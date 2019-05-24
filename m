Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 87B1B29CF8
	for <lists+netdev@lfdr.de>; Fri, 24 May 2019 19:27:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731977AbfEXR1s (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 May 2019 13:27:48 -0400
Received: from dispatch1-us1.ppe-hosted.com ([148.163.129.52]:48712 "EHLO
        dispatch1-us1.ppe-hosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1731958AbfEXR1s (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 May 2019 13:27:48 -0400
X-Virus-Scanned: Proofpoint Essentials engine
Received: from webmail.solarflare.com (webmail.solarflare.com [12.187.104.26])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mx1-us4.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTPS id 883C9800089;
        Fri, 24 May 2019 17:27:45 +0000 (UTC)
Received: from [10.17.20.203] (10.17.20.203) by ocex03.SolarFlarecom.com
 (10.20.40.36) with Microsoft SMTP Server (TLS) id 15.0.1395.4; Fri, 24 May
 2019 10:27:40 -0700
Subject: Re: [PATCH v3 net-next 0/3] flow_offload: Re-add per-action
 statistics
To:     Jakub Kicinski <jakub.kicinski@netronome.com>
CC:     Jamal Hadi Salim <jhs@mojatatu.com>, Jiri Pirko <jiri@resnulli.us>,
        "Pablo Neira Ayuso" <pablo@netfilter.org>,
        David Miller <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        "Andy Gospodarek" <andy@greyhouse.net>,
        Michael Chan <michael.chan@broadcom.com>,
        Vishal Kulkarni <vishal@chelsio.com>
References: <9804a392-c9fd-8d03-7900-e01848044fea@solarflare.com>
 <20190522152001.436bed61@cakuba.netronome.com>
 <fa8a9bde-51c1-0418-5f1b-5af28c4a67c1@mojatatu.com>
 <20190523091154.73ec6ccd@cakuba.netronome.com>
 <1718a74b-3684-0160-466f-04495be5f0ca@solarflare.com>
 <20190523102513.363c2557@cakuba.netronome.com>
 <bf4c9a41-ea81-4d87-2731-372e93f8d53d@solarflare.com>
 <1506061d-6ced-4ca2-43fa-09dad30dc7e6@solarflare.com>
 <20190524100329.4e1f0ce4@cakuba.netronome.com>
From:   Edward Cree <ecree@solarflare.com>
Message-ID: <355202da-6c69-1034-eb29-e03edfe0fe2c@solarflare.com>
Date:   Fri, 24 May 2019 18:27:39 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <20190524100329.4e1f0ce4@cakuba.netronome.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Content-Language: en-GB
X-Originating-IP: [10.17.20.203]
X-TM-AS-Product-Ver: SMEX-12.5.0.1300-8.5.1010-24634.005
X-TM-AS-Result: No-2.351800-4.000000-10
X-TMASE-MatchedRID: zGP2F0O7j/vmLzc6AOD8DfHkpkyUphL9B4Id7CiQcz9/Z0SyQdcmEOph
        8zS0iA+p+KorrBfM6XeqXAcmxyWE1TR43n0ulJJBwY28o+cGA5rIA07iVUpi2xA8kNzNeyM+Il2
        Yw4siuJQ1+FbwCpLVjNyO08Nryc0cQ/zBhy7ptN4ZSUX8zcPGn0xAi7xkncUqsp3MDWRc+JhlWG
        AuNI6SxpCNI3ki9tiCUzF6SznhnLTtwKI0w5dMrZ4CIKY/Hg3AcmfM3DjaQLHEQdG7H66TyJ8TM
        nmE+d0ZdMj7GxkDom3AY2JceLhtqRgpYCBjLDE5wY1gWMkPa5ye7Pn80/rNR/rIbf9oiV+Je/r4
        VlMlGUFkMj1HJ8se5dq99md0N7ZW1DXsKeBNv04EqZlWBkJWd7MZNZFdSWvHG2wlTHLNY1JWXGv
        UUmKP2w==
X-TM-AS-User-Approved-Sender: No
X-TM-AS-User-Blocked-Sender: No
X-TMASE-Result: 10--2.351800-4.000000
X-TMASE-Version: SMEX-12.5.0.1300-8.5.1010-24634.005
X-MDID: 1558718867-ZeDgYwOsosh3
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 24/05/2019 18:03, Jakub Kicinski wrote:
> On Fri, 24 May 2019 14:57:24 +0100, Edward Cree wrote:
>> Argh, there's a problem: an action doesn't have a (directly) associated
>>  block, and all the TC offload machinery nowadays is built around blocks.
>> Since this action might have been used in _any_ block (and afaik there's
>>  no way, from the action, to find which) we'd have to make callbacks on
>>  _every_ block in the system, which sounds like it'd perform even worse
>>  than the rule-dumping approach.
>> Any ideas?
> Simplest would be to keep a list of offloaders per action, but maybe
> something more clever would appear as one rummages through the code.
Problem with that is where to put the list heads; you'd need something that
 was allocated per action x block, for those blocks on which at least one
 offloader handled the rule (in_hw_count > 0).
Then you'd also have to update that when a driver bound/unbound from a
 block (fl_reoffload() time).
Best I can think of is keeping the cls_flower.rule allocated in
 fl_hw_replace_filter() around instead of immediately freeing it, and
 having a list_head in each flow_action_entry.  But that really looks like
 an overcomplicated mess.
TBH I'm starting to wonder if just calling all tc blocks in existence is
 really all that bad.  Is there a plausible use case with huge numbers of
 bound blocks?

-Ed

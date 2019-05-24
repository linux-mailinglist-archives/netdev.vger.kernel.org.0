Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9BC1729892
	for <lists+netdev@lfdr.de>; Fri, 24 May 2019 15:09:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2403862AbfEXNJO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 May 2019 09:09:14 -0400
Received: from dispatch1-us1.ppe-hosted.com ([67.231.154.164]:43442 "EHLO
        dispatch1-us1.ppe-hosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2391193AbfEXNJO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 May 2019 09:09:14 -0400
X-Virus-Scanned: Proofpoint Essentials engine
Received: from webmail.solarflare.com (webmail.solarflare.com [12.187.104.26])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mx1-us3.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTPS id 680486C0075;
        Fri, 24 May 2019 13:09:12 +0000 (UTC)
Received: from [10.17.20.203] (10.17.20.203) by ocex03.SolarFlarecom.com
 (10.20.40.36) with Microsoft SMTP Server (TLS) id 15.0.1395.4; Fri, 24 May
 2019 06:09:06 -0700
From:   Edward Cree <ecree@solarflare.com>
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
Message-ID: <bf4c9a41-ea81-4d87-2731-372e93f8d53d@solarflare.com>
Date:   Fri, 24 May 2019 14:09:05 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <20190523102513.363c2557@cakuba.netronome.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Content-Language: en-GB
X-Originating-IP: [10.17.20.203]
X-TM-AS-Product-Ver: SMEX-12.5.0.1300-8.5.1010-24634.005
X-TM-AS-Result: No-8.691200-4.000000-10
X-TMASE-MatchedRID: 6otD/cJAac3mLzc6AOD8DfHkpkyUphL9V447DNvw38YgJFjkm8DYRcGZ
        VQO4VoaxcpuE9m9Vk2YfD8YWt0BqVs8p3j7ZoQuIboe6sMfg+k+MhbTsXysU35m3TxN83Lo4kM0
        ymMa7UzAYzGbvuRy4Hjv41pZeNUOjrjaWIU+gleQsYOarN8c4H0yQ5fRSh265UCgEErrUGFyoxn
        iI8qHturYIn04efCagK+Onc40J9wanjrTPjSfOH/RUId35VCIeEAImHgFYA95+SLLtNOiBhoY19
        HAB6MS1OfsNoyaCQlgmDL47Qq7glFAt1NMaw8PUCbqZbMjTXcd1BfUeU1jjBFZRFNSNY+lSo8WM
        kQWv6iVJeFvFlVDkf46HM5rqDwqtr/eq4voHbDqeommLt71u2KwXwl48xfHfw7kxPXUGMxHSRmH
        ot0nuxEMMprcbiest
X-TM-AS-User-Approved-Sender: No
X-TM-AS-User-Blocked-Sender: No
X-TMASE-Result: 10--8.691200-4.000000
X-TMASE-Version: SMEX-12.5.0.1300-8.5.1010-24634.005
X-MDID: 1558703353-YfhUPVkccm9v
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 23/05/2019 18:25, Jakub Kicinski wrote:
> Whether it's on you to fix this is debatable :) Since you're diving
> into actions and adding support for shared ones, I'd say it's time to
> rectify the situation.
>
> Let's look at it this way - if you fix the RTM_GETACTION you will
> necessarily add the cookie and all the other stuff you need in your
> upcoming driver :)
Yes, but then I don't have an upstream user for RTM_GETACTION offload!
I'd need to teach an existing driver to look up counters by action
 cookie, which would probably mean a hashtable, a bunch of locking and
 lifetime rules... not something I'm comfortable doing in someone else's
 driver that I don't know the innards of and probably don't have
 hardware to test on.

I'll put together an RFC patch, anyway, and maybe some other driver
 maintainer (hint, hint!) will follow up with a user ;-)
Should it be a new entry in enum tc_setup_type (TC_SETUP_ACTION), or in
 enum tc_fl_command (TC_CLSFLOWER_GETACTION)?  I'd imagine the former as
 we want this to (a) be generic beyond just flower and perhaps also (b)
 support creating and deleting actions as well (not just dumping them).

-Ed

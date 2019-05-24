Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C046529984
	for <lists+netdev@lfdr.de>; Fri, 24 May 2019 15:57:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2403920AbfEXN5c (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 May 2019 09:57:32 -0400
Received: from dispatch1-us1.ppe-hosted.com ([67.231.154.164]:34934 "EHLO
        dispatch1-us1.ppe-hosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2403843AbfEXN5c (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 May 2019 09:57:32 -0400
X-Virus-Scanned: Proofpoint Essentials engine
Received: from webmail.solarflare.com (webmail.solarflare.com [12.187.104.26])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mx1-us5.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTPS id 9265758005C;
        Fri, 24 May 2019 13:57:30 +0000 (UTC)
Received: from [10.17.20.203] (10.17.20.203) by ocex03.SolarFlarecom.com
 (10.20.40.36) with Microsoft SMTP Server (TLS) id 15.0.1395.4; Fri, 24 May
 2019 06:57:26 -0700
Subject: Re: [PATCH v3 net-next 0/3] flow_offload: Re-add per-action
 statistics
From:   Edward Cree <ecree@solarflare.com>
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
Message-ID: <1506061d-6ced-4ca2-43fa-09dad30dc7e6@solarflare.com>
Date:   Fri, 24 May 2019 14:57:24 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <bf4c9a41-ea81-4d87-2731-372e93f8d53d@solarflare.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Content-Language: en-GB
X-Originating-IP: [10.17.20.203]
X-TM-AS-Product-Ver: SMEX-12.5.0.1300-8.5.1010-24634.005
X-TM-AS-Result: No-2.839000-4.000000-10
X-TMASE-MatchedRID: +c13yJDs903mLzc6AOD8DfHkpkyUphL9pvDLLlsAH/35+tteD5RzhWly
        s1PDhWLoTKDv7+Pf3CiXeWFOOXYKatxuSf/ttdernO9786xxbgMCC8zqHvcG2hLf1vz7ecPHvRM
        LCSp4+aSqkPUgG0TUx6BVvEjzNBpCv1l2Uvx6idpcO65jrNll89mzcdRxL+xwKrauXd3MZDWXWn
        DYfJ45u0wA2GOR7E6Wya7X0ZiFixViO1iLslC7Pkhm1R8Wa5vJEURIKb/H1pQQvKBp4eJutA+lv
        j9cMpxbWul+nlS/WFVZu+ZwJwBhFw==
X-TM-AS-User-Approved-Sender: No
X-TM-AS-User-Blocked-Sender: No
X-TMASE-Result: 10--2.839000-4.000000
X-TMASE-Version: SMEX-12.5.0.1300-8.5.1010-24634.005
X-MDID: 1558706251-6T8RWGXfJldr
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 24/05/2019 14:09, Edward Cree wrote:
> I'll put together an RFC patch, anyway
Argh, there's a problem: an action doesn't have a (directly) associated
 block, and all the TC offload machinery nowadays is built around blocks.
Since this action might have been used in _any_ block (and afaik there's
 no way, from the action, to find which) we'd have to make callbacks on
 _every_ block in the system, which sounds like it'd perform even worse
 than the rule-dumping approach.
Any ideas?

-Ed

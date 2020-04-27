Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C1ED91BA670
	for <lists+netdev@lfdr.de>; Mon, 27 Apr 2020 16:32:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728018AbgD0OcF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Apr 2020 10:32:05 -0400
Received: from dispatch1-us1.ppe-hosted.com ([148.163.129.52]:33370 "EHLO
        dispatch1-us1.ppe-hosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727917AbgD0OcD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Apr 2020 10:32:03 -0400
Received: from mx1-us1.ppe-hosted.com (unknown [10.7.65.60])
        by dispatch1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTP id B59D7600CC;
        Mon, 27 Apr 2020 14:32:02 +0000 (UTC)
Received: from us4-mdac16-10.ut7.mdlocal (unknown [10.7.65.180])
        by mx1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTP id B397C2009A;
        Mon, 27 Apr 2020 14:32:02 +0000 (UTC)
X-Virus-Scanned: Proofpoint Essentials engine
Received: from mx1-us1.ppe-hosted.com (unknown [10.7.66.37])
        by mx1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTPS id 287A21C005C;
        Mon, 27 Apr 2020 14:32:02 +0000 (UTC)
Received: from webmail.solarflare.com (uk.solarflare.com [193.34.186.16])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mx1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTPS id 6FB62B40085;
        Mon, 27 Apr 2020 14:32:01 +0000 (UTC)
Received: from [10.17.20.203] (10.17.20.203) by ukex01.SolarFlarecom.com
 (10.17.10.4) with Microsoft SMTP Server (TLS) id 15.0.1395.4; Mon, 27 Apr
 2020 15:31:52 +0100
Subject: Re: [PATCH net] net: flow_offload: skip hw stats check for
 FLOW_ACTION_HW_STATS_DISABLED
To:     Jiri Pirko <jiri@resnulli.us>,
        Pablo Neira Ayuso <pablo@netfilter.org>
CC:     Florian Westphal <fw@strlen.de>, <netfilter-devel@vger.kernel.org>,
        <davem@davemloft.net>, <netdev@vger.kernel.org>, <kuba@kernel.org>
References: <20200420090505.pr6wsunozfh7afaj@salvia>
 <20200420091302.GB6581@nanopsycho.orion>
 <20200420100341.6qehcgz66wq4ysax@salvia>
 <20200420115210.GE6581@nanopsycho.orion>
 <3980eea4-18d8-5e62-2d6d-fce0a7e7ed4c@solarflare.com>
 <20200420123915.nrqancwjb7226l7e@salvia>
 <20200420134826.GH6581@nanopsycho.orion>
 <20200420135754.GD32392@breakpoint.cc>
 <20200420141422.GK6581@nanopsycho.orion>
 <20200420191832.ppxjjebls2idrshh@salvia>
 <20200422183701.GN6581@nanopsycho.orion>
From:   Edward Cree <ecree@solarflare.com>
Message-ID: <4f242df0-26c1-472c-c526-557ff50ef1e0@solarflare.com>
Date:   Mon, 27 Apr 2020 15:31:48 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
MIME-Version: 1.0
In-Reply-To: <20200422183701.GN6581@nanopsycho.orion>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Content-Language: en-GB
X-Originating-IP: [10.17.20.203]
X-ClientProxiedBy: ocex03.SolarFlarecom.com (10.20.40.36) To
 ukex01.SolarFlarecom.com (10.17.10.4)
X-TM-AS-Product-Ver: SMEX-12.5.0.1300-8.5.1020-25380.003
X-TM-AS-Result: No-1.774400-8.000000-10
X-TMASE-MatchedRID: QfHZjzml1E+8rRvefcjeTfZvT2zYoYOwC/ExpXrHizwRGC0rW8q1XRSF
        klSqkKH16oKYjrRG03P3zUUW+ZW64VZKqE+UYHzflrJlvZQ8eOt6i696PjRPiOQ45nVtPqmxTx7
        y4qsCFygSZmqWTdxLdbenQkLW/KtRmUQSrI/466u0pXj1GkAfe34JYJwdJw4T+nlefiwGml8dKx
        VVk54kLWfP+2v5Wsda+GEOUem9z7v4miWUEaTQPolSWYvdSPSYPJb7oABYhT+6Gxh0eXo7azvdJ
        9MevfKV585VzGMOFzAQVjqAOZ5cjQtuKBGekqUpm+MB6kaZ2g73+0/pvjwLHaiJ987TeG81YUkI
        WoEEDKdAdW07AQr7ObnUYSVBJlPhHGIhtzGYFDSMvsq7x5mOx7Q5IS/qa0OXsHzMtm6WwzGHzGT
        HoCwyHhlNKSp2rPkW5wiX7RWZGYs2CWDRVNNHuzflzkGcoK72
X-TM-AS-User-Approved-Sender: Yes
X-TM-AS-User-Blocked-Sender: No
X-TMASE-Result: 10--1.774400-8.000000
X-TMASE-Version: SMEX-12.5.0.1300-8.5.1020-25380.003
X-MDID: 1587997922-XIjmudsvmhIa
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 22/04/2020 19:37, Jiri Pirko wrote:
> "Any" can't be "don't care". TC User expects stats. That's default.
>
> Let's have "don't care" bit only and set it for
> ethtool/netfilter/flowtable. Don't change any. Teach the drivers to deal
> with "don't care", most probably using the default checker.
I think the right solution is either this, or the semantically-similar
 approach of "0 means don't care, we have a bit for disabled, and ANY
 (the TC default) is "all the bits except disabled", i.e.
 DELAYED | IMMEDIATE.  That seems slightly cleaner to me, as then non-
 zero settings are always "here is a bitmask of options, driver may
 choose any of them".  (And 0 differs from DELAYED | IMMEDIATE | DISABLED
 only in that if new bits are added to kernel, 0 includes them.)
And of course either way the TC uAPI needs to be able to specify the
 new "don't care" option.

-ed

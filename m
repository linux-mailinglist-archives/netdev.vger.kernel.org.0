Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 86A06175F33
	for <lists+netdev@lfdr.de>; Mon,  2 Mar 2020 17:07:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727159AbgCBQHy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Mar 2020 11:07:54 -0500
Received: from dispatch1-us1.ppe-hosted.com ([67.231.154.164]:39018 "EHLO
        dispatch1-us1.ppe-hosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726451AbgCBQHx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 2 Mar 2020 11:07:53 -0500
X-Virus-Scanned: Proofpoint Essentials engine
Received: from webmail.solarflare.com (uk.solarflare.com [193.34.186.16])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mx1-us4.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTPS id 4CD13140073;
        Mon,  2 Mar 2020 16:07:51 +0000 (UTC)
Received: from [10.17.20.203] (10.17.20.203) by ukex01.SolarFlarecom.com
 (10.17.10.4) with Microsoft SMTP Server (TLS) id 15.0.1395.4; Mon, 2 Mar 2020
 16:07:40 +0000
Subject: Re: [patch net-next 00/10] net: allow user specify TC filter HW stats
 type
To:     Jiri Pirko <jiri@resnulli.us>,
        Pablo Neira Ayuso <pablo@netfilter.org>
CC:     Jamal Hadi Salim <jhs@mojatatu.com>,
        Jakub Kicinski <kuba@kernel.org>, <netdev@vger.kernel.org>,
        <davem@davemloft.net>, <saeedm@mellanox.com>, <leon@kernel.org>,
        <michael.chan@broadcom.com>, <vishal@chelsio.com>,
        <jeffrey.t.kirsher@intel.com>, <idosch@mellanox.com>,
        <aelior@marvell.com>, <peppe.cavallaro@st.com>,
        <alexandre.torgue@st.com>, <xiyou.wangcong@gmail.com>,
        <mlxsw@mellanox.com>, Marian Pritsak <marianp@mellanox.com>
References: <20200221095643.6642-1-jiri@resnulli.us>
 <20200221102200.1978e10e@kicinski-fedora-PC1C0HJN>
 <20200222063829.GB2228@nanopsycho>
 <b6c5f811-2313-14a0-75c4-96d29196e7e6@solarflare.com>
 <20200224131101.GC16270@nanopsycho>
 <9cd1e555-6253-1856-f21d-43323eb77788@mojatatu.com>
 <20200224162521.GE16270@nanopsycho>
 <b93272f2-f76c-10b5-1c2a-6d39e917ffd6@mojatatu.com>
 <20200225162203.GE17869@nanopsycho> <20200228195909.dfdhifnjy4cescic@salvia>
 <20200229080120.GP26061@nanopsycho>
From:   Edward Cree <ecree@solarflare.com>
Message-ID: <b05ffcad-d3ba-7327-54bb-d346f5303ce2@solarflare.com>
Date:   Mon, 2 Mar 2020 16:07:35 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
MIME-Version: 1.0
In-Reply-To: <20200229080120.GP26061@nanopsycho>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Content-Language: en-GB
X-Originating-IP: [10.17.20.203]
X-ClientProxiedBy: ocex03.SolarFlarecom.com (10.20.40.36) To
 ukex01.SolarFlarecom.com (10.17.10.4)
X-TM-AS-Product-Ver: SMEX-12.5.0.1300-8.5.1020-25264.003
X-TM-AS-Result: No-7.126200-8.000000-10
X-TMASE-MatchedRID: nVQUmLJJeybmLzc6AOD8DfHkpkyUphL96y7Z+mBhUl0Tvdh6VFADyc9x
        vC1/5d4Z84NB8AEyFvr9LeU/rVo3pZTUoGfImkdk/ccgt/EtX/1Dmn7kzuSuKdfVxEPp7g/kR5T
        vx+kKh7CSmxTZw6MyoVDfyYbqflqTOJQuSr/cFG7rOLyP6vXu3X0tCKdnhB58ZYJ9vPJ1vSDUCj
        MSsLl1x+TCMddcL/gjsjvNV98mpPNjCeJDJ8IVkNrikcC6stYqQ0TGvc9gYoM7Q9p2gghMsS12k
        o7AvGvNftwZ3X11IV0=
X-TM-AS-User-Approved-Sender: Yes
X-TM-AS-User-Blocked-Sender: No
X-TMASE-Result: 10--7.126200-8.000000
X-TMASE-Version: SMEX-12.5.0.1300-8.5.1020-25264.003
X-MDID: 1583165272-nJLE198ELXn9
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 29/02/2020 08:01, Jiri Pirko wrote:
> Fri, Feb 28, 2020 at 08:59:09PM CET, pablo@netfilter.org wrote:
>> Something like the sketch patch that I'm attaching?
> But why? Actions are separate entities, with separate counters. The
> driver is either able to offload that or not. Up to the driver to
> abstract this out.
+1

If any of this "fake up a counter action" stuff is common to several
 drivers, we could maybe have some library functions to help them with
 it, but the tc<->driver API shouldn't change (since the change adds
 no expressiveness).

-ed

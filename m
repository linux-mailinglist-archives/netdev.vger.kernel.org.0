Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7563916A507
	for <lists+netdev@lfdr.de>; Mon, 24 Feb 2020 12:38:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727423AbgBXLif (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Feb 2020 06:38:35 -0500
Received: from dispatch1-us1.ppe-hosted.com ([67.231.154.164]:35034 "EHLO
        dispatch1-us1.ppe-hosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726778AbgBXLie (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Feb 2020 06:38:34 -0500
X-Virus-Scanned: Proofpoint Essentials engine
Received: from webmail.solarflare.com (uk.solarflare.com [193.34.186.16])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mx1-us4.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTPS id 95260B40066;
        Mon, 24 Feb 2020 11:38:32 +0000 (UTC)
Received: from [10.17.20.203] (10.17.20.203) by ukex01.SolarFlarecom.com
 (10.17.10.4) with Microsoft SMTP Server (TLS) id 15.0.1395.4; Mon, 24 Feb
 2020 11:38:23 +0000
Subject: Re: [patch net-next 00/10] net: allow user specify TC filter HW stats
 type
To:     Jiri Pirko <jiri@resnulli.us>, Jakub Kicinski <kuba@kernel.org>
CC:     <netdev@vger.kernel.org>, <davem@davemloft.net>,
        <saeedm@mellanox.com>, <leon@kernel.org>,
        <michael.chan@broadcom.com>, <vishal@chelsio.com>,
        <jeffrey.t.kirsher@intel.com>, <idosch@mellanox.com>,
        <aelior@marvell.com>, <peppe.cavallaro@st.com>,
        <alexandre.torgue@st.com>, <jhs@mojatatu.com>,
        <xiyou.wangcong@gmail.com>, <pablo@netfilter.org>,
        <mlxsw@mellanox.com>
References: <20200221095643.6642-1-jiri@resnulli.us>
 <20200221102200.1978e10e@kicinski-fedora-PC1C0HJN>
 <20200222063829.GB2228@nanopsycho>
From:   Edward Cree <ecree@solarflare.com>
Message-ID: <b6c5f811-2313-14a0-75c4-96d29196e7e6@solarflare.com>
Date:   Mon, 24 Feb 2020 11:38:20 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
MIME-Version: 1.0
In-Reply-To: <20200222063829.GB2228@nanopsycho>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Content-Language: en-GB
X-Originating-IP: [10.17.20.203]
X-ClientProxiedBy: ocex03.SolarFlarecom.com (10.20.40.36) To
 ukex01.SolarFlarecom.com (10.17.10.4)
X-TM-AS-Product-Ver: SMEX-12.5.0.1300-8.5.1020-25250.003
X-TM-AS-Result: No-4.602700-8.000000-10
X-TMASE-MatchedRID: u7Yf2n7Ca/3mLzc6AOD8DfHkpkyUphL9MYl7SZFEwUZsMPuLZB/IRxNM
        UypRFEH0LASAR59ZE9v2BGOumBZTulcQrQ0wAgM+SVHYMTQ1F1r4nOjGtd/rn0eRNQFi4zevmpY
        YVVDsQzCc8Hl/+cxY+YslHi31+rVcmw72jSYg2ikcLuEDP+gqcggqPpbA7sp1TmCoNkYjqsDRL5
        O8Y5SCovd+Yt8jQKDv8rjtDXpvGJSCVrCmUEKpNhlJRfzNw8af9e5am3m57X0da1Vk3RqxOBx7q
        i+TpcKI592sjG0JWVuKgppSTR43KYuNJ+oz9dLcwRTopFgZxh0yc6SHgkKAipsoi2XrUn/JmTDw
        p0zM3zoqtq5d3cxkNXEz3ZC7MxyUy3zKBDrIl5r/Lc4tFJU54/NE2o7GD3Mt74aqa5JQRiIRZxQ
        qt4U888QdILowxk2FAFC1GhXrh4lBRQ6X5GL8v9yS5IITWzgwBsRAh8WmTAcG2WAWHb2qekrMHC
        7kmmSWc5S6hNczuvhDDKa3G4nrLQ==
X-TM-AS-User-Approved-Sender: Yes
X-TM-AS-User-Blocked-Sender: No
X-TMASE-Result: 10--4.602700-8.000000
X-TMASE-Version: SMEX-12.5.0.1300-8.5.1020-25250.003
X-MDID: 1582544313-o7NH65dVtZDs
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 22/02/2020 06:38, Jiri Pirko wrote:
> Fri, Feb 21, 2020 at 07:22:00PM CET, kuba@kernel.org wrote:
>> Hmm, but the statistics are on actions, it feels a little bit like we
>> are perpetuating the mistake of counting on filters here.
> You are right, the stats in tc are per-action. However, in both mlxsw
> and mlx5, the stats are per-filter. What hw_stats does is that it
> basically allows the user to set the type for all the actions in the
> filter at once.
>
> Could you imagine a usecase that would use different HW stats type for
> different actions in one action-chain?
Potentially a user could only want stats on one action and disable them
 on another.  For instance, if their action chain does delivery to the
 'customer' and also mirrors the packets for monitoring, they might only
 want stats on the first delivery (e.g. for billing) and not want to
 waste a counter on the mirror.

> Plus, if the fine grained setup is ever needed, the hw_stats could be in
> future easilyt extended to be specified per-action too overriding
> the per-filter setup only for specific action. What do you think?
I think this is improper; the stats type should be defined per-action in
 the uapi, even if userland initially only has UI to set it across the
 entire filter.  (I imagine `tc action` would grow the corresponding UI
 pretty quickly.)  Then on the driver side, you must determine whether
 your hardware can support the user's request, and if not, return an
 appropriate error code.

Let's try not to encourage people (users, future HW & driver developers)
 to keep thinking of stats as per-filter entities.

-ed

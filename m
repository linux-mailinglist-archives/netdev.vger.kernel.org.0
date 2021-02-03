Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BBEF430D473
	for <lists+netdev@lfdr.de>; Wed,  3 Feb 2021 08:57:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232382AbhBCH5E (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Feb 2021 02:57:04 -0500
Received: from hqnvemgate26.nvidia.com ([216.228.121.65]:17015 "EHLO
        hqnvemgate26.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231929AbhBCH5A (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 3 Feb 2021 02:57:00 -0500
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate26.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B601a57240000>; Tue, 02 Feb 2021 23:56:20 -0800
Received: from reg-r-vrt-019-180.mtr.labs.mlnx (172.20.145.6) by
 HQMAIL107.nvidia.com (172.20.187.13) with Microsoft SMTP Server (TLS) id
 15.0.1473.3; Wed, 3 Feb 2021 07:56:16 +0000
Date:   Wed, 3 Feb 2021 09:56:05 +0200
From:   Paul Blakey <paulb@nvidia.com>
To:     Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
CC:     Jiri Pirko <jiri@nvidia.com>, Roi Dayan <roid@nvidia.com>,
        Yossi Kuperman <yossiku@nvidia.com>,
        Oz Shlomo <ozsh@nvidia.com>, <netdev@vger.kernel.org>,
        David Miller <davem@davemloft.net>,
        Aaron Conole <aconole@redhat.com>,
        "Zhike Wang" <wangzhike@jd.com>, Rony Efraim <ronye@nvidia.com>,
        <nst-kernel@redhat.com>, John Hurley <john.hurley@netronome.com>,
        "Simon Horman" <simon.horman@netronome.com>,
        Justin Pettit <jpettit@ovn.org>
Subject: Re: [PATCH iproute2/net-next] tc: flower: Add support for ct_state
 reply flag
In-Reply-To: <20210202124154.GF3288@horizon.localdomain>
Message-ID: <1d2e3271-45e8-51f7-af53-5d14dc12c4f@nvidia.com>
References: <1612268682-29525-1-git-send-email-paulb@nvidia.com> <20210202124154.GF3288@horizon.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
X-Originating-IP: [172.20.145.6]
X-ClientProxiedBy: HQMAIL101.nvidia.com (172.20.187.10) To
 HQMAIL107.nvidia.com (172.20.187.13)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1612338980; bh=DniAnUvNPOEbxpWom8yr/jVDjjckgBYNvu6RGA9k0lo=;
        h=Date:From:To:CC:Subject:In-Reply-To:Message-ID:References:
         MIME-Version:Content-Type:X-Originating-IP:X-ClientProxiedBy;
        b=mgm7Q+e5zke+wZIHx247/JxnhpjJS+5yR1mlgdsDbVB7XI/O8AS+09d6NtqPCCGWO
         uR28vHvSAjkNExGWIFQK9dfIC+V5MIiFSzlY5tpX5gx+j0RK8BlClOrRscOcsmWuqN
         9UslSQT2ReOA3YSrKfremDnpR+G79YOaB0B3nKbLDJX/81eeRK2xr6jsOTlnwsH1KH
         SGSbMH61ClChGXQeJrEM2x9/MXP5kgLXUc4eTavzDb1ABGC9LcE2aiKMuqhnIH9Ibz
         FA8Y5qzcn1p2UZursyHzesfxl37XSqeeBJCvLIrGqfO40iOMW0s5jiJsRBU27R+Z9J
         Gg9g14f9I1J/A==
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On Tue, 2 Feb 2021, Marcelo Ricardo Leitner wrote:

> On Tue, Feb 02, 2021 at 02:24:42PM +0200, Paul Blakey wrote:
> > Matches on conntrack rpl ct_state.
> > 
> > Example:
> > $ tc filter add dev ens1f0_0 ingress prio 1 chain 1 proto ip flower \
> >   ct_state +trk+est+rpl \
> >   action mirred egress redirect dev ens1f0_1
> > $ tc filter add dev ens1f0_1 ingress prio 1 chain 1 proto ip flower \
> >   ct_state +trk+est-rpl \
> >   action mirred egress redirect dev ens1f0_0
> > 
> > Signed-off-by: Paul Blakey <paulb@nvidia.com>
> > ---
> >  man/man8/tc-flower.8 | 2 ++
> >  tc/f_flower.c        | 1 +
> >  2 files changed, 3 insertions(+)
> 
> iproute has a header copy, include/uapi/linux/pkt_cls.h.
> I think it needs updating as well.
> 
>   Marcelo
> 

Hi,

Commit 1e6190218050 ("Update kernel headers") from 02/02/2021 updated the
headers to include the relevant flag.

Thanks,
Paul.



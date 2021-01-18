Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8C24B2FA971
	for <lists+netdev@lfdr.de>; Mon, 18 Jan 2021 19:59:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2407913AbhARS55 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Jan 2021 13:57:57 -0500
Received: from esa.microchip.iphmx.com ([68.232.154.123]:44348 "EHLO
        esa.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2393759AbhARS5p (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 Jan 2021 13:57:45 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1610996264; x=1642532264;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=8xW+Ib1Q2UKnK0aGyXk2bqJxeinADOf0EJFfNV6Zz5k=;
  b=OZ0RDIVGidp4ciskgVVwgu9F09U9HioiOAL/d0NxVi2WuHHPfNmJL80Q
   rrs0ACgJnKMnZC2rH4gVbNbU9HfzqKYdQlECFVBsAJURmPobhpnfMDcXP
   mxHD+aCONZAOVh24bYGcPxFZKatE4iV+6EA+2Y65BYTnDyQzMxpDQZrQZ
   YfH9m/dGajtDl0zh50oHs0ottUyqAmGRVbXNcUcwy3NNEZVaHPs4pCtgk
   yj1LOx9Wax2S0NM8ulWkrHEZj22kNQZ9CIHSpVJxMRvuxGILtYbqF01Tn
   YRobik+FGDbWdiiT0dZwYOKB5+YoQQVGZnhgRwciEPZHF0xEbyffiPCT9
   A==;
IronPort-SDR: zkf4OhDYE5w4kAjlcSrjPOGaOeF3hskz86dXFAwfhAZReZa2lk5TRBnT7px5h33ot4wlz2bZxR
 d07l6EZYUMrhRNlu04pf9s99OzRPpGWwvV0ClKIIPu9DLPGRl6j6MjBNh3no1/lj2/L+x+DOVd
 GFuml9uCHTZW0NUHsg8hB99Mcyc97EDlFGI5E6w55eN+8meQccpPsrMMgbkEfkjPuaIhB4w0QF
 kNNTStimmQAIMQZgEdkbSV56zOIP1kCqoo6Pl63aa2KKP02DfraobMB//llKw2UZlwPLlVkNmB
 9Dw=
X-IronPort-AV: E=Sophos;i="5.79,357,1602572400"; 
   d="scan'208";a="40840029"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa6.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 18 Jan 2021 11:56:20 -0700
Received: from chn-vm-ex03.mchp-main.com (10.10.85.151) by
 chn-vm-ex02.mchp-main.com (10.10.85.144) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Mon, 18 Jan 2021 11:56:19 -0700
Received: from localhost (10.10.115.15) by chn-vm-ex03.mchp-main.com
 (10.10.85.151) with Microsoft SMTP Server id 15.1.1979.3 via Frontend
 Transport; Mon, 18 Jan 2021 11:56:19 -0700
Date:   Mon, 18 Jan 2021 19:56:18 +0100
From:   Horatiu Vultur <horatiu.vultur@microchip.com>
To:     Rasmus Villemoes <rasmus.villemoes@prevas.dk>
CC:     Roopa Prabhu <roopa@nvidia.com>,
        Nikolay Aleksandrov <nikolay@nvidia.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Andrew Lunn <andrew@lunn.ch>,
        <bridge@lists.linux-foundation.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH net] net: mrp: use stp state as substitute for
 unimplemented mrp state
Message-ID: <20210118185618.75h45rjf6qqberic@soft-dev3.localdomain>
References: <20210118181319.25419-1-rasmus.villemoes@prevas.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
In-Reply-To: <20210118181319.25419-1-rasmus.villemoes@prevas.dk>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The 01/18/2021 19:13, Rasmus Villemoes wrote:
> 

Hi Rasmus,

> When using MRP with hardware that does understand the concept of
> blocked or forwarding ports, but not the full MRP offload, we
> currently fail to tell the hardware what state it should put the port
> in when the ring is closed - resulting in a ring of forwarding ports
> and all the trouble that comes with that.

But why don't you implement the SWITCHDEV_ATTR_ID_MRP_PORT_STATE in your
driver? if already the HW understands the concept of block or forwarding?

> 
> Signed-off-by: Rasmus Villemoes <rasmus.villemoes@prevas.dk>
> ---
> 
> I don't really understand why SWITCHDEV_ATTR_ID_MRP_PORT_STATE even
> has to exist seperately from SWITCHDEV_ATTR_ID_PORT_STP_STATE, and
> it's hard to tell what the difference might be since no kernel code
> implements the former.

The reason was to stay away from STP, because you can't run these two
protocols at the same time. Even though in SW, we reuse port's state.
In our driver(which is not upstreamed), we currently implement
SWITCHDEV_ATTR_ID_MRP_PORT_STATE and just call the
SWITCHDEV_ATTR_ID_PORT_STP_STATE.

> 
>  net/bridge/br_mrp_switchdev.c | 18 ++++++++++++++++++
>  1 file changed, 18 insertions(+)
> 
> diff --git a/net/bridge/br_mrp_switchdev.c b/net/bridge/br_mrp_switchdev.c
> index ed547e03ace1..8a1c7953e57a 100644
> --- a/net/bridge/br_mrp_switchdev.c
> +++ b/net/bridge/br_mrp_switchdev.c
> @@ -180,6 +180,24 @@ int br_mrp_port_switchdev_set_state(struct net_bridge_port *p,
>         int err;
> 
>         err = switchdev_port_attr_set(p->dev, &attr);
> +       if (err == -EOPNOTSUPP) {
> +               attr.id = SWITCHDEV_ATTR_ID_PORT_STP_STATE;
> +               switch (state) {
> +               case BR_MRP_PORT_STATE_DISABLED:
> +               case BR_MRP_PORT_STATE_NOT_CONNECTED:
> +                       attr.u.stp_state = BR_STATE_DISABLED;
> +                       break;
> +               case BR_MRP_PORT_STATE_BLOCKED:
> +                       attr.u.stp_state = BR_STATE_BLOCKING;
> +                       break;
> +               case BR_MRP_PORT_STATE_FORWARDING:
> +                       attr.u.stp_state = BR_STATE_FORWARDING;
> +                       break;
> +               default:
> +                       return err;
> +               };
> +               err = switchdev_port_attr_set(p->dev, &attr);
> +       }
>         if (err && err != -EOPNOTSUPP)
>                 br_warn(p->br, "error setting offload MRP state on port %u(%s)\n",
>                         (unsigned int)p->port_no, p->dev->name);
> --
> 2.23.0
> 

-- 
/Horatiu

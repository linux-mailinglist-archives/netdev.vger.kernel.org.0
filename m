Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 07BB255B268
	for <lists+netdev@lfdr.de>; Sun, 26 Jun 2022 16:14:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234479AbiFZOLv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 26 Jun 2022 10:11:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45928 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230497AbiFZOLv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 26 Jun 2022 10:11:51 -0400
Received: from mail-ej1-x635.google.com (mail-ej1-x635.google.com [IPv6:2a00:1450:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 53F49101FA;
        Sun, 26 Jun 2022 07:11:44 -0700 (PDT)
Received: by mail-ej1-x635.google.com with SMTP id lw20so13964114ejb.4;
        Sun, 26 Jun 2022 07:11:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=poXbOCN9IoB/jszUsadi8cNiKABYkr96dLkZjXwEC3I=;
        b=pQ1kU2KyLLscteODpu2pZR5UQlv0xxtV+U4J7ZS5wK4R8bEj9/PEXDB/IkDxytqHd0
         RlWedsVHwCQ+oUMIMBoAdeNG+ugr9l5Iw45KWvHYz0jrK6UXCN9N1X0rNbLjIyI7lSYv
         QQE0liY4anlBfBDXcPGGaVeYFjWnRaz/72XV5VY+wP7LbGLq4LdAuORhX8kzmFzjntNV
         21GucCZaAHKoL7WBgL8tb3ohDWRjevOfc4iAE0MFnT/baLSS+m2IIdCIyf/cVCCFzv3E
         VWAcLT4O0czG2C0svpjKBrJ7HWd8IFoYXtyH+09hpikZInH/ZgrU2mIsbVgMBchCWBnK
         Cr8A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=poXbOCN9IoB/jszUsadi8cNiKABYkr96dLkZjXwEC3I=;
        b=nCs+Us3iMt/P93ujanTnuyT2gvK35wXQwzAOnZPOYoqfmym/N5xQXnrSpgwbO4SfFH
         ddSOaHkr5HAoCcOmIR4fr7hf44mQ31N+YY1ivM9sxQs7w9Cua82QI9UGqYlPRw/fSh27
         7dfqiHg9UEU+bCH2sGc/5U10SZ1kTdzA6A5fSRi22aibMBXkzrTS057EKUlnYIeFLioV
         +1dMmjuyYzjfkgiieCwMSZZGFvXjAPtaaAXMzp9LDup5Q7Zg5qjJ2hMie7HXUplMIltj
         nu2brQYAHLNmpJUUsvXWOg9n83Uir4d73ZjdNA8NziTWAaOACHpc1EGATufuCF93NOLr
         Y+Qg==
X-Gm-Message-State: AJIora8n4D0fD8FzpbRVb44nz57keSCn5GMT3MHeVjIRY4KHCqFkot9Q
        N40xDyj+np4eIAYf64GToUE=
X-Google-Smtp-Source: AGRyM1u4y11s3WwdGdWPBRqNOU1QbABAJKflnweOsewRrHajNo17f7CG1/wYE/tobFBqdO/TABr8sw==
X-Received: by 2002:a17:906:6416:b0:722:e812:1000 with SMTP id d22-20020a170906641600b00722e8121000mr8570835ejm.275.1656252702264;
        Sun, 26 Jun 2022 07:11:42 -0700 (PDT)
Received: from skbuf ([188.25.231.135])
        by smtp.gmail.com with ESMTPSA id ba29-20020a0564021add00b00435a62d35b5sm5876166edb.45.2022.06.26.07.11.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 26 Jun 2022 07:11:41 -0700 (PDT)
Date:   Sun, 26 Jun 2022 17:11:39 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Horatiu Vultur <horatiu.vultur@microchip.com>
Cc:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        UNGLinuxDriver@microchip.com, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        linux@armlinux.org.uk
Subject: Re: [PATCH net-next 5/8] net: lan966x: Add lag support for lan966x.
Message-ID: <20220626141139.kbwhpgmwzp7rpxgy@skbuf>
References: <20220626130451.1079933-1-horatiu.vultur@microchip.com>
 <20220626130451.1079933-6-horatiu.vultur@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220626130451.1079933-6-horatiu.vultur@microchip.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Horatiu,

Just casually browsing through the patches. A comment below.

On Sun, Jun 26, 2022 at 03:04:48PM +0200, Horatiu Vultur wrote:
> Add link aggregation hardware offload support for lan966x
> 
> Signed-off-by: Horatiu Vultur <horatiu.vultur@microchip.com>
> ---
>  .../net/ethernet/microchip/lan966x/Makefile   |   2 +-
>  .../ethernet/microchip/lan966x/lan966x_lag.c  | 296 ++++++++++++++++++
>  .../ethernet/microchip/lan966x/lan966x_main.h |  28 ++
>  .../microchip/lan966x/lan966x_switchdev.c     |  78 ++++-
>  4 files changed, 388 insertions(+), 16 deletions(-)
>  create mode 100644 drivers/net/ethernet/microchip/lan966x/lan966x_lag.c
> 
> diff --git a/drivers/net/ethernet/microchip/lan966x/Makefile b/drivers/net/ethernet/microchip/lan966x/Makefile
> index fd2e0ebb2427..0c22c86bdaa9 100644
> --- a/drivers/net/ethernet/microchip/lan966x/Makefile
> +++ b/drivers/net/ethernet/microchip/lan966x/Makefile
> @@ -8,4 +8,4 @@ obj-$(CONFIG_LAN966X_SWITCH) += lan966x-switch.o
>  lan966x-switch-objs  := lan966x_main.o lan966x_phylink.o lan966x_port.o \
>  			lan966x_mac.o lan966x_ethtool.o lan966x_switchdev.o \
>  			lan966x_vlan.o lan966x_fdb.o lan966x_mdb.o \
> -			lan966x_ptp.o lan966x_fdma.o
> +			lan966x_ptp.o lan966x_fdma.o lan966x_lag.o
> diff --git a/drivers/net/ethernet/microchip/lan966x/lan966x_lag.c b/drivers/net/ethernet/microchip/lan966x/lan966x_lag.c
> new file mode 100644
> index 000000000000..c721a05d44d2
> --- /dev/null
> +++ b/drivers/net/ethernet/microchip/lan966x/lan966x_lag.c
> @@ -0,0 +1,296 @@
> +// SPDX-License-Identifier: GPL-2.0+
> +
> +#include "lan966x_main.h"
> +
> +static void lan966x_lag_set_aggr_pgids(struct lan966x *lan966x)
> +{
> +	u32 visited = GENMASK(lan966x->num_phys_ports - 1, 0);
> +	int p, lag, i;
> +
> +	/* Reset destination and aggregation PGIDS */
> +	for (p = 0; p < lan966x->num_phys_ports; ++p)
> +		lan_wr(ANA_PGID_PGID_SET(BIT(p)),
> +		       lan966x, ANA_PGID(p));
> +
> +	for (p = PGID_AGGR; p < PGID_SRC; ++p)
> +		lan_wr(ANA_PGID_PGID_SET(visited),
> +		       lan966x, ANA_PGID(p));
> +
> +	/* The visited ports bitmask holds the list of ports offloading any
> +	 * bonding interface. Initially we mark all these ports as unvisited,
> +	 * then every time we visit a port in this bitmask, we know that it is
> +	 * the lowest numbered port, i.e. the one whose logical ID == physical
> +	 * port ID == LAG ID. So we mark as visited all further ports in the
> +	 * bitmask that are offloading the same bonding interface. This way,
> +	 * we set up the aggregation PGIDs only once per bonding interface.
> +	 */
> +	for (p = 0; p < lan966x->num_phys_ports; ++p) {
> +		struct lan966x_port *port = lan966x->ports[p];
> +
> +		if (!port || !port->bond)
> +			continue;
> +
> +		visited &= ~BIT(p);
> +	}
> +
> +	/* Now, set PGIDs for each active LAG */
> +	for (lag = 0; lag < lan966x->num_phys_ports; ++lag) {
> +		struct lan966x_port *port = lan966x->ports[lag];
> +		int num_active_ports = 0;
> +		struct net_device *bond;
> +		unsigned long bond_mask;
> +		u8 aggr_idx[16];
> +
> +		if (!port || !port->bond || (visited & BIT(lag)))
> +			continue;
> +
> +		bond = port->bond;
> +		bond_mask = lan966x_lag_get_mask(lan966x, bond, true);
> +
> +		for_each_set_bit(p, &bond_mask, lan966x->num_phys_ports) {
> +			lan_wr(ANA_PGID_PGID_SET(bond_mask),
> +			       lan966x, ANA_PGID(p));
> +			aggr_idx[num_active_ports++] = p;
> +		}

This incorrect logic seems to have been copied from ocelot from before
commit a14e6b69f393 ("net: mscc: ocelot: fix incorrect balancing with
down LAG ports").

The issue is that you calculate bond_mask with only_active_ports=true.
This means the for_each_set_bit() will not iterate through the inactive
LAG ports, and won't set the bond_mask as the PGID destination for those
ports.

That isn't what is desired; as explained in that commit, inactive LAG
ports should be removed via the aggregation PGIDs and not via the
destination PGIDs. Otherwise, an FDB entry targeted towards the
LAG (effectively towards the "primary" LAG port, whose logical port ID
gives the LAG ID) will not egress even the "secondary" LAG port if the
primary's link is down.

> +
> +		for (i = PGID_AGGR; i < PGID_SRC; ++i) {
> +			u32 ac;
> +
> +			ac = lan_rd(lan966x, ANA_PGID(i));
> +			ac &= ~bond_mask;
> +			/* Don't do division by zero if there was no active
> +			 * port. Just make all aggregation codes zero.
> +			 */
> +			if (num_active_ports)
> +				ac |= BIT(aggr_idx[i % num_active_ports]);
> +			lan_wr(ANA_PGID_PGID_SET(ac),
> +			       lan966x, ANA_PGID(i));
> +		}
> +
> +		/* Mark all ports in the same LAG as visited to avoid applying
> +		 * the same config again.
> +		 */
> +		for (p = lag; p < lan966x->num_phys_ports; p++) {
> +			struct lan966x_port *port = lan966x->ports[p];
> +
> +			if (!port)
> +				continue;
> +
> +			if (port->bond == bond)
> +				visited |= BIT(p);
> +		}
> +	}
> +}

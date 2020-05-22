Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A90621DE2FD
	for <lists+netdev@lfdr.de>; Fri, 22 May 2020 11:26:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729557AbgEVJ0J (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 May 2020 05:26:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34852 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728068AbgEVJ0J (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 22 May 2020 05:26:09 -0400
Received: from mail-ej1-x642.google.com (mail-ej1-x642.google.com [IPv6:2a00:1450:4864:20::642])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E163CC061A0E
        for <netdev@vger.kernel.org>; Fri, 22 May 2020 02:26:08 -0700 (PDT)
Received: by mail-ej1-x642.google.com with SMTP id e2so12137560eje.13
        for <netdev@vger.kernel.org>; Fri, 22 May 2020 02:26:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=0jLaWtxWdnJF8hjcCR8YdqOQknLFhayXOGEnRZLWaVY=;
        b=dm1pyry88wPwbZIlp1Uv1ZosNZ9RtOFuClICcgV8M0jLzhnxf7W0RezloDmZ1HfZ0s
         yIxvRUQH4vi4lFJTusO5y+MhfYy3p35F1eYeLPgsAAefJDitmGtxu3lj45hwgI37r5Dm
         h0knyEgmdnmy3LqZqfB3tHqtoNHDBSL3XoPueQiv3FBqGRIKwZTZkr47PcV+QYxroXFW
         J+HpKe6JpBL+9UI0RDrBcEUs5CloaNJcTMVWjoZ+hRXIyHmPMou6jKTugcsE2lid8dO1
         oTAG0NerBWTdya3GJgfKJZNYyuyp0y6nM6JvULgFNnD066Gn5tJOodTGQYav5TOYGvKw
         2FKg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=0jLaWtxWdnJF8hjcCR8YdqOQknLFhayXOGEnRZLWaVY=;
        b=EI3oLtkrlBS/2zMDeE3UtZgKD7NKTcqYO/9P6wIkIGrAD3WQx9ZRiQDvBKx1dE/LX/
         Ogd08TK8xctva35tEhST+JjR2S2efEHXprEiRMCNOX8ljcP96NZstRiIZExxTL4FoARU
         uE0EATrO3WYb20NG1kIfj9AeT4g+jU5G0C65yr3GUJu+yV6R0cPZt1fc3ThfICzNNXW/
         +jQzaWdxD/xmuaHViNHXXbac+e1qtcJh6Rp+tS+4YMZHm7xbk3vdER/F/gpBLFe+Xa8j
         n2I0RPwxI9AEhOr9MpVKQ1249gh8quMrgDdQ1dmOyff2hLnCseTmeA4uH1Spx3VgRJ6f
         T9+Q==
X-Gm-Message-State: AOAM5315w0l9/Ir9LtG4uYQZkhnuItHOyQQvaj1c9sxWjnzJTkIX2OVj
        avKVFjLg7ul7mNpqkRslTkLhcwB+aHWXPF9tn66PTQz0
X-Google-Smtp-Source: ABdhPJzrbeUC/r0WsyW5m5Vpp5BofwlfNqW7QeLUtcy3J8FoRsUbcN1quyyh3dCgson5BYUu6QmpIpAteos/sAa6p48=
X-Received: by 2002:a17:906:a415:: with SMTP id l21mr7549242ejz.100.1590139567378;
 Fri, 22 May 2020 02:26:07 -0700 (PDT)
MIME-Version: 1.0
References: <1590137674-31727-1-git-send-email-claudiu.manoil@nxp.com>
In-Reply-To: <1590137674-31727-1-git-send-email-claudiu.manoil@nxp.com>
From:   Vladimir Oltean <olteanv@gmail.com>
Date:   Fri, 22 May 2020 12:25:56 +0300
Message-ID: <CA+h21hrYhv2PXu-Uky7o4KocmfqkRCo02PYXetjiURRxoLyvXg@mail.gmail.com>
Subject: Re: [PATCH net] felix: Fix initialization of ioremap resources
To:     Claudiu Manoil <claudiu.manoil@nxp.com>
Cc:     netdev <netdev@vger.kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        Vladimir Oltean <vladimir.oltean@nxp.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 22 May 2020 at 11:55, Claudiu Manoil <claudiu.manoil@nxp.com> wrote:
>
> The caller of devm_ioremap_resource(), either accidentally
> or by wrong assumption, is writing back derived resource data
> to global static resource initialization tables that should
> have been constant.  Meaning that after it computes the final
> physical start address it saves the address for no reason
> in the static tables.  This doesn't affect the first driver
> probing after reboot, but it breaks consecutive driver reloads
> (i.e. driver unbind & bind) because the initialization tables
> no longer have the correct initial values.  So the next probe()
> will map the device registers to wrong physical addresses,
> causing ARM SError async exceptions.
> This patch fixes all of the above.
>
> Fixes: 56051948773e ("net: dsa: ocelot: add driver for Felix switch family")
>
> Signed-off-by: Claudiu Manoil <claudiu.manoil@nxp.com>
> ---

Excellent!

Reviewed-by: Vladimir Oltean <vladimir.oltean@nxp.com>
Tested-by: Vladimir Oltean <vladimir.oltean@nxp.com>

# echo 0000:00:00.5 > /sys/bus/pci/drivers/mscc_felix/unbind
[   30.935525] mscc_felix 0000:00:00.5 swp0: Link is Up - 1Gbps/Full -
flow control off
[   30.943932] mscc_felix 0000:00:00.5 swp0: Link is Down
[   31.137763] mscc_felix 0000:00:00.5: Link is Down
[   31.155225] DSA: tree 0 torn down
# echo 0000:00:00.5 > /sys/bus/pci/drivers/mscc_felix/bind
[   34.712125] libphy: VSC9959 internal MDIO bus: probed
[   34.721083] mscc_felix 0000:00:00.5: Found PCS at internal MDIO address 0
[   34.731611] mscc_felix 0000:00:00.5: Found PCS at internal MDIO address 1
[   34.741964] mscc_felix 0000:00:00.5: Found PCS at internal MDIO address 2
[   34.752351] mscc_felix 0000:00:00.5: Found PCS at internal MDIO address 3
[   35.022739] mscc_felix 0000:00:00.5 swp0 (uninitialized): PHY
[0000:00:00.3:10] driver [Microsemi GE VSC8514 SyncE] (irq=POLL)
[   35.177379] mscc_felix 0000:00:00.5 swp0: configuring for
inband/qsgmii link mode
[   35.202391] 8021q: adding VLAN 0 to HW filter on device swp0
[   35.262619] mscc_felix 0000:00:00.5 swp1 (uninitialized): PHY
[0000:00:00.3:11] driver [Microsemi GE VSC8514 SyncE] (irq=POLL)
[   35.408862] mscc_felix 0000:00:00.5 swp1: configuring for
inband/qsgmii link mode
[   35.445788] 8021q: adding VLAN 0 to HW filter on device swp1
[   35.506616] mscc_felix 0000:00:00.5 swp2 (uninitialized): PHY
[0000:00:00.3:12] driver [Microsemi GE VSC8514 SyncE] (irq=POLL)
[   35.652391] mscc_felix 0000:00:00.5 swp2: configuring for
inband/qsgmii link mode
[   35.693938] 8021q: adding VLAN 0 to HW filter on device swp2
[   35.754626] mscc_felix 0000:00:00.5 swp3 (uninitialized): PHY
[0000:00:00.3:13] driver [Microsemi GE VSC8514 SyncE] (irq=POLL)
[   35.768684] mscc_felix 0000:00:00.5: configuring for fixed/internal link mode
[   35.776304] mscc_felix 0000:00:00.5: Link is Up - 2.5Gbps/Full -
flow control off
[   35.783967] DSA: tree 0 setup

>  drivers/net/dsa/ocelot/felix.c         | 23 +++++++++++------------
>  drivers/net/dsa/ocelot/felix.h         |  6 +++---
>  drivers/net/dsa/ocelot/felix_vsc9959.c | 22 ++++++++++------------
>  3 files changed, 24 insertions(+), 27 deletions(-)
>
> diff --git a/drivers/net/dsa/ocelot/felix.c b/drivers/net/dsa/ocelot/felix.c
> index e2c6bf0..e8aae64 100644
> --- a/drivers/net/dsa/ocelot/felix.c
> +++ b/drivers/net/dsa/ocelot/felix.c
> @@ -388,6 +388,7 @@ static int felix_init_structs(struct felix *felix, int num_phys_ports)
>         struct ocelot *ocelot = &felix->ocelot;
>         phy_interface_t *port_phy_modes;
>         resource_size_t switch_base;
> +       struct resource res;
>         int port, i, err;
>
>         ocelot->num_phys_ports = num_phys_ports;
> @@ -422,17 +423,16 @@ static int felix_init_structs(struct felix *felix, int num_phys_ports)
>
>         for (i = 0; i < TARGET_MAX; i++) {
>                 struct regmap *target;
> -               struct resource *res;
>
>                 if (!felix->info->target_io_res[i].name)
>                         continue;
>
> -               res = &felix->info->target_io_res[i];
> -               res->flags = IORESOURCE_MEM;
> -               res->start += switch_base;
> -               res->end += switch_base;
> +               memcpy(&res, &felix->info->target_io_res[i], sizeof(res));
> +               res.flags = IORESOURCE_MEM;
> +               res.start += switch_base;
> +               res.end += switch_base;
>
> -               target = ocelot_regmap_init(ocelot, res);
> +               target = ocelot_regmap_init(ocelot, &res);
>                 if (IS_ERR(target)) {
>                         dev_err(ocelot->dev,
>                                 "Failed to map device memory space\n");
> @@ -453,7 +453,6 @@ static int felix_init_structs(struct felix *felix, int num_phys_ports)
>         for (port = 0; port < num_phys_ports; port++) {
>                 struct ocelot_port *ocelot_port;
>                 void __iomem *port_regs;
> -               struct resource *res;
>
>                 ocelot_port = devm_kzalloc(ocelot->dev,
>                                            sizeof(struct ocelot_port),
> @@ -465,12 +464,12 @@ static int felix_init_structs(struct felix *felix, int num_phys_ports)
>                         return -ENOMEM;
>                 }
>
> -               res = &felix->info->port_io_res[port];
> -               res->flags = IORESOURCE_MEM;
> -               res->start += switch_base;
> -               res->end += switch_base;
> +               memcpy(&res, &felix->info->port_io_res[port], sizeof(res));
> +               res.flags = IORESOURCE_MEM;
> +               res.start += switch_base;
> +               res.end += switch_base;
>
> -               port_regs = devm_ioremap_resource(ocelot->dev, res);
> +               port_regs = devm_ioremap_resource(ocelot->dev, &res);
>                 if (IS_ERR(port_regs)) {
>                         dev_err(ocelot->dev,
>                                 "failed to map registers for port %d\n", port);
> diff --git a/drivers/net/dsa/ocelot/felix.h b/drivers/net/dsa/ocelot/felix.h
> index 9af1065..730a8a9 100644
> --- a/drivers/net/dsa/ocelot/felix.h
> +++ b/drivers/net/dsa/ocelot/felix.h
> @@ -8,9 +8,9 @@
>
>  /* Platform-specific information */
>  struct felix_info {
> -       struct resource                 *target_io_res;
> -       struct resource                 *port_io_res;
> -       struct resource                 *imdio_res;
> +       const struct resource           *target_io_res;
> +       const struct resource           *port_io_res;
> +       const struct resource           *imdio_res;
>         const struct reg_field          *regfields;
>         const u32 *const                *map;
>         const struct ocelot_ops         *ops;
> diff --git a/drivers/net/dsa/ocelot/felix_vsc9959.c b/drivers/net/dsa/ocelot/felix_vsc9959.c
> index 8bf395f..5211f05 100644
> --- a/drivers/net/dsa/ocelot/felix_vsc9959.c
> +++ b/drivers/net/dsa/ocelot/felix_vsc9959.c
> @@ -333,10 +333,8 @@ static const u32 *vsc9959_regmap[] = {
>         [GCB]   = vsc9959_gcb_regmap,
>  };
>
> -/* Addresses are relative to the PCI device's base address and
> - * will be fixed up at ioremap time.
> - */
> -static struct resource vsc9959_target_io_res[] = {
> +/* Addresses are relative to the PCI device's base address */
> +static const struct resource vsc9959_target_io_res[] = {
>         [ANA] = {
>                 .start  = 0x0280000,
>                 .end    = 0x028ffff,
> @@ -379,7 +377,7 @@ static struct resource vsc9959_target_io_res[] = {
>         },
>  };
>
> -static struct resource vsc9959_port_io_res[] = {
> +static const struct resource vsc9959_port_io_res[] = {
>         {
>                 .start  = 0x0100000,
>                 .end    = 0x010ffff,
> @@ -415,7 +413,7 @@ static struct resource vsc9959_port_io_res[] = {
>  /* Port MAC 0 Internal MDIO bus through which the SerDes acting as an
>   * SGMII/QSGMII MAC PCS can be found.
>   */
> -static struct resource vsc9959_imdio_res = {
> +static const struct resource vsc9959_imdio_res = {
>         .start          = 0x8030,
>         .end            = 0x8040,
>         .name           = "imdio",
> @@ -1111,7 +1109,7 @@ static int vsc9959_mdio_bus_alloc(struct ocelot *ocelot)
>         struct device *dev = ocelot->dev;
>         resource_size_t imdio_base;
>         void __iomem *imdio_regs;
> -       struct resource *res;
> +       struct resource res;
>         struct enetc_hw *hw;
>         struct mii_bus *bus;
>         int port;
> @@ -1128,12 +1126,12 @@ static int vsc9959_mdio_bus_alloc(struct ocelot *ocelot)
>         imdio_base = pci_resource_start(felix->pdev,
>                                         felix->info->imdio_pci_bar);
>
> -       res = felix->info->imdio_res;
> -       res->flags = IORESOURCE_MEM;
> -       res->start += imdio_base;
> -       res->end += imdio_base;
> +       memcpy(&res, felix->info->imdio_res, sizeof(res));
> +       res.flags = IORESOURCE_MEM;
> +       res.start += imdio_base;
> +       res.end += imdio_base;
>
> -       imdio_regs = devm_ioremap_resource(dev, res);
> +       imdio_regs = devm_ioremap_resource(dev, &res);
>         if (IS_ERR(imdio_regs)) {
>                 dev_err(dev, "failed to map internal MDIO registers\n");
>                 return PTR_ERR(imdio_regs);
> --
> 2.7.4
>

Thanks,
-Vladimir

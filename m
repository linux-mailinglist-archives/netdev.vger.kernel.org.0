Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C65643EFDCB
	for <lists+netdev@lfdr.de>; Wed, 18 Aug 2021 09:31:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238834AbhHRHcW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Aug 2021 03:32:22 -0400
Received: from esa.microchip.iphmx.com ([68.232.153.233]:51418 "EHLO
        esa.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238454AbhHRHcT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Aug 2021 03:32:19 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1629271907; x=1660807907;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=Wa1r5h4FFrgMJkcMvQN69YhP67t96po6tiEnTqYRkNE=;
  b=eSnnJRqoFD66i/bLsuk39kN9N4B7KorFLKzlmORfR0xw4Dn9WUVo7vyx
   d6HtUSBUmKMqwRg+LqCQLzA9Aqe5LNZY614e8GJ6itkWYSSRSe+ZIzHSN
   X5H96QxbcpmEsbElGeLgBXIXKVN5WQDniIf2o73ri4rgFCTg6si0QGIOU
   A0vr30OiD0nsZqey+erbHbgGnynJ4/XcLvZcH99YPsu+YWQaeB+lrjjOR
   xiHr+p+/EMsjAlBboDacVZEazSCYxZp3Jts3kW/3b8AGq+w7FXKngBAnv
   1uMN6ghclMgp9Wisowr5M0GYf1JJOSrz/Hkrj1T8co9PQV2ALxHQEcxyk
   A==;
IronPort-SDR: /C5XC8QoHTCE7ldhrEULAwdNXjJhfrN83Wha31oBNNF6v7qL8IrP1pacgLaBXtX0cprzIlahmd
 /odHKOahLHPRgG+rZXhBr2XkUTihyQq9MTD2OAiPx7IIDoolW8lmVy+reSJPVbTd4ZEu3QDZld
 bhMh7pLS5T92Ps2iMToVOnxue4qAi+7bmgNaBcsVO8DCeXkxWoBKC+ODMojCBR/jm2Jy7riaw3
 h0DZqY/67OWQaIGr7YRqoyQixIqgQAawD63tt4eKX/kDcYtYVJ7Pb8WsZFfMGCBcdXugO82l/7
 7J+UvxW9VI/hV+0dCEQru2YJ
X-IronPort-AV: E=Sophos;i="5.84,330,1620716400"; 
   d="scan'208";a="132691315"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa5.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 18 Aug 2021 00:31:46 -0700
Received: from chn-vm-ex01.mchp-main.com (10.10.85.143) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.14; Wed, 18 Aug 2021 00:31:44 -0700
Received: from localhost (10.10.115.15) by chn-vm-ex01.mchp-main.com
 (10.10.85.143) with Microsoft SMTP Server id 15.1.2176.14 via Frontend
 Transport; Wed, 18 Aug 2021 00:31:44 -0700
Date:   Wed, 18 Aug 2021 09:32:48 +0200
From:   Horatiu Vultur <horatiu.vultur@microchip.com>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
CC:     Claudiu Manoil <claudiu.manoil@nxp.com>,
        "alexandre.belloni@bootlin.com" <alexandre.belloni@bootlin.com>,
        "UNGLinuxDriver@microchip.com" <UNGLinuxDriver@microchip.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH net-next] net: mscc: ocelot: Fix probe for vsc7514
Message-ID: <20210818073248.as2mbc7ea2rttuxu@soft-dev3-1.localhost>
References: <20210817120633.404790-1-horatiu.vultur@microchip.com>
 <20210817122412.6zjvjbfk3dnyh6uz@skbuf>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
In-Reply-To: <20210817122412.6zjvjbfk3dnyh6uz@skbuf>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The 08/17/2021 12:24, Vladimir Oltean wrote:

Hi Vladimir,

Thanks for the patch, it seems to fix the initial problem(the probe
function failed) but then I start to get some warnings in the probe
function.

[    2.178345] ------------[ cut here ]------------
[    2.183249] WARNING: CPU: 0 PID: 1 at net/core/devlink.c:9275 ocelot_port_devlink_init+0x88/0xd0
[    2.192333] Modules linked in:
[    2.195617] CPU: 0 PID: 1 Comm: swapper/0 Not tainted 5.14.0-rc5-01260-g0f217b897eeb-dirty #113
[    2.204414] Stack : 00000001 81d300e0 0000000f 8018ccc0 00000001 00000004 00000000 b7c1f2a2
[    2.212876]         81455aec 80b142a8 80a30000 80a34663 809ce3d0 00000001 81455a90 81441800
[    2.221331]         00000000 00000000 809ce3d0 81455930 00000001 81455944 00000000 0000076c
[    2.229783]         25784660 81455949 ffffffff 00000010 80a30000 809ce3d0 00000009 00000009
[    2.238235]         00000000 00000006 00000001 81d300e0 00000000 805c9028 00000000 80b10000
[    2.246687]         ...
[    2.249163] Call Trace:
[    2.251626] [<80108b34>] show_stack+0x38/0x118
[    2.256166] [<808d18e4>] dump_stack_lvl+0x68/0x94
[    2.260937] [<808cea2c>] __warn+0xc0/0xe8
[    2.264985] [<808ceac0>] warn_slowpath_fmt+0x6c/0xd0
[    2.269993] [<8067ede0>] ocelot_port_devlink_init+0x88/0xd0
[    2.275608] [<8067cfa0>] mscc_ocelot_probe+0x688/0x808
[    2.280823] [<805df698>] platform_probe+0x68/0xf4
[    2.285587] [<805dd3a8>] really_probe+0xc8/0x350
[    2.290244] [<805dd6c4>] __driver_probe_device+0x94/0x10c
[    2.295686] [<805dd784>] driver_probe_device+0x48/0x110
[    2.300954] [<805ddef8>] __driver_attach+0x7c/0x124
[    2.305871] [<805db430>] bus_for_each_dev+0x7c/0xc8
[    2.310822] [<805dbfa0>] bus_add_driver+0x1f4/0x204
[    2.315739] [<805de9d8>] driver_register+0x84/0x15c
[    2.320660] [<80100158>] do_one_initcall+0x8c/0x1e4
[    2.325579] [<80ac11cc>] kernel_init_freeable+0x268/0x30c
[    2.331049] [<808d53c4>] kernel_init+0x24/0x114
[    2.335637] [<80102698>] ret_from_kernel_thread+0x14/0x1c
[    2.341081]
[    2.342910] ---[ end trace bf0038db663c1a65 ]---
[    2.347793] ------------[ cut here ]------------
[    2.352612] WARNING: CPU: 0 PID: 1 at net/core/devlink.c:9114 devlink_port_register+0x164/0x17c
[    2.361678] Modules linked in:
[    2.364809] CPU: 0 PID: 1 Comm: swapper/0 Tainted: G        W         5.14.0-rc5-01260-g0f217b897eeb-dirty #113
[    2.374959] Stack : 00000001 81d300e0 0000000f 8018ccc0 00000001 00000004 00000000 b7c1f2a2
[    2.383417]         81455abc 80b142a8 80a30000 80a34663 809ce3d0 00000001 81455a60 81441800
[    2.391872]         00000000 00000000 809ce3d0 81455900 00000001 81455914 00000000 00000e10
[    2.400324]         f9a01ed8 81455919 ffffffff 00000010 80a30000 809ce3d0 00000009 00000009
[    2.408777]         00000000 00000006 00000001 81d300e0 00000000 805c9028 00000000 80b10000
[    2.417229]         ...
[    2.419704] Call Trace:
[    2.422167] [<80108b34>] show_stack+0x38/0x118
[    2.426689] [<808d18e4>] dump_stack_lvl+0x68/0x94
[    2.431442] [<808cea2c>] __warn+0xc0/0xe8
[    2.435488] [<808ceac0>] warn_slowpath_fmt+0x6c/0xd0
[    2.440494] [<8073edd4>] devlink_port_register+0x164/0x17c
[    2.446026] [<8067edf0>] ocelot_port_devlink_init+0x98/0xd0
[    2.451645] [<8067cfa0>] mscc_ocelot_probe+0x688/0x808
[    2.456853] [<805df698>] platform_probe+0x68/0xf4
[    2.461611] [<805dd3a8>] really_probe+0xc8/0x350
[    2.466268] [<805dd6c4>] __driver_probe_device+0x94/0x10c
[    2.471709] [<805dd784>] driver_probe_device+0x48/0x110
[    2.476976] [<805ddef8>] __driver_attach+0x7c/0x124
[    2.481895] [<805db430>] bus_for_each_dev+0x7c/0xc8
[    2.486828] [<805dbfa0>] bus_add_driver+0x1f4/0x204
[    2.491746] [<805de9d8>] driver_register+0x84/0x15c
[    2.496666] [<80100158>] do_one_initcall+0x8c/0x1e4
[    2.501586] [<80ac11cc>] kernel_init_freeable+0x268/0x30c
[    2.507041] [<808d53c4>] kernel_init+0x24/0x114
[    2.511621] [<80102698>] ret_from_kernel_thread+0x14/0x1c
[    2.517067]
[    2.518811] ---[ end trace bf0038db663c1a66 ]---


These warnings are generated when trying to initialize unused devlink
ports.

To fix this warnings I have added the following line inside
'ocelot_port_devlink_teardown'.

memset(dlp, 0x0, sizeof(struct devlink_port));

> 
> Hi Horatiu,
> 
> On Tue, Aug 17, 2021 at 02:06:33PM +0200, Horatiu Vultur wrote:
> > The check for parsing the 'phy-handle' was removed in the blamed commit.
> > Therefor it would try to create phylinks for each port and connect to
> > the phys. But on ocelot_pcb123 and ocelot_pcb120 not all the ports have
> > a phy, so this will failed. So the probe of the network driver will
> > fail.
> >
> > The fix consists in adding back the check for 'phy-handle' for vsc7514
> >
> > Fixes: e6e12df625f2 ("net: mscc: ocelot: convert to phylink")
> > Signed-off-by: Horatiu Vultur <horatiu.vultur@microchip.com>
> > ---
> >  drivers/net/ethernet/mscc/ocelot_vsc7514.c | 3 +++
> >  1 file changed, 3 insertions(+)
> >
> > diff --git a/drivers/net/ethernet/mscc/ocelot_vsc7514.c b/drivers/net/ethernet/mscc/ocelot_vsc7514.c
> > index 18aed504f45d..96ac64f13382 100644
> > --- a/drivers/net/ethernet/mscc/ocelot_vsc7514.c
> > +++ b/drivers/net/ethernet/mscc/ocelot_vsc7514.c
> > @@ -954,6 +954,9 @@ static int mscc_ocelot_init_ports(struct platform_device *pdev,
> >               if (of_property_read_u32(portnp, "reg", &reg))
> >                       continue;
> >
> > +             if (!of_parse_phandle(portnp, "phy-handle", 0))
> > +                     continue;
> > +
> >               port = reg;
> >               if (port < 0 || port >= ocelot->num_phys_ports) {
> >                       dev_err(ocelot->dev,
> > --
> > 2.31.1
> >
> 
> Thanks a lot for taking the time to test!
> 
> What do you think about this alternative? It should not limit the driver
> to only having phy-handle (having a fixed-link is valid too):
> 
> -----------------------------[ cut here ]-----------------------------
> From 598f7795389fb127726de199bb77fd7ddf5df096 Mon Sep 17 00:00:00 2001
> From: Vladimir Oltean <vladimir.oltean@nxp.com>
> Date: Tue, 17 Aug 2021 15:14:57 +0300
> Subject: [PATCH] net: mscc: ocelot: allow probing to continue with ports that
>  fail to register
> 
> The existing ocelot device trees, like ocelot_pcb123.dts for example,
> have SERDES ports (ports 4 and higher) that do not have status = "disabled";
> but on the other hand do not have a phy-handle or a fixed-link either.
> 
> So from the perspective of phylink, they have broken DT bindings.
> 
> Since the blamed commit, probing for the entire switch will fail when
> such a device tree binding is encountered on a port. There used to be
> this piece of code which skipped ports without a phy-handle:
> 
>         phy_node = of_parse_phandle(portnp, "phy-handle", 0);
>         if (!phy_node)
>                 continue;
> 
> but now it is gone.
> 
> Anyway, fixed-link setups are a thing which should work out of the box
> with phylink, so it would not be in the best interest of the driver to
> add that check back.
> 
> Instead, let's look at what other drivers do. Since commit 86f8b1c01a0a
> ("net: dsa: Do not make user port errors fatal"), DSA continues after a
> switch port fails to register, and works only with the ports that
> succeeded.
> 
> We can achieve the same behavior in ocelot by unregistering the devlink
> port for ports where ocelot_port_phylink_create() failed (called via
> ocelot_probe_port), and clear the bit in devlink_ports_registered for
> that port. This will make the next iteration reconsider the port that
> failed to probe as an unused port, and re-register a devlink port of
> type UNUSED for it. No other cleanup should need to be performed, since
> ocelot_probe_port() should be self-contained when it fails.
> 
> Fixes: e6e12df625f2 ("net: mscc: ocelot: convert to phylink")
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
> ---
>  drivers/net/ethernet/mscc/ocelot_vsc7514.c | 7 ++++---
>  1 file changed, 4 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/net/ethernet/mscc/ocelot_vsc7514.c b/drivers/net/ethernet/mscc/ocelot_vsc7514.c
> index 18aed504f45d..291ae6817c26 100644
> --- a/drivers/net/ethernet/mscc/ocelot_vsc7514.c
> +++ b/drivers/net/ethernet/mscc/ocelot_vsc7514.c
> @@ -978,14 +978,15 @@ static int mscc_ocelot_init_ports(struct platform_device *pdev,
>                         of_node_put(portnp);
>                         goto out_teardown;
>                 }
> -               devlink_ports_registered |= BIT(port);
> 
>                 err = ocelot_probe_port(ocelot, port, target, portnp);
>                 if (err) {
> -                       of_node_put(portnp);
> -                       goto out_teardown;
> +                       ocelot_port_devlink_teardown(ocelot, port);
> +                       continue;
>                 }
> 
> +               devlink_ports_registered |= BIT(port);
> +
>                 ocelot_port = ocelot->ports[port];
>                 priv = container_of(ocelot_port, struct ocelot_port_private,
>                                     port);
> -----------------------------[ cut here ]-----------------------------

-- 
/Horatiu

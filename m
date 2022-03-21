Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 95A694E2FDB
	for <lists+netdev@lfdr.de>; Mon, 21 Mar 2022 19:22:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352083AbiCUSX5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Mar 2022 14:23:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34334 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352085AbiCUSX4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Mar 2022 14:23:56 -0400
Received: from mail-ed1-x534.google.com (mail-ed1-x534.google.com [IPv6:2a00:1450:4864:20::534])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8B486515BC;
        Mon, 21 Mar 2022 11:22:29 -0700 (PDT)
Received: by mail-ed1-x534.google.com with SMTP id a17so17858579edm.9;
        Mon, 21 Mar 2022 11:22:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=15mNt35SXdTTllQh/DS3vUON7J6NUTE7+sxDarlVZ5Q=;
        b=dAYtMY9LsGnYZnH4l2rkSUUTabzZqoYUSEH0/jYD51R50DX1/51pxxTikUxwRyupo1
         W9x/oX2qFiqsd1awBCmJ6nBlusy0/TT1KdY+7Uw+UBmx/pzuX6EhwIRtYxAQLZ8MqSRE
         Q77C6jn7H99mAAmBNctFgLJOBgaq3iI/4NSUHksHqyNdWuy2ko4PrZ83Z99DfO9jIr/6
         zQgP+XvnZQhqzBuGWss0DJhK/d9sY0Bf/OnfWhiKmIxMoUH0fA59HCljdwfsit0jnbho
         2i1r3ib5lO+hTDifSL4Lviin2z5h55WldGe6Uh9n+eruTKXxw74GqMDNeNSIpMsAyNLy
         6cXw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=15mNt35SXdTTllQh/DS3vUON7J6NUTE7+sxDarlVZ5Q=;
        b=P0RvpHC+Y/PkkkpfaTbqm5RQz+qFKCJFKRlrGYX67PDf5+1Ea9P9VNQSr6w5klFprB
         dsv84m2kme9oCP/pa4x666JOeyEdwq5vmwAT6jX/CAjUev0FO35drPSEiIymIbeJIE/E
         MxfVaqdwgoV+BHi6rR6r5TN/B8i9Zw2TnJyjPFbXicRu0G5aTHL6cRoXLVuab3yl1RKZ
         ffV9BuynEdD4V8rv2A7LFW1kje+cJEa16cUUN28BRHElAvGC00QXJAACkdnn/T5/FJ4W
         g/R3Z7BQhwaRTsh/DHLYp3AgirzfwKb/7Q7IZz2QZca/LO3x0NRjEPxymkSNuQ/odDWr
         a71A==
X-Gm-Message-State: AOAM532AHMsnrvWTo0P8i08+tupxm0AXHnk2OowvNd7ntN+SPcaEmIZv
        7Q7G5V9d4ZW/uMkZzNbIB/msutLY45o=
X-Google-Smtp-Source: ABdhPJwoLPk0sVYlj1alS3N7unlAooFFOMQvk0VY+D8u82gPM/XVeOtKuI2qYtTcPk6ABiqRXFWMbw==
X-Received: by 2002:aa7:c704:0:b0:418:ee8f:3fd0 with SMTP id i4-20020aa7c704000000b00418ee8f3fd0mr24285898edq.248.1647886948042;
        Mon, 21 Mar 2022 11:22:28 -0700 (PDT)
Received: from skbuf ([188.26.57.45])
        by smtp.gmail.com with ESMTPSA id g1-20020a056402424100b00416c6cbfa4csm8110592edb.54.2022.03.21.11.22.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 21 Mar 2022 11:22:27 -0700 (PDT)
Date:   Mon, 21 Mar 2022 20:22:26 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Ansuel Smith <ansuelsmth@gmail.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Russell King <linux@armlinux.org.uk>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [net-next PATCH v2] net: dsa: qca8k: pack driver struct and
 improve cache use
Message-ID: <20220321182226.zx2fqlntaxd7snup@skbuf>
References: <20220228110408.4903-1-ansuelsmth@gmail.com>
 <20220303015327.k3fqkkxunm6kihjl@skbuf>
 <Yjii20KryAsEQp1k@Ansuel-xps.localdomain>
 <20220321172200.eaccmwzfvtw7bjs2@skbuf>
 <Yji1QAMe/efWLBQE@Ansuel-xps.localdomain>
 <Yji2b6XF13E1o2x3@Ansuel-xps.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Yji2b6XF13E1o2x3@Ansuel-xps.localdomain>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Mar 21, 2022 at 06:31:27PM +0100, Ansuel Smith wrote:
> On Mon, Mar 21, 2022 at 06:26:24PM +0100, Ansuel Smith wrote:
> > On Mon, Mar 21, 2022 at 07:22:00PM +0200, Vladimir Oltean wrote:
> > > On Mon, Mar 21, 2022 at 05:07:55PM +0100, Ansuel Smith wrote:
> > > > On Thu, Mar 03, 2022 at 03:53:27AM +0200, Vladimir Oltean wrote:
> > > > > On Mon, Feb 28, 2022 at 12:04:08PM +0100, Ansuel Smith wrote:
> > > > > > Pack qca8k priv and other struct using pahole and set the first priv
> > > > > > struct entry to mgmt_master and mgmt_eth_data to speedup access.
> > > > > > While at it also rework pcs struct and move it qca8k_ports_config
> > > > > > following other configuration set for the cpu ports.
> > > > > > 
> > > > > > Signed-off-by: Ansuel Smith <ansuelsmth@gmail.com>
> > > > > > ---
> > > > > 
> > > > > How did you "pack" struct qca8k_priv exactly?
> > > > >
> > > > 
> > > > I'm trying to understand it too... also this was done basend on what
> > > > target? 
> > > 
> > > I used an arm64 toolchain, if that's what you're asking.
> > >
> > 
> > That could be the reason of different results. Qca8k is mostly used on
> > 32bit systems with 4byte cache wonder. That could be the reason i have
> > different results and on a system like that it did suggest this order?

Is it impossible to use the qca8k driver on 64-bit systems?

> > > > > Before:
> > > > > 
> > > > > struct qca8k_priv {
> > > > >         u8                         switch_id;            /*     0     1 */
> > > > >         u8                         switch_revision;      /*     1     1 */
> > > > >         u8                         mirror_rx;            /*     2     1 */
> > > > >         u8                         mirror_tx;            /*     3     1 */
> > > > >         u8                         lag_hash_mode;        /*     4     1 */
> > > > >         bool                       legacy_phy_port_mapping; /*     5     1 */
> > > > >         struct qca8k_ports_config  ports_config;         /*     6     7 */
> > > > > 
> > > > >         /* XXX 3 bytes hole, try to pack */
> > > > > 
> > > > >         struct regmap *            regmap;               /*    16     8 */
> > > > >         struct mii_bus *           bus;                  /*    24     8 */
> > > > >         struct ar8xxx_port_status  port_sts[7];          /*    32    28 */
> > > > > 
> > > > >         /* XXX 4 bytes hole, try to pack */
> > > > > 
> > > > >         /* --- cacheline 1 boundary (64 bytes) --- */
> > > > >         struct dsa_switch *        ds;                   /*    64     8 */
> > > > >         struct mutex               reg_mutex;            /*    72   160 */
> > > > >         /* --- cacheline 3 boundary (192 bytes) was 40 bytes ago --- */
> > > > >         struct device *            dev;                  /*   232     8 */
> > > > >         struct dsa_switch_ops      ops;                  /*   240   864 */
> > > > >         /* --- cacheline 17 boundary (1088 bytes) was 16 bytes ago --- */
> > > > >         struct gpio_desc *         reset_gpio;           /*  1104     8 */
> > > > >         unsigned int               port_mtu[7];          /*  1112    28 */
> > > > > 
> > > > >         /* XXX 4 bytes hole, try to pack */
> > > > > 
> > > > >         struct net_device *        mgmt_master;          /*  1144     8 */
> > > > >         /* --- cacheline 18 boundary (1152 bytes) --- */
> > > > >         struct qca8k_mgmt_eth_data mgmt_eth_data;        /*  1152   280 */
> > > > >         /* --- cacheline 22 boundary (1408 bytes) was 24 bytes ago --- */
> > > > >         struct qca8k_mib_eth_data  mib_eth_data;         /*  1432   272 */
> > > > >         /* --- cacheline 26 boundary (1664 bytes) was 40 bytes ago --- */
> > > > >         struct qca8k_mdio_cache    mdio_cache;           /*  1704     6 */
> > > > > 
> > > > >         /* XXX 2 bytes hole, try to pack */
> > > > > 
> > > > >         struct qca8k_pcs           pcs_port_0;           /*  1712    32 */
> > > > > 
> > > > >         /* XXX last struct has 4 bytes of padding */
> > > > > 
> > > > >         /* --- cacheline 27 boundary (1728 bytes) was 16 bytes ago --- */
> > > > >         struct qca8k_pcs           pcs_port_6;           /*  1744    32 */
> > > > > 
> > > > >         /* XXX last struct has 4 bytes of padding */
> > > > > 
> > > > >         /* size: 1776, cachelines: 28, members: 22 */
> > > > >         /* sum members: 1763, holes: 4, sum holes: 13 */
> > > > >         /* paddings: 2, sum paddings: 8 */
> > > > >         /* last cacheline: 48 bytes */
> > > > > };
> > > > > 
> > > > > After:
> > > > > 
> > > > > struct qca8k_priv {
> > > > >         struct net_device *        mgmt_master;          /*     0     8 */
> > > > >         struct qca8k_mgmt_eth_data mgmt_eth_data;        /*     8   280 */
> > > > >         /* --- cacheline 4 boundary (256 bytes) was 32 bytes ago --- */
> > > > >         struct qca8k_mdio_cache    mdio_cache;           /*   288     6 */
> > > > >         u8                         switch_id;            /*   294     1 */
> > > > >         u8                         switch_revision;      /*   295     1 */
> > > > >         u8                         mirror_rx;            /*   296     1 */
> > > > >         u8                         mirror_tx;            /*   297     1 */
> > > > >         u8                         lag_hash_mode;        /*   298     1 */
> > > > >         bool                       legacy_phy_port_mapping; /*   299     1 */
> > > > > 
> > > > >         /* XXX 4 bytes hole, try to pack */
> > > > > 
> > > > >         struct qca8k_ports_config  ports_config;         /*   304    72 */
> > > > >         /* --- cacheline 5 boundary (320 bytes) was 56 bytes ago --- */
> > > > >         struct regmap *            regmap;               /*   376     8 */
> > > > >         /* --- cacheline 6 boundary (384 bytes) --- */
> > > > >         struct mii_bus *           bus;                  /*   384     8 */
> > > > >         struct ar8xxx_port_status  port_sts[7];          /*   392    28 */
> > > > > 
> > > > >         /* XXX 4 bytes hole, try to pack */
> > > > > 
> > > > >         struct dsa_switch *        ds;                   /*   424     8 */
> > > > >         struct mutex               reg_mutex;            /*   432   160 */
> > > > >         /* --- cacheline 9 boundary (576 bytes) was 16 bytes ago --- */
> > > > >         struct device *            dev;                  /*   592     8 */
> > > > >         struct gpio_desc *         reset_gpio;           /*   600     8 */
> > > > >         struct dsa_switch_ops      ops;                  /*   608   864 */
> > > > >         /* --- cacheline 23 boundary (1472 bytes) --- */
> > > > >         struct qca8k_mib_eth_data  mib_eth_data;         /*  1472   280 */
> > > > > 
> > > > >         /* XXX last struct has 4 bytes of padding */
> > > > > 
> > > > >         /* --- cacheline 27 boundary (1728 bytes) was 24 bytes ago --- */
> > > > >         unsigned int               port_mtu[7];          /*  1752    28 */
> > > > > 
> > > > >         /* size: 1784, cachelines: 28, members: 20 */
> > > > >         /* sum members: 1772, holes: 2, sum holes: 8 */
> > > > >         /* padding: 4 */
> > > > >         /* paddings: 1, sum paddings: 4 */
> > > > >         /* last cacheline: 56 bytes */
> > > > > };
> > > > > 
> > > > > 1776 vs 1784. That's... larger?!
> > > > > 
> > > > > Also, struct qca8k_priv is so large because the "ops" member is a full
> > > > > copy of qca8k_switch_ops. I understand why commit db460c54b67f ("net:
> > > > > dsa: qca8k: extend slave-bus implementations") did this, but I wonder,
> > > > > is there no better way?
> > > > > 
> > > > 
> > > > Actually from what I can see the struct can be improved in 2 way...
> > > > The ancient struct
> > > > ar8xxx_port_status port_sts[QCA8K_NUM_PORTS];
> > > > can be totally dropped as I can't see why we still need it.
> > > > 
> > > > The duplicated ops is funny. I could be very confused but why it's done
> > > > like that? Can't we modify directly the already defined one and drop
> > > > struct dsa_switch_ops ops; from qca8k_priv?
> > > 
> > > Simply put, qca8k_switch_ops is per kernel, priv->ops is per driver
> > > instance.
> > > 
> > 
> > Right I totally missed that.
> > 
> > > > I mean is all of that to use priv->ops.phy_read instead of
> > > > priv->ds->ops.phy_read or even qca8k_switch_ops directly? o.o
> > > > 
> > > > Am I missing something?
> > > 
> > > The thing is that qca8k_setup_mdio_bus() wants DSA to use the
> > > legacy_phy_port_mapping only as a fallback. DSA uses this simplistic
> > > condition:
> > > 
> > > dsa_switch_setup():
> > > 	if (!ds->slave_mii_bus && ds->ops->phy_read) {
> > > 		ds->slave_mii_bus = mdiobus_alloc();
> > > 
> > > You might be tempted to say: hey, qca8k_mdio_register() populates
> > > ds->slave_mii_bus to an MDIO bus allocated by itself. So you'd be able
> > > to prune the mdiobus_alloc() because the first part of the condition is
> > > false.
> > > 
> > > But dsa_switch_teardown() has:
> > > 
> > > 	if (ds->slave_mii_bus && ds->ops->phy_read) {
> > > 		mdiobus_unregister(ds->slave_mii_bus);
> > > 
> > > In other words, dsa_switch_teardown() has lost track of who allocated
> > > the MDIO bus - it assumes that the DSA core has. That will conflict with
> > > qca8k which uses devres, so it would result in double free.
> > > 
> > > So that's basically what the problem is. The qca8k driver needs to have
> > > a NULL ds->ops->phy_read if it doesn't use the legacy_phy_port_mapping,
> > > so it won't confuse the DSA core.
> > > 
> > > Please note that I'm not really too familiar with this part of the DSA
> > > core since I don't have any hardware that makes any use of ds->slave_mii_bus.
> > > 
> > 
> > Ok now I see the problem. Thx for the good explaination. I wonder...
> > Should I use the easy path and just drop phy_read/write? Qca8k already
> > allocate a dedicated mdio for the same task... Should I just add some
> > check and make the dedicated mdio register without the OF API when it's
> > in legacy mode?
> > 
> > I think that at times the idea of that patch was to try to use as much
> > as possible generic dsa ops but if that would result in having the big
> > ops duplicated for every switch that doesn't seems that optmizied.
> > 
> > An alternative would be adding an additional flag to dsa to control how
> > DSA should handle slave_mii_bus. But I assume a solution like that would
> > be directly NACK as it's just an hack for a driver to save some space.
> > 
> > Or now that I think about it generilize all of this and add some API to
> > DSA to register an mdiobus with an mdio node if provided. Or even
> > provide some way to make the driver decide what to do... Some type of
> > configuration? Is it overkill or other driver would benefit from this?
> > Do we have other driver that declare a custom mdiobus instead of using
> > phy_read/write?
> >
> 
> I just checked we have 4 driver that implement custom mdiobus using an
> of node and would benefit from this... Still don't know if it would be a
> good solution.

If you provide your own ds->slave_mii_bus there should be no reason to
need a ds->ops->phy_read, since your slave_mii_bus already has one.

Bottom line, phy_read is just there in case they it is helpful.
Whereas ds->slave_mii_bus is there if you want to have a non-OF based
phy_connect, with the implicit assumption that the phy_addr is equal to
the port, and it can't be in any other way.

So if ds->ops->phy_read / ds->ops->phy_write aren't useful, don't use them.
I suppose one of the drivers you saw with "custom mdiobus" was sja1105.
I have no interest whatsoever in converting that driver to use
ds->slave_mii_bus or ds->phy_read.

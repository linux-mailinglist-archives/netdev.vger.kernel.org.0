Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A292B4E2EF7
	for <lists+netdev@lfdr.de>; Mon, 21 Mar 2022 18:22:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351741AbiCURXf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Mar 2022 13:23:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49064 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349471AbiCURXb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Mar 2022 13:23:31 -0400
Received: from mail-ej1-x62a.google.com (mail-ej1-x62a.google.com [IPv6:2a00:1450:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 908DB8D6B1;
        Mon, 21 Mar 2022 10:22:04 -0700 (PDT)
Received: by mail-ej1-x62a.google.com with SMTP id bi12so31308787ejb.3;
        Mon, 21 Mar 2022 10:22:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=IG5/PiqhN8hKoXxhGtxKVB/1xsuFYLDKXhsC2CvoekE=;
        b=Sv3M9Tk7R8A4e2HqQfaOpabnBOyy7NSRp85pq7nj003WnaIdvxb2Shl2M0chMm31wp
         Z7w3TrMojuFhvglvYZnBSPOMTDvbH5lfKawDnAF4O3J7lWRKTf/031YiR94xiIy0zf/r
         Pn3RP7nJmQL4Ib8hcWFa4gpf89biL14wx10cIjJlw7Pr3UO5+cxns9dL0UvnM7wZPGJI
         JQD8Qtg5lKBX3TP7JXDLM98E00cWEx4Qo7XfJaAjj582J5i6eKs0pw+tUCYg9Xl+nBR2
         zijaQkIyOAlode/wzUHQriQO33++rQk48NABbwnE0Vj1eeBiLOR8gjoElFPhQfr/3GrO
         zd6Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=IG5/PiqhN8hKoXxhGtxKVB/1xsuFYLDKXhsC2CvoekE=;
        b=zYUOhX0oUxFUafoVQXUrub/SE8ZuBAyQHQHtGsiA8Vk36faWfWsq4AYmsvfy/Dc0ah
         JibYBxwdY0coIIuDh828uJNs8lRyT7gvLP9+Z7K6G8pO7U+/iZsefUUtM2yvle0NZEwT
         PKBF2jY7tqhLcsJ2ZkuJpwnYm0/+UM8sA+aYecTRpf4+/oPUEcqaAj1ccdEL0cb7q27g
         v6i5EiFAuTN0WS/hXP2R/8UI0Xp+vlK5gBWdnYVbbLjlnDIRoPz7MRJgyRd7sR2MqJtn
         qDVe/yPRUuFtDW2l3zCPB/sNo6pUgVXv9kbunyOJqI7bGnvbE0QlCxdynELghPandi55
         MNOg==
X-Gm-Message-State: AOAM5309qDLRnZuWh7hBy8AbqrcOBB+v5zj+HZPj4BQZautrWQsMa9Oc
        FJSOqV0vYcxY6/Z8n5eJTq4=
X-Google-Smtp-Source: ABdhPJxtKjN8Y7eP27QWdR+Zq6QyxNrMyoe1O4CkVerfrvSAtvo3tgR+ZqpdHe4knjzQ4LZopS3WWg==
X-Received: by 2002:a17:907:3da4:b0:6da:9ec2:c3ff with SMTP id he36-20020a1709073da400b006da9ec2c3ffmr21702487ejc.90.1647883322990;
        Mon, 21 Mar 2022 10:22:02 -0700 (PDT)
Received: from skbuf ([188.26.57.45])
        by smtp.gmail.com with ESMTPSA id y15-20020a170906518f00b006df87a2bb16sm6446235ejk.89.2022.03.21.10.22.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 21 Mar 2022 10:22:02 -0700 (PDT)
Date:   Mon, 21 Mar 2022 19:22:00 +0200
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
Message-ID: <20220321172200.eaccmwzfvtw7bjs2@skbuf>
References: <20220228110408.4903-1-ansuelsmth@gmail.com>
 <20220303015327.k3fqkkxunm6kihjl@skbuf>
 <Yjii20KryAsEQp1k@Ansuel-xps.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Yjii20KryAsEQp1k@Ansuel-xps.localdomain>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Mar 21, 2022 at 05:07:55PM +0100, Ansuel Smith wrote:
> On Thu, Mar 03, 2022 at 03:53:27AM +0200, Vladimir Oltean wrote:
> > On Mon, Feb 28, 2022 at 12:04:08PM +0100, Ansuel Smith wrote:
> > > Pack qca8k priv and other struct using pahole and set the first priv
> > > struct entry to mgmt_master and mgmt_eth_data to speedup access.
> > > While at it also rework pcs struct and move it qca8k_ports_config
> > > following other configuration set for the cpu ports.
> > > 
> > > Signed-off-by: Ansuel Smith <ansuelsmth@gmail.com>
> > > ---
> > 
> > How did you "pack" struct qca8k_priv exactly?
> >
> 
> I'm trying to understand it too... also this was done basend on what
> target? 

I used an arm64 toolchain, if that's what you're asking.

> > Before:
> > 
> > struct qca8k_priv {
> >         u8                         switch_id;            /*     0     1 */
> >         u8                         switch_revision;      /*     1     1 */
> >         u8                         mirror_rx;            /*     2     1 */
> >         u8                         mirror_tx;            /*     3     1 */
> >         u8                         lag_hash_mode;        /*     4     1 */
> >         bool                       legacy_phy_port_mapping; /*     5     1 */
> >         struct qca8k_ports_config  ports_config;         /*     6     7 */
> > 
> >         /* XXX 3 bytes hole, try to pack */
> > 
> >         struct regmap *            regmap;               /*    16     8 */
> >         struct mii_bus *           bus;                  /*    24     8 */
> >         struct ar8xxx_port_status  port_sts[7];          /*    32    28 */
> > 
> >         /* XXX 4 bytes hole, try to pack */
> > 
> >         /* --- cacheline 1 boundary (64 bytes) --- */
> >         struct dsa_switch *        ds;                   /*    64     8 */
> >         struct mutex               reg_mutex;            /*    72   160 */
> >         /* --- cacheline 3 boundary (192 bytes) was 40 bytes ago --- */
> >         struct device *            dev;                  /*   232     8 */
> >         struct dsa_switch_ops      ops;                  /*   240   864 */
> >         /* --- cacheline 17 boundary (1088 bytes) was 16 bytes ago --- */
> >         struct gpio_desc *         reset_gpio;           /*  1104     8 */
> >         unsigned int               port_mtu[7];          /*  1112    28 */
> > 
> >         /* XXX 4 bytes hole, try to pack */
> > 
> >         struct net_device *        mgmt_master;          /*  1144     8 */
> >         /* --- cacheline 18 boundary (1152 bytes) --- */
> >         struct qca8k_mgmt_eth_data mgmt_eth_data;        /*  1152   280 */
> >         /* --- cacheline 22 boundary (1408 bytes) was 24 bytes ago --- */
> >         struct qca8k_mib_eth_data  mib_eth_data;         /*  1432   272 */
> >         /* --- cacheline 26 boundary (1664 bytes) was 40 bytes ago --- */
> >         struct qca8k_mdio_cache    mdio_cache;           /*  1704     6 */
> > 
> >         /* XXX 2 bytes hole, try to pack */
> > 
> >         struct qca8k_pcs           pcs_port_0;           /*  1712    32 */
> > 
> >         /* XXX last struct has 4 bytes of padding */
> > 
> >         /* --- cacheline 27 boundary (1728 bytes) was 16 bytes ago --- */
> >         struct qca8k_pcs           pcs_port_6;           /*  1744    32 */
> > 
> >         /* XXX last struct has 4 bytes of padding */
> > 
> >         /* size: 1776, cachelines: 28, members: 22 */
> >         /* sum members: 1763, holes: 4, sum holes: 13 */
> >         /* paddings: 2, sum paddings: 8 */
> >         /* last cacheline: 48 bytes */
> > };
> > 
> > After:
> > 
> > struct qca8k_priv {
> >         struct net_device *        mgmt_master;          /*     0     8 */
> >         struct qca8k_mgmt_eth_data mgmt_eth_data;        /*     8   280 */
> >         /* --- cacheline 4 boundary (256 bytes) was 32 bytes ago --- */
> >         struct qca8k_mdio_cache    mdio_cache;           /*   288     6 */
> >         u8                         switch_id;            /*   294     1 */
> >         u8                         switch_revision;      /*   295     1 */
> >         u8                         mirror_rx;            /*   296     1 */
> >         u8                         mirror_tx;            /*   297     1 */
> >         u8                         lag_hash_mode;        /*   298     1 */
> >         bool                       legacy_phy_port_mapping; /*   299     1 */
> > 
> >         /* XXX 4 bytes hole, try to pack */
> > 
> >         struct qca8k_ports_config  ports_config;         /*   304    72 */
> >         /* --- cacheline 5 boundary (320 bytes) was 56 bytes ago --- */
> >         struct regmap *            regmap;               /*   376     8 */
> >         /* --- cacheline 6 boundary (384 bytes) --- */
> >         struct mii_bus *           bus;                  /*   384     8 */
> >         struct ar8xxx_port_status  port_sts[7];          /*   392    28 */
> > 
> >         /* XXX 4 bytes hole, try to pack */
> > 
> >         struct dsa_switch *        ds;                   /*   424     8 */
> >         struct mutex               reg_mutex;            /*   432   160 */
> >         /* --- cacheline 9 boundary (576 bytes) was 16 bytes ago --- */
> >         struct device *            dev;                  /*   592     8 */
> >         struct gpio_desc *         reset_gpio;           /*   600     8 */
> >         struct dsa_switch_ops      ops;                  /*   608   864 */
> >         /* --- cacheline 23 boundary (1472 bytes) --- */
> >         struct qca8k_mib_eth_data  mib_eth_data;         /*  1472   280 */
> > 
> >         /* XXX last struct has 4 bytes of padding */
> > 
> >         /* --- cacheline 27 boundary (1728 bytes) was 24 bytes ago --- */
> >         unsigned int               port_mtu[7];          /*  1752    28 */
> > 
> >         /* size: 1784, cachelines: 28, members: 20 */
> >         /* sum members: 1772, holes: 2, sum holes: 8 */
> >         /* padding: 4 */
> >         /* paddings: 1, sum paddings: 4 */
> >         /* last cacheline: 56 bytes */
> > };
> > 
> > 1776 vs 1784. That's... larger?!
> > 
> > Also, struct qca8k_priv is so large because the "ops" member is a full
> > copy of qca8k_switch_ops. I understand why commit db460c54b67f ("net:
> > dsa: qca8k: extend slave-bus implementations") did this, but I wonder,
> > is there no better way?
> > 
> 
> Actually from what I can see the struct can be improved in 2 way...
> The ancient struct
> ar8xxx_port_status port_sts[QCA8K_NUM_PORTS];
> can be totally dropped as I can't see why we still need it.
> 
> The duplicated ops is funny. I could be very confused but why it's done
> like that? Can't we modify directly the already defined one and drop
> struct dsa_switch_ops ops; from qca8k_priv?

Simply put, qca8k_switch_ops is per kernel, priv->ops is per driver
instance.

> I mean is all of that to use priv->ops.phy_read instead of
> priv->ds->ops.phy_read or even qca8k_switch_ops directly? o.o
> 
> Am I missing something?

The thing is that qca8k_setup_mdio_bus() wants DSA to use the
legacy_phy_port_mapping only as a fallback. DSA uses this simplistic
condition:

dsa_switch_setup():
	if (!ds->slave_mii_bus && ds->ops->phy_read) {
		ds->slave_mii_bus = mdiobus_alloc();

You might be tempted to say: hey, qca8k_mdio_register() populates
ds->slave_mii_bus to an MDIO bus allocated by itself. So you'd be able
to prune the mdiobus_alloc() because the first part of the condition is
false.

But dsa_switch_teardown() has:

	if (ds->slave_mii_bus && ds->ops->phy_read) {
		mdiobus_unregister(ds->slave_mii_bus);

In other words, dsa_switch_teardown() has lost track of who allocated
the MDIO bus - it assumes that the DSA core has. That will conflict with
qca8k which uses devres, so it would result in double free.

So that's basically what the problem is. The qca8k driver needs to have
a NULL ds->ops->phy_read if it doesn't use the legacy_phy_port_mapping,
so it won't confuse the DSA core.

Please note that I'm not really too familiar with this part of the DSA
core since I don't have any hardware that makes any use of ds->slave_mii_bus.

> > >  drivers/net/dsa/qca8k.c |  8 ++++----
> > >  drivers/net/dsa/qca8k.h | 33 ++++++++++++++++-----------------
> > >  2 files changed, 20 insertions(+), 21 deletions(-)
> > > 
> > > diff --git a/drivers/net/dsa/qca8k.c b/drivers/net/dsa/qca8k.c
> > > index ee0dbf324268..8d059da5f0ca 100644
> > > --- a/drivers/net/dsa/qca8k.c
> > > +++ b/drivers/net/dsa/qca8k.c
> > > @@ -1685,11 +1685,11 @@ qca8k_phylink_mac_select_pcs(struct dsa_switch *ds, int port,
> > >  	case PHY_INTERFACE_MODE_1000BASEX:
> > >  		switch (port) {
> > >  		case 0:
> > > -			pcs = &priv->pcs_port_0.pcs;
> > > +			pcs = &priv->ports_config.qpcs[QCA8K_CPU_PORT0].pcs;
> > >  			break;
> > >  
> > >  		case 6:
> > > -			pcs = &priv->pcs_port_6.pcs;
> > > +			pcs = &priv->ports_config.qpcs[QCA8K_CPU_PORT6].pcs;
> > >  			break;
> > >  		}
> > >  		break;
> > > @@ -2889,8 +2889,8 @@ qca8k_setup(struct dsa_switch *ds)
> > >  	if (ret)
> > >  		return ret;
> > >  
> > > -	qca8k_setup_pcs(priv, &priv->pcs_port_0, 0);
> > > -	qca8k_setup_pcs(priv, &priv->pcs_port_6, 6);
> > > +	qca8k_setup_pcs(priv, &priv->ports_config.qpcs[QCA8K_CPU_PORT0], 0);
> > > +	qca8k_setup_pcs(priv, &priv->ports_config.qpcs[QCA8K_CPU_PORT6], 6);
> > >  
> > >  	/* Make sure MAC06 is disabled */
> > >  	ret = regmap_clear_bits(priv->regmap, QCA8K_REG_PORT0_PAD_CTRL,
> > > diff --git a/drivers/net/dsa/qca8k.h b/drivers/net/dsa/qca8k.h
> > > index f375627174c8..611dc2335dbe 100644
> > > --- a/drivers/net/dsa/qca8k.h
> > > +++ b/drivers/net/dsa/qca8k.h
> > > @@ -341,18 +341,24 @@ enum {
> > >  
> > >  struct qca8k_mgmt_eth_data {
> > >  	struct completion rw_done;
> > > -	struct mutex mutex; /* Enforce one mdio read/write at time */
> > > +	u32 data[4];
> > >  	bool ack;
> > >  	u32 seq;
> > > -	u32 data[4];
> > > +	struct mutex mutex; /* Enforce one mdio read/write at time */
> > >  };
> > >  
> > >  struct qca8k_mib_eth_data {
> > >  	struct completion rw_done;
> > > +	u64 *data; /* pointer to ethtool data */
> > > +	u8 req_port;
> > >  	struct mutex mutex; /* Process one command at time */
> > >  	refcount_t port_parsed; /* Counter to track parsed port */
> > > -	u8 req_port;
> > > -	u64 *data; /* pointer to ethtool data */
> > > +};
> > > +
> > > +struct qca8k_pcs {
> > > +	struct phylink_pcs pcs;
> > > +	struct qca8k_priv *priv;
> > > +	int port;
> > >  };
> > >  
> > >  struct qca8k_ports_config {
> > > @@ -361,6 +367,7 @@ struct qca8k_ports_config {
> > >  	bool sgmii_enable_pll;
> > >  	u8 rgmii_rx_delay[QCA8K_NUM_CPU_PORTS]; /* 0: CPU port0, 1: CPU port6 */
> > >  	u8 rgmii_tx_delay[QCA8K_NUM_CPU_PORTS]; /* 0: CPU port0, 1: CPU port6 */
> > > +	struct qca8k_pcs qpcs[QCA8K_NUM_CPU_PORTS];
> > >  };
> > >  
> > >  struct qca8k_mdio_cache {
> > > @@ -376,13 +383,10 @@ struct qca8k_mdio_cache {
> > >  	u16 hi;
> > >  };
> > >  
> > > -struct qca8k_pcs {
> > > -	struct phylink_pcs pcs;
> > > -	struct qca8k_priv *priv;
> > > -	int port;
> > > -};
> > > -
> > >  struct qca8k_priv {
> > > +	struct net_device *mgmt_master; /* Track if mdio/mib Ethernet is available */
> > > +	struct qca8k_mgmt_eth_data mgmt_eth_data;
> > > +	struct qca8k_mdio_cache mdio_cache;
> > >  	u8 switch_id;
> > >  	u8 switch_revision;
> > >  	u8 mirror_rx;
> > > @@ -396,15 +400,10 @@ struct qca8k_priv {
> > >  	struct dsa_switch *ds;
> > >  	struct mutex reg_mutex;
> > >  	struct device *dev;
> > > -	struct dsa_switch_ops ops;
> > >  	struct gpio_desc *reset_gpio;
> > > -	unsigned int port_mtu[QCA8K_NUM_PORTS];
> > > -	struct net_device *mgmt_master; /* Track if mdio/mib Ethernet is available */
> > > -	struct qca8k_mgmt_eth_data mgmt_eth_data;
> > > +	struct dsa_switch_ops ops;
> > >  	struct qca8k_mib_eth_data mib_eth_data;
> > > -	struct qca8k_mdio_cache mdio_cache;
> > > -	struct qca8k_pcs pcs_port_0;
> > > -	struct qca8k_pcs pcs_port_6;
> > > +	unsigned int port_mtu[QCA8K_NUM_PORTS];
> > >  };
> > >  
> > >  struct qca8k_mib_desc {
> > > -- 
> > > 2.34.1
> > > 
> > 
> 
> -- 
> 	Ansuel

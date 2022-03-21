Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 808884E2F8A
	for <lists+netdev@lfdr.de>; Mon, 21 Mar 2022 19:01:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351941AbiCUSCQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Mar 2022 14:02:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46188 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351944AbiCUSCP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Mar 2022 14:02:15 -0400
Received: from mail-wm1-x330.google.com (mail-wm1-x330.google.com [IPv6:2a00:1450:4864:20::330])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D6CC7171783;
        Mon, 21 Mar 2022 11:00:48 -0700 (PDT)
Received: by mail-wm1-x330.google.com with SMTP id l7-20020a05600c1d0700b0038c99618859so5696wms.2;
        Mon, 21 Mar 2022 11:00:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=MmvC6yte+guAWKHqyBn7ZvgA2PwGYsPw2bp5ki62SkA=;
        b=Yegm9XfSxVqsDP24jck/dJZfiwJCsqefq4ubVrun097AMzTN6mnIDe6IsDbDn40qz3
         ww8z+oWnjUN/WXq7UDB+dMJPdwfegQaXknJ+bqOUZgkavkfhTXUJcMD7YbOWIDpHdbSb
         gS8maY2hfryLBKrC1+X1ICTzYLTy1klx7/a0CwgyhyHd2/9l8xV8yxMsBrQx3zeYMG6U
         OzNzlY+3GqhAV5VtODt2U6uxp4DJjBg3oNoN1HeMLxNmrRlDjJ5NpTSziZNjkhDdzM4t
         Cg9rFW+b4oQJf2cy8Gq9gbs3StXyuuo+BlHTOoG/E8HfqXk2ql2r622Y3ZpcaA2XTM06
         yj2Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=MmvC6yte+guAWKHqyBn7ZvgA2PwGYsPw2bp5ki62SkA=;
        b=dWKNw/I1VRRDsy21gzy1/VQR1L3sVMNFMSmtndUsN0m+lyU0XkCnw/ugweRuHRi98r
         w3KZPVREl/6o9j53vCiK8ah48XkqJkALO9tjCM1SE14qAviax1oqOUFENcTjZpkGgJdZ
         5OYSZwioIdwy5PL4PJ2fwvNBDO3LhuW/RGKeNxpF1545AJjKj8mizooGuDToaMrqrOyc
         HDomBIC7vDuugEfmQ5oOlxJ6Nn3azqIC4hOI+I1IDiL42bGi2b85YyWum2ao1JsxmK9d
         zh6Wt2E8gXvvYMbem1AS2HI4cSYenu2HIaKa+Nu+wCE2iFb5qQiW4VmrBW/PKG8FDIVe
         hPcw==
X-Gm-Message-State: AOAM532pRdTp34L1wAD1ysKHhtEffHMFqDQQLZSUXlGYFP+oI95naxuU
        oporOTHJ1kZ0JY4WVhbGlTk=
X-Google-Smtp-Source: ABdhPJx5EaUYmESCcyMShKFT7TfAUbHhxkvpyRs3Amff9F/a61pL887gC/e8bHrDy8dKkQ65E/dfpg==
X-Received: by 2002:a1c:ed18:0:b0:37e:7a1d:a507 with SMTP id l24-20020a1ced18000000b0037e7a1da507mr237219wmh.187.1647885646970;
        Mon, 21 Mar 2022 11:00:46 -0700 (PDT)
Received: from Ansuel-xps.localdomain (93-42-69-170.ip85.fastwebnet.it. [93.42.69.170])
        by smtp.gmail.com with ESMTPSA id u12-20020a5d6dac000000b00204119d37d0sm3528437wrs.26.2022.03.21.11.00.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 21 Mar 2022 11:00:46 -0700 (PDT)
Date:   Mon, 21 Mar 2022 18:31:27 +0100
From:   Ansuel Smith <ansuelsmth@gmail.com>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Russell King <linux@armlinux.org.uk>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [net-next PATCH v2] net: dsa: qca8k: pack driver struct and
 improve cache use
Message-ID: <Yji2b6XF13E1o2x3@Ansuel-xps.localdomain>
References: <20220228110408.4903-1-ansuelsmth@gmail.com>
 <20220303015327.k3fqkkxunm6kihjl@skbuf>
 <Yjii20KryAsEQp1k@Ansuel-xps.localdomain>
 <20220321172200.eaccmwzfvtw7bjs2@skbuf>
 <Yji1QAMe/efWLBQE@Ansuel-xps.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Yji1QAMe/efWLBQE@Ansuel-xps.localdomain>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Mar 21, 2022 at 06:26:24PM +0100, Ansuel Smith wrote:
> On Mon, Mar 21, 2022 at 07:22:00PM +0200, Vladimir Oltean wrote:
> > On Mon, Mar 21, 2022 at 05:07:55PM +0100, Ansuel Smith wrote:
> > > On Thu, Mar 03, 2022 at 03:53:27AM +0200, Vladimir Oltean wrote:
> > > > On Mon, Feb 28, 2022 at 12:04:08PM +0100, Ansuel Smith wrote:
> > > > > Pack qca8k priv and other struct using pahole and set the first priv
> > > > > struct entry to mgmt_master and mgmt_eth_data to speedup access.
> > > > > While at it also rework pcs struct and move it qca8k_ports_config
> > > > > following other configuration set for the cpu ports.
> > > > > 
> > > > > Signed-off-by: Ansuel Smith <ansuelsmth@gmail.com>
> > > > > ---
> > > > 
> > > > How did you "pack" struct qca8k_priv exactly?
> > > >
> > > 
> > > I'm trying to understand it too... also this was done basend on what
> > > target? 
> > 
> > I used an arm64 toolchain, if that's what you're asking.
> >
> 
> That could be the reason of different results. Qca8k is mostly used on
> 32bit systems with 4byte cache wonder. That could be the reason i have
> different results and on a system like that it did suggest this order?
> 
> > > > Before:
> > > > 
> > > > struct qca8k_priv {
> > > >         u8                         switch_id;            /*     0     1 */
> > > >         u8                         switch_revision;      /*     1     1 */
> > > >         u8                         mirror_rx;            /*     2     1 */
> > > >         u8                         mirror_tx;            /*     3     1 */
> > > >         u8                         lag_hash_mode;        /*     4     1 */
> > > >         bool                       legacy_phy_port_mapping; /*     5     1 */
> > > >         struct qca8k_ports_config  ports_config;         /*     6     7 */
> > > > 
> > > >         /* XXX 3 bytes hole, try to pack */
> > > > 
> > > >         struct regmap *            regmap;               /*    16     8 */
> > > >         struct mii_bus *           bus;                  /*    24     8 */
> > > >         struct ar8xxx_port_status  port_sts[7];          /*    32    28 */
> > > > 
> > > >         /* XXX 4 bytes hole, try to pack */
> > > > 
> > > >         /* --- cacheline 1 boundary (64 bytes) --- */
> > > >         struct dsa_switch *        ds;                   /*    64     8 */
> > > >         struct mutex               reg_mutex;            /*    72   160 */
> > > >         /* --- cacheline 3 boundary (192 bytes) was 40 bytes ago --- */
> > > >         struct device *            dev;                  /*   232     8 */
> > > >         struct dsa_switch_ops      ops;                  /*   240   864 */
> > > >         /* --- cacheline 17 boundary (1088 bytes) was 16 bytes ago --- */
> > > >         struct gpio_desc *         reset_gpio;           /*  1104     8 */
> > > >         unsigned int               port_mtu[7];          /*  1112    28 */
> > > > 
> > > >         /* XXX 4 bytes hole, try to pack */
> > > > 
> > > >         struct net_device *        mgmt_master;          /*  1144     8 */
> > > >         /* --- cacheline 18 boundary (1152 bytes) --- */
> > > >         struct qca8k_mgmt_eth_data mgmt_eth_data;        /*  1152   280 */
> > > >         /* --- cacheline 22 boundary (1408 bytes) was 24 bytes ago --- */
> > > >         struct qca8k_mib_eth_data  mib_eth_data;         /*  1432   272 */
> > > >         /* --- cacheline 26 boundary (1664 bytes) was 40 bytes ago --- */
> > > >         struct qca8k_mdio_cache    mdio_cache;           /*  1704     6 */
> > > > 
> > > >         /* XXX 2 bytes hole, try to pack */
> > > > 
> > > >         struct qca8k_pcs           pcs_port_0;           /*  1712    32 */
> > > > 
> > > >         /* XXX last struct has 4 bytes of padding */
> > > > 
> > > >         /* --- cacheline 27 boundary (1728 bytes) was 16 bytes ago --- */
> > > >         struct qca8k_pcs           pcs_port_6;           /*  1744    32 */
> > > > 
> > > >         /* XXX last struct has 4 bytes of padding */
> > > > 
> > > >         /* size: 1776, cachelines: 28, members: 22 */
> > > >         /* sum members: 1763, holes: 4, sum holes: 13 */
> > > >         /* paddings: 2, sum paddings: 8 */
> > > >         /* last cacheline: 48 bytes */
> > > > };
> > > > 
> > > > After:
> > > > 
> > > > struct qca8k_priv {
> > > >         struct net_device *        mgmt_master;          /*     0     8 */
> > > >         struct qca8k_mgmt_eth_data mgmt_eth_data;        /*     8   280 */
> > > >         /* --- cacheline 4 boundary (256 bytes) was 32 bytes ago --- */
> > > >         struct qca8k_mdio_cache    mdio_cache;           /*   288     6 */
> > > >         u8                         switch_id;            /*   294     1 */
> > > >         u8                         switch_revision;      /*   295     1 */
> > > >         u8                         mirror_rx;            /*   296     1 */
> > > >         u8                         mirror_tx;            /*   297     1 */
> > > >         u8                         lag_hash_mode;        /*   298     1 */
> > > >         bool                       legacy_phy_port_mapping; /*   299     1 */
> > > > 
> > > >         /* XXX 4 bytes hole, try to pack */
> > > > 
> > > >         struct qca8k_ports_config  ports_config;         /*   304    72 */
> > > >         /* --- cacheline 5 boundary (320 bytes) was 56 bytes ago --- */
> > > >         struct regmap *            regmap;               /*   376     8 */
> > > >         /* --- cacheline 6 boundary (384 bytes) --- */
> > > >         struct mii_bus *           bus;                  /*   384     8 */
> > > >         struct ar8xxx_port_status  port_sts[7];          /*   392    28 */
> > > > 
> > > >         /* XXX 4 bytes hole, try to pack */
> > > > 
> > > >         struct dsa_switch *        ds;                   /*   424     8 */
> > > >         struct mutex               reg_mutex;            /*   432   160 */
> > > >         /* --- cacheline 9 boundary (576 bytes) was 16 bytes ago --- */
> > > >         struct device *            dev;                  /*   592     8 */
> > > >         struct gpio_desc *         reset_gpio;           /*   600     8 */
> > > >         struct dsa_switch_ops      ops;                  /*   608   864 */
> > > >         /* --- cacheline 23 boundary (1472 bytes) --- */
> > > >         struct qca8k_mib_eth_data  mib_eth_data;         /*  1472   280 */
> > > > 
> > > >         /* XXX last struct has 4 bytes of padding */
> > > > 
> > > >         /* --- cacheline 27 boundary (1728 bytes) was 24 bytes ago --- */
> > > >         unsigned int               port_mtu[7];          /*  1752    28 */
> > > > 
> > > >         /* size: 1784, cachelines: 28, members: 20 */
> > > >         /* sum members: 1772, holes: 2, sum holes: 8 */
> > > >         /* padding: 4 */
> > > >         /* paddings: 1, sum paddings: 4 */
> > > >         /* last cacheline: 56 bytes */
> > > > };
> > > > 
> > > > 1776 vs 1784. That's... larger?!
> > > > 
> > > > Also, struct qca8k_priv is so large because the "ops" member is a full
> > > > copy of qca8k_switch_ops. I understand why commit db460c54b67f ("net:
> > > > dsa: qca8k: extend slave-bus implementations") did this, but I wonder,
> > > > is there no better way?
> > > > 
> > > 
> > > Actually from what I can see the struct can be improved in 2 way...
> > > The ancient struct
> > > ar8xxx_port_status port_sts[QCA8K_NUM_PORTS];
> > > can be totally dropped as I can't see why we still need it.
> > > 
> > > The duplicated ops is funny. I could be very confused but why it's done
> > > like that? Can't we modify directly the already defined one and drop
> > > struct dsa_switch_ops ops; from qca8k_priv?
> > 
> > Simply put, qca8k_switch_ops is per kernel, priv->ops is per driver
> > instance.
> > 
> 
> Right I totally missed that.
> 
> > > I mean is all of that to use priv->ops.phy_read instead of
> > > priv->ds->ops.phy_read or even qca8k_switch_ops directly? o.o
> > > 
> > > Am I missing something?
> > 
> > The thing is that qca8k_setup_mdio_bus() wants DSA to use the
> > legacy_phy_port_mapping only as a fallback. DSA uses this simplistic
> > condition:
> > 
> > dsa_switch_setup():
> > 	if (!ds->slave_mii_bus && ds->ops->phy_read) {
> > 		ds->slave_mii_bus = mdiobus_alloc();
> > 
> > You might be tempted to say: hey, qca8k_mdio_register() populates
> > ds->slave_mii_bus to an MDIO bus allocated by itself. So you'd be able
> > to prune the mdiobus_alloc() because the first part of the condition is
> > false.
> > 
> > But dsa_switch_teardown() has:
> > 
> > 	if (ds->slave_mii_bus && ds->ops->phy_read) {
> > 		mdiobus_unregister(ds->slave_mii_bus);
> > 
> > In other words, dsa_switch_teardown() has lost track of who allocated
> > the MDIO bus - it assumes that the DSA core has. That will conflict with
> > qca8k which uses devres, so it would result in double free.
> > 
> > So that's basically what the problem is. The qca8k driver needs to have
> > a NULL ds->ops->phy_read if it doesn't use the legacy_phy_port_mapping,
> > so it won't confuse the DSA core.
> > 
> > Please note that I'm not really too familiar with this part of the DSA
> > core since I don't have any hardware that makes any use of ds->slave_mii_bus.
> > 
> 
> Ok now I see the problem. Thx for the good explaination. I wonder...
> Should I use the easy path and just drop phy_read/write? Qca8k already
> allocate a dedicated mdio for the same task... Should I just add some
> check and make the dedicated mdio register without the OF API when it's
> in legacy mode?
> 
> I think that at times the idea of that patch was to try to use as much
> as possible generic dsa ops but if that would result in having the big
> ops duplicated for every switch that doesn't seems that optmizied.
> 
> An alternative would be adding an additional flag to dsa to control how
> DSA should handle slave_mii_bus. But I assume a solution like that would
> be directly NACK as it's just an hack for a driver to save some space.
> 
> Or now that I think about it generilize all of this and add some API to
> DSA to register an mdiobus with an mdio node if provided. Or even
> provide some way to make the driver decide what to do... Some type of
> configuration? Is it overkill or other driver would benefit from this?
> Do we have other driver that declare a custom mdiobus instead of using
> phy_read/write?
>

I just checked we have 4 driver that implement custom mdiobus using an
of node and would benefit from this... Still don't know if it would be a
good solution.

> > > > >  drivers/net/dsa/qca8k.c |  8 ++++----
> > > > >  drivers/net/dsa/qca8k.h | 33 ++++++++++++++++-----------------
> > > > >  2 files changed, 20 insertions(+), 21 deletions(-)
> > > > > 
> > > > > diff --git a/drivers/net/dsa/qca8k.c b/drivers/net/dsa/qca8k.c
> > > > > index ee0dbf324268..8d059da5f0ca 100644
> > > > > --- a/drivers/net/dsa/qca8k.c
> > > > > +++ b/drivers/net/dsa/qca8k.c
> > > > > @@ -1685,11 +1685,11 @@ qca8k_phylink_mac_select_pcs(struct dsa_switch *ds, int port,
> > > > >  	case PHY_INTERFACE_MODE_1000BASEX:
> > > > >  		switch (port) {
> > > > >  		case 0:
> > > > > -			pcs = &priv->pcs_port_0.pcs;
> > > > > +			pcs = &priv->ports_config.qpcs[QCA8K_CPU_PORT0].pcs;
> > > > >  			break;
> > > > >  
> > > > >  		case 6:
> > > > > -			pcs = &priv->pcs_port_6.pcs;
> > > > > +			pcs = &priv->ports_config.qpcs[QCA8K_CPU_PORT6].pcs;
> > > > >  			break;
> > > > >  		}
> > > > >  		break;
> > > > > @@ -2889,8 +2889,8 @@ qca8k_setup(struct dsa_switch *ds)
> > > > >  	if (ret)
> > > > >  		return ret;
> > > > >  
> > > > > -	qca8k_setup_pcs(priv, &priv->pcs_port_0, 0);
> > > > > -	qca8k_setup_pcs(priv, &priv->pcs_port_6, 6);
> > > > > +	qca8k_setup_pcs(priv, &priv->ports_config.qpcs[QCA8K_CPU_PORT0], 0);
> > > > > +	qca8k_setup_pcs(priv, &priv->ports_config.qpcs[QCA8K_CPU_PORT6], 6);
> > > > >  
> > > > >  	/* Make sure MAC06 is disabled */
> > > > >  	ret = regmap_clear_bits(priv->regmap, QCA8K_REG_PORT0_PAD_CTRL,
> > > > > diff --git a/drivers/net/dsa/qca8k.h b/drivers/net/dsa/qca8k.h
> > > > > index f375627174c8..611dc2335dbe 100644
> > > > > --- a/drivers/net/dsa/qca8k.h
> > > > > +++ b/drivers/net/dsa/qca8k.h
> > > > > @@ -341,18 +341,24 @@ enum {
> > > > >  
> > > > >  struct qca8k_mgmt_eth_data {
> > > > >  	struct completion rw_done;
> > > > > -	struct mutex mutex; /* Enforce one mdio read/write at time */
> > > > > +	u32 data[4];
> > > > >  	bool ack;
> > > > >  	u32 seq;
> > > > > -	u32 data[4];
> > > > > +	struct mutex mutex; /* Enforce one mdio read/write at time */
> > > > >  };
> > > > >  
> > > > >  struct qca8k_mib_eth_data {
> > > > >  	struct completion rw_done;
> > > > > +	u64 *data; /* pointer to ethtool data */
> > > > > +	u8 req_port;
> > > > >  	struct mutex mutex; /* Process one command at time */
> > > > >  	refcount_t port_parsed; /* Counter to track parsed port */
> > > > > -	u8 req_port;
> > > > > -	u64 *data; /* pointer to ethtool data */
> > > > > +};
> > > > > +
> > > > > +struct qca8k_pcs {
> > > > > +	struct phylink_pcs pcs;
> > > > > +	struct qca8k_priv *priv;
> > > > > +	int port;
> > > > >  };
> > > > >  
> > > > >  struct qca8k_ports_config {
> > > > > @@ -361,6 +367,7 @@ struct qca8k_ports_config {
> > > > >  	bool sgmii_enable_pll;
> > > > >  	u8 rgmii_rx_delay[QCA8K_NUM_CPU_PORTS]; /* 0: CPU port0, 1: CPU port6 */
> > > > >  	u8 rgmii_tx_delay[QCA8K_NUM_CPU_PORTS]; /* 0: CPU port0, 1: CPU port6 */
> > > > > +	struct qca8k_pcs qpcs[QCA8K_NUM_CPU_PORTS];
> > > > >  };
> > > > >  
> > > > >  struct qca8k_mdio_cache {
> > > > > @@ -376,13 +383,10 @@ struct qca8k_mdio_cache {
> > > > >  	u16 hi;
> > > > >  };
> > > > >  
> > > > > -struct qca8k_pcs {
> > > > > -	struct phylink_pcs pcs;
> > > > > -	struct qca8k_priv *priv;
> > > > > -	int port;
> > > > > -};
> > > > > -
> > > > >  struct qca8k_priv {
> > > > > +	struct net_device *mgmt_master; /* Track if mdio/mib Ethernet is available */
> > > > > +	struct qca8k_mgmt_eth_data mgmt_eth_data;
> > > > > +	struct qca8k_mdio_cache mdio_cache;
> > > > >  	u8 switch_id;
> > > > >  	u8 switch_revision;
> > > > >  	u8 mirror_rx;
> > > > > @@ -396,15 +400,10 @@ struct qca8k_priv {
> > > > >  	struct dsa_switch *ds;
> > > > >  	struct mutex reg_mutex;
> > > > >  	struct device *dev;
> > > > > -	struct dsa_switch_ops ops;
> > > > >  	struct gpio_desc *reset_gpio;
> > > > > -	unsigned int port_mtu[QCA8K_NUM_PORTS];
> > > > > -	struct net_device *mgmt_master; /* Track if mdio/mib Ethernet is available */
> > > > > -	struct qca8k_mgmt_eth_data mgmt_eth_data;
> > > > > +	struct dsa_switch_ops ops;
> > > > >  	struct qca8k_mib_eth_data mib_eth_data;
> > > > > -	struct qca8k_mdio_cache mdio_cache;
> > > > > -	struct qca8k_pcs pcs_port_0;
> > > > > -	struct qca8k_pcs pcs_port_6;
> > > > > +	unsigned int port_mtu[QCA8K_NUM_PORTS];
> > > > >  };
> > > > >  
> > > > >  struct qca8k_mib_desc {
> > > > > -- 
> > > > > 2.34.1
> > > > > 
> > > > 
> > > 
> > > -- 
> > > 	Ansuel
> 
> -- 
> 	Ansuel

-- 
	Ansuel

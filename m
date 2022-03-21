Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 455BA4E2E2C
	for <lists+netdev@lfdr.de>; Mon, 21 Mar 2022 17:37:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351258AbiCUQio (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Mar 2022 12:38:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55704 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241534AbiCUQin (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Mar 2022 12:38:43 -0400
Received: from mail-wm1-x335.google.com (mail-wm1-x335.google.com [IPv6:2a00:1450:4864:20::335])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2EBCAED9DF;
        Mon, 21 Mar 2022 09:37:17 -0700 (PDT)
Received: by mail-wm1-x335.google.com with SMTP id bg31-20020a05600c3c9f00b00381590dbb33so8705757wmb.3;
        Mon, 21 Mar 2022 09:37:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=CR5MhstiautQ+fKo0102plnWfdRHnkKf/5yTqnlcE0Y=;
        b=Ygw7anaet6FzKMcreNetMcmSvYsQ2nE3AES8PzqVWlfid4Fn3IlD7aSbMq7k14XCwm
         jt7B73SYmymXM738S4I7e9xM86Ed8GLrAAgl0Vo76f4eZ2x+B+hovBAWNjRXmG0qKcEw
         2sRUuesnrrvO1u6K/fiKe9ytSq0ljYh2VcFvWYN23/TEiNUGck6Ols8Mh060+EVneig3
         q0oK4gUmWOSLJxEhllVIbbSZ2CUy0Wh7vahJxhu/kLH3oJ/GERSosq+nYQJ8IxrZGwrZ
         4XsEv951FBlOXVNkaDJNenl5bIZz+jwAqZBK66lGl958FGoXTs/JPJVwgpBv/3REfkLG
         byxg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=CR5MhstiautQ+fKo0102plnWfdRHnkKf/5yTqnlcE0Y=;
        b=sME/2rO3cPxA6eESTcmTfBWo5L6JGfbflpri1MQ6QYqZmENzJRP47m4ySpFmTqOrzD
         kjGw3xRkC9lYKtW+2vp/EFQAGVGHVEgbdcr4DYrVnD3p716Rla+EpJRr/4/b7cGRP/4w
         ge0nmI4JMDuhD/VCb0ZEkhdhdvvfvD4tilZWehlv9NQOF/lS5lNscl65FmSZiyyxNJIp
         PM4hTpedCCJua32hmCQawvFILS6q0xltfPOZ1NTM3SXglctfwuFhGEulSRmsjtrFk/Xc
         ZVf8CMHzWzvGDvhXww7yMM/IH/ddkZUAXz2+7H6w+h5cL3j6fYyLQJ9P22yBV5A5OkwO
         RD1A==
X-Gm-Message-State: AOAM531O8glLHL/wP22UqpLV4sO//J7TPPCB46ebfZrbNLpZwF9ArJQW
        ZdC9+33aAowPYOj89ZB5HQE=
X-Google-Smtp-Source: ABdhPJws43+PByf1nFz9BFFhtx17Jjxiu/klSS58SjNzfZPynJArDoCJb6L9T+lAc4m8l+8q5bSa/A==
X-Received: by 2002:a05:600c:1548:b0:389:cde3:35cc with SMTP id f8-20020a05600c154800b00389cde335ccmr27858632wmg.133.1647880635504;
        Mon, 21 Mar 2022 09:37:15 -0700 (PDT)
Received: from Ansuel-xps.localdomain (93-42-69-170.ip85.fastwebnet.it. [93.42.69.170])
        by smtp.gmail.com with ESMTPSA id m23-20020a05600c3b1700b0038bbd24f401sm311178wms.2.2022.03.21.09.37.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 21 Mar 2022 09:37:15 -0700 (PDT)
Date:   Mon, 21 Mar 2022 17:07:55 +0100
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
Message-ID: <Yjii20KryAsEQp1k@Ansuel-xps.localdomain>
References: <20220228110408.4903-1-ansuelsmth@gmail.com>
 <20220303015327.k3fqkkxunm6kihjl@skbuf>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220303015327.k3fqkkxunm6kihjl@skbuf>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Mar 03, 2022 at 03:53:27AM +0200, Vladimir Oltean wrote:
> On Mon, Feb 28, 2022 at 12:04:08PM +0100, Ansuel Smith wrote:
> > Pack qca8k priv and other struct using pahole and set the first priv
> > struct entry to mgmt_master and mgmt_eth_data to speedup access.
> > While at it also rework pcs struct and move it qca8k_ports_config
> > following other configuration set for the cpu ports.
> > 
> > Signed-off-by: Ansuel Smith <ansuelsmth@gmail.com>
> > ---
> 
> How did you "pack" struct qca8k_priv exactly?
>

I'm trying to understand it too... also this was done basend on what
target? 

> Before:
> 
> struct qca8k_priv {
>         u8                         switch_id;            /*     0     1 */
>         u8                         switch_revision;      /*     1     1 */
>         u8                         mirror_rx;            /*     2     1 */
>         u8                         mirror_tx;            /*     3     1 */
>         u8                         lag_hash_mode;        /*     4     1 */
>         bool                       legacy_phy_port_mapping; /*     5     1 */
>         struct qca8k_ports_config  ports_config;         /*     6     7 */
> 
>         /* XXX 3 bytes hole, try to pack */
> 
>         struct regmap *            regmap;               /*    16     8 */
>         struct mii_bus *           bus;                  /*    24     8 */
>         struct ar8xxx_port_status  port_sts[7];          /*    32    28 */
> 
>         /* XXX 4 bytes hole, try to pack */
> 
>         /* --- cacheline 1 boundary (64 bytes) --- */
>         struct dsa_switch *        ds;                   /*    64     8 */
>         struct mutex               reg_mutex;            /*    72   160 */
>         /* --- cacheline 3 boundary (192 bytes) was 40 bytes ago --- */
>         struct device *            dev;                  /*   232     8 */
>         struct dsa_switch_ops      ops;                  /*   240   864 */
>         /* --- cacheline 17 boundary (1088 bytes) was 16 bytes ago --- */
>         struct gpio_desc *         reset_gpio;           /*  1104     8 */
>         unsigned int               port_mtu[7];          /*  1112    28 */
> 
>         /* XXX 4 bytes hole, try to pack */
> 
>         struct net_device *        mgmt_master;          /*  1144     8 */
>         /* --- cacheline 18 boundary (1152 bytes) --- */
>         struct qca8k_mgmt_eth_data mgmt_eth_data;        /*  1152   280 */
>         /* --- cacheline 22 boundary (1408 bytes) was 24 bytes ago --- */
>         struct qca8k_mib_eth_data  mib_eth_data;         /*  1432   272 */
>         /* --- cacheline 26 boundary (1664 bytes) was 40 bytes ago --- */
>         struct qca8k_mdio_cache    mdio_cache;           /*  1704     6 */
> 
>         /* XXX 2 bytes hole, try to pack */
> 
>         struct qca8k_pcs           pcs_port_0;           /*  1712    32 */
> 
>         /* XXX last struct has 4 bytes of padding */
> 
>         /* --- cacheline 27 boundary (1728 bytes) was 16 bytes ago --- */
>         struct qca8k_pcs           pcs_port_6;           /*  1744    32 */
> 
>         /* XXX last struct has 4 bytes of padding */
> 
>         /* size: 1776, cachelines: 28, members: 22 */
>         /* sum members: 1763, holes: 4, sum holes: 13 */
>         /* paddings: 2, sum paddings: 8 */
>         /* last cacheline: 48 bytes */
> };
> 
> After:
> 
> struct qca8k_priv {
>         struct net_device *        mgmt_master;          /*     0     8 */
>         struct qca8k_mgmt_eth_data mgmt_eth_data;        /*     8   280 */
>         /* --- cacheline 4 boundary (256 bytes) was 32 bytes ago --- */
>         struct qca8k_mdio_cache    mdio_cache;           /*   288     6 */
>         u8                         switch_id;            /*   294     1 */
>         u8                         switch_revision;      /*   295     1 */
>         u8                         mirror_rx;            /*   296     1 */
>         u8                         mirror_tx;            /*   297     1 */
>         u8                         lag_hash_mode;        /*   298     1 */
>         bool                       legacy_phy_port_mapping; /*   299     1 */
> 
>         /* XXX 4 bytes hole, try to pack */
> 
>         struct qca8k_ports_config  ports_config;         /*   304    72 */
>         /* --- cacheline 5 boundary (320 bytes) was 56 bytes ago --- */
>         struct regmap *            regmap;               /*   376     8 */
>         /* --- cacheline 6 boundary (384 bytes) --- */
>         struct mii_bus *           bus;                  /*   384     8 */
>         struct ar8xxx_port_status  port_sts[7];          /*   392    28 */
> 
>         /* XXX 4 bytes hole, try to pack */
> 
>         struct dsa_switch *        ds;                   /*   424     8 */
>         struct mutex               reg_mutex;            /*   432   160 */
>         /* --- cacheline 9 boundary (576 bytes) was 16 bytes ago --- */
>         struct device *            dev;                  /*   592     8 */
>         struct gpio_desc *         reset_gpio;           /*   600     8 */
>         struct dsa_switch_ops      ops;                  /*   608   864 */
>         /* --- cacheline 23 boundary (1472 bytes) --- */
>         struct qca8k_mib_eth_data  mib_eth_data;         /*  1472   280 */
> 
>         /* XXX last struct has 4 bytes of padding */
> 
>         /* --- cacheline 27 boundary (1728 bytes) was 24 bytes ago --- */
>         unsigned int               port_mtu[7];          /*  1752    28 */
> 
>         /* size: 1784, cachelines: 28, members: 20 */
>         /* sum members: 1772, holes: 2, sum holes: 8 */
>         /* padding: 4 */
>         /* paddings: 1, sum paddings: 4 */
>         /* last cacheline: 56 bytes */
> };
> 
> 1776 vs 1784. That's... larger?!
> 
> Also, struct qca8k_priv is so large because the "ops" member is a full
> copy of qca8k_switch_ops. I understand why commit db460c54b67f ("net:
> dsa: qca8k: extend slave-bus implementations") did this, but I wonder,
> is there no better way?
> 

Actually from what I can see the struct can be improved in 2 way...
The ancient struct
ar8xxx_port_status port_sts[QCA8K_NUM_PORTS];
can be totally dropped as I can't see why we still need it.

The duplicated ops is funny. I could be very confused but why it's done
like that? Can't we modify directly the already defined one and drop
struct dsa_switch_ops ops; from qca8k_priv?

I mean is all of that to use priv->ops.phy_read instead of
priv->ds->ops.phy_read or even qca8k_switch_ops directly? o.o

Am I missing something?

> >  drivers/net/dsa/qca8k.c |  8 ++++----
> >  drivers/net/dsa/qca8k.h | 33 ++++++++++++++++-----------------
> >  2 files changed, 20 insertions(+), 21 deletions(-)
> > 
> > diff --git a/drivers/net/dsa/qca8k.c b/drivers/net/dsa/qca8k.c
> > index ee0dbf324268..8d059da5f0ca 100644
> > --- a/drivers/net/dsa/qca8k.c
> > +++ b/drivers/net/dsa/qca8k.c
> > @@ -1685,11 +1685,11 @@ qca8k_phylink_mac_select_pcs(struct dsa_switch *ds, int port,
> >  	case PHY_INTERFACE_MODE_1000BASEX:
> >  		switch (port) {
> >  		case 0:
> > -			pcs = &priv->pcs_port_0.pcs;
> > +			pcs = &priv->ports_config.qpcs[QCA8K_CPU_PORT0].pcs;
> >  			break;
> >  
> >  		case 6:
> > -			pcs = &priv->pcs_port_6.pcs;
> > +			pcs = &priv->ports_config.qpcs[QCA8K_CPU_PORT6].pcs;
> >  			break;
> >  		}
> >  		break;
> > @@ -2889,8 +2889,8 @@ qca8k_setup(struct dsa_switch *ds)
> >  	if (ret)
> >  		return ret;
> >  
> > -	qca8k_setup_pcs(priv, &priv->pcs_port_0, 0);
> > -	qca8k_setup_pcs(priv, &priv->pcs_port_6, 6);
> > +	qca8k_setup_pcs(priv, &priv->ports_config.qpcs[QCA8K_CPU_PORT0], 0);
> > +	qca8k_setup_pcs(priv, &priv->ports_config.qpcs[QCA8K_CPU_PORT6], 6);
> >  
> >  	/* Make sure MAC06 is disabled */
> >  	ret = regmap_clear_bits(priv->regmap, QCA8K_REG_PORT0_PAD_CTRL,
> > diff --git a/drivers/net/dsa/qca8k.h b/drivers/net/dsa/qca8k.h
> > index f375627174c8..611dc2335dbe 100644
> > --- a/drivers/net/dsa/qca8k.h
> > +++ b/drivers/net/dsa/qca8k.h
> > @@ -341,18 +341,24 @@ enum {
> >  
> >  struct qca8k_mgmt_eth_data {
> >  	struct completion rw_done;
> > -	struct mutex mutex; /* Enforce one mdio read/write at time */
> > +	u32 data[4];
> >  	bool ack;
> >  	u32 seq;
> > -	u32 data[4];
> > +	struct mutex mutex; /* Enforce one mdio read/write at time */
> >  };
> >  
> >  struct qca8k_mib_eth_data {
> >  	struct completion rw_done;
> > +	u64 *data; /* pointer to ethtool data */
> > +	u8 req_port;
> >  	struct mutex mutex; /* Process one command at time */
> >  	refcount_t port_parsed; /* Counter to track parsed port */
> > -	u8 req_port;
> > -	u64 *data; /* pointer to ethtool data */
> > +};
> > +
> > +struct qca8k_pcs {
> > +	struct phylink_pcs pcs;
> > +	struct qca8k_priv *priv;
> > +	int port;
> >  };
> >  
> >  struct qca8k_ports_config {
> > @@ -361,6 +367,7 @@ struct qca8k_ports_config {
> >  	bool sgmii_enable_pll;
> >  	u8 rgmii_rx_delay[QCA8K_NUM_CPU_PORTS]; /* 0: CPU port0, 1: CPU port6 */
> >  	u8 rgmii_tx_delay[QCA8K_NUM_CPU_PORTS]; /* 0: CPU port0, 1: CPU port6 */
> > +	struct qca8k_pcs qpcs[QCA8K_NUM_CPU_PORTS];
> >  };
> >  
> >  struct qca8k_mdio_cache {
> > @@ -376,13 +383,10 @@ struct qca8k_mdio_cache {
> >  	u16 hi;
> >  };
> >  
> > -struct qca8k_pcs {
> > -	struct phylink_pcs pcs;
> > -	struct qca8k_priv *priv;
> > -	int port;
> > -};
> > -
> >  struct qca8k_priv {
> > +	struct net_device *mgmt_master; /* Track if mdio/mib Ethernet is available */
> > +	struct qca8k_mgmt_eth_data mgmt_eth_data;
> > +	struct qca8k_mdio_cache mdio_cache;
> >  	u8 switch_id;
> >  	u8 switch_revision;
> >  	u8 mirror_rx;
> > @@ -396,15 +400,10 @@ struct qca8k_priv {
> >  	struct dsa_switch *ds;
> >  	struct mutex reg_mutex;
> >  	struct device *dev;
> > -	struct dsa_switch_ops ops;
> >  	struct gpio_desc *reset_gpio;
> > -	unsigned int port_mtu[QCA8K_NUM_PORTS];
> > -	struct net_device *mgmt_master; /* Track if mdio/mib Ethernet is available */
> > -	struct qca8k_mgmt_eth_data mgmt_eth_data;
> > +	struct dsa_switch_ops ops;
> >  	struct qca8k_mib_eth_data mib_eth_data;
> > -	struct qca8k_mdio_cache mdio_cache;
> > -	struct qca8k_pcs pcs_port_0;
> > -	struct qca8k_pcs pcs_port_6;
> > +	unsigned int port_mtu[QCA8K_NUM_PORTS];
> >  };
> >  
> >  struct qca8k_mib_desc {
> > -- 
> > 2.34.1
> > 
> 

-- 
	Ansuel

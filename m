Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A85194CB485
	for <lists+netdev@lfdr.de>; Thu,  3 Mar 2022 02:57:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231503AbiCCByX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Mar 2022 20:54:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50776 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231562AbiCCByV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Mar 2022 20:54:21 -0500
Received: from mail-ed1-x533.google.com (mail-ed1-x533.google.com [IPv6:2a00:1450:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2566C53708;
        Wed,  2 Mar 2022 17:53:31 -0800 (PST)
Received: by mail-ed1-x533.google.com with SMTP id x5so4660571edd.11;
        Wed, 02 Mar 2022 17:53:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=/nj/x4EcaAHZ48ZKXHO6tJgxsIj+fgw8rai9ogBnLJw=;
        b=cEW3C4IP39oJbfJsEO7S34XAGWuiAXKUmAPcPxXLO7TZ4JVHyy0UC2DFm5DjAI87MX
         8j4e50naS9CPkmi1oAW6M46COrau5sWUPum5VQGpVGRMNdJJ6Usk6pjxddBw1BScvc8P
         7dVXfu/drbdVKSMPBfKF4cvdVmhVDaYsy+bAQMBi2vOuIDunlgFO453auNkTc5Bb+wBF
         H4qi7Wf0TeTKMcSwe+MaEFWVoDvpJ4djxyBWmXBo7QoMTMWCXYbYz5sjjKkEt53qhvmi
         Rn3T9VU3ZgMKI2m3jL1AnaYxWkWVM9F88eCHB+4Clh4vgEysxfpqnZErEqwHbjbRJvuX
         d91Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=/nj/x4EcaAHZ48ZKXHO6tJgxsIj+fgw8rai9ogBnLJw=;
        b=YrPxlJZ4boQ2mE8YMcE3LdEk+tNLJIsYSshMoZ+CYaefhL4lvcNK0f6WUQQFR2VQ4R
         6cY5NzUmyhqDsank8qy6ucU6DgRKso1YjxTGke0Ch1auI5oy4UmBUEIAs1RfgWa0qvBz
         N8XuBCeflgweoQ8bJzAWfApNCpZY69u51rWnfs3+KmVaBJL7krgBBzhyDcYNP/u/ZHFO
         ddM+M/UD8EoG3Vlr2eI01RWi/vRry1qPxxB0TgbHbPlEal+GGbcg0Vl9DulPcL6IuoHv
         1Ab2qGI72oImLx9eudOnsVxAXHv/zUKTJyL1kekrv9rXWWDIwX/utn/a8U2aB8YEkpMz
         ySJA==
X-Gm-Message-State: AOAM533o9JmiPnn9fwIkXFdjWJBv/ClprFsRxKO7PF4b5qcSIFjd/Tga
        WkQk6z9PlNcGz3C6sHqt1YY=
X-Google-Smtp-Source: ABdhPJzQ7uwSc5TZ2tt5UEwG1otUMR1DpALsL1r/ey7vpe5qaAuzMZd5JJpdc1GnjBEr58GhdSkUIA==
X-Received: by 2002:a05:6402:5254:b0:410:def7:132c with SMTP id t20-20020a056402525400b00410def7132cmr32443104edd.161.1646272409352;
        Wed, 02 Mar 2022 17:53:29 -0800 (PST)
Received: from skbuf ([188.25.231.156])
        by smtp.gmail.com with ESMTPSA id i26-20020a17090671da00b006d9b2150a22sm193305ejk.146.2022.03.02.17.53.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 02 Mar 2022 17:53:28 -0800 (PST)
Date:   Thu, 3 Mar 2022 03:53:27 +0200
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
Message-ID: <20220303015327.k3fqkkxunm6kihjl@skbuf>
References: <20220228110408.4903-1-ansuelsmth@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220228110408.4903-1-ansuelsmth@gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Feb 28, 2022 at 12:04:08PM +0100, Ansuel Smith wrote:
> Pack qca8k priv and other struct using pahole and set the first priv
> struct entry to mgmt_master and mgmt_eth_data to speedup access.
> While at it also rework pcs struct and move it qca8k_ports_config
> following other configuration set for the cpu ports.
> 
> Signed-off-by: Ansuel Smith <ansuelsmth@gmail.com>
> ---

How did you "pack" struct qca8k_priv exactly?

Before:

struct qca8k_priv {
        u8                         switch_id;            /*     0     1 */
        u8                         switch_revision;      /*     1     1 */
        u8                         mirror_rx;            /*     2     1 */
        u8                         mirror_tx;            /*     3     1 */
        u8                         lag_hash_mode;        /*     4     1 */
        bool                       legacy_phy_port_mapping; /*     5     1 */
        struct qca8k_ports_config  ports_config;         /*     6     7 */

        /* XXX 3 bytes hole, try to pack */

        struct regmap *            regmap;               /*    16     8 */
        struct mii_bus *           bus;                  /*    24     8 */
        struct ar8xxx_port_status  port_sts[7];          /*    32    28 */

        /* XXX 4 bytes hole, try to pack */

        /* --- cacheline 1 boundary (64 bytes) --- */
        struct dsa_switch *        ds;                   /*    64     8 */
        struct mutex               reg_mutex;            /*    72   160 */
        /* --- cacheline 3 boundary (192 bytes) was 40 bytes ago --- */
        struct device *            dev;                  /*   232     8 */
        struct dsa_switch_ops      ops;                  /*   240   864 */
        /* --- cacheline 17 boundary (1088 bytes) was 16 bytes ago --- */
        struct gpio_desc *         reset_gpio;           /*  1104     8 */
        unsigned int               port_mtu[7];          /*  1112    28 */

        /* XXX 4 bytes hole, try to pack */

        struct net_device *        mgmt_master;          /*  1144     8 */
        /* --- cacheline 18 boundary (1152 bytes) --- */
        struct qca8k_mgmt_eth_data mgmt_eth_data;        /*  1152   280 */
        /* --- cacheline 22 boundary (1408 bytes) was 24 bytes ago --- */
        struct qca8k_mib_eth_data  mib_eth_data;         /*  1432   272 */
        /* --- cacheline 26 boundary (1664 bytes) was 40 bytes ago --- */
        struct qca8k_mdio_cache    mdio_cache;           /*  1704     6 */

        /* XXX 2 bytes hole, try to pack */

        struct qca8k_pcs           pcs_port_0;           /*  1712    32 */

        /* XXX last struct has 4 bytes of padding */

        /* --- cacheline 27 boundary (1728 bytes) was 16 bytes ago --- */
        struct qca8k_pcs           pcs_port_6;           /*  1744    32 */

        /* XXX last struct has 4 bytes of padding */

        /* size: 1776, cachelines: 28, members: 22 */
        /* sum members: 1763, holes: 4, sum holes: 13 */
        /* paddings: 2, sum paddings: 8 */
        /* last cacheline: 48 bytes */
};

After:

struct qca8k_priv {
        struct net_device *        mgmt_master;          /*     0     8 */
        struct qca8k_mgmt_eth_data mgmt_eth_data;        /*     8   280 */
        /* --- cacheline 4 boundary (256 bytes) was 32 bytes ago --- */
        struct qca8k_mdio_cache    mdio_cache;           /*   288     6 */
        u8                         switch_id;            /*   294     1 */
        u8                         switch_revision;      /*   295     1 */
        u8                         mirror_rx;            /*   296     1 */
        u8                         mirror_tx;            /*   297     1 */
        u8                         lag_hash_mode;        /*   298     1 */
        bool                       legacy_phy_port_mapping; /*   299     1 */

        /* XXX 4 bytes hole, try to pack */

        struct qca8k_ports_config  ports_config;         /*   304    72 */
        /* --- cacheline 5 boundary (320 bytes) was 56 bytes ago --- */
        struct regmap *            regmap;               /*   376     8 */
        /* --- cacheline 6 boundary (384 bytes) --- */
        struct mii_bus *           bus;                  /*   384     8 */
        struct ar8xxx_port_status  port_sts[7];          /*   392    28 */

        /* XXX 4 bytes hole, try to pack */

        struct dsa_switch *        ds;                   /*   424     8 */
        struct mutex               reg_mutex;            /*   432   160 */
        /* --- cacheline 9 boundary (576 bytes) was 16 bytes ago --- */
        struct device *            dev;                  /*   592     8 */
        struct gpio_desc *         reset_gpio;           /*   600     8 */
        struct dsa_switch_ops      ops;                  /*   608   864 */
        /* --- cacheline 23 boundary (1472 bytes) --- */
        struct qca8k_mib_eth_data  mib_eth_data;         /*  1472   280 */

        /* XXX last struct has 4 bytes of padding */

        /* --- cacheline 27 boundary (1728 bytes) was 24 bytes ago --- */
        unsigned int               port_mtu[7];          /*  1752    28 */

        /* size: 1784, cachelines: 28, members: 20 */
        /* sum members: 1772, holes: 2, sum holes: 8 */
        /* padding: 4 */
        /* paddings: 1, sum paddings: 4 */
        /* last cacheline: 56 bytes */
};

1776 vs 1784. That's... larger?!

Also, struct qca8k_priv is so large because the "ops" member is a full
copy of qca8k_switch_ops. I understand why commit db460c54b67f ("net:
dsa: qca8k: extend slave-bus implementations") did this, but I wonder,
is there no better way?

>  drivers/net/dsa/qca8k.c |  8 ++++----
>  drivers/net/dsa/qca8k.h | 33 ++++++++++++++++-----------------
>  2 files changed, 20 insertions(+), 21 deletions(-)
> 
> diff --git a/drivers/net/dsa/qca8k.c b/drivers/net/dsa/qca8k.c
> index ee0dbf324268..8d059da5f0ca 100644
> --- a/drivers/net/dsa/qca8k.c
> +++ b/drivers/net/dsa/qca8k.c
> @@ -1685,11 +1685,11 @@ qca8k_phylink_mac_select_pcs(struct dsa_switch *ds, int port,
>  	case PHY_INTERFACE_MODE_1000BASEX:
>  		switch (port) {
>  		case 0:
> -			pcs = &priv->pcs_port_0.pcs;
> +			pcs = &priv->ports_config.qpcs[QCA8K_CPU_PORT0].pcs;
>  			break;
>  
>  		case 6:
> -			pcs = &priv->pcs_port_6.pcs;
> +			pcs = &priv->ports_config.qpcs[QCA8K_CPU_PORT6].pcs;
>  			break;
>  		}
>  		break;
> @@ -2889,8 +2889,8 @@ qca8k_setup(struct dsa_switch *ds)
>  	if (ret)
>  		return ret;
>  
> -	qca8k_setup_pcs(priv, &priv->pcs_port_0, 0);
> -	qca8k_setup_pcs(priv, &priv->pcs_port_6, 6);
> +	qca8k_setup_pcs(priv, &priv->ports_config.qpcs[QCA8K_CPU_PORT0], 0);
> +	qca8k_setup_pcs(priv, &priv->ports_config.qpcs[QCA8K_CPU_PORT6], 6);
>  
>  	/* Make sure MAC06 is disabled */
>  	ret = regmap_clear_bits(priv->regmap, QCA8K_REG_PORT0_PAD_CTRL,
> diff --git a/drivers/net/dsa/qca8k.h b/drivers/net/dsa/qca8k.h
> index f375627174c8..611dc2335dbe 100644
> --- a/drivers/net/dsa/qca8k.h
> +++ b/drivers/net/dsa/qca8k.h
> @@ -341,18 +341,24 @@ enum {
>  
>  struct qca8k_mgmt_eth_data {
>  	struct completion rw_done;
> -	struct mutex mutex; /* Enforce one mdio read/write at time */
> +	u32 data[4];
>  	bool ack;
>  	u32 seq;
> -	u32 data[4];
> +	struct mutex mutex; /* Enforce one mdio read/write at time */
>  };
>  
>  struct qca8k_mib_eth_data {
>  	struct completion rw_done;
> +	u64 *data; /* pointer to ethtool data */
> +	u8 req_port;
>  	struct mutex mutex; /* Process one command at time */
>  	refcount_t port_parsed; /* Counter to track parsed port */
> -	u8 req_port;
> -	u64 *data; /* pointer to ethtool data */
> +};
> +
> +struct qca8k_pcs {
> +	struct phylink_pcs pcs;
> +	struct qca8k_priv *priv;
> +	int port;
>  };
>  
>  struct qca8k_ports_config {
> @@ -361,6 +367,7 @@ struct qca8k_ports_config {
>  	bool sgmii_enable_pll;
>  	u8 rgmii_rx_delay[QCA8K_NUM_CPU_PORTS]; /* 0: CPU port0, 1: CPU port6 */
>  	u8 rgmii_tx_delay[QCA8K_NUM_CPU_PORTS]; /* 0: CPU port0, 1: CPU port6 */
> +	struct qca8k_pcs qpcs[QCA8K_NUM_CPU_PORTS];
>  };
>  
>  struct qca8k_mdio_cache {
> @@ -376,13 +383,10 @@ struct qca8k_mdio_cache {
>  	u16 hi;
>  };
>  
> -struct qca8k_pcs {
> -	struct phylink_pcs pcs;
> -	struct qca8k_priv *priv;
> -	int port;
> -};
> -
>  struct qca8k_priv {
> +	struct net_device *mgmt_master; /* Track if mdio/mib Ethernet is available */
> +	struct qca8k_mgmt_eth_data mgmt_eth_data;
> +	struct qca8k_mdio_cache mdio_cache;
>  	u8 switch_id;
>  	u8 switch_revision;
>  	u8 mirror_rx;
> @@ -396,15 +400,10 @@ struct qca8k_priv {
>  	struct dsa_switch *ds;
>  	struct mutex reg_mutex;
>  	struct device *dev;
> -	struct dsa_switch_ops ops;
>  	struct gpio_desc *reset_gpio;
> -	unsigned int port_mtu[QCA8K_NUM_PORTS];
> -	struct net_device *mgmt_master; /* Track if mdio/mib Ethernet is available */
> -	struct qca8k_mgmt_eth_data mgmt_eth_data;
> +	struct dsa_switch_ops ops;
>  	struct qca8k_mib_eth_data mib_eth_data;
> -	struct qca8k_mdio_cache mdio_cache;
> -	struct qca8k_pcs pcs_port_0;
> -	struct qca8k_pcs pcs_port_6;
> +	unsigned int port_mtu[QCA8K_NUM_PORTS];
>  };
>  
>  struct qca8k_mib_desc {
> -- 
> 2.34.1
> 


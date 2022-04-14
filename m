Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D27EC501A11
	for <lists+netdev@lfdr.de>; Thu, 14 Apr 2022 19:35:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240552AbiDNRhT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Apr 2022 13:37:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57850 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231521AbiDNRhP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 Apr 2022 13:37:15 -0400
Received: from mail-ed1-x531.google.com (mail-ed1-x531.google.com [IPv6:2a00:1450:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 416FB49F9C;
        Thu, 14 Apr 2022 10:34:48 -0700 (PDT)
Received: by mail-ed1-x531.google.com with SMTP id c6so7248070edn.8;
        Thu, 14 Apr 2022 10:34:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=a5uj+K6AdCyMYSVv+JauoA+KUXkGH81hHIIN+LKrtqs=;
        b=ZDFc6IffRDKxejIGdwD6KSofAyYD/YcV2o09x5/hyZwOOAGIIBCCtHd7GWBOyIMokf
         bdMPN0rE/UW0v9B0Q7jzHTgwdL5sBQw1+ilD+u/2P21MCDUI6UxPgPQFz2Pwg2BaT2D+
         uU2SVyikKilpog+0wct15HMi7F7Co9RDRPekVIFOLEsDKavNQNHGUwk81FsCEbKqVj/B
         m2bWmKSni95pgiGOrY+2g+5m0gjRARTO7tnBkwV7aKLWH2O43L5kWzcskKJiV23pc9TV
         IaseIiUnyYuj4V5T7aJW70iGHNzXKxzGg9+rtCFhOxTkQOwgX9omsV3GG8qfoks5xLSP
         eaKw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=a5uj+K6AdCyMYSVv+JauoA+KUXkGH81hHIIN+LKrtqs=;
        b=HSxpUSYimLFfkkAgjdsoiFU1ONon8gdDgoR6QevwiinCQs6DPASyBRbzaFi8PTLkuc
         4VCgZQYSPYthNpiUNoApVHpGbM5wGtVuNqdpDUnkJ9VM1eIs7UYRucEACQ2xYdiZfalh
         KGmr0ahupRbU62J0ZrbhX0zyLsSpgfS+NOVCOH/Oi6VLG9yONlySSAAfy3ZIXdzE0S2g
         TUReTIZhAyqEipPvIaC59N5Zvnlh8YKwXLytrIOvGb9JLVVaieC7kvkOMLnP2H0zFjvd
         a6M6DuzqtibLBePE4EQQF9KrYcOFRGFSTlKCjsBY57FHSbwmxUT1maah1cKoiRF2mPOc
         0X+w==
X-Gm-Message-State: AOAM532bwDvz7IGorqmrAzFTZyQNb5yGUItKBYvwae0U3NsKY7lV0G9m
        yf9SsUMyVjGW9EO6eP6uEOA=
X-Google-Smtp-Source: ABdhPJy3pEAcYKxq7V9/0PnOeNgm+ByWFRn1uvWeeJAdT3NnfrXuFOZb0JFLip/O9Jpy/4YO/HF9rw==
X-Received: by 2002:a50:ee89:0:b0:41d:70eb:eb36 with SMTP id f9-20020a50ee89000000b0041d70ebeb36mr4361146edr.24.1649957686616;
        Thu, 14 Apr 2022 10:34:46 -0700 (PDT)
Received: from skbuf ([188.26.57.45])
        by smtp.gmail.com with ESMTPSA id cy5-20020a0564021c8500b0041fec3310desm1339177edb.68.2022.04.14.10.34.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 14 Apr 2022 10:34:46 -0700 (PDT)
Date:   Thu, 14 Apr 2022 20:34:44 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     =?utf-8?B?Q2zDqW1lbnQgTMOpZ2Vy?= <clement.leger@bootlin.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzk+dt@kernel.org>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Magnus Damm <magnus.damm@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        Herve Codina <herve.codina@bootlin.com>,
        =?utf-8?Q?Miqu=C3=A8l?= Raynal <miquel.raynal@bootlin.com>,
        Milan Stevanovic <milan.stevanovic@se.com>,
        Jimmy Lalande <jimmy.lalande@se.com>,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
        linux-renesas-soc@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH net-next 07/12] net: dsa: rzn1-a5psw: add statistics
 support
Message-ID: <20220414173444.iymkyes7iu4jifte@skbuf>
References: <20220414122250.158113-1-clement.leger@bootlin.com>
 <20220414122250.158113-8-clement.leger@bootlin.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20220414122250.158113-8-clement.leger@bootlin.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Apr 14, 2022 at 02:22:45PM +0200, Clément Léger wrote:
> Add per-port statistics. This support requries to add a stat lock since
> statistics are stored in two 32 bits registers, the hi part one being
> global and latched when accessing the lo part.
> 
> Signed-off-by: Clément Léger <clement.leger@bootlin.com>
> ---

I think for new drivers Jakub will also want to see the more specific
and less free-form get_stats64, get_eth_mac_stats, get_eth_phy_stats,
get_eth_ctrl_stats ops implemented. Your counters should map nicely over
these.

>  drivers/net/dsa/rzn1_a5psw.c | 101 +++++++++++++++++++++++++++++++++++
>  drivers/net/dsa/rzn1_a5psw.h |   2 +
>  2 files changed, 103 insertions(+)
> 
> diff --git a/drivers/net/dsa/rzn1_a5psw.c b/drivers/net/dsa/rzn1_a5psw.c
> index 5bee999f7050..7ab7d9054427 100644
> --- a/drivers/net/dsa/rzn1_a5psw.c
> +++ b/drivers/net/dsa/rzn1_a5psw.c
> @@ -16,6 +16,59 @@
>  
>  #include "rzn1_a5psw.h"
>  
> +struct a5psw_stats {
> +	u16 offset;
> +	const char *name;
> +};
> +
> +#define STAT_DESC(_offset, _name) {.offset = _offset, .name = _name}
> +
> +static const struct a5psw_stats a5psw_stats[] = {
> +	STAT_DESC(0x868, "aFrameTransmitted"),
> +	STAT_DESC(0x86C, "aFrameReceived"),
> +	STAT_DESC(0x870, "aFrameCheckSequenceErrors"),
> +	STAT_DESC(0x874, "aAlignmentErrors"),
> +	STAT_DESC(0x878, "aOctetsTransmitted"),
> +	STAT_DESC(0x87C, "aOctetsReceived"),
> +	STAT_DESC(0x880, "aTxPAUSEMACCtrlFrames"),
> +	STAT_DESC(0x884, "aRxPAUSEMACCtrlFrames"),

What does the "a" stand for?

> +	/* If */
> +	STAT_DESC(0x888, "ifInErrors"),
> +	STAT_DESC(0x88C, "ifOutErrors"),
> +	STAT_DESC(0x890, "ifInUcastPkts"),
> +	STAT_DESC(0x894, "ifInMulticastPkts"),
> +	STAT_DESC(0x898, "ifInBroadcastPkts"),
> +	STAT_DESC(0x89C, "ifOutDiscards"),
> +	STAT_DESC(0x8A0, "ifOutUcastPkts"),
> +	STAT_DESC(0x8A4, "ifOutMulticastPkts"),
> +	STAT_DESC(0x8A8, "ifOutBroadcastPkts"),
> +	/* Ether */
> +	STAT_DESC(0x8AC, "etherStatsDropEvents"),
> +	STAT_DESC(0x8B0, "etherStatsOctets"),
> +	STAT_DESC(0x8B4, "etherStatsPkts"),
> +	STAT_DESC(0x8B8, "etherStatsUndersizePkts"),
> +	STAT_DESC(0x8BC, "etherStatsetherStatsOversizePktsDropEvents"),

"etherStats" is duplicated here.

> +	STAT_DESC(0x8C0, "etherStatsPkts64Octets"),
> +	STAT_DESC(0x8C4, "etherStatsPkts65to127Octets"),
> +	STAT_DESC(0x8C8, "etherStatsPkts128to255Octets"),
> +	STAT_DESC(0x8CC, "etherStatsPkts256to511Octets"),
> +	STAT_DESC(0x8D0, "etherStatsPkts512to1023Octets"),
> +	STAT_DESC(0x8D4, "etherStatsPkts1024to1518Octets"),
> +	STAT_DESC(0x8D8, "etherStatsPkts1519toXOctets"),
> +	STAT_DESC(0x8DC, "etherStatsJabbers"),
> +	STAT_DESC(0x8E0, "etherStatsFragments"),
> +
> +	STAT_DESC(0x8E8, "VLANReceived"),
> +	STAT_DESC(0x8EC, "VLANTransmitted"),
> +
> +	STAT_DESC(0x910, "aDeferred"),
> +	STAT_DESC(0x914, "aMultipleCollisions"),
> +	STAT_DESC(0x918, "aSingleCollisions"),
> +	STAT_DESC(0x91C, "aLateCollisions"),
> +	STAT_DESC(0x920, "aExcessiveCollisions"),
> +	STAT_DESC(0x924, "aCarrierSenseErrors"),
> +};
> +
>  static void a5psw_reg_writel(struct a5psw *a5psw, int offset, u32 value)
>  {
>  	writel(value, a5psw->base + offset);
> @@ -316,6 +369,50 @@ static void a5psw_port_fast_age(struct dsa_switch *ds, int port)
>  	a5psw_port_fdb_flush(a5psw, port);
>  }
>  
> +static void a5psw_get_strings(struct dsa_switch *ds, int port, u32 stringset,
> +			      uint8_t *data)
> +{
> +	unsigned int u;
> +
> +	if (stringset != ETH_SS_STATS)
> +		return;
> +
> +	for (u = 0; u < ARRAY_SIZE(a5psw_stats); u++) {
> +		strncpy(data + u * ETH_GSTRING_LEN, a5psw_stats[u].name,
> +			ETH_GSTRING_LEN);
> +	}
> +}
> +
> +static void a5psw_get_ethtool_stats(struct dsa_switch *ds, int port,
> +				    uint64_t *data)
> +{
> +	struct a5psw *a5psw = ds->priv;
> +	u32 reg_lo, reg_hi;
> +	unsigned int u;
> +
> +	for (u = 0; u < ARRAY_SIZE(a5psw_stats); u++) {
> +		/* A5PSW_STATS_HIWORD is global and thus, access must be
> +		 * exclusive
> +		 */
> +		spin_lock(&a5psw->stats_lock);
> +		reg_lo = a5psw_reg_readl(a5psw, a5psw_stats[u].offset +
> +					 A5PSW_PORT_OFFSET(port));
> +		/* A5PSW_STATS_HIWORD is latched on stat read */
> +		reg_hi = a5psw_reg_readl(a5psw, A5PSW_STATS_HIWORD);
> +
> +		data[u] = ((u64)reg_hi << 32) | reg_lo;
> +		spin_unlock(&a5psw->stats_lock);
> +	}
> +}
> +
> +static int a5psw_get_sset_count(struct dsa_switch *ds, int port, int sset)
> +{
> +	if (sset != ETH_SS_STATS)
> +		return 0;
> +
> +	return ARRAY_SIZE(a5psw_stats);
> +}
> +
>  static int a5psw_setup(struct dsa_switch *ds)
>  {
>  	struct a5psw *a5psw = ds->priv;
> @@ -395,6 +492,9 @@ const struct dsa_switch_ops a5psw_switch_ops = {
>  	.phylink_mac_link_up = a5psw_phylink_mac_link_up,
>  	.port_change_mtu = a5psw_port_change_mtu,
>  	.port_max_mtu = a5psw_port_max_mtu,
> +	.get_sset_count = a5psw_get_sset_count,
> +	.get_strings = a5psw_get_strings,
> +	.get_ethtool_stats = a5psw_get_ethtool_stats,
>  	.set_ageing_time = a5psw_set_ageing_time,
>  	.port_bridge_join = a5psw_port_bridge_join,
>  	.port_bridge_leave = a5psw_port_bridge_leave,
> @@ -580,6 +680,7 @@ static int a5psw_probe(struct platform_device *pdev)
>  		return -ENOMEM;
>  
>  	a5psw->dev = dev;
> +	spin_lock_init(&a5psw->stats_lock);
>  	spin_lock_init(&a5psw->lk_lock);
>  	spin_lock_init(&a5psw->reg_lock);
>  	a5psw->base = devm_platform_ioremap_resource(pdev, 0);
> diff --git a/drivers/net/dsa/rzn1_a5psw.h b/drivers/net/dsa/rzn1_a5psw.h
> index 2d96a2afbc3a..b34ea549e936 100644
> --- a/drivers/net/dsa/rzn1_a5psw.h
> +++ b/drivers/net/dsa/rzn1_a5psw.h
> @@ -177,6 +177,7 @@
>   * @mdio_freq: MDIO bus frequency requested
>   * @pcs: Array of PCS connected to the switch ports (not for the CPU)
>   * @ds: DSA switch struct
> + * @stats_lock: lock to access statistics (shared HI counter)
>   * @lk_lock: Lock for the lookup table
>   * @reg_lock: Lock for register read-modify-write operation
>   * @flooding_ports: List of ports that should be flooded
> @@ -190,6 +191,7 @@ struct a5psw {
>  	u32 mdio_freq;
>  	struct phylink_pcs *pcs[A5PSW_PORTS_NUM - 1];
>  	struct dsa_switch ds;
> +	spinlock_t stats_lock;
>  	spinlock_t lk_lock;
>  	spinlock_t reg_lock;
>  	u32 flooding_ports;
> -- 
> 2.34.1
> 


Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8596751A515
	for <lists+netdev@lfdr.de>; Wed,  4 May 2022 18:14:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353163AbiEDQR7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 May 2022 12:17:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49616 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353141AbiEDQR6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 May 2022 12:17:58 -0400
Received: from mail-ej1-x62a.google.com (mail-ej1-x62a.google.com [IPv6:2a00:1450:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3E0D327B39;
        Wed,  4 May 2022 09:14:19 -0700 (PDT)
Received: by mail-ej1-x62a.google.com with SMTP id j6so3801962ejc.13;
        Wed, 04 May 2022 09:14:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=EO/exjYIL2Y7doxRAG/8tv0+K4n654l6gAS/q81p8VU=;
        b=MqhOzlGbNPDmmEkZxrkvlxT8yAsFHCS5fJpOrOc96wYcV7RZliRUshFSrY7sMN8ssE
         0ifZJBu1ODc9B+x7yzT8DuPqVdxoy3EEmWNQfcoDjW4lKC4L7mQdunYBXLjNKoBLuA5t
         x+ejzkmyot4gDA6E0riYHZsfTuahHqqC6m7H66ECjJ199S3NO2rg5rH04JCxOUbFMHIJ
         wMqHdnlRpf0XAaDhBj/6jvNZRxGA0j5DfuHILXTvItX9d88lZgDfE3M5ceuVGjRwIYHB
         HODrZsf2ceJPTpk8hlUwTAz6qaqG2jpKhhVxAdnwXQpHe6PWpfKOt8Tmil5aTRlwTGDy
         d+Og==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=EO/exjYIL2Y7doxRAG/8tv0+K4n654l6gAS/q81p8VU=;
        b=T2HZBaQ1s8L4CBXt2hcIvh0YzvQvs0quAPhS6cigVQwDLhS8RUMt+6Uho8hLNn4UoU
         gjh+LVay58kanMPURMmkLZvvHhRGKcMElaNL1mwUYOjEYYGEYBpTOjKUa/o7Bz/qGVDp
         TcNzje99HzQePDWDWDfHU+XNlTbHdwiQMPogTL9ihDR5/5/k/LHkfRszrXX2FVfhF8xG
         Lz8zzRomAEcdth+PNrXzldHDguGKphzgyZtlTI1o1YCKirbzCnqbZ8hbrmEdcNU8TqAC
         b70/RFMm7+erOeLmsSoTyxFu+uqFSGPzaVDi2velh8iERoOHsdcTRIqkaVR44ZMcjwYi
         aj/g==
X-Gm-Message-State: AOAM532XGgjSA1OCf+GhYhuC2v8YDOORvdp8PSNJj1wc2aN9yHuaqOq5
        Nq3RZH7KKolqCEo6mlmqBfsft8iCSWo=
X-Google-Smtp-Source: ABdhPJy9c9TpbTPzuMmXBwFXbHfvSuQ6WT98ztnuNFRqTqFEUnA7xkC7oz2tfhV5q0bxgxpXCpwa1w==
X-Received: by 2002:a17:907:7212:b0:6f4:7d9:5f78 with SMTP id dr18-20020a170907721200b006f407d95f78mr20039274ejc.474.1651680857768;
        Wed, 04 May 2022 09:14:17 -0700 (PDT)
Received: from skbuf ([188.25.160.86])
        by smtp.gmail.com with ESMTPSA id ml11-20020a170906cc0b00b006f3ef214e59sm5916928ejb.191.2022.05.04.09.14.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 04 May 2022 09:14:17 -0700 (PDT)
Date:   Wed, 4 May 2022 19:14:14 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     =?utf-8?B?Q2zDqW1lbnQgTMOpZ2Vy?= <clement.leger@bootlin.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
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
        Pascal Eberhard <pascal.eberhard@se.com>,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
        linux-renesas-soc@vger.kernel.org, netdev@vger.kernel.org,
        Jean-Pierre Geslin <jean-pierre.geslin@non.se.com>,
        Phil Edworthy <phil.edworthy@renesas.com>
Subject: Re: [PATCH net-next v3 06/12] net: dsa: rzn1-a5psw: add Renesas
 RZ/N1 advanced 5 port switch driver
Message-ID: <20220504161414.u6riybjcrgachjvh@skbuf>
References: <20220504093000.132579-1-clement.leger@bootlin.com>
 <20220504093000.132579-7-clement.leger@bootlin.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20220504093000.132579-7-clement.leger@bootlin.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, May 04, 2022 at 11:29:54AM +0200, Clément Léger wrote:
> Add Renesas RZ/N1 advanced 5 port switch driver. This switch handles 5
> ports including 1 CPU management port. A MDIO bus is also exposed by
> this switch and allows to communicate with PHYs connected to the ports.
> Each switch port (except for the CPU management ports) is connected to
> the MII converter.
> 
> This driver includes basic bridging support, more support will be added
> later (vlan, etc).
> 
> Suggested-by: Jean-Pierre Geslin <jean-pierre.geslin@non.se.com>
> Suggested-by: Phil Edworthy <phil.edworthy@renesas.com>
> Signed-off-by: Clément Léger <clement.leger@bootlin.com>
> ---
> +static void a5psw_port_disable(struct dsa_switch *ds, int port)
> +{
> +	struct a5psw *a5psw = ds->priv;
> +
> +	a5psw_port_authorize_set(a5psw, port, false);
> +	a5psw_port_enable_set(a5psw, port, false);
> +	a5psw_port_fdb_flush(a5psw, port);

The bridge core takes care of this by setting the port state to
DISABLED, which makes DSA call dsa_port_fast_age(), no?

Standalone ports shouldn't need fast ageing because they shouldn't have
address learning enabled in the first place.

> +}

> +static int a5psw_port_bridge_join(struct dsa_switch *ds, int port,
> +				  struct dsa_bridge bridge,
> +				  bool *tx_fwd_offload,
> +				  struct netlink_ext_ack *extack)
> +{
> +	struct a5psw *a5psw = ds->priv;
> +
> +	/* We only support 1 bridge device */
> +	if (a5psw->br_dev && bridge.dev != a5psw->br_dev)
> +		return -EINVAL;

return -EOPNOTSUPP, to allow software bridging.
You might also want to set an extack message here and avoid overwriting
it in dsa_slave_changeupper() with "Offloading not supported", but say
something more specific like "Forwarding offload supported for a single
bridge".

> +
> +	a5psw->br_dev = bridge.dev;
> +	a5psw_flooding_set_resolution(a5psw, port, true);
> +	a5psw_port_mgmtfwd_set(a5psw, port, false);
> +
> +	return 0;
> +}
> +
> +static void a5psw_port_bridge_leave(struct dsa_switch *ds, int port,
> +				    struct dsa_bridge bridge)
> +{
> +	struct a5psw *a5psw = ds->priv;
> +
> +	a5psw_flooding_set_resolution(a5psw, port, false);
> +	a5psw_port_mgmtfwd_set(a5psw, port, true);
> +
> +	/* No more port bridged */

s/port/ports/

> +	if (a5psw->bridged_ports == BIT(A5PSW_CPU_PORT))
> +		a5psw->br_dev = NULL;
> +}

> +static int a5psw_pcs_get(struct a5psw *a5psw)
> +{
> +	struct device_node *ports, *port, *pcs_node;
> +	struct phylink_pcs *pcs;
> +	int ret;
> +	u32 reg;
> +
> +	ports = of_get_child_by_name(a5psw->dev->of_node, "ports");

Can you please do:

	ports = of_get_child_by_name(a5psw->dev->of_node, "ethernet-ports");
	if (!ports)
		ports = of_get_child_by_name(a5psw->dev->of_node, "ports");

> +	if (!ports)
> +		return -EINVAL;
> +
> +	for_each_available_child_of_node(ports, port) {
> +		pcs_node = of_parse_phandle(port, "pcs-handle", 0);
> +		if (!pcs_node)
> +			continue;
> +
> +		if (of_property_read_u32(port, "reg", &reg)) {
> +			ret = -EINVAL;
> +			goto free_pcs;
> +		}
> +
> +		if (reg >= ARRAY_SIZE(a5psw->pcs)) {
> +			ret = -ENODEV;
> +			goto free_pcs;
> +		}
> +
> +		pcs = miic_create(pcs_node);
> +		if (IS_ERR(pcs)) {
> +			dev_err(a5psw->dev, "Failed to create PCS for port %d\n",
> +				reg);
> +			ret = PTR_ERR(pcs);
> +			goto free_pcs;
> +		}
> +
> +		a5psw->pcs[reg] = pcs;
> +	}
> +	of_node_put(ports);
> +
> +	return 0;
> +
> +free_pcs:
> +	a5psw_pcs_free(a5psw);
> +
> +	return ret;
> +}

> +/* Ensure enough space for 2 VLAN tags */
> +#define A5PSW_EXTRA_MTU_LEN		(A5PSW_TAG_LEN + 8)
> +#define A5PSW_MAX_MTU			(A5PSW_JUMBO_LEN - A5PSW_EXTRA_MTU_LEN)
> +#define A5PSW_MGMT_TAG_VALUE		0xE001
> +
> +#define A5PSW_PATTERN_MGMTFWD		0
> +
> +#define A5PSW_LK_BUSY_USEC_POLL		10
> +#define A5PSW_CTRL_TIMEOUT		1000
> +#define A5PSW_TABLE_ENTRIES		8192
> +
> +/**
> + * struct a5psw - switch struct
> + * @base: Base address of the switch
> + * @hclk: hclk_switch clock
> + * @clk: clk_switch clock
> + * @dev: Device associated to the switch
> + * @mii_bus: MDIO bus struct
> + * @mdio_freq: MDIO bus frequency requested
> + * @pcs: Array of PCS connected to the switch ports (not for the CPU)
> + * @ds: DSA switch struct
> + * @lk_lock: Lock for the lookup table
> + * @reg_lock: Lock for register read-modify-write operation
> + * @bridged_ports: List of ports that are bridged and should be flooded

s/List/Mask/

> + * @br_dev: Bridge net device
> + */
> +struct a5psw {
> +	void __iomem *base;
> +	struct clk *hclk;
> +	struct clk *clk;
> +	struct device *dev;
> +	struct mii_bus	*mii_bus;
> +	struct phylink_pcs *pcs[A5PSW_PORTS_NUM - 1];
> +	struct dsa_switch ds;
> +	spinlock_t lk_lock;
> +	spinlock_t reg_lock;
> +	u32 bridged_ports;
> +	struct net_device *br_dev;
> +};
> -- 
> 2.34.1
> 


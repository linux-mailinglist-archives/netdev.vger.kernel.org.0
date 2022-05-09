Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1CB73520200
	for <lists+netdev@lfdr.de>; Mon,  9 May 2022 18:10:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238883AbiEIQMO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 May 2022 12:12:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51680 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238850AbiEIQMN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 May 2022 12:12:13 -0400
Received: from mail-ed1-x52e.google.com (mail-ed1-x52e.google.com [IPv6:2a00:1450:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2DF29270C8A;
        Mon,  9 May 2022 09:08:19 -0700 (PDT)
Received: by mail-ed1-x52e.google.com with SMTP id ba17so16879052edb.5;
        Mon, 09 May 2022 09:08:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=qpVSIRHLciQG1lJnk05gcj0OOBt3+jSZsfgixWYIteE=;
        b=Mci7nN1U48tC8u15wuILJos0lwuwNF9NQhf2lqJGQGj5DaeLz3B2uwGU2VTGbEpAqK
         jD6wtJqHoxF+knHnwMuQ8aYufm0kUXlXuM7RQD7pe/YymePBq7itDofWQoGOJOVJ5/IC
         XkStkfFnLV8dQ2cXCvnkOeiwXOgpIxWyJWi3ESdzwZkNU0bY5cSPWsPSnvVeWubQUEVO
         cxT742mRgLHSg27CEZ1Ms/+yR0nWMcPcXMIz2OuCr70X0KXnxCJUFNYpuAqLjFwabGNs
         6Q9qIeCh4D7vkFcEzMFAXR2muOsqFNiHV5628vFEDdU2US00RHiwUuSFTjJWt9ZGxNAj
         oWOA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=qpVSIRHLciQG1lJnk05gcj0OOBt3+jSZsfgixWYIteE=;
        b=lM9Yw7ZhCvjleRCNQo2PUSdsAoJWn5mCNs+w7pk2yuSNaUJ5O3Hk0de2ox2XJxM9r9
         24qln7r2hztTRMtYhX1MSBzjT5jA5fv0uTdm2Rf7U/pjxxhy4ympILZkXGr9NJgx9/hK
         zCFqDc5xfLdW1E7+rg1ITn+TSD80L22N56vP/QDD3sgnVThMprMy029k3Eo29Cu/pmS4
         vVAIPAp3uwZfLXRcWfN0jegKwiKGoweMbfWWGfXoIUHV+LKCM6Ppa1keSK3ood1beeJt
         yCjEIV+4/qwzmL8PqLqJzrz+zMSQFJsFRSfFyx2//85M+Oz2EqrYje54T0qDGeWW5U9y
         KKog==
X-Gm-Message-State: AOAM533ze9Hn3kE5iEDwEC68L1+vV/rBncijkN7jgPoOcykviPaZPjLH
        OsvaFMTmFviwHHkS0ddsR2U=
X-Google-Smtp-Source: ABdhPJzvNkOIu8i7ui8m8hMrQINj908JMFjiHuM+ZFnTOC2FqTY5Y/ZELRXEwKEXntDSN4d3FRS4qg==
X-Received: by 2002:a05:6402:1a42:b0:424:20bb:3e37 with SMTP id bf2-20020a0564021a4200b0042420bb3e37mr17707069edb.29.1652112497589;
        Mon, 09 May 2022 09:08:17 -0700 (PDT)
Received: from skbuf ([188.25.160.86])
        by smtp.gmail.com with ESMTPSA id ig11-20020a1709072e0b00b006f3ef214e2csm5339743ejc.146.2022.05.09.09.08.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 09 May 2022 09:08:15 -0700 (PDT)
Date:   Mon, 9 May 2022 19:08:13 +0300
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
Subject: Re: [PATCH net-next v4 06/12] net: dsa: rzn1-a5psw: add Renesas
 RZ/N1 advanced 5 port switch driver
Message-ID: <20220509160813.stfqb4c2houmfn2g@skbuf>
References: <20220509131900.7840-1-clement.leger@bootlin.com>
 <20220509131900.7840-7-clement.leger@bootlin.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20220509131900.7840-7-clement.leger@bootlin.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, May 09, 2022 at 03:18:54PM +0200, Clément Léger wrote:
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
> +static int a5psw_port_bridge_join(struct dsa_switch *ds, int port,
> +				  struct dsa_bridge bridge,
> +				  bool *tx_fwd_offload,
> +				  struct netlink_ext_ack *extack)
> +{
> +	struct a5psw *a5psw = ds->priv;
> +
> +	/* We only support 1 bridge device */
> +	if (a5psw->br_dev && bridge.dev != a5psw->br_dev) {
> +		NL_SET_ERR_MSG_MOD(extack,
> +				   "Forwarding offload supported for a single bridge");

I don't think I saw the dsa_slave_changeupper() patch that avoids
overwriting the extack when dsa_port_bridge_join() returns -EOPNOTSUPP.

> +		return -EOPNOTSUPP;
> +	}
> +
> +	a5psw->br_dev = bridge.dev;
> +	a5psw_flooding_set_resolution(a5psw, port, true);
> +	a5psw_port_mgmtfwd_set(a5psw, port, false);
> +
> +	return 0;

By the way, does this switch pass tools/testing/selftests/drivers/net/dsa/no_forwarding.sh?

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
> +	/* No more ports bridged */
> +	if (a5psw->bridged_ports == BIT(A5PSW_CPU_PORT))
> +		a5psw->br_dev = NULL;
> +}
> +
> +static int a5psw_pcs_get(struct a5psw *a5psw)
> +{
> +	struct device_node *ports, *port, *pcs_node;
> +	struct phylink_pcs *pcs;
> +	int ret;
> +	u32 reg;
> +
> +	ports = of_get_child_by_name(a5psw->dev->of_node, "ethernet-ports");
> +	if (!ports)
> +		ports = of_get_child_by_name(a5psw->dev->of_node, "ports");
> +
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

The error path is missing of_node_put(ports).

> +	a5psw_pcs_free(a5psw);
> +
> +	return ret;
> +}
> +
> +static int a5psw_probe(struct platform_device *pdev)
> +{
> +	struct device *dev = &pdev->dev;
> +	struct device_node *mdio;
> +	struct dsa_switch *ds;
> +	struct a5psw *a5psw;
> +	int ret;
> +
> +	a5psw = devm_kzalloc(dev, sizeof(*a5psw), GFP_KERNEL);
> +	if (!a5psw)
> +		return -ENOMEM;
> +
> +	a5psw->dev = dev;
> +	spin_lock_init(&a5psw->lk_lock);
> +	spin_lock_init(&a5psw->reg_lock);
> +	a5psw->base = devm_platform_ioremap_resource(pdev, 0);
> +	if (!a5psw->base)
> +		return -EINVAL;
> +
> +	ret = a5psw_pcs_get(a5psw);
> +	if (ret)
> +		return ret;
> +
> +	a5psw->hclk = devm_clk_get(dev, "hclk");
> +	if (IS_ERR(a5psw->hclk)) {
> +		dev_err(dev, "failed get hclk clock\n");
> +		ret = PTR_ERR(a5psw->hclk);
> +		goto free_pcs;
> +	}
> +
> +	a5psw->clk = devm_clk_get(dev, "clk");
> +	if (IS_ERR(a5psw->clk)) {
> +		dev_err(dev, "failed get clk_switch clock\n");
> +		ret = PTR_ERR(a5psw->clk);
> +		goto free_pcs;
> +	}
> +
> +	ret = clk_prepare_enable(a5psw->clk);
> +	if (ret)
> +		goto free_pcs;
> +
> +	ret = clk_prepare_enable(a5psw->hclk);
> +	if (ret)
> +		goto clk_disable;
> +
> +	mdio = of_get_child_by_name(dev->of_node, "mdio");
> +	if (of_device_is_available(mdio)) {
> +		ret = a5psw_probe_mdio(a5psw, mdio);
> +		if (ret) {
> +			of_node_put(mdio);
> +			dev_err(&pdev->dev, "Failed to register MDIO: %d\n",
> +				ret);
> +			goto hclk_disable;
> +		}

Missing an of_node_put(mdio) if the device is available and ret == 0.

> +	} else {
> +		of_node_put(mdio);
> +	}
> +
> +	ds = &a5psw->ds;
> +	ds->dev = &pdev->dev;
> +	ds->num_ports = A5PSW_PORTS_NUM;
> +	ds->ops = &a5psw_switch_ops;
> +	ds->priv = a5psw;
> +
> +	ret = dsa_register_switch(ds);
> +	if (ret) {
> +		dev_err(&pdev->dev, "Failed to register DSA switch: %d\n", ret);
> +		goto hclk_disable;
> +	}
> +
> +	return 0;
> +
> +hclk_disable:
> +	clk_disable_unprepare(a5psw->hclk);
> +clk_disable:
> +	clk_disable_unprepare(a5psw->clk);
> +free_pcs:
> +	a5psw_pcs_free(a5psw);
> +
> +	return ret;
> +}
> +
> +static int a5psw_remove(struct platform_device *pdev)
> +{
> +	struct a5psw *a5psw = platform_get_drvdata(pdev);

I hate to repeat myself, but drivers in general can be removed after the device
was shut down. If that happens, you will dereference a platform_get_drvdata()
which is NULL, as set by yourself in a5psw_shutdown().

> +
> +	dsa_unregister_switch(&a5psw->ds);
> +	a5psw_pcs_free(a5psw);
> +	clk_disable_unprepare(a5psw->hclk);
> +	clk_disable_unprepare(a5psw->clk);
> +
> +	return 0;
> +}
> +
> +static void a5psw_shutdown(struct platform_device *pdev)
> +{
> +	struct a5psw *a5psw = platform_get_drvdata(pdev);
> +
> +	if (!a5psw)
> +		return;
> +
> +	dsa_switch_shutdown(&a5psw->ds);
> +
> +	platform_set_drvdata(pdev, NULL);
> +}

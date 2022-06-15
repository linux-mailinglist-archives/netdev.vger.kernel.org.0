Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6EF0354C126
	for <lists+netdev@lfdr.de>; Wed, 15 Jun 2022 07:33:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238803AbiFOFbQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Jun 2022 01:31:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52984 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234510AbiFOFbP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Jun 2022 01:31:15 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2992E49C99;
        Tue, 14 Jun 2022 22:31:14 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C0BDAB81C36;
        Wed, 15 Jun 2022 05:31:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 645AFC34115;
        Wed, 15 Jun 2022 05:31:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1655271071;
        bh=UP9/PPlSi1ds0ci9Dk+oUiyvyIrwws3/Ir1Z5PIAGWQ=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=epqJaVYUaaMbXOx6dxJme+50GCKJAN4hmd5ydrTMcFCZlBo2stNqNuemRouFNq3tJ
         seV6Df3/hG0OxFbINgCBRbEDAuzC3sWMlmPDjEeyVH8yspGMNrkD9vnGZ3jGo1aMdF
         WPUbnybKGsI8+bJg3BFaEW/lSvXsGWzvfnlI61Dxpc4f0VybKTBeXPVJdTf65SKRpt
         p0LIdJp9HYocDl3zqK+Yd0rP3JjxQAxUb3CBzTMsCwF73VFwWfOmp0OCtGaz+mDUpa
         D449yXNvobGB3j6Hqqmtc819Xed4vlDnRsPemlzYBkfTVjg7TJFCs6EeHz7+aXAxxC
         Oivda28Tyf4Bw==
Date:   Tue, 14 Jun 2022 22:31:09 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Russell King <linux@armlinux.org.uk>
Cc:     =?UTF-8?B?Q2zDqW1lbnQgTMOpZ2Vy?= <clement.leger@bootlin.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzk+dt@kernel.org>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Magnus Damm <magnus.damm@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        Herve Codina <herve.codina@bootlin.com>,
        =?UTF-8?B?TWlxdcOobA==?= Raynal <miquel.raynal@bootlin.com>,
        Milan Stevanovic <milan.stevanovic@se.com>,
        Jimmy Lalande <jimmy.lalande@se.com>,
        Pascal Eberhard <pascal.eberhard@se.com>,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
        linux-renesas-soc@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH RESEND net-next v7 05/16] net: pcs: add Renesas MII
 converter driver
Message-ID: <20220614223109.603935fb@kernel.org>
In-Reply-To: <20220610103712.550644-6-clement.leger@bootlin.com>
References: <20220610103712.550644-1-clement.leger@bootlin.com>
        <20220610103712.550644-6-clement.leger@bootlin.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 10 Jun 2022 12:37:01 +0200 Cl=C3=A9ment L=C3=A9ger wrote:
> Subject: [PATCH RESEND net-next v7 05/16] net: pcs: add Renesas MII conve=
rter driver
>=20
> Add a PCS driver for the MII converter that is present on the Renesas
> RZ/N1 SoC. This MII converter is reponsible for converting MII to
> RMII/RGMII or act as a MII pass-trough. Exposing it as a PCS allows to
> reuse it in both the switch driver and the stmmac driver. Currently,
> this driver only allows the PCS to be used by the dual Cortex-A7
> subsystem since the register locking system is not used.

Could someone with MII &| PCS knowledge cast an eye over this code?
All I can do is point out error path issues...

> +struct phylink_pcs *miic_create(struct device *dev, struct device_node *=
np)
> +{
> +	struct platform_device *pdev;
> +	struct miic_port *miic_port;
> +	struct device_node *pcs_np;
> +	struct miic *miic;
> +	u32 port;
> +
> +	if (!of_device_is_available(np))
> +		return ERR_PTR(-ENODEV);
> +
> +	if (of_property_read_u32(np, "reg", &port))
> +		return ERR_PTR(-EINVAL);
> +
> +	if (port > MIIC_MAX_NR_PORTS || port < 1)
> +		return ERR_PTR(-EINVAL);
> +
> +	/* The PCS pdev is attached to the parent node */
> +	pcs_np =3D of_get_parent(np);

of_get_parent()? ..

> +	if (!pcs_np)
> +		return ERR_PTR(-ENODEV);
> +
> +	if (!of_device_is_available(pcs_np))
> +		return ERR_PTR(-ENODEV);

.. more like of_leak_parent()

> +	pdev =3D of_find_device_by_node(pcs_np);
> +	if (!pdev || !platform_get_drvdata(pdev))
> +		return ERR_PTR(-EPROBE_DEFER);
> +
> +	miic_port =3D kzalloc(sizeof(*miic_port), GFP_KERNEL);
> +	if (!miic_port)
> +		return ERR_PTR(-ENOMEM);
> +
> +	miic =3D platform_get_drvdata(pdev);
> +	device_link_add(dev, miic->dev, DL_FLAG_AUTOREMOVE_CONSUMER);
> +
> +	miic_port->miic =3D miic;
> +	miic_port->port =3D port - 1;
> +	miic_port->pcs.ops =3D &miic_phylink_ops;
> +
> +	return &miic_port->pcs;
> +}
> +EXPORT_SYMBOL(miic_create);

> +static int miic_parse_dt(struct device *dev, u32 *mode_cfg)
> +{
> +	s8 dt_val[MIIC_MODCTRL_CONF_CONV_NUM];
> +	struct device_node *np =3D dev->of_node;
> +	struct device_node *conv;
> +	u32 conf;
> +	int port;
> +
> +	memset(dt_val, MIIC_MODCTRL_CONF_NONE, sizeof(dt_val));
> +
> +	of_property_read_u32(np, "renesas,miic-switch-portin", &conf);
> +	dt_val[0] =3D conf;
> +
> +	for_each_child_of_node(np, conv) {
> +		if (of_property_read_u32(conv, "reg", &port))
> +			continue;
> +
> +		if (!of_device_is_available(conv))
> +			continue;
> +
> +		if (of_property_read_u32(conv, "renesas,miic-input", &conf) =3D=3D 0)
> +			dt_val[port] =3D conf;
> +
> +		of_node_put(conv);

Don't these iteration functions put() the current before taking the
next one all by themselves? Or is there supposed to be a "break" here?

> +	}
> +
> +	return miic_match_dt_conf(dev, dt_val, mode_cfg);
> +}

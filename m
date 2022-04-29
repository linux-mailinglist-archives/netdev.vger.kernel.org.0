Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7A726514DD1
	for <lists+netdev@lfdr.de>; Fri, 29 Apr 2022 16:44:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1377491AbiD2OsE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 Apr 2022 10:48:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34504 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1377257AbiD2OsD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 29 Apr 2022 10:48:03 -0400
Received: from relay2-d.mail.gandi.net (relay2-d.mail.gandi.net [IPv6:2001:4b98:dc4:8::222])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EF59787212;
        Fri, 29 Apr 2022 07:44:43 -0700 (PDT)
Received: (Authenticated sender: clement.leger@bootlin.com)
        by mail.gandi.net (Postfix) with ESMTPSA id 66EB240006;
        Fri, 29 Apr 2022 14:44:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=gm1;
        t=1651243482;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=6VZp545cL1tkFy7Ufnki1RQqtXzhp7N0eLBFHK/NFwQ=;
        b=Jn07hk8vRLFNfuylZda/8CXThhdBxH2nk8vdeQK3qdjSvA67vX8dTZVbEGnoBS3sCx9bFB
        mLFGVf8Xd0EwSIzSMbTYcXzBb28FT+URogjj8ucrOt6c1+L1tziEzxlpqxSY5x6SFFE5kx
        m6K25lC1yiSoZPeBI7LqnS22SYbwq2LOKTd3MyMr0no8VWxsNlqzBTyiVb2JIGwargLMPS
        D9bnUcl0X7F8n4d7cvHLfU2QET85EtLw2g8QTk8MGhyqRsUUs/YGTU3csHlT5WFxx7PPzb
        wyj2/5KGuWA2YuQvvmfD0ZXN331NP/bXmLcSBvgt9dxfmF8VbwnLZro3smfIOA==
Date:   Fri, 29 Apr 2022 16:43:22 +0200
From:   =?UTF-8?B?Q2zDqW1lbnQgTMOpZ2Vy?= <clement.leger@bootlin.com>
To:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzk+dt@kernel.org>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Magnus Damm <magnus.damm@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>
Cc:     Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        Herve Codina <herve.codina@bootlin.com>,
        =?UTF-8?B?TWlxdcOobA==?= Raynal <miquel.raynal@bootlin.com>,
        Milan Stevanovic <milan.stevanovic@se.com>,
        Jimmy Lalande <jimmy.lalande@se.com>,
        Pascal Eberhard <pascal.eberhard@se.com>,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
        linux-renesas-soc@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [net-next v2 04/12] net: pcs: add Renesas MII converter driver
Message-ID: <20220429164322.3f5cedd2@fixe.home>
In-Reply-To: <20220429143505.88208-5-clement.leger@bootlin.com>
References: <20220429143505.88208-1-clement.leger@bootlin.com>
        <20220429143505.88208-5-clement.leger@bootlin.com>
Organization: Bootlin
X-Mailer: Claws Mail 4.0.0 (GTK+ 3.24.31; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Le Fri, 29 Apr 2022 16:34:57 +0200,
Cl=C3=A9ment L=C3=A9ger <clement.leger@bootlin.com> a =C3=A9crit :

> +
> +static struct miic_port *phylink_pcs_to_miic_port(struct phylink_pcs *pc=
s)
> +{
> +	return container_of(pcs, struct miic_port, pcs);
> +}
> +
> +static void miic_reg_writel(struct miic *miic, int offset, u32 value)
> +{
> +	writel(value, miic->base + offset);
> +
> +	pr_err("Udpdating MIIC register %d with val %x\n", offset, value);

Spurious error message.

> +
> +static void miic_link_up(struct phylink_pcs *pcs, unsigned int mode,
> +			 phy_interface_t interface, int speed, int duplex)
> +{
> +	struct miic_port *miic_port =3D phylink_pcs_to_miic_port(pcs);
> +	struct miic *miic =3D miic_port->miic;
> +	int port =3D miic_port->port;
> +	u32 conv_speed =3D 0, val =3D 0;

Missing reverse christmas tree declaration.
> +
> +static void miic_dump_conf(struct device *dev,
> +			   s8 conf[MIIC_MODCTRL_CONF_CONV_NUM])
> +{
> +	int i;
> +	const char *conf_name;

Ditto.


--=20
Cl=C3=A9ment L=C3=A9ger,
Embedded Linux and Kernel engineer at Bootlin
https://bootlin.com

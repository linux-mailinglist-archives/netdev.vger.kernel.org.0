Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5F79D5170D1
	for <lists+netdev@lfdr.de>; Mon,  2 May 2022 15:43:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1385353AbiEBNrP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 May 2022 09:47:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52718 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242565AbiEBNrO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 2 May 2022 09:47:14 -0400
Received: from relay6-d.mail.gandi.net (relay6-d.mail.gandi.net [IPv6:2001:4b98:dc4:8::226])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E63BA288;
        Mon,  2 May 2022 06:43:43 -0700 (PDT)
Received: (Authenticated sender: clement.leger@bootlin.com)
        by mail.gandi.net (Postfix) with ESMTPSA id 35F31C000D;
        Mon,  2 May 2022 13:43:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=gm1;
        t=1651499022;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=rTNTBDxgKfkBKLVRJS6UhHxHs1szeuwpqo0QEGwYx7Q=;
        b=UkiAgflMq3OoaHbggQd0NS0/zduGzlUMCyALI3kHiXg7gWA2J/uDsAVmLsICsMkgPkzJd+
        XMEDtKiURDChQVwwbPFRvGa4G7VVupAEYSXuHzxavduYZ7J949sEJ2hCUsxVU6GwX5nNB3
        qIhZW3o/2h4A045/2QcjuQCiBhcdLClcxgja55wM4fRjExUngPwMK9xAd5ZgeHDVA6f6EH
        XVlQIiZkJyf1WkXxtOu+kI7crbWM6ZP8e2vEff4dXDNFeNVGpzx4r4YdB1HlMpFpRhM/Ce
        sbHgQRxwVxxcots4dufruojEKQYZZaR9IXQCqw6H/T3NIQDjUCPpRpDJCBGIbw==
Date:   Mon, 2 May 2022 15:43:38 +0200
From:   =?UTF-8?B?Q2zDqW1lbnQgTMOpZ2Vy?= <clement.leger@bootlin.com>
To:     Florian Fainelli <f.fainelli@gmail.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
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
        Russell King <linux@armlinux.org.uk>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        Herve Codina <herve.codina@bootlin.com>,
        =?UTF-8?B?TWlxdcOobA==?= Raynal <miquel.raynal@bootlin.com>,
        Milan Stevanovic <milan.stevanovic@se.com>,
        Jimmy Lalande <jimmy.lalande@se.com>,
        Pascal Eberhard <pascal.eberhard@se.com>,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
        linux-renesas-soc@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [net-next v2 02/12] net: dsa: add Renesas RZ/N1 switch tag
 driver
Message-ID: <20220502154338.201a7416@xps-bootlin>
In-Reply-To: <baec3c8d-72f1-b1b5-f472-ee73be1047d6@gmail.com>
References: <20220429143505.88208-1-clement.leger@bootlin.com>
        <20220429143505.88208-3-clement.leger@bootlin.com>
        <baec3c8d-72f1-b1b5-f472-ee73be1047d6@gmail.com>
Organization: Bootlin
X-Mailer: Claws Mail 4.1.0 (GTK 3.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Le Fri, 29 Apr 2022 09:22:21 -0700,
Florian Fainelli <f.fainelli@gmail.com> a =C3=A9crit :

> On 4/29/22 07:34, Cl=C3=A9ment L=C3=A9ger wrote:
> > The switch that is present on the Renesas RZ/N1 SoC uses a specific
> > VLAN value followed by 6 bytes which contains forwarding
> > configuration.
> >=20
> > Signed-off-by: Cl=C3=A9ment L=C3=A9ger <clement.leger@bootlin.com>
> > --- =20
>=20
> [snip]
>=20
> > +struct a5psw_tag {
> > +	__be16 ctrl_tag;
> > +	__be16 ctrl_data;
> > +	__be16 ctrl_data2_hi;
> > +	__be16 ctrl_data2_lo;
> > +} __packed; =20
>=20
> The structure should already be naturally aligned.

Indeed, I'll remove this packed attribute.

>=20
> > +
> > +static struct sk_buff *a5psw_tag_xmit(struct sk_buff *skb, struct
> > net_device *dev) +{
> > +	struct dsa_port *dp =3D dsa_slave_to_port(dev);
> > +	struct a5psw_tag *ptag;
> > +	u32 data2_val;
> > +
> > +	BUILD_BUG_ON(sizeof(*ptag) !=3D A5PSW_TAG_LEN);
> > +
> > +	/* The Ethernet switch we are interfaced with needs
> > packets to be at
> > +	 * least 64 bytes (including FCS) otherwise they will be
> > discarded when
> > +	 * they enter the switch port logic. When tagging is
> > enabled, we need
> > +	 * to make sure that packets are at least 68 bytes
> > (including FCS and
> > +	 * tag). =20
>=20
> Did you mean 70 bytes since your tag is 6, and not 4 bytes?

Yes you are right, this should be 70 bytes. Additionnaly, I forgot to
add the FCS len to the number of byte to be padded below.



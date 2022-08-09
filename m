Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2B35258D54F
	for <lists+netdev@lfdr.de>; Tue,  9 Aug 2022 10:24:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235849AbiHIIYv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Aug 2022 04:24:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32810 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229567AbiHIIYu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 9 Aug 2022 04:24:50 -0400
Received: from galois.linutronix.de (Galois.linutronix.de [193.142.43.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5570462EE;
        Tue,  9 Aug 2022 01:24:48 -0700 (PDT)
From:   Kurt Kanzenbach <kurt@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1660033486;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=XOANnQIgW3aAbW5LfRI6DNFCWo8HlrGXax9XfkwIOvw=;
        b=J0qc2M5dFGUOfEMj/pHfg3Bj3A12SAXDIneYAOi1AyVHT+NK1irTS97V1AWO8Ni/yAp/DS
        pGzEmNb5PR2k4EPimzq9wwfG2Ed0gZbtgZ2mvN60tjzf3ciRDdl9PNqJi6k9hv7TxWYdcz
        Hume5zUzJDzUcf5OEXYmhybRPhoxX1cqToy/39/xW1yViTjlBVuNgJytHLrD3Fb+0l8ixl
        lgTtMTcREGvu+mTSc8mGQSZFMHJQc+B5hV04pqqyDIdZBSO+sFUhcE/DZI/C1vbfIYintn
        zY8dId0N6tVkNlgg6OZXk9kCDFcI02L1GYfMSmvs4FFu7KZFXze45WoEaKe1GA==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1660033486;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=XOANnQIgW3aAbW5LfRI6DNFCWo8HlrGXax9XfkwIOvw=;
        b=lru1oi1+CrBYjUdcetVA6g9asvhuotMjj7MKBbPgSl+JQrs3qBjqzlOls27OY8Wpna1O4T
        BX8lJbWkJAh2wCDA==
To:     Vladimir Oltean <vladimir.oltean@nxp.com>, netdev@vger.kernel.org
Cc:     devicetree@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Oleksij Rempel <linux@rempel-privat.de>,
        Christian Marangi <ansuelsmth@gmail.com>,
        John Crispin <john@phrozen.org>,
        Mans Rullgard <mans@mansr.com>,
        Arun Ramadoss <arun.ramadoss@microchip.com>,
        Woojung Huh <woojung.huh@microchip.com>,
        UNGLinuxDriver@microchip.com,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        George McCollister <george.mccollister@gmail.com>,
        DENG Qingfang <dqfext@gmail.com>,
        Sean Wang <sean.wang@mediatek.com>,
        Landen Chao <Landen.Chao@mediatek.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Hauke Mehrtens <hauke@hauke-m.de>,
        Martin Blumenstingl <martin.blumenstingl@googlemail.com>,
        Aleksander Jan Bajkowski <olek2@wp.pl>,
        Alvin =?utf-8?Q?=C5=A0ipraga?= <alsi@bang-olufsen.dk>,
        Luiz Angelo Daros de Luca <luizluca@gmail.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Pawel Dembicki <paweldembicki@gmail.com>,
        =?utf-8?Q?Cl=C3=A9ment_L=C3=A9ger?= <clement.leger@bootlin.com>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Russell King <rmk+kernel@armlinux.org.uk>,
        Marek =?utf-8?Q?Beh=C3=BAn?= <kabel@kernel.org>,
        Marcin Wojtas <mw@semihalf.com>, Marek Vasut <marex@denx.de>,
        linux-renesas-soc@vger.kernel.org,
        Frank Rowand <frowand.list@gmail.com>
Subject: Re: [RFC PATCH v3 net-next 10/10] net: dsa: make phylink-related OF
 properties mandatory on DSA and CPU ports
In-Reply-To: <20220806141059.2498226-11-vladimir.oltean@nxp.com>
References: <20220806141059.2498226-1-vladimir.oltean@nxp.com>
 <20220806141059.2498226-11-vladimir.oltean@nxp.com>
Date:   Tue, 09 Aug 2022 10:24:43 +0200
Message-ID: <87h72lx1ro.fsf@kurt>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
        micalg=pgp-sha512; protocol="application/pgp-signature"
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--=-=-=
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Sat Aug 06 2022, Vladimir Oltean wrote:
[...]
> +static const char * const dsa_switches_dont_enforce_validation[] =3D {
> +#if IS_ENABLED(CONFIG_NET_DSA_HIRSCHMANN_HELLCREEK)
> +	"hirschmann,hellcreek-de1soc-r1",
> +#endif

You can safely remove that one. I've updated all downstream DTS files accor=
dingly.=20

Thanks,
Kurt

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQJHBAEBCgAxFiEEvLm/ssjDfdPf21mSwZPR8qpGc4IFAmLyGcsTHGt1cnRAbGlu
dXRyb25peC5kZQAKCRDBk9HyqkZzgnetD/sHUuK8jc/OsCLUnFTJPln0wEOg1gWn
Xn9qOw8eN/OurTvefVq1CSJDc4JgdW9zKJF+OmkBbhvIHkIO0x8HACWvYpaIfc4/
YdYuFUmsVgDxWQU/Gc3k7WoHEPa75IMqBofyp2xbq2cVUAquti9+x4rwmSXZk5WJ
UGr+kWkEWTYqHFpi+fEQh7CA91Hh6T3Dx7If7p/Nlfc6EmRD5hz+wUNlbiOf6sL2
17FkCAA1Yybekpmz18zVAS4eO8FrproyuvfXi/AlGRpapjoxSB/JdNUnNGIKbe5h
ji5I/vq4+wW/NazAh/F+diMRURn4dmwA2zX9hygJ1Voe4TXBdFqi5dj3p81OAeAr
lNjU1wWahJVQQOvxvdMjS6FjtQBY8bQz//SmyhZt5qNnGEsxcsyHKkmBV7YkA+wD
qqx8/ei3Fm7uI1FW7+GQm1+XX9FeS7CoUJ5oOEVSxkCchnxKO2mQAZHmtxtOXmFZ
96lI5kKZV1OAil2/JyEfZzhfgrovRDXbVlAUpP2He1GkIi7GNTQZNiGaeAQYW17L
JbslFc+D8Qs6Bk+Zvilt7PSLYxccKwK1CGl+TB9dRQE2eACS/hf+6i1bUzH9LmL8
1VeaCF6L2UPV2e7phL+UB5862qaW7gEWy2KlqNTtd2KzKS9zvKLxLwpmdydG7ped
v5X2tRdpar2kfw==
=oPLD
-----END PGP SIGNATURE-----
--=-=-=--

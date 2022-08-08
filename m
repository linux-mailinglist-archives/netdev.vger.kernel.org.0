Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8D7A158C2DF
	for <lists+netdev@lfdr.de>; Mon,  8 Aug 2022 07:31:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234922AbiHHFb3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Aug 2022 01:31:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59330 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233256AbiHHFb1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 8 Aug 2022 01:31:27 -0400
Received: from galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D80E0641F;
        Sun,  7 Aug 2022 22:31:26 -0700 (PDT)
From:   Kurt Kanzenbach <kurt@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1659936684;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=7Dw0RQXvBc2kKRj4xAlqJpYNon4vsUwnGQl85FZk3jQ=;
        b=Ecvt+JymeyJ+6Ybd/lC5IsM7hRrUzMr99jrcbZ39cqPhQZbfOhG2VbALoZojWCl+2b4Mz4
        UKXGmGXsXeWzcVJhnNjSPsHgjZpDGZufsARzCD5gkoM8vqkA1Cr8ucLqiQqUlRWaZjBiBz
        UggZJe2UlrXRzy2ZrzbomxQbJ+6cyxMo4jgRVbiC717/8614xALyHEl3lb99IVBzT29DJe
        Vm400MeFY12KsAvyT31WTHerJE5l1Grak9MeqqcWIOa9pFuxNpzgy6TZd79lmpkMg089TL
        QrBpFBdEUlg7+8dIQCEvUVCDsqacY6R2cE6zLFkiOpYVMqQAhFeX2G5CAxe0EA==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1659936684;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=7Dw0RQXvBc2kKRj4xAlqJpYNon4vsUwnGQl85FZk3jQ=;
        b=UsjBsSpcrzMzZdQbWFtcOeHL/uBpiZkraNINO+4KY6BAubeZcjnir/s8M8H5Q8AmA/51rZ
        nQS2qqt8aL+19SCg==
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
        linux-renesas-soc@vger.kernel.org
Subject: Re: [RFC PATCH v3 net-next 02/10] dt-bindings: net: dsa: hellcreek:
 add missing CPU port phy-mode/fixed-link to example
In-Reply-To: <20220806141059.2498226-3-vladimir.oltean@nxp.com>
References: <20220806141059.2498226-1-vladimir.oltean@nxp.com>
 <20220806141059.2498226-3-vladimir.oltean@nxp.com>
Date:   Mon, 08 Aug 2022 07:31:20 +0200
Message-ID: <87sfm7xpw7.fsf@kurt>
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

On Sat Aug 06 2022, Vladimir Oltean wrote:
> Looking at hellcreek_phylink_get_caps(), I see that depending on whether
> is_100_mbits is set, speeds of 1G or of 100M will be advertised. The
> de1soc_r1_pdata sets is_100_mbits to true.
>
> The PHY modes declared in the capabilities are MII, RGMII and GMII. GMII
> doesn't support 100Mbps, and as for RGMII, it would be a bit implausible
> to me to support this PHY mode but limit it to only 25 MHz. So I've
> settled on MII as a phy-mode in the example, and a fixed-link of
> 100Mbps.
>
> As a side note, there exists such a thing as "rev-mii", because the MII
> protocol is asymmetric, and "mii" is the designation for the MAC side
> (expected to be connected to a PHY), and "rev-mii" is the designation
> for the PHY side (expected to be connected to a MAC). I wonder whether
> "mii" or "rev-mii" should actually be used here, since this is a CPU
> port and presumably connected to another MAC.
>
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>

Reviewed-by: Kurt Kanzenbach <kurt@linutronix.de>

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQJHBAEBCgAxFiEEvLm/ssjDfdPf21mSwZPR8qpGc4IFAmLwn6gTHGt1cnRAbGlu
dXRyb25peC5kZQAKCRDBk9HyqkZzgnV1D/4jjpY2LHBzIngNbW80H26+NeagzhRL
WIma9gdVOSr6P9BKCRR7YOk1STqB1Ggwahy9QV/st9zaH4ZBC1TurrLtkRZ2UAxW
zZ+DsW6z08xd/sdbmLTth6TfGzEA3uk2BtmBYTJkeWxm+ln2fKfMpZ3YXC27eNyf
zB9t5k4fCcZfNA8HXAKUKSbprvypLuNssjGLzHL5UOb4KXuPONGOAMbY3D5ovqKS
cDw/SVKwPQXy14JzSS0sHli2gJtPyo485tH4rnqXhwBmhbYO1eW+/nE2ocRmkdKW
Viop1RTs6/xIbyJ9lbK9EcpRqOimaiImX7nDy1Qo2zD0nFWhmbWcKoTlgwZjX3A2
x8uT68hbcOVKT/bGdC6u2xbLrdO460exmn1iU9MoaRRcxpuku2IgyT//FiDS29cF
LoxTGvuUO7ziaD3DvWfRkemYZPR6g9X/84XBOP5J73SBgIN4xeMJCBggFZY4RvCg
VG/eVjfMcRV80yLEBv3pauBHpXzpndwBWi012JBCsKUdZLujDuXNPjKYB0TUIjwr
tB/q+m4/PDxCz+BHy6uCNxk2OOF1DcD/vx6yurEYWv+jXIxq/wooI7hYHDkAz4jQ
CLTDVv2GkMOmgwrP/NHcW6WbizCvOBaLTATSAdp+rAnDhhKn46OiDD1hUvJ5AAJO
KE4eDXO2ippa7w==
=h8JJ
-----END PGP SIGNATURE-----
--=-=-=--

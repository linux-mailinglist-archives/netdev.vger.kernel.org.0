Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A682CB9783
	for <lists+netdev@lfdr.de>; Fri, 20 Sep 2019 21:03:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2393258AbfITTC4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Sep 2019 15:02:56 -0400
Received: from mout.web.de ([212.227.15.3]:43639 "EHLO mout.web.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2391415AbfITTC4 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 20 Sep 2019 15:02:56 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=web.de;
        s=dbaedf251592; t=1569006162;
        bh=+xzRLQql5so0uF+9GF2myh5Z49YfJh7o8/sXYr6G2C8=;
        h=X-UI-Sender-Class:Subject:From:To:Cc:References:Date:In-Reply-To;
        b=KrNwgjt+O+h0wK7/rF8GsqKwWGwR4TGZhDrn2EfrGaGmtcRQkbxUe7JQcAkkEUIzH
         dgOJg21b7kmPOW61ID2VS9/F9X5o8cwm8IqFfNy0Xhmk5g+QP6pj7RdW+MpaymKz5G
         F3bW+Z6Me5ZHKOtFZuGJUmsBpPo/iNFRU1aJa4fw=
X-UI-Sender-Class: c548c8c5-30a9-4db5-a2e7-cb6cb037b8f9
Received: from [192.168.1.2] ([2.244.117.22]) by smtp.web.de (mrweb004
 [213.165.67.108]) with ESMTPSA (Nemesis) id 0LcUIo-1hkXx948F4-00jrA4; Fri, 20
 Sep 2019 21:02:42 +0200
Subject: [PATCH 1/2] net/phy/mdio-mscc-miim: Use
 devm_platform_ioremap_resource() in mscc_miim_probe()
From:   Markus Elfring <Markus.Elfring@web.de>
To:     netdev@vger.kernel.org,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Heiner Kallweit <hkallweit1@gmail.com>
Cc:     LKML <linux-kernel@vger.kernel.org>,
        kernel-janitors@vger.kernel.org
References: <189ccfc3-d5a6-79fd-29b8-1f7140e9639a@web.de>
Autocrypt: addr=Markus.Elfring@web.de; prefer-encrypt=mutual; keydata=
 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 FEE=
Message-ID: <506889a6-4148-89f9-302e-4be069595bb4@web.de>
Date:   Fri, 20 Sep 2019 21:02:40 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.0
MIME-Version: 1.0
In-Reply-To: <189ccfc3-d5a6-79fd-29b8-1f7140e9639a@web.de>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:IZ4s53M5EcVgufSPdpFXU97/i9BwcjQgdYEYOulM/9mFA4OqkdL
 ySNnASGdI5gctzlgt2OqyQhlyTQfvzMQwHliwWF3Ggn3kZTmQEEga6o76rbLmRzAKpWH2tW
 TX0rzOTsMcyBupn97YCN5SBu3KtcD/qjTtB6kB0wKPENVizrEiwXvqaf+ibCiYkmIdknMx4
 Es8AYNLTxEuQCZ1YcC2lg==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:wptcITCQ8Pw=:Wvzlmq5cmEMCsCCSdXBzXO
 mepu5J8kiSrT0GvxriDMfgWuQeOIEY1fCl41jDb6OVUVBc6ikJAh7/iiaL0KmjapEzTw0pUYS
 APxEjQdpVe5FxHmWE4ifW9F5YukI7uMNPqujDH/jbSKGyZt9jeSZSdg69dzXVW6LA0mqaSGSa
 L7DmhzNkmMTTOfjV74UKMdaOnI2HhYx/OmsKOaXjc5bjKcatiqP7Ao6H7HydrdMw33vk/PxlN
 5z/asVW4LCGUi6AH3Yi0cHO3re8Oz3wXQmQ0fvln+QJPaFp2l0wuj5KWj7faLJa2c2lOhFFpL
 6Eoxn01z4hTCp1Ncvnl20G1BHpnoCTRV4zhVojo1xVRqoEYI3VzBI4FIVXwAvZgp88efR3zBE
 ROCbKpaMgcTYEIXtf/ttROia2e9V2PTW8od1AwlLvUK9DM02ML3wQCN6U7Oea3X+MkKqv6uW6
 +ya0FYCnubscfKmC6EAtf+tzD1rfg3DEsJZYyp3q5lUa5moN4JzxCJoAmhRqGIl+Zhu2d1SmU
 5oBy7IMtAsXo+Z2Ys+dbtwsiPX7TnwkGP7rfzn6cs+UEoMFQMrX3FVgcHpIddh3uJAfCD916w
 2rW+dnfCYTSbOMu0meDdCRtmXMhjfuuApPVZ7u7PiPcFTXbC/nxT/wRju03sPSrw6n1Qcvv3O
 yMpw3bGH2mhAPguqYaND3E7vMm/Pj3rKHfwNrPXH6ckR5XkUl3c99HjpYS8Us2APxaXhxkX6r
 RJMuZRv3+D8nU/k8apsJTJNGGHeHwl5qIroGfwjNsdv84h1ih5YsbsfcRW/ceal/Q0Pz9jnKu
 HH0n34QpW4cK4maNE9EGkCdJnj2x+Czp3qVmTWh/EVLP9YKpgm8x3hduDuGOrMHoblWA5YFa+
 e1FCzsdWJn8MrsDZgxPJzCgqTO1R7qDM+v9wRaTA2QAh63iSAB0kdZM6SD6heFNyDwtTnUBX0
 JWcFNvvuT8Hk2IJK1VjdZFhqt3g3cnGSV4e0697cne/eA3BAvT/wlq2KCPqBWTMrvqFERmAoP
 Qwc8bz36pwYl16XCVVQNP4liMGaXdcdTXIOYgjal2y3ZSx5dSQdJrPUUcVHAmba3wLGwli2Gi
 CWClGMxtJjdMl/fNG6kAKGGC3SwuN/JEOnc16VrfNPkstnQGNmPU1QcnCe0kbHNum5e48DCIu
 tE/3P3Cwy6ASwj4+SRZLE/Gqthjah4Gf7s0qiWhUJB6sDm2u1Dv3m4NXY0AxQJpfmU8MyKNEU
 62OoV1Q6cwdepgpHxFFtP8BDdUmMurjgo7eAk51Wl1Bj7VPjw5XQRbRS3KwA=
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Markus Elfring <elfring@users.sourceforge.net>
Date: Fri, 20 Sep 2019 20:20:34 +0200

Simplify this function implementation by using a known wrapper function.

This issue was detected by using the Coccinelle software.

Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
=2D--
 drivers/net/phy/mdio-mscc-miim.c | 18 +++++-------------
 1 file changed, 5 insertions(+), 13 deletions(-)

diff --git a/drivers/net/phy/mdio-mscc-miim.c b/drivers/net/phy/mdio-mscc-=
miim.c
index badbc99bedd3..b36fe81b6e6d 100644
=2D-- a/drivers/net/phy/mdio-mscc-miim.c
+++ b/drivers/net/phy/mdio-mscc-miim.c
@@ -115,15 +115,10 @@ static int mscc_miim_reset(struct mii_bus *bus)

 static int mscc_miim_probe(struct platform_device *pdev)
 {
-	struct resource *res;
 	struct mii_bus *bus;
 	struct mscc_miim_dev *dev;
 	int ret;

-	res =3D platform_get_resource(pdev, IORESOURCE_MEM, 0);
-	if (!res)
-		return -ENODEV;
-
 	bus =3D devm_mdiobus_alloc_size(&pdev->dev, sizeof(*dev));
 	if (!bus)
 		return -ENOMEM;
@@ -136,19 +131,16 @@ static int mscc_miim_probe(struct platform_device *p=
dev)
 	bus->parent =3D &pdev->dev;

 	dev =3D bus->priv;
-	dev->regs =3D devm_ioremap_resource(&pdev->dev, res);
+	dev->regs =3D devm_platform_ioremap_resource(pdev, 0);
 	if (IS_ERR(dev->regs)) {
 		dev_err(&pdev->dev, "Unable to map MIIM registers\n");
 		return PTR_ERR(dev->regs);
 	}

-	res =3D platform_get_resource(pdev, IORESOURCE_MEM, 1);
-	if (res) {
-		dev->phy_regs =3D devm_ioremap_resource(&pdev->dev, res);
-		if (IS_ERR(dev->phy_regs)) {
-			dev_err(&pdev->dev, "Unable to map internal phy registers\n");
-			return PTR_ERR(dev->phy_regs);
-		}
+	dev->phy_regs =3D devm_platform_ioremap_resource(pdev, 1);
+	if (IS_ERR(dev->phy_regs)) {
+		dev_err(&pdev->dev, "Unable to map internal phy registers\n");
+		return PTR_ERR(dev->phy_regs);
 	}

 	ret =3D of_mdiobus_register(bus, pdev->dev.of_node);
=2D-
2.23.0


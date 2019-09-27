Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A77E3C00F6
	for <lists+netdev@lfdr.de>; Fri, 27 Sep 2019 10:18:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726785AbfI0ISm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 Sep 2019 04:18:42 -0400
Received: from mout.web.de ([212.227.15.14]:35087 "EHLO mout.web.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726027AbfI0ISl (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 27 Sep 2019 04:18:41 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=web.de;
        s=dbaedf251592; t=1569572311;
        bh=ZlJTddYajDzxZUvw2i60xJMbFlpFF4H6Ye3p0QwUyMo=;
        h=X-UI-Sender-Class:Subject:From:To:Cc:References:Date:In-Reply-To;
        b=BVBcpPNGFR5LcOh3zXb/Mrm6AEN1L7LdlOFugoKoiLU+ZqQEZU2BL5QlmkXV43tnp
         GoywS5GSWtVrqqSi4LtX6Gx0HQeZxvB/kDUVSy+xGlZnXWAIURR9gu3UopuSns2SRP
         RmrWq/GSIi23zbhEGMJZfkWpnwftEgLXWB1Qgies=
X-UI-Sender-Class: c548c8c5-30a9-4db5-a2e7-cb6cb037b8f9
Received: from [192.168.1.2] ([93.133.191.8]) by smtp.web.de (mrweb001
 [213.165.67.108]) with ESMTPSA (Nemesis) id 0MQf77-1iaYZu1bvJ-00U5Od; Fri, 27
 Sep 2019 10:18:31 +0200
Subject: [PATCH v2 2/2] net: phy: mscc-miim: Move the setting of mii_bus
 structure members in mscc_miim_probe()
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
 <506889a6-4148-89f9-302e-4be069595bb4@web.de> <20190920190908.GH3530@lunn.ch>
 <121e75c5-4d45-9df2-a471-6997a1fb3218@web.de>
 <20190926161825.GB6825@piout.net>
 <0a1f4dbf-4cc6-8530-a38e-31c3369e6db6@web.de>
 <20190926193239.GC6825@piout.net>
 <8fbfa9ad-182a-e2ce-e91f-7350523e33c7@web.de>
Autocrypt: addr=Markus.Elfring@web.de; prefer-encrypt=mutual; keydata=
 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 FEE=
Message-ID: <70ec73ad-19aa-76aa-168b-b9a2a6911938@web.de>
Date:   Fri, 27 Sep 2019 10:18:27 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.1
MIME-Version: 1.0
In-Reply-To: <8fbfa9ad-182a-e2ce-e91f-7350523e33c7@web.de>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:gPCXHdjuqZ85wND61koKlX9qwAqruudBe3+N42vkNHBPsWSClIb
 FbJ5QdZbKb9ZwLBnYem6VrXWllSQd90tG4JkwnJeNG1OVwGqnOWCB2HdBGgcP1i+C5NOAUQ
 QqQ9F3Co7FH0R9+TWZLS/MxbVbQmmy1Y7PqhPzAus8g3/itmYoDIXWHQpso7A+rctC/Mp1A
 m/nSbAS0NjY7yAmJZyPWw==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:MOvpmzHJPg8=:hK60pnbaJxC6i9n5RVJn0c
 SZi7HrwZaLApLO4XhUohpk+GmeuzqQ9w5EFgP3SwOp9czwvpLIbVH+mBJRuFemDSiBmqiknGI
 JGsSKXKkn189kM2OWy6IOlzydJohV4XEU6ZSDvrlDN5Twjr4aHs32Gm+nmZa6AAN9cxtS5e43
 q6jK/R41ofWo5eJzoKVBR3+WS2ITmLz3PVZocUEmG4UXdOTh+sMQimg76kC7kODBrtio+dEW/
 Dgckd/tw0iJ7H9zpKd8cdoPb/XC9be6y8MvKktIbbZOH7eAT6q3auLNz2VKJU5eCk/PYHmLQi
 RaA2EA844Ru2i5+l/qAtlTU4A4gjPUzGtcJZUBmjEvG9BFpRJEdtNyo66msw0qQkd5k8EgrcW
 r5Q3Ut325DaQGHzQXLNjTn/Zw5oEjGaO0DXJU7ZGE/T6lBJwyYLoTe+Oon0aEX1oznRtFnbSd
 2tB7HBBcWnPgIz2Qn/u3ZQMY/mQ2/vC/zmR1v2aVizaNsi69kU9bayGguvDjYMU25sqH4lV9r
 SpiGJsl0iMBN1U21YAsxPm4jzlvTGsY3yhtuRiRNlcOKpUjeVuEmDGPgrTVK5E61xsaUhJASz
 75uoxE9iGD4jaqiX9VjjZMgosTFXA0RbsnPy5xSmFmb+njThUFCMpmUllnw8dNKXC+9qXE/Es
 kGiWE0glIromXbwJPuz2C7MiGycMzPy3R2yHiNS1KSwlpQUf5YwLtz7mQQbudi0RBE7wEaoJL
 vTp/Vi2K34aKz36HcTTjv/xWC8NM5Gh/a3ZD+dXXxJjHUf1/ASBLZFeKxoHbGWFtSbTmr0BnI
 ZWceFcV+07NyBpi0u8G5U4umjM0ClOUToAIRflGrhIWl25yKd/HurGOo7dzZYYh/dLhkiN1Td
 /m+/XXT9obkc5jVFEIIw+/tYi9IjAdURwdRqdou5XKCGptBVn2MTVlqNRKSx5ldy/gsX8tjIm
 4s7qiasobkOzR8xzhnrs8xpy9JIHwIRAxxLbT4RFkCqgeGTNNjUlw+wxSzbUhISzGqPZJ/AHF
 J0LmzVI6t8va7hQRUmryl8TstH1mt8z69/Lj+2J95zxiKoz7rJtcnQnR97sp2AMgZEwhPphyW
 cG1XLYjlvWioQRnL9RQkzRtM2QVdNoncPSkp3QlCCRMag+RSotFlPKfFqhXPpJBGapC81SXs/
 4c9PH6k6zPdgTe/g64ygwoXLK+5clPZOzhEEquTuwzGMH5PiqcNLOqXdRQTvp+h0TSk3h6vhm
 t2EdoA95jwv4dVYdZ+gYvNByGR5N4U0KKlhjyqhlBXicJ3w/R+AtCk87IyyE=
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Markus Elfring <elfring@users.sourceforge.net>
Date: Fri, 27 Sep 2019 09:30:14 +0200

Move the modification of some members in the data structure =E2=80=9Cmii_b=
us=E2=80=9D
for the local variable =E2=80=9Cbus=E2=80=9D directly before the call of
the function =E2=80=9Cof_mdiobus_register=E2=80=9D so that this change wil=
l be performed
only after previous resource allocations succeeded.

Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
=2D--

v2:
This suggestion was repeated based on the change for the previous update s=
tep.


 drivers/net/phy/mdio-mscc-miim.c | 13 ++++++-------
 1 file changed, 6 insertions(+), 7 deletions(-)

diff --git a/drivers/net/phy/mdio-mscc-miim.c b/drivers/net/phy/mdio-mscc-=
miim.c
index aabb13982251..a270f83bb207 100644
=2D-- a/drivers/net/phy/mdio-mscc-miim.c
+++ b/drivers/net/phy/mdio-mscc-miim.c
@@ -124,13 +124,6 @@ static int mscc_miim_probe(struct platform_device *pd=
ev)
 	if (!bus)
 		return -ENOMEM;

-	bus->name =3D "mscc_miim";
-	bus->read =3D mscc_miim_read;
-	bus->write =3D mscc_miim_write;
-	bus->reset =3D mscc_miim_reset;
-	snprintf(bus->id, MII_BUS_ID_SIZE, "%s-mii", dev_name(&pdev->dev));
-	bus->parent =3D &pdev->dev;
-
 	dev =3D bus->priv;
 	dev->regs =3D devm_platform_ioremap_resource(pdev, 0);
 	if (IS_ERR(dev->regs)) {
@@ -147,6 +140,12 @@ static int mscc_miim_probe(struct platform_device *pd=
ev)
 		}
 	}

+	bus->name =3D "mscc_miim";
+	bus->read =3D mscc_miim_read;
+	bus->write =3D mscc_miim_write;
+	bus->reset =3D mscc_miim_reset;
+	snprintf(bus->id, MII_BUS_ID_SIZE, "%s-mii", dev_name(&pdev->dev));
+	bus->parent =3D &pdev->dev;
 	ret =3D of_mdiobus_register(bus, pdev->dev.of_node);
 	if (ret < 0) {
 		dev_err(&pdev->dev, "Cannot register MDIO bus (%d)\n", ret);
=2D-
2.23.0


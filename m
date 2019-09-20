Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C2E52B9789
	for <lists+netdev@lfdr.de>; Fri, 20 Sep 2019 21:04:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2393736AbfITTEK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Sep 2019 15:04:10 -0400
Received: from mout.web.de ([212.227.15.14]:47649 "EHLO mout.web.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2393485AbfITTEJ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 20 Sep 2019 15:04:09 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=web.de;
        s=dbaedf251592; t=1569006238;
        bh=rVyfZ2UYBc5Ewzf10tXDMMKVBD25jdpZOsxrYxMAJGs=;
        h=X-UI-Sender-Class:Subject:From:To:Cc:References:Date:In-Reply-To;
        b=JJF9I/rZTsbaeqZekRxfSN7k8LgWITBPqRykIndAQ8DCU691mu890jeJctpw1QhOK
         WpE2iD2ArtOtaeiFhnMavEIJqTljOSBNshzBuzN1vHQ06vzOFiPUtJDw+IuDrgf+cv
         NN6yQZuAtH7xW0dQQROPS4P+hSmdbuLxiVFMRthQ=
X-UI-Sender-Class: c548c8c5-30a9-4db5-a2e7-cb6cb037b8f9
Received: from [192.168.1.2] ([2.244.117.22]) by smtp.web.de (mrweb001
 [213.165.67.108]) with ESMTPSA (Nemesis) id 0LaTtv-1hmTqL1vWJ-00mIiX; Fri, 20
 Sep 2019 21:03:58 +0200
Subject: [PATCH 2/2] net/phy/mdio-mscc-miim: Move the setting of mii_bus
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
Autocrypt: addr=Markus.Elfring@web.de; prefer-encrypt=mutual; keydata=
 mQINBFg2+xABEADBJW2hoUoFXVFWTeKbqqif8VjszdMkriilx90WB5c0ddWQX14h6w5bT/A8
 +v43YoGpDNyhgA0w9CEhuwfZrE91GocMtjLO67TAc2i2nxMc/FJRDI0OemO4VJ9RwID6ltwt
 mpVJgXGKkNJ1ey+QOXouzlErVvE2fRh+KXXN1Q7fSmTJlAW9XJYHS3BDHb0uRpymRSX3O+E2
 lA87C7R8qAigPDZi6Z7UmwIA83ZMKXQ5stA0lhPyYgQcM7fh7V4ZYhnR0I5/qkUoxKpqaYLp
 YHBczVP+Zx/zHOM0KQphOMbU7X3c1pmMruoe6ti9uZzqZSLsF+NKXFEPBS665tQr66HJvZvY
 GMDlntZFAZ6xQvCC1r3MGoxEC1tuEa24vPCC9RZ9wk2sY5Csbva0WwYv3WKRZZBv8eIhGMxs
 rcpeGShRFyZ/0BYO53wZAPV1pEhGLLxd8eLN/nEWjJE0ejakPC1H/mt5F+yQBJAzz9JzbToU
 5jKLu0SugNI18MspJut8AiA1M44CIWrNHXvWsQ+nnBKHDHHYZu7MoXlOmB32ndsfPthR3GSv
 jN7YD4Ad724H8fhRijmC1+RpuSce7w2JLj5cYj4MlccmNb8YUxsE8brY2WkXQYS8Ivse39MX
 BE66MQN0r5DQ6oqgoJ4gHIVBUv/ZwgcmUNS5gQkNCFA0dWXznQARAQABtCZNYXJrdXMgRWxm
 cmluZyA8TWFya3VzLkVsZnJpbmdAd2ViLmRlPokCVAQTAQgAPhYhBHDP0hzibeXjwQ/ITuU9
 Figxg9azBQJYNvsQAhsjBQkJZgGABQsJCAcCBhUICQoLAgQWAgMBAh4BAheAAAoJEOU9Figx
 g9azcyMP/iVihZkZ4VyH3/wlV3nRiXvSreqg+pGPI3c8J6DjP9zvz7QHN35zWM++1yNek7Ar
 OVXwuKBo18ASlYzZPTFJZwQQdkZSV+atwIzG3US50ZZ4p7VyUuDuQQVVqFlaf6qZOkwHSnk+
 CeGxlDz1POSHY17VbJG2CzPuqMfgBtqIU1dODFLpFq4oIAwEOG6fxRa59qbsTLXxyw+PzRaR
 LIjVOit28raM83Efk07JKow8URb4u1n7k9RGAcnsM5/WMLRbDYjWTx0lJ2WO9zYwPgRykhn2
 sOyJVXk9xVESGTwEPbTtfHM+4x0n0gC6GzfTMvwvZ9G6xoM0S4/+lgbaaa9t5tT/PrsvJiob
 kfqDrPbmSwr2G5mHnSM9M7B+w8odjmQFOwAjfcxoVIHxC4Cl/GAAKsX3KNKTspCHR0Yag78w
 i8duH/eEd4tB8twcqCi3aCgWoIrhjNS0myusmuA89kAWFFW5z26qNCOefovCx8drdMXQfMYv
 g5lRk821ZCNBosfRUvcMXoY6lTwHLIDrEfkJQtjxfdTlWQdwr0mM5ye7vd83AManSQwutgpI
 q+wE8CNY2VN9xAlE7OhcmWXlnAw3MJLW863SXdGlnkA3N+U4BoKQSIToGuXARQ14IMNvfeKX
 NphLPpUUnUNdfxAHu/S3tPTc/E/oePbHo794dnEm57LuuQINBFg2+xABEADZg/T+4o5qj4cw
 nd0G5pFy7ACxk28mSrLuva9tyzqPgRZ2bdPiwNXJUvBg1es2u81urekeUvGvnERB/TKekp25
 4wU3I2lEhIXj5NVdLc6eU5czZQs4YEZbu1U5iqhhZmKhlLrhLlZv2whLOXRlLwi4jAzXIZAu
 76mT813jbczl2dwxFxcT8XRzk9+dwzNTdOg75683uinMgskiiul+dzd6sumdOhRZR7YBT+xC
 wzfykOgBKnzfFscMwKR0iuHNB+VdEnZw80XGZi4N1ku81DHxmo2HG3icg7CwO1ih2jx8ik0r
 riIyMhJrTXgR1hF6kQnX7p2mXe6K0s8tQFK0ZZmYpZuGYYsV05OvU8yqrRVL/GYvy4Xgplm3
 DuMuC7/A9/BfmxZVEPAS1gW6QQ8vSO4zf60zREKoSNYeiv+tURM2KOEj8tCMZN3k3sNASfoG
 fMvTvOjT0yzMbJsI1jwLwy5uA2JVdSLoWzBD8awZ2X/eCU9YDZeGuWmxzIHvkuMj8FfX8cK/
 2m437UA877eqmcgiEy/3B7XeHUipOL83gjfq4ETzVmxVswkVvZvR6j2blQVr+MhCZPq83Ota
 xNB7QptPxJuNRZ49gtT6uQkyGI+2daXqkj/Mot5tKxNKtM1Vbr/3b+AEMA7qLz7QjhgGJcie
 qp4b0gELjY1Oe9dBAXMiDwARAQABiQI8BBgBCAAmFiEEcM/SHOJt5ePBD8hO5T0WKDGD1rMF
 Alg2+xACGwwFCQlmAYAACgkQ5T0WKDGD1rOYSw/+P6fYSZjTJDAl9XNfXRjRRyJSfaw6N1pA
 Ahuu0MIa3djFRuFCrAHUaaFZf5V2iW5xhGnrhDwE1Ksf7tlstSne/G0a+Ef7vhUyeTn6U/0m
 +/BrsCsBUXhqeNuraGUtaleatQijXfuemUwgB+mE3B0SobE601XLo6MYIhPh8MG32MKO5kOY
 hB5jzyor7WoN3ETVNQoGgMzPVWIRElwpcXr+yGoTLAOpG7nkAUBBj9n9TPpSdt/npfok9ZfL
 /Q+ranrxb2Cy4tvOPxeVfR58XveX85ICrW9VHPVq9sJf/a24bMm6+qEg1V/G7u/AM3fM8U2m
 tdrTqOrfxklZ7beppGKzC1/WLrcr072vrdiN0icyOHQlfWmaPv0pUnW3AwtiMYngT96BevfA
 qlwaymjPTvH+cTXScnbydfOQW8220JQwykUe+sHRZfAF5TS2YCkQvsyf7vIpSqo/ttDk4+xc
 Z/wsLiWTgKlih2QYULvW61XU+mWsK8+ZlYUrRMpkauN4CJ5yTpvp+Orcz5KixHQmc5tbkLWf
 x0n1QFc1xxJhbzN+r9djSGGN/5IBDfUqSANC8cWzHpWaHmSuU3JSAMB/N+yQjIad2ztTckZY
 pwT6oxng29LzZspTYUEzMz3wK2jQHw+U66qBFk8whA7B2uAU1QdGyPgahLYSOa4XAEGb6wbI FEE=
Message-ID: <fe3ecdd2-a011-e4ed-5ef2-c3a8a02b343c@web.de>
Date:   Fri, 20 Sep 2019 21:03:57 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.0
MIME-Version: 1.0
In-Reply-To: <189ccfc3-d5a6-79fd-29b8-1f7140e9639a@web.de>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:Yb9zGoxPjM2G34AS5H+A2jM8Epd5wGi3vs0cr1Ys5cxPtFseC5Q
 +KqgalXy2OhCvkTLTLlkNskta7muWYnKhR1PsSZMVrGl7hsCAD1uIBDqsybrKaoSrWXxLhA
 FBIoghmqf9jpzi6V2/gOJPdrCowJTU8gl3ESdNpu1yz6spH/AMmA/CZJoV/fIPl0hgRr0yW
 eQ2W4Hr0tZa70yqnT0fkQ==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:oQQVd5Td7z0=:UC/0RQ8vC2enJUn2luDCd/
 ffqyYi76Teo/tMiCoqe2UofWwVHJdVHdGoD79Z5FO+5PihgqaNQrqvmkv0SYAiMfmRHJ3jZXL
 MsSgnxUF1T7Eey2ArmwNsuQTtqB4GCHRA+ImX2r0ynGcq3uoz0C9tQfUBor0GoG1XidcUc2Jx
 W8+210WFKCbfqztTRjA2niaG5Y3m+IAsHsZDDdronhQ1YBcQ7S2hypHOXCAZMKcSnikRKdczv
 5diyOwMz5zJsBki9W+y539bDT7XPegcKCUuLWunPyXc9Ta34WR0ARgovgi2rfzMWv/y0DqYkK
 HH73MrysBbiYizXxHh5FWwmbrmMPFw/IcLyEmQ/ue53zqdLzBVujdctiArnCAD/3G31BJmkst
 ariMSZRwzMMLhMa4QHTAf3nJqyEMGDJD2Tyh3D6YG4PZXmfU//4Z19QIPKjdoJE0xSgX2d4dM
 gjEMnsT9q5QI8yzhc7N2/YiAuXE/Ie+k+QyNXIJbCSG9R0tMQ5RssuMwlncgiD0xxANjrgniB
 DAr1BMmlIFEZwqbjpgLuRcgX5qK4MFF4RKsN7xAaIDKhJd83QYs/hFQ1r0eXtTh6Jl8/Uorx8
 eb0/fRmbQw8lD13b7YRJJsxOFW1hY5dE7VUy5o78oTOLb9WQxP2CtBo82sSGf3ufb5Sjq5dtK
 cnpYhiJ4o3wCV+0f1wYuqshY9zBEroueft9MM2LcMNCopmhmITM31T0c3Nx5cB9Do4k70upRv
 fPTSuCgZrcJa211Xy8zwIIFpqbwkOC9/ai7uiotyg4M/WCvFVZ5cwn3Hzp4WZHVDlqLR6m1n/
 wrFp/4szOW0t9DPHRuoAdcZaZIp6wqsjAajL2hinJdw+h9XnSruX/4HW3rkvsdyr2WZw1gbdT
 Z0CY8dxZU8zOeTY4sVN3LM4a+mvT6/1s/SadSz1kS04G4u2ThwXNpZHHv0GujX8YDJJ+Jhg9r
 98RgsRCxXNcnAba1lUyw0NT3Kmx11kWIpi7e3KGIvcH2othfB863sbLsDqGlXxQW1YeV9q00v
 YWGBnM6wYn76piOH2RRznicjePzWbaC2p6YD+gTXidLCR/rSzdYZBsqDYRsNuw3vHfqc9YqJM
 2YrftXqrh5QopDM1PwY2HCCGQ44K2iy2pN82iF18kn/FBkEuwXreQBP4ubaV2BrL++z/71MRw
 uui87MVqdD+a3TILusuPnMYLhSF4+Qzf3UuywOb/DAUimpfWPnsFdGPphRsfv7+g65ICotaoJ
 saz2lsXvPLtNhbrit5f2d26nO1cq8jVDF6mSDkXSokZB+Pgs4gjUfGCCA4qw=
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Markus Elfring <elfring@users.sourceforge.net>
Date: Fri, 20 Sep 2019 20:42:42 +0200

Move the modification of some members in the data structure =E2=80=9Cmii_b=
us=E2=80=9D
for the local variable =E2=80=9Cbus=E2=80=9D directly before the call of
the function =E2=80=9Cof_mdiobus_register=E2=80=9D so that this change wil=
l be performed
only after previous resource allocations succeeded.

Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
=2D--
 drivers/net/phy/mdio-mscc-miim.c | 13 ++++++-------
 1 file changed, 6 insertions(+), 7 deletions(-)

diff --git a/drivers/net/phy/mdio-mscc-miim.c b/drivers/net/phy/mdio-mscc-=
miim.c
index b36fe81b6e6d..c46e0c78402e 100644
=2D-- a/drivers/net/phy/mdio-mscc-miim.c
+++ b/drivers/net/phy/mdio-mscc-miim.c
@@ -123,13 +123,6 @@ static int mscc_miim_probe(struct platform_device *pd=
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
@@ -143,6 +136,12 @@ static int mscc_miim_probe(struct platform_device *pd=
ev)
 		return PTR_ERR(dev->phy_regs);
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


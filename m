Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 96B35C00F0
	for <lists+netdev@lfdr.de>; Fri, 27 Sep 2019 10:17:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726810AbfI0IRN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 Sep 2019 04:17:13 -0400
Received: from mout.web.de ([212.227.15.14]:51017 "EHLO mout.web.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726054AbfI0IRM (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 27 Sep 2019 04:17:12 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=web.de;
        s=dbaedf251592; t=1569572221;
        bh=Zmvcu8/nZOzuXMOWbFAj2qJfy89TLpGL3Fx6l2pLhJQ=;
        h=X-UI-Sender-Class:Subject:From:To:Cc:References:Date:In-Reply-To;
        b=OGyqacmGrxkdkRzfMA5O1KUvAjj9LKYlrmc5aZTeRshzBBSawGqBqgM3gq9j4+/3o
         NJx3LsxazBOpVcbogUFUhHYRVcy+5deVNvUERS31vtsXvVS3nzZRQ28tj9MHw43fi6
         RTMTdQ2NGFC4Kqx9ITAeFTj/3dS9d3SDf2l0Poxo=
X-UI-Sender-Class: c548c8c5-30a9-4db5-a2e7-cb6cb037b8f9
Received: from [192.168.1.2] ([93.133.191.8]) by smtp.web.de (mrweb004
 [213.165.67.108]) with ESMTPSA (Nemesis) id 0M3PN2-1hvxXB0Fpg-00r0Gn; Fri, 27
 Sep 2019 10:17:01 +0200
Subject: [PATCH v2 1/2] net: phy: mscc-miim: Use
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
 <506889a6-4148-89f9-302e-4be069595bb4@web.de> <20190920190908.GH3530@lunn.ch>
 <121e75c5-4d45-9df2-a471-6997a1fb3218@web.de>
 <20190926161825.GB6825@piout.net>
 <0a1f4dbf-4cc6-8530-a38e-31c3369e6db6@web.de>
 <20190926193239.GC6825@piout.net>
 <8fbfa9ad-182a-e2ce-e91f-7350523e33c7@web.de>
Autocrypt: addr=Markus.Elfring@web.de; prefer-encrypt=mutual; keydata=
 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 FEE=
Message-ID: <90c7a71f-d39a-2615-eedb-cc2d1150f3b3@web.de>
Date:   Fri, 27 Sep 2019 10:16:56 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.1
MIME-Version: 1.0
In-Reply-To: <8fbfa9ad-182a-e2ce-e91f-7350523e33c7@web.de>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:AaX0sq9+HUsSDnV09bMPNY6kK7JV3C1Pw/3vcyFGiClRO7HQCY1
 Ull0v5PTUlkBXkK7CB2tRwtx6Ih61No22LmP4AkF7CgeYOwEl5HUbBbYfRM86dXKODsz8ZT
 VWyY0zHRzOsudJ+JkK8f/cgC24UAXFBEmTapE4x9cRbfacLI6wGgnGS4cOcQ+jfhe0fWhZH
 35K0m7GjXtjudkLj5rhJw==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:4viL5OhCNTs=:lP/MxgEccLUgGs97ZGL2+K
 XPCn6n0nmyGkIFG1cWdLfrV9Sginaj2JaAqH6xx/4dhbBqTidV3zUxWM5kaBy+jNPJcuehdOp
 mOJTWjqeghBO4JA9RGT0sULkWfUcTXnOPEYUl+Hz1ZWofNif6MNbmUb1xp2fIdd6bb70RDq2X
 G/zQ5mB8J/bsVihBGkUgbRSTeikNQq4Kq4Ai3a1NSKlulX8yKJI5oFqcPo+ycxo/FEGoUc2eJ
 /uX9Rf71oCWX1fbbl4HuejgdB7b9koc47fnx/040oD7Pr5U5cxL6Ptqwk+3PskbuYqa2XWeVj
 iNWoh2shC55QO9mNrf+WJbnilY6TTJc66dA+GA/qwchlHkU9jYmuSSIoJ4Z1IdS9Hoc1IdCMR
 DxDL4GHA7MP05knAcoYQDRweHfftaLgh8k+8yXCge5XsGesi5jWOr///0F0oK93Gf2AJEkFwk
 tsZnX+bEuTfqoytzq4WoGlnT9FIhQywFNSX7h8mEE4Ldc69hASTKB0tc2+mmKMEf/AZ14+k9J
 0Ypi6993AWPzFOyVPyJKuk0Tk09PXd/S/iFCv4m5bthKpVQ+CbKWaQ+hWzjhkSRxQ776hfmzN
 WWJMGCL+NUBjd+eYPdJM8Gxa7M25l6psyfr6MfduUDL4Cw2q/rAS8EkIvKZBhP/YWvZ4rw/Js
 JygH+AvSGgNHNv+SRoG+5cAgKDXStn6JET/HEwuJpmuwvzZLQJsKF38imwm6GTmYFjSHygmi+
 L9WpavEKkm8OvkpXGH1WYWzeijXagIioYNT80QnY6kUXN/IFeoTiIi3ocuutbY/PpbkfIU7zq
 DZPhO5MusrVc6FjoK6svPpsrqMCWFMLzgjGAqg7wGoyzFY1m/Lt+SAa/7HGUMwYFLfLiPdkEO
 sdG1lEj0Yqd7IZsqbeKh3EWCxW6vJotcv1ZK7ui3pSeW3IVY3AJYy4EsDXUjbT3bNXkPir6/h
 T17PICuBZo2Axoh+FVphwds6HKXVBeO6yg4d+7ztzdL2oCVahgqwJ7cryGWrgVrncbZ/ZnWW4
 x7KQ2rYNnj3J8IFmJwIw7KKreCG5c/siv2ymn7nWDn8fe8p40Gkm/fnrKkXQZsotjfZ9kjpuK
 NfhzXvWxmUO35eigGWza6p+kkxo+a4BTLfwtcItyDOD+bPdDifXESStEUPf6uhnC8N5hynPKL
 rotYAF2iUhtTdgMIHNInDQz56nM1uesgOv07+mhYTWcsUOqP/UzybQy3pIOEt5p+nMj/VCzEV
 HXvAydR0sJwFjodIuVFnoZ3lxrgW1Y9WJKjXM8vxzo5de+H+HiBInT83cpbY=
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Markus Elfring <elfring@users.sourceforge.net>
Date: Fri, 27 Sep 2019 09:24:03 +0200

Simplify this function implementation a bit by using
a known wrapper function.

This issue was detected by using the Coccinelle software.

Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
=2D--

v2:
Alexandre Belloni pointed the need for adjustments out.
https://lore.kernel.org/r/20190926193239.GC6825@piout.net/

* The mapping of internal phy registers should be treated as optional.
* An other prefix would be preferred in the commit subject.


 drivers/net/phy/mdio-mscc-miim.c | 6 +-----
 1 file changed, 1 insertion(+), 5 deletions(-)

diff --git a/drivers/net/phy/mdio-mscc-miim.c b/drivers/net/phy/mdio-mscc-=
miim.c
index badbc99bedd3..aabb13982251 100644
=2D-- a/drivers/net/phy/mdio-mscc-miim.c
+++ b/drivers/net/phy/mdio-mscc-miim.c
@@ -120,10 +120,6 @@ static int mscc_miim_probe(struct platform_device *pd=
ev)
 	struct mscc_miim_dev *dev;
 	int ret;

-	res =3D platform_get_resource(pdev, IORESOURCE_MEM, 0);
-	if (!res)
-		return -ENODEV;
-
 	bus =3D devm_mdiobus_alloc_size(&pdev->dev, sizeof(*dev));
 	if (!bus)
 		return -ENOMEM;
@@ -136,7 +132,7 @@ static int mscc_miim_probe(struct platform_device *pde=
v)
 	bus->parent =3D &pdev->dev;

 	dev =3D bus->priv;
-	dev->regs =3D devm_ioremap_resource(&pdev->dev, res);
+	dev->regs =3D devm_platform_ioremap_resource(pdev, 0);
 	if (IS_ERR(dev->regs)) {
 		dev_err(&pdev->dev, "Unable to map MIIM registers\n");
 		return PTR_ERR(dev->regs);
=2D-
2.23.0


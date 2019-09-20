Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3C25DB8D8F
	for <lists+netdev@lfdr.de>; Fri, 20 Sep 2019 11:23:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2408453AbfITJXf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Sep 2019 05:23:35 -0400
Received: from mout.web.de ([212.227.15.3]:47507 "EHLO mout.web.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2405677AbfITJXf (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 20 Sep 2019 05:23:35 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=web.de;
        s=dbaedf251592; t=1568971395;
        bh=n4wmlEpIxeMGtEm71cttecdZaNY+CTMNrXv01ql06WI=;
        h=X-UI-Sender-Class:Subject:To:Cc:References:From:Date:In-Reply-To;
        b=SUEHIhMMI6o/3mClDMFOY1RjdGGlEOrME2mYFKlqu70BvHhnTMv3CFPHE4JI1hOVC
         p/9s+2tpTDoGOCRWbeZ/eeULBEyq1dNHDc7r344xSdnssI4kros4LfXqBH3vxQZ1zT
         Enyq7TFmMO0bZ/e9PV/uOI6i1FAVmzN6Y6MvzxOg=
X-UI-Sender-Class: c548c8c5-30a9-4db5-a2e7-cb6cb037b8f9
Received: from [192.168.1.2] ([2.244.117.22]) by smtp.web.de (mrweb001
 [213.165.67.108]) with ESMTPSA (Nemesis) id 0MIvJx-1iDi6l4A01-002TX4; Fri, 20
 Sep 2019 11:23:15 +0200
Subject: [PATCH v2] ethernet: gemini: Use devm_platform_ioremap_resource() in
 gemini_ethernet_probe()
To:     netdev@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        "David S. Miller" <davem@davemloft.net>,
        Hans Ulli Kroll <ulli.kroll@googlemail.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Radhey Shyam Pandey <radheys@xilinx.com>
Cc:     LKML <linux-kernel@vger.kernel.org>,
        kernel-janitors@vger.kernel.org
References: <af65355e-c2f8-9142-4d0b-6903f23a98b2@web.de>
 <CH2PR02MB700047AFFFE08FE5FD563541C78E0@CH2PR02MB7000.namprd02.prod.outlook.com>
From:   Markus Elfring <Markus.Elfring@web.de>
Autocrypt: addr=Markus.Elfring@web.de; prefer-encrypt=mutual; keydata=
 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 FEE=
Message-ID: <bd860b05-f493-20e6-083d-66ef3cb61f60@web.de>
Date:   Fri, 20 Sep 2019 11:23:05 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.0
MIME-Version: 1.0
In-Reply-To: <CH2PR02MB700047AFFFE08FE5FD563541C78E0@CH2PR02MB7000.namprd02.prod.outlook.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:E/YSl/pVxZOVaMlSuToRZB9j18SuzSKs7/OpR/QbkpV7cgHn4l+
 mrIzs0OaehmnFdqS2+HNJfIBxBemBdK5oIno3xlKn85UpQZwyMinEE1BFEu7wQB5NZKcxzm
 JHgFoFqza7gBrfViN+V6ZguTim5C1Wl7GMTrzoZWUlBxRO5kpk821PMHvOb3pZw6KLjo89G
 W2s3sSwIfCQTgNX/PWTrw==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:tUzNvkgXqCc=:QLSgv6PXtMq5ZNrz3bj3G8
 IpntKqLAdz3e05t7AS/kLr4tTQVvz5rV3SohxTmLvDNgweQ+2Gx6rZbePcgl8gxpPoEtrRiSo
 oelKMsCTZwC8FmECByfMtAvXkfa7BiSZMc8epRsYlQ/UB2iv7CzHACbjw1SFc/k7XdITSF0bM
 t53mbkYcmMcw3ACEcdzV5bmCf0cWVEDpn8+cHMi7zj8eSnDd9iqpIC9a4PAd+Rxpo/6Wkt3L+
 qL/WoUoetXzJYgW94wv6PzN1io+liSHHcH1tSmm4NzscUMF/Z9xU6lwjYzWw+w/7eeUjaqmSp
 AREbPuDLgn3UOx3EkSAT3y55uXoTx8MWga7TBV3yNw5obGm3YGc3YZDN4pFBaQaz3qi/hjzBv
 xq2QKW5sU57gpIVNE2Yr8Czl+ZfxUTfHfPPyfKfvofTho+XCgoHSF1F0qpkVyWqWI4wlFnzLB
 lCv9O6uTP/KYDhu4Sb3XZeS+SZGP3z0Fa8IUaAluD6IsVs3J4Pm4d1wuX5G5G0uw9cARHygLl
 cFEyuz74fpM5jQRkoElFVv4eZycxq5yv4/dei5mrk8FCMctDivUITFr0Yj/PQiMnI5MiaYhZm
 klAneL7wkiCZnIEpGADcd+CophYdVCVsC7B7M/vUvVXPDvGmlmOWnYNaoHP9ukktqObcPbXEK
 WMe1/Eul7kUlBFBwjZRhfFXQ94NWxBP1ycG8Dt8a5TADnTva7c4sbZl8YVUQNZQXtpr/HZpRE
 NOYZlshOevzaDJQhelS06VExqj8S+9AJiwJ7C/4uTasLugtrwTe099gB3fT/qB/AofX3vEAXU
 sbv6xB/89qh67ZSx72TlhN2t8Wz/TClMJLd9wr8ydq0+u4VzIXqvJyUK8smE47Rz/iQgok7UF
 ZRzzrZ8ThyK9ip8xjlGk6Y3cQuHO3JilzGo9EsIUvwr8FiPQY2BXzde0YyLcMg2u8HE/HKbxo
 u2lMKpNW8Bgmm0z5TNiQ0kUsY4zGBv+X2hnyp90MrIV9yoHqOr2vCmfe2qiG4k4/vlhewCZoy
 7WI/Bw881mN2tp2WxPiAjWIozozPrVclDgap5jGTq1GS1nriQ708f0umsf389/Nbn0n2atLDL
 1vIA2dAY9TfAMQY1ZeuM52XJ5UYHhxte+jTmIAE9iClMwPQ8n96F9CMc1DSENPAaHlP6kVFVe
 k1ot+TJoWrPjcTLXbbS7zTYxso2r2WqdbGftB8jGq8wjGs5mxinJRjbIEGkedm8+QGbgb/1N5
 9VoAxgLD74rykHXV9lW/MdOJzxSZeO9rPGUbcORGkfahGsDq2HBU0DARnU3I=
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Markus Elfring <elfring@users.sourceforge.net>
Date: Fri, 20 Sep 2019 10:52:56 +0200

Simplify this function implementation by using the wrapper function
=E2=80=9Cdevm_platform_ioremap_resource=E2=80=9D instead of calling the fu=
nctions
=E2=80=9Cplatform_get_resource=E2=80=9D and =E2=80=9Cdevm_ioremap_resource=
=E2=80=9D directly.

* Thus reduce also a bit of exception handling code here.
* Delete the local variable =E2=80=9Cres=E2=80=9D.

This issue was detected by using the Coccinelle software.

Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
=2D--

v2:
Further changes were requested by Radhey Shyam Pandey.

https://lore.kernel.org/r/CH2PR02MB700047AFFFE08FE5FD563541C78E0@CH2PR02MB=
7000.namprd02.prod.outlook.com/



* Updates for three modules were split into
 a separate patch for each driver.
* The commit description was adjusted.



 drivers/net/ethernet/cortina/gemini.c | 6 +-----
 1 file changed, 1 insertion(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/cortina/gemini.c b/drivers/net/ethernet/=
cortina/gemini.c
index e736ce2c58ca..f009415ee4d8 100644
=2D-- a/drivers/net/ethernet/cortina/gemini.c
+++ b/drivers/net/ethernet/cortina/gemini.c
@@ -2549,17 +2549,13 @@ static int gemini_ethernet_probe(struct platform_d=
evice *pdev)
 	struct device *dev =3D &pdev->dev;
 	struct gemini_ethernet *geth;
 	unsigned int retry =3D 5;
-	struct resource *res;
 	u32 val;

 	/* Global registers */
 	geth =3D devm_kzalloc(dev, sizeof(*geth), GFP_KERNEL);
 	if (!geth)
 		return -ENOMEM;
-	res =3D platform_get_resource(pdev, IORESOURCE_MEM, 0);
-	if (!res)
-		return -ENODEV;
-	geth->base =3D devm_ioremap_resource(dev, res);
+	geth->base =3D devm_platform_ioremap_resource(pdev, 0);
 	if (IS_ERR(geth->base))
 		return PTR_ERR(geth->base);
 	geth->dev =3D dev;
=2D-
2.23.0


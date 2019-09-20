Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 50BF9B920A
	for <lists+netdev@lfdr.de>; Fri, 20 Sep 2019 16:29:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390099AbfITO2P (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Sep 2019 10:28:15 -0400
Received: from mout.web.de ([212.227.15.3]:53205 "EHLO mout.web.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389778AbfITO2J (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 20 Sep 2019 10:28:09 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=web.de;
        s=dbaedf251592; t=1568989682;
        bh=kdzZIwCly4T9zp29vrSfE2M+d5f7xcC9TUVJt32lSys=;
        h=X-UI-Sender-Class:Subject:From:To:Cc:References:Date:In-Reply-To;
        b=Rc4bDu/Jv0umTJbDyJZZqeHkEZK7Q70ob2pjYLpMtB/dHeN4aJJUaqTlEav9mcDNM
         5e+BkGY5tivBSMWV/pWt25KJpAZwh8Ox8Q5eoUQL7CYGLT6W74dgpdjTUSp2yYk8Uh
         g9S6BKWrzcezmKVyn3PBNEeW4aJTQqFwu1AwtbqY=
X-UI-Sender-Class: c548c8c5-30a9-4db5-a2e7-cb6cb037b8f9
Received: from [192.168.1.2] ([2.244.117.22]) by smtp.web.de (mrweb004
 [213.165.67.108]) with ESMTPSA (Nemesis) id 0MVXnr-1ihyDl0pmJ-00Yx3q; Fri, 20
 Sep 2019 16:28:02 +0200
Subject: [PATCH 1/2] net: dsa: vsc73xx: Use devm_platform_ioremap_resource()
 in vsc73xx_platform_probe()
From:   Markus Elfring <Markus.Elfring@web.de>
To:     netdev@vger.kernel.org, Andrew Lunn <andrew@lunn.ch>,
        "David S. Miller" <davem@davemloft.net>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Pawel Dembicki <paweldembicki@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>
Cc:     LKML <linux-kernel@vger.kernel.org>,
        kernel-janitors@vger.kernel.org
References: <98fee5f4-1e45-a0c6-2a38-9201b201c6eb@web.de>
Autocrypt: addr=Markus.Elfring@web.de; prefer-encrypt=mutual; keydata=
 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 FEE=
Message-ID: <dbc78014-6ed4-5080-8208-0a5930a3bf6e@web.de>
Date:   Fri, 20 Sep 2019 16:28:00 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.0
MIME-Version: 1.0
In-Reply-To: <98fee5f4-1e45-a0c6-2a38-9201b201c6eb@web.de>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:eaHOMc8N0+305YH/nAoGgTtwujnEWWyNrxbqXIy8TqENwpAxYyC
 Lyhg7CQIZHa3ZGvjPK7m0yHuyqBBXSQ59+D6aDz8i8oW47ql5JK7Swwni4yRS+Zo9EPrtEH
 VCkvu9z6JG8/4r3pMxGtV82VjGiHD0TUyg6auYpda90eH1WUV0HwY1FQEb/G+XL4w2FwCOJ
 4n07ih3keq6ReQqkeWyAA==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:281xM9Molak=:Zf81jyMzl8OKZLMlvl3IPz
 hMAEFaIklXt6n3ph8dndb01wP+lGSK20kV7UD5PEvMKlmi6I1dJ6sBsZHgx7EtrpvnmhRvKmc
 0xla+IrzPEau2ItZXGmR9/q0S9JNJiGxLAUTawgHgTmRs1g5pEU6lJ2a/4ZcOD6dGe6dHM8uw
 ff8uGPs6kMBG9/EJaWNuZ3TNS9EIkfXWPHLy7nIZYKgkTin7GQUdMg1bw5ktgwe783djL0kte
 HoNtuZumO6usEn4gilhHUCz9eZk4B0Oyz0p4U4+Bh9SsJgAl+M7+Wr/BLd/wnOv2xyNkdke3D
 WjCgECLoh2a4KOKAHXsnbRr6HlABNZXLJwJTtZW4x/SdKYicQCmQs7Qe7ls+d4JqcTzM+3S3e
 qvq/EOdxbwG5Nhl/+y1iutgpG6CKSks6nF9syVsqzAbKou1tY+SsA9vPjtUxx0BZF+akXsErv
 QafW+uULjDwABqdpuw7RZlWxoV2Wrsze2xjWKYB4POt3QOiFT3KFuqnNuFfTaLQgQAZBvZvnK
 vjiBnknBGGajnAf05iKe2BjcpUnnemekWs7/dtDSKUDnvdAwWbZUpCJgLxJcXpSIjkThfckn3
 EA+GXxpQYSJ82nxMZOOD8di5k4ASTy41w8lPsWxrvXRisbYVaZ3s8T8BqPzMPC4GovjbWZKpq
 m9ajMKo1SVaxbU01iB9NNtP8tXu90sT7EwzC1Oz5ElDfzqOkgW+uO4btC80f7OETwcphwgZm9
 911O1NumfzRYAUk9eL7eB/k15R/4DqGNp3P9uSQVKTvbMQpGlXxZSVV9tG1CvQ1jIldPvtMAr
 Rag7kEzxDLJN/yUuLp6vOy6m9R+mUowjZXaSAT8srVrmlk7szVEjFtqZwXa9EqacUZtJibjUf
 Hf7BN41chxN20U3dpuGDIvw8hASJQqI8llnkBDBarDoD+XLndzkNaHtQi3VUTzue08ALgtWLb
 trI2NjJwLgqombKpJDeshNNg5+Rh3QSiXvEffr74fICNBxDkSUE/bQREMf61GFt/ADUIFJ88F
 /TqqW3uwsxZUo6xkV9OcB1Un1Qq+UpMMgNny3kkBlmfWcKVQmGiXwrr6iIhTvuQFJw9ZHN3FS
 2JMGUkP/kPYFxRmZDU9Tyyp1M2VHATukj/d0yRd+UEZZV398SmUJZ4H/yiD7zYqUebFBh8tN6
 mhHLeAtBrvV/ZMOjFweHc040HmzDiTMWwF2zpta6whzStkNap/+60+A6APdSIHw445xkWIMqk
 eWwcwT3dK47Qu97hPhtFB9DbJCgwW6INjL5tqUUye76fvuCWEMsjydrdlcTI=
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Markus Elfring <elfring@users.sourceforge.net>
Date: Fri, 20 Sep 2019 15:23:39 +0200

Simplify this function implementation by using a known wrapper function.

This issue was detected by using the Coccinelle software.

Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
=2D--
 drivers/net/dsa/vitesse-vsc73xx-platform.c | 12 +-----------
 1 file changed, 1 insertion(+), 11 deletions(-)

diff --git a/drivers/net/dsa/vitesse-vsc73xx-platform.c b/drivers/net/dsa/=
vitesse-vsc73xx-platform.c
index 0541785f9fee..a3bbf9bd1bf1 100644
=2D-- a/drivers/net/dsa/vitesse-vsc73xx-platform.c
+++ b/drivers/net/dsa/vitesse-vsc73xx-platform.c
@@ -89,7 +89,6 @@ static int vsc73xx_platform_probe(struct platform_device=
 *pdev)
 {
 	struct device *dev =3D &pdev->dev;
 	struct vsc73xx_platform *vsc_platform;
-	struct resource *res =3D NULL;
 	int ret;

 	vsc_platform =3D devm_kzalloc(dev, sizeof(*vsc_platform), GFP_KERNEL);
@@ -101,16 +100,7 @@ static int vsc73xx_platform_probe(struct platform_dev=
ice *pdev)
 	vsc_platform->vsc.dev =3D dev;
 	vsc_platform->vsc.priv =3D vsc_platform;
 	vsc_platform->vsc.ops =3D &vsc73xx_platform_ops;
-
-	/* obtain I/O memory space */
-	res =3D platform_get_resource(pdev, IORESOURCE_MEM, 0);
-	if (!res) {
-		dev_err(&pdev->dev, "cannot obtain I/O memory space\n");
-		ret =3D -ENXIO;
-		return ret;
-	}
-
-	vsc_platform->base_addr =3D devm_ioremap_resource(&pdev->dev, res);
+	vsc_platform->base_addr =3D devm_platform_ioremap_resource(pdev, 0);
 	if (IS_ERR(vsc_platform->base_addr)) {
 		dev_err(&pdev->dev, "cannot request I/O memory space\n");
 		ret =3D -ENXIO;
=2D-
2.23.0


Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B73A3B8F02
	for <lists+netdev@lfdr.de>; Fri, 20 Sep 2019 13:31:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2438221AbfITLa5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Sep 2019 07:30:57 -0400
Received: from mout.web.de ([212.227.15.4]:51299 "EHLO mout.web.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2438181AbfITLa5 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 20 Sep 2019 07:30:57 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=web.de;
        s=dbaedf251592; t=1568979037;
        bh=6u/lrL0YjFWeNKufdCoJnqJ/iIRy/jFjcRoEoLmbNRg=;
        h=X-UI-Sender-Class:Subject:To:Cc:References:From:Date:In-Reply-To;
        b=bsXxou1FKiQZZOXDYnHT2F3sFl4uBqiUv5k4bjUI2VFQQEsaisZymicPD2v1g21EB
         tbn79Nlql7TKrJeVUeG4yHm7dMvTmh4dKQPxRNsszBKeBESnOhmJO2g01njMhaLDmN
         MIRiUfrTgWyzWXcI+jVw1lPrbMJRNCTgqaQ8YvIw=
X-UI-Sender-Class: c548c8c5-30a9-4db5-a2e7-cb6cb037b8f9
Received: from [192.168.1.2] ([2.244.117.22]) by smtp.web.de (mrweb001
 [213.165.67.108]) with ESMTPSA (Nemesis) id 0LnBTZ-1hhh7g28R3-00hKw8; Fri, 20
 Sep 2019 13:30:37 +0200
Subject: [PATCH v2] ethernet: axienet: Use devm_platform_ioremap_resource() in
 axienet_probe()
To:     netdev@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        "David S. Miller" <davem@davemloft.net>,
        Michal Simek <michals@xilinx.com>,
        Radhey Shyam Pandey <radheys@xilinx.com>
Cc:     LKML <linux-kernel@vger.kernel.org>,
        kernel-janitors@vger.kernel.org
References: <af65355e-c2f8-9142-4d0b-6903f23a98b2@web.de>
 <CH2PR02MB700047AFFFE08FE5FD563541C78E0@CH2PR02MB7000.namprd02.prod.outlook.com>
From:   Markus Elfring <Markus.Elfring@web.de>
Autocrypt: addr=Markus.Elfring@web.de; prefer-encrypt=mutual; keydata=
 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 FEE=
Message-ID: <604a6376-0298-ebcd-ee84-435945370374@web.de>
Date:   Fri, 20 Sep 2019 13:30:35 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.0
MIME-Version: 1.0
In-Reply-To: <CH2PR02MB700047AFFFE08FE5FD563541C78E0@CH2PR02MB7000.namprd02.prod.outlook.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:6SRgYF57pdwisiSOfQg1UlbC32Jh8S0JVlx+KF5kzO9pVIQbQ2K
 iRjI+uMuwp2Dh6DhZKSc9QSQhmgk96hR1spxlpNLq+TUzfYzhB4EjgMoHGWTKwAO4thnf0p
 S4WbEy8DT62mC5yIO7GvaDBYoSDLgX2svhNSxlA3dvG5V6r0oElMxaCowKGsZZZwIowAmaI
 8kwv2IqrC5n/HAqzYkGUw==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:qeu4r5QVVrQ=:yP+b0esX9R5pV6FoUHsJbD
 5b4yGkvMRHiG45WlgYxnYfewaZT5f9DkNHWpTJ62I5Yb/X55s+NsebxepbvNVAuWD0pf56obg
 iFIIJNWDoNtaElbJvySPOp2kL5UkytO0jKkkxEPZwyzQY5+s2wG98WDvl5gIL5vj7j5hIE80m
 ta7HosB+bLPJ8o0aoX9z2UtU0Tjw56jLFWhxpvmlE90usD6DNxrQrPJdvSt5oEQiPGs5hvBtA
 evxtiFwv8kV0YRBJr35RdzqqVfhQyzMPYGgoVWPAa6K4qurQhTfYJXGS8h/baUz24Qbx4uf3C
 GIpuvz+RscL06kHJHcVo7laCFPOr5e3MwYz5jZtR1JMWdBpBUtugEIQJrkGnLfZiIsG+10IBl
 HAmxT149FTFmZ0JWIwj+TgyK7Xo8bcnhMT0r+VFp6UD1zMfvntHdmK/Lb97tcad5Opos5U3OZ
 bRHBO9yaCr0RAq89eVFMaYIltua95IXBL3hXhYHONUOX6ckfTqEGgXtq52RE6KTolskMQoT7p
 S3FMajIeg3Ys7BdZde5InniIaNPtMZ6UMJiAtfUMEzPr2o5HRCv0XiMxAe4eHBMJ5IKXnqjO2
 TFn101EXT0PaJsJ4y8ty0T6PRrxpVFNkphq3OaH2hpU5ljweCvANAUPvzpflmvrsWaViInBz4
 3Y1jXDLrQevanKpOrJXJMkqnlLcIx1kbPFii+pk8VOKQMle9HlTJvCs4gv6wiB+76ZjX8jmr6
 2NgFXmefu/aDRvKjqjZNYlltDw+jPYpTZhD84Ezf9ata7kREcQTyBYH+eG25v25l0CuQBfYKJ
 Rh7EFNFm5hGXfiTLXcjiGlOQWeWDHVZ0PPc631jp68UOcm1eRDEp1ksAKQclz6TzLTTkNXgob
 9rTKCNu4JuCJz1QrX/eln19HttnDNv6sUDYliuUif9VKN//nvvM1EOc6DvhhvsWA5ClqIdPa5
 A70ZMr1cRAUTcSGSF33Htzrr3tk6c84ERnV82t8ESgv32jE5YjUKwmpG1CgeW2Yv8xU7r0PbG
 akZhmFxsjhIeMxP8Hj/R+2HB2L2vx6K5FOx1C8AXCNzbm6Okjx3EHKyU4ml0/Ie33o9a9oep+
 hSWjZmBfQPhqOPPamOX689V0COjHw3fTT/s748wW+NLX6PzQ/DYjW/2cuC27f3fucZHQ0IMF5
 9tLxeg0u9myVvyKX/iiB+/DJBETdiPrb0sx6EkgI98fSgQloKCgJPgBHTWIjNtW5vCZBYZ5et
 +jj/4zviV3UETxY/XkZ4ndw7x15L69SXps8UeS90nn7FDhgJHzv19NVyW4P0=
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Markus Elfring <elfring@users.sourceforge.net>
Date: Fri, 20 Sep 2019 13:17:01 +0200

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

* Updates for three modules were split into a separate patch for each driv=
er.
* The commit description was adjusted.


 drivers/net/ethernet/xilinx/xilinx_axienet_main.c | 9 +--------
 1 file changed, 1 insertion(+), 8 deletions(-)

diff --git a/drivers/net/ethernet/xilinx/xilinx_axienet_main.c b/drivers/n=
et/ethernet/xilinx/xilinx_axienet_main.c
index 4fc627fb4d11..92783aaaa0a2 100644
=2D-- a/drivers/net/ethernet/xilinx/xilinx_axienet_main.c
+++ b/drivers/net/ethernet/xilinx/xilinx_axienet_main.c
@@ -1787,14 +1787,7 @@ static int axienet_probe(struct platform_device *pd=
ev)
 		of_node_put(np);
 		lp->eth_irq =3D platform_get_irq(pdev, 0);
 	} else {
-		/* Check for these resources directly on the Ethernet node. */
-		struct resource *res =3D platform_get_resource(pdev,
-							     IORESOURCE_MEM, 1);
-		if (!res) {
-			dev_err(&pdev->dev, "unable to get DMA memory resource\n");
-			goto free_netdev;
-		}
-		lp->dma_regs =3D devm_ioremap_resource(&pdev->dev, res);
+		lp->dma_regs =3D devm_platform_ioremap_resource(pdev, 1);
 		lp->rx_irq =3D platform_get_irq(pdev, 1);
 		lp->tx_irq =3D platform_get_irq(pdev, 0);
 		lp->eth_irq =3D platform_get_irq(pdev, 2);
=2D-
2.23.0


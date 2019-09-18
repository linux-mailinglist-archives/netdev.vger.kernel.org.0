Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D3C0DB6467
	for <lists+netdev@lfdr.de>; Wed, 18 Sep 2019 15:31:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730323AbfIRNa7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Sep 2019 09:30:59 -0400
Received: from mout.web.de ([212.227.15.4]:41541 "EHLO mout.web.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730149AbfIRNa7 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 18 Sep 2019 09:30:59 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=web.de;
        s=dbaedf251592; t=1568813438;
        bh=MKpOuZMYrkG7lb7f49A49QuW8PC37B5GHy9Sk1Q2aZ8=;
        h=X-UI-Sender-Class:To:From:Subject:Cc:Date;
        b=cuwKBadiuCV9GuTsa3ebhURyf/BV3MkFKmrpd3Yk/0SaQbTapk7vJR2QyqODYDCNb
         1p5W/bPgJdJPTk38avudQ6wa177OHIx/Z8YvPhAm4RjMcruzhSq6yG+yIqz4wkiHLi
         TFXw2ZsTd8YUq7wEz4XbWV+HStBulSAxvP6/eh4I=
X-UI-Sender-Class: c548c8c5-30a9-4db5-a2e7-cb6cb037b8f9
Received: from [192.168.1.2] ([2.244.2.101]) by smtp.web.de (mrweb002
 [213.165.67.108]) with ESMTPSA (Nemesis) id 0Mare6-1iTuNA1Lb8-00KQN2; Wed, 18
 Sep 2019 15:30:38 +0200
To:     netdev@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        "David S. Miller" <davem@davemloft.net>,
        Hans Ulli Kroll <ulli.kroll@googlemail.com>,
        Hauke Mehrtens <hauke@hauke-m.de>,
        Linus Walleij <linus.walleij@linaro.org>,
        Michal Simek <michal.simek@xilinx.com>,
        Radhey Shyam Pandey <radhey.shyam.pandey@xilinx.com>
From:   Markus Elfring <Markus.Elfring@web.de>
Subject: [PATCH] ethernet: Use devm_platform_ioremap_resource() in three
 functions
Autocrypt: addr=Markus.Elfring@web.de; prefer-encrypt=mutual; keydata=
 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 FEE=
Cc:     LKML <linux-kernel@vger.kernel.org>,
        kernel-janitors@vger.kernel.org,
        Bartosz Golaszewski <bgolaszewski@baylibre.com>,
        Himanshu Jha <himanshujha199640@gmail.com>
Message-ID: <af65355e-c2f8-9142-4d0b-6903f23a98b2@web.de>
Date:   Wed, 18 Sep 2019 15:30:35 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.0
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:22C8D5pAJ88BDsubwFxmBuIaPkVQVly0cFnhkU1Wh6CR8SWDzkW
 iNLlWrhHgf5k6ALb2CBe9F26dyC/ZKFNeOo+WTx+ySAb5+VAlugFnrNYXQBMB1CFV9Bb3M8
 g8Ri2a/DZvua9KEfQ+D8prLcN6jpFDkZ2CQd7h1RsQtrwXW+iDblb1NP7I/bLVsSwFA72wV
 z1R/EXu02pS9bmH1mliUw==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:zuAoDArFchE=:Stm8Se+lOKkjLvOdWBGNXO
 98JrYSnf+jAyr7BK2+VjkE+tFk+hz+WEB6FwKdKHMcQ9AzRH+2+W2om9ALEyhY1OqJk2Mn3xw
 t8M/jXvi17QEdY4aTAilBM7TxdvfIIRlL4r3V51+RwzDko4+FyeA8ibVGMFJMBYRbLquh8o65
 32DZ7aflIaO8dgdH5V3chWTwvmYcjwFbmJwAemiK6RtI/HSHV3OVL1zjagc0M9+fk9chweOfV
 UBsqFoTSgKxZh0AwQVW22Psp0fI2vCYlvFzDZ7XfJ9NTRGRNzC5vu+WbYF5IgRL3PW+jylKiO
 tcnnLUs5lnNSO+HvBwlYQIcvQM+v1uEdLhIDWYQeNT8tdBeaSisbiv7pzD/i155P1VoBa69/M
 IajZh2/B3ThUKNfijnc2inXsRmxekgUuRu1CusgWxOXt/PNPpbza3FJx20pfCKsm5rjuRSTcf
 kIyYEFldz5zgVjFH0UXWUPzyzukfR4KPWYXDvdz/6Y2V69atNd+RKEJ0T1mYErOE5ELr0oBkf
 zB2diLRTXK3rv/F2lIpfs8wP9ZOqdCShloiJuIUJCJuRSuqBRbgv+tzV0kVzBNVGQwBdEhtlr
 NUxOlutQ4YbKvQQk3QdafPXgd+a+Wi+y/cieLy6ICrBJsKBMemeQbSVi1KzJt2VqS4wloXMGU
 uiqmCxtRMXPBkNECrdnW7t7fzjDUF/3E5SrKmEvlpJHswxbbI/TQ7BuLLe7Nr7G9huTm+tNPn
 K3gnYQ7iwiUkwNvQf23lREtv0bFZzm1OOynFeONTryErdaifJEAvxCpmJIrQtZAcXWkVGVNQt
 /OngClV1b6ito9+mwvgheAXy0A4gD4LyFRZSNV5qQ/cdBxwj30Zv7PsIa13ME14yUxpTjuPVY
 o95svFSZkajO1Vg80bMJVwu8CfpcNQSB5xWKhFCsGY6S8GeUsHzJsQ9ruxg2896i193TKjTXP
 JULRGoZiIbxKbrgoO2dHzTknMTprPT6FO4XnfzIPz7Y6I6WDtksT5KITvc0OGKscULniWU++w
 o/iI3W0Q/CXMLcG5t45YK/xxnzSihHxmDK5RqzxybkNOnaFpb/0312NexLTJ0WbocMw+PfqPs
 wBvBhYcHm8pUx8al6wBexoVOioux4i6AFb7zuATuHJNNZT9G8iqprvkwvKlHT5ys+UTZPcwn4
 OUS4Z6w1CND89x6g542ni3I6Vj8EapKlkZh5k1m2b/iWQGWLW1IOgd71sT+WYxKUpCOuIFNoI
 TYbHwGrWnIei9bGNA5xbDK2vOUc6txMcz4nM2Mynn4om3dusnFBaI4Te2/To=
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Markus Elfring <elfring@users.sourceforge.net>
Date: Wed, 18 Sep 2019 15:15:06 +0200

Simplify these function implementations by using a known wrapper function.

This issue was detected by using the Coccinelle software.

Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
=2D--
 drivers/net/ethernet/cortina/gemini.c             |  6 +-----
 drivers/net/ethernet/lantiq_xrx200.c              | 11 +----------
 drivers/net/ethernet/xilinx/xilinx_axienet_main.c |  9 +--------
 3 files changed, 3 insertions(+), 23 deletions(-)

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
diff --git a/drivers/net/ethernet/lantiq_xrx200.c b/drivers/net/ethernet/l=
antiq_xrx200.c
index 900affbdcc0e..0a7ea45b9e59 100644
=2D-- a/drivers/net/ethernet/lantiq_xrx200.c
+++ b/drivers/net/ethernet/lantiq_xrx200.c
@@ -424,7 +424,6 @@ static int xrx200_probe(struct platform_device *pdev)
 {
 	struct device *dev =3D &pdev->dev;
 	struct device_node *np =3D dev->of_node;
-	struct resource *res;
 	struct xrx200_priv *priv;
 	struct net_device *net_dev;
 	const u8 *mac;
@@ -443,15 +442,7 @@ static int xrx200_probe(struct platform_device *pdev)
 	SET_NETDEV_DEV(net_dev, dev);
 	net_dev->min_mtu =3D ETH_ZLEN;
 	net_dev->max_mtu =3D XRX200_DMA_DATA_LEN;
-
-	/* load the memory ranges */
-	res =3D platform_get_resource(pdev, IORESOURCE_MEM, 0);
-	if (!res) {
-		dev_err(dev, "failed to get resources\n");
-		return -ENOENT;
-	}
-
-	priv->pmac_reg =3D devm_ioremap_resource(dev, res);
+	priv->pmac_reg =3D devm_platform_ioremap_resource(pdev, 0);
 	if (IS_ERR(priv->pmac_reg)) {
 		dev_err(dev, "failed to request and remap io ranges\n");
 		return PTR_ERR(priv->pmac_reg);
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


Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7008FF807D
	for <lists+netdev@lfdr.de>; Mon, 11 Nov 2019 20:51:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727220AbfKKTvf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Nov 2019 14:51:35 -0500
Received: from mout.gmx.net ([212.227.15.19]:50495 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726912AbfKKTve (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 11 Nov 2019 14:51:34 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.net;
        s=badeba3b8450; t=1573501792;
        bh=YkAVCsJym+AYytMKLyvpOFynFysMj/mqsnSce6arYPw=;
        h=X-UI-Sender-Class:From:To:Cc:Subject:Date:In-Reply-To:References;
        b=IxdvP7z8uO6jLxvVmFHKmO4/4gdU1tJ6UnMDlji7vCRDkKtkyoXgbYYZcmBENIy9V
         UGLlTBNy6eYrUoBKn9+8dnse4D6ojxsSIAabbOlDC1x/9+jHE0FLS8pHlYmjyMenau
         VRm6qPaKyAUsKaZmvcLkx4MSx9dI9ixy8Pm5QTu8=
X-UI-Sender-Class: 01bb95c1-4bf8-414a-932a-4f6e2808ef9c
Received: from localhost.localdomain ([37.4.249.112]) by mail.gmx.com
 (mrgmx004 [212.227.17.190]) with ESMTPSA (Nemesis) id
 1MOiHl-1iGGvH0ZzD-00Q8oD; Mon, 11 Nov 2019 20:49:52 +0100
From:   Stefan Wahren <wahrenst@gmx.net>
To:     Matthias Brugger <matthias.bgg@kernel.org>,
        Matthias Brugger <mbrugger@suse.com>,
        "David S . Miller" <davem@davemloft.net>,
        Rob Herring <robh+dt@kernel.org>,
        Florian Fainelli <f.fainelli@gmail.com>
Cc:     Eric Anholt <eric@anholt.net>,
        Nicolas Saenz Julienne <nsaenzjulienne@suse.de>,
        Doug Berger <opendmb@gmail.com>, netdev@vger.kernel.org,
        bcm-kernel-feedback-list@broadcom.com,
        linux-arm-kernel@lists.infradead.org, devicetree@vger.kernel.org,
        Stefan Wahren <wahrenst@gmx.net>
Subject: [PATCH V5 net-next 4/7] net: bcmgenet: Add BCM2711 support
Date:   Mon, 11 Nov 2019 20:49:23 +0100
Message-Id: <1573501766-21154-5-git-send-email-wahrenst@gmx.net>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1573501766-21154-1-git-send-email-wahrenst@gmx.net>
References: <1573501766-21154-1-git-send-email-wahrenst@gmx.net>
X-Provags-ID: V03:K1:/0eJG8jHGbLvFZ50W01axrjmSeg0Zy0GbS/+/utYnSs2uAGw3Fc
 YrJCkLBDKa1nLxeOXskKItd7x0sZWrzKOSbWTT5BfK85tGqFK3sa2iWbUzGVMmX3nxZ3Cwa
 VtvR5KNsBMh/50yXR6ttiYSL3IBzeHvw4Q/DXCrWvQ3OTh5jdluDlcX022tltqSKT0Q53/W
 mW/qBNPgvtI1PdwN9qWIg==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:hTMeSMXs+RQ=:mRG/AEgArGsRrAJXfk0mwy
 cXxNqQWdqhoDKLNPii9BOxZgHiKJyBUwfZFz2lSFfvQyW0EvC1FrRfTyzskzK94plcLeBAKNb
 nwRHBxmd2aBuHD5AFjlHm/4PNDuBHqDbS+35ScRV0Kk0KYhMGmF+rn803C6ZfQuf3kIc4tHgA
 IPGKJlmrDQFesH5dSmtXdDa3jTYjdVSrNGwI5XRhUV3wi1rJYJib6xawacbYQ8Hw5RTXWd18a
 YprwVIAj2mJYE1zEq0ID4ckjP4RhQjjTOnETKGWVjFR5tz5RdpH6M1d5t+RyObUP5eE2ifDlh
 AHD7Zrh75On6WKHqXGLHVJ2iP0YfGp9DW4DDiLqFTfOuOFxeu5jMCCx4i9xESPGOu9vOGLall
 UPiZ+T1W3/aAeqy5PQlaF8etaw3D0XXPEg+nFoprCYJ3VXFniyFDebiyGe05Z8YuwZNI+HnZN
 sNrTqilh6xO+HEWYcMPfU1ODHKdE6EIAt9IZYMU7LN15A+kpC+LsZSCVl0cZP1PFzZeOSizYe
 ljVjj4y9A+Poi2kH4TAS9d7IIExoFFpr1kiFlfApdUFA21T9hhuN0kmZQboHm4F/mg3n6rA34
 iMhms4byLLt2CC9lZPWw43hyiX2V1WZbWVZYZNQBWH4TifbEN0OUwD1k3PSHKJezqLp6aPK28
 2h8sGfcxYzd9yb5gVdUU6IE8Bu44dkK2CxsCKIVBxCoo9CQu2yPGltDXIceMutU25wIEh95+1
 X5Vde07ZHmnMOq++DY8+afELzKHItwn35yyvLYFJ6VKy/xO1LN+X4p6RiGc9dpLv/koW9z8YQ
 zUDHmfr6TkWLAgJoqT4sEiztYEbqeG80gJiIOLusrm++v/srw2pCuBZ5w8UENO7c0+fP6c9IQ
 VjNw08DhH1KmCjsfJvNVk/kw+EANGiH7bIpFs2KmAh6ikIeF/gQd3pym1ElxWWm5oS5FBp/kV
 WQopc7OWIlEsEDUza7+yV2uTixENwbNYggB04GicCNQ8rjZkkP3nWJ6G4U+NpS3JiyE8PjWpr
 ZuE5d4qs2APOGvhFXsdkxpsy1LPB+FhWeo1uq8oZZ3xvCcT1L8FnGGDRa7ZaIKER92MuRubkk
 NCMf9ZPYohT2hxfrey47O5BVLNhl/co02h4t7gY1bFOM7GBVYtIvXSyCiVsqiiXp+/ygXLTfY
 bhhNOFc1V0p7A0MDR8PhAxHhGXyZftxZooJY6LPwosGYLVcZYcyx/X7sUZlD7B6RGc03tXZRa
 Cs8pFn7p8WKbrc7IMKufcnnICRhKDTBWRoh79Hw==
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The BCM2711 needs a different maximum DMA burst length. If not set
accordingly a timeout in the transmit queue happens and no package
can be sent. So use the new compatible to derive this value.

Until now the GENET HW version was used as the platform identifier.
This doesn't work with SoC-specific modifications, so introduce a proper
platform data structure.

Signed-off-by: Stefan Wahren <wahrenst@gmx.net>
Acked-by: Florian Fainelli <f.fainelli@gmail.com>
Reviewed-by: Matthias Brugger <mbrugger@suse.com>
=2D--
 drivers/net/ethernet/broadcom/genet/bcmgenet.c | 63 +++++++++++++++++++++=
+----
 drivers/net/ethernet/broadcom/genet/bcmgenet.h |  1 +
 2 files changed, 54 insertions(+), 10 deletions(-)

diff --git a/drivers/net/ethernet/broadcom/genet/bcmgenet.c b/drivers/net/=
ethernet/broadcom/genet/bcmgenet.c
index ee4d8ef..120fa05 100644
=2D-- a/drivers/net/ethernet/broadcom/genet/bcmgenet.c
+++ b/drivers/net/ethernet/broadcom/genet/bcmgenet.c
@@ -2576,7 +2576,8 @@ static int bcmgenet_init_dma(struct bcmgenet_priv *p=
riv)
 	}

 	/* Init rDma */
-	bcmgenet_rdma_writel(priv, DMA_MAX_BURST_LENGTH, DMA_SCB_BURST_SIZE);
+	bcmgenet_rdma_writel(priv, priv->dma_max_burst_length,
+			     DMA_SCB_BURST_SIZE);

 	/* Initialize Rx queues */
 	ret =3D bcmgenet_init_rx_queues(priv->dev);
@@ -2589,7 +2590,8 @@ static int bcmgenet_init_dma(struct bcmgenet_priv *p=
riv)
 	}

 	/* Init tDma */
-	bcmgenet_tdma_writel(priv, DMA_MAX_BURST_LENGTH, DMA_SCB_BURST_SIZE);
+	bcmgenet_tdma_writel(priv, priv->dma_max_burst_length,
+			     DMA_SCB_BURST_SIZE);

 	/* Initialize Tx queues */
 	bcmgenet_init_tx_queues(priv->dev);
@@ -3420,12 +3422,48 @@ static void bcmgenet_set_hw_params(struct bcmgenet=
_priv *priv)
 		params->words_per_bd);
 }

+struct bcmgenet_plat_data {
+	enum bcmgenet_version version;
+	u32 dma_max_burst_length;
+};
+
+static const struct bcmgenet_plat_data v1_plat_data =3D {
+	.version =3D GENET_V1,
+	.dma_max_burst_length =3D DMA_MAX_BURST_LENGTH,
+};
+
+static const struct bcmgenet_plat_data v2_plat_data =3D {
+	.version =3D GENET_V2,
+	.dma_max_burst_length =3D DMA_MAX_BURST_LENGTH,
+};
+
+static const struct bcmgenet_plat_data v3_plat_data =3D {
+	.version =3D GENET_V3,
+	.dma_max_burst_length =3D DMA_MAX_BURST_LENGTH,
+};
+
+static const struct bcmgenet_plat_data v4_plat_data =3D {
+	.version =3D GENET_V4,
+	.dma_max_burst_length =3D DMA_MAX_BURST_LENGTH,
+};
+
+static const struct bcmgenet_plat_data v5_plat_data =3D {
+	.version =3D GENET_V5,
+	.dma_max_burst_length =3D DMA_MAX_BURST_LENGTH,
+};
+
+static const struct bcmgenet_plat_data bcm2711_plat_data =3D {
+	.version =3D GENET_V5,
+	.dma_max_burst_length =3D 0x08,
+};
+
 static const struct of_device_id bcmgenet_match[] =3D {
-	{ .compatible =3D "brcm,genet-v1", .data =3D (void *)GENET_V1 },
-	{ .compatible =3D "brcm,genet-v2", .data =3D (void *)GENET_V2 },
-	{ .compatible =3D "brcm,genet-v3", .data =3D (void *)GENET_V3 },
-	{ .compatible =3D "brcm,genet-v4", .data =3D (void *)GENET_V4 },
-	{ .compatible =3D "brcm,genet-v5", .data =3D (void *)GENET_V5 },
+	{ .compatible =3D "brcm,genet-v1", .data =3D &v1_plat_data },
+	{ .compatible =3D "brcm,genet-v2", .data =3D &v2_plat_data },
+	{ .compatible =3D "brcm,genet-v3", .data =3D &v3_plat_data },
+	{ .compatible =3D "brcm,genet-v4", .data =3D &v4_plat_data },
+	{ .compatible =3D "brcm,genet-v5", .data =3D &v5_plat_data },
+	{ .compatible =3D "brcm,bcm2711-genet-v5", .data =3D &bcm2711_plat_data =
},
 	{ },
 };
 MODULE_DEVICE_TABLE(of, bcmgenet_match);
@@ -3435,6 +3473,7 @@ static int bcmgenet_probe(struct platform_device *pd=
ev)
 	struct bcmgenet_platform_data *pd =3D pdev->dev.platform_data;
 	struct device_node *dn =3D pdev->dev.of_node;
 	const struct of_device_id *of_id =3D NULL;
+	const struct bcmgenet_plat_data *pdata;
 	struct bcmgenet_priv *priv;
 	struct net_device *dev;
 	const void *macaddr;
@@ -3516,10 +3555,14 @@ static int bcmgenet_probe(struct platform_device *=
pdev)

 	priv->dev =3D dev;
 	priv->pdev =3D pdev;
-	if (of_id)
-		priv->version =3D (enum bcmgenet_version)of_id->data;
-	else
+	if (of_id) {
+		pdata =3D of_id->data;
+		priv->version =3D pdata->version;
+		priv->dma_max_burst_length =3D pdata->dma_max_burst_length;
+	} else {
 		priv->version =3D pd->genet_version;
+		priv->dma_max_burst_length =3D DMA_MAX_BURST_LENGTH;
+	}

 	priv->clk =3D devm_clk_get(&priv->pdev->dev, "enet");
 	if (IS_ERR(priv->clk)) {
diff --git a/drivers/net/ethernet/broadcom/genet/bcmgenet.h b/drivers/net/=
ethernet/broadcom/genet/bcmgenet.h
index dbc69d8..a565919 100644
=2D-- a/drivers/net/ethernet/broadcom/genet/bcmgenet.h
+++ b/drivers/net/ethernet/broadcom/genet/bcmgenet.h
@@ -664,6 +664,7 @@ struct bcmgenet_priv {
 	bool crc_fwd_en;

 	unsigned int dma_rx_chk_bit;
+	u32 dma_max_burst_length;

 	u32 msg_enable;

=2D-
2.7.4


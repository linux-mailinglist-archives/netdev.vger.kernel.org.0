Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8B693F6ED0
	for <lists+netdev@lfdr.de>; Mon, 11 Nov 2019 07:57:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726950AbfKKG5w (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Nov 2019 01:57:52 -0500
Received: from mout.gmx.net ([212.227.15.18]:47315 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726843AbfKKG5o (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 11 Nov 2019 01:57:44 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.net;
        s=badeba3b8450; t=1573455362;
        bh=8HV3EiHpIHVHXBdME3Q/eToeSF7Jm2HaGy/rlqtR8Ok=;
        h=X-UI-Sender-Class:From:To:Cc:Subject:Date:In-Reply-To:References;
        b=OS35HakRmMN/vW5B0NGPW1fASvPZvo4LGO0ksNKg+GhWg9pzowrKqRT85QStuX6gn
         xMEBbwHgAh5RJaEzAOgRlqGVccMJI3SMOP+7hX3a5fjJxlT2YNQHOwIvh6uhAy/CG8
         gAy6rzbLUiel3E9XWWIW8mFt0REfNkPoRtUI3nXY=
X-UI-Sender-Class: 01bb95c1-4bf8-414a-932a-4f6e2808ef9c
Received: from localhost.localdomain ([37.4.249.112]) by mail.gmx.com
 (mrgmx005 [212.227.17.190]) with ESMTPSA (Nemesis) id
 1MfYPi-1hxDuU2AdE-00g0F1; Mon, 11 Nov 2019 07:56:02 +0100
From:   Stefan Wahren <wahrenst@gmx.net>
To:     Matthias Brugger <matthias.bgg@kernel.org>,
        Matthias Brugger <mbrugger@suse.com>,
        "David S . Miller" <davem@davemloft.net>,
        Florian Fainelli <f.fainelli@gmail.com>
Cc:     Eric Anholt <eric@anholt.net>,
        Nicolas Saenz Julienne <nsaenzjulienne@suse.de>,
        Doug Berger <opendmb@gmail.com>, netdev@vger.kernel.org,
        bcm-kernel-feedback-list@broadcom.com,
        linux-arm-kernel@lists.infradead.org,
        Stefan Wahren <wahrenst@gmx.net>
Subject: [PATCH V4 net-next 4/7] net: bcmgenet: Add BCM2711 support
Date:   Mon, 11 Nov 2019 07:55:38 +0100
Message-Id: <1573455341-22813-5-git-send-email-wahrenst@gmx.net>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1573455341-22813-1-git-send-email-wahrenst@gmx.net>
References: <1573455341-22813-1-git-send-email-wahrenst@gmx.net>
X-Provags-ID: V03:K1:tRBUOnoU9EWg6WOY04KifIkEQDRnA9kKZz4ezZGLLoMf4Ocl2tg
 uk0mMja29Qfoz81SKYJlwy3j7OXMtUbHvR/7dbxmCCBe7N7tWpx/ejkqSwzxoQOHEfQs+X0
 +8p3sXTHeTSGMsPjdY6KUz/TEyq8xEymvN0dtlDtxHj/GCiWl3no+Lw6IHSVWp6f6gIAkio
 hQVIFZ3thzkMr+X59PV/g==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:xrqUkc5hyA8=:QyBakKAx3dPhq8Jn1H7yRv
 yQk7gKlELOMgNuv+H4YMEf1WFv3cRoYroK61LNuHdluPvsmTD6S6DjWCOVqc16U4siw7f5IpZ
 TGdZu9P0JehAm7Q2qhsC0jfbm+YZQvTEYSEd9vxPisXtxtnSBSuXK+UHEHj9WTnOO4bsASzpA
 VLxMibj5gC0kp4wZfpi7kalrkdD5ukdhc3CljyVd855t4Y2eZ6kHFKmScxZNWBcAD0YBqIt+2
 8bci4r5Y3E0zxB/LDBZgY0U6n2LdxNbGVPDMdqxFB+CezpAjmWEdkGO79Xkm2wPCvPx6si1aW
 sR6ru12+d6CL4bO9Gc5A67GI+usTQnfKKxKYMTxKjYDcazJYNeLxV36KWdj8Bw9V/6y5YsOkw
 I/GW2EDRHCVSXcaSuy46G02LT6qmXEuA4vqadod+VOYO3Kmha953EJrKqlRnwp5VSrOCcV+fa
 PuBvbQTx6G4LfPoB5yJyB3zbleFj1z/ZTCnbiWAd7QvKkEEWuEevImE7PJrHoIVopxba6HofX
 D+ooM1dEBakXRhptyuanxyLHimS4EftTRcioeXlR3W5ue9PoKCdafUxrKJvElL7G58c0nvdh0
 p/LihWLl6tlluiwlTho06hgwAHdeEeCd40Seh9SnoI/yKjMDgPw51OIJLwkw56ERH5EirzcFC
 UptVzqDoRf6xx10fll3lZ4MicZOd5Krk7bG2fZK/nCKn7gQRIdmG4JKiRsLOCY4nzZeisNxUX
 U3LBaUj3E/Jj8kt+XBzFziHXE7Nd7E4ivU2U/QZytI1ALCgHL4i7b0YLZQdRV5atAu4K4smg0
 lzsIMaKN84GKXfIFo30lLChxj4UGQRZl9qQkOh7nQgbcE06bH5E7ebVQPqTvWgVMl3x8FwCk7
 Zzn87BPqrjxO2aig74AybtMmjZLIuO1J1CCWiDgAxtD2fKattidm0diisfGiW7+f26d72qqzp
 vkAkPCFYWztqxTnN074Lps5M8Td8NsHGQmzF47jGOWdk/qBaswzWSisFUVieQw7pBcAQczJoO
 0gc6lkwde8/G/S5pYoRazsUybIUYWdsQQKMBA8xAOTVvTc1L2+0A9zT6v217GIwpfIN1Ejggc
 jxRIzaxislJ9l4LXpEihU2NIKiaQRu3zZ/oU4pTSpuUI1TOQaRkafhXjtCjxXlzVmO9UAWOls
 pi2PStrvTdQCBeN4UIGOe7q87TOSZj169alGMkvIwTL32QLbNKreR6mbvSzsDJAJuWLTae6cl
 KXOhYNaCD1flfda353OBC4ic1hv3YGKKrQfJN3A==
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


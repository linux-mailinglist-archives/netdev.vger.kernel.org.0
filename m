Return-Path: <netdev+bounces-1134-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 529B86FC50E
	for <lists+netdev@lfdr.de>; Tue,  9 May 2023 13:35:43 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 1F919281204
	for <lists+netdev@lfdr.de>; Tue,  9 May 2023 11:35:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7F37617AD2;
	Tue,  9 May 2023 11:35:22 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C2F0AD44
	for <netdev@vger.kernel.org>; Tue,  9 May 2023 11:35:22 +0000 (UTC)
Received: from mail-lf1-x132.google.com (mail-lf1-x132.google.com [IPv6:2a00:1450:4864:20::132])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4DDC42D62;
	Tue,  9 May 2023 04:35:20 -0700 (PDT)
Received: by mail-lf1-x132.google.com with SMTP id 2adb3069b0e04-4f139de8cefso33274559e87.0;
        Tue, 09 May 2023 04:35:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1683632118; x=1686224118;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=JEf8nW/e5rX1lrg2FM6+u2SZlAqTzqdeg72ZyL+zfRU=;
        b=DBoK7x1nOErHLKNeDarD+nJ7xAfoTVKzzzuvV1+0EbaXnT+NGaI9yz1CqpLTLvlkxm
         oSWE5X4e8uxiEGBIr+IzKysYKjXZQ312NPrRhjhNmUngxnuVTVxXKll5VG/qmg/Sgrhy
         inlNsCjDZJH28ohfRxgnqdan/4ecqPNd37GN3bd2IhmfrPRKcdyzLpkX8iM5DkcWIzMl
         T2AAxrNOH7fqdgxZrSiZWOx+1beHKeCywGAZ67WmNmOx/due+1rOadlAn+HbVCGaytkU
         f09hDEuCgfz2tHeHpd4+DWuYe/wrtwzNrR2CSsbgZk2vx1G9AUvbR0EDm+MWfaoZEeV3
         6WXg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683632118; x=1686224118;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=JEf8nW/e5rX1lrg2FM6+u2SZlAqTzqdeg72ZyL+zfRU=;
        b=SYIpi8UD5dZKcP0gqvWz31Gq1InQq2T+wbZb65iS9JuYMLmvWAqHNJQ5HWagL+ZUVc
         YTtcekY0qogJmdB9IVSR6fngdzwh17gnF27Y2IvOjFHziC8t0y6EBU/fHTZ4tfmL33xd
         7lVPRI4okQJQVRY6snMEV91/fvAV0DUm8q/5yC3rIpGef2wrrYF0rGNS5dJ2MNpezt2V
         pMZa+b0iRuQ49QsgbO3TjYQspqEsDyxjHiY1xU7/rQP0QB7zaXVzjRulPvSevNWiZ4sc
         7nlYNxuBx/neVqGT+xl4bTuyOhBcEow0p0EW3RHjz67pmv9njIgXzmyuxpJdsrC/onlq
         m+Mg==
X-Gm-Message-State: AC+VfDy7xes0b/sgopJ7ysdyoQHAjXgo5qtNUBXv5AfnqHpA1YtoODsQ
	kXkot0bxDfr5QsTTW8/ieUA=
X-Google-Smtp-Source: ACHHUZ5P6iPUUpdtAE+teUteA2tmyf8nbg5M4SKeRktLOJxdu7PzVPHjY547loWAYyrHE3ux5CGtGg==
X-Received: by 2002:ac2:5d6b:0:b0:4ee:fdd8:a536 with SMTP id h11-20020ac25d6b000000b004eefdd8a536mr684045lft.8.1683632118467;
        Tue, 09 May 2023 04:35:18 -0700 (PDT)
Received: from localhost.localdomain (93-80-66-133.broadband.corbina.ru. [93.80.66.133])
        by smtp.googlemail.com with ESMTPSA id k16-20020ac24570000000b004f25ccac240sm108940lfm.74.2023.05.09.04.35.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 09 May 2023 04:35:17 -0700 (PDT)
From: Ivan Mikhaylov <fr0st61te@gmail.com>
To: Samuel Mendoza-Jonas <sam@mendozajonas.com>,
	"David S . Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Rob Herring <robh+dt@kernel.org>,
	Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>
Cc: netdev@vger.kernel.org,
	devicetree@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	openbmc@lists.ozlabs.org,
	Ivan Mikhaylov <fr0st61te@gmail.com>
Subject: [PATCH v2 1/5] net/ncsi: make one oem_gma function for all mfr id
Date: Tue,  9 May 2023 14:35:00 +0000
Message-Id: <20230509143504.30382-2-fr0st61te@gmail.com>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230509143504.30382-1-fr0st61te@gmail.com>
References: <20230509143504.30382-1-fr0st61te@gmail.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
	RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Make the one Get Mac Address function for all manufacturers and change
this call in handlers accordingly.

Signed-off-by: Ivan Mikhaylov <fr0st61te@gmail.com>
---
 net/ncsi/ncsi-rsp.c | 88 ++++++++++-----------------------------------
 1 file changed, 19 insertions(+), 69 deletions(-)

diff --git a/net/ncsi/ncsi-rsp.c b/net/ncsi/ncsi-rsp.c
index 6447a09932f5..91c42253a711 100644
--- a/net/ncsi/ncsi-rsp.c
+++ b/net/ncsi/ncsi-rsp.c
@@ -611,14 +611,15 @@ static int ncsi_rsp_handler_snfc(struct ncsi_request *nr)
 	return 0;
 }
 
-/* Response handler for Mellanox command Get Mac Address */
-static int ncsi_rsp_handler_oem_mlx_gma(struct ncsi_request *nr)
+/* Response handler for Get Mac Address command */
+static int ncsi_rsp_handler_oem_gma(struct ncsi_request *nr, int mfr_id)
 {
 	struct ncsi_dev_priv *ndp = nr->ndp;
 	struct net_device *ndev = ndp->ndev.dev;
 	const struct net_device_ops *ops = ndev->netdev_ops;
 	struct ncsi_rsp_oem_pkt *rsp;
 	struct sockaddr saddr;
+	u32 mac_addr_off = 0;
 	int ret = 0;
 
 	/* Get the response header */
@@ -626,7 +627,19 @@ static int ncsi_rsp_handler_oem_mlx_gma(struct ncsi_request *nr)
 
 	saddr.sa_family = ndev->type;
 	ndev->priv_flags |= IFF_LIVE_ADDR_CHANGE;
-	memcpy(saddr.sa_data, &rsp->data[MLX_MAC_ADDR_OFFSET], ETH_ALEN);
+	if (mfr_id == NCSI_OEM_MFR_BCM_ID)
+		mac_addr_off = BCM_MAC_ADDR_OFFSET;
+	else if (mfr_id == NCSI_OEM_MFR_MLX_ID)
+		mac_addr_off = MLX_MAC_ADDR_OFFSET;
+	else if (mfr_id == NCSI_OEM_MFR_INTEL_ID)
+		mac_addr_off = INTEL_MAC_ADDR_OFFSET;
+
+	memcpy(saddr.sa_data, &rsp->data[mac_addr_off], ETH_ALEN);
+	if (mfr_id == NCSI_OEM_MFR_BCM_ID || mfr_id == NCSI_OEM_MFR_INTEL_ID)
+		eth_addr_inc((u8 *)saddr.sa_data);
+	if (!is_valid_ether_addr((const u8 *)saddr.sa_data))
+		return -ENXIO;
+
 	/* Set the flag for GMA command which should only be called once */
 	ndp->gma_flag = 1;
 
@@ -649,41 +662,10 @@ static int ncsi_rsp_handler_oem_mlx(struct ncsi_request *nr)
 
 	if (mlx->cmd == NCSI_OEM_MLX_CMD_GMA &&
 	    mlx->param == NCSI_OEM_MLX_CMD_GMA_PARAM)
-		return ncsi_rsp_handler_oem_mlx_gma(nr);
+		return ncsi_rsp_handler_oem_gma(nr, NCSI_OEM_MFR_MLX_ID);
 	return 0;
 }
 
-/* Response handler for Broadcom command Get Mac Address */
-static int ncsi_rsp_handler_oem_bcm_gma(struct ncsi_request *nr)
-{
-	struct ncsi_dev_priv *ndp = nr->ndp;
-	struct net_device *ndev = ndp->ndev.dev;
-	const struct net_device_ops *ops = ndev->netdev_ops;
-	struct ncsi_rsp_oem_pkt *rsp;
-	struct sockaddr saddr;
-	int ret = 0;
-
-	/* Get the response header */
-	rsp = (struct ncsi_rsp_oem_pkt *)skb_network_header(nr->rsp);
-
-	saddr.sa_family = ndev->type;
-	ndev->priv_flags |= IFF_LIVE_ADDR_CHANGE;
-	memcpy(saddr.sa_data, &rsp->data[BCM_MAC_ADDR_OFFSET], ETH_ALEN);
-	/* Increase mac address by 1 for BMC's address */
-	eth_addr_inc((u8 *)saddr.sa_data);
-	if (!is_valid_ether_addr((const u8 *)saddr.sa_data))
-		return -ENXIO;
-
-	/* Set the flag for GMA command which should only be called once */
-	ndp->gma_flag = 1;
-
-	ret = ops->ndo_set_mac_address(ndev, &saddr);
-	if (ret < 0)
-		netdev_warn(ndev, "NCSI: 'Writing mac address to device failed\n");
-
-	return ret;
-}
-
 /* Response handler for Broadcom card */
 static int ncsi_rsp_handler_oem_bcm(struct ncsi_request *nr)
 {
@@ -695,42 +677,10 @@ static int ncsi_rsp_handler_oem_bcm(struct ncsi_request *nr)
 	bcm = (struct ncsi_rsp_oem_bcm_pkt *)(rsp->data);
 
 	if (bcm->type == NCSI_OEM_BCM_CMD_GMA)
-		return ncsi_rsp_handler_oem_bcm_gma(nr);
+		return ncsi_rsp_handler_oem_gma(nr, NCSI_OEM_MFR_BCM_ID);
 	return 0;
 }
 
-/* Response handler for Intel command Get Mac Address */
-static int ncsi_rsp_handler_oem_intel_gma(struct ncsi_request *nr)
-{
-	struct ncsi_dev_priv *ndp = nr->ndp;
-	struct net_device *ndev = ndp->ndev.dev;
-	const struct net_device_ops *ops = ndev->netdev_ops;
-	struct ncsi_rsp_oem_pkt *rsp;
-	struct sockaddr saddr;
-	int ret = 0;
-
-	/* Get the response header */
-	rsp = (struct ncsi_rsp_oem_pkt *)skb_network_header(nr->rsp);
-
-	saddr.sa_family = ndev->type;
-	ndev->priv_flags |= IFF_LIVE_ADDR_CHANGE;
-	memcpy(saddr.sa_data, &rsp->data[INTEL_MAC_ADDR_OFFSET], ETH_ALEN);
-	/* Increase mac address by 1 for BMC's address */
-	eth_addr_inc((u8 *)saddr.sa_data);
-	if (!is_valid_ether_addr((const u8 *)saddr.sa_data))
-		return -ENXIO;
-
-	/* Set the flag for GMA command which should only be called once */
-	ndp->gma_flag = 1;
-
-	ret = ops->ndo_set_mac_address(ndev, &saddr);
-	if (ret < 0)
-		netdev_warn(ndev,
-			    "NCSI: 'Writing mac address to device failed\n");
-
-	return ret;
-}
-
 /* Response handler for Intel card */
 static int ncsi_rsp_handler_oem_intel(struct ncsi_request *nr)
 {
@@ -742,7 +692,7 @@ static int ncsi_rsp_handler_oem_intel(struct ncsi_request *nr)
 	intel = (struct ncsi_rsp_oem_intel_pkt *)(rsp->data);
 
 	if (intel->cmd == NCSI_OEM_INTEL_CMD_GMA)
-		return ncsi_rsp_handler_oem_intel_gma(nr);
+		return ncsi_rsp_handler_oem_gma(nr, NCSI_OEM_MFR_INTEL_ID);
 
 	return 0;
 }
-- 
2.40.1



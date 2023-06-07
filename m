Return-Path: <netdev+bounces-8909-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id A13887263FC
	for <lists+netdev@lfdr.de>; Wed,  7 Jun 2023 17:18:16 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 09F341C20E32
	for <lists+netdev@lfdr.de>; Wed,  7 Jun 2023 15:18:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7C67330B9B;
	Wed,  7 Jun 2023 15:17:56 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B8FA1ACB5
	for <netdev@vger.kernel.org>; Wed,  7 Jun 2023 15:17:56 +0000 (UTC)
Received: from mail-lj1-x22e.google.com (mail-lj1-x22e.google.com [IPv6:2a00:1450:4864:20::22e])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2685E1BE2;
	Wed,  7 Jun 2023 08:17:54 -0700 (PDT)
Received: by mail-lj1-x22e.google.com with SMTP id 38308e7fff4ca-2b203360d93so7257961fa.3;
        Wed, 07 Jun 2023 08:17:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1686151072; x=1688743072;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=WeqtwiQhONf8j07mpNFn1jzgxpzelUIw0fWyS3xg0dc=;
        b=Lx17MFNsn/9ERHdWH/+iZazwCcZL6wc+m6u7vV9uUaqy0wliQUbPKVrER8Lkw8FQyA
         +3ckoe7wBacq1yOBaZ7rSJGG+xtFS0koGBmwRl3S7Px822Ohwmbdtll5EIkZG4HN1kT1
         iBluAI1l5R4DjR2FjOQqhrKVm7Qwj6+gmpg1t+zgUvNiUDqkmgsrE1Ta8Y7P3E4QU8iE
         cALpYcsgOXdceRd4NxFbIDym0sWRxkJ+BlYp63ZSVjI7yPgfjhgtAygG10ZWgv5YPVJn
         7f6a85lkhI/R+Px8yJTsni+ahz8Mj//cIHECxYu8tdCMHyCpSxJglZk4tXnY+nOmD7HO
         F5Ew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686151072; x=1688743072;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=WeqtwiQhONf8j07mpNFn1jzgxpzelUIw0fWyS3xg0dc=;
        b=HR+TfBkj+lrlarNAYmtX2vWUR36xDfo2qrSh6zVbGMi9AifAtpaXw2AoXP7Ea121Dn
         SsfFeyeWWteHUj2KpO+TecjckceEuO/cHcZd7IJV3ARIFYsA59PKeXklS7edTPzH/KY3
         DXrwmN6yHFouv+N71VQAursymaO6wnf8JDvCs2XWpjeOQ6kS+qA9VanVmb7TTu9yVOCc
         NsH5ZeBiJeeUySHGx4z2Ivae1RvU3fM0CH1jmhaQUTo23KGc41NrqJugwT92Lt6nBFDS
         zqpOBMEdDsYeug49iDPSRBX+d3b+MQBRZrIAT5EMQj60woEx8rRvQTfqTVpy7vUEKejU
         6JaA==
X-Gm-Message-State: AC+VfDzmhc3Nb9Q+7IeiH80OXqbTqTLy6i1pJAgNVpbdde//2Du6kWx2
	2KfzYdf8YjkRELuwWFutwlk=
X-Google-Smtp-Source: ACHHUZ6LciptBSsUdDC0lDf9avlU6xBBuTumLDmRYi+6ZwREtBKF7a45WKWW56g12fI+0JoONi2agw==
X-Received: by 2002:a2e:854b:0:b0:2b1:cf7c:a892 with SMTP id u11-20020a2e854b000000b002b1cf7ca892mr2458042ljj.30.1686151072022;
        Wed, 07 Jun 2023 08:17:52 -0700 (PDT)
Received: from localhost.localdomain (95-31-191-227.broadband.corbina.ru. [95.31.191.227])
        by smtp.googlemail.com with ESMTPSA id v5-20020a2e87c5000000b002ad9a1bfa8esm2302014ljj.1.2023.06.07.08.17.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 07 Jun 2023 08:17:51 -0700 (PDT)
From: Ivan Mikhaylov <fr0st61te@gmail.com>
To: Samuel Mendoza-Jonas <sam@mendozajonas.com>,
	"David S . Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Vijay Khemka <vijaykhemka@fb.com>
Cc: netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	openbmc@lists.ozlabs.org,
	Ivan Mikhaylov <fr0st61te@gmail.com>,
	Simon Horman <simon.horman@corigine.com>
Subject: [PATCH v3 1/2] net/ncsi: make one oem_gma function for all mfr id
Date: Wed,  7 Jun 2023 18:17:41 +0300
Message-Id: <20230607151742.6699-2-fr0st61te@gmail.com>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230607151742.6699-1-fr0st61te@gmail.com>
References: <20230607151742.6699-1-fr0st61te@gmail.com>
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

Reviewed-by: Simon Horman <simon.horman@corigine.com>
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



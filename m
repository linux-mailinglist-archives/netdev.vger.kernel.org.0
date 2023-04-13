Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AC6706E00D1
	for <lists+netdev@lfdr.de>; Wed, 12 Apr 2023 23:29:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229894AbjDLV3T (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Apr 2023 17:29:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57902 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229736AbjDLV3S (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 12 Apr 2023 17:29:18 -0400
Received: from mail-lj1-x236.google.com (mail-lj1-x236.google.com [IPv6:2a00:1450:4864:20::236])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EFC8B61BE;
        Wed, 12 Apr 2023 14:29:16 -0700 (PDT)
Received: by mail-lj1-x236.google.com with SMTP id e3so4616629ljn.1;
        Wed, 12 Apr 2023 14:29:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1681334955;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Gf1Kh5uQzs3C5TGP5BVbMx6BF/0Z+MG9RXtrMz1RDgM=;
        b=GkXYQ/3beNepeO3usBEwjwoDTlL8QGlWGIQ/aF3svhoBZEwQLr1SCHRMg4xKhcdeJr
         /Fvq6jbZfV6pnSftbXF+TGTJt6LQQHzP0g8V2c0Xq3nKUfxTdkhK7H5sHvKfbzU3qG7+
         zkL0+F7EyX1ZUJTAXUwIM4nKgjOPWGiCGr++2TkUMYfdSMXomltUxQLFQQBV2sdi9Df3
         TpdtmCxW+As3NH+yHY3VXdqx6zk4tHkEZniI2gXlgqTJCTR0dm/Zp9I1E9GyLeuvapdc
         0aRKyI/yOH1Umqlep1Hk6uOI2xq3iQuQx1hwsROlRWvso6LJ3kNiQS2qwAxvc+U6ondm
         BCVg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681334955;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Gf1Kh5uQzs3C5TGP5BVbMx6BF/0Z+MG9RXtrMz1RDgM=;
        b=k0UKCVOp+nu5H6E+kiJ3rpl07HYqO4eE8frMHT/HgNMudUQ6sGeVoHyI9S6jCTxS0E
         JDdfrqN7n9I+qO26HKRVZ/dPge53kgLRRajebbPCCQE5/LKv7LPJcRT3tNRnDAvcKuGJ
         XEZ0GXh71x30gNgF2gQa8aMO6xlx0rndYuWeOjY/ewiTG1pjHKEi7bhFcJsI9k/IKJ/d
         YT8V49qjYr9HMD4+spgKctBBfpt7GzXUncysIXU/Mmxv6FpkoKsGpGr0RZ0z9DZ1h6hn
         buLN496OUFEQdpi/wEkP1fgo7wQVWPv9p0wKMHMRw7Zfis075mFObYwyqPJoZzJXyIus
         Zu2w==
X-Gm-Message-State: AAQBX9fgyRjCk6dj7rK4vJn0E2DKHcLXVtqwdj5FuLBvaj6sJ9qM30r+
        OBa3ajUD25wBwSFufyclSM0=
X-Google-Smtp-Source: AKy350YsA11yAODO6cQEvGeRv+XcnYg8ZwmfbqA/a0ZN7yoxXNuF2g+6V+85Fb+18kioaXmyv/JRoA==
X-Received: by 2002:a05:651c:d5:b0:2a7:6f60:34f2 with SMTP id 21-20020a05651c00d500b002a76f6034f2mr21442ljr.33.1681334955193;
        Wed, 12 Apr 2023 14:29:15 -0700 (PDT)
Received: from localhost.localdomain (93-80-67-75.broadband.corbina.ru. [93.80.67.75])
        by smtp.googlemail.com with ESMTPSA id p14-20020a2e804e000000b002a7758b13c9sm1882481ljg.52.2023.04.12.14.29.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 12 Apr 2023 14:29:14 -0700 (PDT)
From:   Ivan Mikhaylov <fr0st61te@gmail.com>
To:     Samuel Mendoza-Jonas <sam@mendozajonas.com>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>
Cc:     netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, Ivan Mikhaylov <fr0st61te@gmail.com>
Subject: [PATCH 1/4] net/ncsi: make one oem_gma function for all mfr id
Date:   Thu, 13 Apr 2023 00:29:02 +0000
Message-Id: <20230413002905.5513-2-fr0st61te@gmail.com>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230413002905.5513-1-fr0st61te@gmail.com>
References: <20230413002905.5513-1-fr0st61te@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

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
2.40.0


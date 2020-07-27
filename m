Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A4B0B22E947
	for <lists+netdev@lfdr.de>; Mon, 27 Jul 2020 11:41:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727936AbgG0JlQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Jul 2020 05:41:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49734 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726139AbgG0JlP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Jul 2020 05:41:15 -0400
Received: from mail-pg1-x542.google.com (mail-pg1-x542.google.com [IPv6:2607:f8b0:4864:20::542])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2834EC061794
        for <netdev@vger.kernel.org>; Mon, 27 Jul 2020 02:41:15 -0700 (PDT)
Received: by mail-pg1-x542.google.com with SMTP id s189so9162418pgc.13
        for <netdev@vger.kernel.org>; Mon, 27 Jul 2020 02:41:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=KTsmP6nwmd8wRDLbbW3/oz+Q+fROVNjlX2EbifXxIWo=;
        b=Ou+3BOnLMYtN0nw5Gg0Grhp2B0IMwdvdr+VWv93YrWmxnKfLvyX3dR8NoSGqFKgBd+
         x3T4cGmdYLWlp6SNRERXd0d1fCY8xJ0hiUTVkKsnV5qC54FerGk7dQsA1Mk5Qeiu0+o3
         MrIGaSAJ6tXg+20Vd6HQZ7R4gq266MYdHUWhU=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=KTsmP6nwmd8wRDLbbW3/oz+Q+fROVNjlX2EbifXxIWo=;
        b=b9v6pQJP/g2jP3X31BXMk4EjY8yvQPfj8RvNm9TVOxRd2VL6Xdh842qN7BZzndfohG
         vQnoqeKSs4vLVD1bkB9dDXKl3bEgRMH4F7sQ18EyjILKCJ5oga3yqVWVsKtoTvK06i2Z
         PAIQhkPwiLZP/ykPRBse/DxtU0FEvzq8NjiRHi7mSuIRT1jvhpQlLNgc0hV97XpH3sX6
         +37fhgXoHIzXec0YD2KlTCWx7mnvdBIsACOTVLbwD7R9vQfsTES+rKg4CIYYrV+5lktQ
         ZQ4xn+TI7FmG5TKCEEJjXjlKz4kuSmi+mBIDVm7tX9I+JkclAc8ZIiNITuju+a60NJgK
         tFlQ==
X-Gm-Message-State: AOAM530RxCy8mvwxqlFIM2UNnzLq/FQfFM/P/ZcpVf7kT3Y1PeOVyP82
        sA7AWstLXz20rjyEcK17YevTbQ==
X-Google-Smtp-Source: ABdhPJwj2cJYgefMcgbY3HY0yeZQaASrN0HbT9/d8xmb+GKTntFoBVoz8Nfp9+9QLZd0W3T52cGw3w==
X-Received: by 2002:a65:4502:: with SMTP id n2mr18970828pgq.132.1595842874641;
        Mon, 27 Jul 2020 02:41:14 -0700 (PDT)
Received: from localhost.swdvt.lab.broadcom.com ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id f131sm14560945pgc.14.2020.07.27.02.41.12
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 27 Jul 2020 02:41:14 -0700 (PDT)
From:   Michael Chan <michael.chan@broadcom.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, kuba@kernel.org
Subject: [PATCH net-next v2 03/10] bnxt_en: Use macros to define port statistics size and offset.
Date:   Mon, 27 Jul 2020 05:40:38 -0400
Message-Id: <1595842845-19403-4-git-send-email-michael.chan@broadcom.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1595842845-19403-1-git-send-email-michael.chan@broadcom.com>
References: <1595842845-19403-1-git-send-email-michael.chan@broadcom.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The port statistics structures have hard coded padding and offset.
Define macros to make this look cleaner.

Reviewed-by: Pavan Chebbi <pavan.chebbi@broadcom.com>
Reviewed-by: Vasundhara Volam <vasundhara-v.volam@broadcom.com>
Signed-off-by: Michael Chan <michael.chan@broadcom.com>
---
 drivers/net/ethernet/broadcom/bnxt/bnxt.c | 8 ++++----
 drivers/net/ethernet/broadcom/bnxt/bnxt.h | 8 +++++++-
 2 files changed, 11 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt.c b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
index cd794b0..b4a387c 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
@@ -3780,8 +3780,7 @@ static int bnxt_alloc_stats(struct bnxt *bp)
 	if (bp->hw_rx_port_stats)
 		goto alloc_ext_stats;
 
-	bp->hw_port_stats_size = sizeof(struct rx_port_stats) +
-				 sizeof(struct tx_port_stats) + 1024;
+	bp->hw_port_stats_size = BNXT_PORT_STATS_SIZE;
 
 	bp->hw_rx_port_stats =
 		dma_alloc_coherent(&pdev->dev, bp->hw_port_stats_size,
@@ -3790,9 +3789,10 @@ static int bnxt_alloc_stats(struct bnxt *bp)
 	if (!bp->hw_rx_port_stats)
 		return -ENOMEM;
 
-	bp->hw_tx_port_stats = (void *)(bp->hw_rx_port_stats + 1) + 512;
+	bp->hw_tx_port_stats = (void *)bp->hw_rx_port_stats +
+			       BNXT_TX_PORT_STATS_BYTE_OFFSET;
 	bp->hw_tx_port_stats_map = bp->hw_rx_port_stats_map +
-				   sizeof(struct rx_port_stats) + 512;
+				   BNXT_TX_PORT_STATS_BYTE_OFFSET;
 	bp->flags |= BNXT_FLAG_PORT_STATS;
 
 alloc_ext_stats:
diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt.h b/drivers/net/ethernet/broadcom/bnxt/bnxt.h
index 306636d..df62897 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.h
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.h
@@ -1926,12 +1926,18 @@ struct bnxt {
 	struct device		*hwmon_dev;
 };
 
+#define BNXT_PORT_STATS_SIZE				\
+	(sizeof(struct rx_port_stats) + sizeof(struct tx_port_stats) + 1024)
+
+#define BNXT_TX_PORT_STATS_BYTE_OFFSET			\
+	(sizeof(struct rx_port_stats) + 512)
+
 #define BNXT_RX_STATS_OFFSET(counter)			\
 	(offsetof(struct rx_port_stats, counter) / 8)
 
 #define BNXT_TX_STATS_OFFSET(counter)			\
 	((offsetof(struct tx_port_stats, counter) +	\
-	  sizeof(struct rx_port_stats) + 512) / 8)
+	  BNXT_TX_PORT_STATS_BYTE_OFFSET) / 8)
 
 #define BNXT_RX_STATS_EXT_OFFSET(counter)		\
 	(offsetof(struct rx_port_stats_ext, counter) / 8)
-- 
1.8.3.1


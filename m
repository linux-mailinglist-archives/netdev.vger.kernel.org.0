Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F201C22E472
	for <lists+netdev@lfdr.de>; Mon, 27 Jul 2020 05:30:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727064AbgG0DaZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 26 Jul 2020 23:30:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48974 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726932AbgG0DaX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 26 Jul 2020 23:30:23 -0400
Received: from mail-pl1-x643.google.com (mail-pl1-x643.google.com [IPv6:2607:f8b0:4864:20::643])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 93D6DC0619D2
        for <netdev@vger.kernel.org>; Sun, 26 Jul 2020 20:30:23 -0700 (PDT)
Received: by mail-pl1-x643.google.com with SMTP id d1so7283824plr.8
        for <netdev@vger.kernel.org>; Sun, 26 Jul 2020 20:30:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=KTsmP6nwmd8wRDLbbW3/oz+Q+fROVNjlX2EbifXxIWo=;
        b=B1LTATU+xfSAJOYGfQSUmDoJHt/4E4TdeBRMs7PCJPSCPPcmpGz5O6vsFONyOg1uPy
         VNR9tmA2QeimsSgL7KXLWAZZY/iYEm+tderEAwt7stR59qfNneFy0VUv3RPRa7B6kY1k
         kz5puq1UKvQDuS5OPJdHHvzj8fhK4yRQ3EtmY=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=KTsmP6nwmd8wRDLbbW3/oz+Q+fROVNjlX2EbifXxIWo=;
        b=gxWfhe7SNUa1Cr4C24wDfDJftco0Gi0SsPlDS6G8zvniygSEqOkfu0ZW5spuWwdcKs
         m5FgZJ/ACsX2ahh5RTadHukYFZsS081xfhXjOwg4KPYxhwdQfP7bY5E4J4pE3xUR2usv
         uNTwYtSsFRsW9xVy7TKyyTaWp24DmqScbyumQoJhFl2j3TsWUxdKj7BM4NaadPFN97lF
         rLu7f0S13AIDhSk6Fyto//RbS7dnK93kz0Thvpvufr5gETtzUbmxTvxvmGKz3yc67Xlc
         5g2sAJu1vvzeE9T29ZCRJozZUDN3cHplYDXv6RpCOt0ghamsn/pUK4nsC0cPse330ZPy
         FJsQ==
X-Gm-Message-State: AOAM5337aIhDi8jgVuPGi4oY/c0lWokLS2oaxFqXucMvWeCUkEo2xm+0
        vj8I2XV0F2buOpyhFMvx0VzaMleNkjQ=
X-Google-Smtp-Source: ABdhPJw199cKF3P9K/KLzM+V/DTFB1g7/szuq4UGi4dBHRX/sn+r3igbC0OTF4DPYPOKOeMouFjkCw==
X-Received: by 2002:a17:90a:5d15:: with SMTP id s21mr17230212pji.154.1595820622985;
        Sun, 26 Jul 2020 20:30:22 -0700 (PDT)
Received: from localhost.swdvt.lab.broadcom.com ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id n25sm13504506pff.51.2020.07.26.20.30.20
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 26 Jul 2020 20:30:22 -0700 (PDT)
From:   Michael Chan <michael.chan@broadcom.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, kuba@kernel.org
Subject: [PATCH net-next 03/10] bnxt_en: Use macros to define port statistics size and offset.
Date:   Sun, 26 Jul 2020 23:29:39 -0400
Message-Id: <1595820586-2203-4-git-send-email-michael.chan@broadcom.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1595820586-2203-1-git-send-email-michael.chan@broadcom.com>
References: <1595820586-2203-1-git-send-email-michael.chan@broadcom.com>
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


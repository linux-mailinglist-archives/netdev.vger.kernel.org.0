Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7E2AA4E481A
	for <lists+netdev@lfdr.de>; Tue, 22 Mar 2022 22:08:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235152AbiCVVJ0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Mar 2022 17:09:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40722 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235087AbiCVVJS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Mar 2022 17:09:18 -0400
Received: from mail-wm1-x32a.google.com (mail-wm1-x32a.google.com [IPv6:2a00:1450:4864:20::32a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C8F2D3E5F9
        for <netdev@vger.kernel.org>; Tue, 22 Mar 2022 14:07:49 -0700 (PDT)
Received: by mail-wm1-x32a.google.com with SMTP id k124-20020a1ca182000000b0038c9cf6e2a6so2702759wme.0
        for <netdev@vger.kernel.org>; Tue, 22 Mar 2022 14:07:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=engleder-embedded-com.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=r4mWBVMcX+Ym/GkYMe5nyJzvD+eaNrKowzj3i13n1h4=;
        b=VE/Bpo/a49xcsDbf/70gNF1Fc8f9+DSghlyytRzZwO9ga+f3qb91IcloszLjXjM40F
         8Q/zYHzRuZduB+jNQ4TEkfY7oU+hY5IZdx4fWgXjdoIxeAnbO2srlk/OVv3+SmpeHT/b
         6lgYa9UHnxyk9g6YweAqH5rNH+P9cMNVbPYKsPJcn2/soE/GBnsgqsLH47rHhyyTtYJq
         hWiN6MeM/l8SYCkhk0Fys11jNjlFySRwVNG5mhhod2gJ+pJOv5zlQ/0um4JYkLQupuRJ
         I40t7VirA6ytKRTphQhl6Jg+vbNz7foPvdACyAelNI+PfCo491ngs+8AXLvj+kjNtODK
         qcgg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=r4mWBVMcX+Ym/GkYMe5nyJzvD+eaNrKowzj3i13n1h4=;
        b=sBDXmWUeO2ggMRcbaHUqM6dVZ7GU1HRk7j22KCHz/nhQJPyqrisfGN2OxAWn5WCD/S
         m8zEjHqTFPdYdBwtGhD3ICWJwhtMjZUGSOpC7z8d+Q/V40Qd3YzKETC33psr0OsWAoXX
         ulJQorq+evY/VIRNYOwWwr5VuMrpWOuz/OQon1dWIqt7c3HTTPahQHDcQxABVNw6k0yd
         QIbuLQlStYpalDMYwMgiuiTIiwgcdvdo3orFGfcdLWP1B0yDyWnD0hyB5fnaC44PfHvX
         abVQ5M7gNfm1R9V/M08oGKDBCw1o6pA4awHGlEIkk5kUsluXOVvtG9gTRj2v96Uh6PYP
         USKQ==
X-Gm-Message-State: AOAM531+Cl4hWelngk2Op0Ek8LOMEqKpJxbiGTg7m6tsk0vNBr7hOyUH
        uUfvyOzohCMbBHEg6LrbVosvYA==
X-Google-Smtp-Source: ABdhPJzCfG2mjYPHIZ+KXzxsIShToVyJS9flGedZGp8KeIue8PwJ6AzA0D0eW7fJyAItqw6tXwUJ2A==
X-Received: by 2002:a1c:cc01:0:b0:37b:dcc8:7dfd with SMTP id h1-20020a1ccc01000000b0037bdcc87dfdmr5724873wmb.134.1647983268421;
        Tue, 22 Mar 2022 14:07:48 -0700 (PDT)
Received: from hornet.engleder.at ([2001:871:23a:8366:6e3b:e5ff:fe2c:34c1])
        by smtp.gmail.com with ESMTPSA id c7-20020a5d4f07000000b00203db8f13c6sm16281805wru.75.2022.03.22.14.07.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 22 Mar 2022 14:07:48 -0700 (PDT)
From:   Gerhard Engleder <gerhard@engleder-embedded.com>
To:     richardcochran@gmail.com, yangbo.lu@nxp.com, davem@davemloft.net,
        kuba@kernel.org
Cc:     mlichvar@redhat.com, vinicius.gomes@intel.com,
        netdev@vger.kernel.org,
        Gerhard Engleder <gerhard@engleder-embedded.com>
Subject: [PATCH net-next v1 6/6] tsnep: Add physical clock cycles support
Date:   Tue, 22 Mar 2022 22:07:22 +0100
Message-Id: <20220322210722.6405-7-gerhard@engleder-embedded.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20220322210722.6405-1-gerhard@engleder-embedded.com>
References: <20220322210722.6405-1-gerhard@engleder-embedded.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The TSN endpoint Ethernet MAC supports a free running counter
additionally to its clock. This free running counter can be read and
hardware timestamps are supported. As the name implies, this counter
cannot be set and its frequency cannot be adjusted.

Add cycles support based on free running counter to physical clock. This
also requires hardware time stamps based on that free running counter.

Signed-off-by: Gerhard Engleder <gerhard@engleder-embedded.com>
---
 drivers/net/ethernet/engleder/tsnep_hw.h   |  9 ++++-
 drivers/net/ethernet/engleder/tsnep_main.c | 27 ++++++++-----
 drivers/net/ethernet/engleder/tsnep_ptp.c  | 44 ++++++++++++++++++++++
 3 files changed, 69 insertions(+), 11 deletions(-)

diff --git a/drivers/net/ethernet/engleder/tsnep_hw.h b/drivers/net/ethernet/engleder/tsnep_hw.h
index 71cc8577d640..916ceac3ada2 100644
--- a/drivers/net/ethernet/engleder/tsnep_hw.h
+++ b/drivers/net/ethernet/engleder/tsnep_hw.h
@@ -43,6 +43,10 @@
 #define ECM_RESET_CHANNEL 0x00000100
 #define ECM_RESET_TXRX 0x00010000
 
+/* counter */
+#define ECM_COUNTER_LOW 0x0028
+#define ECM_COUNTER_HIGH 0x002C
+
 /* control and status */
 #define ECM_STATUS 0x0080
 #define ECM_LINK_MODE_OFF 0x01000000
@@ -190,7 +194,8 @@ struct tsnep_tx_desc {
 /* tsnep TX descriptor writeback */
 struct tsnep_tx_desc_wb {
 	__le32 properties;
-	__le32 reserved1[3];
+	__le32 reserved1;
+	__le64 counter;
 	__le64 timestamp;
 	__le32 dma_delay;
 	__le32 reserved2;
@@ -221,7 +226,7 @@ struct tsnep_rx_desc_wb {
 
 /* tsnep RX inline meta */
 struct tsnep_rx_inline {
-	__le64 reserved;
+	__le64 counter;
 	__le64 timestamp;
 };
 
diff --git a/drivers/net/ethernet/engleder/tsnep_main.c b/drivers/net/ethernet/engleder/tsnep_main.c
index 904f3304727e..599776c6bd5e 100644
--- a/drivers/net/ethernet/engleder/tsnep_main.c
+++ b/drivers/net/ethernet/engleder/tsnep_main.c
@@ -441,6 +441,7 @@ static bool tsnep_tx_poll(struct tsnep_tx *tx, int napi_budget)
 	unsigned long flags;
 	int budget = 128;
 	struct tsnep_tx_entry *entry;
+	struct skb_shared_info *shinfo;
 	int count;
 
 	spin_lock_irqsave(&tx->lock, flags);
@@ -460,18 +461,26 @@ static bool tsnep_tx_poll(struct tsnep_tx *tx, int napi_budget)
 		 */
 		dma_rmb();
 
+		shinfo = skb_shinfo(entry->skb);
+
 		count = 1;
-		if (skb_shinfo(entry->skb)->nr_frags > 0)
-			count += skb_shinfo(entry->skb)->nr_frags;
+		if (shinfo->nr_frags > 0)
+			count += shinfo->nr_frags;
 
 		tsnep_tx_unmap(tx, count);
 
-		if ((skb_shinfo(entry->skb)->tx_flags & SKBTX_IN_PROGRESS) &&
+		if ((shinfo->tx_flags & SKBTX_IN_PROGRESS) &&
 		    (__le32_to_cpu(entry->desc_wb->properties) &
 		     TSNEP_DESC_EXTENDED_WRITEBACK_FLAG)) {
-			struct skb_shared_hwtstamps hwtstamps;
-			u64 timestamp =
-				__le64_to_cpu(entry->desc_wb->timestamp);
+			struct skb_shared_hwtstamps hwtstamps = {};
+			u64 timestamp;
+
+			if (shinfo->tx_flags & SKBTX_HW_TSTAMP_USE_CYCLES)
+				timestamp =
+					__le64_to_cpu(entry->desc_wb->counter);
+			else
+				timestamp =
+					__le64_to_cpu(entry->desc_wb->timestamp);
 
 			memset(&hwtstamps, 0, sizeof(hwtstamps));
 			hwtstamps.hwtstamp = ns_to_ktime(timestamp);
@@ -704,11 +713,11 @@ static int tsnep_rx_poll(struct tsnep_rx *rx, struct napi_struct *napi,
 					skb_hwtstamps(skb);
 				struct tsnep_rx_inline *rx_inline =
 					(struct tsnep_rx_inline *)skb->data;
-				u64 timestamp =
-					__le64_to_cpu(rx_inline->timestamp);
 
+				skb_shinfo(skb)->tx_flags |=
+					SKBTX_HW_TSTAMP_PHC;
 				memset(hwtstamps, 0, sizeof(*hwtstamps));
-				hwtstamps->hwtstamp = ns_to_ktime(timestamp);
+				hwtstamps->phc_data = rx_inline;
 			}
 			skb_pull(skb, TSNEP_RX_INLINE_METADATA_SIZE);
 			skb->protocol = eth_type_trans(skb,
diff --git a/drivers/net/ethernet/engleder/tsnep_ptp.c b/drivers/net/ethernet/engleder/tsnep_ptp.c
index eaad453d487e..eb66dfa98242 100644
--- a/drivers/net/ethernet/engleder/tsnep_ptp.c
+++ b/drivers/net/ethernet/engleder/tsnep_ptp.c
@@ -175,6 +175,48 @@ static int tsnep_ptp_settime64(struct ptp_clock_info *ptp,
 	return 0;
 }
 
+static int tsnep_ptp_getcyclesx64(struct ptp_clock_info *ptp,
+				  struct timespec64 *ts,
+				  struct ptp_system_timestamp *sts)
+{
+	struct tsnep_adapter *adapter = container_of(ptp, struct tsnep_adapter,
+						     ptp_clock_info);
+	u32 high_before;
+	u32 low;
+	u32 high;
+	u64 counter;
+
+	/* read high dword twice to detect overrun */
+	high = ioread32(adapter->addr + ECM_COUNTER_HIGH);
+	do {
+		ptp_read_system_prets(sts);
+		low = ioread32(adapter->addr + ECM_COUNTER_LOW);
+		ptp_read_system_postts(sts);
+		high_before = high;
+		high = ioread32(adapter->addr + ECM_COUNTER_HIGH);
+	} while (high != high_before);
+	counter = (((u64)high) << 32) | ((u64)low);
+
+	*ts = ns_to_timespec64(counter);
+
+	return 0;
+}
+
+static ktime_t tsnep_ptp_gettstamp(struct ptp_clock_info *ptp,
+				   const struct skb_shared_hwtstamps *hwtstamps,
+				   bool cycles)
+{
+	struct tsnep_rx_inline *rx_inline = hwtstamps->phc_data;
+	u64 timestamp;
+
+	if (cycles)
+		timestamp = __le64_to_cpu(rx_inline->counter);
+	else
+		timestamp = __le64_to_cpu(rx_inline->timestamp);
+
+	return ns_to_ktime(timestamp);
+}
+
 int tsnep_ptp_init(struct tsnep_adapter *adapter)
 {
 	int retval = 0;
@@ -192,6 +234,8 @@ int tsnep_ptp_init(struct tsnep_adapter *adapter)
 	adapter->ptp_clock_info.adjtime = tsnep_ptp_adjtime;
 	adapter->ptp_clock_info.gettimex64 = tsnep_ptp_gettimex64;
 	adapter->ptp_clock_info.settime64 = tsnep_ptp_settime64;
+	adapter->ptp_clock_info.getcyclesx64 = tsnep_ptp_getcyclesx64;
+	adapter->ptp_clock_info.gettstamp = tsnep_ptp_gettstamp;
 
 	spin_lock_init(&adapter->ptp_lock);
 
-- 
2.20.1


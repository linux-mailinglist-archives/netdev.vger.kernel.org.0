Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BEE6E3B353B
	for <lists+netdev@lfdr.de>; Thu, 24 Jun 2021 20:07:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232519AbhFXSJ6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Jun 2021 14:09:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37708 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231488AbhFXSJy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Jun 2021 14:09:54 -0400
Received: from mail-qk1-x74a.google.com (mail-qk1-x74a.google.com [IPv6:2607:f8b0:4864:20::74a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 53658C061574
        for <netdev@vger.kernel.org>; Thu, 24 Jun 2021 11:07:35 -0700 (PDT)
Received: by mail-qk1-x74a.google.com with SMTP id q207-20020a3743d80000b02903ab34f7ef76so7931159qka.5
        for <netdev@vger.kernel.org>; Thu, 24 Jun 2021 11:07:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=mgFFu+FIcf+/75rn61ODhS0p4WAMzZSYFQOkEwo2yBA=;
        b=EuX+LdYo9Apv09D4Vjc5H5gVSOFcs+SXoNWpXYWYtYbm1Gu4uqlN5xOPUho222ZP8g
         ybLAJ1/MLiXKoq2tVP+SQ6wJDtLk5jTCQl+mhtTtkKUh4dy30JZhqZySlKlDyIsgv3bN
         dy9Nyy38/l88r13onKkcPgf4tCYZ4R0tGJIuQE17euw1pzsMs/gaWyFvayvWjP1UULKf
         6rqGGKQksGDAlhWUOjqBrr2G/nO+DQIMptozOwAtApMe3h6UslJ9Zqo5Uc7voTyTeHFq
         2Kq02L26xib6WIj/vn6OFpvFSXc+WyizzRE/ZL4RYlHNDKXDa1c5JuStGCwDcSydTPzI
         EmmQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=mgFFu+FIcf+/75rn61ODhS0p4WAMzZSYFQOkEwo2yBA=;
        b=MvuXR0IZOy4ncHQ0axznGH2hqKWX9c/34ssRF7SKYG4MbRgNTn5h1G/r1ItzAUwcst
         O39qkqOdTRbbFSfgZw7hqWrz4PGhS9OysNf7zV6TqUSVyYa07Q71bowzHVL4Aa+kTp+h
         l9YHNR2JeCQoZ7PtQC8t3VD0acAZYh1HDuxkTuJ8Z+QLQ+S2fKAyp//oybQxB3wy13bv
         Ow5nNVk6RTpvb9VyupICtNm6gUrdk5S94Q04Ayo6eRqrl17QX4t6mqCgVABwzSqDDO9Q
         rlAfid7jWZvXnAFaWj+ZiJkqPbOZYck5J7Nm7xHReAMvd7ngGNuKl7blKylxk1eU+P9L
         HLZg==
X-Gm-Message-State: AOAM532vrg1mmoKlkqB/XfHprv+nf0Q4U12SgzIRa6t63GRuq0uHwdBX
        9Ogv2LUQErSJlHAVPEB3KEAys5M=
X-Google-Smtp-Source: ABdhPJw3A8ASn1TqGaydT1W41j7ktcQKbB6JZdT+AqqW5o8qansb1Cr9sOjVIE+U97y5BX99H0qt/Rg=
X-Received: from bcf-linux.svl.corp.google.com ([2620:15c:2c4:1:cb6c:4753:6df0:b898])
 (user=bcf job=sendgmr) by 2002:ad4:4c43:: with SMTP id cs3mr6800833qvb.27.1624558054442;
 Thu, 24 Jun 2021 11:07:34 -0700 (PDT)
Date:   Thu, 24 Jun 2021 11:06:18 -0700
In-Reply-To: <20210624180632.3659809-1-bcf@google.com>
Message-Id: <20210624180632.3659809-3-bcf@google.com>
Mime-Version: 1.0
References: <20210624180632.3659809-1-bcf@google.com>
X-Mailer: git-send-email 2.32.0.93.g670b81a890-goog
Subject: [PATCH net-next 02/16] gve: Move some static functions to a common file
From:   Bailey Forrest <bcf@google.com>
To:     Bailey Forrest <bcf@google.com>,
        "David S . Miller" <davem@davemloft.net>
Cc:     netdev@vger.kernel.org, Willem de Bruijn <willemb@google.com>,
        Catherine Sullivan <csully@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

These functions will be shared by the GQI and DQO variants of the GVNIC
driver as of follow-up patches in this series.

Signed-off-by: Bailey Forrest <bcf@google.com>
Reviewed-by: Willem de Bruijn <willemb@google.com>
Reviewed-by: Catherine Sullivan <csully@google.com>
---
 drivers/net/ethernet/google/gve/Makefile    |  2 +-
 drivers/net/ethernet/google/gve/gve_rx.c    | 42 +------------
 drivers/net/ethernet/google/gve/gve_tx.c    | 21 +------
 drivers/net/ethernet/google/gve/gve_utils.c | 65 +++++++++++++++++++++
 drivers/net/ethernet/google/gve/gve_utils.h | 24 ++++++++
 5 files changed, 94 insertions(+), 60 deletions(-)
 create mode 100644 drivers/net/ethernet/google/gve/gve_utils.c
 create mode 100644 drivers/net/ethernet/google/gve/gve_utils.h

diff --git a/drivers/net/ethernet/google/gve/Makefile b/drivers/net/ethernet/google/gve/Makefile
index 3354ce40eb97..0143f4471e42 100644
--- a/drivers/net/ethernet/google/gve/Makefile
+++ b/drivers/net/ethernet/google/gve/Makefile
@@ -1,4 +1,4 @@
 # Makefile for the Google virtual Ethernet (gve) driver
 
 obj-$(CONFIG_GVE) += gve.o
-gve-objs := gve_main.o gve_tx.o gve_rx.o gve_ethtool.o gve_adminq.o
+gve-objs := gve_main.o gve_tx.o gve_rx.o gve_ethtool.o gve_adminq.o gve_utils.o
diff --git a/drivers/net/ethernet/google/gve/gve_rx.c b/drivers/net/ethernet/google/gve/gve_rx.c
index bf123fe524c4..2cfedf4bf5d8 100644
--- a/drivers/net/ethernet/google/gve/gve_rx.c
+++ b/drivers/net/ethernet/google/gve/gve_rx.c
@@ -1,21 +1,14 @@
 // SPDX-License-Identifier: (GPL-2.0 OR MIT)
 /* Google virtual Ethernet (gve) driver
  *
- * Copyright (C) 2015-2019 Google, Inc.
+ * Copyright (C) 2015-2021 Google, Inc.
  */
 
 #include "gve.h"
 #include "gve_adminq.h"
+#include "gve_utils.h"
 #include <linux/etherdevice.h>
 
-static void gve_rx_remove_from_block(struct gve_priv *priv, int queue_idx)
-{
-	struct gve_notify_block *block =
-			&priv->ntfy_blocks[gve_rx_idx_to_ntfy(priv, queue_idx)];
-
-	block->rx = NULL;
-}
-
 static void gve_rx_free_buffer(struct device *dev,
 			       struct gve_rx_slot_page_info *page_info,
 			       union gve_rx_data_slot *data_slot)
@@ -137,16 +130,6 @@ static int gve_prefill_rx_pages(struct gve_rx_ring *rx)
 	return err;
 }
 
-static void gve_rx_add_to_block(struct gve_priv *priv, int queue_idx)
-{
-	u32 ntfy_idx = gve_rx_idx_to_ntfy(priv, queue_idx);
-	struct gve_notify_block *block = &priv->ntfy_blocks[ntfy_idx];
-	struct gve_rx_ring *rx = &priv->rx[queue_idx];
-
-	block->rx = rx;
-	rx->ntfy_id = ntfy_idx;
-}
-
 static int gve_rx_alloc_ring(struct gve_priv *priv, int idx)
 {
 	struct gve_rx_ring *rx = &priv->rx[idx];
@@ -279,27 +262,6 @@ static enum pkt_hash_types gve_rss_type(__be16 pkt_flags)
 	return PKT_HASH_TYPE_L2;
 }
 
-static struct sk_buff *gve_rx_copy(struct net_device *dev,
-				   struct napi_struct *napi,
-				   struct gve_rx_slot_page_info *page_info,
-				   u16 len)
-{
-	struct sk_buff *skb = napi_alloc_skb(napi, len);
-	void *va = page_info->page_address + GVE_RX_PAD +
-		   (page_info->page_offset ? PAGE_SIZE / 2 : 0);
-
-	if (unlikely(!skb))
-		return NULL;
-
-	__skb_put(skb, len);
-
-	skb_copy_to_linear_data(skb, va, len);
-
-	skb->protocol = eth_type_trans(skb, dev);
-
-	return skb;
-}
-
 static struct sk_buff *gve_rx_add_frags(struct napi_struct *napi,
 					struct gve_rx_slot_page_info *page_info,
 					u16 len)
diff --git a/drivers/net/ethernet/google/gve/gve_tx.c b/drivers/net/ethernet/google/gve/gve_tx.c
index 3e04a3973d68..6866f6e0139d 100644
--- a/drivers/net/ethernet/google/gve/gve_tx.c
+++ b/drivers/net/ethernet/google/gve/gve_tx.c
@@ -1,11 +1,12 @@
 // SPDX-License-Identifier: (GPL-2.0 OR MIT)
 /* Google virtual Ethernet (gve) driver
  *
- * Copyright (C) 2015-2019 Google, Inc.
+ * Copyright (C) 2015-2021 Google, Inc.
  */
 
 #include "gve.h"
 #include "gve_adminq.h"
+#include "gve_utils.h"
 #include <linux/ip.h>
 #include <linux/tcp.h>
 #include <linux/vmalloc.h>
@@ -131,14 +132,6 @@ static void gve_tx_free_fifo(struct gve_tx_fifo *fifo, size_t bytes)
 	atomic_add(bytes, &fifo->available);
 }
 
-static void gve_tx_remove_from_block(struct gve_priv *priv, int queue_idx)
-{
-	struct gve_notify_block *block =
-			&priv->ntfy_blocks[gve_tx_idx_to_ntfy(priv, queue_idx)];
-
-	block->tx = NULL;
-}
-
 static int gve_clean_tx_done(struct gve_priv *priv, struct gve_tx_ring *tx,
 			     u32 to_do, bool try_to_wake);
 
@@ -174,16 +167,6 @@ static void gve_tx_free_ring(struct gve_priv *priv, int idx)
 	netif_dbg(priv, drv, priv->dev, "freed tx queue %d\n", idx);
 }
 
-static void gve_tx_add_to_block(struct gve_priv *priv, int queue_idx)
-{
-	int ntfy_idx = gve_tx_idx_to_ntfy(priv, queue_idx);
-	struct gve_notify_block *block = &priv->ntfy_blocks[ntfy_idx];
-	struct gve_tx_ring *tx = &priv->tx[queue_idx];
-
-	block->tx = tx;
-	tx->ntfy_id = ntfy_idx;
-}
-
 static int gve_tx_alloc_ring(struct gve_priv *priv, int idx)
 {
 	struct gve_tx_ring *tx = &priv->tx[idx];
diff --git a/drivers/net/ethernet/google/gve/gve_utils.c b/drivers/net/ethernet/google/gve/gve_utils.c
new file mode 100644
index 000000000000..2bfff0f75519
--- /dev/null
+++ b/drivers/net/ethernet/google/gve/gve_utils.c
@@ -0,0 +1,65 @@
+// SPDX-License-Identifier: (GPL-2.0 OR MIT)
+/* Google virtual Ethernet (gve) driver
+ *
+ * Copyright (C) 2015-2021 Google, Inc.
+ */
+
+#include "gve.h"
+#include "gve_adminq.h"
+#include "gve_utils.h"
+
+void gve_tx_remove_from_block(struct gve_priv *priv, int queue_idx)
+{
+	struct gve_notify_block *block =
+			&priv->ntfy_blocks[gve_tx_idx_to_ntfy(priv, queue_idx)];
+
+	block->tx = NULL;
+}
+
+void gve_tx_add_to_block(struct gve_priv *priv, int queue_idx)
+{
+	int ntfy_idx = gve_tx_idx_to_ntfy(priv, queue_idx);
+	struct gve_notify_block *block = &priv->ntfy_blocks[ntfy_idx];
+	struct gve_tx_ring *tx = &priv->tx[queue_idx];
+
+	block->tx = tx;
+	tx->ntfy_id = ntfy_idx;
+}
+
+void gve_rx_remove_from_block(struct gve_priv *priv, int queue_idx)
+{
+	struct gve_notify_block *block =
+			&priv->ntfy_blocks[gve_rx_idx_to_ntfy(priv, queue_idx)];
+
+	block->rx = NULL;
+}
+
+void gve_rx_add_to_block(struct gve_priv *priv, int queue_idx)
+{
+	u32 ntfy_idx = gve_rx_idx_to_ntfy(priv, queue_idx);
+	struct gve_notify_block *block = &priv->ntfy_blocks[ntfy_idx];
+	struct gve_rx_ring *rx = &priv->rx[queue_idx];
+
+	block->rx = rx;
+	rx->ntfy_id = ntfy_idx;
+}
+
+struct sk_buff *gve_rx_copy(struct net_device *dev, struct napi_struct *napi,
+			    struct gve_rx_slot_page_info *page_info, u16 len)
+{
+	struct sk_buff *skb = napi_alloc_skb(napi, len);
+	void *va = page_info->page_address + GVE_RX_PAD +
+		   (page_info->page_offset ? PAGE_SIZE / 2 : 0);
+
+	if (unlikely(!skb))
+		return NULL;
+
+	__skb_put(skb, len);
+
+	skb_copy_to_linear_data(skb, va, len);
+
+	skb->protocol = eth_type_trans(skb, dev);
+
+	return skb;
+}
+
diff --git a/drivers/net/ethernet/google/gve/gve_utils.h b/drivers/net/ethernet/google/gve/gve_utils.h
new file mode 100644
index 000000000000..76540374a083
--- /dev/null
+++ b/drivers/net/ethernet/google/gve/gve_utils.h
@@ -0,0 +1,24 @@
+/* SPDX-License-Identifier: (GPL-2.0 OR MIT)
+ * Google virtual Ethernet (gve) driver
+ *
+ * Copyright (C) 2015-2021 Google, Inc.
+ */
+
+#ifndef _GVE_UTILS_H
+#define _GVE_UTILS_H
+
+#include <linux/etherdevice.h>
+
+#include "gve.h"
+
+void gve_tx_remove_from_block(struct gve_priv *priv, int queue_idx);
+void gve_tx_add_to_block(struct gve_priv *priv, int queue_idx);
+
+void gve_rx_remove_from_block(struct gve_priv *priv, int queue_idx);
+void gve_rx_add_to_block(struct gve_priv *priv, int queue_idx);
+
+struct sk_buff *gve_rx_copy(struct net_device *dev, struct napi_struct *napi,
+			    struct gve_rx_slot_page_info *page_info, u16 len);
+
+#endif /* _GVE_UTILS_H */
+
-- 
2.32.0.288.g62a8d224e6-goog


Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 883BD549EA0
	for <lists+netdev@lfdr.de>; Mon, 13 Jun 2022 22:10:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349491AbiFMUKT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Jun 2022 16:10:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47146 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349092AbiFMUKE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Jun 2022 16:10:04 -0400
Received: from mail-lj1-x22d.google.com (mail-lj1-x22d.google.com [IPv6:2a00:1450:4864:20::22d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8E9E527B0F;
        Mon, 13 Jun 2022 11:44:12 -0700 (PDT)
Received: by mail-lj1-x22d.google.com with SMTP id g25so7200065ljm.2;
        Mon, 13 Jun 2022 11:44:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=VqO5G8hk6yhioyao4IlSt5H4ZBoh/GhshlNDoSDXcHI=;
        b=ooWtNh0joNNDvhVMDEBoyVh+mVbiOboztgnSdtVXz8PNPmr9qFjtLJMps/xhIcVvGr
         WFUk0waE1laiRv4UwjFk3wD+dTNqxddGZjpkPVfUVS63jCgi08bUEUPFRGV9QQ6EmzJq
         y6e4sB59cLFryuyHSHXA0+gxVMKSn9P+4oBce7wuEI8VNHiu0nuE25//ZEu3N030nU8/
         l0LJJdH5i8F/tI0nNS/lH8hIxFGFz15t6ch1Ko4gXRRWlLhRoVAQje/8skCpTS3KyXEB
         Nx+pNoHl2MFQuqRmQZRjq44XwIanpJslp3TAkFhWirFFNOmcMxeTcE2+7ezf5y7XAK63
         4W3g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=VqO5G8hk6yhioyao4IlSt5H4ZBoh/GhshlNDoSDXcHI=;
        b=dLXM/uLI0lzpIEvtWR517QikU7wWQlIBX0AlFyaUjrYP/N1voDrgdNRhywejf/XNOx
         LRGkpV0vTPDzuHb3sB8GkheX65urcPCimJ114wNTHYADgIe/29uO/Gc2NOXqB8edWWbw
         OAcTe8zdzz2SuzsSC9t2OPwAP+7nKtNhm0OPwKtZ68wkd86WKSf/XRVuWhVgHQMFx9xa
         JjRd2nMg3FpB7Aj+yvq2xXntxZryuxcgdXnimPAfU64lhJ+AZNxWeJxs7q4uRHvjJTIG
         dRTHv5lM8TwmeDikLTMMvdzetwy9gAy3WEEkG3CMwCJLeaGJ+oLkrudisKMaU3VGqBaQ
         55Iw==
X-Gm-Message-State: AJIora8fu8AIqY0Ob6aZn5J8WxF8aoSBa17YTYvmemtMXhxJFotL/BHZ
        TpbUBm/fqwST3VsT3Qhsx1ZoqiWrK97klg==
X-Google-Smtp-Source: AGRyM1tOuSWMIusVj6mJP+VBio3OBudn1pRbolu79qYknI0f2/ofYU+6Kvf0i2ar33GOqGC7WRrlMw==
X-Received: by 2002:a2e:95cc:0:b0:255:8325:9920 with SMTP id y12-20020a2e95cc000000b0025583259920mr471242ljh.362.1655145850832;
        Mon, 13 Jun 2022 11:44:10 -0700 (PDT)
Received: from localhost.localdomain ([94.103.229.27])
        by smtp.gmail.com with ESMTPSA id s2-20020a2eb8c2000000b0024f3d1dae9csm1071667ljp.36.2022.06.13.11.44.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 Jun 2022 11:44:09 -0700 (PDT)
From:   Pavel Skripkin <paskripkin@gmail.com>
To:     toke@toke.dk, kvalo@kernel.org, davem@davemloft.net,
        kuba@kernel.org
Cc:     linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Pavel Skripkin <paskripkin@gmail.com>,
        Jeff Johnson <quic_jjohnson@quicinc.com>
Subject: [PATCH v6 2/2] ath9k: htc: clean up statistics macros
Date:   Mon, 13 Jun 2022 21:44:07 +0300
Message-Id: <ebb2306d06a496cd1b032155ae52fdc5fa8cc2c5.1655145743.git.paskripkin@gmail.com>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <d57bbedc857950659bfacac0ab48790c1eda00c8.1655145743.git.paskripkin@gmail.com>
References: <d57bbedc857950659bfacac0ab48790c1eda00c8.1655145743.git.paskripkin@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

I've changed *STAT_* macros a bit in previous patch and I seems like
they become really unreadable. Align these macros definitions to make
code cleaner and fix folllowing checkpatch warning

ERROR: Macros with complex values should be enclosed in parentheses

Also, statistics macros now accept an hif_dev as argument, since
macros that depend on having a local variable with a magic name
don't abide by the coding style.

No functional change

Suggested-by: Jeff Johnson <quic_jjohnson@quicinc.com>
Signed-off-by: Pavel Skripkin <paskripkin@gmail.com>
---

Changes since v4:
	- Fixed build error caused by wrong variable name
	  passed to newly added macros

Changes since v4:
	- Rebased on top of ath-next branch

Changes since v3:
	- Added additional clean up related to relying on magical
	  name from outside of the macro

Changes since v2:
	- My send-email script forgot, that mailing lists exist.
	  Added back all related lists
	- Fixed checkpatch warning

Changes since v1:
	- Added this patch

---
 drivers/net/wireless/ath/ath9k/hif_usb.c      | 26 +++++++--------
 drivers/net/wireless/ath/ath9k/htc.h          | 32 +++++++++++--------
 drivers/net/wireless/ath/ath9k/htc_drv_txrx.c | 10 +++---
 3 files changed, 36 insertions(+), 32 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/hif_usb.c b/drivers/net/wireless/ath/ath9k/hif_usb.c
index 518deb509..4d9002a9d 100644
--- a/drivers/net/wireless/ath/ath9k/hif_usb.c
+++ b/drivers/net/wireless/ath/ath9k/hif_usb.c
@@ -244,11 +244,11 @@ static inline void ath9k_skb_queue_complete(struct hif_device_usb *hif_dev,
 		ath9k_htc_txcompletion_cb(hif_dev->htc_handle,
 					  skb, txok);
 		if (txok) {
-			TX_STAT_INC(skb_success);
-			TX_STAT_ADD(skb_success_bytes, ln);
+			TX_STAT_INC(hif_dev, skb_success);
+			TX_STAT_ADD(hif_dev, skb_success_bytes, ln);
 		}
 		else
-			TX_STAT_INC(skb_failed);
+			TX_STAT_INC(hif_dev, skb_failed);
 	}
 }
 
@@ -302,7 +302,7 @@ static void hif_usb_tx_cb(struct urb *urb)
 	hif_dev->tx.tx_buf_cnt++;
 	if (!(hif_dev->tx.flags & HIF_USB_TX_STOP))
 		__hif_usb_tx(hif_dev); /* Check for pending SKBs */
-	TX_STAT_INC(buf_completed);
+	TX_STAT_INC(hif_dev, buf_completed);
 	spin_unlock(&hif_dev->tx.tx_lock);
 }
 
@@ -353,7 +353,7 @@ static int __hif_usb_tx(struct hif_device_usb *hif_dev)
 			tx_buf->len += tx_buf->offset;
 
 		__skb_queue_tail(&tx_buf->skb_queue, nskb);
-		TX_STAT_INC(skb_queued);
+		TX_STAT_INC(hif_dev, skb_queued);
 	}
 
 	usb_fill_bulk_urb(tx_buf->urb, hif_dev->udev,
@@ -369,7 +369,7 @@ static int __hif_usb_tx(struct hif_device_usb *hif_dev)
 		list_move_tail(&tx_buf->list, &hif_dev->tx.tx_buf);
 		hif_dev->tx.tx_buf_cnt++;
 	} else {
-		TX_STAT_INC(buf_queued);
+		TX_STAT_INC(hif_dev, buf_queued);
 	}
 
 	return ret;
@@ -514,7 +514,7 @@ static void hif_usb_sta_drain(void *hif_handle, u8 idx)
 			ath9k_htc_txcompletion_cb(hif_dev->htc_handle,
 						  skb, false);
 			hif_dev->tx.tx_skb_cnt--;
-			TX_STAT_INC(skb_failed);
+			TX_STAT_INC(hif_dev, skb_failed);
 		}
 	}
 
@@ -585,14 +585,14 @@ static void ath9k_hif_usb_rx_stream(struct hif_device_usb *hif_dev,
 		pkt_tag = get_unaligned_le16(ptr + index + 2);
 
 		if (pkt_tag != ATH_USB_RX_STREAM_MODE_TAG) {
-			RX_STAT_INC(skb_dropped);
+			RX_STAT_INC(hif_dev, skb_dropped);
 			return;
 		}
 
 		if (pkt_len > 2 * MAX_RX_BUF_SIZE) {
 			dev_err(&hif_dev->udev->dev,
 				"ath9k_htc: invalid pkt_len (%x)\n", pkt_len);
-			RX_STAT_INC(skb_dropped);
+			RX_STAT_INC(hif_dev, skb_dropped);
 			return;
 		}
 
@@ -618,7 +618,7 @@ static void ath9k_hif_usb_rx_stream(struct hif_device_usb *hif_dev,
 				goto err;
 			}
 			skb_reserve(nskb, 32);
-			RX_STAT_INC(skb_allocated);
+			RX_STAT_INC(hif_dev, skb_allocated);
 
 			memcpy(nskb->data, &(skb->data[chk_idx+4]),
 			       hif_dev->rx_transfer_len);
@@ -639,7 +639,7 @@ static void ath9k_hif_usb_rx_stream(struct hif_device_usb *hif_dev,
 				goto err;
 			}
 			skb_reserve(nskb, 32);
-			RX_STAT_INC(skb_allocated);
+			RX_STAT_INC(hif_dev, skb_allocated);
 
 			memcpy(nskb->data, &(skb->data[chk_idx+4]), pkt_len);
 			skb_put(nskb, pkt_len);
@@ -649,10 +649,10 @@ static void ath9k_hif_usb_rx_stream(struct hif_device_usb *hif_dev,
 
 err:
 	for (i = 0; i < pool_index; i++) {
-		RX_STAT_ADD(skb_completed_bytes, skb_pool[i]->len);
+		RX_STAT_ADD(hif_dev, skb_completed_bytes, skb_pool[i]->len);
 		ath9k_htc_rx_msg(hif_dev->htc_handle, skb_pool[i],
 				 skb_pool[i]->len, USB_WLAN_RX_PIPE);
-		RX_STAT_INC(skb_completed);
+		RX_STAT_INC(hif_dev, skb_completed);
 	}
 }
 
diff --git a/drivers/net/wireless/ath/ath9k/htc.h b/drivers/net/wireless/ath/ath9k/htc.h
index e3d546ef7..30f0765fb 100644
--- a/drivers/net/wireless/ath/ath9k/htc.h
+++ b/drivers/net/wireless/ath/ath9k/htc.h
@@ -327,14 +327,18 @@ static inline struct ath9k_htc_tx_ctl *HTC_SKB_CB(struct sk_buff *skb)
 }
 
 #ifdef CONFIG_ATH9K_HTC_DEBUGFS
-#define __STAT_SAFE(expr) (hif_dev->htc_handle->drv_priv ? (expr) : 0)
-#define TX_STAT_INC(c) __STAT_SAFE(hif_dev->htc_handle->drv_priv->debug.tx_stats.c++)
-#define TX_STAT_ADD(c, a) __STAT_SAFE(hif_dev->htc_handle->drv_priv->debug.tx_stats.c += a)
-#define RX_STAT_INC(c) __STAT_SAFE(hif_dev->htc_handle->drv_priv->debug.skbrx_stats.c++)
-#define RX_STAT_ADD(c, a) __STAT_SAFE(hif_dev->htc_handle->drv_priv->debug.skbrx_stats.c += a)
-#define CAB_STAT_INC   priv->debug.tx_stats.cab_queued++
-
-#define TX_QSTAT_INC(q) (priv->debug.tx_stats.queue_stats[q]++)
+#define __STAT_SAFE(hif_dev, expr)	((hif_dev)->htc_handle->drv_priv ? (expr) : 0)
+#define CAB_STAT_INC(priv)		((priv)->debug.tx_stats.cab_queued++)
+#define TX_QSTAT_INC(priv, q)		((priv)->debug.tx_stats.queue_stats[q]++)
+
+#define TX_STAT_INC(hif_dev, c) \
+		__STAT_SAFE((hif_dev), (hif_dev)->htc_handle->drv_priv->debug.tx_stats.c++)
+#define TX_STAT_ADD(hif_dev, c, a) \
+		__STAT_SAFE((hif_dev), (hif_dev)->htc_handle->drv_priv->debug.tx_stats.c += a)
+#define RX_STAT_INC(hif_dev, c) \
+		__STAT_SAFE((hif_dev), (hif_dev)->htc_handle->drv_priv->debug.skbrx_stats.c++)
+#define RX_STAT_ADD(hif_dev, c, a) \
+		__STAT_SAFE((hif_dev), (hif_dev)->htc_handle->drv_priv->debug.skbrx_stats.c += a)
 
 void ath9k_htc_err_stat_rx(struct ath9k_htc_priv *priv,
 			   struct ath_rx_status *rs);
@@ -374,13 +378,13 @@ void ath9k_htc_get_et_stats(struct ieee80211_hw *hw,
 			    struct ethtool_stats *stats, u64 *data);
 #else
 
-#define TX_STAT_INC(c) do { } while (0)
-#define TX_STAT_ADD(c, a) do { } while (0)
-#define RX_STAT_INC(c) do { } while (0)
-#define RX_STAT_ADD(c, a) do { } while (0)
-#define CAB_STAT_INC   do { } while (0)
+#define TX_STAT_INC(hif_dev, c)
+#define TX_STAT_ADD(hif_dev, c, a)
+#define RX_STAT_INC(hif_dev, c)
+#define RX_STAT_ADD(hif_dev, c, a)
 
-#define TX_QSTAT_INC(c) do { } while (0)
+#define CAB_STAT_INC(priv)
+#define TX_QSTAT_INC(priv, c)
 
 static inline void ath9k_htc_err_stat_rx(struct ath9k_htc_priv *priv,
 					 struct ath_rx_status *rs)
diff --git a/drivers/net/wireless/ath/ath9k/htc_drv_txrx.c b/drivers/net/wireless/ath/ath9k/htc_drv_txrx.c
index a23eaca03..672789e3c 100644
--- a/drivers/net/wireless/ath/ath9k/htc_drv_txrx.c
+++ b/drivers/net/wireless/ath/ath9k/htc_drv_txrx.c
@@ -106,20 +106,20 @@ static inline enum htc_endpoint_id get_htc_epid(struct ath9k_htc_priv *priv,
 
 	switch (qnum) {
 	case 0:
-		TX_QSTAT_INC(IEEE80211_AC_VO);
+		TX_QSTAT_INC(priv, IEEE80211_AC_VO);
 		epid = priv->data_vo_ep;
 		break;
 	case 1:
-		TX_QSTAT_INC(IEEE80211_AC_VI);
+		TX_QSTAT_INC(priv, IEEE80211_AC_VI);
 		epid = priv->data_vi_ep;
 		break;
 	case 2:
-		TX_QSTAT_INC(IEEE80211_AC_BE);
+		TX_QSTAT_INC(priv, IEEE80211_AC_BE);
 		epid = priv->data_be_ep;
 		break;
 	case 3:
 	default:
-		TX_QSTAT_INC(IEEE80211_AC_BK);
+		TX_QSTAT_INC(priv, IEEE80211_AC_BK);
 		epid = priv->data_bk_ep;
 		break;
 	}
@@ -328,7 +328,7 @@ static void ath9k_htc_tx_data(struct ath9k_htc_priv *priv,
 	memcpy(tx_fhdr, (u8 *) &tx_hdr, sizeof(tx_hdr));
 
 	if (is_cab) {
-		CAB_STAT_INC;
+		CAB_STAT_INC(priv);
 		tx_ctl->epid = priv->cab_ep;
 		return;
 	}
-- 
2.36.1


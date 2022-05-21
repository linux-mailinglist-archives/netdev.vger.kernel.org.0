Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A577C52FF91
	for <lists+netdev@lfdr.de>; Sat, 21 May 2022 23:28:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346546AbiEUV2W (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 21 May 2022 17:28:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56732 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229941AbiEUV2N (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 21 May 2022 17:28:13 -0400
Received: from mail-lf1-x135.google.com (mail-lf1-x135.google.com [IPv6:2a00:1450:4864:20::135])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C885C3E0D2;
        Sat, 21 May 2022 14:28:11 -0700 (PDT)
Received: by mail-lf1-x135.google.com with SMTP id t25so19679997lfg.7;
        Sat, 21 May 2022 14:28:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=HVs/1m1zfJ0z0GfA6521SZbt9h8+pc7g6retbmFBtRU=;
        b=EicsP02tuZWncMaI6gu/EacdnITe7jssJNRlBCtzHHdEyIiUYUE4OEowRYC7NbRFeh
         vthvVNcqpjKJF4e446HEMWQvbz22lCfT9xBRGrtxKx03sue/sx/HKlxdnxId8BpISnK4
         t4ddwCFeVqMMoBNfzabnPpBWiFhBFCSAx3bxNaRWRDDruVqHr1kQXlrJzzUEdt+uzFNq
         krrBnho/fMH9/jH21xDbHJBzJw5uuDk1zxRr7QLKAbc/47X/aBrB3/65YRVJAODkoPoJ
         gjjViA3hSnvyV+VTsF1B7Ie3RCaqphFEgJ4/LJPAPShA/AAkeBGQWQLDcE79btz2UIoD
         goqQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=HVs/1m1zfJ0z0GfA6521SZbt9h8+pc7g6retbmFBtRU=;
        b=Z60ASJ46R2XzVT/Bz7Sf81xDsW6B9bG8jlohldVmzOcx5APeJ8i/BTPqpl3BJgFvMK
         ccIKhm+uWd63QfSPn0rYAh0Ywq4qCRlvq6f7y4trbqM2mQGtVZVMU/dFBUJ17qX0Wlr0
         oKw1AotXWi7skofyj0WLHFoFNOx5FI7Cn8C7RF4AttJ+4bsxOYGw3RT7MTixo5CqLoXB
         H+Zt3dUz5KScfmi/Ajw1uxFemMIZ+1xAGx/qxng7797w+5XWXgl2+81nTGYl+Rj5pCMG
         j2CRIFrDlqwXDrOW3r5rIpLGOC5wOorf4viyrzKW0lBCkdlaEj2iqaDAXeuZ6Uv+dYKs
         C/pw==
X-Gm-Message-State: AOAM533/b6aIA+ZFUqxPQ18AblxGDfVlGe465CO1qsBitj9YVWoTo/G9
        LHN7lm/ZaNcDFms3f7wvLI8=
X-Google-Smtp-Source: ABdhPJwR+vf0JIlO7yHeunMWGhWLPPv5OrQoOidS9TRGNHztpz0EdEzflg8fL0+tqdVwpLXHbwXNcg==
X-Received: by 2002:a05:6512:e90:b0:477:cc44:9813 with SMTP id bi16-20020a0565120e9000b00477cc449813mr9087082lfb.226.1653168490121;
        Sat, 21 May 2022 14:28:10 -0700 (PDT)
Received: from localhost.localdomain ([46.235.67.4])
        by smtp.gmail.com with ESMTPSA id m25-20020ac24299000000b0047255d2117csm1195276lfh.171.2022.05.21.14.28.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 21 May 2022 14:28:09 -0700 (PDT)
From:   Pavel Skripkin <paskripkin@gmail.com>
To:     toke@toke.dk, kvalo@kernel.org, davem@davemloft.net,
        kuba@kernel.org, pabeni@redhat.com, senthilkumar@atheros.com
Cc:     linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Pavel Skripkin <paskripkin@gmail.com>,
        Jeff Johnson <quic_jjohnson@quicinc.com>
Subject: [PATCH v5 2/2] ath9k: htc: clean up statistics macros
Date:   Sun, 22 May 2022 00:28:07 +0300
Message-Id: <7bb006bb88e280c596d0e86ece7d251a21b8ed1f.1653168225.git.paskripkin@gmail.com>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <961b028f073d0d5541de66c00a517495431981f9.1653168225.git.paskripkin@gmail.com>
References: <961b028f073d0d5541de66c00a517495431981f9.1653168225.git.paskripkin@gmail.com>
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
index 518deb5098a2..7f220a245985 100644
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
+		TX_STAT_INC(hiv_dev, buf_queued);
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
index e3d546ef71dd..30f0765fb9fd 100644
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
index a23eaca0326d..672789e3c55d 100644
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


Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 194FD4ACA53
	for <lists+netdev@lfdr.de>; Mon,  7 Feb 2022 21:25:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237251AbiBGUZa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Feb 2022 15:25:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49572 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234543AbiBGUYc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Feb 2022 15:24:32 -0500
Received: from mail-lf1-x12f.google.com (mail-lf1-x12f.google.com [IPv6:2a00:1450:4864:20::12f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1AA3DC0401DA;
        Mon,  7 Feb 2022 12:24:31 -0800 (PST)
Received: by mail-lf1-x12f.google.com with SMTP id z4so14391444lfg.5;
        Mon, 07 Feb 2022 12:24:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=gItGRtBFmuDCuiCd8LZimI8CT8KycScnCN76eWqmpsI=;
        b=EvGmrX7VLUplcnT7jV/mKf7O+C+eUWXMUppPpYkx6X9DhLk8AvGTjImHanjDBoSfid
         p+e+YTlRflPL2Ke4p+llrqzuoi+T9WduxnN4OGM6oMSCpsVjeJ9O7fZl8wqmLC7LBbYm
         Lcnl9+KHWE/ges8niXD9d1f2MdpOQ89TbyZVvnUk+yvUZzfyPqnIrX9SFEdoC7Q5HR/G
         jZMVmTDWmlvagkAEzMUAUzGHXSJ6ljsOL3VfU1f1tZK9bfUFP5YPVV0UOJOy6vu241i/
         AJ+LjR7N37F6Zvsuc/Xfcf2LKt1YDeC+cYmpFjapst9HF1Ag1KTjQRJQugX45T/JUfjf
         noPw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=gItGRtBFmuDCuiCd8LZimI8CT8KycScnCN76eWqmpsI=;
        b=eMB3YV6/oC9E+9DhfI8U3BY4t1gXAnaEp7iRYeUHXCIuPyJe5vxQrdWZ5hxl5/D9dM
         ilL2o6A7b/yOAdfBGYg1V9tdj6p7QCQvbqhlk2jgRehWWRw2oHM/YQ/D+8UWmzG/820M
         ObTbrqCDci8aHltmBb4upgCl14NFHJBGhwGtTnC347+OCkWeZPAL+RHsxNfz16qzX8vC
         R8Q0juoiRKbQe3I9x0DFu7zg5bpkmi/QkOdti5EsJxu815TnLKTE3sxbgH6RigsEL0ev
         ySa2PBH+BMcIeOrdjZBquivmsH9zwnIT+DzjkhJ1kLLZBBrjhE/HOnXzyTOvk11UpigF
         mrcw==
X-Gm-Message-State: AOAM531OxE4SopaEjVezmel34xcXD8ckR/Zem1nb68iYOcR6pAa03EVb
        5cl/PCsc2/XNO7rNj5PnVHEaoQbhZrncEg==
X-Google-Smtp-Source: ABdhPJz7L7ywOhhkq7VsLw/TZyIlGHs1A43QzxAPf71xzK7cAl3+cKVgqJvVR4mIAjJjhLs6FT83Fg==
X-Received: by 2002:a05:6512:234a:: with SMTP id p10mr767844lfu.15.1644265469479;
        Mon, 07 Feb 2022 12:24:29 -0800 (PST)
Received: from localhost.localdomain ([94.103.224.201])
        by smtp.gmail.com with ESMTPSA id m7sm1759127ljh.47.2022.02.07.12.24.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 07 Feb 2022 12:24:28 -0800 (PST)
From:   Pavel Skripkin <paskripkin@gmail.com>
To:     ath9k-devel@qca.qualcomm.com, kvalo@kernel.org,
        davem@davemloft.net, kuba@kernel.org, toke@toke.dk,
        linville@tuxdriver.com
Cc:     linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Pavel Skripkin <paskripkin@gmail.com>
Subject: [PATCH v3 2/2] ath9k: htc: clean up *STAT_* macros
Date:   Mon,  7 Feb 2022 23:24:25 +0300
Message-Id: <28c83b99b8fea0115ad7fbda7cc93a86468ec50d.1644265120.git.paskripkin@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <80962aae265995d1cdb724f5362c556d494c7566.1644265120.git.paskripkin@gmail.com>
References: <80962aae265995d1cdb724f5362c556d494c7566.1644265120.git.paskripkin@gmail.com>
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
code cleaner.

Also fixed following checkpatch warning

ERROR: Macros with complex values should be enclosed in parentheses

Signed-off-by: Pavel Skripkin <paskripkin@gmail.com>
---

Changes since v2:
	- My send-email script forgot, that mailing lists exist.
	  Added back all related lists
	- Fixed checkpatch warning

Changes since v1:
	- Added this patch

---
 drivers/net/wireless/ath/ath9k/htc.h | 16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/htc.h b/drivers/net/wireless/ath/ath9k/htc.h
index 141642e5e00d..b4755e21a501 100644
--- a/drivers/net/wireless/ath/ath9k/htc.h
+++ b/drivers/net/wireless/ath/ath9k/htc.h
@@ -327,14 +327,14 @@ static inline struct ath9k_htc_tx_ctl *HTC_SKB_CB(struct sk_buff *skb)
 }
 
 #ifdef CONFIG_ATH9K_HTC_DEBUGFS
-#define __STAT_SAVE(expr) (hif_dev->htc_handle->drv_priv ? (expr) : 0)
-#define TX_STAT_INC(c) __STAT_SAVE(hif_dev->htc_handle->drv_priv->debug.tx_stats.c++)
-#define TX_STAT_ADD(c, a) __STAT_SAVE(hif_dev->htc_handle->drv_priv->debug.tx_stats.c += a)
-#define RX_STAT_INC(c) __STAT_SAVE(hif_dev->htc_handle->drv_priv->debug.skbrx_stats.c++)
-#define RX_STAT_ADD(c, a) __STAT_SAVE(hif_dev->htc_handle->drv_priv->debug.skbrx_stats.c += a)
-#define CAB_STAT_INC   priv->debug.tx_stats.cab_queued++
-
-#define TX_QSTAT_INC(q) (priv->debug.tx_stats.queue_stats[q]++)
+#define __STAT_SAVE(expr)	(hif_dev->htc_handle->drv_priv ? (expr) : 0)
+#define TX_STAT_INC(c)		__STAT_SAVE(hif_dev->htc_handle->drv_priv->debug.tx_stats.c++)
+#define TX_STAT_ADD(c, a)	__STAT_SAVE(hif_dev->htc_handle->drv_priv->debug.tx_stats.c += a)
+#define RX_STAT_INC(c)		__STAT_SAVE(hif_dev->htc_handle->drv_priv->debug.skbrx_stats.c++)
+#define RX_STAT_ADD(c, a)	__STAT_SAVE(hif_dev->htc_handle->drv_priv->debug.skbrx_stats.c += a)
+#define CAB_STAT_INC		(priv->debug.tx_stats.cab_queued++)
+
+#define TX_QSTAT_INC(q)		(priv->debug.tx_stats.queue_stats[q]++)
 
 void ath9k_htc_err_stat_rx(struct ath9k_htc_priv *priv,
 			   struct ath_rx_status *rs);
-- 
2.34.1


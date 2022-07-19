Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3E6EF579CBD
	for <lists+netdev@lfdr.de>; Tue, 19 Jul 2022 14:42:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241015AbiGSMmH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Jul 2022 08:42:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52020 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241018AbiGSMkG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 Jul 2022 08:40:06 -0400
Received: from mail-wm1-x330.google.com (mail-wm1-x330.google.com [IPv6:2a00:1450:4864:20::330])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EE9BD7D1E9
        for <netdev@vger.kernel.org>; Tue, 19 Jul 2022 05:16:13 -0700 (PDT)
Received: by mail-wm1-x330.google.com with SMTP id r1-20020a05600c35c100b003a326685e7cso408850wmq.1
        for <netdev@vger.kernel.org>; Tue, 19 Jul 2022 05:16:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=TjIe9OOGpwDnNhvL/YIzxOaQKCsr8adQ/Od7/da9He4=;
        b=gh88/L0EF0d7WK8EgA4uY51kb2W0GEteDnRLto/5sHATRc09yqXU5W3trIQPLJ4ooU
         0+y8u/iJRaz29fNC5utxkCxePKodAH3dBp62k70Jhaui4a6ZCtA1AMqXS6kZkjB7EnAA
         FK+OpHLm8DLUCW3RmItzx2aUuGMszsH7hchvCjd9b7F+QDA/WBFbcxBs+uVKYan8nmTL
         hlcG9XDKK+2C06E3kleaeIq5FMp0Q5DZ+bT/Yb+JxD8gxiRd6dc9bh/XCKGxg9nf8wCs
         9EOuWX00WhSE6uw0KeOyvq5Lyt3HMXPB+xIUcDpdLT7HIMgstCueMcs+q8OPtsJjrHqU
         og9g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=TjIe9OOGpwDnNhvL/YIzxOaQKCsr8adQ/Od7/da9He4=;
        b=UyFwla+mVx0MxcTuvPF1G3vAf0N7JSxDOnPKHaZDGfBtXeJfKqDv3zJAugS7ZEiL6N
         7A9TbNBd2O1egMnLM5r6UIhdY+eDsyXdYPRJyO0jHpr/nYsYtJS0NKwVpIrcYuj1QLv8
         fxOE9wOfPMEsbRzbNMNOdKCK08da/g1ax/XaZ859Hx+x6MZsT7I3LVuCRTy4YLgOJsUK
         Dk7FlfPNI0+S6EjO9z4nveIlAK2/J3/e5pNiW7vuMnLx08nKTJv3cR8tIyLqfD7cRiGS
         DyQ2JIeH1TusT5Rp1v2hqjUztE1i5QCywDu7bIaYDq9MLMtmDjkft6n7pObsNhXNf0Kq
         Mkqg==
X-Gm-Message-State: AJIora+xfO2bVdShxpdudFh1LMK/Zr53CxA3Y0kqFFVBn25dBcLdyRHu
        vmKhT1tIeViJrg8V2J4I0PRVBA==
X-Google-Smtp-Source: AGRyM1sVHgREOggQFPUAmM2U+cJS6ZgOZoqiUR/RGhevO/uH/w4XJ7EqiPa9v7Klu6WZZREBAuvPdA==
X-Received: by 2002:a7b:cc14:0:b0:3a3:2213:e653 with SMTP id f20-20020a7bcc14000000b003a32213e653mr3259901wmh.52.1658232967477;
        Tue, 19 Jul 2022 05:16:07 -0700 (PDT)
Received: from sagittarius-a.chello.ie (188-141-3-169.dynamic.upc.ie. [188.141.3.169])
        by smtp.gmail.com with ESMTPSA id d16-20020a05600c34d000b0039c5642e430sm14423812wmq.20.2022.07.19.05.16.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 19 Jul 2022 05:16:07 -0700 (PDT)
From:   Bryan O'Donoghue <bryan.odonoghue@linaro.org>
To:     kvalo@kernel.org, loic.poulain@linaro.org
Cc:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, wcn36xx@lists.infradead.org,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        bryan.odonoghue@linaro.org
Subject: [PATCH 4/4] wcn36xx: Add debugfs entry to read firmware feature strings
Date:   Tue, 19 Jul 2022 13:16:00 +0100
Message-Id: <20220719121600.1847440-5-bryan.odonoghue@linaro.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220719121600.1847440-1-bryan.odonoghue@linaro.org>
References: <20220719121600.1847440-1-bryan.odonoghue@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add in the ability to easily find the firmware feature bits reported in the
get feature exchange without having to compile-in debug prints.

root@linaro-alip:~# cat /sys/kernel/debug/ieee80211/phy0/wcn36xx/firmware_feat_caps
FW Cap = MCC
FW Cap = P2P
FW Cap = DOT11AC
FW Cap = SLM_SESSIONIZATION
FW Cap = DOT11AC_OPMODE
FW Cap = SAP32STA
FW Cap = TDLS
FW Cap = P2P_GO_NOA_DECOUPLE_INIT_SCAN
FW Cap = WLANACTIVE_OFFLOAD
FW Cap = BEACON_OFFLOAD
FW Cap = SCAN_OFFLOAD
FW Cap = BCN_MISS_OFFLOAD
FW Cap = STA_POWERSAVE
FW Cap = STA_ADVANCED_PWRSAVE
FW Cap = BCN_FILTER
FW Cap = RTT
FW Cap = RATECTRL
FW Cap = WOW
FW Cap = WLAN_ROAM_SCAN_OFFLOAD
FW Cap = SPECULATIVE_PS_POLL
FW Cap = IBSS_HEARTBEAT_OFFLOAD
FW Cap = WLAN_SCAN_OFFLOAD
FW Cap = WLAN_PERIODIC_TX_PTRN
FW Cap = ADVANCE_TDLS
FW Cap = BATCH_SCAN
FW Cap = FW_IN_TX_PATH
FW Cap = EXTENDED_NSOFFLOAD_SLOT
FW Cap = CH_SWITCH_V1
FW Cap = HT40_OBSS_SCAN
FW Cap = UPDATE_CHANNEL_LIST
FW Cap = WLAN_MCADDR_FLT
FW Cap = WLAN_CH144
FW Cap = TDLS_SCAN_COEXISTENCE
FW Cap = LINK_LAYER_STATS_MEAS
FW Cap = MU_MIMO
FW Cap = EXTENDED_SCAN
FW Cap = DYNAMIC_WMM_PS
FW Cap = MAC_SPOOFED_SCAN
FW Cap = FW_STATS
FW Cap = WPS_PRBRSP_TMPL
FW Cap = BCN_IE_FLT_DELTA

Signed-off-by: Bryan O'Donoghue <bryan.odonoghue@linaro.org>
---
 drivers/net/wireless/ath/wcn36xx/debug.c | 37 ++++++++++++++++++++++++
 drivers/net/wireless/ath/wcn36xx/debug.h |  1 +
 2 files changed, 38 insertions(+)

diff --git a/drivers/net/wireless/ath/wcn36xx/debug.c b/drivers/net/wireless/ath/wcn36xx/debug.c
index 6af306ae41ad..ca6f22a00f75 100644
--- a/drivers/net/wireless/ath/wcn36xx/debug.c
+++ b/drivers/net/wireless/ath/wcn36xx/debug.c
@@ -21,6 +21,7 @@
 #include "wcn36xx.h"
 #include "debug.h"
 #include "pmc.h"
+#include "firmware.h"
 
 #ifdef CONFIG_WCN36XX_DEBUGFS
 
@@ -136,6 +137,40 @@ static const struct file_operations fops_wcn36xx_dump = {
 	.write =       write_file_dump,
 };
 
+static ssize_t read_file_firmware_feature_caps(struct file *file,
+					       char __user *user_buf,
+					       size_t count, loff_t *ppos)
+{
+	struct wcn36xx *wcn = file->private_data;
+	unsigned long page = get_zeroed_page(GFP_KERNEL);
+	char *p = (char *)page;
+	int i;
+	int ret;
+
+	if (!p)
+		return -ENOMEM;
+
+	mutex_lock(&wcn->hal_mutex);
+	for (i = 0; i < MAX_FEATURE_SUPPORTED; i++) {
+		if (wcn36xx_firmware_get_feat_caps(wcn->fw_feat_caps, i)) {
+			p += sprintf(p, "FW Cap = %s\n",
+				     wcn36xx_firmware_get_cap_name(i));
+		}
+	}
+	mutex_unlock(&wcn->hal_mutex);
+
+	ret = simple_read_from_buffer(user_buf, count, ppos, (char *)page,
+				      (unsigned long)p - page);
+
+	free_page(page);
+	return ret;
+}
+
+static const struct file_operations fops_wcn36xx_firmware_feat_caps = {
+	.open = simple_open,
+	.read = read_file_firmware_feature_caps,
+};
+
 #define ADD_FILE(name, mode, fop, priv_data)		\
 	do {							\
 		struct dentry *d;				\
@@ -163,6 +198,8 @@ void wcn36xx_debugfs_init(struct wcn36xx *wcn)
 
 	ADD_FILE(bmps_switcher, 0600, &fops_wcn36xx_bmps, wcn);
 	ADD_FILE(dump, 0200, &fops_wcn36xx_dump, wcn);
+	ADD_FILE(firmware_feat_caps, 0200,
+		 &fops_wcn36xx_firmware_feat_caps, wcn);
 }
 
 void wcn36xx_debugfs_exit(struct wcn36xx *wcn)
diff --git a/drivers/net/wireless/ath/wcn36xx/debug.h b/drivers/net/wireless/ath/wcn36xx/debug.h
index 46307aa562d3..7116d96e0543 100644
--- a/drivers/net/wireless/ath/wcn36xx/debug.h
+++ b/drivers/net/wireless/ath/wcn36xx/debug.h
@@ -31,6 +31,7 @@ struct wcn36xx_dfs_entry {
 	struct dentry *rootdir;
 	struct wcn36xx_dfs_file file_bmps_switcher;
 	struct wcn36xx_dfs_file file_dump;
+	struct wcn36xx_dfs_file file_firmware_feat_caps;
 };
 
 void wcn36xx_debugfs_init(struct wcn36xx *wcn);
-- 
2.36.1


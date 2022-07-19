Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6AE2E57A1D5
	for <lists+netdev@lfdr.de>; Tue, 19 Jul 2022 16:38:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239304AbiGSOi3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Jul 2022 10:38:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59050 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237732AbiGSOiH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 Jul 2022 10:38:07 -0400
Received: from mail-wm1-x32a.google.com (mail-wm1-x32a.google.com [IPv6:2a00:1450:4864:20::32a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A1C162A701
        for <netdev@vger.kernel.org>; Tue, 19 Jul 2022 07:33:10 -0700 (PDT)
Received: by mail-wm1-x32a.google.com with SMTP id 8-20020a05600c024800b003a2fe343db1so9297406wmj.1
        for <netdev@vger.kernel.org>; Tue, 19 Jul 2022 07:33:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=1A3RZDz93CJsUVu1ZGCAc3vc85qUDp5cTEvniEHIFDU=;
        b=jQ8wwS67AZC0aPGPY8PtQuc2BqAASJQpUhW/K6fech4c+AVZwp66x+6Z44uIf9LULB
         nhfdbRw0X0rnv0dVxDNAEXkdUJLvTE+R/lXP+m4Bc3PW3RAzubD4k9tsrHVgC2lshbhX
         Y2T/A5tIayW+O9MNMT/W9LENM2/XkociCwxoGiangLxgdCn/CFQX9fGPvDB/nB1gLIH+
         D+HCLD6E9Omu4ypFYTC1+ci5QZYmNEV5rUQJ6GwkHcxLlgdb3KLy9zwQJGV8UNLVxvHA
         ceeTu4o4rUKYhrYTpEDt1QJZ8os47jAM7U+lZK6BU4w2KbL3RiXePBk4jVWWLmJhwnwJ
         OdkQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=1A3RZDz93CJsUVu1ZGCAc3vc85qUDp5cTEvniEHIFDU=;
        b=6SRP7QT3AfUc5N1wNYeUtKscnk+5/uXYaBT2+TVl5ou9Cx/PwoLgAmhGG7xUGBl50K
         XQnkjb48KOFKNlU+1Wbd3+dxYFm63u8lGNdL5JCmrpYK9jH0aNzM/ja+qzuFm+7CPxxV
         +nrEvJeCs7AhBLAmmu4Q/rV1UySIN73I/vCZwlfWVkLFUYax/Fn7tRKgcL6JqW2JZ13m
         4yA/wC8QvBlrSTSOckFE/l2urZ3quiXKAy36YTwwUgh6j+a1ABx7PVxvAySyi8zPl362
         dlp9v0xf9tI9ChRCXXmG2XogNpLOStvQ1ony47rfXqky77xAQc0tZ2zcHo4Cle4T4mLO
         c+Lg==
X-Gm-Message-State: AJIora8i/2q5NIQAzjUzn9TycLwFOguR00Wkeyzu8o02zudILJP4LKGH
        rMbRlgxJ4X2NxK+rUsL0k1yb3ggYuSGPww==
X-Google-Smtp-Source: AGRyM1vWu67gzk72zMk4h+O6x4e3mmM0paqu8OTlTC4v8U6LhUBXFI0Oir0UzV1Kc79+RienOUfk0g==
X-Received: by 2002:a05:600c:34c6:b0:3a3:2549:1905 with SMTP id d6-20020a05600c34c600b003a325491905mr2295740wmq.204.1658241189152;
        Tue, 19 Jul 2022 07:33:09 -0700 (PDT)
Received: from sagittarius-a.chello.ie (188-141-3-169.dynamic.upc.ie. [188.141.3.169])
        by smtp.gmail.com with ESMTPSA id d15-20020adffbcf000000b0020fff0ea0a3sm13634378wrs.116.2022.07.19.07.33.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 19 Jul 2022 07:33:08 -0700 (PDT)
From:   Bryan O'Donoghue <bryan.odonoghue@linaro.org>
To:     kvalo@kernel.org, loic.poulain@linaro.org
Cc:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, wcn36xx@lists.infradead.org,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        bryan.odonoghue@linaro.org
Subject: [PATCH v2 4/4] wcn36xx: Add debugfs entry to read firmware feature strings
Date:   Tue, 19 Jul 2022 15:33:02 +0100
Message-Id: <20220719143302.2071223-5-bryan.odonoghue@linaro.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220719143302.2071223-1-bryan.odonoghue@linaro.org>
References: <20220719143302.2071223-1-bryan.odonoghue@linaro.org>
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
MCC
P2P
DOT11AC
SLM_SESSIONIZATION
DOT11AC_OPMODE
SAP32STA
TDLS
P2P_GO_NOA_DECOUPLE_INIT_SCAN
WLANACTIVE_OFFLOAD
BEACON_OFFLOAD
SCAN_OFFLOAD
BCN_MISS_OFFLOAD
STA_POWERSAVE
STA_ADVANCED_PWRSAVE
BCN_FILTER
RTT
RATECTRL
WOW
WLAN_ROAM_SCAN_OFFLOAD
SPECULATIVE_PS_POLL
IBSS_HEARTBEAT_OFFLOAD
WLAN_SCAN_OFFLOAD
WLAN_PERIODIC_TX_PTRN
ADVANCE_TDLS
BATCH_SCAN
FW_IN_TX_PATH
EXTENDED_NSOFFLOAD_SLOT
CH_SWITCH_V1
HT40_OBSS_SCAN
UPDATE_CHANNEL_LIST
WLAN_MCADDR_FLT
WLAN_CH144
TDLS_SCAN_COEXISTENCE
LINK_LAYER_STATS_MEAS
MU_MIMO
EXTENDED_SCAN
DYNAMIC_WMM_PS
MAC_SPOOFED_SCAN
FW_STATS
WPS_PRBRSP_TMPL
BCN_IE_FLT_DELTA

Signed-off-by: Bryan O'Donoghue <bryan.odonoghue@linaro.org>
---
 drivers/net/wireless/ath/wcn36xx/debug.c | 37 ++++++++++++++++++++++++
 drivers/net/wireless/ath/wcn36xx/debug.h |  1 +
 2 files changed, 38 insertions(+)

diff --git a/drivers/net/wireless/ath/wcn36xx/debug.c b/drivers/net/wireless/ath/wcn36xx/debug.c
index 6af306ae41ad..220f338045bd 100644
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
+			p += sprintf(p, "%s\n",
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


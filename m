Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6C7D32AA704
	for <lists+netdev@lfdr.de>; Sat,  7 Nov 2020 18:24:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728640AbgKGRYE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 7 Nov 2020 12:24:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40314 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726364AbgKGRYE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 7 Nov 2020 12:24:04 -0500
Received: from mail-pl1-x641.google.com (mail-pl1-x641.google.com [IPv6:2607:f8b0:4864:20::641])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4B1CCC0613CF;
        Sat,  7 Nov 2020 09:24:04 -0800 (PST)
Received: by mail-pl1-x641.google.com with SMTP id t18so2473313plo.0;
        Sat, 07 Nov 2020 09:24:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=odlLroNxxuLIC09tR+IlvfwqpoNgpJyrXnvF3o9ig+c=;
        b=IHs5FQ8Qw9UcNwUF6BUwERkP9ilP01zbci1uGo3vKlEbwejMPeVZx+dpZ31WBpZ71u
         rZBmYO6YAgGikZGN4m5kTel8PjchamivCCqPIvssRLgzriudPgQ899QTwSdSOww3OrsE
         pBh09V6DpG5xYi322wUDwg0os0kB7Rnxd28ZE35qNLgmTMdSD+psy2r69aFg0hfvkUZB
         a8LyUbF4onW5UlwLN/0rndDLa5YnVbFKcmvKNOHzIi9GHrVjWqE2X9y6MhJ8oGHp6umH
         9s7XHQqZHX18ZQci5Rbz3o0Auu9yadzuLsHre7VHIQw5wIJDR+SS23KQx11jxJXFtI3m
         KjJw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=odlLroNxxuLIC09tR+IlvfwqpoNgpJyrXnvF3o9ig+c=;
        b=tOJ7Kzzl3CYSOGgfpXNPP7ElAKKYfjDwlyOKvKRNopKLKe/Lg/tcFlZUURNkJmBRVq
         lmN6c10VXSvbau5LEPJk/DHWsXbk6RvwooEQbroYp7ut39YegBCMu95I7fu6KuXkzNE0
         trWm6P52BkJg+mvZ3616RKivUKEjlPJduw4FuXjUlfWBVcONsMU4kIDoi8bOlnHSNPCu
         wFi05LMF0nG2Sh61D+5M8imnZVq4es0a59NuyFjSUwaobW1PjAXKM3+Zo0IaN61Ikgj2
         pM+IUDGCmVemJimo3uxqkTvszpleF5eMvKK3Mcm9kZt9vUd7eFJpva9Ez+yWdsE9J8cO
         pFng==
X-Gm-Message-State: AOAM532JwkozRElZuRCRz4eKRvqcRptOFPCKACqza8VpUaoe23757bIX
        nNF9imxmqOK0f9k7BVdcnlM=
X-Google-Smtp-Source: ABdhPJxBr/485iFpiaVQrXjQEXm46jBqhyO6DKnSZrGQ0rW8ljq9LmeLoncg9NAI/EeCEgxrYORc2g==
X-Received: by 2002:a17:90b:46d7:: with SMTP id jx23mr5094196pjb.86.1604769843792;
        Sat, 07 Nov 2020 09:24:03 -0800 (PST)
Received: from localhost.localdomain ([180.70.143.152])
        by smtp.gmail.com with ESMTPSA id m17sm4916962pgu.21.2020.11.07.09.23.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 07 Nov 2020 09:24:03 -0800 (PST)
From:   Taehee Yoo <ap420073@gmail.com>
To:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org
Cc:     ap420073@gmail.com, David.Laight@aculab.com,
        johannes@sipsolutions.net, nstange@suse.de, derosier@gmail.com,
        kvalo@codeaurora.org, linux-wireless@vger.kernel.org,
        wil6210@qti.qualcomm.com, b43-dev@lists.infradead.org,
        linux-bluetooth@vger.kernel.org, michael.hennerich@analog.com,
        linux-wpan@vger.kernel.org, stefan@datenfreihafen.org,
        inaky.perez-gonzalez@intel.com, linux-wimax@intel.com,
        emmanuel.grumbach@intel.com, luciano.coelho@intel.com,
        stf_xl@wp.pl, pkshih@realtek.com, ath11k@lists.infradead.org,
        ath10k@lists.infradead.org, wcn36xx@lists.infradead.org,
        merez@codeaurora.org, pizza@shaftnet.org,
        Larry.Finger@lwfinger.net, amitkarwar@gmail.com,
        ganapathi.bhat@nxp.com, huxinming820@gmail.com,
        marcel@holtmann.org, johan.hedberg@gmail.com, alex.aring@gmail.com,
        jukka.rissanen@linux.intel.com, arend.vanspriel@broadcom.com,
        franky.lin@broadcom.com, hante.meuleman@broadcom.com,
        chung-hsien.hsu@infineon.com, wright.feng@infineon.com,
        chi-hsien.lin@infineon.com
Subject: [PATCH net v2 09/21] iwlwifi: set .owner to THIS_MODULE
Date:   Sat,  7 Nov 2020 17:21:40 +0000
Message-Id: <20201107172152.828-10-ap420073@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20201107172152.828-1-ap420073@gmail.com>
References: <20201107172152.828-1-ap420073@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

If THIS_MODULE is not set, the module would be removed while debugfs is
being used.
It eventually makes kernel panic.

Fixes: 5ae212c9273d ("[PATCH] iwlwifi: add read rate scale table debugfs function")
Fixes: 0209dc11c769 ("[PATCH] iwlwifi: add debugfs rate scale stats")
Fixes: 712b6cf57a53 ("iwlwifi: Add debugfs to iwl core")
Fixes: 189a2b5942d6 ("iwlwifi: trigger event log from debugfs")
Fixes: 8ca151b568b6 ("iwlwifi: add the MVM driver")
Fixes: 757cf23b4b4b ("iwlwifi: mvm: add per rate tx stats")
Fixes: 2b55f43f8e47 ("iwlwifi: mvm: Add mem debugfs entry")
Fixes: 93b167c13a3a ("iwlwifi: runtime: sync FW and host clocks for logs")
Fixes: 38167459da50 ("iwlagn: show current rate scale data in debugfs")
Fixes: 87e5666c0722 ("iwlagn: transport handler can register debugfs entries")
Fixes: 16db88ba51d6 ("iwlagn: move dump_csr and dump_fh to transport layer")
Signed-off-by: Taehee Yoo <ap420073@gmail.com>
---

v1 -> v2:
 - Change headline
 - Squash patches into per-driver/subsystem

 drivers/net/wireless/intel/iwlwifi/dvm/debugfs.c | 3 +++
 drivers/net/wireless/intel/iwlwifi/dvm/rs.c      | 3 +++
 drivers/net/wireless/intel/iwlwifi/fw/debugfs.c  | 3 +++
 drivers/net/wireless/intel/iwlwifi/mvm/debugfs.c | 1 +
 drivers/net/wireless/intel/iwlwifi/mvm/debugfs.h | 3 +++
 drivers/net/wireless/intel/iwlwifi/mvm/rs.c      | 3 +++
 drivers/net/wireless/intel/iwlwifi/pcie/trans.c  | 3 +++
 7 files changed, 19 insertions(+)

diff --git a/drivers/net/wireless/intel/iwlwifi/dvm/debugfs.c b/drivers/net/wireless/intel/iwlwifi/dvm/debugfs.c
index 911049201838..a1022987eccf 100644
--- a/drivers/net/wireless/intel/iwlwifi/dvm/debugfs.c
+++ b/drivers/net/wireless/intel/iwlwifi/dvm/debugfs.c
@@ -34,6 +34,7 @@ static const struct file_operations iwl_dbgfs_##name##_ops = {          \
 	.read = iwl_dbgfs_##name##_read,				\
 	.open = simple_open,						\
 	.llseek = generic_file_llseek,					\
+	.owner = THIS_MODULE,						\
 };
 
 #define DEBUGFS_WRITE_FILE_OPS(name)                                    \
@@ -41,6 +42,7 @@ static const struct file_operations iwl_dbgfs_##name##_ops = {          \
 	.write = iwl_dbgfs_##name##_write,                              \
 	.open = simple_open,						\
 	.llseek = generic_file_llseek,					\
+	.owner = THIS_MODULE,						\
 };
 
 
@@ -50,6 +52,7 @@ static const struct file_operations iwl_dbgfs_##name##_ops = {          \
 	.read = iwl_dbgfs_##name##_read,                                \
 	.open = simple_open,						\
 	.llseek = generic_file_llseek,					\
+	.owner = THIS_MODULE,						\
 };
 
 static ssize_t iwl_dbgfs_sram_read(struct file *file,
diff --git a/drivers/net/wireless/intel/iwlwifi/dvm/rs.c b/drivers/net/wireless/intel/iwlwifi/dvm/rs.c
index 548540dd0c0f..1518dead1e47 100644
--- a/drivers/net/wireless/intel/iwlwifi/dvm/rs.c
+++ b/drivers/net/wireless/intel/iwlwifi/dvm/rs.c
@@ -3172,6 +3172,7 @@ static const struct file_operations rs_sta_dbgfs_scale_table_ops = {
 	.read = rs_sta_dbgfs_scale_table_read,
 	.open = simple_open,
 	.llseek = default_llseek,
+	.owner = THIS_MODULE,
 };
 static ssize_t rs_sta_dbgfs_stats_table_read(struct file *file,
 			char __user *user_buf, size_t count, loff_t *ppos)
@@ -3215,6 +3216,7 @@ static const struct file_operations rs_sta_dbgfs_stats_table_ops = {
 	.read = rs_sta_dbgfs_stats_table_read,
 	.open = simple_open,
 	.llseek = default_llseek,
+	.owner = THIS_MODULE,
 };
 
 static ssize_t rs_sta_dbgfs_rate_scale_data_read(struct file *file,
@@ -3241,6 +3243,7 @@ static const struct file_operations rs_sta_dbgfs_rate_scale_data_ops = {
 	.read = rs_sta_dbgfs_rate_scale_data_read,
 	.open = simple_open,
 	.llseek = default_llseek,
+	.owner = THIS_MODULE,
 };
 
 static void rs_add_debugfs(void *priv, void *priv_sta,
diff --git a/drivers/net/wireless/intel/iwlwifi/fw/debugfs.c b/drivers/net/wireless/intel/iwlwifi/fw/debugfs.c
index 267ad4eddb5c..5f41c8587ac6 100644
--- a/drivers/net/wireless/intel/iwlwifi/fw/debugfs.c
+++ b/drivers/net/wireless/intel/iwlwifi/fw/debugfs.c
@@ -122,6 +122,7 @@ static const struct file_operations iwl_dbgfs_##name##_ops = {		\
 	.open = _iwl_dbgfs_##name##_open,				\
 	.llseek = generic_file_llseek,					\
 	.release = _iwl_dbgfs_release,					\
+	.owner = THIS_MODULE,						\
 }
 
 #define FWRT_DEBUGFS_WRITE_WRAPPER(name, buflen, argtype)		\
@@ -150,6 +151,7 @@ static const struct file_operations iwl_dbgfs_##name##_ops = {		\
 	.open = _iwl_dbgfs_##name##_open,				\
 	.llseek = generic_file_llseek,					\
 	.release = _iwl_dbgfs_release,					\
+	.owner = THIS_MODULE,						\
 }
 
 #define _FWRT_DEBUGFS_WRITE_FILE_OPS(name, buflen, argtype)		\
@@ -160,6 +162,7 @@ static const struct file_operations iwl_dbgfs_##name##_ops = {		\
 	.open = _iwl_dbgfs_##name##_open,				\
 	.llseek = generic_file_llseek,					\
 	.release = _iwl_dbgfs_release,					\
+	.owner = THIS_MODULE,						\
 }
 
 #define FWRT_DEBUGFS_READ_FILE_OPS(name, bufsz)				\
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/debugfs.c b/drivers/net/wireless/intel/iwlwifi/mvm/debugfs.c
index 3395c4675988..d4b9ef8b25ee 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/debugfs.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/debugfs.c
@@ -1981,6 +1981,7 @@ static const struct file_operations iwl_dbgfs_mem_ops = {
 	.write = iwl_dbgfs_mem_write,
 	.open = simple_open,
 	.llseek = default_llseek,
+	.owner = THIS_MODULE,
 };
 
 void iwl_mvm_sta_add_debugfs(struct ieee80211_hw *hw,
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/debugfs.h b/drivers/net/wireless/intel/iwlwifi/mvm/debugfs.h
index a83d252c0602..5bf4f7801b83 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/debugfs.h
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/debugfs.h
@@ -63,6 +63,7 @@ static const struct file_operations iwl_dbgfs_##name##_ops = {		\
 	.read = iwl_dbgfs_##name##_read,				\
 	.open = simple_open,						\
 	.llseek = generic_file_llseek,					\
+	.owner = THIS_MODULE,						\
 }
 
 #define MVM_DEBUGFS_WRITE_WRAPPER(name, buflen, argtype)		\
@@ -87,6 +88,7 @@ static const struct file_operations iwl_dbgfs_##name##_ops = {		\
 	.read = iwl_dbgfs_##name##_read,				\
 	.open = simple_open,						\
 	.llseek = generic_file_llseek,					\
+	.owner = THIS_MODULE,						\
 };
 
 #define _MVM_DEBUGFS_WRITE_FILE_OPS(name, buflen, argtype)		\
@@ -95,4 +97,5 @@ static const struct file_operations iwl_dbgfs_##name##_ops = {		\
 	.write = _iwl_dbgfs_##name##_write,				\
 	.open = simple_open,						\
 	.llseek = generic_file_llseek,					\
+	.owner = THIS_MODULE,						\
 };
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/rs.c b/drivers/net/wireless/intel/iwlwifi/mvm/rs.c
index ed7382e7ea17..853c3969c956 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/rs.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/rs.c
@@ -3909,6 +3909,7 @@ static const struct file_operations rs_sta_dbgfs_scale_table_ops = {
 	.read = rs_sta_dbgfs_scale_table_read,
 	.open = simple_open,
 	.llseek = default_llseek,
+	.owner = THIS_MODULE,
 };
 static ssize_t rs_sta_dbgfs_stats_table_read(struct file *file,
 			char __user *user_buf, size_t count, loff_t *ppos)
@@ -3956,6 +3957,7 @@ static const struct file_operations rs_sta_dbgfs_stats_table_ops = {
 	.read = rs_sta_dbgfs_stats_table_read,
 	.open = simple_open,
 	.llseek = default_llseek,
+	.owner = THIS_MODULE,
 };
 
 static ssize_t rs_sta_dbgfs_drv_tx_stats_read(struct file *file,
@@ -4046,6 +4048,7 @@ static const struct file_operations rs_sta_dbgfs_drv_tx_stats_ops = {
 	.write = rs_sta_dbgfs_drv_tx_stats_write,
 	.open = simple_open,
 	.llseek = default_llseek,
+	.owner = THIS_MODULE,
 };
 
 static ssize_t iwl_dbgfs_ss_force_read(struct file *file,
diff --git a/drivers/net/wireless/intel/iwlwifi/pcie/trans.c b/drivers/net/wireless/intel/iwlwifi/pcie/trans.c
index d2e69ad53b27..250b7883703c 100644
--- a/drivers/net/wireless/intel/iwlwifi/pcie/trans.c
+++ b/drivers/net/wireless/intel/iwlwifi/pcie/trans.c
@@ -2476,6 +2476,7 @@ static const struct file_operations iwl_dbgfs_##name##_ops = {		\
 	.read = iwl_dbgfs_##name##_read,				\
 	.open = simple_open,						\
 	.llseek = generic_file_llseek,					\
+	.owner = THIS_MODULE,						\
 };
 
 #define DEBUGFS_WRITE_FILE_OPS(name)                                    \
@@ -2483,6 +2484,7 @@ static const struct file_operations iwl_dbgfs_##name##_ops = {          \
 	.write = iwl_dbgfs_##name##_write,                              \
 	.open = simple_open,						\
 	.llseek = generic_file_llseek,					\
+	.owner = THIS_MODULE,						\
 };
 
 #define DEBUGFS_READ_WRITE_FILE_OPS(name)				\
@@ -2491,6 +2493,7 @@ static const struct file_operations iwl_dbgfs_##name##_ops = {		\
 	.read = iwl_dbgfs_##name##_read,				\
 	.open = simple_open,						\
 	.llseek = generic_file_llseek,					\
+	.owner = THIS_MODULE,						\
 };
 
 struct iwl_dbgfs_tx_queue_priv {
-- 
2.17.1


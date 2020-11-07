Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AD8C62AA71C
	for <lists+netdev@lfdr.de>; Sat,  7 Nov 2020 18:25:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728744AbgKGRY6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 7 Nov 2020 12:24:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40472 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728437AbgKGRY6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 7 Nov 2020 12:24:58 -0500
Received: from mail-pf1-x442.google.com (mail-pf1-x442.google.com [IPv6:2607:f8b0:4864:20::442])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B2498C0613CF;
        Sat,  7 Nov 2020 09:24:57 -0800 (PST)
Received: by mail-pf1-x442.google.com with SMTP id z3so4414813pfb.10;
        Sat, 07 Nov 2020 09:24:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=R8MHn27XTX9uCiH/plMskXmmEPSmK7f2PWuf8/OR+AU=;
        b=pUNoC673i2WYSbCl0jbt9pCvBg26oiu+f0tyKdcFmV6zq/aN99b+xI+aaNhT1CXQIl
         qXc/7OlhFBeMVo/yqdz9o6G0xJBqIB4kkxmid/9QP9amDKRpZ1My4jFUUHBbUbXI3SXw
         JJAcjXn4u7UcHyXvKKLPjlqWqDdjWQ2iTTwhC2hjP20nnqhMwwgKw/O/RBuofvxrYd4/
         zCFJ1tb7WgOV0M5GcTFX4EcooXtEk2ELFdlgAUFUSCM7P1LEEBrRdGZTwNy8rwtmF1t9
         FGgoeJfh1SgmLhOvhX31q/Hyq6YNewUYNrFZyibVcnMcxBOyxOEu+3suF8qNmf+tJ3kx
         LZ4A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=R8MHn27XTX9uCiH/plMskXmmEPSmK7f2PWuf8/OR+AU=;
        b=d8mxEN8yyTmuBhPSQhsgzQZfsUUguiRvjm2LoES+rgCewxVbsIDw8JYOHtHf3dAjrw
         J5zJtOxzCPwBcQ3PJxJTs9Lr0EjCfLA4ixrtqrl66XixE/kh1NCRW9HTmXX4Yg5Z6u6I
         YIsriCFGtl+sBLsT60nS3Wi4k+07pwdfQYKd7nTEcAbXQRdw5h2xbm/nMD9Jsah5/kmZ
         EC1DBaHZ8Qm3imB+UQWjHJ2duKQe9FM8SXyTHMGI/mvfVXr8YOZzpvRcE2edxkzea0Jp
         d9KoPB3m+BjfoWlEn5Aa1PeyRAKdQT+5gXVzKrB94BeBEKC1kwWA/k8V+WK8o4GkvmvH
         R74g==
X-Gm-Message-State: AOAM530zqw5QER62zLPv5U2RMlI1nFI5SFCJ9ATeD4Q0erASrOYevaH9
        1wlp2nfcL9ceDLvOPZC24/k=
X-Google-Smtp-Source: ABdhPJy92yRleIaEQ5hiH+RyR1slGmITH9Z4dpShgnssfYQTYJ49kuylD+nc3doX3ybGbLPNcJDl5Q==
X-Received: by 2002:a63:1103:: with SMTP id g3mr6488347pgl.48.1604769897225;
        Sat, 07 Nov 2020 09:24:57 -0800 (PST)
Received: from localhost.localdomain ([180.70.143.152])
        by smtp.gmail.com with ESMTPSA id m17sm4916962pgu.21.2020.11.07.09.24.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 07 Nov 2020 09:24:56 -0800 (PST)
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
Subject: [PATCH net v2 15/21] wil6210: set .owner to THIS_MODULE
Date:   Sat,  7 Nov 2020 17:21:46 +0000
Message-Id: <20201107172152.828-16-ap420073@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20201107172152.828-1-ap420073@gmail.com>
References: <20201107172152.828-1-ap420073@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

If THIS_MODULE is not set, the module would be removed while debugfs is
being used.
It eventually makes kernel panic.

Fixes: 2be7d22f0625 ("wireless: add new wil6210 802.11ad 60GHz driver")
Fixes: 0b39aaf2f203 ("wil6210: Tx mgmt frame from debugfs")
Fixes: c5b3a6582b1e ("wil6210: Add support for setting RBUFCAP configuration")
Fixes: 3277213feb1b ("wil6210: ADDBA/DELBA flows")
Fixes: dc16427bbe65 ("wil6210: Add pmc debug mechanism memory management")
Fixes: 977c45ab5f41 ("wil6210: add debugfs to show PMC ring content")
Fixes: ff974e408334 ("wil6210: debugfs interface to send raw WMI command")
Fixes: c33407a8c504 ("wil6210: manual FW error recovery mode")
Fixes: a24a3d6abb97 ("wil6210: add TX latency statistics")
Fixes: 0c936b3c9633 ("wil6210: add support for link statistics")
Fixes: 10d599ad84a1 ("wil6210: add support for device led configuration")
Fixes: 12bace75704e ("wil6210: extract firmware capabilities from FW file")
Fixes: 13cd9f758a55 ("wil6210: extract firmware version from file header")
Fixes: fe9ee51e6a43 ("wil6210: add support for PCIe D3hot in system suspend")
Fixes: 96c93589e2df ("wil6210: initialize TX and RX enhanced DMA rings")
Signed-off-by: Taehee Yoo <ap420073@gmail.com>
---

v1 -> v2:
 - Change headline
 - Squash patches into per-driver/subsystem

 drivers/net/wireless/ath/wil6210/debugfs.c | 19 +++++++++++++++++++
 1 file changed, 19 insertions(+)

diff --git a/drivers/net/wireless/ath/wil6210/debugfs.c b/drivers/net/wireless/ath/wil6210/debugfs.c
index 2d618f90afa7..799493739771 100644
--- a/drivers/net/wireless/ath/wil6210/debugfs.c
+++ b/drivers/net/wireless/ath/wil6210/debugfs.c
@@ -678,6 +678,7 @@ static const struct file_operations fops_ioblob = {
 	.read =		wil_read_file_ioblob,
 	.open =		simple_open,
 	.llseek =	default_llseek,
+	.owner =	THIS_MODULE,
 };
 
 static
@@ -729,6 +730,7 @@ static ssize_t wil_write_file_rxon(struct file *file, const char __user *buf,
 static const struct file_operations fops_rxon = {
 	.write = wil_write_file_rxon,
 	.open  = simple_open,
+	.owner = THIS_MODULE,
 };
 
 static ssize_t wil_write_file_rbufcap(struct file *file,
@@ -767,6 +769,7 @@ static ssize_t wil_write_file_rbufcap(struct file *file,
 static const struct file_operations fops_rbufcap = {
 	.write = wil_write_file_rbufcap,
 	.open  = simple_open,
+	.owner = THIS_MODULE,
 };
 
 /* block ack control, write:
@@ -865,6 +868,7 @@ static const struct file_operations fops_back = {
 	.read = wil_read_back,
 	.write = wil_write_back,
 	.open  = simple_open,
+	.owner = THIS_MODULE,
 };
 
 /* pmc control, write:
@@ -941,12 +945,14 @@ static const struct file_operations fops_pmccfg = {
 	.read = wil_read_pmccfg,
 	.write = wil_write_pmccfg,
 	.open  = simple_open,
+	.owner = THIS_MODULE,
 };
 
 static const struct file_operations fops_pmcdata = {
 	.open		= simple_open,
 	.read		= wil_pmc_read,
 	.llseek		= wil_pmc_llseek,
+	.owner		= THIS_MODULE,
 };
 
 static int wil_pmcring_seq_open(struct inode *inode, struct file *file)
@@ -959,6 +965,7 @@ static const struct file_operations fops_pmcring = {
 	.release	= single_release,
 	.read		= seq_read,
 	.llseek		= seq_lseek,
+	.owner		= THIS_MODULE,
 };
 
 /*---tx_mgmt---*/
@@ -996,6 +1003,7 @@ static ssize_t wil_write_file_txmgmt(struct file *file, const char __user *buf,
 static const struct file_operations fops_txmgmt = {
 	.write = wil_write_file_txmgmt,
 	.open  = simple_open,
+	.owner = THIS_MODULE,
 };
 
 /* Write WMI command (w/o mbox header) to this file to send it
@@ -1039,6 +1047,7 @@ static ssize_t wil_write_file_wmi(struct file *file, const char __user *buf,
 static const struct file_operations fops_wmi = {
 	.write = wil_write_file_wmi,
 	.open  = simple_open,
+	.owner = THIS_MODULE,
 };
 
 static void wil_seq_print_skb(struct seq_file *s, struct sk_buff *skb)
@@ -1558,6 +1567,7 @@ static const struct file_operations fops_recovery = {
 	.read = wil_read_file_recovery,
 	.write = wil_write_file_recovery,
 	.open  = simple_open,
+	.owner = THIS_MODULE,
 };
 
 /*---------Station matrix------------*/
@@ -1836,6 +1846,7 @@ static const struct file_operations fops_tx_latency = {
 	.read		= seq_read,
 	.write		= wil_tx_latency_write,
 	.llseek		= seq_lseek,
+	.owner		= THIS_MODULE,
 };
 
 static void wil_link_stats_print_basic(struct wil6210_vif *vif,
@@ -1999,6 +2010,7 @@ static const struct file_operations fops_link_stats = {
 	.read		= seq_read,
 	.write		= wil_link_stats_write,
 	.llseek		= seq_lseek,
+	.owner		= THIS_MODULE,
 };
 
 static int
@@ -2053,6 +2065,7 @@ static const struct file_operations fops_link_stats_global = {
 	.read		= seq_read,
 	.write		= wil_link_stats_global_write,
 	.llseek		= seq_lseek,
+	.owner		= THIS_MODULE,
 };
 
 static ssize_t wil_read_file_led_cfg(struct file *file, char __user *user_buf,
@@ -2100,6 +2113,7 @@ static const struct file_operations fops_led_cfg = {
 	.read = wil_read_file_led_cfg,
 	.write = wil_write_file_led_cfg,
 	.open  = simple_open,
+	.owner = THIS_MODULE,
 };
 
 /* led_blink_time, write:
@@ -2165,6 +2179,7 @@ static const struct file_operations fops_led_blink_time = {
 	.read = wil_read_led_blink_time,
 	.write = wil_write_led_blink_time,
 	.open  = simple_open,
+	.owner = THIS_MODULE,
 };
 
 /*---------FW capabilities------------*/
@@ -2189,6 +2204,7 @@ static const struct file_operations fops_fw_capabilities = {
 	.release	= single_release,
 	.read		= seq_read,
 	.llseek		= seq_lseek,
+	.owner		= THIS_MODULE,
 };
 
 /*---------FW version------------*/
@@ -2215,6 +2231,7 @@ static const struct file_operations fops_fw_version = {
 	.release	= single_release,
 	.read		= seq_read,
 	.llseek		= seq_lseek,
+	.owner		= THIS_MODULE,
 };
 
 /*---------suspend_stats---------*/
@@ -2275,6 +2292,7 @@ static const struct file_operations fops_suspend_stats = {
 	.read = wil_read_suspend_stats,
 	.write = wil_write_suspend_stats,
 	.open  = simple_open,
+	.owner = THIS_MODULE,
 };
 
 /*---------compressed_rx_status---------*/
@@ -2329,6 +2347,7 @@ static const struct file_operations fops_compressed_rx_status = {
 	.read = seq_read,
 	.write = wil_compressed_rx_status_write,
 	.llseek	= seq_lseek,
+	.owner = THIS_MODULE,
 };
 
 /*----------------*/
-- 
2.17.1


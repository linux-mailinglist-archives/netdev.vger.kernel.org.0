Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B66352AA714
	for <lists+netdev@lfdr.de>; Sat,  7 Nov 2020 18:24:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728707AbgKGRYk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 7 Nov 2020 12:24:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40420 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726364AbgKGRYj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 7 Nov 2020 12:24:39 -0500
Received: from mail-pl1-x641.google.com (mail-pl1-x641.google.com [IPv6:2607:f8b0:4864:20::641])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D2BAFC0613CF;
        Sat,  7 Nov 2020 09:24:39 -0800 (PST)
Received: by mail-pl1-x641.google.com with SMTP id b12so2466414plr.4;
        Sat, 07 Nov 2020 09:24:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=4+aAtgXDYqySZiqkd4LH9+itS3gTV5MK5an12cOAgbw=;
        b=Q7hLYJCPIgsT59lxTt9zeO6RYC2+dwg7ulaDUytCRoqpD0R+OmQxzzdPGZXdKDH70t
         ZL7Fh1+wL7kcQOnLqVaTEx1jVp6AdZswPySyMpuWgupV2ALz49JvcXuz+cJXSEnoCfXz
         r6FnDpvmq4vSsgURIUtJPnqT0+vDa0fzN0D3HqtxDoPsTt/XvJnNz5Tu5yuLyOztZfkU
         SKomJDDOCxeLHJA43dBhgNs66xzmq9Pf8Hbc1ipb9df6iz/bDuqdxqjOts/+5cs7gwdu
         Ohzv5shxfgWOCE5wAbCVXP4gM/Fmplmi4I6ej3saMlvonM2OkAWNTXocb8g3809PYY6N
         MpSQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=4+aAtgXDYqySZiqkd4LH9+itS3gTV5MK5an12cOAgbw=;
        b=lKE64/Rct6DZA0u7gg/MvZ8WvlFQWYTbjSo6/vIuMUfTRKdufUrzAtmEPsbPLqPBQy
         RpeE69uFys69yU9M0x9LretY4AW4X7J/VXoYtnl3Ln7zhKGS6tPrBKfpZySEi4nX4GBn
         JOBxZIlwH1yuzSqjaxCo5VhsvIcRx7wsyrAcVO8IyFIVtiVk/axRgv3uZSguR81X5RFI
         aRzVg2d27L9fmEfAYkV6L3xMB+ZHjmICE2MdJm1H++z5EU1UQ/ACj82rcnKlHIi0wpeJ
         0ASYL0MYXXY1rkXGiVSxZS2S0gzw4omzoSBRn8e0D2a2ItCij2vIiYeJ9954cnI6FqaH
         aMIw==
X-Gm-Message-State: AOAM531N/OrV2XbaABakT20y20l+RAt1W8QtrnAs8tmklQYRzx9hSo+J
        JPC6yI3b9sOJdvMB3qdz84U=
X-Google-Smtp-Source: ABdhPJyHgpbU5ya1bMlCna6kWX13dnAwHbmM9yXtj4YB8SiJpxFmsgoAV0DwmDwRUxkOH802YCLe6Q==
X-Received: by 2002:a17:902:9347:b029:d3:7c08:86c6 with SMTP id g7-20020a1709029347b02900d37c0886c6mr6028323plp.84.1604769879429;
        Sat, 07 Nov 2020 09:24:39 -0800 (PST)
Received: from localhost.localdomain ([180.70.143.152])
        by smtp.gmail.com with ESMTPSA id m17sm4916962pgu.21.2020.11.07.09.24.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 07 Nov 2020 09:24:38 -0800 (PST)
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
Subject: [PATCH net v2 13/21] ath10k: set .owner to THIS_MODULE
Date:   Sat,  7 Nov 2020 17:21:44 +0000
Message-Id: <20201107172152.828-14-ap420073@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20201107172152.828-1-ap420073@gmail.com>
References: <20201107172152.828-1-ap420073@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

If THIS_MODULE is not set, the module would be removed while debugfs is
being used.
It eventually makes kernel panic.

Fixes: 90174455ae05 ("ath10k: add support to configure pktlog filter")
Fixes: 63fb32df9786 ("ath10k: add debugfs entry to configure quiet period")
Fixes: 844fa5722712 ("ath10k: debugfs file to enable Bluetooth coexistence feature")
Fixes: 348cd95c8196 ("ath10k: add debugfs entry to enable extended tx stats")
Fixes: cc61a1bbbc0e ("ath10k: enable debugfs provision to enable Peer Stats feature")
Signed-off-by: Taehee Yoo <ap420073@gmail.com>
---

v1 -> v2:
 - Change headline
 - Squash patches into per-driver/subsystem

 drivers/net/wireless/ath/ath10k/debug.c | 15 ++++++++++-----
 1 file changed, 10 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/debug.c b/drivers/net/wireless/ath/ath10k/debug.c
index e8250a665433..afde3d8048e8 100644
--- a/drivers/net/wireless/ath/ath10k/debug.c
+++ b/drivers/net/wireless/ath/ath10k/debug.c
@@ -1911,7 +1911,8 @@ static ssize_t ath10k_read_pktlog_filter(struct file *file, char __user *ubuf,
 static const struct file_operations fops_pktlog_filter = {
 	.read = ath10k_read_pktlog_filter,
 	.write = ath10k_write_pktlog_filter,
-	.open = simple_open
+	.open = simple_open,
+	.owner = THIS_MODULE,
 };
 
 static ssize_t ath10k_write_quiet_period(struct file *file,
@@ -1955,7 +1956,8 @@ static ssize_t ath10k_read_quiet_period(struct file *file, char __user *ubuf,
 static const struct file_operations fops_quiet_period = {
 	.read = ath10k_read_quiet_period,
 	.write = ath10k_write_quiet_period,
-	.open = simple_open
+	.open = simple_open,
+	.owner = THIS_MODULE,
 };
 
 static ssize_t ath10k_write_btcoex(struct file *file,
@@ -2039,7 +2041,8 @@ static ssize_t ath10k_read_btcoex(struct file *file, char __user *ubuf,
 static const struct file_operations fops_btcoex = {
 	.read = ath10k_read_btcoex,
 	.write = ath10k_write_btcoex,
-	.open = simple_open
+	.open = simple_open,
+	.owner = THIS_MODULE,
 };
 
 static ssize_t ath10k_write_enable_extd_tx_stats(struct file *file,
@@ -2094,7 +2097,8 @@ static ssize_t ath10k_read_enable_extd_tx_stats(struct file *file,
 static const struct file_operations fops_enable_extd_tx_stats = {
 	.read = ath10k_read_enable_extd_tx_stats,
 	.write = ath10k_write_enable_extd_tx_stats,
-	.open = simple_open
+	.open = simple_open,
+	.owner = THIS_MODULE,
 };
 
 static ssize_t ath10k_write_peer_stats(struct file *file,
@@ -2163,7 +2167,8 @@ static ssize_t ath10k_read_peer_stats(struct file *file, char __user *ubuf,
 static const struct file_operations fops_peer_stats = {
 	.read = ath10k_read_peer_stats,
 	.write = ath10k_write_peer_stats,
-	.open = simple_open
+	.open = simple_open,
+	.owner = THIS_MODULE,
 };
 
 static ssize_t ath10k_debug_fw_checksums_read(struct file *file,
-- 
2.17.1


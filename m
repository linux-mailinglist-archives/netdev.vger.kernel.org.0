Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 01BBC2AA708
	for <lists+netdev@lfdr.de>; Sat,  7 Nov 2020 18:24:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728653AbgKGRYN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 7 Nov 2020 12:24:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40340 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726364AbgKGRYN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 7 Nov 2020 12:24:13 -0500
Received: from mail-pl1-x643.google.com (mail-pl1-x643.google.com [IPv6:2607:f8b0:4864:20::643])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 24736C0613CF;
        Sat,  7 Nov 2020 09:24:13 -0800 (PST)
Received: by mail-pl1-x643.google.com with SMTP id u2so2452661pls.10;
        Sat, 07 Nov 2020 09:24:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=s1LNEKUScgxop0eLZewEZfCrayhJikCFppuZBt54gvA=;
        b=p/Wt5kBeDfH3ajleUhl3tkKcpb3mI5osB6IOB3ny6/tUOl9K2gYz9jo3xduJtNpzxA
         CjuPrXjJPXJsfnUWDAHmtPChTNANUZp2ag9m3y8PX6qTKPIGuhlKZ8NznODaJ1GayAlg
         pxr0+XvpEoBBs22sSRLHi2SzTiSbk+uhTMNfPq1nxGnBy3iw00e7nIx4KOHFCBFH2JVZ
         ykgSUJ105T0DiI3Upg78QBT4WNNZ+lQWWe3bpa6kCC3dnMItOfyty80xUpC+fSkut1vU
         TuTeC2PBosHW7f0zDScBFmS3wX6knlTlF78CIzjQ4ItcjslBw7N0j3TuXwTrk4QsDBaU
         HiWQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=s1LNEKUScgxop0eLZewEZfCrayhJikCFppuZBt54gvA=;
        b=UdPR7uYErxOifnnQBgNcCxCHCe+UhlIvmdtl7clhNxEBqlqYIfXNZkqxF13HTi/E7Q
         VP2Bfj4+aFLwOh2XkrSCGqIbSA9+lI5In0VWAzGrLLAW3B75a2znUOEgXgRtWNY2rJv1
         kOHdekA8tEO6Mb12g/VvBnIZXaHSKLd8Dxo210A5uJITsmX3uux73NRNHlG30Vf4Glrx
         ztJTh/KkZzchwoNghJynRKuStjNp8j+ii2NidKhDT5VBoH/gTCMaEDRGA6WOALN38ZNl
         OmofTCztdbYflG7oDJ7yDFoK125ApO1ruKjV/AB9RNVwX24YmCsOVN8EXCN3P0oElS5e
         qtXg==
X-Gm-Message-State: AOAM531j1Px8dUejXqj/GXXSch6pbxXQKsx1ZKpVP3cwx3ZU2DufQDXn
        HzW3nI/g8KzrmsbERFuHL4w=
X-Google-Smtp-Source: ABdhPJxqw+ukXLR9L1J0ECgPqV3whGl+KagDxNK7Wrnq1QhY+2NRbUAnVfriBcV53gFDFQ8jk5Sx3Q==
X-Received: by 2002:a17:90a:d70d:: with SMTP id y13mr5197661pju.138.1604769852694;
        Sat, 07 Nov 2020 09:24:12 -0800 (PST)
Received: from localhost.localdomain ([180.70.143.152])
        by smtp.gmail.com with ESMTPSA id m17sm4916962pgu.21.2020.11.07.09.24.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 07 Nov 2020 09:24:11 -0800 (PST)
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
Subject: [PATCH net v2 10/21] iwlegacy: set .owner to THIS_MODULE
Date:   Sat,  7 Nov 2020 17:21:41 +0000
Message-Id: <20201107172152.828-11-ap420073@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20201107172152.828-1-ap420073@gmail.com>
References: <20201107172152.828-1-ap420073@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

If THIS_MODULE is not set, the module would be removed while debugfs is
being used.
It eventually makes kernel panic.

Fixes: be663ab67077 ("iwlwifi: split the drivers for agn and legacy devices 3945/4965")
Fixes: 4bc85c1324aa ("Revert "iwlwifi: split the drivers for agn and legacy devices 3945/4965"")
Signed-off-by: Taehee Yoo <ap420073@gmail.com>
---

v1 -> v2:
 - Change headline
 - Squash patches into per-driver/subsystem

 drivers/net/wireless/intel/iwlegacy/3945-rs.c | 1 +
 drivers/net/wireless/intel/iwlegacy/4965-rs.c | 3 +++
 drivers/net/wireless/intel/iwlegacy/debug.c   | 3 +++
 3 files changed, 7 insertions(+)

diff --git a/drivers/net/wireless/intel/iwlegacy/3945-rs.c b/drivers/net/wireless/intel/iwlegacy/3945-rs.c
index b2478cbe558e..b86e8ddc6f76 100644
--- a/drivers/net/wireless/intel/iwlegacy/3945-rs.c
+++ b/drivers/net/wireless/intel/iwlegacy/3945-rs.c
@@ -836,6 +836,7 @@ static const struct file_operations rs_sta_dbgfs_stats_table_ops = {
 	.read = il3945_sta_dbgfs_stats_table_read,
 	.open = simple_open,
 	.llseek = default_llseek,
+	.owner = THIS_MODULE,
 };
 
 static void
diff --git a/drivers/net/wireless/intel/iwlegacy/4965-rs.c b/drivers/net/wireless/intel/iwlegacy/4965-rs.c
index 9a491e5db75b..afe0b2121fc9 100644
--- a/drivers/net/wireless/intel/iwlegacy/4965-rs.c
+++ b/drivers/net/wireless/intel/iwlegacy/4965-rs.c
@@ -2669,6 +2669,7 @@ static const struct file_operations rs_sta_dbgfs_scale_table_ops = {
 	.read = il4965_rs_sta_dbgfs_scale_table_read,
 	.open = simple_open,
 	.llseek = default_llseek,
+	.owner = THIS_MODULE,
 };
 
 static ssize_t
@@ -2714,6 +2715,7 @@ static const struct file_operations rs_sta_dbgfs_stats_table_ops = {
 	.read = il4965_rs_sta_dbgfs_stats_table_read,
 	.open = simple_open,
 	.llseek = default_llseek,
+	.owner = THIS_MODULE,
 };
 
 static ssize_t
@@ -2742,6 +2744,7 @@ static const struct file_operations rs_sta_dbgfs_rate_scale_data_ops = {
 	.read = il4965_rs_sta_dbgfs_rate_scale_data_read,
 	.open = simple_open,
 	.llseek = default_llseek,
+	.owner = THIS_MODULE,
 };
 
 static void
diff --git a/drivers/net/wireless/intel/iwlegacy/debug.c b/drivers/net/wireless/intel/iwlegacy/debug.c
index d998a3f1b056..67fae353038c 100644
--- a/drivers/net/wireless/intel/iwlegacy/debug.c
+++ b/drivers/net/wireless/intel/iwlegacy/debug.c
@@ -136,6 +136,7 @@ static const struct file_operations il_dbgfs_##name##_ops = {	\
 	.read = il_dbgfs_##name##_read,				\
 	.open = simple_open,					\
 	.llseek = generic_file_llseek,				\
+	.owner = THIS_MODULE,					\
 };
 
 #define DEBUGFS_WRITE_FILE_OPS(name)				\
@@ -144,6 +145,7 @@ static const struct file_operations il_dbgfs_##name##_ops = {	\
 	.write = il_dbgfs_##name##_write,			\
 	.open = simple_open,					\
 	.llseek = generic_file_llseek,				\
+	.owner = THIS_MODULE,					\
 };
 
 #define DEBUGFS_READ_WRITE_FILE_OPS(name)			\
@@ -154,6 +156,7 @@ static const struct file_operations il_dbgfs_##name##_ops = {	\
 	.read = il_dbgfs_##name##_read,				\
 	.open = simple_open,					\
 	.llseek = generic_file_llseek,				\
+	.owner = THIS_MODULE,					\
 };
 
 static const char *
-- 
2.17.1


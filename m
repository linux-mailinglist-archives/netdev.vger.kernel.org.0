Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 968682AA710
	for <lists+netdev@lfdr.de>; Sat,  7 Nov 2020 18:24:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728687AbgKGRYb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 7 Nov 2020 12:24:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40392 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726364AbgKGRYb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 7 Nov 2020 12:24:31 -0500
Received: from mail-pj1-x1041.google.com (mail-pj1-x1041.google.com [IPv6:2607:f8b0:4864:20::1041])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DF647C0613CF;
        Sat,  7 Nov 2020 09:24:30 -0800 (PST)
Received: by mail-pj1-x1041.google.com with SMTP id gi3so1013101pjb.3;
        Sat, 07 Nov 2020 09:24:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=VRJReBusLJDdL7VrPK2tUmMmHMsSMNbu46+dvffJ4Ng=;
        b=JX3RDgq4wVWW6aZoTEcAdTgVaXjdLHYVWICv2dc7uEKWFBPxZ0vITqHuB++9M2NMIZ
         UTv0nLdFmvCVg+UQNTJ8Vp0tHSR7XhkAXqDi66jFnX1+xN8sabT+kEtshoMB0BS9xshn
         Kedr/a4Uijjfh/dbSlRtNOoiGKGwaJ58jbxT37hoI5my3VKiHOeiF6XMXD6lfE2oo1Tw
         iO9mEA4hTKvqD9yWME4qJRAlL81L0110C90QTz+ghmMyXSdVh/xDiwzSm65q7ydAcq4g
         6yRDneyw5UCmVlvbhm9GJLgO0+4u6bLgT1iAmROYGBmZqku6H37fj4WH86qK41Mw3EO8
         KjGg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=VRJReBusLJDdL7VrPK2tUmMmHMsSMNbu46+dvffJ4Ng=;
        b=GQn0arZMD9nmAfXQHD+lssvvkl/PIe+Vofp4oqVkoLCivy3NIi4f7lPU0qR1qP2PZT
         K/C0NeNoLesAc4qY5lHCgubSpS4xzJL3z3P385ddwvlO5v24CFVXQY+0yD91mwojy97L
         dz78C+L9bNF6+bjp8Z6VFTH6yROeud2C2HvHyUIPSg7oSajNsGqz73WiY/w1O/hE9u2y
         VsctWrlxSkzbtJI/JvOchTSq/bt/ZFoLxK8t73ffTRim8ybcPSB6vJ4yrlo5Rx51Kapz
         KW7DovUIwJNRV8QWF7VP7r9W7T3UUxf0iDty05GKyTeVEr8kNyGTOMxsCFhQ0vSk+YiN
         gn+g==
X-Gm-Message-State: AOAM530a+nT5Zk0m+UeQEMJ7noQolrL1Rd9bkOLhRF1EBTVF65tAJhsY
        ofBT28JpOaXrYOxr3x6Cego=
X-Google-Smtp-Source: ABdhPJxqit/zAbNV9BUSu85bevXj9bYGcoVd7LeOdaB86aHpNM7QsRGbVKGp6HnpZUgxugHd6l6zCw==
X-Received: by 2002:a17:90a:b393:: with SMTP id e19mr4974472pjr.40.1604769870452;
        Sat, 07 Nov 2020 09:24:30 -0800 (PST)
Received: from localhost.localdomain ([180.70.143.152])
        by smtp.gmail.com with ESMTPSA id m17sm4916962pgu.21.2020.11.07.09.24.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 07 Nov 2020 09:24:29 -0800 (PST)
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
Subject: [PATCH net v2 12/21] ath11k: set .owner to THIS_MODULE
Date:   Sat,  7 Nov 2020 17:21:43 +0000
Message-Id: <20201107172152.828-13-ap420073@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20201107172152.828-1-ap420073@gmail.com>
References: <20201107172152.828-1-ap420073@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

If THIS_MODULE is not set, the module would be removed while debugfs is
being used.
It eventually makes kernel panic.

Fixes: d5c65159f289 ("ath11k: driver for Qualcomm IEEE 802.11ax devices")
Signed-off-by: Taehee Yoo <ap420073@gmail.com>
---

v1 -> v2:
 - Change headline
 - Squash patches into per-driver/subsystem

 drivers/net/wireless/ath/ath11k/debugfs.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ath/ath11k/debugfs.c b/drivers/net/wireless/ath/ath11k/debugfs.c
index 1b914e67d314..bce9f9512833 100644
--- a/drivers/net/wireless/ath/ath11k/debugfs.c
+++ b/drivers/net/wireless/ath/ath11k/debugfs.c
@@ -593,7 +593,8 @@ static ssize_t ath11k_read_enable_extd_tx_stats(struct file *file,
 static const struct file_operations fops_extd_tx_stats = {
 	.read = ath11k_read_enable_extd_tx_stats,
 	.write = ath11k_write_enable_extd_tx_stats,
-	.open = simple_open
+	.open = simple_open,
+	.owner = THIS_MODULE,
 };
 
 static ssize_t ath11k_write_extd_rx_stats(struct file *file,
@@ -686,6 +687,7 @@ static const struct file_operations fops_extd_rx_stats = {
 	.read = ath11k_read_extd_rx_stats,
 	.write = ath11k_write_extd_rx_stats,
 	.open = simple_open,
+	.owner = THIS_MODULE,
 };
 
 static int ath11k_fill_bp_stats(struct ath11k_base *ab,
@@ -1047,7 +1049,8 @@ static ssize_t ath11k_write_simulate_radar(struct file *file,
 
 static const struct file_operations fops_simulate_radar = {
 	.write = ath11k_write_simulate_radar,
-	.open = simple_open
+	.open = simple_open,
+	.owner = THIS_MODULE,
 };
 
 int ath11k_debugfs_register(struct ath11k *ar)
-- 
2.17.1


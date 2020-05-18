Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 068F61D72F3
	for <lists+netdev@lfdr.de>; Mon, 18 May 2020 10:30:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726990AbgERIaI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 May 2020 04:30:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57946 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726800AbgERIaI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 May 2020 04:30:08 -0400
Received: from mail-wm1-x343.google.com (mail-wm1-x343.google.com [IPv6:2a00:1450:4864:20::343])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E6020C061A0C
        for <netdev@vger.kernel.org>; Mon, 18 May 2020 01:30:07 -0700 (PDT)
Received: by mail-wm1-x343.google.com with SMTP id w64so9241982wmg.4
        for <netdev@vger.kernel.org>; Mon, 18 May 2020 01:30:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=0pLnW0H+BLzHGpplRC3J6YV6S2ox3NAuOKZYgALffrw=;
        b=KiHjURskyciUpY8fn2m62QLha5AFFkbI6hdhbklFoWI1KvW3Kn7EBs29Wjvt3egmKt
         ZGl1iSwvsYbI/Dj3gOKX2b+/AR8wWNZge9KMttndZIxOt1Va9eIC7xt0NtRg6Q9WP7JD
         +WDMajbUEpdBYzH0mRVfJipByLCQgsrCiA1W0=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=0pLnW0H+BLzHGpplRC3J6YV6S2ox3NAuOKZYgALffrw=;
        b=ZpJ457CR5oiFVGzKZEKcwP4JT39rKSbyU7+zd2ZvjD+FFc7fHlD/Rusa2UCB8i1Beq
         LvlaVM8EWE1IPyEomOkfBpgdxnv7Hff55ldB+LC9sOjKtViKs2oMDFvwE5HoX1Me6wnq
         yeHSKgddhqI40s+hqGP0q5HbYk+cu/9fVmcuZm1OYLyyxyQfKnCXJ/KZptD2nCoSJN/P
         yYBW5xGh3j6b3RHPFaCqn2cKFqkYYS3fuRNY3j6QY1KTmhObMwQDg7t7BDBNsJkB7wV/
         OyCkU71KWb9bZtvMGyTFFU75aopb0vPSd66eSrtvOa+HzV9TBlbf/ywhUtfT154B1apo
         H/cg==
X-Gm-Message-State: AOAM530xFqeD9LwBheDLHP+h1+P2+Alhlck4f3b7O/5JTrDq2azqJDIn
        bzHxDhyEooQ6IN80Q1xcHWWkaQ==
X-Google-Smtp-Source: ABdhPJxbdVyQpHpT+tWbyq5fSF6iL0npizHVBqt+XF8ZaKBL+7YbpixBsOpimOGyJESJJV+VfPelgQ==
X-Received: by 2002:a05:600c:206:: with SMTP id 6mr18185517wmi.170.1589790606272;
        Mon, 18 May 2020 01:30:06 -0700 (PDT)
Received: from lxpurley1.dhcp.broadcom.net ([192.19.234.250])
        by smtp.gmail.com with ESMTPSA id m7sm15350144wmc.40.2020.05.18.01.30.04
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 18 May 2020 01:30:05 -0700 (PDT)
From:   Vasundhara Volam <vasundhara-v.volam@broadcom.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org,
        Vasundhara Volam <vasundhara-v.volam@broadcom.com>,
        Michael Chan <michael.chan@broadcom.com>
Subject: [PATCH net-next 4/4] bnxt_en: Check if hot_fw_reset is allowed before doing ETHTOOL_RESET
Date:   Mon, 18 May 2020 13:57:19 +0530
Message-Id: <1589790439-10487-5-git-send-email-vasundhara-v.volam@broadcom.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1589790439-10487-1-git-send-email-vasundhara-v.volam@broadcom.com>
References: <1589790439-10487-1-git-send-email-vasundhara-v.volam@broadcom.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

If device does not allow hot_fw_reset, issue firmware reset
without graceful flag.

Cc: Michael Chan <michael.chan@broadcom.com>
Signed-off-by: Vasundhara Volam <vasundhara-v.volam@broadcom.com>
Reviewed-by: Edwin Peer <edwin.peer@broadcom.com>
---
 drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c | 17 +++++++++--------
 1 file changed, 9 insertions(+), 8 deletions(-)

diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c b/drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c
index dd0c3f2..e5eb8d2 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c
@@ -1888,12 +1888,11 @@ static int bnxt_firmware_reset(struct net_device *dev,
 	return bnxt_hwrm_firmware_reset(dev, proc_type, self_reset, flags);
 }
 
-static int bnxt_firmware_reset_chip(struct net_device *dev)
+static int bnxt_firmware_reset_chip(struct net_device *dev, bool hot_reset)
 {
-	struct bnxt *bp = netdev_priv(dev);
 	u8 flags = 0;
 
-	if (bp->fw_cap & BNXT_FW_CAP_HOT_RESET)
+	if (hot_reset)
 		flags = FW_RESET_REQ_FLAGS_RESET_GRACEFUL;
 
 	return bnxt_hwrm_firmware_reset(dev,
@@ -3082,7 +3081,7 @@ static void bnxt_self_test(struct net_device *dev, struct ethtool_test *etest,
 static int bnxt_reset(struct net_device *dev, u32 *flags)
 {
 	struct bnxt *bp = netdev_priv(dev);
-	bool reload = false;
+	bool reload = false, hot_reset;
 	u32 req = *flags;
 
 	if (!req)
@@ -3093,8 +3092,10 @@ static int bnxt_reset(struct net_device *dev, u32 *flags)
 		return -EOPNOTSUPP;
 	}
 
-	if (pci_vfs_assigned(bp->pdev) &&
-	    !(bp->fw_cap & BNXT_FW_CAP_HOT_RESET)) {
+	if (bnxt_hwrm_get_hot_reset(bp, &hot_reset))
+		hot_reset = !!(bp->fw_cap & BNXT_FW_CAP_HOT_RESET);
+
+	if (pci_vfs_assigned(bp->pdev) && !hot_reset) {
 		netdev_err(dev,
 			   "Reset not allowed when VFs are assigned to VMs\n");
 		return -EBUSY;
@@ -3103,9 +3104,9 @@ static int bnxt_reset(struct net_device *dev, u32 *flags)
 	if ((req & BNXT_FW_RESET_CHIP) == BNXT_FW_RESET_CHIP) {
 		/* This feature is not supported in older firmware versions */
 		if (bp->hwrm_spec_code >= 0x10803) {
-			if (!bnxt_firmware_reset_chip(dev)) {
+			if (!bnxt_firmware_reset_chip(dev, hot_reset)) {
 				netdev_info(dev, "Firmware reset request successful.\n");
-				if (!(bp->fw_cap & BNXT_FW_CAP_HOT_RESET))
+				if (!hot_reset)
 					reload = true;
 				*flags &= ~BNXT_FW_RESET_CHIP;
 			}
-- 
1.8.3.1


Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2F77F1C34E8
	for <lists+netdev@lfdr.de>; Mon,  4 May 2020 10:51:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728399AbgEDIvP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 4 May 2020 04:51:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55888 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728403AbgEDIvN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 4 May 2020 04:51:13 -0400
Received: from mail-pl1-x641.google.com (mail-pl1-x641.google.com [IPv6:2607:f8b0:4864:20::641])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7736EC061A0E
        for <netdev@vger.kernel.org>; Mon,  4 May 2020 01:51:13 -0700 (PDT)
Received: by mail-pl1-x641.google.com with SMTP id s10so6541557plr.1
        for <netdev@vger.kernel.org>; Mon, 04 May 2020 01:51:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=ukO7xCfi57MbIdpZmphGNI+0Z1Oe5f/a95XRojt32rE=;
        b=MdFOg67Oc/ng0zY4NacsAms6LdC4RgrGb7l2HrJ0px11x0yDoEJvMPxZBSgF2Xx2pt
         /Pe+K+8aHJ0RbbsMTQnzufSKys5NMoDRoyVXNPhFu8l69sS7XAdDcfWkhrkw7j5PnJW9
         ioyGOTI4YfU7z6znrfY3d8OygBpjacFaO1MX4=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=ukO7xCfi57MbIdpZmphGNI+0Z1Oe5f/a95XRojt32rE=;
        b=LBoGVzLjpoPd49dvpO0QJjYgmvA6QCPx02gdQ54yQCN8txV5888zwgUyS3ScVmadbw
         4XGbg+WvsLAm11TNGrUduHNbHbosWStQCgHDV2x9Ph9OEWkkolLNI4FovfN18Ih94kv5
         C94P3Mpo6myXY4fFR5860VaCpUaUTglLgij4ih3CVDnTD0lpRgP107P9BG8y007/D76H
         BvQ7k2z4ccwF0rVysB73kDEK+q0HIi3Fh1KR6eOCBCcAeYrjIMQN2LmTxkchI8xE+Q1J
         /o8+QzEul8vGPG/zMPOceeK6l4LFmOrBKygaXPBs/xNkNHJmUjJULOXwEd+bA6l/t2n8
         ZpcA==
X-Gm-Message-State: AGi0PuaVHZvZUNadHM0YTvDVnupLSBdovOLi4hn0u8mNNJMvzhdiI58s
        SVVhmVc7JbFk1FwOWyUOfBjlyjfDRbs=
X-Google-Smtp-Source: APiQypKg36lNDe0oqh79CfxNRfEjFapIzpBvo7p2XkCFdGT0Vafb1t7fqDqJDlsjtEGrWQ8bmDDEfg==
X-Received: by 2002:a17:902:fe14:: with SMTP id g20mr17028748plj.330.1588582272992;
        Mon, 04 May 2020 01:51:12 -0700 (PDT)
Received: from localhost.swdvt.lab.broadcom.com ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id x193sm8754088pfd.54.2020.05.04.01.51.11
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 04 May 2020 01:51:12 -0700 (PDT)
From:   Michael Chan <michael.chan@broadcom.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, Edwin Peer <edwin.peer@broadcom.com>
Subject: [PATCH net-next 08/15] bnxt_en: Improve kernel log messages related to ethtool reset.
Date:   Mon,  4 May 2020 04:50:34 -0400
Message-Id: <1588582241-31066-9-git-send-email-michael.chan@broadcom.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1588582241-31066-1-git-send-email-michael.chan@broadcom.com>
References: <1588582241-31066-1-git-send-email-michael.chan@broadcom.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Edwin Peer <edwin.peer@broadcom.com>

Kernel log messages for failed AP reset commands should be suppressed.
These are expected to fail on devices that do not have an AP.  Add
missing driver reload message after AP reset and log it in a common
way without duplication.

Signed-off-by: Edwin Peer <edwin.peer@broadcom.com>
Signed-off-by: Michael Chan <michael.chan@broadcom.com>
---
 drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c | 18 ++++++++++++++----
 1 file changed, 14 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c b/drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c
index 9937c21..ad68bc3 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c
@@ -1762,9 +1762,14 @@ static int bnxt_hwrm_firmware_reset(struct net_device *dev, u8 proc_type,
 	req.selfrst_status = self_reset;
 	req.flags = flags;
 
-	rc = hwrm_send_message(bp, &req, sizeof(req), HWRM_CMD_TIMEOUT);
-	if (rc == -EACCES)
-		bnxt_print_admin_err(bp);
+	if (proc_type == FW_RESET_REQ_EMBEDDED_PROC_TYPE_AP) {
+		rc = hwrm_send_message_silent(bp, &req, sizeof(req),
+					      HWRM_CMD_TIMEOUT);
+	} else {
+		rc = hwrm_send_message(bp, &req, sizeof(req), HWRM_CMD_TIMEOUT);
+		if (rc == -EACCES)
+			bnxt_print_admin_err(bp);
+	}
 	return rc;
 }
 
@@ -2999,6 +3004,7 @@ static void bnxt_self_test(struct net_device *dev, struct ethtool_test *etest,
 static int bnxt_reset(struct net_device *dev, u32 *flags)
 {
 	struct bnxt *bp = netdev_priv(dev);
+	bool reload = false;
 	u32 req = *flags;
 
 	if (!req)
@@ -3022,7 +3028,7 @@ static int bnxt_reset(struct net_device *dev, u32 *flags)
 			if (!bnxt_firmware_reset_chip(dev)) {
 				netdev_info(dev, "Firmware reset request successful.\n");
 				if (!(bp->fw_cap & BNXT_FW_CAP_HOT_RESET))
-					netdev_info(dev, "Reload driver to complete reset\n");
+					reload = true;
 				*flags &= ~BNXT_FW_RESET_CHIP;
 			}
 		} else if (req == BNXT_FW_RESET_CHIP) {
@@ -3035,6 +3041,7 @@ static int bnxt_reset(struct net_device *dev, u32 *flags)
 		if (bp->hwrm_spec_code >= 0x10803) {
 			if (!bnxt_firmware_reset_ap(dev)) {
 				netdev_info(dev, "Reset application processor successful.\n");
+				reload = true;
 				*flags &= ~BNXT_FW_RESET_AP;
 			}
 		} else if (req == BNXT_FW_RESET_AP) {
@@ -3042,6 +3049,9 @@ static int bnxt_reset(struct net_device *dev, u32 *flags)
 		}
 	}
 
+	if (reload)
+		netdev_info(dev, "Reload driver to complete reset\n");
+
 	return 0;
 }
 
-- 
2.5.1


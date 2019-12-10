Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CD0A3118184
	for <lists+netdev@lfdr.de>; Tue, 10 Dec 2019 08:49:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726187AbfLJHth (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Dec 2019 02:49:37 -0500
Received: from mail-pl1-f196.google.com ([209.85.214.196]:46996 "EHLO
        mail-pl1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726071AbfLJHth (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Dec 2019 02:49:37 -0500
Received: by mail-pl1-f196.google.com with SMTP id k20so6945454pll.13
        for <netdev@vger.kernel.org>; Mon, 09 Dec 2019 23:49:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=9vjyfI3RjyTqPju2Zd+2ihLXTmCwe2TTL4EBpd1pjI4=;
        b=Z0jOhefVbe+ch/tU7E9Hxa1oZBo1EUEFrVvRgtvYJVhLYS7YDkKTcHjigugNGtdvUy
         VlDwuPbcZ2SyUtpX16V/wMZDgSkOkBEtP1UN0zeuMSyMENZIzpumjEJWQdezX0ptbUtE
         uUKEv40fD9W3dc36gng4x0qAyTGRziCLq+p98=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=9vjyfI3RjyTqPju2Zd+2ihLXTmCwe2TTL4EBpd1pjI4=;
        b=b76b/9ZTmh0W68VWt3pAOgVKCPiauHPjCM3EtgEu6loGwLNtxyk6azTIasPTIIeYhB
         SFeTcNWe3uVxrjUbPg1OaWAiC35P7xVJgNYSwHTQ6Nnw+LmV0OT5nMuAKmH4lcAIRYPr
         jtOAHDKx7A+ws4xevum0Gk0mWn3LgFpP6vAIHvU5f/X/WebEGDwkts5w7QR2TnSsmuez
         qxmAWWCAhsaGvORVk+fJgI/Ee5G8P0K2ToRd4jhpwUi+80OeIXZlWq+JX2uGfQMnqsoh
         Y3YOpxUcNfOviH6AnTprxPe7sN6rLOZ/7gCn6GiB+QPwddHvJ6Vf6OCqUA1c/5tSXVsj
         /btQ==
X-Gm-Message-State: APjAAAUAsc7xzhY7RuLtybZXTkgxJrJwEX9c1X6zE3j9RRDw/RSlekx4
        WvXcFj/T2ZtH+Pml3ZfHggCyyeT9gFI=
X-Google-Smtp-Source: APXvYqyDoz2qbhQ80bglAITesCxfUJ7A0eLj/p1p+SBmEPaODsdPLvDQmaL9DGYTH957BvjXq9ECdQ==
X-Received: by 2002:a17:902:aa49:: with SMTP id c9mr34491030plr.220.1575964176555;
        Mon, 09 Dec 2019 23:49:36 -0800 (PST)
Received: from localhost.swdvt.lab.broadcom.com ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id z29sm2108101pge.21.2019.12.09.23.49.34
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 09 Dec 2019 23:49:36 -0800 (PST)
From:   Michael Chan <michael.chan@broadcom.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org,
        Vasundhara Volam <vasundhara-v.volam@broadcom.com>
Subject: [PATCH net 5/7] bnxt_en: Remove unnecessary NULL checks for fw_health
Date:   Tue, 10 Dec 2019 02:49:11 -0500
Message-Id: <1575964153-11299-6-git-send-email-michael.chan@broadcom.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1575964153-11299-1-git-send-email-michael.chan@broadcom.com>
References: <1575964153-11299-1-git-send-email-michael.chan@broadcom.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vasundhara Volam <vasundhara-v.volam@broadcom.com>

After fixing the allocation of bp->fw_health in the previous patch,
the driver will not go through the fw reset and recovery code paths
if bp->fw_health allocation fails.  So we can now remove the
unnecessary NULL checks.

Signed-off-by: Vasundhara Volam <vasundhara-v.volam@broadcom.com>
Signed-off-by: Michael Chan <michael.chan@broadcom.com>
---
 drivers/net/ethernet/broadcom/bnxt/bnxt.c         | 6 ++----
 drivers/net/ethernet/broadcom/bnxt/bnxt_devlink.c | 6 +-----
 2 files changed, 3 insertions(+), 9 deletions(-)

diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt.c b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
index d6a5fce..2a100ff 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
@@ -9989,8 +9989,7 @@ static void bnxt_fw_health_check(struct bnxt *bp)
 	struct bnxt_fw_health *fw_health = bp->fw_health;
 	u32 val;
 
-	if (!fw_health || !fw_health->enabled ||
-	    test_bit(BNXT_STATE_IN_FW_RESET, &bp->state))
+	if (!fw_health->enabled || test_bit(BNXT_STATE_IN_FW_RESET, &bp->state))
 		return;
 
 	if (fw_health->tmr_counter) {
@@ -10768,8 +10767,7 @@ static void bnxt_fw_reset_task(struct work_struct *work)
 		bnxt_queue_fw_reset_work(bp, bp->fw_reset_min_dsecs * HZ / 10);
 		return;
 	case BNXT_FW_RESET_STATE_ENABLE_DEV:
-		if (test_bit(BNXT_STATE_FW_FATAL_COND, &bp->state) &&
-		    bp->fw_health) {
+		if (test_bit(BNXT_STATE_FW_FATAL_COND, &bp->state)) {
 			u32 val;
 
 			val = bnxt_fw_health_readl(bp,
diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt_devlink.c b/drivers/net/ethernet/broadcom/bnxt/bnxt_devlink.c
index acb2dd6..1e7c7c3 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt_devlink.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt_devlink.c
@@ -39,11 +39,10 @@ static int bnxt_fw_reporter_diagnose(struct devlink_health_reporter *reporter,
 				     struct netlink_ext_ack *extack)
 {
 	struct bnxt *bp = devlink_health_reporter_priv(reporter);
-	struct bnxt_fw_health *health = bp->fw_health;
 	u32 val, health_status;
 	int rc;
 
-	if (!health || test_bit(BNXT_STATE_IN_FW_RESET, &bp->state))
+	if (test_bit(BNXT_STATE_IN_FW_RESET, &bp->state))
 		return 0;
 
 	val = bnxt_fw_health_readl(bp, BNXT_FW_HEALTH_REG);
@@ -185,9 +184,6 @@ void bnxt_devlink_health_report(struct bnxt *bp, unsigned long event)
 	struct bnxt_fw_health *fw_health = bp->fw_health;
 	struct bnxt_fw_reporter_ctx fw_reporter_ctx;
 
-	if (!fw_health)
-		return;
-
 	fw_reporter_ctx.sp_event = event;
 	switch (event) {
 	case BNXT_FW_RESET_NOTIFY_SP_EVENT:
-- 
2.5.1


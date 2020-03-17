Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3DF25188904
	for <lists+netdev@lfdr.de>; Tue, 17 Mar 2020 16:19:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726875AbgCQPTo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Mar 2020 11:19:44 -0400
Received: from mail-wr1-f66.google.com ([209.85.221.66]:33528 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726112AbgCQPTo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Mar 2020 11:19:44 -0400
Received: by mail-wr1-f66.google.com with SMTP id a25so26212076wrd.0
        for <netdev@vger.kernel.org>; Tue, 17 Mar 2020 08:19:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=74uQK3ncqYdXbh/SiunUd28g7s2N2bIE0PwTtUowhe0=;
        b=TTjUd8bOKKQDANdeQXklD0siggL1Ux9ZWMYVWLmTGJmvNWhZgGGboEcQXJ+HXTyVf9
         SKfRMEWWeFLnQTJhfkBKUypgojuAx7+vj+cONrKlG7nEgaMCHiH0mh5b7H4bRW5pHa/I
         XeSbubk0skyHTOHssiXf8YYtK+vyHYRqLIsY4=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=74uQK3ncqYdXbh/SiunUd28g7s2N2bIE0PwTtUowhe0=;
        b=bK4qw3j4XN7a1bv0FMnbT4YPjG5TQkqGUO/Of76+1BOZNwzhks3Ubaf29GHoafT+If
         jc62jRYmvJmtkukcGFyXNiSNxFVCuwCXb8KjeRFlx1bfoWUl5dwEBVbjgQMZgZBBIIO+
         /K9yBCt8BGQ64biH+1Pidq0VkwDVKHB1miuqsCOJrIDUNL4zBvp66U4bsftiUswWXBVt
         4tCfmNHab3gXg19Hk2B1j1uJYGw2ohk8RjeGbfabHXQ4bk43FPjYeV4uJMl9+7urg5+o
         BpK0ggRbo06sC3k8pLAPP7prVTeG5EkQsyT8qMKHQJeecpLwDdbYm0gNjQONB3rhqAKW
         xsEg==
X-Gm-Message-State: ANhLgQ2nWZ0I5PelYe3nkki5f3wvtGD9RFrUX0i4V5vyPdbbqmMzNO0Z
        XmqT38fNEh/dH5L44A0hjeZ0WA==
X-Google-Smtp-Source: ADFU+vu17pYOKEClBVzf+ziuAmCxL+8uj4m1EORSsucWqpEZjswzssWugiRHC3o2Ak4KbJ5VwCC7XQ==
X-Received: by 2002:adf:f082:: with SMTP id n2mr6944734wro.207.1584458382266;
        Tue, 17 Mar 2020 08:19:42 -0700 (PDT)
Received: from lxpurley1.dhcp.broadcom.net ([192.19.234.250])
        by smtp.gmail.com with ESMTPSA id z19sm4363534wma.41.2020.03.17.08.19.39
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 17 Mar 2020 08:19:41 -0700 (PDT)
From:   Vasundhara Volam <vasundhara-v.volam@broadcom.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, Pavan Chebbi <pavan.chebbi@broadcom.com>,
        Vasundhara Volam <vasundhara-v.volam@broadcom.com>,
        Michael Chan <michael.chan@broadcom.com>
Subject: [PATCH net-next 11/11] bnxt_en: Use "enable_ecn" devlink param
Date:   Tue, 17 Mar 2020 20:47:26 +0530
Message-Id: <1584458246-29370-5-git-send-email-vasundhara-v.volam@broadcom.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1584458246-29370-1-git-send-email-vasundhara-v.volam@broadcom.com>
References: <1584458246-29370-1-git-send-email-vasundhara-v.volam@broadcom.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Pavan Chebbi <pavan.chebbi@broadcom.com>

Add support for "enable_ecn" devlink parameter with configuration
mode as permanent and runtime. Also update bnxt.rst documentation
file.

Signed-off-by: Pavan Chebbi <pavan.chebbi@broadcom.com>
Signed-off-by: Vasundhara Volam <vasundhara-v.volam@broadcom.com>
Signed-off-by: Michael Chan <michael.chan@broadcom.com>
---
 Documentation/networking/devlink/bnxt.rst         |  2 +
 drivers/net/ethernet/broadcom/bnxt/bnxt_devlink.c | 81 ++++++++++++++++++++---
 drivers/net/ethernet/broadcom/bnxt/bnxt_devlink.h |  1 +
 3 files changed, 73 insertions(+), 11 deletions(-)

diff --git a/Documentation/networking/devlink/bnxt.rst b/Documentation/networking/devlink/bnxt.rst
index 17b6522..5541826 100644
--- a/Documentation/networking/devlink/bnxt.rst
+++ b/Documentation/networking/devlink/bnxt.rst
@@ -22,6 +22,8 @@ Parameters
      - Permanent
    * - ``msix_vec_per_pf_min``
      - Permanent
+   * - ``enable_ecn``
+     - Permanent, runtime
 
 The ``bnxt`` driver also implements the following driver-specific
 parameters.
diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt_devlink.c b/drivers/net/ethernet/broadcom/bnxt/bnxt_devlink.c
index 6065602..53274be 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt_devlink.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt_devlink.c
@@ -312,6 +312,8 @@ enum bnxt_dl_param_id {
 	 NVM_OFF_MSIX_VEC_PER_PF_MAX, BNXT_NVM_SHARED_CFG, 10, 4},
 	{DEVLINK_PARAM_GENERIC_ID_MSIX_VEC_PER_PF_MIN,
 	 NVM_OFF_MSIX_VEC_PER_PF_MIN, BNXT_NVM_SHARED_CFG, 7, 4},
+	{DEVLINK_PARAM_GENERIC_ID_ENABLE_ECN, NVM_OFF_ENABLE_ECN,
+	 BNXT_NVM_SHARED_CFG, 1, 1},
 	{BNXT_DEVLINK_PARAM_ID_GRE_VER_CHECK, NVM_OFF_DIS_GRE_VER_CHECK,
 	 BNXT_NVM_SHARED_CFG, 1, 1},
 };
@@ -626,15 +628,42 @@ static int bnxt_hwrm_nvm_req(struct bnxt *bp, u32 param_id, void *msg,
 static int bnxt_dl_nvm_param_get(struct devlink *dl, u32 id,
 				 struct devlink_param_gset_ctx *ctx)
 {
-	struct hwrm_nvm_get_variable_input req = {0};
 	struct bnxt *bp = bnxt_get_bp_from_dl(dl);
 	int rc;
 
-	bnxt_hwrm_cmd_hdr_init(bp, &req, HWRM_NVM_GET_VARIABLE, -1, -1);
-	rc = bnxt_hwrm_nvm_req(bp, id, &req, sizeof(req), &ctx->val);
-	if (!rc)
-		if (id == BNXT_DEVLINK_PARAM_ID_GRE_VER_CHECK)
-			ctx->val.vbool = !ctx->val.vbool;
+	if (ctx->cmode == DEVLINK_PARAM_CMODE_PERMANENT) {
+		struct hwrm_nvm_get_variable_input req = {0};
+
+		bnxt_hwrm_cmd_hdr_init(bp, &req, HWRM_NVM_GET_VARIABLE, -1, -1);
+		rc = bnxt_hwrm_nvm_req(bp, id, &req, sizeof(req), &ctx->val);
+		if (!rc)
+			if (id == BNXT_DEVLINK_PARAM_ID_GRE_VER_CHECK)
+				ctx->val.vbool = !ctx->val.vbool;
+	} else if (ctx->cmode == DEVLINK_PARAM_CMODE_RUNTIME) {
+		switch (id) {
+		case DEVLINK_PARAM_GENERIC_ID_ENABLE_ECN:
+		{
+			struct hwrm_fw_ecn_qcfg_input req = {0};
+			struct hwrm_fw_ecn_qcfg_output *resp =
+				bp->hwrm_cmd_resp_addr;
+
+			bnxt_hwrm_cmd_hdr_init(bp, &req, HWRM_FW_ECN_QCFG,
+					       -1, -1);
+			rc = hwrm_send_message(bp, &req, sizeof(req),
+					       HWRM_CMD_TIMEOUT);
+			if (!rc) {
+				if (resp->flags &
+				    FW_ECN_QCFG_RESP_FLAGS_ENABLE_ECN)
+					ctx->val.vbool = true;
+			}
+			break;
+		}
+		default:
+			netdev_err(bp->dev, "Unsupported devlink parameter\n");
+			rc = -EOPNOTSUPP;
+			break;
+		}
+	}
 
 	return rc;
 }
@@ -642,15 +671,40 @@ static int bnxt_dl_nvm_param_get(struct devlink *dl, u32 id,
 static int bnxt_dl_nvm_param_set(struct devlink *dl, u32 id,
 				 struct devlink_param_gset_ctx *ctx)
 {
-	struct hwrm_nvm_set_variable_input req = {0};
 	struct bnxt *bp = bnxt_get_bp_from_dl(dl);
+	int rc;
 
-	bnxt_hwrm_cmd_hdr_init(bp, &req, HWRM_NVM_SET_VARIABLE, -1, -1);
+	if (ctx->cmode == DEVLINK_PARAM_CMODE_PERMANENT) {
+		struct hwrm_nvm_set_variable_input req = {0};
 
-	if (id == BNXT_DEVLINK_PARAM_ID_GRE_VER_CHECK)
-		ctx->val.vbool = !ctx->val.vbool;
+		if (id == BNXT_DEVLINK_PARAM_ID_GRE_VER_CHECK)
+			ctx->val.vbool = !ctx->val.vbool;
 
-	return bnxt_hwrm_nvm_req(bp, id, &req, sizeof(req), &ctx->val);
+		bnxt_hwrm_cmd_hdr_init(bp, &req, HWRM_NVM_SET_VARIABLE, -1, -1);
+		rc = bnxt_hwrm_nvm_req(bp, id, &req, sizeof(req), &ctx->val);
+	} else if (ctx->cmode == DEVLINK_PARAM_CMODE_RUNTIME) {
+		switch (id) {
+		case DEVLINK_PARAM_GENERIC_ID_ENABLE_ECN:
+		{
+			struct hwrm_fw_ecn_cfg_input req = {0};
+
+			bnxt_hwrm_cmd_hdr_init(bp, &req, HWRM_FW_ECN_CFG,
+					       -1, -1);
+			if (ctx->val.vbool)
+				req.flags =
+				cpu_to_le32(FW_ECN_CFG_REQ_FLAGS_ENABLE_ECN);
+			rc = hwrm_send_message(bp, &req, sizeof(req),
+					       HWRM_CMD_TIMEOUT);
+			break;
+		}
+		default:
+			netdev_err(bp->dev, "Unsupported devlink parameter\n");
+			rc = -EOPNOTSUPP;
+			break;
+		}
+	}
+
+	return rc;
 }
 
 static int bnxt_dl_msix_validate(struct devlink *dl, u32 id,
@@ -690,6 +744,11 @@ static int bnxt_dl_msix_validate(struct devlink *dl, u32 id,
 			      BIT(DEVLINK_PARAM_CMODE_PERMANENT),
 			      bnxt_dl_nvm_param_get, bnxt_dl_nvm_param_set,
 			      bnxt_dl_msix_validate),
+	DEVLINK_PARAM_GENERIC(ENABLE_ECN,
+			      BIT(DEVLINK_PARAM_CMODE_PERMANENT) |
+			      BIT(DEVLINK_PARAM_CMODE_RUNTIME),
+			      bnxt_dl_nvm_param_get, bnxt_dl_nvm_param_set,
+			      NULL),
 	DEVLINK_PARAM_DRIVER(BNXT_DEVLINK_PARAM_ID_GRE_VER_CHECK,
 			     "gre_ver_check", DEVLINK_PARAM_TYPE_BOOL,
 			     BIT(DEVLINK_PARAM_CMODE_PERMANENT),
diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt_devlink.h b/drivers/net/ethernet/broadcom/bnxt/bnxt_devlink.h
index e720b1d..71ba65a 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt_devlink.h
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt_devlink.h
@@ -38,6 +38,7 @@ static inline void bnxt_link_bp_to_dl(struct bnxt *bp, struct devlink *dl)
 #define NVM_OFF_MSIX_VEC_PER_PF_MIN	114
 #define NVM_OFF_IGNORE_ARI		164
 #define NVM_OFF_DIS_GRE_VER_CHECK	171
+#define NVM_OFF_ENABLE_ECN		173
 #define NVM_OFF_ENABLE_SRIOV		401
 #define NVM_OFF_NVM_CFG_VER		602
 
-- 
1.8.3.1


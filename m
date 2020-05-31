Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 986F31E9604
	for <lists+netdev@lfdr.de>; Sun, 31 May 2020 09:07:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387432AbgEaHHA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 31 May 2020 03:07:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52014 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387407AbgEaHG7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 31 May 2020 03:06:59 -0400
Received: from mail-wm1-x343.google.com (mail-wm1-x343.google.com [IPv6:2a00:1450:4864:20::343])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 97AA6C05BD43
        for <netdev@vger.kernel.org>; Sun, 31 May 2020 00:06:59 -0700 (PDT)
Received: by mail-wm1-x343.google.com with SMTP id f185so8238309wmf.3
        for <netdev@vger.kernel.org>; Sun, 31 May 2020 00:06:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=T2V/Yn57ra8AwU/cESpZtKBEP4Kg27ZBno5kLaCrvLo=;
        b=iHtqaX4yKGR8EO0AJj10QWDdJ0L+YCSmoQGYdZ6NQz0SgGPmSa6tZhLC8YRCRH9lsL
         7b4bkqEL3BDqjm6wcwvLwIeKQbvuz9eJ92y9X2SH1s5UAxy/UWK7iQviaTq8/FZR62gl
         5Tfcs05dm+Bg6PvjIxxt3/PA+d6OBxSCAsR/I=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=T2V/Yn57ra8AwU/cESpZtKBEP4Kg27ZBno5kLaCrvLo=;
        b=eEkdJ+1qQoLUlOEo/0hmsvB9uODiY92YaJS2/7gucH0n1l2aPcqsO2Kh0UcrTyYdqO
         GycviWIZDaQAObdG2/WOxrTsBeHCF64jAag3ozIIXCAdtvmVyga+Q3naxa8PCD9/ZQtm
         YXYmR6CMqhGk73Aje/NPiJz8VspfWajPvHSneB04ZdR8xQ2yU53PVPRXCIMwO2aYIEVC
         /EqVjQpzwKL7u9g7QXj183ADIuOk/wV+yMzpmRQdwok/8qXfzsjtaBCYj9fJKYVwoQgV
         T35lB3mmQX9LtGdfCPu1An1+xY9KKgDIj/GLfNqwZoPjfKhl0Lyl7WjvvsQkKj9/SSMc
         cxlg==
X-Gm-Message-State: AOAM532nQ7XWq3af4ZcDkwaOH/exus3OvUMojlamgXwcO+ghnDEZoDZr
        Q2abNCRcHCaTansS8Qw/ywjvDA==
X-Google-Smtp-Source: ABdhPJyWxmweHYW45M4KjcCi8VQ4Va8UXAwwLBAll3Cd3uOdEKl+hNBSkJWBDAS6cf/AJmZjE3Eudg==
X-Received: by 2002:a7b:c212:: with SMTP id x18mr6980739wmi.119.1590908818127;
        Sun, 31 May 2020 00:06:58 -0700 (PDT)
Received: from lxpurley1.dhcp.broadcom.net ([192.19.234.250])
        by smtp.gmail.com with ESMTPSA id 5sm4828731wrr.5.2020.05.31.00.06.56
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 31 May 2020 00:06:57 -0700 (PDT)
From:   Vasundhara Volam <vasundhara-v.volam@broadcom.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, michael.chan@broadcom.com,
        Vasundhara Volam <vasundhara-v.volam@broadcom.com>
Subject: [PATCH v3 net-next 5/6] bnxt_en: Use 'allow_live_dev_reset' devlink parameter.
Date:   Sun, 31 May 2020 12:33:44 +0530
Message-Id: <1590908625-10952-6-git-send-email-vasundhara-v.volam@broadcom.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1590908625-10952-1-git-send-email-vasundhara-v.volam@broadcom.com>
References: <1590908625-10952-1-git-send-email-vasundhara-v.volam@broadcom.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This parameter allows the user to prevent live reset of the device
temporarily by setting it to false.
For example, if the host is running a mission critical application,
user can set this parameter to false until the application has
completed, to avoid a potential device reset disrupting it.

Signed-off-by: Vasundhara Volam <vasundhara-v.volam@broadcom.com>
Signed-off-by: Michael Chan <michael.chan@broadcom.com>
---
v2->v3: Rename parameter name to "allow_live_dev_reset".
- Moved permanent configuration mode code to a separate patch as the
param is renamed to "enable_live_dev_reset".
- Rename the get/set callbacks of the param accordingly.
- Moved the documentation completely to devlink-params.rst file.
---
 Documentation/networking/devlink/bnxt.rst         |  2 ++
 drivers/net/ethernet/broadcom/bnxt/bnxt.c         | 28 ++++++++++++++-
 drivers/net/ethernet/broadcom/bnxt/bnxt.h         |  2 ++
 drivers/net/ethernet/broadcom/bnxt/bnxt_devlink.c | 43 +++++++++++++++++++++++
 4 files changed, 74 insertions(+), 1 deletion(-)

diff --git a/Documentation/networking/devlink/bnxt.rst b/Documentation/networking/devlink/bnxt.rst
index ae0a69d..5573663 100644
--- a/Documentation/networking/devlink/bnxt.rst
+++ b/Documentation/networking/devlink/bnxt.rst
@@ -24,6 +24,8 @@ Parameters
      - Permanent
    * - ``enable_live_dev_reset``
      - Permanent
+   * - ``allow_live_dev_reset``
+     - Runtime
 
 The ``bnxt`` driver also implements the following driver-specific
 parameters.
diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt.c b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
index f86b621..535fe8f 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
@@ -6955,7 +6955,7 @@ static int __bnxt_hwrm_func_qcaps(struct bnxt *bp)
 	struct hwrm_func_qcaps_input req = {0};
 	struct hwrm_func_qcaps_output *resp = bp->hwrm_cmd_resp_addr;
 	struct bnxt_hw_resc *hw_resc = &bp->hw_resc;
-	u32 flags;
+	u32 flags, flags_ext;
 
 	bnxt_hwrm_cmd_hdr_init(bp, &req, HWRM_FUNC_QCAPS, -1, -1);
 	req.fid = cpu_to_le16(0xffff);
@@ -6985,6 +6985,10 @@ static int __bnxt_hwrm_func_qcaps(struct bnxt *bp)
 	if (flags & FUNC_QCAPS_RESP_FLAGS_PUSH_MODE_SUPPORTED)
 		bp->tx_push_thresh = BNXT_TX_PUSH_THRESH;
 
+	flags_ext = le32_to_cpu(resp->flags_ext);
+	if (flags_ext & FUNC_QCAPS_RESP_FLAGS_EXT_HOT_RESET_IF_SUPPORT)
+		bp->fw_cap |= BNXT_FW_CAP_HOT_RESET_IF_SUPPORT;
+
 	hw_resc->max_rsscos_ctxs = le16_to_cpu(resp->max_rsscos_ctx);
 	hw_resc->max_cp_rings = le16_to_cpu(resp->max_cmpl_rings);
 	hw_resc->max_tx_rings = le16_to_cpu(resp->max_tx_rings);
@@ -8773,6 +8777,28 @@ static int bnxt_hwrm_shutdown_link(struct bnxt *bp)
 
 static int bnxt_fw_init_one(struct bnxt *bp);
 
+int bnxt_hwrm_get_hot_reset(struct bnxt *bp, bool *hot_reset_allowed)
+{
+	struct hwrm_func_qcfg_output *resp = bp->hwrm_cmd_resp_addr;
+	struct hwrm_func_qcfg_input req = {0};
+	int rc;
+
+	if (!(bp->fw_cap & BNXT_FW_CAP_HOT_RESET_IF_SUPPORT)) {
+		*hot_reset_allowed = !!(bp->fw_cap & BNXT_FW_CAP_HOT_RESET);
+		return 0;
+	}
+
+	bnxt_hwrm_cmd_hdr_init(bp, &req, HWRM_FUNC_QCFG, -1, -1);
+	req.fid = cpu_to_le16(0xffff);
+	mutex_lock(&bp->hwrm_cmd_lock);
+	rc = _hwrm_send_message(bp, &req, sizeof(req), HWRM_CMD_TIMEOUT);
+	if (!rc)
+		*hot_reset_allowed = !!(le16_to_cpu(resp->flags) &
+					FUNC_QCFG_RESP_FLAGS_HOT_RESET_ALLOWED);
+	mutex_unlock(&bp->hwrm_cmd_lock);
+	return rc;
+}
+
 static int bnxt_hwrm_if_change(struct bnxt *bp, bool up)
 {
 	struct hwrm_func_drv_if_change_output *resp = bp->hwrm_cmd_resp_addr;
diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt.h b/drivers/net/ethernet/broadcom/bnxt/bnxt.h
index c04ac4a..fd6592e 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.h
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.h
@@ -1710,6 +1710,7 @@ struct bnxt {
 	#define BNXT_FW_CAP_ERR_RECOVER_RELOAD		0x00100000
 	#define BNXT_FW_CAP_HOT_RESET			0x00200000
 	#define BNXT_FW_CAP_SHARED_PORT_CFG		0x00400000
+	#define BNXT_FW_CAP_HOT_RESET_IF_SUPPORT	0x08000000
 
 #define BNXT_NEW_RM(bp)		((bp)->fw_cap & BNXT_FW_CAP_NEW_RM)
 	u32			hwrm_spec_code;
@@ -2062,5 +2063,6 @@ int bnxt_get_port_parent_id(struct net_device *dev,
 			    struct netdev_phys_item_id *ppid);
 void bnxt_dim_work(struct work_struct *work);
 int bnxt_hwrm_set_ring_coal(struct bnxt *bp, struct bnxt_napi *bnapi);
+int bnxt_hwrm_get_hot_reset(struct bnxt *bp, bool *hot_reset_allowed);
 
 #endif
diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt_devlink.c b/drivers/net/ethernet/broadcom/bnxt/bnxt_devlink.c
index 3e1a4ef..da31351 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt_devlink.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt_devlink.c
@@ -620,6 +620,45 @@ static int bnxt_dl_msix_validate(struct devlink *dl, u32 id,
 	return 0;
 }
 
+static int bnxt_live_dev_reset_get(struct devlink *dl, u32 id,
+				   struct devlink_param_gset_ctx *ctx)
+{
+	struct bnxt *bp = bnxt_get_bp_from_dl(dl);
+
+	return bnxt_hwrm_get_hot_reset(bp, &ctx->val.vbool);
+}
+
+static int bnxt_live_dev_reset_set(struct devlink *dl, u32 id,
+				   struct devlink_param_gset_ctx *ctx)
+{
+	struct bnxt *bp = bnxt_get_bp_from_dl(dl);
+	struct hwrm_func_cfg_input req = {0};
+	bool hot_reset_allowed;
+	int rc;
+
+	if (!(bp->fw_cap & BNXT_FW_CAP_HOT_RESET_IF_SUPPORT))
+		return -EOPNOTSUPP;
+
+	bnxt_hwrm_cmd_hdr_init(bp, &req, HWRM_FUNC_CFG, -1, -1);
+	req.fid = cpu_to_le16(0xffff);
+	req.enables = cpu_to_le32(FUNC_CFG_REQ_ENABLES_HOT_RESET_IF_SUPPORT);
+	if (ctx->val.vbool)
+		req.flags = cpu_to_le32(FUNC_CFG_REQ_FLAGS_HOT_RESET_IF_EN_DIS);
+
+	rc = hwrm_send_message(bp, &req, sizeof(req), HWRM_CMD_TIMEOUT);
+	if (rc)
+		return rc;
+
+	rc = bnxt_hwrm_get_hot_reset(bp, &hot_reset_allowed);
+	if (rc)
+		return rc;
+
+	if (ctx->val.vbool && !hot_reset_allowed)
+		netdev_info(bp->dev, "Live reset enabled, but is disallowed as it is disabled on other interface(s) of this device.\n");
+
+	return 0;
+}
+
 static const struct devlink_param bnxt_dl_params[] = {
 	DEVLINK_PARAM_GENERIC(ENABLE_SRIOV,
 			      BIT(DEVLINK_PARAM_CMODE_PERMANENT),
@@ -646,6 +685,10 @@ static int bnxt_dl_msix_validate(struct devlink *dl, u32 id,
 			      BIT(DEVLINK_PARAM_CMODE_PERMANENT),
 			      bnxt_dl_nvm_param_get, bnxt_dl_nvm_param_set,
 			      NULL),
+	DEVLINK_PARAM_GENERIC(ALLOW_LIVE_DEV_RESET,
+			      BIT(DEVLINK_PARAM_CMODE_RUNTIME),
+			      bnxt_live_dev_reset_get, bnxt_live_dev_reset_set,
+			      NULL),
 };
 
 static const struct devlink_param bnxt_dl_port_params[] = {
-- 
1.8.3.1


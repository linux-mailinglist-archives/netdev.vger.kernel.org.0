Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4B0903DA9EA
	for <lists+netdev@lfdr.de>; Thu, 29 Jul 2021 19:18:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231710AbhG2RSI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Jul 2021 13:18:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46978 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229739AbhG2RR7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 29 Jul 2021 13:17:59 -0400
Received: from mail-ed1-x534.google.com (mail-ed1-x534.google.com [IPv6:2a00:1450:4864:20::534])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A4AB6C0613D5;
        Thu, 29 Jul 2021 10:17:54 -0700 (PDT)
Received: by mail-ed1-x534.google.com with SMTP id f13so9144830edq.13;
        Thu, 29 Jul 2021 10:17:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=83JzS4OeHeIiTINWZZZwZVAkdXfE28yihp7c6aPxoE8=;
        b=tfZ/H+TQuAgGwi4wE11UtgmCXAxZnlYN0QaeWWxTzG4BHAJjak26tz8xRV7kgytvdW
         jaWT41vjHWu+xNeFlnA+KfxoUgyCMmIbT1VQqr9C2HnEAE2Ag/tAAIhq/IdEE/J8G9KI
         sOAiXJSAh/EbrToSCUSib5tWJBAmiudNpA3YGsaC/LMrc32iqOc4j3a1vGY+LmxJy/ye
         JBmStBanXpepSDNxHIO5bAlyaIOBWy4quLs2b0hTcMYC/WP4iwtm0ZOV8iwuLZiEBi15
         5z2+QQENlZueb89+QuJTHpyZ3n1lvYUyUCd48hSEgg7x7Tpu28uBRPocL8fe7TVx6awQ
         zZtg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=83JzS4OeHeIiTINWZZZwZVAkdXfE28yihp7c6aPxoE8=;
        b=AEIuJgVOwd4PrTjLXahkwMXHOXoAxb4TAKJKHfk2zU0zmirJIlts1GfbYP9CMK7h7C
         498ks4sb3yt7DxYqutmkTlFsgRdNVPW7zkxgsrs6+t+o4vLGPSNAZF78IVM84E5DeuYW
         24L7L6MU9kR36NqBhst2CseGI2LCEZHkM/Ab345e9LQflKKibEC2psTr6cTLtUIR2Mci
         tjyQKmTV4ccZkOil6AyS+GKgmjTWP3piSINPCmABXmNet7OhST8WT1mQdhKLgrPfUq94
         8DWno3H8yDG/c8gApeqil6kdvM4MfO7ibDQgGgxOrrQgKr0aIICQbuupMpK/GetQulDj
         R3hA==
X-Gm-Message-State: AOAM530ZhFqaTgypQUj4EwkftJzNrDe+XWkITdtFTDrQuDt4IgDPQ70x
        jlnBrGQJNMnDPtqEG+zzehc=
X-Google-Smtp-Source: ABdhPJxmrvq/lYjReWP3A/lB+VzkWdQ+FoSXftjbX87F4tF02R0UCqXmF2cy1fP5U4l7wm04zOYhJg==
X-Received: by 2002:a05:6402:2283:: with SMTP id cw3mr7334881edb.87.1627579073131;
        Thu, 29 Jul 2021 10:17:53 -0700 (PDT)
Received: from yoga-910.localhost ([82.76.66.29])
        by smtp.gmail.com with ESMTPSA id df14sm1451612edb.90.2021.07.29.10.17.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 29 Jul 2021 10:17:52 -0700 (PDT)
From:   Ioana Ciornei <ciorneiioana@gmail.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     corbet@lwn.net, netdev@vger.kernel.org, linux-doc@vger.kernel.org,
        Ioana Ciornei <ioana.ciornei@nxp.com>
Subject: [PATCH net-next 5/9] dpaa2-switch: add API for setting up mirroring
Date:   Thu, 29 Jul 2021 20:18:57 +0300
Message-Id: <20210729171901.3211729-6-ciorneiioana@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210729171901.3211729-1-ciorneiioana@gmail.com>
References: <20210729171901.3211729-1-ciorneiioana@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ioana Ciornei <ioana.ciornei@nxp.com>

Add the necessary MC API for setting up and configuring the mirroring
feature on the DPSW DPAA2 object.

Signed-off-by: Ioana Ciornei <ioana.ciornei@nxp.com>
---
 .../net/ethernet/freescale/dpaa2/dpsw-cmd.h   | 19 +++++
 drivers/net/ethernet/freescale/dpaa2/dpsw.c   | 80 +++++++++++++++++++
 drivers/net/ethernet/freescale/dpaa2/dpsw.h   | 31 +++++++
 3 files changed, 130 insertions(+)

diff --git a/drivers/net/ethernet/freescale/dpaa2/dpsw-cmd.h b/drivers/net/ethernet/freescale/dpaa2/dpsw-cmd.h
index cb13e740f72b..397d55f2bd99 100644
--- a/drivers/net/ethernet/freescale/dpaa2/dpsw-cmd.h
+++ b/drivers/net/ethernet/freescale/dpaa2/dpsw-cmd.h
@@ -39,11 +39,16 @@
 #define DPSW_CMDID_GET_IRQ_STATUS           DPSW_CMD_ID(0x016)
 #define DPSW_CMDID_CLEAR_IRQ_STATUS         DPSW_CMD_ID(0x017)
 
+#define DPSW_CMDID_SET_REFLECTION_IF        DPSW_CMD_ID(0x022)
+
 #define DPSW_CMDID_IF_SET_TCI               DPSW_CMD_ID(0x030)
 #define DPSW_CMDID_IF_SET_STP               DPSW_CMD_ID(0x031)
 
 #define DPSW_CMDID_IF_GET_COUNTER           DPSW_CMD_V2(0x034)
 
+#define DPSW_CMDID_IF_ADD_REFLECTION        DPSW_CMD_ID(0x037)
+#define DPSW_CMDID_IF_REMOVE_REFLECTION     DPSW_CMD_ID(0x038)
+
 #define DPSW_CMDID_IF_ENABLE                DPSW_CMD_ID(0x03D)
 #define DPSW_CMDID_IF_DISABLE               DPSW_CMD_ID(0x03E)
 
@@ -533,5 +538,19 @@ struct dpsw_cmd_acl_entry {
 	__le64 pad2[4];
 	__le64 key_iova;
 };
+
+struct dpsw_cmd_set_reflection_if {
+	__le16 if_id;
+};
+
+#define DPSW_FILTER_SHIFT	0
+#define DPSW_FILTER_SIZE	2
+
+struct dpsw_cmd_if_reflection {
+	__le16 if_id;
+	__le16 vlan_id;
+	/* only 2 bits from the LSB */
+	u8 filter;
+};
 #pragma pack(pop)
 #endif /* __FSL_DPSW_CMD_H */
diff --git a/drivers/net/ethernet/freescale/dpaa2/dpsw.c b/drivers/net/ethernet/freescale/dpaa2/dpsw.c
index 6352d6d1ecba..ab921d75deb2 100644
--- a/drivers/net/ethernet/freescale/dpaa2/dpsw.c
+++ b/drivers/net/ethernet/freescale/dpaa2/dpsw.c
@@ -1579,3 +1579,83 @@ int dpsw_acl_remove_entry(struct fsl_mc_io *mc_io, u32 cmd_flags, u16 token,
 	/* send command to mc*/
 	return mc_send_command(mc_io, &cmd);
 }
+
+/**
+ * dpsw_set_reflection_if() - Set target interface for traffic mirrored
+ * @mc_io:	Pointer to MC portal's I/O object
+ * @cmd_flags:	Command flags; one or more of 'MC_CMD_FLAG_'
+ * @token:	Token of DPSW object
+ * @if_id:	Interface Id
+ *
+ * Only one mirroring destination is allowed per switch
+ *
+ * Return:	Completion status. '0' on Success; Error code otherwise.
+ */
+int dpsw_set_reflection_if(struct fsl_mc_io *mc_io, u32 cmd_flags, u16 token,
+			   u16 if_id)
+{
+	struct dpsw_cmd_set_reflection_if *cmd_params;
+	struct fsl_mc_command cmd = { 0 };
+
+	cmd.header = mc_encode_cmd_header(DPSW_CMDID_SET_REFLECTION_IF,
+					  cmd_flags,
+					  token);
+	cmd_params = (struct dpsw_cmd_set_reflection_if *)cmd.params;
+	cmd_params->if_id = cpu_to_le16(if_id);
+
+	return mc_send_command(mc_io, &cmd);
+}
+
+/**
+ * dpsw_if_add_reflection() - Setup mirroring rule
+ * @mc_io:	Pointer to MC portal's I/O object
+ * @cmd_flags:	Command flags; one or more of 'MC_CMD_FLAG_'
+ * @token:	Token of DPSW object
+ * @if_id:	Interface Identifier
+ * @cfg:	Reflection configuration
+ *
+ * Return:	Completion status. '0' on Success; Error code otherwise.
+ */
+int dpsw_if_add_reflection(struct fsl_mc_io *mc_io, u32 cmd_flags, u16 token,
+			   u16 if_id, const struct dpsw_reflection_cfg *cfg)
+{
+	struct dpsw_cmd_if_reflection *cmd_params;
+	struct fsl_mc_command cmd = { 0 };
+
+	cmd.header = mc_encode_cmd_header(DPSW_CMDID_IF_ADD_REFLECTION,
+					  cmd_flags,
+					  token);
+	cmd_params = (struct dpsw_cmd_if_reflection *)cmd.params;
+	cmd_params->if_id = cpu_to_le16(if_id);
+	cmd_params->vlan_id = cpu_to_le16(cfg->vlan_id);
+	dpsw_set_field(cmd_params->filter, FILTER, cfg->filter);
+
+	return mc_send_command(mc_io, &cmd);
+}
+
+/**
+ * dpsw_if_remove_reflection() - Remove mirroring rule
+ * @mc_io:	Pointer to MC portal's I/O object
+ * @cmd_flags:	Command flags; one or more of 'MC_CMD_FLAG_'
+ * @token:	Token of DPSW object
+ * @if_id:	Interface Identifier
+ * @cfg:	Reflection configuration
+ *
+ * Return:	Completion status. '0' on Success; Error code otherwise.
+ */
+int dpsw_if_remove_reflection(struct fsl_mc_io *mc_io, u32 cmd_flags, u16 token,
+			      u16 if_id, const struct dpsw_reflection_cfg *cfg)
+{
+	struct dpsw_cmd_if_reflection *cmd_params;
+	struct fsl_mc_command cmd = { 0 };
+
+	cmd.header = mc_encode_cmd_header(DPSW_CMDID_IF_REMOVE_REFLECTION,
+					  cmd_flags,
+					  token);
+	cmd_params = (struct dpsw_cmd_if_reflection *)cmd.params;
+	cmd_params->if_id = cpu_to_le16(if_id);
+	cmd_params->vlan_id = cpu_to_le16(cfg->vlan_id);
+	dpsw_set_field(cmd_params->filter, FILTER, cfg->filter);
+
+	return mc_send_command(mc_io, &cmd);
+}
diff --git a/drivers/net/ethernet/freescale/dpaa2/dpsw.h b/drivers/net/ethernet/freescale/dpaa2/dpsw.h
index 5ef221a25b02..892df905b876 100644
--- a/drivers/net/ethernet/freescale/dpaa2/dpsw.h
+++ b/drivers/net/ethernet/freescale/dpaa2/dpsw.h
@@ -752,4 +752,35 @@ int dpsw_acl_add_entry(struct fsl_mc_io *mc_io, u32 cmd_flags, u16 token,
 
 int dpsw_acl_remove_entry(struct fsl_mc_io *mc_io, u32 cmd_flags, u16 token,
 			  u16 acl_id, const struct dpsw_acl_entry_cfg *cfg);
+
+/**
+ * enum dpsw_reflection_filter - Filter type for frames to be reflected
+ * @DPSW_REFLECTION_FILTER_INGRESS_ALL: Reflect all frames
+ * @DPSW_REFLECTION_FILTER_INGRESS_VLAN: Reflect only frames that belong to
+ *	the particular VLAN defined by vid parameter
+ *
+ */
+enum dpsw_reflection_filter {
+	DPSW_REFLECTION_FILTER_INGRESS_ALL = 0,
+	DPSW_REFLECTION_FILTER_INGRESS_VLAN = 1
+};
+
+/**
+ * struct dpsw_reflection_cfg - Structure representing the mirroring config
+ * @filter: Filter type for frames to be mirrored
+ * @vlan_id: VLAN ID to mirror; valid only when the type is DPSW_INGRESS_VLAN
+ */
+struct dpsw_reflection_cfg {
+	enum dpsw_reflection_filter filter;
+	u16 vlan_id;
+};
+
+int dpsw_set_reflection_if(struct fsl_mc_io *mc_io, u32 cmd_flags, u16 token,
+			   u16 if_id);
+
+int dpsw_if_add_reflection(struct fsl_mc_io *mc_io, u32 cmd_flags, u16 token,
+			   u16 if_id, const struct dpsw_reflection_cfg *cfg);
+
+int dpsw_if_remove_reflection(struct fsl_mc_io *mc_io, u32 cmd_flags, u16 token,
+			      u16 if_id, const struct dpsw_reflection_cfg *cfg);
 #endif /* __FSL_DPSW_H */
-- 
2.31.1


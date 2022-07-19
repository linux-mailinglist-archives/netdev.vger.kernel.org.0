Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9AAEC57936A
	for <lists+netdev@lfdr.de>; Tue, 19 Jul 2022 08:49:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231635AbiGSGtS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Jul 2022 02:49:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55506 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235768AbiGSGtD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 Jul 2022 02:49:03 -0400
Received: from mail-ej1-x631.google.com (mail-ej1-x631.google.com [IPv6:2a00:1450:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F2B4A26122
        for <netdev@vger.kernel.org>; Mon, 18 Jul 2022 23:49:01 -0700 (PDT)
Received: by mail-ej1-x631.google.com with SMTP id mf4so25380336ejc.3
        for <netdev@vger.kernel.org>; Mon, 18 Jul 2022 23:49:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Y0d6xIdSAlipEBv8dkiXH/59al98EBuG1h6b/37KGT4=;
        b=8OC5G6CJn2pVNJG3a5LykZ7ehiXX8ZOZtoE/GZSSrKD7tpqaA+FO/HeEixvzY0ilZz
         wctKWiHlD13LN76c+ivfhlo5tgp/Dik+vVOUNB6AJVa3GKLg3U+hzuvYlEoVvCyMvIqk
         /nlrxm310OYbca+hxqQ+8jaJ7THHOxs6lqYmfYnVG9VRBr4XZtIQP8KqFUUuFRcuQzmX
         Ehm6IwQuU7aWwkwmAp4ilrdnDsfuV+rJOpUjzIG1AvDdl49gHSMo1fxS6DwnZff5fcIQ
         vhuXFNCaUMSv8j7VNLHgYGSoGZsSGm9W2jsgG/PO8FbDQV0vjtGwpH6lB3VHQxni8lGY
         eOoQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Y0d6xIdSAlipEBv8dkiXH/59al98EBuG1h6b/37KGT4=;
        b=YN3iIUUNeGYa3BocX1kkYsN4IUajGQuMhTMl71yUO5xMK/JLseAUBrg4wxAQ2wZgHx
         vpNKqMjDL9IOy4x9WK93zfSr3LIhrS9HtQn3euRJlDP1b0KZBW6z/OhnzhFIADMAOxS1
         0RCb5EeUKBbtkzfndNJ2EIXw8c5qTNDZ9g1aGs7ExmjjmLErvKKzqgAlZmY4OMqosTXS
         8k8TuukWm6pWsZybjf7krH/3yAfrIKITA0mqhLGb2iZ2EFJ9BDqjHMXV6MhYIIHFXrU9
         Lam0G3tXYWl7qvHVyI13fFz0DKLuLUtb8SnOnHNdxHDxygDPLP2BneUA45QwZyqjLrQ3
         lLpg==
X-Gm-Message-State: AJIora/e6d0Tzt9/Awun4B5zokFxy8Jdqh8hATtDkCrDXWQrjnGOOzWE
        QVFwHEb4S0hZNiRYdk9BTaFlCsGkzmZrgDid2vs=
X-Google-Smtp-Source: AGRyM1uUl7cE3I2OTTH587DdPBziuxJf41uQeAfoN0t9cxIUcdpEeFZDCKaGu6NEqbDIElVT2tQfuQ==
X-Received: by 2002:a17:907:980d:b0:72f:2cf2:9aff with SMTP id ji13-20020a170907980d00b0072f2cf29affmr8735303ejc.165.1658213340492;
        Mon, 18 Jul 2022 23:49:00 -0700 (PDT)
Received: from localhost (host-213-179-129-39.customer.m-online.net. [213.179.129.39])
        by smtp.gmail.com with ESMTPSA id b4-20020a17090636c400b0072aa014e852sm6314471ejc.87.2022.07.18.23.48.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 18 Jul 2022 23:49:00 -0700 (PDT)
From:   Jiri Pirko <jiri@resnulli.us>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, idosch@nvidia.com,
        petrm@nvidia.com, pabeni@redhat.com, edumazet@google.com,
        mlxsw@nvidia.com, saeedm@nvidia.com, snelson@pensando.io
Subject: [patch net-next v2 08/12] mlxsw: reg: Add Management DownStream Device Tunneling Register
Date:   Tue, 19 Jul 2022 08:48:43 +0200
Message-Id: <20220719064847.3688226-9-jiri@resnulli.us>
X-Mailer: git-send-email 2.35.3
In-Reply-To: <20220719064847.3688226-1-jiri@resnulli.us>
References: <20220719064847.3688226-1-jiri@resnulli.us>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jiri Pirko <jiri@nvidia.com>

The MDDT register allows to deliver query and request messages (PRM
registers, commands) to a DownStream device.

Signed-off-by: Jiri Pirko <jiri@nvidia.com>
Signed-off-by: Ido Schimmel <idosch@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlxsw/reg.h | 90 +++++++++++++++++++++++
 1 file changed, 90 insertions(+)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/reg.h b/drivers/net/ethernet/mellanox/mlxsw/reg.h
index 76caf06b17d6..e45df09df757 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/reg.h
+++ b/drivers/net/ethernet/mellanox/mlxsw/reg.h
@@ -11276,6 +11276,95 @@ mlxsw_reg_mbct_unpack(const char *payload, u8 *p_slot_index,
 		*p_fsm_state = mlxsw_reg_mbct_fsm_state_get(payload);
 }
 
+/* MDDT - Management DownStream Device Tunneling Register
+ * ------------------------------------------------------
+ * This register allows to deliver query and request messages (PRM registers,
+ * commands) to a DownStream device.
+ */
+#define MLXSW_REG_MDDT_ID 0x9160
+#define MLXSW_REG_MDDT_LEN 0x110
+
+MLXSW_REG_DEFINE(mddt, MLXSW_REG_MDDT_ID, MLXSW_REG_MDDT_LEN);
+
+/* reg_mddt_slot_index
+ * Slot index.
+ * Access: Index
+ */
+MLXSW_ITEM32(reg, mddt, slot_index, 0x00, 8, 4);
+
+/* reg_mddt_device_index
+ * Device index.
+ * Access: Index
+ */
+MLXSW_ITEM32(reg, mddt, device_index, 0x00, 0, 8);
+
+/* reg_mddt_read_size
+ * Read size in D-Words.
+ * Access: OP
+ */
+MLXSW_ITEM32(reg, mddt, read_size, 0x04, 24, 8);
+
+/* reg_mddt_write_size
+ * Write size in D-Words.
+ * Access: OP
+ */
+MLXSW_ITEM32(reg, mddt, write_size, 0x04, 16, 8);
+
+enum mlxsw_reg_mddt_status {
+	MLXSW_REG_MDDT_STATUS_OK,
+};
+
+/* reg_mddt_status
+ * Return code of the Downstream Device to the register that was sent.
+ * Access: RO
+ */
+MLXSW_ITEM32(reg, mddt, status, 0x0C, 24, 8);
+
+enum mlxsw_reg_mddt_method {
+	MLXSW_REG_MDDT_METHOD_QUERY,
+	MLXSW_REG_MDDT_METHOD_WRITE,
+};
+
+/* reg_mddt_method
+ * Access: OP
+ */
+MLXSW_ITEM32(reg, mddt, method, 0x0C, 22, 2);
+
+/* reg_mddt_register_id
+ * Access: Index
+ */
+MLXSW_ITEM32(reg, mddt, register_id, 0x0C, 0, 16);
+
+#define MLXSW_REG_MDDT_PAYLOAD_OFFSET 0x0C
+#define MLXSW_REG_MDDT_PRM_REGISTER_HEADER_LEN 4
+
+static inline char *mlxsw_reg_mddt_inner_payload(char *payload)
+{
+	return payload + MLXSW_REG_MDDT_PAYLOAD_OFFSET +
+	       MLXSW_REG_MDDT_PRM_REGISTER_HEADER_LEN;
+}
+
+static inline void mlxsw_reg_mddt_pack(char *payload, u8 slot_index,
+				       u8 device_index,
+				       enum mlxsw_reg_mddt_method method,
+				       const struct mlxsw_reg_info *reg,
+				       char **inner_payload)
+{
+	int len = reg->len + MLXSW_REG_MDDT_PRM_REGISTER_HEADER_LEN;
+
+	if (WARN_ON(len + MLXSW_REG_MDDT_PAYLOAD_OFFSET > MLXSW_REG_MDDT_LEN))
+		len = MLXSW_REG_MDDT_LEN - MLXSW_REG_MDDT_PAYLOAD_OFFSET;
+
+	MLXSW_REG_ZERO(mddt, payload);
+	mlxsw_reg_mddt_slot_index_set(payload, slot_index);
+	mlxsw_reg_mddt_device_index_set(payload, device_index);
+	mlxsw_reg_mddt_method_set(payload, method);
+	mlxsw_reg_mddt_register_id_set(payload, reg->id);
+	mlxsw_reg_mddt_read_size_set(payload, len / 4);
+	mlxsw_reg_mddt_write_size_set(payload, len / 4);
+	*inner_payload = mlxsw_reg_mddt_inner_payload(payload);
+}
+
 /* MDDQ - Management DownStream Device Query Register
  * --------------------------------------------------
  * This register allows to query the DownStream device properties. The desired
@@ -12854,6 +12943,7 @@ static const struct mlxsw_reg_info *mlxsw_reg_infos[] = {
 	MLXSW_REG(mfgd),
 	MLXSW_REG(mgpir),
 	MLXSW_REG(mbct),
+	MLXSW_REG(mddt),
 	MLXSW_REG(mddq),
 	MLXSW_REG(mddc),
 	MLXSW_REG(mfde),
-- 
2.35.3


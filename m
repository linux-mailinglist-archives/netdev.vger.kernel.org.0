Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8C8A857FB5D
	for <lists+netdev@lfdr.de>; Mon, 25 Jul 2022 10:30:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233950AbiGYI3u (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Jul 2022 04:29:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45194 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233944AbiGYI3q (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 Jul 2022 04:29:46 -0400
Received: from mail-ej1-x62c.google.com (mail-ej1-x62c.google.com [IPv6:2a00:1450:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0298F1401C
        for <netdev@vger.kernel.org>; Mon, 25 Jul 2022 01:29:41 -0700 (PDT)
Received: by mail-ej1-x62c.google.com with SMTP id b11so19148744eju.10
        for <netdev@vger.kernel.org>; Mon, 25 Jul 2022 01:29:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Y0d6xIdSAlipEBv8dkiXH/59al98EBuG1h6b/37KGT4=;
        b=f5UFaoNML68nAZTYIyOIuHiLiTqCNkzuNg9Vv5TJaGw/gu6cFFSYduYuwvh0Ff7PHI
         ++My4gPjBhnVLBYHOYRB/FzVFJhe/JG1ruFgBoiEN/6DetzHwEKbD1PG+9t/GDqq9Uxh
         cgAKn5sep0Dr13vHOJlUH4be8rg7Ooc2RDcwzuOcJjzMZyslKSK6neiBJw3q/zGv9QQ+
         qkgqsUHx4vJz31y8NoNnj03rwrWza8bZPbgIcHhVsrZnrjhR1Lj37uk27Dj+Grg4Fs+f
         E1PHczQt+ftXM5E29Mj8McqH9SNQ4w0I2WXQNjfPcZuQKGPndvtvW+8uAURrWtZEUGtO
         VtMA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Y0d6xIdSAlipEBv8dkiXH/59al98EBuG1h6b/37KGT4=;
        b=VqANrCJ0zmXkIm+0q4ywawh+DPhzWQK4LSFT0QdyWNnuTPii5BxtZU0uEwTGHMWXdr
         l3NPnKNXsaRzQcYHXNLa372CuvWxjJF5kv6Z+66FCOmBsU/jugV+svEw9XTTxGz2s/ha
         wlX3c0khurW9kGtB0vq9ahjvdMqx3u/xv75Wh9g0wGzOp7PbLqivOIYyARdrXEl1drVf
         H1VZ0Kzd9YyaYVMvWT9TRhXT2J62G+3UFeAS+kXLIwy5wqBcRVggWMh6cErWa/m/Aeby
         a0pW2HtFI2qVga3qDpEMUcXyljvknJBRsuS4NGIT9zNcAmNcG0Xgv5BsIDBHjdEjn9SG
         tzOg==
X-Gm-Message-State: AJIora/P2bsGAcEVk2l/zaWXT3ffUd0RHc2L6Y9NBQF+px2MR7Td6t0A
        6pcJBE4zHyK93SOxgsQkUjAJYF6MVrX01LI92zU=
X-Google-Smtp-Source: AGRyM1sIpouOIyAtglLo37omjf6rqdnfMOLTKKmI78dFLNa75bqQr/8n0jq+H+svpPv1/hdYukGUbA==
X-Received: by 2002:a17:907:2724:b0:72b:526f:6389 with SMTP id d4-20020a170907272400b0072b526f6389mr9294862ejl.289.1658737779275;
        Mon, 25 Jul 2022 01:29:39 -0700 (PDT)
Received: from localhost (host-213-179-129-39.customer.m-online.net. [213.179.129.39])
        by smtp.gmail.com with ESMTPSA id en27-20020a056402529b00b0043a4de1d421sm6670856edb.84.2022.07.25.01.29.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 25 Jul 2022 01:29:38 -0700 (PDT)
From:   Jiri Pirko <jiri@resnulli.us>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, idosch@nvidia.com,
        petrm@nvidia.com, pabeni@redhat.com, edumazet@google.com,
        mlxsw@nvidia.com, saeedm@nvidia.com, snelson@pensando.io
Subject: [patch net-next v4 08/12] mlxsw: reg: Add Management DownStream Device Tunneling Register
Date:   Mon, 25 Jul 2022 10:29:21 +0200
Message-Id: <20220725082925.366455-9-jiri@resnulli.us>
X-Mailer: git-send-email 2.35.3
In-Reply-To: <20220725082925.366455-1-jiri@resnulli.us>
References: <20220725082925.366455-1-jiri@resnulli.us>
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


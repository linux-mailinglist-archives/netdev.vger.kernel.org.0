Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3596557B94F
	for <lists+netdev@lfdr.de>; Wed, 20 Jul 2022 17:13:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241230AbiGTPNL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Jul 2022 11:13:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48688 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241221AbiGTPNB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 Jul 2022 11:13:01 -0400
Received: from mail-wr1-x42a.google.com (mail-wr1-x42a.google.com [IPv6:2a00:1450:4864:20::42a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2B4B15A2CD
        for <netdev@vger.kernel.org>; Wed, 20 Jul 2022 08:12:50 -0700 (PDT)
Received: by mail-wr1-x42a.google.com with SMTP id e15so21321587wro.5
        for <netdev@vger.kernel.org>; Wed, 20 Jul 2022 08:12:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Y0d6xIdSAlipEBv8dkiXH/59al98EBuG1h6b/37KGT4=;
        b=QfEGLQiTTIyWixOoQN+CDRn3On98GdDXy80Q/jAJ9T7Dfvlk1XG0NA18CXq0IgsG4e
         /a709M5W5ZUZlLFEXNohMcJ5m172OcqAWR15UAkbXCsP7ZxjgNThRc+AS7RkrWX9Y8Gr
         RO+RihFbaJTk1jS8+LnoLpb1EzqhLF39AFRw2YW6DpADHLfbSZfZAN/ni5tDs0mhKhr2
         gTV4ScJIXF+tqyOWYGPE1SEXzVXGVEPJ0SWgx/GT7Vb80fXPmUVBTS+nYkGI/5eOzKyZ
         oL75CXTB/qSVr5cno/efWD0EiXAdSzpIdhqWgCo4RwNLOV9ivuA1iEALvRF9bQazTarG
         QmkA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Y0d6xIdSAlipEBv8dkiXH/59al98EBuG1h6b/37KGT4=;
        b=Ua5ljsMTiT212g/+yrkV6/cAaOuKPKYpNHxxdhBKtEBGmySYhRaXQpusvi4z93wseo
         sRw5lsFcuRWVZHcgGBGjmU4Xw+rLdhGW+IJE/ZTgaPCyuYtUojLAod9+2GSfovuNtAr5
         q56VaAXjvsPSSizQTuSW1YmFaH3ARZ/WRuwyMlKXG6htESWV0rizPtJreLzyWhGBPLXR
         C+m+7Ovw2ZrAkZFQdldPjNaSETWCGulrLfkg7HrGwTygiDB5nsEtP//kGsG34eTiBp7Y
         8xXBiiM+FW+vWARupmDuafXPOyQaQi8DZMAVmaXUF9SYPlh+rLbn3C6lHy3VhMeWGteh
         +JGQ==
X-Gm-Message-State: AJIora9KzA2V4HzZLeV2z5D6JPwnAMQZlvmYZ7SCXDDWxbhhcDw17VXy
        yx6EmHShQNZH1FfIRU5a79eeKEvVsYDRdeg4awo=
X-Google-Smtp-Source: AGRyM1t1fKaaGF6FnATqFJ6/MNAHe60fPlWemJ4/+iIM8vIya+tGc9RWBBB7OFEyVSx81Ar6Zvs19w==
X-Received: by 2002:adf:f40e:0:b0:21e:4baf:12f1 with SMTP id g14-20020adff40e000000b0021e4baf12f1mr2154081wro.639.1658329968507;
        Wed, 20 Jul 2022 08:12:48 -0700 (PDT)
Received: from localhost (host-213-179-129-39.customer.m-online.net. [213.179.129.39])
        by smtp.gmail.com with ESMTPSA id x3-20020adfffc3000000b0021e4f446d43sm867434wrs.58.2022.07.20.08.12.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 20 Jul 2022 08:12:47 -0700 (PDT)
From:   Jiri Pirko <jiri@resnulli.us>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, idosch@nvidia.com,
        petrm@nvidia.com, pabeni@redhat.com, edumazet@google.com,
        mlxsw@nvidia.com, saeedm@nvidia.com, snelson@pensando.io
Subject: [patch net-next v3 07/11] mlxsw: reg: Add Management DownStream Device Tunneling Register
Date:   Wed, 20 Jul 2022 17:12:30 +0200
Message-Id: <20220720151234.3873008-8-jiri@resnulli.us>
X-Mailer: git-send-email 2.35.3
In-Reply-To: <20220720151234.3873008-1-jiri@resnulli.us>
References: <20220720151234.3873008-1-jiri@resnulli.us>
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


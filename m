Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8208854B152
	for <lists+netdev@lfdr.de>; Tue, 14 Jun 2022 14:39:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236173AbiFNMh3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Jun 2022 08:37:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41438 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229771AbiFNMft (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Jun 2022 08:35:49 -0400
Received: from mail-ej1-x633.google.com (mail-ej1-x633.google.com [IPv6:2a00:1450:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E5A024EA0E
        for <netdev@vger.kernel.org>; Tue, 14 Jun 2022 05:33:37 -0700 (PDT)
Received: by mail-ej1-x633.google.com with SMTP id o7so16895466eja.1
        for <netdev@vger.kernel.org>; Tue, 14 Jun 2022 05:33:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=2i8ETkljsPMTZ5Hu/X8QPsw/28pUy+5gYWCwSmJzp7s=;
        b=s5ZH+HxC8SN6B0AdCCJjzr4BinhALz8t4+9vGo87SpKXAVRHOlx5IuNnnjMEmu7TOV
         aPolmEvNQQQ+Q24f7Hm7a4SEubZBU7nbHDhosWnjHPPTqxQ0CVRfqhLFLL65pAINkJLw
         qBwALvTzYcRsxo6Uh8YOdzl3GM7frtTVR3WEAUizIlD0XUix6VwAwjGeqS0DKpLKPWxh
         y2KoRzZJXdP295RHtCzKldL/yyehApilaliuHQibEH9NxmMbedM6Ys5F63CEAO9q0cSy
         +NkvU4lUdbUOkJKMe2mzYVCIfct9ELlgA4vSbrpPt6/AzLhAkGRkKKKB7yzH/PX1c0Ed
         kErA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=2i8ETkljsPMTZ5Hu/X8QPsw/28pUy+5gYWCwSmJzp7s=;
        b=x7GXgpZ6HL9XRvKyuXxFNFiB03WJgWbtnSzbzVz4VRhceDbyo2aEnMUtSfjtMei8uC
         P+sqAanOpru+v958NqAGqX66681WfiLtBSMh4FpfndhgfLnNPnUTAnZo3bVgIsC61dEJ
         5Vbsvb3WHckcgP7mTrVBnd/tfZtH+1j3PLip20R4MOHSD78V6O1D6Q0iHemwt2Iyfds0
         Nxh+9QI53fk+lFeM0ZIcOg1teL41id4BwhyJWY4uoG0xHhpZQvh78vOk3/zgaojnuSIk
         oDiuV7sYL7N/ZRGalgjl+JrClbDl8Horbg++abX4knVcYmsfrOQsThXLkYcRBau0LDrr
         h5HQ==
X-Gm-Message-State: AOAM533MNOLaIlywoczt9nwTS6Y2T2wKpLSMkio8gjonZaNp93FpkvHH
        QhW414s/m3NMGH9VPlGh/f0lNt7LOw+KLpPnbDQ=
X-Google-Smtp-Source: ABdhPJyyBQIyNzoAJ89SzEd/vud5+VsgDTGNOXUr7xM7i0UYc9JBYzlYm7RzyttljR/kpomBbAivyA==
X-Received: by 2002:a17:906:1ca:b0:715:73f3:b50f with SMTP id 10-20020a17090601ca00b0071573f3b50fmr4197666ejj.374.1655210017453;
        Tue, 14 Jun 2022 05:33:37 -0700 (PDT)
Received: from localhost ([86.61.181.4])
        by smtp.gmail.com with ESMTPSA id q8-20020a056402040800b0042dd4f9c464sm6924629edv.84.2022.06.14.05.33.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Jun 2022 05:33:36 -0700 (PDT)
From:   Jiri Pirko <jiri@resnulli.us>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, idosch@nvidia.com,
        petrm@nvidia.com, pabeni@redhat.com, edumazet@google.com,
        mlxsw@nvidia.com
Subject: [patch net-next 07/11] mlxsw: reg: Add Management DownStream Device Tunneling Register
Date:   Tue, 14 Jun 2022 14:33:22 +0200
Message-Id: <20220614123326.69745-8-jiri@resnulli.us>
X-Mailer: git-send-email 2.35.3
In-Reply-To: <20220614123326.69745-1-jiri@resnulli.us>
References: <20220614123326.69745-1-jiri@resnulli.us>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
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
index c8d526669522..953790b9abd1 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/reg.h
+++ b/drivers/net/ethernet/mellanox/mlxsw/reg.h
@@ -11622,6 +11622,95 @@ mlxsw_reg_mbct_unpack(const char *payload, u8 *p_slot_index,
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
@@ -13208,6 +13297,7 @@ static const struct mlxsw_reg_info *mlxsw_reg_infos[] = {
 	MLXSW_REG(mfgd),
 	MLXSW_REG(mgpir),
 	MLXSW_REG(mbct),
+	MLXSW_REG(mddt),
 	MLXSW_REG(mddq),
 	MLXSW_REG(mddc),
 	MLXSW_REG(mfde),
-- 
2.35.3


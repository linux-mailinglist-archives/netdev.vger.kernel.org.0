Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ACBF03F5E9B
	for <lists+netdev@lfdr.de>; Tue, 24 Aug 2021 15:04:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237464AbhHXNFZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Aug 2021 09:05:25 -0400
Received: from new3-smtp.messagingengine.com ([66.111.4.229]:57177 "EHLO
        new3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S237455AbhHXNFX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 Aug 2021 09:05:23 -0400
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailnew.nyi.internal (Postfix) with ESMTP id A91E4580B1C;
        Tue, 24 Aug 2021 09:04:38 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute6.internal (MEProxy); Tue, 24 Aug 2021 09:04:38 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm3; bh=TbpKZ13GFZEfyQKgxRy+PtEOzP33EG0S4dq9TUbndXc=; b=X9rwmvsL
        mKXJuNRlVXjlE5nIULX33SWfwVZVU7GXLXjfD80kO827OCOWjAvL9/QDM7kABg1a
        xlq2U5rMfPcV2Vr20OD34upxNzLgf+ZaJIfTwDqeO/pQw8WJL2IWtfm1y85GpzHu
        drofzdogMdr5/Kt8/yE2GskPWgy0TEh22u74rmtGRrJi1Wh/Up2vAEk5v71WQLJX
        QjtgWwT/Glju4mP1f591dOe5pBJHWHlXWvMzrNNldhEekxxoA/dVRcisBmABGfWw
        XLhMiCD+IN+CGnmkimFNzNqnEim2/Rb4Y/zlQgpnnejZRD3Jjv8oPOx3CqSGskh2
        JHwEtyVEbB75iQ==
X-ME-Sender: <xms:Ze4kYbym4hKobZETd-Bh0lMn8t8DM8EFCt2P7et4eJrLvEDPDsmoPA>
    <xme:Ze4kYTQClLEYLp5X1LxaV7gUvAgECjIqjoJb-Ts_cuetlDA8tmSnPvAzOhBhrq4ty
    Q2QU2fV_UonKTI>
X-ME-Received: <xmr:Ze4kYVUAUK293957aAwf3laK_XcUUP9OBFB4UdKLB06Pe0kh6KkOwsJl0_EPzcdFBl31wemIp5jtQbtRmeAve3jcDaiDAiSyk0DsTxmyaNUgLg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvtddruddtjedgiedtucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgjfhgggfestdekre
    dtredttdenucfhrhhomhepkfguohcuufgthhhimhhmvghluceoihguohhstghhsehiugho
    shgthhdrohhrgheqnecuggftrfgrthhtvghrnhepudetieevffffveelkeeljeffkefhke
    ehgfdtffethfelvdejgffghefgveejkefhnecuvehluhhsthgvrhfuihiivgeptdenucfr
    rghrrghmpehmrghilhhfrhhomhepihguohhstghhsehiughoshgthhdrohhrgh
X-ME-Proxy: <xmx:Ze4kYVjum_R5Y0ppD9BJNcMi1KZ5AeXHFjyGNEbSVPRYkXNZraZDRw>
    <xmx:Ze4kYdBP64NlebMh1l-3pWcwn3iON_j28wYUOI8UfLTKzTqYpmFKaw>
    <xmx:Ze4kYeJ3jAmAGp_uYnvn5o1gFEJejCC-TKwMSt1aRj9Ta1hovSL5Xw>
    <xmx:Zu4kYR2og9_fdbp5BCVjd-uy0H37um46pcsawHZ2Z9zSQ_rXidrRjA>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Tue,
 24 Aug 2021 09:04:35 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, andrew@lunn.ch,
        mkubecek@suse.cz, pali@kernel.org, jacob.e.keller@intel.com,
        jiri@nvidia.com, vadimp@nvidia.com, mlxsw@nvidia.com,
        Ido Schimmel <idosch@nvidia.com>
Subject: [RFC PATCH net-next v3 2/6] mlxsw: reg: Add Port Module Memory Map Properties register
Date:   Tue, 24 Aug 2021 16:03:40 +0300
Message-Id: <20210824130344.1828076-3-idosch@idosch.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210824130344.1828076-1-idosch@idosch.org>
References: <20210824130344.1828076-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ido Schimmel <idosch@nvidia.com>

Add the Port Module Memory Map Properties register. It will be used to
set the power mode of a module in subsequent patches.

Signed-off-by: Ido Schimmel <idosch@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlxsw/reg.h | 44 +++++++++++++++++++++++
 1 file changed, 44 insertions(+)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/reg.h b/drivers/net/ethernet/mellanox/mlxsw/reg.h
index 6c96e124e4c8..fe9bf6ce3508 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/reg.h
+++ b/drivers/net/ethernet/mellanox/mlxsw/reg.h
@@ -5946,6 +5946,49 @@ static inline void mlxsw_reg_pddr_pack(char *payload, u8 local_port,
 	mlxsw_reg_pddr_page_select_set(payload, page_select);
 }
 
+/* PMMP - Port Module Memory Map Properties Register
+ * -------------------------------------------------
+ * The PMMP register allows to override the module memory map advertisement.
+ * The register can only be set when the module is disabled by PMAOS register.
+ */
+#define MLXSW_REG_PMMP_ID 0x5044
+#define MLXSW_REG_PMMP_LEN 0x2C
+
+MLXSW_REG_DEFINE(pmmp, MLXSW_REG_PMMP_ID, MLXSW_REG_PMMP_LEN);
+
+/* reg_pmmp_module
+ * Module number.
+ * Access: Index
+ */
+MLXSW_ITEM32(reg, pmmp, module, 0x00, 16, 8);
+
+/* reg_pmmp_eeprom_override_mask
+ * Write mask bit (negative polarity).
+ * 0 - Allow write
+ * 1 - Ignore write
+ * On write, indicates which of the bits from eeprom_override field are
+ * updated.
+ * Access: WO
+ */
+MLXSW_ITEM32(reg, pmmp, eeprom_override_mask, 0x04, 16, 16);
+
+enum {
+	/* Set module to low power mode */
+	MLXSW_REG_PMMP_EEPROM_OVERRIDE_LOW_POWER_MASK = BIT(8),
+};
+
+/* reg_pmmp_eeprom_override
+ * Override / ignore EEPROM advertisement properties bitmask
+ * Access: RW
+ */
+MLXSW_ITEM32(reg, pmmp, eeprom_override, 0x04, 0, 16);
+
+static inline void mlxsw_reg_pmmp_pack(char *payload, u8 module)
+{
+	MLXSW_REG_ZERO(pmmp, payload);
+	mlxsw_reg_pmmp_module_set(payload, module);
+}
+
 /* PLLP - Port Local port to Label Port mapping Register
  * -----------------------------------------------------
  * The PLLP register returns the mapping from Local Port into Label Port.
@@ -12273,6 +12316,7 @@ static const struct mlxsw_reg_info *mlxsw_reg_infos[] = {
 	MLXSW_REG(pmtdb),
 	MLXSW_REG(pmpe),
 	MLXSW_REG(pddr),
+	MLXSW_REG(pmmp),
 	MLXSW_REG(pllp),
 	MLXSW_REG(htgt),
 	MLXSW_REG(hpkt),
-- 
2.31.1


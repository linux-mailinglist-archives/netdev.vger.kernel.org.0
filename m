Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 930AA420078
	for <lists+netdev@lfdr.de>; Sun,  3 Oct 2021 09:34:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229888AbhJCHfo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 3 Oct 2021 03:35:44 -0400
Received: from new2-smtp.messagingengine.com ([66.111.4.224]:56325 "EHLO
        new2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229877AbhJCHfk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 3 Oct 2021 03:35:40 -0400
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailnew.nyi.internal (Postfix) with ESMTP id 10E69580E43;
        Sun,  3 Oct 2021 03:33:53 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute3.internal (MEProxy); Sun, 03 Oct 2021 03:33:53 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm1; bh=nImdF6j1LgCiDiPmAZ0/Yn9vHkDCY52jGC75qP6Y4XM=; b=Ibt2AKGt
        lk4O9C71RewicoLClxO13ejAYEhTk7XgSQgl5sM+AAzlAr24nAxdbPpQSzD6EQBs
        smcZ1NVoN0yTJHvWwmYxxAQN5c0MJbm/6okcBp/JpvM+MGHL/JthxDn7vtjV1LbA
        SqSxzVcMIQHzFiylok474u2yslb2WhCGsjDocjo0YKbpyvpx/h42+XDuI+42edsB
        qYZTXmU/ce52eInXu/ykM6vH3jfUwcwJoLCv3WWtvFH61Cru0z9qEsdbvrCvdr3o
        YbLohFVf8PxazZzDYr5UhCvXLaZwQcgexfS01Odq1uaRHfdNAUkazirE3PyYt3jn
        +S6jJl+OHxE3Sg==
X-ME-Sender: <xms:4FxZYXrgDudg45jvUZjTE6jMZXe0mCNVDw35eHe6byOou4r9vGnBrw>
    <xme:4FxZYRpMccOz9Isq_SwmLQ3jjDruBUnB08s-_7dKciqvcrtFzvuS8y4niBdhiEjfS
    IrOcOsXF4ozB18>
X-ME-Received: <xmr:4FxZYUMb9axGFKZzcIq0u1l-g--3KJawODgFCJtq71wVgfvca-w_sqExADmwwnag_4rInTxvW8w9qxehiaIkg5Isx4zXQm-DLUTJoPt71lNt9g>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvtddrudekledguddulecutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecunecujfgurhephffvufffkffojghfggfgsedtke
    ertdertddtnecuhfhrohhmpefkughoucfutghhihhmmhgvlhcuoehiughoshgthhesihgu
    ohhstghhrdhorhhgqeenucggtffrrghtthgvrhhnpeduteeiveffffevleekleejffekhf
    ekhefgtdfftefhledvjefggfehgfevjeekhfenucevlhhushhtvghrufhiiigvpedtnecu
    rfgrrhgrmhepmhgrihhlfhhrohhmpehiughoshgthhesihguohhstghhrdhorhhg
X-ME-Proxy: <xmx:4FxZYa45gluZLhd79cutDp11DeB109dp0x50aM_Y3dFOj0bEdbEPqw>
    <xmx:4FxZYW6n8ELaKgSh08qiZjzZmw5j1tCyDVTEwQEqa8ukuUnXUC2pRQ>
    <xmx:4FxZYSi6MvWHu5JAD6lXc6fbHJQNAoxeW1bStQ4lxqZs8aFj26gOQQ>
    <xmx:4VxZYYtafYYyJKcddCpcMkyihvp5inzFWp0DkAadNeNlMsiQvx_-FQ>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Sun,
 3 Oct 2021 03:33:50 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, andrew@lunn.ch,
        mkubecek@suse.cz, pali@kernel.org, jacob.e.keller@intel.com,
        jiri@nvidia.com, vadimp@nvidia.com, mlxsw@nvidia.com,
        Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH net-next 2/6] mlxsw: reg: Add Port Module Memory Map Properties register
Date:   Sun,  3 Oct 2021 10:32:15 +0300
Message-Id: <20211003073219.1631064-3-idosch@idosch.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211003073219.1631064-1-idosch@idosch.org>
References: <20211003073219.1631064-1-idosch@idosch.org>
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
 drivers/net/ethernet/mellanox/mlxsw/reg.h | 50 +++++++++++++++++++++++
 1 file changed, 50 insertions(+)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/reg.h b/drivers/net/ethernet/mellanox/mlxsw/reg.h
index c5fad3c94fac..bff05a0a2f7a 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/reg.h
+++ b/drivers/net/ethernet/mellanox/mlxsw/reg.h
@@ -5946,6 +5946,55 @@ static inline void mlxsw_reg_pddr_pack(char *payload, u8 local_port,
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
+/* reg_pmmp_sticky
+ * When set, will keep eeprom_override values after plug-out event.
+ * Access: OP
+ */
+MLXSW_ITEM32(reg, pmmp, sticky, 0x00, 0, 1);
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
@@ -12348,6 +12397,7 @@ static const struct mlxsw_reg_info *mlxsw_reg_infos[] = {
 	MLXSW_REG(pmtdb),
 	MLXSW_REG(pmpe),
 	MLXSW_REG(pddr),
+	MLXSW_REG(pmmp),
 	MLXSW_REG(pllp),
 	MLXSW_REG(htgt),
 	MLXSW_REG(hpkt),
-- 
2.31.1


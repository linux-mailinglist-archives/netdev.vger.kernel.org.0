Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 88172279F60
	for <lists+netdev@lfdr.de>; Sun, 27 Sep 2020 09:50:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730474AbgI0Hut (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 27 Sep 2020 03:50:49 -0400
Received: from wout5-smtp.messagingengine.com ([64.147.123.21]:43001 "EHLO
        wout5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727263AbgI0Hus (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 27 Sep 2020 03:50:48 -0400
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailout.west.internal (Postfix) with ESMTP id 16E2145A;
        Sun, 27 Sep 2020 03:50:47 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute4.internal (MEProxy); Sun, 27 Sep 2020 03:50:47 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:in-reply-to:message-id:mime-version:references
        :subject:to:x-me-proxy:x-me-proxy:x-me-sender:x-me-sender
        :x-sasl-enc; s=fm3; bh=E2fhDlWjoWI9H58HnpUqgY0kZefjrLvHF6l0qnobZ
        UA=; b=obVpMfti7a5i4HT3fH8GpPlJyKwOLC5lRnhJF2IU1u1/2CVmhI8cKDHYw
        +g1gYCeMNzlomDHUATvHtKyvRcxGgcbs9hTVbHJWxTOLQswhsVhnMfhivdNPNHfX
        1dbdn1Q+46A0ZAT5KPhYKdtdLWaNqP4qdsZOA6Cj4Hw84HHcb281AAz3RDPL9BL1
        ElYHvrO+fIPNXQZFz0YKckCrehfGEdipzbcns6SvdMclOTmcOAf17GoPkPUr0i8X
        pCt8KtPgIASCBKf+HLGKbKqw3mdRrNCUSfphyMIuVxMaEQuS1MyI7p0PKb8Qr9OL
        cl6Sk+SKVdNoWPiss/4bWjNYi94Bg==
X-ME-Sender: <xms:VkRwX2Uv1ounZi8fp0QW7pSihbd2aF0EqLEUzjhKifRgCKUpKWMf_w>
    <xme:VkRwXykI2YdnD3Gr7UWSlvXpRo57RohCdRGS3UqdB4j-9TPursBp93kAXW-2R-Msn
    D7_kt_r4KJwjDE>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedujedrvdefgdduudeiucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgjfhggtgfgsehtke
    ertdertdejnecuhfhrohhmpefkughoucfutghhihhmmhgvlhcuoehiughoshgthhesihgu
    ohhstghhrdhorhhgqeenucggtffrrghtthgvrhhnpeekheelfeefffdthfeuhfeuieeltd
    fgffejffdvuddtgeefvefhleffteeujeethfenucfkphepkeegrddvvdelrdefjedrudeg
    keenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehiug
    hoshgthhesihguohhstghhrdhorhhg
X-ME-Proxy: <xmx:VkRwX6an6d_gmsRzOwF9gceRmhpv-TCfQFHPf5sFsahUOncGqzBDug>
    <xmx:VkRwX9XxBgnumGNBrN8zYuwf3cwFz3CRWB1Qdiwk58QVBzVHVd8mUw>
    <xmx:VkRwXwka2vf3Or9EEmH7MyH_rEY-P1PSBR0t47xugBBackU47Um-Mw>
    <xmx:VkRwX6hriA4BIGQqZA5XPqYvPrmRBf2VvLCijDkVsB7CYMRzXSobDg>
Received: from shredder.lan (igld-84-229-37-148.inter.net.il [84.229.37.148])
        by mail.messagingengine.com (Postfix) with ESMTPA id 304DD3280059;
        Sun, 27 Sep 2020 03:50:44 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, amcohen@nvidia.com,
        jiri@nvidia.com, mlxsw@nvidia.com, Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH net-next 02/10] mlxsw: reg: Add Port Module Plug/Unplug Event Register
Date:   Sun, 27 Sep 2020 10:50:07 +0300
Message-Id: <20200927075015.1417714-3-idosch@idosch.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200927075015.1417714-1-idosch@idosch.org>
References: <20200927075015.1417714-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Amit Cohen <amcohen@nvidia.com>

PMPE register reports any operational status change of a module.
It will be used for enabling temperature warning event when a module is
plugged in.

Signed-off-by: Amit Cohen <amcohen@nvidia.com>
Reviewed-by: Jiri Pirko <jiri@nvidia.com>
Signed-off-by: Ido Schimmel <idosch@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlxsw/reg.h | 45 +++++++++++++++++++++++
 1 file changed, 45 insertions(+)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/reg.h b/drivers/net/ethernet/mellanox/mlxsw/reg.h
index e04eb7576ca6..5878f14a6538 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/reg.h
+++ b/drivers/net/ethernet/mellanox/mlxsw/reg.h
@@ -5441,6 +5441,50 @@ static inline void mlxsw_reg_pplr_pack(char *payload, u8 local_port,
 				 MLXSW_REG_PPLR_LB_TYPE_BIT_PHY_LOCAL : 0);
 }
 
+/* PMPE - Port Module Plug/Unplug Event Register
+ * ---------------------------------------------
+ * This register reports any operational status change of a module.
+ * A change in the module’s state will generate an event only if the change
+ * happens after arming the event mechanism. Any changes to the module state
+ * while the event mechanism is not armed will not be reported. Software can
+ * query the PMPE register for module status.
+ */
+#define MLXSW_REG_PMPE_ID 0x5024
+#define MLXSW_REG_PMPE_LEN 0x10
+
+MLXSW_REG_DEFINE(pmpe, MLXSW_REG_PMPE_ID, MLXSW_REG_PMPE_LEN);
+
+/* reg_pmpe_slot_index
+ * Slot index.
+ * Access: Index
+ */
+MLXSW_ITEM32(reg, pmpe, slot_index, 0x00, 24, 4);
+
+/* reg_pmpe_module
+ * Module number.
+ * Access: Index
+ */
+MLXSW_ITEM32(reg, pmpe, module, 0x00, 16, 8);
+
+enum mlxsw_reg_pmpe_module_status {
+	MLXSW_REG_PMPE_MODULE_STATUS_PLUGGED_ENABLED = 1,
+	MLXSW_REG_PMPE_MODULE_STATUS_UNPLUGGED,
+	MLXSW_REG_PMPE_MODULE_STATUS_PLUGGED_ERROR,
+	MLXSW_REG_PMPE_MODULE_STATUS_PLUGGED_DISABLED,
+};
+
+/* reg_pmpe_module_status
+ * Module status.
+ * Access: RO
+ */
+MLXSW_ITEM32(reg, pmpe, module_status, 0x00, 0, 4);
+
+/* reg_pmpe_error_type
+ * Module error details.
+ * Access: RO
+ */
+MLXSW_ITEM32(reg, pmpe, error_type, 0x04, 8, 4);
+
 /* PDDR - Port Diagnostics Database Register
  * -----------------------------------------
  * The PDDR enables to read the Phy debug database
@@ -11059,6 +11103,7 @@ static const struct mlxsw_reg_info *mlxsw_reg_infos[] = {
 	MLXSW_REG(pbmc),
 	MLXSW_REG(pspa),
 	MLXSW_REG(pplr),
+	MLXSW_REG(pmpe),
 	MLXSW_REG(pddr),
 	MLXSW_REG(pmtm),
 	MLXSW_REG(htgt),
-- 
2.26.2


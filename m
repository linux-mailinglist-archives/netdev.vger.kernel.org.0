Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1AA6B3F5E9C
	for <lists+netdev@lfdr.de>; Tue, 24 Aug 2021 15:04:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237467AbhHXNF1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Aug 2021 09:05:27 -0400
Received: from new3-smtp.messagingengine.com ([66.111.4.229]:57823 "EHLO
        new3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S237463AbhHXNFZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 Aug 2021 09:05:25 -0400
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailnew.nyi.internal (Postfix) with ESMTP id A436C580B13;
        Tue, 24 Aug 2021 09:04:41 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute3.internal (MEProxy); Tue, 24 Aug 2021 09:04:41 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm3; bh=uaH6gIO9jSc0rt1izId1IU5t4+RcSMjHQkMx39VP+HQ=; b=If67y3yu
        HpwkozQXTGgJcraSHTYpY3CrBbsWe2xipujTwcIkS12PvGrBfl+d4eA4RHGQCIQZ
        A8zjnorzJkzCVYHYQNBmkB+QzNQULdvyBPFFy0Lq+V54Z/wLagyPl7vtept8nZTm
        rnt4QeIFxj9fEPdS9+q1T6IpAFaGtBCsvjFgcLFn25SBXW6BnLTK+GPnXpiNPAjf
        ZiVXql15E90RcyTnH8/g04n2Pj+wsQwRYRBjtOe2seXXNwFeUUcl9zGjuskeZM5o
        WnLbrUeDWOgCOvQfBjQsGjIghXIXlQAuUo2/G5nK1yDah9KkJOQgWV8Mfy56/eCh
        X0wqqrT/4AG1ig==
X-ME-Sender: <xms:ae4kYWE2cMfeCic4Wr0p7tx346ITXGfbrotM6zB3p_tiKwVC2LCWEg>
    <xme:ae4kYXVpBEN9jIWG2rXMNGYUsZJwy2aaZLLk2m5eNRCEI7lLIIRoce94PoADwVHwm
    Q8kCWTWVQz5Tso>
X-ME-Received: <xmr:ae4kYQJd3CSSguSW3SsshWrSANSnbI0VH_nTxLQFyXm9II4l_xdWw7r83jYuc8oQIQ65URAgikj11D6tU7w1McHQ_Gqpb2buE6TaW9o5oDnXvA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvtddruddtjedgiedtucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgjfhgggfestdekre
    dtredttdenucfhrhhomhepkfguohcuufgthhhimhhmvghluceoihguohhstghhsehiugho
    shgthhdrohhrgheqnecuggftrfgrthhtvghrnhepudetieevffffveelkeeljeffkefhke
    ehgfdtffethfelvdejgffghefgveejkefhnecuvehluhhsthgvrhfuihiivgepudenucfr
    rghrrghmpehmrghilhhfrhhomhepihguohhstghhsehiughoshgthhdrohhrgh
X-ME-Proxy: <xmx:ae4kYQHSHmycRThwUU9GspcdHHmpxC0NOeLSfNI-XbPkyeNtkorW5w>
    <xmx:ae4kYcUU_GwPsvOkiITF-dhQJRgfInwFA6oW9EgYJCokrBmTMb3dOQ>
    <xmx:ae4kYTNygF6rBMyKGmbB9gTQ-moXeytT7J1ZotRFp7SSY9UtVi596Q>
    <xmx:ae4kYQqKRDG7EKJyteWrwwqyNAwdGdtnL_tk-jjkC1YmnTeA8L1pfA>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Tue,
 24 Aug 2021 09:04:38 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, andrew@lunn.ch,
        mkubecek@suse.cz, pali@kernel.org, jacob.e.keller@intel.com,
        jiri@nvidia.com, vadimp@nvidia.com, mlxsw@nvidia.com,
        Ido Schimmel <idosch@nvidia.com>
Subject: [RFC PATCH net-next v3 3/6] mlxsw: reg: Add Management Cable IO and Notifications register
Date:   Tue, 24 Aug 2021 16:03:41 +0300
Message-Id: <20210824130344.1828076-4-idosch@idosch.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210824130344.1828076-1-idosch@idosch.org>
References: <20210824130344.1828076-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ido Schimmel <idosch@nvidia.com>

Add the Management Cable IO and Notifications register. It will be used
to retrieve the power mode status of a module in subsequent patches and
whether a module is present in a cage or not.

Signed-off-by: Ido Schimmel <idosch@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlxsw/reg.h | 34 +++++++++++++++++++++++
 1 file changed, 34 insertions(+)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/reg.h b/drivers/net/ethernet/mellanox/mlxsw/reg.h
index fe9bf6ce3508..b862e56c1f9e 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/reg.h
+++ b/drivers/net/ethernet/mellanox/mlxsw/reg.h
@@ -10321,6 +10321,39 @@ static inline void mlxsw_reg_mlcr_pack(char *payload, u8 local_port,
 					   MLXSW_REG_MLCR_DURATION_MAX : 0);
 }
 
+/* MCION - Management Cable IO and Notifications Register
+ * ------------------------------------------------------
+ * The MCION register is used to query transceiver modules' IO pins and other
+ * notifications.
+ */
+#define MLXSW_REG_MCION_ID 0x9052
+#define MLXSW_REG_MCION_LEN 0x18
+
+MLXSW_REG_DEFINE(mcion, MLXSW_REG_MCION_ID, MLXSW_REG_MCION_LEN);
+
+/* reg_mcion_module
+ * Module number.
+ * Access: Index
+ */
+MLXSW_ITEM32(reg, mcion, module, 0x00, 16, 8);
+
+enum {
+	MLXSW_REG_MCION_MODULE_STATUS_BITS_PRESENT_MASK = BIT(0),
+	MLXSW_REG_MCION_MODULE_STATUS_BITS_LOW_POWER_MASK = BIT(8),
+};
+
+/* reg_mcion_module_status_bits
+ * Module IO status as defined by SFF.
+ * Access: RO
+ */
+MLXSW_ITEM32(reg, mcion, module_status_bits, 0x04, 0, 16);
+
+static inline void mlxsw_reg_mcion_pack(char *payload, u8 module)
+{
+	MLXSW_REG_ZERO(mcion, payload);
+	mlxsw_reg_mcion_module_set(payload, module);
+}
+
 /* MTPPS - Management Pulse Per Second Register
  * --------------------------------------------
  * This register provides the device PPS capabilities, configure the PPS in and
@@ -12364,6 +12397,7 @@ static const struct mlxsw_reg_info *mlxsw_reg_infos[] = {
 	MLXSW_REG(mgir),
 	MLXSW_REG(mrsr),
 	MLXSW_REG(mlcr),
+	MLXSW_REG(mcion),
 	MLXSW_REG(mtpps),
 	MLXSW_REG(mtutc),
 	MLXSW_REG(mpsc),
-- 
2.31.1


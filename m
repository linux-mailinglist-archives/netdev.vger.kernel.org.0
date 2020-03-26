Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 32E021940B3
	for <lists+netdev@lfdr.de>; Thu, 26 Mar 2020 15:02:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727905AbgCZOB5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Mar 2020 10:01:57 -0400
Received: from out2-smtp.messagingengine.com ([66.111.4.26]:57439 "EHLO
        out2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727897AbgCZOB4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 Mar 2020 10:01:56 -0400
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailout.nyi.internal (Postfix) with ESMTP id 423735C0222;
        Thu, 26 Mar 2020 10:01:55 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute4.internal (MEProxy); Thu, 26 Mar 2020 10:01:55 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm2; bh=rzbqFcdY42LF7ixautMDOuXwlWedE4D8CQcXv8zNWQg=; b=ZRiYGrWA
        vz18TB5JJIba2fEssrT7oEH6VLrizAOo21k8VypU1TX3o9n+5NTtwzMwGvH3zngq
        54876TJPBny8ctjLw6li65xJHv5I2/qhhRYDUYaIjinSchbJyfc7xwTvRdiyrdnA
        UwuVVDZW6M5IzlZBFjlohdVBdem+RKqjzYSTemsS/fLk/StJb+rP58wM3ByyigLR
        A8T5Ybv+EMa8aMrXKUfy9UH2mfoRQBi4RtFCDqtVl6RhUfwOz3japGNRsMUiF5jb
        MH8rYJCNkVR82aq3I229I7fgYGErRlJjmnBdIPSC8sTvHwFgjQtDrZumEkAYS3D4
        0+jeA+CdTEiUmQ==
X-ME-Sender: <xms:07V8XjxjUyiVCn4h6AzWghEsxTO1BCwqZHw6gvCC9IBJeleIFa_Rbg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedugedrudehiedgheelucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgjfhgggfestdekre
    dtredttdenucfhrhhomhepkfguohcuufgthhhimhhmvghluceoihguohhstghhsehiugho
    shgthhdrohhrgheqnecukfhppeejledrudekuddrudefvddrudeludenucevlhhushhtvg
    hrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehiughoshgthhesihguohhs
    tghhrdhorhhg
X-ME-Proxy: <xmx:07V8XvgdHjvIMq5RSHVXEiiDtEKThuSm-DpgL67cI9G5jDVEH7QKAA>
    <xmx:07V8XoV_Cq1T-WxbvHT66vj3ZBFuzEIMgP2j8ja_Scd0En009sMnag>
    <xmx:07V8Xh3TpA9qbwNSJzWNJvj4EC7jCb2onqAWuFgIE71TA9gxUcVPEg>
    <xmx:07V8XrByx9jRCLjBBOG9bgc7uUCMchlJQl9bBhNWtJpTWoc7eJgPTw>
Received: from splinter.mtl.com (bzq-79-181-132-191.red.bezeqint.net [79.181.132.191])
        by mail.messagingengine.com (Postfix) with ESMTPA id C10B930696D4;
        Thu, 26 Mar 2020 10:01:53 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, jiri@mellanox.com,
        petrm@mellanox.com, mlxsw@mellanox.com,
        Ido Schimmel <idosch@mellanox.com>
Subject: [PATCH net-next 3/6] mlxsw: core: Add DSCP, ECN, dscp_rw to QOS_ACTION
Date:   Thu, 26 Mar 2020 16:01:11 +0200
Message-Id: <20200326140114.1393972-4-idosch@idosch.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200326140114.1393972-1-idosch@idosch.org>
References: <20200326140114.1393972-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Petr Machata <petrm@mellanox.com>

The QOS_ACTION is used for manipulating the QOS attributes of the packet.
Add the defines and helpers related to DSCP and ECN fields, and dscp_rw.

Signed-off-by: Petr Machata <petrm@mellanox.com>
Reviewed-by: Jiri Pirko <jiri@mellanox.com>
Signed-off-by: Ido Schimmel <idosch@mellanox.com>
---
 .../mellanox/mlxsw/core_acl_flex_actions.c    | 64 +++++++++++++++++++
 1 file changed, 64 insertions(+)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/core_acl_flex_actions.c b/drivers/net/ethernet/mellanox/mlxsw/core_acl_flex_actions.c
index 1d0695050cfc..3ae0a91875ef 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/core_acl_flex_actions.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/core_acl_flex_actions.c
@@ -1248,6 +1248,43 @@ EXPORT_SYMBOL(mlxsw_afa_block_append_mirror);
 #define MLXSW_AFA_QOS_CODE 0x06
 #define MLXSW_AFA_QOS_SIZE 1
 
+enum mlxsw_afa_qos_ecn_cmd {
+	/* Do nothing */
+	MLXSW_AFA_QOS_ECN_CMD_NOP,
+	/* Set ECN to afa_qos_ecn */
+	MLXSW_AFA_QOS_ECN_CMD_SET,
+};
+
+/* afa_qos_ecn_cmd
+ */
+MLXSW_ITEM32(afa, qos, ecn_cmd, 0x04, 29, 3);
+
+/* afa_qos_ecn
+ * ECN value.
+ */
+MLXSW_ITEM32(afa, qos, ecn, 0x04, 24, 2);
+
+enum mlxsw_afa_qos_dscp_cmd {
+	/* Do nothing */
+	MLXSW_AFA_QOS_DSCP_CMD_NOP,
+	/* Set DSCP 3 LSB bits according to dscp[2:0] */
+	MLXSW_AFA_QOS_DSCP_CMD_SET_3LSB,
+	/* Set DSCP 3 MSB bits according to dscp[5:3] */
+	MLXSW_AFA_QOS_DSCP_CMD_SET_3MSB,
+	/* Set DSCP 6 bits according to dscp[5:0] */
+	MLXSW_AFA_QOS_DSCP_CMD_SET_ALL,
+};
+
+/* afa_qos_dscp_cmd
+ * DSCP command.
+ */
+MLXSW_ITEM32(afa, qos, dscp_cmd, 0x04, 14, 2);
+
+/* afa_qos_dscp
+ * DSCP value.
+ */
+MLXSW_ITEM32(afa, qos, dscp, 0x04, 0, 6);
+
 enum mlxsw_afa_qos_switch_prio_cmd {
 	/* Do nothing */
 	MLXSW_AFA_QOS_SWITCH_PRIO_CMD_NOP,
@@ -1264,6 +1301,33 @@ MLXSW_ITEM32(afa, qos, switch_prio_cmd, 0x08, 14, 2);
  */
 MLXSW_ITEM32(afa, qos, switch_prio, 0x08, 0, 4);
 
+enum mlxsw_afa_qos_dscp_rw {
+	MLXSW_AFA_QOS_DSCP_RW_PRESERVE,
+	MLXSW_AFA_QOS_DSCP_RW_SET,
+	MLXSW_AFA_QOS_DSCP_RW_CLEAR,
+};
+
+/* afa_qos_dscp_rw
+ * DSCP Re-write Enable. Controlling the rewrite_enable for DSCP.
+ */
+MLXSW_ITEM32(afa, qos, dscp_rw, 0x0C, 30, 2);
+
+static inline void
+mlxsw_afa_qos_ecn_pack(char *payload,
+		       enum mlxsw_afa_qos_ecn_cmd ecn_cmd, u8 ecn)
+{
+	mlxsw_afa_qos_ecn_cmd_set(payload, ecn_cmd);
+	mlxsw_afa_qos_ecn_set(payload, ecn);
+}
+
+static inline void
+mlxsw_afa_qos_dscp_pack(char *payload,
+			enum mlxsw_afa_qos_dscp_cmd dscp_cmd, u8 dscp)
+{
+	mlxsw_afa_qos_dscp_cmd_set(payload, dscp_cmd);
+	mlxsw_afa_qos_dscp_set(payload, dscp);
+}
+
 static inline void
 mlxsw_afa_qos_switch_prio_pack(char *payload,
 			       enum mlxsw_afa_qos_switch_prio_cmd prio_cmd,
-- 
2.24.1


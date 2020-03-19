Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 075AF18B856
	for <lists+netdev@lfdr.de>; Thu, 19 Mar 2020 14:48:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727498AbgCSNsR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Mar 2020 09:48:17 -0400
Received: from out3-smtp.messagingengine.com ([66.111.4.27]:52755 "EHLO
        out3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727488AbgCSNsQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 Mar 2020 09:48:16 -0400
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailout.nyi.internal (Postfix) with ESMTP id F3ABC5C0315;
        Thu, 19 Mar 2020 09:48:14 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute4.internal (MEProxy); Thu, 19 Mar 2020 09:48:14 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm2; bh=HY8QK0Izan+osytOc4mgrE/zpeNndi5nbq44tZnKAQE=; b=0UHSvyJq
        aW1vugFfE+zy5snERvb95YcEl/LSfK3KK+IKUpvteHHCzBybz8tS9aqxePYiBwAV
        GWjEzrxf5IBWYNGNMdJ/ts/tb/gdhy88pOgTMeI8v1J9di+N9gyQE7jvyz08iJLV
        Rn2VMC4UnpAk4Rt5yoL6C6eWhZp61eK4HsIOMLSU7/R3WWLlvWaxZx4bZE/XJdcq
        q/H74WBfRs5QHPF6J5vt0viGZ+gY/rzUyaglgqCRBunGQelyBzDZ7ndWyHWkp1Dk
        vi3s8OSM7PKRMT3eVDm/TVTwLMt7U9IvtpIKdiqlkXbUJP0cxTb9pgrM0DYvWHFD
        L0uu0mxpjlNDjg==
X-ME-Sender: <xms:HnhzXgaGMoboa2jFRNmPqPCXyqtQUyggdCov-BBWZswUnWfCXVSdDg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedugedrudefledgheeiucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgjfhgggfestdekre
    dtredttdenucfhrhhomhepkfguohcuufgthhhimhhmvghluceoihguohhstghhsehiugho
    shgthhdrohhrgheqnecukfhppedutdelrdeiiedrudeftddrheenucevlhhushhtvghruf
    hiiigvpedunecurfgrrhgrmhepmhgrihhlfhhrohhmpehiughoshgthhesihguohhstghh
    rdhorhhg
X-ME-Proxy: <xmx:HnhzXrhUfLdu_ubtXTc9TjpEuW2bdTQFIMFfH3vJEANbXzCkd8omwg>
    <xmx:HnhzXozAg3gw-jDaqSbf4O335heYm-Ifdz9qdvxAIY82gBPY2GpuMg>
    <xmx:HnhzXu4CHCzr8AD5tHVd_iRy-8MH62Gg77LGSrdBwUsLcwgs6BxL6A>
    <xmx:HnhzXmUHeOEO4LjX5F23ll9IIDq63Biy4nJ6zTqbuuyS0Ggue7XVVQ>
Received: from splinter.mtl.com (bzq-109-66-130-5.red.bezeqint.net [109.66.130.5])
        by mail.messagingengine.com (Postfix) with ESMTPA id 3761A30614FA;
        Thu, 19 Mar 2020 09:48:11 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, jiri@mellanox.com,
        jhs@mojatatu.com, xiyou.wangcong@gmail.com, petrm@mellanox.com,
        mlxsw@mellanox.com, Ido Schimmel <idosch@mellanox.com>
Subject: [PATCH net-next 3/5] mlxsw: core: Add QOS_ACTION
Date:   Thu, 19 Mar 2020 15:47:22 +0200
Message-Id: <20200319134724.1036942-4-idosch@idosch.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200319134724.1036942-1-idosch@idosch.org>
References: <20200319134724.1036942-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Petr Machata <petrm@mellanox.com>

The QOS_ACTION is used for manipulating the QoS attributes of a packet.
Add the corresponding defines and helpers, in particular for the
switch_priority override.

Signed-off-by: Petr Machata <petrm@mellanox.com>
Reviewed-by: Jiri Pirko <jiri@mellanox.com>
Signed-off-by: Ido Schimmel <idosch@mellanox.com>
---
 .../mellanox/mlxsw/core_acl_flex_actions.c    | 35 +++++++++++++++++++
 1 file changed, 35 insertions(+)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/core_acl_flex_actions.c b/drivers/net/ethernet/mellanox/mlxsw/core_acl_flex_actions.c
index 1f2e6db743e1..fbb76377adf8 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/core_acl_flex_actions.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/core_acl_flex_actions.c
@@ -1238,6 +1238,41 @@ mlxsw_afa_block_append_mirror(struct mlxsw_afa_block *block, u8 local_in_port,
 }
 EXPORT_SYMBOL(mlxsw_afa_block_append_mirror);
 
+/* QoS Action
+ * ----------
+ * The QOS_ACTION is used for manipulating the QoS attributes of a packet. It
+ * can be used to change the DCSP, ECN, Color and Switch Priority of the packet.
+ * Note that PCP field can be changed using the VLAN action.
+ */
+
+#define MLXSW_AFA_QOS_CODE 0x06
+#define MLXSW_AFA_QOS_SIZE 1
+
+enum mlxsw_afa_qos_cmd {
+	/* Do nothing */
+	MLXSW_AFA_QOS_CMD_NOP,
+	/* Set a field */
+	MLXSW_AFA_QOS_CMD_SET,
+};
+
+/* afa_qos_switch_prio_cmd
+ * Switch Priority command as per mlxsw_afa_qos_cmd.
+ */
+MLXSW_ITEM32(afa, qos, switch_prio_cmd, 0x08, 14, 2);
+
+/* afa_qos_switch_prio
+ * Switch Priority.
+ */
+MLXSW_ITEM32(afa, qos, switch_prio, 0x08, 0, 4);
+
+static inline void
+mlxsw_afa_qos_switch_prio_pack(char *payload,
+			       enum mlxsw_afa_qos_cmd prio_cmd, u8 prio)
+{
+	mlxsw_afa_qos_switch_prio_cmd_set(payload, prio_cmd);
+	mlxsw_afa_qos_switch_prio_set(payload, prio);
+}
+
 /* Forwarding Action
  * -----------------
  * Forwarding Action can be used to implement Policy Based Switching (PBS)
-- 
2.24.1


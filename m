Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 687651940AF
	for <lists+netdev@lfdr.de>; Thu, 26 Mar 2020 15:02:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727909AbgCZOB6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Mar 2020 10:01:58 -0400
Received: from out2-smtp.messagingengine.com ([66.111.4.26]:41471 "EHLO
        out2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727792AbgCZOBy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 Mar 2020 10:01:54 -0400
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailout.nyi.internal (Postfix) with ESMTP id 9D9505C020E;
        Thu, 26 Mar 2020 10:01:53 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute4.internal (MEProxy); Thu, 26 Mar 2020 10:01:53 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm2; bh=YpyyjxHPrC63BdFNHnt8N4pKZC17WEc9NAwB5D5qIqo=; b=Q+Ui7vPX
        yK52YHuFD45AhDx9x370khmldiBWHMykeJslLoecxxfsGiTL++tKVSHFdb9JrHRu
        KP8sRTb8+UdUazve8Md4H1/NITDbWhuZKXX/quYIIHnnf86KWzOAgRBuNeXyKwi3
        QzChy3iUE5+0EyCUu3Up4CdXmpYO/M4Zv8IQEwiQUlqud+Y+D+R7tBeuLxKoStJO
        DteseZANmrGcl+bmoG5PrWvs2g5gl7f1cGshzcpQMxLUJvDRXzhu5f7zrfibqehN
        bHmCvuuvYMkbut42NibjUeA3fkWPQo1rlK35euFqRAbxiaGqexnyHtg9KajliBDX
        lRzJnKaAZBkizA==
X-ME-Sender: <xms:0bV8Xk8p5KC7sOqx46cUpVBWivJTUtuLmBKbMHFnT_zWGw__L3HT1w>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedugedrudehiedgheelucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgjfhgggfestdekre
    dtredttdenucfhrhhomhepkfguohcuufgthhhimhhmvghluceoihguohhstghhsehiugho
    shgthhdrohhrgheqnecukfhppeejledrudekuddrudefvddrudeludenucevlhhushhtvg
    hrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehiughoshgthhesihguohhs
    tghhrdhorhhg
X-ME-Proxy: <xmx:0bV8Xi10oRK_VSDBxiUKQz5D7Yh_kYHg6ool5FkeG-KvEqXg_D4ljQ>
    <xmx:0bV8XgiXzOZG7EJU8Eoy_NCkFgdaKoUjJypJHfrEdD170Y02ZiW_vg>
    <xmx:0bV8XucTxhCjWGE9u4xVUjbfRrH_WdraIBeGzrcdCycImHugBf32Jw>
    <xmx:0bV8Xrt3JpvlxHpqx2yK8q1zwkcdDNWnBObjfgug8kZad9ctURIbLA>
Received: from splinter.mtl.com (bzq-79-181-132-191.red.bezeqint.net [79.181.132.191])
        by mail.messagingengine.com (Postfix) with ESMTPA id 4234A30696D4;
        Thu, 26 Mar 2020 10:01:52 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, jiri@mellanox.com,
        petrm@mellanox.com, mlxsw@mellanox.com,
        Ido Schimmel <idosch@mellanox.com>
Subject: [PATCH net-next 2/6] mlxsw: core: Rename mlxsw_afa_qos_cmd to mlxsw_afa_qos_switch_prio_cmd
Date:   Thu, 26 Mar 2020 16:01:10 +0200
Message-Id: <20200326140114.1393972-3-idosch@idosch.org>
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

The original idea was to reuse this set of actions for ECN rewrite as well,
but on second look, it's not such a great idea. These two items should each
have its own command. Rename the existing enum to make it obvious that it
belongs to switch_prio_cmd.

Signed-off-by: Petr Machata <petrm@mellanox.com>
Reviewed-by: Jiri Pirko <jiri@mellanox.com>
Signed-off-by: Ido Schimmel <idosch@mellanox.com>
---
 .../mellanox/mlxsw/core_acl_flex_actions.c         | 14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/core_acl_flex_actions.c b/drivers/net/ethernet/mellanox/mlxsw/core_acl_flex_actions.c
index c713bc22da7d..1d0695050cfc 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/core_acl_flex_actions.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/core_acl_flex_actions.c
@@ -1248,15 +1248,14 @@ EXPORT_SYMBOL(mlxsw_afa_block_append_mirror);
 #define MLXSW_AFA_QOS_CODE 0x06
 #define MLXSW_AFA_QOS_SIZE 1
 
-enum mlxsw_afa_qos_cmd {
+enum mlxsw_afa_qos_switch_prio_cmd {
 	/* Do nothing */
-	MLXSW_AFA_QOS_CMD_NOP,
-	/* Set a field */
-	MLXSW_AFA_QOS_CMD_SET,
+	MLXSW_AFA_QOS_SWITCH_PRIO_CMD_NOP,
+	/* Set Switch Priority to afa_qos_switch_prio */
+	MLXSW_AFA_QOS_SWITCH_PRIO_CMD_SET,
 };
 
 /* afa_qos_switch_prio_cmd
- * Switch Priority command as per mlxsw_afa_qos_cmd.
  */
 MLXSW_ITEM32(afa, qos, switch_prio_cmd, 0x08, 14, 2);
 
@@ -1267,7 +1266,8 @@ MLXSW_ITEM32(afa, qos, switch_prio, 0x08, 0, 4);
 
 static inline void
 mlxsw_afa_qos_switch_prio_pack(char *payload,
-			       enum mlxsw_afa_qos_cmd prio_cmd, u8 prio)
+			       enum mlxsw_afa_qos_switch_prio_cmd prio_cmd,
+			       u8 prio)
 {
 	mlxsw_afa_qos_switch_prio_cmd_set(payload, prio_cmd);
 	mlxsw_afa_qos_switch_prio_set(payload, prio);
@@ -1285,7 +1285,7 @@ int mlxsw_afa_block_append_qos_switch_prio(struct mlxsw_afa_block *block,
 		NL_SET_ERR_MSG_MOD(extack, "Cannot append QOS action");
 		return PTR_ERR(act);
 	}
-	mlxsw_afa_qos_switch_prio_pack(act, MLXSW_AFA_QOS_CMD_SET,
+	mlxsw_afa_qos_switch_prio_pack(act, MLXSW_AFA_QOS_SWITCH_PRIO_CMD_SET,
 				       prio);
 	return 0;
 }
-- 
2.24.1


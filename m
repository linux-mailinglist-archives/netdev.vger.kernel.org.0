Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EE8AD4B24A
	for <lists+netdev@lfdr.de>; Wed, 19 Jun 2019 08:43:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731170AbfFSGmG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Jun 2019 02:42:06 -0400
Received: from out4-smtp.messagingengine.com ([66.111.4.28]:33585 "EHLO
        out4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1731111AbfFSGmF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Jun 2019 02:42:05 -0400
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.nyi.internal (Postfix) with ESMTP id BF90F21C46;
        Wed, 19 Jun 2019 02:42:04 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute3.internal (MEProxy); Wed, 19 Jun 2019 02:42:04 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm3; bh=9WZpGhH/bEAdki7EGuIG+hCEOHDJA3tDfRL+CrfGqBg=; b=HBI+8Ge6
        VsJsuJPSS+KOwyf5ZHh7flpd7Z95bwXWKTsDY3QyqOkI1z70u23c3iks/F3W//NV
        YMq0ZYiqGQLsovt5ZihZchdSEvfib8R++ZJlaqwS+P3ykj1/j6EQrCFzniH80Qq+
        oq4z0ZFh5IuVhfx0wpuo7io/P6+J8Y4Nx4/q/RQnFYuMj5jtw6iE4yU0BoZDQEgw
        qf3XvfPW4EdfAMnrVjY2yUfhn9mAm7w1MB3bLXVtCcXHp+gp1SqKAKtwZBImzgVC
        xbCOSjevZF5TthuKMEBoxoyjNxlHhWasWSu1OFZts12We8GiZq4rPUnhyJ7DokL+
        WYaU79J8zZCbRg==
X-ME-Sender: <xms:PNkJXW2dnZy4khbFscIxPkjk43zM8F_Ti7hE2KsV90kBbVQIFvJLRQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduvddrtddugdduudduucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgjfhgggfestdekre
    dtredttdenucfhrhhomhepkfguohcuufgthhhimhhmvghluceoihguohhstghhsehiugho
    shgthhdrohhrgheqnecukfhppeduleefrdegjedrudeihedrvdehudenucfrrghrrghmpe
    hmrghilhhfrhhomhepihguohhstghhsehiughoshgthhdrohhrghenucevlhhushhtvghr
    ufhiiigvpeei
X-ME-Proxy: <xmx:PNkJXav80AZ79G5_gCnuTfCahCGu1-IpY70TSudZi1oOySMaxhdbDw>
    <xmx:PNkJXS8cY0i0hJV1lVXsEWPga4lVtSXF9VX6wZZlcXxfRo7YDF70oQ>
    <xmx:PNkJXeTg6mA2pm_UR8nXWzwN7bqV-Ebi06tx1cFbfhOV02yDRzTDPA>
    <xmx:PNkJXWYemjJHIbKq9aU5S4WV6lkf6YkiBAU1o-_VQsD6xlt17BD_bw>
Received: from splinter.mtl.com (unknown [193.47.165.251])
        by mail.messagingengine.com (Postfix) with ESMTPA id CA4DF8005B;
        Wed, 19 Jun 2019 02:42:01 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, jiri@mellanox.com, jhs@mojatatu.com,
        xiyou.wangcong@gmail.com, pablo@netfilter.org,
        ecree@solarflare.com, jakub.kicinski@netronome.com,
        Ido Schimmel <idosch@mellanox.com>
Subject: [PATCH net-next 7/8] mlxsw: spectrum_flower: Implement support for ingress device matching
Date:   Wed, 19 Jun 2019 09:41:08 +0300
Message-Id: <20190619064109.849-8-idosch@idosch.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190619064109.849-1-idosch@idosch.org>
References: <20190619064109.849-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jiri Pirko <jiri@mellanox.com>

Benefit from the previously extended flow_dissector infrastructure and
offload matching on ingress port.

Signed-off-by: Jiri Pirko <jiri@mellanox.com>
Signed-off-by: Ido Schimmel <idosch@mellanox.com>
---
 .../net/ethernet/mellanox/mlxsw/spectrum.h    |  9 ++++
 .../ethernet/mellanox/mlxsw/spectrum_acl.c    |  9 +---
 .../ethernet/mellanox/mlxsw/spectrum_flower.c | 50 ++++++++++++++++++-
 3 files changed, 59 insertions(+), 9 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum.h b/drivers/net/ethernet/mellanox/mlxsw/spectrum.h
index ea4d56486ea3..84f4276193b3 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum.h
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum.h
@@ -623,6 +623,15 @@ enum mlxsw_sp_acl_profile {
 	MLXSW_SP_ACL_PROFILE_MR,
 };
 
+struct mlxsw_sp_acl_block {
+	struct list_head binding_list;
+	struct mlxsw_sp_acl_ruleset *ruleset_zero;
+	struct mlxsw_sp *mlxsw_sp;
+	unsigned int rule_count;
+	unsigned int disable_count;
+	struct net *net;
+};
+
 struct mlxsw_afk *mlxsw_sp_acl_afk(struct mlxsw_sp_acl *acl);
 struct mlxsw_sp *mlxsw_sp_acl_block_mlxsw_sp(struct mlxsw_sp_acl_block *block);
 unsigned int mlxsw_sp_acl_block_rule_count(struct mlxsw_sp_acl_block *block);
diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_acl.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_acl.c
index a146a44634e9..e8ac90564dbe 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_acl.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_acl.c
@@ -45,14 +45,6 @@ struct mlxsw_sp_acl_block_binding {
 	bool ingress;
 };
 
-struct mlxsw_sp_acl_block {
-	struct list_head binding_list;
-	struct mlxsw_sp_acl_ruleset *ruleset_zero;
-	struct mlxsw_sp *mlxsw_sp;
-	unsigned int rule_count;
-	unsigned int disable_count;
-};
-
 struct mlxsw_sp_acl_ruleset_ht_key {
 	struct mlxsw_sp_acl_block *block;
 	u32 chain_index;
@@ -221,6 +213,7 @@ struct mlxsw_sp_acl_block *mlxsw_sp_acl_block_create(struct mlxsw_sp *mlxsw_sp,
 		return NULL;
 	INIT_LIST_HEAD(&block->binding_list);
 	block->mlxsw_sp = mlxsw_sp;
+	block->net = net;
 	return block;
 }
 
diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_flower.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_flower.c
index 96b23c856f4d..a83e1a986ef1 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_flower.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_flower.c
@@ -120,6 +120,49 @@ static int mlxsw_sp_flower_parse_actions(struct mlxsw_sp *mlxsw_sp,
 	return 0;
 }
 
+static int mlxsw_sp_flower_parse_meta(struct mlxsw_sp_acl_rule_info *rulei,
+				      struct tc_cls_flower_offload *f,
+				      struct mlxsw_sp_acl_block *block)
+{
+	struct flow_rule *rule = tc_cls_flower_offload_flow_rule(f);
+	struct mlxsw_sp_port *mlxsw_sp_port;
+	struct net_device *ingress_dev;
+	struct flow_match_meta match;
+
+	if (!flow_rule_match_key(rule, FLOW_DISSECTOR_KEY_META))
+		return 0;
+
+	flow_rule_match_meta(rule, &match);
+	if (match.mask->ingress_ifindex != 0xFFFFFFFF) {
+		NL_SET_ERR_MSG_MOD(f->common.extack, "Unsupported ingress ifindex mask");
+		return -EINVAL;
+	}
+
+	ingress_dev = __dev_get_by_index(block->net,
+					 match.key->ingress_ifindex);
+	if (!ingress_dev) {
+		NL_SET_ERR_MSG_MOD(f->common.extack, "Can't find specified ingress port to match on");
+		return -EINVAL;
+	}
+
+	if (!mlxsw_sp_port_dev_check(ingress_dev)) {
+		NL_SET_ERR_MSG_MOD(f->common.extack, "Can't match on non-mlxsw ingress port");
+		return -EINVAL;
+	}
+
+	mlxsw_sp_port = netdev_priv(ingress_dev);
+	if (mlxsw_sp_port->mlxsw_sp != block->mlxsw_sp) {
+		NL_SET_ERR_MSG_MOD(f->common.extack, "Can't match on a port from different device");
+		return -EINVAL;
+	}
+
+	mlxsw_sp_acl_rulei_keymask_u32(rulei,
+				       MLXSW_AFK_ELEMENT_SRC_SYS_PORT,
+				       mlxsw_sp_port->local_port,
+				       0xFFFFFFFF);
+	return 0;
+}
+
 static void mlxsw_sp_flower_parse_ipv4(struct mlxsw_sp_acl_rule_info *rulei,
 				       struct tc_cls_flower_offload *f)
 {
@@ -267,7 +310,8 @@ static int mlxsw_sp_flower_parse(struct mlxsw_sp *mlxsw_sp,
 	int err;
 
 	if (dissector->used_keys &
-	    ~(BIT(FLOW_DISSECTOR_KEY_CONTROL) |
+	    ~(BIT(FLOW_DISSECTOR_KEY_META) |
+	      BIT(FLOW_DISSECTOR_KEY_CONTROL) |
 	      BIT(FLOW_DISSECTOR_KEY_BASIC) |
 	      BIT(FLOW_DISSECTOR_KEY_ETH_ADDRS) |
 	      BIT(FLOW_DISSECTOR_KEY_IPV4_ADDRS) |
@@ -283,6 +327,10 @@ static int mlxsw_sp_flower_parse(struct mlxsw_sp *mlxsw_sp,
 
 	mlxsw_sp_acl_rulei_priority(rulei, f->common.prio);
 
+	err = mlxsw_sp_flower_parse_meta(rulei, f, block);
+	if (err)
+		return err;
+
 	if (flow_rule_match_key(rule, FLOW_DISSECTOR_KEY_CONTROL)) {
 		struct flow_match_control match;
 
-- 
2.20.1


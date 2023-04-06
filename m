Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E33C26D8D28
	for <lists+netdev@lfdr.de>; Thu,  6 Apr 2023 04:02:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234704AbjDFCCt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Apr 2023 22:02:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34584 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233854AbjDFCCr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 Apr 2023 22:02:47 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 905F17AAC
        for <netdev@vger.kernel.org>; Wed,  5 Apr 2023 19:02:44 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 14EBC62B22
        for <netdev@vger.kernel.org>; Thu,  6 Apr 2023 02:02:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6758DC433D2;
        Thu,  6 Apr 2023 02:02:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1680746563;
        bh=k9+ZYCSfzjVVByLQaY9qvQRzEjgXkI4oCAZOc1xvnGI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=n3urchuR/stlc+vHsa3PklGOe3V9MPNZOS9vbnDrZG0Iuz6YB7CvrCCt95qHRNQXB
         FS5lSK1EkmJ0PFtYT9qs+a93z/zgMlp54tCfQxQndM24WO/qryO01qLYQmuzgliRX+
         HoECZXlnR2P0abH9zAL0PYgJ6TnRxySzVfarG1okBmuKf0d4LfE8u0nDl8iDM+rpaG
         go/f0eJcXCdhSALijU3VsADHiIrZzNwdPLcDB5oChLmaiDdwJp9fVGVo0T8kuzSNnF
         AJmRXmJE5s/zTiYB3+L7AUo6J0HGr9hQJ6bu0MOGSoqbEd4qQfzVlkz5CaRPKqOtzJ
         bWTXzTkTI9Uxg==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>
Cc:     Saeed Mahameed <saeedm@nvidia.com>, netdev@vger.kernel.org,
        Tariq Toukan <tariqt@nvidia.com>,
        Paul Blakey <paulb@nvidia.com>, Roi Dayan <roid@nvidia.com>
Subject: [net-next 01/15] net/mlx5e: Set default can_offload action
Date:   Wed,  5 Apr 2023 19:02:18 -0700
Message-Id: <20230406020232.83844-2-saeed@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230406020232.83844-1-saeed@kernel.org>
References: <20230406020232.83844-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-5.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Paul Blakey <paulb@nvidia.com>

Many parsers of tc actions just return true on their can_offload()
implementation, without checking the input flow/action.
Set the default can_offload action to true (allow), and avoid
having many can_offload implementations that do just that.

This patch doesn't change any functionality.

Signed-off-by: Paul Blakey <paulb@nvidia.com>
Reviewed-by: Roi Dayan <roid@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 .../net/ethernet/mellanox/mlx5/core/en/tc/act/accept.c | 10 ----------
 .../net/ethernet/mellanox/mlx5/core/en/tc/act/drop.c   | 10 ----------
 .../net/ethernet/mellanox/mlx5/core/en/tc/act/pedit.c  | 10 ----------
 .../net/ethernet/mellanox/mlx5/core/en/tc/act/ptype.c  | 10 ----------
 .../net/ethernet/mellanox/mlx5/core/en/tc/act/trap.c   | 10 ----------
 .../net/ethernet/mellanox/mlx5/core/en/tc/act/tun.c    | 10 ----------
 .../net/ethernet/mellanox/mlx5/core/en/tc/act/vlan.c   | 10 ----------
 .../mellanox/mlx5/core/en/tc/act/vlan_mangle.c         | 10 ----------
 drivers/net/ethernet/mellanox/mlx5/core/en_tc.c        |  2 +-
 9 files changed, 1 insertion(+), 81 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/tc/act/accept.c b/drivers/net/ethernet/mellanox/mlx5/core/en/tc/act/accept.c
index a278f52d52b0..9db1b5307a8d 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/tc/act/accept.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/tc/act/accept.c
@@ -4,15 +4,6 @@
 #include "act.h"
 #include "en/tc_priv.h"
 
-static bool
-tc_act_can_offload_accept(struct mlx5e_tc_act_parse_state *parse_state,
-			  const struct flow_action_entry *act,
-			  int act_index,
-			  struct mlx5_flow_attr *attr)
-{
-	return true;
-}
-
 static int
 tc_act_parse_accept(struct mlx5e_tc_act_parse_state *parse_state,
 		    const struct flow_action_entry *act,
@@ -26,7 +17,6 @@ tc_act_parse_accept(struct mlx5e_tc_act_parse_state *parse_state,
 }
 
 struct mlx5e_tc_act mlx5e_tc_act_accept = {
-	.can_offload = tc_act_can_offload_accept,
 	.parse_action = tc_act_parse_accept,
 	.is_terminating_action = true,
 };
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/tc/act/drop.c b/drivers/net/ethernet/mellanox/mlx5/core/en/tc/act/drop.c
index 7d16aeabb119..5dc81715d625 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/tc/act/drop.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/tc/act/drop.c
@@ -4,15 +4,6 @@
 #include "act.h"
 #include "en/tc_priv.h"
 
-static bool
-tc_act_can_offload_drop(struct mlx5e_tc_act_parse_state *parse_state,
-			const struct flow_action_entry *act,
-			int act_index,
-			struct mlx5_flow_attr *attr)
-{
-	return true;
-}
-
 static int
 tc_act_parse_drop(struct mlx5e_tc_act_parse_state *parse_state,
 		  const struct flow_action_entry *act,
@@ -25,7 +16,6 @@ tc_act_parse_drop(struct mlx5e_tc_act_parse_state *parse_state,
 }
 
 struct mlx5e_tc_act mlx5e_tc_act_drop = {
-	.can_offload = tc_act_can_offload_drop,
 	.parse_action = tc_act_parse_drop,
 	.is_terminating_action = true,
 };
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/tc/act/pedit.c b/drivers/net/ethernet/mellanox/mlx5/core/en/tc/act/pedit.c
index 47597c524e59..3b272bbf4c53 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/tc/act/pedit.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/tc/act/pedit.c
@@ -78,15 +78,6 @@ mlx5e_tc_act_pedit_parse_action(struct mlx5e_priv *priv,
 	return err;
 }
 
-static bool
-tc_act_can_offload_pedit(struct mlx5e_tc_act_parse_state *parse_state,
-			 const struct flow_action_entry *act,
-			 int act_index,
-			 struct mlx5_flow_attr *attr)
-{
-	return true;
-}
-
 static int
 tc_act_parse_pedit(struct mlx5e_tc_act_parse_state *parse_state,
 		   const struct flow_action_entry *act,
@@ -114,6 +105,5 @@ tc_act_parse_pedit(struct mlx5e_tc_act_parse_state *parse_state,
 }
 
 struct mlx5e_tc_act mlx5e_tc_act_pedit = {
-	.can_offload = tc_act_can_offload_pedit,
 	.parse_action = tc_act_parse_pedit,
 };
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/tc/act/ptype.c b/drivers/net/ethernet/mellanox/mlx5/core/en/tc/act/ptype.c
index 6454b031ff7a..80b4bc64380a 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/tc/act/ptype.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/tc/act/ptype.c
@@ -4,15 +4,6 @@
 #include "act.h"
 #include "en/tc_priv.h"
 
-static bool
-tc_act_can_offload_ptype(struct mlx5e_tc_act_parse_state *parse_state,
-			 const struct flow_action_entry *act,
-			 int act_index,
-			 struct mlx5_flow_attr *attr)
-{
-	return true;
-}
-
 static int
 tc_act_parse_ptype(struct mlx5e_tc_act_parse_state *parse_state,
 		   const struct flow_action_entry *act,
@@ -31,6 +22,5 @@ tc_act_parse_ptype(struct mlx5e_tc_act_parse_state *parse_state,
 }
 
 struct mlx5e_tc_act mlx5e_tc_act_ptype = {
-	.can_offload = tc_act_can_offload_ptype,
 	.parse_action = tc_act_parse_ptype,
 };
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/tc/act/trap.c b/drivers/net/ethernet/mellanox/mlx5/core/en/tc/act/trap.c
index 915ce201aeb2..1b78bd9c106a 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/tc/act/trap.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/tc/act/trap.c
@@ -5,15 +5,6 @@
 #include "en/tc_priv.h"
 #include "eswitch.h"
 
-static bool
-tc_act_can_offload_trap(struct mlx5e_tc_act_parse_state *parse_state,
-			const struct flow_action_entry *act,
-			int act_index,
-			struct mlx5_flow_attr *attr)
-{
-	return true;
-}
-
 static int
 tc_act_parse_trap(struct mlx5e_tc_act_parse_state *parse_state,
 		  const struct flow_action_entry *act,
@@ -27,6 +18,5 @@ tc_act_parse_trap(struct mlx5e_tc_act_parse_state *parse_state,
 }
 
 struct mlx5e_tc_act mlx5e_tc_act_trap = {
-	.can_offload = tc_act_can_offload_trap,
 	.parse_action = tc_act_parse_trap,
 };
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/tc/act/tun.c b/drivers/net/ethernet/mellanox/mlx5/core/en/tc/act/tun.c
index b4fa2de9711d..f1cae21c2c37 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/tc/act/tun.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/tc/act/tun.c
@@ -32,15 +32,6 @@ tc_act_parse_tun_encap(struct mlx5e_tc_act_parse_state *parse_state,
 	return 0;
 }
 
-static bool
-tc_act_can_offload_tun_decap(struct mlx5e_tc_act_parse_state *parse_state,
-			     const struct flow_action_entry *act,
-			     int act_index,
-			     struct mlx5_flow_attr *attr)
-{
-	return true;
-}
-
 static int
 tc_act_parse_tun_decap(struct mlx5e_tc_act_parse_state *parse_state,
 		       const struct flow_action_entry *act,
@@ -58,6 +49,5 @@ struct mlx5e_tc_act mlx5e_tc_act_tun_encap = {
 };
 
 struct mlx5e_tc_act mlx5e_tc_act_tun_decap = {
-	.can_offload = tc_act_can_offload_tun_decap,
 	.parse_action = tc_act_parse_tun_decap,
 };
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/tc/act/vlan.c b/drivers/net/ethernet/mellanox/mlx5/core/en/tc/act/vlan.c
index 2e0d88b513aa..c8a3eaf189f6 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/tc/act/vlan.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/tc/act/vlan.c
@@ -141,15 +141,6 @@ mlx5e_tc_act_vlan_add_pop_action(struct mlx5e_priv *priv,
 	return err;
 }
 
-static bool
-tc_act_can_offload_vlan(struct mlx5e_tc_act_parse_state *parse_state,
-			const struct flow_action_entry *act,
-			int act_index,
-			struct mlx5_flow_attr *attr)
-{
-	return true;
-}
-
 static int
 tc_act_parse_vlan(struct mlx5e_tc_act_parse_state *parse_state,
 		  const struct flow_action_entry *act,
@@ -205,7 +196,6 @@ tc_act_post_parse_vlan(struct mlx5e_tc_act_parse_state *parse_state,
 }
 
 struct mlx5e_tc_act mlx5e_tc_act_vlan = {
-	.can_offload = tc_act_can_offload_vlan,
 	.parse_action = tc_act_parse_vlan,
 	.post_parse = tc_act_post_parse_vlan,
 };
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/tc/act/vlan_mangle.c b/drivers/net/ethernet/mellanox/mlx5/core/en/tc/act/vlan_mangle.c
index 9a8a1a6bd99e..310b99230760 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/tc/act/vlan_mangle.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/tc/act/vlan_mangle.c
@@ -50,15 +50,6 @@ mlx5e_tc_act_vlan_add_rewrite_action(struct mlx5e_priv *priv, int namespace,
 	return err;
 }
 
-static bool
-tc_act_can_offload_vlan_mangle(struct mlx5e_tc_act_parse_state *parse_state,
-			       const struct flow_action_entry *act,
-			       int act_index,
-			       struct mlx5_flow_attr *attr)
-{
-	return true;
-}
-
 static int
 tc_act_parse_vlan_mangle(struct mlx5e_tc_act_parse_state *parse_state,
 			 const struct flow_action_entry *act,
@@ -81,6 +72,5 @@ tc_act_parse_vlan_mangle(struct mlx5e_tc_act_parse_state *parse_state,
 }
 
 struct mlx5e_tc_act mlx5e_tc_act_vlan_mangle = {
-	.can_offload = tc_act_can_offload_vlan_mangle,
 	.parse_action = tc_act_parse_vlan_mangle,
 };
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
index 083ce31f95b6..4140155e3487 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
@@ -4096,7 +4096,7 @@ parse_tc_actions(struct mlx5e_tc_act_parse_state *parse_state,
 			goto out_free;
 		}
 
-		if (!tc_act->can_offload(parse_state, act, i, attr)) {
+		if (tc_act->can_offload && !tc_act->can_offload(parse_state, act, i, attr)) {
 			err = -EOPNOTSUPP;
 			goto out_free;
 		}
-- 
2.39.2


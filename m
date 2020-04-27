Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D03431BA78D
	for <lists+netdev@lfdr.de>; Mon, 27 Apr 2020 17:13:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728197AbgD0PNl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Apr 2020 11:13:41 -0400
Received: from out3-smtp.messagingengine.com ([66.111.4.27]:33627 "EHLO
        out3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727006AbgD0PNi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Apr 2020 11:13:38 -0400
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailout.nyi.internal (Postfix) with ESMTP id EB0225C00A1;
        Mon, 27 Apr 2020 11:13:37 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute4.internal (MEProxy); Mon, 27 Apr 2020 11:13:37 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm2; bh=aBX2E9if+eXrZ+kE/i6+B8y5egQ13zpGdYYC8LuXabE=; b=ih+BNd0Z
        Mpxqw6Za5jdKbgAArOf/Ke7amxMssvdxsGTsAmUBGjqDD02q/ehM8bidpgAdLIgE
        iQ90Jpf4balhJp23x+VC5HBYR0NS7XtJVWltbOTtFtbWWDeJB2ZkuwB6iwmrDGwN
        3m3szeWzZ3U7OYqtIiO9cBFnjk1U0nra2o3j6+QwVNVI+E32ukDnM2Ei0YpQwWe1
        xQzuxE83mby/7qMyEjwEG+ObAME4/mWKZ9vgyteA4WdMrPwangWm8BKHuSzfnSYF
        FYfsAL2bMtudvIco3hgqvgCmjVBmk8L3MjmQNmcEKSMtpj32ZjjYCQhOyOVbn/lk
        unKj4hupZ0KvGg==
X-ME-Sender: <xms:ofamXsfS0-_IF7R9XVALngggzQZHOlGtBnt8CjEPOFNG8uTFmt6f6w>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduhedrheelgdekgecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhephffvufffkffojghfggfgsedtkeertd
    ertddtnecuhfhrohhmpefkughoucfutghhihhmmhgvlhcuoehiughoshgthhesihguohhs
    tghhrdhorhhgqeenucfkphepjeelrddukedtrdehgedrudduieenucevlhhushhtvghruf
    hiiigvpedvnecurfgrrhgrmhepmhgrihhlfhhrohhmpehiughoshgthhesihguohhstghh
    rdhorhhg
X-ME-Proxy: <xmx:ofamXqh1rg_-Pozi29s_ELd5TFWL8xFfD9oPZcTtGznO1itnpJe7_w>
    <xmx:ofamXgQS3KB_t5LSQqm_3LiDX30WTm4BsSQ5QmbfqiRWsjMF73l6iw>
    <xmx:ofamXjzjJiLkMYYDrLVKtb-zyXT5hhBfkCNAk76lC1hCTDYSM3NT3Q>
    <xmx:ofamXoPIn98ljm1VsXkdXAH0wn5U77dP7RYw9DrYpWQWGYuGcwEncg>
Received: from splinter.mtl.com (bzq-79-180-54-116.red.bezeqint.net [79.180.54.116])
        by mail.messagingengine.com (Postfix) with ESMTPA id ABC83328005A;
        Mon, 27 Apr 2020 11:13:36 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, jiri@mellanox.com, mlxsw@mellanox.com,
        Ido Schimmel <idosch@mellanox.com>
Subject: [PATCH net-next 05/13] mlxsw: spectrum_acl: Use block variable in mlxsw_sp_acl_rule_del()
Date:   Mon, 27 Apr 2020 18:13:02 +0300
Message-Id: <20200427151310.3950411-6-idosch@idosch.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200427151310.3950411-1-idosch@idosch.org>
References: <20200427151310.3950411-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jiri Pirko <jiri@mellanox.com>

On couple of places in mlxsw_sp_acl_rule_del(), block variable is not
used directly as it could be. So do it.

Signed-off-by: Jiri Pirko <jiri@mellanox.com>
Signed-off-by: Ido Schimmel <idosch@mellanox.com>
---
 drivers/net/ethernet/mellanox/mlxsw/spectrum_acl.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_acl.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_acl.c
index 800eaa6be3c0..c61f78e30397 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_acl.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_acl.c
@@ -704,14 +704,13 @@ void mlxsw_sp_acl_rule_del(struct mlxsw_sp *mlxsw_sp,
 
 	block->egress_blocker_rule_count -= rule->rulei->egress_bind_blocker;
 	block->ingress_blocker_rule_count -= rule->rulei->ingress_bind_blocker;
-	ruleset->ht_key.block->rule_count--;
+	block->rule_count--;
 	mutex_lock(&mlxsw_sp->acl->rules_lock);
 	list_del(&rule->list);
 	mutex_unlock(&mlxsw_sp->acl->rules_lock);
 	if (!ruleset->ht_key.chain_index &&
 	    mlxsw_sp_acl_ruleset_is_singular(ruleset))
-		mlxsw_sp_acl_ruleset_block_unbind(mlxsw_sp, ruleset,
-						  ruleset->ht_key.block);
+		mlxsw_sp_acl_ruleset_block_unbind(mlxsw_sp, ruleset, block);
 	rhashtable_remove_fast(&ruleset->rule_ht, &rule->ht_node,
 			       mlxsw_sp_acl_rule_ht_params);
 	ops->rule_del(mlxsw_sp, rule->priv);
-- 
2.24.1


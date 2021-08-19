Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DE68F3F1799
	for <lists+netdev@lfdr.de>; Thu, 19 Aug 2021 12:59:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238410AbhHSLAA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Aug 2021 07:00:00 -0400
Received: from out5-smtp.messagingengine.com ([66.111.4.29]:55131 "EHLO
        out5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S236149AbhHSK77 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 Aug 2021 06:59:59 -0400
Received: from compute2.internal (compute2.nyi.internal [10.202.2.42])
        by mailout.nyi.internal (Postfix) with ESMTP id B37F95C0159;
        Thu, 19 Aug 2021 06:59:22 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute2.internal (MEProxy); Thu, 19 Aug 2021 06:59:22 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :message-id:mime-version:subject:to:x-me-proxy:x-me-proxy
        :x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=Fbh/GUGixdVIS398e
        w3saLTA8QL4tpBuyFiDFzaG+0M=; b=YnxASP+4+unwFGxQEEoEZE00mhxYXVNYB
        lSpKSvDX/WnD+JPDA4QlN6+kxG+sDQGYH5uXJzqZz9cYCabthWuX7ERsdZeyLyPA
        RZzXOmPYEWix5s6uFDMqRM7+HmaIze0jYfu9krndD8pIRVcn41Wdall14ZDuQR8g
        9j7ZIlR/PyVZ7kdcYoCDZxdNB2rYMGV5jrLexPPWeZ6oLG7q1atwQBX3pHbR3aHj
        BKQEwqF8T+RzQfUUVQHKU0O3vGqdpKewBhhCnLjo4sF4gs2Vli/EBNhy5cHNS5be
        fGAUJ9/O07a/3tD+ARYbIxCH3ZBVMiWGUvpN0940WtLbm5m1exppw==
X-ME-Sender: <xms:iTkeYXYDG7Qtxb-kqpfWfeLb9ksRYxeavekL635wG83LiBYjlnfcYw>
    <xme:iTkeYWaZWsH0AdneleDo_LZPWwJUWmZxSSXQM7l0BgmqbZVMGq8Q-1nkCsWYlo7f2
    DcrL_y2Qea7ysQ>
X-ME-Received: <xmr:iTkeYZ9MzY7KrtZJfbXfYrrtTedGmZn2DruZaBB6uq2nHH7rE1mxjuK9vQvfUK1vzZkO_udUYphLIHB3ReLI72FClCsaCPuVmg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvtddrleejgdeffecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhephffvufffkffoggfgsedtkeertdertd
    dtnecuhfhrohhmpefkughoucfutghhihhmmhgvlhcuoehiughoshgthhesihguohhstghh
    rdhorhhgqeenucggtffrrghtthgvrhhnpeetveeghfevgffgffekueffuedvhfeuheehte
    ffieekgeehveefvdegledvffduhfenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgr
    mhepmhgrihhlfhhrohhmpehiughoshgthhesihguohhstghhrdhorhhg
X-ME-Proxy: <xmx:iTkeYdrltwmFL1lCl7AGgfiGFkV9JIPEYwvRJ09dXrX4P0ANtM-HJQ>
    <xmx:iTkeYSp-ColSTipaaeoFZUZ08mTfOT9d4s3bA7kqMPCBpRCicGCBaQ>
    <xmx:iTkeYTQQcAL98840onxwOV9D5yjI6F3Y_TYieVrXw2h58TldyRJPkA>
    <xmx:ijkeYblJV4aAo42gRncjxkfLe7quHwW7bVtSgXNnnP6b0APjTbL3BA>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Thu,
 19 Aug 2021 06:59:19 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, jhs@mojatatu.com,
        mlxsw@nvidia.com, Ido Schimmel <idosch@nvidia.com>,
        gushengxian <gushengxian@yulong.com>
Subject: [PATCH net] Revert "flow_offload: action should not be NULL when it is referenced"
Date:   Thu, 19 Aug 2021 13:58:42 +0300
Message-Id: <20210819105842.1315705-1-idosch@idosch.org>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ido Schimmel <idosch@nvidia.com>

This reverts commit 9ea3e52c5bc8bb4a084938dc1e3160643438927a.

Cited commit added a check to make sure 'action' is not NULL, but
'action' is already dereferenced before the check, when calling
flow_offload_has_one_action().

Therefore, the check does not make any sense and results in a smatch
warning:

include/net/flow_offload.h:322 flow_action_mixed_hw_stats_check() warn:
variable dereferenced before check 'action' (see line 319)

Fix by reverting this commit.

Cc: gushengxian <gushengxian@yulong.com>
Fixes: 9ea3e52c5bc8 ("flow_offload: action should not be NULL when it is referenced")
Signed-off-by: Ido Schimmel <idosch@nvidia.com>
---
 include/net/flow_offload.h | 12 +++++-------
 1 file changed, 5 insertions(+), 7 deletions(-)

diff --git a/include/net/flow_offload.h b/include/net/flow_offload.h
index f3c2841566a0..1b9d75aedb22 100644
--- a/include/net/flow_offload.h
+++ b/include/net/flow_offload.h
@@ -319,14 +319,12 @@ flow_action_mixed_hw_stats_check(const struct flow_action *action,
 	if (flow_offload_has_one_action(action))
 		return true;
 
-	if (action) {
-		flow_action_for_each(i, action_entry, action) {
-			if (i && action_entry->hw_stats != last_hw_stats) {
-				NL_SET_ERR_MSG_MOD(extack, "Mixing HW stats types for actions is not supported");
-				return false;
-			}
-			last_hw_stats = action_entry->hw_stats;
+	flow_action_for_each(i, action_entry, action) {
+		if (i && action_entry->hw_stats != last_hw_stats) {
+			NL_SET_ERR_MSG_MOD(extack, "Mixing HW stats types for actions is not supported");
+			return false;
 		}
+		last_hw_stats = action_entry->hw_stats;
 	}
 	return true;
 }
-- 
2.31.1


Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 857FB77AC9
	for <lists+netdev@lfdr.de>; Sat, 27 Jul 2019 19:37:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387995AbfG0Rdz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 27 Jul 2019 13:33:55 -0400
Received: from out4-smtp.messagingengine.com ([66.111.4.28]:54555 "EHLO
        out4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2387665AbfG0Rdz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 27 Jul 2019 13:33:55 -0400
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.nyi.internal (Postfix) with ESMTP id 0D07D210A8;
        Sat, 27 Jul 2019 13:33:54 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute3.internal (MEProxy); Sat, 27 Jul 2019 13:33:54 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm3; bh=InOQnjBqsEVOqO7mir0WG9cyaUjqxQEPU0FHPNf0T3M=; b=v5martfM
        xEWwGqWguvgY6IhccoUIxmyIScMBE0aZqGU5evYIMHwujOaZL9tsF+vK4n3/YLpC
        HTFhBGKxrtjSYwndcjexhJL/1V0HiHT/698mRHvA9C/n3rirOugTxrcWQph9c1EU
        GEHbeaNZcSKGNxphyuAbwJSgSsZ7lK1wENbJ0MY6xhpgyoWKn3nx2LB+xRrw7r2A
        kyXNkjG74OAtkI2O7FmSappgkYjYvku/WOL15+K7SA3C5YbulIrlUvhCJV280BqR
        6pW1rRaJOhabfvNOrVXWN9PggIiNAtu34tZ9L1J5OQQKq1UQ4j0Y1zaIwaeuiHG3
        PjMjabzdFZFAJw==
X-ME-Sender: <xms:AYs8XXJ5OaBJRWLs8OBdYw86Az9twNEcfoVLREsEM6Q8-yEha1S7bw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduvddrkeeigdduudejucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgjfhgggfestdekre
    dtredttdenucfhrhhomhepkfguohcuufgthhhimhhmvghluceoihguohhstghhsehiugho
    shgthhdrohhrgheqnecukfhppeejjedrudefkedrvdegledrvddtleenucfrrghrrghmpe
    hmrghilhhfrhhomhepihguohhstghhsehiughoshgthhdrohhrghenucevlhhushhtvghr
    ufhiiigvpedu
X-ME-Proxy: <xmx:AYs8XW34-UfVxXA_waTXo2uBkR1zq5cy7g049EN-SF1Hs-6coWVTxA>
    <xmx:AYs8XWmsjpFT7XvIgROzNYU5ijNXkMyMg2_uMpRzCEs3ifHn1oqNWA>
    <xmx:AYs8XVN_XnV38WuKY0b9lBceTFDvBYHGWEwWDzdClyRjtv3YkJaEBA>
    <xmx:Aos8XQPQBPdX_kAhPBW_K15W3YMciCvrLZPr1kbWfwgiRkN6lwL07Q>
Received: from splinter.mtl.com (unknown [77.138.249.209])
        by mail.messagingengine.com (Postfix) with ESMTPA id 4F430380074;
        Sat, 27 Jul 2019 13:33:52 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, jiri@mellanox.com, mlxsw@mellanox.com,
        Ido Schimmel <idosch@mellanox.com>
Subject: [PATCH net-next 3/3] mlxsw: spectrum_flower: Forbid to offload match on reserved TCP flags bits
Date:   Sat, 27 Jul 2019 20:32:57 +0300
Message-Id: <20190727173257.6848-4-idosch@idosch.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190727173257.6848-1-idosch@idosch.org>
References: <20190727173257.6848-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jiri Pirko <jiri@mellanox.com>

Matching on reserved TCP flags bits is only supported using custom
parser. Since the usecase for that is not known now, just forbid to
offload rules that match on these bits.

Reported-by: Alex Kushnarov <alexanderk@mellanox.com>
Signed-off-by: Jiri Pirko <jiri@mellanox.com>
Signed-off-by: Ido Schimmel <idosch@mellanox.com>
---
 drivers/net/ethernet/mellanox/mlxsw/spectrum_flower.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_flower.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_flower.c
index c86d582dafbe..0ad1a24abfc6 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_flower.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_flower.c
@@ -267,6 +267,12 @@ static int mlxsw_sp_flower_parse_tcp(struct mlxsw_sp *mlxsw_sp,
 
 	flow_rule_match_tcp(rule, &match);
 
+	if (match.mask->flags & htons(0x0E00)) {
+		NL_SET_ERR_MSG_MOD(f->common.extack, "TCP flags match not supported on reserved bits");
+		dev_err(mlxsw_sp->bus_info->dev, "TCP flags match not supported on reserved bits\n");
+		return -EINVAL;
+	}
+
 	mlxsw_sp_acl_rulei_keymask_u32(rulei, MLXSW_AFK_ELEMENT_TCP_FLAGS,
 				       ntohs(match.key->flags),
 				       ntohs(match.mask->flags));
-- 
2.21.0


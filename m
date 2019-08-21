Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 735119733E
	for <lists+netdev@lfdr.de>; Wed, 21 Aug 2019 09:20:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728210AbfHUHUd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Aug 2019 03:20:33 -0400
Received: from out2-smtp.messagingengine.com ([66.111.4.26]:39801 "EHLO
        out2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728186AbfHUHUb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 21 Aug 2019 03:20:31 -0400
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.nyi.internal (Postfix) with ESMTP id 0A9DB220A9;
        Wed, 21 Aug 2019 03:20:31 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute3.internal (MEProxy); Wed, 21 Aug 2019 03:20:31 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm3; bh=VYVwyKp+jN6Npnn4tfwZxUx0j2q6QTnvBvk1LI0sxhc=; b=owYSDi41
        KM9FaBjl4aVZybd2ekmXQgI6oPQ+ta8kaI036MUB1XTiMXYJXeYe6mFWgfCYeKkU
        /fnfS7DPLmRiNsrZ/vNDyWOJfamIWnE2+J0iAlCqg/T4KJHmzb8HbZfxl5370MCA
        v4B0w7OKNTSFxh8UuT7A6RwjdTr4pwAjgeoNy4abA7+zXMk7zQ3NWkB6F5AZFUcW
        Iz79KgEoE2tQuyy6GPPbFLPc2VEpCsLdoDV7xqJehwlEj4ci10dpz+9h+AVh5KfG
        UUL1QKi7wie73XkAENIrSbauwb01DBR0x3rMFjp6WJrrQ5TcC5YnR9U5Uvbk+3r4
        pIG2zcPiu/px8A==
X-ME-Sender: <xms:vvBcXeETWCBmDpByPWUcJ2Dg7fFfOtsehI6iZwHKaNhMqNBgHerVqQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduvddrudegvddguddvudcutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecunecujfgurhephffvufffkffojghfggfgsedtke
    ertdertddtnecuhfhrohhmpefkughoucfutghhihhmmhgvlhcuoehiughoshgthhesihgu
    ohhstghhrdhorhhgqeenucfkphepudelfedrgeejrdduieehrddvhedunecurfgrrhgrmh
    epmhgrihhlfhhrohhmpehiughoshgthhesihguohhstghhrdhorhhgnecuvehluhhsthgv
    rhfuihiivgepfe
X-ME-Proxy: <xmx:vvBcXdKq6DG3Fn1wn-F_cC0iPV9YnZuosVFCJPRkyPb13se1fR50iw>
    <xmx:vvBcXSmdYoywlCwQqQS2RjZaLdUIVhYf4GeizBywNktqk19njGXxnA>
    <xmx:vvBcXVQOkh05doQHe6YR2IOCFTM9M3TEvvbvBIQpT0WlSphdTRKlAA>
    <xmx:v_BcXf9Md7Kr0d3-mPjSUxcXSEyeCSfN-6S-vZQEdKiB9L3T273a7g>
Received: from splinter.mtl.com (unknown [193.47.165.251])
        by mail.messagingengine.com (Postfix) with ESMTPA id 2310DD6005E;
        Wed, 21 Aug 2019 03:20:28 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, jiri@mellanox.com, dsahern@gmail.com,
        mlxsw@mellanox.com, Ido Schimmel <idosch@mellanox.com>
Subject: [PATCH net-next 4/7] mlxsw: Add trap group for layer 2 discards
Date:   Wed, 21 Aug 2019 10:19:34 +0300
Message-Id: <20190821071937.13622-5-idosch@idosch.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190821071937.13622-1-idosch@idosch.org>
References: <20190821071937.13622-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ido Schimmel <idosch@mellanox.com>

Discard trap groups are defined in a different enum so that they could
all share the same policer ID: MLXSW_REG_HTGT_TRAP_GROUP_MAX + 1.

Signed-off-by: Ido Schimmel <idosch@mellanox.com>
Acked-by: Jiri Pirko <jiri@mellanox.com>
---
 drivers/net/ethernet/mellanox/mlxsw/reg.h | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/reg.h b/drivers/net/ethernet/mellanox/mlxsw/reg.h
index 59e296562b5a..baa20cdd65df 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/reg.h
+++ b/drivers/net/ethernet/mellanox/mlxsw/reg.h
@@ -5422,6 +5422,14 @@ enum mlxsw_reg_htgt_trap_group {
 	MLXSW_REG_HTGT_TRAP_GROUP_SP_LBERROR,
 	MLXSW_REG_HTGT_TRAP_GROUP_SP_PTP0,
 	MLXSW_REG_HTGT_TRAP_GROUP_SP_PTP1,
+
+	__MLXSW_REG_HTGT_TRAP_GROUP_MAX,
+	MLXSW_REG_HTGT_TRAP_GROUP_MAX = __MLXSW_REG_HTGT_TRAP_GROUP_MAX - 1
+};
+
+enum mlxsw_reg_htgt_discard_trap_group {
+	MLXSW_REG_HTGT_DISCARD_TRAP_GROUP_BASE = MLXSW_REG_HTGT_TRAP_GROUP_MAX,
+	MLXSW_REG_HTGT_TRAP_GROUP_SP_L2_DISCARDS,
 };
 
 /* reg_htgt_trap_group
-- 
2.21.0


Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 00E64196F3C
	for <lists+netdev@lfdr.de>; Sun, 29 Mar 2020 20:22:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728614AbgC2SWc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 29 Mar 2020 14:22:32 -0400
Received: from new2-smtp.messagingengine.com ([66.111.4.224]:51201 "EHLO
        new2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728467AbgC2SWb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 29 Mar 2020 14:22:31 -0400
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailnew.nyi.internal (Postfix) with ESMTP id CBDE658090C;
        Sun, 29 Mar 2020 14:22:30 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute4.internal (MEProxy); Sun, 29 Mar 2020 14:22:30 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm2; bh=0ZPz9qMvTYlXx4wYQuhJJCeI2ymcYIX+JBiCZuuBCjo=; b=rQjp1pnI
        m/lS6c+cLetv/vS/cu3a7rEpbttREfuezK3QQO2xDTjvYo56q2AVefn4jLiE5sGO
        wxLhcSpcc+VWphegJH9qzuLWVvd3+UGv16T8JCL8/D97iZsArl28dKEQDDWC2Nl4
        AoxQ/yFBN9eI/hmFDmZipsHtEstYiLm8JFB/MLUFVibnNm6Op9hXZRgbyusqo+Ai
        t7Jad98sCar3NlyRKZRZ9WkvX2rvTRm1A6XiBb8M3nMybdhWPqSGI+xnzP71glNT
        NO3TPjJkt+nr7kVUw7QynSFHb/TKe0W4+ZRWSCFC2D73hlhTL5+vewM1m7SzEKZj
        pU6l0DJYi/3G8w==
X-ME-Sender: <xms:ZueAXrbNm4nUvZyH_GgYRtSFi9jjf_4or6nT2RSNtlvtVGa4fyBORg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedugedrudeifedguddviecutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecunecujfgurhephffvufffkffojghfggfgsedtke
    ertdertddtnecuhfhrohhmpefkughoucfutghhihhmmhgvlhcuoehiughoshgthhesihgu
    ohhstghhrdhorhhgqeenucfkphepjeelrddukedurddufedvrdduledunecuvehluhhsth
    gvrhfuihiivgepuddunecurfgrrhgrmhepmhgrihhlfhhrohhmpehiughoshgthhesihgu
    ohhstghhrdhorhhg
X-ME-Proxy: <xmx:ZueAXkEoQgBg-AGADFK9uWbXYyBv1R1lux_65H8U_CJhQwhtjP8ltw>
    <xmx:ZueAXk5pusEyriVcPfoibHqlAY6AZ8txd52cLxJxkfF38Z8GKrDD9w>
    <xmx:ZueAXlsHG1MHCUogipCi0NxBD-gKPcQaoTbKi8mYZmk5W1CCvGi6tw>
    <xmx:ZueAXji_AvPVvX5ANS9L5l8S8RRra1QvINH8njDh-eJQeX7ZDyLmNA>
Received: from splinter.mtl.com (bzq-79-181-132-191.red.bezeqint.net [79.181.132.191])
        by mail.messagingengine.com (Postfix) with ESMTPA id C63A1328005A;
        Sun, 29 Mar 2020 14:22:27 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, jiri@mellanox.com,
        roopa@cumulusnetworks.com, nikolay@cumulusnetworks.com,
        andrew@lunn.ch, f.fainelli@gmail.com, vivien.didelot@gmail.com,
        mlxsw@mellanox.com, Ido Schimmel <idosch@mellanox.com>
Subject: [PATCH net-next v2 12/15] mlxsw: spectrum_trap: Do not initialize dedicated discard policer
Date:   Sun, 29 Mar 2020 21:21:16 +0300
Message-Id: <20200329182119.2207630-13-idosch@idosch.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200329182119.2207630-1-idosch@idosch.org>
References: <20200329182119.2207630-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ido Schimmel <idosch@mellanox.com>

The policer is now initialized as part of the registration with devlink,
so there is no need to initialize it before the registration.

Remove the initialization.

Signed-off-by: Ido Schimmel <idosch@mellanox.com>
Reviewed-by: Jiri Pirko <jiri@mellanox.com>
---
 drivers/net/ethernet/mellanox/mlxsw/spectrum_trap.c | 10 +---------
 1 file changed, 1 insertion(+), 9 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_trap.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_trap.c
index b2e41eb5ffdb..579f1164ad5d 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_trap.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_trap.c
@@ -307,8 +307,7 @@ static const u16 mlxsw_sp_listener_devlink_map[] = {
 	DEVLINK_TRAP_GENERIC_ID_EGRESS_FLOW_ACTION_DROP,
 };
 
-#define MLXSW_SP_DISCARD_POLICER_ID	(MLXSW_REG_HTGT_TRAP_GROUP_MAX + 1)
-#define MLXSW_SP_THIN_POLICER_ID	(MLXSW_SP_DISCARD_POLICER_ID + 1)
+#define MLXSW_SP_THIN_POLICER_ID	(MLXSW_REG_HTGT_TRAP_GROUP_MAX + 1)
 
 static struct mlxsw_sp_trap_policer_item *
 mlxsw_sp_trap_policer_item_lookup(struct mlxsw_sp *mlxsw_sp, u32 id)
@@ -327,13 +326,6 @@ mlxsw_sp_trap_policer_item_lookup(struct mlxsw_sp *mlxsw_sp, u32 id)
 static int mlxsw_sp_trap_cpu_policers_set(struct mlxsw_sp *mlxsw_sp)
 {
 	char qpcr_pl[MLXSW_REG_QPCR_LEN];
-	int err;
-
-	mlxsw_reg_qpcr_pack(qpcr_pl, MLXSW_SP_DISCARD_POLICER_ID,
-			    MLXSW_REG_QPCR_IR_UNITS_M, false, 10 * 1024, 7);
-	err = mlxsw_reg_write(mlxsw_sp->core, MLXSW_REG(qpcr), qpcr_pl);
-	if (err)
-		return err;
 
 	/* The purpose of "thin" policer is to drop as many packets
 	 * as possible. The dummy group is using it.
-- 
2.24.1


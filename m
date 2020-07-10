Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 73F3521B760
	for <lists+netdev@lfdr.de>; Fri, 10 Jul 2020 15:58:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728059AbgGJN63 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Jul 2020 09:58:29 -0400
Received: from new4-smtp.messagingengine.com ([66.111.4.230]:43837 "EHLO
        new4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726832AbgGJN61 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Jul 2020 09:58:27 -0400
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailnew.nyi.internal (Postfix) with ESMTP id 96F3458059E;
        Fri, 10 Jul 2020 09:58:26 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute4.internal (MEProxy); Fri, 10 Jul 2020 09:58:26 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm3; bh=nEljDNIKQHe9wQAKAG8KeEF/05EWeQUJlco/xfMtRkU=; b=cqq740kS
        GbOIhxCtGUMCMYs8Z/y4C1u7LsdN3BEmVJrxPZggInsj+IHHv3X+zVGwZR6o77ja
        3FDGkJ/mpc+qfr2TxRHv0KlYHHOqBoOWCwNF6DaCi4iT3BVimhtmFqkRI1l3z2M1
        6LBbvcLprRkM/CaXcG5hh0vWryH6mVGU+66GBiZ09ZTdXepoGXnpoFtvOlrxfpdu
        0z28PTJMzDxb03Iv6aT7cMy8s9LQm86/iJOsahS6SkZEqOEMs2E+40CCckG4ZJUN
        qBWqBybcvuUiklxlzQuHzmNmFM1EgxARYFBm1NtVTx1sKI25/l0ft4GqWVy3PmqZ
        o3NeDYLj/EZedg==
X-ME-Sender: <xms:AnQIXzWoyfogNYV6U2r94OLjBP7v2y86hHzWyebqHJgUN5hTt1lvLA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduiedrvddugdejgecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhephffvufffkffojghfggfgsedtkeertd
    ertddtnecuhfhrohhmpefkughoucfutghhihhmmhgvlhcuoehiughoshgthhesihguohhs
    tghhrdhorhhgqeenucggtffrrghtthgvrhhnpeduteeiveffffevleekleejffekhfekhe
    fgtdfftefhledvjefggfehgfevjeekhfenucfkphepuddtledrieeirdduledrudeffeen
    ucevlhhushhtvghrufhiiigvpeejnecurfgrrhgrmhepmhgrihhlfhhrohhmpehiughosh
    gthhesihguohhstghhrdhorhhg
X-ME-Proxy: <xmx:AnQIX7lYzkOz915YiDffvt4my2mkT9PI9mV8KzssWp16Sr6UBTAxAg>
    <xmx:AnQIX_ZUfnKBDAo_Gp8gk8dd_XAahlaJ3ymndq9Y3VneQpZs2iamCw>
    <xmx:AnQIX-WcyiucaK0uVb7hj4v39fbX4_-99rF0kE-LqO390xi-avDV2g>
    <xmx:AnQIXzeA7ZyWNyQSkxKZzpBO4SjstTUCbHZrTW7N5jFvt8Yas-o18w>
Received: from shredder.mtl.com (bzq-109-66-19-133.red.bezeqint.net [109.66.19.133])
        by mail.messagingengine.com (Postfix) with ESMTPA id 02DBC328005A;
        Fri, 10 Jul 2020 09:58:22 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, jiri@mellanox.com,
        petrm@mellanox.com, mlxsw@mellanox.com, michael.chan@broadcom.com,
        saeedm@mellanox.com, leon@kernel.org, pablo@netfilter.org,
        kadlec@netfilter.org, fw@strlen.de, jhs@mojatatu.com,
        xiyou.wangcong@gmail.com, simon.horman@netronome.com,
        Ido Schimmel <idosch@mellanox.com>
Subject: [PATCH net-next 08/13] mlxsw: spectrum_flow: Convert a goto to a return
Date:   Fri, 10 Jul 2020 16:57:01 +0300
Message-Id: <20200710135706.601409-9-idosch@idosch.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200710135706.601409-1-idosch@idosch.org>
References: <20200710135706.601409-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Petr Machata <petrm@mellanox.com>

No clean-up is performed at the target label of this goto. Convert it to a
direct return.

Signed-off-by: Petr Machata <petrm@mellanox.com>
Reviewed-by: Jiri Pirko <jiri@mellanox.com>
Signed-off-by: Ido Schimmel <idosch@mellanox.com>
---
 drivers/net/ethernet/mellanox/mlxsw/spectrum_flow.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_flow.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_flow.c
index 47b66f347ff1..421581a85cd6 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_flow.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_flow.c
@@ -219,8 +219,7 @@ static int mlxsw_sp_setup_tc_block_bind(struct mlxsw_sp_port *mlxsw_sp_port,
 					       mlxsw_sp_tc_block_release);
 		if (IS_ERR(block_cb)) {
 			mlxsw_sp_flow_block_destroy(flow_block);
-			err = PTR_ERR(block_cb);
-			goto err_cb_register;
+			return PTR_ERR(block_cb);
 		}
 		register_block = true;
 	} else {
@@ -247,7 +246,6 @@ static int mlxsw_sp_setup_tc_block_bind(struct mlxsw_sp_port *mlxsw_sp_port,
 err_block_bind:
 	if (!flow_block_cb_decref(block_cb))
 		flow_block_cb_free(block_cb);
-err_cb_register:
 	return err;
 }
 
-- 
2.26.2


Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C11674A4EB
	for <lists+netdev@lfdr.de>; Tue, 18 Jun 2019 17:13:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729737AbfFRPNw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Jun 2019 11:13:52 -0400
Received: from out4-smtp.messagingengine.com ([66.111.4.28]:53105 "EHLO
        out4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729603AbfFRPNr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Jun 2019 11:13:47 -0400
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.nyi.internal (Postfix) with ESMTP id 97BE322374;
        Tue, 18 Jun 2019 11:13:46 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute3.internal (MEProxy); Tue, 18 Jun 2019 11:13:46 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm3; bh=AJMvMzZBfYBTkARUMRHFa60cyzrVl2C/JDDV5Mc4Dzo=; b=yFV4DMBz
        9k5EMRT6XgGJlqmk04YS21jrb4kWfxWSfOfZ6OiZket4DvWlhUhxurhOFzcUQIcG
        CCKq2Y5YpIgCE1zhYsAzGtfXNaXJXus3pAjHSEChTQfbdDIyMgwoGafoBRakBpom
        /S8SV8Y/ZFmBqLKINtH0xx3mhc4/DB5ZTBkOZhQgHCQd+BWh8METNMNFRPuTrAoE
        fmuGjd7QYK0ZOhMMx4UWF6PgcggotaLZOzLGZ9ZQ6EhJjSe2xlUhwXVmWpLT8qGc
        ljDfTyGs8un3MNmE6OctIBaYXH4JeR0IPaUB10mUkYkLgcYLDBS9ig1tqc6YzUhE
        MsfB79Evpo9gSA==
X-ME-Sender: <xms:qv8IXTfcfzrcDneLo2JVZIIsknxp40PtSth_yFY7jj0wAXpD9s8xuA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduvddrtddtgdehhecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhephffvufffkffojghfggfgsedtkeertd
    ertddtnecuhfhrohhmpefkughoucfutghhihhmmhgvlhcuoehiughoshgthhesihguohhs
    tghhrdhorhhgqeenucfkphepudelfedrgeejrdduieehrddvhedunecurfgrrhgrmhepmh
    grihhlfhhrohhmpehiughoshgthhesihguohhstghhrdhorhhgnecuvehluhhsthgvrhfu
    ihiivgepuddt
X-ME-Proxy: <xmx:qv8IXSid62BiR_p30QxoMlRIeYMZvPGDSjTUTKgxGr3D5eDhoPGZYg>
    <xmx:qv8IXTyp2epRWNL5FYpTQkfPAFrgIB2DQiNrNc2rDFieCMNB4etLHA>
    <xmx:qv8IXWMVOSeRqSKI3R99dfXAhvySyAsmNqdoggmMIrAYPYb_kQZ49A>
    <xmx:qv8IXeFQZ-hVDN0WjHVpjWmr4jUC82DmyiU8BJE1ivQYcV91YoFk8g>
Received: from splinter.mtl.com (unknown [193.47.165.251])
        by mail.messagingengine.com (Postfix) with ESMTPA id BECD8380073;
        Tue, 18 Jun 2019 11:13:44 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, jiri@mellanox.com, dsahern@gmail.com,
        alexpe@mellanox.com, mlxsw@mellanox.com,
        Ido Schimmel <idosch@mellanox.com>
Subject: [PATCH net-next v2 12/16] mlxsw: spectrum_router: Pass array of routes to route handling functions
Date:   Tue, 18 Jun 2019 18:12:54 +0300
Message-Id: <20190618151258.23023-13-idosch@idosch.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190618151258.23023-1-idosch@idosch.org>
References: <20190618151258.23023-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ido Schimmel <idosch@mellanox.com>

Prepare the driver to handle multiple routes in a single notification by
passing an array of routes to the functions that actually add / delete a
route.

Signed-off-by: Ido Schimmel <idosch@mellanox.com>
Acked-by: Jiri Pirko <jiri@mellanox.com>
---
 .../net/ethernet/mellanox/mlxsw/spectrum_router.c  | 14 ++++++++++----
 1 file changed, 10 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c
index dff96d1b0970..f0332d54aea1 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c
@@ -5556,10 +5556,12 @@ static void mlxsw_sp_fib6_entry_replace(struct mlxsw_sp *mlxsw_sp,
 }
 
 static int mlxsw_sp_router_fib6_add(struct mlxsw_sp *mlxsw_sp,
-				    struct fib6_info *rt, bool replace)
+				    struct fib6_info **rt_arr,
+				    unsigned int nrt6, bool replace)
 {
 	struct mlxsw_sp_fib6_entry *fib6_entry;
 	struct mlxsw_sp_fib_node *fib_node;
+	struct fib6_info *rt = rt_arr[0];
 	int err;
 
 	if (mlxsw_sp->router->aborted)
@@ -5613,10 +5615,12 @@ static int mlxsw_sp_router_fib6_add(struct mlxsw_sp *mlxsw_sp,
 }
 
 static void mlxsw_sp_router_fib6_del(struct mlxsw_sp *mlxsw_sp,
-				     struct fib6_info *rt)
+				     struct fib6_info **rt_arr,
+				     unsigned int nrt6)
 {
 	struct mlxsw_sp_fib6_entry *fib6_entry;
 	struct mlxsw_sp_fib_node *fib_node;
+	struct fib6_info *rt = rt_arr[0];
 
 	if (mlxsw_sp->router->aborted)
 		return;
@@ -6021,7 +6025,8 @@ static void mlxsw_sp_router_fib6_event_work(struct work_struct *work)
 	case FIB_EVENT_ENTRY_ADD:
 		replace = fib_work->event == FIB_EVENT_ENTRY_REPLACE;
 		err = mlxsw_sp_router_fib6_add(mlxsw_sp,
-					       fib_work->fib6_work.rt_arr[0],
+					       fib_work->fib6_work.rt_arr,
+					       fib_work->fib6_work.nrt6,
 					       replace);
 		if (err)
 			mlxsw_sp_router_fib_abort(mlxsw_sp);
@@ -6029,7 +6034,8 @@ static void mlxsw_sp_router_fib6_event_work(struct work_struct *work)
 		break;
 	case FIB_EVENT_ENTRY_DEL:
 		mlxsw_sp_router_fib6_del(mlxsw_sp,
-					 fib_work->fib6_work.rt_arr[0]);
+					 fib_work->fib6_work.rt_arr,
+					 fib_work->fib6_work.nrt6);
 		mlxsw_sp_router_fib6_work_fini(&fib_work->fib6_work);
 		break;
 	case FIB_EVENT_RULE_ADD:
-- 
2.20.1


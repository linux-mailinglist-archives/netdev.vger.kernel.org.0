Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2ACF721F3C5
	for <lists+netdev@lfdr.de>; Tue, 14 Jul 2020 16:23:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728140AbgGNOVp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Jul 2020 10:21:45 -0400
Received: from out3-smtp.messagingengine.com ([66.111.4.27]:57495 "EHLO
        out3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728076AbgGNOVm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Jul 2020 10:21:42 -0400
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailout.nyi.internal (Postfix) with ESMTP id 845275C00E9;
        Tue, 14 Jul 2020 10:21:41 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute4.internal (MEProxy); Tue, 14 Jul 2020 10:21:41 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm3; bh=xGUbgUEb6xY5S66XpiZkjHuYeKey/ZsAprCS9SMjz3o=; b=WxLE45cH
        1kTKugTNyYq/SV1oA4R7OR8EhCBIN848el3DunqCyfoNu8hRs5bHSAdDBhFodq/w
        cLDBN2X+Msc0tVBdPfvNjJu/I8wowODmHNHrxdLPXWWRnC/voiEXG2cOklSd+yUz
        yn1vR6mQ7hVR3jR8kLUpwXJ/kM5Pd3DcAq5MwhP4Sa1FaOqGRSZlcWSRJitKafn3
        wNny6+3DPTrk9oAu8pWkQGks2/fAlkgeblhfPh0Ajb0GKkJhkuwneJ/HfUPEGyfU
        mBb0QDwg9otkCQKXfloc3en7laZk2V9Wi/10IrF1scMw1rbEOvJRjLW4SJe7bxyg
        DsKE5Eo14Ologg==
X-ME-Sender: <xms:db8NX4xtSuAG5htdB2Omd8vNmFRJQ5PPgqOdL_9EebCZdTkxa3D3EA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduiedrfedtgdejkecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhephffvufffkffojghfggfgsedtkeertd
    ertddtnecuhfhrohhmpefkughoucfutghhihhmmhgvlhcuoehiughoshgthhesihguohhs
    tghhrdhorhhgqeenucggtffrrghtthgvrhhnpeduteeiveffffevleekleejffekhfekhe
    fgtdfftefhledvjefggfehgfevjeekhfenucfkphepuddtledrieeirdduledrudeffeen
    ucevlhhushhtvghrufhiiigvpedunecurfgrrhgrmhepmhgrihhlfhhrohhmpehiughosh
    gthhesihguohhstghhrdhorhhg
X-ME-Proxy: <xmx:db8NX8SIIgsaajZhFLONFjIiUYFn8qkaNetriQPj4k1Adm8Goy9XCg>
    <xmx:db8NX6WrpMhfNgnorFIgy5TNgL41qTDY76QBtdwIK3cPHjNCgf_2_g>
    <xmx:db8NX2i_Uvd-MFlw_EzpxqbYx2iUchnwjyEbV8RGWmXhBRlxP0DS8g>
    <xmx:db8NX1P5__Eg3bsKAuZEUF5o0NlR3PvokBLzpBr8NSw2o0tRNPlF8A>
Received: from shredder.mtl.com (bzq-109-66-19-133.red.bezeqint.net [109.66.19.133])
        by mail.messagingengine.com (Postfix) with ESMTPA id 8562930600A9;
        Tue, 14 Jul 2020 10:21:39 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, jiri@mellanox.com,
        petrm@mellanox.com, amitc@mellanox.com, mlxsw@mellanox.com,
        Ido Schimmel <idosch@mellanox.com>
Subject: [PATCH net-next 04/13] mlxsw: spectrum_span: Add driver private info to parms_set() callback
Date:   Tue, 14 Jul 2020 17:20:57 +0300
Message-Id: <20200714142106.386354-5-idosch@idosch.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200714142106.386354-1-idosch@idosch.org>
References: <20200714142106.386354-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ido Schimmel <idosch@mellanox.com>

The parms_set() callback is supposed to fill in the parameters for the
SPAN agent, such as the destination port and encapsulation info, if any.

When mirroring to the CPU port we cannot resolve the destination port
(the CPU port) without access to the driver private info.

Pass the driver private info to parms_set() callback so that it could be
used later on to resolve the CPU port.

Reviewed-by: Jiri Pirko <jiri@mellanox.com>
Signed-off-by: Petr Machata <petrm@mellanox.com>
Signed-off-by: Ido Schimmel <idosch@mellanox.com>
---
 .../ethernet/mellanox/mlxsw/spectrum_span.c   | 19 ++++++++++++-------
 .../ethernet/mellanox/mlxsw/spectrum_span.h   |  3 ++-
 2 files changed, 14 insertions(+), 8 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_span.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_span.c
index 6a257eb0df49..40289afdaaa8 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_span.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_span.c
@@ -129,7 +129,8 @@ void mlxsw_sp_span_fini(struct mlxsw_sp *mlxsw_sp)
 }
 
 static int
-mlxsw_sp_span_entry_phys_parms(const struct net_device *to_dev,
+mlxsw_sp_span_entry_phys_parms(struct mlxsw_sp *mlxsw_sp,
+			       const struct net_device *to_dev,
 			       struct mlxsw_sp_span_parms *sparmsp)
 {
 	sparmsp->dest_port = netdev_priv(to_dev);
@@ -405,7 +406,8 @@ mlxsw_sp_span_gretap4_route(const struct net_device *to_dev,
 }
 
 static int
-mlxsw_sp_span_entry_gretap4_parms(const struct net_device *to_dev,
+mlxsw_sp_span_entry_gretap4_parms(struct mlxsw_sp *mlxsw_sp,
+				  const struct net_device *to_dev,
 				  struct mlxsw_sp_span_parms *sparmsp)
 {
 	struct ip_tunnel_parm tparm = mlxsw_sp_ipip_netdev_parms4(to_dev);
@@ -506,7 +508,8 @@ mlxsw_sp_span_gretap6_route(const struct net_device *to_dev,
 }
 
 static int
-mlxsw_sp_span_entry_gretap6_parms(const struct net_device *to_dev,
+mlxsw_sp_span_entry_gretap6_parms(struct mlxsw_sp *mlxsw_sp,
+				  const struct net_device *to_dev,
 				  struct mlxsw_sp_span_parms *sparmsp)
 {
 	struct __ip6_tnl_parm tparm = mlxsw_sp_ipip_netdev_parms6(to_dev);
@@ -580,7 +583,8 @@ mlxsw_sp_span_vlan_can_handle(const struct net_device *dev)
 }
 
 static int
-mlxsw_sp_span_entry_vlan_parms(const struct net_device *to_dev,
+mlxsw_sp_span_entry_vlan_parms(struct mlxsw_sp *mlxsw_sp,
+			       const struct net_device *to_dev,
 			       struct mlxsw_sp_span_parms *sparmsp)
 {
 	struct net_device *real_dev;
@@ -652,7 +656,8 @@ struct mlxsw_sp_span_entry_ops *mlxsw_sp2_span_entry_ops_arr[] = {
 };
 
 static int
-mlxsw_sp_span_entry_nop_parms(const struct net_device *to_dev,
+mlxsw_sp_span_entry_nop_parms(struct mlxsw_sp *mlxsw_sp,
+			      const struct net_device *to_dev,
 			      struct mlxsw_sp_span_parms *sparmsp)
 {
 	return mlxsw_sp_span_entry_unoffloadable(sparmsp);
@@ -935,7 +940,7 @@ static void mlxsw_sp_span_respin_work(struct work_struct *work)
 		if (!refcount_read(&curr->ref_count))
 			continue;
 
-		err = curr->ops->parms_set(curr->to_dev, &sparms);
+		err = curr->ops->parms_set(mlxsw_sp, curr->to_dev, &sparms);
 		if (err)
 			continue;
 
@@ -971,7 +976,7 @@ int mlxsw_sp_span_agent_get(struct mlxsw_sp *mlxsw_sp,
 	}
 
 	memset(&sparms, 0, sizeof(sparms));
-	err = ops->parms_set(to_dev, &sparms);
+	err = ops->parms_set(mlxsw_sp, to_dev, &sparms);
 	if (err)
 		return err;
 
diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_span.h b/drivers/net/ethernet/mellanox/mlxsw/spectrum_span.h
index 29b96b222e25..c21d8dfd371b 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_span.h
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_span.h
@@ -52,7 +52,8 @@ struct mlxsw_sp_span_entry {
 
 struct mlxsw_sp_span_entry_ops {
 	bool (*can_handle)(const struct net_device *to_dev);
-	int (*parms_set)(const struct net_device *to_dev,
+	int (*parms_set)(struct mlxsw_sp *mlxsw_sp,
+			 const struct net_device *to_dev,
 			 struct mlxsw_sp_span_parms *sparmsp);
 	int (*configure)(struct mlxsw_sp_span_entry *span_entry,
 			 struct mlxsw_sp_span_parms sparms);
-- 
2.26.2


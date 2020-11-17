Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 33F3D2B6C27
	for <lists+netdev@lfdr.de>; Tue, 17 Nov 2020 18:48:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730100AbgKQRrh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Nov 2020 12:47:37 -0500
Received: from wout2-smtp.messagingengine.com ([64.147.123.25]:43009 "EHLO
        wout2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729008AbgKQRrg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Nov 2020 12:47:36 -0500
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.west.internal (Postfix) with ESMTP id CA018E83;
        Tue, 17 Nov 2020 12:47:35 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute3.internal (MEProxy); Tue, 17 Nov 2020 12:47:36 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm1; bh=RGlzTFvCtpT5MxS8IQRIbYZSYgQxpzafd077fYScL84=; b=MPu57YHy
        +eDsBEchJ3PUDmk5V+OXVSHv4g7ZKnp1epwMXW4m9pi8g2sobXHm5SxvHEMM77yH
        eLo9ZZ8ZFXlPyk1pxG7bMmhlqoNZZuzLmjIONoGB8KZ2kfMqNEdjvrRBU+Nz7fiC
        CqfUEpCd3xSFaCuZnqgtPgVOx0p4ErPKaS6Mh3xdbsevex0MjQoZmUb54nyTFRmW
        dFR6rUi8b/XowobLj9v3/SGrfucw2P6limKNLld952M4yiMzTA4TFbv25rkCGG6Z
        aRi7qIA75vOnKR40W/h3V+4OZCN9o6FfOFvEDf8+Fb0hJTToxrf4pTu5z8xnKWOS
        fXsw9uR67cpFpg==
X-ME-Sender: <xms:twy0X1NjPyGHQrLtc3vb-uKw2UEVGBkabwcmDHx5HTXjWEO-TM8N3w>
    <xme:twy0X3_4s-2Vs2yMpoeVbF__BlB7P_eh8R1M6lAiQ2A6pJUYb4pwvWJaQLhrS289h
    XQlrl3WvKmhCnY>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedujedrudeffedguddthecutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecunecujfgurhephffvufffkffojghfggfgsedtke
    ertdertddtnecuhfhrohhmpefkughoucfutghhihhmmhgvlhcuoehiughoshgthhesihgu
    ohhstghhrdhorhhgqeenucggtffrrghtthgvrhhnpeduteeiveffffevleekleejffekhf
    ekhefgtdfftefhledvjefggfehgfevjeekhfenucfkphepkeegrddvvdelrdduheegrddu
    geejnecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepih
    guohhstghhsehiughoshgthhdrohhrgh
X-ME-Proxy: <xmx:twy0X0RAVxXx10CWgwT7XQy2vPc8QWyNi-M6A6C9vgYVih5SblIdWA>
    <xmx:twy0XxvhdvXZJGu4Ab9rI8FxOP8lIK_3Q8_vKhra1iMlDaHgH7SDcw>
    <xmx:twy0X9feA33-E4Bo42hZCjjZlN7qWAU-D7eew8NGpXTaDLh6jowugw>
    <xmx:twy0Xx5MhtOhI98yY4IxwCe1pl4Js0lgHSBbbb_XoUQ28_9icqITiQ>
Received: from shredder.lan (igld-84-229-154-147.inter.net.il [84.229.154.147])
        by mail.messagingengine.com (Postfix) with ESMTPA id 10BA2328005A;
        Tue, 17 Nov 2020 12:47:33 -0500 (EST)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, jiri@nvidia.com,
        dsahern@gmail.com, mlxsw@nvidia.com,
        Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH net-next 3/9] mlxsw: spectrum_router: Pass ifindex to mlxsw_sp_ipip_entry_find_by_decap()
Date:   Tue, 17 Nov 2020 19:46:58 +0200
Message-Id: <20201117174704.291990-4-idosch@idosch.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20201117174704.291990-1-idosch@idosch.org>
References: <20201117174704.291990-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ido Schimmel <idosch@nvidia.com>

The sole caller of the function will soon only have the ifindex
available, instead of the pointer itself.

Therefore, change the function to take the ifindex as input and have it
get the pointer.

Signed-off-by: Ido Schimmel <idosch@nvidia.com>
Reviewed-by: Jiri Pirko <jiri@nvidia.com>
---
 .../ethernet/mellanox/mlxsw/spectrum_router.c | 24 ++++++++++++++-----
 1 file changed, 18 insertions(+), 6 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c
index 1ea338786479..89b44dc543a5 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c
@@ -1353,21 +1353,33 @@ mlxsw_sp_ipip_entry_matches_decap(struct mlxsw_sp *mlxsw_sp,
 
 /* Given decap parameters, find the corresponding IPIP entry. */
 static struct mlxsw_sp_ipip_entry *
-mlxsw_sp_ipip_entry_find_by_decap(struct mlxsw_sp *mlxsw_sp,
-				  const struct net_device *ul_dev,
+mlxsw_sp_ipip_entry_find_by_decap(struct mlxsw_sp *mlxsw_sp, int ul_dev_ifindex,
 				  enum mlxsw_sp_l3proto ul_proto,
 				  union mlxsw_sp_l3addr ul_dip)
 {
-	struct mlxsw_sp_ipip_entry *ipip_entry;
+	struct mlxsw_sp_ipip_entry *ipip_entry = NULL;
+	struct net_device *ul_dev;
+
+	rcu_read_lock();
+
+	ul_dev = dev_get_by_index_rcu(mlxsw_sp_net(mlxsw_sp), ul_dev_ifindex);
+	if (!ul_dev)
+		goto out_unlock;
 
 	list_for_each_entry(ipip_entry, &mlxsw_sp->router->ipip_list,
 			    ipip_list_node)
 		if (mlxsw_sp_ipip_entry_matches_decap(mlxsw_sp, ul_dev,
 						      ul_proto, ul_dip,
 						      ipip_entry))
-			return ipip_entry;
+			goto out_unlock;
+
+	rcu_read_unlock();
 
 	return NULL;
+
+out_unlock:
+	rcu_read_unlock();
+	return ipip_entry;
 }
 
 static bool mlxsw_sp_netdev_ipip_type(const struct mlxsw_sp *mlxsw_sp,
@@ -4775,8 +4787,8 @@ mlxsw_sp_fib4_entry_type_set(struct mlxsw_sp *mlxsw_sp,
 
 	switch (fen_info->type) {
 	case RTN_LOCAL:
-		ipip_entry = mlxsw_sp_ipip_entry_find_by_decap(mlxsw_sp, dev,
-						 MLXSW_SP_L3_PROTO_IPV4, dip);
+		ipip_entry = mlxsw_sp_ipip_entry_find_by_decap(mlxsw_sp, dev->ifindex,
+							       MLXSW_SP_L3_PROTO_IPV4, dip);
 		if (ipip_entry && ipip_entry->ol_dev->flags & IFF_UP) {
 			fib_entry->type = MLXSW_SP_FIB_ENTRY_TYPE_IPIP_DECAP;
 			return mlxsw_sp_fib_entry_decap_init(mlxsw_sp,
-- 
2.28.0


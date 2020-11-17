Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DBEBB2B6C2D
	for <lists+netdev@lfdr.de>; Tue, 17 Nov 2020 18:48:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729927AbgKQRrz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Nov 2020 12:47:55 -0500
Received: from wout2-smtp.messagingengine.com ([64.147.123.25]:57931 "EHLO
        wout2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728761AbgKQRrp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Nov 2020 12:47:45 -0500
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.west.internal (Postfix) with ESMTP id 294B95D5;
        Tue, 17 Nov 2020 12:47:44 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute3.internal (MEProxy); Tue, 17 Nov 2020 12:47:44 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm1; bh=eqXtW1sva4FZtMLqV0VDvhUnJUylPWlZqLeNDjaplwQ=; b=e3C3HrxX
        6sjIlDBIxnjGiOP7+9dKUFF8vTJ0RkMxEc1z1QAaqvDrYj2T/MgCs5ACrj6eN7Hd
        XarZZViqzh1PcSORNHYPD4HDPTHP3Il+DdF8GdVHbU1Lm7l2EFEU+2pB9S+bAqq0
        o3x5pX6oCUJBA0HyDW6A/BjoHqkJsKBfLNZKPZrDJxTeLPEBesXmasjv+/p4zCse
        OsLY5HBHxpiDXO/MzfqzXZGZeAeFt9JX2f5/DkjTlI0vU0ClhIhvxTvQmdKoRgEa
        vzOACHvWX79wZC2Ugh6uwHBqPw7E11gR+UcNwKscj4po2sZE6KQnQafne0VsdLTL
        O681W1n8brOgTQ==
X-ME-Sender: <xms:vwy0X_sjoyXBdQouQ1IM0wm8dAAGLbleBzGguCFF_zdHNejFMDX-WQ>
    <xme:vwy0XwfwI7Zlk6cjvK6BplXtEKzVJ8eegYBvpfv6hoGBjgG_rMpBYlAZs5WWKCr_f
    VQIn-1JPY7doGk>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedujedrudeffedguddthecutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecunecujfgurhephffvufffkffojghfggfgsedtke
    ertdertddtnecuhfhrohhmpefkughoucfutghhihhmmhgvlhcuoehiughoshgthhesihgu
    ohhstghhrdhorhhgqeenucggtffrrghtthgvrhhnpeduteeiveffffevleekleejffekhf
    ekhefgtdfftefhledvjefggfehgfevjeekhfenucfkphepkeegrddvvdelrdduheegrddu
    geejnecuvehluhhsthgvrhfuihiivgepgeenucfrrghrrghmpehmrghilhhfrhhomhepih
    guohhstghhsehiughoshgthhdrohhrgh
X-ME-Proxy: <xmx:vwy0XyzVxyb3u3eRTOkvgxWoKIXrRUJQpGem7W-CirwKtx9znXR1Uw>
    <xmx:vwy0X-O3Dv7UoNTveYa64Aui8eorCQ_opcPf9RoXMbNSG_w-YmKKWw>
    <xmx:vwy0X_8BAgFQ4WzALxQS5N2w-FsuwxUtUdA7jyDMg4nBx_s0eqwM9A>
    <xmx:vwy0XyYt0w8JhLl5hcW8xU-eqvluCRcUeXBtcIeSwaNdnCOgt46_Lw>
Received: from shredder.lan (igld-84-229-154-147.inter.net.il [84.229.154.147])
        by mail.messagingengine.com (Postfix) with ESMTPA id 0D5B13280068;
        Tue, 17 Nov 2020 12:47:41 -0500 (EST)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, jiri@nvidia.com,
        dsahern@gmail.com, mlxsw@nvidia.com,
        Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH net-next 8/9] mlxsw: spectrum_router: Add an indication if a nexthop group can be destroyed
Date:   Tue, 17 Nov 2020 19:47:03 +0200
Message-Id: <20201117174704.291990-9-idosch@idosch.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20201117174704.291990-1-idosch@idosch.org>
References: <20201117174704.291990-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ido Schimmel <idosch@nvidia.com>

Currently, a nexthop group is destroyed when the last FIB entry is
detached from it.

When nexthop objects are supported, this can no longer be the case, as
the group is a separate object whose lifetime is managed by user space.

Add an indication if a nexthop group can be destroyed and always set it
to true for the existing IPv4 and IPv6 nexthop groups.

Signed-off-by: Ido Schimmel <idosch@nvidia.com>
Reviewed-by: Jiri Pirko <jiri@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c
index 645ec70314d2..87b8c8db688b 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c
@@ -2897,6 +2897,7 @@ struct mlxsw_sp_nexthop_group {
 	};
 	struct mlxsw_sp_nexthop_group_info *nhgi;
 	enum mlxsw_sp_nexthop_group_type type;
+	bool can_destroy;
 };
 
 void mlxsw_sp_nexthop_counter_alloc(struct mlxsw_sp *mlxsw_sp,
@@ -4173,6 +4174,8 @@ mlxsw_sp_nexthop4_group_create(struct mlxsw_sp *mlxsw_sp, struct fib_info *fi)
 	if (err)
 		goto err_nexthop_group_insert;
 
+	nh_grp->can_destroy = true;
+
 	return nh_grp;
 
 err_nexthop_group_insert:
@@ -4187,6 +4190,8 @@ static void
 mlxsw_sp_nexthop4_group_destroy(struct mlxsw_sp *mlxsw_sp,
 				struct mlxsw_sp_nexthop_group *nh_grp)
 {
+	if (!nh_grp->can_destroy)
+		return;
 	mlxsw_sp_nexthop_group_remove(mlxsw_sp, nh_grp);
 	mlxsw_sp_nexthop4_group_info_fini(mlxsw_sp, nh_grp);
 	fib_info_put(nh_grp->ipv4.fi);
@@ -5479,6 +5484,8 @@ mlxsw_sp_nexthop6_group_create(struct mlxsw_sp *mlxsw_sp,
 	if (err)
 		goto err_nexthop_group_insert;
 
+	nh_grp->can_destroy = true;
+
 	return nh_grp;
 
 err_nexthop_group_insert:
@@ -5492,6 +5499,8 @@ static void
 mlxsw_sp_nexthop6_group_destroy(struct mlxsw_sp *mlxsw_sp,
 				struct mlxsw_sp_nexthop_group *nh_grp)
 {
+	if (!nh_grp->can_destroy)
+		return;
 	mlxsw_sp_nexthop_group_remove(mlxsw_sp, nh_grp);
 	mlxsw_sp_nexthop6_group_info_fini(mlxsw_sp, nh_grp);
 	kfree(nh_grp);
-- 
2.28.0


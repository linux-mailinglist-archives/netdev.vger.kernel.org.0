Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CA7A72C487C
	for <lists+netdev@lfdr.de>; Wed, 25 Nov 2020 20:36:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728842AbgKYTfx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Nov 2020 14:35:53 -0500
Received: from out3-smtp.messagingengine.com ([66.111.4.27]:58929 "EHLO
        out3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728521AbgKYTfx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 25 Nov 2020 14:35:53 -0500
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.nyi.internal (Postfix) with ESMTP id 6563F5C00E1;
        Wed, 25 Nov 2020 14:35:52 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute3.internal (MEProxy); Wed, 25 Nov 2020 14:35:52 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm1; bh=Tq+cWtUV/8L5K0AeSbH5wr7jkuJgFZ5iSTZ2oqatsEE=; b=E2yHkMeP
        y9RO5dkP3yU1CCmqexHa7hjqj8+gx0ePniX6MAgq+y7C7R5/YQDqNoJskm9UwkXW
        D5a/bZ4L3dwHuYekJQKjZMvwshJTPXdwyKkWwTeLfilHpv37RyIS0CNJ0bfE5uAu
        X8d8oQBfCwUuI603xO91lLzF0sE/sg20p5VVGwVRygwFzmt4euc/SQuDLpfHGiMO
        69bV5+lbKoeImn1B7W7C+Tyc0joRhZILLTbieaddlEyRWodeLKkx/EemYopHDFWz
        9+OvRy/WhxOE9OznLW29fnRhp3/jw7y4a92gB02JiS1hiO0NIVT8uBfD+YICAS9r
        sEkrFxUhLbysZg==
X-ME-Sender: <xms:GLK-XzwqUX4Mq767XRWtflH5ABEE6CQbhZLqF6aH2wreIIXfPCqqLA>
    <xme:GLK-X7T_xvMCmLK84l21hd52UbT4uqQ2sU9n5oHsckJbgAxwzRhGrvwAPJIwgKLZ_
    fo380vPCvl7pJg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedujedrudehtddguddvjecutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecunecujfgurhephffvufffkffojghfggfgsedtke
    ertdertddtnecuhfhrohhmpefkughoucfutghhihhmmhgvlhcuoehiughoshgthhesihgu
    ohhstghhrdhorhhgqeenucggtffrrghtthgvrhhnpeduteeiveffffevleekleejffekhf
    ekhefgtdfftefhledvjefggfehgfevjeekhfenucfkphepkeegrddvvdelrdduheegrddu
    geejnecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepih
    guohhstghhsehiughoshgthhdrohhrgh
X-ME-Proxy: <xmx:GLK-X9Xvxl6wUcBLfPQg75yb3AxFjleSnwXxkuWsm39oJ1D_U9VXZw>
    <xmx:GLK-X9jnbClmwExqNcgTTGiwz21hO1SdlHi9npWoDR8pa3uA1jVwig>
    <xmx:GLK-X1CLDsNq3p4eTWkM355pWW1S_UrbHCBlAbWakEurjpzuIJLPCQ>
    <xmx:GLK-X0O9nZ7a9rU82SRRxjstyyhyLA7CvegqOEWZRHg4mGiT_9TM9A>
Received: from shredder.lan (igld-84-229-154-147.inter.net.il [84.229.154.147])
        by mail.messagingengine.com (Postfix) with ESMTPA id 15C7A328005D;
        Wed, 25 Nov 2020 14:35:50 -0500 (EST)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, jiri@nvidia.com,
        dsahern@gmail.com, mlxsw@nvidia.com,
        Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH net-next 3/5] mlxsw: spectrum_router: Rollback virtual router adjacency pointer update
Date:   Wed, 25 Nov 2020 21:35:03 +0200
Message-Id: <20201125193505.1052466-4-idosch@idosch.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20201125193505.1052466-1-idosch@idosch.org>
References: <20201125193505.1052466-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ido Schimmel <idosch@nvidia.com>

In the rare case where the adjacency pointer cannot be updated for a
given virtual router, rollback the operation so that virtual routers
that are already using the new index will use the old one again.

Signed-off-by: Ido Schimmel <idosch@nvidia.com>
Reviewed-by: Jiri Pirko <jiri@nvidia.com>
---
 .../net/ethernet/mellanox/mlxsw/spectrum_router.c | 15 ++++++++++++++-
 1 file changed, 14 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c
index b229f28f6209..316182d6c1e3 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c
@@ -3279,9 +3279,22 @@ static int mlxsw_sp_adj_index_mass_update(struct mlxsw_sp *mlxsw_sp,
 							nhgi->adj_index,
 							nhgi->ecmp_size);
 		if (err)
-			return err;
+			goto err_mass_update_vr;
 	}
 	return 0;
+
+err_mass_update_vr:
+	list_for_each_entry_continue_reverse(fib_entry, &nh_grp->fib_list,
+					     nexthop_group_node) {
+		struct mlxsw_sp_nexthop_group_info *nhgi = nh_grp->nhgi;
+
+		fib = fib_entry->fib_node->fib;
+		mlxsw_sp_adj_index_mass_update_vr(mlxsw_sp, fib->proto,
+						  fib->vr->id, nhgi->adj_index,
+						  nhgi->ecmp_size,
+						  old_adj_index, old_ecmp_size);
+	}
+	return err;
 }
 
 static int __mlxsw_sp_nexthop_update(struct mlxsw_sp *mlxsw_sp, u32 adj_index,
-- 
2.28.0


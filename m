Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 82C372B6C2A
	for <lists+netdev@lfdr.de>; Tue, 17 Nov 2020 18:48:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730140AbgKQRrm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Nov 2020 12:47:42 -0500
Received: from wout2-smtp.messagingengine.com ([64.147.123.25]:46149 "EHLO
        wout2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728761AbgKQRrl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Nov 2020 12:47:41 -0500
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.west.internal (Postfix) with ESMTP id B38B9E18;
        Tue, 17 Nov 2020 12:47:40 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute3.internal (MEProxy); Tue, 17 Nov 2020 12:47:41 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm1; bh=tCDnF2MA4zsQuGX0XbKszl7q4jiGjYTxDwWBCkikBr4=; b=jQFgT2Fk
        CXXpSHpXRdPGRCgnDLw0wdTv4PCKON8DpdTekVJJulI+itSlKAXK1rTbB7eMINw7
        fV71qmOGV5gvFucy2s9b9Bx9M+5uEzTGepIty8Edey/HAqPxLAE+m8T8fQsk6M/B
        qHQU4fEDwgvQyf0jMe3qyJl1VyEj5Z80LmWeAXYdjdIKy6W27Rlu0+4eWnT/jSeS
        Uo1OH68HzKSZRQnqV4te2a4YNh+bMa6Eal1c2+cnNGER7kOiPStw7y1Gfhgw8npm
        e1xt0On0XqVb3GmngLhQaRt0XZ0ld3Y/w4kphhZsZb/zW43DofUsyTQ/X+LgpWy7
        t+Pkqaebr964Yw==
X-ME-Sender: <xms:vAy0XzcE63OUEICwIlKJHsJn-cS1XD8pmlWovPkZgJeq6oS0vdD_qg>
    <xme:vAy0X5NRhF2E0hg_nP_peH9CcEhTYamWcdl0ld0qmg5UtT_QeE0wp5pRX4Yfz2SRu
    YlxKLiqbhzH-nA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedujedrudeffedguddthecutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecunecujfgurhephffvufffkffojghfggfgsedtke
    ertdertddtnecuhfhrohhmpefkughoucfutghhihhmmhgvlhcuoehiughoshgthhesihgu
    ohhstghhrdhorhhgqeenucggtffrrghtthgvrhhnpeduteeiveffffevleekleejffekhf
    ekhefgtdfftefhledvjefggfehgfevjeekhfenucfkphepkeegrddvvdelrdduheegrddu
    geejnecuvehluhhsthgvrhfuihiivgepgeenucfrrghrrghmpehmrghilhhfrhhomhepih
    guohhstghhsehiughoshgthhdrohhrgh
X-ME-Proxy: <xmx:vAy0X8glhVePnwoPOcquAcVVsIIohYulOR30rg1JaUS554Kr7QHBqw>
    <xmx:vAy0X08y5mxV4JY2qXk1UTbrJlKQWON-exuR49OuaULBobmckWA4qA>
    <xmx:vAy0X_spTk715sno4OkIz6HFHJZY44oMR_kB64bW5Ma4qnsS84DrQw>
    <xmx:vAy0X_KYJ1-EJwphBG9S-y3sRsncB5YyDQpLIhQO9y50QfAFkQVq7g>
Received: from shredder.lan (igld-84-229-154-147.inter.net.il [84.229.154.147])
        by mail.messagingengine.com (Postfix) with ESMTPA id BC4C6328006A;
        Tue, 17 Nov 2020 12:47:38 -0500 (EST)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, jiri@nvidia.com,
        dsahern@gmail.com, mlxsw@nvidia.com,
        Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH net-next 6/9] mlxsw: spectrum_router: Re-order mlxsw_sp_nexthop6_group_get()
Date:   Tue, 17 Nov 2020 19:47:01 +0200
Message-Id: <20201117174704.291990-7-idosch@idosch.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20201117174704.291990-1-idosch@idosch.org>
References: <20201117174704.291990-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ido Schimmel <idosch@nvidia.com>

Attach the FIB entry to the nexthop group after setting the offload flag
on the IPv6 FIB info (i.e., 'struct fib6_info'). The second operation is
not needed when the nexthop group is a nexthop object. This will allow
us to have a common exit path from the function, regardless of the
nexthop group's type.

Signed-off-by: Ido Schimmel <idosch@nvidia.com>
Reviewed-by: Jiri Pirko <jiri@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c
index 4f5c135bc587..49cd6eba0661 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c
@@ -5508,15 +5508,15 @@ static int mlxsw_sp_nexthop6_group_get(struct mlxsw_sp *mlxsw_sp,
 			return PTR_ERR(nh_grp);
 	}
 
-	list_add_tail(&fib6_entry->common.nexthop_group_node,
-		      &nh_grp->fib_list);
-	fib6_entry->common.nh_group = nh_grp;
-
 	/* The route and the nexthop are described by the same struct, so we
 	 * need to the update the nexthop offload indication for the new route.
 	 */
 	__mlxsw_sp_nexthop6_group_offload_refresh(nh_grp, fib6_entry);
 
+	list_add_tail(&fib6_entry->common.nexthop_group_node,
+		      &nh_grp->fib_list);
+	fib6_entry->common.nh_group = nh_grp;
+
 	return 0;
 }
 
-- 
2.28.0


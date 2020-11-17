Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EF0712B6C2B
	for <lists+netdev@lfdr.de>; Tue, 17 Nov 2020 18:48:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730144AbgKQRrn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Nov 2020 12:47:43 -0500
Received: from wout2-smtp.messagingengine.com ([64.147.123.25]:37177 "EHLO
        wout2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728761AbgKQRrn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Nov 2020 12:47:43 -0500
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.west.internal (Postfix) with ESMTP id 43E55EA5;
        Tue, 17 Nov 2020 12:47:42 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute3.internal (MEProxy); Tue, 17 Nov 2020 12:47:42 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm1; bh=D7koepcQBNyg6crt2bwN5lP205ksKfd0MwyViruSvZc=; b=HO+PPHwi
        zozXdEgT5cMK/et5sB2hR4aW4m0i9K+8xqLU76M/IKF0LAOy/aBQABkY5g+5ppcf
        Xv+xWanSf+/bBtjNKY7XzdDASOIh5HV6Ohr1FK1F9vbFh/WpgbllGHrWCM3oJbFP
        e5ni4Xzvm8bFJMP7h+lFVG83eroOcoT7qtjyD/8xoD8tBFGPeMiJqEDKaPTkmooI
        MQ6kRzm+fHfV4Qm95jH3fqHw6LywD30dQ+EM+T0NaTrQEQtN7f7W7BRjHTS2R3l+
        eW4luIVHAmUfhcJTeJ7rRqm//bUszy6vC6newiEyRrmRbKQIBoxXqYFbrzYoGNZc
        L3FQMemymJi2lA==
X-ME-Sender: <xms:vQy0X01Qx2gP9Rg-9P1nDBBdt4-rmUtk37zbVChLlqFTSOR47c-ELQ>
    <xme:vQy0X_F69MMFC5ovyCAkqexRCrXtXoDUgu87lwpy745_VIQDWjfbZIWS8VVRkwU-q
    SSBUatHaYZmxiE>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedujedrudeffedguddthecutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecunecujfgurhephffvufffkffojghfggfgsedtke
    ertdertddtnecuhfhrohhmpefkughoucfutghhihhmmhgvlhcuoehiughoshgthhesihgu
    ohhstghhrdhorhhgqeenucggtffrrghtthgvrhhnpeduteeiveffffevleekleejffekhf
    ekhefgtdfftefhledvjefggfehgfevjeekhfenucfkphepkeegrddvvdelrdduheegrddu
    geejnecuvehluhhsthgvrhfuihiivgepgeenucfrrghrrghmpehmrghilhhfrhhomhepih
    guohhstghhsehiughoshgthhdrohhrgh
X-ME-Proxy: <xmx:vQy0X842GWGr870nQa626VLv_wpJ_mUXdlPywah6jvGVAw_Qg7V8cA>
    <xmx:vQy0X93VxG2UMniwQ1hMMLM7ZbYBg_WJnawWbqAUkH3DfxPgdwKXAA>
    <xmx:vQy0X3Fh8547fz3orA18eDu59OxQMKHvsDEL5uYlGy_-irgYydolSw>
    <xmx:vQy0X_Djy7jmOuPE4C83e1VjKLzTVYWG4W70bXvvYYlWHeiEuddaWQ>
Received: from shredder.lan (igld-84-229-154-147.inter.net.il [84.229.154.147])
        by mail.messagingengine.com (Postfix) with ESMTPA id 5546A328005E;
        Tue, 17 Nov 2020 12:47:40 -0500 (EST)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, jiri@nvidia.com,
        dsahern@gmail.com, mlxsw@nvidia.com,
        Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH net-next 7/9] mlxsw: spectrum_router: Only clear offload indication from valid IPv6 FIB info
Date:   Tue, 17 Nov 2020 19:47:02 +0200
Message-Id: <20201117174704.291990-8-idosch@idosch.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20201117174704.291990-1-idosch@idosch.org>
References: <20201117174704.291990-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ido Schimmel <idosch@nvidia.com>

When the IPv6 FIB info has a nexthop object, the nexthop offload
indication is set on the nexthop object and not on the FIB info itself.

Therefore, do not try to clear the offload indication from the FIB info
when it has a nexthop object.

Signed-off-by: Ido Schimmel <idosch@nvidia.com>
Reviewed-by: Jiri Pirko <jiri@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c
index 49cd6eba0661..645ec70314d2 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c
@@ -5324,7 +5324,8 @@ static void mlxsw_sp_rt6_destroy(struct mlxsw_sp_rt6 *mlxsw_sp_rt6)
 {
 	struct fib6_nh *fib6_nh = mlxsw_sp_rt6->rt->fib6_nh;
 
-	fib6_nh->fib_nh_flags &= ~RTNH_F_OFFLOAD;
+	if (!mlxsw_sp_rt6->rt->nh)
+		fib6_nh->fib_nh_flags &= ~RTNH_F_OFFLOAD;
 	mlxsw_sp_rt6_release(mlxsw_sp_rt6->rt);
 	kfree(mlxsw_sp_rt6);
 }
-- 
2.28.0


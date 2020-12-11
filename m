Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B51D82D7C6C
	for <lists+netdev@lfdr.de>; Fri, 11 Dec 2020 18:08:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2394553AbgLKRH5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Dec 2020 12:07:57 -0500
Received: from wout1-smtp.messagingengine.com ([64.147.123.24]:48039 "EHLO
        wout1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2391929AbgLKRHf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Dec 2020 12:07:35 -0500
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.west.internal (Postfix) with ESMTP id 841FDB3B;
        Fri, 11 Dec 2020 12:05:31 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute3.internal (MEProxy); Fri, 11 Dec 2020 12:05:32 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm1; bh=Wv5bV8CoMux3g9Qr/wfmNQVU7j7IglIOcfwsDnC2UDc=; b=WSmol7Z8
        cBP7osEDMY/6/pfjFZ22YvCtvhFQ/S4Jd+xKuUx7cmUpbkRCNgPGUBdch08JFREg
        PfHAsxNi2BcijwFKqxOYl2SzAG6OoKJP9RpWt5wM9zAmtYpMoEZDJ1UXQnroRxLS
        2aqv+srdXyHNb51Ct5mF8VtHhbRpeDUP0CXgIxmA0c7nQRlcuIBbPB58DXV2EfqD
        BtUKfxEq6S0U3PVKNEuyXTp4zKGe5t1ufbp3d/GTN5gONkqF39PMK/YBWXJfuGrW
        pcpzHfZaRS+iGWN872pSVlSXzHvXN5UoegPzPPIwKfb4OCGkhru6ys3TsGo9UcKp
        UajVZaZ1iChwSQ==
X-ME-Sender: <xms:26bTXyfAyvUuUGmN4IZ6t4tFZnB61V-b-h_siMWKnSyj8eim_MNB5g>
    <xme:26bTXyN6fp7szklTbbjurqLuT5OKFTiNCVaIbCoYS4Nd-e9WTgjs4MnjktXSsNLyI
    uoJHV8D0jAZegM>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedujedrudekvddgleekucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgjfhgggfestdekre
    dtredttdenucfhrhhomhepkfguohcuufgthhhimhhmvghluceoihguohhstghhsehiugho
    shgthhdrohhrgheqnecuggftrfgrthhtvghrnhepudetieevffffveelkeeljeffkefhke
    ehgfdtffethfelvdejgffghefgveejkefhnecukfhppeekgedrvddvledrudehfedrjeek
    necuvehluhhsthgvrhfuihiivgepkeenucfrrghrrghmpehmrghilhhfrhhomhepihguoh
    hstghhsehiughoshgthhdrohhrgh
X-ME-Proxy: <xmx:26bTXxJpIkTN8MbrPLIkx5jtcI5lnxzaHGqVlNkkTLfynGyTfQ8owg>
    <xmx:26bTX7Exf42yCvyYzZexsmxR0Ucy_9s_FeH-8WEfvuEO-FUM795BPQ>
    <xmx:26bTXxSsv7w4MygPQKBZrfRkhT9XUrHKI8J3b1xgVVT-QOMtMAxlUw>
    <xmx:26bTX5imV7M48-keoOCahyR-6Z9bJsLzL0YHd6XYyq2euSBm9dl1FA>
Received: from shredder.lan (igld-84-229-153-78.inter.net.il [84.229.153.78])
        by mail.messagingengine.com (Postfix) with ESMTPA id 155AA1080057;
        Fri, 11 Dec 2020 12:05:29 -0500 (EST)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, jiri@nvidia.com,
        mlxsw@nvidia.com, Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH net-next 15/15] mlxsw: spectrum_router: Use eXtended mezzanine to offload IPv4 router
Date:   Fri, 11 Dec 2020 19:04:13 +0200
Message-Id: <20201211170413.2269479-16-idosch@idosch.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201211170413.2269479-1-idosch@idosch.org>
References: <20201211170413.2269479-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jiri Pirko <jiri@nvidia.com>

In case the eXtended mezzanine is present on the system, use it for IPv4
router offload.

Signed-off-by: Jiri Pirko <jiri@nvidia.com>
Signed-off-by: Ido Schimmel <idosch@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c    | 4 +++-
 drivers/net/ethernet/mellanox/mlxsw/spectrum_router.h    | 1 +
 drivers/net/ethernet/mellanox/mlxsw/spectrum_router_xm.c | 7 +++++++
 3 files changed, 11 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c
index 62d51b281b58..41424ee909a0 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c
@@ -9213,7 +9213,9 @@ int mlxsw_sp_router_init(struct mlxsw_sp *mlxsw_sp,
 	if (err)
 		goto err_xm_init;
 
-	router->proto_ll_ops[MLXSW_SP_L3_PROTO_IPV4] = &mlxsw_sp_router_ll_basic_ops;
+	router->proto_ll_ops[MLXSW_SP_L3_PROTO_IPV4] = mlxsw_sp_router_xm_ipv4_is_supported(mlxsw_sp) ?
+						       &mlxsw_sp_router_ll_xm_ops :
+						       &mlxsw_sp_router_ll_basic_ops;
 	router->proto_ll_ops[MLXSW_SP_L3_PROTO_IPV6] = &mlxsw_sp_router_ll_basic_ops;
 
 	err = mlxsw_sp_router_ll_op_ctx_init(router);
diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.h b/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.h
index 31612891ad48..2875ee8ec537 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.h
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.h
@@ -227,5 +227,6 @@ extern const struct mlxsw_sp_router_ll_ops mlxsw_sp_router_ll_xm_ops;
 
 int mlxsw_sp_router_xm_init(struct mlxsw_sp *mlxsw_sp);
 void mlxsw_sp_router_xm_fini(struct mlxsw_sp *mlxsw_sp);
+bool mlxsw_sp_router_xm_ipv4_is_supported(const struct mlxsw_sp *mlxsw_sp);
 
 #endif /* _MLXSW_ROUTER_H_*/
diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_router_xm.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_router_xm.c
index 975962cd6765..b680c22eff7d 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_router_xm.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_router_xm.c
@@ -803,3 +803,10 @@ void mlxsw_sp_router_xm_fini(struct mlxsw_sp *mlxsw_sp)
 	rhashtable_destroy(&router_xm->ltable_ht);
 	kfree(router_xm);
 }
+
+bool mlxsw_sp_router_xm_ipv4_is_supported(const struct mlxsw_sp *mlxsw_sp)
+{
+	struct mlxsw_sp_router_xm *router_xm = mlxsw_sp->router->xm;
+
+	return router_xm && router_xm->ipv4_supported;
+}
-- 
2.29.2


Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 834AF344A0B
	for <lists+netdev@lfdr.de>; Mon, 22 Mar 2021 17:00:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231249AbhCVQA2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Mar 2021 12:00:28 -0400
Received: from out5-smtp.messagingengine.com ([66.111.4.29]:39189 "EHLO
        out5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230499AbhCVP7o (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 22 Mar 2021 11:59:44 -0400
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.nyi.internal (Postfix) with ESMTP id CA36F5C01D8;
        Mon, 22 Mar 2021 11:59:43 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute3.internal (MEProxy); Mon, 22 Mar 2021 11:59:43 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm2; bh=8aPkjrwS4LQQcSDWHFu4l0CFT6Hkzk8nIYKKBfkVOgs=; b=hWMN93PL
        QUtLkkUOrmL/5MBAfirHVpwWPWhUixJx3Q6Lo9hPTWWrXMvYD+KJ+1oRzpMmBLsF
        mdj80Xz/SiXOz8JyH5Nb4K5SmjBHdzqD0y/Qj8wUZA7t7NgcMfjPpMdlaMJCoJJZ
        ukWLFzuiOU4uxgnCGGinvl0oFP+l9mkWwrG5yq21DHnJvIxLo5Nf4kQ5nQ90eyNk
        XP8khpmkrsef4sTSMQqVWzCNmXk8xziJNr5OfpOn7xtZrbMuPusqBDOHe6+k98z5
        GPAMEEHBB9ZUaCdzbn8NzzKQ3/ybocJBCqnwgQx+RGIM2wx90NadjuEQmlJa6j0G
        xkm0QLq5UK4+JQ==
X-ME-Sender: <xms:775YYJZcmNgwZY7LUFCZMgyw25xuM6Hn9A7SziQHo-UH-mWplB1_Qw>
    <xme:775YYAZMTNLdRAM42r11wH0QXjKqZnzkGp4y7hobOHLbvoSbwQc6_lLsU56oat3Gb
    zS4z7PsnJsLZyg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrudeggedgkedvucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgjfhgggfestdekre
    dtredttdenucfhrhhomhepkfguohcuufgthhhimhhmvghluceoihguohhstghhsehiugho
    shgthhdrohhrgheqnecuggftrfgrthhtvghrnhepudetieevffffveelkeeljeffkefhke
    ehgfdtffethfelvdejgffghefgveejkefhnecukfhppeekgedrvddvledrudehfedrgeeg
    necuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepihguoh
    hstghhsehiughoshgthhdrohhrgh
X-ME-Proxy: <xmx:775YYL8asleJAQQJwE2LODC3zWbZ4foG_2QMF6g_ZbqSGsQTTUrN1w>
    <xmx:775YYHpp1OkB2OBu3xJEcRpe_Jurw1LOwEdhzJWk4h8E6cYZlPDrZQ>
    <xmx:775YYEpJ8KrPQpWNOSp8UK9_oV8CKaGKNzrZ9wws8gwzjShnRcmP6A>
    <xmx:775YYNm9nPifiYl2HcmjvXgCfKf5t-OWt1dEtdowvbAvvsIBohPGcw>
Received: from shredder.lan (igld-84-229-153-44.inter.net.il [84.229.153.44])
        by mail.messagingengine.com (Postfix) with ESMTPA id 1B8541080057;
        Mon, 22 Mar 2021 11:59:41 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, jiri@nvidia.com,
        petrm@nvidia.com, dsahern@gmail.com, mlxsw@nvidia.com,
        Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH net-next 03/14] mlxsw: spectrum_router: Only provide MAC address for valid nexthops
Date:   Mon, 22 Mar 2021 17:58:44 +0200
Message-Id: <20210322155855.3164151-4-idosch@idosch.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210322155855.3164151-1-idosch@idosch.org>
References: <20210322155855.3164151-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ido Schimmel <idosch@nvidia.com>

The helper returns the MAC address associated with the nexthop. It is
only valid when the nexthop forwards packets and when it is an Ethernet
nexthop. Reflect this in the checks the helper is performing.

This is not an issue because the sole caller of the function only
invokes it for such nexthops.

Signed-off-by: Ido Schimmel <idosch@nvidia.com>
Reviewed-by: Petr Machata <petrm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c
index 593a40aa9af8..b7358cf611c1 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c
@@ -2986,7 +2986,8 @@ bool mlxsw_sp_nexthop_is_forward(const struct mlxsw_sp_nexthop *nh)
 
 unsigned char *mlxsw_sp_nexthop_ha(struct mlxsw_sp_nexthop *nh)
 {
-	if (!nh->offloaded)
+	if (nh->type != MLXSW_SP_NEXTHOP_TYPE_ETH ||
+	    !mlxsw_sp_nexthop_is_forward(nh))
 		return NULL;
 	return nh->neigh_entry->ha;
 }
-- 
2.29.2


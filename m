Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 538BB19536B
	for <lists+netdev@lfdr.de>; Fri, 27 Mar 2020 09:57:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727336AbgC0I5E (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 Mar 2020 04:57:04 -0400
Received: from out5-smtp.messagingengine.com ([66.111.4.29]:47521 "EHLO
        out5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727173AbgC0I5C (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 27 Mar 2020 04:57:02 -0400
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailout.nyi.internal (Postfix) with ESMTP id 754915C0462;
        Fri, 27 Mar 2020 04:57:01 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute4.internal (MEProxy); Fri, 27 Mar 2020 04:57:01 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm2; bh=HN9j02Mvqu2iUy7WK/5gwThp/NhHC9cUzv3z8MOqt10=; b=Od3CqS5p
        /RQtdeFfakKQBqOJMCiwdyfgiu1aNah6qTRpGQ/P1u69GuDfxqTKNA0VxrAHNyJ8
        3zm8jGobElGX3LF0VitmN67VmIr7hki7VNH/tzQe6Iq6yZBPEt/EUk9T3lWGO+cu
        dertLz6hx2JlO0SWlt7+PrvCrnwfoAlAMsJxQe/rntdN8f5JLWs6cXEECejkqq0V
        W+IHfaUuURvFop6AiQAeWPyf0oMV1UKkZ+Zjkz0e3T8f1ffvG8iOoaa6y0xoZ64V
        tA1kCbI1+GYyqzYUODsFHI2FzSOVDqPzScJ6zcROccMDI2azlLQrPMI/vcptBGPa
        gXWgMYWPnZjbxg==
X-ME-Sender: <xms:3b99XvpEcZLL0PirQx0-VMDMtIiojZ76bHO6Jswe3BlxJlfmDs1zow>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedugedrudehkedgvdefucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgjfhgggfestdekre
    dtredttdenucfhrhhomhepkfguohcuufgthhhimhhmvghluceoihguohhstghhsehiugho
    shgthhdrohhrgheqnecukfhppeejledrudekuddrudefvddrudeludenucevlhhushhtvg
    hrufhiiigvpedvnecurfgrrhgrmhepmhgrihhlfhhrohhmpehiughoshgthhesihguohhs
    tghhrdhorhhg
X-ME-Proxy: <xmx:3b99XuVzi8klVKVK0_ntBLZaszP0C8scR3DTFIl-Tw7CBzLZR91EZw>
    <xmx:3b99XpAyjFMEIqwrlQDFQiLayqvQ87sRhBqD50UcqFu-9zEauTMWvA>
    <xmx:3b99XvxaWUK-CF8RrK-HVSshNx0tMPfGTN4FdViU0aDdGeau9FmlOg>
    <xmx:3b99XoPMnODGbMHkbAcu3kpGSbSUve-ptaQCX-O7Y_DoUt_5k_-DWw>
Received: from splinter.mtl.com (bzq-79-181-132-191.red.bezeqint.net [79.181.132.191])
        by mail.messagingengine.com (Postfix) with ESMTPA id 32962306BD54;
        Fri, 27 Mar 2020 04:57:00 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, jiri@mellanox.com, kuba@kernel.org,
        mlxsw@mellanox.com, Ido Schimmel <idosch@mellanox.com>
Subject: [PATCH net-next 6/6] mlxsw: spectrum_router: Avoid uninitialized symbol errors
Date:   Fri, 27 Mar 2020 11:55:25 +0300
Message-Id: <20200327085525.1906170-7-idosch@idosch.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200327085525.1906170-1-idosch@idosch.org>
References: <20200327085525.1906170-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ido Schimmel <idosch@mellanox.com>

Suppress the following smatch errors. None of these are actually
possible with current code paths.

drivers/net/ethernet/mellanox/mlxsw//spectrum_router.c:1220
mlxsw_sp_ipip_entry_find_decap() error: uninitialized symbol 'saddrp'.
drivers/net/ethernet/mellanox/mlxsw//spectrum_router.c:1220
mlxsw_sp_ipip_entry_find_decap() error: uninitialized symbol
'saddr_len'.
drivers/net/ethernet/mellanox/mlxsw//spectrum_router.c:1221
mlxsw_sp_ipip_entry_find_decap() error: uninitialized symbol
'saddr_prefix_len'.

drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c:1390
mlxsw_sp_netdevice_ipip_ol_reg_event() error: uninitialized symbol
'ipipt'.

drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c:3255
mlxsw_sp_nexthop_group_update() error: uninitialized symbol 'err'.

Signed-off-by: Ido Schimmel <idosch@mellanox.com>
Reviewed-by: Jiri Pirko <jiri@mellanox.com>
---
 drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c
index 97b7e6ebd9fa..d5bca1be3ef5 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c
@@ -1212,7 +1212,7 @@ mlxsw_sp_ipip_entry_find_decap(struct mlxsw_sp *mlxsw_sp,
 		saddr_len = 4;
 		saddr_prefix_len = 32;
 		break;
-	case MLXSW_SP_L3_PROTO_IPV6:
+	default:
 		WARN_ON(1);
 		return NULL;
 	}
@@ -1380,9 +1380,9 @@ static bool mlxsw_sp_netdevice_ipip_can_offload(struct mlxsw_sp *mlxsw_sp,
 static int mlxsw_sp_netdevice_ipip_ol_reg_event(struct mlxsw_sp *mlxsw_sp,
 						struct net_device *ol_dev)
 {
+	enum mlxsw_sp_ipip_type ipipt = MLXSW_SP_IPIP_TYPE_MAX;
 	struct mlxsw_sp_ipip_entry *ipip_entry;
 	enum mlxsw_sp_l3proto ul_proto;
-	enum mlxsw_sp_ipip_type ipipt;
 	union mlxsw_sp_l3addr saddr;
 	u32 ul_tb_id;
 
@@ -3231,7 +3231,6 @@ mlxsw_sp_nexthop_group_update(struct mlxsw_sp *mlxsw_sp,
 	u32 adj_index = nh_grp->adj_index; /* base */
 	struct mlxsw_sp_nexthop *nh;
 	int i;
-	int err;
 
 	for (i = 0; i < nh_grp->count; i++) {
 		nh = &nh_grp->nexthops[i];
@@ -3242,6 +3241,8 @@ mlxsw_sp_nexthop_group_update(struct mlxsw_sp *mlxsw_sp,
 		}
 
 		if (nh->update || reallocate) {
+			int err = 0;
+
 			switch (nh->type) {
 			case MLXSW_SP_NEXTHOP_TYPE_ETH:
 				err = mlxsw_sp_nexthop_update
-- 
2.24.1


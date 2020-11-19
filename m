Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 07C912B9330
	for <lists+netdev@lfdr.de>; Thu, 19 Nov 2020 14:13:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727334AbgKSNJa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Nov 2020 08:09:30 -0500
Received: from wout3-smtp.messagingengine.com ([64.147.123.19]:41367 "EHLO
        wout3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726958AbgKSNJa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 Nov 2020 08:09:30 -0500
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.west.internal (Postfix) with ESMTP id E1F19ED0;
        Thu, 19 Nov 2020 08:09:28 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute3.internal (MEProxy); Thu, 19 Nov 2020 08:09:29 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm1; bh=VfHREOI2rhUGtxA3k8rxUeFfqhgekWIFrFjHVl2urCk=; b=jwgkzr29
        Hg6+O+sUOsHFOmtXHJxdDKKGrM51501rAdNVB8Ih1TGHQdq5YvL5wcVzGPwVno13
        QN/44+Bp2/nwg0tkA5neu/aIUxU4rOlootzbj+P4vaxLK/HeI9nw95l76Gw9hsM4
        Iw4DUXW03JYfqiYRmDpl8ufn1v1wQEwpk5hz5bQEvbN6RVRUQQD266tetCasKyg5
        H6mER711jmwFe+UDQS+6ml+PL9fvF2BWW097x6O5rDHrrY2SINV1F4B7sdxYOkvH
        C/8FW4Sl71IUg7L1lUobHTv1M0NqOi7GkvAEYjzuOYaKc0C+4/7oAZy/bA/4+5me
        7E1vMdX0/FpHTQ==
X-ME-Sender: <xms:iG62X_DFsdlXev6yajHKmppYNR3bS7arf8mpk5o_x5S-rh5x3ziNMw>
    <xme:iG62X1gDvUmNKw4vnFcl4zFgiJkuYFMvh-fiBE5CYPUJdw6cHZIRWFtwm5HvzPXtw
    yzR2BMCqGm6K_k>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedujedrudefjedggeekucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgjfhgggfestdekre
    dtredttdenucfhrhhomhepkfguohcuufgthhhimhhmvghluceoihguohhstghhsehiugho
    shgthhdrohhrgheqnecuggftrfgrthhtvghrnhepudetieevffffveelkeeljeffkefhke
    ehgfdtffethfelvdejgffghefgveejkefhnecukfhppeekgedrvddvledrudehgedrudeg
    jeenucevlhhushhtvghrufhiiigvpedunecurfgrrhgrmhepmhgrihhlfhhrohhmpehiug
    hoshgthhesihguohhstghhrdhorhhg
X-ME-Proxy: <xmx:iG62X6nU-5JhCV_1xOJwni-3ibpawY5LH_LcK6YXDmrqXpLazgUTRg>
    <xmx:iG62XxzO-LRQ-sj7VGHlJxJITiCM1TywkLE-XK8bnji9zYqjE25EpQ>
    <xmx:iG62X0SuMB0yuK_3VMyhExBK4v5K-cxNNo_HKBZDgRx2Zkn8AKM5fg>
    <xmx:iG62X6eviaEknz9NqdkyHJSVnFPyb628CkJXTE_8cjbhi1ny_zo-rw>
Received: from shredder.lan (igld-84-229-154-147.inter.net.il [84.229.154.147])
        by mail.messagingengine.com (Postfix) with ESMTPA id 9EE05328005A;
        Thu, 19 Nov 2020 08:09:26 -0500 (EST)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, dsahern@gmail.com,
        jiri@nvidia.com, mlxsw@nvidia.com, Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH net-next 3/8] mlxsw: spectrum_router: Allow programming routes with nexthop objects
Date:   Thu, 19 Nov 2020 15:08:43 +0200
Message-Id: <20201119130848.407918-4-idosch@idosch.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20201119130848.407918-1-idosch@idosch.org>
References: <20201119130848.407918-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ido Schimmel <idosch@nvidia.com>

Now that the driver supports nexthop objects, the check is no longer
necessary. Remove it.

Signed-off-by: Ido Schimmel <idosch@nvidia.com>
Reviewed-by: Jiri Pirko <jiri@nvidia.com>
---
 .../net/ethernet/mellanox/mlxsw/spectrum_router.c  | 14 --------------
 1 file changed, 14 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c
index ad335d5b8d66..42a7bec3fd88 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c
@@ -7068,20 +7068,6 @@ static int mlxsw_sp_router_fib_event(struct notifier_block *nb,
 				NL_SET_ERR_MSG_MOD(info->extack, "IPv6 gateway with IPv4 route is not supported");
 				return notifier_from_errno(-EINVAL);
 			}
-			if (fen_info->fi->nh) {
-				NL_SET_ERR_MSG_MOD(info->extack, "IPv4 route with nexthop objects is not supported");
-				return notifier_from_errno(-EINVAL);
-			}
-		} else if (info->family == AF_INET6) {
-			struct fib6_entry_notifier_info *fen6_info;
-
-			fen6_info = container_of(info,
-						 struct fib6_entry_notifier_info,
-						 info);
-			if (fen6_info->rt->nh) {
-				NL_SET_ERR_MSG_MOD(info->extack, "IPv6 route with nexthop objects is not supported");
-				return notifier_from_errno(-EINVAL);
-			}
 		}
 		break;
 	}
-- 
2.28.0


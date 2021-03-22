Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 26F9C344A12
	for <lists+netdev@lfdr.de>; Mon, 22 Mar 2021 17:00:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231601AbhCVQAf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Mar 2021 12:00:35 -0400
Received: from out5-smtp.messagingengine.com ([66.111.4.29]:44035 "EHLO
        out5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230218AbhCVQAA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 22 Mar 2021 12:00:00 -0400
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.nyi.internal (Postfix) with ESMTP id C2B435C01A9;
        Mon, 22 Mar 2021 11:59:59 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute3.internal (MEProxy); Mon, 22 Mar 2021 11:59:59 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm2; bh=yM7DrzRaDEUQ6/mqxIxqg4+9sRo7d7GRxGR35wsSZRA=; b=Yb8yd5XP
        baLXgCvSl3efKuPrFEeJ/WoybhiijglA0G4H9GJPUpMBolS4CaSSvC8avgTVBGft
        WhkFyPSSGPIpC5xyDF9qXNst37R4l/1mXLc/tC/1kD171w4uu1o9u3C7VMSu6ct5
        mK5M4XzPrE/yz/zMjbNJndvUWqshqfJ5K4+eZ5utW+7a+aTK+CIX+TnavC0P4j4O
        Qr73dFzYQ3iNss1Si3Ix/dvZmkcEQoSZrWwIW2Anh3OCHQbkqNTqDsNKpBAo+8lr
        RZENt3WOmJ4JRPXDfriePrzuVGurEz257+KjzyovMkkxOAthlFiPaDuX8g42jClR
        Pqlu4rw2+X5YIg==
X-ME-Sender: <xms:_75YYNGODM8rT7f5pNsFJO93I79-zE5Nr03ZQCKnEWgnYgfBbxcL3A>
    <xme:_75YYCWxSp-8ug_t3W-RYNLaqIx2oBGfI8PcKTtxTTzKf9wuz78pMkSWcpTk35rXK
    TALcQmy-P1nAbE>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrudeggedgkedvucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgjfhgggfestdekre
    dtredttdenucfhrhhomhepkfguohcuufgthhhimhhmvghluceoihguohhstghhsehiugho
    shgthhdrohhrgheqnecuggftrfgrthhtvghrnhepudetieevffffveelkeeljeffkefhke
    ehgfdtffethfelvdejgffghefgveejkefhnecukfhppeekgedrvddvledrudehfedrgeeg
    necuvehluhhsthgvrhfuihiivgepjeenucfrrghrrghmpehmrghilhhfrhhomhepihguoh
    hstghhsehiughoshgthhdrohhrgh
X-ME-Proxy: <xmx:_75YYPICcUmVebtYcVXlBpBzd06pLh19Xd4Us0onVlFjiFC8YGeFYw>
    <xmx:_75YYDEZv6VVrKMq_44rKpEbQeZ_YNPPw9NQ6jE92j-CBKhKt1vFnA>
    <xmx:_75YYDWEbzYzaD5iqvBIWk9Uwxpq-RfCO5qt_3iAdct_kAkZ0bkEJA>
    <xmx:_75YYJyf-E3PYevgwJS83YGAj1BMEZgxpMi2X9L5kqSD7JNLLtJIpQ>
Received: from shredder.lan (igld-84-229-153-44.inter.net.il [84.229.153.44])
        by mail.messagingengine.com (Postfix) with ESMTPA id A60501080057;
        Mon, 22 Mar 2021 11:59:57 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, jiri@nvidia.com,
        petrm@nvidia.com, dsahern@gmail.com, mlxsw@nvidia.com,
        Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH net-next 10/14] mlxsw: spectrum_router: Break nexthop group entry validation to a separate function
Date:   Mon, 22 Mar 2021 17:58:51 +0200
Message-Id: <20210322155855.3164151-11-idosch@idosch.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210322155855.3164151-1-idosch@idosch.org>
References: <20210322155855.3164151-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ido Schimmel <idosch@nvidia.com>

The validation of a nexthop group entry is also necessary for resilient
nexthop groups, so break the validation to a separate function to allow
for code reuse in subsequent patches.

Signed-off-by: Ido Schimmel <idosch@nvidia.com>
Reviewed-by: Petr Machata <petrm@nvidia.com>
---
 .../ethernet/mellanox/mlxsw/spectrum_router.c | 36 +++++++++++++------
 1 file changed, 25 insertions(+), 11 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c
index 6be225ec1997..fa190e27323e 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c
@@ -4296,6 +4296,29 @@ mlxsw_sp_nexthop_obj_single_validate(struct mlxsw_sp *mlxsw_sp,
 	return err;
 }
 
+static int
+mlxsw_sp_nexthop_obj_group_entry_validate(struct mlxsw_sp *mlxsw_sp,
+					  const struct nh_notifier_single_info *nh,
+					  struct netlink_ext_ack *extack)
+{
+	int err;
+
+	err = mlxsw_sp_nexthop_obj_single_validate(mlxsw_sp, nh, extack);
+	if (err)
+		return err;
+
+	/* Device only nexthops with an IPIP device are programmed as
+	 * encapsulating adjacency entries.
+	 */
+	if (!nh->gw_family && !nh->is_reject &&
+	    !mlxsw_sp_netdev_ipip_type(mlxsw_sp, nh->dev, NULL)) {
+		NL_SET_ERR_MSG_MOD(extack, "Nexthop group entry does not have a gateway");
+		return -EINVAL;
+	}
+
+	return 0;
+}
+
 static int
 mlxsw_sp_nexthop_obj_group_validate(struct mlxsw_sp *mlxsw_sp,
 				    const struct nh_notifier_grp_info *nh_grp,
@@ -4313,19 +4336,10 @@ mlxsw_sp_nexthop_obj_group_validate(struct mlxsw_sp *mlxsw_sp,
 		int err;
 
 		nh = &nh_grp->nh_entries[i].nh;
-		err = mlxsw_sp_nexthop_obj_single_validate(mlxsw_sp, nh,
-							   extack);
+		err = mlxsw_sp_nexthop_obj_group_entry_validate(mlxsw_sp, nh,
+								extack);
 		if (err)
 			return err;
-
-		/* Device only nexthops with an IPIP device are programmed as
-		 * encapsulating adjacency entries.
-		 */
-		if (!nh->gw_family && !nh->is_reject &&
-		    !mlxsw_sp_netdev_ipip_type(mlxsw_sp, nh->dev, NULL)) {
-			NL_SET_ERR_MSG_MOD(extack, "Nexthop group entry does not have a gateway");
-			return -EINVAL;
-		}
 	}
 
 	return 0;
-- 
2.29.2


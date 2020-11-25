Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E45392C487A
	for <lists+netdev@lfdr.de>; Wed, 25 Nov 2020 20:36:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728802AbgKYTfv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Nov 2020 14:35:51 -0500
Received: from out3-smtp.messagingengine.com ([66.111.4.27]:57513 "EHLO
        out3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728521AbgKYTfu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 25 Nov 2020 14:35:50 -0500
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.nyi.internal (Postfix) with ESMTP id 7DC515C009D;
        Wed, 25 Nov 2020 14:35:49 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute3.internal (MEProxy); Wed, 25 Nov 2020 14:35:49 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm1; bh=so5/Sl/2rzXhbACDSrZEug8/9w4xmFwYsxzaN9aK6uk=; b=hUbe4KE5
        LKIbL6edRGIFlBn4IyPYjMm1p0AgbgVDWd3tHC5+I0x93+ZP5cXRimOT2JU1I9pr
        1f4i6MLdP5VO3J+OkFNtUdU8vug8P4IbOHfjOcxT7yCQCKDFKLG0PsV4jKVc9UlE
        tppZjShRo1GbXrhUzf7Toim8rXLjZcMLsUgYQSInwfTIsBgkNwytw5VYFBRCu1py
        DDLsBWl9p7KfJr+LBMkNjYilBYQdBsGYx/sMVImtjshSmvU8g08vw0tu2mn+Df6E
        yv9lnCeRMUpYsz09zerDcmiVehCPINcjsb1XW9BBZiLkJVnCKGO5pTM1dEPspYLr
        q/3jvu5XTkZd4w==
X-ME-Sender: <xms:FbK-XzTU7RaryGP07GCteWEqAbdyurtBcflJdoVYVrdDNXUW9AM3hQ>
    <xme:FbK-X0wu0G97quVJm0C-0-c6bvqpSfu1Dj4myoVxpJaXybgcyPhOJPR_Gpsxx_FGL
    PMU5nvU2UHeeYM>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedujedrudehtddguddvjecutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecunecujfgurhephffvufffkffojghfggfgsedtke
    ertdertddtnecuhfhrohhmpefkughoucfutghhihhmmhgvlhcuoehiughoshgthhesihgu
    ohhstghhrdhorhhgqeenucggtffrrghtthgvrhhnpeduteeiveffffevleekleejffekhf
    ekhefgtdfftefhledvjefggfehgfevjeekhfenucfkphepkeegrddvvdelrdduheegrddu
    geejnecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepih
    guohhstghhsehiughoshgthhdrohhrgh
X-ME-Proxy: <xmx:FbK-X41WrDIrRhVLRWR26ojBk_Y1f04oHqgMa8-UkTr0E0l72NINew>
    <xmx:FbK-XzD0Ar6o_QVoZlDfgdmKe2Sfr12ubtV0gHOCHcKxwt3CPW_UKQ>
    <xmx:FbK-X8jcKIdoAh4tX9CA0j6v8MsVPcJCnzfPRrnccmy0JRZjpwaHaQ>
    <xmx:FbK-X1soe0N_NdumqFAYIRIV-R36AGhh5EOv5R2PXF-IYXy78cvw0w>
Received: from shredder.lan (igld-84-229-154-147.inter.net.il [84.229.154.147])
        by mail.messagingengine.com (Postfix) with ESMTPA id 1C4023280060;
        Wed, 25 Nov 2020 14:35:47 -0500 (EST)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, jiri@nvidia.com,
        dsahern@gmail.com, mlxsw@nvidia.com,
        Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH net-next 1/5] mlxsw: spectrum_router: Fix error handling issue
Date:   Wed, 25 Nov 2020 21:35:01 +0200
Message-Id: <20201125193505.1052466-2-idosch@idosch.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20201125193505.1052466-1-idosch@idosch.org>
References: <20201125193505.1052466-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ido Schimmel <idosch@nvidia.com>

Return error to the caller instead of suppressing it.

Fixes: e3ddfb45bacd ("mlxsw: spectrum_router: Allow returning errors from mlxsw_sp_nexthop_group_refresh()")
Addresses-Coverity: ("Error handling issues  (CHECKED_RETURN)")
Signed-off-by: Ido Schimmel <idosch@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c
index d551e9bc373c..118d48d9ff8e 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c
@@ -3608,10 +3608,8 @@ mlxsw_sp_nexthop_group_refresh(struct mlxsw_sp *mlxsw_sp,
 	int i, err2, err = 0;
 	u32 old_adj_index;
 
-	if (!nhgi->gateway) {
-		mlxsw_sp_nexthop_fib_entries_update(mlxsw_sp, nh_grp);
-		return 0;
-	}
+	if (!nhgi->gateway)
+		return mlxsw_sp_nexthop_fib_entries_update(mlxsw_sp, nh_grp);
 
 	for (i = 0; i < nhgi->count; i++) {
 		nh = &nhgi->nexthops[i];
-- 
2.28.0


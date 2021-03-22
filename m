Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BBF3B344A0E
	for <lists+netdev@lfdr.de>; Mon, 22 Mar 2021 17:00:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231561AbhCVQAc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Mar 2021 12:00:32 -0400
Received: from out5-smtp.messagingengine.com ([66.111.4.29]:59569 "EHLO
        out5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231288AbhCVP7u (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 22 Mar 2021 11:59:50 -0400
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.nyi.internal (Postfix) with ESMTP id 3DC7A5C01A9;
        Mon, 22 Mar 2021 11:59:50 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute3.internal (MEProxy); Mon, 22 Mar 2021 11:59:50 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm2; bh=3NqsANYgM6xsUfaA1bGlJh6bcJkkgx7Kiy9yiVJyBQU=; b=uaAuKgX7
        RKsCkGhAyaxAgsJ8nnwBWOBF3t5tdownieZHmK5pEvdefo2GbsdWQWayfxmBKRrg
        E/fgVUhHVPPTd89onG2IJB4loqub8AQgeesN5Xe5K9DGSDXE0jbctGwT06lct568
        j3ezmZ43Ll2b+/oXLL9c+2b9WKonODhCwPcb8A7A3+gFIa/XoZafV0OJlsR1plvR
        USrfZJEvH+F+MPVn2VYYrbNywbIrvDCS+yAhue5KraGurVOm9fEDoGoXciWE7Ngc
        MD/VuQjBylBT/cdod+HD+NSSen8/9JOA+Gw6IuMvE+ShoDIuEF/oiQOHTnSja5rM
        xGwGpPIoG90pWQ==
X-ME-Sender: <xms:9r5YYBFvMA-qwIcneDC2ELb3eHP9gkMVcrubW9akcDaTj9fHf3Z2yw>
    <xme:9r5YYGWsCmVgo0MFXL47DHB_JYK3czZwwAIa5R_4mH6tWHhHguGT0fu8F6A1yVA2T
    gMEWm7Jde4N87I>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrudeggedgkedvucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgjfhgggfestdekre
    dtredttdenucfhrhhomhepkfguohcuufgthhhimhhmvghluceoihguohhstghhsehiugho
    shgthhdrohhrgheqnecuggftrfgrthhtvghrnhepudetieevffffveelkeeljeffkefhke
    ehgfdtffethfelvdejgffghefgveejkefhnecukfhppeekgedrvddvledrudehfedrgeeg
    necuvehluhhsthgvrhfuihiivgepfeenucfrrghrrghmpehmrghilhhfrhhomhepihguoh
    hstghhsehiughoshgthhdrohhrgh
X-ME-Proxy: <xmx:9r5YYDJ96hb3NZjNnC53Fzn7Zn8FKrCC3QRc77sVWLI2SYQf7YIlMQ>
    <xmx:9r5YYHGmTXkDkhC7Rqx7JjhiolG4RgK-tR0vJ_luV9M7LS--IsRx4Q>
    <xmx:9r5YYHUoCRQMF4pzCfDkCd1o2UvcXhJsLM2YTASuNNUFVA2SGnZmFw>
    <xmx:9r5YYNwFjROB0pdnB1ly_ksRa4x2TBxvKJ0324W48mGal1W1HQX9OQ>
Received: from shredder.lan (igld-84-229-153-44.inter.net.il [84.229.153.44])
        by mail.messagingengine.com (Postfix) with ESMTPA id 1E9FA1080064;
        Mon, 22 Mar 2021 11:59:47 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, jiri@nvidia.com,
        petrm@nvidia.com, dsahern@gmail.com, mlxsw@nvidia.com,
        Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH net-next 06/14] mlxsw: spectrum_router: Prepare for nexthops with trap action
Date:   Mon, 22 Mar 2021 17:58:47 +0200
Message-Id: <20210322155855.3164151-7-idosch@idosch.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210322155855.3164151-1-idosch@idosch.org>
References: <20210322155855.3164151-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ido Schimmel <idosch@nvidia.com>

Nexthops that need to be programmed with a trap action might not have a
valid router interface (RIF) associated with them. Therefore, use the
loopback RIF created during initialization to program them to the
device.

Signed-off-by: Ido Schimmel <idosch@nvidia.com>
Reviewed-by: Petr Machata <petrm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c
index 3ad1e1bd2197..d09a76866a5f 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c
@@ -3411,10 +3411,13 @@ static int __mlxsw_sp_nexthop_update(struct mlxsw_sp *mlxsw_sp, u32 adj_index,
 {
 	struct mlxsw_sp_neigh_entry *neigh_entry = nh->neigh_entry;
 	char ratr_pl[MLXSW_REG_RATR_LEN];
+	u16 rif_index;
 
+	rif_index = nh->rif ? nh->rif->rif_index :
+			      mlxsw_sp->router->lb_rif_index;
 	mlxsw_reg_ratr_pack(ratr_pl, MLXSW_REG_RATR_OP_WRITE_WRITE_ENTRY,
 			    true, MLXSW_REG_RATR_TYPE_ETHERNET,
-			    adj_index, nh->rif->rif_index);
+			    adj_index, rif_index);
 	if (nh->action == MLXSW_SP_NEXTHOP_ACTION_DISCARD)
 		mlxsw_reg_ratr_trap_action_set(ratr_pl,
 					       MLXSW_REG_RATR_TRAP_ACTION_DISCARD_ERRORS);
-- 
2.29.2


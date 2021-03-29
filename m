Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E7DD134CDAF
	for <lists+netdev@lfdr.de>; Mon, 29 Mar 2021 12:11:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232571AbhC2KKq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Mar 2021 06:10:46 -0400
Received: from out3-smtp.messagingengine.com ([66.111.4.27]:54289 "EHLO
        out3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232579AbhC2KK1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Mar 2021 06:10:27 -0400
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.nyi.internal (Postfix) with ESMTP id 922335C00C4;
        Mon, 29 Mar 2021 06:10:26 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute3.internal (MEProxy); Mon, 29 Mar 2021 06:10:26 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm2; bh=Cp8bMS1dY43XmrjlJFyspTFjkHPWxv/dPAfn7kOhLGE=; b=fNnBhPP1
        30Pa9bVA3203WIjgPYLF74FvDyQSIqOi6TXRvGW3z1Opu0qY9cjm1Cykj+K+VcDm
        bQQArFKSaaUMd+C1pDj8FxRRwaZ6stTPHcWkA9iLtEgDBMcgVBEY77c3qw+kyWXF
        /wFD8E/oC2tDbZC9y0JfOGZOMX6PDu0kqoxQwAtkyI/HswL+SWxEHAu1xPfYBzkG
        o9JispAH4q5uSrtW3ASBdNwwzICZZG4ue/ygnFSOkAP1/rNe5zGZu8wSFW5kkQ8W
        lh32kF5mbaAzpb4SrHRUeZeoHlbjXXGCN4t89u/kljS9iCRbGEzW5DuKEuvc0QiN
        +fn2v9LmD4Vg1w==
X-ME-Sender: <xms:kqdhYBkfekDd-OBWz7swH4CNVKstma9S7LOuBGYHl1djgPIxRmcaNQ>
    <xme:kqdhYM3P8cwC-PqxWERxTdwY97y5aK2bLFacpqDoKTGIv_dVC76zz4nJEtzd0-Acr
    PJx0y9MZ6zmpUg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrudehkedgvdehucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgjfhgggfestdekre
    dtredttdenucfhrhhomhepkfguohcuufgthhhimhhmvghluceoihguohhstghhsehiugho
    shgthhdrohhrgheqnecuggftrfgrthhtvghrnhepudetieevffffveelkeeljeffkefhke
    ehgfdtffethfelvdejgffghefgveejkefhnecukfhppeekgedrvddvledrudehfedrgeeg
    necuvehluhhsthgvrhfuihiivgepudenucfrrghrrghmpehmrghilhhfrhhomhepihguoh
    hstghhsehiughoshgthhdrohhrgh
X-ME-Proxy: <xmx:kqdhYHoABNL5jK9t0WK_cizQwv7PQtUvtyt0EqQZyxCJKDP5BHQVxA>
    <xmx:kqdhYBk8fYWjD0Qf71Bb6zG4Kg6s8c4c5ABdMROtGYnpbedlNbMJhg>
    <xmx:kqdhYP3QoKukFRym_Nt4nszpi8BSH5IIURfQ-vn4wzNW5ZOgGKFYrw>
    <xmx:kqdhYNAg5BVXtITIeyYtVlg-ukhzf0FlwNgutAMwaKmWsmLJD8QVbA>
Received: from shredder.mellanox.com (igld-84-229-153-44.inter.net.il [84.229.153.44])
        by mail.messagingengine.com (Postfix) with ESMTPA id 53FCA240054;
        Mon, 29 Mar 2021 06:10:25 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, jiri@nvidia.com,
        mlxsw@nvidia.com, Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH net-next 2/6] mlxsw: spectrum_matchall: Convert if statements to a switch statement
Date:   Mon, 29 Mar 2021 13:09:44 +0300
Message-Id: <20210329100948.355486-3-idosch@idosch.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210329100948.355486-1-idosch@idosch.org>
References: <20210329100948.355486-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ido Schimmel <idosch@nvidia.com>

Previous patch moved the protocol check out of the action check, so
these if statements can now be converted to a switch statement. Perform
the conversion.

Signed-off-by: Ido Schimmel <idosch@nvidia.com>
Reviewed-by: Jiri Pirko <jiri@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlxsw/spectrum_matchall.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_matchall.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_matchall.c
index 9252e23fd082..af0a20581a37 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_matchall.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_matchall.c
@@ -252,7 +252,8 @@ int mlxsw_sp_mall_replace(struct mlxsw_sp *mlxsw_sp,
 
 	act = &f->rule->action.entries[0];
 
-	if (act->id == FLOW_ACTION_MIRRED) {
+	switch (act->id) {
+	case FLOW_ACTION_MIRRED:
 		if (flower_prio_valid && mall_entry->ingress &&
 		    mall_entry->priority >= flower_min_prio) {
 			NL_SET_ERR_MSG(f->common.extack, "Failed to add behind existing flower rules");
@@ -267,7 +268,8 @@ int mlxsw_sp_mall_replace(struct mlxsw_sp *mlxsw_sp,
 		}
 		mall_entry->type = MLXSW_SP_MALL_ACTION_TYPE_MIRROR;
 		mall_entry->mirror.to_dev = act->dev;
-	} else if (act->id == FLOW_ACTION_SAMPLE) {
+		break;
+	case FLOW_ACTION_SAMPLE:
 		if (flower_prio_valid &&
 		    mall_entry->priority >= flower_min_prio) {
 			NL_SET_ERR_MSG(f->common.extack, "Failed to add behind existing flower rules");
@@ -279,7 +281,8 @@ int mlxsw_sp_mall_replace(struct mlxsw_sp *mlxsw_sp,
 		mall_entry->sample.params.truncate = act->sample.truncate;
 		mall_entry->sample.params.trunc_size = act->sample.trunc_size;
 		mall_entry->sample.params.rate = act->sample.rate;
-	} else {
+		break;
+	default:
 		err = -EOPNOTSUPP;
 		goto errout;
 	}
-- 
2.30.2


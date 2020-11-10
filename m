Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AB5FB2AD2D9
	for <lists+netdev@lfdr.de>; Tue, 10 Nov 2020 10:51:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731886AbgKJJvA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Nov 2020 04:51:00 -0500
Received: from wout3-smtp.messagingengine.com ([64.147.123.19]:49595 "EHLO
        wout3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1730570AbgKJJua (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Nov 2020 04:50:30 -0500
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.west.internal (Postfix) with ESMTP id AB66CE08;
        Tue, 10 Nov 2020 04:50:29 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute3.internal (MEProxy); Tue, 10 Nov 2020 04:50:30 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm1; bh=aAFLNEcChrju9De83QTrwBOj+/4wnwETE8s+WtTu8RY=; b=RqaSCKxy
        VThOD6yfX5kZBDaztyrSeZ2KWOMbNNIkkdElhmV+sCm7BlX2AIH1pxBUTC0H4woh
        pern92U9VtGBByIeQ041r2IG6Fw98KATtfvFPuZZSMxUuKx8SmZ1q6yXgtfumEuv
        s8V+R+OV4CAU0OaxGvW2OXp/Up3WWL1cL3vXWw7uX40JvxCrLgLGRlPJkgt8Z2s6
        QetQoiIizTfoeqrdM0V6iXkealHvRumHTFTLwqPzCtMdLxsL9QOhzl2ZSqUuAjMq
        CMZGW12WBb+SATutOeAG6OGChbQcj7v8072ImWTHrF01wv66qk9R+g5K+GJRM5tl
        SCQIcoHOsSBAAw==
X-ME-Sender: <xms:ZWKqX98A6pS6id5Y2tvAArpYIEvc7Q72hb9TDQzBsPJNMJw233EW1Q>
    <xme:ZWKqXxvV9BuVyXio0_zpAbbt74NiFjPHHauu_Vyz-N9w3gLMBtonYxAm48iqLnAMr
    -0VMixSY9CCo2k>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedujedruddujedgtdekucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgjfhgggfestdekre
    dtredttdenucfhrhhomhepkfguohcuufgthhhimhhmvghluceoihguohhstghhsehiugho
    shgthhdrohhrgheqnecuggftrfgrthhtvghrnhepudetieevffffveelkeeljeffkefhke
    ehgfdtffethfelvdejgffghefgveejkefhnecukfhppeekgedrvddvledrudehgedrudeg
    jeenucevlhhushhtvghrufhiiigvpeeknecurfgrrhgrmhepmhgrihhlfhhrohhmpehiug
    hoshgthhesihguohhstghhrdhorhhg
X-ME-Proxy: <xmx:ZWKqX7BW-bSj4hxlc2KICN9zCByLmfjR0ES7viETlLPeQ4wOKy1sDQ>
    <xmx:ZWKqXxd1L-GOru3B9yreT5BHpLb7AqhorRKfVbRJCuYlhN9VH7ZKoA>
    <xmx:ZWKqXyNJ36MShz662t_8SgEwVbEICiDWcMbtqFvC9kpUiD4WOfKtyg>
    <xmx:ZWKqX7Y3D9qUcX47b21TpoSnUzrX0meXizSi1jlTS5ZKPNAOAIakPQ>
Received: from shredder.mtl.com (igld-84-229-154-147.inter.net.il [84.229.154.147])
        by mail.messagingengine.com (Postfix) with ESMTPA id 0F5133280064;
        Tue, 10 Nov 2020 04:50:27 -0500 (EST)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, jiri@nvidia.com,
        mlxsw@nvidia.com, Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH net-next 09/15] mlxsw: spectrum_router: Use RALUE pack helper from abort function
Date:   Tue, 10 Nov 2020 11:48:54 +0200
Message-Id: <20201110094900.1920158-10-idosch@idosch.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20201110094900.1920158-1-idosch@idosch.org>
References: <20201110094900.1920158-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jiri Pirko <jiri@nvidia.com>

Unify the RALUE register payload packing and use the
__mlxsw_sp_fib_entry_ralue_pack() helper from
__mlxsw_sp_router_set_abort_trap().

Signed-off-by: Jiri Pirko <jiri@nvidia.com>
Signed-off-by: Ido Schimmel <idosch@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c
index 4edb2eec8179..b0758c5c3490 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c
@@ -5764,8 +5764,8 @@ static int __mlxsw_sp_router_set_abort_trap(struct mlxsw_sp *mlxsw_sp,
 		if (err)
 			return err;
 
-		mlxsw_reg_ralue_pack(ralue_pl, ralxx_proto,
-				     MLXSW_REG_RALUE_OP_WRITE_WRITE, vr->id, 0);
+		mlxsw_sp_fib_entry_ralue_pack(ralue_pl, proto,
+					      MLXSW_SP_FIB_ENTRY_OP_WRITE, vr->id, 0, NULL);
 		mlxsw_reg_ralue_act_ip2me_pack(ralue_pl);
 		err = mlxsw_reg_write(mlxsw_sp->core, MLXSW_REG(ralue),
 				      ralue_pl);
-- 
2.26.2


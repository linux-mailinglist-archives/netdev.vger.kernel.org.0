Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 41753F88BE
	for <lists+netdev@lfdr.de>; Tue, 12 Nov 2019 07:49:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726983AbfKLGtj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Nov 2019 01:49:39 -0500
Received: from out3-smtp.messagingengine.com ([66.111.4.27]:60635 "EHLO
        out3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726973AbfKLGti (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Nov 2019 01:49:38 -0500
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.nyi.internal (Postfix) with ESMTP id 2EA3B220E7;
        Tue, 12 Nov 2019 01:49:37 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute3.internal (MEProxy); Tue, 12 Nov 2019 01:49:37 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm1; bh=tK3A69kJ0VUiZjaS7esssaZgzi5PqvJGhU5MUP7LPNw=; b=XE5ult28
        Bt+QrUDi64x1j9O3xVqx4K5+JxhAqRqFraJr8evsXNNivvzVxPDEU1o+g+ejvvii
        hGDVTNPIfyMJv4MXCOuyYFcm8pevw7NDwakoSil7g/QRqsMKI1/iIpOp1yi8NS+Y
        UPxkEUnUHkkyOOATtO61OqF9dorM8vLfAIWE2tZSJXxAcOLoBL8R9YJKUnxSArGl
        Gt0c/6c9F7NBLUBzS4kVR+fD6V5M5PqQLntBRLHCcWOOFoqNImXkd69vFEVD4Bi3
        I0QmUEQ6YT4wZSaMyWSHR9GKtTPG8jnz3nNhmW9UMIQBz9r2LQ8UgaFzRVxlQUJN
        N8R1juRzoCtUSA==
X-ME-Sender: <xms:AVbKXbMWiUKRhLPEYtVOysb6hK96_3ZnI2vaCIGniKirRilBm_WTXA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedufedruddvkedggeehucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgjfhgggfestdekre
    dtredttdenucfhrhhomhepkfguohcuufgthhhimhhmvghluceoihguohhstghhsehiugho
    shgthhdrohhrgheqnecukfhppeduleefrdegjedrudeihedrvdehudenucfrrghrrghmpe
    hmrghilhhfrhhomhepihguohhstghhsehiughoshgthhdrohhrghenucevlhhushhtvghr
    ufhiiigvpeef
X-ME-Proxy: <xmx:AVbKXZOERdr1kLriVjR4p5vZiDzYT7vLqRhUE6CFOat3phfUvfn33g>
    <xmx:AVbKXTsIBP8FtGyWkjFxevw9975dF5aDtsbmfvC4Jsa6lkhkZclfNA>
    <xmx:AVbKXbX-4V4TVcGKugyTV-AYqBRKrZ5lOsuhnDjJwV_kwVE1k2TTPQ>
    <xmx:AVbKXYGbgM_gTFCtywOewl72C6UTgpTehDFny6voB7BXI-a9OMkmIg>
Received: from splinter.mtl.com (unknown [193.47.165.251])
        by mail.messagingengine.com (Postfix) with ESMTPA id A74D580060;
        Tue, 12 Nov 2019 01:49:35 -0500 (EST)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, jiri@mellanox.com, shalomt@mellanox.com,
        jakub.kicinski@netronome.com, mlxsw@mellanox.com,
        Ido Schimmel <idosch@mellanox.com>
Subject: [PATCH net-next v2 5/7] mlxsw: core: Extend EMAD information reported to devlink hwerr
Date:   Tue, 12 Nov 2019 08:48:28 +0200
Message-Id: <20191112064830.27002-6-idosch@idosch.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20191112064830.27002-1-idosch@idosch.org>
References: <20191112064830.27002-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Shalom Toledo <shalomt@mellanox.com>

Extend EMAD information reported to devlink hwerr tracepoint with
transaction id and reg id (both, hex and string).

Signed-off-by: Shalom Toledo <shalomt@mellanox.com>
Acked-by: Jiri Pirko <jiri@mellanox.com>
Signed-off-by: Ido Schimmel <idosch@mellanox.com>
---
 drivers/net/ethernet/mellanox/mlxsw/core.c | 12 ++++++++++--
 1 file changed, 10 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/core.c b/drivers/net/ethernet/mellanox/mlxsw/core.c
index d834bdc632ef..d6a10727d4e6 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/core.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/core.c
@@ -1683,8 +1683,11 @@ int mlxsw_reg_trans_write(struct mlxsw_core *mlxsw_core,
 }
 EXPORT_SYMBOL(mlxsw_reg_trans_write);
 
+#define MLXSW_REG_TRANS_ERR_STRING_SIZE	256
+
 static int mlxsw_reg_trans_wait(struct mlxsw_reg_trans *trans)
 {
+	char err_string[MLXSW_REG_TRANS_ERR_STRING_SIZE];
 	struct mlxsw_core *mlxsw_core = trans->core;
 	int err;
 
@@ -1702,9 +1705,14 @@ static int mlxsw_reg_trans_wait(struct mlxsw_reg_trans *trans)
 			mlxsw_core_reg_access_type_str(trans->type),
 			trans->emad_status,
 			mlxsw_emad_op_tlv_status_str(trans->emad_status));
+
+		snprintf(err_string, MLXSW_REG_TRANS_ERR_STRING_SIZE,
+			 "(tid=%llx,reg_id=%x(%s)) %s\n", trans->tid,
+			 trans->reg->id, mlxsw_reg_id_str(trans->reg->id),
+			 mlxsw_emad_op_tlv_status_str(trans->emad_status));
+
 		trace_devlink_hwerr(priv_to_devlink(mlxsw_core),
-				    trans->emad_status,
-				    mlxsw_emad_op_tlv_status_str(trans->emad_status));
+				    trans->emad_status, err_string);
 	}
 
 	list_del(&trans->bulk_list);
-- 
2.21.0


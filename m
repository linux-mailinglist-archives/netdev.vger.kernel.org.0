Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 44485EACBC
	for <lists+netdev@lfdr.de>; Thu, 31 Oct 2019 10:43:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727312AbfJaJnC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 31 Oct 2019 05:43:02 -0400
Received: from out2-smtp.messagingengine.com ([66.111.4.26]:43717 "EHLO
        out2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727308AbfJaJnB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 31 Oct 2019 05:43:01 -0400
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.nyi.internal (Postfix) with ESMTP id CA93F21FBC;
        Thu, 31 Oct 2019 05:43:00 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute3.internal (MEProxy); Thu, 31 Oct 2019 05:43:00 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm1; bh=F0JjFYDaMIhE+96IXBrF5BNy3hQORan7qxgBZ6sftj4=; b=B+GTwnaD
        i4lG3f8LHWPlZNy1VHrbkA/hvdx1zpA6zbiAhIf2SMnIL1Fs8GgWDo9xuFNtVflF
        n0g41dkl7Aevpk/wbKYeP8fMQkYTlDGbpRto4EeTQUa+Rh73vRUxRevLffRPOZMp
        y6M/RADW08BMb7CGRtC+VJXSgF36+FhygES/YBqdnyFYVrq2MmOKKhBEKCNzoBA4
        gDr3X3mRHrob2t4JgPgqFV2yQRbEE6VGjlhyiRN3ovb2gQvFGdykpKVjaBi4IpQP
        3BRY0Fh0471I9KzcsDg863PhXWc6R/XvwS0pLOkjY0Am49h5r3su4B37LOlC7e50
        9vYFSm+u11vnJw==
X-ME-Sender: <xms:pKy6XWrUrQ1gOmI5qiHGWWL923H9wgyMbbezZy9sfUG84FKchrRAfw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedufedruddthedgtdehucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgjfhgggfestdekre
    dtredttdenucfhrhhomhepkfguohcuufgthhhimhhmvghluceoihguohhstghhsehiugho
    shgthhdrohhrgheqnecukfhppeduleefrdegjedrudeihedrvdehudenucfrrghrrghmpe
    hmrghilhhfrhhomhepihguohhstghhsehiughoshgthhdrohhrghenucevlhhushhtvghr
    ufhiiigvpedutd
X-ME-Proxy: <xmx:pKy6XY6it17U2j8R10xlw5_366OQo03lF8kMr-KCFEbXFECrvG4fog>
    <xmx:pKy6XWO3zhAnyWgoW4PMS3RKtKEGfFDDEd97p7iiAST1kzlE8w3_Zg>
    <xmx:pKy6XaMQCtkzWZNPXW68FBOPLF6S83eFlcUP6KtoTOjjuk87L_FkPg>
    <xmx:pKy6XX5SgxTRBybr31ttC7n6paku6bL9VcjFKZINAbzWBsGWKQe-_A>
Received: from localhost.localdomain (unknown [193.47.165.251])
        by mail.messagingengine.com (Postfix) with ESMTPA id E10CA80064;
        Thu, 31 Oct 2019 05:42:58 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, jiri@mellanox.com, mlxsw@mellanox.com,
        Ido Schimmel <idosch@mellanox.com>
Subject: [PATCH net-next 11/16] mlxsw: spectrum: Introduce resource for getting offset of 4 lanes split port
Date:   Thu, 31 Oct 2019 11:42:16 +0200
Message-Id: <20191031094221.17526-12-idosch@idosch.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20191031094221.17526-1-idosch@idosch.org>
References: <20191031094221.17526-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jiri Pirko <jiri@mellanox.com>

In Spectrum-3 the modules have 8 lanes, so split by count 2 results in
two split ports each of 4 lanes. Add a resource that can be used to
obtain local port offset in that case.

Signed-off-by: Jiri Pirko <jiri@mellanox.com>
Signed-off-by: Ido Schimmel <idosch@mellanox.com>
---
 drivers/net/ethernet/mellanox/mlxsw/resources.h | 2 ++
 drivers/net/ethernet/mellanox/mlxsw/spectrum.c  | 2 ++
 2 files changed, 4 insertions(+)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/resources.h b/drivers/net/ethernet/mellanox/mlxsw/resources.h
index 85f919fe851b..6534184cb942 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/resources.h
+++ b/drivers/net/ethernet/mellanox/mlxsw/resources.h
@@ -26,6 +26,7 @@ enum mlxsw_res_id {
 	MLXSW_RES_ID_MAX_LAG_MEMBERS,
 	MLXSW_RES_ID_LOCAL_PORTS_IN_1X,
 	MLXSW_RES_ID_LOCAL_PORTS_IN_2X,
+	MLXSW_RES_ID_LOCAL_PORTS_IN_4X,
 	MLXSW_RES_ID_GUARANTEED_SHARED_BUFFER,
 	MLXSW_RES_ID_CELL_SIZE,
 	MLXSW_RES_ID_MAX_HEADROOM_SIZE,
@@ -82,6 +83,7 @@ static u16 mlxsw_res_ids[] = {
 	[MLXSW_RES_ID_MAX_LAG_MEMBERS] = 0x2521,
 	[MLXSW_RES_ID_LOCAL_PORTS_IN_1X] = 0x2610,
 	[MLXSW_RES_ID_LOCAL_PORTS_IN_2X] = 0x2611,
+	[MLXSW_RES_ID_LOCAL_PORTS_IN_4X] = 0x2612,
 	[MLXSW_RES_ID_GUARANTEED_SHARED_BUFFER] = 0x2805,	/* Bytes */
 	[MLXSW_RES_ID_CELL_SIZE] = 0x2803,	/* Bytes */
 	[MLXSW_RES_ID_MAX_HEADROOM_SIZE] = 0x2811,	/* Bytes */
diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum.c
index 39ea408deec1..d336e54d7a76 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum.c
@@ -4165,6 +4165,8 @@ static int mlxsw_sp_local_ports_offset(struct mlxsw_core *mlxsw_core,
 		local_ports_in_x_res_id = MLXSW_RES_ID_LOCAL_PORTS_IN_1X;
 	else if (split_width == 2)
 		local_ports_in_x_res_id = MLXSW_RES_ID_LOCAL_PORTS_IN_2X;
+	else if (split_width == 4)
+		local_ports_in_x_res_id = MLXSW_RES_ID_LOCAL_PORTS_IN_4X;
 	else
 		return -EINVAL;
 
-- 
2.21.0


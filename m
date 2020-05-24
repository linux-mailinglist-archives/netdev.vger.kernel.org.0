Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7456B1E0374
	for <lists+netdev@lfdr.de>; Sun, 24 May 2020 23:51:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388456AbgEXVvb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 24 May 2020 17:51:31 -0400
Received: from out4-smtp.messagingengine.com ([66.111.4.28]:48397 "EHLO
        out4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2387970AbgEXVva (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 24 May 2020 17:51:30 -0400
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailout.nyi.internal (Postfix) with ESMTP id 6A71E5C00A2;
        Sun, 24 May 2020 17:51:29 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute4.internal (MEProxy); Sun, 24 May 2020 17:51:29 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm2; bh=tuE9CHqcTp7RO7gIZt1QC+gWJ8BYLY4qJ8BmEJwXw3A=; b=eNIxobVD
        QQ8SYbwDaD4iM8NU70djf4A9cTSBsyT0KsgfPSTkDr5fl7cpDigU2Rv1h6pkzynv
        OYBKKuu5Bw7kwE+Aq9aGdWEw47UdhSVCLp8TeuxDSPDg6AOgZiPtJ/F/j4Oyx9qM
        2M4tMNhs0ZFTFwogqAlN3w7aSK/uHuaIhOVJ9wBdQROSVs85pLfTbBEHWSpigpHQ
        0Y8IsPp0fs153AXt9yVpi1WStVviD35YrivqCxTN3wMmLZNJJAnODTBEC6AV7PQ1
        vEohfBPps5vno+uFVN13QK60aW5qZbEaIFONpvU488FZ9mteb+Twn+I4+mDmUDOP
        D+En3lk28YwzgA==
X-ME-Sender: <xms:YezKXp1JfcB-tZ-qU8k6J2Ai0Me_QAwfIDYX5hDElVf30kvjRYKoxQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduhedrudduledgtdefucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgjfhgggfestdekre
    dtredttdenucfhrhhomhepkfguohcuufgthhhimhhmvghluceoihguohhstghhsehiugho
    shgthhdrohhrgheqnecuggftrfgrthhtvghrnhepudetieevffffveelkeeljeffkefhke
    ehgfdtffethfelvdejgffghefgveejkefhnecukfhppeejledrudejiedrvdegrddutdej
    necuvehluhhsthgvrhfuihiivgepvdenucfrrghrrghmpehmrghilhhfrhhomhepihguoh
    hstghhsehiughoshgthhdrohhrgh
X-ME-Proxy: <xmx:YezKXgGCLdDV4gyYYTLGuX_sOgdGbJTeSHBdoZnj0Yn1s3icQGVNHA>
    <xmx:YezKXp6YeTSa5DoM4sVqGePuyAYbkmmUfqjxYMj8rHKxQvgFhMspwQ>
    <xmx:YezKXm1bb5E5WLl-iaba19131o2jRopuxYpnsyruKRdCfvVLcBai4Q>
    <xmx:YezKXmOHO-6l3LWTohTq2JbPwCDpVtQaqGEzgrctEbNmr4WA0g-VDg>
Received: from splinter.mtl.com (bzq-79-176-24-107.red.bezeqint.net [79.176.24.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id 21B57306651E;
        Sun, 24 May 2020 17:51:27 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, jiri@mellanox.com,
        mlxsw@mellanox.com, Ido Schimmel <idosch@mellanox.com>
Subject: [PATCH net-next 04/11] mlxsw: spectrum: Change default rate and priority of DHCP packets
Date:   Mon, 25 May 2020 00:51:00 +0300
Message-Id: <20200524215107.1315526-5-idosch@idosch.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200524215107.1315526-1-idosch@idosch.org>
References: <20200524215107.1315526-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ido Schimmel <idosch@mellanox.com>

Reduce the default acceptable rate of DHCP packets to 128 packets per
second and reduce their priority. This is reasonable given the Spectrum
ASICs are limited to 128 ports at the moment.

These are only the default values. Users will be able to modify them via
devlink-trap.

Signed-off-by: Ido Schimmel <idosch@mellanox.com>
Reviewed-by: Jiri Pirko <jiri@mellanox.com>
---
 drivers/net/ethernet/mellanox/mlxsw/spectrum.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum.c
index fa6e630abb6e..c2d6890803da 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum.c
@@ -4152,6 +4152,7 @@ static int mlxsw_sp_cpu_policers_set(struct mlxsw_core *mlxsw_core)
 		case MLXSW_REG_HTGT_TRAP_GROUP_SP_OSPF:
 		case MLXSW_REG_HTGT_TRAP_GROUP_SP_PIM:
 		case MLXSW_REG_HTGT_TRAP_GROUP_SP_LBERROR:
+		case MLXSW_REG_HTGT_TRAP_GROUP_SP_DHCP:
 			rate = 128;
 			burst_size = 7;
 			break;
@@ -4161,7 +4162,6 @@ static int mlxsw_sp_cpu_policers_set(struct mlxsw_core *mlxsw_core)
 			break;
 		case MLXSW_REG_HTGT_TRAP_GROUP_SP_BGP:
 		case MLXSW_REG_HTGT_TRAP_GROUP_SP_ARP:
-		case MLXSW_REG_HTGT_TRAP_GROUP_SP_DHCP:
 		case MLXSW_REG_HTGT_TRAP_GROUP_SP_ROUTER_EXP:
 		case MLXSW_REG_HTGT_TRAP_GROUP_SP_REMOTE_ROUTE:
 		case MLXSW_REG_HTGT_TRAP_GROUP_SP_IPV6_ND:
@@ -4230,7 +4230,6 @@ static int mlxsw_sp_trap_groups_set(struct mlxsw_core *mlxsw_core)
 			tc = 5;
 			break;
 		case MLXSW_REG_HTGT_TRAP_GROUP_SP_BGP:
-		case MLXSW_REG_HTGT_TRAP_GROUP_SP_DHCP:
 			priority = 4;
 			tc = 4;
 			break;
@@ -4242,6 +4241,7 @@ static int mlxsw_sp_trap_groups_set(struct mlxsw_core *mlxsw_core)
 		case MLXSW_REG_HTGT_TRAP_GROUP_SP_ARP:
 		case MLXSW_REG_HTGT_TRAP_GROUP_SP_IPV6_ND:
 		case MLXSW_REG_HTGT_TRAP_GROUP_SP_PTP1:
+		case MLXSW_REG_HTGT_TRAP_GROUP_SP_DHCP:
 			priority = 2;
 			tc = 2;
 			break;
-- 
2.26.2


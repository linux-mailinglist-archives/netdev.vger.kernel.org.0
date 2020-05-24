Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9E2721E0378
	for <lists+netdev@lfdr.de>; Sun, 24 May 2020 23:51:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388510AbgEXVvj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 24 May 2020 17:51:39 -0400
Received: from out4-smtp.messagingengine.com ([66.111.4.28]:48321 "EHLO
        out4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2387970AbgEXVvh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 24 May 2020 17:51:37 -0400
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailout.nyi.internal (Postfix) with ESMTP id 617E15C009F;
        Sun, 24 May 2020 17:51:36 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute4.internal (MEProxy); Sun, 24 May 2020 17:51:36 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm2; bh=MhvmC18JOHliAVPbb5j9xZKLmYyR7+pyQGyc6C171yE=; b=KtBk5DbN
        fpOTq+3nabX8tgax3ecYZRoKpITdVAj6P2QERhk3APoaa5tO7ozJygy7NMvuWD8G
        OoOyVh0qGR4/hXWysM2nDQnZ88pVToFJX308Y37IGF2+huB/QYlCpJGj6rPNcawB
        Q5vHn6hbFCKvqhZSb5JTAzHHIjqNeru25waQWinHZtKrrEdskwgq+m5Oaxl+unOA
        rrS4VWapAG1H2gZDji2NYGPGnpdtZAdLjkKSyPq/BPmnXXe6XBxENw+5ROIqizwU
        HIwQfHLATpeZMRGkRDzmbUs8CVgShpDCx2MNM/tatz/gnqjlUAiw2NeUgEoGN2kn
        oaSo5jKdsff0Yg==
X-ME-Sender: <xms:aOzKXgUWlf7rzHW8lALLn13orF5aVQr8sULh3yIu8RrIlUR-4ohjfA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduhedrudduledgtdefucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgjfhgggfestdekre
    dtredttdenucfhrhhomhepkfguohcuufgthhhimhhmvghluceoihguohhstghhsehiugho
    shgthhdrohhrgheqnecuggftrfgrthhtvghrnhepudetieevffffveelkeeljeffkefhke
    ehgfdtffethfelvdejgffghefgveejkefhnecukfhppeejledrudejiedrvdegrddutdej
    necuvehluhhsthgvrhfuihiivgepieenucfrrghrrghmpehmrghilhhfrhhomhepihguoh
    hstghhsehiughoshgthhdrohhrgh
X-ME-Proxy: <xmx:aOzKXkn61EH_eEtvW4JL9tYEbb_s_iEtmBdyM2UtHxhhfPXfribrHg>
    <xmx:aOzKXkZ_OGFSmpUwJHJYSaykAANt8eNGjhjUnTC36-VJ9XTGMrKKsg>
    <xmx:aOzKXvWA0nRHXy4iE8dunCkhcoXWX_TgXxEFqAGqL1yi-kSwww0Z2g>
    <xmx:aOzKXuvV-raVqP8SlPgaYh6VDDu_pAy1RV7KdBeI1T7uDn2-3x3PDQ>
Received: from splinter.mtl.com (bzq-79-176-24-107.red.bezeqint.net [79.176.24.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id 1882A306651E;
        Sun, 24 May 2020 17:51:34 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, jiri@mellanox.com,
        mlxsw@mellanox.com, Ido Schimmel <idosch@mellanox.com>
Subject: [PATCH net-next 09/11] mlxsw: spectrum: Use same trap group for IPv6 ND and ARP packets
Date:   Mon, 25 May 2020 00:51:05 +0300
Message-Id: <20200524215107.1315526-10-idosch@idosch.org>
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

Both packet types are needed for the same reason (neighbour discovery),
so associate them with the same trap group.

Signed-off-by: Ido Schimmel <idosch@mellanox.com>
Reviewed-by: Jiri Pirko <jiri@mellanox.com>
---
 drivers/net/ethernet/mellanox/mlxsw/spectrum.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum.c
index 6ef8222cc0ae..c4fdfe8fd5a3 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum.c
@@ -4082,10 +4082,10 @@ static const struct mlxsw_listener mlxsw_sp_listener[] = {
 			  false),
 	MLXSW_SP_RXL_MARK(L3_IPV6_ROUTER_ADVERTISMENT, TRAP_TO_CPU, IPV6_ND,
 			  false),
-	MLXSW_SP_RXL_MARK(L3_IPV6_NEIGHBOR_SOLICITATION, TRAP_TO_CPU, IPV6_ND,
-			  false),
-	MLXSW_SP_RXL_MARK(L3_IPV6_NEIGHBOR_ADVERTISMENT, TRAP_TO_CPU, IPV6_ND,
-			  false),
+	MLXSW_SP_RXL_MARK(L3_IPV6_NEIGHBOR_SOLICITATION, TRAP_TO_CPU,
+			  NEIGH_DISCOVERY, false),
+	MLXSW_SP_RXL_MARK(L3_IPV6_NEIGHBOR_ADVERTISMENT, TRAP_TO_CPU,
+			  NEIGH_DISCOVERY, false),
 	MLXSW_SP_RXL_MARK(L3_IPV6_REDIRECTION, TRAP_TO_CPU, IPV6_ND, false),
 	MLXSW_SP_RXL_MARK(IPV6_MC_LINK_LOCAL_DEST, TRAP_TO_CPU, ROUTER_EXP,
 			  false),
-- 
2.26.2


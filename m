Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A6C101E1814
	for <lists+netdev@lfdr.de>; Tue, 26 May 2020 01:06:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388907AbgEYXGa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 May 2020 19:06:30 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:60993 "EHLO
        out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2388814AbgEYXG0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 May 2020 19:06:26 -0400
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailout.nyi.internal (Postfix) with ESMTP id 0AF355C0114;
        Mon, 25 May 2020 19:06:25 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute4.internal (MEProxy); Mon, 25 May 2020 19:06:25 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm2; bh=ovdVJ3DnFnnUVCXdsbvYvzHQwGNexuSQNW/dThWWH5Q=; b=dKCwLw1S
        A0RIogxEx4EhOZS4JoF73No9z2SURhzpn9x8QxBzhWst3xCIuR/yquEOQJbmSuF3
        HnOwLfWt8aNwSf4qW7hJ7DpZW9EcH8yaDCQCAxoV13UBLGMRCwxnL9krrg0DI2Qa
        2ynn7jf73e6cabj6x58u38NWqzDeY3qOseIyZ0bgWjb+m+K1iA8OGlRDg9KV879Y
        KscNTDFIfHH5EiexNs8ilbeUQ6mW3dKoykQUWKUvHb4W2+we3FJnlCrq1oOElS2Z
        uKVf9mjq4a2wcRoWD2WVU6lTAwVFwB6VPPykqDi9lbO+fY94zwqLz5nrSNt3vSa0
        mYDBTKet7VJCOA==
X-ME-Sender: <xms:cE_MXiyPal4iVLAWR_EkfVzC4-Mvr6X7pXHd85cvaDczbUY7UuD5YA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduhedruddvuddgudejucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgjfhgggfestdekre
    dtredttdenucfhrhhomhepkfguohcuufgthhhimhhmvghluceoihguohhstghhsehiugho
    shgthhdrohhrgheqnecuggftrfgrthhtvghrnhepudetieevffffveelkeeljeffkefhke
    ehgfdtffethfelvdejgffghefgveejkefhnecukfhppeejledrudejiedrvdegrddutdej
    necuvehluhhsthgvrhfuihiivgepgeenucfrrghrrghmpehmrghilhhfrhhomhepihguoh
    hstghhsehiughoshgthhdrohhrgh
X-ME-Proxy: <xmx:cE_MXuSZhlyxmW-f1skglDMHMH9_PPy4TZUgfaM5sLlMOoDwWOLbzA>
    <xmx:cE_MXkW2IuEITZEDzO_6BLJ4zaQoCpjUAx21daLmIFTaE4uDvqgBMA>
    <xmx:cE_MXogFCS41qZ2aTRFVmEPoDnc-XMIaVSJlq1Xsqd59kwek25q1bA>
    <xmx:cU_MXt45mOkTD3j3dLxm6XvXvlXH1klOfoawV27yIBiuUvNEHT8AWQ>
Received: from splinter.mtl.com (bzq-79-176-24-107.red.bezeqint.net [79.176.24.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id BA1AA3280059;
        Mon, 25 May 2020 19:06:23 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, jiri@mellanox.com,
        mlxsw@mellanox.com, Ido Schimmel <idosch@mellanox.com>
Subject: [PATCH net-next 07/14] mlxsw: spectrum: Reduce priority of locally delivered packets
Date:   Tue, 26 May 2020 02:05:49 +0300
Message-Id: <20200525230556.1455927-8-idosch@idosch.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200525230556.1455927-1-idosch@idosch.org>
References: <20200525230556.1455927-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ido Schimmel <idosch@mellanox.com>

To align with recent recommended values. Will be configurable by future
patches.

Signed-off-by: Ido Schimmel <idosch@mellanox.com>
Reviewed-by: Jiri Pirko <jiri@mellanox.com>
---
 drivers/net/ethernet/mellanox/mlxsw/spectrum.c            | 2 +-
 tools/testing/selftests/drivers/net/mlxsw/sharedbuffer.sh | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum.c
index 5fe51ee8a206..b10e5aeaedef 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum.c
@@ -4235,11 +4235,11 @@ static int mlxsw_sp_trap_groups_set(struct mlxsw_core *mlxsw_core)
 			tc = 4;
 			break;
 		case MLXSW_REG_HTGT_TRAP_GROUP_SP_MC_SNOOPING:
-		case MLXSW_REG_HTGT_TRAP_GROUP_SP_IP2ME:
 			priority = 3;
 			tc = 3;
 			break;
 		case MLXSW_REG_HTGT_TRAP_GROUP_SP_NEIGH_DISCOVERY:
+		case MLXSW_REG_HTGT_TRAP_GROUP_SP_IP2ME:
 		case MLXSW_REG_HTGT_TRAP_GROUP_SP_IPV6:
 		case MLXSW_REG_HTGT_TRAP_GROUP_SP_PTP1:
 		case MLXSW_REG_HTGT_TRAP_GROUP_SP_DHCP:
diff --git a/tools/testing/selftests/drivers/net/mlxsw/sharedbuffer.sh b/tools/testing/selftests/drivers/net/mlxsw/sharedbuffer.sh
index 58f3a05f08af..7d9e73a43a49 100755
--- a/tools/testing/selftests/drivers/net/mlxsw/sharedbuffer.sh
+++ b/tools/testing/selftests/drivers/net/mlxsw/sharedbuffer.sh
@@ -15,7 +15,7 @@ source mlxsw_lib.sh
 SB_POOL_ING=0
 SB_POOL_EGR_CPU=10
 
-SB_ITC_CPU_IP=3
+SB_ITC_CPU_IP=2
 SB_ITC_CPU_ARP=2
 SB_ITC=0
 
-- 
2.26.2


Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D202C40C373
	for <lists+netdev@lfdr.de>; Wed, 15 Sep 2021 12:13:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237480AbhIOKPE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Sep 2021 06:15:04 -0400
Received: from out4-smtp.messagingengine.com ([66.111.4.28]:37365 "EHLO
        out4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S237418AbhIOKO5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Sep 2021 06:14:57 -0400
Received: from compute5.internal (compute5.nyi.internal [10.202.2.45])
        by mailout.nyi.internal (Postfix) with ESMTP id E42205C0199;
        Wed, 15 Sep 2021 06:13:38 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute5.internal (MEProxy); Wed, 15 Sep 2021 06:13:38 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm3; bh=Ve2nurOkw0fHzj/i9egAU5VjE3MOeewRzNVMGG7QMPU=; b=WMITwhEA
        drAHzy+4b0fwl1p2hWxI3Tl3rCL3/0sT7aiPmO5thHHuUqS5jnzfTCloJ1yQqEnE
        YwAt9kA1B9KVKw5iwdY9QuWzg8zOMA3xBm27HzHp2T3gS/8R7x4lJGN5Ep3VYXV4
        ROpyJ+kAxXW9fK5kk6Xv/xRR/8QT2zy6ggo7bE0zVChdgPTBd0FptDRx4f9Rx5Ga
        WlDOn5JnYsgYJBDdpzAnnUcYWkmGQ/qM3qSqPmp4vYhViWZimNu9nziFGDwABs+l
        th/ZA5CW5EByifQYzQHTA7JOPv6OIlfQjnar+QX6qzsaOI3C/lPCeLgH6GpDRNlx
        teRnH9YfK0d8xQ==
X-ME-Sender: <xms:UsdBYe9FvmZh5kTM9NUMu2T8x5hS45mwds33McJVtd4wWvJlIS_3HQ>
    <xme:UsdBYeucIrSpba-juNYLNhXZZlvBz85pPxkXovAI13HEwkv0I7evZMwJi_nODMcQf
    tFQxFCiYk5O8UY>
X-ME-Received: <xmr:UsdBYUBKvDWnXFX6PN4r4rlI0N21AFPQ52jaXPt0a4n54yFjcgOpHlwIx1RiJxGpXM2ahO1gWhLtcjCMJNSdo-GFQbYhJrEQcg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvtddrudehuddgvddvucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgjfhgggfestdekre
    dtredttdenucfhrhhomhepkfguohcuufgthhhimhhmvghluceoihguohhstghhsehiugho
    shgthhdrohhrgheqnecuggftrfgrthhtvghrnhepudetieevffffveelkeeljeffkefhke
    ehgfdtffethfelvdejgffghefgveejkefhnecuvehluhhsthgvrhfuihiivgepvdenucfr
    rghrrghmpehmrghilhhfrhhomhepihguohhstghhsehiughoshgthhdrohhrgh
X-ME-Proxy: <xmx:UsdBYWeJxEN-z7Es4LMrUvCOf7X-JKpZIngWM3AKCGCf4sLKpfQq7Q>
    <xmx:UsdBYTPPWKfjWa07LCILB17QGrCqOXrF5u2IBzLT48YodjXrpEBiAQ>
    <xmx:UsdBYQmn4sjhA5D3P3pJ2lFO1SkdDzrYrKEqdzEFSLLg5xoEQdOA9w>
    <xmx:UsdBYe1tYTjENpPfzAf4woLVIG805EFY7Dclg5e1VOD9LauYlWKisQ>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Wed,
 15 Sep 2021 06:13:37 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, andrew@lunn.ch,
        jiri@nvidia.com, vadimp@nvidia.com, mlxsw@nvidia.com,
        Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH net-next 06/10] mlxsw: spectrum: Do not return an error in mlxsw_sp_port_module_unmap()
Date:   Wed, 15 Sep 2021 13:13:10 +0300
Message-Id: <20210915101314.407476-7-idosch@idosch.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210915101314.407476-1-idosch@idosch.org>
References: <20210915101314.407476-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ido Schimmel <idosch@nvidia.com>

The return value is never checked. Allows us to simplify a later patch.

Signed-off-by: Ido Schimmel <idosch@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlxsw/spectrum.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum.c
index 976d7e1ecb14..cea411884b05 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum.c
@@ -551,13 +551,13 @@ mlxsw_sp_port_module_map(struct mlxsw_sp *mlxsw_sp, u8 local_port,
 	return mlxsw_reg_write(mlxsw_sp->core, MLXSW_REG(pmlp), pmlp_pl);
 }
 
-static int mlxsw_sp_port_module_unmap(struct mlxsw_sp *mlxsw_sp, u8 local_port)
+static void mlxsw_sp_port_module_unmap(struct mlxsw_sp *mlxsw_sp, u8 local_port)
 {
 	char pmlp_pl[MLXSW_REG_PMLP_LEN];
 
 	mlxsw_reg_pmlp_pack(pmlp_pl, local_port);
 	mlxsw_reg_pmlp_width_set(pmlp_pl, 0);
-	return mlxsw_reg_write(mlxsw_sp->core, MLXSW_REG(pmlp), pmlp_pl);
+	mlxsw_reg_write(mlxsw_sp->core, MLXSW_REG(pmlp), pmlp_pl);
 }
 
 static int mlxsw_sp_port_open(struct net_device *dev)
-- 
2.31.1


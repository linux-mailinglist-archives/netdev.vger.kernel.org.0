Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2ABFA40C372
	for <lists+netdev@lfdr.de>; Wed, 15 Sep 2021 12:13:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237536AbhIOKPD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Sep 2021 06:15:03 -0400
Received: from out4-smtp.messagingengine.com ([66.111.4.28]:43891 "EHLO
        out4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S237477AbhIOKOz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Sep 2021 06:14:55 -0400
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.nyi.internal (Postfix) with ESMTP id 0CDD55C018F;
        Wed, 15 Sep 2021 06:13:37 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute3.internal (MEProxy); Wed, 15 Sep 2021 06:13:37 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm3; bh=UawJTonJjlrR2ABNMYjMkrYDqU8IfYcMFKqjQt2HCks=; b=nSXhamHu
        rh6bANK3GFbypM1gLFr68ayamDQkMHmBErfaEF71QV47v4sNAp2hNPiKNkgqJ+2n
        Ye0Pxvlbpp6HNoNkMxvuuxPa+BuNdLTMAdBNuHGa3041aIpjOf1Rsr54eyyjkDAj
        dSBAH0vH9iiR+S5a/cEU46d8UINpi0GWT0B3IKClYc5TFQtCYm7wFNyXFdL8q2pc
        9166ZjzQFBS2t9+fdUcNBLE2z0YtCBO2kLmkqQ9YI6MUs1TQ8PCvEbYp+F3m1cf7
        id1Kvf4uD34ia58o8Fi1E7coOTo4dnb7+2VXCGSWu7rQULuDRlkviubhCnx8Gi+G
        GsqP6DEdBhBjsg==
X-ME-Sender: <xms:UMdBYer11Q5qLe-4d92h66cYqM8NK0Pbl39gL_7JVtCET7ZpgitsdA>
    <xme:UMdBYcoMuHOekNYmB2j6x1nMXknr59AM0o9S51C3V9nnZoWm1okgsfuF9xPU1ryOW
    Auy9OdUBfHr-M8>
X-ME-Received: <xmr:UMdBYTNGc46SnMKMLIV1ot6eVrLBHoAkm2jPQFUj7Ie3b0YN7gfe7lDMlYu0_bbEVNKVtf4ANxLQX0-MY-k8MObHb9DsYmW9Ng>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvtddrudehuddgvddvucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgjfhgggfestdekre
    dtredttdenucfhrhhomhepkfguohcuufgthhhimhhmvghluceoihguohhstghhsehiugho
    shgthhdrohhrgheqnecuggftrfgrthhtvghrnhepudetieevffffveelkeeljeffkefhke
    ehgfdtffethfelvdejgffghefgveejkefhnecuvehluhhsthgvrhfuihiivgepudenucfr
    rghrrghmpehmrghilhhfrhhomhepihguohhstghhsehiughoshgthhdrohhrgh
X-ME-Proxy: <xmx:UMdBYd4hDm6MFFwj918I_Y4Lqy_f7UtHcNntmQEplsOjAWB74owMvg>
    <xmx:UMdBYd6jXYct95voYkuBQ3ajT-JW99Xd_fppKleGINdNUp6OsU2_ZA>
    <xmx:UMdBYdjVptku7RjrK93aNjpJZMSgdy8JJpJgSJHgW8APXmhJYosHFw>
    <xmx:UcdBYbRMYH7qJymIkCmeuVFvNjc0Xt30W6hwW54dCMJGDT2HCtlyiQ>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Wed,
 15 Sep 2021 06:13:35 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, andrew@lunn.ch,
        jiri@nvidia.com, vadimp@nvidia.com, mlxsw@nvidia.com,
        Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH net-next 05/10] mlxsw: spectrum: Do not return an error in ndo_stop()
Date:   Wed, 15 Sep 2021 13:13:09 +0300
Message-Id: <20210915101314.407476-6-idosch@idosch.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210915101314.407476-1-idosch@idosch.org>
References: <20210915101314.407476-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ido Schimmel <idosch@nvidia.com>

The return value is not checked by the networking stack. Allows us to
simplify a later patch.

Signed-off-by: Ido Schimmel <idosch@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlxsw/spectrum.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum.c
index 9cbc893c2545..976d7e1ecb14 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum.c
@@ -577,7 +577,8 @@ static int mlxsw_sp_port_stop(struct net_device *dev)
 	struct mlxsw_sp_port *mlxsw_sp_port = netdev_priv(dev);
 
 	netif_stop_queue(dev);
-	return mlxsw_sp_port_admin_status_set(mlxsw_sp_port, false);
+	mlxsw_sp_port_admin_status_set(mlxsw_sp_port, false);
+	return 0;
 }
 
 static netdev_tx_t mlxsw_sp_port_xmit(struct sk_buff *skb,
-- 
2.31.1


Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5E1F442BD33
	for <lists+netdev@lfdr.de>; Wed, 13 Oct 2021 12:38:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229524AbhJMKk3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Oct 2021 06:40:29 -0400
Received: from out2-smtp.messagingengine.com ([66.111.4.26]:38825 "EHLO
        out2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229604AbhJMKk1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 Oct 2021 06:40:27 -0400
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailout.nyi.internal (Postfix) with ESMTP id 6EFB45C018D;
        Wed, 13 Oct 2021 06:38:24 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute4.internal (MEProxy); Wed, 13 Oct 2021 06:38:24 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm1; bh=DIwRxjbxYFKlh5Bws9ypKpKP52puicmA/KIiFSlUmsI=; b=PVXIKkoJ
        oTx9LNim4hN2CHw6wU2o8gKKYbVG1WKVCBiLpvTsl8LsCss8vNlKuu/fJYCrXL9b
        AWW+P1i6LkrUlKU5zfXt7nVkZWhabVGslJHsetQ/OmnFmg43v5U4+qHOn7O68HzN
        39yc4VEkWocjQf0ZaX3at2fvtCcWvYOlU/AKOMtM6HCbnzHBD6u/Uhz4wUbB2jz+
        cFWuGAvit4sQLcM+FAdlu7zV1URDfUI+UTQceZsyipyvmPxPPT5gzlABTIC+xbRv
        9lXUsASceeIOnbwJU5Ui/ZcqWmoee5wjk8VcuEQlPwN5Fn5NJu+b4sZDFJR0SlnS
        YPqGiF2NIoFTZg==
X-ME-Sender: <xms:ILdmYZY_pJobqH7A0ON3FMfjkweYZSJ0MtHswHn-gNt9Y24TaU68Yw>
    <xme:ILdmYQbzTWPzwMwsRyFY3RKJFOAECaxGomIsZ92XR7LRM3T1uN3i564ypXncZwHiJ
    WcZP9jRA81myxA>
X-ME-Received: <xmr:ILdmYb81cIWRfvG3qohctZprDiKI1FXRWlucrNH9Lz8MJHxy_cGkzXtfyAUJ1cZbE2FwLrYgXMxeEBjNQ6Lq5MbjO3ZTV4J5tPjjdtdXEfcagQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvtddrvddutddgvdekucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgjfhgggfestdekre
    dtredttdenucfhrhhomhepkfguohcuufgthhhimhhmvghluceoihguohhstghhsehiugho
    shgthhdrohhrgheqnecuggftrfgrthhtvghrnhepudetieevffffveelkeeljeffkefhke
    ehgfdtffethfelvdejgffghefgveejkefhnecuvehluhhsthgvrhfuihiivgepudenucfr
    rghrrghmpehmrghilhhfrhhomhepihguohhstghhsehiughoshgthhdrohhrgh
X-ME-Proxy: <xmx:ILdmYXroBxQ1YXBuCiC_vGm5C3wPxPn42hx6CtI7wL2_D8OZABJlgw>
    <xmx:ILdmYUpc9_rqEUUi_BGp6pQNVNP_qy3ORbCxYHldq7B0vnRgnhrnZQ>
    <xmx:ILdmYdRjW9ks7XP_9SGKtaLh_xbojqw1v0jo44o3IOeP7mukSJdbow>
    <xmx:ILdmYdno7xeR2p9K9Q6wGpWtZ2T-oaq8_PQSsRTpyE3uUOjNtANSSQ>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Wed,
 13 Oct 2021 06:38:22 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, jiri@nvidia.com,
        petrm@nvidia.com, mlxsw@nvidia.com,
        Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH net-next 3/5] mlxsw: reg: Add ecn_marked_tc to Per-TC Congestion Counters
Date:   Wed, 13 Oct 2021 13:37:46 +0300
Message-Id: <20211013103748.492531-4-idosch@idosch.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211013103748.492531-1-idosch@idosch.org>
References: <20211013103748.492531-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Petr Machata <petrm@nvidia.com>

The PPCNT register retrieves per port performance counters. The
ecn_marked_tc field in per-TC Congestion counter group contains a count of
packets marked as ECN or potentially marked as ECN.

Signed-off-by: Petr Machata <petrm@nvidia.com>
Signed-off-by: Ido Schimmel <idosch@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlxsw/reg.h | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/reg.h b/drivers/net/ethernet/mellanox/mlxsw/reg.h
index 2f8c0c6d66e0..48b817ba6d4e 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/reg.h
+++ b/drivers/net/ethernet/mellanox/mlxsw/reg.h
@@ -5398,6 +5398,12 @@ MLXSW_ITEM64(reg, ppcnt, tc_no_buffer_discard_uc,
 MLXSW_ITEM64(reg, ppcnt, wred_discard,
 	     MLXSW_REG_PPCNT_COUNTERS_OFFSET + 0x00, 0, 64);
 
+/* reg_ppcnt_ecn_marked_tc
+ * Access: RO
+ */
+MLXSW_ITEM64(reg, ppcnt, ecn_marked_tc,
+	     MLXSW_REG_PPCNT_COUNTERS_OFFSET + 0x08, 0, 64);
+
 static inline void mlxsw_reg_ppcnt_pack(char *payload, u8 local_port,
 					enum mlxsw_reg_ppcnt_grp grp,
 					u8 prio_tc)
-- 
2.31.1


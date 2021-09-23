Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 11E10415E7A
	for <lists+netdev@lfdr.de>; Thu, 23 Sep 2021 14:38:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241031AbhIWMjr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Sep 2021 08:39:47 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:49033 "EHLO
        out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S241015AbhIWMjl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Sep 2021 08:39:41 -0400
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailout.nyi.internal (Postfix) with ESMTP id 325745C009B;
        Thu, 23 Sep 2021 08:38:10 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute1.internal (MEProxy); Thu, 23 Sep 2021 08:38:10 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm3; bh=RJKoKDBS2+gSgDjKrNZhLGPJEFmH4217antK37N29p8=; b=hg4G8KEc
        3yLyRpYNoHg6VWCqKR/kwbgMf6MI5ZsExPBzly6MQN16Sd+Ar+Co1OnoVuTHGNvn
        fEGuh08Mt/Z6MUeK2XJSDO2yfJ5ev34hmKI9GZK9teGHGXdQbrwRFM7+le1lg/Hu
        tl5I3uH/PtI8KZb4Qnkfg9wQ74S9W+z4uxAECIMa4WOYop7lJLD5OE/gA8DVLkTx
        j7Gkts3JkfTqJ2IyCOELbhAIkq5ov9+kM+loc0tNr0c6WkxgfkNlLpRbLj8O3aU2
        07pD/8P67e0i1zwWeqwehLl0AKPl+9yPcLIrkrM+Hc6HjcfC39PHefOBa4dN/FRf
        +Q2TG98/R+uGbg==
X-ME-Sender: <xms:MnVMYSCBFW6nsxecRlqgATxSlN0-hAEw5osvAKFSA343wEsx_kS0TA>
    <xme:MnVMYcjWoELv-0-ZgUkfNWcz3_3aVj5liuBLXAIayxU6rhN6RGp19r3064KNd8P2r
    S-7F54W1SDmm0w>
X-ME-Received: <xmr:MnVMYVl7M0dyP2hBDRm0RS6o8-3bLDOC80xWulUWm4V_C6vAFztS3TPSPcjzR8c6fwwNdA6iRs5S2t2KY4Y_xFSdW_6LaGhfBZ-C0rODzxh9lw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvtddrudeiledgheefucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgjfhgggfestdekre
    dtredttdenucfhrhhomhepkfguohcuufgthhhimhhmvghluceoihguohhstghhsehiugho
    shgthhdrohhrgheqnecuggftrfgrthhtvghrnhepudetieevffffveelkeeljeffkefhke
    ehgfdtffethfelvdejgffghefgveejkefhnecuvehluhhsthgvrhfuihiivgeptdenucfr
    rghrrghmpehmrghilhhfrhhomhepihguohhstghhsehiughoshgthhdrohhrgh
X-ME-Proxy: <xmx:MnVMYQznrLo5h5rDGlSwoXOIqwVRBBTB26bIRgVkc9s_2Pd0PRQuVA>
    <xmx:MnVMYXTshnYovu0gwtQavEIqrSMlWcNnJoifKkeciaSq3hysb2Kiug>
    <xmx:MnVMYbaBucP6c_x2DtQt5gkqUp2pb29cRwzWlNMr4s_83G_VaM0ApQ>
    <xmx:MnVMYYJqCVubfDJtZw2lU9H-yYkjT2Og0Bxe7YHACXPllCb9-P7aFQ>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Thu,
 23 Sep 2021 08:38:08 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, amcohen@nvidia.com,
        petrm@nvidia.com, jiri@nvidia.com, mlxsw@nvidia.com,
        Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH net-next 03/14] mlxsw: spectrum_router: Fix arguments alignment
Date:   Thu, 23 Sep 2021 15:36:49 +0300
Message-Id: <20210923123700.885466-4-idosch@idosch.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210923123700.885466-1-idosch@idosch.org>
References: <20210923123700.885466-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Amit Cohen <amcohen@nvidia.com>

Suppress the following checkpatch.pl check [1] by adding a variable to
store the IP-in-IP options. Noticed while adding equivalent IPv6 code in
subsequent patches.

[1]
CHECK: Alignment should match open parenthesis
+               mlxsw_reg_ritr_loopback_ipip4_pack(ritr_pl, lb_cf.lb_ipipt,
+
+ MLXSW_REG_RITR_LOOPBACK_IPIP_OPTIONS_GRE_KEY_PRESET,

Signed-off-by: Amit Cohen <amcohen@nvidia.com>
Reviewed-by: Petr Machata <petrm@nvidia.com>
Signed-off-by: Ido Schimmel <idosch@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c
index 0454f3bc27d3..61f1e7d58128 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c
@@ -1536,19 +1536,22 @@ mlxsw_sp_rif_ipip_lb_op(struct mlxsw_sp_rif_ipip_lb *lb_rif, u16 ul_vr_id,
 			u16 ul_rif_id, bool enable)
 {
 	struct mlxsw_sp_rif_ipip_lb_config lb_cf = lb_rif->lb_config;
+	enum mlxsw_reg_ritr_loopback_ipip_options ipip_options;
 	struct mlxsw_sp_rif *rif = &lb_rif->common;
 	struct mlxsw_sp *mlxsw_sp = rif->mlxsw_sp;
 	char ritr_pl[MLXSW_REG_RITR_LEN];
 	u32 saddr4;
 
+	ipip_options = MLXSW_REG_RITR_LOOPBACK_IPIP_OPTIONS_GRE_KEY_PRESET;
 	switch (lb_cf.ul_protocol) {
 	case MLXSW_SP_L3_PROTO_IPV4:
 		saddr4 = be32_to_cpu(lb_cf.saddr.addr4);
 		mlxsw_reg_ritr_pack(ritr_pl, enable, MLXSW_REG_RITR_LOOPBACK_IF,
 				    rif->rif_index, rif->vr_id, rif->dev->mtu);
 		mlxsw_reg_ritr_loopback_ipip4_pack(ritr_pl, lb_cf.lb_ipipt,
-			    MLXSW_REG_RITR_LOOPBACK_IPIP_OPTIONS_GRE_KEY_PRESET,
-			    ul_vr_id, ul_rif_id, saddr4, lb_cf.okey);
+						   ipip_options, ul_vr_id,
+						   ul_rif_id, saddr4,
+						   lb_cf.okey);
 		break;
 
 	case MLXSW_SP_L3_PROTO_IPV6:
-- 
2.31.1


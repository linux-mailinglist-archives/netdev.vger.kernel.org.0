Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A9BA4415E7F
	for <lists+netdev@lfdr.de>; Thu, 23 Sep 2021 14:38:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241059AbhIWMjx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Sep 2021 08:39:53 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:33427 "EHLO
        out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S241054AbhIWMjw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Sep 2021 08:39:52 -0400
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailout.nyi.internal (Postfix) with ESMTP id 662B95C00D6;
        Thu, 23 Sep 2021 08:38:20 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute1.internal (MEProxy); Thu, 23 Sep 2021 08:38:20 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm3; bh=m8RiaI42z4bKKyPRCEG5mGgb1hNtRqXG/nuYQ10Wjko=; b=OCeUWJew
        A7cAmJvDgxB4iAT/ZJXzz5NpED7l8EiL9BEBWPenqgiblkpQ/rJEc65gZM1kiveH
        qieN20L8pfGu10BsnRKXVKMShbfBor0kaN9ddFfznWHYi37zQOeHsTocUKQxZaYq
        trjGufohrx71Quz7inZcDGjz10p5/CIdxpAcY5mc/5dvOQb2+DNfdC62ITHwbgzE
        8CuqZXkVpQiBkXMswCwPDbWEcMKaS8NmdLMHRePXQRMlT2wQv7IJRIvmVfmL1xAQ
        z2ZtwIIjphYjs0meHOUAC9UCAi/trbdKX1irCXU8QsRJLwV+dLHJsAIrybay3jmQ
        ilHauJ9Zt8McNw==
X-ME-Sender: <xms:PHVMYTgPt5IBNFEEiIfXyoKO9gfV4YLnz5HC3ViCGdBEx6wA9cJjhw>
    <xme:PHVMYQDnM88rfW-YhijPZNvwgPyOWC_OTza2QvS5EH40kCDM_xlsOT0wY30hf-Vim
    3w4xyoTvW5inAo>
X-ME-Received: <xmr:PHVMYTGzA8aGVYHntRRZJtntHcFdumMnp552Jom6vCbtIMTv3iMwxHGvaPRZOucWBfAusE1GJK2vpLH0fnxvF06rMvExRWgyu50DzsI31-RrJA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvtddrudeiledgheefucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgjfhgggfestdekre
    dtredttdenucfhrhhomhepkfguohcuufgthhhimhhmvghluceoihguohhstghhsehiugho
    shgthhdrohhrgheqnecuggftrfgrthhtvghrnhepudetieevffffveelkeeljeffkefhke
    ehgfdtffethfelvdejgffghefgveejkefhnecuvehluhhsthgvrhfuihiivgepfeenucfr
    rghrrghmpehmrghilhhfrhhomhepihguohhstghhsehiughoshgthhdrohhrgh
X-ME-Proxy: <xmx:PHVMYQS-oJYY-Pv8i20DFyaJYQ1CcIqgj4gXUKQMeTCDaaZp7eXo7A>
    <xmx:PHVMYQxEHG1O0k0hLhc_77lASlKVdbxGNzME-y7woKRgoQd7EgQeEA>
    <xmx:PHVMYW5dIn7sPFbirP62NS2_ZLkFb0BFrMS7P_J2vYx5lbCo9TmTpw>
    <xmx:PHVMYfoPn9nisshg05ieykVAJWmp0yMnKlpkkR2pmfsIAK9T-8vg5Q>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Thu,
 23 Sep 2021 08:38:18 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, amcohen@nvidia.com,
        petrm@nvidia.com, jiri@nvidia.com, mlxsw@nvidia.com,
        Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH net-next 08/14] mlxsw: reg: Add support for ratr_ipip6_entry_pack()
Date:   Thu, 23 Sep 2021 15:36:54 +0300
Message-Id: <20210923123700.885466-9-idosch@idosch.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210923123700.885466-1-idosch@idosch.org>
References: <20210923123700.885466-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Amit Cohen <amcohen@nvidia.com>

The RATR register is used to configure the Router Adjacency (next-hop)
Table.

For IP-in-IP entry, underlay destination IPv4 is saved as part of this
register and underlay destination IPv6 is saved by RIPS register and RATR
saves pointer to it.

Add function for setting IPv6 IP-in-IP configuration.

Signed-off-by: Amit Cohen <amcohen@nvidia.com>
Reviewed-by: Petr Machata <petrm@nvidia.com>
Signed-off-by: Ido Schimmel <idosch@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlxsw/reg.h | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/reg.h b/drivers/net/ethernet/mellanox/mlxsw/reg.h
index f9f614e3c57c..5cc4b1ee7e7b 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/reg.h
+++ b/drivers/net/ethernet/mellanox/mlxsw/reg.h
@@ -7002,6 +7002,12 @@ static inline void mlxsw_reg_ratr_ipip4_entry_pack(char *payload, u32 ipv4_udip)
 	mlxsw_reg_ratr_ipip_ipv4_udip_set(payload, ipv4_udip);
 }
 
+static inline void mlxsw_reg_ratr_ipip6_entry_pack(char *payload, u32 ipv6_ptr)
+{
+	mlxsw_reg_ratr_ipip_type_set(payload, MLXSW_REG_RATR_IPIP_TYPE_IPV6);
+	mlxsw_reg_ratr_ipip_ipv6_ptr_set(payload, ipv6_ptr);
+}
+
 static inline void mlxsw_reg_ratr_counter_pack(char *payload, u64 counter_index,
 					       bool counter_enable)
 {
-- 
2.31.1


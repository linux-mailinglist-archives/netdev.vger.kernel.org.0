Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0518B415E79
	for <lists+netdev@lfdr.de>; Thu, 23 Sep 2021 14:38:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241029AbhIWMjl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Sep 2021 08:39:41 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:44925 "EHLO
        out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S240997AbhIWMjk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Sep 2021 08:39:40 -0400
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailout.nyi.internal (Postfix) with ESMTP id 4E8065C00D6;
        Thu, 23 Sep 2021 08:38:08 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute1.internal (MEProxy); Thu, 23 Sep 2021 08:38:08 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm3; bh=m3myROkHmV79FY7m2ntvoM0uDiZqDAkTJ96zgOySzkQ=; b=rznXhTCa
        4X8eElZR6OuQaNXoJ51xTCj2UdR8c3CIsAzGY81ghhAR2Mm2QD/MQYFSubHmiuQD
        8/pILhoNQmi1FDgse3QMYPR+ruxDNKOMDwmekyIAKXtPDZiIO2j78WN0QIS4wKo/
        XT0EdCe1pb0Yz2xDwnCVKbYTQ8IfWBNW8a0kBZsrw3SYR35Ul9QVHn8guCZb31sr
        MXvMvH+u8K7jZOU+N25mPGSQ5MGrbfXPUspv+cew14Vo248e6wWVHUPYK6RhAdBy
        1megXLRzmg+tsrzIQORkfwT/nSFYUhzMMGukGs28fcstKnqTa7GG/WWOa+bwS/RD
        oQCM6dNK1650aQ==
X-ME-Sender: <xms:MHVMYUD-Oj_W8Jgsc531kvEpvACApIB11DU5Am50cSWm8fxNA56c5Q>
    <xme:MHVMYWjdgRcFaqaiut3zfKK8Z0ze5pjf1bg2KGpJ03MVvRxnEp-nd83ntSejgIkx0
    7zcXrLkw4-wYz0>
X-ME-Received: <xmr:MHVMYXkNd_JEyHazSGVQAsWG9LK3NAT-eAIpw85NgcLBr1boaKU3gBXShHm9YyYo9TFf2OQKPTpOrbK1XRQHzvro_T9kKymgAH-1GV_PIpWiaA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvtddrudeiledgheefucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgjfhgggfestdekre
    dtredttdenucfhrhhomhepkfguohcuufgthhhimhhmvghluceoihguohhstghhsehiugho
    shgthhdrohhrgheqnecuggftrfgrthhtvghrnhepudetieevffffveelkeeljeffkefhke
    ehgfdtffethfelvdejgffghefgveejkefhnecuvehluhhsthgvrhfuihiivgeptdenucfr
    rghrrghmpehmrghilhhfrhhomhepihguohhstghhsehiughoshgthhdrohhrgh
X-ME-Proxy: <xmx:MHVMYazeOtFZbkwrDtU-GMzjet4VqVVIdKqkyrmDaG5DmhzWSUJh4A>
    <xmx:MHVMYZQb86T9GDc9NsrjOfWwoqCtZlRFCOZh1yTZ2d6F8h7TmDRvxA>
    <xmx:MHVMYVZSoOunk0AcJvOMsx2W3oJljBLDe_3bdBT8-pHIkaoH9WDgug>
    <xmx:MHVMYSLQZzC1e6x5LE_eCeKkYxJTVK9-Ln0g1glln7BA50pF-3UwjQ>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Thu,
 23 Sep 2021 08:38:06 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, amcohen@nvidia.com,
        petrm@nvidia.com, jiri@nvidia.com, mlxsw@nvidia.com,
        Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH net-next 02/14] mlxsw: spectrum_ipip: Pass IP tunnel parameters by reference and as 'const'
Date:   Thu, 23 Sep 2021 15:36:48 +0300
Message-Id: <20210923123700.885466-3-idosch@idosch.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210923123700.885466-1-idosch@idosch.org>
References: <20210923123700.885466-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Amit Cohen <amcohen@nvidia.com>

Currently, there are several functions that handle 'struct ip_tunnel_parm'
and 'struct __ip6_tnl_parm'.

Change the mentioned functions to get IP tunnel parameters by reference
and as 'const'.

Signed-off-by: Amit Cohen <amcohen@nvidia.com>
Reviewed-by: Petr Machata <petrm@nvidia.com>
Signed-off-by: Ido Schimmel <idosch@nvidia.com>
---
 .../ethernet/mellanox/mlxsw/spectrum_ipip.c   | 66 +++++++++----------
 1 file changed, 33 insertions(+), 33 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_ipip.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_ipip.c
index 5facabd86882..9aeb6fe76c06 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_ipip.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_ipip.c
@@ -24,50 +24,50 @@ mlxsw_sp_ipip_netdev_parms6(const struct net_device *ol_dev)
 	return tun->parms;
 }
 
-static bool mlxsw_sp_ipip_parms4_has_ikey(struct ip_tunnel_parm parms)
+static bool mlxsw_sp_ipip_parms4_has_ikey(const struct ip_tunnel_parm *parms)
 {
-	return !!(parms.i_flags & TUNNEL_KEY);
+	return !!(parms->i_flags & TUNNEL_KEY);
 }
 
-static bool mlxsw_sp_ipip_parms4_has_okey(struct ip_tunnel_parm parms)
+static bool mlxsw_sp_ipip_parms4_has_okey(const struct ip_tunnel_parm *parms)
 {
-	return !!(parms.o_flags & TUNNEL_KEY);
+	return !!(parms->o_flags & TUNNEL_KEY);
 }
 
-static u32 mlxsw_sp_ipip_parms4_ikey(struct ip_tunnel_parm parms)
+static u32 mlxsw_sp_ipip_parms4_ikey(const struct ip_tunnel_parm *parms)
 {
 	return mlxsw_sp_ipip_parms4_has_ikey(parms) ?
-		be32_to_cpu(parms.i_key) : 0;
+		be32_to_cpu(parms->i_key) : 0;
 }
 
-static u32 mlxsw_sp_ipip_parms4_okey(struct ip_tunnel_parm parms)
+static u32 mlxsw_sp_ipip_parms4_okey(const struct ip_tunnel_parm *parms)
 {
 	return mlxsw_sp_ipip_parms4_has_okey(parms) ?
-		be32_to_cpu(parms.o_key) : 0;
+		be32_to_cpu(parms->o_key) : 0;
 }
 
 static union mlxsw_sp_l3addr
-mlxsw_sp_ipip_parms4_saddr(struct ip_tunnel_parm parms)
+mlxsw_sp_ipip_parms4_saddr(const struct ip_tunnel_parm *parms)
 {
-	return (union mlxsw_sp_l3addr) { .addr4 = parms.iph.saddr };
+	return (union mlxsw_sp_l3addr) { .addr4 = parms->iph.saddr };
 }
 
 static union mlxsw_sp_l3addr
-mlxsw_sp_ipip_parms6_saddr(struct __ip6_tnl_parm parms)
+mlxsw_sp_ipip_parms6_saddr(const struct __ip6_tnl_parm *parms)
 {
-	return (union mlxsw_sp_l3addr) { .addr6 = parms.laddr };
+	return (union mlxsw_sp_l3addr) { .addr6 = parms->laddr };
 }
 
 static union mlxsw_sp_l3addr
-mlxsw_sp_ipip_parms4_daddr(struct ip_tunnel_parm parms)
+mlxsw_sp_ipip_parms4_daddr(const struct ip_tunnel_parm *parms)
 {
-	return (union mlxsw_sp_l3addr) { .addr4 = parms.iph.daddr };
+	return (union mlxsw_sp_l3addr) { .addr4 = parms->iph.daddr };
 }
 
 static union mlxsw_sp_l3addr
-mlxsw_sp_ipip_parms6_daddr(struct __ip6_tnl_parm parms)
+mlxsw_sp_ipip_parms6_daddr(const struct __ip6_tnl_parm *parms)
 {
-	return (union mlxsw_sp_l3addr) { .addr6 = parms.raddr };
+	return (union mlxsw_sp_l3addr) { .addr6 = parms->raddr };
 }
 
 union mlxsw_sp_l3addr
@@ -80,10 +80,10 @@ mlxsw_sp_ipip_netdev_saddr(enum mlxsw_sp_l3proto proto,
 	switch (proto) {
 	case MLXSW_SP_L3_PROTO_IPV4:
 		parms4 = mlxsw_sp_ipip_netdev_parms4(ol_dev);
-		return mlxsw_sp_ipip_parms4_saddr(parms4);
+		return mlxsw_sp_ipip_parms4_saddr(&parms4);
 	case MLXSW_SP_L3_PROTO_IPV6:
 		parms6 = mlxsw_sp_ipip_netdev_parms6(ol_dev);
-		return mlxsw_sp_ipip_parms6_saddr(parms6);
+		return mlxsw_sp_ipip_parms6_saddr(&parms6);
 	}
 
 	WARN_ON(1);
@@ -95,7 +95,7 @@ static __be32 mlxsw_sp_ipip_netdev_daddr4(const struct net_device *ol_dev)
 
 	struct ip_tunnel_parm parms4 = mlxsw_sp_ipip_netdev_parms4(ol_dev);
 
-	return mlxsw_sp_ipip_parms4_daddr(parms4).addr4;
+	return mlxsw_sp_ipip_parms4_daddr(&parms4).addr4;
 }
 
 static union mlxsw_sp_l3addr
@@ -108,10 +108,10 @@ mlxsw_sp_ipip_netdev_daddr(enum mlxsw_sp_l3proto proto,
 	switch (proto) {
 	case MLXSW_SP_L3_PROTO_IPV4:
 		parms4 = mlxsw_sp_ipip_netdev_parms4(ol_dev);
-		return mlxsw_sp_ipip_parms4_daddr(parms4);
+		return mlxsw_sp_ipip_parms4_daddr(&parms4);
 	case MLXSW_SP_L3_PROTO_IPV6:
 		parms6 = mlxsw_sp_ipip_netdev_parms6(ol_dev);
-		return mlxsw_sp_ipip_parms6_daddr(parms6);
+		return mlxsw_sp_ipip_parms6_daddr(&parms6);
 	}
 
 	WARN_ON(1);
@@ -158,8 +158,8 @@ mlxsw_sp_ipip_decap_config_gre4(struct mlxsw_sp *mlxsw_sp,
 	u32 ikey;
 
 	parms = mlxsw_sp_ipip_netdev_parms4(ipip_entry->ol_dev);
-	has_ikey = mlxsw_sp_ipip_parms4_has_ikey(parms);
-	ikey = mlxsw_sp_ipip_parms4_ikey(parms);
+	has_ikey = mlxsw_sp_ipip_parms4_has_ikey(&parms);
+	ikey = mlxsw_sp_ipip_parms4_ikey(&parms);
 
 	mlxsw_reg_rtdp_pack(rtdp_pl, MLXSW_REG_RTDP_TYPE_IPIP, tunnel_index);
 	mlxsw_reg_rtdp_egress_router_interface_set(rtdp_pl, ul_rif_id);
@@ -218,12 +218,12 @@ mlxsw_sp_ipip_ol_loopback_config_gre4(struct mlxsw_sp *mlxsw_sp,
 	struct ip_tunnel_parm parms = mlxsw_sp_ipip_netdev_parms4(ol_dev);
 	enum mlxsw_reg_ritr_loopback_ipip_type lb_ipipt;
 
-	lb_ipipt = mlxsw_sp_ipip_parms4_has_okey(parms) ?
+	lb_ipipt = mlxsw_sp_ipip_parms4_has_okey(&parms) ?
 		MLXSW_REG_RITR_LOOPBACK_IPIP_TYPE_IP_IN_GRE_KEY_IN_IP :
 		MLXSW_REG_RITR_LOOPBACK_IPIP_TYPE_IP_IN_GRE_IN_IP;
 	return (struct mlxsw_sp_rif_ipip_lb_config){
 		.lb_ipipt = lb_ipipt,
-		.okey = mlxsw_sp_ipip_parms4_okey(parms),
+		.okey = mlxsw_sp_ipip_parms4_okey(&parms),
 		.ul_protocol = MLXSW_SP_L3_PROTO_IPV4,
 		.saddr = mlxsw_sp_ipip_netdev_saddr(MLXSW_SP_L3_PROTO_IPV4,
 						    ol_dev),
@@ -245,10 +245,10 @@ mlxsw_sp_ipip_ol_netdev_change_gre4(struct mlxsw_sp *mlxsw_sp,
 
 	new_parms = mlxsw_sp_ipip_netdev_parms4(ipip_entry->ol_dev);
 
-	new_saddr = mlxsw_sp_ipip_parms4_saddr(new_parms);
-	old_saddr = mlxsw_sp_ipip_parms4_saddr(ipip_entry->parms4);
-	new_daddr = mlxsw_sp_ipip_parms4_daddr(new_parms);
-	old_daddr = mlxsw_sp_ipip_parms4_daddr(ipip_entry->parms4);
+	new_saddr = mlxsw_sp_ipip_parms4_saddr(&new_parms);
+	old_saddr = mlxsw_sp_ipip_parms4_saddr(&ipip_entry->parms4);
+	new_daddr = mlxsw_sp_ipip_parms4_daddr(&new_parms);
+	old_daddr = mlxsw_sp_ipip_parms4_daddr(&ipip_entry->parms4);
 
 	if (!mlxsw_sp_l3addr_eq(&new_saddr, &old_saddr)) {
 		u16 ul_tb_id = mlxsw_sp_ipip_dev_ul_tb_id(ipip_entry->ol_dev);
@@ -265,14 +265,14 @@ mlxsw_sp_ipip_ol_netdev_change_gre4(struct mlxsw_sp *mlxsw_sp,
 		}
 
 		update_tunnel = true;
-	} else if ((mlxsw_sp_ipip_parms4_okey(ipip_entry->parms4) !=
-		    mlxsw_sp_ipip_parms4_okey(new_parms)) ||
+	} else if ((mlxsw_sp_ipip_parms4_okey(&ipip_entry->parms4) !=
+		    mlxsw_sp_ipip_parms4_okey(&new_parms)) ||
 		   ipip_entry->parms4.link != new_parms.link) {
 		update_tunnel = true;
 	} else if (!mlxsw_sp_l3addr_eq(&new_daddr, &old_daddr)) {
 		update_nhs = true;
-	} else if (mlxsw_sp_ipip_parms4_ikey(ipip_entry->parms4) !=
-		   mlxsw_sp_ipip_parms4_ikey(new_parms)) {
+	} else if (mlxsw_sp_ipip_parms4_ikey(&ipip_entry->parms4) !=
+		   mlxsw_sp_ipip_parms4_ikey(&new_parms)) {
 		update_decap = true;
 	}
 
-- 
2.31.1


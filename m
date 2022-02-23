Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 83B2C4C18A1
	for <lists+netdev@lfdr.de>; Wed, 23 Feb 2022 17:34:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235048AbiBWQe7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Feb 2022 11:34:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45072 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231128AbiBWQe6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Feb 2022 11:34:58 -0500
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2074.outbound.protection.outlook.com [40.107.94.74])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9676D4F47B
        for <netdev@vger.kernel.org>; Wed, 23 Feb 2022 08:34:29 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=WJ0wBxxIAQSbkdFDX1lKRwYw/vGQUpbOunqw1CnmINbYFCxwjgqO2ef+nOMkK7dwClIqxlodeHmzcpwfLtfm0z0n9NSYC/4rX2YOQw++Z4k5IMpHi3MxbBZQdvWLMkEt15z44G2L4yWES1T1QhuQhsZrcY/hVOcUgLJT0J/7o1zleIAv8pQOO7LH2Jr5trHhFFtnSSbf1xIErt8gdMZLZf5y8qju0mhFA5RdbBmTeRVJz8Sshwqmj+Uqt+Q/v2+LDqn9qAZP8Hcu6kuKjumB220r/bTN/33f7tfMo4+YQ6TEkWuwpr5dGbLzz/+Co2bvPbPhudjBak91losyVJA4Fw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=UCtKW0+2UTc074H6EW6580DCBEulhZhtX3SfsuiI6Uc=;
 b=EW/KxzmeKrCO3sah2W30x73GOPGI0tVwRLuQJHbBTmG3U9UJuwNNuzN1o4sg4Zajb0qx0F3Kl8T3JtsqVQbN27ey0HMgZ++ajUrPCcG+7fzTxHMvxYE/tWNHP+Smv1XNspXGqsjLShi5x7fETQ+j+UmFdjJzcI/S/JepmSAYab3p0xjJJIdtRM8RDKW2lxjhqw5FGPshQ2bv9hqlJHnNNbiCo/qNYxgGf3vG3Xg6kaAyzzx+07nIE1/sV7+Kn/I71gN+MMxJN1ZoEumOs6Oiz9VcAGRc8y9J03RIDaGeB9XfPgtxlCW/zW315zK9GvO5Ay/0xVRyaqg46q40muPN4g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.236) smtp.rcpttodomain=davemloft.net smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=UCtKW0+2UTc074H6EW6580DCBEulhZhtX3SfsuiI6Uc=;
 b=piKP+Qv/6DSbmIUkIi0Xl5dhpWOITuH5D6zFWkLung27qPbLXxE2Dt0lZFPqPxUJW5s/qGruZWt9dp/jVg33Qgie7tx/AFjhrRSUPU/otxJpzWMoNhaUWbmSgCpsaxDUKMn5IZxFh7sb96l6oXg1Ax38ZxWR+4lMnT7lfbKS/MDpC7kmjgNctB7hN75ocENTFlzwkdbwrvlYU5SRtg0309FAGpMi2Wvbdzg5HhrOPnpT8n6HLriE0xhEE8GvpzGstE0X6C9zXfvph5B2r5epb/Y4lqQGWOr0uJ9xqVm+ZCrx4J7NO4AkrXaY0SHhEE+FcBTgqJq131OlY5lpPk/r9w==
Received: from DM6PR13CA0025.namprd13.prod.outlook.com (2603:10b6:5:bc::38) by
 DM4PR12MB5914.namprd12.prod.outlook.com (2603:10b6:8:67::21) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4995.17; Wed, 23 Feb 2022 16:34:27 +0000
Received: from DM6NAM11FT006.eop-nam11.prod.protection.outlook.com
 (2603:10b6:5:bc:cafe::d) by DM6PR13CA0025.outlook.office365.com
 (2603:10b6:5:bc::38) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5017.9 via Frontend
 Transport; Wed, 23 Feb 2022 16:34:27 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.236)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.236 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.236; helo=mail.nvidia.com;
Received: from mail.nvidia.com (12.22.5.236) by
 DM6NAM11FT006.mail.protection.outlook.com (10.13.173.104) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.5017.22 via Frontend Transport; Wed, 23 Feb 2022 16:34:27 +0000
Received: from rnnvmail204.nvidia.com (10.129.68.6) by DRHQMAIL109.nvidia.com
 (10.27.9.19) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Wed, 23 Feb
 2022 16:34:23 +0000
Received: from rnnvmail202.nvidia.com (10.129.68.7) by rnnvmail204.nvidia.com
 (10.129.68.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.9; Wed, 23 Feb 2022
 08:34:22 -0800
Received: from reg-r-vrt-019-180.mtr.labs.mlnx (10.127.8.11) by
 mail.nvidia.com (10.129.68.7) with Microsoft SMTP Server id 15.2.986.9 via
 Frontend Transport; Wed, 23 Feb 2022 08:34:19 -0800
From:   Paul Blakey <paulb@nvidia.com>
To:     Paul Blakey <paulb@nvidia.com>, <dev@openvswitch.org>,
        <netdev@vger.kernel.org>, Jamal Hadi Salim <jhs@mojatatu.com>,
        "Pravin B Shelar" <pshelar@ovn.org>, <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Eelco Chaudron <echaudro@redhat.com>
CC:     Oz Shlomo <ozsh@nvidia.com>, Vlad Buslov <vladbu@nvidia.com>,
        Roi Dayan <roid@nvidia.com>,
        Ariel Levkovich <lariel@nvidia.com>
Subject: [PATCH net v5 1/1] openvswitch: Fix setting ipv6 fields causing hw csum failure
Date:   Wed, 23 Feb 2022 18:34:16 +0200
Message-ID: <20220223163416.24096-1-paulb@nvidia.com>
X-Mailer: git-send-email 2.30.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: ac13e1f0-dda4-4707-2163-08d9f6ea5be2
X-MS-TrafficTypeDiagnostic: DM4PR12MB5914:EE_
X-Microsoft-Antispam-PRVS: <DM4PR12MB5914858316BE06E8DC0B218EC23C9@DM4PR12MB5914.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: x9HhCeT8z4kSHuV0U5gbzT56WBXYJvMsd+d4IEpngLbnpuBs2GEftrUvG0EqTlRzigbBcUk5T/yoI60r3qOg8cha1VixTjToMDaIQRVXFPO+7M/cs348tA+LXnsrJJNKO3DqWrSFHD94lt1zH1xIGRJoqxgFBpM0FvgSD4iLiJRs5cPT1KqoG6BpZaULnp4yiBbvqF69Uaxmurd3ZcteEVOMv1OabFpBV+iyTcpZNn9TnIDosuyd6zHQBcK9hmq+mMFIAqJkA3BIt2NR4eiY0EOFkghrx9e515Mn/XIFvDwT0AYLI2wBnZX2MlXy0ganDebFF3kJk93KPnTrha4LC3q2y2IwVTfnXWaHvxqIh3S3NSktNxhNtfmdDp82h2vkUJdbtK/Ye71mcb+lYXIGYTK/qAN7kGoE346KvdooPlOFR/jRKSY0HnNFIt9GbUi1AzmgwJpKOdFYW6IKyyXYMbGNs11pPzuBK7LvC+S9tMvOKshMlmJ9+afTInD99lFQ25oJtB03K1SNmI+of+5kvlmmTW45qIINYrjMkgBBmuP4tOdiW15HKNRoeJ2xaQNfEAAUR5heH8k7uiT0LrFWIrIQ9XfiJhmOR7uaL9Qpmc1xzD89AwoKmDaZF8hcKvYBegdedSfUKuCzuADqph9v5W4ovjeWLj0XRiAYwIOBsinoxRHNQDmr2kdNuc4/1ULtVKUoPKvr3zvmZWbFwQE6yg==
X-Forefront-Antispam-Report: CIP:12.22.5.236;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230001)(4636009)(46966006)(40470700004)(36840700001)(83380400001)(1076003)(47076005)(6666004)(2906002)(40460700003)(54906003)(356005)(26005)(110136005)(186003)(81166007)(86362001)(8936002)(107886003)(36756003)(508600001)(82310400004)(316002)(36860700001)(336012)(5660300002)(2616005)(8676002)(426003)(70206006)(70586007)(4326008)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Feb 2022 16:34:27.2712
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: ac13e1f0-dda4-4707-2163-08d9f6ea5be2
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.236];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT006.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB5914
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Ipv6 ttl, label and tos fields are modified without first
pulling/pushing the ipv6 header, which would have updated
the hw csum (if available). This might cause csum validation
when sending the packet to the stack, as can be seen in
the trace below.

Fix this by updating skb->csum if available.

Trace resulted by ipv6 ttl dec and then sending packet
to conntrack [actions: set(ipv6(hlimit=63)),ct(zone=99)]:
[295241.900063] s_pf0vf2: hw csum failure
[295241.923191] Call Trace:
[295241.925728]  <IRQ>
[295241.927836]  dump_stack+0x5c/0x80
[295241.931240]  __skb_checksum_complete+0xac/0xc0
[295241.935778]  nf_conntrack_tcp_packet+0x398/0xba0 [nf_conntrack]
[295241.953030]  nf_conntrack_in+0x498/0x5e0 [nf_conntrack]
[295241.958344]  __ovs_ct_lookup+0xac/0x860 [openvswitch]
[295241.968532]  ovs_ct_execute+0x4a7/0x7c0 [openvswitch]
[295241.979167]  do_execute_actions+0x54a/0xaa0 [openvswitch]
[295242.001482]  ovs_execute_actions+0x48/0x100 [openvswitch]
[295242.006966]  ovs_dp_process_packet+0x96/0x1d0 [openvswitch]
[295242.012626]  ovs_vport_receive+0x6c/0xc0 [openvswitch]
[295242.028763]  netdev_frame_hook+0xc0/0x180 [openvswitch]
[295242.034074]  __netif_receive_skb_core+0x2ca/0xcb0
[295242.047498]  netif_receive_skb_internal+0x3e/0xc0
[295242.052291]  napi_gro_receive+0xba/0xe0
[295242.056231]  mlx5e_handle_rx_cqe_mpwrq_rep+0x12b/0x250 [mlx5_core]
[295242.062513]  mlx5e_poll_rx_cq+0xa0f/0xa30 [mlx5_core]
[295242.067669]  mlx5e_napi_poll+0xe1/0x6b0 [mlx5_core]
[295242.077958]  net_rx_action+0x149/0x3b0
[295242.086762]  __do_softirq+0xd7/0x2d6
[295242.090427]  irq_exit+0xf7/0x100
[295242.093748]  do_IRQ+0x7f/0xd0
[295242.096806]  common_interrupt+0xf/0xf
[295242.100559]  </IRQ>
[295242.102750] RIP: 0033:0x7f9022e88cbd
[295242.125246] RSP: 002b:00007f9022282b20 EFLAGS: 00000246 ORIG_RAX: ffffffffffffffda
[295242.132900] RAX: 0000000000000005 RBX: 0000000000000010 RCX: 0000000000000000
[295242.140120] RDX: 00007f9022282ba8 RSI: 00007f9022282a30 RDI: 00007f9014005c30
[295242.147337] RBP: 00007f9014014d60 R08: 0000000000000020 R09: 00007f90254a8340
[295242.154557] R10: 00007f9022282a28 R11: 0000000000000246 R12: 0000000000000000
[295242.161775] R13: 00007f902308c000 R14: 000000000000002b R15: 00007f9022b71f40

Fixes: 3fdbd1ce11e5 ("openvswitch: add ipv6 'set' action")
Signed-off-by: Paul Blakey <paulb@nvidia.com>
---
Changelog:
    v5->v4:
      Replaced v4 helper with csum_replace.
      Removed extra space
    v4->v3:
      Use new helper csum_block_replace
    v2->v3:
      Use u8 instead of __u8
      Fix sparse warnings on conversions
    v1->v2:
      Replaced push pull rcsum checksum calc with actual checksum calc

 include/net/checksum.h    |  5 +++++
 net/openvswitch/actions.c | 46 ++++++++++++++++++++++++++++++++-------
 2 files changed, 43 insertions(+), 8 deletions(-)

diff --git a/include/net/checksum.h b/include/net/checksum.h
index 5218041e5c8f..b6d9f9c4ab49 100644
--- a/include/net/checksum.h
+++ b/include/net/checksum.h
@@ -141,6 +141,11 @@ static inline void csum_replace2(__sum16 *sum, __be16 old, __be16 new)
 	*sum = ~csum16_add(csum16_sub(~(*sum), old), new);
 }
 
+static inline void csum_replace(__wsum *csum, __wsum old, __wsum new)
+{
+	*csum = csum_add(csum_sub(*csum, old), new);
+}
+
 struct sk_buff;
 void inet_proto_csum_replace4(__sum16 *sum, struct sk_buff *skb,
 			      __be32 from, __be32 to, bool pseudohdr);
diff --git a/net/openvswitch/actions.c b/net/openvswitch/actions.c
index 076774034bb9..780d9e2246f3 100644
--- a/net/openvswitch/actions.c
+++ b/net/openvswitch/actions.c
@@ -423,12 +423,43 @@ static void set_ipv6_addr(struct sk_buff *skb, u8 l4_proto,
 	memcpy(addr, new_addr, sizeof(__be32[4]));
 }
 
-static void set_ipv6_fl(struct ipv6hdr *nh, u32 fl, u32 mask)
+static void set_ipv6_dsfield(struct sk_buff *skb, struct ipv6hdr *nh, u8 ipv6_tclass, u8 mask)
 {
+	u8 old_ipv6_tclass = ipv6_get_dsfield(nh);
+
+	ipv6_tclass = OVS_MASKED(old_ipv6_tclass, ipv6_tclass, mask);
+
+	if (skb->ip_summed == CHECKSUM_COMPLETE)
+		csum_replace(&skb->csum, (__force __wsum)(old_ipv6_tclass << 12),
+			     (__force __wsum)(ipv6_tclass << 12));
+
+	ipv6_change_dsfield(nh, ~mask, ipv6_tclass);
+}
+
+static void set_ipv6_fl(struct sk_buff *skb, struct ipv6hdr *nh, u32 fl, u32 mask)
+{
+	u32 ofl;
+
+	ofl = nh->flow_lbl[0] << 16 |  nh->flow_lbl[1] << 8 |  nh->flow_lbl[2];
+	fl = OVS_MASKED(ofl, fl, mask);
+
 	/* Bits 21-24 are always unmasked, so this retains their values. */
-	OVS_SET_MASKED(nh->flow_lbl[0], (u8)(fl >> 16), (u8)(mask >> 16));
-	OVS_SET_MASKED(nh->flow_lbl[1], (u8)(fl >> 8), (u8)(mask >> 8));
-	OVS_SET_MASKED(nh->flow_lbl[2], (u8)fl, (u8)mask);
+	nh->flow_lbl[0] = (u8)(fl >> 16);
+	nh->flow_lbl[1] = (u8)(fl >> 8);
+	nh->flow_lbl[2] = (u8)fl;
+
+	if (skb->ip_summed == CHECKSUM_COMPLETE)
+		csum_replace(&skb->csum, (__force __wsum)htonl(ofl), (__force __wsum)htonl(fl));
+}
+
+static void set_ipv6_ttl(struct sk_buff *skb, struct ipv6hdr *nh, u8 new_ttl, u8 mask)
+{
+	new_ttl = OVS_MASKED(nh->hop_limit, new_ttl, mask);
+
+	if (skb->ip_summed == CHECKSUM_COMPLETE)
+		csum_replace(&skb->csum, (__force __wsum)(nh->hop_limit << 8),
+			     (__force __wsum)(new_ttl << 8));
+	nh->hop_limit = new_ttl;
 }
 
 static void set_ip_ttl(struct sk_buff *skb, struct iphdr *nh, u8 new_ttl,
@@ -546,18 +577,17 @@ static int set_ipv6(struct sk_buff *skb, struct sw_flow_key *flow_key,
 		}
 	}
 	if (mask->ipv6_tclass) {
-		ipv6_change_dsfield(nh, ~mask->ipv6_tclass, key->ipv6_tclass);
+		set_ipv6_dsfield(skb, nh, key->ipv6_tclass, mask->ipv6_tclass);
 		flow_key->ip.tos = ipv6_get_dsfield(nh);
 	}
 	if (mask->ipv6_label) {
-		set_ipv6_fl(nh, ntohl(key->ipv6_label),
+		set_ipv6_fl(skb, nh, ntohl(key->ipv6_label),
 			    ntohl(mask->ipv6_label));
 		flow_key->ipv6.label =
 		    *(__be32 *)nh & htonl(IPV6_FLOWINFO_FLOWLABEL);
 	}
 	if (mask->ipv6_hlimit) {
-		OVS_SET_MASKED(nh->hop_limit, key->ipv6_hlimit,
-			       mask->ipv6_hlimit);
+		set_ipv6_ttl(skb, nh, key->ipv6_hlimit, mask->ipv6_hlimit);
 		flow_key->ip.ttl = nh->hop_limit;
 	}
 	return 0;
-- 
2.30.1


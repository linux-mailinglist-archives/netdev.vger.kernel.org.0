Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 073E94BCE9D
	for <lists+netdev@lfdr.de>; Sun, 20 Feb 2022 14:22:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243835AbiBTNWG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 20 Feb 2022 08:22:06 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:47178 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232564AbiBTNWE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 20 Feb 2022 08:22:04 -0500
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2080.outbound.protection.outlook.com [40.107.93.80])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BF7DCDF5A
        for <netdev@vger.kernel.org>; Sun, 20 Feb 2022 05:21:42 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VmuvSk3/SySePe37H4ioQbV1CM1m1YHNhzeL4yl5At6QnzKsdSOn1SWK9AlHG7AGGBCN4NKUTGmSEwmBuxeIFaPkNzGoaK5NjOlWhD3+f+vai564uvukzz9It/mAWHg6gWmIBwnbDBkR0HYXJPhXvwwG3SJBScqdQzpy32M844HYhx+PZrwTwA9c6X6Fhfnr9S7kS5tQ/bAWOCqqeqcxvi9oc+wcngT0iOXN9a9yQCBX+BYWH3VT0310v5zjcUfYEJMkYnWfrMMFbXZ7VildxFbbfNgJKRpTiszsYh0HAAfhqmw3qNFJqcfpSSJ7w7MdDMrNHYf/jGwYz5ZWoGaWxw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=tos2kPV9+jjDmUktZITuoAXQ05jzmODcSP58D7gX//I=;
 b=B65XEsetCfQ1MzOAmeqL2WK+o/eebbEKQYeQZln6xDbpme0Yq9/IWNOV8rA/AyO+HZ3oHTbAjdxMvf5EBE1UHD+rbCn+qNoDndHfEGJg3K946KEKyXHDd9LlnQf+kESgn4vH1kIdbed7TdzXXvgQ+wa5drHvV4wFuse2fnzF7BRMKCANvwuzSEZvXWQK3wjhClytkKjOjcbuItzzPc00z24CXoYq/fyjHmC5MTJOc0ZSqbTT+24SDRCu3AkB/O0i+qiElOQSKvZlAsRfXw+u8gRQ6kEi/UU6gNg9iIpTqvMSzu2SnSbCtpc69S9pkM5Eu8ddD7glvKv/gggXNaY3hw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.238) smtp.rcpttodomain=davemloft.net smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tos2kPV9+jjDmUktZITuoAXQ05jzmODcSP58D7gX//I=;
 b=RgUFU8sy6dEy9SmDUJmsGqTowtds9Ijd9c/NBk8Z9Tb1jt/uoGO7cSG6PLlBXJHmbuqQ2F2M1Oegd8DDAeTjSYbxNsYL+LVZWcVgJ28pqpUj7bKWgBqNmtoivDYbEeK8MUUDTmXb1zUEdoss+14VemGyPZVa3Or6c3t0kSqO5GaLGDgKwnuxXYDm+1YBQPXKI1n03b119suII1/d+HffBg0Lkhnkashj9+LkntrAUZfyQ/CsXdJr0kXe7jl9qb/tdFlCj0GkFkbRPaylS4N9QVWCUaZrE97tjSdA0CjL41lQYiWBz6HgPXfkuUw5tOHMVj0IcngrUIibGD+oNm3WRw==
Received: from MWHPR07CA0011.namprd07.prod.outlook.com (2603:10b6:300:116::21)
 by MN2PR12MB2911.namprd12.prod.outlook.com (2603:10b6:208:a9::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4995.16; Sun, 20 Feb
 2022 13:21:40 +0000
Received: from CO1NAM11FT025.eop-nam11.prod.protection.outlook.com
 (2603:10b6:300:116:cafe::96) by MWHPR07CA0011.outlook.office365.com
 (2603:10b6:300:116::21) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4995.14 via Frontend
 Transport; Sun, 20 Feb 2022 13:21:39 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.238)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.238 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.238; helo=mail.nvidia.com;
Received: from mail.nvidia.com (12.22.5.238) by
 CO1NAM11FT025.mail.protection.outlook.com (10.13.175.232) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4995.15 via Frontend Transport; Sun, 20 Feb 2022 13:21:39 +0000
Received: from rnnvmail202.nvidia.com (10.129.68.7) by DRHQMAIL105.nvidia.com
 (10.27.9.14) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Sun, 20 Feb
 2022 13:21:37 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by rnnvmail202.nvidia.com
 (10.129.68.7) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.9; Sun, 20 Feb 2022
 05:21:35 -0800
Received: from reg-r-vrt-019-180.mtr.labs.mlnx (10.127.8.11) by
 mail.nvidia.com (10.129.68.8) with Microsoft SMTP Server id 15.2.986.9 via
 Frontend Transport; Sun, 20 Feb 2022 05:21:33 -0800
From:   Paul Blakey <paulb@nvidia.com>
To:     Paul Blakey <paulb@nvidia.com>, <dev@openvswitch.org>,
        <netdev@vger.kernel.org>, Jamal Hadi Salim <jhs@mojatatu.com>,
        "Pravin B Shelar" <pshelar@ovn.org>, <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Eelco Chaudron <echaudro@redhat.com>
CC:     Oz Shlomo <ozsh@nvidia.com>, Vlad Buslov <vladbu@nvidia.com>,
        Roi Dayan <roid@nvidia.com>,
        Ariel Levkovich <lariel@nvidia.com>
Subject: [PATCH net v4 1/1] openvswitch: Fix setting ipv6 fields causing hw csum failure
Date:   Sun, 20 Feb 2022 15:21:14 +0200
Message-ID: <20220220132114.18989-1-paulb@nvidia.com>
X-Mailer: git-send-email 2.30.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: f61a1fe2-8f87-404d-20dc-08d9f473ed8a
X-MS-TrafficTypeDiagnostic: MN2PR12MB2911:EE_
X-Microsoft-Antispam-PRVS: <MN2PR12MB2911B19C144CFC350385F2B2C2399@MN2PR12MB2911.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: cqXrc6gNbY+tDFzhh+vywgn5W9l/+qtUOzsyT2lcuq+0ZCy/Iy7V/07/1Q4MupOugFXw8LYZMHX8kLKYNf16mxWkH6WxxPW2/Sa0QzmUCR4gzBvsoCQoFfBI61sNBv4SnBRiXJ1TunpMaE54Xfn3rZtqdpsQ53nPrH4M/MoJpj0tFNqsJqZ4BcRJE1V7txed7FLDqxcrN7RIFd/WizGhewo0HZbERJspJOVhHUlWgL9/Nt2v0mBhj4J8ovMSa/nYPpWkNJU7veftSimAwEyx26hLIOz0YiVBqbnvPOTMAlLku6ByzvXWs4dgXBwU3sbyJMuArCzJt7soLTcBfpsW75D6Py6MIiyerh4oOFobRf9LdWD7B9U1PzKlfvUwGH0S/zh/bLL0Br3P7SH79ZNJsi7n7ANTm8Cwxax9k1V99Suio157qun8Id5HxsIj0C7C8Jpupvvt0CgtsxMZCe8fQbUNK613hVQDnPVgpDyHwTK2iRcHai0Wk38rw+fhEuHxEP1TvSPyfsQk+Bna7piDk8NwT5nDHL51yjiCnM/BPtiINsQddSmMUy0n1hEj9PY4edvxQ4MnSX3LEWRZ/WuoIe6CS1NRdRJNjzytjehUylNzSnFJ+Svf+px6tbKKNXe9GlDer9Tgyo5x2rNIhxIb8S98DTc2CDOexEDU9t+GRVu7pP+gSypahq8yHRvcCRAgGz+28v2YF6TOH0ZzszacaA==
X-Forefront-Antispam-Report: CIP:12.22.5.238;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230001)(4636009)(40470700004)(36840700001)(46966006)(8936002)(356005)(81166007)(5660300002)(40460700003)(6666004)(2906002)(82310400004)(86362001)(8676002)(508600001)(4326008)(36860700001)(83380400001)(47076005)(36756003)(70206006)(70586007)(426003)(186003)(26005)(1076003)(54906003)(316002)(336012)(2616005)(107886003)(110136005)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Feb 2022 13:21:39.2211
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: f61a1fe2-8f87-404d-20dc-08d9f473ed8a
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.238];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT025.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB2911
X-Spam-Status: No, score=-0.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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
    v4->v3:
      Use new helper csum_block_replace
    v2->v3:
      Use u8 instead of __u8
      Fix sparse warnings on conversions
    v1->v2:
      Replaced push pull rcsum checksum calc with actual checksum calc

 include/net/checksum.h    |  7 ++++++
 net/openvswitch/actions.c | 47 ++++++++++++++++++++++++++++++++-------
 2 files changed, 46 insertions(+), 8 deletions(-)

diff --git a/include/net/checksum.h b/include/net/checksum.h
index 5218041e5c8f..ce39e47b2881 100644
--- a/include/net/checksum.h
+++ b/include/net/checksum.h
@@ -106,6 +106,12 @@ csum_block_sub(__wsum csum, __wsum csum2, int offset)
 	return csum_block_add(csum, ~csum2, offset);
 }
 
+static inline __wsum
+csum_block_replace(__wsum csum, __wsum old, __wsum new, int offset)
+{
+	return csum_block_add(csum_block_sub(csum, old, offset), new, offset);
+}
+
 static inline __wsum csum_unfold(__sum16 n)
 {
 	return (__force __wsum)n;
@@ -184,4 +190,5 @@ static inline __wsum wsum_negate(__wsum val)
 {
 	return (__force __wsum)-((__force u32)val);
 }
+
 #endif
diff --git a/net/openvswitch/actions.c b/net/openvswitch/actions.c
index 076774034bb9..1bc9037e4b9e 100644
--- a/net/openvswitch/actions.c
+++ b/net/openvswitch/actions.c
@@ -423,12 +423,44 @@ static void set_ipv6_addr(struct sk_buff *skb, u8 l4_proto,
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
+		skb->csum = csum_block_replace(skb->csum, (__force __wsum)(old_ipv6_tclass << 4),
+					       (__force __wsum)(ipv6_tclass << 4), 1);
+
+	ipv6_change_dsfield(nh, ~mask, ipv6_tclass);
+}
+
+static void set_ipv6_fl(struct sk_buff *skb, struct ipv6hdr *nh, u32 fl, u32 mask)
+{
+	u32 old_fl;
+
+	old_fl = nh->flow_lbl[0] << 16 |  nh->flow_lbl[1] << 8 |  nh->flow_lbl[2];
+	fl = OVS_MASKED(old_fl, fl, mask);
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
+		skb->csum = csum_block_replace(skb->csum, (__force __wsum)htonl(old_fl),
+					       (__force __wsum)htonl(fl), 0);
+}
+
+static void set_ipv6_ttl(struct sk_buff *skb, struct ipv6hdr *nh, u8 new_ttl, u8 mask)
+{
+	new_ttl = OVS_MASKED(nh->hop_limit, new_ttl, mask);
+
+	if (skb->ip_summed == CHECKSUM_COMPLETE)
+		skb->csum = csum_block_replace(skb->csum, (__force __wsum)nh->hop_limit,
+					       (__force __wsum)new_ttl, 1);
+	nh->hop_limit = new_ttl;
 }
 
 static void set_ip_ttl(struct sk_buff *skb, struct iphdr *nh, u8 new_ttl,
@@ -546,18 +578,17 @@ static int set_ipv6(struct sk_buff *skb, struct sw_flow_key *flow_key,
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


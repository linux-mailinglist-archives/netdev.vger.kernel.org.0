Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3AB334AC279
	for <lists+netdev@lfdr.de>; Mon,  7 Feb 2022 16:07:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1384200AbiBGPFq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Feb 2022 10:05:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47924 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354816AbiBGOlS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Feb 2022 09:41:18 -0500
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2077.outbound.protection.outlook.com [40.107.236.77])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3E252C0401C3
        for <netdev@vger.kernel.org>; Mon,  7 Feb 2022 06:41:17 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=eG0G1MYf0IcRg/7z24pEDS++tjsUOz4Mlrocqih1kpO4sACnXIB2jVM+cpqu/2hw78uNGZgDWriPxvS5n+qoF5iowJKQ/2N8G3zhJszn01IXUJT3qiyszR9DVw7YkhxfbOctD4wmm8vsyiDvKZPV8JK1NT71JJ7cpSsKrW4e3Ue/eMKg7EEsu0cfNzZ9gzMd+WrNuJFZQmiQUVk50TG1jtvqjpsFpMrpcNRWz63+tFrC4IHEmeuS9LU/HmGz/Hnt+ALayX8wCttDG4xmYmoEi4hDcGmTgNrNopfaWs6X8pFl+zaSiJW6UqjA3AOvn7Mu7ZNVGAHI5IZG7B8fy54Xkg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=iAs4aPSRC9yi0QrNfjQnNP5T2PPlGod1PNvlC091RRI=;
 b=L3moDwACM4uFaA9+Zn35U8WP7w5p/NEUswLZWSI/hRafPPuReE/b6znPZWsBuUQx5AQGT+SGWEQS8eL49X0Cd9XeW5d8Ud8zs0+VFYlFd1qhloRNsi7zi+nNNEfaHZvBde9GdWurzEKagFw6v0/TdxcgujeTC+mr25MpwuMPyfCaaEWNShejPevzeBBcf/4veFpMdn15hf3vgohPBqOv0Gb0F7dWMK2Ckz7egAZ/3aoEnrVLPUrVIhhef13+hCsvHHSfFJwmN9NSAC+vKQT9QTE+p+2wPU3PYPqnoh9dOMO23//lrsIHN1Tm1lT+O7LIYdm5JvI/CCLzJkPWdUmQ/g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.238) smtp.rcpttodomain=davemloft.net smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=iAs4aPSRC9yi0QrNfjQnNP5T2PPlGod1PNvlC091RRI=;
 b=FGmcnMUAtN5IQrrwwuJNqIRM2761CbwSSk48OztuMHTBxla0s/xp2vxRB+DiUBFBNLzK2gI1kY82AI9LW1SpPIAFMc4PJi9kkwUSoa29cL6xm0P/hdn6CC2u0BbXwoFfleQuEFJc7A/quAgVRrkLYPPaxqdzARE+h3zROojKsX26rSbfGQ1jP2FEgxb8TdXVx6jwf9pSzPnzfE5FanvPy8DMf7lt4o+8LqH6ghhO3oS0Lss/zNGCASYPYzHW2LWKnOtLkp1hKRaLM0IXcdGmy5Bw9z3ern+pS31a4Wb1yOA7rauWsFEpbfQa3Lpr34Y1LoUnt2qLclxzBA/E9Nj3IA==
Received: from MWHPR18CA0029.namprd18.prod.outlook.com (2603:10b6:320:31::15)
 by BN8PR12MB3281.namprd12.prod.outlook.com (2603:10b6:408:6e::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4951.14; Mon, 7 Feb
 2022 14:41:15 +0000
Received: from CO1NAM11FT013.eop-nam11.prod.protection.outlook.com
 (2603:10b6:320:31:cafe::32) by MWHPR18CA0029.outlook.office365.com
 (2603:10b6:320:31::15) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4951.19 via Frontend
 Transport; Mon, 7 Feb 2022 14:41:14 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.238)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.238 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.238; helo=mail.nvidia.com;
Received: from mail.nvidia.com (12.22.5.238) by
 CO1NAM11FT013.mail.protection.outlook.com (10.13.174.227) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4951.12 via Frontend Transport; Mon, 7 Feb 2022 14:41:14 +0000
Received: from rnnvmail202.nvidia.com (10.129.68.7) by DRHQMAIL105.nvidia.com
 (10.27.9.14) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Mon, 7 Feb
 2022 14:41:13 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by rnnvmail202.nvidia.com
 (10.129.68.7) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.9; Mon, 7 Feb 2022
 06:41:12 -0800
Received: from reg-r-vrt-019-180.mtr.labs.mlnx (10.127.8.11) by
 mail.nvidia.com (10.129.68.8) with Microsoft SMTP Server id 15.2.986.9 via
 Frontend Transport; Mon, 7 Feb 2022 06:41:09 -0800
From:   Paul Blakey <paulb@nvidia.com>
To:     Paul Blakey <paulb@nvidia.com>, <dev@openvswitch.org>,
        <netdev@vger.kernel.org>, Jamal Hadi Salim <jhs@mojatatu.com>,
        "Pravin B Shelar" <pshelar@ovn.org>, <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Eelco Chaudron <echaudro@redhat.com>
CC:     Oz Shlomo <ozsh@nvidia.com>, Vlad Buslov <vladbu@nvidia.com>,
        Roi Dayan <roid@nvidia.com>,
        Ariel Levkovich <lariel@nvidia.com>
Subject: [PATCH net 1/1] openvswitch: Fix setting ipv6 fields causing hw csum failure
Date:   Mon, 7 Feb 2022 16:41:01 +0200
Message-ID: <20220207144101.17200-1-paulb@nvidia.com>
X-Mailer: git-send-email 2.30.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 90783db1-0f2c-4937-5684-08d9ea47e441
X-MS-TrafficTypeDiagnostic: BN8PR12MB3281:EE_
X-Microsoft-Antispam-PRVS: <BN8PR12MB3281844525385A96A900A823C22C9@BN8PR12MB3281.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7691;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: G+taTUQCPlugYFxIBAgDQ42sKIvvQlSZMgmKjbTQAYIT3C22yZpxDcJnZjCk6/OjHqRbJnhZG0K2rZBjgLp9ccRpIk/NFX/wJqet1HwjAUvmqgpQKK5tRdQN/+bgYHw3/SBxMMdJ67iZNOdwHUr5AcaoTk3OJgbSn41jPk6HvDoGwjVFrRvy7EKcYdRvZsNIszHCY7pIwwklp90RDEUTlE+8M/SuCUzKJIiUZI7tYaHlGEotbdvTwq90LLWnQR1KWzMg6LEgicYUMo0Cv4NHKEShc6iOPg8SbEFHIvBTtpY7ajguibn/vDIODD20PgUfTFRioampkp0/w3iPChXuvs9pFSQ4RmE2a5P0BPN4t4mCawPLtj2VR+6I88+3gYS0Ux3JHL4Kvwn1rsJvHjVKZacUtvZOS6P+Rx7eijy1ZZ3He0QUWr+rk9amCzXaSxNnltqQYLg7UIQ3N+povkqMxTMSCZkLtCD9m2pm4emQrcM7+EY+Icj1oBf55h12fg01Dwj8+hcfm9qpkUt/0xibJJVJZXXHiv3gwZtv4H/PTYDp/AwESdCPw21x7idttc3r3wPs54SOWyCmilDsanit5LdiqO2dU5S52FqSQnse3hVFB8SnU9vT+t2YjKMQ7ICHG36T/t8dI/andJm+kAdB1u1jJR8Bv48bLE4I1FPJ9xdddRg2plIHehc+Gxgg1Zf8mmr9w1+AwbOHcGn4MKxTvQ==
X-Forefront-Antispam-Report: CIP:12.22.5.238;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230001)(4636009)(36840700001)(46966006)(40470700004)(4326008)(8936002)(8676002)(86362001)(2906002)(70586007)(70206006)(5660300002)(81166007)(356005)(82310400004)(26005)(186003)(1076003)(2616005)(36756003)(336012)(107886003)(508600001)(6666004)(426003)(47076005)(110136005)(40460700003)(54906003)(83380400001)(36860700001)(316002)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Feb 2022 14:41:14.1607
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 90783db1-0f2c-4937-5684-08d9ea47e441
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.238];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT013.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN8PR12MB3281
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

Fix this by calling postpush/postpull checksum calculation
which will update the hw csum if needed.

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
 net/openvswitch/actions.c | 29 ++++++++++++++++++++++++-----
 1 file changed, 24 insertions(+), 5 deletions(-)

diff --git a/net/openvswitch/actions.c b/net/openvswitch/actions.c
index 076774034bb9..77b99dc82f95 100644
--- a/net/openvswitch/actions.c
+++ b/net/openvswitch/actions.c
@@ -423,12 +423,32 @@ static void set_ipv6_addr(struct sk_buff *skb, u8 l4_proto,
 	memcpy(addr, new_addr, sizeof(__be32[4]));
 }
 
-static void set_ipv6_fl(struct ipv6hdr *nh, u32 fl, u32 mask)
+static void set_ipv6_dsfield(struct sk_buff *skb, struct ipv6hdr *nh, __u8 ipv6_tclass, __u8 mask)
 {
+	skb_postpull_rcsum(skb, nh, 4);
+
+	ipv6_change_dsfield(nh, ~mask, ipv6_tclass);
+
+	skb_postpush_rcsum(skb, nh, 4);
+}
+
+static void set_ipv6_fl(struct sk_buff *skb, struct ipv6hdr *nh, u32 fl, u32 mask)
+{
+	skb_postpull_rcsum(skb, nh, 4);
+
 	/* Bits 21-24 are always unmasked, so this retains their values. */
 	OVS_SET_MASKED(nh->flow_lbl[0], (u8)(fl >> 16), (u8)(mask >> 16));
 	OVS_SET_MASKED(nh->flow_lbl[1], (u8)(fl >> 8), (u8)(mask >> 8));
 	OVS_SET_MASKED(nh->flow_lbl[2], (u8)fl, (u8)mask);
+
+	skb_postpush_rcsum(skb, nh, 4);
+}
+
+static void set_ipv6_ttl(struct sk_buff *skb, struct ipv6hdr *nh, u8 new_ttl, u8 mask)
+{
+	__skb_postpull_rcsum(skb, &nh->hop_limit, sizeof(nh->hop_limit), 1);
+	OVS_SET_MASKED(nh->hop_limit, new_ttl, mask);
+	__skb_postpush_rcsum(skb, &nh->hop_limit, sizeof(nh->hop_limit), 1);
 }
 
 static void set_ip_ttl(struct sk_buff *skb, struct iphdr *nh, u8 new_ttl,
@@ -546,18 +566,17 @@ static int set_ipv6(struct sk_buff *skb, struct sw_flow_key *flow_key,
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


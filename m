Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C1E454B5093
	for <lists+netdev@lfdr.de>; Mon, 14 Feb 2022 13:49:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244240AbiBNMtO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Feb 2022 07:49:14 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:42222 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231627AbiBNMtN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Feb 2022 07:49:13 -0500
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2068.outbound.protection.outlook.com [40.107.236.68])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A067F4B85C
        for <netdev@vger.kernel.org>; Mon, 14 Feb 2022 04:49:05 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=n4AFFdsI4QXsWOewLB5eCHTo9NrnktRccmdwd3jFKgTzu6Kfh48LJRfEoAhLyQikiy3d1gpB5w1evCCwXFLgh6q17/7bjZ7Rys6Z+Pu/UTW8G4lSjgr8iSyeOYwswZ5Hcj04kPRgCR/CnrqP1Z8+frAaj11W/DEJYyJIPdkVXX7J2/PsfBqs0esOP5+cl8L6YNzy06Sq66Gpvoww5Gl1RkYW0X7Jo4YYa+GMK/OJ75lhE8vqXtO0RZY0aNPtAaHXLC7VuAQ2Mk4WRvCijSV1fQA/Row5+OtbhPndY5M8AZE5AREZFtR02zg/mkHf7kuOYNOq6PhullzAsN+WnZE8bQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Pu6M9Hpoy2hmcMDN8ETMLtf7loN+5IDgonbvG3OswNI=;
 b=OyJtoJyU3wlqz5ViyG1+PMPz/H08R01Xqpc9GjqzThjikRqnFlt0/B+Y13PfSnBUq8N2YwpRQ/Ro6nsk+gTUabz8eq5cEgNeFJUdCSySbjz6BgSQ5uAJoidvfSdtcsCQcbZIdV7T6I80H2v8iGwM+G3NWZ9nkYuXkNQRRc0vwkI22B7GUInRNZ4TBygJFI/UZB57uv/GB0UBGhtoXMK0QBYXhxU7idOPzocEYzFRNX+rBXrcS7iXpO99Z/pJnolBMjURlzsPrbAsiTYjGqZTH7ysQ4zJJ4puX/XCA6KfrcFHpW0Rq6n0LJYNrUIWpFVEMP5hm943mWWLUD7TOhZaGg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.234) smtp.rcpttodomain=davemloft.net smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Pu6M9Hpoy2hmcMDN8ETMLtf7loN+5IDgonbvG3OswNI=;
 b=bco98xEskJQm/AjwKofLtzeSxsm0X1RBFBTdkCaMgjqEglzAvyLYBJ5GVcptmCr7CSOBEv841/scHkWR46FF6/7p0rbpyBoQ66iZdikQT9ovusW8DHRB3Hy+FcBRgcHshmVg4zyQ8RIyjsWHN7oGpAcoML5LfldGSuRVdH4vSCFytEhDLBF2rGfy78wzOv1YPG2n/eXMjZ1QiGr7hVRlUfYyD4D0kQ5ZBNXD144+Qfwm2povau1WmPofzxRJooGOsARwG+yj861IUUNW3ihsfyAEuwIplaeIfKbzws60Huphrrj+npW9rnDND8L8af0g4UxI2+nnLuYEHM4Tizw0Cg==
Received: from DS7PR03CA0311.namprd03.prod.outlook.com (2603:10b6:8:2b::23) by
 BN6PR12MB1827.namprd12.prod.outlook.com (2603:10b6:404:fd::22) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4975.11; Mon, 14 Feb 2022 12:49:03 +0000
Received: from DM6NAM11FT063.eop-nam11.prod.protection.outlook.com
 (2603:10b6:8:2b:cafe::7f) by DS7PR03CA0311.outlook.office365.com
 (2603:10b6:8:2b::23) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4975.12 via Frontend
 Transport; Mon, 14 Feb 2022 12:49:03 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.234)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.234 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.234; helo=mail.nvidia.com;
Received: from mail.nvidia.com (12.22.5.234) by
 DM6NAM11FT063.mail.protection.outlook.com (10.13.172.219) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4975.11 via Frontend Transport; Mon, 14 Feb 2022 12:49:02 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by DRHQMAIL101.nvidia.com
 (10.27.9.10) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Mon, 14 Feb
 2022 12:49:01 +0000
Received: from rnnvmail202.nvidia.com (10.129.68.7) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.9; Mon, 14 Feb 2022
 04:49:00 -0800
Received: from reg-r-vrt-019-180.mtr.labs.mlnx (10.127.8.11) by
 mail.nvidia.com (10.129.68.7) with Microsoft SMTP Server id 15.2.986.9 via
 Frontend Transport; Mon, 14 Feb 2022 04:48:57 -0800
From:   Paul Blakey <paulb@nvidia.com>
To:     Paul Blakey <paulb@nvidia.com>, <dev@openvswitch.org>,
        <netdev@vger.kernel.org>, Jamal Hadi Salim <jhs@mojatatu.com>,
        "Pravin B Shelar" <pshelar@ovn.org>, <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Eelco Chaudron <echaudro@redhat.com>
CC:     Oz Shlomo <ozsh@nvidia.com>, Vlad Buslov <vladbu@nvidia.com>,
        Roi Dayan <roid@nvidia.com>,
        Ariel Levkovich <lariel@nvidia.com>
Subject: [PATCH net v2 1/1] openvswitch: Fix setting ipv6 fields causing hw csum failure
Date:   Mon, 14 Feb 2022 14:48:51 +0200
Message-ID: <20220214124851.14400-1-paulb@nvidia.com>
X-Mailer: git-send-email 2.30.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 949984d7-cf52-488c-db8f-08d9efb86092
X-MS-TrafficTypeDiagnostic: BN6PR12MB1827:EE_
X-Microsoft-Antispam-PRVS: <BN6PR12MB1827CCAFA29332C4928F5B28C2339@BN6PR12MB1827.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6790;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: VxCnrs7hWuGsjdDtFX/IpQrtYzI+MTaKrwf39w73GKHrJm0nvi+MpeZWqEOCq/mhkXqE62dWcGWfKWD2Ulk0LGr9Nh2cv+m/9nkhOzE/ROi9YNjomtikK2Sjg0lrpLYbmmb3tfIKZqhNt+GZMweZrRQXBYqVRCXlyILw6bTi16jH0m89VfYtLo7f/D6WDE03g9Ngqds4/BdKTRRshdN1mnMCTIKs5cIi9r7AH7Urbc2e1TTf3QROmEw50gkKj2lMNj56hSjPxL22/clnt4dBCGn6dJqoDAx87yrdcYFjCpwnaj4Wi68KlXDQ02it9gQOMt2PvTjW60nVzXSZ3UaQkaUhsrJCLCdyouTVPARiiqXELTq0mmuIUXRCsCDSzHOcvu0lZbkI/5M8lnb0hHwRSTf9G6Mx3c3XpiouHTe5A/oJnCdAdAr2w4Yi7FRkWmzYTfk4Vf+rNNavsaUqojDIHlpoX88MaTUHrdnV1+tipEKcMzW+hRdWGWgXqSisbH8lNpnze1wHrW0eeVd4+/4bdGukI7Vna2IFk0k2e2FgbW6LHvSWcrZmSClKJP9zog56I2Ot3LEe/dpEGP65v31utE4WRTeXxx+P8+xBLxTle+tgWXw05GgT7gS376Bf5mLhKuYSSzGqO0ldrm7k+rSh/Ym4kVPgRqJRe/Xmq9hZDwCNIUBUDA9/6yeZUAgBGMkG8yXklHRvbOd74UqUvgu3Lw==
X-Forefront-Antispam-Report: CIP:12.22.5.234;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230001)(4636009)(36840700001)(46966006)(40470700004)(508600001)(83380400001)(86362001)(336012)(426003)(8676002)(70586007)(36756003)(47076005)(36860700001)(4326008)(70206006)(5660300002)(8936002)(316002)(186003)(26005)(107886003)(54906003)(110136005)(1076003)(81166007)(356005)(40460700003)(2906002)(2616005)(82310400004)(6666004)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Feb 2022 12:49:02.1800
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 949984d7-cf52-488c-db8f-08d9efb86092
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.234];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT063.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN6PR12MB1827
X-Spam-Status: No, score=-1.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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
    v1->v2:
      Replaced push pull rcsum checksum calc with actual checksum calc
 
 net/openvswitch/actions.c | 47 ++++++++++++++++++++++++++++++++-------
 1 file changed, 39 insertions(+), 8 deletions(-)

diff --git a/net/openvswitch/actions.c b/net/openvswitch/actions.c
index 076774034bb9..3725801cb040 100644
--- a/net/openvswitch/actions.c
+++ b/net/openvswitch/actions.c
@@ -423,12 +423,44 @@ static void set_ipv6_addr(struct sk_buff *skb, u8 l4_proto,
 	memcpy(addr, new_addr, sizeof(__be32[4]));
 }
 
-static void set_ipv6_fl(struct ipv6hdr *nh, u32 fl, u32 mask)
+static void set_ipv6_dsfield(struct sk_buff *skb, struct ipv6hdr *nh, __u8 ipv6_tclass, __u8 mask)
 {
+	__u8 old_ipv6_tclass = ipv6_get_dsfield(nh);
+
+	ipv6_tclass = OVS_MASKED(old_ipv6_tclass, ipv6_tclass, mask);
+
+	if (skb->ip_summed == CHECKSUM_COMPLETE)
+		skb->csum = ~csum_block_add(csum_block_sub(~skb->csum, ipv6_tclass << 4, 1),
+					    old_ipv6_tclass << 4, 1);
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
+		skb->csum = ~csum_block_add(csum_block_sub(~skb->csum, htonl(fl), 0),
+					    htonl(old_fl), 0);
+}
+
+static void set_ipv6_ttl(struct sk_buff *skb, struct ipv6hdr *nh, u8 new_ttl, u8 mask)
+{
+	new_ttl = OVS_MASKED(nh->hop_limit, new_ttl, mask);
+
+	if (skb->ip_summed == CHECKSUM_COMPLETE)
+		skb->csum = ~csum_block_add(csum_block_sub(~skb->csum, new_ttl, 1),
+					    nh->hop_limit, 1);
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


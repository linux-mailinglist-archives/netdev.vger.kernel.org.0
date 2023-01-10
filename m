Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 551856641F0
	for <lists+netdev@lfdr.de>; Tue, 10 Jan 2023 14:32:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238593AbjAJNcN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Jan 2023 08:32:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57190 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238603AbjAJNbs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Jan 2023 08:31:48 -0500
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2040.outbound.protection.outlook.com [40.107.236.40])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3F30244350;
        Tue, 10 Jan 2023 05:31:46 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DyRRNYipmIaKD7snhP9lPxHdOGu8wK17gty1UhbTuoixaa/QjnsS+z+u52PmM1gshwSrLEQSK9u0+EXrzlKee91dc4+AsZJMDdh/2TVVljA8YOYXWee2lnSJNEACkBIl8C9DL0Lmfvdw8nBkGdf5zQ+8SCiKR8NEZKc/1JujJ6RvFHHj8C4lOacjwf2TXSy7en0+WeGxE0Y4Yt3tmQ4Nh+SJ+DrQONWNZ82SOfsYthEF/Nx2XPTBeZcV/E1YqFeihGWqhsc0uhwbStYjfcspW12IlapP22ruhKkY67TwKIxI4ugC1r025tMZp5Zn71w2Dj5mAn9cEu+T2MyZas+b1A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=wM2paC/pUdX6NnkKABrYxLcS03Usi5y6IxiikT2Ul2k=;
 b=J59IvVLUgVWZ91/e/xq0g9Lax7us/0JFk+2Un99s4NnNlFieDdb2xaAtqrJpnP7uZBKa6m0d4jxFCE6DLRSe3DoI/H0mL0a2lDZ8MoS7IH8vyfcRe+W54Qmx7DCOIZCJhkh+C2N20VVJQWo9JJwhiR5Xi7YWUAV/h0I3uY1qDqHdpv3HxRG5y27m33ocfd9TjAhEslh41PjrqqJeq3RackM7F6LSMsiDUkhRjCOId27zTnQ4Kwp0uJ6mFvz47KLJx0+ot4Wr1s05I+9I6wZystXE8O1raYykz7cabJ9rSZWyeD4Bb3uJ5hAlUcMMJEyiQ5CKHu+WK1YOzbf5sB1kgA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=davemloft.net smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wM2paC/pUdX6NnkKABrYxLcS03Usi5y6IxiikT2Ul2k=;
 b=SFkupVxnNFw4cstnyKkbFX9PSiDWU7KIISgAao4cwT08X1jY96HM2vHIQY0VvrSzGmQp9wKs/X7qXarscELSv1mHC22VO0dyPRI4uFkEnVIcRFaUa8EdVwPhkC2zvT2RCXq0mjLYjFV69NmIV9wvCis/kSDXNo3rPsT/sz3UL+QbEB/u+hG21SWd/dYM47llNIQymv/L28u9n7aNMaw1YyUtrdOuKwS859jCPXdZX5eIKS5kAGx1//mZy1i44IENu/KQ7PHb1/3eU3JfjzZccZikuF9YszfuggpKEOELWlzr3NcIKe4k5XriV6xp3bzcSN68QOleApIFhoUeE7SJOw==
Received: from BN9PR03CA0310.namprd03.prod.outlook.com (2603:10b6:408:112::15)
 by DM4PR12MB7695.namprd12.prod.outlook.com (2603:10b6:8:101::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5986.18; Tue, 10 Jan
 2023 13:31:44 +0000
Received: from BN8NAM11FT040.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:112:cafe::77) by BN9PR03CA0310.outlook.office365.com
 (2603:10b6:408:112::15) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5986.18 via Frontend
 Transport; Tue, 10 Jan 2023 13:31:44 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 BN8NAM11FT040.mail.protection.outlook.com (10.13.177.166) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5986.18 via Frontend Transport; Tue, 10 Jan 2023 13:31:43 +0000
Received: from rnnvmail203.nvidia.com (10.129.68.9) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.36; Tue, 10 Jan
 2023 05:31:21 -0800
Received: from rnnvmail204.nvidia.com (10.129.68.6) by rnnvmail203.nvidia.com
 (10.129.68.9) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.36; Tue, 10 Jan
 2023 05:31:20 -0800
Received: from vdi.nvidia.com (10.127.8.14) by mail.nvidia.com (10.129.68.6)
 with Microsoft SMTP Server id 15.2.986.36 via Frontend Transport; Tue, 10 Jan
 2023 05:31:17 -0800
From:   Vlad Buslov <vladbu@nvidia.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <pabeni@redhat.com>,
        <pablo@netfilter.org>
CC:     <netdev@vger.kernel.org>, <netfilter-devel@vger.kernel.org>,
        <jhs@mojatatu.com>, <xiyou.wangcong@gmail.com>, <jiri@resnulli.us>,
        <ozsh@nvidia.com>, <marcelo.leitner@gmail.com>,
        <simon.horman@corigine.com>, Vlad Buslov <vladbu@nvidia.com>
Subject: [PATCH net-next v1 6/7] net/sched: act_ct: offload UDP NEW connections
Date:   Tue, 10 Jan 2023 14:30:22 +0100
Message-ID: <20230110133023.2366381-7-vladbu@nvidia.com>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20230110133023.2366381-1-vladbu@nvidia.com>
References: <20230110133023.2366381-1-vladbu@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN8NAM11FT040:EE_|DM4PR12MB7695:EE_
X-MS-Office365-Filtering-Correlation-Id: 5fc31460-ed8b-4ef3-8874-08daf30f035f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: hqdgXMv34hDol2iUTn0JZgIy3EOR5u/ydkIajKymcVgcAxZ/zuMWFh05p7Moe4/AMa4VVGNPgFuVzkB/fe74ksto9i1zWXEtwSlroBoXYH8+qE7vJBzoMYdRvYoxxuzuZYFFQjhQ1Vanu6j99TkLGMgL3uNOWFmi/ditUd4PznVrdFx//LLl87u/QFg5FaXsTAO+kNPATPD86utcREp2jrPGQDqDSBbndfozAFKj1yYKYiTQiamRHNkLvk3wO7avoFommbXQG+oi5Q1hhJdgtKNXdNufsZefTWtQmDucNYzb4/EY34aDziPWmd2MSn3ev9CwXJaBpyfZOXMPXOyNMxX2Ul4BgZ252eJcv5BXsCCF1/kiH55EZFigfHlshLqByWWpa45L5QXOH2axJcTddHJ+1tJD7GU9o7EX3gdQfzia0qQtlCm3fouLu4MYw1pEvr76c3NeT/EEP7uzRDHJ8N8uG365sSAIlV7ahLhRCl/HqBloQ2XCevqtTeAf4mbVE+In/l/F7F2XvrEcf9lrLMnwvv0vVBWInEgCsQWDu1Dcq6b5bZqtVu9FNGEhf7wbH7++V4QvcdW2pJfVLqKoF7L1aP59cSL+k9sIlzT7PsT0pxegxjMNxKP1OJq/g1bcJQWoJREiT0b8W85JDv1vhane6Q0bqfubrMuOXUYa0sVbdUJoJlZPPwydck8PBMTIwwqidAwzje3wLprOXYgtgRh/Sgoz/F7C3F/ChGbY4Rg=
X-Forefront-Antispam-Report: CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230022)(4636009)(396003)(136003)(39860400002)(376002)(346002)(451199015)(46966006)(36840700001)(40470700004)(41300700001)(82310400005)(2906002)(8936002)(36756003)(5660300002)(7416002)(8676002)(70586007)(316002)(70206006)(7696005)(107886003)(54906003)(110136005)(6666004)(478600001)(40480700001)(47076005)(336012)(186003)(4326008)(26005)(1076003)(2616005)(426003)(83380400001)(40460700003)(86362001)(36860700001)(82740400003)(356005)(7636003)(2101003);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Jan 2023 13:31:43.0966
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 5fc31460-ed8b-4ef3-8874-08daf30f035f
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT040.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB7695
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When processing connections allow offloading of UDP connections that don't
have IPS_ASSURED_BIT set as unidirectional. When performing table lookup
for reply packets check the current connection status: If UDP
unidirectional connection became assured also promote the corresponding
flow table entry to bidirectional and set the 'update' bit, else just set
the 'update' bit since reply directional traffic will most likely cause
connection status to become 'established' which requires updating the
offload state.

Signed-off-by: Vlad Buslov <vladbu@nvidia.com>
---
 net/sched/act_ct.c | 48 ++++++++++++++++++++++++++++++++++------------
 1 file changed, 36 insertions(+), 12 deletions(-)

diff --git a/net/sched/act_ct.c b/net/sched/act_ct.c
index bfddb462d2bc..563cbdd8341c 100644
--- a/net/sched/act_ct.c
+++ b/net/sched/act_ct.c
@@ -369,7 +369,7 @@ static void tcf_ct_flow_tc_ifidx(struct flow_offload *entry,
 
 static void tcf_ct_flow_table_add(struct tcf_ct_flow_table *ct_ft,
 				  struct nf_conn *ct,
-				  bool tcp)
+				  bool tcp, bool bidirectional)
 {
 	struct nf_conn_act_ct_ext *act_ct_ext;
 	struct flow_offload *entry;
@@ -388,6 +388,8 @@ static void tcf_ct_flow_table_add(struct tcf_ct_flow_table *ct_ft,
 		ct->proto.tcp.seen[0].flags |= IP_CT_TCP_FLAG_BE_LIBERAL;
 		ct->proto.tcp.seen[1].flags |= IP_CT_TCP_FLAG_BE_LIBERAL;
 	}
+	if (bidirectional)
+		__set_bit(NF_FLOW_HW_BIDIRECTIONAL, &entry->flags);
 
 	act_ct_ext = nf_conn_act_ct_ext_find(ct);
 	if (act_ct_ext) {
@@ -411,26 +413,34 @@ static void tcf_ct_flow_table_process_conn(struct tcf_ct_flow_table *ct_ft,
 					   struct nf_conn *ct,
 					   enum ip_conntrack_info ctinfo)
 {
-	bool tcp = false;
-
-	if ((ctinfo != IP_CT_ESTABLISHED && ctinfo != IP_CT_ESTABLISHED_REPLY) ||
-	    !test_bit(IPS_ASSURED_BIT, &ct->status))
-		return;
+	bool tcp = false, bidirectional = true;
 
 	switch (nf_ct_protonum(ct)) {
 	case IPPROTO_TCP:
-		tcp = true;
-		if (ct->proto.tcp.state != TCP_CONNTRACK_ESTABLISHED)
+		if ((ctinfo != IP_CT_ESTABLISHED &&
+		     ctinfo != IP_CT_ESTABLISHED_REPLY) ||
+		    !test_bit(IPS_ASSURED_BIT, &ct->status) ||
+		    ct->proto.tcp.state != TCP_CONNTRACK_ESTABLISHED)
 			return;
+
+		tcp = true;
 		break;
 	case IPPROTO_UDP:
+		if (!nf_ct_is_confirmed(ct))
+			return;
+		if (!test_bit(IPS_ASSURED_BIT, &ct->status))
+			bidirectional = false;
 		break;
 #ifdef CONFIG_NF_CT_PROTO_GRE
 	case IPPROTO_GRE: {
 		struct nf_conntrack_tuple *tuple;
 
-		if (ct->status & IPS_NAT_MASK)
+		if ((ctinfo != IP_CT_ESTABLISHED &&
+		     ctinfo != IP_CT_ESTABLISHED_REPLY) ||
+		    !test_bit(IPS_ASSURED_BIT, &ct->status) ||
+		    ct->status & IPS_NAT_MASK)
 			return;
+
 		tuple = &ct->tuplehash[IP_CT_DIR_ORIGINAL].tuple;
 		/* No support for GRE v1 */
 		if (tuple->src.u.gre.key || tuple->dst.u.gre.key)
@@ -446,7 +456,7 @@ static void tcf_ct_flow_table_process_conn(struct tcf_ct_flow_table *ct_ft,
 	    ct->status & IPS_SEQ_ADJUST)
 		return;
 
-	tcf_ct_flow_table_add(ct_ft, ct, tcp);
+	tcf_ct_flow_table_add(ct_ft, ct, tcp, bidirectional);
 }
 
 static bool
@@ -625,13 +635,27 @@ static bool tcf_ct_flow_table_lookup(struct tcf_ct_params *p,
 	flow = container_of(tuplehash, struct flow_offload, tuplehash[dir]);
 	ct = flow->ct;
 
+	if (dir == FLOW_OFFLOAD_DIR_REPLY &&
+	    !test_bit(NF_FLOW_HW_BIDIRECTIONAL, &flow->flags)) {
+		/* Only offload reply direction after connection became
+		 * assured.
+		 */
+		if (test_bit(IPS_ASSURED_BIT, &ct->status))
+			set_bit(NF_FLOW_HW_BIDIRECTIONAL, &flow->flags);
+		set_bit(NF_FLOW_HW_UPDATE, &flow->flags);
+		return false;
+	}
+
 	if (tcph && (unlikely(tcph->fin || tcph->rst))) {
 		flow_offload_teardown(flow);
 		return false;
 	}
 
-	ctinfo = dir == FLOW_OFFLOAD_DIR_ORIGINAL ? IP_CT_ESTABLISHED :
-						    IP_CT_ESTABLISHED_REPLY;
+	if (dir == FLOW_OFFLOAD_DIR_ORIGINAL)
+		ctinfo = test_bit(IPS_SEEN_REPLY_BIT, &ct->status) ?
+			IP_CT_ESTABLISHED : IP_CT_NEW;
+	else
+		ctinfo = IP_CT_ESTABLISHED_REPLY;
 
 	flow_offload_refresh(nf_ft, flow);
 	nf_conntrack_get(&ct->ct_general);
-- 
2.38.1


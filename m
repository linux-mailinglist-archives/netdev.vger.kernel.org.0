Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ADDA64C65A3
	for <lists+netdev@lfdr.de>; Mon, 28 Feb 2022 10:25:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234299AbiB1JYl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Feb 2022 04:24:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51050 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231688AbiB1JYk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Feb 2022 04:24:40 -0500
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2074.outbound.protection.outlook.com [40.107.92.74])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DC8E45A15F;
        Mon, 28 Feb 2022 01:24:01 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Bv8yWEiMV4+MDGQsDCb6G3j3F11Vvs7UQiZZsLLLRsIdE1Xqu7TKZnfAQbXtV98KBPTmGQ8Sp+uqjm1MFE526Jk1R3rwC2tyPUZ/lZu1bAYfx7Ae11OtUqlyIC8cBPdRugByWtznfNNKLc/l0kxDyq84Gc8DWxJODC2aSmzR4hI7X/zSQapc9sbnCzrQ1Dpy3deAYN9OZridzDDzTQtS9rfWZDuicB8F0MjlxAPEHp1i10EUs/AXAmhk6tyohZSBCvIsKnbOCUGJYT4Tz8FLo2Wo+5vqOSMzywZx+ZlXVHTQtd9Rm1dznpqPHj3M7P5myRDS848pOHUmcoDTDMoBDg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=KnvgmcOTTV3GQSprLhFSs4mqMQMRoQ/0BVM7Z9zdLXE=;
 b=VK2+oyl9NtFUWH0JIyat+osik2Zl5WexV/asr9/2zaLGl9kqKEWmP1EfqDUt1M0YhI10nNS8jPOq3Y+kQKtm8VkS7x7anBBXFdJKSuM1JXeW3l20LcajDwEa9/0iaUSngafznwVpzR+SG92QCExMUpV6cqCVurkuZCVY5j7KRiOi0AW3FcKkm191ljV1TOQiajH153kiC+uQWSUrTpW41W80ldHYKb0gya4ejAGGQeSGQFq9vdrQEyxsaM7OSDrovKTp/FpKz4jC4MfvIOcibiRrjPbypXOCIDpQ15ETMytHZEHZB/8LVO9ExtQkz9akCLRXWSzmrtPYwz+U7xMn7w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.238) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=KnvgmcOTTV3GQSprLhFSs4mqMQMRoQ/0BVM7Z9zdLXE=;
 b=SSbywWPm5uqzBS5Ruxo0CTM7pO8QgAvs+1MhwUlTcduHPe/9n+UsnO83DRC9ZuQWZVnFjpA1WeE4S4sgkOQDhHpwv3MKi9hsQJTRGLOBci8PPWXOQke6S1gv9svshZsoD51szjhag38SBzNtIUS5FV38d9dS+ZXKrjp0sgB0kUslcAbBOiuBxVaiKJrebi5YYV9UOoSAtVTKfwyv8znpwr6aJS2Lwl1tUCPae93Kl3aiTjxpcBxGGE8uWfFRLIqf13WtT/G6/6adoxXJgqoi832kvGJMqxMUj1YDX6ojvMxE7bHaUGH5EKpOlSGMGNJAkQteYGhOO7LBWlALD/h4pg==
Received: from CO2PR04CA0088.namprd04.prod.outlook.com (2603:10b6:104:6::14)
 by SJ0PR12MB5456.namprd12.prod.outlook.com (2603:10b6:a03:3ae::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5017.22; Mon, 28 Feb
 2022 09:23:59 +0000
Received: from CO1NAM11FT003.eop-nam11.prod.protection.outlook.com
 (2603:10b6:104:6:cafe::15) by CO2PR04CA0088.outlook.office365.com
 (2603:10b6:104:6::14) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5017.23 via Frontend
 Transport; Mon, 28 Feb 2022 09:23:59 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.238)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.238 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.238; helo=mail.nvidia.com;
Received: from mail.nvidia.com (12.22.5.238) by
 CO1NAM11FT003.mail.protection.outlook.com (10.13.175.93) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.5017.22 via Frontend Transport; Mon, 28 Feb 2022 09:23:59 +0000
Received: from rnnvmail203.nvidia.com (10.129.68.9) by DRHQMAIL105.nvidia.com
 (10.27.9.14) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Mon, 28 Feb
 2022 09:23:58 +0000
Received: from rnnvmail202.nvidia.com (10.129.68.7) by rnnvmail203.nvidia.com
 (10.129.68.9) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.9; Mon, 28 Feb 2022
 01:23:56 -0800
Received: from reg-r-vrt-019-180.mtr.labs.mlnx (10.127.8.11) by
 mail.nvidia.com (10.129.68.7) with Microsoft SMTP Server id 15.2.986.9 via
 Frontend Transport; Mon, 28 Feb 2022 01:23:52 -0800
From:   Paul Blakey <paulb@nvidia.com>
To:     Paul Blakey <paulb@nvidia.com>, <dev@openvswitch.org>,
        <netdev@vger.kernel.org>, Jamal Hadi Salim <jhs@mojatatu.com>,
        <davem@davemloft.net>, Jiri Pirko <jiri@nvidia.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        <netfilter-devel@vger.kernel.org>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Jozsef Kadlecsik <kadlec@netfilter.org>
CC:     Oz Shlomo <ozsh@nvidia.com>, Vlad Buslov <vladbu@nvidia.com>,
        Roi Dayan <roid@nvidia.com>,
        Ariel Levkovich <lariel@nvidia.com>, <coreteam@netfilter.org>
Subject: [PATCH net v4 1/1] net/sched: act_ct: Fix flow table lookup failure with no originating ifindex
Date:   Mon, 28 Feb 2022 11:23:49 +0200
Message-ID: <20220228092349.3605-1-paulb@nvidia.com>
X-Mailer: git-send-email 2.30.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 618b1dd8-d7dc-4361-6cf9-08d9fa9c0d24
X-MS-TrafficTypeDiagnostic: SJ0PR12MB5456:EE_
X-Microsoft-Antispam-PRVS: <SJ0PR12MB54568776101DD020A786BE37C2019@SJ0PR12MB5456.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: fpAfBmQzwCObQB++yP0734m9/OkkifX5SuQOiouL23kgH2WFcvguU4GpkmusDPQmrROtIvK409DtaZmzlXgQsCb9sOdLhV5bYTzyOwuOcJgK6/mHy/N4YenknmDauCyYoF2BMCo2qEq2gHFDXa8eyoAcPwoFLBUd3QUTAvtXnngx9WevtUTYBA+8ov/qfp4BBfgDqauNjxb1KrANBaiBXmna5eKOjv5CmunjiBxENwF72ad88uIqA3grAWAgJAx4uEgjmJag4g/oBS63FqCkPKwXSH1eDXSyxLkHUQX/aqjj8EkuCv++fjCqWf+vY/7yGUJy/341GA1XPVGxePFSkSY55vAiPtDP34MrlKyac7qOKvbdUMxa4aJm93PqTX3z6ZVu8gVB9VhO8aYuKa2TNsckbwMQGzgD2klGYVkOjhd2RidEbtTgs4MK8hTXgoj4uhgbd1M6q3+KXs8OviFW29fsp4TYOcye8ClYvmVoNp6GEEUSlQ34o5a+DqNVl1CcxxiF87H8dQdnZkP03v6VQcnbkzzwzUG3EUCnJZlfnDL+PNHwXFNTA8CHID4Tsjw85jEcwURJJebAAJt6JVW6LJOyZWEtAiQuIUEg/b0YEpRH+PyLqDMdtMAsMlqjErAODyaRvVm17FgK2kJi+wqIn7GUvdAq1OKRIXjEvCovVDBkJeBMV7w7SbIir7kwGP6+JiDr76k+VxaXhL2vEE9MM0PrKVBINim02A8fcmiFEuo=
X-Forefront-Antispam-Report: CIP:12.22.5.238;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230001)(4636009)(36840700001)(40470700004)(46966006)(26005)(2616005)(921005)(36756003)(40460700003)(316002)(356005)(70586007)(186003)(336012)(81166007)(54906003)(110136005)(7416002)(8936002)(5660300002)(86362001)(83380400001)(82310400004)(2906002)(36860700001)(6666004)(70206006)(47076005)(8676002)(4326008)(1076003)(426003)(508600001)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Feb 2022 09:23:59.0875
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 618b1dd8-d7dc-4361-6cf9-08d9fa9c0d24
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.238];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT003.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR12MB5456
X-Spam-Status: No, score=-1.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

After cited commit optimizted hw insertion, flow table entries are
populated with ifindex information which was intended to only be used
for HW offload. This tuple ifindex is hashed in the flow table key, so
it must be filled for lookup to be successful. But tuple ifindex is only
relevant for the netfilter flowtables (nft), so it's not filled in
act_ct flow table lookup, resulting in lookup failure, and no SW
offload and no offload teardown for TCP connection FIN/RST packets.

To fix this, add new tc ifindex field to tuple, which will
only be used for offloading, not for lookup, as it will not be
part of the tuple hash.

Fixes: 9795ded7f924 ("net/sched: act_ct: Fill offloading tuple iifidx")
Signed-off-by: Paul Blakey <paulb@nvidia.com>
---
Changelog:
   v3->v4:
     Accidently sent v2 as v3, Resent with correct patch as v4.
   v2->v3:
     As suggested by pablo, moved tc specific hardware offload related ifindex
     to a tc specific field, so wont be part of hash/lookup.
   v1->v2:
     Replaced flag withdx being zero at lookup().
     Fixed commit msg Fixes header subject

 include/net/netfilter/nf_flow_table.h |  6 +++++-
 net/netfilter/nf_flow_table_offload.c |  6 +++++-
 net/sched/act_ct.c                    | 13 +++++++++----
 3 files changed, 19 insertions(+), 6 deletions(-)

diff --git a/include/net/netfilter/nf_flow_table.h b/include/net/netfilter/nf_flow_table.h
index a3647fadf1cc..bd59e950f4d6 100644
--- a/include/net/netfilter/nf_flow_table.h
+++ b/include/net/netfilter/nf_flow_table.h
@@ -96,6 +96,7 @@ enum flow_offload_xmit_type {
 	FLOW_OFFLOAD_XMIT_NEIGH,
 	FLOW_OFFLOAD_XMIT_XFRM,
 	FLOW_OFFLOAD_XMIT_DIRECT,
+	FLOW_OFFLOAD_XMIT_TC,
 };
 
 #define NF_FLOW_TABLE_ENCAP_MAX		2
@@ -127,7 +128,7 @@ struct flow_offload_tuple {
 	struct { }			__hash;
 
 	u8				dir:2,
-					xmit_type:2,
+					xmit_type:3,
 					encap_num:2,
 					in_vlan_ingress:2;
 	u16				mtu;
@@ -142,6 +143,9 @@ struct flow_offload_tuple {
 			u8		h_source[ETH_ALEN];
 			u8		h_dest[ETH_ALEN];
 		} out;
+		struct {
+			u32		iifidx;
+		} tc;
 	};
 };
 
diff --git a/net/netfilter/nf_flow_table_offload.c b/net/netfilter/nf_flow_table_offload.c
index b561e0a44a45..fc4265acd9c4 100644
--- a/net/netfilter/nf_flow_table_offload.c
+++ b/net/netfilter/nf_flow_table_offload.c
@@ -110,7 +110,11 @@ static int nf_flow_rule_match(struct nf_flow_match *match,
 		nf_flow_rule_lwt_match(match, tun_info);
 	}
 
-	key->meta.ingress_ifindex = tuple->iifidx;
+	if (tuple->xmit_type == FLOW_OFFLOAD_XMIT_TC)
+		key->meta.ingress_ifindex = tuple->tc.iifidx;
+	else
+		key->meta.ingress_ifindex = tuple->iifidx;
+
 	mask->meta.ingress_ifindex = 0xffffffff;
 
 	if (tuple->encap_num > 0 && !(tuple->in_vlan_ingress & BIT(0)) &&
diff --git a/net/sched/act_ct.c b/net/sched/act_ct.c
index f99247fc6468..0d779e48e78d 100644
--- a/net/sched/act_ct.c
+++ b/net/sched/act_ct.c
@@ -361,6 +361,13 @@ static void tcf_ct_flow_table_put(struct tcf_ct_params *params)
 	}
 }
 
+static void tcf_ct_flow_tc_ifidx(struct flow_offload *entry,
+				 struct nf_conn_act_ct_ext *act_ct_ext, u8 dir)
+{
+	entry->tuplehash[dir].tuple.xmit_type = FLOW_OFFLOAD_XMIT_TC;
+	entry->tuplehash[dir].tuple.tc.iifidx = act_ct_ext->ifindex[dir];
+}
+
 static void tcf_ct_flow_table_add(struct tcf_ct_flow_table *ct_ft,
 				  struct nf_conn *ct,
 				  bool tcp)
@@ -385,10 +392,8 @@ static void tcf_ct_flow_table_add(struct tcf_ct_flow_table *ct_ft,
 
 	act_ct_ext = nf_conn_act_ct_ext_find(ct);
 	if (act_ct_ext) {
-		entry->tuplehash[FLOW_OFFLOAD_DIR_ORIGINAL].tuple.iifidx =
-			act_ct_ext->ifindex[IP_CT_DIR_ORIGINAL];
-		entry->tuplehash[FLOW_OFFLOAD_DIR_REPLY].tuple.iifidx =
-			act_ct_ext->ifindex[IP_CT_DIR_REPLY];
+		tcf_ct_flow_tc_ifidx(entry, act_ct_ext, FLOW_OFFLOAD_DIR_ORIGINAL);
+		tcf_ct_flow_tc_ifidx(entry, act_ct_ext, FLOW_OFFLOAD_DIR_REPLY);
 	}
 
 	err = flow_offload_add(&ct_ft->nf_ft, entry);
-- 
2.30.1


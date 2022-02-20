Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A735F4BCDB6
	for <lists+netdev@lfdr.de>; Sun, 20 Feb 2022 11:21:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241303AbiBTJf3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 20 Feb 2022 04:35:29 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:44602 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232377AbiBTJf2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 20 Feb 2022 04:35:28 -0500
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2089.outbound.protection.outlook.com [40.107.237.89])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 985384F9F0;
        Sun, 20 Feb 2022 01:35:07 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dabJu8lfHUakZsWHOYtn1cONsW5lkFpCaqN9OakERXki4cyfjioPTSVMaq1ePdZqUp35X1T4kOeDjNsDtTLx3v1VFe0Qa+etVbS6EiOq3+8ZqIXZTLqwW7Rrq1qDr14gHa1Z1CSdKQo3WEgkLrp1FM3xobEvKTkdOqPt2DCC1BBg0p9CKCxHm1U/f61Qfmskz6cIx0US/J6hmZnzjlnh5lZp93CO5FxzzVWGTgIkBt6WDB/hOoyRTMT0jc1/H68BR07pW4wy5hj8CH46jHRv8UCD3QODKf/YGx3RCC9HuUSLBka6tCGnevR0KaGYTfJ9DFRqWUQ/ih3xrg0BnGtf+w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=SRTVYBnCO4iIJ5Sz6NkUr00IVoKKnPeO7WKnF0SsgRk=;
 b=XHASqmupGU085EuR2+hhJp5kCpkXqy5tYIBoUq4VjgHL/NOvYCtUra5ORE5mOSaGawSErhK7BCHlj0oeNpUXVm89GMFcl+eS5GmaxPS2BprnDnzPiFqOuUbhmRkDbb5jTMuEUdkjhDbOQKK9wk7t9Az0x0qh5chymoxt1HCPhGkBTVq+VzYWE5ZTGS7t9Yvl1fyu15cg8FGETAUhcrYR9Hg9K0DF+AtcLC6RFN7bwrECNMiKLNo8t15P7z/RI0L1GBViOqiLbcgc+iJZN0iXAVMzrklyQ15500VGANy0W9SSvsS79LRlyZTOcD+EsyMYDcE0vFHrQV+s7240oLoz7g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.238) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=SRTVYBnCO4iIJ5Sz6NkUr00IVoKKnPeO7WKnF0SsgRk=;
 b=kSt6wseIIGRQ/f1CbiZepumUcXS3Ilrl5M+oG3Ic62K5Y3n1Kp3UhwFQ1cen9/Dn5plYhTYXrHJc7mPBUM8XioUFlDT0R5I2BAgEhkw6GtyJMBImD4d+lJHcHuhx5LJaG8etxgUagRs3/hqLeePSFcpKLgaFXt4sP7AXCeQpilt9QRFZfZaD+pYATBFNy96EPwIuiLCJdM9P9S5DOHvYBVqBcLLIqpq4MAz0PTifv2m3Sme3G9UK60d3r0zBpW75u9yshrsWC1JazKdTi1y5iN2fTwWKK57/4CAF0uHoDvcTsoz0qeYPOKxnfOT/DE6zSdlf92sqFPjFAROrF2VDPQ==
Received: from BN9P222CA0002.NAMP222.PROD.OUTLOOK.COM (2603:10b6:408:10c::7)
 by SA0PR12MB4368.namprd12.prod.outlook.com (2603:10b6:806:9f::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4995.17; Sun, 20 Feb
 2022 09:35:05 +0000
Received: from BN8NAM11FT047.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:10c:cafe::f9) by BN9P222CA0002.outlook.office365.com
 (2603:10b6:408:10c::7) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4995.16 via Frontend
 Transport; Sun, 20 Feb 2022 09:35:05 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.238)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.238 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.238; helo=mail.nvidia.com;
Received: from mail.nvidia.com (12.22.5.238) by
 BN8NAM11FT047.mail.protection.outlook.com (10.13.177.220) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4995.15 via Frontend Transport; Sun, 20 Feb 2022 09:35:04 +0000
Received: from rnnvmail205.nvidia.com (10.129.68.10) by DRHQMAIL105.nvidia.com
 (10.27.9.14) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Sun, 20 Feb
 2022 09:35:03 +0000
Received: from rnnvmail203.nvidia.com (10.129.68.9) by rnnvmail205.nvidia.com
 (10.129.68.10) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.9; Sun, 20 Feb 2022
 01:35:03 -0800
Received: from reg-r-vrt-019-180.mtr.labs.mlnx (10.127.8.11) by
 mail.nvidia.com (10.129.68.9) with Microsoft SMTP Server id 15.2.986.9 via
 Frontend Transport; Sun, 20 Feb 2022 01:34:58 -0800
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
Subject: [PATCH net v2 1/1] net/sched: act_ct: Fix flow table lookup failure with no originating ifindex
Date:   Sun, 20 Feb 2022 11:32:26 +0200
Message-ID: <20220220093226.15042-1-paulb@nvidia.com>
X-Mailer: git-send-email 2.30.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 7c9108fc-26dd-421d-0cbe-08d9f45446b8
X-MS-TrafficTypeDiagnostic: SA0PR12MB4368:EE_
X-Microsoft-Antispam-PRVS: <SA0PR12MB4368D6DCC7BF9A181D692790C2399@SA0PR12MB4368.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 2YSTCxvTlL7yFSDL2nAFSQIMFrkf3ebMS40xXt0BGpw4Os8n+zqljPn73xhRMIB04NbFtyUOXf8y2Yzz76KgQWvVG8jx2Sj/ulYp3+vCgSqFrBI5wlONjz3H3OUfBGKdi+NYyNiA6CLp+yRXZ4E2j2lkdvnla3fWnt37rbhnBFu2YmQK7dtQzoBqTE0Ftw5S3f43tNy2yK2n6Rtp89y+kXMvPtmKAGeR8HWLPx8r7JgQ+/cBCmqe6zx2ewpptkWb116dimEbwBKB+XoGMVQDwap//X0pUpecoYliFT1zTjn4FhhxQpwrpqOSpd7xPEKbVWiHnSe0KsSiXt7hUAG4WpPNQdMy1S1cPUTz/TyU2o9WXpoBGyBNVCzK3pC6vhNtWhbkV6Ma7BJqfYg9f1QeVzoSqXgJKicIHjH38ZbzWJ0W8V+rYUlQXcxytlg6mpPOi8tQyQL8un1A2pz3otqk4OcxGrEQH8ci9lA6g2bbjjDL3K+00HzXDPebBU1wgoMfNPmzRIZW3ocKRiUA5j9KSKQZSNP7UxaLhKgxDnemD2UuPf6YtYNw35vF8FsS43nxYIo/I6+MnwxD/7tGl7KLnbtJ/yGke/inpJ5RSxzjmfMQRPFkmxfnJ8h1xRjEcfJH0F+iWqY8Py7E3WOLN5CcMqB2YyI/4Fu6CwRJu+7v7y5Ze9fKeYkGnrK9uW/dLWjvbAV2OywiT1ROkc26rRBdfp3HAKN5k3sz/17gx77EOpE=
X-Forefront-Antispam-Report: CIP:12.22.5.238;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230001)(4636009)(46966006)(36840700001)(40470700004)(36860700001)(83380400001)(36756003)(47076005)(40460700003)(186003)(26005)(1076003)(2906002)(81166007)(356005)(426003)(336012)(921005)(70206006)(70586007)(7416002)(8676002)(5660300002)(2616005)(6666004)(4326008)(8936002)(508600001)(86362001)(110136005)(316002)(82310400004)(54906003)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Feb 2022 09:35:04.8658
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 7c9108fc-26dd-421d-0cbe-08d9f45446b8
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.238];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT047.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR12MB4368
X-Spam-Status: No, score=-1.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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

To fix this, remove ifindex from hash, and allow lookup without
the ifindex. Act ct will lookup without the ifindex filled.

Fixes: 9795ded7f924 ("net/sched: act_ct: Fill offloading tuple iifidx")
Signed-off-by: Paul Blakey <paulb@nvidia.com>
---
 Changelog:
    v1->v2:
        Replaced flag with iifidx being zero at lookup().
        Fixed commit msg Fixes header subject

 include/net/netfilter/nf_flow_table.h | 3 +--
 net/netfilter/nf_flow_table_core.c    | 3 +++
 2 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/include/net/netfilter/nf_flow_table.h b/include/net/netfilter/nf_flow_table.h
index a3647fadf1cc..61dc5e833557 100644
--- a/include/net/netfilter/nf_flow_table.h
+++ b/include/net/netfilter/nf_flow_table.h
@@ -114,8 +114,6 @@ struct flow_offload_tuple {
 		__be16			dst_port;
 	};
 
-	int				iifidx;
-
 	u8				l3proto;
 	u8				l4proto;
 	struct {
@@ -126,6 +124,7 @@ struct flow_offload_tuple {
 	/* All members above are keys for lookups, see flow_offload_hash(). */
 	struct { }			__hash;
 
+	int				iifidx;
 	u8				dir:2,
 					xmit_type:2,
 					encap_num:2,
diff --git a/net/netfilter/nf_flow_table_core.c b/net/netfilter/nf_flow_table_core.c
index b90eca7a2f22..01d32f08a1fd 100644
--- a/net/netfilter/nf_flow_table_core.c
+++ b/net/netfilter/nf_flow_table_core.c
@@ -257,6 +257,9 @@ static int flow_offload_hash_cmp(struct rhashtable_compare_arg *arg,
 	const struct flow_offload_tuple *tuple = arg->key;
 	const struct flow_offload_tuple_rhash *x = ptr;
 
+	if (tuple->iifidx && tuple->iifidx != x->tuple.iifidx)
+		return 1;
+
 	if (memcmp(&x->tuple, tuple, offsetof(struct flow_offload_tuple, __hash)))
 		return 1;
 
-- 
2.30.1


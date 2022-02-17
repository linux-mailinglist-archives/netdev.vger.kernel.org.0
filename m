Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BC4664B9C1B
	for <lists+netdev@lfdr.de>; Thu, 17 Feb 2022 10:35:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238729AbiBQJfa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Feb 2022 04:35:30 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:34692 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229598AbiBQJf3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Feb 2022 04:35:29 -0500
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2067.outbound.protection.outlook.com [40.107.92.67])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 12E07996B9;
        Thu, 17 Feb 2022 01:35:15 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=aT18mRD/M5MSxzCBNA32imxK1LOCajjijzurYcDsqfYsbbdT/q7zhfVG/R3VTTbhh6n2koMCq8RdHnb+mNtCa92tb2p/NPt+w1Dl78XDZKF71m62w2u3IyGeHFroRNDsqXr3uKa0Fr3+3v1PyPWRZ3Fie9B/cmtDI3YxoIUfVYuDJMd86RdbJgdDfiihOJ2gMaY9lUqmx1y454zwgz7wU7sHVimUDB0g+pKR6xBKSep/lBntwUKbRNJeqns6IADlgb+RmC4X8EYoxqZVgtlakdW39N6MRYgpViUf13M2F1aee6NqXiF1tYcq14Ofuk/2vhNu7lI31nDRxg9e7OnO8w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=JnLEV5KQpNWPRckROtwcg1vt2RRHqvxlZNSxDlpW0iE=;
 b=RNhTa8LQAZnbCbHFmAAw4tsyca+JaP7hL5AY8QjUksw4RTeen7pzht0jV3oUmNxFwcPydnoA6WoY2yZ+rAJRJvcIM39OKQoSlEE0UIzML7kcdAkgAuF/QirdaBjlHScoHgpbNA164JI+s9Hi41a+TjmPjcVsx8Sek1XkXNlZSd5TK9xGkH/Z+A/dhPoHSaQ90s7ZGruQxTlyFB5TmMMynw+e2TfR/VLVnauk5mUgFREGE25KAGCZ3daq9NmpGlZRExaNwEF76RHwapJDyY+uCYNzwZNED6soOehwxLj2xVNA56RMdoEax4VA8of+eglt+EnxCBCwyLWoAgn9NoiEpw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.234) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JnLEV5KQpNWPRckROtwcg1vt2RRHqvxlZNSxDlpW0iE=;
 b=EZXwG92YEPqcx02CFZRGWC9KlQuuQ3VAaLaQNKELKJpN9Duwu9zyJjDFhup46AFoyNL/N2ZHWjzMOQerxQtQtzXaCCyltmq75StzVMPQUs012uFRB/aw+RLWAEYt1VzysnuH3S3033Dz1rU5EW+ln8aJ48JssQ5tUi1CyrSDNwk9Z2WUi2e1dO27V87T7L9Lvl6RACRY5BJIHj7DOJkSW9sJWn2ty/j+M0y4izFIRDL6XZH7MARUOhlKr45AC4iHSNfkMMjyAX3/6F5ypFcFpUSVLso2DqvEu29ZmMroIHLByLEOVAxSgAtD81Q3f8j4mmT36t13bm+FstBm4fauXQ==
Received: from CO1PR15CA0086.namprd15.prod.outlook.com (2603:10b6:101:20::30)
 by CH2PR12MB5020.namprd12.prod.outlook.com (2603:10b6:610:65::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4995.16; Thu, 17 Feb
 2022 09:35:13 +0000
Received: from CO1NAM11FT007.eop-nam11.prod.protection.outlook.com
 (2603:10b6:101:20:cafe::a9) by CO1PR15CA0086.outlook.office365.com
 (2603:10b6:101:20::30) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4975.11 via Frontend
 Transport; Thu, 17 Feb 2022 09:35:13 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.234)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.234 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.234; helo=mail.nvidia.com;
Received: from mail.nvidia.com (12.22.5.234) by
 CO1NAM11FT007.mail.protection.outlook.com (10.13.174.131) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4995.15 via Frontend Transport; Thu, 17 Feb 2022 09:35:12 +0000
Received: from rnnvmail202.nvidia.com (10.129.68.7) by DRHQMAIL101.nvidia.com
 (10.27.9.10) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Thu, 17 Feb
 2022 09:34:36 +0000
Received: from rnnvmail203.nvidia.com (10.129.68.9) by rnnvmail202.nvidia.com
 (10.129.68.7) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.9; Thu, 17 Feb 2022
 01:34:35 -0800
Received: from reg-r-vrt-019-180.mtr.labs.mlnx (10.127.8.11) by
 mail.nvidia.com (10.129.68.9) with Microsoft SMTP Server id 15.2.986.9 via
 Frontend Transport; Thu, 17 Feb 2022 01:34:31 -0800
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
Subject: [PATCH net 1/1] net/sched: act_ct: Fix flow table lookup failure with no originating ifindex
Date:   Thu, 17 Feb 2022 11:34:24 +0200
Message-ID: <20220217093424.23601-1-paulb@nvidia.com>
X-Mailer: git-send-email 2.30.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 8b18e57b-e6cd-4862-8ff5-08d9f1f8cc2e
X-MS-TrafficTypeDiagnostic: CH2PR12MB5020:EE_
X-Microsoft-Antispam-PRVS: <CH2PR12MB50209CF49B7B99F162EA0322C2369@CH2PR12MB5020.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:1284;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Sl0Kx1ZCUqq2rha0Ipxzb7AOe6gKDvUuB73oRrCHwUt4PCnkKDKHkypjwj8k0MFu1o2A5YxxX17FF/fwRLPI84pHkcZET+qvypd64sfggBo2VU5jq1d0J9nEpIrKWm8eD9NPL8H3jzo2rYakEieyPN1XNUMYxoNh8ZDBkCOW4VvIsZhW8SOgOT2saGVnFYlZv9WerXpdbau6bv6P/SpxuiUutDSpeZyU5k2mdtdIZDpqZU3nDS6JjrCky5TdJmmPkLbyKSi//DnfK3xzyvrqBk2ZZNpvu3YBjp7NI/PGlRBmFdf8fHZUBQeG0U5o3M8QMtvLGUQ50hT3dJ2hogEduZ3Y1BHu7kdISSmphDcMphceCArkZPBARY+8wBlnXh4SIVVJMBo+PpVdxVdwnRtSYSjaDVM/dt6FFG8bmDgbPCOAR9pJj0GyG5XVIimIxUtaVuWTC52RM9eODNaW9Yz1lLRqyo6+7ZYuCV3qyBbXJ4okzk8cGLQ8tEQQ4ogdYTPPJpiFKX+3DNOk65qPZYX5VKve6TL+UTpjuaaadGCSvh3gjv2cEjlsuUjvCb4xCzUWnZSkEsfg8xo2FjYqz1R1XZCBGFoMcguqIN6OQKFeE5DW+jlpm2iFUjfiaRqtNI8ceSW71cWoVcSHRTaQvXLmxb02o4svYrGk08PVWaTfZXxdn0UjQ1mm/krwaR+/g/bnH2IQJNpFBEzox3zI250G3J9mpjc4JXwbgZ1R3KtkU/A=
X-Forefront-Antispam-Report: CIP:12.22.5.234;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230001)(4636009)(40470700004)(36840700001)(46966006)(426003)(336012)(186003)(83380400001)(1076003)(2616005)(47076005)(6666004)(36756003)(26005)(2906002)(8676002)(356005)(7416002)(5660300002)(8936002)(81166007)(921005)(4326008)(86362001)(508600001)(110136005)(36860700001)(54906003)(70586007)(70206006)(82310400004)(40460700003)(316002)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Feb 2022 09:35:12.7704
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 8b18e57b-e6cd-4862-8ff5-08d9f1f8cc2e
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.234];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT007.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR12MB5020
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

To fix this, allow flow tables that don't hash the ifindex.
Netfilter flow tables will keep using ifindex for a more specific
offload, while act_ct will not.

Fixes: 9795ded7f924 ("net/sched: act_ct: Fill offloading tupledx")
Signed-off-by: Paul Blakey <paulb@nvidia.com>
---
 include/net/netfilter/nf_flow_table.h | 8 ++++----
 net/netfilter/nf_flow_table_core.c    | 6 ++++++
 net/sched/act_ct.c                    | 3 ++-
 3 files changed, 12 insertions(+), 5 deletions(-)

diff --git a/include/net/netfilter/nf_flow_table.h b/include/net/netfilter/nf_flow_table.h
index a3647fadf1cc..9b474414a936 100644
--- a/include/net/netfilter/nf_flow_table.h
+++ b/include/net/netfilter/nf_flow_table.h
@@ -64,8 +64,9 @@ struct nf_flowtable_type {
 };
 
 enum nf_flowtable_flags {
-	NF_FLOWTABLE_HW_OFFLOAD		= 0x1,	/* NFT_FLOWTABLE_HW_OFFLOAD */
-	NF_FLOWTABLE_COUNTER		= 0x2,	/* NFT_FLOWTABLE_COUNTER */
+	NF_FLOWTABLE_HW_OFFLOAD			= 0x1,	/* NFT_FLOWTABLE_HW_OFFLOAD */
+	NF_FLOWTABLE_COUNTER			= 0x2,	/* NFT_FLOWTABLE_COUNTER */
+	NF_FLOWTABLE_NO_IFINDEX_FILTERING	= 0x4,	/* Only used by act_ct */
 };
 
 struct nf_flowtable {
@@ -114,8 +115,6 @@ struct flow_offload_tuple {
 		__be16			dst_port;
 	};
 
-	int				iifidx;
-
 	u8				l3proto;
 	u8				l4proto;
 	struct {
@@ -126,6 +125,7 @@ struct flow_offload_tuple {
 	/* All members above are keys for lookups, see flow_offload_hash(). */
 	struct { }			__hash;
 
+	int				iifidx;
 	u8				dir:2,
 					xmit_type:2,
 					encap_num:2,
diff --git a/net/netfilter/nf_flow_table_core.c b/net/netfilter/nf_flow_table_core.c
index b90eca7a2f22..f0cb2c7075c0 100644
--- a/net/netfilter/nf_flow_table_core.c
+++ b/net/netfilter/nf_flow_table_core.c
@@ -254,9 +254,15 @@ static u32 flow_offload_hash_obj(const void *data, u32 len, u32 seed)
 static int flow_offload_hash_cmp(struct rhashtable_compare_arg *arg,
 					const void *ptr)
 {
+	const struct nf_flowtable *flow_table = container_of(arg->ht, struct nf_flowtable,
+							     rhashtable);
 	const struct flow_offload_tuple *tuple = arg->key;
 	const struct flow_offload_tuple_rhash *x = ptr;
 
+	if (!(flow_table->flags & NF_FLOWTABLE_NO_IFINDEX_FILTERING) &&
+	    x->tuple.iifidx != tuple->iifidx)
+		return 1;
+
 	if (memcmp(&x->tuple, tuple, offsetof(struct flow_offload_tuple, __hash)))
 		return 1;
 
diff --git a/net/sched/act_ct.c b/net/sched/act_ct.c
index f99247fc6468..22cd32ec9889 100644
--- a/net/sched/act_ct.c
+++ b/net/sched/act_ct.c
@@ -305,7 +305,8 @@ static int tcf_ct_flow_table_get(struct tcf_ct_params *params)
 
 	ct_ft->nf_ft.type = &flowtable_ct;
 	ct_ft->nf_ft.flags |= NF_FLOWTABLE_HW_OFFLOAD |
-			      NF_FLOWTABLE_COUNTER;
+			      NF_FLOWTABLE_COUNTER |
+			      NF_FLOWTABLE_NO_IFINDEX_FILTERING;
 	err = nf_flow_table_init(&ct_ft->nf_ft);
 	if (err)
 		goto err_init;
-- 
2.30.1


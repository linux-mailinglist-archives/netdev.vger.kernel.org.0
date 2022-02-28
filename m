Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C4AF04C6587
	for <lists+netdev@lfdr.de>; Mon, 28 Feb 2022 10:17:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232804AbiB1JRh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Feb 2022 04:17:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58030 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229627AbiB1JRg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Feb 2022 04:17:36 -0500
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (mail-sn1anam02on2056.outbound.protection.outlook.com [40.107.96.56])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CC1B645ADD;
        Mon, 28 Feb 2022 01:16:58 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Vo9i5bKekdSa53q4L4qgNf2TVJph84JcLbCr2aD05Xf1LeoRttQ9cDfAqQrE1pTPaVBYIjbitdkbhw/1HS6Yy2APIB+k6WXbryp9/k67XVfZgB+b63Y6pn+YKCBzIDWujfUr+PXR3sUyQCLtWWh22wByhJrwfRSTQw9Re5q9P1dZ2+KHY0fKgTJsa4o9geNhSnHLLrclxiS+MIyQ2gIDrAV35H9PhzHA7i1JsrDwcrN1RzJTJxY1dHak4Pwkdd+C8lz6prDvWpscxM+2GAl+qgqIWh4LBc93qat10zv0u3qR9vKWjvASbyxKnrpJZVXyXQ7NEotKVQfY5OPjRRbV4Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Bi2aFOEfKQHhtGhnefFet49Nn+2HdyILh9zxHt1vico=;
 b=mOiqLl2HlVd5yR5kI9SjZRKyzVufh2PrObY5IijNZt31XXIOKjD9rmqKPhkUpQvf2uCqYEY6WKlHKAV36KxbeOkz0ECam7a1Wt7xFmLdTWQuA9uSGYhCKUcrqe+y2tN4Mv1I+3MHsOZSK7X7ZgVB8jM9vcG1o6cx3mMZN1QejBIx0wjMTsLgF8heeFaJwSlbO1pzTQnNjWB7h1DSi/5TPxDKs6o/X18MLHsP/DuGmPOfHpA6XpS6Wd5UcyskyPbU+n+yHz2NR1RQUqifs6CosoFsJwLKsmGkItd33sKheUzzRS1R/G87+SniNH5rzecEn9JYxhE2S6HMKCl6g4q3DA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.236) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Bi2aFOEfKQHhtGhnefFet49Nn+2HdyILh9zxHt1vico=;
 b=Bo8W3EQ3sBEFF6BARMFyPNMQp96o2f9/Jji5I7KiTC1UyhM6jply0UC9LDl+2+vrlunTwN1fBAJgYsqafM4g1qfL7JQ1tvcDDxXRICRSpGzbB9N3fL0PBAFaygyfe0Tq4SH15o0ZABmrWZHgauqb+Vw+g/AmbXnugVFhaSarZe+ulUxLAs41HbkYhFRjbbXe02PjlUNfelTYHrO7THKPi8FBP8r6plPGxXhNi9JCdWatv9RMJ911CwksLpnWmbiVG7ijpp5lqqkOaz/qcroTxInaRDaHMkMA0mzINA1lNd2+BSVLkrZ+rsAGFiHm3csvTR1RVZjTcx8gpbD6fN+GwQ==
Received: from MW4PR03CA0015.namprd03.prod.outlook.com (2603:10b6:303:8f::20)
 by SN6PR12MB4750.namprd12.prod.outlook.com (2603:10b6:805:e3::25) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5017.25; Mon, 28 Feb
 2022 09:16:56 +0000
Received: from CO1NAM11FT019.eop-nam11.prod.protection.outlook.com
 (2603:10b6:303:8f:cafe::9f) by MW4PR03CA0015.outlook.office365.com
 (2603:10b6:303:8f::20) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5017.21 via Frontend
 Transport; Mon, 28 Feb 2022 09:16:55 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.236)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.236 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.236; helo=mail.nvidia.com;
Received: from mail.nvidia.com (12.22.5.236) by
 CO1NAM11FT019.mail.protection.outlook.com (10.13.175.57) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.5017.22 via Frontend Transport; Mon, 28 Feb 2022 09:16:55 +0000
Received: from rnnvmail205.nvidia.com (10.129.68.10) by DRHQMAIL109.nvidia.com
 (10.27.9.19) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Mon, 28 Feb
 2022 09:16:55 +0000
Received: from rnnvmail203.nvidia.com (10.129.68.9) by rnnvmail205.nvidia.com
 (10.129.68.10) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.9; Mon, 28 Feb 2022
 01:16:53 -0800
Received: from reg-r-vrt-019-180.mtr.labs.mlnx (10.127.8.11) by
 mail.nvidia.com (10.129.68.9) with Microsoft SMTP Server id 15.2.986.9 via
 Frontend Transport; Mon, 28 Feb 2022 01:16:50 -0800
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
Subject: [PATCH net v3 1/1] net/sched: act_ct: Fix flow table lookup failure with no originating ifindex
Date:   Mon, 28 Feb 2022 11:16:46 +0200
Message-ID: <20220228091646.3059-1-paulb@nvidia.com>
X-Mailer: git-send-email 2.30.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: c2b90dc2-a93a-4992-34aa-08d9fa9b10c5
X-MS-TrafficTypeDiagnostic: SN6PR12MB4750:EE_
X-Microsoft-Antispam-PRVS: <SN6PR12MB4750AE1EC6FFFFD87EC25225C2019@SN6PR12MB4750.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: dbeFBgFIjWDoVWxaQCJtmQlJ+dXgh9g6dFQRf8hycAej/tUfTjIxNECWSdMd/5wrIsYRv1bJJ3eU08bJlhTF36Wuxh/TtUHB4N9xVLzxm/AZCcJ695gzc836qA0cqhhgpFrmNnHjhtj6YCcrve9V0wWnNhq4bnD8mJMkrH1xgv1sNuYoEMf4Xxhj06dBPD4sYiYHGxmKcruQpqzZrAMDrKAM6rZfG2GbErhGoamZtCo3PAHY4u2dY4yX48ybTf66Z8iArACOx9nlqFyPywavKVQTp4QmpMPvVvB5bCRZR3kYF6qRZJetI7A+RyleJU3OM0IhjQgbMXNOlcTPiwTW1Kpx2GJHdGIM1IcuWARV1uY25Bdnj2p2vzN+uHf7Q3vbwo6BG1v1QjiJz0eNbG1nhStmLdHNF9yW1BdAtklZMDdVyUuE5AW/M17r8rviiKy81RGaIRJFkzSdyhQv0gn4gOXAs1sDS39giiAXJXN3hbKV7DWDYywRjagRhWau/IAu0GTxs2AH16Ky+caOfDpz7tqtu9XEVPE9dE/IGL9jzPtBBEgm029+XJe1LPAreSV0EN8M13p0g97HKmmOhabw/zBwx6QGS2TAS0qvkb5kGfuXEmkoXKYq0xZNEGbDTgNq7gIJADCCgbmjVQB5qAdRwCxDDTGd8PyIfoaHR6U+bN9SlH741RG1eJVaGyKOuqU6DFD1dAzKGwqhqltH2gcbn6CMq1pGsHbUmEkZATjCCK4=
X-Forefront-Antispam-Report: CIP:12.22.5.236;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230001)(4636009)(40470700004)(46966006)(36840700001)(8936002)(86362001)(36860700001)(47076005)(54906003)(508600001)(82310400004)(110136005)(70206006)(6666004)(70586007)(40460700003)(4326008)(8676002)(316002)(26005)(186003)(1076003)(426003)(336012)(81166007)(356005)(921005)(5660300002)(7416002)(2906002)(2616005)(83380400001)(36756003)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Feb 2022 09:16:55.6776
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: c2b90dc2-a93a-4992-34aa-08d9fa9b10c5
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.236];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT019.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR12MB4750
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

To fix this, remove ifindex from hash, and allow lookup without
the ifindex. Act ct will lookup without the ifindex filled.

Fixes: 9795ded7f924 ("net/sched: act_ct: Fill offloading tuple iifidx")
Signed-off-by: Paul Blakey <paulb@nvidia.com>
---
Changelog:
   v2->v3:
     As suggested by pablo, moved tc specific hardware offload related ifindex
     to a tc specific field, so wont be part of hash/lookup.
   v1->v2:
     Replaced flag withdx being zero at lookup().
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


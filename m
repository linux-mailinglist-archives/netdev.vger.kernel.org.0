Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C897D5197C6
	for <lists+netdev@lfdr.de>; Wed,  4 May 2022 09:03:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345194AbiEDHG5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 May 2022 03:06:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33440 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345172AbiEDHGx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 May 2022 03:06:53 -0400
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2042.outbound.protection.outlook.com [40.107.244.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1E4AF21817
        for <netdev@vger.kernel.org>; Wed,  4 May 2022 00:03:19 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=YhslzGEavaGwnvULOWGR2xHBjEv901m90U5RkeNUdntoyxQT3sAKCWt02SLCYzyB/9nbc0PMH3aiYmUDHlDIqU4AJDENDefXTKLnzDQkj9XhmIIMXK97tBLr1zllmA2tAzqmJetafQhGuY4wvEmzcRq6AZgIh/gQ58LK9Q1vmZdGjoPE0yA3wQRqIg7/605xV2R/JJ+kEXokD/oVN+/7zv8jolxaifS3BlP11pFWJviaErgIUgATJPnSjbqBnWbGxv+OhzU27GEDsvWaLfIGB2Hb8lZRlwdeukRGPFF0p10ApBlmZ8Wdlp66aOiDfameiF8RCsFsQp/LMz0UWdsRsw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=SPnrZrnOSNvUmjt9Ik4MUjCMYfwyHK6H3rwngFtKNvg=;
 b=KvZKLWDplBh+BfyNYXILWa5mNWcRs2lFZsEQzexkWPfpwDiePG2Bewk/Sla6iA8PXhVS7bkQ9MsMAPWg/zd9FPaaaGSRBoXucVUKYLSwyC4I32InAoB6tGtKO71D9UlamXxoo0RhR0eBlyOQxGMCM2uNTOMb50GAAMYAf4JZQI9qIeq+JO1WsHz5YdiWOZ6x0o1UmF8Ttk/C8u1qg7VYGKVRBqqslaqlmhYdiyIWeHZbAv+6pN5NVvlGdqZcEjXG7FbVhtpjBgLzxQxqIujNpBF6nlnflr5e+9kqlB5UjFX2NmugmztQHACIuG8TsqH7nCxned1+BbigL59pCsqviA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=SPnrZrnOSNvUmjt9Ik4MUjCMYfwyHK6H3rwngFtKNvg=;
 b=IziTb6zoIhlEP6mAvt1SEslhoYspCP13TITtZ9CWa+DlKs1XgQiaY8bKh3Y+zEZq9NTo2WcsyaGyYZsKKU12Yc2wPYDil/73HpOHsu4SvR4Y028qdJ8BieKcpwg/HxJsRTHgTN8CdzbpWIo/eQOsmd8B9QD2oSPJ+BiLxJJHhm57l9U3P7unq3auCsD0hp8Ohjlqc2kC8sKdASKAVMJYpHKwqzkX1awdDJ1j/f9TZrrp7UV+nY22mxqi5MFYMz1Dx3sCJZi1QS52jvZegye03dhOfyWL31bjrGPtLak0lkCLOht1fTDi5lvG3HlnWcT0AZo++NcDI2tUnRqySaGaCA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from BY5PR12MB4209.namprd12.prod.outlook.com (2603:10b6:a03:20d::22)
 by PH7PR12MB6586.namprd12.prod.outlook.com (2603:10b6:510:212::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5186.28; Wed, 4 May
 2022 07:03:15 +0000
Received: from BY5PR12MB4209.namprd12.prod.outlook.com
 ([fe80::bcda:499a:1cc1:abca]) by BY5PR12MB4209.namprd12.prod.outlook.com
 ([fe80::bcda:499a:1cc1:abca%4]) with mapi id 15.20.5206.025; Wed, 4 May 2022
 07:03:15 +0000
From:   Saeed Mahameed <saeedm@nvidia.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     netdev@vger.kernel.org, Vlad Buslov <vladbu@nvidia.com>,
        Maor Dickman <maord@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [net 03/15] net/mlx5e: Don't match double-vlan packets if cvlan is not set
Date:   Wed,  4 May 2022 00:02:44 -0700
Message-Id: <20220504070256.694458-4-saeedm@nvidia.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220504070256.694458-1-saeedm@nvidia.com>
References: <20220504070256.694458-1-saeedm@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BYAPR06CA0035.namprd06.prod.outlook.com
 (2603:10b6:a03:d4::48) To BY5PR12MB4209.namprd12.prod.outlook.com
 (2603:10b6:a03:20d::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 03c017f5-c1ac-4981-70b0-08da2d9c28fe
X-MS-TrafficTypeDiagnostic: PH7PR12MB6586:EE_
X-Microsoft-Antispam-PRVS: <PH7PR12MB65863FEFED5E93B36DD45605B3C39@PH7PR12MB6586.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: mTQVKqkoDD/s/3Hq++RPhUhEcdAt9AfFJh3GgBLYxn41CImU+RLihTIRjBh4gjOA2D3MvXumc5Vnll/GtBz0Gw1gK1PQ7PnVNJ7BQnMAx9TuvWHE88gFMrAt8w8D8UiJuU6LyVQVlc6hEQJBqoa/HL+TnxBDYX6E5/HLKeOyGcFYI9/yPY9ZRo5Q2zLjbm6Gkd3CBDpD0i2v/QNTvndYPLM9LYgluYNRWYVi5VMDQiLnFppcNOVvO38Ob1H8rNqVccFAJG7k5B78nIOToYqrEwU/VDmPrksQoHSkesiyQ1kkI196lJdImW/FejoPZYVIfG9yfI643XWtcSJ8GQl+R3obIzIKIJM+0ULndO27d07eLljx1SoTQ9b+5zMqGDQGY2dLtGvsJDkrfQ64nAHDraYclRUP+L/YMOqTySKJMGkiG11ylOqxL2vnKB3u+triYOsjHEpceKGeK0I6g5p7ks/r+5+lUQ/bT2PNiTVkvlVG5/21ZJgdlo+J5Yw35pg1OSTCEviPtSjhWuGD8s2BQVp9kw84p+MhS58E/4ZefNsC0H5++uA87Fk1btcNycG7rp5sHJNvQ78KViwPEsnD8Xt9JPeFXPtZhZEpohyfy9Q0sEpzchcE+SwKygos5MIFuRK9BtvH6YyNXu5PqnN82Q==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR12MB4209.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(316002)(86362001)(83380400001)(36756003)(1076003)(107886003)(186003)(66556008)(66946007)(4326008)(66476007)(8676002)(2616005)(2906002)(8936002)(6512007)(6486002)(38100700002)(5660300002)(110136005)(54906003)(6506007)(508600001)(6666004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?qxRSLFvNK1+jmdak+b6mRN842WPLNfpey1LPI/sdVY48y3/q6VyESu9gEvep?=
 =?us-ascii?Q?1EAQ0XgNICnmW2PNo3+LNRm0FTUrBZBfgSeg1E6jOLdAmemzFcsgJrVq7khK?=
 =?us-ascii?Q?tVLspJstTbHFl78v58C8H//e3U41jGSmfCnqoh2uJOI9oE+hl9ez7dpvpitz?=
 =?us-ascii?Q?PRp2yeEcRzPPcKEQK5kjGYnxJECDgIskEW5EJDObqMED5AfqeZUK1ZKBxNCW?=
 =?us-ascii?Q?VQA2I7MOFgRuvksIVhDgVnzih36MJii3Wop2unpcUY8jRpBRSmA64HrtF2FU?=
 =?us-ascii?Q?xEf11c3rRH8Ztu2oYyr9geJcWEJ1wd4wngEeeys22+7a5eFplQn5ZNHQr8Wa?=
 =?us-ascii?Q?DG/PFeTiHT39HwV3MmUwWXIwcl4v062ocZV8Suk0p52zPsJgyvApy/wfvpt0?=
 =?us-ascii?Q?vx1X0miexSB2gkJPKQjWlUfCRG8BCCVpW0Zzw1VamZOWoQQnzeZ0/5d/qH8q?=
 =?us-ascii?Q?qgbBYE3YSPbMloVap2/a7bnRy+tZ9YISCuyDD49171GZ2Z1wgh9TiLZdGm1w?=
 =?us-ascii?Q?oVvwx+0HSKKEfUXoWt4S9fA5KDYhvT//a/LrI7I/eYLJT3x+PLtOgq5/5zC2?=
 =?us-ascii?Q?K5quom8iZs5Ffjv4aiLnbuNVcnXRc/t+k8mVpd8cey1JaHvAK1d6QBQruCgV?=
 =?us-ascii?Q?ur64lNQaI2ZRRcNT7Oz+H3jtEvfIeWuTCWESTIz9iZl0BbIkRAsvyxx1GtzC?=
 =?us-ascii?Q?sEX0nzR2Jyx8MibnGJeoPziOx1pD8zReD7E2yE+ngiHiNYp5D8AL8S/37EHl?=
 =?us-ascii?Q?cbawCMxsagZzbeP+i3AWI52vH56/XW5x8pCVWeW11A4Q++95YRdq5xgSAtcX?=
 =?us-ascii?Q?rrYn47bHW0Q3c3ZRQeY5vWBZRtmNg9uGiISguVCAKyNg4w3ju1GtY6fAHI8o?=
 =?us-ascii?Q?EQNi6q4Y9ZxQLI4PIA/h7gFaeebO6IMXuGxmyE+He7RvYORoEdHZ2z0wsN9N?=
 =?us-ascii?Q?4zRyKVJtslO5x6BfBwlM78hdXzCp620zvz7UbsAOogFbfwTbxBX3ZAsvuQLO?=
 =?us-ascii?Q?ebBBwJeYupiEf2LhKOXI+ExBlhP+pk2TAifYcKs48DyDVYqucWZExNakZOgD?=
 =?us-ascii?Q?W4H3LijoZDnJ1A7SUNcumAr+vCFNLLXlwHbQo6dsBKSHzuDiOTONm0Ike/Nx?=
 =?us-ascii?Q?bs9VU4ZEvQYbyMWTaiPf59bO14DHajU45I/9bPO9LG4LkrTmTlZLRWLguuJ0?=
 =?us-ascii?Q?5+bUn3vuJAix1xEe7JGb7nDJmciNbPhNCmN/l/rKto6PKsAbzw13uwByvDrq?=
 =?us-ascii?Q?X3w0/fu9qgQqHaPwENcB8gwvzlAEO/CXD1wyi7AUljmzBeKGzXr6gIhsmXX0?=
 =?us-ascii?Q?+Ri9nnTfNGwHwHtTJhl8bC6GiooNZLaRpafQWZmf6+7Lu18iIEd+mPW9u1bE?=
 =?us-ascii?Q?t5QYLXkMShB5c4B7gXQrAyzUD70WkuQTElzNp+eln/7Cup0PsFBhDS3u78kX?=
 =?us-ascii?Q?Gk0jRxPrMsVfmF8J6TB6zVU0/IqNWHFbFBpoFnYmirnpcXIZNrUUBrXEUjbM?=
 =?us-ascii?Q?GyMFkl561Ma8HMHzq1KRtIyzhohjArDbv3rodqDKs72jwNCy/45LGC1mubBI?=
 =?us-ascii?Q?WhGf88y65ihweIss5xu1tY3ADyewTKd5qdLbnFOJQLW6o8J2P8MGrkUEiHNa?=
 =?us-ascii?Q?akTi/WjwiWUFzI/cK55jylONX5RA5U0urRI5kD26Z13gw0I3mQxvpBYnOyKk?=
 =?us-ascii?Q?ewd4DQK4M5nQVFZ5wNSGZ0YLESWiEJkHBSC5FT3xiNxaVooACnX27+2HSfIL?=
 =?us-ascii?Q?kfN2j2UNEDdoOVJy/fQjJzE+Qid3IsRiW1zcDfO3fdxfUAKZ4+Cf?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 03c017f5-c1ac-4981-70b0-08da2d9c28fe
X-MS-Exchange-CrossTenant-AuthSource: BY5PR12MB4209.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 May 2022 07:03:15.3196
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Uw+ziO2C5tY2YR7S0Q05FUuIp/AXciJ5lMyjEEk42jYV1mh2FjMf9SLbPBsXJf9pSAbMdktNOTrenmoj8hmtqA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB6586
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vlad Buslov <vladbu@nvidia.com>

Currently, match VLAN rule also matches packets that have multiple VLAN
headers. This behavior is similar to buggy flower classifier behavior that
has recently been fixed. Fix the issue by matching on
outer_second_cvlan_tag with value 0 which will cause the HW to verify the
packet doesn't contain second vlan header.

Fixes: 699e96ddf47f ("net/mlx5e: Support offloading tc double vlan headers match")
Signed-off-by: Vlad Buslov <vladbu@nvidia.com>
Reviewed-by: Maor Dickman <maord@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en_tc.c | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
index e3fc15ae7bb1..ac0f73074f7a 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
@@ -2459,6 +2459,17 @@ static int __parse_cls_flower(struct mlx5e_priv *priv,
 				 match.key->vlan_priority);
 
 			*match_level = MLX5_MATCH_L2;
+
+			if (!flow_rule_match_key(rule, FLOW_DISSECTOR_KEY_CVLAN) &&
+			    match.mask->vlan_eth_type &&
+			    MLX5_CAP_FLOWTABLE_TYPE(priv->mdev,
+						    ft_field_support.outer_second_vid,
+						    fs_type)) {
+				MLX5_SET(fte_match_set_misc, misc_c,
+					 outer_second_cvlan_tag, 1);
+				spec->match_criteria_enable |=
+					MLX5_MATCH_MISC_PARAMETERS;
+			}
 		}
 	} else if (*match_level != MLX5_MATCH_NONE) {
 		/* cvlan_tag enabled in match criteria and
-- 
2.35.1


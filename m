Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 45607517CA9
	for <lists+netdev@lfdr.de>; Tue,  3 May 2022 06:43:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231241AbiECEqS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 May 2022 00:46:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57160 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230476AbiECEqQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 May 2022 00:46:16 -0400
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2057.outbound.protection.outlook.com [40.107.223.57])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 632643E0EE
        for <netdev@vger.kernel.org>; Mon,  2 May 2022 21:42:45 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DCopp3QKlmvEYYjHbajB5q6Cch6zVYp/1BYF4cJp4aSheniDr1mSrs0ndk/lCHZX7cN785LSKy5Jz9g+VsVshL3ujKZt1r8Q02c/EPWoZji8OaaAHho3oOu7/74t9K0WLDQH6U2dC/kFo5vWsksl50fUNB82FqeV8R3ybp480fdgUhD4LzwQmWLyXu4bl3E+2Mc0meuhOZegZ/IBcBlx+roVtN4ovig0RaTtyrVUZMnSWcjtiG0B2ph7T5ghhUronrhYLEagwH9oQyqDy/x1QIUIKhTIpWrJhIaUhROklf6ZLor1pybHQ69mQEnb4OESRjcWh0iPzui0ONUn83hwRw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=0spybwGsmGRTic5CsJ0+YMlZ9IED131l5DpSyQyNkdU=;
 b=eSn41G2olzPmMPXAqBeqqCBEOgZwleZ7O4QvQJ2aqrTH4VNVhD7sMcVpKrxI4bvLdsMT7we7LxuP8IZP26F8Izvm+v+vdTjJclYKwsuPzwq1GvJMCv+Fd3op4ntwea8VjL1v0fus+ibzEWVsG6x5VKlc2ComGN7Z+QB1my4LF5q0TtnvefLiLAPqqm/uDJ+np44q49Vx4YfUPcQ0fhlkzbjLxeoamxv6cPT1Hs9qqqW6GqC62L9Yde1VvZcmnVQO5qYF5FoFqFQJmQEPpmLKnm2JhNzCkBEESaY3bcfXhdnT8FsoFvQTOIQv8D+QcoEFbaEoVhQXj/u4et3hDBZGRQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0spybwGsmGRTic5CsJ0+YMlZ9IED131l5DpSyQyNkdU=;
 b=mjteLa+eSTjo2X5dz7zH/pvq6BxTcI8vCQBFKaz2d9h128sM9vkI8eS9YgE5DgxjOrdA/51UyHrvkhHkdSmApNRxB0ybQxI5Wtn/FP1XEDNgT+gJpL1Xa5lRYNkVsRqZp1oobCtHYEyc0SvcM76vELkTxJkoVjM3oP4RDcOTFVM5vAVwMRKFNW3JAtZRFvDR9M42CJwDB1QQ9akJLMDufvK2/oBKJAZayxItMemOZ/6fZYeXvqXXm1u+ugW1V9drzIo+ct1u+5GJBRqGus6MDyB9nQPyhXrXRtIkDGRpVFMDSICxE9qaPxlXnAUjxjpuchqSti1h4YDHZ3Y3qn5wfw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from BY5PR12MB4209.namprd12.prod.outlook.com (2603:10b6:a03:20d::22)
 by BY5PR12MB4322.namprd12.prod.outlook.com (2603:10b6:a03:20a::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5206.24; Tue, 3 May
 2022 04:42:41 +0000
Received: from BY5PR12MB4209.namprd12.prod.outlook.com
 ([fe80::bcda:499a:1cc1:abca]) by BY5PR12MB4209.namprd12.prod.outlook.com
 ([fe80::bcda:499a:1cc1:abca%4]) with mapi id 15.20.5206.024; Tue, 3 May 2022
 04:42:41 +0000
From:   Saeed Mahameed <saeedm@nvidia.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     netdev@vger.kernel.org, Haowen Bai <baihaowen@meizu.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [net-next 02/15] net/mlx5: Remove useless kfree
Date:   Mon,  2 May 2022 21:41:56 -0700
Message-Id: <20220503044209.622171-3-saeedm@nvidia.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220503044209.622171-1-saeedm@nvidia.com>
References: <20220503044209.622171-1-saeedm@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SJ0PR13CA0101.namprd13.prod.outlook.com
 (2603:10b6:a03:2c5::16) To BY5PR12MB4209.namprd12.prod.outlook.com
 (2603:10b6:a03:20d::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: da1efa92-fd4d-47a3-1363-08da2cbf5ba1
X-MS-TrafficTypeDiagnostic: BY5PR12MB4322:EE_
X-Microsoft-Antispam-PRVS: <BY5PR12MB43227A7E20B3E8BB00C4FB67B3C09@BY5PR12MB4322.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: LeysEe78fNi5gGhiuLXXydJH7kXR4KXaMDILFcvY+VZzVXeSHICVu74iUW1UlJ2AQRvBRRd0lIW/AbRVfXDBt7r4zS5w0/Nad8jthf1f5u9G/tJ6tXZ4R4PHN2oGg0qSPSln+gCfk68yze3DlxcCl0SXSYZKu/2wnOB3K6WNxGliFDqMZVxhBlW/rN3iwpQmMuywXdvV9bPTnpVz+V2lx82HeKMWeeMUEKs/7dkmE3M4HsbHUFCpIWjceTZpDPLJNaaSayzM5G3sVWxEIFDt3mD4gcg2MbaI2XRL2SBuBvsaie6CQNpJeC/I3cCzTl7Nw3olbIV/oT/L32zuB/Km6Dk3bdWGMBkOLKKkti/zRMAYkBe96BOjRNJKlYLT4ggS639kJteeRXHmil9amWCrj+4hiTAwHTNkLDwGWX4PY+sZReCIpS2FJmNbfO6g+BVr0MXn4u9+WUM3O/8JMdRisHpDQjPpqIfJ563qqndEic7AfoOg3+IfQOrzXTTZz7Cdi4vcSlyFqdAHrqvc48+mU1UkqjqqqnPhvjtWQ8h9Akx6gie+N+n1/9uJMKz0VnvS/GcKDRegygB6QM/qsSj+WeUKj0Shg87Z7RSaNzDLZfNgx8bfoKn8xIXXuZX8ueWpSEMTUk2QzPLoZ4gcO3iJaw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR12MB4209.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(4326008)(66476007)(66556008)(8936002)(6666004)(8676002)(66946007)(83380400001)(6512007)(6486002)(1076003)(2906002)(508600001)(86362001)(2616005)(186003)(4744005)(36756003)(107886003)(5660300002)(316002)(6506007)(38100700002)(110136005)(54906003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?S1T+c/E1QXjKMaWNVp3z5SxdkGXs5GCQbzv/Jf7bE03RzjkML/7gq0Mu5ACK?=
 =?us-ascii?Q?GZOEbDlMhUgyo00Uh/f3207lVo2DcCEiFe4lCITzuRu3Sg1U+bjuHluUh/J2?=
 =?us-ascii?Q?UIiaq8l51OwjHMbLwpgNrI5vT7Tq3BV1ZmXLvzPnCoZcYeSvNosRInsJa1pj?=
 =?us-ascii?Q?lwKibate5ZsQeGHdv1RsEVxrrFtpyQEmG5wCpBfStIzIoJf6I+kyS9AisVSZ?=
 =?us-ascii?Q?JymRothKpucn0uW6ApoSOrGrYpa7zzvWcIBq8a7pmk+bIXVSYagaYvcvV5IR?=
 =?us-ascii?Q?LVwZrvSmDL06A7ff/tULV9NcovF6Pcf170OSoce0fIdJMsogP0wYOJlpN4d9?=
 =?us-ascii?Q?7NhZEX6pkdTKwrja7v7l5jVpwTJi4A/xxRv7E9DVdOSgi6/l84MZZnbDa134?=
 =?us-ascii?Q?Cq3QN7Dghwj/b+9KRJtaxZq/fSq71gigJ5SQqnSqzuH/vn8rmExQtLsA3gqj?=
 =?us-ascii?Q?vrERcXXASB0LXqDP0apHP8ljIzBuATktKGEJBJ9VtHybF36384I846kbhrsW?=
 =?us-ascii?Q?9MHVITojef7tcG91DAgmtfmhDPOKUVVWZaRGF8c12OAlonGrK+9JU9H8O01v?=
 =?us-ascii?Q?j7WF41SjvR/CTRqRJu7x5D8ojcsBq36VEMMiWXx93onxyuqnfVN2X7wu7Llf?=
 =?us-ascii?Q?tovDTLBihdaK6qdl1Oblo+P2bINrXCQyEdDbkNoLLEH8ZJJrX4HfALjP/uhg?=
 =?us-ascii?Q?y1ZCEXhiJ5QirUycXcCCeCv1bB3nvh7BlWFLpNd0mAWDd1spTHVMheTWlVYd?=
 =?us-ascii?Q?UOoPa7F+aOYcj6KD1FFcDXDodTwFAfrchod0j23U994i/HVeXsk/3kPoE23t?=
 =?us-ascii?Q?RmAb+JGkHDB+uTsl8Wn4Vai2WrLWXM0NmnEGq6bbWEEITe7rTy3A/XMGNkaR?=
 =?us-ascii?Q?bTxrW8XMvvmStCdiQ+cn+Q2ra0+0TDw6+Kai6k1Lv05j6oP8/xyZaUGTtVxk?=
 =?us-ascii?Q?la5SKCU7lzKZfiJGkq6CGuy4xMo8NKS/60DE+HR53VOK2j/iXEwGYDGhrGCI?=
 =?us-ascii?Q?CzVK7lxHA0dwcP6Bcdfu9NAUnxFBEYjRLcchD+U4XJ38wmapQGn8wVNmliCe?=
 =?us-ascii?Q?5vcX6y/8ufklJ7Hy8nEbaLJ/W1kEq6VtprqhGWAuy64YNa14nF1sqoNV9NLG?=
 =?us-ascii?Q?KA8SyQ5cQUVYTAEMUvqxygqbzpKPFdN7FgWeKHYDmiE+eKJujLWHcVIsO239?=
 =?us-ascii?Q?rc467n40+ogZbifKTkkxwlWdS/Ye07tRDe5ZvAkN3mP36iCgJU6h2nXpTBSe?=
 =?us-ascii?Q?ZCN4OPgSgQs3zGQZE8y9CHZGL9KCB2vlaWr7hJerANOYxdxh6NePK54BenWR?=
 =?us-ascii?Q?OivMfF010DxwtYYnupiIRq+N9q4Lkw5P4KL7hpYkAfUzJDl1GPIPQkhbY0ux?=
 =?us-ascii?Q?/sZuxG7RWtl+UlG5c1jfLSH1OGxNduhZfUI9QOYmM3PPsciJAoQxNG4SG+cb?=
 =?us-ascii?Q?US3q7NcFFuMPm3lTSbHVL3yU8zcwHj7RfC3GU0+RzPv7pXyacuFHnl6PpA+T?=
 =?us-ascii?Q?cMqAR1Li27jiNwksckmrEKwkY0Jyt6HEJkWWcL9wx3UfWsseJe4d4BY9BZzN?=
 =?us-ascii?Q?xrboRPxFFyQzytH0+l5CoOf7bNc3Xj3tLixv+tq21/F34irgOXmN5Qkv/4Lr?=
 =?us-ascii?Q?PaAb3s/qi2/F3P6BUSReMnCG9IBGJHiVoXZxsLl9+UwA5G8yVASlCph+zEvM?=
 =?us-ascii?Q?suOk24VQOQ/HPYLohyvOwVVzLoNf2c6Hzd9iS4C9mTf29cd6BqhoGZOxW/qD?=
 =?us-ascii?Q?6A/M1H5P5WOFMY6H8xp/EHivJyf5OTc=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: da1efa92-fd4d-47a3-1363-08da2cbf5ba1
X-MS-Exchange-CrossTenant-AuthSource: BY5PR12MB4209.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 May 2022 04:42:41.5254
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 8tauJMijgCn9vz7ltxtC/Z4nJXYyNURojnAJ6N+dyInIo7OyF8pybBYDxKYf7FyXYqaCPVLOu5TgzbawxRG0KA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR12MB4322
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Haowen Bai <baihaowen@meizu.com>

After alloc fail, we do not need to kfree.

Signed-off-by: Haowen Bai <baihaowen@meizu.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en/tc_ct.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/tc_ct.c b/drivers/net/ethernet/mellanox/mlx5/core/en/tc_ct.c
index e49f51124c74..89aa0208b5d2 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/tc_ct.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/tc_ct.c
@@ -1812,7 +1812,6 @@ __mlx5_tc_ct_flow_offload(struct mlx5_tc_ct_priv *ct_priv,
 
 	ct_flow = kzalloc(sizeof(*ct_flow), GFP_KERNEL);
 	if (!ct_flow) {
-		kfree(ct_flow);
 		return ERR_PTR(-ENOMEM);
 	}
 
-- 
2.35.1


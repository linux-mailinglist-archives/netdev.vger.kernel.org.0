Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4A8F0378D47
	for <lists+netdev@lfdr.de>; Mon, 10 May 2021 15:42:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239580AbhEJMiI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 May 2021 08:38:08 -0400
Received: from mail-bn8nam08on2082.outbound.protection.outlook.com ([40.107.100.82]:51296
        "EHLO NAM04-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S236359AbhEJLwA (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 10 May 2021 07:52:00 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=U+xzAQ7qzavloqVr0n9mM2RaWtS0j2sBL/mi2j5vO/XE/CrvcuLrIj+xqPSlcipOU86Lm1P7a68swmjukPBSgDq/fjlAWX8AcSBnXSJMZJwKy3FR0pDIMXqS6U72iARQjN8AGZZaay7IaVzufeiBkUA04++Ft+SYIUgVBE3vupQmNih6gDISZTH9/kjv24EEVtAqC0t92tKZN24YySipG71N0xhwEWVfGgecjhkf832eRcruT8EgHOMN0KRano0hMZ8UwG5GaoeEbWd4aZthoxYWqDmABDs+mAw1wvL2512XesF7Rrq02pjv3slhmQwFEY1Vqa/u7I2CR+sfOujkqA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=czlfPOuzBT2/WGvWKvZevuKCpkfxz3WIP9KWkGqJ+y0=;
 b=Il7PSMQkcSjzcmBP0BPaYRNeEicoSPQ66/eprPfzD50NF3hLLVKK8CdgLYutqIyWOAbf/zc+ph/cRK/Y3sHEcQfVMtLz4zSoHpn2Bi+Bd1dnygycGvZjYkW8Eun6oRVd2Tr4/f25X3N58tt1qtr1kg8z9J0QpogQLoRroZ2kFfSe9JpxLqbmgLIsoqiA26EqT5GrEgYsCA4dan1JxUulgVYhHlqN1wsyxX1crKPXccBrtYzUNXj5GXeQY+S8VAi5CiRdBN6DZy8rQTM8i+HLXHbJJ7hDk2jecn0YqddNChTvbCXkK1r5x5YK/VuqbMrvDdvM4g2KX1dxk8aSOPcl1A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.35) smtp.rcpttodomain=netfilter.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=czlfPOuzBT2/WGvWKvZevuKCpkfxz3WIP9KWkGqJ+y0=;
 b=tyAkubfuTWpxpFt4xCMcZnGK7XV3oEKjRlhTi5htxsG09bb5Uu7V7p+4Fms63ZtOgAf8MuWZZSOfZNghBc7mfzHhHgT6vF/4WCMyMEYFKzZcSPkLnisGBUA4m4ENsyjvzkuaY0kBfdx+bk1FwmDNYCH2BL0EoQNrzq53+8iAF2sqm5IMlZxFqWXQekost9FibQ0fUOZejM1vDuMvibV1a14RoZFIfT97oVowbo0xLjrDE4JFHwQiF5PzDCvJPLpZZayQ2prcVO/qAJ92i7naa8w9HN0U47aXqTWsSFkEyoRrOVQHCjfsCq/Xq8v9eiG6KKBQ8tc/E64Vg2pBQ/FWWg==
Received: from DM5PR10CA0021.namprd10.prod.outlook.com (2603:10b6:4:2::31) by
 BN6PR1201MB2514.namprd12.prod.outlook.com (2603:10b6:404:b0::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4108.29; Mon, 10 May
 2021 11:50:54 +0000
Received: from DM6NAM11FT005.eop-nam11.prod.protection.outlook.com
 (2603:10b6:4:2:cafe::3f) by DM5PR10CA0021.outlook.office365.com
 (2603:10b6:4:2::31) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4108.25 via Frontend
 Transport; Mon, 10 May 2021 11:50:54 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.35)
 smtp.mailfrom=nvidia.com; netfilter.org; dkim=none (message not signed)
 header.d=none;netfilter.org; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.35 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.35; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.35) by
 DM6NAM11FT005.mail.protection.outlook.com (10.13.172.238) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4108.25 via Frontend Transport; Mon, 10 May 2021 11:50:53 +0000
Received: from HQMAIL105.nvidia.com (172.20.187.12) by HQMAIL111.nvidia.com
 (172.20.187.18) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Mon, 10 May
 2021 11:50:52 +0000
Received: from HQMAIL101.nvidia.com (172.20.187.10) by HQMAIL105.nvidia.com
 (172.20.187.12) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Mon, 10 May
 2021 11:50:52 +0000
Received: from dev-r-vrt-138.mtr.labs.mlnx (172.20.145.6) by mail.nvidia.com
 (172.20.187.10) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Mon, 10 May 2021 11:50:51 +0000
From:   Roi Dayan <roid@nvidia.com>
To:     <netdev@vger.kernel.org>, Pablo Neira Ayuso <pablo@netfilter.org>
CC:     Roi Dayan <roid@nvidia.com>, Oz Shlomo <ozsh@nvidia.com>,
        Paul Blakey <paulb@nvidia.com>
Subject: [PATCH net 1/1] netfilter: flowtable: Remove redundant hw refresh bit
Date:   Mon, 10 May 2021 14:50:24 +0300
Message-ID: <20210510115024.10748-1-roid@nvidia.com>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: a35435b7-3041-4204-57e7-08d913a9dd83
X-MS-TrafficTypeDiagnostic: BN6PR1201MB2514:
X-Microsoft-Antispam-PRVS: <BN6PR1201MB25144407D22CACFEAB093262B8549@BN6PR1201MB2514.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7219;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: +ymYcADj6UGFB1j1yB3BkXXOaqIY0MnpaP8qGh2ndyNT78FB2Xq1nwYKWGBPQ75b8yZ26/oJqs4UgobXoNd9sAU566jdNVfp3HTFQrKpxQt0QNv5vN82iyVkTdSBiXolXis301wKo6JgbdrQhFZPAnDUfd3rxKcQI20ZlmfPDAZkdM9KgSHl9KjbyzblCWOmbFs1N78glpyJWdzK99yejaOPqGaNLDr9TdbRwgO1IR4emD5wAxMnpcNfdLIK65riZIKGYLUe39OmtlKGbPk/g2fZze4v+BgO4mQktstMRjd83RSD33APd1OO+2GJfyuALQ17PvzM2tK3fJsFtVCG9dUK0jlmmlMe8SV74pbFZijB9tUptm6FYiE7TcBIN1nSpFxW60oKDqa9NZgaKjCGBhOtU8uct2KU5uPPXcykygzyeMSWJWaHE2WezuthdQQ+V0JFJMjI8sNYcd+tmss1aBOjLB2fL4DS2b3FdpEXFD22ujh2TmOu5fbRH9i+2P7WOlLWbvdyUWmer14WaLTeWp6l8zUrCb3CNGyn6+LUFyj8AmPgnd2wW1hcgNoi09HTwBv1AI5aM0ep2ghVACUriImLU4kude3kwBz7fm1W7mcZxTSxUGl/h7gOCWIqq6OYH64bW1RaIuE73wMmmgj495AseiXSyyMjdOa3VhSa+CQ=
X-Forefront-Antispam-Report: CIP:216.228.112.35;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid04.nvidia.com;CAT:NONE;SFS:(4636009)(39860400002)(396003)(136003)(376002)(346002)(46966006)(36840700001)(47076005)(336012)(7636003)(70206006)(186003)(8936002)(83380400001)(54906003)(2616005)(8676002)(110136005)(426003)(70586007)(4326008)(82310400003)(26005)(2906002)(36906005)(5660300002)(36860700001)(356005)(478600001)(36756003)(86362001)(316002)(82740400003)(6666004)(107886003)(1076003);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 May 2021 11:50:53.5339
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: a35435b7-3041-4204-57e7-08d913a9dd83
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.35];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT005.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN6PR1201MB2514
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Offloading conns could fail for multiple reasons and a hw refresh bit is
set to try to reoffload it in next sw packet.
But it could be in some cases and future points that the hw refresh bit
is not set but a refresh could succeed.
Remove the hw refresh bit and do offload refresh if requested.
There won't be a new work entry if a work is already pending
anyway as there is the hw pending bit.

Fixes: 8b3646d6e0c4 ("net/sched: act_ct: Support refreshing the flow table entries")
Signed-off-by: Roi Dayan <roid@nvidia.com>
---
 include/net/netfilter/nf_flow_table.h | 1 -
 net/netfilter/nf_flow_table_core.c    | 3 +--
 net/netfilter/nf_flow_table_offload.c | 7 ++++---
 3 files changed, 5 insertions(+), 6 deletions(-)

diff --git a/include/net/netfilter/nf_flow_table.h b/include/net/netfilter/nf_flow_table.h
index 51d8eb99764d..48ef7460ff30 100644
--- a/include/net/netfilter/nf_flow_table.h
+++ b/include/net/netfilter/nf_flow_table.h
@@ -157,7 +157,6 @@ enum nf_flow_flags {
 	NF_FLOW_HW,
 	NF_FLOW_HW_DYING,
 	NF_FLOW_HW_DEAD,
-	NF_FLOW_HW_REFRESH,
 	NF_FLOW_HW_PENDING,
 };
 
diff --git a/net/netfilter/nf_flow_table_core.c b/net/netfilter/nf_flow_table_core.c
index 39c02d1aeedf..1d02650dd715 100644
--- a/net/netfilter/nf_flow_table_core.c
+++ b/net/netfilter/nf_flow_table_core.c
@@ -306,8 +306,7 @@ void flow_offload_refresh(struct nf_flowtable *flow_table,
 {
 	flow->timeout = nf_flowtable_time_stamp + NF_FLOW_TIMEOUT;
 
-	if (likely(!nf_flowtable_hw_offload(flow_table) ||
-		   !test_and_clear_bit(NF_FLOW_HW_REFRESH, &flow->flags)))
+	if (likely(!nf_flowtable_hw_offload(flow_table)))
 		return;
 
 	nf_flow_offload_add(flow_table, flow);
diff --git a/net/netfilter/nf_flow_table_offload.c b/net/netfilter/nf_flow_table_offload.c
index 2af7bdb38407..528b2f172684 100644
--- a/net/netfilter/nf_flow_table_offload.c
+++ b/net/netfilter/nf_flow_table_offload.c
@@ -902,10 +902,11 @@ static void flow_offload_work_add(struct flow_offload_work *offload)
 
 	err = flow_offload_rule_add(offload, flow_rule);
 	if (err < 0)
-		set_bit(NF_FLOW_HW_REFRESH, &offload->flow->flags);
-	else
-		set_bit(IPS_HW_OFFLOAD_BIT, &offload->flow->ct->status);
+		goto out;
+
+	set_bit(IPS_HW_OFFLOAD_BIT, &offload->flow->ct->status);
 
+out:
 	nf_flow_offload_destroy(flow_rule);
 }
 
-- 
2.26.2


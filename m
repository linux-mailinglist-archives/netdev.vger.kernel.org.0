Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1FC8835B25B
	for <lists+netdev@lfdr.de>; Sun, 11 Apr 2021 10:14:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235112AbhDKIOT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 11 Apr 2021 04:14:19 -0400
Received: from mail-mw2nam08on2085.outbound.protection.outlook.com ([40.107.101.85]:44129
        "EHLO NAM04-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229792AbhDKIOS (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 11 Apr 2021 04:14:18 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=PabD0wiej57qJrMoAgQ4jwZpUNSaIO5E5leQAlhtS3FjBYKa0liNo+4/PFwKHYAMFEjvXsxKvOugqYwU8bzAFiylTyXbmVV+6RmW8ZeLk0svmW+jz4H7FExbY9F6eIEpH2V+M6XBPTOSyaEs98HsglhsjOU8yhqaPtdToYbp3IAtixLsp3kNxWnSAU5nSQJFoQPI/VYkPzcWwi32rDO0l/arDda//1iruBcLSzBx57zK1djialwHSogdUGmSGKXWGflEvAiWAlwhR7DT4vxld2uEdrT8ZCMg96+m0YlFIes9vq1ixQ8YCioCq91m/t7BVIZFkkqPn/CrZOu/9+JlFQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=cXRduC7811rLl8Y5sFLr3XpEgfXOvS3OuEe9mQLe7+Y=;
 b=l91EnXNe371QiLklDnV0Hhd/2z8ETtymNkSH+CCaMJB+BWtA2aJZSTjaQa9JZOK74j41bw1ZOaRv761LaAG4izp1idPgijX1UirX0QV5Iyc+llQ3QxlZkLEJ7gg1UAIDfnpaejOACAN7dWgbWBZWGeBPKIC1Fv1vJNQsXU+K16qjcWN1g4qxG36pDmLnJ+WbIlZXdB2CWxlOq8mc53hTvjR+/V4JRLLmXloIn78X/udUe6tyjWuO8lqvoqlhOa5b+VJyS8ffaS8y7nt1KwOHdQAYt1QdCmJ46elHSGuq4dicL/n4lyY/+kkKD3YADEQSeE3MqeSdQQCWczulislZyQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.32) smtp.rcpttodomain=netfilter.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=cXRduC7811rLl8Y5sFLr3XpEgfXOvS3OuEe9mQLe7+Y=;
 b=Wb29av3tWz5BJTXBfLTmEOqoBYBBuontcCksZ6shRcqLJtH/zmXlI7vDQMEyMBmTiPqRe5L7l+yespkIVbc8KNDdwnxADIUYVe0dnWIzTuKdlyYhR/fdrddwYfzhYsAzGyqFVLDbXapr0z+uuJpW/oEno2YCZZcKro/+jxuwmnl6ewBF+38W6OhhD7+DOdSoStwOueS9AM97b+EXzgCfXex9iNNkYOLd+8fkufmb120oBpOvqw91hBk1SSebn6jRRp3w/M/VF3ky+ACMKmn9WDNiPJh0x+Ntrp+CvE8APNOxIizEb2VZNvSurilJ8uXHoMMDPK1OQ2c++VIeaZW6vg==
Received: from MW2PR2101CA0026.namprd21.prod.outlook.com (2603:10b6:302:1::39)
 by SN1PR12MB2493.namprd12.prod.outlook.com (2603:10b6:802:2d::30) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4020.21; Sun, 11 Apr
 2021 08:14:01 +0000
Received: from CO1NAM11FT046.eop-nam11.prod.protection.outlook.com
 (2603:10b6:302:1:cafe::7b) by MW2PR2101CA0026.outlook.office365.com
 (2603:10b6:302:1::39) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4065.0 via Frontend
 Transport; Sun, 11 Apr 2021 08:14:00 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.32)
 smtp.mailfrom=nvidia.com; netfilter.org; dkim=none (message not signed)
 header.d=none;netfilter.org; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.32 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.32; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.32) by
 CO1NAM11FT046.mail.protection.outlook.com (10.13.174.203) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4020.17 via Frontend Transport; Sun, 11 Apr 2021 08:14:00 +0000
Received: from HQMAIL101.nvidia.com (172.20.187.10) by HQMAIL109.nvidia.com
 (172.20.187.15) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Sun, 11 Apr
 2021 01:13:59 -0700
Received: from dev-r-vrt-138.mtr.labs.mlnx (172.20.145.6) by mail.nvidia.com
 (172.20.187.10) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Sun, 11 Apr 2021 08:13:58 +0000
From:   Roi Dayan <roid@nvidia.com>
To:     <netdev@vger.kernel.org>
CC:     Roi Dayan <roid@nvidia.com>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        "Oz Shlomo" <ozsh@nvidia.com>, Paul Blakey <paulb@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [PATCH net-next 1/1] netfilter: flowtable: Make sure dst_cache is valid before using it
Date:   Sun, 11 Apr 2021 11:13:34 +0300
Message-ID: <20210411081334.1994938-1-roid@nvidia.com>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 4bcc5fc6-66d4-4bf7-0e85-08d8fcc1c2f9
X-MS-TrafficTypeDiagnostic: SN1PR12MB2493:
X-Microsoft-Antispam-PRVS: <SN1PR12MB24936C5048E6F1449C1D75B9B8719@SN1PR12MB2493.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:1417;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 7lq5AxfJojlzeqfF0GDTdN0vIrT5Dhl1G8cfwbYCQrwg+iPGz/JTagabmAhyCl/4OZ6oxggnNmnQnWChXXAqzOECpTPghTny8B8yo3JKDxzTdF0BQcUeoYrGaLs8DS6zIWCr47qohgcH0vH4idbRK00G5f8DDbxb0QNHBnEA8pMUmc8t+FE4aBgbyeBP1468toEvkOZts3Hlyg0LXCw2SR/n7GT0Et89PHppOoBxw2TQsdhl6IR68xSpfo9gkNbI4/C6LzSiM7SWOUb4UPmqER4DjdxqMunbU5O9hxGu1DoxOZ+yLZcY8UY8Ear8jCh1pBel3rCl/33njCYdHLKFimRjRKWlgy6W19sgjUZha9k8sSIXseG2xL0EXekcJ1ClszzySMxl2LcXHjqwktQAqeHXBz/TcrTUcPbrUJbe40IkI9wIlmToK/vk/ItClKvNEGFhDpjfaA7qxo4xeieg1hVf64Vqd1PA/2Ybzk5eMvpkCASdDFnClOel/CAv4dkLhXiaB+bE2c0kVnL2L+V4Eh55FAH48JriFwxPFZyjbGpjzEiwtKOEnGNp144wiROGyj/mNQgTl93XUQbDyWR4DxTmVidL1KBht2N32PUNZLOsQt7YfU8YI9j+L4KLO6PGyLte+/HEhNcRl+UlVb8nOfYZLgGkFWdaDh/KsxIsg7w=
X-Forefront-Antispam-Report: CIP:216.228.112.32;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid01.nvidia.com;CAT:NONE;SFS:(4636009)(39860400002)(136003)(376002)(396003)(346002)(46966006)(36840700001)(336012)(478600001)(70586007)(70206006)(426003)(356005)(47076005)(7636003)(2906002)(82310400003)(4326008)(36860700001)(186003)(5660300002)(6666004)(2616005)(82740400003)(316002)(4744005)(86362001)(8936002)(36756003)(8676002)(54906003)(26005)(6916009)(1076003)(107886003);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Apr 2021 08:14:00.1905
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 4bcc5fc6-66d4-4bf7-0e85-08d8fcc1c2f9
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.32];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT046.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN1PR12MB2493
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

It could be dst_cache was not set so check it's not null before using
it.

Fixes: 8b9229d15877 ("netfilter: flowtable: dst_check() from garbage collector path")
Signed-off-by: Roi Dayan <roid@nvidia.com>
---
 net/netfilter/nf_flow_table_core.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/net/netfilter/nf_flow_table_core.c b/net/netfilter/nf_flow_table_core.c
index 76573bae6664..e426077aaed1 100644
--- a/net/netfilter/nf_flow_table_core.c
+++ b/net/netfilter/nf_flow_table_core.c
@@ -410,6 +410,8 @@ static bool flow_offload_stale_dst(struct flow_offload_tuple *tuple)
 	if (tuple->xmit_type == FLOW_OFFLOAD_XMIT_NEIGH ||
 	    tuple->xmit_type == FLOW_OFFLOAD_XMIT_XFRM) {
 		dst = tuple->dst_cache;
+		if (!dst)
+			return false;
 		if (!dst_check(dst, tuple->dst_cookie))
 			return true;
 	}
-- 
2.26.2


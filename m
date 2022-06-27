Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 35C4955DA2C
	for <lists+netdev@lfdr.de>; Tue, 28 Jun 2022 15:22:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238452AbiF0L7D (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Jun 2022 07:59:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34500 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239847AbiF0L6Y (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Jun 2022 07:58:24 -0400
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2060f.outbound.protection.outlook.com [IPv6:2a01:111:f400:fe5b::60f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1AEB8E01C
        for <netdev@vger.kernel.org>; Mon, 27 Jun 2022 04:56:03 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Ye2UftPhQjOLCESkbU35ei1JJQel/2eZoJawjM2FY0nuAzr7LcH/3GDncttbE/8VLdmXVCmTrUi8kGMJe1XVeYA3Y23nEVZZe4ofniMdQmb+qy3cheLMn9lHbV8y6aWrFq4yyiqALiiucHGDAomvuGMyf00GK8k3PpvkfJFuFzxD/LUxsKzFbrdrLPfiRFWtdykKaq2YK01uLUHdVfmq0zPvhe+gMN2uNPEVJ4ZMaS/TFFUV88zCqati23E1U9+8DmpNT8bElHbvDgjW9+o/a9/8KTNOtLWUaEnthLBCZzytQ3pC4ZJd2O1ccqdjRv2zYy6GVhxI0cmMUCz/4eZGnA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=pXutBNrBvrbKZ2rubch0CMHqKfX9+gTS4W3DGkrkfU8=;
 b=BJn5Lt1l3xO44c9F2ccqZR2UnXdtTQ36/nRm4EgsYDHmbpB/9bqSJ99zC3g58eQ1nEdPRIgQAkMj2jx6lP+uKv7YIxqxn1LxjQRw8kwlYk8KAgcYQs2heNxS9wUOoLr9LGiVFoNJMxr4ksnlGeQQ9Qao1lhNc6IPeh37PIcg3a3VEuVt1axCUh/ZXslmU+i9s0zhsVv2qZHU2lGjjcqT36HtneSdyqRxfzuqMTkE3dS30Gw/anGgoeg2yTAyvWGdgZwnDnFx5KLsoLyqgvmC8IZ4zbtB7pVBJjzYAaT57peOtKRH4HNqA0Rm8RK6fngozxDtZqXp2/tbnxJItPxpjQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.235) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=pXutBNrBvrbKZ2rubch0CMHqKfX9+gTS4W3DGkrkfU8=;
 b=PPGzg6qewnd82KTNKSYZ3Z1zd2nBYkp71OkiZfGhiWnVQzLtMERvFdWxMsyApimsf1VRM4dG7YNdaACiSHDn8f4BIWRIs4n0kNwmQeiGvKga4WnwjHE5P8+atoiCgsSWNxrbj4/bbnV2ZInOdlzTsVwicW4+bVWJzpuCZGQjkWJJWilvLW4A1b3XlD4PVpaENqealnJxzpgVIfVIlqTAmbNNwwAp0vyMlOq75aC+GCKEdGan9V0Ia/gVarxk7CvOCCMkwBGCG1NJobSsNfwDdZtoKxL0hr3P3cOb+jTmPPmMwMEzcyV1hFkBpIK59n6qBIv7hy2FK7/RLAw2zf1rjQ==
Received: from DS7PR05CA0061.namprd05.prod.outlook.com (2603:10b6:8:57::15) by
 BYAPR12MB2885.namprd12.prod.outlook.com (2603:10b6:a03:13d::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5353.20; Mon, 27 Jun
 2022 11:56:00 +0000
Received: from DM6NAM11FT030.eop-nam11.prod.protection.outlook.com
 (2603:10b6:8:57:cafe::ee) by DS7PR05CA0061.outlook.office365.com
 (2603:10b6:8:57::15) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5395.7 via Frontend
 Transport; Mon, 27 Jun 2022 11:56:00 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.235)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.235 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.235; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (12.22.5.235) by
 DM6NAM11FT030.mail.protection.outlook.com (10.13.172.146) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.5373.15 via Frontend Transport; Mon, 27 Jun 2022 11:55:59 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by DRHQMAIL107.nvidia.com
 (10.27.9.16) with Microsoft SMTP Server (TLS) id 15.0.1497.32; Mon, 27 Jun
 2022 11:55:24 +0000
Received: from localhost.localdomain (10.126.231.35) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.26; Mon, 27 Jun
 2022 04:55:22 -0700
From:   Petr Machata <petrm@nvidia.com>
To:     <netdev@vger.kernel.org>
CC:     Petr Machata <petrm@nvidia.com>, Tariq Toukan <tariqt@nvidia.com>,
        "Itay Aveksis" <itayav@nvidia.com>
Subject: [PATCH iproute2] ip: Fix size_columns() for very large values
Date:   Mon, 27 Jun 2022 13:53:36 +0200
Message-ID: <ca17aa975010294b6d08ac48369917eb42bb80fb.1656330594.git.petrm@nvidia.com>
X-Mailer: git-send-email 2.36.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.126.231.35]
X-ClientProxiedBy: rnnvmail203.nvidia.com (10.129.68.9) To
 rnnvmail201.nvidia.com (10.129.68.8)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 1de8ba68-67bb-499b-ea2d-08da583400bf
X-MS-TrafficTypeDiagnostic: BYAPR12MB2885:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: j37vKSQ2r7hh23Tyey45kE9Pt/HFG2oPLbLw582gff52hqM0qNMkKRKmrtV70lxxLdxsWTLk1yK+jWzy8nc9zsqBxVJ8V/eGt4XhwhVjWEZ6gltw7GzFLP2/B7ov6cZuh5TbKQBDFqD7ON7gFa6umFWkJTm9VxJdu+51e0nxxEMFElbQT6STqVa5wOWEf8kfMKwt8WNMFY8ikB75XTBYvg7LTXbfBtBYL3/iFYq/gWna5vjfHcv7ZR3ibQW9V1x6RlapSRlBfSv+D4ZfnrboffoIGDvIcldPvsCq22DPzwfzWnUndoQIzC8VDUwBu6BeTEXAV2ZVBOC/SHOruEWcgzhEIS1PmabCgmj5v04YRM8F0WtaeF2bW/Gn4nZnkCLQ6Ox8vwtKmU182suhkKnIVCLGdTc8RDPOHdH0LjkndeLE8D+4JTpEidREuEANSZgNTw7FwPMj/qBCeclPGHCiQ60kAtQgdRfTBP/oHFOyRQZFN0kaEwBqBpNcEvBdD3Pk9arQhmh3L1Lk7pJoIvrqfIaFNB7sIFRhwOJu9j2nj6E4IEFC8bUetUKshiWl2c/kMSWo+YW+60E6DhkTZ50poAHIUsZPr0Rh0OiReSU+ISle/mm80hZQ8GMSLewBZMlJ15q4lJDsext30eLkzfyJFHmZjSdF4jb6xF0mDqubCC0CYUOsyDo81htuk59VALhg8JtfNI9ng6UGZpq8DaHBq3G8jRqwmVBngWkY+3hZW2jB5FTaT/6qLaXASqcVcSVyiJW3I2i+5pxsaxKyPp76eEJL4kS9Un+UkM3IuZOoUgdbO3psHpsXy36QyCye9xXMRI/0CXyDx5zSstI8CdDWxQ==
X-Forefront-Antispam-Report: CIP:12.22.5.235;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230016)(4636009)(346002)(396003)(376002)(39860400002)(136003)(40470700004)(46966006)(36840700001)(107886003)(356005)(8936002)(41300700001)(40480700001)(186003)(70586007)(40460700003)(81166007)(6666004)(16526019)(36860700001)(5660300002)(83380400001)(426003)(336012)(2906002)(316002)(36756003)(82310400005)(6916009)(2616005)(86362001)(54906003)(26005)(8676002)(47076005)(82740400003)(4326008)(478600001)(70206006)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Jun 2022 11:55:59.9061
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 1de8ba68-67bb-499b-ea2d-08da583400bf
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.235];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT030.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR12MB2885
X-Spam-Status: No, score=-1.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        SPF_HELO_PASS,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

For values near the 64-bit boundary, the iterative application of
powi *= 10 causes powi to overflow without the termination condition of
powi >= val having ever been satisfied. Instead, when determining the
length of the number, iterate val /= 10 and terminate when it's a single
digit.

Fixes: 49437375b6c1 ("ip: dynamically size columns when printing stats")
CC: Tariq Toukan <tariqt@nvidia.com>
CC: Itay Aveksis <itayav@nvidia.com>
Signed-off-by: Petr Machata <petrm@nvidia.com>
---
 ip/ipaddress.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/ip/ipaddress.c b/ip/ipaddress.c
index 67403185..e0eb41bc 100644
--- a/ip/ipaddress.c
+++ b/ip/ipaddress.c
@@ -549,7 +549,7 @@ static void print_vfinfo(FILE *fp, struct ifinfomsg *ifi, struct rtattr *vfinfo)
 void size_columns(unsigned int cols[], unsigned int n, ...)
 {
 	unsigned int i, len;
-	uint64_t val, powi;
+	uint64_t val;
 	va_list args;
 
 	va_start(args, n);
@@ -560,7 +560,7 @@ void size_columns(unsigned int cols[], unsigned int n, ...)
 		if (human_readable)
 			continue;
 
-		for (len = 1, powi = 10; powi < val; len++, powi *= 10)
+		for (len = 1; val > 9; len++, val /= 10)
 			/* nothing */;
 		if (len > cols[i])
 			cols[i] = len;
-- 
2.35.3


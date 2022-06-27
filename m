Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0943055D2E1
	for <lists+netdev@lfdr.de>; Tue, 28 Jun 2022 15:11:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236115AbiF0NYy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Jun 2022 09:24:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38000 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236068AbiF0NYx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Jun 2022 09:24:53 -0400
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2072.outbound.protection.outlook.com [40.107.94.72])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 957E963B7
        for <netdev@vger.kernel.org>; Mon, 27 Jun 2022 06:24:51 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kYLea+qFASjoGEnfcDFdagWHft2pIHMQN2/8Y5PR3/QjrSpPgS9cOWjmdXPjs4aLXFwYkN2uoNgQdNXX01S+CnAMrozv3IATMLFP/wnf/hjvOnommpfDArDQXNHqLqaX63uyt/kK1L4FUaKt3ewkJq6rQBL05sBn4lgMNiMly96gFA0k7/hMRJnm0qNMgnZ2WJk5qPI7rkarKKKTp84APGos46+lRa0N0Nm5+MVq4IsarqovbmyMUUhLFaxDEpJN3EYk3P+eFJBsXjmLyiO4Kx/a+GG5YhMLHtjZ2XnR4bw0qwa3TGkYcofOICnppdu694znf/jg3D3X4iVmAEbilA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=TTH4dwrozlHfdShuqZqqyvuDPOFNulPdplalELCHdjE=;
 b=blArTQmljCExOaE6wAhzOD73BLkwU6i8T2b4eiG20SouFv1EJHR89zHI4qjG1nuWsJ1nzWOK2FkUNtoLfktC11S9bVWxeWN1m2gSJANydiy2wOY4a9Ix3yLYWkJhURcELez9L5GS1UNUnCV5mJGpj5RkLtemJEx1AjWkEm733jpoPkvawCqM3BPQCltofCeWy7bk8Br+fI41koy5WfQHzhnSO3cyRfQq0quzqHnMMcgWkZanZX5rq1vQyKqgCQCJPrVwFn3sIwMu6oq9CZS5SXyTC+iTzmPgu+3hUbvqQ36nV6Eq6GbRdpjJbg+Qo5ROgrcqF9DvtdmYLOE0rAeFEw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.238) smtp.rcpttodomain=networkplumber.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=TTH4dwrozlHfdShuqZqqyvuDPOFNulPdplalELCHdjE=;
 b=lVw5b4Ezptm0IVSslOMi5AXi7w+eXsMl7bQFDcYiTSMv1iyzU8tdQSD0U2JVbnBtGYWQnLVSm/0SgTuXWY5xAH3+vZnA5hAJ+Ik4Wew6+cjORm9+hvcMzvSkKf3KUXX5V3X/18CBvS+ujfGWC4h4Zk2o/fP1qHrsY18RrmuA/6608SdidlnG0kYTA/nyY3i78AQiYfNwsYQNO92MJ8rouzeJgQ20AyS1ip4R3RR3ZFfrbXcg11ccue1TkxzdLyEFiofOfxZYyDRxCTc+HIm6rXSEAp1Ugiu/DITUlaFvmIVTttj//42OfQFrnIJpBjoPvNlk/vZFUA3Iwkba1PYA4g==
Received: from BN0PR03CA0014.namprd03.prod.outlook.com (2603:10b6:408:e6::19)
 by DM6PR12MB3371.namprd12.prod.outlook.com (2603:10b6:5:116::27) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5373.15; Mon, 27 Jun
 2022 13:24:49 +0000
Received: from BN8NAM11FT045.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:e6:cafe::e9) by BN0PR03CA0014.outlook.office365.com
 (2603:10b6:408:e6::19) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5373.16 via Frontend
 Transport; Mon, 27 Jun 2022 13:24:49 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.238)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.238 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.238; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (12.22.5.238) by
 BN8NAM11FT045.mail.protection.outlook.com (10.13.177.47) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.5373.15 via Frontend Transport; Mon, 27 Jun 2022 13:24:48 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by DRHQMAIL105.nvidia.com
 (10.27.9.14) with Microsoft SMTP Server (TLS) id 15.0.1497.32; Mon, 27 Jun
 2022 13:24:48 +0000
Received: from localhost.localdomain (10.126.231.35) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.26; Mon, 27 Jun
 2022 06:24:45 -0700
From:   Petr Machata <petrm@nvidia.com>
To:     <netdev@vger.kernel.org>
CC:     David Ahern <dsahern@gmail.com>,
        Stephen Hemminger <stephen@networkplumber.org>,
        Petr Machata <petrm@nvidia.com>,
        Tariq Toukan <tariqt@nvidia.com>,
        Itay Aveksis <itayav@nvidia.com>
Subject: [PATCH iproute2-next] ip: Fix rx_otherhost_dropped support
Date:   Mon, 27 Jun 2022 15:24:31 +0200
Message-ID: <207bb26a9fde5104920b85a9266481aac9fdd052.1656336125.git.petrm@nvidia.com>
X-Mailer: git-send-email 2.36.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.126.231.35]
X-ClientProxiedBy: rnnvmail201.nvidia.com (10.129.68.8) To
 rnnvmail201.nvidia.com (10.129.68.8)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: a2080092-c8c1-45df-c0a2-08da58406902
X-MS-TrafficTypeDiagnostic: DM6PR12MB3371:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: t0Rlm6GCGKa1aQpRuIc0X6YzTkm8sHcnratspTMLs5Ds24gz/pXPk+cJANsEagNim7RkYhyjgq8NHBhU3EhhzoaaOogwK0CtvMw0pt9s+G64MuwUgNK2yyZHlk6WboaOV8iECUOUobyZqkkYHkCd9PtTgEh2lS2QjradeN1w4ix+XDxjH6RAbuxarsSVzNxMiFYAsKbba/hgI87DywRbpDcUZE7LMco8Guuitpnqfpe6XUVh2P3cYmCg0MobnXuUUkhecykjnFAqKUZocF7jUn7A+J7078ARSSMTOdaTHog9HUtn0a+SAgScL4UVS2Nl8HRHqFKunXv88AJdm3CYELN1qxY7skq6W2kdIYf4J/XLICjLcQJfQPyzRl4tawTzLAftmKRqWH/Ne0+M1cdmcIb6kTZ+jC03mpMyed+DxIxsVXqyJNuD0KlOxSINKyx4NwtPcBOEO/VEmBRQihDDBLJ6+uvpE/fN/Mnmm5Tz44S5nTR2KochFg2L2iqe2hv06rixvxl8MFeaWTEHvoU95buaKP0nMTtwGTnY0HTmKhIlH412jzV72U21Jb7dLgbs2+HjMEvKiXc2TrR3H9FETAlCHXvcvXx+GVnXYTYJaKTS2HBIAgHoT5bCMUkDXIayDSXMcMnIOpWqzKqO7QQuaAyWk81gVDUc2vFK36whHiAxNFPBxqlH0YN/i5v85VsHu4S/baaww3p8dmm/jOYJ8GYRVgMSPM6xN+joL5me54DpRrRf8ReMNawBac75NSaeLjJqYE9zQj8G6R6vFu80MaRvUB07gcDBPMxPQPF+UcSyn27JQP51F4HGeAO9BX8W5uIVbATag42qrkDdh3qvFA==
X-Forefront-Antispam-Report: CIP:12.22.5.238;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230016)(4636009)(396003)(346002)(376002)(136003)(39860400002)(40470700004)(46966006)(36840700001)(426003)(47076005)(36860700001)(336012)(36756003)(316002)(2906002)(2616005)(6916009)(6666004)(54906003)(40480700001)(186003)(4326008)(8676002)(16526019)(83380400001)(478600001)(40460700003)(107886003)(41300700001)(5660300002)(70206006)(8936002)(26005)(81166007)(82740400003)(70586007)(86362001)(82310400005)(356005)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Jun 2022 13:24:48.7567
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: a2080092-c8c1-45df-c0a2-08da58406902
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.238];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT045.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB3371
X-Spam-Status: No, score=-1.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The commit cited below added a new column to print_stats64(). However it
then updated only one call site, neglecting to update the remaining three.
As a result, in those not-updated invocations, size_columns() now accesses
a vararg argument that is not being passed, which is undefined behavior.

Fixes: cebf67a35d8a ("show rx_otherehost_dropped stat in ip link show")
CC: Tariq Toukan <tariqt@nvidia.com>
CC: Itay Aveksis <itayav@nvidia.com>
Signed-off-by: Petr Machata <petrm@nvidia.com>
---
 ip/ipaddress.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/ip/ipaddress.c b/ip/ipaddress.c
index 30f32746..1d2dc803 100644
--- a/ip/ipaddress.c
+++ b/ip/ipaddress.c
@@ -775,10 +775,12 @@ void print_stats64(FILE *fp, struct rtnl_link_stats64 *s,
 		if (what)
 			close_json_object();
 	} else {
+		uint64_t zero64 = 0;
+
 		size_columns(cols, ARRAY_SIZE(cols),
 			     s->rx_bytes, s->rx_packets, s->rx_errors,
 			     s->rx_dropped, s->rx_missed_errors,
-			     s->multicast, s->rx_compressed);
+			     s->multicast, s->rx_compressed, zero64);
 		if (show_stats > 1)
 			size_columns(cols, ARRAY_SIZE(cols), 0,
 				     s->rx_length_errors, s->rx_crc_errors,
@@ -788,7 +790,7 @@ void print_stats64(FILE *fp, struct rtnl_link_stats64 *s,
 		size_columns(cols, ARRAY_SIZE(cols),
 			     s->tx_bytes, s->tx_packets, s->tx_errors,
 			     s->tx_dropped, s->tx_carrier_errors,
-			     s->collisions, s->tx_compressed);
+			     s->collisions, s->tx_compressed, zero64);
 		if (show_stats > 1)
 			size_columns(cols, ARRAY_SIZE(cols), 0, 0,
 				     s->tx_aborted_errors, s->tx_fifo_errors,
@@ -796,7 +798,8 @@ void print_stats64(FILE *fp, struct rtnl_link_stats64 *s,
 				     s->tx_heartbeat_errors,
 				     (uint64_t)(carrier_changes ?
 						rta_getattr_u32(carrier_changes)
-						: 0));
+						: 0),
+				     zero64);
 
 		/* RX stats */
 		fprintf(fp, "    RX: %*s %*s %*s %*s %*s %*s %*s%s",
-- 
2.35.3


Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 48F5B52B90B
	for <lists+netdev@lfdr.de>; Wed, 18 May 2022 13:45:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235665AbiERLdY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 May 2022 07:33:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59362 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235636AbiERLdW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 May 2022 07:33:22 -0400
Received: from NAM04-BN8-obe.outbound.protection.outlook.com (mail-bn8nam08on2048.outbound.protection.outlook.com [40.107.100.48])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 74B7B5C863;
        Wed, 18 May 2022 04:33:19 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=GC9HUhSfywyXRVSfDwbPgKHEAQI1cismEuNi7mQXI7yAKRC88JeDK4IeCueQsVtd9e0TLgCE4JKzMWKpngHNagPsZtYqQPUlBYjAx2TSJqTpK4TPKLNNGHyzctbBzTIx7SbdSSKgcl4D5GQrOOUoUXs9RifzaEZpNG7QHtqK6BW4OPKE2QaLuqKDHrsewya1ZuKFZF4rshfy74u8Jqb0vuCTeUhJ7yLwudUd8nwxXfKxeZtk+/lkwppo/nDUzq1BAOZZG9fKVvo1ZeJ3JD7zi1jhR9xorytE7JQHAHiN891+oEh85NRUoilCPHilqzu1Fr6ExmEqs6m+J4oQgIqYAg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=+BHrt2PwNc4HD1YS0zv9n5DUDu9DqfPfSfExlo/19N8=;
 b=URpGe3fiB/pZgzrUG782eJ2FeiIA2y6OIzsh5ggrN27Aht8rf/7b1cbg2w77tdEL73OdAm9KJmn506yRRZKnKa85g21MLzoNtEm3IdCzsMC0yDTE2Ul948hHVyLykk4SmR1yU1akY3e3g5R3cTOBarAXBAKDMx2rqeENHmbb8X7LjO1hHgLE2SQcz56MyIBn3HPNq/SECXNLNMmiDYpPUghHCEXvkl1c2/zn6PLFgbbDjyPJKM0rGjqsGUpOM/26xDxlGPnNU5HiPUfdYLNP3NI3IHUr7NKZOYzs8wv+lTPyRjzm7GnyT5334M+E67W3/nwYx31OLaNkdOzhFEBdWA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 149.199.62.198) smtp.rcpttodomain=microchip.com smtp.mailfrom=xilinx.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=xilinx.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=xilinx.onmicrosoft.com; s=selector2-xilinx-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+BHrt2PwNc4HD1YS0zv9n5DUDu9DqfPfSfExlo/19N8=;
 b=d5GKNPFGSheKvbR6LFE8t8fnMw3tQldeGXTkGJ6Xu70ZLW1yWvVXD2+Re8boTLmDyYoRBMS1Gzkb0j7Egz9Fc3KuODqQNxQ4XZqrXCXTiXZTrdIlkx/zlf14whAWkTVBKdUCBxCwTGTuJt9liA8wvtrZJNeKAwZgekXm7lI9PBQ=
Received: from BN9PR03CA0873.namprd03.prod.outlook.com (2603:10b6:408:13c::8)
 by DM5PR02MB2860.namprd02.prod.outlook.com (2603:10b6:3:113::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5273.14; Wed, 18 May
 2022 11:33:17 +0000
Received: from BN1NAM02FT014.eop-nam02.prod.protection.outlook.com
 (2603:10b6:408:13c:cafe::fe) by BN9PR03CA0873.outlook.office365.com
 (2603:10b6:408:13c::8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5273.13 via Frontend
 Transport; Wed, 18 May 2022 11:33:17 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 149.199.62.198)
 smtp.mailfrom=xilinx.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=xilinx.com;
Received-SPF: Pass (protection.outlook.com: domain of xilinx.com designates
 149.199.62.198 as permitted sender) receiver=protection.outlook.com;
 client-ip=149.199.62.198; helo=xsj-pvapexch02.xlnx.xilinx.com; pr=C
Received: from xsj-pvapexch02.xlnx.xilinx.com (149.199.62.198) by
 BN1NAM02FT014.mail.protection.outlook.com (10.13.2.131) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.5273.14 via Frontend Transport; Wed, 18 May 2022 11:33:17 +0000
Received: from xsj-pvapexch02.xlnx.xilinx.com (172.19.86.41) by
 xsj-pvapexch02.xlnx.xilinx.com (172.19.86.41) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.14; Wed, 18 May 2022 04:33:15 -0700
Received: from smtp.xilinx.com (172.19.127.96) by
 xsj-pvapexch02.xlnx.xilinx.com (172.19.86.41) with Microsoft SMTP Server id
 15.1.2176.14 via Frontend Transport; Wed, 18 May 2022 04:33:15 -0700
Envelope-to: nicolas.ferre@microchip.com,
 davem@davemloft.net,
 richardcochran@gmail.com,
 claudiu.beznea@microchip.com,
 kuba@kernel.org,
 edumazet@google.com,
 pabeni@redhat.com,
 netdev@vger.kernel.org,
 linux-kernel@vger.kernel.org,
 harinikatakamlinux@gmail.com
Received: from [10.140.6.13] (port=41766 helo=xhdharinik40.xilinx.com)
        by smtp.xilinx.com with esmtp (Exim 4.90)
        (envelope-from <harini.katakam@xilinx.com>)
        id 1nrHvW-000DlO-M7; Wed, 18 May 2022 04:33:15 -0700
From:   Harini Katakam <harini.katakam@xilinx.com>
To:     <nicolas.ferre@microchip.com>, <davem@davemloft.net>,
        <richardcochran@gmail.com>, <claudiu.beznea@microchip.com>,
        <kuba@kernel.org>, <edumazet@google.com>, <pabeni@redhat.com>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <michal.simek@xilinx.com>, <harinikatakamlinux@gmail.com>,
        <harini.katakam@xilinx.com>, <radhey.shyam.pandey@xilinx.com>
Subject: [PATCH net v2 0/2] Macb PTP one step fix
Date:   Wed, 18 May 2022 17:03:08 +0530
Message-ID: <20220518113310.28132-1-harini.katakam@xilinx.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 23996aec-8671-4488-cf54-08da38c233f5
X-MS-TrafficTypeDiagnostic: DM5PR02MB2860:EE_
X-Microsoft-Antispam-PRVS: <DM5PR02MB28604AF78337625B65F347C2C9D19@DM5PR02MB2860.namprd02.prod.outlook.com>
X-Auto-Response-Suppress: DR, RN, NRN, OOF, AutoReply
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: HCQPPGMOs9WOeZ6LgGDq7O7P0Px3swwNWqxLm9tCREh5rr+l0RBEqO0asHtDaZlpFevDoW7pG6ZhBXq/0QLCjUGSFi0Uj+HEPTyf4cqu4gLioqBYFPwSEZ+Ytgls7p7BKaHV2nNVdaNGfHmHlS08YWtRUOMqTvKGm49TSNOdsB6n2i1U3u6CoydgvvGXT7qHNdOI7X5MwD9uavSEKeUJSfGNtNcpwmKBu7iFzC0n47K09+XmnCGyDAKRfywq+s2ZcCYz5OYwqbvo9b6SGqMsyz/lXYwmoF1R6GEIKIGMj41l+iRpLTPjkqjRAIK5FPKRLZFIl9I/Favz+LjkN7Yt9+qBwBTy33zrrl8v2QdsU7MM2zEgtDcJ3YyhFbh6crTD4yKyiZPKFFdndXyepKh036rijVzPev8D+HpZvMjvw0QttUYcnELWs8eSuz+G3bqbp0bcZhb16wGEcy0oXDIuFc0cxxhGp4+3X/j+/lwooU7zB5aFf0WRy1lv/2Tdy1iucsfTKeoZpEHVP5l6LezuJJwWvWX3u8pDCRh2frJ2i59Cb3rPz3Yy6NPu7GJ1xE7jWch2O5lku4UbLjwotHtWDCNEkQnvjwLvvy8DahxtQNEBY+lDwyulNjP6dJhL3wyRyCph9x+QfU0q87FLBN208X5E0ZJx9u1M/wg3W+CiofXmuzqjepBpl6TGVLjlZzUGwan/CJIbomZzzNJPvCDRv+GrzQTKYD3wfy7iMtc6lQm5jdJVxGsMV9QLI42/uvmmAOoawkA4v2rZ39Lc1C+BJNybts2L6BPRoWEaIadDiJA=
X-Forefront-Antispam-Report: CIP:149.199.62.198;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:xsj-pvapexch02.xlnx.xilinx.com;PTR:unknown-62-198.xilinx.com;CAT:NONE;SFS:(13230001)(4636009)(46966006)(36840700001)(40470700004)(2616005)(82310400005)(1076003)(336012)(47076005)(110136005)(356005)(54906003)(4744005)(8676002)(107886003)(4326008)(70586007)(6666004)(70206006)(7636003)(7696005)(5660300002)(186003)(2906002)(7416002)(40460700003)(83380400001)(8936002)(36860700001)(26005)(9786002)(426003)(316002)(36756003)(44832011)(966005)(508600001)(102446001);DIR:OUT;SFP:1101;
X-OriginatorOrg: xilinx.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 May 2022 11:33:17.1498
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 23996aec-8671-4488-cf54-08da38c233f5
X-MS-Exchange-CrossTenant-Id: 657af505-d5df-48d0-8300-c31994686c5c
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=657af505-d5df-48d0-8300-c31994686c5c;Ip=[149.199.62.198];Helo=[xsj-pvapexch02.xlnx.xilinx.com]
X-MS-Exchange-CrossTenant-AuthSource: BN1NAM02FT014.eop-nam02.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR02MB2860
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Split from "Macb PTP updates" series
https://lore.kernel.org/netdev/20220517135525.GC3344@hoboy.vegasvil.org/T/
- Fix Macb PTP one step.
- Add common twoStepflag field definition.

Harini Katakam (2):
  include: ptp: Add common two step flag mask
  net: macb: Fix PTP one step sync support

 drivers/net/ethernet/cadence/macb_main.c | 41 +++++++++++++++++++++---
 drivers/net/ethernet/cadence/macb_ptp.c  |  4 ++-
 include/linux/ptp_classify.h             |  3 ++
 3 files changed, 43 insertions(+), 5 deletions(-)

-- 
2.17.1


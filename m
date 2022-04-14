Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8A094500DBB
	for <lists+netdev@lfdr.de>; Thu, 14 Apr 2022 14:38:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243450AbiDNMka (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Apr 2022 08:40:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40120 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240342AbiDNMk3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 Apr 2022 08:40:29 -0400
Received: from NAM02-BN1-obe.outbound.protection.outlook.com (mail-bn1nam07on2088.outbound.protection.outlook.com [40.107.212.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0C1C690256;
        Thu, 14 Apr 2022 05:38:05 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HYPXgR6Rieeb2eXJ7XmlH2aBmlK8xSWhBdsRJqoPD9RFEpiVS3FjzP+apBUi/q/ARVxcVjfAqd2wL2NLqLQb79cRErtMh49hzszCi8BcQVYdSCyLH7ipnZxsyEio1RpkNie/FTeHwg5Odr+O6XhHEG1FcUfM9U3837/BU6t89V16Vm23ApTjS0InRELLqOACMUW/86fQdpBWKDgF5EUB+/ISJHoI8DfgjDK3lB6BO42k1F8o1hx3MiavR9C37c4CCZYPS6NnBwe0Tkt31RhSb4EbGJvtzFZCmNyqpOq7RRYL9JA+BwhdOzpZEiRMkCaN0Qw0B612P9gzrqyGT2DRKw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=8pn1lO4gZuzlwU6BMg0/WVkCEn/FoM0TglVS9ZPhiqI=;
 b=nt7Qvx3VlDhSa3o+E24MIV5qTElyMbx8AIAX3eWeBSFJhMVJrvyRM79qhPFJHakqX7/5R9xA+AbiIwxhwiksCGNOQPY+AeClp7RVJwEEILlrv++INgPnFzREqaD5cS0CnrAz2R8DUrWZYLHTUTjDUWIMkGBr+D8qouS0HmQCC2Mo7zDOGcc/nXY/jfSYdc8pR7NdCj0yMvCG9GPdxGLqIRtU+z7Ea9eVdvaiV9johjoljckUCpXHD5BK+kACfl5PWej++eoUWzekYIM13+6G34CQWRtLF7TUbtl4dAeDjY9Xo10+K0ExYUYgbuXwApAjgMJJJgQ1tha2H5dNpRTY0A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 149.199.62.198) smtp.rcpttodomain=davemloft.net smtp.mailfrom=xilinx.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=xilinx.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=xilinx.onmicrosoft.com; s=selector2-xilinx-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8pn1lO4gZuzlwU6BMg0/WVkCEn/FoM0TglVS9ZPhiqI=;
 b=H1O1C20pJvug2oEKTWxoNldB2DophaT0kE8zKy8uC+4Cm+mS6IAPHT8X989fR+OO05MSL7Q0W+8FtkWMJvWBv6ihhYmti607kvMq8GZWAHwN7KhMUJTkqsP3UnnwCaDAI8wfQ4RiZJVLTUEWgIi3iA+v6YhiQQTzS1ZmXG+HQ9Q=
Received: from BN9PR03CA0809.namprd03.prod.outlook.com (2603:10b6:408:13f::34)
 by BL0PR02MB5699.namprd02.prod.outlook.com (2603:10b6:208:80::32) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5164.18; Thu, 14 Apr
 2022 12:38:01 +0000
Received: from BN1NAM02FT031.eop-nam02.prod.protection.outlook.com
 (2603:10b6:408:13f:cafe::56) by BN9PR03CA0809.outlook.office365.com
 (2603:10b6:408:13f::34) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5164.20 via Frontend
 Transport; Thu, 14 Apr 2022 12:38:01 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 149.199.62.198)
 smtp.mailfrom=xilinx.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=xilinx.com;
Received-SPF: Pass (protection.outlook.com: domain of xilinx.com designates
 149.199.62.198 as permitted sender) receiver=protection.outlook.com;
 client-ip=149.199.62.198; helo=xsj-pvapexch01.xlnx.xilinx.com;
Received: from xsj-pvapexch01.xlnx.xilinx.com (149.199.62.198) by
 BN1NAM02FT031.mail.protection.outlook.com (10.13.2.145) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.5164.19 via Frontend Transport; Thu, 14 Apr 2022 12:38:01 +0000
Received: from xsj-pvapexch02.xlnx.xilinx.com (172.19.86.41) by
 xsj-pvapexch01.xlnx.xilinx.com (172.19.86.40) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.14; Thu, 14 Apr 2022 05:37:46 -0700
Received: from smtp.xilinx.com (172.19.127.96) by
 xsj-pvapexch02.xlnx.xilinx.com (172.19.86.41) with Microsoft SMTP Server id
 15.1.2176.14 via Frontend Transport; Thu, 14 Apr 2022 05:37:46 -0700
Envelope-to: git@xilinx.com,
 davem@davemloft.net,
 kuba@kernel.org,
 linux-arm-kernel@lists.infradead.org,
 andrew@lunn.ch,
 pabeni@redhat.com,
 linux-kernel@vger.kernel.org,
 netdev@vger.kernel.org
Received: from [172.23.64.6] (port=53840 helo=xhdvnc106.xilinx.com)
        by smtp.xilinx.com with esmtp (Exim 4.90)
        (envelope-from <radhey.shyam.pandey@xilinx.com>)
        id 1neyjK-0006sK-9I; Thu, 14 Apr 2022 05:37:46 -0700
Received: by xhdvnc106.xilinx.com (Postfix, from userid 13245)
        id F27DF61066; Thu, 14 Apr 2022 18:07:18 +0530 (IST)
From:   Radhey Shyam Pandey <radhey.shyam.pandey@xilinx.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <pabeni@redhat.com>,
        <andrew@lunn.ch>
CC:     <michal.simek@xilinx.com>, <netdev@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>, <git@xilinx.com>,
        Radhey Shyam Pandey <radhey.shyam.pandey@xilinx.com>
Subject: [PATCH net-next 2/3] net: emaclite: Update copyright text to correct format
Date:   Thu, 14 Apr 2022 18:07:10 +0530
Message-ID: <1649939831-14901-3-git-send-email-radhey.shyam.pandey@xilinx.com>
X-Mailer: git-send-email 2.1.1
In-Reply-To: <1649939831-14901-1-git-send-email-radhey.shyam.pandey@xilinx.com>
References: <1649939831-14901-1-git-send-email-radhey.shyam.pandey@xilinx.com>
MIME-Version: 1.0
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: bf4bfa8e-c5bc-4485-4010-08da1e139cf7
X-MS-TrafficTypeDiagnostic: BL0PR02MB5699:EE_
X-Microsoft-Antispam-PRVS: <BL0PR02MB56995E9CF04D1B63BE554822C7EF9@BL0PR02MB5699.namprd02.prod.outlook.com>
X-Auto-Response-Suppress: DR, RN, NRN, OOF, AutoReply
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 0I/odbwozhIjOn0lpHYHKmSreL72hRfwgcSodUA/3zgwrZGyNLxa4Bd06qLJVTAzOWqGtRfExVopHD1tj8Pxvyi4hgOL6VcEkFK4obzS8hn0+K4IYgZPOOMXS2K58fmMKzgcOc5Pg8/wiQWXV1uzYAgPPWkYTv5mnK5eGHDF27QlgkEvDkHxWoQpdvkWXkxGe0EcjcaSvCIBONowXxczfjgZSzVu8ycYrK2LvDxwvachfu+47q4dQkcCUdABbtKOhCgLqe2pbC1d7GBiLlPPh6GdqfiXdN9ysn2wVjLK7EIrhDLvMQwmX3JvrRjRq/hBJvBG4J5q+UUyDG+i+nTkJwY4K0GXk423bp8Lpgw7e8heZoPV+QQQZADMEzbxYoGglm0HCq5k5zRWRmMA4qzM0qa+cj+nc//eM07QMvvZVMjuk5iRYmShZshKmPlgR7p+h+WPqvsv0Ypljh2lfoTeFdjOGCurSTMVL1JmnuQHIPowjj2q9akv7UraktEjk+dNuZ5O6M8xJG/dxCYvy4RZvfQ7ChInN1pLyN9j1taq63PEVb8m0uOXlkk8tGAEnbfuXC2yzcUR2mU7U6I/kBl0N0Zbpqe4xcNgiBjBUEvWmzTL7UH0Eg+xEq8r+Bb0KaCuzUhWJrmF1n3h15LwGlmMNJb4nhWXDGKt021ZcHE8ojWYhvs65EpSsZsbAC++s89YF+6DhJxNcAHGXxl/5REzfA==
X-Forefront-Antispam-Report: CIP:149.199.62.198;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:xsj-pvapexch01.xlnx.xilinx.com;PTR:unknown-62-198.xilinx.com;CAT:NONE;SFS:(13230001)(4636009)(36840700001)(46966006)(40470700004)(316002)(42186006)(508600001)(107886003)(356005)(47076005)(2616005)(110136005)(54906003)(70586007)(6666004)(336012)(426003)(36860700001)(186003)(7636003)(8676002)(6266002)(70206006)(4326008)(8936002)(26005)(82310400005)(4744005)(40460700003)(83380400001)(5660300002)(2906002)(36756003)(102446001);DIR:OUT;SFP:1101;
X-OriginatorOrg: xilinx.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Apr 2022 12:38:01.1445
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: bf4bfa8e-c5bc-4485-4010-08da1e139cf7
X-MS-Exchange-CrossTenant-Id: 657af505-d5df-48d0-8300-c31994686c5c
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=657af505-d5df-48d0-8300-c31994686c5c;Ip=[149.199.62.198];Helo=[xsj-pvapexch01.xlnx.xilinx.com]
X-MS-Exchange-CrossTenant-AuthSource: BN1NAM02FT031.eop-nam02.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL0PR02MB5699
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Michal Simek <michal.simek@xilinx.com>

Based on recommended guidance Copyright term should be also present in
front of (c). That's why aligned driver to match this pattern.
It helps automated tools with source code scanning.

Signed-off-by: Michal Simek <michal.simek@xilinx.com>
Signed-off-by: Radhey Shyam Pandey <radhey.shyam.pandey@xilinx.com>
---
 drivers/net/ethernet/xilinx/xilinx_emaclite.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/xilinx/xilinx_emaclite.c b/drivers/net/ethernet/xilinx/xilinx_emaclite.c
index 6294b714fbfa..bb9c3ebde522 100644
--- a/drivers/net/ethernet/xilinx/xilinx_emaclite.c
+++ b/drivers/net/ethernet/xilinx/xilinx_emaclite.c
@@ -4,7 +4,7 @@
  * This is a new flat driver which is based on the original emac_lite
  * driver from John Williams <john.williams@xilinx.com>.
  *
- * 2007 - 2013 (c) Xilinx, Inc.
+ * Copyright (c) 2007 - 2013 Xilinx, Inc.
  */
 
 #include <linux/module.h>
-- 
2.7.4


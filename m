Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 600D1587AE7
	for <lists+netdev@lfdr.de>; Tue,  2 Aug 2022 12:44:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236378AbiHBKn7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Aug 2022 06:43:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49976 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232660AbiHBKn5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 2 Aug 2022 06:43:57 -0400
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2073.outbound.protection.outlook.com [40.107.220.73])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2DB7022539;
        Tue,  2 Aug 2022 03:43:57 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=iBREsuWO0XjyCaWUfb9LG7gUaCev2b+OsLGrvHgxL1ZhiEw7jg/5l/I26Cm/eaiSZRtV8CBr/C4DqeXFjmorv32/IP5XD6sMCNm2pOfouYptdNUw57jWGY/e8Fz73ftIC9OKJAJbqlLieSK5k6JsAoS43eIIW8ErHGcjoMEcxo5HBmSqI7bxdsuTQtYGuP9TYcQQanojc0vBTYkIEEPdgNRmxnZLdmPGTtaYAke9Jjc79GTbV0oTFyC6zv7JLTKks5VFxIpUjzc8j0lSYqxWhqV+WDsWVFC3ZeaWxdDurxnO5KdxAM9qcX9CRwTNc2wi4DESU3LbszdDN3vaARs+0g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=4+8rrOpBnpEcegpoqWTfBZwYdmwOy/9zOgIWRDvrZRk=;
 b=cafCgso5xRf/8IRx2DnPk0K/yXEKLPEpkwwnKgeBviBaUR13aX0HAq2m/vlzreBk44hq0xS8nJ9HFczmuYDBZLi0uYZb5aBVjKR8hXUUYeXiRrLT+PaWTeODh3OvMaVMDuf46L4sAsZb+BGeL22V+zpngs7gPnQgYb2Ibx8KYoMPTPcVX4HPi7kkg1ftEaZCXHRet6Mt7qAIPYq7AVn/L8OeYlyAOHnXPkPvUbc7KBVT4U0wmwQ2LJkJHg9h8AS7Jevg5xZrHgtCmF1GjD71eYYzM7HsiwpWUsQr5eNLr9dNcAIwIlgqXa+Th67MysBE2q1MuUXT/z54y0WnIV7JWA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 149.199.62.198) smtp.rcpttodomain=microchip.com smtp.mailfrom=xilinx.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=xilinx.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=xilinx.onmicrosoft.com; s=selector2-xilinx-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4+8rrOpBnpEcegpoqWTfBZwYdmwOy/9zOgIWRDvrZRk=;
 b=PVzM9l6EVp99Uoa18IU3jRZSdwePyNEKgpAYncuza7O8vK3MFaS0nDylMtFSfXw7TfhxcHjyduY4oxOzJiSZa7lUudhBrG1MyBdwNjNNf2ou19JmjmTTRPIiWpoag2IjDj33Z0gXTLJEh9qzc9nCmWTRiaMHvl6bjg8dccDlnm0=
Received: from DM6PR18CA0019.namprd18.prod.outlook.com (2603:10b6:5:15b::32)
 by SJ0PR02MB8609.namprd02.prod.outlook.com (2603:10b6:a03:3e4::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5482.12; Tue, 2 Aug
 2022 10:43:53 +0000
Received: from DM3NAM02FT061.eop-nam02.prod.protection.outlook.com
 (2603:10b6:5:15b:cafe::23) by DM6PR18CA0019.outlook.office365.com
 (2603:10b6:5:15b::32) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5458.19 via Frontend
 Transport; Tue, 2 Aug 2022 10:43:53 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 149.199.62.198)
 smtp.mailfrom=xilinx.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=xilinx.com;
Received-SPF: Pass (protection.outlook.com: domain of xilinx.com designates
 149.199.62.198 as permitted sender) receiver=protection.outlook.com;
 client-ip=149.199.62.198; helo=xsj-pvapexch01.xlnx.xilinx.com; pr=C
Received: from xsj-pvapexch01.xlnx.xilinx.com (149.199.62.198) by
 DM3NAM02FT061.mail.protection.outlook.com (10.13.4.230) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.5482.10 via Frontend Transport; Tue, 2 Aug 2022 10:43:52 +0000
Received: from xsj-pvapexch02.xlnx.xilinx.com (172.19.86.41) by
 xsj-pvapexch01.xlnx.xilinx.com (172.19.86.40) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.14; Tue, 2 Aug 2022 03:43:51 -0700
Received: from smtp.xilinx.com (172.19.127.96) by
 xsj-pvapexch02.xlnx.xilinx.com (172.19.86.41) with Microsoft SMTP Server id
 15.1.2176.14 via Frontend Transport; Tue, 2 Aug 2022 03:43:51 -0700
Envelope-to: nicolas.ferre@microchip.com,
 davem@davemloft.net,
 richardcochran@gmail.com,
 claudiu.beznea@microchip.com,
 andrei.pistirica@microchip.com,
 kuba@kernel.org,
 edumazet@google.com,
 pabeni@redhat.com,
 netdev@vger.kernel.org,
 linux-kernel@vger.kernel.org,
 harinikatakamlinux@gmail.com,
 michal.simek@amd.com,
 harini.katakam@amd.com,
 radhey.shyam.pandey@amd.com
Received: from [10.140.6.13] (port=38092 helo=xhdharinik40.xilinx.com)
        by smtp.xilinx.com with esmtp (Exim 4.90)
        (envelope-from <harini.katakam@xilinx.com>)
        id 1oIpNO-0004qa-PC; Tue, 02 Aug 2022 03:43:51 -0700
From:   Harini Katakam <harini.katakam@xilinx.com>
To:     <nicolas.ferre@microchip.com>, <davem@davemloft.net>,
        <richardcochran@gmail.com>, <claudiu.beznea@microchip.com>,
        <andrei.pistirica@microchip.com>, <kuba@kernel.org>,
        <edumazet@google.com>, <pabeni@redhat.com>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <michal.simek@xilinx.com>, <harinikatakamlinux@gmail.com>,
        <harini.katakam@xilinx.com>, <michal.simek@amd.com>,
        <harini.katakam@amd.com>, <radhey.shyam.pandey@amd.com>
Subject: [PATCH 0/2] Macb PTP enhancements
Date:   Tue, 2 Aug 2022 16:13:44 +0530
Message-ID: <20220802104346.29335-1-harini.katakam@xilinx.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 0ee1e0c6-3201-4104-d4bb-08da7473e481
X-MS-TrafficTypeDiagnostic: SJ0PR02MB8609:EE_
X-Auto-Response-Suppress: DR, RN, NRN, OOF, AutoReply
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: slC9XD2jlc4JBwahH9TJc4RH7MlMWhLbbrGIl/I1JlAKdrXFOo35Yjk8aWrFlhimKEUfh9vCAyaFRMCdAuwV+6lf9zuaMFvOORgMVZTDqyVpLJTHBnHdfi92H+jTnFy9pg/qOB2wmdUhAHnEW5HYIsj1XhJ0fiIAMixNKLvrRwB/aHWyYsJo90s3YHf8N7RxopthLJ3OEVOvXTXla3qOgjs4m6FWmSA9taC+cyn+ZWK4GNHHKlyaVLaip2NvHDaYCPyrVkN//tMTZoFXohpSls2NCFN3Zp51MrUX93vqMHa7pJr04rjbOvz6p9eCHt45+3PPVzUW5i2yZt9r8FWTmJ6z3ang67lbyHYGkUlfJ3iA/lHpOx1/vR8SUBlijlo/epaM63Zga61P9GGpNGvhgD4mgZPNKVDj0CDeKdw2D1DsLx03w5PA9IgFVzBsCRl7rlPKJ52X6SV/2Iebg6XOXKoG/h4pBhlmBfygiruvEEgGj8wJDPF0iMrJNlHwxUvevYVvQgmV0rnKlFV70HQCibwWA+llufDNm4aMzjxmIlpmsVtZineBspu5pMjpU8z90TwCsCgv3WkyApb9f2l8xfQK2AMe9rTkGfg0nYQbksvd1kqMpzdAWZ5hveYrhn4NofODUe+DTvchtxBEd+6opjaTiD71r9XqLIFcQcnIzT7p0z88D4CuuVgE4VQ/7+CsjAdccColwIEWiKH8ADl7vGRVGQOf9D+ZAwapZWZofU4w9FxpyMFnXwbbC7gf9bPhMbG0GqqxzSOHE6tNJR7Zv8kmtQ3M8vEG8KaBBfTRR1gGQ4N685lJgQbqczZjvlTpRnnRuvXgkDNeFn5XANj2+FgT5EUPPP8/SnXWEVETerjgc+uBLD3q/OeHbr86Nh5UVcM+uyQ8AEbxi8vSHVXuYw==
X-Forefront-Antispam-Report: CIP:149.199.62.198;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:xsj-pvapexch01.xlnx.xilinx.com;PTR:unknown-62-198.xilinx.com;CAT:NONE;SFS:(13230016)(4636009)(376002)(39860400002)(136003)(346002)(396003)(40470700004)(36840700001)(46966006)(40480700001)(40460700003)(110136005)(54906003)(36756003)(36860700001)(83380400001)(8936002)(9786002)(70206006)(70586007)(4326008)(8676002)(478600001)(966005)(7636003)(186003)(2616005)(82740400003)(356005)(4744005)(5660300002)(6666004)(7416002)(44832011)(41300700001)(336012)(426003)(47076005)(2906002)(316002)(26005)(1076003)(82310400005)(7696005)(102446001);DIR:OUT;SFP:1101;
X-OriginatorOrg: xilinx.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Aug 2022 10:43:52.9183
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 0ee1e0c6-3201-4104-d4bb-08da7473e481
X-MS-Exchange-CrossTenant-Id: 657af505-d5df-48d0-8300-c31994686c5c
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=657af505-d5df-48d0-8300-c31994686c5c;Ip=[149.199.62.198];Helo=[xsj-pvapexch01.xlnx.xilinx.com]
X-MS-Exchange-CrossTenant-AuthSource: DM3NAM02FT061.eop-nam02.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR02MB8609
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Harini Katakam <harini.katakam@amd.com>

This series is a follow up for patches 2 and 3 from a previous series:
https://lore.kernel.org/all/ca4c97c9-1117-a465-5202-e1bf276fe75b@microchip.com/
https://lore.kernel.org/all/20220517135525.GC3344@hoboy.vegasvil.org/
Sorry for the delay.

ACK is added only to patch 3 (now patch 2).
Patch 1 is updated with check for gem_has_ptp as per Claudiu's comments.

Harini Katakam (2):
  net: macb: Enable PTP unicast
  net: macb: Optimize reading HW timestamp

 drivers/net/ethernet/cadence/macb.h      |  4 ++++
 drivers/net/ethernet/cadence/macb_main.c | 13 ++++++++++++-
 drivers/net/ethernet/cadence/macb_ptp.c  |  8 ++++++--
 3 files changed, 22 insertions(+), 3 deletions(-)

-- 
2.17.1


Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B227D529ADE
	for <lists+netdev@lfdr.de>; Tue, 17 May 2022 09:33:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241213AbiEQHdZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 May 2022 03:33:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34578 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241431AbiEQHdP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 May 2022 03:33:15 -0400
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2062.outbound.protection.outlook.com [40.107.237.62])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B880B483BB;
        Tue, 17 May 2022 00:33:09 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=YJHfiVsUDykSPr5+k151RDcZIeCNT1afz4WMhHSQ+344SoeTAKh6P+3PI01q3b5aHIjVD9Q+xEeovXgsJG0GkECt/1tNYl97QC7tVyksiu+pRkVec/hblTVsx0iVjw6EeWtvIc6Zp0VgSwe/M1XmODOuU8s2hpcda7KAVR66ciC+kNnfHrUwZ/7QKBwd6jKALzduJjmdxtziFGg/7l83xl50rlxqM9WLLeV864u4LyqEvKyqsSU1g22Es8SyUFyO6x38ssCUYGUwmC7uFxdfcJdIny/dspp61E8mMZlcHsTsyWvm3X2Yfa3jsES3UfORrcj0X1VjC2gvs2AFIHhfOQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=PJO2/UqQXOTiG2HBuMZte525u9YRMZUNc7NuyzFtt4M=;
 b=ceDdpipkdpXxo+usqvd6bKi3sHktSxKLmh+2eKCUX3WCYhOzDh1rAKkMstC/z8m9ckLb8X4BkchhcD33K6TwYyNVqnT8tzAthXaEK6reoh6oZ8tRTLlBVfeA1ODeDvbQjlxfKR+GBwgoCn1qF6IFsMVLneq+2gjPAJMpUyOxHkjgHR6At7hCJiD+W+r2egYVqQ8A7wLCA0ZKB7jzBVl4oYpCAC2ZhcBM90bR8Xmht7E9Q5cuqRCHSJjDfe3SsZSMt7QZhLlNDyClnXFHJ+VbCZOC7JtWX8lF9whhc/zFek3dPtGOtLixwJBu2fSQ60Q+fF+kyF/IKlmopi8zyDuSXw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 149.199.62.198) smtp.rcpttodomain=microchip.com smtp.mailfrom=xilinx.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=xilinx.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=xilinx.onmicrosoft.com; s=selector2-xilinx-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=PJO2/UqQXOTiG2HBuMZte525u9YRMZUNc7NuyzFtt4M=;
 b=ViHVPzR2RKNLuqpkLrjSAi5tzqxWLEJYhzvjQKdI9qizJVlK0Q+WNGvSN2JJEkT6Hsy8HVw5Q8dWKyQUtYLCJLWnRoVOS7gvTfjwMbhL3c8EDAkw23ZVv3YDSpK7mC5npCUCo9fiwT2yQg8Yt4/6HKzVPvJh0I3DfPDp4mQ8az8=
Received: from BN9PR03CA0306.namprd03.prod.outlook.com (2603:10b6:408:112::11)
 by BN7PR02MB4994.namprd02.prod.outlook.com (2603:10b6:408:2a::25) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5250.16; Tue, 17 May
 2022 07:33:07 +0000
Received: from BN1NAM02FT051.eop-nam02.prod.protection.outlook.com
 (2603:10b6:408:112:cafe::a9) by BN9PR03CA0306.outlook.office365.com
 (2603:10b6:408:112::11) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5250.14 via Frontend
 Transport; Tue, 17 May 2022 07:33:07 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 149.199.62.198)
 smtp.mailfrom=xilinx.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=xilinx.com;
Received-SPF: Pass (protection.outlook.com: domain of xilinx.com designates
 149.199.62.198 as permitted sender) receiver=protection.outlook.com;
 client-ip=149.199.62.198; helo=xsj-pvapexch01.xlnx.xilinx.com;
Received: from xsj-pvapexch01.xlnx.xilinx.com (149.199.62.198) by
 BN1NAM02FT051.mail.protection.outlook.com (10.13.2.159) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.5250.13 via Frontend Transport; Tue, 17 May 2022 07:33:07 +0000
Received: from xsj-pvapexch02.xlnx.xilinx.com (172.19.86.41) by
 xsj-pvapexch01.xlnx.xilinx.com (172.19.86.40) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.14; Tue, 17 May 2022 00:33:03 -0700
Received: from smtp.xilinx.com (172.19.127.96) by
 xsj-pvapexch02.xlnx.xilinx.com (172.19.86.41) with Microsoft SMTP Server id
 15.1.2176.14 via Frontend Transport; Tue, 17 May 2022 00:33:03 -0700
Envelope-to: nicolas.ferre@microchip.com,
 davem@davemloft.net,
 richardcochran@gmail.com,
 claudiu.beznea@microchip.com,
 kuba@kernel.org,
 pabeni@redhat.com,
 netdev@vger.kernel.org,
 linux-kernel@vger.kernel.org,
 harinikatakamlinux@gmail.com
Received: from [10.140.6.13] (port=40442 helo=xhdharinik40.xilinx.com)
        by smtp.xilinx.com with esmtp (Exim 4.90)
        (envelope-from <harini.katakam@xilinx.com>)
        id 1nqrhX-000GAX-D7; Tue, 17 May 2022 00:33:03 -0700
From:   Harini Katakam <harini.katakam@xilinx.com>
To:     <nicolas.ferre@microchip.com>, <davem@davemloft.net>,
        <richardcochran@gmail.com>, <claudiu.beznea@microchip.com>,
        <kuba@kernel.org>, <pabeni@redhat.com>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <michal.simek@xilinx.com>, <harinikatakamlinux@gmail.com>,
        <harini.katakam@xilinx.com>, <radhey.shyam.pandey@xilinx.com>
Subject: [PATCH 0/3] Macb PTP updates
Date:   Tue, 17 May 2022 13:02:56 +0530
Message-ID: <20220517073259.23476-1-harini.katakam@xilinx.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: afd473f2-9713-495d-8147-08da37d77c9b
X-MS-TrafficTypeDiagnostic: BN7PR02MB4994:EE_
X-Microsoft-Antispam-PRVS: <BN7PR02MB4994A7832663AE46847A3426C9CE9@BN7PR02MB4994.namprd02.prod.outlook.com>
X-Auto-Response-Suppress: DR, RN, NRN, OOF, AutoReply
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: G5FalLh2piL3vBb/u0syiVZGYTIAUezD0FkxMOhl0+mgPGnKPehlpvyR7ccWv8RjxMfWRYSK8qnz6DuFWLr3MOnfN7n7svkuxND4xhExbGpbV6OhtqOBhmwfbXUq4+L9hXduzqpvsVLzp4aIjtlYbWHqjNTczTJRcheQVFV4+MD0H5qdjDx0hYyf+Mtx/3Jt1hS9+XJsNogHv0haH/d52goXcMDnOzvNjjyQpKWv8I97YWGLiCc+MrRihVrxQ5bZQ1l9gwhZ5/Qu/4EQlCM10XgSzm1Ss3LeQALHck+4cjcZ3ekPfRjBuGYZQndpXdFl58jmHeM1+9GjLuiQHbvGSI+7WShSZ+LWPEtkc5vQHfrI12plQaWYeX0t6QmTHjE7w6ZDM0usqaQAXBOUNXUGHkBkQAjA2OEx4px71YqpHgpV23Cr5n4V8XUiae2g0goLAaYwEj7hpGbI9Q54VNw9Sg25bNtDzQpUqagxiugkh+K1tAgMW/sjb3uBHAMdC2KHwgar9xVu3kMPvS+Rv0dCE2Mfhtj0Um3oqEiRsuRhYc2hi/s4s7mBH1tyNqRBU0VqtTONtIZx6EL8D9bGPcS/u5GwUuYEo4NWuAsrBsGn24YPw50/jGMBvQdEKei0rGUiCt4W8VKtWXaGjtZKNLkdHJFRThIYbjfAxDe0TnAySl1EOSm0qYHKJsl08IQ0yGz8sDHnc6oS+SLl6n6sugJJQQ==
X-Forefront-Antispam-Report: CIP:149.199.62.198;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:xsj-pvapexch01.xlnx.xilinx.com;PTR:unknown-62-198.xilinx.com;CAT:NONE;SFS:(13230001)(4636009)(46966006)(36840700001)(40470700004)(4326008)(82310400005)(8676002)(15650500001)(2616005)(54906003)(70586007)(6666004)(83380400001)(2906002)(40460700003)(316002)(9786002)(508600001)(7636003)(36860700001)(8936002)(47076005)(336012)(36756003)(7696005)(426003)(1076003)(107886003)(356005)(70206006)(110136005)(44832011)(5660300002)(26005)(4744005)(186003)(102446001);DIR:OUT;SFP:1101;
X-OriginatorOrg: xilinx.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 May 2022 07:33:07.2846
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: afd473f2-9713-495d-8147-08da37d77c9b
X-MS-Exchange-CrossTenant-Id: 657af505-d5df-48d0-8300-c31994686c5c
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=657af505-d5df-48d0-8300-c31994686c5c;Ip=[149.199.62.198];Helo=[xsj-pvapexch01.xlnx.xilinx.com]
X-MS-Exchange-CrossTenant-AuthSource: BN1NAM02FT051.eop-nam02.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN7PR02MB4994
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Macb PTP updates to handle PTP one step sync support and other minor
enhancements.

Harini Katakam (3):
  net: macb: Fix PTP one step sync support
  net: macb: Enable PTP unicast
  net: macb: Optimize reading HW timestamp

 drivers/net/ethernet/cadence/macb.h      |  4 ++
 drivers/net/ethernet/cadence/macb_main.c | 61 +++++++++++++++++++-----
 drivers/net/ethernet/cadence/macb_ptp.c  | 12 +++--
 3 files changed, 63 insertions(+), 14 deletions(-)

-- 
2.17.1


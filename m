Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2302657E067
	for <lists+netdev@lfdr.de>; Fri, 22 Jul 2022 13:03:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235145AbiGVLDk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Jul 2022 07:03:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38748 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229811AbiGVLDj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 22 Jul 2022 07:03:39 -0400
Received: from NAM04-MW2-obe.outbound.protection.outlook.com (mail-mw2nam04on2078.outbound.protection.outlook.com [40.107.101.78])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C408CB555F;
        Fri, 22 Jul 2022 04:03:38 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=RG8DT186dseJXZ1jHGcExgK3CWqJmD2X7BCVEWnGZ6gEd7mFp0sa//MXwJp/w65swsOoDtIUsXcV61RV/BIahkyK3Jjf9YAhPh0pofptJFBHSpYLfSqIE7DYwrsXnyD/CblsC4UqzE8CNLVEqVyF/R9n5a1R5UcbVyDQycQihzm6uqPNojqRMVFnQoYwVO8Iz4keTG8YEayX6G78Zo7wEQ9BgM8ZM01PMw/ITldzFS5rC1CRjnu2X5G5H3PbQ3uRSzsSdYbUpyQbpC8V8pexZ1kDu3iNMFgOVBRMHm3EA2pUTLFyeM3bD2VKEkWOLF6WJ/xsGmDSWKjjpFlQaD4Z7w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=0n89HN1eWe5UP6GF1c1W+LnLBNodMdTh+EAPt6zXnNY=;
 b=SO4XHI5DUtr5WTq3x4mkt+25ojcbmmvPfnRB4Z7BHaQQAlkVb1FSUhM0DVqxikvmQiEWOaZZXkcYhev3jFjhdQFt8nwA2dViPao6YIpS8r1h0HMOmpzQh4SdY563pMfb0vASzKKUkYD9vjRRbP/0DsK1n+Y4pi2h7C8CEfiBvjfZGV243ubktGHJoxXf4PwPUl7UnXvUvmfJ1vqTdqUO1ocV3KqOcXxtht0IWEmzxWAeQF+mUrSU0qmhTS5xP5Jd+76+2xwgaHt4RL/Uy3OMrCpSIDqLNGDtfqKvbGdQDAFgYNnrXu3AwkzmJOoO3WUugMLoWRt0o0/bP4eNn+bCvA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 149.199.62.198) smtp.rcpttodomain=microchip.com smtp.mailfrom=xilinx.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=xilinx.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=xilinx.onmicrosoft.com; s=selector2-xilinx-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0n89HN1eWe5UP6GF1c1W+LnLBNodMdTh+EAPt6zXnNY=;
 b=J8hJYEJMTzLG9QEwEHta9xq4UyWLOGMXgdyc3FIWcxSOMdzqQYxXOhX4IAOYYxYF/J5X/m664+CUBDnrlWee0mUgar+d9G+AVvv6tYhpYNsAhiZr8sbQH137/ec7soLw3YrFqDCmzwakcfr+C5lHp54c308yrBxzFLB7RvArsqs=
Received: from SN7PR18CA0025.namprd18.prod.outlook.com (2603:10b6:806:f3::29)
 by DM6PR02MB5609.namprd02.prod.outlook.com (2603:10b6:5:35::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5458.19; Fri, 22 Jul
 2022 11:03:36 +0000
Received: from SN1NAM02FT0054.eop-nam02.prod.protection.outlook.com
 (2603:10b6:806:f3:cafe::37) by SN7PR18CA0025.outlook.office365.com
 (2603:10b6:806:f3::29) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5458.19 via Frontend
 Transport; Fri, 22 Jul 2022 11:03:36 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 149.199.62.198)
 smtp.mailfrom=xilinx.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=xilinx.com;
Received-SPF: Pass (protection.outlook.com: domain of xilinx.com designates
 149.199.62.198 as permitted sender) receiver=protection.outlook.com;
 client-ip=149.199.62.198; helo=xsj-pvapexch01.xlnx.xilinx.com; pr=C
Received: from xsj-pvapexch01.xlnx.xilinx.com (149.199.62.198) by
 SN1NAM02FT0054.mail.protection.outlook.com (10.97.4.242) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.5458.17 via Frontend Transport; Fri, 22 Jul 2022 11:03:36 +0000
Received: from xsj-pvapexch02.xlnx.xilinx.com (172.19.86.41) by
 xsj-pvapexch01.xlnx.xilinx.com (172.19.86.40) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.14; Fri, 22 Jul 2022 04:03:35 -0700
Received: from smtp.xilinx.com (172.19.127.96) by
 xsj-pvapexch02.xlnx.xilinx.com (172.19.86.41) with Microsoft SMTP Server id
 15.1.2176.14 via Frontend Transport; Fri, 22 Jul 2022 04:03:35 -0700
Envelope-to: nicolas.ferre@microchip.com,
 davem@davemloft.net,
 claudiu.beznea@microchip.com,
 kuba@kernel.org,
 edumazet@google.com,
 pabeni@redhat.com,
 robh+dt@kernel.org,
 krzysztof.kozlowski+dt@linaro.org,
 netdev@vger.kernel.org,
 linux-kernel@vger.kernel.org,
 harinikatakamlinux@gmail.com,
 harini.katakam@amd.com,
 devicetree@vger.kernel.org
Received: from [10.140.6.13] (port=33588 helo=xhdharinik40.xilinx.com)
        by smtp.xilinx.com with esmtp (Exim 4.90)
        (envelope-from <harini.katakam@xilinx.com>)
        id 1oEqRT-0001lP-0W; Fri, 22 Jul 2022 04:03:35 -0700
From:   Harini Katakam <harini.katakam@xilinx.com>
To:     <nicolas.ferre@microchip.com>, <davem@davemloft.net>,
        <claudiu.beznea@microchip.com>, <kuba@kernel.org>,
        <edumazet@google.com>, <pabeni@redhat.com>, <robh+dt@kernel.org>,
        <krzysztof.kozlowski+dt@linaro.org>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <michal.simek@xilinx.com>, <harinikatakamlinux@gmail.com>,
        <harini.katakam@xilinx.com>, <harini.katakam@amd.com>,
        <devicetree@vger.kernel.org>, <radhey.shyam.pandey@xilinx.com>
Subject: [PATCH v2 0/3] Add Versal compatible string to Macb driver
Date:   Fri, 22 Jul 2022 16:33:27 +0530
Message-ID: <20220722110330.13257-1-harini.katakam@xilinx.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 4dd85724-a609-4bde-0cdc-08da6bd1d368
X-MS-TrafficTypeDiagnostic: DM6PR02MB5609:EE_
X-Auto-Response-Suppress: DR, RN, NRN, OOF, AutoReply
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: jLmKLJfzOs6vck34vg1vGHIZjBHIPOuNBEBvqIXVQR8bPAWoCnzUINUnCiMhuOucmU54e3uJRQHZb1exl1KIPw+Ze1fMEWB5c3FTo4VW2zLPltRqo+GBDHODduI+Xxpzr8b0nbt1exvPVbpH60RVAgDr8lc+SyqWaVENxktWYAk1oxQCrUe2GwqJL+oU8RE0P9JZztBkV6N++NKmVrz1Q3IfBVlG4YUYZeeORDwPOzRzvZcW1n4FyLfoxL2jd2lcjX7TL3K5LCt2CtfoX/hkKYkmUkJW3tYoKlEoeh/kp7fxMF5zbjwmzSUQL14IrUnqjWWSIaa/J5ilu//O/duT2U01vrC5kZItRE/rUnFrwyut4N5b/kluLaDoLbOhGS9+6HPz8K+FJ+PyvjDh7Wnpkm8ZzcHZAmKCp0GwxnvCoL7jx7EL6KC5nnHFvs/qiek1D64k3vRR4WkyhUpZ02jS90e7D+M7QviRR+zGAhowjZs6YNggHG0s53dZ3UyhjXystGMUAtFB9Q7Aw/yE4uSLO0BYtnljWs5qxV9yZ1SpYQDpsdOf0nDwSJpH82Twm5uwDNNeA8tZKY/EOZGdatkCtG16uOD32rRkETxm/2X9PFt+NsKgLz32W/wdsmhZrmfhz7Q20CluFTlTSqbEXuOS97cZD4m8UEm1N2nGO2wYc1WrNOQYeN733u7VjmA4YgbbyrATMwzA8e0A3cCrTCOWhKDu/VAH5hScD6gCJUzJtIn51jF3G5GX8p01Oy9wLNXKKYusnwekxeq3SLcH7JG/v7nAiL5eXsID908x+Y9MiqLei/9N7acyKJS0kI+YuRiQR4QDx8qStmbV0xlrmqfMHw==
X-Forefront-Antispam-Report: CIP:149.199.62.198;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:xsj-pvapexch01.xlnx.xilinx.com;PTR:unknown-62-198.xilinx.com;CAT:NONE;SFS:(13230016)(4636009)(376002)(346002)(39860400002)(136003)(396003)(36840700001)(46966006)(40470700004)(40480700001)(36756003)(70206006)(8676002)(36860700001)(70586007)(110136005)(54906003)(4326008)(44832011)(5660300002)(4744005)(9786002)(7416002)(316002)(8936002)(40460700003)(478600001)(7636003)(2906002)(1076003)(82310400005)(41300700001)(6666004)(7696005)(356005)(107886003)(186003)(336012)(82740400003)(26005)(47076005)(83380400001)(2616005)(426003)(102446001);DIR:OUT;SFP:1101;
X-OriginatorOrg: xilinx.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Jul 2022 11:03:36.4557
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 4dd85724-a609-4bde-0cdc-08da6bd1d368
X-MS-Exchange-CrossTenant-Id: 657af505-d5df-48d0-8300-c31994686c5c
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=657af505-d5df-48d0-8300-c31994686c5c;Ip=[149.199.62.198];Helo=[xsj-pvapexch01.xlnx.xilinx.com]
X-MS-Exchange-CrossTenant-AuthSource: SN1NAM02FT0054.eop-nam02.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR02MB5609
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add Versal device support.

v2:
- Sort compatible strings alphabetically in DT bindings.
- Reorganize new config and CAPS order to be cleaner. 

Harini Katakam (2):
  net: macb: Sort CAPS flags by bit positions
  net: macb: Update tsu clk usage in runtime suspend/resume for Versal

Radhey Shyam Pandey (1):
  dt-bindings: net: cdns,macb: Add versal compatible string

 .../devicetree/bindings/net/cdns,macb.yaml      |  1 +
 drivers/net/ethernet/cadence/macb.h             |  5 +++--
 drivers/net/ethernet/cadence/macb_main.c        | 17 +++++++++++++++--
 3 files changed, 19 insertions(+), 4 deletions(-)

-- 
2.17.1


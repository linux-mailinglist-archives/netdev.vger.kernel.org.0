Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8A0DB585599
	for <lists+netdev@lfdr.de>; Fri, 29 Jul 2022 21:37:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238186AbiG2Tgv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 Jul 2022 15:36:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51124 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232823AbiG2Tgu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 29 Jul 2022 15:36:50 -0400
Received: from NAM04-DM6-obe.outbound.protection.outlook.com (mail-dm6nam04on2055.outbound.protection.outlook.com [40.107.102.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 048EE31DD4;
        Fri, 29 Jul 2022 12:36:49 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=iFxyiSgi3mim3GudfPoLjAPaYn/0UjKm6oxyQOLFCXbIuGPSKSvYeDGL/QBeKc7wTrquQs9ZFVwcOsIpDfdoPdIQPoQ1/mZf9BD4H0632O8JoJbfB/32xf8YJwFb92gDujZn6vrUF8uDzkW3XKIwHi6Ax71rw5zyvL3i2yqm24rH+s417NoHCcoHJFiefei9B0R31aJN4zEHEdj4yHvwSPK19l9YbSikFC0E8u+K9+J7eCt9e+tiyw0b/SsFLJr9Yxad7BeriJaeK1M4OFRliXxFgwAny5F3bAO06SiE6xfyM7Buri0C6+HxpSqBUdZVvL+Tiu9RZZ1pgE6Z76hYdw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=5fPu1LfLRvFBdFXPcfaT+Z3uOTnt5Q5hwhjTjhjquEw=;
 b=DWH4JRvrbFQ4mpcEJRB3CbIb7nR/LdpEHhIvZQfxOlLGqFG6+c7tDv1O+m6mpF4Ldc6DpwkMc2yov3Wqxx1P3vNVzxwwAim7C/jlzqyLgE5uG+PZC3giuGXPvBy5ahxcAvxZAQumycK5GLckXlFqmz+I1gSmv87FhxEKuOY4u3YLD7d1wiKgcbdK1/YLQF31ZX+dKGMi2rlUOZgGlYh5ZGt9KAqqnqUJKetcO3q82KVL1an5yWOu31auCoq7NnN9qubizM04OUkxbqsledVdHrd2YIluTmEqjxchBR271aU8JDuuLM9fhWt0qtbKFUkVWeeAWDFmBwmHu07i+1fuew==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 149.199.62.198) smtp.rcpttodomain=amd.com smtp.mailfrom=xilinx.com;
 dmarc=fail (p=quarantine sp=quarantine pct=100) action=quarantine
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=xilinx.onmicrosoft.com; s=selector2-xilinx-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5fPu1LfLRvFBdFXPcfaT+Z3uOTnt5Q5hwhjTjhjquEw=;
 b=PbKB0sSjbiMz1SZOK9eSwJZnH3ys2GRWtrwOsuMoV3VKwIRmS3P3GjsdXFUBmnrMTPlhMT+zFEKc3EKTccF88xgvyQqZ9+AVvREEpHmIDGlijFYd1xu4Q6DVJUsxaEwVQ+DQuvr4sJLETzBqMAtITVIwBoAlOPTTOhM1mN5Mo9c=
Received: from DM5PR08CA0041.namprd08.prod.outlook.com (2603:10b6:4:60::30) by
 DM5PR02MB2315.namprd02.prod.outlook.com (2603:10b6:3:4f::20) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5458.19; Fri, 29 Jul 2022 19:36:46 +0000
Received: from DM3NAM02FT038.eop-nam02.prod.protection.outlook.com
 (2603:10b6:4:60:cafe::9c) by DM5PR08CA0041.outlook.office365.com
 (2603:10b6:4:60::30) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5458.20 via Frontend
 Transport; Fri, 29 Jul 2022 19:36:46 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 149.199.62.198)
 smtp.mailfrom=xilinx.com; dkim=none (message not signed)
 header.d=none;dmarc=fail action=quarantine header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of xilinx.com designates
 149.199.62.198 as permitted sender) receiver=protection.outlook.com;
 client-ip=149.199.62.198; helo=xsj-pvapexch01.xlnx.xilinx.com; pr=C
Received: from xsj-pvapexch01.xlnx.xilinx.com (149.199.62.198) by
 DM3NAM02FT038.mail.protection.outlook.com (10.13.5.131) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.5482.10 via Frontend Transport; Fri, 29 Jul 2022 19:36:46 +0000
Received: from xsj-pvapexch02.xlnx.xilinx.com (172.19.86.41) by
 xsj-pvapexch01.xlnx.xilinx.com (172.19.86.40) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.14; Fri, 29 Jul 2022 12:36:45 -0700
Received: from smtp.xilinx.com (172.19.127.96) by
 xsj-pvapexch02.xlnx.xilinx.com (172.19.86.41) with Microsoft SMTP Server id
 15.1.2176.14 via Frontend Transport; Fri, 29 Jul 2022 12:36:45 -0700
Envelope-to: git@xilinx.com,
 git@amd.com,
 radhey.shyam.pandey@amd.com,
 davem@davemloft.net,
 edumazet@google.com,
 kuba@kernel.org,
 gregkh@linuxfoundation.org,
 linux-arm-kernel@lists.infradead.org,
 claudiu.beznea@microchip.com,
 nicolas.ferre@microchip.com,
 pabeni@redhat.com,
 linux-kernel@vger.kernel.org,
 netdev@vger.kernel.org
Received: from [172.23.64.3] (port=58451 helo=xhdvnc103.xilinx.com)
        by smtp.xilinx.com with esmtp (Exim 4.90)
        (envelope-from <radhey.shyam.pandey@xilinx.com>)
        id 1oHVmv-000Gvt-Bu; Fri, 29 Jul 2022 12:36:45 -0700
Received: by xhdvnc103.xilinx.com (Postfix, from userid 13245)
        id 3050F105461; Sat, 30 Jul 2022 01:06:43 +0530 (IST)
From:   Radhey Shyam Pandey <radhey.shyam.pandey@amd.com>
To:     <michal.simek@xilinx.com>, <nicolas.ferre@microchip.com>,
        <claudiu.beznea@microchip.com>, <davem@davemloft.net>,
        <edumazet@google.com>, <kuba@kernel.org>, <pabeni@redhat.com>,
        <gregkh@linuxfoundation.org>
CC:     <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>,
        <git@amd.com>, <git@xilinx.com>,
        "Radhey Shyam Pandey" <radhey.shyam.pandey@amd.com>
Subject: [PATCH v2 net-next 0/2] macb: add zynqmp SGMII dynamic configuration support
Date:   Sat, 30 Jul 2022 01:05:48 +0530
Message-ID: <1659123350-10638-1-git-send-email-radhey.shyam.pandey@amd.com>
X-Mailer: git-send-email 2.1.1
MIME-Version: 1.0
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 1f953b9d-673b-4efc-d18b-08da7199acc6
X-MS-TrafficTypeDiagnostic: DM5PR02MB2315:EE_
X-MS-Exchange-SenderADCheck: 0
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: DzmkALyFWo49crWOKNY+SGc5F8b1VeKUIZ8HOVsIuXCq4+FJ2pPz+SX/oRBcSvePJVWLDYUuyKtXXcZClsPOriqj780BRSaBAXpXfUi030ipKtm1Afn8+U2WUzjpBoqDwNmrc3ai3EY4M/0oEbV976os+XKP+PZbSCRD2fzN95pBC49OyKT2kNaw9pGIXqBa9D2Jw3HfC+qhg0SXJE9N/JXlB2+sd3ePA28X84GNX/3xr2doXPPoQmclYTVm2dmmTnntWO/xsTcwlYgMxXWTzYZrRKYaNH344KiknFnkXMKG699yIGhe/s0vFWfIbaFSaYuGblk3pJGOQ+fKFw3k/nmN2fZjDhyZnG5wL1ggwnzuqLfUce2OcE3oM7+0tVryiHtL5m1Z5E5FWeVUNEl8haTrYs89x7F0rJ06T2zFLU7s+sNjZzROPzo94vAiWGlJlf57X9yMdPaBV5XoaS/tZizp4z39LFiCs7OMvlgbqvemWQ7eodUuH0aRAEknhoI3IXtneYWMXtEutaACAb7WuziDAUno8Ab6AW3e2sfZkbw0UjaRvNNsskRModawQ8XjVlh8A10Aj2Yjzu8I4rBtgghDB8UzSA7D1FhFniZjC761w3RPZMeoShZJB92noMZ4V8gn2rz6rv4etzKz5uLVC9Iy8oNIiYf3KoQDjG+owDxU8QQsnL3AXWbNSDtS7IOq2kOLjqrg0DIGmejlHRP8mLU1fb6BJkk3dg2XRUMPujLANdABStLvAG9kJmT4SCP9IXuTSzb0VAikfyS/bOuR6e4XfAeU95NuNDi9FBppjdIC0YxX4oxxSO4rslxcY/xJ/aHmGAcVgq5gVBmOZZcroA==
X-Forefront-Antispam-Report: CIP:149.199.62.198;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:xsj-pvapexch01.xlnx.xilinx.com;PTR:unknown-62-198.xilinx.com;CAT:NONE;SFS:(13230016)(4636009)(136003)(346002)(376002)(39860400002)(396003)(40470700004)(36840700001)(46966006)(70206006)(47076005)(8676002)(7416002)(5660300002)(70586007)(336012)(26005)(41300700001)(40460700003)(82740400003)(40480700001)(6266002)(8936002)(82310400005)(356005)(478600001)(186003)(4744005)(2906002)(4326008)(7636003)(54906003)(110136005)(36860700001)(83170400001)(2616005)(42186006)(36756003)(316002)(42882007)(102446001);DIR:OUT;SFP:1101;
X-OriginatorOrg: xilinx.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Jul 2022 19:36:46.8054
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 1f953b9d-673b-4efc-d18b-08da7199acc6
X-MS-Exchange-CrossTenant-Id: 657af505-d5df-48d0-8300-c31994686c5c
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=657af505-d5df-48d0-8300-c31994686c5c;Ip=[149.199.62.198];Helo=[xsj-pvapexch01.xlnx.xilinx.com]
X-MS-Exchange-CrossTenant-AuthSource: DM3NAM02FT038.eop-nam02.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR02MB2315
X-Spam-Status: No, score=1.3 required=5.0 tests=AC_FROM_MANY_DOTS,BAYES_00,
        DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Level: *
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patchset add firmware and driver support to do SD/GEM dynamic
configuration. In traditional flow GEM secure space configuration
is done by FSBL. However in specific usescases like dynamic designs
where GEM is not enabled in base vivado design, FSBL skips GEM
initialization and we need a mechanism to configure GEM secure space
in linux space at runtime. 


Changes for v2:
- Add phy_exit() in error return paths.
- Use tab indent for zynqmp_pm_set_sd/gem_config return documentation.

Radhey Shyam Pandey (1):
  net: macb: Add zynqmp SGMII dynamic configuration support

Ronak Jain (1):
  firmware: xilinx: add support for sd/gem config

 drivers/firmware/xilinx/zynqmp.c         | 31 ++++++++++++++++++++++++++++++
 drivers/net/ethernet/cadence/macb_main.c | 25 ++++++++++++++++++++++++
 include/linux/firmware/xlnx-zynqmp.h     | 33 ++++++++++++++++++++++++++++++++
 3 files changed, 89 insertions(+)

-- 
2.1.1


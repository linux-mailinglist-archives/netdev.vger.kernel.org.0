Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0FDBC5E84DC
	for <lists+netdev@lfdr.de>; Fri, 23 Sep 2022 23:29:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231958AbiIWV3r (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 23 Sep 2022 17:29:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53032 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229808AbiIWV3q (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 23 Sep 2022 17:29:46 -0400
Received: from NAM02-DM3-obe.outbound.protection.outlook.com (mail-dm3nam02on2067.outbound.protection.outlook.com [40.107.95.67])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 926A72A957
        for <netdev@vger.kernel.org>; Fri, 23 Sep 2022 14:29:43 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=i8j632pxg9fl9bi5Pm/PCqqByDh4VOKOt/+lw1LUjx6WWJJZSBjf6oEGbSmkCi1f5aKAhFFWSSBJe8vj0SpANnv+szgS1QexfdkM5hjl9pe9rONX7Kg2xvbE6d+aC2o8rf71eJ6Dl1LY/Xyd3xbyq5OBWVpOKmHH6c0qPckW45h8WaaxhB5KNF1Rhd1ZHOalUt7zEVIcw/4U/ZGOoOqAhm7ru4u4TrHQMmMEWRNCxDSh3KpayU3I0xBzrS4bLJ+u7czZJDbwQFgBC/g/BxiQKU7uS8nkcFUmzJoax5hTUsF12hB5PqHeL/TxYXPdBqjXjF61Zx0R/JMGkVMsqCgiKw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=UQcOGjOtcdgCpkv+DlM8QdCwhZcFWowY9pNiQoffFwU=;
 b=F6/wa0OrH222lVoMVjkp+/hBhloZnVlD1r66gxvvUrC58QcYA4IvKQyjQe1fKIDz4jucB+BzZgBjI/r8k/x0izzeSo8coMvcm3fXumZPTfQFU9lYxnxU0zdb14lMJNabCGRAFQQVQCvQD/4l3kSrZyw8DXuel0L/PrX4wwx0FytXBYEAx3aRYgLxoFV/0Pd+Koss/25SKC78/AUwDUvR8SaGgZly3bRC/YVklBkc+mJ2XA5ieNf/I2RjAvpt+d0oozdVUBV5d1HcH7ku98KlIKaK1lcaVD4jxt/UUjE4wJ8csiW99g8Q99kJAQdIBfLbVcgH2WPGSqmoszomYRq72Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=fail (p=none sp=none pct=100) action=none header.from=xilinx.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector1-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=UQcOGjOtcdgCpkv+DlM8QdCwhZcFWowY9pNiQoffFwU=;
 b=Jpm/lDtQ9RmJHW8wIkYSmQnnOyiM8QD0xin181WiYjrm0BEiFpwUR9gCT0bqOSEPNUpkys/LOlfQfzHVFcdMGAREuB7MsgjOWJUkN9BznxbQRQ/nQRNCjPRRxC6miO5Vuo8l6sDuBl5m4QMLPGjd5aTxgennL09RBoBgy7SZqfXhxxnzBfMexATzNIov9UbV5Gq6SjC4StcV0HfWeLxN77VlnesLwneILhliLns+sMAFM4RiOvG4MAdnQ9W+O69JUuh9OVm08MVpOsQDFKqPZq6FDrTQaOvn1OcKhbaLgyQUZEVZe43nV0wNfc01RVvZnVSwdvuv7C4iV8qTIhXBhQ==
Received: from BN1PR12CA0002.namprd12.prod.outlook.com (2603:10b6:408:e1::7)
 by MN2PR12MB4568.namprd12.prod.outlook.com (2603:10b6:208:260::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5654.17; Fri, 23 Sep
 2022 21:29:41 +0000
Received: from BN8NAM11FT051.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:e1:cafe::92) by BN1PR12CA0002.outlook.office365.com
 (2603:10b6:408:e1::7) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5654.20 via Frontend
 Transport; Fri, 23 Sep 2022 21:29:41 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=fail action=none header.from=xilinx.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB03.amd.com; pr=C
Received: from SATLEXMB03.amd.com (165.204.84.17) by
 BN8NAM11FT051.mail.protection.outlook.com (10.13.177.66) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.5654.14 via Frontend Transport; Fri, 23 Sep 2022 21:29:41 +0000
Received: from SATLEXMB06.amd.com (10.181.40.147) by SATLEXMB03.amd.com
 (10.181.40.144) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.28; Fri, 23 Sep
 2022 16:29:41 -0500
Received: from SATLEXMB03.amd.com (10.181.40.144) by SATLEXMB06.amd.com
 (10.181.40.147) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.28; Fri, 23 Sep
 2022 16:29:40 -0500
Received: from xcbecree41x.xilinx.com (10.180.168.240) by SATLEXMB03.amd.com
 (10.181.40.144) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.28 via Frontend
 Transport; Fri, 23 Sep 2022 16:29:39 -0500
From:   <ecree@xilinx.com>
To:     <netdev@vger.kernel.org>, <linux-net-drivers@amd.com>
CC:     <davem@davemloft.net>, <kuba@kernel.org>, <pabeni@redhat.com>,
        <edumazet@google.com>, <habetsm.xilinx@gmail.com>,
        Edward Cree <ecree.xilinx@gmail.com>
Subject: [PATCH net-next 0/6] sfc: bare bones TC offload
Date:   Fri, 23 Sep 2022 22:05:32 +0100
Message-ID: <cover.1663962652.git.ecree.xilinx@gmail.com>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN8NAM11FT051:EE_|MN2PR12MB4568:EE_
X-MS-Office365-Filtering-Correlation-Id: 9cb2c03f-09a3-4e74-bbdf-08da9daab9e6
X-MS-Exchange-SenderADCheck: 0
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: HDgMWMBECFA7RkiCH+mzqyuNu0bDQQmGpiuFPyLGcYcxgqEZ97+qxb4Ksgsp2BYRJmhcHaEJ8SgfSi9QGEhnMV+ulNm/wPjCb1ZclHRnlq3+dtwj/WkKYqSyXld+VQDxSGxuaUMKtNeRNez7XubJyx3HK4fmlv5Pm12Q/Cbp8YUcYHYk7bOzOxheUnUiDkRiLL1Mz2QoQwgX/67it312bttd66NKYqL8s+jLr18Dt55V2xsy4JI9M5oPvNz8L4AY+wAoljvH++8rzS+QdGLZHyGSjvlntqxhRH9mKaONhMJkucqvg9vTlYprYbKN367pHGaO+95fFuF48qI0PVs7Ed0Nxzu4ktaytq4KAnnJhlL63GLmLidwPT+RzHA61V5t+7bb7nURhVFlXfuo5L8FLmD8vkp5wLfHJWt5Bt2l755N8UDyRqiI9h3gqpcBKmb3z/K29MzGtYiWBtf9HxEgsWvK6Rhqtbk+Xl3xymtzEoUmhGIXNbUpu3RZFfxYhoY3evzTrcxNAAt5EmsqrhEKZgQDJPo23xHAILzB0k1FPqj9pFHyKtpQqB2g0AQVdp8bjlKl4B9S2Xfbh7Lc0C3dK40o5Vu/ribs5+aIpv0pt/mlqSsMQnLztj7VlNZQeE3QSvhXziGns9djQIj7McF+4S9jwo+imhaa2NDbbBDJXc+Y5M6z/uIcJ25zH7oagTLQ3T6VeOU6GZK6gpQWkJD/Mwxdw9n/ZEAF3LBGs/o8phIIxVpFGY8eW1sCKKa8zZB7B/hNzAYwoERVgOvELJ3A6kI/gruDcygDUS/ewWfmbCY=
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB03.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230022)(4636009)(376002)(346002)(136003)(396003)(39860400002)(451199015)(40470700004)(36840700001)(46966006)(82740400003)(478600001)(4326008)(36756003)(42882007)(336012)(70586007)(82310400005)(316002)(356005)(54906003)(70206006)(55446002)(41300700001)(8676002)(81166007)(83170400001)(110136005)(40480700001)(6666004)(36860700001)(26005)(9686003)(40460700003)(5660300002)(83380400001)(2876002)(8936002)(2906002)(186003)(47076005)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Sep 2022 21:29:41.4629
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 9cb2c03f-09a3-4e74-bbdf-08da9daab9e6
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB03.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT051.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB4568
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Edward Cree <ecree.xilinx@gmail.com>

This series begins the work of supporting TC flower offload on EF100 NICs.
This is the absolute minimum viable TC implementation to get traffic to
 VFs and allow them to be tested; it supports no match fields besides
 ingress port, no actions besides mirred and drop, and no stats.
More matches, actions, and counters will be added in subsequent patches.

Edward Cree (6):
  sfc: bind blocks for TC offload on EF100
  sfc: bind indirect blocks for TC offload on EF100
  sfc: optional logging of TC offload errors
  sfc: add a hashtable for offloaded TC rules
  sfc: interrogate MAE capabilities at probe time
  sfc: bare bones TC offload on EF100

 drivers/net/ethernet/sfc/Makefile         |   2 +-
 drivers/net/ethernet/sfc/ef100_ethtool.c  |   2 +
 drivers/net/ethernet/sfc/ef100_netdev.c   |   4 +
 drivers/net/ethernet/sfc/ef100_nic.c      |   3 +
 drivers/net/ethernet/sfc/ef100_rep.c      |  18 +-
 drivers/net/ethernet/sfc/ef100_rep.h      |   1 +
 drivers/net/ethernet/sfc/ethtool_common.c |  37 ++
 drivers/net/ethernet/sfc/ethtool_common.h |   2 +
 drivers/net/ethernet/sfc/mae.c            | 165 +++++++++
 drivers/net/ethernet/sfc/mae.h            |  14 +
 drivers/net/ethernet/sfc/mcdi.h           |  10 +
 drivers/net/ethernet/sfc/net_driver.h     |   2 +
 drivers/net/ethernet/sfc/tc.c             | 430 +++++++++++++++++++++-
 drivers/net/ethernet/sfc/tc.h             |  36 ++
 drivers/net/ethernet/sfc/tc_bindings.c    | 228 ++++++++++++
 drivers/net/ethernet/sfc/tc_bindings.h    |  29 ++
 16 files changed, 980 insertions(+), 3 deletions(-)
 create mode 100644 drivers/net/ethernet/sfc/tc_bindings.c
 create mode 100644 drivers/net/ethernet/sfc/tc_bindings.h


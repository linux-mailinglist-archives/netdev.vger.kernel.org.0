Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E1556628104
	for <lists+netdev@lfdr.de>; Mon, 14 Nov 2022 14:16:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237214AbiKNNQY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Nov 2022 08:16:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42678 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237315AbiKNNQX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Nov 2022 08:16:23 -0500
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2044.outbound.protection.outlook.com [40.107.93.44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CA45ABF7C
        for <netdev@vger.kernel.org>; Mon, 14 Nov 2022 05:16:17 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lL/Wz8ykfUUaNmZ2y9wvjYl4iLfa8bJDQCRMZxYs6egHPeFl3Kl4Bjp8le2RazsFSxxzh8F9MuLxl/yCF3iHcB87lscKwqsElhz3q9i5ctxLvIh0QhqDxUpGQUQuvqUvw1qlWcgk9AG4QDFafZ4xwCZwpft8MASAk3fgjRfj1GuDzQDa+POh6hn4oFIc6kbGvuac5CjMFHKTWwDvrUnwseUIC2cl1S/F+QwnEMJ3moHIjXvdyF8pbKMOh+weVXtSPaYgbKW76U+eHcAxaJ3ydxGimg4l4U+qFhfVJLCb79IUX3zbQoaaVIsHgolLohbCFmfyUn8N8bCG1PvGUgGjeQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=2WNwf0dWG80FOYWdI3RoG0MMGTl7zvTynwW1izTFE54=;
 b=J3wDy+iNi3VysfFz0u2W1Wmt/25ESH69w6GwVaIFasy8RTOQbq5sNv0I7FrxGTWofj/mHtwZbtCynxep6hVabYRgey4UED7hzvn4kp1LiFG6yqLfObVkZgljlZ/s+GGGir1ScIGHr9+/Hqq9jNk76EBb6pkPZ7Z8C2X9KqikJqFfWoely7K4dCgKpiMaR6GaeZ2Sn0itzaFf8gVcSlQlBg2DaEu2wIRM0FSFO0r3ozX1QYgcAN+abT393/jFB7LsqhpD4hmJ75ZOHjFTez799eHiOTj9G0XVYusfnXl6Va9JTnePK8fpYHnPdCPqj7BGlF/ZJ2f0MSx632iNoz4wGg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2WNwf0dWG80FOYWdI3RoG0MMGTl7zvTynwW1izTFE54=;
 b=gz/GYbL9EdUqEkhXGwoqsjk8AujlsWWK1o7BiTBFIPXk9/u9iaa8bChdMiNp5g2ZApqCEsWrem1wrQjxw84tXrjUwO/AHX2EMGOA/+hLS1ENNnuR5Oc2Q2gLh8ZT3nAfLf9O7TEl5nSNdSc9l54xmal03dTkr1uWtfG8huOpkd0=
Received: from DM6PR08CA0060.namprd08.prod.outlook.com (2603:10b6:5:1e0::34)
 by CY8PR12MB7219.namprd12.prod.outlook.com (2603:10b6:930:59::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5813.17; Mon, 14 Nov
 2022 13:16:15 +0000
Received: from DM6NAM11FT026.eop-nam11.prod.protection.outlook.com
 (2603:10b6:5:1e0:cafe::eb) by DM6PR08CA0060.outlook.office365.com
 (2603:10b6:5:1e0::34) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5813.16 via Frontend
 Transport; Mon, 14 Nov 2022 13:16:15 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 DM6NAM11FT026.mail.protection.outlook.com (10.13.172.161) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.5813.12 via Frontend Transport; Mon, 14 Nov 2022 13:16:15 +0000
Received: from SATLEXMB07.amd.com (10.181.41.45) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Mon, 14 Nov
 2022 07:16:14 -0600
Received: from SATLEXMB04.amd.com (10.181.40.145) by SATLEXMB07.amd.com
 (10.181.41.45) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Mon, 14 Nov
 2022 05:16:14 -0800
Received: from xcbecree41x.xilinx.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34 via Frontend
 Transport; Mon, 14 Nov 2022 07:16:13 -0600
From:   <edward.cree@amd.com>
To:     <netdev@vger.kernel.org>, <linux-net-drivers@amd.com>
CC:     <davem@davemloft.net>, <kuba@kernel.org>, <pabeni@redhat.com>,
        <edumazet@google.com>, <habetsm.xilinx@gmail.com>,
        Edward Cree <ecree.xilinx@gmail.com>
Subject: [PATCH v2 net-next 00/12] sfc: TC offload counters
Date:   Mon, 14 Nov 2022 13:15:49 +0000
Message-ID: <cover.1668430870.git.ecree.xilinx@gmail.com>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6NAM11FT026:EE_|CY8PR12MB7219:EE_
X-MS-Office365-Filtering-Correlation-Id: 55117811-fe6f-4797-861b-08dac642689e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: j/3APxYFKRllH7xmX7MQm3ROkr8GsDZ7H2r1K6wOj9WyzhOKZIZChAfWOVThfDvPsI0abO+utNv7rpt1dwKwIGpLyn3UCcvOI5A2oLVulCkX0r4g3SxsH405fRUoY5ujlGnvXcfIphSl+vjQ0eC1tSHpGF8ZAW1PPexH0YZJRLpSp0P/53hrQgJ6HBhd/95kLY4xu9zLEo9XPhfvz6xELRqZ/Z4sZa4ipPTgNcCkl6aW8Looge/duN9gu6r6Blk9HeTipuKqNJGlZH1DHO1Oq8aVyorEfdNZtqLKElbBhyUNj8+RBUpGIXNP4FPlkHQhKoWm3XdStyseLvLMLH0k+ygz5GWPIYpVA37D81uztetYs5OZ1u12ddyvSnq+L3i7iy8u73PO9VQvc3rZMzPohtousxc+yIdrgoO0nasWVyzkDilmLhtwhh1Duz9bz0bBJNDFSkNx6pZ6jxFvGqNdDWUdxWJ+lf14qhJOkUJUYO8a+X2jPgrQRoW+edjR6lVXVSucT5PnF7kb8EjdRekHTya3VSHka4wIxhcqljEMndIJ2LF+V41YgQSdtLseGaKRv0f+2XgA4tdrBrtxltw8CwZcsqJ1vQgLqNhXiF/2f6d8q41JjJPtyHEiN4qwBpRDJHVNfBpzNCZjL/Bj/xOa3JaxRUW3m4iJDdt4kmzrPAMbc4kowYKIy1Kxu87yqvZcWp7C60jVyuqHPTcn0JsDKH6BtmwqTV6nmRQ1OCaCKkPaNQJI6pdQySmZY6XNsBkMqk53e5e8EmCvqZ3mTAHR95PsKpT/cqLFlyGD7znD/Bo=
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230022)(4636009)(396003)(346002)(39860400002)(136003)(376002)(451199015)(40470700004)(36840700001)(46966006)(81166007)(83380400001)(47076005)(336012)(426003)(186003)(2876002)(82740400003)(2906002)(356005)(36860700001)(8936002)(40460700003)(40480700001)(82310400005)(478600001)(26005)(6666004)(9686003)(5660300002)(8676002)(70586007)(70206006)(4326008)(41300700001)(6636002)(54906003)(110136005)(316002)(36756003)(55446002)(86362001)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Nov 2022 13:16:15.0925
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 55117811-fe6f-4797-861b-08dac642689e
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT026.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR12MB7219
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Edward Cree <ecree.xilinx@gmail.com>

EF100 hardware supports attaching counters to action-sets in the MAE.
Use these counters to implement stats for TC flower offload.

The counters are delivered to the host over a special hardware RX queue
 which should only ever receive counter update messages, not 'real'
 network packets.

Changed in v2:
* added new patch #1 to fix shift UB on 32 bit (kernel test robot)

Edward Cree (12):
  sfc: fix ef100 RX prefix macro
  sfc: add ability for an RXQ to grant credits on refill
  sfc: add start and stop methods to channels
  sfc: add ability for extra channels to receive raw RX buffers
  sfc: add ef100 MAE counter support functions
  sfc: add extra RX channel to receive MAE counter updates on ef100
  sfc: add hashtables for MAE counters and counter ID mappings
  sfc: add functions to allocate/free MAE counters
  sfc: accumulate MAE counter values from update packets
  sfc: attach an MAE counter to TC actions that need it
  sfc: validate MAE action order
  sfc: implement counters readout to TC stats

 drivers/net/ethernet/sfc/Makefile             |   2 +-
 drivers/net/ethernet/sfc/ef100_rx.c           |  23 +-
 drivers/net/ethernet/sfc/efx_channels.c       |   9 +-
 drivers/net/ethernet/sfc/mae.c                | 170 +++++-
 drivers/net/ethernet/sfc/mae.h                |   7 +
 drivers/net/ethernet/sfc/mae_counter_format.h |  73 +++
 drivers/net/ethernet/sfc/mcdi.h               |   5 +
 drivers/net/ethernet/sfc/net_driver.h         |  17 +-
 drivers/net/ethernet/sfc/rx_common.c          |   3 +
 drivers/net/ethernet/sfc/tc.c                 | 122 +++++
 drivers/net/ethernet/sfc/tc.h                 |  16 +
 drivers/net/ethernet/sfc/tc_counters.c        | 501 ++++++++++++++++++
 drivers/net/ethernet/sfc/tc_counters.h        |  59 +++
 13 files changed, 998 insertions(+), 9 deletions(-)
 create mode 100644 drivers/net/ethernet/sfc/mae_counter_format.h
 create mode 100644 drivers/net/ethernet/sfc/tc_counters.c
 create mode 100644 drivers/net/ethernet/sfc/tc_counters.h


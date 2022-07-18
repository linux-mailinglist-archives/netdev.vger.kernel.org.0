Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 25B59578298
	for <lists+netdev@lfdr.de>; Mon, 18 Jul 2022 14:43:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235082AbiGRMnd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Jul 2022 08:43:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34426 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235093AbiGRMnc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 Jul 2022 08:43:32 -0400
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2082.outbound.protection.outlook.com [40.107.243.82])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AD323240BD;
        Mon, 18 Jul 2022 05:43:31 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Hq+FGHlFbNzAGXAP1dVLhe7O6/cJolKd3iBKfh9Azq6GxTGwGQY9jX+jSZfh/qwSSYoDDpLQYCebU0fdL9PyN0sNxCyPufoUMfnUxDrOfOiI2mssAx80lv8PUWwm1FOU1FUSOt47zkT1lsdYajrtF/+10LFBsXv3M0E53LfPq+CexiIoAt4p5lmvTPMdazrbatGywgOM2EVgn/evVSBhQyOB84dZ2KGrxK8VTTq7utJJySYmVSS84W2LFjX92rNqo8m6yIg3pUh5DOLgduzPJvGssiTB2yROEtC7Eltx9dhFqWGBq7V9wWiv9zdfPZYwegkJVnOrJwLEvYfGu2kZSw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Wn4YWyogS2SQOyBi5bi4hTWTPzWcamUBZS34LBN8BA4=;
 b=NUEp6EkNzvRN1UzsX0GvCjWlroZXAWgwQvK6gM/jf4uUxrsqt2tAEM8HO1Ebl5oNttDyj5Iih2hEJxJLjCkJoaVpa10aejUHw59IFu1DrSeRnBOiqaCarv/xxqGaaGClGtnNVjcdxlagudlhjpOba217XCzNjwPRoL96HHIDXfkHX1M8trGLNUFZR4qulDmhvw8nCMd8FceO2nnscbMaiFWWyX7EcBexjPAtK6ym0bw4RT7GjbnlrXq4hq9nnJLWD3wDt1pGlU6x2rWPuJZdTZYdNZxS/viGb5I8HScG0BldmqF0xfd/BDgYeyb8Yv0Flh9oJWzddYM2ZIQXAMpUeg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.235) smtp.rcpttodomain=redhat.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Wn4YWyogS2SQOyBi5bi4hTWTPzWcamUBZS34LBN8BA4=;
 b=oZZgXt154FoLujv+CLnvarmHqJiLIWd02J6o1B1z5syiLR6KsLR/DwHFwP3RVkHjgr3y5GtQb5Sf75qPULs2xETxIkEQ5J3NvbVTLr/FyKZmU3S/vWPH2Ik5yu9ODGo7yWs8iRGSxhPX7CGZGy1K0yPrhkicbWHKat/WblforBLmFD6JJ2wqpeFTklRnPPn3LX5R7e7fUKM3GvMzu6wU806BkvRVlvGlTbgSZDQMKRUu3ycDEp+dv+CLHRF51us7ykQD7A5sICNlGqL48VfN2tTA0WxK3UF1b87t2JW06XaJZuc2PQQI+YSN/r1NtrnwntGHM89If/W2rihH7WH48Q==
Received: from BN6PR17CA0023.namprd17.prod.outlook.com (2603:10b6:404:65::33)
 by BL0PR12MB5508.namprd12.prod.outlook.com (2603:10b6:208:1c1::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5438.14; Mon, 18 Jul
 2022 12:43:30 +0000
Received: from BN8NAM11FT065.eop-nam11.prod.protection.outlook.com
 (2603:10b6:404:65:cafe::7f) by BN6PR17CA0023.outlook.office365.com
 (2603:10b6:404:65::33) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5438.19 via Frontend
 Transport; Mon, 18 Jul 2022 12:43:30 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.235)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.235 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.235; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (12.22.5.235) by
 BN8NAM11FT065.mail.protection.outlook.com (10.13.177.63) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.5438.12 via Frontend Transport; Mon, 18 Jul 2022 12:43:30 +0000
Received: from drhqmail201.nvidia.com (10.126.190.180) by
 DRHQMAIL107.nvidia.com (10.27.9.16) with Microsoft SMTP Server (TLS) id
 15.0.1497.32; Mon, 18 Jul 2022 12:43:29 +0000
Received: from drhqmail202.nvidia.com (10.126.190.181) by
 drhqmail201.nvidia.com (10.126.190.180) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.986.26; Mon, 18 Jul 2022 05:43:28 -0700
Received: from vdi.nvidia.com (10.127.8.14) by mail.nvidia.com
 (10.126.190.181) with Microsoft SMTP Server id 15.2.986.26 via Frontend
 Transport; Mon, 18 Jul 2022 05:43:24 -0700
From:   Tariq Toukan <tariqt@nvidia.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Ingo Molnar <mingo@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Juri Lelli <juri.lelli@redhat.com>
CC:     Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>, <netdev@vger.kernel.org>,
        Gal Pressman <gal@nvidia.com>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        <linux-kernel@vger.kernel.org>, Tariq Toukan <tariqt@nvidia.com>
Subject: [PATCH net-next V2 0/2] mlx5: Use NUMA distance metrics
Date:   Mon, 18 Jul 2022 15:43:13 +0300
Message-ID: <20220718124315.16648-1-tariqt@nvidia.com>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 8ed7ef2a-fb97-410e-0d10-08da68bb1e3e
X-MS-TrafficTypeDiagnostic: BL0PR12MB5508:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 22YCo6qFZM/Isz+HUx1dS7wGczm1AXfuNRg43qivttrTbFWvWb4gK7lPs4NTZmWlgfcVGNG6fKqyX+BTm+g5J/BtB+L0TYcPkZCWyEJbI1RgddDPYXpDAZslaKKBvIVCjqc9nNhfnqEGJQ35goANSmcEEgFspK+Av8zIAgD45AS0hmTxRbzHTsNNu9gHheAi6e6I784/LezK2gUq2pTGVweyVXodZnvPqsA4uHTgSAkdO3o8anCZ3CMpcN3RT7cHIjwOIS0dKXOcmt8dq+T5QUVDdTRkI3yA+LlK84rkygApS8a8QzO2N4O9oR2c/hNHaBTh19TQMpH3Od1jdHMLz2G9t/8LlaT/5eMUNWqYok4XCq2Hp9eFLihh+GkXPU2SRasgvy2rAsLdXRnrgY69lOXEFCWLTloxb5HPAhG4MGXb/zaIy6ti+aUGP37YDhycYN87VHlnZlCoizlOoqH7OUGsLRGh2jRnRgeFqdy7P1uyWudheCoOmKq9W95ROml4wmb/Bgh+o/JyLkYpOu0SYs98+mP3Ea5A/jh/MivmZrt/0Oz13jjh3pM7ukZhWzySsVdY/xgVQyi2Av+LPlpLkRX9WRP6pHG4iIkGS+dTms+2fiGagD7a3881qr277RSp/ahZYkYS/3TDjdUNUk1noamdo49z9c630klyfamBRPODC1L2p0GvDWUz58lvl1OvLBOdMfcwY2ifUlGdI0N4QfSlAnrC/W9UXapVK2qD9CAsQhe1UXgrFXjtRudNJj23T7eT6O/hs5VgmRpIKKgSLGyAzXVLD+6/qzlMPjFMViAcZQqH+Jzmdph0k2IESkrZuRcBufTSKYaXXH7Dr4OAz02dEo+JuX/7Y8tZSUJR8wU=
X-Forefront-Antispam-Report: CIP:12.22.5.235;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230016)(4636009)(376002)(396003)(346002)(136003)(39860400002)(46966006)(40470700004)(36840700001)(426003)(83380400001)(107886003)(1076003)(336012)(2616005)(186003)(478600001)(7696005)(41300700001)(47076005)(36860700001)(356005)(6666004)(82740400003)(26005)(8936002)(82310400005)(4744005)(7416002)(2906002)(5660300002)(36756003)(40480700001)(81166007)(8676002)(40460700003)(316002)(86362001)(110136005)(54906003)(70586007)(4326008)(70206006)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Jul 2022 12:43:30.0027
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 8ed7ef2a-fb97-410e-0d10-08da68bb1e3e
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.235];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT065.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL0PR12MB5508
X-Spam-Status: No, score=-1.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

Expose the scheduler's sched_numa_find_closest() function, and use it in
mlx5 device driver.  This replaces the binary NUMA preference (local /
remote) with an improved one that minds the actual distances, so that
remote NUMAs with short distance are preferred over farther ones.

This has significant performance implications when using NUMA-aware
memory allocations, improving the throughput and CPU utilization.

Regards,
Tariq

Tariq Toukan (2):
  sched/topology: Expose sched_numa_find_closest
  net/mlx5e: Improve remote NUMA preferences used for the IRQ affinity
    hints

 drivers/net/ethernet/mellanox/mlx5/core/eq.c | 62 +++++++++++++++++++-
 include/linux/sched/topology.h               |  2 +
 kernel/sched/topology.c                      |  1 +
 3 files changed, 62 insertions(+), 3 deletions(-)

-- 
2.21.0


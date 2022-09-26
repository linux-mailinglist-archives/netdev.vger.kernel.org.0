Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3748A5EB09F
	for <lists+netdev@lfdr.de>; Mon, 26 Sep 2022 20:59:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231295AbiIZS7K (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Sep 2022 14:59:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42012 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230137AbiIZS7F (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 26 Sep 2022 14:59:05 -0400
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2054.outbound.protection.outlook.com [40.107.244.54])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EF00C8E9BC
        for <netdev@vger.kernel.org>; Mon, 26 Sep 2022 11:59:03 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nEZ9kFxAKnD+zim7KaWbg6mYEB3FcOp+HmP2o0ot/zGKjPqrZRUJyzle8xacRka5op5xefHE+teJ9nlNVTUyAJmpq4JBf2uhPqV734gyMZ4WzJ1X39OU+Tn9jakXvY0jkyQ7rPo6aB118s+K0hWo+z2O+Vlis/tgLjETlN6FH6IwFT+boxSDFzME4E9YW5aNPTXRyVKH8m/DLUjRykZaKPu7ctDtzwdQDa4yP4qwqzqRW1/hPPVasFh+pmpmW6aS5SZn42eTQ409PSXp45Ou8QJqQDGHe2E7o0/GEzYCshothLztrN6kVeK3RQtrvdUWAx+RUaVwszUWv7aFAhTfZg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=o8KKO4yQpYThZEFnGtRYxdyyKT3ETTdhaI/76W+xPaw=;
 b=kmwY+L9+znm81IpJRqHw+ytiOWfggyLeXMbPcGf0ggqrXSw1z7y1Wj0LtE9JpJcqDTIae2EEJHVnyB5Q3thUsWzaMJ/K9hlNUDQ2BRzgj7UmkM5Hm90QQRpHCtBNdvUNHVezBWU9cp9zUDqrC0lutbdHBOuA6tA7jcdLaMp8WVkfMHbZNPlWK1QfZLi2UR+4EJRDRHu7gji/sMeJJUnP0MmVgxYLNNoCvSInTGvwIaPneQv1v3YHRPGkJVtO9ScYDu4ltIILXGYnFDAo4HyxodDYSQdDe7/RPz444MXLfhpR8ARdz+YOh4r+EtQXQtZZhWTUIRc5Bl4QSW9wfZIxng==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=fail (p=none sp=none pct=100) action=none header.from=xilinx.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector1-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=o8KKO4yQpYThZEFnGtRYxdyyKT3ETTdhaI/76W+xPaw=;
 b=fQldYeHxYG1kSoVD1PjaerEKc6h4TK/XMCvIC+pWZBdlRqb8mAW8l18qwiDxzO8phhIYABvxPX8MSNyA+q/C2sdPFFbK/Qj8C1QlM8lR1MKM0Eo8LNjx0zNl8LY/au7K3BF0LHPjcDhdlkGVyk16AErRHOW99qDN+VpihAM1mWgTblFJ8IyLLnVYw+5vOd/hkupUOcezIDYm+spSJCc096VZne0AWMP+WuLucQXa6YN/b08yCNdI0ox654K2/ukC4QMw05B26oy7PJFidfIUkTFtkB8SenUXf3XsaoDxqf52INBu7u39IB6ajMJr5xeefbyUtsBL5Eons5OWjPZV4g==
Received: from MW4PR03CA0019.namprd03.prod.outlook.com (2603:10b6:303:8f::24)
 by SA0PR12MB4558.namprd12.prod.outlook.com (2603:10b6:806:72::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5654.25; Mon, 26 Sep
 2022 18:59:02 +0000
Received: from CO1NAM11FT084.eop-nam11.prod.protection.outlook.com
 (2603:10b6:303:8f:cafe::c8) by MW4PR03CA0019.outlook.office365.com
 (2603:10b6:303:8f::24) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5654.25 via Frontend
 Transport; Mon, 26 Sep 2022 18:59:01 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=fail action=none header.from=xilinx.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB03.amd.com; pr=C
Received: from SATLEXMB03.amd.com (165.204.84.17) by
 CO1NAM11FT084.mail.protection.outlook.com (10.13.174.194) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.5654.14 via Frontend Transport; Mon, 26 Sep 2022 18:59:01 +0000
Received: from SATLEXMB08.amd.com (10.181.40.132) by SATLEXMB03.amd.com
 (10.181.40.144) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.28; Mon, 26 Sep
 2022 13:59:00 -0500
Received: from SATLEXMB03.amd.com (10.181.40.144) by SATLEXMB08.amd.com
 (10.181.40.132) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.28; Mon, 26 Sep
 2022 11:58:59 -0700
Received: from xcbecree41x.xilinx.com (10.180.168.240) by SATLEXMB03.amd.com
 (10.181.40.144) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.28 via Frontend
 Transport; Mon, 26 Sep 2022 13:58:58 -0500
From:   <ecree@xilinx.com>
To:     <netdev@vger.kernel.org>, <linux-net-drivers@amd.com>
CC:     <davem@davemloft.net>, <kuba@kernel.org>, <pabeni@redhat.com>,
        <edumazet@google.com>, <habetsm.xilinx@gmail.com>,
        Edward Cree <ecree.xilinx@gmail.com>
Subject: [PATCH v2 net-next 0/6] sfc: bare bones TC offload
Date:   Mon, 26 Sep 2022 19:57:30 +0100
Message-ID: <cover.1664218348.git.ecree.xilinx@gmail.com>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO1NAM11FT084:EE_|SA0PR12MB4558:EE_
X-MS-Office365-Filtering-Correlation-Id: dda5d0fb-eca9-4568-a47d-08da9ff12d0f
X-MS-Exchange-SenderADCheck: 0
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 2RWYrEND8S0lxLxdSinbGdeL2vfMR6Ly7N4R4asc0SzZPtHS24xwzXoXnW0QelYNtXVKJr48jIwHlKCtbBJPq7ckbJ1LqZrrClkQ1WynQfRiLboioajftqTIuGIpQ2rDtKfUCEZBW7o9CyNqPQmmXD6MYdn/O7x6x7jEiTkYyqfHcHOJXC1nkwMVJfTzpz35zvbpqXQ6Bzu03z9g6Zabdy27I34rgFbA3HmrDJLoUR0rwzxgfl2v7T8CJwxRH00Fis3SRztMXmXNbuDRFgYhdnh1/SK0OOojRy1tBBx0G+XI76VU51QXcnLiJL+IRKq8jJcTDQaTjNZwuVPMfBzKdkJ2XdAtRQ1sHQx2MPf2io6e1YaU/Cp4Lk1kxpMLYbM+9WXQeLT/wQ4qw3ToE39bP9HJFz1ZdK/e2ZpPNFiN83mfdSi5VCjcgbZJA8a9M9B2dDsQauJY4iWS64dceM8y48kSWFL3i/XQIL+i95Nkul7098uDhr7opJkNQ+h55DAFnQSVWr7iYUQsTfozgPTflYTPjwl9VBkFI2k3BKc3AmEbiGawEq+bi1TOIli5UcB8gRXGfjPvtA1nTY7qtUnK2YVaiGx/X546hrZvspuoFl+8QEqfDGsV2IE5TXbv+/60xkpuwxSXQ0VQ/DR0WNZARtU4VB5m6joTMQ486MAU6YNstDeiCWecquZRD2mPt7FT3bJoB97TcayObhl6IZ5N0aiaoiBj3EbBVFyuqESHzbjBiBNtu+aSySlAZMikzlv1rnewzhQt66SbEYEd7o30OsPNmuhXk5peQq/CBQfKezc=
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB03.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230022)(4636009)(396003)(346002)(376002)(136003)(39860400002)(451199015)(46966006)(40470700004)(36840700001)(70586007)(186003)(4326008)(336012)(70206006)(47076005)(42882007)(8676002)(26005)(6666004)(9686003)(54906003)(110136005)(2876002)(316002)(36756003)(5660300002)(356005)(2906002)(83170400001)(82740400003)(81166007)(8936002)(41300700001)(55446002)(40480700001)(40460700003)(83380400001)(36860700001)(82310400005)(478600001)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Sep 2022 18:59:01.5468
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: dda5d0fb-eca9-4568-a47d-08da9ff12d0f
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB03.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT084.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR12MB4558
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

Changed in v2:
 - Add missing 'static' on declarations (kernel test robot, sparse)

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


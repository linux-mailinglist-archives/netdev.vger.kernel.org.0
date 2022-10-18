Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D27896025DB
	for <lists+netdev@lfdr.de>; Tue, 18 Oct 2022 09:35:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230268AbiJRHe6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Oct 2022 03:34:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41562 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230212AbiJRHe5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Oct 2022 03:34:57 -0400
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2058.outbound.protection.outlook.com [40.107.223.58])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 43FA81EC79
        for <netdev@vger.kernel.org>; Tue, 18 Oct 2022 00:34:56 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=EAWr9e9Vm5852xvrfrqZY4qw1eSTHctZusf/0bywSzuwVg8pIOtW91bythuWWpgXUEsPEndvZSOLlJrguOZJ2BVcsN/P0wcQ2qayAhOozO9qN7CaQKnWIDpXoAKM9sqnzmxm7r7+NpU+fNlYzQua3/vIv3ji8YgcKkI45FDGNoGwg3bH5IKezPSSBCbpi0pWe1gmpookX+Ox6sUAiqxhp874C2/l49EgVSJC1pKP2vkLzCcGX7VrAtJEkCDBgcrHT8FY6g/X9PGG8I6KD5vLyem15EG7k7UOAYvK2WpVbfV6yMlnmFevvY/R8oNLsyiM98YGBLYEs10p4FX/NRqiaw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=iux2GCKXURnSsHVL6orqQVcCHx4QAAqBr8JyYweBiHA=;
 b=FkPbbzkyByvZb88T+EQt2MWad1ddczAh6HRjDwjZr9RLx+7/zE9xoqc1H+m0KiCa5+RI97veXD5j6sCdaeaGGPGrai24uaXtvQFfT186JD71uCXGjbVDbfG9LrjE+jKNyJjnCcHrQqOZznCmgdubkGc7PCGYWmgQs17Ggt4T3ed0upS4L7OyJ4uxDBsNTTEjlBcGfXNwC+AdQEIw5tiRzibsWgW2u+YjnuQgmOjayQBWyXtWW8gksw9r1+ibthQHH8m+Og6Xg+gawnsQiI2K1sCKHm91oJrag/qViPwdnh3l2F6PjPdQH/I2xUB7T/nVqLEViZll9NxSq8gTpTC3mQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.118.232) smtp.rcpttodomain=iogearbox.net smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=iux2GCKXURnSsHVL6orqQVcCHx4QAAqBr8JyYweBiHA=;
 b=g2I5cd5M0jF0k2tc4BA8UJOhxXzgAN5c4Pfxc5gsS1q9KQxdlNvWGNupGVkZJvzTYSFEPXSxe5lhNR/tw4YRn0eQxmTWNu53R3EqlJHQrbmoOkGxk6pwhZa2Vjmbwh52i4oRRQBvP80mymfxLWujOeREvMXAQyMap+5qXB9c4tN2hP+5f7DAzWrZu4sRbouj9uYjRHwnXSdtRk2+wxBRUN+6nW6xIi5470o5CgT2khBYfQgD1oVreQGL5RFjsg+BbntFmVkCpPTaJRj/2+958DIL5qjdw6RNAQOwVDMPb+5sdSxOZFKngaTGio5v4i6+QglIs3OaPX8MGS950rjJSg==
Received: from BN9PR03CA0717.namprd03.prod.outlook.com (2603:10b6:408:ef::32)
 by MW4PR12MB7216.namprd12.prod.outlook.com (2603:10b6:303:226::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5723.32; Tue, 18 Oct
 2022 07:34:54 +0000
Received: from BN8NAM11FT036.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:ef:cafe::48) by BN9PR03CA0717.outlook.office365.com
 (2603:10b6:408:ef::32) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5723.32 via Frontend
 Transport; Tue, 18 Oct 2022 07:34:54 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.118.232)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.118.232 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.118.232; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.118.232) by
 BN8NAM11FT036.mail.protection.outlook.com (10.13.177.168) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5723.20 via Frontend Transport; Tue, 18 Oct 2022 07:34:53 +0000
Received: from drhqmail203.nvidia.com (10.126.190.182) by mail.nvidia.com
 (10.127.129.5) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.26; Tue, 18 Oct
 2022 00:34:45 -0700
Received: from drhqmail201.nvidia.com (10.126.190.180) by
 drhqmail203.nvidia.com (10.126.190.182) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.986.29; Tue, 18 Oct 2022 00:34:44 -0700
Received: from reg-r-vrt-019-180.mtr.labs.mlnx (10.127.8.11) by
 mail.nvidia.com (10.126.190.180) with Microsoft SMTP Server id 15.2.986.29
 via Frontend Transport; Tue, 18 Oct 2022 00:34:42 -0700
From:   Paul Blakey <paulb@nvidia.com>
To:     Daniel Borkmann <daniel@iogearbox.net>,
        Paul Blakey <paulb@nvidia.com>,
        Vlad Buslov <vladbu@nvidia.com>, Oz Shlomo <ozsh@nvidia.com>,
        Roi Dayan <roid@nvidia.com>, <netdev@vger.kernel.org>,
        Saeed Mahameed <saeedm@nvidia.com>
CC:     Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Subject: [PATCH net v4 0/2] net: Fix return value of qdisc ingress handling on success
Date:   Tue, 18 Oct 2022 10:34:37 +0300
Message-ID: <1666078479-11437-1-git-send-email-paulb@nvidia.com>
X-Mailer: git-send-email 1.8.4.3
MIME-Version: 1.0
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN8NAM11FT036:EE_|MW4PR12MB7216:EE_
X-MS-Office365-Filtering-Correlation-Id: 3bd20f2d-806f-4db7-66c9-08dab0db3fbd
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Snx9Ma/AzPxLaQyDSfPGyDEKUHCIlykf6BvEjOKMZHbTNsYEV6J4YOHwtwqH9q9mSeXGdsTUCJGgRpCixjx2es39V/sgTe+lmRvB86fyxbU+JZ5sGfnw7aI34zwC0ox4dQ7LsbX20ApBRFAlt3o0QKF9pql84dZOeAZ5zuKiyhp0gpScBt+v/HAW4yvijpBG8xhtVyecN+g3/28gWl1g13DZvGmXpkylySqYszZC6EN9NYQvwWZ152ZsOUfF/UCcJaX8beJ9cBQQULhdT04HmXieZDQ132uPSDCk8VYqcvNY6ZGiIX1v1VaCJ9qgaSfr2g9sldpMEvUcMavZbsgWZ/YbnZ03ygjHAm8mm1JCoBdmqkiY3nUJXXRdR+banY8ArcCoExuOYFKlCarOzLXZ5rJ2ha5LaegqaAxS6jsOr4cLcPsSjO3HNGoq2m1LhbDtTiuVjF2fvhILjlc+XuVnUBSng3j+kiDcpSTXDTdvP9/o+oSbM7DHxjwex5NZt9v6IHvX7x7jtzdNhKC2NzBZe7MFJyTnPw9up+aOMfov3A6sfmHStOinZ3TWsIpOvknNshQPP8QWqOL0kJeGYru9l9HyaXJ1qWmnNkdwm19dyKqnNt1kuWHnZqE5jLSUIfbYB5L52BCE2wd0MdKD5T8DNUaqvW8wIR+JJfDIi/PZjJs178sCJn1rbP783A/4pDUJFU8vTrvYW79MvCkI1Q9n27NAMnO6tXF6pAEDwtO7ctRrt+Ti6WpkH9zR9ve7iNbFrimgmFoNi3Ocrx1jzu1c+Q==
X-Forefront-Antispam-Report: CIP:216.228.118.232;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc7edge1.nvidia.com;CAT:NONE;SFS:(13230022)(4636009)(39860400002)(346002)(396003)(376002)(136003)(451199015)(40470700004)(36840700001)(46966006)(4744005)(186003)(36756003)(86362001)(82740400003)(40460700003)(356005)(7636003)(2906002)(5660300002)(8936002)(41300700001)(70206006)(70586007)(4326008)(8676002)(36860700001)(316002)(110136005)(40480700001)(54906003)(82310400005)(6636002)(426003)(47076005)(6666004)(2616005)(336012)(26005)(478600001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Oct 2022 07:34:53.8018
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 3bd20f2d-806f-4db7-66c9-08dab0db3fbd
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.118.232];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT036.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR12MB7216
X-Spam-Status: No, score=-1.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fix patch + self-test with the currently broken scenario.

v4->v3:
  Removed new line in self test and rebase (Paolo).

v2->v3:
  Added DROP return to TC_ACT_SHOT case (Cong).

v1->v2:
  Changed blamed commit
  Added self-test


Paul Blakey (2):
  net: Fix return value of qdisc ingress handling on success
  selftests: add selftest for chaining of tc ingress handling to egress

 net/core/dev.c                                |  4 +
 tools/testing/selftests/net/Makefile          |  1 +
 .../net/test_ingress_egress_chaining.sh       | 79 +++++++++++++++++++
 3 files changed, 84 insertions(+)
 create mode 100644 tools/testing/selftests/net/test_ingress_egress_chaining.sh

-- 
2.30.1


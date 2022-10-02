Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0F6A15F228C
	for <lists+netdev@lfdr.de>; Sun,  2 Oct 2022 12:25:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229709AbiJBKY7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 2 Oct 2022 06:24:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59910 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229695AbiJBKYz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 2 Oct 2022 06:24:55 -0400
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2074.outbound.protection.outlook.com [40.107.237.74])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 29D981AF1C
        for <netdev@vger.kernel.org>; Sun,  2 Oct 2022 03:24:53 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=eKp2lYyvhI3Nj1ovpQrqYcFVBV033S5V410VXBgynPFmcK3WuN4SLcjXiRJFO0Z3Apk9PV3+uvtTGnQWWN6oiQo+vGhkX0Y7/KjmJz6LpVp32ijsIFzNONnEyvfTj9DOeo/cZhrHd0/ZDbfy6vJJJUWNPUE2IKtSJ7rigYYl9vbecN1pdn1SIcanVVxtY2ZsACoujUE56XnNJVJ/DecW7kwZGLRa+Im3GuH7BF5/vAOQRcZQk4KvCW8zcxowBtvsxCK5jhET3jR/KO4zOrkBcDOO0JhrgPj9uYunPXBboZtiPcPnG0uZGm0sQNLSP4AyA9BKzWPUUa7upRVWmKaymA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=LBDHyNHXlQNtETb79hEh4qhu8joCP1yIJCB7+0Vx8A4=;
 b=L6K4cqzBrmDdoTEH3ATOg2GK8suRHjUF/ek1Y5Pd09bfitM9Bcb2rP+jsbvGT9CFBmafDj8xm8IgVXuiB4HLyV80Es1sIbjK/dAxl03wepcMdn9IEJPvNSKwAE0Klyurg8RSsgwpi2WtoyEaC0gFlUqxlBz8w4G85HcnVGf22cPKcy8EoUVXFwHCkNRO+7WMLEljoZTZlApKQEPi+lcCCfCvN7m+3izbhZ2xqlznD3Wx2oC42E8DNnJkGk7qLKMyEkm+F63UUoCu9zRf2EyS5lYHJvGLaXyodYgrYRJyIG14tFGLOC9zHdC3A6ljAOvm5xVP0ENFslGs5UKBUHmoQw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=iogearbox.net smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=LBDHyNHXlQNtETb79hEh4qhu8joCP1yIJCB7+0Vx8A4=;
 b=lgKCFf0NmJHORgvgkb5GokTHIhWyRItQmzP471WUmVS6pXXHF8imw1KE5bqMWyoFL4qaZqoELVAvanDe4QRUPfrrJWcEB5NYd8qvBP2DekCXBD3jxYkxPIs5+TRnC+4f0nvs8aclMEzEx6SEr3cp4GRtB/e4ciNkx32aI8XXoFGdSoN0bG7ZKx83SQj63xl2zx+HRYl4WUyuFFucx5BTpEtXByTcDELwr0L+t9pokE0ziclt3D92OtRlxEFHCLdSxKQqCENKfYNiBBlPB/RCJ9Pkz5FayZ3I34Jd5zJ1ER/aBYPjU3pTciqEQW7gbFBPPrd/LJHCplSweZOS5jSANQ==
Received: from MW4PR03CA0217.namprd03.prod.outlook.com (2603:10b6:303:b9::12)
 by MW6PR12MB7086.namprd12.prod.outlook.com (2603:10b6:303:238::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5654.26; Sun, 2 Oct
 2022 10:24:50 +0000
Received: from CO1NAM11FT110.eop-nam11.prod.protection.outlook.com
 (2603:10b6:303:b9:cafe::eb) by MW4PR03CA0217.outlook.office365.com
 (2603:10b6:303:b9::12) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5676.26 via Frontend
 Transport; Sun, 2 Oct 2022 10:24:50 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 CO1NAM11FT110.mail.protection.outlook.com (10.13.175.125) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5676.17 via Frontend Transport; Sun, 2 Oct 2022 10:24:50 +0000
Received: from rnnvmail205.nvidia.com (10.129.68.10) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.26; Sun, 2 Oct 2022
 03:24:39 -0700
Received: from rnnvmail204.nvidia.com (10.129.68.6) by rnnvmail205.nvidia.com
 (10.129.68.10) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.29; Sun, 2 Oct 2022
 03:24:38 -0700
Received: from reg-r-vrt-019-180.mtr.labs.mlnx (10.127.8.11) by
 mail.nvidia.com (10.129.68.6) with Microsoft SMTP Server id 15.2.986.29 via
 Frontend Transport; Sun, 2 Oct 2022 03:24:36 -0700
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
Subject: [PATCH net v3 0/2] net: Fix return value of qdisc ingress handling on success
Date:   Sun, 2 Oct 2022 13:24:30 +0300
Message-ID: <1664706272-10164-1-git-send-email-paulb@nvidia.com>
X-Mailer: git-send-email 1.8.4.3
MIME-Version: 1.0
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO1NAM11FT110:EE_|MW6PR12MB7086:EE_
X-MS-Office365-Filtering-Correlation-Id: a7db8a13-07b0-460a-9f20-08daa4605695
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Eg3+oll+8x+hUUv71arJfUI4xOW5DhqxV7F5GIbRJk6yuEUMGvJIqWWQXF2X3aUFV95rOOPvSWFpGiACbOP/Whi6NFhlwlEEkRQTlEo17SrSgl86JXmzbOU/jP5j5bOQR5JyxuAtje7V3Uvw0Fa5BNWe0kURe3d+gGw/C7K1BDSyYOswZTz9GGpDE3x3uKzcdflLLneHcjyS0E3yE6263gVkHEdyXDGU8oHiWXO6Tw9lCl8WfNKJ4JIfdPus+EP6ia53HOaszNMSpBWMgq+jsXwAZZ4Db/zlQ7AJbNi2770scqF+WXPbWTUk0g6CCYJ5xGy7sSU4WlsQZ5ae/Vmp3CBzZupFa3iM9/OwPUlUFejA1c1H5UH93NL2ICWZ1Jwhcp/ZCxg5vHl4RK4qsu48P7v+Vl2XZ4UMv8zvq9r5JTkFcXD0mgwC432s705Gxe6oSxxYrdktE8w2rzlyfDYGhwHdcxy4SX1GRhbusOmgrNMTleYPcqkqaMHC+6GB1E2MkDnZkoDYO/icZFdHCT80xOlt4TGfs92hzeBw+tdoyF/XKY/jeFFWAdktE2j7C/M07fUTTJHsNeiuBMbQqSF1VKmSq+X1wMpgzHAQnKbhwgesl0itr3EJoVObTq13oZYQ7n/w1miTY17x7rFWdsuQtw+HSPSIKRYLgHsrFaRR6mNaZf6/IKdaxwQqfFgDa1iQm+9sm0OHE4mPUmgK3KH361/z28xTS69XA6+/qRDmUKEPQuoCiqHVnBxLBIJA0McFRR2dyKhJ2prH7gWwlzjz9g==
X-Forefront-Antispam-Report: CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230022)(4636009)(346002)(39860400002)(396003)(136003)(376002)(451199015)(36840700001)(46966006)(40470700004)(110136005)(47076005)(86362001)(5660300002)(2906002)(2616005)(8936002)(426003)(7636003)(4744005)(336012)(4326008)(70206006)(41300700001)(186003)(356005)(26005)(8676002)(40480700001)(82740400003)(40460700003)(36860700001)(316002)(82310400005)(70586007)(54906003)(6636002)(36756003)(478600001)(6666004);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Oct 2022 10:24:50.1245
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: a7db8a13-07b0-460a-9f20-08daa4605695
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT110.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW6PR12MB7086
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fix patch + self-test with the currently broken scenario.

v2->v3:
  Added DROP return to TC_ACT_SHOT case (Cong).

v1->v2:
  Changed blamed commit
  Added self-test

Paul Blakey (2):
  net: Fix return value of qdisc ingress handling on success
  selftests: add selftest for chaining of tc ingress handling to egress

 net/core/dev.c                                |  4 +
 .../net/test_ingress_egress_chaining.sh       | 81 +++++++++++++++++++
 2 files changed, 85 insertions(+)
 create mode 100644 tools/testing/selftests/net/test_ingress_egress_chaining.sh

-- 
2.30.1


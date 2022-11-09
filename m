Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6C0EC6236C3
	for <lists+netdev@lfdr.de>; Wed,  9 Nov 2022 23:48:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229733AbiKIWsB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Nov 2022 17:48:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48062 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229447AbiKIWsA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Nov 2022 17:48:00 -0500
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2078.outbound.protection.outlook.com [40.107.244.78])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D73A725E89
        for <netdev@vger.kernel.org>; Wed,  9 Nov 2022 14:47:58 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fWfkK5wFaOu4FpA2gP/t8S2gkEjRgmRP0WYMqhdg3ynpJd/5v4FB/DnfESEQwI+M2O+0KOSqBqL2dfCKtCo/I10kD/NraipZSJs+OGzKV9MJ2v/0XKPySXVCPucxMgDE2OAosFq6Uv9zVDXKnn/rhJZBMj6BKWSZV6vkt25QVc5FU6xqDPNakQczHg8gOO35C8ETfoWQg9H3Kgg/QhzHODiyps6Y0ByT6M6YL4I0yZ9jhey7d+fc2F77lUA/8U44QEU0e+mDHFYByb5CERXSy+cXSiaoULHbNfDcetzz58CV7FI4zQX/6JUkWpxM71nVHDQRCxtG31wBClqxFjZN3A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=uu9UPHzbQnh6nag1u4oaoxJCVF1KQZb82/g1iORjp7E=;
 b=HYZrfTXv//OuP8GvlyklLF6OJQWkPRxUk3soRUg3kxQCS3IFICgt8OavoONjzvClwiGgakY6qVhkUNK6++BZ7cY2zxEWUllUEVbEjrImfmRxvCt1wMS7rWNbeuhwYr6ot0R8Jk0auZTttUM4qw5Rpo9EOo0vwHf6+/Z1TLEMVdbo6cNGob+OsUhEKffvsMdayWuI+mBGbuAcfTFz5Uf0728x46YbrIC6LYY+i7pk5IcIimK8hf23lYprjFlAiPDUIc8pgforM/652thyJUknZx2zooze8pTQipldW4IlZM6XMSzImADHQTGcUwBtGUno+77ojIppAILKe//EwxRltQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.118.232) smtp.rcpttodomain=davemloft.net smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=uu9UPHzbQnh6nag1u4oaoxJCVF1KQZb82/g1iORjp7E=;
 b=ObWkvrPqliWYOiEbAFY5TDdmbhHW8EvP2EnwOjasDsJ/HUQWRMuM4QZYoXjuzgqcahVosmNEBE7qy4Sml+byAG1CWTMIeGPxLxWOR/yD/Q+OhXSGwUb6wjhiUTKAVaZ+RnA8VwfvQYANXxWLJ7GCDU4hm6/WOcK2Gz0ruvMoqEojx6GS7QOdR843w32AWNV/Oz+D8GM+6TA91L3cKWAzowulqXfKs+GHX2Oph/WuhlSuklSVhhkqUknrDE+NL9kufphczStOAYSf33nES9ovKZs77t3YXz4If878hc6ouwX65L4VtR/HYOzZZvHdKiUCikt4ydOOvdEX4QNuC2kYNA==
Received: from DS7PR03CA0177.namprd03.prod.outlook.com (2603:10b6:5:3b2::32)
 by CY5PR12MB6154.namprd12.prod.outlook.com (2603:10b6:930:26::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5791.26; Wed, 9 Nov
 2022 22:47:57 +0000
Received: from DM6NAM11FT042.eop-nam11.prod.protection.outlook.com
 (2603:10b6:5:3b2:cafe::4d) by DS7PR03CA0177.outlook.office365.com
 (2603:10b6:5:3b2::32) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5791.27 via Frontend
 Transport; Wed, 9 Nov 2022 22:47:57 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.118.232)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.118.232 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.118.232; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.118.232) by
 DM6NAM11FT042.mail.protection.outlook.com (10.13.173.165) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5813.12 via Frontend Transport; Wed, 9 Nov 2022 22:47:56 +0000
Received: from drhqmail203.nvidia.com (10.126.190.182) by mail.nvidia.com
 (10.127.129.5) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.26; Wed, 9 Nov 2022
 14:47:56 -0800
Received: from drhqmail201.nvidia.com (10.126.190.180) by
 drhqmail203.nvidia.com (10.126.190.182) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.986.36; Wed, 9 Nov 2022 14:47:56 -0800
Received: from vdi.nvidia.com (10.127.8.14) by mail.nvidia.com
 (10.126.190.180) with Microsoft SMTP Server id 15.2.986.36 via Frontend
 Transport; Wed, 9 Nov 2022 14:47:55 -0800
From:   David Thompson <davthompson@nvidia.com>
To:     <davem@davemloft.net>, <edumazet@google.com>, <kuba@kernel.org>,
        <pabeni@redhat.com>
CC:     <netdev@vger.kernel.org>, <cai.huoqing@linux.dev>, <brgl@bgdev.pl>,
        <limings@nvidia.com>, <chenhao288@hisilicon.com>,
        <huangguangbin2@huawei.com>,
        David Thompson <davthompson@nvidia.com>
Subject: [PATCH net-next v2 0/4] mlxbf_gige: add BlueField-3 support
Date:   Wed, 9 Nov 2022 17:47:48 -0500
Message-ID: <20221109224752.17664-1-davthompson@nvidia.com>
X-Mailer: git-send-email 2.30.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6NAM11FT042:EE_|CY5PR12MB6154:EE_
X-MS-Office365-Filtering-Correlation-Id: 02d13d4a-c843-419d-a2a3-08dac2a47216
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: L9f1a6du+8z6cUhXGygMjfM81xwqzM8rb0Zj7HLFTTo5VOHz/drk3cfwbyP2gb2szYmCyoTrqJtrdIW5rhTw9CIk+42DRfyjMmwe0ognxfZVjTIRSNI/EzYq9RVaTP37+6oosLVfDcVml79x59hdhgemQXU3sBSs0JHImL5Oy2K+R3t4QwJ+MGhSlHaJJNX2tLOkMmRjCuVzwYZRAkD8Jmd1kI5ROlZRwshToGIBmA3pzL0Lp8mStbc+8rTr8nOrp7FC9XGhEKA0DDB8/54eMkkXsK/RrGHIGRXGsy5csb99yTR5WkUhepN0ASu1MwtRhtdGBfotEPANnJM6gGQX6RBujEy/ZiKGu7GITD56mB8lXYw1SMdoKcLu1bhQdnkeL99o2hu8RW4QCg80R6ZJSmVE9dPA7IbdIo1ik8dmiakdnCNP3p9/StqYwvYtyVG8zJTnhWVnEEN4d60jUxQPrIqWs88S8Qmu1DLtCPJx7IikDfDjKeLQKy+sVzTl/aUyLbD1VWGdmyrC88QADTQvxZ5+WhE9ERdMfSMNAhxZQd0bkH6JtNnQHyyuir9jBbeaj6Jx5LS5dTCxUE/Hg5Gc9H06hn2U3e/LSBbQS6cSp+ME17ad3lklPiYlmzHXTM75/l2iPRMRaHxGmhmzB/epBTKeBvPGz1Ttn1sWVwprJEtmHbmJ8MgMMVUfGXMnugbKVj0jroG9WVKn+mMfVY0M0BW99JB5d1/iz39Y9RaiIbTA5r/HAarJiQKUshbCqkI8gJNf0gWQSO0LqVyMjXAKvQ==
X-Forefront-Antispam-Report: CIP:216.228.118.232;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc7edge1.nvidia.com;CAT:NONE;SFS:(13230022)(4636009)(346002)(39860400002)(136003)(396003)(376002)(451199015)(40470700004)(36840700001)(46966006)(2616005)(6666004)(186003)(336012)(26005)(1076003)(47076005)(70586007)(7696005)(36860700001)(83380400001)(2906002)(426003)(107886003)(40480700001)(40460700003)(4326008)(478600001)(110136005)(316002)(82310400005)(8936002)(5660300002)(41300700001)(8676002)(70206006)(54906003)(36756003)(7636003)(82740400003)(86362001)(356005);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Nov 2022 22:47:56.9451
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 02d13d4a-c843-419d-a2a3-08dac2a47216
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.118.232];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT042.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY5PR12MB6154
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch series adds driver logic to the "mlxbf_gige"
Ethernet driver in order to support the third generation 
BlueField SoC (BF3).  The existing "mlxbf_gige" driver is
extended with BF3-specific logic and run-time decisions
are made by the driver depending on the SoC generation
(BF2 vs. BF3).

The BF3 SoC is similar to BF2 SoC with regards to transmit
and receive packet processing:
       * Driver rings usage; consumer & producer indices
       * Single queue for receive and transmit
       * DMA operation

The differences between BF3 and BF2 are:
       * In addition to supporting 1Gbps interface speed, the BF3 SoC
         adds support for 10Mbps and 100Mbps interface speeds
       * BF3 requires SerDes config logic to support its SGMII interface
       * BF3 adds support for "ethtool -s" for interface speed config
       * BF3 utilizes different MDIO logic for accessing the
         board-level PHY device

Testing
  - Successful build of kernel for ARM64, ARM32, X86_64
  - Tested ARM64 build on FastModels, Palladium, SoC

v1 -> v2:
  - Fixed build failures in "build_32bit" and "build_allmodconfig_warn"
  - Removed use of spinlock in BF3 "adjust_link" callback
  - Added use of ARRAY_SIZE() where appropriate
  - Added "set_link_ksettings" ethtool callback for BF2 and BF3

David Thompson (4):
  mlxbf_gige: add MDIO support for BlueField-3
  mlxbf_gige: support 10M/100M/1G speeds on BlueField-3
  mlxbf_gige: add BlueField-3 Serdes configuration
  mlxbf_gige: add "set_link_ksettings" ethtool callback

 .../net/ethernet/mellanox/mlxbf_gige/Makefile |    3 +-
 .../ethernet/mellanox/mlxbf_gige/mlxbf_gige.h |   31 +-
 .../mellanox/mlxbf_gige/mlxbf_gige_ethtool.c  |    1 +
 .../mellanox/mlxbf_gige/mlxbf_gige_main.c     |  164 ++-
 .../mellanox/mlxbf_gige/mlxbf_gige_mdio.c     |  185 +--
 .../mellanox/mlxbf_gige/mlxbf_gige_mdio_bf2.h |   53 +
 .../mellanox/mlxbf_gige/mlxbf_gige_mdio_bf3.h |   54 +
 .../mellanox/mlxbf_gige/mlxbf_gige_regs.h     |   22 +
 .../mellanox/mlxbf_gige/mlxbf_gige_uphy.c     | 1173 +++++++++++++++++
 .../mellanox/mlxbf_gige/mlxbf_gige_uphy.h     |  398 ++++++
 10 files changed, 1987 insertions(+), 97 deletions(-)
 create mode 100644 drivers/net/ethernet/mellanox/mlxbf_gige/mlxbf_gige_mdio_bf2.h
 create mode 100644 drivers/net/ethernet/mellanox/mlxbf_gige/mlxbf_gige_mdio_bf3.h
 create mode 100644 drivers/net/ethernet/mellanox/mlxbf_gige/mlxbf_gige_uphy.c
 create mode 100644 drivers/net/ethernet/mellanox/mlxbf_gige/mlxbf_gige_uphy.h

-- 
2.30.1


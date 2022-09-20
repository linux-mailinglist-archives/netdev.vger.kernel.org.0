Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C70E75BE697
	for <lists+netdev@lfdr.de>; Tue, 20 Sep 2022 15:02:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230246AbiITNCU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Sep 2022 09:02:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35546 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229603AbiITNCT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 20 Sep 2022 09:02:19 -0400
Received: from NAM02-DM3-obe.outbound.protection.outlook.com (mail-dm3nam02on2086.outbound.protection.outlook.com [40.107.95.86])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1220331233
        for <netdev@vger.kernel.org>; Tue, 20 Sep 2022 06:02:19 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=RobcrxvSbrRBqb6kysp5DavDhKVbhvUbM5PEIp3KRiomuXT3LEPafMawr66oGoBdBU+hIuXReLaF/ysDLAvvPcdlMMXHBLoglk92OVvsi1y17fH6p9zVU9YAZP449xuQnTwmrkSoR67X44EcIi2aTsJ1RiF0qEOb+aREgMXr98x223nMM2mnaaIiGVlvskurKjD+68w1RhwQaMIGZE2voDar25woTKoD+MOp4fg0erNWBLfJhZcHhSC0TSavXguWq+qBAE06Q8OqjSP6qv1sGFdokPSZf41xxqnjNT27Dl8yIFv6GbvKq5QZ6LDpDLAfIVbELtxYHMAlSPnBXvKdgg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=mOqEHUPmsY968KWjwInrFI1W+NDOEqHKVwDV7v8M0fQ=;
 b=a/QryE7OtMlcJG7P2urZW5FceUp5YS3+gbur4Z2nCyHjQbPk/LjYeL98HbXYWeo4XMxeLCVsACWBwwqVm5YL9hGtu/oyPy9vJcFR4IOcBK0kdkuHwN5LAxva/E/3TftY+nmd9NFmYXNzOmmvL2rE2j9ljNtuohwBXi2ymq68dLCE3t7SAgBDd3R1GuxCFImDa85yHpkZlTZBzcpFRDrB078QnxLkoJsiTStrO5scm9h8uqXeOxZUy4VuFLXIpR4/8qT6AKRcv8HaYD7V7GiUr3QpEb9ZRHPRZy3T1yQgQuodp+JnIn33w3mIwIQTCz2oAZrJGArLLjP8C6pNpsvafw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=davemloft.net smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mOqEHUPmsY968KWjwInrFI1W+NDOEqHKVwDV7v8M0fQ=;
 b=fe3cvmnQ2QvI7Cv5mXuvFdVlle32GUBgs7LBAO8vq8CPsc8xb3ONP/1sUhc2XyXMl9zvdj5ftzdQrJuE8bT14ym3zA8egFn5znwMm56BtBs0RQwpWo16ueTP52SvavY6tZ+9E8u7geiHh+72YmRBAwdBZIBYeOs89eTpxkHMxYSGD+oqTqo0cbdvMCd3oEg/YYzQ9Ff0cLVR9GLGiOkJhzh3h4td6kDhICYjc8dqUWs8eF+rgAAAWo7JnU3iHhjNwLRcpgYTsrhDi+cs+ETN8dkktnub3nrk2smesEff+LUyNK8U9Ma1GrA4mQUvEhYQmzdAARzIMjdDPVlc1zBqtw==
Received: from BN0PR04CA0045.namprd04.prod.outlook.com (2603:10b6:408:e8::20)
 by BL1PR12MB5729.namprd12.prod.outlook.com (2603:10b6:208:384::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5612.22; Tue, 20 Sep
 2022 13:02:15 +0000
Received: from BN8NAM11FT058.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:e8:cafe::73) by BN0PR04CA0045.outlook.office365.com
 (2603:10b6:408:e8::20) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5632.21 via Frontend
 Transport; Tue, 20 Sep 2022 13:02:15 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 BN8NAM11FT058.mail.protection.outlook.com (10.13.177.58) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5632.12 via Frontend Transport; Tue, 20 Sep 2022 13:02:15 +0000
Received: from rnnvmail202.nvidia.com (10.129.68.7) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.26; Tue, 20 Sep
 2022 06:01:57 -0700
Received: from rnnvmail201.nvidia.com (10.129.68.8) by rnnvmail202.nvidia.com
 (10.129.68.7) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.29; Tue, 20 Sep
 2022 06:01:56 -0700
Received: from vdi.nvidia.com (10.127.8.14) by mail.nvidia.com (10.129.68.8)
 with Microsoft SMTP Server id 15.2.986.29 via Frontend Transport; Tue, 20 Sep
 2022 06:01:54 -0700
From:   Gal Pressman <gal@nvidia.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
CC:     <netdev@vger.kernel.org>, Saeed Mahameed <saeedm@nvidia.com>,
        Tariq Toukan <tariqt@nvidia.com>,
        John Fastabend <john.fastabend@gmail.com>,
        "Boris Pismenny" <borisp@nvidia.com>, Gal Pressman <gal@nvidia.com>
Subject: [PATCH net-next v2 0/4] Support 256 bit TLS keys with device offload
Date:   Tue, 20 Sep 2022 16:01:46 +0300
Message-ID: <20220920130150.3546-1-gal@nvidia.com>
X-Mailer: git-send-email 2.37.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN8NAM11FT058:EE_|BL1PR12MB5729:EE_
X-MS-Office365-Filtering-Correlation-Id: b030e789-3d0f-43b5-b8d8-08da9b085773
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: nit7VLFruXccmGRFGHfvI8NMLjByWyiyog1kLDvURHE04Ld+db958L4emEk/ZD7uOfdNrTc9Wkkq/wJyxZTXlVpjKh/1qXYvZrNWUayFvzZyEWaWg8EYe2sUMvWSvVsg+kQVMWBj9KaYgQFZy5/ObjMXbmFj8h+yWb+W4W8L1T+Wfja2jZmLkOhwnEWy0yGkm6fZN70ZEwSMeU/Uo0LbtmKC4IIqdW9CsOGHYpMK23ij5idVb8yBl69kypnKSJYyzYyrCo0dtQ0kLmmdyShf6JvZYV9/Z4n9KzAEgqTRk5sE9igZ5UFISuod/At72LNVT01553XA80vcstgwWvIZ9OI8ZWS8CmN3EKAdc6vLIZulqMuWAbJ4JHBmY4B5RR1j8CwcoW+/ydw1Opjwq2njdKxeu/GV2OzWEd2QUvubZf69esJIzSZKOMecf0DrqnBb3NNmU81TzaYexaTbbTB5FVfb4Lg8uGmhCsIHU1HqvylIHI46rakFtN6/T6tlmxL2PeD7gRt8HNIcTMfXn7Q3jvTKtrypa5sbhLJoShyiFy8ESNR13wCYhLyRkRiZ5eEdZCTqaUJi02xB/TdOCYxgEwQdVM1FwIgsfXWIm6oFFbj++AeygnkzxFjPkruQoUVkDI7vdv82iUt86QO8Hgk+reBoTjoyn9V/nZg5Mt8x+qdemcATa+QbrTqPdDP6YVzOMojtjIzSqOS/hDtdBqOXrzonuXfrnesuUQxNbPAup85RnN2h6wY0msXFetKzpHmrPYELWDMW8DvLm/jwLksy8JCrh5UOdW7Wn4jcbhrYzcWQTDjXyPzOyvLN7GCqonIKcDj5yPHo3WMLefXqCsEeGfaWQp1OCsd+EHfFwmDdo+0=
X-Forefront-Antispam-Report: CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230022)(4636009)(136003)(376002)(346002)(396003)(39860400002)(451199015)(36840700001)(40470700004)(46966006)(110136005)(70206006)(186003)(36860700001)(2616005)(86362001)(5660300002)(4326008)(47076005)(426003)(7636003)(478600001)(36756003)(40480700001)(40460700003)(8676002)(336012)(83380400001)(26005)(82740400003)(316002)(7696005)(82310400005)(2906002)(8936002)(6666004)(1076003)(966005)(107886003)(356005)(41300700001)(54906003)(70586007);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Sep 2022 13:02:15.3560
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: b030e789-3d0f-43b5-b8d8-08da9b085773
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT058.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR12MB5729
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hey,
This series adds support for 256 bit TLS keys with device offload, and a
cleanup patch to remove repeating code:
- Patches #1-2 add cipher sizes descriptors which allow reducing the
  amount of code duplications.
- Patch #3 allows 256 bit keys to be TX offloaded in the tls module (RX
  already supported).
- Patch #4 adds 256 bit keys support to the mlx5 driver.

Changelog -
v1->v2: https://lore.kernel.org/all/20220914090520.4170-1-gal@nvidia.com/
* Add a missing '=' in initializer
* Add missing unlocks in resync_handle_seq_match()

Thanks,
Gal

Gal Pressman (3):
  net/tls: Use cipher sizes structs
  net/tls: Support 256 bit keys with TX device offload
  net/mlx5e: Support 256 bit keys with kTLS device offload

Tariq Toukan (1):
  net/tls: Describe ciphers sizes by const structs

 .../mellanox/mlx5/core/en_accel/ktls.h        |  7 +-
 .../mellanox/mlx5/core/en_accel/ktls_rx.c     | 45 +++++++++--
 .../mellanox/mlx5/core/en_accel/ktls_tx.c     | 41 ++++++++--
 .../mellanox/mlx5/core/en_accel/ktls_txrx.c   | 27 ++++++-
 .../mellanox/mlx5/core/en_accel/ktls_utils.h  |  8 +-
 include/net/tls.h                             | 10 +++
 net/tls/tls_device.c                          | 61 ++++++++------
 net/tls/tls_device_fallback.c                 | 79 +++++++++++++------
 net/tls/tls_main.c                            | 17 ++++
 9 files changed, 227 insertions(+), 68 deletions(-)

-- 
2.25.1


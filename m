Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 35470520D65
	for <lists+netdev@lfdr.de>; Tue, 10 May 2022 07:58:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236873AbiEJGB6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 May 2022 02:01:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50188 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233186AbiEJGB5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 May 2022 02:01:57 -0400
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2073.outbound.protection.outlook.com [40.107.94.73])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A4A5A266E12
        for <netdev@vger.kernel.org>; Mon,  9 May 2022 22:58:00 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=UqVt2j2elJESk+0Z9IzN5AsUk4hCyaKzp8pAkgbsGz8dDgM/8QlbbuFieILmm49ZWDu4D0yZX0XNnfQPbW+aba3IV5kMFOEVbpcIGACgTr04vnKcG8dfZ7CDTeO0mi8ap367c4kBN2MM+Me3rABUN2MroVEIUd6kWOFPf8Y3OUwH5JkPU85aakTKGKEMsD1qmhCMRG/Jr52WNpvG6hD05YhWI7yPSPoWDfZlG8kx3L10a5+quH/8md3fyUchPQrQ0NC/pAbxThNuZgq3CV4rrw28R3H+8PG5GoPDLAsCo9FJ4h4A5O2X8w3c5iCnKbdguOSy0x2s+LeFDAVBMD/E0w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=1PJ1i4dOVkXZEBuCviExIFXgUPVxhaU5lBqyb/a0kAY=;
 b=SAQFe25SfkZdPoWDd5ML5P2Mg4aXIgfEFuxVW+u2t6RZfp0dZ7cpRO3XDQ31FCmO1prI9HTfHcZWERdrDHrOOlxQqDR2L4sS9JFZUKdRpod1TkcFrhRdc46kpR2OmGBiRM/RDl3IGCIS/jL9Q5TPHSNXUVJOs0kykBUNoicJFiJBKMo9R7XfIhspK7KHPTuG6KmLhtuNHTRSaq7SftZrNRTac9DPTkPegGv5rVJJky1nOeekokYO5o0vW2x0jQaQohZNdZhcDx4D3DW3gkadiBFoF/jiH9qAQpse9m1M3S10t4YhZ9EFIAXirekHpNCJGPAIWOrfHTm9UYS8RdTq5Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1PJ1i4dOVkXZEBuCviExIFXgUPVxhaU5lBqyb/a0kAY=;
 b=asLkUzQJO0o89KHxucK8BJNAhRt8sX8ERXPO5QNkI795qE5FXicFxJFWN+nPM09nE8qJzPeEzVo4epVRqNYFNZdsGOXwhNrDJAnrwppHynxPylKv7ZVZJGLgOBbsjzDLwID3cqjRcJ1RwmtyMMBvNzKlF1/1yB8pbwitO6b74RimHFeFsU+zTKtyqB/pKJ1p4IXVLLkTYUe/FqSiyirjmsSthY6JdAuFB+ReU3scBtXHntxJ4g1WUjSQA7u1owqN7A2667PtqJ/f5k/BXD9ZfrfS+oLtRnJ5NwVKQu31vbh7FPXx+7fJr3UngcDkmRWsPtWCA43Oj55UBBz4hU5iRg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from BY5PR12MB4209.namprd12.prod.outlook.com (2603:10b6:a03:20d::22)
 by CY5PR12MB6383.namprd12.prod.outlook.com (2603:10b6:930:3d::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5206.25; Tue, 10 May
 2022 05:57:59 +0000
Received: from BY5PR12MB4209.namprd12.prod.outlook.com
 ([fe80::bcda:499a:1cc1:abca]) by BY5PR12MB4209.namprd12.prod.outlook.com
 ([fe80::bcda:499a:1cc1:abca%4]) with mapi id 15.20.5227.023; Tue, 10 May 2022
 05:57:59 +0000
From:   Saeed Mahameed <saeedm@nvidia.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     netdev@vger.kernel.org, Saeed Mahameed <saeedm@nvidia.com>
Subject: [pull request][net-next 00/15] mlx5 updates 2022-05-09
Date:   Mon,  9 May 2022 22:57:28 -0700
Message-Id: <20220510055743.118828-1-saeedm@nvidia.com>
X-Mailer: git-send-email 2.35.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BYAPR02CA0046.namprd02.prod.outlook.com
 (2603:10b6:a03:54::23) To BY5PR12MB4209.namprd12.prod.outlook.com
 (2603:10b6:a03:20d::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: bc5c2c34-b72d-4cf4-7df7-08da324a093d
X-MS-TrafficTypeDiagnostic: CY5PR12MB6383:EE_
X-Microsoft-Antispam-PRVS: <CY5PR12MB638399B80F4EBC69A09F8F3EB3C99@CY5PR12MB6383.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: RFuvIg2sWzh6Fqn7kZI2o4SOAyUB0B9bVj/rV02CZaYH3zvfG7kjRIprMlrNVjWV5Yys2KrMFhVVnYSnKSXb8m97Rnk1LmvOzMdPTfGzzhKhm1xIDyT0U6VQJ8W3pfYmKl9TMomyGk6fJ75zFnhRwq1g1Zou02Ei3AacCbMaHmqFT9QNczjjQzXJGv3I18j70AV7xk8ZUrR033hfdi/ED5DhTPBoEG6mYfdNuQ6TvdFdN46D89835r7rudFB6gi5j08qvDVgWJraUpD6BQ5hTeKRLgWbj4icQpxQ5iCjMBxbrsn8CeYhlZ6tiX1SUlKZ2w1K8/yJMFuGghtM3365C56euw1eC2T1a8kgA0vBhgCmqVFtsAXqqE3DZeorvYQJhRubWyNkxxLqf0DPU7E1+hd7qRLjhxVDRUiMZMm7qLyYieSXoV41kW82v1FrIdcg+3ke2o/1sf0dvywdpCLCMUAuA8ZMQI/Qgnw9XW4H20SmWndCFYII9qaZIA2NwPG+eZusMqzAIKEq1mlvdcxn3ebZOWWbeEMqHrkP0E8n5hsW/5s9iPiHFwmCKjZ1PeLJuWjHiIyCR2bZTkDh5/dVrLdMJSfPWZGtt8axIme/uc1NvoJ8rRqC6/Ya2TpfGvWdM7QVMOCCZgbT9ozrfedWYg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR12MB4209.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(110136005)(316002)(8676002)(36756003)(2906002)(6506007)(107886003)(2616005)(1076003)(83380400001)(38100700002)(186003)(4326008)(8936002)(6486002)(15650500001)(5660300002)(508600001)(6666004)(66556008)(66946007)(66476007)(86362001)(6512007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?nSDUiwNN84MTZUpP3R7DOb0X1FzcFFAmdzg03ahKRNs2NB7W9cAy0jzA2mUC?=
 =?us-ascii?Q?yL5BZZ0RKzYj9zcJtsyHP49xZZMUzdIydJKFc9xXfPB3AGfxflN8m0dQ6m1A?=
 =?us-ascii?Q?THlfdW3l8RrrrIY1HygWkbg0qcKeyM0Zf6wzXpbeHIfAKSOWYBxcPYeS2gnn?=
 =?us-ascii?Q?cfPKYrCDEvC9VkcAA+Vh+ITWo8fwXliTQThi2hiPB3BqKuiDNUPYirb/JcMo?=
 =?us-ascii?Q?EuIDWvRbrAYy0LJdDc0U7w1ayzshcMUlpNZL7IpLKD+LZp9uO5KbaBeEBWOj?=
 =?us-ascii?Q?tA8o2RTZc3K71dv9CHgbn0V6TfsI+cm0J4vzArkmIaD4dk67AX46MG/nW7hL?=
 =?us-ascii?Q?mfDbzhGRsgpD5SJkjOWy49o4Ep+ktGAolv4bhLgacwTaxjKeTnYCuOXDJgZU?=
 =?us-ascii?Q?Dq/8lukRVk/WeHr/Z8phL/yQ2cninQahEHMcvz1FV3OfKaZzUxD07j6KTb2F?=
 =?us-ascii?Q?RInFVrDjdH2fgy1aSBcgXB0YBBFesS2M7RlfjX2h3Zhe7O4KcHPdjLnrqJqm?=
 =?us-ascii?Q?gLNjI3NzzF/VU6PK1jQWYSDd4sopi5Q7+4WsBZJLbOyXVWzRXmHY54KsE5lo?=
 =?us-ascii?Q?kbM+sj5xXMhb9V6UwXIonL0hu089trt3jy6Em+gy47QqjqWYylKX9lgqXbhQ?=
 =?us-ascii?Q?QEKBZ8yuzTixkOG9EFvKJx3tX5rgERExxOFgvjIhk/pqc41k0kzaqpekVChW?=
 =?us-ascii?Q?QP2gv8JWv2NcEXOx7yaviO8YauBiZXC/soHrpiJXlV/06AwL3YLDBAa1K2e/?=
 =?us-ascii?Q?13flakpqGnAe1oNBTfCInrK4byTVFV1vO9YobfEQlte6CZEKfIPBwsHXAdxI?=
 =?us-ascii?Q?+uyRgW0In/QFJMFpn8Ahsdh+e1gwTcN/ArfQ8FBTJGvpSjZp30XmBEmSNXy0?=
 =?us-ascii?Q?iHbL0H5YvIJEXaFtW5bHKhiuXULqCJZXyWsgPjWdu6aycHYwiv1ijPzc+bWb?=
 =?us-ascii?Q?YbUmR8vThqd7t+Lw7XKOcfXUseTgXf/Bd562zvzM/gZeNfP5j/SIKWAHfWBz?=
 =?us-ascii?Q?K9GPUHd2obpwIFfILK7NHQfi4EBbMpD6NehmD/3rUS6b8HCsEwRaCP43jGVH?=
 =?us-ascii?Q?HPCJRHsTkBcv/6SPSNfdo4YMa1kNU4NRxEA0wRRQEJkXLUnIYN40/bqeZHV9?=
 =?us-ascii?Q?YA0g94sgh3kvv13uqKPihaW1nqEX8gs/c4Bnb+EVgh90SLZ1r1N63j/z/7rJ?=
 =?us-ascii?Q?c2bGU0BVJWVIAE0cBiu/+OIoSyQOOBrrWwuxDjic2zWJq8KDuEnjLlb5WZ1C?=
 =?us-ascii?Q?wt5tCnbzPAuj3eD4fWVnm7grgnl/uXT7peBwMvUqu60dIAyw2ovPq3a3sSUE?=
 =?us-ascii?Q?kCWogGNE5fbe08qhr/gIbx2iaa7w/qgHaLf5VPZCce8dpzO3bd4kUP6iQnbT?=
 =?us-ascii?Q?c7ag1PUTGVoyOKcMp3c3oVY/mR3wePyuj7ynNnejnTMjPboIHqlBShJNWC6k?=
 =?us-ascii?Q?zVjqcFK/XgAVVD4dVqI1dwEEGmuba46GTfsxbxMf8jAxc9ojlp3Y7H+P9s2b?=
 =?us-ascii?Q?OmEmQAdJQRyAgqOcaYT7xnDGICGWTkugIc9cM/n8dyi0cRLRk/YjQlidbogf?=
 =?us-ascii?Q?aXDn1v7HOVCvl2RaXMSJrG1QADWF4gMSzKkXozFffo0GzFetVZCVTWThApb3?=
 =?us-ascii?Q?mYqErftWBTwICOwcIY9ydLquF+N7WJUjqhqFU7/FlO1GeyaQQI6phEplKR9w?=
 =?us-ascii?Q?47KM6iIyp3HG6IAYFXEgjai+2BCjkEaX40P8pUhEgnSGrRS+/fHWyMEmUvsI?=
 =?us-ascii?Q?65RbkG73YKBBa1nwGYoLG8gTDKK1WyM=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bc5c2c34-b72d-4cf4-7df7-08da324a093d
X-MS-Exchange-CrossTenant-AuthSource: BY5PR12MB4209.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 May 2022 05:57:59.2070
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: TtvdD4Mys/TAtBMM4nAcCXC+woxrFwdxOBF2F6TfbI03ydDAdtNJb2Z1QWei1A9iTR4uoNRyPp36HtayRELbAg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY5PR12MB6383
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This series adds the support for 4 ports HCAs LAG mode in mlx5 driver.
For more information please see tag log below.

Please pull and let me know if there is any problem.

Thanks,
Saeed.


The following changes since commit 9eab75d45ddc9d29640fd17199880d39241eeb35:

  Merge branch 'nfp-support-corigine-pcie-vendor-id' (2022-05-09 18:20:42 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/saeed/linux.git tags/mlx5-updates-2022-05-09

for you to fetch changes up to 7f46a0b7327ae261f9981888708dbca22c283900:

  net/mlx5: Lag, add debugfs to query hardware lag state (2022-05-09 22:54:04 -0700)

----------------------------------------------------------------
mlx5-updates-2022-05-09

1) Gavin Li, adds exit route from waiting for FW init on device boot and
   increases FW init timeout on health recovery flow

2) Support 4 ports HCAs LAG mode

Mark Bloch Says:
================

This series adds to mlx5 drivers support for 4 ports HCAs.
Starting with ConnectX-7 HCAs with 4 ports are possible.

As most driver parts aren't affected by such configuration most driver
code is unchanged.

Specially the only affected areas are:
- Lag
- Devcom
- Merged E-Switch
- Single FDB E-Switch

Lag was chosen to be converted first. Creating hardware LAG when all 4
ports are added to the same bond device.

Devom, merge E-Switch and single FDB E-Switch, are marked as supporting
only 2 ports HCAs and future patches will add support for 4 ports HCAs.

In order to activate the hardware lag a user can execute the:

ip link add bond0 type bond
ip link set bond0 type bond miimon 100 mode 2
ip link set eth2 master bond0
ip link set eth3 master bond0
ip link set eth4 master bond0
ip link set eth5 master bond0

Where eth2, eth3, eth4 and eth5 are the PFs of the same HCA.

================

----------------------------------------------------------------
Gavin Li (2):
      net/mlx5: Add exit route when waiting for FW
      net/mlx5: Increase FW pre-init timeout for health recovery

Mark Bloch (13):
      net/mlx5: Lag, expose number of lag ports
      net/mlx5: devcom only supports 2 ports
      net/mlx5: Lag, move E-Switch prerequisite check into lag code
      net/mlx5: Lag, use lag lock
      net/mlx5: Lag, filter non compatible devices
      net/mlx5: Lag, store number of ports inside lag object
      net/mlx5: Lag, support single FDB only on 2 ports
      net/mlx5: Lag, use hash when in roce lag on 4 ports
      net/mlx5: Lag, use actual number of lag ports
      net/mlx5: Support devices with more than 2 ports
      net/mlx5: Lag, refactor dmesg print
      net/mlx5: Lag, use buckets in hash mode
      net/mlx5: Lag, add debugfs to query hardware lag state

 drivers/infiniband/hw/mlx5/gsi.c                   |   2 +-
 drivers/infiniband/hw/mlx5/main.c                  |   1 +
 drivers/infiniband/hw/mlx5/mlx5_ib.h               |   1 +
 drivers/infiniband/hw/mlx5/qp.c                    |   2 +-
 drivers/net/ethernet/mellanox/mlx5/core/Makefile   |   2 +-
 drivers/net/ethernet/mellanox/mlx5/core/dev.c      |  49 +-
 drivers/net/ethernet/mellanox/mlx5/core/devlink.c  |   4 +-
 drivers/net/ethernet/mellanox/mlx5/core/eswitch.c  |  25 -
 drivers/net/ethernet/mellanox/mlx5/core/eswitch.h  |   8 -
 drivers/net/ethernet/mellanox/mlx5/core/fw_reset.c |   2 +-
 .../net/ethernet/mellanox/mlx5/core/lag/debugfs.c  | 173 +++++++
 drivers/net/ethernet/mellanox/mlx5/core/lag/lag.c  | 537 ++++++++++++++-------
 drivers/net/ethernet/mellanox/mlx5/core/lag/lag.h  |  16 +-
 .../net/ethernet/mellanox/mlx5/core/lag/port_sel.c | 129 +++--
 .../net/ethernet/mellanox/mlx5/core/lag/port_sel.h |  15 +-
 .../net/ethernet/mellanox/mlx5/core/lib/devcom.c   |  16 +-
 .../net/ethernet/mellanox/mlx5/core/lib/devcom.h   |   2 +
 drivers/net/ethernet/mellanox/mlx5/core/lib/tout.c |   1 +
 drivers/net/ethernet/mellanox/mlx5/core/lib/tout.h |   1 +
 drivers/net/ethernet/mellanox/mlx5/core/main.c     |  28 +-
 .../net/ethernet/mellanox/mlx5/core/mlx5_core.h    |   3 +-
 include/linux/mlx5/driver.h                        |   5 +-
 22 files changed, 720 insertions(+), 302 deletions(-)
 create mode 100644 drivers/net/ethernet/mellanox/mlx5/core/lag/debugfs.c

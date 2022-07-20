Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 385D657BDC3
	for <lists+netdev@lfdr.de>; Wed, 20 Jul 2022 20:30:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234710AbiGTSaE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Jul 2022 14:30:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47398 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234607AbiGTSaD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 Jul 2022 14:30:03 -0400
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2056.outbound.protection.outlook.com [40.107.220.56])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C6C4F4A834
        for <netdev@vger.kernel.org>; Wed, 20 Jul 2022 11:30:01 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=C9FV/xOxvBGrBwvfTqtQ2FqsQwDQioYIUbuTepEuXcqem3wyI2afZOt3L/kj2u4ozBeZPCLmoRMtD8H2cR/7Q22M4bhZyweZHcw/rmoLWYeTRX7Qp4PAu1MQAbgafAhjyXwo8OWBBWEzPAOwFFGrBsenyZTOC5sEmHcxzgVIo3+WmKD4gC8mjcDodVY41kzr1UZH1KTUPj671W0Se+eHu55Ws4/XKcQKaPp8WJhq+7Iy+kmNjsMto9hEX5xfVLoEhI6HkeHIJ16RdjAQDBxGDnmhPPPPPXrwTqSIFcAlPsAnlOpRb2ScEvOxHDCZMJwt9TN9rVgvGmZHpH/JIdWJ3Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=82XJrUX7WGfQrtV9/NBXxENEMzvXjc2Y5QVoA8xC8/s=;
 b=Mw3X3CgYJTPr6kMagbq96PeDeQMlyQwqbdCPKiU/dLObwd3kLa/oBnkGuk5ak4GzCm3NliKM8Qjt8q6jbHYmtg5JandwDjI79oPPFyrh7FpIF1RtdLVmjQNurZ3vDHxvvn1HfFP5d6Fl6uIkl2oamXwARR3/LgvFAWLyEWxaJ1iUGhmjiyY+lGS3frDTLqbXmRa/YKMsozSFTcyVHRYY2PcGGDV2UrkIqL/5yeuflBDVSZ1IaTCSjMKW9IU4JfQJ8e2368T8akDu717d55ULq1XkDaFXBo7NTl3FZ5LJjk5QPmIabV1r8+NdOG4L8cIsDCQ/5guOwWRg8t9VG+gyTA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=davemloft.net smtp.mailfrom=amd.com;
 dmarc=fail (p=none sp=none pct=100) action=none header.from=xilinx.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector1-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=82XJrUX7WGfQrtV9/NBXxENEMzvXjc2Y5QVoA8xC8/s=;
 b=DLnQnWDjj7StyhUJapRTVD5T8Xrqk1e/PGURMCxnTfb1iXtJ9zsNL7njS2HcZe0pb223bVDRcWr6O4AT6YDWr6HlMgSnL/pDBpVT0QTyWdTDgnyPbenTDaDwnSxGKp3D0I8Olr5aXcybi6JvlVQ9lxJmHF0hxov7hmGLlq8rfsTxWGZof6l5Ql7gbpAEANua6nC4jOXpq5xRBZj8eKtI36jIz1cTjnuCtcZ2VgMiiwBK9fDgWuBhmzQGrt8T/b60oNcG7WHDYfadb1Ych4ic3xo9H0osK0WwXO4r7Vp+uBlAi2pYxeN70oYjJlblExVwjxpprDHRjV47JMf8kkFirw==
Received: from DM6PR07CA0042.namprd07.prod.outlook.com (2603:10b6:5:74::19) by
 CH2PR12MB4891.namprd12.prod.outlook.com (2603:10b6:610:36::9) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5458.18; Wed, 20 Jul 2022 18:30:00 +0000
Received: from DM6NAM11FT023.eop-nam11.prod.protection.outlook.com
 (2603:10b6:5:74:cafe::88) by DM6PR07CA0042.outlook.office365.com
 (2603:10b6:5:74::19) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5438.23 via Frontend
 Transport; Wed, 20 Jul 2022 18:29:59 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=fail action=none header.from=xilinx.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 DM6NAM11FT023.mail.protection.outlook.com (10.13.173.96) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.5458.17 via Frontend Transport; Wed, 20 Jul 2022 18:29:59 +0000
Received: from SATLEXMB08.amd.com (10.181.40.132) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.28; Wed, 20 Jul
 2022 13:29:58 -0500
Received: from SATLEXMB04.amd.com (10.181.40.145) by SATLEXMB08.amd.com
 (10.181.40.132) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.28; Wed, 20 Jul
 2022 11:29:58 -0700
Received: from xcbecree41x.xilinx.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.28 via Frontend
 Transport; Wed, 20 Jul 2022 13:29:57 -0500
From:   <ecree@xilinx.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <pabeni@redhat.com>,
        <linux-net-drivers@amd.com>
CC:     <netdev@vger.kernel.org>, Edward Cree <ecree.xilinx@gmail.com>
Subject: [PATCH v3 net-next 0/9] sfc: VF representors for EF100
Date:   Wed, 20 Jul 2022 19:29:23 +0100
Message-ID: <cover.1658341691.git.ecree.xilinx@gmail.com>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: d54267f6-9866-4ab8-7491-08da6a7dda91
X-MS-TrafficTypeDiagnostic: CH2PR12MB4891:EE_
X-MS-Exchange-SenderADCheck: 0
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: I5A8zrMmJ7DFzmvvgN/gcmGFzGeqIHfCcw0xbv6kxn5Bahs1eq+CzeTahmy+lcMFc2o8udt0KpQBk3sV5NWNQRpEwbxITxin0/fnzAQRBFkaV7hvZx3NA6CpMclMOCTs5BCsjxzNWQus+ZZZ+sHuzNcKnRBVCvW77I8uJ4pr1avNTpB/nsfSypk/qhDQmfIfDfX3itwTu0aGigLEmxx5DCuGSqLa3XondihTTz9HtzgmR1vTSJWXBQn2ejJRGUNe0E7Vz5MEWbk7k31r16zbwE4CwwPnoivVgSEYojigRQv0czPkblDmj4VT2DFzVKSmhmVvLk9bjklUZc8NSVwOsr+QAEQGk53ZDytMgEFLlb9CvbBLM7zZk3rS8YtJWy3VJpLjYBkjYSomaSfwDqGPeS9GF5H7xeY4rbw6u8fyX/f4ty6n/3ast9Ft7gc+xn5lTr65NFX9mx7d3eKSoBm3eyYQ4C55e5doJWjxh7KHoXioBmxKZuGzWyv9MGFKIn+mmLgF5Frtam6/y72qOv1EpEyPMcpdWQw7CkmLp3yr1fqMjDyK+5w5hrimfCpRwG44/hrCwI4Kwf4OqkGD7C8hytx2X6aE9f+Nhxuqr2Enjjsm3VmFVDPblxp6/WHd8aXdHbMg6Kezi7s0o00uo6Dpiaa3lHXQyp/8cGCpRUGE5rv3CeVRKRalWBT950sULbcO5sscTslA/OJkf1bsMrlNOAiN9lpGkmXEk9IfhUuPBaGGkPQA0pVPvRtkY6NFSptcOQRNpcfYNWV77Fb7oSw14QvNkFshWEQkMv6v7Cz7w8AbHH/YKfMmpQUL1hci0cthSTj49waYJIyweOTxExrJsg==
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230016)(4636009)(39860400002)(346002)(396003)(136003)(376002)(36840700001)(40470700004)(46966006)(36860700001)(36756003)(82310400005)(41300700001)(55446002)(2876002)(6666004)(26005)(478600001)(40480700001)(356005)(2906002)(8936002)(110136005)(83170400001)(70206006)(5660300002)(9686003)(40460700003)(186003)(47076005)(42882007)(83380400001)(70586007)(54906003)(336012)(316002)(81166007)(82740400003)(8676002)(4326008)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Jul 2022 18:29:59.5674
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: d54267f6-9866-4ab8-7491-08da6a7dda91
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT023.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR12MB4891
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

This series adds representor netdevices for EF100 VFs, as a step towards
 supporting TC offload and vDPA usecases in future patches.
In this first series is basic netdevice creation and packet TX; the
 following series will add the RX path.

v3: dropped massive mcdi_pcol.h patch which was applied separately.
v2: converted comments on struct efx_nic members added in patch #4 to
 kernel-doc (Jakub).  While at it, also gave struct efx_rep its own kdoc
 since several members had comments on them.

Edward Cree (9):
  sfc: update EF100 register descriptions
  sfc: detect ef100 MAE admin privilege/capability at probe time
  sfc: add skeleton ef100 VF representors
  sfc: add basic ethtool ops to ef100 reps
  sfc: phys port/switch identification for ef100 reps
  sfc: determine representee m-port for EF100 representors
  sfc: support passing a representor to the EF100 TX path
  sfc: hook up ef100 representor TX
  sfc: attach/detach EF100 representors along with their owning PF

 drivers/net/ethernet/sfc/Makefile       |   2 +-
 drivers/net/ethernet/sfc/ef100_netdev.c |  16 +-
 drivers/net/ethernet/sfc/ef100_netdev.h |   5 +
 drivers/net/ethernet/sfc/ef100_nic.c    |   7 +
 drivers/net/ethernet/sfc/ef100_nic.h    |   1 +
 drivers/net/ethernet/sfc/ef100_regs.h   |  83 +++++---
 drivers/net/ethernet/sfc/ef100_rep.c    | 244 ++++++++++++++++++++++++
 drivers/net/ethernet/sfc/ef100_rep.h    |  49 +++++
 drivers/net/ethernet/sfc/ef100_sriov.c  |  32 +++-
 drivers/net/ethernet/sfc/ef100_sriov.h  |   2 +-
 drivers/net/ethernet/sfc/ef100_tx.c     |  84 +++++++-
 drivers/net/ethernet/sfc/ef100_tx.h     |   3 +
 drivers/net/ethernet/sfc/efx.h          |   9 +-
 drivers/net/ethernet/sfc/efx_common.c   |  38 ++++
 drivers/net/ethernet/sfc/efx_common.h   |   3 +
 drivers/net/ethernet/sfc/mae.c          |  44 +++++
 drivers/net/ethernet/sfc/mae.h          |  22 +++
 drivers/net/ethernet/sfc/mcdi.c         |  46 +++++
 drivers/net/ethernet/sfc/mcdi.h         |   1 +
 drivers/net/ethernet/sfc/net_driver.h   |   5 +
 drivers/net/ethernet/sfc/tx.c           |   6 +-
 drivers/net/ethernet/sfc/tx_common.c    |  35 +++-
 drivers/net/ethernet/sfc/tx_common.h    |   3 +-
 23 files changed, 687 insertions(+), 53 deletions(-)
 create mode 100644 drivers/net/ethernet/sfc/ef100_rep.c
 create mode 100644 drivers/net/ethernet/sfc/ef100_rep.h
 create mode 100644 drivers/net/ethernet/sfc/mae.c
 create mode 100644 drivers/net/ethernet/sfc/mae.h


Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D45C16DE3D9
	for <lists+netdev@lfdr.de>; Tue, 11 Apr 2023 20:27:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229825AbjDKS1a (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 Apr 2023 14:27:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47674 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229692AbjDKS12 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 11 Apr 2023 14:27:28 -0400
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2051.outbound.protection.outlook.com [40.107.220.51])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 205AB46BB
        for <netdev@vger.kernel.org>; Tue, 11 Apr 2023 11:27:27 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DrT7VwYdIZnJrr47IKiEd427HJcLRyCG5iAKztAd1beXANK/0t9lhNlnkM5sHQWszudbgWdyviQXPGmabI0quE++jDwlPeMBLjfQOFUlaJNXdYXcNqCSoY778sEg4VkPNJuXSGIX4pZ0qUF3fgKeGcHpSGP0Gxrkzsw67Vhm/gFjtH5GI6NYSnRXDNf3h8IYiQqOVoJi5qb+LFRj54VmhL7lZG6iwUmGhx8EyGFf2Zr3CNXhzUp1GRnYEkr9JH/CzNBkwEgDxgPqpsX/+irkiBT80XgbA9oKYEkSFm0kYOR67Sh3PswAED+0MOwZlBbSMulfKlYpxsOBhjJbvXPTMw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=gJ8gJzZy/zBkmHzr5Jlzm7IbNkeuDu53FPBljR+TnnM=;
 b=S0EYi34mPCcEVZIJ94Rm07wfbXDV/W23/HWfojDIb9jxB3LMlLl3cdcTieNwJPimwWvz0fNgdDhoJjtp7hfBcsnXV02oz7v5UxzioJ+tzhsTsk9vdAgqdC00/dnAXZ4BDG8IeKRxK9/xzW9NTBN933wk6YDoi9DkOpICm7jP7/MlkQ1m8xyukOiL7UylQ6iTU5tZSuT/n3F5K2UwsUYm4L3XqHzlL8RCFZTchkHGZSNatrI1DYZj+qWyqNvalqanKCjcdXh2B1FxjuP8dERapnck2wrQlwJsJRKeXV6Km3XuhfKO8aeEafZNXrlcObSKYocVzzM7t1HOJ1Y2SMZ4Ow==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=davemloft.net smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gJ8gJzZy/zBkmHzr5Jlzm7IbNkeuDu53FPBljR+TnnM=;
 b=wOPG7hqN1xXLeqGRpxt9WVpCn2d1165LS3BHrYI2IUdVde9n2NPk7e/42COSYzyqiQ+1XJKH7B3O3hJfaGIvmiJZCrhT75NvnOGPikfpm85hpnHYak8fI81f9/TOf6WnMDfwf+9sz46DzT3j6twib2e5F1uvvQ0mfKXvcv6QDxk=
Received: from MW4PR04CA0226.namprd04.prod.outlook.com (2603:10b6:303:87::21)
 by SN7PR12MB6909.namprd12.prod.outlook.com (2603:10b6:806:263::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6277.38; Tue, 11 Apr
 2023 18:27:22 +0000
Received: from CO1NAM11FT019.eop-nam11.prod.protection.outlook.com
 (2603:10b6:303:87:cafe::e8) by MW4PR04CA0226.outlook.office365.com
 (2603:10b6:303:87::21) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6277.40 via Frontend
 Transport; Tue, 11 Apr 2023 18:27:22 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 CO1NAM11FT019.mail.protection.outlook.com (10.13.175.57) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.6298.28 via Frontend Transport; Tue, 11 Apr 2023 18:27:22 +0000
Received: from SATLEXMB03.amd.com (10.181.40.144) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Tue, 11 Apr
 2023 13:27:21 -0500
Received: from xcbecree41x.xilinx.com (10.180.168.240) by SATLEXMB03.amd.com
 (10.181.40.144) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34 via Frontend
 Transport; Tue, 11 Apr 2023 13:27:20 -0500
From:   <edward.cree@amd.com>
To:     <linux-net-drivers@amd.com>, <davem@davemloft.net>,
        <kuba@kernel.org>, <pabeni@redhat.com>, <edumazet@google.com>
CC:     Edward Cree <ecree.xilinx@gmail.com>, <netdev@vger.kernel.org>,
        <habetsm.xilinx@gmail.com>, <sudheer.mogilappagari@intel.com>
Subject: [RFC PATCH v2 net-next 0/7] ethtool: track custom RSS contexts in the core
Date:   Tue, 11 Apr 2023 19:26:08 +0100
Message-ID: <cover.1681236653.git.ecree.xilinx@gmail.com>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO1NAM11FT019:EE_|SN7PR12MB6909:EE_
X-MS-Office365-Filtering-Correlation-Id: 03811302-c16b-4798-a181-08db3aba6454
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: xylFWkMu7Vqc5FcFiuME9R2mnfVfk/nddMrk5ae4lvoVu4IIHJUM46fpuu+8sJ1aNoqDEsCbJFh9ExzCfKIyWV2GFPTPBboy3EqznWGHpS310266DMsSIcb6FWyfhSQp+OrRWFXMCAEifmcpTYLP+OuP5SPhuxYuVDzu5d7UfcdiAxjVZ+xKcS95l3jvRtgCYbz283WBmda6D6iTpoO3DBfIZ1GflOHFgzKHgLAiaW6hm/OiVQ9D6xIBIp+d4DKId163hJBYqibst4GIMcMO17boweeusIzPQUqL5EFMtJISv69VDYSiS9DelFt2Xed9hF86NVyZHTHqe63kDUtPUFfbtOrvFywG2qHnO8cTyYRe9WwIWFEdbvW0MXomZPVox/djZJLTcfU8YgsOacwjyfY807ni3LWXtGUzzJTfVNq9J5oDW6RSwt8dRYESt58FSmlpAwqwh/LJkCIdslzH5fGMiK40FPIYJi4tdt+fVWTAgWhV1Xr/nzzDIMo0TlB3CRycX4INAT0FKS3xBMFuWoNnSwaVVc2nQmLjkixdyrvTyV8Fh6nv3z38ZLfKHu96HRlLwlBMalb4M2pqcjEKri8dvap4pUQQJaeihRgYYSvYlmWJ2nNABnx1G62u76/RLGn3sVYU1efhngVeusEWJb4jIB6jw577ZwiZohxUWnWvPqeTTMX3NE7osGXFkpL2YhsoClMLld1YpzB+fAYUzKaqUazglE3nFDgW1isLPCo=
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230028)(4636009)(346002)(376002)(39860400002)(396003)(136003)(451199021)(36840700001)(40470700004)(46966006)(55446002)(36756003)(86362001)(41300700001)(110136005)(316002)(8676002)(54906003)(70586007)(4326008)(70206006)(478600001)(82310400005)(5660300002)(40480700001)(36860700001)(2906002)(8936002)(2876002)(356005)(186003)(81166007)(82740400003)(6666004)(26005)(9686003)(426003)(336012)(83380400001)(47076005)(40460700003)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Apr 2023 18:27:22.3090
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 03811302-c16b-4798-a181-08db3aba6454
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT019.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR12MB6909
X-Spam-Status: No, score=0.8 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Edward Cree <ecree.xilinx@gmail.com>

Make the core responsible for tracking the set of custom RSS contexts,
 their IDs, indirection tables, hash keys, and hash functions; this
 lets us get rid of duplicative code in drivers, and will allow us to
 support netlink dumps later.

This series only moves the sfc EF10 & EF100 driver over to the new API; if
 the design is approved of, I plan to post a follow-up series to convert the
 other drivers and remove the legacy API.  (However, I don't have hardware
 for the drivers besides sfc, so I won't be able to test those myself.)

Edward Cree (7):
  net: move ethtool-related netdev state into its own struct
  net: ethtool: attach an IDR of custom RSS contexts to a netdevice
  net: ethtool: record custom RSS contexts in the IDR
  net: ethtool: let the core choose RSS context IDs
  net: ethtool: add an extack parameter to new rxfh_context APIs
  net: ethtool: add a mutex protecting RSS contexts
  sfc: use new rxfh_context API

 drivers/net/ethernet/realtek/r8169_main.c |   4 +-
 drivers/net/ethernet/sfc/ef10.c           |   2 +-
 drivers/net/ethernet/sfc/ef100_ethtool.c  |   5 +-
 drivers/net/ethernet/sfc/efx.c            |   2 +-
 drivers/net/ethernet/sfc/efx.h            |   2 +-
 drivers/net/ethernet/sfc/efx_common.c     |  10 +-
 drivers/net/ethernet/sfc/ethtool.c        |   5 +-
 drivers/net/ethernet/sfc/ethtool_common.c | 147 +++++++++++++---------
 drivers/net/ethernet/sfc/ethtool_common.h |  18 ++-
 drivers/net/ethernet/sfc/mcdi_filters.c   | 133 ++++++++++----------
 drivers/net/ethernet/sfc/mcdi_filters.h   |   8 +-
 drivers/net/ethernet/sfc/net_driver.h     |  28 ++---
 drivers/net/ethernet/sfc/rx_common.c      |  64 ++--------
 drivers/net/ethernet/sfc/rx_common.h      |   8 +-
 drivers/net/phy/phy.c                     |   2 +-
 drivers/net/phy/phy_device.c              |   4 +-
 drivers/net/phy/phylink.c                 |   2 +-
 include/linux/ethtool.h                   | 109 +++++++++++++++-
 include/linux/netdevice.h                 |   7 +-
 net/core/dev.c                            |  38 ++++++
 net/ethtool/ioctl.c                       | 124 ++++++++++++++++--
 net/ethtool/wol.c                         |   2 +-
 22 files changed, 484 insertions(+), 240 deletions(-)


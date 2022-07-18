Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C97AC578669
	for <lists+netdev@lfdr.de>; Mon, 18 Jul 2022 17:31:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234141AbiGRPbH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Jul 2022 11:31:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44992 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231340AbiGRPbG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 Jul 2022 11:31:06 -0400
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2051.outbound.protection.outlook.com [40.107.93.51])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 83C08208
        for <netdev@vger.kernel.org>; Mon, 18 Jul 2022 08:31:03 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=OdhjygAw3SXJIdthVYASsz0o6RGvU0PtpDki12CgE7oEgnl2uzXum8/i3dOfH4UYllfH4OC94TmSuiecOunrw7zFYQLm3CSEPw++2Y9oXdo/IE+8zXrOL8FqX+BW9pmqGgtbwSEBZAbt0EvSagi7DkEcGpY5kV7Apw1tgVdpJ0tI2oaANGaNF6/nTNAXDBaVmiWbsvcAYvFzC1t0BUJgwM0TvbsIl9Ma8YIA2E2A2bRi4Afx4Gn27xjn7VFVATL77wFBDJVL88E45P9H3eCjNy8tgrINTPq+J0sZ9FX9d8w2lM6ypCXzJVsVj/rftLgpP2AJK/9tUSuTRuzu+f4SpA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=FYF8OEg815CZ8cIYPlMoYUUfXU5oQilzvkXvyQuBL18=;
 b=K1kO2c16C71fcJJN3wee7SY4mjuoQx5hE/x+WJdA/VY3AAcNSwcF66HHkRezuSQ53xSIkvs3m4r6GuPadqL+c7I16RBeRlU0gEQgrU4kDSPqkJx/zgU5EWhcNy01NOKueKf1pLfFTB/lfrKZEScWMEEk3MM6H6XQo3y8gw5bWrdvuP5bYPB0+lsj4uhSkR65Y95Ak+yYFQRF48651Kl1ZSOI+iADpT0h7MqWQ6T3f1dP7Eu1bI1tQavDQMw9FbXoeNS6rS5uPoN033uNjjVfo+ZPSscAEnBNqMv/uaiD4EeA1gvmHrwrLKg8OlWZXejjxZ+39+ucya0weJjEf/nVHg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=davemloft.net smtp.mailfrom=amd.com;
 dmarc=fail (p=none sp=none pct=100) action=none header.from=xilinx.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector1-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=FYF8OEg815CZ8cIYPlMoYUUfXU5oQilzvkXvyQuBL18=;
 b=zaeROrYz2S44O0DCytIO9YjshhoM0929nyp/mC3gdSBvJe6E11XiWfVea2RE0NyryvoPh6wAEG3f4/jgqp8FdHfz+Cu4H2ke2eBZMAALcG2zbHuMlWdtWtDEQhkjpiPkBSDvh3dHkGl6NMsu2Ld3CvL6qQLLfgohZEI+1JJv4mfpwEbTq5V3zoK0ALmzybPVpgBqgrYanm+gUU3XyY4TTbIKw3G3KkcYrVcxmR8pw+F84Fx2kG98VwyYkglbtmcCKAVxAmdXlu9vmFRnljWmQMTOqOs8iaG/12L04U+jdrOKGbfYyy5HtCEtCIQwuwPdez1xELzJSlTHkoZYepGeyg==
Received: from BN7PR06CA0067.namprd06.prod.outlook.com (2603:10b6:408:34::44)
 by CH2PR12MB4325.namprd12.prod.outlook.com (2603:10b6:610:a9::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5438.15; Mon, 18 Jul
 2022 15:31:01 +0000
Received: from BN8NAM11FT030.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:34:cafe::5e) by BN7PR06CA0067.outlook.office365.com
 (2603:10b6:408:34::44) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5438.14 via Frontend
 Transport; Mon, 18 Jul 2022 15:31:01 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=fail action=none header.from=xilinx.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB03.amd.com; pr=C
Received: from SATLEXMB03.amd.com (165.204.84.17) by
 BN8NAM11FT030.mail.protection.outlook.com (10.13.177.146) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.5438.12 via Frontend Transport; Mon, 18 Jul 2022 15:31:01 +0000
Received: from SATLEXMB03.amd.com (10.181.40.144) by SATLEXMB03.amd.com
 (10.181.40.144) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.28; Mon, 18 Jul
 2022 10:31:00 -0500
Received: from xcbecree41x.xilinx.com (10.180.168.240) by SATLEXMB03.amd.com
 (10.181.40.144) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.28 via Frontend
 Transport; Mon, 18 Jul 2022 10:30:59 -0500
From:   <ecree@xilinx.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <pabeni@redhat.com>,
        <linux-net-drivers@amd.com>
CC:     <netdev@vger.kernel.org>, Edward Cree <ecree.xilinx@gmail.com>
Subject: [PATCH v2 net-next 00/10] sfc: VF representors for EF100
Date:   Mon, 18 Jul 2022 16:30:06 +0100
Message-ID: <cover.1658158016.git.ecree.xilinx@gmail.com>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 7a85b4b6-e25e-4e8d-6e13-08da68d2851c
X-MS-TrafficTypeDiagnostic: CH2PR12MB4325:EE_
X-MS-Exchange-SenderADCheck: 0
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: shkfKd9yx3N3qWTvFWZMeS0rOwrllVwnUb0IeGdA6jvehfC1Eer2QbnhvlXaHX7h+ZnDbTf7cISsUqm8y9ZtMhy5eW5HhEUig2lLJneZ1V7HgBEmKGZy7qt5i2c4LCmdZe0Yg5ROWn+/Yms2Ou6aCME7e66EbroateTXeSXZ6jKQSomC5vMvRZz5Dn3ubNMPX7ctMEkF8fq2T+Y1dFu0KEboJmhCjkYtgLVqAH52Bh5CnHJpJqqCmnblPNDNRHjX4E5A7AfJNl+tSx1zjslzVGbfEKp3O7pbt9YyU8Ww1hk0nWGoNzGnaJd4j38PCBRGNcCMk6TI5hp8ffmakuoyVOKHmrKXDKADgudw281rXUzrbPJkqQuMOk8igwGPPIhz1fMwnbgEmZpLkzToJVlHDUVw/X5rdknhMD6YenbGISFci0uQlyonj6+rwuBanOdnwF5wEFKT5U+Lp/h6hEAaPGIy10Rr598SohaBPFFSvt1EruZPozt2B8DBtOCi7v6N609FTJZDFeN5eeDwknieACS2BKuiYe7OTUFGvIS9kHGSukNkvSQMnBFxdafGE3TPqtloxW6kEh0gtcPz6kIWqzb7hYe3rKaZS2wDwhJ23Z6ROHpRqoGpdXHVI5MTbsSULN3TNWSNuDx2GameCgUgIjPY8H7KhqSdsWPEJDBVau3PHm8SdlX4/a4fResPBlDYfxOpK1ZxR03bZV6Cvc3T2ImBrKqKlrZm3XYygpBfg1BzCMLtFDcuvItQ3Uuvuqc8KzlzI38zBDLkx4pZAiMkNPLpHtVXtxFTEjPe1+wkCaWw3NlKY6gVkNYS1ZrT07rI5db+cMvJzSchEleMLEjd/NZjYGPOPy/7nd9/y3TUPZY=
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB03.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230016)(4636009)(396003)(39860400002)(346002)(376002)(136003)(40470700004)(36840700001)(46966006)(2876002)(4326008)(8936002)(70206006)(8676002)(70586007)(55446002)(36756003)(83170400001)(110136005)(82740400003)(40460700003)(356005)(54906003)(316002)(83380400001)(6666004)(41300700001)(9686003)(186003)(42882007)(478600001)(47076005)(336012)(82310400005)(81166007)(40480700001)(5660300002)(2906002)(36860700001)(26005)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Jul 2022 15:31:01.1375
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 7a85b4b6-e25e-4e8d-6e13-08da68d2851c
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB03.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT030.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR12MB4325
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

v2: converted comments on struct efx_nic members added in patch #4 to
 kernel-doc (Jakub).  While at it, also gave struct efx_rep its own kdoc
 since several members had comments on them.

Edward Cree (10):
  sfc: update MCDI protocol headers
  sfc: update EF100 register descriptions
  sfc: detect ef100 MAE admin privilege/capability at probe time
  sfc: add skeleton ef100 VF representors
  sfc: add basic ethtool ops to ef100 reps
  sfc: phys port/switch identification for ef100 reps
  sfc: determine representee m-port for EF100 representors
  sfc: support passing a representor to the EF100 TX path
  sfc: hook up ef100 representor TX
  sfc: attach/detach EF100 representors along with their owning PF

 drivers/net/ethernet/sfc/Makefile       |    2 +-
 drivers/net/ethernet/sfc/ef100_netdev.c |   16 +-
 drivers/net/ethernet/sfc/ef100_netdev.h |    5 +
 drivers/net/ethernet/sfc/ef100_nic.c    |    7 +
 drivers/net/ethernet/sfc/ef100_nic.h    |    1 +
 drivers/net/ethernet/sfc/ef100_regs.h   |   83 +-
 drivers/net/ethernet/sfc/ef100_rep.c    |  244 +
 drivers/net/ethernet/sfc/ef100_rep.h    |   49 +
 drivers/net/ethernet/sfc/ef100_sriov.c  |   32 +-
 drivers/net/ethernet/sfc/ef100_sriov.h  |    2 +-
 drivers/net/ethernet/sfc/ef100_tx.c     |   84 +-
 drivers/net/ethernet/sfc/ef100_tx.h     |    3 +
 drivers/net/ethernet/sfc/efx.h          |    9 +-
 drivers/net/ethernet/sfc/efx_common.c   |   38 +
 drivers/net/ethernet/sfc/efx_common.h   |    3 +
 drivers/net/ethernet/sfc/mae.c          |   44 +
 drivers/net/ethernet/sfc/mae.h          |   22 +
 drivers/net/ethernet/sfc/mcdi.c         |   46 +
 drivers/net/ethernet/sfc/mcdi.h         |    1 +
 drivers/net/ethernet/sfc/mcdi_pcol.h    | 8182 ++++++++++++++++++++++-
 drivers/net/ethernet/sfc/net_driver.h   |    5 +
 drivers/net/ethernet/sfc/tx.c           |    6 +-
 drivers/net/ethernet/sfc/tx_common.c    |   35 +-
 drivers/net/ethernet/sfc/tx_common.h    |    3 +-
 24 files changed, 8647 insertions(+), 275 deletions(-)
 create mode 100644 drivers/net/ethernet/sfc/ef100_rep.c
 create mode 100644 drivers/net/ethernet/sfc/ef100_rep.h
 create mode 100644 drivers/net/ethernet/sfc/mae.c
 create mode 100644 drivers/net/ethernet/sfc/mae.h


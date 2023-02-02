Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C37EB687BE7
	for <lists+netdev@lfdr.de>; Thu,  2 Feb 2023 12:14:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230366AbjBBLOk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Feb 2023 06:14:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45438 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230156AbjBBLOi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Feb 2023 06:14:38 -0500
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2040.outbound.protection.outlook.com [40.107.237.40])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DFC2886EBE;
        Thu,  2 Feb 2023 03:14:36 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Nc7WSYdi82jOff8TFhvjdSbDiIIPZaBQQ7urMMqhehHvpmRiaxCH+Ub9xkrsfCDo74Kp1pvrtg6QoNwxEVgef9MUdDSiizeD1Z07WzQ4XJV6xJEUvSoTru4IN62bVWr4g2UKFLbfoQYFN8IDHY6aEAGZh4gV7W/N5DZ8L2tg99VV3EabTvSFi2q7zxpHe0oNTOp/+caneCH/4LFhL4xVHcjNSPK8h6kntzWOTNEW5TWLiqDmjEhWu2E19qgfPflHwVGpJ+vtwD5TBJ2IrII/qbxYXBhxjQD61dWQAScDgFYDGAWYZ2XKL4hPsAs+tN1tGqHnlOqYfGEBzXdZj2s5QA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=r1ezyLpJzbgh6D859wQt124ND6M+E2Vv0rm2dy/nHZ0=;
 b=oBz3sX2dSLMffSG0o8NTqHF+yjzWhzVoLrpHJgAX+/6RSbB1T6Ln40YQLT5bQrw0+VI59NXE3krrLFjSrMnwCarO/yAn6Xo6zfnh0PDV1e0OyC2MkDydKplHQwGBmxHkvUGqIHWiMg5bUZ2fTdjCPncVGNITGhg6IV6n0B7WG1MUvFkD6u8e4U7BbmD87xlc2QeY74ADh1gyoNb1IyTvLarIja6LKqnO+q4Xh0nnLJ2kXoPVzRvp+oKspd7KrIologaGB/bko/M8juqt/IfKi7R5tN4VWFgmHcqENYSnZley3B8TFlfYSL3oeNjVrUqJPkZxAPGTfyFFlPcLqjY7Yg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=r1ezyLpJzbgh6D859wQt124ND6M+E2Vv0rm2dy/nHZ0=;
 b=a1gdR8rrKQW6AunFrFLmNOisph4hx8GoyPbfEh1sGxr4OGazOktdVuncOIwYz21srFvz+wCnGxbrp7bFFOOtV9VXGWVyC5KlM0xXNt4r+f+Ss9AzA+ZSfn5quVP/tzpXzij4/bCczsfGq8VRcuasMls+djn0a/WYBn7PwpblWC8=
Received: from DS7PR05CA0091.namprd05.prod.outlook.com (2603:10b6:8:56::12) by
 BN9PR12MB5383.namprd12.prod.outlook.com (2603:10b6:408:104::7) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6064.27; Thu, 2 Feb 2023 11:14:34 +0000
Received: from DM6NAM11FT046.eop-nam11.prod.protection.outlook.com
 (2603:10b6:8:56:cafe::43) by DS7PR05CA0091.outlook.office365.com
 (2603:10b6:8:56::12) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6086.6 via Frontend
 Transport; Thu, 2 Feb 2023 11:14:34 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB03.amd.com; pr=C
Received: from SATLEXMB03.amd.com (165.204.84.17) by
 DM6NAM11FT046.mail.protection.outlook.com (10.13.172.121) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.6043.28 via Frontend Transport; Thu, 2 Feb 2023 11:14:34 +0000
Received: from SATLEXMB04.amd.com (10.181.40.145) by SATLEXMB03.amd.com
 (10.181.40.144) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Thu, 2 Feb
 2023 05:14:33 -0600
Received: from xcbalucerop41x.xilinx.com (10.180.168.240) by
 SATLEXMB04.amd.com (10.181.40.145) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.34 via Frontend Transport; Thu, 2 Feb 2023 05:14:31 -0600
From:   <alejandro.lucero-palau@amd.com>
To:     <netdev@vger.kernel.org>, <linux-net-drivers@amd.com>
CC:     <davem@davemloft.net>, <kuba@kernel.org>, <pabeni@redhat.com>,
        <edumazet@google.com>, <habetsm.xilinx@gmail.com>,
        <ecree.xilinx@gmail.com>, <linux-doc@vger.kernel.org>,
        <corbet@lwn.net>, <jiri@nvidia.com>,
        "Alejandro Lucero" <alejandro.lucero-palau@amd.com>
Subject: [PATCH v5 net-next 0/8] sfc: devlink support for ef100
Date:   Thu, 2 Feb 2023 11:14:15 +0000
Message-ID: <20230202111423.56831-1-alejandro.lucero-palau@amd.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6NAM11FT046:EE_|BN9PR12MB5383:EE_
X-MS-Office365-Filtering-Correlation-Id: 8837a87b-42d3-463f-2176-08db050eaa4d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: fjCSHhuuFnf5ZAkGVcICrpcNF7rp3ZAxGtV+fHkuoHxmBTQHEkwD5BJtBiKLEzBqjufc8XSudG5hM0W72N9Uf2Bjyd6mqbb8Gyx5vDG3FaifJ/sfAQhoQBKjZg529+vgBIxLNviGPhXxrXNGy3/ODK/4/e1Gvgxp/diTZjELFobbcgCeUZMu4QjXU+mkXNXgW2nRlDCPstwUmWlUsDyYRS3CJ/OcKffIF74nbHp41HFna1kC6ZDB44bQtpctjTk+ptbulInCGjw/mU3PcJkY/uWRhcQ0OvgmszhObTApNzNh5pPwYwQabVdlr+teEgzfmS0TgzxArl5mNwoTI/2pZ6iwATgCbeUXU25wbfshdU2VUUuW9tesK9oPNp4nOb6yhGStxoUKTGY6eQ43KMcyc7PNaWDnU+bT8tv389PP0NM4YmtW0omzWZfbfL0vzbWb/fHrPFzltlq/hrALX3lE7+sSWlIAp7eGgmtN+2/MUHZFyfg6p4YsIftUW+nqksyLiPjLaMqDr+3E0QYTsfclvbC5qfQwo6B4BCnwviDB1wXBaRMvstbPaKS64PHN2vXcagwFC+NhscveD0Oy+DHwc8sum/oPw+G6nbCNo/upQKvAY8fEzk29yJucRvZ3kk4j/iRrqmh78FOMXbGPb30Bkb/zr1fzHbnUN/iChEQYTHrbJsMgsJh4aEoyTfckG+CjCzaOGcHnAOwFhZPQYYMoMudU/MdHVcBUrjOtYT2MYsc=
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB03.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230025)(4636009)(136003)(39860400002)(376002)(396003)(346002)(451199018)(36840700001)(40470700004)(46966006)(40460700003)(36860700001)(8936002)(6636002)(478600001)(54906003)(110136005)(186003)(26005)(36756003)(1076003)(82310400005)(316002)(6666004)(5660300002)(86362001)(7416002)(2906002)(2876002)(4326008)(70586007)(70206006)(8676002)(41300700001)(40480700001)(336012)(2616005)(426003)(83380400001)(47076005)(356005)(81166007)(82740400003)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Feb 2023 11:14:34.7138
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 8837a87b-42d3-463f-2176-08db050eaa4d
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB03.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT046.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN9PR12MB5383
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Alejandro Lucero <alejandro.lucero-palau@amd.com>

v5 changes
 - add extack error report for devlink info
 - Rename devlink functions stating locking
 - Check functions return through a variable
 - Remove unnecessary non related changes
 - put SRIOV dependent code inside #ifdefs (is ia64 still alive?)

v4 changes:
 - Add new doc file to MAINTAINERS
 - nvram metadata call independent of MTD config
 - add more useful info with extack

v3 changes:
 - fix compilation warnings/errors reported by checkpatch

v2 changes:
 - splitting up devlink info from basic devlink support
 - using devlink lock/unlock during initialization and removal
 - fix devlink registration order
 - splitting up efx_devlink_info_running_versions
 - Add sfc.rst with specifics about sfc info
 - embedding dl_port in mports
 - using extack for error reports to user space

This patchset adds devlink port support for ef100 allowing setting VFs
mac addresses through the VF representor devlink ports.

Basic devlink infrastructure is first introduced, then support for info
command. Next changes for enumerating MAE ports which will be used for
devlink port creation when netdevs are registered.

Adding support for devlink port_function_hw_addr_get requires changes in
the ef100 driver for getting the mac address based on a client handle.
This allows to obtain VFs mac addresses during netdev initialization as
well what is included in patch 6.

Such client handle is used in patches 7 and 8 for getting and setting
devlink port addresses.

Alejandro Lucero (8):
  sfc: add devlink support for ef100
  sfc: add devlink info support for ef100
  sfc: enumerate mports in ef100
  sfc: add mport lookup based on driver's mport data
  sfc: add devlink port support for ef100
  sfc: obtain device mac address based on firmware handle for ef100
  sfc: add support for devlink port_function_hw_addr_get in ef100
  sfc: add support for devlink port_function_hw_addr_set in ef100

 Documentation/networking/devlink/sfc.rst |  57 ++
 MAINTAINERS                              |   1 +
 drivers/net/ethernet/sfc/Kconfig         |   1 +
 drivers/net/ethernet/sfc/Makefile        |   3 +-
 drivers/net/ethernet/sfc/ef100_netdev.c  |  33 +
 drivers/net/ethernet/sfc/ef100_nic.c     |  93 ++-
 drivers/net/ethernet/sfc/ef100_nic.h     |   7 +
 drivers/net/ethernet/sfc/ef100_rep.c     |  57 +-
 drivers/net/ethernet/sfc/ef100_rep.h     |  10 +
 drivers/net/ethernet/sfc/efx_devlink.c   | 738 +++++++++++++++++++++++
 drivers/net/ethernet/sfc/efx_devlink.h   |  47 ++
 drivers/net/ethernet/sfc/mae.c           | 218 ++++++-
 drivers/net/ethernet/sfc/mae.h           |  41 ++
 drivers/net/ethernet/sfc/mcdi.c          |  72 +++
 drivers/net/ethernet/sfc/mcdi.h          |   8 +
 drivers/net/ethernet/sfc/net_driver.h    |   8 +
 16 files changed, 1369 insertions(+), 25 deletions(-)
 create mode 100644 Documentation/networking/devlink/sfc.rst
 create mode 100644 drivers/net/ethernet/sfc/efx_devlink.c
 create mode 100644 drivers/net/ethernet/sfc/efx_devlink.h

-- 
2.17.1


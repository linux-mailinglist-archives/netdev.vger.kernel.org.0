Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F275268F0AF
	for <lists+netdev@lfdr.de>; Wed,  8 Feb 2023 15:25:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231366AbjBHOZm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Feb 2023 09:25:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41120 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230203AbjBHOZj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Feb 2023 09:25:39 -0500
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2088.outbound.protection.outlook.com [40.107.223.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3FC8147EF9;
        Wed,  8 Feb 2023 06:25:32 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=TBMW/jLIpeVuQxcAo+mLJ93J35lS8NQYycaeIagoiFP4KvWO8AeDQ8DuX3jsyOQUDGFPz8a0f9fOEHglv0dE+23KEtzw1qe1+QU0+JDO9G8FIXrdOxBsmsmTPNFCaR56imB6dEW59QVuugGFFyjQ5c2TU703sXxYVECdc3OgFZ/VBUxyoC7ms5boqvKTZJQU3SfDiSCtCG8WSdDjaJfRxiktpcbhBhfjBhjtlcShMlQbfUjNoT1n0/EXX+6G5Pp3KBzjfevN9Dx46bRdEkg6i4wB5KJlbsbc8+uR3TDsotv/D034KshbWIL3VA4fkfnajsn7J0VvBRtc7wfmDSqxTQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=V/CLvqp7g1axguD2KbgF/Yj4Vw/kCax8hN3+lJErB9c=;
 b=Sok/XXG5YR7uTb1bYXP5cSow8fqhOuNLb5BJm30ZjROO8YmnNIp2R1Y3M8WswCRyvDE5CDXsQFaU1MlYykfOxLn4YCyjyKLoQHRyoWbmQ9im26KnQqELFaoJUlNIH7n4rODxXOrkrwa2CrrlDKTl4C1gVMkMTdHIqypfnzPpwU7fg73ey1+R6nvcLYEVzpboqPHMS1IbHN7mgHPoWJ4Y0tNgTSAUoMEHsvFah+E79mjwUDO/PngBa4APYOroOO+4wVgRyt7yUrAp63IIEUV40kx2sdVXpG6/4om/37dCoaAUqz5PbgWC9eYDpm2ua2E3/TJkFECUl2e3PCeHPYYhtA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=V/CLvqp7g1axguD2KbgF/Yj4Vw/kCax8hN3+lJErB9c=;
 b=4D+WB1ycCgPLJFkmxhrZq7IsJj17n3YPqnhSgqRFXRPjvPvv7e68sm0s4eat1iTlmyedHwFiDC/i/8ZVPv8tz1Id01QMDDrXMj1vjEKGVeLuL0d5+PEi2xwlQFWFepzU6JXax/OG+MRevTEmlr7pNBlWT5SEJNCGgX73Qi22u5w=
Received: from DM6PR07CA0107.namprd07.prod.outlook.com (2603:10b6:5:330::21)
 by BL1PR12MB5159.namprd12.prod.outlook.com (2603:10b6:208:318::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6064.36; Wed, 8 Feb
 2023 14:25:30 +0000
Received: from DM6NAM11FT087.eop-nam11.prod.protection.outlook.com
 (2603:10b6:5:330:cafe::dd) by DM6PR07CA0107.outlook.office365.com
 (2603:10b6:5:330::21) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6086.17 via Frontend
 Transport; Wed, 8 Feb 2023 14:25:29 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB03.amd.com; pr=C
Received: from SATLEXMB03.amd.com (165.204.84.17) by
 DM6NAM11FT087.mail.protection.outlook.com (10.13.172.150) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.6086.17 via Frontend Transport; Wed, 8 Feb 2023 14:25:29 +0000
Received: from SATLEXMB07.amd.com (10.181.41.45) by SATLEXMB03.amd.com
 (10.181.40.144) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Wed, 8 Feb
 2023 08:25:29 -0600
Received: from SATLEXMB03.amd.com (10.181.40.144) by SATLEXMB07.amd.com
 (10.181.41.45) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Wed, 8 Feb
 2023 06:25:28 -0800
Received: from xcbalucerop41x.xilinx.com (10.180.168.240) by
 SATLEXMB03.amd.com (10.181.40.144) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.34 via Frontend Transport; Wed, 8 Feb 2023 08:25:27 -0600
From:   <alejandro.lucero-palau@amd.com>
To:     <netdev@vger.kernel.org>, <linux-net-drivers@amd.com>
CC:     <davem@davemloft.net>, <kuba@kernel.org>, <pabeni@redhat.com>,
        <edumazet@google.com>, <habetsm.xilinx@gmail.com>,
        <ecree.xilinx@gmail.com>, <linux-doc@vger.kernel.org>,
        <corbet@lwn.net>, <jiri@nvidia.com>,
        "Alejandro Lucero" <alejandro.lucero-palau@amd.com>
Subject: [PATCH v6 net-next 0/8] sfc: devlink support for ef100
Date:   Wed, 8 Feb 2023 14:25:11 +0000
Message-ID: <20230208142519.31192-1-alejandro.lucero-palau@amd.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6NAM11FT087:EE_|BL1PR12MB5159:EE_
X-MS-Office365-Filtering-Correlation-Id: f2276fba-64b4-4681-fe40-08db09e0547f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: JuJx/Xoou4b9GlUMBozhQu0W0QdPL/I3QstCITRjt5SFI0jC+iGWeZrD0MZzaGLhErsL2qa+VjJjIdMKSnwLr2LJwPRhn+PsFR2sNOHax2rEcP5gysqvsdzyG6mSPlktnKj/LHWwbOppcvekkSLEJW3ouSuexgX/uCV7nMsqmxZ0eRuRUxRjqb5qcJau2XWWW33STugbpKsA3iE8e35oSQzom8YxBAWBEPmdr72xsAi1VvLPv1stmrV9KXUENyO8JyQE3902EObUWG86nSZO84WoCtYNpU4HI+nW6byHwZivp+dRgQvhixHkXpSvtxyDesOYpik/x2OYySSOJ/EeFiv+7fTxQYYxlfSRANtDljH+039d7wcZfvPsB56RAiUPs2Hsoijt2rrdYmcz+8ShK3oBw/9BemojVW8w+a5vbsc48wtHexyrLxHW+NsVuEB2xa+4lwhX/SFx1EN0/BFL3La0B0vw+gHERTQMoucQzKjlVUBdlqf2VxXWBZ1WVkdOXqdKT4yvxRuIY0f2w9QWpDsGCbOxd2iS2D8jTYsFzNukXcW+O+0KXrqGVqSfY9vvOgFn/tWDZkoMsb9LcYr6z802zcQTJf4vc87LqoCs3YtMzInTpzfUAnzDWTDMK4f8+QcakequRoEj5SYh81rWmkTR49TP0P0S4Gsr65M62B9hAihT6tfy1xjtQDY9rMg1CDzDvlOG/r/hlxW1p+eBWMfd5WxacWaLi/Ot9+VvabA=
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB03.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230025)(4636009)(39860400002)(136003)(376002)(396003)(346002)(451199018)(40470700004)(46966006)(36840700001)(26005)(186003)(1076003)(2906002)(6666004)(36756003)(2876002)(7416002)(5660300002)(356005)(478600001)(81166007)(41300700001)(82310400005)(82740400003)(8936002)(40480700001)(2616005)(47076005)(8676002)(336012)(36860700001)(70586007)(70206006)(4326008)(83380400001)(6636002)(86362001)(426003)(110136005)(54906003)(40460700003)(316002)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Feb 2023 14:25:29.7430
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: f2276fba-64b4-4681-fe40-08db09e0547f
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB03.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT087.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR12MB5159
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

v6 changes:
 - add file headers at its due time
 - fix sfc.rst warnings
 - add sfc.rst to the index.rst file
 - avoid microblaze build error
 - simplify devlink info errors reported

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

 Documentation/networking/devlink/index.rst |   1 +
 Documentation/networking/devlink/sfc.rst   |  57 ++
 MAINTAINERS                                |   1 +
 drivers/net/ethernet/sfc/Kconfig           |   1 +
 drivers/net/ethernet/sfc/Makefile          |   3 +-
 drivers/net/ethernet/sfc/ef100_netdev.c    |  30 +
 drivers/net/ethernet/sfc/ef100_nic.c       |  93 ++-
 drivers/net/ethernet/sfc/ef100_nic.h       |   7 +
 drivers/net/ethernet/sfc/ef100_rep.c       |  57 +-
 drivers/net/ethernet/sfc/ef100_rep.h       |  10 +
 drivers/net/ethernet/sfc/efx_devlink.c     | 713 +++++++++++++++++++++
 drivers/net/ethernet/sfc/efx_devlink.h     |  48 ++
 drivers/net/ethernet/sfc/mae.c             | 218 ++++++-
 drivers/net/ethernet/sfc/mae.h             |  40 ++
 drivers/net/ethernet/sfc/mcdi.c            |  74 +++
 drivers/net/ethernet/sfc/mcdi.h            |  10 +
 drivers/net/ethernet/sfc/net_driver.h      |   8 +
 17 files changed, 1346 insertions(+), 25 deletions(-)
 create mode 100644 Documentation/networking/devlink/sfc.rst
 create mode 100644 drivers/net/ethernet/sfc/efx_devlink.c
 create mode 100644 drivers/net/ethernet/sfc/efx_devlink.h

-- 
2.17.1


Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6453167A5B6
	for <lists+netdev@lfdr.de>; Tue, 24 Jan 2023 23:30:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230490AbjAXWav (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Jan 2023 17:30:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57762 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229503AbjAXWau (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 Jan 2023 17:30:50 -0500
Received: from NAM02-BN1-obe.outbound.protection.outlook.com (mail-bn1nam02on2085.outbound.protection.outlook.com [40.107.212.85])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DBA738683
        for <netdev@vger.kernel.org>; Tue, 24 Jan 2023 14:30:48 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jRmzJexsbn+/KNtBrNNztTgrtE+f4581A1an3fGqf1/T+ltPtlddoMAtVyejb9owx4gZQHm62EjPbUn3/jBXcxV5UP4HXXiYp9PzimbGk5juGr6HQ0xOj2wpmKjoV2JIIRHdlJPLIZvwufzyhj1ss8Djyzc0eCgMulvUacyKo2zkvPWH+vxUyCnu3MdzJv3TQW4RtZ+m3izk2yxx3u62rkmN90Xo5aM4hvll5Ty6woOJdwa/ldpvjNQKBC8RuojHvZQSbnl99fnw8Ls3kvkB5SKTvJIQLaFiVSMsv3YWqrpi1Fd/VMlcQmX/BfWy2epovir4BriFSduEAYJswPnOfQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=DaxkCe7w75qgt74WJjpIVqwhtC2XqZIHByXJ4kMxYxc=;
 b=R8XCPYUS67x2j49W9qZH8pXCjdpSrp1CPvbFm0B0oUzdbdR8RwByVi1Maf8yLn8bgtOfXJeB8ShUiiBse6TMC0sxJ0yrgHbGYbIHU2b7DRbk5BihLmE9eLbUUcFNlI+W6Ng0fFsnM1xBy7pe6F3hHL61+G+Jjxq5NLMp9aUVTR/7WNRxg6S/JPItzAclrkWYKZUOWTFyH96fmiku6yrmpk40umcuWpAH0jPB65DXBLotQinU5wVCrjOjJlKs8qy19KcCN+1lRJdL5wLbEkeOncu++bngUCZN+AbPqQMC0mmzbZ7Pb1+Xs+OyK9rCCVowDRW/M91mNRXzsoCvQSgpcw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DaxkCe7w75qgt74WJjpIVqwhtC2XqZIHByXJ4kMxYxc=;
 b=QlyZpRWbz4H4MKMedeSS6b31tAV4KT4GlNeDjyIErtW+BZn0q7r6ob7sXz0er2hQWlTdCz3CO5aLrcghug1DSPgGyzZSxb6sHOhbMihu7uzi5z+erFyNjZOGnoyTxNVhw7urjqptCSqK4weoRkGWISytq/wsmRN4c6IWekpDGGE=
Received: from MW4P221CA0015.NAMP221.PROD.OUTLOOK.COM (2603:10b6:303:8b::20)
 by SN7PR12MB6815.namprd12.prod.outlook.com (2603:10b6:806:265::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6002.33; Tue, 24 Jan
 2023 22:30:46 +0000
Received: from CO1NAM11FT015.eop-nam11.prod.protection.outlook.com
 (2603:10b6:303:8b:cafe::7) by MW4P221CA0015.outlook.office365.com
 (2603:10b6:303:8b::20) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6002.33 via Frontend
 Transport; Tue, 24 Jan 2023 22:30:46 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB03.amd.com; pr=C
Received: from SATLEXMB03.amd.com (165.204.84.17) by
 CO1NAM11FT015.mail.protection.outlook.com (10.13.175.130) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.6043.17 via Frontend Transport; Tue, 24 Jan 2023 22:30:46 +0000
Received: from SATLEXMB08.amd.com (10.181.40.132) by SATLEXMB03.amd.com
 (10.181.40.144) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Tue, 24 Jan
 2023 16:30:45 -0600
Received: from SATLEXMB03.amd.com (10.181.40.144) by SATLEXMB08.amd.com
 (10.181.40.132) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Tue, 24 Jan
 2023 14:30:45 -0800
Received: from xcbalucerop41x.xilinx.com (10.180.168.240) by
 SATLEXMB03.amd.com (10.181.40.144) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.34 via Frontend Transport; Tue, 24 Jan 2023 16:30:43 -0600
From:   <alejandro.lucero-palau@amd.com>
To:     <netdev@vger.kernel.org>, <linux-net-drivers@amd.com>
CC:     <davem@davemloft.net>, <kuba@kernel.org>, <pabeni@redhat.com>,
        <edumazet@google.com>, <habetsm.xilinx@gmail.com>,
        <ecree.xilinx@gmail.com>,
        Alejandro Lucero <alejandro.lucero-palau@amd.com>
Subject: [PATCH v2 net-next 0/8] sfc: devlink support for ef100
Date:   Tue, 24 Jan 2023 22:30:21 +0000
Message-ID: <20230124223029.51306-1-alejandro.lucero-palau@amd.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO1NAM11FT015:EE_|SN7PR12MB6815:EE_
X-MS-Office365-Filtering-Correlation-Id: 977e9d00-3251-4b51-c065-08dafe5aa32a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: +yxXSak8V65Xa1Kd/K28uyljRLZCyvGaOYiYA7hI+eT4os7RZv9qL5RLsW8OJuyUYA46jhPnaGt+ZbtvwkmlCFtPKnDa0TFhAHeal8Zij1/Ed5Edd0CzJiMkU5tZ+kh32WgLxr/d2cwfd4dY8E1J4xC0IpOHiP6ivB7/mPnstRrdQNgF2a/c9ngEFQdMdOfxiK7Pool4nuac09TEyDq1NFRLO2cmk/4nJucHvLnSwiPMhQFdxQZfVhAa8IO30weuzOPvWa9X+vjM0CcGz5Ir/vH8bUgb50Ri6EmWeYzY02DuSwpAH4XG2VwDSzfkp/M8Ew81HWIS5/wLkve0H/kvocUGCHMfuytha5zUJIDDnf54A/5cz1oF8q4MzLbHa90apIxtk96rTLAWl8MTUlyrlhjFLCNugjpViC4axwn5+TUvtxliFrBWKi4c6FKqzCCr76QuDgNmUbpd0HVnOLbvyS9srVzbLniZ0TVvy3YvDn6akx9mfDaYqEII+y+C1E3d2xaAwjzeo+Jzptl9DrveOW5MhWSFRulrC9DneqWY6bTzAqQJVTdXTb6DYv1nVP93OWqInDPyYqTvcEuuTRVtF5zJa6KQDluznZyKE2KCYy+UIuHE95ygH+ER7eJG0zH4LFoYZjiK3xDlL89754dZHOD65ZpdaTlZm2Jfs1t7d+Yh0aJJraXp/lTki+oxInz1G67V65/IS1bRC34AvmwJIWfFxb+EXqh73z6Ynnb9jBg=
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB03.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230025)(4636009)(376002)(136003)(396003)(346002)(39860400002)(451199018)(46966006)(36840700001)(40470700004)(4326008)(316002)(70206006)(86362001)(36860700001)(36756003)(1076003)(5660300002)(426003)(2906002)(82740400003)(41300700001)(2876002)(6636002)(82310400005)(8936002)(47076005)(2616005)(40460700003)(6666004)(186003)(40480700001)(26005)(8676002)(70586007)(54906003)(110136005)(478600001)(336012)(83380400001)(356005)(81166007)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Jan 2023 22:30:46.2783
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 977e9d00-3251-4b51-c065-08dafe5aa32a
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB03.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT015.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR12MB6815
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Alejandro Lucero <alejandro.lucero-palau@amd.com>

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
devlik port creation when netdevs are registered.

Adding support for devlink port_function_hw_addr_get requires changes in
the ef100 driver for getting the mac address based on a client handle.
This allows to obtain VFs mac address during netdev initialization as
well what is included in patch 6.

Such client handle is used in patches 7 and 8 for getting and setting
devlink ports addresses.

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
 drivers/net/ethernet/sfc/Kconfig         |   1 +
 drivers/net/ethernet/sfc/Makefile        |   3 +-
 drivers/net/ethernet/sfc/ef100_netdev.c  |  31 ++
 drivers/net/ethernet/sfc/ef100_nic.c     |  93 +++-
 drivers/net/ethernet/sfc/ef100_nic.h     |   7 +
 drivers/net/ethernet/sfc/ef100_rep.c     |  57 +-
 drivers/net/ethernet/sfc/ef100_rep.h     |  10 +
 drivers/net/ethernet/sfc/efx_devlink.c   | 660 +++++++++++++++++++++++
 drivers/net/ethernet/sfc/efx_devlink.h   |  46 ++
 drivers/net/ethernet/sfc/mae.c           | 218 +++++++-
 drivers/net/ethernet/sfc/mae.h           |  41 ++
 drivers/net/ethernet/sfc/mcdi.c          |  72 +++
 drivers/net/ethernet/sfc/mcdi.h          |   8 +
 drivers/net/ethernet/sfc/net_driver.h    |   8 +
 15 files changed, 1285 insertions(+), 27 deletions(-)
 create mode 100644 Documentation/networking/devlink/sfc.rst
 create mode 100644 drivers/net/ethernet/sfc/efx_devlink.c
 create mode 100644 drivers/net/ethernet/sfc/efx_devlink.h

-- 
2.17.1


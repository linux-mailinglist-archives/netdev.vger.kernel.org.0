Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6ABF1682FF9
	for <lists+netdev@lfdr.de>; Tue, 31 Jan 2023 15:58:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232323AbjAaO6x (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 31 Jan 2023 09:58:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56416 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231405AbjAaO6g (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 31 Jan 2023 09:58:36 -0500
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2086.outbound.protection.outlook.com [40.107.93.86])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 351FD18B0B;
        Tue, 31 Jan 2023 06:58:35 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lE4CnJNwLtRsi2o+BRyp8N6zu0sebSg1m4T782SkxiCTm8LKuVAWPqxzFRVjayGC9NoPD78nCn9rC0HkScLvWzFdnAkTgP47Y6S1m4ggxeMwpcMsRi5tSWmmRKmC7JVOAEM0vahQeljwpMWLyZD1UUhFk0FhMSdphF2c8G2n1DriwGQHgozhHTclZAtCgZ8513AiehaARpwIeRv6zCcBFzzuqvCVRrESY/Kk3A8JcLZy1R0fTUqGqIKQh5yuPSw48jG9rH/+6NoRc9WBj1iCeAypviZ7t4nlOQWgdmYvAAwqo0VXA1o8GzdsmTwrL4w6V4op12KSIzOffFxRhSEP8Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=eCtHoup9NHL/Y0Ew6XmURrtErKff4TOs9jRV1aVN7II=;
 b=QkUVXRSCHorkCu+P8xY80Iihd8eZzyiS/2Ti9YV5LRffedB6qwnkx9hkku91+tWWSizHMOq+Jg5PoCxhs5OlslZebcucy4MU+5/zIGZDppgVhLzvXtCoA7DWqS2FJzfCQGBlXQHmryVqKUy1FQj9eF4gUQ/EqnsY7Lz0hRRxc6ky/rY/okq+cYm6kAbyh6oX6ii8g1LThA+hU47RYXiacPfVEDhxRY+Nrvzxs59NeOdT0hQ+kiZN0T8/ZI/HEQsHHXqpe0UnKbFaP1lWKPB9deIumcAPg7ndb0goPpO7iTZ3VV7IbAao4C3RmQIAa4w0f7+bL5cxVJGUFcNQg/m5CQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=eCtHoup9NHL/Y0Ew6XmURrtErKff4TOs9jRV1aVN7II=;
 b=QfFQ2AMiE8peaxsxxBIqvmHqcp7QM6kEliQpaIeywCocitYDemgVdcWEuUa2/D5GBb29Jbp4fI0bhmyGLFhn/Yy34mk8iDylTdotgMgTQMUxsVRUbV+P2YDczp8QYrcznlE9+p6rNjjh4mnqtI7QJ/baxowpFVjBSxngo7BqAag=
Received: from BN0PR07CA0022.namprd07.prod.outlook.com (2603:10b6:408:141::14)
 by MW3PR12MB4345.namprd12.prod.outlook.com (2603:10b6:303:59::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6043.36; Tue, 31 Jan
 2023 14:58:32 +0000
Received: from BN8NAM11FT023.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:141:cafe::10) by BN0PR07CA0022.outlook.office365.com
 (2603:10b6:408:141::14) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6043.38 via Frontend
 Transport; Tue, 31 Jan 2023 14:58:32 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 BN8NAM11FT023.mail.protection.outlook.com (10.13.177.103) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.6064.22 via Frontend Transport; Tue, 31 Jan 2023 14:58:32 +0000
Received: from SATLEXMB03.amd.com (10.181.40.144) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Tue, 31 Jan
 2023 08:58:31 -0600
Received: from xcbalucerop41x.xilinx.com (10.180.168.240) by
 SATLEXMB03.amd.com (10.181.40.144) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.34 via Frontend Transport; Tue, 31 Jan 2023 08:58:30 -0600
From:   <alejandro.lucero-palau@amd.com>
To:     <netdev@vger.kernel.org>, <linux-net-drivers@amd.com>
CC:     <davem@davemloft.net>, <kuba@kernel.org>, <pabeni@redhat.com>,
        <edumazet@google.com>, <habetsm.xilinx@gmail.com>,
        <ecree.xilinx@gmail.com>, <linux-doc@vger.kernel.org>,
        <corbet@lwn.net>, <jiri@nvidia.com>,
        "Alejandro Lucero" <alejandro.lucero-palau@amd.com>
Subject: [PATCH v4 net-next 0/8] sfc: devlink support for ef100
Date:   Tue, 31 Jan 2023 14:58:14 +0000
Message-ID: <20230131145822.36208-1-alejandro.lucero-palau@amd.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN8NAM11FT023:EE_|MW3PR12MB4345:EE_
X-MS-Office365-Filtering-Correlation-Id: e5bda5c9-8344-4c6c-9a76-08db039b9eef
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 13KZmTtfIZaj+nkRX0bywGbPCpHZztEMYpjzXZsnyV/ACZGhCY9SbqL/fzVJS7+jtrpro/Gf/HxrydUt880fV8dbEUYJQZ7Qq/G+eQlP0onxR0JqXa+wUr4u6vfQ7qsThC4TCRUBOGUPJ4KTW2hQLnHoZDU8jGErB3LseX8expeN3WI9PGyXTTlSuXLvI0T1o/u8YxKAUPAwjMwkUKvKKBoGknrVj/HdFDGvM1t0kCjI+YlxcloqMfgNn62PRQgOBNERiblVZRAC84Mr6P7xt69v810hXFqZ25NM1PFXCwBlZJbwc7IxNQW1B1m1FjGju1NX2PGCs6QFbV9vzieWTMF9xUGQZk4x6q28CvsA5Tf+upFT2Mjx80tLn6HbZqvzeDFjn5f53PopByXkl8E8ST+L9I3QLSFKP5nHBM6EIo+jHrRC1z2oKGJnSXWTRv50tQEfDoN5EfxsdUmS0xIqabc1uZkfb+rXMM7NUsqeszODMnkw6yUCDQ+sgK1g+8AQhVpME54NmtW4rcFdeHxAxJzAB9RQU6jJJLsbRcGnC9TF/2+IbISlsMKKTk+dULe9ApH66R2XAxmqcxJuuNaMcWNe/aXd24CWh0RKG0Fto03CVtvv+jf/fr/WEX2BTNFt+1L6ne8QnLczr7cXJtQ+SusOxL/WYG52jVHzqVuHTipFZfP99wed+iOwLrRcggCZBmG27/bVbZ0yH8+2Dm/Fs1OYqvbOIxlhUlwMZpU59qs=
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230025)(4636009)(346002)(39860400002)(396003)(136003)(376002)(451199018)(46966006)(36840700001)(40470700004)(86362001)(81166007)(356005)(8676002)(82740400003)(36860700001)(36756003)(54906003)(8936002)(5660300002)(82310400005)(110136005)(70586007)(316002)(6636002)(70206006)(41300700001)(4326008)(40480700001)(40460700003)(2906002)(336012)(2876002)(7416002)(2616005)(47076005)(426003)(83380400001)(478600001)(26005)(186003)(1076003)(6666004)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 31 Jan 2023 14:58:32.3905
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: e5bda5c9-8344-4c6c-9a76-08db039b9eef
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT023.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW3PR12MB4345
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
 drivers/net/ethernet/sfc/ef100_netdev.c  |  31 ++
 drivers/net/ethernet/sfc/ef100_nic.c     |  93 +++-
 drivers/net/ethernet/sfc/ef100_nic.h     |   7 +
 drivers/net/ethernet/sfc/ef100_rep.c     |  57 +-
 drivers/net/ethernet/sfc/ef100_rep.h     |  10 +
 drivers/net/ethernet/sfc/efx_devlink.c   | 672 +++++++++++++++++++++++
 drivers/net/ethernet/sfc/efx_devlink.h   |  45 ++
 drivers/net/ethernet/sfc/mae.c           | 218 +++++++-
 drivers/net/ethernet/sfc/mae.h           |  41 ++
 drivers/net/ethernet/sfc/mcdi.c          |  72 +++
 drivers/net/ethernet/sfc/mcdi.h          |   8 +
 drivers/net/ethernet/sfc/net_driver.h    |   8 +
 16 files changed, 1297 insertions(+), 27 deletions(-)
 create mode 100644 Documentation/networking/devlink/sfc.rst
 create mode 100644 drivers/net/ethernet/sfc/efx_devlink.c
 create mode 100644 drivers/net/ethernet/sfc/efx_devlink.h

-- 
2.17.1


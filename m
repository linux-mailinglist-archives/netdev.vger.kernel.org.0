Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ED400383B19
	for <lists+netdev@lfdr.de>; Mon, 17 May 2021 19:19:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236086AbhEQRUz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 May 2021 13:20:55 -0400
Received: from azhdrrw-ex01.nvidia.com ([20.51.104.162]:1231 "EHLO
        AZHDRRW-EX01.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232996AbhEQRUz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 May 2021 13:20:55 -0400
X-Greylist: delayed 902 seconds by postgrey-1.27 at vger.kernel.org; Mon, 17 May 2021 13:20:55 EDT
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (104.47.55.170)
 by mxs.oss.nvidia.com (10.13.234.36) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.858.12; Mon, 17 May 2021 10:04:35 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Kc9PO3Dr+6wo8MgGCKgMdAdWJmdT4yh9tshwWM73YMjcV4i7L9j5+FvE3NS3nQkN/P0HOBiNPuwfPA8/AyfiIG+ZympM1QcCOvoFOWqvQjqq7xzMYZU4fNR5tePi3VKcjUjFrXQ/FvprgiFfptErDkQhF1b9ywONqSseCl7STTSoX+ZCep0plwoz+eVauDe3lgg0voavTo/mtw+bHQs5QKEUC+8J2+r8aIUijAV8g4IvOKGSa7rXZpdjeWy/Egw9Yn3vxyQcrvXeU6lcIXQ2/BU7DlsjBLkulMBISAoJ6aO30BGCgnTRJ5mqwmXwGuRobKSlldedoNRlSc9pIFCsZw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=GROP0DM8oiw573UiU15OuwADhxQU+clcvCY2c00iqQU=;
 b=OFNM+mmJ1oEKdKSs4U0+sFVTBXOc3cH+1CBSuL/9CgThyiOoIF1p0OyWIGoK/uBioLAVbmIxbMNOzCnE0BlmyUX7tMw8ly59F+HYuHNeYYrkGhug1i3tUS+in+DR0DB8Mo6b8mIplHmwjbVP+wxtbjbb56mhKy9HjafCpV0kFcRVLsGc/FSqomy7/JumoOuDouv1WFjD6Gm7Py6IGI7WSaIEekU/a1oVMTve+ynjzldY0OqBhXEcINkA6IuFPzVeN1bGymQkSWmrAAJ/YwJmGG1XWsEdy5+HaxnxZbC7VpaFpWp41gCSXQZd4uwyUpIbND0sQ7SURDOJw67uPY6ssA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.34) smtp.rcpttodomain=kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=GROP0DM8oiw573UiU15OuwADhxQU+clcvCY2c00iqQU=;
 b=OPabxaDq+3PqH2fO38REMnfsJ3vjpbGynIWT4Cwek3LLg7BfKLVLLfERKqoWp3Vl+JRPZrd1dw5PKFURNtMBWhGvoAs4XH4w8Zv/Gnmq3ZPnixZwW21V35d5jelDX4VZ628lsKv2sY5kCEwlPhkVm3lUpkoUHcwQOkwKU3wBZnHMcMqsYF9ZseZniqxE4EomeSi3+lHxkdjC7qHpt/q0ipSOaWWaOgpVknBuARJyikhEBuvQ3iXpBF+o6lU60HnsnXGChN8dBogqfSheOUTJhkDBNlyLCcU/KGb9yWKUegLf4mdD4BKTOIu/00yNXtDfEkxkAhw3egCxXczG9/Dw8g==
Received: from DM6PR03CA0102.namprd03.prod.outlook.com (2603:10b6:5:333::35)
 by CH0PR12MB5369.namprd12.prod.outlook.com (2603:10b6:610:d4::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4129.26; Mon, 17 May
 2021 17:04:33 +0000
Received: from DM6NAM11FT021.eop-nam11.prod.protection.outlook.com
 (2603:10b6:5:333:cafe::f1) by DM6PR03CA0102.outlook.office365.com
 (2603:10b6:5:333::35) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4108.25 via Frontend
 Transport; Mon, 17 May 2021 17:04:33 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.34)
 smtp.mailfrom=nvidia.com; kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.34 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.34; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.34) by
 DM6NAM11FT021.mail.protection.outlook.com (10.13.173.76) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4129.25 via Frontend Transport; Mon, 17 May 2021 17:04:33 +0000
Received: from shredder.mellanox.com (172.20.145.6) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Mon, 17 May
 2021 17:04:29 +0000
From:   Ido Schimmel <idosch@OSS.NVIDIA.COM>
To:     <netdev@vger.kernel.org>
CC:     <davem@davemloft.net>, <kuba@kernel.org>, <jiri@OSS.NVIDIA.COM>,
        <petrm@OSS.NVIDIA.COM>, <danieller@OSS.NVIDIA.COM>,
        <amcohen@OSS.NVIDIA.COM>, <mlxsw@OSS.NVIDIA.COM>,
        Ido Schimmel <idosch@OSS.NVIDIA.COM>
Subject: [PATCH net-next 00/11] mlxsw: Various updates
Date:   Mon, 17 May 2021 20:03:50 +0300
Message-ID: <20210517170401.188563-1-idosch@nvidia.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [172.20.145.6]
X-ClientProxiedBy: HQMAIL105.nvidia.com (172.20.187.12) To
 HQMAIL107.nvidia.com (172.20.187.13)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: f20e816d-cd85-4bcf-69c5-08d91955d80f
X-MS-TrafficTypeDiagnostic: CH0PR12MB5369:
X-Microsoft-Antispam-PRVS: <CH0PR12MB53696DC63ECE3661D7A94408B22D9@CH0PR12MB5369.namprd12.prod.outlook.com>
X-MS-Exchange-Transport-Forked: True
X-MS-Oob-TLC-OOBClassifiers: OLM:1850;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: j2DRuVvG2nE+VV3kfOfZz7DAV4K774VqHQmRsIRuEi4CIJR7Vsc0KIF39sGIk/N1xumY0aqsHN39phfNDEa+c5CEo6M9yWoVX7miMVdHkb0nM4LDZrhAkFriPkSlZjU/MlWjY8gqIaHcilCrUUlgdu8mJiSdO2RmMx7yxIqiW0UMaJ8e8uf2MOEWdiODyBL3L8t/N/ysko2l1wxWHjhnOeXXhN73VaX+Vp13+6fl0IDwkEnEHMLTlcH5b02o4TvJVs9NgCrBaQV4kd7D8CTTAjjIDC/m0JpC2EnkSfQe7fngmDUr2QTX144kJvui7TKrW+ne4M43KuaS7LlRhY1jh8ZA9JvppdIsqBqqC0eoKdAgN7WG8/iFro6Ck8GLqnZmVDsHuaaiuwozYn1DIh7umK4sC8lP5FhUoRputkjdw97mGnE7MP94rCrZ7oHLNLDW4ybglbefiJRACms6Xz/DUzSI9FcxsfybXBpMPbfYdyFon7k4LnaFwrHZLoDxA5zflUIWaf9misUQCJgUNuAC29kEYrLRBl9orJypQlai7fst9lf76l80m+/aYlCC2FDErheXvxDHqustlcZhRxhXNLJDl/tVfhB2bEyH+iy2QIqQTKz70pv3cZhRNHIjHprzkwi+gKnt0jFELS8DGJ1vCqQrkYg325/Ufm6L/upLMMs=
X-Forefront-Antispam-Report: CIP:216.228.112.34;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid03.nvidia.com;CAT:NONE;SFS:(4636009)(136003)(39860400002)(346002)(396003)(376002)(36840700001)(46966006)(2616005)(36860700001)(316002)(26005)(36906005)(478600001)(2906002)(36756003)(47076005)(5660300002)(4326008)(82310400003)(16526019)(336012)(66574015)(6666004)(15650500001)(107886003)(8936002)(70586007)(356005)(86362001)(83380400001)(70206006)(1076003)(82740400003)(426003)(8676002)(7636003)(6916009)(186003)(54906003);DIR:OUT;SFP:1101;
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 May 2021 17:04:33.6459
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: f20e816d-cd85-4bcf-69c5-08d91955d80f
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.34];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT021.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR12MB5369
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patchset contains various updates to the mlxsw driver and related
selftests.

Patches #1-#5 contain various updates to mlxsw selftests. The most
significant change is the conversion of the DCB selftests to use the new
iproute2 DCB support.

Patches #6-#9 contain mostly trivial changes to the driver itself. No
user facing changes.

Patches #10-#11 remove support for SwitchX-2 and SwitchIB ASICs that did
not see any updates in the last 4-5 years and will not see any in the
future. See individual commit messages for detailed explanation as to
why it is OK to remove these drivers from the kernel.

Amit Cohen (2):
  mlxsw: Remove Mellanox SwitchIB ASIC support
  mlxsw: Remove Mellanox SwitchX-2 ASIC support

Danielle Ratson (3):
  selftests: mlxsw: Make the unsplit array global in port_scale test
  mlxsw: spectrum_buffers: Switch function arguments
  mlxsw: Verify the accessed index doesn't exceed the array length

Ido Schimmel (3):
  selftests: mlxsw: Make sampling test more robust
  mlxsw: core: Avoid unnecessary EMAD buffer copy
  mlxsw: spectrum_router: Avoid missing error code warning

Petr Machata (3):
  selftests: mlxsw: qos_headroom: Convert to iproute2 dcb
  selftests: mlxsw: qos_pfc: Convert to iproute2 dcb
  selftests: mlxsw: qos_lib: Drop __mlnx_qos

 drivers/net/ethernet/mellanox/mlxsw/Kconfig   |   22 -
 drivers/net/ethernet/mellanox/mlxsw/Makefile  |    4 -
 drivers/net/ethernet/mellanox/mlxsw/core.c    |    2 +-
 drivers/net/ethernet/mellanox/mlxsw/ib.h      |    9 -
 drivers/net/ethernet/mellanox/mlxsw/minimal.c |    4 +
 drivers/net/ethernet/mellanox/mlxsw/pci.c     |    5 -
 drivers/net/ethernet/mellanox/mlxsw/pci.h     |    3 -
 .../net/ethernet/mellanox/mlxsw/spectrum.c    |    5 +
 .../mellanox/mlxsw/spectrum_buffers.c         |    6 +-
 .../ethernet/mellanox/mlxsw/spectrum_ptp.c    |    3 +
 .../ethernet/mellanox/mlxsw/spectrum_router.c |    9 +-
 .../mellanox/mlxsw/spectrum_switchdev.c       |    4 +
 .../net/ethernet/mellanox/mlxsw/switchib.c    |  595 ------
 .../net/ethernet/mellanox/mlxsw/switchx2.c    | 1691 -----------------
 .../selftests/drivers/net/mlxsw/port_scale.sh |    4 +-
 .../drivers/net/mlxsw/qos_headroom.sh         |   69 +-
 .../selftests/drivers/net/mlxsw/qos_lib.sh    |   14 -
 .../selftests/drivers/net/mlxsw/qos_pfc.sh    |   24 +-
 .../selftests/drivers/net/mlxsw/tc_sample.sh  |   12 +-
 19 files changed, 83 insertions(+), 2402 deletions(-)
 delete mode 100644 drivers/net/ethernet/mellanox/mlxsw/ib.h
 delete mode 100644 drivers/net/ethernet/mellanox/mlxsw/switchib.c
 delete mode 100644 drivers/net/ethernet/mellanox/mlxsw/switchx2.c

-- 
2.31.1


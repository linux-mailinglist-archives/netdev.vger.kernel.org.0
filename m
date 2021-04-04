Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C3150353761
	for <lists+netdev@lfdr.de>; Sun,  4 Apr 2021 10:15:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229709AbhDDIPD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 4 Apr 2021 04:15:03 -0400
Received: from mail-bn7nam10on2072.outbound.protection.outlook.com ([40.107.92.72]:44000
        "EHLO NAM10-BN7-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229483AbhDDIPD (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 4 Apr 2021 04:15:03 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=LG6UBmpsXu9Tqh7TlCZA1xgGtiulJdhyRZOH+w24yFP9V3KsFCvjMxlMPI1YSEJeyHDasRh/xncdDCTosqQOxxACJtEyZuBw+Alefa3+dJwoHAIazi7gQwpzsJO3CSht2hBuQjS5hdd1yzdjHbSYgYm7QRAvRjGGtgAwPVVDUz8tJTn+2MEIlQg3LJKKH0/mIKu+EAD3Rrb1H4WXZ4+rSJlvy4TRPUSS7C3ptdiyXe5fVrUim+iQ4srjzXbyajzjaUOe7SSP1yWat5Cf9X3genHdA5VJ1TnTvGNoXOytLI2vpdf5wm6kDr8+rx+rKVsDwPnzAbMASQu2IHNRGvmIFQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fmQNgjiMx99q6Z1OzmeTyT7hv9BpJUpZT5QUEbgbe7Q=;
 b=flbXHVpMfghiINaLk9nwtNS8I6TrkIDV8FIO1LO7bww3qnHgJHEnULV4GXIsvaN4+mdCC7YIqgXX/GapQSkvb3QNRft57UQwAjMIssW+gqzfzocQSLwdglsUi9xOfNTEEagbiKMHdA0FH1954YSGWwxWcg4EzqrEhHxpvpdIr41u6nY74zGEDfLp+MkftmQf4ZCBGYtfrDISbOw1iqocuxHKXd9RMcy3FwMiVcgDIPLv8mbib9H0PbB+b5P62/L30+5BBS1eKrbcHhikusHnHmyQ52Y7UjVmkdiG7RKfDUGEQ4Sf3mIOlE8MWXu2nonSnB35f0i/+TA+nLXGSW81Gw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.34) smtp.rcpttodomain=embeddedor.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fmQNgjiMx99q6Z1OzmeTyT7hv9BpJUpZT5QUEbgbe7Q=;
 b=YnGo6dniH6BOIFi132rT8Tu8HeTFZhPbe1dyLWinVmIYeRUZ0ECb9c5YoPSC73kdp93fG6zjspozsaKRaJ7JtlziHX4jNdFD43oXeb6Nwc2vaxApjzEEJqJOUaxvdRYb3gTqi7exMwuT97CLrLz5lqi/Z4G6sNGYY/n9rk1Gy/NtXpbddb6LkCT1HNbJ++2xm43T1t8i7p5rxLe7QRs9bdb81IqBg2Nqbraw6edZsX5v+sIceVIT9RzRrxdJhSv4ewijLV1jU7/Efi2evyt16EzM5ob3On/I0EtiWByc2TIb7LtRx9QimAKIx38bTubxxPaCo7ZPkEr0D9jGCn2PXg==
Received: from DM6PR12CA0025.namprd12.prod.outlook.com (2603:10b6:5:1c0::38)
 by BY5PR12MB4161.namprd12.prod.outlook.com (2603:10b6:a03:209::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3999.28; Sun, 4 Apr
 2021 08:14:57 +0000
Received: from DM6NAM11FT039.eop-nam11.prod.protection.outlook.com
 (2603:10b6:5:1c0:cafe::18) by DM6PR12CA0025.outlook.office365.com
 (2603:10b6:5:1c0::38) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3999.26 via Frontend
 Transport; Sun, 4 Apr 2021 08:14:57 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.34)
 smtp.mailfrom=nvidia.com; embeddedor.com; dkim=none (message not signed)
 header.d=none;embeddedor.com; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.34 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.34; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.34) by
 DM6NAM11FT039.mail.protection.outlook.com (10.13.172.83) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.3999.28 via Frontend Transport; Sun, 4 Apr 2021 08:14:56 +0000
Received: from dev-r-vrt-156.mtr.labs.mlnx (172.20.145.6) by
 HQMAIL107.nvidia.com (172.20.187.13) with Microsoft SMTP Server (TLS) id
 15.0.1497.2; Sun, 4 Apr 2021 08:14:52 +0000
From:   Danielle Ratson <danieller@nvidia.com>
To:     <netdev@vger.kernel.org>
CC:     <davem@davemloft.net>, <kuba@kernel.org>, <eric.dumazet@gmail.com>,
        <andrew@lunn.ch>, <mkubecek@suse.cz>, <f.fainelli@gmail.com>,
        <acardace@redhat.com>, <irusskikh@marvell.com>,
        <gustavo@embeddedor.com>, <magnus.karlsson@intel.com>,
        <ecree@solarflare.com>, <idosch@nvidia.com>, <jiri@nvidia.com>,
        <mlxsw@nvidia.com>, Danielle Ratson <danieller@nvidia.com>
Subject: [PATCH net v2 0/2] Fix link_mode derived params functionality
Date:   Sun, 4 Apr 2021 11:14:31 +0300
Message-ID: <20210404081433.1260889-1-danieller@nvidia.com>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [172.20.145.6]
X-ClientProxiedBy: HQMAIL105.nvidia.com (172.20.187.12) To
 HQMAIL107.nvidia.com (172.20.187.13)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 06cdc5cd-f6e2-46ca-453d-08d8f741bbd7
X-MS-TrafficTypeDiagnostic: BY5PR12MB4161:
X-Microsoft-Antispam-PRVS: <BY5PR12MB41613AA0F3FE4D1C7E1947C8D8789@BY5PR12MB4161.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 44XCqtxiFc4R30LgZRF/qF0DY76SnmytDGWeVeXIaLeSaX0NJWpqxFNBlxsBgbcvln+mJhV/RzwcFtBO0JQ5daRWAg8h7OxEjH5zm85MSwk7JfvO6wBPT1nTOrtRcGyVBnlKjVhrigvQw3zgfAbETHhBVfanWW0wv0OwV5lzmJJ4GSPgEbRuldChmDm5aLvWtytrDQZrAoqNvFu+zc4jkiFaX8iCco2sqER/IQ2/4CD/cPtZbyY6vf2ToaLowz0mjDjerLc7fkkOuh5I/BsgcSj2sTekzEYg93XRk79UdgpuYRZRhudKQFyD/oSMGEcg3d8k+Ek3nL09QRaxbJdMwkjEGLCHe120eUheTgECNgxx3+NyoFTl6kXjJJi98u3Hr3B709RFL5fW9NCKGt4x0tVjX74/JR0/wDf+iuZOSTNZI9zEW4zV2u5Ng+L/OGAruDYB2LYsug4m+8KrjoUh+5oclHkZNj0yPEFNE15tti+Ph3ITLae3W4FqT0LbcWmZrEZqgkkS2WjiFw4pCLiVFSXMZ8h93oVzwPZSTb4TpReUseNh03a9sYXg4jdurv6C+1NTnQrj3iOifHJr4lZm4CwnWqUqcYkAQe23106E72yr+4CV4XAiL+0t9WGpoEmYmNF9YwKkivIOpZv1n++q0Lc4dmnvW5NmGIJjL/cIa1o=
X-Forefront-Antispam-Report: CIP:216.228.112.34;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid03.nvidia.com;CAT:NONE;SFS:(4636009)(136003)(396003)(346002)(376002)(39860400002)(36840700001)(46966006)(356005)(186003)(26005)(6666004)(4326008)(336012)(16526019)(83380400001)(426003)(36756003)(82310400003)(6916009)(70206006)(316002)(5660300002)(36906005)(47076005)(54906003)(36860700001)(2906002)(2616005)(86362001)(7636003)(107886003)(1076003)(8676002)(70586007)(82740400003)(7416002)(8936002)(478600001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Apr 2021 08:14:56.8208
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 06cdc5cd-f6e2-46ca-453d-08d8f741bbd7
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.34];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT039.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR12MB4161
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Currently, link_mode parameter derives 3 other link parameters, speed,
lanes and duplex, and the derived information is sent to user space.

Two bugs were found in that functionality.
First, some drivers clear the 'ethtool_link_ksettings' struct in their
get_link_ksettings() callback and cause receiving wrong link mode
information in user space. And also, some drivers can report random
values in the 'link_mode' field and cause general protection fault.

Second, the link parameters are only derived in netlink path so in ioctl
path, we don't any reasonable values.

Patch #1 solves the first problem by introducing a new capability bit for
supporting link_mode in driver.
Patch #2 solves the second one, by deriving the parameters in ioctl path
as well.

v2:
	* Add patch #2.
	* Introduce 'cap_link_mode_supported' instead of adding a
	  validity field to 'ethtool_link_ksettings' struct in patch #1.

Danielle Ratson (2):
  ethtool: Add link_mode parameter capability bit to ethtool_ops
  ethtool: Derive parameters from link_mode in ioctl path

 .../mellanox/mlxsw/spectrum_ethtool.c         |  1 +
 include/linux/ethtool.h                       |  5 ++-
 net/ethtool/ioctl.c                           | 34 ++++++++++++++-----
 3 files changed, 31 insertions(+), 9 deletions(-)

-- 
2.26.2


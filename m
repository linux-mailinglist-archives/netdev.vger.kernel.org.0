Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7A2F938E88D
	for <lists+netdev@lfdr.de>; Mon, 24 May 2021 16:20:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232921AbhEXOV0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 May 2021 10:21:26 -0400
Received: from mail-dm6nam10on2076.outbound.protection.outlook.com ([40.107.93.76]:28344
        "EHLO NAM10-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S232486AbhEXOVZ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 24 May 2021 10:21:25 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=d6AiOBZ1PFclfkKc+Qu47b0HvSsLqgiR7aMHXYKBL7x82RpsY5UQ/coRd1m/5vIPLyhqxCUbdESjCmRUNhZBdhKdZ7Xe8O1Q5GyeogPgcR8aTMFGuBqwA2M9UTIXNmXa0Qkfue9WAr4mxJeN0GtvC6NPZV+6VcC47sZQJxAJqF5a/RSWVICBDBjgX3b+f6xrCfhhIu5Nla8l99kHCtbCnTgg541z1mtR3rvauTc44fPAakbvnypTvkoHELVnkQ1pSzHLD4mLQi8fNRiUhNPeOLfBVDXxlbXkCwD9d4WkEOaOFWIKtGmcTO72tkzV3iql78AZ5u+HrXOPop+++kv/Sg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=yHNtu+ymwLNRPH0yuvpSKxkrHoMRwZwDYFGvuLLWkUw=;
 b=GUtbASxwnWNLnMFottYPJB3PZmXNpVLUIwkQi//0PEfrmQuEZUOd2vbZPlXyClDCdmTeKRzVEa6ZA4f6rPTHFeGHc395m/Vk9EPMa21+p5T4uDIUh9gY0Jmbmh56YUvgyHreCAxbGDj6DxHpgxu1PuhdcOH7Cu0zPvG5oGhXDHq3AtBNmvoNySD8JoZzNE8ltv1XQwpom4X0OfIxgMPLU8JyU7Ize4k2j3BT1cxrsea805vUa2Gn/MKXp8R6G0vOJwF6b/KYAkhGwq+XGb7Vj/zbhq1MV9ahZS1vRD6fs2wYib0vmzMZIOBZdum0CrnEWUeJ7u16QWzxNi1FkC231w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.34) smtp.rcpttodomain=thebollingers.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=yHNtu+ymwLNRPH0yuvpSKxkrHoMRwZwDYFGvuLLWkUw=;
 b=TDRxbFNRSzNK8mo2EZhRzWy+uY+3Di9efxUSaNvGYvpDCoi7XPXINZj1kZqJ6PSpfSFpoMK2J3TbT9qma0S84yVtOL9AidpoS3vQ7PXMN0MZ3HwON8RPAGrfSE3I0n2nCa473AF8SS7QohdK1Xy0hO0oQRMzfRnD+Z/zii1Hqo8/mOSfGHGetNZJA1bb9u2gD4iVM5m27gyPP+YIG3segH8Bq3YsUK64U6aXNEFVtpDruaPb3PV/sPeeefZToNY9p7RRQ3oRvDsQ2viEmy/U2WRsDBvdgqPFijfFGDXMAKrn9mx5dFAV0EjxLmpJGt8vHW9wD0JbA4r4Xq6DIHpiRQ==
Received: from BN0PR04CA0155.namprd04.prod.outlook.com (2603:10b6:408:eb::10)
 by CH2PR12MB3957.namprd12.prod.outlook.com (2603:10b6:610:2c::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4150.23; Mon, 24 May
 2021 14:19:56 +0000
Received: from BN8NAM11FT059.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:eb:cafe::1a) by BN0PR04CA0155.outlook.office365.com
 (2603:10b6:408:eb::10) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4150.23 via Frontend
 Transport; Mon, 24 May 2021 14:19:56 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.34)
 smtp.mailfrom=nvidia.com; thebollingers.org; dkim=none (message not signed)
 header.d=none;thebollingers.org; dmarc=pass action=none
 header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.34 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.34; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.34) by
 BN8NAM11FT059.mail.protection.outlook.com (10.13.177.120) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4129.25 via Frontend Transport; Mon, 24 May 2021 14:19:56 +0000
Received: from HQMAIL107.nvidia.com (172.20.187.13) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Mon, 24 May
 2021 14:19:55 +0000
Received: from vdi.nvidia.com (172.20.145.6) by mail.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Mon, 24 May 2021 14:19:53 +0000
From:   Moshe Shemesh <moshe@nvidia.com>
To:     Michal Kubecek <mkubecek@suse.cz>, Andrew Lunn <andrew@lunn.ch>,
        "Jakub Kicinski" <kuba@kernel.org>,
        Don Bollinger <don@thebollingers.org>, <netdev@vger.kernel.org>
CC:     Vladyslav Tarasiuk <vladyslavt@nvidia.com>,
        Moshe Shemesh <moshe@nvidia.com>
Subject: [PATCH ethtool v2 0/4] Extend module EEPROM API
Date:   Mon, 24 May 2021 17:18:56 +0300
Message-ID: <1621865940-287332-1-git-send-email-moshe@nvidia.com>
X-Mailer: git-send-email 1.8.4.3
MIME-Version: 1.0
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: ef0e943d-4789-44b0-8888-08d91ebf01c9
X-MS-TrafficTypeDiagnostic: CH2PR12MB3957:
X-Microsoft-Antispam-PRVS: <CH2PR12MB3957126963321BA6500BAF07D4269@CH2PR12MB3957.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6790;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: htcQjGWd2EUJQEUzVNUtFvvrSE5GsMNETLCU5sEoEJsPmVU52pTJbDt+Ztnwt7J552UhAZXaMFrUWE0RG+QhkzmFbZez4PKLe2eoXaNdtLLKZFp9emZUjP/9MAndXN/MAKtrpLjLEfgMje/uXWUMGO6DJCNpEL2CQKgwT+fPUiCrpZRluYyuE6JUYnU+d+HmU1m+EFIzPADyhPtbgHyzRzIj+NZarWmnLF7BWjCXKhxHx4zj7d75673m05PE4yiOFDo5rEYBpEotq9Xvp6jWM6S/4vwSj5bPBingO73olR95Rcg3KaoBfsF8l/OVt6k5mtS9MJogt/BlCZCBf7c5MqIxvwv7oieVd9GMYT3Js3obDiqUO+VzTgKawUtXr8l+QQF8M8Uk3Vu9SNKnck6LIu+lDhpxRKx+CwHLcIHZCbKRRo2esbpouQQSo2/Gp9dYxMqm8gSbsdiinU1vs8CuOfmgYUND0C3LJMmLa4CDdKLijbkwMJyPcBEmacH7hH/tcCobJvEcuBEujECYeVl2MrZzDusWQFY5IM1zsQn28nBoeh7cRhFiyLhihqZhTnFsvFQd4CIejNnhL5cI1bSHDME049zMCnCR2iaX+2FsIRdU3nzAJgwhKQ/SdDDZQ/DDz7Ue6MtWdc/MZ6xZxVNZfI6PnsKd71pv8A5DA4RCaYU=
X-Forefront-Antispam-Report: CIP:216.228.112.34;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid03.nvidia.com;CAT:NONE;SFS:(4636009)(346002)(376002)(39860400002)(396003)(136003)(46966006)(36840700001)(83380400001)(336012)(86362001)(82310400003)(2906002)(7696005)(2616005)(426003)(8936002)(47076005)(82740400003)(70586007)(356005)(70206006)(107886003)(478600001)(316002)(5660300002)(8676002)(110136005)(186003)(4326008)(7636003)(36756003)(36860700001)(36906005)(54906003)(26005);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 May 2021 14:19:56.5268
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: ef0e943d-4789-44b0-8888-08d91ebf01c9
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.34];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT059.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR12MB3957
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Ethtool supports module EEPROM dumps via the `ethtool -m <dev>` command.
But in current state its functionality is limited - offset and length
parameters, which are used to specify a linear desired region of EEPROM
data to dump, is not enough, considering emergence of complex module
EEPROM layouts such as CMIS 4.0.

Moreover, CMIS 4.0 extends the amount of pages that may be accessible by
introducing another parameter for page addressing - banks. Besides,
currently module EEPROM is represented as a chunk of concatenated pages,
where lower 128 bytes of all pages, except page 00h, are omitted. Offset
and length are used to address parts of this fake linear memory. But in
practice drivers, which implement get_module_info() and
get_module_eeprom() ethtool ops still calculate page number and set I2C
address on their own.

This series adds support in `ethtool -m` of dumping an arbitrary page
specified by page number, bank number and I2C address. Implement netlink
handler for `ethtool -m` in order to make such requests to the kernel
and extend CLI by adding corresponding parameters.
New command line format:
 ethtool -m <dev> [hex on|off] [raw on|off] [offset N] [length N] [page N] [bank N] [i2c N]

Netlink infrastructure works on per-page basis and allows dumps of a
single page at once. But in case user requests human-readable output,
which currently may require more than one page, userspace can make such
additional calls to kernel on demand and place pages in a linked list.
It allows to get pages from cache on demand and pass them to refactored
SFF decoders.

Change Log:
v1 -> v2:
- Changed offset defines to specification values.
- Added default offset value (128) if page number is specified.
- Fixed return values.
- Removed page_available()

Vladyslav Tarasiuk (4):
  ethtool: Add netlink handler for getmodule (-m)
  ethtool: Refactor human-readable module EEPROM output for new API
  ethtool: Rename QSFP-DD identifiers to use CMIS 4.0
  ethtool: Update manpages to reflect changes to getmodule (-m) command

 Makefile.am             |   3 +-
 qsfp-dd.c => cmis4.c    | 220 +++++++++++----------
 cmis4.h                 | 128 +++++++++++++
 ethtool.8.in            |  14 ++
 ethtool.c               |   4 +
 internal.h              |  12 ++
 list.h                  |  34 ++++
 netlink/desc-ethtool.c  |  13 ++
 netlink/extapi.h        |   2 +
 netlink/module-eeprom.c | 416 ++++++++++++++++++++++++++++++++++++++++
 qsfp-dd.h               |  29 +--
 qsfp.c                  | 130 +++++++------
 qsfp.h                  |  51 ++---
 sff-common.c            |   3 +
 sff-common.h            |   3 +-
 15 files changed, 870 insertions(+), 192 deletions(-)
 rename qsfp-dd.c => cmis4.c (55%)
 create mode 100644 cmis4.h
 create mode 100644 list.h
 create mode 100644 netlink/module-eeprom.c

-- 
2.18.2


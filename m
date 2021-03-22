Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EDF51344CE7
	for <lists+netdev@lfdr.de>; Mon, 22 Mar 2021 18:12:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231989AbhCVRMD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Mar 2021 13:12:03 -0400
Received: from mail-bn8nam11on2075.outbound.protection.outlook.com ([40.107.236.75]:40480
        "EHLO NAM11-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229979AbhCVRLe (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 22 Mar 2021 13:11:34 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Bfb5eRziHFBgndcm9p+hmQZRfgYHu0ADSAh5YmNfc6iMlo+h1IDnMlfOByVMvWT3HscK8cz8hPeqqWr1E6DlAXDD+Hq8oh3WrvFV3Ob1LbM3gYZz3e8QKmO5NM1rCso43F7rfS9FzwxnHva2Y4e94eJrVWdpcRK4Z4dvteiTYkVtV4RFKexp3wZeRtODX41NhBskMdjdKqacqCB9r3IogzEFou3BqMCZFycWKpWpDomRzwbqxMsZ2z8ya+/IL99e/SFNBh8juxyp/bVNxH+moHxI0zEYt8IXz9JGfKUj4zNnyeXs693GqJTYe/rpcyJ0BURXB6WRqgbTp3YqyY8Yqg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tEFhN60rgvuX5OKgiPbPEqXHokttXPV6hafCAunPo1E=;
 b=O4shCEDP76fbLVb49X9ghQj6b+FxKRyUXOnPR2vOUQ+BGGUK0NmWvCXHJdXAT5s1qk7xOQHJaBkiAtYlXYm15pOAwg0aYMWst1AHBcNAdj4dROh1fxJ7RzSDE12dNyBqUczHx0PttS2iiyEVcun6UJhCsSyVZjAX2ZdT/UVqm0515eGQ5pzGNYUmRuY7PiEsM23r4PD/r88/vB7nlvZmsZptZndE7p5DdXM11STfMd75ZXJcYUajm+rfsWzRWGoO0SDHCKUkOEPD7Y7Tjgqo7bt8d/NUb5wcoV4iRcSmZd4qDaGIabPZgn7toAin4cmerjxhFXHGABqQx5+XeLgqEg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.36) smtp.rcpttodomain=suse.cz smtp.mailfrom=nvidia.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tEFhN60rgvuX5OKgiPbPEqXHokttXPV6hafCAunPo1E=;
 b=Z72NGWY0K/xeafgSyQc8QTDYPvbkHe/WG08uWu9CC8lFm2Wnb6+Evj5ra4zIexN5FjPrmyW4lEVFsa5E/z5H7hD4ITfq+cTpinNgy54HQOrAlWFU2EtYsWj7J3maLs5qEq9olcxfRlgdoPs063jbscDyC28qHn13zQYVIyIKSqMlQOzpz1kVFLTv/btqHiv2gRUmX0GPtfa6SMo8fWTO5jWcNu1PcDcIHALlbf7MWIYZTS8ZWAJRY14yc0EduS6W31JSUNBECgvQ816MV01mzBbhb2awjRwG66U3IZStDB4Jk6SrwmfAd3bq/6HKFkSMPcb/EnV1DYpJDSnYG2TYvQ==
Received: from DM6PR02CA0157.namprd02.prod.outlook.com (2603:10b6:5:332::24)
 by SN6PR12MB4736.namprd12.prod.outlook.com (2603:10b6:805:e0::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3955.18; Mon, 22 Mar
 2021 17:11:32 +0000
Received: from DM6NAM11FT012.eop-nam11.prod.protection.outlook.com
 (2603:10b6:5:332:cafe::61) by DM6PR02CA0157.outlook.office365.com
 (2603:10b6:5:332::24) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3955.18 via Frontend
 Transport; Mon, 22 Mar 2021 17:11:32 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.36)
 smtp.mailfrom=nvidia.com; suse.cz; dkim=none (message not signed)
 header.d=none;suse.cz; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.36 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.36; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.36) by
 DM6NAM11FT012.mail.protection.outlook.com (10.13.173.109) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.3955.18 via Frontend Transport; Mon, 22 Mar 2021 17:11:32 +0000
Received: from HQMAIL107.nvidia.com (172.20.187.13) by HQMAIL101.nvidia.com
 (172.20.187.10) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Mon, 22 Mar
 2021 17:11:31 +0000
Received: from vdi.nvidia.com (172.20.145.6) by mail.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Mon, 22 Mar 2021 17:11:29 +0000
From:   Moshe Shemesh <moshe@nvidia.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, Andrew Lunn <andrew@lunn.ch>,
        Adrian Pop <pop.adrian61@gmail.com>,
        "Michal Kubecek" <mkubecek@suse.cz>,
        Don Bollinger <don@thebollingers.org>, <netdev@vger.kernel.org>
CC:     Vladyslav Tarasiuk <vladyslavt@nvidia.com>,
        Moshe Shemesh <moshe@nvidia.com>
Subject: [RFC PATCH V4 net-next 0/5] ethtool: Extend module EEPROM dump API
Date:   Mon, 22 Mar 2021 19:11:10 +0200
Message-ID: <1616433075-27051-1-git-send-email-moshe@nvidia.com>
X-Mailer: git-send-email 1.8.4.3
MIME-Version: 1.0
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 319b2087-155d-4b92-3e29-08d8ed558a70
X-MS-TrafficTypeDiagnostic: SN6PR12MB4736:
X-Microsoft-Antispam-PRVS: <SN6PR12MB4736E6B2FD739135E407F585D4659@SN6PR12MB4736.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6790;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: isYkgu36I0equtr9Vpb2AXWHiL8+NSwaxM0Vw77+rCvsaZOUlnmLNtaSJ0eZd38MEpRZNo1AsFjZprK89WijhTIDrLZFSjUwg6JmfzqxuDAmqzjA/sBa4ym+pooNI7MLOFOQrzNPPiKVJjsDMMx8ogpLJCxpWn/GyWAyQ2d64tZm8aMsqHAyc20Dz9sl347vKTUK1po2XsJvWPuPboCpptDWrogjv9WvOJlXEG6GzDz90km+g23ZsVig/3vMp32o4eQwhM221AqVzP7jrPbrUAWtDPOmnkOs/RIuknN82rSGSb6ZS6U7+cKhAH8Q+qVtrnXK5OHwlAMScSH5vJvL1CiG4amYKpcJqzluA/1qWcRpP34oIM61k9xRWUpLc5Lo8gx2Pd5cWV6qttRUO2QTLr8m14MwmiAQx1F6SGfPQ5PhGqIwu1eeBHqoarRI6LtWjwUauAe1DJaLXun6DwHuC0rudf5dR4wBou3OQXtH599T6QVzLagP1WGi3wlFVQVvoc4NQfXFoA3mhGRnNBYxAJ2FTURwoFmsRkmuD9LSfvfvqi+oI6VA0hLL2vxBeHBySreTy6xp6GA5yfSX1Lc8F0HflGlBzbs9Fy45xRKMX+KO99qm2Qd2E9vDB11h/G1DEeQsds3SX+RF0fTGmxKfR2HTwouENp+YCrO8LVVzhmM=
X-Forefront-Antispam-Report: CIP:216.228.112.36;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid05.nvidia.com;CAT:NONE;SFS:(4636009)(376002)(346002)(136003)(396003)(39860400002)(36840700001)(46966006)(4326008)(82310400003)(316002)(36906005)(2906002)(70206006)(478600001)(2616005)(54906003)(86362001)(83380400001)(70586007)(110136005)(8676002)(36860700001)(8936002)(26005)(7696005)(7636003)(36756003)(336012)(6666004)(426003)(47076005)(186003)(107886003)(82740400003)(356005)(5660300002);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Mar 2021 17:11:32.2570
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 319b2087-155d-4b92-3e29-08d8ed558a70
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.36];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT012.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR12MB4736
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Ethtool supports module EEPROM dumps via the `ethtool -m <dev>` command.
But in current state its functionality is limited - offset and length
parameters, which are used to specify a linear desired region of EEPROM
data to dump, is not enough, considering emergence of complex module
EEPROM layouts such as CMIS 4.0.
Moreover, CMIS 4.0 extends the amount of pages that may be accessible by
introducing another parameter for page addressing - banks.

Besides, currently module EEPROM is represented as a chunk of
concatenated pages, where lower 128 bytes of all pages, except page 00h,
are omitted. Offset and length are used to address parts of this fake
linear memory. But in practice drivers, which implement
get_module_info() and get_module_eeprom() ethtool ops still calculate
page number and set I2C address on their own.

This series tackles these issues by adding ethtool op, which allows to
pass page number, bank number and I2C address in addition to offset and
length parameters to the driver, adds corresponding netlink
infrastructure and implements the new interface in mlx5 driver.

This allows to extend userspace 'ethtool -m' CLI by adding new
parameters - page, bank and i2c. New command line format:
 ethtool -m <dev> [hex on|off] [raw on|off] [offset N] [length N] [page N] [bank N] [i2c N]

The consequence of this series is a possibility to dump arbitrary EEPROM
page at a time, in contrast to dumps of concatenated pages. Therefore,
offset and length change their semantics and may be used only to specify
a part of data within a page, which size is currently limited to 256
bytes.

As for backwards compatibility with get_module_info() and
get_module_eeprom() pair, the series addresses it as well by
implementing a fallback mechanism. As mentioned earlier, drivers derive
a page number from 'global' offset, so this can be done vice versa
without their involvement thanks to standardization. If kernel netlink
handler of 'ethtool -m' command detects that new ethtool op is not
supported by the driver, it calculates offset from given page number and
page offset and calls old ndos, if they are available.

Change log:
v3 -> v4:
- Renamed many identifiers to use 'eeprom' instead of 'eeprom_data'.
- Renamed netlink enums and defines to use 'MODULE_EEPROM' instead of
   'EEPROM_DATA'.
- Renamed struct ethtool_eeprom_data to ethtool_module_eeprom.
- Added MODULE_EEPROM_MAX_OFFSET (257 * 256) macro and check global offset
    against it to avoid overflow.
- Removed ndo pointer check from _parse_request().
- Removed separate length element from netlink response.
- Limited reads to 128 bytes without crossing half page bound.

v2 -> v3:
- Removed page number limitations
- Added length limit when page is present in fallback
- Changed page, bank and i2c_address type to u8 all over the patchset
- Added 0x51 I2C address usage increasing offset by 256 for SFP

v1 -> v2:
- Limited i2c_address values by 127
- Added page bound check for offset and length
- Added defines for these two points
- Added extack to ndo parameters
- Moved ethnl_ops_begin(dev) and set error path accordingly



Vladyslav Tarasiuk (5):
  ethtool: Allow network drivers to dump arbitrary EEPROM data
  net/mlx5: Refactor module EEPROM query
  net/mlx5: Implement get_module_eeprom_by_page()
  net/mlx5: Add support for DSFP module EEPROM dumps
  ethtool: Add fallback to get_module_eeprom from netlink command

 Documentation/networking/ethtool-netlink.rst  |  32 ++-
 .../ethernet/mellanox/mlx5/core/en_ethtool.c  |  44 ++++
 .../net/ethernet/mellanox/mlx5/core/port.c    | 101 +++++---
 include/linux/ethtool.h                       |  33 ++-
 include/linux/mlx5/port.h                     |  12 +
 include/uapi/linux/ethtool_netlink.h          |  19 ++
 net/ethtool/Makefile                          |   2 +-
 net/ethtool/eeprom.c                          | 231 ++++++++++++++++++
 net/ethtool/netlink.c                         |  10 +
 net/ethtool/netlink.h                         |   2 +
 10 files changed, 454 insertions(+), 32 deletions(-)
 create mode 100644 net/ethtool/eeprom.c

-- 
2.18.2


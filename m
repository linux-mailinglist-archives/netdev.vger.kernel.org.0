Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2C8073494BF
	for <lists+netdev@lfdr.de>; Thu, 25 Mar 2021 15:58:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231225AbhCYO5f (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Mar 2021 10:57:35 -0400
Received: from mail-bn8nam12on2069.outbound.protection.outlook.com ([40.107.237.69]:1249
        "EHLO NAM12-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S230377AbhCYO5M (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 25 Mar 2021 10:57:12 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=LNQEpBzbi12FkahgGuc9/U7cJiAOxDQVEtOYK4jYjDBo4vj2pkKlGbKGmAe8mx4adbtS7t0urCjGYo6yV6oOSePUNbxhab5wkTwo3pPdFO5/LFQhbcjXQ24M54aiZL9ZSuJVw496iXMaPhKSbQuQf263EBA3EsIkpPnCOahGWbpDKTojrWL9353yDS5w2rM02NQTWa7qrFmUAlM+3T74GDpSA9scOPEWsQUjipQLngsK5AukVabProHgPgDAv0uGbx6zVY50Z1JUpLCLJ35yFwI85y3X6LEaOd4lEE+Rk0m8LZF7ZWlxjlNYEc9cdBRlsIxugbBoTAg6ZDfpod2xUw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YfhpfY2V46EhcB5ZkYZPSXWteLkvid6Adu7QOp/5M7Q=;
 b=L/accHl7btkR8OIPSXYidJtqMOsxH7NR/qWjzKMwohzqqZdjrvEb/DUZhW9IEHKto1uowu8kb8tgrjiJTWSQq1ly9cDIJKR7Ugu+TUT6wNsbcDQwXzfrKp39ZEsPj2mCnYkGPJCU8J+aMo3u6LbzxdDOAD6lNeCguiHfh4FCo+6hmguWy7j23d1u6rqf443+X0bpiAldi/uE/1EbV5bDcGnsWzK6b/L2edTiQDB9C9EheWWDKir5ypjKc6lixXzJBFbH3eRHe/J6wSkj3sBqS30GDt8B2iW9mVcfki498pLgqzsUawVLjmnPOQ0RdfnRRBxKdISYeFLQTjQsaRJ0rg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.32) smtp.rcpttodomain=suse.cz smtp.mailfrom=nvidia.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YfhpfY2V46EhcB5ZkYZPSXWteLkvid6Adu7QOp/5M7Q=;
 b=tspf2Pp2ZMyRrOOphJz8vXcYD1es5mnY7DqPx2TtJvVCM1zX8cMvQDvXsAdH0/DqbSTySZyGMAdq9vdU8n/Xm7TLAmcD8JOwCn2JYDfRNb7/gqt6L6OESAOl/JTwPnNxRhmxeO80klIoR1wMvDdXH43vdTWD/VyD/Rg/C/ErFZWYailbyGNHA1mMPGmBs9+ZQhdO0ZhKLdRbnwdIR35v3ZLthkZaSHqoNnHxhSrvEjqha9KDo9WuYK4uKMTGXzPNl1Rui7u8YW7ku0aTiElGyerU9fw83Frx2tQhomeLWKY0R6cnQdcp2USZr5jABs36IdI2B4uQIhy7G7lex5dDCA==
Received: from DM5PR06CA0034.namprd06.prod.outlook.com (2603:10b6:3:5d::20) by
 CH2PR12MB4149.namprd12.prod.outlook.com (2603:10b6:610:7c::13) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3977.24; Thu, 25 Mar 2021 14:57:11 +0000
Received: from DM6NAM11FT026.eop-nam11.prod.protection.outlook.com
 (2603:10b6:3:5d:cafe::41) by DM5PR06CA0034.outlook.office365.com
 (2603:10b6:3:5d::20) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3977.25 via Frontend
 Transport; Thu, 25 Mar 2021 14:57:10 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.32)
 smtp.mailfrom=nvidia.com; suse.cz; dkim=none (message not signed)
 header.d=none;suse.cz; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.32 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.32; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.32) by
 DM6NAM11FT026.mail.protection.outlook.com (10.13.172.161) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.3955.18 via Frontend Transport; Thu, 25 Mar 2021 14:57:10 +0000
Received: from HQMAIL109.nvidia.com (172.20.187.15) by HQMAIL109.nvidia.com
 (172.20.187.15) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Thu, 25 Mar
 2021 07:57:09 -0700
Received: from vdi.nvidia.com (172.20.145.6) by mail.nvidia.com
 (172.20.187.15) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Thu, 25 Mar 2021 07:57:07 -0700
From:   Moshe Shemesh <moshe@nvidia.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, Andrew Lunn <andrew@lunn.ch>,
        Adrian Pop <pop.adrian61@gmail.com>,
        "Michal Kubecek" <mkubecek@suse.cz>,
        Don Bollinger <don@thebollingers.org>, <netdev@vger.kernel.org>
CC:     Vladyslav Tarasiuk <vladyslavt@nvidia.com>,
        Moshe Shemesh <moshe@nvidia.com>
Subject: [RFC PATCH V5 net-next 0/5] ethtool: Extend module EEPROM dump API
Date:   Thu, 25 Mar 2021 16:56:50 +0200
Message-ID: <1616684215-4701-1-git-send-email-moshe@nvidia.com>
X-Mailer: git-send-email 1.8.4.3
MIME-Version: 1.0
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 19d0cb6f-34a1-4a54-4c62-08d8ef9e446a
X-MS-TrafficTypeDiagnostic: CH2PR12MB4149:
X-Microsoft-Antispam-PRVS: <CH2PR12MB4149A8B6B84251E8FFF0514FD4629@CH2PR12MB4149.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7219;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: /5v/7hfzWqtkueM3ECTvcYI80bThVTwKWS7VvT6nC+ThFToZOF41MEtk5SstYbRKqG6pRcV0DSo4ZAvgptkYTjAOpQ7xxb3YFlEcx6myueME0O6fiPeTTqfdLogFqdxH5Ooo9PoBn5KigKDVaFj6fPnaEEhPm0q1Xj0Ik8NlvjwwVSat8CYqUwY3kGp67t/iw622NA/RFRenV/MJuwY+demYPSJBR7/Hdj9Vw/QslNm1cysQdbKyiLkPeHuUhlQJb3FjfzQ1wDoRmfdtFf7BqUkGvFaqyRheeeDL78Tig4eryJ7cLdbsuljE4tynO9ff8JtnSoTb7OdeWoaTCKlC9MMQ+Y0+y3O534sVfeJGSTVGhkANzK7fkRzLOFCCee1dHKsHliawDDtelRpOR6D85aQZ2oIjIrUlrOrYo3kM0NqfHXHEHxZjXUliCHGMimxphDTmouQVLh0NyaI7rfA386oojXkFkbODadNsPEybhkzyOLUgKimOEWPvIbnGHjDvfpUOt/uHaCOy6dCW6D8gI8iqqqkccHcjZptMpG7b9okqW/Y4nIFm3sjUVAf61vsb54NZi2DsQXqJIIrPubQHsL9beEJRGL1l5dxL7Gc2lrvf5+0BLYnqvXJYbYVd2TFz8f4/brMr5Gtru9XTKlBGYFh6MKkifjunFt99fT8oS1U=
X-Forefront-Antispam-Report: CIP:216.228.112.32;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid01.nvidia.com;CAT:NONE;SFS:(4636009)(346002)(376002)(39860400002)(396003)(136003)(36840700001)(46966006)(336012)(8936002)(86362001)(186003)(107886003)(36860700001)(7636003)(82310400003)(47076005)(82740400003)(83380400001)(8676002)(356005)(36756003)(26005)(426003)(2906002)(4326008)(70206006)(2616005)(110136005)(54906003)(316002)(5660300002)(478600001)(6666004)(7696005)(70586007);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Mar 2021 14:57:10.3584
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 19d0cb6f-34a1-4a54-4c62-08d8ef9e446a
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.32];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT026.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR12MB4149
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
a part of data within half page boundary, which size is currently limited
to 128 bytes.

As for drivers that support legacy get_module_info() and
get_module_eeprom() pair, the series addresses it by implementing a
fallback mechanism. As mentioned earlier, such drivers derive a page
number from 'global' offset, so this can be done vice versa without
their involvement thanks to standardization. If kernel netlink handler
of 'ethtool -m' command detects that new ethtool op is not supported by
the driver, it calculates offset from given page number and page offset
and calls old ndos, if they are available.

Change log:
v4 ->v5:
- Limited KAPI to only read 1/2 page at once.
- Redefined ETH_MODULE_EEPROM_PAGE_LEN as 128.
- Made page number mandatory for any request.
- Added extack messages for invalid parameters failures.

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

 Documentation/networking/ethtool-netlink.rst  |  36 ++-
 .../ethernet/mellanox/mlx5/core/en_ethtool.c  |  44 ++++
 .../net/ethernet/mellanox/mlx5/core/port.c    | 101 +++++---
 include/linux/ethtool.h                       |  33 ++-
 include/linux/mlx5/port.h                     |  12 +
 include/uapi/linux/ethtool_netlink.h          |  19 ++
 net/ethtool/Makefile                          |   2 +-
 net/ethtool/eeprom.c                          | 234 ++++++++++++++++++
 net/ethtool/netlink.c                         |  10 +
 net/ethtool/netlink.h                         |   2 +
 10 files changed, 461 insertions(+), 32 deletions(-)
 create mode 100644 net/ethtool/eeprom.c

-- 
2.18.2


Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 290DE35971B
	for <lists+netdev@lfdr.de>; Fri,  9 Apr 2021 10:07:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231127AbhDIIHM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Apr 2021 04:07:12 -0400
Received: from mail-eopbgr750050.outbound.protection.outlook.com ([40.107.75.50]:55776
        "EHLO NAM02-BL2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229621AbhDIIHL (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 9 Apr 2021 04:07:11 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JStIsGf2kCuM1CcJjHXM7GKZEDHF42LezZR4OV+Kknqescq4HsIl0rjTPrGv/VA01ThuRIYSMb1TR9hxNlTI4WgRTNyQfwcjqeTeykGxraCkAxsvthyQzAEg8cSWnXhoZM68pnC6k6Q5Ew5RDaLGP1q5wmRgaU87zHo6EunK81u5h6Fj4W+2DQy16HpYmsj6GGtZqSbQQMgQcjY9qpBpBNEFsDWlKbThp3m6jD89GgMWNPK8Dcx0Zc6GV9zyYPytbNWssG1Yg94vROpcfcOGAWqDAG65C5W5gJWL0ikbc+duOcmSJI3g2AIJlBZ+5c7hKt7njzX644QzfCr4XBuFPg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=J3UJUtueWNoWmVSI10qRBGUlQ4M06+ngcBdBGJUwf0E=;
 b=fHDVZqhyIG4FyhpIr22wmXxmdAkQXAouzdFsPx5R9+Ick4pzDk/X2BPfceOvyd50nj3CWJixjzVi2J1JIF9FjG3qEIE7cTi6gxvOt67BFJG6UBgdayAm1QHZFLs1f2mcSlLAgNzUuFvesiflNM+qsNIRiyPnWAuYUL6TfyaHSbGLSZr0/S+n3ZIbjnNm8lpMofW+3S97hxwzJ6yywtw6i+A54k0XJ590muZPFuvMxE0OX3a4t8iU29Thw6hfYV1PcCz3yrwdEEz/pGaqtrBLDZHk+Tf3EIjrI4Zzb9XZaQqAQQsg4Doi40e6vbpKAbSNIuo6HwGspgCTNLTRaK7YOw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.32) smtp.rcpttodomain=gmail.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=J3UJUtueWNoWmVSI10qRBGUlQ4M06+ngcBdBGJUwf0E=;
 b=D2jAiZG3G54Ppcg30vQKohcnFIEHYNiOJdWYiDt+/mjQtlLG0vlWbbpk6QFdmHpd4aGW/dWzrvSl1UTaV9bY2azGzWrvuN/1DXPmoyQF9V6pee2WPdhNtSjumqAv+g3n+9V5qx9Q8DPGf7YODa2EmsumcZuYmvw4BdxQYmCsZFBbwK0xZC1QWxNHwFW2ax+4pDQ/OyzQOhxbxBkt3ypx2/feXHuy1FPu4Q+fmJEnIDH3o2C4moLfBt7Exd1lbwRjMUWaBLh+xUpd8aNHKr3QTaPP+oOrRK79R5s+jXx+e+4N49Un1Q+6HyZP+4+mEjnQxnDCnKzvqSE9c5PePESPEA==
Received: from BN1PR12CA0001.namprd12.prod.outlook.com (2603:10b6:408:e1::6)
 by SN6PR12MB2686.namprd12.prod.outlook.com (2603:10b6:805:72::30) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3999.29; Fri, 9 Apr
 2021 08:06:57 +0000
Received: from BN8NAM11FT051.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:e1:cafe::33) by BN1PR12CA0001.outlook.office365.com
 (2603:10b6:408:e1::6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4020.16 via Frontend
 Transport; Fri, 9 Apr 2021 08:06:57 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.32)
 smtp.mailfrom=nvidia.com; gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.32 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.32; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.32) by
 BN8NAM11FT051.mail.protection.outlook.com (10.13.177.66) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4020.17 via Frontend Transport; Fri, 9 Apr 2021 08:06:57 +0000
Received: from HQMAIL109.nvidia.com (172.20.187.15) by HQMAIL109.nvidia.com
 (172.20.187.15) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Fri, 9 Apr
 2021 01:06:56 -0700
Received: from vdi.nvidia.com (172.20.145.6) by mail.nvidia.com
 (172.20.187.15) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Fri, 9 Apr 2021 01:06:54 -0700
From:   Moshe Shemesh <moshe@nvidia.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, Andrew Lunn <andrew@lunn.ch>,
        Adrian Pop <pop.adrian61@gmail.com>,
        "Michal Kubecek" <mkubecek@suse.cz>
CC:     <netdev@vger.kernel.org>,
        Vladyslav Tarasiuk <vladyslavt@nvidia.com>,
        Moshe Shemesh <moshe@nvidia.com>
Subject: [PATCH net-next 0/8] ethtool: Extend module EEPROM dump API
Date:   Fri, 9 Apr 2021 11:06:33 +0300
Message-ID: <1617955601-21055-1-git-send-email-moshe@nvidia.com>
X-Mailer: git-send-email 1.8.4.3
MIME-Version: 1.0
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: f46d19f0-4cdc-4fcc-50a3-08d8fb2e7258
X-MS-TrafficTypeDiagnostic: SN6PR12MB2686:
X-Microsoft-Antispam-PRVS: <SN6PR12MB2686981EACF3FF41A88D7F35D4739@SN6PR12MB2686.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7219;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: jl2vkODP8LTtCjw/E5IIsB4/QcGtR06qTpTfCUXd+Sxy3OIzwrTSGap4+czYS9Ad5cCJ2LPbAe1cwiRN7ca9DW8Bgoo9JA1apz3Z7Ke7EtExpasVfwDEOTQxWtoX97cZKFWSX+43sm5vXkMSspV0Uf0Iqdqi1Eew9MT+yY4fbfAXEPjWuyspFy5Owr41INMExLCrWwVD/Lqlwf6VDJa5yGSfuyAPf2Lx8joLqW11SQc6H+wIr37nI0/uPX/BN5t55YbqvX3PeDCwYUwDxb9pfo5PGO2sjG8qSA4bIcmjAmBhKS/iby0FndbcnBTHdoQwV1O8c0HS/RsPk0A1z7oGWU/+vHmAcyBZlxhP+wKTUfBQ4drUY5Vxm3Ix4xqsrgEdj6bEfRY0NfOjXDudSQRG0G/YQ021yMPbUwMCL8pbJ9GaeNY+Bwtp5vipHcFwAD4gqcew2AbRioURl+QJPQOAmBg6NlB8YPBwxjSKdWfniQQheVUrvlWgv6uoQ0rrc0DO00b1VRgUVOPYLGwg0Xd4iM3+9QN3rYonrvozpW/fezzIiib+kxeCEmpeOLHzgDCDQziemRyYs9Ib+e53US0rbPdWIC6+xdH+kXuY3Bu/qU1JVlh0nneG5vaQpRCC88QFnmEZUEeQE3G7N9TKLDSS7G/m6hykixNq1oKm3Z1H8ok=
X-Forefront-Antispam-Report: CIP:216.228.112.32;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid01.nvidia.com;CAT:NONE;SFS:(4636009)(396003)(376002)(346002)(136003)(39860400002)(46966006)(36840700001)(26005)(478600001)(82740400003)(107886003)(2616005)(7696005)(6666004)(82310400003)(86362001)(8676002)(70206006)(36756003)(7636003)(316002)(356005)(70586007)(110136005)(47076005)(36860700001)(2906002)(5660300002)(186003)(83380400001)(426003)(8936002)(54906003)(336012)(4326008);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Apr 2021 08:06:57.6584
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: f46d19f0-4cdc-4fcc-50a3-08d8fb2e7258
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.32];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT051.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR12MB2686
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
RFC v5 -> v1:
- Added support for generic SFP (by Andrew).
- Fixd fallback code by exporting functions ethtool_get_module_eeprom_call()
  and ethtool_get_module_info_call() (by Andrew).
- Fix ETH_MODULE_EEPROM_PAGE_LEN in fallback to
  ETH_MODULE_EEPROM_PAGE_LEN * 2 when accounting for high I2C.

RFC v4 -> RFC v5:
- Limited KAPI to only read 1/2 page at once.
- Redefined ETH_MODULE_EEPROM_PAGE_LEN as 128.
- Made page number mandatory for any request.
- Added extack messages for invalid parameters failures.

RFC v3 -> RFC v4:
- Renamed many identifiers to use 'eeprom' instead of 'eeprom_data'.
- Renamed netlink enums and defines to use 'MODULE_EEPROM' instead of
   'EEPROM_DATA'.
- Renamed struct ethtool_eeprom_data to ethtool_module_eeprom.
- Added MODULE_EEPROM_MAX_OFFSET (257 * 256) macro and check global offset
    against it to avoid overflow.
- Removed ndo pointer check from _parse_request().
- Removed separate length element from netlink response.
- Limited reads to 128 bytes without crossing half page bound.

RFC v2 -> RFC v3:
- Removed page number limitations
- Added length limit when page is present in fallback
- Changed page, bank and i2c_address type to u8 all over the patchset
- Added 0x51 I2C address usage increasing offset by 256 for SFP

RFC v1 -> RFC v2:
- Limited i2c_address values by 127
- Added page bound check for offset and length
- Added defines for these two points
- Added extack to ndo parameters
- Moved ethnl_ops_begin(dev) and set error path accordingly


Andrew Lunn (3):
  net: ethtool: Export helpers for getting EEPROM info
  phy: sfp: add netlink SFP support to generic SFP code
  ethtool: wire in generic SFP module access

Vladyslav Tarasiuk (5):
  ethtool: Allow network drivers to dump arbitrary EEPROM data
  net/mlx5: Refactor module EEPROM query
  net/mlx5: Implement get_module_eeprom_by_page()
  net/mlx5: Add support for DSFP module EEPROM dumps
  ethtool: Add fallback to get_module_eeprom from netlink command

 Documentation/networking/ethtool-netlink.rst  |  36 ++-
 .../ethernet/mellanox/mlx5/core/en_ethtool.c  |  44 ++++
 .../net/ethernet/mellanox/mlx5/core/port.c    | 110 ++++++--
 drivers/net/phy/sfp-bus.c                     |  20 ++
 drivers/net/phy/sfp.c                         |  25 ++
 drivers/net/phy/sfp.h                         |   3 +
 include/linux/ethtool.h                       |  33 ++-
 include/linux/mlx5/port.h                     |  12 +
 include/linux/sfp.h                           |  10 +
 include/uapi/linux/ethtool_netlink.h          |  19 ++
 net/ethtool/Makefile                          |   2 +-
 net/ethtool/common.h                          |   5 +
 net/ethtool/eeprom.c                          | 246 ++++++++++++++++++
 net/ethtool/ioctl.c                           |  14 +-
 net/ethtool/netlink.c                         |  11 +
 net/ethtool/netlink.h                         |   2 +
 16 files changed, 553 insertions(+), 39 deletions(-)
 create mode 100644 net/ethtool/eeprom.c

-- 
2.26.2


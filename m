Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 257DB33C3C5
	for <lists+netdev@lfdr.de>; Mon, 15 Mar 2021 18:13:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230502AbhCORNJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Mar 2021 13:13:09 -0400
Received: from mail-dm6nam10on2071.outbound.protection.outlook.com ([40.107.93.71]:62464
        "EHLO NAM10-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231990AbhCORM7 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 15 Mar 2021 13:12:59 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ONvWXaPX/HD63XU46p11/ykm7eNY/BvBgsPiFf8pN9f/N0FrUKdLs7W6zF5kkbi3aZUioS5RbnwSLsa4RILj/3O579xo2ZiRyZEo4dfVZhEoCh6kWpR8JnitC214SzEmNJYZiRhY95GndEQ5/p9scGwynN48+eyJHHEmW5zpQhpMpjReu0qO83sLJTmvlBrtpEFgQ1n/XpTld9KSv+O0Hi+ADy2lLxfmWOutYJODXtWaxq82nG+a+I+ECOKQHX9RnPSNNxN2pNiciXnT8cbdsTQqce7haFooPOM+ijxtWoz9VEaX+fRM+TVnl6S09o4DbGP5kHRotxJcqXhwhnVdjw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=KYqO8EcCj6urJphvEDnV4/qxLRsg9ta13zfJwV/o8s8=;
 b=P9LTiJeIPIzLSnFeC41YguNWNsZ/EOzW9rQ/f90BGWJ+7qntyWQ/RVQrlol9VDT09IWDe+CY9HHAXF/t7+ULoFOPf9DWs7LCw+KdrMdEpuGdf46HZWnjlagFrAkxAo034Dtcowe4jHrg0CJFTtbt6CquQYAh1PYAtHdt5lvzmsvU7Exux9D8NwWpuyru02i5YvXKjO72oWnoCxxPKUYTNU1dl+qiqri6CUeno9yv3achK8YkyL6fug7mp1apFGaBq7McqJQ7LfmR3tj9nKhp99OhcolWCSM6TVlYcmafCRKzzN1ccHdsw8e2PDZPfc1GzUa21hDFQoSUkcmtGAVBFQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.32) smtp.rcpttodomain=suse.cz smtp.mailfrom=nvidia.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=KYqO8EcCj6urJphvEDnV4/qxLRsg9ta13zfJwV/o8s8=;
 b=kjZv114q5RfsJSFSpuSResYIDov8RSGtn+qAIwKmiZfSNZpj+GyT4328zjIBWGivs0XTC02tfjV6W1qv7U5UfYWMngf19vnW/QY6gy/ukJ964MYm5R9diVMK5SqLvET8SKGE4BYrik9r1Fvh6EE9tQ2E4yOFjv1CJ2H72q0xk0qVqUQWEfgqBXXVWrAYtZsRvit7KI0QigtE4G+H5zxodPaH13vUNB9d9+V3NE+wK62qDVkYjOaJYoTczKbLocdTZsrulMtksbBRTP6g3qNdx15sSx67jcubEiJOCXddWov6aiQOn9NGVYYyKzK1/91FaIPNXj6hhThlAV3PmYz2sg==
Received: from DM6PR05CA0054.namprd05.prod.outlook.com (2603:10b6:5:335::23)
 by BN6PR12MB1570.namprd12.prod.outlook.com (2603:10b6:405:5::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3933.32; Mon, 15 Mar
 2021 17:12:57 +0000
Received: from DM6NAM11FT060.eop-nam11.prod.protection.outlook.com
 (2603:10b6:5:335:cafe::fe) by DM6PR05CA0054.outlook.office365.com
 (2603:10b6:5:335::23) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3955.11 via Frontend
 Transport; Mon, 15 Mar 2021 17:12:57 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.32)
 smtp.mailfrom=nvidia.com; suse.cz; dkim=none (message not signed)
 header.d=none;suse.cz; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.32 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.32; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.32) by
 DM6NAM11FT060.mail.protection.outlook.com (10.13.173.63) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.3933.31 via Frontend Transport; Mon, 15 Mar 2021 17:12:56 +0000
Received: from HQMAIL101.nvidia.com (172.20.187.10) by HQMAIL109.nvidia.com
 (172.20.187.15) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Mon, 15 Mar
 2021 17:12:55 +0000
Received: from vdi.nvidia.com (172.20.145.6) by mail.nvidia.com
 (172.20.187.10) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Mon, 15 Mar 2021 17:12:53 +0000
From:   Moshe Shemesh <moshe@nvidia.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, Andrew Lunn <andrew@lunn.ch>,
        Adrian Pop <pop.adrian61@gmail.com>,
        "Michal Kubecek" <mkubecek@suse.cz>,
        Don Bollinger <don@thebollingers.org>, <netdev@vger.kernel.org>
CC:     Vladyslav Tarasiuk <vladyslavt@nvidia.com>,
        Moshe Shemesh <moshe@nvidia.com>
Subject: [RFC PATCH V3 net-next 0/5] ethtool: Extend module EEPROM dump API
Date:   Mon, 15 Mar 2021 19:12:38 +0200
Message-ID: <1615828363-464-1-git-send-email-moshe@nvidia.com>
X-Mailer: git-send-email 1.8.4.3
MIME-Version: 1.0
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 2cd20c28-9da0-4452-0403-08d8e7d5939c
X-MS-TrafficTypeDiagnostic: BN6PR12MB1570:
X-Microsoft-Antispam-PRVS: <BN6PR12MB1570DA8A4E20CB3BD5390D9ED46C9@BN6PR12MB1570.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6790;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: yO36yjqGTMqICfYyewRwz4eeBTJvFf1PD1MqSNCg1jOHuFwicjg8FcFC3w9Ld81cA6Q1L/wp7xlhojkhW2OxcTRVE8/Y/o+uuO5R72zLCQJJ4dmO9EwSD+e40t3CH8lrMU5uzsIPKLLHtJ41ByYFIuqS6YtsjWkrQNJc4zcFlBE7IDNkEWO5kfzo7TZ4dsNWQWjOX6eImCIs+eTfPFxPtOJFLSkWBt+FfNyfPLdYJcSTRQvutfqNtHSIeJPs/oZo/Dkmen3X7grmqpbWSOmBqicc3Ql8LMW6R6nnqt0VurHPUjVAlkIPXKSVfUMJaUmKhFLs5tESjzF4HFD7Lqwv4IWalrXlkHHIIvdbGwjFck60zBoQsGXeTEFMkFj0a8GY3F5owek66IccY4PEDu6TO46IyKvArjUS+klI3mtVQ6UjmrXjdM5QSr5Bq8HNdZ9nb38RER422jSW9pqyU6oxTpQG1wG3ttTJ7xF/AE4LyjwBgS04U42+NjVXMWBS3okRuWY/Tu0qBScYlqvumSCix+4hY0swgmrSyw7P2jqbDjD/fxCR2L2+I2Zc2AxJvWobM/UznEBaCdwpGEE0aUDO56WK3T73F23FP8O/PnKFbn9TTxs6BqP/Ah6cDvbTvQaiQtftv5rRP86yL7E0CAsqRGNze8W3rU9rrlxhqQ2UCx4e1Fp389AbBo+yYuGRMZIt
X-Forefront-Antispam-Report: CIP:216.228.112.32;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid01.nvidia.com;CAT:NONE;SFS:(4636009)(39860400002)(136003)(346002)(396003)(376002)(36840700001)(46966006)(316002)(34020700004)(478600001)(110136005)(36860700001)(2906002)(336012)(6666004)(54906003)(186003)(83380400001)(36756003)(107886003)(82310400003)(82740400003)(5660300002)(356005)(8936002)(8676002)(86362001)(7696005)(70206006)(2616005)(70586007)(426003)(47076005)(26005)(4326008)(7636003);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Mar 2021 17:12:56.2271
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 2cd20c28-9da0-4452-0403-08d8e7d5939c
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.32];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT060.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN6PR12MB1570
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
  net/mlx5: Implement get_module_eeprom_data_by_page()
  net/mlx5: Add support for DSFP module EEPROM dumps
  ethtool: Add fallback to get_module_eeprom from netlink command

 Documentation/networking/ethtool-netlink.rst  |  34 ++-
 .../ethernet/mellanox/mlx5/core/en_ethtool.c  |  44 ++++
 .../net/ethernet/mellanox/mlx5/core/port.c    | 101 +++++---
 include/linux/ethtool.h                       |   8 +-
 include/linux/mlx5/port.h                     |  12 +
 include/uapi/linux/ethtool.h                  |  25 ++
 include/uapi/linux/ethtool_netlink.h          |  19 ++
 net/ethtool/Makefile                          |   2 +-
 net/ethtool/eeprom.c                          | 226 ++++++++++++++++++
 net/ethtool/netlink.c                         |  10 +
 net/ethtool/netlink.h                         |   2 +
 11 files changed, 451 insertions(+), 32 deletions(-)
 create mode 100644 net/ethtool/eeprom.c

-- 
2.26.2


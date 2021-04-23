Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 59DB9368DDD
	for <lists+netdev@lfdr.de>; Fri, 23 Apr 2021 09:23:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230191AbhDWHYU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 23 Apr 2021 03:24:20 -0400
Received: from mail-bn7nam10on2077.outbound.protection.outlook.com ([40.107.92.77]:11105
        "EHLO NAM10-BN7-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229982AbhDWHYT (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 23 Apr 2021 03:24:19 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=PoGBCcKs+TXEwWynsZ+03VPKHC9MqPUWaaL7mFrq2yTXgM89DeMZOcMl3dYrz4E1bEZRoaqAoF8FN8dpBBnO7vu0y+7m8FJIHrr3AH/H3ONewrx6iSNrwGq1h6XvOuWp6rrj8YgSJvMMpgQAvi8KpCNHxI4rAUT6aGaZOIrOI/ToYwc43oruQjTxGlYbTwT1CgRR7sOP13jX8bNYrD1GCBYnnpOedZuinAx0WiMjGzJOkJEtvqpnw6KAgdidINsGHXQrn6vpkXD68fKKWUfnbh+XdOjWhq4agnoyGF9Vtd+KpxUKxRpMt/LSI2EM2WseFAfMM0SufHseb/pEboqQZg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+YcUvIJGJNUkBGjr6A7EaeRVclhq/RQvyVNEyYDfT1M=;
 b=Oh7XxW2HM/eTcEBai4zBifmVn/FVZ4Ji7slTFpdqm3ZwJuraOiN/VVRTNSHPUpKjHuTO7uzkXOPMJ4ZX+ODEfjrPo5FzCy3yO5vpFZ0xgeBVcjoC5q1AV0ILurW55s/OBUcdBIjzXZQxCDpOzUAkC2tuRF9kY7Xl1rO0lqRdVTqhm7gvLPvh5R5Te93UY6GTcdfEPV3aY5qEvJp0dj8xTN36iqCglYtRhgJKJjP2k9L58CSB4N8evy2nfJl9W2YGdmI4lpHV9/em+9ktPpVtLFKRLp1wN3El0JUrs+S+tvD5tbCyb+5nd5xvYOXacGIkuSJ3skPbECRApFkpyQgWww==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.35) smtp.rcpttodomain=lunn.ch smtp.mailfrom=nvidia.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+YcUvIJGJNUkBGjr6A7EaeRVclhq/RQvyVNEyYDfT1M=;
 b=RPNh+Fx7q+yBKTFKY5XMkNKwQyZU4MbFC5gwrvGa6ahJsgPBQUnPk0V1J/2e2tN+744LfR8xqIdAnuMLnBlNFh8LQFpmkfJs+NkvRymMYjspeECHT8QAz3ziNfwN8rPXb6vUtz9QZsYJdrR11Tdjg9buxfGZ4iUEWAWlfHiUKzo4Gn1s5Hk/7SxpCs5sw2vOsv5cQfZPpkgnAEqkzm1+3IJjRVaRe0GwzVkAV4ruNCBpb8cUEi6TWTfymm3O/Pqbvs1HjACWnBw1N1cmCEI/XxSrrg0lQyZHhl43NApETlIL2Lrh2ZiZFim1LjSVR09kG4fF+qRVg0ZVfSHNOEKRjw==
Received: from DM5PR04CA0057.namprd04.prod.outlook.com (2603:10b6:3:ef::19) by
 BY5PR12MB4998.namprd12.prod.outlook.com (2603:10b6:a03:1d4::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4065.21; Fri, 23 Apr
 2021 07:23:41 +0000
Received: from DM6NAM11FT010.eop-nam11.prod.protection.outlook.com
 (2603:10b6:3:ef:cafe::7b) by DM5PR04CA0057.outlook.office365.com
 (2603:10b6:3:ef::19) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4065.20 via Frontend
 Transport; Fri, 23 Apr 2021 07:23:41 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.35)
 smtp.mailfrom=nvidia.com; lunn.ch; dkim=none (message not signed)
 header.d=none;lunn.ch; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.35 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.35; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.35) by
 DM6NAM11FT010.mail.protection.outlook.com (10.13.172.222) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4065.21 via Frontend Transport; Fri, 23 Apr 2021 07:23:41 +0000
Received: from HQMAIL105.nvidia.com (172.20.187.12) by HQMAIL111.nvidia.com
 (172.20.187.18) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Fri, 23 Apr
 2021 07:23:40 +0000
Received: from HQMAIL105.nvidia.com (172.20.187.12) by HQMAIL105.nvidia.com
 (172.20.187.12) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Fri, 23 Apr
 2021 07:23:40 +0000
Received: from vdi.nvidia.com (172.20.145.6) by mail.nvidia.com
 (172.20.187.12) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Fri, 23 Apr 2021 07:23:38 +0000
From:   Moshe Shemesh <moshe@nvidia.com>
To:     Michal Kubecek <mkubecek@suse.cz>, Andrew Lunn <andrew@lunn.ch>,
        "Jakub Kicinski" <kuba@kernel.org>,
        Don Bollinger <don@thebollingers.org>, <netdev@vger.kernel.org>
CC:     Vladyslav Tarasiuk <vladyslavt@nvidia.com>,
        Moshe Shemesh <moshe@nvidia.com>
Subject: [PATCH ethtool-next 0/4] Extend module EEPROM API
Date:   Fri, 23 Apr 2021 10:23:12 +0300
Message-ID: <1619162596-23846-1-git-send-email-moshe@nvidia.com>
X-Mailer: git-send-email 1.8.4.3
MIME-Version: 1.0
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: af8af40b-624c-472a-f030-08d90628b894
X-MS-TrafficTypeDiagnostic: BY5PR12MB4998:
X-Microsoft-Antispam-PRVS: <BY5PR12MB49980F30FB04C952D64F8412D4459@BY5PR12MB4998.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6108;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: lWVfBDUaLc0b8unuOKzgBPSYP0MnDGAwErA5BVtBXBjpuDuxmuuXTkLXB++Ir6blveT+ilwRbMqWx+8qMYMv9ckg0Vq9mzM5fnRVuQsBXvh2NRc4YqDwXGKwc6KnaEOUapjNxHM8lJuHSfgAnc3AjnIHexTgEaOfASrqtK38b4LX2bgZCp/i2yJFfygGe6Q8zFIM6ZdnjpGrmu2qjbYdge06/p2Lb0iqqoQM+HqRTNsc/e4/X9AWlbteXepGO8LrZJTicHBQw8spWBZaQo975+dfY9zZrowh7sul8i4ZooK2xm0wPjFUqdj2c5E3SNFDY3hDnf6VgUwMYFiJBHEB9UCZOKb0b40AqZwYTKUXo2IplHw1W7oqLAzvggG+1zXtkq7nueJQvqGff/GF1BQu/sKu67ThMPl9iwT9tfVG4J53lW+wHDgcjNgfaU2zidnXvVJsOakf5FuOeKf5d7q3lUlJHY0pulkRGxKWeCOFvLftf+8yHDiiAn0JmlDjNPs83klG8y+3B+OSOZPPbVpYb6ygELspvsgF2ifaw7sHDHjTlL60zGy5Lf+E2OCIQHcyO9Hn9wGoGqGCgWm8MKn82Wa3emxGFmYGYbuVXiG0wujZl48oz5pzOn0F/XLAGAdo5tl2QsQCGe+DVg6zQbhlHYC4+ML7PBeZxYuKnd040yo=
X-Forefront-Antispam-Report: CIP:216.228.112.35;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid04.nvidia.com;CAT:NONE;SFS:(4636009)(39860400002)(346002)(376002)(396003)(136003)(36840700001)(46966006)(36860700001)(7636003)(36906005)(82310400003)(82740400003)(107886003)(70206006)(478600001)(83380400001)(356005)(8676002)(70586007)(4326008)(36756003)(316002)(26005)(54906003)(86362001)(8936002)(2906002)(426003)(336012)(186003)(5660300002)(47076005)(2616005)(6666004)(7696005)(110136005);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Apr 2021 07:23:41.3753
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: af8af40b-624c-472a-f030-08d90628b894
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.35];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT010.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR12MB4998
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

Vladyslav Tarasiuk (4):
  ethtool: Add netlink handler for getmodule (-m)
  ethtool: Refactor human-readable module EEPROM output for new API
  ethtool: Rename QSFP-DD identifiers to use CMIS 4.0
  ethtool: Update manpages to reflect changes to getmodule (-m) command

 Makefile.am             |   3 +-
 qsfp-dd.c => cmis4.c    | 220 +++++++++++---------
 cmis4.h                 | 128 ++++++++++++
 ethtool.8.in            |  14 ++
 ethtool.c               |   4 +
 internal.h              |  12 ++
 list.h                  |  34 ++++
 netlink/desc-ethtool.c  |  13 ++
 netlink/extapi.h        |   2 +
 netlink/module-eeprom.c | 438 ++++++++++++++++++++++++++++++++++++++++
 qsfp-dd.h               | 125 ------------
 qsfp.c                  | 129 +++++++-----
 qsfp.h                  |  52 ++---
 sff-common.c            |   3 +
 sff-common.h            |   3 +-
 15 files changed, 876 insertions(+), 304 deletions(-)
 rename qsfp-dd.c => cmis4.c (55%)
 create mode 100644 cmis4.h
 create mode 100644 list.h
 create mode 100644 netlink/module-eeprom.c
 delete mode 100644 qsfp-dd.h

-- 
2.26.2


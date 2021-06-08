Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0A9AC39F39E
	for <lists+netdev@lfdr.de>; Tue,  8 Jun 2021 12:34:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231300AbhFHKfu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Jun 2021 06:35:50 -0400
Received: from mail-dm6nam10on2088.outbound.protection.outlook.com ([40.107.93.88]:20637
        "EHLO NAM10-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231294AbhFHKft (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 8 Jun 2021 06:35:49 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dVwRmYM3K9m2JS+2x8xdKUYzfiZ/vBu58hs9fAI393G92bwOv8siWCb1JoN+/c/HSHlmvKaVZu0jxEYKnKKCjRbBTSlewQywCJeufL2+hPgogP208RNhRv9KZrPSjlvmnTLptyhP0hSKYE0NMYxrZOkasmBePxwpiTCb6zj9TL/c3or1R6hUpfLXIiMwXuF3KDtBx/zSJK+iPSPkWtKoehv3WA8en3YVxIMv3hq/2IrkoeLCDldQTLJ3Usj9vzZtGWMhkwsubosJMyVTrMeuM04Cqe+w9R2bnb5Yf0unosIj70cD0/NREC80Vnu0uEAA0753c3xOxOW67LW+OyHmYA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=axG7Kdv5ctwhHhs5BnMlfAQav9V+rkcs6Nu7bgXQwo8=;
 b=mamWwJT9/HUi/tq9LcHgtl53gq41arpTU0vHu+O7IhBuO++DpEZg+jTZhQFirO9s8+ag1m82GvbqLjv4lXJAmuZKQLmjsKCBrp95vyoPnHNR2sVXOmHPr9mrUWeaE5u+4zFavgyOWOjNTN509Lt86uRMXzKqpX9DYX9EkG0QY99XGBaUc+ZdRGmSw0214PIaXh/ub60j7Wh5aJeEO19J6VQqTc4o5m6nIM3lHvU/zi1cYT4zc3bSr2iFYU6JgTQarlZ2xh6+myaWJpKssu495TtRsKS4dAiJdjqJdSP9Y+QaEmZoO1dg9P4uxHJKPHT0jeaMnC+n4IN35GTSNlz6kQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.35) smtp.rcpttodomain=thebollingers.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=axG7Kdv5ctwhHhs5BnMlfAQav9V+rkcs6Nu7bgXQwo8=;
 b=Dt9znM5VVqDVMgkyHLQG/LhSZsHDDGsdt8KqQ5NjfXcVGlYpNWiiM5v6OGiMZXPDSTXsDo+TDVVhf4fwuTqjI72Vzs328oqHFTzgAeQpihDEqspLcZy5/0EJdEeN6y9k8oHrB2D0N+6o1FxWmkMOfVJPQ+9/EIz0+VObUWB13sYOGdjpKlqFpXTSH7OBnoMxknJN0lyy6men71/5fyF0UnE5pQtHOq8U6pcZS32kM3+ih2VBhifW9Aa4a5w66RLBnoDT/dqJ9piqE/MM7W6v7ZpcVPz0GJV/LrDB8MDa7hq/bl+NzUCr1WykgWJq8Nerir2kNal6PSlqWwQqj/6NAg==
Received: from MW4PR04CA0176.namprd04.prod.outlook.com (2603:10b6:303:85::31)
 by DM6PR12MB3529.namprd12.prod.outlook.com (2603:10b6:5:15d::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4195.25; Tue, 8 Jun
 2021 10:33:55 +0000
Received: from CO1NAM11FT012.eop-nam11.prod.protection.outlook.com
 (2603:10b6:303:85:cafe::61) by MW4PR04CA0176.outlook.office365.com
 (2603:10b6:303:85::31) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4219.20 via Frontend
 Transport; Tue, 8 Jun 2021 10:33:55 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.35)
 smtp.mailfrom=nvidia.com; thebollingers.org; dkim=none (message not signed)
 header.d=none;thebollingers.org; dmarc=pass action=none
 header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.35 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.35; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.35) by
 CO1NAM11FT012.mail.protection.outlook.com (10.13.175.192) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4195.22 via Frontend Transport; Tue, 8 Jun 2021 10:33:55 +0000
Received: from HQMAIL107.nvidia.com (172.20.187.13) by HQMAIL111.nvidia.com
 (172.20.187.18) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Tue, 8 Jun
 2021 10:33:53 +0000
Received: from vdi.nvidia.com (172.20.187.5) by mail.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Tue, 8 Jun 2021 10:33:48 +0000
From:   Moshe Shemesh <moshe@nvidia.com>
To:     Michal Kubecek <mkubecek@suse.cz>, Andrew Lunn <andrew@lunn.ch>,
        "Jakub Kicinski" <kuba@kernel.org>,
        Don Bollinger <don@thebollingers.org>, <netdev@vger.kernel.org>
CC:     Vladyslav Tarasiuk <vladyslavt@nvidia.com>,
        Moshe Shemesh <moshe@nvidia.com>
Subject: [PATCH ethtool v3 0/4] Extend module EEPROM API
Date:   Tue, 8 Jun 2021 13:32:24 +0300
Message-ID: <1623148348-2033898-1-git-send-email-moshe@nvidia.com>
X-Mailer: git-send-email 1.8.4.3
MIME-Version: 1.0
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 8b755d35-b5c5-41cc-800b-08d92a68eaf7
X-MS-TrafficTypeDiagnostic: DM6PR12MB3529:
X-Microsoft-Antispam-PRVS: <DM6PR12MB35290C8992BD01A120D107E2D4379@DM6PR12MB3529.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6790;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: XA6pIZ91NUrq/rSHHBIlAPa1S42x88Py7eLZn9RGCGVxDcMa2ECtp9e2JK+V3CKLhHPD+5WnxgHnoDzFcTqj9qQwXFCnjRsm9P+GzvQUC5Udcc+gYIrNhDZlS1tA+Be4EqSzwm3Av6+mhK4QgkkL5y86/vFUrh8rta5I8sDOLcB1H/ruC2kOnXzmCYVUyy+TS+pHCF4hB1Kv3vT+zTjKVSXau0SMszRTsNBPOlRSgL7yoaWQnZkdj2cZaAjge9ixH3PK6dxYZaXDEZLW/1rSwRjrob1J+alW4xbIBflTkUlnqsGsy0fgr5ApXrjz41d50FY7S6qCB0OUVlo02G3RQGUmUn26JjItQgXj8xtcNyuWI1ZBT/jSMPu2sIEFshqhvLddRwyWM3KOA5WFEb4SS+6iuEI6WEMr9swri1uLAFj5uZwGP+1W0xHRc/jRBjJXYqJfIvpG6xarm03bUKj6Hy3q/2WdyOwYQDvQx8np9ZXUL4T8L0jqkVKfzgVPYR5YY1BFxJS7FsEHw88vMiUgt9mm+obpRsxx7difK5tzad0A5suAxySKkWKoCSjeZX/SPXyihiXKhB1o5OdWL33ZmcS0xwtgINgMFY1B2jPygRj3gItBH5hPQ9d4U6tbTyGpHOSpjMrhzPU60MhQT0/jsDhbhZNla/eiAwJLu7rYYEI=
X-Forefront-Antispam-Report: CIP:216.228.112.35;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid04.nvidia.com;CAT:NONE;SFS:(4636009)(396003)(376002)(136003)(346002)(39860400002)(36840700001)(46966006)(7636003)(336012)(426003)(2616005)(316002)(36860700001)(82740400003)(4326008)(82310400003)(70206006)(356005)(70586007)(86362001)(36756003)(7696005)(36906005)(6666004)(47076005)(5660300002)(54906003)(8936002)(83380400001)(110136005)(478600001)(8676002)(186003)(2906002)(26005)(107886003);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Jun 2021 10:33:55.5660
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 8b755d35-b5c5-41cc-800b-08d92a68eaf7
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.35];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT012.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB3529
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Ethtool supports module EEPROM dumps via the `ethtool -m <dev>` command.
But in current state its functionality is limited - offset and length
parameters, which are used to specify a linear desired region of EEPROM
data to dump, is not enough, considering emergence of complex module
EEPROM layouts such as CMIS.

Moreover, CMIS extends the amount of pages that may be accessible by
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
v2 -> v3:
- Removed spec version from CMIS identifiers by changing 'CMIS4' and 'cmis4' to 'CMIS' and 'cmis' respectively.

v1 -> v2:
- Changed offset defines to specification values.
- Added default offset value (128) if page number is specified.
- Fixed return values.
- Removed page_available()


Vladyslav Tarasiuk (4):
  ethtool: Add netlink handler for getmodule (-m)
  ethtool: Refactor human-readable module EEPROM output for new API
  ethtool: Rename QSFP-DD identifiers to use CMIS
  ethtool: Update manpages to reflect changes to getmodule (-m) command

 Makefile.am             |   3 +-
 cmis.c                  | 359 +++++++++++++++++++++++++++++++++++++++++
 cmis.h                  | 128 +++++++++++++++
 ethtool.8.in            |  14 ++
 ethtool.c               |   4 +
 internal.h              |  12 ++
 list.h                  |  34 ++++
 netlink/desc-ethtool.c  |  13 ++
 netlink/extapi.h        |   2 +
 netlink/module-eeprom.c | 416 ++++++++++++++++++++++++++++++++++++++++++++++++
 qsfp-dd.c               | 333 --------------------------------------
 qsfp-dd.h               | 125 ---------------
 qsfp.c                  | 130 ++++++++-------
 qsfp.h                  |  51 +++---
 sff-common.c            |   3 +
 sff-common.h            |   3 +-
 16 files changed, 1090 insertions(+), 540 deletions(-)
 create mode 100644 cmis.c
 create mode 100644 cmis.h
 create mode 100644 list.h
 create mode 100644 netlink/module-eeprom.c
 delete mode 100644 qsfp-dd.c
 delete mode 100644 qsfp-dd.h

-- 
1.8.2.3


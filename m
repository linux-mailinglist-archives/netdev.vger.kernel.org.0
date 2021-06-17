Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 05B5D3ABA39
	for <lists+netdev@lfdr.de>; Thu, 17 Jun 2021 19:05:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231617AbhFQRH1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Jun 2021 13:07:27 -0400
Received: from mail-dm6nam11on2085.outbound.protection.outlook.com ([40.107.223.85]:10956
        "EHLO NAM11-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229784AbhFQRH0 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 17 Jun 2021 13:07:26 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nbi5g0jabbmAMMIEdP1DEBmJ2JNzu/d80zN34oNveZiR8KUhtuNO8xb4KNOlmAPkwjmFhG8y7MsGERg8Nwaz3i7J6eVOKdWdjZ3hsj3S7j2k68UQCqlevmC+/OINgxjOwXjNJO6Wzy+9hjTN15ySaVrklfIlFe2RA60ZSHU/GhiX8zKOEw0xF45bvuEcSX5VvSGnTzZCht5h2bEtOao/jdhOBPYsxS++2HHBTklnKMxx3JmcBMZVkLnVg4VLuSCp5Olx/w2Av6HwzJ1QEcDC+eSMzks/yaUph+oWexpmswQevMshDjzESzM3bnQ9B/QhszIvYwlTMiS1DEknF+HJzw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mEv13knuDcaaRgz4xwiytLq6sD5cyHaS/w9VG3NsHPs=;
 b=crdgN9ywtlA001DYtKKsyWScF13H1Dujby2WDDpnAxVRQBfK5854xlcvwrgPpOKsoGaUtpy8d8iRh4DZvxYnKdmRjXNDWFHyBstl+LJjL7y8PM5Hqr4xIhjpH6BueP+9c6yuFnoT/qAWQV0M5nUdJldg623rVHeehx1VtKyMa071zc0bnw42r4bG/GoX3ck+xwGObLhUfkyYeuV8u9GvXTQZaTpvTwD5Y+Jt8pgKqO4dAsKhcz2H9KJLCA2IPWSkFqUIqhvkD7TrFOaH51eeWz9x5REwhUwriW2QtJxiEvdWT5LJBdVIGA0vWMX99Fa/DR5OVKiI11P1EJvlOJHErQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.32) smtp.rcpttodomain=thebollingers.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mEv13knuDcaaRgz4xwiytLq6sD5cyHaS/w9VG3NsHPs=;
 b=uIS8/vWZ2/KnPrcN//NeJ7ttrRYwrVmWIdgLEpJ6wze9665BOg7iUNcsYVBILQgyPCgYy2HpaomSQFP4s4eFfm4dQJGV6SiD0oYEAA6B5kCbmL0tsaZyqtfybY21aiVTn2tByTIWU2RDjGfP3ye7nZliLlcR73WXvBL4dg49KtnXHh7ny34jUnb93c8EDo5UjXYOiViCmsqn6uIqhjOd9YGsWMdfyx7SseQ+3r+3oUkTyoxgTLZrWMssI1s29Oz5Q4yUrmeWTiE6OuvmPzse5z3lrFp2NfobnpL7JHlMRjXJQFFSsVziqR6xyfoFASbYTc2nqSbzIlJUk+oS/dtEqw==
Received: from MW4P220CA0008.NAMP220.PROD.OUTLOOK.COM (2603:10b6:303:115::13)
 by BL1PR12MB5333.namprd12.prod.outlook.com (2603:10b6:208:31f::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4242.15; Thu, 17 Jun
 2021 17:05:17 +0000
Received: from CO1NAM11FT037.eop-nam11.prod.protection.outlook.com
 (2603:10b6:303:115:cafe::24) by MW4P220CA0008.outlook.office365.com
 (2603:10b6:303:115::13) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4242.16 via Frontend
 Transport; Thu, 17 Jun 2021 17:05:17 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.32)
 smtp.mailfrom=nvidia.com; thebollingers.org; dkim=none (message not signed)
 header.d=none;thebollingers.org; dmarc=pass action=none
 header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.32 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.32; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.32) by
 CO1NAM11FT037.mail.protection.outlook.com (10.13.174.91) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4242.16 via Frontend Transport; Thu, 17 Jun 2021 17:05:16 +0000
Received: from HQMAIL109.nvidia.com (172.20.187.15) by HQMAIL109.nvidia.com
 (172.20.187.15) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Thu, 17 Jun
 2021 10:05:16 -0700
Received: from vdi.nvidia.com (172.20.187.5) by mail.nvidia.com
 (172.20.187.15) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Thu, 17 Jun 2021 10:05:14 -0700
From:   Moshe Shemesh <moshe@nvidia.com>
To:     Michal Kubecek <mkubecek@suse.cz>, Andrew Lunn <andrew@lunn.ch>,
        "Jakub Kicinski" <kuba@kernel.org>,
        Don Bollinger <don@thebollingers.org>, <netdev@vger.kernel.org>
CC:     Vladyslav Tarasiuk <vladyslavt@nvidia.com>,
        Moshe Shemesh <moshe@nvidia.com>
Subject: [PATCH ethtool v4 0/4] Extend module EEPROM API
Date:   Thu, 17 Jun 2021 20:05:00 +0300
Message-ID: <1623949504-51291-1-git-send-email-moshe@nvidia.com>
X-Mailer: git-send-email 1.8.4.3
MIME-Version: 1.0
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 51a6b1e1-bdc5-4a4b-d05a-08d931b214a9
X-MS-TrafficTypeDiagnostic: BL1PR12MB5333:
X-Microsoft-Antispam-PRVS: <BL1PR12MB53339F098215E5AC9F849734D40E9@BL1PR12MB5333.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6790;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 2fufaVIoXnly8pOcaheFBF+4hOisYXZNqfq0V2gK41fTHGeoVi1zNhRZURVDhlf6ywNateM4z5DRsuJix7vKmOGIZHefSaT/YEIsC+WBnDCpOwu3Bgu8v17XWB1jWOYgVufE4mb6Ebw1DWCkGGirlFx4ib3aMtttn0sUmTqB5Da46q5gbsfuB/qSe0MyS529ZDIdQQ3gkEbmttfjnz3UvBs8mqEZ8pwYSxIm/85NOZjz5KxI2nCjExYkgHopGeSpH9J6yhDZtuslERZxd1k81Yh0PSV1KwzZY4zNEKEynLo7uHdw7UzKZWDnkbk7PY4sc1ngfhM6vBUFhvD3NFNHjZE1iVrsVCLC3j9ZA/ld6ggT/AkD9liGxGwr1HHCVLlYp41kUOrYPNS9QwXPVo9ThBecPB/kzZYyD6TDnQDJiPMrWlZOW6jhELQtqIS1FJvRekaVvlZLD7KgaApSFuO+kfJVTO6GSw3VIb6mpU8tPrNCdITOjRAU2ZpJxGPLB8FDvMZl8Vx7HOhhpS0Z1cjgQwM36CPtgUb32F6PVIkO4Nptx1xaKbpeIR8DrbPMd+Ehio8TTKuGTiq4ccmrdK22kvbq0OiO9DxXaji/fT5/suBXgccjTjg0CXMA0oXa5DyOaCfDxk1TIp7p8eFUIULm9HjoZa6BxV65r4V0cYROV40=
X-Forefront-Antispam-Report: CIP:216.228.112.32;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid01.nvidia.com;CAT:NONE;SFS:(4636009)(376002)(346002)(396003)(39860400002)(136003)(36840700001)(46966006)(5660300002)(107886003)(70586007)(7696005)(426003)(8936002)(4326008)(36860700001)(316002)(54906003)(186003)(47076005)(70206006)(336012)(2616005)(82740400003)(110136005)(83380400001)(2906002)(7636003)(26005)(356005)(36756003)(86362001)(6666004)(8676002)(478600001)(82310400003);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Jun 2021 17:05:16.9239
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 51a6b1e1-bdc5-4a4b-d05a-08d931b214a9
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.32];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT037.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR12MB5333
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
v3 -> v4:
- Fixed cmis_show_all() prototype

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


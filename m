Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3FC9345906F
	for <lists+netdev@lfdr.de>; Mon, 22 Nov 2021 15:43:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238864AbhKVOqp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Nov 2021 09:46:45 -0500
Received: from mail-mw2nam12on2068.outbound.protection.outlook.com ([40.107.244.68]:47361
        "EHLO NAM12-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S230152AbhKVOqp (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 22 Nov 2021 09:46:45 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=OGnEkOHEjCxv7YsVHR+i07hwuvp406G+9NRx0MUXAE3ROgZ0ZXn2sKEynP4RBXmkJy39blcWs7xlXxoKmcfjRqh7OmB94wgUi7GW5nhvV5Ud2aMtbNlp1G7S8X8cHErM201FsjorsllYjfWHWIL9lsvEeJQEGVMiGiRtY3XJrIQxknQXSd/11H6rONUir3aLs7cZNoglIX4uv+4tHeu9W/aB4GpTFROSh4h56Tko5O6ZBE9bdmQK8EsfR6m5sM1UfVZH7sI4KXlCwzUabmsYr0EPaJXLYsmcQZhTMO7XL8Wp4C4bU+YrWZ8Sd/TsJjZEjEHWHrBYTf5jzJ7lCHh6qA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=HMF9q5HpM+Yh5LthdVM5cs+oGRWZSJ+wM6AOhogaRns=;
 b=bl/MA2Tq4x0Uf7PGlhXAgqJVw9SKPXfm9vy3lDFfl/dYaC9N/zwyyPKgl1XI/FdvKanP9SysetEUeTGuZ/qg5aW2Elp+Ps2HZw043zvw7z/pKQD8vOektHdwrwiOv0kUZoO9p5MGEP6PZKKEJkcT5U7dQZxshUwHMlxmVjCOQqcQvm2VwS0RAaUlu7NOJGLMDA+oGUhaF4iOToYp+YFqIdLyKI0xl1jgU+vRdeao7fEEPzz7sDBW2q18RpdKHUoQJkXHCfqmN6MMmH5ld02TWdWL6AOiYQCcOep85gKnGcoJ4SPbFR1cYqM7/2dyMBIRu1quN9vpOIjTUcjmuvWWAA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.34) smtp.rcpttodomain=kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HMF9q5HpM+Yh5LthdVM5cs+oGRWZSJ+wM6AOhogaRns=;
 b=QDjUF3PNSW3Z4woFEoRNunM57KXvKZZJ2fjbV3RIvNWICy65q5640PEFXnzzJnHZurXVR3esoN9cOndYAKGDSA10+HT/CWP177oiLqb71TYxCGZd5TYuf9XTscx1eN5Sm/6+RD+hVNpsGKwb6CMcs1sttvV20LLVwWrd4QjcKSxQoLfq0QKK/zqSSJXENArgTtOvzM8vW6OYY2y8MtvJwVKlk+NiG+HwO4AjiUH/SUkcnI+m4jFbxEYaxS98uF4wMc1TGqsT50VOlbxE9M6XEsISnJZDMOIBi9kCufx3aes48y+jQhNEvRb2OcdZNBXuB1mEXY0cEsRV/KqDcsfYYA==
Received: from DM6PR02CA0140.namprd02.prod.outlook.com (2603:10b6:5:332::7) by
 BN6PR12MB1332.namprd12.prod.outlook.com (2603:10b6:404:15::10) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4713.22; Mon, 22 Nov 2021 14:43:37 +0000
Received: from DM6NAM11FT030.eop-nam11.prod.protection.outlook.com
 (2603:10b6:5:332:cafe::7) by DM6PR02CA0140.outlook.office365.com
 (2603:10b6:5:332::7) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4713.21 via Frontend
 Transport; Mon, 22 Nov 2021 14:43:36 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.34)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.34 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.34; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.34) by
 DM6NAM11FT030.mail.protection.outlook.com (10.13.172.146) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4713.20 via Frontend Transport; Mon, 22 Nov 2021 14:43:36 +0000
Received: from mtx-w2012r202.mtx.labs.mlnx (172.20.187.5) by
 HQMAIL107.nvidia.com (172.20.187.13) with Microsoft SMTP Server (TLS) id
 15.0.1497.18; Mon, 22 Nov 2021 14:43:34 +0000
From:   Sunil Rani <sunrani@nvidia.com>
To:     <netdev@vger.kernel.org>, <davem@davemloft.net>, <kuba@kernel.org>
CC:     <parav@nvidia.com>, <jiri@nvidia.com>, <saeedm@nvidia.com>,
        Sunil Rani <sunrani@nvidia.com>
Subject: [PATCH net-next 0/2] Extend devlink for port trust setting
Date:   Mon, 22 Nov 2021 16:43:05 +0200
Message-ID: <20211122144307.218021-1-sunrani@nvidia.com>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [172.20.187.5]
X-ClientProxiedBy: HQMAIL111.nvidia.com (172.20.187.18) To
 HQMAIL107.nvidia.com (172.20.187.13)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: bd376aa7-15b9-4856-ca3f-08d9adc67746
X-MS-TrafficTypeDiagnostic: BN6PR12MB1332:
X-Microsoft-Antispam-PRVS: <BN6PR12MB13329F70916D4B2C33143992D49F9@BN6PR12MB1332.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6430;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: qSqOcwlu2fHKKVgJinkUeM+OwmF5SCUt1fylASjsxMx1x9KGs37e9slJRgLQ48JRwGEgNm5JWHbGw1vBLeSUpZuMOC5JWxHjcGj1imJK2bba6iVkjI5YoIkkbqWtvnVrpVS2PJKvZLGQDyhuG3vbf/iHlki5xGmu4sBaGB98ZzXlCNmVg3bPx7OTKOjAW6Ri0iZAzA1UscAtNjuJX3IRVZZgxsM2NVewbxd5yF+BD75t05aDi8Vn3IOozGW+9HOoNjgyDzyOl3xlB8/OsOzS3oNDOlCNoudOX+znf+lvzygdj/v+M8Nm+8rjWjX5y/tRimQvmCWxQvl1oQiGSHpkFNFGgO1sKwC3VgdHMQ+4KD2hqcoDODVEVr1j5WS+5sL10qqhFwCYoNs06YO9hmeI06mUObCyU62E9kgBUSzz9rd3M+znLA/4N7k9sKb5UgW04gRwCHSI2cz+GiOYTzGCcMgR2Hhxcszs8Xn9134j3/HMLEz+sd7S6tTE9Cy6cWlvcuQVtkWLz8GJ2hnEoSzzpIYZLF/QUHErnonpnGUoR5N5HtgWH1MMH7dDyz/QCkkWzKeMlkgcFiFf5PArnCpYxKR2CPR7Q3A1QanWP3TcRnNbNUv28PQjhsFql6ioXpMDq/vGwI0oBrPLQHPxTwbFuPwFja5O4+ewOaGwkk7gPMB+SXgr26l0AIfubCWrUXqJO5CJMkvuMf3/bQxwY8ccNw==
X-Forefront-Antispam-Report: CIP:216.228.112.34;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid03.nvidia.com;CAT:NONE;SFS:(4636009)(46966006)(36840700001)(4326008)(2616005)(426003)(336012)(186003)(7636003)(16526019)(508600001)(6666004)(26005)(2906002)(356005)(5660300002)(82310400003)(8936002)(110136005)(1076003)(36906005)(47076005)(54906003)(316002)(36860700001)(36756003)(70206006)(86362001)(8676002)(83380400001)(107886003)(70586007);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Nov 2021 14:43:36.4804
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: bd376aa7-15b9-4856-ca3f-08d9adc67746
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.34];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT030.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN6PR12MB1332
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Currently a function (VF/SF) is always untrusted by default. Such a
function does not have the privilege to perform steering database update
as what a switchdev device can do.

In a use case where, a trusted application wants to modify/update the
device steering database through a VF or a SF, add a user knob through
which administrator can mark the function trusted; thereby it can update
the steering database.

This patchset introduces a knob to mark a function trusted. Function
restores to its untrusted state when either user marks it as untrusted
or the function is deleted (SR-IOV disablement or SF port deletion).

Patch Summary:
patch1: extends devlink to get/set trust state
patch2: extends mlx5 driver to get/set trust state setting

example config sequence:
Add SF Port:
$ devlink port add pci/0000:08:00.0 flavour pcisf pfnum 0 sfnum 88
pci/0000:08:00.0/32768: type eth netdev eth6 flavour pcisf controller 0 pfnum 0 sfnum 88 splittable false
  function:
    hw_addr 00:00:00:00:00:00 state inactive opstate detached trusted false

Set SF trust setting:
$ devlink port function set pci/0000:08:00.0/32768 trusted true

Query SF settings:
$ devlink port show pci/0000:08:00.0/32768
pci/0000:08:00.0/32768: type eth netdev eth6 flavour pcisf controller 0 pfnum 0 sfnum 88 splittable false
  function:
    hw_addr 00:00:00:00:00:00 state inactive opstate detached trusted true

Sunil Rani (2):
  devlink: Add support to set port function as trusted
  net/mlx5: SF/VF, Port function trust set support

 .../networking/devlink/devlink-port.rst       |   4 +
 .../net/ethernet/mellanox/mlx5/core/devlink.c |   2 +
 .../net/ethernet/mellanox/mlx5/core/eswitch.c |  24 ++++
 .../net/ethernet/mellanox/mlx5/core/eswitch.h |  11 +-
 .../mellanox/mlx5/core/eswitch_offloads.c     | 116 ++++++++++++++++++
 include/linux/mlx5/driver.h                   |   1 +
 include/linux/mlx5/mlx5_ifc.h                 |  10 +-
 include/net/devlink.h                         |  22 ++++
 include/uapi/linux/devlink.h                  |   1 +
 net/core/devlink.c                            |  55 +++++++++
 10 files changed, 244 insertions(+), 2 deletions(-)

-- 
2.26.2


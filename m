Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2E67F366F99
	for <lists+netdev@lfdr.de>; Wed, 21 Apr 2021 18:00:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241633AbhDUQAJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Apr 2021 12:00:09 -0400
Received: from mail-bn7nam10on2060.outbound.protection.outlook.com ([40.107.92.60]:32609
        "EHLO NAM10-BN7-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S241047AbhDUQAF (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 21 Apr 2021 12:00:05 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=GXqWqw+XVG8VdTR7qvbu4B6B3fffvv4ooeQYHKKq3itjjcYRoSr/8OKTfnQjDRry/RjnQU1GitLZpmYw76U0FNm9w7ZXn7Hm1gOi06vnaX1hDR3MtC/CWs9BFlyXWrOKVb0nI+bo8imX/QRisuHuajN3TZyZ+HuDzpO2sef1e54X/lVg+zh5LPI64d8zyBGgqhkKP25bn3CON/XfF1QM0kaqr/F23NVC+kA/Vpda2j9n5TxD5+YCoo0LodjnvtrcX2Sp5nbJkZ3THj3EDGtTIww3EmC23a59OtuGzrC32DjACAYqbw9H5FQ3yqs7FuTS6csiTfX8spOsASvjFdM/Iw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=iW1FiJWN//u/KMOT5h/Kl/mvV7s5cQyCPUWRqdYUoyI=;
 b=JGO92L02bJEH7MSs+NTrITUgwdObd0GUbgJtKJ85Rzcti6H80wORxv5Le1UID0AGWQxvaNmNOL2EP0hrT4ATuMw4viQGU8R24SMfuxvW4IASHlg1BIFOD1uUwEbbtKBWi8lgMuzONLkGb8BhMt62Y10ArlJd9VdVOBUEXLcDvTnZfoLSCIujNvH2mY09ov0w6C9CJ767X+9a16ykwLZLyTzkfVkYtRW5/SoiXSzovHzndHl6W+Xxvbn+8fm1/SCJOm1VR4pR9JQbTC2aGwGdTSFjiu6H0WUJ4uj3+wq4fCruG+Mp5lFe5eqxfFKmJtpo+aU9YC9YCfhD/fRhS53VSQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.35) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=iW1FiJWN//u/KMOT5h/Kl/mvV7s5cQyCPUWRqdYUoyI=;
 b=TcyUrWlnXrDDFpOyNsh20On6K+4+jeEC9ddbWZ6RC2jFjiXxvuWbmE9isuSGSPCpS5Xuz5LxyupimpaAM2K3OZxqZl6kMb7BWFL9pxC2qQh6mw2HVIGRzpbpk6yB1HB1Y5Foq0MNVDb83r1btb0NbEOtUWYxdwX6Pf7Ou7U+rO2PirywUbSBWeKv6Zr8IsXWTmiezZRrjo8Eyyzt3FQwX6X0iLQSpIERSKFXPJ5MWZhaKMpkJslTEwL8v8RN/zNH2xrKEOXfQGKfcRQvw1OVt7J4IqrxdXXPcNfi8kgvJF71u7lRfzpDBQfciQL66HoiEIYvAfGuFhcjeY8oGHI2Eg==
Received: from MWHPR1401CA0009.namprd14.prod.outlook.com
 (2603:10b6:301:4b::19) by MWHPR12MB1312.namprd12.prod.outlook.com
 (2603:10b6:300:11::9) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4065.21; Wed, 21 Apr
 2021 15:59:29 +0000
Received: from CO1NAM11FT035.eop-nam11.prod.protection.outlook.com
 (2603:10b6:301:4b:cafe::9a) by MWHPR1401CA0009.outlook.office365.com
 (2603:10b6:301:4b::19) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4065.20 via Frontend
 Transport; Wed, 21 Apr 2021 15:59:29 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.35)
 smtp.mailfrom=nvidia.com; vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.35 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.35; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.35) by
 CO1NAM11FT035.mail.protection.outlook.com (10.13.175.36) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4065.21 via Frontend Transport; Wed, 21 Apr 2021 15:59:29 +0000
Received: from HQMAIL105.nvidia.com (172.20.187.12) by HQMAIL111.nvidia.com
 (172.20.187.18) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Wed, 21 Apr
 2021 15:59:28 +0000
Received: from HQMAIL107.nvidia.com (172.20.187.13) by HQMAIL105.nvidia.com
 (172.20.187.12) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Wed, 21 Apr
 2021 15:59:28 +0000
Received: from vdi.nvidia.com (172.20.145.6) by mail.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Wed, 21 Apr 2021 15:59:26 +0000
From:   <dlinkin@nvidia.com>
To:     <netdev@vger.kernel.org>
CC:     <davem@davemloft.net>, <kuba@kernel.org>, <jiri@nvidia.com>,
        <stephen@networkplumber.org>, <dsahern@gmail.com>,
        <vladbu@nvidia.com>, Dmytro Linkin <dlinkin@nvidia.com>
Subject: [PATCH RESEND RFC iproute2 net-next 0/4] devlink rate support
Date:   Wed, 21 Apr 2021 18:59:21 +0300
Message-ID: <1619020765-20823-1-git-send-email-dlinkin@nvidia.com>
X-Mailer: git-send-email 1.8.3.1
MIME-Version: 1.0
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 10ebbdaa-3f2c-420b-6f14-08d904de7213
X-MS-TrafficTypeDiagnostic: MWHPR12MB1312:
X-Microsoft-Antispam-PRVS: <MWHPR12MB1312CAD24222186716795162CB479@MWHPR12MB1312.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8273;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: URKOA82BvYkUz3xb4ZPek1rAYroEdJmKF6YNQx7UXCy6AlQV5rWLs4mSmiqnsOnSO+L1dmwhgaNKdztBCI5OjMOtuCJWY7QmYeWtyOsZdWgSgvAfdN0DKLFXXcHsmYpL5pSqzyyyGN7i3KcBEbZnCHexE/RdqDrAcCztiPqKbVUcUbQvQY2M6AuyyTSjnmZPu42KM+jYTvICiZPFyB+3LTEOmxxDWC8bF1lzd172paj668BItMPOH9uH6+eO8QfcuFkzWfzwmv5/pziE/z5/FUNQfH7Lfu8mN1YF85gdE5bbBaWj4wNRIDjyKSCPn+c2+JLuki+Do8+bxfN7JyDMF9rZow4RUSlzzGDZmbtE3OHw8Xf2Xur7mvD8r3RndF+itKDY5g8TNDxunNEUO9DL2GvSqOPv6POTYKh3713MP6g9aCO6+jsMbgoATaol5DkWtqPZUqoHhvW2SlW/QAmA3Cg+9r3D/hv436QSnPtAXOnbj8meEvARVsGh1Zx6UxWXJ+or3Q63mO0drrbtfvfvFiRIlL9cyYFVICaZEvEjRPR615o24umujP6F7D8Egw4YN7fNGghYwOT+3zlR4YfNIwV+YFwcXDjz2gBg3uYfjA/eDXGWBUoQPW4qrw/vavvp3qjMLUNabx+1PH/TnfeFVg==
X-Forefront-Antispam-Report: CIP:216.228.112.35;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid02.nvidia.com;CAT:NONE;SFS:(4636009)(396003)(376002)(346002)(39860400002)(136003)(36840700001)(46966006)(82310400003)(47076005)(36860700001)(5660300002)(478600001)(107886003)(4326008)(6666004)(2616005)(54906003)(7696005)(86362001)(36906005)(2876002)(2906002)(6916009)(336012)(316002)(26005)(186003)(426003)(36756003)(356005)(82740400003)(83380400001)(70586007)(70206006)(8936002)(8676002)(7636003);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Apr 2021 15:59:29.1583
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 10ebbdaa-3f2c-420b-6f14-08d904de7213
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.35];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT035.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR12MB1312
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Dmytro Linkin <dlinkin@nvidia.com>

Resending, due to the issue with smtp server.

Serries implements devlink rate commands, which are:
- Dump particular or all rate objects (JSON or non-JSON)
- Add/Delete node rate object
- Set tx rate share/max values for rate object
- Set/Unset parent rate object for other rate object

Examples:

Display all rate objects:

    # devlink port function rate show
    pci/0000:03:00.0/1 type leaf parent some_group
    pci/0000:03:00.0/2 type leaf tx_share 12Mbit
    pci/0000:03:00.0/some_group type node tx_share 1Gbps tx_max 5Gbps

Display leaf rate object bound to the 1st devlink port of the
pci/0000:03:00.0 device:

    # devlink port function rate show pci/0000:03:00.0/1
    pci/0000:03:00.0/1 type leaf

Display node rate object with name some_group of the pci/0000:03:00.0
device:

    # devlink port function rate show pci/0000:03:00.0/some_group
    pci/0000:03:00.0/some_group type node

Display leaf rate object rate values using IEC units:

    # devlink -i port function rate show pci/0000:03:00.0/2
    pci/0000:03:00.0/2 type leaf 11718Kibit

Display pci/0000:03:00.0/2 leaf rate object as pretty JSON output:

    # devlink -jp port function rate show pci/0000:03:00.0/2
    {
        "rate": {
            "pci/0000:03:00.0/2": {
                "type": "leaf",
                "tx_share": 1500000
            }
        }
    }

Create node rate object with name "1st_group" on pci/0000:03:00.0 device:

    # devlink port function rate add pci/0000:03:00.0/1st_group

Create node rate object with specified parameters:

    # devlink port function rate add pci/0000:03:00.0/2nd_group \
        tx_share 10Mbit tx_max 30Mbit parent 1st_group

Set parameters to the specified leaf rate object:

    # devlink port function rate set pci/0000:03:00.0/1 \
        tx_share 2Mbit tx_max 10Mbit

Set leaf's parent to "1st_group":

    # devlink port function rate set pci/0000:03:00.0/1 parent 1st_group

Unset leaf's parent:

    # devlink port function rate set pci/0000:03:00.0/1 noparent

Delete node rate object:

    # devlink port function rate del pci/0000:03:00.0/2nd_group

Rate values can be specified in bits or bytes per second (bit|bps), with
any SI (k, m, g, t) or IEC (ki, mi, gi, ti) prefix. Bare number means
bits per second. Units also printed in "show" command output, but not
necessarily the same which were specified with "set" or "add" command.
-i/--iec switch force output in IEC units. JSON output always print
values as bytes per sec.

Dmytro Linkin (4):
  uapi: update devlink kernel header
  devlink: Add helper function to validate object handler
  devlink: Add port func rate support
  devlink: Add ISO/IEC switch

 devlink/devlink.c            | 527 ++++++++++++++++++++++++++++++++++++++++---
 include/uapi/linux/devlink.h |  17 ++
 man/man8/devlink-port.8      |   8 +
 man/man8/devlink-rate.8      | 270 ++++++++++++++++++++++
 man/man8/devlink.8           |   4 +
 5 files changed, 797 insertions(+), 29 deletions(-)
 create mode 100644 man/man8/devlink-rate.8

-- 
1.8.3.1


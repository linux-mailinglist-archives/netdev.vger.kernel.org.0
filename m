Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 08FB739F4D8
	for <lists+netdev@lfdr.de>; Tue,  8 Jun 2021 13:22:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231942AbhFHLYd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Jun 2021 07:24:33 -0400
Received: from mail-mw2nam10on2061.outbound.protection.outlook.com ([40.107.94.61]:33177
        "EHLO NAM10-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231866AbhFHLYc (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 8 Jun 2021 07:24:32 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=iVPsBRLQg/B4wcDjbvqwsRAqiIZijpSLfpycxt3y3kb+LKhSp8vGyFKpJ+1lB+//8enRL4naHVads2q+9hEBdv6Nw/PvVJfwN84qqYHj+0uTdY/kibX3DdYlf9bkx5pTZZkKWDvewdeTB+fyo1krZpAhN4uXuzhpeBNAPyIUb6cLuw3H2P6p7uTK3NSf97AedE7uR/EzhYMZYD3IbdUb/zegVKZxAodqgDR9wioIMveEZlTxaawT0KVNV/BmEZE27EkrO1ju6lnpgp5tL4ExXA42BlioJvGxVK9acfpedw/8NlwirwRg+s/TZj5NlCd5OFNwQGOjOz8Wdn4ax+hX1Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2RQ+sdligX64LjYpL+UG6S82+H9qZ+Ogacj1oFgEjGc=;
 b=nAUJNZE0nKjsAN8d0ul+DMypv9nYlWtBlEc2X9X5lITMhzPmxW/sfRDxkj1KhaLtZSFa4vJhYo7i3pltGYMQTaFvo5ULicUwyY215jR6tYBjZQtDWw4b0EBQXi9aEFWs68zcfASEiMbC3n/jr0GC+G53E3pytB3KTtJ6dSa0c6MULD1x8DoeIIxlEI7KpHsdfkuRRuuRtEsQvBr5jSsOw7A1V0p8K4Xdh6py7rJWvhy13c9wgnWE1Kxq0E3gTWcuVJ0vHbhVB3KeXVRqVYK4YLZQFVY36dquvYjSnJredI25rMLvRdnEUxbI1DuXPRfU7IlKLhCyOGP7qeJU3IQ04A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.32) smtp.rcpttodomain=gmail.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2RQ+sdligX64LjYpL+UG6S82+H9qZ+Ogacj1oFgEjGc=;
 b=FUYvSVYd8Jt2+UfWVu76Awv+nfDtrrys06cX8waAG3e8beMxZvzWp57TCFX/Kn6s9OQpk6PHCNf/7I1SbI6XngRQnxLkx+1f1HQTYxcaxiY8T3GsHvqZGeeKJw/eaaRRRcZD/zc2k7q9pKHxhvfTym42uoU6pY6AeoDCW7UynjRjoXC7JHgpMoVEtlXuI1SpedqEchg7JGg6rwCNYFG0/5h45ok89hEciHeSsap7X6vp8Cqdqz6T5uu1CDlcYKy9Edh7AwEOGE3ANnlMWWHPhSIkkKHRvcum3trR0C97bcpxh2PgjWEqQf7LNRP1hh0m7eVVvt/Wu4wtot0A7oy65Q==
Received: from MW4PR03CA0338.namprd03.prod.outlook.com (2603:10b6:303:dc::13)
 by DM5PR12MB2501.namprd12.prod.outlook.com (2603:10b6:4:b4::34) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4195.27; Tue, 8 Jun
 2021 11:22:38 +0000
Received: from CO1NAM11FT052.eop-nam11.prod.protection.outlook.com
 (2603:10b6:303:dc:cafe::8c) by MW4PR03CA0338.outlook.office365.com
 (2603:10b6:303:dc::13) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4219.20 via Frontend
 Transport; Tue, 8 Jun 2021 11:22:38 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.32)
 smtp.mailfrom=nvidia.com; gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.32 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.32; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.32) by
 CO1NAM11FT052.mail.protection.outlook.com (10.13.174.225) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4195.22 via Frontend Transport; Tue, 8 Jun 2021 11:22:38 +0000
Received: from HQMAIL101.nvidia.com (172.20.187.10) by HQMAIL109.nvidia.com
 (172.20.187.15) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Tue, 8 Jun
 2021 04:22:37 -0700
Received: from vdi.nvidia.com (172.20.187.6) by mail.nvidia.com
 (172.20.187.10) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Tue, 8 Jun 2021 11:22:35 +0000
From:   <dlinkin@nvidia.com>
To:     <netdev@vger.kernel.org>
CC:     <davem@davemloft.net>, <kuba@kernel.org>, <jiri@nvidia.com>,
        <dsahern@gmail.com>, <stephen@networkplumber.org>,
        <vladbu@nvidia.com>, <parav@nvidia.com>, <huyn@nvidia.com>,
        <dlinkin@nvidia.com>
Subject: [PATCH RESEND iproute2 net-next 0/4] devlink rate support
Date:   Tue, 8 Jun 2021 14:22:30 +0300
Message-ID: <1623151354-30930-1-git-send-email-dlinkin@nvidia.com>
X-Mailer: git-send-email 1.8.3.1
MIME-Version: 1.0
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: bd2d449b-c63c-4488-a47a-08d92a6fb927
X-MS-TrafficTypeDiagnostic: DM5PR12MB2501:
X-Microsoft-Antispam-PRVS: <DM5PR12MB2501C7C6C770F2E8D9D1683DCB379@DM5PR12MB2501.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8273;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: qL5RDMKIFnmkfwjHQ9M8DYZDorSz49zQrVI8oJu5rsTJue2oHXzyZftsiFV4wHcS7QhCk6PM9P02/o4JmnwcsC/+FXCMfQ3QPVYjmayhstSzUBR5hOE0LjlomjzzEhfg/BXSwKy8TVRrWLJKUKkxaKYc+QDwW4YEVGrGCRwSy3QLI5u7sb3ABTcjokG48OsD1CvNAt6RylDak3xTIjc2jErdJuxKOQ1lK6JCg48+IsKK6V+0nJ4CPU/tiMYZ7eHDFc81fKQBs1PrfotCvREJf9SPuryzyHM5odkxSqYVuQBfSj+1XX102o5jUVXrlDC5SBdm9dx+u2Nbw4BZlta3QqWA+EYmFqS7gQZU1iKTzudN6Bb+s8Petb0770lX/LCTqlYPm/aDm0wp+hvtuiyrfSuiFztmIicXzhFUX2/Ga7QmRAANPTOnS4MAFQUgO3P/gUE6ocmpqyayVt/XtEH3ebvkos3Gz+alZ5xdqaX3O/oDMHnt1oLVUfl79rzWtQdYWe0/r8/hjDOQz8tp0dQ7XsI697HW8CWegu/99tR2jCvWhOzI1ZVjZRNrQ81lMQxKk6OheiB9c4inpquA0r1rxzWnWaDyVniq2Q9kYPuUe3RMMBMq656nyc5y+OpQw3Q2V+qPQJ1H39jGq39p2FiwWg==
X-Forefront-Antispam-Report: CIP:216.228.112.32;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid01.nvidia.com;CAT:NONE;SFS:(4636009)(346002)(39860400002)(376002)(136003)(396003)(46966006)(36840700001)(86362001)(82310400003)(2906002)(7696005)(26005)(6666004)(36756003)(5660300002)(2616005)(107886003)(2876002)(186003)(47076005)(83380400001)(8936002)(316002)(4326008)(36860700001)(6916009)(8676002)(7636003)(82740400003)(356005)(54906003)(426003)(478600001)(70586007)(70206006)(336012);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Jun 2021 11:22:38.4545
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: bd2d449b-c63c-4488-a47a-08d92a6fb927
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.32];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT052.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR12MB2501
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Dmytro Linkin <dlinkin@nvidia.com>

Resend rebased on top of net-next.

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


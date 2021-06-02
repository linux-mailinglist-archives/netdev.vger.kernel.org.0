Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 50213398990
	for <lists+netdev@lfdr.de>; Wed,  2 Jun 2021 14:31:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229818AbhFBMc4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Jun 2021 08:32:56 -0400
Received: from mail-dm3nam07on2054.outbound.protection.outlook.com ([40.107.95.54]:12001
        "EHLO NAM02-DM3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229610AbhFBMcy (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 2 Jun 2021 08:32:54 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=n+LgopS5j7OOKrVA3UZMvCWtxuLKqoHQWOt7r6OFY2xWA5pnSbJ/MJAEGouVqahxMtR5gKA+H2d2drtZIDrZWYOhsxBT4OFuSe/Kv1fcegfSTtOSCYeyoYJrSkZepHnnH+n4qoCWGqFwznLmlW8PHLaFpscmQ+rTaraGWQtLsnbzWyPn5lp2zJ05nMd8aglQTQ8bVFwX190Ko8+rsSNKeDa3RwPe6pZV1DiL81UVT2VV7PtmoEeHPkzirL0Y/9OK85b3Zo2OzExzsmyrft3+cqvH0isJ3tZ6Hhrx6Hes8HUCY1M1om0BEsSQSnqWMl9/IP1gNVGKgdNwzjkCow2t8g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DRpplJ78U4kAWP1VgbzEpfhxX9oGV9KwGClL/ejQasg=;
 b=B1niUl4L7iedZBbZG+Cr0P/MwOzoKc1dV9leOR+XJ0sbblyJPqXBXXRdDjgvU8Du3ASELjdSzkJfCajEh0icBjWINLRXBEiI0GsZ+mhO3LNaVGCXJ6nyPrrtUAFs/MOy5VlbXV1XAmfO55wrO67CbWWqjmfp+SQaa+QjpY6D8OgayhwGW3FzZoz66G0y976vw2vfyuN1SEJi0tyuutkqNu6Pj72hPQ84NVgaWJisDvkHoB4Y22Q5/RewTr2gD8N7OS7O/ri4xi1jUFcL5U1Vv3KFTpT5YYa9phLfLMKYXBq6/Zpm+2+eyxdMpyhyiyb8FYxNhZAHjIV6hE3llmA9UA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.34) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DRpplJ78U4kAWP1VgbzEpfhxX9oGV9KwGClL/ejQasg=;
 b=U6TE9FJHeLZVPC8GbGCcj/ISZm+y5uoQomQTDUAQ6fICksgALdcTIeawrj1NkHnvE3h0KKgBJdBanwmz9Ajt9bhNOVVlckBJkMdjq9KGGj7wQKA/TaUQiEzIHs7T17F/Kh027d+H5W5+sIzPawH0xpF1jMVf22U5NAe1nYwK5CJaryjXGTY6TPUgzoKZmot+F14U6pWZi0eAxpCKYaztmdMSLb0P3wzZSM/KRMQkjDinF9Kklpdtot1EA8VOUga8m49N24m1gFr4gD6GPvu9R9GTi/TeyICY1bkKJ7xrUWO/YtCq8cTJOEmCOu1KbCF0U56gckqm+WRSnYA9WVcQ7A==
Received: from BN9PR03CA0935.namprd03.prod.outlook.com (2603:10b6:408:108::10)
 by BN6PR1201MB0243.namprd12.prod.outlook.com (2603:10b6:405:50::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4173.22; Wed, 2 Jun
 2021 12:31:09 +0000
Received: from BN8NAM11FT051.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:108:cafe::a0) by BN9PR03CA0935.outlook.office365.com
 (2603:10b6:408:108::10) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4195.21 via Frontend
 Transport; Wed, 2 Jun 2021 12:31:09 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.34)
 smtp.mailfrom=nvidia.com; vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.34 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.34; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.34) by
 BN8NAM11FT051.mail.protection.outlook.com (10.13.177.66) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4150.30 via Frontend Transport; Wed, 2 Jun 2021 12:31:09 +0000
Received: from HQMAIL107.nvidia.com (172.20.187.13) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Wed, 2 Jun
 2021 12:31:09 +0000
Received: from vdi.nvidia.com (172.20.187.6) by mail.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Wed, 2 Jun 2021 12:31:06 +0000
From:   Dmytro Linkin <dlinkin@nvidia.com>
To:     <dlinkin@nvidia.com>
CC:     <davem@davemloft.net>, <dsahern@gmail.com>, <huyn@nvidia.com>,
        <jiri@nvidia.com>, <kuba@kernel.org>, <netdev@vger.kernel.org>,
        <parav@nvidia.com>, <stephen@networkplumber.org>,
        <vladbu@nvidia.com>
Subject: [PATCH RESEND iproute2 net-next 0/4] devlink rate support
Date:   Wed, 2 Jun 2021 15:31:01 +0300
Message-ID: <1622637065-30803-1-git-send-email-dlinkin@nvidia.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1622636251-29892-1-git-send-email-dlinkin@nvidia.com>
References: <1622636251-29892-1-git-send-email-dlinkin@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 91ef4f07-7199-4527-1282-08d925c24d2f
X-MS-TrafficTypeDiagnostic: BN6PR1201MB0243:
X-Microsoft-Antispam-PRVS: <BN6PR1201MB0243E7AC429D1715A340E62FCB3D9@BN6PR1201MB0243.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8273;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: gEoBVibYxoxgiz7pu+NBsn08T8r6r3usBBHIr5rJFP3tgh8OE3ekMOICd8vJVZYM9nd3sdRRj5r0EBkmbjTY9acZwiuuq1/cQKXFkIvq6UDawxoygVcIu+MXrNm19w7fdBY39lZp4Ad9Cf+Z0JsECh6sPdF+t7GZofwWwTY9y+9AVAgRdY/z/nAt6YTsDjme8P8UK/i9woPN4aC7ldScFwBIl6INDCBS3M0V0gO0eOGSew3sSerxL/cWFVTM3JfVeHVkDlA7zg4u7l4UYtTFKSSXZ7p6g+n08U6JSPVzMVr6QReEWuBrt4Qk2JUupWTNhXSO0AY7uVBy0Mh0kVExuvOzlZN2Wd3HsSF7qyiaDT5tnewnhg2K9Sixfwkg5l5xOPvNlXCMKxQnmJEkSpeikddYJs4U9v8f23dAUGMzmpM0+F5U/XXL+vBgp/eaumb3hrGcdx/Qe4CRshpkKI8W0kVLf/V5gYH4Qiz5mdFpICbngI/PmoPg4LKiM9hZ/G0K1bW8z79Am7VrPChwAp3hl9N20WPm68HEhfoGmQ8x/aJeVmUYLOgRF6uHVoXjeMML06j1KK8c0RWH/puNWxWa0Pgc710b/RbWpTpBfZ5ueJvH3Qrrun2pkmyfIIPyssTQX+AUSaIOTtI2/ZTJPSd3IA==
X-Forefront-Antispam-Report: CIP:216.228.112.34;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid03.nvidia.com;CAT:NONE;SFS:(4636009)(376002)(346002)(39860400002)(396003)(136003)(36840700001)(46966006)(6862004)(426003)(2616005)(107886003)(83380400001)(336012)(86362001)(7696005)(7049001)(2906002)(47076005)(8936002)(6200100001)(82740400003)(54906003)(82310400003)(8676002)(7636003)(316002)(37006003)(36906005)(26005)(36860700001)(4326008)(70206006)(186003)(356005)(6666004)(36756003)(70586007)(5660300002)(478600001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Jun 2021 12:31:09.6580
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 91ef4f07-7199-4527-1282-08d925c24d2f
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.34];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT051.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN6PR1201MB0243
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Resending without RFC.

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


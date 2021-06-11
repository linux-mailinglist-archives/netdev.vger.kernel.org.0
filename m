Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E20943A3D0C
	for <lists+netdev@lfdr.de>; Fri, 11 Jun 2021 09:25:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230450AbhFKH1o (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Jun 2021 03:27:44 -0400
Received: from mail-bn8nam12on2051.outbound.protection.outlook.com ([40.107.237.51]:27328
        "EHLO NAM12-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S230233AbhFKH1l (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 11 Jun 2021 03:27:41 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=G0XZ2+MrvTeFiLacWv51vo7KXNTnDHEo8tvQVitSWb/zac1zumwyGFbV7+SV5TsX8YHzCLTY1q0yB6leFtGiahTwLtAn18gSoCbxqq8Jwvyqs9djP7fd6+iP+MxJBcc8CuuZw3te9S9xzuEVB8IkGdtlbIg63rFQ5wnW2tXA3c+Xmg8vBPxSvsz4/C3YK6FxwNQQAx9eXngO+cJI0Y1TvYrOZFQbJumOzMeoOgrqOSSkrw3+zZHEfTa5sgR2T+QlOpOMlL+anqiXeeBLg1KVoNSwiwYcqs+RTXz+USIeWtiZgt0lpDl9eFyqmVOTWmIDl0fju513KVk489KKb8sNLg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=po6rdq+Pzdvy62sCovnxTdh7VJ0U2eN2Blcfxbgc+QM=;
 b=ER2glGc+y5EXDRhwscjaX+SWTSLfZMtcIB1ICiJIoHiMQtYMJDiWtuTZunmw0O6p9Upa9ic6N2w5PZFnramsJIg1W6KFy04CHs6JAQNgFcLrMp9bwx6pnIyfzizQvoJTusIa3vxoBVYcaKZUdJCI+3NPeFn0R1LcQp9SepjzIOv3NUNkS7UxjFm7zequRbulN/eOeS3gsG/n3fSsZVUT84JdDMh+1M9sdxhNUMWcHdF40gEICNXxTP8TRaQ5x1fJjWIeGpTXcG95dkG8GPP4TVodwlEgyum2WYVQjp8eNGzukB8D13VPN13wlXgzAhOZdVobUG2G1+tTvXYRinbeVg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.35) smtp.rcpttodomain=gmail.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=po6rdq+Pzdvy62sCovnxTdh7VJ0U2eN2Blcfxbgc+QM=;
 b=H+C/OTQECJYDsnZ+JqZIxWsoGpY0FR3sM1QlHkZp+i27GwvgrvXMoGQe4OuEwWWJYxCc+r0E99Im1Qxu4ij3x7JJKEySl8ULpAOoj7/3mPZkYjPXR1Rp0QboGo0cX5YUZWdzYJ5yO1fYggY2R4nDwrrnP/uZklDpWHD6xmZdBuOlKwkaIciT1o5G4rbvHMLiBt5a5kXHinfhyQ6s/g1Z3NB9aymtmJrvv7ziudyXROR83FiVd6Z6AHi6lvn4G9wh68xq5vWlCo/DlO6gsNKRK3/P4hdS3FWVpPSj5af0y/UWNByZmyZ0EMKHZS36VITnYjUQ7DKPtjdHcXh1AOFOiw==
Received: from BN6PR2001CA0016.namprd20.prod.outlook.com
 (2603:10b6:404:b4::26) by BN6PR12MB1636.namprd12.prod.outlook.com
 (2603:10b6:405:6::11) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4219.23; Fri, 11 Jun
 2021 07:25:42 +0000
Received: from BN8NAM11FT021.eop-nam11.prod.protection.outlook.com
 (2603:10b6:404:b4:cafe::52) by BN6PR2001CA0016.outlook.office365.com
 (2603:10b6:404:b4::26) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4219.20 via Frontend
 Transport; Fri, 11 Jun 2021 07:25:42 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.35)
 smtp.mailfrom=nvidia.com; gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.35 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.35; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.35) by
 BN8NAM11FT021.mail.protection.outlook.com (10.13.177.114) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4195.22 via Frontend Transport; Fri, 11 Jun 2021 07:25:41 +0000
Received: from HQMAIL101.nvidia.com (172.20.187.10) by HQMAIL111.nvidia.com
 (172.20.187.18) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Fri, 11 Jun
 2021 07:25:41 +0000
Received: from vdi.nvidia.com (172.20.187.5) by mail.nvidia.com
 (172.20.187.10) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Fri, 11 Jun 2021 07:25:38 +0000
From:   <dlinkin@nvidia.com>
To:     <netdev@vger.kernel.org>
CC:     <davem@davemloft.net>, <kuba@kernel.org>, <jiri@nvidia.com>,
        <dsahern@gmail.com>, <stephen@networkplumber.org>,
        <vladbu@nvidia.com>, <parav@nvidia.com>, <huyn@nvidia.com>,
        <dlinkin@nvidia.com>
Subject: [PATCH RESEND2 iproute2 net-next 0/3] devlink rate support
Date:   Fri, 11 Jun 2021 10:25:34 +0300
Message-ID: <1623396337-30106-1-git-send-email-dlinkin@nvidia.com>
X-Mailer: git-send-email 1.8.3.1
MIME-Version: 1.0
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 96762682-7c4f-4e66-8563-08d92caa1ea3
X-MS-TrafficTypeDiagnostic: BN6PR12MB1636:
X-Microsoft-Antispam-PRVS: <BN6PR12MB16360CCF7B7624B0B28B2489CB349@BN6PR12MB1636.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8273;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: CkXKexqf79i0uPTcNNVVbONITnBHEuyNTSp/ynxUFSnxITsPVYq19THkUIZd/hJQ9t0IBmaT6ggK+aK1N4FawINF8lJH6NFd3B/BGdnL/8Cwhh5XKKvCLflw9Z5zDzefHLcFqp8QcQ6G7+WeE96qT0ky2XPBKA7fEmaPhu6cvA2gLmI23ssUrV5mINjgiH5Zc9EgQp0X3N/14xUcxZ7H4v6eBYBCOjPJ7FenJ6gXtNxKTDKDm/DiJYBNAWXV4hEzbxHHAeCwj/PhhahTl8UpdzXSxLxiCxL1toLBHvTW4lyiHkvE9r1XlhKIBVlZmX4QQ8pvLM9H1yxMF04EU86pholt4BS9um1u0Glv33OHMWCMxzdIvUOt/JRZN2HVIa2jLi4isJh1XKFwclmFVRu6/pG9J6gu9crEunyOiHmXgq0/YCGN2LM5ZXnGmQMcozAcuaL8b18vjAAThbdrsuecCcklgCbW+e7D+aw/lkTLpOOxyivR1G9siYCWoEra1zlbLKq7g1sHYPxESAVY+bDNm1CxthAuDPrXXFG12FFRTe/dRNjM1ZkClkLanIcTFrPPVru2gXP+3vRDEtuEBO4PpEketE/6kVh0N2Hc4IfsaeR1V+YpZqCUFoGLdL/cOndm6dAVDw6Be1EL9eW9KV7H+A==
X-Forefront-Antispam-Report: CIP:216.228.112.35;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid02.nvidia.com;CAT:NONE;SFS:(4636009)(39860400002)(396003)(376002)(346002)(136003)(36840700001)(46966006)(36906005)(316002)(2616005)(54906003)(356005)(7636003)(6666004)(26005)(186003)(5660300002)(426003)(336012)(7696005)(478600001)(6916009)(82310400003)(8676002)(83380400001)(2876002)(86362001)(36756003)(70586007)(82740400003)(70206006)(8936002)(47076005)(2906002)(107886003)(36860700001)(4326008);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Jun 2021 07:25:41.8002
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 96762682-7c4f-4e66-8563-08d92caa1ea3
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.35];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT021.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN6PR12MB1636
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Dmytro Linkin <dlinkin@nvidia.com>

Resend rebased on top of net-next. Dropped header update patch.

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

Dmytro Linkin (3):
  devlink: Add helper function to validate object handler
  devlink: Add port func rate support
  devlink: Add ISO/IEC switch

 devlink/devlink.c       | 527 +++++++++++++++++++++++++++++++++++++++++++++---
 man/man8/devlink-port.8 |   8 +
 man/man8/devlink-rate.8 | 270 +++++++++++++++++++++++++
 man/man8/devlink.8      |   4 +
 4 files changed, 780 insertions(+), 29 deletions(-)
 create mode 100644 man/man8/devlink-rate.8

-- 
1.8.3.1


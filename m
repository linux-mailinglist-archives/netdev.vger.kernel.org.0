Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3451135A56E
	for <lists+netdev@lfdr.de>; Fri,  9 Apr 2021 20:13:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234306AbhDISNw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Apr 2021 14:13:52 -0400
Received: from mail-dm6nam10on2040.outbound.protection.outlook.com ([40.107.93.40]:49505
        "EHLO NAM10-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S234446AbhDISNv (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 9 Apr 2021 14:13:51 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=j5M8UnS0eWq8dnmz78KKkOZOyqmJ8X4UJek92YAlyQYI7/Lc6krjMoUlR8Qyzqr8tZHSbMeRmpH5eMqu4sJBelO8ACqZKB8aDdItGnFPGsfaLgmr9u8QbgboHEEy04UTenZzjKnvHUskdhxkjdy+RCcDBhsX7Dlid017uc5yfulFVk2cSRM9F8QAHD6mF2EHKdh+C9ggf1k/ZmMxgqrGwbFJy8R1v7/N/6QC8lGpSMVSLRRc0Fj7LkCrW/8YJ45bw4+8uRO3HNdXkvJlLE3b43dUmh+M18E/IJiGdcbV8+j9TyHv7Rwz/1KJo923/sjGgHT7d0z1UKeRaBK7D8lntg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=I06W/in/Q43zEr4/oc5C0Qw8f6xvmsTqzT/9Z1P7Ph4=;
 b=mWnSp8l+IAyX6P4Y56n/r/5m5AKRiLs1QS7eBex8wmItR7zZ/YvmCpv8SMsN7vAu2kocD8y8EEBKd1coNMfdWV+fYD/E8F0Q4F/Sx5XJ6NSLrCuyevpssX41GkWySglKSrOuFqmJ5h27no8dlkqLGUJJQ/rza+WiAfriARci4ONCbGNExcM6MyWNwQAZtdRD7UoaOUo9hV8mhTkcwlZGPgvPBXd7ltB7rcVkfLhEFJBPI2rnIyra4v+q2TnHZJYXWSqyo1vXs8EjbXYGJTL2/zyfiUxTIl5lbTMDXPpzXhn5TKSbzsZ4ZBap9wsONsMCh69zS4FbRpk8dtSa3/miiQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 149.199.62.198) smtp.rcpttodomain=davemloft.net smtp.mailfrom=xilinx.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=xilinx.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=xilinx.onmicrosoft.com; s=selector2-xilinx-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=I06W/in/Q43zEr4/oc5C0Qw8f6xvmsTqzT/9Z1P7Ph4=;
 b=pJKsEBOYiWyiKrhN7ccgXpn2h7kkkRwZtc6VbolWr5BqselMF44YTTkb6eey2cqJ6rXqK4NUEDzwrz2a+w6ORiD8yu2Fv079FQ4BHr/QO/FWfM1B4D17N7GBEtp+dcPvaDNdJ0PHYthwDWb8o6cRfjV9uRdceXX+zvs8KdZ3VYg=
Received: from MN2PR11CA0006.namprd11.prod.outlook.com (2603:10b6:208:23b::11)
 by DM5PR02MB3894.namprd02.prod.outlook.com (2603:10b6:4:b1::25) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3999.29; Fri, 9 Apr
 2021 18:13:35 +0000
Received: from BL2NAM02FT060.eop-nam02.prod.protection.outlook.com
 (2603:10b6:208:23b:cafe::6d) by MN2PR11CA0006.outlook.office365.com
 (2603:10b6:208:23b::11) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4020.21 via Frontend
 Transport; Fri, 9 Apr 2021 18:13:34 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 149.199.62.198)
 smtp.mailfrom=xilinx.com; davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=pass action=none header.from=xilinx.com;
Received-SPF: Pass (protection.outlook.com: domain of xilinx.com designates
 149.199.62.198 as permitted sender) receiver=protection.outlook.com;
 client-ip=149.199.62.198; helo=xsj-pvapexch02.xlnx.xilinx.com;
Received: from xsj-pvapexch02.xlnx.xilinx.com (149.199.62.198) by
 BL2NAM02FT060.mail.protection.outlook.com (10.152.76.124) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.4020.17 via Frontend Transport; Fri, 9 Apr 2021 18:13:34 +0000
Received: from xsj-pvapexch02.xlnx.xilinx.com (172.19.86.41) by
 xsj-pvapexch02.xlnx.xilinx.com (172.19.86.41) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2106.2; Fri, 9 Apr 2021 11:13:30 -0700
Received: from smtp.xilinx.com (172.19.127.96) by
 xsj-pvapexch02.xlnx.xilinx.com (172.19.86.41) with Microsoft SMTP Server id
 15.1.2106.2 via Frontend Transport; Fri, 9 Apr 2021 11:13:30 -0700
Envelope-to: git@xilinx.com,
 davem@davemloft.net,
 kuba@kernel.org,
 robh+dt@kernel.org,
 vkoul@kernel.org,
 linux-arm-kernel@lists.infradead.org,
 devicetree@vger.kernel.org,
 linux-kernel@vger.kernel.org,
 netdev@vger.kernel.org
Received: from [172.23.64.106] (port=33560 helo=xhdvnc125.xilinx.com)
        by smtp.xilinx.com with esmtp (Exim 4.90)
        (envelope-from <radhey.shyam.pandey@xilinx.com>)
        id 1lUvdJ-0004ls-TF; Fri, 09 Apr 2021 11:13:30 -0700
Received: by xhdvnc125.xilinx.com (Postfix, from userid 13245)
        id 1ED11121386; Fri,  9 Apr 2021 23:43:29 +0530 (IST)
From:   Radhey Shyam Pandey <radhey.shyam.pandey@xilinx.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <robh+dt@kernel.org>,
        <michal.simek@xilinx.com>, <vkoul@kernel.org>
CC:     <devicetree@vger.kernel.org>, <netdev@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>, <git@xilinx.com>,
        Radhey Shyam Pandey <radhey.shyam.pandey@xilinx.com>
Subject: [RFC PATCH 0/3] net: axienet: Introduce dmaengine support
Date:   Fri, 9 Apr 2021 23:43:19 +0530
Message-ID: <1617992002-38028-1-git-send-email-radhey.shyam.pandey@xilinx.com>
X-Mailer: git-send-email 2.1.1
MIME-Version: 1.0
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 2bb8a75c-ed15-4381-d6c1-08d8fb83306e
X-MS-TrafficTypeDiagnostic: DM5PR02MB3894:
X-Microsoft-Antispam-PRVS: <DM5PR02MB389435C956945A845EF6ACB3C7739@DM5PR02MB3894.namprd02.prod.outlook.com>
X-Auto-Response-Suppress: DR, RN, NRN, OOF, AutoReply
X-MS-Oob-TLC-OOBClassifiers: OLM:3173;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: IljkmjHDlQO53vQPVFIEV0MNILQOnmBrIivS0mt8/b9AtYYbKB7hj8xqXbesTCqks85qWcbA9bmqBWGDOUQN0zj800NpXvTWPEEYnzswxTkw2xZWuVyfY0jAB+dN9dBsD/0zFcmz5E/5AHQmtPXFNb0sCQWE/Wmyj8vg366lsN6H0V7WVfSd3zlb1O7dc2qKuowLgxxk7gAXZY8broHD5WD99bao7MKS+44vVlmKWBVPcIuQX62zz4MFcwzEUn2ZaaTB4yW8gQzovtFa46QJf/McbQFp7X0NJJVg3O5NpTzsyhxn1J8hfKC1tQGtaQh3OcNgac8ECOHEgt7Ps8gaTsc7ihbYBe0lkA9/oRBIT7EDcgiyGOFhlAtkcqy5Laolqzvi7oCGFOBdh0BEatw1YafriII+z/hgZPKvIgIwCySwP6G48yo6+yZcxjnv6wpF49WxjjQcfeG6NZ1IgVjqfySpRvJWA2K2yJXhA2qq2vH96LLcWSH44LxQWpHOaAK/RIRN+6UrRHK7C175jXhzGule5teHqGHXIeFWA16CPq/P19aO3KzFbSxpKjArksPTTmFqdsLokuLUGgR14fgP/obdhrDALrOCOXdSrNI6T02qlcRW25oe5Hip0NctX5lZhMevMOIXwAoAH0EZnz4mDnN/3Sf8dZ7UsAO+oKv7P/paZiMB6hBhtBjkV+3iQ529itGyfNmex2uszdxsdKSpv0UYYJQnhCoab6+4EKsTokds6yuI39Tpbb+zd112Am4qqsaU3K6muBipG3p0hXLJlw==
X-Forefront-Antispam-Report: CIP:149.199.62.198;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:xsj-pvapexch02.xlnx.xilinx.com;PTR:unknown-62-198.xilinx.com;CAT:NONE;SFS:(4636009)(396003)(346002)(39860400002)(376002)(136003)(46966006)(36840700001)(356005)(70206006)(36906005)(42186006)(336012)(110136005)(316002)(82310400003)(54906003)(2906002)(83380400001)(426003)(36860700001)(2616005)(7636003)(5660300002)(8676002)(36756003)(107886003)(82740400003)(478600001)(966005)(8936002)(186003)(4326008)(47076005)(6666004)(70586007)(6266002)(26005)(102446001);DIR:OUT;SFP:1101;
X-OriginatorOrg: xilinx.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Apr 2021 18:13:34.3450
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 2bb8a75c-ed15-4381-d6c1-08d8fb83306e
X-MS-Exchange-CrossTenant-Id: 657af505-d5df-48d0-8300-c31994686c5c
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=657af505-d5df-48d0-8300-c31994686c5c;Ip=[149.199.62.198];Helo=[xsj-pvapexch02.xlnx.xilinx.com]
X-MS-Exchange-CrossTenant-AuthSource: BL2NAM02FT060.eop-nam02.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR02MB3894
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The axiethernet driver now uses the dmaengine framework to communicate
with the xilinx DMAengine driver(AXIDMA, MCDMA). The inspiration behind
this dmaengine adoption is to reuse the in-kernel xilinx dma engine 
driver[1] and remove redundant dma programming sequence[2] from the 
ethernet driver. This simplifies the ethernet driver and also makes
it generic to be hooked to any complaint dma IP i.e AXIDMA, MCDMA 
without any modification.

This initial version is a proof of concept and validated with a ping test
on an AXI ethernet subsystem 1G + xilinx AXI DMA design. There is an
anticipated performance impact due to the adoption of the dmaengine 
framework. The plan is to revisit it once all required functional 
features are implemented.

The dmaengine framework was extended for metadata API support during the
axidma RFC[3] discussion. However, it still needs further enhancements to
make it well suited for ethernet usecases. The ethernet features i.e
ethtool set/get of DMA IP properties, ndo_poll_controller, trigger
reset of DMA IP from ethernet are not supported (mentioned in TODO)
and it requires follow-up discussion and dma framework enhancement.

Comments, suggestions, thoughts to implement remaining functional
features are very welcome!

[1]: https://github.com/torvalds/linux/blob/master/drivers/dma/xilinx/xilinx_dma.c
[2]: https://github.com/torvalds/linux/blob/master/drivers/net/ethernet/xilinx/xilinx_axienet_main.c#L238 
[3]: http://lkml.iu.edu/hypermail/linux/kernel/1804.0/00367.html 

This series is based on dmaengine tree commit: #a38fd8748464

Radhey Shyam Pandey (3):
  dt-bindings: net: xilinx_axienet: convert bindings document to yaml
  dt-bindings: net: xilinx_axienet: Introduce dmaengine binding support
  net: axienet: Introduce dmaengine support

 .../devicetree/bindings/net/xilinx_axienet.txt     |   80 --
 .../devicetree/bindings/net/xilinx_axienet.yaml    |  155 +++
 MAINTAINERS                                        |    1 +
 drivers/net/ethernet/xilinx/xilinx_axienet.h       |  141 +--
 drivers/net/ethernet/xilinx/xilinx_axienet_main.c  | 1050 ++++----------------
 5 files changed, 341 insertions(+), 1086 deletions(-)
 delete mode 100644 Documentation/devicetree/bindings/net/xilinx_axienet.txt
 create mode 100644 Documentation/devicetree/bindings/net/xilinx_axienet.yaml

-- 
2.7.4


Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CE41A4802B4
	for <lists+netdev@lfdr.de>; Mon, 27 Dec 2021 18:21:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230124AbhL0RVu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Dec 2021 12:21:50 -0500
Received: from mail-dm3nam07on2057.outbound.protection.outlook.com ([40.107.95.57]:1889
        "EHLO NAM02-DM3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229508AbhL0RVu (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 27 Dec 2021 12:21:50 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=SaO/VusisqT4uTNMs70793KDsE4nya0aPS/ks1XNnEN3W8y/wGsIGKPOvyV9ZhWRCl88mBsbmTQsRUYl4lcfeai6oo/FCxfW7VfMaBftsP/OYvSLJd36Ukp8BKbEX7inaHIdXsjuDqXpoQOUlNRTtODX77sdUyqHT2M43wyJdqUEGnn5xA2nAhYCUCO/AbegVPNnpo2d/27Q2IRtcC5+O9lIESurp8KJdcmmBuTG6BAL2/kzfgVpU/4IQZGz32ZWzO5irOx6iUU16qF3ZQBXcBYQUut6U5hx+sjJSYiyvu++GbBo7gIe215ZsWFK544uF51ZfJRgfydpq89dT8/feQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=IA+KRUzxcy7EpPkf0jMHQd8Qab3G3ZvhQyKoo+92EPM=;
 b=DJtMKzBAB5JRY1dQLgIh19tKdkUY5WxyNIx0Dy2dTTyqBVSVB8btI3ol1wnbhvompHMho9ApHU0Ut5jbKYmgx65Gnn/CJHC5/hpEoN+/hwvHuaAMe9muCV8+tKYWGtsca05oPCHmgZcOynFGd7KEJn+uJRz/wASKDs4dE8TtRjGInZQh8TBufmoPaj/jd1nKguLkaT7xZBqH+e9aC/gqkaz4kKsAIUHHe0DJZuvs3/y7TgQTWAt8BTvj72fVQA7nKpDC6vs6B7r/T8z+BoNW6Qwj5TH0K2K3G6XiiGA98jRjztOx/gO0TSdvpoqypXnCbtDMqEaDMvY9prxAWI1pqw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.236) smtp.rcpttodomain=davemloft.net smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=IA+KRUzxcy7EpPkf0jMHQd8Qab3G3ZvhQyKoo+92EPM=;
 b=BR073ALw7LAj2b/jHqFDGfoXJHUCm58pOnl2EDLUcHHsOQRUjGmhBActsCrYMCC4w2EySLQ9cLQcb6arLzA+rReVkyws0g0Zsno8CIkHcr0NogHovW02CUxjFZgMMev5sRG8eG3/YVqK4tHmXQydMxuxwjj/P8/9Uc8glOdPKU43Y8KFyfhtiUV0PXYN28IFfgrnzPUYprmhu+nolZxfT6Peaev2zC0as/MWlmTb6Mo+X4ROHLpUwuKlI2Nqpf536sUJrMXYuhFwyOxCo1TR2VCRKtqY8lNWEBvmvAqxxtFUn1sRaSRr9pCfE4DNLyef2pJ0FDHlL2tbYd00M6SVkw==
Received: from BN8PR12CA0034.namprd12.prod.outlook.com (2603:10b6:408:60::47)
 by BYAPR12MB2837.namprd12.prod.outlook.com (2603:10b6:a03:68::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4823.17; Mon, 27 Dec
 2021 17:21:47 +0000
Received: from BN8NAM11FT018.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:60:cafe::ef) by BN8PR12CA0034.outlook.office365.com
 (2603:10b6:408:60::47) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4823.19 via Frontend
 Transport; Mon, 27 Dec 2021 17:21:47 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.236)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.236 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.236; helo=mail.nvidia.com;
Received: from mail.nvidia.com (12.22.5.236) by
 BN8NAM11FT018.mail.protection.outlook.com (10.13.176.89) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4823.18 via Frontend Transport; Mon, 27 Dec 2021 17:21:46 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by DRHQMAIL109.nvidia.com
 (10.27.9.19) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Mon, 27 Dec
 2021 17:21:40 +0000
Received: from debil.mellanox.com (172.20.187.6) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id 15.2.986.9; Mon, 27 Dec 2021
 09:21:36 -0800
From:   Nikolay Aleksandrov <nikolay@nvidia.com>
To:     <netdev@vger.kernel.org>
CC:     <eric.dumazet@gmail.com>, <stable@vger.kernel.org>,
        <herbert@gondor.apana.org.au>, <roopa@nvidia.com>,
        <davem@davemloft.net>, <bridge@lists.linux-foundation.org>,
        <kuba@kernel.org>, Nikolay Aleksandrov <nikolay@nvidia.com>
Subject: [PATCH net 0/2] net: bridge: mcast: add and enforce query interval minimum
Date:   Mon, 27 Dec 2021 19:21:14 +0200
Message-ID: <20211227172116.320768-1-nikolay@nvidia.com>
X-Mailer: git-send-email 2.33.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [172.20.187.6]
X-ClientProxiedBy: HQMAIL101.nvidia.com (172.20.187.10) To
 rnnvmail201.nvidia.com (10.129.68.8)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: d05282c0-aba3-4e54-e00e-08d9c95d5c18
X-MS-TrafficTypeDiagnostic: BYAPR12MB2837:EE_
X-Microsoft-Antispam-PRVS: <BYAPR12MB283771C06B525D0671624030DF429@BYAPR12MB2837.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 8Yzxb0RSMHJGRgheVH9w2JbO0jtNi/m2unP14Kbx8s2jUVxLv0P7vp/70j6Dc23rLRfbyIdeBZPBg5Vj43ogT44QqlUM+YNdCdiJN2kXCIQJTicpCwXQELs0SomRWBuSl0lxAUKqyFvo9yvSpZpcK3CTDkHmrMrO4mTdLULF4W/bfMvhqORAonepEcI587CIkirutjrcKiPycvfK9k7kVsMPtFaW1dQjBOxmnqIpuwi/h1DYSPdZRKHe+5x9/PFLWr9dJNZDbyQYDdm6+bo1AljYPzn/wJC1x/Ovh8Z4upz82FA9QfOW6oKK013qfOs/iHzOIpIGKSFO9FkPKYgg7pQSC7c31hXrHxUYiGNwR9cRVDUGs86CWPh4SKQhD56/udDbL8NeFMQnnA+GfpsjrbUyPC5YFiu9ybH8OqLqKAjtOdTvTIPagxjuDCouPUDrEXFxnzITnfnQ6JznuJgijWNP6b6regu67C7kMv/QwasF7/B42CA7V8Mivrvklzq3OSGbhRZaxP4PdUo7JxVFUsG0gdvcoicLtqEVgfajD5BBEQMs566q/jg1O/flghtQL5RLCTAu5wddBY6s+gdvV0I7GHWt/MQSKXI85dWd6EBHv5U9b9HJhemvVoi4ZbsTeCVvwFyojb8f7Gvhxnp+a2BQvtYI3HQhcmALCNvDF60yadcPN57+c0ifbk9c2/M1fZ1zDVLiiqoW+yWdDwXI9UjLwGEbfy43/fdZ7mp23XUOHMONY6MGhLbxZSgIpoL/1xoknKB8T4wlrXLJeWn9TTW0zoqaf5YU2EpLutH3snvRrdv/zDxvyAYqSEx3AKMU4wHRHMMkOF4jgvF96rP59AxhBewulv2Ccd2e6TNLqixrf2uqT88Gg5ZRAoiIMvsq
X-Forefront-Antispam-Report: CIP:12.22.5.236;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(4636009)(36840700001)(40470700002)(46966006)(47076005)(81166007)(36756003)(336012)(36860700001)(316002)(186003)(2906002)(70586007)(86362001)(8676002)(70206006)(1076003)(426003)(2616005)(356005)(6666004)(4326008)(966005)(26005)(83380400001)(508600001)(82310400004)(40460700001)(16526019)(6916009)(107886003)(5660300002)(54906003)(8936002)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Dec 2021 17:21:46.2036
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: d05282c0-aba3-4e54-e00e-08d9c95d5c18
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.236];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT018.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR12MB2837
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,
This set adds and enforces 1 second minimum value for bridge multicast
query and startup query intervals in order to avoid rearming the timers
too often which could lock and crash the host. I doubt anyone is using
such low values or anything lower than 1 second, so it seems like a good
minimum. In order to be compatible if the value is lower then it is
overwritten and a log message is emitted, since we can't return an error
at this point.

Eric, I looked for the syzbot reports in its dashboard but couldn't find
them so I've added you as the reporter. If you point me to the reports
I can respin to give syzbot the credit.

I've prepared a global bridge igmp rate limiting patch but wasn't
sure if it's ok for -net. It adds a static limit of 32k packets per
second, I plan to send it for net-next with added drop counters for
each bridge so it can be easily debugged.

Original report can be seen at:
https://lore.kernel.org/netdev/e8b9ce41-57b9-b6e2-a46a-ff9c791cf0ba@gmail.com/

Thanks,
 Nik

Nikolay Aleksandrov (2):
  net: bridge: mcast: add and enforce query interval minimum
  net: bridge: mcast: add and enforce startup query interval minimum

 net/bridge/br_multicast.c    | 32 ++++++++++++++++++++++++++++++++
 net/bridge/br_netlink.c      |  4 ++--
 net/bridge/br_private.h      |  6 ++++++
 net/bridge/br_sysfs_br.c     |  4 ++--
 net/bridge/br_vlan_options.c |  4 ++--
 5 files changed, 44 insertions(+), 6 deletions(-)

-- 
2.33.1


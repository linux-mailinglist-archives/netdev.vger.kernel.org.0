Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 29570460EB3
	for <lists+netdev@lfdr.de>; Mon, 29 Nov 2021 07:20:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236041AbhK2GX1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Nov 2021 01:23:27 -0500
Received: from mail-mw2nam12on2065.outbound.protection.outlook.com ([40.107.244.65]:50185
        "EHLO NAM12-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229946AbhK2GVZ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 29 Nov 2021 01:21:25 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=b595N6KHCTfJBbPNvag+v32CnicTTj3YbWUlHwlQjk1J7Y8j2063pQ6IPDLlFMQhV7cMqFqM4R1b18eKYPC7NzVv3CdrxLvxxqlYBuS1uRoxl1azPr+wlFZt13wGT4K5IZVkAl29BYNiwxcNY8XDYdlxuAUViwwiECKDLmHbHa8NWJ8JLWf8Y8nMjemgVp4TmEJ98Z4XfDvLz+mJIIHsS5OiMcBofjLfBqAKO5frxSsI0lFC/nHa7+T7oPmxunpauaPu0BakQgUVeu2fYtj+ysPotp8AWRqlbkAQMnDeVND+MEdB+DdfErlb/tW+O+bEEl+Ogj4ndTx+y3a7+Zuc8w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=JecPS8XzzBr1aFuBA0t7l0ZOjkLiVSF9Dtyj7DvgRfc=;
 b=n/+P7MN1YQRWumUX79tdtpTsUTDITDe5ClGIzl6Zyjf+N1jUXAJ5jCV4LqYOGYRf4ibpDAbIYzMQ8M4HKqrgGizdeJ3bSVTlRyk8XTUN3WfvzAgfAbhZxNpzAVeJmSxA8AEZzx6WBMBX5LTAkaDt2JpzC46kAk1uaEAuKIkM4rGp+0qFXHHURsZv7rSgUCYDj/uIxcsYyl4PlVUb4sPBMngmi7AqBOtQcxzr8WngF+q/t1wpGlntykjtFqq0+u57yKkOU68MpJPxC7poKoNn2PaFZ5jgpqX2qiujtDx3cBLJDk+fLsABzxXZf9VnjnbY6l+GTQyEYqWHGXTAc3FoEg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.35) smtp.rcpttodomain=davemloft.net smtp.mailfrom=nvidia.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JecPS8XzzBr1aFuBA0t7l0ZOjkLiVSF9Dtyj7DvgRfc=;
 b=P8xXaGD0ARzPvJWRp0Q7zsrBStY+6KjLlRY8hpItp2R0uzirFA5mF9J1aG5uP6I/HfmYtYquSzELqJiL3YckuccsxnALeLbJG2Y266FvxurOI5wlMa3kz3ix3syljVR2Bzp9pbady/c7g4d88QbQYK/ZDRqfS3zhncnEXp2WX5RaAhgn5XWcmSQ7wV6raAvE4xGWYgJTEwoWGwec+X1/CD3EbzpCDqNnQ1EGpdL8OlrpQqW71nj1Je18EZ7AG1U3JN6AOILxh5Da6i49cUZim1PnzXz9uN7db7B+fYXI3F2zCAdAtcrWnKCoh+w6bocXp7l1KK/d8jNWmyyx63/kWA==
Received: from DM6PR05CA0062.namprd05.prod.outlook.com (2603:10b6:5:335::31)
 by CH2PR12MB3862.namprd12.prod.outlook.com (2603:10b6:610:21::27) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4734.23; Mon, 29 Nov
 2021 06:18:06 +0000
Received: from DM6NAM11FT050.eop-nam11.prod.protection.outlook.com
 (2603:10b6:5:335:cafe::a3) by DM6PR05CA0062.outlook.office365.com
 (2603:10b6:5:335::31) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4755.7 via Frontend
 Transport; Mon, 29 Nov 2021 06:18:06 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.35)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.35 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.35; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.35) by
 DM6NAM11FT050.mail.protection.outlook.com (10.13.173.111) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4734.22 via Frontend Transport; Mon, 29 Nov 2021 06:18:06 +0000
Received: from HQMAIL105.nvidia.com (172.20.187.12) by HQMAIL111.nvidia.com
 (172.20.187.18) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Mon, 29 Nov
 2021 06:18:05 +0000
Received: from HQMAIL107.nvidia.com (172.20.187.13) by HQMAIL105.nvidia.com
 (172.20.187.12) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Mon, 29 Nov
 2021 06:18:05 +0000
Received: from d3.nvidia.com (172.20.187.5) by mail.nvidia.com (172.20.187.13)
 with Microsoft SMTP Server id 15.0.1497.18 via Frontend Transport; Mon, 29
 Nov 2021 06:18:04 +0000
From:   Benjamin Poirier <bpoirier@nvidia.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
CC:     Jiapeng Chong <jiapeng.chong@linux.alibaba.com>,
        Kangmin Park <l4stpr0gr4m@gmail.com>,
        Roopa Prabhu <roopa@cumulusnetworks.com>,
        "Robert Shearman" <rshearma@brocade.com>, <netdev@vger.kernel.org>
Subject: [PATCH net 0/2] net: mpls: Netlink notification fixes
Date:   Mon, 29 Nov 2021 15:15:04 +0900
Message-ID: <20211129061506.221430-1-bpoirier@nvidia.com>
X-Mailer: git-send-email 2.33.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: f70a3973-62ba-4fff-c65a-08d9b30001d4
X-MS-TrafficTypeDiagnostic: CH2PR12MB3862:
X-Microsoft-Antispam-PRVS: <CH2PR12MB3862B15AA75C82140C2BF61EB0669@CH2PR12MB3862.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:873;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 61EKbUqtAOs0h1YFc60sR0rk602SIZwz9Z/LEdC6mFjeGG9gTIWnM0yLrNl8riS4OXUFNgxNwerGXBL+ZkR0vzK3A/3rvRAV0L1t81D/QyBzw7lNaZXnFxYIoHgDavWdxYuNG4W/jFu9kEjo0Jd8tAsydK4SGe2OJSP/LFlffyTnfVIuDn2rsAOdpEcpqIhId6hIzcspY7wgWTIo2osit5hE2eSS0ctM3FFe8hueMCUCjFAYzu3pg5cF3oMVH1ZVivnYWzESFZwOsmRcjk/QaMYwgFuTCE0dJWJu92Ug+ON6XvcW8Iizb41nYyt25lKXI+hm9na5Zt2AFzTm8NjMcrAFZomxaIIwjgRNhmCJaM7sEalH8yNxra94X2UKHPVbJpvyivctVOZReq12qfhH8C/sr9E9BQnPXJqNfiyjqow5tnYjn7SQ44TaCHZjR1bI6rlE95nGf4fVd2daFlWn+Kw03bEPUta8W9+WRl2wRb6nz3DibJh0IIU0Y11DFv3X5yspp7kLaQGNokqgCDlEwSjZalusoX1HAzIcd2Pr9vW/JeYkKIBV0lk+lZ35BUAV15EtJpKURAaYvYLNezeqwtklfj/MHF51L2ZDWDzsafVugRnLRNTF5CHJ0V/wQLgrc+pIqVsS2bVVN3fMEXZqO/zoSZzIrIVO7WpcNIV/xLQZP4FsCzaLOrqLmUonyb3zi/9kYBv/+3myNUGOoFBXhg==
X-Forefront-Antispam-Report: CIP:216.228.112.35;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid02.nvidia.com;CAT:NONE;SFS:(4636009)(36840700001)(46966006)(1076003)(7696005)(2906002)(26005)(4744005)(82310400004)(426003)(36860700001)(336012)(8676002)(4326008)(2616005)(8936002)(36756003)(5660300002)(186003)(15650500001)(70206006)(110136005)(70586007)(54906003)(508600001)(356005)(316002)(83380400001)(47076005)(7636003)(86362001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Nov 2021 06:18:06.0630
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: f70a3973-62ba-4fff-c65a-08d9b30001d4
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.35];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT050.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR12MB3862
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Benjamin Poirier <benjamin.poirier@gmail.com>

fix missing or inaccurate route notifications when devices used in
nexthops are deleted.

Benjamin Poirier (2):
  net: mpls: Fix notifications when deleting a device
  net: mpls: Remove rcu protection from nh_dev

 net/mpls/af_mpls.c  | 97 +++++++++++++++++++++++++++++----------------
 net/mpls/internal.h |  2 +-
 2 files changed, 63 insertions(+), 36 deletions(-)

-- 
2.33.1


Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2A2EA3E3943
	for <lists+netdev@lfdr.de>; Sun,  8 Aug 2021 08:53:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230426AbhHHGxc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 8 Aug 2021 02:53:32 -0400
Received: from mail-bn8nam12on2047.outbound.protection.outlook.com ([40.107.237.47]:50400
        "EHLO NAM12-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S230348AbhHHGxc (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 8 Aug 2021 02:53:32 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jxHfxRRwyqQdL43oo7XkrzPhYfYR7AihT2RadtM63z6jVAG9joAV2fV9idIgY4HbQY2Xde3Trm57G1tkCgijxtgiulrnZAJ9YdSkWNVNTY4U3gU2LXaCB2dJyqY+axi/83Zv9AqbnxbnjSvUa4W5o6IOmidcZwlCjBPdKJPT64IK/yTgMqetuAoLRHJfUD65tedpmycoDcjYWDyiCznTZq+fFEa+pdVyhJWile+MfdgZyUhDOOGY44YTFnqvScF+V1RF9LaB+3sYXAdtgm34vDKoBnkvaFh3nrrk2uuunt5xJKPxC/B6aQOORfBLJBXuum/yqep0iSyoVyJq7A1rYQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZHgQXkzGdXxgySkzYS5Bqjf5uFkrJVtwgxaaikR/h5M=;
 b=f25qzhtdPQO/bNruF57jDUoVvmZFscRT3UTjLQSxCdC/JdX6q/M0z1rqdavewC7BwoMMAbRSexf6RFS+m+M8Ksn9JBUNOULJLxoaYcCgab8QB7ZUZcaw++VyY5PgilHIWPD1cSAePH8RRXxJZsyYr6PIBqlL3k4PWPC4a48e80pH6/gG4jewi3fH5tu2EC31nfTdl2N2ZH7dJeQsocsJMEjARynq/vE3X62m5MHloLhrPJESgdFRPNXOz6exbl9b44BaFSLSoJslC5ISWQs6l5GO/gs74olq9wY8Uo1FLI8AQGhqJacGIG0ALEBEagsuJfnpQ4AnyDL0wp59P2PRcQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.34) smtp.rcpttodomain=davemloft.net smtp.mailfrom=nvidia.com;
 dmarc=pass (p=quarantine sp=none pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZHgQXkzGdXxgySkzYS5Bqjf5uFkrJVtwgxaaikR/h5M=;
 b=mkV3lL1aF/n13qVG3dzxXE+vdQYXfhxlLoG2smUJy4ZmOQjmGLtFL8kj/O7adngBj8xWq7rQRS/YxR2lfnn2e8l7B/eDmpXMcRx6PIFDY+WdnyHaD24qsQdWRx9uYvUOFSuihziLl9kWiG6bEw1+a5bGcANkCTmTR1SWLNljQ4ZtagOoyX81ZJpjr1X6wl7IVulEBLKToi+VTY6SnijhmMZpGz7NHss5+yBcxgyIY26+2InzyqFwWQjc74eZhDF9e1Y9Gz55bC0PkMFJnKT2QqDb/dkR5BUSpLl8kSbUoRri2CMWmTgh6qvF/7Be9HWEWqCKnHXLh458iS85rvhzag==
Received: from MW4P221CA0017.NAMP221.PROD.OUTLOOK.COM (2603:10b6:303:8b::22)
 by MWHPR12MB1712.namprd12.prod.outlook.com (2603:10b6:300:112::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4394.19; Sun, 8 Aug
 2021 06:53:10 +0000
Received: from CO1NAM11FT060.eop-nam11.prod.protection.outlook.com
 (2603:10b6:303:8b:cafe::a) by MW4P221CA0017.outlook.office365.com
 (2603:10b6:303:8b::22) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4394.15 via Frontend
 Transport; Sun, 8 Aug 2021 06:53:10 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.34)
 smtp.mailfrom=nvidia.com; davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.34 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.34; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.34) by
 CO1NAM11FT060.mail.protection.outlook.com (10.13.175.132) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4394.16 via Frontend Transport; Sun, 8 Aug 2021 06:53:10 +0000
Received: from HQMAIL107.nvidia.com (172.20.187.13) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Sun, 8 Aug
 2021 06:53:08 +0000
Received: from dev-r-vrt-138.mtr.labs.mlnx (172.20.187.6) by mail.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Sun, 8 Aug 2021 06:53:07 +0000
From:   Roi Dayan <roid@nvidia.com>
To:     <netdev@vger.kernel.org>
CC:     Roi Dayan <roid@nvidia.com>, Jiri Pirko <jiri@nvidia.com>,
        Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH net 1/1] psample: Add a fwd declaration for skbuff
Date:   Sun, 8 Aug 2021 09:52:42 +0300
Message-ID: <20210808065242.1522535-1-roid@nvidia.com>
X-Mailer: git-send-email 2.26.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 2126c32a-d14a-4a89-420f-08d95a392f5b
X-MS-TrafficTypeDiagnostic: MWHPR12MB1712:
X-Microsoft-Antispam-PRVS: <MWHPR12MB1712CE784C08B4BA9A019817B8F59@MWHPR12MB1712.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:1186;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: bmdzBqAB7RiFcACgsvTpJoKtN+Bu745UrupmMhSguyvwdGIMUqN/5IpVlDOew+w0IJahGskr8yeDtWF9UMmN/VW0apL+jCmL+XCIfmNsGWR6swsiKd+n2IosdnR6348iRDR9qqE6gB8ZNqK+2AilkOrekWV+mVZu9Tmr9NZp78iMCeyWSHj+2D7VnE0DFINLqL40wGa+M+HhxZEEvAkJKMWV+k5GN2zePhd20ddDPbyyUZlV+J/5avqfTxQbKtf+/VMIlRnBd8B9JCj1P6X3TL1x2XpvvPJ7wqhGryWqNijgHgSY4L78KPfksqzisNAsZQwSrfDnRSLuN83T09fZw0nBMRdqt1Rcva7Yskvx+VZCBgC8OGO0yOSWfOCzmHyhJUm9gXMR8YCBXLDwNSVs1C8UVM6AdYsJqR06gtMk7MbOlS+RpJbMHdol+Avl4mGZWM9sSUXskt0d1H1Yeb8b7oP7c9pN1vRArEsqt9RxFvzwsqIh7x58d8jPfz+q7/GGKHnqQRzcsDCdWSzTrQQZ3en5QLDvWuWaelCfUOGSuUxpZhV1JnBCzwrta6jdxPBEdkfpNSi3dHKqJ0oBhgMLRDEVrSMEbe/EMh0mN2pRLHU8qEVOgvq4TaFSbzSJXHkdexJXdW4emXs55EkBt9hyrFb6x/gQzYK2xAVaBdqYUQJBaW2TnwtC+SkjQrz+DhMeyqnjDA0NFCU+0Pbt2cCnCQ==
X-Forefront-Antispam-Report: CIP:216.228.112.34;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid03.nvidia.com;CAT:NONE;SFS:(4636009)(396003)(136003)(39860400002)(346002)(376002)(46966006)(36840700001)(70586007)(70206006)(47076005)(2616005)(426003)(1076003)(8936002)(36860700001)(5660300002)(26005)(4744005)(86362001)(8676002)(82740400003)(7636003)(2906002)(336012)(83380400001)(186003)(478600001)(82310400003)(6916009)(36906005)(6666004)(316002)(356005)(54906003)(4326008)(36756003);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Aug 2021 06:53:10.2721
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 2126c32a-d14a-4a89-420f-08d95a392f5b
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.34];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT060.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR12MB1712
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Without this there is a warning if source files include psample.h
before skbuff.h or doesn't include it at all.

Fixes: 6ae0a6286171 ("net: Introduce psample, a new genetlink channel for packet sampling")
Signed-off-by: Roi Dayan <roid@nvidia.com>
---
 include/net/psample.h | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/include/net/psample.h b/include/net/psample.h
index e328c5127757..0509d2d6be67 100644
--- a/include/net/psample.h
+++ b/include/net/psample.h
@@ -31,6 +31,8 @@ struct psample_group *psample_group_get(struct net *net, u32 group_num);
 void psample_group_take(struct psample_group *group);
 void psample_group_put(struct psample_group *group);
 
+struct sk_buff;
+
 #if IS_ENABLED(CONFIG_PSAMPLE)
 
 void psample_sample_packet(struct psample_group *group, struct sk_buff *skb,
-- 
2.26.3


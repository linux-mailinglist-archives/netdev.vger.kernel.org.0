Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C5797368DE1
	for <lists+netdev@lfdr.de>; Fri, 23 Apr 2021 09:23:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240881AbhDWHYa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 23 Apr 2021 03:24:30 -0400
Received: from mail-dm6nam10on2072.outbound.protection.outlook.com ([40.107.93.72]:17111
        "EHLO NAM10-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S241227AbhDWHY1 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 23 Apr 2021 03:24:27 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Wn5N0HqInXjmZf9nTpIzBfkvjg5P/8/jRFE5xNJYfLcEFYu4HiKfdPf6EJ7Zrtk1VBBpG+k1zcHb4ZbzQ7sKrsq0ragxY0/epQHGnZQ7IVxiipTvp3bMeK8H+B8OuW/YgTGlAOFmFuzEvFDvNb2Ynl6CAkNIBkVZcdIyPvpopbutP3tKTw8LyKIJ3Wmr/eabU8tgR7IASeRxMJB3cu3k8FZtKhTXEMo9T+WaVN4rtqjWLdcur24qWKdcrdNJuvgaYq3VIn+7iB5bDv1erEqKHwtZnDqLfQgcuQ1cgToX9TGxgtTjvyN112QlBuNGVwW1lhj/FcmsNy14T5X6LpSq3g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ObByZxlxAYjNRZT1NMN0MZHZvGOV2qd3a1El6sj4hZ0=;
 b=QNQXmbK1Xbn/9Yl/SADSGIUsdc99eh3sE3gBWUkFelbFWlqcImzONXoXCY0A+rv4+Ls3R2qEVZa14CRpnbWJ252rLUruVjlObRcuSrhWmvuqANDmB2vgwq4oe7YPk0oXdOzAVkrbH7h7kKieBqA580go8wwk/XUIAmcxs+g2I8xohLjcycE+uMlCHPehSRdeKJCkVj7G3VO954BUJk/jD0EZqefH9N2DmwvMreOwfvwAKNRb3IrAhoYoWtB6TML5iQmCuYfBCEV+7pTcUL0UWrURJhEOofHc9Uur5gckNawl2OzBDse9OBr3LWSarcw5dKQtBop1YBNgfAirK/i4DQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.32) smtp.rcpttodomain=thebollingers.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ObByZxlxAYjNRZT1NMN0MZHZvGOV2qd3a1El6sj4hZ0=;
 b=VhOfcqjQ7nA8AFETqLqgmmbW3IBak7+3j6wk2yOTN1n2oDpPBu/qrN1xadAiQSQiUZUJWXRH8FeKYHPmmroHV40yD+R4v4HrDNLRV7tR3gmm/Qp9ADiZ3EIfqzFd1iBo7tBbnRmI3n2jxrIZCSoqtw6lK1vsrcM0JaIqzMTpylBnqjRcYeRWQIFPmAOggTBuYzM1fd3va8SLxoakah4qhiwj+GqIXC6P36F2rLZGWj8XD0u96gAuIjfqq4Yq8xxKokLxz1791jtz8c4rCN67eL6ZoEul7mR66f/T7JOLvGtHtAslbC7ZCra63/KfQdVpSub8TIhgNtEnVRFjZADmoA==
Received: from DM5PR18CA0052.namprd18.prod.outlook.com (2603:10b6:3:22::14) by
 DM5PR12MB2502.namprd12.prod.outlook.com (2603:10b6:4:af::28) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4065.22; Fri, 23 Apr 2021 07:23:51 +0000
Received: from DM6NAM11FT047.eop-nam11.prod.protection.outlook.com
 (2603:10b6:3:22:cafe::d1) by DM5PR18CA0052.outlook.office365.com
 (2603:10b6:3:22::14) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4065.20 via Frontend
 Transport; Fri, 23 Apr 2021 07:23:51 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.32)
 smtp.mailfrom=nvidia.com; thebollingers.org; dkim=none (message not signed)
 header.d=none;thebollingers.org; dmarc=pass action=none
 header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.32 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.32; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.32) by
 DM6NAM11FT047.mail.protection.outlook.com (10.13.172.139) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4065.21 via Frontend Transport; Fri, 23 Apr 2021 07:23:50 +0000
Received: from HQMAIL105.nvidia.com (172.20.187.12) by HQMAIL109.nvidia.com
 (172.20.187.15) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Fri, 23 Apr
 2021 00:23:50 -0700
Received: from vdi.nvidia.com (172.20.145.6) by mail.nvidia.com
 (172.20.187.12) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Fri, 23 Apr 2021 07:23:48 +0000
From:   Moshe Shemesh <moshe@nvidia.com>
To:     Michal Kubecek <mkubecek@suse.cz>, Andrew Lunn <andrew@lunn.ch>,
        "Jakub Kicinski" <kuba@kernel.org>,
        Don Bollinger <don@thebollingers.org>, <netdev@vger.kernel.org>
CC:     Vladyslav Tarasiuk <vladyslavt@nvidia.com>,
        Moshe Shemesh <moshe@nvidia.com>
Subject: [PATCH ethtool-next 4/4] ethtool: Update manpages for getmodule (-m) command
Date:   Fri, 23 Apr 2021 10:23:16 +0300
Message-ID: <1619162596-23846-5-git-send-email-moshe@nvidia.com>
X-Mailer: git-send-email 1.8.4.3
In-Reply-To: <1619162596-23846-1-git-send-email-moshe@nvidia.com>
References: <1619162596-23846-1-git-send-email-moshe@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: f7cbfbcd-6e5b-4fc4-7f41-08d90628be2c
X-MS-TrafficTypeDiagnostic: DM5PR12MB2502:
X-Microsoft-Antispam-PRVS: <DM5PR12MB25029E9F91EE80A56927D6AED4459@DM5PR12MB2502.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7691;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: DN3ycHv8Ag195P77Q0RnBVf7/ncieJJFJyKcJ8o316/Ad66t3wzb9OFwP+BK4Wm0ed8cOn31rWn+FOQyRs7yS9iKfNrqSoaifjo70PIoECMf/ZMifBHTSM9KS72ZHPWLmPabDXe48n61c3N+2c3bUM8XuO1bXH7yXa6yHyo2B1DHMIYqwAMXFHTsKFv2OSbWYfqWgspb+NUy91FaxR3mMSV5nOWxntpkZpeZqPakdGFfQCTEW7r4PEvaL7vcGbPLQLqEfQJ3UovN5gjLs10Ncpn6FwgDjb4nM13Nyn3Q5CQuLazLjVKeLj2ocz2PWw16y9ObT+XvnaSMOtes5nODf9arESV5J4RztnBKSk7SOuW+iIZZASo0V+WDanoYHuZyg/cq4lLLNeGubHZ5gtcIxyUZlvyT85I1TMttn1GBeONwOcdB4snixBhXCqNhCXIedvJiQsUnEMS0VGFkUN4B7zr9GJckHRGzPZ2Z+MLQ9l4fJNs+HESFRMQ4mU5jUGjMuCTakLWhXeE0wGHuaYhkYVaVTCc4Velk3c0yhYYkEmliC1c22eexUJB8X/q9wc1/edxrIv3BU/lWEdcRvPa6HaPVAdkphVjWjhIJ70G73CHWaOywmdArcXZUyRQ4CmUFrSZf045/z2Cjksvji/Jr1A==
X-Forefront-Antispam-Report: CIP:216.228.112.32;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid01.nvidia.com;CAT:NONE;SFS:(4636009)(346002)(136003)(396003)(376002)(39860400002)(46966006)(36840700001)(7696005)(8936002)(2906002)(82310400003)(478600001)(47076005)(82740400003)(8676002)(316002)(356005)(15650500001)(5660300002)(54906003)(110136005)(336012)(36756003)(36860700001)(426003)(186003)(4326008)(86362001)(107886003)(6666004)(83380400001)(70586007)(26005)(2616005)(7636003)(70206006);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Apr 2021 07:23:50.7492
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: f7cbfbcd-6e5b-4fc4-7f41-08d90628be2c
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.32];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT047.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR12MB2502
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladyslav Tarasiuk <vladyslavt@nvidia.com>

Add page, bank and i2c parameters and mention change in offset and
length treatment if either one of new parameters is specified by the
user.

Signed-off-by: Vladyslav Tarasiuk <vladyslavt@nvidia.com>
Reviewed-by: Moshe Shemesh <moshe@nvidia.com>
---
 ethtool.8.in | 14 ++++++++++++++
 1 file changed, 14 insertions(+)

diff --git a/ethtool.8.in b/ethtool.8.in
index fe49b66..9516458 100644
--- a/ethtool.8.in
+++ b/ethtool.8.in
@@ -359,6 +359,9 @@ ethtool \- query or control network driver and hardware settings
 .B2 hex on off
 .BN offset
 .BN length
+.BN page
+.BN bank
+.BN i2c
 .HP
 .B ethtool \-\-show\-priv\-flags
 .I devname
@@ -1154,6 +1157,17 @@ Changes the number of multi-purpose channels.
 Retrieves and if possible decodes the EEPROM from plugin modules, e.g SFP+, QSFP.
 If the driver and module support it, the optical diagnostic information is also
 read and decoded.
+When either one of
+.I page,
+.I bank
+or
+.I i2c
+parameters is specified, dumps only of a single page or its portion is
+allowed. In such a case
+.I offset
+and
+.I length
+parameters are treated relatively to EEPROM page boundaries.
 .TP
 .B \-\-show\-priv\-flags
 Queries the specified network device for its private flags.  The
-- 
2.26.2


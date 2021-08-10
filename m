Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 316D73E5958
	for <lists+netdev@lfdr.de>; Tue, 10 Aug 2021 13:47:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240262AbhHJLrN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Aug 2021 07:47:13 -0400
Received: from mail-dm6nam11on2057.outbound.protection.outlook.com ([40.107.223.57]:25144
        "EHLO NAM11-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S240227AbhHJLrE (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 10 Aug 2021 07:47:04 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=eS6vEecY/xZbdEFguOSQT7XibDHMIpawbHFVWWBcxHthW8vYf6Ml5N5+87lW4KRU0/0Wp3SS0olpZyUcVS5SGEIHeqskW2UxGG3W1j4jofoB2QuWBTXykDXKNCcc8r07cdSiB1OZQefIMforbDetA/hWoqV5u1hNpZJbhT1hyfWfUAdl5+dsdYwXSAVOflHwulULFdEouEfxaFP/bfpQ4pTLJUrl6hWLWnssz3lV1shYysP+P+7zof205zesO1RI3B+2Me5wkO7521CyKyBM5LFGu36cHe7Jf91q8JDegr+69c3PuSIH/5+UjrLRB9bh743bevN9eiuO5/9J3f94XQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lMMYImPDjzX3tlIYCUsUxidRBJpfw8dwpK6xM3+B8nQ=;
 b=aOJrs1aDdl/GkQXcBHhnYPID5WD4lwYk/slREXD+E0/xgWBC5qrXyFq7lckHVZXOE8wIbEpjefcY9fqWaAyGVIifa+8BEskMuY5/Gay1mMVWObQi6n6IEQlu9X8V9Xm9XQDS6V5I5O9yelEdeQCitZ1d/1sXrkNXwMZAVNYn2uVlKvY0Pv1f9jEjX9P4u0nFtt0Wfyrl5PByV2vkMpoyAgp3LeFbkyRhEjIent4Pz/HVz7iwbBAaJiq9M+l+GmbD7Ff/cj46fbkszsQ1d3zcNoR2jLe35Mc5NcpVDmqDFrH+E7J2CfAmRzpQjZnIL4ux2SNVjBaBVVT2FV2VMjQ7Aw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.34) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=quarantine sp=none pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lMMYImPDjzX3tlIYCUsUxidRBJpfw8dwpK6xM3+B8nQ=;
 b=Zn4zvqKoIBEKJBIUVIhI2OxHSvUPAUEHXr5iimsRO3cyFZKRNdgh16FZYW5pJhGL/t1PylXdN6HbMeSqGa01etbD3e4/N0xRz8boGAYQosycxYKqXa1Cm6Jvk9wHvhKrFZhWrTiz9JQYFLIkX8F3SfGKpLLzlCJ4MkWHs9u3eG9gziNmRlFWxfxuKK92Yn9kNT79gcNPwNtjcrS57iHUiUoOXIu1/rjp+OiwmGqqbpmLmfCgPJ+RcneM3ifG+N55XuYTPJQB/qYU6obG+B8PGA2gLP2d0IiX6f0Nh2KgdE7yIMl5AwMQ0HRyVd/yQop0Piw2Z4edhBILBWbYxsIOsA==
Received: from BN9P222CA0017.NAMP222.PROD.OUTLOOK.COM (2603:10b6:408:10c::22)
 by BN6PR1201MB0050.namprd12.prod.outlook.com (2603:10b6:405:4e::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4394.19; Tue, 10 Aug
 2021 11:46:41 +0000
Received: from BN8NAM11FT064.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:10c:cafe::34) by BN9P222CA0017.outlook.office365.com
 (2603:10b6:408:10c::22) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4394.16 via Frontend
 Transport; Tue, 10 Aug 2021 11:46:41 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.34)
 smtp.mailfrom=nvidia.com; vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.34 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.34; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.34) by
 BN8NAM11FT064.mail.protection.outlook.com (10.13.176.160) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4394.16 via Frontend Transport; Tue, 10 Aug 2021 11:46:41 +0000
Received: from sw-mtx-036.mtx.labs.mlnx (172.20.187.6) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Tue, 10 Aug
 2021 11:46:40 +0000
From:   Parav Pandit <parav@nvidia.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <netdev@vger.kernel.org>
CC:     Parav Pandit <parav@nvidia.com>, Jiri Pirko <jiri@nvidia.com>,
        "Leon Romanovsky" <leonro@nvidia.com>
Subject: [PATCH net-next 04/10] devlink: Create a helper function for one parameter registration
Date:   Tue, 10 Aug 2021 14:46:14 +0300
Message-ID: <20210810114620.8397-5-parav@nvidia.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210810114620.8397-1-parav@nvidia.com>
References: <20210810114620.8397-1-parav@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [172.20.187.6]
X-ClientProxiedBy: HQMAIL101.nvidia.com (172.20.187.10) To
 HQMAIL107.nvidia.com (172.20.187.13)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 85b42a41-9a72-49d1-1ab7-08d95bf48545
X-MS-TrafficTypeDiagnostic: BN6PR1201MB0050:
X-Microsoft-Antispam-PRVS: <BN6PR1201MB00502FB69E7C99452137FF3DDCF79@BN6PR1201MB0050.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:597;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: cTjSbE+jvW4AbcZTiaOptOOnUSBBpDmFaMyhYNa7jwVjdWUczlkG9IpRmpzt0IWbs+FiV0nxGVLer4jnkHinrbCErMd7C25sjmjKoPkZzW4T7DUX53QORoWXVrLIN/FsmMiAd3mG4CKiDwo6jaJLNvTSjFDYFG1gp13K89rUCUpKrrP3AGHNnnwwQGC3+5eSqK8fUqDZmfOYY+LvjxXwQJivdaejKEdUG28QdBf2mqHJFtC8ONRJxcTphMlPb9ICNGo0K6T6ryr4p4hSPAB6pXM7QbHlheB7hY9UiMNO00AGdVuIToPlMyZzWgHDc0zJMYFvXDfRpo/lMlhdxJxq32ztIs3417ck9L47+UhvJpAIIsV5Plzn9ix/ArOX2xLzxbfPZluDlXbk2QpJJvpZdcVN2oG8RCv5im7Yh67xTv3zJcC2xKEAyYJEw9BnBFVH1xrAmiWTOftawMO8Iec+On7k6mrIRMG7qkRPby0cP8jvxZyzm2taqqpu3oiqBJKK/MbdgtiIil6hlcEU/BWHfWOwf9e1LDhOJ6Kkbw/GxDEdSlb5YwYj5jsTG7E2vs7HHyH+Sdc6XO6YAWBPkumd2GydqO+ETG9WCohZH1QRN156WIZFDVOgvc6CYpcJaP4Zi3MYhvPsf6xP4RrqdgUlUlh06uwuLD8V3Bz0ANpIZU+vAf0Phm1aTOy7zpho934kIQiJIridt9D6lUYwjRx60A==
X-Forefront-Antispam-Report: CIP:216.228.112.34;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid03.nvidia.com;CAT:NONE;SFS:(4636009)(36840700001)(46966006)(8936002)(316002)(110136005)(86362001)(36860700001)(54906003)(1076003)(508600001)(36906005)(8676002)(36756003)(47076005)(7636003)(2616005)(6666004)(83380400001)(336012)(107886003)(16526019)(186003)(70206006)(70586007)(2906002)(356005)(5660300002)(82310400003)(426003)(4326008)(26005);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Aug 2021 11:46:41.3983
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 85b42a41-9a72-49d1-1ab7-08d95bf48545
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.34];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT064.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN6PR1201MB0050
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Create and use a helper function for one parameter registration.
Subsequent patch also will reuse this for driver facing routine to
register a single parameter.

Signed-off-by: Parav Pandit <parav@nvidia.com>
Reviewed-by: Jiri Pirko <jiri@nvidia.com>
Reviewed-by: Leon Romanovsky <leonro@nvidia.com>
---
 net/core/devlink.c | 24 ++++++++++++++++++------
 1 file changed, 18 insertions(+), 6 deletions(-)

diff --git a/net/core/devlink.c b/net/core/devlink.c
index 867ae7e39788..050dd7271a45 100644
--- a/net/core/devlink.c
+++ b/net/core/devlink.c
@@ -9800,6 +9800,22 @@ static int devlink_param_verify(const struct devlink_param *param)
 		return devlink_param_driver_verify(param);
 }
 
+static int __devlink_param_register_one(struct devlink *devlink,
+					unsigned int port_index,
+					struct list_head *param_list,
+					const struct devlink_param *param,
+					enum devlink_command reg_cmd)
+{
+	int err;
+
+	err = devlink_param_verify(param);
+	if (err)
+		return err;
+
+	return devlink_param_register_one(devlink, port_index,
+					  param_list, param, reg_cmd);
+}
+
 static int __devlink_params_register(struct devlink *devlink,
 				     unsigned int port_index,
 				     struct list_head *param_list,
@@ -9814,12 +9830,8 @@ static int __devlink_params_register(struct devlink *devlink,
 
 	mutex_lock(&devlink->lock);
 	for (i = 0; i < params_count; i++, param++) {
-		err = devlink_param_verify(param);
-		if (err)
-			goto rollback;
-
-		err = devlink_param_register_one(devlink, port_index,
-						 param_list, param, reg_cmd);
+		err = __devlink_param_register_one(devlink, port_index,
+						   param_list, param, reg_cmd);
 		if (err)
 			goto rollback;
 	}
-- 
2.26.2


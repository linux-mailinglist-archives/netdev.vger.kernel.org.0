Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 64DC037C0A5
	for <lists+netdev@lfdr.de>; Wed, 12 May 2021 16:49:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230442AbhELOvB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 May 2021 10:51:01 -0400
Received: from mail-dm6nam11on2083.outbound.protection.outlook.com ([40.107.223.83]:62891
        "EHLO NAM11-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231355AbhELOuV (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 12 May 2021 10:50:21 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=OObK2WqwHKpSb+R5SL+bsCv7ZzXWsvYXf6QHMWnDN7ThT3uQReEMESLUFCprN36eeZjwllC8T7XMtNUJPDHqRe5x4wq25hSie0djK7+0myf5EjXnj5+utm681gzfaYcCoAaWbldlRmHW3ezrvW/cRR3Ah6uOtfPxq6Mm03gb9c2NF5gPYFYu/hlh3QbDPZAvKAiSmsPxXAqJvijNIt9pu2hHuu6mNSyRKIeSIMwKtyj/LTLTmQlOuPEWVM0gl7XVKEL23H3zOMroIo6hDvra9rBIJK6OnX6gegTZOO7fPTjtqO25SBDY7LlRwSvr0q9ge+3wnSC+WrcaUdRyk2lNOg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=m8s2DaLPRJdS/d8/hCJX0xTYb5liTfDINCLFcO9y+cU=;
 b=leoYB+PtAOPfMiZ5EoL6rPkhSFrzLsHMNNOje5Yz0B3JSaCCyL3R12mVnrSkJpSiDdu7/yrcPoc82ulqfEAkrJ2/qQF4mn0iPNZ1lIXP2JYO8LvShoca2oNtS5c/ODSOJ/0JvB0ytGvgzCl0f9TW844O/6AgMlpT1awyGOFpreP4crHYCnlDk+7a+mtlyJUdpEDoYbcvbQSC6pJPYMhtD+udmpOUU3ZOMP86M4TvAG6tRQQ6jLPFuY7FSFEYSJScpRjV5UGSkhhPCqDShr8ImEwZMe1SqNoST68gUjnEfJOzcEdz3EQf7gYLVQtzpiYuX/p0ZLyplTMCCWRaMQncHQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.35) smtp.rcpttodomain=networkplumber.org
 smtp.mailfrom=nvidia.com; dmarc=pass (p=none sp=none pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=m8s2DaLPRJdS/d8/hCJX0xTYb5liTfDINCLFcO9y+cU=;
 b=uG7uAuqwXN/NS9grF6wc0Uvtne+mWFYpf5oTeaCZpvNq47o5scya5va1uImMRWG1fSJRQTCFZb/muX91uMbRCtHyEJWwNi8+M3LvZiGvuO3lrP4cy2CQ1vYVS2BYanOHmudzqjUA41HAysgCpzbNeD81gybpJXb3rX9kc+W9CXv4FqRAmsGBn/DOE6vpmt1ZXC9xuM7r5azUr5j6wOAGB6k2nEknY5tqzdkqUAcaQgUHeLpS067pXswMp4NS2GjGAXBOdljuNNsQRW1pvgAMqHeJe/lS0tskhpVHc5U1h952Oznj7JI+9/CcUtY2xuLpduzch6KK/IGFtVlXBecp3Q==
Received: from BN6PR12CA0042.namprd12.prod.outlook.com (2603:10b6:405:70::28)
 by BN6PR12MB1780.namprd12.prod.outlook.com (2603:10b6:404:107::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4108.24; Wed, 12 May
 2021 14:49:12 +0000
Received: from BN8NAM11FT009.eop-nam11.prod.protection.outlook.com
 (2603:10b6:405:70:cafe::49) by BN6PR12CA0042.outlook.office365.com
 (2603:10b6:405:70::28) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4108.25 via Frontend
 Transport; Wed, 12 May 2021 14:49:12 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.35)
 smtp.mailfrom=nvidia.com; networkplumber.org; dkim=none (message not signed)
 header.d=none;networkplumber.org; dmarc=pass action=none
 header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.35 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.35; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.35) by
 BN8NAM11FT009.mail.protection.outlook.com (10.13.176.65) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4129.25 via Frontend Transport; Wed, 12 May 2021 14:49:12 +0000
Received: from HQMAIL105.nvidia.com (172.20.187.12) by HQMAIL111.nvidia.com
 (172.20.187.18) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Wed, 12 May
 2021 14:49:11 +0000
Received: from vdi.nvidia.com (172.20.145.6) by mail.nvidia.com
 (172.20.187.12) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Wed, 12 May 2021 14:49:09 +0000
From:   <dlinkin@nvidia.com>
To:     <netdev@vger.kernel.org>
CC:     <davem@davemloft.net>, <kuba@kernel.org>, <jiri@nvidia.com>,
        <stephen@networkplumber.org>, <dsahern@gmail.com>,
        <vladbu@nvidia.com>, <parav@nvidia.com>, <huyn@nvidia.com>,
        Dmytro Linkin <dlinkin@nvidia.com>
Subject: [PATCH RFC net-next v2 07/18] netdevsim: Register devlink rate leaf objects per VF
Date:   Wed, 12 May 2021 17:48:36 +0300
Message-ID: <1620830927-11828-8-git-send-email-dlinkin@nvidia.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1620830927-11828-1-git-send-email-dlinkin@nvidia.com>
References: <1620830927-11828-1-git-send-email-dlinkin@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: e2656d0a-5a30-4d06-9f2a-08d915551b5e
X-MS-TrafficTypeDiagnostic: BN6PR12MB1780:
X-Microsoft-Antispam-PRVS: <BN6PR12MB17808EE99A475D7501EC59E1CB529@BN6PR12MB1780.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:31;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: N96Zin49oV3qWXnSOynFJxU1vSfhpszNgEPBZjlAWAE9pf3Ps30LtrEPvjDVRf3JGqf6BSTIZOzFpQIwkg8Hi7mwXmqd6Sa/qV54xIm7Si8IYdP5B2U6Mrxo8SDncNKZaFbWcIaKGxA70bhDvrZjiVuAqXRlLm1jPioGI+A58GxnhdZfy/fD/2AqOt2dkDpzJkHV7+Q2TxMXjXXvD+74E9Utv85cP81nBHnie9cKvCjrWLoZ2ND4X4a/+OsnO+r8wK961Cln6Hv/PP5qXJL6FNdlsdGaDF0HUizrzJYt2Q3CaxLKid1K5ipfAzaGAvzFgwdLGls+COYVoSNLeHKEqjh/OUJ4XaScA9yOUlVU525RrZOmmIbqhJDd1TdwIHo+5azlHOk1vyG9DpfyfmZX49UnOxQrU+qUFYxDrUvmhsJA1ROPIYP+IeKchQAohPrHGt/QDjopllhEH9RZTj9no3micv54y+4IOv0uQ2LXw0SgIlqOKweG0diQ8AzbSe3bDZcnuISSIiMBUpuRq5uGbAhOWpGfHZ7vRU9/lWfDxa5WYV37d+f5Qt48HFRvrxaATyz19Q2Gq5270RE0q71bs3oj44uY2OKx6uDRKmVw/JJuQZeeeFknqvdwBDJEQ3/w39UiEsftessBxTFQxCcXwg==
X-Forefront-Antispam-Report: CIP:216.228.112.35;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid04.nvidia.com;CAT:NONE;SFS:(4636009)(136003)(39860400002)(376002)(346002)(396003)(46966006)(36840700001)(70206006)(6666004)(36860700001)(36756003)(8676002)(6916009)(54906003)(70586007)(316002)(8936002)(2876002)(36906005)(82310400003)(2906002)(4326008)(86362001)(7636003)(47076005)(336012)(82740400003)(2616005)(7696005)(478600001)(26005)(5660300002)(356005)(186003)(107886003)(426003);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 May 2021 14:49:12.3466
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: e2656d0a-5a30-4d06-9f2a-08d915551b5e
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.35];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT009.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN6PR12MB1780
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Dmytro Linkin <dlinkin@nvidia.com>

Register devlink rate leaf objects per VF.

Co-developed-by: Vlad Buslov <vladbu@nvidia.com>
Signed-off-by: Vlad Buslov <vladbu@nvidia.com>
Signed-off-by: Dmytro Linkin <dlinkin@nvidia.com>
Reviewed-by: Jiri Pirko <jiri@nvidia.com>
---
 drivers/net/netdevsim/dev.c | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/drivers/net/netdevsim/dev.c b/drivers/net/netdevsim/dev.c
index ed9ce08..356287a 100644
--- a/drivers/net/netdevsim/dev.c
+++ b/drivers/net/netdevsim/dev.c
@@ -1055,11 +1055,20 @@ static int __nsim_dev_port_add(struct nsim_dev *nsim_dev, enum nsim_dev_port_typ
 		goto err_port_debugfs_exit;
 	}
 
+	if (nsim_dev_port_is_vf(nsim_dev_port)) {
+		err = devlink_rate_leaf_create(&nsim_dev_port->devlink_port,
+					       nsim_dev_port);
+		if (err)
+			goto err_nsim_destroy;
+	}
+
 	devlink_port_type_eth_set(devlink_port, nsim_dev_port->ns->netdev);
 	list_add(&nsim_dev_port->list, &nsim_dev->port_list);
 
 	return 0;
 
+err_nsim_destroy:
+	nsim_destroy(nsim_dev_port->ns);
 err_port_debugfs_exit:
 	nsim_dev_port_debugfs_exit(nsim_dev_port);
 err_dl_port_unregister:
@@ -1074,6 +1083,8 @@ static void __nsim_dev_port_del(struct nsim_dev_port *nsim_dev_port)
 	struct devlink_port *devlink_port = &nsim_dev_port->devlink_port;
 
 	list_del(&nsim_dev_port->list);
+	if (nsim_dev_port_is_vf(nsim_dev_port))
+		devlink_rate_leaf_destroy(&nsim_dev_port->devlink_port);
 	devlink_port_type_clear(devlink_port);
 	nsim_destroy(nsim_dev_port->ns);
 	nsim_dev_port_debugfs_exit(nsim_dev_port);
-- 
1.8.3.1


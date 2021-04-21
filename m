Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 30DD8366F78
	for <lists+netdev@lfdr.de>; Wed, 21 Apr 2021 17:53:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244136AbhDUPyE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Apr 2021 11:54:04 -0400
Received: from mail-mw2nam10on2088.outbound.protection.outlook.com ([40.107.94.88]:15841
        "EHLO NAM10-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S244111AbhDUPyC (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 21 Apr 2021 11:54:02 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Drp6tnvhDwx2RizzniEGwxfJBKqIJFUgElC0VJTOqO0Dk+kTlqKYps68pPgffeoOcT6FPdkE7yyicp8UXlz+vK+i+oZM8lJ58pIiRYZSDu7fJNl4FDVBuwRYWrAGVOyLYX+Ioiej4maVFaM90qBTI/cQ0noYTqgsxv2rHbyEgEHYxs/KvHK2lqyvJxPY2KK6Fj4XpJpBdTRNxnLBkk/YoRJnXc51V5Pm/UwaJeywe6AkHXDzsd4hMzi1fo8j5l7oT5AEfpkQPhHKpShE8p32vYSw/WdzSxZWH5n1VhDqDmpbrisG/eOCQuPH0ZOjJ3vIYXGuwmdG9N8isTHJplb1Vw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=m8s2DaLPRJdS/d8/hCJX0xTYb5liTfDINCLFcO9y+cU=;
 b=RLZvsydgrW9Oag5KQeQHT/qttvZmo0MMRh58IpXpegrrkqa0/G/kOe0s/Nal0R2q1j2Vmn/G/hbIytMf4IcXHX+7LiEJcQbxPRyMcmmXCnMM6rU3LVDhwc4HtGOvcH6a2AEnLuMewxJXhZ9xKm0nCsMECUKrHFB4Nyo/yJ1yhuJUsbBEYJ3zETKKv57E8Nh/Zs592BIm3dArhitNhXwskfMbjfoq4j8i2Ns5tE0QNLg2+p6ZtHcNe/6WL8mQ4OJoO6BsjIQAawKiIimZUBUwLXbaQ7wP0DeqTKH+EjUxyMhZOCw7KJ7sPaGDodkmaoFSysDqlWX98DqF08/CgF254A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.32) smtp.rcpttodomain=networkplumber.org
 smtp.mailfrom=nvidia.com; dmarc=pass (p=none sp=none pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=m8s2DaLPRJdS/d8/hCJX0xTYb5liTfDINCLFcO9y+cU=;
 b=EYUDUnh38td6x9ZSCgmQnFokV2Z99iVGh5DYVrIxiWdi8jHtB+dzWsqufLMPJYMEu+yIbcwz3UdcNQrLhh5YzifVhB9oW9BRDYabHXSjufmSUaEcl6FtoUFsgdGxfu2enNmXjBDcnqIk4OW+6BfQppNsVAhSm63c1PSPsMdqknzY2dRtOwo5IAB0gvTHt5OKKm2/BL1hljHXYKJzM0xt2pEl0zH0AqmL3VCkXTwg9PVtbZA5+Uv8mnUm9E4lP525oi30SRlvMyUvpCC6lJXqobky9fOb2MAvCelzrNuI4WgQ2o35xhmhuvun4/tvI4R8x35Qd7NLQvm62josO34c8g==
Received: from MWHPR20CA0015.namprd20.prod.outlook.com (2603:10b6:300:13d::25)
 by BN6PR12MB1539.namprd12.prod.outlook.com (2603:10b6:405:6::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4042.24; Wed, 21 Apr
 2021 15:53:26 +0000
Received: from CO1NAM11FT010.eop-nam11.prod.protection.outlook.com
 (2603:10b6:300:13d:cafe::88) by MWHPR20CA0015.outlook.office365.com
 (2603:10b6:300:13d::25) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4065.20 via Frontend
 Transport; Wed, 21 Apr 2021 15:53:26 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.32)
 smtp.mailfrom=nvidia.com; networkplumber.org; dkim=none (message not signed)
 header.d=none;networkplumber.org; dmarc=pass action=none
 header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.32 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.32; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.32) by
 CO1NAM11FT010.mail.protection.outlook.com (10.13.175.88) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4065.21 via Frontend Transport; Wed, 21 Apr 2021 15:53:26 +0000
Received: from HQMAIL105.nvidia.com (172.20.187.12) by HQMAIL109.nvidia.com
 (172.20.187.15) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Wed, 21 Apr
 2021 08:53:25 -0700
Received: from vdi.nvidia.com (172.20.145.6) by mail.nvidia.com
 (172.20.187.12) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Wed, 21 Apr 2021 15:53:23 +0000
From:   <dlinkin@nvidia.com>
To:     <netdev@vger.kernel.org>
CC:     <davem@davemloft.net>, <kuba@kernel.org>, <jiri@nvidia.com>,
        <stephen@networkplumber.org>, <dsahern@gmail.com>,
        <vladbu@nvidia.com>, Dmytro Linkin <dlinkin@nvidia.com>
Subject: [PATCH RESEND-2 RFC net-next 07/18] netdevsim: Register devlink rate leaf objects per VF
Date:   Wed, 21 Apr 2021 18:52:54 +0300
Message-ID: <1619020385-20220-8-git-send-email-dlinkin@nvidia.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1619020385-20220-1-git-send-email-dlinkin@nvidia.com>
References: <1619020385-20220-1-git-send-email-dlinkin@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 67b68754-75c9-4d2f-3951-08d904dd99da
X-MS-TrafficTypeDiagnostic: BN6PR12MB1539:
X-Microsoft-Antispam-PRVS: <BN6PR12MB1539C758AE22244329DF5BEFCB479@BN6PR12MB1539.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:31;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: qgiuV6Q6BrEShtR7UlFhUdfiRhY2p3DZ7yl1YZjGjMEHJXf8TstCYDz/GHVfivNpgggvCfb4ZAWpq0J32gigj916Gh+xwC3EMR60waWMa7xFz2NG3YX/4+TQpf+57rm1nJv/VX0g0ZWxSNOXdgFA/wAhQf6KCwTPXcLFgX5dOzJNruTpy/q/7hO026bgGsc1Rw/+SSqLFWVzgyzFBsVdBvZPL2XU+E/vXaHMtlt6er51NWIptHlmWViyy/V5nfId5Q722U6MUXAywDU/B3AjnB6gBahEvsRQSxstP4XEgQXncLdsdoMQpKKFFIRPx1/DTPhI1JMT6K1GzcJX2JisrcAv3qEOskHCZIGv67rsAdA8S6fion8EXQX5yQItq/IC0ShBXEqk1175cOlGDsbQmRhNs1xqHMyWr/zuopiUZe4Gt1CRYKo4rl63paaYouwIEzCMkMwopIh3rl2fjyVXCXiJvPjS544Nn8Y4NFWH55yoIxp4Zd/p76FcehCXcp4hOXXh+WClAItCwgUAviGsMrYO5b3YcUbilShOd2gYkwv85DE9aWBSaoTVvlMSu/R+A4e/VaabLmuf5BniyeksukO49X5bDhXpxocRpoU7zmR2IzV3VRplWiGkLowvoWdxAENwZgw/5bQdGvYCnvG5MQ==
X-Forefront-Antispam-Report: CIP:216.228.112.32;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid01.nvidia.com;CAT:NONE;SFS:(4636009)(396003)(376002)(39860400002)(346002)(136003)(46966006)(36840700001)(186003)(47076005)(70586007)(4326008)(6666004)(336012)(6916009)(316002)(426003)(2876002)(2906002)(70206006)(26005)(2616005)(82310400003)(107886003)(356005)(7696005)(5660300002)(86362001)(8936002)(54906003)(8676002)(36860700001)(36756003)(82740400003)(478600001)(7636003);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Apr 2021 15:53:26.4005
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 67b68754-75c9-4d2f-3951-08d904dd99da
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.32];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT010.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN6PR12MB1539
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


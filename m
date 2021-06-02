Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6BE7639893C
	for <lists+netdev@lfdr.de>; Wed,  2 Jun 2021 14:18:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229911AbhFBMTp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Jun 2021 08:19:45 -0400
Received: from mail-mw2nam10on2086.outbound.protection.outlook.com ([40.107.94.86]:37696
        "EHLO NAM10-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229973AbhFBMTl (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 2 Jun 2021 08:19:41 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HQsiUA/ORHlZ8s6IU7gviZq1OlFPPMKnMTzrs97poUGzLJgoPwh01UE8ngZn2oXDREKdVNeejSIJfrE5lVsoNy/l5A3D+V8c8XkLUy94XQjZmiXmmKUNkyeL80z9FLOiXrSiHEYwz7cyC+mfXyqKvfM0BOUgqJEXgZQemIj0FMOoBEJw/ke4JjQOMFYzvxnNkIYNpUhdkNoOXetbEcNe+jo3acg17bAeQmYEc/5JK8KnBSVycq6jpAi9lql+/0eoVT6eIO9TbAJAJnjQCWg6jrDVnSGdRlfitp3zo55WQfTvs4A0qPdvz5Yf4RrWQwAlCT5G/ym9XEQAxObIgMijTg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=m8s2DaLPRJdS/d8/hCJX0xTYb5liTfDINCLFcO9y+cU=;
 b=MLdVxVd7Sc2QKLq9tGQo04PyXuSI5JhgNyEipxH2rumfsyvug1KBEb3k8mlYO0owB2UpUcIOumvhM6bvxtaNY/KfOrDVcmf3c4PVeTcCTklj4bJ/AMnHsbeRBsf4uPuDMpbo130Proa9FF/CeJxm4HyYXGX86jdUS9phR0i7IaDe2wHSHAEuc8KmbrKuMvE42UXtol09g2TSxu+8zcu48h5+9cY38BkerB88ShaP0350Ws6VXHPJUzAmF+qhYlu/18K4Y/4FJk6AYA8dDCxsWBXkXalJcsy6HQ+NIZd010JquRuo4E9mQeh1lCjIzbh8QT/N7lXSmdbG2z0N9x+e0w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.36) smtp.rcpttodomain=networkplumber.org
 smtp.mailfrom=nvidia.com; dmarc=pass (p=none sp=none pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=m8s2DaLPRJdS/d8/hCJX0xTYb5liTfDINCLFcO9y+cU=;
 b=uBKUFjuwTvgffS1YXH6+Y2hTrPvPMr3n8fahPvBXEr4mCrsXis6Gwi5iqUg/HDnr13+Diz0Bg3ov2nVVMn0/xBKOhOSFiD30bOoJW6gU3H3P2uv9U+DXDKxUsiW47a5SI2Tvj36ud2e73/aZpGzFbsbIY8f2bgQYonJrfyVOFwsSHbh8szc+WMqbIA9LkSG3v9A8ga0JvIESkaDwbnqdGVpF8f6hxMCwO/sC8KT7sjmgPBN3fKTO0kbOjCGypRjxLTe/T8+kD3GYVSbmMJ2JoNxMYNiJMhtjaP6B4+ynYGyxGL9bch/Q7QENIJMJ7mNI11enkIynoxI8vfDceqUDPA==
Received: from MW2PR16CA0007.namprd16.prod.outlook.com (2603:10b6:907::20) by
 BY5PR12MB4275.namprd12.prod.outlook.com (2603:10b6:a03:20a::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4173.21; Wed, 2 Jun
 2021 12:17:57 +0000
Received: from CO1NAM11FT008.eop-nam11.prod.protection.outlook.com
 (2603:10b6:907:0:cafe::22) by MW2PR16CA0007.outlook.office365.com
 (2603:10b6:907::20) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4195.20 via Frontend
 Transport; Wed, 2 Jun 2021 12:17:57 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.36)
 smtp.mailfrom=nvidia.com; networkplumber.org; dkim=none (message not signed)
 header.d=none;networkplumber.org; dmarc=pass action=none
 header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.36 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.36; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.36) by
 CO1NAM11FT008.mail.protection.outlook.com (10.13.175.191) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4150.30 via Frontend Transport; Wed, 2 Jun 2021 12:17:56 +0000
Received: from HQMAIL109.nvidia.com (172.20.187.15) by HQMAIL101.nvidia.com
 (172.20.187.10) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Wed, 2 Jun
 2021 12:17:55 +0000
Received: from vdi.nvidia.com (172.20.187.5) by mail.nvidia.com
 (172.20.187.15) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Wed, 2 Jun 2021 05:17:52 -0700
From:   <dlinkin@nvidia.com>
To:     <netdev@vger.kernel.org>
CC:     <davem@davemloft.net>, <kuba@kernel.org>, <jiri@nvidia.com>,
        <stephen@networkplumber.org>, <dsahern@gmail.com>,
        <vladbu@nvidia.com>, <parav@nvidia.com>, <huyn@nvidia.com>,
        Dmytro Linkin <dlinkin@nvidia.com>
Subject: [PATCH RESEND net-next v3 07/18] netdevsim: Register devlink rate leaf objects per VF
Date:   Wed, 2 Jun 2021 15:17:20 +0300
Message-ID: <1622636251-29892-8-git-send-email-dlinkin@nvidia.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1622636251-29892-1-git-send-email-dlinkin@nvidia.com>
References: <1622636251-29892-1-git-send-email-dlinkin@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: c97e2376-5311-4f04-6340-08d925c074ad
X-MS-TrafficTypeDiagnostic: BY5PR12MB4275:
X-Microsoft-Antispam-PRVS: <BY5PR12MB42751AA2C1395FDA827747C0CB3D9@BY5PR12MB4275.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:31;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: xgiq7SSPcVYwmPoblVkKkxJOIl3osn6qfOsUfzRbcwv8DipEiKGm0IiYfBTP0SMqAL5/o0SYa2M1E1kCPivy9SYJaICx++Xs/mvvW3QujJ3cIoQpawXG65GI0CEaLujSs+Fzxuaq9Zs1m5Z68lJtqvxSQ7SIn77odwP/1lnpvty+lx8ZZKJk85vgT8CFDC6xweTZu5ae1pSrvZwPoM7pkXiOthELuOEM7qYrpUpX9RsRpK09DMV/+SnDWKExNt0gSWHvMjIpXnWz6s2/OZ99DjHgkNYcyzgp4+D+sVSLdillkT9Wo/TNMgn+WG90G3gtKBAk9Bljhu5sGibLIU5l71AtFecNSldpVeye/cQWT+vwma0PyvjdrjUMVXGxP8vhG2NfvLE9dRUQilBCdXy1BQdpXiYtcTesXFy6WhK7ZB4V79Dkhd7BLwtwB2noMzpidvcW0A9qWygK6SCcXJpDj4QpJJ0PVMkjVjOMsBXwWc0DZbBD7+spgQgnxJJaKJ/W8iNR1mftZfIDPEVYSrplxvGIJG5h11HQaPsNIjc8zLHDmvosgrwrub+OX7/WBD6kXmo/DXzCtY9jHCmdjoYFBYTKcjJhomQShK7qytU0j2kgQtfs1ByV1D+gqfDHbt5Pfvcgluer+ANYMWoqgF/p9w==
X-Forefront-Antispam-Report: CIP:216.228.112.36;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid05.nvidia.com;CAT:NONE;SFS:(4636009)(39860400002)(376002)(396003)(136003)(346002)(46966006)(36840700001)(36906005)(36860700001)(4326008)(2876002)(54906003)(82310400003)(2906002)(26005)(6666004)(47076005)(7636003)(478600001)(8676002)(2616005)(426003)(70206006)(336012)(82740400003)(6916009)(356005)(5660300002)(70586007)(8936002)(107886003)(86362001)(316002)(186003)(7696005)(36756003);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Jun 2021 12:17:56.9995
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: c97e2376-5311-4f04-6340-08d925c074ad
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.36];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT008.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR12MB4275
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


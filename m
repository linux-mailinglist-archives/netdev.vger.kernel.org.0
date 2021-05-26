Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8223C3916EF
	for <lists+netdev@lfdr.de>; Wed, 26 May 2021 14:01:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233975AbhEZMDR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 May 2021 08:03:17 -0400
Received: from mail-bn1nam07on2067.outbound.protection.outlook.com ([40.107.212.67]:15751
        "EHLO NAM02-BN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S233100AbhEZMDK (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 26 May 2021 08:03:10 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=N6ae4avtJytMzenPCCBJR9hSiMf7Pn0PuTJABXSNruRDuShPe3Ub5AT2a2QpwiPQBY8SO/J65ovLklC0rkytIrHsKG6UfOrha+M1nVbjkLAMPORaeXozKy5oWDvSN0j/nfbbl1CduqDkPTZASjLd9QukwR6bVFgx9wdNCgGcPuVp5X/IF4/dr/9zMc3H90o/RhVIIifsP5PT4bwg2cxoJda24h54pwsK9T7IUGPI/xh0omHQ8TD01pYj6biDOWbrjSPMGgQz52R7kWx0uxZCGDPjB9Q/NlAEJ1kQUcAmDmUNiQF67hoEv79LYs0xUYIR+Jbq7s5aliiBc0dAc2UMwA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=m8s2DaLPRJdS/d8/hCJX0xTYb5liTfDINCLFcO9y+cU=;
 b=MhHwNrPpOkp/TG0cZCh7VWw/afNd8/1hQsxyKJ+DphKLBPLhctMz5mo8K+o1zzE/7GxNcEf5axhwXagrY09y9iM3oc60geFl4JvFE15fnrt+6RBhhykbIIP2eq1b2tURy7TPt+YEcsXZJr7npBLixYxEN2RkRK1GTiDKdHIbYUprhIqLiJmXW1MxbMkterN50B8cdg3tE54PbaPr8pT3qRaIr72VLXetX6snfrBo4Vy/eq+bc/k1IcOfnvTQqQpw+NVJ749pryrndtMKFrm87x+LqR4VjmepTsiTjoNktjhfpfQ+gEc5gwM/87J839tA3prOCmb8P2hEGjsTG4BrRw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.36) smtp.rcpttodomain=networkplumber.org
 smtp.mailfrom=nvidia.com; dmarc=pass (p=none sp=none pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=m8s2DaLPRJdS/d8/hCJX0xTYb5liTfDINCLFcO9y+cU=;
 b=dt2QyU02r9Iblde3BLwSNAMKaxwkwCvOYnjsNBycH6r9PI5PfSvS1Vzi5zE8ud8///KVWLgSxnjGTYnV4r7PQuLFDfYpIkz17I2EnBZV4e0szYgQiqBdwFI+grkk5h3F3yQqY9DQsGqCBEH1Gbkl0GFfsB2j85+/RtsgKQO0IeokhUiS9XvOTXrPDdY/MaNq8Bxx6Y/wjpeijAa/pM5haIr8VMVb/OW4rhwxtfeedsVEtRtwoaIJRX3aW/xBgLbScBAymri/tkqUG6GiFGiWIsr+obOqAw9yAbuR9J2ktujdg8uIEyDZ+5gIce/9V10RmU5uu+iHu73ZW2oYJPBrxA==
Received: from BN6PR19CA0071.namprd19.prod.outlook.com (2603:10b6:404:e3::33)
 by CH0PR12MB5235.namprd12.prod.outlook.com (2603:10b6:610:d2::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4173.20; Wed, 26 May
 2021 12:01:37 +0000
Received: from BN8NAM11FT005.eop-nam11.prod.protection.outlook.com
 (2603:10b6:404:e3:cafe::12) by BN6PR19CA0071.outlook.office365.com
 (2603:10b6:404:e3::33) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4173.21 via Frontend
 Transport; Wed, 26 May 2021 12:01:36 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.36)
 smtp.mailfrom=nvidia.com; networkplumber.org; dkim=none (message not signed)
 header.d=none;networkplumber.org; dmarc=pass action=none
 header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.36 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.36; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.36) by
 BN8NAM11FT005.mail.protection.outlook.com (10.13.176.69) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4129.25 via Frontend Transport; Wed, 26 May 2021 12:01:36 +0000
Received: from HQMAIL101.nvidia.com (172.20.187.10) by HQMAIL101.nvidia.com
 (172.20.187.10) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Wed, 26 May
 2021 12:01:34 +0000
Received: from vdi.nvidia.com (172.20.145.6) by mail.nvidia.com
 (172.20.187.10) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Wed, 26 May 2021 12:01:32 +0000
From:   <dlinkin@nvidia.com>
To:     <netdev@vger.kernel.org>
CC:     <davem@davemloft.net>, <kuba@kernel.org>, <jiri@nvidia.com>,
        <stephen@networkplumber.org>, <dsahern@gmail.com>,
        <vladbu@nvidia.com>, <parav@nvidia.com>, <huyn@nvidia.com>,
        Dmytro Linkin <dlinkin@nvidia.com>
Subject: [PATCH RFC net-next v3 07/18] netdevsim: Register devlink rate leaf objects per VF
Date:   Wed, 26 May 2021 15:00:59 +0300
Message-ID: <1622030470-21434-8-git-send-email-dlinkin@nvidia.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1622030470-21434-1-git-send-email-dlinkin@nvidia.com>
References: <1622030470-21434-1-git-send-email-dlinkin@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 6bfab394-b837-4278-484a-08d9203e0345
X-MS-TrafficTypeDiagnostic: CH0PR12MB5235:
X-Microsoft-Antispam-PRVS: <CH0PR12MB523529126D736DBFECF4F789CB249@CH0PR12MB5235.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:31;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: HVs6DLEyS6xfTfp2RDLL/Vyf5oXq8pIGHApMBVZ+9JvHjOVXtf84LcO86SZJwwredIzMmeUhiKTir0RPXDi802CyY5/4P6ecUJR/7l3JRCQThCHzjULHqvrayByV+bM7EuBJtFlz6PGRp2n1aOC8WfVB8nzKfzHAi3M+uOhiusUI57qPkp/mns0UQTRw+3hqOQkq7wIO2Myb8AyDFQAmFCr06sRI4HM6DP72KlKMapef4yNDj1KUYAtE9vzi3LpvmU5OCzp8b2evKASBfuyAAx922uDKZczFevOAk5wlUSHgMsUPsjsdjOTVujEBBahy+xmPAngRE8yQFJNlCpeILrv3PRYJGYxQ5WRRpZ4++FXCgDLzoBKSygTCKpbPB2bvVybB3T/YtuA2tUJtLbBJyMbmBnDOuTSSYt1RGBD1Qrjg7lT0losbd7916HSD3KnvgO/XRcQr5m1Rmy+jR+V5WYjIGdnoMMPQbUX+BIa/0Ae2AMKI/Igm4zw0ubRfqDBXXaXRziG6PDhWN1TMAWPOFPJuzgV6fNWtzCP4yJXR1LLDg/X9lhZfoD38kKaRLW4Oxt1IfqvQjBsT33AdmcK3K2PbQ/FGhYcsHk44WwIazxbf4G9e1XsMHUbsw+2JvpP1Ak4wjcTNKFIxjFMawne57A==
X-Forefront-Antispam-Report: CIP:216.228.112.36;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid05.nvidia.com;CAT:NONE;SFS:(4636009)(376002)(136003)(396003)(346002)(39860400002)(36840700001)(46966006)(86362001)(2876002)(54906003)(2906002)(6916009)(82740400003)(5660300002)(7696005)(7636003)(4326008)(316002)(356005)(6666004)(336012)(36756003)(82310400003)(107886003)(8676002)(426003)(70586007)(70206006)(478600001)(186003)(47076005)(8936002)(36860700001)(2616005)(36906005)(26005);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 May 2021 12:01:36.2910
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 6bfab394-b837-4278-484a-08d9203e0345
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.36];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT005.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR12MB5235
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


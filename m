Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6791C58FB36
	for <lists+netdev@lfdr.de>; Thu, 11 Aug 2022 13:24:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234783AbiHKLYw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Aug 2022 07:24:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55248 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234776AbiHKLYv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 11 Aug 2022 07:24:51 -0400
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (mail-sn1anam02on2051.outbound.protection.outlook.com [40.107.96.51])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 577FF13DCF;
        Thu, 11 Aug 2022 04:24:50 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=GjWkaUWrLf3gG9n32Te+7O7e42+iCg4dfVATcd2f/1iEYRxTacZ+vvik9ntA8u9beMUQGwG3f7HK1tndCKKeGRQZxbjoqJJaiHGcUFw4bYFEni2CRQpHdi30oxIm8mlTET/rfsumyPNSPsUbGsyiTQVZr+4z73RVzq3gg7FC5VzuaPFiXJfu+nFJCn0FgdIvPXf8jPqAzvn0a7ZlCPCPxdoxQZCvzeiEiq+F0YHLJwsZAtx+X7PKF1TAU/fo983DA3lnT9QB+m/2UPeiT+jQg2rM8fHxyGGpoU+E4LlAJ2JzLB8DTOJWojB/9YGr8QoBvoEUuGOeA3XnlexISMiopw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=JdMRY4ZfLJhFCAqgBxOAe6TNUxEnOYzMdVpj5r5aHfg=;
 b=SoekFG0i7rGeBObZdoXM4GhWkB/zbJs/peTqP3SYLj5jW2VwQMLor+cU8XC/+iBSLyZt2muAkIyLWlhgbATqt66Wl34gpE8tPtP7Zt1IOh5yPY+JvkUJ+hkFG5mnw/p8MI+1T77MkkmfIb+IXc/kl04TxovQKv+w6K+QBNsQGmoFN4kKAzbH0Hzw67ntrhNonoja5PmM5bfPbnnToQIOiPV8apjkJKdBkbEKja4/flL2Gd1olZFn/hInIJNZcum/aZzfm/MXDy+x8Zfxk5NkZoG/CSCle65pZ438ZODF6uu1RPCy+1bQPHO+Sf3uu1HzM1A+bVMo/10w9IJEHMmWeg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.235) smtp.rcpttodomain=redhat.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JdMRY4ZfLJhFCAqgBxOAe6TNUxEnOYzMdVpj5r5aHfg=;
 b=ShAtZy8/OtIrY7UKWVnxmURQwrMijb24HE9N6H2/r3irh9ZORuV8XJ+N/mkFaq5AHlX+YCnf9akGUyBY/gvv6iwT60MShOPp33nSFGbAk/m4joiVID50XbjVTL8NazQ94uzq/SY2Ry0g9fNQkMnX6Qu7rtKmN+u29ZAwc6XAaTTSyQDsX/L75wh75IR4A5R/lVnnoZULJGujf8Ucqikj2NSRNtuwVvvCVJaznBSCTzfQ9ThDjDQqb5Gd5kz12nGg2K35Mm1SijPep/AwmppS7OHnzvr5nKBC0oqLnM7JJQ4Y0HUZCzOLeJSWJ0nZjiFJl4JrWtqEkEBxyUsh8mHBlw==
Received: from BN9PR03CA0861.namprd03.prod.outlook.com (2603:10b6:408:13d::26)
 by DM6PR12MB4810.namprd12.prod.outlook.com (2603:10b6:5:1f7::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5504.17; Thu, 11 Aug
 2022 11:24:48 +0000
Received: from BN8NAM11FT030.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:13d:cafe::e) by BN9PR03CA0861.outlook.office365.com
 (2603:10b6:408:13d::26) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5504.16 via Frontend
 Transport; Thu, 11 Aug 2022 11:24:48 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.235)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.235 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.235; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (12.22.5.235) by
 BN8NAM11FT030.mail.protection.outlook.com (10.13.177.146) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.5525.11 via Frontend Transport; Thu, 11 Aug 2022 11:24:47 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by DRHQMAIL107.nvidia.com
 (10.27.9.16) with Microsoft SMTP Server (TLS) id 15.0.1497.32; Thu, 11 Aug
 2022 11:24:47 +0000
Received: from yaviefel.vdiclient.nvidia.com (10.126.231.35) by
 rnnvmail201.nvidia.com (10.129.68.8) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.986.29; Thu, 11 Aug 2022 04:24:44 -0700
From:   Petr Machata <petrm@nvidia.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, <netdev@vger.kernel.org>
CC:     <linux-kernel@vger.kernel.org>, Petr Machata <petrm@nvidia.com>,
        "Vadim Pasternak" <vadimp@nvidia.com>,
        Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH net] mlxsw: minimal: Fix deadlock in ports creation
Date:   Thu, 11 Aug 2022 11:57:36 +0200
Message-ID: <f4afce5ab0318617f3866b85274be52542d59b32.1660211614.git.petrm@nvidia.com>
X-Mailer: git-send-email 2.37.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.126.231.35]
X-ClientProxiedBy: rnnvmail202.nvidia.com (10.129.68.7) To
 rnnvmail201.nvidia.com (10.129.68.8)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 853ec161-3c91-4e72-4958-08da7b8c1990
X-MS-TrafficTypeDiagnostic: DM6PR12MB4810:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 2UY8RJGnB8MOrPLKqlMIdC7oAEH5+iFkeX0zRg5yjGcUNfR1A19u81MkvFaKVNqrqXfI0BMLDIdSlALX8rCb2mmLGSo8+zPyldTbppY7QDun9cPuEhItfoxWSlb7Dew4JSz5LUFAAi/+SXqk6xzqYNn+uHXFTalsOHODImPUqt/ufWSwvAx38cHWJ3/T5cMMCaBneroJ+9Otn388w+5xlxpDFf7Ij/jOnqJmeelWUYdtw6cxAnq/oyZQNu7rsLgaLT96sjfjteqDWlV4G99kEokFhUSWBVLuhN8JykiPpoMlxYZHpWMWFDfLYV/lkSG9Qkh+Ghq/7IvpK+pbgtr1TPw9T1LeDQOdnChnRac2hE28a23jPrRNVKGSvE9IgfQsQRq/nIVmt8pcYVuniPhq7Pcb+pL7hijV6mzWvNkiYxnNZLjVVQTZTAWViZzVT4vu/z0hnt8NkozOxDyKMaIiGDpmaagQIThI+WsRLh11eQaGTQ576REkl1+sDJDsDAgpQ0g4ZU3ze2vA+cAqlv1cl44dzWDLRdqMtNRSKI1Idu/R2pEa3wlNjAWzSRFoqCbc//zLR+hvp2+koxvxCZ8ImhWyOSplETGYfP92H9w9bQqfu7ua+PnWMj7rQqJg0zlUY5r2tw6bqo5GPBAJPk6Qb4uT3j0fA1hiOjirYy6JYwO4pLG4GEnux64BK4tYdV3vblltX9X7nIk0Qtbpv1nDvSFDKPMe8krmScfWZAkWI15oYz4MPg1T3MfJBwVRclv57T372H8PuCI7aCaT3AUMYwuhjSesLvtG6QcuueSbTFBh5bYyHnG5acjRpkd/ChjotW0Pm7d6l3dpGc2n3vMgVA==
X-Forefront-Antispam-Report: CIP:12.22.5.235;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230016)(4636009)(376002)(346002)(39860400002)(136003)(396003)(40470700004)(36840700001)(46966006)(81166007)(356005)(82740400003)(16526019)(186003)(2616005)(41300700001)(26005)(47076005)(6666004)(107886003)(7696005)(36860700001)(40480700001)(110136005)(86362001)(426003)(40460700003)(8676002)(70206006)(478600001)(336012)(70586007)(82310400005)(4326008)(54906003)(316002)(5660300002)(36756003)(83380400001)(8936002)(2906002)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Aug 2022 11:24:47.8995
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 853ec161-3c91-4e72-4958-08da7b8c1990
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.235];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT030.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4810
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vadim Pasternak <vadimp@nvidia.com>

Drop devl_lock() / devl_unlock() from ports creation and removal flows
since the devlink instance lock is now taken by mlxsw_core.

Fixes: 72a4c8c94efa ("mlxsw: convert driver to use unlocked devlink API during init/fini")
Signed-off-by: Vadim Pasternak <vadimp@nvidia.com>
Signed-off-by: Ido Schimmel <idosch@nvidia.com>
Signed-off-by: Petr Machata <petrm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlxsw/minimal.c | 7 -------
 1 file changed, 7 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/minimal.c b/drivers/net/ethernet/mellanox/mlxsw/minimal.c
index d9bf584234a6..bb1cd4bae82e 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/minimal.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/minimal.c
@@ -328,7 +328,6 @@ static void mlxsw_m_port_module_unmap(struct mlxsw_m *mlxsw_m, u8 module)
 static int mlxsw_m_ports_create(struct mlxsw_m *mlxsw_m)
 {
 	unsigned int max_ports = mlxsw_core_max_ports(mlxsw_m->core);
-	struct devlink *devlink = priv_to_devlink(mlxsw_m->core);
 	u8 last_module = max_ports;
 	int i;
 	int err;
@@ -357,7 +356,6 @@ static int mlxsw_m_ports_create(struct mlxsw_m *mlxsw_m)
 	}
 
 	/* Create port objects for each valid entry */
-	devl_lock(devlink);
 	for (i = 0; i < mlxsw_m->max_ports; i++) {
 		if (mlxsw_m->module_to_port[i] > 0) {
 			err = mlxsw_m_port_create(mlxsw_m,
@@ -367,7 +365,6 @@ static int mlxsw_m_ports_create(struct mlxsw_m *mlxsw_m)
 				goto err_module_to_port_create;
 		}
 	}
-	devl_unlock(devlink);
 
 	return 0;
 
@@ -377,7 +374,6 @@ static int mlxsw_m_ports_create(struct mlxsw_m *mlxsw_m)
 			mlxsw_m_port_remove(mlxsw_m,
 					    mlxsw_m->module_to_port[i]);
 	}
-	devl_unlock(devlink);
 	i = max_ports;
 err_module_to_port_map:
 	for (i--; i > 0; i--)
@@ -390,10 +386,8 @@ static int mlxsw_m_ports_create(struct mlxsw_m *mlxsw_m)
 
 static void mlxsw_m_ports_remove(struct mlxsw_m *mlxsw_m)
 {
-	struct devlink *devlink = priv_to_devlink(mlxsw_m->core);
 	int i;
 
-	devl_lock(devlink);
 	for (i = 0; i < mlxsw_m->max_ports; i++) {
 		if (mlxsw_m->module_to_port[i] > 0) {
 			mlxsw_m_port_remove(mlxsw_m,
@@ -401,7 +395,6 @@ static void mlxsw_m_ports_remove(struct mlxsw_m *mlxsw_m)
 			mlxsw_m_port_module_unmap(mlxsw_m, i);
 		}
 	}
-	devl_unlock(devlink);
 
 	kfree(mlxsw_m->module_to_port);
 	kfree(mlxsw_m->ports);
-- 
2.35.3


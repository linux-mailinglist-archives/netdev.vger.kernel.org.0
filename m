Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5863868C1E9
	for <lists+netdev@lfdr.de>; Mon,  6 Feb 2023 16:42:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229716AbjBFPmT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Feb 2023 10:42:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46574 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229741AbjBFPmD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Feb 2023 10:42:03 -0500
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on20624.outbound.protection.outlook.com [IPv6:2a01:111:f400:fe59::624])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2244C83F0
        for <netdev@vger.kernel.org>; Mon,  6 Feb 2023 07:41:12 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=YkIBn9jJGKGOvLdnHqH8pqGC1KZN+1D3IZ43zw/+cxLV7AD8gifg46Ifc/fYQnU5uh3bGPOSqk8mmAhgiszUdHSlp+CNDuRmtt/5f/OL+YWKO/+QFLukTcZ+kgHMK1Nyui05sM1RdLqrfUq4JIEMNkAvo1jH/DENlCx8KglkDmXxOTy2QvCDGN+/QV+ArOnfUp6Vn99Qa2VamLFhQ9ORzbTAz+6aGhNRAJjAppfRTJD7Qgextdt/4HccWi+JiRmkk2YW24WxWd312T1qfpK+9MzMCjgqtJatGYiyTneYwDjXQMOkjT3lPzGTmEDqM3FqiMdjHbhChGoP6ecQUUGCeQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=UUmgPvuemPWAfp24J2g5g43j/Of/OTwn1IdBPdkRnQI=;
 b=AyC8m3/lwzbt+OLe/LQPa+00LcT0euhey4KaIcpkslgZ5icVSvFIZdDsb3XAoqbn+YndQFr9vcvNzKiyUwWixqhbr8tUzXTH99Lv7hHyQ0ZFHN5wD4tir+s8Y8SbDa4GfvMQ5Z+vmMQA662lb3DFEGZS1h/yUXrvgz8Agm5oN2ZjbpMPjVfKPbWJWs3Avetnai4DVDB3dCxwE2L5nfH9B5ycPPgy45oxEijb+Sn4V+iFMPdhD1oHhM+UZIPk0vqOJSEWH9p1xQzagXkAUbaT+/z8+/A9slTk++OEa9CSBpSGpyXoL/my++n+LK/b9BkbC62/e159YMP1kokz0tlbCQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=davemloft.net smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=UUmgPvuemPWAfp24J2g5g43j/Of/OTwn1IdBPdkRnQI=;
 b=Xi1tseKWjCqPIhybGePHJoAzConxfnI/BUTlRf2kiX74xRv6onCzDAKwnRz+OnhCywmQw9YK8DVfIMDtlim5TygduAa3jPDSDDjggja3k+S72U+NM0vPPKc3DSHWIXFh1DGeFHJZq9arx0ckVahie3TfZvsO+vGk3vcwlEKCOpdIv60ocVhLBA1P8638my0gTHyEICCJUMED14rMfpPSBkPwotNDFCiAXJUQjUoL+IIWa3jtE36FHTG1PTuifxH30TEJx/yR93cY4QNrYngT7q7DGZPTVKrU6CyWkYzhUfJ5+8/rQzD6tlu0srHrIpCVTMXPnpXVOkg/igj1Zcg4Zg==
Received: from BN9PR03CA0140.namprd03.prod.outlook.com (2603:10b6:408:fe::25)
 by CY5PR12MB6323.namprd12.prod.outlook.com (2603:10b6:930:20::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6064.31; Mon, 6 Feb
 2023 15:39:55 +0000
Received: from BN8NAM11FT069.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:fe:cafe::2c) by BN9PR03CA0140.outlook.office365.com
 (2603:10b6:408:fe::25) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6064.35 via Frontend
 Transport; Mon, 6 Feb 2023 15:39:54 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.160)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 BN8NAM11FT069.mail.protection.outlook.com (10.13.176.152) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6064.35 via Frontend Transport; Mon, 6 Feb 2023 15:39:54 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.36; Mon, 6 Feb 2023
 07:39:47 -0800
Received: from localhost.localdomain (10.126.230.37) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.36; Mon, 6 Feb 2023
 07:39:44 -0800
From:   Petr Machata <petrm@nvidia.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, <netdev@vger.kernel.org>
CC:     Jacob Keller <jacob.e.keller@intel.com>,
        Ido Schimmel <idosch@nvidia.com>,
        Petr Machata <petrm@nvidia.com>, Jiri Pirko <jiri@nvidia.com>,
        "Danielle Ratson" <danieller@nvidia.com>, <mlxsw@nvidia.com>
Subject: [PATCH net-next 1/6] mlxsw: spectrum: Remove pointless call to devlink_param_driverinit_value_set()
Date:   Mon, 6 Feb 2023 16:39:18 +0100
Message-ID: <bb8ddbeb644e9b631445515e338ecf1eef33587e.1675692666.git.petrm@nvidia.com>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <cover.1675692666.git.petrm@nvidia.com>
References: <cover.1675692666.git.petrm@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.126.230.37]
X-ClientProxiedBy: rnnvmail203.nvidia.com (10.129.68.9) To
 rnnvmail201.nvidia.com (10.129.68.8)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN8NAM11FT069:EE_|CY5PR12MB6323:EE_
X-MS-Office365-Filtering-Correlation-Id: 45de4ef3-2b87-4776-bda2-08db085864ee
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: xM9ukB9hT7t447x8yAnDVL4h3Icjcsb6QCvAdVDUZvXwF5Oj7ia4gp7vPbnTUPT6X7TrUJv6n/Iw3froiwhf0TeRFBaHXsCjFXpoDHZP78mTLKtznqTf88hZAX6aWn+8n9ugOKrtEyt+5hQgXBYu6WtcehW2K0u9LmhShWRQIEMOD3OQublSETIevX7u/jizWbklZUSzF++syRqYcAtm+142cX7METiRIq7gTQjWKJ2EOmEPDWB+IeDM4X3EY5B95/zvBl2SH/ugTaBKupNvd7tsNfXORXqrjdnLOeYnu28PV4a134vxkH5cMNBMuh5SfAPfOVOLvAqmbQw1YdcVTPPaRxCcdmMT7xve5L63tqEv2vtW6RzxGqprKDSGBNz0GfoWPMBeQoI4Bbq5d+ZQxX2ng6IB7g+R2OtyWNadabHiBZ7vpRuZiL8JMkLNI9oj/B90BsOSSCIm+s2oCfeLXBMn9oYWbDfwuXukr34qQEgaNIi/zil8N7A31YG5dzOjSpfJGu9uSpty2RnVo2Rz6PTMXKFz19gpaCRLUZnVyDWKeb0FFs+p/IpsO9mFEG5cTPnS1ctpNdWm14Ixt0c5ZEMkffIF/b/7zg29dKuTynP4lxYkrx9+4rqn/v3iwHEGNPDrNqpOSl8GYD36Xuy1hnl8CuLOAjMFjSKXvEJH7y5OWtMSnee3wbhmXTdrEXvGK1BOhlB60IQi4aIBpIlcNg==
X-Forefront-Antispam-Report: CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230025)(4636009)(136003)(396003)(39860400002)(376002)(346002)(451199018)(36840700001)(46966006)(40470700004)(8936002)(41300700001)(5660300002)(4326008)(40460700003)(70206006)(36756003)(70586007)(8676002)(54906003)(26005)(186003)(36860700001)(107886003)(2616005)(83380400001)(6666004)(336012)(426003)(47076005)(110136005)(2906002)(478600001)(316002)(82740400003)(40480700001)(16526019)(82310400005)(7636003)(86362001)(356005);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Feb 2023 15:39:54.4537
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 45de4ef3-2b87-4776-bda2-08db085864ee
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT069.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY5PR12MB6323
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        SPF_HELO_PASS,SPF_NONE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Danielle Ratson <danieller@nvidia.com>

The "acl_region_rehash_interval" devlink parameter is a "runtime"
parameter, making the call to devl_param_driverinit_value_set()
pointless. Before cited commit the function simply returned an error
(that was not checked), but now it emits a WARNING [1].

Fix by removing the function call.

[1]
WARNING: CPU: 0 PID: 7 at net/devlink/leftover.c:10974
devl_param_driverinit_value_set+0x8c/0x90
[...]
Call Trace:
 <TASK>
 mlxsw_sp2_params_register+0x83/0xb0 [mlxsw_spectrum]
 __mlxsw_core_bus_device_register+0x5e5/0x990 [mlxsw_core]
 mlxsw_core_bus_device_register+0x42/0x60 [mlxsw_core]
 mlxsw_pci_probe+0x1f0/0x230 [mlxsw_pci]
 local_pci_probe+0x1a/0x40
 work_for_cpu_fn+0xf/0x20
 process_one_work+0x1db/0x390
 worker_thread+0x1d5/0x3b0
 kthread+0xe5/0x110
 ret_from_fork+0x1f/0x30
 </TASK>

Fixes: 85fe0b324c83 ("devlink: make devlink_param_driverinit_value_set() return void")
Signed-off-by: Danielle Ratson <danieller@nvidia.com>
Reviewed-by: Ido Schimmel <idosch@nvidia.com>
Signed-off-by: Petr Machata <petrm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlxsw/spectrum.c | 14 ++------------
 1 file changed, 2 insertions(+), 12 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum.c
index b0bdb9640ebf..b150e97b97b7 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum.c
@@ -3895,19 +3895,9 @@ static const struct devlink_param mlxsw_sp2_devlink_params[] = {
 static int mlxsw_sp2_params_register(struct mlxsw_core *mlxsw_core)
 {
 	struct devlink *devlink = priv_to_devlink(mlxsw_core);
-	union devlink_param_value value;
-	int err;
 
-	err = devl_params_register(devlink, mlxsw_sp2_devlink_params,
-				   ARRAY_SIZE(mlxsw_sp2_devlink_params));
-	if (err)
-		return err;
-
-	value.vu32 = 0;
-	devl_param_driverinit_value_set(devlink,
-					MLXSW_DEVLINK_PARAM_ID_ACL_REGION_REHASH_INTERVAL,
-					value);
-	return 0;
+	return devl_params_register(devlink, mlxsw_sp2_devlink_params,
+				    ARRAY_SIZE(mlxsw_sp2_devlink_params));
 }
 
 static void mlxsw_sp2_params_unregister(struct mlxsw_core *mlxsw_core)
-- 
2.39.0


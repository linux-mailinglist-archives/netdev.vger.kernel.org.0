Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CA5036E4E9F
	for <lists+netdev@lfdr.de>; Mon, 17 Apr 2023 18:54:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229585AbjDQQyH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Apr 2023 12:54:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33158 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229485AbjDQQyG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Apr 2023 12:54:06 -0400
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (mail-sn1nam02on2089.outbound.protection.outlook.com [40.107.96.89])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 709C58F
        for <netdev@vger.kernel.org>; Mon, 17 Apr 2023 09:54:04 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=EZAFEdDMx/m88ERbocEpwf8LmUpwRplGIMlnQuxaawjut8vNk6hZBxk/aFESGaQAmeps0kpDISxsKJ+g41UfmuNz2jRdPvYujxhUvkyFVDOrhwZ1V4m63c1BAxcNh6EpsbN6gfrMX5QgCRR9FtBo1KEvNLFv/m1GbI5QwgFcGh6cEYwXkXKguEddCASQKI8WKrhCmSKubGelhPN72IklPA2Yb5USbVQ7+WLwNe/7wt2YAM/6b3iSCSHfmmYGnOK2MQO5AdKAKnZQjmvv84RmF2FniJ19yyl0Fa69chrt1DXHINJFs7F54QREQ53nmSbLnR5k75IFe0LizB4e8BalXg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=wHiG6xpHMRRr9qJuSetv4Oc6+ExTon6Izobzzho84VA=;
 b=T5bezR7AOe2WPOZrRW+r7BGp9oeIas2goRodgZiBHcworm4jIfV98PAsTJz7gIjeCXSaEnm5Oy4Mh816v0kSuYhRkbSPGMCHi6Q7CThOw0iV9p2uD7BVheC4B75B6fdjDRVQ6dHvhI+igTfJEGpPy+o/v94zhpyM2FnSczp417CSL/7MfCGV3lBxTW+WrednAyLR+pzRVoR12FAKmyj/6qBOzvAr1DoQB2ybkUdqHZdiLvvd+FXHMfhE+29BCCd9GqQQT7wMybnua4fSY0CLo0+CqhKmO3CLbgl5J7nf4HCEpFtMrRWFCS06dSzdb9dFhf7Zu11q/nuJ0NVaiDOAkw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=davemloft.net smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wHiG6xpHMRRr9qJuSetv4Oc6+ExTon6Izobzzho84VA=;
 b=q5HzV9OwgNMsLE6QGCXIzTapyWBMjpG2M3/pBDCc/VFSsbQAx+kqu6DACxg5iOjYgISxIxwgy1tvjE4TKXPNSOd9lvZ0OPOyO5+0ixzCYE6bmPyLaPMEjVf5LRwhLHvvNs3zNdWwJaydNEWKcVzRAfjvbPFrizAgOZ3TftSHZAKdqu3nOFW9dYown3UWeYWwcxdlUFjlNmKHmMWa+tqd/mHVbVtIeqw/2UtDX2+6qayfh2wnanqwCAH7+1ICzmy07CUmCcwtUjQ9SN0Bts8yPMvjPqW891oRX5keL5/TH3+71c5ErL0DY3lSvUN/kAiz5IIpYY5dH8s+on8l2Celmg==
Received: from BN8PR04CA0038.namprd04.prod.outlook.com (2603:10b6:408:d4::12)
 by DM6PR12MB4451.namprd12.prod.outlook.com (2603:10b6:5:2ab::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6298.45; Mon, 17 Apr
 2023 16:54:02 +0000
Received: from BN8NAM11FT064.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:d4:cafe::b9) by BN8PR04CA0038.outlook.office365.com
 (2603:10b6:408:d4::12) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6298.46 via Frontend
 Transport; Mon, 17 Apr 2023 16:54:02 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 BN8NAM11FT064.mail.protection.outlook.com (10.13.176.160) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6319.19 via Frontend Transport; Mon, 17 Apr 2023 16:54:01 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.5; Mon, 17 Apr 2023
 09:53:46 -0700
Received: from yaviefel.vdiclient.nvidia.com (10.126.230.37) by
 rnnvmail201.nvidia.com (10.129.68.8) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.986.37; Mon, 17 Apr 2023 09:53:43 -0700
From:   Petr Machata <petrm@nvidia.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, <netdev@vger.kernel.org>
CC:     Ido Schimmel <idosch@nvidia.com>, Petr Machata <petrm@nvidia.com>,
        "Amit Cohen" <amitc@mellanox.com>, <mlxsw@nvidia.com>
Subject: [PATCH net] mlxsw: pci: Fix possible crash during initialization
Date:   Mon, 17 Apr 2023 18:52:51 +0200
Message-ID: <303aa6102f0f9a8be9af749342d2afc82dd9dc53.1681749167.git.petrm@nvidia.com>
X-Mailer: git-send-email 2.39.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.126.230.37]
X-ClientProxiedBy: rnnvmail203.nvidia.com (10.129.68.9) To
 rnnvmail201.nvidia.com (10.129.68.8)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN8NAM11FT064:EE_|DM6PR12MB4451:EE_
X-MS-Office365-Filtering-Correlation-Id: a0d1aece-2f8c-4165-6ab1-08db3f645896
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 4TMyLOFvMXv5vzRLrtLWz1Zx6xhcsKH18xkPHzAReyBJFXaH7fsZo+yUgz9x7jxCPnjCuhI54ZdzdLJcKx6v4OVLxfPpKpB79e5MtvZ2/3XCWdTaMR3IOH3gbGZ1C4IAjELcwRPdVGNkVc73r0UfxBGg13r/yTMisPdBAhNkS31e+swBtehIC1Es68+YxP3GPx2CGWrM2mqt7Pk/iB7mwfzDDUGPueF5w4kGOEgyVMsQ8zOwIMKF8IAoJJGnfSLRiRBmo73Y+Ng35R8zUyHGg6y+0uAWzRxU29Lt9ZwujR2AlUN+8oqNwF+CjU5sum4sTuDjHjcorgh1EGV6UjtWkwHMd/8Y9R2x+cLUtXW8VnRg0vgR5R7M++Hs89GRCei6oXsYV8/0D3pCqIxz3gixe3nZht35bo1L4DL8pvm9+jB+9wI41e1m1FAPl4ksFkFQxvJsM377AS9xDUC9y8I2YYOw0IXxClGiOhQagbxIVXkwQz+q4MKkpDzcXAkskRIIueCgUgNUhnwCbrMKOz2XnVE7JnmeQYmwTPoW11xpTJrjcrw1xY04AcSMdBoeVDj175Y9IKNl1lF8u2+rCcMJAo5OkagUG9YMmCwxEMZAQeNL9QQLpQ4FcIk7B4w2XwXFYJSlfwxgjVLFtAK4BKbp6ovsqTMwf+xvMQ9dc1pLWbwpPLvLyCH3gdtqJXgXQ7JeK1X8yYo/1ieenT8qbxjSSYS65uc7qPGLlYDhXPTp3rpfZyTgfZ+He7D2QpTlFxdlabO9K3cE8dGg0499tOYJEVL++S6fdpOZ8l7AyxebfpI=
X-Forefront-Antispam-Report: CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230028)(4636009)(376002)(346002)(136003)(39860400002)(396003)(451199021)(46966006)(40470700004)(36840700001)(36860700001)(54906003)(110136005)(2616005)(107886003)(26005)(34020700004)(478600001)(82740400003)(70586007)(70206006)(47076005)(316002)(83380400001)(7696005)(6666004)(186003)(16526019)(336012)(426003)(4326008)(7636003)(356005)(41300700001)(8936002)(8676002)(2906002)(5660300002)(36756003)(82310400005)(40460700003)(40480700001)(86362001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Apr 2023 16:54:01.6558
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: a0d1aece-2f8c-4165-6ab1-08db3f645896
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT064.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4451
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ido Schimmel <idosch@nvidia.com>

During initialization the driver issues a reset command via its command
interface in order to remove previous configuration from the device.

After issuing the reset, the driver waits for 200ms before polling on
the "system_status" register using memory-mapped IO until the device
reaches a ready state (0x5E). The wait is necessary because the reset
command only triggers the reset, but the reset itself happens
asynchronously. If the driver starts polling too soon, the read of the
"system_status" register will never return and the system will crash
[1].

The issue was discovered when the device was flashed with a development
firmware version where the reset routine took longer to complete. The
issue was fixed in the firmware, but it exposed the fact that the
current wait time is borderline.

Fix by increasing the wait time from 200ms to 400ms. With this patch and
the buggy firmware version, the issue did not reproduce in 10 reboots
whereas without the patch the issue is reproduced quite consistently.

[1]
mce: CPUs not responding to MCE broadcast (may include false positives): 0,4
mce: CPUs not responding to MCE broadcast (may include false positives): 0,4
Kernel panic - not syncing: Timeout: Not all CPUs entered broadcast exception handler
Shutting down cpus with NMI
Kernel Offset: 0x12000000 from 0xffffffff81000000 (relocation range: 0xffffffff80000000-0xffffffffbfffffff)

Fixes: ac004e84164e ("mlxsw: pci: Wait longer before accessing the device after reset")
Signed-off-by: Ido Schimmel <idosch@nvidia.com>
Reviewed-by: Petr Machata <petrm@nvidia.com>
Signed-off-by: Petr Machata <petrm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlxsw/pci_hw.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/pci_hw.h b/drivers/net/ethernet/mellanox/mlxsw/pci_hw.h
index 48dbfea0a2a1..7cdf0ce24f28 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/pci_hw.h
+++ b/drivers/net/ethernet/mellanox/mlxsw/pci_hw.h
@@ -26,7 +26,7 @@
 #define MLXSW_PCI_CIR_TIMEOUT_MSECS		1000
 
 #define MLXSW_PCI_SW_RESET_TIMEOUT_MSECS	900000
-#define MLXSW_PCI_SW_RESET_WAIT_MSECS		200
+#define MLXSW_PCI_SW_RESET_WAIT_MSECS		400
 #define MLXSW_PCI_FW_READY			0xA1844
 #define MLXSW_PCI_FW_READY_MASK			0xFFFF
 #define MLXSW_PCI_FW_READY_MAGIC		0x5E
-- 
2.39.0


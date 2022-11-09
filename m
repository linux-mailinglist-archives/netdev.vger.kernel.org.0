Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BAFC66236CA
	for <lists+netdev@lfdr.de>; Wed,  9 Nov 2022 23:48:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231906AbiKIWsq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Nov 2022 17:48:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49056 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229872AbiKIWsl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Nov 2022 17:48:41 -0500
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2071.outbound.protection.outlook.com [40.107.92.71])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DC4A427DCA
        for <netdev@vger.kernel.org>; Wed,  9 Nov 2022 14:48:20 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dyQ1mMM1+uQgo8SJpxa2JoR9V2o0hR5YQmdfjPXbjbzeJMg9mPqPxpkefjd7FQbUCIV5JT+q2PoXyPkZlg/9c0yP0o4izmRMnJtJyXl+pRn8rpA/m+s+glUHlAugnA3lPCMbYipL2w3lAaCR0XLD5D4TWqlvgTiBAHRDRNA8WhHV42vZWD7bcCKBRAzs5lKDyx/mbVgK8532RapceYy6OVvt9pnAJIkx8eJ38yQc2tRHZ3h+bTLpHdUfzhnGeGw3/F77RTfB6GNuceMF4pSgTtEN7sI/X9gbliRNprx7NAt9Me+t+ipup4zUg5hbgdDJFiHhOBGPVUYDayidTtZUlw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=eFugRgnHV14ITZ/bRjiCAdWrvxblE8kROFDtD3SQkYs=;
 b=jRAkpy3GAt2g56lWSuPQDFimIqE8lSr7NlLBGmJjmnHm5CJit29WS0lq1w+dRbEa+e9uhDM8E3yCbF8jx9IWvHdmevTJ0QKylKVreCMqcCVcjUuEl6NmrJL3jwUr57jpOoH1o7JHbc1iB8qEUycF5DUa9GuGd73ktr1eItfr9wQO96j7T9oR7W/C8IFbORdzPb6iaRJjwoXX8tAnF00MuoELlEyV4Qcxsyzw6g0kDr98zMOIvGPOHHEhxJEQsSefzJuGwijUSTI6rBol87mWfXSOpSELjBXVa5x+6CgWSwEKZBKOjQ7jlPeEqCaNWZsZ53zavWhZIUF4JPdqt0FNWQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.118.232) smtp.rcpttodomain=davemloft.net smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=eFugRgnHV14ITZ/bRjiCAdWrvxblE8kROFDtD3SQkYs=;
 b=TfKYE06jilsi+H5Mlgr9/i4gEZ+3SPb5eLY7UcQ7sHN2Zg5Zht3smWi26THsP9dBf6S7mr5Y4zpfaRWCCIqd0L2+9AxMlKfLkv/6560VTaDdj7Qzn2goXFWnFREHpCt/SPI9ww0gMVsv7UqLCq5A3yWSui6155lOnZ2bDt2YSfyWv2YglWt2H7e0HHDcWr292nOSSSK/nnEftfgaEYaQ+ZbclDbIOCPTRYN++9dKA/hXL/ny3EWAnpTN/IQzUxk0RDqzJ1QDA8a0LMSpPX9dCmYQU5FGr3MIA37OPB+KvHSyAsp/2ksnXV7K575wqcSRKAX4AvrZEaDpNeEnARgeXw==
Received: from DM6PR11CA0057.namprd11.prod.outlook.com (2603:10b6:5:14c::34)
 by CY8PR12MB7684.namprd12.prod.outlook.com (2603:10b6:930:87::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5791.27; Wed, 9 Nov
 2022 22:48:19 +0000
Received: from DM6NAM11FT062.eop-nam11.prod.protection.outlook.com
 (2603:10b6:5:14c:cafe::e7) by DM6PR11CA0057.outlook.office365.com
 (2603:10b6:5:14c::34) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5791.27 via Frontend
 Transport; Wed, 9 Nov 2022 22:48:19 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.118.232)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.118.232 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.118.232; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.118.232) by
 DM6NAM11FT062.mail.protection.outlook.com (10.13.173.40) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5813.12 via Frontend Transport; Wed, 9 Nov 2022 22:48:18 +0000
Received: from drhqmail203.nvidia.com (10.126.190.182) by mail.nvidia.com
 (10.127.129.5) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.26; Wed, 9 Nov 2022
 14:48:08 -0800
Received: from drhqmail201.nvidia.com (10.126.190.180) by
 drhqmail203.nvidia.com (10.126.190.182) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.986.36; Wed, 9 Nov 2022 14:48:08 -0800
Received: from vdi.nvidia.com (10.127.8.14) by mail.nvidia.com
 (10.126.190.180) with Microsoft SMTP Server id 15.2.986.36 via Frontend
 Transport; Wed, 9 Nov 2022 14:48:06 -0800
From:   David Thompson <davthompson@nvidia.com>
To:     <davem@davemloft.net>, <edumazet@google.com>, <kuba@kernel.org>,
        <pabeni@redhat.com>
CC:     <netdev@vger.kernel.org>, <cai.huoqing@linux.dev>, <brgl@bgdev.pl>,
        <limings@nvidia.com>, <chenhao288@hisilicon.com>,
        <huangguangbin2@huawei.com>,
        David Thompson <davthompson@nvidia.com>,
        "Asmaa Mnebhi" <asmaa@nvidia.com>
Subject: [PATCH net-next v2 4/4] mlxbf_gige: add "set_link_ksettings" ethtool callback
Date:   Wed, 9 Nov 2022 17:47:52 -0500
Message-ID: <20221109224752.17664-5-davthompson@nvidia.com>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20221109224752.17664-1-davthompson@nvidia.com>
References: <20221109224752.17664-1-davthompson@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6NAM11FT062:EE_|CY8PR12MB7684:EE_
X-MS-Office365-Filtering-Correlation-Id: 85a8ff16-aa9d-44dc-f5e1-08dac2a47eff
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 41d7xFeb/27LJCs5ddNpci3Usa6wkE1ZiPhn0Kx5Q6HRSKiPJ4PzP1YIkfNZwqWwofqaACRZ0NwhuoH1qtqA0Sy0o72X+YgLYX+jbqCvZ4skEPA/v+nvSyOXoipPIjmgQ6T2i19FTsIYr87IL1DoZx4PUxeaZt8EFEVBXyRos38GuIKHkYDJUQjajH38N7m3sELdiUjAQV48V/F+jvj3vbrW1vQZv1gttSTXQ9AfzlSF04LfQc4dVCxOe8r7zND8rDDTnIFJwRPKXalfsGlG8VRlSxGzHIkLoUiX2xBS3t3CkMGSD2gYBlG1ogsPq5pzA8NxC0UGut18ezV/o3LajK5UKlWEYPqLcmQUx2LN8IylAgy7ozOHCAnwF+XWm6njCMrrGPcIvxrsJX7ZgQbQ5ZoMcnp3+zbh5Q7dtbu0E9imVKB07KjAFwrFzxBOx3myJNagAkFfWMv/nErtSSkCTOQg5MVdjNuJxpPfD21aFFcdtGa7opcTPEwLEf7TIzY05Mt310um8G49DME7WX/b6PobM7tOLCO23rgEoLlwGYXlBT6YZ8PxdMmJgt1v/dExNNa5/s5dx2Azg6OHjTGbJwyZVRCs93fU3F1o9xUMXcojwyA5B78xwi4ctdSqgkY6c4/eVzIxCZFF3KCbezIuILHhs3/53o87VepXCbSV9SiXQTbo/nYBCbCMdbmZOt+XqncHd6Q0hUNq2Jxm5g8U+rPYZC7aBK3s52/fxxc57DUmK+K2s8n+DmprAOtDkhL26lIMDac6vyv1sYAUJRw0eA==
X-Forefront-Antispam-Report: CIP:216.228.118.232;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc7edge1.nvidia.com;CAT:NONE;SFS:(13230022)(4636009)(346002)(396003)(136003)(376002)(39860400002)(451199015)(46966006)(40470700004)(36840700001)(478600001)(82740400003)(82310400005)(356005)(7636003)(316002)(26005)(6666004)(110136005)(54906003)(36860700001)(107886003)(70206006)(47076005)(70586007)(40480700001)(426003)(8676002)(7696005)(83380400001)(4326008)(36756003)(8936002)(5660300002)(336012)(41300700001)(2616005)(1076003)(86362001)(2906002)(186003)(40460700003);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Nov 2022 22:48:18.5913
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 85a8ff16-aa9d-44dc-f5e1-08dac2a47eff
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.118.232];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT062.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR12MB7684
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch extends the "ethtool_ops" data structure to
include the "set_link_ksettings" callback. This change
enables configuration of the various interface speeds
that the BlueField-3 supports (10Mbps, 100Mbps, and 1Gbps).

Signed-off-by: David Thompson <davthompson@nvidia.com>
Signed-off-by: Asmaa Mnebhi <asmaa@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlxbf_gige/mlxbf_gige_ethtool.c | 1 +
 drivers/net/ethernet/mellanox/mlxbf_gige/mlxbf_gige_main.c    | 2 +-
 2 files changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlxbf_gige/mlxbf_gige_ethtool.c b/drivers/net/ethernet/mellanox/mlxbf_gige/mlxbf_gige_ethtool.c
index 41ebef25a930..253d7ad9b809 100644
--- a/drivers/net/ethernet/mellanox/mlxbf_gige/mlxbf_gige_ethtool.c
+++ b/drivers/net/ethernet/mellanox/mlxbf_gige/mlxbf_gige_ethtool.c
@@ -135,4 +135,5 @@ const struct ethtool_ops mlxbf_gige_ethtool_ops = {
 	.nway_reset		= phy_ethtool_nway_reset,
 	.get_pauseparam		= mlxbf_gige_get_pauseparam,
 	.get_link_ksettings	= phy_ethtool_get_link_ksettings,
+	.set_link_ksettings	= phy_ethtool_set_link_ksettings,
 };
diff --git a/drivers/net/ethernet/mellanox/mlxbf_gige/mlxbf_gige_main.c b/drivers/net/ethernet/mellanox/mlxbf_gige/mlxbf_gige_main.c
index 80060a54ba95..a9fa662e0665 100644
--- a/drivers/net/ethernet/mellanox/mlxbf_gige/mlxbf_gige_main.c
+++ b/drivers/net/ethernet/mellanox/mlxbf_gige/mlxbf_gige_main.c
@@ -224,7 +224,7 @@ static int mlxbf_gige_stop(struct net_device *netdev)
 }
 
 static int mlxbf_gige_eth_ioctl(struct net_device *netdev,
-			       struct ifreq *ifr, int cmd)
+				struct ifreq *ifr, int cmd)
 {
 	if (!(netif_running(netdev)))
 		return -EINVAL;
-- 
2.30.1


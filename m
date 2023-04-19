Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3DD816E7C49
	for <lists+netdev@lfdr.de>; Wed, 19 Apr 2023 16:22:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232818AbjDSOWL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Apr 2023 10:22:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49952 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232338AbjDSOWC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Apr 2023 10:22:02 -0400
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2040.outbound.protection.outlook.com [40.107.236.40])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A7D661A1
        for <netdev@vger.kernel.org>; Wed, 19 Apr 2023 07:21:57 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nh++WzKH7Xhhz1PrWP0noO9d93rWG667CJRu0FoOH/aE8wdieOVyjjqoXWLbIDQbp7JzqcjBjS6GMQNzXMLbWgwKx+uZhd5wRN9da2ITmRrefohpUdwf7EP0goLkP7KhHzAuy3y4tBeJ9BpBd4OV3w2tig4bXTCflHe6qet09Z5ntyVBolfYUTi5Owa2wCSXY7IbOTSt1e+fvaT7GGt85/YhQppHDxh+tnbz0AdLRE/u22McNcwWcnA+gtZOHIHaJmVPrBPKeaqQLeUpbbYacOqQrb8E6gw8yzSi7OxWQ5DkqGf+HodCQMalfIRdY2l1DFfEcOABG/B1VWknRjh+LA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=yoFJwwZmbzVx8YVVFLDZ1HzKqo4X1v+2Gs528PyXIPQ=;
 b=J8ZLV/us+jJ+vGVOOtn3vBVzpvdJ3MvqqmMDZSyXo5IlL8sEjHpNWs5F2ifjZzg79NNPKvZBD+P8UQcJ9Rfk3wCiPdjYnaDpQezNf8TDjTmYu3/TsDag7WLJw8jXnA9SlPy6TAfBfwRA7bn4LPQeQFC7XxU5VDOIg4W8LqbFAUp4MQ71KuP0GUb8gGEnLL0laDp5kRWbo9e8EAddSz9tcajh62BBupDOEQmUWXr+qGsEVeY0PAPYfMCoVN0+nGSvSOI72WE4g1+dmTpWM65CQpU+f7yBu37yfXqebLZM/ktDrfe/vP2DRpLVNB3s+ZC3OOyc2iofTNgkOCs93tQpMA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=davemloft.net smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=yoFJwwZmbzVx8YVVFLDZ1HzKqo4X1v+2Gs528PyXIPQ=;
 b=gssH7xC//tAtqh0t1vVyY+mBAlvlUBlP85/MK9uDCiKeM2xhmDWob+7YelDe/41q3k7aAJMmPS7TlQM52nBpqEg0AX7XY9rVCA6ITL1xCnPRnMzuZt3wiY3JD3fcBXr2FnfscwTtrfgyQQFnpOrHffLlqQxCMaw6e2QRTBK1sBzLrTzOTaxNKhQ9srd9gRI0NXIR7W9isaQIJ+ke+Ny/x/7+0djyzLDET6QO8d/AFMaJwbYdwy1LBzahq54f1x655QScao8s+h8n3ekBLCtwLtfcDtk3QaZgkCkRsEjjmuMBW+Izo6LE+m59+qsSOQzq4719KVlZBRWDDZjE8DPm5w==
Received: from BN0PR04CA0115.namprd04.prod.outlook.com (2603:10b6:408:ec::30)
 by SA1PR12MB8119.namprd12.prod.outlook.com (2603:10b6:806:337::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6319.22; Wed, 19 Apr
 2023 14:21:54 +0000
Received: from BN8NAM11FT051.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:ec:cafe::71) by BN0PR04CA0115.outlook.office365.com
 (2603:10b6:408:ec::30) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6319.22 via Frontend
 Transport; Wed, 19 Apr 2023 14:21:54 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 BN8NAM11FT051.mail.protection.outlook.com (10.13.177.66) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6319.22 via Frontend Transport; Wed, 19 Apr 2023 14:21:54 +0000
Received: from rnnvmail204.nvidia.com (10.129.68.6) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.5; Wed, 19 Apr 2023
 07:21:42 -0700
Received: from rnnvmail204.nvidia.com (10.129.68.6) by rnnvmail204.nvidia.com
 (10.129.68.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.37; Wed, 19 Apr
 2023 07:21:42 -0700
Received: from vdi.nvidia.com (10.127.8.9) by mail.nvidia.com (10.129.68.6)
 with Microsoft SMTP Server id 15.2.986.37 via Frontend Transport; Wed, 19 Apr
 2023 07:21:40 -0700
From:   Emeel Hakim <ehakim@nvidia.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <pabeni@redhat.com>,
        <edumazet@google.com>, <sd@queasysnail.net>
CC:     <netdev@vger.kernel.org>, <leon@kernel.org>,
        Emeel Hakim <ehakim@nvidia.com>
Subject: [PATCH net-next v7 2/5] net/mlx5: Enable MACsec offload feature for VLAN interface
Date:   Wed, 19 Apr 2023 17:21:23 +0300
Message-ID: <20230419142126.9788-3-ehakim@nvidia.com>
X-Mailer: git-send-email 2.21.3
In-Reply-To: <20230419142126.9788-1-ehakim@nvidia.com>
References: <20230419142126.9788-1-ehakim@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN8NAM11FT051:EE_|SA1PR12MB8119:EE_
X-MS-Office365-Filtering-Correlation-Id: f9c669bc-79c6-4697-96a9-08db40e16d13
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: MapqA7VGr533ap1Qz/VDRhtJy2a/+vKLZ/8c3ENGJvsY8xDqGhuGK8iWEXAkJeNqFEOPP3r5IOqKU1B3wVUjwihmA8B6M1+aai5PErKXzPGPScSpuxwQCMe/fOkv3sufIU+AarwvmSG8FbxruezOhxoZ0D2C6RYruRlLXm2vnvFvP70EEF5IJNYE6C3w/42GLtyxp2LkwprxPk8SoYTd71Fano18M3RlfoFXNR6Pz/W3+YMqbdmK622z/gMLZzHUgAxy8ZreEyGurqRT8XtE9EHaDVEWggeuMUXY2Yg/0TCDoS7du36NcjUM5voRRsUmsxzrnB1EGJM64+14eYcu5DBVSpGKgt5U5+yAW01bwiTaBpc6uBQSdOUS/IqMZCc/OOPeLziAlWpYVUllFnP90gtFcySaqGcFn3CGzMLqSrZEBqVgr9rvk8qeR3YhNppELotGbQhtpK8LgQn841+t0TiA1UAzTZRLVu47SFUZ0hOUYS0a4tn62bHZdxmj0Ut9tlD8KaRJBmkm410DUABh4CgLw4qM4UtIRue+Dl1p/bZLEnQ3y9uGSe+4iMjRbWSdd4bvIkmFuuBOSwlU+ryC3eiFp4zKQhY6XbcHICmT62MZc4w5P5yLN16a8CvsZ+zxdwGJCs6Rf0qnfnoV7ZhIACXjj1WDmw3UtTLMqmlDiEkg4GWbFtXEpH8vxwNeijaOtJBVDNE8rIYa6ko1zsTzER5mIXkdGCwkHrSDdXx/G0faOEThuGfrVfba+VBNktubQmRhWLmPSoJuNCoFwQDnsgvE/6VeB1SgJ3dEZFcWwr4=
X-Forefront-Antispam-Report: CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230028)(4636009)(39860400002)(346002)(396003)(136003)(376002)(451199021)(36840700001)(40470700004)(46966006)(54906003)(34070700002)(110136005)(47076005)(478600001)(2616005)(36860700001)(7696005)(40480700001)(1076003)(26005)(107886003)(6666004)(70586007)(70206006)(4326008)(7636003)(41300700001)(356005)(336012)(426003)(316002)(82740400003)(186003)(5660300002)(8676002)(2906002)(40460700003)(8936002)(4744005)(86362001)(36756003)(82310400005);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Apr 2023 14:21:54.2845
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: f9c669bc-79c6-4697-96a9-08db40e16d13
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT051.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR12MB8119
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Enable MACsec offload feature over VLAN by adding NETIF_F_HW_MACSEC
to the device vlan_features.

Signed-off-by: Emeel Hakim <ehakim@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en_main.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
index ec72743b64e2..1b4b4afa9dc7 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
@@ -5125,6 +5125,7 @@ static void mlx5e_build_nic_netdev(struct net_device *netdev)
 
 	netdev->vlan_features    |= NETIF_F_SG;
 	netdev->vlan_features    |= NETIF_F_HW_CSUM;
+	netdev->vlan_features    |= NETIF_F_HW_MACSEC;
 	netdev->vlan_features    |= NETIF_F_GRO;
 	netdev->vlan_features    |= NETIF_F_TSO;
 	netdev->vlan_features    |= NETIF_F_TSO6;
-- 
2.21.3


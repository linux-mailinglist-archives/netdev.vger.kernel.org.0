Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2F2186E0BEA
	for <lists+netdev@lfdr.de>; Thu, 13 Apr 2023 12:57:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231246AbjDMK5J (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Apr 2023 06:57:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36858 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231255AbjDMK5B (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 13 Apr 2023 06:57:01 -0400
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2082.outbound.protection.outlook.com [40.107.223.82])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 680BD7ED7
        for <netdev@vger.kernel.org>; Thu, 13 Apr 2023 03:56:58 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=aj2v47NpreXDbVG/eKkBQk8FZHiIKzqH0sJwi5f0y7WuNr95t1Cr0lpyC9g5fni+xI/aopLUNIdZ6TNlEmCd12yRuzsakQz6mIfPF5DmupNMW8IXkOwCo+h6fFEMod5PwBOBbP4UUSR3XRPx/qJl0ZRrjsuXcBTyRzl1wxHrTBDdp0w7orVVvR7q7+Q9pWylJ6ixtDRyI5OJdbC0FyOTG7/5t3TKV4oTPniUuMYx77Ch6jFIvEmkYDd1B3+naOHMLaazxqmBeoQTVo4COtXfzECWKx4ryAnF5h7Go04F0semndZqezO+DdlspsVTxL1vc6BVVA3To/3yK8sU7LSf4g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=yoFJwwZmbzVx8YVVFLDZ1HzKqo4X1v+2Gs528PyXIPQ=;
 b=WjV/+Y3PCQj9I3vayxwi9E1eGdjAHqYHIAolxrTVxBIZdy/8jBNVcmyJZowtGHA3RnehO7DXAW4pCqooG+yflm5IZnEx9vYetlpVXgI+lJDb54/7ofbiLnzPQg13+/HIMCsz3himgw8gAFPXxN4KA+kWtx07qyS0jSbEipLYJfPXrKQgTiKZox+cFFzFmtXBNnAw1NWs0DfVEcO6thgygcacXDMvY7pkmGABQI1dzM1EWWJq6rQUh222jXmV3eolAtn4KWHEE523QGI5SI5Ac2PnxR4dCMyn55Ekg2wzHCkjQS76BZAIzDeCDfJaGhKDNp5gT6KsQJw5kuiuZ0tkRg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=davemloft.net smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=yoFJwwZmbzVx8YVVFLDZ1HzKqo4X1v+2Gs528PyXIPQ=;
 b=Dcxwi/6xkh/wC7zoOBFNbGBhMI5McI8apy9j/ZI43Vfx0esarjxpxGEC368W0fY8UfObyprgwGRPMZZRTDNM4VVOzzRdcvo2f6aVVGYF5nbmJ1iudMvYJUNsbii3lEozZqZx/LgL/aWc/qGoI6WgVL1q7eBJMo3YdyMxb/PsEN6i838ti7OZEXMzmH5WDnJr2yRh6BTLd87hUpaWoI/SwtjGy6J7KU3zKj1uar3AI34zoEnk7cWQxSnhlwhEzOlDsPW3I4rvwC588nvOHw5XxlzLFUq1qWs4LFeSxwTnS4660KJGOgDMqOoyIjtURBhzTCx526jEewU86U9D/RoUmg==
Received: from MW4PR03CA0321.namprd03.prod.outlook.com (2603:10b6:303:dd::26)
 by DM6PR12MB4403.namprd12.prod.outlook.com (2603:10b6:5:2ab::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6298.30; Thu, 13 Apr
 2023 10:56:55 +0000
Received: from CO1NAM11FT095.eop-nam11.prod.protection.outlook.com
 (2603:10b6:303:dd:cafe::64) by MW4PR03CA0321.outlook.office365.com
 (2603:10b6:303:dd::26) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6298.30 via Frontend
 Transport; Thu, 13 Apr 2023 10:56:55 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 CO1NAM11FT095.mail.protection.outlook.com (10.13.174.179) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6298.32 via Frontend Transport; Thu, 13 Apr 2023 10:56:55 +0000
Received: from rnnvmail205.nvidia.com (10.129.68.10) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.5; Thu, 13 Apr 2023
 03:56:40 -0700
Received: from rnnvmail205.nvidia.com (10.129.68.10) by rnnvmail205.nvidia.com
 (10.129.68.10) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.37; Thu, 13 Apr
 2023 03:56:40 -0700
Received: from vdi.nvidia.com (10.127.8.9) by mail.nvidia.com (10.129.68.10)
 with Microsoft SMTP Server id 15.2.986.37 via Frontend Transport; Thu, 13 Apr
 2023 03:56:38 -0700
From:   Emeel Hakim <ehakim@nvidia.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <pabeni@redhat.com>,
        <edumazet@google.com>, <sd@queasysnail.net>
CC:     <netdev@vger.kernel.org>, <leon@kernel.org>,
        Emeel Hakim <ehakim@nvidia.com>
Subject: [PATCH net-next v5 2/5] net/mlx5: Enable MACsec offload feature for VLAN interface
Date:   Thu, 13 Apr 2023 13:56:19 +0300
Message-ID: <20230413105622.32697-3-ehakim@nvidia.com>
X-Mailer: git-send-email 2.21.3
In-Reply-To: <20230413105622.32697-1-ehakim@nvidia.com>
References: <20230413105622.32697-1-ehakim@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO1NAM11FT095:EE_|DM6PR12MB4403:EE_
X-MS-Office365-Filtering-Correlation-Id: 4c6ba5be-8c1b-4d54-dd87-08db3c0dcbb0
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: OlIVrU9bujG3cz8StZ9IVkRPKFs1ILEOdXUc0siBbjh8J0xw1YlYJV5rqxpPd0QYqh5hH6iinKNai8SCT02gllYm6AUrKeA8gx00BUPaYAGI25D5p6Q1agJ8YDtiCxqGZv8l2f+t6TSt+pX/KGTVvM4QNSrMxGVaVNmdVoLMxXtYATFYWeG8VLbXn9DA4GcuVX/Ae1PcP9TPyz7h6M0w804AHBzJlvyX0lBJUf1lkVRojBBqRMtIvlfyHAw8fvMSJt0YaxUYZOqMo+HC3iUotAZ2gCU2Qafycwt6x7vEldxm2U9ZyvVh63/mCI4tgR9/6zieF2JcWye4KjsqX/23qLkrM8wkWyN4+uwgc2eSZUhesOCyXdH5BYs+NqHaoRe1oHpypHY4gP03m+d/ajgDKuSQqlbontUv8y4u7bGprr1D1iabnQq6PPIzAqwNxSoqcn6kSUpFWt5MZppvQyj/SCY5B6qXGNcc72Vg6hnkuu4u6+0mBLmTAPvefr6D+xl/3YyD21FfBXEDossBLFtR9bIDSNgg3dyGLXw6tDNwRr98l+7aI8pbFIe+j1doEfHUYNcxsrzCty5/xPCH5c1tV6WAgD14Y6k1gifI+NKSyKwQSAiR/xH+DGINmENxvyiHsiVyG7+hZXUA+aKiOJeXDapHocVMa0/qblUGiBBqt0zunKeqZj0CfL3Mfl3DgNTUwSMLxjkXuZIenAjoC79Tc65hkH7bwh2HUO1+lmbeA+1ELP/bUruURHYUTg1wTmK0wjYgyjODx+k2xUCpyHDlAc+UWx9y/xbC7nO+Gf3a+ic=
X-Forefront-Antispam-Report: CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230028)(4636009)(136003)(396003)(39860400002)(346002)(376002)(451199021)(40470700004)(36840700001)(46966006)(36860700001)(70586007)(426003)(2616005)(54906003)(34020700004)(47076005)(70206006)(336012)(186003)(6666004)(478600001)(26005)(107886003)(110136005)(1076003)(7696005)(316002)(4744005)(36756003)(5660300002)(40460700003)(2906002)(82310400005)(7636003)(356005)(82740400003)(4326008)(41300700001)(8676002)(8936002)(40480700001)(86362001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Apr 2023 10:56:55.1102
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 4c6ba5be-8c1b-4d54-dd87-08db3c0dcbb0
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT095.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4403
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.6
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


Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7331860CA6B
	for <lists+netdev@lfdr.de>; Tue, 25 Oct 2022 12:53:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232424AbiJYKxf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Oct 2022 06:53:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59476 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232207AbiJYKxe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Oct 2022 06:53:34 -0400
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2052.outbound.protection.outlook.com [40.107.223.52])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 999E917F9AB
        for <netdev@vger.kernel.org>; Tue, 25 Oct 2022 03:53:33 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=i1tO0Rx1RRzcM7Wo8RvizAHail8/gR+vbC+qmcXWy7GiCjRXXoI1QEedfbIs9/DqTGWHJOCMenfG3xnut/hrwNCCZBmQzdzO7NeVtosgP3T0wmKcRspZfQvCOslKdQdH8rspvmoTpvNIrIZ906rvgibkcd3RY33TJJh5TYRADpTmer9ZKtFUYC4S0H5CjyE+anpAKjWK0wlakEiek5ZCjg6fuKTLh3AdIkITnDW85JAOk1Iyo3Szb08s8dEZZ3a90RwWgS48wpuerJc7LjJilMb3lrDfpdei230GQXCC4z9z1tPFKkbyTUARldRDRdCVkqBBoiUqqid0DuNEoSchdw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=+QkwMm4WhlFKYkMm/nfotl4x0bCOxRuzEXStaZqQ2s8=;
 b=lmp8Qn7OzwhzIYqjbPm1tK/ijjrLr79GORrJ8A2VGRiRBFPqW1xlg+0X6p8fsSzPkiH/O99AJF+06xXjeIwNnmtW4iqgK0O0erFV3WlQawVsVx/7wal6Oo2GY4W8P/F2cr4i0UTvWeETuXx1OibfdbpjjKWM+rrLxT5KfdQlpfoVdPWGa4e6zJ1tSjwjrx89JLiGkvuuwUW26t6oH9bYCFDBtU/qBzGAg5KQPWQo87KFF/+WTFynS6hMFSPMt71Lvf5noW7sY7Gnsgw8ZsICky/zZKoD99eAHwmnnKGuot6XVZABfSMHT/GIAIr55fX9ltdh9J1zQn5wzLngTgoXRA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=davemloft.net smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+QkwMm4WhlFKYkMm/nfotl4x0bCOxRuzEXStaZqQ2s8=;
 b=BjEyBh+fj76mSTr+3qgaMyuhUx2lFGVDPIZ4EtYlJYFCvqH2fMUjqXhI0hjlVv//5EhaeyFggnD4z4D7RNJqYpFCSCW3+Qx8AVc8B6sYdELmLf0B+z+AGSQn6IdzOBOwKxYYHnn32vWBw8prk0hHzo8moRBDWPKG84NbhUIk524Ko/WlWu9kkkFbbF+NWkmz7GwQ6HGIIEGS9SULtJyQVcYu1E9rZ3DZv0KszhC30DQ3vyOHfjnf6d9I3Rte5ZQIS4bquJUzX/oAbTGQC2mlVCH9QKbDKH8UDPn6u9VawgqLb8kXO6X9fyFb2UBn35A2ws8pFEVWopvSJKOcnB4KgA==
Received: from BN8PR03CA0030.namprd03.prod.outlook.com (2603:10b6:408:94::43)
 by MN0PR12MB6002.namprd12.prod.outlook.com (2603:10b6:208:37e::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5723.34; Tue, 25 Oct
 2022 10:53:31 +0000
Received: from BN8NAM11FT026.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:94:cafe::a5) by BN8PR03CA0030.outlook.office365.com
 (2603:10b6:408:94::43) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5746.28 via Frontend
 Transport; Tue, 25 Oct 2022 10:53:31 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 BN8NAM11FT026.mail.protection.outlook.com (10.13.177.51) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5746.16 via Frontend Transport; Tue, 25 Oct 2022 10:53:31 +0000
Received: from rnnvmail202.nvidia.com (10.129.68.7) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.26; Tue, 25 Oct
 2022 03:53:21 -0700
Received: from rnnvmail204.nvidia.com (10.129.68.6) by rnnvmail202.nvidia.com
 (10.129.68.7) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.29; Tue, 25 Oct
 2022 03:53:20 -0700
Received: from vdi.nvidia.com (10.127.8.14) by mail.nvidia.com (10.129.68.6)
 with Microsoft SMTP Server id 15.2.986.29 via Frontend Transport; Tue, 25 Oct
 2022 03:53:17 -0700
From:   Tariq Toukan <tariqt@nvidia.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>
CC:     Boris Pismenny <borisp@nvidia.com>,
        John Fastabend <john.fastabend@gmail.com>,
        <netdev@vger.kernel.org>, Saeed Mahameed <saeedm@nvidia.com>,
        Gal Pressman <gal@nvidia.com>,
        Jay Vosburgh <j.vosburgh@gmail.com>,
        Veaceslav Falico <vfalico@gmail.com>,
        Andy Gospodarek <andy@greyhouse.net>,
        Tariq Toukan <tariqt@nvidia.com>
Subject: [PATCH net-next] bond: Disable TLS features indication
Date:   Tue, 25 Oct 2022 13:53:00 +0300
Message-ID: <20221025105300.4718-1-tariqt@nvidia.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN8NAM11FT026:EE_|MN0PR12MB6002:EE_
X-MS-Office365-Filtering-Correlation-Id: 4e0fec0a-81b2-4e96-2810-08dab67727e0
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Yz0V6cjrP1fRzyh4j+wkydHf7cMIrfM4ta+/0gTsa0j5vEWft4MJcCwuUxegqqMgWkfYZUCsjwxGrwdFj/dHS87TfIP/Qo/4J45T2gXy+0IO3OJidRw3FRnOR03trEl14uHvQ0gwOMNjL2POVMX9Yn0YZt8+kJ/d2y4kJodhuOsKgSQbmAn/SkQ9PjpO95x/AOzB1SS+S16yEzl76rsfxK/eM9295LTA1x4v0cbq+adKF3p67VXdOgc2Hu4V5/2ck4ASRyC1oC4+uksX2CSX9EiCAH8yo55dwh2zGO2jCdOTdE1iGcgRnXlJABwv9RgmX1u6nLMdPOeyWponzzsRuuBrQCSo0D3JiaTl9duqyX6upOUG+y3LszouUmIp9S34C++O7c7j8E/q8ueaaY8DWut6l4ctyKbIQ6arKrh102fd9Ln0XbrMqhmTNLzKRCdaG3bvOXEJ9it7Z7Rj8TiBidmyBbBECFFksMfuSMuCnK1f9WG2aN354MWe81v4NRvl5LVAnm3ky2jxDbIm3046Se6L1H9CBnrt2FcOvaoplnDK4Rt0jaTmkXKyqwu7RWpeRzc/DQxmLu/+fHGqYby4Z0gghrS092qB274cv4RMuzkOrWC6BiJMB1fHEyZc85544d03DcnpO2d5GWTRQVPToEjE48/z09ZtRMEoynZ+zGDMWiMZhsAsjqTtuz7H1NeKF/1F6VlxLoZm45BIYJhNRZx8g1cPlhLFY+kFoe9bKy4LXaxvWUzP0QrE4xhObFlNYa/KCD+Xfo2tUJDGLxQF/L1xcZCddStWZKQEWIaBojwN1voS6DBGImW/ITWKN6mBFvGM4NyzL6bAvJUNU+teL6Jp1HdG6BTf8nHkE51lqGc=
X-Forefront-Antispam-Report: CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230022)(4636009)(396003)(346002)(136003)(39860400002)(376002)(451199015)(46966006)(36840700001)(40470700004)(8936002)(70206006)(54906003)(2906002)(40480700001)(316002)(107886003)(478600001)(82310400005)(41300700001)(1076003)(5660300002)(966005)(8676002)(4326008)(47076005)(40460700003)(6666004)(7696005)(2616005)(186003)(336012)(70586007)(83380400001)(36756003)(36860700001)(426003)(110136005)(86362001)(7636003)(26005)(82740400003)(356005);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Oct 2022 10:53:31.0524
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 4e0fec0a-81b2-4e96-2810-08dab67727e0
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT026.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN0PR12MB6002
X-Spam-Status: No, score=-1.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Bond agnostically interacts with TLS device-offload requests via the
.ndo_sk_get_lower_dev operation. Return value is true iff bond
guarantees fixed mapping between the TLS connection and a lower netdev.

Due to this nature, the bond TLS device offload features are not
explicitly controllable in the bond layer. As of today, these are
read-only values based on the evaluation of bond_sk_check().  However,
this indication might be incorrect and misleading, when the feature bits
are "fixed" by some dependency features.  For example,
NETIF_F_HW_TLS_TX/RX are forcefully cleared in case the corresponding
checksum offload is disabled. But in fact the bond ability to still
offload TLS connections to the lower device is not hurt.

This means that these bits can not be trusted, and hence better become
unused.

This patch revives some old discussion [1] and proposes a much simpler
solution: Clear the bond's TLS features bits. Everyone should stop
reading them.

[1] https://lore.kernel.org/netdev/20210526095747.22446-1-tariqt@nvidia.com/

Signed-off-by: Tariq Toukan <tariqt@nvidia.com>
Reviewed-by: Gal Pressman <gal@nvidia.com>
---
 drivers/net/bonding/bond_main.c    | 13 +------------
 drivers/net/bonding/bond_options.c | 18 ------------------
 include/net/bonding.h              |  4 ----
 3 files changed, 1 insertion(+), 34 deletions(-)

diff --git a/drivers/net/bonding/bond_main.c b/drivers/net/bonding/bond_main.c
index e84c49bf4d0c..1cd4e71916f8 100644
--- a/drivers/net/bonding/bond_main.c
+++ b/drivers/net/bonding/bond_main.c
@@ -307,7 +307,7 @@ netdev_tx_t bond_dev_queue_xmit(struct bonding *bond, struct sk_buff *skb,
 	return dev_queue_xmit(skb);
 }
 
-bool bond_sk_check(struct bonding *bond)
+static bool bond_sk_check(struct bonding *bond)
 {
 	switch (BOND_MODE(bond)) {
 	case BOND_MODE_8023AD:
@@ -1398,13 +1398,6 @@ static netdev_features_t bond_fix_features(struct net_device *dev,
 	netdev_features_t mask;
 	struct slave *slave;
 
-#if IS_ENABLED(CONFIG_TLS_DEVICE)
-	if (bond_sk_check(bond))
-		features |= BOND_TLS_FEATURES;
-	else
-		features &= ~BOND_TLS_FEATURES;
-#endif
-
 	mask = features;
 
 	features &= ~NETIF_F_ONE_FOR_ALL;
@@ -5806,10 +5799,6 @@ void bond_setup(struct net_device *bond_dev)
 	if (BOND_MODE(bond) == BOND_MODE_ACTIVEBACKUP)
 		bond_dev->features |= BOND_XFRM_FEATURES;
 #endif /* CONFIG_XFRM_OFFLOAD */
-#if IS_ENABLED(CONFIG_TLS_DEVICE)
-	if (bond_sk_check(bond))
-		bond_dev->features |= BOND_TLS_FEATURES;
-#endif
 }
 
 /* Destroy a bonding device.
diff --git a/drivers/net/bonding/bond_options.c b/drivers/net/bonding/bond_options.c
index 3498db1c1b3c..f71d5517f829 100644
--- a/drivers/net/bonding/bond_options.c
+++ b/drivers/net/bonding/bond_options.c
@@ -842,19 +842,6 @@ static bool bond_set_xfrm_features(struct bonding *bond)
 	return true;
 }
 
-static bool bond_set_tls_features(struct bonding *bond)
-{
-	if (!IS_ENABLED(CONFIG_TLS_DEVICE))
-		return false;
-
-	if (bond_sk_check(bond))
-		bond->dev->wanted_features |= BOND_TLS_FEATURES;
-	else
-		bond->dev->wanted_features &= ~BOND_TLS_FEATURES;
-
-	return true;
-}
-
 static int bond_option_mode_set(struct bonding *bond,
 				const struct bond_opt_value *newval)
 {
@@ -885,7 +872,6 @@ static int bond_option_mode_set(struct bonding *bond,
 		bool update = false;
 
 		update |= bond_set_xfrm_features(bond);
-		update |= bond_set_tls_features(bond);
 
 		if (update)
 			netdev_update_features(bond->dev);
@@ -1418,10 +1404,6 @@ static int bond_option_xmit_hash_policy_set(struct bonding *bond,
 		   newval->string, newval->value);
 	bond->params.xmit_policy = newval->value;
 
-	if (bond->dev->reg_state == NETREG_REGISTERED)
-		if (bond_set_tls_features(bond))
-			netdev_update_features(bond->dev);
-
 	return 0;
 }
 
diff --git a/include/net/bonding.h b/include/net/bonding.h
index e999f851738b..ea36ab7f9e72 100644
--- a/include/net/bonding.h
+++ b/include/net/bonding.h
@@ -92,8 +92,6 @@
 #define BOND_XFRM_FEATURES (NETIF_F_HW_ESP | NETIF_F_HW_ESP_TX_CSUM | \
 			    NETIF_F_GSO_ESP)
 
-#define BOND_TLS_FEATURES (NETIF_F_HW_TLS_TX | NETIF_F_HW_TLS_RX)
-
 #ifdef CONFIG_NET_POLL_CONTROLLER
 extern atomic_t netpoll_block_tx;
 
@@ -280,8 +278,6 @@ struct bond_vlan_tag {
 	unsigned short	vlan_id;
 };
 
-bool bond_sk_check(struct bonding *bond);
-
 /**
  * Returns NULL if the net_device does not belong to any of the bond's slaves
  *
-- 
2.31.1


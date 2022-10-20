Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4542860643D
	for <lists+netdev@lfdr.de>; Thu, 20 Oct 2022 17:22:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230030AbiJTPWa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Oct 2022 11:22:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52282 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230123AbiJTPWZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Oct 2022 11:22:25 -0400
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2059.outbound.protection.outlook.com [40.107.93.59])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2C68211D99F
        for <netdev@vger.kernel.org>; Thu, 20 Oct 2022 08:22:24 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dSh2WFCymbjEbHkN35Vg+FH4mB9ROvyIoAnygCXJOkmM5a17mYBIByrlc9oReQ6UxsKN6KhFypK7iTA9Ioa/vq9UO/j2bEd2ORS2lz4P+n83FPmghBX9O4221lnhMx76vkAUV7H+FwmY9oQD1TNExJyqO6RVlgb9B7KiZTWgZpGAjOnMl4TxfgBbDzpYT/KG+m502J0jk6biNNuDq6WEX2umVyH9jPTeEil4Fj71Fc8+9HG28eq/NML9l61SGq+F2wxW0U2ZbSylSOxJDQtn+B8M5sSvpCBV53tUp8myxqyw0LHkOCTC9hw6ll+ItUv/ja6MP16EVhcDFsgNY7P52w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=2pW4rmLcfo8zmnBw4GvoSMhpqi/sIYcWXuEGyMoe8Z0=;
 b=NGeOyfX3P4r6/RLP4EmXu0w9wiwJ99kJNz6JFRcip7/Zfu/2ria/FkZ+qpKysP+JtwxoNCP8uEnWD9xEUbaDS3u9+PAcHP36Umqu01H6S+APB7rYwKZoCWLLedFZL6ZtNrBW8J0Eaxbxo6OS+xbtni34aY1c8H/zkggd+2DULvF9JxzNjnXDLpY7WqBiZc8AZsY2rhHXd6qtatiikUsf2geJjA8GfP/fuX1wndEIoiNxFobOoM1yMaiLGl4sHy2CGHrxop5WKSTXVtjEeqkmkfwryzejuGZeS8bGpAsXQa4ic3ytMkoYaL4WO8xQpigAoRb2TiGjIfxHQEfHvNZH2g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none (sender ip is
 216.228.117.161) smtp.rcpttodomain=davemloft.net smtp.mailfrom=nvidia.com;
 dmarc=fail (p=reject sp=reject pct=100) action=oreject
 header.from=nvidia.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2pW4rmLcfo8zmnBw4GvoSMhpqi/sIYcWXuEGyMoe8Z0=;
 b=DAOCULovKyncCY04E3TGsm0W4qklXN5aE4nncHFlogV0KAm+7l3QHgTIHIv1rlbrb9H+GzlJR5BiLwVhtEIBB6mEwqVhQLqtkchoQbOc3Islcee6/jxAS3XKUc6hh1CMm04OFsAzIdujoiWbypTxLTHqswBJ1jWExlXR2sAg3Q0o5KcqsUv7SHbKGRxvbrh78P+nkkeOdUjpwl7Hf7DOxR9hX1XNHNOTZxUKuGK1sfjkmX+3YQOGlepbOh2kZfTkKJV3+jysE4PlhV8YTrlNB5gxwvRabJpUjOEQPNU+e2LWr5JDEdDzoSIl2hdAfRTzxYDgWvobRGYx0RQTwx8HJA==
Received: from DM6PR04CA0007.namprd04.prod.outlook.com (2603:10b6:5:334::12)
 by DM6PR12MB4402.namprd12.prod.outlook.com (2603:10b6:5:2a5::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5723.34; Thu, 20 Oct
 2022 15:22:22 +0000
Received: from DM6NAM11FT055.eop-nam11.prod.protection.outlook.com
 (2603:10b6:5:334:cafe::c9) by DM6PR04CA0007.outlook.office365.com
 (2603:10b6:5:334::12) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5723.35 via Frontend
 Transport; Thu, 20 Oct 2022 15:22:22 +0000
X-MS-Exchange-Authentication-Results: spf=none (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=fail action=oreject header.from=nvidia.com;
Received-SPF: None (protection.outlook.com: nvidia.com does not designate
 permitted sender hosts)
Received: from mail.nvidia.com (216.228.117.161) by
 DM6NAM11FT055.mail.protection.outlook.com (10.13.173.103) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5746.16 via Frontend Transport; Thu, 20 Oct 2022 15:22:22 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.26; Thu, 20 Oct
 2022 08:22:11 -0700
Received: from yaviefel.vdiclient.nvidia.com (10.126.230.35) by
 rnnvmail201.nvidia.com (10.129.68.8) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.986.29; Thu, 20 Oct 2022 08:22:08 -0700
From:   Petr Machata <petrm@nvidia.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, <netdev@vger.kernel.org>
CC:     Jay Vosburgh <j.vosburgh@gmail.com>,
        Veaceslav Falico <vfalico@gmail.com>,
        Andy Gospodarek <andy@greyhouse.net>,
        Ido Schimmel <idosch@nvidia.com>,
        "Petr Machata" <petrm@nvidia.com>, Amit Cohen <amcohen@nvidia.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        David Ahern <dsahern@kernel.org>, <mlxsw@nvidia.com>
Subject: [PATCH net-next 1/3] ethtool: Add support for 800Gbps link modes
Date:   Thu, 20 Oct 2022 17:20:03 +0200
Message-ID: <4140452facd33be0018dca064b569ef8297cbcde.1666277135.git.petrm@nvidia.com>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <cover.1666277135.git.petrm@nvidia.com>
References: <cover.1666277135.git.petrm@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.126.230.35]
X-ClientProxiedBy: rnnvmail201.nvidia.com (10.129.68.8) To
 rnnvmail201.nvidia.com (10.129.68.8)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6NAM11FT055:EE_|DM6PR12MB4402:EE_
X-MS-Office365-Filtering-Correlation-Id: 390e1afc-65d3-4758-6c5a-08dab2aee299
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: SMnkDG1aemRO6HSuzNzbYmyiTr61tNOD0KgQHyI3IrWau9rJo5WbdPA40gEcWdKtJY1G862OlrOrmb2P4+e9ksGCLr2Jfp7rIO3OMc9KN8nVrBOy+n3siuEvkFiCCWoMGJVwtPdw+ncp0C6tRHXpzSaLNJI7R4kdNWgOmc+izKBi3f07ToupbEueZCLniF+v7LEcgh1IHB5qQDCbEdveZ02EblBpxDyl7vwrqJnQlcyuiW10L/uoJcZPtJYaSk8S0qC998O1TsjQ1ozk55rKImRMwpre6VuiVJjIXkioYRHufaos/fC9GE14FlMWHSeCOwFiA1Q9lzu9CbcvIk7PZN6lrVP9DoX5dJI7Z0PtBysug2+Cm7mx26EfaNVFQ6SoTjeliTndMWVzcw6KkB7BVhyAuwK/JyHE8Tf3wOXXNQq6jOyzdX1F0eQqcZ3rN4lwDgiER7oyGpX+q1HPg5D6or7dJNtegzSGkjPTfNHBb4scuoPisQ2Iqd8JBANgkERhAoirQOaAYvnyldGWD17AF8Roi+6u/YUqpk7TvIdPNZInf9Vom3+qxccGGX7Er8+Q5tnSlDIpSSL0zhxYQFEp1OHbqLLtDz+Q7qn3zKvV1uZG2V9zefySpNz4LPjo//F5KNcLD4VfIvENzWHJ83PoRDV96YSisQuK9X1/q+av0I768x30DLkf+IH7ursPuEaTGhd3SQ/2NFGfyt/ItaIyafWnRXpaLM+Rug1BdZEazNjhdgPBwgtq74WclWcYAXRSz9iMxFEReJ8PipRq6sNzqs1iLvmdO0nxsatUDdsLkOKe3hOcYOtafHW8qX+ZdRk1MsozEu6hHf75QUGSXHwzW+4NjxX8hZTFYGsYkGOHHCU=
X-Forefront-Antispam-Report: CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230022)(4636009)(396003)(136003)(376002)(39860400002)(346002)(451199015)(40470700004)(36840700001)(46966006)(36756003)(7416002)(5660300002)(54906003)(110136005)(6666004)(7696005)(19627235002)(4326008)(107886003)(70206006)(8936002)(41300700001)(316002)(36860700001)(7636003)(82740400003)(356005)(8676002)(426003)(47076005)(2616005)(186003)(82310400005)(16526019)(336012)(40480700001)(2906002)(70586007)(86362001)(83380400001)(478600001)(26005)(40460700003)(966005);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Oct 2022 15:22:22.0230
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 390e1afc-65d3-4758-6c5a-08dab2aee299
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT055.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4402
X-Spam-Status: No, score=-1.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Amit Cohen <amcohen@nvidia.com>

Add support for 800Gbps speed, link modes of 100Gbps per lane.
As mentioned in slide 21 in IEEE documentation [1], all adopted 802.3df
copper and optical PMDs baselines using 100G/lane will be supported.

Add the relevant PMDs which are mentioned in slide 5 in IEEE
documentation [1] and were approved on 10-2022 [2]:
BP - KR8
Cu Cable - CR8
MMF 50m - VR8
MMF 100m - SR8
SMF 500m - DR8
SMF 2km - DR8-2

[1]: https://www.ieee802.org/3/df/public/22_10/22_1004/shrikhande_3df_01a_221004.pdf
[2]: https://ieee802.org/3/df/KeyMotions_3df_221005.pdf

Signed-off-by: Amit Cohen <amcohen@nvidia.com>
Reviewed-by: Ido Schimmel <idosch@nvidia.com>
Signed-off-by: Petr Machata <petrm@nvidia.com>
---
 drivers/net/phy/phy-core.c   | 11 ++++++++++-
 include/uapi/linux/ethtool.h |  8 ++++++++
 net/ethtool/common.c         | 14 ++++++++++++++
 3 files changed, 32 insertions(+), 1 deletion(-)

diff --git a/drivers/net/phy/phy-core.c b/drivers/net/phy/phy-core.c
index 2c8bf438ea61..5d08c627a516 100644
--- a/drivers/net/phy/phy-core.c
+++ b/drivers/net/phy/phy-core.c
@@ -13,7 +13,7 @@
  */
 const char *phy_speed_to_str(int speed)
 {
-	BUILD_BUG_ON_MSG(__ETHTOOL_LINK_MODE_MASK_NBITS != 93,
+	BUILD_BUG_ON_MSG(__ETHTOOL_LINK_MODE_MASK_NBITS != 99,
 		"Enum ethtool_link_mode_bit_indices and phylib are out of sync. "
 		"If a speed or mode has been added please update phy_speed_to_str "
 		"and the PHY settings array.\n");
@@ -49,6 +49,8 @@ const char *phy_speed_to_str(int speed)
 		return "200Gbps";
 	case SPEED_400000:
 		return "400Gbps";
+	case SPEED_800000:
+		return "800Gbps";
 	case SPEED_UNKNOWN:
 		return "Unknown";
 	default:
@@ -157,6 +159,13 @@ EXPORT_SYMBOL_GPL(phy_interface_num_ports);
 			       .bit = ETHTOOL_LINK_MODE_ ## b ## _BIT}
 
 static const struct phy_setting settings[] = {
+	/* 800G */
+	PHY_SETTING( 800000, FULL, 800000baseCR8_Full		),
+	PHY_SETTING( 800000, FULL, 800000baseKR8_Full		),
+	PHY_SETTING( 800000, FULL, 800000baseDR8_Full		),
+	PHY_SETTING( 800000, FULL, 800000baseDR8_2_Full		),
+	PHY_SETTING( 800000, FULL, 800000baseSR8_Full		),
+	PHY_SETTING( 800000, FULL, 800000baseVR8_Full		),
 	/* 400G */
 	PHY_SETTING( 400000, FULL, 400000baseCR8_Full		),
 	PHY_SETTING( 400000, FULL, 400000baseKR8_Full		),
diff --git a/include/uapi/linux/ethtool.h b/include/uapi/linux/ethtool.h
index dc2aa3d75b39..f341de2ae612 100644
--- a/include/uapi/linux/ethtool.h
+++ b/include/uapi/linux/ethtool.h
@@ -1737,6 +1737,13 @@ enum ethtool_link_mode_bit_indices {
 	ETHTOOL_LINK_MODE_100baseFX_Half_BIT		 = 90,
 	ETHTOOL_LINK_MODE_100baseFX_Full_BIT		 = 91,
 	ETHTOOL_LINK_MODE_10baseT1L_Full_BIT		 = 92,
+	ETHTOOL_LINK_MODE_800000baseCR8_Full_BIT	 = 93,
+	ETHTOOL_LINK_MODE_800000baseKR8_Full_BIT	 = 94,
+	ETHTOOL_LINK_MODE_800000baseDR8_Full_BIT	 = 95,
+	ETHTOOL_LINK_MODE_800000baseDR8_2_Full_BIT	 = 96,
+	ETHTOOL_LINK_MODE_800000baseSR8_Full_BIT	 = 97,
+	ETHTOOL_LINK_MODE_800000baseVR8_Full_BIT	 = 98,
+
 	/* must be last entry */
 	__ETHTOOL_LINK_MODE_MASK_NBITS
 };
@@ -1848,6 +1855,7 @@ enum ethtool_link_mode_bit_indices {
 #define SPEED_100000		100000
 #define SPEED_200000		200000
 #define SPEED_400000		400000
+#define SPEED_800000		800000
 
 #define SPEED_UNKNOWN		-1
 
diff --git a/net/ethtool/common.c b/net/ethtool/common.c
index 566adf85e658..ee3e02da0013 100644
--- a/net/ethtool/common.c
+++ b/net/ethtool/common.c
@@ -202,6 +202,12 @@ const char link_mode_names[][ETH_GSTRING_LEN] = {
 	__DEFINE_LINK_MODE_NAME(100, FX, Half),
 	__DEFINE_LINK_MODE_NAME(100, FX, Full),
 	__DEFINE_LINK_MODE_NAME(10, T1L, Full),
+	__DEFINE_LINK_MODE_NAME(800000, CR8, Full),
+	__DEFINE_LINK_MODE_NAME(800000, KR8, Full),
+	__DEFINE_LINK_MODE_NAME(800000, DR8, Full),
+	__DEFINE_LINK_MODE_NAME(800000, DR8_2, Full),
+	__DEFINE_LINK_MODE_NAME(800000, SR8, Full),
+	__DEFINE_LINK_MODE_NAME(800000, VR8, Full),
 };
 static_assert(ARRAY_SIZE(link_mode_names) == __ETHTOOL_LINK_MODE_MASK_NBITS);
 
@@ -238,6 +244,8 @@ static_assert(ARRAY_SIZE(link_mode_names) == __ETHTOOL_LINK_MODE_MASK_NBITS);
 #define __LINK_MODE_LANES_X		1
 #define __LINK_MODE_LANES_FX		1
 #define __LINK_MODE_LANES_T1L		1
+#define __LINK_MODE_LANES_VR8		8
+#define __LINK_MODE_LANES_DR8_2		8
 
 #define __DEFINE_LINK_MODE_PARAMS(_speed, _type, _duplex)	\
 	[ETHTOOL_LINK_MODE(_speed, _type, _duplex)] = {		\
@@ -352,6 +360,12 @@ const struct link_mode_info link_mode_params[] = {
 	__DEFINE_LINK_MODE_PARAMS(100, FX, Half),
 	__DEFINE_LINK_MODE_PARAMS(100, FX, Full),
 	__DEFINE_LINK_MODE_PARAMS(10, T1L, Full),
+	__DEFINE_LINK_MODE_PARAMS(800000, CR8, Full),
+	__DEFINE_LINK_MODE_PARAMS(800000, KR8, Full),
+	__DEFINE_LINK_MODE_PARAMS(800000, DR8, Full),
+	__DEFINE_LINK_MODE_PARAMS(800000, DR8_2, Full),
+	__DEFINE_LINK_MODE_PARAMS(800000, SR8, Full),
+	__DEFINE_LINK_MODE_PARAMS(800000, VR8, Full),
 };
 static_assert(ARRAY_SIZE(link_mode_params) == __ETHTOOL_LINK_MODE_MASK_NBITS);
 
-- 
2.35.3


Return-Path: <netdev+bounces-11455-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id E6B9773329B
	for <lists+netdev@lfdr.de>; Fri, 16 Jun 2023 15:54:38 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 9CBCD281795
	for <lists+netdev@lfdr.de>; Fri, 16 Jun 2023 13:54:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 74E2319E58;
	Fri, 16 Jun 2023 13:54:00 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 63F2A19E4D
	for <netdev@vger.kernel.org>; Fri, 16 Jun 2023 13:54:00 +0000 (UTC)
Received: from EUR04-DB3-obe.outbound.protection.outlook.com (mail-db3eur04on2080.outbound.protection.outlook.com [40.107.6.80])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2D20C30DE;
	Fri, 16 Jun 2023 06:53:59 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=d9hxcSudGXT2Kxq7pHHEWh1+SKLlBByNbGp28tXV7JZ+6IImLOP2plY9ZkeVkNgjlMl9Jc6LVVKn6zHMHSbDCpwskS4X/FIXs1SxriNEn+sfEyqkgJdy24zLXpcqc7+sYreyQ2odZZTwrXa2DrDVCzDMmBH09qZBYyOplMJqYeim+nZGUnrCzOMWPXjySOcTCActnqhmF6DejlSX0tMBhI7TIrZCr3e6IQ89pUqwq9GYQO38I6mIiGxtBqH8vAch46Wt9nHFrIgLAVeMrk+QGL0/pViAO/1bgejy2y/2BVRr4aLeZXhlS+d93qT7KEEdXoHjHbcuBKGFPTICDWEI6A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=wh2vJC8ChTfKQwkLYfzpWOgAhicMc27vW7eIyIvO4jU=;
 b=cwIcehvhBkikwXEpHDrmHyRB40cAcs5Jqspw2j5Rk/0JVccUFauzAkEu879w5RIde1FAtQ/7NAJu0N85KJCsRB5UG7dMRd3r4Z/ktxT7ORlyGqCAuqO/D/fhrU1Ug3wYEjH1sDwDK+PX06HcnuhD8YN6dZeHSDUUwgTswHUTjR9URvGSkFNASoo2v1YAIU/iLwO5VKrHFNyjO0eki4HPb976y9vxjh3r5t2+BBAdNxS0Gwfd8MCb+sLkguAI0EyU+NfLXO5MlFXbnlzfaWhFZkHjq6siPbe2NT1WpgrXv4B7KByBho8EJ6eOs7Xih27yS12PF1L+/P7Wt2lUjYoNBg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oss.nxp.com; dmarc=pass action=none header.from=oss.nxp.com;
 dkim=pass header.d=oss.nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=NXP1.onmicrosoft.com;
 s=selector2-NXP1-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wh2vJC8ChTfKQwkLYfzpWOgAhicMc27vW7eIyIvO4jU=;
 b=BIsrZKKhCQUCodzCSvHsWGn5YgSdKQL6AEaO8kx060zGOwtpYrs41DfEkCf5Q0/g1nabWakiqBf59pXfkO7rqTdTs6syiGgNjngaOpFPvKd4pG5/MWZhW2M6Q5zdFp75Uq809Yd/1GGQcv3oSPivKR/ag2rOOHaxuilIj6EKyOE=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=oss.nxp.com;
Received: from AM9PR04MB8954.eurprd04.prod.outlook.com (2603:10a6:20b:409::7)
 by PA4PR04MB9318.eurprd04.prod.outlook.com (2603:10a6:102:2a5::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6500.25; Fri, 16 Jun
 2023 13:53:56 +0000
Received: from AM9PR04MB8954.eurprd04.prod.outlook.com
 ([fe80::5356:c79f:ef9f:dc29]) by AM9PR04MB8954.eurprd04.prod.outlook.com
 ([fe80::5356:c79f:ef9f:dc29%4]) with mapi id 15.20.6500.029; Fri, 16 Jun 2023
 13:53:56 +0000
From: "Radu Pirea (NXP OSS)" <radu-nicolae.pirea@oss.nxp.com>
To: andrew@lunn.ch,
	hkallweit1@gmail.com,
	linux@armlinux.org.uk,
	davem@davemloft.net,
	edumazet@google.com,
	kuba@kernel.org,
	pabeni@redhat.com,
	richardcochran@gmail.com
Cc: netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	sebastian.tobuschat@nxp.com,
	"Radu Pirea (NXP OSS)" <radu-nicolae.pirea@oss.nxp.com>
Subject: [PATCH net-next v1 02/14] net: phy: nxp-c45-tja11xx: use phylib master/slave implementation
Date: Fri, 16 Jun 2023 16:53:11 +0300
Message-Id: <20230616135323.98215-3-radu-nicolae.pirea@oss.nxp.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230616135323.98215-1-radu-nicolae.pirea@oss.nxp.com>
References: <20230616135323.98215-1-radu-nicolae.pirea@oss.nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM0PR01CA0106.eurprd01.prod.exchangelabs.com
 (2603:10a6:208:10e::47) To AM9PR04MB8954.eurprd04.prod.outlook.com
 (2603:10a6:20b:409::7)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: AM9PR04MB8954:EE_|PA4PR04MB9318:EE_
X-MS-Office365-Filtering-Correlation-Id: b83ffa02-d811-4f0d-56a4-08db6e712075
X-MS-Exchange-SharedMailbox-RoutingAgent-Processed: True
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	ea6NBVtSf04e5H3UCcQAHGNdmgtHUk+Rvonm6uNeFRXRMW8xiykI1si/fDUHkua75cRGnBN2IFVzusv8LImoTV3mJ0lE/Akvbqxed/zXPbYp4qvinEzmrO6WUQ/II/9WqSNWny32mz51o8jvQ6Kwox2h9RNYp7trjGKg6/HmgiFZ7honl9nNP9/tX4cXRhEMudh70kGL6KrNclTXpy05HC1nYwp4360RRh8vBaFhKlPxPGyk4jzNf4g2N4fIakYtjjDwCiTHZQdPpeS10hCkUcpkQ5RyGEYA2HVQ5hQ1PNBlDLcPfjzd8HDOkjQAIu7VblISoEk5IAxBIngJngT8dGKhz8fSXMqEVXHe9ZPBF1HXaDYan7xQaSUBv75NMoksTdVj+8NuOHT5sGcM3zmhdbAbVWgBH1J2JpYRowtKxJappaZKqb/YPkQfTwuq6Ojva2r1XtOeY/u+RbT85/klvBzV3nBNP+TZj6G3uFiw3/BJIkSu1NQf/bj4GOmIDNcX0ipG5IbJx1hpMzarwZRdaVQ4IuM63/Zfvx+x3LKN3hnotVH0BadM4Gw5hNEsP/CvHqjc9peMUimdjNfKu8aXLKXFJ52Pj9ikhx8KJLsLoAbjKY0eZSMmfdE3PV7G2gmx
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM9PR04MB8954.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(39860400002)(396003)(366004)(346002)(136003)(376002)(451199021)(41300700001)(52116002)(86362001)(66556008)(66946007)(316002)(6486002)(8676002)(8936002)(6666004)(66476007)(4326008)(478600001)(7416002)(6512007)(5660300002)(26005)(83380400001)(6506007)(1076003)(2906002)(186003)(38350700002)(2616005)(38100700002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?lnlajcqSlqJYMZPdPFLapWCrQyXyBOXGKgas+VSI1TPwzQiZsLnZWFoEy24f?=
 =?us-ascii?Q?cre1zf7d0r0GUN+q47MIkrtLlh7pctUcSogENo882/gD+1bX+3X3nzQ5jdH6?=
 =?us-ascii?Q?T+O8oulCo+3nkdSM0MaYIV84aQff5Ur/A5tZz9jysCEseP19zWZk55MakOKN?=
 =?us-ascii?Q?BStWCWTYGyybMcq3AAv069skhZz6soLs5tJ73Tw9SQmBahMMFKAzBgj3eakv?=
 =?us-ascii?Q?I3gF489b5TvLcu71sekIPR3UcdpO5UDWOFL4tgcM2zam4Doe/lrnlv/iKvWi?=
 =?us-ascii?Q?K5jUgvlOpjeq/30arnXJeRUkbczVAVc9STr+2D+p81FaTMEoaYQtkDNS4LW6?=
 =?us-ascii?Q?lmnLhWR+6fxTlhJng/NHPs4AmCGcEkPNTraoQ8FzYyXvlC0HUYyCYDkqt+2h?=
 =?us-ascii?Q?ILyt9sQq+iq2FPT289CI/gALpq2t84U2w4tn5a6QiDVaja3ldktY9v38xTpw?=
 =?us-ascii?Q?ld8HrcfVGGzEGLSmvEImmZiiWwOqFeciJ2F7I7kpVWHp3HtEWlwT+pY+wtSk?=
 =?us-ascii?Q?pNPUlpEHbK8H0cBzySwkT/A8u30WVmw1p2y5YZ6Fvu2i5UGpPPEyY/IpeDBe?=
 =?us-ascii?Q?qofY5zl8DtHG545HBBjaFJgytwx6W43VpfQJcT10KBYOet+pHbNtclCcnlqs?=
 =?us-ascii?Q?qZ50JPGy3vzA3eGx39imSFMtPZRtclc1dSiOi+f5CrQgoIZ95lSzpTzRQRJi?=
 =?us-ascii?Q?WU/UfvMUVnN9Mmr+EakbsnE19RMgs38TrPlaIGCwatp07Krn/1flmpqj5s5z?=
 =?us-ascii?Q?iJOf1H4NpXblcIqZ6lXZA/zzjFgeDGOCruFVXNU1WUlcnyppppVFisIXAwEI?=
 =?us-ascii?Q?MAyn5T+0BMcFKViUF2vzwbVEjNXSYI5sPaUwOZz7D63FMJ+767EiJ1ef9MAC?=
 =?us-ascii?Q?S42voO0lsttRlG1tDGINzRq02xGRBuQ9sRXaabmN/h1auVV0r0Ejxym/F0E7?=
 =?us-ascii?Q?cZKGhXgMLNcfk+U85jERB838iaSEBjDcrOTrgw0sI3ssAOPSQGkh/yOBRZ6v?=
 =?us-ascii?Q?oM6IJ4P/oBf2EhDn2CrDHW201mnfUZNHRK9I94EcUz/+h+HdpHrxgglvvkzi?=
 =?us-ascii?Q?PbVNVUy6YmTKJitxRduqPuvmrOq6gfZO94TwtzCT4GJXZ3PyJ9ZjZf/FsKd+?=
 =?us-ascii?Q?K5twu1mO1zdahr3T3TQ6O03AGSE6YLHYrVr4L0cmurYcJOKcnl7N2mFcTQdY?=
 =?us-ascii?Q?iWlRvltP/W3he1Cc+QHxpm35jmQVTq6k7hQe8+W/NpQYH0H20bFmTFIs5R0Q?=
 =?us-ascii?Q?YG1rsnRC3nZNc9CHOr6dTCPQGx8+YCPvJt/zTSQAsjkX//cUbCRb34sklpct?=
 =?us-ascii?Q?5/XsqgzCBfal0UwUNVNaXj75FqxXfv11Go2i7d8neScEBLx4RCE+tdKTN77L?=
 =?us-ascii?Q?C976vvm3Es8RURcVZkIcncqB+NS7Cl5TdkWywOJCaT3+cNf7/O5RMnHnIAT+?=
 =?us-ascii?Q?vMFUy71aIbZ+hTeS5+N7II1Ai3MqBP3/R/LsT5MUCiWZZLiob1wF/Tk39T/O?=
 =?us-ascii?Q?K5fm8IbDVmjwtD6AHxGJpZuX9abOXhGFgqlYSm4+4a33RfVA17MlLMwF+l/k?=
 =?us-ascii?Q?qUpmNo0HJXLc++yaM87OdrVeQzhbR+yedQk/TZWMNvKeZn++vZGYxqfRNFYt?=
 =?us-ascii?Q?iQ=3D=3D?=
X-OriginatorOrg: oss.nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b83ffa02-d811-4f0d-56a4-08db6e712075
X-MS-Exchange-CrossTenant-AuthSource: AM9PR04MB8954.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Jun 2023 13:53:56.3983
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: NTKQURizUA7lp9UUBcriiBhCjBSnier93DR27xm8Qrn2d65VymWFFBPoOe/7axS1QEmjSB+n69JW9IYZRO+VpsJi30NHELq55pcY1pc/Cbw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PA4PR04MB9318
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Remove the custom implementation of master/save setup and read status
and use genphy_c45_config_aneg and genphy_c45_read_status since phylib
has support for master/slave setup and master/slave status.

Signed-off-by: Radu Pirea (NXP OSS) <radu-nicolae.pirea@oss.nxp.com>
---
 drivers/net/phy/nxp-c45-tja11xx.c | 77 +------------------------------
 1 file changed, 2 insertions(+), 75 deletions(-)

diff --git a/drivers/net/phy/nxp-c45-tja11xx.c b/drivers/net/phy/nxp-c45-tja11xx.c
index 7b213c3f4536..78a30007edf8 100644
--- a/drivers/net/phy/nxp-c45-tja11xx.c
+++ b/drivers/net/phy/nxp-c45-tja11xx.c
@@ -19,13 +19,6 @@
 
 #define PHY_ID_TJA_1103			0x001BB010
 
-#define PMAPMD_B100T1_PMAPMD_CTL	0x0834
-#define B100T1_PMAPMD_CONFIG_EN		BIT(15)
-#define B100T1_PMAPMD_MASTER		BIT(14)
-#define MASTER_MODE			(B100T1_PMAPMD_CONFIG_EN | \
-					 B100T1_PMAPMD_MASTER)
-#define SLAVE_MODE			(B100T1_PMAPMD_CONFIG_EN)
-
 #define VEND1_DEVICE_CONTROL		0x0040
 #define DEVICE_CONTROL_RESET		BIT(15)
 #define DEVICE_CONTROL_CONFIG_GLOBAL_EN	BIT(14)
@@ -999,72 +992,6 @@ static int nxp_c45_cable_test_get_status(struct phy_device *phydev,
 	return nxp_c45_start_op(phydev);
 }
 
-static int nxp_c45_setup_master_slave(struct phy_device *phydev)
-{
-	switch (phydev->master_slave_set) {
-	case MASTER_SLAVE_CFG_MASTER_FORCE:
-	case MASTER_SLAVE_CFG_MASTER_PREFERRED:
-		phy_write_mmd(phydev, MDIO_MMD_PMAPMD, PMAPMD_B100T1_PMAPMD_CTL,
-			      MASTER_MODE);
-		break;
-	case MASTER_SLAVE_CFG_SLAVE_PREFERRED:
-	case MASTER_SLAVE_CFG_SLAVE_FORCE:
-		phy_write_mmd(phydev, MDIO_MMD_PMAPMD, PMAPMD_B100T1_PMAPMD_CTL,
-			      SLAVE_MODE);
-		break;
-	case MASTER_SLAVE_CFG_UNKNOWN:
-	case MASTER_SLAVE_CFG_UNSUPPORTED:
-		return 0;
-	default:
-		phydev_warn(phydev, "Unsupported Master/Slave mode\n");
-		return -EOPNOTSUPP;
-	}
-
-	return 0;
-}
-
-static int nxp_c45_read_master_slave(struct phy_device *phydev)
-{
-	int reg;
-
-	phydev->master_slave_get = MASTER_SLAVE_CFG_UNKNOWN;
-	phydev->master_slave_state = MASTER_SLAVE_STATE_UNKNOWN;
-
-	reg = phy_read_mmd(phydev, MDIO_MMD_PMAPMD, PMAPMD_B100T1_PMAPMD_CTL);
-	if (reg < 0)
-		return reg;
-
-	if (reg & B100T1_PMAPMD_MASTER) {
-		phydev->master_slave_get = MASTER_SLAVE_CFG_MASTER_FORCE;
-		phydev->master_slave_state = MASTER_SLAVE_STATE_MASTER;
-	} else {
-		phydev->master_slave_get = MASTER_SLAVE_CFG_SLAVE_FORCE;
-		phydev->master_slave_state = MASTER_SLAVE_STATE_SLAVE;
-	}
-
-	return 0;
-}
-
-static int nxp_c45_config_aneg(struct phy_device *phydev)
-{
-	return nxp_c45_setup_master_slave(phydev);
-}
-
-static int nxp_c45_read_status(struct phy_device *phydev)
-{
-	int ret;
-
-	ret = genphy_c45_read_status(phydev);
-	if (ret)
-		return ret;
-
-	ret = nxp_c45_read_master_slave(phydev);
-	if (ret)
-		return ret;
-
-	return 0;
-}
-
 static int nxp_c45_get_sqi(struct phy_device *phydev)
 {
 	int reg;
@@ -1366,11 +1293,11 @@ static struct phy_driver nxp_c45_driver[] = {
 		.features		= PHY_BASIC_T1_FEATURES,
 		.probe			= nxp_c45_probe,
 		.soft_reset		= nxp_c45_soft_reset,
-		.config_aneg		= nxp_c45_config_aneg,
+		.config_aneg		= genphy_c45_config_aneg,
 		.config_init		= nxp_c45_config_init,
 		.config_intr		= nxp_c45_config_intr,
 		.handle_interrupt	= nxp_c45_handle_interrupt,
-		.read_status		= nxp_c45_read_status,
+		.read_status		= genphy_c45_read_status,
 		.suspend		= genphy_c45_pma_suspend,
 		.resume			= genphy_c45_pma_resume,
 		.get_sset_count		= nxp_c45_get_sset_count,
-- 
2.34.1



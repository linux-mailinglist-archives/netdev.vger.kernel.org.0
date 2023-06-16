Return-Path: <netdev+bounces-11466-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id EBD4D7332B3
	for <lists+netdev@lfdr.de>; Fri, 16 Jun 2023 15:58:15 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id A698A2817BB
	for <lists+netdev@lfdr.de>; Fri, 16 Jun 2023 13:58:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 610621ACA1;
	Fri, 16 Jun 2023 13:54:57 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F19F19E40
	for <netdev@vger.kernel.org>; Fri, 16 Jun 2023 13:54:57 +0000 (UTC)
Received: from EUR04-DB3-obe.outbound.protection.outlook.com (mail-db3eur04on2065.outbound.protection.outlook.com [40.107.6.65])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1458F35BE;
	Fri, 16 Jun 2023 06:54:26 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=WreIKL52TDby+f70Oi2VIY+7YzaVa7vS868X+AzzHQUC8RDKdm80i2AOf8Vb6TQvjhyU33s6R/+f/p83i4bvg+PTO2v6sf9qOQ15ll2lvXE8kT9hX7rodbeXprmajCGEnlVCzW2ImtPs6u8LFKdfPamkRrNIp7vQftYsRl2bYhTLWcKADsi/LTP2t9F/TAfkJVMCaFr0XVk4QNe6pBHVUzMWaJqEKrb02JPOoAYyOQeEom3IBPklqeTmo5w4+fvhkAW2dQ+YN+uVkqtwzvZYO6tPEOxpmvL/m0T2qFSjEuLpK8zsnKKOf4RIvWcoz7Vhj9x8WLtjO/yDlb3g1KEWkQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=wcDcZg+fEnaFJECLgaYFdV3yzxB51wthQPGaJAi8V2g=;
 b=mx7UFOrQSJz+PMs/blHQTbI/nVRwQtn4N4gdC9UMRuQ8nKquRY5RLTGiyMwBbW+lVw0rhbb7uLg9qa4yqHcs2M0LVPszcUmjyWOiG7Dy0jAlgRuoJkMDoU0BUS+/G7Hz5TUgRirUBrpqeF53kef1h9oIep3CE5l7yO/Mz2jScetquPz9Up5tiWHtfwIss6DzPapj8gWbZbJujINTMGdx+bKs2KcIoAYJkcPYQSv6w16iPHiNSNF8UgbY/dH7wU0RHPhPoquRzO2P1c/V3ABt0m2u7fZ+pYnuB7KJ57Pv7lb/ZcmtNSaXRW0NWdRKoeVizRiWEMqCV/Ju1TiiLvKIBA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oss.nxp.com; dmarc=pass action=none header.from=oss.nxp.com;
 dkim=pass header.d=oss.nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=NXP1.onmicrosoft.com;
 s=selector2-NXP1-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wcDcZg+fEnaFJECLgaYFdV3yzxB51wthQPGaJAi8V2g=;
 b=NII28wTjw/9eLga4+4fNn7NpVe2UCh1yQMY+Xogtkr30e9GpO1mIEXiq3KOAFBF24S5cKCfdfYoHzAD6X0wzm+4OQPM5E4R8dP+xho/Xn3VafBBQUlczLP81ZxPB62nXQx7crHxkvnj001PZxPx5R2tGCswUUoDWG05yszJtdQI=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=oss.nxp.com;
Received: from AM9PR04MB8954.eurprd04.prod.outlook.com (2603:10a6:20b:409::7)
 by PA4PR04MB9318.eurprd04.prod.outlook.com (2603:10a6:102:2a5::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6500.25; Fri, 16 Jun
 2023 13:54:06 +0000
Received: from AM9PR04MB8954.eurprd04.prod.outlook.com
 ([fe80::5356:c79f:ef9f:dc29]) by AM9PR04MB8954.eurprd04.prod.outlook.com
 ([fe80::5356:c79f:ef9f:dc29%4]) with mapi id 15.20.6500.029; Fri, 16 Jun 2023
 13:54:06 +0000
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
Subject: [PATCH net-next v1 13/14] net: phy: nxp-c45-tja11xx: reset PCS if the link goes down
Date: Fri, 16 Jun 2023 16:53:22 +0300
Message-Id: <20230616135323.98215-14-radu-nicolae.pirea@oss.nxp.com>
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
X-MS-Office365-Filtering-Correlation-Id: da81a6a2-de93-4288-fdb1-08db6e7126bb
X-MS-Exchange-SharedMailbox-RoutingAgent-Processed: True
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	T7AFjoikDY9Kqu0W84CkXJqtaJu55eiM//PbrN/xvgoIJ4aQBpcM9FK7f2AdUUd88OcS+S3A4kH9Fdx+wosDisBuokcDO3Lv0NAcUUTPOS6DXRbY1ZpcslHB4IEh6A4c0tucTeJKoWrTt/oV0eV1rHK1SpPHyJoOehqBR9xHZL2zRjKTiYkqfx/pdCW/sjmJA4Y4t+Pf/GcZnbuNyzRZNPTTQLW2vK8OOB8ukuuIueLRKmbk58wsFRIgik4Fq0Zihr6leL59b1E668m8sg/yKfarBZcRLBfP0WdtjwsIHVjh4mfKwkuYd24sonDXnuQ7BJB++edQCey9YNIxJ9dPydD1O9AFwMdaRuijz23fbYplgun5PSW5x/ZVtXyOP5Rf/0zrfRtXaeg9simn3cxvMSv94XIXKe87bbaarjbcNC/zK3PTVHb9jp4HLXQ/v5kUxC0rKHCA+StSLviIfI5AQtVImPfhY76PsDTWCd2EqL24zFFGW2RKaWTORfRWdAv/xQnKi8B/63dUMGvuy9Jg91MW6LB/+6Ey+6wx5dmsR+S4Un8PmNGp/pQPo3aCuNp8u1D0FcejxuaKEEVilzvl0Dl97Wq3PZw1DL0/bhdpdDuWehS9dVryuF658KQ/wgaD
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM9PR04MB8954.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(39860400002)(396003)(366004)(346002)(136003)(376002)(451199021)(41300700001)(52116002)(86362001)(66556008)(66946007)(316002)(6486002)(8676002)(8936002)(6666004)(66476007)(4326008)(478600001)(7416002)(6512007)(5660300002)(26005)(83380400001)(6506007)(1076003)(2906002)(186003)(38350700002)(2616005)(38100700002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?W03C2FwzhkY7fkHcRvnj/meFK71jAtM33uR9mbHdSb7FifNPEW7HWOrVjUTY?=
 =?us-ascii?Q?Phq5KTwyUNGWeinAC4AcK7R4R0louOL8G/SWVRywDlKAZL7Bp+BDOqC34M1F?=
 =?us-ascii?Q?2ayV14wUBs6PY6I6jLaFsJ+gPDTNkB4MnQdK9qRnn4sBtqWlvl2fMc4f0t4z?=
 =?us-ascii?Q?qhUosImBu4IfSayUoEF3jr02iqP1Wq0K+mPtg7V3Av7Bw6mPB6IHqXXd7e2a?=
 =?us-ascii?Q?paas3DlDtjAsr4dvR5W85qMIIIrOSeRP5Ahd3Ea/kToeAzbk/u9Vn+hoJEa9?=
 =?us-ascii?Q?K8DGlqIOLFvZEWfUZPmKCehFkq3QCMl+jxeLoDFmyc7MuH3v8uB/UykbBZEQ?=
 =?us-ascii?Q?GCIotTQGOWdqyyS5gkOjhejqJhvgiGRk0AHZYRybuqv9qhmtemHCzkEZ53c8?=
 =?us-ascii?Q?97bWFLxHsaW0mfv7+poVwNkz65U4YMq4l5Htv0uqhx8/bU8svhMu8Aor/FdZ?=
 =?us-ascii?Q?EQS3JmUY1MCBEm7xAHH3nR8uwEZQyLuRF96pqQYIcyYVjoRWwnNvh6b7f4Pw?=
 =?us-ascii?Q?+O3IW4xba1oK5TM2aLVI8hYCmZNDqrc7ttTBrmO4YA0Pu8b55XeTy+IxW8Vb?=
 =?us-ascii?Q?IXUWGzT6NJ/mj8/kBilUVUPiufq3ku4OK/Qs7naGlHZrbAmP+u16TNNMzLf/?=
 =?us-ascii?Q?5UWl9zrxTJ+81DCFzgejRN0sKHTHUdx0pTGVM4ViW9P2nYv7V8N4YvhTB3Jf?=
 =?us-ascii?Q?v4Kn/StKwhFsy0BqNqk9760sVZCoXZBcKa9ZGv01fJ+BDs021u1J7B6pbeus?=
 =?us-ascii?Q?BkTK8qjG2PINJoqmGX6U9c+Bwt2vlkzHReJUrOUBnkRiBp7WBUioD7LYc543?=
 =?us-ascii?Q?bPLsx+4tAbuTRdP63oxuEPGsNMqgEVQAsHD2KnTyIPGUxgrYeaQqC03X6QaS?=
 =?us-ascii?Q?qeudbojuZdOMVp/gaaBYQMCeSvZNL5thZipbW+5C643cvuaiKQen4FKR2VfB?=
 =?us-ascii?Q?Y/ug89ghPWiyP5I83lub4vIP5RVlAGOdCDeicRdCYAqU4CM9FXh7E99FDqMK?=
 =?us-ascii?Q?sL/cmguRzMKO6E0ambh1R1r478o6kzp26WZGlJFUdf3GeZpE3MgYIbx6HIGN?=
 =?us-ascii?Q?PBoNFAt5UPa632ls6y3OSluLWfiGtsquciPX1imz0ooQsUlr82lpxq4DwAJw?=
 =?us-ascii?Q?50Gcaf4qurMZsZnnMMIfC/EGx0xuAM3k64e3JDOERmLeNBSRpRgLnzIBBKxk?=
 =?us-ascii?Q?D33m7M53xON9AaU0bzvBRjTLGMYCzC6NviL0Bap2VPbPw8HK1kJ79bL74bVm?=
 =?us-ascii?Q?mBIDV6ywm437ndaBCTNFZTZpk0xT1LNLlzXwd9s05t7MJ4tFJM8Eei5elLGf?=
 =?us-ascii?Q?tfuFCipUic+VL5AQKOyuAhO6VxH9Ih/L+BZH+lAWpoUW4AJeROsFtueXn0zq?=
 =?us-ascii?Q?70BUQ6vYERtXrvP7DV9GJRq+5U08KfPPalSi711RoY5fDTDI4XFJGqcOd+gi?=
 =?us-ascii?Q?nPNHaH3ofva4si0gVy9PGiuGzMLrSYKE5tGRZmqvmYVvm17ZznAGMY8tyarc?=
 =?us-ascii?Q?XdjS1O64bilQLfeNUnXnjMJWuMLA4tblXlh/v3PzydZ9/GgHNbLFcRIX+lRQ?=
 =?us-ascii?Q?j9xGsfTw05JRTvbEJIu/kzWDQFVZljOLYuhohJOW2S/54tHHShly2UiQWltx?=
 =?us-ascii?Q?yw=3D=3D?=
X-OriginatorOrg: oss.nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: da81a6a2-de93-4288-fdb1-08db6e7126bb
X-MS-Exchange-CrossTenant-AuthSource: AM9PR04MB8954.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Jun 2023 13:54:06.4960
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: MJM5GgcW71JJFBc3SppArUzLh3izLxw8rrJ5nRQXO36IPZVC9pYhUkIF4M5vMBXdTj9oL/3EakeGZ+6Hsb5aHH/2peFkNZKA/SJXTcm/m6M=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PA4PR04MB9318
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

During PTP testing on early TJA1120 engineering samples I observed that
if the link is lost and recovered, the tx timestamps will be randomly
lost. To avoid this HW issue, the PCS should be reseted.

Resetting the PCS will break the link and we should reset the PCS on
LINK UP -> LINK DOWN transition, otherwise we will trigger and infinite
loop of LINK UP -> LINK DOWN events.

Signed-off-by: Radu Pirea (NXP OSS) <radu-nicolae.pirea@oss.nxp.com>
---
 drivers/net/phy/nxp-c45-tja11xx.c | 27 ++++++++++++++++++++++++++-
 1 file changed, 26 insertions(+), 1 deletion(-)

diff --git a/drivers/net/phy/nxp-c45-tja11xx.c b/drivers/net/phy/nxp-c45-tja11xx.c
index 0ed96d696bad..0d22eb7534dc 100644
--- a/drivers/net/phy/nxp-c45-tja11xx.c
+++ b/drivers/net/phy/nxp-c45-tja11xx.c
@@ -56,6 +56,9 @@
 #define VEND1_PHY_CONFIG		0x8108
 #define PHY_CONFIG_AUTO			BIT(0)
 
+#define TJA1120_EPHY_RESETS		0x810A
+#define EPHY_PCS_RESET			BIT(3)
+
 #define VEND1_SIGNAL_QUALITY		0x8320
 #define SQI_VALID			BIT(14)
 #define SQI_MASK			GENMASK(2, 0)
@@ -1325,6 +1328,28 @@ static int nxp_c45_get_sqi(struct phy_device *phydev)
 	return reg;
 }
 
+static int tja1120_read_status(struct phy_device *phydev)
+{
+	unsigned int link = phydev->link;
+	int ret;
+
+	ret = genphy_c45_read_status(phydev);
+	if (ret)
+		return ret;
+
+	/* Bug workaround for TJA1120 enegineering samples: fix egress
+	 * timestamps lost after link recovery.
+	 */
+	if (link && !phydev->link) {
+		phy_set_bits_mmd(phydev, MDIO_MMD_VEND1,
+				 TJA1120_EPHY_RESETS, EPHY_PCS_RESET);
+		phy_clear_bits_mmd(phydev, MDIO_MMD_VEND1,
+				   TJA1120_EPHY_RESETS, EPHY_PCS_RESET);
+	}
+
+	return ret;
+}
+
 static int nxp_c45_get_sqi_max(struct phy_device *phydev)
 {
 	return MAX_SQI;
@@ -1879,7 +1904,7 @@ static struct phy_driver nxp_c45_driver[] = {
 		.config_init		= nxp_c45_config_init,
 		.config_intr		= tja1120_config_intr,
 		.handle_interrupt	= nxp_c45_handle_interrupt,
-		.read_status		= genphy_c45_read_status,
+		.read_status		= tja1120_read_status,
 		.suspend		= genphy_c45_pma_suspend,
 		.resume			= genphy_c45_pma_resume,
 		.get_sset_count		= nxp_c45_get_sset_count,
-- 
2.34.1



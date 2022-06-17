Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DF4D754FECC
	for <lists+netdev@lfdr.de>; Fri, 17 Jun 2022 23:02:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1379217AbiFQUf4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Jun 2022 16:35:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36306 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1356803AbiFQUeb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Jun 2022 16:34:31 -0400
Received: from EUR01-DB5-obe.outbound.protection.outlook.com (mail-eopbgr150052.outbound.protection.outlook.com [40.107.15.52])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 813BD5DA68;
        Fri, 17 Jun 2022 13:34:08 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=V2XCZVK+gnOSA31zyXydj0CPHYYARcKvBS89W3Bn1mUwpz0rkaeo90YRn7y69DJe3jC/amFyH6yvesDOgUv9BJYjqmr4FZcWAOCbE6LP/Fv3hF2x6P9BHMjD7vSmkemCf1ESgSAykLNNpliBRGWJzbu5t3rGu3hpNjbXY++6CLR9WeGGMt4AV/0jr9wM9eVOJWMg+knESsHMcgN/3X3204ciTxBhiZdWfC9CA7qdOr9GXBmNlNAQ3+32s4oYRojKu3RGLjJ/C+vHsdV7CvNLAWV95P1tQcoHRwZB1PaynN/nOH8DGf+3ybxemT3wA5NrCqjMeSarB/Ec1jYtRHLnFA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=EwGmp4JothRZALGGoK3eVqxnN7ATYjCfhlKdCMgzcJA=;
 b=QgGJV2f1dJeJerqbje9Ypoxe2SRMoyCbB9kZgVu9IOn+gj7QJcqQauTUKamTWQCCz0t3s/S0U2IwIIUoAD7XmTQ7B3tOE25tH1MuAkI+YSphj5/QpkdjKa756O31vS3zuZqhZAtDI6LCZs0HPx+VJCYWvn8nM0MSuiMY8kWa+Khw21QECBV8SCrLthRHXgoWN9EMbQfcBRUoODj6G1USQ/aXyGX0Ba1COZtumqh3GpAGTsKrvGAkhxEJPiUlRNd1+/CRw6Pp3R6m858+gjxk26rCodJtqhvEyOjae6NHkQ0l656G/f+EHP2tZ/uOssJL5gP/gjNiuCIPVLa8H34d9A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=seco.com; dmarc=pass action=none header.from=seco.com;
 dkim=pass header.d=seco.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=seco.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=EwGmp4JothRZALGGoK3eVqxnN7ATYjCfhlKdCMgzcJA=;
 b=rOIS2mvMAfS/HeenrDecxPOEL2ROM0PN3af7Y26VajOqwNeWg81nw1QVi7H2tc/Bzh71H/UWvK117dCz5Iodlrdw7YVih37BHaQwpKRTx7VjBVfa8ZmuXZkOwgDHAiVrhw7qUU4gQmxNTqKkNNHzNQ24DQqUHITgCVG3TPxhM2drWoHUINnjmfj2eojSZehifvlCVzA0C5eE7kL3OogK2e5sDqdww9bc9BKdMRoHUl5YGCZwbyeYa13MC2KvmC24m7aKCHRovlzOpGW076yr+2M69IcSzyYo5JoJVMgaNis8zHoAXPB22uqUr7sQXQw0mO7SV7GVivSYjR2HVMVdkQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=seco.com;
Received: from VI1PR03MB4973.eurprd03.prod.outlook.com (2603:10a6:803:c5::12)
 by AS8PR03MB6838.eurprd03.prod.outlook.com (2603:10a6:20b:29b::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5353.16; Fri, 17 Jun
 2022 20:34:06 +0000
Received: from VI1PR03MB4973.eurprd03.prod.outlook.com
 ([fe80::d18f:e481:f1fa:3e8d]) by VI1PR03MB4973.eurprd03.prod.outlook.com
 ([fe80::d18f:e481:f1fa:3e8d%7]) with mapi id 15.20.5353.016; Fri, 17 Jun 2022
 20:34:06 +0000
From:   Sean Anderson <sean.anderson@seco.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Madalin Bucur <madalin.bucur@nxp.com>, netdev@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Paolo Abeni <pabeni@redhat.com>,
        Russell King <linux@armlinux.org.uk>,
        Eric Dumazet <edumazet@google.com>,
        Sean Anderson <sean.anderson@seco.com>
Subject: [PATCH net-next 16/28] net: fman: Inline several functions into initialization
Date:   Fri, 17 Jun 2022 16:33:00 -0400
Message-Id: <20220617203312.3799646-17-sean.anderson@seco.com>
X-Mailer: git-send-email 2.35.1.1320.gc452695387.dirty
In-Reply-To: <20220617203312.3799646-1-sean.anderson@seco.com>
References: <20220617203312.3799646-1-sean.anderson@seco.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BL1PR13CA0384.namprd13.prod.outlook.com
 (2603:10b6:208:2c0::29) To VI1PR03MB4973.eurprd03.prod.outlook.com
 (2603:10a6:803:c5::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 946e9218-6cc8-4e5d-d5b2-08da50a0b966
X-MS-TrafficTypeDiagnostic: AS8PR03MB6838:EE_
X-Microsoft-Antispam-PRVS: <AS8PR03MB6838CEB7D732AF86184CD61096AF9@AS8PR03MB6838.eurprd03.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: AzgPgX68A9UBCRqQCPyrFH6dlkhaFYjL2w6OmT1SKDdqbFKsXocrvMdHLum6dNNUdbBNPbV39h4k5uS9CTRio42IhjIH8tkr74dqn+fnZXny5bVeenWFDfCNlHZAiAPP12Pl1bYvGlOsQ2VN3VV1PIxMwNIXuYT1dSZDMjCrq3PyZoX7IoOZXL/D2Lj2hA+X3q0ZVu8P8/XjrNfPkP3ZXvaxoIrXHYawsQjlu5acNSjS4sTFrWBUPWuhjiOziyyfJyyo958fnOlpiEE0Fuufbe2L1Fl0iBBu+zY+sXYBNBPgIgkM54JGR7JSDV+d8BJQpMIr51KE+mGG0iz5j4ewT/2ZJNaaRUfpd01z1KTYMllW9BrCPk3q81QNZm9RkjQctLyW9tMfQVE2n3PrCZCA8HPi4EEYwt0mbN2Hz29w4NUrgH13is/ZrHQ/AWw/uWyAytXor4Kb9HJ5IIycXnruFxPrlbVJpE6ZgfOaNCUOPe/SwlR/CrYPYqSMA9CbktlTBakTSk2XSe9+cPWJEYbRb57pWkERqwBIfObwpeTM2STXC9bc7pFcLdfQ4IuSX/m3QUHnMd1SFwOys0IDW9OYnACJSNYDEiGecXpUkArdMaEc4NDMTYJ9BSGh9+ROG5SypbB3mWQfCRD2P3KYsWk+NuD5HXYFj9zYjGU08MtB3s83GEMdsxXQ/3RvMOBfRMilFb1wSdh1GOwyUkU0bNzj0g==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR03MB4973.eurprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(366004)(44832011)(2616005)(38100700002)(38350700002)(8936002)(52116002)(26005)(316002)(36756003)(6512007)(2906002)(4326008)(66476007)(6486002)(66556008)(6506007)(5660300002)(107886003)(83380400001)(8676002)(86362001)(186003)(66946007)(6666004)(1076003)(54906003)(110136005)(498600001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?UWVCDRrjtFHGjVw4J/xILBS0qdf/Dt2RAfI5FKFgssFEgRq7x1hQnRhcxIly?=
 =?us-ascii?Q?j6CPOXehQJ07MLiGWcB6mmh0iHk2VCVxueuT9dyraBami1BzNmv3uI9Y0zyM?=
 =?us-ascii?Q?FlZpvMGWfvK8v9cMy2eV5fgH29D2pjjAg4UgUwRjR4TCLfYDMj5ZFlCQwOS2?=
 =?us-ascii?Q?fsj037cLG32X4/hsDBDIohXC9c0/pT25d2s2b/Li2Rq/DmWJW16nPZA8eI9H?=
 =?us-ascii?Q?P9kixRG6aO+iFWCpwAa6huyWopACgnpkc1QDNna8oTL8eE3kDwNIPtS8bem1?=
 =?us-ascii?Q?wIzuSqLwWlvDH3em24EI+2SburVyWDu2yZRqRPc9th7HK1Gsmb435NmcyeIR?=
 =?us-ascii?Q?L1mdxqUWf6Z4seOSS+SF3aqlqI5fVe/mPaPdli5Sq7US4qh19WmXrv9MiMQg?=
 =?us-ascii?Q?0rb4/YS+if77IpO6HBtqVzwFqfZavc3Uxbe92NxulHmpOflnH38dPlNEkDmo?=
 =?us-ascii?Q?N0SLq8W0muJmcG601jEvm3+H8JcsfnOX/OdQgSkkl5i/UX88EPkVzsEcvo00?=
 =?us-ascii?Q?7f3Fe9NIwEV4EZticbsnq0Z5aoNPLlX3wZ0CxRR5lSJGI/p1qBDY/OUfmDVN?=
 =?us-ascii?Q?Lre5Z2cvLSl855wlmRB1/tNQNRCK/KOQIr/EzNQQt+56mD2V9FFf9qUDL//t?=
 =?us-ascii?Q?LgntpTtNhuoJCaupr2Sr+rNCBkBMJkH9kiQOWcKr7oBSA4PmWbODvAHiaM1V?=
 =?us-ascii?Q?kdf1/l9tmpA3xU49itJ1CSBE9Hu50m3yQBgBqGJCAYRy+fez+l/euwxFw7HV?=
 =?us-ascii?Q?4rmT9m+eK1tbQoIz+RVnYQOtIBvsSrwbcrZ8CxVU9pCgBWA7uK02MV6vkfAw?=
 =?us-ascii?Q?s+q39zQHHwZ0VQsjqi5ryx1c8vDXIl1TM4QhRTPa94jslGrnJJJnqCWMozzv?=
 =?us-ascii?Q?4DAnlH+pxSm3Wl3Ug6viL2KguX1zTw5ZfxMXj+wlUMmaFXGNHzaUfcXpP+wp?=
 =?us-ascii?Q?1MZSI/CuEpPJfURQRVziO8xp64TJunm8KrxfnBHqrHdcjc0r6Uv0uC8aUTD7?=
 =?us-ascii?Q?xH6jRYQL9/mDN9PjPkFAkbgf/N0OL+DC/ywBP/tqvNTcQ4dxWPxUMsTD3IwV?=
 =?us-ascii?Q?rUoKIFN0t7YlLNMMVPZGKwV24Ns+jMb1SeKAEuX90nLhgWBURfV3Fu5RxFdv?=
 =?us-ascii?Q?RM1Kk7jEB+eO3y0IrAWqs2lIQ5rRiOnUQ1pezTyrfgww8/fPIiySOplGOhMt?=
 =?us-ascii?Q?oEvGixpIii/7CydnfukwYIDfOehk1LUTxr6C4Q1DAQVRa8EzLeevfaH6pDgf?=
 =?us-ascii?Q?IeU32rw1j6fG0R7aYgVWS54uumfxkZjaq7FZVEkxJK6x8Qm3IYq1g930Hexl?=
 =?us-ascii?Q?5uXd7j/HhOD4f9eDLL+1lddERBzcQ/EnFCOkJY6vzpWAWr2hKffB+NPTr/A3?=
 =?us-ascii?Q?gBTzdSmD4NN4DPCG4zbdltelcSTbhtLSGcizPM2XmbGMpFoMqLK1kdpl4UcJ?=
 =?us-ascii?Q?WpG/UGIQd7Ab3DAG9syMyHefoajQ7wjXGzru+l/ETWmItxZ6zf2Go0eDE2Ze?=
 =?us-ascii?Q?FZY/6EnzCQ9E74R+zp5aSppGdOIzZ8aLhTct+bmpvPjtbC4j/DcJaPn3S+A1?=
 =?us-ascii?Q?5RP+1pIcXcxAkqF1XNnqcJBlMRmNfRn2lxTE5zee3Olcd683iRrBF2h54rQv?=
 =?us-ascii?Q?llUbMiU8fMnDqcXwQ+9Un3+7IzUs7J2j7O0y6ITWTDCrch9fdZE4aF8swOYx?=
 =?us-ascii?Q?l0wATx2TToBZeMM8r5RxwK7oLPifZeUiwz6reKbcxQaKpglJMpV1DYt4Jyb5?=
 =?us-ascii?Q?DhQL3PPaga4OzoToGN151RDBVuf90KY=3D?=
X-OriginatorOrg: seco.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 946e9218-6cc8-4e5d-d5b2-08da50a0b966
X-MS-Exchange-CrossTenant-AuthSource: VI1PR03MB4973.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Jun 2022 20:34:06.5610
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: bebe97c3-6438-442e-ade3-ff17aa50e733
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: McKSOYWuz5iLkUiep+m1YOF3V+1w6nskmactNmaCL3zkft9F3o7poAA1MVREBuKUkmw0Bx7oPAVU6HpY0kailA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS8PR03MB6838
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

There are several small functions which weer only necessary because the
initialization functions didn't have access to the mac private data. Now
that they do, just do things directly.

Signed-off-by: Sean Anderson <sean.anderson@seco.com>
---

 .../net/ethernet/freescale/fman/fman_dtsec.c  | 59 +++----------------
 .../net/ethernet/freescale/fman/fman_memac.c  | 47 ++-------------
 .../net/ethernet/freescale/fman/fman_tgec.c   | 43 +++-----------
 3 files changed, 21 insertions(+), 128 deletions(-)

diff --git a/drivers/net/ethernet/freescale/fman/fman_dtsec.c b/drivers/net/ethernet/freescale/fman/fman_dtsec.c
index 8da50c56c440..44718c34c899 100644
--- a/drivers/net/ethernet/freescale/fman/fman_dtsec.c
+++ b/drivers/net/ethernet/freescale/fman/fman_dtsec.c
@@ -814,26 +814,6 @@ static void free_init_resources(struct fman_mac *dtsec)
 	dtsec->unicast_addr_hash = NULL;
 }
 
-static int dtsec_cfg_max_frame_len(struct fman_mac *dtsec, u16 new_val)
-{
-	if (is_init_done(dtsec->dtsec_drv_param))
-		return -EINVAL;
-
-	dtsec->dtsec_drv_param->maximum_frame = new_val;
-
-	return 0;
-}
-
-static int dtsec_cfg_pad_and_crc(struct fman_mac *dtsec, bool new_val)
-{
-	if (is_init_done(dtsec->dtsec_drv_param))
-		return -EINVAL;
-
-	dtsec->dtsec_drv_param->tx_pad_crc = new_val;
-
-	return 0;
-}
-
 static void graceful_start(struct fman_mac *dtsec)
 {
 	struct dtsec_regs __iomem *regs = dtsec->regs;
@@ -1274,18 +1254,6 @@ static void adjust_link_dtsec(struct mac_device *mac_dev)
 			err);
 }
 
-static int dtsec_get_version(struct fman_mac *dtsec, u32 *mac_version)
-{
-	struct dtsec_regs __iomem *regs = dtsec->regs;
-
-	if (!is_init_done(dtsec->dtsec_drv_param))
-		return -EINVAL;
-
-	*mac_version = ioread32be(&regs->tsec_id);
-
-	return 0;
-}
-
 static int dtsec_set_exception(struct fman_mac *dtsec,
 			       enum fman_mac_exceptions exception, bool enable)
 {
@@ -1526,7 +1494,7 @@ int dtsec_initialization(struct mac_device *mac_dev,
 	int			err;
 	struct mac_priv_s	*priv;
 	struct fman_mac_params	params;
-	u32			version;
+	struct fman_mac		*dtsec;
 
 	priv = mac_dev->priv;
 	mac_dev->set_promisc		= dtsec_set_promiscuous;
@@ -1554,34 +1522,25 @@ int dtsec_initialization(struct mac_device *mac_dev,
 		goto _return;
 	}
 
-	err = dtsec_cfg_max_frame_len(mac_dev->fman_mac, fman_get_max_frm());
-	if (err < 0)
-		goto _return_fm_mac_free;
-
-	err = dtsec_cfg_pad_and_crc(mac_dev->fman_mac, true);
-	if (err < 0)
-		goto _return_fm_mac_free;
-
-	err = dtsec_init(mac_dev->fman_mac);
+	dtsec = mac_dev->fman_mac;
+	dtsec->dtsec_drv_param->maximum_frame = fman_get_max_frm();
+	dtsec->dtsec_drv_param->tx_pad_crc = true;
+	err = dtsec_init(dtsec);
 	if (err < 0)
 		goto _return_fm_mac_free;
 
 	/* For 1G MAC, disable by default the MIB counters overflow interrupt */
-	err = mac_dev->set_exception(mac_dev->fman_mac,
-				     FM_MAC_EX_1G_RX_MIB_CNT_OVFL, false);
+	err = dtsec_set_exception(dtsec, FM_MAC_EX_1G_RX_MIB_CNT_OVFL, false);
 	if (err < 0)
 		goto _return_fm_mac_free;
 
-	err = dtsec_get_version(mac_dev->fman_mac, &version);
-	if (err < 0)
-		goto _return_fm_mac_free;
-
-	dev_info(mac_dev->dev, "FMan dTSEC version: 0x%08x\n", version);
+	dev_info(mac_dev->dev, "FMan dTSEC version: 0x%08x\n",
+		 ioread32be(&dtsec->regs->tsec_id));
 
 	goto _return;
 
 _return_fm_mac_free:
-	dtsec_free(mac_dev->fman_mac);
+	dtsec_free(dtsec);
 
 _return:
 	return err;
diff --git a/drivers/net/ethernet/freescale/fman/fman_memac.c b/drivers/net/ethernet/freescale/fman/fman_memac.c
index 2b4df8f3a27a..a97815287b31 100644
--- a/drivers/net/ethernet/freescale/fman/fman_memac.c
+++ b/drivers/net/ethernet/freescale/fman/fman_memac.c
@@ -792,37 +792,6 @@ static void adjust_link_memac(struct mac_device *mac_dev)
 			err);
 }
 
-static int memac_cfg_max_frame_len(struct fman_mac *memac, u16 new_val)
-{
-	if (is_init_done(memac->memac_drv_param))
-		return -EINVAL;
-
-	memac->memac_drv_param->max_frame_length = new_val;
-
-	return 0;
-}
-
-static int memac_cfg_reset_on_init(struct fman_mac *memac, bool enable)
-{
-	if (is_init_done(memac->memac_drv_param))
-		return -EINVAL;
-
-	memac->memac_drv_param->reset_on_init = enable;
-
-	return 0;
-}
-
-static int memac_cfg_fixed_link(struct fman_mac *memac,
-				struct fixed_phy_status *fixed_link)
-{
-	if (is_init_done(memac->memac_drv_param))
-		return -EINVAL;
-
-	memac->memac_drv_param->fixed_link = fixed_link;
-
-	return 0;
-}
-
 static int memac_set_tx_pause_frames(struct fman_mac *memac, u8 priority,
 				     u16 pause_time, u16 thresh_time)
 {
@@ -1207,6 +1176,7 @@ int memac_initialization(struct mac_device *mac_dev,
 	struct mac_priv_s	*priv;
 	struct fman_mac_params	 params;
 	struct fixed_phy_status *fixed_link;
+	struct fman_mac		*memac;
 
 	priv = mac_dev->priv;
 	mac_dev->set_promisc		= memac_set_promiscuous;
@@ -1237,13 +1207,9 @@ int memac_initialization(struct mac_device *mac_dev,
 		goto _return;
 	}
 
-	err = memac_cfg_max_frame_len(mac_dev->fman_mac, fman_get_max_frm());
-	if (err < 0)
-		goto _return_fm_mac_free;
-
-	err = memac_cfg_reset_on_init(mac_dev->fman_mac, true);
-	if (err < 0)
-		goto _return_fm_mac_free;
+	memac = mac_dev->fman_mac;
+	memac->memac_drv_param->max_frame_length = fman_get_max_frm();
+	memac->memac_drv_param->reset_on_init = true;
 
 	if (!mac_dev->phy_node && of_phy_is_fixed_link(mac_node)) {
 		struct phy_device *phy;
@@ -1273,10 +1239,7 @@ int memac_initialization(struct mac_device *mac_dev,
 		fixed_link->asym_pause = phy->asym_pause;
 
 		put_device(&phy->mdio.dev);
-
-		err = memac_cfg_fixed_link(mac_dev->fman_mac, fixed_link);
-		if (err < 0)
-			goto _return_fixed_link_free;
+		memac->memac_drv_param->fixed_link = fixed_link;
 	}
 
 	err = memac_init(mac_dev->fman_mac);
diff --git a/drivers/net/ethernet/freescale/fman/fman_tgec.c b/drivers/net/ethernet/freescale/fman/fman_tgec.c
index ca0e00386c66..32ee1674ff2f 100644
--- a/drivers/net/ethernet/freescale/fman/fman_tgec.c
+++ b/drivers/net/ethernet/freescale/fman/fman_tgec.c
@@ -441,16 +441,6 @@ static int tgec_set_promiscuous(struct fman_mac *tgec, bool new_val)
 	return 0;
 }
 
-static int tgec_cfg_max_frame_len(struct fman_mac *tgec, u16 new_val)
-{
-	if (is_init_done(tgec->cfg))
-		return -EINVAL;
-
-	tgec->cfg->max_frame_length = new_val;
-
-	return 0;
-}
-
 static int tgec_set_tx_pause_frames(struct fman_mac *tgec,
 				    u8 __maybe_unused priority, u16 pause_time,
 				    u16 __maybe_unused thresh_time)
@@ -618,18 +608,6 @@ static void adjust_link_void(struct mac_device *mac_dev)
 {
 }
 
-static int tgec_get_version(struct fman_mac *tgec, u32 *mac_version)
-{
-	struct tgec_regs __iomem *regs = tgec->regs;
-
-	if (!is_init_done(tgec->cfg))
-		return -EINVAL;
-
-	*mac_version = ioread32be(&regs->tgec_id);
-
-	return 0;
-}
-
 static int tgec_set_exception(struct fman_mac *tgec,
 			      enum fman_mac_exceptions exception, bool enable)
 {
@@ -809,7 +787,7 @@ int tgec_initialization(struct mac_device *mac_dev,
 {
 	int err;
 	struct fman_mac_params	params;
-	u32			version;
+	struct fman_mac		*tgec;
 
 	mac_dev->set_promisc		= tgec_set_promiscuous;
 	mac_dev->change_addr		= tgec_modify_mac_address;
@@ -835,26 +813,19 @@ int tgec_initialization(struct mac_device *mac_dev,
 		goto _return;
 	}
 
-	err = tgec_cfg_max_frame_len(mac_dev->fman_mac, fman_get_max_frm());
-	if (err < 0)
-		goto _return_fm_mac_free;
-
-	err = tgec_init(mac_dev->fman_mac);
+	tgec = mac_dev->fman_mac;
+	tgec->cfg->max_frame_length = fman_get_max_frm();
+	err = tgec_init(tgec);
 	if (err < 0)
 		goto _return_fm_mac_free;
 
 	/* For 10G MAC, disable Tx ECC exception */
-	err = mac_dev->set_exception(mac_dev->fman_mac,
-				     FM_MAC_EX_10G_TX_ECC_ER, false);
+	err = tgec_set_exception(tgec, FM_MAC_EX_10G_TX_ECC_ER, false);
 	if (err < 0)
 		goto _return_fm_mac_free;
 
-	err = tgec_get_version(mac_dev->fman_mac, &version);
-	if (err < 0)
-		goto _return_fm_mac_free;
-
-	pr_info("FMan XGEC version: 0x%08x\n", version);
-
+	pr_info("FMan XGEC version: 0x%08x\n",
+		ioread32be(&tgec->regs->tgec_id));
 	goto _return;
 
 _return_fm_mac_free:
-- 
2.35.1.1320.gc452695387.dirty


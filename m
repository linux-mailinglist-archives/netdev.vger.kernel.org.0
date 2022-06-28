Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7A29255F13C
	for <lists+netdev@lfdr.de>; Wed, 29 Jun 2022 00:32:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230487AbiF1WPn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Jun 2022 18:15:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43748 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229747AbiF1WO5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Jun 2022 18:14:57 -0400
Received: from EUR04-VI1-obe.outbound.protection.outlook.com (mail-eopbgr80079.outbound.protection.outlook.com [40.107.8.79])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7E0A9393FD;
        Tue, 28 Jun 2022 15:14:45 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=BH2eshoTsQAkxtw08eE40J5LEZyz+fJfr6vJCJoej2FD1KDVeiFwhxQgyah73l+AGnFTgbapwTpdDJLnhu/dwsd9nOPgL5lDX3/t+gE5WoEj41qHbtOpJDXain6u+h8BtAd1eb0yDaSzoJkIsFrQUxD/p4as+SK20R5XAJq/W1YeWfbzVvJFKJgCLxXfV1dU+c2e3SMawsOo/157t1kxJhieUHu4gShOjNfJQo8y6gPBLgG2rUv4nrPdnbGy3jj5YKpyDaUs5VVl60q3CTOyg4p7wJz7oXHKcRdkodjvJKIBKLunDyQZXLlWu9K/aGOnAn2alAaWZPc6C/Hgl9teCQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=oUrfFcuevg9QB5iLWVeqewSedYp3yYzXMgy6YG9oZBw=;
 b=W9zdKlkBlbzEIwx6Vf42toLlYTLL4ATF6le4RVOtpk+h/64+GZvsPIZqFWOT+wuRaOkLmzkqXDxkN5IDjV3HvLq7X0vgDRFbk6qfdWdTd+I9I1jhSdCxZfz18E1zY+vcffF290CazvIiGH1EYsKVtmjcWFLkt2GKyWZ32khSxeQyzBceQd4U1zP7rTPmFFreEgFE7uuGEvnpzSeBpEPozGvj4c1U5FUuPZ3uXXxefOLutZZwtuSlIPJ8QzqyHCz4kvyZy0UAXl7Eq7D/EA9ITJ0HkcCDOMRUQsbv3FeHhRD1v2PMx4DEiur2iNxJ7ULlADWazEjnRhYUwYHRbOzmuQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=seco.com; dmarc=pass action=none header.from=seco.com;
 dkim=pass header.d=seco.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=seco.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=oUrfFcuevg9QB5iLWVeqewSedYp3yYzXMgy6YG9oZBw=;
 b=RkAMXvYuGk7fKA0NAM03IhPXgbh2RcrPthlk/ydncHfwBY3tMH8gmkJMG3H/cuWxhdG00acja6963iZJg20rX40hSINBWhIEpRTocDBYQ/EXWVGoM0ZsWau4IpVZMueGGnw4WsSelUGagSKgWSzjJPQL3RdXn0Gpgt1VuzOsQ3lAif5gu5KVgyOTawD9s12LhWCOSJrlUVEBpJYw6yGXE6eMvj1Tr7U2Ir3trQJfeZ/E+EB2h9rvK6ZdrYgw1SWAnM4qLRhC3cLeHPalxvrAI59Xfrwl5/NqtOiGolHxtajm5+dEEjW0LSAPLAP/DS0a/DgFUifeGqfpJ089XaSS0Q==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=seco.com;
Received: from DB7PR03MB4972.eurprd03.prod.outlook.com (2603:10a6:10:7d::22)
 by AS8PR03MB7399.eurprd03.prod.outlook.com (2603:10a6:20b:2e2::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5373.18; Tue, 28 Jun
 2022 22:14:37 +0000
Received: from DB7PR03MB4972.eurprd03.prod.outlook.com
 ([fe80::757e:b75f:3449:45b1]) by DB7PR03MB4972.eurprd03.prod.outlook.com
 ([fe80::757e:b75f:3449:45b1%6]) with mapi id 15.20.5373.018; Tue, 28 Jun 2022
 22:14:37 +0000
From:   Sean Anderson <sean.anderson@seco.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Madalin Bucur <madalin.bucur@nxp.com>, netdev@vger.kernel.org
Cc:     Russell King <linux@armlinux.org.uk>,
        Paolo Abeni <pabeni@redhat.com>,
        linux-arm-kernel@lists.infradead.org,
        Eric Dumazet <edumazet@google.com>,
        linux-kernel@vger.kernel.org,
        Sean Anderson <sean.anderson@seco.com>
Subject: [PATCH net-next v2 11/35] net: fman: Move struct dev to mac_device
Date:   Tue, 28 Jun 2022 18:13:40 -0400
Message-Id: <20220628221404.1444200-12-sean.anderson@seco.com>
X-Mailer: git-send-email 2.35.1.1320.gc452695387.dirty
In-Reply-To: <20220628221404.1444200-1-sean.anderson@seco.com>
References: <20220628221404.1444200-1-sean.anderson@seco.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BL1P222CA0011.NAMP222.PROD.OUTLOOK.COM
 (2603:10b6:208:2c7::16) To DB7PR03MB4972.eurprd03.prod.outlook.com
 (2603:10a6:10:7d::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 9c671edc-0677-46db-7e4d-08da595396aa
X-MS-TrafficTypeDiagnostic: AS8PR03MB7399:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 6x+JpDhGMxPZ2NLd98i2UOSpdFPFtPBdJmC5dKhxmlkRIn1PkBWMftwQ+nit5Ikv87SMsdQbpRy3POM6gJlg+kWHDs5Mr/jrc5uWewlZdb0lGMWZ80AkkzRn/WOZArSFuFUZlJrEDI3ZnI6wt3+2DMsxYcjbpqSHH7BSE6yF8oR8Pws47Thkw1g18xY7IxAQPxZdO9spLRiWgOoZxKrqrl/8/zRytVcqYc36EwwRqE+s9GjOZJ8/SL15pPytfUWOpFrPlFRCtc5UDZC0nrqsYj/nXeP+5bBa8W9lQZR10PQ5fc+vfcWeI+ighSE0XQj+ODOAEdlP76MtDWAhG4RsdYuJUPumF/RcqXnLFkkYGXC4QHCy2TiTiYqIDHvQODuSmu0EVZ8qMA43i2gHoFMD0yTubI42T39si4QMxjZJqE2QwFjd2lC6Ob9pW04VMuHH1NWHidQhmJRGey/nejh/9h0KMhkxYdCoQV/FtHQ1P2CbeXgH54SNGKyN11/uW5vvPQOuiZfcx7nION/t4SNGLRzMlFsOylULpEPtJOR1+7qlT7CRMXnskW4qK7ptnQ8FeK1St+R7LyUj2hxbhVrtDTP83h246FzELTJfniAv9hbqHlQvVKRb/0M+x+Q6qCOfc0sSJ9C8mIZriONduUcVqnZzwBPL5/NdMrSnxZz71BsEJD5l0D1KhT2Ue6xfuciSpqEHJxCN6UP7H+OGODSHOzh2jDhNcChK5k9c1XXvF0i+C6gwKCH+d3y44ZNGYOXELqkYMh/chSoiuTMub9O+15Y1qc8V0wQBZU5IEzBjq1Y=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB7PR03MB4972.eurprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(376002)(136003)(396003)(39850400004)(346002)(366004)(38100700002)(5660300002)(44832011)(6512007)(6666004)(186003)(38350700002)(1076003)(83380400001)(86362001)(2906002)(66476007)(8936002)(6486002)(4326008)(41300700001)(8676002)(26005)(52116002)(36756003)(478600001)(66946007)(2616005)(6506007)(316002)(54906003)(66556008)(107886003)(110136005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?mpHJk+8fAu6wELwsTu1DeQrobsJx3l70/tsVgTu0oWPYVMRnMzERETvGgCNA?=
 =?us-ascii?Q?yQcOXKGI2nbhsPwa1BD6DDC9Qg6NqsxT6Yxae2Y+L/6JPAopr6Rtmy9eWKcV?=
 =?us-ascii?Q?HINANVQjc5nFoHBixV/u25kLw0fJ+FWLiNSopO4diunC1TsWEuzqHgC9pdkf?=
 =?us-ascii?Q?STzoLJrFshfeYfUSrSYBxLUtdcbSJFcIR6dQWbKJJCfydO2ytJ8fOvdxr+Ce?=
 =?us-ascii?Q?aKT2/BNVMGYwjXLtTYe5/tN9IpZOvKoY6pesgFSJZC1043IPQZn4HTCc1xLl?=
 =?us-ascii?Q?JurfNpn01XQ8iuVw6p1jOcyjLRrhCGzDOAKHApn3y3trJVKL0xMp4gkY1QGu?=
 =?us-ascii?Q?1a1dLc9TsNB75u7C3OMJvHqpOCHguVLzDeILZbDQ+3Bz5QS0TjlMU9ru66o1?=
 =?us-ascii?Q?HiUmt2+CrBlvMh88a6H+CgaVvgqXoHdudnmtPwZOwNugUYS/6BkmcRK6pSap?=
 =?us-ascii?Q?PumZ/kQysQ0PYoMlhJtb8SRtbyIzjgUktn/5fmJoALari0A1r02YyCi21Rog?=
 =?us-ascii?Q?rGMK0JOemEOVMVfFms9My36UnK3wPhRZy0V33R6rCKGlMPaqlPUmjInZ5aEh?=
 =?us-ascii?Q?PErxIkAVZvOmw7MOJO5fUAX9G2UqnlGwwl8wQkmdwBnIYX7C9MCV5Ka4izVY?=
 =?us-ascii?Q?gMnIP84a3brsiUWtxi7Zuz938dk9NPa8FU1WM5sbU3wwym8oMhN5hSstmGOv?=
 =?us-ascii?Q?2SU0GV1C8hZbi6UBMwnGI8ShBt5JmU5h7r/RlMOwlnHoatQw2LjMTlP1TEqr?=
 =?us-ascii?Q?DxHtP826cFHMar39pXuXI+wPAtejxokb0O2M7hmARg3OOQxIgsYtyhxXR5sj?=
 =?us-ascii?Q?Sa4YZ9z+kAErqQnjIQJFRK4EHcJ7tR2LE7hu83LIUxDltkTYo5yhDOHRQQfI?=
 =?us-ascii?Q?hDUk5TMmqI6hEtq2TMD13a0iGF/6hxQwOYqcVWuQLwGKhrckrdWdEO2nZQJg?=
 =?us-ascii?Q?oZEhf3UKOMuMxaSr+ediZrFUA/5X4GtsgIQYorRPPRrQUT93V7kmN/gQJd7A?=
 =?us-ascii?Q?xEDEuXbZ3WmWduEo4iik61egrGEIOtSHwUHiFrDkJu0DHDEj2T/Wc95ELJNy?=
 =?us-ascii?Q?CHZbZ1SzEoB9JMsHgF5QmLfaEDt+aQ+aPHwDeGWbXg8komijCKU1M0gDMKvs?=
 =?us-ascii?Q?nV2btK3sXAw5kepnbXN5aB/eJbqF5gfT21LwLB1R4EJTnlB0ygtY/PoHkmoC?=
 =?us-ascii?Q?QKWGwH8J8mIYRbAAyDwnkyDlJf36ipX6azqhqzcIVCre12TOujaGa0a7IYVJ?=
 =?us-ascii?Q?5ES9hUO81x97m6VXxD4pbdBAJvdCb7uJLRx5nS0WQyDo700BE+VDYcrHvNEu?=
 =?us-ascii?Q?nd35uhRVELmzZ18vC3rIGDYFvqlelFjKNzQhyzcIDNOfKHXx8oXwBtH41K0Z?=
 =?us-ascii?Q?OIGCt1eeprgJzDnUNTxcKjpuWt45vtlQB3eYUsmM587Ud0Xtiz0J0YZAZljk?=
 =?us-ascii?Q?lJ0T5H42WVjg0FDNCXz67U6JeT8xXjhqtS0Tk38I334gSUXHz97upjNetRob?=
 =?us-ascii?Q?0nb2wDZ9WHStJfDl6i21qLKxgW00wHaLeVTbfY1oZkIQ8jTqqHo94AWnw6Ad?=
 =?us-ascii?Q?MFG8YBDevUcc4ryXYCfBdo2+7AMYosh48YrlgmspOoUy4DqdbIMDU355tSJ5?=
 =?us-ascii?Q?Fg=3D=3D?=
X-OriginatorOrg: seco.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9c671edc-0677-46db-7e4d-08da595396aa
X-MS-Exchange-CrossTenant-AuthSource: DB7PR03MB4972.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Jun 2022 22:14:37.2822
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: bebe97c3-6438-442e-ade3-ff17aa50e733
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: wXoVaF32tEZ/h2KoPyXTiKAMnV8OTmBWJAiyqr7/JJevCPBFg9JBdOQUZRX/HTdM3o0ZTtTZL6OiH3OtJJm5oQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS8PR03MB7399
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Move the reference to our device to mac_device. This way, macs can use
it in their log messages.

Signed-off-by: Sean Anderson <sean.anderson@seco.com>
---

Changes in v2:
- Remove some unused variables

 drivers/net/ethernet/freescale/fman/mac.c | 31 ++++++++---------------
 drivers/net/ethernet/freescale/fman/mac.h |  1 +
 2 files changed, 12 insertions(+), 20 deletions(-)

diff --git a/drivers/net/ethernet/freescale/fman/mac.c b/drivers/net/ethernet/freescale/fman/mac.c
index 8dd6a5b12922..5b3a6ea2d0e2 100644
--- a/drivers/net/ethernet/freescale/fman/mac.c
+++ b/drivers/net/ethernet/freescale/fman/mac.c
@@ -28,7 +28,6 @@ MODULE_LICENSE("Dual BSD/GPL");
 MODULE_DESCRIPTION("FSL FMan MAC API based driver");
 
 struct mac_priv_s {
-	struct device			*dev;
 	void __iomem			*vaddr;
 	u8				cell_index;
 	struct fman			*fman;
@@ -47,20 +46,16 @@ struct mac_address {
 
 static void mac_exception(void *handle, enum fman_mac_exceptions ex)
 {
-	struct mac_device	*mac_dev;
-	struct mac_priv_s	*priv;
-
-	mac_dev = handle;
-	priv = mac_dev->priv;
+	struct mac_device *mac_dev = handle;
 
 	if (ex == FM_MAC_EX_10G_RX_FIFO_OVFL) {
 		/* don't flag RX FIFO after the first */
 		mac_dev->set_exception(mac_dev->fman_mac,
 				       FM_MAC_EX_10G_RX_FIFO_OVFL, false);
-		dev_err(priv->dev, "10G MAC got RX FIFO Error = %x\n", ex);
+		dev_err(mac_dev->dev, "10G MAC got RX FIFO Error = %x\n", ex);
 	}
 
-	dev_dbg(priv->dev, "%s:%s() -> %d\n", KBUILD_BASENAME ".c",
+	dev_dbg(mac_dev->dev, "%s:%s() -> %d\n", KBUILD_BASENAME ".c",
 		__func__, ex);
 }
 
@@ -70,7 +65,7 @@ static int set_fman_mac_params(struct mac_device *mac_dev,
 	struct mac_priv_s *priv = mac_dev->priv;
 
 	params->base_addr = (typeof(params->base_addr))
-		devm_ioremap(priv->dev, mac_dev->res->start,
+		devm_ioremap(mac_dev->dev, mac_dev->res->start,
 			     resource_size(mac_dev->res));
 	if (!params->base_addr)
 		return -ENOMEM;
@@ -244,7 +239,7 @@ static void adjust_link_dtsec(struct mac_device *mac_dev)
 	fman_get_pause_cfg(mac_dev, &rx_pause, &tx_pause);
 	err = fman_set_mac_active_pause(mac_dev, rx_pause, tx_pause);
 	if (err < 0)
-		dev_err(mac_dev->priv->dev, "fman_set_mac_active_pause() = %d\n",
+		dev_err(mac_dev->dev, "fman_set_mac_active_pause() = %d\n",
 			err);
 }
 
@@ -261,7 +256,7 @@ static void adjust_link_memac(struct mac_device *mac_dev)
 	fman_get_pause_cfg(mac_dev, &rx_pause, &tx_pause);
 	err = fman_set_mac_active_pause(mac_dev, rx_pause, tx_pause);
 	if (err < 0)
-		dev_err(mac_dev->priv->dev, "fman_set_mac_active_pause() = %d\n",
+		dev_err(mac_dev->dev, "fman_set_mac_active_pause() = %d\n",
 			err);
 }
 
@@ -269,11 +264,9 @@ static int tgec_initialization(struct mac_device *mac_dev,
 			       struct device_node *mac_node)
 {
 	int err;
-	struct mac_priv_s	*priv;
 	struct fman_mac_params	params;
 	u32			version;
 
-	priv = mac_dev->priv;
 	mac_dev->set_promisc		= tgec_set_promiscuous;
 	mac_dev->change_addr		= tgec_modify_mac_address;
 	mac_dev->add_hash_mac_addr	= tgec_add_hash_mac_address;
@@ -316,7 +309,7 @@ static int tgec_initialization(struct mac_device *mac_dev,
 	if (err < 0)
 		goto _return_fm_mac_free;
 
-	dev_info(priv->dev, "FMan XGEC version: 0x%08x\n", version);
+	dev_info(mac_dev->dev, "FMan XGEC version: 0x%08x\n", version);
 
 	goto _return;
 
@@ -331,11 +324,9 @@ static int dtsec_initialization(struct mac_device *mac_dev,
 				struct device_node *mac_node)
 {
 	int			err;
-	struct mac_priv_s	*priv;
 	struct fman_mac_params	params;
 	u32			version;
 
-	priv = mac_dev->priv;
 	mac_dev->set_promisc		= dtsec_set_promiscuous;
 	mac_dev->change_addr		= dtsec_modify_mac_address;
 	mac_dev->add_hash_mac_addr	= dtsec_add_hash_mac_address;
@@ -383,7 +374,7 @@ static int dtsec_initialization(struct mac_device *mac_dev,
 	if (err < 0)
 		goto _return_fm_mac_free;
 
-	dev_info(priv->dev, "FMan dTSEC version: 0x%08x\n", version);
+	dev_info(mac_dev->dev, "FMan dTSEC version: 0x%08x\n", version);
 
 	goto _return;
 
@@ -446,7 +437,7 @@ static int memac_initialization(struct mac_device *mac_dev,
 	if (err < 0)
 		goto _return_fm_mac_free;
 
-	dev_info(priv->dev, "FMan MEMAC\n");
+	dev_info(mac_dev->dev, "FMan MEMAC\n");
 
 	goto _return;
 
@@ -507,7 +498,7 @@ static struct platform_device *dpaa_eth_add_device(int fman_id,
 		goto no_mem;
 	}
 
-	pdev->dev.parent = priv->dev;
+	pdev->dev.parent = mac_dev->dev;
 
 	ret = platform_device_add_data(pdev, &data, sizeof(data));
 	if (ret)
@@ -569,7 +560,7 @@ static int mac_probe(struct platform_device *_of_dev)
 
 	/* Save private information */
 	mac_dev->priv = priv;
-	priv->dev = dev;
+	mac_dev->dev = dev;
 
 	INIT_LIST_HEAD(&priv->mc_addr_list);
 
diff --git a/drivers/net/ethernet/freescale/fman/mac.h b/drivers/net/ethernet/freescale/fman/mac.h
index fed3835a8473..05dbb8b5a704 100644
--- a/drivers/net/ethernet/freescale/fman/mac.h
+++ b/drivers/net/ethernet/freescale/fman/mac.h
@@ -19,6 +19,7 @@ struct fman_mac;
 struct mac_priv_s;
 
 struct mac_device {
+	struct device		*dev;
 	struct resource		*res;
 	u8			 addr[ETH_ALEN];
 	struct fman_port	*port[2];
-- 
2.35.1.1320.gc452695387.dirty


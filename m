Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0A667580145
	for <lists+netdev@lfdr.de>; Mon, 25 Jul 2022 17:12:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235956AbiGYPLr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Jul 2022 11:11:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55212 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235858AbiGYPLY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 Jul 2022 11:11:24 -0400
Received: from EUR02-HE1-obe.outbound.protection.outlook.com (mail-eopbgr10078.outbound.protection.outlook.com [40.107.1.78])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 15E8F193D2;
        Mon, 25 Jul 2022 08:11:19 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=k1kGb7O0pRmKrFMZiS1TAG+sBJho8LcK6oia7kbs0ZAntj6H5izFqONDin0EdFBPkWuP7wbUSrP4DpKne2kp28dTx9J+V2G7J3yMh0YfLCjWzpIb1481uhrDqdvEjp/ecMfsroIm2BaKSYQfRUVKTUFAp9xWeJ1J02qnXIij0jYmuY/V5t7dguBgruXNfUhV7ISO6ZskB1YDt1sJRbRQs6fS8d3QcTTqy7opXhRJOLqy1VzOYlPjTODREG9zCYcsrgfoguCugs8uquqE6mBPnlXU64ZcIiW37M2eW7w8gXvTvpX81YbHYZBL6R8A/bomglooLrS0rnaqDxUJJ+wTiA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=CPX7hRuvNHelwZEqnA8XUAFgil9vCNo0TTSKnqFGgX0=;
 b=Pb2mH9+AZzHevysMzHg4xQIO11O6LXCnejODvkHaNgrNjUL9tn0Ic5oDu12v7kMLdUCcEh7Ruj+yjZKo9iJkEEXahSU6X3DtzwDtqsvnXAX0xIr6HE6d8LHtg/N3Zm0eNggnowC4wvGicElfryvUx6x35rszcbD9XGKpTAjlE47NRXZHwRB50aXF4x6inHY4M442Tf4f5Sl5pZLm+Pj0b8nN2P4CrL//4cTv4GxkGWGHdeZqsZuvqJv32ojTq7hOc8ZUNm34XdThQL6VDUKIN6r95leMtdv9eRd9TA07tIinI90JRe+MVgpsFUNj68LWwBU9A49mXfCW7/ZGs/683g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=seco.com; dmarc=pass action=none header.from=seco.com;
 dkim=pass header.d=seco.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=seco.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=CPX7hRuvNHelwZEqnA8XUAFgil9vCNo0TTSKnqFGgX0=;
 b=NWE/jcANsfJQ++rI8k3QZTjG2suWs2u9wCSX03txw42OKu6wIUGwuDycpT2Yf8rmwGT8aGpZ6hMjprkpWDJTPicSg66nosa4dewdH5cooTA9Pk+MRfTlWpDsNT+KgL73adqhCMTtvXCjvufrKlMF48maVQOk+IVEysAi27Hf82xLhw0DxjLqeACWmJhqD+n3qYcNE7aub74Rt10RH4PYu9yf8ybHZ2EV/y6mdWl7KP+vX8I+pG3pZbvm5BS5sGyrqozN76zoZwhUnJczuNCGywvzfykuk//XHs8WrK1eDSKZ1EyMc1a8+mA7LCDccNUP4newA7K1Kwk8LO9wmlsjhg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=seco.com;
Received: from DB7PR03MB4972.eurprd03.prod.outlook.com (2603:10a6:10:7d::22)
 by AM9PR03MB7817.eurprd03.prod.outlook.com (2603:10a6:20b:415::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5458.24; Mon, 25 Jul
 2022 15:11:12 +0000
Received: from DB7PR03MB4972.eurprd03.prod.outlook.com
 ([fe80::59ef:35d2:2f27:e98b]) by DB7PR03MB4972.eurprd03.prod.outlook.com
 ([fe80::59ef:35d2:2f27:e98b%4]) with mapi id 15.20.5458.018; Mon, 25 Jul 2022
 15:11:12 +0000
From:   Sean Anderson <sean.anderson@seco.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org
Cc:     linuxppc-dev@lists.ozlabs.org,
        Camelia Groza <camelia.groza@nxp.com>,
        linux-kernel@vger.kernel.org (open list),
        Madalin Bucur <madalin.bucur@nxp.com>,
        linux-arm-kernel@lists.infradead.org,
        Sean Anderson <sean.anderson@seco.com>
Subject: [PATCH v4 08/25] net: fman: Move struct dev to mac_device
Date:   Mon, 25 Jul 2022 11:10:22 -0400
Message-Id: <20220725151039.2581576-9-sean.anderson@seco.com>
X-Mailer: git-send-email 2.35.1.1320.gc452695387.dirty
In-Reply-To: <20220725151039.2581576-1-sean.anderson@seco.com>
References: <20220725151039.2581576-1-sean.anderson@seco.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: CH0PR03CA0229.namprd03.prod.outlook.com
 (2603:10b6:610:e7::24) To DB7PR03MB4972.eurprd03.prod.outlook.com
 (2603:10a6:10:7d::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 4d59d2de-799f-49b5-ce95-08da6e4fe96d
X-MS-TrafficTypeDiagnostic: AM9PR03MB7817:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: HBF3aJcvcZPgMYHErEOEp6aRoRKhU6HvlK3wp8WrHKOgQPWkcss09BsZYOW52uSmBYUADgQDwvmI43Gfw9Af/IFyOLgSK79PMCm/j1ThaBpWvDowoVUuUGBM2MIQSA/TR8+pCMpc+h8Z0RrhccBmMkEllgfU8pnZ66/gCU+BMC6ReTixNgtoyTy+rosoZYm1xnftaIVqkeIfdFJAzHGgqg9QtARE3UazkcqSxVJVOfxL9rAW0TCL6OL39msd1FwqdShWtfpAjqxPtcVDVNXfKVXWcgFbfEzTI3mqAhcw7cBh3lduG9XTq7r/Hr/ZOBsjNQ43jDechpjwtcVS3qb4gYB3DEB94XRfu3NAx7oUMPH2UGSKT6sf3sUMC4OTC2KSU6gIPrsP6YX7ZVcwVe5GBvroSAYcF+i3JiP9z01eeHT7cXB+kDoPlv6JUrO0//UyVv9AJ9CSmCfZ6Tbs5OJMNmQ6MoaCjungaPvDBZIUNHRRtszkfHi8M2AJAkt+y2iN+eh6r6PQ0i+m2n3nON3rNbpy9i+UtMCp9cM8/bxA0ZKK95EhKey1qQxMUTRqosjIfxUKGrpeA+81+3dHUGJx0aywyGHWGn+uoQV+uiXHhogL9x7aIz8ToVKtavM17EqoTEk0hrM++71XGew8lpwPUt7dO1Agec0uxvbUG/1Gjv0PwH4Q9yk2uw7zoPV2vxzHmi3b2/ObQvTMI0/QeRVF4CPOhS9rzQ9pneR2r9orSv5Era9XfbLGClPTXOLr1TLBhuAA7dqsvCMg0SBT0RzPrxYXKO534e8Ix4x40SAQb/Y=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB7PR03MB4972.eurprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(39850400004)(136003)(396003)(346002)(366004)(376002)(36756003)(110136005)(54906003)(186003)(38350700002)(8676002)(66556008)(66946007)(316002)(66476007)(38100700002)(8936002)(86362001)(2616005)(478600001)(4326008)(5660300002)(6666004)(83380400001)(7416002)(6506007)(41300700001)(6486002)(44832011)(26005)(6512007)(52116002)(107886003)(1076003)(2906002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?W/ETnwbf6ONS7sR9Z4ELTQ/QmWSIYwmqb5cHQqcPv36XSBXerkgBjURy27vU?=
 =?us-ascii?Q?yKn9zUrxHexy4BL8a5TZZ+OW5MLugqkk+cJBub38vrh2izF9DVfY1k1lJGZj?=
 =?us-ascii?Q?uC0OLzJTRWwkLc9sdmKhMpAfVD5sbB4UxDs2PYx0dnGm/aoUAz2aHOS5pOg1?=
 =?us-ascii?Q?tqrbmklUpTik92sHAqq4zdfi6MOBcjTcGkXPYboeiX8dQ1WxnSJIYo9otx2o?=
 =?us-ascii?Q?bAEQAqoKjOSoNBJwME8qJytBdmSOIoJO/quGUPDLjt6Y+wPF/GUZ4YGJnsU6?=
 =?us-ascii?Q?GQZbClzAgwrnBvbA3ZbykBo2GHr4MSQWin8iFEx+3gIvbM3VJ/o7xPz4zUW7?=
 =?us-ascii?Q?a4B/cZHz0OSjjdouQF7nNc0bMlw8E7GjMqDjOw6AS3P6gUtIZ4bTdVDMlCGC?=
 =?us-ascii?Q?OymaUVyRodsOAb5PNQwXjWqt/fIuSTDwJn/ZliQuMc27SIFOTQkeGRgjtMfj?=
 =?us-ascii?Q?NV++i9WzFiHS3ocBf8TfGZUdwmv7F/VOHfC4YxTSc88YKkF5UNqlbaVGBy0y?=
 =?us-ascii?Q?bRww/WX2oB1aNvy9PDAC16fpmsmhiC9M1WbgR62oOIY6+cEnQiDqBYLeYDZ+?=
 =?us-ascii?Q?86hKJc3rsyID853VLrYLLpL7k4xg9FOdTSC8CSPN66JJffm1kyZj+ZBVhXvR?=
 =?us-ascii?Q?ii3dWwXHzNIfH6eaAjAqI1tUGKMf7UiMvMrkbZMFGLDQI1eve/jlqMYB+Nix?=
 =?us-ascii?Q?U9ybMjazWzVEIjUaHC4D3NKTE2kR9TxDwt5TchBrmXu1snbFRJTeCcr+yDfQ?=
 =?us-ascii?Q?wmiH/D4LB8T6Eq4I1v1DcykV0VQpMzrdfygUjzZK6ttbD756MlD8vHwWw2us?=
 =?us-ascii?Q?JTdKAy5rdI7zsc8Q1+bFw3meWPjwJubvYWwZmqUg3X+u0mykUY0YRFhnaHMq?=
 =?us-ascii?Q?A8mhhpiY70DOJ5SeCnpx8Fbl/HC8DBiRV8m3tUk67BHV4DILjemCG02FM0cZ?=
 =?us-ascii?Q?3Rr++pZgUVAqqOR55WtZrRW42QnCLepykK/7xf1C4U4V+xoG0qkIeGLqo8um?=
 =?us-ascii?Q?JokrkiPiUWoLJs/hZ2loUc9bXGolbC0Xx0RDBduyaVAefed58skYWMbIk2Jm?=
 =?us-ascii?Q?oejSSg5vz/1OFh9oEPrLKrx8qiyVehyT6tUsD9QRr61IVmHCxNGmhVPW55ux?=
 =?us-ascii?Q?CoxieEs2V8T+9Hk1ezpkEv/FOeQT4q1HFLcMR9eOP/WkwPhItn5O8qojigON?=
 =?us-ascii?Q?gnHkFRPBvgNU6GxvBNhecbFNqU5RzYUMVgMJm7SpJK2RhaKbCFa6+rXhDp6z?=
 =?us-ascii?Q?KaORTgENWHiG/mOdsMDeiZ0bSKLY8KM0Zy4Dg31jZd7iuiqaL9eododH4u9v?=
 =?us-ascii?Q?Zs071l/Z7t2+oXpqkt8xn1C8Eq0dkpST5J+FO7DAsUE+dPrYQJc1d79LyMmI?=
 =?us-ascii?Q?YvLeh3VEc/edkQzYzFU8a8r1rYvdQYhGtdDn2hsyUydt4voU5K0zBHIXJxYl?=
 =?us-ascii?Q?rUxKJBjJx7sXU/eQV6xCL7zRaSQFc5+vbv6nqButWmJeBkJlNhQ6LQFFyWuX?=
 =?us-ascii?Q?mH7uOo2T2UyilNvKIOz+v4D45PoPbsVHZHUNv7vI+dlq9V3pEmXkSm78ooME?=
 =?us-ascii?Q?hLqZycZPlz+bYNmHFQNredRt+h5615eQNqcO1rUQNEI2aAdXsSJDPeq6JAcI?=
 =?us-ascii?Q?Cw=3D=3D?=
X-OriginatorOrg: seco.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4d59d2de-799f-49b5-ce95-08da6e4fe96d
X-MS-Exchange-CrossTenant-AuthSource: DB7PR03MB4972.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Jul 2022 15:11:12.5199
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: bebe97c3-6438-442e-ade3-ff17aa50e733
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: WQh1qfDEKZK6J9g/sOzw7g66Squ2EhPjgkxa9mggSsbhBw+eihTjwhWX/EKVL2tOB7WNhS3CJEzmumoOaJ6TlA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM9PR03MB7817
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Move the reference to our device to mac_device. This way, macs can use
it in their log messages.

Signed-off-by: Sean Anderson <sean.anderson@seco.com>
Acked-by: Camelia Groza <camelia.groza@nxp.com>
---

(no changes since v2)

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


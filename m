Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DC63D598881
	for <lists+netdev@lfdr.de>; Thu, 18 Aug 2022 18:18:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344623AbiHRQR5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Aug 2022 12:17:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39528 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344569AbiHRQRa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Aug 2022 12:17:30 -0400
Received: from EUR04-HE1-obe.outbound.protection.outlook.com (mail-eopbgr70070.outbound.protection.outlook.com [40.107.7.70])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E5CD0BD0A2;
        Thu, 18 Aug 2022 09:17:28 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=UlUQSSP+XKrzs5YCRes3MlYyevDq/xldkfFTWMwOpQZSYMSV9iMJJg2Cg+PLmjqiNdksF6bsYAZj5gd07yLVcR5yvdzirD4A+uZ0lAJxme7o0LLOIUPoNtiU9QJfkVPoq35red7zAkJMpyyxnWH/o7oeGYKMWTZk72hj+/RQFeX+w3M2zVP9sQU1ZVSCVbHGwWQAPJupmyidnh+WtYSjbT9WnyvN5nm0EqjP7bTXosIvTsz8ZELygH+XLuL/40oJi1d0/aBjoLB/Eoev1/84bOXatXTKYQIrnlbJSfSnaqO8VKhkhgns2TNpHsk9bvmKQmoKRVVWaMvHb0G5Mm8wgA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=CPX7hRuvNHelwZEqnA8XUAFgil9vCNo0TTSKnqFGgX0=;
 b=JePjJznxx9VrVfc2+bDW5BabQsAVYZanz2Gib294oFQfALDLjXFP/VLm2RN1B9RZoDSpGalxeCFhS77Poicx0So4hgok1/UcHRP8cNOf6x0mMh9ZDeyVtSm6+kcGOiAqcyNKFNB1uIL1gRWoYVTWwNOcmOlGh/JFsm/4NK/2jbDsxg9ELsSySBuMO3y2ajtIY54+quIrkyfpuLPgXl0QXdrHocARGYL2oPo3pe5CF2N6FwdyAa9qbWMbb33M0/5yVX3oqRLK0QF7J7z/XDrgKAQdNbL0pJeu6OjPpgAubm0xHyjIYSFCZyMELmhtqw14iGIv+u9YIQ9mIz3imm1ieA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=seco.com; dmarc=pass action=none header.from=seco.com;
 dkim=pass header.d=seco.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=seco.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=CPX7hRuvNHelwZEqnA8XUAFgil9vCNo0TTSKnqFGgX0=;
 b=UQsiFoaaha0WyBSh0llxIYzk/IiExHHMtUeIWzPlwi23Br6lzXSdpxUgyxAnsPpkDnbQi6JjGoD4y+V4KuQEFJAdQPMHgF48n49dIpG7ZC0GRgVXsaL46Ib05gI12GXajx3VtMbltNfYLgCAVr8NaOQNM3icrwgBa+1Dqi7yEI5TTk5+ID14GswNoRgHz524JSuuZw7oyDs9xeZ2rmwBULKNXiSCJ65RuJh9JcPXUOoAG7P6k8Qx09QeqbsYC0TEdfzTzF2gGf7JPWlZnveChuSeFQyEMXwuGiko3V6XyHOFo+wwR7f6UvCXW8YBVo3JMGbCqpRav76tU++TqNuc3w==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=seco.com;
Received: from DB7PR03MB4972.eurprd03.prod.outlook.com (2603:10a6:10:7d::22)
 by DB3PR0302MB3211.eurprd03.prod.outlook.com (2603:10a6:8:11::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5546.16; Thu, 18 Aug
 2022 16:17:19 +0000
Received: from DB7PR03MB4972.eurprd03.prod.outlook.com
 ([fe80::ecaa:a5a9:f0d5:27a2]) by DB7PR03MB4972.eurprd03.prod.outlook.com
 ([fe80::ecaa:a5a9:f0d5:27a2%4]) with mapi id 15.20.5504.019; Thu, 18 Aug 2022
 16:17:19 +0000
From:   Sean Anderson <sean.anderson@seco.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org
Cc:     Camelia Groza <camelia.groza@nxp.com>,
        linux-kernel@vger.kernel.org (open list),
        Madalin Bucur <madalin.bucur@nxp.com>,
        linuxppc-dev@lists.ozlabs.org,
        linux-arm-kernel@lists.infradead.org,
        Sean Anderson <sean.anderson@seco.com>
Subject: [RESEND PATCH net-next v4 08/25] net: fman: Move struct dev to mac_device
Date:   Thu, 18 Aug 2022 12:16:32 -0400
Message-Id: <20220818161649.2058728-9-sean.anderson@seco.com>
X-Mailer: git-send-email 2.35.1.1320.gc452695387.dirty
In-Reply-To: <20220818161649.2058728-1-sean.anderson@seco.com>
References: <20220818161649.2058728-1-sean.anderson@seco.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MN2PR20CA0009.namprd20.prod.outlook.com
 (2603:10b6:208:e8::22) To DB7PR03MB4972.eurprd03.prod.outlook.com
 (2603:10a6:10:7d::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: ea78c24a-3e75-44be-16b4-08da81351f9d
X-MS-TrafficTypeDiagnostic: DB3PR0302MB3211:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: qf+3NsUceho+l7HSPrAeMJwSTEmohgtOutofLieYyl1J8ZJAMIXUIT9G3QqvabEjJxQp7m+fyeTiOhZzqXJiFRDmdweMsOPUiNE2RBUYzJ3I47JVePzAXsTPUlK4az1a5T4RrUQn4hSHQRilQOYffr+CQPiut/YRRYuD2swOXfIE8h71dARJwOwTEMTLSkw+EaRCJbyI8X3Ut36lTtSoTb3NlEJ2FcMTFmo4pcj6g2A2etjxtHg+XpsLDmLipHjoR6MtDUMEaK1iikW5B5qY0ghbOJk+m2Fi6E+MGu9H18/G9BGKIP5/WP8jmtIVeC9OGiKbUd7oOLKkV/pfeZURVLX5HxIFuf3CSM1EpxuzuSwAznVfg7RUNz5i20bCRBY1V4LehArYlMGmKiCJ60PusaYt6TFl8d9RilqXXSHrd5FcbZbuz+EOBUQcZg1l3lCsMyo2gulmFN5Btax6WAIwTD8tEAMqiKmAWlPsT68dNC/0r7EY0gIWEhhTNhVxdrrLdIa7bi7CtEKsSv6VQcFEmjGW+lCNmwOtKdWltjaudDqImgLKUgIM/4itjhC8FmnshWgbOrZQjDzJFkF0v+CnOxCi/c2/UyTYrrV9C0wYRrie/zxI9J6SEefU5I/tfrGNg37sIGCWFClxRkEQrtNbt5CTbTNFolRd/d92QxUdTsQokAz+DfP5Fgsp50X4Aq2ngsB+mUX5bcKgwBciRLR85HYBe7isKnl5ED7eu19hrGJoGMjC4Txaa7uaxfV1Wmk20Xtz95KyvaVPwoCkHCiT+g==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB7PR03MB4972.eurprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(396003)(346002)(39840400004)(136003)(366004)(376002)(2616005)(38350700002)(8936002)(38100700002)(4326008)(6512007)(26005)(6506007)(52116002)(6666004)(2906002)(8676002)(36756003)(66556008)(1076003)(66946007)(66476007)(54906003)(110136005)(44832011)(478600001)(86362001)(41300700001)(6486002)(316002)(107886003)(83380400001)(186003)(5660300002)(7416002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?/0bOdinqNilD55NEY+1jj9rb39BKlYubuBfVU803lUzBVb5SdfvIw73VXzsh?=
 =?us-ascii?Q?n4yyJ5ZxdqHZLxR73A/iF4bq/nJGSdMjru1JwOZg0IelJqftJmeqdDGEjfyZ?=
 =?us-ascii?Q?4KpaPl1ZfK8wYEvkIsBYR5pKid9Tg6JXZZMXQD3EWm3+NSscY869O1jq/Pn3?=
 =?us-ascii?Q?nP6P5UQrp31pcQKfC3e6kZdwmZZhkUF+iLAtCFE3HiE6t1J/yXcCUWoWOm/H?=
 =?us-ascii?Q?AyrnQJIPCGiDLozGq4KvSZtza5RTwMZpnOiFZ6QXj4zaaiWIrKdKun3qkWPN?=
 =?us-ascii?Q?Yt1NjM+UjaQyOG4zsamDr2K/Pg0XBnDWPH6cnPxAKCBhDSzs5odT+hpZb0sw?=
 =?us-ascii?Q?8v4u2gi5sFnnYUzOAJrxkhcXWJ+6GBvKd2Aq1fxH7+bvLL1IFXOQYSIyFMkS?=
 =?us-ascii?Q?jGjCcaQnf6cKeCgeHbS2cwBKl9Mf9wVQNXfC7+xW9FF/e0ZXkKqc+xopZJ1l?=
 =?us-ascii?Q?xvtgQwcvrHbF007qj9ZZO/Sd1P0Mso9oPFVGDfHhUcj88NWVcwhx3dHRGXC6?=
 =?us-ascii?Q?SHKGadxS0DEp4y63tThJub1AbEN5iLFPdW4uBps+G9nz1CZyTTfVpfC3Id8Q?=
 =?us-ascii?Q?bU8Kn3Ua6E6L7239rsrMlKb18gd/Tggv+FkkIvmmK0DJ2mVN9qNJY+EdPtuR?=
 =?us-ascii?Q?y2a27/tVzslIPRJ4448x4RfGVv7cVufpAV5eNteRaJcjkOkSzdRpmDHMMeFd?=
 =?us-ascii?Q?NANaO02AvQPSdygGAe1998aIvYdnwrpABYWK2KGd/71QM7t61/Bmg/VV9t8a?=
 =?us-ascii?Q?WEoNXsj69+vp6NH8Du6PZ4Yl+w4/bjBHv4WPauVsijZhL+roPYDo/PhXolp4?=
 =?us-ascii?Q?xZ8KgMNkJi2qyMYd3hjWD+9nlzNmgq+t8Knc3Mzk5QC/+Itq6tA0jdBSgh0U?=
 =?us-ascii?Q?ZdAeZEiK4GUpO4RD5gogsPmGvF8babTA5YnrfPw2GQXjDKmmXOb3jc/g2eK1?=
 =?us-ascii?Q?kqRQthv3jby34cREhOWA8WwHeHdk0A/RCnaH59m/WVvp8dHGqyfRLNT7k7T8?=
 =?us-ascii?Q?0w4+BFrQPUY4cOlt8FMG819OIeXVmj0/lYWC9VwTisQJaVvq4M/g/6JWyhS1?=
 =?us-ascii?Q?JRLZuTaJI/JMnHpeRmkgwyL7gqwFylxIHeuo5gJSGqtaKDjVKOF0kvsTGS0g?=
 =?us-ascii?Q?egSrVlhGaojP7oHn0exbtTcnN+y4lp0DiCSU2mbW8dzuACxzyctEB5r7m3cj?=
 =?us-ascii?Q?fdMPq4YvlgN47YNqyhNaqohRpHq4k3IW69khocRQJDpA+yjA1oqP04ZFDPic?=
 =?us-ascii?Q?qMLfo0wnaMQXFg2v7BRY391RmemR1qdfUdmmj21hgLWjzAcmf0eZ35nOHs9a?=
 =?us-ascii?Q?vQQeSCy/XyJHO2voRgTaXz96TnyatT69jN154GR8NjrL+IuRO4coRWhFgPMJ?=
 =?us-ascii?Q?Kz4D3Id5Ebzy8WEUvpmpYrt0GlkS09b+fsJb46RP+K1nxYg4TqM9GXRzkPpF?=
 =?us-ascii?Q?Hn3cQikgA7QwruVpCGMon67Ghy5t2x445+bCJ10bmjru1vf96tZhovT0xgyT?=
 =?us-ascii?Q?gDEg/dSZuU15NMf4B+SnC/ZQ5ifjIP1WgaY1ko6xz1w5b1wQ3u6a6h28OsqW?=
 =?us-ascii?Q?zPdGgrMaVXXVAdq2f53r2yC1HhDcxu8NmF2/0TPuf1BR9FJ1ry2Dr/ZWopYp?=
 =?us-ascii?Q?kg=3D=3D?=
X-OriginatorOrg: seco.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ea78c24a-3e75-44be-16b4-08da81351f9d
X-MS-Exchange-CrossTenant-AuthSource: DB7PR03MB4972.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Aug 2022 16:17:19.1234
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: bebe97c3-6438-442e-ade3-ff17aa50e733
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: wpN7LDWNBzUmiogC1pYnKvypBUy7gcGaKGB2RbtoKTm8MQeHFB2iSP1rI/rV6tBDDz+ifvk4VR9blV5dhMj4Dg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB3PR0302MB3211
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
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


Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3605757697C
	for <lists+netdev@lfdr.de>; Sat, 16 Jul 2022 00:06:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232153AbiGOWEL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Jul 2022 18:04:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60886 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232147AbiGOWDC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 15 Jul 2022 18:03:02 -0400
Received: from EUR03-VE1-obe.outbound.protection.outlook.com (mail-eopbgr50080.outbound.protection.outlook.com [40.107.5.80])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 873098D5E5;
        Fri, 15 Jul 2022 15:01:22 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=RiycRsGOMUmY2/a+wBhkOzcNvJ1j6N2IXvxRJrJKbqs4qkemWq8XjLe8s6yDOko5O3RdAe1xYGBVt+p03zCuFbe7Vc9UV3vzkdxmMdBMQtojHIMmjNLdiSYC3IkXCO05M+FuUQ+cqaw00iBVip63nL+KCd1TS4YJMCFRAPp+ogDp+DV8Wpuuw7WgOTgHJoZLoyfVDO5FE0q8ZScHzZFcF/Y14MXjTJSccPYBDgTnOGHDvg1cG3g6geTRtxhkRqnn/wjTkA7PXaWYRrr/6K4DYqjfcG9x7rvZnLpWb6N5BmcrNj3E6eVnajyY+R7SBQKn25iJ/cLNw4LNaFaAkfDIAw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=PZK/rW2K6NDVpiwI0/IflAWDjqbC89Vw9tIHDOvYBVw=;
 b=NMU/1V68YOc25N8EK2n487AgA0IX7JpyKywXA81GGLWnT5e4FnfvqUgji/57IRaXeeiWHeYzcK1cGqCG3yINI+XYcXnU3QT2Q0Omj22n94WVb81s0XHhjArWeVy318YVzrTbcWeY+GQMW+Tl+rBtzT6kcUCN3ggrAifTJSxk3PtTfwOTc6QY4pE55wKJWwGSMoHXV6pSKlXTf/PZg4Sz8Rjx01JGmjSKbU48TBcBSDEP9k8+tGZRUDFxIpA3b/CwEvlHKpIH49enHyhwY0wp60e5c0i19k6iott9aErE2tDhqLrlbo0+bExFOWUXYj8Kdw+q+Zl2GpECmJS7LW7OjA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=seco.com; dmarc=pass action=none header.from=seco.com;
 dkim=pass header.d=seco.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=seco.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=PZK/rW2K6NDVpiwI0/IflAWDjqbC89Vw9tIHDOvYBVw=;
 b=k1yk0pLeQ6V/zOCCW+TWnTTPtorwSjI3kbY+sXAP+VW6hIG8e1hsX+Qd4ngdhFNFYsbu2dpEt7VeGBFSAXgySvvABEZ7GB2bxBiLwxs9/p7BDcQvh5S5f4Nj/52wcfzKbNmeObitgHpnCtaDTQFPm7nOzK0lW0IavzrAuCDTxnHaNlJUkHPWrg/e5Dlyg5miluD+qgM0wAT9FRnC9kS/vZwydI0y/qbbbEvLXIlAVDRamqCtPCDvENYR+lb9/s1Nq/bM/bo+DD/2Td8oECPWY5cJxAPLCSq1sYqy81uviidjdtuHnWsc8ZUVVe5zzkRiTsjs0ZEPwo6T7LyNT0h1pw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=seco.com;
Received: from VI1PR03MB4973.eurprd03.prod.outlook.com (2603:10a6:803:c5::12)
 by GV2PR03MB8607.eurprd03.prod.outlook.com (2603:10a6:150:77::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5438.14; Fri, 15 Jul
 2022 22:01:01 +0000
Received: from VI1PR03MB4973.eurprd03.prod.outlook.com
 ([fe80::5c3e:4e46:703b:8558]) by VI1PR03MB4973.eurprd03.prod.outlook.com
 ([fe80::5c3e:4e46:703b:8558%7]) with mapi id 15.20.5438.015; Fri, 15 Jul 2022
 22:01:01 +0000
From:   Sean Anderson <sean.anderson@seco.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Madalin Bucur <madalin.bucur@nxp.com>, netdev@vger.kernel.org
Cc:     Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>,
        linux-arm-kernel@lists.infradead.org,
        Russell King <linux@armlinux.org.uk>,
        linux-kernel@vger.kernel.org,
        Sean Anderson <sean.anderson@seco.com>
Subject: [PATCH net-next v3 21/47] net: fman: Move struct dev to mac_device
Date:   Fri, 15 Jul 2022 17:59:28 -0400
Message-Id: <20220715215954.1449214-22-sean.anderson@seco.com>
X-Mailer: git-send-email 2.35.1.1320.gc452695387.dirty
In-Reply-To: <20220715215954.1449214-1-sean.anderson@seco.com>
References: <20220715215954.1449214-1-sean.anderson@seco.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: CH2PR10CA0009.namprd10.prod.outlook.com
 (2603:10b6:610:4c::19) To VI1PR03MB4973.eurprd03.prod.outlook.com
 (2603:10a6:803:c5::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 5686453a-ad6c-4222-3dc4-08da66ad819d
X-MS-TrafficTypeDiagnostic: GV2PR03MB8607:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 7IEeSa8CkMJfwrjLpWq51F7eU1uiMbAYyCoRA6YZAxcecVyPiBpLMsPKEevQQ+e0YBNHNfDb5IN9V830MQ4tTX+quf2zLIFZOeSgtcOecZiejQtHpI2d2Jl2w7Rnzs5EnzwwcSeJ6gLmGRZ2PymKmrif1LKNU7pFHdUjhhvhxbM0urECWS9wsICAA3RaE95Ipb9qcd+5Dt+HJNgJa0mSBBZSQsuhc4dp4zz2U28R8SVP7/8qzXo73tU5LteDtdM3c/B1t04tH1ZHa/briMjpd2FrIQB+w32mgDIhvfBX1gTGrboqXo2CbsVcqaYF4fuSGSCNv5lQExpx6iWYnS1UGkttAg5mxq1nC7AM+wVAD23ryRX7+DlMACHaeqe+Y6bJvIAEGa7aZEp3xvhQWHIUXa+VvaKT6OuP1wzZzsuw+Wv6vcb0Jk2br3GopQlpz+PbEhnbyZ63d2s5jmJiCJm8xHIExfGVrQJG39Qv4VzajTfVK6Kyq4zq0yQSZmxChfHLxgfwb2MRbJVnxqJK8hB8C3p3vFUSAzDZ0qyu05TtwhnJgJk9VcUjqiclqu8tvvj/ygL7x/xlX9g/x89pnPJEvhBTy/oVBjYra/CvGMh4H/3CxuaovwgnHLMAof/Zyh/Aozm7lihaFj5/sRdD7KPSaA8dy6gCplQWwd8f+FWsKXvrwT3kCjW1WB4UaXXMkNaH7AyO5tde/VPJsXyFRKXoR+0xEpdtDqUkUxKiel1XdDx963afAOaxt5l6y8Poeh4Wt8elS2+/0nMglfpCpBLFOChqtZVqdUP3baXS8WF574UUSBAaByvz8kMvCjAsXkyK
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR03MB4973.eurprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(366004)(396003)(136003)(39850400004)(376002)(346002)(186003)(38350700002)(66556008)(83380400001)(38100700002)(66946007)(110136005)(316002)(66476007)(36756003)(8676002)(4326008)(1076003)(2616005)(8936002)(86362001)(44832011)(6486002)(478600001)(6506007)(52116002)(107886003)(6666004)(41300700001)(5660300002)(54906003)(6512007)(2906002)(26005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?YBtZYIfuDMm8njTf33RHh9zhfdA1TNMNd5j9MmQgG/fmW8j+UoZrns82AUyB?=
 =?us-ascii?Q?a2jxZyP+IFrgfM9jc8NYeVeiqLcLw64/uIMtlwEWTTX4AXPHIBFhDiVXj4uB?=
 =?us-ascii?Q?lyayGM1T4m7SuIRdi0cC7kUwLyCay5FTQkZT9dnQsXUoEx/bSe/O5mCzIuUx?=
 =?us-ascii?Q?ud80Jh4q9S7e4erqFkbMx1XCF9vlhumhZidMlUjf5mgOIrLzW0v8AkG3gmbJ?=
 =?us-ascii?Q?R7Ek9TgjHPCUR6oHRcO8pa4TbFlFCbp6ryHfIYb+bWQurXGoYy/XS27Sq9I5?=
 =?us-ascii?Q?q5RHkxTmK/YlSQQEy2zW5epddM6YYFoOV8e8N7O9qxx8S+FRtH+7YMgYrOTm?=
 =?us-ascii?Q?/jhktHpkLLLzcIIWsvGAZjcJv9a2uflG8rF/WDVMBoorHrWX/DkPY3LJdoit?=
 =?us-ascii?Q?wBKF/d6k6aQeVxvEq5vsiV0mx4VcnDOzjcC7F4yrjDz8FLqKvnnL9ZoADl9t?=
 =?us-ascii?Q?8jGHTytzckwRBNPKXtG2/gcmM2/h6rCVbMNvHqQRzjmaUdATul3caq8pZHEE?=
 =?us-ascii?Q?+PKVI3n/Db3+OBG4KCfkstFbCIXsRBIU3P5thvWUVmxA/PKDqkmHhY2krMk8?=
 =?us-ascii?Q?oCN5y5CbafPyk/FYIumfZleiYAjbvmr8qRpNhUkeZ0i1Mq0lv/RjrG1IZVdp?=
 =?us-ascii?Q?uf+GIAh8Mn4AFHzPR9haogm74h8/q9fJm4dmOVl7qbGNdZcSY43Hv0pBmIXk?=
 =?us-ascii?Q?9TsXO1KxjH25vw8lh6pjHefV+LfD8VCDcxpDETPHb+JPwSVQsP03jv+6WrAy?=
 =?us-ascii?Q?mRCC4TqX1N7MBCqQ+G+7tDmaCFIiHm2GsguhWDAm0LpBDzPHzVdOwUYOKHLF?=
 =?us-ascii?Q?EW2IeV7TpIhbLkx9m3CmScA7p4Ju3pdi9p8N7NOoZ4ckBrtDDw6ZG79qpEhk?=
 =?us-ascii?Q?Tl298Uz/4vgiIAGoWi7DnTaPk7A5+YR6mTbgonFSrj/XnSeoH4w0MzWxVAW0?=
 =?us-ascii?Q?kqAOoyW1xOIv4wkWixLXSLtu0xVQI3cwtowSyGLYHqqdjivyeBE1CT/KTlNj?=
 =?us-ascii?Q?yocCOFWbaqXFwtxzxWxc+yQq3s+tu7/gAEjkGTxjkly69hckHVrq1p37L0Yo?=
 =?us-ascii?Q?UGO6fPcDNUSXVaU9zaHV68zwrPE+oe3Ri9ahILc07Bapdis3a9ugHpweIYYu?=
 =?us-ascii?Q?5uTkOlih0Tq/mSV/yOITNO3ills5EMC4vw5NFdwn/2BtJo1Se6ZzCBWgdvlX?=
 =?us-ascii?Q?VBnDu1/qs5PScn3ZYi0PcnqffXOyM8eJg/CAx9FRHKrgFp6y1NcWjDHHnptd?=
 =?us-ascii?Q?NdzV0Co0C/KAYD6pY8kk1dC1B05qdWHH+E5Xaj+5Qsfm5Hr/KOUlVVEQNmE+?=
 =?us-ascii?Q?tMpo+iwufFCZn9fOIN7V5V2si5ibBnGyxZd0PSBeC3KfoUUqOpUqWZBcnHhB?=
 =?us-ascii?Q?72xSkhK2wMeXrkn9DNx8pm0U7UlmwXLivJnne5nKow49EiF3ZM+dUGSkn46q?=
 =?us-ascii?Q?nMGSD2jAWR/lqVGQJ+WXhLiDSo4TJ4sxfUyNihsOOXMSPXQ6RIo8pv7HSkIL?=
 =?us-ascii?Q?FqK1kPq9hDklvDb3qwhU7K2mBi/3FBUuTAYaGg2UYWulNkA5CHSUm3pjtC7n?=
 =?us-ascii?Q?10OPfZKE/S9yU6xrNlJae+VtApunfGMWGf8/+OBjylDxgaFAiJztfQ+ri/OO?=
 =?us-ascii?Q?eQ=3D=3D?=
X-OriginatorOrg: seco.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5686453a-ad6c-4222-3dc4-08da66ad819d
X-MS-Exchange-CrossTenant-AuthSource: VI1PR03MB4973.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Jul 2022 22:01:01.7225
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: bebe97c3-6438-442e-ade3-ff17aa50e733
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: CI7OBADJfdOakFawSbD46Xvqt6PlmrzDcI5ujnjmCGPi2N/O7lc9Fg6cJTzkC9KSBFSJkjQadD/73oJZ3Z2gsA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: GV2PR03MB8607
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


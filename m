Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D7D4154FEB4
	for <lists+netdev@lfdr.de>; Fri, 17 Jun 2022 23:02:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1382536AbiFQUfk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Jun 2022 16:35:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35534 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1356351AbiFQUeR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Jun 2022 16:34:17 -0400
Received: from EUR05-AM6-obe.outbound.protection.outlook.com (mail-am6eur05on2065.outbound.protection.outlook.com [40.107.22.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4EDE35C753;
        Fri, 17 Jun 2022 13:34:02 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=LN7zDv+9YKIYxbDmQz0cQOugMCLDYNixtUv18TA9GUFlWX2cRLcaWAYfm3NSvnEFQihWtje7Bb2Z9gbhsVu20lb2Hr0AO59nVRGVpNlSViYcDIYJjFqTkTxSRjQp7aRo2NaBngWGwkFeiSRGh1W58XVBWE7UZLivudXLGoJUkc4MNsa+vlDnW/RUBJEqIHkVzwxakAwze7dX8iuxHU6cO72Q/BJqvc4y53i7PeM3iI9xEYqUmVI3aK2glsWdjNrO7wHpiA+MlNPQc4KxgTaRSD+Agthy1I4cK3wbaE8Ee6+FPCLLmXrjNEMswgPx71gHPsLBgFNmubp/PWlWOZqIUg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=SmNK+rIDleChWzdQJwY9c2TwGYnNr7tRlJcgC6moeL4=;
 b=PDAbDJgG2pKP0g+OSZ3CoxWNp1daNq8gDi9Ya4vZ/aN0KeXYZCRsIy5YFdfCnaZxcDZf8Knxcy1ielEA4qt3wR5dD2tgV0Qu18PhZuUK6qplGl2QsTHjv09Jr2Icl0Owa5kVZ/vimE35hbBCctnpRUpbZFMR4Z37bPDbBk1eNxpvUzgUziEKc3MtXUCyS1yazFOIWsZ6Ml+ikSoid/WhxA216k6X9p67enoug6l2nMBu44Rv6s96Tf8WZ4ost/q/3cIkuqtp1iR07PEDLclGsyUynPX68vF7F4Vmv0W011u4XOi1MX+BquNu9e303oOuTh1VY/VMh3vYCdJbbNx5Zg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=seco.com; dmarc=pass action=none header.from=seco.com;
 dkim=pass header.d=seco.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=seco.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=SmNK+rIDleChWzdQJwY9c2TwGYnNr7tRlJcgC6moeL4=;
 b=uXc9rnE76/DuZsiXYMPj9eTkHi4P3+RhAarB0+tqyz7CYvkIp6vrjEOr37f8fR7aQGxh37X0ZbNHEQB55yA6W/sx2rVFqgIz4TuFOkjZXFKF5vKqyXuSGgQz2B3zhg5RFcumMJ72PDGjfpYr4EX8AmGe1WYDwqM/SddDFhJ7A91KnmE1pUggBCs0dXRxt7sVyVrX2y0X7eNiZnkloXiObetr+VoRC2kKwtU/IRcT8YLQLAvFTLtUG8nIL4PcQRQIIKfO93Px7HEO4i2ltsSbpJ5C0mDjAM4ytmgNOrOR2GUJOU0k6rUytJZN8G7J4fat+XNa4zooGmpw8wBpLakqEg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=seco.com;
Received: from VI1PR03MB4973.eurprd03.prod.outlook.com (2603:10a6:803:c5::12)
 by DBAPR03MB6438.eurprd03.prod.outlook.com (2603:10a6:10:19f::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5353.16; Fri, 17 Jun
 2022 20:33:55 +0000
Received: from VI1PR03MB4973.eurprd03.prod.outlook.com
 ([fe80::d18f:e481:f1fa:3e8d]) by VI1PR03MB4973.eurprd03.prod.outlook.com
 ([fe80::d18f:e481:f1fa:3e8d%7]) with mapi id 15.20.5353.016; Fri, 17 Jun 2022
 20:33:55 +0000
From:   Sean Anderson <sean.anderson@seco.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Madalin Bucur <madalin.bucur@nxp.com>, netdev@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Paolo Abeni <pabeni@redhat.com>,
        Russell King <linux@armlinux.org.uk>,
        Eric Dumazet <edumazet@google.com>,
        Sean Anderson <sean.anderson@seco.com>
Subject: [PATCH net-next 10/28] net: fman: Move struct dev to mac_device
Date:   Fri, 17 Jun 2022 16:32:54 -0400
Message-Id: <20220617203312.3799646-11-sean.anderson@seco.com>
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
X-MS-Office365-Filtering-Correlation-Id: 233221ad-ee1e-4391-b208-08da50a0b295
X-MS-TrafficTypeDiagnostic: DBAPR03MB6438:EE_
X-Microsoft-Antispam-PRVS: <DBAPR03MB64382AD75048EEE3AFD7F47096AF9@DBAPR03MB6438.eurprd03.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 6B3PqJQ4l3kZPipk0hQNE/KTatLpT5jrFso1yqOiAaskTX1yT/RRMWLGfqvzIeOvGDMhxAfl5TYqgFkQV/BeImJr5KWCo08HLRSd61gq2ZFqWA2s9wCLZExM5UwXl+MpKkUtuDCR0EmUMH83lgxAVf+JKBRNAs5Logzyy7qP6nmNQbZn0tIxZZcYV+GetwT7kURIyWEftAFWV6gjdst+E6avAgbrLp6KvOrEeukv9V4EO8yf08a7shHSQQWEzyi5Giw1Hl6T92tDYD9CYB8gr1/jPEflDjdI5IMBxmF8dOjnxpN7LT2mn7Eapqd7Az8HKD/rr7S0W6r4u3fYhM/ecBtt/8dVLCFI2ebCcU9V5JBzAuGwfzaFupjpF2fuIZrAsGVLz6gjRHwHH0fPewAUwXJft8FAEM1UqIKSIfUymETjWsJiyNc7nj+AqO4GcsXC61Cp9DlFAp9JH2aQ2jb0EFA0AdTwFvvtVi3/CNluzeMSFkJnrHEUpWIdT3LwW8QeHR9Od7zndLz/Br0+bHmXAXquxEb26qzfsjW+MZI+ddvL6ly4FjRy/99hnf4g4ifNV1NHdH0a46rhfzRm6U0Fy+4Ry8EFw5J2/iMxjD5kyn6KnYGrTNJSXG3nkP/NAmZ6HKrw+tJPEuDGkVOeGMBfmK9UBAxwblDDwh6fUEGjNh7YmWyedBtC4b0tc9H53Xbdf+rqDvbbkzsisr4ozcvhlQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR03MB4973.eurprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(366004)(54906003)(498600001)(8936002)(110136005)(6486002)(52116002)(2906002)(6506007)(4326008)(26005)(83380400001)(66476007)(66556008)(8676002)(316002)(1076003)(36756003)(66946007)(38100700002)(107886003)(38350700002)(44832011)(86362001)(2616005)(5660300002)(6512007)(186003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?jVCPeyZHky994pYPtoxf+WC4+8kIZG0uLI0XvM5wkBRxZlXFnJxZnfn8rUFU?=
 =?us-ascii?Q?/JUQP2CY4xAyLIMg02zv1BUlGDixrFcuCcpB9d1NmpPpYvUFmVSPEySOvuGc?=
 =?us-ascii?Q?AfNmAmLpYKL/9N0nmbFySY/B7+TS1DdmahK5x4jop/M4gM2tlkWoYV7SB9EC?=
 =?us-ascii?Q?YhlQZnEhj3kYUHExhe6wiymbYtiu9mBmzOWP8fxg6nCyKJhaTS1m5x2r27qP?=
 =?us-ascii?Q?Pk8RRZ7RXnxSEdyS7PbgqsEvaVFWYlvX8oUVcjlu1R9/jVvX8LrsFJV0Wo0D?=
 =?us-ascii?Q?B87d/1slJDGyFh+qGZoPa+iPK3k8KmW8t9HeFpPnU+tQ/78l7bUMj+nbNyS0?=
 =?us-ascii?Q?aWxL1MD/FTXxGwNQFk/BHQG71G+nvevA06gScd0AEla9OMcphqn3N2JKQL5o?=
 =?us-ascii?Q?xFdoXcoD6G15KPFFmyMV9STn4kQzpyftaygCmVcghAqca1iub7l3E2OQj+io?=
 =?us-ascii?Q?Q3DK/9n5mmCITp5HcRpcOGHnMirrFZNKqFKtJWnJzX1kcSfjybpQthCevYZm?=
 =?us-ascii?Q?636LdKEw95D+EBIyDwNbgXO07qVTQJxOD9/xcXlMyujqpYx9b6IDgP1Wk9EK?=
 =?us-ascii?Q?KCelvoyJduvbq9zlVfQ/ENu0p38CFG9w1r0/+T7Bdn+PTMa44flm+M9WNUH1?=
 =?us-ascii?Q?/f4Mm97RCPYr0PYvzhlRaNJ70PmrvUdk4it5oEOkA396IWxEaYH5CliCGNKD?=
 =?us-ascii?Q?U+Qr8HDO3AMnyPht2Se5RXiWj/cAqMYaR7hlTH6LWHC2oVcvNl4M8ltwfFXA?=
 =?us-ascii?Q?ZitFTlRLNG2GPm/XeDo1G0cqpeLLn9uI+Z60mMvYj8U6Q3Zbk3dCZh7RlDd3?=
 =?us-ascii?Q?589+EDwP+ZyihkYDLzRN1Xrs+5ekkLvaKRp66q0OCsGdNzQ7lFii2MxGyPDL?=
 =?us-ascii?Q?Pl4Yv+db91yrlU5XMsp8plyyav2pBwMy7IQykuOWJd61brB/tlWquv3IMpFA?=
 =?us-ascii?Q?tguTqXgOf8Gp7RGXeTdIDA1yYNRAl9P4hMWGNj6jB6sSEDMdH9FTUYh7hsKW?=
 =?us-ascii?Q?CBRwKlvmZUsZwHVjXzl6FqnzTWKxxhAGb5SGeSbcZN3qocYD2Thf34UeIH9I?=
 =?us-ascii?Q?5kd+S3SqOwTJlJHuLcRQ2LXVTVq0vxJElPFsY8xz9awhOfA1GBXtx15dx09S?=
 =?us-ascii?Q?Xl7KW6ZXmga+ERyo8emfXh1qbkMRMjbbeUgi1GOJvkh9CMNzynX9QzDR68bx?=
 =?us-ascii?Q?yh9PaQabIAlxsPqHdjLjWtTTYX/VnAO8kwrBhqokmJMMRl4WXasV4HzYD0Jh?=
 =?us-ascii?Q?hXQNAb2GT0kxYJ7k9T7AED9jxuvHufWOR0lb8ze9u+BvMNYF7FSnXsZgoU57?=
 =?us-ascii?Q?+zeKXPWvM+zKqPrpHFP7xd6uUVOc5O8H4/k8yJbU0uAMSx3rbxtiJ5/q6Wp5?=
 =?us-ascii?Q?L+oIlETazX/jM1dcHlqMNQcM50xov5FY6E3QJpKSccIw2aohe8+EcEnaQxqJ?=
 =?us-ascii?Q?yjS1CAX7cGj2LhpfD36VUOzNueSHpNeg172XszMFea4v8dWei8Sk0m7jtDxd?=
 =?us-ascii?Q?Ec6GwJINrTHPMvJNcRmlDNmk2fYyrVxDbOUgSXnld2T/+RLl0FS+unKsovfc?=
 =?us-ascii?Q?XmBA3VrGsDp8iepPx7KtGOdDq5P73Y58HMTavAyQt2utJ4iJuthh5OwpIaHk?=
 =?us-ascii?Q?3VM19tJziOWtsX2Mln7HcEdu83lKz8XAg9/5tq57QW40+xj7QE3tUwLFEDfr?=
 =?us-ascii?Q?cEAxqWp3wB4uVDH59st/pCpUjNHql/wC+aK10bFQ1XtffyAyWh67ghiwfWPi?=
 =?us-ascii?Q?q1AmzBVYaobBhyWHgq132PhCGVBw+AY=3D?=
X-OriginatorOrg: seco.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 233221ad-ee1e-4391-b208-08da50a0b295
X-MS-Exchange-CrossTenant-AuthSource: VI1PR03MB4973.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Jun 2022 20:33:54.9209
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: bebe97c3-6438-442e-ade3-ff17aa50e733
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: qIN8azaEu9gPtXhFt4UN/F6cJFwjthpilcvdjDG/ITU9i3FgRVK7nqZrTzIS1nxs2lRay5jTE1zXOaQ7MfjECQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DBAPR03MB6438
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

 drivers/net/ethernet/freescale/fman/mac.c | 21 ++++++++++-----------
 drivers/net/ethernet/freescale/fman/mac.h |  1 +
 2 files changed, 11 insertions(+), 11 deletions(-)

diff --git a/drivers/net/ethernet/freescale/fman/mac.c b/drivers/net/ethernet/freescale/fman/mac.c
index 8dd6a5b12922..5d6159c0e1f0 100644
--- a/drivers/net/ethernet/freescale/fman/mac.c
+++ b/drivers/net/ethernet/freescale/fman/mac.c
@@ -28,7 +28,6 @@ MODULE_LICENSE("Dual BSD/GPL");
 MODULE_DESCRIPTION("FSL FMan MAC API based driver");
 
 struct mac_priv_s {
-	struct device			*dev;
 	void __iomem			*vaddr;
 	u8				cell_index;
 	struct fman			*fman;
@@ -57,10 +56,10 @@ static void mac_exception(void *handle, enum fman_mac_exceptions ex)
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
 
@@ -70,7 +69,7 @@ static int set_fman_mac_params(struct mac_device *mac_dev,
 	struct mac_priv_s *priv = mac_dev->priv;
 
 	params->base_addr = (typeof(params->base_addr))
-		devm_ioremap(priv->dev, mac_dev->res->start,
+		devm_ioremap(mac_dev->dev, mac_dev->res->start,
 			     resource_size(mac_dev->res));
 	if (!params->base_addr)
 		return -ENOMEM;
@@ -244,7 +243,7 @@ static void adjust_link_dtsec(struct mac_device *mac_dev)
 	fman_get_pause_cfg(mac_dev, &rx_pause, &tx_pause);
 	err = fman_set_mac_active_pause(mac_dev, rx_pause, tx_pause);
 	if (err < 0)
-		dev_err(mac_dev->priv->dev, "fman_set_mac_active_pause() = %d\n",
+		dev_err(mac_dev->dev, "fman_set_mac_active_pause() = %d\n",
 			err);
 }
 
@@ -261,7 +260,7 @@ static void adjust_link_memac(struct mac_device *mac_dev)
 	fman_get_pause_cfg(mac_dev, &rx_pause, &tx_pause);
 	err = fman_set_mac_active_pause(mac_dev, rx_pause, tx_pause);
 	if (err < 0)
-		dev_err(mac_dev->priv->dev, "fman_set_mac_active_pause() = %d\n",
+		dev_err(mac_dev->dev, "fman_set_mac_active_pause() = %d\n",
 			err);
 }
 
@@ -316,7 +315,7 @@ static int tgec_initialization(struct mac_device *mac_dev,
 	if (err < 0)
 		goto _return_fm_mac_free;
 
-	dev_info(priv->dev, "FMan XGEC version: 0x%08x\n", version);
+	dev_info(mac_dev->dev, "FMan XGEC version: 0x%08x\n", version);
 
 	goto _return;
 
@@ -383,7 +382,7 @@ static int dtsec_initialization(struct mac_device *mac_dev,
 	if (err < 0)
 		goto _return_fm_mac_free;
 
-	dev_info(priv->dev, "FMan dTSEC version: 0x%08x\n", version);
+	dev_info(mac_dev->dev, "FMan dTSEC version: 0x%08x\n", version);
 
 	goto _return;
 
@@ -446,7 +445,7 @@ static int memac_initialization(struct mac_device *mac_dev,
 	if (err < 0)
 		goto _return_fm_mac_free;
 
-	dev_info(priv->dev, "FMan MEMAC\n");
+	dev_info(mac_dev->dev, "FMan MEMAC\n");
 
 	goto _return;
 
@@ -507,7 +506,7 @@ static struct platform_device *dpaa_eth_add_device(int fman_id,
 		goto no_mem;
 	}
 
-	pdev->dev.parent = priv->dev;
+	pdev->dev.parent = mac_dev->dev;
 
 	ret = platform_device_add_data(pdev, &data, sizeof(data));
 	if (ret)
@@ -569,7 +568,7 @@ static int mac_probe(struct platform_device *_of_dev)
 
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


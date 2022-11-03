Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 43B35618A51
	for <lists+netdev@lfdr.de>; Thu,  3 Nov 2022 22:10:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230395AbiKCVKd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Nov 2022 17:10:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33774 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231510AbiKCVKB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Nov 2022 17:10:01 -0400
Received: from EUR02-VE1-obe.outbound.protection.outlook.com (mail-eopbgr20049.outbound.protection.outlook.com [40.107.2.49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B38E313F58;
        Thu,  3 Nov 2022 14:08:28 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=B+Pe9sgUx25qtqTNZJZ7cUbSQK0VwI5hJ1UWWDarvdR3U5X5OfQRMZRheDluMHkoJ3Hd5rIjD2RssNxZqkj6to3CyGqkIRuS5zH017h9qu/WjpAsEVuzTQbQ1u5Xh61g5Ax7nyefZ8KQn8P49RI0r/g4Bdt5zIWKSmX3N4QHx+C0xpJtgyAEZFGkEl/1aQTb0Ci/xmOmFAXQJSsLhLNmgmRlgskgQoHZRI7CKkQMwbm4bpe/8+0xVbr846NqtoHMpKJca3VXqiRo0U8cmcUxumYljc2Xlq73hiRy9NRT1eMUdIdiQo+IyrknEccqZBgNe5sjOPuztiT/snLsYwGJgw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Wv+dx9OXnb81iE7XDcAOy4whLhL4bBbPl11NBAZi+78=;
 b=cLzLGmcg8ZH1VECaCk3ksMgtvz6HUc6uG7Oqqfahp8rdQFzigl7oXuFTshxKsJg3jYlWnfx+Bgkpmo/B0j2QhXF5LsVO4wUF5Y+fhdxwTq52fesgy3iCqLjLEnSpsUmVB+s+AD4Rr2SwfrTtwOKV2xPhfce6DQEuqyzM74FnX0diXWn21tB211LQt6zPtZd7HJjdRrUP4tkb/Q4Xif94mwpNrJ6QiUw+D5m5HNho5T4LmVn6fCVbnqmHJWh4AfPftMiwJxJb0SfXC1eGWWovWyRZhcF4m81SD7IIcc5cUF7dCnydiUA1qxR2xwMZ6KkG7ajKZSfkZPlDyANFLGn+Kw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=seco.com; dmarc=pass action=none header.from=seco.com;
 dkim=pass header.d=seco.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=seco.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Wv+dx9OXnb81iE7XDcAOy4whLhL4bBbPl11NBAZi+78=;
 b=FBOvMLMsGop/06ToggkcUck8BiwsW3XA/T3gFPwEtMfcBLXr9fQGdkePTU4kIxoK+dUyHahyR8Yr7fNcHV6w4AQnU/ORB/0cstPDRl5xiAavczW03zARL2jX8fufrYjjJGqs1FgZUCpqIrIwPHLpM94rOqWJsdzCSgmDzDgtPZdTN52JWDD1nq0QSWqQdFaTBq6jYUJa4CZvgTvUr+4GpY11I74ftMA0g5OdqjMT2eLDWBFBr3BV5fdXMH1tR5s7FFI0lz7e6IOVJiVoB3eX4kKPD8hklb0wFBdVZfkSh7GxBUHMiw2xocZWFfr1Egw1HKvSd8Dim9H8QyWeXimd9g==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=seco.com;
Received: from DB7PR03MB4972.eurprd03.prod.outlook.com (2603:10a6:10:7d::22)
 by PAXPR03MB7746.eurprd03.prod.outlook.com (2603:10a6:102:208::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5769.15; Thu, 3 Nov
 2022 21:07:21 +0000
Received: from DB7PR03MB4972.eurprd03.prod.outlook.com
 ([fe80::e9d6:22e1:489a:c23d]) by DB7PR03MB4972.eurprd03.prod.outlook.com
 ([fe80::e9d6:22e1:489a:c23d%4]) with mapi id 15.20.5791.022; Thu, 3 Nov 2022
 21:07:21 +0000
From:   Sean Anderson <sean.anderson@seco.com>
To:     Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>, netdev@vger.kernel.org
Cc:     Vladimir Oltean <olteanv@gmail.com>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>, linux-kernel@vger.kernel.org,
        Andrew Lunn <andrew@lunn.ch>,
        Ioana Ciornei <ioana.ciornei@nxp.com>,
        Madalin Bucur <madalin.bucur@nxp.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sean Anderson <sean.anderson@seco.com>
Subject: [PATCH net-next v2 11/11] [DO NOT MERGE] net: pcs: lynx: Remove non-device functionality
Date:   Thu,  3 Nov 2022 17:06:50 -0400
Message-Id: <20221103210650.2325784-12-sean.anderson@seco.com>
X-Mailer: git-send-email 2.35.1.1320.gc452695387.dirty
In-Reply-To: <20221103210650.2325784-1-sean.anderson@seco.com>
References: <20221103210650.2325784-1-sean.anderson@seco.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BLAP220CA0002.NAMP220.PROD.OUTLOOK.COM
 (2603:10b6:208:32c::7) To DB7PR03MB4972.eurprd03.prod.outlook.com
 (2603:10a6:10:7d::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DB7PR03MB4972:EE_|PAXPR03MB7746:EE_
X-MS-Office365-Filtering-Correlation-Id: 413f4757-3282-4121-b8c4-08dabddf65d5
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: cM8u1QohOB+psZmFMnEWXUPPsynq7WSv6dSd8EIY0rYxuBiquNeqJbPyv+gMW2sX9apkR50ivgMKKoBIBZyq5ad+R++lIsyyHbELvQ6XuUYQXEADc0IwCHqHJRoV8geFvNsZbZK8kr+o5MqRm5cThjExLnMwShUHrGn/5lD5jLxQ4VVDFlux/aNfkTQMN2gsr8wj7o0AuqQrlwwwbu96kSbG5eb5xkLzy4RFVavyPWZpmZBli0dFMT8ibcXcn0ajSJVCZiWnfr5VlYkvs5FjetsPlKTrw9cnJqFWh4J7unzXF2CLZDjDmRlPtmNhkdq9slXBeIaNVEb3riDrFKRG1urZDR11y1KGrwgtzJMyFWD/I84l2uJ4iQjbYgoFimMetaCQoFEkVlECKsj28eJhkjRjXpUTZVAmf5kFFrbp2omwNTmfIf+i/7stve13vhi5qES+h61fhnhulPoq3ETkWiiPf2g/0+tVxNtmryb0vnmIhb0a6WwUtiiyrI/uH8oYjnnFpy1SlDI42rJZbuqX06y6KWGJMOI47LXlBHpKqslWRF0nuyQ99JrRqsGTwf8TovQu3waYxsEfBzXWpNuTjCEX/tIclrBmoc0WXgD268CdQOytQISsvhqPJNWzS3HFJAdpSm+FINfMRJvMuvBMDBGtveRMx5MZsAKx6LCUeLsXiE4HIzND6JJwFvLTS67DnoPbTlILCLBHvpIUaGRSxdtVEvyDPen2GEjUkwm2DYxQGB028w7A6z0rJV7+Gkwi
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB7PR03MB4972.eurprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(136003)(366004)(39850400004)(376002)(346002)(396003)(451199015)(8936002)(86362001)(36756003)(107886003)(478600001)(6486002)(44832011)(5660300002)(2906002)(52116002)(26005)(6512007)(6506007)(1076003)(38350700002)(38100700002)(186003)(83380400001)(2616005)(7416002)(41300700001)(6666004)(66946007)(66556008)(4326008)(66476007)(8676002)(316002)(54906003)(110136005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Hu8ZkmU1BxS9k4YqEIIN3vkPNlDk/lNIOKOdExCNuRZoO7rfL2qsFeHPJ5wL?=
 =?us-ascii?Q?eymijk+wywqtz1zyXLDCyz8VfOHEM0bvh6GWgaMiggs+a84nkxqty777Ylid?=
 =?us-ascii?Q?tdX9tr0udJMqxXkivLtTlUJ6c5VE6cJIMswTMpbPfhrFhmHLDx7PdHXpzEn4?=
 =?us-ascii?Q?8iI07W1fxo80DWy6+JGyN17VSPhNlcLNsFm98KSAL1oP3QKdEJ0vtvPV3NvY?=
 =?us-ascii?Q?1LqQnXJ82dgVaRFkgtYIO+K2HzE7UdBxU0yKJTbT3U8P3mlhA6rDnWBOfOvn?=
 =?us-ascii?Q?jL7rozxtfZVm1+9/Rh7zFV3u81qWMGmseXo+UYYszRThd0qFWWSZHiOoDiqX?=
 =?us-ascii?Q?tLPV4sSiDnlrHwSyKDS2GyYpATHns9YhKfxC+XGbEjCojsHPWJQxsivPfVKg?=
 =?us-ascii?Q?qVrKdWx7kaWaUDsvsMbjaYnjalA7RKQI7tE1b0qioCdyg/S+xXOLMHhQLeYU?=
 =?us-ascii?Q?fndNWdV5trgFr+lcp7V1Oy296AgHvogaTgKRYEbMhTL+TK6i0Xdikunn9mTM?=
 =?us-ascii?Q?T9ip8Z4xPTrmXHINnIyfqI2f13VaUQ3PsqsHFJMWg5FqcZzjk/fnw5HmG6S3?=
 =?us-ascii?Q?xKnQKzHAncBmFZpy30nvQJClb7q4vr8MVGg6n6f58CwQQOKbskomDfSSitCp?=
 =?us-ascii?Q?zlf/BLVLZrXvlIVhOUTTs0si5f96a+Zsjkwu4+fHkKUvc9jnahYGWsA3GFRH?=
 =?us-ascii?Q?tlNrvcA2ySsbMji14JxnQvTvUwzDoDhhXEt+JEsUE+O4T8x9+uSZYQqa1SN0?=
 =?us-ascii?Q?GcTPb0xXXSBi5V9WTxD1K/tK3VHR+yCssd/AP7SHvwAYz7iCOTbKVdxRLbZn?=
 =?us-ascii?Q?dyY8d4x4eB25FsVpVeTb8a5Q3EPyRBhzvnMhdtr1/7s38yeuMg5H8c9PTamM?=
 =?us-ascii?Q?QQUG/k4Ve1IyyCSE8gqqqdoziT4E/WFAHXBH02t2qQEm5yiWa8sVMXlYRml3?=
 =?us-ascii?Q?5eugS6ux8jy00rFRlYqdksqIgrhUeupgLfw6nY+s5WGuHRxdYyaUFWb0mlbd?=
 =?us-ascii?Q?THFxaBVTJtnSrapd2pEWt2GJA5XaT3lD87QBeB30l4PPL4mQNcH4DwpJB9qy?=
 =?us-ascii?Q?ekW4dS2p62/TqKEMMToumQvRGKHbuWf7236ep2gENsET/yRvrrzsPGHEw5Pk?=
 =?us-ascii?Q?+RpuB2dHJbZ5to1oxDNKVg8wVoIN0cbsqWBOQAsWLvBwAdOXpiqkaDVH7JTC?=
 =?us-ascii?Q?OI/c8esvFh09ro+kBT4a9rr0hhfSPTxFvhgXO5YdoALjL7v7SMmQjtFVSjwz?=
 =?us-ascii?Q?KceghaRqx1OHZx5HPHuHbTZpU1NU5rcICmGyUNHUUN2dUXpgRkmhSWklsghx?=
 =?us-ascii?Q?irjSRK3XX3ZBLFcEHwJduGNI4fZQEyL762nMxxZ3EYYN9yOQmuQIM2P/WAGz?=
 =?us-ascii?Q?iNTL9ZFAQY+kUduyE8kVrUUPg5nDNf5Qwv7Fh47WbnSrks7nt++HFfjfP5qZ?=
 =?us-ascii?Q?vDRCczFr7ktnnr1mjjSSoisSkOdZKGnPH8JlEp4kVBwXSSfJ6wOopfTXEU41?=
 =?us-ascii?Q?weLQN6fKv60E/xZfwR+dykhNz4jUl720qVaoWxsKw4hIVoUPB/8ND9DUM5z/?=
 =?us-ascii?Q?SD3y42RJuTWn3c4ju8e0ZNDRGEv8YhwlUKGZrpQtY8xAYKq5k/kYh+9ObNMN?=
 =?us-ascii?Q?uQ=3D=3D?=
X-OriginatorOrg: seco.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 413f4757-3282-4121-b8c4-08dabddf65d5
X-MS-Exchange-CrossTenant-AuthSource: DB7PR03MB4972.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Nov 2022 21:07:21.2083
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: bebe97c3-6438-442e-ade3-ff17aa50e733
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: tpH8wjxme3cFeVFRCMOEnZgGMjupaRInLDPX/iv/qlR6sG/dE/g96D9vqiGOzneI2iJCN0AGPp5GaGLD4jwYeA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PAXPR03MB7746
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

As all former consumers of non-device lynx PCSs have been removed, we
can now remove the remaining functions retained for backwards-
compatibility.

Signed-off-by: Sean Anderson <sean.anderson@seco.com>
---

(no changes since v1)

 drivers/net/pcs/pcs-lynx.c | 51 +++++---------------------------------
 include/linux/pcs-lynx.h   |  5 ----
 2 files changed, 6 insertions(+), 50 deletions(-)

diff --git a/drivers/net/pcs/pcs-lynx.c b/drivers/net/pcs/pcs-lynx.c
index 3ea402049ef1..df9e8ad3f728 100644
--- a/drivers/net/pcs/pcs-lynx.c
+++ b/drivers/net/pcs/pcs-lynx.c
@@ -38,15 +38,6 @@ enum sgmii_speed {
 };
 
 #define phylink_pcs_to_lynx(pl_pcs) container_of((pl_pcs), struct lynx_pcs, pcs)
-#define lynx_to_phylink_pcs(lynx) (&(lynx)->pcs)
-
-struct mdio_device *lynx_get_mdio_device(struct phylink_pcs *pcs)
-{
-	struct lynx_pcs *lynx = phylink_pcs_to_lynx(pcs);
-
-	return lynx->mdio;
-}
-EXPORT_SYMBOL(lynx_get_mdio_device);
 
 static void lynx_pcs_get_state_usxgmii(struct mdio_device *pcs,
 				       struct phylink_link_state *state)
@@ -322,57 +313,28 @@ static const struct phylink_pcs_ops lynx_pcs_phylink_ops = {
 	.pcs_link_up = lynx_pcs_link_up,
 };
 
-struct phylink_pcs *lynx_pcs_create(struct mdio_device *mdio)
+static int lynx_pcs_probe(struct mdio_device *mdio)
 {
+	struct device *dev = &mdio->dev;
 	struct lynx_pcs *lynx;
+	int ret;
 
 	lynx = kzalloc(sizeof(*lynx), GFP_KERNEL);
 	if (!lynx)
-		return NULL;
+		return -ENOMEM;
 
 	lynx->mdio = mdio;
+	lynx->pcs.dev = dev;
 	lynx->pcs.ops = &lynx_pcs_phylink_ops;
 	lynx->pcs.poll = true;
 
-	return lynx_to_phylink_pcs(lynx);
-}
-EXPORT_SYMBOL_GPL(lynx_pcs_create);
-
-static int lynx_pcs_probe(struct mdio_device *mdio)
-{
-	struct device *dev = &mdio->dev;
-	struct phylink_pcs *pcs;
-	int ret;
-
-	pcs = lynx_pcs_create(mdio);
-	if (!pcs)
-		return -ENOMEM;
-
-	dev_set_drvdata(dev, pcs);
-	pcs->dev = dev;
-	ret = pcs_register(pcs);
+	ret = devm_pcs_register(dev, &lynx->pcs);
 	if (ret)
 		return dev_err_probe(dev, ret, "could not register PCS\n");
 	dev_info(dev, "probed\n");
 	return 0;
 }
 
-void lynx_pcs_destroy(struct phylink_pcs *pcs)
-{
-	struct lynx_pcs *lynx = phylink_pcs_to_lynx(pcs);
-
-	kfree(lynx);
-}
-EXPORT_SYMBOL(lynx_pcs_destroy);
-
-static void lynx_pcs_remove(struct mdio_device *mdio)
-{
-	struct phylink_pcs *pcs = dev_get_drvdata(&mdio->dev);
-
-	pcs_unregister(pcs);
-	lynx_pcs_destroy(pcs);
-}
-
 static const struct of_device_id lynx_pcs_of_match[] = {
 	{ .compatible = "fsl,lynx-pcs" },
 	{ },
@@ -381,7 +343,6 @@ MODULE_DEVICE_TABLE(of, lynx_pcs_of_match);
 
 static struct mdio_driver lynx_pcs_driver = {
 	.probe = lynx_pcs_probe,
-	.remove = lynx_pcs_remove,
 	.mdiodrv.driver = {
 		.name = "lynx-pcs",
 		.of_match_table = of_match_ptr(lynx_pcs_of_match),
diff --git a/include/linux/pcs-lynx.h b/include/linux/pcs-lynx.h
index ef073b28fae9..f8fe134c63e5 100644
--- a/include/linux/pcs-lynx.h
+++ b/include/linux/pcs-lynx.h
@@ -10,12 +10,7 @@ struct device;
 struct mii_bus;
 struct phylink_pcs;
 
-struct mdio_device *lynx_get_mdio_device(struct phylink_pcs *pcs);
-
-struct phylink_pcs *lynx_pcs_create(struct mdio_device *mdio);
 struct phylink_pcs *lynx_pcs_create_on_bus(struct device *dev,
 					   struct mii_bus *bus, int addr);
 
-void lynx_pcs_destroy(struct phylink_pcs *pcs);
-
 #endif /* __LINUX_PCS_LYNX_H */
-- 
2.35.1.1320.gc452695387.dirty


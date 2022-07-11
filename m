Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0B7665707FA
	for <lists+netdev@lfdr.de>; Mon, 11 Jul 2022 18:07:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230150AbiGKQHB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Jul 2022 12:07:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57092 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231829AbiGKQGl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 Jul 2022 12:06:41 -0400
Received: from EUR05-AM6-obe.outbound.protection.outlook.com (mail-am6eur05on2059.outbound.protection.outlook.com [40.107.22.59])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C427C77A53;
        Mon, 11 Jul 2022 09:06:05 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ayShGProG0OxqeiVBuD4GPYjttDo9XL2nMPndo9GykZCTQ9msSDKhDv+iSVR8TOLCsyAgL/6dbYzsJDwNm5KgJlJ5p3WHCcXpcyfxJ7bdA+K3rJHYIPJo8NZX+Y4j2/4yOA/3S/cCsiixIUdAdp8aqEhYoUbLTx9zNxp8alnYk8EuUWJOJ8PQslaWp/xaqS6axw1nTkPj8wGgHgP5lHQfGdQ4qy0w/fgtnBw3WK5ZUnsGb/pZGQ/VQA5XnVF7ZsSGGlLlKTv1QIfXFbQcVa6JEk3xfEdPHG+wQnkYCeQnBuFnFcffkhLVRDalA5PSQVP1u5gqgpULstP/QbYD/Cq6w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=QsnF6KwrnOBQj3Vyo4Ii1tIjjSDkIAsMrXwa5Ec/fSs=;
 b=juYAJmHKC1THICnMakvKJnks3NfqIjMbM2LFS/x0a5h7nU2/hqLwqY5HxlyHyaOVdAmS/Qercoi8vWTucfqedrp+I8yOYt7wbN+0M5wKATpOXCindKyYPaQA3hSSp8pgIBYmRm/MrWbRmrDV+0BmHEOcQmXscY7dZm9gbRhD14CVg+Qev+oF0wgLeYIPriuLcWc2Es57UfvkHf1UZLYa/7tAWGH6ThQjCQuO8+3VV5NtbS+7WQMrslnOmWcDn+aiFiWLGEY5MmheeS1pa5CgmIUgF2S6bNWe4NuiTog4pLVsUtFzutHCAqnvnS0aElhHDDib3o2lWJP5h2wr8SYU3A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=seco.com; dmarc=pass action=none header.from=seco.com;
 dkim=pass header.d=seco.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=seco.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=QsnF6KwrnOBQj3Vyo4Ii1tIjjSDkIAsMrXwa5Ec/fSs=;
 b=iKkVQjrCP/Swuyg39NpV+TLduKUOO2W7pF2t10itlQia3X4HYLpodPwrEXNspid2C4cPaUNcPDV7QklWDU8qxccwnvVFmAq7xYIPk6todN53z3Lc6Trq3ZMbX4wHG7/p0E/sI+nKusIitGX6CDNkegZSEvXKXcSt6hnt4uSLFgCg1cH2fdlntI9PPv0oINvGraEtAvf9mHPiTYBglxIQLPBb1ZtVRbxZpbGtZ6hs7gxTZelPMqQ6c+XLBVEbDzUpEqvOQ4hZX4J2YVtIz3rd+zJBo23HgV2eiygYVht65XaqD/Q3zV4VlgwCGTkJI2eOiZbcTHwf3d6+5A0fVaLvNg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=seco.com;
Received: from DB7PR03MB4972.eurprd03.prod.outlook.com (2603:10a6:10:7d::22)
 by DB7PR03MB5113.eurprd03.prod.outlook.com (2603:10a6:10:77::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5417.26; Mon, 11 Jul
 2022 16:05:58 +0000
Received: from DB7PR03MB4972.eurprd03.prod.outlook.com
 ([fe80::757e:b75f:3449:45b1]) by DB7PR03MB4972.eurprd03.prod.outlook.com
 ([fe80::757e:b75f:3449:45b1%6]) with mapi id 15.20.5417.026; Mon, 11 Jul 2022
 16:05:58 +0000
From:   Sean Anderson <sean.anderson@seco.com>
To:     Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>, netdev@vger.kernel.org
Cc:     Jakub Kicinski <kuba@kernel.org>,
        Madalin Bucur <madalin.bucur@nxp.com>,
        "David S . Miller" <davem@davemloft.net>,
        Paolo Abeni <pabeni@redhat.com>,
        Ioana Ciornei <ioana.ciornei@nxp.com>,
        linux-kernel@vger.kernel.org, Eric Dumazet <edumazet@google.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Sean Anderson <sean.anderson@seco.com>
Subject: [RFC PATCH net-next 9/9] net: pcs: lynx: Remove remaining users of lynx_pcs_create
Date:   Mon, 11 Jul 2022 12:05:19 -0400
Message-Id: <20220711160519.741990-10-sean.anderson@seco.com>
X-Mailer: git-send-email 2.35.1.1320.gc452695387.dirty
In-Reply-To: <20220711160519.741990-1-sean.anderson@seco.com>
References: <20220711160519.741990-1-sean.anderson@seco.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MN2PR16CA0056.namprd16.prod.outlook.com
 (2603:10b6:208:234::25) To DB7PR03MB4972.eurprd03.prod.outlook.com
 (2603:10a6:10:7d::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: d362e91c-b6e4-4b78-4130-08da63573e55
X-MS-TrafficTypeDiagnostic: DB7PR03MB5113:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: y+DZYecDp6h3zLny8JuVdaZGd3sjyXJP2gUU4w26QxPPv/AzHoGlP+BBsyloizvilg7Xwg/1KS4ug+pORKRkEJpfesB0G78F+xyep39aHz0ctXtImgOOdGyCiKaQ3nXEWiEuTChyHy6vq0vUAFQAjymSs+DA7MoiSnS7L6wDrvwWiBiOPuTp9R+ZDKFUK7GsyxpLLwN/3s2GdRjqP+kNrnIaHW2cAj4eDELVCsdqfqCH/lImocXnETaI/xMuuAnASj21XTOVoBWxvmC3M+Dh4uEerWYSe+doINXMd5S6J+4YcNw61BsLXu5+ueX1yVM/HNjUazc/rWdLpCph4eFT7LSrOEz1qK6yBaz2STFY8ZMC4ynOu149B2MF5o6fx7r1NbelQywZMP9TnLWD6BCRTucrukFE0rw8HNI4SmtoA3294PMIIm+/kWFyBIcQJVr3YkocN4RNdCqr9zePI4T0Oycbahw/6U1+xzB3vuxwpxPryKTtTBY/gaJH4epiVQwSw1lapghPZcUnYc21PLrtydiKyhG04f1wD+Pc/xr0O4+w3l/7p1MWmzmxpOd6p5L+y3ICbnChD98aXUHc/i61kDr7qfxPSqZ1U9QXZsmIOBT/34fyD7sI6//JrtkrFplTLyL5m8mMWsY9+xx7r0XmgpYobnrbgzmBTyr5+W9kQNOzxk6o+8FahvvbMNdnMSI/v08ebIG7xpUKaFSK06m/dJadhQB6zK22F7gbKLqDIS8itWWkb8yMlzD7Kcu6wlodShsEi40hOqbgHHroeddL126naPiHOddZCqbZU0TwigHzwecbsnwD7mgRON4y+Vdn
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB7PR03MB4972.eurprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(346002)(136003)(396003)(376002)(39850400004)(366004)(83380400001)(86362001)(38350700002)(66946007)(38100700002)(4326008)(8936002)(66556008)(66476007)(8676002)(36756003)(6512007)(316002)(54906003)(5660300002)(44832011)(6666004)(7416002)(2906002)(6506007)(41300700001)(26005)(6486002)(52116002)(478600001)(110136005)(107886003)(186003)(1076003)(2616005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?iU0KyZ+o7gDACzP8i04Dy1KujA5OYURdic7C2zC3P9rO3eM9Bp/d09UKUUlt?=
 =?us-ascii?Q?NcH0EGuTY7nnhb6XfmNbSdy7Quc33noE6gPngmUK3hFMZsiEtwU7G3hlkL48?=
 =?us-ascii?Q?jrC60/F7We6W8AlRRDg/9cu/zyKyZ3u/UUWHBO76U3Suoh9Qv6On/SUrftrI?=
 =?us-ascii?Q?72KYAZJPSViRaLJi3AwKQsTmxqtr70AsXCc4Zhe302Ts1XvrCpJzIhPmkTIu?=
 =?us-ascii?Q?WEqgTqT330k7ny+EDNDTxnyTrx5DjQPHEEHNABQD2eUwsmQJdpo9/Gj7MVch?=
 =?us-ascii?Q?s8AwishRTeCrByEUcglPCD1LkA91/Nl+7JEIhrl9H8JD9F73nukjkDPN5Ud7?=
 =?us-ascii?Q?3fYl2nf/4pr2MmlQ4pd74p1gwpUjU5odZ9OYBOqOnuJIGKeHBKHoTC6715PZ?=
 =?us-ascii?Q?p8rInL233DqN8yz8nSpf1Nd7gASwEb7sLbrDYx5/XIXhtLJHC4TiejMqT3qG?=
 =?us-ascii?Q?Z5EWOEW99ggre6LG8e3224ITNogayi1e7lc13zMjgtYiRW5q2dWPFylbC5y6?=
 =?us-ascii?Q?8sYgMbp+YP0D62XbpwzmspPjo58egHgALYvQL8TLlbFkQVpYfkXHKI8Jb4Ry?=
 =?us-ascii?Q?ifJuq3pX1rCjRt0L3XGyXOx+CF63wxgt15hMDy26RfRR8jFy5yFYO3TiOUCs?=
 =?us-ascii?Q?HDVbPIcJ+YTc8gTJWAJOXwiXT+iryOSZ4Ssex8mcUA2QFTpRTvciDzuhe8qG?=
 =?us-ascii?Q?Dh6GF5arar29VSVF4qsFmmA5JdvaeSAsHQiOxfyqpJ+fcQTBtQ0P47fzvCgF?=
 =?us-ascii?Q?5I2DzGgEnyM4o1PT6eInVfnY0PlmhjAC+HI4U2DZvLcJsMtG7MATbujhdAGi?=
 =?us-ascii?Q?NOC+dAo7RBVge0EcvqvXFovCdTOz68Z3zbhZ9P75WHpsiWvGlqCz9EzmGY3N?=
 =?us-ascii?Q?Z9G2XaUeQNqGp6jZOCBzInxoOlB89PhcbKMNTKQy4ruGn84nzQvydmUQXc9x?=
 =?us-ascii?Q?UDzV1VFGIB+g2mfM7fYwLgbW6s9umfYOSRPWlhFkRwPQRKTujTZPBZYYSluo?=
 =?us-ascii?Q?0z7CMcL4IFVAXvAMfff76YNvX2okV6xWf2S4Lv0Nb5mLam5D+Pxq9Jp7ZJfu?=
 =?us-ascii?Q?cQ+FR6dOWnbnCjEAfbf9NOl0vYdtzCAde1IqZx2zrxvyQZvbLaAUR/75dZlW?=
 =?us-ascii?Q?YalhAKz+FRKZ0BlfQvkfS12AvR5+DU6w1DCxEV4DP7SimtMRonNwtP/EPv1+?=
 =?us-ascii?Q?S5FDjWK4aDDZtp/bGRl66qs6KMvdPKSL2j5JAfdDTWHWb2Sy9fgAr2skDFZQ?=
 =?us-ascii?Q?co0UGLT4j3FxpUV+egMOsQa9WJ3yxfPONfiGhlFuDIazRdwsuY1fLnh/vyPG?=
 =?us-ascii?Q?dctTolIMPmEfrHudKagidP0p93mBbydLABLx76AgSzzgYq7HOHMAfVwd1CcK?=
 =?us-ascii?Q?fbtEP7+RRgRVUQ1tgO0upo2ZxJbv3GQmgKzCg8aF8QDoqot+udzjMPJAwiHa?=
 =?us-ascii?Q?rR4lE0Na6ZPljAPx0gox+2yGuccYdXaJvN+S50FTyNcF9ttFi2XxiCRlExVe?=
 =?us-ascii?Q?iqggAJPQFWZcyFSAMb+MLJkOyle2F+M0sy22Jgona9RN21gYDwNTU0K7GvGu?=
 =?us-ascii?Q?gzX2x4eSWoDyh/c/EG2ZOcVLSAI3j8YXHTkrrqT4rpsuB3HFlOW+9an+fkk9?=
 =?us-ascii?Q?Zg=3D=3D?=
X-OriginatorOrg: seco.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d362e91c-b6e4-4b78-4130-08da63573e55
X-MS-Exchange-CrossTenant-AuthSource: DB7PR03MB4972.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Jul 2022 16:05:58.8706
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: bebe97c3-6438-442e-ade3-ff17aa50e733
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: v9belI9yBAh7ol7UZ1jO4Lm2seG/6J3Jn9juLC/zofgsRSy+X2oynGAaf8lETRgaB4M1nWyTfHL3ZqvEMFEf8g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB7PR03MB5113
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Now that PCS devices have a compatible string, we no longer have to bind
the driver manually in lynx_pcs_create. Remove it, and convert the
remaining users to pcs_get_by_fwnode.

Signed-off-by: Sean Anderson <sean.anderson@seco.com>
---
This requires that all PCSs have a compatible string. For a reasonable
window of compatibility, this should be applied one major release after
all compatible strings are added.

 .../net/ethernet/freescale/dpaa2/dpaa2-mac.c  | 27 ++-----------------
 drivers/net/pcs/pcs-lynx.c                    | 19 -------------
 include/linux/pcs-lynx.h                      |  1 -
 3 files changed, 2 insertions(+), 45 deletions(-)

diff --git a/drivers/net/ethernet/freescale/dpaa2/dpaa2-mac.c b/drivers/net/ethernet/freescale/dpaa2/dpaa2-mac.c
index d8b491ffa4db..1c1cd935ec1d 100644
--- a/drivers/net/ethernet/freescale/dpaa2/dpaa2-mac.c
+++ b/drivers/net/ethernet/freescale/dpaa2/dpaa2-mac.c
@@ -247,32 +247,9 @@ static int dpaa2_pcs_create(struct dpaa2_mac *mac,
 			    struct fwnode_handle *dpmac_node,
 			    int id)
 {
-	struct mdio_device *mdiodev;
-	struct fwnode_handle *node;
-
-	node = fwnode_find_reference(dpmac_node, "pcs-handle", 0);
-	if (IS_ERR(node)) {
-		/* do not error out on old DTS files */
-		netdev_warn(mac->net_dev, "pcs-handle node not found\n");
-		return 0;
-	}
-
-	if (!fwnode_device_is_available(node)) {
-		netdev_err(mac->net_dev, "pcs-handle node not available\n");
-		fwnode_handle_put(node);
-		return -ENODEV;
-	}
-
-	mdiodev = fwnode_mdio_find_device(node);
-	fwnode_handle_put(node);
-	if (!mdiodev)
-		return -EPROBE_DEFER;
-
-	mac->pcs = lynx_pcs_create(mdiodev);
-	mdio_device_free(mdiodev);
+	mac->pcs = pcs_get_by_fwnode(dpmac_node, NULL);
 	if (IS_ERR(mac->pcs)) {
-		netdev_err(mac->net_dev, "lynx_pcs_create() failed\n");
-		put_device(&mdiodev->dev);
+		netdev_err(mac->net_dev, "pcs_get_by_fwnode() failed\n");
 		return PTR_ERR(mac->pcs);
 	}
 
diff --git a/drivers/net/pcs/pcs-lynx.c b/drivers/net/pcs/pcs-lynx.c
index bfa72d9cbcf9..f4a70a1a73fe 100644
--- a/drivers/net/pcs/pcs-lynx.c
+++ b/drivers/net/pcs/pcs-lynx.c
@@ -376,25 +376,6 @@ static struct mdio_driver lynx_pcs_driver = {
 };
 mdio_module_driver(lynx_pcs_driver);
 
-struct phylink_pcs *lynx_pcs_create(struct mdio_device *mdio)
-{
-	struct device *dev = &mdio->dev;
-	int err;
-
-	/* For compatibility with device trees lacking compatible strings, we
-	 * bind the device manually here.
-	 */
-	err = device_driver_attach(&lynx_pcs_driver.mdiodrv.driver, dev);
-	if (err && err != -EBUSY) {
-		if (err == -EAGAIN)
-			err = -EPROBE_DEFER;
-		return ERR_PTR(err);
-	}
-
-	return pcs_get_by_provider(&mdio->dev);
-}
-EXPORT_SYMBOL(lynx_pcs_create);
-
 struct phylink_pcs *lynx_pcs_create_on_bus(struct mii_bus *bus, int addr)
 {
 	struct mdio_device *mdio;
diff --git a/include/linux/pcs-lynx.h b/include/linux/pcs-lynx.h
index 61caa59a069c..54dacabc0884 100644
--- a/include/linux/pcs-lynx.h
+++ b/include/linux/pcs-lynx.h
@@ -9,7 +9,6 @@
 #include <linux/mdio.h>
 #include <linux/phylink.h>
 
-struct phylink_pcs *lynx_pcs_create(struct mdio_device *mdio);
 struct phylink_pcs *lynx_pcs_create_on_bus(struct mii_bus *bus, int addr);
 
 #endif /* __LINUX_PCS_LYNX_H */
-- 
2.35.1.1320.gc452695387.dirty


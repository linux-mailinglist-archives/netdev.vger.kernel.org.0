Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C2C664F703E
	for <lists+netdev@lfdr.de>; Thu,  7 Apr 2022 03:18:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234019AbiDGBUp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Apr 2022 21:20:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32822 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240540AbiDGBUF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 Apr 2022 21:20:05 -0400
Received: from APC01-SG2-obe.outbound.protection.outlook.com (mail-sgaapc01on2120.outbound.protection.outlook.com [40.107.215.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9F272EA743;
        Wed,  6 Apr 2022 18:18:06 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Cjw9f8bocjLIaZMCQmiQt3a7LEysVZ9lx7/HGOuhpYkrorrZv3ml/YjGbiB8O43yy138lZpfkLlwpFv1ai6EpO0A7iTjs0hTCbrJFodEIl+bF1qiTnH4GLvVZLYdcmJ+J5W9YsrXuywPbNfBH30SJj1uzgdg0yM5Up5nSJq8TMXMN2ZPdyAGod83sE2wAoBZ+93ITozlyV0Y6xN0JsTgeLUnjSylzfmg+CF4YIbEmuQgK0r1Lz5OerlznYPzgQ3X/CNZVQD7wwdzW7RhHjlm2sjxZlH0jj1ynY+nqYNhFbaryzddwz4afFBG9P9fVmWhYUh8GqHqR2QCj8Zlp/z7ng==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ejm9oWzAFjLDKF8GvYIn45mp7teq4YWcl7bpMskJVIk=;
 b=VZRzFAFp2YnhVElsbpBS5chtSDkALJouin7tW+Aqi6srS1RQy9qnUr/baDNP5yeW4F9DKAS7fbsgcuO5HF1B7ceZhQbtt0CDGMoZOsfA9a/hYfzFhyzKKLT72x8xODAtMkHpzl/Ee7A55q9V7tuw/iuV2rDzK/NfYbPAaCXzst7X5mgc+sq5DXBXLC9HTs6WyEF6vbdugI55qbfq7YFiiYnHOH/SE2Bf07hooSHZ/fBSS0C+I3wa3g5r/qBI91qo1ImDXlu5J49qSiZ3pqGVTFWT4tn9/eG4+pZSSIydr1dgmVY8RpbntL1g5ozsC5wrjrZRaJoymuwAgKTpsaqyBw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=quantatw.com; dmarc=pass action=none header.from=quantatw.com;
 dkim=pass header.d=quantatw.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=quantacorp.onmicrosoft.com; s=selector2-quantacorp-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ejm9oWzAFjLDKF8GvYIn45mp7teq4YWcl7bpMskJVIk=;
 b=BJKcOq3Ox09ij2TQJEn6LeMhSGt9GqJLYDIpRyOLH2a0iwCMn/BrHA69NUhvZ6Nnb21nmx6wa3+2hAfThFiAAdKvKalliLY0TsGfgk/gQCyujNlwYyhlh79HFOMSFLowFS54gnnzha1odn+X0bd6qeQgUV8CxR4GmN7XjZiUDUY=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=quantatw.com;
Received: from SG2PR04MB3285.apcprd04.prod.outlook.com (2603:1096:4:6d::18) by
 TY2PR04MB3167.apcprd04.prod.outlook.com (2603:1096:404:a0::13) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5144.22; Thu, 7 Apr 2022 01:18:02 +0000
Received: from SG2PR04MB3285.apcprd04.prod.outlook.com
 ([fe80::e94c:1300:a35a:4a1c]) by SG2PR04MB3285.apcprd04.prod.outlook.com
 ([fe80::e94c:1300:a35a:4a1c%2]) with mapi id 15.20.5102.035; Thu, 7 Apr 2022
 01:18:02 +0000
From:   Potin Lai <potin.lai@quantatw.com>
To:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>, davem@davemloft.net,
        Jakub Kicinski <kuba@kernel.org>,
        Joel Stanley <joel@jms.id.au>, Andrew Jeffery <andrew@aj.id.au>
Cc:     netdev@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-aspeed@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        Patrick Williams <patrick@stwcx.xyz>,
        Potin Lai <potin.lai@quantatw.com>
Subject: [PATCH net-next v3 2/3] net: mdio: aspeed: Introduce read write function for c22 and c45
Date:   Thu,  7 Apr 2022 09:17:37 +0800
Message-Id: <20220407011738.7189-3-potin.lai@quantatw.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20220407011738.7189-1-potin.lai@quantatw.com>
References: <20220407011738.7189-1-potin.lai@quantatw.com>
Content-Type: text/plain
X-ClientProxiedBy: HK2PR02CA0143.apcprd02.prod.outlook.com
 (2603:1096:202:16::27) To SG2PR04MB3285.apcprd04.prod.outlook.com
 (2603:1096:4:6d::18)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 2c1c7699-d177-48fb-740a-08da18347603
X-MS-TrafficTypeDiagnostic: TY2PR04MB3167:EE_
X-Microsoft-Antispam-PRVS: <TY2PR04MB3167CCE24BB204C996A96ED08EE69@TY2PR04MB3167.apcprd04.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: JbrXxPHg58fhKcwiiTj2lnu1wkQR5WwjxXrn4CGMaaHSdcSGDRvgwb739lfKHGaitJ8IwGcl1sotaeW22szN5BYreS59dy2MIeK23oZ7kgtX9kHBD6iOzqM2lIINWEIsRvjFbQGfvgurpZjA+qRRtBTZ35sl2omV+YZ1XVAgQvYeUKAJZ/pVlFFf8V8dBNVUfRaDg/nlfjdggoBffenbuvpHZ7c73+K//HcDidhTvAFMvY/3DlLdVpl4nmI8PufFCq7IqXV5TlHqE+5bgIx4wy7PrVdBudGh6Z3enB8N3xcgl+0R6iyWKWb0V2zpyDSkZrTvyUflmGBSqk0ohTlhDgQEzxFm25mfSiQ0wffTwChWYzNzpwBnsJPe3ZjW7DyNqsdutA0pcS4b5W9pqbDMaf1IWpf8IzYtbo1L37T4J6JUf7slriPfTED5+ELYskx3GHL8WQw2O5GG1KlKlYGK/DPSxr16Y/LB9HqP26AxtwPT5OObwwKI1wu3MSY/KCbeFvkdOrXR+zxNM43Y8uzjP4wbfUm2ZroARhBrGnCiYVQO5CUZAJN9Bds8TQdZXUAjurali06/dT5nslvbQh0JJ6cLV5jas0XqDrRA6erw9xT/zs1HMD8Gipc9IT4A0bITz/3ivE4h6AGqVSjUI+AHraGhjVWHhvzwPlhgjqUIcrrvnjHrooF125AfDqOM2ZKoM+LoEg5xlt7eMLepG1DBtQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SG2PR04MB3285.apcprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(6506007)(7416002)(36756003)(316002)(110136005)(52116002)(2906002)(54906003)(6666004)(107886003)(8936002)(44832011)(2616005)(5660300002)(6512007)(38350700002)(38100700002)(4326008)(66556008)(86362001)(186003)(26005)(6486002)(66946007)(508600001)(83380400001)(1076003)(8676002)(66476007);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?HSoULehcdldro8ScDoqHmGlzzMOOTfdH+tLGtAbZC5h5/8vhWpDj5Mk9vNgx?=
 =?us-ascii?Q?FNj9yBzQ2jp/mgxM7zkjTRwAnlpbdSOS06LOGZqeVJwJfORgJ5s6+hQ9ECme?=
 =?us-ascii?Q?K9CtZeEXNnVxQCybImvh6+EPEce+kUdl/5EWq9LqmGTMNHsqM8pSwN2d+S2J?=
 =?us-ascii?Q?bT/OZPnMd5ej0Y3mZT3OLYPX+madt5lVbGtsUBu3gGKI9pwnQnwImSPGTUkh?=
 =?us-ascii?Q?vumdRtl2n6vxR8BKoL36jPawa2XFrdlhjOBr1AjfygbAKRo7/K7eJFmONMbr?=
 =?us-ascii?Q?vf76M4g0NEGqPTKuOjBUo1ecIY6FwNuvjvt3Y2YZdAlN4zOjN4EhhpQ5RvBx?=
 =?us-ascii?Q?bWzEaSY0vMI1Sl6aJiQS8p3oM0+ZHsTiw0+vh/Louvv8a2Nmfupt2iGe4zNG?=
 =?us-ascii?Q?iHHvD/yS24TRpxgsNppvYhQICBH4GBDPuhSmbJn8CVYHlfF1X/A9inaL++cr?=
 =?us-ascii?Q?+u1XJDZZbODNEBEAm/b+q+N8MoGyPtKTmPF2w7hMJA3jsijqqZhvlMtluv0/?=
 =?us-ascii?Q?OnL5SStWheBDNHjJnLwjoH3eX86kKZHV7G2iWEc4fGbaof7f6L/uATaTY44L?=
 =?us-ascii?Q?+2Tp0C5kF3DnC1leGAVXbH7cLiTW6eztgS2Xyj/LfaX20JZM2k0FVHuE1Chc?=
 =?us-ascii?Q?DSvV8Sqdoon/os85FGAIaCOCGEe/HwRxLMp1Y5sos9zkTzoEXJpSmcWWpV/v?=
 =?us-ascii?Q?Kg5HAVUYi2+bxExS4B7ER22oB/9mPLIxuYW8eWLkXu9pSS/Xb7JVA6Lbi8rU?=
 =?us-ascii?Q?Q7SQfihU4ONadW9hWBY3Yjqu3TYXT9EL6iWLa4Yc4QKQhzYF/NKe/+NJrCiV?=
 =?us-ascii?Q?0d9jFUNfgmDMPx1SZkgvTT+7DUufUfTU+6DmuzT3xSxfPHC1Bb6CqJH8SRQI?=
 =?us-ascii?Q?o6o0QbZNH3NYMDLQqruOIDgGhXdudH836gKc6aVMac00DjWdNWnwlv1r07KM?=
 =?us-ascii?Q?jMU6MjRDxXInQtWm4yJXbuzT8aqLkxlICbApyF0k2UwTARONeQWKxMj70WQU?=
 =?us-ascii?Q?BK+Jc6nSi35PPjdBOdu6Ylz5M1Wbv74vc9Sg5fYyI9oPzDUXHE9FJ8kD7cge?=
 =?us-ascii?Q?KHb4iQT+MvxB1XtpCVVLrEyiWntn+TFDTs24fgNncbmrB2DKOBUxODDagU/3?=
 =?us-ascii?Q?I85BVRwcJ9nlvRGE6DAVQLwNrhXq61tCUZm7loC3lOk/SDu2h6iOP1sAfMFU?=
 =?us-ascii?Q?PxfQCmtMjeaF3RNTKXSQdlxXp5Mxx7GBearG6/W8Swxo0xF47VVBDM5jcMnp?=
 =?us-ascii?Q?4R/Yi1nGzPeSD1nhaNOYNHIy+R2RE7XbPv64oUIVcg6xq0TaxL+YXOZ3P8M1?=
 =?us-ascii?Q?wNVN7dlLpii8q4NL712/yPwupYWLcqRmxdpJClOVjxzeoP5KtB4E9sfL6LDG?=
 =?us-ascii?Q?1UEgCmKWeve+D138y7iCeBOehLv6CzJwlmXAKibFWjR0+ElE673jocro3mbF?=
 =?us-ascii?Q?liBbujsdeGIDxa9HK2ctLLxjHs3PXHC2VBJSgVJq8+4BsjKw/yULxjs8Wq/6?=
 =?us-ascii?Q?Ibe8c4zXO4OpiGwvWW3WXbED2lARGKWSMOtci55fAfkdnIQO8HzwPkxcy7Ou?=
 =?us-ascii?Q?9fFs2AsfDTZJfdrLukZD9zZKxtQvm/ys20DePdN/AL2/1gDU6i3dU4dVkdn0?=
 =?us-ascii?Q?wi0FzAYuSN/27XxqzvxO9IK8Up1R9KRy5Tj1/nmPaKg079BPlFhLdiYjwWi7?=
 =?us-ascii?Q?NHlg4CDJAf0S4a6lzICNEr6aNtCFGBANyqT08rUoU1wdAG2ogL2AdDDpztpy?=
 =?us-ascii?Q?6hIBcwMGDrNomZRCdSCFkeKHVF3bajM=3D?=
X-OriginatorOrg: quantatw.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2c1c7699-d177-48fb-740a-08da18347603
X-MS-Exchange-CrossTenant-AuthSource: SG2PR04MB3285.apcprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Apr 2022 01:18:02.5993
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 179b0327-07fc-4973-ac73-8de7313561b2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: EeWKwsI0o/psscR/0adoWqztjYiV0MHl4f7MjooX09kdWE3WCePZUt4osZnnNd9O+Vev0004fsxABnj2egOedQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: TY2PR04MB3167
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add following additional functions to move out the implementation from
aspeed_mdio_read() and aspeed_mdio_write().

c22:
 - aspeed_mdio_read_c22()
 - aspeed_mdio_write_c22()

c45:
 - aspeed_mdio_read_c45()
 - aspeed_mdio_write_c45()

Signed-off-by: Potin Lai <potin.lai@quantatw.com>
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
---
 drivers/net/mdio/mdio-aspeed.c | 46 +++++++++++++++++++++++++---------
 1 file changed, 34 insertions(+), 12 deletions(-)

diff --git a/drivers/net/mdio/mdio-aspeed.c b/drivers/net/mdio/mdio-aspeed.c
index f22be2f069e9..5becddb56117 100644
--- a/drivers/net/mdio/mdio-aspeed.c
+++ b/drivers/net/mdio/mdio-aspeed.c
@@ -79,17 +79,10 @@ static int aspeed_mdio_get_data(struct mii_bus *bus)
 	return FIELD_GET(ASPEED_MDIO_DATA_MIIRDATA, data);
 }
 
-static int aspeed_mdio_read(struct mii_bus *bus, int addr, int regnum)
+static int aspeed_mdio_read_c22(struct mii_bus *bus, int addr, int regnum)
 {
 	int rc;
 
-	dev_dbg(&bus->dev, "%s: addr: %d, regnum: %d\n", __func__, addr,
-		regnum);
-
-	/* Just clause 22 for the moment */
-	if (regnum & MII_ADDR_C45)
-		return -EOPNOTSUPP;
-
 	rc = aspeed_mdio_op(bus, ASPEED_MDIO_CTRL_ST_C22, MDIO_C22_OP_READ,
 			    addr, regnum, 0);
 	if (rc < 0)
@@ -98,17 +91,46 @@ static int aspeed_mdio_read(struct mii_bus *bus, int addr, int regnum)
 	return aspeed_mdio_get_data(bus);
 }
 
+static int aspeed_mdio_write_c22(struct mii_bus *bus, int addr, int regnum,
+				 u16 val)
+{
+	return aspeed_mdio_op(bus, ASPEED_MDIO_CTRL_ST_C22, MDIO_C22_OP_WRITE,
+			      addr, regnum, val);
+}
+
+static int aspeed_mdio_read_c45(struct mii_bus *bus, int addr, int regnum)
+{
+	/* TODO: add c45 support */
+	return -EOPNOTSUPP;
+}
+
+static int aspeed_mdio_write_c45(struct mii_bus *bus, int addr, int regnum,
+				 u16 val)
+{
+	/* TODO: add c45 support */
+	return -EOPNOTSUPP;
+}
+
+static int aspeed_mdio_read(struct mii_bus *bus, int addr, int regnum)
+{
+	dev_dbg(&bus->dev, "%s: addr: %d, regnum: %d\n", __func__, addr,
+		regnum);
+
+	if (regnum & MII_ADDR_C45)
+		return aspeed_mdio_read_c45(bus, addr, regnum);
+
+	return aspeed_mdio_read_c22(bus, addr, regnum);
+}
+
 static int aspeed_mdio_write(struct mii_bus *bus, int addr, int regnum, u16 val)
 {
 	dev_dbg(&bus->dev, "%s: addr: %d, regnum: %d, val: 0x%x\n",
 		__func__, addr, regnum, val);
 
-	/* Just clause 22 for the moment */
 	if (regnum & MII_ADDR_C45)
-		return -EOPNOTSUPP;
+		return aspeed_mdio_write_c45(bus, addr, regnum, val);
 
-	return aspeed_mdio_op(bus, ASPEED_MDIO_CTRL_ST_C22, MDIO_C22_OP_WRITE,
-			      addr, regnum, val);
+	return aspeed_mdio_write_c22(bus, addr, regnum, val);
 }
 
 static int aspeed_mdio_probe(struct platform_device *pdev)
-- 
2.17.1


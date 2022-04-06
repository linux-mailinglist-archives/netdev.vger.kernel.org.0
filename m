Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 405F94F68D1
	for <lists+netdev@lfdr.de>; Wed,  6 Apr 2022 20:19:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240228AbiDFSTh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Apr 2022 14:19:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50486 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241574AbiDFST0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 Apr 2022 14:19:26 -0400
Received: from APC01-TYZ-obe.outbound.protection.outlook.com (mail-tyzapc01on2091.outbound.protection.outlook.com [40.107.117.91])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 07A53BF017;
        Wed,  6 Apr 2022 10:01:25 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jFgh4a2DVdB8nbOEjcua9Gu/9DTUs+X0OxUX0/nFHFmLC9GAqfG8GM7fSethE962X9ZxSBP9oprC1ItoZSLjfik3lXP2telBXWitGRfiJup+dC5Lyt3rMaTK4AbkVTD1a8LuP0guBjPFaGg8QYUXcgZ7uQYxEzE80vAMoIyaRRqbn08wp2dKe0S3wgdOVwmWFhd2tE1ROApQYecHl2IG//uY5cheaXWE67OSj4O1K0PNO+0FPzPX0tnhZex1ZFv7KlM4iFWbtM1aIQHTVNL1bJODH7Itw+2DID0+1KP6p/KSobM2kbXr9XeCWsZU0HhASS4E8NGtTwwX8eOlcGNt7w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=AYzr40+X2aVF3Ayj/CulXGvHvmrjzqpfdwE9vWNRAhw=;
 b=lbTaK+7r74uTxzCx4vqM/um40VXbLlxoOnOWU+seB0oDTKCc09BajDAex87RdD30kSGbT0EUNWU3b+eoCSQyAGOGBDbn1qK70eQDSqYlaPbDg9howMp47oeCq3p5o/EVXW6/q3eImprVSqY/Dw0YQRx8xwwt6aLkESFiSUKdItGeq/0GXbU4LtrgffNjWh4gNmMKjK6fMRrgO+3OmoAKdufWoIKv496s64tDJrGjvsoE7kh+sRYyP28xznJWojAWppgCKm3AV3iPGFEkwbSp1R9Q+RqrntIdKFsMvE1XJOH97T/X1Dh1bnM1f7hXjHILW1IJyTmxMWthJ5ZZgR9AHg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=quantatw.com; dmarc=pass action=none header.from=quantatw.com;
 dkim=pass header.d=quantatw.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=quantacorp.onmicrosoft.com; s=selector2-quantacorp-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=AYzr40+X2aVF3Ayj/CulXGvHvmrjzqpfdwE9vWNRAhw=;
 b=zPEZMFuqk7MCFfoWidBtGZ/pQHXBieAgiqFXMgpSg3W5KNWCoucPAmYkuU//EyZflN4PTxL8dZRG1WXqvep9mftP1Opa/CZ7kuIEVMYRWQ2qNg58OAcV+TzS4MGq5yFN2Q/G9y0kfR1QZHQ2pGL6VQnS9u1X75LXdheqofB867Q=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=quantatw.com;
Received: from HK0PR04MB3282.apcprd04.prod.outlook.com (2603:1096:203:89::17)
 by PUZPR04MB5204.apcprd04.prod.outlook.com (2603:1096:301:bf::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5144.19; Wed, 6 Apr
 2022 17:01:20 +0000
Received: from HK0PR04MB3282.apcprd04.prod.outlook.com
 ([fe80::9c61:c8e7:d1ad:c65f]) by HK0PR04MB3282.apcprd04.prod.outlook.com
 ([fe80::9c61:c8e7:d1ad:c65f%6]) with mapi id 15.20.5123.031; Wed, 6 Apr 2022
 17:01:20 +0000
From:   Potin Lai <potin.lai@quantatw.com>
To:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>, davem@davemloft.net,
        Jakub Kicinski <kuba@kernel.org>,
        Joel Stanley <joel@jms.id.au>, Andrew Jeffery <andrew@aj.id.au>
Cc:     Patrick Williams <patrick@stwcx.xyz>, netdev@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-aspeed@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        Potin Lai <potin.lai@quantatw.com>
Subject: [PATCH net-next RESEND v2 1/3] net: mdio: aspeed: move reg accessing part into separate functions
Date:   Thu,  7 Apr 2022 01:00:53 +0800
Message-Id: <20220406170055.28516-2-potin.lai@quantatw.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20220406170055.28516-1-potin.lai@quantatw.com>
References: <20220406170055.28516-1-potin.lai@quantatw.com>
Content-Type: text/plain
X-ClientProxiedBy: HK2PR02CA0148.apcprd02.prod.outlook.com
 (2603:1096:202:16::32) To HK0PR04MB3282.apcprd04.prod.outlook.com
 (2603:1096:203:89::17)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: a2c7f00d-d1e1-490a-d382-08da17ef1298
X-MS-TrafficTypeDiagnostic: PUZPR04MB5204:EE_
X-Microsoft-Antispam-PRVS: <PUZPR04MB52042BFC8FDA2EC5CD94E4BB8EE79@PUZPR04MB5204.apcprd04.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: BU4EyBr4UPjsvjFYsDBIWD9j37U0ukcRzOsedP1QNXPed0z08z/lUeXJn/DZIs9A0Or9t8SyUXUE2tuzoOJUqMylv1QU+7RH95K2VIcQWZKcpPEBvmDGeGWQ7Swr/Dj2xny8XCPMjw1KNDUlFMVyx7hiZYJsPH/lsd75NZiAQjby0jsTix0iRGnnyrUKUl9JgKe0qbZJVE+JJ3SDeeHPiWA5kIHRDRXlZRgvqglE3GJ2nIEwgbuM0Ow7WSIbQIumyjSniDTe9IPR7zZndSglZCslYv5teQDl15iaycY07E0BiZyN0uiYdNTn9TTKZdbB+NvA/9t2cxRL1D3dGwTJ2E/4jfmU5CaB8x4TLIeXv1aFczkaQf3yufPL/WDzqy9WK8/aRhqyo8PXO7KhA8sKTGa2V7DVuQ4fiZkgn11vXRqPrd+ftYef0IoG6zedEdPBU6vYReUeF4Yo8IprUhNn08GHeW0N3qnfh2NHwwhlO5S9NzHSuUR5lnoOXbWotvsh2ZlM5TRqxiH0GGiDxrotSmVhpB8FGhBvk13Pjvf60ooLg8xUHKmHaMn/1AcbywY/oritlHD0+oWjTuRSbnF6Rm/7NIh7/emm8Hzp+Iq8bYixswiJCtnDsENgNfrwo4BzfKytKcMA8zZP3J3pDd0HjzfPlnwWrMlmSEmuYGYonclVx8Tn8ibgp3np+dCpljC5vcO8HMrNeANBRV5ZQb5o9g==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:HK0PR04MB3282.apcprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(83380400001)(5660300002)(38350700002)(26005)(7416002)(6512007)(36756003)(2906002)(6506007)(52116002)(186003)(508600001)(44832011)(38100700002)(6486002)(8936002)(110136005)(107886003)(4326008)(8676002)(66476007)(66556008)(1076003)(54906003)(66946007)(86362001)(2616005)(316002)(6666004);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?whCk43gK6hAAn4qVGUsiRVojM5rEJAr0J/xgr0rhdDZB5/qpQ1Jby5jiuEyN?=
 =?us-ascii?Q?/pPdVImEeAoPxG1ye0CG5yAz2/H+GUcZatJ1UtOxbUlHjwSkan03tGNyl/aH?=
 =?us-ascii?Q?EXC0CcrBm3tlhVvJejG6iUW+YhcrM837xunusZHDAh7jcfitn8xuK+B3b73j?=
 =?us-ascii?Q?CK1m5HGx1T46FHqMiJR5MeA7pEaZnW/813PeAuxqfQfb3lqn4yFwqYPCtq/Y?=
 =?us-ascii?Q?/3L0fsgKH35e6F3+bRe69Grvo1wbQh+3plSyjQrbeXZw3oyWINVl1hBNxwSd?=
 =?us-ascii?Q?ueUI8WgUnk+ET+N0qtDepjXFwVR983aN3PQ7q28k66EreBqcBhXZQOs+eVT5?=
 =?us-ascii?Q?pmC2VRZBg4Ks2tnwdyL6MCBLZ+fWJTutT3aVOtReFLQ6R6Tf7u0g9jY1JLL9?=
 =?us-ascii?Q?wbw0gvpP9Kqeri1l6GsM2rmV6aDlcKfbxzls9KdrVRsw4P4UOuKeCHVuv9/1?=
 =?us-ascii?Q?oh1edbof3RYNBRJh75+oBaTIArtEPDojnwfmLzIL9yyDeX+dwLUISuwJsYxz?=
 =?us-ascii?Q?Y6x8nyI8Dqdwsmw2ogrMYqpYpgk5nmdSdKLPPkhFzgOX2ClYSohbrL0QorUL?=
 =?us-ascii?Q?7QMg3pGs139rl35Frb0UisEZCockucpNavP949tDFq8o+R/GBAjFE8RCcqts?=
 =?us-ascii?Q?/MK3yXwFRy9ZHG2v9p1eMrEi9B0A9mzVh7dtn/43jCt4rl7oZYgDCsthAk80?=
 =?us-ascii?Q?7FUrJpdNi7+8OF01p8OTfrpdExEWGa4DhinSufahNPjsBmlfIHRwiihwyrnX?=
 =?us-ascii?Q?AwScjLM/v1PHg31i8it+OSWqhDqhizmsVQj3EGy+iM492N+GgoKp2K4olTsR?=
 =?us-ascii?Q?DoTnize+vQ8DDquMH94mGbOxCR4sruEETga6TI+8//RqqiFYv6gNFXGRqsFj?=
 =?us-ascii?Q?KbyUIvWJWaFItiNUdZ0LUWs137hKmC7gNyOZiNW6Ib2hMOH2+mL9CvTcuyGq?=
 =?us-ascii?Q?9BsawWW7QIEEOA+xyX4gYW2l+6oJ0QB81ExM0D8FGjen26D6HJt1K8eM3gpV?=
 =?us-ascii?Q?5l45QyMVH/MKW0oswjzMKLLCgLfHLUIhjH1mobaH2gfs27CXD6yvrhXCn7id?=
 =?us-ascii?Q?RZ5Yt+Kl8RDDCfKbd3ZYfq1XQjeJY/+pAMweDWaJC7NRQ1EXO36ESdlA7GUN?=
 =?us-ascii?Q?seBeA7sKDHk8m5SAgrRxvZbJSt+Kw1FPTWMyXCaXR4VWNUsKNe4FbFrEl4FN?=
 =?us-ascii?Q?8NPEV/8BUw2ELjI1I7PP12gN/BExhcaNjsEmcCNu+P+kz38jMgiYOShg0KMV?=
 =?us-ascii?Q?5bd10DJuAbc5h5DjAu0XXPQD6ho0yYf2j3HHhEo/T/TtXdsrmBmil+J1tZbg?=
 =?us-ascii?Q?0SuLkODEdaEzDNIzhXAeSPl1hFIlAsWU6FMG7m7sBfjjOEMfNv5lrD4TijUt?=
 =?us-ascii?Q?nVa1fgxu/vR2QbmzsQtyoCCj4fZ5ZjAfcVQriv3yJJxoFrpO9XuxgN5/DFLk?=
 =?us-ascii?Q?Ys9XnWc9ZHz7lSOFYU2fm+96dSaA+Mzhzq1+uzT34ZaSL6FAwn934dXddHsg?=
 =?us-ascii?Q?nbATMH1VSqlIlga725LBUVEoS82KrSSRpjEypCmYgGJrNBIvNSX/WqAC1MGo?=
 =?us-ascii?Q?fnkgcQUpLRGFtbt0/BUZ4Uvr6Y02SGSQoziYYm93FS13W104GGVfXfGWGTia?=
 =?us-ascii?Q?5bljUjcfQF5FrzMR13CR1YUMj4ghseGIso9MzFdyFB6ljWsJqgQ1/3DzQL9L?=
 =?us-ascii?Q?MPPg0LdQc3/ZEnE9zqT3lHV3dQc7wOFBk18wU86N0ZPVaSDJ6lBFHnSbkmG3?=
 =?us-ascii?Q?GGTttrMoeNmrefNHZtibOHlWtRx2df0=3D?=
X-OriginatorOrg: quantatw.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a2c7f00d-d1e1-490a-d382-08da17ef1298
X-MS-Exchange-CrossTenant-AuthSource: HK0PR04MB3282.apcprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Apr 2022 17:01:20.4693
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 179b0327-07fc-4973-ac73-8de7313561b2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: I2Rb0YHPFL3MQKwYO+9qQKKGqiwET8IY0fZKirnd7qRx7LVec/M1RfgZA9z8iffTMsMXlQoNKAdVVkjk66/uKA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PUZPR04MB5204
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add aspeed_mdio_op() and aseed_mdio_get_data() for register accessing.

aspeed_mdio_op() handles operations, write command to control register,
then check and wait operations is finished (bit 31 is cleared).

aseed_mdio_get_data() fetchs the result value of operation from data
register.

Signed-off-by: Potin Lai <potin.lai@quantatw.com>
---
 drivers/net/mdio/mdio-aspeed.c | 70 ++++++++++++++++++----------------
 1 file changed, 38 insertions(+), 32 deletions(-)

diff --git a/drivers/net/mdio/mdio-aspeed.c b/drivers/net/mdio/mdio-aspeed.c
index e2273588c75b..f22be2f069e9 100644
--- a/drivers/net/mdio/mdio-aspeed.c
+++ b/drivers/net/mdio/mdio-aspeed.c
@@ -39,34 +39,35 @@ struct aspeed_mdio {
 	void __iomem *base;
 };
 
-static int aspeed_mdio_read(struct mii_bus *bus, int addr, int regnum)
+static int aspeed_mdio_op(struct mii_bus *bus, u8 st, u8 op, u8 phyad, u8 regad,
+			  u16 data)
 {
 	struct aspeed_mdio *ctx = bus->priv;
 	u32 ctrl;
-	u32 data;
-	int rc;
 
-	dev_dbg(&bus->dev, "%s: addr: %d, regnum: %d\n", __func__, addr,
-		regnum);
-
-	/* Just clause 22 for the moment */
-	if (regnum & MII_ADDR_C45)
-		return -EOPNOTSUPP;
+	dev_dbg(&bus->dev, "%s: st: %u op: %u, phyad: %u, regad: %u, data: %u\n",
+		__func__, st, op, phyad, regad, data);
 
 	ctrl = ASPEED_MDIO_CTRL_FIRE
-		| FIELD_PREP(ASPEED_MDIO_CTRL_ST, ASPEED_MDIO_CTRL_ST_C22)
-		| FIELD_PREP(ASPEED_MDIO_CTRL_OP, MDIO_C22_OP_READ)
-		| FIELD_PREP(ASPEED_MDIO_CTRL_PHYAD, addr)
-		| FIELD_PREP(ASPEED_MDIO_CTRL_REGAD, regnum);
+		| FIELD_PREP(ASPEED_MDIO_CTRL_ST, st)
+		| FIELD_PREP(ASPEED_MDIO_CTRL_OP, op)
+		| FIELD_PREP(ASPEED_MDIO_CTRL_PHYAD, phyad)
+		| FIELD_PREP(ASPEED_MDIO_CTRL_REGAD, regad)
+		| FIELD_PREP(ASPEED_MDIO_DATA_MIIRDATA, data);
 
 	iowrite32(ctrl, ctx->base + ASPEED_MDIO_CTRL);
 
-	rc = readl_poll_timeout(ctx->base + ASPEED_MDIO_CTRL, ctrl,
+	return readl_poll_timeout(ctx->base + ASPEED_MDIO_CTRL, ctrl,
 				!(ctrl & ASPEED_MDIO_CTRL_FIRE),
 				ASPEED_MDIO_INTERVAL_US,
 				ASPEED_MDIO_TIMEOUT_US);
-	if (rc < 0)
-		return rc;
+}
+
+static int aspeed_mdio_get_data(struct mii_bus *bus)
+{
+	struct aspeed_mdio *ctx = bus->priv;
+	int rc;
+	u32 data;
 
 	rc = readl_poll_timeout(ctx->base + ASPEED_MDIO_DATA, data,
 				data & ASPEED_MDIO_DATA_IDLE,
@@ -78,31 +79,36 @@ static int aspeed_mdio_read(struct mii_bus *bus, int addr, int regnum)
 	return FIELD_GET(ASPEED_MDIO_DATA_MIIRDATA, data);
 }
 
-static int aspeed_mdio_write(struct mii_bus *bus, int addr, int regnum, u16 val)
+static int aspeed_mdio_read(struct mii_bus *bus, int addr, int regnum)
 {
-	struct aspeed_mdio *ctx = bus->priv;
-	u32 ctrl;
+	int rc;
 
-	dev_dbg(&bus->dev, "%s: addr: %d, regnum: %d, val: 0x%x\n",
-		__func__, addr, regnum, val);
+	dev_dbg(&bus->dev, "%s: addr: %d, regnum: %d\n", __func__, addr,
+		regnum);
 
 	/* Just clause 22 for the moment */
 	if (regnum & MII_ADDR_C45)
 		return -EOPNOTSUPP;
 
-	ctrl = ASPEED_MDIO_CTRL_FIRE
-		| FIELD_PREP(ASPEED_MDIO_CTRL_ST, ASPEED_MDIO_CTRL_ST_C22)
-		| FIELD_PREP(ASPEED_MDIO_CTRL_OP, MDIO_C22_OP_WRITE)
-		| FIELD_PREP(ASPEED_MDIO_CTRL_PHYAD, addr)
-		| FIELD_PREP(ASPEED_MDIO_CTRL_REGAD, regnum)
-		| FIELD_PREP(ASPEED_MDIO_CTRL_MIIWDATA, val);
+	rc = aspeed_mdio_op(bus, ASPEED_MDIO_CTRL_ST_C22, MDIO_C22_OP_READ,
+			    addr, regnum, 0);
+	if (rc < 0)
+		return rc;
 
-	iowrite32(ctrl, ctx->base + ASPEED_MDIO_CTRL);
+	return aspeed_mdio_get_data(bus);
+}
 
-	return readl_poll_timeout(ctx->base + ASPEED_MDIO_CTRL, ctrl,
-				  !(ctrl & ASPEED_MDIO_CTRL_FIRE),
-				  ASPEED_MDIO_INTERVAL_US,
-				  ASPEED_MDIO_TIMEOUT_US);
+static int aspeed_mdio_write(struct mii_bus *bus, int addr, int regnum, u16 val)
+{
+	dev_dbg(&bus->dev, "%s: addr: %d, regnum: %d, val: 0x%x\n",
+		__func__, addr, regnum, val);
+
+	/* Just clause 22 for the moment */
+	if (regnum & MII_ADDR_C45)
+		return -EOPNOTSUPP;
+
+	return aspeed_mdio_op(bus, ASPEED_MDIO_CTRL_ST_C22, MDIO_C22_OP_WRITE,
+			      addr, regnum, val);
 }
 
 static int aspeed_mdio_probe(struct platform_device *pdev)
-- 
2.17.1


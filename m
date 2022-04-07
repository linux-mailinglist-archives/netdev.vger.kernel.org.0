Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B14F44F7049
	for <lists+netdev@lfdr.de>; Thu,  7 Apr 2022 03:19:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238185AbiDGBUx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Apr 2022 21:20:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60868 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240533AbiDGBUE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 Apr 2022 21:20:04 -0400
Received: from APC01-SG2-obe.outbound.protection.outlook.com (mail-sgaapc01on2120.outbound.protection.outlook.com [40.107.215.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 30480186D8;
        Wed,  6 Apr 2022 18:18:05 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ehZteNDXk23z9bdsVUGzvsGfFR9jLLHUuXNFL/KFI9WV1vuzVT3TREzxpAaKALaOKsnaCJ/BMBo7T31qdK+o3HB/IS5g7h8GXwrGMUvgzlw4XLcNpTcDudoFF3vBg+spUp3MzhxsUDmvRspmbgFL479RZpvCUoSOiHnsELjK6x0/fJGP0+dWywBoGu4asQoUyToncnqi0Hy2X3mZ/pc3DJSkBWM/JPG5sOSayLuKkppdCmaX/JUOR8Tqh9Jm5DT6sOIDJ+BifjJqIEFs5OOs5Sfhjrb2BDDt4nQBfVPS+49sKRVEE1GQIxbccMb4AQjavwYhu4KnJL4fLLL72HLnSQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Anl4BOgxOJcNkkwR9UNxcA7AJ3mvnQvkslP7Ixl0VUk=;
 b=gxHprgkA36CaRyHzG1ew7C16ktN91/f0mwuQZGUE9ayMIO8uKK8l1gbvTBCunGAed6j1RLNLR6sVowTshqqr7QnekxujZZGAaogquKknvJXLZlkZBbKa+2NgDXujogunPfOCpXJMD7HBAFmGDwP80O/6uDWyOhbOsNwpTwWq/VRrbduRlK9kq/P4XPdUkXTIpch0/wIg89j1d8SHtj0OR+z4KSz+xxJLa6w/Yv21eS4TZwqsA3eILoDpXVGsCsf13Wd15Pq/rzOEdpqo4WfDCt3DauYVyVkdC+ySj1pOQpOrhr42MhtxAxrcdUog1MNXkEu9RGJMB9TKyq7wRQgxQQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=quantatw.com; dmarc=pass action=none header.from=quantatw.com;
 dkim=pass header.d=quantatw.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=quantacorp.onmicrosoft.com; s=selector2-quantacorp-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Anl4BOgxOJcNkkwR9UNxcA7AJ3mvnQvkslP7Ixl0VUk=;
 b=GgKsuL2hccf4u8o8URCp0x9hRyqywFtOKiIPhW4tgDaFLQ4jtRJ0/4ykMw9C0oe0rY7AVAU5z85DiS+N9Y6qpDgrhcj2ika8SynOJwTBWgO8dFOLEqLOVgDZoB0ChtlLPU90/+FF0hc9Pozp1+ZRgJbzsFCWQ8qoN18f7Rz4nIY=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=quantatw.com;
Received: from SG2PR04MB3285.apcprd04.prod.outlook.com (2603:1096:4:6d::18) by
 TY2PR04MB3167.apcprd04.prod.outlook.com (2603:1096:404:a0::13) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5144.22; Thu, 7 Apr 2022 01:18:01 +0000
Received: from SG2PR04MB3285.apcprd04.prod.outlook.com
 ([fe80::e94c:1300:a35a:4a1c]) by SG2PR04MB3285.apcprd04.prod.outlook.com
 ([fe80::e94c:1300:a35a:4a1c%2]) with mapi id 15.20.5102.035; Thu, 7 Apr 2022
 01:18:01 +0000
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
Subject: [PATCH net-next v3 1/3] net: mdio: aspeed: move reg accessing part into separate functions
Date:   Thu,  7 Apr 2022 09:17:36 +0800
Message-Id: <20220407011738.7189-2-potin.lai@quantatw.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20220407011738.7189-1-potin.lai@quantatw.com>
References: <20220407011738.7189-1-potin.lai@quantatw.com>
Content-Type: text/plain
X-ClientProxiedBy: HK2PR02CA0143.apcprd02.prod.outlook.com
 (2603:1096:202:16::27) To SG2PR04MB3285.apcprd04.prod.outlook.com
 (2603:1096:4:6d::18)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 9828f007-1f02-4232-e26c-08da1834754b
X-MS-TrafficTypeDiagnostic: TY2PR04MB3167:EE_
X-Microsoft-Antispam-PRVS: <TY2PR04MB3167FB99A2807D38E962ED318EE69@TY2PR04MB3167.apcprd04.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: V13B3FpWga5bz3OE3CMgoHD/4NURKc+R1Qv7ieliJfVO6vtcTHfgY6GGnkHGgaFTKTTID8F9i6Uhkk63h1M3xQQDc+yW4SS6QTyyBqmojZclXmcL6/HWGcuzN+Nvuc9Ftl4wneb9x6Y6keZszb3S0SB7XQDNAuwv5EuSkTX5M4Kke0wbtSCBHliHDDM/UstbH/Cq0DadiLcLC7T39gVY/DN0EGPyQfxhMxuZXxLAV4MUuy7X26gJzrkV9FeRelpXINYIevSZw9UvK4dbcefJ7y/T3RipP54To7DgT/B48G49N0830+6i2BbJYzx3SF+q2NKNWb5XhQ7sxZM1335wO6Y4dR1vXhnLCOUAFmlzTa8FPbmikIpMmCc/sUbxEnXmFsj4IKcOp5t619qYvyNORb1pcvid5ZtkTnDgcqqV/Fk8c3qO/Hxhcb22BZp3oSisLvigJpx+wRJQThlIiIqxIpg5josgeEbMn4By0h4zyQ5XoE6cG0SuDrxT3QgUBNg+JKDDZH6DZcLimmuFPAPY9j0Ef6pwMUA+z602IVocvPrWniw7911qVZQrLdB6Wc1tqtUpAPiLUCcJI9CJnvE0arrG6ywaDJ3JmccmLP350Ej7od+WhoR/99OHhHrhXHWcJR661+tEkJ5gLh75cTqrHD9xCjaVYto80zZi0sasc8LxW3mQNmF+32pffB//iZsexHKC97hwk67DIIiruxGyfQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SG2PR04MB3285.apcprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(6506007)(7416002)(36756003)(316002)(110136005)(52116002)(2906002)(54906003)(6666004)(107886003)(8936002)(44832011)(2616005)(5660300002)(6512007)(38350700002)(38100700002)(4326008)(66556008)(86362001)(186003)(26005)(6486002)(66946007)(508600001)(83380400001)(1076003)(8676002)(66476007);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?wqfAqd/O8NLPaTy0Un6F9+BqgLpH6F8K/lAIe1thum4ihFQduS2RPo45oB11?=
 =?us-ascii?Q?j7BM8gWbHEz4lS7/g7UuOe/nDpxB3pqAFo2gWS2Jaqa1rbde+/KqLHrsQAXE?=
 =?us-ascii?Q?1Eas/NfYI8gw88TPSv2kCR4j5at+jHtYCGQGYUghYxH/hX2TcKAbYVEoc9y5?=
 =?us-ascii?Q?IT6EDktG+EK8x9ncc8wCKf5dqGnFlOCFyLY428KdTTKPh+z7iDF3vgEQxtXr?=
 =?us-ascii?Q?SBsFDMWFC3mZcAz5ZONYUu2iJdKVyQvvSDJIO+4eOmeRTh/9l0DClDuf11g5?=
 =?us-ascii?Q?1kRoJb4gS6KBojaAn7y2n2UFAaEspKMOjzXPNxI7j5Oc5XMINu8vAhPLxo+a?=
 =?us-ascii?Q?UFDjxn3GQMuaIwGzIbJTa7S036H/45pyRSs7AnWt3yZU607QIKxFyW8XAlZT?=
 =?us-ascii?Q?cba7CUIuR4p7rXbWwSnvAnr2VU4l1fCRUIg22/WBBMINtb5aUJrn5HZst1yk?=
 =?us-ascii?Q?aZzahfLwPZ926kNib+koGnubdxoDUGX0oIfMuHGBJGiadIWE5lU3d9avQ6HI?=
 =?us-ascii?Q?sLA97qEZ2wOwY98/uuVSm0rLVnCgvQJfrKdS2rSA9CmSKr1HF4hxwbfMy4F3?=
 =?us-ascii?Q?X+rQtb7QlO1Q4jd7Jb6hJng5ok3Elu+Uo8tXP5/uU0w+hrNVZ/WyitF13LIa?=
 =?us-ascii?Q?798vzI6GnrjbZYUSyNNXQBOfr+5O/RQAwcekLDaxx0fq7Y4RP9YUVZorD3p7?=
 =?us-ascii?Q?GhI/Lq56xmTxuPl2LR8uvS0DXR6IL0lHVVd7nfE0130G7pRW5r2xm7PQVI/9?=
 =?us-ascii?Q?+9/S1R3RchsTq8VXg9UWZQ24upWo1YereVvn44VQ420NQtzDyNkt0Msmohxr?=
 =?us-ascii?Q?GJCh6BytPqvHO5eMj31AinFwMb1VHCUeAyytxmUW4THx+t93p+Z+xNFSGSDn?=
 =?us-ascii?Q?qeO0HaOkupcnplg7WT33LR+d3jltFOvNhf7b7J67khD3awsOi/2iPBox/y42?=
 =?us-ascii?Q?8t1O7t7dRg1b0b/j88rtglFvPT2/yPc9OskIoYdM2A7y20OGwWbBV+ppUoLq?=
 =?us-ascii?Q?mxLz6lpm+sC1Ca4bp6Vap7UPGpI/cufvnx20l0zWa1vBYizRUdQaLguTmGjM?=
 =?us-ascii?Q?74WM0z9t4wb4fPM9a/p6H6aWIqJnzEklsQKx8aYI2wxdvSmq7jcFBAbLYsyc?=
 =?us-ascii?Q?m4l9t51rLEqjwCXFReGvROA/a4tqM1eK1sD3433OVTMBhxAzXTuGynnCVndz?=
 =?us-ascii?Q?r3ChY8U6ne7sIPlULj8ANMTylU5JhV3iD/wpUpyNhn/QZCOHSwWFlrr2EyaL?=
 =?us-ascii?Q?BC5gyg+KVxg30q+iEqUsvyGrAmDi16WtKKt0Qf+WqbO2HtQoId0g/wVDBfCX?=
 =?us-ascii?Q?la6GSwggdTd+pg02UyVxMXhiQvEBruPDxucfD2Jn94OKhFEosxdnoRzgAlNZ?=
 =?us-ascii?Q?6fvKCmT+3O8JYs6ewP6L9mFwmE34te69HnlFpaGx6PUfIk+bwDtQQ/0ca+qC?=
 =?us-ascii?Q?DaFLsDXlu11TaIUWHvM4rYYd3O0sGx7xrvUjyzIIIEOBt7I2NgmtwhGjRGlq?=
 =?us-ascii?Q?QE3w1OvZIJPk1voxJf0sSSFhjqFfdd1NkUQwZ0PUhtPGip5dZenCkR3reqKY?=
 =?us-ascii?Q?zOGbrlkJbtfuQCch/sH1cH4BI/SUhcN3f31+trK4A7nJ4355SqN7xlJ/v+kG?=
 =?us-ascii?Q?Ofi61LWUSNED9zIKyqO2TPMLxctCjCi/9vaVXsge09KBjhfLIllRDn6qe78s?=
 =?us-ascii?Q?4XiJkCUHHe+EFAmknwgYgMNvJcazPFfoRo1/rDgaxahVEKY85NSoS3+KGUDm?=
 =?us-ascii?Q?0aHiLkkRYiHJxkZH2GwqLz0xCMEps3M=3D?=
X-OriginatorOrg: quantatw.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9828f007-1f02-4232-e26c-08da1834754b
X-MS-Exchange-CrossTenant-AuthSource: SG2PR04MB3285.apcprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Apr 2022 01:18:01.3963
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 179b0327-07fc-4973-ac73-8de7313561b2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: /ijN2kYSJlh4kd0jz2iN625nwOqjIcGSFH4jH5dhav04fZVA89nyTYlSUSQU4xu6/No8mRKcSv++gilNC8k/Rg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: TY2PR04MB3167
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
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
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
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


Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 67A284F7044
	for <lists+netdev@lfdr.de>; Thu,  7 Apr 2022 03:19:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235532AbiDGBUv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Apr 2022 21:20:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32912 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240543AbiDGBUG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 Apr 2022 21:20:06 -0400
Received: from APC01-SG2-obe.outbound.protection.outlook.com (mail-sgaapc01on2120.outbound.protection.outlook.com [40.107.215.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C73BD18007F;
        Wed,  6 Apr 2022 18:18:07 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QZpuSi7dCAIyypgiU2/eDfAer7M/tg98M+kxBHNqde2/OeOWNMi/h6YBRv379BSEdlXULGK0jr/UNPjW9CumGWVVwwx6sVxwEtLGKFLvU6tc3sZH3wMy51rpDksSYVd0rH6LtqMZWlyrJDoyzixaPHllsuu1axagOUVNIXCiYtZpcnsnylbQBScHjuTe2Q4RxneMah+GcjOrON0JNGpuHkRxTtbniNYiaV5binHzqwqnqCsYiajk5SIvNGIzGnvXjd12pt9d7t9nfI4buLoRtDa0qVnV6Vl/Z4RNV2vOpFUWh4nJf3DzuPvC3w6WhcCIU3yb4YnRYioCfzybbWssAA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=qtbN/aF/twwFM8LcNvblrfy3Id/6HrA2AGjcJG4KYYc=;
 b=f+m/T1aG5XMUzH9H45j0y/1tJ17fh27IsBA8LhqGxt+g6cg+r3eTo9eXZ05DZ5oniQ1Af5exo/M1Yer8ZBBANM833NwYcECzjSAPWxXn4BkQw+J4hpG8wqUe+L0GASbHFGkXZ0e3Y0wPb5E7JFX3KKtM2i6H5RuPI2pUP/+bivCFst9NK0qWTz/BE7HPz7cKUeH3N0JZTa5wj8mozBg7LDlbdbmhJ+QcK4GTOEQuaXZo8dS+tN1PcmoKc/jnyYxa9FfHySzMpEu1xf8eljAmAhcxv3CI9zPMumYl9bYBp4TO8yKq1xdKZf7hMwpaYWFRNLHwLo3Z4HQFmDr89QT9QQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=quantatw.com; dmarc=pass action=none header.from=quantatw.com;
 dkim=pass header.d=quantatw.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=quantacorp.onmicrosoft.com; s=selector2-quantacorp-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qtbN/aF/twwFM8LcNvblrfy3Id/6HrA2AGjcJG4KYYc=;
 b=LYu6mYtMwJ9SP8aqAqblOsCM/bFWm1vQOOUCEi8sQX4D8ssSLF5UtzXuREonfDfoFkzXby7T1f7p8JWEOaOvZOKEJH5SI0YTu1+Fu0ySOH0KXGKFzBLFDvUllGNKr649sH1v5RMS9lI/LlT/zHNcAHeu62rW1IUV/wsmhUd5kSk=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=quantatw.com;
Received: from SG2PR04MB3285.apcprd04.prod.outlook.com (2603:1096:4:6d::18) by
 TY2PR04MB3167.apcprd04.prod.outlook.com (2603:1096:404:a0::13) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5144.22; Thu, 7 Apr 2022 01:18:04 +0000
Received: from SG2PR04MB3285.apcprd04.prod.outlook.com
 ([fe80::e94c:1300:a35a:4a1c]) by SG2PR04MB3285.apcprd04.prod.outlook.com
 ([fe80::e94c:1300:a35a:4a1c%2]) with mapi id 15.20.5102.035; Thu, 7 Apr 2022
 01:18:04 +0000
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
Subject: [PATCH net-next v3 3/3] net: mdio: aspeed: Add c45 support
Date:   Thu,  7 Apr 2022 09:17:38 +0800
Message-Id: <20220407011738.7189-4-potin.lai@quantatw.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20220407011738.7189-1-potin.lai@quantatw.com>
References: <20220407011738.7189-1-potin.lai@quantatw.com>
Content-Type: text/plain
X-ClientProxiedBy: HK2PR02CA0143.apcprd02.prod.outlook.com
 (2603:1096:202:16::27) To SG2PR04MB3285.apcprd04.prod.outlook.com
 (2603:1096:4:6d::18)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 148f32e5-9dc8-451d-67fb-08da183476bd
X-MS-TrafficTypeDiagnostic: TY2PR04MB3167:EE_
X-Microsoft-Antispam-PRVS: <TY2PR04MB316797ECECF323381F4DDBA48EE69@TY2PR04MB3167.apcprd04.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 8YYqj4ghvVY267i7zPU9ZyMDdkweHC6Zw8zqoZTlmJ9nmJgGmQWUkgQuiE/hlPgok3J1T9JDkSq/zuRTezAqHf5hCTaz9EXjjKQtN6rbn1dZwQM+z0u6giClan4K6WVflCoKCjEQ13bqvwwrlE13Dth8DpVM8yFap+z9Bf7iAGoQRO4KtWsMHJdiw0f11Jb43dsb8YKPkX09Pr/SpBxSjY1UUJ/4V3n1KJBzi14BBbIaa0gvtwTUc5zD2cJ9h/gBnMoEFS7QADhtHjS+WX4HMQ3Iuj5WN+rcgktc4w4jnBlmWqvEOhxWO4elCHfhcPmGKUqp+6lZmwM91E/daXU1fC78Gv/jyRWwxjKbYEsUwJddQpyGevgjdClz+DoZvr9hG7sVrYf7Apx74Y6nunayYXdaFrgOs88tGGzbsxRqoBoA21T/ZCvsiZnhd3lqlcCsyxb7FKcJGvpXpWNwjvmCJo4vqlocZKXKJsfw4fgMqYQq0qGMKdCQeqYdI7l5zxWfKFjQNd0ialUD4B4yaZpDLmS+hLl+x/VvjkUF8vdp2TsIPNtjL4APBKmKTMrnK0BDfFbO8eSMFluuB8h0RqO+32r6DHYdE2h/ZLt70Opkb2RT++iSfYjrp/MBzJtQPRn+oMVly8x59/aP6mEmdqek7u+SvqSJ9H4SDVqIwvMSAoG80s4INAp2LqWsqVMDpLAjQS/ftahO9RhqbJVUOQroCw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SG2PR04MB3285.apcprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(6506007)(7416002)(36756003)(316002)(110136005)(52116002)(2906002)(54906003)(6666004)(107886003)(8936002)(44832011)(2616005)(5660300002)(6512007)(38350700002)(38100700002)(4326008)(66556008)(86362001)(186003)(26005)(6486002)(66946007)(508600001)(83380400001)(1076003)(8676002)(66476007);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?kL7yhs7Vq8YON2C1j1MVjhMZ8177WhcilITifQN1ZoE6NzbHZza7OsBBPj8M?=
 =?us-ascii?Q?0DC/gvv6fJ73prNls3cUIeebLP176bz/bKGzGN2Pfi1nN+juInl/x5WdSQUZ?=
 =?us-ascii?Q?NX2QSNTUD3jmJAlZdxI8UKbT2XZkN2DFd5zjTB2/ZUsmLeZ9ClZpxO4+lGrv?=
 =?us-ascii?Q?EXj7sK/RiOSs3dBztBkH1hFMfxuaCJjLNRBmnaOHmNzaWBek3curGAy0QyFS?=
 =?us-ascii?Q?RWfhRrbgMQ894KC/if1PxQSCSGrINMXW0cWnDNSTZoZV5xmhMZ1MMAfgOsyd?=
 =?us-ascii?Q?xIpn/1/VAdgF4F0JkDP81YiU0c5NQzgCcI25XibTXqBeTpwOZiJG/BuwQ6sx?=
 =?us-ascii?Q?+lEHq7jqlkIYejEGjN7xBBX2ZIqYb1DWVZkdGfsHkzwVQPuPVpYu6V43UprR?=
 =?us-ascii?Q?+ESePNW2a+dMwRJVT7wS2CFpyTGvIctKgdvm57Bm6f4eEu6vmSG51Yik/00D?=
 =?us-ascii?Q?/yqbSARxUMk7JfdQ8U/ww3oUCbxG51HNHohjHdDozJTzTHgTNSd/HjelaGcx?=
 =?us-ascii?Q?j9MiomKMOPGPj/rxzdg7mJdIIlsyycJozTTxbrxumUytQGS+OwUK1aHzRUWk?=
 =?us-ascii?Q?7dnngIf9Pf8NtZkxMliLqn222Xrwo/gT9xf0jiJJQfql2VVVAI1Cpvn4rQV7?=
 =?us-ascii?Q?ymbHr4ef5GKxf3s72G61PxSEiaW00xnkQNJVIr3HjWKzQ/zYPp5aoPjYDReJ?=
 =?us-ascii?Q?BaWcxH3esg8Uoe3Gh3kHjKslXX/o8kX5yl7BiqPHkPYOXCEokR/V9t/8qDng?=
 =?us-ascii?Q?fhv5ztGs97BeeqviaLUyIejKNCPuCs5V6Lx7ytW9C65D2rm2Ha6yyOizypXS?=
 =?us-ascii?Q?fHwTvyOmAFJjkQOsSISsSUzCGwe6Gu3LoqmOI2PgHh4wt1w5hDh7yDHKy753?=
 =?us-ascii?Q?LVLtBqCm72t8Gbdb/aAWY3bGGjucDKcCRxyXL+8A97oM1i7Vbl8dygr1MWIH?=
 =?us-ascii?Q?k3eZ2KMffL5C3TuvcQtTp1WeoCmTm+i5o28WMS5fHxss5LitKyRCFgGxpW/5?=
 =?us-ascii?Q?5MkNeNIkt9OMNaqd5YcO2tVsdndvaPLgEYAgwpiWQsuTOGRHeswbYH93CSyh?=
 =?us-ascii?Q?qQd95s8TplRUK9S7jHg9L5tMISaexf8vDV3HOgEUqi5JY3DWT6e1yYtsp/oz?=
 =?us-ascii?Q?z15t6Ca0HuF1+sb9G81BF7eenkbrza41r6AP/wNNljjFW8SO/UBnumotRxvk?=
 =?us-ascii?Q?oQQk0uhwE9gtGUog5qiKc4RcV/bgn5mKpfY/UcotbRliqOnG86QQMDJppoql?=
 =?us-ascii?Q?brt84pfVstFoL1jYf//feN3rbUV3Jdp3hmNwFV2rC8r005XTfqarsRUPKLI5?=
 =?us-ascii?Q?ls9AsyLAGkGmPmcGUp1HTZl0fpfEMdFNJdcrf5ZZny/u0eUomI2BDH1SWuLG?=
 =?us-ascii?Q?ZnB39EvKR5WTR1KjTYFFaOPm0K4UvQleKmC1GtEoRpBXpra2SJTAs1AYMx3V?=
 =?us-ascii?Q?3+3jnzAr81d8/oDtdlox6Hvj2OLxhx0/juhoGxqZSt1hIzpPMbCHJcaPDEHM?=
 =?us-ascii?Q?ds6RyVFTe0r4fK7fv/FMpZEX0IoloLAD1NHAFGXxhwVyyr9tKREZkXY9Zscp?=
 =?us-ascii?Q?lTjFx8voiVZC3uN152HaOiHRH4xR/biblDvNz0mhcdtjf6dhllO8mNHIG7cT?=
 =?us-ascii?Q?x+T6gScHWjaUx2HlABTxd+rUe4YoN+5PT22eX748OgiUqvOchDpZNXUuVQsG?=
 =?us-ascii?Q?u36ht+AM5bU20Zrma61Q2hkyFqrf8rJoMH29hEA6OcQsVjQykO/sx3S33ERk?=
 =?us-ascii?Q?MSiXjXvkF62x0x9K/xNbered0PkMCE0=3D?=
X-OriginatorOrg: quantatw.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 148f32e5-9dc8-451d-67fb-08da183476bd
X-MS-Exchange-CrossTenant-AuthSource: SG2PR04MB3285.apcprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Apr 2022 01:18:03.8024
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 179b0327-07fc-4973-ac73-8de7313561b2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: XT9efBGI7JWweR9zfH0RFJoBie+hME06jE1AObn7ew2dLLgkjfNDzxft/Wqa1X//dyo2XFY9LrLmkBoPq0fcJA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: TY2PR04MB3167
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add Clause 45 support for Aspeed mdio driver.

Signed-off-by: Potin Lai <potin.lai@quantatw.com>
---
 drivers/net/mdio/mdio-aspeed.c | 37 +++++++++++++++++++++++++++++-----
 1 file changed, 32 insertions(+), 5 deletions(-)

diff --git a/drivers/net/mdio/mdio-aspeed.c b/drivers/net/mdio/mdio-aspeed.c
index 5becddb56117..7aa49827196f 100644
--- a/drivers/net/mdio/mdio-aspeed.c
+++ b/drivers/net/mdio/mdio-aspeed.c
@@ -21,6 +21,10 @@
 #define   ASPEED_MDIO_CTRL_OP		GENMASK(27, 26)
 #define     MDIO_C22_OP_WRITE		0b01
 #define     MDIO_C22_OP_READ		0b10
+#define     MDIO_C45_OP_ADDR		0b00
+#define     MDIO_C45_OP_WRITE		0b01
+#define     MDIO_C45_OP_PREAD		0b10
+#define     MDIO_C45_OP_READ		0b11
 #define   ASPEED_MDIO_CTRL_PHYAD	GENMASK(25, 21)
 #define   ASPEED_MDIO_CTRL_REGAD	GENMASK(20, 16)
 #define   ASPEED_MDIO_CTRL_MIIWDATA	GENMASK(15, 0)
@@ -66,8 +70,8 @@ static int aspeed_mdio_op(struct mii_bus *bus, u8 st, u8 op, u8 phyad, u8 regad,
 static int aspeed_mdio_get_data(struct mii_bus *bus)
 {
 	struct aspeed_mdio *ctx = bus->priv;
-	int rc;
 	u32 data;
+	int rc;
 
 	rc = readl_poll_timeout(ctx->base + ASPEED_MDIO_DATA, data,
 				data & ASPEED_MDIO_DATA_IDLE,
@@ -100,15 +104,37 @@ static int aspeed_mdio_write_c22(struct mii_bus *bus, int addr, int regnum,
 
 static int aspeed_mdio_read_c45(struct mii_bus *bus, int addr, int regnum)
 {
-	/* TODO: add c45 support */
-	return -EOPNOTSUPP;
+	u8 c45_dev = (regnum >> 16) & 0x1F;
+	u16 c45_addr = regnum & 0xFFFF;
+	int rc;
+
+	rc = aspeed_mdio_op(bus, ASPEED_MDIO_CTRL_ST_C45, MDIO_C45_OP_ADDR,
+			    addr, c45_dev, c45_addr);
+	if (rc < 0)
+		return rc;
+
+	rc = aspeed_mdio_op(bus, ASPEED_MDIO_CTRL_ST_C45, MDIO_C45_OP_READ,
+			    addr, c45_dev, 0);
+	if (rc < 0)
+		return rc;
+
+	return aspeed_mdio_get_data(bus);
 }
 
 static int aspeed_mdio_write_c45(struct mii_bus *bus, int addr, int regnum,
 				 u16 val)
 {
-	/* TODO: add c45 support */
-	return -EOPNOTSUPP;
+	u8 c45_dev = (regnum >> 16) & 0x1F;
+	u16 c45_addr = regnum & 0xFFFF;
+	int rc;
+
+	rc = aspeed_mdio_op(bus, ASPEED_MDIO_CTRL_ST_C45, MDIO_C45_OP_ADDR,
+			    addr, c45_dev, c45_addr);
+	if (rc < 0)
+		return rc;
+
+	return aspeed_mdio_op(bus, ASPEED_MDIO_CTRL_ST_C45, MDIO_C45_OP_WRITE,
+			      addr, c45_dev, val);
 }
 
 static int aspeed_mdio_read(struct mii_bus *bus, int addr, int regnum)
@@ -153,6 +179,7 @@ static int aspeed_mdio_probe(struct platform_device *pdev)
 	bus->parent = &pdev->dev;
 	bus->read = aspeed_mdio_read;
 	bus->write = aspeed_mdio_write;
+	bus->probe_capabilities = MDIOBUS_C22_C45;
 
 	rc = of_mdiobus_register(bus, pdev->dev.of_node);
 	if (rc) {
-- 
2.17.1


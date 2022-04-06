Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 37FC54F68C3
	for <lists+netdev@lfdr.de>; Wed,  6 Apr 2022 20:19:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240454AbiDFSTf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Apr 2022 14:19:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41534 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241575AbiDFST0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 Apr 2022 14:19:26 -0400
Received: from APC01-TYZ-obe.outbound.protection.outlook.com (mail-tyzapc01on2091.outbound.protection.outlook.com [40.107.117.91])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D2D90C5590;
        Wed,  6 Apr 2022 10:01:27 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=L+MUsWDuQKhgGFw0K/aGs8LOxWg52Ab/TBzyw9g1QWo74GGN0XWJCkNlFVbiA6pL6Ocx5NIpRVw4yyW7YH9X51N4cCCFlgk6hSgbPYZr5xXZNlEvfG+a8IF60+f1CgCyJus456pE+8XzbNtIPnW9qkaZCIPUZTMOiettIKJfnLnGaqt0K1RLkuq7T6PrdVurp5MuQ4b+KuW8Uv4uaDqAnGBM4F9z0xCIXclpDX5NVh293bZuz1QtQxtNYWVs+i+wQr6fBYPMi7EHh7VRRRvp2enDhONpa5Itk7zdChjM/jCurwBY2SaaiNOc4Uie9FxF0tLvTpRbenVZ5QVa62pDTA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=edq+ryQ73PscVubk4QO6nQR8gN/3+Nc3wCNr3YSWrhI=;
 b=irtFICiVnAwOPzYyiL/KL8kbRtwox4AXdIlYUQDEFpyKnn3KBVxfYnRTVkk/wSI2AehnRpUhTtwdEAwHFfUOwN4uPAwaRMLZTE1Bn1Il4yipNjlMaHIlpOLOxTAgdnvLO0OOGqjSl+pnsc2/Xu+oKQ6AH7gewE7yzJ28vpatvZTuhPhV5ipynKMSGa7FmaTr6XFU/+YoNh69LtaYLWXgZUenON0CLmxKiS6LUYXP5aXrWN+gvbcLvVi0wqvxCdp87dijLfQZhcT+/jZRbTPFEHFUaYBOmLc+CcDRPapXkKah8M99AeTJlbMlEPAJS1dJoMkMFZfZK3Dbmnny9dx/0A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=quantatw.com; dmarc=pass action=none header.from=quantatw.com;
 dkim=pass header.d=quantatw.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=quantacorp.onmicrosoft.com; s=selector2-quantacorp-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=edq+ryQ73PscVubk4QO6nQR8gN/3+Nc3wCNr3YSWrhI=;
 b=uK652hdoqStu46Lbi7OqyWwmQLwhVQK4TA7e29lHGZcN7dtmFAFvKbRGaHartWdRVpG6InGxqDgtaOCyRmTX2/2qOImx7tUXNCx9NabZw54Oz/YlwR1lM2fY6Q93TcFvFxjp7aHYAcH1XnRernKgrTl3qLAXKacHXboQSCG8i64=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=quantatw.com;
Received: from HK0PR04MB3282.apcprd04.prod.outlook.com (2603:1096:203:89::17)
 by PUZPR04MB5204.apcprd04.prod.outlook.com (2603:1096:301:bf::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5144.19; Wed, 6 Apr
 2022 17:01:22 +0000
Received: from HK0PR04MB3282.apcprd04.prod.outlook.com
 ([fe80::9c61:c8e7:d1ad:c65f]) by HK0PR04MB3282.apcprd04.prod.outlook.com
 ([fe80::9c61:c8e7:d1ad:c65f%6]) with mapi id 15.20.5123.031; Wed, 6 Apr 2022
 17:01:21 +0000
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
Subject: [PATCH net-next RESEND v2 3/3] net: mdio: aspeed: Add c45 support
Date:   Thu,  7 Apr 2022 01:00:55 +0800
Message-Id: <20220406170055.28516-4-potin.lai@quantatw.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20220406170055.28516-1-potin.lai@quantatw.com>
References: <20220406170055.28516-1-potin.lai@quantatw.com>
Content-Type: text/plain
X-ClientProxiedBy: HK2PR02CA0148.apcprd02.prod.outlook.com
 (2603:1096:202:16::32) To HK0PR04MB3282.apcprd04.prod.outlook.com
 (2603:1096:203:89::17)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 7e02ae51-2265-406a-3e7c-08da17ef1349
X-MS-TrafficTypeDiagnostic: PUZPR04MB5204:EE_
X-Microsoft-Antispam-PRVS: <PUZPR04MB52041026041DFFEF7F7C84ED8EE79@PUZPR04MB5204.apcprd04.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: NeB0KJmZX20JQZbSa2L27H9Z+SEJzkE949/av7Aot3cyj848Z2leiTy8NE7LfFtosi37nNYMhM2V0x0PyGq1ZpTyAcLBqLAUXRhvfBPEFrbWQDnlEhFzlQR9F+nhj6xsaS4UptCeldK9C80zY0OgsXYJdfth/bPq47XImShye3T45MoT49OjeGFTONVErMpHKvYGNTrvdPTsT653x86we2d83Wwrzj3PrvO+SJ1jjOYj1ARvehSW//03P8n/lOkOClWrEAWzum/kOMt0orf5I621E8xqVnJp1ForuoFDtFgDPD47Jcudk8BkGns3dSv8g6AJC86XWNQcjabZBzLe+L5vEXiwuQkKN+Mh1E9YkaBbZlFFIaE6MhBAL8di8dCY9P+T6WNfbYUApkdi20OwUlk+WHDtxBLvajMV6B06lffxlN93Se2i0kRRGJgw/tdVvNeAq0e//j2uhty5g3F1vHRcO0arrEXWBlrNXn8LI85Eny+aciEjV6Pkf2n5Ws1uLe7S4gW8D2Onbg3qA/kIUkbzsztUx+sLOWkeEGPi9OLB1pQmu6VuLjhMjb3JVnOy9z9eFpzOysZkqO1EmVGNVqAx2nuvm3awlTCVQ47TRe1o7iuDaTnjvIgsokXteGoLlZEsufxXX41N6V6mnIMsgwJNmswFwZAJErEEKypTnfsyr2fJZlgy5FAWHW7gZpbT
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:HK0PR04MB3282.apcprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(83380400001)(5660300002)(38350700002)(26005)(7416002)(6512007)(36756003)(2906002)(6506007)(52116002)(186003)(508600001)(44832011)(38100700002)(6486002)(8936002)(110136005)(107886003)(4326008)(8676002)(66476007)(66556008)(1076003)(54906003)(66946007)(86362001)(2616005)(316002)(6666004);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?zX/h3bxOTUAGr4I8r8LA0eFGfdaSdLzYtYtDPU6yv2LP3TVZyqwME2UUEo4F?=
 =?us-ascii?Q?/TafkZKmqQrdga8p5/wOtla9ke/JsyrbWedsM+xkf9F+jImHxpL2rVVkdeAV?=
 =?us-ascii?Q?7gbPel2IBvfTiRnptwXWPc4B/uWRfi4wZm+UE3yHeFm5zyt64Un7GXb2b0ME?=
 =?us-ascii?Q?g90sTKnX4BaRkSctb2KCzJds4slJlsVh7J+M4b/v9RgviQ1P1Z1tQRJcbHai?=
 =?us-ascii?Q?4De+hyD8W0+Q77ebWusdNac63i0BdjbSFcEMaxA2y9ZQSAk9cmVFLa7ufzxB?=
 =?us-ascii?Q?zJRBZHjk4+3FtFt2htypNIpY4N8pJw3CMz9Xg2RpSZ/bXDk4jceQh6D6RAAS?=
 =?us-ascii?Q?jjyonhqLo1Rye5iFQSsHs4O0uSHfj+wecnptwqTYoJ9qJJlJSVkfHUcedCCz?=
 =?us-ascii?Q?iLXVLR0O+OVduZLQtP4fFK76g90kgSaJJR0RH9K3oJXoD7I7V6gGmqTPAtX4?=
 =?us-ascii?Q?7pOGsXZRWgBaXWIuXMhQ0VKx4iLwDUKzozXEUdYMVzGFMyJ2iQ+ZZ2PQ8DpR?=
 =?us-ascii?Q?DWkABsQWuNNKWgtZARrYEllVkiX6FvNjnl8KmoC+JJVGL7uAhNRwjQEXAajr?=
 =?us-ascii?Q?cncfk/2OmHQiNcT4y16Bl6q+iDAQMYKE53HLQbgMxBJaYmKXaT9tYMB6p+ko?=
 =?us-ascii?Q?xYwzRjyIDchl2LrZqpQ57I4rUF/hWyzjkAd+gSDO8w2uN7XAD3kJAKno11fC?=
 =?us-ascii?Q?WKpLkED4V7p0WIikUpzciF3Nd80cuiNVEqBd4kKQA2kFFenn9wZ65tYfWA1m?=
 =?us-ascii?Q?MBtUN+T8VzvOWgvVIA/yymDCzR8LEux5e5jS2jFDJPAwOKsKmIOm0CjLuXPc?=
 =?us-ascii?Q?m9H0r/uuEPNCGOTPHn1HH7PYVHlciZ2p1YZikzCpiBehaVsUsEMSz+a42KCH?=
 =?us-ascii?Q?NR1FmZYg1K+y0/XbYbQC1txaAqff1hgWv03G1QI/9cPoaqTkMlw4WXnVuvLz?=
 =?us-ascii?Q?w6yDetLseWRjbGn/hdxuoRk3omO6pFAdk43oXD75CGACGC49wCrLTe4dZsoY?=
 =?us-ascii?Q?o2dkLsjlb3u7/GC0aEUDFWiQI7a4yZYLHvwIewfbXr5BIeuFMBLIEQl8Gx8N?=
 =?us-ascii?Q?jCTFb5ZxtvbH7/v1NrmUKE4PzgEu1hJMrfUgSg7YI8UOZjY/oMqL0wt24+ny?=
 =?us-ascii?Q?0oJqykuC+yVbdKZ1e84fGmXFa4pBAyGcJQNh1dEb84dIemN/nKgce2l1Xryd?=
 =?us-ascii?Q?9Oy5DfST6z4g3oU6e+hM9XjQJTj4OmV85XtfeYUn65E2p1e57dYZ2GyepWXU?=
 =?us-ascii?Q?GIyzG5++Yl3I9IO9YFJfNWKPduN3gYnHFytD0RTPJHQmKmC2Wi3DwWimX0ce?=
 =?us-ascii?Q?A26/6UWnIOonVAtUQgCXji+xsrwDgEqkEFl85sG4E2iwredTZunDrMWXzWYh?=
 =?us-ascii?Q?MKxg7v/GYyaIIxBcx4iP4bImnvUV1N7A29CVd+M68hXXP5gUhsVGRn9hPccC?=
 =?us-ascii?Q?48uJcqXqUqRMtiUA+agBujqSH/mHXLgAwdtuu5z1T5bPYS0ujPTOy5/btQRR?=
 =?us-ascii?Q?ELlDD+9SdRH5dMKdhlMqrWthYXtFpefNvc1tDOTgHIIOMYZbsKPxS6sxcpF6?=
 =?us-ascii?Q?GeWLCv0s4PqiEJ+6asH0mOF08xbU8pyakn6QS2POJWj44WT36tkMPnvR+rth?=
 =?us-ascii?Q?ijoPvu0leUQUF60F1TK+KrBTxwfuHANVa1GtA4lQZ3oC8YOZzi+EDpkUaa0Z?=
 =?us-ascii?Q?klipW3+E7XgPqx0oOuoyS6p7aGv/ZxNIQ3D8aSZB9uC8PntM+LYhPsyXf4bl?=
 =?us-ascii?Q?yw23w3Mrml1oXjyyO7HNvSCvowR2lXs=3D?=
X-OriginatorOrg: quantatw.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7e02ae51-2265-406a-3e7c-08da17ef1349
X-MS-Exchange-CrossTenant-AuthSource: HK0PR04MB3282.apcprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Apr 2022 17:01:21.6098
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 179b0327-07fc-4973-ac73-8de7313561b2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: jKcOkWOYHuqcVVnre9VofAPkLkWbMSVe+DRQMkv1uEi4kpuEy3GSeabFplU8mEcJz00PcCRV6aBovRBzXOyDnA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PUZPR04MB5204
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add Clause 45 support for Aspeed mdio driver.

Signed-off-by: Potin Lai <potin.lai@quantatw.com>
---
 drivers/net/mdio/mdio-aspeed.c | 35 ++++++++++++++++++++++++++++++----
 1 file changed, 31 insertions(+), 4 deletions(-)

diff --git a/drivers/net/mdio/mdio-aspeed.c b/drivers/net/mdio/mdio-aspeed.c
index 5becddb56117..4236ba78aa65 100644
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
@@ -100,15 +104,37 @@ static int aspeed_mdio_write_c22(struct mii_bus *bus, int addr, int regnum,
 
 static int aspeed_mdio_read_c45(struct mii_bus *bus, int addr, int regnum)
 {
-	/* TODO: add c45 support */
-	return -EOPNOTSUPP;
+	int rc;
+	u8 c45_dev = (regnum >> 16) & 0x1F;
+	u16 c45_addr = regnum & 0xFFFF;
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
+	int rc;
+	u8 c45_dev = (regnum >> 16) & 0x1F;
+	u16 c45_addr = regnum & 0xFFFF;
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


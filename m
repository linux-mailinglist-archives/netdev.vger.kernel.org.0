Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F1F724F5794
	for <lists+netdev@lfdr.de>; Wed,  6 Apr 2022 10:16:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229702AbiDFIEo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Apr 2022 04:04:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55204 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1579846AbiDFIB7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 Apr 2022 04:01:59 -0400
Received: from APC01-SG2-obe.outbound.protection.outlook.com (mail-sgaapc01on2135.outbound.protection.outlook.com [40.107.215.135])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4F2A1ED9C9;
        Tue,  5 Apr 2022 18:20:34 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ltcvV+C7kil5CYjCysURQLuzPIKMQweHN21HRD3MalEfYvafa48qgPYvjt7ACzfHSkDe31Vx0/cczFb2vblADHryq6rt/zXmMCbnLJHuFlQ8Nui78dqIixWRbtqeNe0etrdFd2shFCIaMYz1M2q6omRu6iV9cfbC0y9gbHj4XBXiH5Q30bd4VZTLtVMvEAfYh03cbg9uKWE2INwvVpppsMvjkTBvPn4NZJ8O9Auc65VN5BSqiqEsKwj1a2mE/tgvPIh4Z9py0jy6hsWI2G1C9Yxtbf8Si+gl1UjfD1InNciVQ3HJ/FgY50oe2L8J9VgFTiip4f6pZ/auSZM0WyN3mQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=VXb9X5yBGCE/Yv1MuBWWaiCSAPduSoTpjKKur/aLeSI=;
 b=gPZKvqdTH67ShqIF/CkqzGendt5v1HzepLECXXwnAQSOnWXJ31RtPGcEK6t0nBg3JKktTBiSqd0/cJBv14kq9DNETVmo55pHO/3nNLmjZh4X8eokMiQkXHkWiXzjGO1OIAExHYSSC2E3lk96Cvi5jpMYlm8KQKq7VA+eUg2sJsf+COQRo2UHmmcddVOblcl2m/RkEUOzFH96KhWE0ZNpvnvtXTPmN1QBFLejFhREC1eAcLqIVYals3aGWHkynhaJXOmYWDn6FKg6EJv+dYw6Onc3VvAXrzRkcbbXV3RpCzxcxzcaFY6dHhA0XCNIRiJD0YdT40ExWA1Cjkp0+r+7Qw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=quantatw.com; dmarc=pass action=none header.from=quantatw.com;
 dkim=pass header.d=quantatw.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=quantacorp.onmicrosoft.com; s=selector2-quantacorp-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=VXb9X5yBGCE/Yv1MuBWWaiCSAPduSoTpjKKur/aLeSI=;
 b=0ovV/7CGM0iqTZYCadk41YcZ3qRazwVf1NubxR84oqX5Ow//fZVokL2fBUosF2+m+NKuzgWE+4psExRbjtWdIJDkaW+3Iy+rOosSbBzV/8NLEe4OM8vvRvIkrNE6RYWKKVKmPlMhg1/j4x7Asqv+RwYFHTR3kjH4s2I5h+uCndQ=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=quantatw.com;
Received: from HK0PR04MB3282.apcprd04.prod.outlook.com (2603:1096:203:89::17)
 by TYZPR04MB4446.apcprd04.prod.outlook.com (2603:1096:400:4::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5123.31; Wed, 6 Apr
 2022 01:20:24 +0000
Received: from HK0PR04MB3282.apcprd04.prod.outlook.com
 ([fe80::9c61:c8e7:d1ad:c65f]) by HK0PR04MB3282.apcprd04.prod.outlook.com
 ([fe80::9c61:c8e7:d1ad:c65f%6]) with mapi id 15.20.5123.031; Wed, 6 Apr 2022
 01:20:24 +0000
From:   Potin Lai <potin.lai@quantatw.com>
To:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Joel Stanley <joel@jms.id.au>, Andrew Jeffery <andrew@aj.id.au>
Cc:     Patrick Williams <patrick@stwcx.xyz>,
        Potin Lai <potin.lai@quantatw.com>, netdev@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-aspeed@lists.ozlabs.org, linux-kernel@vger.kernel.org
Subject: [PATCH v2 2/3] net: mdio: aspeed: Introduce read write function for c22 and c45
Date:   Wed,  6 Apr 2022 09:20:01 +0800
Message-Id: <20220406012002.15128-3-potin.lai@quantatw.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20220406012002.15128-1-potin.lai@quantatw.com>
References: <20220406012002.15128-1-potin.lai@quantatw.com>
Content-Type: text/plain
X-ClientProxiedBy: HK2PR02CA0129.apcprd02.prod.outlook.com
 (2603:1096:202:16::13) To HK0PR04MB3282.apcprd04.prod.outlook.com
 (2603:1096:203:89::17)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: de17ab40-fbf0-45f6-3bb9-08da176ba058
X-MS-TrafficTypeDiagnostic: TYZPR04MB4446:EE_
X-Microsoft-Antispam-PRVS: <TYZPR04MB4446412794F9BB3729BC27A78EE79@TYZPR04MB4446.apcprd04.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: VRmOV9V+9IflT4yWaIQRAE/tnJeWfA/t3YpAFbTgNj/YGer5SujYEpYPLyMLofnC7W+iukcWO6cpM1Judu/1DE4nXd2SEjXaImOOwh4F13qhlO992+uVBIRFS+rrHbS0zs6RB8bGtGvTPa9SZhNCm23fbQC28AFi4EdB/AH0ZaqKoZrX6Guzq+nUKEoV7aOJm5SHzV74+cdYNIadRuV9Th7mVaFOnr98i7utYMTZO9XD0QcEr+y8Zn/Q7Tk/PMZP/89ToX2OfsP8ETFVPYgcDVi915vFNuGFY3Jgw5o8WTfodfofzMFyk6Vi2qZquki4MpcwVngyQEGne/YfkFnpG1BwoCgKKMlgvzl8WJlC1ZuLIjNYuPcqNmFP0SfYbzEYp+bfIRnXFXQG/Wx8VSeVMHJ4Ij3bTBwSkXAVIWUWdkRa5emdciLauA3KYtbvJ1Qfee9DoOQFKieplrPN6Pjyqjo9acILSF77kUhgPL+eiPqbBSy7T/PzAPJu3jBrFKsviSfYB2/uaHWXyEuTZeRA4OlmWzNEikpQ2NWMvxga6skQhMPGq83xnffsBQeXNKRBgm9aT3fEM0EOfNxXDQPcvhiiGaFWiiSK/2SJ19oObUojATD8NFjWV7Nv3LERie91tLVC/bM2SVVHdMNhEIthBWIf+uE5ulE6t2Hi/1l+Yb/JOaDk67Ob3FS53bG6z1FrWLxMNv2DDVBqSDSsDCjyUg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:HK0PR04MB3282.apcprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(508600001)(66946007)(5660300002)(52116002)(38350700002)(38100700002)(6506007)(6666004)(8676002)(6512007)(66476007)(66556008)(2616005)(4326008)(110136005)(86362001)(8936002)(186003)(6486002)(26005)(7416002)(36756003)(44832011)(316002)(1076003)(2906002)(54906003)(83380400001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?W8xK0ze5vRSxxIuIZcccbufg7lpFySRS/QY3xGx4lgj69zFi8aE4bLCP0Ivy?=
 =?us-ascii?Q?mfHUr0/44AI479+7ItMswTwKA7Rt1aPuwPzDn3qFFr8Ytau4YXjQy/nSKgiD?=
 =?us-ascii?Q?OMTmXGVaiUStfyeO0g68LCNj00ZqXkY3XJCdaE/TMI5scQJPhdwakl7bsSt3?=
 =?us-ascii?Q?KDBNVtBXT9LkYW7as6H6/zOlAb9ZvxqV4YxgnLxn3NdMjjNU9hosJLfwZL/1?=
 =?us-ascii?Q?Y8FIXZbccwjU1ygjLfBTTbZbmY4lw9p+rBvvJb/6nR04Zy7tMmPWbcWum8VT?=
 =?us-ascii?Q?TedxmzCiH8PRnq4RKh339+Vg75O3e8P3P1Cn+s7wELYCNx62knBQKYw8n/Q+?=
 =?us-ascii?Q?pK4E1F+S4eAqpS55EHQT2weL2z/wn4bXxhnIfqt6Kw1z8gIMPCyh/Th9o5L6?=
 =?us-ascii?Q?I0OLKFM7HXopxMnkPSfa0lTA6PsbK72rsujWmUewazoPwml3dMNbR0QFmOEq?=
 =?us-ascii?Q?2ApeGvSzkY0CY/LuTbxUJWANYj6tTJP2V6gHgSGhKm6nrhNL8fxnJjMHNwYv?=
 =?us-ascii?Q?87SorH811Hu1sujNnqifybkpFfgsF785WlFLcE1HoMgKqoJaN6LKcTftvddj?=
 =?us-ascii?Q?OPGPSCyXvb/8OwE7IeKvTnN6lkiQXQgyQGIO2O+J3hvVUFHedJXad6LnUzPH?=
 =?us-ascii?Q?s1b4JW6NSsm0JhFW1ppKbtDtkccS0W8o/TY+gfGviHLb2GaSD6bya0Xmjng2?=
 =?us-ascii?Q?ftFu1MZDWVXgkUQmDkp/1V31F+TJjJXyfcf53M9JmF9c8T2QEz3fWwLNhJ+H?=
 =?us-ascii?Q?llgS7W1R773JOpKan0g/JURl1cKrqky0Dazo6zTtDQWk8BUsaCe4NVDYwhYv?=
 =?us-ascii?Q?z+NyNaXQ4LiNG6Nq+Y3Bg+X8naAa78UvkxGRu4lAOXYXvmLu+4GSGOayxCtV?=
 =?us-ascii?Q?pJxCEKBlglVr6mipq++cIQGXmcxc2NpiLfgjUkE0fLkObtGhlvLENBBJ4ONw?=
 =?us-ascii?Q?rDp7f0GdFqqp/7kvTyigVS5WBTr96inWl4l8M8VF0zeiZhXQyAy6lR/CJ1la?=
 =?us-ascii?Q?8wBQhxtEJItPq+AclLWLxHFsOyAzKEXeXVwweoCDGFw/Qy2utPmewgz9N42w?=
 =?us-ascii?Q?Z3LO1Qz6mbbB85mF7ZGVp+cWMQbQT7Zq1gmsZ79vrRsizSke1hYM/6aT/VPb?=
 =?us-ascii?Q?lza2hfZECcmihJ9zruWjuvLyNcKS+yVZf68920WoYso504vV9NZ6/lFDkjBw?=
 =?us-ascii?Q?5CnRjHQqtfZ72g0E5YAmcJJBP5JlkyulbWKb977Lawh7gUpPNGwni1cROZQw?=
 =?us-ascii?Q?hyXBeQ3yDYC7QiYrZvWG5vzKABL09BXDDfMQWD1mvdqE8o1p3zKsc+/QHWus?=
 =?us-ascii?Q?5iwhSVGeJcQ2HeN+N9CpgsXu779fmF9wcX1jDMSNS1ieOgAkSyKqDyuClAyx?=
 =?us-ascii?Q?W7eb1jzAiuHp73PcinGxYEpdt+baHKt12G+6dg4c/GO/Tx6LPCHebwdtacQC?=
 =?us-ascii?Q?p7r+MVUN0hz03eIiKwXg551cVARxTB377GEB64KWlYlYkRiVqXIJEBj0eTCz?=
 =?us-ascii?Q?UGQI/SSL79YxRaNcZMuY0e2zKiWYlUSy3/aY74VylnQmczqbabQRaVaFhhC/?=
 =?us-ascii?Q?iZ777KIM7oLq3+NGi5EVZtZvhMa+KX1WM6Xja4b8pYJGu+suB9yAwTWu0iz5?=
 =?us-ascii?Q?E6jlp2lRkVNzXfMxZYwq0EwX/894myWlu69f1OMlnWpIqRCFoYwFcZ3SzI6+?=
 =?us-ascii?Q?QGMS8tUo2fO1yoT++gK2Pt6m93STz/Rqz9LOyOC3xp109u+b4WUzaht8vq9l?=
 =?us-ascii?Q?GCoWG9xhaHuZInt4+IgaiTZLfPdDwPI=3D?=
X-OriginatorOrg: quantatw.com
X-MS-Exchange-CrossTenant-Network-Message-Id: de17ab40-fbf0-45f6-3bb9-08da176ba058
X-MS-Exchange-CrossTenant-AuthSource: HK0PR04MB3282.apcprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Apr 2022 01:20:24.6360
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 179b0327-07fc-4973-ac73-8de7313561b2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: x9GYlawlNqdzFjLvB3oOkYTee1LAYs7nbk8Zu+h3u9lW5c5UesEtakpAwzS5e03t0KLeVX4HV63f6Le/seQFpA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: TYZPR04MB4446
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


Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 83F1D43295F
	for <lists+netdev@lfdr.de>; Mon, 18 Oct 2021 23:55:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233784AbhJRV50 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Oct 2021 17:57:26 -0400
Received: from mail-db8eur05on2080.outbound.protection.outlook.com ([40.107.20.80]:24544
        "EHLO EUR05-DB8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S233571AbhJRV5T (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 18 Oct 2021 17:57:19 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=CucsfkiTe/IWiGvkKn2xywXc5DEko23m92XxKdN9ZRfYO+m+LJtiHTp0Dv2JAoNoO2CvsXB0T9PwxwA1DzrbJrx5nGa486uETjyAFoVX6PopDQI6Tb+4nEp9ilbSwsxgvM+jnTmBChNOP9hU1vbhsMehgiqX9Wx/Ez5+QQ+VmW2fpgbFKZkNIM3+l4uCRP01AKfoWsR10eqloAygu7y/k0W4A+pKZXv1W3n4Q7BmtzGokMjZ9Ra9f7s26irFHiJf8XK7fr0GHIWNt43lET6Flqyqc8Wm/CQ72lSBHmIaqo5dsit6Q6aNRg8/xVSq2Yg0XROOR28EQF18Q2gvdOukVA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=px2TT514bHRbG7p/dO5ydmGWvLG54/oSs+zSGR8MeZc=;
 b=Gnrgkxd+bi5tjm2cvnFj/DoXOb7Jji6TUZJ6Fb6Plc0RAxLLmVEPmbOWHK78+00pSnUHsu3zuw0gZcCeMg8LEL1g1EBTQrc6ZlClouTAIA+CXsw3uBJltVHqIeHCh2/ZLvNL9uCdmNv0Zg3snLVrGP5uPT00+/KTvfBkmdYZIlZvUt0fmAJV0SMocNhg+HzRNAHvMxANfuWeHKKbZ+5kLEqlrC0DikAz5FL6d3futGuTOP7f8GH6vArfK+pB+iZO+SoWdg8Vevkd7kqOMAErNuN3Y9cgPDJ1tV8E9w4vS55O3UXh9SP/IY99qXOrx9uyLuHOZ7LWoarIkWiguk78Kg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=seco.com; dmarc=pass action=none header.from=seco.com;
 dkim=pass header.d=seco.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=secospa.onmicrosoft.com; s=selector2-secospa-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=px2TT514bHRbG7p/dO5ydmGWvLG54/oSs+zSGR8MeZc=;
 b=jKDe6YNNQSWKhOf8lZ9K5VDcHhlGSqB7GSDUNnhKnVGHOIDAooFyFpQE2ibawMDdzooVGcV3dla575yZ0MPDUJj+vr7tyJlwaeoBe+MefwiOBBzf2ttg8XIbe0XpiOVHucWVSJVppgq3j3+VlNbNgVxiK2qAOjNaI15px/WDCTQ=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=seco.com;
Received: from DB7PR03MB4523.eurprd03.prod.outlook.com (20.176.234.91) by
 DBBPR03MB5366.eurprd03.prod.outlook.com (10.255.79.141) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4608.15; Mon, 18 Oct 2021 21:55:06 +0000
Received: from DB7PR03MB4523.eurprd03.prod.outlook.com
 ([fe80::a9aa:f363:66e:fadf]) by DB7PR03MB4523.eurprd03.prod.outlook.com
 ([fe80::a9aa:f363:66e:fadf%6]) with mapi id 15.20.4608.018; Mon, 18 Oct 2021
 21:55:06 +0000
From:   Sean Anderson <sean.anderson@seco.com>
To:     netdev@vger.kernel.org, Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>
Cc:     linux-kernel@vger.kernel.org,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Russell King <linux@armlinux.org.uk>,
        Sean Anderson <sean.anderson@seco.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        George McCollister <george.mccollister@gmail.com>,
        Kishon Vijay Abraham I <kishon@ti.com>,
        Mark Brown <broonie@kernel.org>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>
Subject: [PATCH 3/3] net: Convert more users of mdiobus_* to mdiodev_*
Date:   Mon, 18 Oct 2021 17:54:48 -0400
Message-Id: <20211018215448.1723702-3-sean.anderson@seco.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20211018215448.1723702-1-sean.anderson@seco.com>
References: <20211018215448.1723702-1-sean.anderson@seco.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MN2PR19CA0003.namprd19.prod.outlook.com
 (2603:10b6:208:178::16) To DB7PR03MB4523.eurprd03.prod.outlook.com
 (2603:10a6:10:19::27)
MIME-Version: 1.0
Received: from plantagenet.inhand.com (50.195.82.171) by MN2PR19CA0003.namprd19.prod.outlook.com (2603:10b6:208:178::16) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4608.16 via Frontend Transport; Mon, 18 Oct 2021 21:55:04 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 03cd1fff-664e-438e-f913-08d99281f24e
X-MS-TrafficTypeDiagnostic: DBBPR03MB5366:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DBBPR03MB5366CEB697261B3DA313839B96BC9@DBBPR03MB5366.eurprd03.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4941;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: NEaTYesWS/JCh3+Sb8hMtUG6UmubOPKPl8RmZq8ox63Ga1Xsx5hEsCCLkzFERFIAvWzVdBnu5RsOMJpk5xplboAu/XovyVi0mc5vIfq+GC55wGzcLWuoztSj4VOccsWM1DMumn3xJ4VgOwheT87lrgX+2teWLZ5/WKQdXPd8i2ZwJ/nk6HX9Ex8CwdsvcSrdT69JPYWop/dDRTIFBhWjf6xe8x6ZVdgMGAEJb++Lewd+trRs06B07ZPS2wCTBaXPIAuNZnriXm6ETbXdQqYmSoSkFzS5QOjpE0XDeh63S/Q0rXCizaKVL1cXuxCGfOci34zxvILVJvZGKtrGCB/BiBzPEQ3/RYbEa25nQKPIh//TUEApxnTA9N4QmU23TcbamzLhOJYpKX9Bg6QIHOTSbAJl3cDvrKsTsmEYufc7BaoGMEYLYUwonR0vJwnaUmtcdQMDJrSGT7O46JjDF3pknx/urNixOF6dhawOB8AizNfhm5cULrnCQiQCxCh1KLZKkI2sQ6QUsniuOQCM6uvZoFW86dL9VQacsb4N/DULjrPWyXVJLDn28pQMUWQAQMWO7Rto4PzHZhRc7dst6h5oxIivHF1P4xnJ3Pfz8r0i1GSRq73CJjZurY42IoaUuzSMlfln/vferBgFGBJMU20dQ6bxU2//jM27eT6GRthG18GkNYjhkB9GVqj17bhGqDOpxT+eIAKSs8VmtZbkGDHTTg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB7PR03MB4523.eurprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(5660300002)(83380400001)(52116002)(6512007)(186003)(1076003)(38350700002)(4326008)(110136005)(6506007)(8936002)(66556008)(66476007)(956004)(6486002)(2906002)(8676002)(86362001)(66946007)(44832011)(6666004)(316002)(54906003)(7416002)(36756003)(26005)(508600001)(2616005)(38100700002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?cVyJiXTSx0OrQjObZcDB0+phOmaWdNL5EjU156NtuBdd2sqZ5wmuU3l6v1b3?=
 =?us-ascii?Q?sPNkKF+K1GTZs/JJFAzELC426NEJ8WLkRVxvsysZmthNUUHE1UzoCD0/ZlMY?=
 =?us-ascii?Q?4bC3+HaFnfv7f7Z08+QwXUNbcSueLz8fqAirC9vm+YonQViX/b+Q9kP3PwWz?=
 =?us-ascii?Q?FS9l+pY1+N33qVawHV6XgkhKNi2nQu3TrMkzzT3UzmoxiBgN8DU7xxoiZhT8?=
 =?us-ascii?Q?P7NCccyg5HxAiJTMHNNhTTmgs2DImMoEHCknNbTiQsHp/yPIOXY0GN9W6pn6?=
 =?us-ascii?Q?X5P4D7HEbbv93mmEHCcZGRb7ujLEhGRDoF3qu6OPeJ9b2y+DpHjY2LYok2Ep?=
 =?us-ascii?Q?ingL62sOII2e/eXweN/SeROaihepKqAGGqpZd2sxM3PzQoJg9KX6wMOjZZBa?=
 =?us-ascii?Q?0Vu7572sE3RFgKuwQDS24oOajZokaK97gU24WWILiJTTzvlttJ/QDO2Uws96?=
 =?us-ascii?Q?/NYJNdR+5OjMaj1BJhfJ4Gu5NYL2KxqCMbfvXb9FTfwsXoMvjn7ZMcuJY91Z?=
 =?us-ascii?Q?YlI41v5l5TBogFlm6KR5JXN0Zrf2f4501NcYjGG8WvG7pVcbuMQzOgX3wfdK?=
 =?us-ascii?Q?GO3Tsag8fBEI/PKKtfRhGAJZdZw+F5NI5E97KK3VUReY7fr6j2KUwJYF80pi?=
 =?us-ascii?Q?z3K+QqI7+3sA0Vx4fgzAVlxRdj9uHAhfFv4Io7X7xscPzy3eQ9gYVsE+6AlJ?=
 =?us-ascii?Q?f886IbCkwQp+plYMq8KWUsbExA9GxSqDzRvAv+eOQkYnBVofJkZJSSV6Jx6H?=
 =?us-ascii?Q?uSkQiDwkNhf8Gazh60QMHJYgfcygFxfN6JxRu2j2GHs5ksUmhUDq/iYmKqy4?=
 =?us-ascii?Q?cgxQvJUVmiPL1V8t04FlGWioRRAaRd27fF07fWltphi8IIE0b5eygZ+ox3fh?=
 =?us-ascii?Q?pMP4HiSzbS8hk9mCgkcf3Tx506udo/RUc92aSE9yUZgM4vRNeySyKP8duO6J?=
 =?us-ascii?Q?gyfzglYmjD864dIEYrmyThaZ3k58ZsQVfFQjcUDaef+XmHurDcJvSUJk82Tb?=
 =?us-ascii?Q?y5b40s+ByKgakxaQVME5ON/zJodpX7g+eHhUs4IwMbqBOWj16h30tpHhVr7R?=
 =?us-ascii?Q?5sI5boh7mTJGvo7uNPGNX54lnX4aGO8yVa9lXDPRamegZ3a/s46xRxtjgmeq?=
 =?us-ascii?Q?N5lvAW56uw+ZYg1BdQUV1EjKuT1M03c6us4KXpTWyrR+JGovJoAkEWx8jjXZ?=
 =?us-ascii?Q?eEUCHj6wbqw8yo8Sd1QpG5IJ+OZbPSRyepSrAlqPjkAb3C1Q8E8XxUEQqk8O?=
 =?us-ascii?Q?7SEkv0BNdOGTERz+17ZBoZPsX/615su/JhQwO0hLdidfTbhTM5L6mzXGOonW?=
 =?us-ascii?Q?k5ysEOWdJkkHJfe6C2NR9Tr0?=
X-OriginatorOrg: seco.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 03cd1fff-664e-438e-f913-08d99281f24e
X-MS-Exchange-CrossTenant-AuthSource: DB7PR03MB4523.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Oct 2021 21:55:06.5922
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: bebe97c3-6438-442e-ade3-ff17aa50e733
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: LfDYM+y53jT7+ibBZRwejhk842iU1z+k16j2LCSxBFMtE4VRHvwlnLJY3toWRAiY+HxhCjjSYdDZRp6dyxCphw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DBBPR03MB5366
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This converts users of mdiobus to mdiodev using the following semantic
patch:

@@
identifier mdiodev;
expression regnum;
@@

- mdiobus_read(mdiodev->bus, mdiodev->addr, regnum)
+ mdiodev_read(mdiodev, regnum)

@@
identifier mdiodev;
expression regnum, val;
@@

- mdiobus_write(mdiodev->bus, mdiodev->addr, regnum, val)
+ mdiodev_write(mdiodev, regnum, val)

Signed-off-by: Sean Anderson <sean.anderson@seco.com>
---
I am not too experienced with coccinelle, so pointers would be
appreciated. In particular, is it possible to convert things like

bus = mdiodev->bus;
addr = mdiodev->addr;
mdiobus_foo(bus, addr, ...);

in a generic way?

 drivers/base/regmap/regmap-mdio.c       |  6 +++---
 drivers/net/dsa/xrs700x/xrs700x_mdio.c  | 12 ++++++------
 drivers/phy/broadcom/phy-bcm-ns-usb3.c  |  2 +-
 drivers/phy/broadcom/phy-bcm-ns2-pcie.c |  6 ++----
 4 files changed, 12 insertions(+), 14 deletions(-)

diff --git a/drivers/base/regmap/regmap-mdio.c b/drivers/base/regmap/regmap-mdio.c
index 6a20201299f5..f7293040a2b1 100644
--- a/drivers/base/regmap/regmap-mdio.c
+++ b/drivers/base/regmap/regmap-mdio.c
@@ -14,7 +14,7 @@ static int regmap_mdio_read(struct mdio_device *mdio_dev, u32 reg, unsigned int
 {
 	int ret;
 
-	ret = mdiobus_read(mdio_dev->bus, mdio_dev->addr, reg);
+	ret = mdiodev_read(mdio_dev, reg);
 	if (ret < 0)
 		return ret;
 
@@ -24,7 +24,7 @@ static int regmap_mdio_read(struct mdio_device *mdio_dev, u32 reg, unsigned int
 
 static int regmap_mdio_write(struct mdio_device *mdio_dev, u32 reg, unsigned int val)
 {
-	return mdiobus_write(mdio_dev->bus, mdio_dev->addr, reg, val);
+	return mdiodev_write(mdio_dev, reg, val);
 }
 
 static int regmap_mdio_c22_read(void *context, unsigned int reg, unsigned int *val)
@@ -44,7 +44,7 @@ static int regmap_mdio_c22_write(void *context, unsigned int reg, unsigned int v
 	if (unlikely(reg & ~REGNUM_C22_MASK))
 		return -ENXIO;
 
-	return mdiobus_write(mdio_dev->bus, mdio_dev->addr, reg, val);
+	return mdiodev_write(mdio_dev, reg, val);
 }
 
 static const struct regmap_bus regmap_mdio_c22_bus = {
diff --git a/drivers/net/dsa/xrs700x/xrs700x_mdio.c b/drivers/net/dsa/xrs700x/xrs700x_mdio.c
index d01cf1073d49..127a677d1f39 100644
--- a/drivers/net/dsa/xrs700x/xrs700x_mdio.c
+++ b/drivers/net/dsa/xrs700x/xrs700x_mdio.c
@@ -31,7 +31,7 @@ static int xrs700x_mdio_reg_read(void *context, unsigned int reg,
 
 	uval = (u16)FIELD_GET(GENMASK(31, 16), reg);
 
-	ret = mdiobus_write(mdiodev->bus, mdiodev->addr, XRS_MDIO_IBA1, uval);
+	ret = mdiodev_write(mdiodev, XRS_MDIO_IBA1, uval);
 	if (ret < 0) {
 		dev_err(dev, "xrs mdiobus_write returned %d\n", ret);
 		return ret;
@@ -39,13 +39,13 @@ static int xrs700x_mdio_reg_read(void *context, unsigned int reg,
 
 	uval = (u16)((reg & GENMASK(15, 1)) | XRS_IB_READ);
 
-	ret = mdiobus_write(mdiodev->bus, mdiodev->addr, XRS_MDIO_IBA0, uval);
+	ret = mdiodev_write(mdiodev, XRS_MDIO_IBA0, uval);
 	if (ret < 0) {
 		dev_err(dev, "xrs mdiobus_write returned %d\n", ret);
 		return ret;
 	}
 
-	ret = mdiobus_read(mdiodev->bus, mdiodev->addr, XRS_MDIO_IBD);
+	ret = mdiodev_read(mdiodev, XRS_MDIO_IBD);
 	if (ret < 0) {
 		dev_err(dev, "xrs mdiobus_read returned %d\n", ret);
 		return ret;
@@ -64,7 +64,7 @@ static int xrs700x_mdio_reg_write(void *context, unsigned int reg,
 	u16 uval;
 	int ret;
 
-	ret = mdiobus_write(mdiodev->bus, mdiodev->addr, XRS_MDIO_IBD, (u16)val);
+	ret = mdiodev_write(mdiodev, XRS_MDIO_IBD, (u16)val);
 	if (ret < 0) {
 		dev_err(dev, "xrs mdiobus_write returned %d\n", ret);
 		return ret;
@@ -72,7 +72,7 @@ static int xrs700x_mdio_reg_write(void *context, unsigned int reg,
 
 	uval = (u16)FIELD_GET(GENMASK(31, 16), reg);
 
-	ret = mdiobus_write(mdiodev->bus, mdiodev->addr, XRS_MDIO_IBA1, uval);
+	ret = mdiodev_write(mdiodev, XRS_MDIO_IBA1, uval);
 	if (ret < 0) {
 		dev_err(dev, "xrs mdiobus_write returned %d\n", ret);
 		return ret;
@@ -80,7 +80,7 @@ static int xrs700x_mdio_reg_write(void *context, unsigned int reg,
 
 	uval = (u16)((reg & GENMASK(15, 1)) | XRS_IB_WRITE);
 
-	ret = mdiobus_write(mdiodev->bus, mdiodev->addr, XRS_MDIO_IBA0, uval);
+	ret = mdiodev_write(mdiodev, XRS_MDIO_IBA0, uval);
 	if (ret < 0) {
 		dev_err(dev, "xrs mdiobus_write returned %d\n", ret);
 		return ret;
diff --git a/drivers/phy/broadcom/phy-bcm-ns-usb3.c b/drivers/phy/broadcom/phy-bcm-ns-usb3.c
index b1adaecc26f8..bbfad209c890 100644
--- a/drivers/phy/broadcom/phy-bcm-ns-usb3.c
+++ b/drivers/phy/broadcom/phy-bcm-ns-usb3.c
@@ -183,7 +183,7 @@ static int bcm_ns_usb3_mdio_phy_write(struct bcm_ns_usb3 *usb3, u16 reg,
 {
 	struct mdio_device *mdiodev = usb3->mdiodev;
 
-	return mdiobus_write(mdiodev->bus, mdiodev->addr, reg, value);
+	return mdiodev_write(mdiodev, reg, value);
 }
 
 static int bcm_ns_usb3_mdio_probe(struct mdio_device *mdiodev)
diff --git a/drivers/phy/broadcom/phy-bcm-ns2-pcie.c b/drivers/phy/broadcom/phy-bcm-ns2-pcie.c
index 4c7d11d2b378..9e7434a0d3e0 100644
--- a/drivers/phy/broadcom/phy-bcm-ns2-pcie.c
+++ b/drivers/phy/broadcom/phy-bcm-ns2-pcie.c
@@ -29,14 +29,12 @@ static int ns2_pci_phy_init(struct phy *p)
 	int rc;
 
 	/* select the AFE 100MHz block page */
-	rc = mdiobus_write(mdiodev->bus, mdiodev->addr,
-			   BLK_ADDR_REG_OFFSET, PLL_AFE1_100MHZ_BLK);
+	rc = mdiodev_write(mdiodev, BLK_ADDR_REG_OFFSET, PLL_AFE1_100MHZ_BLK);
 	if (rc)
 		goto err;
 
 	/* set the 100 MHz reference clock amplitude to 2.05 v */
-	rc = mdiobus_write(mdiodev->bus, mdiodev->addr,
-			   PLL_CLK_AMP_OFFSET, PLL_CLK_AMP_2P05V);
+	rc = mdiodev_write(mdiodev, PLL_CLK_AMP_OFFSET, PLL_CLK_AMP_2P05V);
 	if (rc)
 		goto err;
 
-- 
2.25.1


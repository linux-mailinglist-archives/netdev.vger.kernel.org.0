Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5FD81437A7F
	for <lists+netdev@lfdr.de>; Fri, 22 Oct 2021 17:59:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233469AbhJVQCA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Oct 2021 12:02:00 -0400
Received: from mail-db8eur05on2043.outbound.protection.outlook.com ([40.107.20.43]:18401
        "EHLO EUR05-DB8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S233484AbhJVQB5 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 22 Oct 2021 12:01:57 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=EeElO+0g5k3I3gfSMXMsnGNlA2xBY1d960BIWwPswhQegKr5cGo7wdsoEr3M4q7N5XvIess5NM6j3tXlfF9mfsXRhm2N5a3SPtT+FpyjGdfnsdTvjIZLYJn8ARwOV9wA5raFqVoKdwI6+u/ZHoPT5bxsc7eEdmlpzy3WbAwZhnvHWdZzZy1EOWyud18dQ+dxD55h49Ux6yc/o9iMh8gzyMLPI39gaqJDu3b5OSC8YCzBOaC3prXASgxlQmlGCNssgxGKsFgKsTUwGSRXXF5ecAmXMNECt2HyBTjQJtf8lQKLzN4qE4aV8XsSeC4tnGzcvhI18NHrfozZAQwg50S4GQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Yv2UB8kq7sV3+P4J38XEo7u7FfpYsmn0ukb6hvA6iXA=;
 b=Iodj9pAwmLZtLX/+ncL3G9JSKzjos/R5sNTCYNdg0LulEKkm+d4WvZwWNAlYWMbEeBe0Bt+05v6fyXSRC0EPZ4PMOGtlK85xDfRFzTUJhjYuL7EYH/on7OWErMfOKZJCkDUX7HfS9KFhEbN6Dis/FqObVVzOnMectDw96FmF6V0q3Vz7nnlwVE8HTnvnkb/xPAWrhD8Z9ZxvnA0Sa5t4L2MC0ljEyngwgTsiaF28dGYnRkrdiAG0MLPTIcAv7LQlfgBxMEG7t1lnJfartajT1OD2sRSYLfHurdB+4ryECf6If8S1kN96BNu9BWAmC/KRwYKn2oqnYQydhWu+unDeBg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=seco.com; dmarc=pass action=none header.from=seco.com;
 dkim=pass header.d=seco.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=secospa.onmicrosoft.com; s=selector2-secospa-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Yv2UB8kq7sV3+P4J38XEo7u7FfpYsmn0ukb6hvA6iXA=;
 b=4V7qm6emdVEzVgdss320ghXgZoHJu3QbJx7cV1+g2EWMDxAWq1mQVOdzGIMkQC9XdkFsrwtn3IEJIy66NtOauWk683bLr7E9lz1Ce3YHbnr7Q0NwTqVAeobCXQNueIo0+UUoFsOQ59CIje7PioqTFJoe0uIHXk7G7jsL7vtrMd0=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=seco.com;
Received: from DB7PR03MB4523.eurprd03.prod.outlook.com (2603:10a6:10:19::27)
 by DB7PR03MB4522.eurprd03.prod.outlook.com (2603:10a6:10:1a::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4608.17; Fri, 22 Oct
 2021 15:59:37 +0000
Received: from DB7PR03MB4523.eurprd03.prod.outlook.com
 ([fe80::a9aa:f363:66e:fadf]) by DB7PR03MB4523.eurprd03.prod.outlook.com
 ([fe80::a9aa:f363:66e:fadf%6]) with mapi id 15.20.4608.018; Fri, 22 Oct 2021
 15:59:37 +0000
From:   Sean Anderson <sean.anderson@seco.com>
To:     netdev@vger.kernel.org, Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>
Cc:     Russell King <linux@armlinux.org.uk>, linux-kernel@vger.kernel.org,
        Jakub Kicinski <kuba@kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        Sean Anderson <sean.anderson@seco.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        George McCollister <george.mccollister@gmail.com>,
        Kishon Vijay Abraham I <kishon@ti.com>,
        Mark Brown <broonie@kernel.org>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>
Subject: [net-next PATCH v2 3/3] net: Convert more users of mdiobus_* to mdiodev_*
Date:   Fri, 22 Oct 2021 11:59:14 -0400
Message-Id: <20211022155914.3347672-3-sean.anderson@seco.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20211022155914.3347672-1-sean.anderson@seco.com>
References: <20211022155914.3347672-1-sean.anderson@seco.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MN2PR01CA0036.prod.exchangelabs.com (2603:10b6:208:10c::49)
 To DB7PR03MB4523.eurprd03.prod.outlook.com (2603:10a6:10:19::27)
MIME-Version: 1.0
Received: from plantagenet.inhand.com (50.195.82.171) by MN2PR01CA0036.prod.exchangelabs.com (2603:10b6:208:10c::49) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4628.16 via Frontend Transport; Fri, 22 Oct 2021 15:59:35 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: fe371e71-69ef-4f29-7502-08d99574f2fd
X-MS-TrafficTypeDiagnostic: DB7PR03MB4522:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DB7PR03MB4522F804E1BF32E60979CEA396809@DB7PR03MB4522.eurprd03.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4941;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 1TPenzVoHuZPhV2BkrSFtO9QD/wajUXf6QlzipgzLvK7q9RkVp35qTVhzfnfRyLL2BqAz/5Vhe7XVJJD/kmt6KvO8Dw3YrUcmjw5rsX/Y95mis1ByFQrNBSi7ZR3YSlV/OqaWtsiesFtG71naMzMOC5Feg6jwhZjXOX6ekbLtJ51Ud6iIuWJeovChhqIsGUHOCKDhisQ/PzKJptWrQXkA3ZMTDDNZmbLW3if5wesHo+15pVARzpij+NN5e4Ql3RdR9tILwKMAr6dZYEePFF/4OWZyQeDeb0O3xHUwH403BQZxti+YnF/gEhelzVTLdd8ZPBOuMIOCvT3XhSzaHKxeKiuGyTauESBRU7qgfYPgHIVzBQ2Q/NFmGOE7vwd0wOZq2QWLmQWbHmaK8afrCsJa09a3EByeh5oYFXfbbst5jUpCjCVsyjayf7W44BNiBYcVMqFI0JU5/+IM8SSynl3Tz0V/Z+j7iB7X15RcRoDakI5pcoxemAWAuI3bCocMD4ED1tJqrpKhNLddhR4qoIUvQWqNPorLWzKsprFQktSANt3Z+0XV27kXeBaghgPdVndzNaQnVUMq3fIDCeQ9kRfAID3kjsqG4V9Aubu30xBQxRd0cJmUG3CnVk8oCBFfrvpjY2M5lqLMjjEaXZ5ZghNo1XcyIcgA3o9yTjCyC1M4oYVzr7xzC9Go+WYUambk1cP/oLZwBndlRABbkGAVCmKHw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB7PR03MB4523.eurprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(316002)(8936002)(110136005)(2906002)(26005)(83380400001)(66946007)(6486002)(6506007)(54906003)(5660300002)(52116002)(86362001)(7416002)(186003)(508600001)(4326008)(66476007)(36756003)(8676002)(66556008)(6666004)(44832011)(2616005)(956004)(38100700002)(38350700002)(1076003)(6512007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?r9JUmm+kioZzJD8pFutw+bA9h41Rf8jW5xb8FOiARdKgtkOTrFG9WGOhn+z3?=
 =?us-ascii?Q?wgYyoGqr0bzoVcRGab2pq5e51hI0QlnEc+ex8kP+zzzGtVND/gYTx8x4TeuS?=
 =?us-ascii?Q?XdOLpbbAxCpLE/nJr/AY3nNsZtwO4XAhP45QLTZRFDnm3L6wVeRv7XqfUIMb?=
 =?us-ascii?Q?/NnAb6gAflhNi4Ql5E64GhpHiPC5Ba6i9gGRRy29omgmpUAB+Nn+Ow9IyiBj?=
 =?us-ascii?Q?VP26sEVYjYm3DeY30T1igRvKJK9DBSvLWKfeE3c2R1ZUk2bgG7MpM1o7ZyV7?=
 =?us-ascii?Q?LY7dATzLqKCw6KoGdMxs9/oWf/UD3yoGxZ0UR+ZS5FnffWecImw9iFiRLX+0?=
 =?us-ascii?Q?WESsTtZOKF1YX4Z6nz3MSw+NMpn8EJVyHKiZTcNwXHwGZbTopcZZp/QLZsbV?=
 =?us-ascii?Q?z3HXPnre0uRdWOTHERiXXmOJs9q+wd6YBTv/w0RzEvI0beVQ9VBeN6k2Qh3e?=
 =?us-ascii?Q?b+Xgzav/a5EMbHo/4CGgKKWZ4ASLJsl3LnRQMny8/FDNWc+tTy5wC+rPFdJ2?=
 =?us-ascii?Q?YvVoGn4egmZx48pFTY9/XzVu/ZDsFNHYWQTf7K+27x+uawtJjcgRj1VCadAZ?=
 =?us-ascii?Q?vE2dHM1PKZrzeghJJqg/PngnXGgoH1tSLdIGwe6e7z6eY4z0inbML5Gjn7KM?=
 =?us-ascii?Q?UOuvaocAQJJCQmMwmrQKlqyqjzmDItqT3MoskhzETMKuMY9fZAb0MLmjnx8N?=
 =?us-ascii?Q?W1JPa/j9uD52XCgvDRO0yWgCph3tN82uw9UYKFtgXGK+5FV2YV37Jmo0SAhe?=
 =?us-ascii?Q?VNeZBNrVAsYk2s+YqJ//abOuOY5wzWOC3BCvm9JeYOOgcldDU6zB0W6YLrf5?=
 =?us-ascii?Q?y4GpQY8e9c3khcbXApCTI2Bx0Pg4Ak1/BWtRtQbZ1hQ5cXsVzikVwTs9850i?=
 =?us-ascii?Q?R5CeWDEs/ySGA3DrX9N3DZGNoNyUexMjtjzdYY3O6JsEp/dlFz1OOYsHQauh?=
 =?us-ascii?Q?DKRqBGclaIo9X65As6VP6tBBGmZAaKi5GrJTOgKJbNLwGOibV1ZoIEJpX7aN?=
 =?us-ascii?Q?AJpMYTRTzzCv5Ao1KwoLYcrremhch6NNmnUG29pWS+NMqa2Dhaqk48iEkEcn?=
 =?us-ascii?Q?gdMdnXY4cGXHbOpXS1+83FVs7/V+k9UNtkE1LIF9FG4o3gtYt8/bXPHP5LxT?=
 =?us-ascii?Q?spF9b3htvvxbHk0xcHPLn6ZfXu+aFMvjgtQ1/UvCPIBTlWV4vzj66zpdhS5Q?=
 =?us-ascii?Q?dZ8rNr6+DWhtFh7w5Ic3LOMPG7CBVh6uJ6ntlwGs35+26Ee+un9hrYXXBOOu?=
 =?us-ascii?Q?OBsXEn7VsbKe3EQ3vUQVX0jdjHEfTmQQoPZXj5l+6zLQ5cYnYkxwJvd6wTWF?=
 =?us-ascii?Q?XRtRjab0ecsNNr3hFrYUQADA?=
X-OriginatorOrg: seco.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fe371e71-69ef-4f29-7502-08d99574f2fd
X-MS-Exchange-CrossTenant-AuthSource: DB7PR03MB4523.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Oct 2021 15:59:37.6276
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: bebe97c3-6438-442e-ade3-ff17aa50e733
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: sean.anderson@seco.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB7PR03MB4522
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
Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
---
I am not too experienced with coccinelle, so pointers would be
appreciated. In particular, is it possible to convert things like

bus = mdiodev->bus;
addr = mdiodev->addr;
mdiobus_foo(bus, addr, ...);

in a generic way?

(no changes since v1)

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


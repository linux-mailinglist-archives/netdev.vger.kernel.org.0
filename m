Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CD91E66C523
	for <lists+netdev@lfdr.de>; Mon, 16 Jan 2023 17:02:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232082AbjAPQB4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Jan 2023 11:01:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43866 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231987AbjAPQBh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 Jan 2023 11:01:37 -0500
Received: from EUR05-VI1-obe.outbound.protection.outlook.com (mail-vi1eur05on2075.outbound.protection.outlook.com [40.107.21.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 79DFE2384C;
        Mon, 16 Jan 2023 08:01:31 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mRiVAjzRp2NH3+KrvquLbTw66/3/aMc8H2yphZget4lnUxcI3clendGEOJWwlC9WHCbc4EfI8VrhibC6X85Bu33P/NnD/yNkRp5ooE1AZh9ZLDTi2bz2gRZdzGCcu2tWi7SMp4rLqCRHaokk2FJTaee9cFkvSCbivee4FTKVT62+qDvuEMw3Xo9/CPR3yqTsUdwJFxVrT26Eivh+SOJkVDo0H//KNbQdRCz+7mW4KVz4wh4xLT6dNWwjGZmALIviH2ZRzMlZIa3Iap1L9khyK9tyaE6E60PU10F5hX7LA93BwCrLzKfMazX7pm9gdU5Kpcnf9MXUB6XJo7WIHUsVHA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=cvlGYZkoVn4TdDss7k7lTU4NSTFviekj5xMmkYwhZtM=;
 b=UKEOpQe8y0EP4NHZVsRyLWxFUNO5pdUZ6Cmgv7XNZIjUGwqYxN9n1PUU+XRDkHKco/z+btQ4Jdon37CPRF5qHVj2kxkQ6jZzrOh1NKZKV/t6i3xiCd50RpCuiB1b/RmcqaTd4qjv3sQW4MbSXUxJvd/IRnjSKhJ6+Xi63KkdFz6jLNxl+dumIuv+dKFDvHpYIBGGXIqZKw2zlfcxC24ANyhbf8kDtERVkgCTFE5BoZIMUxIgllflek3nEnp2H0ckuojSydsWtqZ1HJjCOJQeiZbWJ3TmznOa1ygl+pMI4oC3ZcxBN7mGz8UUktsOMLnK2qf/yEjV9jOfgu5XRDbl0w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=variscite.com; dmarc=pass action=none
 header.from=variscite.com; dkim=pass header.d=variscite.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=variscite.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=cvlGYZkoVn4TdDss7k7lTU4NSTFviekj5xMmkYwhZtM=;
 b=VrkmoEJW3mB88k2RYFra8syMQNgmT23MVwGu6LzfK/N4hyNlnZrj7rh4l8+Wa+7AJqkgjou8QOyFb5hJzjFNoiI1xdAp/a8xgrdYZWxfj/Tt7SiCdfD5YISlRgJuLmxYDiBjdaULVy+d27gdA/YfNZRQqY/+gdM2phJ1wpu4lpdP3LQW2QBlpC6RKXVvlcpK2zJiTDo1BnqcSQZ6VhMdk7liNioV3kwb5nu0AVBu+wAPPwnliBoYMAM5KwQp2Bp6C7GnncOPsXgt8xVtXefuA1+66Wq4NpcSQvu29YKKrlr0uHdbOEPIyR1iNbHq8Z1ME65qTKGO0So58dUKZbcgZg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=variscite.com;
Received: from AM6PR08MB4376.eurprd08.prod.outlook.com (2603:10a6:20b:bb::21)
 by DB9PR08MB7534.eurprd08.prod.outlook.com (2603:10a6:10:302::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5986.23; Mon, 16 Jan
 2023 16:01:27 +0000
Received: from AM6PR08MB4376.eurprd08.prod.outlook.com
 ([fe80::4e5b:51c8:1237:1fee]) by AM6PR08MB4376.eurprd08.prod.outlook.com
 ([fe80::4e5b:51c8:1237:1fee%5]) with mapi id 15.20.6002.012; Mon, 16 Jan 2023
 16:01:27 +0000
From:   Pierluigi Passaro <pierluigi.p@variscite.com>
To:     andrew@lunn.ch, hkallweit1@gmail.com, linux@armlinux.org.uk,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     eran.m@variscite.com, nate.d@variscite.com,
        francesco.f@variscite.com, pierluigi.p@variscite.com,
        pierluigi.passaro@gmail.com
Subject: [PATCH net-next v3] net: mdio: force deassert MDIO reset signal
Date:   Mon, 16 Jan 2023 17:01:14 +0100
Message-Id: <20230116160114.36467-1-pierluigi.p@variscite.com>
X-Mailer: git-send-email 2.37.2
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: ZR2P278CA0069.CHEP278.PROD.OUTLOOK.COM
 (2603:10a6:910:52::15) To AM6PR08MB4376.eurprd08.prod.outlook.com
 (2603:10a6:20b:bb::21)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: AM6PR08MB4376:EE_|DB9PR08MB7534:EE_
X-MS-Office365-Filtering-Correlation-Id: f1316f50-266b-4e78-f9f0-08daf7daecdf
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: F53BOghxwHFf0vavV8CJPGSJTAg/h1n20dwDRJR/Nmo5vHKrOhlECio6qvsjKijckI5Z2yIl6IRP1LZ9CkweDj4rQC7lM62dPo9vASI3m6DM4Gt29qMPOAhP0gVYPOvKzELBBwPfB0nsVopFSDNtYGN6pDpKNsdEq50XAHHJR3ZHdXtBktV40O62W3bOpAf5bTJJI3SYEK/btjHhQiZUxQCYGXpHITx+z22nOyU3OtBuST4uXn0bp2whZcG2BWyJTdskDHjShXw/Yj8BZTiFYabaXKD86wIQQn7hZ8X1bV9TysAUFe1gc35Bp/u6Jmaz7PrMwawzP6jXl2mCUXgsRZH7f5xA2DQT81k2y8Ur6oJ2Kx1cRjNgxwjjEuCu2e1OuuxD6vAmncNpj5u78+gumvVAt6p2iN82nDt3Vf2NUf5evhJ5UvfNn+PvCutt24w/KpAUM0vEcgZE6Z2WcSnzMiDPEPpKtcnRoS6PokbIGP3AiU7Ar60nhsCpyUEuzuEyu6pHlCsO+2ON4X4anODqKrwIU5j793iy2imzCjNq5qqcFLyCBtf9CVOtCJMnd4z8mpbByDGf2O3HvAK4Xz0apZZjBlihWwMle8Pa9NZ68C8cXKEA/zZsSy3ftMQFv7zEzG1u8R6Ndg+YAG3OjOdsg5WC08uJ4PnjR78UrTMM3s/NrbaZfNiTKWJCWDZHfi3/
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM6PR08MB4376.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(39850400004)(346002)(136003)(366004)(396003)(376002)(451199015)(38350700002)(38100700002)(86362001)(316002)(5660300002)(8936002)(7416002)(66946007)(41300700001)(66476007)(66556008)(2906002)(4326008)(8676002)(6512007)(26005)(1076003)(2616005)(83380400001)(186003)(6666004)(52116002)(478600001)(36756003)(6486002)(6506007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Vmqyzd3Ymf6GIQMaFhgOiotQjyuzRnCHeMB+0eghKj1XEOgnjlXs632EWp4y?=
 =?us-ascii?Q?k1abazxP40U+LnOimnV7ynvU63OttewgshfeE/z4NUB3S6Nvi01VvQ0rtvPD?=
 =?us-ascii?Q?o+uUbA0N/rWelnXYTTZ4FxmwhlEGvuMunn24O25E9OOJptG4BGfqWpvvWx3R?=
 =?us-ascii?Q?2CcoHMUTQtwf6hWzix/ooUNxKhTUxydsXY4CogXCSqsR0/FA+LHK2O/0NIS8?=
 =?us-ascii?Q?EWSs+w717iMAzZw1Wto13XB9sD1SiAsYfrWijqv4+aEL6LrcBYLSqAtkg4oT?=
 =?us-ascii?Q?z1Ph4FFmyK42qpymUsfZRbCYJSaT/rqmIpdJNQigynvI7pVe8eCcezpiexGv?=
 =?us-ascii?Q?mCBAbq4Ga4Ze3u+Gz9/qxy8dydhLTYKwY0v5OZfJK8HsImovG7OeDmRgcQRS?=
 =?us-ascii?Q?Waw+V7y5PhQNNn/gMlkWwBADRdo2KwHmFbKBtSuTvpcbBj3y1Ynwk7vum6qB?=
 =?us-ascii?Q?almyA3NcJDlmOeEzqRhQ6xgQUoHOmBB3/CiaAOid+NbcLxwWt9hULPNuqOAm?=
 =?us-ascii?Q?rjpwOgFdSH6v2cQqH29IYgwqTr2j5riKILxV5tK3arAycnnUvRFiCidNe8GH?=
 =?us-ascii?Q?L7Zn5PHhCC8b3nuWCYEVDDtYBqdpB0T2Lw4ZH4aY6FOmefOyEAf4PTuP3QoL?=
 =?us-ascii?Q?2uOYNSAPDeyUJee6o66VJZcvDO9v02/MSvtg+NBgxFEpgpovEQvmsAF2lOFU?=
 =?us-ascii?Q?QK+XIL9R8ybU8tmGRCMOGTNjnsaCoajVZFZAwtnP3hjsseNTUAR7skqVdXZ8?=
 =?us-ascii?Q?oQm5RLUPnUfLjgepuugN2fcGy9JEdab4lhPrFHPofVfrNZLbyhIveOT22O5q?=
 =?us-ascii?Q?JT1l0TPXgC3UlvUGlnKJuQInf7WpxVA0nWaGftuk58eJH5ztTUFD3PaIVlql?=
 =?us-ascii?Q?Z2HkMiL6muEA0t1BRIYbES9stee6T5aFQIjZbKBpYK+dNfLI2vd3wnVs2Btq?=
 =?us-ascii?Q?hynydvKKOENfkrrK8ORQC7woK2Y0/X2rPRoWNgDE6+C/HdFq0FIXYlpEz6+x?=
 =?us-ascii?Q?ypoH+ZJIKF6seWXQJbtNBqnfJ2ad3s++t64RSUUPjg62ksQCILj+UoE2KEAD?=
 =?us-ascii?Q?y0p5S0Fm7BnR0NJmg+2Zo6wKZ15OnRLr4VGy4utmYv0JrPKtrt/QhoaW39AC?=
 =?us-ascii?Q?CF8HwEo6EJvZ/JhoOsQ/y9sGGWVldaI8ZSPcjpPaWqCd0+XhbHS9pBhp6joG?=
 =?us-ascii?Q?Enah00sv3m2Xj68xT+FH2JJ8VzcyGcIokRvPsvzj7s6/Wjz7IVYToRb9f5AC?=
 =?us-ascii?Q?zyN8kaaYJxuHgeBDHYyQRbK8/ajlQyU/OWeqzhFvwA0QFdH95kf9y+8vLUel?=
 =?us-ascii?Q?8iUw5SoG6UP4EyiVO5j3RlY3/LI7VeHEIy6b82pAv0ppSpcic7YohqeRLCyp?=
 =?us-ascii?Q?K9da32FaatfD9FraQSrXdzezuY1B2bPqXhcPXT+sLIZ51402+LmmrRuGukK/?=
 =?us-ascii?Q?xG2xpD5bmC1hFNrwL3O2pXnpiUcLw4I9pMoJqBzZQwKmo4RRsaXNITtEgTeh?=
 =?us-ascii?Q?ZeM/vVMCbvnWpIP+tZxeivReXDa34GXSIrKn71ylKbwQ22GBpRX0R+F6Sv/c?=
 =?us-ascii?Q?BBSrIs9vRqBu+FEcnzhN8oDkKYHqtVucqIxFrQNuF2IZxq1gyydoVf15Vsde?=
 =?us-ascii?Q?UA=3D=3D?=
X-OriginatorOrg: variscite.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f1316f50-266b-4e78-f9f0-08daf7daecdf
X-MS-Exchange-CrossTenant-AuthSource: AM6PR08MB4376.eurprd08.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Jan 2023 16:01:27.6629
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 399ae6ac-38f4-4ef0-94a8-440b0ad581de
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Jvio7ir47z9YNLVS9iueZFOdN+7nv91d/vZNDlAcSP1lM6QHyNVN13wAOZbO0D1MBAhn7ZOjY48fYeGWt9woiF5hVSkrV+2uggqp7rwlG4I=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB9PR08MB7534
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When the reset gpio is defined within the node of the device tree
describing the PHY, the reset is initialized and managed only after
calling the fwnode_mdiobus_phy_device_register function.
However, before calling it, the MDIO communication is checked by the
get_phy_device function.
When this happens and the reset GPIO was somehow previously set down,
the get_phy_device function fails, preventing the PHY detection.
These changes force the deassert of the MDIO reset signal before
checking the MDIO channel.
The PHY may require a minimum deassert time before being responsive:
use a reasonable sleep time after forcing the deassert of the MDIO
reset signal.
Once done, free the gpio descriptor to allow managing it later.

Signed-off-by: Pierluigi Passaro <pierluigi.p@variscite.com>
Signed-off-by: FrancescoFerraro <francesco.f@variscite.com>
---
 drivers/net/mdio/fwnode_mdio.c | 26 ++++++++++++++++++++++++++
 1 file changed, 26 insertions(+)

diff --git a/drivers/net/mdio/fwnode_mdio.c b/drivers/net/mdio/fwnode_mdio.c
index b782c35c4ac1..eb146eecff5c 100644
--- a/drivers/net/mdio/fwnode_mdio.c
+++ b/drivers/net/mdio/fwnode_mdio.c
@@ -8,6 +8,8 @@
 
 #include <linux/acpi.h>
 #include <linux/fwnode_mdio.h>
+#include <linux/gpio/consumer.h>
+#include <linux/gpio/driver.h>
 #include <linux/of.h>
 #include <linux/phy.h>
 #include <linux/pse-pd/pse.h>
@@ -114,6 +116,7 @@ int fwnode_mdiobus_register_phy(struct mii_bus *bus,
 {
 	struct mii_timestamper *mii_ts = NULL;
 	struct pse_control *psec = NULL;
+	struct gpio_desc *reset_gpio;
 	struct phy_device *phy;
 	bool is_c45 = false;
 	u32 phy_id;
@@ -134,10 +137,33 @@ int fwnode_mdiobus_register_phy(struct mii_bus *bus,
 	if (rc >= 0)
 		is_c45 = true;
 
+	reset_gpio = fwnode_gpiod_get_index(child, "reset", 0, GPIOD_OUT_LOW, "PHY reset");
+	if (reset_gpio == ERR_PTR(-EPROBE_DEFER)) {
+		dev_dbg(&bus->dev, "reset signal for PHY@%u not ready\n", addr);
+		return -EPROBE_DEFER;
+	} else if (IS_ERR(reset_gpio)) {
+		if (reset_gpio == ERR_PTR(-ENOENT))
+			dev_dbg(&bus->dev, "reset signal for PHY@%u not defined\n", addr);
+		else
+			dev_dbg(&bus->dev, "failed to request reset for PHY@%u, error %ld\n", addr, PTR_ERR(reset_gpio));
+		reset_gpio = NULL;
+	} else {
+		int reset_deassert_delay = 0;
+
+		dev_dbg(&bus->dev, "deassert reset signal for PHY@%u\n", addr);
+		fwnode_property_read_u32(child, "reset-deassert-us",
+					 &reset_deassert_delay);
+		if (reset_deassert_delay)
+			fsleep(reset_deassert_delay);
+	}
+
 	if (is_c45 || fwnode_get_phy_id(child, &phy_id))
 		phy = get_phy_device(bus, addr, is_c45);
 	else
 		phy = phy_device_create(bus, addr, phy_id, 0, NULL);
+
+	gpiochip_free_own_desc(reset_gpio);
+
 	if (IS_ERR(phy)) {
 		rc = PTR_ERR(phy);
 		goto clean_mii_ts;
-- 
2.37.2


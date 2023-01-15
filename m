Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5E44966B434
	for <lists+netdev@lfdr.de>; Sun, 15 Jan 2023 22:38:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231459AbjAOViG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 15 Jan 2023 16:38:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45560 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231650AbjAOViD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 15 Jan 2023 16:38:03 -0500
Received: from EUR05-AM6-obe.outbound.protection.outlook.com (mail-am6eur05on2064.outbound.protection.outlook.com [40.107.22.64])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EFA6A18160;
        Sun, 15 Jan 2023 13:37:57 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jjlXNM2unfEG8nxV604oI474GceGgGIi8IP+HEDSdZQZ7w/O5MjScygQ91NI03OOom55VngBiqKiazOoVF8Y2dNp0n9cYK53dBY/8Pp7P/6B188ETZvHYPuhxxv405Pf1p1UdTpvZPWV+n3OHK2BoxJ9P1F1CCEB1Z27CtFzFiPsTvdzIv3xqxdsZr4pfRGgizaz2gGvtSAF+n14ua4FUYKDgrOdoH6rZQhUVm71Bwoso1K3YHkP7XOS/lGclk/hheeo69htJoMDKo7N51PbERKoZHTZIXYHO4s/Z2cM8Fijb6cdcw/i/gjGQgLQHiyTtPMW3q6xKM/qVfc3H/rYhA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=JDpZG6R01B4AYaHlUsuLgtOkzpvo1j93zGzi7+X+if8=;
 b=NoXC83YxdM7OMJQS35uJDU65bxARz5OuWCm/g0tMTYHkDAwmDCKahWWGgoC5WwxquY1I5wbjGBE60JEMFYGwoxh5qDmWfy5sE28AO3PPHSI9OWv8qjoPRMhfX7HeKPkGuw+qgvPT/ntmiW2o9gqJ9S6FjpL1WKG7mjAFLwG6OzmtFELTA6KfPJPA3TzQOnX6/sicY0ogItEvapGz+JNyByp81z4XFdi8/Lrlud61zXHZM1eNQpb5YID6f3D7GzYBQgeY6ZZwQAs1jaZzG+pZmuTOKKkl7OqhTlP7uhgdyWsYUFORyPYTTrFaWsctglQyF5r6HHweLULkZ7jyRyjoHw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=variscite.com; dmarc=pass action=none
 header.from=variscite.com; dkim=pass header.d=variscite.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=variscite.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JDpZG6R01B4AYaHlUsuLgtOkzpvo1j93zGzi7+X+if8=;
 b=HPUoCjwsU26XjYyrDUWl6H0THY6mAM1pagG7HpCgGQgmHt8qMPSpoyAMH5lHAfqpGbnzwRzpqDU6cWx6Fg1XjXIpmKvucHmhNcQdH4rZceAlPey9Lm4RP8TRvyTkFy4/syKwl2TNJHw/cp3DvANBpZt/6tOa0jAOxAYBtolgXrWLbWiIyvSk6I5mF4PsMiuEV1BLuqwJeH0TylUGbNBf84iMqgAu0X5XrTdmYRzG6FY2lui0exioHm5zAIDE/yIKpX42s6gMHJ/npQoZpgi5iI/h5+15MvYUeNUQUrVzZv5VneafoLjr7HEFA2qkbSflNdqcYCe+fQgFQWKE/3YaGw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=variscite.com;
Received: from AM6PR08MB4376.eurprd08.prod.outlook.com (2603:10a6:20b:bb::21)
 by DU0PR08MB9607.eurprd08.prod.outlook.com (2603:10a6:10:449::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5986.23; Sun, 15 Jan
 2023 21:37:55 +0000
Received: from AM6PR08MB4376.eurprd08.prod.outlook.com
 ([fe80::4e5b:51c8:1237:1fee]) by AM6PR08MB4376.eurprd08.prod.outlook.com
 ([fe80::4e5b:51c8:1237:1fee%5]) with mapi id 15.20.6002.012; Sun, 15 Jan 2023
 21:37:55 +0000
From:   Pierluigi Passaro <pierluigi.p@variscite.com>
To:     andrew@lunn.ch, hkallweit1@gmail.com, linux@armlinux.org.uk,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     eran.m@variscite.com, nate.d@variscite.com,
        francesco.f@variscite.com, pierluigi.p@variscite.com,
        pierluigi.passaro@gmail.com
Subject: [PATCH v2] net: mdio: force deassert MDIO reset signal
Date:   Sun, 15 Jan 2023 22:37:46 +0100
Message-Id: <20230115213746.26601-1-pierluigi.p@variscite.com>
X-Mailer: git-send-email 2.37.2
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: VI1PR0802CA0030.eurprd08.prod.outlook.com
 (2603:10a6:800:a9::16) To AM6PR08MB4376.eurprd08.prod.outlook.com
 (2603:10a6:20b:bb::21)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: AM6PR08MB4376:EE_|DU0PR08MB9607:EE_
X-MS-Office365-Filtering-Correlation-Id: 56c2abbb-2ae4-473a-54b0-08daf740c37c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: PCHrkV3ldmiCc85elG+pBTmT/RQUXLIWwKXp5D36ZkgIx0IjDILDEdT1L0uul4w3At19doJzrzNWxNgYCPg2KhhTdTwsNrW9k5xrNAx7B7Xvr6qxmbc5O6if665xPDruzqK/A+WQn/VgjSQhqXOpdavgIE6/cW/JzwuFNr91rxKlxxqERm25pdZJhOYQzVEEKxPJFOr7PlhSmgNnZxOJP2m7drYhugRBCf6cbBzYsGTl2MYDibPYnpSRZ6aZHMe07gOg5VMg7E4Y48FVGn01LMzZDmXaUwOxIUWZ4cU92tsuk6KPbljN0t5FzwsD5H2fdgHW4WLXq1QqWigazobPJOje0Jp7Qj0KUIcdwzfWIR6kEb2K2vhFPWF5xBYvEWg5LLf0C7tURo/4hu3KzcF5Pea6iPqUmmUWYgCvBzqhY3SbE2lBBjcPo0AqpAv5pEPgNcNjccUE8KE86cbWQj98UJrL9IhVW2/TkiMbu6XyQyMo6u1j7tbeeUV61gPmTDJIDqjelvB/cbIupq/MihTlQBq3QzD+yWZ5AH4LrWohjGCsbGl33vhuiiWto26AfJaGQIcVMXEEAdmvb0/nM5EQHAWOj/8NzpyUlCR0NNCFvacNhv9luagX9p/tjJb71NmLLgvG5cTnoHXmLiJzobvkQ4pjxmSYRZyN28N4Q7wIKPvL33iq9X4eQ0DDXGO9nWKp
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM6PR08MB4376.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(376002)(366004)(346002)(39850400004)(396003)(136003)(451199015)(36756003)(66946007)(8676002)(66476007)(66556008)(4326008)(7416002)(41300700001)(5660300002)(186003)(8936002)(83380400001)(26005)(478600001)(6512007)(6666004)(6486002)(6506007)(1076003)(316002)(52116002)(2616005)(86362001)(2906002)(38350700002)(38100700002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?MS4yVlPwGOO/ny76nJqROW2GMa3xoztoiOEMch1/6ee5f3wqDdVtpgBXCEps?=
 =?us-ascii?Q?/FkUyscK6OwmwAK1y6zUsga7CSUXcI9rpELiq24MArMJ59IKpp6XGk1fmaTy?=
 =?us-ascii?Q?7BgrJ/30/9veV1yCv3V6ohCGbbnO7RddZmhxjLSwPSB9oIBZchC0OaUXzRNn?=
 =?us-ascii?Q?T76hJ3eeGVgWDJ+PUERvv3LKKs59jKyyaO5VGqc0BVN6HVHgxtGu3IU52lHO?=
 =?us-ascii?Q?WMB2C6C1lSDJYCTpEXwDCHjMmIfn3OtX21cxfoxI0UiP3MNnNkq//MHC6EzF?=
 =?us-ascii?Q?/2X27R5YLJprmSku9isdexPOjcj/wqPTO/SFTsFcbANolPlFeM6NIqoe2dOV?=
 =?us-ascii?Q?i6DDGvPZ0T1OEHp+o0nCcnUMQxcP9oZ49NCug2M+Bwf0Uxn5LBlBIa3ZWHhC?=
 =?us-ascii?Q?iJdQUDOYpW/fYUNjypY9biUuaGIzfN8SWubiAkd3fdsuxL2zP/5t1zrP9b2f?=
 =?us-ascii?Q?4Fu1ovbXZNkmSQgdNPey45ZCBN1e2n38Ipl/NA10Zbk8EHNXptZHYoHBoBPC?=
 =?us-ascii?Q?KUsFlcUJLliEZOBJAEE4pHrq/IJYmYedsXBYAZ4SZVH71LoyHUUZj3+lkRqX?=
 =?us-ascii?Q?DuhA1eYM2yUdG4nP8Owxd1ocQTxtlnfBvWZLgAlxpusB9602qjHu+a5V9rzm?=
 =?us-ascii?Q?F3NLrjtQEW9m784gaYmgioYKL7Sk0Tc6uz88JQ09D1o1+99o6KQKeRIfIg38?=
 =?us-ascii?Q?G6OgBdnWqMRNHXD+wSflaBh9gWKKj4EIda95ukeuOUOjz8pzS0SucZ7+Ty5+?=
 =?us-ascii?Q?zHGDmsCVbOL622qiV2I2q9Ny06aQODzWgfNJ9bCTyx1BjFO3YxoV0aHqJNLp?=
 =?us-ascii?Q?pcf6XBqxl5+V/2ovROGhXCtYH6IjrsXk5y9wi0MB8e2zhNrBn8eXFRaTysmc?=
 =?us-ascii?Q?LNaJ8W+hZjkj7HYbsABEqucBianKtkpcBBCoUOm5qMBKus1Nz7a/n7Bq+LIw?=
 =?us-ascii?Q?W0kggZcfC1NU8M8Ed+lK7KLelt3qAVERlK2e8WuVh9eU7lDG12wUVjuguNg5?=
 =?us-ascii?Q?oENilCwvFG/kJaVX1RWF1ivTbHvOZu6kbKDMtt9rp8gGLbYLn4sY6Qq0Yj2L?=
 =?us-ascii?Q?vA7w67yCEeZGXDdH5c6NfqNKanQF798XDPeC2ZzOeIqnKaK9MhuRzsGkn57s?=
 =?us-ascii?Q?AFoCivOzKerKKFJQGMLQxs4Wco5oZni9qJKUS8GG7a31pRUcU2EhxXuM/ZG/?=
 =?us-ascii?Q?HpH//AF+MbNdnjnn2jarqb21p+RuG7QgLuUwjQ+Dl1yXeWuV6VeogTlwmSU6?=
 =?us-ascii?Q?dEb2MO1EupZA+dDGVH47cpVlT85dInuHhct1tgxCru11o5OGXkqcDCUO4FJT?=
 =?us-ascii?Q?p7OqreaIbaJyiWK9OdrVwL/WjDR1+mWjcis7HAq8N/PfjbkjqtsJNQLn4fMb?=
 =?us-ascii?Q?Qf/QSf1tDEyt+t0HqPniZJGEq0oXbo8Qe44fj4+msYVTMUQ8ifMuz/Fj+rML?=
 =?us-ascii?Q?hXkvu3JwFpYnYebbDVjYqHFtbqIsP6eGKrvBQYw9mrFfm7p5/UuLnt1IKMVB?=
 =?us-ascii?Q?Pj428Bp/cvCSglqa/zlYJIVYZNbYf8CkFl1jkd9hGLmt4/ly04MxSxiW0imA?=
 =?us-ascii?Q?U21UG5M+jqYkyRHhivPpOdrDJ8j4fFoByXuhjYu/SCbXp8lFkN0jwZ3Qt1v6?=
 =?us-ascii?Q?jA=3D=3D?=
X-OriginatorOrg: variscite.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 56c2abbb-2ae4-473a-54b0-08daf740c37c
X-MS-Exchange-CrossTenant-AuthSource: AM6PR08MB4376.eurprd08.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Jan 2023 21:37:55.7581
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 399ae6ac-38f4-4ef0-94a8-440b0ad581de
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: NxzHTjRBmx42lC3TzTYJjd0bAiLREcEjYp032mi141x+peZAi6SbOv1GBeL8ei+idCXLJ8pZgd/YxyYpi/LTWycHyfWgqWVRmSoo/QT0CpE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DU0PR08MB9607
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
When this happen and the reset GPIO was somehow previously set down,
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
 drivers/net/mdio/fwnode_mdio.c | 25 +++++++++++++++++++++++++
 1 file changed, 25 insertions(+)

diff --git a/drivers/net/mdio/fwnode_mdio.c b/drivers/net/mdio/fwnode_mdio.c
index b782c35c4ac1..1f4b8c4c1f60 100644
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
@@ -118,6 +120,8 @@ int fwnode_mdiobus_register_phy(struct mii_bus *bus,
 	bool is_c45 = false;
 	u32 phy_id;
 	int rc;
+	int reset_deassert_delay = 0;
+	struct gpio_desc *reset_gpio;
 
 	psec = fwnode_find_pse_control(child);
 	if (IS_ERR(psec))
@@ -134,10 +138,31 @@ int fwnode_mdiobus_register_phy(struct mii_bus *bus,
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


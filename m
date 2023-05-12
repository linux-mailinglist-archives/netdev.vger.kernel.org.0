Return-Path: <netdev+bounces-2045-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id B6C1B700110
	for <lists+netdev@lfdr.de>; Fri, 12 May 2023 09:09:24 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id C41E41C21126
	for <lists+netdev@lfdr.de>; Fri, 12 May 2023 07:09:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5C5A863C5;
	Fri, 12 May 2023 07:09:21 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 43F43138F
	for <netdev@vger.kernel.org>; Fri, 12 May 2023 07:09:21 +0000 (UTC)
Received: from APC01-SG2-obe.outbound.protection.outlook.com (mail-sgaapc01olkn2057.outbound.protection.outlook.com [40.92.53.57])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2964111B55;
	Fri, 12 May 2023 00:09:19 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jOest2PxPbkUOm7LaehBFxw6OCdkyMMZi0ztv1iRCECNeaNHPMjBB9YCpik81s61IKcC9RMeWpd8rtPsAijRWuraFQEOD6ZjHJo7W3jw4nFf+q+hKDACYPR6JRNyRHhq32qra6u8B0LweeybzpU8tnr5QfEb0PGeZd+bEE8xrCwmT4PaPoHTcQGSl1eWnPIVuYhB4eVclOMtceQqs982trgr6WztPrOyJiewKQ9oUMKqIDcDbKLuqqL13s55HAbMSU01FTuge3FW+dM6CgOK7+1/d6K1XeuoU/x5x+JYzpMn7UErj9nHUJ5dw3CXGPk9aZj40ti8zgl2KfUsFm4m5w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=B8fszxikWujlNqHtePraER4cs9gGBf+1rpVwkgOwCz4=;
 b=YFTYQzZmK617ECVx448+b9UoRo0rnCcNaQxT+eBO5PM8cW4bEwUDwkUA4izBfjRCeXEFJHQ52SYwXt9Tz6Xtl9i+cASZ+IoPOYAtjnBrhpJmrfcTjZIfp+i21jr4tT8fgx9kYn9NXguXj0xYN/Nf/e08cSi4CKF1XJfkxGDxCKjhOT1OzkeTNCL4XH8AZ7DUEKdhrjZ9TL7YjXkn4RepeIwPbA83NWSz29UoX3RuqePGvHYQhNol/+ib2lPdiAfJo8WQUjIwCYNvuBIclXc3NCzy06yY8ef6yVzZVNgZ2bgYRteKwuQwIli+7XlNWfkTFkdFWnlrOIUIHwND9r/PNQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=outlook.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=B8fszxikWujlNqHtePraER4cs9gGBf+1rpVwkgOwCz4=;
 b=b9dgr+WFKQ69ZvwjPxKoBTSfDNadXZ8MYO688HnYipaCtPGkxmmplKhYum+dTBVExQ5lYb5Z3UbLj5S8KZIMJcB4jquQ40KGjdCkuC0sWzb8jbM50DBbuyv+gbYdDft68VTA6Ns0EWE2AhYNGdvkCm43T9IaK+/Jy+qb6k/oKGf5urEHEmkeUrtYWpsdFlEA2gzXT+ZitQuuYaAbyBZmhGellq3r0HjHykrCJnhLNqGuuvBF+qqh/wTREhMcSzoDC7ASzLYmQaKD1XeG8siSvS8UYLMmdnERPipIlJCQGT+Cd8hWjxIMDUK29RWqtlXXJ3c5nRVpMxIseSSbcjgBbw==
Received: from KL1PR01MB5448.apcprd01.prod.exchangelabs.com
 (2603:1096:820:9a::12) by KL1PR01MB5447.apcprd01.prod.exchangelabs.com
 (2603:1096:820:c7::8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6387.19; Fri, 12 May
 2023 07:09:14 +0000
Received: from KL1PR01MB5448.apcprd01.prod.exchangelabs.com
 ([fe80::93cb:1631:4c4c:1821]) by KL1PR01MB5448.apcprd01.prod.exchangelabs.com
 ([fe80::93cb:1631:4c4c:1821%4]) with mapi id 15.20.6387.018; Fri, 12 May 2023
 07:09:14 +0000
From: Yan Wang <rk.code@outlook.com>
To: andrew@lunn.ch,
	hkallweit1@gmail.com,
	davem@davemloft.net,
	edumazet@google.com,
	kuba@kernel.org,
	pabeni@redhat.com,
	netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux@armlinux.org.uk
Cc: Yan Wang <rk.code@outlook.com>
Subject: [PATCH v5] net: mdiobus: Add a function to deassert reset
Date: Fri, 12 May 2023 15:08:53 +0800
Message-ID:
 <KL1PR01MB54486A247214CC72CAB5A433E6759@KL1PR01MB5448.apcprd01.prod.exchangelabs.com>
X-Mailer: git-send-email 2.17.1
Content-Type: text/plain
X-TMN: [lmqzzkbq0J9/RHf2sCJ9RDt73yXy8RKp]
X-ClientProxiedBy: SG2PR02CA0001.apcprd02.prod.outlook.com
 (2603:1096:3:17::13) To KL1PR01MB5448.apcprd01.prod.exchangelabs.com
 (2603:1096:820:9a::12)
X-Microsoft-Original-Message-ID: <20230512070853.7980-1-rk.code@outlook.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: KL1PR01MB5448:EE_|KL1PR01MB5447:EE_
X-MS-Office365-Filtering-Correlation-Id: 725310bf-64bd-4594-5644-08db52b7caf8
X-MS-Exchange-SLBlob-MailProps:
	AZnQBsB9Xmr6PcyLpofOFOY3OlYay91H39wmy5h7TMSd0wqER6AK4YGfr5csbks1rf+GbIoJLgE8XBkvGWRV6de4p/o8AgjF0bn/bT5CNMjYsAxRgFK7UErMPwPGRWBEVGa8gQ95Z/4EkvRHIri8Dn+oyy5n2ySF8q0y4jPb2/tAArkVkeKFRacyrB4bnzD5JKcbCc9uNcHSIoJ4LyXA1ayGSPs4tTfIQwPahat5Fnss9WjlAbwrqaiFIZDw6udZED6j4s6bNUOpkb3oPp8qSYOFGZcjK7I6Tc6Nf01HHHQKQbxzYGjStIATTsn7QrDCk6qpccCGF/mcC0qnjep2w7SEs1M51xGc4rDgDW9zqzyNfr5YIRbeb6L1Ui2h5NKaURBFt2MUihuro7RdGkURDOqPYlRcPHFLv+qxTjRp4Wl981U5fQH2Wrqkcsm5n9/8hyarwfWhAnHnrH/zZE0815+z0A1HF5vrk/D5TimJMYFpy2EdsQUv16/iq6hfjzQ5ucGuFFifSOrugwfDyQkcXP5wAQUp5z4Tw3/+om78ITAv2S6AhkRFfoeN9+7Pk1UpJ08iDy5+sbSIVSGL9DDXuZr1CKFySO5Tp1ONLAxEABCg6IxN1JUcNKYLsJMWWNIGbzksyCayu/BWGqNL+61kIfQcq8Eu4J1d5MR9Nf77jnyffX42MVnFJvmCqFlLnjXj/pynvr8pqBFCarns4uAE4IJFUhFhnGXSy79Mkj4cA4M5T4uqC/2TwVkw68LEE8/5LjXE12Kqox4=
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	/kMY17lFNqC1LTErI6Dz4g9RQbo037erHLsR1OVsf0py4XfIj493gMYlufiruOzeaePOWGmQsIfKgi6l8+2Y6XF7hT75yUH5lvKetskQaGFyivb/hl7/13Gq6e7cnnnX4JMiMxJ+xc+Ph2ltgf38cvxHzDSPXUiEcw5Y1szFkUUAI4CKTkVTStv935h3O1uptGFIJQXhRkFbzBJau/NZU5dW6HP7eQ+iwUsvIPGeBR6s28Uh6SPaJ+2BsjWqx8gG1vYyh+uBoiBw7Lp2v7A7mZsVc49lvTbZsBTvWIFqPf5lIImxJvCbF0M7bPlalgyToeMLa3k6BE73pnHCNAYpno5nCMXwQo+37gW4e0JluoATKs4vMFlSOdMVgybAS82u1zzEHxQme65CxkEzmDVC+oWw9B7wbf2DSfSCpVtIswl5X3Y/K0NZbWLvMB3ybG7joyIgWbKKB7qQE9kvNQW+fW2f+pMhlRhyOwrftRHxfKKcJAjOmpGiZuhute9hjS6GrKrdesYLh8Abjc7rTNSXYVG4dMeSXzG86d6Vm4F7vqwudQ7cTBM33/OOcmIpMYr4PPVV9czBQzk8M0VqLIdEIKBE7wGBQ1SHBapBevUnhe9tziVgSUz81xPWThXtZ6F4cGrbjpIq3W5OSo/LfU8+9g==
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?PzUR6VqOoTO6p32ob9CJiwvzy9aPQq0tZ6GWjeWfNDc845skRfiqFV1i8QsU?=
 =?us-ascii?Q?IXSfemocVgYsmHna2kl/9Vh3hOXFaAH/gsn0+hsAHmLDwaJJpmFl8c+jYLI2?=
 =?us-ascii?Q?0YM40L4bzhmnoLtmYhsiW72FKoG+ke21sBxTZjaqjbV92DxqSwMMqklFAgAv?=
 =?us-ascii?Q?4TsJPKHYVTqiz8+4oFBkPQCrtOBu6wH6RMnDZdK6oqcV8c06QBizbllq7Phk?=
 =?us-ascii?Q?xcZix5uq7W5aTXEYekUZYoOA7FfhpFNh4jrkEoUUp+HhsGrXa6TQmQqkNWKJ?=
 =?us-ascii?Q?nKy+rJrlOXeWItviwoy14j8gRfkgL9U7kHcIyfKA62mzbP974cTN6daOVeHj?=
 =?us-ascii?Q?eoT2da/DuMzIJoYJ7GVLzTea3HMxb0hf/Iu5HBvZOiYmJ4/S5ZW0MdrWezM2?=
 =?us-ascii?Q?8Qm4QbViVgRB3GQl39k/dqmVj8CLiW7eu112NIekVxbJGqbjvHgxzufmuHsK?=
 =?us-ascii?Q?LWqAB4gqnLDf8astlMqCpOUWFajox1ruFDzYLsQVzJIurUT0By/4n4GqozKT?=
 =?us-ascii?Q?jPZXd2gwU0I+Jyk3dBwWaHiWnnQyLHhtogChiMbd8SvKZ3uNMJ8ZuzQR57We?=
 =?us-ascii?Q?WzGX9Zy7ewlLv4kznmipC8/ExRB69kJ4giTb8EH8uT5eJ+dfR1eOVdlHui3M?=
 =?us-ascii?Q?S4SOupX6EfWqEdXejLypgzxJKrUgoBUbOzZZTcSQMaZl/qSiy5R1liyl7Ror?=
 =?us-ascii?Q?k2gFcXnp7D/bSA4+F7bayjLf7obzSLyAQFQiv7Ojd8FMlHYZ1gv+faeONWrc?=
 =?us-ascii?Q?r8qsIJ+faakvILhyRkVW+JRkUT3J48rWR6oW89UE++iUhVXmSAv4sfg/2Egy?=
 =?us-ascii?Q?4K7Bo69L0k5OkoqX2u6LuMvnZQUWptxsh8YLtk/yZXNiZgygpSMPS5XQu7/5?=
 =?us-ascii?Q?cyZv8uEEcEgs8VeccWhLqCtgbRKVT8HO0h2VyvMA71UzAstbtvWukIq+SG4B?=
 =?us-ascii?Q?gf9eHRmQbtMkFHvcRBatUySfiBSRDGeLHCH58VocAmDdpAvi6uQrBfL04Cq5?=
 =?us-ascii?Q?Uo4pGTgimX4IB/bgaWNz9AN0J6idTZ8OIsvmKg1pc5k1ticvSgtwGa9K4D2s?=
 =?us-ascii?Q?vnGSa3n6i3TwjVN6LqzXl7OQAkJH9wlhsFcOyxGy+3qmKCLIBjyxZ07XSwUQ?=
 =?us-ascii?Q?Ir/kUmTH16c5ilCVuKPnhYo4hWSDOJ4Ezi8eMLNzBA2qlIQ4IBCxjvawYgVB?=
 =?us-ascii?Q?eJNbj92cfHVUBNIzZ2KFesSUMy1LjlrVZANHmg=3D=3D?=
X-OriginatorOrg: outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 725310bf-64bd-4594-5644-08db52b7caf8
X-MS-Exchange-CrossTenant-AuthSource: KL1PR01MB5448.apcprd01.prod.exchangelabs.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 May 2023 07:09:14.3866
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 84df9e7f-e9f6-40af-b435-aaaaaaaaaaaa
X-MS-Exchange-CrossTenant-RMS-PersistedConsumerOrg:
	00000000-0000-0000-0000-000000000000
X-MS-Exchange-Transport-CrossTenantHeadersStamped: KL1PR01MB5447
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,SPF_HELO_PASS,
	SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
	version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

It is possible to mount multiple sub-devices on the mido bus.
The hardware power-on does not necessarily reset these devices.
The device may be in an uncertain state, causing the device's ID
to not be scanned.

So,before adding a reset to the scan, make sure the device is in
normal working mode.

Reported-by: kernel test robot <lkp@intel.com>
Link: https://lore.kernel.org/oe-kbuild-all/202305101702.4xW6vT72-lkp@intel.com/
Signed-off-by: Yan Wang <rk.code@outlook.com>
---
v5:
  - fixed code style.
  - Add fwnode_property_read_u32()'s return value processing.
v4: https://lore.kernel.org/all/KL1PR01MB54480925428513803DF3D03AE6749@KL1PR01MB5448.apcprd01.prod.exchangelabs.com/
  - Get pulse width and settling time from the device tree
  - Add logic for processing (PTR_ERR(reset) == -EPROBE_DEFER)
  - included <linux/goio/consumer.h>
  - fixed commit message
v3: https://lore.kernel.org/all/KL1PR01MB5448A33A549CDAD7D68945B9E6779@KL1PR01MB5448.apcprd01.prod.exchangelabs.com/
  - fixed commit message
v2: https://lore.kernel.org/all/KL1PR01MB54482416A8BE0D80EA27223CE6779@KL1PR01MB5448.apcprd01.prod.exchangelabs.com/
  - fixed commit message
  - Using gpiod_ replace gpio_
v1: https://lore.kernel.org/all/KL1PR01MB5448631F2D6F71021602117FE6769@KL1PR01MB5448.apcprd01.prod.exchangelabs.com/
  - Incorrect description of commit message.
  - The gpio-api too old
---
 drivers/net/mdio/fwnode_mdio.c | 48 ++++++++++++++++++++++++++++++++++
 1 file changed, 48 insertions(+)

diff --git a/drivers/net/mdio/fwnode_mdio.c b/drivers/net/mdio/fwnode_mdio.c
index 1183ef5e203e..02e89e25c23d 100644
--- a/drivers/net/mdio/fwnode_mdio.c
+++ b/drivers/net/mdio/fwnode_mdio.c
@@ -11,6 +11,7 @@
 #include <linux/of.h>
 #include <linux/phy.h>
 #include <linux/pse-pd/pse.h>
+#include <linux/gpio/consumer.h>
 
 MODULE_AUTHOR("Calvin Johnson <calvin.johnson@oss.nxp.com>");
 MODULE_LICENSE("GPL");
@@ -57,6 +58,51 @@ fwnode_find_mii_timestamper(struct fwnode_handle *fwnode)
 	return register_mii_timestamper(arg.np, arg.args[0]);
 }
 
+static void fwnode_mdiobus_pre_enable_phy(struct fwnode_handle *fwnode)
+{
+	unsigned int reset_deassert_delay;
+	unsigned int reset_assert_delay;
+	struct gpio_desc *reset;
+	int ret;
+
+	ret = fwnode_property_read_u32(fwnode, "reset-assert-us",
+				       &reset_assert_delay);
+	if (ret) {
+		pr_err("%pOFn: %s : The reset-assert-us property missing\n",
+		       to_of_node(fwnode), __func__);
+		return;
+	}
+
+	ret = fwnode_property_read_u32(fwnode, "reset-deassert-us",
+				       &reset_deassert_delay);
+	if (ret) {
+		pr_err("%pOFn: %s : The reset-deassert-us property missing\n",
+		       to_of_node(fwnode), __func__);
+		return;
+	}
+
+	reset = fwnode_gpiod_get_index(fwnode, "reset", 0, GPIOD_OUT_LOW, NULL);
+	if (IS_ERR(reset)) {
+		if (PTR_ERR(reset) == -EPROBE_DEFER)
+			pr_debug("%pOFn: %s: GPIOs not yet available, retry later\n",
+				 to_of_node(fwnode), __func__);
+		else
+			pr_err("%pOFn: %s: Can't get reset line property\n",
+			       to_of_node(fwnode), __func__);
+
+		return;
+	}
+
+	gpiod_set_value_cansleep(reset, gpiod_is_active_low(reset));
+	fsleep(reset_assert_delay);
+	gpiod_set_value_cansleep(reset, !gpiod_is_active_low(reset));
+	fsleep(reset_deassert_delay);
+	/*Release phy's reset line, mdiobus_register_gpiod() need to
+	 *request it
+	 */
+	gpiod_put(reset);
+}
+
 int fwnode_mdiobus_phy_device_register(struct mii_bus *mdio,
 				       struct phy_device *phy,
 				       struct fwnode_handle *child, u32 addr)
@@ -119,6 +165,8 @@ int fwnode_mdiobus_register_phy(struct mii_bus *bus,
 	u32 phy_id;
 	int rc;
 
+	fwnode_mdiobus_pre_enable_phy(child);
+
 	psec = fwnode_find_pse_control(child);
 	if (IS_ERR(psec))
 		return PTR_ERR(psec);
-- 
2.17.1



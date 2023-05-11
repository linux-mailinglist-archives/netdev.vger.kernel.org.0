Return-Path: <netdev+bounces-1672-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 686EF6FEC15
	for <lists+netdev@lfdr.de>; Thu, 11 May 2023 09:00:29 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 9F961281676
	for <lists+netdev@lfdr.de>; Thu, 11 May 2023 07:00:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B5C4D27702;
	Thu, 11 May 2023 07:00:25 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A29001773B
	for <netdev@vger.kernel.org>; Thu, 11 May 2023 07:00:25 +0000 (UTC)
Received: from APC01-SG2-obe.outbound.protection.outlook.com (mail-sgaapc01olkn2021.outbound.protection.outlook.com [40.92.53.21])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A56DC5265;
	Wed, 10 May 2023 23:59:50 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=UeUC1oJ4PUNA9rwJ9pYqBooPhiMhDCxeSx5WIM/Hw50oPgYlseCMd924Nuk93jcbkDVuOEZ+jGcT9lZT8Irqo9RqCXMkCEZR1GOkzt7IBqGBJ1PRyMs/p6EifradB+1KO5a/csPlBU7pD/IiZ7SHqLHXlqtvPqsZRwCLIeEuOKg+peOxZkJNxza7hrAvyGgkkh5bxkg5JovIHCyHLGq+N5ypVoVbck93+abKu8hYuBITHZENnrQIpXbPTdBO+5uxTx03DYvb4K7yZEge9I3eJKgJLH+IyeucvOw3NiIa0THYzfpUwDyXt/bL/jsArI+ZYcadKde7fK8uTt/a6QqV7w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=zwm3bT0OHUUbgkLF3YHQagTln1G6CZmA+7H01PQWkmk=;
 b=hY8kPlQBhjL5/RBwvMgNkOEKdCILIcfGw4UNy0224nOimD+Q9HOKSBzLfpVveN+wpqJIXDQXAmPzxHwPHb3Zv1mWMkj9zTQlVnDJlGvHMA7nC1A081sQZvNtTOGQDpviKG0tFe5VTagJO9lF4/xUcatT4Et1ouX1g8ZGaWYT3zdNTcnEuZ67hphQNqF7udszeSxsoSaCnD5V2Eg+hgg18gnB9ljP15w8+JsbTKOyujsYZoqqZm/8xkUtbnoiNeTaF6UmrOsQchKZdjD440QocLohGer0zzvX3Ywjjcsoo8QQugLLsAQIvFRuevoIlY6G+Bhftfb13OXBDMGe956THQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=outlook.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zwm3bT0OHUUbgkLF3YHQagTln1G6CZmA+7H01PQWkmk=;
 b=h5wx8J61Qoa4cRAMFiv8WHrXBgZtgRtKvO1T7aC324y0MWdycD7m48XCTPoQ7bVqcSc0WNiZmrzyaC59IUtde87ZMBAYKeGv/c+sOOAspTVOV95FJrnPddeJqj4P4YZJD2nBcr4ADS6n3BIWY9KteHIMYYoQt/YOs1CYroSGhx/y+JKPXeSAZsV7clnnuuqeskE24aChzqKyjlB1tiUaC4Yr7CAZaiatRXPQYFNbd6ChU6A7IG4Jp7WEQPv4eVc+0k/lUT7rSY7j+P3thLctYXa/LidfmA4Ja0gGcEvwGEB9JvYgEuvp880V/tgix5mOXEHCl+pT0Byuu7PMJblJHg==
Received: from KL1PR01MB5448.apcprd01.prod.exchangelabs.com
 (2603:1096:820:9a::12) by TYZPR01MB4140.apcprd01.prod.exchangelabs.com
 (2603:1096:400:1c8::7) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6363.31; Thu, 11 May
 2023 06:59:30 +0000
Received: from KL1PR01MB5448.apcprd01.prod.exchangelabs.com
 ([fe80::93cb:1631:4c4c:1821]) by KL1PR01MB5448.apcprd01.prod.exchangelabs.com
 ([fe80::93cb:1631:4c4c:1821%4]) with mapi id 15.20.6387.018; Thu, 11 May 2023
 06:59:30 +0000
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
Subject: [PATCH v4] net: mdiobus: Add a function to deassert reset
Date: Thu, 11 May 2023 14:59:09 +0800
Message-ID:
 <KL1PR01MB54480925428513803DF3D03AE6749@KL1PR01MB5448.apcprd01.prod.exchangelabs.com>
X-Mailer: git-send-email 2.17.1
Content-Type: text/plain
X-TMN: [HLsnJVlr1CdsThsnyTyvNoBu0cOg29N4]
X-ClientProxiedBy: SG2PR01CA0196.apcprd01.prod.exchangelabs.com
 (2603:1096:4:189::23) To KL1PR01MB5448.apcprd01.prod.exchangelabs.com
 (2603:1096:820:9a::12)
X-Microsoft-Original-Message-ID: <20230511065909.1920-1-rk.code@outlook.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: KL1PR01MB5448:EE_|TYZPR01MB4140:EE_
X-MS-Office365-Filtering-Correlation-Id: 91420bb8-717e-4cb3-7359-08db51ed446b
X-MS-Exchange-SLBlob-MailProps:
	ZILSnhm0P3k2XayEnZ/FXgv66CsfMCS1CpyJ1582nDelJTLmLlEk7YU7wM7TwsPqY6G+1N2g87q67s3q1apWzJrks0oeEDnEi1j81Rp/L+a1/PzPmChWOg54OJMLOIJSuG2zbpjFAyvIhbS4RgguxmE3m6aiflEtgNLbEf8JhxkXrHg3jTUnZ85Y5SvEvK/H5ZpyH6DMnEJkxCQi7GDD/85grEvj3dwaoJ0uTFLD97OS6p+ZW5GZ1pLtFoLtZCHSJ8CX/zrulFeANkG1uTH3gTqsMWSbl54Nq+YUSG949yXhx09EafcQDQJSsUbqGqzyLggYjDkZ9VlBo46WGn931V/OzcDTqgVrKXWK/k440o/bZdyLaus5sgVlhsLc3vo+DRVa9jYtA4WI7lxrJNyPBuvEfMq/uS/okpOgA8a+ooQ1ytkArSCuCjSwinWB0vgDZyCMI16eEwgFBCR8qq6lc73hqd3dyiuiuCA1fpn7AtI1DU8KjJBhbpItUfrglz0CXmuRNaLRsal5FZ2kvCB5S6qDxAg85jKebWlrxK0Ivlv16syVQ/Ei22VBbKP9bpmlNr5GAmWdZWyCgwcWLMHRTV0FkfLgdCOok+7/fsb37Qb8e97sARUvWfLAvSLOcSeR1gniAaW3D7HP0aN+do1d4qTZ6lVaWIfV7UIRVx5TGCvzgpEPIovRiVQnPqYGguc9b/peUNSuTLNmpjS7hn2NIXtl9qi1BY3rTvzGGSEdy6qYVSQlTyAAjlEpiPLeJcaNxV/t+fubGcytDCcMlJ9OUOPhO3OugW6/
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	QSmbsbyUP9UWMZitPq1Zqi4nT8vbAGw4yJb9ZxM+Bv1Ndz3OoTYH5v3tBqPDFtcU/MXS4iAcqVqgkNHiM0wkbc/mzj5LcSz7tXOEMkaQBZgO1agyZWwMNVlBOQulKPq6ncuIdpf0AIxALZ8b2QnRAdW+NKMALPkNUu8uIEFPC6huDKhV1KROypMxz9jbZql3gM7bJ42mch2HrMZ+FeXXOWQtnRzSNE6CPNpivaXYWwZ4IQ0na48nPxAQHlKTlIZa9+oCkXYflDLnzHR45ZK3ttmXpQd2TJpra5Tt45a0nwR6pkl739RTErRKbxX5Ws6xWqX9AqaM3lLdm4kuz1DVFIkZN/SLHUPQiYWSUafhvl+cwh1OnpauOPAjjhltF5c1LSkBUBGfZrpEer1FFW/O+zgbkWbSuDy81vmBsLdE2MLfl6VVcCbDt4F8JammBgXXe3X5e7yHazsCCPKzWduYoOtcsHzY7eZ7xsAytvpVGRaqKMiQeXrM/JMQbDxy9wyEN625+5NfV3fsB5ZsEhE4SrbA5Lu/L16JsYmhyGjlA1oi6S9Oqe4HCZDBQuYrGSFvDdfwFF5LY+Jv/7oRBWotPCbO25iaAk5uUjlfFJFUQqbL4Y3N84GNNeWgTVjh6wxvBpYl/vIYcBV0EsosGLrQyw==
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?25mqsSDMLg8YKFHEqIP+4YfsL/QfunTUvp+5bO0jOjcZ4O7bvWcNAagIGP75?=
 =?us-ascii?Q?6Daf8PromYzuph+mO0q2WSNBEFxCVYZcNCZ7v4Y8n1p6dIZKZsH5LhlE+2a1?=
 =?us-ascii?Q?K4q20IQxjBiAieelvxvPr8RDKn5oUWgTdQB46uj2vzY4xfQIzgX12eU79JUr?=
 =?us-ascii?Q?VM599naoRIYy5F5BQVuY5QXO7jYD6dR/ueC/Tb+Fw+wUiDvC84rsQkowxx/H?=
 =?us-ascii?Q?WO8UAXwIgmmjy8Hm7a+M1SKLkqbBkPX0/nrEA/ZiSmdXcCeOUo6X+5U+6VRf?=
 =?us-ascii?Q?7m8+qjSpGhx28227jIQjJuf/dN7bcPPQY+5/l56yKzdv3Xd6gBtefcWUTiAl?=
 =?us-ascii?Q?iVxrL27Wff9r5s8zhM6K6BA7oswEeJvwqZU3fCQUBjFSOijqVDsZSqAn2VCD?=
 =?us-ascii?Q?/4UVDg8Q1MVCMfm9nnLFBVC+hIB3OEaHfUd5p8zhOZlQxNbuDJ6Kz2lE3RBe?=
 =?us-ascii?Q?1Nq7P63GqRM2/E5id/MskLoR8FmRY151Mc64SDKwTuibi1OAsmBKs23qkFlz?=
 =?us-ascii?Q?e6eiZFpZ4LKN1iR1rx+tTkHoMQGYtcIYl0AViB7Zp5OK11W2Jh3TU5Q32Oj4?=
 =?us-ascii?Q?zB9n3KX/kbGkVpc1H30kVzdRa/Ug2rKnYPGied6jsqE08aNKPYaDs+Vzzfe/?=
 =?us-ascii?Q?0g6uNwnd6OTZZ0J3SGR3r34qw5jFozuNidBx51lE4b4zlPEWse1bHpqW+QTZ?=
 =?us-ascii?Q?89YmgWfZE3vkNWxQXDoOMJHAMwInsyAX5vFC8+wFtF/pND46Bm0XvV54iRH8?=
 =?us-ascii?Q?X7ERIgvwN1x2QgZ+uIunRkIEFO/IKnE4OeB5i7hxi5It4WgTnX9acfh5EF5G?=
 =?us-ascii?Q?NVXhPy1LaB8dM36wc8GqYFuhf2I9srR/MHPwnyhJb1mOG8VEuj9lBYTaNeDe?=
 =?us-ascii?Q?7dBhFFd1H6gf6ZV1bKuEh9gOOPzIErF/0NJEq5yNXz0iGh6FxuzzIt41AU0R?=
 =?us-ascii?Q?q9XUw8T2OoME/XVyb/QCVQy25J6SqdZsgRJzHOmNU45CcHCOG8ZNqEK2P7ap?=
 =?us-ascii?Q?Ew5TCa0gYHZxkVLUx6N/PGM861/Xl4HgxixkgLhEaFwRTCR27mhAGYxGqy2Q?=
 =?us-ascii?Q?fDtThgS5iQoiViwidYufow54leSgVvFirH7ArQ2HC+eMo/aJoh0iL9TVWYPD?=
 =?us-ascii?Q?u8Xkr4btYITjML9taHj0lQeV+F/Q9LNHsVkg4xzccobcj/CV11N7JDuwu5VL?=
 =?us-ascii?Q?Du4fildH6XYDm/zVjNisNUY46hA6I344dusUnA=3D=3D?=
X-OriginatorOrg: outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 91420bb8-717e-4cb3-7359-08db51ed446b
X-MS-Exchange-CrossTenant-AuthSource: KL1PR01MB5448.apcprd01.prod.exchangelabs.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 May 2023 06:59:30.4051
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 84df9e7f-e9f6-40af-b435-aaaaaaaaaaaa
X-MS-Exchange-CrossTenant-RMS-PersistedConsumerOrg:
	00000000-0000-0000-0000-000000000000
X-MS-Exchange-Transport-CrossTenantHeadersStamped: TYZPR01MB4140
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,RCVD_IN_MSPIKE_H2,
	SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
	autolearn_force=no version=3.4.6
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
v4:
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
 drivers/net/mdio/fwnode_mdio.c | 32 ++++++++++++++++++++++++++++++++
 1 file changed, 32 insertions(+)

diff --git a/drivers/net/mdio/fwnode_mdio.c b/drivers/net/mdio/fwnode_mdio.c
index 1183ef5e203e..9d7df6393059 100644
--- a/drivers/net/mdio/fwnode_mdio.c
+++ b/drivers/net/mdio/fwnode_mdio.c
@@ -11,6 +11,7 @@
 #include <linux/of.h>
 #include <linux/phy.h>
 #include <linux/pse-pd/pse.h>
+#include <linux/gpio/consumer.h>
 
 MODULE_AUTHOR("Calvin Johnson <calvin.johnson@oss.nxp.com>");
 MODULE_LICENSE("GPL");
@@ -57,6 +58,35 @@ fwnode_find_mii_timestamper(struct fwnode_handle *fwnode)
 	return register_mii_timestamper(arg.np, arg.args[0]);
 }
 
+static void fwnode_mdiobus_pre_enable_phy(struct fwnode_handle *fwnode)
+{
+	struct gpio_desc *reset;
+	unsigned int reset_assert_delay;
+	unsigned int reset_deassert_delay;
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
+	fwnode_property_read_u32(fwnode, "reset-assert-us",
+				 &reset_assert_delay);
+	fwnode_property_read_u32(fwnode, "reset-deassert-us",
+				 &reset_deassert_delay);
+	gpiod_set_value_cansleep(reset, 1);
+	fsleep(reset_assert_delay);
+	gpiod_set_value_cansleep(reset, 0);
+	fsleep(reset_deassert_delay);
+	/*Release phy's reset line, mdiobus_register_gpiod() need to request it*/
+	gpiod_put(reset);
+}
+
 int fwnode_mdiobus_phy_device_register(struct mii_bus *mdio,
 				       struct phy_device *phy,
 				       struct fwnode_handle *child, u32 addr)
@@ -119,6 +149,8 @@ int fwnode_mdiobus_register_phy(struct mii_bus *bus,
 	u32 phy_id;
 	int rc;
 
+	fwnode_mdiobus_pre_enable_phy(child);
+
 	psec = fwnode_find_pse_control(child);
 	if (IS_ERR(psec))
 		return PTR_ERR(psec);
-- 
2.17.1



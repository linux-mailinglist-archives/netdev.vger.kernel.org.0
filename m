Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EEA1F4CEF74
	for <lists+netdev@lfdr.de>; Mon,  7 Mar 2022 03:13:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234732AbiCGCN4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 6 Mar 2022 21:13:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54992 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234725AbiCGCNo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 6 Mar 2022 21:13:44 -0500
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2099.outbound.protection.outlook.com [40.107.93.99])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A1F901C90F;
        Sun,  6 Mar 2022 18:12:36 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Wl2UYcsNXM7OV+boPuL8DTqmbzTAChc2B0ErpvAzR83joRhnzfeHgb7PFhJV2XdOXpfIVJoHc0kOeU7uCrHAxOQAhbNN4vxDwOQhiMTpGKJ7cd5bH62/sSBoeLAxxEGmLFFU4xHVsywfFhU+oVgcp8WLwjrUVslIs2+b5+iuosEFOJYJr/u58H6gxK5C/x4JcBMHKuPeWaLmaLWMjoK3WnNw+bgXlU5eXTaAPGCebNkt6lcgXXb4F/k1Pk7epA1RCLe+cvrZ6yK6JQD/HhHU9uucGckeeLpAXq+QkLNGA0C3nbUo8/YMrMud0zOBW7Plxpg7WmYFNf7Q4iIgixdyJw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=1yHcS8+H0EQSbT6XNcAd9KChHXtk1wzd33u2GdJWRGM=;
 b=VnGScs7aKayAzdgtnX03h4kjxaiRCFHRWuOtZHEr8PO6KKOu7xvgG5VA+IRL47xbU5R0gd8wxIITG5trhs5fpm689k/KdnDBzBXww99Z9pgdn/bk3YS+HVcoaKwSwR6yjzpO4S8CbwcmOs+Rzkb+QbxXnVzTbRXyRrx0FqdshXYOrvClIlTTLxXu1aE/H2mhsTDO++a6w21YygoG68j83KgxcKvOF7LrAy0NmHjKIsPbEUp2y7rO39/EvOuZjunSSoolFSC7E3MQhl4qtlHiUu8/UDs9zwKtQ10R5R53+0Z53Dco1oT+Qw1k1O1SlCfqLiC3W6dsx0IaTQo3dqVMCQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=in-advantage.com; dmarc=pass action=none
 header.from=in-advantage.com; dkim=pass header.d=in-advantage.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=inadvantage.onmicrosoft.com; s=selector2-inadvantage-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1yHcS8+H0EQSbT6XNcAd9KChHXtk1wzd33u2GdJWRGM=;
 b=gnlQwPXlLQkXxKMJFk3A0PqX6cgTvvEsJkJCcnKwvj/SfUqCA7S81QRUUPzR0RCLBSX9DtMscHtpJrfmz2vPGUuymu5W1Toz2UGERJ5na+odR6pL4bAudvaAqXkUdOUUOuzJEEq1Bkvv8HYVaZfZP0SqNFz6PlF6Xo+QSqkVkR8=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=in-advantage.com;
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37) by SA2PR10MB4553.namprd10.prod.outlook.com
 (2603:10b6:806:11a::12) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5038.14; Mon, 7 Mar
 2022 02:12:35 +0000
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::7c:dc80:7f24:67c5]) by MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::7c:dc80:7f24:67c5%6]) with mapi id 15.20.5038.026; Mon, 7 Mar 2022
 02:12:35 +0000
From:   Colin Foster <colin.foster@in-advantage.com>
To:     linux-arm-kernel@lists.infradead.org, linux-gpio@vger.kernel.org,
        linux-phy@lists.infradead.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Marc Zyngier <maz@kernel.org>,
        Hector Martin <marcan@marcan.st>,
        Angela Czubak <acz@semihalf.com>,
        Steen Hegelund <Steen.Hegelund@microchip.com>,
        Lars Povlsen <lars.povlsen@microchip.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Vinod Koul <vkoul@kernel.org>,
        Kishon Vijay Abraham I <kishon@ti.com>,
        Russell King <linux@armlinux.org.uk>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>, UNGLinuxDriver@microchip.com,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Lee Jones <lee.jones@linaro.org>, katie.morris@in-advantage.com
Subject: [RFC v7 net-next 12/13] net: dsa: felix: add configurable device quirks
Date:   Sun,  6 Mar 2022 18:12:07 -0800
Message-Id: <20220307021208.2406741-13-colin.foster@in-advantage.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220307021208.2406741-1-colin.foster@in-advantage.com>
References: <20220307021208.2406741-1-colin.foster@in-advantage.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MW4PR04CA0174.namprd04.prod.outlook.com
 (2603:10b6:303:85::29) To MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 474f6295-5df3-417f-79eb-08d9ffdff1a4
X-MS-TrafficTypeDiagnostic: SA2PR10MB4553:EE_
X-Microsoft-Antispam-PRVS: <SA2PR10MB455318E0B5C0F75EB1D8B259A4089@SA2PR10MB4553.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 7fbYS2lxAdmieirmWiGZLQyTZSd2T8wTP288tmKCbIAKHXxCXIKZIA+oNj7j5/285t4h0anx0VeHB2ugZQLw9Ua5kvXYIuToVlqVS2RQdPC75wpgzDIZT54ih4pN1ramP99oEJSuSca0g2EC9IfjRUDUiWtnoCx6shZY9N8O3ww6vX9iBnwQvnsJud4i4g1ZuSp3qZ8jJ5queoJE1zyymXolSbOwwKtQNbQXOyIbCteIEKownK5E9wlO2h0kuw8RH+6AU3MT7XHg9oaUWBOo++nD15Zfx7f2I4phWqL3DMC2kBJnoOhpHr9LsW0Et2a1nuNgRZzaU8CmqGsb7n2bs4KPERuuP8uZEJWnPg/KYhL5e5/uJet3QXkUvqHp/LJ2av3tfibQM5slU4+SfF71DKYUpdcUZqq9ivzhxbHnS94mgvhMPRnrkm6v0JXxaJ3ES5eCn36aqtwOi7/DNZRfbi9n67GhyxL7QTojx3LLE/9CcGQnI6cLF6wTvLD8j1ffFezT5v7zSStcqlFUnoqpVKQ93K2S4Q21UiwBj24MWgF/Q+25+Ud03JLCPSkvZeGxOUwHiUYLIzG43EMI0AQVi30Zq/ASQ4Qt/D32VK3K6ifkaUvPHr/RQg7k62UpUPVT+KDiE4W++20mf9u8ajEYOWbZymps/KQOeMuKbtiZ/t5k8lNAOZykgixDwXaNeyqiGPtNbaFwS8tabQY4pGzGig==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2351.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(376002)(42606007)(396003)(136003)(39840400004)(346002)(38350700002)(86362001)(508600001)(107886003)(38100700002)(6486002)(54906003)(36756003)(44832011)(6666004)(6506007)(66556008)(66946007)(4326008)(316002)(66476007)(8676002)(6512007)(26005)(186003)(8936002)(83380400001)(52116002)(1076003)(5660300002)(7416002)(2616005)(2906002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?P/LIXIXIelF9Z9+beZ9uAIKWcsUTs7Vr7jzuii8eVSO4o436HTtc6dR3mBEp?=
 =?us-ascii?Q?4JOlPywk1WS9fhJk0M0NVhIZOqRRb4OQFcVvMgKz7jjpwpn7EnK8hXyXcn9N?=
 =?us-ascii?Q?llkM2EzWaGCS3Tjxc6JhMDdHwtHiPTEId9Qz0CWLsl2iDi9I90yXoDmuIPPR?=
 =?us-ascii?Q?1Ihhm/tq6YIkO5dRdTAx890U0rwMAMs0zFVI06Ve0kY28BHHGgtgYjgCh66Y?=
 =?us-ascii?Q?za1ud2K/W4OXw4Y6tPLIJT2g3ZnT0cwUmy9PRjomxN53IXEXZDmU3bkKbCO1?=
 =?us-ascii?Q?pCHKCO67GhEd3/rFB9nevO/xIElc8HPXYUb6IiQN1JeMAhh06aPAjHbgTfWQ?=
 =?us-ascii?Q?sMR0YCBRLA+6QRyeaMTkm+in3mdSSmmOTPoiZGgbFp8Amc4mWm3qBH3mDds4?=
 =?us-ascii?Q?nTLw35LEK4V2xYHDyFB85pRGBBVbs73ui6eRKEHk7A5/Z5PtEy+rGG1RUAIS?=
 =?us-ascii?Q?lkhd6d8lYLY3XDPyssRhDU++STSAq+HAyuOXePGgpWSI9Tyouabx1UWOZ5Vz?=
 =?us-ascii?Q?b3NRm5A8OPyjM1T0Zy8ftpFMN9dgW3vmzXTsWDROO2RlyXLBiQm9+aejfycx?=
 =?us-ascii?Q?7HSuSLLZjxWRgZnHo31hdiCJ2tICUPqbICyiaJRsBwcUlhsLLfIrmVQIzqYu?=
 =?us-ascii?Q?BKQgKG0bPapJMN3O9K0jMENzDOr4P2Ba37slb/dyOLitsbxjKNFV0G0l9CMc?=
 =?us-ascii?Q?XZ8cWqkTFN0AZPwz6J8naWEecsOdJcddSm9FA7NNdtx+QSGjUYAUP1agGgbu?=
 =?us-ascii?Q?uFBKQr2FVhRRjbr0/CeDcDuM17hxKz/nfWBv1pPni0L1XsXRPJ+WLDv9CPZp?=
 =?us-ascii?Q?Wd+Mc4jC5FCJ4pEg235YvX9IEmH265uAMVyfLIYyy70viwPO8uleGyldDES8?=
 =?us-ascii?Q?WhKLCySdMi1sf34+kqP6P+wRlL7kNkScbDqFSO7A9Qj1zMszLg/q0LjHwEmG?=
 =?us-ascii?Q?yxGSmjuHN61eqLyWyCbdXplEittVed/+/tfrajNQ90MxBFYdZ6g8LmRNPJaZ?=
 =?us-ascii?Q?lhFrZQs++l7pW6ghxmEk6BRyDpU0QZB4Z63gOQTww/aHS2kv96U5krXiiLxi?=
 =?us-ascii?Q?n1ckCF1jW4o5mPvLgdj8VCik89PxtxqKIQVED68wxbp9UtUwBY9in4FjTt1q?=
 =?us-ascii?Q?VQWGg7gRtEcyLemhKSi/d6MDKhuvzz490moJy9Jm/Mg1vb8sFMdgx2ainZ6Y?=
 =?us-ascii?Q?IKMEDkIQvhvZbQAZxvItboXd0LMLfbf+zgDWmAUr67dA5e0tUaNJ4EHbTCLP?=
 =?us-ascii?Q?y7wQWBh7MSicD66WGfwRHTANGyUEixPSVrYFgz2GUNZqUrmpaco7/PWQ5qQF?=
 =?us-ascii?Q?fP1oBA76Q3kL3cZ1aLaZfGtwvBfLSHYXc5Lq5LTkSZyhEtWk6184p7jn/fPJ?=
 =?us-ascii?Q?aw+ZQx276Oxnphv0Za++zexgZJyeHJDtHxOKGTssSukgrTC30qsxrg1aDZFI?=
 =?us-ascii?Q?TOFAk2jTCqBHNilBsf41ED4UE8pYHA099ycKXIiPnfxt29rwMsNRgnwpg/Cv?=
 =?us-ascii?Q?ah6QYJ14eqxRlNgNBLkzK6oSD3nlksRG5HMcB6n4PKeAEjEqMMswnHwjItzx?=
 =?us-ascii?Q?DHnqORtA14RMtriLKixSwGuHaZkIkgaq0V0SuTLavkAVgzTVO7A7XeICUTzb?=
 =?us-ascii?Q?o+XX9BcUUQMrhtG6xFI7aU/hlUAPJ6v1wDvAwPBkK3bRtNk2YH1LxJmEnkxr?=
 =?us-ascii?Q?nifnnzv8MdVGxDknu6Cu/Wol1Vc=3D?=
X-OriginatorOrg: in-advantage.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 474f6295-5df3-417f-79eb-08d9ffdff1a4
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2351.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Mar 2022 02:12:34.9169
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 48e842ca-fbd8-4633-a79d-0c955a7d3aae
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: qz86541FWkEwzkMw9zmidnm3/RKputRPtYqRatm8EXo4yURmIWoukcDh+f8/LupFDlnXkHneLkQnXGblzR+7WqwpQRnM4L5DPWUDlHD30ZE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR10MB4553
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The define FELIX_MAC_QUIRKS was used directly in the felix.c shared driver.
Other devices (VSC7512 for example) don't require the same quirks, so they
need to be configured on a per-device basis.

Signed-off-by: Colin Foster <colin.foster@in-advantage.com>
Reviewed-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 drivers/net/dsa/ocelot/felix.c           | 7 +++++--
 drivers/net/dsa/ocelot/felix.h           | 1 +
 drivers/net/dsa/ocelot/felix_vsc9959.c   | 1 +
 drivers/net/dsa/ocelot/seville_vsc9953.c | 1 +
 4 files changed, 8 insertions(+), 2 deletions(-)

diff --git a/drivers/net/dsa/ocelot/felix.c b/drivers/net/dsa/ocelot/felix.c
index 7cc67097948b..7cf4afc6ed9a 100644
--- a/drivers/net/dsa/ocelot/felix.c
+++ b/drivers/net/dsa/ocelot/felix.c
@@ -997,9 +997,12 @@ static void felix_phylink_mac_link_down(struct dsa_switch *ds, int port,
 					phy_interface_t interface)
 {
 	struct ocelot *ocelot = ds->priv;
+	struct felix *felix;
+
+	felix = ocelot_to_felix(ocelot);
 
 	ocelot_phylink_mac_link_down(ocelot, port, link_an_mode, interface,
-				     FELIX_MAC_QUIRKS);
+				     felix->info->quirks);
 }
 
 static void felix_phylink_mac_link_up(struct dsa_switch *ds, int port,
@@ -1014,7 +1017,7 @@ static void felix_phylink_mac_link_up(struct dsa_switch *ds, int port,
 
 	ocelot_phylink_mac_link_up(ocelot, port, phydev, link_an_mode,
 				   interface, speed, duplex, tx_pause, rx_pause,
-				   FELIX_MAC_QUIRKS);
+				   felix->info->quirks);
 
 	if (felix->info->port_sched_speed_set)
 		felix->info->port_sched_speed_set(ocelot, port, speed);
diff --git a/drivers/net/dsa/ocelot/felix.h b/drivers/net/dsa/ocelot/felix.h
index f083b06fdfe9..0323383dee1e 100644
--- a/drivers/net/dsa/ocelot/felix.h
+++ b/drivers/net/dsa/ocelot/felix.h
@@ -33,6 +33,7 @@ struct felix_info {
 	u16				vcap_pol_base2;
 	u16				vcap_pol_max2;
 	const struct ptp_clock_info	*ptp_caps;
+	unsigned long			quirks;
 
 	/* Some Ocelot switches are integrated into the SoC without the
 	 * extraction IRQ line connected to the ARM GIC. By enabling this
diff --git a/drivers/net/dsa/ocelot/felix_vsc9959.c b/drivers/net/dsa/ocelot/felix_vsc9959.c
index ead3316742f6..1f79ed4ccef4 100644
--- a/drivers/net/dsa/ocelot/felix_vsc9959.c
+++ b/drivers/net/dsa/ocelot/felix_vsc9959.c
@@ -2220,6 +2220,7 @@ static const struct felix_info felix_info_vsc9959 = {
 	.num_mact_rows		= 2048,
 	.num_ports		= VSC9959_NUM_PORTS,
 	.num_tx_queues		= OCELOT_NUM_TC,
+	.quirks			= FELIX_MAC_QUIRKS,
 	.quirk_no_xtr_irq	= true,
 	.ptp_caps		= &vsc9959_ptp_caps,
 	.mdio_bus_alloc		= vsc9959_mdio_bus_alloc,
diff --git a/drivers/net/dsa/ocelot/seville_vsc9953.c b/drivers/net/dsa/ocelot/seville_vsc9953.c
index 68ef8f111bbe..58665abf9d02 100644
--- a/drivers/net/dsa/ocelot/seville_vsc9953.c
+++ b/drivers/net/dsa/ocelot/seville_vsc9953.c
@@ -1092,6 +1092,7 @@ static const struct felix_info seville_info_vsc9953 = {
 	.vcap_pol_max		= VSC9953_VCAP_POLICER_MAX,
 	.vcap_pol_base2		= VSC9953_VCAP_POLICER_BASE2,
 	.vcap_pol_max2		= VSC9953_VCAP_POLICER_MAX2,
+	.quirks			= FELIX_MAC_QUIRKS,
 	.num_mact_rows		= 2048,
 	.num_ports		= VSC9953_NUM_PORTS,
 	.num_tx_queues		= OCELOT_NUM_TC,
-- 
2.25.1


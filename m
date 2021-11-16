Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 59B5D452AA0
	for <lists+netdev@lfdr.de>; Tue, 16 Nov 2021 07:24:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231157AbhKPG1Z (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Nov 2021 01:27:25 -0500
Received: from mail-dm6nam10on2119.outbound.protection.outlook.com ([40.107.93.119]:14080
        "EHLO NAM10-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S230243AbhKPG0u (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 16 Nov 2021 01:26:50 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=aFRP4cu4rB7i6bxfeF+mK+x8GXs7mvjhzpIbWJbF+FXMr5FoLbmIh8uf+fuUvISiOP9vinlGOeIQJrHQ+YoJcZ0tlJue7JQgvFTXVhOZ+VchmOrSP0XLcCvSticiRqgBVIf5iRv5a47SckRxPZNgX7T8MWz0hci6/K7lK75ht0CYtc3hEvrN+8Txrr0RzB6Ob3dvhWVOjKzQXh+r8/u0H0R/s01hySHk36EkF8SCZgY79BaehaAGwtXdYs7Nwbz/2WkPgKeMO51DNiNDejLNY5Iu/+C7aDjdKn1Ksb/16oNPPq9kVP5/9wl6XzwItnyN2PF4ExrbPS4EYebE3E4hWA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=q3Fc3IRCTa7wuJ4BPfx1/ga3Gse8KsZ+tjKMWhSG/qU=;
 b=AEB0fqQePdRkv9A8uaUmpJF+lDhjRSi42nlfEenBS3bhBlbLhzqcgc5e7bwg1gupooYtcPqwEn2bC9ZW/0E1vcza1KSj7/v1EkGB9DLkCDbo/a5oyr+PfQzzbaJ/kNAdw28p8hMsVj0sNr2ZNzgKtF1FYhj7W626Nu0WyB7QAlaibgYkX76nPu3+7DTII3Ozff9+EMHWKuC60s+8+EJyiqN687bHIsFI6TONEIuFaEnksn1hOqcQo2g5GyG4GGnHQmn2UrKT5+n/nWtwFVh73f4NwIsKIZlNjlRxPCIO4HH7aXz22ofaAQkPVfHTvbjtRlwqme0y1VSWXMxGGJiTAQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=in-advantage.com; dmarc=pass action=none
 header.from=in-advantage.com; dkim=pass header.d=in-advantage.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=inadvantage.onmicrosoft.com; s=selector2-inadvantage-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=q3Fc3IRCTa7wuJ4BPfx1/ga3Gse8KsZ+tjKMWhSG/qU=;
 b=IJtNxUTuIwEysddiuIK48pRm6/vVI7mVQd2I2MmP0dPydmnysEIiATdVYezqAbzSNVuoGV/Pe2zN76q+Ou+JPS6KeORmD85TyTcjAmsMNaiqib8bIMMcsjS0tRzmbYMW/6Gwa3O/7Bw3pxXZuKdjUlq/WldHceaKNoP7GtTKjpw=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=in-advantage.com;
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37) by CO1PR10MB4722.namprd10.prod.outlook.com
 (2603:10b6:303:9e::12) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4690.27; Tue, 16 Nov
 2021 06:23:48 +0000
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::6430:b20:8805:cd9f]) by MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::6430:b20:8805:cd9f%5]) with mapi id 15.20.4690.026; Tue, 16 Nov 2021
 06:23:47 +0000
From:   Colin Foster <colin.foster@in-advantage.com>
To:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-gpio@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Rafael J. Wysocki" <rafael@kernel.org>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        UNGLinuxDriver@microchip.com, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Ioana Ciornei <ioana.ciornei@nxp.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Lars Povlsen <lars.povlsen@microchip.com>,
        Steen Hegelund <Steen.Hegelund@microchip.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Heikki Krogerus <heikki.krogerus@linux.intel.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: [RFC PATCH v4 net-next 07/23] net: dsa: ocelot: felix: add per-device-per-port quirks
Date:   Mon, 15 Nov 2021 22:23:12 -0800
Message-Id: <20211116062328.1949151-8-colin.foster@in-advantage.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20211116062328.1949151-1-colin.foster@in-advantage.com>
References: <20211116062328.1949151-1-colin.foster@in-advantage.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MWHPR11CA0028.namprd11.prod.outlook.com
 (2603:10b6:300:115::14) To MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37)
MIME-Version: 1.0
Received: from localhost.localdomain (67.185.175.147) by MWHPR11CA0028.namprd11.prod.outlook.com (2603:10b6:300:115::14) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4690.26 via Frontend Transport; Tue, 16 Nov 2021 06:23:47 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: c1aad6e7-c7ee-4452-5080-08d9a8c9a5e6
X-MS-TrafficTypeDiagnostic: CO1PR10MB4722:
X-Microsoft-Antispam-PRVS: <CO1PR10MB4722188B2CAD724E81672743A4999@CO1PR10MB4722.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8273;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 3F5e969X3sbnOvpsHIB3STZlQcwQidZKBQoPFaOzv01ek9bUzECRcB0hNEGSVhmq7VJpGxEpw2h5POW2qHfVgt2VNP2qVm5GVcWCIigm2vbB0b0AtAq5JB65FzfvNRf/l+D8CQ98rPaVsB9e9IQSLmCMNd9U4Wx6troMhdUEbnHMksjbTgN/mQu8Dt+i8U85sGIJ2v1+oCqOhCtnQP//L1rOcRbAn/gEVrXV2YVNMhOz6Wxb0e7ZE72pxUTQxYVOLNdLFz7bP9VFsNn6rwCv2rbO2h3f84mZVzd3Z4A6qt95Nzmm+oBBd4AlqzPYoBWkBk3b/l1Oj65VUH4NJIU2hhyE+vyCzePD/SfQdWCTKOsPhe69/KIJLD+XkTWk4BC2S7JhVLT1SibHlIfp4eMMj2R8MhdLpYWZvop+yHqmEpmJFoXWz2NliNXkYS4GBG7KGjfpOjMtpMo36IcOnzakQj78616SlEeylLHDhB7ZgTEQXzNkJGh/6T0C+lm5EW6QfWuw0iFOjHdnUPwmdZe0YV6H/GVx84pt000rdI8lF75h4dIFc5x44jbcklo2ysmudUA5fSlEvAlOSjKOaPaFTE+3rOEVJP5+ST7BFcdhrSau4BMa+Y5ppim+uhrrkKoP/gjG4R4VOZsnnSu+xLCwZf9pKXT09/SBtKYYLHh7G8eT7LQlQZd/wix4uVunEgwRoYKptVG4q2Xxf6V1HALrYw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2351.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(376002)(136003)(366004)(396003)(39830400003)(346002)(83380400001)(6666004)(54906003)(5660300002)(2906002)(7416002)(6486002)(44832011)(956004)(86362001)(2616005)(4326008)(316002)(508600001)(8676002)(186003)(6512007)(38100700002)(38350700002)(1076003)(8936002)(52116002)(26005)(6506007)(36756003)(66556008)(66476007)(66946007);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?GtHgoFDtgPjEYlQMe8TQpWiCS4L/izk1b3VEqnmLsiB3fbMOlN20udYmFkmK?=
 =?us-ascii?Q?D4VsSGRMxDGzveg+I2X+gHOsQ40cVyly7SyPKB2rGhNuhwhJIRTwsYVQaWJA?=
 =?us-ascii?Q?p6cLtrMauBoNnRzrF5iQmPzRkMa6H35E3o0Hj4SxljkuXFMxTPISGwm1KozG?=
 =?us-ascii?Q?pfp0cIaGQ3GZWtySAlv52izUWvugd6W102nwVFWfnkVKoUoJUOOEDqvMdDNp?=
 =?us-ascii?Q?QumxSlRXWYUPS1j873xw9scOY23BMhC/qVJ8MypHpMdR76EJCGc7t3cLt7x2?=
 =?us-ascii?Q?Rb8ij+c2FE+4F15s9aTUZ6LI7GCz/6YaWr+oWjo/4Iavp9KTOa4JTX/PS+OD?=
 =?us-ascii?Q?uUaVifnGZnaFDc9dcwXYMasEgJQGx9t+/FgW9aRHLJkWiUOqIyh3+gOLYG+4?=
 =?us-ascii?Q?CIsPqjaGL67QT/NreC2s8QSX4nBXCEB9A9nXQqrhijn+V3+Icocl7GvLqoMM?=
 =?us-ascii?Q?9lbV7UBxuCNygSaWsdrHz7qKdb3kfdYxFbykM40gDsXaRrZePu3F3u8y9CMx?=
 =?us-ascii?Q?FzzIT6RoJIGeIUOPEdjNMGiTh2fSvqUqONdFemfIcdF5zxBQuLwhJ6UKzgY7?=
 =?us-ascii?Q?7AfgDdv5gLbF9ybJ3GJo6rN9yXUqpwgrllaZeooKl0U9h+tO++8NZrXDFsLa?=
 =?us-ascii?Q?jyslNYBbDkJoWA/xGdhtrdb2M9D2hGG+Cn81hjid5GQSagBPDXnwSjJkOOD4?=
 =?us-ascii?Q?lhjVvFmvt8naLR7y5prFTDBS/h1tixszt56a9FwZzb48LHBI0BAUka1mZoKw?=
 =?us-ascii?Q?kij6gCMuokXnvijgbkYOCMGrtbigoPmTTShgugPHsNBztQLqd0MK2h60uM7g?=
 =?us-ascii?Q?Yq7tME4nP9Jt6yc2WGkDqJhgIgf+wlojPFcTzmjq6+p5NNSAti+eDv72xO3N?=
 =?us-ascii?Q?hJjh9cCJDkEFVfDiMj2EZmqAoExxumGWOhePYTW7XC1n0J9xRmL0TV+Ck1yM?=
 =?us-ascii?Q?X+IPTkDVeFwHdRc7xfCc/LpPpJZqRmSHZM53t4ottvuTL++EO6aTIQ9aKRaF?=
 =?us-ascii?Q?PjOzNUfZNiJfrGoTRI+njzF0ob3CzLiiwvZyMhO3N1/d7hSV1DkSGVKyyUFb?=
 =?us-ascii?Q?MozPA8FZbwyiZ6nOhPy+Nyf3f/t5fy205JDxOIJ/pWagEOhNFhrtFoy+zqo5?=
 =?us-ascii?Q?gboWpAzM7ynbGmFNyLd6Zf/JLAntB/f0aHNvRDIUTQvocThZU3AMm9hYqltj?=
 =?us-ascii?Q?H2FaN1LBRhnPclPVSgKyohhqAkshWgOyDdeLrAVC2i4HHpB0fyuOTlcbYlHy?=
 =?us-ascii?Q?XQSNdrk4y2UMNeKdNn1QIXNCqsCwisCM4Tt5Ik39rhGmJVGpU/jfEv/W91FZ?=
 =?us-ascii?Q?Gpiu9mKTHHOJfFwQLkPiwpiz6+Y7GrDR3E0A/ICeiCMGdRtEnDoMaUcdcu6a?=
 =?us-ascii?Q?pyEhCwy1Nmyuv8zj0OQ3GgIpg7G+J8agpzwrlz+cTghCyUz5vuwr4VWJWDq0?=
 =?us-ascii?Q?xUiqu2P28VwESN1GFulVctRWrHTeG9nX06e3RPvEfwyKJiZOYqGBUF/hVdNk?=
 =?us-ascii?Q?C7LggwrK8MI7qZkq6Xp5S/XMJNF9xCSuqpFa8IgEjZ9adza3sSzncOd/4yhO?=
 =?us-ascii?Q?WtA7AZe0FW9Pd6NYL0PSFqrXH2xTG5mMNBwXIcmXc0SNLRom8z7E3MwEo3dt?=
 =?us-ascii?Q?2WL/3bzC+8LdsOU6pNoqqtay9cBD21MocBKttYS4dXfZS4SMUAVdj69Xelwi?=
 =?us-ascii?Q?RRb4tVdakU+n6V/y1j+vATnhd5A=3D?=
X-OriginatorOrg: in-advantage.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c1aad6e7-c7ee-4452-5080-08d9a8c9a5e6
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2351.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Nov 2021 06:23:47.6522
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 48e842ca-fbd8-4633-a79d-0c955a7d3aae
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: /7JNxto0BcrqIKMeCRZFTtZ1rPlHnkTa2ISRKtBiTNtGJCXnYL3KTztwISDLXE84PZ0s67yf+aIU5k0fqzK2xPz1agJKv4Gbbh5iPZgZXIc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR10MB4722
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Initial Felix-driver products (VSC9959 and VSC9953) both had quirks
where the PCS was in charge of rate adaptation. In the case of the
VSC7512 there is a differnce in that some ports (ports 0-3) don't have
a PCS and others might have different quirks based on how they are
configured.

This adds a generic method by which any port can have any quirks that
are handled by each device's driver.

Signed-off-by: Colin Foster <colin.foster@in-advantage.com>
---
 drivers/net/dsa/ocelot/felix.c           | 20 +++++++++++++++++---
 drivers/net/dsa/ocelot/felix.h           |  4 ++++
 drivers/net/dsa/ocelot/felix_vsc9959.c   |  1 +
 drivers/net/dsa/ocelot/seville_vsc9953.c |  1 +
 4 files changed, 23 insertions(+), 3 deletions(-)

diff --git a/drivers/net/dsa/ocelot/felix.c b/drivers/net/dsa/ocelot/felix.c
index 615f6b84c688..f53db233148d 100644
--- a/drivers/net/dsa/ocelot/felix.c
+++ b/drivers/net/dsa/ocelot/felix.c
@@ -824,14 +824,25 @@ static void felix_phylink_mac_config(struct dsa_switch *ds, int port,
 		phylink_set_pcs(dp->pl, &felix->pcs[port]->pcs);
 }
 
+unsigned long felix_quirks_have_rate_adaptation(struct ocelot *ocelot,
+						int port)
+{
+	return FELIX_MAC_QUIRKS;
+}
+EXPORT_SYMBOL(felix_quirks_have_rate_adaptation);
+
 static void felix_phylink_mac_link_down(struct dsa_switch *ds, int port,
 					unsigned int link_an_mode,
 					phy_interface_t interface)
 {
 	struct ocelot *ocelot = ds->priv;
+	unsigned long quirks;
+	struct felix *felix;
 
+	felix = ocelot_to_felix(ocelot);
+	quirks = felix->info->get_quirk_for_port(ocelot, port);
 	ocelot_phylink_mac_link_down(ocelot, port, link_an_mode, interface,
-				     FELIX_MAC_QUIRKS);
+				     quirks);
 }
 
 static void felix_phylink_mac_link_up(struct dsa_switch *ds, int port,
@@ -842,11 +853,14 @@ static void felix_phylink_mac_link_up(struct dsa_switch *ds, int port,
 				      bool tx_pause, bool rx_pause)
 {
 	struct ocelot *ocelot = ds->priv;
-	struct felix *felix = ocelot_to_felix(ocelot);
+	unsigned long quirks;
+	struct felix *felix;
 
+	felix = ocelot_to_felix(ocelot);
+	quirks = felix->info->get_quirk_for_port(ocelot, port);
 	ocelot_phylink_mac_link_up(ocelot, port, phydev, link_an_mode,
 				   interface, speed, duplex, tx_pause, rx_pause,
-				   FELIX_MAC_QUIRKS);
+				   quirks);
 
 	if (felix->info->port_sched_speed_set)
 		felix->info->port_sched_speed_set(ocelot, port, speed);
diff --git a/drivers/net/dsa/ocelot/felix.h b/drivers/net/dsa/ocelot/felix.h
index 81a86bd60f03..b5fa5b7325b1 100644
--- a/drivers/net/dsa/ocelot/felix.h
+++ b/drivers/net/dsa/ocelot/felix.h
@@ -48,6 +48,7 @@ struct felix_info {
 					u32 speed);
 	struct regmap *(*init_regmap)(struct ocelot *ocelot,
 				      struct resource *res);
+	unsigned long (*get_quirk_for_port)(struct ocelot *ocelot, int port);
 };
 
 extern const struct dsa_switch_ops felix_switch_ops;
@@ -68,4 +69,7 @@ struct felix {
 struct net_device *felix_port_to_netdev(struct ocelot *ocelot, int port);
 int felix_netdev_to_port(struct net_device *dev);
 
+unsigned long felix_quirks_have_rate_adaptation(struct ocelot *ocelot,
+						int port);
+
 #endif
diff --git a/drivers/net/dsa/ocelot/felix_vsc9959.c b/drivers/net/dsa/ocelot/felix_vsc9959.c
index 789e1ff0d13b..5056f39dc47e 100644
--- a/drivers/net/dsa/ocelot/felix_vsc9959.c
+++ b/drivers/net/dsa/ocelot/felix_vsc9959.c
@@ -1368,6 +1368,7 @@ static const struct felix_info felix_info_vsc9959 = {
 	.port_setup_tc		= vsc9959_port_setup_tc,
 	.port_sched_speed_set	= vsc9959_sched_speed_set,
 	.init_regmap		= ocelot_regmap_init,
+	.get_quirk_for_port	= felix_quirks_have_rate_adaptation,
 };
 
 static irqreturn_t felix_irq_handler(int irq, void *data)
diff --git a/drivers/net/dsa/ocelot/seville_vsc9953.c b/drivers/net/dsa/ocelot/seville_vsc9953.c
index 47da279a8ff7..362ba66401d8 100644
--- a/drivers/net/dsa/ocelot/seville_vsc9953.c
+++ b/drivers/net/dsa/ocelot/seville_vsc9953.c
@@ -1088,6 +1088,7 @@ static const struct felix_info seville_info_vsc9953 = {
 	.phylink_validate	= vsc9953_phylink_validate,
 	.prevalidate_phy_mode	= vsc9953_prevalidate_phy_mode,
 	.init_regmap		= ocelot_regmap_init,
+	.get_quirk_for_port	= felix_quirks_have_rate_adaptation,
 };
 
 static int seville_probe(struct platform_device *pdev)
-- 
2.25.1


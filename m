Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 705CD46870F
	for <lists+netdev@lfdr.de>; Sat,  4 Dec 2021 19:29:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349354AbhLDScq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 4 Dec 2021 13:32:46 -0500
Received: from mail-dm6nam11on2112.outbound.protection.outlook.com ([40.107.223.112]:6588
        "EHLO NAM11-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S245439AbhLDSco (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 4 Dec 2021 13:32:44 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mfJR2lydYdwK46fOA/kJqwPz9W/K6M9G8kIcwC8XYG//JZUz90VTqjMkd7jaNL7U6QODAfGeyBhpzx9ZnrGI3nbWBj9TXTuZeUq3zuLbkGo9vHmjQnHMpj4BzoRPxupEbcKU1nb2uEkyjisMA9jFisZGKx36dqJoSc+QOVlpEGqV9AM18Yfk9QBCFUH1NLoKMYUPcyyHvS35gp74Trs0vys6njLRUUn+q38O83cntztfzNgsXYKwCRvMlYAGXgQGLGzG7u8KZSlmwGqR+qez60affj08dkcCMVRu+h5tjLdIuSQWqfL91eLSaAC8rL/urHaa0SVEKmfvUT0G0ANh2w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=NJHikKGjzYL3zY3aXozgnTIg6hgegdf2xZxHKjteHdk=;
 b=QcGsc8h0u4XRRXOsW4Vp4V0USo+xtf95Ow4dfPpo+RWJekNjlc/5DTDL1aWP5bNdI/2wPZawO1GAKioa2ahjA7L6o7XSnI2h9fPwF9JxnCeMJ/Yg0s/ITMQKGELXTxyP/zwtm0S4V4StQIexJFle0XK+KJ2Rw2i2lrX+Osc3SWNC8+f8kWZ7Pat9fAGCSaMVdlXL8UJ5Y/TlhU8jfNMIa/Q7ZkJuLWS8JxKX2Qkq8m0vX8A6mc+VJ8BDmWZ/HtXQggYdNdRpVCxvlKT73vftbb0O54ruBHtXfMlLbrKWZSky1sijnCpCVNUtcwrZHfgAYronghz9I1I5H5gROh4vhQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=in-advantage.com; dmarc=pass action=none
 header.from=in-advantage.com; dkim=pass header.d=in-advantage.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=inadvantage.onmicrosoft.com; s=selector2-inadvantage-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NJHikKGjzYL3zY3aXozgnTIg6hgegdf2xZxHKjteHdk=;
 b=aXjLOUxHoOlWJtwKhQkdsnnlrpl5V/Iz0ni5WSDBeJaTMPPUuFsWlaorpB/UA/cgVge21m2AN2qWUNWCtHX1MdE/3aXjf8JNFl3VjWeLO0hNOIzWemvym5opJQi9zNrSGdbnJ5RQGx34L6y4zEsjKjQPb58Yfj0LopKMWtxB57Q=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=in-advantage.com;
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com (10.174.170.165) by
 MWHPR1001MB2063.namprd10.prod.outlook.com (10.174.170.29) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4734.23; Sat, 4 Dec 2021 18:29:16 +0000
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::6430:b20:8805:cd9f]) by MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::6430:b20:8805:cd9f%5]) with mapi id 15.20.4755.020; Sat, 4 Dec 2021
 18:29:16 +0000
From:   Colin Foster <colin.foster@in-advantage.com>
To:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Cc:     Vladimir Oltean <vladimir.oltean@nxp.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        UNGLinuxDriver@microchip.com, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Russell King <linux@armlinux.org.uk>
Subject: [PATCH v4 net-next 1/5] net: dsa: ocelot: remove unnecessary pci_bar variables
Date:   Sat,  4 Dec 2021 10:28:54 -0800
Message-Id: <20211204182858.1052710-2-colin.foster@in-advantage.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20211204182858.1052710-1-colin.foster@in-advantage.com>
References: <20211204182858.1052710-1-colin.foster@in-advantage.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MWHPR11CA0045.namprd11.prod.outlook.com
 (2603:10b6:300:115::31) To MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37)
MIME-Version: 1.0
Received: from localhost.localdomain (67.185.175.147) by MWHPR11CA0045.namprd11.prod.outlook.com (2603:10b6:300:115::31) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4755.19 via Frontend Transport; Sat, 4 Dec 2021 18:29:08 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: d19a7717-afb1-451e-6345-08d9b753f60e
X-MS-TrafficTypeDiagnostic: MWHPR1001MB2063:
X-Microsoft-Antispam-PRVS: <MWHPR1001MB20638C047DCECFA918B22B0AA46B9@MWHPR1001MB2063.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:5236;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: +z1UqFbzXSqziFykRfXOFZXes/7oQvgSis5AFHCJR1DE3MbVPUs4aFazgs8ysV8d+wHzFiK7ro9iGyyV5SqBu6hzw/EkweT0wEU9mT73eR5zm0gWW8D1IuOtmw6D+7mupeWl8ghCDWxHnm1CcRsMjJa+pnXiAoJGywnFRPI53HdkIKRw5qgZ2K9ionjYHBWplQkhrwB6XOky5hmLZGIXLbiD4RQ++3lJ+SY71WsfkIoXvujzz1pazwI1bJnCu3Q/zJ7CbyCHzvdkPcrThN9EucItLE5u1IryMnD4Q+gFYInmEjgJpL9LgOP8UWBBS12JEe6IoEyveL4YELcTIQsMQgDLxJ8aJWZwSJVL1imEvuHIIhZXmbmX+XuiVZKPtBfQ0JliLPCiMiv/+aviWZk1s9Fwqj4GS8wO71GKvzblwau7rK5ZWPzyo0CrXetOcE5G0Q/vE5CNnqBhAeooiETlF3Nw6+sl0pDsu3Hx6DkqH4rNE1uvZUO5O7wiUgMkQfvGlwSa5AAJkDucSnPS6wJOZ+HYtZx4NPdhaA7Y4oxNoLNqL9TzLhAZm0Pz8xRButH6RHXmjchPDAoX4ThfcjlTNaYKV/qxk5BE84DC/wdQgyDAd3MsU63UyWtt0EN9rJ44ZFA3X348bTi6nxE2xw+kbCpwI5c7udqaWS0GMHpuSo6JA7E3VcuplVMVWA8nSLpFgII5dCQJBSdkayfH09/WyQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2351.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(39830400003)(366004)(376002)(136003)(346002)(396003)(8936002)(2616005)(956004)(86362001)(4326008)(508600001)(1076003)(66556008)(7416002)(6486002)(66946007)(6506007)(52116002)(6512007)(36756003)(54906003)(66476007)(8676002)(83380400001)(26005)(5660300002)(44832011)(316002)(2906002)(38350700002)(6666004)(38100700002)(186003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?EmEZPZG/80lqXqSVP1pYE+Zxxkuddy0DTvToMhHPyj09bbm+2FgCcIP/kbgz?=
 =?us-ascii?Q?K5jFKvnmZW3lm+gTU/QwK0x40gSa1dLH2tv431ZvmgeAKN4pmSgirTaut2YO?=
 =?us-ascii?Q?AaansstfYXAU5pjwOf5lIQtxI4lX2SvKa+Vl08pEqguyt0kCwNuQrDb25TYR?=
 =?us-ascii?Q?cCDXKnvYSKy3vwICvKYj74fBp4e6Ofr8mikPI7s0T5jo8b1KGeSkZ6+SbsYU?=
 =?us-ascii?Q?rhS5EoW0Ytfa/XanMtmDywQ4mK8nmDVgDX0eJi5rilrHdSqRcRzgSdk3E9Zm?=
 =?us-ascii?Q?Kisw2ClrfY4gA+T+LyW1Uu6gTW28PcT2/CUxtcxLrRuH/upc5ZO0uSS6YnmP?=
 =?us-ascii?Q?Yfbc79+dVu+I0XFIiu38G5M97EFpaR065HFT1YApe2QDxE+Qv0MqCJP/GP6a?=
 =?us-ascii?Q?cJrPfL8KDL66nxvgdr7NVEEE9+Tk+OJuCMlir1ego16RnuzrEa7eDlENptmz?=
 =?us-ascii?Q?qDz87eFX9LYPJ2eg1O/LWQjVhhcIyWOtOBWIfJ04TalERDIqPZr0Qmqa5EG1?=
 =?us-ascii?Q?b6aIBACfcapRbP5XL5LNXx4wiqzFJkZVjCfJJolvmb/fMlvRbw4XOW2fROjW?=
 =?us-ascii?Q?skw/YR+tPTGsuw0YTDsQrszkoxDgYwhnbiEBHQU8MJRPoWF7rDgTA8BsfBV7?=
 =?us-ascii?Q?KYwVzNEHwm3RvVgG/d5S9ssBxE+h9FWQNIelvnCcdhWGh9/wduhesftl6SCY?=
 =?us-ascii?Q?sgiuJhIyWQCUNwnBoJ6ae7vuowGSyz9sVpkxNHjKCRuLajq0Z5nNQa+vSODg?=
 =?us-ascii?Q?JfxxPG1rh1WVlQDPzjX9wJLOLtK74dw/cYwj5aPdFh8b6T9YXQ4I+j/yU/mM?=
 =?us-ascii?Q?o77hzggmCufO94Pp2kSZ+kZ56yOl34UtCJWoTystsiHKIaPABi7qCe5gU8pp?=
 =?us-ascii?Q?fUB7p4zhzk5mF/FQXuQH88twKncQmVxWLXTDkA14fT0fgvtECaXtPWNKvAJj?=
 =?us-ascii?Q?+F2k/+xtmOtYdxleTwG5gssizpLwa++S6nQXk/8+JmeEY1w3Hore2FZle/Es?=
 =?us-ascii?Q?d+xguoB7BKKwkJ3Rzw6OMMWSbMzj8pVTzyO/d3Gi4NR+P6lH32XAHdDZOOUn?=
 =?us-ascii?Q?C9yBOQ04rwSMEcKWNBDJmi3NdRO3bTsiW4v/5xV22Vcrmu5DRR1O+N9WJlQ9?=
 =?us-ascii?Q?mpKCQWX9AtSiLxglJP3sW7iidGTjWf6sKR5IcJq/wWVTWWBSlxFsDK0g0l8l?=
 =?us-ascii?Q?7WghcQJLQoVPyVL2QwJDcjrRUFM/O6h3Cfc97vrXpTk+wRV9LPiq6gjhkaOX?=
 =?us-ascii?Q?eTOYs6xgvzJ73lglWrVSyMeZt1MKg2+s2gFTSkj+BlIear8UQwHRDc9vfVN4?=
 =?us-ascii?Q?xBJXq9VYOUgqsnshbTIhgPlS4oppdu+L7+98JNp9u07jUnxMoYQ7xFbGfhlK?=
 =?us-ascii?Q?eRRdjOdoz745gQfRs/VP3douhjqewWGfRYaS/EAsV0oIhELiDR752T3dNU07?=
 =?us-ascii?Q?XlQQOvW+U1nKBsgJ2sPYbxhX5yroKZTdomYnFmJK819OMql3PCJEYK2jfgc8?=
 =?us-ascii?Q?mtwgIfNcTBA8ISiZVXOmv0tiFJnmJ+rcEcZlJ5BJYtEZxEKzbrS6rIzeC9pl?=
 =?us-ascii?Q?i9D5CsgC5IVW5bQ2QLLXrZ5dXDfxTOEAC6Y2n7r3LbuUmTVJJQRO7mIJhOHZ?=
 =?us-ascii?Q?nz8a6NQ6RkZrparyCS7RPtfkhY6bAeS0ARhKMIosEceAai5EpojrDl90fRSt?=
 =?us-ascii?Q?/MiGsfsixfs5PlLQTTcDfU/NYTY=3D?=
X-OriginatorOrg: in-advantage.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d19a7717-afb1-451e-6345-08d9b753f60e
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2351.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Dec 2021 18:29:08.9821
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 48e842ca-fbd8-4633-a79d-0c955a7d3aae
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: /rojjXcoDhtQ+dVtxasEhm6gUwGAxTNWNXSb3Momk2YXKhPOFeA0oQHVg1/i6eXbsiikz54UN6yKS45jwxvBe7X9oca6XH/Cf6tw1whvWqs=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR1001MB2063
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The pci_bar variables for the switch and imdio don't make sense for the
generic felix driver. Moving them to felix_vsc9959 to limit scope and
simplify the felix_info struct.

Signed-off-by: Colin Foster <colin.foster@in-advantage.com>
Reviewed-by: Vladimir Oltean <vladimir.oltean@nxp.com>
Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
---
 drivers/net/dsa/ocelot/felix.h         |  2 --
 drivers/net/dsa/ocelot/felix_vsc9959.c | 10 ++++------
 2 files changed, 4 insertions(+), 8 deletions(-)

diff --git a/drivers/net/dsa/ocelot/felix.h b/drivers/net/dsa/ocelot/felix.h
index dfe08dddd262..183dbf832db9 100644
--- a/drivers/net/dsa/ocelot/felix.h
+++ b/drivers/net/dsa/ocelot/felix.h
@@ -25,8 +25,6 @@ struct felix_info {
 	u16				vcap_pol_max;
 	u16				vcap_pol_base2;
 	u16				vcap_pol_max2;
-	int				switch_pci_bar;
-	int				imdio_pci_bar;
 	const struct ptp_clock_info	*ptp_caps;
 
 	/* Some Ocelot switches are integrated into the SoC without the
diff --git a/drivers/net/dsa/ocelot/felix_vsc9959.c b/drivers/net/dsa/ocelot/felix_vsc9959.c
index 9add86eda7e3..0676e204c804 100644
--- a/drivers/net/dsa/ocelot/felix_vsc9959.c
+++ b/drivers/net/dsa/ocelot/felix_vsc9959.c
@@ -21,6 +21,8 @@
 #define VSC9959_TAS_GCL_ENTRY_MAX	63
 #define VSC9959_VCAP_POLICER_BASE	63
 #define VSC9959_VCAP_POLICER_MAX	383
+#define VSC9959_SWITCH_PCI_BAR		4
+#define VSC9959_IMDIO_PCI_BAR		0
 
 static const u32 vsc9959_ana_regmap[] = {
 	REG(ANA_ADVLEARN,			0x0089a0),
@@ -2230,8 +2232,6 @@ static const struct felix_info felix_info_vsc9959 = {
 	.num_mact_rows		= 2048,
 	.num_ports		= 6,
 	.num_tx_queues		= OCELOT_NUM_TC,
-	.switch_pci_bar		= 4,
-	.imdio_pci_bar		= 0,
 	.quirk_no_xtr_irq	= true,
 	.ptp_caps		= &vsc9959_ptp_caps,
 	.mdio_bus_alloc		= vsc9959_mdio_bus_alloc,
@@ -2290,10 +2290,8 @@ static int felix_pci_probe(struct pci_dev *pdev,
 	ocelot->dev = &pdev->dev;
 	ocelot->num_flooding_pgids = OCELOT_NUM_TC;
 	felix->info = &felix_info_vsc9959;
-	felix->switch_base = pci_resource_start(pdev,
-						felix->info->switch_pci_bar);
-	felix->imdio_base = pci_resource_start(pdev,
-					       felix->info->imdio_pci_bar);
+	felix->switch_base = pci_resource_start(pdev, VSC9959_SWITCH_PCI_BAR);
+	felix->imdio_base = pci_resource_start(pdev, VSC9959_IMDIO_PCI_BAR);
 
 	pci_set_master(pdev);
 
-- 
2.25.1


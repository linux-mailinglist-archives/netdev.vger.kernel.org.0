Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 56DEA452A9D
	for <lists+netdev@lfdr.de>; Tue, 16 Nov 2021 07:24:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230488AbhKPG1V (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Nov 2021 01:27:21 -0500
Received: from mail-bn8nam12on2106.outbound.protection.outlook.com ([40.107.237.106]:43904
        "EHLO NAM12-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S230135AbhKPG0o (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 16 Nov 2021 01:26:44 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=YA37jrLFLA8eybtMeilwJ6QjEXrnZJ+w8E94ZaFVg+M/7OAjmam9Y8nAvWn2FxkF2tC5ak6JMXQq8uXNqFcYEBjiajPS7VbZhaEcxpSopt0vWWgM2XVK0uGUzGB1/rm/gRt7361tpJr7NArO+Jh+KPiIO4gYq7/1te2QieoOoOwxlvHLcIcuuosJhCo6RS7IdECVLwx5sj+lfkuB84cD2S4I9LG154Q7lyxS+LhEPlNGSEGJ0bQwBt3RtdAJJv4BhOj48gAeD4SP8HyMcDKgYge+CJ7hsUSuls/7i10Tv6z/PL5RbBTNl3JPXp0gu9v0HV53nuCJhSzUIr/6rk7Uqg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=UOnO6hezclrIYdoOtco2dhlOh86vjDnOu9BuYW7qkIY=;
 b=TQd/Pguv+6ThK4jTedJxqtBoaUjGkDutnfdeNOJsttHZmoZcWoVbZkVnvSGGqmriGLHpGeh8w4zNbONd05/uNWubAljeuOujeix7+A042FbP+uhxjNS1gqhDi1CEQl6SZk5RC8E+84sPpiwh66D6H4V+duhrU67i3nFxqEChgqL7QXSJ0YUenHDNLtOTmu3cMq8oVNEKyCH/vFRJyyUVyQRAOUAmKwpgJyBx6ySWpfrsPr65poPq3GJ0Lq509NvYzTrMAMIakuZXBw5xdMJx8yfxI8gDJuZrCOMVjlUdruvNcDYq4axc6uEaolPJw5YYtrRiiV8QbHRoLv+IlafFxA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=in-advantage.com; dmarc=pass action=none
 header.from=in-advantage.com; dkim=pass header.d=in-advantage.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=inadvantage.onmicrosoft.com; s=selector2-inadvantage-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=UOnO6hezclrIYdoOtco2dhlOh86vjDnOu9BuYW7qkIY=;
 b=W/0n8VXZMkE7ZvhLeX+5fh9DTARiZG+eZDU4qKc2pVSDzLBxmXIoaXlCNA+rZm5LpNM7l+k3Hb4y5Eo0tGdA0h4B2QuWRms6acaG2oVtvZqDHtsYRHXBQcDGm2H6UWZWo/6wapDH5kTr3gVfpVi4lVZMYng8RXVwbF2Nyu1WaOo=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=in-advantage.com;
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37) by MWHPR1001MB2383.namprd10.prod.outlook.com
 (2603:10b6:301:31::34) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4690.16; Tue, 16 Nov
 2021 06:23:43 +0000
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::6430:b20:8805:cd9f]) by MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::6430:b20:8805:cd9f%5]) with mapi id 15.20.4690.026; Tue, 16 Nov 2021
 06:23:43 +0000
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
Subject: [RFC PATCH v4 net-next 01/23] net: dsa: ocelot: remove unnecessary pci_bar variables
Date:   Mon, 15 Nov 2021 22:23:06 -0800
Message-Id: <20211116062328.1949151-2-colin.foster@in-advantage.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20211116062328.1949151-1-colin.foster@in-advantage.com>
References: <20211116062328.1949151-1-colin.foster@in-advantage.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MWHPR11CA0028.namprd11.prod.outlook.com
 (2603:10b6:300:115::14) To MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37)
MIME-Version: 1.0
Received: from localhost.localdomain (67.185.175.147) by MWHPR11CA0028.namprd11.prod.outlook.com (2603:10b6:300:115::14) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4690.26 via Frontend Transport; Tue, 16 Nov 2021 06:23:42 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: a8c00fa1-5892-431e-adcb-08d9a8c9a31d
X-MS-TrafficTypeDiagnostic: MWHPR1001MB2383:
X-Microsoft-Antispam-PRVS: <MWHPR1001MB23830A5B37F06A4EDA9CAB55A4999@MWHPR1001MB2383.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:5236;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: O6hZbWTvHHQ4504uhtVN5qIjmCQtsEl+BpYjf2wWX4Ykt/CKMFDcVI8JMZ4HomyXSJY5XVjnHUd29T+PtiSfrH1R+HPYWCAyVj7uCf5Mm+rL2lpI+2Z0lVy3VOhOoXZSHFKOx7SFvnGfdDQguMAaQqQG124Xa9b3J8UzvOAIgvPuOiOZnVEA5Ja9eAdq3Fe5T6GeJnPtkv/WE8mSnsESYcaELczr5K9ah+4jyUWGjCMnFlyMZtgwk6ybX7T7/lRfFku5gOm/xKkIgGzVlyvZ2CPQuFnGMyVtT2yHyXcJVal5mJl+cS2FUYYyBKT8syE3eLPECZTp/xUa52Da4SlSw9G7134x7ynQjlDSAB0bO389xO4F/LcZE1Mgwcac+eDhawMQQ9keOQXCxQj8EetUZxpcTkkls5Lfd6RNaOFOIftWoEJbsIXlHjWj3Yvd6A/XcoUV/IpbxVoHeW1lp6GXN+q46xbYqkn/sNkN6sy4RdvXbRcEcGxFb3ljUvigiD/9GFAmF9Muh0QJCfLYauFCVizukobzmRI1e0QWCDBkHZWYDKgjSy4roni3z+rFjvYg7rT4c3SdzCxB5pWVasP6kgDvl6nsTN61JNMBL+rShzMQcQBchOil3QNQNOmpC4zBMyEr2mMf8Ir1OdwT0C7wUvfJIykKowC9cd+lbili3JBwkQegBQtRO8ceH8cM0Fi3kmcSS/vpvdCVAlfLBh64Uw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2351.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(376002)(39830400003)(136003)(366004)(346002)(396003)(6512007)(54906003)(316002)(4326008)(83380400001)(8676002)(86362001)(44832011)(1076003)(2906002)(66946007)(38100700002)(38350700002)(508600001)(956004)(26005)(66476007)(66556008)(6666004)(6486002)(6506007)(52116002)(5660300002)(36756003)(7416002)(8936002)(186003)(2616005);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?L+evD8vh1JGvX2DYFeyVZAZDXc2YBO05u9aRvAj1FAkwGTA/kAy7AU+72r4x?=
 =?us-ascii?Q?7gCVK/DpjO+2tg0o1dMp5F3Z1XcZ0xRtRLhGXHYMDIEJJqGJRCeUhppaqnMB?=
 =?us-ascii?Q?8hLJm6aTql9bT92nGD5MqpA7IUcegF5MxmUmcD+NKPdRtTalwdsX9hah79D9?=
 =?us-ascii?Q?ldUhpNMS5lvVRNmecbN8xfTy4P3cJVh8zJxbj8kpYylaTfGVEY8ljvFX6Dw0?=
 =?us-ascii?Q?ff3oF+qLHL/e7wEsRyetVI/LA7QwqW7GMtvvtizphbRMoDsYEqAdOyBDg/yu?=
 =?us-ascii?Q?noYF/YQnf/OFjeXppAcKRVIyXqXkuA2/oe1aX4BM+fH56xxqR9av/GXwahVq?=
 =?us-ascii?Q?qt5OHAUIIeZ/cAoTa9AcMQNrBGCB+FToOYR8oXAWCZ+ODpTuUZUe/mw9XESJ?=
 =?us-ascii?Q?8iL88dSEORsIqO2azKHsC02vlxcO6E6M9s4T5ZjoBiiAZDbmDmgr4fSBC2EI?=
 =?us-ascii?Q?pZT6My+Q8EHcmLmVa1xNp7mGJul6qEBRoGsHf5Hz5XJD1iW+Yv54EcAF4n8U?=
 =?us-ascii?Q?bS5zlGZpWdrqPBKHs7gvPCpe7HJG8vgxUtaufu8hBM1qsO6D02znbiDOqiwi?=
 =?us-ascii?Q?MUPmVKlZKNMzvAXnOVIx8V9UA+19G8qHsQ3InJBvOrYH/8pXIHrbW6wieQpj?=
 =?us-ascii?Q?EBrlOpq08xLdiHgNyL324q0HJ9joT4QDjURHimmI4pwODPyDvW3itsU9ho+r?=
 =?us-ascii?Q?owv4T2l/SkqJcUjhugF56/jATz6VYiW3dLNVi3u0JpRYybqKtTNQYmiuueHJ?=
 =?us-ascii?Q?95HFXmKMTAjQv3qdSHcVyJCC4LqGx2MY5PPoB1rHELa2gexX8s+zyPeBiUan?=
 =?us-ascii?Q?hTVFL7ULo4b5fyz58EMCqOYfgvAYopmVQMYZDnzeIT+OFVzhMZRmq0Emjytj?=
 =?us-ascii?Q?6l/CXHiHlPO1T6ptcJTxpD+zjCIpxrVY1rOtvSSrI7LYT5lDc68lTYvpaKMT?=
 =?us-ascii?Q?cnhUocnhdpY//7vmAL/H12hEbIaxKhCc5F5rYKARlSf9hnIc0j+bqHk2g2en?=
 =?us-ascii?Q?pYCHeIIlxr5/TwiB+Y6W+yx/DfqeTjRtnQVUieIDSvqd7B1E+LIcdh1raMgG?=
 =?us-ascii?Q?Y+hiTouDY1tKaTywlSC1zDFDhrMtPSWRhDiJxpmZpLkvHD5o3zWPgWGWj9Zd?=
 =?us-ascii?Q?fRCDFZBvfUdTNocTxAVWJ4SQfZqU85eQCTdzuutc+kXHw0u6/P1VWh2oDOHQ?=
 =?us-ascii?Q?kVEKxNNDdO0m2FwIHDj+EjVc0oNtVAGM7siwWMmo2cCNPfIMNHCX2vqoznw2?=
 =?us-ascii?Q?xxCZMT4i66qI97DpNZb3k/oPeXdTP8iRjHdF2P0Vqxjm6hRIVLYn629+P5qq?=
 =?us-ascii?Q?XRI2ZyBqa9AuT0D+ejjckOnZnsixU7ZSVKM/AW82bmdGxuCnOE4iNOgZnHEk?=
 =?us-ascii?Q?PDYgxChRZjWOl7RgNPXP40VowSm53r4fagnn4Ef8/AKTtUd9x1glqU7H60uB?=
 =?us-ascii?Q?3DNlRI2/u9NYX/dtOTz5246KFcvp5nzgskYib4kfUd9ulNDbByhwF9NlaZ3s?=
 =?us-ascii?Q?8LSbAeNFDoJn8xbovYh54KiHGNAfJ+q0bba6T68B/i9UQf+JlJon7/DyySlv?=
 =?us-ascii?Q?9PIj2UII7NSL3j6gfI2FE07T4CreHmqQbDF83PyCz7Z9y7gHU+FyyF6xY7VJ?=
 =?us-ascii?Q?tI2yEEP7Z3zAMJ+LGaMr2D6O5vRfmeHe6YVwgNeAgegQmzj5N26B0IIJoJvY?=
 =?us-ascii?Q?9GojkFQe/FVyC6YfSqNzwIvRFc8=3D?=
X-OriginatorOrg: in-advantage.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a8c00fa1-5892-431e-adcb-08d9a8c9a31d
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2351.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Nov 2021 06:23:43.0018
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 48e842ca-fbd8-4633-a79d-0c955a7d3aae
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 4piEpF/bV2Rowv3hbRjrwDj9z07GkF7esUds4RlXbIifn4bU2U3K2nx1vZbrx+9pPOMrDGQRFT4hDxZovfDrGnfDgZAOjqndZIaAl1/BFec=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR1001MB2383
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The pci_bar variables for the switch and imdio don't make sense for the
generic felix driver. Moving them to felix_vsc9959 to limit scope and
simplify the felix_info struct.

Signed-off-by: Colin Foster <colin.foster@in-advantage.com>
Reviewed-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 drivers/net/dsa/ocelot/felix.h         |  2 --
 drivers/net/dsa/ocelot/felix_vsc9959.c | 11 +++++------
 2 files changed, 5 insertions(+), 8 deletions(-)

diff --git a/drivers/net/dsa/ocelot/felix.h b/drivers/net/dsa/ocelot/felix.h
index be3e42e135c0..d7da307fc071 100644
--- a/drivers/net/dsa/ocelot/felix.h
+++ b/drivers/net/dsa/ocelot/felix.h
@@ -21,8 +21,6 @@ struct felix_info {
 	int				num_ports;
 	int				num_tx_queues;
 	struct vcap_props		*vcap;
-	int				switch_pci_bar;
-	int				imdio_pci_bar;
 	const struct ptp_clock_info	*ptp_caps;
 
 	/* Some Ocelot switches are integrated into the SoC without the
diff --git a/drivers/net/dsa/ocelot/felix_vsc9959.c b/drivers/net/dsa/ocelot/felix_vsc9959.c
index 45c5ec7a83ea..0b3ccfd54603 100644
--- a/drivers/net/dsa/ocelot/felix_vsc9959.c
+++ b/drivers/net/dsa/ocelot/felix_vsc9959.c
@@ -1357,8 +1357,6 @@ static const struct felix_info felix_info_vsc9959 = {
 	.num_mact_rows		= 2048,
 	.num_ports		= 6,
 	.num_tx_queues		= OCELOT_NUM_TC,
-	.switch_pci_bar		= 4,
-	.imdio_pci_bar		= 0,
 	.quirk_no_xtr_irq	= true,
 	.ptp_caps		= &vsc9959_ptp_caps,
 	.mdio_bus_alloc		= vsc9959_mdio_bus_alloc,
@@ -1386,6 +1384,9 @@ static irqreturn_t felix_irq_handler(int irq, void *data)
 	return IRQ_HANDLED;
 }
 
+#define VSC9959_SWITCH_PCI_BAR 4
+#define VSC9959_IMDIO_PCI_BAR 0
+
 static int felix_pci_probe(struct pci_dev *pdev,
 			   const struct pci_device_id *id)
 {
@@ -1417,10 +1418,8 @@ static int felix_pci_probe(struct pci_dev *pdev,
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


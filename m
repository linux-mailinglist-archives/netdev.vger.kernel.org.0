Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D2F613C3670
	for <lists+netdev@lfdr.de>; Sat, 10 Jul 2021 21:27:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231328AbhGJT3R (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 10 Jul 2021 15:29:17 -0400
Received: from mail-bn7nam10on2107.outbound.protection.outlook.com ([40.107.92.107]:9249
        "EHLO NAM10-BN7-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229771AbhGJT3I (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 10 Jul 2021 15:29:08 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=b4Aqz1e156HUuac4XWyOwsJGxYUcYsRdoST1J88BtHjriY3swqIqx8s8IixgYj/lF951yE6X23PDcaw3vOg4lj5/ZgCnLkeqjM16zcXb3wD/UNc8k37kxEgN7wx9+ZsGsiSk9eQm8UuEk/+Nl3bLwMsovPSkjuL1LogPACQDszJtd9Tn4O8CtWIGeDxrU88D75PUyMBwPA4UmqM9aAXMgjdZYKzhi2GZkoREcmdjRrbpgJ29C688vbusMCKOlSxT6KdeQmYXbYMZJYYOnLnU96UAsK0TWuRgfh1qGqvyXunRWaj/xn0joJPLZf3v5wtWiCJTUIPhmZ8C08CQ+2R4IA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=K3Td32aNUuAy+MIpz4C721HcR5oE5o7gZH9hbwaeuJE=;
 b=fQvIdaGzKuhU3sn0EfO9ztgW9sP9LwxxqW4/B8M48y5ZcpJqTn8L9PraLT+19eiSqwJBZMgTNEqvy1pkdFIbnB3d4yTLmnoq2eykUVGbzu2McDRwx8Tc3hnpsyu5A+2+pZtg20zq4ww1LFFkczoBfEcE6rme3vIdEpiEi3ySBSo8aayA7yraHsw4x+Xvhg2nIMOaydXB5ZQnC5q1lWG0uc4SyxHqiEkr4Laj1Ts7YAgXiQJtbMbqa0WgGTL5J+6KyE2TghFeHLZS+fRcAqJxCXBcz5gEO3bLmdnG64vkQsZrpYoS8Vr3N/PEmcFxgnI8IwQN0GX0Vampice/SXV4Ig==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=in-advantage.com; dmarc=pass action=none
 header.from=in-advantage.com; dkim=pass header.d=in-advantage.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=inadvantage.onmicrosoft.com; s=selector2-inadvantage-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=K3Td32aNUuAy+MIpz4C721HcR5oE5o7gZH9hbwaeuJE=;
 b=RV3IPvUswQSxd4zb1ZajMWu4Vuk7+0C9TYc9sQPc5y4xwGUeR3QS3Q+8ToSRoDZq38Rr6YPuP9EIncmqqLiXduYkRysKBLYCs/A9inu3nEh/b/7e6MdwbRihvKVvoBzqHUbRz5C/q1wOdhKcbTKvACjUfjpsWfM2RjlR5hMiWlo=
Authentication-Results: lunn.ch; dkim=none (message not signed)
 header.d=none;lunn.ch; dmarc=none action=none header.from=in-advantage.com;
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37) by MWHPR10MB1709.namprd10.prod.outlook.com
 (2603:10b6:301:7::15) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4308.22; Sat, 10 Jul
 2021 19:26:17 +0000
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::e81f:cf8e:6ad6:d24d]) by MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::e81f:cf8e:6ad6:d24d%3]) with mapi id 15.20.4287.033; Sat, 10 Jul 2021
 19:26:17 +0000
From:   Colin Foster <colin.foster@in-advantage.com>
To:     andrew@lunn.ch, vivien.didelot@gmail.com, f.fainelli@gmail.com,
        olteanv@gmail.com, davem@davemloft.net, kuba@kernel.org,
        robh+dt@kernel.org, claudiu.manoil@nxp.com,
        alexandre.belloni@bootlin.com, UNGLinuxDriver@microchip.com,
        linux@armlinux.org.uk
Cc:     netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [RFC PATCH v2 net-next 1/8] net: dsa: ocelot: remove unnecessary pci_bar variables
Date:   Sat, 10 Jul 2021 12:25:55 -0700
Message-Id: <20210710192602.2186370-2-colin.foster@in-advantage.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210710192602.2186370-1-colin.foster@in-advantage.com>
References: <20210710192602.2186370-1-colin.foster@in-advantage.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MWHPR12CA0042.namprd12.prod.outlook.com
 (2603:10b6:301:2::28) To MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (67.185.175.147) by MWHPR12CA0042.namprd12.prod.outlook.com (2603:10b6:301:2::28) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4308.19 via Frontend Transport; Sat, 10 Jul 2021 19:26:16 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 8a260ce6-7b8d-466c-4e3b-08d943d896bb
X-MS-TrafficTypeDiagnostic: MWHPR10MB1709:
X-Microsoft-Antispam-PRVS: <MWHPR10MB170982CEE8F424DB547555ABA4179@MWHPR10MB1709.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:5236;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 8VasocAn40XXV0kKW/xpJ4vrWCNuf9EcbPMf7N0eaMGEQHofrpIOKVI/22wDJayBfsIClMQGJJo2bHtHtdOevZIpsppafLEyzFt+Xy67LuGRknkK3ot+fUEHBmSqtLK3MPy7yKAqHGeV1bm4KRHeClRmzr41ijPyHhY3v5TeU5ivNovX0smWrfxZy5iGGZKwC1bl9G+lwHU6IrA5l7xJfTmKOakvD+wCmz/rywVh1dxT21Nvo34kopzDIRgXGI9evw7+WJOhvd1LU76KR8TU5v6jWqLlxmJrOFibsamrckNQKqi+eKPYHXTbattbPeHGmRJI1DRPE2Ai5aLho4JAJ7dcLxRFQyzfcdIkXsEpGcIHwK+TSdGjaJwsKDv28xYRViSHXmNg4QTjfVzxdo2XRNuKOEoJRFmGlEBeanIUw13tD42CaAnwgz9WN6HW2R7rqLXUjE8qvxX0IZRYDI4k5Ngvp0IdKIw9n5wuZU348OGdtJWMJY1HVaQdHTZiAaAyOVfmhINxOdqT8/93YEZyJM1gmjMixVHHgkUpmedowpOG54CCkfPShXalgVOq34EgXVxSpVqUvoN4tGR+U6YEZzRzciCzV0+ZuQV9jK/0PhdG7GEyjZGcn61VlseLOPV5B826XBgM1OaEsJDbWWj5RCexfFVAvycCoaQGGLjY7gA4wwuXPmlqCya3+hv5ouj3i90mtTgMU8DVXE6z8KCxNnKYu7jQJTO2lp4XL/9NiPY=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2351.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(346002)(396003)(376002)(39830400003)(136003)(366004)(8936002)(7416002)(6506007)(5660300002)(2906002)(66556008)(26005)(2616005)(8676002)(44832011)(6486002)(6512007)(66476007)(6666004)(38100700002)(38350700002)(52116002)(66946007)(921005)(4326008)(956004)(83380400001)(1076003)(316002)(36756003)(86362001)(186003)(478600001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?AXEzkf3+OI96IAjEuG+KnFiNYGoKJmet10344Pufum3EgmEOZeTgy/xhPe41?=
 =?us-ascii?Q?22d3ELa1ecAnW9Hatgu6jKSRJoBjsE2zxwv70BOydwtPiBB4Lk+GsnIT66XJ?=
 =?us-ascii?Q?1dGyAYsf/DxpGs36lu/KnO9Kses2eOpLVK9AE72Z+SvZQCYY8icplfSx+dvw?=
 =?us-ascii?Q?DHq/ARPUYrA4tEYxToVZkRbh++0z0vw+me7rC7tKu2DTbNy/8k21PvfS0MBO?=
 =?us-ascii?Q?YKieis/BIY48y6l5KjdF7UL8DfjCCUcpOlpORAjdpucVfkGkrdznIblMFhUK?=
 =?us-ascii?Q?8KRYBcoScc2gDG0WKN/ml1KY7iiQoSIhxg7XWdT/70tyoO+7+Yum6hZMGPM4?=
 =?us-ascii?Q?FV/8SpLQw4AH+Os2wxHwH3/EZCQlmzF275Ymhox+8Wt/U5TLEQLkt/KT5A63?=
 =?us-ascii?Q?Cd10x+Wnc+nhoUdRwyNAmt6zSGPgGVAZzEbXadVt3bcsfUntLk3F4D3q3WmU?=
 =?us-ascii?Q?H5HPdusSH4sHGs8fCOiEW7gkDPSaYkdHpYdUO+i3NfcfPDSlZ7lpF0AiDx8Z?=
 =?us-ascii?Q?AdWoFbTGePCRbyN/U11pakmiyB6ttXLsEnOSNltrGNxO86GmlZG7QJDKDm9a?=
 =?us-ascii?Q?/n2M5NuPz6r9AcZ4lYdRzzpcq1vaHEjo78QLP/5nti3uJxGkiWWYre/tmJN6?=
 =?us-ascii?Q?wHFLrv3kQU65Vs/TRrimqBjGK2fm/W+LsCTsxQPRz00RVLCHF47/eGqIpwNI?=
 =?us-ascii?Q?0/MJeolB183V5Ncp1lmIDoCl58vrHhVd6GhkgoHUV5LifJ5GGxRDgcikTAL2?=
 =?us-ascii?Q?7Nab+TQccQFn6hOHwAbOKU4iQNpsPq0UHWhShWGJAXpNpOfkyqQZm+N4MNb2?=
 =?us-ascii?Q?WJEsktoRv2LObHX3bVhBgZCb19KtimHmZn0R7eHAruCB286jJTcYk8J6uy9t?=
 =?us-ascii?Q?3kG5/ZQwABzwUWRR9ZNXTNO4jy1yShbYM0Q6Te3I+ADyu7D7hAnjFhtjCZUf?=
 =?us-ascii?Q?9w3PBuqrCbkRXZBlDsUS01ILJwZ7Q9NqDhRemN+XoUo99NRRBT/ekPiEAFOR?=
 =?us-ascii?Q?El2I3Js1khmjjKxN+qPfVDDg4kQVraXAMZ3B5qD6DvzA7BNeAqOmLsScoM7p?=
 =?us-ascii?Q?5rEFJmxqCtB38cJHLVXN5XyWx21gqrexa7WmP3466eesX/T5w+p9Dy1xlg3Q?=
 =?us-ascii?Q?AaNAuDeSZEt5FMBHEv01EJEHBIogmpLTkrpPqTgD+qVqvRcHmmD5fC0mVR+T?=
 =?us-ascii?Q?iu1XNn7nXgliq2qV6O0vkk7PcQx763Na1qXAOvOP+C1ESNrPapXc7+h1Leqn?=
 =?us-ascii?Q?vCCJtGJyNT5GUaLSu6r96pGxhrWX1DuIwPp1E9+h8M+PijEcmozpKB7msp1K?=
 =?us-ascii?Q?GC11swrMujiffcAxEaSpOWRL?=
X-OriginatorOrg: in-advantage.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8a260ce6-7b8d-466c-4e3b-08d943d896bb
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2351.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Jul 2021 19:26:17.2009
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 48e842ca-fbd8-4633-a79d-0c955a7d3aae
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: CFrQBx42YYt429US1mxCb2pptj+KqU4ORRTTfdDoXxarhVW9zbEJRs+I+DntjBOP0lDYK/MlnIwICIbVWHK/yU4v/PvDI7rzPEPyDdBirvc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR10MB1709
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The pci_bar variables for the switch and imdio don't make sense for the
generic felix driver. Moving them to felix_vsc9959 to limit scope and
simplify the felix_info struct.

Signed-off-by: Colin Foster <colin.foster@in-advantage.com>
---
 drivers/net/dsa/ocelot/felix.h         |  2 --
 drivers/net/dsa/ocelot/felix_vsc9959.c | 11 +++++------
 2 files changed, 5 insertions(+), 8 deletions(-)

diff --git a/drivers/net/dsa/ocelot/felix.h b/drivers/net/dsa/ocelot/felix.h
index 4d96cad815d5..47769dd386db 100644
--- a/drivers/net/dsa/ocelot/felix.h
+++ b/drivers/net/dsa/ocelot/felix.h
@@ -20,8 +20,6 @@ struct felix_info {
 	int				num_ports;
 	int				num_tx_queues;
 	struct vcap_props		*vcap;
-	int				switch_pci_bar;
-	int				imdio_pci_bar;
 	const struct ptp_clock_info	*ptp_caps;
 
 	/* Some Ocelot switches are integrated into the SoC without the
diff --git a/drivers/net/dsa/ocelot/felix_vsc9959.c b/drivers/net/dsa/ocelot/felix_vsc9959.c
index f966a253d1c7..182ca749c8e2 100644
--- a/drivers/net/dsa/ocelot/felix_vsc9959.c
+++ b/drivers/net/dsa/ocelot/felix_vsc9959.c
@@ -1359,8 +1359,6 @@ static const struct felix_info felix_info_vsc9959 = {
 	.num_mact_rows		= 2048,
 	.num_ports		= 6,
 	.num_tx_queues		= OCELOT_NUM_TC,
-	.switch_pci_bar		= 4,
-	.imdio_pci_bar		= 0,
 	.quirk_no_xtr_irq	= true,
 	.ptp_caps		= &vsc9959_ptp_caps,
 	.mdio_bus_alloc		= vsc9959_mdio_bus_alloc,
@@ -1388,6 +1386,9 @@ static irqreturn_t felix_irq_handler(int irq, void *data)
 	return IRQ_HANDLED;
 }
 
+#define VSC9959_SWITCH_PCI_BAR 4
+#define VSC9959_IMDIO_PCI_BAR 0
+
 static int felix_pci_probe(struct pci_dev *pdev,
 			   const struct pci_device_id *id)
 {
@@ -1419,10 +1420,8 @@ static int felix_pci_probe(struct pci_dev *pdev,
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


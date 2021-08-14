Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F055F3EBFD8
	for <lists+netdev@lfdr.de>; Sat, 14 Aug 2021 04:50:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236732AbhHNCuv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Aug 2021 22:50:51 -0400
Received: from mail-bn1nam07on2106.outbound.protection.outlook.com ([40.107.212.106]:10517
        "EHLO NAM02-BN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S236506AbhHNCut (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 13 Aug 2021 22:50:49 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=asiY/aXftygjBPFH1rpWqC7fad+jWBWajD3pBVXwrnaBGE1pi96P2cUdCtdviiuM1AK7Zo7o39Ikv62ALSZ53371cTf810v3ysTQnerR2d9GUcz0tv1k/JgG2iFjYVKDex74BDQJASGO0TzyrfvZgN2VJhd/wFAPylYOuLUm7+WDO8o7GV/wDrV94PS2qOfPyifUfZNrtuzYEvvPRkf6OID9vAgEYL3YrYOCU5jG9JOv33SuwxkGQW9w9dxzivOEI/u9qZz21A2r0echsRiKlH6FmD1QgKQH40yNmiYE8DXwN7JGxNB7fN6Iooz+z4z8/Mmmi20DPyWMZym6RIAuCw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=K3Td32aNUuAy+MIpz4C721HcR5oE5o7gZH9hbwaeuJE=;
 b=GvKhM7pU5JP483yHpZINHaNIxtV2fctTP4W0BSc92A5WAZC4Xg3q6EwnWQX1b1ir4lH8uoi9gsDCQJbHZwjPYckLtuyCDCnrD5f7wyEwhWnUqC4l6pJpGwUuFWl5ARms0ej/jePvlw/tZP0cVdr7JKTaWsUjOwW4zifRtadsULONGHXJxHbYiw35aNqEKzv1zc2a+GLiROERFEO25YgvouUwdOgcSqZwyVlY9Z0IFY3hoi676Lf8AhdUFpROu1NpYxqveDRNBJofzfP2/7df9PNn7Nho+28yXjAv2BxRac6Y1UQNwOF/o2Hstp9DH/71YB0+sbQrWI+d/bqhKL+33Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=in-advantage.com; dmarc=pass action=none
 header.from=in-advantage.com; dkim=pass header.d=in-advantage.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=inadvantage.onmicrosoft.com; s=selector2-inadvantage-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=K3Td32aNUuAy+MIpz4C721HcR5oE5o7gZH9hbwaeuJE=;
 b=JIdsi6d0ebGoC7Y3eAf2FlUBw1GhwW3x5PoZv48eOi95SXvqJgM4g7qNjQqfaN6hE/4fhDMluaqqbRSJs8lVw18d8qgMJb+Q2uIvHryqF+8KuXY284ozvisMf7I4sZYVBiQpYN1SSmD6Rggr0gkYDXHSbjsn1vrcLFy+ucqYQ4c=
Authentication-Results: in-advantage.com; dkim=none (message not signed)
 header.d=none;in-advantage.com; dmarc=none action=none
 header.from=in-advantage.com;
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37) by MWHPR10MB2030.namprd10.prod.outlook.com
 (2603:10b6:300:10d::13) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4415.14; Sat, 14 Aug
 2021 02:50:16 +0000
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::e81f:cf8e:6ad6:d24d]) by MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::e81f:cf8e:6ad6:d24d%3]) with mapi id 15.20.4415.019; Sat, 14 Aug 2021
 02:50:16 +0000
From:   Colin Foster <colin.foster@in-advantage.com>
To:     colin.foster@in-advantage.com, andrew@lunn.ch,
        vivien.didelot@gmail.com, f.fainelli@gmail.com, olteanv@gmail.com,
        davem@davemloft.net, kuba@kernel.org, robh+dt@kernel.org,
        claudiu.manoil@nxp.com, alexandre.belloni@bootlin.com,
        UNGLinuxDriver@microchip.com, hkallweit1@gmail.com,
        linux@armlinux.org.uk
Cc:     netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [RFC PATCH v3 net-next 01/10] net: dsa: ocelot: remove unnecessary pci_bar variables
Date:   Fri, 13 Aug 2021 19:49:54 -0700
Message-Id: <20210814025003.2449143-2-colin.foster@in-advantage.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210814025003.2449143-1-colin.foster@in-advantage.com>
References: <20210814025003.2449143-1-colin.foster@in-advantage.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MW4P221CA0007.NAMP221.PROD.OUTLOOK.COM
 (2603:10b6:303:8b::12) To MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (67.185.175.147) by MW4P221CA0007.NAMP221.PROD.OUTLOOK.COM (2603:10b6:303:8b::12) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4415.14 via Frontend Transport; Sat, 14 Aug 2021 02:50:15 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 5d336c96-19f9-4435-14ff-08d95ece3eca
X-MS-TrafficTypeDiagnostic: MWHPR10MB2030:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <MWHPR10MB203081196F2FC901450AE123A4FB9@MWHPR10MB2030.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:5236;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: lY7QMR5PiIQm1emt/y22OV+AyABxIAbvQLCR87p/3iR0+8xOcCNaIZ7Gr4Ilk1KQm9MmNmijRS+gAn1L/TrF1JFuiYh9PkaU9nYoDJlZSglCRAubDDIXiiCrnHzaSmdgriAm5BBF5wYuIvWJf/Zb6XEdzrfbVzvwUXMO3RJHIEHRKCkg/qJotXl6nY8VOCAGNniWlOmYUpWAfdI2X3fD9X+EPusaoBFr3TLPkUCWfEjh1M13NJ4bg5Z/mCNPIAvxXRZ6HYReE+rQznK1qoMft/ohQyFXhrLL86DMlh7FObV9itrcKIQFcEEs2SkCdBkEFFXw4FJo7pmPxzu9c64CtPddeLVSCosQu5z0w6DqAOt6BjlrRtxTgcqWc6VyLenMaG23MzYQj+ACbJVdvZ38HqKOHAiCSPVYg5n0jy6ATchgqAcpyUN3kN5hBJ3Vs46PCTWjg2or23XdiIqp7ZBG3Tfocfb1QMZ8kjui8ye7gYSY47s1gSKt5Et5E1+KqvymUp5R9ApoZP+0+YO+r7fIUQkmo2VvKW0+CCqc2GxRMC9ipQQX6ob2tq4EKoyMG2xSWj5gUyrC1csI6VNCHBqz9j2ywHj80JRZRyr4yv4IczDNY/hlQJtn83hkdpNrkxe5I1hyaDFgLQkutRG6X4hJqVy91F9o+keyQBezZufaWXynFvM4PXFPefVb7ROU9T1JC+HSz72bLdLIfI3py+pBQS+D5DjSIlKNi+D0UPXNZIw=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2351.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(396003)(346002)(39830400003)(136003)(376002)(186003)(5660300002)(316002)(4326008)(8936002)(6486002)(2906002)(52116002)(66476007)(66556008)(44832011)(956004)(2616005)(66946007)(1076003)(921005)(36756003)(83380400001)(38100700002)(38350700002)(6512007)(6506007)(26005)(478600001)(8676002)(86362001)(6666004)(7416002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?fot4XFFd0XHFs0GKl6XloInIY710Y33uYJonHFBFMEELLi2NA1p4LW7NSRvc?=
 =?us-ascii?Q?UQvHDO0weAVstlmFqbTVcSU8gK1KE7lhDMlbKae0lR38iLgQVBTofs2nrIWV?=
 =?us-ascii?Q?gDRUGA7HOJxQ1fE1jDVk0AWkbUuwW4k3iDj6TNZXX6kYVmwHDBfZ7w2gSeRh?=
 =?us-ascii?Q?/wkonMY1mpf1H45DLt1LR47ewqRpHfNuWD7Lvy0psSVidQx2RjuBaqHgZa0h?=
 =?us-ascii?Q?jjIPm47wDRjq7y18T9RBAblGPksozsb/wD63v2rW+FVhLA+m48+jHLEm5H42?=
 =?us-ascii?Q?FU1r4psQ008Zjxk9h5DwNsCQpYp48jNjqDhkryIi+X7tVHq0tbuCVUpvY2bq?=
 =?us-ascii?Q?Wdz0j28v0/7kGVV2n96DO04jN2+GRBKywGWdqtr8YehgU0+qf7vEniXuwyjx?=
 =?us-ascii?Q?ucgt1g5rgDM09Oz3dPbkdzZyZd+U4vU4tAS2TbEv5JHMUGKPu1G5XE89ORKF?=
 =?us-ascii?Q?7ic8nJ2symOpIp6mYf/PduFEpNc5b60vbptA3LUVHGHzqeeWiwMpBTKCxC/y?=
 =?us-ascii?Q?f3oxoTo0qW087LDJS0T9N1b+TuBTEZnqiCphqD4TpsUo4L7FQXxYXXbwnVlX?=
 =?us-ascii?Q?zPcSwzsJIa3WF4VpBZnJACqPHiQ8PqCSdtxoF46MLHKUnTy7U1D097RyKAoH?=
 =?us-ascii?Q?DhzJTVJGO+0c1aLSatLgn+hbxgt1T0Lat+QnNK9yy7QoH/sOn56qiY3dzze8?=
 =?us-ascii?Q?5zBkXP++chm/4LIvCUsiXZsNSUlj8VdQ65nuKurJzRHsI3k3T63tc9gIc/jh?=
 =?us-ascii?Q?ldyQn4aujMOk308CoMbVTxqYC+N2kilykvLH8SS1JsgTrPHY9w6TxvxFgA1c?=
 =?us-ascii?Q?EHLDT1bXVqLQEeWr7EKmrlFx8LQSfraCwhcWznKn9+vL0h2KqNexDCO3ZiMs?=
 =?us-ascii?Q?RbrFx/nASWyFWCOyuhFaBR0pxtD+a4bJ9orSxsi3XRqU+Fk+XEH875E2EfaA?=
 =?us-ascii?Q?SOWJLfHLpLDeoBwnzdoEvL+SvuPB1OanH3/jETm/nDNHVHw048GW3pPhSvu4?=
 =?us-ascii?Q?1FMuuFmcAZk9WqpIkNk3Q1A7LYJorTHbULAthO4QNqVgniRY3LB0Lg8dOccR?=
 =?us-ascii?Q?sIobHlbH9OR3GB6odowAVF7BdRGyDovJ41T7tQFSDzZqZDzzW0ywWFI9BIrR?=
 =?us-ascii?Q?O5z8xTtSKmr+SX7s4j67B+ewzEh5qMpiQqfGftM0eTKEkzrSzt9NlusbyRSK?=
 =?us-ascii?Q?toFWJIm+qQDGDAxI77vN7c00rJDe50PVcVjnPMkFBp6O2vckvREmf3jfhIAE?=
 =?us-ascii?Q?Pk+uCTcjc4ZVTfHvbFjej6BenfcAxtVx0VgmL2jM2nr+j+6LW5Oc2hVjIqt2?=
 =?us-ascii?Q?b6x2OEXauWhF3lkbRZCGvW1o?=
X-OriginatorOrg: in-advantage.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5d336c96-19f9-4435-14ff-08d95ece3eca
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2351.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Aug 2021 02:50:16.0610
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 48e842ca-fbd8-4633-a79d-0c955a7d3aae
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: DeoKBau9DGbgJCe56/BC5rJ/6o5xxNaqR3v9xarEjm7UA0ifveTCIIzXZiBITIf1th5HhdL21MFDxDrmJ+D/9cmRkVN2yG3l9ePTOPRPlMw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR10MB2030
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


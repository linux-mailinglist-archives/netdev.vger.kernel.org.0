Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 80605203A47
	for <lists+netdev@lfdr.de>; Mon, 22 Jun 2020 17:06:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729399AbgFVPGV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Jun 2020 11:06:21 -0400
Received: from mail-am6eur05on2047.outbound.protection.outlook.com ([40.107.22.47]:15660
        "EHLO EUR05-AM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729365AbgFVPGU (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 22 Jun 2020 11:06:20 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Hr+JcPCWQHeDSZj5ZYsvD6SD3Ip5/j7FGokZfuuA3wU6sdnhvMsJD+zQDbhMBoTEJP1JTxuf76KD4SLZOrJS+5yUfS7kj5trRv9shbLxDyjXxcAmmVW/V234Qzsnh36rNoJHZkVuHu/3w2VNMASknOUs8jbkRnnkIJvv/fMS8uvc6Ic5mFp7XTLXsMXLqhgJWspUATUDYVME67HeinVOwJL3mwAOkBAghWTkaRrnFQwgPrYaXEwOi0nRhBEwSUumq1wSokl7Mt4eVQCUrJCpCKsW17x1OvzcbUztVh2SvjEznqQuqylIhQxivuWdg8JFJO9Osj0X62sD8R1kl+biWA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9RSMy93/Z670E4QZrOsK7Fyl1gPiV3rIn7Naw8XtO0Y=;
 b=cWWhSHoGwTdiMGOtEgm5BdCWtZN9M4AdpmS3zdbmc5Cm7zgDAyzofKl7KnEznrh7rZqd5V2Vs6WNkj5am3MWYdTzTyXy3axZJdozCYn3U+oofCbp1dvbB1QS9mH8OrpEXldN2ij/eAqF4chEuOlCKuSROx/TiPDp/QYnLTt3BzNVnqA+YOm70yFQ8m+F2EMZsQ9+w1tPV1iGhkZKitNIojmadPoIpDQ1a5UEt2FdncDbsz86Rglp4ictd+ej6BGxBK/TNmR9RoY1dRIbSywlAfTmBI0F7ZyAgD9O2PeYigpOTYLKm8MQkQMwS8PKdfz5zCvZHfhokfXo9iu+sGk1bQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oss.nxp.com; dmarc=pass action=none header.from=oss.nxp.com;
 dkim=pass header.d=oss.nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=NXP1.onmicrosoft.com;
 s=selector2-NXP1-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9RSMy93/Z670E4QZrOsK7Fyl1gPiV3rIn7Naw8XtO0Y=;
 b=B1g1X5P4nRmCmylUclBvk4opyGaBA6I93xWfeMunPr/O31nW+G71WHB5RWZt+0/cZC8VoWAtKVs7XgdlV00GLpKU5bcINiuPvgPBNI88jgc8kHE+lIATgNZ8hkZdXqaLsyXLwH1ZJBzNcxxyXgJJUk5BR1XnroFjzdulqA+zSwU=
Authentication-Results: arm.com; dkim=none (message not signed)
 header.d=none;arm.com; dmarc=none action=none header.from=oss.nxp.com;
Received: from AM0PR04MB5636.eurprd04.prod.outlook.com (2603:10a6:208:130::22)
 by AM0PR04MB4289.eurprd04.prod.outlook.com (2603:10a6:208:62::30) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3109.22; Mon, 22 Jun
 2020 15:06:16 +0000
Received: from AM0PR04MB5636.eurprd04.prod.outlook.com
 ([fe80::7dda:a30:6b25:4d45]) by AM0PR04MB5636.eurprd04.prod.outlook.com
 ([fe80::7dda:a30:6b25:4d45%7]) with mapi id 15.20.3109.027; Mon, 22 Jun 2020
 15:06:16 +0000
From:   Calvin Johnson <calvin.johnson@oss.nxp.com>
To:     Jeremy Linton <jeremy.linton@arm.com>,
        Russell King - ARM Linux admin <linux@armlinux.org.uk>,
        Jon <jon@solid-run.com>,
        Cristi Sovaiala <cristian.sovaiala@nxp.com>,
        Ioana Ciornei <ioana.ciornei@nxp.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Andy Shevchenko <andy.shevchenko@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Madalin Bucur <madalin.bucur@oss.nxp.com>
Cc:     netdev@vger.kernel.org, linux.cj@gmail.com,
        Calvin Johnson <calvin.johnson@oss.nxp.com>
Subject: [net-next PATCH v3 3/3] net/fsl: enable extended scanning in xgmac_mdio
Date:   Mon, 22 Jun 2020 20:35:34 +0530
Message-Id: <20200622150534.27482-4-calvin.johnson@oss.nxp.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200622150534.27482-1-calvin.johnson@oss.nxp.com>
References: <20200622150534.27482-1-calvin.johnson@oss.nxp.com>
Content-Type: text/plain
X-ClientProxiedBy: SG2PR03CA0115.apcprd03.prod.outlook.com
 (2603:1096:4:91::19) To AM0PR04MB5636.eurprd04.prod.outlook.com
 (2603:10a6:208:130::22)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from lsv03152.swis.in-blr01.nxp.com (14.142.151.118) by SG2PR03CA0115.apcprd03.prod.outlook.com (2603:1096:4:91::19) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3131.10 via Frontend Transport; Mon, 22 Jun 2020 15:06:13 +0000
X-Mailer: git-send-email 2.17.1
X-Originating-IP: [14.142.151.118]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: ce8e54b4-33fd-41e6-ee55-08d816bdcfb8
X-MS-TrafficTypeDiagnostic: AM0PR04MB4289:
X-MS-Exchange-SharedMailbox-RoutingAgent-Processed: True
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <AM0PR04MB428916784770F4F6EF630697D2970@AM0PR04MB4289.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6108;
X-Forefront-PRVS: 0442E569BC
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: EB/abq3HxrsyLoLSyyqk9e8zYfD1GmhN74uJjy+vTypc2JFEDyzn3pldkkuDpuul4mO9ztsbafbGWHmCpyEhoz16kXUzMPt5ZMol9aEmvJG7LDV8x6tsk5srpxddf4R+4i3Co4LDeRhPj7ajlfUXV2OjZnoZj/lXZ/OUjvoWMHRLl6Izc9FC0D5Gv3cpgD4cOa8XZIBkDW0nrcUAMu9wckFKwetqbcoZ8WmcZ6WyEEUgMgz/fVZxxemTFRO1lghcK4+1HaIY5MDKq/GGF2NaoGx3wTAX2/dnHdKJufP3YtlfAnmK03A0X0UofGSoHHuUrGmM7+hbGZiNr1olHZ+UkQQ9Fj1c1uJ3K6UZID5Slu/Gn8X6fPa3sSyRst4z7PKd
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR04MB5636.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(376002)(396003)(366004)(136003)(39860400002)(346002)(6506007)(478600001)(26005)(16526019)(52116002)(186003)(55236004)(316002)(8936002)(2616005)(1076003)(5660300002)(110136005)(66476007)(44832011)(66556008)(6636002)(6512007)(2906002)(66946007)(6666004)(6486002)(86362001)(4326008)(956004)(8676002)(1006002)(110426005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: fKV3SfeCDBPLCPW5jEAuYhQVMd2MSFjSWXnY8PANzb49r7Erd37P6Lz5DO/uc39KY18biyqz26EqXlibpQgek9grq3cEZT3z39WysqJMMSsOMtKlkDFe4wHmkurmdP9doPeoTNHfdvhCfJmIHsKthrU7AJHd+HScXHNQvttprDTvAitGa+jKYV2zHRfYo48bBwGpvsBW1/9dV0c3V+6O0tTc0DBLY9yJYU/8lhPba8L13lBPjQtXn+xOJQ4c5k6jK41a2EW4XwJpQLlX0PcUmQZ2oiSALLvw6i70voItAIZ9+9kQqno3NSHSkrQd4xRtMFgebuM/dSNMupLz9g9nKOnCwZBUD7INWeeGKDOKP+Q4BwAN5CeYsWMKiJUEE/PiVRHZx7SE2Uws9H20+6SqYyC6oGf0QexAl2IEmZo0JG2FJ4HqS4pCXVz8AEVRYjgs8pxaS69flHaLdCwDN5DSmsC1OF396YJolzFTK3DYlUehf0nQokIOmWa7yslRNbGo
X-OriginatorOrg: oss.nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ce8e54b4-33fd-41e6-ee55-08d816bdcfb8
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Jun 2020 15:06:16.5986
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 2FRrxmqrqZq2Ot9P4xjYTBe/qv1CoWTivrA1T86Qj7Sap08XfWc1eInsJBoHMmkp49c0tLKjifpUg93CA5Kxzg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR04MB4289
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jeremy Linton <jeremy.linton@arm.com>

Since we know the xgmac hardware always has a c45
compliant bus, let's try scanning for c22 capable
PHYs first. If we fail to find any, then it will
fall back to c45 automatically.

Signed-off-by: Jeremy Linton <jeremy.linton@arm.com>
Signed-off-by: Calvin Johnson <calvin.johnson@oss.nxp.com>

---

Changes in v3: None
Changes in v2: None

 drivers/net/ethernet/freescale/xgmac_mdio.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/ethernet/freescale/xgmac_mdio.c b/drivers/net/ethernet/freescale/xgmac_mdio.c
index b4ed5f837975..98be51d8b08c 100644
--- a/drivers/net/ethernet/freescale/xgmac_mdio.c
+++ b/drivers/net/ethernet/freescale/xgmac_mdio.c
@@ -268,6 +268,7 @@ static int xgmac_mdio_probe(struct platform_device *pdev)
 	bus->read = xgmac_mdio_read;
 	bus->write = xgmac_mdio_write;
 	bus->parent = &pdev->dev;
+	bus->probe_capabilities = MDIOBUS_C22_C45;
 	snprintf(bus->id, MII_BUS_ID_SIZE, "%pa", &res->start);
 
 	/* Set the PHY base address */
-- 
2.17.1


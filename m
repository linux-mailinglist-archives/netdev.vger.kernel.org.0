Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 35A2B55EC37
	for <lists+netdev@lfdr.de>; Tue, 28 Jun 2022 20:09:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234494AbiF1SJS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Jun 2022 14:09:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53622 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234483AbiF1SJR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Jun 2022 14:09:17 -0400
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2080.outbound.protection.outlook.com [40.107.243.80])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2ADAC13E9B;
        Tue, 28 Jun 2022 11:09:16 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Ye79pHSrL8Aao/5bO+hWSh4K0pIn+D7OKKgGLPpEDGEIbF8tZSOEPx0N6P0UYJncST0j7KutW/c2BFpW8WwEntPMRhszn7cIQ4N0RA9Ar+sMddpc1XztAXdzlJHZkOSZ9JCFTEjpx92FiHzFygVqj0WmdaRp8ukCEfHpCFWYmZvHYMa0XF39D6PjPyjsGeqUEu8WoEPW0a8NE5gBKg5IolSS6cIdYGfVMLGxypMXu7etguI6ZaL/He3MpApIhvZU8d3sC40IJJ3qD23yAHOtfTcKw7x1MAkToxCLW/hPQjCU8g4dA26I3/GGi8AWxqZl6FYKzbHbxCEjeJMngMtbgQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=h0BMqfi1kM1aosKh4E3CRzsaFSQFQKnfmsc6aHlJ6A4=;
 b=RhIGJYTDaDwo0dA6ayEfu1QErat1aBMkscyKcdnwBdaHIrtgqoffHYp7ahrmDpD/sw+Jxd56bufogfDewMWzBLAwHNdQFBpW0ziW2YxVUsLaArI5LpSWm0lcYkj1FqKkTjri4K81WscpnBF/g9drti0HonfuF93UP5dsRMvLxkVA4vJczyYo777yXuXYSgtvsS7re5TYCj2Ve0K3R6qPgc6CRixQ1yMVZAqTfz0zqG4NZqu3Fm2VEk3lw61JOScqQp8S2GG3Y9XGV1VCoPLp6Q2UnmLZqNifgIkBb9FUwnNVVRxVxTL0LcM0w+VnrE7HxPKQkUD8G8tPmWOMz5+6jA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 149.199.62.198) smtp.rcpttodomain=amd.com smtp.mailfrom=xilinx.com;
 dmarc=fail (p=quarantine sp=quarantine pct=100) action=quarantine
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=xilinx.onmicrosoft.com; s=selector2-xilinx-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=h0BMqfi1kM1aosKh4E3CRzsaFSQFQKnfmsc6aHlJ6A4=;
 b=MrRjI57HUPyrYeII89bIDjpdTsF8UaASM2Sq9jAMZkLHcUH9JdUAIwf/8QYgIh3ITe5MxEcPG3tmgUwNAtS+xbeigNkaGNgzmosndv+JSFiFuKM+H3ZxSD4srqVNPRZBFMV70umz4LMJSHqkJNL/UndzlR1xYHy+cHBbuNzVqUI=
Received: from SN4PR0601CA0007.namprd06.prod.outlook.com
 (2603:10b6:803:2f::17) by DM6PR02MB6761.namprd02.prod.outlook.com
 (2603:10b6:5:213::14) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5373.15; Tue, 28 Jun
 2022 18:09:10 +0000
Received: from SN1NAM02FT0061.eop-nam02.prod.protection.outlook.com
 (2603:10b6:803:2f:cafe::d0) by SN4PR0601CA0007.outlook.office365.com
 (2603:10b6:803:2f::17) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5373.16 via Frontend
 Transport; Tue, 28 Jun 2022 18:09:10 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 149.199.62.198)
 smtp.mailfrom=xilinx.com; dkim=none (message not signed)
 header.d=none;dmarc=fail action=quarantine header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of xilinx.com designates
 149.199.62.198 as permitted sender) receiver=protection.outlook.com;
 client-ip=149.199.62.198; helo=xsj-pvapexch01.xlnx.xilinx.com; pr=C
Received: from xsj-pvapexch01.xlnx.xilinx.com (149.199.62.198) by
 SN1NAM02FT0061.mail.protection.outlook.com (10.97.4.250) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.5373.15 via Frontend Transport; Tue, 28 Jun 2022 18:09:10 +0000
Received: from xsj-pvapexch02.xlnx.xilinx.com (172.19.86.41) by
 xsj-pvapexch01.xlnx.xilinx.com (172.19.86.40) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.14; Tue, 28 Jun 2022 11:09:09 -0700
Received: from smtp.xilinx.com (172.19.127.95) by
 xsj-pvapexch02.xlnx.xilinx.com (172.19.86.41) with Microsoft SMTP Server id
 15.1.2176.14 via Frontend Transport; Tue, 28 Jun 2022 11:09:09 -0700
Envelope-to: git@amd.com,
 harini.katakam@amd.com,
 radhey.shyam.pandey@amd.com,
 davem@davemloft.net,
 edumazet@google.com,
 claudiu.beznea@microchip.com,
 nicolas.ferre@microchip.com,
 pabeni@redhat.com,
 linux-kernel@vger.kernel.org,
 netdev@vger.kernel.org
Received: from [172.23.64.2] (port=57890 helo=xhdvnc102.xilinx.com)
        by smtp.xilinx.com with esmtp (Exim 4.90)
        (envelope-from <radhey.shyam.pandey@xilinx.com>)
        id 1o6Fe8-0005hG-Rf; Tue, 28 Jun 2022 11:09:09 -0700
Received: by xhdvnc102.xilinx.com (Postfix, from userid 13245)
        id 14496104545; Tue, 28 Jun 2022 23:39:08 +0530 (IST)
From:   Radhey Shyam Pandey <radhey.shyam.pandey@amd.com>
To:     <nicolas.ferre@microchip.com>, <claudiu.beznea@microchip.com>,
        <davem@davemloft.net>, <edumazet@google.com>, <pabeni@redhat.com>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <git@amd.com>, <harini.katakam@amd.com>,
        Radhey Shyam Pandey <radhey.shyam.pandey@amd.com>
Subject: [PATCH net-next] net: macb: In shared MDIO usecase make MDIO producer ethernet node to probe first
Date:   Tue, 28 Jun 2022 23:38:54 +0530
Message-ID: <1656439734-632-1-git-send-email-radhey.shyam.pandey@amd.com>
X-Mailer: git-send-email 2.1.1
MIME-Version: 1.0
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: b0c0a111-5b79-4a2b-edcf-08da59314ccb
X-MS-TrafficTypeDiagnostic: DM6PR02MB6761:EE_
X-MS-Exchange-SenderADCheck: 0
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Aaqxwn6y3j509AQurtAvMScdJaBuiMrKZ02kzVDrqUQDwgLaUoS6EOHjGapQGS3qA42e/kQPAr+dyQKGnOtvGGOIZlsl3F1E6OrDFfRmggZEGoa5B2j2L2GVege8HJVl0sFDAMY8HqkzqgVmFva0XyWS7XFmFxbb5yKlJjiQpmMINvNeUNEGtcQ9JWhrp5K6BOFqevvJADTdQoF/yU5n0xRARsA6xb5xTN05/4Zh4GDaEB/kc9eky4aB3cDzFzLa0d6PjQpIEYg6S8BWJUNmgUSDGznL6u4TtdXbZB8BNr8YNClrMHpwjxu0vbcmi4r40vgaHyIG18Xh/cYP+VAmFcyfSlCnjh1cOp4k4Ko2yJUYglLSRpnG3muctIMoQm9y9R/XQipcbi4GSO0xB2lIUqAVMvJ3oIjQ40/JNypu6n3R3MQqpsjY1uR3N5arMnUfc+huY703mwLfgEl+HEKvsPdUjN/22ZN65rEX+QhTgnTd/dyIkW869jAIDvWZVpn/89aTYAUhD2PmRkEffa1OyfHrhSwFkW75uGXkNTV9A1NImTiCNwEsZPI8g4/tau1yVyg/gSoqHhD7wbs09djTWsZnjUcXfhD+zIWHexRVSsOR0TAGrSk9T2H2F+PrdSv9EuLYlxZhpJhQzq0Qe1uyifwsnrVu+cIogno9LROOkgH4wRq8Wh5RBuoRcDdFOzjV7XBqwRqJ208zVPUf6oSftsIkmA7SmJTPPqvSiMfGCuIhiyTaHjUVnJ607ALc021++thKRT49WmyIKkJKX0fLOpBxXTOuZnHx68UEl3JiwhGCQcyQbEzKf4OxuFA1KqstOBtxQZYGUW6nXFWfpwuoyQ==
X-Forefront-Antispam-Report: CIP:149.199.62.198;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:xsj-pvapexch01.xlnx.xilinx.com;PTR:unknown-62-198.xilinx.com;CAT:NONE;SFS:(13230016)(4636009)(39860400002)(376002)(396003)(136003)(346002)(36840700001)(46966006)(40470700004)(2616005)(36860700001)(26005)(47076005)(40460700003)(70206006)(356005)(7416002)(478600001)(2906002)(336012)(82740400003)(83380400001)(40480700001)(42882007)(6666004)(110136005)(36756003)(186003)(7636003)(316002)(82310400005)(8676002)(83170400001)(8936002)(70586007)(6266002)(42186006)(5660300002)(54906003)(4326008)(41300700001)(102446001);DIR:OUT;SFP:1101;
X-OriginatorOrg: xilinx.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Jun 2022 18:09:10.2267
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: b0c0a111-5b79-4a2b-edcf-08da59314ccb
X-MS-Exchange-CrossTenant-Id: 657af505-d5df-48d0-8300-c31994686c5c
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=657af505-d5df-48d0-8300-c31994686c5c;Ip=[149.199.62.198];Helo=[xsj-pvapexch01.xlnx.xilinx.com]
X-MS-Exchange-CrossTenant-AuthSource: SN1NAM02FT0061.eop-nam02.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR02MB6761
X-Spam-Status: No, score=1.3 required=5.0 tests=AC_FROM_MANY_DOTS,BAYES_00,
        DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Level: *
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In shared MDIO suspend/resume usecase for ex. with MDIO producer
(0xff0c0000) eth1 and MDIO consumer(0xff0b0000) eth0 there is a
constraint that ethernet interface(ff0c0000) MDIO bus producer
has to be resumed before the consumer ethernet interface(ff0b0000).

However above constraint is not met when GEM0(ff0b0000) is resumed first.
There is phy_error on GEM0 and interface becomes non-functional on resume.

suspend:
[ 46.477795] macb ff0c0000.ethernet eth1: Link is Down
[ 46.483058] macb ff0c0000.ethernet: gem-ptp-timer ptp clock unregistered.
[ 46.490097] macb ff0b0000.ethernet eth0: Link is Down
[ 46.495298] macb ff0b0000.ethernet: gem-ptp-timer ptp clock unregistered.

resume:
[ 46.633840] macb ff0b0000.ethernet eth0: configuring for phy/sgmii link mode
macb_mdio_read -> pm_runtime_get_sync(GEM1) it return -EACCES error.

The suspend/resume is dependent on probe order so to fix this dependency
ensure that MDIO producer ethernet node is always probed first followed
by MDIO consumer ethernet node.

During MDIO registration find out if MDIO bus is shared and check if MDIO
producer platform node(traverse by 'phy-handle' property) is bound. If not
bound then defer the MDIO consumer ethernet node probe. Doing it ensures
that in suspend/resume MDIO producer is resumed followed by MDIO consumer
ethernet node.

Signed-off-by: Radhey Shyam Pandey <radhey.shyam.pandey@amd.com>
---
As an alternative to this defer probe approach i also explored using
devicelink framework in ndo_open and create a link between consumer and
producer and that solves suspend/resume issue but incase MDIO producer
probe fails MDIO consumer ethernet node remain non-functional. So a
simpler solution seem to defer MDIO consumer ethernet probe till all
dependencies are met.
---
 drivers/net/ethernet/cadence/macb_main.c | 26 +++++++++++++++++++++++-
 1 file changed, 25 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/cadence/macb_main.c b/drivers/net/ethernet/cadence/macb_main.c
index d0ea8dbfa213..5c903d566bc7 100644
--- a/drivers/net/ethernet/cadence/macb_main.c
+++ b/drivers/net/ethernet/cadence/macb_main.c
@@ -853,7 +853,8 @@ static int macb_mii_probe(struct net_device *dev)
 
 static int macb_mdiobus_register(struct macb *bp)
 {
-	struct device_node *child, *np = bp->pdev->dev.of_node;
+	struct device_node *child, *np = bp->pdev->dev.of_node, *mdio_np, *dev_np;
+	struct platform_device *mdio_pdev;
 
 	/* If we have a child named mdio, probe it instead of looking for PHYs
 	 * directly under the MAC node
@@ -884,6 +885,29 @@ static int macb_mdiobus_register(struct macb *bp)
 			return of_mdiobus_register(bp->mii_bus, np);
 		}
 
+	/* For shared MDIO usecases find out MDIO producer platform
+	 * device node by traversing through phy-handle DT property.
+	 */
+	np = of_parse_phandle(np, "phy-handle", 0);
+	mdio_np = of_get_parent(np);
+	of_node_put(np);
+	dev_np = of_get_parent(mdio_np);
+	of_node_put(mdio_np);
+	mdio_pdev = of_find_device_by_node(dev_np);
+	of_node_put(dev_np);
+
+	/* Check if the MDIO producer device is probed */
+	device_lock(&mdio_pdev->dev);
+	if (mdio_pdev && !device_is_bound(&mdio_pdev->dev)) {
+		device_unlock(&mdio_pdev->dev);
+		platform_device_put(mdio_pdev);
+		netdev_info(bp->dev, "Defer probe as mdio producer %s is not probed\n",
+			    dev_name(&mdio_pdev->dev));
+		return -EPROBE_DEFER;
+	}
+
+	device_unlock(&mdio_pdev->dev);
+	platform_device_put(mdio_pdev);
 	return mdiobus_register(bp->mii_bus);
 }
 
-- 
2.25.1


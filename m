Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1EB1D562399
	for <lists+netdev@lfdr.de>; Thu, 30 Jun 2022 21:55:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236960AbiF3Tza (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Jun 2022 15:55:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54632 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236082AbiF3Tz2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Jun 2022 15:55:28 -0400
Received: from NAM02-DM3-obe.outbound.protection.outlook.com (mail-dm3nam02on2074.outbound.protection.outlook.com [40.107.95.74])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 447184475A;
        Thu, 30 Jun 2022 12:55:27 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FgmVeuu+ciUkRdmRkOKF8Q50IBagxl1pYjhNFVCa6duPTAwjyKpUB3o/NUl8eJLf2kwWnWpN9i+paa7w8g99JMs5jr5Lj6ED3VS+x5rsKA03X013lK8m5l6NY4vF5oot1qqwuZH9AyAkiSQisfK6Gbtf5YLAYUa6s/C7LaezAs9WGYSIGj3otIoJ7MBLsqddPVkS74jfoXh+MasAlRQ+2Mw79JCduY2iTXnqhJvr4piGErR9pDVsPSVb9oliAQYYyS5e4oW/EXydAW6snBSgWnr/kDnMzTEp6npRiDwxha+5tyFT1kvdi2WU8YoV+ikRx1hUYIAvzgnZ4kALyCnyQw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=qQpItGuXNQO9FPhGCho9iqwz0nRZbsOmBiUHL8OA3Sg=;
 b=fCnKd3miXHqNFF8dwDpjQvfMsj+8pWgj8/Yn4QhPCIzOD9zFCcSaalgpLG+gR76P8E+xUmZnvAYqe9Xmpv1N4j5KpPYnzM9S9yCYBgTHYaxBdCXTP8GY9k1XakO/tV4hZTm8F3cGYnU7E2SmtNPA8dZvfbL0bPgBY2MkgePGUv79/a5mP2FAvUrBGz674OmuRCb2bHpy7J8Y66kQ5VSq+3b+JpgeAEY+UN8tAl9CY+V09Tibi9iGaWiA/M0KH2ncDVZycc7pV3Bg8TfouklCEPyU5xO3M/DsY4vHM/8iachtvFOcHkrxxjSjSfEjvdSmu8tede+mTVRmQD9jgZuk5w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 149.199.62.198) smtp.rcpttodomain=amd.com smtp.mailfrom=xilinx.com;
 dmarc=fail (p=quarantine sp=quarantine pct=100) action=quarantine
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=xilinx.onmicrosoft.com; s=selector2-xilinx-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qQpItGuXNQO9FPhGCho9iqwz0nRZbsOmBiUHL8OA3Sg=;
 b=h0RbKjk4GkXVu1ZstSQofp7WiG7F7K5JsA7zA7EfHEo7WJBQATqah3IPzIVrzEc2QANXXFYnNUkeP9CpmNDN5jbZ2jJ1T2RZSlMFG8Bq+jpANbbSYdp5tJEn/NkqP/QHDoc2vRBg1wRlx5LpM6wV7mti17frBYxjU5aIIXY2+Ew=
Received: from BN9P221CA0017.NAMP221.PROD.OUTLOOK.COM (2603:10b6:408:10a::8)
 by DM6PR02MB5418.namprd02.prod.outlook.com (2603:10b6:5:33::30) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5395.14; Thu, 30 Jun
 2022 19:55:25 +0000
Received: from BN1NAM02FT039.eop-nam02.prod.protection.outlook.com
 (2603:10b6:408:10a:cafe::98) by BN9P221CA0017.outlook.office365.com
 (2603:10b6:408:10a::8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5373.17 via Frontend
 Transport; Thu, 30 Jun 2022 19:55:25 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 149.199.62.198)
 smtp.mailfrom=xilinx.com; dkim=none (message not signed)
 header.d=none;dmarc=fail action=quarantine header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of xilinx.com designates
 149.199.62.198 as permitted sender) receiver=protection.outlook.com;
 client-ip=149.199.62.198; helo=xsj-pvapexch01.xlnx.xilinx.com; pr=C
Received: from xsj-pvapexch01.xlnx.xilinx.com (149.199.62.198) by
 BN1NAM02FT039.mail.protection.outlook.com (10.13.2.150) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.5395.14 via Frontend Transport; Thu, 30 Jun 2022 19:55:25 +0000
Received: from xsj-pvapexch02.xlnx.xilinx.com (172.19.86.41) by
 xsj-pvapexch01.xlnx.xilinx.com (172.19.86.40) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.14; Thu, 30 Jun 2022 12:55:22 -0700
Received: from smtp.xilinx.com (172.19.127.95) by
 xsj-pvapexch02.xlnx.xilinx.com (172.19.86.41) with Microsoft SMTP Server id
 15.1.2176.14 via Frontend Transport; Thu, 30 Jun 2022 12:55:22 -0700
Envelope-to: git@amd.com,
 radhey.shyam.pandey@amd.com,
 linux@armlinux.org.uk,
 davem@davemloft.net,
 hkallweit1@gmail.com,
 edumazet@google.com,
 saravanak@google.com,
 kuba@kernel.org,
 rafael@kernel.org,
 gregkh@linuxfoundation.org,
 andrew@lunn.ch,
 claudiu.beznea@microchip.com,
 nicolas.ferre@microchip.com,
 pabeni@redhat.com,
 linux-kernel@vger.kernel.org,
 netdev@vger.kernel.org
Received: from [172.23.64.3] (port=55126 helo=xhdvnc103.xilinx.com)
        by smtp.xilinx.com with esmtp (Exim 4.90)
        (envelope-from <radhey.shyam.pandey@xilinx.com>)
        id 1o70G1-000BS2-V3; Thu, 30 Jun 2022 12:55:22 -0700
Received: by xhdvnc103.xilinx.com (Postfix, from userid 13245)
        id 898D0105461; Fri,  1 Jul 2022 01:25:20 +0530 (IST)
From:   Radhey Shyam Pandey <radhey.shyam.pandey@amd.com>
To:     <nicolas.ferre@microchip.com>, <claudiu.beznea@microchip.com>,
        <davem@davemloft.net>, <edumazet@google.com>, <kuba@kernel.org>,
        <pabeni@redhat.com>, <andrew@lunn.ch>, <hkallweit1@gmail.com>,
        <linux@armlinux.org.uk>, <gregkh@linuxfoundation.org>,
        <rafael@kernel.org>, <saravanak@google.com>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <git@amd.com>, Radhey Shyam Pandey <radhey.shyam.pandey@amd.com>
Subject: [PATCH net-next v2] net: macb: In shared MDIO usecase make MDIO producer ethernet node to probe first
Date:   Fri, 1 Jul 2022 01:25:06 +0530
Message-ID: <1656618906-29881-1-git-send-email-radhey.shyam.pandey@amd.com>
X-Mailer: git-send-email 2.1.1
MIME-Version: 1.0
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: f972b384-5a40-4f86-6305-08da5ad2795f
X-MS-TrafficTypeDiagnostic: DM6PR02MB5418:EE_
X-MS-Exchange-SenderADCheck: 0
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 6kj/iC8GT0YfRpWubI9rY4h7K1/EA4WiGpl25Hy4sVWoP4K0b3BCFq1Y0oqK/7lYbFtz7dzgIPAgE0p/xPdvk8RZe61diTU4W0zAWmYNBwdR/glIugY2UlWeJTKi8PwZ/7rTyEpyMCT6UJ5xKFlY5SsCJ6uFFc4rWRyJqSZ6osbkv+mwMAtlAUiRZbaYV9IQNMf0UsvNO+gU054Wn/bzFWB8tQRcaZtk4r/cyPSP8S6jvLhc7YiHLGt98Vo9aIXW9nYmt6swmmnIvLGX1pHSwRcjqn3uaJqgVFdxzPvEOgS9s2Hu/yNqhk4xhthHbzayGdS8VuEjaoZXako3OoYnCwNTytKdL3KNnzG2lBAmV1NMHJASujB3MY0btZm3G2zON/4TjLimUOO6FMud66nQutdYOwdOulSKfxfCxmLnZrzK9flSs2zGvBL9k5b+FQ9fgU1EfmrinD3j4ZOPn2thxmMArlrHrTm0bvgdV/C6LnEY8V4ZNWyF8lh7JsGUtJMFSqbogdMyjj0ogIzigthPRCNfNms1COOCBk/6U1rUrsawFQv4zku6A22GcSjEybforaPaA6//Xvxf3koGPC92xud8aR6tdAkAf+BbODy7XzWRWi89oG9Pn+/kFvSTFdzqE13xZ8mjsIm9ZlUsvVe8q6SBySuqUSpLN0SiCFuNG7jOHRFWaE6Y9s1yAESwxCD8soIYSDgJ8J3DYXUai4RrUSVFSHHKynM/kUCjySZgwOK+3WAA09dY7sg2Ji2kCJNNwj3TzJnsYX0GRVBG5AaL9AQEvMBffvNXlSwlAj9oKde9STvz32Y4ekF60Wzrp1UhkXQPrs6NKL47Jy6B81w5x4xC7RaJPWFl7bOY/1QSltPSTmRkBnz9iU0j+ttyNFhvrY9oqxQI0PuQEBn+Py70dA==
X-Forefront-Antispam-Report: CIP:149.199.62.198;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:xsj-pvapexch01.xlnx.xilinx.com;PTR:unknown-62-198.xilinx.com;CAT:NONE;SFS:(13230016)(4636009)(376002)(346002)(136003)(396003)(39860400002)(46966006)(40470700004)(36840700001)(36860700001)(82310400005)(40480700001)(83380400001)(478600001)(921005)(7636003)(82740400003)(40460700003)(83170400001)(36756003)(356005)(966005)(47076005)(54906003)(7416002)(336012)(5660300002)(186003)(6266002)(42882007)(26005)(8936002)(70206006)(2906002)(316002)(42186006)(4326008)(6666004)(8676002)(110136005)(70586007)(2616005)(41300700001)(102446001);DIR:OUT;SFP:1101;
X-OriginatorOrg: xilinx.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Jun 2022 19:55:25.0710
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: f972b384-5a40-4f86-6305-08da5ad2795f
X-MS-Exchange-CrossTenant-Id: 657af505-d5df-48d0-8300-c31994686c5c
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=657af505-d5df-48d0-8300-c31994686c5c;Ip=[149.199.62.198];Helo=[xsj-pvapexch01.xlnx.xilinx.com]
X-MS-Exchange-CrossTenant-AuthSource: BN1NAM02FT039.eop-nam02.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR02MB5418
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
Changes for v2:
- check presence of drvdata instead of using device_is_bound()
  to fix module compilation. Idea derived from ongoing
  onboard_usb_hub driver series[1].
  [1]: https://lore.kernel.org/all/20220622144857.v23.2.I7c9a1f1d6ced41dd8310e8a03da666a32364e790@changeid
  Listed in v21 changes.
- CC Saravana, Greg, Rafael and ethernet phy maintainers.

Background notes:
As an alternative to this defer probe approach i also explored using
devicelink framework in ndo_open and create a link between consumer and
producer and that solves suspend/resume issue but incase MDIO producer
probe fails MDIO consumer ethernet node remain non-functional. So a
simpler solution seem to defer MDIO consumer ethernet probe till all
dependencies are met.

Please suggest if there is better of solving MDIO producer dependency.
Copied below DTS snippet for reference.

ethernet@ff0b0000 {
    is-internal-pcspma;
    phy-handle = <0x8f>;
    phys = <0x17 0x0 0x8 0x0 0x0>;
    compatible = "cdns,zynqmp-gem", "cdns,gem";
    status = "okay";
	<snip>
    xlnx,ptp-enet-clock = <0x0>;
    phandle = <0x58>;
};

ethernet@ff0c0000 {
    phy-handle = <0x91>;
    pinctrl-0 = <0x90>;
    pinctrl-names = "default";
    compatible = "cdns,zynqmp-gem", "cdns,gem";
    status = "okay";
    <snip>
	mdio {
        phandle = <0x99>;
        #size-cells = <0x0>;
        #address-cells = <0x1>;

        ethernet-phy@8 {
        phandle = <0x91>;
        reset-gpios = <0x8b 0x6 0x1>;
        reset-deassert-us = <0x118>;
        reset-assert-us = <0x64>;
        ti,dp83867-rxctrl-strap-quirk;
        ti,fifo-depth = <0x1>;
        ti,tx-internal-delay = <0xa>;
        ti,rx-internal-delay = <0x8>;
        reg = <0x8>;
        compatible = "ethernet-phy-id2000.a231";
        #phy-cells = <0x1>;
        };

        ethernet-phy@4 {
            phandle = <0x8f>;
            reset-gpios = <0x8b 0x5 0x1>;
            reset-deassert-us = <0x118>;
            reset-assert-us = <0x64>;
            ti,dp83867-rxctrl-strap-quirk;
            ti,fifo-depth = <0x1>;
            ti,tx-internal-delay = <0xa>;
            ti,rx-internal-delay = <0x8>;
            reg = <0x4>;
            compatible = "ethernet-phy-id2000.a231";
            #phy-cells = <0x1>;
            };
        };
};
---
 drivers/net/ethernet/cadence/macb_main.c | 23 ++++++++++++++++++++++-
 1 file changed, 22 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/cadence/macb_main.c b/drivers/net/ethernet/cadence/macb_main.c
index d0ea8dbfa213..88b95d4cacaf 100644
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
@@ -884,6 +885,26 @@ static int macb_mdiobus_register(struct macb *bp)
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
+	/* Check MDIO producer device driver data to see if it's probed */
+	if (mdio_pdev && !dev_get_drvdata(&mdio_pdev->dev)) {
+		platform_device_put(mdio_pdev);
+		netdev_info(bp->dev, "Defer probe as mdio producer %s is not probed\n",
+			    dev_name(&mdio_pdev->dev));
+		return -EPROBE_DEFER;
+	}
+
+	platform_device_put(mdio_pdev);
 	return mdiobus_register(bp->mii_bus);
 }
 
-- 
2.1.1


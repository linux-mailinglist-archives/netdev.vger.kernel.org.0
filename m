Return-Path: <netdev+bounces-4100-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 019C670ADFB
	for <lists+netdev@lfdr.de>; Sun, 21 May 2023 13:53:39 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 87FDE1C2095E
	for <lists+netdev@lfdr.de>; Sun, 21 May 2023 11:53:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 721591FBB;
	Sun, 21 May 2023 11:53:36 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5ECF01FA6
	for <netdev@vger.kernel.org>; Sun, 21 May 2023 11:53:36 +0000 (UTC)
Received: from EUR05-AM6-obe.outbound.protection.outlook.com (mail-am6eur05on2062d.outbound.protection.outlook.com [IPv6:2a01:111:f400:7e1b::62d])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3F2954481;
	Sun, 21 May 2023 04:53:10 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=EeZT6VfP8cLQd9vCPcKTDOoETDcpk3xg42YBiYppvjXflrRC6+o5soqze+wfcJh3FUG9MRtm2ZFPT8pFA07gmppQxgw2IlfOTlquhSC25KcCvxCRu7PU0WkSHFT/gvdwXOwkdAMt7o6FbwhztlZnHDJNpuA3zjslQqMOHJj0BFSYjbsEo6J/kfmQUrjeNqKByitBbiq4sQlPuBrRvMpWjl+KlNDnOQmzsePjtdCNZVpFL/UV2VDAynSsVDpQ2p0S+3vSR4S5phNGJUJazU2vQ0BcnvlYu1z9A5BpwUmiouyFBRhl8mp26HsJvQbxxaaeaxDkNrvfvW0vnyKErbX6Gg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=JKIoiWsnwnExt14hTcEbd2B2oriiej5f/NwLcK0cWw4=;
 b=fwcyF5AuYLVKVKSRY4HOzxKyxAa1QEDWlmmvN9w67q2uCZJuMbAkROTkakClVn744I+HVgAP1ripphqdR2BaO47dO8eipb+d5k5WxZekKkvf4L2ir+eb3ovdqvqkEVLp3+wZVEKDbbqlClv+yA+bWQGrJ4qTPzTsgW2ReWiS8b36jjRYGdG6Y6mJ54gvjb6KR+xFhdK3nYDtRZ/B1DAKeGxl0rp9JJwcYVHkSaeJkXImzxbV+wiAPnBJKGZQCWRTi3qqEsxKJQaLPGwjI7GlRZleBurto6gmB7ypyFRIRAo7/utSWEQNwVg3LCHk6L0puzKJg6SNBbI1yhlfd5EgHA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JKIoiWsnwnExt14hTcEbd2B2oriiej5f/NwLcK0cWw4=;
 b=seEjO8e71QUSlHsbX3FMj9mkfNQrn4mAhUsWeFptHMUDN2rpgobvK9x3TOy60+gGh/BNYiOe9zd0l92s0JnWx8MXJCakaBRuaKwKlphQDy+AK8rvvZc3tPGgHpt+2aOmKnxPhFDxkj7JTtEQQLwouvISwlZFh3zAQJ7SbBKIC4A=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from AM0PR04MB6452.eurprd04.prod.outlook.com (2603:10a6:208:16d::21)
 by AS4PR04MB9508.eurprd04.prod.outlook.com (2603:10a6:20b:4cb::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6411.25; Sun, 21 May
 2023 11:51:57 +0000
Received: from AM0PR04MB6452.eurprd04.prod.outlook.com
 ([fe80::b027:17aa:e5f5:4fea]) by AM0PR04MB6452.eurprd04.prod.outlook.com
 ([fe80::b027:17aa:e5f5:4fea%6]) with mapi id 15.20.6411.027; Sun, 21 May 2023
 11:51:56 +0000
From: Vladimir Oltean <vladimir.oltean@nxp.com>
To: linux-pci@vger.kernel.org
Cc: netdev@vger.kernel.org,
	Bjorn Helgaas <bhelgaas@google.com>,
	Rob Herring <robh@kernel.org>,
	Claudiu Manoil <claudiu.manoil@nxp.com>,
	Michael Walle <michael@walle.cc>,
	linux-kernel@vger.kernel.org
Subject: [PATCH pci] PCI: don't skip probing entire device if first fn OF node has status = "disabled"
Date: Sun, 21 May 2023 14:51:41 +0300
Message-Id: <20230521115141.2384444-1-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.34.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: FR0P281CA0266.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:b5::11) To AM0PR04MB6452.eurprd04.prod.outlook.com
 (2603:10a6:208:16d::21)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: AM0PR04MB6452:EE_|AS4PR04MB9508:EE_
X-MS-Office365-Filtering-Correlation-Id: 3672f4e2-751d-4317-7f58-08db59f1c704
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	o0LtH+rRwYeXQ+2aoPjZdIS/9jjAxjB014EJIQRBZW/kqUSZa69nd2OxhPtvksLuyms1jtJlpTYT8btXf5weN+u1MPaXJVlCLaR+g5sPev+V3uO2Pw5lG28zKN0CQqzXtFwbVpZamV5XF24WJiKvlaKOrb13Na/DCZHqnIqOarq6nfMf9weqYPG5bqg54sOsJS2Ry/cY7TObyGZoJoLmc9bgoAELXGHVAcWp+qCZrVD4Ub+n2L4LTbTcIRr2ukr47V0VfqwqTPSqRWSFPaEdISJ51dR1UoaUh2hORQpEAkJE78rNRgHjZqHuokCE3n6mft8C5xAsuTnnuiAJhmpBHXHTZyDnK7q0UTcXrJ2Owdp0X+0Bf3BWGa204oHlbzX4U1GD2RKHHCnYcUM/PvWBBDvvGjq87Dms3Tg43UhUiuVYgNWrwm0gFDaCq6EoS4EVqMG5oZZCJHKTlSBQZGs7mFUacq6wL1Azn/8RTRc1nXOJcIRiKqhW4m7BeSm9NRDlpTqxtF3ABoiHdss05tyo4BHi2q2x8/aYSfJQFAl7E6Vh5BGjbBbQjjbUjDjk/b9KON1brwemK1Vi8WspvX+tmMhqmBs9nFWlQTj/yVro3Xg=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR04MB6452.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(136003)(39860400002)(346002)(376002)(366004)(396003)(451199021)(44832011)(5660300002)(6916009)(54906003)(4326008)(66476007)(8676002)(8936002)(38100700002)(38350700002)(6512007)(6506007)(26005)(52116002)(1076003)(478600001)(41300700001)(83380400001)(66556008)(6666004)(66946007)(6486002)(316002)(2616005)(36756003)(86362001)(186003)(2906002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?g5/Z9US/AnMMlwlmpvY3SXeYUBhFcyoIfH9k51Y7yI9ZvtpfgZlmMFFU83R1?=
 =?us-ascii?Q?qQa9EdgeWMNpiVkoHJj9B1EIKKdBzzC2uMa9N2HZ2rU+PUwi+TK8X+4NJYh2?=
 =?us-ascii?Q?Gt5wKRdg3xw+EkABj1Q+uusFT9x+lqBuI24K4jH/tDAYKYfxuaiR2zWE+y13?=
 =?us-ascii?Q?JXvWCOVGEYOw0gwMBCQWA++eTKay+13dEGasshdB1dJYJmGDKuklfUDycjHW?=
 =?us-ascii?Q?xNNjrRQZgyNU6/vKwghnIn7n2xps4TJcgIZsXfPxkhQhXb1QKN6QvnnvOv0p?=
 =?us-ascii?Q?J9/cxXdOZnIzyQfzSv+U1bTQdMxxGSs9x44hILe1Scmy4FociP486dKr/IaT?=
 =?us-ascii?Q?qO3/9DODfJ7VpwwHsbLbZDPDXleNSwhVbllm6iFaWISO4XN0riwVB9yKdFt4?=
 =?us-ascii?Q?yUHv633CpSQAgMoJ2C29gSD0b26ZWuAgamxHng2yK0fPeCOsI2z46cPqLGFN?=
 =?us-ascii?Q?4nIcdp0s9PvgTu3DSsiOoYftdFmtIux6gCELGZbAo1AEWZ4Fbiz+MzTeOulI?=
 =?us-ascii?Q?fP5RyaeudLfa2KatbwyE5APAjE/ySp98Rkv73ixnHU8CFoEQIdLP5EFlJbYT?=
 =?us-ascii?Q?qSPx4Mf2HFH42ZgHbizGYz5yEJcjyTLKHWvkopyrmnMl+bOnUGiLf/AqO89b?=
 =?us-ascii?Q?yrZdSz+/2+mUxinUL1mhXnOPRseK/2Sozzjp+alY5P1+ykiFfJz7/swSyJiy?=
 =?us-ascii?Q?mKdROugY2v1noG+mtbtEAA9ipReaDJ0e6WjDTlkHJzRaFo7JAbhBH8tGazpB?=
 =?us-ascii?Q?LbyS/DUo4wOxBp1FgEmTDqI9fI9hazS2Bqg2X3PX2qGgROkuEc1RPjXbcIC4?=
 =?us-ascii?Q?emIIDV6LtFGSGSogpoI0rKHaAqg7k6qfA6A2SlVdNe0hTs8qc6uCF4gSsEza?=
 =?us-ascii?Q?qAuIyszCAsGSJWaFrnlb+xXvbALIZFWI6p36SBwYFBd0OtY+I/VmSXy2xENp?=
 =?us-ascii?Q?u0Ho/xZDHSDKA4gnIz55lQe4yh8FcfUhiAAprHYOUcSHoRtsYhhSuPRndSgM?=
 =?us-ascii?Q?I1wgN861H1bj+wGHCFG7EY2egsa1McD3Y5DPoqmkPuJ+S/+VV4y861HvCTQs?=
 =?us-ascii?Q?LBsFDa35R2RvvmxqMSEh7K0c6Epe+IBrGa564DvglbpYdbcVJLblUNl+8lGm?=
 =?us-ascii?Q?LaaFO9a3n7tgoo/+OzqU/V3j2FzXAZu4D/xtMCnL8Wvsqjm+JwkIB7Eg1pd1?=
 =?us-ascii?Q?hiXQYTJG8FMriQjsfnnW73v7Xkjg3rhOGDR3Phb12+byQkgWSUYbjc5YI3hQ?=
 =?us-ascii?Q?08WZDqI/iesZv0/1sTYhkOvHkMN/CCtHItsWYit1JZylnwFf+27RQaM0jnSw?=
 =?us-ascii?Q?jpEyxTzSPrktR+0lLQWnMsy+tTHXvcOs6KaCXtj9Qx9lFgF3ikLNRU/RouCY?=
 =?us-ascii?Q?+URnfylGZC9S6jk0tZFGMTitoNVi1/OKGjmE5Tf29psduo6DN46Qfq6Hu66v?=
 =?us-ascii?Q?VWjJZDrOo5Sh0tFj/NjMgBalfEOwD/tJ6XbjBwJaqAWAxf+8MV4S4cYjiSK2?=
 =?us-ascii?Q?tQksSSWr5iU6xsAs47kyKZlNOt0f2p9d8I8kGT6ElMWPzshAkf2W2VgPOML7?=
 =?us-ascii?Q?XrymJ5iJ4H3O5LMr7QIltURkSN7+Hu5P85NCSScMb3PttkAQQzO6IyYQywxT?=
 =?us-ascii?Q?hg=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3672f4e2-751d-4317-7f58-08db59f1c704
X-MS-Exchange-CrossTenant-AuthSource: AM0PR04MB6452.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 May 2023 11:51:56.7206
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 5mYM8q80JA2MXgUjV9HliKmYmVR1zGWIEHShCT/qXMuEtC+l2RMLdgRGJLL7QF5p2344rN2lVf7jRL/ItF73xA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS4PR04MB9508
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,SPF_HELO_PASS,
	T_SCC_BODY_TEXT_LINE,T_SPF_PERMERROR autolearn=ham autolearn_force=no
	version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

pci_scan_child_bus_extend() calls pci_scan_slot() with devfn
(bus:device:function) being a multiple of 8, i.e. for each unique
device.

pci_scan_slot() has logic to say that if the function 0 of a device is
absent, the entire device is absent and we can skip the other functions
entirely. Traditionally, this has meant that pci_bus_read_dev_vendor_id()
returns an error code for that function.

However, since the blamed commit, there is an extra confounding
condition: function 0 of the device exists and has a valid vendor id,
but it is disabled in the device tree. In that case, pci_scan_slot()
would incorrectly skip the entire device instead of just that function.

Such is the case with the NXP LS1028A SoC, which has an ECAM
for embedded Ethernet (see pcie@1f0000000 in
arm64/boot/dts/freescale/fsl-ls1028a.dtsi). Each Ethernet port
represents a function within the ENETC ECAM, with function 0 going
to ENETC Ethernet port 0, connected to SERDES port 0 (SGMII or USXGMII).

When using a SERDES protocol such as 0x9999, all 4 SERDES lanes go to
the Ethernet switch (function 5 on this ECAM) and none go to ENETC
port 0. So, ENETC port 0 needs to have status = "disabled", and embedded
Ethernet takes place just through the other functions (fn 2 is the DSA
master, fn 3 is the MDIO controller, fn 5 is the DSA switch etc).
Contrast this with other SERDES protocols like 0x85bb, where the switch
takes up a single SERDES lane and uses the QSGMII protocol - so ENETC
port 0 also gets access to a SERDES lane.

Therefore, here, function 0 being unused has nothing to do with the
entire PCI device being unused.

Add a "bool present_but_skipped" which is propagated from the caller
of pci_set_of_node() all the way to pci_scan_slot(), so that it can
distinguish an error reading the ECAM from a disabled device in the
device tree.

Fixes: 6fffbc7ae137 ("PCI: Honor firmware's device disabled status")
Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 drivers/pci/pci.h   |  1 +
 drivers/pci/probe.c | 58 +++++++++++++++++++++++++++++++--------------
 2 files changed, 41 insertions(+), 18 deletions(-)

diff --git a/drivers/pci/pci.h b/drivers/pci/pci.h
index 2475098f6518..dc11e0945744 100644
--- a/drivers/pci/pci.h
+++ b/drivers/pci/pci.h
@@ -240,6 +240,7 @@ bool pci_bus_generic_read_dev_vendor_id(struct pci_bus *bus, int devfn, u32 *pl,
 					int crs_timeout);
 int pci_idt_bus_quirk(struct pci_bus *bus, int devfn, u32 *pl, int crs_timeout);
 
+int __pci_setup_device(struct pci_dev *dev, bool *present_but_skipped);
 int pci_setup_device(struct pci_dev *dev);
 int __pci_read_base(struct pci_dev *dev, enum pci_bar_type type,
 		    struct resource *res, unsigned int reg);
diff --git a/drivers/pci/probe.c b/drivers/pci/probe.c
index 0b2826c4a832..17a51fa55020 100644
--- a/drivers/pci/probe.c
+++ b/drivers/pci/probe.c
@@ -1811,17 +1811,7 @@ static void early_dump_pci_device(struct pci_dev *pdev)
 		       value, 256, false);
 }
 
-/**
- * pci_setup_device - Fill in class and map information of a device
- * @dev: the device structure to fill
- *
- * Initialize the device structure with information about the device's
- * vendor,class,memory and IO-space addresses, IRQ lines etc.
- * Called at initialisation of the PCI subsystem and by CardBus services.
- * Returns 0 on success and negative if unknown type of device (not normal,
- * bridge or CardBus).
- */
-int pci_setup_device(struct pci_dev *dev)
+int __pci_setup_device(struct pci_dev *dev, bool *present_but_skipped)
 {
 	u32 class;
 	u16 cmd;
@@ -1841,8 +1831,10 @@ int pci_setup_device(struct pci_dev *dev)
 	set_pcie_port_type(dev);
 
 	err = pci_set_of_node(dev);
-	if (err)
+	if (err) {
+		*present_but_skipped = true;
 		return err;
+	}
 	pci_set_acpi_fwnode(dev);
 
 	pci_dev_assign_slot(dev);
@@ -1995,6 +1987,23 @@ int pci_setup_device(struct pci_dev *dev)
 	return 0;
 }
 
+/**
+ * pci_setup_device - Fill in class and map information of a device
+ * @dev: the device structure to fill
+ *
+ * Initialize the device structure with information about the device's
+ * vendor,class,memory and IO-space addresses, IRQ lines etc.
+ * Called at initialisation of the PCI subsystem and by CardBus services.
+ * Returns 0 on success and negative if unknown type of device (not normal,
+ * bridge or CardBus).
+ */
+int pci_setup_device(struct pci_dev *dev)
+{
+	bool present_but_skipped = false;
+
+	return __pci_setup_device(dev, &present_but_skipped);
+}
+
 static void pci_configure_mps(struct pci_dev *dev)
 {
 	struct pci_dev *bridge = pci_upstream_bridge(dev);
@@ -2414,7 +2423,8 @@ EXPORT_SYMBOL(pci_bus_read_dev_vendor_id);
  * Read the config data for a PCI device, sanity-check it,
  * and fill in the dev structure.
  */
-static struct pci_dev *pci_scan_device(struct pci_bus *bus, int devfn)
+static struct pci_dev *pci_scan_device(struct pci_bus *bus, int devfn,
+				       bool *present_but_skipped)
 {
 	struct pci_dev *dev;
 	u32 l;
@@ -2430,7 +2440,7 @@ static struct pci_dev *pci_scan_device(struct pci_bus *bus, int devfn)
 	dev->vendor = l & 0xffff;
 	dev->device = (l >> 16) & 0xffff;
 
-	if (pci_setup_device(dev)) {
+	if (__pci_setup_device(dev, present_but_skipped)) {
 		pci_bus_put(dev->bus);
 		kfree(dev);
 		return NULL;
@@ -2575,17 +2585,20 @@ void pci_device_add(struct pci_dev *dev, struct pci_bus *bus)
 	WARN_ON(ret < 0);
 }
 
-struct pci_dev *pci_scan_single_device(struct pci_bus *bus, int devfn)
+static struct pci_dev *__pci_scan_single_device(struct pci_bus *bus, int devfn,
+						bool *present_but_skipped)
 {
 	struct pci_dev *dev;
 
+	*present_but_skipped = false;
+
 	dev = pci_get_slot(bus, devfn);
 	if (dev) {
 		pci_dev_put(dev);
 		return dev;
 	}
 
-	dev = pci_scan_device(bus, devfn);
+	dev = pci_scan_device(bus, devfn, present_but_skipped);
 	if (!dev)
 		return NULL;
 
@@ -2593,6 +2606,13 @@ struct pci_dev *pci_scan_single_device(struct pci_bus *bus, int devfn)
 
 	return dev;
 }
+
+struct pci_dev *pci_scan_single_device(struct pci_bus *bus, int devfn)
+{
+	bool present_but_skipped;
+
+	return __pci_scan_single_device(bus, devfn, &present_but_skipped);
+}
 EXPORT_SYMBOL(pci_scan_single_device);
 
 static int next_ari_fn(struct pci_bus *bus, struct pci_dev *dev, int fn)
@@ -2665,6 +2685,7 @@ static int only_one_child(struct pci_bus *bus)
  */
 int pci_scan_slot(struct pci_bus *bus, int devfn)
 {
+	bool present_but_skipped;
 	struct pci_dev *dev;
 	int fn = 0, nr = 0;
 
@@ -2672,13 +2693,14 @@ int pci_scan_slot(struct pci_bus *bus, int devfn)
 		return 0; /* Already scanned the entire slot */
 
 	do {
-		dev = pci_scan_single_device(bus, devfn + fn);
+		dev = __pci_scan_single_device(bus, devfn + fn,
+					       &present_but_skipped);
 		if (dev) {
 			if (!pci_dev_is_added(dev))
 				nr++;
 			if (fn > 0)
 				dev->multifunction = 1;
-		} else if (fn == 0) {
+		} else if (fn == 0 && !present_but_skipped) {
 			/*
 			 * Function 0 is required unless we are running on
 			 * a hypervisor that passes through individual PCI
-- 
2.34.1



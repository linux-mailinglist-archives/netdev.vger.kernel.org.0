Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2D920AB8CF
	for <lists+netdev@lfdr.de>; Fri,  6 Sep 2019 15:03:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405080AbfIFNDS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 Sep 2019 09:03:18 -0400
Received: from mx0a-00128a01.pphosted.com ([148.163.135.77]:26674 "EHLO
        mx0a-00128a01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2403816AbfIFNDR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 6 Sep 2019 09:03:17 -0400
Received: from pps.filterd (m0167089.ppops.net [127.0.0.1])
        by mx0a-00128a01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id x86D38Dw032568;
        Fri, 6 Sep 2019 09:03:08 -0400
Received: from nam04-bn3-obe.outbound.protection.outlook.com (mail-bn3nam04lp2052.outbound.protection.outlook.com [104.47.46.52])
        by mx0a-00128a01.pphosted.com with ESMTP id 2uqnt8m9ju-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Fri, 06 Sep 2019 09:03:07 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=UpMBNpAXqUmy5GvM7ZocVRQHl35CShYqaVSCXJRLaklKbRGjuipsKmWsHKmC7mjMf124QPT6PpanE2Rv+QvWvd5Hc0j0jDM3b4D2rOjZFEAYPBbWONE/nZPHJTbKxhSQhtpoaQ2Iu1Rm7VUcXx4BxE5nVc4JUhEg64bgc8W7FKTnZ3TCNSuAO+Wf4GPCGockHIJr4NFaIQtWxpR5eEH5DMmZGpbmZgqfP8jijleFUMplKPYM/wmm0VqNAzjheUuXbVdj9a6rhIZBFVRldZFLFUdZXOnZA7JnqvRsSH+WeMS1xZbBpt31Mg/Xf3dB+SULm4Djlj9tQ1xJYdKEkH9CbA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gHNlD7sV8msy3I2Oe/HMoKcdJRRdSl7AJUBlnBp/T4c=;
 b=JwnwmnxeZMY1nIozKly12/bB+UxKE3zOlHE+pCXhbgRxdWZJzpCOAx6H7p5F4d+coYZtCs93EdzWVVZ/QTdo1R9YT9D8OCsvdFmobA2G1dpKYPegwie/XXkzgLjJIUBcxPlNDyFhIhCrVJfPsxW17FCrajliNMTcGsz0lMDDvl03dP8NU8/EOHNJEvTdOmwMnNGY2NcEqDWBVbGLjSnb86abU3A9+skGmOJTpTCXqgnhhNdt8gWuGcLbgC/s9QEwHMtaFDKIfKtyLL15wcJMRyfZbi6f2g3hQe9MXcr/oHagtFscmjnnTeI3cZMwnTNswq65t5AwnZfPkF0Hg5XjYQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 137.71.25.55) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=analog.com;
 dmarc=bestguesspass action=none header.from=analog.com; dkim=none (message
 not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=analog.onmicrosoft.com; s=selector2-analog-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gHNlD7sV8msy3I2Oe/HMoKcdJRRdSl7AJUBlnBp/T4c=;
 b=SKU7OtTfc/vCmzG7a6iXApwF/p0gy2Qe6pXO0FoxjrT9LI3fA2cZ1w7XDBaXeztGbjjwe5rIMqobQjm35tsO2rchE8hvIgpqCPquhvSNX1MfGusLQWmG3d1P8aXs6qSRo/4QxAI5k81Fe6JyS2iNoXoUt9P1JJZRynuuTbC6Xhg=
Received: from CY4PR03CA0094.namprd03.prod.outlook.com (2603:10b6:910:4d::35)
 by DM6PR03MB3819.namprd03.prod.outlook.com (2603:10b6:5:4f::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2220.19; Fri, 6 Sep
 2019 13:03:04 +0000
Received: from BL2NAM02FT011.eop-nam02.prod.protection.outlook.com
 (2a01:111:f400:7e46::208) by CY4PR03CA0094.outlook.office365.com
 (2603:10b6:910:4d::35) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2199.17 via Frontend
 Transport; Fri, 6 Sep 2019 13:03:04 +0000
Received-SPF: Pass (protection.outlook.com: domain of analog.com designates
 137.71.25.55 as permitted sender) receiver=protection.outlook.com;
 client-ip=137.71.25.55; helo=nwd2mta1.analog.com;
Received: from nwd2mta1.analog.com (137.71.25.55) by
 BL2NAM02FT011.mail.protection.outlook.com (10.152.77.5) with Microsoft SMTP
 Server (version=TLS1_0, cipher=TLS_RSA_WITH_AES_256_CBC_SHA) id 15.20.2241.14
 via Frontend Transport; Fri, 6 Sep 2019 13:03:03 +0000
Received: from NWD2HUBCAS7.ad.analog.com (nwd2hubcas7.ad.analog.com [10.64.69.107])
        by nwd2mta1.analog.com (8.13.8/8.13.8) with ESMTP id x86D32NA030651
        (version=TLSv1/SSLv3 cipher=AES256-SHA bits=256 verify=OK);
        Fri, 6 Sep 2019 06:03:02 -0700
Received: from saturn.ad.analog.com (10.48.65.123) by
 NWD2HUBCAS7.ad.analog.com (10.64.69.107) with Microsoft SMTP Server id
 14.3.408.0; Fri, 6 Sep 2019 09:03:01 -0400
From:   Alexandru Ardelean <alexandru.ardelean@analog.com>
To:     <netdev@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
CC:     <davem@davemloft.net>, <robh+dt@kernel.org>,
        <peppe.cavallaro@st.com>, <alexandre.torgue@st.com>,
        <--cc=andrew@lunn.ch>,
        Alexandru Ardelean <alexandru.ardelean@analog.com>
Subject: [PATCH 1/2] net: stmmac: implement support for passive mode converters via dt
Date:   Fri, 6 Sep 2019 16:02:55 +0300
Message-ID: <20190906130256.10321-1-alexandru.ardelean@analog.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ADIRoutedOnPrem: True
X-EOPAttributedMessage: 0
X-MS-Office365-Filtering-HT: Tenant
X-Forefront-Antispam-Report: CIP:137.71.25.55;IPV:NLI;CTRY:US;EFV:NLI;SFV:NSPM;SFS:(10009020)(136003)(346002)(376002)(39860400002)(396003)(2980300002)(189003)(199004)(50226002)(70586007)(54906003)(478600001)(110136005)(106002)(486006)(48376002)(7696005)(1076003)(70206006)(8676002)(2201001)(126002)(356004)(476003)(44832011)(5660300002)(316002)(2616005)(47776003)(6666004)(107886003)(26005)(336012)(426003)(305945005)(7636002)(51416003)(186003)(246002)(2870700001)(2906002)(4326008)(36756003)(86362001)(8936002)(50466002);DIR:OUT;SFP:1101;SCL:1;SRVR:DM6PR03MB3819;H:nwd2mta1.analog.com;FPR:;SPF:Pass;LANG:en;PTR:nwd2mail10.analog.com;MX:1;A:1;
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 1538e307-50dc-4d37-6675-08d732ca8dce
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600166)(711020)(4605104)(4709080)(1401327)(4618075)(2017052603328);SRVR:DM6PR03MB3819;
X-MS-TrafficTypeDiagnostic: DM6PR03MB3819:
X-Microsoft-Antispam-PRVS: <DM6PR03MB3819B379B4E7E93EA968EC7EF9BA0@DM6PR03MB3819.namprd03.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8273;
X-Forefront-PRVS: 0152EBA40F
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam-Message-Info: S+2J5Vw4yRFmkVBC5tYe7Ppwin/gxZvNx1x4VsZ+inRWIuonL6PJ7e8RLZDxLJ+nkiYutzPlEp6M8lNohBaPzeVE9BmiMk3v2dMB4amVOjlSIXDcn7Z5uFZKoWj5ufVQ024p2GjN6JlgbHXN2+Hgp8H+HBdEzFsZSlkcVSDv6e7/wuP5vVtCs31K1AlMmAeWGcEl3ayrYKfu3jA8csB4g+IF85aMn6TwV6ijrWvG762WXh/XOGNmUi8s5duuGGoLhyMAr9J8V7bcg6vr+9z4gsVPQkxYX8wpqkSij2/+QUG5hudHAjoP6IF4PhaaCdwWZl8bm6iMdu8uchu2ecmVyvyRpnPvaoYJBrAnqryksmMrdGJI4l1MqoXE82wapde3bLRUAA1Xt3teleXmvq5T7M7Hf8+LsOstsXWMHkciaU4=
X-OriginatorOrg: analog.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Sep 2019 13:03:03.8990
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 1538e307-50dc-4d37-6675-08d732ca8dce
X-MS-Exchange-CrossTenant-Id: eaa689b4-8f87-40e0-9c6f-7228de4d754a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=eaa689b4-8f87-40e0-9c6f-7228de4d754a;Ip=[137.71.25.55];Helo=[nwd2mta1.analog.com]
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR03MB3819
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.70,1.0.8
 definitions=2019-09-06_06:2019-09-04,2019-09-06 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0 clxscore=1011
 suspectscore=0 lowpriorityscore=0 bulkscore=0 spamscore=0 malwarescore=0
 mlxscore=0 priorityscore=1501 adultscore=0 mlxlogscore=999 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-1906280000
 definitions=main-1909060138
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In-between the MAC & PHY there can be a mode converter, which converts one
mode to another (e.g. GMII-to-RGMII).

The converter, can be passive (i.e. no driver or OS/SW information
required), so the MAC & PHY need to be configured differently.

For the `stmmac` driver, this is implemented via a `mac-mode` property in
the device-tree, which configures the MAC into a certain mode, and for the
PHY a `phy_interface` field will hold the mode of the PHY. The mode of the
PHY will be passed to the PHY and from there-on it work in a different
mode. If unspecified, the default `phy-mode` will be used for both.

Signed-off-by: Alexandru Ardelean <alexandru.ardelean@analog.com>
---
 .../net/ethernet/stmicro/stmmac/stmmac_main.c |  2 +-
 .../ethernet/stmicro/stmmac/stmmac_platform.c | 34 ++++++++++++++++++-
 include/linux/stmmac.h                        |  1 +
 3 files changed, 35 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
index c3baca9f587b..ec7aa42128a5 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
@@ -1029,7 +1029,7 @@ static int stmmac_init_phy(struct net_device *dev)
 static int stmmac_phy_setup(struct stmmac_priv *priv)
 {
 	struct fwnode_handle *fwnode = of_fwnode_handle(priv->plat->phylink_node);
-	int mode = priv->plat->interface;
+	int mode = priv->plat->phy_interface;
 	struct phylink *phylink;
 
 	priv->phylink_config.dev = &priv->dev->dev;
diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_platform.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_platform.c
index eaf8f08f2e91..401cbbfc06f0 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_platform.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_platform.c
@@ -355,6 +355,32 @@ static int stmmac_dt_phy(struct plat_stmmacenet_data *plat,
 	return 0;
 }
 
+/**
+ * stmmac_of_get_mac_mode - retrieves the interface of the MAC
+ * @np - device-tree node
+ * Description:
+ * Similar to `of_get_phy_mode()`, this function will retrieve (from
+ * the device-tree) the interface mode on the MAC side. This assumes
+ * that there is mode converter in-between the MAC & PHY
+ * (e.g. GMII-to-RGMII).
+ */
+static int stmmac_of_get_mac_mode(struct device_node *np)
+{
+	const char *pm;
+	int err, i;
+
+	err = of_property_read_string(np, "mac-mode", &pm);
+	if (err < 0)
+		return err;
+
+	for (i = 0; i < PHY_INTERFACE_MODE_MAX; i++) {
+		if (!strcasecmp(pm, phy_modes(i)))
+			return i;
+	}
+
+	return -ENODEV;
+}
+
 /**
  * stmmac_probe_config_dt - parse device-tree driver parameters
  * @pdev: platform_device structure
@@ -383,7 +409,13 @@ stmmac_probe_config_dt(struct platform_device *pdev, const char **mac)
 		*mac = NULL;
 	}
 
-	plat->interface = of_get_phy_mode(np);
+	plat->phy_interface = of_get_phy_mode(np);
+	if (plat->phy_interface < 0)
+		return ERR_PTR(plat->phy_interface);
+
+	plat->interface = stmmac_of_get_mac_mode(np);
+	if (plat->interface < 0)
+		plat->interface = plat->phy_interface;
 
 	/* Some wrapper drivers still rely on phy_node. Let's save it while
 	 * they are not converted to phylink. */
diff --git a/include/linux/stmmac.h b/include/linux/stmmac.h
index 7ad7ae35cf88..dc60d03c4b60 100644
--- a/include/linux/stmmac.h
+++ b/include/linux/stmmac.h
@@ -131,6 +131,7 @@ struct plat_stmmacenet_data {
 	int bus_id;
 	int phy_addr;
 	int interface;
+	int phy_interface;
 	struct stmmac_mdio_bus_data *mdio_bus_data;
 	struct device_node *phy_node;
 	struct device_node *phylink_node;
-- 
2.20.1


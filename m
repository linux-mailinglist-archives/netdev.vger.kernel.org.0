Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 45835B0FE5
	for <lists+netdev@lfdr.de>; Thu, 12 Sep 2019 15:28:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732145AbfILN2j (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Sep 2019 09:28:39 -0400
Received: from mx0b-00128a01.pphosted.com ([148.163.139.77]:15664 "EHLO
        mx0b-00128a01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1732072AbfILN2i (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 Sep 2019 09:28:38 -0400
Received: from pps.filterd (m0167090.ppops.net [127.0.0.1])
        by mx0b-00128a01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id x8CDRETI019623;
        Thu, 12 Sep 2019 09:28:27 -0400
Received: from nam04-co1-obe.outbound.protection.outlook.com (mail-co1nam04lp2054.outbound.protection.outlook.com [104.47.45.54])
        by mx0b-00128a01.pphosted.com with ESMTP id 2uv967r5k7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 12 Sep 2019 09:28:27 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=i+jm2ND9THuoLI0rletrw8ZtJKRD493S5cvTvsoCCS3dRcpLcs4NZEOWmM9qWKA719/nqB07B6B82heRk+eq2JDvQpb7KgWsRmg3dkCOrs9naWlG5bSmB+dzfoEKMmeNNnvWqHiVEevwVMaJAs2LDtA3RnLXlyrdgBCLkugQdIvhfqaMblB4j4lVjKNeS42KGlHe2RwTC+P9AWTKppDqHbCfQlXg+DTN0z6UI7edm93qmLOKdTqQYx3dOp6pmfffCE6AB+G6GZDoAnPP42ruhDL7m/gTh1dhrCjNa0bvUrwWY1GnJIur7VcrC7X4rlfkYWEN5J+IjzppwdIFM0zs8Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zvHMY2JQ/e3SZ6o2dRnIp2uMIofAbTV7xHyg8RXTRwc=;
 b=gbiWPf/HXUmRjE0I5kR/LPCzv3kwseGNKm8eKKUG7/7r0N/9IqTKsn0E4UrpJH9ygNH2zYQrj10vHFCpENeQwZuJjvViM3F8v7lBBx0QtZKXqSF4gaCCXLDgxItbxNnrNXZRyb/cbj2BO7gpqA7HIOg0XmrPDNCmG10EK1dPFZj0SAPTbU09TwU2b9cQuxAYO57t1AtToXphyLlA9+vPPVjaSyOoOHD+hi1uP2Yikl+TbqRKzWWGoQ2LCmBKgsS2TxSEiHyLbJGTLG3ywdY+aqHWm3KXQqD8gVfKE8wNE3vkcDuXYF+3Wsxuew3IMY6WEjx+xtPbM+YSUyTjJPg7Mw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 137.71.25.57) smtp.rcpttodomain=davemloft.net smtp.mailfrom=analog.com;
 dmarc=bestguesspass action=none header.from=analog.com; dkim=none (message
 not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=analog.onmicrosoft.com; s=selector2-analog-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zvHMY2JQ/e3SZ6o2dRnIp2uMIofAbTV7xHyg8RXTRwc=;
 b=HH6D8jQ47wiMZ0qbf6Xku3IFyO5appt1M+nr2zfEwmJrHjsvQI8fD86MyY/l2vCgNb4EHAbJwJYYsvRGJz7iou3quWxayUmljCtBoIworpE/xKBGSw7syC/5i0hX+80zMyXsqSVJFv/axekhcSaK+q4phweTeB3C1gdNg16PsUM=
Received: from BN3PR03CA0101.namprd03.prod.outlook.com (2603:10b6:400:4::19)
 by BL0PR03MB4196.namprd03.prod.outlook.com (2603:10b6:208:63::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2263.17; Thu, 12 Sep
 2019 13:28:23 +0000
Received: from CY1NAM02FT054.eop-nam02.prod.protection.outlook.com
 (2a01:111:f400:7e45::202) by BN3PR03CA0101.outlook.office365.com
 (2603:10b6:400:4::19) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2263.14 via Frontend
 Transport; Thu, 12 Sep 2019 13:28:23 +0000
Received-SPF: Pass (protection.outlook.com: domain of analog.com designates
 137.71.25.57 as permitted sender) receiver=protection.outlook.com;
 client-ip=137.71.25.57; helo=nwd2mta2.analog.com;
Received: from nwd2mta2.analog.com (137.71.25.57) by
 CY1NAM02FT054.mail.protection.outlook.com (10.152.74.100) with Microsoft SMTP
 Server (version=TLS1_0, cipher=TLS_RSA_WITH_AES_256_CBC_SHA) id 15.20.2241.14
 via Frontend Transport; Thu, 12 Sep 2019 13:28:23 +0000
Received: from NWD2HUBCAS7.ad.analog.com (nwd2hubcas7.ad.analog.com [10.64.69.107])
        by nwd2mta2.analog.com (8.13.8/8.13.8) with ESMTP id x8CDSHI1027902
        (version=TLSv1/SSLv3 cipher=AES256-SHA bits=256 verify=OK);
        Thu, 12 Sep 2019 06:28:17 -0700
Received: from saturn.ad.analog.com (10.48.65.123) by
 NWD2HUBCAS7.ad.analog.com (10.64.69.107) with Microsoft SMTP Server id
 14.3.408.0; Thu, 12 Sep 2019 09:28:22 -0400
From:   Alexandru Ardelean <alexandru.ardelean@analog.com>
To:     <netdev@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
CC:     <davem@davemloft.net>, <robh+dt@kernel.org>,
        <mark.rutland@arm.com>, <f.fainelli@gmail.com>,
        <hkallweit1@gmail.com>, <andrew@lunn.ch>, <mkubecek@suse.cz>,
        Alexandru Ardelean <alexandru.ardelean@analog.com>
Subject: [PATCH v4 1/2] ethtool: implement Energy Detect Powerdown support via phy-tunable
Date:   Thu, 12 Sep 2019 19:28:11 +0300
Message-ID: <20190912162812.402-2-alexandru.ardelean@analog.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190912162812.402-1-alexandru.ardelean@analog.com>
References: <20190912162812.402-1-alexandru.ardelean@analog.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ADIRoutedOnPrem: True
X-EOPAttributedMessage: 0
X-MS-Office365-Filtering-HT: Tenant
X-Forefront-Antispam-Report: CIP:137.71.25.57;IPV:NLI;CTRY:US;EFV:NLI;SFV:NSPM;SFS:(10009020)(136003)(396003)(346002)(39860400002)(376002)(199004)(189003)(48376002)(8676002)(7696005)(51416003)(107886003)(86362001)(50226002)(2201001)(8936002)(356004)(6666004)(336012)(446003)(186003)(11346002)(54906003)(5660300002)(110136005)(316002)(2906002)(426003)(486006)(44832011)(478600001)(26005)(126002)(476003)(36756003)(50466002)(70206006)(47776003)(1076003)(305945005)(2616005)(7636002)(106002)(2870700001)(70586007)(246002)(76176011)(7416002)(4326008)(14444005);DIR:OUT;SFP:1101;SCL:1;SRVR:BL0PR03MB4196;H:nwd2mta2.analog.com;FPR:;SPF:Pass;LANG:en;PTR:nwd2mail11.analog.com;A:1;MX:1;
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: cb5bd848-287a-4801-c650-08d7378515c7
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600166)(711020)(4605104)(4709080)(1401327)(4618075)(2017052603328);SRVR:BL0PR03MB4196;
X-MS-TrafficTypeDiagnostic: BL0PR03MB4196:
X-Microsoft-Antispam-PRVS: <BL0PR03MB41965D237A02196C324ED933F9B00@BL0PR03MB4196.namprd03.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6790;
X-Forefront-PRVS: 01583E185C
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam-Message-Info: ykpgkae5sylVBpVdYD7IYK0zP2zusR0/RYz88wY5ed3uzoIwmn2K3Y1PohBzfOEn7Nh6/A8G0y1wtp/cgIN2zXT/baIAme7migVgPj/iz313+NWF6meEGuUTJQICRLZNDTqqI2W+bbRMrkcMPcEIwmPsxofciaEox5+9tn+pITvgpHmwDVj3d68Gy+q0/tn/4FVUcBRIAeZvrkVZOgv8Kdj9KP/o3iofldJ2xtJX89e5KKhYDy8+VP4SAyaF7emAIZb9b8l9XsLUnK+GFkKhic2qgSJqNG0xTyla7ybF/REZlvnpRtYu363DsLcbBxY9QgkuDWlMRtuPaVP/pgVQ0cH+r+vepmjCpZ/QPwHLO0++cAHpTNuBf1tGQL/xO1WxYs4YINFVPdPtM3ITvmmIjC2O2dczkjcWFQbd6MKlruA=
X-OriginatorOrg: analog.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Sep 2019 13:28:23.0495
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: cb5bd848-287a-4801-c650-08d7378515c7
X-MS-Exchange-CrossTenant-Id: eaa689b4-8f87-40e0-9c6f-7228de4d754a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=eaa689b4-8f87-40e0-9c6f-7228de4d754a;Ip=[137.71.25.57];Helo=[nwd2mta2.analog.com]
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL0PR03MB4196
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.70,1.0.8
 definitions=2019-09-12_06:2019-09-11,2019-09-12 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 suspectscore=0 bulkscore=0 clxscore=1015 mlxscore=0 phishscore=0
 mlxlogscore=999 impostorscore=0 adultscore=0 malwarescore=0 spamscore=0
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-1906280000 definitions=main-1909120142
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The `phy_tunable_id` has been named `ETHTOOL_PHY_EDPD` since it looks like
this feature is common across other PHYs (like EEE), and defining
`ETHTOOL_PHY_ENERGY_DETECT_POWER_DOWN` seems too long.

The way EDPD works, is that the RX block is put to a lower power mode,
except for link-pulse detection circuits. The TX block is also put to low
power mode, but the PHY wakes-up periodically to send link pulses, to avoid
lock-ups in case the other side is also in EDPD mode.

Currently, there are 2 PHY drivers that look like they could use this new
PHY tunable feature: the `adin` && `micrel` PHYs.

The ADIN's datasheet mentions that TX pulses are at intervals of 1 second
default each, and they can be disabled. For the Micrel KSZ9031 PHY, the
datasheet does not mention whether they can be disabled, but mentions that
they can modified.

The way this change is structured, is similar to the PHY tunable downshift
control:
* a `ETHTOOL_PHY_EDPD_DFLT_TX_MSECS` value is exposed to cover a default
  TX interval; some PHYs could specify a certain value that makes sense
* `ETHTOOL_PHY_EDPD_NO_TX` would disable TX when EDPD is enabled
* `ETHTOOL_PHY_EDPD_DISABLE` will disable EDPD

As noted by the `ETHTOOL_PHY_EDPD_DFLT_TX_MSECS` the interval unit is 1
millisecond, which should cover a reasonable range of intervals:
 - from 1 millisecond, which does not sound like much of a power-saver
 - to ~65 seconds which is quite a lot to wait for a link to come up when
   plugging a cable

Signed-off-by: Alexandru Ardelean <alexandru.ardelean@analog.com>
---
 include/uapi/linux/ethtool.h | 22 ++++++++++++++++++++++
 net/core/ethtool.c           |  6 ++++++
 2 files changed, 28 insertions(+)

diff --git a/include/uapi/linux/ethtool.h b/include/uapi/linux/ethtool.h
index dd06302aa93e..8938b76c4ee3 100644
--- a/include/uapi/linux/ethtool.h
+++ b/include/uapi/linux/ethtool.h
@@ -259,10 +259,32 @@ struct ethtool_tunable {
 #define ETHTOOL_PHY_FAST_LINK_DOWN_ON	0
 #define ETHTOOL_PHY_FAST_LINK_DOWN_OFF	0xff
 
+/* Energy Detect Power Down (EDPD) is a feature supported by some PHYs, where
+ * the PHY's RX & TX blocks are put into a low-power mode when there is no
+ * link detected (typically cable is un-plugged). For RX, only a minimal
+ * link-detection is available, and for TX the PHY wakes up to send link pulses
+ * to avoid any lock-ups in case the peer PHY may also be running in EDPD mode.
+ *
+ * Some PHYs may support configuration of the wake-up interval for TX pulses,
+ * and some PHYs may support only disabling TX pulses entirely. For the latter
+ * a special value is required (ETHTOOL_PHY_EDPD_NO_TX) so that this can be
+ * configured from userspace (should the user want it).
+ *
+ * The interval units for TX wake-up are in milliseconds, since this should
+ * cover a reasonable range of intervals:
+ *  - from 1 millisecond, which does not sound like much of a power-saver
+ *  - to ~65 seconds which is quite a lot to wait for a link to come up when
+ *    plugging a cable
+ */
+#define ETHTOOL_PHY_EDPD_DFLT_TX_MSECS		0xffff
+#define ETHTOOL_PHY_EDPD_NO_TX			0xfffe
+#define ETHTOOL_PHY_EDPD_DISABLE		0
+
 enum phy_tunable_id {
 	ETHTOOL_PHY_ID_UNSPEC,
 	ETHTOOL_PHY_DOWNSHIFT,
 	ETHTOOL_PHY_FAST_LINK_DOWN,
+	ETHTOOL_PHY_EDPD,
 	/*
 	 * Add your fresh new phy tunable attribute above and remember to update
 	 * phy_tunable_strings[] in net/core/ethtool.c
diff --git a/net/core/ethtool.c b/net/core/ethtool.c
index 6288e69e94fc..c763106c73fc 100644
--- a/net/core/ethtool.c
+++ b/net/core/ethtool.c
@@ -133,6 +133,7 @@ phy_tunable_strings[__ETHTOOL_PHY_TUNABLE_COUNT][ETH_GSTRING_LEN] = {
 	[ETHTOOL_ID_UNSPEC]     = "Unspec",
 	[ETHTOOL_PHY_DOWNSHIFT]	= "phy-downshift",
 	[ETHTOOL_PHY_FAST_LINK_DOWN] = "phy-fast-link-down",
+	[ETHTOOL_PHY_EDPD]	= "phy-energy-detect-power-down",
 };
 
 static int ethtool_get_features(struct net_device *dev, void __user *useraddr)
@@ -2451,6 +2452,11 @@ static int ethtool_phy_tunable_valid(const struct ethtool_tunable *tuna)
 		    tuna->type_id != ETHTOOL_TUNABLE_U8)
 			return -EINVAL;
 		break;
+	case ETHTOOL_PHY_EDPD:
+		if (tuna->len != sizeof(u16) ||
+		    tuna->type_id != ETHTOOL_TUNABLE_U16)
+			return -EINVAL;
+		break;
 	default:
 		return -EINVAL;
 	}
-- 
2.20.1


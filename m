Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D6BABB35B6
	for <lists+netdev@lfdr.de>; Mon, 16 Sep 2019 09:36:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729114AbfIPHfy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Sep 2019 03:35:54 -0400
Received: from mx0a-00128a01.pphosted.com ([148.163.135.77]:32202 "EHLO
        mx0a-00128a01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725776AbfIPHfx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 Sep 2019 03:35:53 -0400
Received: from pps.filterd (m0167089.ppops.net [127.0.0.1])
        by mx0a-00128a01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id x8G7XW4k013923;
        Mon, 16 Sep 2019 03:35:41 -0400
Received: from nam01-by2-obe.outbound.protection.outlook.com (mail-by2nam01lp2056.outbound.protection.outlook.com [104.47.34.56])
        by mx0a-00128a01.pphosted.com with ESMTP id 2v0w47jtts-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 16 Sep 2019 03:35:40 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Y9lPaHTbXMjJTfAOH0F2nklWnzyPxEzyEayE64JM2iP3iXbnpT+TW3M7lPdpMmbv5Z5UVVttUqG32TtcIgOFC7mgE3vjFG0vMtlL0kX8v14SqBdiWaxBIgi/bY2ZigGLZ6FuTWPhRXb25R05fBqcTX2PZVRIH/93dzc0X8btmLTftokzJeQ4D3tsrgc63vMnvpi+Ltqypm+CmUjUAHb6wgQDECGuWFIjfzRwEeQQIwuLwVV0RWnkkGTLVbHerwHkfii6hdrRQekxoj43hiXlKSnk5GiUN/EJpmkX+THMPcLJ5Ib6qQp0jzVbXNYRsPKmI0uVCdeAls8ZEvAgfBe9JQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HsCPHeruHC8uT20pjos60yhcvqYyLrY32H7xE7SYxDc=;
 b=P9Zujd9MAjnG9JsRR7w+fsf6RZkrXzvYx12/nH8WnAN0r22CnJGIla/7pKyXDss7Z1lUXkIZIoqq5208hPp02c7XSr3j9VRcDbT4yw/ibZ/t/fOpmLJh6jNeQYbjxvdua7CE0rnudkQ8qKnCDqt0Py/6G3dFPJMJqsx5z3lN1VBBZqZS7eaS1RFfeC7l4iY/ugd8TGUO1i+fE15q/4OsfkeN5DMb4IfAui2WIEwZboyc/Ux3srHd829FMvryR7UaM1KVANwz9ZjKRy1uK+Q0LN+xTxLR29f+4/S6Hwhqm6AXGZsJtB28TAeSLjB6yDIJXaloxLG8OVL7nLkbS0R6OA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 137.71.25.57) smtp.rcpttodomain=davemloft.net smtp.mailfrom=analog.com;
 dmarc=bestguesspass action=none header.from=analog.com; dkim=none (message
 not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=analog.onmicrosoft.com; s=selector2-analog-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HsCPHeruHC8uT20pjos60yhcvqYyLrY32H7xE7SYxDc=;
 b=7AJdAD9xslA5wfvldkbrASfQAAU24OEfeSPLmRhLM7HfYAajye+LbjWnsAuBxlz1I9XWbfnO0OEJ2Y28QCA2OXF86hgFNeAubC/VXfMJ51va2C7JhOKkdfTNwIC892sv8YvZmQlKFmf74/WYVgqMi6SFe+WsFlLH3TJsg+kO06o=
Received: from BN6PR03CA0094.namprd03.prod.outlook.com (2603:10b6:405:6f::32)
 by BN6PR03MB3201.namprd03.prod.outlook.com (2603:10b6:405:3f::34) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2263.24; Mon, 16 Sep
 2019 07:35:39 +0000
Received: from CY1NAM02FT058.eop-nam02.prod.protection.outlook.com
 (2a01:111:f400:7e45::207) by BN6PR03CA0094.outlook.office365.com
 (2603:10b6:405:6f::32) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2263.17 via Frontend
 Transport; Mon, 16 Sep 2019 07:35:39 +0000
Received-SPF: Pass (protection.outlook.com: domain of analog.com designates
 137.71.25.57 as permitted sender) receiver=protection.outlook.com;
 client-ip=137.71.25.57; helo=nwd2mta2.analog.com;
Received: from nwd2mta2.analog.com (137.71.25.57) by
 CY1NAM02FT058.mail.protection.outlook.com (10.152.74.149) with Microsoft SMTP
 Server (version=TLS1_0, cipher=TLS_RSA_WITH_AES_256_CBC_SHA) id 15.20.2263.17
 via Frontend Transport; Mon, 16 Sep 2019 07:35:38 +0000
Received: from NWD2HUBCAS7.ad.analog.com (nwd2hubcas7.ad.analog.com [10.64.69.107])
        by nwd2mta2.analog.com (8.13.8/8.13.8) with ESMTP id x8G7ZXaG021670
        (version=TLSv1/SSLv3 cipher=AES256-SHA bits=256 verify=OK);
        Mon, 16 Sep 2019 00:35:33 -0700
Received: from saturn.ad.analog.com (10.48.65.123) by
 NWD2HUBCAS7.ad.analog.com (10.64.69.107) with Microsoft SMTP Server id
 14.3.408.0; Mon, 16 Sep 2019 03:35:37 -0400
From:   Alexandru Ardelean <alexandru.ardelean@analog.com>
To:     <netdev@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
CC:     <davem@davemloft.net>, <robh+dt@kernel.org>,
        <mark.rutland@arm.com>, <f.fainelli@gmail.com>,
        <hkallweit1@gmail.com>, <andrew@lunn.ch>, <mkubecek@suse.cz>,
        Alexandru Ardelean <alexandru.ardelean@analog.com>
Subject: [PATCH v5 1/2] ethtool: implement Energy Detect Powerdown support via phy-tunable
Date:   Mon, 16 Sep 2019 10:35:25 +0300
Message-ID: <20190916073526.24711-2-alexandru.ardelean@analog.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190916073526.24711-1-alexandru.ardelean@analog.com>
References: <20190916073526.24711-1-alexandru.ardelean@analog.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ADIRoutedOnPrem: True
X-EOPAttributedMessage: 0
X-MS-Office365-Filtering-HT: Tenant
X-Forefront-Antispam-Report: CIP:137.71.25.57;IPV:NLI;CTRY:US;EFV:NLI;SFV:NSPM;SFS:(10009020)(376002)(39860400002)(346002)(396003)(136003)(189003)(199004)(486006)(4326008)(107886003)(305945005)(70586007)(70206006)(14444005)(316002)(110136005)(5660300002)(356004)(48376002)(6666004)(50466002)(246002)(106002)(44832011)(2616005)(8936002)(476003)(446003)(50226002)(54906003)(51416003)(7696005)(76176011)(7416002)(26005)(2201001)(36756003)(7636002)(478600001)(86362001)(1076003)(336012)(186003)(47776003)(426003)(126002)(11346002)(8676002)(2870700001)(2906002);DIR:OUT;SFP:1101;SCL:1;SRVR:BN6PR03MB3201;H:nwd2mta2.analog.com;FPR:;SPF:Pass;LANG:en;PTR:nwd2mail11.analog.com;MX:1;A:1;
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: a8265cad-7858-4820-9c9e-08d73a78789d
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(5600167)(711020)(4605104)(4709080)(1401327)(4618075)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(2017052603328);SRVR:BN6PR03MB3201;
X-MS-TrafficTypeDiagnostic: BN6PR03MB3201:
X-Microsoft-Antispam-PRVS: <BN6PR03MB320191DB5676E30DCAA234F8F98C0@BN6PR03MB3201.namprd03.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6790;
X-Forefront-PRVS: 0162ACCC24
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam-Message-Info: JprWWrMKx/vwVTIFqwT8iwFE9lBsq+TZpxnOsBt//NAE7O7KHWkQAZfQ6pjh/3M9+Ne9u86UKCr+sUZTNI+CzsggGhtawWuwEHIj/N4qLOjwU9I0E0bLgRz/Qj+t6DxH9o7APGY0ctN5LY4oo49CJfL0kgHBmceXQX99pLE2swlEaf1i5f9krHAQs8FUxQ5/fdSnC38vWupWlzgSsEZPdQzE4ElJJP4QB+LsvznV2jzsFjYoxu59nb9U1C7yFse36Le1tHL4OgzX9BEbkn7FHiMdtsXlrcaNta72YTlILAnsUNJb3MVQHGp6T3T55M0B1lbm1AijIq4imtSDugAl3cyNGGtlTfH6PJ/gL/N3yJJkionSXy65OcbUK9xlQZCBWHO0mnSLYayNuh85IANe6AMBxdjiYUWpZxwR7s+7Mu8=
X-OriginatorOrg: analog.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Sep 2019 07:35:38.9025
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: a8265cad-7858-4820-9c9e-08d73a78789d
X-MS-Exchange-CrossTenant-Id: eaa689b4-8f87-40e0-9c6f-7228de4d754a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=eaa689b4-8f87-40e0-9c6f-7228de4d754a;Ip=[137.71.25.57];Helo=[nwd2mta2.analog.com]
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN6PR03MB3201
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.70,1.0.8
 definitions=2019-09-16_04:2019-09-11,2019-09-16 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 adultscore=0
 lowpriorityscore=0 impostorscore=0 mlxscore=0 mlxlogscore=999
 malwarescore=0 bulkscore=0 priorityscore=1501 suspectscore=0 spamscore=0
 phishscore=0 clxscore=1015 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-1908290000 definitions=main-1909160082
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

Reviewed-by: Andrew Lunn <andrew@lunn.ch>
Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
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


Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E1B03AD9C1
	for <lists+netdev@lfdr.de>; Mon,  9 Sep 2019 15:13:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404887AbfIINNf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Sep 2019 09:13:35 -0400
Received: from mx0a-00128a01.pphosted.com ([148.163.135.77]:25698 "EHLO
        mx0a-00128a01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2404870AbfIINNf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 Sep 2019 09:13:35 -0400
Received: from pps.filterd (m0167089.ppops.net [127.0.0.1])
        by mx0a-00128a01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id x89D7ogc007270;
        Mon, 9 Sep 2019 09:13:22 -0400
Received: from nam04-bn3-obe.outbound.protection.outlook.com (mail-bn3nam04lp2055.outbound.protection.outlook.com [104.47.46.55])
        by mx0a-00128a01.pphosted.com with ESMTP id 2uv9f67hcw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 09 Sep 2019 09:13:22 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=j3+WuhHbvthBU5tv32BvBSWacH5EDPiWjuNoQwVdZgSDnBBmZaq3IV4tfTxG6q/IPp5nxAYpYXUfUZhKhYY313YR1/sME43jLVn4X7QfBGDjCwvsCMUtTxXl1n4hsqGk8oTDFRQwRu6J3NAwWvQrbyW5OP0fntfSjxfu0k91w4Co2pwRxGkH9Ts6bUoaDtudjNfOg77+IcD9yhozZh8Uf45vsJsannIMBvi0zmEk6LEXoRMcLmC7BUaGMfYlVannMSPdQwk7G7vhrjSyoaP5farlJUIMSO50z1GY8N5MVNnN/CSChHo312QVcxMGTKYPf3SMSUZFipx5hL6xMz4GTA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=IvzvT9gGvTr7R4xLkOIkF334SLVFb7TPO26JRy8ZkN8=;
 b=BoOH3fBy48UH2Eoav+ZD8x2XlemEbEILlVUbOhNes00gDRp+opqDPeUkBx13FrwKcJlVr20KXLtdZZq/OOf9Gw5ESmzpnS7qDSKe6qsFs6Lg+QPwYfryAER7Lv+YaF1Xispka1S2UoplPAbmdYjb+iserHKp6LKG+IYyn9uEeHmOeSy5OLxqNkO+cg+mi/0Us7Y1eOgjfz0ERdxw47vEt2kFsX0Vm3gm3+snSXZpLwdhuYBp3yiAt8+3wV9PkkQ+qepz0mmKZmNqmT+LgwFjdWN88g0trnftys8NO1jJwD+8AneDMwoLKiVz7g8cAk4AbBG5Yx669X3BIKcNzB2rpA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 137.71.25.57) smtp.rcpttodomain=davemloft.net smtp.mailfrom=analog.com;
 dmarc=bestguesspass action=none header.from=analog.com; dkim=none (message
 not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=analog.onmicrosoft.com; s=selector2-analog-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=IvzvT9gGvTr7R4xLkOIkF334SLVFb7TPO26JRy8ZkN8=;
 b=SOekyrhA/xVeoqhTBdGXApKMxb06x04orT1727btigsNbhKsHJtLmT8HBagFHzgnyEFwT2xpAftQcgS4kibZOppR3TaKFgOOzarA62Q5k/gYgUW9K4dKgJ2N7zc0DhFaGkeIV0wgr7POfCzF2Z+XLRtVF+aj+o6HJprI/FIvGUs=
Received: from BN6PR03CA0101.namprd03.prod.outlook.com (2603:10b6:404:10::15)
 by SN6PR03MB3614.namprd03.prod.outlook.com (2603:10b6:805:42::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2241.14; Mon, 9 Sep
 2019 13:13:19 +0000
Received: from CY1NAM02FT010.eop-nam02.prod.protection.outlook.com
 (2a01:111:f400:7e45::207) by BN6PR03CA0101.outlook.office365.com
 (2603:10b6:404:10::15) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2241.14 via Frontend
 Transport; Mon, 9 Sep 2019 13:13:18 +0000
Received-SPF: Pass (protection.outlook.com: domain of analog.com designates
 137.71.25.57 as permitted sender) receiver=protection.outlook.com;
 client-ip=137.71.25.57; helo=nwd2mta2.analog.com;
Received: from nwd2mta2.analog.com (137.71.25.57) by
 CY1NAM02FT010.mail.protection.outlook.com (10.152.75.50) with Microsoft SMTP
 Server (version=TLS1_0, cipher=TLS_RSA_WITH_AES_256_CBC_SHA) id 15.20.2241.14
 via Frontend Transport; Mon, 9 Sep 2019 13:13:17 +0000
Received: from NWD2HUBCAS7.ad.analog.com (nwd2hubcas7.ad.analog.com [10.64.69.107])
        by nwd2mta2.analog.com (8.13.8/8.13.8) with ESMTP id x89DDCkj028624
        (version=TLSv1/SSLv3 cipher=AES256-SHA bits=256 verify=OK);
        Mon, 9 Sep 2019 06:13:12 -0700
Received: from saturn.ad.analog.com (10.48.65.123) by
 NWD2HUBCAS7.ad.analog.com (10.64.69.107) with Microsoft SMTP Server id
 14.3.408.0; Mon, 9 Sep 2019 09:13:16 -0400
From:   Alexandru Ardelean <alexandru.ardelean@analog.com>
To:     <netdev@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
CC:     <davem@davemloft.net>, <robh+dt@kernel.org>,
        <mark.rutland@arm.com>, <f.fainelli@gmail.com>,
        <hkallweit1@gmail.com>, <andrew@lunn.ch>,
        Alexandru Ardelean <alexandru.ardelean@analog.com>
Subject: [PATCH v3 1/2] ethtool: implement Energy Detect Powerdown support via phy-tunable
Date:   Mon, 9 Sep 2019 16:12:50 +0300
Message-ID: <20190909131251.3634-2-alexandru.ardelean@analog.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190909131251.3634-1-alexandru.ardelean@analog.com>
References: <20190909131251.3634-1-alexandru.ardelean@analog.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ADIRoutedOnPrem: True
X-EOPAttributedMessage: 0
X-MS-Office365-Filtering-HT: Tenant
X-Forefront-Antispam-Report: CIP:137.71.25.57;IPV:NLI;CTRY:US;EFV:NLI;SFV:NSPM;SFS:(10009020)(376002)(396003)(136003)(346002)(39860400002)(2980300002)(199004)(189003)(356004)(4326008)(110136005)(54906003)(107886003)(316002)(47776003)(50226002)(305945005)(7636002)(486006)(1076003)(246002)(186003)(76176011)(336012)(126002)(426003)(51416003)(446003)(11346002)(44832011)(48376002)(36756003)(50466002)(7696005)(2906002)(476003)(26005)(70586007)(2616005)(70206006)(8676002)(8936002)(2201001)(86362001)(5660300002)(478600001)(6666004)(14444005)(2870700001)(106002);DIR:OUT;SFP:1101;SCL:1;SRVR:SN6PR03MB3614;H:nwd2mta2.analog.com;FPR:;SPF:Pass;LANG:en;PTR:nwd2mail11.analog.com;A:1;MX:1;
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: d86bb189-aff3-4328-3d4e-08d735277b4b
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600166)(711020)(4605104)(4709080)(1401327)(4618075)(2017052603328);SRVR:SN6PR03MB3614;
X-MS-TrafficTypeDiagnostic: SN6PR03MB3614:
X-Microsoft-Antispam-PRVS: <SN6PR03MB3614ACF11F6BAF8BCD5C913EF9B70@SN6PR03MB3614.namprd03.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8273;
X-Forefront-PRVS: 01559F388D
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam-Message-Info: NH6NnDsQ36DLYz+n0t5XwvkRMmwroEP2n+4BhqGfzCv9UR2FRruxMcJFJ+gpj7qUxbuexuzO2aTxnFER1jN89xLuZA2uuM8LBxv0iikQVC1usZpZn+vKAT2dsPxTuv1037gTe8vQSknxcGv6+MeLyAXM4zVwE75WWh3X06ExIbu4Tlj6aXHiH9bADxXXKKGMi1U9pmghPZA0M4yT9FSU9oNWtwq3IWqInxHRwHjwromfqVgf9XpmS4zv7LUz34PTWRQxLCghV3Avd2sZczKOGZK7xPVQQTal4KzXfQ8yLU5dfsEWn3ap3gwKyLCBCRmSY6xrW10th5RkVihNF+t/9C+tdtQGDvOhtbJ++4V/4NpPCPtIhPgzCpc9faVOqaeOpv+MO09KT03PhYhrkUPFWq0fF9i71GHRugjSb1A+9t4=
X-OriginatorOrg: analog.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Sep 2019 13:13:17.8955
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: d86bb189-aff3-4328-3d4e-08d735277b4b
X-MS-Exchange-CrossTenant-Id: eaa689b4-8f87-40e0-9c6f-7228de4d754a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=eaa689b4-8f87-40e0-9c6f-7228de4d754a;Ip=[137.71.25.57];Helo=[nwd2mta2.analog.com]
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR03MB3614
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.70,1.0.8
 definitions=2019-09-09_05:2019-09-09,2019-09-09 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 suspectscore=0 spamscore=0 adultscore=0 phishscore=0 mlxscore=0
 impostorscore=0 bulkscore=0 lowpriorityscore=0 malwarescore=0
 mlxlogscore=999 clxscore=1015 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-1906280000 definitions=main-1909090136
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
* a `ETHTOOL_PHY_EDPD_DFLT_TX_INTERVAL` value is exposed to cover a default
  TX interval; some PHYs could specify a certain value that makes sense
* `ETHTOOL_PHY_EDPD_NO_TX` would disable TX when EDPD is enabled
* `ETHTOOL_PHY_EDPD_DISABLE` will disable EDPD

This should allow PHYs to:
* enable EDPD and not enable TX pulses (interval would be 0)
* enable EDPD and configure TX pulse interval; note that TX interval units
  would be PHY specific; we could consider `seconds` as units, but it could
  happen that some PHYs would be prefer milliseconds as a unit;
  a maximum of 65533 units should be sufficient
* disable EDPD

Signed-off-by: Alexandru Ardelean <alexandru.ardelean@analog.com>
---
 include/uapi/linux/ethtool.h | 19 +++++++++++++++++++
 net/core/ethtool.c           |  6 ++++++
 2 files changed, 25 insertions(+)

diff --git a/include/uapi/linux/ethtool.h b/include/uapi/linux/ethtool.h
index dd06302aa93e..5961b4984cb6 100644
--- a/include/uapi/linux/ethtool.h
+++ b/include/uapi/linux/ethtool.h
@@ -259,10 +259,29 @@ struct ethtool_tunable {
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
+ * The interval units for TX wake-up are PHY specific, as some PHYs may require
+ * seconds as intervals, and some would require milliseconds.
+ */
+#define ETHTOOL_PHY_EDPD_DFLT_TX_INTERVAL	0xffff
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


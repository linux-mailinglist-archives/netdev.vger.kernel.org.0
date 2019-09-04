Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 869EFA846D
	for <lists+netdev@lfdr.de>; Wed,  4 Sep 2019 15:49:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730156AbfIDNX5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Sep 2019 09:23:57 -0400
Received: from mx0b-00128a01.pphosted.com ([148.163.139.77]:4662 "EHLO
        mx0b-00128a01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727675AbfIDNX4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 Sep 2019 09:23:56 -0400
Received: from pps.filterd (m0167090.ppops.net [127.0.0.1])
        by mx0b-00128a01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id x84DNOiF027845;
        Wed, 4 Sep 2019 09:23:50 -0400
Received: from nam01-sn1-obe.outbound.protection.outlook.com (mail-sn1nam01lp2052.outbound.protection.outlook.com [104.47.32.52])
        by mx0b-00128a01.pphosted.com with ESMTP id 2uqnh5fpj2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 04 Sep 2019 09:23:50 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=U+seGsod1H+HZGhlcpSoB7rtKWefU4jPQyOjf6TrY+h5UkPAGBvVLbN+aW21USvitTDG2xNKQtrJloYMNqpLaQmteKq80Y8phdJY0VN0MzN7Yax+RZubIqQ0HlitaaDe3rnV8CZnO1cmBF5LwfFMFgB1iZq/kpIlLZ5roLAQ3L7WF72XS/gYo7ki6Xsy+J+dSgSF5cqHb/PIIGW4GIJLwuP6fTdYwrSVzSvIu0TIiGjOebSGwBcKg/ttc/yeuE9GK25v2qRIf90RCP3SCOaYvwroxwfb6iIxAJJCR/uA2KScAOpgKko5E48rERmgTUxvA0TWxbTRGQByU5TYgNA2/g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=EwyWsWTTjnhaEVbnOb0I+raOCV6dgAKf/IPOLbO6ze0=;
 b=gSz8rpEBvn8kt0i+uWj6soGckh9IU5xIDnx0NTNIXIU+ztxR3MuZnlA5gER9bq0lM9Ox5GPDCoLt/59cIHhkJAcCrKW6S2OTd0K4/e2i7uZGp/GuLOQ6T1G2VxT9lNW+DHRXFI+z9V1V9DrpO1+4huXvQ0NhnKfT1hc7f572dzculbBvf9lQdcu7uDOZjJe/30q+/an4M3Ke907H1nkIj3VbY3zaOVvgSxPo5/w3/2LyhVGgBqLnFUoCAUqAHu1RedF9/Qy76Vit0mbGoW2CbyXigB08MFGwvt+UNTJXwCvRGzmyOQCQ43DVHZzeVnQNRqXobPMrEPp2sozaXq3fCw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 137.71.25.57) smtp.rcpttodomain=lunn.ch smtp.mailfrom=analog.com;
 dmarc=bestguesspass action=none header.from=analog.com; dkim=none (message
 not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=analog.onmicrosoft.com; s=selector2-analog-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=EwyWsWTTjnhaEVbnOb0I+raOCV6dgAKf/IPOLbO6ze0=;
 b=yRIbvoDjsNvmMFIyzsfbHbHuHmgF6+68RvwoHUydVms9Wke70u9AY5fRZns+0oSKZgRWjtv+wwBmi9UMqynAzWrD/2CHx9vqjSIBfsb4C0cUmokP97CA8MdKtMSdAyHZNxcnyYWZiKowNciyYGcIuCoIWZGBkT4n8yndVammk1I=
Received: from MWHPR03CA0019.namprd03.prod.outlook.com (2603:10b6:300:117::29)
 by BN7PR03MB3523.namprd03.prod.outlook.com (2603:10b6:406:bf::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2220.19; Wed, 4 Sep
 2019 13:23:46 +0000
Received: from CY1NAM02FT010.eop-nam02.prod.protection.outlook.com
 (2a01:111:f400:7e45::201) by MWHPR03CA0019.outlook.office365.com
 (2603:10b6:300:117::29) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2241.14 via Frontend
 Transport; Wed, 4 Sep 2019 13:23:45 +0000
Received-SPF: Pass (protection.outlook.com: domain of analog.com designates
 137.71.25.57 as permitted sender) receiver=protection.outlook.com;
 client-ip=137.71.25.57; helo=nwd2mta2.analog.com;
Received: from nwd2mta2.analog.com (137.71.25.57) by
 CY1NAM02FT010.mail.protection.outlook.com (10.152.75.50) with Microsoft SMTP
 Server (version=TLS1_0, cipher=TLS_RSA_WITH_AES_256_CBC_SHA) id 15.20.2220.16
 via Frontend Transport; Wed, 4 Sep 2019 13:23:43 +0000
Received: from NWD2HUBCAS7.ad.analog.com (nwd2hubcas7.ad.analog.com [10.64.69.107])
        by nwd2mta2.analog.com (8.13.8/8.13.8) with ESMTP id x84DNgaY019827
        (version=TLSv1/SSLv3 cipher=AES256-SHA bits=256 verify=OK);
        Wed, 4 Sep 2019 06:23:42 -0700
Received: from saturn.ad.analog.com (10.48.65.123) by
 NWD2HUBCAS7.ad.analog.com (10.64.69.107) with Microsoft SMTP Server id
 14.3.408.0; Wed, 4 Sep 2019 09:23:41 -0400
From:   Alexandru Ardelean <alexandru.ardelean@analog.com>
To:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC:     <andrew@lunn.ch>, <f.fainelli@gmail.com>, <hkallweit1@gmail.com>,
        <davem@davemloft.net>,
        Alexandru Ardelean <alexandru.ardelean@analog.com>
Subject: [PATCH v2 1/2] ethtool: implement Energy Detect Powerdown support via phy-tunable
Date:   Wed, 4 Sep 2019 19:23:21 +0300
Message-ID: <20190904162322.17542-2-alexandru.ardelean@analog.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190904162322.17542-1-alexandru.ardelean@analog.com>
References: <20190904162322.17542-1-alexandru.ardelean@analog.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ADIRoutedOnPrem: True
X-EOPAttributedMessage: 0
X-MS-Office365-Filtering-HT: Tenant
X-Forefront-Antispam-Report: CIP:137.71.25.57;IPV:NLI;CTRY:US;EFV:NLI;SFV:NSPM;SFS:(10009020)(376002)(136003)(396003)(39860400002)(346002)(2980300002)(189003)(199004)(86362001)(1076003)(246002)(54906003)(110136005)(50226002)(47776003)(186003)(8936002)(476003)(26005)(106002)(5660300002)(8676002)(486006)(336012)(2616005)(126002)(478600001)(44832011)(356004)(6666004)(446003)(11346002)(426003)(316002)(36756003)(7636002)(4326008)(2906002)(2870700001)(305945005)(70586007)(107886003)(70206006)(51416003)(76176011)(7696005)(14444005)(48376002)(50466002);DIR:OUT;SFP:1101;SCL:1;SRVR:BN7PR03MB3523;H:nwd2mta2.analog.com;FPR:;SPF:Pass;LANG:en;PTR:nwd2mail11.analog.com;MX:1;A:1;
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 04161901-0d38-4c3a-61ad-08d7313b1cc7
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600166)(711020)(4605104)(4709080)(1401327)(4618075)(2017052603328);SRVR:BN7PR03MB3523;
X-MS-TrafficTypeDiagnostic: BN7PR03MB3523:
X-Microsoft-Antispam-PRVS: <BN7PR03MB3523226CF693011822708F54F9B80@BN7PR03MB3523.namprd03.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7691;
X-Forefront-PRVS: 0150F3F97D
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam-Message-Info: FowBlHPxDtZrkUBK6aIHWH2lidchYmd3YnBNyID43rS5JexsGwTegykmWz6Bg6/6YLmjoxCuRqEkyZ6mSYZCLvyUtipwNQNrsNdtoVAxHz845JsZjMcxSSlfJXKyV7akta5glIhLNupHjoNCh9J9TN28ZbCgxYhpsMGqwvBmR582MMLG0824nhB8DgGI260rxyUxRXS9/0bLIzxjqS3IKtiQe03nhkI4++EVLwttyB8/Fwr3KwC95qIBEq4PbxyjZa4A9FyoXrTjLNlvowMqZXuKnB+g+TnBrG1nguVWvqGwNsUzYWFziDG5o7zSM2QcZ2gwfvbl/hpqqK7QAsCuyzgM8fAM91FSuPsJ1IWXWi0CwZXKyru822+ADBG+2Cxqx3BBd3631iH912BHaompV/Wa6LzJKEIHzamKPKDwe4I=
X-OriginatorOrg: analog.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Sep 2019 13:23:43.7853
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 04161901-0d38-4c3a-61ad-08d7313b1cc7
X-MS-Exchange-CrossTenant-Id: eaa689b4-8f87-40e0-9c6f-7228de4d754a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=eaa689b4-8f87-40e0-9c6f-7228de4d754a;Ip=[137.71.25.57];Helo=[nwd2mta2.analog.com]
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN7PR03MB3523
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.70,1.0.8
 definitions=2019-09-04_04:2019-09-03,2019-09-04 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015 suspectscore=0
 mlxscore=0 adultscore=0 priorityscore=1501 bulkscore=0 impostorscore=0
 mlxlogscore=999 spamscore=0 malwarescore=0 phishscore=0 lowpriorityscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-1906280000
 definitions=main-1909040135
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
  happen that some PHYs would be prefer 500 milliseconds as a unit;
  a maximum of 32766 units should be sufficient
* disable EDPD

Signed-off-by: Alexandru Ardelean <alexandru.ardelean@analog.com>
---
 include/uapi/linux/ethtool.h | 5 +++++
 net/core/ethtool.c           | 6 ++++++
 2 files changed, 11 insertions(+)

diff --git a/include/uapi/linux/ethtool.h b/include/uapi/linux/ethtool.h
index dd06302aa93e..0349e9c4350f 100644
--- a/include/uapi/linux/ethtool.h
+++ b/include/uapi/linux/ethtool.h
@@ -259,10 +259,15 @@ struct ethtool_tunable {
 #define ETHTOOL_PHY_FAST_LINK_DOWN_ON	0
 #define ETHTOOL_PHY_FAST_LINK_DOWN_OFF	0xff
 
+#define ETHTOOL_PHY_EDPD_DFLT_TX_INTERVAL	0x7fff
+#define ETHTOOL_PHY_EDPD_NO_TX			0x8000
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


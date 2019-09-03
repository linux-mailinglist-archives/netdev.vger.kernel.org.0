Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2CA96A6959
	for <lists+netdev@lfdr.de>; Tue,  3 Sep 2019 15:07:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729393AbfICNGr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Sep 2019 09:06:47 -0400
Received: from mx0b-00128a01.pphosted.com ([148.163.139.77]:53382 "EHLO
        mx0b-00128a01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729385AbfICNGq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 Sep 2019 09:06:46 -0400
Received: from pps.filterd (m0167090.ppops.net [127.0.0.1])
        by mx0b-00128a01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id x83D2xOc027325;
        Tue, 3 Sep 2019 09:06:42 -0400
Received: from nam05-by2-obe.outbound.protection.outlook.com (mail-by2nam05lp2055.outbound.protection.outlook.com [104.47.50.55])
        by mx0b-00128a01.pphosted.com with ESMTP id 2uqnh5d9db-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 03 Sep 2019 09:06:42 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kWNLZJsrL+Gx29sXZHWnwJKQVsJ1rblbOW0DnWH8hebHcpVTimqkes56OMfb7f8IPVn3Sf1JZVizPhznTHOEGxVyKOAxS30lyQ1Atb4ntNuV/pn5doBKeK+GDCeoRgomwr4g60X+XSz9JhM0kdcB2x0jgq36ItiKJFVoAbBil4FdSzznBc9VA7f1Wzg/Uc4G20wjbeuLGPVbS7NdnfwV3bohhY8Mxe9wkdqlOmx6V6zOSH6nOZKCJ/Snz8Xa6Yj9SjYMxw5ZDwpV8hQ5bFIfVgWuVcXODPebnXtb7yQGestyGVKDS38h6DtoZeyMnifExby+y+MH1iI2u9CKafArww==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=EwyWsWTTjnhaEVbnOb0I+raOCV6dgAKf/IPOLbO6ze0=;
 b=EaUMg78lnkIRgl7o/z4dsvsZGyP1BPJiGBbbaxBh2BnNSVbkxlRN6IBV8kJUf7pgC0W6sKcibvM8MNJQhDion4SrKCG3HYpFAT0O8eSptTZFqFr8VoTa0Gc0TQXXRbPFCNanVQVMGMgnRAHiEiKE1OawWSq00YpOL9qYVqjRhVNJpsPHkIiRCgrlidkf34CK2vnZlCkwTarzdoTX3hTlGWRdn8nqH38qhyTwb8vKlH3l735n3A/eH2slSq6EyLo7MC/88jj3ACGTz5+R+XBEtmvNu1t2N3zId6OQ3lr+hO+hM/AlIep1hz4WxTGxVaNEB1C7duNsihAKP6do+2ymsw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 137.71.25.55) smtp.rcpttodomain=lunn.ch smtp.mailfrom=analog.com;
 dmarc=bestguesspass action=none header.from=analog.com; dkim=none (message
 not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=analog.onmicrosoft.com; s=selector2-analog-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=EwyWsWTTjnhaEVbnOb0I+raOCV6dgAKf/IPOLbO6ze0=;
 b=auBBgZ6XvDfuqF+PEwz5mDI+zOR4b3nKIla8pufvC5BQbc93oOakrKIGOo1EAbMqiZYDRbn6q9E5GDh7vWRkyL1BVj8d77jikmVN1Oa2YNENmod7/whiY7nJf/m1SsIyfc4T/sUj2+mUtjXndX7vACJB9e4ICksurAqOfstdMAE=
Received: from BN6PR03CA0013.namprd03.prod.outlook.com (2603:10b6:404:23::23)
 by DM5PR03MB3340.namprd03.prod.outlook.com (2603:10b6:4:43::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2199.19; Tue, 3 Sep
 2019 13:06:38 +0000
Received: from BL2NAM02FT016.eop-nam02.prod.protection.outlook.com
 (2a01:111:f400:7e46::200) by BN6PR03CA0013.outlook.office365.com
 (2603:10b6:404:23::23) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2220.19 via Frontend
 Transport; Tue, 3 Sep 2019 13:06:38 +0000
Received-SPF: Pass (protection.outlook.com: domain of analog.com designates
 137.71.25.55 as permitted sender) receiver=protection.outlook.com;
 client-ip=137.71.25.55; helo=nwd2mta1.analog.com;
Received: from nwd2mta1.analog.com (137.71.25.55) by
 BL2NAM02FT016.mail.protection.outlook.com (10.152.77.171) with Microsoft SMTP
 Server (version=TLS1_0, cipher=TLS_RSA_WITH_AES_256_CBC_SHA) id 15.20.2220.16
 via Frontend Transport; Tue, 3 Sep 2019 13:06:38 +0000
Received: from NWD2HUBCAS7.ad.analog.com (nwd2hubcas7.ad.analog.com [10.64.69.107])
        by nwd2mta1.analog.com (8.13.8/8.13.8) with ESMTP id x83D6XFE024841
        (version=TLSv1/SSLv3 cipher=AES256-SHA bits=256 verify=OK);
        Tue, 3 Sep 2019 06:06:33 -0700
Received: from saturn.ad.analog.com (10.48.65.123) by
 NWD2HUBCAS7.ad.analog.com (10.64.69.107) with Microsoft SMTP Server id
 14.3.408.0; Tue, 3 Sep 2019 09:06:37 -0400
From:   Alexandru Ardelean <alexandru.ardelean@analog.com>
To:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC:     <andrew@lunn.ch>, <f.fainelli@gmail.com>, <hkallweit1@gmail.com>,
        <davem@davemloft.net>,
        Alexandru Ardelean <alexandru.ardelean@analog.com>
Subject: [PATCH 1/4] ethtool: implement Energy Detect Powerdown support via phy-tunable
Date:   Tue, 3 Sep 2019 19:06:23 +0300
Message-ID: <20190903160626.7518-2-alexandru.ardelean@analog.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190903160626.7518-1-alexandru.ardelean@analog.com>
References: <20190903160626.7518-1-alexandru.ardelean@analog.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ADIRoutedOnPrem: True
X-EOPAttributedMessage: 0
X-MS-Office365-Filtering-HT: Tenant
X-Forefront-Antispam-Report: CIP:137.71.25.55;IPV:NLI;CTRY:US;EFV:NLI;SFV:NSPM;SFS:(10009020)(376002)(136003)(346002)(39860400002)(396003)(2980300002)(189003)(199004)(11346002)(186003)(486006)(5660300002)(50466002)(126002)(476003)(446003)(2616005)(48376002)(478600001)(2906002)(107886003)(36756003)(4326008)(76176011)(336012)(426003)(26005)(2870700001)(51416003)(7696005)(47776003)(1076003)(8936002)(70206006)(106002)(110136005)(316002)(14444005)(7636002)(6666004)(356004)(50226002)(305945005)(86362001)(44832011)(8676002)(70586007)(246002)(54906003);DIR:OUT;SFP:1101;SCL:1;SRVR:DM5PR03MB3340;H:nwd2mta1.analog.com;FPR:;SPF:Pass;LANG:en;PTR:nwd2mail10.analog.com;MX:1;A:1;
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 3de575bd-aba8-4b3f-e394-08d7306f8e5f
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600166)(711020)(4605104)(4709080)(1401327)(4618075)(2017052603328);SRVR:DM5PR03MB3340;
X-MS-TrafficTypeDiagnostic: DM5PR03MB3340:
X-Microsoft-Antispam-PRVS: <DM5PR03MB33407E20393A21CEE22F00EFF9B90@DM5PR03MB3340.namprd03.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7691;
X-Forefront-PRVS: 01494FA7F7
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam-Message-Info: MNMTj/Rt8shYCr1a21nEIGDwkYuFBYU/1Mc+HBkfXrc9R0PEFRvhFqQz4Non744C97IQkbJJoUb1eW+8XTL2AKuwq+oiK0gK6MnF7BZ9HvMAIDyLQpAOCd11C/Sn+umb72GOKJ/IUNVBSNNQWcHBNT2zumWpBNEFa05FpNOH9dELtWIjcXGxdiWPQFGmspddFx3iEIwMyCme9FIYvrir+r8i9dCRvr2uJy88e8/WAMziMQVIsFCBzFPsnMPMqCtSZGkFssx5/69Z7DBl0L7I98s1VJNVJWs8pq8xPajhr9szIVq5FiemBQuoy9v1mlein/XleHp/kEdU2NYC4w4y7uxh/6StHpKmaLF6nHQArkDLdZlf0G3d75rnCUrGTQ+is0a1I1srTUVzHgrOVzk8fM9ek9PjJSjC2aVdSajS8eo=
X-OriginatorOrg: analog.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Sep 2019 13:06:38.3245
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 3de575bd-aba8-4b3f-e394-08d7306f8e5f
X-MS-Exchange-CrossTenant-Id: eaa689b4-8f87-40e0-9c6f-7228de4d754a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=eaa689b4-8f87-40e0-9c6f-7228de4d754a;Ip=[137.71.25.55];Helo=[nwd2mta1.analog.com]
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR03MB3340
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.70,1.0.8
 definitions=2019-09-03_02:2019-09-03,2019-09-03 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015 suspectscore=0
 mlxscore=0 adultscore=0 priorityscore=1501 bulkscore=0 impostorscore=0
 mlxlogscore=999 spamscore=0 malwarescore=0 phishscore=0 lowpriorityscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-1906280000
 definitions=main-1909030137
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


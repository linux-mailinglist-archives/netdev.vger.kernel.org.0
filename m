Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9379748BA40
	for <lists+netdev@lfdr.de>; Tue, 11 Jan 2022 22:56:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231654AbiAKVz5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 Jan 2022 16:55:57 -0500
Received: from mx0c-0054df01.pphosted.com ([67.231.159.91]:15928 "EHLO
        mx0c-0054df01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231287AbiAKVzv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 11 Jan 2022 16:55:51 -0500
Received: from pps.filterd (m0208999.ppops.net [127.0.0.1])
        by mx0c-0054df01.pphosted.com (8.16.1.2/8.16.1.2) with ESMTP id 20BCxNSl017415;
        Tue, 11 Jan 2022 16:55:33 -0500
Received: from can01-to1-obe.outbound.protection.outlook.com (mail-to1can01lp2054.outbound.protection.outlook.com [104.47.61.54])
        by mx0c-0054df01.pphosted.com (PPS) with ESMTPS id 3dgjrs98t6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 11 Jan 2022 16:55:32 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=EMMnp3rJfRdlg1Vw1W2qkWLok6hPWu1no4NowKLWhNCRJB9D0NSvM31VTE8DeERbsbrhVJBgsFV0CgOq8gAplBAeay4NtvrEMr0gSwM/uai8HiG7YDtqBAMk8lwEHYFdiKibtPNWX8doV/w0hc7hSxZGq/vMR93vcFfzwaHnxvcgZnxQhcBp/pKYolTAkgR+ZJCt6EpzakgqiJhPyErzYdjK+Q55JTFVQfsKRS7uqKRvqViIT0ZX3IN1nBG6fQFgJFRxE4xy3QLHtjLMAt4YtCG1581qcL5U2hZXn9LexNdbS/ccwgvmOhE6BInuE68NTPZ3WAHcBScuUQPWRy/9YQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ZpXWaBZB/QYS8THuKXaWQSKjFB8HiOgnMRklhzH7QlM=;
 b=kBuYLjUDUCk8+JiMFFV6Q4Tp9SgMq6BTRse48ZpGO7uY2ZogqjIwNCGgUq+pq+NzsbJCFTBlQ6ZLD8Sxg9yfnGFsnVe+zybP5DlGxgmq1+1nZsSU3LUH4MygPm+6L9IOQVzuUY7wouMMWbsxWiSJzaRe9ViOUyCR7obrfjCIPTRIFlaoPZ9XtQX2uh6OEArRCHSG3W1v/7ZFUs52lf7GzrqhfNg0lwWtOcTBWTBzmhubrjzcHWIsZdZqmOPD1bfH9DuWmAH8B5oJL2SmWX9IulSXntSrjg5u4r+kdqH4g2qr0U/69sAub+UExuPJSNs8rxSj1gv6vWWB0gQ91x217g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=calian.com; dmarc=pass action=none header.from=calian.com;
 dkim=pass header.d=calian.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=calian.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZpXWaBZB/QYS8THuKXaWQSKjFB8HiOgnMRklhzH7QlM=;
 b=tqvSheuFcctPXEsS0Y49oIH+7iy6m6tHNw1hkqQ+903JVOv4oZHS8hH/g4q1nvdTxO0WqcLpRzP1tUunvznwwwv8BXTHf3Jdyda9MJyuXuQwrph1t/ZZzDmYRMcSFS/np46ObumdpuoO81jSj8s7G0n2VnL0AWJSO3MmCXFDUfQ=
Received: from YT3PR01MB6274.CANPRD01.PROD.OUTLOOK.COM (2603:10b6:b01:6a::19)
 by YTOPR0101MB0860.CANPRD01.PROD.OUTLOOK.COM (2603:10b6:b00:24::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4867.11; Tue, 11 Jan
 2022 21:55:31 +0000
Received: from YT3PR01MB6274.CANPRD01.PROD.OUTLOOK.COM
 ([fe80::d1f6:d9e4:7cc7:af76]) by YT3PR01MB6274.CANPRD01.PROD.OUTLOOK.COM
 ([fe80::d1f6:d9e4:7cc7:af76%5]) with mapi id 15.20.4867.012; Tue, 11 Jan 2022
 21:55:31 +0000
From:   Robert Hancock <robert.hancock@calian.com>
To:     netdev@vger.kernel.org
Cc:     andrew@lunn.ch, hkallweit1@gmail.com, linux@armlinux.org.uk,
        davem@davemloft.net, kuba@kernel.org,
        Robert Hancock <robert.hancock@calian.com>
Subject: [PATCH net-next v2 3/3] net: phy: at803x: Support downstream SFP cage
Date:   Tue, 11 Jan 2022 15:55:04 -0600
Message-Id: <20220111215504.2714643-4-robert.hancock@calian.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20220111215504.2714643-1-robert.hancock@calian.com>
References: <20220111215504.2714643-1-robert.hancock@calian.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: CH0PR04CA0021.namprd04.prod.outlook.com
 (2603:10b6:610:76::26) To YT3PR01MB6274.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:6a::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: f90ba91e-b918-4ca4-826e-08d9d54d1620
X-MS-TrafficTypeDiagnostic: YTOPR0101MB0860:EE_
X-Microsoft-Antispam-PRVS: <YTOPR0101MB0860326EA355EC047381193AEC519@YTOPR0101MB0860.CANPRD01.PROD.OUTLOOK.COM>
X-MS-Oob-TLC-OOBClassifiers: OLM:7219;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Lf7SpS+Xrl6smfMx/TVm4SO54oWYrzd5jUfNPtrDudwREoGK6MYdjUTtXll8jHvPZoTRYKEBledROY3dYM2CfjjOb9UtYQQHTDk7GfUQE0oHo32UZEZp6PYGBlwZrF8O4+D59TcAKbVGOfQa1YOEYBZxln1iABdc4QbzjfaTu4Soa6zJ+ooRi+gTFMVvsdQjvIQmCI3k7bRKksmtQ7emOae8vzDj+IQBTe4VathXvJQQGhkMEWxUtYVyUTab0rdKyDFl3te6l92rhQWmjUrzm1ZKhQChzVgxsA1UxrPoq+L9QnqD48tNoUXVOu/urROWPC6UoW5BaqPCY+daRmNxlUsJKwsuvoWQ38OEplToRiUNMQ0bB9JjUZDEuXXKzu06cUm0OJXxBwIykB4xGDZuWdlPTE9RZKzYJX5B3mfHfpz4K/jDopek1uCBp6vU4K+CZbnVTStizdeeNxSw+XWsLWFYlDb0bvp9ZRu36lbSl4FaxE8wwryaoqCcqRf+m16aMGGt6o54IOqgqg3TTTC9iiSEIaP938KNjtCoQgIIe/NmqnnEUMlWMYuplJdhJxxiQyHA95JvLkaK4DhL4Ta7WG3SlqhvvUMA3111jy3FzcM0Exbye5P3oshzA3xWnNfcfIw11v7ADiTrGsOFEz9ndk1fF3mL3B7SodNKkU36cGTP2mIfBo5pl57W2MwxLvBwAJ3x/CBuTCy9ur/rBJ2DSw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:YT3PR01MB6274.CANPRD01.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(4636009)(366004)(1076003)(52116002)(36756003)(186003)(6506007)(8936002)(38100700002)(6666004)(44832011)(38350700002)(6512007)(2616005)(316002)(66476007)(508600001)(83380400001)(107886003)(8676002)(86362001)(5660300002)(6916009)(66556008)(2906002)(66946007)(4326008)(26005)(6486002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?OjvvW1MbJFJlpYnd7v6GtLFp5zTqcnYbLA66i+xOQ6aAeJ29TXyabb3qcGW7?=
 =?us-ascii?Q?ztn2rB1KdLHug7vfi3TP9IuJaTmKeyxKmt5lzJ6jtcwPDXr54ErS2vGuVUrA?=
 =?us-ascii?Q?b7v14H6WKfE/p9ebCf6kAsE8AHMExGgFhL7UE/YloiRadZlft6Mnf7Uwsr6X?=
 =?us-ascii?Q?4ijjaAyfSyTZ3/c/1ThGmVcwVQQNxIQ63V4yGdG5wRkz/CTt/08sf6D7ItLV?=
 =?us-ascii?Q?+BLkROyXpEKVsVzBmQZWlol1ZporT0E+TOEQttRKYiNkMvxFM697SNOVeBWi?=
 =?us-ascii?Q?bAJu1wVK5QgPwTIgwbyD9rjvrtfCD/Vt4B3Zq/QO0ymrceQJDPJNUqc4cLWL?=
 =?us-ascii?Q?SgioTwkiYt05WRK6OvXE4Vv+rkUcr7jJDes7qgurpCZzstPKN7WvOx9wMiYf?=
 =?us-ascii?Q?Syh2TiEFgLP8NamFEykMe8N4mEM8LP7L0nBTksYtZr/95lPkeeZ3ro8UmWyh?=
 =?us-ascii?Q?h5I8pRCIrZY5jMjHNXmsKFFM6QkvyleWl7kIIssCOPofPPoWOnyYyukATUmn?=
 =?us-ascii?Q?rZWL0f47HcWmm9ZhuKYeKP5/opU/HEnD1FKhstbBXpPfGGUUA5ziMKAua0oG?=
 =?us-ascii?Q?FU8c2u1d/njz6MVhM7Lf1apmPpqbPt9hyr3PkGyWpK2hoL8J93/EwZkkPReP?=
 =?us-ascii?Q?OakInfPHpt54ZMobQecccyu7CUeIUjbUZQ5PmA1aF2MF5XpI37wECDBmqqWy?=
 =?us-ascii?Q?iaFRp7q977t9cnnJGc17tp+0aAykstW0U7oIH8igamVuLK3XYNAAovm2fUui?=
 =?us-ascii?Q?M9iSrpWxsS4vqTMgRYoIBD/X1OkiRwwl/lP0a56L2UGaeyOYaLWCQNUrE/1b?=
 =?us-ascii?Q?3NGMYEs782xlcw+VUvolN+8LHNLjkrf/44qufrRV/iL3R+yb+xpKtNMRYfMS?=
 =?us-ascii?Q?GowR7Wa3r+yixRkQzUx6VYuZ4JmrSq2kGGafL3zZZTL5bkO0f4IrA5Qb+dY2?=
 =?us-ascii?Q?XvEg9boC36OgvTQ6BnXPof9X9RDkRGTjPq5Myh5xJ6l8PI3BfdGYbG8ItT5t?=
 =?us-ascii?Q?24mGacfGyM0xdYe/vRpgkC7zAy+Z7QXVyHF6/DsGkr/ZzS+P24Z8NP+rh9j/?=
 =?us-ascii?Q?l5zP4b0dEz66nrIWK805LkVqrz1oZmDvv1IJxFKWG4l0qbpYyutKaJdd7gXR?=
 =?us-ascii?Q?hj4FepiYLa22cwq2bsUxLHL2+xtycrWLzNBzmc0dmHq3bkhFIqxaeBIQjT8H?=
 =?us-ascii?Q?b2u5gaNLJJAWrXLzu0XyZ4Gd8exhFVRWKJOQRzkE37iiXKWIcAxa7qoiDG9L?=
 =?us-ascii?Q?p9CrYDy+/xLwpgD9hgPcuNg/btZR2zDVocfrunyrvgbWl44/nb+JH6cNe2+f?=
 =?us-ascii?Q?Aq913lAuLd3ZQiFbhrrZczV8YXmq9bT7alF2g53zgP5hdJG3uWFQ0zZTLOtC?=
 =?us-ascii?Q?UPvskXA7bot8eJKrVY6MWNCIlrpisK9y0tWgoX973/00qwjaPdvU2nAZ/ojq?=
 =?us-ascii?Q?eoOeqCay1eYa4LQ9KEGOksNDs6TN7QXyetqbD6oOv3SemkTCY2Dl9DhleXQr?=
 =?us-ascii?Q?wc821c5wQ+KAWfSa2MQ4aThJebkpFkkRCzwhuSayWFInvuZqw6ufJpciGgTN?=
 =?us-ascii?Q?x6V9tpH5b0/uN/4UBKjuyaAJOvq3cJj9wNV99AbRkR4b8FbB1HDJEVrd49CC?=
 =?us-ascii?Q?HUOLUKpWwQKDTPbUHrvTeJLrw+EpoMtamcYygVfBPZus4cfWutBvGPm0quzl?=
 =?us-ascii?Q?eVsi6+7hO359mnE930E0uQ+bvjg=3D?=
X-OriginatorOrg: calian.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f90ba91e-b918-4ca4-826e-08d9d54d1620
X-MS-Exchange-CrossTenant-AuthSource: YT3PR01MB6274.CANPRD01.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Jan 2022 21:55:31.1325
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 23b57807-562f-49ad-92c4-3bb0f07a1fdf
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ucrubeCxWgK/4moWPyJsui3eZWl+AxBZGMkCyQmZBkIfqbboxjQhTDB57JdltA97eO4Zg2Z1uKj+nT4i1aaHsc49wGVkBsi8mw03nB54gaY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: YTOPR0101MB0860
X-Proofpoint-ORIG-GUID: D8gp-DxLWdK2GQPApJ8Lfde3fYn8uRGw
X-Proofpoint-GUID: D8gp-DxLWdK2GQPApJ8Lfde3fYn8uRGw
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2022-01-11_04,2022-01-11_01,2021-12-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0
 priorityscore=1501 suspectscore=0 adultscore=0 clxscore=1015 phishscore=0
 mlxlogscore=999 malwarescore=0 spamscore=0 mlxscore=0 bulkscore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2110150000 definitions=main-2201110114
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add support for downstream SFP cages for AR8031 and AR8033. This is
primarily intended for fiber modules or direct-attach cables, however
copper modules which work in 1000Base-X mode may also function. Such
modules are allowed with a warning.

Signed-off-by: Robert Hancock <robert.hancock@calian.com>
---
 drivers/net/phy/at803x.c | 56 ++++++++++++++++++++++++++++++++++++++++
 1 file changed, 56 insertions(+)

diff --git a/drivers/net/phy/at803x.c b/drivers/net/phy/at803x.c
index 63d84eb2eddb..c4e87c76edcb 100644
--- a/drivers/net/phy/at803x.c
+++ b/drivers/net/phy/at803x.c
@@ -19,6 +19,8 @@
 #include <linux/regulator/of_regulator.h>
 #include <linux/regulator/driver.h>
 #include <linux/regulator/consumer.h>
+#include <linux/phylink.h>
+#include <linux/sfp.h>
 #include <dt-bindings/net/qca-ar803x.h>
 
 #define AT803X_SPECIFIC_FUNCTION_CONTROL	0x10
@@ -664,6 +666,55 @@ static int at8031_register_regulators(struct phy_device *phydev)
 	return 0;
 }
 
+static int at803x_sfp_insert(void *upstream, const struct sfp_eeprom_id *id)
+{
+	struct phy_device *phydev = upstream;
+	__ETHTOOL_DECLARE_LINK_MODE_MASK(phy_support);
+	__ETHTOOL_DECLARE_LINK_MODE_MASK(sfp_support);
+	phy_interface_t iface;
+
+	linkmode_zero(phy_support);
+	phylink_set(phy_support, 1000baseX_Full);
+	phylink_set(phy_support, 1000baseT_Full);
+	phylink_set(phy_support, Autoneg);
+	phylink_set(phy_support, Pause);
+	phylink_set(phy_support, Asym_Pause);
+
+	linkmode_zero(sfp_support);
+	sfp_parse_support(phydev->sfp_bus, id, sfp_support);
+	/* Some modules support 10G modes as well as others we support.
+	 * Mask out non-supported modes so the correct interface is picked.
+	 */
+	linkmode_and(sfp_support, phy_support, sfp_support);
+
+	if (linkmode_empty(sfp_support)) {
+		dev_err(&phydev->mdio.dev, "incompatible SFP module inserted\n");
+		return -EINVAL;
+	}
+
+	iface = sfp_select_interface(phydev->sfp_bus, sfp_support);
+
+	/* Only 1000Base-X is supported by AR8031/8033 as the downstream SerDes
+	 * interface for use with SFP modules.
+	 * However, some copper modules detected as having a preferred SGMII
+	 * interface do default to and function in 1000Base-X mode, so just
+	 * print a warning and allow such modules, as they may have some chance
+	 * of working.
+	 */
+	if (iface == PHY_INTERFACE_MODE_SGMII)
+		dev_warn(&phydev->mdio.dev, "module may not function if 1000Base-X not supported\n");
+	else if (iface != PHY_INTERFACE_MODE_1000BASEX)
+		return -EINVAL;
+
+	return 0;
+}
+
+static const struct sfp_upstream_ops at803x_sfp_ops = {
+	.attach = phy_sfp_attach,
+	.detach = phy_sfp_detach,
+	.module_insert = at803x_sfp_insert,
+};
+
 static int at803x_parse_dt(struct phy_device *phydev)
 {
 	struct device_node *node = phydev->mdio.dev.of_node;
@@ -771,6 +822,11 @@ static int at803x_parse_dt(struct phy_device *phydev)
 			phydev_err(phydev, "failed to get VDDIO regulator\n");
 			return PTR_ERR(priv->vddio);
 		}
+
+		/* Only AR8031/8033 support 1000Base-X for SFP modules */
+		ret = phy_sfp_probe(phydev, &at803x_sfp_ops);
+		if (ret < 0)
+			return ret;
 	}
 
 	return 0;
-- 
2.31.1


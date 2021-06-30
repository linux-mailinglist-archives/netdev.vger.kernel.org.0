Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 64FF83B8863
	for <lists+netdev@lfdr.de>; Wed, 30 Jun 2021 20:25:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233256AbhF3S2L (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Jun 2021 14:28:11 -0400
Received: from mx0d-0054df01.pphosted.com ([67.231.150.19]:6695 "EHLO
        mx0d-0054df01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233223AbhF3S2K (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 30 Jun 2021 14:28:10 -0400
Received: from pps.filterd (m0209000.ppops.net [127.0.0.1])
        by mx0c-0054df01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 15UASann002486;
        Wed, 30 Jun 2021 14:02:14 -0400
Received: from can01-qb1-obe.outbound.protection.outlook.com (mail-qb1can01lp2056.outbound.protection.outlook.com [104.47.60.56])
        by mx0c-0054df01.pphosted.com with ESMTP id 39g3ve0s3k-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 30 Jun 2021 14:02:14 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=j8rZ58q8LnJS1TkbiWKi3lr29OBWRIWSZqI4FNmN0vzOpcWbVN5X4VZp24wCe2B67rRm4UyzG1k0WgcNnJU/SngD+FtInhrEtgOZuQgVM/yCni1O5ZZIKW9ik45lIOcQRLd9n6N3xvPVmO+LF5NBYECKhb/2NarhMcXaueawZBEUNhgDAQS+juMTV4qG5U+9O3XgRGTXApNr6j8VEVbijpzkxIfiXcFPh8yPV8uGCCbFTvfL6q8xAIJNNCtjTBLTdLUWRbvQmeXaEhE42srTIHQI1nr4tXPSbKyJyoI7rjRQANVAVxsqNyK+z6S/Y62lvZMx06cLOGYQ8dotw6zyFg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YnbXZKk3VHBztxlcQZZPIJ35CKH7EIxGsRlQMBbbWmk=;
 b=LCk2yAC9nG/CBrDd64UWnOKbajqwro8p4TPtZ1CkIGZSg4BfZftmcnQUV8Y0lw/6N/mRM/niwJRfkgdxDfi1LxH5vWL4u3342oJBxLgF8BlNvy89hMCIOzl7FBBH45aq59aVi+07gEEc37z0MsuwwebU4IPu5HCsVAzB/flBEQQKSzapA9oKkcvd2WWhgldjQCg1Fo1aRffxkiUjHbqc7jNBeoAYCirSxq/cNCUpFE+pgo8p8pXCyjnupsEQHeA+QaZhTobsjvj1stKaUeNLLqlHQ3dnCq3dFfWSD32Xi9J7PlDn5EaapI5SweaFBO3njjrn8ir/AZwglBqaEceHqQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=calian.com; dmarc=pass action=none header.from=calian.com;
 dkim=pass header.d=calian.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=calian.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YnbXZKk3VHBztxlcQZZPIJ35CKH7EIxGsRlQMBbbWmk=;
 b=m5XQ8DgVhjLoSaaR6MzJyuRrKxno8ce+JFsrkstWJPR+69w4y9RfRvUH0TadO0HtjAvLsafqqCu+ZWX5fnvOtk/MrlzLaUdIP6gOeSjpO0rG/nja9Y317mZze7tducFjCPtFI28ybU5XvC4dr1kJmn11y67yiz2KhKYcSScdetw=
Authentication-Results: lunn.ch; dkim=none (message not signed)
 header.d=none;lunn.ch; dmarc=none action=none header.from=calian.com;
Received: from YQXPR01MB5049.CANPRD01.PROD.OUTLOOK.COM (2603:10b6:c01:27::23)
 by YQBPR0101MB4569.CANPRD01.PROD.OUTLOOK.COM (2603:10b6:c01:14::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4264.19; Wed, 30 Jun
 2021 18:02:13 +0000
Received: from YQXPR01MB5049.CANPRD01.PROD.OUTLOOK.COM
 ([fe80::88bb:860e:2f3a:e007]) by YQXPR01MB5049.CANPRD01.PROD.OUTLOOK.COM
 ([fe80::88bb:860e:2f3a:e007%5]) with mapi id 15.20.4287.023; Wed, 30 Jun 2021
 18:02:13 +0000
From:   Robert Hancock <robert.hancock@calian.com>
To:     andrew@lunn.ch, hkallweit1@gmail.com
Cc:     linux@armlinux.org.uk, davem@davemloft.net, kuba@kernel.org,
        netdev@vger.kernel.org, Robert Hancock <robert.hancock@calian.com>
Subject: [PATCH net-next 2/2] net: phy: at803x: Support downstream SFP cage
Date:   Wed, 30 Jun 2021 12:01:46 -0600
Message-Id: <20210630180146.1121925-3-robert.hancock@calian.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210630180146.1121925-1-robert.hancock@calian.com>
References: <20210630180146.1121925-1-robert.hancock@calian.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [204.83.154.189]
X-ClientProxiedBy: MWHPR08CA0047.namprd08.prod.outlook.com
 (2603:10b6:300:c0::21) To YQXPR01MB5049.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:c01:27::23)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from eng-hw-cstream8.sedsystems.ca (204.83.154.189) by MWHPR08CA0047.namprd08.prod.outlook.com (2603:10b6:300:c0::21) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4287.22 via Frontend Transport; Wed, 30 Jun 2021 18:02:12 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 61c7500b-614f-4943-1988-08d93bf1307d
X-MS-TrafficTypeDiagnostic: YQBPR0101MB4569:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <YQBPR0101MB4569295714CF531D87AE6FD0EC019@YQBPR0101MB4569.CANPRD01.PROD.OUTLOOK.COM>
X-MS-Oob-TLC-OOBClassifiers: OLM:6790;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: fKj2UzXf3orgs4m6rypxuF8vajnexvcbYTZkSPBrD5ATA9pt+i9t4qOaqNuTneBIjZTDsi4cNYrNzkkuCiBMCCtxXZ+G196NJC3TtBfsasLhp8U8tuQjfjbccPgbaH9M1KZg0Gu8VF5+gbTW9usz1V8vonXVe+UB62pkWPZNhRVGUhtdrcW0AP5Q94AXTJCqykeflAfiWaKkb7o2WrvuUV9/T930xiFSZ/kiMt8gSHMvXAmGuQ7nlFdoQtW3rxVqFNaNdl23McuY8ptc7Zf1OMd3FjW7HtJ96RqCkq1yeRXkRl05zM3ffddmhKk7/i7EE5X6yEgC4kM96NaIH97rU5gWW5JRLe384uECuxccEng15rfy2UMauIsFnJcjXWjpbTNsjYesYEqN2L0k9P4BsYSen2Zptx5i3U2rcTB0RFjj2WZK+8E7xoevGMt6dpizXDZ5AxLdZ7OFS7zHtx43wrPfx+rxsVwoVprmU4GuQ/fl/VcnvfZIfcLFYRZRWRK+6YOxgfvIzncHx3ji8NN7n1v3JC4Ry1K3BzVfsf1j1fKJvSkhNwv9Ygd2NRshPKiSvWGbhntZtKcgrsJAI6V0IoBrQbwwMUrble7DnyX9jtGcMOv0QZAw52LctAKeKJelh4eM/BT3pj/KJwR5P/fmBfQZ3qv3rBowLFTO0RpXPyY2x91kKGZxjokYkJSUEf+DEm/nnXpLm516htrrgkMS4g==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:YQXPR01MB5049.CANPRD01.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(4636009)(366004)(136003)(346002)(39850400004)(376002)(396003)(5660300002)(16526019)(86362001)(186003)(956004)(2616005)(1076003)(478600001)(6486002)(38100700002)(66476007)(44832011)(6666004)(83380400001)(36756003)(66946007)(66556008)(8676002)(38350700002)(4326008)(2906002)(52116002)(107886003)(6512007)(8936002)(26005)(316002)(6506007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?cCB3l2kQ9bLmXvcuzhMXpX+Wi6qbq7gSrGRVGYg5G0eO/K54mh2VkJtCtaGv?=
 =?us-ascii?Q?Ws3sR/ZGB1+fjuM4CocOO/oZ8EVTEAQn4XbtXjf12PkkpzJFIhXfy4rYQdZj?=
 =?us-ascii?Q?Z0cdzdA0xMXQjYrmBPNmgIlI2gCGv0fLNIIfUJa/gc3nM+OC68JA6OwgTGZ5?=
 =?us-ascii?Q?OZ0sJf4oJWf7JlVdlqgTgBjHr4wEfCK62UVQeK6e0tsPl5T9WiQht9b2Isbw?=
 =?us-ascii?Q?HOD06hh+yhwFRehtykV6/dCYr9BKH9Mp56oVgBPhf54FpCh9s7oPzKt/ODDD?=
 =?us-ascii?Q?/dUqESW5vvYk/KV0EPHpxIFO2Vb/F2TVyH4GlvC1+E6AY8qEKIeJYkk+aVCd?=
 =?us-ascii?Q?qSlkTWiN+Uw3z5PYCJjNYTbGzKRENgrlvXLepSGFBfWgmaAJZoifa8x5iY28?=
 =?us-ascii?Q?y37DAoXYilPaeJTHhlPlgPjYy+DsjIpHSQmwlNEl006vVT5/GXfh3TgXIttm?=
 =?us-ascii?Q?hlCncToY+9hl0OWp0yvoAowtGL2zsa07WKx2XZqQj7fLM0WWZL/T0ia8Xwez?=
 =?us-ascii?Q?2A9fFJCHgC3hKOMX2EOCWCQo0Qz0Qv/QhquPNo4Xv8UCRYmNQGDkOjRYgDQX?=
 =?us-ascii?Q?2SS3HIj+kq0CGggZjgitZxCFq+qgQMrnq7+MQXjKILz9hBy8usbNp65vzSuC?=
 =?us-ascii?Q?/Oh4URpkWg9RYoA7Ff1mhQNwqWk5mk3keZICTEPTzZEqVAPykhyYZ5iZw5g2?=
 =?us-ascii?Q?Nl8uysDEg3ayYFRX2qQb4aYLtT79qfH0K5SnctKUyuku4g1Cew8ZlfX5qwhv?=
 =?us-ascii?Q?C1MBVXTgEh6ImBo5CtzroU42CGVO1wOpb0IgpAsNVqnrUvRD1xQlMVEq0tXO?=
 =?us-ascii?Q?Lgu5VW8HFOgoY0CM4eGhdOwaD2TbmyVlHBnV2SJE+bqgzMgeqI1YFi5EvIjb?=
 =?us-ascii?Q?EBc+yXDE+A0MbbUIn0sS5N4trllaunmj5MZRNYApJ42cmiTGL5FplMALwBFY?=
 =?us-ascii?Q?V7xS+pyUh+dNg1wfoHlp7mVBByXJRPTYHz+cxG0HIZpTJjS5ySw4nWj21Aeu?=
 =?us-ascii?Q?liiczo/qiyu40EMCCK6iwYRu8vLGoRolO9bG35jogkDGtqQDuDTWbM4Xs0Yu?=
 =?us-ascii?Q?+x9N96mJdS+s9M3Kb5Wg2O5iKM4DPRHZIUXky99jQXo+pt8rV9l0DgZv5d/q?=
 =?us-ascii?Q?PRehxV9C5ZV6TsRtgurmq+7ktSP9EpPGoLv4z30e9IcF/AekJZXEvt0ymTuz?=
 =?us-ascii?Q?azrbg8fLgYjoGREVYnF+YEAadIGrKZDgobKTGIjMZSNOAmYarbqrycpB0Yq4?=
 =?us-ascii?Q?4x1uf6WWY3aJ9xvNFdSnaKg6VO9l6111QtW3TfSt4/uy3GH+NwS7O9g6xHv/?=
 =?us-ascii?Q?M1pnGQFYQ5ThOb/8aiusL1da?=
X-OriginatorOrg: calian.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 61c7500b-614f-4943-1988-08d93bf1307d
X-MS-Exchange-CrossTenant-AuthSource: YQXPR01MB5049.CANPRD01.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Jun 2021 18:02:13.7880
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 23b57807-562f-49ad-92c4-3bb0f07a1fdf
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: nPRelmKuB0WDQoc6c7yeePAu/GJNOQj5c6tyNSHcc/JA1NwJgpJWB9qms/YVNY1I3hNqzB/B6bQGOIraMYbcfBQm4VQKVI6iIPFSWLsJGng=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: YQBPR0101MB4569
X-Proofpoint-ORIG-GUID: 70_K49KY1iSSgqudUQ978bYcsHPY3pcX
X-Proofpoint-GUID: 70_K49KY1iSSgqudUQ978bYcsHPY3pcX
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.182.1,Aquarius:18.0.790,Hydra:6.0.391,FMLib:17.0.607.475
 definitions=2021-06-30_08,2021-06-30_01,2020-04-07_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0
 suspectscore=0 spamscore=0 adultscore=0 lowpriorityscore=0 malwarescore=0
 mlxscore=0 phishscore=0 bulkscore=0 priorityscore=1501 clxscore=1015
 mlxlogscore=999 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104190000 definitions=main-2106300099
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add support for downstream SFP cages for AR8031 and AR8033. This is
primarily intended for fiber modules or direct-attach cables, however
copper modules which work in 1000Base-X mode may also function. Such
modules are allowed with a warning.

Signed-off-by: Robert Hancock <robert.hancock@calian.com>
---
 drivers/net/phy/at803x.c | 53 ++++++++++++++++++++++++++++++++++++++++
 1 file changed, 53 insertions(+)

diff --git a/drivers/net/phy/at803x.c b/drivers/net/phy/at803x.c
index 65f546eca5f4..b613e26b6b16 100644
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
@@ -552,6 +554,51 @@ static bool at803x_match_phy_id(struct phy_device *phydev, u32 phy_id)
 		== (phy_id & phydev->drv->phy_id_mask);
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
+	iface = sfp_select_interface(phydev->sfp_bus, sfp_support);
+
+	/* Only 1000Base-X is supported by AR8031/8033 as the downstream SerDes
+	 * interface for use with SFP modules.
+	 * However, some copper modules detected as having a preferred SGMII
+	 * interface do default to and function in 1000Base-X mode, so just
+	 * print a warning and allow such modules, as they may have some chance
+	 * of working.
+	 */
+	if (iface == PHY_INTERFACE_MODE_SGMII) {
+		dev_warn(&phydev->mdio.dev, "module may not function if 1000Base-X not supported\n");
+	} else if (iface != PHY_INTERFACE_MODE_1000BASEX) {
+		dev_err(&phydev->mdio.dev, "incompatible SFP module inserted\n");
+		return -EINVAL;
+	}
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
@@ -716,6 +763,12 @@ static int at803x_probe(struct phy_device *phydev)
 		phy_unlock_mdio_bus(phydev);
 		if (ret)
 			goto err;
+
+		if (priv->is_1000basex) {
+			ret = phy_sfp_probe(phydev, &at803x_sfp_ops);
+			if (ret < 0)
+				goto err;
+		}
 	}
 
 	return 0;
-- 
2.27.0


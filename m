Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AB50658A17C
	for <lists+netdev@lfdr.de>; Thu,  4 Aug 2022 21:48:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239515AbiHDTrk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 4 Aug 2022 15:47:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49246 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238778AbiHDTrg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 4 Aug 2022 15:47:36 -0400
Received: from EUR01-HE1-obe.outbound.protection.outlook.com (mail-eopbgr130085.outbound.protection.outlook.com [40.107.13.85])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 77D9267CA0;
        Thu,  4 Aug 2022 12:47:35 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dqGCGIJHp+Y2iQck7fystPa3gBGW+wtW6sJyE7meP3/yfVcHvPCKsUr1lE00J6jDvMiXGRT6WmSx/26X8OXPVLFO692OkCrcLiEQNI4fnVHaoeRmeYG2haf8avd9To75i8++/81NKsc8oU2eMLTVR/1YUxKbm0ZBpb7trTgacwWSdnKYYAwd/8F/hIVIuooBS04ie3b3NjFsvfGYEy4gNbHJ6R7BVn1sXlsVJOxGEa5wtplSW9tBMWLwpaZLqR+ZKwjQ3AoCU+2d5RL7iazGhKPVyVIl2j0+pyoqHcthY1cDAz/TNpQHQUQu3rW9xjCKq8jrOY19XS+3E9M8YH6osA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=R+q9wxmuYFEtYhelB1kFPXp0tCVpIWTJa8bakEDEdas=;
 b=T7bbBV4DcEP0oP+BvNwCMnZEjN7cqHKsJqqOzb5ein/Yq52COzhPQAOkogQeUaAoTCa/B8RywQlN1y8LdB7ugG3Xe+1ha5/VGHDA3sH3xPeVs/HLmJ5RSzu05JmIcc7thpKZH1uruwjiy4QxTp2vhFnU3xMNrbmr5xhYn8whD7VV3gxIUyLxb4niDr4WtyJWpQKTD1kegUDt+IkXQ9QTWDMN6Ne9HKTimrfcxJNViVxg0StsB1qVwewscn1+Y7/DCfrzi6tx11anAfJOCTYSN87b5K45j1US3TYoDqnxOE5b78Z3dYX1BAhfW2BgwWLzDGi5bg5XFwx7pIg6JIN7mA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=seco.com; dmarc=pass action=none header.from=seco.com;
 dkim=pass header.d=seco.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=seco.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=R+q9wxmuYFEtYhelB1kFPXp0tCVpIWTJa8bakEDEdas=;
 b=jjBAGIyUVfS+/NS99JyeJxd6HVcCVrsVm2rkrViaXGUMbU38Mwe7+4/A9h8n1v3k+vF+xhnt/swQmgclKfdF1BgHzv1Y5UlnVWqRhNd1qbV9k25A9uuGuLDBS8zMWvvA9FFyrcSWGob0f+igDb59th9+7/BXYnfYI4T4rHi9v1FjqVLCc6Kj2dxuZagoOIv64zmcKZotAy6BFBhgBm7Tf91SMG6wJzi/XfKja3r7JYidSInlrOKcfpNJZuLHVKL2H8U27lqjQvRsJzZgaMhIhaVh8BVhY7ZAfZbJZpNJETrQF1B0Y84SL6QExCzafH/CnZRpxiRGlrgJXOM4SN79qg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=seco.com;
Received: from DB7PR03MB4972.eurprd03.prod.outlook.com (2603:10a6:10:7d::22)
 by HE1PR0301MB2297.eurprd03.prod.outlook.com (2603:10a6:3:25::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5504.14; Thu, 4 Aug
 2022 19:47:29 +0000
Received: from DB7PR03MB4972.eurprd03.prod.outlook.com
 ([fe80::ecaa:a5a9:f0d5:27a2]) by DB7PR03MB4972.eurprd03.prod.outlook.com
 ([fe80::ecaa:a5a9:f0d5:27a2%4]) with mapi id 15.20.5504.014; Thu, 4 Aug 2022
 19:47:29 +0000
From:   Sean Anderson <sean.anderson@seco.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Madalin Bucur <madalin.bucur@nxp.com>,
        Camelia Alexandra Groza <camelia.groza@nxp.com>,
        netdev@vger.kernel.org
Cc:     "linuxppc-dev @ lists . ozlabs . org" <linuxppc-dev@lists.ozlabs.org>,
        linux-kernel@vger.kernel.org, Paolo Abeni <pabeni@redhat.com>,
        linux-arm-kernel@lists.infradead.org,
        Eric Dumazet <edumazet@google.com>,
        Russell King <linux@armlinux.org.uk>,
        Sean Anderson <sean.anderson@seco.com>
Subject: [PATCH net-next v4 3/8] net: fman: memac: Add serdes support
Date:   Thu,  4 Aug 2022 15:47:00 -0400
Message-Id: <20220804194705.459670-4-sean.anderson@seco.com>
X-Mailer: git-send-email 2.35.1.1320.gc452695387.dirty
In-Reply-To: <20220804194705.459670-1-sean.anderson@seco.com>
References: <20220804194705.459670-1-sean.anderson@seco.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BL1P223CA0012.NAMP223.PROD.OUTLOOK.COM
 (2603:10b6:208:2c4::17) To DB7PR03MB4972.eurprd03.prod.outlook.com
 (2603:10a6:10:7d::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 759cdf4d-dff1-4424-14e3-08da76522a37
X-MS-TrafficTypeDiagnostic: HE1PR0301MB2297:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: mdMRPIhLE7mqggphjKn9snFchn3y6Efj7HqmTFv/mZZOIFDtlvjfNoOYY37ICzCBIBZMso8rVEGG1Q41CGQDGF46tofMrkg4k41HsOzvVaaOrtHrMuYNuI4oPxWJovB7790aZ67WvXTsS4ytEStqbSR/x+7chn9PAiH+dx51sktJx9lH5joDsQuu/3olFmWbL42PpgYo85su16c6hTx5SR1Nw932sHAnqJZJM3x0bQsJOUM8+U3OjU18IAGXPjq/5aJ2MWiXruSp1ZxWCSVBk1Yh53AJstv/VJopd398WPwuJDckue/CubU/gGHNmtcwWgVXfLbmRKoSeAr8vYWwXPz6ruTZ1wKYDxDpOn4851cQhlZs5dqcW4PCvzmyirdEMLeHKPtFASSLgeRRkMpJ45/yVJN7iaQBMZTvG9oYVD/sYaOZ8T9QGgBUGlgBs/gEf93hfm6Bhst7eI6t+eDrYcczSldj0umyZBbn4T5UGzL7AjcNIVfyBzwHJl2lGQdF8XpEbA8sDaX3IY2wZ740E+GdLKZb1zKHAJm+XUyVeyQFKthQoXHFKIxkSJOWynwQwrwY5uZI3L0UKGQF+01ezNKQJlQhFoR8TMWDOjk/DrUyEBWFgC/L/iMiiTy0jWzgdc4ttRqsMngoABTzkLTsvXkmyjbeNVdvOUk9A1tCklcq12stJZeE5rgzOCAxLPVP0ByVeraAeGRMaUawtiMSJTupSzbF6bOj2AXY55X7d+37IhoRTJ60vq4+kE85ygLuyQ/Z8Tjiu7QNVWSjM2RhnJumul2z0B1ew7gdh4UY9Y0KV/x+a9hBBKs285hfKdoQ
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB7PR03MB4972.eurprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(39850400004)(366004)(346002)(376002)(136003)(396003)(6486002)(478600001)(186003)(1076003)(26005)(107886003)(7416002)(6506007)(6666004)(2906002)(6512007)(8936002)(83380400001)(44832011)(41300700001)(38350700002)(110136005)(38100700002)(86362001)(316002)(5660300002)(54906003)(8676002)(36756003)(66946007)(66556008)(4326008)(2616005)(66476007)(52116002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?rkOd34TvRi823iH+wR7UvL7PuBlZDsEAnYzjxXIh88RZs3t2HRkzkle4NufW?=
 =?us-ascii?Q?zJshuxQKg1dnd9Gxp6tQ++wpGj5gTaG3OzuZ8VgBFEIrohkLVUXkSL5kAK/1?=
 =?us-ascii?Q?uTmD9479qp8FqMZPL5uO35tg+jfHJytRLJEEddOIV+j8METPTyHoLK1QOQca?=
 =?us-ascii?Q?KqaxKPVguCt0s/rdWpE82Is/FEVobRNdSVnD3GvW8NZCfR0Mio4Y47MC81Tn?=
 =?us-ascii?Q?oyYwPHUtGfPilbJ3CCKqkWF45ZePRsrlnx4rHnpu8iVBFD0J5J0AwxoWOZYy?=
 =?us-ascii?Q?+a/1GLljSY9GDetrlZniOx5smeC8wFgAQmkQ568H+LGb23bgRb2M71O3m8vR?=
 =?us-ascii?Q?VqlZnYJ6L94OeOsGp//j+uUHOtMB58B+DG7EXVOZybd4RoVkhJqisgTmp8nd?=
 =?us-ascii?Q?z6KTQ+M9M+gXzG14E+Tg180tLhnG3RwLh+sBxlLmamkHS6t/9YA7RsyvEtLe?=
 =?us-ascii?Q?zemWQM4ORnUErASF+HNY5y5K8ULKDooUOKm/9CE1Ntd6tKCCVCI18UNrFSB1?=
 =?us-ascii?Q?jiiyn91LroQNqodH1a5SAamclNa9NY6JH359XfkfuBGE9TPZ6orAp83y0Jba?=
 =?us-ascii?Q?1F9V665kSBWqyL1fWl2Y+Mxt5wVha7HaeCotZKww3rosb9Xx48i7mGmKvbIJ?=
 =?us-ascii?Q?4p3KeLJ3k9rBZFHC4e7iUR1Bz79SnRVJ8xH1C7xrHviQW+i3actQTHw49OPI?=
 =?us-ascii?Q?pMLsJleIJGQfuZR++tsROIIcymqCEqw8Nrhs6sP9ks0PsT2BqruDhPrGM9LS?=
 =?us-ascii?Q?rMj65tlOYLEcSe/dhF/Zms0qNgAmKBIJ6nrscIefK5oN9eIeditlkiydNI7H?=
 =?us-ascii?Q?vmaTMdZPPw+dAsLUDAOr050hXiqYFg5Tseu7Au4nCHSI0shRNyjZx1JV0ese?=
 =?us-ascii?Q?PudzqbK0WOFpVVJc1bLXPofCL6bFC1vb+WfbfRg7p5E4IWzMyYjQuIkxZ9yT?=
 =?us-ascii?Q?ULylN3E00MKP+5LuLPNPmFDminHyh/8NMQWO6RAzdCU2WUdNFHiJbW/q3HUO?=
 =?us-ascii?Q?VgDS8Tbj01sSdwSi2mkR8T2p4G1++yj1aEU4eQYoqZmLJzQWm9QP4/N4tMvH?=
 =?us-ascii?Q?vf4gwrpX+H7MiiKqoPOeKeR61+Wc6tqPjSgUdILOcejD+lsWDzj01FvtSdiX?=
 =?us-ascii?Q?ZZATCDZKq97wfMYt55DFtZbsFXPM71zrUDK1mhVcrpGa1bk2ZnDKMdw0Rhh2?=
 =?us-ascii?Q?NFKiVsuhN5qQlhds7oKSmODHZFrO184Zw/ZLvvKRzH0xC9oP770z3JkqOnf2?=
 =?us-ascii?Q?3AwcbvO2GzwyolusBd4XClB/ttpL301c9AGiGmqy6YvfWMYOvhHxGdcMSqv+?=
 =?us-ascii?Q?ULhgiO7QZnjDqPnwrRzLQ2Hd0V+3CKrGqOz51R0OeiQiyTfgDhPomR9s0YWF?=
 =?us-ascii?Q?OkzmRi08sOLuLLgfxVriYg5a5ZQ+dJKiKiHf70tapbgvioUPbW3biRYH+TZW?=
 =?us-ascii?Q?ubNIX90eWto3maX02AYc8HeG9M/t71+yJVeojOYG5DSgPqwdRTPYfZDgNRs+?=
 =?us-ascii?Q?dYu3blcizEVa4zUWjygSSGa2U2wAi0McPRv3JP0tYNyM7MytTRjFJH0tHdFR?=
 =?us-ascii?Q?2sjpiPX2hfMVGDCyHt1LQh/OmgfuxlzB7Ej5RvCVNyMvqvzUp/+JvVtUR2pb?=
 =?us-ascii?Q?ZQ=3D=3D?=
X-OriginatorOrg: seco.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 759cdf4d-dff1-4424-14e3-08da76522a37
X-MS-Exchange-CrossTenant-AuthSource: DB7PR03MB4972.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Aug 2022 19:47:29.6026
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: bebe97c3-6438-442e-ade3-ff17aa50e733
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 1DQFt8ZdbMcKsANxK6coOkNXEMHgzLWoaY9iAD+Awbcf9Tcr1lG/v2TsyAvmCQj3HCXu2M6NhRbcitz4U0hgDQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: HE1PR0301MB2297
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This adds support for using a serdes which has to be configured. This is
primarly in preparation for the next commit, which will then change the
serdes mode dynamically.

Signed-off-by: Sean Anderson <sean.anderson@seco.com>
---

Changes in v4:
- Don't fail if phy support was not compiled in

 .../net/ethernet/freescale/fman/fman_memac.c  | 49 ++++++++++++++++++-
 1 file changed, 47 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/freescale/fman/fman_memac.c b/drivers/net/ethernet/freescale/fman/fman_memac.c
index 02b3a0a2d5d1..2886f86e45ba 100644
--- a/drivers/net/ethernet/freescale/fman/fman_memac.c
+++ b/drivers/net/ethernet/freescale/fman/fman_memac.c
@@ -13,6 +13,7 @@
 #include <linux/io.h>
 #include <linux/phy.h>
 #include <linux/phy_fixed.h>
+#include <linux/phy/phy.h>
 #include <linux/of_mdio.h>
 
 /* PCS registers */
@@ -324,6 +325,7 @@ struct fman_mac {
 	void *fm;
 	struct fman_rev_info fm_rev_info;
 	bool basex_if;
+	struct phy *serdes;
 	struct phy_device *pcsphy;
 	bool allmulti_enabled;
 };
@@ -1203,17 +1205,56 @@ int memac_initialization(struct mac_device *mac_dev,
 		}
 	}
 
+	memac->serdes = devm_of_phy_get(mac_dev->dev, mac_node, "serdes");
+	err = PTR_ERR(memac->serdes);
+	if (err == -ENODEV || err == -ENOSYS) {
+		dev_dbg(mac_dev->dev, "could not get (optional) serdes\n");
+		memac->serdes = NULL;
+	} else if (IS_ERR(memac->serdes)) {
+		dev_err_probe(mac_dev->dev, err, "could not get serdes\n");
+		goto _return_fm_mac_free;
+	} else {
+		err = phy_init(memac->serdes);
+		if (err) {
+			dev_err_probe(mac_dev->dev, err,
+				      "could not initialize serdes\n");
+			goto _return_fm_mac_free;
+		}
+
+		err = phy_power_on(memac->serdes);
+		if (err) {
+			dev_err_probe(mac_dev->dev, err,
+				      "could not power on serdes\n");
+			goto _return_phy_exit;
+		}
+
+		if (memac->phy_if == PHY_INTERFACE_MODE_SGMII ||
+		    memac->phy_if == PHY_INTERFACE_MODE_1000BASEX ||
+		    memac->phy_if == PHY_INTERFACE_MODE_2500BASEX ||
+		    memac->phy_if == PHY_INTERFACE_MODE_QSGMII ||
+		    memac->phy_if == PHY_INTERFACE_MODE_XGMII) {
+			err = phy_set_mode_ext(memac->serdes, PHY_MODE_ETHERNET,
+					       memac->phy_if);
+			if (err) {
+				dev_err_probe(mac_dev->dev, err,
+					      "could not set serdes mode to %s\n",
+					      phy_modes(memac->phy_if));
+				goto _return_phy_power_off;
+			}
+		}
+	}
+
 	if (!mac_dev->phy_node && of_phy_is_fixed_link(mac_node)) {
 		struct phy_device *phy;
 
 		err = of_phy_register_fixed_link(mac_node);
 		if (err)
-			goto _return_fm_mac_free;
+			goto _return_phy_power_off;
 
 		fixed_link = kzalloc(sizeof(*fixed_link), GFP_KERNEL);
 		if (!fixed_link) {
 			err = -ENOMEM;
-			goto _return_fm_mac_free;
+			goto _return_phy_power_off;
 		}
 
 		mac_dev->phy_node = of_node_get(mac_node);
@@ -1242,6 +1283,10 @@ int memac_initialization(struct mac_device *mac_dev,
 
 	goto _return;
 
+_return_phy_power_off:
+	phy_power_off(memac->serdes);
+_return_phy_exit:
+	phy_exit(memac->serdes);
 _return_fixed_link_free:
 	kfree(fixed_link);
 _return_fm_mac_free:
-- 
2.35.1.1320.gc452695387.dirty


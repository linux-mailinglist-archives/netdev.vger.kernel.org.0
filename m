Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CA1EC5EB0D8
	for <lists+netdev@lfdr.de>; Mon, 26 Sep 2022 21:04:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230292AbiIZTEH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Sep 2022 15:04:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50280 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229529AbiIZTDo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 26 Sep 2022 15:03:44 -0400
Received: from EUR05-VI1-obe.outbound.protection.outlook.com (mail-vi1eur05on2042.outbound.protection.outlook.com [40.107.21.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 274DA87FA2;
        Mon, 26 Sep 2022 12:03:42 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DTFclAIfcAGS4oXc8JkqNPaN16a8wPDmbvOwomZf/borFRDAHfASWUw1AGKvAuH430d+duQ6WPcKEi3M7oGgDKg4aIklqEuTJRUdZPNs2dORvOEasYiIGF+ZAtwVmiQ6MD4ShPjyXEwa9mtFeVOpxd5SeQN1h4Li+u56b+a5r7zJrKZKfIkXoOgVtyxsLoAbpHFQcqyGiARcOA8zz934W8xhQZ002GbOHOcICX6bLHwsvy5IgG5oo15ljMop4KvrxxLmqk14rvZkfPIVDmWSPhOHZfnzZVqeONHYBHngcG4xef1z6oi3XhL93kY5bmYrzs4pB81tEv/oJnTNfdunhg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ppbX7gkdSbkxfHgc6D5Y+h9NkpsO2d0pVIeXPyTOAWM=;
 b=huW562sw643xzIvmfMfupbWVrbzkZfjImz/I8DLYDhPqZwbN6A9moVVAOtK4K3aaykK/KuYh3U+yweIfqgofbApdHQd/pKdU0RyWSkoA4skikwOPeUguUOlsbh7G26feKUh9/qvcKeHuDQBY7ndLwYE37zT5xXURM5AXd9dau1p2/a3oMxB33HjxZKBe6qP72kY7qx1i92oIRxIUTMDPMoAtcTOhAxhiVuknO1Akl2Ks78eJWiLRIhIjx5gUAcnRkp/ECltxz09n01QA53tCpk1ZJqKELWeEoW1G7SIJlUUWw/yW+11RT9LW4zaXJNgaF4J8+4l/daDVVVfKuUIC4g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=seco.com; dmarc=pass action=none header.from=seco.com;
 dkim=pass header.d=seco.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=seco.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ppbX7gkdSbkxfHgc6D5Y+h9NkpsO2d0pVIeXPyTOAWM=;
 b=CRYkjogV2m+6sN+kCFG4ElbO0e9cAGJZ0B5D4DsqapONqY/m/c3B6zCrMWajHcIPurmPJeESHx2MNEDqRDkoOLjAhE1rFCdh4HHJLphGKjcFZbNbdzyRlvAr7aiGRoMUg7brHkC0jQYnWTRTaokdkaSOfDG0c7uHB7IELinSR/IqGzThM35eDbmo3kaeec4MiLxUV3gkR9wtaS0Zhbb7cCGu2xtZSSrSIpdvrx/aTQKVHYVljgWNsC5G6wFFWlVQ5KQSwUs8pMujMW5iLtAdqbeT2KQVF0AVx2VuNxIsyyEwKn4mwlR7Ny3b5wvSDdb4D5VDIa7OCW2tiUmKn3ozmQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=seco.com;
Received: from DB7PR03MB4972.eurprd03.prod.outlook.com (2603:10a6:10:7d::22)
 by PAWPR03MB9246.eurprd03.prod.outlook.com (2603:10a6:102:342::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5654.25; Mon, 26 Sep
 2022 19:03:39 +0000
Received: from DB7PR03MB4972.eurprd03.prod.outlook.com
 ([fe80::204a:de22:b651:f86d]) by DB7PR03MB4972.eurprd03.prod.outlook.com
 ([fe80::204a:de22:b651:f86d%6]) with mapi id 15.20.5654.014; Mon, 26 Sep 2022
 19:03:38 +0000
From:   Sean Anderson <sean.anderson@seco.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Madalin Bucur <madalin.bucur@nxp.com>,
        Camelia Alexandra Groza <camelia.groza@nxp.com>,
        netdev@vger.kernel.org
Cc:     Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Russell King <linux@armlinux.org.uk>,
        "linuxppc-dev @ lists . ozlabs . org" <linuxppc-dev@lists.ozlabs.org>,
        Sean Anderson <sean.anderson@seco.com>
Subject: [PATCH net-next v5 4/9] net: fman: memac: Add serdes support
Date:   Mon, 26 Sep 2022 15:03:16 -0400
Message-Id: <20220926190322.2889342-5-sean.anderson@seco.com>
X-Mailer: git-send-email 2.35.1.1320.gc452695387.dirty
In-Reply-To: <20220926190322.2889342-1-sean.anderson@seco.com>
References: <20220926190322.2889342-1-sean.anderson@seco.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BL0PR1501CA0019.namprd15.prod.outlook.com
 (2603:10b6:207:17::32) To DB7PR03MB4972.eurprd03.prod.outlook.com
 (2603:10a6:10:7d::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DB7PR03MB4972:EE_|PAWPR03MB9246:EE_
X-MS-Office365-Filtering-Correlation-Id: 004b2d87-e84b-4da8-d933-08da9ff1d221
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: SNxY4x1+LZX31A61n7PUqHpezpmveyodvRNhW6kRdPjcaa1/qnPT/NwwyMd6uf9UemXfOEKUXbKihO6iVzNP6WZK98JlHo9h3tGMSupABAxWHReJ8JWOH8kUfS1qHxn8AuuVW2nnKc3qq1wFAPGUIT/TogJEuO7yIonH6B30EbuDDMtIqgy9J1eMyyoixJcnF3YSctebmvgCTowc5f0N4ytadX7NPGwcYsvwLCW/FgHIwTu3TDE8Fvp4tvZEzmGROe/X7D1fgCklEL+dCsYJXlItsv1/2u69SVsDQuk2AVwxz7ijnCw4QhllciO4CN21UYC8rdLR+FWzMiiQicnxix3QZ6s76a3fV1EJobOzqO9SaWamGXyMaHGbvYe/FwaQzm2eGCkbY1tvnn54Yl8DFbPCP8VgdWTwjNMTsjYrXnlD1y4iI89ZdEpSOKpTfooE8Ztxo4B5GN+qXli4oOEO3CEkkgILyV/0HlIQ7LrTpUyVl0nHu2JKHSYgDs74zb808HciGIS0tWOK4/zLCBvoOGHBLo/lbRzkwJ/17s4H4o6QuJNixBXgkuzRYEMkkOfFvKjyHhN8zN9cE3FgVXcq6azK1F8jjgebrWvO+wPjask0VT3X7f4Jed9+fX6cKiK/PiaQnSz/P0wBRAxAlS+1GB4f5rl2hQ0EvE34RtiF+O+6LPueKcl5lTVR0Tk7RfHUG4wsiK4DwT3VxPcq5hkb23Mb5ZL5LVicljqa9aAl05hIjZpZmyPg9DetzmPzInikF/dX5Va4f4T60n0GEL/4gg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB7PR03MB4972.eurprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(366004)(396003)(136003)(376002)(39850400004)(346002)(451199015)(36756003)(86362001)(66946007)(66476007)(66556008)(6486002)(110136005)(54906003)(4326008)(316002)(478600001)(38350700002)(38100700002)(41300700001)(107886003)(6666004)(8676002)(5660300002)(7416002)(44832011)(6512007)(26005)(2616005)(2906002)(1076003)(186003)(83380400001)(8936002)(6506007)(52116002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Um0qXIKrszPfmbJeQUOxyEL8fc9bl1WULt3R9d6Gp7H+XW+i/KyXYmZbQVC2?=
 =?us-ascii?Q?u3h8mkrCqIRcIRoOsKFqDM9MTufQq1dVt8nyUIV03SzJYrx9AuB4ruBo/nal?=
 =?us-ascii?Q?mvFj30tecfuv1720XV3t1Yynw5B7TnUu0YA/H/rgGsEy4Pa+kq+1omGOHI1r?=
 =?us-ascii?Q?XCHCfeo034nfxyW4q4mcqAU06qSTXLbZW4CRjZ1FUw0D4MPHG1DzvzKP4J2A?=
 =?us-ascii?Q?pFz3m3+fxXO32qvC6RqlSUoLUFFiKanTyx04se/5QepzvW3eUMBIkQgBFHEU?=
 =?us-ascii?Q?F/0vHyQnRz/2ZCN7X1bH7lU9F3X7T6pkmKWk5vRTiooCPjyK35iJFepR4KJ/?=
 =?us-ascii?Q?/3JnKlOa18ihsfVqPRT/hR9fXPCDuuXwwQ1L78tUsDqFqEaRWkaO/IzmW+SD?=
 =?us-ascii?Q?jQrZ9c5OTeVD+t4mBawZ2S6CjnYR/uR7RIeR3pwVEizWsXs4smXyksZLoQoK?=
 =?us-ascii?Q?8QAtY5wyFFNVXe/82gg09ln9R6ziWedBTNdDIdxg1+6DmB55uU0jSgATePXF?=
 =?us-ascii?Q?Avpr7l5ila7jPGifhj8S4Pfd0+bfAgRWhAlVynU3jxg6Fe5k4NEBI5NdFoTb?=
 =?us-ascii?Q?+ALPVnYjwC2UdfLu1eJfosDxloHviepfL1bl7rwgQmpvsvymUzaR+qv5AU3+?=
 =?us-ascii?Q?r6leLTY3Au/FU+Mbezor72qHKIsaHnDprt2kgxFnV4QCZwJWz1zpu18tjKL0?=
 =?us-ascii?Q?ffpwkVlKkwtytpCJSuAE6116HN+Lek7cSY1wAnFvH19MxTvkHvrJXV7ptm9d?=
 =?us-ascii?Q?POKFzUl+FvhL//XCqNdj7ZFv96nGXTSYf//npRrmf5Cz6Y39LmXCzkbMNGkn?=
 =?us-ascii?Q?VNY06DHq3HmyuAFM4JviuX/5HBpU9DpjfrY2vs/RN5ak6ZH8g5wACmedCvjq?=
 =?us-ascii?Q?fiD6edvDim2qSGbjmhhSLT+JPGMcl4RMTAFlyLcgD2xmZkLBtiw9ftnSHKUz?=
 =?us-ascii?Q?H/TTijxLkRc8DJyq5N01B/nQ40ImDU2DEd8dwSs4mjUGoeSc9udnH8dvE/KE?=
 =?us-ascii?Q?/lVdK9o9zDOCgVe7iKqOepiYpOB7ukWDbHTEFjwlkyUX1zgrrciWW69X39d5?=
 =?us-ascii?Q?vdsKUqm2a6DJFdEqPR0frcV6e4n6yYS/ZMcipOB8mW9Bk6Ssv1WjVlViC/8G?=
 =?us-ascii?Q?9G23mZ6MEHsoSyE+k2HUGi3RYraWR9EUwgj0ge9C6XmLfjTLSzO43/K8Ud3C?=
 =?us-ascii?Q?obaN4WySHSkIkhYfko3EQN6u9Z/UBLRejQ81u8zy+NsG71nIUTbg9k+cVBg+?=
 =?us-ascii?Q?QGlzqm32ngJWTtu6kUnwbwTSqFI6VEZefmAPZvSNa15IJu7pVYo78inPqbp4?=
 =?us-ascii?Q?gSTRz85dt5t1aWu8+keDgNZkuGMFO3HtTJ7qha29GljH8WK7IafAqRTdf4yV?=
 =?us-ascii?Q?m/BBUOQYNYWM2RJsNunhBdVWN4xDgO1Z53ZIyMTYmXp8TEf8zPxkJ5HtQD8u?=
 =?us-ascii?Q?D/vH0QLCdcJjccypPXv2M32r/A+mqB9b56hCrCZCnQdlUbwfPwjX8Dvyocge?=
 =?us-ascii?Q?OdU23tabnuw1Xl4d0tIu6lax6sJh6HkFrS+gteZTeo7wMFpxpjO9dmWi9TTq?=
 =?us-ascii?Q?fMN/MUkK0d1zW4xq1QMf+sEmhKGQALYvzsU3VWkBKAltS3AQlXXkh4PARfCD?=
 =?us-ascii?Q?Tg=3D=3D?=
X-OriginatorOrg: seco.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 004b2d87-e84b-4da8-d933-08da9ff1d221
X-MS-Exchange-CrossTenant-AuthSource: DB7PR03MB4972.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Sep 2022 19:03:38.8652
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: bebe97c3-6438-442e-ade3-ff17aa50e733
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: UrdgqBgQbyG4csQBqxKWVnRIp96OFwKsoiZYZHFtDUYP502IylmaUvkaV/KRoo7lgghjTWmxR5BGRxWplivhLg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PAWPR03MB9246
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

(no changes since v4)

Changes in v4:
- Don't fail if phy support was not compiled in

 .../net/ethernet/freescale/fman/fman_memac.c  | 49 ++++++++++++++++++-
 1 file changed, 47 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/freescale/fman/fman_memac.c b/drivers/net/ethernet/freescale/fman/fman_memac.c
index 32d26cf17843..56a29f505590 100644
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


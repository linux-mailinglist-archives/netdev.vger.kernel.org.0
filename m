Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8B578576970
	for <lists+netdev@lfdr.de>; Sat, 16 Jul 2022 00:04:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231175AbiGOWED (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Jul 2022 18:04:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59796 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232112AbiGOWCx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 15 Jul 2022 18:02:53 -0400
Received: from EUR04-HE1-obe.outbound.protection.outlook.com (mail-eopbgr70058.outbound.protection.outlook.com [40.107.7.58])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AD3308C156;
        Fri, 15 Jul 2022 15:01:15 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=cpEU5ditqW16vw0os0evoDqpMWHpEbz0oMcnDdci1BZuI0FwELtMWUStpCRApuVIIhxiTibwx5YNoyH3XF8oXLC24RDk2KgKipZhKbqkGVww76AwcRXZjvz+3Ns8XGKnIaYqql6rzCD/t5lLsl5v3EpmzPcb+jqMJD7y6//tVb/8a7aFDFOACqikWEiSaMtmvU64J4hzuT/FA8IBYZIS6Wzrd+luWBXPLWkeaum8TuxdsVU3GndDUjXPL57JluUIPyTL7wqrh+y5FZmIse6BLtusWpMHn9fUTzVI1X4awd+gipuu21NkcNYns01rAW1U3KB4TIGgeNPrM5u1knob8g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=X8nna6V9FR6z3TQeYzJFwbNUncpaCJL9LdjjV9RUVos=;
 b=HkoMJDipmDekbVbpmxlYLk8o1ZiFgbQ0UeWUP91PhylNNDMomb3RgpS8esAaDImi1MsFklHcDtJodEvVJrWiDxAn//V1xyldxfVAzANmtyK4FKVNXYksjY2SaPoSDcmOh920rg+z9kqWuNBw//4/3HadWqasy4Z2Qf6/19a+Hcw36jLYMX48H1Aj6+EuntqqFPa96yIuuSvYLvZJT5lQQCrnWjr69c8v/syxWHTTZ+4EJK6OMEUUySfxiNGfgXxFUWP4W9pOjCFarVqXvCS4V8jZyN6eIze3qLwVbP0QP+oYOROdK0HVZfI+Qahpk/3srKA0RvLFYheFWu2XuTgijw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=seco.com; dmarc=pass action=none header.from=seco.com;
 dkim=pass header.d=seco.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=seco.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=X8nna6V9FR6z3TQeYzJFwbNUncpaCJL9LdjjV9RUVos=;
 b=ZUwdwwyLXPw7acwgSD9NcAI4N8VjjU+/eELOVh2mbB/vsQO8ZbZjQ8jkEHW9gyWNTtdALHxTgyRLevCo0VAOi0YO7KQrRB3NBkRFb4BYe/rl2dNMwz90NfxLucbpm+lcmScE71Aem0NR7Ao2HghTxrzzIEmIZ0VtZwZZOpEG+I2PmtlUvDEuI/OLX+dTz/DUrYkfTJp1JP9SAwV3LnK2lw7UK3mBFphSrRVGunL1TO0oCFUtrdRTDQT3G4UFGTLs2+Y/VvwGaVUawx7Hln9k2H7yUPOWTk9iLjyymSFeWBWqjm58FGWacepyDoWOHcOuUm3FSFswd7VOkUjao+btCw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=seco.com;
Received: from VI1PR03MB4973.eurprd03.prod.outlook.com (2603:10a6:803:c5::12)
 by DB6PR03MB2902.eurprd03.prod.outlook.com (2603:10a6:6:34::27) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5438.17; Fri, 15 Jul
 2022 22:01:04 +0000
Received: from VI1PR03MB4973.eurprd03.prod.outlook.com
 ([fe80::5c3e:4e46:703b:8558]) by VI1PR03MB4973.eurprd03.prod.outlook.com
 ([fe80::5c3e:4e46:703b:8558%7]) with mapi id 15.20.5438.015; Fri, 15 Jul 2022
 22:01:03 +0000
From:   Sean Anderson <sean.anderson@seco.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Madalin Bucur <madalin.bucur@nxp.com>, netdev@vger.kernel.org
Cc:     Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>,
        linux-arm-kernel@lists.infradead.org,
        Russell King <linux@armlinux.org.uk>,
        linux-kernel@vger.kernel.org,
        Sean Anderson <sean.anderson@seco.com>
Subject: [PATCH net-next v3 22/47] net: fman: Configure fixed link in memac_initialization
Date:   Fri, 15 Jul 2022 17:59:29 -0400
Message-Id: <20220715215954.1449214-23-sean.anderson@seco.com>
X-Mailer: git-send-email 2.35.1.1320.gc452695387.dirty
In-Reply-To: <20220715215954.1449214-1-sean.anderson@seco.com>
References: <20220715215954.1449214-1-sean.anderson@seco.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: CH2PR10CA0009.namprd10.prod.outlook.com
 (2603:10b6:610:4c::19) To VI1PR03MB4973.eurprd03.prod.outlook.com
 (2603:10a6:803:c5::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 961713a2-9520-4611-b565-08da66ad82dc
X-MS-TrafficTypeDiagnostic: DB6PR03MB2902:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 1WS+jk3F4FuCXlcw+sSqm2i7ID0CiVWrj59yVYowIZtaNX1+eO61MFdshwOiwxlHGEIMeSD/EKXvon3BaulAZZkHnjdbPaH7tOZxdDHhUSkLIYV3e4a0Uu2MWCwSqwHYBji9/YsrVUlutgxFnzrvZIe0/nbB+fxkHiNsA4nww52H9xo46h3urphLPtTU9KeIAehfVgYr4h59HkFRIA+V3SKtrVwAlWi4sMcN/SLGdZwvUpU3oQO5RSKz3aZyRwKDL7bcwk8huArdiB4tNDeKuM72yiRMWYC7JPA7DAyeFx06LKB+e3Sxd4hT9YjaPLJl8MbpAz62J+K2aDN6fa9C4Jy5OqsyLEhMDNdVTbKdjh12G0jK+YGJHALrglVHwfR3Ni9uf5925YetQZGI0Z8VKoFF+j8HnpSwGkDfFLmW0r3YuYu6swkP4nkAArORD5FUIioZQCywjxJLsLKvhrdVEeHo6bS7oBxKmqYhTuAp68mpDgrRvlS5JlyzxDdYTKU+el88cSWZb3RsYMs4AIOSPyfiSXLGMU+Qi+KiuK2tEQuNYL3JzQOwZ2GyCmhpESb7auZRJvWxac8x00CLc3u2SAElGsWQ9lGTzAM/8nZHVvex765TbO4kZWxzXqTgETlDhprDlEOvbkLe3co34imn2v8QnssMdqogg7LUZw6Yl4pib4QqasV7O0ti0c7/1ouhIRKKBLmzOar1BCs6FRj8R7H5c0vScBSoInAufUMtlwt4m1UvG0tIMcGwLo7PboPPEEBtlY3FnnffncD6zb6jP6k+79/eqtd7XceijX8uGG8VOTu6bCTBoTDHEiieSkCQ
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR03MB4973.eurprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(346002)(366004)(39840400004)(136003)(376002)(396003)(86362001)(5660300002)(83380400001)(6512007)(1076003)(107886003)(38350700002)(38100700002)(186003)(2616005)(36756003)(26005)(6486002)(52116002)(316002)(41300700001)(6666004)(478600001)(6506007)(110136005)(54906003)(2906002)(8676002)(66946007)(66476007)(66556008)(44832011)(4326008)(8936002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?GVaHbyQbR/y/fjbpR+cABMM1tR5hoovCjuh3mcdN1guLjhnhKnue/WW4P25W?=
 =?us-ascii?Q?vMgsL5w4Tbk0vlvUXxw3jjV5hV5cig/9Kj/IuspwnvpNqHODgiqyoSlK/tW/?=
 =?us-ascii?Q?MfvcJBy0JQGu6Lz+sbw9E2uE6nFSy8kLMPFgZePo1lAigOhU2Kyl70A3DY+c?=
 =?us-ascii?Q?u5VkevdkOQsYH/ICSQs+OP+XaIfF8IEHn9/U7bi6uMr+2KF+B1CYlXVZu36m?=
 =?us-ascii?Q?/LQil9ssdfmTKvLs9CgagOkWF3V0rY3vmGMAUR0OeYU41dHnOA0UcrA4RVLC?=
 =?us-ascii?Q?u8G84/GJDdyKkKI54vFNQxHmjAAnO5LVFJhHmfOpfaincj98XY8OwwfYA6Mv?=
 =?us-ascii?Q?Dhid67Kt3gKUKIi05omsg9Py6iot7oi6YctaMZJrOv15Zf/NzPZkg1jViz6D?=
 =?us-ascii?Q?tATddjmlrr+WZjBle4MdQvIRlpyJb+N8ND70+Q532VnXkvaURCviGdZckZEX?=
 =?us-ascii?Q?TnZNSEJJ5UPG/EawF74NT/g1GqTMy7jFQpmTf4obB4LFdOISbxDwlayAFhKh?=
 =?us-ascii?Q?fnllSrjA42nYf/bzubVWjVnvPcoSdDYy0cRUkoA6TLdQbTtXbnPXNHDxxrYd?=
 =?us-ascii?Q?8IOQwGwvDDFRJu09bEWJ8HI3KKZcOw1vLEb4K5iKioC53cKttTHL3HdU94gD?=
 =?us-ascii?Q?WIpK4NpaWmI/F6cnI+KPcnZZl1nbcaBv1+wzHMdc6x6jkjVcIxx+bP7+5ujs?=
 =?us-ascii?Q?Z6PdE4n3+nqbGrOypo7PQkQc9EdD50H9S81IatjDgJ6IMGTXE92bVSo2hTEc?=
 =?us-ascii?Q?ShZrRFhcFk5ykB0/gPxmR23e+CHPLDrkrk5MP8nRGEm05R9hquyQT9wFaRTv?=
 =?us-ascii?Q?HzO9gwr34BynLVbmr4izBuN3eX3VMxnbAiYNUD9Z75JeaXC4PwZmjTaEh10w?=
 =?us-ascii?Q?Fo43kOfNRlCX+GLVQYyL2ocneqKnzCRBHFdPzIlR6bmo547LzjpMkcXZzFOt?=
 =?us-ascii?Q?WA3RC7XNm1w5PQ/gVsm51q8cpJ7cRilE5ZHtNesIqrj1SU9M/WUEBYe/aGH4?=
 =?us-ascii?Q?JTAt4E4ATzX6MxU9rI/hmYpZ3FD7Oj22xG4JL2KZu4G6Y+i8uMUG5Py5pYMl?=
 =?us-ascii?Q?Yj2k0bmVCZQxVuoS96vk2/VybSU//EfYsw7A4jS4ZHymFcgMcJ1XUsPeu67C?=
 =?us-ascii?Q?/jKaXEjhBK818i0vH1C44gz9HXTxSFYh6fCRnKA+z+fhMrapOfUVL3BQzBkr?=
 =?us-ascii?Q?x5MdSgYgO+QJQ8GGGN74wTLtKt5aTXo+Mqu+aVdb3yXwZGcPf87p2x1gl78X?=
 =?us-ascii?Q?5mE7oOHk6ZsmNL5TkkGjx9Pz+NSBg7Bv+jQE2/5c5q8GxRqZGt6tWJuDnq9E?=
 =?us-ascii?Q?bWCmHb/Q15JuUo/zJUZH1D+C9D+1FX1BwntDe0pgFrxZ/0MRBLohGKXbSxTR?=
 =?us-ascii?Q?SwmQLQUDyMEYWvTTsnJE1QeNS5iT7GaL2ywhFvg3nfGG6Iw71pD/RkGpXUaB?=
 =?us-ascii?Q?hGbOMdqrGPryyJqEMwRZPkhkZ0/dZaXBPuTozzMMIut7bdTWS08rk2CnL++a?=
 =?us-ascii?Q?3Vnn0BlyXKY0XE+ZRXhZwhMNNpyos/0FXi/SV8e0PlEgW49r8Qr8v+jRI20e?=
 =?us-ascii?Q?hCwAwKq3RbAiMeOflBkcIMKalrxjRBnkSrbvvTYLaApcbOHuraX/nA4d8IMG?=
 =?us-ascii?Q?oQ=3D=3D?=
X-OriginatorOrg: seco.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 961713a2-9520-4611-b565-08da66ad82dc
X-MS-Exchange-CrossTenant-AuthSource: VI1PR03MB4973.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Jul 2022 22:01:03.8786
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: bebe97c3-6438-442e-ade3-ff17aa50e733
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ZvuR3O/65Sy7EDPIRhjIjY0WfZGwCed5TktPP8I7KADHDEdoO6UActSeNsK3wdImVEYlWysULvS4DGTMeeStrQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB6PR03MB2902
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

memac is the only mac which parses fixed links. Move the
parsing/configuring to its initialization function.

Signed-off-by: Sean Anderson <sean.anderson@seco.com>
---

(no changes since v1)

 drivers/net/ethernet/freescale/fman/mac.c | 93 +++++++++++------------
 1 file changed, 46 insertions(+), 47 deletions(-)

diff --git a/drivers/net/ethernet/freescale/fman/mac.c b/drivers/net/ethernet/freescale/fman/mac.c
index 5b3a6ea2d0e2..af5e5d98e23e 100644
--- a/drivers/net/ethernet/freescale/fman/mac.c
+++ b/drivers/net/ethernet/freescale/fman/mac.c
@@ -34,7 +34,6 @@ struct mac_priv_s {
 	/* List of multicast addresses */
 	struct list_head		mc_addr_list;
 	struct platform_device		*eth_dev;
-	struct fixed_phy_status		*fixed_link;
 	u16				speed;
 	u16				max_speed;
 };
@@ -391,6 +390,7 @@ static int memac_initialization(struct mac_device *mac_dev,
 	int			 err;
 	struct mac_priv_s	*priv;
 	struct fman_mac_params	 params;
+	struct fixed_phy_status *fixed_link;
 
 	priv = mac_dev->priv;
 	mac_dev->set_promisc		= memac_set_promiscuous;
@@ -429,21 +429,52 @@ static int memac_initialization(struct mac_device *mac_dev,
 	if (err < 0)
 		goto _return_fm_mac_free;
 
-	err = memac_cfg_fixed_link(mac_dev->fman_mac, priv->fixed_link);
-	if (err < 0)
-		goto _return_fm_mac_free;
+	if (!mac_dev->phy_node && of_phy_is_fixed_link(mac_node)) {
+		struct phy_device *phy;
+
+		err = of_phy_register_fixed_link(mac_node);
+		if (err)
+			goto _return_fm_mac_free;
+
+		fixed_link = kzalloc(sizeof(*fixed_link), GFP_KERNEL);
+		if (!fixed_link) {
+			err = -ENOMEM;
+			goto _return_fm_mac_free;
+		}
+
+		mac_dev->phy_node = of_node_get(mac_node);
+		phy = of_phy_find_device(mac_dev->phy_node);
+		if (!phy) {
+			err = -EINVAL;
+			of_node_put(mac_dev->phy_node);
+			goto _return_fixed_link_free;
+		}
+
+		fixed_link->link = phy->link;
+		fixed_link->speed = phy->speed;
+		fixed_link->duplex = phy->duplex;
+		fixed_link->pause = phy->pause;
+		fixed_link->asym_pause = phy->asym_pause;
+
+		put_device(&phy->mdio.dev);
+
+		err = memac_cfg_fixed_link(mac_dev->fman_mac, fixed_link);
+		if (err < 0)
+			goto _return_fixed_link_free;
+	}
 
 	err = memac_init(mac_dev->fman_mac);
 	if (err < 0)
-		goto _return_fm_mac_free;
+		goto _return_fixed_link_free;
 
 	dev_info(mac_dev->dev, "FMan MEMAC\n");
 
 	goto _return;
 
+_return_fixed_link_free:
+	kfree(fixed_link);
 _return_fm_mac_free:
 	memac_free(mac_dev->fman_mac);
-
 _return:
 	return err;
 }
@@ -570,7 +601,7 @@ static int mac_probe(struct platform_device *_of_dev)
 		dev_err(dev, "of_get_parent(%pOF) failed\n",
 			mac_node);
 		err = -EINVAL;
-		goto _return_of_get_parent;
+		goto _return_of_node_put;
 	}
 
 	of_dev = of_find_device_by_node(dev_node);
@@ -604,7 +635,7 @@ static int mac_probe(struct platform_device *_of_dev)
 	if (err < 0) {
 		dev_err(dev, "of_address_to_resource(%pOF) = %d\n",
 			mac_node, err);
-		goto _return_of_get_parent;
+		goto _return_of_node_put;
 	}
 
 	mac_dev->res = __devm_request_region(dev,
@@ -614,7 +645,7 @@ static int mac_probe(struct platform_device *_of_dev)
 	if (!mac_dev->res) {
 		dev_err(dev, "__devm_request_mem_region(mac) failed\n");
 		err = -EBUSY;
-		goto _return_of_get_parent;
+		goto _return_of_node_put;
 	}
 
 	priv->vaddr = devm_ioremap(dev, mac_dev->res->start,
@@ -622,12 +653,12 @@ static int mac_probe(struct platform_device *_of_dev)
 	if (!priv->vaddr) {
 		dev_err(dev, "devm_ioremap() failed\n");
 		err = -EIO;
-		goto _return_of_get_parent;
+		goto _return_of_node_put;
 	}
 
 	if (!of_device_is_available(mac_node)) {
 		err = -ENODEV;
-		goto _return_of_get_parent;
+		goto _return_of_node_put;
 	}
 
 	/* Get the cell-index */
@@ -635,7 +666,7 @@ static int mac_probe(struct platform_device *_of_dev)
 	if (err) {
 		dev_err(dev, "failed to read cell-index for %pOF\n", mac_node);
 		err = -EINVAL;
-		goto _return_of_get_parent;
+		goto _return_of_node_put;
 	}
 	priv->cell_index = (u8)val;
 
@@ -650,14 +681,14 @@ static int mac_probe(struct platform_device *_of_dev)
 		dev_err(dev, "of_count_phandle_with_args(%pOF, fsl,fman-ports) failed\n",
 			mac_node);
 		err = nph;
-		goto _return_of_get_parent;
+		goto _return_of_node_put;
 	}
 
 	if (nph != ARRAY_SIZE(mac_dev->port)) {
 		dev_err(dev, "Not supported number of fman-ports handles of mac node %pOF from device tree\n",
 			mac_node);
 		err = -EINVAL;
-		goto _return_of_get_parent;
+		goto _return_of_node_put;
 	}
 
 	for (i = 0; i < ARRAY_SIZE(mac_dev->port); i++) {
@@ -716,42 +747,12 @@ static int mac_probe(struct platform_device *_of_dev)
 
 	/* Get the rest of the PHY information */
 	mac_dev->phy_node = of_parse_phandle(mac_node, "phy-handle", 0);
-	if (!mac_dev->phy_node && of_phy_is_fixed_link(mac_node)) {
-		struct phy_device *phy;
-
-		err = of_phy_register_fixed_link(mac_node);
-		if (err)
-			goto _return_of_get_parent;
-
-		priv->fixed_link = kzalloc(sizeof(*priv->fixed_link),
-					   GFP_KERNEL);
-		if (!priv->fixed_link) {
-			err = -ENOMEM;
-			goto _return_of_get_parent;
-		}
-
-		mac_dev->phy_node = of_node_get(mac_node);
-		phy = of_phy_find_device(mac_dev->phy_node);
-		if (!phy) {
-			err = -EINVAL;
-			of_node_put(mac_dev->phy_node);
-			goto _return_of_get_parent;
-		}
-
-		priv->fixed_link->link = phy->link;
-		priv->fixed_link->speed = phy->speed;
-		priv->fixed_link->duplex = phy->duplex;
-		priv->fixed_link->pause = phy->pause;
-		priv->fixed_link->asym_pause = phy->asym_pause;
-
-		put_device(&phy->mdio.dev);
-	}
 
 	err = init(mac_dev, mac_node);
 	if (err < 0) {
 		dev_err(dev, "mac_dev->init() = %d\n", err);
 		of_node_put(mac_dev->phy_node);
-		goto _return_of_get_parent;
+		goto _return_of_node_put;
 	}
 
 	/* pause frame autonegotiation enabled */
@@ -782,8 +783,6 @@ static int mac_probe(struct platform_device *_of_dev)
 
 _return_of_node_put:
 	of_node_put(dev_node);
-_return_of_get_parent:
-	kfree(priv->fixed_link);
 _return:
 	return err;
 }
-- 
2.35.1.1320.gc452695387.dirty


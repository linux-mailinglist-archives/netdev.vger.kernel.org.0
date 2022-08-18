Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F12A359888A
	for <lists+netdev@lfdr.de>; Thu, 18 Aug 2022 18:18:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344631AbiHRQSA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Aug 2022 12:18:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39530 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344554AbiHRQRb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Aug 2022 12:17:31 -0400
Received: from EUR04-HE1-obe.outbound.protection.outlook.com (mail-eopbgr70085.outbound.protection.outlook.com [40.107.7.85])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 77376BD0B5;
        Thu, 18 Aug 2022 09:17:30 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dU1wXc8OQUk1vnPN4sl+NPNn6xuhh8ubzx+9NdTjK+7+T4D/4Vx0bo9hv6CFVCZOcLnj9KC+LPDIwP26hHyO4qnQqXiX3AJZPLMJuYmVBUq5nlPNQ9E+PZizgUB7F59/IGKutz/MprPEFP8BX/yBavIs9Fe2CCE1iKatsW7W9i+N4uf+RjbfI4PPPqZgJmVauWyBZAGP7r0VnGwZgTvpxgsbrwpHSFi4+ethTbNKTOBDro24xFHQpJUludfSqkIGwmWPCpXtS8tiudn3dMPrHBTfNK7mu4zGAEBSpjdiX46Fskqhm5T94rMEdMtP6peo51V9jD0aymvMa76eMBdasw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=wS5ITppNepmtVMtZsf6WSzWL6go75usr88Nid72CAN0=;
 b=SJjDUNZ73KzutcET665RU6ST8QxCYbF/1/UF81b0cetz1YTz7PVMPwLiVnxNekCY9T0SbSubuXAZEA8PEK87hE3OgWMXSgnMBGrK5i5pMze58iMKWryIhbIOXM+W8qwXawJciBRWLmWXMDytEm9jQa+OfLqe6ekKItntZJ4Aj3P9FBVai5tNoI5smfeZ3OKUE5JruQ0MoI9BCDr3/RZ++L+Q3sxgLWbW6ToX0DAwDc2LZyPQlurIAIpfO8XBLvxWxjIsOW3K1hrXIPnj+1dSbOuaNaCC4aRmkCbD7/gzKh2i2uR3eiVaq3/46TuoQfRfWLUAJ5Nz+emS+mgu6vL/aQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=seco.com; dmarc=pass action=none header.from=seco.com;
 dkim=pass header.d=seco.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=seco.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wS5ITppNepmtVMtZsf6WSzWL6go75usr88Nid72CAN0=;
 b=jcluQ+iPpDjeGnIYfzLI++I4GclROhQYY+vtOLNs8jHer86PXMDzwvvsq/1GbjgTir5VlyME8dU9B+F76XYeBUzWRLoNoJ2En/6mHW05Nx39ssuGreFZWBiVLV8tKCkXJYGT6WvTi+FjcHigRoXDvLhOR20fePdCpeG+QIEuCiadBpsGEcBU4WpWq4fYNQAgXJcBO7099evx3l3f8ehZQ47tpws6Gy38/yPGu24hAKaOx3t+QI6D8AI2Sv9DuW6m4xOchejZ0yRcRBH0Jgn2jWs+hdlH+CHxvRdhplIEIUueKgj+R4i3tOS+ZYbEAydJ28MNJmVwUUoEAYBi8m0sZg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=seco.com;
Received: from DB7PR03MB4972.eurprd03.prod.outlook.com (2603:10a6:10:7d::22)
 by DB3PR0302MB3211.eurprd03.prod.outlook.com (2603:10a6:8:11::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5546.16; Thu, 18 Aug
 2022 16:17:20 +0000
Received: from DB7PR03MB4972.eurprd03.prod.outlook.com
 ([fe80::ecaa:a5a9:f0d5:27a2]) by DB7PR03MB4972.eurprd03.prod.outlook.com
 ([fe80::ecaa:a5a9:f0d5:27a2%4]) with mapi id 15.20.5504.019; Thu, 18 Aug 2022
 16:17:20 +0000
From:   Sean Anderson <sean.anderson@seco.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org
Cc:     Camelia Groza <camelia.groza@nxp.com>,
        linux-kernel@vger.kernel.org (open list),
        Madalin Bucur <madalin.bucur@nxp.com>,
        linuxppc-dev@lists.ozlabs.org,
        linux-arm-kernel@lists.infradead.org,
        Sean Anderson <sean.anderson@seco.com>
Subject: [RESEND PATCH net-next v4 09/25] net: fman: Configure fixed link in memac_initialization
Date:   Thu, 18 Aug 2022 12:16:33 -0400
Message-Id: <20220818161649.2058728-10-sean.anderson@seco.com>
X-Mailer: git-send-email 2.35.1.1320.gc452695387.dirty
In-Reply-To: <20220818161649.2058728-1-sean.anderson@seco.com>
References: <20220818161649.2058728-1-sean.anderson@seco.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MN2PR20CA0009.namprd20.prod.outlook.com
 (2603:10b6:208:e8::22) To DB7PR03MB4972.eurprd03.prod.outlook.com
 (2603:10a6:10:7d::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 4f0811b0-096f-4530-bb2c-08da81352067
X-MS-TrafficTypeDiagnostic: DB3PR0302MB3211:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 4/btZ+wDkT7eZvYUlTuBn7tSyYCQc1DbDxP8rIam7X2w9OotLzBnMn2GGVSN3Btj2Anp74yVMSe+WVu+rEm7UlIYoMNzNnhBMMnfOur7RSbTRpsgddESg4c4SzY0hM0Jrt9sy0Z1e7d6rBQDDL/hsM50G2AD17IJCsiBWqtNC+nhU0tVpnePtJQLZbR4u3ctvgY97ELCbdZytKt6cWEqULLXKtCZAnqf+HS3MYo/J1kn8aPzd168EtRu4x77v3fLP8bADMJ+vZ2NTTeRhUSci5oGGYkCA1jSqc/ONdhQq6BJxt93LJfW1AnuEMMj6mmjmoYNYIr58vMyIaLWZQ74EPAhNnVsfziSY7MqE1Dtq4Ki+rxa4rWp7N+7TCadeSOwFpoiZarKQiMIxnFvLVeC/2VKBFGTh+bmLwl5u5ucaKsqucXJyQnsn41Ld66Y18bsrLs7VbtSogGUryn9QDBZlWLozXXW2nVLnx7Kl5e2tRdU3DsB5rAFBPmrOzdtcnsWA1Pnk1ek7g1ymuUnL2/xPPZ8DcZwtms+ZEilbB/Tg6+i6m9vxxjt2bgfNS2XTyW2sWFu2DMDsZkpI+4ABglUZfC70YmT2UQ71UixS1mWKfdhP+c4gntgKEh+zA3ZzGCqUhj3mkYMW9urCWTxiStRzloPusykyR7l1wBZ4UkmwZzW9EHZ9WdJsRedrpN9Du+trUGbAUxoWvs1idUl+8BF+l3YZBMf3ByuaHlzN6qwtsiWtVaaMHY//QF2ptmNjCiFbsJPW+XlM9WsfaEaNnxEDg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB7PR03MB4972.eurprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(396003)(346002)(39840400004)(136003)(366004)(376002)(2616005)(38350700002)(8936002)(38100700002)(4326008)(6512007)(26005)(6506007)(52116002)(6666004)(2906002)(8676002)(36756003)(66556008)(1076003)(66946007)(66476007)(54906003)(110136005)(44832011)(478600001)(86362001)(41300700001)(6486002)(316002)(107886003)(83380400001)(186003)(5660300002)(7416002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?ikANFR+l4TK2+BCXTNgEqzZgg/2LB49S46FzuR1klo/m5vfRLNl7ToC+BPbX?=
 =?us-ascii?Q?aDqvNAtWKPGukrx3CwoVy9hdvww01H4xNVU1eVHehX84IMr/WT2L2irZuCSc?=
 =?us-ascii?Q?pdd1ADoYnbvPG8NrPMrEMWS6E4erQdBqFlw/UPszc9Ez2P9G+ZXnJvcIuD4r?=
 =?us-ascii?Q?gEpv4N0C0K5PfA638muMNTOKE41K7TUAQ5q3iPce0o5IC8oZiOAEi6PT2Qou?=
 =?us-ascii?Q?7VJAT4v18BPzybgyGozJLpOsefwGEpobHcYYkogjN/7NRkPVT3vfjBt8Yhfw?=
 =?us-ascii?Q?nWhAMiS2/NpTqPmbctsudoGr33SmLJbVrwGhbPHkjHZjRoFOYHgGFJJWvXK8?=
 =?us-ascii?Q?TZSFvBGSYjYXfOoEyJFoR1TMVz5RQY8aoFBOWQe5s6rlsMM80kPII3S/KzzC?=
 =?us-ascii?Q?mRlIBLXOkAAeqV+fL50UKilKXdgsOlE9lAk6UdW9GOmHdnIM3R05baF0dGDy?=
 =?us-ascii?Q?aeyRYwTAUMmoDyQ1tOsQKu7H9O6sis90V1nJ8pgFD1iRxs/gnb0yJVYvbnoQ?=
 =?us-ascii?Q?1cSXrBsvMFItu/ELUfp6Ephuyw7SLZhFCV9arwn10ZIPisfbDuITNuT5tYvC?=
 =?us-ascii?Q?W78XnHbJqPBFs3mooJUPI+Dj4VfjeiZt/0FKgAYJ7BtnDJ1LIV+7GokT3C+l?=
 =?us-ascii?Q?6F1Aybxa8Z/qXiVQnSXF8zxSITeFOA2fqPp1XtvFRoVkyvo9dLtaP/hBbx0M?=
 =?us-ascii?Q?tbGFjT5ab6gnLahzARHJAE/Y2kzhJf8m5YN4fpefzzhgspqKn9jWdHMd6FzF?=
 =?us-ascii?Q?NSdr/h8QWTHHmmd0afip3qr5B9oAWH6RRGArN7l8yOoshjDVPf0WrGSxknf+?=
 =?us-ascii?Q?rbt80BbEKc/L8tRaEV9w01vticyS+Hou0JuhtCYKG/EE/BCWiZgejEZ9/fHo?=
 =?us-ascii?Q?uXOs7A1Ja324VhXRUsrvJOMHsPn9ZqZWHwLWivNPIzRO01pIuXQRVeG+nL5s?=
 =?us-ascii?Q?ofLeoqCDKUrw7jRq9uNrgeKZIIr4TM/E2dWIw6rq2PEEY/KYxTJB3WuFhsrm?=
 =?us-ascii?Q?FbLicAGOW+mSIHmrxRPhPtkvZJ8Fws3dGBrp5htVk+bgVZaHT641HiH2Lu6M?=
 =?us-ascii?Q?Xe15EdwCufa3wumsIfg8bWM5ch0rDbLfbIX8UjCkLeuNh2oeHleWsbzInjL0?=
 =?us-ascii?Q?XKMkOObsy2BRM7QJofBtu8jsyJAikZfL67j70MBRrULEtBe+pFfAoYI+yGNr?=
 =?us-ascii?Q?a3uWpZlAUGDbVmAMPYFIHX73DO04EtxSo5w4pIqvxlveDpFDbFyT0cpvWwKY?=
 =?us-ascii?Q?pibM1yKsSgmkUM+Vuqq3nxrea3jShE/dmkXszTQV3uY7JOf1zRKdxXJUXGro?=
 =?us-ascii?Q?8zoOqj37z2XpEvKBc3fNeYeqqg0kfrLaFfRhzh1Vw+W+nYfudkR7q9CMy8zq?=
 =?us-ascii?Q?RBBueNDI4tbnNT4P1mo/v0LyV+EN27Z7P6Jxi1K+7qColSC05b+RMIvBTBx0?=
 =?us-ascii?Q?8FFTNpTyLOVpu0H/IHTUpP1+/PLnntacqG2Y+yAS/nxUKzMWVdcV7Qy+KPT3?=
 =?us-ascii?Q?Z0ocMW9euELPjqUKd6UShBfNM9SUlJYE4k1MESByjjafJDdtjxtSyXJ5IRfg?=
 =?us-ascii?Q?O8hFI8OiCFPXfkmbRs2Leauy7JOepT4fX0+t/thThXiWymX3pXm4hrtmzuFX?=
 =?us-ascii?Q?Tg=3D=3D?=
X-OriginatorOrg: seco.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4f0811b0-096f-4530-bb2c-08da81352067
X-MS-Exchange-CrossTenant-AuthSource: DB7PR03MB4972.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Aug 2022 16:17:20.5140
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: bebe97c3-6438-442e-ade3-ff17aa50e733
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: f0acTwbZyB6vQh4fV4Qp+pUOx8xo7MtYwxoetHSRzFtYibwxvJt/Zs1c1GXyJiqkT+ms+PYtV7uPfy9nk1roPQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB3PR0302MB3211
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

memac is the only mac which parses fixed links. Move the
parsing/configuring to its initialization function.

Signed-off-by: Sean Anderson <sean.anderson@seco.com>
Acked-by: Camelia Groza <camelia.groza@nxp.com>
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


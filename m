Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9BE30580147
	for <lists+netdev@lfdr.de>; Mon, 25 Jul 2022 17:12:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235999AbiGYPM3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Jul 2022 11:12:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55228 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235869AbiGYPLZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 Jul 2022 11:11:25 -0400
Received: from EUR02-HE1-obe.outbound.protection.outlook.com (mail-eopbgr10078.outbound.protection.outlook.com [40.107.1.78])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4B65619C0F;
        Mon, 25 Jul 2022 08:11:22 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gOrjz7hRZS7AqIV4j8M1jxkHB15bkJdiBZd6oWXeOrmyYfN7a+u2irXs4SeOjVespFny1JZbl5Xr8CWiFKPb9Ja6pI++ZxaPjBX8t4cBc3L2evjOBbvj6CioZKtRnibPoEm0OiaazJ5gOdetv/8Il4WVoh+CvfIRpulwFGwFvvczzpNyfgLFqxdhhibEV2peHugjOyH56b/RXfpVXkfQeEZL76oNbyfXPSj1CfrjRcBLCdZGuqVTQvTa5hMmZ0DoXpKyEU2YELH4GbG2HGyvd+CCX14CEkDZJR+VVXaPZ+C9ZzHHc/ZQerIsg3UZMQP0n6mMFmfg6U9z+qqsb/0JFA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=wS5ITppNepmtVMtZsf6WSzWL6go75usr88Nid72CAN0=;
 b=QdXnvdMxiDhoICQ4r1Oe6VvfCkthf129TzMD2J1Q4leMGNBL9PzdDXv/oYT6F3F6z0abVFt9nx6PiT/jSwj2pcgQIRrSCvj2cIsaktMKMXa6hNl9nIwKL6RuqW1bIDShRq0q/XcLJ4j10EuIeyyD3dVNHRa7DUB2RCGrekMpDLnzPDvQZa7Zjv5WQt2w3s5JLGKdrQgfY/lKDQC3MM8cIR37GDLfZWy5rUybAcHfijZTOndQSRVmw43Wf5ltdOyI6WfRewVm+MciHygmZB2uHiwCQ603F29n+dfJY30UJ5fQzW0SQR1GHRuW6yVXxJT3vVtJh3lYEOPCIhF+CYxBAw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=seco.com; dmarc=pass action=none header.from=seco.com;
 dkim=pass header.d=seco.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=seco.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wS5ITppNepmtVMtZsf6WSzWL6go75usr88Nid72CAN0=;
 b=LzshjRGWZhYu8bsEixVmBKXKjc55b5xs0ClEvf/8RCzLjvp47sw4yTbWMMVYkTIUyr0LxOr7xxf4rVKY508m6fldVGOx/jt4KYyhUC3z9+qD5MNKYxC8PHr6wD3Sq/yH0FnSnJMzIt+iYm0oruoNN5KcHgrh+OtVVTXlFULLuW8iEkwwHC+Xb9Yill9FHCJLU6lxIoE4gFgcQdpYwG/JQcnGRKzI3+YcWUUdk9gWkXYjZJJkVGyxLLDCD6dJbvkjVF+a3+5h4/fDD0VzUwia3ei82/bYcj2rECbnMm55xzJDDXbnh1jb9vHvYhtl0NlhfmYq+oq5zaHCPiigjYdWMw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=seco.com;
Received: from DB7PR03MB4972.eurprd03.prod.outlook.com (2603:10a6:10:7d::22)
 by AM9PR03MB7817.eurprd03.prod.outlook.com (2603:10a6:20b:415::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5458.24; Mon, 25 Jul
 2022 15:11:14 +0000
Received: from DB7PR03MB4972.eurprd03.prod.outlook.com
 ([fe80::59ef:35d2:2f27:e98b]) by DB7PR03MB4972.eurprd03.prod.outlook.com
 ([fe80::59ef:35d2:2f27:e98b%4]) with mapi id 15.20.5458.018; Mon, 25 Jul 2022
 15:11:14 +0000
From:   Sean Anderson <sean.anderson@seco.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org
Cc:     linuxppc-dev@lists.ozlabs.org,
        Camelia Groza <camelia.groza@nxp.com>,
        linux-kernel@vger.kernel.org (open list),
        Madalin Bucur <madalin.bucur@nxp.com>,
        linux-arm-kernel@lists.infradead.org,
        Sean Anderson <sean.anderson@seco.com>
Subject: [PATCH v4 09/25] net: fman: Configure fixed link in memac_initialization
Date:   Mon, 25 Jul 2022 11:10:23 -0400
Message-Id: <20220725151039.2581576-10-sean.anderson@seco.com>
X-Mailer: git-send-email 2.35.1.1320.gc452695387.dirty
In-Reply-To: <20220725151039.2581576-1-sean.anderson@seco.com>
References: <20220725151039.2581576-1-sean.anderson@seco.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: CH0PR03CA0229.namprd03.prod.outlook.com
 (2603:10b6:610:e7::24) To DB7PR03MB4972.eurprd03.prod.outlook.com
 (2603:10a6:10:7d::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 9efb05ce-6a41-4e44-5ade-08da6e4fea82
X-MS-TrafficTypeDiagnostic: AM9PR03MB7817:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: qeimUrH3vPktVU8ShkVrZfFi7Sk8v0cjUYIF11OSNDFvyMFpo/TtHQJjzY+kYHeqcRVPIYqsAppk6uzCNKmB2Sz7f4NkKDz7L+EXkkM7iPsQjXsHgZpAKH30OFeqV7isoHhktzRaqUz/cZOEX4Cs5HI5+VepYAkeFBwoEjy1VawceLw+8qJt//EHiW8p3cW/OS/SVO3dD4h7GdSz/IgDSlUGlwr2cadR1Mq+whfwwIpmnRvsuMTD8PvM7y+FkWhEYqINokz8heqweBF8wOFxWXCrd1k1fD9nB3iZKe1Xbqo0GtuKj8wtYX9jtGyMJZRCbDqKmgwlrURp0/GnIYYwy7TxH1jakq9aT6nNq6fGwbno/so+nGzkbVMX0OX9QfG83OBr4O/keo69cv1w074lR+Hgbs/PLkmS1Q8aRm/pSqDzLN/WiVLkuIJ8v1zvEMoT8/n2w933JoRrRMIGnWBtYKP3It6rSpIPo+13sCgF0TiLKg9p0BigE99nQO0InxYdTF2eN/LSYswy8xzEfdZODCwWxkE2bgqnEI4YVLpOSPuM2wwsIF6YJtdKUXyiSLj5Ed/308BkIGdztLpxWdHebiIpHPZAhwM6hDP63bQRFhoGgOwqfU1DEXMhkOjaNN1Rp8+lITxs8ifIlB1SCYMIfos29u5fkbUfBssZ6yJLyhJJ9ySV0+x08rVm5LqGrhaoCdzRjwaNCY9OBqabB0oaqnHTMslf9iuMVY6dA+NhIKIeeYg22nabv6YOt3Ly3RCuO72C72ETw0z3h5TWJKBpLL/s8HQEMa9ty/PGG52YScc=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB7PR03MB4972.eurprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(39850400004)(136003)(396003)(346002)(366004)(376002)(36756003)(110136005)(54906003)(186003)(38350700002)(8676002)(66556008)(66946007)(316002)(66476007)(38100700002)(8936002)(86362001)(2616005)(478600001)(4326008)(5660300002)(6666004)(83380400001)(7416002)(6506007)(41300700001)(6486002)(44832011)(26005)(6512007)(52116002)(107886003)(1076003)(2906002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?gvyDbx0bTedxbqRJ8YTl6ikOboqEtWF2u8F9rRfY8xpiedd9ZaWTBzZDTCUf?=
 =?us-ascii?Q?p/wAygLsSCTPKcA1iQU2hMCLMAebvuXN9gxptmFzZ0jfJpO2Oso+2ufcHOTy?=
 =?us-ascii?Q?m3Nmthl3OOZYik7dzICB4X6+WS2GSNtYijP2yPM3FoaoVmrHa2d/h/Sh98wU?=
 =?us-ascii?Q?jKfx/mOS3IHqEbbMdmq8pn72IeLvtJJ7c/fL8u2L38EKx3tLDcJAus+88OYo?=
 =?us-ascii?Q?iFR7DHjMoF+XIAqQVoBevxC0CgwtEoZpvOEj8c75by9qkUxAOZ+6eWS1BVw1?=
 =?us-ascii?Q?ASSQShw18qaTnNX0e4pqVmm5suVFGhmksWk28q5JSdNLvFEtH+93iAp8E2sD?=
 =?us-ascii?Q?7HUqSZtHopMRfKmlKxeVMtX8q+BQ6ym2mRqmcYaK9ZaLHGFctn2+gaQjBzXV?=
 =?us-ascii?Q?vX9gY1ANN/7OgZegaJXRtBTkd6sNQbaSw9vt6Xcevwk0vnTxs6o9aNHzlZbO?=
 =?us-ascii?Q?+wgdAzdRec9YYr9Xdk2Z0xcCErRExgZY7TEOp1kmp4muCED3h9sqJhKw0bx5?=
 =?us-ascii?Q?QpuBajlrTN624TR31z8NIsDPXRvTEYo+aZkqURE0WN1G0TIAWYF6bAA9+lf2?=
 =?us-ascii?Q?laK3M3I8Qj1eqbNvLBrS5Z1DXGysuKTn89NrmJcT3estPe1Niz1FmM3dYC1d?=
 =?us-ascii?Q?UhQkBfSCcrXdnOVnwKZ9xAsKhcY2ebMSlHXxuvKEmJvcZ5UPYsLA6c/N4gox?=
 =?us-ascii?Q?H9oW93C7Mw4ofXVFKxEm9rfzifzYHInxgO91HJlIB/9tnm31gsKv4fNQV9nD?=
 =?us-ascii?Q?nMtA8u0ZIhmrPkx4tdXwcuOiNK1d8rdlaWvgrdIaSP0yhS40oIdDDQ0J9q4j?=
 =?us-ascii?Q?UtkEgLIEUJj3V1aNwf714SwNySk6oKHjZyMcwj20vP8V8zFm1682ToFwBk2z?=
 =?us-ascii?Q?wk0U4Z726tuMgovUOJu76GGq9pmpJkHrgQ3IaToQi1+IfdvwNGzPQwV4bj5t?=
 =?us-ascii?Q?DZovueFpwAWq53kQwv7JxnuC7oBQmu4wexdlS+53LJwxT+txFt7jKkZ17k1U?=
 =?us-ascii?Q?h68krX9WmrwCouW2PWGl8MXoEu8l+iwCbMedym/Gs992X0qZdAG/up8VLKgu?=
 =?us-ascii?Q?HJAUeEiw/iVpwSMG1DFYN33axtj6Lr2PWfzH9L4VRp6vccW+9vItZs0zh2fc?=
 =?us-ascii?Q?t9c5ED4/G0sdvpIQ5uqVwhGCVyyUcg5LM4s/ds39hwhhcAZuLXpaPLljT7/f?=
 =?us-ascii?Q?6SvWWtmzRqktFgLtliEN4KYkbE99ed+6aOlprSg8b7aWnPAR3pWeNiXbXNXl?=
 =?us-ascii?Q?hEWZlOHBVPsW+G7Qp7C1BwPWQkOagA40Yf8lB93STAmNvzlu4nNOHTQs9Xi6?=
 =?us-ascii?Q?Vb04uIlrsUvqH7/DpBpFv/1Es/8Hn29O61rwKEL1SzqHR+7zYXI0MhFfX+ek?=
 =?us-ascii?Q?QRcdOubNQBdldMi61vMQswEKdQjEEUtt03PCub7mZFxtsQgnozaKO5KmefvK?=
 =?us-ascii?Q?t1q5D732oln5xSjhy1rP4Zj8X/MBrIoEa2OiPEGzByxiP6NcRDX8BESvt25G?=
 =?us-ascii?Q?C/F1/gTHUUZYN62xAi5T/pnz1/7w7z1FWRQHL2Tzes8VSVU+SqtTE8WQSTbT?=
 =?us-ascii?Q?Zx9b8iu9AJBYzBlE8SK+yUpti4rkeqki4oT4X+OOjANi3iJlozoayb8FT7Ow?=
 =?us-ascii?Q?+w=3D=3D?=
X-OriginatorOrg: seco.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9efb05ce-6a41-4e44-5ade-08da6e4fea82
X-MS-Exchange-CrossTenant-AuthSource: DB7PR03MB4972.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Jul 2022 15:11:14.3323
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: bebe97c3-6438-442e-ade3-ff17aa50e733
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 7Ub4MrcBF2hHgLUoF/IKL/Zu/brhEnaRzIqdO3zmuXFrURCoLzNR1mGzm1eXxhcseTqkbEj60zE/tuVWLucFLw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM9PR03MB7817
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


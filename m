Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 53FB5580148
	for <lists+netdev@lfdr.de>; Mon, 25 Jul 2022 17:12:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236021AbiGYPMa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Jul 2022 11:12:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54980 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235873AbiGYPL1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 Jul 2022 11:11:27 -0400
Received: from EUR01-HE1-obe.outbound.protection.outlook.com (mail-eopbgr130088.outbound.protection.outlook.com [40.107.13.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E29E1193E9;
        Mon, 25 Jul 2022 08:11:21 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VeVJJ6K3/cEL3ltURXGdVd9NmXRsmc1gRjEH/Q19c6SGDV7I0Z+FpiD/KeoGEjgbB3/SkmPqqQXbFiJ+RVKwgZInat5MmlH0J0byS3SORn8jCkYdCD/UOaCPsHEZI8apMOdCw3IW7UJqIf1CbaMQUoD4iN/7qYVTkuuF0AMJ9T5q4EF68ljBdsKC53KWvMvjKkypHwdczhIFrtBb7zI8zGDpWFgqS2CuRQBrTGMMgH+5Z8e994L5ZJaqF4+4Y6s2EZ/THXHGYdC0OpNIWzefsAu59AdrA+vnwPAuWn0pvm8sHkXzJgs7hjItVzjZqZJ21mclrgUt6OrvGsKdLwZoeQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=yjElZB4KBj9O7wepfR5xVozXWKsZLczj6QtJJ2HiuT8=;
 b=hnwo3Yg7kK0aBSBzzqDV5Ff8hjsoQ7QjvU9L7M+OqUbDl55ufPjJqpJcBnk+em4EVPe9qVPkc9YNs9sA1Or1OY4koLAESErhgcLKuZCPOrMuk7tusCWzVOCTiGlKivNkvQoYi5A8v3MEdS+/0iuQG/GWAZIjIU+Iot97/HpKy3U+ZO3+quETo5XcEG7wI8Fs/Hi3OZtJq2TknCZ0OSAPsvqTLPNbkRYFuFo+/KfUPzFSZhe87HWZgkeqAjBCwR5QU1qC1frMhEE57lUjWczXjC7kNaW7/RC+VuquxR7TC+cuNxypsJ1hTVSc36t16wMnivoiFq44p8R3C6lE6kBgbA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=seco.com; dmarc=pass action=none header.from=seco.com;
 dkim=pass header.d=seco.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=seco.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=yjElZB4KBj9O7wepfR5xVozXWKsZLczj6QtJJ2HiuT8=;
 b=Lw2NDVc7ppNq11GsFfIqHRdIujzWWBwDVFBygOSlVocb7JPHblTolRqJBHnY1+hlpuHiFcZyL0Bht0GJ21jt7xZh4Vx9JxHcDHw5Ks7CZAJWXy9vc/OuelSKP1eI9PcLjcb5Alzt6bCOJ7QsC2100q74BoZ7fkTQHaerCylWY4OaX5IeFArswA+1HvIsSL6o/Y5rK4PSvnLfVWYBggMFtgRHz8N1mkFcKgHJz7BvlZpHlgV70FddhghoG2Tg/Gu8hL96xsQXB4WCx2A5TiRhy/K0SModl0mJxmwvTK3GInLPzN0lBR1L4o9sc1MFFV7L7jbTPd1Xh9L7uOaG+VbKDA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=seco.com;
Received: from DB7PR03MB4972.eurprd03.prod.outlook.com (2603:10a6:10:7d::22)
 by DB7PR03MB3723.eurprd03.prod.outlook.com (2603:10a6:5:6::24) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5458.18; Mon, 25 Jul 2022 15:11:18 +0000
Received: from DB7PR03MB4972.eurprd03.prod.outlook.com
 ([fe80::59ef:35d2:2f27:e98b]) by DB7PR03MB4972.eurprd03.prod.outlook.com
 ([fe80::59ef:35d2:2f27:e98b%4]) with mapi id 15.20.5458.018; Mon, 25 Jul 2022
 15:11:18 +0000
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
Subject: [PATCH v4 11/25] net: fman: memac: Use params instead of priv for max_speed
Date:   Mon, 25 Jul 2022 11:10:25 -0400
Message-Id: <20220725151039.2581576-12-sean.anderson@seco.com>
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
X-MS-Office365-Filtering-Correlation-Id: 354b5a9b-8223-46f9-111e-08da6e4feca9
X-MS-TrafficTypeDiagnostic: DB7PR03MB3723:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: gF61q32NfkKyXAeyEuaCI6WbWI6eQx2AnOtuIwP8HnAyL8cziEc31qprMnEezDZjsoNp8+tWTjTxnGb2EAl2WOzNqW14yTEObl0snTBURbxWtLBJ4nSBt6C6aLkLeA8logLfSqRanl11kXDIzHizQZwl4nJDhpQT2UX9dGoOdObq4YXWZAAqDn2Wbv/q21RmMr8bopkqC2BF91ZTGBtR5BBhBbq31kbFcwm/jz/pGr3/YONYPIGL3NadxJnbQMYcVGSEIDCcP4lGOjtYibCJxKCoTSmv/AaWTBQZ43D/G1fnc1a0A8JvYtBZbfxcZE8jnmar26dgxUJi6gaTf519+pcppNZAN2pqLhpRLXi60/Ib7e+Ci45qRyBNTaQUTtDNxv5qMx2svJbw9oRRns2ZNMlrUfw+uVFQcYJFGIBJwJrqAwffvZw2JqbuoGANzXMycvT9/UO32akZiTThoKrKAXNfsR+R+OFJYiCRFj1rrpv/ruaCq65O2u9x6p5+YDX0EjObyadguuwQUXiUQGLwCRKO49pJuFWW1pV1LQWVx4iHdcMBLwmMsq6TDsuv9VizUVKlVqSxnmO7Z4iQDQY+6UFvHS1Nun3tBOsqtVj1qUlcq3Nv1MOPua7O5Bs/qboP4ePJAr3PUbU+UGe363EkG8t8NhB93XmOpZIZ0Q+RfAE1ft7vH19pTsurtSSBxNMsrhN7tCJAFiI/+y9LTUSr3koQn2dIZIZv1G0O7E5lrIfY7farUueEY/4+MYPF/55SzmOV9oL9ye2RjnwwrfB4BNeXgCJo7Ch4cQjZdHCpI0o=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB7PR03MB4972.eurprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(136003)(396003)(346002)(39850400004)(376002)(366004)(186003)(6512007)(2616005)(107886003)(66946007)(1076003)(316002)(5660300002)(44832011)(66556008)(4326008)(66476007)(8936002)(6506007)(7416002)(52116002)(54906003)(110136005)(6666004)(26005)(8676002)(6486002)(2906002)(38350700002)(86362001)(83380400001)(38100700002)(36756003)(478600001)(41300700001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?vh1kLrVsXcSAbAlHz1XZA+AOhxoGSvaFrzFE7Z5Umiau49K8fLa9mVfJ6vIy?=
 =?us-ascii?Q?jjoddm2I0okK2Q1WVfyNTzGaRO0zBiHcU+Mv0j5udaD81Uh9m2Fk+51cknzi?=
 =?us-ascii?Q?VOyvPhhiQ8fpxwBwOkDvBvrUoNKIIP6rwDxmFpe6+jdytrdod0Oc+UB2kKuo?=
 =?us-ascii?Q?6T9UO3VoTEYmE1RTSWiPyvwHZo5wGdGF/6ciWCooZnhmx7tARBkbucovYFvK?=
 =?us-ascii?Q?LT6qP+XHClwt+yQfIdzmHAwLG0WN5dfx63imVmDR+XuMSFS6hnizGWvyxe8I?=
 =?us-ascii?Q?4mAdBT+cbcPXAeDZ8mESkUytlrUNnhiH66J0M+F9rp3C6vN0Z9HCvmoEUH25?=
 =?us-ascii?Q?S08DCyJvkMRAxHZ0mX4HfLo/inSQGv/NtfxCvM705DrJGX2ZYLRgj6rArsE4?=
 =?us-ascii?Q?e+Z4NzyC8hrtF5hAo2uizznmYiWCbmQeDtl0menFvDY5Y4L0h9s7Myb2rtmw?=
 =?us-ascii?Q?rq+H2KwrVbE7YeoKP9hglLD+i2pqijLKz/UJksJJdLVBYjIlZq/9qQQgxBBL?=
 =?us-ascii?Q?9Dgb2WnGOFtCvfJ6YvoC/SsK/HA6//YfQvTZhLbMPTb2Qoq51muxguVt0FqF?=
 =?us-ascii?Q?hhsVu63w8ZnFF8DUAynbHyQZsTNvy865L4N3wVocbCnKtpWgVLdlBQ+k3BAw?=
 =?us-ascii?Q?Jbl4/1XKIpL5x8qsF98Jz3z4X2sm8W5gMwyHpjuvieQIh6mnq5ymPuohqlc6?=
 =?us-ascii?Q?B1QRMyUxrShPa0c1N8d2vN8rP7JG60i4Z82Xi72R1ZHQbK6/XrpMuUgkx+VB?=
 =?us-ascii?Q?52L8db9NIIGZUKl4JS3s9BrQqE0aRp9ukWtuVKj5d+X9O4hoZkpk3B35Q848?=
 =?us-ascii?Q?kVfNdQZwnpDTJWmsS9h4dl+xvG/5ZfNcp4MeXkjXdE2mK/Ui+YenM4rhKUaY?=
 =?us-ascii?Q?blyhXpJAbRRgEBVS/a7k+cOX3vIw4q1uatNLr4OyZaUkQIeaf4A2vYODLPz3?=
 =?us-ascii?Q?va6kUVJxU3WtQe/RUlnGIrEr2RW1JAEY61jS+YP9FEcCSULsh0vipXy71a3Z?=
 =?us-ascii?Q?3yALuCSYQFUCMr1N7Vu2dy+KR46HzksbaWDipdj7iFgeweC7ci6uGGxbhqro?=
 =?us-ascii?Q?VxCQlrd2RUEGHkNccZtTQ9S/X5nPxGHTYaIrPo1Sy3SKKgtG6le8ZabnqiiH?=
 =?us-ascii?Q?ipm/MihwkC7jtH+hsFT06NSIO6JUrWWZYU2wOUbqhkmJguyXNchRhwuEAIkp?=
 =?us-ascii?Q?zy2tqEPFmFoSAZyxvjRZN3YKeDSk6spo7O0z8km+3XBTZKRam88J4xZPam26?=
 =?us-ascii?Q?v4/89sV7xL2g8zVQB6LpmAPuHBsmjIDTMuIyBrbKZielE1gbjao8V5HSQc1V?=
 =?us-ascii?Q?KyfrVGi6Eyik5zZBrXjmLkdqWgR8n5AA9zR9BY1v8qzJAvF18zLAVZSlOQBf?=
 =?us-ascii?Q?6zquYQ8svv4isKCZghAAcAU3bjTCcaCUF4HZf+wpgreMUlzJG8YIDfGejkt+?=
 =?us-ascii?Q?bpXDe+yFd93KAepjUhN49AXJnAZYAnpkdtdrLWj0Gx4sfw4Ajk2jChqmXXZn?=
 =?us-ascii?Q?mxFHN07bufL+PHiSvpZWN1C1mA5MpIpBrao8zNNpCBvQQOn4k0cbGT5ubHUF?=
 =?us-ascii?Q?JUZqBN+p/lvncdQcAIsUNTQblvOgNTdygFpR/4YkxKjvqIO5sSrj2Tx5RLdR?=
 =?us-ascii?Q?jw=3D=3D?=
X-OriginatorOrg: seco.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 354b5a9b-8223-46f9-111e-08da6e4feca9
X-MS-Exchange-CrossTenant-AuthSource: DB7PR03MB4972.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Jul 2022 15:11:18.0664
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: bebe97c3-6438-442e-ade3-ff17aa50e733
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: +C4T0vsr/9lP5TWE3TNKCp15PJixrYyrEHbZbxM+Fmhx0X2oOc4cXKnatM8cBfPX8SKfcHkRf2NSv+adUM17EA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB7PR03MB3723
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This option is present in params, so use it instead of the fman private
version.

Signed-off-by: Sean Anderson <sean.anderson@seco.com>
Acked-by: Camelia Groza <camelia.groza@nxp.com>
---

(no changes since v1)

 drivers/net/ethernet/freescale/fman/mac.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/freescale/fman/mac.c b/drivers/net/ethernet/freescale/fman/mac.c
index 0ac8df87308a..c376b9bf657d 100644
--- a/drivers/net/ethernet/freescale/fman/mac.c
+++ b/drivers/net/ethernet/freescale/fman/mac.c
@@ -388,11 +388,9 @@ static int memac_initialization(struct mac_device *mac_dev,
 				struct device_node *mac_node)
 {
 	int			 err;
-	struct mac_priv_s	*priv;
 	struct fman_mac_params	 params;
 	struct fixed_phy_status *fixed_link;
 
-	priv = mac_dev->priv;
 	mac_dev->set_promisc		= memac_set_promiscuous;
 	mac_dev->change_addr		= memac_modify_mac_address;
 	mac_dev->add_hash_mac_addr	= memac_add_hash_mac_address;
@@ -412,7 +410,7 @@ static int memac_initialization(struct mac_device *mac_dev,
 		goto _return;
 	params.internal_phy_node = of_parse_phandle(mac_node, "pcsphy-handle", 0);
 
-	if (priv->max_speed == SPEED_10000)
+	if (params.max_speed == SPEED_10000)
 		params.phy_if = PHY_INTERFACE_MODE_XGMII;
 
 	mac_dev->fman_mac = memac_config(&params);
-- 
2.35.1.1320.gc452695387.dirty


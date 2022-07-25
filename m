Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 96EE0580203
	for <lists+netdev@lfdr.de>; Mon, 25 Jul 2022 17:38:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235909AbiGYPiW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Jul 2022 11:38:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51950 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235969AbiGYPiT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 Jul 2022 11:38:19 -0400
Received: from EUR05-DB8-obe.outbound.protection.outlook.com (mail-db8eur05on2061.outbound.protection.outlook.com [40.107.20.61])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8AA50DF30;
        Mon, 25 Jul 2022 08:37:53 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=EQA0s7sSO5uVKA8zQgPEgWAnt4BMcL3aenEaIE1amTpKQ1ShgxxPiEj+Ji8gmsvgnCyK4m9TcsB3NLhsdTa1OKf4xJ25w+unGSKB4ShBalb91ILPgnG/J58QIwGFXXk590VffHXatCTgiXQQtucfpKHZSvj30L3lJN+MC4pK53to/C0/rPieOdmJU9BcJsh/P8swDVQp023a2pE6H/RkesddG/e2k5gXwpuVStO0Od5DrUOy1H0jPZphPiJhxTZicTZfMD1UipC7XBagRWzo/Q3Z1d9CR9GrrL7lj0yhiAD32AzcUv80kc4cWESUaWt/+cgBQX1kgGo9HDZgclEISg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=U5iFmrfwwkbvAIW1DiuwmjTQzQA6j27fMaHDaUsHht0=;
 b=Dr/RNOmO7BxaWMv0ziFnrIJDhmrDBUk3dfzjfnCwlvnYRobz4Hk8+zum5yP3z9vHqNSmX5u2cXe+72VhFN9stK0aLLl+aYLh6ox4j14qBdT99XkuAxxxk20v8wQAblBeJ1z4Y53G+51xiaKS5C0RYIg05QwgNgHMCQJg1zPvMnThHh58vhaN5OGZ0Zil3/iMITFCDvda0HxP1lKvv1JREmOO33PdSELZCsE5VBpb7Yvs79FDLg44UM7efYv16jGMsH71ZQ9BpGCL9Y1n9QZQ2Pp5dC2qLYvspJuvcEnkwMIwdMHQENOZ+ZYXPwtBOro+hr6ZQVpUJlzjtkaRk3Zc+Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=seco.com; dmarc=pass action=none header.from=seco.com;
 dkim=pass header.d=seco.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=seco.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=U5iFmrfwwkbvAIW1DiuwmjTQzQA6j27fMaHDaUsHht0=;
 b=YgSpKAwcMmSEBJebmmhfaN68t7Ia5pZ2Zg9qRsHD1Qx7YWUVWyKxsGwUo9dp20i967sKjCXMdT46Vv/tqlYgeZtMeV8A3frYurQpazJUX57CAHfBbJwhL+RGsKnmHNNd4UgVx7HGLDhCPi+DBELeS6MIG7F1ZeCw+YeUDC9czsaLnuvn07/k+Wh1zeUsBreUKRBD+nDQ2fgBdgwQUFzNPeo4RZKqe44icm1yFUiaaXmv024YgaLOVNDsaosSmW9L3ufnxwBrvi74fCQi6I8zljNtK+y46WPQFsS3BBsvP799WWssl8wuwDDLrMXU8TEoaTPYP78xeuduar1fi9N7Mw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=seco.com;
Received: from DB7PR03MB4972.eurprd03.prod.outlook.com (2603:10a6:10:7d::22)
 by VI1PR03MB6464.eurprd03.prod.outlook.com (2603:10a6:800:19e::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5458.24; Mon, 25 Jul
 2022 15:37:51 +0000
Received: from DB7PR03MB4972.eurprd03.prod.outlook.com
 ([fe80::59ef:35d2:2f27:e98b]) by DB7PR03MB4972.eurprd03.prod.outlook.com
 ([fe80::59ef:35d2:2f27:e98b%4]) with mapi id 15.20.5458.018; Mon, 25 Jul 2022
 15:37:50 +0000
From:   Sean Anderson <sean.anderson@seco.com>
To:     netdev@vger.kernel.org, Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>
Cc:     Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>,
        Alexandru Marginean <alexandru.marginean@nxp.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, linux-kernel@vger.kernel.org,
        Sean Anderson <sean.anderson@seco.com>
Subject: [PATCH v3 05/11] net: phylink: Generate caps and convert to linkmodes separately
Date:   Mon, 25 Jul 2022 11:37:23 -0400
Message-Id: <20220725153730.2604096-6-sean.anderson@seco.com>
X-Mailer: git-send-email 2.35.1.1320.gc452695387.dirty
In-Reply-To: <20220725153730.2604096-1-sean.anderson@seco.com>
References: <20220725153730.2604096-1-sean.anderson@seco.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BLAPR03CA0137.namprd03.prod.outlook.com
 (2603:10b6:208:32e::22) To DB7PR03MB4972.eurprd03.prod.outlook.com
 (2603:10a6:10:7d::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: ef14664d-987c-4cab-ee73-08da6e53a220
X-MS-TrafficTypeDiagnostic: VI1PR03MB6464:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: zSLs+j5eIxf/S9n5DguMnuVELRXCb2I21yCP6enkstzK1/V7WooVS1jS+HAtxXDQqo7hf4q4Ginbeb10BTChauptaL6ZOTIdKcaWQSTDFoPuWCbA6mMyQXzRF/Limzo6Bf9xqhgWM2ZTAD7//dPfMSPoLHrkG/95jvwOdzzNmFZWz9Fro3Awc+m3emrOV5dmILPpFf8mx19L6B2H5LHEz45WA7PWbBqPjEvgrSxPvuvnVe3FK1NVRnpO+C2h28rZgbpxlIj/oWrkcSAAp6UG3OGv+Wdbh04tg/xTQYG6w8SE0Q92t+DvE8vgNIAZLeLzhkC7mC23z8HdfHJkCeB0vyP/OQ5VAwz8Nvre8uR3V1qWkB4+wyTii3dJWUcryP7Jw06s6aghMA3/FBdpq4gbhEv6mUXNUGyiovKug/QGyCAXn5VLMr2FtpyjydzulOcev7W5MoGtI97o00+JZpZgK1/wjmuPmnW39diCYWD+DnAWAhiTYWdISVl5EJ9q2KLPE616MK7QWvG8nQZ7Onh2tU5viB7wzkH+qspNiKEoO05N1bjb64BuPnsNaBNZNPMnDz/D59wfVzk+l6aohxTi+k1zCfqsb5LfJ4RTh1szEbZ3FB6br617WEg5tAxT9sMWcLGoLhh+WUNWyznSux0zpRWJXGaSuu3+rEcnigCFGvsS5p9tcI+JWfi9fRwQBQDfYJ6kUP7wRSbGrG77GGXefsayZU8EsrUNkw+lgdEXpHy+2z447Ldr64JDLOPBjmW8af3H+MBVkhk7Lz+ktTSejxJmwLv4diTWiJqpiwv/2zU=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB7PR03MB4972.eurprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(39850400004)(136003)(396003)(346002)(366004)(376002)(36756003)(110136005)(54906003)(186003)(38350700002)(8676002)(66556008)(66946007)(316002)(66476007)(38100700002)(8936002)(86362001)(2616005)(478600001)(4326008)(5660300002)(6666004)(83380400001)(7416002)(6506007)(41300700001)(6486002)(44832011)(26005)(6512007)(52116002)(107886003)(1076003)(2906002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?GM2o5VDnIiq25p78X/ALc2X2HL/NiRrwfSMGiZByhAz+kuPfexq/ri/DiNZ4?=
 =?us-ascii?Q?OdIi3AfQNNc6lLHG/Ghy/RUiPAe/tfdTc3oTYIQPB1LhX96jlXlPhAYDnWzi?=
 =?us-ascii?Q?MlCRvb5lnk8CxnNaEj4J3QYhAtD4rlgr20Iz7G1WUIQKLZwHrszyNNiwjy+u?=
 =?us-ascii?Q?ZPke4kqF3OORlSiW+B7Iob9lh5cewEBqzLvuDFn6rhFxWlYBJ8vKkfQpBB3r?=
 =?us-ascii?Q?PNCVjmVBjnuSP8xmS68JYm0lT4nP2kwlShipm8qCOd4P+xM3IZYEtaDsB+HM?=
 =?us-ascii?Q?itVC4ro6MJxC0rmhYlNmq3dpYTjFnUbo+hjxcd01Vws3XjX/AXcJM5gKzmyG?=
 =?us-ascii?Q?oCsa8SXXiW0j44hL5eNXtkAPi/0Da0VZ9zJc29aE3j6XgWh+N4Jx2PFUE/w3?=
 =?us-ascii?Q?8lPQzsCHwDmWNTRMKoGNFXewZTFwgEQmQ0+e+IJ1CyQ291ZEPbs2OjypwA/Z?=
 =?us-ascii?Q?iWo3t2fK3lxoQ71TZC4Cbvarr+CkbZSDQz6zPJSzdA2r6iGHy2g32AxPE80j?=
 =?us-ascii?Q?0WLSwby5MlhGzAAsoxrYUGVNxg6vlo7Obx8YPkUSiezIhoOtObNwkrs5zhcL?=
 =?us-ascii?Q?2A2Y+eD6/nzU/lGOd6XTeq5IYD4fZPkXjizToixF0H+IL3PofIES4VwbFhYJ?=
 =?us-ascii?Q?h2aUUtRqAwV8MwiivzHsn0ZqBJZdN97k3hWat7TOeLSEoYxK15OvXN6Y+Ji8?=
 =?us-ascii?Q?8nMU7gxwKFEpyabvi9qZoqb7Bl5ikK8yKZQjXljZv1T9PDt+4g2I8t4OvSpN?=
 =?us-ascii?Q?NZpQfPULIo2iCxbClEe350Pq5YULHaNNLx0IBOHghrBUYcpVk71SedKo0Fxp?=
 =?us-ascii?Q?y8My4/w5wTtTDR4yayNqiB3fsnuUhWs1Fk9uJegUDd2sEt7562nBVAw/rUdk?=
 =?us-ascii?Q?PZdCMmp5We9ZNdFeSH8+++r7G6q201f4BqtlcNJLGYfqIuFfhR1hrpw99CON?=
 =?us-ascii?Q?BnA7s943t+Ur2Hoj0Z9k3Vj44dZBDINQJf1PkgsP6j7xvl6GlR2vjPe2I8g+?=
 =?us-ascii?Q?mF3u/pz8aAsqDco8yXV5ohE7+OUYijDt1393FkMvoP6qkkhiLOU54o22xaRg?=
 =?us-ascii?Q?6V+OSzyfUiVW+G4hjk5/IeMpw+/cj7Prwu/4u6YnTXIn1hN+R/PN0ugnz70h?=
 =?us-ascii?Q?XyIcHOkuuFb/jmynESAsdFQ2MC7Lrzfsks4/C5BXZbwrk5InZfkHnThaPszt?=
 =?us-ascii?Q?v2TlyYrP4SEShfIpGLPwbqUlwJcw9LdxAPlajnNj9DdcRFQvQ8OSLtHgrVj3?=
 =?us-ascii?Q?7iuf2HkvSaTt1nCUSn+XQzt4J32xUeJ7ceJXSeM9A7ft9Enep3IYmxQnQTWg?=
 =?us-ascii?Q?SLZf7glzb68UqeDg2Q0N8C8CJIquyvujEpVbiyzcLdHy6ZMQ3ghU1ppAtrth?=
 =?us-ascii?Q?M9wfZfrb4fal+1bIm7ycTkBrA8A2/uro4zgWZ57RxpaEkRGV9RVQl8yyAKsa?=
 =?us-ascii?Q?mLS64aQDahX5Bj7slYQ7lw4s1YfKlrrz1nwLWgidYhxghmnOViw0/qxrrkfv?=
 =?us-ascii?Q?JHJEmNuaYQ4Wvzb4k7YPeN6bEBQFj3JcbcJ9M1aaQCKXooBUUpw+v+KimV9S?=
 =?us-ascii?Q?WkwbLWS+7I4/H1h3nQGP+FOReS02SkBDjtkgh149MkCzsKrnnpps6h1Oo5Be?=
 =?us-ascii?Q?ag=3D=3D?=
X-OriginatorOrg: seco.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ef14664d-987c-4cab-ee73-08da6e53a220
X-MS-Exchange-CrossTenant-AuthSource: DB7PR03MB4972.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Jul 2022 15:37:50.8535
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: bebe97c3-6438-442e-ade3-ff17aa50e733
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ehwxlPDe5aPQH0R8YvoHGk2Hb/cx2Zb93QzvaKox5WgiXWKOp26nRIFwh5ETRCyb483OJI7DiYizn/epc2iHGQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR03MB6464
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

If we call phylink_caps_to_linkmodes directly from
phylink_get_linkmodes, it is difficult to re-use this functionality in
MAC drivers. This is because MAC drivers must then work with an ethtool
linkmode bitmap, instead of with mac capabilities. Instead, let the
caller of phylink_get_linkmodes do the conversion. To reflect this
change, rename the function to phylink_get_capabilities.

Signed-off-by: Sean Anderson <sean.anderson@seco.com>
---

(no changes since v1)

 drivers/net/phy/phylink.c | 21 +++++++++++----------
 include/linux/phylink.h   |  4 ++--
 2 files changed, 13 insertions(+), 12 deletions(-)

diff --git a/drivers/net/phy/phylink.c b/drivers/net/phy/phylink.c
index 51e66320526f..68a58ab6a8ed 100644
--- a/drivers/net/phy/phylink.c
+++ b/drivers/net/phy/phylink.c
@@ -305,17 +305,15 @@ void phylink_caps_to_linkmodes(unsigned long *linkmodes, unsigned long caps)
 EXPORT_SYMBOL_GPL(phylink_caps_to_linkmodes);
 
 /**
- * phylink_get_linkmodes() - get acceptable link modes
- * @linkmodes: ethtool linkmode mask (must be already initialised)
+ * phylink_get_capabilities() - get capabilities for a given MAC
  * @interface: phy interface mode defined by &typedef phy_interface_t
  * @mac_capabilities: bitmask of MAC capabilities
  *
- * Set all possible pause, speed and duplex linkmodes in @linkmodes that
- * are supported by the @interface mode and @mac_capabilities. @linkmodes
- * must have been initialised previously.
+ * Get the MAC capabilities that are supported by the @interface mode and
+ * @mac_capabilities.
  */
-void phylink_get_linkmodes(unsigned long *linkmodes, phy_interface_t interface,
-			   unsigned long mac_capabilities)
+unsigned long phylink_get_capabilities(phy_interface_t interface,
+				       unsigned long mac_capabilities)
 {
 	unsigned long caps = MAC_SYM_PAUSE | MAC_ASYM_PAUSE;
 
@@ -390,9 +388,9 @@ void phylink_get_linkmodes(unsigned long *linkmodes, phy_interface_t interface,
 		break;
 	}
 
-	phylink_caps_to_linkmodes(linkmodes, caps & mac_capabilities);
+	return caps & mac_capabilities;
 }
-EXPORT_SYMBOL_GPL(phylink_get_linkmodes);
+EXPORT_SYMBOL_GPL(phylink_get_capabilities);
 
 /**
  * phylink_generic_validate() - generic validate() callback implementation
@@ -408,11 +406,14 @@ void phylink_generic_validate(struct phylink_config *config,
 			      unsigned long *supported,
 			      struct phylink_link_state *state)
 {
+	unsigned long caps;
 	__ETHTOOL_DECLARE_LINK_MODE_MASK(mask) = { 0, };
 
 	phylink_set_port_modes(mask);
 	phylink_set(mask, Autoneg);
-	phylink_get_linkmodes(mask, state->interface, config->mac_capabilities);
+	caps = phylink_get_capabilities(state->interface,
+					config->mac_capabilities);
+	phylink_caps_to_linkmodes(mask, caps);
 
 	linkmode_and(supported, supported, mask);
 	linkmode_and(state->advertising, state->advertising, mask);
diff --git a/include/linux/phylink.h b/include/linux/phylink.h
index 2a6d2f7a7ebb..661d1d4fdbec 100644
--- a/include/linux/phylink.h
+++ b/include/linux/phylink.h
@@ -535,8 +535,8 @@ void pcs_link_up(struct phylink_pcs *pcs, unsigned int mode,
 #endif
 
 void phylink_caps_to_linkmodes(unsigned long *linkmodes, unsigned long caps);
-void phylink_get_linkmodes(unsigned long *linkmodes, phy_interface_t interface,
-			   unsigned long mac_capabilities);
+unsigned long phylink_get_capabilities(phy_interface_t interface,
+				       unsigned long mac_capabilities);
 void phylink_generic_validate(struct phylink_config *config,
 			      unsigned long *supported,
 			      struct phylink_link_state *state);
-- 
2.35.1.1320.gc452695387.dirty


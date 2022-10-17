Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1E357601953
	for <lists+netdev@lfdr.de>; Mon, 17 Oct 2022 22:23:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230218AbiJQUXq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Oct 2022 16:23:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52874 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230501AbiJQUXX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Oct 2022 16:23:23 -0400
Received: from EUR02-DB5-obe.outbound.protection.outlook.com (mail-db5eur02on2062d.outbound.protection.outlook.com [IPv6:2a01:111:f400:fe12::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C32A656B96;
        Mon, 17 Oct 2022 13:23:18 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=cWbDFU6mdUkOUh6sJZig9DhOfUU1JgUWFdAH7VGK3a2zovTqP0fHsK0v9HTmF1nfBtFstJ/1nxn/x54p6DSS00BO3H0EGV0MNWe7J4/KfAXiwry8/1gWa6FQ0S7H6nBLnNwK+aqJcJGsrl04EzfZamn1Qc/YgDrbIDBLRuXBATlsSrt9vnBOp6frTcFW1R+9P43Je51MwviPGDWfjjQ9o2KmVIZlIrFU0xq/cfn9uaXsoGGr0I4jZ0Rj1qTfgHw/oFWcTjSqixp9garFH6ZyHQSpJ76KnzwBPhCJSapEfrRLuaTHWPXQXS5S+4Q5QnWpZ36xTzUURbaQOsDD/BgT9w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=MuTitHhPg0b12Qp2wrCx+kHRxCvPDQhgJzaOtmPQ0DY=;
 b=mf/GvmyW4igb/kddnQoTfCgLnCMPh7WmvivLvno/S+zFOz7BByg5G5zjeMaUPnowGJlPIRDHlEydZJ72+CPwYceNe5a5bVR4FIkrtBjUl+yvsKpMEpTHhSy2sVwXs89/b/bgdAX9lLNdgd9Fu0SeGd8nOAmp9QK4FkXElrGDb0bS0mKvwNCU1Oz98fu3XVPpreQc+ziggfDiXoaGURgepk9/SUrYCvVKME6GBMGPnMcgXzF2FjWGUyGi9g+ScOdWhH97O4nzmNL6sALatS6ZS9qteYoEPQcRw0oiQp2I3h9ACKLSUzC7ywQeGd8jLeVDCQUvvfNX4FqE7Vh1U4Qc8A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=seco.com; dmarc=pass action=none header.from=seco.com;
 dkim=pass header.d=seco.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=seco.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=MuTitHhPg0b12Qp2wrCx+kHRxCvPDQhgJzaOtmPQ0DY=;
 b=jSiDNzQuQjuAr03DuaqyS5axLgavlJ6+1JdBzLG9ES2WhRPSuxtHMFubLJxkdFhKiVNIkvOGaNP2ozNfsY32wQAGZtUUQ1vmP8ZnwWxDLlNzjN9BEexzUBtqLsl3Uh4/mlM8LxQJZLmUY4cesJdeQDidoLr27tWG56cMLkLWafQTqAck9A4fhxrlz0RMp/MlIsBa5pv2f8/5FzhNSaVnSZzSLN9QD+0Ec/6HbW4icrOTpr2P1fPpmWxJrglQQeH4IUD5LLztmCpN+iRmxUYm8LEceynHWeZm4OSGvjyD+D27SDXHXoS+WgT7w/PjWE0tMag0QwpdsLaMWmrBt3fEtw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=seco.com;
Received: from DB7PR03MB4972.eurprd03.prod.outlook.com (2603:10a6:10:7d::22)
 by DBBPR03MB6761.eurprd03.prod.outlook.com (2603:10a6:10:1f4::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5723.32; Mon, 17 Oct
 2022 20:23:17 +0000
Received: from DB7PR03MB4972.eurprd03.prod.outlook.com
 ([fe80::204a:de22:b651:f86d]) by DB7PR03MB4972.eurprd03.prod.outlook.com
 ([fe80::204a:de22:b651:f86d%6]) with mapi id 15.20.5723.033; Mon, 17 Oct 2022
 20:23:17 +0000
From:   Sean Anderson <sean.anderson@seco.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Madalin Bucur <madalin.bucur@nxp.com>,
        Camelia Alexandra Groza <camelia.groza@nxp.com>,
        netdev@vger.kernel.org
Cc:     Eric Dumazet <edumazet@google.com>,
        "linuxppc-dev @ lists . ozlabs . org" <linuxppc-dev@lists.ozlabs.org>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Russell King <linux@armlinux.org.uk>,
        Paolo Abeni <pabeni@redhat.com>,
        "Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>,
        Sean Anderson <sean.anderson@seco.com>
Subject: [PATCH net-next v7 04/10] net: phylink: provide phylink_validate_mask_caps() helper
Date:   Mon, 17 Oct 2022 16:22:35 -0400
Message-Id: <20221017202241.1741671-5-sean.anderson@seco.com>
X-Mailer: git-send-email 2.35.1.1320.gc452695387.dirty
In-Reply-To: <20221017202241.1741671-1-sean.anderson@seco.com>
References: <20221017202241.1741671-1-sean.anderson@seco.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SJ0PR03CA0251.namprd03.prod.outlook.com
 (2603:10b6:a03:3a0::16) To DB7PR03MB4972.eurprd03.prod.outlook.com
 (2603:10a6:10:7d::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DB7PR03MB4972:EE_|DBBPR03MB6761:EE_
X-MS-Office365-Filtering-Correlation-Id: 549a1767-1d88-45cb-6610-08dab07d6d04
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: DeoEVqk5Ejtic5ETrncWESQG4r1yMtrpInckaSLnNxLr8QPwgFit13Ym9LtzZumV+IVjIdPqsITWCq/8DWdQ5dvFnraBZztIweDzMknAUK8l0NpnnjQlkqr/On4RGMPVAIxmD2b9vQ9SUTToZZI5mklfGWDgxc53K8yq3fPKsOb/HdslZqG+kB+VqJW38bWBr+zfT/y/sTPdX/0j11E0Q8A4lXtzX4/1orB3EDvddl3QNMFnEpURFgCXC2NOGGMpNNAUgNdwDh8P6Kmmbs1crwcB8rqdznrIntk8CdqAGnYkFPz3wP9BbYLKuanFTxMsX4FoK7/SV5BmV33wIGQigYVr9j4J6Uh1ch0ST+V+1woZ6igdYV93q716WTJPdfzFHITwwWIMpvEGQGXVA+NeZPRp8bZqUMon2rTiJQNEJQSY1FxnGU+QIkxqpoeciA5sZgH9zhSesRaqsWiytgiP14AI6hDF4J0Sl3LHNlDfjRGw11rtTpYLyHmyo3dOf4qsUe5qlxFxLIMcWgWRbwJr8j9ItukD1Hw2DXP54JT63fcxZJ8+2w0UZUaMLWPQNHAmm5FS6J5sv1Ojno4+iV582HN4UyzazYkmPS/adLrah7aN7T8MmqszIPCCCTv/Ncoet7P9ATGZXjBA50QjoRYAtSO27RigRRt/kvvEhr94+/QJ/4XWjlnCG7mfsLXaRVJzFzwYdL22D8V4MqZrX/TESSgY1Nl3sxtBWTuWE5mI5FR2erkZvNbSpcx4QeuD8JXBo3uXHRJ6tNhoEvLPzF9esA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB7PR03MB4972.eurprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(136003)(366004)(396003)(39850400004)(376002)(346002)(451199015)(2906002)(5660300002)(7416002)(66946007)(66556008)(4326008)(110136005)(54906003)(8676002)(316002)(36756003)(478600001)(107886003)(6666004)(6506007)(8936002)(41300700001)(6486002)(38350700002)(6512007)(83380400001)(26005)(44832011)(52116002)(66476007)(38100700002)(1076003)(186003)(86362001)(2616005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?n58S0iGIB+J5sPCXhBmsubKF7xalmF+Yx46TcohpHszRMjbPG5Q5k1EmGa25?=
 =?us-ascii?Q?fFqeV63rSIMHLU9xPGQ7vWpGOY/2Hiyf4Y0fJC1Nk0vtM1BE93ODtTsL4Vo9?=
 =?us-ascii?Q?jN/5vjZQEhu3STCNpL2D8Rze6DWgn9YX6KY2NZkBElxnvjMCrCX8ljK60P7u?=
 =?us-ascii?Q?/CEORpUOr4gMFPx+ie8vTdNgULCKmi45BHdXMlJo84JgZA0Z0O/SR2cTl7WM?=
 =?us-ascii?Q?u1L/aZygMjaOxkyNW10dhrlJPWdHytCBE11LVJZrsL/c05kEKm3lwDRYyKoU?=
 =?us-ascii?Q?S4PMHGUwulSuFyImCjtFUxYwYtrdmh9K2cFJIH1j2AENqG2cfQf6L0DuGnkd?=
 =?us-ascii?Q?t1G1yYbZC+KVgnoQSTCJj5hssw1dpRksFORdP7+KY4YHCDjJMUBnFqZtSGrt?=
 =?us-ascii?Q?HYYJrroqNkvpgiYKEdY5FH5hknM0ZezZK719T/ghOJzKn9naAG2PywWrNjWK?=
 =?us-ascii?Q?KsbJNWBiQv8rPuz4WySVIcknlQoB3tD4s4pu7F+gz855OkSXC87Fjj9u1EnX?=
 =?us-ascii?Q?gAUYFbxUkDZ19qpTfaydP2FtYTeXsDNOYluKa8ahfXyqcE5CpBnhe4xjagXL?=
 =?us-ascii?Q?CD2NBkklPIuANeKHMVjqL8JSuyOimKw8ef5wb2DsOHmbTivDHq68x2+7b6DT?=
 =?us-ascii?Q?w+tvmA7/qv6VDYbz0E2CwYizhd2IVwjPdtwSjlR6gkl4HcWA3OWEWL5I3Ui7?=
 =?us-ascii?Q?PvkxuHZixJBN/TBomVcdZ9zc3drfuxsGxpQinvpkigtWLkLZvPTT2JwZlhBQ?=
 =?us-ascii?Q?DA9n+XykZA89+fEGMnMycgsVEmv/Hgj+bgkdZDzL47FQD5lzQMZYj9/wsOiV?=
 =?us-ascii?Q?OZ2+YyJoKVCLovoLKZeIr335nb07khvVkFX/QDxuczBbX4HRTYyDT7UdkdbV?=
 =?us-ascii?Q?5MHxLTGIK2KImJ7/7E5k3SMY4j9jr6TQ0FXdRu7xTGxi+Ey0932OiQl5xROP?=
 =?us-ascii?Q?m8EwBhQLjMECEdQKA0JjWLIBa5BIStT06hL0H6hLdWL+vUpFL6zdgWG6Xh8k?=
 =?us-ascii?Q?5gV0GF1bWDUjrlzNQgMJMew0xzvcFWbQkre5rFIKwjmHMZhpf6GaeUXVK162?=
 =?us-ascii?Q?z1vwavg5YlCE1uu2+hFTf/vpKOeuNHh2m/48/VUoY3Y9RMLTLL80Kl84/TWD?=
 =?us-ascii?Q?MJjnNEJyQuI5/XAL4gtk8TqcpYNTpXZBXM1KluWj/DaLOBUTmjBMe+XK4qzh?=
 =?us-ascii?Q?TWpEW9V0qRu66obnlHEGyzh97snyjLSZKuYPBTaVn3SX5SVpTxxIolZLycHO?=
 =?us-ascii?Q?9GxyKziWM/w2Jo0qRXbC9y3O5bZUzQ7vFJpadlRNhc0aVUaNM6HBd4w1trs4?=
 =?us-ascii?Q?xFFHrJfniNB7/7Z7UdimRwomBtWI8ocVHjIW759NQqrGX8plGakmgbAcPAdh?=
 =?us-ascii?Q?5nz/j5uy9tGHkN7elGwah6VOkDZ+MaYkE+GAhSr4FNYQAhTUi0cVLGUw3HD9?=
 =?us-ascii?Q?7wnaJGTh7HG4cijQ+YcjzSG6n7fsKRZWriwNU+6Jo3rJXrGzpjAc4Y16NTwB?=
 =?us-ascii?Q?yncQsVpPk+QGZnetlImpFP25rK268aH+PHSVpf6FR71gD4caJCEJtm1EBtZX?=
 =?us-ascii?Q?x++d1lkcPC4mVVfVH4jHQMlrbzj+C4caqKwTE+9SeUk2hxeAyASOy6g/7nPE?=
 =?us-ascii?Q?Qg=3D=3D?=
X-OriginatorOrg: seco.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 549a1767-1d88-45cb-6610-08dab07d6d04
X-MS-Exchange-CrossTenant-AuthSource: DB7PR03MB4972.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Oct 2022 20:23:17.4314
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: bebe97c3-6438-442e-ade3-ff17aa50e733
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: v5LRAz6/A9TlyipcJI2CvcvXYBGBIr0I94aoS1OPkWfGh5Z90ibilbDYwFA6quEBdDb1ZU5KXbwIr8/L6+laFg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DBBPR03MB6761
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: "Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>

Provide a helper that restricts the link modes according to the
phylink capabilities.

Signed-off-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
[rebased on net-next/master and added documentation]
Signed-off-by: Sean Anderson <sean.anderson@seco.com>
---

Changes in v7:
- New

 drivers/net/phy/phylink.c | 43 +++++++++++++++++++++++++++------------
 include/linux/phylink.h   |  3 +++
 2 files changed, 33 insertions(+), 13 deletions(-)

diff --git a/drivers/net/phy/phylink.c b/drivers/net/phy/phylink.c
index 75464df191ef..ef10f5a70e5a 100644
--- a/drivers/net/phy/phylink.c
+++ b/drivers/net/phy/phylink.c
@@ -561,6 +561,35 @@ unsigned long phylink_get_capabilities(phy_interface_t interface,
 }
 EXPORT_SYMBOL_GPL(phylink_get_capabilities);
 
+/**
+ * phylink_validate_mask_caps() - Restrict link modes based on caps
+ * @supported: ethtool bitmask for supported link modes.
+ * @state: an (optional) pointer to a &struct phylink_link_state.
+ * @mac_capabilities: bitmask of MAC capabilities
+ *
+ * Calculate the supported link modes based on @mac_capabilities, and restrict
+ * @supported and @state based on that. Use this function if your capabiliies
+ * aren't constant, such as if they vary depending on the interface.
+ */
+void phylink_validate_mask_caps(unsigned long *supported,
+				struct phylink_link_state *state,
+				unsigned long mac_capabilities)
+{
+	__ETHTOOL_DECLARE_LINK_MODE_MASK(mask) = { 0, };
+	unsigned long caps;
+
+	phylink_set_port_modes(mask);
+	phylink_set(mask, Autoneg);
+	caps = phylink_get_capabilities(state->interface, mac_capabilities,
+					state->rate_matching);
+	phylink_caps_to_linkmodes(mask, caps);
+
+	linkmode_and(supported, supported, mask);
+	if (state)
+		linkmode_and(state->advertising, state->advertising, mask);
+}
+EXPORT_SYMBOL_GPL(phylink_validate_mask_caps);
+
 /**
  * phylink_generic_validate() - generic validate() callback implementation
  * @config: a pointer to a &struct phylink_config.
@@ -569,24 +598,12 @@ EXPORT_SYMBOL_GPL(phylink_get_capabilities);
  *
  * Generic implementation of the validate() callback that MAC drivers can
  * use when they pass the range of supported interfaces and MAC capabilities.
- * This makes use of phylink_get_linkmodes().
  */
 void phylink_generic_validate(struct phylink_config *config,
 			      unsigned long *supported,
 			      struct phylink_link_state *state)
 {
-	__ETHTOOL_DECLARE_LINK_MODE_MASK(mask) = { 0, };
-	unsigned long caps;
-
-	phylink_set_port_modes(mask);
-	phylink_set(mask, Autoneg);
-	caps = phylink_get_capabilities(state->interface,
-					config->mac_capabilities,
-					state->rate_matching);
-	phylink_caps_to_linkmodes(mask, caps);
-
-	linkmode_and(supported, supported, mask);
-	linkmode_and(state->advertising, state->advertising, mask);
+	phylink_validate_mask_caps(supported, state, config->mac_capabilities);
 }
 EXPORT_SYMBOL_GPL(phylink_generic_validate);
 
diff --git a/include/linux/phylink.h b/include/linux/phylink.h
index 664dd409feb9..c29c3f174972 100644
--- a/include/linux/phylink.h
+++ b/include/linux/phylink.h
@@ -556,6 +556,9 @@ void phylink_caps_to_linkmodes(unsigned long *linkmodes, unsigned long caps);
 unsigned long phylink_get_capabilities(phy_interface_t interface,
 				       unsigned long mac_capabilities,
 				       int rate_matching);
+void phylink_validate_mask_caps(unsigned long *supported,
+				struct phylink_link_state *state,
+				unsigned long caps);
 void phylink_generic_validate(struct phylink_config *config,
 			      unsigned long *supported,
 			      struct phylink_link_state *state);
-- 
2.35.1.1320.gc452695387.dirty


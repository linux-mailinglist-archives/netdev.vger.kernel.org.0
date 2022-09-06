Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AD8735AF0D5
	for <lists+netdev@lfdr.de>; Tue,  6 Sep 2022 18:44:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236175AbiIFQlz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Sep 2022 12:41:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50228 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235439AbiIFQky (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Sep 2022 12:40:54 -0400
Received: from EUR03-DBA-obe.outbound.protection.outlook.com (mail-dbaeur03on2076.outbound.protection.outlook.com [40.107.104.76])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0C97D112E;
        Tue,  6 Sep 2022 09:19:24 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Cbs0ITyB8VB5GW0Wlwqjpo/Qe7mQGgDOUrH1ETxZW+KDhpDlZc+IuagpUPGwPfvUiHfIYjMIC2Rw5JrYorS7oKOWfnzAJR5LQNwQTlcB4nFYnufgL4zXbY2akOUurLzlYLvwLjckZfX8PsOjyZc9sPC98rC0S9ct6t0+OLC3DSyZ3tTxcBSpze0B0/js/IOiB4mC1j0TJQqNCBLdkOjzMQM3LUxjneDS9+J/7/xApR8MAU68j5HO7wKEjF+rzwJLV7E7qzzHC1DfgyyCA1ATAra+0UrRkcMFMr6C6uyHiNV8uwAeGY6DEWhBC0k+neZ9l1NWwh648Io6F/R1aXdJAw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=fJCF7ljDrTc1FW1nQ7/4QSEadMl/TpmNqM0XeZPW+CQ=;
 b=I5W2UY5jRZisYSOdgE7OnVtMq1yFNGyQ57vaphXsGpIV/Y+aglvl/jeauGWmc14qDencHLKAF8FlqwYaKy4XdOymFbi6VEEgDb8GyobeaEriBMyzrpbVPQSX+duF9wEBVS9VgpZTESvmH3D00jUc4NO0eg5cHe1YeS3g97+a17Ql2UyzWJjMFbCH8V0ceiTyJsRvuinj9Fitj7/0tGiKiNRKpUmI2H6V0uweddhoNc9EiWVB3nPO+O8mZGG9r82Gvr1YFSMQ7AXqfa1CSdiDTi/bH9zkc9X1BxwjFO0hlKJ1OHBIIs7azm/Yo8vow2URpQNyQw0+u6abhGHddcclCQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=seco.com; dmarc=pass action=none header.from=seco.com;
 dkim=pass header.d=seco.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=seco.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fJCF7ljDrTc1FW1nQ7/4QSEadMl/TpmNqM0XeZPW+CQ=;
 b=kPNibe54+NM/TgOUI7n7+jBIyC/HtIiIPaa3obJtxFTRgFXgtlGbRZNFNfq/tbJRKtx00MWT8recSSAcJaFUkiKPFUHi5YN2FPKUQGtLQZODMvVVwyc5kKvk0TNc1DxIZpNo7WjHKbnzUby+iCEyjMGSFY7LNgGj7ddHLd2XSOh54Q1xUqMm87SH46xnYJVVuoOYUCNtPJWvEJQIAWIA+TbslZPmIRt87F0KkGgzD3Qda351OsCXMxrvhNI0CNl8vk/uW2g0ptXzkjQjLjIPVSJRb6s/91Kt/ApxRqI5qGAmoX/DW8R8kyj6qnKSaTJ4W9b6ejH7UbDJksKAnmqHQg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=seco.com;
Received: from DB7PR03MB4972.eurprd03.prod.outlook.com (2603:10a6:10:7d::22)
 by VI1PR0301MB2254.eurprd03.prod.outlook.com (2603:10a6:800:29::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5588.18; Tue, 6 Sep
 2022 16:19:11 +0000
Received: from DB7PR03MB4972.eurprd03.prod.outlook.com
 ([fe80::ecaa:a5a9:f0d5:27a2]) by DB7PR03MB4972.eurprd03.prod.outlook.com
 ([fe80::ecaa:a5a9:f0d5:27a2%4]) with mapi id 15.20.5588.018; Tue, 6 Sep 2022
 16:19:11 +0000
From:   Sean Anderson <sean.anderson@seco.com>
To:     netdev@vger.kernel.org, Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>
Cc:     Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Alexandru Marginean <alexandru.marginean@nxp.com>,
        linux-kernel@vger.kernel.org,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Sean Anderson <sean.anderson@seco.com>
Subject: [PATCH net-next v5 3/8] net: phylink: Generate caps and convert to linkmodes separately
Date:   Tue,  6 Sep 2022 12:18:47 -0400
Message-Id: <20220906161852.1538270-4-sean.anderson@seco.com>
X-Mailer: git-send-email 2.35.1.1320.gc452695387.dirty
In-Reply-To: <20220906161852.1538270-1-sean.anderson@seco.com>
References: <20220906161852.1538270-1-sean.anderson@seco.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BL0PR02CA0046.namprd02.prod.outlook.com
 (2603:10b6:207:3d::23) To DB7PR03MB4972.eurprd03.prod.outlook.com
 (2603:10a6:10:7d::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: f0e92ac1-8766-429e-d481-08da9023867d
X-MS-TrafficTypeDiagnostic: VI1PR0301MB2254:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: znfF2KmBfJK2OtPh40Hke/1Pj/U3+t6fmgrGbVo322SCyPBnz4lLJKH+JEot39kT5trlg+V1EEoUzroSIB8zEeV315Sfk4PuWPeIEBBQkD9qLH07eiiSt4zN5mvvFUymcmA3NlAkzPzXnduQoBPEHXJQTpjrlJqI02GiRcyi4E8ULcvp3t/W3Wdw6pPfuvaOGUbo4rVQA9VVIU7toyja9uPHk2F00f9na0cx/u/kIsjyRYdD2EuETP3ocO84vQFqzpS21GQARhDgavPDHZqrooExdTMoZ9cSf4KEbc6dbH4LPpKeYhpwtUu6CHtf5oog7ZSweeVZs2CJGLbl2CoMsqZGwNmx2NwCETxXlLdayud9/jXC5wZxidQJRZwAHLv5dtdO6AMNDx61pQmMy0vszVoA+GnQpRWOb2BvFvLEoHF/2oK0jfnBKAUIcLEAjbe0n4Q1v9AFoaSXw4SYhFeafXjCAGpMDu64Hku+m533/pJBQOZoZMdZRR3Xpb3ycwZVZB84WbgC8Fx/zrsewsIFJwCnPLjfdJkYSkyaxv5340DFvuloGaBCoibv93dm715FdhkyWvgzw5VkUi4a73ISC+JikE8zpRdSWX2CH8ZztGCstJUPHM8ZNMGbydOYA9E+o0Bad6Y6+S1k02/690HQAt3cFnLomkw5xbf/jic0PusZXdaun8JgEuNW9CFeEvfHLrW8F6oRw5wzLlF6ELtT6vpAZj/A5tsASff2eERTlm7oWE40QDZD1ZViL8CLJjntAoORpmgbhkQobZ0lhGzUVg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB7PR03MB4972.eurprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(376002)(346002)(366004)(396003)(136003)(39850400004)(38100700002)(54906003)(38350700002)(110136005)(83380400001)(316002)(4326008)(8676002)(66556008)(66476007)(66946007)(2906002)(44832011)(7416002)(8936002)(6506007)(5660300002)(2616005)(1076003)(52116002)(186003)(478600001)(41300700001)(6666004)(86362001)(6512007)(26005)(6486002)(107886003)(36756003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?S4DblGvbEr882mHy5X9ZsJw4tzB0dRcT9SKa9XklNvudOjTrbml0xy4qhlma?=
 =?us-ascii?Q?u0WjLprWzjc5k8z1K11erSy+ANITIsqg/oS+A3gXzA29ytIBa0UUiU5Xp4lL?=
 =?us-ascii?Q?5nnn34S6kNUS+TGeczpmwp/Ui0zgWAc0NnQFoKT+Abo0PKF/J1MhgAB7OP7u?=
 =?us-ascii?Q?VHzLG9/XNrI/Xb5juhpEJK1N3tAEhK7IDbVreuYJ2jqkVx629COHhW1PvbEO?=
 =?us-ascii?Q?Y3nE60HRlPzyfVn+xpfBizkYUnVV5DVMoi4QWrGYwmy9VxkGcSADNJk9ICiX?=
 =?us-ascii?Q?DimaZRV4IhhgBZVALHTYY1Q4M078VI1oJ+e2VGRnRS4tpqAZZXuEXii+9C3P?=
 =?us-ascii?Q?xc5wSBizscnXof7LmyIwOODmeFaA1dE7txWKc/2p0pqc9spO4L2w+We+1Yab?=
 =?us-ascii?Q?Y4Em2TjFPpqYAmixlE6RqvGsRcgtkANnM8WoPZaAvhPmbpGgLyM0KUn62+RR?=
 =?us-ascii?Q?7VvGnbo6crg0xatnX+syVgVeMMuC3Q29XqvZKmpQxOABo/aFdJF+87wtTsOU?=
 =?us-ascii?Q?ZrKQVfaTYSBJxZHu4hMqqw2RkKsDt0SYjM+xqS6D9iIp6JMk6NUoD8gzJoeG?=
 =?us-ascii?Q?a3Yk3t9G0rqgaB1BnapOVjlla+SzwofQZq1F2hfCmzER0KQ/LufdtX9nRghr?=
 =?us-ascii?Q?nBHRzn2f34eEwy1zyAEUL4eo2EgaN1NpcaQ6N7xTEiFmJ+M862YWucbd74M5?=
 =?us-ascii?Q?GKG43Lfm+T2uIwS2wuDtc/paLinSmpUiZkzsQS1MkcSGRfgFEIg8mPoRRAfC?=
 =?us-ascii?Q?AB4V19GavlZqof2lGuSC38lUBnVZsQUgqany++TBKlbVuKBKh6w5ndNfxXp/?=
 =?us-ascii?Q?8eLyDwz3p/b+nMCU6DBpHn5c8L2VSKixjxVeKYDDEtbMR0UbRIJVfUZBxlJp?=
 =?us-ascii?Q?uVEAH8OEcg78dIM/zZOSBnSSbkz8Zyg8DBeJQ0L2luFhzkuYI9tPds07RaDk?=
 =?us-ascii?Q?igHhqdmFrn318SsNQ3BKwBhIcL9lyF/E+bcxmvTOFb2QQlmfB6J3ZIuHlutf?=
 =?us-ascii?Q?QNcVeSwrNR4+mx67fW6RkXMKw0nyUZR04Emu1fCjoLol2LAh9J8ekPMESUgq?=
 =?us-ascii?Q?AcUhha7MdpiZZOAsakuc6lmbugzgk55E484N7Shfv+vw1oE5hZ1+ZHe5JwYp?=
 =?us-ascii?Q?JtdPC1nwsze9/MEicnuWi9Ms6g7E+HMTF2FAHqpkdrAs2t2GogttjCcQZJkg?=
 =?us-ascii?Q?Jw0BeXqIHH4QebuuGpDlFoyQlJCDVvED+IhH6eUVwwMHH465I4Drs/8mLElR?=
 =?us-ascii?Q?sZqM4KdQ9fLq33BSmE9Ge2QlyFEg/+Z88NvvMN3mXah8883xxwgQ3usY95NL?=
 =?us-ascii?Q?uVb94bHWvzQWakAZOmTBK9L99PQC5DJDysdtQ0uwzBVZvPvpPoXxctSadWT3?=
 =?us-ascii?Q?DeJjZBgcU03WIZDdxPaNDsS5ZsKsFP0zIHk739MzQ0klNWaU6vvZMFqeZJxM?=
 =?us-ascii?Q?wqOoNzo45cmPZr+A1yG1Zc+Bs+54vHewiP7qDW4I/ZfQJAtMw5dPaHszKBDX?=
 =?us-ascii?Q?/f1hUzjkiWsksBW1Ud6LkiBfY4YFXAAw0RKoFx+OfwbLUA1mQomJ8uWKrGMh?=
 =?us-ascii?Q?t6MqHAaJQES55njPhPWVDTbvdQy0C2SVbjIg68H09SVyfm94j2roj+r9dtHT?=
 =?us-ascii?Q?tg=3D=3D?=
X-OriginatorOrg: seco.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f0e92ac1-8766-429e-d481-08da9023867d
X-MS-Exchange-CrossTenant-AuthSource: DB7PR03MB4972.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Sep 2022 16:19:08.2713
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: bebe97c3-6438-442e-ade3-ff17aa50e733
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: kkXLY7daYZbDHi1Xg9qucyGmroFlmXWWhZ6Ubda5jBBDv80JWanfPmqqDoiwK3+HeNQDNL6G6WO1H7ZKBtOWkw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0301MB2254
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
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
index c5c3f0b62d7f..1f022e5d01ba 100644
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
 
@@ -391,9 +389,9 @@ void phylink_get_linkmodes(unsigned long *linkmodes, phy_interface_t interface,
 		break;
 	}
 
-	phylink_caps_to_linkmodes(linkmodes, caps & mac_capabilities);
+	return caps & mac_capabilities;
 }
-EXPORT_SYMBOL_GPL(phylink_get_linkmodes);
+EXPORT_SYMBOL_GPL(phylink_get_capabilities);
 
 /**
  * phylink_generic_validate() - generic validate() callback implementation
@@ -409,11 +407,14 @@ void phylink_generic_validate(struct phylink_config *config,
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
index 9bb088e0ef3e..c2aa49c692a0 100644
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


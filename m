Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DED966286A4
	for <lists+netdev@lfdr.de>; Mon, 14 Nov 2022 18:08:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238175AbiKNRIL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Nov 2022 12:08:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46912 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238169AbiKNRIC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Nov 2022 12:08:02 -0500
Received: from EUR05-DB8-obe.outbound.protection.outlook.com (mail-db8eur05on2062.outbound.protection.outlook.com [40.107.20.62])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2B6792F008
        for <netdev@vger.kernel.org>; Mon, 14 Nov 2022 09:08:00 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=a26raTXPYvVlSAZ9V+yZn3Um/2/qjUEu4uOXNGseqQ+5a8x6+QIH1oOWOCj1/L/TRsE5AbCq+Da3uGAEQSlKFP/IcMl+l0lqbJvo+vn/NPWNykzDny9iD+EBYmGqGMbYn5Voro8W3yeqthYOHiMO4ct+3hsLfhJpaFS66MO3pxf5/qHJM4oJ8vEHd/47WDWwjX9AzjCf+K+sn0BEr1S/AiGZy+QIXOxmHdK+wQH2UpXzJqcEqjrjM82kEPd7X/cQNwN44D/fGioXh2rDhyvNJaW1WSp+cz3fqoPhnYnCC2XEiRajSVSg6i3VWtZseQsrTgbEZ/v7KxF6UMvNcR0Acg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=O5bBYXRv8qvYIIaVAFYVISrK/jzDgZXjmSxu7zrv4B4=;
 b=FApb3HK2UV3uRXLKowbGNy+p4WcDdDl1BQXF9wauUH5gTFeTfLuLM/7U3HjehH2HSYiqkbLSnROuHhIKRs7JyvmJuW0YRUoNQZSVCRouFJHTIGgE4Lc7dVqL8TvnlnBLdecbBnAHTqcjW7J9QTrGiydb88O+bliscBJh2Bj5GtrucYx61HEEEI8bfpGFH2aSf7c0Ci9ZtuONL1Ps4iiBrmHgZchTm2mPjGpWL1KkgExL4Nkr1KrGUtnJa8sBwmvFwnv1h2glDiWp+5dMzqB6wUa3M3wsjjAxWu4AmbXMQpBMrv/eU+8rdvWt/VicKtKyDeCjEwJP0PnoLXVHj/kv2A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=O5bBYXRv8qvYIIaVAFYVISrK/jzDgZXjmSxu7zrv4B4=;
 b=NGv95hPQq1or5bnV1pKEytKSpimayWruwj9X3GR2PgyYEGI07yYesEp6/2hlXUuBFFWQ63u6C9qpS+RpXWNrAlvI1YhvubhyPzUwsA5Gb6/qay6cb/0KA/c8QbdzVV7nl1RdA8jytFHmuQOg5Aw8FiUVccnB2tg9l50HKoU7NSA=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by PAXPR04MB9280.eurprd04.prod.outlook.com (2603:10a6:102:2b6::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5813.16; Mon, 14 Nov
 2022 17:07:58 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::9317:77dc:9be2:63b]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::9317:77dc:9be2:63b%7]) with mapi id 15.20.5813.017; Mon, 14 Nov 2022
 17:07:58 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org
Cc:     Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        UNGLinuxDriver@microchip.com,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Sean Anderson <sean.anderson@seco.com>,
        Colin Foster <colin.foster@in-advantage.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Subject: [PATCH v2 net-next 4/4] net: dsa: remove phylink_validate() method
Date:   Mon, 14 Nov 2022 19:07:30 +0200
Message-Id: <20221114170730.2189282-5-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20221114170730.2189282-1-vladimir.oltean@nxp.com>
References: <20221114170730.2189282-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AS4P191CA0007.EURP191.PROD.OUTLOOK.COM
 (2603:10a6:20b:5d5::7) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: VI1PR04MB5136:EE_|PAXPR04MB9280:EE_
X-MS-Office365-Filtering-Correlation-Id: cfb088bf-bf72-44ba-fbde-08dac662c763
X-LD-Processed: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 8zfDPlttQO83oeEmKtKyG4UtDJvyTe8FjppZinNOeJmwdgfht3fV+ynmZnV3DWRRBJLCWnSWix/grq6oFGEhFxCQ+MfhZrTjYTDyrH83RqRV8e90ftJTdQvcwQOOW1Y5A4U7HQShY4/nVGaBaFDIAaxCKgPQ3gH1UWzc+lYin8vBHQY8ZHs+WXE+iQ4EpOBXmpNQIuUwvqPRKh8d04n8AVZj3+qVyy+b+Aw/A7CASxRfVuv780qCj1pk53JyVGvswvzrr/SNTRgGcGQmvMWkux7/fh7LrkOtKnGpbBWWXc2XWAOz5CuYV9O9AiJt9N9rYAN09Jk0IM/6y83sv99ULbtlDpyzFy2CE0JpJKQ3uvbjVHyWgX/yZCEmf2BuyKo+q+ReGiXyZSrwKPzKPFdDoRtvX+E2zeXFXgNLatb3T9Ql55Tu+qzyNQud8dHScsFQ01ercgGghnjuPqhZ3EK0J2v7Ij5hb0mo7JZn6jZyIOobcJsvKfQpcgbYZIdf1nyCFOWzDfe/v0yFYuJIRCBqoNxT+5YKnJlAWQYrvo8qK3/5Q/PuNUbfnRUQCzqpQR99blv1ZnsE0SLP8bvR/1K6ATJjijJ5uBk/kAhZyLtDw5EPMEcQW+nuw8MWDrEkpo7CZQdHu3THOsAJOqnHTzTQPFhypA9TXo7QNK+8gV/OoHnLVB4xTyDpuKwtVcr9GZm5KgYv5CCsXdkZrSEuTYMaZFMrc6wMLJhfl7miSkDpt4pHPYKTNMR1jMLBkPzkiKA2uL03bFYtvufBynF8xXgGaA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(39860400002)(396003)(376002)(366004)(346002)(136003)(451199015)(44832011)(36756003)(7416002)(6512007)(5660300002)(26005)(1076003)(6506007)(6666004)(2616005)(86362001)(8936002)(52116002)(478600001)(6486002)(83380400001)(2906002)(186003)(316002)(66946007)(66556008)(41300700001)(66476007)(6916009)(8676002)(4326008)(54906003)(38100700002)(38350700002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?p6pjgWB0sU0+sZfIc3RrsDpH7/McLreJfkLCaxD0iLFgdwwjqGuy2nMyrEVF?=
 =?us-ascii?Q?VlmMI3Of+v377Bke68i6aCPSHYzlbRmHJujQgzokH0yZSkhy59XevX57qQ+w?=
 =?us-ascii?Q?kTjPQ89o/h8a0LXVZ6A6FcegnRdGHQ1EJrUIAGJy0LaJJPiZcpllhCIGlifF?=
 =?us-ascii?Q?aLipljFizhZi5tNHF+ocmrj8HzLhadVcrDh1sJ+NZiOuvYK7CTFRiS8ZDVD5?=
 =?us-ascii?Q?20ODHJZYs1P1Kht+OGCf5eAhrxXHyiLPx++xYHWe94aUMXK1d/htR19oPhi3?=
 =?us-ascii?Q?GWVV5/JB4A/LYYWA4XswJayqNFUXp1axK9hytW4rix88Wvp+OtAe25gUSA0s?=
 =?us-ascii?Q?MSg3gVPzLZEB8rimeh/EiRjAQmmasnmoDhrrk5u9y3u4xbyW202aQRenzUPe?=
 =?us-ascii?Q?kn5D+z2nvEIXYaFfdbM5GwnrHQM+xL5SmR6g3sJooEIa7wtxVL/bKr4wDmDd?=
 =?us-ascii?Q?gFh+WMcu2JPBPYIyi9UCtHNt+1w/M0z4fmlj47fqNvDiDspd0mC3ZTS4vJVE?=
 =?us-ascii?Q?P+m1yACvUR/ccK7FJBsdf6JaS2hlquBV4zMfZP/6AiKam4I8QzcmZ8JvbFEg?=
 =?us-ascii?Q?fh3giavAnvwnJH/fzH80E2uuWuajjxu0I33lLYFzecKSvQtDZyztLL//H46P?=
 =?us-ascii?Q?9rhLgIHIdrTEeMqD5DAQ2/rVBHIWzr/1GeGWgxGsZcv1sP5PmyVd8h/kUhLu?=
 =?us-ascii?Q?kMK+hyFvPATStZ0ZzCyoDmuZ4Kfoi91k+fywcUjlcigAJaIxf2iPwMgzAyiN?=
 =?us-ascii?Q?Rtqqp1SsG1XP7dSLxsD1O42EQlDQdqqPcxjPvUkf8ENDzDIwHCf3Z09MRCyw?=
 =?us-ascii?Q?kqe+n65rRNxUqev8nPIMbvG8IyMjaHtFKlfxsQVjgZXveRL5tdEtNaAW1+M6?=
 =?us-ascii?Q?RAMR1peASq190PKaqdaexMsVFozHOtpOJQ/2rB1V1hN/MSD2MLmdZlQGKENu?=
 =?us-ascii?Q?hatGCwRTfP27GEYF7sLKzXEw/hoCue/jORNnQRx1oVXxyWqJJXsnGEUwgxBK?=
 =?us-ascii?Q?79MJX9OvZLx5O2yUnnkfydcnUnyE8GGzikOvrIC1KsCxud3ixOfmwN7ED2mP?=
 =?us-ascii?Q?8BSR1d+vW1xE2DVT9LDhFLdd13Pn2rpafaH2MiIslLfoXjw7/EGYToIarCmd?=
 =?us-ascii?Q?zYSFaTl5PJ/ce7ZwdVZDlH52tJXW2JG3sF4L/8WXd5a4fWnEiHrGhHKSR7qM?=
 =?us-ascii?Q?JLL0d4s45cmrrweaN2380HQe4NjWsQOEYnr5qH512UM/69t+rwLyz01Lm0bu?=
 =?us-ascii?Q?jJqnGALojDuLfZGxIuuxSAfK7Qz/ruxHuOC9OwmdrDM3fXwERzT1EgKlOBZ3?=
 =?us-ascii?Q?cFIv8pQfvgcTOugtP2GcsT+ahoNhkNF7i9YzzQWb+D6TRu38nKfHOXTxLNbt?=
 =?us-ascii?Q?vwNLoj0sldSq9OSsFWQG/UgAvrJgvkr301iU0vCelNXJgafpbUvjwPmKqM4I?=
 =?us-ascii?Q?jRiIYy08g6HrMB6/oO5KAwI3+uW5aQv+BcNwa/BJ+6D/vFqVn4vFMPrHlUnA?=
 =?us-ascii?Q?dQ5gfaPq/PSdFlesjrPgUJfLDxUyJelYH/QojMjkhGpSQ3rh5w160mksPkW5?=
 =?us-ascii?Q?2jv4QAIbfUAWMTSoECGUA7egLE167GAfSxgmkJkTSvuMhyy9J8xC0bgXe2DW?=
 =?us-ascii?Q?rg=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cfb088bf-bf72-44ba-fbde-08dac662c763
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Nov 2022 17:07:58.2222
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: tlqcp92WC3MRXjNnXmxOQkj7XtqJYt9HXRihAWU+Dcjwmvt7He2989/is4EuvWljtCvFaTvL5nHq+Gki8wl/Hw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PAXPR04MB9280
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

As of now, no DSA driver uses a custom link mode validation procedure
anymore. So remove this DSA operation and let phylink determine what is
supported based on config->mac_capabilities (if provided by the driver).
Leave a comment why we left the code that we did, and that there is more
work to do.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
v1->v2:
remove ds->ops->phylink_validate() but keep dsa_port_phylink_validate()
as a no-op shim for those drivers which do not populate mac_capabilities.
Eventually this will have to go away too, but it's outside the scope of
the current series.

 include/net/dsa.h |  3 ---
 net/dsa/port.c    | 18 ++++++++----------
 2 files changed, 8 insertions(+), 13 deletions(-)

diff --git a/include/net/dsa.h b/include/net/dsa.h
index ee369670e20e..dde364688739 100644
--- a/include/net/dsa.h
+++ b/include/net/dsa.h
@@ -880,9 +880,6 @@ struct dsa_switch_ops {
 	 */
 	void	(*phylink_get_caps)(struct dsa_switch *ds, int port,
 				    struct phylink_config *config);
-	void	(*phylink_validate)(struct dsa_switch *ds, int port,
-				    unsigned long *supported,
-				    struct phylink_link_state *state);
 	struct phylink_pcs *(*phylink_mac_select_pcs)(struct dsa_switch *ds,
 						      int port,
 						      phy_interface_t iface);
diff --git a/net/dsa/port.c b/net/dsa/port.c
index 208168276995..48c9eaa74aee 100644
--- a/net/dsa/port.c
+++ b/net/dsa/port.c
@@ -1536,16 +1536,14 @@ static void dsa_port_phylink_validate(struct phylink_config *config,
 				      unsigned long *supported,
 				      struct phylink_link_state *state)
 {
-	struct dsa_port *dp = container_of(config, struct dsa_port, pl_config);
-	struct dsa_switch *ds = dp->ds;
-
-	if (!ds->ops->phylink_validate) {
-		if (config->mac_capabilities)
-			phylink_generic_validate(config, supported, state);
-		return;
-	}
-
-	ds->ops->phylink_validate(ds, dp->index, supported, state);
+	/* Skip call for drivers which don't yet set mac_capabilities,
+	 * since validating in that case would mean their PHY will advertise
+	 * nothing. In turn, skipping validation makes them advertise
+	 * everything that the PHY supports, so those drivers should be
+	 * converted ASAP.
+	 */
+	if (config->mac_capabilities)
+		phylink_generic_validate(config, supported, state);
 }
 
 static void dsa_port_phylink_mac_pcs_get_state(struct phylink_config *config,
-- 
2.34.1


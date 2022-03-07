Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D73A74CEF7A
	for <lists+netdev@lfdr.de>; Mon,  7 Mar 2022 03:13:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234799AbiCGCN7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 6 Mar 2022 21:13:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54870 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234723AbiCGCNn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 6 Mar 2022 21:13:43 -0500
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2104.outbound.protection.outlook.com [40.107.93.104])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E077C1B782;
        Sun,  6 Mar 2022 18:12:35 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=NcqwAtXX2hb4JSH7UJjsMDBJABvkl/8g7tLuiVLuGW84XAVvdHgYutkAPkQvIwnL8MsO9IQ2o9ICrYCrrkc5M92Tp2xUG47P5I4wP5vFo7kumLJFM6EDLKWWhnqkWwVeUpo+lshlt9UIadz/uR82F2L5TXzTHMzYTYrCFstM77ppm30V6fJZYi76AL7/LnOMR2mOqrjhZpr2KK0L/MlKg8gEG9D0Ge0+tnMidXBSZdKCdi+9y+T+mASO/vA+0xWfQPW15eqIrnlLMWRjGefTn65nFbNxMUiYYgQz86CVm+SwBnTxA3f9N5myUThlaA6cStRu6IAkCy8wRr+aGlzpOw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=QV657+McWv/jnkwNJ2N6k6LOi6WxEwlFpgFimBh2Edc=;
 b=G7GMtZw+xFQxx41Otf+oiEeklCOOCIS3+OnrjjTMtm/xA8TkL9Sr9w5Io7norInwBdeqHN6A9d5an2ps4OCFOk6n+e82Pl6ny2gup932FGaqdhbDajUKlcmaJ33gTgKwa0v2slhDBxLfJQvGi6K1Nu4LlEg/bmltwhWlBfaL44+Rf0L2kTwtbae0+I+fjYXRREi6+QybetbQgVHZhWLujXwJz7xIhRwv33jRv2wFW4bbyJL7DXWEfD1uPTqAxBdpL/LE2obP4HME5gIklHQU7ypS/93jrBTtRJsEHZTFR0HRajacUWE/2vPu1fFxGzPLEY1uiowWDTjfmnXo1XW8fQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=in-advantage.com; dmarc=pass action=none
 header.from=in-advantage.com; dkim=pass header.d=in-advantage.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=inadvantage.onmicrosoft.com; s=selector2-inadvantage-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=QV657+McWv/jnkwNJ2N6k6LOi6WxEwlFpgFimBh2Edc=;
 b=cag7A99YJnEqO+NeR9sA7Ep1mBJ1LKh1AoKDD6e8Pc8Ob7iHgBfg7+J9kk5tcK6ksOXqamA2JknvmGFdrtfWPdZTAo6WE6zbLAq7wbAPUoToEBCAgnKv4w/gI+x3wZ48+TdWzHnS0gI2rW9vN8zGT2U8cws85EsGRQLRL6ToZas=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=in-advantage.com;
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37) by SA2PR10MB4553.namprd10.prod.outlook.com
 (2603:10b6:806:11a::12) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5038.14; Mon, 7 Mar
 2022 02:12:34 +0000
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::7c:dc80:7f24:67c5]) by MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::7c:dc80:7f24:67c5%6]) with mapi id 15.20.5038.026; Mon, 7 Mar 2022
 02:12:34 +0000
From:   Colin Foster <colin.foster@in-advantage.com>
To:     linux-arm-kernel@lists.infradead.org, linux-gpio@vger.kernel.org,
        linux-phy@lists.infradead.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Marc Zyngier <maz@kernel.org>,
        Hector Martin <marcan@marcan.st>,
        Angela Czubak <acz@semihalf.com>,
        Steen Hegelund <Steen.Hegelund@microchip.com>,
        Lars Povlsen <lars.povlsen@microchip.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Vinod Koul <vkoul@kernel.org>,
        Kishon Vijay Abraham I <kishon@ti.com>,
        Russell King <linux@armlinux.org.uk>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>, UNGLinuxDriver@microchip.com,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Lee Jones <lee.jones@linaro.org>, katie.morris@in-advantage.com
Subject: [RFC v7 net-next 11/13] net: mscc: ocelot: expose ocelot wm functions
Date:   Sun,  6 Mar 2022 18:12:06 -0800
Message-Id: <20220307021208.2406741-12-colin.foster@in-advantage.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220307021208.2406741-1-colin.foster@in-advantage.com>
References: <20220307021208.2406741-1-colin.foster@in-advantage.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MW4PR04CA0174.namprd04.prod.outlook.com
 (2603:10b6:303:85::29) To MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: bcb58d44-21cf-4ddd-3413-08d9ffdff11a
X-MS-TrafficTypeDiagnostic: SA2PR10MB4553:EE_
X-Microsoft-Antispam-PRVS: <SA2PR10MB455366D55BB5E2423479DF59A4089@SA2PR10MB4553.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: fB2L3UsvvrqnvMtJRDSDRNzD7sFecpUEaHxKi3XaZ/tNLG2ZmITYuCCECTsxp+W10ZzbepEe1lkMVrx6jZUFe3TlRmULDd0Sh4YKY/3HonJ0ZlTYMjUrA539F+PByAzufAmy0gFMTXMRBX1//npg00AATI2DlmfbjpbG8NcXq316TAudPJBBRKUfpEXqrO5xMmoIAsPbA0KVCiO5eSFHQo03D445xqltAi57y8HLXUhNLmkjzfeWlx0JxCiVP+sOUJNxyAEOMPROoE5y8IhUCRVYFEXNEldFtCEiJu/D4mHmcn+E8nQ+iYQ4SJyhf2L0PZ6rsVv+RwRLl7hsQztcImsQgFYTwkOWsFX7ox2tNeu08hXGKAVAlZliq79vrtOLWn+oWGS7BpDWEsr+G8nUItsTMglUe4KGzoTs6VhPKg/83mLgre8rXTCwG/t2Vw890BRAgmRORdJFjHNZ2FQCsPOyHrvTbQWjxs/yFB7ZI9W45cD/gOkUN3aYuSQnWuyc/5ZfzULqwDZpq9A8baJ88wQtGgC3zK+US2CKiA/P84sduhuTWxmBb5+ED5N5vrt/Vzz5Xs/4orUSR6wLuU6bBbDt10lVVdG3pUyQL6XEBf1crUaFHjQxS8lKdjL7RCLfrB3I3sCT3KYGhtQtxDRzsFl95EBEJ5yf8tdrAYpp+tZgVzbs9LEBV7AAOcUorIPfNOMm40wN+NhI8TRhfRfnDA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2351.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(376002)(42606007)(396003)(136003)(39840400004)(346002)(38350700002)(86362001)(508600001)(107886003)(38100700002)(6486002)(54906003)(36756003)(44832011)(6666004)(6506007)(66556008)(66946007)(4326008)(316002)(66476007)(8676002)(6512007)(26005)(186003)(8936002)(83380400001)(52116002)(1076003)(5660300002)(7416002)(2616005)(2906002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?upyFk9vehWOVYLjzr75yjMUu4GV0TVcy+tD0FXHJTSzfSCdZrALoALztV0Zl?=
 =?us-ascii?Q?lMP9SFBrOSHOgDipSLTXu+nSBWp15niWwnxHYYKBmyYBJXGHDs97zv/c7UYs?=
 =?us-ascii?Q?Wcl+4Esu6Ne3tMipYyGFhs6ofDpo7OLqHi+wdcn4vgkTHOUa0jHm+amB0hsW?=
 =?us-ascii?Q?ylOLo5nZ60+qZLztkkOXbxZHidy7e75/3qbq+GxCe9cF4UToFSdcl/fX7cdL?=
 =?us-ascii?Q?nVniYpucAse5mMJ47Q0Y7hx/Y28NQN6UJrt755khmKNhSRlfGwnHNQwEUqUD?=
 =?us-ascii?Q?TWljCdxYZH77+bOJFSBNdBKjVb8agSlb+XK66IntjdfKDg8yS4ApcbG127oy?=
 =?us-ascii?Q?0FaXFIMXYRGrLQT4HgmdRtGAkqdItGHb9SGoLXm5CnlIk/gv3r+cBJvdPRXQ?=
 =?us-ascii?Q?ySO6Z7E1JX3EA9TeSDFq1PhkbdOSPV/4TgWVWnSklVhYLnDcpWK+aCGdb+d9?=
 =?us-ascii?Q?04SRcAuJCXfVnd88aA6/Ne+RMkr0deHsUzKm2hWlhAq/IIDVpuuM7sG/EplJ?=
 =?us-ascii?Q?xM1ci9rtJsDUpCQ9KJfwiSeNvqWszWjXCzrW/twDcABwSD2FFU9Z0iVVBsIP?=
 =?us-ascii?Q?j+F2/rbRn4wk9+jtUGGxys1ake1wTjh8duFV70pXBcqa4DxbcHcRkZf/6nat?=
 =?us-ascii?Q?9O2BYwAT1KC2ah/8f7q5OaQodWfKaZkSN/8qJd3XbgYQ2fCdNfPvZHQVC+mJ?=
 =?us-ascii?Q?DRooKUAJXnpQqwI0hTq7SGa6vEvsGT1W01UtbKOY7UXCLuNuJ+KPqTB71UnY?=
 =?us-ascii?Q?dcxl7FJLKMYqk8gZI0W3fAaeUGXoT1uH2mETtiY1X0avvyzgrz7z2yYVejFx?=
 =?us-ascii?Q?CwanG/J0hNXzAzWv+G9Hez98S5Eo35XOoo91YMMdPssNlNOueBqOZjtu3amW?=
 =?us-ascii?Q?FuxLVO2tZfcP6JJjls+4z1GjiVMYQ9/WAS6TW4L+KkTctA0t2MW3fgoBNFAz?=
 =?us-ascii?Q?jRQdmWYFENg+4nxqpbTI9YazDrzl4r8vfWNP67eZVoNiZ+cPZIPORqLLf6m8?=
 =?us-ascii?Q?jcHSnTeW5VSJ7KzbT0rjGW5BQHY9MNKWt3WRm1PNarb7o4L9DRiTJ2ZXT5JK?=
 =?us-ascii?Q?tzWEC7SMBF/mxUYhAPcFjfEv2N/8Ckt8aM0phquGK4kILsJdVVVZia219Cta?=
 =?us-ascii?Q?/ai3chxR9Cp54NHdZ3a/AS9QS54kZcIdiu9Qqgsy2p1noRR/mSfS0g/yqwxd?=
 =?us-ascii?Q?p8cHib+lCuMlHemDW6X5oB6/O7/hNkkVGry9vbXnXsCx3ZmrDH0PaPPUU0Qo?=
 =?us-ascii?Q?rs8Vx/OlNFYKrz1djjacVU7LWzMdOtHjt5qMP93xH0GuLobFqXia/6lfHMxM?=
 =?us-ascii?Q?7vquopFAeBUtSLQa4xC9nZEJ3KRZuSJNTlg3jrE0mlYKhyAUnxq9//mzlshX?=
 =?us-ascii?Q?tfYG810TVKng0lKwooKQCVD4se1xACLAVYTcFAFthELAHqMzENmNYD47UVYP?=
 =?us-ascii?Q?mKr1z53zkg+eXuNq6FQeo/H5CLTl5tOEa9AYIoa6DAoDwNmihFk33FiozwyT?=
 =?us-ascii?Q?Cnlj82a3ZRr2XuF6+r8NXfi3TZ+xV0Ct3TsUobhTjKGnsKb4xxHLri19Qbpl?=
 =?us-ascii?Q?IP6J3u3YYjVmnedldd9mMY4Wb/RpogO80QzmtXJ1y9h4tXEdQI0dhDjYHyOp?=
 =?us-ascii?Q?ckmoH89JmxciSJz45LETVHhPFJ8gvfzM9lYjqbrEWC9v3C1j16Th4nYP/BdW?=
 =?us-ascii?Q?2hPVEuz+puAsXpAjphormGE236o=3D?=
X-OriginatorOrg: in-advantage.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bcb58d44-21cf-4ddd-3413-08d9ffdff11a
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2351.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Mar 2022 02:12:34.0108
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 48e842ca-fbd8-4633-a79d-0c955a7d3aae
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Ph5baFsXgvpnijCRV9N4Zk0RCZTjdHJVhuyItKoz8bnWHlUU9er4qBhFad02DpUSc5AGnxyYL0224BHn+id+UpCV6KjnQfbwxY5QyVqfzsY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR10MB4553
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Expose ocelot_wm functions so they can be shared with other drivers.

Signed-off-by: Colin Foster <colin.foster@in-advantage.com>
Reviewed-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 drivers/net/ethernet/mscc/ocelot_devlink.c | 31 ++++++++++++++++++++++
 drivers/net/ethernet/mscc/ocelot_vsc7514.c | 28 -------------------
 include/soc/mscc/ocelot.h                  |  5 ++++
 3 files changed, 36 insertions(+), 28 deletions(-)

diff --git a/drivers/net/ethernet/mscc/ocelot_devlink.c b/drivers/net/ethernet/mscc/ocelot_devlink.c
index b8737efd2a85..d9ea75a14f2f 100644
--- a/drivers/net/ethernet/mscc/ocelot_devlink.c
+++ b/drivers/net/ethernet/mscc/ocelot_devlink.c
@@ -487,6 +487,37 @@ static void ocelot_watermark_init(struct ocelot *ocelot)
 	ocelot_setup_sharing_watermarks(ocelot);
 }
 
+/* Watermark encode
+ * Bit 8:   Unit; 0:1, 1:16
+ * Bit 7-0: Value to be multiplied with unit
+ */
+u16 ocelot_wm_enc(u16 value)
+{
+	WARN_ON(value >= 16 * BIT(8));
+
+	if (value >= BIT(8))
+		return BIT(8) | (value / 16);
+
+	return value;
+}
+EXPORT_SYMBOL(ocelot_wm_enc);
+
+u16 ocelot_wm_dec(u16 wm)
+{
+	if (wm & BIT(8))
+		return (wm & GENMASK(7, 0)) * 16;
+
+	return wm;
+}
+EXPORT_SYMBOL(ocelot_wm_dec);
+
+void ocelot_wm_stat(u32 val, u32 *inuse, u32 *maxuse)
+{
+	*inuse = (val & GENMASK(23, 12)) >> 12;
+	*maxuse = val & GENMASK(11, 0);
+}
+EXPORT_SYMBOL(ocelot_wm_stat);
+
 /* Pool size and type are fixed up at runtime. Keeping this structure to
  * look up the cell size multipliers.
  */
diff --git a/drivers/net/ethernet/mscc/ocelot_vsc7514.c b/drivers/net/ethernet/mscc/ocelot_vsc7514.c
index 4f4a495a60ad..5e526545ef67 100644
--- a/drivers/net/ethernet/mscc/ocelot_vsc7514.c
+++ b/drivers/net/ethernet/mscc/ocelot_vsc7514.c
@@ -307,34 +307,6 @@ static int ocelot_reset(struct ocelot *ocelot)
 	return 0;
 }
 
-/* Watermark encode
- * Bit 8:   Unit; 0:1, 1:16
- * Bit 7-0: Value to be multiplied with unit
- */
-static u16 ocelot_wm_enc(u16 value)
-{
-	WARN_ON(value >= 16 * BIT(8));
-
-	if (value >= BIT(8))
-		return BIT(8) | (value / 16);
-
-	return value;
-}
-
-static u16 ocelot_wm_dec(u16 wm)
-{
-	if (wm & BIT(8))
-		return (wm & GENMASK(7, 0)) * 16;
-
-	return wm;
-}
-
-static void ocelot_wm_stat(u32 val, u32 *inuse, u32 *maxuse)
-{
-	*inuse = (val & GENMASK(23, 12)) >> 12;
-	*maxuse = val & GENMASK(11, 0);
-}
-
 static const struct ocelot_ops ocelot_ops = {
 	.reset			= ocelot_reset,
 	.wm_enc			= ocelot_wm_enc,
diff --git a/include/soc/mscc/ocelot.h b/include/soc/mscc/ocelot.h
index d9e2710d5646..480bf21da404 100644
--- a/include/soc/mscc/ocelot.h
+++ b/include/soc/mscc/ocelot.h
@@ -852,6 +852,11 @@ void ocelot_deinit_port(struct ocelot *ocelot, int port);
 void ocelot_port_set_dsa_8021q_cpu(struct ocelot *ocelot, int port);
 void ocelot_port_unset_dsa_8021q_cpu(struct ocelot *ocelot, int port);
 
+/* Watermark interface */
+u16 ocelot_wm_enc(u16 value);
+u16 ocelot_wm_dec(u16 wm);
+void ocelot_wm_stat(u32 val, u32 *inuse, u32 *maxuse);
+
 /* DSA callbacks */
 void ocelot_get_strings(struct ocelot *ocelot, int port, u32 sset, u8 *data);
 void ocelot_get_ethtool_stats(struct ocelot *ocelot, int port, u64 *data);
-- 
2.25.1


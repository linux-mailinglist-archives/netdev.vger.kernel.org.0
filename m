Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2E538526B00
	for <lists+netdev@lfdr.de>; Fri, 13 May 2022 22:13:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1384078AbiEMUNC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 May 2022 16:13:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53646 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1384076AbiEMUNA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 May 2022 16:13:00 -0400
Received: from EUR04-HE1-obe.outbound.protection.outlook.com (mail-eopbgr70041.outbound.protection.outlook.com [40.107.7.41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C5CEB60D99;
        Fri, 13 May 2022 13:12:58 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fmk4DPOlLTEXR8+mXghkFDVCgHy7M9I/cBoqRiVwj3Paj09YqWz6TIqlr8tsbJLpefd+WcLIs5vLX6UF/daArXvMCGniqlPy5d82KsNCRfm3TKilX2XSsugTpZaBVeKxSBBETi8STXTDLJAaJ+SxlqnXDKAQGe9RpCNhjCpwlrXsx55qDLkTobT1ypo2raTo46B8P7ouB8c9da4ukH0jFDyHyzQwCjmzL68EeOZUNjOtNjbEX3dzjiRtR5PjUeydlr9674XXkP2nD/D52e/Lh9qIY/EVhMCLvd3dn59IrF+ryqhkC/HTJI17nVofcxw2ei7p9ilOjOyWiklXG4ul5g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=snZeiLRYrHnKS3m1GHZZMrPgYYZIUSSsjrBcXkVBIlE=;
 b=AEX+w9EQ0feyM4zozHQXgVp7QJ63cqAnV3As5JOSWybyPjSS3lfIPe/g7+GqkUIpEtZtOGBV1muOfRBqRQrpJtUoV4eumYCG/NNCMlV/gU1uY5E7FMAS5fwPl7IUqI2DmE4awIUzTqBUSslisGX17c1uLvFWhpN9DrqiLyi4IfADBAaIcrZ9bXXYAfZbeZTYOf80oubWycB9vdbVYCTkadCv6OuVvOlGi0X/ng4TWHolueB9tMUMKh6GxCvHdIIlv0ACurpLndp6sxylo6YRUkNijtIEQlC/wvpJm77pWW/i7r2mNre2rSjF7rt3cIBUiOqc2NCj9/G8uMS6Zw1bGw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=snZeiLRYrHnKS3m1GHZZMrPgYYZIUSSsjrBcXkVBIlE=;
 b=mmvwpOdJOUusWHYkPZx5l9WDVJFhR84/kd+7z7mAd03/mBYZQxe1JX3mSrL1O6IL01f6ove2i7JOiTuxgYJKvL6XqkR/9fwExsjQEACreioISBkyqC6pHthjxf7zaMocHQkHWDNB+T1xolbcuBWveMWcBtPfYI9EfcG6mw4S7hE=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by HE1PR04MB3194.eurprd04.prod.outlook.com (2603:10a6:7:1d::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5250.14; Fri, 13 May
 2022 20:12:55 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::fd1f:cc16:dafe:4bf5]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::fd1f:cc16:dafe:4bf5%5]) with mapi id 15.20.5250.014; Fri, 13 May 2022
 20:12:55 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     netdev@vger.kernel.org, Saravana Kannan <saravanak@google.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Rafael J. Wysocki" <rafael@kernel.org>,
        Robin Murphy <robin.murphy@arm.com>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Rob Herring <robh+dt@kernel.org>,
        Frank Rowand <frowand.list@gmail.com>,
        John Stultz <john.stultz@linaro.org>,
        =?UTF-8?q?Alvin=20=C5=A0ipraga?= <alsi@bang-olufsen.dk>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Russell King <rmk+kernel@armlinux.org.uk>,
        Heiner Kallweit <hkallweit1@gmail.com>
Subject: [RFC PATCH devicetree] of: property: mark "interrupts" as optional for fw_devlink
Date:   Fri, 13 May 2022 23:12:43 +0300
Message-Id: <20220513201243.2381133-1-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM6P193CA0050.EURP193.PROD.OUTLOOK.COM
 (2603:10a6:209:8e::27) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 1a778e81-47bd-48ad-2f4a-08da351cf75b
X-MS-TrafficTypeDiagnostic: HE1PR04MB3194:EE_
X-Microsoft-Antispam-PRVS: <HE1PR04MB3194ECA781DDD372F8625358E0CA9@HE1PR04MB3194.eurprd04.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: OWr3rPQXqTpfyQNqLHwjlc+NJ160MNAfQxXEW3YLX6Fl3dIvahrOZJu10CiuY+nP4ELlfTdd0d9DiUfyvxf62eEDK5N3H3tx3jcreWTkxxOWUfawbeSlNIIywHw6+0OsHOjQz8HcmUjEiRUcl6RPxgnJami6lrxKOGBelr9BDV5VZUuz/eOz5fid7ipabXTyQcwrfGNl/LlRXg6EtTzvKs+34W/9e79N9KWQRNprN2g1wxwSbEsGw6DWlcvZTUVLESdSGw27+/kGqqlBNhchoRI9uIsTt+ITQtiR45jTvmBwB+T7WMGZC/NyuClK1vM2JeFtp8I1wWu42MInNG3gUNI7D5lP9Nihd+fPzsx9M8Q6nkHaw/NUC3ZOpGeeXaMFpK/RlHIrnA+EML1UkSuXODerav7GoYzTwWs0riiV/h1TEBtFO0kcsWbyEvQbXt9qv52IPo6IXUJ8J+C8duLCODvtQ63qhsRQu5Ue796r2qrzS7nOqh4MtZ3pDLIziTkMZjVlKYhpL7mhCGXEbILZrkn4xORnd62XKPFryhxF+gq8c6s2tLmMhqJVFXWDH8iPzBUMny/6/dukyo8pdOOM6EH75JiLPtDFxM4tkRdDGSQkqZIm+irt3xHfCdz/i2H8M27PczdPVY2I6DZE+4G/H78LnnBIFC3RPprpDmPjHj7cQ/shGOmA972Jf/pDY2jUvkEQL3m6msFyXAPrTw2vOpcMuuqqYWcsVgyhAgN92DxRiCMO9cCLLaAc9d4oGvg/NSNKnWYczIeFUMcU5QtA/dx/yQy73A6fOp77mo+ZutQ=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(186003)(26005)(44832011)(38100700002)(6512007)(508600001)(36756003)(83380400001)(6486002)(8936002)(8676002)(7416002)(5660300002)(38350700002)(966005)(2906002)(86362001)(54906003)(6666004)(6506007)(1076003)(66946007)(52116002)(4326008)(66556008)(316002)(66476007)(2616005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?eU2VNQ8MZNXUWLdGHhDnsCFEtVfUfw4/u+os5sG723tN0/GCCTZkkhYt2v3p?=
 =?us-ascii?Q?dNwU+Q8UCeMT2gK9Em07Mdi9wP3DcA99G43rLwvEzPCTRkTOXjQJ1fLIhsEX?=
 =?us-ascii?Q?NtuNDL2ND0rDLnXi/LmDssuIFOw+oYuq034M9STYGYbhrRVn1YdOtbSAtkqI?=
 =?us-ascii?Q?HWPiq5ykgYwaJuMH1+BCuqzV2/A6Be4+oqC6S1mtLpGRjT5hDof7nTYXp6pc?=
 =?us-ascii?Q?GkacjWxNwPvDLOITShUPzmp+AlHg5o2wu0er0idPNqPgT2mqM3kpJjPxibg4?=
 =?us-ascii?Q?1+4ZkfHwk44cFrjxxrknjjWLgnpyO5yuA6uzQ20qtefjG3cky220rpH2BnL0?=
 =?us-ascii?Q?ka3bgR+7mRkiBm1+BZTvg+N4itD64VMck8Rpc5XcoFCg04v4b5o9X0QeKdCN?=
 =?us-ascii?Q?QDINRFNMP1aN/NxdX/6MigSHKkj1cnh758GzDxhEwMJO9VMpXsXdTp2lGieO?=
 =?us-ascii?Q?yUA5BnLN+GVW70baUjVQXzjE4XNj7JBfFdnOzD4skYEEUqAZgSXlMipWXs0H?=
 =?us-ascii?Q?kS7Z/S2TRyTHeyEZ0QQwetpUIcidic6J2mFrxBffH4LDqH4h2nDsmrTXO/mw?=
 =?us-ascii?Q?yyNBnn4y6TWE+T6pFCxNk5ohsPFuiDYue82hHBMRhFAbohHEcQWy2OHGXg42?=
 =?us-ascii?Q?x2p8IXUp2IeFD3dmDE++2XvCVcKjb8sC+m1D7PGZdioDif22YPkHelPUMY6C?=
 =?us-ascii?Q?bbivJ/HMU/ZRZFRtbS69U64yqLZLXUP8vHEHsNlCi4ExaUMDohvxt11N+8ae?=
 =?us-ascii?Q?9O91RITCbZ47x2vwXhKEHSFWwr7DAPnTiiIpH6dKoWbFhSvjiHjNeiFUrEpv?=
 =?us-ascii?Q?ZG/Czo5U+i+bbrlsgoOgVc+ye3JRWP1BiSuOY3aMKvuYU6dtIhOugPj8hBNa?=
 =?us-ascii?Q?5Whng+jLdPB7YDSjy8PYcJRolKGI760ax66ERTw2CCJwr8Mjxpykhhf3FMyu?=
 =?us-ascii?Q?4QulYjG9F7uxXhdkvCdTS1EtE3x9eBp8brZtxaHi4I9kFtjUea5hBoi5iOfv?=
 =?us-ascii?Q?bgB05MJos2X46tG53HtiYcblGxsLghRrSd+aX/qen+QKZ3U42sDwKqPATp8H?=
 =?us-ascii?Q?SglQurr6dynRr9blMFFKGpvQsBOP9E5hwqLjVVmiDwVb4YeXTc3yYrY1H/fL?=
 =?us-ascii?Q?x0l5qldHWulK1WBmAiSG3DeSUsUk34Liqm3Wnrroe9RlU6JiUS2m/soiY5/T?=
 =?us-ascii?Q?KfRLyNSAFCuh2bcrdqFzuLtNoUTiADiHFmQ3vIwo2PWhXbqtytRwI2Ud8np2?=
 =?us-ascii?Q?YA2w8RtAty3tu43AhVXCZxVhhffnSy+JU0VnXsu1bx1QnQTSfwhKcAWC7wk8?=
 =?us-ascii?Q?geuBKVt4WimHj/4ucux4QomcHg2rre2xQc0SXVTiYZXSBhZyBPLbtb/K5IMz?=
 =?us-ascii?Q?5BbGGI9ZwmrbSdW0vvWbWU/Du/yR0PzPqqywq+QPTEW6AnbZvG1Bxoor9135?=
 =?us-ascii?Q?npLviXP4NAuPITuC/hqQonM8+hvoc9PT2A87I7R+KtwECaKy6C0+UHUog5vn?=
 =?us-ascii?Q?EYlIWq6RaNnbtGEGD/O3jLJusz+kfYHAmrz6KQioOaBXG0GEpOGhYevsLNEX?=
 =?us-ascii?Q?b6QBKp3SL/KsZK/HPgn3aVpoVHNjdOgJvtFAi9J/buMZdVMd4+xdY77vM3OJ?=
 =?us-ascii?Q?qUWa7Ue34DijNt9YfgLLvdRYcQV2w1Lf8lW2wUUfc49PEhb+I3s0C1iE/oG0?=
 =?us-ascii?Q?isNEzUX7cyspu5MNh7+dJwOXCqSA9Y3DNbSAPHDgVVVM4oUcaTXmOhEEe7Pe?=
 =?us-ascii?Q?pCqyEFvORRd19OFNHszxS8bhRGw2lmU=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1a778e81-47bd-48ad-2f4a-08da351cf75b
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 May 2022 20:12:55.4307
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: zWTav9cjENqEbEiPGC7uw63PRvhNOhutMHdNnthjHNawyAK4pI7rUq65Jd/BIWJpNfO2V2LwdI/8/8qQ2yro1g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: HE1PR04MB3194
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

I have a board with an Ethernet PHY whose driver currently works in poll
mode. I am in the process of making some changes through which it will
be updated to use interrupts. The changes are twofold.

First, an irqchip driver needs to be written, and device trees need to
be updated. But old kernels need to work with the updated device trees
as well. From their perspective, the interrupt-parent is a missing
supplier, so fw_devlink will block the consumer from probing.

Second, proper interrupt support is only expected to be fulfilled on a
subset of boards on which this irqchip driver runs. The driver detects
this and fails to probe on unsatisfied requirements, which should allow
the consumer driver to fall back to poll mode. But fw_devlink treats a
supplier driver that failed to probe the same as a supplier driver that
did not probe at all, so again, it blocks the consumer.

According to Saravana's commit a9dd8f3c2cf3 ("of: property: Add
fw_devlink support for optional properties"), the way to deal with this
issues is to mark the struct supplier_bindings associated with
"interrupts" and "interrupts-extended" as "optional". Optional actually
means that fw_devlink will no longer create a fwnode link to the
interrupt parent, unless we boot with "fw_devlink.strict".

So practically speaking, interrupts are now not "handled as optional",
but rather "not handled" by fw_devlink. This has quite wide ranging
side effects, for example it happens to fix the case (linked below)
where we have a cyclic dependency between a parent being an interrupt
supplier to a child, fw_devlink blocking the child from probing, and the
parent waiting for the child to probe before the parent itself finishes
probing successfully. This isn't really the main thing I'm intending
with this change, but rather a side observation.

The reason why I'm blaming the commit below is because old kernels
should work with updated device trees, and that commit is practically
where the support was added. IMHO it should have been backported to
older kernels exactly for DT compatibility reasons, but it wasn't.

Fixes: a9dd8f3c2cf3 ("of: property: Add fw_devlink support for optional properties")
Link: https://lore.kernel.org/netdev/20210826074526.825517-2-saravanak@google.com/
Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
Technically this patch targets the devicetree git tree, but I think it
needs an ack from device core maintainers and/or people who contributed
to the device links and fw_devlink, or deferred probing in general.

With this patch in place, the way in which things will work is that:
- of_irq_get() will return -EPROBE_DEFER a number of times.
- fwnode_mdiobus_phy_device_register(), through
  driver_deferred_probe_check_state(), will wait until the initcall
  stage is over (simplifying a bit), then fall back to poll mode.
- The PHY driver will now finally probe successfully
- The PHY driver might defer probe for so long, that the Ethernet
  controller might actually get an -EPROBE_DEFER when calling
  phy_attach_direct() or one of the many of its derivatives.
  This happens because "phy-handle" support was removed from fw_devlink
  in commit 3782326577d4 ("Revert "of: property: fw_devlink: Add support
  for "phy-handle" property"").
- Until the PHY probes, the Ethernet controller may call
  phylink_fwnode_phy_connect() -> fwnode_phy_find_device(), and this
  will return NULL with an unspecified reason. This needs to be patched
  to return -EPROBE_DEFER instead of -ENODEV until
  driver_deferred_probe_check_state() says otherwise
- Even so, some drivers like DSA treat PHY connection errors as "soft"
  and continue probing. This is problematic because an -EPROBE_DEFER
  coming from the PHY will result in a missing net_device. What we want
  is to fix the backpressure all the way to the Ethernet controller
  probing.

This is to say, don't expect that all things start working just with
this single change. I'm copying some Ethernet driver maintainers as a
heads up about this fact, and my plan to address the other issues until
the above works.

 drivers/of/property.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/of/property.c b/drivers/of/property.c
index 8e90071de6ed..a9ceb02e00d9 100644
--- a/drivers/of/property.c
+++ b/drivers/of/property.c
@@ -1393,7 +1393,7 @@ static const struct supplier_bindings of_supplier_bindings[] = {
 	{ .parse_prop = parse_leds, },
 	{ .parse_prop = parse_backlight, },
 	{ .parse_prop = parse_gpio_compat, },
-	{ .parse_prop = parse_interrupts, },
+	{ .parse_prop = parse_interrupts, .optional = true, },
 	{ .parse_prop = parse_regulators, },
 	{ .parse_prop = parse_gpio, },
 	{ .parse_prop = parse_gpios, },
-- 
2.25.1


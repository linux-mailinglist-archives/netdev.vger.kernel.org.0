Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1E522363A9B
	for <lists+netdev@lfdr.de>; Mon, 19 Apr 2021 06:29:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237411AbhDSE3a (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Apr 2021 00:29:30 -0400
Received: from mail-eopbgr30071.outbound.protection.outlook.com ([40.107.3.71]:46659
        "EHLO EUR03-AM5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231942AbhDSE30 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 19 Apr 2021 00:29:26 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VNVgjyChGsOi0W5fo8A1QLOjqeCdAjPprA9QE7ooO0n/UnMqdP4rFhLtByT/hss9EhWbzUhh7SdeE+4OgUyx+Xo+zyj15+W3xgeTH8pJAYkcjGQOy9Vi7osNaHAJRjuMvf3Vh9McyzvbNDWKt3BBpYWbSu655AuQUMRYPF+J/AnAJ6GO5CptDkJshDVe+nbOBbZDsDyzUxR/vSH7pS8SSDKc9Hgz/YTeKjJfi2QEOPnIYRcylHpxDvZ9+rTGeh71z9IgfbbjGgbOWcTARi1h1oIj42AKTNO399cNCEdf31Y6thwbMu3rJUMN3ui9RmPT1MnW2AxNoZ141PR+jVwlVg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JR38Ef3yCrpsm0l/Vw1uaZhZY0dZ2rHaxqZe/N5wxKQ=;
 b=WXqXQRnS6FU5g99Kwlg7Whdsc/B5gSSlhwX4kE5qRRzuXSimSFcaDD+Dl0dUj7Lgvrm96mAEgsvwcbZ4UAjaiZJqwks6Sd/wZRVa+3JS6GanRm5m2nhg7nuLAHz1qoigvlfyeOMlrWD2+yMkni7rsJ13B+4w3T2CbgZF4YNqK1cygaVd9GMODDRsKWQlq983cP2dmItqpeQUdTkJlgoEshqUau/W7FbPvQ42mErNIw0fwYv7HdiuCsgsoQxaToOQpH3tGf/2DXsyt5NmcttiWbsP7KQRl4yQ6ktgVkkulp+GSIljtjFCarkJlb3fvL4LBpp07/Rj85nhxjquGCOjhQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oss.nxp.com; dmarc=pass action=none header.from=oss.nxp.com;
 dkim=pass header.d=oss.nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=NXP1.onmicrosoft.com;
 s=selector2-NXP1-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JR38Ef3yCrpsm0l/Vw1uaZhZY0dZ2rHaxqZe/N5wxKQ=;
 b=HUjA2Q+4hnjdPczd46vUHDJASI+LSQy9L55ez3DElLBRfi1Saax6iPCVy4mLg0hUQI6A7gSIZ9W8V8GrWGudeXnQ8hnjYTNJqaYWzdgqAwmbh8wqGYgDVv+UKToYyokRIBSpZbDzFqetbtcQZM3AhSjRLrJB9CcYfT6m1CK5DhI=
Authentication-Results: linuxfoundation.org; dkim=none (message not signed)
 header.d=none;linuxfoundation.org; dmarc=none action=none
 header.from=oss.nxp.com;
Received: from AM6PR04MB6053.eurprd04.prod.outlook.com (2603:10a6:20b:b9::10)
 by AM6PR04MB4406.eurprd04.prod.outlook.com (2603:10a6:20b:22::30) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4020.22; Mon, 19 Apr
 2021 04:28:52 +0000
Received: from AM6PR04MB6053.eurprd04.prod.outlook.com
 ([fe80::b034:690:56aa:7b18]) by AM6PR04MB6053.eurprd04.prod.outlook.com
 ([fe80::b034:690:56aa:7b18%4]) with mapi id 15.20.4042.024; Mon, 19 Apr 2021
 04:28:52 +0000
From:   "Alice Guo (OSS)" <alice.guo@oss.nxp.com>
To:     gregkh@linuxfoundation.org, rafael@kernel.org,
        horia.geanta@nxp.com, aymen.sghaier@nxp.com,
        herbert@gondor.apana.org.au, davem@davemloft.net, tony@atomide.com,
        geert+renesas@glider.be, mturquette@baylibre.com, sboyd@kernel.org,
        vkoul@kernel.org, peter.ujfalusi@gmail.com, a.hajda@samsung.com,
        narmstrong@baylibre.com, robert.foss@linaro.org, airlied@linux.ie,
        daniel@ffwll.ch, khilman@baylibre.com, tomba@kernel.org,
        jyri.sarha@iki.fi, joro@8bytes.org, will@kernel.org,
        mchehab@kernel.org, ulf.hansson@linaro.org,
        adrian.hunter@intel.com, kishon@ti.com, kuba@kernel.org,
        linus.walleij@linaro.org, Roy.Pledge@nxp.com, leoyang.li@nxp.com,
        ssantosh@kernel.org, matthias.bgg@gmail.com, edubezval@gmail.com,
        j-keerthy@ti.com, balbi@kernel.org, linux@prisktech.co.nz,
        stern@rowland.harvard.edu, wim@linux-watchdog.org,
        linux@roeck-us.net
Cc:     linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org,
        linux-omap@vger.kernel.org, linux-renesas-soc@vger.kernel.org,
        linux-clk@vger.kernel.org, dmaengine@vger.kernel.org,
        dri-devel@lists.freedesktop.org, linux-amlogic@lists.infradead.org,
        linux-arm-kernel@lists.infradead.org,
        iommu@lists.linux-foundation.org, linux-media@vger.kernel.org,
        linux-mmc@vger.kernel.org, netdev@vger.kernel.org,
        linux-phy@lists.infradead.org, linux-gpio@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org, linux-staging@lists.linux.dev,
        linux-mediatek@lists.infradead.org, linux-pm@vger.kernel.org,
        linux-usb@vger.kernel.org, linux-watchdog@vger.kernel.org
Subject: [RFC v1 PATCH 3/3] driver: update all the code that use soc_device_match
Date:   Mon, 19 Apr 2021 12:27:22 +0800
Message-Id: <20210419042722.27554-4-alice.guo@oss.nxp.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210419042722.27554-1-alice.guo@oss.nxp.com>
References: <20210419042722.27554-1-alice.guo@oss.nxp.com>
Content-Type: text/plain
X-Originating-IP: [119.31.174.71]
X-ClientProxiedBy: AM0PR02CA0207.eurprd02.prod.outlook.com
 (2603:10a6:20b:28f::14) To AM6PR04MB6053.eurprd04.prod.outlook.com
 (2603:10a6:20b:b9::10)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from nxf55104-OptiPlex-7060.ap.freescale.net (119.31.174.71) by AM0PR02CA0207.eurprd02.prod.outlook.com (2603:10a6:20b:28f::14) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4042.19 via Frontend Transport; Mon, 19 Apr 2021 04:28:33 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: ae8910fb-f1ac-4eb0-0e6b-08d902eba26c
X-MS-TrafficTypeDiagnostic: AM6PR04MB4406:
X-MS-Exchange-SharedMailbox-RoutingAgent-Processed: True
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <AM6PR04MB4406747B2D44512854E0D701A3499@AM6PR04MB4406.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:843;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: AGl30tAMSycmpdC2zhkyWF0yx84gVfjrfaCd/gFzkRuZNGr9It51L9umhoOHl5jMDzQGaNRCGWIvT3/i5iulwERFHIOm9UmnIzfAKTyBoxPwf05uuwg99LIIycDwmSehQzjHpMeJJVbfnQoy6OaB6z8NdeMu2lT0vCz8TjaYm9vnxbzyLfRKz7WpwDkG5XhDLwREK+Dm2t/e7grP2LzFIWZYx0j1W/btHq8CPPzwMRl+EiZi7RZXAXTkU2vPbXs/A+vT2tOWFYRgZ4ZzN0UQgnBnUfy8C1C/uJilIWzAUEJSTXqnb1rv7U5vPBOdPxKqpYanCAv4GK/F6QbXeRowRzgNmIixG5XeELslfXD5A0qGIG+tCzEG9Eq6yKp+xIT/xZfRtb9+EzEUPJAbo0p4b2ksTB14W4N8KL82RDd3f55QZHT1xo0gvEhGrmwBbipMb97+oppmtuP7mcabPDolBym9E2hg6Fw0k1pZWJ84GalHNws8iCgn11J3cUXsd5BHxg/VobLxAu4xUfgyhqwZii3DLK4597O8P35J+kcvmL02tjZglYYEhmzJ8p/5MNRpdC8U+Z0cNmpVhXHOD5/Zlyvkz+Xg9sCL1NmOM6MmnmHwvaPpopJXVfv/1odoTx5TnKAOmwz/Kw3oEgtmp5X7roOKTmdZue66vJ4jHMINOMo=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM6PR04MB6053.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(346002)(136003)(366004)(396003)(39860400002)(376002)(186003)(7366002)(7406005)(6666004)(2906002)(8936002)(2616005)(26005)(5660300002)(8676002)(83380400001)(86362001)(38350700002)(7416002)(38100700002)(16526019)(316002)(956004)(1076003)(66556008)(15650500001)(4326008)(6486002)(6512007)(478600001)(6506007)(921005)(66946007)(52116002)(30864003)(66476007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?0JOB576zVAEKseU9JXkg+/LZ6QhEz/REwynOrYeiRL924v2v22TpX7Tm5sKT?=
 =?us-ascii?Q?OnmluQCsytia7XdaTMgYWvKNAC60moSG/LqkCxXR8xpJYS2MwApD7BkDNq2X?=
 =?us-ascii?Q?9c8/vtY0Rg+GU7mlLML4mHVmuE2poOzvlri2q5fzogoQQIkeZoE/uB2UWaCx?=
 =?us-ascii?Q?F96yWe3Fq9d3uN9G5OCP0LZCbzLSBK9wecx1lSuF1Mf1ZQ+UhteSV9EKejSH?=
 =?us-ascii?Q?AnDv9YtZ2OPJ9+Al83nsu9G6thVJwsCTk1uLCYh9lrL6hKSIO16P61MXXw/L?=
 =?us-ascii?Q?KOBKvpru7l83rB1uA+vM5D+08wzucRmb06sDXc3BAmxuauxSFx0lFnmRx5/s?=
 =?us-ascii?Q?V6GH10B2C9C2aWsYoQqS9gn02TpUiweknvAaN0GbcY+7oFaUfjJCexcQGu7y?=
 =?us-ascii?Q?JDPS++bMZtIc5Vbic+UosJ7YJkyw96qpuEQKDGmOxjA263+sZn5mIGfCQEAg?=
 =?us-ascii?Q?nGeJojCJMegvWPGbMkI/IKD7CSoDOMqPBQaQ/XHsS8OQG+Z9M3QkCU3+cmpY?=
 =?us-ascii?Q?qS0g62oMpcnhIDK1svnqqrKAgiPyzds5ujjX+ko8VdSuWcoQLWrLitxxfVq2?=
 =?us-ascii?Q?rcE75Ml/WQ+GodjGzjS7hd10N9UEZjfV099nbAxFRyOLhpZq+AbxnXZKmSb0?=
 =?us-ascii?Q?F3brME4TcGfHSxBGrCkv5sV9rL56f6mx/a32BhlLf4QgsQ2QN2+fyYqNU+dq?=
 =?us-ascii?Q?Xqtd/mB93r+0xXfI0jNLZTxOacCKXYEpFH7WoMS/k+CSgz5pNENOdMHsV9Lm?=
 =?us-ascii?Q?OP/Bv9m5u/Eo0r9qkUEH0fzEMKCcXINn/ldTkPIORPJP4LrtBPSFCkf3lxof?=
 =?us-ascii?Q?8xbJsZMANcgUe46TkEBSR3dt/8t41WEDMk+ImW/SSFW8QkEM9QZwhOj7w18d?=
 =?us-ascii?Q?lKnSB7Lc8SlXX+9tAVI4CWdcXmRFXL8Hh9Kd2UaqPMOrrUaudHzWqB7+N8c3?=
 =?us-ascii?Q?VbX8vT74HqDup3B32aDHon+VLa0luhq9suCO0EgX0BaiSjjYvQoGJJv5Bks7?=
 =?us-ascii?Q?fyIvO1fhm7RlnY21fJbFdbr61rP/1TqUC56y0hcj7yOEsA4ZnpfW67W/Xw1t?=
 =?us-ascii?Q?ogqDiJErQ7v+r4VuUzGkf4aWsGFaPlFlLGCwpCaXjjfBExCp8X8ccn6M200g?=
 =?us-ascii?Q?k/M7VBVSqdFJqmAKnF8MVFIr5iQY9pLWrkSv04HYG84bN3gjFcEF/hnPTylU?=
 =?us-ascii?Q?YiFxT+GvevhmVddspiISnqqt7N8oUX1+Ycxb2RffWcS2Bc4btZ8S/pRJ3pPd?=
 =?us-ascii?Q?5Y/iW+LaK4vT7Q25KMlr9xoX2llT2kByxGyyIl3tiIRNNgtBMWK9fBmDBVCt?=
 =?us-ascii?Q?cRdEKIWQPlHY037++4Ot1WTS?=
X-OriginatorOrg: oss.nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ae8910fb-f1ac-4eb0-0e6b-08d902eba26c
X-MS-Exchange-CrossTenant-AuthSource: AM6PR04MB6053.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Apr 2021 04:28:52.5770
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 1/OaAWfsYzDRzxQN2ODMAnchQA7SZoZvNGCXLqH1Ru5qDeZko+G8kKBDSg9reNJ+PpkgAm3mR6WjZTZ8IpfUPA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM6PR04MB4406
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Alice Guo <alice.guo@nxp.com>

Update all the code that use soc_device_match because add support for
soc_device_match returning -EPROBE_DEFER.

Signed-off-by: Alice Guo <alice.guo@nxp.com>
---
 drivers/bus/ti-sysc.c                         |  2 +-
 drivers/clk/renesas/r8a7795-cpg-mssr.c        |  4 +++-
 drivers/clk/renesas/rcar-gen2-cpg.c           |  2 +-
 drivers/clk/renesas/rcar-gen3-cpg.c           |  2 +-
 drivers/dma/fsl-dpaa2-qdma/dpaa2-qdma.c       |  7 ++++++-
 drivers/dma/ti/k3-psil.c                      |  3 +++
 drivers/dma/ti/k3-udma.c                      |  2 +-
 drivers/gpu/drm/bridge/nwl-dsi.c              |  2 +-
 drivers/gpu/drm/meson/meson_drv.c             |  4 +++-
 drivers/gpu/drm/omapdrm/dss/dispc.c           |  2 +-
 drivers/gpu/drm/omapdrm/dss/dpi.c             |  4 +++-
 drivers/gpu/drm/omapdrm/dss/dsi.c             |  3 +++
 drivers/gpu/drm/omapdrm/dss/dss.c             |  3 +++
 drivers/gpu/drm/omapdrm/dss/hdmi4_core.c      |  3 +++
 drivers/gpu/drm/omapdrm/dss/venc.c            |  4 +++-
 drivers/gpu/drm/omapdrm/omap_drv.c            |  3 +++
 drivers/gpu/drm/rcar-du/rcar_du_crtc.c        |  4 +++-
 drivers/gpu/drm/rcar-du/rcar_lvds.c           |  2 +-
 drivers/gpu/drm/tidss/tidss_dispc.c           |  4 +++-
 drivers/iommu/ipmmu-vmsa.c                    |  7 +++++--
 drivers/media/platform/rcar-vin/rcar-core.c   |  2 +-
 drivers/media/platform/rcar-vin/rcar-csi2.c   |  2 +-
 drivers/media/platform/vsp1/vsp1_uif.c        |  4 +++-
 drivers/mmc/host/renesas_sdhi_core.c          |  2 +-
 drivers/mmc/host/renesas_sdhi_internal_dmac.c |  2 +-
 drivers/mmc/host/sdhci-of-esdhc.c             | 21 ++++++++++++++-----
 drivers/mmc/host/sdhci-omap.c                 |  2 +-
 drivers/mmc/host/sdhci_am654.c                |  2 +-
 drivers/net/ethernet/renesas/ravb_main.c      |  4 +++-
 drivers/net/ethernet/ti/am65-cpsw-nuss.c      |  2 +-
 drivers/net/ethernet/ti/cpsw.c                |  2 +-
 drivers/net/ethernet/ti/cpsw_new.c            |  2 +-
 drivers/phy/ti/phy-omap-usb2.c                |  4 +++-
 drivers/pinctrl/renesas/core.c                |  2 +-
 drivers/pinctrl/renesas/pfc-r8a7790.c         |  5 ++++-
 drivers/pinctrl/renesas/pfc-r8a7794.c         |  5 ++++-
 drivers/soc/fsl/dpio/dpio-driver.c            | 13 ++++++++----
 drivers/soc/renesas/r8a774c0-sysc.c           |  5 ++++-
 drivers/soc/renesas/r8a7795-sysc.c            |  2 +-
 drivers/soc/renesas/r8a77990-sysc.c           |  5 ++++-
 drivers/soc/ti/k3-ringacc.c                   |  2 +-
 drivers/staging/mt7621-pci/pci-mt7621.c       |  2 +-
 drivers/thermal/rcar_gen3_thermal.c           |  4 +++-
 drivers/thermal/ti-soc-thermal/ti-bandgap.c   | 10 +++++++--
 drivers/usb/gadget/udc/renesas_usb3.c         |  2 +-
 drivers/usb/host/ehci-platform.c              |  4 +++-
 drivers/usb/host/xhci-rcar.c                  |  2 +-
 drivers/watchdog/renesas_wdt.c                |  2 +-
 48 files changed, 131 insertions(+), 52 deletions(-)

diff --git a/drivers/bus/ti-sysc.c b/drivers/bus/ti-sysc.c
index 5fae60f8c135..00c59aa217c1 100644
--- a/drivers/bus/ti-sysc.c
+++ b/drivers/bus/ti-sysc.c
@@ -2909,7 +2909,7 @@ static int sysc_init_soc(struct sysc *ddata)
 	}
 
 	match = soc_device_match(sysc_soc_feat_match);
-	if (!match)
+	if (!match || IS_ERR(match))
 		return 0;
 
 	if (match->data)
diff --git a/drivers/clk/renesas/r8a7795-cpg-mssr.c b/drivers/clk/renesas/r8a7795-cpg-mssr.c
index c32d2c678046..90a18336a4c3 100644
--- a/drivers/clk/renesas/r8a7795-cpg-mssr.c
+++ b/drivers/clk/renesas/r8a7795-cpg-mssr.c
@@ -439,6 +439,7 @@ static const unsigned int r8a7795es2_mod_nullify[] __initconst = {
 
 static int __init r8a7795_cpg_mssr_init(struct device *dev)
 {
+	const struct soc_device_attribute *match;
 	const struct rcar_gen3_cpg_pll_config *cpg_pll_config;
 	u32 cpg_mode;
 	int error;
@@ -453,7 +454,8 @@ static int __init r8a7795_cpg_mssr_init(struct device *dev)
 		return -EINVAL;
 	}
 
-	if (soc_device_match(r8a7795es1)) {
+	match = soc_device_match(r8a7795es1);
+	if (!IS_ERR(match) && match) {
 		cpg_core_nullify_range(r8a7795_core_clks,
 				       ARRAY_SIZE(r8a7795_core_clks),
 				       R8A7795_CLK_S0D2, R8A7795_CLK_S0D12);
diff --git a/drivers/clk/renesas/rcar-gen2-cpg.c b/drivers/clk/renesas/rcar-gen2-cpg.c
index edae874fa2b6..946f82634d23 100644
--- a/drivers/clk/renesas/rcar-gen2-cpg.c
+++ b/drivers/clk/renesas/rcar-gen2-cpg.c
@@ -383,7 +383,7 @@ int __init rcar_gen2_cpg_init(const struct rcar_gen2_cpg_pll_config *config,
 	cpg_pll0_div = pll0_div;
 	cpg_mode = mode;
 	attr = soc_device_match(cpg_quirks_match);
-	if (attr)
+	if (!IS_ERR(attr) && attr)
 		cpg_quirks = (uintptr_t)attr->data;
 	pr_debug("%s: mode = 0x%x quirks = 0x%x\n", __func__, mode, cpg_quirks);
 
diff --git a/drivers/clk/renesas/rcar-gen3-cpg.c b/drivers/clk/renesas/rcar-gen3-cpg.c
index caa0f9414e45..e5c7854188cd 100644
--- a/drivers/clk/renesas/rcar-gen3-cpg.c
+++ b/drivers/clk/renesas/rcar-gen3-cpg.c
@@ -499,7 +499,7 @@ int __init rcar_gen3_cpg_init(const struct rcar_gen3_cpg_pll_config *config,
 	cpg_clk_extalr = clk_extalr;
 	cpg_mode = mode;
 	attr = soc_device_match(cpg_quirks_match);
-	if (attr)
+	if (!IS_ERR(attr) && attr)
 		cpg_quirks = (uintptr_t)attr->data;
 	pr_debug("%s: mode = 0x%x quirks = 0x%x\n", __func__, mode, cpg_quirks);
 
diff --git a/drivers/dma/fsl-dpaa2-qdma/dpaa2-qdma.c b/drivers/dma/fsl-dpaa2-qdma/dpaa2-qdma.c
index 4ec909e0b810..7c83ae86ced4 100644
--- a/drivers/dma/fsl-dpaa2-qdma/dpaa2-qdma.c
+++ b/drivers/dma/fsl-dpaa2-qdma/dpaa2-qdma.c
@@ -651,6 +651,7 @@ static int dpaa2_dpdmai_init_channels(struct dpaa2_qdma_engine *dpaa2_qdma)
 
 static int dpaa2_qdma_probe(struct fsl_mc_device *dpdmai_dev)
 {
+	const struct soc_device_attribute *match;
 	struct device *dev = &dpdmai_dev->dev;
 	struct dpaa2_qdma_engine *dpaa2_qdma;
 	struct dpaa2_qdma_priv *priv;
@@ -718,7 +719,11 @@ static int dpaa2_qdma_probe(struct fsl_mc_device *dpdmai_dev)
 
 	dpaa2_dpdmai_init_channels(dpaa2_qdma);
 
-	if (soc_device_match(soc_fixup_tuning))
+	match = soc_device_match(soc_fixup_tuning);
+	if (IS_ERR(match))
+		return PTR_ERR(match);
+
+	if (match)
 		dpaa2_qdma->qdma_wrtype_fixup = true;
 	else
 		dpaa2_qdma->qdma_wrtype_fixup = false;
diff --git a/drivers/dma/ti/k3-psil.c b/drivers/dma/ti/k3-psil.c
index 13ce7367d870..ae56441e5184 100644
--- a/drivers/dma/ti/k3-psil.c
+++ b/drivers/dma/ti/k3-psil.c
@@ -33,6 +33,9 @@ struct psil_endpoint_config *psil_get_ep_config(u32 thread_id)
 		const struct soc_device_attribute *soc;
 
 		soc = soc_device_match(k3_soc_devices);
+		if (IS_ERR(soc))
+			return PTR_ERR(soc);
+
 		if (soc) {
 			soc_ep_map = soc->data;
 		} else {
diff --git a/drivers/dma/ti/k3-udma.c b/drivers/dma/ti/k3-udma.c
index 96ad21869ba7..50a4c8f0993d 100644
--- a/drivers/dma/ti/k3-udma.c
+++ b/drivers/dma/ti/k3-udma.c
@@ -5188,7 +5188,7 @@ static int udma_probe(struct platform_device *pdev)
 	ud->match_data = match->data;
 
 	soc = soc_device_match(k3_soc_devices);
-	if (!soc) {
+	if (!IS_ERR(soc) && !soc) {
 		dev_err(dev, "No compatible SoC found\n");
 		return -ENODEV;
 	}
diff --git a/drivers/gpu/drm/bridge/nwl-dsi.c b/drivers/gpu/drm/bridge/nwl-dsi.c
index 66b67402f1ac..80fe971e359d 100644
--- a/drivers/gpu/drm/bridge/nwl-dsi.c
+++ b/drivers/gpu/drm/bridge/nwl-dsi.c
@@ -1158,7 +1158,7 @@ static int nwl_dsi_probe(struct platform_device *pdev)
 	}
 
 	attr = soc_device_match(nwl_dsi_quirks_match);
-	if (attr)
+	if (!IS_ERR(attr) && attr)
 		dsi->quirks = (uintptr_t)attr->data;
 
 	dsi->bridge.driver_private = dsi;
diff --git a/drivers/gpu/drm/meson/meson_drv.c b/drivers/gpu/drm/meson/meson_drv.c
index 453d8b4c5763..d409c9958f18 100644
--- a/drivers/gpu/drm/meson/meson_drv.c
+++ b/drivers/gpu/drm/meson/meson_drv.c
@@ -195,6 +195,7 @@ static int meson_drv_bind_master(struct device *dev, bool has_components)
 {
 	struct platform_device *pdev = to_platform_device(dev);
 	const struct meson_drm_match_data *match;
+	const struct soc_device_attribute *attr;
 	struct meson_drm *priv;
 	struct drm_device *drm;
 	struct resource *res;
@@ -291,7 +292,8 @@ static int meson_drv_bind_master(struct device *dev, bool has_components)
 
 	/* Assign limits per soc revision/package */
 	for (i = 0 ; i < ARRAY_SIZE(meson_drm_soc_attrs) ; ++i) {
-		if (soc_device_match(meson_drm_soc_attrs[i].attrs)) {
+		attr = soc_device_match(meson_drm_soc_attrs[i].attrs);
+		if (!IS_ERR(attr) && attr) {
 			priv->limits = &meson_drm_soc_attrs[i].limits;
 			break;
 		}
diff --git a/drivers/gpu/drm/omapdrm/dss/dispc.c b/drivers/gpu/drm/omapdrm/dss/dispc.c
index 5619420cc2cc..53f402d72fc4 100644
--- a/drivers/gpu/drm/omapdrm/dss/dispc.c
+++ b/drivers/gpu/drm/omapdrm/dss/dispc.c
@@ -4741,7 +4741,7 @@ static int dispc_bind(struct device *dev, struct device *master, void *data)
 	 * string, use SoC device matching.
 	 */
 	soc = soc_device_match(dispc_soc_devices);
-	if (soc)
+	if (!IS_ERR(soc) && soc)
 		dispc->feat = soc->data;
 	else
 		dispc->feat = of_match_device(dispc_of_match, &pdev->dev)->data;
diff --git a/drivers/gpu/drm/omapdrm/dss/dpi.c b/drivers/gpu/drm/omapdrm/dss/dpi.c
index 030f997eccd0..57b1c62dcdf2 100644
--- a/drivers/gpu/drm/omapdrm/dss/dpi.c
+++ b/drivers/gpu/drm/omapdrm/dss/dpi.c
@@ -677,12 +677,14 @@ static const struct soc_device_attribute dpi_soc_devices[] = {
 static int dpi_init_regulator(struct dpi_data *dpi)
 {
 	struct regulator *vdds_dsi;
+	struct soc_device_attribute *soc;
 
 	/*
 	 * The DPI uses the DSI VDDS on OMAP34xx, OMAP35xx, OMAP36xx, AM37xx and
 	 * DM37xx only.
 	 */
-	if (!soc_device_match(dpi_soc_devices))
+	soc = soc_device_match(dpi_soc_devices);
+	if (!IS_ERR(soc) && !soc)
 		return 0;
 
 	vdds_dsi = devm_regulator_get(&dpi->pdev->dev, "vdds_dsi");
diff --git a/drivers/gpu/drm/omapdrm/dss/dsi.c b/drivers/gpu/drm/omapdrm/dss/dsi.c
index 5f1722b040f4..cbef6fb85d1d 100644
--- a/drivers/gpu/drm/omapdrm/dss/dsi.c
+++ b/drivers/gpu/drm/omapdrm/dss/dsi.c
@@ -4952,6 +4952,9 @@ static int dsi_probe(struct platform_device *pdev)
 	}
 
 	soc = soc_device_match(dsi_soc_devices);
+	if (IS_ERR(soc))
+		return PTR_ERR(soc);
+
 	if (soc)
 		dsi->data = soc->data;
 	else
diff --git a/drivers/gpu/drm/omapdrm/dss/dss.c b/drivers/gpu/drm/omapdrm/dss/dss.c
index d6a5862b4dbf..1f88d25d178b 100644
--- a/drivers/gpu/drm/omapdrm/dss/dss.c
+++ b/drivers/gpu/drm/omapdrm/dss/dss.c
@@ -1446,6 +1446,9 @@ static int dss_probe(struct platform_device *pdev)
 	 * string, use SoC device matching.
 	 */
 	soc = soc_device_match(dss_soc_devices);
+	if (IS_ERR(soc))
+		return PTR_ERR(soc);
+
 	if (soc)
 		dss->feat = soc->data;
 	else
diff --git a/drivers/gpu/drm/omapdrm/dss/hdmi4_core.c b/drivers/gpu/drm/omapdrm/dss/hdmi4_core.c
index 35faa7f028c4..53a09cfd4deb 100644
--- a/drivers/gpu/drm/omapdrm/dss/hdmi4_core.c
+++ b/drivers/gpu/drm/omapdrm/dss/hdmi4_core.c
@@ -874,6 +874,9 @@ int hdmi4_core_init(struct platform_device *pdev, struct hdmi_core_data *core)
 	const struct soc_device_attribute *soc;
 
 	soc = soc_device_match(hdmi4_soc_devices);
+	if (IS_ERR(soc))
+		return PTR_ERR(soc);
+
 	if (!soc)
 		return -ENODEV;
 
diff --git a/drivers/gpu/drm/omapdrm/dss/venc.c b/drivers/gpu/drm/omapdrm/dss/venc.c
index e522c17955d0..df6fa3977481 100644
--- a/drivers/gpu/drm/omapdrm/dss/venc.c
+++ b/drivers/gpu/drm/omapdrm/dss/venc.c
@@ -805,6 +805,7 @@ static const struct soc_device_attribute venc_soc_devices[] = {
 
 static int venc_probe(struct platform_device *pdev)
 {
+	const struct soc_device_attribute *match;
 	struct venc_device *venc;
 	struct resource *venc_mem;
 	int r;
@@ -818,7 +819,8 @@ static int venc_probe(struct platform_device *pdev)
 	platform_set_drvdata(pdev, venc);
 
 	/* The OMAP34xx, OMAP35xx and AM35xx VENC require the TV DAC clock. */
-	if (soc_device_match(venc_soc_devices))
+	match = soc_device_match(venc_soc_devices);
+	if (!IS_ERR(match) && match)
 		venc->requires_tv_dac_clk = true;
 
 	venc->config = &venc_config_pal_trm;
diff --git a/drivers/gpu/drm/omapdrm/omap_drv.c b/drivers/gpu/drm/omapdrm/omap_drv.c
index 8632139e0f01..8542998f5e9e 100644
--- a/drivers/gpu/drm/omapdrm/omap_drv.c
+++ b/drivers/gpu/drm/omapdrm/omap_drv.c
@@ -576,6 +576,9 @@ static int omapdrm_init(struct omap_drm_private *priv, struct device *dev)
 	priv->dss->mgr_ops_priv = priv;
 
 	soc = soc_device_match(omapdrm_soc_devices);
+	if (IS_ERR(soc))
+		return PTR_ERR(soc);
+
 	priv->omaprev = soc ? (unsigned int)soc->data : 0;
 	priv->wq = alloc_ordered_workqueue("omapdrm", 0);
 
diff --git a/drivers/gpu/drm/rcar-du/rcar_du_crtc.c b/drivers/gpu/drm/rcar-du/rcar_du_crtc.c
index ea7e39d03545..06f5fd518326 100644
--- a/drivers/gpu/drm/rcar-du/rcar_du_crtc.c
+++ b/drivers/gpu/drm/rcar-du/rcar_du_crtc.c
@@ -215,6 +215,7 @@ static void rcar_du_crtc_set_display_timing(struct rcar_du_crtc *rcrtc)
 	const struct drm_display_mode *mode = &rcrtc->crtc.state->adjusted_mode;
 	struct rcar_du_device *rcdu = rcrtc->dev;
 	unsigned long mode_clock = mode->clock * 1000;
+	const struct soc_device_attribute *match;
 	u32 dsmr;
 	u32 escr;
 
@@ -238,7 +239,8 @@ static void rcar_du_crtc_set_display_timing(struct rcar_du_crtc *rcrtc)
 		 * no post-divider when a display PLL is present (as shown by
 		 * the workaround breaking HDMI output on M3-W during testing).
 		 */
-		if (soc_device_match(rcar_du_r8a7795_es1)) {
+		match = soc_device_match(rcar_du_r8a7795_es1);
+		if (!IS_ERR(match) && match) {
 			target *= 2;
 			div = 1;
 		}
diff --git a/drivers/gpu/drm/rcar-du/rcar_lvds.c b/drivers/gpu/drm/rcar-du/rcar_lvds.c
index 70dbbe44bb23..273c812a04e0 100644
--- a/drivers/gpu/drm/rcar-du/rcar_lvds.c
+++ b/drivers/gpu/drm/rcar-du/rcar_lvds.c
@@ -912,7 +912,7 @@ static int rcar_lvds_probe(struct platform_device *pdev)
 	lvds->info = of_device_get_match_data(&pdev->dev);
 
 	attr = soc_device_match(lvds_quirk_matches);
-	if (attr)
+	if (!IS_ERR(attr) && attr)
 		lvds->info = attr->data;
 
 	ret = rcar_lvds_parse_dt(lvds);
diff --git a/drivers/gpu/drm/tidss/tidss_dispc.c b/drivers/gpu/drm/tidss/tidss_dispc.c
index 60b92df615aa..8f083604e04f 100644
--- a/drivers/gpu/drm/tidss/tidss_dispc.c
+++ b/drivers/gpu/drm/tidss/tidss_dispc.c
@@ -2643,8 +2643,10 @@ static void dispc_init_errata(struct dispc_device *dispc)
 		{ .family = "AM65X", .revision = "SR1.0" },
 		{ /* sentinel */ }
 	};
+	const struct soc_device_attribute *match;
 
-	if (soc_device_match(am65x_sr10_soc_devices)) {
+	match = soc_device_match(am65x_sr10_soc_devices);
+	if (!IS_ERR(match) && match) {
 		dispc->errata.i2000 = true;
 		dev_info(dispc->dev, "WA for erratum i2000: YUV formats disabled\n");
 	}
diff --git a/drivers/iommu/ipmmu-vmsa.c b/drivers/iommu/ipmmu-vmsa.c
index eaaec0a55cc6..13a06b613379 100644
--- a/drivers/iommu/ipmmu-vmsa.c
+++ b/drivers/iommu/ipmmu-vmsa.c
@@ -757,17 +757,20 @@ static const char * const devices_allowlist[] = {
 
 static bool ipmmu_device_is_allowed(struct device *dev)
 {
+	const struct soc_device_attribute *match1, *match2;
 	unsigned int i;
 
 	/*
 	 * R-Car Gen3 and RZ/G2 use the allow list to opt-in devices.
 	 * For Other SoCs, this returns true anyway.
 	 */
-	if (!soc_device_match(soc_needs_opt_in))
+	match1 = soc_device_match(soc_needs_opt_in);
+	if (!IS_ERR(match1) && !match1)
 		return true;
 
 	/* Check whether this SoC can use the IPMMU correctly or not */
-	if (soc_device_match(soc_denylist))
+	match2 = soc_device_match(soc_denylist);
+	if (!IS_ERR(match2) && !match2)
 		return false;
 
 	/* Check whether this device can work with the IPMMU */
diff --git a/drivers/media/platform/rcar-vin/rcar-core.c b/drivers/media/platform/rcar-vin/rcar-core.c
index cb3025992817..37afc4b169c1 100644
--- a/drivers/media/platform/rcar-vin/rcar-core.c
+++ b/drivers/media/platform/rcar-vin/rcar-core.c
@@ -1413,7 +1413,7 @@ static int rcar_vin_probe(struct platform_device *pdev)
 	 * uses different routing than r8a7795 ES2.0.
 	 */
 	attr = soc_device_match(r8a7795es1);
-	if (attr)
+	if (!IS_ERR(attr) && attr)
 		vin->info = attr->data;
 
 	vin->base = devm_platform_ioremap_resource(pdev, 0);
diff --git a/drivers/media/platform/rcar-vin/rcar-csi2.c b/drivers/media/platform/rcar-vin/rcar-csi2.c
index e06cd512aba2..b83200e8e30d 100644
--- a/drivers/media/platform/rcar-vin/rcar-csi2.c
+++ b/drivers/media/platform/rcar-vin/rcar-csi2.c
@@ -1214,7 +1214,7 @@ static int rcsi2_probe(struct platform_device *pdev)
 	 * share the same compatible string.
 	 */
 	attr = soc_device_match(r8a7795);
-	if (attr)
+	if (!IS_ERR(attr) && attr)
 		priv->info = attr->data;
 
 	priv->dev = &pdev->dev;
diff --git a/drivers/media/platform/vsp1/vsp1_uif.c b/drivers/media/platform/vsp1/vsp1_uif.c
index 467d1072577b..e5c5b4f50dea 100644
--- a/drivers/media/platform/vsp1/vsp1_uif.c
+++ b/drivers/media/platform/vsp1/vsp1_uif.c
@@ -240,6 +240,7 @@ static const struct soc_device_attribute vsp1_r8a7796[] = {
 struct vsp1_uif *vsp1_uif_create(struct vsp1_device *vsp1, unsigned int index)
 {
 	struct vsp1_uif *uif;
+	const struct soc_device_attribute *attr;
 	char name[6];
 	int ret;
 
@@ -247,7 +248,8 @@ struct vsp1_uif *vsp1_uif_create(struct vsp1_device *vsp1, unsigned int index)
 	if (!uif)
 		return ERR_PTR(-ENOMEM);
 
-	if (soc_device_match(vsp1_r8a7796))
+	attr = soc_device_match(vsp1_r8a7796);
+	if (!IS_ERR(attr) && attr)
 		uif->m3w_quirk = true;
 
 	uif->entity.ops = &uif_entity_ops;
diff --git a/drivers/mmc/host/renesas_sdhi_core.c b/drivers/mmc/host/renesas_sdhi_core.c
index 635bf31a6735..71986a8bf50e 100644
--- a/drivers/mmc/host/renesas_sdhi_core.c
+++ b/drivers/mmc/host/renesas_sdhi_core.c
@@ -964,7 +964,7 @@ int renesas_sdhi_probe(struct platform_device *pdev,
 	of_data = of_device_get_match_data(&pdev->dev);
 
 	attr = soc_device_match(sdhi_quirks_match);
-	if (attr)
+	if (!IS_ERR(attr) && attr)
 		quirks = attr->data;
 
 	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
diff --git a/drivers/mmc/host/renesas_sdhi_internal_dmac.c b/drivers/mmc/host/renesas_sdhi_internal_dmac.c
index e8f4863d8f1a..946f57b3cc48 100644
--- a/drivers/mmc/host/renesas_sdhi_internal_dmac.c
+++ b/drivers/mmc/host/renesas_sdhi_internal_dmac.c
@@ -408,7 +408,7 @@ static int renesas_sdhi_internal_dmac_probe(struct platform_device *pdev)
 	const struct soc_device_attribute *soc = soc_device_match(soc_dma_quirks);
 	struct device *dev = &pdev->dev;
 
-	if (soc)
+	if (!IS_ERR(soc) && soc)
 		global_flags |= (unsigned long)soc->data;
 
 	/* value is max of SD_SECCNT. Confirmed by HW engineers */
diff --git a/drivers/mmc/host/sdhci-of-esdhc.c b/drivers/mmc/host/sdhci-of-esdhc.c
index ab5ab969f711..4259553451da 100644
--- a/drivers/mmc/host/sdhci-of-esdhc.c
+++ b/drivers/mmc/host/sdhci-of-esdhc.c
@@ -1336,6 +1336,7 @@ static void esdhc_init(struct platform_device *pdev, struct sdhci_host *host)
 	struct sdhci_esdhc *esdhc;
 	struct device_node *np;
 	struct clk *clk;
+	const struct soc_device_attribute *match1, *match2, *match3;
 	u32 val;
 	u16 host_ver;
 
@@ -1346,17 +1347,20 @@ static void esdhc_init(struct platform_device *pdev, struct sdhci_host *host)
 	esdhc->vendor_ver = (host_ver & SDHCI_VENDOR_VER_MASK) >>
 			     SDHCI_VENDOR_VER_SHIFT;
 	esdhc->spec_ver = host_ver & SDHCI_SPEC_VER_MASK;
-	if (soc_device_match(soc_incorrect_hostver))
+	match1 = soc_device_match(soc_incorrect_hostver);
+	if (!IS_ERR(match1) && match1)
 		esdhc->quirk_incorrect_hostver = true;
 	else
 		esdhc->quirk_incorrect_hostver = false;
 
-	if (soc_device_match(soc_fixup_sdhc_clkdivs))
+	match2 = soc_device_match(soc_fixup_sdhc_clkdivs);
+	if (!IS_ERR(match2) && match2)
 		esdhc->quirk_limited_clk_division = true;
 	else
 		esdhc->quirk_limited_clk_division = false;
 
-	if (soc_device_match(soc_unreliable_pulse_detection))
+	match3 = soc_device_match(soc_unreliable_pulse_detection);
+	if (!IS_ERR(match3) && match3)
 		esdhc->quirk_unreliable_pulse_detection = true;
 	else
 		esdhc->quirk_unreliable_pulse_detection = false;
@@ -1417,6 +1421,7 @@ static int sdhci_esdhc_probe(struct platform_device *pdev)
 	struct device_node *np;
 	struct sdhci_pltfm_host *pltfm_host;
 	struct sdhci_esdhc *esdhc;
+	const struct soc_device_attribute *match1, *match2;
 	int ret;
 
 	np = pdev->dev.of_node;
@@ -1443,12 +1448,18 @@ static int sdhci_esdhc_probe(struct platform_device *pdev)
 
 	pltfm_host = sdhci_priv(host);
 	esdhc = sdhci_pltfm_priv(pltfm_host);
-	if (soc_device_match(soc_tuning_erratum_type1))
+	match1 = soc_device_match(soc_tuning_erratum_type1);
+	if (IS_ERR(match1))
+		return PTR_ERR(match1);
+	if (match1)
 		esdhc->quirk_tuning_erratum_type1 = true;
 	else
 		esdhc->quirk_tuning_erratum_type1 = false;
 
-	if (soc_device_match(soc_tuning_erratum_type2))
+	match2 = soc_device_match(soc_tuning_erratum_type2);
+	if (IS_ERR(match2))
+		return PTR_ERR(match2);
+	if (match2)
 		esdhc->quirk_tuning_erratum_type2 = true;
 	else
 		esdhc->quirk_tuning_erratum_type2 = false;
diff --git a/drivers/mmc/host/sdhci-omap.c b/drivers/mmc/host/sdhci-omap.c
index 7893fd3599b6..5a6f2b22eb42 100644
--- a/drivers/mmc/host/sdhci-omap.c
+++ b/drivers/mmc/host/sdhci-omap.c
@@ -1132,7 +1132,7 @@ static int sdhci_omap_probe(struct platform_device *pdev)
 		goto err_pltfm_free;
 
 	soc = soc_device_match(sdhci_omap_soc_devices);
-	if (soc) {
+	if (!IS_ERR(soc) && soc) {
 		omap_host->version = "rev11";
 		if (!strcmp(dev_name(dev), "4809c000.mmc"))
 			mmc->f_max = 96000000;
diff --git a/drivers/mmc/host/sdhci_am654.c b/drivers/mmc/host/sdhci_am654.c
index 1fad6e442688..c0d1a0eab939 100644
--- a/drivers/mmc/host/sdhci_am654.c
+++ b/drivers/mmc/host/sdhci_am654.c
@@ -787,7 +787,7 @@ static int sdhci_am654_probe(struct platform_device *pdev)
 
 	/* Update drvdata based on SoC revision */
 	soc = soc_device_match(sdhci_am654_devices);
-	if (soc && soc->data)
+	if (!IS_ERR(soc) && soc && soc->data)
 		drvdata = soc->data;
 
 	host = sdhci_pltfm_init(pdev, drvdata->pdata, sizeof(*sdhci_am654));
diff --git a/drivers/net/ethernet/renesas/ravb_main.c b/drivers/net/ethernet/renesas/ravb_main.c
index 8c84c40ab9a0..f9e1cafe9b1a 100644
--- a/drivers/net/ethernet/renesas/ravb_main.c
+++ b/drivers/net/ethernet/renesas/ravb_main.c
@@ -1016,6 +1016,7 @@ static int ravb_phy_init(struct net_device *ndev)
 	struct ravb_private *priv = netdev_priv(ndev);
 	struct phy_device *phydev;
 	struct device_node *pn;
+	const struct soc_device_attribute *soc;
 	phy_interface_t iface;
 	int err;
 
@@ -1049,7 +1050,8 @@ static int ravb_phy_init(struct net_device *ndev)
 	/* This driver only support 10/100Mbit speeds on R-Car H3 ES1.0
 	 * at this time.
 	 */
-	if (soc_device_match(r8a7795es10)) {
+	soc = soc_device_match(r8a7795es10);
+	if (!IS_ERR(soc) && soc) {
 		err = phy_set_max_speed(phydev, SPEED_100);
 		if (err) {
 			netdev_err(ndev, "failed to limit PHY to 100Mbit/s\n");
diff --git a/drivers/net/ethernet/ti/am65-cpsw-nuss.c b/drivers/net/ethernet/ti/am65-cpsw-nuss.c
index 6a67b026df0b..01c1e5b573fa 100644
--- a/drivers/net/ethernet/ti/am65-cpsw-nuss.c
+++ b/drivers/net/ethernet/ti/am65-cpsw-nuss.c
@@ -2596,7 +2596,7 @@ static void am65_cpsw_nuss_apply_socinfo(struct am65_cpsw_common *common)
 	const struct soc_device_attribute *soc;
 
 	soc = soc_device_match(am65_cpsw_socinfo);
-	if (soc && soc->data) {
+	if (!IS_ERR(soc) && soc && soc->data) {
 		const struct am65_cpsw_soc_pdata *socdata = soc->data;
 
 		/* disable quirks */
diff --git a/drivers/net/ethernet/ti/cpsw.c b/drivers/net/ethernet/ti/cpsw.c
index c0cd7de88316..12bb62ed0fe9 100644
--- a/drivers/net/ethernet/ti/cpsw.c
+++ b/drivers/net/ethernet/ti/cpsw.c
@@ -1579,7 +1579,7 @@ static int cpsw_probe(struct platform_device *pdev)
 		goto clean_dt_ret;
 
 	soc = soc_device_match(cpsw_soc_devices);
-	if (soc)
+	if (!IS_ERR(soc) && soc)
 		cpsw->quirk_irq = true;
 
 	data = &cpsw->data;
diff --git a/drivers/net/ethernet/ti/cpsw_new.c b/drivers/net/ethernet/ti/cpsw_new.c
index 69b7a4e0220a..2b82a3e4a3cc 100644
--- a/drivers/net/ethernet/ti/cpsw_new.c
+++ b/drivers/net/ethernet/ti/cpsw_new.c
@@ -1925,7 +1925,7 @@ static int cpsw_probe(struct platform_device *pdev)
 		goto clean_dt_ret;
 
 	soc = soc_device_match(cpsw_soc_devices);
-	if (soc)
+	if (!IS_ERR(soc) && soc)
 		cpsw->quirk_irq = true;
 
 	cpsw->rx_packet_max = rx_packet_max;
diff --git a/drivers/phy/ti/phy-omap-usb2.c b/drivers/phy/ti/phy-omap-usb2.c
index ebceb1520ce8..d7346d0ea9ed 100644
--- a/drivers/phy/ti/phy-omap-usb2.c
+++ b/drivers/phy/ti/phy-omap-usb2.c
@@ -348,6 +348,7 @@ static void omap_usb2_init_errata(struct omap_usb *phy)
 		{ .family = "AM65X", .revision = "SR1.0" },
 		{ /* sentinel */ }
 	};
+	const struct soc_device_attribute *soc;
 
 	/*
 	 * Errata i2075: USB2PHY: USB2PHY Charger Detect is Enabled by
@@ -358,7 +359,8 @@ static void omap_usb2_init_errata(struct omap_usb *phy)
 	 * Disabling the USB2_PHY Charger Detect function will put D+
 	 * into the normal state.
 	 */
-	if (soc_device_match(am65x_sr10_soc_devices))
+	soc = soc_device_match(am65x_sr10_soc_devices);
+	if (!IS_ERR(soc) && soc)
 		phy->flags |= OMAP_USB2_DISABLE_CHRG_DET;
 }
 
diff --git a/drivers/pinctrl/renesas/core.c b/drivers/pinctrl/renesas/core.c
index 5ccc49b387f1..758444e0a620 100644
--- a/drivers/pinctrl/renesas/core.c
+++ b/drivers/pinctrl/renesas/core.c
@@ -1102,7 +1102,7 @@ static const void *sh_pfc_quirk_match(void)
 	};
 
 	match = soc_device_match(quirks);
-	if (match)
+	if (!IS_ERR(match) && match)
 		return match->data ?: ERR_PTR(-ENODEV);
 #endif /* CONFIG_PINCTRL_PFC_R8A77950 || CONFIG_PINCTRL_PFC_R8A77951 */
 
diff --git a/drivers/pinctrl/renesas/pfc-r8a7790.c b/drivers/pinctrl/renesas/pfc-r8a7790.c
index e9a64e0e2734..57044d338fd5 100644
--- a/drivers/pinctrl/renesas/pfc-r8a7790.c
+++ b/drivers/pinctrl/renesas/pfc-r8a7790.c
@@ -5999,8 +5999,11 @@ static const struct soc_device_attribute r8a7790_tdsel[] = {
 
 static int r8a7790_pinmux_soc_init(struct sh_pfc *pfc)
 {
+	const struct soc_device_attribute *match;
+
 	/* Initialize TDSEL on old revisions */
-	if (soc_device_match(r8a7790_tdsel))
+	match = soc_device_match(r8a7790_tdsel);
+	if (!IS_ERR(match) && match)
 		sh_pfc_write(pfc, 0xe6060088, 0x00155554);
 
 	return 0;
diff --git a/drivers/pinctrl/renesas/pfc-r8a7794.c b/drivers/pinctrl/renesas/pfc-r8a7794.c
index 34481b6c4328..fb9a714dec1d 100644
--- a/drivers/pinctrl/renesas/pfc-r8a7794.c
+++ b/drivers/pinctrl/renesas/pfc-r8a7794.c
@@ -5587,8 +5587,11 @@ static const struct soc_device_attribute r8a7794_tdsel[] = {
 
 static int r8a7794_pinmux_soc_init(struct sh_pfc *pfc)
 {
+	const struct soc_device_attribute *match;
+
 	/* Initialize TDSEL on old revisions */
-	if (soc_device_match(r8a7794_tdsel))
+	match = soc_device_match(r8a7794_tdsel);
+	if (!IS_ERR(match) && match)
 		sh_pfc_write(pfc, 0xe6060068, 0x55555500);
 
 	return 0;
diff --git a/drivers/soc/fsl/dpio/dpio-driver.c b/drivers/soc/fsl/dpio/dpio-driver.c
index 7f397b4ad878..01e3d1ca54df 100644
--- a/drivers/soc/fsl/dpio/dpio-driver.c
+++ b/drivers/soc/fsl/dpio/dpio-driver.c
@@ -55,14 +55,19 @@ static const struct soc_device_attribute lx2160a_soc[] = {
 
 static int dpaa2_dpio_get_cluster_sdest(struct fsl_mc_device *dpio_dev, int cpu)
 {
+	const struct soc_device_attribute *match1, *match2, *match3, *match4;
 	int cluster_base, cluster_size;
 
-	if (soc_device_match(ls1088a_soc)) {
+	match1 = soc_device_match(ls1088a_soc);
+	match2 = soc_device_match(ls2080a_soc);
+	match3 = soc_device_match(ls2088a_soc);
+	match4 = soc_device_match(lx2160a_soc);
+	if (!IS_ERR(match1) && match1) {
 		cluster_base = 2;
 		cluster_size = 4;
-	} else if (soc_device_match(ls2080a_soc) ||
-		   soc_device_match(ls2088a_soc) ||
-		   soc_device_match(lx2160a_soc)) {
+	} else if ((!IS_ERR(match2) && match2) ||
+		   (!IS_ERR(match3) && match3) ||
+		   (!IS_ERR(match4) && match4)) {
 		cluster_base = 0;
 		cluster_size = 2;
 	} else {
diff --git a/drivers/soc/renesas/r8a774c0-sysc.c b/drivers/soc/renesas/r8a774c0-sysc.c
index c1c216f7d073..6b0b092c1b45 100644
--- a/drivers/soc/renesas/r8a774c0-sysc.c
+++ b/drivers/soc/renesas/r8a774c0-sysc.c
@@ -36,7 +36,10 @@ static const struct soc_device_attribute r8a774c0[] __initconst = {
 
 static int __init r8a774c0_sysc_init(void)
 {
-	if (soc_device_match(r8a774c0)) {
+	const struct soc_device_attribute *match;
+
+	match = soc_device_match(r8a774c0);
+	if (!IS_ERR(match) && match) {
 		/* Fix incorrect 3DG hierarchy */
 		swap(r8a774c0_areas[6], r8a774c0_areas[7]);
 		r8a774c0_areas[6].parent = R8A774C0_PD_ALWAYS_ON;
diff --git a/drivers/soc/renesas/r8a7795-sysc.c b/drivers/soc/renesas/r8a7795-sysc.c
index 91074411b8cf..7d5dcfcb1d09 100644
--- a/drivers/soc/renesas/r8a7795-sysc.c
+++ b/drivers/soc/renesas/r8a7795-sysc.c
@@ -74,7 +74,7 @@ static int __init r8a7795_sysc_init(void)
 	u32 quirks = 0;
 
 	attr = soc_device_match(r8a7795_quirks_match);
-	if (attr)
+	if (!IS_ERR(attr) && attr)
 		quirks = (uintptr_t)attr->data;
 
 	if (!(quirks & HAS_A2VC0))
diff --git a/drivers/soc/renesas/r8a77990-sysc.c b/drivers/soc/renesas/r8a77990-sysc.c
index 9f92737dc352..10353afe061d 100644
--- a/drivers/soc/renesas/r8a77990-sysc.c
+++ b/drivers/soc/renesas/r8a77990-sysc.c
@@ -36,7 +36,10 @@ static const struct soc_device_attribute r8a77990[] __initconst = {
 
 static int __init r8a77990_sysc_init(void)
 {
-	if (soc_device_match(r8a77990)) {
+	const struct soc_device_attribute *match;
+
+	match = soc_device_match(r8a77990);
+	if (!IS_ERR(match) && match) {
 		/* Fix incorrect 3DG hierarchy */
 		swap(r8a77990_areas[7], r8a77990_areas[8]);
 		r8a77990_areas[7].parent = R8A77990_PD_ALWAYS_ON;
diff --git a/drivers/soc/ti/k3-ringacc.c b/drivers/soc/ti/k3-ringacc.c
index 312ba0f98ad7..f4a08992e827 100644
--- a/drivers/soc/ti/k3-ringacc.c
+++ b/drivers/soc/ti/k3-ringacc.c
@@ -1368,7 +1368,7 @@ static int k3_ringacc_init(struct platform_device *pdev,
 		return ret;
 
 	soc = soc_device_match(k3_ringacc_socinfo);
-	if (soc && soc->data) {
+	if (!IS_ERR(soc) && soc && soc->data) {
 		const struct k3_ringacc_soc_data *soc_data = soc->data;
 
 		ringacc->dma_ring_reset_quirk = soc_data->dma_ring_reset_quirk;
diff --git a/drivers/staging/mt7621-pci/pci-mt7621.c b/drivers/staging/mt7621-pci/pci-mt7621.c
index 115250115f10..34ce3c8eb9fc 100644
--- a/drivers/staging/mt7621-pci/pci-mt7621.c
+++ b/drivers/staging/mt7621-pci/pci-mt7621.c
@@ -667,7 +667,7 @@ static int mt7621_pci_probe(struct platform_device *pdev)
 	INIT_LIST_HEAD(&pcie->ports);
 
 	attr = soc_device_match(mt7621_pci_quirks_match);
-	if (attr)
+	if (!IS_ERR(attr) && attr)
 		pcie->resets_inverted = true;
 
 	err = mt7621_pcie_parse_dt(pcie);
diff --git a/drivers/thermal/rcar_gen3_thermal.c b/drivers/thermal/rcar_gen3_thermal.c
index e1e412348076..ada3cc5adc02 100644
--- a/drivers/thermal/rcar_gen3_thermal.c
+++ b/drivers/thermal/rcar_gen3_thermal.c
@@ -310,6 +310,7 @@ static int rcar_gen3_thermal_probe(struct platform_device *pdev)
 	const int *rcar_gen3_ths_tj_1 = of_device_get_match_data(dev);
 	struct resource *res;
 	struct thermal_zone_device *zone;
+	const struct soc_device_attribute *attr;
 	int ret, i;
 
 	/* default values if FUSEs are missing */
@@ -321,7 +322,8 @@ static int rcar_gen3_thermal_probe(struct platform_device *pdev)
 		return -ENOMEM;
 
 	priv->thermal_init = rcar_gen3_thermal_init;
-	if (soc_device_match(r8a7795es1))
+	attr = soc_device_match(r8a7795es1);
+	if (!IS_ERR(attr) && attr)
 		priv->thermal_init = rcar_gen3_thermal_init_r8a7795es1;
 
 	platform_set_drvdata(pdev, priv);
diff --git a/drivers/thermal/ti-soc-thermal/ti-bandgap.c b/drivers/thermal/ti-soc-thermal/ti-bandgap.c
index d81af89166d2..eb9b7bcbd934 100644
--- a/drivers/thermal/ti-soc-thermal/ti-bandgap.c
+++ b/drivers/thermal/ti-soc-thermal/ti-bandgap.c
@@ -886,6 +886,9 @@ static const struct soc_device_attribute soc_no_cpu_notifier[] = {
 static
 int ti_bandgap_probe(struct platform_device *pdev)
 {
+#ifdef CONFIG_PM_SLEEP
+	const struct soc_device_attribute *match;
+#endif
 	struct ti_bandgap *bgp;
 	int clk_rate, ret, i;
 
@@ -1037,7 +1040,8 @@ int ti_bandgap_probe(struct platform_device *pdev)
 
 #ifdef CONFIG_PM_SLEEP
 	bgp->nb.notifier_call = bandgap_omap_cpu_notifier;
-	if (!soc_device_match(soc_no_cpu_notifier))
+	match = soc_device_match(soc_no_cpu_notifier);
+	if (!IS_ERR(match) && !match)
 		cpu_pm_register_notifier(&bgp->nb);
 #endif
 
@@ -1072,9 +1076,11 @@ static
 int ti_bandgap_remove(struct platform_device *pdev)
 {
 	struct ti_bandgap *bgp = platform_get_drvdata(pdev);
+	const struct soc_device_attribute *attr;
 	int i;
 
-	if (!soc_device_match(soc_no_cpu_notifier))
+	soc = soc_device_match(soc_no_cpu_notifier);
+	if (!IS_ERR(attr) && !attr)
 		cpu_pm_unregister_notifier(&bgp->nb);
 
 	/* Remove sensor interfaces */
diff --git a/drivers/usb/gadget/udc/renesas_usb3.c b/drivers/usb/gadget/udc/renesas_usb3.c
index 0c418ce50ba0..dfc73e0187bd 100644
--- a/drivers/usb/gadget/udc/renesas_usb3.c
+++ b/drivers/usb/gadget/udc/renesas_usb3.c
@@ -2753,7 +2753,7 @@ static int renesas_usb3_probe(struct platform_device *pdev)
 	const struct soc_device_attribute *attr;
 
 	attr = soc_device_match(renesas_usb3_quirks_match);
-	if (attr)
+	if (!IS_ERR(attr) && attr)
 		priv = attr->data;
 	else
 		priv = of_device_get_match_data(&pdev->dev);
diff --git a/drivers/usb/host/ehci-platform.c b/drivers/usb/host/ehci-platform.c
index c70f2d0b4aaf..5d9cd7797ec1 100644
--- a/drivers/usb/host/ehci-platform.c
+++ b/drivers/usb/host/ehci-platform.c
@@ -243,6 +243,7 @@ static int ehci_platform_probe(struct platform_device *dev)
 	struct usb_ehci_pdata *pdata = dev_get_platdata(&dev->dev);
 	struct ehci_platform_priv *priv;
 	struct ehci_hcd *ehci;
+	const struct soc_device_attribute *match;
 	int err, irq, clk = 0;
 
 	if (usb_disabled())
@@ -297,7 +298,8 @@ static int ehci_platform_probe(struct platform_device *dev)
 					  "has-transaction-translator"))
 			hcd->has_tt = 1;
 
-		if (soc_device_match(quirk_poll_match))
+		match = soc_device_match(quirk_poll_match);
+		if (!IS_ERR(match) && match)
 			priv->quirk_poll = true;
 
 		for (clk = 0; clk < EHCI_MAX_CLKS; clk++) {
diff --git a/drivers/usb/host/xhci-rcar.c b/drivers/usb/host/xhci-rcar.c
index 1bc4fe7b8c75..41bb59d0e975 100644
--- a/drivers/usb/host/xhci-rcar.c
+++ b/drivers/usb/host/xhci-rcar.c
@@ -135,7 +135,7 @@ static int xhci_rcar_download_firmware(struct usb_hcd *hcd)
 	const char *firmware_name;
 
 	attr = soc_device_match(rcar_quirks_match);
-	if (attr)
+	if (!IS_ERR(attr) && attr)
 		quirks = (uintptr_t)attr->data;
 
 	if (quirks & RCAR_XHCI_FIRMWARE_V2)
diff --git a/drivers/watchdog/renesas_wdt.c b/drivers/watchdog/renesas_wdt.c
index 5791198960e6..fdc534dc4024 100644
--- a/drivers/watchdog/renesas_wdt.c
+++ b/drivers/watchdog/renesas_wdt.c
@@ -197,7 +197,7 @@ static bool rwdt_blacklisted(struct device *dev)
 	const struct soc_device_attribute *attr;
 
 	attr = soc_device_match(rwdt_quirks_match);
-	if (attr && setup_max_cpus > (uintptr_t)attr->data) {
+	if (!IS_ERR(attr) && attr && setup_max_cpus > (uintptr_t)attr->data) {
 		dev_info(dev, "Watchdog blacklisted on %s %s\n", attr->soc_id,
 			 attr->revision);
 		return true;
-- 
2.17.1


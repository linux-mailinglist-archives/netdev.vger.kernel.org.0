Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0A18C363A73
	for <lists+netdev@lfdr.de>; Mon, 19 Apr 2021 06:27:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232671AbhDSE2I (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Apr 2021 00:28:08 -0400
Received: from mail-eopbgr00061.outbound.protection.outlook.com ([40.107.0.61]:63985
        "EHLO EUR02-AM5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229473AbhDSE2C (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 19 Apr 2021 00:28:02 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=BIfUylbF1u6g42Ih0vw50xP6D7xRSLWW2I9zIv8xpPfI+8QTA+Yvqs8rcEhgkShhN1F5VCTfikyuN00lU7MYQpLyAi61zSBXde+lBtKtZ91KF4JkDryrkKImQc4jtArTgkvv22rGSlWBi+316rG07ozzVX8yH+lrNaB4Y76q0iQ4zUQW6K3d9JzIJkWsU1QsvjfqMy2v6XzsDlch5VnExSBZi1Fditx7GwrKrLI7E/sfpEmjrnivx/IpLa9EXSocY6lD/yML7X4WAKNF1EY300fyMYpWitucXgZ/XL8CLbbwDx1OQw7Fi2QoTb2TSXTWyC1GIFPgb1qOvwl4cLPWlA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=EGsFEeNS52w1ZRf0E7RmTdDzsa/XGegT9oBy+olcLfY=;
 b=hGFFrgJo2nl82ALdcCWukVL33RkUM6iFcTbkS0Q6cbKM62pdvYnFsqLLOtlF+2o2VdYauLw4dwP2SOeHtc3aZK7MlLjtddm7LhJTrWTkIj6VkevHMcvevTOm0Iaa1xW8T6J+3i8PR8ODJ/vsRcMpNN5h52SiwRYematUkUoYYgadgMtAVfcWh/leBm2L8Tg51aG1SFFROj7+y2jsXIW81DOM/gOKW31vHMKMqX6qmnynX8F75iYwa4zb9oeycrCf1V0DNBxu5cGiiQ81HZj1l4KbQ6UDlERn6Pd76e3un4zKWXsAtWQNRqdFc0IAvJ55fTvey3xfXI4mXsOkubJDog==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oss.nxp.com; dmarc=pass action=none header.from=oss.nxp.com;
 dkim=pass header.d=oss.nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=NXP1.onmicrosoft.com;
 s=selector2-NXP1-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=EGsFEeNS52w1ZRf0E7RmTdDzsa/XGegT9oBy+olcLfY=;
 b=j+dOYrXfIk7Kfa0Fobi8pj2zSP1kRkdYvZPRfIcM8F+/XY2p5O6m146Lg8uw11qr8f1XCxfgzTkNhGiUBKIwzqfro+IOGzrsiOB/EFGQjxCT+tmokcK5gMw090mHbYn4cAawbUShERe9QsYw1J905qk2uPKxj/G1mOjHNwIbMt4=
Authentication-Results: linuxfoundation.org; dkim=none (message not signed)
 header.d=none;linuxfoundation.org; dmarc=none action=none
 header.from=oss.nxp.com;
Received: from AM6PR04MB6053.eurprd04.prod.outlook.com (2603:10a6:20b:b9::10)
 by AS8PR04MB7912.eurprd04.prod.outlook.com (2603:10a6:20b:2ae::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4042.16; Mon, 19 Apr
 2021 04:27:06 +0000
Received: from AM6PR04MB6053.eurprd04.prod.outlook.com
 ([fe80::b034:690:56aa:7b18]) by AM6PR04MB6053.eurprd04.prod.outlook.com
 ([fe80::b034:690:56aa:7b18%4]) with mapi id 15.20.4042.024; Mon, 19 Apr 2021
 04:26:59 +0000
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
Subject: [RFC v1 PATCH 0/3] support soc_device_match to return -EPROBE_DEFER
Date:   Mon, 19 Apr 2021 12:27:19 +0800
Message-Id: <20210419042722.27554-1-alice.guo@oss.nxp.com>
X-Mailer: git-send-email 2.17.1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Originating-IP: [119.31.174.71]
X-ClientProxiedBy: AM0PR02CA0207.eurprd02.prod.outlook.com
 (2603:10a6:20b:28f::14) To AM6PR04MB6053.eurprd04.prod.outlook.com
 (2603:10a6:20b:b9::10)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from nxf55104-OptiPlex-7060.ap.freescale.net (119.31.174.71) by AM0PR02CA0207.eurprd02.prod.outlook.com (2603:10a6:20b:28f::14) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4042.19 via Frontend Transport; Mon, 19 Apr 2021 04:26:40 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 9896ff12-c5b4-421f-f9a1-08d902eb5f30
X-MS-TrafficTypeDiagnostic: AS8PR04MB7912:
X-MS-Exchange-SharedMailbox-RoutingAgent-Processed: True
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <AS8PR04MB7912513CE4C6A5F1A16187D3A3499@AS8PR04MB7912.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: AK1XnEs7EIU/2ApqujL4ENEsdD7cfE1FbgcvAaPgea6Hbv0vJgmkFlrJQc9Zwe0hRvg6ODWJqw7DeYSJRkwBUI6Dg9CvBg76tQsc/zECgFN9N0rU1PraAub2z1SmPXooxUEKWedxX5mry6PHesrXtLa56siBXEvmuwr/ay92Ty2P7nHxHjCjlwvncBhFzscBGAd2Tlz6ly4vsWI7jjwFt5zemq9s1tZzujO+pRaFFN0jLicObMUjXbOCYpNjld7qp3nLx4wkcfdipmjFsCJXiTk+x7LXtjQ3SFz3tJFe1/gciMsGU9oMwC2wF7hUdL1RdpiZLDgJVep6zFnA56/ISZh0nJOUfxYyH5cueA1KZK3QNB6PMI7kZ0ex8+hoQL0dXjtTG6c4tOkauz1CuRnqiQ/2rBiwXb+SekuC44XZa1J4ady1C9t8Mg9honhFO5TtLtkNxiEbL90A14r7TxjM2Q61qy6OxOtFSpF1+lPl2Gkvxu+yivq0TNugxczd2YY6WAE1PONiwqP0D3oJlk28nEJrxZ1QsCEJrWIDpRmBdvt7cHDmn2IGnX0rbRNtHwm5Vj50Bwo2EmrqFvgMs/NwPESfADARD49yW+UCIFJAQxRl681Nbj7s55lka7wcQkZinoUggVYz1CbaryPIzm2Z/V/Nb1WtEpnxWWjL8aF5R7M=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM6PR04MB6053.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(376002)(346002)(136003)(396003)(366004)(39860400002)(1076003)(66946007)(7406005)(478600001)(52116002)(66556008)(66476007)(2906002)(7366002)(7416002)(8936002)(921005)(8676002)(4326008)(5660300002)(16526019)(26005)(38100700002)(83380400001)(956004)(2616005)(38350700002)(6486002)(6666004)(6506007)(6512007)(186003)(316002)(86362001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?aVdtSGVXV002Y2NaaDlsL2RhYzBTbFFsLzI0RnNqcmI3U2hjTTg1LzQvMEFx?=
 =?utf-8?B?VE0ySXJiSmRSNEVPMG9SZ1p4OUxzb3hSbGkwK1VuZmJzcExSUkVXbmp1dUR1?=
 =?utf-8?B?WlNoVFVCdmFpdEZ5KzNjV3ZhdkwrUG10L3IzQ3ViMndabVJPMHVjTUlLb210?=
 =?utf-8?B?OTdnNFhLVUd6TEpwajVpdzdFaFRzVTVaTXUvMWFwa1J3V0RuS3FBalV6bkMw?=
 =?utf-8?B?REtXbEh0RGR4cGlxMHpxN1ZmNFBmT3dBR285Q2k2QjZUSU9mUDZ4VzgvelpR?=
 =?utf-8?B?bVhwVGZsT0hITTdha09TVnoyYnZCWVQvdUFhemJibnB4UXp1UTd3Z21xWHNO?=
 =?utf-8?B?S2VDRm1oandzWHpTVjc0Qks2NFpuYmsxaUpRRlMyTTVhVHNvTXVJN0cvZURD?=
 =?utf-8?B?c294ODZVaDdHb2ZRaVRNQXV4N1B4dmgxcHM5NXh4UFRVYWlGdTRmeTYwVjRX?=
 =?utf-8?B?elpNU3VUMzNud2UrNFlxRFpQUytHVmorOFRRb2N6dlVMQ0t4Vmdua2lVQy80?=
 =?utf-8?B?dWRZMDBJdWNZRjJZRlVRWlZKczdaK1hPSFlxOWJ0cC94aFo0eEk4czhkZDA2?=
 =?utf-8?B?Q0NCdExiWXFGb1B3U3YyeXFRYjZjdmpTM1RJYTZIaVhiY1JTRDFVcXNobUIr?=
 =?utf-8?B?Q3dDS2xHTHNZd1A5dy9rS29Jc0MvSVhMeU9LeFU1WllrSi9ZVFNoQWJvcHNw?=
 =?utf-8?B?NlpKOFZXdnd1Y2YzcEJoOW1JYTVMRFhwcjdJQUlKRUp1S1RPUmd5L0R5cXAz?=
 =?utf-8?B?WVRSbnRsNmZUM2hTeVRHdFdpdCtIMkJkZ0x2aitSdTJPVjNCTVRaU0w1dzBR?=
 =?utf-8?B?SnNqZHBVREdVb25lVHVzTlpZSFcxMjRGb2JZNFhvU1hjc0tXWHk3clJMTEt5?=
 =?utf-8?B?YVdqNEp0NENmT0RTcTNFZ3dWUjc4Z0UwUkdTSGdKeUNXRi94ZEI0RFQrTTdW?=
 =?utf-8?B?UVVZY1pTSVpyMkg5VEZVM1hMUmdXTWF4WDJ3UTN3dEZzRmpEQUhrMTNtY2tM?=
 =?utf-8?B?dHVOSitKdWpYWWcybmprNUl1N2Eyclp1T29rUlRsVnNIdzJmeVBSdjloTVhN?=
 =?utf-8?B?RXk2cXZIR2RsQ2pBMHRreUw1TnBLYUZOWENzSGtTUXlnZlFnSDJUNXR1QzVV?=
 =?utf-8?B?YVJlbXZFMFVFTXZjOVRtQlJlMkJXTzNad0NPRjlkRGd5UzlXdGRMd2FEdUFk?=
 =?utf-8?B?bTJSVGVueTk1Q290MmFSN1dkSzlCYWxhVnhqZUdYb3Q1RTQ1eldkbkdVa1N6?=
 =?utf-8?B?TXovZERmclBxY0xjemkrbUNHVjRNMU1GOW4vMXFjc3pnR0wrd201dmpqSllU?=
 =?utf-8?B?SVIxV2Y2MlhaU2svdzVvMldRcUdyK2hRVitkUUpPeVd1S2hNNlRxMkpSUDE1?=
 =?utf-8?B?OUY0UEFoUmNEMWVCdS9aeUFURG56bngrYWVSMUJoTFhSMmVqdjAvM05mblVn?=
 =?utf-8?B?bVYxYm5LeWNXbWNGeHFZQXdBZlZHd2JXbTFhWVNWR2taTzZnQTZQV2hVOFhJ?=
 =?utf-8?B?QjMyYXNTcy9ab0x3eHdhS3lUd2pQUkJZWXFocU14Q2tTTGFwY3ZvZWlzYkpk?=
 =?utf-8?B?ZkFwMXI0VHlxRXZ5SkdtZW1iMW04blZWTlVuWWRtV1MydkdTYUp4UDF0ZkVq?=
 =?utf-8?B?V3hJSm1UQ0Jqc2xqSkNXZ2ZWT05JdVBKQStUVzI5RWRwU2dvRVcybXh5cWFy?=
 =?utf-8?B?TllJSDNqVENVSExBZmVSd3g0NzJvenVsUUZVU3dpbGhISjd6WmlmYytnNEpN?=
 =?utf-8?Q?QGHOnxCgvOAwMkAbgHRHefjr/WYqcT969phCLa9?=
X-OriginatorOrg: oss.nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9896ff12-c5b4-421f-f9a1-08d902eb5f30
X-MS-Exchange-CrossTenant-AuthSource: AM6PR04MB6053.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Apr 2021 04:26:59.4616
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 1IYHRUj96ZFPUGM224m5kKukwj6GivUjSaU/anOesbfoQxqSi1R6BEaAG0+PdVaFc474JX9J+PecEtTuEmLjOw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS8PR04MB7912
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Alice Guo <alice.guo@nxp.com>

In patch "soc: imx8m: change to use platform driver", change soc-imx8m.c to use
module platform driver and use NVMEM APIs to ocotp register, the reason is that
directly reading ocotp egister causes kexec kernel hang because kernel will
disable unused clks after kernel boots up. This patch makes the SoC driver
ready. This patch makes the SoC driver ready later than before, and causes device
depends on soc_device_match() for initialization are affected, resulting in
kernel boot error.

CAAM driver is one of these affected drivers. It uses soc_device_match() to find
the first matching entry of caam_imx_soc_table, if none of them match, the next
instruction will be executed without any processing because CAAM driver is used
not only on i.MX and LS, but also PPC and Vybrid. We hope that
soc_device_match() could support to return -EPROBE_DEFER(or some other error
code, e.g. -ENODEV, but not NULL) in case of “no SoC device registered” to SoC
bus. We tried it and updated all the code that is using soc_device_match()
throughout the tree.

Alice Guo (3):
  drivers: soc: add support for soc_device_match returning -EPROBE_DEFER
  caam: add defer probe when the caam driver cannot identify SoC
  driver: update all the code that use soc_device_match

 drivers/base/soc.c                            |  5 +++++
 drivers/bus/ti-sysc.c                         |  2 +-
 drivers/clk/renesas/r8a7795-cpg-mssr.c        |  4 +++-
 drivers/clk/renesas/rcar-gen2-cpg.c           |  2 +-
 drivers/clk/renesas/rcar-gen3-cpg.c           |  2 +-
 drivers/crypto/caam/ctrl.c                    |  3 +++
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
 50 files changed, 139 insertions(+), 52 deletions(-)

-- 
2.17.1


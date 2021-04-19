Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 72D5E363ACF
	for <lists+netdev@lfdr.de>; Mon, 19 Apr 2021 07:02:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233046AbhDSFCv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Apr 2021 01:02:51 -0400
Received: from mail.kernel.org ([198.145.29.99]:50526 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229473AbhDSFCs (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 19 Apr 2021 01:02:48 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 65BC961078;
        Mon, 19 Apr 2021 05:02:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1618808539;
        bh=srAR5o/oGq5ioibP/eXNEOXMJgehSJWXVDMJHT8j86M=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Q2aSyWKadyluHjWWN1SwyxF3iNnBxBRV4eFwfMyHPgeuOCbx3zVu4VA/PQblKt1mX
         LG/8Qa12wOxexoPdM1AtRUqEwffA6hhUzg5XvoNYf5i8CVaEzIb5aHKsxdmdIZ0VNh
         EB/GtCUOovxwGQ5QiY5CwzbiGBepA6YRCHaOc9bFp2O+m0lnHel/QMKuqas1XJG+Ml
         vece3azY0OPvilnrF9TxEM4Y2QEUh42RCB/qgDYU4n+IIRFMdKunRACTXFpDc2oJTx
         Tw4u0mxUHQNeAMruPlzpJF4CCm1VJVvyur9NU2SbLDowYlZY9RFqgpKroyAxadDiZV
         1t4tD3zjj0ZKQ==
Date:   Mon, 19 Apr 2021 08:02:15 +0300
From:   Leon Romanovsky <leon@kernel.org>
To:     "Alice Guo (OSS)" <alice.guo@oss.nxp.com>
Cc:     gregkh@linuxfoundation.org, rafael@kernel.org,
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
        linux@roeck-us.net, linux-kernel@vger.kernel.org,
        linux-crypto@vger.kernel.org, linux-omap@vger.kernel.org,
        linux-renesas-soc@vger.kernel.org, linux-clk@vger.kernel.org,
        dmaengine@vger.kernel.org, dri-devel@lists.freedesktop.org,
        linux-amlogic@lists.infradead.org,
        linux-arm-kernel@lists.infradead.org,
        iommu@lists.linux-foundation.org, linux-media@vger.kernel.org,
        linux-mmc@vger.kernel.org, netdev@vger.kernel.org,
        linux-phy@lists.infradead.org, linux-gpio@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org, linux-staging@lists.linux.dev,
        linux-mediatek@lists.infradead.org, linux-pm@vger.kernel.org,
        linux-usb@vger.kernel.org, linux-watchdog@vger.kernel.org
Subject: Re: [RFC v1 PATCH 3/3] driver: update all the code that use
 soc_device_match
Message-ID: <YH0O1104YEdjY9mb@unreal>
References: <20210419042722.27554-1-alice.guo@oss.nxp.com>
 <20210419042722.27554-4-alice.guo@oss.nxp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210419042722.27554-4-alice.guo@oss.nxp.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Apr 19, 2021 at 12:27:22PM +0800, Alice Guo (OSS) wrote:
> From: Alice Guo <alice.guo@nxp.com>
> 
> Update all the code that use soc_device_match because add support for
> soc_device_match returning -EPROBE_DEFER.
> 
> Signed-off-by: Alice Guo <alice.guo@nxp.com>
> ---
>  drivers/bus/ti-sysc.c                         |  2 +-
>  drivers/clk/renesas/r8a7795-cpg-mssr.c        |  4 +++-
>  drivers/clk/renesas/rcar-gen2-cpg.c           |  2 +-
>  drivers/clk/renesas/rcar-gen3-cpg.c           |  2 +-
>  drivers/dma/fsl-dpaa2-qdma/dpaa2-qdma.c       |  7 ++++++-
>  drivers/dma/ti/k3-psil.c                      |  3 +++
>  drivers/dma/ti/k3-udma.c                      |  2 +-
>  drivers/gpu/drm/bridge/nwl-dsi.c              |  2 +-
>  drivers/gpu/drm/meson/meson_drv.c             |  4 +++-
>  drivers/gpu/drm/omapdrm/dss/dispc.c           |  2 +-
>  drivers/gpu/drm/omapdrm/dss/dpi.c             |  4 +++-
>  drivers/gpu/drm/omapdrm/dss/dsi.c             |  3 +++
>  drivers/gpu/drm/omapdrm/dss/dss.c             |  3 +++
>  drivers/gpu/drm/omapdrm/dss/hdmi4_core.c      |  3 +++
>  drivers/gpu/drm/omapdrm/dss/venc.c            |  4 +++-
>  drivers/gpu/drm/omapdrm/omap_drv.c            |  3 +++
>  drivers/gpu/drm/rcar-du/rcar_du_crtc.c        |  4 +++-
>  drivers/gpu/drm/rcar-du/rcar_lvds.c           |  2 +-
>  drivers/gpu/drm/tidss/tidss_dispc.c           |  4 +++-
>  drivers/iommu/ipmmu-vmsa.c                    |  7 +++++--
>  drivers/media/platform/rcar-vin/rcar-core.c   |  2 +-
>  drivers/media/platform/rcar-vin/rcar-csi2.c   |  2 +-
>  drivers/media/platform/vsp1/vsp1_uif.c        |  4 +++-
>  drivers/mmc/host/renesas_sdhi_core.c          |  2 +-
>  drivers/mmc/host/renesas_sdhi_internal_dmac.c |  2 +-
>  drivers/mmc/host/sdhci-of-esdhc.c             | 21 ++++++++++++++-----
>  drivers/mmc/host/sdhci-omap.c                 |  2 +-
>  drivers/mmc/host/sdhci_am654.c                |  2 +-
>  drivers/net/ethernet/renesas/ravb_main.c      |  4 +++-
>  drivers/net/ethernet/ti/am65-cpsw-nuss.c      |  2 +-
>  drivers/net/ethernet/ti/cpsw.c                |  2 +-
>  drivers/net/ethernet/ti/cpsw_new.c            |  2 +-
>  drivers/phy/ti/phy-omap-usb2.c                |  4 +++-
>  drivers/pinctrl/renesas/core.c                |  2 +-
>  drivers/pinctrl/renesas/pfc-r8a7790.c         |  5 ++++-
>  drivers/pinctrl/renesas/pfc-r8a7794.c         |  5 ++++-
>  drivers/soc/fsl/dpio/dpio-driver.c            | 13 ++++++++----
>  drivers/soc/renesas/r8a774c0-sysc.c           |  5 ++++-
>  drivers/soc/renesas/r8a7795-sysc.c            |  2 +-
>  drivers/soc/renesas/r8a77990-sysc.c           |  5 ++++-
>  drivers/soc/ti/k3-ringacc.c                   |  2 +-
>  drivers/staging/mt7621-pci/pci-mt7621.c       |  2 +-
>  drivers/thermal/rcar_gen3_thermal.c           |  4 +++-
>  drivers/thermal/ti-soc-thermal/ti-bandgap.c   | 10 +++++++--
>  drivers/usb/gadget/udc/renesas_usb3.c         |  2 +-
>  drivers/usb/host/ehci-platform.c              |  4 +++-
>  drivers/usb/host/xhci-rcar.c                  |  2 +-
>  drivers/watchdog/renesas_wdt.c                |  2 +-
>  48 files changed, 131 insertions(+), 52 deletions(-)
> 
> diff --git a/drivers/bus/ti-sysc.c b/drivers/bus/ti-sysc.c
> index 5fae60f8c135..00c59aa217c1 100644
> --- a/drivers/bus/ti-sysc.c
> +++ b/drivers/bus/ti-sysc.c
> @@ -2909,7 +2909,7 @@ static int sysc_init_soc(struct sysc *ddata)
>  	}
>  
>  	match = soc_device_match(sysc_soc_feat_match);
> -	if (!match)
> +	if (!match || IS_ERR(match))
>  		return 0;
>  
>  	if (match->data)
> diff --git a/drivers/clk/renesas/r8a7795-cpg-mssr.c b/drivers/clk/renesas/r8a7795-cpg-mssr.c
> index c32d2c678046..90a18336a4c3 100644
> --- a/drivers/clk/renesas/r8a7795-cpg-mssr.c
> +++ b/drivers/clk/renesas/r8a7795-cpg-mssr.c
> @@ -439,6 +439,7 @@ static const unsigned int r8a7795es2_mod_nullify[] __initconst = {
>  
>  static int __init r8a7795_cpg_mssr_init(struct device *dev)
>  {
> +	const struct soc_device_attribute *match;
>  	const struct rcar_gen3_cpg_pll_config *cpg_pll_config;
>  	u32 cpg_mode;
>  	int error;
> @@ -453,7 +454,8 @@ static int __init r8a7795_cpg_mssr_init(struct device *dev)
>  		return -EINVAL;
>  	}
>  
> -	if (soc_device_match(r8a7795es1)) {
> +	match = soc_device_match(r8a7795es1);
> +	if (!IS_ERR(match) && match) {

"if (!IS_ERR_OR_NULL(match))" in all places.

Thanks

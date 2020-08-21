Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 821E024D6BC
	for <lists+netdev@lfdr.de>; Fri, 21 Aug 2020 15:58:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728550AbgHUN6P (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Aug 2020 09:58:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:51242 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727123AbgHUN6N (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 21 Aug 2020 09:58:13 -0400
Received: from coco.lan (ip5f5ad5bf.dynamic.kabel-deutschland.de [95.90.213.191])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id F296F20720;
        Fri, 21 Aug 2020 13:58:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1598018291;
        bh=C1qkdYnVlB8TjKiXCca33hF85UABOti3fWfXcteU3Ms=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=l1mnDXsbmgumY6i+wDZnB57lfwyZ8aXmRiD8X0RBBfI6pkaSx/VseZ1258Flb4VTs
         5QniQC3mIhGQc+5ugAIPr1kH0D9POaIRX5xjuoWRStvj4Id5kW3Ba6Lg2Qadvq2YEP
         s7nhPnOrM5wkZclwBuviOe/sYNWDeCxEPgGqa1lE=
Date:   Fri, 21 Aug 2020 15:58:01 +0200
From:   Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
To:     Sam Ravnborg <sam@ravnborg.org>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Neil Armstrong <narmstrong@baylibre.com>,
        Xinliang Liu <xinliang.liu@linaro.org>,
        Wanchun Zheng <zhengwanchun@hisilicon.com>,
        linuxarm@huawei.com, dri-devel <dri-devel@lists.freedesktop.org>,
        Andrzej Hajda <a.hajda@samsung.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        devel@driverdev.osuosl.org, Daniel Borkmann <daniel@iogearbox.net>,
        John Fastabend <john.fastabend@gmail.com>,
        Xiubin Zhang <zhangxiubin1@huawei.com>,
        Wei Xu <xuwei5@hisilicon.com>, David Airlie <airlied@linux.ie>,
        Xinwei Kong <kong.kongxinwei@hisilicon.com>,
        Tomi Valkeinen <tomi.valkeinen@ti.com>,
        Bogdan Togorean <bogdan.togorean@analog.com>,
        Laurentiu Palcu <laurentiu.palcu@nxp.com>,
        linux-media@vger.kernel.org, devicetree@vger.kernel.org,
        Liwei Cai <cailiwei@hisilicon.com>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        Manivannan Sadhasivam <mani@kernel.org>,
        Chen Feng <puck.chen@hisilicon.com>,
        Alexei Starovoitov <ast@kernel.org>,
        linaro-mm-sig@lists.linaro.org, Rob Herring <robh+dt@kernel.org>,
        Jakub Kicinski <kuba@kernel.org>, mauro.chehab@huawei.com,
        Rob Clark <robdclark@chromium.org>,
        linux-arm-kernel@lists.infradead.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Liuyao An <anliuyao@huawei.com>,
        Rongrong Zou <zourongrong@gmail.com>, bpf@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>
Subject: Re: [PATCH 00/49] DRM driver for Hikey 970
Message-ID: <20200821155801.0b820fc6@coco.lan>
In-Reply-To: <20200819173558.GA3733@ravnborg.org>
References: <cover.1597833138.git.mchehab+huawei@kernel.org>
        <20200819152120.GA106437@ravnborg.org>
        <20200819174027.70b39ee9@coco.lan>
        <20200819173558.GA3733@ravnborg.org>
X-Mailer: Claws Mail 3.17.5 (GTK+ 2.24.32; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Em Wed, 19 Aug 2020 19:35:58 +0200
Sam Ravnborg <sam@ravnborg.org> escreveu:

> Also a few high level comments:

Hi Sam,

Finally finished addressing the things you pointed, except by a few
ones:
	- bridge bindings;
	- use drm_foo() instead of DRM_foo() when possible.

A few answers to some of your comments.

> There is too much unused code present - please delete.
> I dod not think I spotted it all.

I'll took a look and dropped most of it. I kept just some
code there related to an optional IOMMU support. The code
there is commented out because they depend on a driver that,
after some upstream discussions, I'm opting to not sending
it. Basically, there are better ways to support the integrated
MMU for the GPU core.

I'added some FIXME and commented out the code, as I intend
to take another look on it in the future. Not top priority,
as the driver works without it, but it could affect driver's
performance.

> Some style issues - ask checkpatch --strict for help identifying
> these.

Ok. There aren't much reported by checkpatch, as I did lots of
checkpatch fixes already in this series. I ended keeping
some CamelCase for macros:

	CHECK:CAMELCASE: Avoid CamelCase: <SMMU_SMRx_P>
	#143: FILE: drivers/staging/hikey9xx/gpu/kirin970_dpe_reg.h:143:
	+#define SMMU_SMRx_P	(0x10000)

and a few other things that, IMHO, making checkpatch happier
would make things worse for humans ;-)

> Needs to be adapted to new bridge handling - see comments.

Ok.

> Move panel stuff to drm_panel (or maybe I got confsed so this was just
> bride stuff).

There used to have a separate panel driver. The DRM driver has
support for it, probably using some older binding model (although
I converted some things that don't work on upstream Kernels anymore).

The old panel driver is there at the history (patch 01/49), but
a later patch drops it. The main thing is that Hikey 970 board
doesn't come with any panel. Maybe are out there some daughter
boards providing a panel display, but I was unable to find it.

So, I ended dropping the panel driver, but keeping the main
driver's code to handle it, as someone could find it useful.

> Lots track a few times - so may have confused myself a few times.
> 
> Many small comments - but general impression is good.

Good!

> Happy hacking!

Thanks!

> 	Sam
> 
> 
> > diff --git a/drivers/staging/hikey9xx/gpu/Kconfig b/drivers/staging/hikey9xx/gpu/Kconfig
> > new file mode 100644
> > index 000000000000..957da13bcf81
> > --- /dev/null
> > +++ b/drivers/staging/hikey9xx/gpu/Kconfig
> > @@ -0,0 +1,22 @@
> > +config DRM_HISI_KIRIN9XX
> > +	tristate "DRM Support for Hisilicon Kirin9xx series SoCs Platform"
> > +	depends on DRM && OF && ARM64
> > +	select DRM_KMS_HELPER
> > +	select DRM_GEM_CMA_HELPER
> > +	select DRM_KMS_CMA_HELPER
> > +	select DRM_MIPI_DSI
> > +	help
> > +	  Choose this option if you have a HiSilicon Kirin960 or Kirin970.
> > +	  If M is selected the module will be called kirin9xx-drm.
> > +
> > +config DRM_HISI_KIRIN970
> > +	bool "Enable support for Hisilicon Kirin970"
> > +	depends on DRM_MIPI_DSI  
> Implied by DRM_HISI_KIRIN9XX, so not needed.
> > +	depends on DRM_HISI_KIRIN9XX
> > +	help
> > +	  Choose this option if you have a hisilicon Kirin chipsets(kirin970).
> > +
> > +config DRM_HISI_KIRIN9XX_DSI
> > +	tristate
> > +	depends on DRM_HISI_KIRIN9XX
> > +	default y  
> This is essential a copy of DRM_HISI_KIRIN9XX - so no need for this
> extra Kconfig variable.

The above are left-overs. I'm dropping everything, keeping just
DRM_HISI_KIRIN9XX. The driver now has support for both Kirin 960 and 970
at the same time, without needing an extra Kconfig.

> > +	// D0  
> Some people dislike the more readable c99 comments.
> I do not recall if coding style allows them
> Ask checkpatch --strict

It used to be forbidden. Linus changed his mind about c99 comments
some time ago. It is now allowed. More than that, using c99 comments is 
now mandatory for SPDX on c files.

In any case, changing to /* */ is as easy as running this script:

	for i in drivers/staging/hikey9xx/gpu/*.[ch]; do perl -ne 'if (! m,// SPDX,) { s,//\s*(.*),/* \1 */,; }; print $_' -i $i; done

As I also prefer not using c99 comments, I applied a cleanup patch.

> Some of the enums I checked are not used.

Yeah, based on the size of the header files, when compared with
the size of the code, I suspect that lots of things there won't be
used. Cleaning this could take some time and may end removing
some bits that we could need in the future in order to address
existing problems at the driver. 

So, I opted preserving them, at least on this initial
patchset. I intend to do a further cleanup when trying to
merge this driver with the one for Kirin 620. On a side node,
currently, I don't have a Kirin 620 board. So, I'm postponing
such task until I get one such boards, as I'm not willing
to take the risk of changing it without being able to test.

> If their members are used then consider to use the enum
> and not just an int.

Yeah, it makes sense to use enum for type consistency.

I would prefer to do such kind of cleanup later on, together
with the attempt of having a single driver for all Kirin
supported DRM, as this is something that I'll need to revisit
when trying to merge the code.

> > +	ctx->dss_pri_clk = devm_clk_get(dev, "clk_edc0");
> > +	if (!ctx->dss_pri_clk) {
> > +		DRM_ERROR("failed to parse dss_pri_clk\n");
> > +	return -ENODEV;
> > +	}
...

> I had expected some of these could fail with a PROBE_DEFER.
> Consider to use the newly introduced dev_probe_err()

Yeah, getting clock lines can fail. I was unable to find dev_probe_err(),
at least on Kernel 5.9-rc1. I saw this comment:

	https://lkml.org/lkml/2020/3/6/356

It sounds it didn't reach upstream. Anyway, I add error handling for the
the clk_get calls:

	ctx->dss_pri_clk = devm_clk_get(dev, "clk_edc0");
	ret = PTR_ERR_OR_ZERO(ctx->dss_pri_clk);
	if (ret == -EPROBE_DEFER) {
		return ret;
	} else if (ret) {
		DRM_ERROR("failed to parse dss_pri_clk: %d\n", ret);
		return ret;
	}

This should be able to detect deferred probe, plus to warn
about other errors.

PS.: I'll be changing DRM_foo() to drm_foo() on a separate
patchset, after finishing the remaining code changes.


> > +static int  dss_drm_suspend(struct platform_device *pdev, pm_message_t state)
> > +{
> > +	struct dss_data *dss = platform_get_drvdata(pdev);
> > +	struct drm_crtc *crtc = &dss->acrtc.base;
> > +
> > +	dss_crtc_disable(crtc, NULL);
> > +
> > +	return 0;
> > +}  
> There is a suspend (and resume) helper - can it be used?

That's a very good question. Hard to answer right, as last time
I checked, DPMS suspend/resume are currently broken. 

I need to re-test it, but it has been hard to work on that part,
because right now there's no USB driver (so, no keyboard/mouse).

I was using x2x to send evdev events to the remote machine, but
I did some changes at the test distro, and this stopped working.

I need to find some other solution to send evdev events to Hikey970
while I don't fix my USB driver port.

So, for now, I prefer keeping those. I'll revisit this before
moving the driver out of staging, as this is one of the current
bugs.

> > +
> > +#define ROUND(x, y)		((x) / (y) + \
> > +				((x) % (y) * 10 / (y) >= 5 ? 1 : 0))
> > +#define ROUND1(x, y)	((x) / (y) + ((x) % (y)  ? 1 : 0))  
> Use generic macros for this?

> > +#define encoder_to_dsi(encoder) \
> > +	container_of(encoder, struct dw_dsi, encoder)
> > +#define host_to_dsi(host) \
> > +	container_of(host, struct dw_dsi, host)
> > +#define connector_to_dsi(connector) \
> > +	container_of(connector, struct dw_dsi, connector)
> > +#define DSS_REDUCE(x)	((x) > 0 ? ((x) - 1) : (x))  
> Use generic macros for this?

> > +struct dw_dsi_client {
> > +	u32 lanes;
> > +	u32 phy_clock; /* in kHz */
> > +	enum mipi_dsi_pixel_format format;
> > +	unsigned long mode_flags;
> > +};
> > +  
> 
> Can the panel stuff be moved out and utilise drm_panel?

I saw the code at drm_panel. The real issue here is that I can't
test anything related to panel support, as I lack any hardware
for testing. So, there's a high chance I may end breaking
something while trying to do that.

> > +struct dw_dsi {
> > +	struct drm_encoder encoder;
> > +	struct drm_bridge *bridge;
> > +	struct drm_panel *panel;
> > +	struct mipi_dsi_host host;
> > +	struct drm_connector connector; /* connector for panel */
> > +	struct drm_display_mode cur_mode;
> > +	struct dsi_hw_ctx *ctx;
> > +	struct mipi_phy_params phy;
> > +	struct mipi_panel_info mipi;
> > +	struct ldi_panel_info ldi;
> > +	u32 lanes;
> > +	enum mipi_dsi_pixel_format format;
> > +	unsigned long mode_flags;
> > +	struct gpio_desc *gpio_mux;
> > +	struct dw_dsi_client client[OUT_MAX];
> > +	enum dsi_output_client cur_client, attached_client;
> > +	bool enable;
> > +};  
> This smells like a bridge driver.
> Bridge drivers shall use the bridge panel.
> And new bridge drivers shall not create conectors, thats the role of the
> display driver.

Actually, this device is "hybrid" with regards to bridges.
HDMI uses an external bridge (adv7535), while panel doesn't.

In any case, I would prefer not touching anything related to
the panel. As I mentioned on my other comment, currently
I lack any panels that might work on Hikey 970. So, this is
something I can't test.

> > +
> > +	/* Link drm_bridge to encoder */
> > +	if (!bridge) {
> > +		DRM_INFO("no dsi bridge to attach the encoder\n");
> > +		return 0;
> > +	}
> > +
> > +	crtc_mask = drm_of_find_possible_crtcs(drm_dev, dev->of_node);
> > +	if (!crtc_mask) {
> > +		DRM_ERROR("failed to find crtc mask\n");
> > +		return -EINVAL;
> > +	}
> > +
> > +	dev_info(dev, "Initializing CRTC encoder: %d\n",
> > +		 crtc_mask);
> > +
> > +	encoder->possible_crtcs = crtc_mask;
> > +	encoder->possible_clones = 0;
> > +	ret = drm_encoder_init(drm_dev, encoder, &dw_encoder_funcs,
> > +			       DRM_MODE_ENCODER_DSI, NULL);
> > +	if (ret) {
> > +		DRM_ERROR("failed to init dsi encoder\n");
> > +		return ret;
> > +	}
> > +
> > +	drm_encoder_helper_add(encoder, &dw_encoder_helper_funcs);
> > +
> > +	/* associate the bridge to dsi encoder */
> > +	ret = drm_bridge_attach(encoder, bridge, NULL, 0);  
> The bridge should be attached with the falg that tell the bridge NOT to
> create a connector.
> 
> The display driver shall created the connector.
> 
> Please see how other drivers do this (but most driver uses the old
> pattern so so look for drm_bridge_attach() with the flag argument.
> I cannot see any user of this pwm and backlight stuff.
> So the best would be to drop it all.
> > +
> > +int hisi_pwm_set_backlight(struct backlight_device *bl, uint32_t bl_level)
> > +{

Yeah, this was dropped in a patch on this series that it is after the DT
changes.

The PWM and backlight stuff is used by the display panel driver which
came together with the DRM drivers. I dropped it, together with the
parts of the driver which used to call them.


Thanks,
Mauro

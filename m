Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3232E4E664
	for <lists+netdev@lfdr.de>; Fri, 21 Jun 2019 12:44:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726640AbfFUKoy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Jun 2019 06:44:54 -0400
Received: from vps.xff.cz ([195.181.215.36]:57978 "EHLO vps.xff.cz"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726218AbfFUKoy (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 21 Jun 2019 06:44:54 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=megous.com; s=mail;
        t=1561113891; bh=uF+1BlMGKRS6vtUXDE5TvLdvEqjdbvyP/y5+AuCPrdw=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=ow7PxS52be3W7D+CLStx+GnsxjXGCQTI1iuSUM4RsdIJWfx2Wksiz1Cnlbol/TQnf
         0l7P19qDOVyz+44VF/o0q4TbwtyXww1V4VneGDWy5Uj9bzh5c0hpMrGskFUcj9TZ9P
         l7NFkU2RW73QR563UgLKHOamD9gE5HV9F+TY0g64=
Date:   Fri, 21 Jun 2019 12:44:50 +0200
From:   =?utf-8?Q?Ond=C5=99ej?= Jirman <megous@megous.com>
To:     linux-sunxi@googlegroups.com,
        Maxime Ripard <maxime.ripard@bootlin.com>,
        Chen-Yu Tsai <wens@csie.org>, Rob Herring <robh+dt@kernel.org>,
        Jernej =?utf-8?Q?=C5=A0krabec?= <jernej.skrabec@gmail.com>
Cc:     Mark Rutland <mark.rutland@arm.com>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        devicetree@vger.kernel.org, David Airlie <airlied@linux.ie>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        dri-devel@lists.freedesktop.org,
        linux-stm32@st-md-mailman.stormreply.com,
        Jose Abreu <joabreu@synopsys.com>,
        linux-arm-kernel@lists.infradead.org,
        Daniel Vetter <daniel@ffwll.ch>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        "David S. Miller" <davem@davemloft.net>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>
Subject: Re: [PATCH v7 0/6] Add support for Orange Pi 3
Message-ID: <20190621104450.vyemihcou5cjayju@core.my.home>
Mail-Followup-To: linux-sunxi@googlegroups.com,
        Maxime Ripard <maxime.ripard@bootlin.com>,
        Chen-Yu Tsai <wens@csie.org>, Rob Herring <robh+dt@kernel.org>,
        Jernej =?utf-8?Q?=C5=A0krabec?= <jernej.skrabec@gmail.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        devicetree@vger.kernel.org, David Airlie <airlied@linux.ie>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        dri-devel@lists.freedesktop.org,
        linux-stm32@st-md-mailman.stormreply.com,
        Jose Abreu <joabreu@synopsys.com>,
        linux-arm-kernel@lists.infradead.org,
        Daniel Vetter <daniel@ffwll.ch>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        "David S. Miller" <davem@davemloft.net>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>
References: <20190620134748.17866-1-megous@megous.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190620134748.17866-1-megous@megous.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jun 20, 2019 at 03:47:42PM +0200, verejna wrote:
> From: Ondrej Jirman <megous@megous.com>
> 
> This series implements support for Xunlong Orange Pi 3 board.
> 
> - ethernet support (patches 1-3)
> - HDMI support (patches 4-6)
> 
> For some people, ethernet doesn't work after reboot (but works on cold
> boot), when the stmmac driver is built into the kernel. It works when
> the driver is built as a module. It's either some timing issue, or power
> supply issue or a combination of both. Module build induces a power
> cycling of the phy.
> 
> I encourage people with this issue, to build the driver into the kernel,
> and try to alter the reset timings for the phy in DTS or
> startup-delay-us and report the findings.

Other theory to test is that the PHY requires two power supplies to be
enabled at the same time, and during reboot one of them (one controlled
via GPIO) may be turned off, and ALDO2 controlled by AXP805 may not.

It should be possible to turn off ALDO2 in u-boot via CONFIG_AXP_ALDO2_VOLT=0
(You may need to enable CONFIG_AXP809_POWER and other options too, since
it seems AXP805 support is not enabled for orange pi 3 in u-boot)

regards,
	o.

> 
> Please take a look.
> 
> thank you and regards,
>   Ondrej Jirman
> 
> 
> Changes in v7:
> - dropped stored reference to connector_pdev as suggested by Jernej
> - added forgotten dt-bindings reviewed-by tag
> 
> Changes in v6:
> - added dt-bindings reviewed-by tag
> - fix wording in stmmac commit (as suggested by Sergei)
> 
> Changes in v5:
> - dropped already applied patches (pinctrl patches, mmc1 pinconf patch)
> - rename GMAC-3V3 -> GMAC-3V to match the schematic (Jagan)
> - changed hdmi-connector's ddc-supply property to ddc-en-gpios
>   (Rob Herring)
> 
> Changes in v4:
> - fix checkpatch warnings/style issues
> - use enum in struct sunxi_desc_function for io_bias_cfg_variant
> - collected acked-by's
> - fix compile error in drivers/pinctrl/sunxi/pinctrl-sun9i-a80-r.c:156
>   caused by missing conversion from has_io_bias_cfg struct member
>   (I've kept the acked-by, because it's a trivial change, but feel free
>   to object.) (reported by Martin A. on github)
>   I did not have A80 pinctrl enabled for some reason, so I did not catch
>   this sooner.
> - dropped brcm firmware patch (was already applied)
> - dropped the wifi dts patch (will re-send after H6 RTC gets merged,
>   along with bluetooth support, in a separate series)
> 
> Changes in v3:
> - dropped already applied patches
> - changed pinctrl I/O bias selection constants to enum and renamed
> - added /omit-if-no-ref/ to mmc1_pins
> - made mmc1_pins default pinconf for mmc1 in H6 dtsi
> - move ddc-supply to HDMI connector node, updated patch descriptions,
>   changed dt-bindings docs
> 
> Changes in v2:
> - added dt-bindings documentation for the board's compatible string
>   (suggested by Clement)
> - addressed checkpatch warnings and code formatting issues (on Maxime's
>   suggestions)
> - stmmac: dropped useless parenthesis, reworded description of the patch
>   (suggested by Sergei)
> - drop useles dev_info() about the selected io bias voltage
> - docummented io voltage bias selection variant macros
> - wifi: marked WiFi DTS patch and realted mmc1_pins as "DO NOT MERGE",
>   because wifi depends on H6 RTC support that's not merged yet (suggested
>   by Clement)
> - added missing signed-of-bys
> - changed &usb2otg dr_mode to otg, and added a note about VBUS
> - improved wording of HDMI driver's DDC power supply patch
> 
> Icenowy Zheng (2):
>   net: stmmac: sun8i: add support for Allwinner H6 EMAC
>   net: stmmac: sun8i: force select external PHY when no internal one
> 
> Ondrej Jirman (4):
>   arm64: dts: allwinner: orange-pi-3: Enable ethernet
>   dt-bindings: display: hdmi-connector: Support DDC bus enable
>   drm: sun4i: Add support for enabling DDC I2C bus to sun8i_dw_hdmi glue
>   arm64: dts: allwinner: orange-pi-3: Enable HDMI output
> 
>  .../display/connector/hdmi-connector.txt      |  1 +
>  .../dts/allwinner/sun50i-h6-orangepi-3.dts    | 70 +++++++++++++++++++
>  drivers/gpu/drm/sun4i/sun8i_dw_hdmi.c         | 54 ++++++++++++--
>  drivers/gpu/drm/sun4i/sun8i_dw_hdmi.h         |  2 +
>  .../net/ethernet/stmicro/stmmac/dwmac-sun8i.c | 21 ++++++
>  5 files changed, 144 insertions(+), 4 deletions(-)
> 
> -- 
> 2.22.0
> 
> 
> _______________________________________________
> linux-arm-kernel mailing list
> linux-arm-kernel@lists.infradead.org
> http://lists.infradead.org/mailman/listinfo/linux-arm-kernel

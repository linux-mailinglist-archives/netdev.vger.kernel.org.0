Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C908F3DB641
	for <lists+netdev@lfdr.de>; Fri, 30 Jul 2021 11:46:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238275AbhG3JqE convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Fri, 30 Jul 2021 05:46:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53788 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238208AbhG3JqE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 30 Jul 2021 05:46:04 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A2CA9C061765
        for <netdev@vger.kernel.org>; Fri, 30 Jul 2021 02:45:56 -0700 (PDT)
Received: from lupine.hi.pengutronix.de ([2001:67c:670:100:3ad5:47ff:feaf:1a17] helo=lupine)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <p.zabel@pengutronix.de>)
        id 1m9P5U-0007Fl-DW; Fri, 30 Jul 2021 11:45:52 +0200
Received: from pza by lupine with local (Exim 4.92)
        (envelope-from <p.zabel@pengutronix.de>)
        id 1m9P5T-0000A9-03; Fri, 30 Jul 2021 11:45:51 +0200
Message-ID: <a360877260a877819ad8eef7f63c370e0c16c640.camel@pengutronix.de>
Subject: Re: [PATCHv1 2/3] ARM: dts: meson: Use new reset id for reset
 controller
From:   Philipp Zabel <p.zabel@pengutronix.de>
To:     Anand Moon <linux.amoon@gmail.com>, netdev@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-amlogic@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-stm32@st-md-mailman.stormreply.com,
        devicetree@vger.kernel.org
Cc:     Jerome Brunet <jbrunet@baylibre.com>,
        Neil Armstrong <narmstrong@baylibre.com>,
        Martin Blumenstingl <martin.blumenstingl@googlemail.com>,
        Rob Herring <robh+dt@kernel.org>,
        Kevin Hilman <khilman@baylibre.com>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Emiliano Ingrassia <ingrassia@epigenesys.com>
Date:   Fri, 30 Jul 2021 11:45:50 +0200
In-Reply-To: <20210729201100.3994-3-linux.amoon@gmail.com>
References: <20210729201100.3994-1-linux.amoon@gmail.com>
         <20210729201100.3994-3-linux.amoon@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
User-Agent: Evolution 3.30.5-1.1 
MIME-Version: 1.0
X-SA-Exim-Connect-IP: 2001:67c:670:100:3ad5:47ff:feaf:1a17
X-SA-Exim-Mail-From: p.zabel@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 2021-07-30 at 01:40 +0530, Anand Moon wrote:
> Used new reset id for reset controller as it conflict
> with the core reset id.
> 
> Fixes: b96446541d83 ("ARM: dts: meson8b: extend ethernet controller description")
> 
> Cc: Jerome Brunet <jbrunet@baylibre.com>
> Cc: Neil Armstrong <narmstrong@baylibre.com>
> Cc: Martin Blumenstingl <martin.blumenstingl@googlemail.com>
> Signed-off-by: Anand Moon <linux.amoon@gmail.com>
> ---
>  arch/arm/boot/dts/meson8b.dtsi  | 2 +-
>  arch/arm/boot/dts/meson8m2.dtsi | 2 +-
>  2 files changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/arm/boot/dts/meson8b.dtsi b/arch/arm/boot/dts/meson8b.dtsi
> index c02b03cbcdf4..cb3a579d09ef 100644
> --- a/arch/arm/boot/dts/meson8b.dtsi
> +++ b/arch/arm/boot/dts/meson8b.dtsi
> @@ -511,7 +511,7 @@ &ethmac {
>  	tx-fifo-depth = <2048>;
>  
>  	resets = <&reset RESET_ETHERNET>;
> -	reset-names = "stmmaceth";
> +	reset-names = "ethreset";

This looks like an incompatible change. Is the "stmmaceth" reset not
used? It is documented as "MAC reset signal" in [1]. So a PHY reset
should be separate from this.

[1] Documentation/devicetree/bindings/net/snps,dwmac.yaml

regards
Philipp

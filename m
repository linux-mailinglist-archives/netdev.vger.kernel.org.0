Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 863BE434AF6
	for <lists+netdev@lfdr.de>; Wed, 20 Oct 2021 14:14:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230317AbhJTMQ1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Oct 2021 08:16:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48456 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230298AbhJTMQ0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 Oct 2021 08:16:26 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B995FC06161C
        for <netdev@vger.kernel.org>; Wed, 20 Oct 2021 05:14:11 -0700 (PDT)
Received: from ptx.hi.pengutronix.de ([2001:67c:670:100:1d::c0])
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <ore@pengutronix.de>)
        id 1mdATt-0005SZ-Fg; Wed, 20 Oct 2021 14:14:05 +0200
Received: from ore by ptx.hi.pengutronix.de with local (Exim 4.92)
        (envelope-from <ore@pengutronix.de>)
        id 1mdATs-0000fV-PE; Wed, 20 Oct 2021 14:14:04 +0200
Date:   Wed, 20 Oct 2021 14:14:04 +0200
From:   Oleksij Rempel <o.rempel@pengutronix.de>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, netdev@vger.kernel.org,
        Rob Herring <robh+dt@kernel.org>,
        Shawn Guo <shawnguo@kernel.org>, Li Yang <leoyang.li@nxp.com>,
        Florian Fainelli <f.fainelli@gmail.com>
Subject: Re: [PATCH devicetree 1/3] ARM: dts: imx6qp-prtwd3: update RGMII
 delays for sja1105 switch
Message-ID: <20211020121404.GA2298@pengutronix.de>
References: <20211020113613.815210-1-vladimir.oltean@nxp.com>
 <20211020113613.815210-2-vladimir.oltean@nxp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20211020113613.815210-2-vladimir.oltean@nxp.com>
X-Sent-From: Pengutronix Hildesheim
X-URL:  http://www.pengutronix.de/
X-IRC:  #ptxdist @freenode
X-Accept-Language: de,en
X-Accept-Content-Type: text/plain
X-Uptime: 14:13:35 up 244 days, 15:37, 136 users,  load average: 0.11, 0.19,
 0.32
User-Agent: Mutt/1.10.1 (2018-07-13)
X-SA-Exim-Connect-IP: 2001:67c:670:100:1d::c0
X-SA-Exim-Mail-From: ore@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Oct 20, 2021 at 02:36:11PM +0300, Vladimir Oltean wrote:
> In the new behavior, the sja1105 driver expects there to be explicit
> RGMII delays present on the fixed-link ports, otherwise it will complain
> that it falls back to legacy behavior, which is to apply RGMII delays
> incorrectly derived from the phy-mode string.
> 
> In this case, the legacy behavior of the driver is to apply both RX and
> TX delays. To preserve that, add explicit 2 nanosecond delays, which are
> identical with what the driver used to add (a 90 degree phase shift).
> The delays from the phy-mode are ignored by new kernels (it's still
> RGMII as long as it's "rgmii*" something), and the explicit
> {rx,tx}-internal-delay-ps properties are ignored by old kernels, so the
> change works both ways.
> 
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
> Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>

Reviewed-by: Oleksij Rempel <o.rempel@pengutronix.de> 

> ---
>  arch/arm/boot/dts/imx6qp-prtwd3.dts | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/arch/arm/boot/dts/imx6qp-prtwd3.dts b/arch/arm/boot/dts/imx6qp-prtwd3.dts
> index 7648e8a02000..cf6571cc4682 100644
> --- a/arch/arm/boot/dts/imx6qp-prtwd3.dts
> +++ b/arch/arm/boot/dts/imx6qp-prtwd3.dts
> @@ -178,6 +178,8 @@ port@4 {
>  				label = "cpu";
>  				ethernet = <&fec>;
>  				phy-mode = "rgmii-id";
> +				rx-internal-delay-ps = <2000>;
> +				tx-internal-delay-ps = <2000>;
>  
>  				fixed-link {
>  					speed = <100>;
> -- 
> 2.25.1
> 
> 
> _______________________________________________
> linux-arm-kernel mailing list
> linux-arm-kernel@lists.infradead.org
> http://lists.infradead.org/mailman/listinfo/linux-arm-kernel
> 

-- 
Pengutronix e.K.                           |                             |
Steuerwalder Str. 21                       | http://www.pengutronix.de/  |
31137 Hildesheim, Germany                  | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |

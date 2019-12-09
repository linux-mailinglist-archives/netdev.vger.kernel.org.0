Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 183BC117B39
	for <lists+netdev@lfdr.de>; Tue, 10 Dec 2019 00:09:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727075AbfLIXIs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Dec 2019 18:08:48 -0500
Received: from gloria.sntech.de ([185.11.138.130]:51516 "EHLO gloria.sntech.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726362AbfLIXIs (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 9 Dec 2019 18:08:48 -0500
Received: from ip5f5a6266.dynamic.kabel-deutschland.de ([95.90.98.102] helo=diego.localnet)
        by gloria.sntech.de with esmtpsa (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <heiko@sntech.de>)
        id 1ieS8r-0003WX-Uy; Tue, 10 Dec 2019 00:08:37 +0100
From:   Heiko =?ISO-8859-1?Q?St=FCbner?= <heiko@sntech.de>
To:     Soeren Moch <smoch@web.de>
Cc:     Kalle Valo <kvalo@codeaurora.org>, linux-wireless@vger.kernel.org,
        brcm80211-dev-list.pdl@broadcom.com,
        brcm80211-dev-list@cypress.com, netdev@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-rockchip@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 8/8] arm64: dts: rockchip: RockPro64: enable wifi module at sdio0
Date:   Tue, 10 Dec 2019 00:08:37 +0100
Message-ID: <2668270.pdtvSLGib8@diego>
In-Reply-To: <20191209223822.27236-8-smoch@web.de>
References: <20191209223822.27236-1-smoch@web.de> <20191209223822.27236-8-smoch@web.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Soeren,

Am Montag, 9. Dezember 2019, 23:38:22 CET schrieb Soeren Moch:
> RockPro64 supports an Ampak AP6359SA based wifi/bt combo module.
> The BCM4359/9 wifi controller in this module is connected to sdio0,
> enable this interface.
> 
> Signed-off-by: Soeren Moch <smoch@web.de>
> ---
> Not sure where to place exactly the sdio0 node in the dts because
> existing sd nodes are not sorted alphabetically.
> 
> This last patch in this brcmfmac patch series probably should be picked
> up by Heiko independently of the rest of this series. It was sent together
> to show how this brcmfmac extension for 4359-sdio support with RSDB is
> used and tested.

node placement looks good so I can apply it, just a general questions
I only got patch 8/8 are patches 1-7 relevant for this one and what are they?

Thanks
Heiko


> 
> Cc: Heiko Stuebner <heiko@sntech.de>
> Cc: Kalle Valo <kvalo@codeaurora.org>
> Cc: linux-wireless@vger.kernel.org
> Cc: brcm80211-dev-list.pdl@broadcom.com
> Cc: brcm80211-dev-list@cypress.com
> Cc: netdev@vger.kernel.org
> Cc: linux-arm-kernel@lists.infradead.org
> Cc: linux-rockchip@lists.infradead.org
> Cc: linux-kernel@vger.kernel.org
> ---
>  .../boot/dts/rockchip/rk3399-rockpro64.dts    | 21 ++++++++++++-------
>  1 file changed, 14 insertions(+), 7 deletions(-)
> 
> diff --git a/arch/arm64/boot/dts/rockchip/rk3399-rockpro64.dts b/arch/arm64/boot/dts/rockchip/rk3399-rockpro64.dts
> index 7f4b2eba31d4..9fa92790d6e0 100644
> --- a/arch/arm64/boot/dts/rockchip/rk3399-rockpro64.dts
> +++ b/arch/arm64/boot/dts/rockchip/rk3399-rockpro64.dts
> @@ -71,13 +71,6 @@
>  		clock-names = "ext_clock";
>  		pinctrl-names = "default";
>  		pinctrl-0 = <&wifi_enable_h>;
> -
> -		/*
> -		 * On the module itself this is one of these (depending
> -		 * on the actual card populated):
> -		 * - SDIO_RESET_L_WL_REG_ON
> -		 * - PDN (power down when low)
> -		 */
>  		reset-gpios = <&gpio0 RK_PB2 GPIO_ACTIVE_LOW>;
>  	};
> 
> @@ -650,6 +643,20 @@
>  	status = "okay";
>  };
> 
> +&sdio0 {
> +	bus-width = <4>;
> +	cap-sd-highspeed;
> +	cap-sdio-irq;
> +	disable-wp;
> +	keep-power-in-suspend;
> +	mmc-pwrseq = <&sdio_pwrseq>;
> +	non-removable;
> +	pinctrl-names = "default";
> +	pinctrl-0 = <&sdio0_bus4 &sdio0_cmd &sdio0_clk>;
> +	sd-uhs-sdr104;
> +	status = "okay";
> +};
> +
>  &sdmmc {
>  	bus-width = <4>;
>  	cap-sd-highspeed;
> --
> 2.17.1
> 





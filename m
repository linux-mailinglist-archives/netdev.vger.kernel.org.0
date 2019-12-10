Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 56889118495
	for <lists+netdev@lfdr.de>; Tue, 10 Dec 2019 11:13:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727289AbfLJKNq convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Tue, 10 Dec 2019 05:13:46 -0500
Received: from gloria.sntech.de ([185.11.138.130]:56236 "EHLO gloria.sntech.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726574AbfLJKNq (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 10 Dec 2019 05:13:46 -0500
Received: from ip5f5a6266.dynamic.kabel-deutschland.de ([95.90.98.102] helo=diego.localnet)
        by gloria.sntech.de with esmtpsa (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <heiko@sntech.de>)
        id 1iecWS-0006Fq-56; Tue, 10 Dec 2019 11:13:40 +0100
From:   Heiko =?ISO-8859-1?Q?St=FCbner?= <heiko@sntech.de>
To:     Soeren Moch <smoch@web.de>
Cc:     Kalle Valo <kvalo@codeaurora.org>, linux-wireless@vger.kernel.org,
        brcm80211-dev-list.pdl@broadcom.com,
        brcm80211-dev-list@cypress.com, netdev@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-rockchip@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 8/8] arm64: dts: rockchip: RockPro64: enable wifi module at sdio0
Date:   Tue, 10 Dec 2019 11:13:39 +0100
Message-ID: <3170826.NpdqLUR24W@diego>
In-Reply-To: <d0cece6c-9f90-c691-eb68-a25547532f68@web.de>
References: <20191209223822.27236-1-smoch@web.de> <6162240.GiEx4hqPFh@diego> <d0cece6c-9f90-c691-eb68-a25547532f68@web.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain; charset="iso-8859-1"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Am Dienstag, 10. Dezember 2019, 11:08:18 CET schrieb Soeren Moch:
> Hi Heiko,
> 
> On 10.12.19 02:18, Heiko Stübner wrote:
> > Hi Soeren,
> >
> > Am Dienstag, 10. Dezember 2019, 00:29:21 CET schrieb Soeren Moch:
> >> On 10.12.19 00:08, Heiko Stübner wrote:
> >>> Am Montag, 9. Dezember 2019, 23:38:22 CET schrieb Soeren Moch:
> >>>> RockPro64 supports an Ampak AP6359SA based wifi/bt combo module.
> >>>> The BCM4359/9 wifi controller in this module is connected to sdio0,
> >>>> enable this interface.
> >>>>
> >>>> Signed-off-by: Soeren Moch <smoch@web.de>
> >>>> ---
> >>>> Not sure where to place exactly the sdio0 node in the dts because
> >>>> existing sd nodes are not sorted alphabetically.
> >>>>
> >>>> This last patch in this brcmfmac patch series probably should be picked
> >>>> up by Heiko independently of the rest of this series. It was sent together
> >>>> to show how this brcmfmac extension for 4359-sdio support with RSDB is
> >>>> used and tested.
> >>> node placement looks good so I can apply it, just a general questions
> >>> I only got patch 8/8 are patches 1-7 relevant for this one and what are they?
> >> Patches 1-7 are the patches to support the BCM4359 chipset with SDIO
> >> interface in the linux brcmfmac net-wireless driver, see [1].
> >>
> >> So this patch series has 2 parts:
> >> patches 1-7: add support for the wifi chipset in the wireless driver,
> >> this has to go through net-wireless
> >> patch 8: enable the wifi module with this chipset on RockPro64, this patch
> > Thanks for the clarification :-) .
> >
> > As patch 8 "only" does the core sdio node, it doesn't really depend on the
> > earlier ones and you can submit any uart-hooks for bluetooth once the
> > other patches land I guess.
> The uart part for bluetooth already is in: uart0.
> However, I haven't tested if it really works.

In the new world there is now also a way to actually hook the bt-uart to
the wifi driver without userspace intervention, and you might want to hook
up the interrupt as well for sdio? For example look at the rock960:

sdio-interrupt: https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tree/arch/arm64/boot/dts/rockchip/rk3399-rock960.dtsi#n510
uart-magic: https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tree/arch/arm64/boot/dts/rockchip/rk3399-rock960.dtsi#n557


Heiko

> >> If this was confusing, what would be the ideal way to post such series?
> > I think every maintainer has some slightly different perspective on this,
> > but personally I like getting the whole series to follow the discussion but
> > also to just see when the driver-side changes get merged, as the dts-parts
> > need to wait for that in a lot of cases.
> OK, thanks.
> I will add you for the whole series when sending a v2.
> 
> Soeren
> >
> > Heiko
> >
> >
> >> [1] https://patchwork.kernel.org/project/linux-wireless/list/?series=213951
> >>> Thanks
> >>> Heiko
> >>>
> >>>
> >>>> Cc: Heiko Stuebner <heiko@sntech.de>
> >>>> Cc: Kalle Valo <kvalo@codeaurora.org>
> >>>> Cc: linux-wireless@vger.kernel.org
> >>>> Cc: brcm80211-dev-list.pdl@broadcom.com
> >>>> Cc: brcm80211-dev-list@cypress.com
> >>>> Cc: netdev@vger.kernel.org
> >>>> Cc: linux-arm-kernel@lists.infradead.org
> >>>> Cc: linux-rockchip@lists.infradead.org
> >>>> Cc: linux-kernel@vger.kernel.org
> >>>> ---
> >>>>  .../boot/dts/rockchip/rk3399-rockpro64.dts    | 21 ++++++++++++-------
> >>>>  1 file changed, 14 insertions(+), 7 deletions(-)
> >>>>
> >>>> diff --git a/arch/arm64/boot/dts/rockchip/rk3399-rockpro64.dts b/arch/arm64/boot/dts/rockchip/rk3399-rockpro64.dts
> >>>> index 7f4b2eba31d4..9fa92790d6e0 100644
> >>>> --- a/arch/arm64/boot/dts/rockchip/rk3399-rockpro64.dts
> >>>> +++ b/arch/arm64/boot/dts/rockchip/rk3399-rockpro64.dts
> >>>> @@ -71,13 +71,6 @@
> >>>>  		clock-names = "ext_clock";
> >>>>  		pinctrl-names = "default";
> >>>>  		pinctrl-0 = <&wifi_enable_h>;
> >>>> -
> >>>> -		/*
> >>>> -		 * On the module itself this is one of these (depending
> >>>> -		 * on the actual card populated):
> >>>> -		 * - SDIO_RESET_L_WL_REG_ON
> >>>> -		 * - PDN (power down when low)
> >>>> -		 */
> >>>>  		reset-gpios = <&gpio0 RK_PB2 GPIO_ACTIVE_LOW>;
> >>>>  	};
> >>>>
> >>>> @@ -650,6 +643,20 @@
> >>>>  	status = "okay";
> >>>>  };
> >>>>
> >>>> +&sdio0 {
> >>>> +	bus-width = <4>;
> >>>> +	cap-sd-highspeed;
> >>>> +	cap-sdio-irq;
> >>>> +	disable-wp;
> >>>> +	keep-power-in-suspend;
> >>>> +	mmc-pwrseq = <&sdio_pwrseq>;
> >>>> +	non-removable;
> >>>> +	pinctrl-names = "default";
> >>>> +	pinctrl-0 = <&sdio0_bus4 &sdio0_cmd &sdio0_clk>;
> >>>> +	sd-uhs-sdr104;
> >>>> +	status = "okay";
> >>>> +};
> >>>> +
> >>>>  &sdmmc {
> >>>>  	bus-width = <4>;
> >>>>  	cap-sd-highspeed;
> >>>> --
> >>>> 2.17.1
> >>>>
> >>>
> >>>
> >>
> >
> >
> >
> 
> 





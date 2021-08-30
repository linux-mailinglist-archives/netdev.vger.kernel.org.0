Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7B29D3FB74B
	for <lists+netdev@lfdr.de>; Mon, 30 Aug 2021 15:52:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236934AbhH3Nwo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Aug 2021 09:52:44 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:48492 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236858AbhH3Nwn (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 30 Aug 2021 09:52:43 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Transfer-Encoding:Content-Disposition:
        Content-Type:MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:From:
        Sender:Reply-To:Subject:Date:Message-ID:To:Cc:MIME-Version:Content-Type:
        Content-Transfer-Encoding:Content-ID:Content-Description:Content-Disposition:
        In-Reply-To:References; bh=9DGgUo2ugpU41hWzsW/N+Nu2joYqP2tCgM60Nh03GC4=; b=5s
        k1rHmyE1QQyrq2xcPMU4SNSmqh6fo9dEbWF93Jp0v7TVuONsN3mymtZ5402qJJqOA6wYl+dU3rF4b
        7fZNkMa8OnIljxahEh2iQgv86oEdlcNqO4qXrZf6bHsAgh6fGJKPX1/WIXUmLRm5W/hgRmCiGbHtw
        66SIBCBvyOzFur8=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1mKhh7-004ZKf-EG; Mon, 30 Aug 2021 15:51:25 +0200
Date:   Mon, 30 Aug 2021 15:51:25 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     =?utf-8?B?Q2zDqW1lbnQgQsWTc2No?= <u@pkh.me>
Cc:     Heiner Kallweit <hkallweit1@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Maxime Ripard <mripard@kernel.org>,
        Chen-Yu Tsai <wens@csie.org>,
        Willy Liu <willy.liu@realtek.com>, netdev@vger.kernel.org,
        linux-sunxi@lists.linux.dev, devicetree@vger.kernel.org
Subject: Re: sunxi H5 DTB fix for realtek regression
Message-ID: <YSziXfll/p/5OrOv@lunn.ch>
References: <YSwr6YZXjNrdKoBZ@ssq0.pkh.me>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <YSwr6YZXjNrdKoBZ@ssq0.pkh.me>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Aug 30, 2021 at 02:52:57AM +0200, Clément Bœsch wrote:
> Hi,
> 
> Commit bbc4d71d63549bcd003a430de18a72a742d8c91e ("net: phy: realtek: fix
> rtl8211e rx/tx delay config") broke the network on the NanoPI NEO 2 board
> (RTL8211E chip).
> 
> Following what was suggested by Andrew Lunn for another hardware¹, I tried
> the following diff:
> 
> diff --git a/arch/arm64/boot/dts/allwinner/sun50i-h5-nanopi-neo2.dts b/arch/arm64/boot/dts/allwinner/sun50i-h5-nanopi-neo2.dts
> index 02f8e72f0cad..05486cccee1c 100644
> --- a/arch/arm64/boot/dts/allwinner/sun50i-h5-nanopi-neo2.dts
> +++ b/arch/arm64/boot/dts/allwinner/sun50i-h5-nanopi-neo2.dts
> @@ -75,7 +75,7 @@ &emac {
>         pinctrl-0 = <&emac_rgmii_pins>;
>         phy-supply = <&reg_gmac_3v3>;
>         phy-handle = <&ext_rgmii_phy>;
> -       phy-mode = "rgmii";
> +       phy-mode = "rgmii-id";
>         status = "okay";
>  };
> 
> 
> ...which fixed the issue. This was tested on v5.11.4 but the patch applies
> cleanly on stable so far.
> 
> I'm sorry for not sending a proper patch: I unfortunately have very little
> clue about what I'm doing here so it's very hard for me to elaborate a
> proper commit description.

Hi Clément

You are not too far away from a proper patch. I can either guide you,
if you want to learn, or the allwinner maintainer can probably take
your work and finish it off.

     Andrew

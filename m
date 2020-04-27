Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 130571BAA42
	for <lists+netdev@lfdr.de>; Mon, 27 Apr 2020 18:46:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726303AbgD0QqX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Apr 2020 12:46:23 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:38772 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726282AbgD0QqX (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 27 Apr 2020 12:46:23 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=tP8rD2QRrQA4OB+TWtA7Qhd+z+Cz4MCa/3wl3NgU3xM=; b=I0t7k9Rlus5qnaf5BP8KN6wKIc
        gG69s564/7nlx4KKJiGjLeNhfHPpVDLR0qLylDfWwGzYkNpuSoDKby1fpTnv/4gU3LL1XFieFaNur
        uKI55p+XSjhFGZesbqFg1Qs8kr7CefLpyOzS1KSI0qZv7HTMzZTgV/mVKorRjcMh2j0s=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.93)
        (envelope-from <andrew@lunn.ch>)
        id 1jT6tg-005FOU-V3; Mon, 27 Apr 2020 18:46:20 +0200
Date:   Mon, 27 Apr 2020 18:46:20 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Leonard Crestez <leonard.crestez@nxp.com>
Cc:     Andy Duan <fugang.duan@nxp.com>,
        David Miller <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>,
        Chris Healy <Chris.Healy@zii.aero>,
        dl-linux-imx <linux-imx@nxp.com>, Chris Healy <cphealy@gmail.com>
Subject: Re: [PATCH] net: ethernet: fec: Replace interrupt driven MDIO with
 polled IO
Message-ID: <20200427164620.GD1250287@lunn.ch>
References: <20200414004551.607503-1-andrew@lunn.ch>
 <VI1PR04MB6941D611F6EF67BB42826D4EEEAF0@VI1PR04MB6941.eurprd04.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <VI1PR04MB6941D611F6EF67BB42826D4EEEAF0@VI1PR04MB6941.eurprd04.prod.outlook.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Apr 27, 2020 at 03:19:54PM +0000, Leonard Crestez wrote:
> Hello,
> 
> This patch breaks network boot on at least imx8mm-evk. Boot works if I 
> revert just commit 29ae6bd1b0d8 ("net: ethernet: fec: Replace interrupt 
> driven MDIO with polled IO") on top of next-20200424.

Hi Leonard

Please could you try this:

diff --git a/arch/arm64/boot/dts/freescale/imx8mm-evk.dts b/arch/arm64/boot/dts/freescale/imx8mm-evk.dts
index 951e14a3de0e..3c1adaf7affa 100644
--- a/arch/arm64/boot/dts/freescale/imx8mm-evk.dts
+++ b/arch/arm64/boot/dts/freescale/imx8mm-evk.dts
@@ -109,6 +109,7 @@ &fec1 {
        phy-handle = <&ethphy0>;
        phy-reset-gpios = <&gpio4 22 GPIO_ACTIVE_LOW>;
        phy-reset-duration = <10>;
+       phy-reset-post-delay = <100>;
        fsl,magic-packet;
        status = "okay";


There is an interesting post from Fabio Estevam

https://u-boot.denx.narkive.com/PlutD3Rg/patch-1-3-phy-atheros-use-ar8035-config-for-ar8031

Thanks
	Andrew

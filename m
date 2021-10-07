Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0CBD0424AD7
	for <lists+netdev@lfdr.de>; Thu,  7 Oct 2021 02:04:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239945AbhJGAGq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Oct 2021 20:06:46 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:53216 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239804AbhJGAGp (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 6 Oct 2021 20:06:45 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=vjULCuyM6E9PqK0agGHV57epTss1vNh4sqRG3ZXPoKI=; b=YgibhvDFgERm7MnZq24jiU5tR3
        vzjLXMcoaKiNIPUgIjnIO7jUvEZQ2N4XKB0o1bLSF4k2XZnNknDE4IUQ/KMFDxRJPEN8kuj1Ari1Z
        XL4GVRNXzmsalAwovlo9XeYarH8tGVoNq8AFd8wTk41YFgAeRgG6xeyyClCTqwLpI5kA=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1mYGu0-009tAD-J7; Thu, 07 Oct 2021 02:04:48 +0200
Date:   Thu, 7 Oct 2021 02:04:48 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Ansuel Smith <ansuelsmth@gmail.com>
Cc:     Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [net-next PATCH 01/13] drivers: net: phy: at803x: fix resume for
 QCA8327 phy
Message-ID: <YV45oPmuEUGW8/yg@lunn.ch>
References: <20211006223603.18858-1-ansuelsmth@gmail.com>
 <20211006223603.18858-2-ansuelsmth@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211006223603.18858-2-ansuelsmth@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Oct 07, 2021 at 12:35:51AM +0200, Ansuel Smith wrote:
> >From Documentation phy resume triggers phy reset and restart
> auto-negotiation. Add a dedicated function to wait reset to finish as
> it was notice a regression where port sometime are not reliable after a
> suspend/resume session. The reset wait logic is copied from phy_poll_reset.
> Add dedicated suspend function to use genphy_suspend only with QCA8337
> phy and set only additional debug settings for QCA8327. With more test
> it was reported that QCA8327 doesn't proprely support this mode and
> using this cause the unreliability of the switch ports, especially the
> malfunction of the port0.
> 
> Fixes: 52a6cdbe43a3 ("net: phy: at803x: add resume/suspend function to qca83xx phy")

Please base it on net, since it is a fix.

> -#define AT803X_DEBUG_REG_3D			0x3D
> +#define AT803X_DEBUG_REG_GREEN			0x3D

Fixes are supposed to be minimal. So i would not include the rename of
3D to GREEN in the fix. Do that in a patch for net-next.

   Andrew

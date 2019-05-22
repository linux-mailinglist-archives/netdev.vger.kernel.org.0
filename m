Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E0EE926A29
	for <lists+netdev@lfdr.de>; Wed, 22 May 2019 20:54:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729583AbfEVSyD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 May 2019 14:54:03 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:43609 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728533AbfEVSyD (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 22 May 2019 14:54:03 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=2+tji27/C7eRJxFWD6jg8abA+FF+0YMzibI9AbiqiLg=; b=pneoZ8aT1sXmD/0Upi2m1wmSvj
        0GuIWoWD0XFqod3U4d/JmKOkrQzwJvif3I4/lygQ6aQtKMTscxu613xWro8FxsFB+y4BWR9481Y8v
        e4blfLJG+lT6Lh8PX2OFX9pvRPan/tJugKw97N6bGcuuMgreWcFRMCjVJBa8P72BXobY=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.89)
        (envelope-from <andrew@lunn.ch>)
        id 1hTWNE-00026e-VR; Wed, 22 May 2019 20:54:00 +0200
Date:   Wed, 22 May 2019 20:54:00 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Trent Piepho <tpiepho@impinj.com>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>
Subject: Re: [PATCH net-next v2 4/8] net: phy: dp83867: Rework delay rgmii
 delay handling
Message-ID: <20190522185400.GB7281@lunn.ch>
References: <20190522184255.16323-1-tpiepho@impinj.com>
 <20190522184255.16323-4-tpiepho@impinj.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190522184255.16323-4-tpiepho@impinj.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, May 22, 2019 at 06:43:23PM +0000, Trent Piepho wrote:
> The code was assuming the reset default of the delay control register
> was to have delay disabled.  This is what the datasheet shows as the
> register's initial value.  However, that's not actually true: the
> default is controlled by the PHY's pin strapping.
> 
> If the interface mode is selected as RX or TX delay only, insure the
> other direction's delay is disabled.
> 
> If the interface mode is just "rgmii", with neither TX or RX internal
> delay, one might expect that the driver should disable both delays.  But
> this is not what the driver does.  It leaves the setting at the PHY's
> strapping's default.  And that default, for no pins with strapping
> resistors, is to have delay enabled and 2.00 ns.
> 
> Rather than change this behavior, I've kept it the same and documented
> it.  No delay will most likely not work and will break ethernet on any
> board using "rgmii" mode.  If the board is strapped to have a delay and
> is configured to use "rgmii" mode a warning is generated that "rgmii-id"
> should have been used.
> 
> Also validate the delay values and fail if they are not in range.
> 
> Cc: Andrew Lunn <andrew@lunn.ch>
> Cc: Florian Fainelli <f.fainelli@gmail.com>
> Cc: Heiner Kallweit <hkallweit1@gmail.com>
> Signed-off-by: Trent Piepho <tpiepho@impinj.com>

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew

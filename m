Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E1D178001A
	for <lists+netdev@lfdr.de>; Fri,  2 Aug 2019 20:18:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2406657AbfHBSSs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Aug 2019 14:18:48 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:57634 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2405976AbfHBSSs (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 2 Aug 2019 14:18:48 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=JCYZVC/M3FiIjiwcLsQNRgrwzjn8oD0+t2wbx/4yCkY=; b=POWpG2umKb7U6UMpO9yXJOhHmd
        HQxcSzbnaPrg+WkF1dGL7YSS3DpZtl7+04FZEubHBMvQDhQwtDmbToGqQW3FIRgW3m6/iCAPt9DMw
        B9a+GxlZnoTUV4WEua+5Vuibii9KHivZ2+VjQGx7jcV6z6Bj3TOlWvu6mPItX/MFObM8=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.89)
        (envelope-from <andrew@lunn.ch>)
        id 1htc8W-0002qb-9p; Fri, 02 Aug 2019 20:18:40 +0200
Date:   Fri, 2 Aug 2019 20:18:40 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Matthias Kaehlcke <mka@chromium.org>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        Douglas Anderson <dianders@chromium.org>
Subject: Re: [PATCH v4 4/4] net: phy: realtek: configure RTL8211E LEDs
Message-ID: <20190802181840.GP2099@lunn.ch>
References: <20190801190759.28201-1-mka@chromium.org>
 <20190801190759.28201-5-mka@chromium.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190801190759.28201-5-mka@chromium.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Aug 01, 2019 at 12:07:59PM -0700, Matthias Kaehlcke wrote:
> Configure the RTL8211E LEDs behavior when the device tree property
> 'realtek,led-modes' is specified.
> 
> Signed-off-by: Matthias Kaehlcke <mka@chromium.org>

Hi Matthias

I was more thinking of adding a new driver call to the PHY driver API,
to configure an LED. Something like

rtl8211e_config_leds(phydev, int led, struct phy_led_config cfg);

It would be called by the phylib core after config_init(). But also,
thinking ahead to generic linux LED support, it could be called later
to reconfigure the LEDs to use a different trigger. The standard LED
sysfs interface would be used.

      Andrew

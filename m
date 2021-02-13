Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DB52631AD42
	for <lists+netdev@lfdr.de>; Sat, 13 Feb 2021 17:51:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229703AbhBMQuT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 13 Feb 2021 11:50:19 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:39242 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229745AbhBMQuO (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 13 Feb 2021 11:50:14 -0500
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1lAy6n-0064fH-34; Sat, 13 Feb 2021 17:49:25 +0100
Date:   Sat, 13 Feb 2021 17:49:25 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Robert Hancock <robert.hancock@calian.com>
Cc:     hkallweit1@gmail.com, davem@davemloft.net, kuba@kernel.org,
        f.fainelli@gmail.com, linux@armlinux.org.uk,
        bcm-kernel-feedback-list@broadcom.com, netdev@vger.kernel.org
Subject: Re: [PATCH net-next v2 2/2] net: phy: broadcom: Do not modify LED
 configuration for SFP module PHYs
Message-ID: <YCgDFeiTOL2jfflk@lunn.ch>
References: <20210213021840.2646187-1-robert.hancock@calian.com>
 <20210213021840.2646187-3-robert.hancock@calian.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210213021840.2646187-3-robert.hancock@calian.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Feb 12, 2021 at 08:18:40PM -0600, Robert Hancock wrote:
> bcm54xx_config_init was modifying the PHY LED configuration to enable link
> and activity indications. However, some SFP modules (such as Bel-Fuse
> SFP-1GBT-06) have no LEDs but use the LED outputs to control the SFP LOS
> signal, and modifying the LED settings will cause the LOS output to
> malfunction. Skip this configuration for PHYs which are bound to an SFP
> bus.

I agree with Russell here. You need to add a quirk to sfp.c which
detects this specific SFP, and sets PHY flag before starting the PHY.

	Andrew

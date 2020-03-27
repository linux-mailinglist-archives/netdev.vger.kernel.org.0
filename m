Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1DA06194DBE
	for <lists+netdev@lfdr.de>; Fri, 27 Mar 2020 01:10:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726540AbgC0AKA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Mar 2020 20:10:00 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:60594 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726067AbgC0AKA (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 26 Mar 2020 20:10:00 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=yBYMbTP3N65eCrwIwvg899ZnFuGNKY1t8iY9m5afKJc=; b=iXtMRWtgiL7AV4xDShotWCaPE+
        DHwd44XJmimb6VJXUlj1mtL78RP6hB5Bp+kDKMveJAV2EnCY/oscbfcKtb7OK+S9FPrnInaFyRxru
        p7+UU3n4iTOY5HqOZWSUD5xeKbu9BvlzqUgQz6A/URTtxReOhj3khInMuyAS0KMSb9TA=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.93)
        (envelope-from <andrew@lunn.ch>)
        id 1jHcZQ-0004o8-9u; Fri, 27 Mar 2020 01:09:56 +0100
Date:   Fri, 27 Mar 2020 01:09:56 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Heiner Kallweit <hkallweit1@gmail.com>
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Russell King - ARM Linux <linux@armlinux.org.uk>,
        David Miller <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [PATCH net-next v2] net: phy: probe PHY drivers synchronously
Message-ID: <20200327000956.GK3819@lunn.ch>
References: <612b81d5-c4c1-5e20-a667-893eeeef0bf5@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <612b81d5-c4c1-5e20-a667-893eeeef0bf5@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Mar 27, 2020 at 01:00:22AM +0100, Heiner Kallweit wrote:
> If we have scenarios like
> 
> mdiobus_register()
> 	-> loads PHY driver module(s)
> 	-> registers PHY driver(s)
> 	-> may schedule async probe
> phydev = mdiobus_get_phy()
> <phydev action involving PHY driver>
> 
> or
> 
> phydev = phy_device_create()
> 	-> loads PHY driver module
> 	-> registers PHY driver
> 	-> may schedule async probe
> <phydev action involving PHY driver>
> 
> then we expect the PHY driver to be bound to the phydev when triggering
> the action. This may not be the case in case of asynchronous probing.
> Therefore ensure that PHY drivers are probed synchronously.
> 
> Default still is sync probing, except async probing is explicitly
> requested. I saw some comments that the intention is to promote
> async probing for more parallelism in boot process and want to be
> prepared for the case that the default is changed to async probing.
> 
> Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew

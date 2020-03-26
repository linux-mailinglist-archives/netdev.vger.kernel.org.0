Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E2382194D53
	for <lists+netdev@lfdr.de>; Fri, 27 Mar 2020 00:34:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727393AbgCZXeS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Mar 2020 19:34:18 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:60440 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726296AbgCZXeS (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 26 Mar 2020 19:34:18 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=bm9m2Uzfv/z9E9EHzmdig+XZ4zim2nrxJ3R+4f8lZQo=; b=GvKhWvlJmF5ZrFuBtJBLQiBX9/
        8L56fLc9tw36WRb+0vb5q+rfTLN159xtVFjtj6lmPBkFDFvOiS9+AXZhhidiTBP5glCevJDjJAHZs
        ouGhYKPKP46SYpUUmyRSAkkkYxSDM7zSVHIYkZcEaGkSBhe9SEvoSIC+WRUB3nluoUCE=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.93)
        (envelope-from <andrew@lunn.ch>)
        id 1jHc0q-0004Pi-06; Fri, 27 Mar 2020 00:34:12 +0100
Date:   Fri, 27 Mar 2020 00:34:11 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Heiner Kallweit <hkallweit1@gmail.com>
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Russell King - ARM Linux <linux@armlinux.org.uk>,
        David Miller <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [PATCH net-next] net: phy: probe PHY drivers synchronously
Message-ID: <20200326233411.GG3819@lunn.ch>
References: <86582ac9-e600-bdb5-3d2e-d2d99ed544f4@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <86582ac9-e600-bdb5-3d2e-d2d99ed544f4@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Mar 26, 2020 at 07:16:23PM +0100, Heiner Kallweit wrote:
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

Hi Heiner

We have been doing asynchronous driver loads since forever, and not
noticed any problem. Do you have a real example of it going wrong?

	Andrew

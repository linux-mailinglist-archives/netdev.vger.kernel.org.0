Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8D6BE391FE5
	for <lists+netdev@lfdr.de>; Wed, 26 May 2021 21:01:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235272AbhEZTDZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 May 2021 15:03:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39386 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235191AbhEZTDW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 May 2021 15:03:22 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4F620C061574;
        Wed, 26 May 2021 12:01:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=TMvprjr4ywx6U/K3Mpwk3Fg3inw4PtVFjzKQGT7I/EI=; b=HShQBKArAxwt9ECdTrlS06qFL
        JVfIoeOHOw/GzUB3RX5FkidwkG+422yfpQClTREgMM6NjSXOnBSqCC/4KeV6V1FnvI5ULiVnkTtWM
        Os5YHirXFD2c/1MPRmgQs6Dp3XL7p/Ky+zobuMaGMseClfMV4tbJTqN3aPHRk/0oE45DIMh2O1gvT
        glv4JrLr+11av2InohzFos0D1y6BxCydGoDacbTL2Djo4syzHKgEQ9uZFELqvkSUeyM5Du3tTw3wL
        kYO5zaSrvkUA3qyOzmklIAejfMP+tiGxpLVkRnBdebzcwzACacTWO4MYsVHw+/T3o7Dxm1cwX/kMr
        B3S79D3Lw==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:44394)
        by pandora.armlinux.org.uk with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <linux@armlinux.org.uk>)
        id 1llymq-000692-Ut; Wed, 26 May 2021 20:01:48 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1llymq-00033r-O6; Wed, 26 May 2021 20:01:48 +0100
Date:   Wed, 26 May 2021 20:01:48 +0100
From:   "Russell King (Oracle)" <linux@armlinux.org.uk>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Florian Fainelli <f.fainelli@gmail.com>, netdev@vger.kernel.org,
        olteanv@gmail.com, Heiner Kallweit <hkallweit1@gmail.com>,
        open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH net] net: phy: Document phydev::dev_flags bits allocation
Message-ID: <20210526190148.GM30436@shell.armlinux.org.uk>
References: <20210526184617.3105012-1-f.fainelli@gmail.com>
 <YK6ZNbClPNCMl0Vx@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YK6ZNbClPNCMl0Vx@lunn.ch>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, May 26, 2021 at 08:53:41PM +0200, Andrew Lunn wrote:
> On Wed, May 26, 2021 at 11:46:17AM -0700, Florian Fainelli wrote:
> > Document the phydev::dev_flags bit allocation to allow bits 15:0 to
> > define PHY driver specific behavior, bits 23:16 to be reserved for now,
> > and bits 31:24 to hold generic PHY driver flags.
> 
> This is good as far as it goes. But do we want to give a hint that if
> the MAC driver sets bits in [15:0] it should first verify the PHY has
> the ID which is expected?

Hi Andrew,

I think we probably need a helper for that - while we can match
phydev->phy_id, that only works for C22 PHYs. Matching the C45
IDs is much more painful. So, I think a helper would be good,
even if initially it just checks the C22 ID.

Thoughts?

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!

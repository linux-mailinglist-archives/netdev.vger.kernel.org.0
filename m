Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 849382E21F4
	for <lists+netdev@lfdr.de>; Wed, 23 Dec 2020 22:13:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729226AbgLWVMb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Dec 2020 16:12:31 -0500
Received: from mail.kernel.org ([198.145.29.99]:49394 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726279AbgLWVMa (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 23 Dec 2020 16:12:30 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 10743223E4;
        Wed, 23 Dec 2020 21:11:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1608757910;
        bh=qA5zu6kLWTjMvdfo1scNBtwChRieVHSK00bO38S7dHw=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=UtpPGvViLwTfXb2WRIrZFzDgpGAAlvFQhp0ToOfInk0z7vRTpCO3nL4rrB8KmOcU+
         6lcVlCRZEITojcJe7OzxK7irYRpmHOnbvD0z7mGka73/xggWbzo42QKUUlZe+D6Nf5
         B6TjMW8zwOQbiqxD4UDabaRkQa9egq/+np5ufB6/2KOUV5mOepOoCoSgPHxRMNy+Pn
         Ux+uNAtZRz3v0MpMwvEYbtqD5HSbuD2UZTZG3/70Vn6c+KRL8w1Zoew/FWVNvCm/nt
         5nLdh7Zpqo1ka2bUcXKKcgo6REo000djrSVwyh8KdjznNpQVSt/+YB9Yc/QSoX+GIe
         iJwLTd4K3FIUA==
Date:   Wed, 23 Dec 2020 13:11:49 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Dinghao Liu <dinghao.liu@zju.edu.cn>, kjlu@umn.edu,
        "David S. Miller" <davem@davemloft.net>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Arnd Bergmann <arnd@arndb.de>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net: ethernet: Fix memleak in ethoc_probe
Message-ID: <20201223131149.15fff8d2@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20201223210044.GA3253993@lunn.ch>
References: <20201223110615.31389-1-dinghao.liu@zju.edu.cn>
        <20201223153304.GD3198262@lunn.ch>
        <20201223123218.1cf7d9cb@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <20201223210044.GA3253993@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 23 Dec 2020 22:00:44 +0100 Andrew Lunn wrote:
> On Wed, Dec 23, 2020 at 12:32:18PM -0800, Jakub Kicinski wrote:
> > On Wed, 23 Dec 2020 16:33:04 +0100 Andrew Lunn wrote:  
> > > On Wed, Dec 23, 2020 at 07:06:12PM +0800, Dinghao Liu wrote:  
> > > > When mdiobus_register() fails, priv->mdio allocated
> > > > by mdiobus_alloc() has not been freed, which leads
> > > > to memleak.
> > > > 
> > > > Signed-off-by: Dinghao Liu <dinghao.liu@zju.edu.cn>    
> > > 
> > > Fixes: bfa49cfc5262 ("net/ethoc: fix null dereference on error exit path")
> > > 
> > > Reviewed-by: Andrew Lunn <andrew@lunn.ch>  
> > 
> > Ooof, I applied without looking at your email and I added:
> > 
> > Fixes: e7f4dc3536a4 ("mdio: Move allocation of interrupts into core")  
> 
> [Goes and looks deeper]
> 
> Yes, commit e7f4dc3536a4 looks like it introduced the original
> problem. bfa49cfc5262 just moved to code around a bit.
> 
> Does patchwork not automagically add Fixes: lines from full up emails?
> That seems like a reasonable automation.

Looks like it's been a TODO for 3 years now:

https://github.com/getpatchwork/patchwork/issues/151

:(

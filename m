Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7AE6E454CF6
	for <lists+netdev@lfdr.de>; Wed, 17 Nov 2021 19:20:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238907AbhKQSXD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Nov 2021 13:23:03 -0500
Received: from mail.kernel.org ([198.145.29.99]:54206 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230094AbhKQSXD (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 17 Nov 2021 13:23:03 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 086C861BC1;
        Wed, 17 Nov 2021 18:20:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637173204;
        bh=FBrlAqhn871oYVvr9mvGIxAz/ecPOq96bNZqG0+QPFw=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=0i+lTezY0Kf4tMj/aQXa51W3F7kfNg0IeEMYP8aAH1Vj4tckDivXscIMPB24/bpSf
         D/n+vqhCc16u7dHF050vKvuueoMRr5PbrgfWny6PDKQsn6AL9/AvGZQvO8/GfzUW44
         ucCfYdRWsT/9MJvFXmbvLrFdE7cC6rEtS5oT7ocQ=
Date:   Wed, 17 Nov 2021 19:20:02 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Florian Fainelli <f.fainelli@gmail.com>
Cc:     stable@vger.kernel.org, Corentin Labbe <clabbe.montjoie@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        "David S . Miller" <davem@davemloft.net>,
        "open list:ETHERNET PHY LIBRARY" <netdev@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH stable 4.9] net: mdio-mux: fix unbalanced put_device
Message-ID: <YZVH0u5bTOXhQw56@kroah.com>
References: <20211117180309.2737514-1-f.fainelli@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211117180309.2737514-1-f.fainelli@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Nov 17, 2021 at 10:03:08AM -0800, Florian Fainelli wrote:
> From: Corentin Labbe <clabbe.montjoie@gmail.com>
> 
> commit 60f786525032432af1b7d9b8935cb12936244ccd upstream
> 
> mdio_mux_uninit() call put_device (unconditionally) because of
> of_mdio_find_bus() in mdio_mux_init.
> But of_mdio_find_bus is only called if mux_bus is empty.
> If mux_bus is set, mdio_mux_uninit will print a "refcount_t: underflow"
> trace.
> 
> This patch add a get_device in the other branch of "if (mux_bus)".
> 
> Signed-off-by: Corentin Labbe <clabbe.montjoie@gmail.com>
> Reviewed-by: Andrew Lunn <andrew@lunn.ch>
> Signed-off-by: David S. Miller <davem@davemloft.net>
> Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
> ---
> Note: this patch did not get any fixes tag, but it does fix issues
> introduced by  fdf3b78df4d2 ("mdio: mux: Correct mdio_mux_init error
> path issues").

Now queued up, thanks.

greg k-h

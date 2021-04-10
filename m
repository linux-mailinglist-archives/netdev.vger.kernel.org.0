Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C008635A9DA
	for <lists+netdev@lfdr.de>; Sat, 10 Apr 2021 03:14:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235396AbhDJBNl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Apr 2021 21:13:41 -0400
Received: from mail.kernel.org ([198.145.29.99]:36808 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235330AbhDJBNk (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 9 Apr 2021 21:13:40 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A696E610E5;
        Sat, 10 Apr 2021 01:13:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1618017206;
        bh=3evecR3+DwkpcpYRK8824Qk9fr5Pz5G17S7Mip6Jbtw=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=flVub5aWUfDcUIsqEZkSFdFct2FvMVm1hsfGP0YWuTRm3qRAYAclvI9fzYWR/CRJH
         YPHcoC7mHZLQk70Nn4gVGvewM/a3ahvQNSv0QK3jk7EPLygdbtkkpwGk1aOyVJBx7C
         vUv/Jfy8aAZhzenq0SGDMBTTBh0/TyOyxSC+W6sfWBRUxYNXMBy7F2IhsTdzfjSmmd
         +t0pzzm7NvnB+E8Cm1e5QMvojMtq/6v2G+NNB93t5jmKzgYWQ47Xoc97go3Fre6d2t
         6I061olx29Ji3kJb/ZSFYMBHLXWI19vCzIJYdPGVGCGrfWkPYT5V6TzA6sLYIhZMgN
         q5ms9CXVzQ0NA==
Date:   Fri, 9 Apr 2021 18:13:25 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Heiner Kallweit <hkallweit1@gmail.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Russell King - ARM Linux <linux@armlinux.org.uk>,
        David Miller <davem@davemloft.net>,
        Fugang Duan <fugang.duan@nxp.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Joakim Zhang <qiangqing.zhang@nxp.com>
Subject: Re: [PATCH net-next 0/3] net: make PHY PM ops a no-op if MAC driver
 manages PHY PM
Message-ID: <20210409181325.0c915f4d@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <9e695411-ab1d-34fe-8b90-3e8192ab84f6@gmail.com>
References: <9e695411-ab1d-34fe-8b90-3e8192ab84f6@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 7 Apr 2021 17:50:46 +0200 Heiner Kallweit wrote:
> Resume callback of the PHY driver is called after the one for the MAC
> driver. The PHY driver resume callback calls phy_init_hw(), and this is
> potentially problematic if the MAC driver calls phy_start() in its resume
> callback. One issue was reported with the fec driver and a KSZ8081 PHY
> which seems to become unstable if a soft reset is triggered during aneg.
> 
> The new flag allows MAC drivers to indicate that they take care of
> suspending/resuming the PHY. Then the MAC PM callbacks can handle
> any dependency between MAC and PHY PM.

Applied, thanks!

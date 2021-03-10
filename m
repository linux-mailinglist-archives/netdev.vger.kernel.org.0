Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3242E334BEF
	for <lists+netdev@lfdr.de>; Wed, 10 Mar 2021 23:49:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233077AbhCJWs6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Mar 2021 17:48:58 -0500
Received: from mail.kernel.org ([198.145.29.99]:60696 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233150AbhCJWsx (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 10 Mar 2021 17:48:53 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 090F864F60;
        Wed, 10 Mar 2021 22:48:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1615416529;
        bh=hMhnxe2pT2lcv/axs+glNzsnZ5FBBEWTJS4v8suCwjY=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=mj9WPA4pXbA+qEUD0Xe2o6g6OwxZAunjyXrn1eEvjRRPpEIdUDfC4P0tUuje8zRT7
         n2gTvNWGDNGMiWw411KPeFvOnKpoj/njY6b9Dz/iuqJlnz+btc5A78UtsUE3z5dT4q
         LtCDEUw4gcAEdRS51bhLzvwexDO7hJtdEI3YcOgsP1kSsEGn9vPuWL6j0ggiVL8tQ+
         8UmBkZaNfpjh4PmfwSaVtCSO+eAkqnerhcAfVKOxWITvU1pgVGxaD5p0DnVZQeDS7n
         fvMct3H07A7zI/0Auzrda4j9n8OxxCVRzAluheKej+qRGTCiIMaJJ6v68T1CCGvErb
         OTqpAc0Wz4t9w==
Date:   Wed, 10 Mar 2021 14:48:48 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Florian Fainelli <f.fainelli@gmail.com>
Cc:     netdev@vger.kernel.org, Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S. Miller" <davem@davemloft.net>,
        linux-kernel@vger.kernel.org (open list)
Subject: Re: [PATCH net-next] net: phy: Expose phydev::dev_flags through
 sysfs
Message-ID: <20210310144848.53ffbbd9@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20210310221244.2968469-1-f.fainelli@gmail.com>
References: <20210310221244.2968469-1-f.fainelli@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 10 Mar 2021 14:12:43 -0800 Florian Fainelli wrote:
> phydev::dev_flags contains a bitmask of configuration bits requested by
> the consumer of a PHY device (Ethernet MAC or switch) towards the PHY
> driver. Since these flags are often used for requesting LED or other
> type of configuration being able to quickly audit them without
> instrumenting the kernel is useful.
> 
> Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
> ---
>  Documentation/ABI/testing/sysfs-class-net-phydev | 12 ++++++++++++
>  drivers/net/phy/phy_device.c                     | 11 +++++++++++
>  2 files changed, 23 insertions(+)
> 
> diff --git a/Documentation/ABI/testing/sysfs-class-net-phydev b/Documentation/ABI/testing/sysfs-class-net-phydev
> index 40ced0ea4316..ac722dd5e694 100644
> --- a/Documentation/ABI/testing/sysfs-class-net-phydev
> +++ b/Documentation/ABI/testing/sysfs-class-net-phydev
> @@ -51,3 +51,15 @@ Description:
>  		Boolean value indicating whether the PHY device is used in
>  		standalone mode, without a net_device associated, by PHYLINK.
>  		Attribute created only when this is the case.
> +
> +What:		/sys/class/mdio_bus/<bus>/<device>/phy_dev_flags
> +Date:		March 2021
> +KernelVersion:	5.13
> +Contact:	netdev@vger.kernel.org
> +Description:
> +		32-bit hexadecimal number representing a bit mask of the
> +		configuration bits passed from the consumer of the PHY
> +		(Ethernet MAC, switch, etc.) to the PHY driver. The flags are
> +		only used internally by the kernel and their placement are
> +		not meant to be stable across kernel versions. This is intended
> +		for facilitating the debugging of PHY drivers.

Why not debugfs, then?


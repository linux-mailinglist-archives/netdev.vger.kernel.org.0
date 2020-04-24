Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E09F41B773C
	for <lists+netdev@lfdr.de>; Fri, 24 Apr 2020 15:43:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728145AbgDXNmq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Apr 2020 09:42:46 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:60858 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726667AbgDXNmp (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 24 Apr 2020 09:42:45 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=K/wuW35fCeVAxwxu9PaLKs0VDsc/O/tT3lplBdlNIHk=; b=pceQaPqPZele9yUDVkCTmJaCJa
        GaM0FxwqoKga+jO7qsdOmKuA71oqfoaW2LgmP9JmUb9jQo87Ff9BIpq05a9F2lI3gyKx6X7pdK4v7
        RchVvTiNAc6OQcZWJK373PjpAvJ4VPRt35S24z+GAQqWpo7ezUVhRC+5T1eKIrOl+rLY=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.93)
        (envelope-from <andrew@lunn.ch>)
        id 1jRybE-004Yyc-G2; Fri, 24 Apr 2020 15:42:36 +0200
Date:   Fri, 24 Apr 2020 15:42:36 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Florinel Iordache <florinel.iordache@nxp.com>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, f.fainelli@gmail.com,
        hkallweit1@gmail.com, linux@armlinux.org.uk,
        devicetree@vger.kernel.org, linux-doc@vger.kernel.org,
        robh+dt@kernel.org, mark.rutland@arm.com, kuba@kernel.org,
        corbet@lwn.net, shawnguo@kernel.org, leoyang.li@nxp.com,
        madalin.bucur@oss.nxp.com, ioana.ciornei@nxp.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next v2 3/9] net: phy: add kr phy connection type
Message-ID: <20200424134236.GB1087366@lunn.ch>
References: <1587732391-3374-1-git-send-email-florinel.iordache@nxp.com>
 <1587732391-3374-4-git-send-email-florinel.iordache@nxp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1587732391-3374-4-git-send-email-florinel.iordache@nxp.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Apr 24, 2020 at 03:46:25PM +0300, Florinel Iordache wrote:
> Add support for backplane kr phy connection types currently available
> (10gbase-kr, 40gbase-kr4) and the required phylink updates (cover all
> the cases for KR modes which are clause 45 compatible to correctly assign
> phy_interface and phylink#supported)
> 
> Signed-off-by: Florinel Iordache <florinel.iordache@nxp.com>
> ---
>  drivers/net/phy/phylink.c | 15 ++++++++++++---
>  include/linux/phy.h       |  6 +++++-
>  2 files changed, 17 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/net/phy/phylink.c b/drivers/net/phy/phylink.c
> index 34ca12a..9a31f68 100644
> --- a/drivers/net/phy/phylink.c
> +++ b/drivers/net/phy/phylink.c
> @@ -4,6 +4,7 @@
>   * technologies such as SFP cages where the PHY is hot-pluggable.
>   *
>   * Copyright (C) 2015 Russell King
> + * Copyright 2020 NXP
>   */
>  #include <linux/ethtool.h>
>  #include <linux/export.h>
> @@ -304,7 +305,6 @@ static int phylink_parse_mode(struct phylink *pl, struct fwnode_handle *fwnode)
>  			break;
>  
>  		case PHY_INTERFACE_MODE_USXGMII:
> -		case PHY_INTERFACE_MODE_10GKR:
>  		case PHY_INTERFACE_MODE_10GBASER:
>  			phylink_set(pl->supported, 10baseT_Half);
>  			phylink_set(pl->supported, 10baseT_Full);

Hi Florinel

What about the issues pointed out in:

https://www.spinics.net/lists/netdev/msg641046.html

	Andrew

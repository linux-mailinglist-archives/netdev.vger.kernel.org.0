Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2B7E68A95B
	for <lists+netdev@lfdr.de>; Mon, 12 Aug 2019 23:32:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727144AbfHLVc2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Aug 2019 17:32:28 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:54564 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726144AbfHLVc2 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 12 Aug 2019 17:32:28 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=4dEqu1ylg8H5FaiIyy64LiGsCCfnlkBJ4J07GmJuJLg=; b=Qnkv/JNkar6HqaI2vZZohC0y9T
        oi92XZ/zL5BoGzoAHXxy0Q/cyo6hJOl1RgaL6fuep47u1P8aPmtmgku/l0+yNH4+apB1tLdJkiEkL
        ZM9WcMacIZUHPrOyJyu5MOWARG+/VEe5SLZRqNlgmFDh7a4KTlJHwQtSwG7thtkOaa4c=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.89)
        (envelope-from <andrew@lunn.ch>)
        id 1hxHvV-0004UD-7Q; Mon, 12 Aug 2019 23:32:25 +0200
Date:   Mon, 12 Aug 2019 23:32:25 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Heiner Kallweit <hkallweit1@gmail.com>
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        David Miller <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [PATCH net-next 2/3] net: phy: add __phy_speed_down and
 phy_resolve_min_speed
Message-ID: <20190812213225.GC15047@lunn.ch>
References: <0799ec1f-307c-25ab-0259-b8239e4e04ba@gmail.com>
 <e499c226-7141-d5be-990c-b46b7dd048f8@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e499c226-7141-d5be-990c-b46b7dd048f8@gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> +int __phy_speed_down(struct phy_device *phydev)
> +{
> +	int min_common_speed = phy_resolve_min_speed(phydev, true);
> +
> +	if (min_common_speed == SPEED_UNKNOWN)
> +		return -EINVAL;
> +
> +	return __set_linkmode_max_speed(phydev, min_common_speed,
> +					phydev->advertising);
> +}
> +
>  static void mmd_phy_indirect(struct mii_bus *bus, int phy_addr, int devad,
>  			     u16 regnum)
>  {
> diff --git a/include/linux/phy.h b/include/linux/phy.h
> index 781f4810c..4be6d3b47 100644
> --- a/include/linux/phy.h
> +++ b/include/linux/phy.h
> @@ -665,6 +665,7 @@ size_t phy_speeds(unsigned int *speeds, size_t size,
>  		  unsigned long *mask);
>  void of_set_phy_supported(struct phy_device *phydev);
>  void of_set_phy_eee_broken(struct phy_device *phydev);
> +int __phy_speed_down(struct phy_device *phydev);

It seems odd having a __ function exported. Can we find a better name
for it, and drop the __?

    Andrew

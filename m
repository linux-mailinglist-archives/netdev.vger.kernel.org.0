Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2C8DD177CD5
	for <lists+netdev@lfdr.de>; Tue,  3 Mar 2020 18:09:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729664AbgCCRIw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Mar 2020 12:08:52 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:44040 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727894AbgCCRIv (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 3 Mar 2020 12:08:51 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=3jWTh/gyHuP0JwZCERtjuQX0oP0LMIya7VtQSjCh4fU=; b=qo7DXLJyUWCmhiRAaiGhijrW4m
        T56V024GBjJh2rBbt2mXoWBrtEj55o/YLFxTyqOfdTvWlqZWKYScVxX4uiSIx+ItZ/lEkbGceEJF+
        sDoVDRHeHohz1HUEwmYiqIEE6t+rY3az1ZlYg9nLSqrhREUODX990OmkFvettaei+yqs=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.93)
        (envelope-from <andrew@lunn.ch>)
        id 1j9B2F-0007tS-N0; Tue, 03 Mar 2020 18:08:47 +0100
Date:   Tue, 3 Mar 2020 18:08:47 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Russell King <rmk+kernel@armlinux.org.uk>
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Antoine Tenart <antoine.tenart@bootlin.com>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org
Subject: Re: [PATCH net-next v2 2/3] net: phy: marvell10g: add energy detect
 power down tunable
Message-ID: <20200303170847.GK24912@lunn.ch>
References: <20200303155347.GS25745@shell.armlinux.org.uk>
 <E1j99s6-00011Y-UI@rmk-PC.armlinux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <E1j99s6-00011Y-UI@rmk-PC.armlinux.org.uk>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> +static int mv3310_get_tunable(struct phy_device *phydev,
> +			      struct ethtool_tunable *tuna, void *data)
> +{
> +	switch (tuna->id) {
> +	case ETHTOOL_PHY_EDPD:
> +		return mv3310_get_edpd(phydev, data);
> +	default:
> +		return -EINVAL;
> +	}
> +}
> +
> +static int mv3310_set_tunable(struct phy_device *phydev,
> +			      struct ethtool_tunable *tuna, const void *data)
> +{
> +	switch (tuna->id) {
> +	case ETHTOOL_PHY_EDPD:
> +		return mv3310_set_edpd(phydev, *(u16 *)data);
> +	default:
> +		return -EINVAL;
> +	}
> +}

Hi Russell

Looking at other PHY drivers, all but mscc.c return EOPNOTSUPP.
mscc.c is the only other driver which returns EINVAL. EOPNOTSUPP does
seem more appropriate.

Thanks
	Andrew

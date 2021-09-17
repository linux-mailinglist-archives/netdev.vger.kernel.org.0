Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9C79440FAAA
	for <lists+netdev@lfdr.de>; Fri, 17 Sep 2021 16:45:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233248AbhIQOrC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Sep 2021 10:47:02 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:46466 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230009AbhIQOqk (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 17 Sep 2021 10:46:40 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=SJmSYEZ9zU3MqEbDt3zgJ+gHfjq80okIxKSVKSJdKT8=; b=JGKwN34Bg7sU5R35hxo+3VFr3V
        0z2WA+/pxQkAIuhxUTICNbOPaK5whbOQYEczFLdYA/yPO8tlyVfbGfdV46cO986l674fF4O1qsJg7
        MlFBA+YPbRLONxPabVgMB4qTY4AJi5KYPIqk/tS4OS06aXRM1s+AP7E/n5Hlm+hyleoA=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1mRF6t-0075Dg-PP; Fri, 17 Sep 2021 16:45:03 +0200
Date:   Fri, 17 Sep 2021 16:45:03 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Russell King <rmk+kernel@armlinux.org.uk>
Cc:     Heiner Kallweit <hkallweit1@gmail.com>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        Marek Beh__n <kabel@kernel.org>,
        Jakub Kicinski <kuba@kernel.org>
Subject: Re: [PATCH net-next] net: phy: marvell10g: add downshift tunable
 support
Message-ID: <YUSp78o/vfZNFCJw@lunn.ch>
References: <E1mREEN-001yxo-Da@rmk-PC.armlinux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <E1mREEN-001yxo-Da@rmk-PC.armlinux.org.uk>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> +static int mv3310_set_downshift(struct phy_device *phydev, u8 ds)
> +{
> +	struct mv3310_priv *priv = dev_get_drvdata(&phydev->mdio.dev);
> +	u16 val;
> +	int err;
> +
> +	if (!priv->has_downshift)
> +		return -EOPNOTSUPP;
> +
> +	if (ds == DOWNSHIFT_DEV_DISABLE)
> +		return phy_clear_bits_mmd(phydev, MDIO_MMD_PCS, MV_PCS_DSC1,
> +					  MV_PCS_DSC1_ENABLE);
> +
> +	/* FIXME: The default is disabled, so should we disable? */
> +	if (ds == DOWNSHIFT_DEV_DEFAULT_COUNT)
> +		ds = 2;

Hi Russell

Rather than a FIXME, maybe just document that the hardware default is
disabled, which does not make too much sense, so default to 2 attempts?

      Andrew


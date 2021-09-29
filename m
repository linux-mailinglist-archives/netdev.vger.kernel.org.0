Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DD1D541C8CD
	for <lists+netdev@lfdr.de>; Wed, 29 Sep 2021 17:54:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345432AbhI2Pz0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Sep 2021 11:55:26 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:38546 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1345414AbhI2PzY (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 29 Sep 2021 11:55:24 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=kC9z6ajYVZSqfr5M4T7TgVdxt1JUa9WFNmhSM3NKWHo=; b=lUmmay0yuC3UGRVKnLnXKQmjf2
        GCrlEvuCN1fGa3+gEGOnZbZhrNQXNGjDXZb+VtcZvz1N6367cgfcbVvxDMhc+Csa8+tY2ksSY7vdq
        bLyIp5Ebjea8Ib6ySCTNKjFRpEXnb/l7h9OGSRLZVVAx/NSwHYNsmQ+w/QkGTTNneYJ8=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1mVbtr-008nQY-98; Wed, 29 Sep 2021 17:53:39 +0200
Date:   Wed, 29 Sep 2021 17:53:39 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Russell King <rmk+kernel@armlinux.org.uk>
Cc:     Heiner Kallweit <hkallweit1@gmail.com>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        Marek Beh__n <kabel@kernel.org>,
        Jakub Kicinski <kuba@kernel.org>
Subject: Re: [PATCH v2 net-next] net: phy: marvell10g: add downshift tunable
 support
Message-ID: <YVSMAyxgJSqz+gRk@lunn.ch>
References: <E1mVbVt-0004Fh-Dv@rmk-PC.armlinux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <E1mVbVt-0004Fh-Dv@rmk-PC.armlinux.org.uk>
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
> +	/* DOWNSHIFT_DEV_DEFAULT_COUNT is confusing. It looks like it should
> +	 * set the default settings for the PHY. However, it is used for
> +	 * "ethtool --set-phy-tunable ethN downshift on". The intention is
> +	 * to enable downshift at a default number of retries. The default
> +	 * settings for 88x3310 are for two retries with downshift disabled.
> +	 * So let's use two retries with downshift enabled.
> +	 */
> +	if (ds == DOWNSHIFT_DEV_DEFAULT_COUNT)
> +		ds = 2;

That is sensible and explains what is going on. Thanks.

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew

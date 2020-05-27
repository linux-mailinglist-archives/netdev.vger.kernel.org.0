Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 293B11E341E
	for <lists+netdev@lfdr.de>; Wed, 27 May 2020 02:42:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727022AbgE0Am1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 May 2020 20:42:27 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:50860 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726835AbgE0Am1 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 26 May 2020 20:42:27 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=5rqWhNxnEWM2DWyLWAl8r0qKrNaot5Y4p6nmyXUDIHk=; b=CdZGDRw+maTbVmaL+3K8beWaHQ
        YtMnnnlGYSAqqwPCojnZt9pKTZn4KGoLfeezV4XpdUVwsEh+11vfBG1/EOCU3OEXElVzQwaFfVRvL
        ULK1Yi6ogtK+p8n9U3aHTYrSObnmmJzLG7apQZVATN+Eu8EUNkoGHTVa7zZPjFKxHXdA=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.93)
        (envelope-from <andrew@lunn.ch>)
        id 1jdk9E-003LBz-Rq; Wed, 27 May 2020 02:42:20 +0200
Date:   Wed, 27 May 2020 02:42:20 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Dan Murphy <dmurphy@ti.com>
Cc:     f.fainelli@gmail.com, hkallweit1@gmail.com, davem@davemloft.net,
        robh@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org
Subject: Re: [PATCH net-next v3 2/4] net: phy: Add a helper to return the
 index for of the internal delay
Message-ID: <20200527004220.GE782807@lunn.ch>
References: <20200526174716.14116-1-dmurphy@ti.com>
 <20200526174716.14116-3-dmurphy@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200526174716.14116-3-dmurphy@ti.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> +/**
> + * phy_get_delay_index - returns the index of the internal delay
> + * @phydev: phy_device struct
> + * @delay_values: array of delays the PHY supports
> + * @size: the size of the delay array
> + * @int_delay: the internal delay to be looked up
> + * @descending: if the delay array is in descending order
> + *
> + * Returns the index within the array of internal delay passed in.
> + * Return errno if the delay is invalid or cannot be found.
> + */
> +s32 phy_get_delay_index(struct phy_device *phydev, int *delay_values, int size,
> +			int int_delay, bool descending)
> +{
> +	if (int_delay < 0)
> +		return -EINVAL;
> +
> +	if (size <= 0)
> +		return -EINVAL;
> +
> +	if (descending)
> +		return phy_find_descending_delay(phydev, delay_values, size,
> +						 int_delay);
> +
> +	return phy_find_ascending_delay(phydev, delay_values, size, int_delay);
> +}
> +EXPORT_SYMBOL(phy_get_delay_index);

Do we really need this ascending vs descending? This array is not
coming from device tree of anything, it is a static list in the PHY
driver. I would just define it needs to be ascending and be done.

	Andrew

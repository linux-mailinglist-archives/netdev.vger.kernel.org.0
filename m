Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D026713AADA
	for <lists+netdev@lfdr.de>; Tue, 14 Jan 2020 14:25:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728844AbgANNZF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Jan 2020 08:25:05 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:36328 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728831AbgANNZE (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 14 Jan 2020 08:25:04 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=d0dk/vJKrd8zNhb4VFZv8LITp9cxyp3uVig/z78F/kM=; b=ljQ6VAGETZTAqZlBlH4nGoMqhR
        GoKg23NeI1dJMtzX01F8YblNNGEhL12yp7HetK00yRbyVokudcKdJdiwao3gTok4uo7pUMbovaMK+
        exBhcnFYyMKoajSWO2hfufOGXIUHq47YgaWPlA7QNda1LQ4Kt40exNVmIHjcwSBlJOQU=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.93)
        (envelope-from <andrew@lunn.ch>)
        id 1irMBq-0002XJ-FB; Tue, 14 Jan 2020 14:25:02 +0100
Date:   Tue, 14 Jan 2020 14:25:02 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Michael Grzeschik <m.grzeschik@pengutronix.de>
Cc:     netdev@vger.kernel.org, f.fainelli@gmail.com, hkallweit1@gmail.com,
        kernel@pengutronix.de
Subject: Re: [PATCH] net: phy: dp83867: Set FORCE_LINK_GOOD do default after
 reset
Message-ID: <20200114132502.GH11788@lunn.ch>
References: <20200114112425.19967-1-m.grzeschik@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200114112425.19967-1-m.grzeschik@pengutronix.de>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Michael

> @@ -635,6 +636,16 @@ static int dp83867_phy_reset(struct phy_device *phydev)
>  
>  	usleep_range(10, 20);
>  
> +	/* After reset FORCE_LINK_GOOD bit is set. Although the
> +	 * default value should be unset. Disable FORCE_LINK_GOOD
> +	 * for the phy to work properly.
> +	 */
> +	val = phy_read(phydev, MII_DP83867_PHYCTRL);
> +	if (val & DP83867_PHYCR_FORCE_LINK_GOOD) {
> +		val &= ~(DP83867_PHYCR_FORCE_LINK_GOOD);
> +		phy_write(phydev, MII_DP83867_PHYCTRL, val);
> +	}

You could use phy_modify().

    Andrew

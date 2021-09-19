Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A90C3410C69
	for <lists+netdev@lfdr.de>; Sun, 19 Sep 2021 18:44:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234000AbhISQpq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 19 Sep 2021 12:45:46 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:48534 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230063AbhISQpq (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 19 Sep 2021 12:45:46 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=mce8cWyUQX6AmdOseIhXtBb5z0qeB9sYuTh9PTAolUc=; b=Qms638x+ItpXke48Q5oX+6pXBX
        /EkcKGe0/wFHNW2z8KKu5WQlA0kPY3z+ilknZwQwK2IUhUF11RbaxNTvfsYafMka+2NTwuf+dlDOs
        ycF9sxlY4cOuJJF05z13Nwa2fetuTECpNiIDNTtUUj49c2f1P4bUQyC2ui4zmwm1KYz8=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1mRzvI-007MZB-R5; Sun, 19 Sep 2021 18:44:12 +0200
Date:   Sun, 19 Sep 2021 18:44:12 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Ansuel Smith <ansuelsmth@gmail.com>
Cc:     Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [net-next PATCH 2/3] net: phy: at803x: add resume/suspend
 function to qca83xx phy
Message-ID: <YUdo3G1XdxdSv4Fa@lunn.ch>
References: <20210919151146.10501-1-ansuelsmth@gmail.com>
 <20210919151146.10501-2-ansuelsmth@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210919151146.10501-2-ansuelsmth@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> +static int qca83xx_suspend(struct phy_device *phydev)
> +{
> +	phy_modify(phydev, MII_BMCR, 0, BMCR_PDOWN);
> +
> +	return 0;
> +}
> +
> +static int qca83xx_resume(struct phy_device *phydev)
> +{
> +	return phy_modify(phydev, MII_BMCR, BMCR_PDOWN, 0);
> +}
> +

genphy_suspend() and genphy_resume() do exactly this. Please use the
helpers.

Please also add a patch 0/3 which explains the big picture. It will be
used in the merge commit.

	Andrew

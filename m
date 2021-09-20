Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 04BF84113D0
	for <lists+netdev@lfdr.de>; Mon, 20 Sep 2021 13:52:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237306AbhITLyG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Sep 2021 07:54:06 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:49940 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230037AbhITLyF (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 20 Sep 2021 07:54:05 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=yGE8gpbmE7JEaUwJzRYJcDw6OeJj0fv2qAbkqApHilU=; b=v8ypol8CHDW+nq/kmj6lcE3eP5
        IqSiooPJCsz5hzR9c7OrsObf4jclmAW9+rLtNr1Vea8nQaCEyfoXMLkfYzfDIRsjpQuNpP8n5IxjF
        ba4WqRbR9MAKoZxT66EtLc569vI/AV0bbLjbyhC1iIzVgQ92D1F9StzFQOYn+ANSfxPo=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1mSHqA-007UX0-Ba; Mon, 20 Sep 2021 13:52:06 +0200
Date:   Mon, 20 Sep 2021 13:52:06 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Horatiu Vultur <horatiu.vultur@microchip.com>
Cc:     davem@davemloft.net, kuba@kernel.org, robh+dt@kernel.org,
        linux@armlinux.org.uk, f.fainelli@gmail.com,
        alexandre.belloni@bootlin.com, vladimir.oltean@nxp.com,
        UNGLinuxDriver@microchip.com, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-phy@lists.infradead.org, linux-pm@vger.kernel.org
Subject: Re: [RFC PATCH net-next 01/12] net: mdio: mscc-miim: Fix the mdio
 controller
Message-ID: <YUh15ieAzBiCVeX9@lunn.ch>
References: <20210920095218.1108151-1-horatiu.vultur@microchip.com>
 <20210920095218.1108151-2-horatiu.vultur@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210920095218.1108151-2-horatiu.vultur@microchip.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Sep 20, 2021 at 11:52:07AM +0200, Horatiu Vultur wrote:
> According to the documentation the second resource is optional. But the
> blamed commit ignores that and if the resource is not there it just
> fails.
> 
> This patch reverts that to still allow the second resource to be
> optional because other SoC have the some MDIO controller and doesn't
> need to second resource.
> 
> Fixes: 672a1c394950 ("net: mdio: mscc-miim: Make use of the helper function devm_platform_ioremap_resource()")
> Signed-off-by: Horatiu Vultur <horatiu.vultur@microchip.com>

Hi Moratiu

The script kiddies might come long and 'fix' this again. Maybe
consider adding devm_platform_ioremap_resource_optional(), following
the pattern of other _optional() API calls. Otherwise add a comment.

    Andrew

Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F3216436215
	for <lists+netdev@lfdr.de>; Thu, 21 Oct 2021 14:50:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230374AbhJUMwc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Oct 2021 08:52:32 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:50526 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230231AbhJUMwc (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 21 Oct 2021 08:52:32 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=oy6v5iVZJiolJ9FVtEYshkEVwEiT0r5Ra+Ipjg/HDbk=; b=PmR/RcgwEJVNtnk+3hE/VaFcvl
        SHUY571C09KsfJSTzbO6avyBCe7XyZM9lUgV0PrYb0dc/KEljI4+zSccxATxqbEANncuEzrLXHDyu
        QmFfZF/InF6N7kBX/3ZY73tG/Ld/TouoBqrpxwszNHAzVVfaj+ysbvBMZI8t4nMrhwpQ=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1mdXWI-00BHp2-MK; Thu, 21 Oct 2021 14:50:06 +0200
Date:   Thu, 21 Oct 2021 14:50:06 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Matthias Schiffer <matthias.schiffer@ew.tq-group.com>
Cc:     Joakim Zhang <qiangqing.zhang@nxp.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: (EXT) Re: [PATCH] net: fec: defer probe if PHY on external MDIO
 bus is not available
Message-ID: <YXFh/nLTqvCsLAXj@lunn.ch>
References: <20211014113043.3518-1-matthias.schiffer@ew.tq-group.com>
 <YW7SWKiUy8LfvSkl@lunn.ch>
 <aae9573f89560a32da0786dc90cb7be0331acad4.camel@ew.tq-group.com>
 <YXBk8gwuCqrxDbVY@lunn.ch>
 <c286107376a99ca2201db058e1973e2b2264e9fb.camel@ew.tq-group.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c286107376a99ca2201db058e1973e2b2264e9fb.camel@ew.tq-group.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> I would love to do this, but driver-api/driver-model/driver.rst
> contains the following warning:
> 
>       -EPROBE_DEFER must not be returned if probe() has already created
>       child devices, even if those child devices are removed again
>       in a cleanup path. If -EPROBE_DEFER is returned after a child
>       device has been registered, it may result in an infinite loop of
>       .probe() calls to the same driver.
> 
> My understanding of this is that there is simply no way to return
> -EPROBE_DEFER after fec_enet_mii_init(pdev).

It might say that, but lots of network drivers actually do this. I've
not seen an endless loop.

    Andrew

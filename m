Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4778339C173
	for <lists+netdev@lfdr.de>; Fri,  4 Jun 2021 22:40:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231437AbhFDUlr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Jun 2021 16:41:47 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:46122 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229854AbhFDUlq (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 4 Jun 2021 16:41:46 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=m+QYsXtela9hi8J1/G3KHsdwFHjEwfV4evj5iomCfyc=; b=c1LQHFC2cd7Vs30Y233twMpsOx
        nIAo8wsA/1qrcFYzXmf4ZVrG5MQqrWrVFnROzA+b2SbrvqYS2yax6Dv6wZGy7d/J8RpKv+bT45h2H
        BpK1DJpo2jETcA3L3DhkudxymFjf2XjRh1jkVmfu4LGe6eXS2lMLJUGxtOUman5jRm8g=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1lpGbm-007qwP-Oy; Fri, 04 Jun 2021 22:39:58 +0200
Date:   Fri, 4 Jun 2021 22:39:58 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Liang Xu <lxu@maxlinear.com>
Cc:     "hkallweit1@gmail.com" <hkallweit1@gmail.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "vee.khee.wong@linux.intel.com" <vee.khee.wong@linux.intel.com>,
        "linux@armlinux.org.uk" <linux@armlinux.org.uk>,
        Hauke Mehrtens <hmehrtens@maxlinear.com>,
        Thomas Mohren <tmohren@maxlinear.com>
Subject: Re: [PATCH v2] net: phy: add Maxlinear GPY115/21x/24x driver
Message-ID: <YLqPnpNXbd6o019o@lunn.ch>
References: <20210603073438.33967-1-lxu@maxlinear.com>
 <YLoZWho/5a60wqPu@lunn.ch>
 <797fe98f-ab65-8633-dadc-beed56d251d0@maxlinear.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <797fe98f-ab65-8633-dadc-beed56d251d0@maxlinear.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jun 04, 2021 at 12:52:02PM +0000, Liang Xu wrote:
> On 4/6/2021 8:15 pm, Andrew Lunn wrote:
> > This email was sent from outside of MaxLinear.
> >
> >
> >> +config MXL_GPHY
> >> +     tristate "Maxlinear PHYs"
> >> +     help
> >> +       Support for the Maxlinear GPY115, GPY211, GPY212, GPY215,
> >> +       GPY241, GPY245 PHYs.
> > Do these PHYs have unique IDs in register 2 and 3? What is the format
> > of these IDs?
> >
> > The OUI is fixed. But often the rest is split into two. The higher
> > part indicates the product, and the lower part is the revision. We
> > then have a struct phy_driver for each product, and the mask is used
> > to match on all the revisions of the product.
> >
> >       Andrew
> >
> Register 2, Register 3 bit 10~15 - OUI
> 
> Register 3 bit 4~9 - product number
> 
> Register 3 bit 0~3 - revision number
> 
> These PHYs have same ID in register 2 and 3.

O.K, that is pretty normal. Please add a phy_device for each
individual PHY. There are macros to help you do this.

	Andrew

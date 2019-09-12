Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 61D4DB1063
	for <lists+netdev@lfdr.de>; Thu, 12 Sep 2019 15:52:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732269AbfILNwR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Sep 2019 09:52:17 -0400
Received: from pandora.armlinux.org.uk ([78.32.30.218]:47844 "EHLO
        pandora.armlinux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731683AbfILNwR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 Sep 2019 09:52:17 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=P5GNO5qeCugl9ICVScLbazWUS0djlBZooprxENuDtI0=; b=fn7zM6YU7Y8gezw7Rh/SGNIH9
        H+/W8zRfXHLmDano96MAjUcvGLZydTZYqG8u1lkhPXFCMWyrgtuOtsmqRaYxQNSHeCZqE9BH5k4QK
        zhiMBHOOYazuL63goViZtkVzqZmf+Iz7D0AA1nNLeuLA5UUnJcMKGgk9ZnN6I/uYqw9676F5a6vSQ
        GJfD9xVjlmH3ZVnrRfVt6JYdjd7Pidy0toN+WtR31by/eFWDJ+3y13V+nOppV0/xXhOST7FDXOiKv
        l/Yq0PxIfHRaQyO1owqPlRc7iUR8sP7Xw8JheMWomTAuMAhsB5Tz1RJTATdwnyMshBJcMdanDkA3X
        49PM6qpig==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:42778)
        by pandora.armlinux.org.uk with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.90_1)
        (envelope-from <linux@armlinux.org.uk>)
        id 1i8PW7-0004oy-EQ; Thu, 12 Sep 2019 14:52:11 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1i8PW4-0004vZ-E6; Thu, 12 Sep 2019 14:52:08 +0100
Date:   Thu, 12 Sep 2019 14:52:08 +0100
From:   Russell King - ARM Linux admin <linux@armlinux.org.uk>
To:     Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc:     Linus Walleij <linus.walleij@linaro.org>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "open list:GPIO SUBSYSTEM" <linux-gpio@vger.kernel.org>,
        Andrew Lunn <andrew@lunn.ch>,
        "David S. Miller" <davem@davemloft.net>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        netdev <netdev@vger.kernel.org>
Subject: Re: [PATCH 04/11] net: phylink: switch to using
 fwnode_gpiod_get_index()
Message-ID: <20190912135208.GY13294@shell.armlinux.org.uk>
References: <20190911075215.78047-1-dmitry.torokhov@gmail.com>
 <20190911075215.78047-5-dmitry.torokhov@gmail.com>
 <20190911092514.GM2680@smile.fi.intel.com>
 <20190911093914.GT13294@shell.armlinux.org.uk>
 <20190911094619.GN2680@smile.fi.intel.com>
 <20190911095149.GA108334@dtor-ws>
 <CACRpkdbTErKxFBr__tj391FHwUTxC7ZF_m94tC8-VHzaynBsnw@mail.gmail.com>
 <20190912134429.GZ2680@smile.fi.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190912134429.GZ2680@smile.fi.intel.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Sep 12, 2019 at 04:44:29PM +0300, Andy Shevchenko wrote:
> On Thu, Sep 12, 2019 at 10:41:43AM +0100, Linus Walleij wrote:
> > On Wed, Sep 11, 2019 at 10:51 AM Dmitry Torokhov
> > <dmitry.torokhov@gmail.com> wrote:
> > 
> > > If we are willing to sacrifice the custom label for the GPIO that
> > > fwnode_gpiod_get_index() allows us to set, then there are several
> > > drivers that could actually use gpiod_get() API.
> > 
> > We have:
> > gpiod_set_consumer_name(gpiod, "name");
> > to deal with that so no sacrifice is needed.
> 
> Thank for this hint!

Would it be possible to improve your email etiquette, and move this
discussion to a more appropriate subject line, so I don't have to keep
checking these emails, in case you _do_ talk about something relevent
to the original patch that the subject line refers to?

Thanks.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTC broadband for 0.8mile line in suburbia: sync at 12.1Mbps down 622kbps up
According to speedtest.net: 11.9Mbps down 500kbps up

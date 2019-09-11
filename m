Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 50649AF987
	for <lists+netdev@lfdr.de>; Wed, 11 Sep 2019 11:52:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727531AbfIKJvy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Sep 2019 05:51:54 -0400
Received: from mail-pf1-f194.google.com ([209.85.210.194]:40201 "EHLO
        mail-pf1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726341AbfIKJvy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 Sep 2019 05:51:54 -0400
Received: by mail-pf1-f194.google.com with SMTP id x127so13326694pfb.7;
        Wed, 11 Sep 2019 02:51:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=oa7u80RXbIOL5pSRB6LVDmgAyUhE8R9E1GZbUGFyfpY=;
        b=mL7NiEn+6ge0h+BxS7E7NOyBlmKTMOwNAU7+4YOxjrZ6Hvnrbythxytm5RgnsCOwqH
         96ZdXgnXnC24cqlC78FvkyznbIVJ7G2x7FL1jPki82vTYFGf2DpfBaSzBF8wOnpaiRJG
         fGBn0/SScHlqjPVezslukbzENw/x4nG/Dm8GCMsAfsDCA2ed8JOu4TNBx0UKCa72g4qU
         QNzHKZSv9TL+APROJcYu66ENexXXQTElyfwKokZoZcYstN7XWsN3YB/lxLdDvnDyC0gw
         MjTYnaDC198sVBo8fnyStu3xwNSWTU0U3griwrge5RxxVUSvYf5+4PJsVcljMxwRlPxh
         fUog==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=oa7u80RXbIOL5pSRB6LVDmgAyUhE8R9E1GZbUGFyfpY=;
        b=QBEFeOb00QM9llFGyUHBf5wThwgpCLrR3Xg4qRNj6wQHLxqUyLpnxvQ5m3cERCZh8H
         vutE2Mozz1+/ZJBhRX/z5loHRsVxPIn7wos2IS617YS+W3Yv7CcvyeecyDTej6Ub8ad/
         xcux7wMIW32JJw9H9A5Tc3zB7vyKJIVOvcbQBDT+FAXer/wZwLGb1SjmZ7YYz1IlcDCG
         RPNtlZA1iPSYGyYihBGzL4Ndo/dmw63ik8ceYwYgGMSgsX7XOTH/qHTvhxgEvQ6ID1WE
         mkXs8rJpQOr1aL9qITWvcsKYh6jUDwNMa6O6HaGWX1ckC9vgCxDgMYpSLrMW0iyP/Nut
         Ux1Q==
X-Gm-Message-State: APjAAAU9iJ+RE1f4iTTFz/S8ixbI7zOSmp5PBp5nTURFQKLSH4lrjz2m
        0k7nG1RKwZMJAHfqBEYaSbA=
X-Google-Smtp-Source: APXvYqwOcxIOH4t+fIaaEcDipG/11XnkGy5NdmbeWsVxSGU8jsO2ou3SCB17+GxNscICkb3PBxJMrQ==
X-Received: by 2002:a17:90a:3aa3:: with SMTP id b32mr4559506pjc.75.1568195512312;
        Wed, 11 Sep 2019 02:51:52 -0700 (PDT)
Received: from dtor-ws ([2620:15c:202:201:3adc:b08c:7acc:b325])
        by smtp.gmail.com with ESMTPSA id b185sm26818791pfg.14.2019.09.11.02.51.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 11 Sep 2019 02:51:51 -0700 (PDT)
Date:   Wed, 11 Sep 2019 02:51:49 -0700
From:   Dmitry Torokhov <dmitry.torokhov@gmail.com>
To:     Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc:     Russell King - ARM Linux admin <linux@armlinux.org.uk>,
        Linus Walleij <linus.walleij@linaro.org>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        linux-kernel@vger.kernel.org, linux-gpio@vger.kernel.org,
        Andrew Lunn <andrew@lunn.ch>,
        "David S. Miller" <davem@davemloft.net>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>, netdev@vger.kernel.org
Subject: Re: [PATCH 04/11] net: phylink: switch to using
 fwnode_gpiod_get_index()
Message-ID: <20190911095149.GA108334@dtor-ws>
References: <20190911075215.78047-1-dmitry.torokhov@gmail.com>
 <20190911075215.78047-5-dmitry.torokhov@gmail.com>
 <20190911092514.GM2680@smile.fi.intel.com>
 <20190911093914.GT13294@shell.armlinux.org.uk>
 <20190911094619.GN2680@smile.fi.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190911094619.GN2680@smile.fi.intel.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Sep 11, 2019 at 12:46:19PM +0300, Andy Shevchenko wrote:
> On Wed, Sep 11, 2019 at 10:39:14AM +0100, Russell King - ARM Linux admin wrote:
> > On Wed, Sep 11, 2019 at 12:25:14PM +0300, Andy Shevchenko wrote:
> > > On Wed, Sep 11, 2019 at 12:52:08AM -0700, Dmitry Torokhov wrote:
> > > > Instead of fwnode_get_named_gpiod() that I plan to hide away, let's use
> > > > the new fwnode_gpiod_get_index() that mimics gpiod_get_index(), bit
> > > > works with arbitrary firmware node.
> > > 
> > > I'm wondering if it's possible to step forward and replace
> > > fwnode_get_gpiod_index by gpiod_get() / gpiod_get_index() here and
> > > in other cases in this series.
> > 
> > No, those require a struct device, but we have none.  There are network
> > drivers where there is a struct device for the network complex, but only
> > DT nodes for the individual network interfaces.  So no, gpiod_* really
> > doesn't work.
> 
> In the following patch the node is derived from struct device. So, I believe
> some cases can be handled differently.

If we are willing to sacrifice the custom label for the GPIO that
fwnode_gpiod_get_index() allows us to set, then there are several
drivers that could actually use gpiod_get() API.

This is up to the dirver's maintainers...

Thanks.

-- 
Dmitry

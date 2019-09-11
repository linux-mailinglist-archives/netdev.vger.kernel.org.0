Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9562EAF997
	for <lists+netdev@lfdr.de>; Wed, 11 Sep 2019 11:55:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727307AbfIKJzP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Sep 2019 05:55:15 -0400
Received: from mail-pf1-f196.google.com ([209.85.210.196]:33524 "EHLO
        mail-pf1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726702AbfIKJzP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 Sep 2019 05:55:15 -0400
Received: by mail-pf1-f196.google.com with SMTP id q10so13350898pfl.0;
        Wed, 11 Sep 2019 02:55:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=EYAdW6e1HjgiO7iOA9knRWup6ouX3NvawvaBsn5XypY=;
        b=uadrbg0nOLNfbytsdr/sMmmtNrDUkeUPXVSZuu51dsCCjTuuJIQ70gXTSFF9T/2Mod
         9WuGH7pzgyBVz7CUH169M1T2ORrSB93tEzRcOnFlgAlr5aPoxrbP++8WhYuUP+Y+TFBS
         QGAqm0aqS7VP/0Zp6tN64XH/sgtS0puMtywdEnQWylQa12lnCjhM/28pV43vv5qsiuAo
         +0x5Q6A57plY+1ZEWAPJusNjnYGnNvM0UGCxpWY9Eiuq70zzjEt6IcD0TFze6vB96iUt
         mHapZ2Z1zdbob9Oq0EZiiSFhN6JkgJpNt5po04BFPnTWW8d8mCRHdS6tIDwKvoLkRCgK
         CpvQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=EYAdW6e1HjgiO7iOA9knRWup6ouX3NvawvaBsn5XypY=;
        b=sptcehjBkkuOEff8cqXpLIQKmYnpTaUUG+JYv3EiiaowBoR9ZdlBjbmlXd0RKNGklr
         meH+GY1ZyKj/oWYsC3dtm3p9XgBakvtHGtXaC6rBzRCfKtwxFZMab4qib6yOQQFsWLVX
         ERWxKNf+dienNlNvyPniHyU13bT+ESyB6+9BDx2CdlWnzpX5BffQEOY+5/gyzRXIF7xa
         xW/FMxaCM8kuKXxrsXPEedZQfaYo761LH3r5+N3C1NnWImtWotJMT4irjAnha95lUvfD
         wxVS3hapkVUFFXzNu+i9cKKbdKpfgtr7ecE1wCeCCvZOTRjIM6yCIPQ/D7dWBFl0O8Ap
         qOYw==
X-Gm-Message-State: APjAAAWbu3VMHtMJBuA9pCUYB8QNvqmrAmGRmoG8Jyd4uq18fyUVTenM
        Jznugw9smIQZIJ/d8jv72esQcoQZlkE=
X-Google-Smtp-Source: APXvYqz8/DQvRH8+c009V9c0kMz3Cs9wV2T2oQJUOaot7e5CWOEkxzbY8jQ1Kv48S4dhqFwZvUdIFw==
X-Received: by 2002:a17:90a:a014:: with SMTP id q20mr4591336pjp.113.1568195714294;
        Wed, 11 Sep 2019 02:55:14 -0700 (PDT)
Received: from dtor-ws ([2620:15c:202:201:3adc:b08c:7acc:b325])
        by smtp.gmail.com with ESMTPSA id j2sm21388338pfe.130.2019.09.11.02.55.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 11 Sep 2019 02:55:13 -0700 (PDT)
Date:   Wed, 11 Sep 2019 02:55:11 -0700
From:   Dmitry Torokhov <dmitry.torokhov@gmail.com>
To:     Russell King - ARM Linux admin <linux@armlinux.org.uk>
Cc:     Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        linux-kernel@vger.kernel.org, linux-gpio@vger.kernel.org,
        Andrew Lunn <andrew@lunn.ch>,
        "David S. Miller" <davem@davemloft.net>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>, netdev@vger.kernel.org
Subject: Re: [PATCH 04/11] net: phylink: switch to using
 fwnode_gpiod_get_index()
Message-ID: <20190911095511.GB108334@dtor-ws>
References: <20190911075215.78047-1-dmitry.torokhov@gmail.com>
 <20190911075215.78047-5-dmitry.torokhov@gmail.com>
 <20190911092514.GM2680@smile.fi.intel.com>
 <20190911093914.GT13294@shell.armlinux.org.uk>
 <20190911094619.GN2680@smile.fi.intel.com>
 <20190911094929.GV13294@shell.armlinux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190911094929.GV13294@shell.armlinux.org.uk>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Sep 11, 2019 at 10:49:29AM +0100, Russell King - ARM Linux admin wrote:
> On Wed, Sep 11, 2019 at 12:46:19PM +0300, Andy Shevchenko wrote:
> > On Wed, Sep 11, 2019 at 10:39:14AM +0100, Russell King - ARM Linux admin wrote:
> > > On Wed, Sep 11, 2019 at 12:25:14PM +0300, Andy Shevchenko wrote:
> > > > On Wed, Sep 11, 2019 at 12:52:08AM -0700, Dmitry Torokhov wrote:
> > > > > Instead of fwnode_get_named_gpiod() that I plan to hide away, let's use
> > > > > the new fwnode_gpiod_get_index() that mimics gpiod_get_index(), bit
> > > > > works with arbitrary firmware node.
> e > > 
> > > > I'm wondering if it's possible to step forward and replace
> > > > fwnode_get_gpiod_index by gpiod_get() / gpiod_get_index() here and
> > > > in other cases in this series.
> > > 
> > > No, those require a struct device, but we have none.  There are network
> > > drivers where there is a struct device for the network complex, but only
> > > DT nodes for the individual network interfaces.  So no, gpiod_* really
> > > doesn't work.
> > 
> > In the following patch the node is derived from struct device. So, I believe
> > some cases can be handled differently.
> 
> phylink is not passed a struct device - it has no knowledge what the
> parent device is.
> 
> In any case, I do not have "the following patch".

Andy is talking about this one:

diff --git a/drivers/net/phy/mdio_bus.c b/drivers/net/phy/mdio_bus.c
index ce940871331e..9ca51d678123 100644
--- a/drivers/net/phy/mdio_bus.c
+++ b/drivers/net/phy/mdio_bus.c
@@ -46,8 +46,8 @@ static int mdiobus_register_gpiod(struct mdio_device *mdiodev)

        /* Deassert the optional reset signal */
        if (mdiodev->dev.of_node)
-               gpiod = fwnode_get_named_gpiod(&mdiodev->dev.of_node->fwnode,
-                                              "reset-gpios", 0,
                                               GPIOD_OUT_LOW,
+               gpiod = fwnode_gpiod_get_index(&mdiodev->dev.of_node->fwnode,
+                                              "reset", 0, GPIOD_OUT_LOW,
                                               "PHY reset");
Here if we do not care about "PHY reset" label, we could use
gpiod_get(&mdiodev->dev, "reset", GPIOD_OUT_LOW).

Thanks.

-- 
Dmitry

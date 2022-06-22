Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7B0405547D8
	for <lists+netdev@lfdr.de>; Wed, 22 Jun 2022 14:12:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357614AbiFVLVP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Jun 2022 07:21:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58216 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357599AbiFVLUy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Jun 2022 07:20:54 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7835B3D1D2
        for <netdev@vger.kernel.org>; Wed, 22 Jun 2022 04:19:16 -0700 (PDT)
Received: from ptx.hi.pengutronix.de ([2001:67c:670:100:1d::c0])
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <sha@pengutronix.de>)
        id 1o3yNj-0002pw-5i; Wed, 22 Jun 2022 13:18:47 +0200
Received: from sha by ptx.hi.pengutronix.de with local (Exim 4.92)
        (envelope-from <sha@pengutronix.de>)
        id 1o3yNV-0004vY-2O; Wed, 22 Jun 2022 13:18:33 +0200
Date:   Wed, 22 Jun 2022 13:18:33 +0200
From:   Sascha Hauer <sha@pengutronix.de>
To:     Andy Shevchenko <andy.shevchenko@gmail.com>
Cc:     Linus Walleij <linus.walleij@linaro.org>,
        Andrew Lunn <andrew@lunn.ch>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        "Rafael J. Wysocki" <rafael@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Pavel Machek <pavel@ucw.cz>, Will Deacon <will@kernel.org>,
        Saravana Kannan <saravanak@google.com>,
        Kevin Hilman <khilman@kernel.org>,
        Joerg Roedel <joro@8bytes.org>,
        Russell King <linux@armlinux.org.uk>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Android Kernel Team <kernel-team@android.com>,
        Len Brown <len.brown@intel.com>,
        Linux PM <linux-pm@vger.kernel.org>,
        "open list:GPIO SUBSYSTEM" <linux-gpio@vger.kernel.org>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        David Ahern <dsahern@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "list@263.net:IOMMU DRIVERS" <iommu@lists.linux-foundation.org>,
        Sascha Hauer <kernel@pengutronix.de>,
        netdev <netdev@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Heiner Kallweit <hkallweit1@gmail.com>
Subject: Re: [PATCH v2 7/9] driver core: Set fw_devlink.strict=1 by default
Message-ID: <20220622111833.GW1615@pengutronix.de>
References: <CAHp75VdqjCoWAHV4AyYrju0o8buREA8pM5wyf8TD=rCMTs-tEA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHp75VdqjCoWAHV4AyYrju0o8buREA8pM5wyf8TD=rCMTs-tEA@mail.gmail.com>
X-Sent-From: Pengutronix Hildesheim
X-URL:  http://www.pengutronix.de/
X-Accept-Language: de,en
X-Accept-Content-Type: text/plain
User-Agent: Mutt/1.10.1 (2018-07-13)
X-SA-Exim-Connect-IP: 2001:67c:670:100:1d::c0
X-SA-Exim-Mail-From: sha@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jun 22, 2022 at 12:52:02PM +0200, Andy Shevchenko wrote:
> On Wed, Jun 22, 2022 at 10:44 AM Linus Walleij <linus.walleij@linaro.org> wrote:
> > On Wed, Jun 22, 2022 at 9:48 AM Sascha Hauer <sha@pengutronix.de> wrote:
> 
> ...
> 
> > > This patch has the effect that console UART devices which have "dmas"
> > > properties specified in the device tree get deferred for 10 to 20
> > > seconds. This happens on i.MX and likely on other SoCs as well. On i.MX
> > > the dma channel is only requested at UART startup time and not at probe
> > > time. dma is not used for the console. Nevertheless with this driver probe
> > > defers until the dma engine driver is available.
> > >
> > > It shouldn't go in as-is.
> >
> > This affects all machines with the PL011 UART and DMAs specified as
> > well.
> >
> > It would be best if the console subsystem could be treated special and
> > not require DMA devlink to be satisfied before probing.
> 
> In 8250 we force disable DMA and PM on kernel consoles, because it's
> so-o PITA and has a lot of corner cases we may never chase down.

On i.MX this is done as well, but it doesn't help here. The driver is
not even probed when the device node contains a "dmas" property.

Sascha

-- 
Pengutronix e.K.                           |                             |
Steuerwalder Str. 21                       | http://www.pengutronix.de/  |
31137 Hildesheim, Germany                  | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |

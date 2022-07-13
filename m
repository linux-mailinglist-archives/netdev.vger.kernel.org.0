Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 41DA7573014
	for <lists+netdev@lfdr.de>; Wed, 13 Jul 2022 10:07:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234652AbiGMIG5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Jul 2022 04:06:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36624 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234828AbiGMIGx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 Jul 2022 04:06:53 -0400
Received: from muru.com (muru.com [72.249.23.125])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id E92FDE9213;
        Wed, 13 Jul 2022 01:06:51 -0700 (PDT)
Received: from localhost (localhost [127.0.0.1])
        by muru.com (Postfix) with ESMTPS id 268A680AE;
        Wed, 13 Jul 2022 08:01:08 +0000 (UTC)
Date:   Wed, 13 Jul 2022 11:06:49 +0300
From:   Tony Lindgren <tony@atomide.com>
To:     Saravana Kannan <saravanak@google.com>
Cc:     Rob Herring <robh@kernel.org>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Rafael J. Wysocki" <rafael@kernel.org>,
        Kevin Hilman <khilman@kernel.org>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Len Brown <len.brown@intel.com>, Pavel Machek <pavel@ucw.cz>,
        Joerg Roedel <joro@8bytes.org>, Will Deacon <will@kernel.org>,
        Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>,
        Android Kernel Team <kernel-team@android.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "open list:THERMAL" <linux-pm@vger.kernel.org>,
        Linux IOMMU <iommu@lists.linux-foundation.org>,
        netdev <netdev@vger.kernel.org>,
        "open list:GPIO SUBSYSTEM" <linux-gpio@vger.kernel.org>,
        Alexander Stein <alexander.stein@ew.tq-group.com>
Subject: Re: [PATCH v2 1/9] PM: domains: Delete usage of
 driver_deferred_probe_check_state()
Message-ID: <Ys59Gctsllu6GraU@atomide.com>
References: <CAGETcx8c+P0r6ARmhv+ERaz9zAGBOVJQu3bSDXELBycEGfkYQw@mail.gmail.com>
 <CAL_JsqJd3J6k6pRar7CkHVaaPbY7jqvzAePd8rVDisRV-dLLtg@mail.gmail.com>
 <CAGETcx9ZmeTyP1sJCFZ9pBbMyXeifQFohFvWN3aBPx0sSOJ2VA@mail.gmail.com>
 <Yr6HQOtS4ctUYm9m@atomide.com>
 <Yr6QUzdoFWv/eAI6@atomide.com>
 <CAGETcx-0bStPx8sF3BtcJFiu74NwiB0btTQ+xx_B=8B37TEb8w@mail.gmail.com>
 <CAGETcx-Yp2JKgCNfaGD0SzZg9F2Xnu8A3zXmV5=WX1hY7uR=0g@mail.gmail.com>
 <Yr7wA8d4J7xtjwsH@atomide.com>
 <Ys0ewNYFB25RWNju@atomide.com>
 <CAGETcx8H9je6Yg-fciU5-dh22xB0_h6XzAfH5UsCSeET97wrpA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAGETcx8H9je6Yg-fciU5-dh22xB0_h6XzAfH5UsCSeET97wrpA@mail.gmail.com>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

* Saravana Kannan <saravanak@google.com> [220713 00:44]:
> On Tue, Jul 12, 2022 at 12:12 AM Tony Lindgren <tony@atomide.com> wrote:
> >
> > * Tony Lindgren <tony@atomide.com> [220701 16:00]:
> > > Also, looks like both with the initcall change for prm, and the patch
> > > below, there seems to be also another problem where my test devices no
> > > longer properly idle somehow compared to reverting the your two patches
> > > in next.
> >
> > Sorry looks like was a wrong conclusion. While trying to track down this
> > issue, I cannot reproduce it. So I don't see issues idling with either
> > the initcall change or your test patch.
> >
> > Not sure what caused my earlier tests to fail though. Maybe a config
> > change to enable more debugging, or possibly some kind of warm reset vs
> > cold reset type issue.
> 
> Thanks for getting back to me about the false alarm.

FYI I'm pretty sure I had also some pending sdhci related patches applied
while testing causing extra issues.

> OK, so it looks like my patch to drivers/of/property.c fixed the issue
> for you. In that case, let me test that a bit more thoroughly on my
> end to make sure it's not breaking any existing functionality. And if
> it's not breaking, I'll land that in the kernel eventually. Might be a
> bit too late for 5.19. I'm considering temporarily reverting my series
> depending on how the rest of the issues from my series go.

OK. Seems the series is otherwise working and in case of issues, partial
revert should be enough in the worst case. But yeah, probably some more
testing is needed.

Regards,

Tony

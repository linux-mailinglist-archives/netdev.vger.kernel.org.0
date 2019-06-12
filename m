Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C132C42A4E
	for <lists+netdev@lfdr.de>; Wed, 12 Jun 2019 17:07:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2439977AbfFLPHA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Jun 2019 11:07:00 -0400
Received: from smtp1.de.adit-jv.com ([93.241.18.167]:38907 "EHLO
        smtp1.de.adit-jv.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2437171AbfFLPHA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 12 Jun 2019 11:07:00 -0400
Received: from localhost (smtp1.de.adit-jv.com [127.0.0.1])
        by smtp1.de.adit-jv.com (Postfix) with ESMTP id 13CE63C00C6;
        Wed, 12 Jun 2019 17:06:56 +0200 (CEST)
Received: from smtp1.de.adit-jv.com ([127.0.0.1])
        by localhost (smtp1.de.adit-jv.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id oIFPVGe6i6WH; Wed, 12 Jun 2019 17:06:49 +0200 (CEST)
Received: from HI2EXCH01.adit-jv.com (hi2exch01.adit-jv.com [10.72.92.24])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by smtp1.de.adit-jv.com (Postfix) with ESMTPS id 60ACF3C00DD;
        Wed, 12 Jun 2019 17:06:47 +0200 (CEST)
Received: from vmlxhi-102.adit-jv.com (10.72.93.184) by HI2EXCH01.adit-jv.com
 (10.72.92.24) with Microsoft SMTP Server (TLS) id 14.3.439.0; Wed, 12 Jun
 2019 17:06:47 +0200
Date:   Wed, 12 Jun 2019 17:06:44 +0200
From:   Eugeniu Rosca <erosca@de.adit-jv.com>
To:     Marc Zyngier <marc.zyngier@arm.com>
CC:     Geert Uytterhoeven <geert@linux-m68k.org>,
        Tony Lindgren <tony@atomide.com>,
        Kalle Valo <kvalo@codeaurora.org>, Eyal Reizer <eyalr@ti.com>,
        Simon Horman <horms+renesas@verge.net.au>,
        "David S. Miller" <davem@davemloft.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Randy Dunlap <rdunlap@infradead.org>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        John Stultz <john.stultz@linaro.org>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Spyridon Papageorgiou <spapageorgiou@de.adit-jv.com>,
        Joshua Frkuska <joshua_frkuska@mentor.com>,
        "George G . Davis" <george_davis@mentor.com>,
        Andrey Gusakov <andrey.gusakov@cogentembedded.com>,
        Linux-Renesas <linux-renesas-soc@vger.kernel.org>,
        Eugeniu Rosca <roscaeugeniu@gmail.com>,
        Eugeniu Rosca <erosca@de.adit-jv.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Jason Cooper <jason@lakedaemon.net>,
        Linus Walleij <linus.walleij@linaro.org>,
        Harish Jenny K N <harish_kandiga@mentor.com>
Subject: Re: [PATCH] wlcore/wl18xx: Add invert-irq OF property for physically
 inverted IRQ
Message-ID: <20190612150644.GA22002@vmlxhi-102.adit-jv.com>
References: <20190607172958.20745-1-erosca@de.adit-jv.com>
 <87tvcxncuq.fsf@codeaurora.org>
 <20190610083012.GV5447@atomide.com>
 <CAMuHMdUOc17ocqmt=oNmyN1UT_K7_y=af1pwjwr5PTgQL2o2OQ@mail.gmail.com>
 <08bc4755-5f47-d792-8b5a-927b5fbe7619@arm.com>
 <20190612094538.GA16575@vmlxhi-102.adit-jv.com>
 <86d0jjglax.wl-marc.zyngier@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <86d0jjglax.wl-marc.zyngier@arm.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
X-Originating-IP: [10.72.93.184]
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Marc,

Thanks for your comment.

On Wed, Jun 12, 2019 at 11:17:10AM +0100, Marc Zyngier wrote:
> Eugeniu Rosca <erosca@de.adit-jv.com> wrote:
> > On Tue, Jun 11, 2019 at 10:00:41AM +0100, Marc Zyngier wrote:
[..]
> > > We already have plenty of that in the tree, the canonical example
> > > probably being drivers/irqchip/irq-mtk-sysirq.c. It should be pretty
> > > easy to turn this driver into something more generic.
> > 
> > I don't think drivers/irqchip/irq-mtk-sysirq.c can serve the
> > use-case/purpose of this patch. The MTK driver seems to be dealing with
> > the polarity inversion of on-SoC interrupts which are routed to GiC,
> > whereas in this patch we are talking about an off-chip interrupt
> > wired to R-Car GPIO controller.
> 
> And how different is that? The location of the interrupt source is
> pretty irrelevant here.

The main difference which I sense is that a driver like irq-mtk-sysirq
mostly (if not exclusively) deals with internal kernel implementation
detail (tuned via DT) whilst adding an inverter for GPIO IRQs raises
a whole bunch of new questions (e.g. how to arbitrate between
kernel-space and user-space IRQ polarity configuration?).

> The point is that there is already a general
> scheme to deal with these "signal altering widgets", and that we
> should try to reuse at least the concept, if not the code.

Since Harish Jenny K N might be working on a new driver doing GPIO IRQ
inversion, I have CC-ed him as well to avoid any overlapping work.

> 
> > It looks to me that the nice DTS sketch shared by Linus Walleij in [5]
> > might come closer to the concept proposed by Geert? FWIW, the
> > infrastructure/implementation to make this possible is still not
> > ready.
> 
> Which looks like what I'm suggesting.

Then we are on the same page. Thanks.

> 
> 	M.
> 
> -- 
> Jazz is not dead, it just smells funny.

-- 
Best Regards,
Eugeniu.

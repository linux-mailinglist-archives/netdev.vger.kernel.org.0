Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8603563F5CE
	for <lists+netdev@lfdr.de>; Thu,  1 Dec 2022 17:59:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229949AbiLAQ76 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Dec 2022 11:59:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50174 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229681AbiLAQ74 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 1 Dec 2022 11:59:56 -0500
Received: from mail-ej1-x634.google.com (mail-ej1-x634.google.com [IPv6:2a00:1450:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A229AA5551
        for <netdev@vger.kernel.org>; Thu,  1 Dec 2022 08:59:54 -0800 (PST)
Received: by mail-ej1-x634.google.com with SMTP id b2so5650475eja.7
        for <netdev@vger.kernel.org>; Thu, 01 Dec 2022 08:59:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=baylibre-com.20210112.gappssmtp.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=MxGqyJNrUGujXMX18s1mjL2u0fDn76vkmShKgy0/GIg=;
        b=ghr+FqNiUeaxQ4O+hMb0CJ0v2KjgGXRQdIdZ9HUrcmEmVzMRFeNhxJgjR8fv8C6DY3
         S8jsWUxHH/1OOrICy7P7eElJ4AaEhhxQXjEcjRoRy45Mt1OX+1sj/Uh8wQp7Dg7F9CcF
         j9bMEGrsEEnBzPqz59AYJUw+Uad1SiZ3Mbot3iyudLo9EHr1Be1w3cbope15tyviU+AU
         su9Te/qPn/N8XSmNGL/LSy0ar9cqpuKYiw3fcAlj1Pr8j8GiuXoYNRH5mS4CYtxiwtYF
         AGbIHMP3Na7kl92PlvFHnhvehgboRsd1vbFuJXZhNcbZY+RKO8QqfHP85MPp+3pvLYwf
         PJJw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=MxGqyJNrUGujXMX18s1mjL2u0fDn76vkmShKgy0/GIg=;
        b=6NpuChnx0kdz9NswH8gjwXR2lFjPlbyjNvPklXRIR0QAhl8/K2vWAJJ+limNPxXOFq
         TdoqE6F/KkHOGYNsBINV3guGOe4iIyE9tPvsLqgTG9nsx7jF638v0J92j08uIV+Mu3kl
         5Z3fR1y7LsaB3HXixT9qJCydDO/ipvJWgmRs5qvRuVMt27LrH6QEXAOsxOqFAvok1TXR
         J4BFRdA6cXRpd5ImwnVi7GpTUAQ1V0pFfY6VIG/fhNGulTpMd6sju0xe3lTquorhQjac
         6ypPyF3VymWEcr27Azi1W5RgVfD+NWcLu7Xp5950NeqQQo5Q9/8xa8rKGGmxBGmQ+ta5
         VG9g==
X-Gm-Message-State: ANoB5plXVOXyVLVwgf1OURXoDkuTlc80sVxBuI0Cd6iR7BwNG2QNenC8
        pkijPq5n/NCqqPxe6ZKwWfx/cxUfQl3PlA==
X-Google-Smtp-Source: AA0mqf4sv2kZ4cYbl4xbOf8gb/qBFcNRIjTbJ1RX+Ei7CBmvtdncQ0lBGkaIDZJVRJMUY7sDX1V4Cw==
X-Received: by 2002:a17:906:d8a6:b0:7c0:b741:8b61 with SMTP id qc6-20020a170906d8a600b007c0b7418b61mr1861040ejb.625.1669913992984;
        Thu, 01 Dec 2022 08:59:52 -0800 (PST)
Received: from blmsp ([2001:4091:a245:805c:9cf4:fdb8:bb61:5f4e])
        by smtp.gmail.com with ESMTPSA id tz4-20020a170907c78400b007c0b530f3cfsm652511ejc.72.2022.12.01.08.59.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 01 Dec 2022 08:59:52 -0800 (PST)
Date:   Thu, 1 Dec 2022 17:59:51 +0100
From:   Markus Schneider-Pargmann <msp@baylibre.com>
To:     Marc Kleine-Budde <mkl@pengutronix.de>
Cc:     Chandrasekar Ramakrishnan <rcsekar@samsung.com>,
        Wolfgang Grandegger <wg@grandegger.com>,
        linux-can@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 04/15] can: m_can: Use transmit event FIFO watermark
 level interrupt
Message-ID: <20221201165951.5a4srb7zjrsdr3vd@blmsp>
References: <20221116205308.2996556-1-msp@baylibre.com>
 <20221116205308.2996556-5-msp@baylibre.com>
 <20221130171715.nujptzwnut7silbm@pengutronix.de>
 <20221201082521.3tqevaygz4nhw52u@blmsp>
 <20221201090508.jh5iymwmhs3orb2v@pengutronix.de>
 <20221201101220.r63fvussavailwh5@blmsp>
 <20221201110033.r7hnvpw6fp2fquni@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20221201110033.r7hnvpw6fp2fquni@pengutronix.de>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Dec 01, 2022 at 12:00:33PM +0100, Marc Kleine-Budde wrote:
> On 01.12.2022 11:12:20, Markus Schneider-Pargmann wrote:
> > > > For the upcoming receive side patch I already added a hrtimer. I may try
> > > > to use the same timer for both directions as it is going to do the exact
> > > > same thing in both cases (call the interrupt routine). Of course that
> > > > depends on the details of the coalescing support. Any objections on
> > > > that?
> > > 
> > > For the mcp251xfd I implemented the RX and TX coalescing independent of
> > > each other and made it configurable via ethtool's IRQ coalescing
> > > options.
> > > 
> > > The hardware doesn't support any timeouts and only FIFO not empty, FIFO
> > > half full and FIFO full IRQs and the on chip RAM for mailboxes is rather
> > > limited. I think the mcan core has the same limitations.
> > 
> > Yes and no, the mcan core provides watermark levels so it has more
> > options, but there is no hardware timer as well (at least I didn't see
> > anything usable).
> 
> Are there any limitations to the water mark level?

Anything specific? I can't really see any limitation. You can set the
watermark between 1 and 32. I guess we could also always use it instead
of the new-element interrupt, but I haven't tried that yet. That may
simplify the code.

> 
> > > The configuration for the mcp251xfd looks like this:
> > > 
> > > - First decide for classical CAN or CAN-FD mode
> > > - configure RX and TX ring size
> > >   9263c2e92be9 ("can: mcp251xfd: ring: add support for runtime configurable RX/TX ring parameters")
> > >   For TX only a single FIFO is used.
> > >   For RX up to 3 FIFOs (up to a depth of 32 each).
> > >   FIFO depth is limited to power of 2.
> > >   On the mcan cores this is currently done with a DT property.
> > >   Runtime configurable ring size is optional but gives more flexibility
> > >   for our use-cases due to limited RAM size.
> > > - configure RX and TX coalescing via ethtools
> > >   Set a timeout and the max CAN frames to coalesce.
> > >   The max frames are limited to half or full FIFO.
> > 
> > mcan can offer more options for the max frames limit fortunately.
> > 
> > > 
> > > How does coalescing work?
> > > 
> > > If coalescing is activated during reading of the RX'ed frames the FIFO
> > > not empty IRQ is disabled (the half or full IRQ stays enabled). After
> > > handling the RX'ed frames a hrtimer is started. In the hrtimer's
> > > functions the FIFO not empty IRQ is enabled again.
> > 
> > My rx path patches are working similarly though not 100% the same. I
> > will adopt everything and add it to the next version of this series.
> > 
> > > 
> > > I decided not to call the IRQ handler from the hrtimer to avoid
> > > concurrency, but enable the FIFO not empty IRQ.
> > 
> > mcan uses a threaded irq and I found this nice helper function I am
> > currently using for the receive path.
> > 	irq_wake_thread()
> > 
> > It is not widely used so I hope this is fine. But this hopefully avoids
> > the concurrency issue. Also I don't need to artificially create an IRQ
> > as you do.
> 
> I think it's Ok to use the function. Which IRQs are enabled after you
> leave the RX handler? The mcp251xfd driver enables only a high watermark
> IRQ and sets up the hrtimer. Then we have 3 scenarios:
> - high watermark IRQ triggers -> IRQ is handled,
> - FIFO level between 0 and high water mark -> no IRQ triggered, but
>   hrtimer will run, irq_wake_thread() is called, IRQ is handled
> - FIFO level 0 -> no IRQ triggered, hrtimer will run. What do you do in
>   the IRQ handler? Check if FIFO is empty and enable the FIFO not empty
>   IRQ?

I am currently doing the normal IRQ handler run. It checks the
"Interrupt Register" at the beginning. This register does not show the
interrupts that fired, it shows the status. So even though the watermark
interrupt didn't trigger when called by a timer, RF0N 'new message'
status bit is still set if there is something new in the FIFO. Of course
it is the same for the transmit status bits.
So there is no need to read the FIFO fill levels directly, just the
general status register.

Best,
Markus

Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8D094640395
	for <lists+netdev@lfdr.de>; Fri,  2 Dec 2022 10:43:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232645AbiLBJn4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Dec 2022 04:43:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46822 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232623AbiLBJnw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 2 Dec 2022 04:43:52 -0500
Received: from mail-wr1-x42f.google.com (mail-wr1-x42f.google.com [IPv6:2a00:1450:4864:20::42f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B71E3C23DB
        for <netdev@vger.kernel.org>; Fri,  2 Dec 2022 01:43:50 -0800 (PST)
Received: by mail-wr1-x42f.google.com with SMTP id bs21so6961236wrb.4
        for <netdev@vger.kernel.org>; Fri, 02 Dec 2022 01:43:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=baylibre-com.20210112.gappssmtp.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=c7jlww+YwvtAfoXwz8qUgfga6wLFv4byhYCz3Q0szb8=;
        b=UUc5j3AY/8JQw+2iT1LRk0y67Zdou18oQp+qMNiQ5HQ2ZM7wjqAqK+J0bA0SVzPl1m
         uhLopuQ7wySKWej1bxdYuxwkfM/zbXDRzaYKHXEfUbjQo4aPkNsWSJJL1EIY+RRNF2yb
         qRF64ISg2W7145G7j8/5wfzG2Ktx8O9JBzgSGYZfF0+Z5whK4hQMe/07xss/gbfFjGXj
         6CoT9Y0iev91zqQYyOveRkI95p7oP2h50Jn2/F70Pj/TJ7LbnUWyaDUD3WhDVYz9E06G
         itm/c6NrQoXxBfm37yjjjZPXUdv/sQQoZ9fX1ip9k84iN1UzkLc+3FyYCFqi2UbVAdIg
         e55w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=c7jlww+YwvtAfoXwz8qUgfga6wLFv4byhYCz3Q0szb8=;
        b=xznLHVYBw5ZgvRuY2OEmKH49E6fYVgEXi+uZiDxj4CuhXPd4wrHx8NrSRZLzO9hRFx
         Wz6OxDyKsYvHAC+KBoPOUBvpsZPJoF6Ecem3Wfg3R6JmEL8YIod1/S8DTT8QHCUJuM8g
         tmtTlAt+PfqnBAmHLNHCl83hvEWCpYneRSDzfmzRDz+vt7zsBhl4Nu/vYCQgtVABcHAl
         2UpF7wH97f3GjcA+K8eeOwdFNHNLQMavMnTMjbQxDZhb+5oqlLZCACIP5N0Tvg5/JkTO
         oyfdv7ZK7PvQt/i0YfDsAcwqK1mcq/byYD4IcFfCJBHa1g89/sh6fJ+Wc8wE/VQONiXR
         1vPw==
X-Gm-Message-State: ANoB5pkVWWvYnUA+e5l8utXIlw7QAGw/8VgXwAUP0YEsaEUrxrR3oftw
        lHnDoxX+NxNNk10svSts8+BkiQ==
X-Google-Smtp-Source: AA0mqf5PU3+l+PWDbIeocGDkvLX8GPrawrhlnnw5BkWigrAwIkUb2MEgKnEa5yha97IhUbU+4a9aAQ==
X-Received: by 2002:a5d:5952:0:b0:241:a79b:3c41 with SMTP id e18-20020a5d5952000000b00241a79b3c41mr42208065wri.22.1669974229202;
        Fri, 02 Dec 2022 01:43:49 -0800 (PST)
Received: from blmsp ([185.238.219.119])
        by smtp.gmail.com with ESMTPSA id j3-20020adfd203000000b002366c3eefccsm6661799wrh.109.2022.12.02.01.43.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 02 Dec 2022 01:43:48 -0800 (PST)
Date:   Fri, 2 Dec 2022 10:43:46 +0100
From:   Markus Schneider-Pargmann <msp@baylibre.com>
To:     Marc Kleine-Budde <mkl@pengutronix.de>
Cc:     Chandrasekar Ramakrishnan <rcsekar@samsung.com>,
        Wolfgang Grandegger <wg@grandegger.com>,
        linux-can@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 04/15] can: m_can: Use transmit event FIFO watermark
 level interrupt
Message-ID: <20221202094346.u2nasxlcwh7llwe5@blmsp>
References: <20221116205308.2996556-1-msp@baylibre.com>
 <20221116205308.2996556-5-msp@baylibre.com>
 <20221130171715.nujptzwnut7silbm@pengutronix.de>
 <20221201082521.3tqevaygz4nhw52u@blmsp>
 <20221201090508.jh5iymwmhs3orb2v@pengutronix.de>
 <20221201101220.r63fvussavailwh5@blmsp>
 <20221201110033.r7hnvpw6fp2fquni@pengutronix.de>
 <20221201165951.5a4srb7zjrsdr3vd@blmsp>
 <20221202092306.7p3r4yuauwjj5xaj@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20221202092306.7p3r4yuauwjj5xaj@pengutronix.de>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Dec 02, 2022 at 10:23:06AM +0100, Marc Kleine-Budde wrote:
...
> > > > > The configuration for the mcp251xfd looks like this:
> > > > > 
> > > > > - First decide for classical CAN or CAN-FD mode
> > > > > - configure RX and TX ring size
> > > > >   9263c2e92be9 ("can: mcp251xfd: ring: add support for runtime configurable RX/TX ring parameters")
> > > > >   For TX only a single FIFO is used.
> > > > >   For RX up to 3 FIFOs (up to a depth of 32 each).
> > > > >   FIFO depth is limited to power of 2.
> > > > >   On the mcan cores this is currently done with a DT property.
> > > > >   Runtime configurable ring size is optional but gives more flexibility
> > > > >   for our use-cases due to limited RAM size.
> > > > > - configure RX and TX coalescing via ethtools
> > > > >   Set a timeout and the max CAN frames to coalesce.
> > > > >   The max frames are limited to half or full FIFO.
> > > > 
> > > > mcan can offer more options for the max frames limit fortunately.
> > > > 
> > > > > 
> > > > > How does coalescing work?
> > > > > 
> > > > > If coalescing is activated during reading of the RX'ed frames the FIFO
> > > > > not empty IRQ is disabled (the half or full IRQ stays enabled). After
> > > > > handling the RX'ed frames a hrtimer is started. In the hrtimer's
> > > > > functions the FIFO not empty IRQ is enabled again.
> > > > 
> > > > My rx path patches are working similarly though not 100% the same. I
> > > > will adopt everything and add it to the next version of this series.
> > > > 
> > > > > 
> > > > > I decided not to call the IRQ handler from the hrtimer to avoid
> > > > > concurrency, but enable the FIFO not empty IRQ.
> > > > 
> > > > mcan uses a threaded irq and I found this nice helper function I am
> > > > currently using for the receive path.
> > > > 	irq_wake_thread()
> > > > 
> > > > It is not widely used so I hope this is fine. But this hopefully avoids
> > > > the concurrency issue. Also I don't need to artificially create an IRQ
> > > > as you do.
> > > 
> > > I think it's Ok to use the function. Which IRQs are enabled after you
> > > leave the RX handler? The mcp251xfd driver enables only a high watermark
> > > IRQ and sets up the hrtimer. Then we have 3 scenarios:
> > > - high watermark IRQ triggers -> IRQ is handled,
> > > - FIFO level between 0 and high water mark -> no IRQ triggered, but
> > >   hrtimer will run, irq_wake_thread() is called, IRQ is handled
> > > - FIFO level 0 -> no IRQ triggered, hrtimer will run. What do you do in
> > >   the IRQ handler? Check if FIFO is empty and enable the FIFO not empty
> > >   IRQ?
> > 
> > I am currently doing the normal IRQ handler run. It checks the
> > "Interrupt Register" at the beginning. This register does not show the
> > interrupts that fired, it shows the status. So even though the watermark
> > interrupt didn't trigger when called by a timer, RF0N 'new message'
> > status bit is still set if there is something new in the FIFO.
> 
> That covers scenario 2 from above.
> 
> > Of course it is the same for the transmit status bits.
> 
> ACK - The TX complete event handling is a 95% copy/paste of the RX
> handling.
> 
> > So there is no need to read the FIFO fill levels directly, just the
> > general status register.
> 
> What do you do if the hrtimer fires and there's no CAN frame waiting in
> the FIFO?

Just enabling the 'new item' interrupt again and keep the hrtimer
disabled.

Best,
Markus

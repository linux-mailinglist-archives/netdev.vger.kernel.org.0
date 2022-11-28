Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3538E63AE4E
	for <lists+netdev@lfdr.de>; Mon, 28 Nov 2022 18:02:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232501AbiK1RCW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Nov 2022 12:02:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47780 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232453AbiK1RCT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Nov 2022 12:02:19 -0500
Received: from mail-ej1-x630.google.com (mail-ej1-x630.google.com [IPv6:2a00:1450:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CFF171AF0E;
        Mon, 28 Nov 2022 09:02:17 -0800 (PST)
Received: by mail-ej1-x630.google.com with SMTP id gu23so9248229ejb.10;
        Mon, 28 Nov 2022 09:02:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=r4Xp39aXpV011e+5h8njmyuT7Fm/E+rF8jmDGDSv4mY=;
        b=Ue3SalrZTWzI4PDqEQSyfs/kc2ciUEK64DOqJIoz83oVzBWoYuOORWlIQ5JfMlNxme
         O2Qieq2LV/Bl7+mfLg3Hia/iV2/VjZ99iAC2AH66j5vtjvbBYwzZq0u+zdzClw89Hmu7
         LEmWLgUDiQgKKX1Nqo7l5Wws5S/6ZKzyIswM47nGr0T4SqHgpsL1F6KYZOKJMyRwSdJt
         hkoRD4gxF8rE8u79+KB/OQOOm7wUnB25WfAVQGmu7XMEgX7YShHaGUZt83THk1r7dtLO
         t4AT81VmO4vtLGL4UzzyqhvGELNlK/rux+LjkBMWDK07wvTHaiyq0WYSSQmtE54aOf9I
         JMKw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=r4Xp39aXpV011e+5h8njmyuT7Fm/E+rF8jmDGDSv4mY=;
        b=NNCtvMYRTzjXEiOz9Zd5aFSxrXhlyBLs2RfVgDmPqs4+jSU0AR80pi/lxleR/hyjhK
         1GY6JP/iIwo1i3MR66sTSut93xtFY9BbbrH+Bnek5u4sd4NGzHwm2KNUeERnCtE0ze6f
         pb9KHfkHQ1/VGxGZo6YZX6Kl/91sOCd34fj0ggSGo/SfNv+XGXiF7w4a69V8lTiGIrcd
         OPLtxORokaLaqDVlHAJ6FnxSXbUDtX8bwZAaXVu8p0sC7+FISm/u4bVRmpRPw/2LQGaS
         C5/+OR1mtujBjoAIB1TW940XBKxYEjTaENMwXxtzWkIt8sBYF+YPXbZTOkLoYhkvLXTG
         gVlQ==
X-Gm-Message-State: ANoB5pnmrlXdI1p+I0x9sIki/kEbP3+BTss1dKa0XfwbQ5+FMrlOg251
        XdlmSZK6Qyurjh4Cqa6Egz0QHOf0Y40gd9sQ4Fk=
X-Google-Smtp-Source: AA0mqf5mBeHooqfwF375ytElVysiuJgCeZliHUGQbwRhxsTcxQeqoMV3PAUczhFmeJ6UKX4C30tvWz7zKq5mn8i3Uv8=
X-Received: by 2002:a17:906:95c3:b0:78e:975:5e8 with SMTP id
 n3-20020a17090695c300b0078e097505e8mr28053095ejy.82.1669654935782; Mon, 28
 Nov 2022 09:02:15 -0800 (PST)
MIME-Version: 1.0
References: <20221127190244.888414-1-christoph.fritz@hexdev.de>
 <58a773bd-0db4-bade-f8a2-46e850df9b0b@hartkopp.net> <Y4SKZb9woV5XE1bU@mars> <202211281549.47092.pisa@cmp.felk.cvut.cz>
In-Reply-To: <202211281549.47092.pisa@cmp.felk.cvut.cz>
From:   Ryan Edwards <ryan.edwards@gmail.com>
Date:   Mon, 28 Nov 2022 12:02:04 -0500
Message-ID: <CAEVdEgBWVgVFF2utm4w5W0_trYYJQVeKrcGN+T0yJ1Qa615bcQ@mail.gmail.com>
Subject: Re: [RFC][PATCH 0/2] LIN support for Linux
To:     Pavel Pisa <pisa@cmp.felk.cvut.cz>
Cc:     Christoph Fritz <christoph.fritz@hexdev.de>,
        Oliver Hartkopp <socketcan@hartkopp.net>,
        Richard Weinberger <richard@nod.at>,
        Andreas Lauser <andreas.lauser@mbition.io>,
        Wolfgang Grandegger <wg@grandegger.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Jonathan Corbet <corbet@lwn.net>, linux-can@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

All,

On Mon, Nov 28, 2022 at 10:09 AM Pavel Pisa <pisa@cmp.felk.cvut.cz> wrote:
>
> Hello Christoph and Oliver,
>
> On Monday 28 of November 2022 11:16:05 Christoph Fritz wrote:
> > > are you already aware of this LIN project that uses the Linux SocketCAN
> > > infrastructure and implements the LIN protocol based on a serial tty
> > > adaption (which the serial LIN protocol mainly is)?
> > >
> > > https://github.com/lin-bus
> >
> > Sure, that's why I initially added Pavel Pisa to the recipients of this
> > RFC patch series. When there is an internal kernel API for LIN, his
> > sllin (tty-line-discipline driver for LIN) could be adjusted and finally
> > go mainline.
>
> Some layer common for UART based and dedicated LIN hardware would
> be usesfull. The main think to decide is if the solution encoding
> LIN interface control into CAN messages is the right one and how
> the encoding should work. Actual mapping keeps LIN and CAN data
> 1:1 and puts control into identifier and flags. It has advantage
> that common SocketCAN infrastructure can be used. There is disadvantage
> that in the case of real CAN to LIN gateway connected to CAN bus
> almost whole identifiers range is occupied by gateway control.
> If the response table control and LIN identifier is part of the data
> field then I can imagine, that more real gateway devices can be
> be connected to the single CAN bus. But if there is not standard
> followed by all such gateways producers then it is not of much help.
> So probably actual mechanism is reasonable.
>
> > Adding LIN only as a tty-line-discipline does not fit all the currently
> > available hardware. Another argument against a tty-line-discipline only
> > approach as a LIN-API is, that there is no off the shelf standard
> > computer UART with LIN-break-detection (necessary to meet timing
> > constraints), so it always needs specially crafted hardware like USB
> > adapters or PCIe-cards.
>
> Break is not so big problem, slave side baudate automatic setup
> is and then control of Rx FIFO depth and if not possible then its
> switchinch off which needs generic UART level API longterm
>
>   https://github.com/lin-bus/linux-lin/issues/13
>
> > For the handful of specialized embedded UARTs with LIN-break-detection I
> > guess it could make more sense to go the RS485-kind-of-path and
> > integrate LIN support into the tty-driver while not using a
> > tty-line-discipline there at all.
>
> The state automata is required and its implementation in userspace
> complicates the design and would result in higher latencies
> (memory context switch etc.) but may be not so critical for 19200 baud
> or similar. Kernel with RT preempt support is quite capable and for
> master side there is time when driver does not lost Rx characters.
>
> > > IIRC the implementation of the master/slave timings was the biggest
> >
> > Currently sllin only supports master mode, I guess because of the tight
> > timing constraints.
>
> On the UART with FIFO control, there is no problem with response
> latency on moderately loaded fully preemptive kernel and slLIN
> supports both modes.
>
> I see as the main problem for actual integration of both modes
> to select acceptable names for standard defined entities "master node"
> and "slave task". May it be "coordinator", "initiator" and "responder"
> or "target".... Probably N_SLLIN and N_SLLIN_SLAVE are unacceptable
> today...
>
> > > challenge and your approach seems to offload this problem to your
> > > USB-attached hardware right?
> >
> > The hexLIN USB adapter processes slave mode answer table on its own,
> > just to meet timing constraints.  For master mode, it is currently not
> > offloaded (but could be if really necessary).
>
> Yes, for USB the responses uploading to device is a must and API has
> to count with it.
>
> > The amount of offloading (if any at all) is totally up to the device and
> > its device-driver (the entity actually processing data). So sllin does
> > not do offloading but can only work in relaxed timing constrained
> > environments.
> > An UART with built in LIN-break-detection (there are a few) might be
> > able to fully meet timing constraints without offloading (as well as
> > e.g. a PCIe card).
>
> In theory request/response loop up to RT user space task but keeping in
> the kernel is better and less error prone to applications errors.
>
> > > Can I assume there will be a similar CAN-controlled programming interface
> > > to create real time master/slave protocol frames like in a usual CAN/LIN
> > > adapter (e.g. https://www.peak-system.com/PCAN-LIN.213.0.html) ??
> >
> > I already did some tests letting hexLIN and PCAN talk to each other in a
> > real time manner. Please see my preliminary PDF docu at
> > https://hexdev.de/hexlin/

Marc gave me a heads on on this discussion and I have some insight.

I've spent quite a bit of time trying to craft a solution for the LIN
problem.  Even with a TTY solution the best I was able to achieve was
40ms turnaround between the header and response which exceeded the
timeout of the master.  This was in userspace and I assume that a
kernel solution would better be able to meet the timing but this
solution would only work for devices with embedded UART.

I did create a solution that uses the gs_usb driver using "pseduo" CAN
frames that currently supports slave and monitor mode.  I had no use
cases for master mode up to this point so it has not yet been
implemented.  The framework is there if it needs to be added.

The README contains the HOWTO on usage of the driver.  Right now it's
a hack but could be better designed using message flags or a seperate
CAN channel.

In my design the device contains a slave response table which is
configured via CAN frames via socketcan.  Currently up to 10 master
frames can be responded to.  It also allows the LIN node to be put
into monitor mode and gate those messages to the host via a CAN
message.

https://github.com/ryedwards/budgetcan_fw

Thanks,

--Ryan

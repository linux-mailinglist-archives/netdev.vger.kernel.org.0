Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4CD8163ABC8
	for <lists+netdev@lfdr.de>; Mon, 28 Nov 2022 15:58:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232064AbiK1O65 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Nov 2022 09:58:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48460 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231865AbiK1O6y (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Nov 2022 09:58:54 -0500
X-Greylist: delayed 498 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Mon, 28 Nov 2022 06:58:47 PST
Received: from mailgw.felk.cvut.cz (mailgw.felk.cvut.cz [147.32.82.15])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 462EDC77D;
        Mon, 28 Nov 2022 06:58:47 -0800 (PST)
Received: from mailgw.felk.cvut.cz (localhost.localdomain [127.0.0.1])
        by mailgw.felk.cvut.cz (Proxmox) with ESMTP id 22FB530B2967;
        Mon, 28 Nov 2022 15:49:56 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        cmp.felk.cvut.cz; h=cc:cc:content-transfer-encoding:content-type
        :content-type:date:from:from:in-reply-to:message-id:mime-version
        :references:reply-to:subject:subject:to:to; s=felkmail; bh=gObjV
        pUBT6yWWy2zHm1E4x+/kbAZjX4Kp+c9QnYn8J8=; b=C0JlQU7KD/chwq6HeCj3w
        EuexRpxjj2GmLA3tJZMHWIs92fSQQZNE1Bh/2S6lOMEI5lNtsrD1FW/9oNWM3dj4
        Qpa+OTMlWWs3iOVy2Kf322XhWlk9a3OOmbydeVclrriqRobIgc8L3+R3VcJdZqYC
        ub7+gTZLTH3bw2LjJG6/n550j/myzJBm/V65xyudwUN+E40qkDU0yLtIbkyRiibu
        evuXxiv6yDnG2q+eU396PjTvlTqc4UiuaV8e+4wCnUoN8BMN6sEXCHdh8PISKGsW
        pr+DhjJXDKoq/ntWoz+YhZO+Ujb9Fkztp+QA+2mRsOoqk26ME0wQiShIwEvPugi9
        w==
Received: from cmp.felk.cvut.cz (haar.felk.cvut.cz [147.32.84.19])
        by mailgw.felk.cvut.cz (Proxmox) with ESMTPS id 0CDEA30B2963;
        Mon, 28 Nov 2022 15:49:55 +0100 (CET)
Received: from haar.felk.cvut.cz (localhost [127.0.0.1])
        by cmp.felk.cvut.cz (8.14.0/8.12.3/SuSE Linux 0.6) with ESMTP id 2ASEnsDP030168;
        Mon, 28 Nov 2022 15:49:54 +0100
Received: (from pisa@localhost)
        by haar.felk.cvut.cz (8.14.0/8.13.7/Submit) id 2ASEnsmq030167;
        Mon, 28 Nov 2022 15:49:54 +0100
X-Authentication-Warning: haar.felk.cvut.cz: pisa set sender to pisa@cmp.felk.cvut.cz using -f
From:   Pavel Pisa <pisa@cmp.felk.cvut.cz>
To:     Christoph Fritz <christoph.fritz@hexdev.de>
Subject: Re: [RFC][PATCH 0/2] LIN support for Linux
Date:   Mon, 28 Nov 2022 15:49:47 +0100
User-Agent: KMail/1.9.10
Cc:     Oliver Hartkopp <socketcan@hartkopp.net>,
        Richard Weinberger <richard@nod.at>,
        Andreas Lauser <andreas.lauser@mbition.io>,
        Wolfgang Grandegger <wg@grandegger.com>,
        "Marc Kleine-Budde" <mkl@pengutronix.de>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Jonathan Corbet <corbet@lwn.net>, linux-can@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20221127190244.888414-1-christoph.fritz@hexdev.de> <58a773bd-0db4-bade-f8a2-46e850df9b0b@hartkopp.net> <Y4SKZb9woV5XE1bU@mars>
In-Reply-To: <Y4SKZb9woV5XE1bU@mars>
X-KMail-QuotePrefix: > 
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <202211281549.47092.pisa@cmp.felk.cvut.cz>
X-Spam-Status: No, score=-2.3 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,NICE_REPLY_A,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello Christoph and Oliver,

On Monday 28 of November 2022 11:16:05 Christoph Fritz wrote:
> > are you already aware of this LIN project that uses the Linux SocketCAN
> > infrastructure and implements the LIN protocol based on a serial tty
> > adaption (which the serial LIN protocol mainly is)?
> >
> > https://github.com/lin-bus
>
> Sure, that's why I initially added Pavel Pisa to the recipients of this
> RFC patch series. When there is an internal kernel API for LIN, his
> sllin (tty-line-discipline driver for LIN) could be adjusted and finally
> go mainline.

Some layer common for UART based and dedicated LIN hardware would
be usesfull. The main think to decide is if the solution encoding
LIN interface control into CAN messages is the right one and how
the encoding should work. Actual mapping keeps LIN and CAN data
1:1 and puts control into identifier and flags. It has advantage
that common SocketCAN infrastructure can be used. There is disadvantage
that in the case of real CAN to LIN gateway connected to CAN bus
almost whole identifiers range is occupied by gateway control.
If the response table control and LIN identifier is part of the data
field then I can imagine, that more real gateway devices can be
be connected to the single CAN bus. But if there is not standard
followed by all such gateways producers then it is not of much help.
So probably actual mechanism is reasonable. 

> Adding LIN only as a tty-line-discipline does not fit all the currently
> available hardware. Another argument against a tty-line-discipline only
> approach as a LIN-API is, that there is no off the shelf standard
> computer UART with LIN-break-detection (necessary to meet timing
> constraints), so it always needs specially crafted hardware like USB
> adapters or PCIe-cards.

Break is not so big problem, slave side baudate automatic setup
is and then control of Rx FIFO depth and if not possible then its
switchinch off which needs generic UART level API longterm

  https://github.com/lin-bus/linux-lin/issues/13

> For the handful of specialized embedded UARTs with LIN-break-detection I
> guess it could make more sense to go the RS485-kind-of-path and
> integrate LIN support into the tty-driver while not using a
> tty-line-discipline there at all.

The state automata is required and its implementation in userspace
complicates the design and would result in higher latencies
(memory context switch etc.) but may be not so critical for 19200 baud
or similar. Kernel with RT preempt support is quite capable and for
master side there is time when driver does not lost Rx characters.

> > IIRC the implementation of the master/slave timings was the biggest
>
> Currently sllin only supports master mode, I guess because of the tight
> timing constraints.

On the UART with FIFO control, there is no problem with response
latency on moderately loaded fully preemptive kernel and slLIN
supports both modes.

I see as the main problem for actual integration of both modes
to select acceptable names for standard defined entities "master node"
and "slave task". May it be "coordinator", "initiator" and "responder"
or "target".... Probably N_SLLIN and N_SLLIN_SLAVE are unacceptable
today...

> > challenge and your approach seems to offload this problem to your
> > USB-attached hardware right?
>
> The hexLIN USB adapter processes slave mode answer table on its own,
> just to meet timing constraints.  For master mode, it is currently not
> offloaded (but could be if really necessary).

Yes, for USB the responses uploading to device is a must and API has
to count with it.

> The amount of offloading (if any at all) is totally up to the device and
> its device-driver (the entity actually processing data). So sllin does
> not do offloading but can only work in relaxed timing constrained
> environments.
> An UART with built in LIN-break-detection (there are a few) might be
> able to fully meet timing constraints without offloading (as well as
> e.g. a PCIe card).

In theory request/response loop up to RT user space task but keeping in
the kernel is better and less error prone to applications errors.

> > Can I assume there will be a similar CAN-controlled programming interface
> > to create real time master/slave protocol frames like in a usual CAN/LIN
> > adapter (e.g. https://www.peak-system.com/PCAN-LIN.213.0.html) ??
>
> I already did some tests letting hexLIN and PCAN talk to each other in a
> real time manner. Please see my preliminary PDF docu at
> https://hexdev.de/hexlin/

Best wishes,

                Pavel Pisa
    phone:      +420 603531357
    e-mail:     pisa@cmp.felk.cvut.cz
    Department of Control Engineering FEE CVUT
    Karlovo namesti 13, 121 35, Prague 2
    university: http://control.fel.cvut.cz/
    personal:   http://cmp.felk.cvut.cz/~pisa
    projects:   https://www.openhub.net/accounts/ppisa
    CAN related:http://canbus.pages.fel.cvut.cz/
    RISC-V education: https://comparch.edu.cvut.cz/
    Open Technologies Research Education and Exchange Services
    https://gitlab.fel.cvut.cz/otrees/org/-/wikis/home


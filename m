Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 84CD1525E7B
	for <lists+netdev@lfdr.de>; Fri, 13 May 2022 11:19:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1378348AbiEMIj2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 May 2022 04:39:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32916 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1378347AbiEMIj1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 May 2022 04:39:27 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 52C0C267C17
        for <netdev@vger.kernel.org>; Fri, 13 May 2022 01:39:24 -0700 (PDT)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1npQpW-0007dj-B1
        for netdev@vger.kernel.org; Fri, 13 May 2022 10:39:22 +0200
Received: from [IPv6:2a01:4f8:1c1c:29e9:22:41ff:fe00:1400] (unknown [IPv6:2a01:4f8:1c1c:29e9:22:41ff:fe00:1400])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256
         client-signature RSA-PSS (4096 bits) client-digest SHA256)
        (Client CN "mkl@blackshift.org", Issuer "StartCom Class 1 Client CA" (not verified))
        (Authenticated sender: mkl@blackshift.org)
        by smtp.blackshift.org (Postfix) with ESMTPSA id B02937D753
        for <netdev@vger.kernel.org>; Fri, 13 May 2022 08:39:21 +0000 (UTC)
Received: from bjornoya.blackshift.org
        by bjornoya with LMTP
        id SGIkOB1wfWLsJQYAs6a69A
        (envelope-from <broonie@kernel.org>)
        for <mkl-all@blackshift.org>; Thu, 12 May 2022 20:37:49 +0000
Received: from dspam.blackshift.org (localhost [127.0.0.1])
        by bjornoya.blackshift.org (Postfix) with SMTP id CF16D7CD6F
        for <mkl-all@blackshift.org>; Thu, 12 May 2022 20:37:49 +0000 (UTC)
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        by bjornoya.blackshift.org (Postfix) with ESMTPS id AD0DC7CD6E
        for <ptx@kleine-budde.de>; Thu, 12 May 2022 20:37:49 +0000 (UTC)
Received: from ams.source.kernel.org ([2604:1380:4601:e00::1])
        by metis.ext.pengutronix.de with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <broonie@kernel.org>)
        id 1npFZD-0003i3-F8; Thu, 12 May 2022 22:37:48 +0200
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A4E26B80AEA;
        Thu, 12 May 2022 20:37:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6AFCEC385B8;
        Thu, 12 May 2022 20:37:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1652387864;
        bh=bbpLZoOYzYww6nT6xnedncs0bC4IR5fIUiq0nu4/xf0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Pg2nidMSUn33vAFuxW0RB3y7udFhu8jp6cmxr4VrIK9v7wSLrF8Kl/xLKmv/feHT4
         v6ufzSONCEp0JTZUuiCUEKnn/K+z2ZeWziJXIm/47TnJc5qVzBcrng9hANrB2Dg9wm
         7USLZuoPTWjamTv+1IlRS3VC3UYsgp64IkNWNSHQC85JwbESBBWO7rj1+lIIJB5GQM
         NtLNFZmZ4WXCF83Nwl4mUNdzH/gU8yQ59k4tddFYYqi+R4l8HeHZnsVwPWH8t+78Cz
         BiVoD9C4nk2A2QXHgcvWsO7Hg6/yopTXiXnZfLmienpr26n6SNdUNy91mK3d27DMRp
         cM/abdGIJ660w==
Date:   Thu, 12 May 2022 21:37:39 +0100
From:   Mark Brown <broonie@kernel.org>
To:     David Jander <david@protonic.nl>
Cc:     linux-spi@vger.kernel.org, Marc Kleine-Budde <mkl@pengutronix.de>,
        Oleksij Rempel <ore@pengutronix.de>
Message-ID: <Yn1wE4TLyXCIm9GF@sirena.org.uk>
References: <20220512163445.6dcca126@erd992>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="P6TuPfVxnO0O6Ugp"
Content-Disposition: inline
In-Reply-To: <20220512163445.6dcca126@erd992>
X-Cookie: Oh, wow!  Look at the moon!
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
X-Spam-Level: 
X-Spam-Status: No, score=-4.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=unavailable autolearn_force=no version=3.4.6
Subject: Re: [RFC] A new SPI API for fast, low-latency regmap peripheral
 access
X-PTX-Original-Recipient: mkl@pengutronix.de
X-PTX-Original-Recipient: ptx@kleine-budde.de
X-SA-Exim-Connect-IP: 2001:67c:670:201:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--P6TuPfVxnO0O6Ugp
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, May 12, 2022 at 04:34:45PM +0200, David Jander wrote:

> Sorry for sending an RFC without actual patches. What I am about to propo=
se
> would require a lot of work, and I am sure I will not get it right without
> first asking for comments. I also assume that I might not be the only one
> asking/proposing this, and may ignore the existence of discussions that m=
ay
> have happened in the past. If I am committing a crime, please accept my
> apologies and let me know.

> TL;DR: drivers/spi/spi.c API has too much overhead for some use cases.

It would be really helpful if you could describe in concrete terms your
actual use case here.  According to your mail you are testing with a
single threaded echo server which is obviously not a realistic
application and will be a bit of a limiting factor, it would be good to
understand what's going on in a way that's less microbenchmarky.

High level it feels like you are approaching this at the wrong level, as
far as I can tell you are proposing a completely separate API for
drivers which cuts out all the locking which doesn't seem like a very
usable API for them as the performance characteristics are going to end
up being very system and application specific, it's going to be hard for
them to assess which API to use.  I'm not seeing anything here that says
add a new API, there's certainly room to make the existing API more
performant but I don't see the jump to a new API.

> There are many use-cases for SPI in the Linux kernel, and they all have
> special requirements and trade-offs: On one side one wants to transfer la=
rge
> amount of data to the peripheral efficiently (FLASH memory) and without
> blocking. On the opposite side there is the need to modify registers in a
> SPI-mapped peripheral, ideally using regmap.

> There are two APIs already: sync and async, that should cover these use-c=
ases.
> Unfortunately both share a large portion of the code path, which causes t=
he
> sync use-case for small, fast register manipulation to be bogged down by =
all
> the accounting and statistics code. There's also sometimes memcpy()'s inv=
olved
> to put buffers into DMA space (driver dependent), even though DMA isn't u=
sed.

That's not really a good description of what's going on with those APIs
or choosing between them - there's certainly no short/long message
distinction intended, the distinction is more about if the user needs to
get the results of the transfer before proceeding with a side order of
the sync APIs being more convenient to use.  In general if a user has a
lot of work to do and doesn't specifically need to block for it there
will often be a performance advantage in using the async API, even if
the individual messages are short.  Submitting asynchronously means that
we are more likely to be able to start pushing a new message immediately
after completion of one message which minimises dead time on the bus,
and opens up opportunities for preparing one message while the current
one is in flight that don't otherwise exist (opportunities than we
currently make much use of).  Conversely a large message where we need
the result in order to proceed is going to do just fine with the sync
API, it is actually a synchronous operation after all.

One example of lots of potentially short messages is regmap's cache sync
code, it uses async writes to sync the register map so that it can
overlap working out what to sync and marshalling the data with the
actual writes - that tends to pan out as meaning that the sync completes
faster since we can often identify and queue several more registers to
write in the time it takes to send the first one which works out faster
even with PIO controllers and bouncing to the worker thread, the context
switching ends up being less than the time taken to work out what to
send for even a fairly small number of registers.

> Assuming the *sync* API cannot be changed, this leads to the need to intr=
oduce
> a new API optimized specifically for this use-case. IMHO it is also reaso=
nable
> to say that when accessing registers on a peripheral device, the whole
> statistics and accounting machinery in spi.c isn't really so valuable, and
> definitely not worth its overhead in a production system.

That seems like a massive assumption, one could equally say that any
application that is saturating the SPI bus is going to be likely to want
to be able to monitor the performance and utilisation of the bus in
order to facilitate optimisation and so want the statistics.

> 5. Details of the SPI transfers involved
> ----------------------------------------
>=20
> The MCP2518FD CAN driver does a series of small SPI transfers when runnin=
g a
> single CAN message from cangen to canecho and back:
>=20
>  1. CAN message RX, IRQ line asserted
>  2. Hard IRQ empty, starts IRQ thread
>  3. IRQ thread interrogates MCP2518FD via register access:
>  3.1. SPI transfer 1: CS low, 72bit xfer, CS high
>  3.2. SPI transfer 2: CS low, 200bit xfer, CS high
>  3.3. SPI transfer 3: CS low, 72bit xfer, CS high
>  3.4. SPI transfer 4: CS low, 104bit xfer, CS high
>  4. IRQ thread ended, RX message gets delivered to user-space
>  5. canecho.c recv()
>  6. canecho.c send()
>  7. TX message gets delivered to CAN driver
>  8. CAN driver does spi_async to queue 2 xfers (replace by spi_sync equiv=
alent
>  in kernel C):
>  8.1. SPI message 1: CS low, 168bit xfer, CS high, CS low, 48bit xfer, CS=
 high
>  9. CAN message SOF starts appearing on the bus just before last CS high.

Note that this is all totally single threaded and sequential which is
going to change the performance characteristics substantially, for
example adding and driving another echo server or even just having the
remote end push another message into flight before it waits for a
response would get more mileage out of the async API.

> 6.1. Accounting spinlocks:

> Spinlocks are supposed to be fast, especially for the case that they are =
not
> contested, but in such critical paths their impact shouldn't be neglected.

> SPI_STATISTICS_ADD_TO_FIELD: This macro defined in spi.h has a spinlock, =
and
> it is used 4 times directly in __spi_sync(). It is also used in
> spi_transfer_one_message() which is called from there. Removing the spinl=
ocks
> (thus introducing races) makes the code measurably faster (several us).

> spi_statistics_add_transfer_stats(): Called twice from
> spi_transfer_one_message(), and also contains a spinlock. Removing these =
again
> has a measurable impact of several us.

So for example a sysctl to suppress stats, or making the stats code
fancier with per cpu data or whatever so it doesn't need to lock in the
hot path would help here (obviously the latter is a bit nicer).  Might
be interesting seeing if it's the irqsave bit that's causing trouble
here, I'm not sure that's actually required other than for the error
counters.

> spi_set_cs(): Removing all delay code and leaving the bare minimum for GP=
IO
> based CS activation again has a measurable impact. Most (all?) simple SPI
> peripheral chips don't have any special CS->clock->CS timing requirements=
, so
> it might be a good idea to have a simpler version of this function.

Surely the thing there would just be to set the delays to zero if they
can actually be zero (and add a special case for actually zero delay
which we don't currently have)?  But in any case devices do always have
some minimum requirements for delays at various points around asserting
chip select, plus there's considerations around providing enough ramp
time for signals to reach appropriate levels which are more system level
than chip level.  The required delays are normally very small so
effectively pan out as zero in a lot of systems but the faster things
run (both on the bus and for the SoC) the more visible they get and more
attention needs to be paid.  It should be possible to do something to
assess a delay as being effectively zero and round down which would feed
in here when we're managing the chip select from software but we can't
just ignore the delays.

I note that for example that the MPC2515 quotes minimum chip select
setup, hold and disable times of 50ns - those are very small, but they
are non-zero.

> Since this hypothetical new API would be used only for very short, very f=
ast
> transfers where latency and overhead should be minimized, the best way to=
 do
> it is obviate all scheduling work and do it strictly synchronous and base=
d on
> polling. The context switch of even a hard-IRQ can quickly cost a lot mor=
e CPU
> cycles than busy waiting for 48 bits to be shifted through the transmitte=
r at
> 20+MHz clock. This requires that SPI drivers offer low-level functions th=
at do
> such simple transfers on polling basis. The patches [1] from Marc Kleine-=
Budde
> already do this, but it is the SPI driver that choses whether to use poll=
ing or
> IRQ based transfers based on heuristics calculating the theoretical trans=
fer
> time given the clock frequency and its size. While it improves the perfor=
mance
> in a lot of cases already, peripheral drivers have no choice but to still=
 go
> through all the heavy code in spi.c.

There's a whole pile of assumptions in there about the specific system
you're running on and how it's going to perform.  Like I said above it
really feels like this is the wrong level to approach things at, it's
pushing decisions to the client driver that are really system specific.
Why would a client doing "short" transfers (short itself being a fuzzy
term) not want to use this interface, and what happens when for example
someone puts one of these CAN controllers on a USB dongle which simply
can't implement a non-blocking mode?  We should aim to do things which
just benefit any client driver using the APIs idiomatically without them
having to make assumptions about either the performance characteristics
of the system they're running on or the features it has, especially if
those assumptions would make the driver unusuable on some systems.

> Since these are low-latency applications, chances are very high that the
> hardware is also designed for low-latency access, which implies that CS
> control via GPIO most probably uses local GPIO controllers instead of I2C=
 GPIO
> expanders for example, so CS access can be assumed to be fast and direct =
and

High chances are not guarantees, and none of this sounds like things
that should require specific coding in the client drivers.

> not involve any context switches. It could be argued that it might even be
> beneficial to have an API that can be called from hard IRQ context, but
> experiments in this case showed that the gain of doing the CAN message re=
ad
> out directly in hard-IRQ and removing the IRQ thread is minimal. But bett=
er
> use-cases could be conceived, so this possibility might need consideration
> also.

That's something that the async API (or the sync API in the contended
case) can enable - if we have another transfer queued then we would if
someone did the work be able to arrange to start pushing it immediately
the prior transfer completes.

> Care should be taken to solve locking in such a way, that it doesn't impa=
ct
> performance for the fast API, while still allowing safe concurrency with
> spi_sync and spi_async. I did not go as far as to solve this issue. I just
> used a simple spinlock and carefully avoided using any call to the old AP=
I for
> doing these proof-of-concept measurements.

Apart from the hard bits...  :P

The only bits of the existing code that you've specifically identified
as taking substantial time here are the delays and the statistics, both
of these seem like areas which could just be improved in place without
requiring changes outside of the SPI subsystem that benefit all users.
It sounds like the bits you've profiled as causing trouble are delays
and stats synchronisation which does sound plausible but those do also
seem like they can be specifically targetted - being smarter about when
we actually do a delay, and either improving the locking or providing
more optimisation for the stats code.

If there are other bits of the message setup code which are getting in
the way and don't have obvious paths for optimisation (the validation
potentially?) then if your application is spamming a lot of the same
operation (eg, with the status reading in the interrupt handler) then
quite a while ago Martin Sparl was looking at providing an interface
which would allow client drivers to pre-cook messages so that they could
be submitted multiple times without going through the validation that we
normally do (and perhaps get some driver preparation done as well).  He
was looking at it for other reasons but it seems like a productive
approach for cutting down on the setup overhead, it would require more
up front work in the client but cut down on the amount of work done per
operation and seems like it should scale well over different systems.

> Performance of spi.c API for the specified use-cases is not ideal.
> Unfortunately there is no single smoking gun to be pointed at, but instead
> many different bits which are not needed for the given use-case that add =
to
> the bloat and ultimately have a big combined performance impact.
> The stated usage scenario is fairly common in the Linux kernel. A simple
> investigation counted 60+ IIO drivers and 9 input drivers alone that use
> spi_sync*() for example, up to a total of 171 .c files. In contrast only =
11 .c
> files use the spi_async*() calls. This does not account for all users of
> regmap_spi.
> Due to this, IMHO one can ask for a better, simpler, more efficient API f=
or
> these use-cases, am I want to propose to create it.

I see the problem, what I don't see is why it requires a new externally
visible API to solve it beyond the suggestion about potentially
preparing messages for repeated use if that's even something that's
really registering.

--P6TuPfVxnO0O6Ugp
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmJ9cBMACgkQJNaLcl1U
h9CJYQf/YecD5lGUzSlutzAv/m7Zvj6EQun+TvstfAoB5RfCnou7zsg45YPZQD2G
DtuAvJtRaGMDAFtInPsTKDqlhcBbYDHxiQhtsdmF8jE/EdVcS5qSZmtQqD2QJ3yf
NXO/rIChhRKQt4L0s+mjx40BoPyAiDOsStuwKMZfqEJOUfBgbEhX7AJ8RzrJfUkz
WTzrXbifxj6sMxDOJLm9xflORhFu8qtAz6D7ab/LdDqr3rgYFEfTYOnuLFHAYKLJ
uaR22+swKr8kR8mhyL1k8KbqBUrCx4gtyH6Z2LyTFTw+qIQx7OJFgNmlzdFwvwhL
ZN4aJETTEha/2cLmoSH6Nj526gXexA==
=6Ovu
-----END PGP SIGNATURE-----

--P6TuPfVxnO0O6Ugp--


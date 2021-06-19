Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4AAC83AD9FE
	for <lists+netdev@lfdr.de>; Sat, 19 Jun 2021 14:35:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234177AbhFSMhO convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Sat, 19 Jun 2021 08:37:14 -0400
Received: from mail-lj1-f175.google.com ([209.85.208.175]:44791 "EHLO
        mail-lj1-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234148AbhFSMhN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 19 Jun 2021 08:37:13 -0400
Received: by mail-lj1-f175.google.com with SMTP id d2so17970549ljj.11;
        Sat, 19 Jun 2021 05:35:00 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=6I2FWb7mQ/8/cNGUfD+T2KExB3NTxaQoGVuBZhhJFdQ=;
        b=igiULZhtz8+3FMj25Zp6CXmJ/V6kvf/DZPLj3RYStiKHeIQzlqIfutyIqUIcm69tW3
         gQDXq6ui0fRKP7aLtsRsKy8fL7oVWjBip+ROOml6q7WOcktzYjnCOpNUP9XbCPAYPsmc
         mSJzSYW0ZiwDg5wvHiStlAb/s9RuhB/DIoZ1vHT872ceQ9QDsNuVA5w0+fCq2klHRTl2
         Fds+ebDgCNbFQ7hlKUtzFERlUsrqQ9o1DLrubKvgZHYXXjZYTAlOCEj0YPUERSZJfJ7Q
         XEg16Hj5UIaUcoxNBWwTnmiAmTnVImULF1QPUcXeI7BrubkqyEdsxowR+aWhyOkWoSRb
         yPgg==
X-Gm-Message-State: AOAM530cXQRzW00H2PI2459ykBpszNUQ7Ko5dGQBlrFjbKm7OWRGOD+5
        ctxbmpUUcYuYaNqRBIzpK4qYMztl0LTIHjeyX2w=
X-Google-Smtp-Source: ABdhPJyGlvxNS4qEXQbN9UP3lnf7MWdOw6Sbptjj9VjQMcrBuIX3nEGzgtK3JTp1QISnxGEeeIcFQ71Ygsg9KgOkymE=
X-Received: by 2002:a2e:8699:: with SMTP id l25mr13273570lji.315.1624106100118;
 Sat, 19 Jun 2021 05:35:00 -0700 (PDT)
MIME-Version: 1.0
References: <20210603151550.140727-1-mailhol.vincent@wanadoo.fr>
 <20210603151550.140727-3-mailhol.vincent@wanadoo.fr> <20210618093424.xohvsqaaq5qf2bjn@pengutronix.de>
 <CAMZ6RqJn5z-9PfkcJdiS6aG+qCPnifXDwH26ZEwo8-=id=TXbw@mail.gmail.com>
 <CAMZ6RqKrPQkPy-dAiQjAB4aKnqeaNx+L-cro8F_mc2VPgOD4Jw@mail.gmail.com>
 <20210618124447.47cy7hyqp53d4tjh@pengutronix.de> <CAMZ6RqJCZB6Q79JYfxD7PGboPwMndDQRKsuUEk5Q34fj2vOcYg@mail.gmail.com>
 <e90cbad2467e2ef42db1e4a14ecdfd8c512965ea.camel@esd.eu>
In-Reply-To: <e90cbad2467e2ef42db1e4a14ecdfd8c512965ea.camel@esd.eu>
From:   Vincent MAILHOL <mailhol.vincent@wanadoo.fr>
Date:   Sat, 19 Jun 2021 21:34:50 +0900
Message-ID: <CAMZ6RqJphchOBFudyuVcN+imnCgCBu7P6yAaNhjzJypGKCQFpA@mail.gmail.com>
Subject: Re: CAN-FD Transmitter Delay Compensation (TDC) on mcp2518fd
To:     =?UTF-8?Q?Stefan_M=C3=A4tje?= <Stefan.Maetje@esd.eu>
Cc:     "mkl@pengutronix.de" <mkl@pengutronix.de>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-can@vger.kernel.org" <linux-can@vger.kernel.org>,
        "socketcan@hartkopp.net" <socketcan@hartkopp.net>,
        "thomas.kopp@microchip.com" <thomas.kopp@microchip.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat. 19 Jun 2021 à 00:55, Stefan Mätje <Stefan.Maetje@esd.eu> wrote:
> Am Freitag, den 18.06.2021, 23:27 +0900 schrieb Vincent MAILHOL:
> > On Fri. 18 Jun 2021 at 21:44, Marc Kleine-Budde <mkl@pengutronix.de> wrote:
> > > On 18.06.2021 20:17:51, Vincent MAILHOL wrote:
> > > > > > I just noticed in the mcp2518fd data sheet:
> > > > > >
> > > > > > > bit 14-8 TDCO[6:0]: Transmitter Delay Compensation Offset bits;
> > > > > > > Secondary Sample Point (SSP) Two’s complement; offset can be
> > > > > > > positive,
> > > > > > > zero, or negative.
> > > > > > >
> > > > > > > 011 1111 = 63 x TSYSCLK
> > > > > > > ...
> > > > > > > 000 0000 = 0 x TSYSCLK
> > > > > > > ...
> > > > > > > 111 1111 = –64 x TSYSCLK
> > > > > >
> > > > > > Have you takes this into account?
> > > > >
> > > > > I have not. And I fail to understand what would be the physical
> > > > > meaning if TDCO is zero or negative.
> > >
> > > The mcp25xxfd family data sheet says:
> > >
> > > > SSP = TDCV + TDCO
> > > > > TDCV indicates the position of the bit start on the RX pin.
> > >
> > > If I understand correctly in automatic mode TDCV is measured by the CAN
> > > controller and reflects the transceiver delay.
> >
> > Yes. I phrased it poorly but this is what I wanted to say. It is
> > the delay to propagate from the TX pin to the RX pin.
> >
> > If TDCO = 0 then SSP = TDCV + 0 = TDCV thus the measurement
> > occurs at the bit start on the RX pin.
> >
> > > I don't know why you want
> > > to subtract a time from that....
> > >
> > > The rest of the relevant registers:
> > >
> > > > TDCMOD[1:0]: Transmitter Delay Compensation Mode bits; Secondary Sample
> > > > Point (SSP)
> > > > 10-11 = Auto; measure delay and add TDCO.
> > > > 01 = Manual; Do not measure, use TDCV + TDCO from register
> > > > 00 = TDC Disabled
> > > >
> > > > TDCO[6:0]: Transmitter Delay Compensation Offset bits; Secondary Sample
> > > > Point (SSP)
> > > > Two’s complement; offset can be positive, zero, or negative.
> > > > 011 1111 = 63 x TSYSCLK
> > > > ...
> > > > 000 0000 = 0 x TSYSCLK
> > > > ...
> > > > 111 1111 = –64 x TSYSCLK
> > > >
> > > > TDCV[5:0]: Transmitter Delay Compensation Value bits; Secondary Sample
> > > > Point (SSP)
> > > > 11 1111 = 63 x TSYSCLK
> > > > ...
> > > > 00 0000 = 0 x TSYSCLK
> >
> > Aside from the negative TDCO, the rest is standard stuff. We can
> > note the absence of the TDCF but that's not a blocker.
> >
> > > > > If TDCO is zero, the measurement occurs on the bit start when all
> > > > > the ringing occurs. That is a really bad choice to do the
> > > > > measurement. If it is negative, it means that you are measuring the
> > > > > previous bit o_O !?
> > >
> > > I don't know...
> > >
> > > > > Maybe I am missing something but I just do not get it.
> > > > >
> > > > > I believe you started to implement the mcp2518fd.
> > >
> > > No I've just looked into the register description.
> >
> > OK. For your information, the ETAS ES58x FD devices do not allow
> > the use of manual mode for TDCV. The microcontroller from
> > Microchip supports it but ETAS firmware only exposes the
> > automatic TDCV mode. So it can not be used to test what would
> > occur if SSP = 0.
> >
> > I will prepare a patch to allow zero value for both TDCV and
> > TDCO (I am a bit sad because I prefer the current design, but if
> > ISO allows it, I feel like I have no choice).  However, I refuse
> > to allow the negative TDCO value unless someone is able to
> > explain the rationale.
>
> Hi,
>
> perhaps I can shed some light on the idea why it is a good idea to allow
> negative TDC offset values. Therefore I would describe the TDC register
> interface of the ESDACC CAN-FD controller of our company (see
> https://esd.eu/en/products/esdacc).

Thanks for joining the conversation. I am happy to receive help
from more experts!

> Register description of TDC-CAN-FD register (reserved bits not shown):
>
> bits [5..0], RO: TDC Measured (TDCmeas)
>         Currently measured TDC value, needs baudrate to be set and CAN traffic
>
> bits [21..16], R/W: TDC offset (TDCoffs)
>         Depending on the selected mode (see TDC mode)
>         - Auto TDC, automatic mode (default)
>                 signed offset onto measured TDC (TDCeff = TDCmeas + TDCoffs),
>                 interpreted as 6-bit two's complement value
>         - Manual TDC
>                 absolute unsigned offset (TDCeff = TDCoffs),
>                 interpreted as 6-bit unsigned value
>         - Other modes
>                 ignored
>         In either case TDC offset is a number of CAN clock cycles.
>
> bits [31..30], R/W: TDC mode
>         00 = Auto TDC
>         01 = Manual TDC
>         10 = reserved
>         11 = TDC off

First remark is that you use different naming than what I
witnessed so far in other datasheets. Let me try to give the
equivalences between your device and the struct can_tdc which I
proposed in my patches.

The Left members are ESDACC CAN-FD registers, the right members
are variables from Socket CAN.

** Auto TDC **
TDCoffs = struct can_tdc::tdco

** Manual TDC **
TDCoffs = struct can_tdc::tdcv + struct can_tdc::tdco

In both cases, TDCeff corresponds to the SSP position.

> So in automatic mode the goal is to be able to move the real sample point
> forward and(!) backward from the measured transmitter delay. Therefore the
> TDCoffs is interpreted as 6-bit two's complement value to make negative offsets
> possible and to decrease the effective (used) TDCeff below the measured value
> TDCmeas.
>
> As far as I have understood our FPGA guy the TDCmeas value is the number of
> clock cycles counted from the start of transmitting a dominant bit until the
> dominant state reaches the RX pin.

Your definition of TDCmeas is consistent with the definition of
TDCV in socket CAN.

What I miss to understand is what does it mean to subtract from
that TDCmeas/TDCV value. If you subtract from it, it means that
TDCeff/SSP is sampled before the signal reaches the RX
pin. Correct?

> During the data phase the sample point is controlled by the tseg values set for
> the data phase but is moved additionally by the number of clocks specified by
> TDCeff (or SSP in the mcp2518fd case).

Here I do not follow you. The SSP, as specified in ISO 11898-1
is "specified by its distance from the start of the bit
time". Either you do not use TDC and the measurement is done on
the SP according to the tseg values, either you do use TDC and
the measurement is done on the SSP according to the TDC
values. There is no mention of mixing the tseg and tdc values.

P.S.: don't hesitate to invite your FPGA guy to this thread!


Yours sincerely,
Vincent

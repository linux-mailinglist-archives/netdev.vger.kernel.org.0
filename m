Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5161D3AC9AB
	for <lists+netdev@lfdr.de>; Fri, 18 Jun 2021 13:18:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232156AbhFRLUO convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Fri, 18 Jun 2021 07:20:14 -0400
Received: from mail-lf1-f42.google.com ([209.85.167.42]:40928 "EHLO
        mail-lf1-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231697AbhFRLUN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Jun 2021 07:20:13 -0400
Received: by mail-lf1-f42.google.com with SMTP id i13so16047012lfc.7;
        Fri, 18 Jun 2021 04:18:03 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=yRbNIo7mdOmljXxfz5le+Oto5o1J3BbeaQLhHAXBHGI=;
        b=tbRC4eyVCtFzFj4dsnupEBsIueIr0+W8Pc9FBAxbAMN47Ct4h9TtXcdzs6i+URM9rb
         vGvip6ITSTJd7iW9GvDZLfTInmS1UZLVNHPKnkdOiVfHmDGVhDufCqa0TXQG017MLtQS
         PWN7wioUkDrqnVnFyecxgsQ4STI4F+ll79Y29NEcUYPKk6ygoOK5qUt9mGGN3qNzgip8
         IuN1cCW9joSk+b2UbgWCbDG0QffbzkY1gMMk7i2/RCdbK51gKj9nhhv7y1OD4BTPAkyq
         JaAoTAOi5j4S0c5IoxFnYYU3gapK+3jPF5HguM6PwzBvqRDb5RMTiVD/qz1BAbbFUVb0
         KzGg==
X-Gm-Message-State: AOAM530aL2WQkQsYWnfgdc3wAL2IuCgzh2JiiSxuye7uxzSU9Bpe5u34
        YjXKIMvkV5eQUBvsxEiiRqQXtTilp4vBIEjCvWk=
X-Google-Smtp-Source: ABdhPJzknHbTJ1YM7Eeik4sLMYALpeh797mnjuQMHn/P8QehPTVEiHezb0bwGfO4Pbbax2hItvigAeHi3UC+er6hAmM=
X-Received: by 2002:a05:6512:2314:: with SMTP id o20mr2696595lfu.531.1624015082551;
 Fri, 18 Jun 2021 04:18:02 -0700 (PDT)
MIME-Version: 1.0
References: <20210603151550.140727-1-mailhol.vincent@wanadoo.fr>
 <20210603151550.140727-3-mailhol.vincent@wanadoo.fr> <20210618093424.xohvsqaaq5qf2bjn@pengutronix.de>
 <CAMZ6RqJn5z-9PfkcJdiS6aG+qCPnifXDwH26ZEwo8-=id=TXbw@mail.gmail.com>
In-Reply-To: <CAMZ6RqJn5z-9PfkcJdiS6aG+qCPnifXDwH26ZEwo8-=id=TXbw@mail.gmail.com>
From:   Vincent MAILHOL <mailhol.vincent@wanadoo.fr>
Date:   Fri, 18 Jun 2021 20:17:51 +0900
Message-ID: <CAMZ6RqKrPQkPy-dAiQjAB4aKnqeaNx+L-cro8F_mc2VPgOD4Jw@mail.gmail.com>
Subject: Re: [PATCH v2 2/2] can: netlink: add interface for CAN-FD Transmitter
 Delay Compensation (TDC)
To:     Marc Kleine-Budde <mkl@pengutronix.de>
Cc:     linux-can <linux-can@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>,
        Oliver Hartkopp <socketcan@hartkopp.net>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri. 18 Jun 2021 at 19:23, Vincent MAILHOL
<mailhol.vincent@wanadoo.fr> wrote:
>
> On Fri. 18 Jun 2021 at 18:34, Marc Kleine-Budde <mkl@pengutronix.de> wrote:
> > On 04.06.2021 00:15:50, Vincent Mailhol wrote:
> > > Add the netlink interface for TDC parameters of struct can_tdc_const
> > > and can_tdc.
> > >
> > > Contrary to the can_bittiming(_const) structures for which there is
> > > just a single IFLA_CAN(_DATA)_BITTMING(_CONST) entry per structure,
> > > here, we create a nested entry IFLA_CAN_TDC. Within this nested entry,
> > > additional IFLA_CAN_TDC_TDC* entries are added for each of the TDC
> > > parameters of the newly introduced struct can_tdc_const and struct
> > > can_tdc.
> > >
> > > For struct can_tdc_const, these are:
> > >         IFLA_CAN_TDC_TDCV_MAX
> > >         IFLA_CAN_TDC_TDCO_MAX
> > >         IFLA_CAN_TDC_TDCF_MAX
> > >
> > > For struct can_tdc, these are:
> > >         IFLA_CAN_TDC_TDCV
> > >         IFLA_CAN_TDC_TDCO
> > >         IFLA_CAN_TDC_TDCF
> >
> > I just noticed in the mcp2518fd data sheet:
> >
> > | bit 14-8 TDCO[6:0]: Transmitter Delay Compensation Offset bits;
> > | Secondary Sample Point (SSP) Two’s complement; offset can be positive,
> > | zero, or negative.
> > |
> > | 011 1111 = 63 x TSYSCLK
> > | ...
> > | 000 0000 = 0 x TSYSCLK
> > | ...
> > | 111 1111 = –64 x TSYSCLK
> >
> > Have you takes this into account?
>
> I have not. And I fail to understand what would be the physical
> meaning if TDCO is zero or negative.
>
> TDCV indicates the position of the bit start on the RX pin. If
> TDCO is zero, the measurement occurs on the bit start when all
> the ringing occurs. That is a really bad choice to do the
> measurement.  If it is negative, it means that you are measuring
> the previous bit o_O !?
>
> Maybe I am missing something but I just do not get it.
>
> I believe you started to implement the mcp2518fd. Can you force a
> zero and a negative value and tell me if the bus is stable?

Actually, ISO 11898-1 specifies that the "SSP position should be
at least 0 to 63 minimum time quanta". This means that we can
have SSP = TDCV + TDCO = 0. In my implementation, I used 0 as a
reserved value for TDCV and TDCO. To comply with the standard, I
now need to allow both TDCV and TDCO to be zero and add a new
field in struct tdc to manage the automatic/manual options.

That said, these zero values still make no sense to me. Why would
someone do the measurement on the bit edge?

Concerning the negative values, the ISO standard says nothing
about it.  If you are using the automatic measurement, a negative
TDCO is impossible to use. TDCV is measured on every bit. When
the measurement is done, it is too late to subtract from it (or
maybe the mcp2518fd has a time machine built in?). If you are
using the manual mode for TDCV, just choose two positive values
so that TDCV + TDCO = SSF.

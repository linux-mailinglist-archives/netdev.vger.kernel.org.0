Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 19BBC3F0666
	for <lists+netdev@lfdr.de>; Wed, 18 Aug 2021 16:19:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239506AbhHROUK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Aug 2021 10:20:10 -0400
Received: from mail-lj1-f172.google.com ([209.85.208.172]:44901 "EHLO
        mail-lj1-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240282AbhHROSE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Aug 2021 10:18:04 -0400
Received: by mail-lj1-f172.google.com with SMTP id s3so5368473ljp.11;
        Wed, 18 Aug 2021 07:17:29 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=K/KWYvHcqVpUzLr8JbrCL76Se9urIzWUVDVPiL6TmZU=;
        b=T4h2HS29ofcRhFYFz9lWN8S7SGDxXgA48eFeLFDwlYn+URbfdb86TxxX4ClkBPWKEe
         XOWvb3kuLbelH5+qsxjYAjY64mDUdTONjugfTLgpXxfHRKn+++AktYCXktKe6NgM0j1/
         8GVDx4D4BVyAHahlUkuZcCf/1mUtAGPhaCVQFo9hmBG+/K3G1ikFJ1WmlqXv0davYvGO
         VrjguedWAriZioyiWBv8zIN7g1Nje6w9w9D20+BkgIWgaKqN5oNbkrT2vQQgHlSwf1wu
         SHWooNpWCXbYBuC41AXj67Ud1myst58CEadIJIch501uWWmJpoj4RGeHjYVrXDznXTai
         paTQ==
X-Gm-Message-State: AOAM531WtUgg6Bjx9y5SJnpIj4hspE+IUYLctsOIXxbaQGi8Ssh8tm/D
        nxUi9/eINH87rZAyDKE5katWN+AI080MgfEQnIZl/MS2hqKcrA==
X-Google-Smtp-Source: ABdhPJzc+nvVVOhtjHxwe1PrcIjGkMwaa/M1M9roeDmN+ouHKjmxltdcg9RPbykdyYNDPvj5B8jP0HzRaM4NUJrY/g8=
X-Received: by 2002:a2e:9999:: with SMTP id w25mr8116060lji.359.1629296248311;
 Wed, 18 Aug 2021 07:17:28 -0700 (PDT)
MIME-Version: 1.0
References: <20210815033248.98111-1-mailhol.vincent@wanadoo.fr>
 <20210815033248.98111-3-mailhol.vincent@wanadoo.fr> <20210816084235.fr7fzau2ce7zl4d4@pengutronix.de>
 <CAMZ6RqK5t62UppiMe9k5jG8EYvnSbFW3doydhCvp72W_X2rXAw@mail.gmail.com>
 <20210816122519.mme272z6tqrkyc6x@pengutronix.de> <20210816123309.pfa57tke5hrycqae@pengutronix.de>
 <20210816134342.w3bc5zjczwowcjr4@pengutronix.de> <CAMZ6RqJFxKSZahAMz9Y8hpPJPh858jxDEXsRm1YkTwf4NFAFwg@mail.gmail.com>
 <20210817200123.4wcdwsdfsdjr3ovk@pengutronix.de> <CAMZ6RqKsjPF2gBbzsKatFG7S4qcOahSX9vSU=dj_e9R-Kqq0CA@mail.gmail.com>
 <20210818122923.hvxmffoi5rf7rbe6@pengutronix.de>
In-Reply-To: <20210818122923.hvxmffoi5rf7rbe6@pengutronix.de>
From:   Vincent MAILHOL <mailhol.vincent@wanadoo.fr>
Date:   Wed, 18 Aug 2021 23:17:16 +0900
Message-ID: <CAMZ6Rq+H4u9D41Fdx+J-kj35g3GVRqoYvDiHtR3LGMXfRjcsiA@mail.gmail.com>
Subject: Re: [PATCH v5 2/7] can: bittiming: allow TDC{V,O} to be zero and add can_tdc_const::tdc{v,o,f}_min
To:     Marc Kleine-Budde <mkl@pengutronix.de>
Cc:     linux-can <linux-can@vger.kernel.org>,
        =?UTF-8?Q?Stefan_M=C3=A4tje?= <Stefan.Maetje@esd.eu>,
        netdev <netdev@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed. 18 Aug 2021 at 21:29, Marc Kleine-Budde <mkl@pengutronix.de> wrote:
> On 18.08.2021 18:22:33, Vincent MAILHOL wrote:
> > > Backwards compatibility using an old ip tool on a new kernel/driver must
> > > work.
> >
> > I am not trying to argue against backward compatibility :)
> > My comment was just to point out that I had other intents as well.
> >
> > > In case of the mcp251xfd the tdc mode must be activated and tdcv
> > > set to the automatic calculated value and tdco automatically measured.
> >
> > Sorry but I am not sure if I will follow you. Here, do you mean
> > that "nothing" should do the "fully automated" calculation?
>
> Sort of.
> The use case is the old ip tool with a driver that supports tdc, for
> CAN-FD to work it must be configured in fully automated mode.

The current patch does that: "nothing" means that both TDC_AUTO
and TDC_MANUAL are not set, same as what an old ip tool would
do. And that triggers the default (fully automated) mode (call
can_calc_tdco()).

> > In your previous message, you said:
> >
> > > Does it make sense to let "mode auto" without a tdco value switch the
> > > controller into full automatic mode and /* nothing */ not tough the tdc
> > > config at all?
> >
> > So, you would like this behavior:
> >
> > | mode auto, no tdco provided -> kernel decides between TDC_AUTO and TDC off.
>
> NACK - mode auto, no tdco -> TDC_AUTO with tdco calculated by the kernel

Currently, the tdco calculation is paired with the decision to
enable or not TDC. If dbrp is one or two, then do the tdco
calculation, else, TDC is off (c.f. can_calc_tdco()). This
behaviour is to follow ISO 11898-1 which states that TDC is only
applicable if data BRP is one or two. In the current patch I
allow to have TDC enabled with a dbrp greater than 2 only if the
tdco is provided by the user (i.e. I allow the user to forcefully
go against ISO but the automatic calculation guarantees
compliance).

So what do you suggest to do when drbp is greater than 2? Still
enable TDC (and violate ISO standard) or return an error
code (e.g. -ENOTSUPP)?

> > | mode auto, tdco provided -> TDC_AUTO
>
> ACK - TDC_AUTO with user supplied tdco
>
> > | mode manual, tdcv and tdco provided -> TDC_MANUAL
>
> ACK - TDC_MANUAL with tdco and tdcv user provided
>
> > | mode off is not needed anymore (redundant with "nothing")
> > (TDCF left out of the picture intentionally)
>
> NACK - TDC is switched off

Same as the current patch then :)

> > | "nothing" -> TDC is off (not touch the tdc config at all)
>
> NACK - do not touch TDC setting, use previous setting

Sorry but I still fail to understand your definition of "do not
touch".

The first time you start a device, all the structures are zeroed
out meaning that TDC is off to begin with.  So the first time the
user do something like:

| ip link set can0 type can bitrate 1000000 dbitrate 8000000 fd on

If you "do not touch" TDC it means that all TDC values stays at
zero, i.e. TDC stays off. This would contradict point 1/.

> > Correct?
>
> See above. Plus a change that addresses your issue 1/ from below.
>
> If driver supports TDC it should be initially brought into TDC auto
> mode, if no TDC mode is given. Maybe we need an explizit TDC off to make
> that work.
>
> > If you do so, I see three issues:
> >
> > 1/ Some of the drivers already implement TDC. Those will
> > automatically do a calculation as long as FD is on. If "nothing"
> > now brings TDC off, some users will find themselves with some
> > error on the bus after the iproute2 update if they continue using
> > the same command.
>
> Nothing would mean "do not touch" and as TDC auto is default a new ip
> would work out of the box. Old ip will work, too. Just failing to decode
> TDC_AUTO...

See above: if you "do not touch", my understanding is that the
old ip tool will indefinitely keep TDC to its initial value:
everything zeroed out.

To turn TDC auto, you will eventually call can_calc_tdco() and
that will touch something.

> > 2/ Users will need to read and understand how to use the TDC
> > parameters of iproute2. And by experience, too many people just
> > don't read the doc. If I can make the interface transparent and
> > do the correct thing by default ("nothing"), I prefer to do so.
>
> ACK, see above
>
> > 3/ Final one is more of a nitpick. The mode auto might result in
> > TDC being off. If we have a TDC_AUTO flag, I would expect the
> > auto mode to always set that flag (unless error occurs). I see
> > this to be slightly counter intuitive (I recognize that my
> > solution also has some aspects which are not intuitive, I just
> > want to point here that none are perfect).
>
> What are the corner cases where TDC_AUTO results in TDC off?

dbrp greater than 2 (see above).

> > To be honest, I really preferred the v1 of this series where
> > there were no tdc-mode {auto,manual,off} and where the "off"
> > behavior was controlled by setting TDCO to zero. However, as we
> > realized, zero is a valid value and thus, I had to add all this
> > complexity just to allow that damn zero value.
>
> Maybe we should not put the TDC mode _not_ into ctrl-mode, but info a
> dedicated tdc-mode (which is not bit-field) inside the struct tdc?

If you do so, then you would need both a tdcmode and a
tdcmode_supported in order for the device to announce which modes
it supports (same as the ctrlmode and ctrlmode_supported in
can_priv). I seriously thought about this option but it seemed
like reinventing the wheel for me.

Also, it needs to be bit field to differentiate between a device
which would only support manual mode, one device which would only
support auto mode and one device which would support both.


Yours sincerely,
Vincent

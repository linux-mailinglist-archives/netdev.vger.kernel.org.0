Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 707A439F4FC
	for <lists+netdev@lfdr.de>; Tue,  8 Jun 2021 13:30:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231849AbhFHLca (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Jun 2021 07:32:30 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:41265 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231768AbhFHLc3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Jun 2021 07:32:29 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1623151836;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=2RI5ey86j83Uuwo2tjOtbNfV+FjFbv6oI/7mKd3IkLQ=;
        b=Qu9Up//g3HUH2+bYL3cjoK5VvOZdHi7bT7lqXz5XgWc/SyBSg315abGz6l+wvtWU9Dbn+d
        manbmFpWufFXaIPQVQ7ZjAH4Vs85JFaWAFJ62V3uITtxKAsYe0mGyQvX3wPWrJWvzX/Y3w
        1Hj5H0bLc1GS9dj25ffrDZhX2n9F7fg=
Received: from mail-ed1-f69.google.com (mail-ed1-f69.google.com
 [209.85.208.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-382-d-2I5-a1P5OL95VOUg3STQ-1; Tue, 08 Jun 2021 07:30:34 -0400
X-MC-Unique: d-2I5-a1P5OL95VOUg3STQ-1
Received: by mail-ed1-f69.google.com with SMTP id z16-20020aa7d4100000b029038feb83da57so10675259edq.4
        for <netdev@vger.kernel.org>; Tue, 08 Jun 2021 04:30:34 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version:content-transfer-encoding;
        bh=2RI5ey86j83Uuwo2tjOtbNfV+FjFbv6oI/7mKd3IkLQ=;
        b=fU/XzwX92UytO/1wgCjGiYIK7qK55GhTj8azb+wI5RawpPVCJvdzWeC7/DkwnWCwkh
         Qky4EicUkxxdn3/MjoDwJLDFKBCXyBYZoM4cfo7U+gUQEcUa6MD5I9H7xEriI80YHjWv
         rUymKmvVI5jhY7I7qbEe9F1BwukB8gQYmX0LwX3yohMiVGEaE1dicyUzgXhudiDENJ8b
         H2f19WjL07KRsm0zsgEcaE0xebn0vyfklf7mXD8GGp3cEj9KOCjMozN7pvUB3KAvScaY
         1EYz1evObcjpvHoNA92o3GZm+hPVaURX9UVUkklmMiDSjLJxsR4oMAtFiUB9yHkLeN81
         rZng==
X-Gm-Message-State: AOAM531+JCmHc1pTOn1IcA8XPwm4RCz7cNOqAiC1fAtXlrabB/zYcCrH
        hGmxQKxPFWF9OxhoY0fvOpJ2rDdyJ8ZptSnxQZ0qwP6lbWLLmnJiXzpHWfzeiPmv6xZtNJfNqjI
        qCohfPs2S+y0nTtbQ
X-Received: by 2002:a17:906:1796:: with SMTP id t22mr22681440eje.304.1623151833294;
        Tue, 08 Jun 2021 04:30:33 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJz8CZ6U8M4vg9eEJCjByzoIhJqloa45BAeveakQTDyR08YhlreAeA+vD8fAbQM0l0CtWDfZrg==
X-Received: by 2002:a17:906:1796:: with SMTP id t22mr22681420eje.304.1623151833049;
        Tue, 08 Jun 2021 04:30:33 -0700 (PDT)
Received: from alrua-x1.borgediget.toke.dk ([45.145.92.2])
        by smtp.gmail.com with ESMTPSA id w1sm7766790eds.37.2021.06.08.04.30.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 08 Jun 2021 04:30:32 -0700 (PDT)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id 88998180723; Tue,  8 Jun 2021 13:30:30 +0200 (CEST)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     Stephan Gerhold <stephan@gerhold.net>
Cc:     Loic Poulain <loic.poulain@linaro.org>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Aleksander Morgado <aleksander@aleksander.es>,
        Network Development <netdev@vger.kernel.org>,
        linux-remoteproc@vger.kernel.org,
        linux-arm-msm <linux-arm-msm@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Ohad Ben-Cohen <ohad@wizery.com>,
        Mathieu Poirier <mathieu.poirier@linaro.org>
Subject: Re: [RFC] Integrate RPMSG/SMD into WWAN subsystem
In-Reply-To: <YL4GiEEcOQC2XrjP@gerhold.net>
References: <YLfL9Q+4860uqS8f@gerhold.net>
 <CAMZdPi9tcye-4P4i0uXZcECJ-Big5T11JdvdXW6k2mEEi9XwyA@mail.gmail.com>
 <YLtDB2Cz5ttewsFu@gerhold.net>
 <CAMZdPi_-Qa=JnThHs_h-144dAfSAjF5s+QdBawdXZ3kk8Mx8ng@mail.gmail.com>
 <YL364+xK3mE2FU8a@gerhold.net> <87sg1tvryx.fsf@toke.dk>
 <YL4GiEEcOQC2XrjP@gerhold.net>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Tue, 08 Jun 2021 13:30:30 +0200
Message-ID: <87czswtwyx.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Stephan Gerhold <stephan@gerhold.net> writes:

> On Mon, Jun 07, 2021 at 01:23:18PM +0200, Toke H=C3=B8iland-J=C3=B8rgense=
n wrote:
>> Stephan Gerhold <stephan@gerhold.net> writes:
>> > On Mon, Jun 07, 2021 at 11:27:07AM +0200, Loic Poulain wrote:
>> >> On Sat, 5 Jun 2021 at 11:25, Stephan Gerhold <stephan@gerhold.net> wr=
ote:
>> >> > On Fri, Jun 04, 2021 at 11:11:45PM +0200, Loic Poulain wrote:
>> >> > > On Wed, 2 Jun 2021 at 20:20, Stephan Gerhold <stephan@gerhold.net=
> wrote:
>> >> > > > I've been thinking about creating some sort of "RPMSG" driver f=
or the
>> >> > > > new WWAN subsystem; this would be used as a QMI/AT channel to t=
he
>> >> > > > integrated modem on some older Qualcomm SoCs such as MSM8916 an=
d MSM8974.
>> >> > > >
>> >> > > > It's easy to confuse all the different approaches that Qualcomm=
 has to
>> >> > > > talk to their modems, so I will first try to briefly give an ov=
erview
>> >> > > > about those that I'm familiar with:
>> >> > > >
>> >> > > > ---
>> >> > > > There is USB and MHI that are mainly used to talk to "external"=
 modems.
>> >> > > >
>> >> > > > For the integrated modems in many Qualcomm SoCs there is typica=
lly
>> >> > > > a separate control and data path. They are not really related t=
o each
>> >> > > > other (e.g. currently no common parent device in sysfs).
>> >> > > >
>> >> > > > For the data path (network interface) there is "IPA" (drivers/n=
et/ipa)
>> >> > > > on newer SoCs or "BAM-DMUX" on some older SoCs (e.g. MSM8916/MS=
M8974).
>> >> > > > I have a driver for BAM-DMUX that I hope to finish up and submi=
t soon.
>> >> > > >
>> >> > > > The connection is set up via QMI. The messages are either sent =
via
>> >> > > > a shared RPMSG channel (net/qrtr sockets in Linux) or via stand=
alone
>> >> > > > SMD/RPMSG channels (e.g. "DATA5_CNTL" for QMI and "DATA1" for A=
T).
>> >> > > >
>> >> > > > This gives a lot of possible combinations like BAM-DMUX+RPMSG
>> >> > > > (MSM8916, MSM8974), or IPA+QRTR (SDM845) but also other funny
>> >> > > > combinations like IPA+RPMSG (MSM8994) or BAM-DMUX+QRTR (MSM8937=
).
>> >> > > >
>> >> > > > Simply put, supporting all these in userspace like ModemManager
>> >> > > > is a mess (Aleksander can probably confirm).
>> >> > > > It would be nice if this could be simplified through the WWAN s=
ubsystem.
>> >> > > >
>> >> > > > It's not clear to me if or how well QRTR sockets can be mapped =
to a char
>> >> > > > device for the WWAN subsystem, so for now I'm trying to focus o=
n the
>> >> > > > standalone RPMSG approach (for MSM8916, MSM8974, ...).
>> >> > > > ---
>> >> > > >
>> >> > > > Currently ModemManager uses the RPMSG channels via the rpmsg-ch=
ardev
>> >> > > > (drivers/rpmsg/rpmsg_char.c). It wasn't my idea to use it like =
this,
>> >> > > > I just took that over from someone else. Realistically speaking=
, the
>> >> > > > current approach isn't too different from the UCI "backdoor int=
erface"
>> >> > > > approach that was rejected for MHI...
>> >> > > >
>> >> > > > I kind of expected that I can just trivially copy some code from
>> >> > > > rpmsg_char.c into a WWAN driver since they both end up as a sim=
ple char
>> >> > > > device. But it looks like the abstractions in wwan_core are kin=
d of
>> >> > > > getting in the way here... As far as I can tell, they don't rea=
lly fit
>> >> > > > together with the RPMSG interface.
>> >> > > >
>> >> > > > For example there is rpmsg_send(...) (blocking) and rpmsg_tryse=
nd(...)
>> >> > > > (non-blocking) and even a rpmsg_poll(...) [1] but I don't see a=
 way to
>> >> > > > get notified when the TX queue is full or no longer full so I c=
an call
>> >> > > > wwan_port_txon/off().
>> >> > > >
>> >> > > > Any suggestions or other thoughts?
>> >> > >
>> >> > > It would be indeed nice to get this in the WWAN framework.
>> >> > > I don't know much about rpmsg but I think it is straightforward f=
or
>> >> > > the RX path, the ept_cb can simply forward the buffers to
>> >> > > wwan_port_rx.
>> >> >
>> >> > Right, that part should be straightforward.
>> >> >
>> >> > > For tx, simply call rpmsg_trysend() in the wwan tx
>> >> > > callback and don't use the txon/off helpers. In short, keep it si=
mple
>> >> > > and check if you observe any issues.
>> >> > >
>> >> >
>> >> > I'm not sure that's a good idea. This sounds like exactly the kind =
of
>> >> > thing that might explode later just because I don't manage to get t=
he
>> >> > TX queue full in my tests. In that case, writing to the WWAN char d=
ev
>> >> > would not block, even if O_NONBLOCK is not set.
>> >>=20
>> >> Right, if you think it could be a problem, you can always implement a
>> >> more complex solution like calling rpmsg_send from a
>> >> workqueue/kthread, and only re-enable tx once rpmsg_send returns.
>> >>=20
>> >
>> > I did run into trouble when I tried to stream lots of data into the WW=
AN
>> > char device (e.g. using dd). However, in practice (with ModemManager)=
=20
>> > I did not manage to cause such issues yet. Personally, I think it's
>> > something we should get right, just to avoid trouble later
>> > (like "modem suddenly stops working").
>> >
>> > Right now I extended the WWAN port ops a bit so I tells me if the write
>> > should be non-blocking or blocking and so I can call rpmsg_poll(...).
>> >
>> > But having some sort of workqueue also sounds like it could work quite
>> > well, thanks for the suggestion! Will think about it some more, or
>> > I might post what I have right now so you can take a look.
>>=20
>> How big are those hardware TXQs? Just pushing packets to the hardware
>> until it overflows sounds like a recipe for absolutely terrible
>> bufferbloat... That would be bad!
>>=20
>
> For reference, we're not really talking about "hardware" TXQs here.
> As far as I understand, the RPMSG channels on Qualcomm devices are
> mostly just a firmware convention for communicating between different
> CPUs/DSPs via shared memory.
>
> The packets are copied into some kind of shared FIFO/ring buffer
> per channel, with varying sizes. On my test device, the firmware
> allcates 1024 bytes for the QMI channel and 8192 bytes
> for the AT channel.
>
> I'm not sure how this would cause any kind of overflow/bufferbloat.
> The remote side (e.g. modem DSP) is notified separately for every packet
> that is sent. If we're really writing more quickly than the remote side
> will read, rpmsg_send() will block and therefore the client will
> block as well (since tx was disabled before calling rpmsg_send()).

Hmm, okay, if this is just control channel traffic and the buffers are
no bigger than that maybe this is not such a huge issue. As long as the
client (which I guess is whichever application is trying to control the
modem?) can block and back off, so it won't just keep queuing up
commands faster than the modem can process them...

-Toke


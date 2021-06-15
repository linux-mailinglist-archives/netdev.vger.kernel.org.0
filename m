Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 467593A7996
	for <lists+netdev@lfdr.de>; Tue, 15 Jun 2021 10:54:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231267AbhFOI41 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Jun 2021 04:56:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46050 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231224AbhFOI4Y (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Jun 2021 04:56:24 -0400
Received: from mail-pf1-x434.google.com (mail-pf1-x434.google.com [IPv6:2607:f8b0:4864:20::434])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5222AC0617AF
        for <netdev@vger.kernel.org>; Tue, 15 Jun 2021 01:54:19 -0700 (PDT)
Received: by mail-pf1-x434.google.com with SMTP id g6so12742065pfq.1
        for <netdev@vger.kernel.org>; Tue, 15 Jun 2021 01:54:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=/aLEC/Eln4giYvsqqyo5tdPZgoWGsWwO6Co3KqLksHg=;
        b=UuMVRAwrCB55jyTqSFvvvTageaNk0AetF/r0yfJQoXu/8Mrqf1i62nNXarlrV/qEHf
         BPM97XDgY+dhI5TbjyzsjNhs5tFwvEOShcmOpEL0smav/GRiFunCkbpOodKBNU/Mx9Xo
         xWdn4nnsBnb5RhLmeVu6GcdeEGzyO/JMtRVyK1gvRmu8wQDMmjY6USf5PcBBGixeWJap
         vqJUY3erH2rFGUqXfqEXlHp6HR/YjqjodkvsXGEhUWvhsACBj6FsjX3Sd48V2aK7tfKY
         8RV50Vqc0TLFiNZ4IspsZXLYjHXIeJ+8qGQ4I01OlbaRA6g3SRxpq+LjJz+E2VthG05Q
         iLAA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=/aLEC/Eln4giYvsqqyo5tdPZgoWGsWwO6Co3KqLksHg=;
        b=EL9qPmbZ2xAordW8UF9UmUiX2+G5NRvVzrmJDVkD8jvkVwVCsXbgdvCN0HskGke04r
         KTqhpCE5QzTwhQ8ZvLXH0yqEsIg5UfpvAO0PuA4vtJWeKLO+SS5cNTPLr98D8h8qWo4u
         sa6DkbSOeYFRSbgDHIhwnLat7CXA/gHyKfzIfvQcvgB2yM+E8JGc9Y5EOv0OS0/L2tA+
         AZwMLSHocRgjwYxeWSHXi9i07VIwAdwAkL7pA51IqNkRnV2koMqYPz7UJpi0Zh779TlC
         PcGO20SbdCATs/mqKEVnTmRHdW31cR1O0GGxR0rDDz04iIlGbncVPWHDfLnL/aY8Ubc4
         kfmw==
X-Gm-Message-State: AOAM533vevxC9f5gSrbjTN4uzTuHYOq63G74uX7QbbCOPJ2bpVbuEv9k
        RUvs7Sn8Z6LfkvOVIiZrGDGu15a8JOFiv0FTUH0M/w==
X-Google-Smtp-Source: ABdhPJz21l8uZFSsOqTdlIjSajUk7E1ngZN/73MbuZIeNMJVmNlJP03TlnwuZb8v5DcyAbUDrJIX8HJWhJEeLEpcFek=
X-Received: by 2002:a63:171d:: with SMTP id x29mr12363221pgl.173.1623747258610;
 Tue, 15 Jun 2021 01:54:18 -0700 (PDT)
MIME-Version: 1.0
References: <YLfL9Q+4860uqS8f@gerhold.net> <CAMZdPi9tcye-4P4i0uXZcECJ-Big5T11JdvdXW6k2mEEi9XwyA@mail.gmail.com>
 <YLtDB2Cz5ttewsFu@gerhold.net> <CAMZdPi_-Qa=JnThHs_h-144dAfSAjF5s+QdBawdXZ3kk8Mx8ng@mail.gmail.com>
 <YL364+xK3mE2FU8a@gerhold.net> <87sg1tvryx.fsf@toke.dk> <YL4GiEEcOQC2XrjP@gerhold.net>
 <CAMZdPi-91y+t1bHb+6NY5Dh-xV_yvJTzG65efaSKzyTNsEGBvA@mail.gmail.com> <YL4Vr0mhiOJp8jkT@gerhold.net>
In-Reply-To: <YL4Vr0mhiOJp8jkT@gerhold.net>
From:   Loic Poulain <loic.poulain@linaro.org>
Date:   Tue, 15 Jun 2021 11:03:20 +0200
Message-ID: <CAMZdPi9c9=G_ewmUqZuEpyHpL7LBghDH+zkPgAhpPyS=buKvwQ@mail.gmail.com>
Subject: Re: [RFC] Integrate RPMSG/SMD into WWAN subsystem
To:     Stephan Gerhold <stephan@gerhold.net>
Cc:     =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Aleksander Morgado <aleksander@aleksander.es>,
        Network Development <netdev@vger.kernel.org>,
        linux-remoteproc@vger.kernel.org,
        linux-arm-msm <linux-arm-msm@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Ohad Ben-Cohen <ohad@wizery.com>,
        Mathieu Poirier <mathieu.poirier@linaro.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

HI Stephan,

On Mon, 7 Jun 2021 at 14:49, Stephan Gerhold <stephan@gerhold.net> wrote:
>
> Hi,
>
> On Mon, Jun 07, 2021 at 02:16:10PM +0200, Loic Poulain wrote:
> > On Mon, 7 Jun 2021 at 13:44, Stephan Gerhold <stephan@gerhold.net> wrot=
e:
> > >
> > > On Mon, Jun 07, 2021 at 01:23:18PM +0200, Toke H=C3=B8iland-J=C3=B8rg=
ensen wrote:
> > > > Stephan Gerhold <stephan@gerhold.net> writes:
> > > > > On Mon, Jun 07, 2021 at 11:27:07AM +0200, Loic Poulain wrote:
> > > > >> On Sat, 5 Jun 2021 at 11:25, Stephan Gerhold <stephan@gerhold.ne=
t> wrote:
> > > > >> > On Fri, Jun 04, 2021 at 11:11:45PM +0200, Loic Poulain wrote:
> > > > >> > > On Wed, 2 Jun 2021 at 20:20, Stephan Gerhold <stephan@gerhol=
d.net> wrote:
> > > > >> > > > I've been thinking about creating some sort of "RPMSG" dri=
ver for the
> > > > >> > > > new WWAN subsystem; this would be used as a QMI/AT channel=
 to the
> > > > >> > > > integrated modem on some older Qualcomm SoCs such as MSM89=
16 and MSM8974.
> > > > >> > > >
> > > > >> > > > It's easy to confuse all the different approaches that Qua=
lcomm has to
> > > > >> > > > talk to their modems, so I will first try to briefly give =
an overview
> > > > >> > > > about those that I'm familiar with:
> > > > >> > > >
> > > > >> > > > ---
> > > > >> > > > There is USB and MHI that are mainly used to talk to "exte=
rnal" modems.
> > > > >> > > >
> > > > >> > > > For the integrated modems in many Qualcomm SoCs there is t=
ypically
> > > > >> > > > a separate control and data path. They are not really rela=
ted to each
> > > > >> > > > other (e.g. currently no common parent device in sysfs).
> > > > >> > > >
> > > > >> > > > For the data path (network interface) there is "IPA" (driv=
ers/net/ipa)
> > > > >> > > > on newer SoCs or "BAM-DMUX" on some older SoCs (e.g. MSM89=
16/MSM8974).
> > > > >> > > > I have a driver for BAM-DMUX that I hope to finish up and =
submit soon.
> > > > >> > > >
> > > > >> > > > The connection is set up via QMI. The messages are either =
sent via
> > > > >> > > > a shared RPMSG channel (net/qrtr sockets in Linux) or via =
standalone
> > > > >> > > > SMD/RPMSG channels (e.g. "DATA5_CNTL" for QMI and "DATA1" =
for AT).
> > > > >> > > >
> > > > >> > > > This gives a lot of possible combinations like BAM-DMUX+RP=
MSG
> > > > >> > > > (MSM8916, MSM8974), or IPA+QRTR (SDM845) but also other fu=
nny
> > > > >> > > > combinations like IPA+RPMSG (MSM8994) or BAM-DMUX+QRTR (MS=
M8937).
> > > > >> > > >
> > > > >> > > > Simply put, supporting all these in userspace like ModemMa=
nager
> > > > >> > > > is a mess (Aleksander can probably confirm).
> > > > >> > > > It would be nice if this could be simplified through the W=
WAN subsystem.
> > > > >> > > >
> > > > >> > > > It's not clear to me if or how well QRTR sockets can be ma=
pped to a char
> > > > >> > > > device for the WWAN subsystem, so for now I'm trying to fo=
cus on the
> > > > >> > > > standalone RPMSG approach (for MSM8916, MSM8974, ...).
> > > > >> > > > ---
> > > > >> > > >
> > > > >> > > > Currently ModemManager uses the RPMSG channels via the rpm=
sg-chardev
> > > > >> > > > (drivers/rpmsg/rpmsg_char.c). It wasn't my idea to use it =
like this,
> > > > >> > > > I just took that over from someone else. Realistically spe=
aking, the
> > > > >> > > > current approach isn't too different from the UCI "backdoo=
r interface"
> > > > >> > > > approach that was rejected for MHI...
> > > > >> > > >
> > > > >> > > > I kind of expected that I can just trivially copy some cod=
e from
> > > > >> > > > rpmsg_char.c into a WWAN driver since they both end up as =
a simple char
> > > > >> > > > device. But it looks like the abstractions in wwan_core ar=
e kind of
> > > > >> > > > getting in the way here... As far as I can tell, they don'=
t really fit
> > > > >> > > > together with the RPMSG interface.
> > > > >> > > >
> > > > >> > > > For example there is rpmsg_send(...) (blocking) and rpmsg_=
trysend(...)
> > > > >> > > > (non-blocking) and even a rpmsg_poll(...) [1] but I don't =
see a way to
> > > > >> > > > get notified when the TX queue is full or no longer full s=
o I can call
> > > > >> > > > wwan_port_txon/off().
> > > > >> > > >
> > > > >> > > > Any suggestions or other thoughts?
> > > > >> > >
> > > > >> > > It would be indeed nice to get this in the WWAN framework.
> > > > >> > > I don't know much about rpmsg but I think it is straightforw=
ard for
> > > > >> > > the RX path, the ept_cb can simply forward the buffers to
> > > > >> > > wwan_port_rx.
> > > > >> >
> > > > >> > Right, that part should be straightforward.
> > > > >> >
> > > > >> > > For tx, simply call rpmsg_trysend() in the wwan tx
> > > > >> > > callback and don't use the txon/off helpers. In short, keep =
it simple
> > > > >> > > and check if you observe any issues.
> > > > >> > >
> > > > >> >
> > > > >> > I'm not sure that's a good idea. This sounds like exactly the =
kind of
> > > > >> > thing that might explode later just because I don't manage to =
get the
> > > > >> > TX queue full in my tests. In that case, writing to the WWAN c=
har dev
> > > > >> > would not block, even if O_NONBLOCK is not set.
> > > > >>
> > > > >> Right, if you think it could be a problem, you can always implem=
ent a
> > > > >> more complex solution like calling rpmsg_send from a
> > > > >> workqueue/kthread, and only re-enable tx once rpmsg_send returns=
.
> > > > >>
> > > > >
> > > > > I did run into trouble when I tried to stream lots of data into t=
he WWAN
> > > > > char device (e.g. using dd). However, in practice (with ModemMana=
ger)
> > > > > I did not manage to cause such issues yet. Personally, I think it=
's
> > > > > something we should get right, just to avoid trouble later
> > > > > (like "modem suddenly stops working").
> > > > >
> > > > > Right now I extended the WWAN port ops a bit so I tells me if the=
 write
> > > > > should be non-blocking or blocking and so I can call rpmsg_poll(.=
..).
> >
> > OK, but note that poll seems to be an optional rpmsg ops, rpmsg_poll
> > can be a no-op and so would not guarantee that EPOLL_OUT will ever be
> > set.
> >
>
> Wouldn't that be more a limitation of the driver that provides the rpmsg
> ops then? If rpmsg_send(...) may block, it should also be possible to
> implement rpmsg_poll(...). Right now my implementation basically behaves
> mostly like the existing rpmsg-char. That's what has been used on
> several devices for more than a year and it works quite well.
>
> Granted, so far testing was mostly done with the "qcom_smd" RPMSG driver
> (which is likely going to be the primary use case for my driver for now).
> This one also happens to be the only one that implements rpmsg_poll()
> at the moment...
>
> I asked some other people to test it for AT messages with "glink" on
> newer Qualcomm SoCs and that doesn't work that well yet. However, as far
> as I can tell most of the trouble seems to be caused by various strange
> bugs in the "glink" driver.
> (See drivers/rpmsg for the drivers I'm referring to...)
>
> ---
>
> One of the main potential problems I see with some kind of workqueue
> approach is that all writes would seemingly succeed for the client.
> When the extra thread is done with rpmsg_send(...) we will have already
> returned from the char dev write(...) syscall, without a way to report
> the error. Perhaps that's unlikely though and we don't need to worry
> about that too much?
>
> I'm not really sure which one of the solution is best at the end.
> I think it doesn't make too much of a difference at the end, both can
> work well and both have some advantages/disadvantages in certain fairly
> unlikely situations.

Yes, feel free to submit the series for review.

Regards,
Loic

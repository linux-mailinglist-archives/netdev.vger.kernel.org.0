Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5188C2318E8
	for <lists+netdev@lfdr.de>; Wed, 29 Jul 2020 07:10:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726724AbgG2FKF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Jul 2020 01:10:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58516 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726054AbgG2FKE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Jul 2020 01:10:04 -0400
Received: from mail-qk1-x742.google.com (mail-qk1-x742.google.com [IPv6:2607:f8b0:4864:20::742])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4D838C061794;
        Tue, 28 Jul 2020 22:10:04 -0700 (PDT)
Received: by mail-qk1-x742.google.com with SMTP id g26so21139476qka.3;
        Tue, 28 Jul 2020 22:10:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=UN7pZpowLMvi6pmc6rfEpBFGli4hSvscFcOgI713qB8=;
        b=X/9Mcp1m87pWEcTQsafKLpx0CUm5AzMOXKhI+nCH6I3oqLcfpxKa6hrPq5pEzzuLBN
         nZcLv38gPXZXxR4aPJeqx7ld3Ezr7B/KZskTMYlXflX7ls6oyB/CvPA/eaFSs6RghIef
         tjLnC/arL0c1sOGiuwknIwKVlJsH0dL+gC3NeF7jHyxNb8MjCZEjS1r43aafQAYN649V
         v6GGezDXvqyy1uz4fKQh00lUoGouprlWz6ltdx5qpvNZqryh6l5agozL3c+sQlsBn9Yn
         C7boNqeKWxqNVyYRpnzKxbvwEzXlFOdOb5pOYLgAO17V6L6syiRVJ6dIFheb6fdYhER1
         K8iA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=UN7pZpowLMvi6pmc6rfEpBFGli4hSvscFcOgI713qB8=;
        b=cCrVpYW3yg8Nr/3YPmwjG1EQZtht4OrfBe+s9UVJjSL0rTNhoVhTUnoJaqnk9eyTx0
         JYt1kRtlPPryNB9nDXXen+2k1f4VP/OLYoqfxSR33+AwafP+xUL4uKXHMgwE7BwHjkvH
         tok5u4g78UlwQCKQLAq0tplgpIsPI0r+8r3uHSlhd1gFEa3XKFxtB7/lk0mqtFiAXKIC
         zBB3cR2InAOcxQJpJXU6RNp7IGJoM9wjaytV1MHx3BvLVt85Gf1nq15jrOrSNjCB4Xn3
         mQy4i4mCASRZU64tA4TOtRXWKZ3vf3pGYJ90A3/gnPTX3i5F6sDSaZKxtS5CFWZzirDD
         iYHA==
X-Gm-Message-State: AOAM533lJHGzYMiU0/HYBETLKqU+yTOTz9pT56rfgKecg1SPtbXXV3jl
        2Vtj4z+tPgghtQuFpbAf0JW4mwftVEbJENNNgV3Wv4ZOH1E=
X-Google-Smtp-Source: ABdhPJwrtrqs73dy2ybvIjtzhRkFh/142rj48vXRTQ4kF8VfCu/1PNcx8rtL07iata7b8RUQkksBCL7Ox4fVZwWV2KE=
X-Received: by 2002:a05:620a:4c:: with SMTP id t12mr6006110qkt.449.1595999403429;
 Tue, 28 Jul 2020 22:10:03 -0700 (PDT)
MIME-Version: 1.0
References: <20200727233431.4103-1-bimmy.pujari@intel.com> <CAEf4BzYMaU14=5bzzasAANJW7w2pNxHZOMDwsDF_btVWvf9ADA@mail.gmail.com>
 <CANP3RGd2fKh7qXyWVeqPM8nVKZRtJrJ65apmGF=w9cwXy6TReQ@mail.gmail.com>
 <CAEf4BzaiCZ3rOBc0EXuLUuWh9m5QXv=51Aoyi5OHwb6T11nnjw@mail.gmail.com> <BYAPR11MB3752ECD1819CE1B987D0B07288730@BYAPR11MB3752.namprd11.prod.outlook.com>
In-Reply-To: <BYAPR11MB3752ECD1819CE1B987D0B07288730@BYAPR11MB3752.namprd11.prod.outlook.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Tue, 28 Jul 2020 22:09:52 -0700
Message-ID: <CAEf4Bzb9KA=mzYo_x42ExRoZjm=dF6up1DxrUL_eqkDYs9+UUg@mail.gmail.com>
Subject: Re: [PATCH] bpf: Add bpf_ktime_get_real_ns
To:     "Nikravesh, Ashkan" <ashkan.nikravesh@intel.com>
Cc:     =?UTF-8?Q?Maciej_=C5=BBenczykowski?= <maze@google.com>,
        "Pujari, Bimmy" <bimmy.pujari@intel.com>,
        bpf <bpf@vger.kernel.org>, Networking <netdev@vger.kernel.org>,
        "mchehab@kernel.org" <mchehab@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin Lau <kafai@fb.com>,
        "Alvarez, Daniel A" <daniel.a.alvarez@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jul 28, 2020 at 1:00 PM Nikravesh, Ashkan
<ashkan.nikravesh@intel.com> wrote:
>
>
>
> ________________________________
> From: Andrii Nakryiko <andrii.nakryiko@gmail.com>
> Sent: Tuesday, July 28, 2020 11:28 AM
> To: Maciej =C5=BBenczykowski <maze@google.com>
> Cc: Pujari, Bimmy <bimmy.pujari@intel.com>; bpf <bpf@vger.kernel.org>; Ne=
tworking <netdev@vger.kernel.org>; mchehab@kernel.org <mchehab@kernel.org>;=
 Alexei Starovoitov <ast@kernel.org>; Daniel Borkmann <daniel@iogearbox.net=
>; Martin Lau <kafai@fb.com>; Nikravesh, Ashkan <ashkan.nikravesh@intel.com=
>
> Subject: Re: [PATCH] bpf: Add bpf_ktime_get_real_ns
>
> On Tue, Jul 28, 2020 at 10:57 AM Maciej =C5=BBenczykowski <maze@google.co=
m> wrote:
> >
> > On Mon, Jul 27, 2020 at 10:01 PM Andrii Nakryiko <andrii.nakryiko@gmail=
.com> wrote:
> >>
> >> On Mon, Jul 27, 2020 at 4:35 PM <bimmy.pujari@intel.com> wrote:
> >> >
> >> > From: Ashkan Nikravesh <ashkan.nikravesh@intel.com>
> >> >
> >> > The existing bpf helper functions to get timestamp return the time
> >> > elapsed since system boot. This timestamp is not particularly useful
> >> > where epoch timestamp is required or more than one server is involve=
d
> >> > and time sync is required. Instead, you want to use CLOCK_REALTIME,
> >> > which provides epoch timestamp.
> >> > Hence add bfp_ktime_get_real_ns() based around CLOCK_REALTIME.
> >> >
> >>
> >> This doesn't seem like a good idea.
> >
> >
> > I disagree.
> >
> >>
> >> With time-since-boot it's very
> >> easy to translate timestamp into a real time on the host.
> >
> >
> > While it's easy to do, it's annoying, because you need to hardcode the =
offset into the bpf program
> > (which has security implications) or use another bpf array lookup/read =
(perf implications).
>
> There is no array lookup/read if you are using a global variable for this=
.
>
> [AN] Yes, as Maciej mentioned, converting since-boot-time to epoch in ker=
nel has performance implication when the epoch timestamp/offset is provided=
 by user-space and hard coding the offset doesn't seem to be a good idea. I=
 am not sure what you refer by using a global variable.
>

This is global variable:


/* this gets initialized from user-space,
 * see tools/bpf/runqslower for examples,
 * or many of selftests doing this
 */
const volatile __u64 boot_to_wall_off_ns =3D 0;

SEC("...")
int my_handler(...)
{
    u64 wallclock_ns =3D bpf_ktime_get_boot_ns() + boot_to_wall_off_ns;

    ...
}

There is no map lookup involved, boot_to_wall_off_ns is accessed directly.

> >
> >>
> >> Having
> >> get_real_ns() variant might just encourage people to assume precise
> >> wall-clock timestamps that can be compared between within or even
> >> across different hosts.
> >
> >
> > In some environments they *can*.  Within a datacenter it is pretty comm=
on
> > to have extremely tightly synchronized clocks across thousands of machi=
nes.
>
> In some, yes, which also means that in some other they can't. So I'm
> still worried about misuses of REALCLOCK, within (internal daemons
> within the company) our outside (BCC tools and alike) of data centers.
> Especially if people will start using it to measure elapsed time
> between events. I'd rather not have to explain over and over again
> that REALCLOCK is not for measuring passage of time.
>
> [AN] Time synchronization fidelity or accuracy requirement is driven by t=
he use-case.  A time synchronization is not the question here, you assume t=
hat your time synchronization accuracy is sufficient for your use-case.  Yo=
u can always aim for better accuracy. For instance, the proposed helper fun=
ction can be used as a mechanism to communicate the timestamp. For this, on=
e use-case could be to measure e2e latency by adding egress timestamp to th=
e packet. To do that, we sync the clock across all the hosts using NTP with=
in a data center.

You are talking about use cases where you guys are conscious about
implications of using wallclock timestamps, and I'm talking about
general BPF users that might not know about any of these nuances, but
seeing bpf_ktime_get_real_ns() would be happy that it's "real" and
would just use it for everything.

> For instance, the proposed helper function can be used as a mechanism to =
communicate the timestamp.

See example above, can `bpf_ktime_get_boot_ns() + boot_to_wall_off_ns`
be used similarly for cross-host timestamp comparison?

>
> >
> >>
> >> REALCLOCK can jump around, you can get
> >> duplicate timestamps, timestamps can go back in time, etc.
> >
> >
> > That's only true if you allow it to.  On a server machine, once it's bo=
oted
>
> Right, but BPF is used so widely that it will be true at least in some ca=
ses.
>
> > up and time is synchronized, it no longer jumps around, only the freque=
ncy
> > is slowly adjusted to keep things in sync.
> >
> >>
> >> It's just not a good way to measure time.
> >
> >
> > It doesn't change the fact that some packets/protocols include real wor=
ld timestamps.
> > We already have the since-boot time fetchers, so this doesn't prevent y=
ou from
> > using that - if that is what you want.
> >
> > Also one thing to remember is that a lot of time you only need ~1s prec=
ision.
> > In which case 'real' can simply be a lot easier to deal with.
> >
>
> Again, I'm worried about ensuing confusion by users trying to pick
> which variant to use. I'm not worried about those who understand the
> difference and can pick the right one for their needs, I'm worried
> about those that don't even give it a second thought. Given it's
> rather simple to convert boot time into wall-clock time, it doesn't
> seem like a necessary addition.
>
> >>
> >> Also, you mention the need for time sync. It's an extremely hard thing
> >> to have synchronized time between two different physical hosts, as
> >> anyone that has dealt with distributed systems will attest. Having
> >> this helper will just create a dangerous illusion that it is possible
> >> and will just cause more problems down the road for people.
> >
> >
> > It is possible.  But yes.  It is very very hard.
> > You can read up on Google TrueTime as an example real world implementat=
ion.
>
> Thank you, I did, though quite a while ago. Notice, I didn't say it's
> impossible, right? ;) But then Google TrueTime provides a range of
> time within confidence intervals, not a single seemingly-deterministic
> timestamp. And it needs custom hardware, so it's not realistic to
> expect to have it everywhere :)
>
> >
> >>
> >>
> >> > Signed-off-by: Ashkan Nikravesh <ashkan.nikravesh@intel.com>
> >> > Signed-off-by: Bimmy Pujari <bimmy.pujari@intel.com>
> >> > ---
> >> >  drivers/media/rc/bpf-lirc.c    |  2 ++
> >> >  include/linux/bpf.h            |  1 +
> >> >  include/uapi/linux/bpf.h       |  7 +++++++
> >> >  kernel/bpf/core.c              |  1 +
> >> >  kernel/bpf/helpers.c           | 14 ++++++++++++++
> >> >  kernel/trace/bpf_trace.c       |  2 ++
> >> >  tools/include/uapi/linux/bpf.h |  7 +++++++
> >> >  7 files changed, 34 insertions(+)
> >>
> >> [...]
> >
> >
> > Maciej =C5=BBenczykowski, Kernel Networking Developer @ Google

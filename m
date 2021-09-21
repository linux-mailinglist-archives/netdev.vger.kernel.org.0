Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 08F18413D76
	for <lists+netdev@lfdr.de>; Wed, 22 Sep 2021 00:20:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234491AbhIUWVx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Sep 2021 18:21:53 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:32587 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232122AbhIUWVw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Sep 2021 18:21:52 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1632262823;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=GP/8rawFN2FuLpfJmGhp4GLpl36vpVy/O8mL8kV6OEc=;
        b=cUwclaMyPmq5BKQgbc+aYOvt19yq8wtVtaktG4HGieZC4R8+dKGBvsrYAVdRx00jfx+Oja
        RzEPh8lZguvHsNvuusCMGkozLRlWYZiTAEbstRfgDztMklevhuoqOJDI5WsPLWxNE3ZHAZ
        hlU++U88Rb7HkEjbccfHKBUzIu7mxKg=
Received: from mail-ed1-f72.google.com (mail-ed1-f72.google.com
 [209.85.208.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-458-xFU4244YMT2DVWMjV0Bo4A-1; Tue, 21 Sep 2021 18:20:22 -0400
X-MC-Unique: xFU4244YMT2DVWMjV0Bo4A-1
Received: by mail-ed1-f72.google.com with SMTP id c7-20020a05640227c700b003d27f41f1d4so605229ede.16
        for <netdev@vger.kernel.org>; Tue, 21 Sep 2021 15:20:21 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version:content-transfer-encoding;
        bh=GP/8rawFN2FuLpfJmGhp4GLpl36vpVy/O8mL8kV6OEc=;
        b=Q1wG+c4HmyUJ0uYHXPCgNNDQHmpYonPHeO7/FhI649tRo22JjZammPYsC014NQBVb5
         qYu2D2RckBUTifV3UUTg7lMBMKzgsPPmNbTRlPLiCXwmM81LzX17mkD9Rr1NKOeWuQLr
         3jRXIvsP8aFeM0BvB4a02MDJkxDAiKiNwQ9j7hpGZk3iFMSf8II1E6msL8rUlDSGjsqR
         vG97LSp/UXh3ovu0GSvq6dDREUuqPl1h02X+hlqhzEpfPHHg4HuLCKSS2Xsrll1e7oi1
         2pa+tm5QrZyHjUaIiMOyo9shJffOMB4I2Zp57jzr7ElncrLTnp3DkaqPIk7zbGoTH7WX
         BX5A==
X-Gm-Message-State: AOAM530tk58IpHvdMzgGm3j1xPrHasuu8/1+hiJy5wwGYXxj3sp1Kx0s
        KiKPDRu7FhDd8gvTjYTfC5L6vy19Qp4NQWj0SoslbVu00SOBV586GzFrp9OnZpfp2CWv7O3e1it
        apmDi4FN5ymTm0SjT
X-Received: by 2002:a50:9d83:: with SMTP id w3mr25767531ede.305.1632262820740;
        Tue, 21 Sep 2021 15:20:20 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzwF21WnRB6xs5VAJXEwXRbEaPKbBEFm6epyLjAB/FTUq7RuMnevXxzKBnDPbICaP3qEYBkjg==
X-Received: by 2002:a50:9d83:: with SMTP id w3mr25767494ede.305.1632262820319;
        Tue, 21 Sep 2021 15:20:20 -0700 (PDT)
Received: from alrua-x1.borgediget.toke.dk ([45.145.92.2])
        by smtp.gmail.com with ESMTPSA id b3sm112274edx.55.2021.09.21.15.20.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 21 Sep 2021 15:20:19 -0700 (PDT)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id 37C6918034A; Wed, 22 Sep 2021 00:20:19 +0200 (CEST)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     Zvi Effron <zeffron@riotgames.com>,
        Lorenz Bauer <lmb@cloudflare.com>,
        Lorenzo Bianconi <lbianconi@redhat.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        John Fastabend <john.fastabend@gmail.com>,
        Network Development <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>
Subject: Re: Redux: Backwards compatibility for XDP multi-buff
In-Reply-To: <CAADnVQKi_u6yZnsxEagNTv-XWXtLPpXwURJH0FnGFRgt6weiww@mail.gmail.com>
References: <87o88l3oc4.fsf@toke.dk>
 <CAC1LvL1xgFMjjE+3wHH79_9rumwjNqDAS2Yg2NpSvmewHsYScA@mail.gmail.com>
 <87ilyt3i0y.fsf@toke.dk>
 <CAADnVQKi_u6yZnsxEagNTv-XWXtLPpXwURJH0FnGFRgt6weiww@mail.gmail.com>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Wed, 22 Sep 2021 00:20:19 +0200
Message-ID: <87czp13718.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Alexei Starovoitov <alexei.starovoitov@gmail.com> writes:

> On Tue, Sep 21, 2021 at 11:23 AM Toke H=C3=B8iland-J=C3=B8rgensen <toke@r=
edhat.com> wrote:
>>
>> Zvi Effron <zeffron@riotgames.com> writes:
>>
>> > On Tue, Sep 21, 2021 at 9:06 AM Toke H=C3=B8iland-J=C3=B8rgensen <toke=
@redhat.com> wrote:
>> >>
>> >> Hi Lorenz (Cc. the other people who participated in today's discussio=
n)
>> >>
>> >> Following our discussion at the LPC session today, I dug up my previo=
us
>> >> summary of the issue and some possible solutions[0]. Seems no on
>> >> actually replied last time, which is why we went with the "do nothing"
>> >> approach, I suppose. I'm including the full text of the original email
>> >> below; please take a look, and let's see if we can converge on a
>> >> consensus here.
>> >>
>> >> First off, a problem description: If an existing XDP program is expos=
ed
>> >> to an xdp_buff that is really a multi-buffer, while it will continue =
to
>> >> run, it may end up with subtle and hard-to-debug bugs: If it's parsing
>> >> the packet it'll only see part of the payload and not be aware of that
>> >> fact, and if it's calculating the packet length, that will also only =
be
>> >> wrong (only counting the first fragment).
>> >>
>> >> So what to do about this? First of all, to do anything about it, XDP
>> >> programs need to be able to declare themselves "multi-buffer aware" (=
but
>> >> see point 1 below). We could try to auto-detect it in the verifier by
>> >> which helpers the program is using, but since existing programs could=
 be
>> >> perfectly happy to just keep running, it probably needs to be somethi=
ng
>> >> the program communicates explicitly. One option is to use the
>> >> expected_attach_type to encode this; programs can then declare it in =
the
>> >> source by section name, or the userspace loader can set the type for
>> >> existing programs if needed.
>> >>
>> >> With this, the kernel will know if a given XDP program is multi-buff
>> >> aware and can decide what to do with that information. For this we ca=
me
>> >> up with basically three options:
>> >>
>> >> 1. Do nothing. This would make it up to users / sysadmins to avoid
>> >>    anything breaking by manually making sure to not enable multi-buff=
er
>> >>    support while loading any XDP programs that will malfunction if
>> >>    presented with an mb frame. This will probably break in interesting
>> >>    ways, but it's nice and simple from an implementation PoV. With th=
is
>> >>    we don't need the declaration discussed above either.
>> >>
>> >> 2. Add a check at runtime and drop the frames if they are mb-enabled =
and
>> >>    the program doesn't understand it. This is relatively simple to
>> >>    implement, but it also makes for difficult-to-understand issues (w=
hy
>> >>    are my packets suddenly being dropped?), and it will incur runtime
>> >>    overhead.
>> >>
>> >> 3. Reject loading of programs that are not MB-aware when running in an
>> >>    MB-enabled mode. This would make things break in more obvious ways,
>> >>    and still allow a userspace loader to declare a program "MB-aware"=
 to
>> >>    force it to run if necessary. The problem then becomes at what lev=
el
>> >>    to block this?
>> >>
>> >
>> > I think there's another potential problem with this as well: what happ=
ens to
>> > already loaded programs that are not MB-aware? Are they forcibly unloa=
ded?
>>
>> I'd say probably the opposite: You can't toggle whatever switch we end
>> up with if there are any non-MB-aware programs (you'd have to unload
>> them first)...
>>
>> >>    Doing this at the driver level is not enough: while a particular
>> >>    driver knows if it's running in multi-buff mode, we can't know for
>> >>    sure if a particular XDP program is multi-buff aware at attach tim=
e:
>> >>    it could be tail-calling other programs, or redirecting packets to
>> >>    another interface where it will be processed by a non-MB aware
>> >>    program.
>> >>
>> >>    So another option is to make it a global toggle: e.g., create a new
>> >>    sysctl to enable multi-buffer. If this is set, reject loading any =
XDP
>> >>    program that doesn't support multi-buffer mode, and if it's unset,
>> >>    disable multi-buffer mode in all drivers. This will make it explic=
it
>> >>    when the multi-buffer mode is used, and prevent any accidental sub=
tle
>> >>    malfunction of existing XDP programs. The drawback is that it's a
>> >>    mode switch, so more configuration complexity.
>> >>
>> >
>> > Could we combine the last two bits here into a global toggle that does=
n't
>> > require a sysctl? If any driver is put into multi-buffer mode, then th=
e system
>> > switches to requiring all programs be multi-buffer? When the last mult=
i-buffer
>> > enabled driver switches out of multi-buffer, remove the system-wide
>> > restriction?
>>
>> Well, the trouble here is that we don't necessarily have an explicit
>> "multi-buf mode" for devices. For instance, you could raise the MTU of a
>> device without it necessarily involving any XDP multi-buffer stuff (if
>> you're not running XDP on that device). So if we did turn "raising the
>> MTU" into such a mode switch, we would end up blocking any MTU changes
>> if any XDP programs are loaded. Or having an MTU change cause a
>> force-unload of all XDP programs.
>
> MTU change that bumps driver into multi-buf mode or enable
> the header split that also bumps it into multi-buf mode
> probably shouldn't be allowed when non-mb aware xdp prog is attached.
> That would be the simplest and least surprising behavior.
> Force unload could cause security issues.

Yeah, I agree, force-unload is not a good solution - I mostly mentioned
it for completeness.

I think it would be fine for a driver to disallow config changes if a
non-mb-aware program is loaded; that basically amounts to the checks
drivers do already if an XDP-program is loaded, so we could just keep
those around for the non-mb-case.

>> Neither of those are desirable outcomes, I think; and if we add a
>> separate "XDP multi-buff" switch, we might as well make it system-wide?
>
> If we have an internal flag 'this driver supports multi-buf xdp' cannot we
> make xdp_redirect to linearize in case the packet is being redirected
> to non multi-buf aware driver (potentially with corresponding non mb awar=
e xdp
> progs attached) from mb aware driver?

Hmm, the assumption that XDP frames take up at most one page has been
fundamental from the start of XDP. So what does linearise mean in this
context? If we get a 9k packet, should we dynamically allocate a
multi-page chunk of contiguous memory and copy the frame into that, or
were you thinking something else?

-Toke


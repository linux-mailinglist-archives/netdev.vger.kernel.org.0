Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B5FAB413DD8
	for <lists+netdev@lfdr.de>; Wed, 22 Sep 2021 01:10:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229849AbhIUXLy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Sep 2021 19:11:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44418 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229801AbhIUXLs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Sep 2021 19:11:48 -0400
Received: from mail-ed1-x532.google.com (mail-ed1-x532.google.com [IPv6:2a00:1450:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6DDF8C061575
        for <netdev@vger.kernel.org>; Tue, 21 Sep 2021 16:10:19 -0700 (PDT)
Received: by mail-ed1-x532.google.com with SMTP id eg28so2620126edb.1
        for <netdev@vger.kernel.org>; Tue, 21 Sep 2021 16:10:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=riotgames.com; s=riotgames;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=6P3jIQG3qIv2oEfSozY9lMCq1e+rjwzC5dNVLEXquuk=;
        b=OwihEpJWaBVDq6N+ZTtLdyYhc/vRhN23Mqm1zH1SejJnhatz7ZI33TjlLT2fJtTra4
         TdWHEThPjzzvX9boLSwW1pR/obMUOYkTUZWHJ/M4WaqrJYGrbaNPxbgxKuMHWw836kqi
         1pXqlcENFu7DYCNwvEhOGAnjS81XEZ2DJgGp8=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=6P3jIQG3qIv2oEfSozY9lMCq1e+rjwzC5dNVLEXquuk=;
        b=jXle5HzmgdSxGo6gDJ8H26LUHcnQVr8nWIjdBpuC+gnDWyxiPeUqw/hNmbsh644j97
         zxDqK1rM9ixvdzApU6ZwcOIaLwm9LVhUJW3TCr2hPxhYn3ePN3qhpgXanhMMS7fKNxGd
         TDp6a8uq3VN6AZH94nmXpgzhbgCNK4x4F/+y3TtFqHeeAXsLrBdvJhQP48g8seYwDEu+
         UYx7CEJ7zc6OqJqZIsl0BpQwkQDu+R/iC35Nn0TLYwGZgtJW/tQSwW1FTWVrs2menUIN
         9XuIbqIGCYka1afI6tXcZd7c38cztdOM63nk7+DBwaSNAF21yAonCStcWTjYG8UOGkBM
         OqtQ==
X-Gm-Message-State: AOAM533RfjU/VCNHaXlVMmo2YNzxKVj/XIrwtG5uTwx4NtjpRrDZW4/2
        7ukmBT8vaQdZm0EEUjBN9PeYcWRJzcNR1/YSR3IicLt2QOSKAQD+
X-Google-Smtp-Source: ABdhPJwtBC1gS0LTuqrESz7jIY7fsHnmocIQwJCkNNUFI1cNXxJlIShr4MRfgfwvXqDLt5hPXZrDInQ1OGAGRIprp3k=
X-Received: by 2002:a17:906:7f01:: with SMTP id d1mr37935423ejr.318.1632265817711;
 Tue, 21 Sep 2021 16:10:17 -0700 (PDT)
MIME-Version: 1.0
References: <87o88l3oc4.fsf@toke.dk> <CAC1LvL1xgFMjjE+3wHH79_9rumwjNqDAS2Yg2NpSvmewHsYScA@mail.gmail.com>
 <87ilyt3i0y.fsf@toke.dk> <CAC1LvL3yQd_T5srJb78rGxv8YD-QND2aRgJ-p5vOQkbvrwJWSw@mail.gmail.com>
 <87fstx37bn.fsf@toke.dk>
In-Reply-To: <87fstx37bn.fsf@toke.dk>
From:   Zvi Effron <zeffron@riotgames.com>
Date:   Tue, 21 Sep 2021 16:10:06 -0700
Message-ID: <CAC1LvL1VArVCN4DoEDBReSPsALFtdpYVLVzzzA4wWa4DDYzCUw@mail.gmail.com>
Subject: Re: Redux: Backwards compatibility for XDP multi-buff
To:     =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>
Cc:     Lorenz Bauer <lmb@cloudflare.com>,
        Lorenzo Bianconi <lbianconi@redhat.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        John Fastabend <john.fastabend@gmail.com>,
        netdev@vger.kernel.org, bpf <bpf@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Sep 21, 2021 at 3:14 PM Toke H=C3=B8iland-J=C3=B8rgensen <toke@redh=
at.com> wrote:
>
> Zvi Effron <zeffron@riotgames.com> writes:
>
> > On Tue, Sep 21, 2021 at 11:23 AM Toke H=C3=B8iland-J=C3=B8rgensen <toke=
@redhat.com> wrote:
> >>
> >> Zvi Effron <zeffron@riotgames.com> writes:
> >>
> >> > On Tue, Sep 21, 2021 at 9:06 AM Toke H=C3=B8iland-J=C3=B8rgensen <to=
ke@redhat.com> wrote:
> >> >>
> >> >> Hi Lorenz (Cc. the other people who participated in today's discuss=
ion)
> >> >>
> >> >> Following our discussion at the LPC session today, I dug up my prev=
ious
> >> >> summary of the issue and some possible solutions[0]. Seems no on
> >> >> actually replied last time, which is why we went with the "do nothi=
ng"
> >> >> approach, I suppose. I'm including the full text of the original em=
ail
> >> >> below; please take a look, and let's see if we can converge on a
> >> >> consensus here.
> >> >>
> >> >> First off, a problem description: If an existing XDP program is exp=
osed
> >> >> to an xdp_buff that is really a multi-buffer, while it will continu=
e to
> >> >> run, it may end up with subtle and hard-to-debug bugs: If it's pars=
ing
> >> >> the packet it'll only see part of the payload and not be aware of t=
hat
> >> >> fact, and if it's calculating the packet length, that will also onl=
y be
> >> >> wrong (only counting the first fragment).
> >> >>
> >> >> So what to do about this? First of all, to do anything about it, XD=
P
> >> >> programs need to be able to declare themselves "multi-buffer aware"=
 (but
> >> >> see point 1 below). We could try to auto-detect it in the verifier =
by
> >> >> which helpers the program is using, but since existing programs cou=
ld be
> >> >> perfectly happy to just keep running, it probably needs to be somet=
hing
> >> >> the program communicates explicitly. One option is to use the
> >> >> expected_attach_type to encode this; programs can then declare it i=
n the
> >> >> source by section name, or the userspace loader can set the type fo=
r
> >> >> existing programs if needed.
> >> >>
> >> >> With this, the kernel will know if a given XDP program is multi-buf=
f
> >> >> aware and can decide what to do with that information. For this we =
came
> >> >> up with basically three options:
> >> >>
> >> >> 1. Do nothing. This would make it up to users / sysadmins to avoid
> >> >>    anything breaking by manually making sure to not enable multi-bu=
ffer
> >> >>    support while loading any XDP programs that will malfunction if
> >> >>    presented with an mb frame. This will probably break in interest=
ing
> >> >>    ways, but it's nice and simple from an implementation PoV. With =
this
> >> >>    we don't need the declaration discussed above either.
> >> >>
> >> >> 2. Add a check at runtime and drop the frames if they are mb-enable=
d and
> >> >>    the program doesn't understand it. This is relatively simple to
> >> >>    implement, but it also makes for difficult-to-understand issues =
(why
> >> >>    are my packets suddenly being dropped?), and it will incur runti=
me
> >> >>    overhead.
> >> >>
> >> >> 3. Reject loading of programs that are not MB-aware when running in=
 an
> >> >>    MB-enabled mode. This would make things break in more obvious wa=
ys,
> >> >>    and still allow a userspace loader to declare a program "MB-awar=
e" to
> >> >>    force it to run if necessary. The problem then becomes at what l=
evel
> >> >>    to block this?
> >> >>
> >> >
> >> > I think there's another potential problem with this as well: what ha=
ppens to
> >> > already loaded programs that are not MB-aware? Are they forcibly unl=
oaded?
> >>
> >> I'd say probably the opposite: You can't toggle whatever switch we end
> >> up with if there are any non-MB-aware programs (you'd have to unload
> >> them first)...
> >>
> >
> > How would we communicate that issue? dmesg? I'm not very familiar with
> > how sysctl change failure causes are communicated to users, so this
> > might be a solved problem, but if I run `sysctl -w net.xdp.multibuffer
> > 1` (or whatever ends up actually being the toggle) to active
> > multi-buffer, and it fails because there's a loaded non-aware program,
> > that seems like a potential for a lot of administrator pain.
>
> Hmm, good question. Document that this only fails if there's a
> non-mb-aware XDP program loaded? Or use some other mechanism with better
> feedback?
>
> >> >>    Doing this at the driver level is not enough: while a particular
> >> >>    driver knows if it's running in multi-buff mode, we can't know f=
or
> >> >>    sure if a particular XDP program is multi-buff aware at attach t=
ime:
> >> >>    it could be tail-calling other programs, or redirecting packets =
to
> >> >>    another interface where it will be processed by a non-MB aware
> >> >>    program.
> >> >>
> >> >>    So another option is to make it a global toggle: e.g., create a =
new
> >> >>    sysctl to enable multi-buffer. If this is set, reject loading an=
y XDP
> >> >>    program that doesn't support multi-buffer mode, and if it's unse=
t,
> >> >>    disable multi-buffer mode in all drivers. This will make it expl=
icit
> >> >>    when the multi-buffer mode is used, and prevent any accidental s=
ubtle
> >> >>    malfunction of existing XDP programs. The drawback is that it's =
a
> >> >>    mode switch, so more configuration complexity.
> >> >>
> >> >
> >> > Could we combine the last two bits here into a global toggle that do=
esn't
> >> > require a sysctl? If any driver is put into multi-buffer mode, then =
the system
> >> > switches to requiring all programs be multi-buffer? When the last mu=
lti-buffer
> >> > enabled driver switches out of multi-buffer, remove the system-wide
> >> > restriction?
> >>
> >> Well, the trouble here is that we don't necessarily have an explicit
> >> "multi-buf mode" for devices. For instance, you could raise the MTU of=
 a
> >> device without it necessarily involving any XDP multi-buffer stuff (if
> >> you're not running XDP on that device). So if we did turn "raising the
> >> MTU" into such a mode switch, we would end up blocking any MTU changes
> >> if any XDP programs are loaded. Or having an MTU change cause a
> >> force-unload of all XDP programs.
> >
> > Maybe I missed something then, but you had stated that "while a
> > particular driver knows if it's running in multi-buff mode" so I
> > assumed that the driver would be able to tell when to toggle the mode
> > on.
>
> Well, a driver knows when it is attaching an XDP program whether it (the
> driver) is configured in a way such that this XDP program could
> encounter a multi-buf.

I know drivers sometimes reconfigure themselves when an XDP program is
attached, but is there any information provided by the attach (other than t=
hat
an XDP program is attaching) that they use to make configuration decisions
during that reconfiguration?

Without modifying the driver to intentionally configure itself differently
based on whether or not the program is mb-aware (which is believe is curren=
tly
not the case for any driver), won't the configuration of a driver be identi=
cal
post XDP attach regardless of whether or not the program is mb-aware or not=
?

I was thinking the driver would make it's mb-aware determination (and refco=
unt
adjustments) when its configuration changes for any reason that could
potentially affect mb-aware status (mostly MTU adjustments, I suspect).

>
> > I had been thinking that when a driver turned multi-buffer off, it
> > could trigger a check of all drivers, but that also seems like it
> > could just be a global refcount of all the drivers that have requested
> > multi-buffer mode. When a driver enables multi-buffer for itself, it
> > increments the refcount, and when it disables, it decrements. A
> > non-zero count means the system is in multi-buffer mode.
>
> I guess we could do a refcount-type thing when an multi-buf XDP program
> is first attached (as per above). But I think it may be easier to just
> do it at load-time, then, so it doesn't have to be in the driver, but
> the BPF core could just enforce it.
>
> This would basically amount to a rule saying "you can't mix mb-aware and
> non-mb-aware programs", and the first type to be loaded determines which
> mode the system is in. This would be fairly simple to implement and
> enforce, I suppose. The drawback is that it's potentially racy in the
> order programs are loaded...
>

Accepting or rejecting at load time would definitely simplify things a bit.=
 But
I think the raciness is worse than just based on the first program to load.=
 If
we're doing refcounting at attach/detach time, then I can load an mb-aware =
and
an mb-unaware program before attaching anything. What do I do when I attach=
 one
of them? The other would be in violation.

If instead of making the determination at attach time, we make it at load t=
ime,
I think it'd be better to go back to the sysctl controlling it, and simply =
not
allow changing the sysctl if any XDP program at all is loaded, as opposed t=
o
if a non-aware program is installed.

Then we're back to the sysctl controlling whether or not mb-aware is requir=
ed.
We stil have a communication to the administrator problem, but it's simplif=
ied
a bit from "some loaded program doesn't comply" and having to track down wh=
ich
one to "there is an XDP program installed".

> -Toke
>

Side note: how do extension programs fit into this? An extension program th=
at's
going to freplace a function in an XDP program (that receives the context)
would also need to mb-aware or not, but not all extension programs can atta=
ch
to such functions, and we wouldn't want those programs to be impacted. Is t=
his
as simple as marking every XDP program and every extension program that tak=
es
an XDP context parameter as needing to be marked as mb-aware?

--Zvi

On Tue, Sep 21, 2021 at 3:14 PM Toke H=C3=B8iland-J=C3=B8rgensen <toke@redh=
at.com> wrote:
>
> Zvi Effron <zeffron@riotgames.com> writes:
>
> > On Tue, Sep 21, 2021 at 11:23 AM Toke H=C3=B8iland-J=C3=B8rgensen <toke=
@redhat.com> wrote:
> >>
> >> Zvi Effron <zeffron@riotgames.com> writes:
> >>
> >> > On Tue, Sep 21, 2021 at 9:06 AM Toke H=C3=B8iland-J=C3=B8rgensen <to=
ke@redhat.com> wrote:
> >> >>
> >> >> Hi Lorenz (Cc. the other people who participated in today's discuss=
ion)
> >> >>
> >> >> Following our discussion at the LPC session today, I dug up my prev=
ious
> >> >> summary of the issue and some possible solutions[0]. Seems no on
> >> >> actually replied last time, which is why we went with the "do nothi=
ng"
> >> >> approach, I suppose. I'm including the full text of the original em=
ail
> >> >> below; please take a look, and let's see if we can converge on a
> >> >> consensus here.
> >> >>
> >> >> First off, a problem description: If an existing XDP program is exp=
osed
> >> >> to an xdp_buff that is really a multi-buffer, while it will continu=
e to
> >> >> run, it may end up with subtle and hard-to-debug bugs: If it's pars=
ing
> >> >> the packet it'll only see part of the payload and not be aware of t=
hat
> >> >> fact, and if it's calculating the packet length, that will also onl=
y be
> >> >> wrong (only counting the first fragment).
> >> >>
> >> >> So what to do about this? First of all, to do anything about it, XD=
P
> >> >> programs need to be able to declare themselves "multi-buffer aware"=
 (but
> >> >> see point 1 below). We could try to auto-detect it in the verifier =
by
> >> >> which helpers the program is using, but since existing programs cou=
ld be
> >> >> perfectly happy to just keep running, it probably needs to be somet=
hing
> >> >> the program communicates explicitly. One option is to use the
> >> >> expected_attach_type to encode this; programs can then declare it i=
n the
> >> >> source by section name, or the userspace loader can set the type fo=
r
> >> >> existing programs if needed.
> >> >>
> >> >> With this, the kernel will know if a given XDP program is multi-buf=
f
> >> >> aware and can decide what to do with that information. For this we =
came
> >> >> up with basically three options:
> >> >>
> >> >> 1. Do nothing. This would make it up to users / sysadmins to avoid
> >> >>    anything breaking by manually making sure to not enable multi-bu=
ffer
> >> >>    support while loading any XDP programs that will malfunction if
> >> >>    presented with an mb frame. This will probably break in interest=
ing
> >> >>    ways, but it's nice and simple from an implementation PoV. With =
this
> >> >>    we don't need the declaration discussed above either.
> >> >>
> >> >> 2. Add a check at runtime and drop the frames if they are mb-enable=
d and
> >> >>    the program doesn't understand it. This is relatively simple to
> >> >>    implement, but it also makes for difficult-to-understand issues =
(why
> >> >>    are my packets suddenly being dropped?), and it will incur runti=
me
> >> >>    overhead.
> >> >>
> >> >> 3. Reject loading of programs that are not MB-aware when running in=
 an
> >> >>    MB-enabled mode. This would make things break in more obvious wa=
ys,
> >> >>    and still allow a userspace loader to declare a program "MB-awar=
e" to
> >> >>    force it to run if necessary. The problem then becomes at what l=
evel
> >> >>    to block this?
> >> >>
> >> >
> >> > I think there's another potential problem with this as well: what ha=
ppens to
> >> > already loaded programs that are not MB-aware? Are they forcibly unl=
oaded?
> >>
> >> I'd say probably the opposite: You can't toggle whatever switch we end
> >> up with if there are any non-MB-aware programs (you'd have to unload
> >> them first)...
> >>
> >
> > How would we communicate that issue? dmesg? I'm not very familiar with
> > how sysctl change failure causes are communicated to users, so this
> > might be a solved problem, but if I run `sysctl -w net.xdp.multibuffer
> > 1` (or whatever ends up actually being the toggle) to active
> > multi-buffer, and it fails because there's a loaded non-aware program,
> > that seems like a potential for a lot of administrator pain.
>
> Hmm, good question. Document that this only fails if there's a
> non-mb-aware XDP program loaded? Or use some other mechanism with better
> feedback?
>
> >> >>    Doing this at the driver level is not enough: while a particular
> >> >>    driver knows if it's running in multi-buff mode, we can't know f=
or
> >> >>    sure if a particular XDP program is multi-buff aware at attach t=
ime:
> >> >>    it could be tail-calling other programs, or redirecting packets =
to
> >> >>    another interface where it will be processed by a non-MB aware
> >> >>    program.
> >> >>
> >> >>    So another option is to make it a global toggle: e.g., create a =
new
> >> >>    sysctl to enable multi-buffer. If this is set, reject loading an=
y XDP
> >> >>    program that doesn't support multi-buffer mode, and if it's unse=
t,
> >> >>    disable multi-buffer mode in all drivers. This will make it expl=
icit
> >> >>    when the multi-buffer mode is used, and prevent any accidental s=
ubtle
> >> >>    malfunction of existing XDP programs. The drawback is that it's =
a
> >> >>    mode switch, so more configuration complexity.
> >> >>
> >> >
> >> > Could we combine the last two bits here into a global toggle that do=
esn't
> >> > require a sysctl? If any driver is put into multi-buffer mode, then =
the system
> >> > switches to requiring all programs be multi-buffer? When the last mu=
lti-buffer
> >> > enabled driver switches out of multi-buffer, remove the system-wide
> >> > restriction?
> >>
> >> Well, the trouble here is that we don't necessarily have an explicit
> >> "multi-buf mode" for devices. For instance, you could raise the MTU of=
 a
> >> device without it necessarily involving any XDP multi-buffer stuff (if
> >> you're not running XDP on that device). So if we did turn "raising the
> >> MTU" into such a mode switch, we would end up blocking any MTU changes
> >> if any XDP programs are loaded. Or having an MTU change cause a
> >> force-unload of all XDP programs.
> >
> > Maybe I missed something then, but you had stated that "while a
> > particular driver knows if it's running in multi-buff mode" so I
> > assumed that the driver would be able to tell when to toggle the mode
> > on.
>
> Well, a driver knows when it is attaching an XDP program whether it (the
> driver) is configured in a way such that this XDP program could
> encounter a multi-buf.
>
> > I had been thinking that when a driver turned multi-buffer off, it
> > could trigger a check of all drivers, but that also seems like it
> > could just be a global refcount of all the drivers that have requested
> > multi-buffer mode. When a driver enables multi-buffer for itself, it
> > increments the refcount, and when it disables, it decrements. A
> > non-zero count means the system is in multi-buffer mode.
>
> I guess we could do a refcount-type thing when an multi-buf XDP program
> is first attached (as per above). But I think it may be easier to just
> do it at load-time, then, so it doesn't have to be in the driver, but
> the BPF core could just enforce it.
>
> This would basically amount to a rule saying "you can't mix mb-aware and
> non-mb-aware programs", and the first type to be loaded determines which
> mode the system is in. This would be fairly simple to implement and
> enforce, I suppose. The drawback is that it's potentially racy in the
> order programs are loaded...
>
> -Toke
>

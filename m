Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9E46141513C
	for <lists+netdev@lfdr.de>; Wed, 22 Sep 2021 22:13:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237325AbhIVUP2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Sep 2021 16:15:28 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:51410 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S237309AbhIVUP1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Sep 2021 16:15:27 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1632341636;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=2TgND3O47YKqQB8erfCc+1pnvuJnmgP/nvoFgpF0hAQ=;
        b=EwGWxk259D/8AzaqAGEt/bohtrRNzSknclRsmA13yfgE0l/gHQODy6eSHMQjuUvVyflksJ
        TB+9+iXfLNFkfbRu2VZ5tzdjTRwK5y7vp7EbsO5slwlWcDdxIPM/dCJ1usOdMTXV5yS5mi
        VbcRCU6Ph4RkQpZ/Yd26wOynsPemmlc=
Received: from mail-ed1-f69.google.com (mail-ed1-f69.google.com
 [209.85.208.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-121-ERun91TXPd6SVZgcsR-HgA-1; Wed, 22 Sep 2021 16:13:55 -0400
X-MC-Unique: ERun91TXPd6SVZgcsR-HgA-1
Received: by mail-ed1-f69.google.com with SMTP id m30-20020a50999e000000b003cdd7680c8cso4417024edb.11
        for <netdev@vger.kernel.org>; Wed, 22 Sep 2021 13:13:55 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version:content-transfer-encoding;
        bh=2TgND3O47YKqQB8erfCc+1pnvuJnmgP/nvoFgpF0hAQ=;
        b=BhDTuBmCDM2/djWGGNX9enKrU5o+DBh5MT3feICr5bZ6w/90yhQkH4O+KHo3Jy4qWi
         hk7/dg/wVMspmTYmpdZR4tZycq0FlNeB4DjNZUcPbYFtuEVFqJraXVHvSMC38yILxD/U
         8FHEqnYK35ulEVstbNN9cpnmvQbsGzkexEiwbjnkVki3hfocKV6PzFoc2c26ycxEZGn9
         kwW7av3F/g1bukvQtkezqMSjh5recV/TKYKV67gKtk7syeoi/KYJeXo/6ltVxA+PHhtl
         1kXU+nBmKTw19McG4yhN4EacPubcLLwn8ZysIlDimuhrkndELNaSnIGymUeVpreGQJh6
         e7ww==
X-Gm-Message-State: AOAM531h6uYjiR3on+j3Vh2mxGlgnRhXWgZC63eaRquwNscMM+f1dpuy
        aDfJRWLhSJQSdLYCEyoqfFRgrcgTQ2rCqZW7QDTfMxN6MKrfL+ILFpQsv9AnzVM3IAEQkIWSh1f
        4qMxs6qJ1X5bbO3Ko
X-Received: by 2002:a17:906:3148:: with SMTP id e8mr1164552eje.240.1632341633955;
        Wed, 22 Sep 2021 13:13:53 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxVSRMxj/tvTIgTBYLMwT+RrqtHNCH++RQ6KkgnDWuQ6uU5uaLaE/VR/X+oJrE53+1Kc2XEyg==
X-Received: by 2002:a17:906:3148:: with SMTP id e8mr1164509eje.240.1632341633542;
        Wed, 22 Sep 2021 13:13:53 -0700 (PDT)
Received: from alrua-x1.borgediget.toke.dk ([45.145.92.2])
        by smtp.gmail.com with ESMTPSA id 10sm1504790ejo.111.2021.09.22.13.13.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 22 Sep 2021 13:13:53 -0700 (PDT)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id 5F01F18034A; Wed, 22 Sep 2021 22:13:51 +0200 (CEST)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     Zvi Effron <zeffron@riotgames.com>
Cc:     Lorenz Bauer <lmb@cloudflare.com>,
        Lorenzo Bianconi <lbianconi@redhat.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        John Fastabend <john.fastabend@gmail.com>,
        netdev@vger.kernel.org, bpf <bpf@vger.kernel.org>
Subject: Re: Redux: Backwards compatibility for XDP multi-buff
In-Reply-To: <CAC1LvL1VArVCN4DoEDBReSPsALFtdpYVLVzzzA4wWa4DDYzCUw@mail.gmail.com>
References: <87o88l3oc4.fsf@toke.dk>
 <CAC1LvL1xgFMjjE+3wHH79_9rumwjNqDAS2Yg2NpSvmewHsYScA@mail.gmail.com>
 <87ilyt3i0y.fsf@toke.dk>
 <CAC1LvL3yQd_T5srJb78rGxv8YD-QND2aRgJ-p5vOQkbvrwJWSw@mail.gmail.com>
 <87fstx37bn.fsf@toke.dk>
 <CAC1LvL1VArVCN4DoEDBReSPsALFtdpYVLVzzzA4wWa4DDYzCUw@mail.gmail.com>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Wed, 22 Sep 2021 22:13:51 +0200
Message-ID: <87h7ec1i80.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Zvi Effron <zeffron@riotgames.com> writes:

> On Tue, Sep 21, 2021 at 3:14 PM Toke H=C3=B8iland-J=C3=B8rgensen <toke@re=
dhat.com> wrote:
>>
>> Zvi Effron <zeffron@riotgames.com> writes:
>>
>> > On Tue, Sep 21, 2021 at 11:23 AM Toke H=C3=B8iland-J=C3=B8rgensen <tok=
e@redhat.com> wrote:
>> >>
>> >> Zvi Effron <zeffron@riotgames.com> writes:
>> >>
>> >> > On Tue, Sep 21, 2021 at 9:06 AM Toke H=C3=B8iland-J=C3=B8rgensen <t=
oke@redhat.com> wrote:
>> >> >>
>> >> >> Hi Lorenz (Cc. the other people who participated in today's discus=
sion)
>> >> >>
>> >> >> Following our discussion at the LPC session today, I dug up my pre=
vious
>> >> >> summary of the issue and some possible solutions[0]. Seems no on
>> >> >> actually replied last time, which is why we went with the "do noth=
ing"
>> >> >> approach, I suppose. I'm including the full text of the original e=
mail
>> >> >> below; please take a look, and let's see if we can converge on a
>> >> >> consensus here.
>> >> >>
>> >> >> First off, a problem description: If an existing XDP program is ex=
posed
>> >> >> to an xdp_buff that is really a multi-buffer, while it will contin=
ue to
>> >> >> run, it may end up with subtle and hard-to-debug bugs: If it's par=
sing
>> >> >> the packet it'll only see part of the payload and not be aware of =
that
>> >> >> fact, and if it's calculating the packet length, that will also on=
ly be
>> >> >> wrong (only counting the first fragment).
>> >> >>
>> >> >> So what to do about this? First of all, to do anything about it, X=
DP
>> >> >> programs need to be able to declare themselves "multi-buffer aware=
" (but
>> >> >> see point 1 below). We could try to auto-detect it in the verifier=
 by
>> >> >> which helpers the program is using, but since existing programs co=
uld be
>> >> >> perfectly happy to just keep running, it probably needs to be some=
thing
>> >> >> the program communicates explicitly. One option is to use the
>> >> >> expected_attach_type to encode this; programs can then declare it =
in the
>> >> >> source by section name, or the userspace loader can set the type f=
or
>> >> >> existing programs if needed.
>> >> >>
>> >> >> With this, the kernel will know if a given XDP program is multi-bu=
ff
>> >> >> aware and can decide what to do with that information. For this we=
 came
>> >> >> up with basically three options:
>> >> >>
>> >> >> 1. Do nothing. This would make it up to users / sysadmins to avoid
>> >> >>    anything breaking by manually making sure to not enable multi-b=
uffer
>> >> >>    support while loading any XDP programs that will malfunction if
>> >> >>    presented with an mb frame. This will probably break in interes=
ting
>> >> >>    ways, but it's nice and simple from an implementation PoV. With=
 this
>> >> >>    we don't need the declaration discussed above either.
>> >> >>
>> >> >> 2. Add a check at runtime and drop the frames if they are mb-enabl=
ed and
>> >> >>    the program doesn't understand it. This is relatively simple to
>> >> >>    implement, but it also makes for difficult-to-understand issues=
 (why
>> >> >>    are my packets suddenly being dropped?), and it will incur runt=
ime
>> >> >>    overhead.
>> >> >>
>> >> >> 3. Reject loading of programs that are not MB-aware when running i=
n an
>> >> >>    MB-enabled mode. This would make things break in more obvious w=
ays,
>> >> >>    and still allow a userspace loader to declare a program "MB-awa=
re" to
>> >> >>    force it to run if necessary. The problem then becomes at what =
level
>> >> >>    to block this?
>> >> >>
>> >> >
>> >> > I think there's another potential problem with this as well: what h=
appens to
>> >> > already loaded programs that are not MB-aware? Are they forcibly un=
loaded?
>> >>
>> >> I'd say probably the opposite: You can't toggle whatever switch we end
>> >> up with if there are any non-MB-aware programs (you'd have to unload
>> >> them first)...
>> >>
>> >
>> > How would we communicate that issue? dmesg? I'm not very familiar with
>> > how sysctl change failure causes are communicated to users, so this
>> > might be a solved problem, but if I run `sysctl -w net.xdp.multibuffer
>> > 1` (or whatever ends up actually being the toggle) to active
>> > multi-buffer, and it fails because there's a loaded non-aware program,
>> > that seems like a potential for a lot of administrator pain.
>>
>> Hmm, good question. Document that this only fails if there's a
>> non-mb-aware XDP program loaded? Or use some other mechanism with better
>> feedback?
>>
>> >> >>    Doing this at the driver level is not enough: while a particular
>> >> >>    driver knows if it's running in multi-buff mode, we can't know =
for
>> >> >>    sure if a particular XDP program is multi-buff aware at attach =
time:
>> >> >>    it could be tail-calling other programs, or redirecting packets=
 to
>> >> >>    another interface where it will be processed by a non-MB aware
>> >> >>    program.
>> >> >>
>> >> >>    So another option is to make it a global toggle: e.g., create a=
 new
>> >> >>    sysctl to enable multi-buffer. If this is set, reject loading a=
ny XDP
>> >> >>    program that doesn't support multi-buffer mode, and if it's uns=
et,
>> >> >>    disable multi-buffer mode in all drivers. This will make it exp=
licit
>> >> >>    when the multi-buffer mode is used, and prevent any accidental =
subtle
>> >> >>    malfunction of existing XDP programs. The drawback is that it's=
 a
>> >> >>    mode switch, so more configuration complexity.
>> >> >>
>> >> >
>> >> > Could we combine the last two bits here into a global toggle that d=
oesn't
>> >> > require a sysctl? If any driver is put into multi-buffer mode, then=
 the system
>> >> > switches to requiring all programs be multi-buffer? When the last m=
ulti-buffer
>> >> > enabled driver switches out of multi-buffer, remove the system-wide
>> >> > restriction?
>> >>
>> >> Well, the trouble here is that we don't necessarily have an explicit
>> >> "multi-buf mode" for devices. For instance, you could raise the MTU o=
f a
>> >> device without it necessarily involving any XDP multi-buffer stuff (if
>> >> you're not running XDP on that device). So if we did turn "raising the
>> >> MTU" into such a mode switch, we would end up blocking any MTU changes
>> >> if any XDP programs are loaded. Or having an MTU change cause a
>> >> force-unload of all XDP programs.
>> >
>> > Maybe I missed something then, but you had stated that "while a
>> > particular driver knows if it's running in multi-buff mode" so I
>> > assumed that the driver would be able to tell when to toggle the mode
>> > on.
>>
>> Well, a driver knows when it is attaching an XDP program whether it (the
>> driver) is configured in a way such that this XDP program could
>> encounter a multi-buf.
>
> I know drivers sometimes reconfigure themselves when an XDP program is
> attached, but is there any information provided by the attach (other than=
 that
> an XDP program is attaching) that they use to make configuration decisions
> during that reconfiguration?
>
> Without modifying the driver to intentionally configure itself differently
> based on whether or not the program is mb-aware (which is believe is curr=
ently
> not the case for any driver), won't the configuration of a driver be iden=
tical
> post XDP attach regardless of whether or not the program is mb-aware or n=
ot?
>
> I was thinking the driver would make it's mb-aware determination (and ref=
count
> adjustments) when its configuration changes for any reason that could
> potentially affect mb-aware status (mostly MTU adjustments, I suspect).
>
>>
>> > I had been thinking that when a driver turned multi-buffer off, it
>> > could trigger a check of all drivers, but that also seems like it
>> > could just be a global refcount of all the drivers that have requested
>> > multi-buffer mode. When a driver enables multi-buffer for itself, it
>> > increments the refcount, and when it disables, it decrements. A
>> > non-zero count means the system is in multi-buffer mode.
>>
>> I guess we could do a refcount-type thing when an multi-buf XDP program
>> is first attached (as per above). But I think it may be easier to just
>> do it at load-time, then, so it doesn't have to be in the driver, but
>> the BPF core could just enforce it.
>>
>> This would basically amount to a rule saying "you can't mix mb-aware and
>> non-mb-aware programs", and the first type to be loaded determines which
>> mode the system is in. This would be fairly simple to implement and
>> enforce, I suppose. The drawback is that it's potentially racy in the
>> order programs are loaded...
>>
>
> Accepting or rejecting at load time would definitely simplify things a bi=
t. But
> I think the raciness is worse than just based on the first program to loa=
d. If
> we're doing refcounting at attach/detach time, then I can load an mb-awar=
e and
> an mb-unaware program before attaching anything. What do I do when I atta=
ch one
> of them? The other would be in violation.
>
> If instead of making the determination at attach time, we make it at load=
 time,
> I think it'd be better to go back to the sysctl controlling it, and simpl=
y not
> allow changing the sysctl if any XDP program at all is loaded, as opposed=
 to
> if a non-aware program is installed.
>
> Then we're back to the sysctl controlling whether or not mb-aware is requ=
ired.
> We stil have a communication to the administrator problem, but it's simpl=
ified
> a bit from "some loaded program doesn't comply" and having to track down =
which
> one to "there is an XDP program installed".

Right, that does simplify things. But if we encode the "mb-aware"
property in the program type (or sub-type, AKA expected_attach_type)
discovering which program is blocking the toggle should be fairly
simple, no?

>> -Toke
>>
>
> Side note: how do extension programs fit into this? An extension program =
that's
> going to freplace a function in an XDP program (that receives the context)
> would also need to mb-aware or not, but not all extension programs can at=
tach
> to such functions, and we wouldn't want those programs to be impacted. Is=
 this
> as simple as marking every XDP program and every extension program that t=
akes
> an XDP context parameter as needing to be marked as mb-aware?

Hmm, that's also a good question. I was mentally assuming that freplace
programs could be limited by target type, which would mean that just
encoding the "mb-aware" property in attach type would be enough. But I
see that this is not, in fact, the case. Right now expected_attach_type
is unpused for freplace programs, so we could use that if the kernel is
to enforce this. Or we could make it up to the userspace loader to
ensure this by whatever mechanism it wants. For libxdp that would mean
setting the type of the dispatcher program based on the component
program and refusing to mix those, for instance...

-Toke


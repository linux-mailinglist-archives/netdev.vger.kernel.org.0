Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 299041A39FC
	for <lists+netdev@lfdr.de>; Thu,  9 Apr 2020 20:49:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726651AbgDIStq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Apr 2020 14:49:46 -0400
Received: from mail-qk1-f196.google.com ([209.85.222.196]:33904 "EHLO
        mail-qk1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725987AbgDIStq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Apr 2020 14:49:46 -0400
Received: by mail-qk1-f196.google.com with SMTP id i186so5153528qke.1;
        Thu, 09 Apr 2020 11:49:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=ukIym3BDkleiNccRNd//cvZqgy+EVOlLbrUy2LS0HW4=;
        b=MJLV19CDMKNsrsUeYmWHoH8tFPQUHJ8U9Qm2B/ehJiY+1UH0/AXQdOwyPT7XEY4GeC
         /YIt5xg+IiPxW8r+kpCuqgcHlf9ayxPo6epcvlhXpCF2H11jBYmJgThCiC7G45GusHoA
         +sm8qcYCWc725kfM6llNMlXtDm2T9wMlz1Pi5Q0So+5JFlIeMOt6ubC+ZTR1XZCs6zWT
         tDPUmSDSbFWLx9L7KQX+1z6vvf9OUCMxQKxDfHo0Ehr4uwzOlSisH3p9aBUO1t3ASahp
         X59sHlXdftw3f2QaTcAvvWzEybdLqoHrn7gaNeiGSLmWLrtuW85nCH4mlF91sJMgwj7x
         oOKw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=ukIym3BDkleiNccRNd//cvZqgy+EVOlLbrUy2LS0HW4=;
        b=RTNThCviXmmXkuNmhZ9w3pHjoeT2wW2JePcjzu+kH0274tP1UqPLMNgKP6xG0KTOJy
         dskrJhBvVdaU2ntw6zt2SxEZoa+g4gsOlpuyuSMsKA6Orbe25CGsz7kypMfQe3SMo0xy
         gFC3tkmNyfn+UaP+Uh2QLnEFLXWXl7owR7BxtQLicTzoWwr1LSLMC6JJ8dm92kR4ibWl
         DXSxQejYYJyk2HQZtSwmzDpv4kHXRszh2Rm5z0EGmc29Nvrn2zhjv3Qsf60VNfWKX/NW
         b3njSjZWwc8d6Fdxe5h5NW2tKSnr3gflVHuJh78tPSvE6Gh5A5PhT2d+AKtJTFGIkBJE
         qzRg==
X-Gm-Message-State: AGi0PubMN8gaO2NNCf50P+IB3O88/RArob26bK0nCaLNfFSdXSfv+qUC
        uE1KPpV/PixfD0Yne2DaRQvn0mqgtg049fXjnrM=
X-Google-Smtp-Source: APiQypJnvqtJIiJzu/cCI9NPl703qxPZ3yvnssM+gougkcbMsL8WzOoXxGZ1X8Aa9TCVNZOOD7lrctLT79qbZpf6NJ4=
X-Received: by 2002:ae9:e854:: with SMTP id a81mr308401qkg.36.1586458184812;
 Thu, 09 Apr 2020 11:49:44 -0700 (PDT)
MIME-Version: 1.0
References: <20200404000948.3980903-1-andriin@fb.com> <20200404000948.3980903-5-andriin@fb.com>
 <87pnckc0fr.fsf@toke.dk> <CAEf4BzYrW43EW_Uneqo4B6TLY4V9fKXJxWj+-gbq-7X0j7y86g@mail.gmail.com>
 <877dyq80x8.fsf@toke.dk> <CAEf4BzaiRYMc4QMjz8bEn1bgiSXZvW_e2N48-kTR4Fqgog2fBg@mail.gmail.com>
 <87tv1t65cr.fsf@toke.dk>
In-Reply-To: <87tv1t65cr.fsf@toke.dk>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Thu, 9 Apr 2020 11:49:33 -0700
Message-ID: <CAEf4BzbXCsHCJ6Tet0i5g=pKB_uYqvgiaBNuY-NMdZm8rdZN5g@mail.gmail.com>
Subject: Re: [RFC PATCH bpf-next 4/8] bpf: support GET_FD_BY_ID and
 GET_NEXT_ID for bpf_link
To:     =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>
Cc:     Andrii Nakryiko <andriin@fb.com>, bpf <bpf@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Kernel Team <kernel-team@fb.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Apr 8, 2020 at 2:21 PM Toke H=C3=B8iland-J=C3=B8rgensen <toke@redha=
t.com> wrote:
>
> Andrii Nakryiko <andrii.nakryiko@gmail.com> writes:
>
> > On Wed, Apr 8, 2020 at 8:14 AM Toke H=C3=B8iland-J=C3=B8rgensen <toke@r=
edhat.com> wrote:
> >>
> >> Andrii Nakryiko <andrii.nakryiko@gmail.com> writes:
> >>
> >> > On Mon, Apr 6, 2020 at 4:34 AM Toke H=C3=B8iland-J=C3=B8rgensen <tok=
e@redhat.com> wrote:
> >> >>
> >> >> Andrii Nakryiko <andriin@fb.com> writes:
> >> >>
> >> >> > Add support to look up bpf_link by ID and iterate over all existi=
ng bpf_links
> >> >> > in the system. GET_FD_BY_ID code handles not-yet-ready bpf_link b=
y checking
> >> >> > that its ID hasn't been set to non-zero value yet. Setting bpf_li=
nk's ID is
> >> >> > done as the very last step in finalizing bpf_link, together with =
installing
> >> >> > FD. This approach allows users of bpf_link in kernel code to not =
worry about
> >> >> > races between user-space and kernel code that hasn't finished att=
aching and
> >> >> > initializing bpf_link.
> >> >> >
> >> >> > Further, it's critical that BPF_LINK_GET_FD_BY_ID only ever allow=
s to create
> >> >> > bpf_link FD that's O_RDONLY. This is to protect processes owning =
bpf_link and
> >> >> > thus allowed to perform modifications on them (like LINK_UPDATE),=
 from other
> >> >> > processes that got bpf_link ID from GET_NEXT_ID API. In the latte=
r case, only
> >> >> > querying bpf_link information (implemented later in the series) w=
ill be
> >> >> > allowed.
> >> >>
> >> >> I must admit I remain sceptical about this model of restricting acc=
ess
> >> >> without any of the regular override mechanisms (for instance, enfor=
cing
> >> >> read-only mode regardless of CAP_DAC_OVERRIDE in this series). Sinc=
e you
> >> >> keep saying there would be 'some' override mechanism, I think it wo=
uld
> >> >> be helpful if you could just include that so we can see the full
> >> >> mechanism in context.
> >> >
> >> > I wasn't aware of CAP_DAC_OVERRIDE, thanks for bringing this up.
> >> >
> >> > One way to go about this is to allow creating writable bpf_link for
> >> > GET_FD_BY_ID if CAP_DAC_OVERRIDE is set. Then we can allow LINK_DETA=
CH
> >> > operation on writable links, same as we do with LINK_UPDATE here.
> >> > LINK_DETACH will do the same as cgroup bpf_link auto-detachment on
> >> > cgroup dying: it will detach bpf_link, but will leave it alive until
> >> > last FD is closed.
> >>
> >> Yup, I think this would be a reasonable way to implement the override
> >> mechanism - it would ensure 'full root' users (like a root shell) can
> >> remove attachments, while still preventing applications from doing so =
by
> >> limiting their capabilities.
> >
> > So I did some experiments and I think I want to keep GET_FD_BY_ID for
> > bpf_link to return only read-only bpf_links.
>
> Why, exactly? (also, see below)

For the reasons I explained below: because you can turn read-only
bpf_link into writable one through pinning + chmod, if you have
CAP_DAC_OVERRIDE.

>
> > After that, one can pin bpf_link temporarily and re-open it as
> > writable one, provided CAP_DAC_OVERRIDE capability is present. All
> > that works already, because pinned bpf_link is just a file, so one can
> > do fchmod on it and all that will go through normal file access
> > permission check code path.
>
> Ah, I did not know that was possible - I was assuming that bpffs was
> doing something special to prevent that. But if not, great!
>
> > Unfortunately, just re-opening same FD as writable (which would
> > be possible if fcntl(fd, F_SETFL, S_IRUSR
> >  S_IWUSR) was supported on Linux) without pinning is not possible.
> > Opening link from /proc/<pid>/fd/<link-fd> doesn't seem to work
> > either, because backing inode is not BPF FS inode. I'm not sure, but
> > maybe we can support the latter eventually. But either way, I think
> > given this is to be used for manual troubleshooting, going through few
> > extra hoops to force-detach bpf_link is actually a good thing.
>
> Hmm, I disagree that deliberately making users jump through hoops is a
> good thing. Smells an awful lot like security through obscurity to me;
> and we all know how well that works anyway...

Depends on who users are? bpftool can implement this as one of
`bpftool link` sub-commands and allow human operators to force-detach
bpf_link, if necessary. I think applications shouldn't do this
(programmatically) at all, which is why I think it's actually good
that it's harder and not obvious, this will make developer think again
before implementing this, hopefully. For me it's about discouraging
bad practice.

>
> >> Extending on the concept of RO/RW bpf_link attachments, maybe it shoul=
d
> >> even be possible for an application to choose which mode it wants to p=
in
> >> its fd in? With the same capability being able to override it of
> >> course...
> >
> > Isn't that what patch #2 is doing?...
>
> Ah yes, so it is! I guess I skipped over that a bit too fast ;)
>
> > There are few bugs in the implementation currently, but it will work
> > in the final version.
>
> Cool.
>
> >> > We need to consider, though, if CAP_DAC_OVERRIDE is something that c=
an
> >> > be disabled for majority of real-life applications to prevent them
> >> > from doing this. If every realistic application has/needs
> >> > CAP_DAC_OVERRIDE, then that's essentially just saying that anyone ca=
n
> >> > get writable bpf_link and do anything with it.
> >>
> >> I poked around a bit, and looking at the sandboxing configurations
> >> shipped with various daemons in their systemd unit files, it appears
> >> that the main case where daemons are granted CAP_DAC_OVERRIDE is if th=
ey
> >> have to be able to read /etc/shadow (which is installed as chmod 0). I=
f
> >> this is really the case, that would indicate it's not a widely needed
> >> capability; but I wouldn't exactly say that I've done a comprehensive
> >> survey, so probably a good idea for you to check your users as well :)
> >
> > Right, it might not be possible to drop it for all applications right
> > away, but at least CAP_DAC_OVERRIDE is not CAP_SYS_ADMIN, which is
> > absolutely necessary to work with BPF.
>
> Yeah, I do hope that we'll eventually get CAP_BPF...
>
> -Toke
>

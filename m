Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A1A521A2A44
	for <lists+netdev@lfdr.de>; Wed,  8 Apr 2020 22:23:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729429AbgDHUXY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Apr 2020 16:23:24 -0400
Received: from mail-qv1-f68.google.com ([209.85.219.68]:34592 "EHLO
        mail-qv1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726876AbgDHUXX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Apr 2020 16:23:23 -0400
Received: by mail-qv1-f68.google.com with SMTP id s18so4415898qvn.1;
        Wed, 08 Apr 2020 13:23:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=R1AjtC1FaOwfS7zLeoPF+OGvcwF9VBDHUVGYBvnBugQ=;
        b=tehj3p0dfeidTHf0Y5LrlkSs1rCTe2tIhGdCyfQ1+ZiEKxZutBeIbszXK/kckUcKMg
         OJ4mBdyG7Kj9sBhjT0vnT3qTNB0qBxa9ExWx6/y+L5iKKz5xwZRfszPbVPQHDF1TwRFg
         5VIERADHm/kz3nyQQFG9UygaMZDxdQoCcaOOn/va4Ucp7rD/prozBVHtpofoA1jJdcRG
         yODo/ICqJGHpeIhqqRcm7VYQR0hfHxVuRjou1OMvtxbKRXo6M3mqbFGhmfcYLrqTcrSC
         lqUms53UzNwMHmxNB0/8IOFHFvb35cqqNas+jHlSH91vaoLWxM19K3w11jg23D8gAnja
         ptlg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=R1AjtC1FaOwfS7zLeoPF+OGvcwF9VBDHUVGYBvnBugQ=;
        b=mjhaK8HURQ5OHawPUtwTP7Fy67FqQW3Amy3nllRIV6kGwb7VJNWD4F6Pz6ZRHkiwc5
         Rd2qXv4OvhXHz4YgaAisUeviCf+4+tGuXMQ45ox31dHIvboi+NIvHHy2rsSh6/r+CQFG
         24WntOYPIxoPpFZmEcfeqofOFyQef3DFGedJ3t0vCgnrHceWKn7xmpYZvdPGGvqLF6Mn
         p1xhlMBJ/Ug6m2mNHrNdaMwR1c37XDSkorZWiXi/p1+yTpePbJRA2AM6wKnsauEgQM6R
         /smESykZdUzMOL8uWg/mGDYTZ9DgPOV3VQ/NGgDtPL6MVE3u4f1FJF+X2RRqwct6QDnf
         nHSQ==
X-Gm-Message-State: AGi0Puay+yesO0wfKSLtZUv+gl9+2g04ux9GFoUqA/37zBur7ODBKU2Q
        R22lVoeIi71Qvsuwm43cJUTQgrag+qbiBG6z1dHw5m/o
X-Google-Smtp-Source: APiQypJajdQjFU9E0qQNPfdMg+UFHUtvQhPC9ADR7qcKm+9DsK9f+wQhmh1MZmSSBB/DbV+Dy29f5fC3+s0AJ1w9NwI=
X-Received: by 2002:ad4:568b:: with SMTP id bc11mr5629523qvb.228.1586377400841;
 Wed, 08 Apr 2020 13:23:20 -0700 (PDT)
MIME-Version: 1.0
References: <20200404000948.3980903-1-andriin@fb.com> <20200404000948.3980903-5-andriin@fb.com>
 <87pnckc0fr.fsf@toke.dk> <CAEf4BzYrW43EW_Uneqo4B6TLY4V9fKXJxWj+-gbq-7X0j7y86g@mail.gmail.com>
 <877dyq80x8.fsf@toke.dk>
In-Reply-To: <877dyq80x8.fsf@toke.dk>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Wed, 8 Apr 2020 13:23:09 -0700
Message-ID: <CAEf4BzaiRYMc4QMjz8bEn1bgiSXZvW_e2N48-kTR4Fqgog2fBg@mail.gmail.com>
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

On Wed, Apr 8, 2020 at 8:14 AM Toke H=C3=B8iland-J=C3=B8rgensen <toke@redha=
t.com> wrote:
>
> Andrii Nakryiko <andrii.nakryiko@gmail.com> writes:
>
> > On Mon, Apr 6, 2020 at 4:34 AM Toke H=C3=B8iland-J=C3=B8rgensen <toke@r=
edhat.com> wrote:
> >>
> >> Andrii Nakryiko <andriin@fb.com> writes:
> >>
> >> > Add support to look up bpf_link by ID and iterate over all existing =
bpf_links
> >> > in the system. GET_FD_BY_ID code handles not-yet-ready bpf_link by c=
hecking
> >> > that its ID hasn't been set to non-zero value yet. Setting bpf_link'=
s ID is
> >> > done as the very last step in finalizing bpf_link, together with ins=
talling
> >> > FD. This approach allows users of bpf_link in kernel code to not wor=
ry about
> >> > races between user-space and kernel code that hasn't finished attach=
ing and
> >> > initializing bpf_link.
> >> >
> >> > Further, it's critical that BPF_LINK_GET_FD_BY_ID only ever allows t=
o create
> >> > bpf_link FD that's O_RDONLY. This is to protect processes owning bpf=
_link and
> >> > thus allowed to perform modifications on them (like LINK_UPDATE), fr=
om other
> >> > processes that got bpf_link ID from GET_NEXT_ID API. In the latter c=
ase, only
> >> > querying bpf_link information (implemented later in the series) will=
 be
> >> > allowed.
> >>
> >> I must admit I remain sceptical about this model of restricting access
> >> without any of the regular override mechanisms (for instance, enforcin=
g
> >> read-only mode regardless of CAP_DAC_OVERRIDE in this series). Since y=
ou
> >> keep saying there would be 'some' override mechanism, I think it would
> >> be helpful if you could just include that so we can see the full
> >> mechanism in context.
> >
> > I wasn't aware of CAP_DAC_OVERRIDE, thanks for bringing this up.
> >
> > One way to go about this is to allow creating writable bpf_link for
> > GET_FD_BY_ID if CAP_DAC_OVERRIDE is set. Then we can allow LINK_DETACH
> > operation on writable links, same as we do with LINK_UPDATE here.
> > LINK_DETACH will do the same as cgroup bpf_link auto-detachment on
> > cgroup dying: it will detach bpf_link, but will leave it alive until
> > last FD is closed.
>
> Yup, I think this would be a reasonable way to implement the override
> mechanism - it would ensure 'full root' users (like a root shell) can
> remove attachments, while still preventing applications from doing so by
> limiting their capabilities.

So I did some experiments and I think I want to keep GET_FD_BY_ID for
bpf_link to return only read-only bpf_links. After that, one can pin
bpf_link temporarily and re-open it as writable one, provided
CAP_DAC_OVERRIDE capability is present. All that works already,
because pinned bpf_link is just a file, so one can do fchmod on it and
all that will go through normal file access permission check code
path. Unfortunately, just re-opening same FD as writable (which would
be possible if fcntl(fd, F_SETFL, S_IRUSR
 S_IWUSR) was supported on Linux) without pinning is not possible.
Opening link from /proc/<pid>/fd/<link-fd> doesn't seem to work
either, because backing inode is not BPF FS inode. I'm not sure, but
maybe we can support the latter eventually. But either way, I think
given this is to be used for manual troubleshooting, going through few
extra hoops to force-detach bpf_link is actually a good thing.


>
> Extending on the concept of RO/RW bpf_link attachments, maybe it should
> even be possible for an application to choose which mode it wants to pin
> its fd in? With the same capability being able to override it of
> course...

Isn't that what patch #2 is doing?... There are few bugs in the
implementation currently, but it will work in the final version.

>
> > We need to consider, though, if CAP_DAC_OVERRIDE is something that can
> > be disabled for majority of real-life applications to prevent them
> > from doing this. If every realistic application has/needs
> > CAP_DAC_OVERRIDE, then that's essentially just saying that anyone can
> > get writable bpf_link and do anything with it.
>
> I poked around a bit, and looking at the sandboxing configurations
> shipped with various daemons in their systemd unit files, it appears
> that the main case where daemons are granted CAP_DAC_OVERRIDE is if they
> have to be able to read /etc/shadow (which is installed as chmod 0). If
> this is really the case, that would indicate it's not a widely needed
> capability; but I wouldn't exactly say that I've done a comprehensive
> survey, so probably a good idea for you to check your users as well :)

Right, it might not be possible to drop it for all applications right
away, but at least CAP_DAC_OVERRIDE is not CAP_SYS_ADMIN, which is
absolutely necessary to work with BPF.

>
> -Toke
>

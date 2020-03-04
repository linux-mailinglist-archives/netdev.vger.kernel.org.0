Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 832FF17944A
	for <lists+netdev@lfdr.de>; Wed,  4 Mar 2020 17:03:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729817AbgCDQC4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Mar 2020 11:02:56 -0500
Received: from mail-qv1-f68.google.com ([209.85.219.68]:37073 "EHLO
        mail-qv1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726263AbgCDQCz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 Mar 2020 11:02:55 -0500
Received: by mail-qv1-f68.google.com with SMTP id c19so1005193qvv.4;
        Wed, 04 Mar 2020 08:02:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=cQWNxVQ0LXIWT9/FvK/J+z/Bcd4MWTGz6TFlkpFiw58=;
        b=JWu8A6SVhf4GM7K2iPXO9lrWghCia0fzLEKfG+4C8o68Hcwch84ezGYfNk8dtRGMJ2
         UoH0kq6h8p0EXu/L+IYvHIfOYZkcktNltxWa3gz72/kBoQ7CeA6yqZ6Pfcla1EMJYZwr
         lW+wpUO9NrfSrDj7Ib54KU0XxCKt754hTdTdluDLS/txJ/6xvIAP4v7bbwUblD99+JPz
         oeMGcKD/vSDBcDeXyj1N5WnTwLXpcqJ9yKDoIDfXrnR4hw7G4deSgHe2D8bhLKCk6siv
         yYffc9AWtkvhHchx1vo2mykncYqzPBLQsQqq6P7xtIagVJEFIZoeiF1hhdVFrPLXG+BU
         DHEw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=cQWNxVQ0LXIWT9/FvK/J+z/Bcd4MWTGz6TFlkpFiw58=;
        b=ELHxKjwyU1eD46RsTvjv/R68aOqpGQ2GL7RqEXQoMdDtfRJMFjJk+oYeltl1K82tPQ
         hBVDYdEy/M5EVSsOF64tOee1M1z56/nKWoS6uDExgGHe//6YkVnlG6V/08msSIBnEnKI
         4XNnWsUFgQsX5c8KeYshMvvlML1YSIrxnmF+0fGxpQLSfTpa8xBdWaliHryfaDHP8a7D
         50o6aEQE7NlaiOT6MFhizmlPYVjvH05jlFFrhN7E2tl3p/AdKd0PPK13/zdw3XVvtvCX
         psLUYRBAqD2jp1URuvsA6x61oFoVisVX/iAhmqncNF5F0XGvwyGExOA4TTS3sHfV7DqB
         QjdQ==
X-Gm-Message-State: ANhLgQ2rgglbbAOvzkicpdTCaKyvyS17aSckSgj3Dw0ZHo8tfSG0DtOJ
        RZPaJ5gOKkCA9Pfw3IDmyKZcPmKRMMqmlik+ZpTfLFNY8D8=
X-Google-Smtp-Source: ADFU+vscuTYdVzl45PQzJQDSmptBLFvact8kenY0lGs84R3EN2ALx0kk0U/9NoEOg+5iLgOUJulr/geDw+bC2Optdec=
X-Received: by 2002:ad4:480f:: with SMTP id g15mr2598022qvy.247.1583337774378;
 Wed, 04 Mar 2020 08:02:54 -0800 (PST)
MIME-Version: 1.0
References: <20200303003233.3496043-1-andriin@fb.com> <20200303003233.3496043-2-andriin@fb.com>
 <fb80ddac-d104-d0b7-8bed-694d20b62d61@iogearbox.net> <CAEf4BzZWXRX_TrFSPb=ORcfun8B+GdGOAF6C29B-3xB=NaJO7A@mail.gmail.com>
 <87blpc4g14.fsf@toke.dk> <945cf1c4-78bb-8d3c-10e3-273d100ce41c@iogearbox.net> <c742d2d4-6596-3178-3d03-809270e67183@iogearbox.net>
In-Reply-To: <c742d2d4-6596-3178-3d03-809270e67183@iogearbox.net>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Wed, 4 Mar 2020 08:02:42 -0800
Message-ID: <CAEf4Bzb6Js3mjNaxw6N1o4RaHXtf5K+8M03QUOpHSCwApM8-8Q@mail.gmail.com>
Subject: Re: [PATCH v3 bpf-next 1/3] bpf: switch BPF UAPI #define constants
 used from BPF program side to enums
To:     Daniel Borkmann <daniel@iogearbox.net>
Cc:     =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>,
        Andrii Nakryiko <andriin@fb.com>, bpf <bpf@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@fb.com>,
        Kernel Team <kernel-team@fb.com>, Yonghong Song <yhs@fb.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Mar 4, 2020 at 7:57 AM Daniel Borkmann <daniel@iogearbox.net> wrote=
:
>
> On 3/4/20 4:38 PM, Daniel Borkmann wrote:
> > On 3/4/20 10:37 AM, Toke H=C3=B8iland-J=C3=B8rgensen wrote:
> >> Andrii Nakryiko <andrii.nakryiko@gmail.com> writes:
> >>> On Tue, Mar 3, 2020 at 3:01 PM Daniel Borkmann <daniel@iogearbox.net>=
 wrote:
> >>>>
> >>>> On 3/3/20 1:32 AM, Andrii Nakryiko wrote:
> >>>>> Switch BPF UAPI constants, previously defined as #define macro, to =
anonymous
> >>>>> enum values. This preserves constants values and behavior in expres=
sions, but
> >>>>> has added advantaged of being captured as part of DWARF and, subseq=
uently, BTF
> >>>>> type info. Which, in turn, greatly improves usefulness of generated=
 vmlinux.h
> >>>>> for BPF applications, as it will not require BPF users to copy/past=
e various
> >>>>> flags and constants, which are frequently used with BPF helpers. On=
ly those
> >>>>> constants that are used/useful from BPF program side are converted.
> >>>>>
> >>>>> Signed-off-by: Andrii Nakryiko <andriin@fb.com>
> >>>>
> >>>> Just thinking out loud, is there some way this could be resolved gen=
erically
> >>>> either from compiler side or via additional tooling where this ends =
up as BTF
> >>>> data and thus inside vmlinux.h as anon enum eventually? bpf.h is one=
 single
> >>>> header and worst case libbpf could also ship a copy of it (?), but w=
hat about
> >>>> all the other things one would need to redefine e.g. for tracing? Sm=
all example
> >>>> that comes to mind are all these TASK_* defines in sched.h etc, and =
there's
> >>>> probably dozens of other similar stuff needed too depending on the p=
articular
> >>>> case; would be nice to have some generic catch-all, hmm.
> >>>
> >>> Enum convertion seems to be the simplest and cleanest way,
> >>> unfortunately (as far as I know). DWARF has some extensions capturing
> >>> #defines, but values are strings (and need to be parsed, which is pai=
n
> >>> already for "1 << 1ULL"), and it's some obscure extension, not a
> >>> standard thing. I agree would be nice not to have and change all UAPI
> >>> headers for this, but I'm not aware of the solution like that.
> >>
> >> Since this is a UAPI header, are we sure that no userspace programs ar=
e
> >> using these defines in #ifdefs or something like that?
> >
> > Hm, yes, anyone doing #ifdefs on them would get build issues. Simple ex=
ample:
> >
> > enum {
> >          FOO =3D 42,
> > //#define FOO   FOO
> > };
> >
> > #ifndef FOO
> > # warning "bar"
> > #endif
> >
> > int main(int argc, char **argv)
> > {
> >          return FOO;
> > }
> >
> > $ gcc -Wall -O2 foo.c
> > foo.c:7:3: warning: #warning "bar" [-Wcpp]
> >      7 | # warning "bar"
> >        |   ^~~~~~~
> >
> > Commenting #define FOO FOO back in fixes it as we discussed in v2:
> >
> > $ gcc -Wall -O2 foo.c
> > $
> >
> > There's also a flag_enum attribute, but with the experiments I tried ye=
sterday
> > night I couldn't get a warning to trigger for anonymous enums at least,=
 so that
> > part should be ok.
> >
> > I was about to push the series out, but agree that there may be a risk =
for #ifndefs
> > in the BPF C code. If we want to be on safe side, #define FOO FOO would=
 be needed.
>
> I checked Cilium, LLVM, bcc, bpftrace code, and various others at least t=
here it
> seems okay with the current approach, meaning no such if{,n}def seen that=
 would
> cause a build warning. Also suricata seems to ship the BPF header itself.=
 But
> iproute2 had the following in include/bpf_util.h:
>
> #ifndef BPF_PSEUDO_MAP_FD
> # define BPF_PSEUDO_MAP_FD      1
> #endif

This actually would still work, even if BPF_PSEUDO_MAP_FD was
converted to enum (it would just ignore enum value and hard-code it to
1).

>
> It's still not what was converted though. I would expect risk might be ra=
ther low.
> Toke, is there anything on your side affected?
>
> Thanks,
> Daniel

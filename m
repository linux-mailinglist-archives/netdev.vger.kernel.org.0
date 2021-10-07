Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3B55D425EEB
	for <lists+netdev@lfdr.de>; Thu,  7 Oct 2021 23:29:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240802AbhJGVbX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Oct 2021 17:31:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42590 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241414AbhJGVbW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Oct 2021 17:31:22 -0400
Received: from mail-yb1-xb35.google.com (mail-yb1-xb35.google.com [IPv6:2607:f8b0:4864:20::b35])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 46704C061570;
        Thu,  7 Oct 2021 14:29:28 -0700 (PDT)
Received: by mail-yb1-xb35.google.com with SMTP id g6so16540560ybb.3;
        Thu, 07 Oct 2021 14:29:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=FvyDwyhAlH9SGLvzayqfsloTmWvwetJouTZrHtsLE/s=;
        b=E2wwG7ZvlrPB3ke6Ks3fN9MV68JH/7vguMH9xsw1pYXp+H9lzIoJieJTz3iZrl86Wr
         JrvwPjiDctFNd3lMMGlSoc8cW79F+nTqmfVLP9FxKkTlSGqLqugcg57NH0pBumC9C98P
         koBvthtsR1Tkx4MbfEEIMOtDaeCAPJkrPaEX136eGZgc53R+Kuj6r2YCeE6BSklDJ+wr
         reQqeY/wSRdf7o1gzNQzmAkftbhkPpm4tLj115tl55MtzqucU8DOUb83gquOYA71Vjwn
         bx3og25ts/2vhzq4dXMWwAlqToQpmKoOd09goWMjrhVQXF+Upl0eExLjEZ2s67hHfPZt
         9YEg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=FvyDwyhAlH9SGLvzayqfsloTmWvwetJouTZrHtsLE/s=;
        b=Y6ADtDKsLVrQzjE32gDG66LGd9blHSgwsd98EyTjwa2v7gEbqnzTVhEQtna05idAIJ
         8chB/mN2LkMwPaDMgEzOBYEXdt/dcffGXKaJF+qzN/hzYhY62P+oFlX0wqBQPcaF+bxm
         OtjNhtEmdDLWy8+7p3qtMGGUKDI9nXSYlzGlFsxjD1bnbtE0h83CllNegGVsKxGM0fEK
         IMiKmuJSOWNj/GgxiPz15+OCyvee5wqgwx5DjsnCf1Bo4USb7xna35kZncX6G+BVc8wx
         l3nNO3vOtySaf++uXwyh6+vOsPpqmIYsHDlRqogQfon29vqyVrQ2YaWZR/HHZAFRCHAf
         cn+Q==
X-Gm-Message-State: AOAM530Dmed6SkeAmOITVZ7TbeQhmFaDLqgUHy5tR/7FtJojiNyTxvh5
        EgzOGlwPlgXKeLv5n0fKu6PuuYpGaRQYTbtBM4g=
X-Google-Smtp-Source: ABdhPJzP8b75JS6KmE0yqBA5AQTS/m8gTQ2VKCOI2zCZYfiA1SThFrSlVy/6FwPrlOUOO5Cs4oHuqexuVLpLxzEWVYg=
X-Received: by 2002:a25:afcd:: with SMTP id d13mr7704179ybj.504.1633642167552;
 Thu, 07 Oct 2021 14:29:27 -0700 (PDT)
MIME-Version: 1.0
References: <20211006002853.308945-1-memxor@gmail.com> <20211006002853.308945-4-memxor@gmail.com>
 <CAEf4BzZCK5L-yZHL=yhGir71t=kkhAn5yN07Vxs2+VizvwF3QQ@mail.gmail.com>
 <20211006052455.st3f7m3q5fb27bs7@apollo.localdomain> <CAEf4Bzai=3GK5L-tkZRTT_h8SYPFjike-LTS8GXK17Z1YFAQtw@mail.gmail.com>
 <CAADnVQKVKY8o_3aU8Gzke443+uHa-eGoM0h7W4srChMXU1S4Bg@mail.gmail.com>
 <CAEf4Bza186k8BeRG8XrUGaUb4_6hf0dCB4a1A5czcS69aBMffw@mail.gmail.com>
 <87zgrlm8t9.fsf@toke.dk> <20211007184405.vffu2bd667ra5aec@apollo.localdomain>
In-Reply-To: <20211007184405.vffu2bd667ra5aec@apollo.localdomain>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Thu, 7 Oct 2021 14:29:16 -0700
Message-ID: <CAEf4BzbgubEz-CY3h6L+hzB7uX1TdWHKYxpFYmRebhdeguqBjQ@mail.gmail.com>
Subject: Re: [PATCH bpf-next v1 3/6] libbpf: Ensure that module BTF fd is
 never 0
To:     Kumar Kartikeya Dwivedi <memxor@gmail.com>
Cc:     =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>,
        Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        bpf <bpf@vger.kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Networking <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Oct 7, 2021 at 11:44 AM Kumar Kartikeya Dwivedi
<memxor@gmail.com> wrote:
>
> On Thu, Oct 07, 2021 at 03:54:34PM IST, Toke H=C3=B8iland-J=C3=B8rgensen =
wrote:
> > Andrii Nakryiko <andrii.nakryiko@gmail.com> writes:
> >
> > > On Wed, Oct 6, 2021 at 12:09 PM Alexei Starovoitov
> > > <alexei.starovoitov@gmail.com> wrote:
> > >>
> > >> On Wed, Oct 6, 2021 at 9:43 AM Andrii Nakryiko
> > >> <andrii.nakryiko@gmail.com> wrote:
> > >> >
> > >> > On Tue, Oct 5, 2021 at 10:24 PM Kumar Kartikeya Dwivedi
> > >> > <memxor@gmail.com> wrote:
> > >> > >
> > >> > > On Wed, Oct 06, 2021 at 10:11:29AM IST, Andrii Nakryiko wrote:
> > >> > > > On Tue, Oct 5, 2021 at 5:29 PM Kumar Kartikeya Dwivedi <memxor=
@gmail.com> wrote:
> > >> > > > >
> > >> > > > > Since the code assumes in various places that BTF fd for mod=
ules is
> > >> > > > > never 0, if we end up getting fd as 0, obtain a new fd > 0. =
Even though
> > >> > > > > fd 0 being free for allocation is usually an application err=
or, it is
> > >> > > > > still possible that we end up getting fd 0 if the applicatio=
n explicitly
> > >> > > > > closes its stdin. Deal with this by getting a new fd using d=
up and
> > >> > > > > closing fd 0.
> > >> > > > >
> > >> > > > > Signed-off-by: Kumar Kartikeya Dwivedi <memxor@gmail.com>
> > >> > > > > ---
> > >> > > > >  tools/lib/bpf/libbpf.c | 14 ++++++++++++++
> > >> > > > >  1 file changed, 14 insertions(+)
> > >> > > > >
> > >> > > > > diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
> > >> > > > > index d286dec73b5f..3e5e460fe63e 100644
> > >> > > > > --- a/tools/lib/bpf/libbpf.c
> > >> > > > > +++ b/tools/lib/bpf/libbpf.c
> > >> > > > > @@ -4975,6 +4975,20 @@ static int load_module_btfs(struct bp=
f_object *obj)
> > >> > > > >                         pr_warn("failed to get BTF object #%=
d FD: %d\n", id, err);
> > >> > > > >                         return err;
> > >> > > > >                 }
> > >> > > > > +               /* Make sure module BTF fd is never 0, as ke=
rnel depends on it
> > >> > > > > +                * being > 0 to distinguish between vmlinux =
and module BTFs,
> > >> > > > > +                * e.g. for BPF_PSEUDO_BTF_ID ld_imm64 insns=
 (ksyms).
> > >> > > > > +                */
> > >> > > > > +               if (!fd) {
> > >> > > > > +                       fd =3D dup(0);
> > >> > > >
> > >> > > > This is not the only place where we make assumptions that fd >=
 0 but
> > >> > > > technically can get fd =3D=3D 0. Instead of doing such a check=
 in every
> > >> > > > such place, would it be possible to open (cheaply) some FD (/d=
ev/null
> > >> > > > or whatever, don't know what's the best file to open), if we d=
etect
> > >> > > > that FD =3D=3D 0 is not allocated? Can we detect that fd 0 is =
not
> > >> > > > allocated?
> > >> > > >
> > >> > >
> > >> > > We can, e.g. using access("/proc/self/fd/0", F_OK), but I think =
just calling
> > >> > > open unconditonally and doing if (ret > 0) close(ret) is better.=
 Also, do I
> > >> >
> > >> > yeah, I like this idea, let's go with it
> > >>
> > >> FYI some production environments may detect that FDs 0,1,2 are not
> > >> pointing to stdin, stdout, stderr and will force close whatever file=
s are there
> > >> and open 0,1,2 with canonical files.
> > >>
> > >> libbpf doesn't have to resort to such measures, but it would be prud=
ent to
> > >> make libbpf operate on FDs > 2 for all bpf objects to make sure othe=
r
> > >> frameworks don't ruin libbpf's view of FDs.
> > >
> > > oh well, even without those production complications this would be a
> > > bit fragile, e.g., if the application temporarily opened FD 0 and the=
n
> > > closed it.
> > >
> > > Ok, Kumar, can you please do it as a simple helper that would
> > > dup()'ing until we have FD>2, and use it in as few places as possible
> > > to make sure that all FDs (not just module BTF) are covered. I'd
> > > suggest doing that only in low-level helpers in btf.c, I think
> > > libbpf's logic always goes through those anyways (but please
> > > double-check that we don't call bpf syscall directly anywhere else).
> >
>
> Just to make sure I am on the same page:
>
> I have to...
> 1. Add a small wrapper (currently named fd_gt_2, any other suggestions?)

ensure_good_fd() or something? 2 is a tiny detail there.

>    that takes in the fd, and dups it to fd >=3D 3 if in range [0, 2] (and=
 closes
>    original fd in this case).
>    Use this for all fd returning bpf syscalls in bpf.c (btf.c is a typo?)=
.

yep, typo, I meant bpf.c

>    Audit other places directly calling syscall(__NR_bpf, ...).

yep

> 2. Assume that the situation Alexei mentioned only occurs at startup, or
>    sometime later, not in parallel (which would race with us, and not sur=
e
>    we can deal with it). I'm thinking of a case where such an fd gets pas=
sed
>    to an exec'd binary which closes invalids fds on startup (so keeping t=
hem
>    >=3D 3 allows proper inheritance).

with checking it next to syscall(__NR_bpf) and fcntl suggestion from
Toke, why does it matter?

> 3. gen_loader can hit the same case, so short of adding a bpf_sys_fcntl (=
or the
>    helper only exposing F_DUPFD), next best option is to reserve the thre=
e fds from
>    skel_internal.h or gen_trace (in bpftool) and close later after loadin=
g is done.

Not sure, will defer to Alexei.

>
> Feedback needed on 3 (and whether a generic bpf_sys_dup providing functio=
nality of
> existing fcntl and dup{,2,3} is better than simply reserving the three fd=
s at
> load time).
>
> > FYI, you can use fcntl() with F_DUPFD{,_CLOEXEC} and tell it the minimu=
m
> > fd number you're interested in for the clone. We do that in libxdp to
> > protect against fd 0:
> >
>
> Thanks, will switch the dup to fcntl in the next version.
>
> > https://github.com/xdp-project/xdp-tools/blob/master/lib/libxdp/libxdp.=
c#L1184
> >
> > Given Alexei's comments above, maybe we should be '3' for the last arg
> > instead of 1...
> >
> > -Toke
> >
>
> --
> Kartikeya

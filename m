Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1D9ED425B16
	for <lists+netdev@lfdr.de>; Thu,  7 Oct 2021 20:44:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243767AbhJGSqE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Oct 2021 14:46:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60978 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243709AbhJGSqD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Oct 2021 14:46:03 -0400
Received: from mail-pj1-x1041.google.com (mail-pj1-x1041.google.com [IPv6:2607:f8b0:4864:20::1041])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5D5A2C061755;
        Thu,  7 Oct 2021 11:44:09 -0700 (PDT)
Received: by mail-pj1-x1041.google.com with SMTP id g13-20020a17090a3c8d00b00196286963b9so7588088pjc.3;
        Thu, 07 Oct 2021 11:44:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=aSpHByIL7hU9Cj+fTKzYf3SlqooK7cuVf6gDHr2VbfI=;
        b=aN4WQ6EG5sZSBkbtky7kZsRr8nRNi62cArJYiQeNqWMlYmvA4xDkA2nw175bg5C/X4
         q47+0VUjaqm+Cpy0bZCRo7IvgxpJbFc7DDzLkjrqY9EKJE8Q3F90xzosOsa4fliybMrx
         MCRxHqmC3OXP8yRjJadUZlx1BNE4UYjtdH4MxF3qg23VWFSfu062aRGBZjjOUjb7zBMb
         uDMfANhxQ8Xishid5/WPC45wwtH+TMfxtqEAPGewK5ZpYoxIDjnv/9YM5QCUWTa/8vfU
         eqr9mDwiyyU/EaLcFKT6vbC9imW1GhfCj7rmupig5OoLaj4QBCsi6x8u4sEjBfsZlW8F
         7IHg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=aSpHByIL7hU9Cj+fTKzYf3SlqooK7cuVf6gDHr2VbfI=;
        b=U295Q8dre6n9vmwdRvpasfeuH4ckDuwD4GRV0NEWx5Zt2+pGf7APlxThZJ38ZJ17wK
         cmQk2h8tW7j5yLpenzZCi++Y/i70AXNPl7ZxjxHc8PTzKSF4FkzqG5Eda/I6rn/KSPg0
         hIZDooli3xxdVu+4Hr9X2wbvlxqTr/E/eWLrwhwwEvBivi13U0/fXnogjYBqHSreduRw
         zgvF7rr/Sl5B6DhYvEWVJ8hu/16cD3HEcU78lb7I70+qCbuuI4AzU1hgZfasDopZ0I92
         hDrt9tcHp17Zumj+1K5JDYr8zDfeusEtG+TbObRSCKwG1lu/aKedXdwA8f1pT5sI0gD2
         6XQA==
X-Gm-Message-State: AOAM533HLCSjyvoEAPOo9rsEvmQsm0UKzHx3/0ap1tGQVoGGacJD4DGq
        aWyy1zz5EeTDECTx/Er5rlAOy0Qmznk=
X-Google-Smtp-Source: ABdhPJxBVfBYNZt695zN8an/qT+bdteVrpEf5+mz9LhlK5W7sXdJiKpV0TI3bBIxem12MkMUvGrUBg==
X-Received: by 2002:a17:902:8a8c:b0:13e:45bc:e9a9 with SMTP id p12-20020a1709028a8c00b0013e45bce9a9mr5347182plo.11.1633632248678;
        Thu, 07 Oct 2021 11:44:08 -0700 (PDT)
Received: from localhost ([2405:201:6014:d058:a28d:3909:6ed5:29e7])
        by smtp.gmail.com with ESMTPSA id 17sm72465pgr.10.2021.10.07.11.44.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 07 Oct 2021 11:44:08 -0700 (PDT)
Date:   Fri, 8 Oct 2021 00:14:05 +0530
From:   Kumar Kartikeya Dwivedi <memxor@gmail.com>
To:     Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
Cc:     Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        bpf <bpf@vger.kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Networking <netdev@vger.kernel.org>
Subject: Re: [PATCH bpf-next v1 3/6] libbpf: Ensure that module BTF fd is
 never 0
Message-ID: <20211007184405.vffu2bd667ra5aec@apollo.localdomain>
References: <20211006002853.308945-1-memxor@gmail.com>
 <20211006002853.308945-4-memxor@gmail.com>
 <CAEf4BzZCK5L-yZHL=yhGir71t=kkhAn5yN07Vxs2+VizvwF3QQ@mail.gmail.com>
 <20211006052455.st3f7m3q5fb27bs7@apollo.localdomain>
 <CAEf4Bzai=3GK5L-tkZRTT_h8SYPFjike-LTS8GXK17Z1YFAQtw@mail.gmail.com>
 <CAADnVQKVKY8o_3aU8Gzke443+uHa-eGoM0h7W4srChMXU1S4Bg@mail.gmail.com>
 <CAEf4Bza186k8BeRG8XrUGaUb4_6hf0dCB4a1A5czcS69aBMffw@mail.gmail.com>
 <87zgrlm8t9.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <87zgrlm8t9.fsf@toke.dk>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Oct 07, 2021 at 03:54:34PM IST, Toke Høiland-Jørgensen wrote:
> Andrii Nakryiko <andrii.nakryiko@gmail.com> writes:
>
> > On Wed, Oct 6, 2021 at 12:09 PM Alexei Starovoitov
> > <alexei.starovoitov@gmail.com> wrote:
> >>
> >> On Wed, Oct 6, 2021 at 9:43 AM Andrii Nakryiko
> >> <andrii.nakryiko@gmail.com> wrote:
> >> >
> >> > On Tue, Oct 5, 2021 at 10:24 PM Kumar Kartikeya Dwivedi
> >> > <memxor@gmail.com> wrote:
> >> > >
> >> > > On Wed, Oct 06, 2021 at 10:11:29AM IST, Andrii Nakryiko wrote:
> >> > > > On Tue, Oct 5, 2021 at 5:29 PM Kumar Kartikeya Dwivedi <memxor@gmail.com> wrote:
> >> > > > >
> >> > > > > Since the code assumes in various places that BTF fd for modules is
> >> > > > > never 0, if we end up getting fd as 0, obtain a new fd > 0. Even though
> >> > > > > fd 0 being free for allocation is usually an application error, it is
> >> > > > > still possible that we end up getting fd 0 if the application explicitly
> >> > > > > closes its stdin. Deal with this by getting a new fd using dup and
> >> > > > > closing fd 0.
> >> > > > >
> >> > > > > Signed-off-by: Kumar Kartikeya Dwivedi <memxor@gmail.com>
> >> > > > > ---
> >> > > > >  tools/lib/bpf/libbpf.c | 14 ++++++++++++++
> >> > > > >  1 file changed, 14 insertions(+)
> >> > > > >
> >> > > > > diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
> >> > > > > index d286dec73b5f..3e5e460fe63e 100644
> >> > > > > --- a/tools/lib/bpf/libbpf.c
> >> > > > > +++ b/tools/lib/bpf/libbpf.c
> >> > > > > @@ -4975,6 +4975,20 @@ static int load_module_btfs(struct bpf_object *obj)
> >> > > > >                         pr_warn("failed to get BTF object #%d FD: %d\n", id, err);
> >> > > > >                         return err;
> >> > > > >                 }
> >> > > > > +               /* Make sure module BTF fd is never 0, as kernel depends on it
> >> > > > > +                * being > 0 to distinguish between vmlinux and module BTFs,
> >> > > > > +                * e.g. for BPF_PSEUDO_BTF_ID ld_imm64 insns (ksyms).
> >> > > > > +                */
> >> > > > > +               if (!fd) {
> >> > > > > +                       fd = dup(0);
> >> > > >
> >> > > > This is not the only place where we make assumptions that fd > 0 but
> >> > > > technically can get fd == 0. Instead of doing such a check in every
> >> > > > such place, would it be possible to open (cheaply) some FD (/dev/null
> >> > > > or whatever, don't know what's the best file to open), if we detect
> >> > > > that FD == 0 is not allocated? Can we detect that fd 0 is not
> >> > > > allocated?
> >> > > >
> >> > >
> >> > > We can, e.g. using access("/proc/self/fd/0", F_OK), but I think just calling
> >> > > open unconditonally and doing if (ret > 0) close(ret) is better. Also, do I
> >> >
> >> > yeah, I like this idea, let's go with it
> >>
> >> FYI some production environments may detect that FDs 0,1,2 are not
> >> pointing to stdin, stdout, stderr and will force close whatever files are there
> >> and open 0,1,2 with canonical files.
> >>
> >> libbpf doesn't have to resort to such measures, but it would be prudent to
> >> make libbpf operate on FDs > 2 for all bpf objects to make sure other
> >> frameworks don't ruin libbpf's view of FDs.
> >
> > oh well, even without those production complications this would be a
> > bit fragile, e.g., if the application temporarily opened FD 0 and then
> > closed it.
> >
> > Ok, Kumar, can you please do it as a simple helper that would
> > dup()'ing until we have FD>2, and use it in as few places as possible
> > to make sure that all FDs (not just module BTF) are covered. I'd
> > suggest doing that only in low-level helpers in btf.c, I think
> > libbpf's logic always goes through those anyways (but please
> > double-check that we don't call bpf syscall directly anywhere else).
>

Just to make sure I am on the same page:

I have to...
1. Add a small wrapper (currently named fd_gt_2, any other suggestions?)
   that takes in the fd, and dups it to fd >= 3 if in range [0, 2] (and closes
   original fd in this case).
   Use this for all fd returning bpf syscalls in bpf.c (btf.c is a typo?).
   Audit other places directly calling syscall(__NR_bpf, ...).
2. Assume that the situation Alexei mentioned only occurs at startup, or
   sometime later, not in parallel (which would race with us, and not sure
   we can deal with it). I'm thinking of a case where such an fd gets passed
   to an exec'd binary which closes invalids fds on startup (so keeping them
   >= 3 allows proper inheritance).
3. gen_loader can hit the same case, so short of adding a bpf_sys_fcntl (or the
   helper only exposing F_DUPFD), next best option is to reserve the three fds from
   skel_internal.h or gen_trace (in bpftool) and close later after loading is done.

Feedback needed on 3 (and whether a generic bpf_sys_dup providing functionality of
existing fcntl and dup{,2,3} is better than simply reserving the three fds at
load time).

> FYI, you can use fcntl() with F_DUPFD{,_CLOEXEC} and tell it the minimum
> fd number you're interested in for the clone. We do that in libxdp to
> protect against fd 0:
>

Thanks, will switch the dup to fcntl in the next version.

> https://github.com/xdp-project/xdp-tools/blob/master/lib/libxdp/libxdp.c#L1184
>
> Given Alexei's comments above, maybe we should be '3' for the last arg
> instead of 1...
>
> -Toke
>

--
Kartikeya

Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C50D02F21D4
	for <lists+netdev@lfdr.de>; Mon, 11 Jan 2021 22:32:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729683AbhAKVcU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Jan 2021 16:32:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44130 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727448AbhAKVcS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 Jan 2021 16:32:18 -0500
Received: from mail-yb1-xb29.google.com (mail-yb1-xb29.google.com [IPv6:2607:f8b0:4864:20::b29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 31094C061786;
        Mon, 11 Jan 2021 13:31:38 -0800 (PST)
Received: by mail-yb1-xb29.google.com with SMTP id o144so218651ybc.0;
        Mon, 11 Jan 2021 13:31:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=YLCXG2bPPn8UMyHmWF0466FW1qLEA/XV5OMrO5redps=;
        b=rUTyzdZvMGdf+nfcR9GdubiC1Rp14lG+bQ1c8pFXrQ1hKOmxjoBmL553AkHpGSSX6T
         g/6D2VMz3wY2ZPWPM6BmAky5dFq9F3LAJsJUYtxZx1XI9WEfjYb5PzJNUnBl6gatlQ2X
         cO7WLHBmCPeykzzGF3FHtE46IncorSnYvNaEBpm6sg8E+HoNUmxxUVMSQy2HzhzQ734D
         Q4KLSJ0gjfteZYhv7inJEFjpBspX2FE0XbMzpDM06BctD2U+yyeDX4nszkOwwZcY3Tb4
         +cf9ghhg9dWz8Oh6yGUo3SGO5ENnP8mjFTOgjXa7GAu+6rZf3zz2pUUEz/ZixraFE3o9
         qnFg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=YLCXG2bPPn8UMyHmWF0466FW1qLEA/XV5OMrO5redps=;
        b=NuYbHavfTIWKvb+4BGPj0eDQlnpOLJTY1lErOVTZU+dGWoj7KcQIee5dWQGQqToRnE
         r+3jACSqvI4fdHegT044qSIaQlzvvbj0FrvsBzulskH/v68szksyWEhyJBT8+v6BxET5
         lyLVsJCDdMUCyjoN5Deu7EKzOU8sbiQ77zIYHx6wzro0dPppJl0vWgJsJ4eBL84W+ChL
         oCllD4l4ECbYTeIppbMtkxSgKjv0qD+Rfzd1GGKzNmhCGtXYrUMXlZ1haNrxNEBsvaFT
         JuLCMpu6jRq/5jpBFNRFAbLRG3yENquVGnGYEFU6y54NAcBI4UmIaXYZnaInM7k0ur0L
         rIbw==
X-Gm-Message-State: AOAM531b0ajo5Qba2LwN1fMsHB24fb6HLDY1Oblfjf4VOqcptyqGCBAm
        AYasqpWAZubXEl2ZLoQ7dNBPY86davee7++/nWg=
X-Google-Smtp-Source: ABdhPJxJwzgknwQmh8e2OyLUEtGDAhh90rGOq+u7Q6BF15pklrgp0gtnYirTSUGREroHDTpLiQ29a479zyF0NkJEal4=
X-Received: by 2002:a25:854a:: with SMTP id f10mr2448692ybn.510.1610400697435;
 Mon, 11 Jan 2021 13:31:37 -0800 (PST)
MIME-Version: 1.0
References: <20210108220930.482456-1-andrii@kernel.org> <20210108220930.482456-6-andrii@kernel.org>
 <CA+khW7jTso5Jz6D8Scn8-Kf3OtT0B4JP_rJWFCZa8EEmYOO8iw@mail.gmail.com>
In-Reply-To: <CA+khW7jTso5Jz6D8Scn8-Kf3OtT0B4JP_rJWFCZa8EEmYOO8iw@mail.gmail.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Mon, 11 Jan 2021 13:31:26 -0800
Message-ID: <CAEf4BzYfqB3mkzwciXfcoMyXwrZO71ukt55cL47U+fLa_qWTzg@mail.gmail.com>
Subject: Re: [PATCH v2 bpf-next 5/7] bpf: support BPF ksym variables in kernel modules
To:     Hao Luo <haoluo@google.com>
Cc:     Andrii Nakryiko <andrii@kernel.org>, bpf <bpf@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Kernel Team <kernel-team@fb.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jan 11, 2021 at 11:00 AM Hao Luo <haoluo@google.com> wrote:
>
> Acked-by: Hao Luo <haoluo@google.com>, with a suggestion on adding a comment.
>

top posting your Ack? :)


> On Fri, Jan 8, 2021 at 2:09 PM Andrii Nakryiko <andrii@kernel.org> wrote:
> >
> > Add support for directly accessing kernel module variables from BPF programs
> > using special ldimm64 instructions. This functionality builds upon vmlinux
> > ksym support, but extends ldimm64 with src_reg=BPF_PSEUDO_BTF_ID to allow
> > specifying kernel module BTF's FD in insn[1].imm field.
> >
> > During BPF program load time, verifier will resolve FD to BTF object and will
> > take reference on BTF object itself and, for module BTFs, corresponding module
> > as well, to make sure it won't be unloaded from under running BPF program. The
> > mechanism used is similar to how bpf_prog keeps track of used bpf_maps.
> >
> > One interesting change is also in how per-CPU variable is determined. The
> > logic is to find .data..percpu data section in provided BTF, but both vmlinux
> > and module each have their own .data..percpu entries in BTF. So for module's
> > case, the search for DATASEC record needs to look at only module's added BTF
> > types. This is implemented with custom search function.
> >
> > Signed-off-by: Andrii Nakryiko <andrii@kernel.org>
> > ---
> >  include/linux/bpf.h          |  10 +++
> >  include/linux/bpf_verifier.h |   3 +
> >  include/linux/btf.h          |   3 +
> >  kernel/bpf/btf.c             |  31 +++++++-
> >  kernel/bpf/core.c            |  23 ++++++
> >  kernel/bpf/verifier.c        | 149 ++++++++++++++++++++++++++++-------
> >  6 files changed, 189 insertions(+), 30 deletions(-)
>
> [...]
>
> > diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
> > index 17270b8404f1..af94c6871ab8 100644
> > --- a/kernel/bpf/verifier.c
> > +++ b/kernel/bpf/verifier.c
> > @@ -9703,6 +9703,31 @@ static int do_check(struct bpf_verifier_env *env)
> >         return 0;
> >  }
> >
> > +static int find_btf_percpu_datasec(struct btf *btf)
> > +{
> > +       const struct btf_type *t;
> > +       const char *tname;
> > +       int i, n;
> > +
>
> It would be good to add a short comment here explaining the reason why
> the search for DATASEC in the module case needs to skip entries.

I can copy-paste parts of the commit message with that explanation, if
I'll need another version. If not, I can send a follow-up patch.

>
> > +       n = btf_nr_types(btf);
> > +       if (btf_is_module(btf))
> > +               i = btf_nr_types(btf_vmlinux);
> > +       else
> > +               i = 1;
> > +
> > +       for(; i < n; i++) {
> > +               t = btf_type_by_id(btf, i);
> > +               if (BTF_INFO_KIND(t->info) != BTF_KIND_DATASEC)
> > +                       continue;
> > +
> > +               tname = btf_name_by_offset(btf, t->name_off);
> > +               if (!strcmp(tname, ".data..percpu"))
> > +                       return i;
> > +       }
> > +
> > +       return -ENOENT;
> > +}
> [...]
> > 2.24.1
> >

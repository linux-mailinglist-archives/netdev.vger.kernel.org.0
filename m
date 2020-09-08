Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 47BF02619C4
	for <lists+netdev@lfdr.de>; Tue,  8 Sep 2020 20:26:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728620AbgIHSZ5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Sep 2020 14:25:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48452 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731720AbgIHSUr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Sep 2020 14:20:47 -0400
Received: from mail-yb1-xb41.google.com (mail-yb1-xb41.google.com [IPv6:2607:f8b0:4864:20::b41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 329C6C061755;
        Tue,  8 Sep 2020 11:20:47 -0700 (PDT)
Received: by mail-yb1-xb41.google.com with SMTP id q3so73737ybp.7;
        Tue, 08 Sep 2020 11:20:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=vMkOhHoTnDdu+r0sl6ItrBY76nhjnjVXd38zplyYtZk=;
        b=c1xL/c909mmGZ8KVCS3qpOjUNJgJy4NJ+erNHnoQXsBacXAN2qB4vI6xL3Iu2YC/Uj
         yDxCdzyZY3mcgS6hTtuXOFcrrJZE12wqSYXb2fgdqM+oNYFYyE3LBnhoEQx0n5Om/9Yh
         BHxLGj5d9ybK8pR5R3R4/o5gHf6RSlNAXsFnOlm2znXLXAoBjJEev7GPtjPqRzXGM/FK
         u+vBdXsSOkm+AQ4LUn84xgJLLMrW7N8PQAVj8w8c9TPe9YdrNvZlKTsRzLYtieUbLK2K
         4sl/k//i4pQTIWED+yMTEcyz4+YQl0uVxX3WTQX+EJDtaX5l1o19PhvErfi9deMqDbZ2
         BPTg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=vMkOhHoTnDdu+r0sl6ItrBY76nhjnjVXd38zplyYtZk=;
        b=qUthvHupkZv5Udmj8iUTC7EqczDp8B9frOmRvTMeKZeY4Xu1bHu4Yamffq2bdPeDfb
         z8H1ZNj9llgXfyyeQQtrdtmBK6aA6qT4pnH/QMTwq+rpiXr/boBm4C5KeJ2qLPbUUTFe
         49e3JfotQdwFi6ZsHXUP+U0c5YK4j8K36TNYNhi1htqjazLp6g0CAk9jlSz6rPh0ze6k
         Sqy6XrCYWD7/XSXX+HR1yI9U2saOVO1pYpIDy5H7ZxApwpBREjD3pCk0cR5NZ5cDcj63
         3LTbvxmpn5p7Y38yjLDlQQtym8FFLyhxNCQAyrLmOAwW7uUb4LJbHF0bu6miy/gnA44U
         O1yg==
X-Gm-Message-State: AOAM532Z7x2ot6INb0Y9iSFBeQl/52V1MSp1khif5n68q/kvJM0lePIC
        xqATBmHEHBL21nUVnLLuWC8sDQ5Qx452SHxXb+Q=
X-Google-Smtp-Source: ABdhPJy44p+aPRb6MaJvJlJkPwO0/uJH8yyQgIeKdWyyyoohr3DfLqv+/hIjoZW8Dzc5v2QATKQhf4lClIBpjkFu3Os=
X-Received: by 2002:a25:c049:: with SMTP id c70mr154168ybf.403.1599589246398;
 Tue, 08 Sep 2020 11:20:46 -0700 (PDT)
MIME-Version: 1.0
References: <20200828193603.335512-1-sdf@google.com> <20200828193603.335512-4-sdf@google.com>
 <CAEf4BzZtYTyBT=jURkF4RQLHXORooVwXrRRRkoSWDqCemyGQeA@mail.gmail.com>
 <20200904012909.c7cx5adhy5f23ovo@ast-mbp.dhcp.thefacebook.com>
 <CAEf4BzZp4ODLbjEiv=W7byoR9XzTqAQ052wZM_wD4=aTPmkjbw@mail.gmail.com>
 <87mu22ottv.fsf@toke.dk> <CAKH8qBuTwNhCjdE91d+9bYsLko08qNf4E2B_33x8Zcc4KAK36g@mail.gmail.com>
In-Reply-To: <CAKH8qBuTwNhCjdE91d+9bYsLko08qNf4E2B_33x8Zcc4KAK36g@mail.gmail.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Tue, 8 Sep 2020 11:20:35 -0700
Message-ID: <CAEf4BzZGADt7bq7S7HeRvj8aL4if1cuSsX8EFcEa-UL_LX0FKw@mail.gmail.com>
Subject: Re: [PATCH bpf-next v3 3/8] libbpf: Add BPF_PROG_BIND_MAP syscall and
 use it on .metadata section
To:     Stanislav Fomichev <sdf@google.com>
Cc:     =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>,
        Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        YiFei Zhu <zhuyifei1999@gmail.com>,
        Andrey Ignatov <rdna@fb.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Sep 8, 2020 at 8:20 AM Stanislav Fomichev <sdf@google.com> wrote:
>
> On Mon, Sep 7, 2020 at 1:49 AM Toke H=C3=B8iland-J=C3=B8rgensen <toke@red=
hat.com> wrote:
> >
> > Andrii Nakryiko <andrii.nakryiko@gmail.com> writes:
> >
> > >> May be we should talk about problem statement and goals.
> > >> Do we actually need metadata per program or metadata per single .o
> > >> or metadata per final .o with multiple .o linked together?
> > >> What is this metadata?
> > >
> > > Yep, that's a very valid question. I've also CC'ed Andrey.
> >
> > For the libxdp use case, I need metadata per program. But I'm already
> > sticking that in a single section and disambiguating by struct name
> > (just prefixing the function name with a _ ), so I think it's fine to
> > have this kind of "concatenated metadata" per elf file and parse out th=
e
> > per-program information from that. This is similar to the BTF-encoded
> > "metadata" we can do today.
> We've come full circle :-)
> I think we discussed that approach originally - to stick everything
> into existing global .data/.rodata and use some variable prefix for
> the metadata. I'm fine with that approach. The only thing I don't

That's what we wanted all along, but the problem was with keeping
reference to bpf_map from bpf_prog. We eventually gave up and
concluded that extra BPF command is necessary. But somewhere along the
road we somehow concluded we need an entire new special map/section,
and I didn't realize at first (and it seems it wasn't just me) that
the latter part is unnecessary.

> understand is - why bother with the additional .rodata.metadata
> section and merging?
> Can we unconditionally do BPF_PROG_BIND_MAP(.rodata) from libbpf (and
> ignore the error) and be done?

That's exactly what we are proposing, to stick to .rodata, instead of
having extra .metadata section. Multiple .rodata/.data sections are
orthogonal concerns, which we need to solve as well, because the
compiler does emit many of them in some cases. So in that context,
once we support multiple .rodata's, it would be possible to have
metadata-only "sub-sections". But we don't have to do that, keeping
everything simple and put into .rodata works just fine.

>
> Sticking to the original question: for our use-case, the metadata is
> per .o file. I'm not sure how it would work in the 'multiple .o linked
> together' use case. Ideally, we'd need to preserve all metadata?

Just like in user-space, when you have multiple .c files compiled into
.o files and later linked into a final library or binary, all the
.data and .rodata sections are combined. That's what will happen with
BPF .o files as well. So it will be automatically preserved, as you
seem to want.

>
> > >> If it's just unreferenced by program read only data then no special =
names or
> > >> prefixes are needed. We can introduce BPF_PROG_BIND_MAP to bind any =
map to any
> > >> program and it would be up to tooling to decide the meaning of the d=
ata in the
> > >> map. For example, bpftool can choose to print all variables from all=
 read only
> > >> maps that match "bpf_metadata_" prefix, but it will be bpftool conve=
ntion only
> > >> and not hard coded in libbpf.
> > >
> > > Agree as well. It feels a bit odd for libbpf to handle ".metadata"
> > > specially, given libbpf itself doesn't care about its contents at all=
.
> > >
> > > So thanks for bringing this up, I think this is an important
> > > discussion to have.
> >
> > I'm fine with having this be part of .rodata. One drawback, though, is
> > that if any metadata is defined, it becomes a bit more complicated to
> > use bpf_map__set_initial_value() because that now also has to include
> > the metadata. Any way we can improve upon that?
> Right. One additional thing we wanted this metadata to have is the
> comm of the process who loaded this bpf program (to be filled/added by
> libbpf).
> I suppose .rodata.metadata section can help with that?

.rodata.metadata has nothing to do with this. I'm also not sure
whether it's a responsibility of libbpf to provide process's comm as a
metadata, to be honest. Next thing it will be user name/user id, then
cgroup name, then some other application-level concept and so on. I'd
prefer to keep it simple and let applications handle that for
themselves. Luckily, using a BPF skeleton this is **extremely** easy.

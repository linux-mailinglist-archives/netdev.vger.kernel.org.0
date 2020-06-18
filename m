Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9F2FB1FFF1C
	for <lists+netdev@lfdr.de>; Fri, 19 Jun 2020 01:59:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728606AbgFRX7a (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Jun 2020 19:59:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58378 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726906AbgFRX73 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Jun 2020 19:59:29 -0400
Received: from mail-qt1-x843.google.com (mail-qt1-x843.google.com [IPv6:2607:f8b0:4864:20::843])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ACB30C06174E;
        Thu, 18 Jun 2020 16:59:28 -0700 (PDT)
Received: by mail-qt1-x843.google.com with SMTP id y1so5925977qtv.12;
        Thu, 18 Jun 2020 16:59:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=MzQ95sn0FwYeR2kndKjQO26BqncGt2L+uDpiWsCGWI4=;
        b=aifmosR5/9EowXMOFOmrx0P6FY+DhQ6ZnU3qkx/nPseu/LHc7SvfIaDNrO7n7tA55R
         ABCMIHCvoxSM/LCF7PlPcrCnR1Ojq3SbZ2awugb+3CyYPgu6KDIyfaOkBoiMgUI9hAhG
         oa1yZEbAroB5yK3s0jDonGtTL5g6b6xUP8SeJICgIq0mh+NAsv5ya2mxdtidmj7UzpHn
         zFaaHDc/Pq0x8xNSRhFyCiJywP/tUq9klpXl/kwhYkDep+BBz5uHNTzvRZyrOoZMcJg+
         cySz68JwEbX4zPRUmwRUJtYRsIekyydcOc+VPuKDhy1x5ktvQSMb7gsL1UlTSE/3IILJ
         em/Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=MzQ95sn0FwYeR2kndKjQO26BqncGt2L+uDpiWsCGWI4=;
        b=DMJ/RrTjF3s9R4zM3QSNSG8bzyG+RNaSnzqR0CjXzp14CGaTSHtWLBqI9FPSU5EfcM
         t8XZTQM33x66aroIBfSxegDh3iY7ulKRdwVvqvlKvNshJP5a1PqqB4rtiAa1zOdzKtAu
         qUUZQs/zX7Ak4U0Bq+JWk27/iVGD85X4EcrltS7XGsHLMih7+hd83DOVlVZNXqZIKUX3
         IfZhBB+iWVAQ+7v6Tc65V7XXOojhhgx/7urZlcszF/keSIS3YDqkuYMMltvqG90QtvuR
         6BG1NqevWqN1Gm1CEj/sA+iQ/BJ+Xl3hW7ZE2BIgLNlZUVUXwnt2T3jQUknirV0G0RNE
         NM6g==
X-Gm-Message-State: AOAM5311PX3ue+Ry9DogPUMBx1EhoCa95bw8umG5wc44NoPo87YCKG2X
        NRg7cq1uejOXQtbi3qiGXyUYUkD0q551HXt43ec=
X-Google-Smtp-Source: ABdhPJz37nUH+eNrlsmRbmUGG7RAAz9JLp70hDdt2Q5ORA84JHtJzjQ7CZ3wM9FRLXH+wtHcdvk/mLv9KGDbOfVXPaM=
X-Received: by 2002:ac8:42ce:: with SMTP id g14mr829761qtm.117.1592524767866;
 Thu, 18 Jun 2020 16:59:27 -0700 (PDT)
MIME-Version: 1.0
References: <20200616173556.2204073-1-jolsa@kernel.org> <5eeaa556c7a0e_38b82b28075185c46a@john-XPS-13-9370.notmuch>
 <20200618114806.GA2369163@krava> <5eebe552dddc1_6d292ad5e7a285b83f@john-XPS-13-9370.notmuch>
In-Reply-To: <5eebe552dddc1_6d292ad5e7a285b83f@john-XPS-13-9370.notmuch>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Thu, 18 Jun 2020 16:59:16 -0700
Message-ID: <CAEf4Bzb+U+A9i0VfGUHLVt28WCob7pb-0iVQA8d1fcR8A27ZpA@mail.gmail.com>
Subject: Re: [PATCH] bpf: Allow small structs to be type of function argument
To:     John Fastabend <john.fastabend@gmail.com>
Cc:     Jiri Olsa <jolsa@redhat.com>, Andrii Nakryiko <andriin@fb.com>,
        Jiri Olsa <jolsa@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Yonghong Song <yhs@fb.com>, Martin KaFai Lau <kafai@fb.com>,
        Jakub Kicinski <kuba@kernel.org>,
        David Miller <davem@redhat.com>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        KP Singh <kpsingh@chromium.org>,
        Masanori Misono <m.misono760@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jun 18, 2020 at 3:50 PM John Fastabend <john.fastabend@gmail.com> wrote:
>
> Jiri Olsa wrote:
> > On Wed, Jun 17, 2020 at 04:20:54PM -0700, John Fastabend wrote:
> > > Jiri Olsa wrote:
> > > > This way we can have trampoline on function
> > > > that has arguments with types like:
> > > >
> > > >   kuid_t uid
> > > >   kgid_t gid
> > > >
> > > > which unwind into small structs like:
> > > >
> > > >   typedef struct {
> > > >         uid_t val;
> > > >   } kuid_t;
> > > >
> > > >   typedef struct {
> > > >         gid_t val;
> > > >   } kgid_t;
> > > >
> > > > And we can use them in bpftrace like:
> > > > (assuming d_path changes are in)
> > > >
> > > >   # bpftrace -e 'lsm:path_chown { printf("uid %d, gid %d\n", args->uid, args->gid) }'
> > > >   Attaching 1 probe...
> > > >   uid 0, gid 0
> > > >   uid 1000, gid 1000
> > > >   ...
> > > >
> > > > Signed-off-by: Jiri Olsa <jolsa@kernel.org>
> > > > ---
> > > >  kernel/bpf/btf.c | 12 +++++++++++-
> > > >  1 file changed, 11 insertions(+), 1 deletion(-)
> > > >
> > > > diff --git a/kernel/bpf/btf.c b/kernel/bpf/btf.c
> > > > index 58c9af1d4808..f8fee5833684 100644
> > > > --- a/kernel/bpf/btf.c
> > > > +++ b/kernel/bpf/btf.c
> > > > @@ -362,6 +362,14 @@ static bool btf_type_is_struct(const struct btf_type *t)
> > > >   return kind == BTF_KIND_STRUCT || kind == BTF_KIND_UNION;
> > > >  }
> > > >
> > > > +/* type is struct and its size is within 8 bytes
> > > > + * and it can be value of function argument
> > > > + */
> > > > +static bool btf_type_is_struct_arg(const struct btf_type *t)
> > > > +{
> > > > + return btf_type_is_struct(t) && (t->size <= sizeof(u64));
> > >
> > > Can you comment on why sizeof(u64) here? The int types can be larger
> > > than 64 for example and don't have a similar check, maybe the should
> > > as well?
> > >
> > > Here is an example from some made up program I ran through clang and
> > > bpftool.
> > >
> > > [2] INT '__int128' size=16 bits_offset=0 nr_bits=128 encoding=SIGNED
> > >
> > > We also have btf_type_int_is_regular to decide if the int is of some
> > > "regular" size but I don't see it used in these paths.
> >
> > so this small structs are passed as scalars via function arguments,
> > so the size limit is to fit teir value into register size which holds
> > the argument
> >
> > I'm not sure how 128bit numbers are passed to function as argument,
> > but I think we can treat them separately if there's a need
> >
>
> Moving Andrii up to the TO field ;)

I've got an upgrade, thanks :)

>
> Andrii, do we also need a guard on the int type with sizeof(u64)?
> Otherwise the arg calculation might be incorrect? wdyt did I follow
> along correctly.

Yes, we probably do. I actually never used __int128 in practice, but
decided to look at what Clang does for a function accepting __int128.
Turns out it passed it in two consecutive registers. So:

__weak int bla(__int128 x) { return (int)(x + 1); }

The assembly is:

      38:       b7 01 00 00 fe ff ff ff r1 = -2
      39:       b7 02 00 00 ff ff ff ff r2 = -1
      40:       85 10 00 00 ff ff ff ff call -1
      41:       bc 01 00 00 00 00 00 00 w1 = w0

So low 64-bits go into r1, high 64-bits into r2.

Which means the 1:1 mapping between registers and input arguments
breaks with __int128, at least for target BPF. I'm too lazy to check
for x86-64, though.

Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BFE8E15AD73
	for <lists+netdev@lfdr.de>; Wed, 12 Feb 2020 17:34:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728576AbgBLQeC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Feb 2020 11:34:02 -0500
Received: from mail-qv1-f65.google.com ([209.85.219.65]:38723 "EHLO
        mail-qv1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727279AbgBLQeC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 12 Feb 2020 11:34:02 -0500
Received: by mail-qv1-f65.google.com with SMTP id g6so1201653qvy.5;
        Wed, 12 Feb 2020 08:34:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=jPDghSiMnJ5ArV1uIYx7OEKA+c/PzF9WfW5YPQOupgY=;
        b=dCBYdHo6Wswj5HqR/eBzQiCEySA74GEWw3KAvLKQjIuRoPa32mRwXB7f2OA8OIKoNi
         kHOeHotpNUSXvq7u6o/miVtMGZGFXy+6NgTtelHJGxOahjar7Wt3DniobflEr9x9Ebt4
         G6XLvS/E1k4IcVcp6ZhHemwkA5vKwn00UxxKOXoBImvx92yizr+HRZw8X5Xh/rQB2e6Z
         VEzl/tAN2Pv0CaWA0NccUtena3s8Ac1kvTsTgbIs6jWM7C5DfcwZvz7bIVYA5LwMlHsx
         Pcgu19eXll8ZXEi/0Uoy3Nr8N8dPN1vY2hFvwOvtyJyibe2zZGRrDTVCsXN4avPlpykk
         TEgw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=jPDghSiMnJ5ArV1uIYx7OEKA+c/PzF9WfW5YPQOupgY=;
        b=l7OSN9geOkzQQxwt9LmLrHz+HN8IC1GlknVAw6yMuL3XWcQVaaJrhQl33m6pO5gRVK
         1pnGKZK2ym/fBtQ5oEt3tcv6m+oE83aduvP/SYJi1XHadqz3uqiUUdvOUiLp6G8R9dEz
         TjNmCNHe7CHb+6gJ5+tLFRNDxL14Zo49wGPN4RaNE2KTBhNPNkloBIzXUez3KwLmBArW
         StFC9VKsXsVNwSbgCRp0zAFPLNs4jxYsmRbpc5f2qaViVmvVLB3ISS0+Qk2c1HuDrcX8
         fa57QkOvA9Pm/Gi2tppsujbLv4Dk7X90/Mj1dWdq4mMIxi2aqAFtZ3/HriIXKWE4+OcT
         jckQ==
X-Gm-Message-State: APjAAAVRTSrRBEiuGZpyde5icH61LCZZnMZPbZe0ySUrQ67HMcEj90l6
        ySE8JnZXpz942EwZqnBhZ1bRangLiNbb8eaVBamZ3/Qyv/k=
X-Google-Smtp-Source: APXvYqwk30M8awXgsAAgyvb+CdP5ySHOqKFoKZIEg+t7QwtQEookdEac9ubtkRhdkERJkYjRqYSBOANw2AzhDjoV4eE=
X-Received: by 2002:a05:6214:38c:: with SMTP id l12mr7977822qvy.224.1581525240789;
 Wed, 12 Feb 2020 08:34:00 -0800 (PST)
MIME-Version: 1.0
References: <20200208154209.1797988-1-jolsa@kernel.org> <20200208154209.1797988-13-jolsa@kernel.org>
 <CAEf4BzZFBYVAs5-LowuMov86cbNFdXABkcA=XZAC2JJWg52HKg@mail.gmail.com> <20200212111000.GE183981@krava>
In-Reply-To: <20200212111000.GE183981@krava>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Wed, 12 Feb 2020 08:33:49 -0800
Message-ID: <CAEf4BzZEVOZ36xx882WO30ReG=jkazug-gmWnXhxmA8Ka6PuhQ@mail.gmail.com>
Subject: Re: [PATCH 12/14] bpf: Add trampolines to kallsyms
To:     Jiri Olsa <jolsa@redhat.com>
Cc:     Jiri Olsa <jolsa@kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Andrii Nakryiko <andriin@fb.com>, Yonghong Song <yhs@fb.com>,
        Song Liu <songliubraving@fb.com>,
        Martin KaFai Lau <kafai@fb.com>,
        Jakub Kicinski <kuba@kernel.org>,
        David Miller <davem@redhat.com>,
        =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@intel.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Jesper Dangaard Brouer <hawk@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Feb 12, 2020 at 3:10 AM Jiri Olsa <jolsa@redhat.com> wrote:
>
> On Tue, Feb 11, 2020 at 10:51:27AM -0800, Andrii Nakryiko wrote:
> > On Sat, Feb 8, 2020 at 7:43 AM Jiri Olsa <jolsa@kernel.org> wrote:
> > >
> > > Adding trampolines to kallsyms. It's displayed as
> > >   bpf_trampoline_<ID> [bpf]
> > >
> > > where ID is the BTF id of the trampoline function.
> > >
> > > Signed-off-by: Jiri Olsa <jolsa@kernel.org>
> > > ---
> > >  include/linux/bpf.h     |  2 ++
> > >  kernel/bpf/trampoline.c | 23 +++++++++++++++++++++++
> > >  2 files changed, 25 insertions(+)
> > >
> > > diff --git a/include/linux/bpf.h b/include/linux/bpf.h
> > > index 7a4626c8e747..b91bac10d3ea 100644
> > > --- a/include/linux/bpf.h
> > > +++ b/include/linux/bpf.h
> > > @@ -502,6 +502,7 @@ struct bpf_trampoline {
> > >         /* Executable image of trampoline */
> > >         void *image;
> > >         u64 selector;
> > > +       struct bpf_ksym ksym;
> > >  };
> > >
> > >  #define BPF_DISPATCHER_MAX 48 /* Fits in 2048B */
> > > @@ -573,6 +574,7 @@ struct bpf_image {
> > >  #define BPF_IMAGE_SIZE (PAGE_SIZE - sizeof(struct bpf_image))
> > >  bool is_bpf_image_address(unsigned long address);
> > >  void *bpf_image_alloc(void);
> > > +void bpf_image_ksym_add(void *data, struct bpf_ksym *ksym);
> > >  /* Called only from code, so there's no need for stubs. */
> > >  void bpf_ksym_add(struct bpf_ksym *ksym);
> > >  void bpf_ksym_del(struct bpf_ksym *ksym);
> > > diff --git a/kernel/bpf/trampoline.c b/kernel/bpf/trampoline.c
> > > index 6b264a92064b..1ee29907cbe5 100644
> > > --- a/kernel/bpf/trampoline.c
> > > +++ b/kernel/bpf/trampoline.c
> > > @@ -96,6 +96,15 @@ bool is_bpf_image_address(unsigned long addr)
> > >         return ret;
> > >  }
> > >
> > > +void bpf_image_ksym_add(void *data, struct bpf_ksym *ksym)
> > > +{
> > > +       struct bpf_image *image = container_of(data, struct bpf_image, data);
> > > +
> > > +       ksym->start = (unsigned long) image;
> > > +       ksym->end = ksym->start + PAGE_SIZE;
> >
> > this seems wrong, use BPF_IMAGE_SIZE instead of PAGE_SIZE?
>
> BPF_IMAGE_SIZE is the size of the data portion of the image,
> which is PAGE_SIZE - sizeof(struct bpf_image)
>
> here we want to account the whole size = data + tree node (struct bpf_image)

Why? Seems like the main use case for this is resolve IP to symbol
(function, dispatcher, trampoline, bpf program, etc). For this
purpose, you only need part of trampoline actually containing
executable code?

Also, for bpf_dispatcher in later patch, you are not including struct
bpf_dispatcher itself, you only include image, so if the idea is to
include all the code and supporting data structures, that already
failed for bpf_dispatcher (and can't even work for that case, due to
dispatcher and image not being part of the same blob of memory, so
you'll need two symbols).

So I guess it would be good to be clear on why we include these
symbols and not mix data and executable parts.

>
> >
> > > +       bpf_ksym_add(ksym);
> > > +}
> > > +
> > >  struct bpf_trampoline *bpf_trampoline_lookup(u64 key)
> > >  {
> > >         struct bpf_trampoline *tr;
> > > @@ -131,6 +140,7 @@ struct bpf_trampoline *bpf_trampoline_lookup(u64 key)
> > >         for (i = 0; i < BPF_TRAMP_MAX; i++)
> > >                 INIT_HLIST_HEAD(&tr->progs_hlist[i]);
> > >         tr->image = image;
> > > +       INIT_LIST_HEAD_RCU(&tr->ksym.lnode);
> > >  out:
> > >         mutex_unlock(&trampoline_mutex);
> > >         return tr;
> > > @@ -267,6 +277,15 @@ static enum bpf_tramp_prog_type bpf_attach_type_to_tramp(enum bpf_attach_type t)
> > >         }
> > >  }
> > >
> > > +static void bpf_trampoline_kallsyms_add(struct bpf_trampoline *tr)
> > > +{
> > > +       struct bpf_ksym *ksym = &tr->ksym;
> > > +
> > > +       snprintf(ksym->name, KSYM_NAME_LEN, "bpf_trampoline_%llu",
> > > +                tr->key & ((u64) (1LU << 32) - 1));
> >
> > why the 32-bit truncation? also, wouldn't it be more trivial as (u32)tr->key?
>
> tr->key can have the target prog id in upper 32 bits,

True, but not clear why it's bad? It's not a security concern, because
those IDs are already exposed (you can dump them from bpftool). On the
other hand, by cutting out part of key, you make symbols potentially
ambiguous, with different trampolines marked with the same name in
kallsyms, which is just going to be confusing to users/tools.

> I'll try to use the casting as you suggest
>
> >
> > > +       bpf_image_ksym_add(tr->image, &tr->ksym);
> > > +}
> > > +
> > >  int bpf_trampoline_link_prog(struct bpf_prog *prog)
> > >  {
> > >         enum bpf_tramp_prog_type kind;
> > > @@ -311,6 +330,8 @@ int bpf_trampoline_link_prog(struct bpf_prog *prog)
> > >         if (err) {
> > >                 hlist_del(&prog->aux->tramp_hlist);
> > >                 tr->progs_cnt[kind]--;
> > > +       } else if (cnt == 0) {
> > > +               bpf_trampoline_kallsyms_add(tr);
> >
> > You didn't handle BPF_TRAMP_REPLACE case above.
>
> ugh, right.. will add
>
> >
> > Also this if (err) { ... } else if (cnt == 0) { } pattern is a bit
> > convoluted. How about:
> >
> > if (err) {
> >    ... whatever ...
> >    goto out;
> > }
> > if (cnt == 0) { ... }
>
> yep, that's better
>
> >
> > >         }
> > >  out:
> > >         mutex_unlock(&tr->mutex);
> > > @@ -336,6 +357,8 @@ int bpf_trampoline_unlink_prog(struct bpf_prog *prog)
> > >         }
> > >         hlist_del(&prog->aux->tramp_hlist);
> > >         tr->progs_cnt[kind]--;
> > > +       if (!(tr->progs_cnt[BPF_TRAMP_FENTRY] + tr->progs_cnt[BPF_TRAMP_FEXIT]))
> > > +               bpf_ksym_del(&tr->ksym);
> >
> > same, BPF_TRAMP_REPLACE case. I'd also introduce cnt for consistency
> > with bpf_trampoline_link_prog?
>
> ok, thanks a lot for comments

sure, you are welcome :)

>
> jirka
>

Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C75281DA547
	for <lists+netdev@lfdr.de>; Wed, 20 May 2020 01:23:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728085AbgESXXc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 May 2020 19:23:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56062 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725998AbgESXXb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 May 2020 19:23:31 -0400
Received: from mail-qt1-x843.google.com (mail-qt1-x843.google.com [IPv6:2607:f8b0:4864:20::843])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 52DB7C061A0E;
        Tue, 19 May 2020 16:23:31 -0700 (PDT)
Received: by mail-qt1-x843.google.com with SMTP id l1so1148133qtp.6;
        Tue, 19 May 2020 16:23:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=NFJWmr9KEQenea6GLlA4NPI5u/eetb0vSSE/zevqVR8=;
        b=vNdj6UMXyvgwDduOT4er4unGN5wDblCw0+Ab0NfuU0I8dqnG+Z/bw8oWQ220TUSEFS
         9C7YFw8x77GkmrhRSrFhfDgW5hr4/zWkbFCZUmqceZY78dteRdezHotGKRirdhJzRyDX
         gwvTHKz2YOjAKJ+hddHNYu8HWEerwQuah8zNLsMZkIdpx/zgfqCJOSGDG7FrEaa6GbPC
         eYPg9+xqwwkql3xKO5l1k9j04U/SgMHgOdSRfG42Qw2sI9DplCuRM5GOn/LcKWRIN28x
         HOpOY8NCgky6lDmwqp0COLRwGHrEFGmrjmZKIh65HklgkFALEzqVJLGI3w3C/4JSnb8F
         Po+A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=NFJWmr9KEQenea6GLlA4NPI5u/eetb0vSSE/zevqVR8=;
        b=ls2wgnqH4W3bkOusUAAebZe4S51rTsXbL42jOiFqeROhUDa5mbO44SeZycfKykTKc4
         AyjxmuyW5IPJQydVw29rMrI6vi225g3s+1NMnwc8oOdXDUILVJS14a93A/LWNuGIzsTM
         fHJF1s2nwVOzqt+ZY+fV3UNS9w+bcHA4lBbNBEFtHUHRsCi3J/5VOWrGPZ7N8LMZgQpX
         OsZ2Adb9c0q3MsAmPE9boVtkogFPlBSHFEIfH0R8CkTFz2JVj/1KtBHGW8bdzBc/lPTR
         jTmKZFIHdLSkoGUPkByhKfZ5snxvuma+MlstTfDpzco+25NSNTxKK1I9KkIBX9FLqR3z
         arAA==
X-Gm-Message-State: AOAM531GLTVenDtxhqEl1LyrKftXUoVo/yBPjM88hwXAnPlQC16d9NsO
        432qhngY2FLHQSt7Q7cu1vdtnY8D4HrjQNMrOjE=
X-Google-Smtp-Source: ABdhPJw+dMIn/pO2zy7FCuRRntxfQbpMxTMPiZItj2lBvlPBO0PJfykSo2IeLmE9XmYkvhnBS9zbx7ycD+qwaF3AXPM=
X-Received: by 2002:aed:2f02:: with SMTP id l2mr2472522qtd.117.1589930609786;
 Tue, 19 May 2020 16:23:29 -0700 (PDT)
MIME-Version: 1.0
References: <CAG=TAF6mfrwxF1-xEJJ9dL675uMUa7RZrOa_eL2mJizZJ-U7iQ@mail.gmail.com>
 <CAEf4BzazvGOoJbm+zNMqTjhTPJAnVLVv9V=rXkdXZELJ4FPtiA@mail.gmail.com>
 <CAG=TAF6aqo-sT2YE30riqp7f47KyXH_uhNJ=M9L12QU6EEEfqQ@mail.gmail.com>
 <CAEf4BzaBfnDL=WpRP-7rYFhocOsCQyFuZaLvM0+k9sv2t_=rVw@mail.gmail.com>
 <CAG=TAF5rYmMXBcxno0pPxVZdcyz=ik-enh03E-V8wupjDS0K5g@mail.gmail.com>
 <CAEf4BzYZ9LkYtmiukToJDw1-V-AFbwfB2jysMU9mM3ie9=qWHw@mail.gmail.com> <CAG=TAF45T4pKew6U2kPNBK0qSAjgoECAX81obmKmFnv0cjE-oA@mail.gmail.com>
In-Reply-To: <CAG=TAF45T4pKew6U2kPNBK0qSAjgoECAX81obmKmFnv0cjE-oA@mail.gmail.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Tue, 19 May 2020 16:23:18 -0700
Message-ID: <CAEf4BzZKCh7+2TL8GVetxrOKYCoL0U7jTGsO5CbDExs7Px+bYQ@mail.gmail.com>
Subject: Re: UBSAN: array-index-out-of-bounds in kernel/bpf/arraymap.c:177
To:     Qian Cai <cai@lca.pw>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andriin@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>,
        Linux Netdev List <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        clang-built-linux <clang-built-linux@googlegroups.com>,
        Kees Cook <keescook@chromium.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, May 19, 2020 at 1:18 PM Qian Cai <cai@lca.pw> wrote:
>
> On Tue, May 19, 2020 at 3:30 PM Andrii Nakryiko
> <andrii.nakryiko@gmail.com> wrote:
> >
> > On Tue, May 19, 2020 at 8:00 AM Qian Cai <cai@lca.pw> wrote:
> > >
> > > On Mon, May 18, 2020 at 8:25 PM Andrii Nakryiko
> > > <andrii.nakryiko@gmail.com> wrote:
> > > >
> > > > On Mon, May 18, 2020 at 5:09 PM Qian Cai <cai@lca.pw> wrote:
> > > > >
> > > > > On Mon, May 18, 2020 at 7:55 PM Andrii Nakryiko
> > > > > <andrii.nakryiko@gmail.com> wrote:
> > > > > >
> > > > > > On Sun, May 17, 2020 at 7:45 PM Qian Cai <cai@lca.pw> wrote:
> > > > > > >
> > > > > > > With Clang 9.0.1,
> > > > > > >
> > > > > > > return array->value + array->elem_size * (index & array->index_mask);
> > > > > > >
> > > > > > > but array->value is,
> > > > > > >
> > > > > > > char value[0] __aligned(8);
> > > > > >
> > > > > > This, and ptrs and pptrs, should be flexible arrays. But they are in a
> > > > > > union, and unions don't support flexible arrays. Putting each of them
> > > > > > into anonymous struct field also doesn't work:
> > > > > >
> > > > > > /data/users/andriin/linux/include/linux/bpf.h:820:18: error: flexible
> > > > > > array member in a struct with no named members
> > > > > >    struct { void *ptrs[] __aligned(8); };
> > > > > >
> > > > > > So it probably has to stay this way. Is there a way to silence UBSAN
> > > > > > for this particular case?
> > > > >
> > > > > I am not aware of any way to disable a particular function in UBSAN
> > > > > except for the whole file in kernel/bpf/Makefile,
> > > > >
> > > > > UBSAN_SANITIZE_arraymap.o := n
> > > > >
> > > > > If there is no better way to do it, I'll send a patch for it.
> > > >
> > > >
> > > > That's probably going to be too drastic, we still would want to
> > > > validate the rest of arraymap.c code, probably. Not sure, maybe
> > > > someone else has better ideas.
> > >
> > > This works although it might makes sense to create a pair of
> > > ubsan_disable_current()/ubsan_enable_current() for it.
> > >
> > > diff --git a/kernel/bpf/arraymap.c b/kernel/bpf/arraymap.c
> > > index 11584618e861..6415b089725e 100644
> > > --- a/kernel/bpf/arraymap.c
> > > +++ b/kernel/bpf/arraymap.c
> > > @@ -170,11 +170,16 @@ static void *array_map_lookup_elem(struct
> > > bpf_map *map, void *key)
> > >  {
> > >         struct bpf_array *array = container_of(map, struct bpf_array, map);
> > >         u32 index = *(u32 *)key;
> > > +       void *elem;
> > >
> > >         if (unlikely(index >= array->map.max_entries))
> > >                 return NULL;
> > >
> > > -       return array->value + array->elem_size * (index & array->index_mask);
> > > +       current->in_ubsan++;
> > > +       elem = array->value + array->elem_size * (index & array->index_mask);
> > > +       current->in_ubsan--;
> >
> > This is an unnecessary performance hit for silencing what is clearly a
> > false positive. I'm not sure that's the right solution here. It seems
> > like something that's lacking on the tooling side instead. C language
> > doesn't allow to express the intent here using flexible array
> > approach. That doesn't mean that what we are doing here is wrong or
> > undefined.
>
> Oh, so you worry about this ++ and -- hurt the performance? If so, how
> about this?
>
> ubsan_disable_current();
> elem = array->value + array->elem_size * (index & array->index_mask);
> ubsan_enable_current();
>
> #ifdef UBSAN
> ubsan_disable_current()
> {
>       current->in_ubsan++;
> }
> #else
> ubsan_disable_current() {}
> #endif
>
> etc
>
> Production kernel would normally have UBSAN=n, so it is an noop.

That would solve runtime performance hit, yes.

>
> Leaving this false positive unsilenced may also waste many people's
> time over and over again, and increase the noisy level. Especially, it
> seems this is one-off (not seen other parts of kernel doing like this)
> and rather expensive to silence it in the UBSAN or/and compilers.

I agree, it's bad to have this noise. But again, there is nothing
wrong with the way it's used in BPF code base. We'd gladly use
flexible array, if we could. But given we can't, I'd say the proper
solution (in order of my preference) would be:

  - don't trigger false error, if zero-sized array is the member of union;
  - or have some sort of annotation at field declaration site (not a
field access site).

Is that possible?

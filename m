Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 687C11DA107
	for <lists+netdev@lfdr.de>; Tue, 19 May 2020 21:30:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726806AbgESTaK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 May 2020 15:30:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47406 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726059AbgESTaK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 May 2020 15:30:10 -0400
Received: from mail-qt1-x844.google.com (mail-qt1-x844.google.com [IPv6:2607:f8b0:4864:20::844])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F096CC08C5C0;
        Tue, 19 May 2020 12:30:09 -0700 (PDT)
Received: by mail-qt1-x844.google.com with SMTP id n22so567438qtv.12;
        Tue, 19 May 2020 12:30:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=JLNTKuWXG5RL22GiqkJEO67M5+yDAhwqj8vxR1pC9Pc=;
        b=EmfmIBE2lvjkW0+zUQudmRZciASPLFo2EKpqAG/Tz9Uw9YulJE1h0sVQPNn7eIjH77
         MDYOvZ07qpNts20VQPNDx5dMX8cIesvElbn4ICM80h0kR3yoRXXicI0fvj52xGv4c/Bv
         kJeyVmKHuLsYCP0DW6c+HxtMqXPzR1Vf1SnDsamSEsbaVgtgo7BG4oi525yT8Hxadx/z
         BmIaFhw+MSqgffVhBNiEC8EYkAPM7RYwDcn1fBiPxV7zwCuTSnAlEHRqPqC82grv3dR+
         UjA/whjYPkottaONimBQxVeLe9tdFMww8nDqdEWSUck7RHwmVxQd2WHmQFchcStMpzBP
         jHmg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=JLNTKuWXG5RL22GiqkJEO67M5+yDAhwqj8vxR1pC9Pc=;
        b=pcC1EWUABJd0XXMEM+8Z06lQLbluilNgeHW6RJus2o3Ws0H0mhv64XJRuXjaZgbu3V
         5LRnv4d8HWu9dXCc/py89O+7S4kyJVFPh5pATl6qilWp6fQyVhX6B+hFwHw/7Rdt7c06
         JeoAVbgjPAiWSfvhGyDzhbSosY1Q5SQ8u174F3OtyW73uhSu+Fj0V/wbrLqOUP2eZXft
         oxmVb6li3w2Wj2svtrG+CnRDpybqZ2bUoQPpuE6QjybAQOrwb3LXJPDRMJC0haWrpGcf
         xvGTjz5Pm9J02DDR0Onx4/qkUHauRwjjZteZkSzyyJvmjFk+vfZhwBhtQ2tbDAXedjWL
         PtAA==
X-Gm-Message-State: AOAM531t3VJ6V3lY0tguXuQZjFZucDFMrcDesT0I6woqoop+3EzkjUrA
        u6hgbKINrw4UNu7vcBv55T8Vs9ez/hyVbo75e3M=
X-Google-Smtp-Source: ABdhPJwRaU0akqgR7ea2OCOB05lC2WOR2l+OUAjjbltd9BouYVuxmZ60MdRKIvD/l1Eiowo03a/JD2Gk3HRI6dpjqyA=
X-Received: by 2002:ac8:1ae7:: with SMTP id h36mr1504281qtk.59.1589916609195;
 Tue, 19 May 2020 12:30:09 -0700 (PDT)
MIME-Version: 1.0
References: <CAG=TAF6mfrwxF1-xEJJ9dL675uMUa7RZrOa_eL2mJizZJ-U7iQ@mail.gmail.com>
 <CAEf4BzazvGOoJbm+zNMqTjhTPJAnVLVv9V=rXkdXZELJ4FPtiA@mail.gmail.com>
 <CAG=TAF6aqo-sT2YE30riqp7f47KyXH_uhNJ=M9L12QU6EEEfqQ@mail.gmail.com>
 <CAEf4BzaBfnDL=WpRP-7rYFhocOsCQyFuZaLvM0+k9sv2t_=rVw@mail.gmail.com> <CAG=TAF5rYmMXBcxno0pPxVZdcyz=ik-enh03E-V8wupjDS0K5g@mail.gmail.com>
In-Reply-To: <CAG=TAF5rYmMXBcxno0pPxVZdcyz=ik-enh03E-V8wupjDS0K5g@mail.gmail.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Tue, 19 May 2020 12:29:58 -0700
Message-ID: <CAEf4BzYZ9LkYtmiukToJDw1-V-AFbwfB2jysMU9mM3ie9=qWHw@mail.gmail.com>
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

On Tue, May 19, 2020 at 8:00 AM Qian Cai <cai@lca.pw> wrote:
>
> On Mon, May 18, 2020 at 8:25 PM Andrii Nakryiko
> <andrii.nakryiko@gmail.com> wrote:
> >
> > On Mon, May 18, 2020 at 5:09 PM Qian Cai <cai@lca.pw> wrote:
> > >
> > > On Mon, May 18, 2020 at 7:55 PM Andrii Nakryiko
> > > <andrii.nakryiko@gmail.com> wrote:
> > > >
> > > > On Sun, May 17, 2020 at 7:45 PM Qian Cai <cai@lca.pw> wrote:
> > > > >
> > > > > With Clang 9.0.1,
> > > > >
> > > > > return array->value + array->elem_size * (index & array->index_mask);
> > > > >
> > > > > but array->value is,
> > > > >
> > > > > char value[0] __aligned(8);
> > > >
> > > > This, and ptrs and pptrs, should be flexible arrays. But they are in a
> > > > union, and unions don't support flexible arrays. Putting each of them
> > > > into anonymous struct field also doesn't work:
> > > >
> > > > /data/users/andriin/linux/include/linux/bpf.h:820:18: error: flexible
> > > > array member in a struct with no named members
> > > >    struct { void *ptrs[] __aligned(8); };
> > > >
> > > > So it probably has to stay this way. Is there a way to silence UBSAN
> > > > for this particular case?
> > >
> > > I am not aware of any way to disable a particular function in UBSAN
> > > except for the whole file in kernel/bpf/Makefile,
> > >
> > > UBSAN_SANITIZE_arraymap.o := n
> > >
> > > If there is no better way to do it, I'll send a patch for it.
> >
> >
> > That's probably going to be too drastic, we still would want to
> > validate the rest of arraymap.c code, probably. Not sure, maybe
> > someone else has better ideas.
>
> This works although it might makes sense to create a pair of
> ubsan_disable_current()/ubsan_enable_current() for it.
>
> diff --git a/kernel/bpf/arraymap.c b/kernel/bpf/arraymap.c
> index 11584618e861..6415b089725e 100644
> --- a/kernel/bpf/arraymap.c
> +++ b/kernel/bpf/arraymap.c
> @@ -170,11 +170,16 @@ static void *array_map_lookup_elem(struct
> bpf_map *map, void *key)
>  {
>         struct bpf_array *array = container_of(map, struct bpf_array, map);
>         u32 index = *(u32 *)key;
> +       void *elem;
>
>         if (unlikely(index >= array->map.max_entries))
>                 return NULL;
>
> -       return array->value + array->elem_size * (index & array->index_mask);
> +       current->in_ubsan++;
> +       elem = array->value + array->elem_size * (index & array->index_mask);
> +       current->in_ubsan--;

This is an unnecessary performance hit for silencing what is clearly a
false positive. I'm not sure that's the right solution here. It seems
like something that's lacking on the tooling side instead. C language
doesn't allow to express the intent here using flexible array
approach. That doesn't mean that what we are doing here is wrong or
undefined.

> +
> +       return elem;
>  }

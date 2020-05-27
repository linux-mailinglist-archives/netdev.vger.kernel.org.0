Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 71EE91E508B
	for <lists+netdev@lfdr.de>; Wed, 27 May 2020 23:33:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727899AbgE0Vd1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 May 2020 17:33:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54208 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726129AbgE0Vd0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 May 2020 17:33:26 -0400
Received: from mail-qt1-x842.google.com (mail-qt1-x842.google.com [IPv6:2607:f8b0:4864:20::842])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C3B96C05BD1E;
        Wed, 27 May 2020 14:33:24 -0700 (PDT)
Received: by mail-qt1-x842.google.com with SMTP id g18so3656933qtu.13;
        Wed, 27 May 2020 14:33:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=fxtUP+fWIp3dwg1JcjyXsNPnXoOQD/0uIPaUAzDSEdI=;
        b=lqZp7hodjNYIblf3qy9d8xKmhHMTYvlk5LCYpDH2tVMZM9eJIC8AbyI4e424EIJV1l
         HmqzEvrubvGDkvDLfOsYsjxqMgF/vI3PxHjNf4g8vfKr9ZacU4K1SghxIyJtfvc+NFtM
         DeG8pXyfgIFrSq9m3QZG+1SPkwyH3kOicG04naqhDeOgwkuUVoQOWPHSO8LBibLRa/a8
         WPz4WboLv+g2/0eQ8CbL0jqZV0V7Um0nIDr6ZRGYzobKYGgK3AjAIgEfEK3XRiw9sE3P
         a1wd9SIc+VscnMc/V8sfTvbuyUx7RJLvCOAV+erOOZtZJT/jgRIwoODVgDJO9fGYumQq
         jsnw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=fxtUP+fWIp3dwg1JcjyXsNPnXoOQD/0uIPaUAzDSEdI=;
        b=LVfaZPWW+m5/P39FgPRgRb5VpYqxOrD6TY9TC3f8eVxoVj8QD4SdcoJ957uJpH7bZN
         FPQdimR6PhdwBhYSE+3Pru36SPcueWbyC7y4IumwBL5BVyoklVhMgFVCSBoGUHIDDgHn
         +3noMOvygxv1ojxtKRekbrz3Uwgo9bAJUaVVtw5/zW2JiITaP9a9yFIw6ZLZYjGVfAgI
         OjnnSUqasAtESHE1qA6LuSfnKTTQnJpnZxim94XHBNL7NAWHtB7rc26PmqwjW7VbKTYX
         cslJ8Lq0dRcgmBJ5LliWGi8HdqvZ1KxHZi/B8U+Ua3et7gxXdB3NCqg98ezngBN8Ulrh
         xf8Q==
X-Gm-Message-State: AOAM530wAoECKSFE8Ri5Bvl/XG5FXTvtSv/BurknNZkStTEaJ+8MeNxm
        fiWT2o/NcOWunGQL4Lu3IisEWYoykEJPIfzKmjk=
X-Google-Smtp-Source: ABdhPJysT7IaBz2s6N7KxEiB3FydbmotssYLzUhVNjYk+ltaVr1JjXVXPOiUz4qTkVtrDUHeCvM6/jn/xurVMWsWknE=
X-Received: by 2002:ac8:42ce:: with SMTP id g14mr6437895qtm.117.1590615203771;
 Wed, 27 May 2020 14:33:23 -0700 (PDT)
MIME-Version: 1.0
References: <CAEf4BzbR+7X-boCBC-f60jugp8xWKVTeFTyUmrcv8Qy4iKsvjg@mail.gmail.com>
 <C31OATROKNZK.27CUNDSXX9I4K@maharaja>
In-Reply-To: <C31OATROKNZK.27CUNDSXX9I4K@maharaja>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Wed, 27 May 2020 14:33:12 -0700
Message-ID: <CAEf4BzYP0gf9wKonV6vkXxR4c9dsVfqJr0-tCXU_3j_R98k9FA@mail.gmail.com>
Subject: Re: [PATCH bpf-next] libbpf: Export bpf_object__load_vmlinux_btf
To:     Daniel Xu <dxu@dxuuu.xyz>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin Lau <kafai@fb.com>, Song Liu <songliubraving@fb.com>,
        Yonghong Song <yhs@fb.com>, Andrii Nakryiko <andriin@fb.com>,
        john fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        bpf <bpf@vger.kernel.org>, Networking <netdev@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>,
        clang-built-linux <clang-built-linux@googlegroups.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, May 27, 2020 at 10:12 AM Daniel Xu <dxu@dxuuu.xyz> wrote:
>
> Hi Andrii,
>
> On Tue May 26, 2020 at 3:09 PM PST, Andrii Nakryiko wrote:
> > On Tue, May 26, 2020 at 7:09 PM Daniel Xu <dxu@dxuuu.xyz> wrote:
> > >
> > > Right now the libbpf model encourages loading the entire object at once.
> > > In this model, libbpf handles loading BTF from vmlinux for us. However,
> > > it can be useful to selectively load certain maps and programs inside an
> > > object without loading everything else.
> >
> > There is no way to selectively load or not load a map. All maps are
> > created, unless they are reusing map FD or pinned instances. See
> > below, I'd like to understand the use case better.
> >
> > >
> > > In the latter model, there was perviously no way to load BTF on-demand.
> > > This commit exports the bpf_object__load_vmlinux_btf such that we are
> > > able to load BTF on demand.
> > >
> >
> > Let's start with the real problem, not a solution. Do you have
> > specific use case where you need bpf_object__load_vmlinux_btf()? It
> > might not do anything if none of BPF programs in the object requires
> > BTF, because it's very much tightly coupled with loading bpf_object as
> > a whole model. I'd like to understand what you are after with this,
> > before exposing internal implementation details as an API.
>
> If I try loading a program through the following sequence:
>
>     bpf_object__open_file()
>     bpf_object__find_program_by_name()
>     bpf_program__load()
>

bpf_program__load() is just broken and shouldn't have been ever
exposed. It **might** work for trivial BPF programs not using maps,
Kconfig and global variables, etc, but more by accident. I think the
right fix for your use-case is to allow more control of which programs
are auto-loaded. There was a patch by Eric Sage previously adding
bpf_program__set_autoload(), but it never landed. We should actually
do that approach instead.

> And the program require BTF (tp_btf), I get an unavoidable (to the best
> of my knowledge) segfault in the following code path:
>
>     bpf_program__load()
>       libbpf_find_attach_btf_id()    <-- [0]
>         __find_vmlinx_btf_id()
>           find_btf_by_prefix_kind()
>             btf__find_by_name_kind() <-- boom (btf->nr_types)
>
> because [0] passes prog->obj->btf_vmlinux which is still null. So the
> solution I'm proposing is exporting bpf_object__load_vmlinux_btf() and
> calling that on struct bpf_object before performing prog loads.
>
> [...]
>
> Thanks,
> Daniel

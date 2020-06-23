Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 33CD1205B4D
	for <lists+netdev@lfdr.de>; Tue, 23 Jun 2020 20:58:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733302AbgFWS6q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Jun 2020 14:58:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39728 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1733138AbgFWS6p (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 23 Jun 2020 14:58:45 -0400
Received: from mail-qk1-x742.google.com (mail-qk1-x742.google.com [IPv6:2607:f8b0:4864:20::742])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 65702C061573;
        Tue, 23 Jun 2020 11:58:45 -0700 (PDT)
Received: by mail-qk1-x742.google.com with SMTP id e13so1575141qkg.5;
        Tue, 23 Jun 2020 11:58:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Hm8MncAba0d07uZxTGbanApe6GFEaJ+ZLuWt1ecBMsI=;
        b=vfgYDgTTx9QGUL/xV8zFYlnIv9IU6HwXWsnn8togNKhCPWpOaL+EFkEBrXbqix+JiP
         tG9qVhiNUhXOTpWPghzO4HaQBei7IPa/u5h1SiZcoW8lJ+knKGDXOosgSND/y95FAbRj
         Eq497faHhHBoSoTd5pnnflFUAchSoF2vt0JG5g91wF3XRpMe4uRUq+MPh1tvAhPcvpIM
         P5tAS6c1FVyatn5CkPWHxYrKn9S0WJB+c9+opFS/0TgMkBJ6zidetaqBxVV5HINUYznj
         vHG2i7/bXZPKofsKs5SFKk0i+RM7NAZ6dJmmQ0VEWjL60OSDDPFDVon9jTgb9ANs1Y3e
         t+Yw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Hm8MncAba0d07uZxTGbanApe6GFEaJ+ZLuWt1ecBMsI=;
        b=EiV26LziMCq3qXOgKpT3uZh8iatsZZHPBFGl8UQIaU5uVfhpyFayoTeXhRz2EEs1es
         iIGFZR4xQjQ0GXvh4I1XL2KzCGyH5EK6Ma2xtpdLZNbgzrs2PkZZfZkbaCn6LdlWfR4X
         mDfB0jw2EegK5bwcoLe85eh7BPhKT78WGFw7FOu35guHovxZQ/P5ALw32OM13VM6QPQy
         w+5AVQrjE8UzNm+sqlq72ifwUzK66z9J8xFpXvlvhZZRDpWvjSn9qiBHtv09eRVNFwdR
         LVClTrdyLKgCaaFD64K4tIhqBs6r4ZHUUDhZxjM9Iyuy+vlt6dJOUBPPX9uRV6MzS9RF
         Xc8w==
X-Gm-Message-State: AOAM5310aFB8XZknTlryEOh+1WhOVyz4JlT8gFbGc+6/XgIxXgR65H0m
        HPFRLhOMRa6MPgnkUHnHSSwoGPXBgcBznQALNptKCA8m
X-Google-Smtp-Source: ABdhPJxsmZ+ZPp6zHAM2E98+rvkAnAjn0qdnRmf6zdMKuXC7zfCdEhOSmVhnzRfj+q79fs88w/tEsA675d5UVOk7KNU=
X-Received: by 2002:a05:620a:b84:: with SMTP id k4mr21911096qkh.39.1592938724542;
 Tue, 23 Jun 2020 11:58:44 -0700 (PDT)
MIME-Version: 1.0
References: <20200616100512.2168860-1-jolsa@kernel.org> <20200616100512.2168860-10-jolsa@kernel.org>
 <CAEf4BzY=d5y_-fXvomG7SjkbK7DZn5=-f+sdCYRdZh9qeynQrQ@mail.gmail.com>
 <20200619133124.GJ2465907@krava> <CAEf4BzZDCtW-5r5rN+ufZi1hUXjw8QCF+CiyT5sOvQQEEOqtiQ@mail.gmail.com>
 <20200622090205.GD2556590@krava> <CAEf4BzZOph2EJLfq9FCYUhesi5NP0L_OQTrEKE-s0NPmt3HmWw@mail.gmail.com>
 <20200623100230.GA2619137@krava>
In-Reply-To: <20200623100230.GA2619137@krava>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Tue, 23 Jun 2020 11:58:33 -0700
Message-ID: <CAEf4BzZ=oYo6TiROpHQWpQ8Mn1CwONLSx44QJ0pqQH=9OUTWTQ@mail.gmail.com>
Subject: Re: [PATCH 09/11] bpf: Add d_path helper
To:     Jiri Olsa <jolsa@redhat.com>
Cc:     Jiri Olsa <jolsa@kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Martin KaFai Lau <kafai@fb.com>,
        David Miller <davem@redhat.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Wenbo Zhang <ethercflow@gmail.com>,
        KP Singh <kpsingh@chromium.org>,
        Andrii Nakryiko <andriin@fb.com>,
        Brendan Gregg <bgregg@netflix.com>,
        Florent Revest <revest@chromium.org>,
        Al Viro <viro@zeniv.linux.org.uk>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jun 23, 2020 at 3:02 AM Jiri Olsa <jolsa@redhat.com> wrote:
>
> On Mon, Jun 22, 2020 at 12:18:19PM -0700, Andrii Nakryiko wrote:
> > On Mon, Jun 22, 2020 at 2:02 AM Jiri Olsa <jolsa@redhat.com> wrote:
> > >
> > > On Fri, Jun 19, 2020 at 11:25:27AM -0700, Andrii Nakryiko wrote:
> > >
> > > SNIP
> > >
> > > > > > >  /* integer value in 'imm' field of BPF_CALL instruction selects which helper
> > > > > > >   * function eBPF program intends to call
> > > > > > > diff --git a/kernel/bpf/btf_ids.c b/kernel/bpf/btf_ids.c
> > > > > > > index d8d0df162f04..853c8fd59b06 100644
> > > > > > > --- a/kernel/bpf/btf_ids.c
> > > > > > > +++ b/kernel/bpf/btf_ids.c
> > > > > > > @@ -13,3 +13,14 @@ BTF_ID(struct, seq_file)
> > > > > > >
> > > > > > >  BTF_ID_LIST(bpf_xdp_output_btf_ids)
> > > > > > >  BTF_ID(struct, xdp_buff)
> > > > > > > +
> > > > > > > +BTF_ID_LIST(bpf_d_path_btf_ids)
> > > > > > > +BTF_ID(struct, path)
> > > > > > > +
> > > > > > > +BTF_WHITELIST_ENTRY(btf_whitelist_d_path)
> > > > > > > +BTF_ID(func, vfs_truncate)
> > > > > > > +BTF_ID(func, vfs_fallocate)
> > > > > > > +BTF_ID(func, dentry_open)
> > > > > > > +BTF_ID(func, vfs_getattr)
> > > > > > > +BTF_ID(func, filp_close)
> > > > > > > +BTF_WHITELIST_END(btf_whitelist_d_path)
> > > > > >
> > > > > > Oh, so that's why you added btf_ids.c. Do you think centralizing all
> > > > > > those BTF ID lists in one file is going to be more convenient? I lean
> > > > > > towards keeping them closer to where they are used, as it was with all
> > > > > > those helper BTF IDS. But I wonder what others think...
> > > > >
> > > > > either way works for me, but then BTF_ID_* macros needs to go
> > > > > to include/linux/btf_ids.h header right?
> > > > >
> > > >
> > > > given it's internal API, I'd probably just put it in
> > > > include/linux/btf.h or include/linux/bpf.h, don't think we need extra
> > > > header just for these
> > >
> > > actually, I might end up with extra header, so it's possible
> > > to add selftest for this
> > >
> >
> > How does extra header help with selftest?
>
> to create binary with various lists defined like we do in kernel
> using the same macros..  and check they are properly made/sorted
>

So the problem here is that selftests don't have access to internal
(non-UAPI) linux/bpf.h header, right? Ok, that's a fair point.

> jirka
>

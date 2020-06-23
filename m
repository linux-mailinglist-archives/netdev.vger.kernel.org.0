Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 79DAB205DE0
	for <lists+netdev@lfdr.de>; Tue, 23 Jun 2020 22:20:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389567AbgFWURe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Jun 2020 16:17:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51786 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389553AbgFWURa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 23 Jun 2020 16:17:30 -0400
Received: from mail-qt1-x843.google.com (mail-qt1-x843.google.com [IPv6:2607:f8b0:4864:20::843])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CA054C061573;
        Tue, 23 Jun 2020 13:17:30 -0700 (PDT)
Received: by mail-qt1-x843.google.com with SMTP id i16so16440781qtr.7;
        Tue, 23 Jun 2020 13:17:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=03CqcO4PwFDG7OH/S8HOnH2tabZI+jSAbUHN5fhLgTo=;
        b=NXk5Ft3K25tFC2GhvAP2mERnwaF5i1fa4Zge4Xg3eHZl1JiA56FTm18KxJz5LrBfjw
         uKd2ElWQ6tRZPG7mXZywoMP0nZWzqpDJYMQH3Apn9XQFWDalBzqyjokwrXqJSHvSJYcK
         NlQWC3J5mMQmyEo83jFlBmGKQ4Bj/Pwo4cw+nCa+6L8YzXZP4fmNiy4DGmt+TZbK080O
         kuEwPjYnxNAxj/iizMR7aXfSVmTrlrZPmqEl0pDhqcuUOQTQEzTaCm8Pfvi/Cac0pG9b
         mnTjpQmJWNYg9FpLy6b3Z2NzTgw4NnVMFdMZBWLrMOPqA5bZ4Zx047qX62TNWnFUkvvN
         8inQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=03CqcO4PwFDG7OH/S8HOnH2tabZI+jSAbUHN5fhLgTo=;
        b=bwHxzMvabuPmga/s+qgc2Jb50kRy9X4NvW5stttm1nzS+r385AROduxFEI0f/4kirp
         qKSfybPe6MRiT3JOAZN81ciN6g8J9dF+EcidzYdk4c0a5a9YZl2SUjdGAehfnDLhDabR
         +IEDZmYSJs0eX8gVYkXLy0x9fI1HTisn2wiLJrIlw7e2fRmPB17yTyxWbQQusqJj41eb
         7bXhEHG5hC1IpyzEdRB+JdUVDfBMbRTATUPefoQRsfyBcvGsWai6IVYtlunnkPnqgt54
         wlco7H6BWVZJf2l+77yw4DVIB0tBZ45l1f6t9k1OwEFCt4u4uyOsHBRHN5ijdVSuQuVr
         RPGg==
X-Gm-Message-State: AOAM533BlNwfbgTyy7V/w02EUFwk/zsTqni8E80orNsAlroWZIJ0X1h8
        Ql0wSOJsaAfviYtniWPwh/pw2RUCj2qEW/oxWlQ=
X-Google-Smtp-Source: ABdhPJzt/Xub3Ksl6h82Ol9MM785Mo5UDRwmVzIlnjMlyoKa0cZ56Hbixf+pl0fdY3qSkIX2rXste/Nm52ESQy9Kh4s=
X-Received: by 2002:ac8:64b:: with SMTP id e11mr888570qth.117.1592943449923;
 Tue, 23 Jun 2020 13:17:29 -0700 (PDT)
MIME-Version: 1.0
References: <20200616100512.2168860-1-jolsa@kernel.org> <20200616100512.2168860-10-jolsa@kernel.org>
 <CAEf4BzY=d5y_-fXvomG7SjkbK7DZn5=-f+sdCYRdZh9qeynQrQ@mail.gmail.com>
 <20200619133124.GJ2465907@krava> <CAEf4BzZDCtW-5r5rN+ufZi1hUXjw8QCF+CiyT5sOvQQEEOqtiQ@mail.gmail.com>
 <20200622090205.GD2556590@krava> <CAEf4BzZOph2EJLfq9FCYUhesi5NP0L_OQTrEKE-s0NPmt3HmWw@mail.gmail.com>
 <20200623100230.GA2619137@krava> <CAEf4BzZ=oYo6TiROpHQWpQ8Mn1CwONLSx44QJ0pqQH=9OUTWTQ@mail.gmail.com>
 <20200623201447.GM2619137@krava>
In-Reply-To: <20200623201447.GM2619137@krava>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Tue, 23 Jun 2020 13:17:18 -0700
Message-ID: <CAEf4Bza0JJqC+VEYxCSJWugpfzt7qMG+=6yt64Es08ap3xNcPA@mail.gmail.com>
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

On Tue, Jun 23, 2020 at 1:14 PM Jiri Olsa <jolsa@redhat.com> wrote:
>
> On Tue, Jun 23, 2020 at 11:58:33AM -0700, Andrii Nakryiko wrote:
> > On Tue, Jun 23, 2020 at 3:02 AM Jiri Olsa <jolsa@redhat.com> wrote:
> > >
> > > On Mon, Jun 22, 2020 at 12:18:19PM -0700, Andrii Nakryiko wrote:
> > > > On Mon, Jun 22, 2020 at 2:02 AM Jiri Olsa <jolsa@redhat.com> wrote:
> > > > >
> > > > > On Fri, Jun 19, 2020 at 11:25:27AM -0700, Andrii Nakryiko wrote:
> > > > >
> > > > > SNIP
> > > > >
> > > > > > > > >  /* integer value in 'imm' field of BPF_CALL instruction selects which helper
> > > > > > > > >   * function eBPF program intends to call
> > > > > > > > > diff --git a/kernel/bpf/btf_ids.c b/kernel/bpf/btf_ids.c
> > > > > > > > > index d8d0df162f04..853c8fd59b06 100644
> > > > > > > > > --- a/kernel/bpf/btf_ids.c
> > > > > > > > > +++ b/kernel/bpf/btf_ids.c
> > > > > > > > > @@ -13,3 +13,14 @@ BTF_ID(struct, seq_file)
> > > > > > > > >
> > > > > > > > >  BTF_ID_LIST(bpf_xdp_output_btf_ids)
> > > > > > > > >  BTF_ID(struct, xdp_buff)
> > > > > > > > > +
> > > > > > > > > +BTF_ID_LIST(bpf_d_path_btf_ids)
> > > > > > > > > +BTF_ID(struct, path)
> > > > > > > > > +
> > > > > > > > > +BTF_WHITELIST_ENTRY(btf_whitelist_d_path)
> > > > > > > > > +BTF_ID(func, vfs_truncate)
> > > > > > > > > +BTF_ID(func, vfs_fallocate)
> > > > > > > > > +BTF_ID(func, dentry_open)
> > > > > > > > > +BTF_ID(func, vfs_getattr)
> > > > > > > > > +BTF_ID(func, filp_close)
> > > > > > > > > +BTF_WHITELIST_END(btf_whitelist_d_path)
> > > > > > > >
> > > > > > > > Oh, so that's why you added btf_ids.c. Do you think centralizing all
> > > > > > > > those BTF ID lists in one file is going to be more convenient? I lean
> > > > > > > > towards keeping them closer to where they are used, as it was with all
> > > > > > > > those helper BTF IDS. But I wonder what others think...
> > > > > > >
> > > > > > > either way works for me, but then BTF_ID_* macros needs to go
> > > > > > > to include/linux/btf_ids.h header right?
> > > > > > >
> > > > > >
> > > > > > given it's internal API, I'd probably just put it in
> > > > > > include/linux/btf.h or include/linux/bpf.h, don't think we need extra
> > > > > > header just for these
> > > > >
> > > > > actually, I might end up with extra header, so it's possible
> > > > > to add selftest for this
> > > > >
> > > >
> > > > How does extra header help with selftest?
> > >
> > > to create binary with various lists defined like we do in kernel
> > > using the same macros..  and check they are properly made/sorted
> > >
> >
> > So the problem here is that selftests don't have access to internal
> > (non-UAPI) linux/bpf.h header, right? Ok, that's a fair point.
>
> hm, how about we keep tools/include/linux/btf_ids.h copy
> like we do for other kernel headers

yes, I assumed you are going to do that

>
> jirka
>

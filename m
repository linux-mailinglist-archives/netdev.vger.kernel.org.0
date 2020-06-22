Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D1802203FF4
	for <lists+netdev@lfdr.de>; Mon, 22 Jun 2020 21:18:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728281AbgFVTSb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Jun 2020 15:18:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45608 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726308AbgFVTSa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 22 Jun 2020 15:18:30 -0400
Received: from mail-qt1-x842.google.com (mail-qt1-x842.google.com [IPv6:2607:f8b0:4864:20::842])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B7892C061573;
        Mon, 22 Jun 2020 12:18:30 -0700 (PDT)
Received: by mail-qt1-x842.google.com with SMTP id v19so11096732qtq.10;
        Mon, 22 Jun 2020 12:18:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=zUWrxO8L9/kU1qSxDxQyWOIHTSXGOu7H1Ujb2Wnde8U=;
        b=X6OYBvfVBRjP2/eZ360mQpBpFJthSAde4QnXKW03durSaAq2YNUGlIX9ohL7Ct6fly
         42q8UHU6NEqpaQfF59bTT22+wyFH3jW6NTHvbm2g5s1XiUJ9kiYsub+cT/Eyl10yMauw
         4DEKeEM6rhJ/8xe/np4wWSG9j8gGPhXrSvau25rKXt/eOqbRzuU1vCY6pXJVPWrmVAAY
         PkF19b424MqH7y/bRYg4r95wRy1vet4lPhdq5b7KX+SemNU1mmRgN1Ujs3xPl6vsoYdU
         MndVOTCcI64IA8y6h8hP9qOqKsb9DXyURBxHpB/unvCZDjrbbsnPxRlMYXa0LsqYxW2E
         D4xQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=zUWrxO8L9/kU1qSxDxQyWOIHTSXGOu7H1Ujb2Wnde8U=;
        b=O3pruL+oadXBx9ujey5qjgiA/cxlg605wYI7+S7ynP8EUJd1hA9t9KFbfXL8jWX0nw
         B4y5WYd1sX3o/yPKwgxj4YTld8zFBG0f+JUMZWwuWk2FAZbXJRKJAjNaN1lIyx3sHzUv
         /mr8dhfNY0CLBhOetygE+aLwFsRawlFGfYfiV9kin0nPyjNKM/aGEvzcNU36tINvVMxG
         DL5qPKbC0MqipAZ9jIXTo9tC61djXmNA/e5ccJzbTc3ebEBcJgFe+onrZrtdwzfGCyvT
         BTpFLk0vaV0JDBukF4qrHc4lW6UmxChzGqwHlCPNShbn6mT6T4VAaQU2JcuZTpY4ZRgQ
         2lkA==
X-Gm-Message-State: AOAM531dXlAljaf3pQQihwg/nofK9PeumBqOFC7k+TagNbTQHlQYyHq3
        UfuqiXAiLWMeUlUxlOkEK4C0XA0o28/DcR/+KU4=
X-Google-Smtp-Source: ABdhPJzIvRHZBCXuW7LZBzxqiTqmUQWHwglz/BYBjh/Iq/laADtnOyt8Cl1gWrRRWssHHCJj0zrNa6dKAhxNxEg/BOs=
X-Received: by 2002:ac8:4cc9:: with SMTP id l9mr4211242qtv.59.1592853509964;
 Mon, 22 Jun 2020 12:18:29 -0700 (PDT)
MIME-Version: 1.0
References: <20200616100512.2168860-1-jolsa@kernel.org> <20200616100512.2168860-10-jolsa@kernel.org>
 <CAEf4BzY=d5y_-fXvomG7SjkbK7DZn5=-f+sdCYRdZh9qeynQrQ@mail.gmail.com>
 <20200619133124.GJ2465907@krava> <CAEf4BzZDCtW-5r5rN+ufZi1hUXjw8QCF+CiyT5sOvQQEEOqtiQ@mail.gmail.com>
 <20200622090205.GD2556590@krava>
In-Reply-To: <20200622090205.GD2556590@krava>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Mon, 22 Jun 2020 12:18:19 -0700
Message-ID: <CAEf4BzZOph2EJLfq9FCYUhesi5NP0L_OQTrEKE-s0NPmt3HmWw@mail.gmail.com>
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

On Mon, Jun 22, 2020 at 2:02 AM Jiri Olsa <jolsa@redhat.com> wrote:
>
> On Fri, Jun 19, 2020 at 11:25:27AM -0700, Andrii Nakryiko wrote:
>
> SNIP
>
> > > > >  /* integer value in 'imm' field of BPF_CALL instruction selects which helper
> > > > >   * function eBPF program intends to call
> > > > > diff --git a/kernel/bpf/btf_ids.c b/kernel/bpf/btf_ids.c
> > > > > index d8d0df162f04..853c8fd59b06 100644
> > > > > --- a/kernel/bpf/btf_ids.c
> > > > > +++ b/kernel/bpf/btf_ids.c
> > > > > @@ -13,3 +13,14 @@ BTF_ID(struct, seq_file)
> > > > >
> > > > >  BTF_ID_LIST(bpf_xdp_output_btf_ids)
> > > > >  BTF_ID(struct, xdp_buff)
> > > > > +
> > > > > +BTF_ID_LIST(bpf_d_path_btf_ids)
> > > > > +BTF_ID(struct, path)
> > > > > +
> > > > > +BTF_WHITELIST_ENTRY(btf_whitelist_d_path)
> > > > > +BTF_ID(func, vfs_truncate)
> > > > > +BTF_ID(func, vfs_fallocate)
> > > > > +BTF_ID(func, dentry_open)
> > > > > +BTF_ID(func, vfs_getattr)
> > > > > +BTF_ID(func, filp_close)
> > > > > +BTF_WHITELIST_END(btf_whitelist_d_path)
> > > >
> > > > Oh, so that's why you added btf_ids.c. Do you think centralizing all
> > > > those BTF ID lists in one file is going to be more convenient? I lean
> > > > towards keeping them closer to where they are used, as it was with all
> > > > those helper BTF IDS. But I wonder what others think...
> > >
> > > either way works for me, but then BTF_ID_* macros needs to go
> > > to include/linux/btf_ids.h header right?
> > >
> >
> > given it's internal API, I'd probably just put it in
> > include/linux/btf.h or include/linux/bpf.h, don't think we need extra
> > header just for these
>
> actually, I might end up with extra header, so it's possible
> to add selftest for this
>

How does extra header help with selftest?

> jirka
>

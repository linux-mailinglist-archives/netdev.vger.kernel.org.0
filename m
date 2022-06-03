Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 78FEF53C898
	for <lists+netdev@lfdr.de>; Fri,  3 Jun 2022 12:23:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243678AbiFCKX2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Jun 2022 06:23:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51694 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243660AbiFCKX1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 Jun 2022 06:23:27 -0400
Received: from mail-wm1-x335.google.com (mail-wm1-x335.google.com [IPv6:2a00:1450:4864:20::335])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EC19964CD;
        Fri,  3 Jun 2022 03:23:15 -0700 (PDT)
Received: by mail-wm1-x335.google.com with SMTP id q15so732972wmj.2;
        Fri, 03 Jun 2022 03:23:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:date:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=2QEKdV9+s64qm3wNNGwYNRuKT5nxHVTzupoSyOGtuQE=;
        b=OsCL00ukMplwgFU2JmFswI04CchshXB2CkdMb5iViW5/pf0S7u3S1ORH3QTJ7nn5Tw
         DAhfLKSJivKj/2Ch6O4B20jCVL/cTcxxzYgD4+kTmk9a3b8x8JS5pfw/MGggRjQr3ncf
         KxJMum4pX5yCo3p2DRja+eXMYVUa9vhB+KTggI6eJUHAEmM0e5440vwHdBYtiYvUALGg
         lSDZXaLfL4O7bo2l/aJBSWOCZubCejHg1tIQEvuB8spL7oHZcWbkKLPWj6OriM3LRevi
         2LW/RjAh+uig/OWk1wJ/mRq27FJSVVM50mJcRrWiiXfaFYaaax3ic+pPA7PNIl3LpN9I
         FWsA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:date:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=2QEKdV9+s64qm3wNNGwYNRuKT5nxHVTzupoSyOGtuQE=;
        b=G2GScu0C7rXPnpzQiZBHG7gFc921VM7a8BUw0ijWaUx1/BLxhO9EJrmNkxudLs+zcl
         Q19NKd3nFFoj3rVtBS0yUvDKTKZNn+IQxBbY3IUTQcL6GXN0mmii0m2sIxJd5hf6kTyi
         dvWa7isVXkJ9c0+ScXcKD3e2R8/vj1SfV2r0czsGUzg8UP7wgmdQLP95uNtiwr1fVDTB
         kpIpr0/MdKgSgX483dTRnLYeJGlUUvNCEiYiikwDDeQ9gyKSSxPe9Xh//Af5S9NvN7Mf
         hb9xJ2hXrglV629J+bljxhDnzKhDCqDVDN2871ueGZel0jfTGA8zns8IJxg4r1IFXR9b
         prCw==
X-Gm-Message-State: AOAM5335oit2fEtFatI5zIpe5L1QvBHBz5YUIU1J/KEmERiN/4vKMjmx
        +NUpiW+Sticz497SP4r+Erg=
X-Google-Smtp-Source: ABdhPJy+tUwMdJ9ZqSpPI1F5B5NJ2nfhVbBZy17Ix7vr2DZVhSySfUWryqyjCbYpdDFkWNyvYuyNDw==
X-Received: by 2002:a05:600c:4ca1:b0:397:8b29:255a with SMTP id g33-20020a05600c4ca100b003978b29255amr7999230wmp.139.1654251794411;
        Fri, 03 Jun 2022 03:23:14 -0700 (PDT)
Received: from krava ([193.85.244.190])
        by smtp.gmail.com with ESMTPSA id z3-20020a05600c0a0300b0039c362311d2sm6839457wmp.9.2022.06.03.03.23.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 03 Jun 2022 03:23:13 -0700 (PDT)
From:   Jiri Olsa <olsajiri@gmail.com>
X-Google-Original-From: Jiri Olsa <jolsa@kernel.org>
Date:   Fri, 3 Jun 2022 12:23:11 +0200
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        lkml <linux-kernel@vger.kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Masami Hiramatsu <mhiramat@kernel.org>
Subject: Re: [PATCH bpf-next 3/3] bpf: Force cookies array to follow symbols
 sorting
Message-ID: <YpnhDxpRuUbx4b2i@krava>
References: <20220527205611.655282-1-jolsa@kernel.org>
 <20220527205611.655282-4-jolsa@kernel.org>
 <CAEf4BzbY19qe6Ftzev884R_xuS4H5OD_fRLOfeekbPWjd5jkiA@mail.gmail.com>
 <CAEf4Bza84ei+Nmyh+aKHY_LSuDfziKjYTmphHQ39xCkooygbxA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAEf4Bza84ei+Nmyh+aKHY_LSuDfziKjYTmphHQ39xCkooygbxA@mail.gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jun 02, 2022 at 04:02:28PM -0700, Andrii Nakryiko wrote:
> On Thu, Jun 2, 2022 at 4:01 PM Andrii Nakryiko
> <andrii.nakryiko@gmail.com> wrote:
> >
> > On Fri, May 27, 2022 at 1:57 PM Jiri Olsa <jolsa@kernel.org> wrote:
> > >
> > > When user specifies symbols and cookies for kprobe_multi link
> > > interface it's very likely the cookies will be misplaced and
> > > returned to wrong functions (via get_attach_cookie helper).
> > >
> > > The reason is that to resolve the provided functions we sort
> > > them before passing them to ftrace_lookup_symbols, but we do
> > > not do the same sort on the cookie values.
> > >
> > > Fixing this by using sort_r function with custom swap callback
> > > that swaps cookie values as well.
> > >
> > > Fixes: 0236fec57a15 ("bpf: Resolve symbols with ftrace_lookup_symbols for kprobe multi link")
> > > Signed-off-by: Jiri Olsa <jolsa@kernel.org>
> > > ---
> > >  kernel/trace/bpf_trace.c | 65 ++++++++++++++++++++++++++++++----------
> > >  1 file changed, 50 insertions(+), 15 deletions(-)
> > >
> > > diff --git a/kernel/trace/bpf_trace.c b/kernel/trace/bpf_trace.c
> > > index 10b157a6d73e..e5c423b835ab 100644
> > > --- a/kernel/trace/bpf_trace.c
> > > +++ b/kernel/trace/bpf_trace.c
> > > @@ -2423,7 +2423,12 @@ kprobe_multi_link_handler(struct fprobe *fp, unsigned long entry_ip,
> > >         kprobe_multi_link_prog_run(link, entry_ip, regs);
> > >  }
> > >
> > > -static int symbols_cmp(const void *a, const void *b)
> > > +struct multi_symbols_sort {
> > > +       const char **funcs;
> > > +       u64 *cookies;
> > > +};
> > > +
> > > +static int symbols_cmp_r(const void *a, const void *b, const void *priv)
> > >  {
> > >         const char **str_a = (const char **) a;
> > >         const char **str_b = (const char **) b;
> > > @@ -2431,6 +2436,25 @@ static int symbols_cmp(const void *a, const void *b)
> > >         return strcmp(*str_a, *str_b);
> > >  }
> > >
> > > +static void symbols_swap_r(void *a, void *b, int size, const void *priv)
> > > +{
> > > +       const struct multi_symbols_sort *data = priv;
> > > +       const char **name_a = a, **name_b = b;
> > > +       u64 *cookie_a, *cookie_b;
> > > +
> > > +       cookie_a = data->cookies + (name_a - data->funcs);
> > > +       cookie_b = data->cookies + (name_b - data->funcs);
> > > +
> > > +       /* swap name_a/name_b and cookie_a/cookie_b values */
> > > +       swap(*name_a, *name_b);
> > > +       swap(*cookie_a, *cookie_b);
> > > +}
> > > +
> > > +static int symbols_cmp(const void *a, const void *b)
> > > +{
> > > +       return symbols_cmp_r(a, b, NULL);
> > > +}
> > > +
> > >  int bpf_kprobe_multi_link_attach(const union bpf_attr *attr, struct bpf_prog *prog)
> > >  {
> > >         struct bpf_kprobe_multi_link *link = NULL;
> > > @@ -2468,6 +2492,19 @@ int bpf_kprobe_multi_link_attach(const union bpf_attr *attr, struct bpf_prog *pr
> > >         if (!addrs)
> > >                 return -ENOMEM;
> > >
> > > +       ucookies = u64_to_user_ptr(attr->link_create.kprobe_multi.cookies);
> > > +       if (ucookies) {
> > > +               cookies = kvmalloc(size, GFP_KERNEL);
> 
> oh, and you'll have to rebase anyways after kvmalloc_array patch

true, that kvmalloc_array change went to bpf-next/master,
but as Song mentioned this patchset should probably go for bpf/master?

I'm fine either way, let me know ;-)

thanks,
jirka

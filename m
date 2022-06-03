Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 69CC253C880
	for <lists+netdev@lfdr.de>; Fri,  3 Jun 2022 12:19:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243575AbiFCKSo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Jun 2022 06:18:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39426 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236237AbiFCKSn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 Jun 2022 06:18:43 -0400
Received: from mail-wm1-x32e.google.com (mail-wm1-x32e.google.com [IPv6:2a00:1450:4864:20::32e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7F0473B2AA;
        Fri,  3 Jun 2022 03:18:42 -0700 (PDT)
Received: by mail-wm1-x32e.google.com with SMTP id n124-20020a1c2782000000b003972dfca96cso4083801wmn.4;
        Fri, 03 Jun 2022 03:18:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:date:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=8mie30TBVJaN2bhO1dj0dafpM0jgLh+ZX1e7/mzDn4E=;
        b=MZU049ypz3+Y3FBybZ5UDRAbsuOxjvKKagezlCSJ4WMyfrIEWmcSKNk6kPzEhicUT5
         aV/ZaF3HsJvOa7qmadXcLfm2T/UDNmI7+0UP5c5bqqL6w1fjGtbln5WR75cjiNfsx+GK
         5PLNnihNh6XeSaVm+kH9x/NDbq4oAQgUiyle+7g5EaHuVAbPwuC35e6a5G/CtrzJJB14
         coFHaaj3sht3Q5qDSaHIF2s8+4JMYBP+tKZqVudkPlzuGvcm2iB4NfJGvQOzT3rnDqOv
         Zxm+/JCIu9GUKUgevuxsyi6X/3LbiQfrvMDSaTx46VpRhUJi9tEl5KCIg3UGMNYlprvB
         /MeA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:date:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=8mie30TBVJaN2bhO1dj0dafpM0jgLh+ZX1e7/mzDn4E=;
        b=MhSJ7n0t8lHND7lqH2jMAP6r+XCySdzkCCvaao8PoBi3ctqbSZOgjIIWiHLWVEkZdx
         lUZ/ZJyXhwKXiBwWHgw3kZwHh2kirWUVgRj4L6lQrijMBTvucQD8nVA5dxhrNEYfXQs4
         5ohsJW0IW81asMT/vLwGjrQKykcg+b4BV5vFEHyP3uq6ToHL/c8Y2n+to3Obc+qA2C9H
         Zt3zV02A5UdIrcdNF+F93BLRsLGwBgJ73lGw3o8sybBM+vnROiBE+IShHiK2kHJvXphj
         wWuNA22tY9roFwXb7EyClp4LY8FDWFba9C0uqTk1piQZ+2qNVQsEA45m4cjRtAa0z+So
         SnoQ==
X-Gm-Message-State: AOAM533FjuOR1JPZKL+fc5JBXxv0Oy8j1xr4Tt+wB/s1vkArjiPPW0Gt
        mqFB754EdSQ0FTDbVK/FY2w=
X-Google-Smtp-Source: ABdhPJzzdFa6iFPnJftJacrEqQ3/KLuCwOu2A/cGyImbXXDg3Tz+3Zggf18tOEpT+p3rShNWOuS9ew==
X-Received: by 2002:a05:600c:502a:b0:397:44d1:d5b6 with SMTP id n42-20020a05600c502a00b0039744d1d5b6mr7943690wmr.57.1654251520952;
        Fri, 03 Jun 2022 03:18:40 -0700 (PDT)
Received: from krava ([193.85.244.190])
        by smtp.gmail.com with ESMTPSA id h4-20020adffd44000000b002102d4ed579sm6830719wrs.39.2022.06.03.03.18.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 03 Jun 2022 03:18:40 -0700 (PDT)
From:   Jiri Olsa <olsajiri@gmail.com>
X-Google-Original-From: Jiri Olsa <jolsa@kernel.org>
Date:   Fri, 3 Jun 2022 12:18:38 +0200
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
Message-ID: <Ypnf/pOC0zaFjF1s@krava>
References: <20220527205611.655282-1-jolsa@kernel.org>
 <20220527205611.655282-4-jolsa@kernel.org>
 <CAEf4BzbY19qe6Ftzev884R_xuS4H5OD_fRLOfeekbPWjd5jkiA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAEf4BzbY19qe6Ftzev884R_xuS4H5OD_fRLOfeekbPWjd5jkiA@mail.gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jun 02, 2022 at 04:01:07PM -0700, Andrii Nakryiko wrote:
> On Fri, May 27, 2022 at 1:57 PM Jiri Olsa <jolsa@kernel.org> wrote:
> >
> > When user specifies symbols and cookies for kprobe_multi link
> > interface it's very likely the cookies will be misplaced and
> > returned to wrong functions (via get_attach_cookie helper).
> >
> > The reason is that to resolve the provided functions we sort
> > them before passing them to ftrace_lookup_symbols, but we do
> > not do the same sort on the cookie values.
> >
> > Fixing this by using sort_r function with custom swap callback
> > that swaps cookie values as well.
> >
> > Fixes: 0236fec57a15 ("bpf: Resolve symbols with ftrace_lookup_symbols for kprobe multi link")
> > Signed-off-by: Jiri Olsa <jolsa@kernel.org>
> > ---
> >  kernel/trace/bpf_trace.c | 65 ++++++++++++++++++++++++++++++----------
> >  1 file changed, 50 insertions(+), 15 deletions(-)
> >
> > diff --git a/kernel/trace/bpf_trace.c b/kernel/trace/bpf_trace.c
> > index 10b157a6d73e..e5c423b835ab 100644
> > --- a/kernel/trace/bpf_trace.c
> > +++ b/kernel/trace/bpf_trace.c
> > @@ -2423,7 +2423,12 @@ kprobe_multi_link_handler(struct fprobe *fp, unsigned long entry_ip,
> >         kprobe_multi_link_prog_run(link, entry_ip, regs);
> >  }
> >
> > -static int symbols_cmp(const void *a, const void *b)
> > +struct multi_symbols_sort {
> > +       const char **funcs;
> > +       u64 *cookies;
> > +};
> > +
> > +static int symbols_cmp_r(const void *a, const void *b, const void *priv)
> >  {
> >         const char **str_a = (const char **) a;
> >         const char **str_b = (const char **) b;
> > @@ -2431,6 +2436,25 @@ static int symbols_cmp(const void *a, const void *b)
> >         return strcmp(*str_a, *str_b);
> >  }
> >
> > +static void symbols_swap_r(void *a, void *b, int size, const void *priv)
> > +{
> > +       const struct multi_symbols_sort *data = priv;
> > +       const char **name_a = a, **name_b = b;
> > +       u64 *cookie_a, *cookie_b;
> > +
> > +       cookie_a = data->cookies + (name_a - data->funcs);
> > +       cookie_b = data->cookies + (name_b - data->funcs);
> > +
> > +       /* swap name_a/name_b and cookie_a/cookie_b values */
> > +       swap(*name_a, *name_b);
> > +       swap(*cookie_a, *cookie_b);
> > +}
> > +
> > +static int symbols_cmp(const void *a, const void *b)
> > +{
> > +       return symbols_cmp_r(a, b, NULL);
> > +}
> > +
> >  int bpf_kprobe_multi_link_attach(const union bpf_attr *attr, struct bpf_prog *prog)
> >  {
> >         struct bpf_kprobe_multi_link *link = NULL;
> > @@ -2468,6 +2492,19 @@ int bpf_kprobe_multi_link_attach(const union bpf_attr *attr, struct bpf_prog *pr
> >         if (!addrs)
> >                 return -ENOMEM;
> >
> > +       ucookies = u64_to_user_ptr(attr->link_create.kprobe_multi.cookies);
> > +       if (ucookies) {
> > +               cookies = kvmalloc(size, GFP_KERNEL);
> > +               if (!cookies) {
> > +                       err = -ENOMEM;
> > +                       goto error;
> > +               }
> > +               if (copy_from_user(cookies, ucookies, size)) {
> > +                       err = -EFAULT;
> > +                       goto error;
> > +               }
> > +       }
> > +
> >         if (uaddrs) {
> >                 if (copy_from_user(addrs, uaddrs, size)) {
> >                         err = -EFAULT;
> > @@ -2480,26 +2517,24 @@ int bpf_kprobe_multi_link_attach(const union bpf_attr *attr, struct bpf_prog *pr
> >                 if (err)
> >                         goto error;
> >
> > -               sort(us.syms, cnt, sizeof(*us.syms), symbols_cmp, NULL);
> > +               if (cookies) {
> > +                       struct multi_symbols_sort data = {
> > +                               .cookies = cookies,
> > +                               .funcs = us.syms,
> > +                       };
> > +
> > +                       sort_r(us.syms, cnt, sizeof(*us.syms), symbols_cmp_r,
> > +                              symbols_swap_r, &data);
> > +               } else {
> > +                       sort(us.syms, cnt, sizeof(*us.syms), symbols_cmp, NULL);
> > +               }
> 
> maybe just always do sort_r, swap callback can just check if cookie
> array is NULL and if not, additionally swap cookies? why have all
> these different callbacks and complicate the code unnecessarily?

right, good idea.. will change

thanks,
jirka

> 
> > +
> >                 err = ftrace_lookup_symbols(us.syms, cnt, addrs);
> >                 free_user_syms(&us);
> >                 if (err)
> >                         goto error;
> >         }
> >
> > -       ucookies = u64_to_user_ptr(attr->link_create.kprobe_multi.cookies);
> > -       if (ucookies) {
> > -               cookies = kvmalloc(size, GFP_KERNEL);
> > -               if (!cookies) {
> > -                       err = -ENOMEM;
> > -                       goto error;
> > -               }
> > -               if (copy_from_user(cookies, ucookies, size)) {
> > -                       err = -EFAULT;
> > -                       goto error;
> > -               }
> > -       }
> > -
> >         link = kzalloc(sizeof(*link), GFP_KERNEL);
> >         if (!link) {
> >                 err = -ENOMEM;
> > --
> > 2.35.3
> >

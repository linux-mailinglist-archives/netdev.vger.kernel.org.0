Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D4A3853C136
	for <lists+netdev@lfdr.de>; Fri,  3 Jun 2022 01:03:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239867AbiFBXCo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Jun 2022 19:02:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44690 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229921AbiFBXCn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Jun 2022 19:02:43 -0400
Received: from mail-lj1-x231.google.com (mail-lj1-x231.google.com [IPv6:2a00:1450:4864:20::231])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 173152733;
        Thu,  2 Jun 2022 16:02:42 -0700 (PDT)
Received: by mail-lj1-x231.google.com with SMTP id g12so6775361lja.3;
        Thu, 02 Jun 2022 16:02:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=l9X+C68T2s+Tz7as0XsMszfHryGUuoJbZpRFuNUCAA0=;
        b=qGYzxtETjWH61KJv9JD8/onfKFxGXJp64M13vL6Sv+XWX8SxPvgLi7fCCDIlZ2uhsb
         lALQv4Z8Gu2df5MLVk8nMN/vWXTrlS+Tr9XzdpfsDPyyNnPQEaLGmYWGjJMIwiw2Px0Q
         IX0oqTXUlRWfjnbDUdXApjc0h42EbvcZhME4QkzI2CvLzrfw1hrAewUR+8t39HCqfM+k
         CnA99ve8zbHeuJTbRbpFEQWGleNImsrRq3SzbXk+EO0Sa1qhBKvZyOX8D76jcOTClK9U
         npgGfNXJznhjMO6TEF29eI2LfwdD5njOFXvVkyc8XElQ2WMaP3rzKVWGCsc7jfLSE9yb
         lQtg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=l9X+C68T2s+Tz7as0XsMszfHryGUuoJbZpRFuNUCAA0=;
        b=q4unuba+GDZBpavFaJdzNeObDxZq/pik61jEsij5qmqIwm6OnFr4wXhgdo4zCZmNTw
         3lMAGNffqSR8eEn7N0DTIzy7Ftf9Jt3VrkMMZwsn4viGY4rOxUhmrlMSXFuC/K6dbZNa
         G+7//SOaKltdkYpXb/SSd/iY4IXXwNQ+PTn/3PqJqfUZrWpsEmN9A5X74YlyP8YUPkJT
         21ox7p1P28jqeGmqa5qWGSm+OgUkBK2xHxS7LOF1mf5lDld2FxrfPC1cIsJ+e22XztPM
         3cck8EKKjTdISmbG20yBRURjT25j0gvYTyJCDY7a1Z+Ec9VpbP6dDB7fM5R6+MP7CkoQ
         gpzQ==
X-Gm-Message-State: AOAM5315C74Pv7oWcXiatNYteSQavpvJeKS0gHcM7R5cRvJsgAQxV+jx
        LYmup8TzetDLh4nKenZIcjZFeGk+t2TP0H1zOu6sqHZN
X-Google-Smtp-Source: ABdhPJzbIu4z34eS+xiIIIPy7PPJKPvH8I66C2ODvC393N4LZSMzqHlYJeXRNsL7pEnDqhJ4Ia541lsj7UNrJndSS+o=
X-Received: by 2002:a2e:3a16:0:b0:255:7811:2827 with SMTP id
 h22-20020a2e3a16000000b0025578112827mr2486239lja.130.1654210960410; Thu, 02
 Jun 2022 16:02:40 -0700 (PDT)
MIME-Version: 1.0
References: <20220527205611.655282-1-jolsa@kernel.org> <20220527205611.655282-4-jolsa@kernel.org>
 <CAEf4BzbY19qe6Ftzev884R_xuS4H5OD_fRLOfeekbPWjd5jkiA@mail.gmail.com>
In-Reply-To: <CAEf4BzbY19qe6Ftzev884R_xuS4H5OD_fRLOfeekbPWjd5jkiA@mail.gmail.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Thu, 2 Jun 2022 16:02:28 -0700
Message-ID: <CAEf4Bza84ei+Nmyh+aKHY_LSuDfziKjYTmphHQ39xCkooygbxA@mail.gmail.com>
Subject: Re: [PATCH bpf-next 3/3] bpf: Force cookies array to follow symbols sorting
To:     Jiri Olsa <jolsa@kernel.org>
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
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jun 2, 2022 at 4:01 PM Andrii Nakryiko
<andrii.nakryiko@gmail.com> wrote:
>
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

oh, and you'll have to rebase anyways after kvmalloc_array patch

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

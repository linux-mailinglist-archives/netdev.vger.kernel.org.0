Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AA2A553C132
	for <lists+netdev@lfdr.de>; Fri,  3 Jun 2022 01:01:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239859AbiFBXBY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Jun 2022 19:01:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39998 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229921AbiFBXBV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Jun 2022 19:01:21 -0400
Received: from mail-lj1-x230.google.com (mail-lj1-x230.google.com [IPv6:2a00:1450:4864:20::230])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4A2372872E;
        Thu,  2 Jun 2022 16:01:20 -0700 (PDT)
Received: by mail-lj1-x230.google.com with SMTP id q1so6759358ljb.5;
        Thu, 02 Jun 2022 16:01:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=UrSyfjfeqVZrZfHKJrmVADtzpO1c1GhQspOF8ytnTY4=;
        b=jCII96mhcASnjxlAKJgImX/8mKQeIsGCBCzykznSe2UfsOz1SzzHQ74GA1CDd1tppr
         /qF3jwdKYrrSpx/g9rUTEH2Y35B3Oypto/Uuu3hthBV1tb4Sf9A/so3ZfTmaKspJ0gkg
         mkHjP3v28HTfIriisu3ZJhDdGJxRFCH1jfMOM4dHLxG4bJhUJtQHJ+UyvPljL147JoFL
         fXdNTMmxt8YjZ9kXCPYCkMcqVPySUq/88vMl9BV9z65NbZzfNlCE+Jx7SqG+oltuvigg
         fM3TLh82F9i7q3btI9jDd0RR1qiwDt53RaqGetVRQN5ES8ZLxzypqGTry4nz19pZ0wKx
         glCw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=UrSyfjfeqVZrZfHKJrmVADtzpO1c1GhQspOF8ytnTY4=;
        b=FjSIQhRoGDkQQAFp+dtzBbLM0QV2/2vYKKzbIM6qVWOkGrDpMppBneBKHZ1qGbrdNL
         GYrAgHlW0vray07I91kyHiP8blrJtVaMRnxx4AJvXmQaMGarK/L5m1TgQyvTLHi1S0WO
         KLxPbz0XlJkUprRFGmLiyfHsKHZcGVD5iu5c1Sj2rtos55hTDDa2QHjFfDV3wJo1+iji
         svu3qF1UnBIQaxWJOuJQXeNSfG1K/6K2ZgZNhjTO0qKQ0/IFmJ1IyXj+97qnUZbnTWr0
         F8Nb722cY0349iOqpAwf2NURq8Q2vVA+/jcfBSyudbFWNQDPSEMLDPZ8itu+8+ajTqbs
         fyTw==
X-Gm-Message-State: AOAM530V8lD3UJki4EMctxjmJnFnSNQyyBzOxQ2DMmlk1MoadgueWb98
        A7V0GVBpmybmansLFg9sqKTE8NUUyPHOa6CvvcA=
X-Google-Smtp-Source: ABdhPJwbDS4kjdp7Wh9KbE1D8cH+KtyjYAZFXoRKE4oCXa6/L+CQvw/L9zG6TbmgU/F97v5Tbjy+CrsKtVvlZlG9WI0=
X-Received: by 2002:a2e:9bc1:0:b0:253:e20a:7a79 with SMTP id
 w1-20020a2e9bc1000000b00253e20a7a79mr36466327ljj.445.1654210878588; Thu, 02
 Jun 2022 16:01:18 -0700 (PDT)
MIME-Version: 1.0
References: <20220527205611.655282-1-jolsa@kernel.org> <20220527205611.655282-4-jolsa@kernel.org>
In-Reply-To: <20220527205611.655282-4-jolsa@kernel.org>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Thu, 2 Jun 2022 16:01:07 -0700
Message-ID: <CAEf4BzbY19qe6Ftzev884R_xuS4H5OD_fRLOfeekbPWjd5jkiA@mail.gmail.com>
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

On Fri, May 27, 2022 at 1:57 PM Jiri Olsa <jolsa@kernel.org> wrote:
>
> When user specifies symbols and cookies for kprobe_multi link
> interface it's very likely the cookies will be misplaced and
> returned to wrong functions (via get_attach_cookie helper).
>
> The reason is that to resolve the provided functions we sort
> them before passing them to ftrace_lookup_symbols, but we do
> not do the same sort on the cookie values.
>
> Fixing this by using sort_r function with custom swap callback
> that swaps cookie values as well.
>
> Fixes: 0236fec57a15 ("bpf: Resolve symbols with ftrace_lookup_symbols for kprobe multi link")
> Signed-off-by: Jiri Olsa <jolsa@kernel.org>
> ---
>  kernel/trace/bpf_trace.c | 65 ++++++++++++++++++++++++++++++----------
>  1 file changed, 50 insertions(+), 15 deletions(-)
>
> diff --git a/kernel/trace/bpf_trace.c b/kernel/trace/bpf_trace.c
> index 10b157a6d73e..e5c423b835ab 100644
> --- a/kernel/trace/bpf_trace.c
> +++ b/kernel/trace/bpf_trace.c
> @@ -2423,7 +2423,12 @@ kprobe_multi_link_handler(struct fprobe *fp, unsigned long entry_ip,
>         kprobe_multi_link_prog_run(link, entry_ip, regs);
>  }
>
> -static int symbols_cmp(const void *a, const void *b)
> +struct multi_symbols_sort {
> +       const char **funcs;
> +       u64 *cookies;
> +};
> +
> +static int symbols_cmp_r(const void *a, const void *b, const void *priv)
>  {
>         const char **str_a = (const char **) a;
>         const char **str_b = (const char **) b;
> @@ -2431,6 +2436,25 @@ static int symbols_cmp(const void *a, const void *b)
>         return strcmp(*str_a, *str_b);
>  }
>
> +static void symbols_swap_r(void *a, void *b, int size, const void *priv)
> +{
> +       const struct multi_symbols_sort *data = priv;
> +       const char **name_a = a, **name_b = b;
> +       u64 *cookie_a, *cookie_b;
> +
> +       cookie_a = data->cookies + (name_a - data->funcs);
> +       cookie_b = data->cookies + (name_b - data->funcs);
> +
> +       /* swap name_a/name_b and cookie_a/cookie_b values */
> +       swap(*name_a, *name_b);
> +       swap(*cookie_a, *cookie_b);
> +}
> +
> +static int symbols_cmp(const void *a, const void *b)
> +{
> +       return symbols_cmp_r(a, b, NULL);
> +}
> +
>  int bpf_kprobe_multi_link_attach(const union bpf_attr *attr, struct bpf_prog *prog)
>  {
>         struct bpf_kprobe_multi_link *link = NULL;
> @@ -2468,6 +2492,19 @@ int bpf_kprobe_multi_link_attach(const union bpf_attr *attr, struct bpf_prog *pr
>         if (!addrs)
>                 return -ENOMEM;
>
> +       ucookies = u64_to_user_ptr(attr->link_create.kprobe_multi.cookies);
> +       if (ucookies) {
> +               cookies = kvmalloc(size, GFP_KERNEL);
> +               if (!cookies) {
> +                       err = -ENOMEM;
> +                       goto error;
> +               }
> +               if (copy_from_user(cookies, ucookies, size)) {
> +                       err = -EFAULT;
> +                       goto error;
> +               }
> +       }
> +
>         if (uaddrs) {
>                 if (copy_from_user(addrs, uaddrs, size)) {
>                         err = -EFAULT;
> @@ -2480,26 +2517,24 @@ int bpf_kprobe_multi_link_attach(const union bpf_attr *attr, struct bpf_prog *pr
>                 if (err)
>                         goto error;
>
> -               sort(us.syms, cnt, sizeof(*us.syms), symbols_cmp, NULL);
> +               if (cookies) {
> +                       struct multi_symbols_sort data = {
> +                               .cookies = cookies,
> +                               .funcs = us.syms,
> +                       };
> +
> +                       sort_r(us.syms, cnt, sizeof(*us.syms), symbols_cmp_r,
> +                              symbols_swap_r, &data);
> +               } else {
> +                       sort(us.syms, cnt, sizeof(*us.syms), symbols_cmp, NULL);
> +               }

maybe just always do sort_r, swap callback can just check if cookie
array is NULL and if not, additionally swap cookies? why have all
these different callbacks and complicate the code unnecessarily?

> +
>                 err = ftrace_lookup_symbols(us.syms, cnt, addrs);
>                 free_user_syms(&us);
>                 if (err)
>                         goto error;
>         }
>
> -       ucookies = u64_to_user_ptr(attr->link_create.kprobe_multi.cookies);
> -       if (ucookies) {
> -               cookies = kvmalloc(size, GFP_KERNEL);
> -               if (!cookies) {
> -                       err = -ENOMEM;
> -                       goto error;
> -               }
> -               if (copy_from_user(cookies, ucookies, size)) {
> -                       err = -EFAULT;
> -                       goto error;
> -               }
> -       }
> -
>         link = kzalloc(sizeof(*link), GFP_KERNEL);
>         if (!link) {
>                 err = -ENOMEM;
> --
> 2.35.3
>

Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 158FF52C78B
	for <lists+netdev@lfdr.de>; Thu, 19 May 2022 01:31:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231357AbiERXb2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 May 2022 19:31:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58088 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230448AbiERXb0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 May 2022 19:31:26 -0400
Received: from mail-il1-x135.google.com (mail-il1-x135.google.com [IPv6:2607:f8b0:4864:20::135])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4020D35A97;
        Wed, 18 May 2022 16:31:25 -0700 (PDT)
Received: by mail-il1-x135.google.com with SMTP id 3so2589440ily.2;
        Wed, 18 May 2022 16:31:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=lVJJebMlPVF5A5XDAVZHl3sAYnjL4i4r2zSkkM3XY8w=;
        b=VvozH93x1DMs7MoQRYYrpmPKDJzo27XgtQpKQUaSvtapVIjZMPcc3umx50yBaGc3AI
         2OJRktp86/F83ESrsUw73BGfgcIz8oD1qku2Klj1+ZD4g4feUO9h7XT8eO+mUTASchDT
         u80QvVlcDUSM4elq9L8TrQXNgF4y7LEjlc+ZDHqprw2TsnJqEMyAA6/OnMWt0JPVxi2a
         gMhy7oEp8sdBxJb1G9SGKIhIhQvi3ppo6BsBjR5Rv/4j65Q2rFDHUabpJ8dOB2UwuQun
         dkeTru0yttbeY5hKK2/5wbE8RNt9PSoJzKN1Vps49/7OQoAyJlaJVqjnlfFMtYolw4C5
         l97g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=lVJJebMlPVF5A5XDAVZHl3sAYnjL4i4r2zSkkM3XY8w=;
        b=yaTrvQQt80oSRqfo849G2UzqCo/Sxuq96Yk4u1NNpBLH0s9CeeD6e8OxVkI7NRNOwr
         J74QpAUSaiJObH/rZsR04ANF5kaH54JU1Aez6AdqAda9S+VBJEPthKayriziGlk3dLMR
         yIIVJQC+2pmQ2og7DOiH96PT0ek2kOHnwri5TQp0lkGhEpzTIUlDKYUtc8T6z3/a0Wvr
         6YKqHJogyOIF+HX+thjMnbs4CvSJ06cyfOZIAjlP5LMwVxOLGOJ1KPjxEIee6PYTZ/FP
         RH3tSIkmjz4NkhZ1+jsrBLwtKz4c3kSuGUK+QKxUTM+NGc1Qu0FV0V3/U11/mjvBTQF1
         2Y4g==
X-Gm-Message-State: AOAM532/k/lS5p2QGEj3iHwH9Z68gtpF0zSWdYYNOg/mTyZu4BBzIxe6
        +zLf0Rq6a2W9JPv7Id9C8Mj0qYrtfSzJ5JvWBiE=
X-Google-Smtp-Source: ABdhPJxUY57EsYv0YkxIbk9exT0rzX/VTjAxYY4RoeiARphLhvlVkfc7PeXga1KW7ZLOI0tPa/wvQwKKSQXP6itPWR8=
X-Received: by 2002:a05:6e02:1b82:b0:2cf:199f:3b4b with SMTP id
 h2-20020a056e021b8200b002cf199f3b4bmr1133463ili.71.1652916684309; Wed, 18 May
 2022 16:31:24 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1652772731.git.esyr@redhat.com> <525b99881dc144b986e381eb23b12617a311f243.1652772731.git.esyr@redhat.com>
In-Reply-To: <525b99881dc144b986e381eb23b12617a311f243.1652772731.git.esyr@redhat.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Wed, 18 May 2022 16:31:13 -0700
Message-ID: <CAEf4BzZVe2k1q-XrTwq=OMvcFRdZSfYa0bv1occxR0NX_Ax2rA@mail.gmail.com>
Subject: Re: [PATCH bpf-next v3 2/4] bpf_trace: support 32-bit kernels in bpf_kprobe_multi_link_attach
To:     Eugene Syromiatnikov <esyr@redhat.com>
Cc:     Jiri Olsa <jolsa@kernel.org>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Ingo Molnar <mingo@redhat.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>,
        Shuah Khan <shuah@kernel.org>,
        "open list:KERNEL SELFTEST FRAMEWORK" 
        <linux-kselftest@vger.kernel.org>
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

On Tue, May 17, 2022 at 12:36 AM Eugene Syromiatnikov <esyr@redhat.com> wrote:
>
> It seems that there is no reason not to support 32-bit architectures;
> doing so requires a bit of rework with respect to cookies handling,
> however, as the current code implicitly assumes
> that sizeof(long) == sizeof(u64).
>
> Signed-off-by: Eugene Syromiatnikov <esyr@redhat.com>
> ---
>  kernel/trace/bpf_trace.c | 17 ++++++++---------
>  1 file changed, 8 insertions(+), 9 deletions(-)
>
> diff --git a/kernel/trace/bpf_trace.c b/kernel/trace/bpf_trace.c
> index 9c041be..a93a54f 100644
> --- a/kernel/trace/bpf_trace.c
> +++ b/kernel/trace/bpf_trace.c
> @@ -2435,16 +2435,12 @@ int bpf_kprobe_multi_link_attach(const union bpf_attr *attr, struct bpf_prog *pr
>         struct bpf_link_primer link_primer;
>         void __user *ucookies;
>         unsigned long *addrs;
> -       u32 flags, cnt, size;
> +       u32 flags, cnt, size, cookies_size;
>         void __user *uaddrs;
>         u64 *cookies = NULL;
>         void __user *usyms;
>         int err;
>
> -       /* no support for 32bit archs yet */
> -       if (sizeof(u64) != sizeof(void *))
> -               return -EOPNOTSUPP;
> -
>         if (prog->expected_attach_type != BPF_TRACE_KPROBE_MULTI)
>                 return -EINVAL;
>
> @@ -2454,6 +2450,7 @@ int bpf_kprobe_multi_link_attach(const union bpf_attr *attr, struct bpf_prog *pr
>
>         uaddrs = u64_to_user_ptr(attr->link_create.kprobe_multi.addrs);
>         usyms = u64_to_user_ptr(attr->link_create.kprobe_multi.syms);
> +       ucookies = u64_to_user_ptr(attr->link_create.kprobe_multi.cookies);
>         if (!!uaddrs == !!usyms)
>                 return -EINVAL;
>
> @@ -2461,8 +2458,11 @@ int bpf_kprobe_multi_link_attach(const union bpf_attr *attr, struct bpf_prog *pr
>         if (!cnt)
>                 return -EINVAL;
>
> -       if (check_mul_overflow(cnt, (u32)sizeof(*addrs), &size))
> +       if (check_mul_overflow(cnt, (u32)sizeof(*addrs), &size) ||
> +           (ucookies &&
> +            check_mul_overflow(cnt, (u32)sizeof(*cookies), &cookies_size))) {
>                 return -EOVERFLOW;
> +       }
>         addrs = kvmalloc(size, GFP_KERNEL);
>         if (!addrs)
>                 return -ENOMEM;
> @@ -2486,14 +2486,13 @@ int bpf_kprobe_multi_link_attach(const union bpf_attr *attr, struct bpf_prog *pr
>                         goto error;
>         }
>
> -       ucookies = u64_to_user_ptr(attr->link_create.kprobe_multi.cookies);
>         if (ucookies) {
> -               cookies = kvmalloc(size, GFP_KERNEL);
> +               cookies = kvmalloc(cookies_size, GFP_KERNEL);

same question about consistent use of kvmalloc_array() and delegating
all the overflow checks to it?

>                 if (!cookies) {
>                         err = -ENOMEM;
>                         goto error;
>                 }
> -               if (copy_from_user(cookies, ucookies, size)) {
> +               if (copy_from_user(cookies, ucookies, cookies_size)) {
>                         err = -EFAULT;
>                         goto error;
>                 }
> --
> 2.1.4
>

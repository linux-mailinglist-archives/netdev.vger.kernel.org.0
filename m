Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E01C44FC773
	for <lists+netdev@lfdr.de>; Tue, 12 Apr 2022 00:15:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350349AbiDKWSD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Apr 2022 18:18:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38078 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350383AbiDKWSC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 Apr 2022 18:18:02 -0400
Received: from mail-io1-xd2a.google.com (mail-io1-xd2a.google.com [IPv6:2607:f8b0:4864:20::d2a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 65D8A19030;
        Mon, 11 Apr 2022 15:15:46 -0700 (PDT)
Received: by mail-io1-xd2a.google.com with SMTP id p21so20426380ioj.4;
        Mon, 11 Apr 2022 15:15:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=CNo6Z0cvn8BDnGlCktMDDZbqh+/TKG3Xb3BUHAR+QVE=;
        b=VuwhO5g812AyrLpid0d6ragtV78PthF0C7yQ2pFTmf7SEhhKtiB9qQ9n47Pq9T6J9j
         H3Fj7Od4JyT19OeEKhJhddeEErBzj8eSouPyPdZhEfZGdajxrWWoKudZ8gkjMV+3/Ntv
         ouMqGJwyH8oD4jyPlMXhIYAR+pGbnIi0tYjbVlll3acsU+1lAKak6Vk9bv3OJ3P/ZGKP
         qblfGS4puksYNhsDkMOJG0uC6kpy/SrA4az0nUHIq9fhlGi64DBdK7Lx6fhNOm/zplzf
         9/zD/dYTgo3FLgVkpAJt5C+fJ5kRexzG05a0PXtg8U5QEHxK0wo64e/hB7ir3N8aVQe2
         gyEA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=CNo6Z0cvn8BDnGlCktMDDZbqh+/TKG3Xb3BUHAR+QVE=;
        b=1pt4UVhg+KID3iw5faG75UpkovNsQaZ9+yKFj4sH3iYvEQXteygxzYVrQy1r0BmWgq
         LzXzpeYOgeaWxLRHyEf/tn85RmBMcbeZ+aMUrCOH138LFWoMc04X6KylZe7YvB5Ku0JV
         zVNtSKEP2HuwDExMYGakzS0nBVmWtzXPVw9GyZGZ2Cs/XMLXnO/B+5G7w+dnEH6iqnpD
         wbu/c2FFnJBzImyOBnHYbl5OYmX8Ck8UnaCE3k+2MDZbbfs9Cbhn9zXq18XWJxt0HSBH
         iXFtm5AXeiK4RGIu4x8IX3XlBJ1Lg2PNIjvVQDz7Nd8IbLQrpJ5cYD3B9runxaJsFG4b
         9ZXQ==
X-Gm-Message-State: AOAM532bUYXDBvBc0D8FOvUx6J2vyiZh6wVJ+HP6MbbudW/PAZ3FO2bb
        U7+DrBaIo2rwZfmCZYRO5zRO/eLqHZwSKYTE1eI=
X-Google-Smtp-Source: ABdhPJzu2W5GjdRPgh4/xmNVCeT2R6RAoAZXLhpRPzKwWf0CKfb5S8q5YedewPmiQ2F1qrxm1hYYvVOm71cJhXkpw9k=
X-Received: by 2002:a05:6602:3c6:b0:63d:cac9:bd35 with SMTP id
 g6-20020a05660203c600b0063dcac9bd35mr14265388iov.144.1649715345843; Mon, 11
 Apr 2022 15:15:45 -0700 (PDT)
MIME-Version: 1.0
References: <20220407125224.310255-1-jolsa@kernel.org> <20220407125224.310255-4-jolsa@kernel.org>
In-Reply-To: <20220407125224.310255-4-jolsa@kernel.org>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Mon, 11 Apr 2022 15:15:32 -0700
Message-ID: <CAEf4BzYrRSB2wSYVmMCGA80RY6Hy2Chtt3MnXFy7+-Feh+2FBw@mail.gmail.com>
Subject: Re: [RFC bpf-next 3/4] bpf: Resolve symbols with kallsyms_lookup_names
 for kprobe multi link
To:     Jiri Olsa <jolsa@kernel.org>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        lkml <linux-kernel@vger.kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>
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

On Thu, Apr 7, 2022 at 5:53 AM Jiri Olsa <jolsa@kernel.org> wrote:
>
> Using kallsyms_lookup_names function to speed up symbols lookup in
> kprobe multi link attachment and replacing with it the current
> kprobe_multi_resolve_syms function.
>
> This speeds up bpftrace kprobe attachment:
>
>   # perf stat -r 5 -e cycles ./src/bpftrace -e 'kprobe:x* {  } i:ms:1 { exit(); }'
>   ...
>   6.5681 +- 0.0225 seconds time elapsed  ( +-  0.34% )
>
> After:
>
>   # perf stat -r 5 -e cycles ./src/bpftrace -e 'kprobe:x* {  } i:ms:1 { exit(); }'
>   ...
>   0.5661 +- 0.0275 seconds time elapsed  ( +-  4.85% )
>
> Signed-off-by: Jiri Olsa <jolsa@kernel.org>
> ---
>  kernel/trace/bpf_trace.c | 123 +++++++++++++++++++++++----------------
>  1 file changed, 73 insertions(+), 50 deletions(-)
>
> diff --git a/kernel/trace/bpf_trace.c b/kernel/trace/bpf_trace.c
> index b26f3da943de..2602957225ba 100644
> --- a/kernel/trace/bpf_trace.c
> +++ b/kernel/trace/bpf_trace.c
> @@ -2226,6 +2226,72 @@ struct bpf_kprobe_multi_run_ctx {
>         unsigned long entry_ip;
>  };
>
> +struct user_syms {
> +       const char **syms;
> +       char *buf;
> +};
> +
> +static int copy_user_syms(struct user_syms *us, void __user *usyms, u32 cnt)
> +{
> +       const char __user **usyms_copy = NULL;
> +       const char **syms = NULL;
> +       char *buf = NULL, *p;
> +       int err = -EFAULT;
> +       unsigned int i;
> +       size_t size;
> +
> +       size = cnt * sizeof(*usyms_copy);
> +
> +       usyms_copy = kvmalloc(size, GFP_KERNEL);
> +       if (!usyms_copy)
> +               return -ENOMEM;

do you really need usyms_copy? why not just read one pointer at a time?

> +
> +       if (copy_from_user(usyms_copy, usyms, size))
> +               goto error;
> +
> +       err = -ENOMEM;
> +       syms = kvmalloc(size, GFP_KERNEL);
> +       if (!syms)
> +               goto error;
> +
> +       /* TODO this potentially allocates lot of memory (~6MB in my tests
> +        * with attaching ~40k functions). I haven't seen this to fail yet,
> +        * but it could be changed to allocate memory gradually if needed.
> +        */
> +       size = cnt * KSYM_NAME_LEN;

this reassignment of size is making it hard to follow the code, you
can just do cnt * KSYM_NAME_LEN inside kvmalloc, you don't ever use it
anywhere else

> +       buf = kvmalloc(size, GFP_KERNEL);
> +       if (!buf)
> +               goto error;
> +
> +       for (p = buf, i = 0; i < cnt; i++) {

like here, before doing strncpy_from_user() you can read usyms[i] from
user-space into temporary variable, no need for extra kvmalloc?

> +               err = strncpy_from_user(p, usyms_copy[i], KSYM_NAME_LEN);
> +               if (err == KSYM_NAME_LEN)
> +                       err = -E2BIG;
> +               if (err < 0)
> +                       goto error;
> +               syms[i] = p;
> +               p += err + 1;
> +       }
> +
> +       err = 0;
> +       us->syms = syms;
> +       us->buf = buf;
> +

[...]

Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 862B250925A
	for <lists+netdev@lfdr.de>; Wed, 20 Apr 2022 23:50:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1382675AbiDTVw7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Apr 2022 17:52:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37854 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234964AbiDTVw7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 Apr 2022 17:52:59 -0400
Received: from mail-vs1-xe2d.google.com (mail-vs1-xe2d.google.com [IPv6:2607:f8b0:4864:20::e2d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 84FEE1EC59;
        Wed, 20 Apr 2022 14:50:11 -0700 (PDT)
Received: by mail-vs1-xe2d.google.com with SMTP id d9so2824610vsh.10;
        Wed, 20 Apr 2022 14:50:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=E9YOcBF8Qte2T6InlNUSlZ6JWX6+9WNopvT5STl0eyU=;
        b=NSGQSQmkoJdKMFKZ0NiBhW4monmH7KmNSyzOnkiPsP1rWKrLz3Gm55Z+Dok7mxTQBH
         XOYyBBTjV+EWLt6uumuINFy7+Wk7ga0WQJRGTaO7ezPPEwVYebCpdO0rqn8LKXdCYsXx
         pDSfo5R0RLUditd6EUQ+VB5t7Wu1H4qpvUG0uN8WK86sV/pqhHmj/WVHHhNRjuckZukY
         yQavyfACmzadaKPtpJupvXC62gtHbp+2LhPUUFyKUv5wCY7uEDrytH2WHPFDJ0FVA6zQ
         2QgO5HRfxK6tPZO6oi1ggx1WwnkZHIIOarfmjPYSBo+c9Gd6UPbYGeTsXP2G3atGeoo/
         ipJw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=E9YOcBF8Qte2T6InlNUSlZ6JWX6+9WNopvT5STl0eyU=;
        b=4MeVQeDspzDQJgfe9ItNt8LnXLAKyec9X6Fpgi545lR68yVVyShvGUd1AklWPE+BRe
         +SRroMwLDqX4wqt4akn3UlSP90YP8Lg/9paEhT6YWKWvDPQCk9zt9VKn3Lfp8Lc/SJtU
         tl5RiVbZXul9lKcWNe94DWVjD0SHH8EsTFT6HCjpypgCog1aMZ1vFy9Wob3/SqrW9SLl
         +QT2rCiLoQ7F0KdMjKfMdwGlQBKMsl2c4BExlfYzDkcUf/ukzyhxeVd5D2Ymcc5266nk
         oUum/RpdQltb6BCkvccNsSjloHCQeUkCVXu75qMz4oontvz9VxxmfdTyw5Hk2c/TdZFk
         bfKA==
X-Gm-Message-State: AOAM533t+w+gijPKJDXhGS6V0xAO+9QnAqD4GgXE3Qxibu5a1lI+4soj
        3A5LY7+o8dihcrt58LIuwXoob8r8rKDrWyes020=
X-Google-Smtp-Source: ABdhPJybKH2CVcTLmO2oJE6QULxf9CuV0sewavhpEiXQCwEQNAHFCNL3vq7l5xZBK6V+FSQKaNjXpmMy9c7Z+YCDLwc=
X-Received: by 2002:a05:6102:22c3:b0:32a:4dd4:974 with SMTP id
 a3-20020a05610222c300b0032a4dd40974mr6925902vsh.18.1650491410399; Wed, 20 Apr
 2022 14:50:10 -0700 (PDT)
MIME-Version: 1.0
References: <20220418124834.829064-1-jolsa@kernel.org> <20220418124834.829064-4-jolsa@kernel.org>
In-Reply-To: <20220418124834.829064-4-jolsa@kernel.org>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Wed, 20 Apr 2022 14:49:59 -0700
Message-ID: <CAEf4Bzau_RmREQwVQ6wPRbCHVXRuAr1k08btaft2jUwBYTeM-Q@mail.gmail.com>
Subject: Re: [PATCHv2 bpf-next 3/4] bpf: Resolve symbols with
 kallsyms_lookup_names for kprobe multi link
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
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Apr 18, 2022 at 5:49 AM Jiri Olsa <jolsa@kernel.org> wrote:
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

LGTM.

Acked-by: Andrii Nakryiko <andrii@kernel.org>

>  kernel/trace/bpf_trace.c | 113 +++++++++++++++++++++++----------------
>  1 file changed, 67 insertions(+), 46 deletions(-)
>
> diff --git a/kernel/trace/bpf_trace.c b/kernel/trace/bpf_trace.c
> index b26f3da943de..f49cdc46a21f 100644
> --- a/kernel/trace/bpf_trace.c
> +++ b/kernel/trace/bpf_trace.c
> @@ -2226,6 +2226,60 @@ struct bpf_kprobe_multi_run_ctx {
>         unsigned long entry_ip;
>  };
>
> +struct user_syms {
> +       const char **syms;
> +       char *buf;
> +};
> +
> +static int copy_user_syms(struct user_syms *us, unsigned long __user *usyms, u32 cnt)
> +{
> +       unsigned long __user usymbol;
> +       const char **syms = NULL;
> +       char *buf = NULL, *p;
> +       int err = -EFAULT;
> +       unsigned int i;
> +
> +       err = -ENOMEM;
> +       syms = kvmalloc(cnt * sizeof(*syms), GFP_KERNEL);
> +       if (!syms)
> +               goto error;
> +
> +       buf = kvmalloc(cnt * KSYM_NAME_LEN, GFP_KERNEL);
> +       if (!buf)
> +               goto error;
> +
> +       for (p = buf, i = 0; i < cnt; i++) {
> +               if (__get_user(usymbol, usyms + i)) {
> +                       err = -EFAULT;
> +                       goto error;
> +               }
> +               err = strncpy_from_user(p, (const char __user *) usymbol, KSYM_NAME_LEN);
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

return 0 here instead of falling through into error: block?

> +
> +error:
> +       if (err) {
> +               kvfree(syms);
> +               kvfree(buf);
> +       }
> +       return err;
> +}
> +
> +static void free_user_syms(struct user_syms *us)
> +{
> +       kvfree(us->syms);
> +       kvfree(us->buf);
> +}
> +
>  static void bpf_kprobe_multi_link_release(struct bpf_link *link)
>  {
>         struct bpf_kprobe_multi_link *kmulti_link;

[...]

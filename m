Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8E4F53BF2C7
	for <lists+netdev@lfdr.de>; Thu,  8 Jul 2021 02:19:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230127AbhGHAVn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Jul 2021 20:21:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58960 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229519AbhGHAVn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Jul 2021 20:21:43 -0400
Received: from mail-yb1-xb30.google.com (mail-yb1-xb30.google.com [IPv6:2607:f8b0:4864:20::b30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4CD97C061574;
        Wed,  7 Jul 2021 17:19:01 -0700 (PDT)
Received: by mail-yb1-xb30.google.com with SMTP id o139so6048685ybg.9;
        Wed, 07 Jul 2021 17:19:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Q1bLAriXJOPBIFNqcBuRyTgQSNRAB4JqLnvjZv2N8TM=;
        b=TyQ1EgUyIO47G2ly6Hom8/58XZID/9d9nWKanFSdsUWUNIMI1qiQZTA4SOApz8QDu1
         ht2z2ZIIICdeu6ZTcF7PEeeNECYbIjpF8F/yFWzI4TMHBTuepwYpogrDtYP8Xc+pY5JB
         H5Wm1uWB/1Q4Xn7meMVRvNmEkNYjpxy7f/uEKtgWLaHQ57RpxfGBlXpJCKEjMac6JF9S
         vRJjaol4ElYsXZQLOIbMLGvv9C+N9ETJNu1lcq0ZX3OCR0Y25FryVxF0saH7XIzRVvTl
         mH87VVx1enXTQM6u2AjbD88jWib9Y7P92NPqj2M2qV2bLJUKJWnIHtLPJCyquZzwfRiG
         F3XA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Q1bLAriXJOPBIFNqcBuRyTgQSNRAB4JqLnvjZv2N8TM=;
        b=tq+ZNk8J2dQA27ubkMxVHGxl422y2M++o2rDu+oa0Qrzcp6XUroATi/P9IiBNk4niD
         ixBLAKGO9+d15DYF6UgHbKnWIrFsXOp8bsmRVLeb2T5V2qEMPDi2wIZ6o0xGHqttSjO1
         kiAxO63kGjwWzFIUBxLBAUPLZaxV4AKtkxR8csyk+9J9rgQBKCUzu8YGYPTq8TYDtW3b
         O8l2LxwuoTBIPdK4dvolcIN/waNe34DUepT2wpv/VKKPF8A+kBrMjNsWk0znwagShU7K
         lc09JIJzcfR5qgqgnSLcO7A9dAFIKZXsorC6e+VyTMcMttwYKf52qRLf7f9W4RTRQtdQ
         KDDQ==
X-Gm-Message-State: AOAM53293Gls7Q12R90Ikrfww2LfCm88vwcFRlGK8wFb28qiOo/5SQnt
        mZ4uFksd8dZCDvJ17kDcSZ6YtkvGhDEJHmVk5M4=
X-Google-Smtp-Source: ABdhPJyo2P8MVpF+85m7T9jAqfmUnEhMyin+He9v+LCK29IeP5PRYzrXk8CMjkkNnShf/01JTvZfAyI+83NbvCaxlLo=
X-Received: by 2002:a25:3787:: with SMTP id e129mr34856590yba.459.1625703540578;
 Wed, 07 Jul 2021 17:19:00 -0700 (PDT)
MIME-Version: 1.0
References: <20210707214751.159713-1-jolsa@kernel.org> <20210707214751.159713-8-jolsa@kernel.org>
In-Reply-To: <20210707214751.159713-8-jolsa@kernel.org>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Wed, 7 Jul 2021 17:18:49 -0700
Message-ID: <CAEf4Bzb9DTtGWubdEgMYirWLT-AiYbU2LfB-cSpGNzk6L0z8Kg@mail.gmail.com>
Subject: Re: [PATCHv3 bpf-next 7/7] selftests/bpf: Add test for
 bpf_get_func_ip in kprobe+offset probe
To:     Jiri Olsa <jolsa@redhat.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andriin@fb.com>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        Alan Maguire <alan.maguire@oracle.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jul 7, 2021 at 2:54 PM Jiri Olsa <jolsa@redhat.com> wrote:
>
> Adding test for bpf_get_func_ip in kprobe+ofset probe.

typo: offset

> Because of the offset value it's arch specific, adding
> it only for x86_64 architecture.

I'm not following, you specified +0x5 offset explicitly, why is this
arch-specific?

>
> Signed-off-by: Jiri Olsa <jolsa@kernel.org>
> ---
>  .../testing/selftests/bpf/progs/get_func_ip_test.c  | 13 +++++++++++++
>  1 file changed, 13 insertions(+)
>
> diff --git a/tools/testing/selftests/bpf/progs/get_func_ip_test.c b/tools/testing/selftests/bpf/progs/get_func_ip_test.c
> index 8ca54390d2b1..e8a9428a0ea3 100644
> --- a/tools/testing/selftests/bpf/progs/get_func_ip_test.c
> +++ b/tools/testing/selftests/bpf/progs/get_func_ip_test.c
> @@ -10,6 +10,7 @@ extern const void bpf_fentry_test2 __ksym;
>  extern const void bpf_fentry_test3 __ksym;
>  extern const void bpf_fentry_test4 __ksym;
>  extern const void bpf_modify_return_test __ksym;
> +extern const void bpf_fentry_test6 __ksym;
>
>  __u64 test1_result = 0;
>  SEC("fentry/bpf_fentry_test1")
> @@ -60,3 +61,15 @@ int BPF_PROG(fmod_ret_test, int a, int *b, int ret)
>         test5_result = (const void *) addr == &bpf_modify_return_test;
>         return ret;
>  }
> +
> +#ifdef __x86_64__
> +__u64 test6_result = 0;

see, and you just forgot to update the user-space part of the test to
even check test6_result...

please group variables together and do explicit ASSERT_EQ

> +SEC("kprobe/bpf_fentry_test6+0x5")
> +int test6(struct pt_regs *ctx)
> +{
> +       __u64 addr = bpf_get_func_ip(ctx);
> +
> +       test6_result = (const void *) addr == &bpf_fentry_test6 + 5;
> +       return 0;
> +}
> +#endif
> --
> 2.31.1
>

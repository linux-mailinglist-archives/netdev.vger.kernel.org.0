Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A7C1D567DD7
	for <lists+netdev@lfdr.de>; Wed,  6 Jul 2022 07:32:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231614AbiGFF3b (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Jul 2022 01:29:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53568 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229598AbiGFF3a (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 Jul 2022 01:29:30 -0400
Received: from mail-ed1-x529.google.com (mail-ed1-x529.google.com [IPv6:2a00:1450:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7D6D1201AF;
        Tue,  5 Jul 2022 22:29:29 -0700 (PDT)
Received: by mail-ed1-x529.google.com with SMTP id e40so17847588eda.2;
        Tue, 05 Jul 2022 22:29:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=fCkJCNYCae0Nr8T/7dsc+2ZBwVlwI3ArcfHZRKK0gJI=;
        b=pJrKdtUT0TTlSEpvmyF5KY1eimVuL6bujf0z7P5vcZDcK3OA6djc4xVCXLORZYg5RC
         ET57NyolKHrr/vRZXS+S0TrJbKl4Tav0qqxsG5L1QYeRujuo1rNizfETw+MFE/2btl3L
         5JH1f9xVcLAp/DyAinx9eUw+Poz6bdkQtrmFhK4fueL6tK1TOFpWr2Licyu7+3jlOk+A
         bYFFBaraiGPn08JlOPD4n4DhZlDNeNrfbZfjLQulvRrQdlrOBEFwLkW1BI6HpTmENkSh
         A60cpMkVpaajPw4nuf6EiIGBlCVsAah4B1coMSQZTkEMiXYUlctnpXtm8tJWv8fkjS1v
         jo3g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=fCkJCNYCae0Nr8T/7dsc+2ZBwVlwI3ArcfHZRKK0gJI=;
        b=RyVp4LevUa2b2I1fn14lbMGzPBex6yomuSVeuh0zHClx4f7lIok925nGrtzHzPQGF4
         1BXULzrDSkMzmeicqpEy14nxvjCrIoUZ162AnjTK7AVMXH4VFri7wUAK3xipCW/Hcoxc
         ZuyRV225cM7Dc4ilZPWOOqPSB0nBiDwZi1OuapQxfNtQqA5QgO+PfVlvGWGRaDX0KnWQ
         uthxYerfJyMODzISLn3WgNTccou7+YPGdV+y95nbcl45gVnUamYZ7yhl36OE+cvemtvH
         qtBP23grGbcoWDcxzY6nrI5Y/Bn1FCIElVr22Gs1ywWNsjn4qLpaf104TMPe+vzAIDse
         gePg==
X-Gm-Message-State: AJIora/pwcKLKn3s31j9LYgNJYgoAxBD4O8cr47AKdwkhIeJMNESR6yw
        GpuqjKWyk670L7KxiQ8zUmP/rm1je6Yd46EMZ/o=
X-Google-Smtp-Source: AGRyM1twIaendsBxd/Qym28X3r1TubrzX9nANy3wak8MkCJy4Cx/z6m7JUlETPc10DMS3wrHOTfTakvjtXu21tUx/Fg=
X-Received: by 2002:a05:6402:510b:b0:437:28b0:8988 with SMTP id
 m11-20020a056402510b00b0043728b08988mr52493508edd.260.1657085368107; Tue, 05
 Jul 2022 22:29:28 -0700 (PDT)
MIME-Version: 1.0
References: <20220705190308.1063813-1-jolsa@kernel.org> <20220705190308.1063813-5-jolsa@kernel.org>
In-Reply-To: <20220705190308.1063813-5-jolsa@kernel.org>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Tue, 5 Jul 2022 22:29:17 -0700
Message-ID: <CAEf4BzapX_C16O9woDSXOpbzVsxjYudXW36woRCqU3u75uYiFA@mail.gmail.com>
Subject: Re: [PATCH RFC bpf-next 4/4] selftests/bpf: Fix kprobe get_func_ip
 tests for CONFIG_X86_KERNEL_IBT
To:     Jiri Olsa <jolsa@kernel.org>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        Martynas Pumputis <m@lambda.lt>,
        Yutaro Hayakawa <yutaro.hayakawa@isovalent.com>
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

On Tue, Jul 5, 2022 at 12:04 PM Jiri Olsa <jolsa@kernel.org> wrote:
>
> The kprobe can be placed anywhere and user must be aware
> of the underlying instructions. Therefore fixing just
> the bpf program to 'fix' the address to match the actual
> function address when CONFIG_X86_KERNEL_IBT is enabled.
>
> Signed-off-by: Jiri Olsa <jolsa@kernel.org>
> ---
>  tools/testing/selftests/bpf/progs/get_func_ip_test.c | 7 +++++--
>  1 file changed, 5 insertions(+), 2 deletions(-)
>
> diff --git a/tools/testing/selftests/bpf/progs/get_func_ip_test.c b/tools/testing/selftests/bpf/progs/get_func_ip_test.c
> index a587aeca5ae0..220d56b7c1dc 100644
> --- a/tools/testing/selftests/bpf/progs/get_func_ip_test.c
> +++ b/tools/testing/selftests/bpf/progs/get_func_ip_test.c
> @@ -2,6 +2,7 @@
>  #include <linux/bpf.h>
>  #include <bpf/bpf_helpers.h>
>  #include <bpf/bpf_tracing.h>
> +#include <stdbool.h>
>
>  char _license[] SEC("license") = "GPL";
>
> @@ -13,6 +14,8 @@ extern const void bpf_modify_return_test __ksym;
>  extern const void bpf_fentry_test6 __ksym;
>  extern const void bpf_fentry_test7 __ksym;
>
> +extern bool CONFIG_X86_KERNEL_IBT __kconfig __weak;
> +
>  __u64 test1_result = 0;
>  SEC("fentry/bpf_fentry_test1")
>  int BPF_PROG(test1, int a)
> @@ -37,7 +40,7 @@ __u64 test3_result = 0;
>  SEC("kprobe/bpf_fentry_test3")
>  int test3(struct pt_regs *ctx)
>  {
> -       __u64 addr = bpf_get_func_ip(ctx);
> +       __u64 addr = bpf_get_func_ip(ctx) - (CONFIG_X86_KERNEL_IBT ? 4 : 0);

so for kprobe bpf_get_func_ip() gets an address with 5 byte
compensation for `call __fentry__`, but not for endr? Why can't we
compensate for endbr inside the kernel code as well? I'd imagine we
either do no compensation (and thus we get &bpf_fentry_test3+5 or
&bpf_fentry_test3+9, depending on CONFIG_X86_KERNEL_IBT) or full
compensation (and thus always get &bpf_fentry_test3), but this
in-between solution seems to be the worst of both worlds?...

>
>         test3_result = (const void *) addr == &bpf_fentry_test3;
>         return 0;
> @@ -47,7 +50,7 @@ __u64 test4_result = 0;
>  SEC("kretprobe/bpf_fentry_test4")
>  int BPF_KRETPROBE(test4)
>  {
> -       __u64 addr = bpf_get_func_ip(ctx);
> +       __u64 addr = bpf_get_func_ip(ctx) - (CONFIG_X86_KERNEL_IBT ? 4 : 0);
>
>         test4_result = (const void *) addr == &bpf_fentry_test4;
>         return 0;
> --
> 2.35.3
>

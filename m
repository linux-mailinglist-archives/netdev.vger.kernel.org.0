Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4C0533FF7A8
	for <lists+netdev@lfdr.de>; Fri,  3 Sep 2021 01:08:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347902AbhIBXJ3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Sep 2021 19:09:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56906 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232401AbhIBXJ2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Sep 2021 19:09:28 -0400
Received: from mail-yb1-xb2c.google.com (mail-yb1-xb2c.google.com [IPv6:2607:f8b0:4864:20::b2c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E60B2C061575;
        Thu,  2 Sep 2021 16:08:29 -0700 (PDT)
Received: by mail-yb1-xb2c.google.com with SMTP id c206so6816455ybb.12;
        Thu, 02 Sep 2021 16:08:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=R7sG4e6kx+eb6tbyLRvdBOMvsMhepSQvJQ5aIgHSbio=;
        b=Sz60IyBmHLmRuYj48mP1jyi245Chdlq6s5ky3Y5Wpx6PSKZZrVYlL18JZ8E+6Bj7AV
         PWjqa4Zheflh0BdQqeb/NfSRo5wZ+w1Eim6aXsQkrJhnio3XMsY2bMfhs00ACXqJvTBH
         H9mjQ2MQlw0U6k0LgPCeuRWhp33W3PV/rvbixCELM2znWp9lNVd1o+WRmSf0O9yJDJhl
         VEMIXUOdUIDdqW3Zq/TbR4OVcH3Kb+aldcSttWftAD7b+1Vi9onZ4yHamI1K+yNIk9fL
         Kx1toh7YLFxQHcOT+K1lU7egcpKdy7L0YQoqdrUwFNz49KiraagOHzvsIkd4em911wOo
         Bt1w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=R7sG4e6kx+eb6tbyLRvdBOMvsMhepSQvJQ5aIgHSbio=;
        b=DBg4o+eBN0Vlft48/CuakJZNFS7AO5Fq/boKHZ0gbXsaTXCTW8V6ZjvtoxZveT7JDu
         NrC63e1ij9BKzC9l9HmWIIy4q+oIvr4DLp94kR0c20HHXYqJf0NAmhq03R5RyGqgK/Ib
         TK97nIGgKdCDzFZ2fBQbrLUGwHYFQCsTc99ezTJqvAGplqnYjQIto3T1XoHJ7xeWHb8S
         bpzyzohpFFAlGwPwO2IeUYGGX4Fx/ri36JrLO1osxuZc+SLv+mZtWu4mOWHaEJlmDcpc
         XyKZGR58bkV1gmvdxL8nC76o+ySTTiUaDEtDUT8JF5ZxjB4tnexf10eC1Jn6n+2KyjFu
         bKfw==
X-Gm-Message-State: AOAM531XvkIOpifTs23iY+X7HH+XExfl6vv+oSv0MYWGTLwXgwULcxvl
        L2I/vkvHqb6zVYGpvfi2yAS7kq/5RL81oAm/4ic=
X-Google-Smtp-Source: ABdhPJyxbO7BJlN6R1tuBPuvAyeaezVDv3wNxOp8repPTINWeXsTpcc+dFjGZpog1To/Apfnvc6KAxwB86waVxCqOao=
X-Received: by 2002:a05:6902:70b:: with SMTP id k11mr1035602ybt.510.1630624109105;
 Thu, 02 Sep 2021 16:08:29 -0700 (PDT)
MIME-Version: 1.0
References: <20210902171929.3922667-1-davemarchevsky@fb.com> <20210902171929.3922667-5-davemarchevsky@fb.com>
In-Reply-To: <20210902171929.3922667-5-davemarchevsky@fb.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Thu, 2 Sep 2021 16:08:18 -0700
Message-ID: <CAEf4BzZrGU99UjNv7WROH03HY06h4=keYOL1+fQjv5gnDSMUJA@mail.gmail.com>
Subject: Re: [PATCH v4 bpf-next 4/9] libbpf: Modify bpf_printk to choose
 helper based on arg count
To:     Dave Marchevsky <davemarchevsky@fb.com>
Cc:     bpf <bpf@vger.kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Yonghong Song <yhs@fb.com>, Networking <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Sep 2, 2021 at 10:23 AM Dave Marchevsky <davemarchevsky@fb.com> wrote:
>
> Instead of being a thin wrapper which calls into bpf_trace_printk,
> libbpf's bpf_printk convenience macro now chooses between
> bpf_trace_printk and bpf_trace_vprintk. If the arg count (excluding
> format string) is >3, use bpf_trace_vprintk, otherwise use the older
> helper.
>
> The motivation behind this added complexity - instead of migrating
> entirely to bpf_trace_vprintk - is to maintain good developer experience
> for users compiling against new libbpf but running on older kernels.
> Users who are passing <=3 args to bpf_printk will see no change in their
> bytecode.
>
> __bpf_vprintk functions similarly to BPF_SEQ_PRINTF and BPF_SNPRINTF
> macros elsewhere in the file - it allows use of bpf_trace_vprintk
> without manual conversion of varargs to u64 array. Previous
> implementation of bpf_printk macro is moved to __bpf_printk for use by
> the new implementation.
>
> This does change behavior of bpf_printk calls with >3 args in the "new
> libbpf, old kernels" scenario. Before this patch, attempting to use 4
> args to bpf_printk results in a compile-time error. After this patch,
> using bpf_printk with 4 args results in a trace_vprintk helper call
> being emitted and a load-time failure on older kernels.
>
> Signed-off-by: Dave Marchevsky <davemarchevsky@fb.com>
> ---

Minor nit below, otherwise looks good:

Acked-by: Andrii Nakryiko <andrii@kernel.org>

>  tools/lib/bpf/bpf_helpers.h | 45 ++++++++++++++++++++++++++++++-------
>  1 file changed, 37 insertions(+), 8 deletions(-)
>
> diff --git a/tools/lib/bpf/bpf_helpers.h b/tools/lib/bpf/bpf_helpers.h
> index b9987c3efa3c..a7e73be6dac4 100644
> --- a/tools/lib/bpf/bpf_helpers.h
> +++ b/tools/lib/bpf/bpf_helpers.h
> @@ -14,14 +14,6 @@
>  #define __type(name, val) typeof(val) *name
>  #define __array(name, val) typeof(val) *name[]
>
> -/* Helper macro to print out debug messages */
> -#define bpf_printk(fmt, ...)                           \
> -({                                                     \
> -       char ____fmt[] = fmt;                           \
> -       bpf_trace_printk(____fmt, sizeof(____fmt),      \
> -                        ##__VA_ARGS__);                \
> -})
> -
>  /*
>   * Helper macro to place programs, maps, license in
>   * different sections in elf_bpf file. Section names
> @@ -224,4 +216,41 @@ enum libbpf_tristate {
>                      ___param, sizeof(___param));               \
>  })
>
> +/* Helper macro to print out debug messages */

this comment probably should have been moved into the new bpf_printk() macro...

> +#define __bpf_printk(fmt, ...)                         \
> +({                                                     \
> +       char ____fmt[] = fmt;                           \
> +       bpf_trace_printk(____fmt, sizeof(____fmt),      \
> +                        ##__VA_ARGS__);                \
> +})
> +
> +/*
> + * __bpf_vprintk wraps the bpf_trace_vprintk helper with variadic arguments
> + * instead of an array of u64.
> + */
> +#define __bpf_vprintk(fmt, args...)                            \
> +({                                                             \
> +       static const char ___fmt[] = fmt;                       \
> +       unsigned long long ___param[___bpf_narg(args)];         \
> +                                                               \
> +       _Pragma("GCC diagnostic push")                          \
> +       _Pragma("GCC diagnostic ignored \"-Wint-conversion\"")  \
> +       ___bpf_fill(___param, args);                            \
> +       _Pragma("GCC diagnostic pop")                           \
> +                                                               \
> +       bpf_trace_vprintk(___fmt, sizeof(___fmt),               \
> +                         ___param, sizeof(___param));          \
> +})
> +
> +/* Use __bpf_printk when bpf_printk call has 3 or fewer fmt args
> + * Otherwise use __bpf_vprintk
> + */
> +#define ___bpf_pick_printk(...) \
> +       ___bpf_nth(_, ##__VA_ARGS__, __bpf_vprintk, __bpf_vprintk, __bpf_vprintk,       \
> +                  __bpf_vprintk, __bpf_vprintk, __bpf_vprintk, __bpf_vprintk,          \
> +                  __bpf_vprintk, __bpf_vprintk, __bpf_printk /*3*/, __bpf_printk /*2*/,\
> +                  __bpf_printk /*1*/, __bpf_printk /*0*/)
> +
> +#define bpf_printk(fmt, args...) ___bpf_pick_printk(args)(fmt, ##args)
> +
>  #endif
> --
> 2.30.2
>

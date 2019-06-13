Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D1A3445013
	for <lists+netdev@lfdr.de>; Fri, 14 Jun 2019 01:34:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726743AbfFMXeC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Jun 2019 19:34:02 -0400
Received: from mail-qt1-f193.google.com ([209.85.160.193]:47024 "EHLO
        mail-qt1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726283AbfFMXeB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 13 Jun 2019 19:34:01 -0400
Received: by mail-qt1-f193.google.com with SMTP id h21so408133qtn.13;
        Thu, 13 Jun 2019 16:33:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=XiDPk1leGZPDf0DKAVUArt0sK2Gr92CBTki7UCtdr2g=;
        b=eanAnNzSb3nMGwxznEQ8t3ok8yFfacLU5z4TytxHGLjhOiHemDvI4vvbU6fF55kxn8
         mhCxKUgJUoxcxKAjwVV/uIbZ31i9AwyHfrOCtSkh82926x/0gdG+Is1zcdLUouI6S7Lk
         c/cUjYcv9U9AdBkHUd7qH09ctfRKhg/KvMNfwzxsBe6bSVLbwxsheJaZ0bPToagELRDX
         GBstQnLOyLHPqmuV7pDljsdk2wEByALUmEXAy05lg57dcEC6WK3n8aRF7HC7/K7OpsIA
         3gxkBon7JOAp2FNMt7oS2kPwLBC1YYH8c6aB0VB9ICzQyHRT62/jg16JZZnAYl0BGtbI
         y4Pg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=XiDPk1leGZPDf0DKAVUArt0sK2Gr92CBTki7UCtdr2g=;
        b=AyQ9RmH+N+qNv3B//1IkYcIVugvk6yOT9lSM0s5aIN4Y/jSOUVgg6COVxYv6gSIG7e
         iTJKl21N3wF43vHOCEnC8vabJFgMON2JQuWIX2+nUzIeA0v7c6bAQ3KJq/qDydL4Ki0o
         +tAbCfcs6i8ImitQBfI1e9xWnQVjbdCYkzrFhmp++un9XLetGb1GGwO7AkP17xvxjcK/
         0kD10lLa8Zh7B22JRqPzVNOIK7tlb4s4xh/HmmEaVGiiIEE6P7qxquwcEjN56lfJVGfD
         fb4adnZBlUWZu98KCVAytC208IiAKjTSyclbXFvspP3l2NMzC82+6RAxHEddc3bp3i5f
         Bi5A==
X-Gm-Message-State: APjAAAXv8uKGvIxBgGb0MHdE35TUjdRMi+Smcj9w3yIFQIACx3blvf4H
        +Vmw6YS5k2zgtAJmeyLh375SEokG7zO4IgCT0XE=
X-Google-Smtp-Source: APXvYqymm0VMMb9PaOQTKMq9wAKHx2jgtkSTeK8kAVEA0So2CQSFwvXCb8G7BD/bJwz5YN/C9USqbLPh8vuKNq1/HFI=
X-Received: by 2002:ac8:21b7:: with SMTP id 52mr59094617qty.59.1560468839062;
 Thu, 13 Jun 2019 16:33:59 -0700 (PDT)
MIME-Version: 1.0
References: <20190613042003.3791852-1-ast@kernel.org> <20190613042003.3791852-9-ast@kernel.org>
In-Reply-To: <20190613042003.3791852-9-ast@kernel.org>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Thu, 13 Jun 2019 16:33:47 -0700
Message-ID: <CAEf4BzYZ2ke46j4Rg_e=PsFB3e36PguCk2+-oRR0FQk4n-tnag@mail.gmail.com>
Subject: Re: [PATCH bpf-next 8/9] selftests/bpf: add realistic loop tests
To:     Alexei Starovoitov <ast@kernel.org>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Edward Cree <ecree@solarflare.com>,
        john fastabend <john.fastabend@gmail.com>,
        Andrii Nakryiko <andriin@fb.com>, Jann Horn <jannh@google.com>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Kernel Team <kernel-team@fb.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jun 13, 2019 at 9:49 AM Alexei Starovoitov <ast@kernel.org> wrote:
>
> Add a bunch of loop tests. Most of them are created by replacing
> '#pragma unroll' with '#pragma clang loop unroll(disable)'
>
> Several tests are artificially large:
>   /* partial unroll. llvm will unroll loop ~150 times.
>    * C loop count -> 600.
>    * Asm loop count -> 4.
>    * 16k insns in loop body.
>    * Total of 5 such loops. Total program size ~82k insns.
>    */
>   "./pyperf600.o",
>
>   /* no unroll at all.
>    * C loop count -> 600.
>    * ASM loop count -> 600.
>    * ~110 insns in loop body.
>    * Total of 5 such loops. Total program size ~1500 insns.
>    */
>   "./pyperf600_nounroll.o",
>
>   /* partial unroll. 19k insn in a loop.
>    * Total program size 20.8k insn.
>    * ~350k processed_insns
>    */
>   "./strobemeta.o",
>
> Signed-off-by: Alexei Starovoitov <ast@kernel.org>
> ---

Acked-by: Andrii Nakryiko <andriin@fb.com>

>  .../bpf/prog_tests/bpf_verif_scale.c          |  67 ++-
>  tools/testing/selftests/bpf/progs/loop1.c     |  28 +
>  tools/testing/selftests/bpf/progs/loop2.c     |  28 +
>  tools/testing/selftests/bpf/progs/loop3.c     |  22 +
>  tools/testing/selftests/bpf/progs/pyperf.h    |   6 +-
>  tools/testing/selftests/bpf/progs/pyperf600.c |   9 +
>  .../selftests/bpf/progs/pyperf600_nounroll.c  |   8 +
>  .../testing/selftests/bpf/progs/strobemeta.c  |  10 +
>  .../testing/selftests/bpf/progs/strobemeta.h  | 528 ++++++++++++++++++
>  .../bpf/progs/strobemeta_nounroll1.c          |   9 +
>  .../bpf/progs/strobemeta_nounroll2.c          |   9 +
>  .../selftests/bpf/progs/test_seg6_loop.c      | 261 +++++++++
>  .../selftests/bpf/progs/test_sysctl_loop1.c   |  68 +++
>  .../selftests/bpf/progs/test_sysctl_loop2.c   |  69 +++
>  .../selftests/bpf/progs/test_xdp_loop.c       | 231 ++++++++
>  15 files changed, 1341 insertions(+), 12 deletions(-)
>  create mode 100644 tools/testing/selftests/bpf/progs/loop1.c
>  create mode 100644 tools/testing/selftests/bpf/progs/loop2.c
>  create mode 100644 tools/testing/selftests/bpf/progs/loop3.c
>  create mode 100644 tools/testing/selftests/bpf/progs/pyperf600.c
>  create mode 100644 tools/testing/selftests/bpf/progs/pyperf600_nounroll.c
>  create mode 100644 tools/testing/selftests/bpf/progs/strobemeta.c
>  create mode 100644 tools/testing/selftests/bpf/progs/strobemeta.h
>  create mode 100644 tools/testing/selftests/bpf/progs/strobemeta_nounroll1.c
>  create mode 100644 tools/testing/selftests/bpf/progs/strobemeta_nounroll2.c
>  create mode 100644 tools/testing/selftests/bpf/progs/test_seg6_loop.c
>  create mode 100644 tools/testing/selftests/bpf/progs/test_sysctl_loop1.c
>  create mode 100644 tools/testing/selftests/bpf/progs/test_sysctl_loop2.c
>  create mode 100644 tools/testing/selftests/bpf/progs/test_xdp_loop.c
>
> diff --git a/tools/testing/selftests/bpf/prog_tests/bpf_verif_scale.c b/tools/testing/selftests/bpf/prog_tests/bpf_verif_scale.c
> index c0091137074b..e1b55261526f 100644
> --- a/tools/testing/selftests/bpf/prog_tests/bpf_verif_scale.c
> +++ b/tools/testing/selftests/bpf/prog_tests/bpf_verif_scale.c
> @@ -5,7 +5,7 @@ static int libbpf_debug_print(enum libbpf_print_level level,
>                               const char *format, va_list args)
>  {
>         if (level != LIBBPF_DEBUG)
> -               return 0;
> +               return vfprintf(stderr, format, args);
>
>         if (!strstr(format, "verifier log"))
>                 return 0;
> @@ -32,24 +32,69 @@ static int check_load(const char *file, enum bpf_prog_type type)
>
>  void test_bpf_verif_scale(void)
>  {
> -       const char *scale[] = {
> -               "./test_verif_scale1.o", "./test_verif_scale2.o", "./test_verif_scale3.o"
> +       const char *sched_cls[] = {
> +               "./test_verif_scale1.o", "./test_verif_scale2.o", "./test_verif_scale3.o",
>         };
> -       const char *pyperf[] = {
> -               "./pyperf50.o", "./pyperf100.o", "./pyperf180.o"
> +       const char *raw_tp[] = {
> +               /* full unroll by llvm */
> +               "./pyperf50.o", "./pyperf100.o", "./pyperf180.o",
> +
> +               /* partial unroll. llvm will unroll loop ~150 times.
> +                * C loop count -> 600.
> +                * Asm loop count -> 4.
> +                * 16k insns in loop body.
> +                * Total of 5 such loops. Total program size ~82k insns.
> +                */
> +               "./pyperf600.o",
> +
> +               /* no unroll at all.
> +                * C loop count -> 600.
> +                * ASM loop count -> 600.
> +                * ~110 insns in loop body.
> +                * Total of 5 such loops. Total program size ~1500 insns.
> +                */
> +               "./pyperf600_nounroll.o",
> +
> +               "./loop1.o", "./loop2.o",
> +
> +               /* partial unroll. 19k insn in a loop.
> +                * Total program size 20.8k insn.
> +                * ~350k processed_insns
> +                */
> +               "./strobemeta.o",
> +
> +               /* no unroll, tiny loops */
> +               "./strobemeta_nounroll1.o",
> +               "./strobemeta_nounroll2.o",
> +       };
> +       const char *cg_sysctl[] = {
> +               "./test_sysctl_loop1.o", "./test_sysctl_loop2.o",
>         };
>         int err, i;
>
>         if (verifier_stats)
>                 libbpf_set_print(libbpf_debug_print);
>
> -       for (i = 0; i < ARRAY_SIZE(scale); i++) {
> -               err = check_load(scale[i], BPF_PROG_TYPE_SCHED_CLS);
> -               printf("test_scale:%s:%s\n", scale[i], err ? "FAIL" : "OK");
> +       err = check_load("./loop3.o", BPF_PROG_TYPE_RAW_TRACEPOINT);
> +       printf("test_scale:loop3:%s\n", err ? (error_cnt--, "OK") : "FAIL");
> +
> +       for (i = 0; i < ARRAY_SIZE(sched_cls); i++) {
> +               err = check_load(sched_cls[i], BPF_PROG_TYPE_SCHED_CLS);
> +               printf("test_scale:%s:%s\n", sched_cls[i], err ? "FAIL" : "OK");
>         }
>
> -       for (i = 0; i < ARRAY_SIZE(pyperf); i++) {
> -               err = check_load(pyperf[i], BPF_PROG_TYPE_RAW_TRACEPOINT);
> -               printf("test_scale:%s:%s\n", pyperf[i], err ? "FAIL" : "OK");
> +       for (i = 0; i < ARRAY_SIZE(raw_tp); i++) {
> +               err = check_load(raw_tp[i], BPF_PROG_TYPE_RAW_TRACEPOINT);
> +               printf("test_scale:%s:%s\n", raw_tp[i], err ? "FAIL" : "OK");
>         }
> +
> +       for (i = 0; i < ARRAY_SIZE(cg_sysctl); i++) {
> +               err = check_load(cg_sysctl[i], BPF_PROG_TYPE_CGROUP_SYSCTL);
> +               printf("test_scale:%s:%s\n", cg_sysctl[i], err ? "FAIL" : "OK");
> +       }
> +       err = check_load("./test_xdp_loop.o", BPF_PROG_TYPE_XDP);
> +       printf("test_scale:test_xdp_loop:%s\n", err ? "FAIL" : "OK");
> +
> +       err = check_load("./test_seg6_loop.o", BPF_PROG_TYPE_LWT_SEG6LOCAL);
> +       printf("test_scale:test_seg6_loop:%s\n", err ? "FAIL" : "OK");
>  }
> diff --git a/tools/testing/selftests/bpf/progs/loop1.c b/tools/testing/selftests/bpf/progs/loop1.c
> new file mode 100644
> index 000000000000..dea395af9ea9
> --- /dev/null
> +++ b/tools/testing/selftests/bpf/progs/loop1.c
> @@ -0,0 +1,28 @@
> +// SPDX-License-Identifier: GPL-2.0
> +// Copyright (c) 2019 Facebook
> +#include <linux/sched.h>
> +#include <linux/ptrace.h>
> +#include <stdint.h>
> +#include <stddef.h>
> +#include <stdbool.h>
> +#include <linux/bpf.h>
> +#include "bpf_helpers.h"
> +
> +char _license[] SEC("license") = "GPL";
> +
> +SEC("raw_tracepoint/kfree_skb")
> +int nested_loops(volatile struct pt_regs* ctx)
> +{
> +       int i, j, sum = 0, m;
> +
> +       for (j = 0; j < 300; j++)
> +               for (i = 0; i < j; i++) {
> +                       if (j & 1)
> +                               m = ctx->rax;
> +                       else
> +                               m = j;
> +                       sum += i * m;
> +               }
> +
> +       return sum;
> +}
> diff --git a/tools/testing/selftests/bpf/progs/loop2.c b/tools/testing/selftests/bpf/progs/loop2.c
> new file mode 100644
> index 000000000000..0637bd8e8bcf
> --- /dev/null
> +++ b/tools/testing/selftests/bpf/progs/loop2.c
> @@ -0,0 +1,28 @@
> +// SPDX-License-Identifier: GPL-2.0
> +// Copyright (c) 2019 Facebook
> +#include <linux/sched.h>
> +#include <linux/ptrace.h>
> +#include <stdint.h>
> +#include <stddef.h>
> +#include <stdbool.h>
> +#include <linux/bpf.h>
> +#include "bpf_helpers.h"
> +
> +char _license[] SEC("license") = "GPL";
> +
> +SEC("raw_tracepoint/consume_skb")
> +int while_true(volatile struct pt_regs* ctx)
> +{
> +       int i = 0;
> +
> +       while (true) {
> +               if (ctx->rax & 1)
> +                       i += 3;
> +               else
> +                       i += 7;
> +               if (i > 40)
> +                       break;
> +       }
> +
> +       return i;
> +}
> diff --git a/tools/testing/selftests/bpf/progs/loop3.c b/tools/testing/selftests/bpf/progs/loop3.c
> new file mode 100644
> index 000000000000..30a0f6cba080
> --- /dev/null
> +++ b/tools/testing/selftests/bpf/progs/loop3.c
> @@ -0,0 +1,22 @@
> +// SPDX-License-Identifier: GPL-2.0
> +// Copyright (c) 2019 Facebook
> +#include <linux/sched.h>
> +#include <linux/ptrace.h>
> +#include <stdint.h>
> +#include <stddef.h>
> +#include <stdbool.h>
> +#include <linux/bpf.h>
> +#include "bpf_helpers.h"
> +
> +char _license[] SEC("license") = "GPL";
> +
> +SEC("raw_tracepoint/consume_skb")
> +int while_true(volatile struct pt_regs* ctx)
> +{
> +       __u64 i = 0, sum = 0;
> +       do {
> +               i++;
> +               sum += ctx->rax;
> +       } while (i < 0x100000000ULL);
> +       return sum;
> +}
> diff --git a/tools/testing/selftests/bpf/progs/pyperf.h b/tools/testing/selftests/bpf/progs/pyperf.h
> index 0cc5e4ee90bd..6b0781391be5 100644
> --- a/tools/testing/selftests/bpf/progs/pyperf.h
> +++ b/tools/testing/selftests/bpf/progs/pyperf.h
> @@ -220,7 +220,11 @@ static inline __attribute__((__always_inline__)) int __on_event(struct pt_regs *
>                 int32_t* symbol_counter = bpf_map_lookup_elem(&symbolmap, &sym);
>                 if (symbol_counter == NULL)
>                         return 0;
> -#pragma unroll
> +#ifdef NO_UNROLL
> +#pragma clang loop unroll(disable)
> +#else
> +#pragma clang loop unroll(full)
> +#endif
>                 /* Unwind python stack */
>                 for (int i = 0; i < STACK_MAX_LEN; ++i) {
>                         if (frame_ptr && get_frame_data(frame_ptr, pidData, &frame, &sym)) {
> diff --git a/tools/testing/selftests/bpf/progs/pyperf600.c b/tools/testing/selftests/bpf/progs/pyperf600.c
> new file mode 100644
> index 000000000000..cb49b89e37cd
> --- /dev/null
> +++ b/tools/testing/selftests/bpf/progs/pyperf600.c
> @@ -0,0 +1,9 @@
> +// SPDX-License-Identifier: GPL-2.0
> +// Copyright (c) 2019 Facebook
> +#define STACK_MAX_LEN 600
> +/* clang will not unroll the loop 600 times.
> + * Instead it will unroll it to the amount it deemed
> + * appropriate, but the loop will still execute 600 times.
> + * Total program size is around 90k insns
> + */
> +#include "pyperf.h"
> diff --git a/tools/testing/selftests/bpf/progs/pyperf600_nounroll.c b/tools/testing/selftests/bpf/progs/pyperf600_nounroll.c
> new file mode 100644
> index 000000000000..6beff7502f4d
> --- /dev/null
> +++ b/tools/testing/selftests/bpf/progs/pyperf600_nounroll.c
> @@ -0,0 +1,8 @@
> +// SPDX-License-Identifier: GPL-2.0
> +// Copyright (c) 2019 Facebook
> +#define STACK_MAX_LEN 600
> +#define NO_UNROLL
> +/* clang will not unroll at all.
> + * Total program size is around 2k insns
> + */
> +#include "pyperf.h"
> diff --git a/tools/testing/selftests/bpf/progs/strobemeta.c b/tools/testing/selftests/bpf/progs/strobemeta.c
> new file mode 100644
> index 000000000000..d3df3d86f092
> --- /dev/null
> +++ b/tools/testing/selftests/bpf/progs/strobemeta.c
> @@ -0,0 +1,10 @@
> +// SPDX-License-Identifier: (LGPL-2.1 OR BSD-2-Clause)
> +// Copyright (c) 2019 Facebook
> +
> +#define STROBE_MAX_INTS 2
> +#define STROBE_MAX_STRS 25
> +#define STROBE_MAX_MAPS 100
> +#define STROBE_MAX_MAP_ENTRIES 20
> +/* full unroll by llvm #undef NO_UNROLL */
> +#include "strobemeta.h"
> +
> diff --git a/tools/testing/selftests/bpf/progs/strobemeta.h b/tools/testing/selftests/bpf/progs/strobemeta.h
> new file mode 100644
> index 000000000000..1ff73f60a3e4
> --- /dev/null
> +++ b/tools/testing/selftests/bpf/progs/strobemeta.h
> @@ -0,0 +1,528 @@
> +// SPDX-License-Identifier: GPL-2.0

Let's make this (LGPL-2.1 OR BSD-2-Clause) ?

> +// Copyright (c) 2019 Facebook
> +
> +#include <stdint.h>
> +#include <stddef.h>
> +#include <stdbool.h>
> +#include <linux/bpf.h>
> +#include <linux/ptrace.h>
> +#include <linux/sched.h>
> +#include <linux/types.h>
> +#include "bpf_helpers.h"
> +
> +typedef uint32_t pid_t;
> +struct task_struct {};
> +
> +#define TASK_COMM_LEN 16
> +#define PERF_MAX_STACK_DEPTH 127
> +
> +#define STROBE_TYPE_INVALID 0
> +#define STROBE_TYPE_INT 1
> +#define STROBE_TYPE_STR 2
> +#define STROBE_TYPE_MAP 3
> +
> +#define STACK_TABLE_EPOCH_SHIFT 20
> +#define STROBE_MAX_STR_LEN 1
> +#define STROBE_MAX_CFGS 32
> +#define STROBE_MAX_PAYLOAD                                             \
> +       (STROBE_MAX_STRS * STROBE_MAX_STR_LEN +                         \
> +       STROBE_MAX_MAPS * (1 + STROBE_MAX_MAP_ENTRIES * 2) * STROBE_MAX_STR_LEN)
> +
> +struct strobe_value_header {
> +       /*
> +        * meaning depends on type:
> +        * 1. int: 0, if value not set, 1 otherwise
> +        * 2. str: 1 always, whether value is set or not is determined by ptr
> +        * 3. map: 1 always, pointer points to additional struct with number
> +        *    of entries (up to STROBE_MAX_MAP_ENTRIES)
> +        */
> +       uint16_t len;
> +       /*
> +        * _reserved might be used for some future fields/flags, but we always
> +        * want to keep strobe_value_header to be 8 bytes, so BPF can read 16
> +        * bytes in one go and get both header and value
> +        */
> +       uint8_t _reserved[6];
> +};
> +
> +/*
> + * strobe_value_generic is used from BPF probe only, but needs to be a union
> + * of strobe_value_int/strobe_value_str/strobe_value_map
> + */
> +struct strobe_value_generic {
> +       struct strobe_value_header header;
> +       union {
> +               int64_t val;
> +               void *ptr;
> +       };
> +};
> +
> +struct strobe_value_int {
> +       struct strobe_value_header header;
> +       int64_t value;
> +};
> +
> +struct strobe_value_str {
> +       struct strobe_value_header header;
> +       const char* value;
> +};
> +
> +struct strobe_value_map {
> +       struct strobe_value_header header;
> +       const struct strobe_map_raw* value;
> +};
> +
> +struct strobe_map_entry {
> +       const char* key;
> +       const char* val;
> +};
> +
> +/*
> + * Map of C-string key/value pairs with fixed maximum capacity. Each map has
> + * corresponding int64 ID, which application can use (or ignore) in whatever
> + * way appropriate. Map is "write-only", there is no way to get data out of
> + * map. Map is intended to be used to provide metadata for profilers and is
> + * not to be used for internal in-app communication. All methods are
> + * thread-safe.
> + */
> +struct strobe_map_raw {
> +       /*
> +        * general purpose unique ID that's up to application to decide
> +        * whether and how to use; for request metadata use case id is unique
> +        * request ID that's used to match metadata with stack traces on
> +        * Strobelight backend side
> +        */
> +       int64_t id;
> +       /* number of used entries in map */
> +       int64_t cnt;
> +       /*
> +        * having volatile doesn't change anything on BPF side, but clang
> +        * emits warnings for passing `volatile const char *` into
> +        * bpf_probe_read_str that expects just `const char *`
> +        */
> +       const char* tag;
> +       /*
> +        * key/value entries, each consisting of 2 pointers to key and value
> +        * C strings
> +        */
> +       struct strobe_map_entry entries[STROBE_MAX_MAP_ENTRIES];
> +};
> +
> +/* Following values define supported values of TLS mode */
> +#define TLS_NOT_SET -1
> +#define TLS_LOCAL_EXEC 0
> +#define TLS_IMM_EXEC 1
> +#define TLS_GENERAL_DYN 2
> +
> +/*
> + * structure that universally represents TLS location (both for static
> + * executables and shared libraries)
> + */
> +struct strobe_value_loc {
> +       /*
> +        * tls_mode defines what TLS mode was used for particular metavariable:
> +        * - -1 (TLS_NOT_SET) - no metavariable;
> +        * - 0 (TLS_LOCAL_EXEC) - Local Executable mode;
> +        * - 1 (TLS_IMM_EXEC) - Immediate Executable mode;
> +        * - 2 (TLS_GENERAL_DYN) - General Dynamic mode;
> +        * Local Dynamic mode is not yet supported, because never seen in
> +        * practice.  Mode defines how offset field is interpreted. See
> +        * calc_location() in below for details.
> +        */
> +       int64_t tls_mode;
> +       /*
> +        * TLS_LOCAL_EXEC: offset from thread pointer (fs:0 for x86-64,
> +        * tpidr_el0 for aarch64).
> +        * TLS_IMM_EXEC: absolute address of GOT entry containing offset
> +        * from thread pointer;
> +        * TLS_GENERAL_DYN: absolute addres of double GOT entry
> +        * containing tls_index_t struct;
> +        */
> +       int64_t offset;
> +};
> +
> +struct strobemeta_cfg {
> +       int64_t req_meta_idx;
> +       struct strobe_value_loc int_locs[STROBE_MAX_INTS];
> +       struct strobe_value_loc str_locs[STROBE_MAX_STRS];
> +       struct strobe_value_loc map_locs[STROBE_MAX_MAPS];
> +};
> +
> +struct strobe_map_descr {
> +       uint64_t id;
> +       int16_t tag_len;
> +       /*
> +        * cnt <0 - map value isn't set;
> +        * 0 - map has id set, but no key/value entries
> +        */
> +       int16_t cnt;
> +       /*
> +        * both key_lens[i] and val_lens[i] should be >0 for present key/value
> +        * entry
> +        */
> +       uint16_t key_lens[STROBE_MAX_MAP_ENTRIES];
> +       uint16_t val_lens[STROBE_MAX_MAP_ENTRIES];
> +};
> +
> +struct strobemeta_payload {
> +       /* req_id has valid request ID, if req_meta_valid == 1 */
> +       int64_t req_id;
> +       uint8_t req_meta_valid;
> +       /*
> +        * mask has Nth bit set to 1, if Nth metavar was present and
> +        * successfully read
> +        */
> +       uint64_t int_vals_set_mask;
> +       int64_t int_vals[STROBE_MAX_INTS];
> +       /* len is >0 for present values */
> +       uint16_t str_lens[STROBE_MAX_STRS];
> +       /* if map_descrs[i].cnt == -1, metavar is not present/set */
> +       struct strobe_map_descr map_descrs[STROBE_MAX_MAPS];
> +       /*
> +        * payload has compactly packed values of str and map variables in the
> +        * form: strval1\0strval2\0map1key1\0map1val1\0map2key1\0map2val1\0
> +        * (and so on); str_lens[i], key_lens[i] and val_lens[i] determines
> +        * value length
> +        */
> +       char payload[STROBE_MAX_PAYLOAD];
> +};
> +
> +struct strobelight_bpf_sample {
> +       uint64_t ktime;
> +       char comm[TASK_COMM_LEN];
> +       pid_t pid;
> +       int user_stack_id;
> +       int kernel_stack_id;
> +       int has_meta;
> +       struct strobemeta_payload metadata;
> +       /*
> +        * makes it possible to pass (<real payload size> + 1) as data size to
> +        * perf_submit() to avoid perf_submit's paranoia about passing zero as
> +        * size, as it deduces that <real payload size> might be
> +        * **theoretically** zero
> +        */
> +       char dummy_safeguard;
> +};
> +
> +struct bpf_map_def SEC("maps") samples = {
> +       .type = BPF_MAP_TYPE_PERF_EVENT_ARRAY,
> +       .key_size = sizeof(int),
> +       .value_size = sizeof(int),
> +       .max_entries = 32,
> +};
> +
> +struct bpf_map_def SEC("maps") stacks_0 = {
> +       .type = BPF_MAP_TYPE_STACK_TRACE,
> +       .key_size = sizeof(uint32_t),
> +       .value_size = sizeof(uint64_t) * PERF_MAX_STACK_DEPTH,
> +       .max_entries = 16,
> +};
> +
> +struct bpf_map_def SEC("maps") stacks_1 = {
> +       .type = BPF_MAP_TYPE_STACK_TRACE,
> +       .key_size = sizeof(uint32_t),
> +       .value_size = sizeof(uint64_t) * PERF_MAX_STACK_DEPTH,
> +       .max_entries = 16,
> +};
> +
> +struct bpf_map_def SEC("maps") sample_heap = {
> +       .type = BPF_MAP_TYPE_PERCPU_ARRAY,
> +       .key_size = sizeof(uint32_t),
> +       .value_size = sizeof(struct strobelight_bpf_sample),
> +       .max_entries = 1,
> +};
> +
> +struct bpf_map_def SEC("maps") strobemeta_cfgs = {
> +       .type = BPF_MAP_TYPE_PERCPU_ARRAY,
> +       .key_size = sizeof(pid_t),
> +       .value_size = sizeof(struct strobemeta_cfg),
> +       .max_entries = STROBE_MAX_CFGS,
> +};
> +
> +/* Type for the dtv.  */
> +/* https://github.com/lattera/glibc/blob/master/nptl/sysdeps/x86_64/tls.h#L34 */
> +typedef union dtv {
> +       size_t counter;
> +       struct {
> +               void* val;
> +               bool is_static;
> +       } pointer;
> +} dtv_t;
> +
> +/* Partial definition for tcbhead_t */
> +/* https://github.com/bminor/glibc/blob/master/sysdeps/x86_64/nptl/tls.h#L42 */
> +struct tcbhead {
> +       void* tcb;
> +       dtv_t* dtv;
> +};
> +
> +/*
> + * TLS module/offset information for shared library case.
> + * For x86-64, this is mapped onto two entries in GOT.
> + * For aarch64, this is pointed to by second GOT entry.
> + */
> +struct tls_index {
> +       uint64_t module;
> +       uint64_t offset;
> +};
> +
> +static inline __attribute__((always_inline))
> +void *calc_location(struct strobe_value_loc *loc, void *tls_base)
> +{
> +       /*
> +        * tls_mode value is:
> +        * - -1 (TLS_NOT_SET), if no metavar is present;
> +        * - 0 (TLS_LOCAL_EXEC), if metavar uses Local Executable mode of TLS
> +        * (offset from fs:0 for x86-64 or tpidr_el0 for aarch64);
> +        * - 1 (TLS_IMM_EXEC), if metavar uses Immediate Executable mode of TLS;
> +        * - 2 (TLS_GENERAL_DYN), if metavar uses General Dynamic mode of TLS;
> +        * This schema allows to use something like:
> +        * (tls_mode + 1) * (tls_base + offset)
> +        * to get NULL for "no metavar" location, or correct pointer for local
> +        * executable mode without doing extra ifs.
> +        */
> +       if (loc->tls_mode <= TLS_LOCAL_EXEC) {
> +               /* static executable is simple, we just have offset from
> +                * tls_base */
> +               void *addr = tls_base + loc->offset;
> +               /* multiply by (tls_mode + 1) to get NULL, if we have no
> +                * metavar in this slot */
> +               return (void *)((loc->tls_mode + 1) * (int64_t)addr);
> +       }
> +       /*
> +        * Other modes are more complicated, we need to jump through few hoops.
> +        *
> +        * For immediate executable mode (currently supported only for aarch64):
> +        *  - loc->offset is pointing to a GOT entry containing fixed offset
> +        *  relative to tls_base;
> +        *
> +        * For general dynamic mode:
> +        *  - loc->offset is pointing to a beginning of double GOT entries;
> +        *  - (for aarch64 only) second entry points to tls_index_t struct;
> +        *  - (for x86-64 only) two GOT entries are already tls_index_t;
> +        *  - tls_index_t->module is used to find start of TLS section in
> +        *  which variable resides;
> +        *  - tls_index_t->offset provides offset within that TLS section,
> +        *  pointing to value of variable.
> +        */
> +       struct tls_index tls_index;
> +       dtv_t *dtv;
> +       void *tls_ptr;
> +
> +       bpf_probe_read(&tls_index, sizeof(struct tls_index),
> +                      (void *)loc->offset);
> +       /* valid module index is always positive */
> +       if (tls_index.module > 0) {
> +               /* dtv = ((struct tcbhead *)tls_base)->dtv[tls_index.module] */
> +               bpf_probe_read(&dtv, sizeof(dtv),
> +                              &((struct tcbhead *)tls_base)->dtv);
> +               dtv += tls_index.module;
> +       } else {
> +               dtv = NULL;
> +       }
> +       bpf_probe_read(&tls_ptr, sizeof(void *), dtv);
> +       /* if pointer has (void *)-1 value, then TLS wasn't initialized yet */
> +       return tls_ptr && tls_ptr != (void *)-1
> +               ? tls_ptr + tls_index.offset
> +               : NULL;
> +}
> +
> +static inline __attribute__((always_inline))
> +void read_int_var(struct strobemeta_cfg *cfg, size_t idx, void *tls_base,
> +                 struct strobe_value_generic *value,
> +                 struct strobemeta_payload *data)
> +{
> +       void *location = calc_location(&cfg->int_locs[idx], tls_base);
> +       if (!location)
> +               return;
> +
> +       bpf_probe_read(value, sizeof(struct strobe_value_generic), location);
> +       data->int_vals[idx] = value->val;
> +       if (value->header.len)
> +               data->int_vals_set_mask |= (1 << idx);
> +}
> +
> +static inline __attribute__((always_inline))
> +uint64_t read_str_var(struct strobemeta_cfg* cfg, size_t idx, void *tls_base,
> +                     struct strobe_value_generic *value,
> +                     struct strobemeta_payload *data, void *payload)
> +{
> +       void *location;
> +       uint32_t len;
> +
> +       data->str_lens[idx] = 0;
> +       location = calc_location(&cfg->str_locs[idx], tls_base);
> +       if (!location)
> +               return 0;
> +
> +       bpf_probe_read(value, sizeof(struct strobe_value_generic), location);
> +       len = bpf_probe_read_str(payload, STROBE_MAX_STR_LEN, value->ptr);
> +       /*
> +        * if bpf_probe_read_str returns error (<0), due to casting to
> +        * unsinged int, it will become big number, so next check is
> +        * sufficient to check for errors AND prove to BPF verifier, that
> +        * bpf_probe_read_str won't return anything bigger than
> +        * STROBE_MAX_STR_LEN
> +        */
> +       if (len > STROBE_MAX_STR_LEN)
> +               return 0;
> +
> +       data->str_lens[idx] = len;
> +       return len;
> +}
> +
> +static inline __attribute__((always_inline))
> +void *read_map_var(struct strobemeta_cfg *cfg, size_t idx, void *tls_base,
> +                  struct strobe_value_generic *value,
> +                  struct strobemeta_payload* data, void *payload)
> +{
> +       struct strobe_map_descr* descr = &data->map_descrs[idx];
> +       struct strobe_map_raw map;
> +       void *location;
> +       uint32_t len;
> +       int i;
> +
> +       descr->tag_len = 0; /* presume no tag is set */
> +       descr->cnt = -1; /* presume no value is set */
> +
> +       location = calc_location(&cfg->map_locs[idx], tls_base);
> +       if (!location)
> +               return payload;
> +
> +       bpf_probe_read(value, sizeof(struct strobe_value_generic), location);
> +       if (bpf_probe_read(&map, sizeof(struct strobe_map_raw), value->ptr))
> +               return payload;
> +
> +       descr->id = map.id;
> +       descr->cnt = map.cnt;
> +       if (cfg->req_meta_idx == idx) {
> +               data->req_id = map.id;
> +               data->req_meta_valid = 1;
> +       }
> +
> +       len = bpf_probe_read_str(payload, STROBE_MAX_STR_LEN, map.tag);
> +       if (len <= STROBE_MAX_STR_LEN) {
> +               descr->tag_len = len;
> +               payload += len;
> +       }
> +
> +#ifdef NO_UNROLL
> +#pragma clang loop unroll(disable)
> +#else
> +#pragma unroll
> +#endif
> +       for (int i = 0; i < STROBE_MAX_MAP_ENTRIES && i < map.cnt; ++i) {
> +               descr->key_lens[i] = 0;
> +               len = bpf_probe_read_str(payload, STROBE_MAX_STR_LEN,
> +                                        map.entries[i].key);
> +               if (len <= STROBE_MAX_STR_LEN) {
> +                       descr->key_lens[i] = len;
> +                       payload += len;
> +               }
> +               descr->val_lens[i] = 0;
> +               len = bpf_probe_read_str(payload, STROBE_MAX_STR_LEN,
> +                                        map.entries[i].val);
> +               if (len <= STROBE_MAX_STR_LEN) {
> +                       descr->val_lens[i] = len;
> +                       payload += len;
> +               }
> +       }
> +
> +       return payload;
> +}
> +
> +/*
> + * read_strobe_meta returns NULL, if no metadata was read; otherwise returns
> + * pointer to *right after* payload ends
> + */
> +static inline __attribute__((always_inline))
> +void *read_strobe_meta(struct task_struct* task,
> +                      struct strobemeta_payload* data) {
> +       pid_t pid = bpf_get_current_pid_tgid() >> 32;
> +       struct strobe_value_generic value = {0};
> +       struct strobemeta_cfg *cfg;
> +       void *tls_base, *payload;
> +
> +       cfg = bpf_map_lookup_elem(&strobemeta_cfgs, &pid);
> +       if (!cfg)
> +               return NULL;
> +
> +       data->int_vals_set_mask = 0;
> +       data->req_meta_valid = 0;
> +       payload = data->payload;
> +       /*
> +        * we don't have struct task_struct definition, it should be:
> +        * tls_base = (void *)task->thread.fsbase;
> +        */
> +       tls_base = (void *)task;
> +
> +#ifdef NO_UNROLL
> +#pragma clang loop unroll(disable)
> +#else
> +#pragma unroll
> +#endif
> +       for (int i = 0; i < STROBE_MAX_INTS; ++i) {
> +               read_int_var(cfg, i, tls_base, &value, data);
> +       }
> +#ifdef NO_UNROLL
> +#pragma clang loop unroll(disable)
> +#else
> +#pragma unroll
> +#endif
> +       for (int i = 0; i < STROBE_MAX_STRS; ++i) {
> +               payload += read_str_var(cfg, i, tls_base, &value, data, payload);
> +       }
> +#ifdef NO_UNROLL
> +#pragma clang loop unroll(disable)
> +#else
> +#pragma unroll
> +#endif
> +       for (int i = 0; i < STROBE_MAX_MAPS; ++i) {
> +               payload = read_map_var(cfg, i, tls_base, &value, data, payload);
> +       }
> +       /*
> +        * return pointer right after end of payload, so it's possible to
> +        * calculate exact amount of useful data that needs to be sent
> +        */
> +       return payload;
> +}
> +
> +SEC("raw_tracepoint/kfree_skb")
> +int on_event(struct pt_regs *ctx) {
> +       pid_t pid =  bpf_get_current_pid_tgid() >> 32;
> +       struct strobelight_bpf_sample* sample;
> +       struct task_struct *task;
> +       uint32_t zero = 0;
> +       uint64_t ktime_ns;
> +       void *sample_end;
> +
> +       sample = bpf_map_lookup_elem(&sample_heap, &zero);
> +       if (!sample)
> +               return 0; /* this will never happen */
> +
> +       sample->pid = pid;
> +       bpf_get_current_comm(&sample->comm, TASK_COMM_LEN);
> +       ktime_ns = bpf_ktime_get_ns();
> +       sample->ktime = ktime_ns;
> +
> +       task = (struct task_struct *)bpf_get_current_task();
> +       sample_end = read_strobe_meta(task, &sample->metadata);
> +       sample->has_meta = sample_end != NULL;
> +       sample_end = sample_end ? : &sample->metadata;
> +
> +       if ((ktime_ns >> STACK_TABLE_EPOCH_SHIFT) & 1) {
> +               sample->kernel_stack_id = bpf_get_stackid(ctx, &stacks_1, 0);
> +               sample->user_stack_id = bpf_get_stackid(ctx, &stacks_1, BPF_F_USER_STACK);
> +       } else {
> +               sample->kernel_stack_id = bpf_get_stackid(ctx, &stacks_0, 0);
> +               sample->user_stack_id = bpf_get_stackid(ctx, &stacks_0, BPF_F_USER_STACK);
> +       }
> +
> +       uint64_t sample_size = sample_end - (void *)sample;
> +       /* should always be true */
> +       if (sample_size < sizeof(struct strobelight_bpf_sample))
> +               bpf_perf_event_output(ctx, &samples, 0, sample, 1 + sample_size);
> +       return 0;
> +}
> +
> +char _license[] SEC("license") = "GPL";
> diff --git a/tools/testing/selftests/bpf/progs/strobemeta_nounroll1.c b/tools/testing/selftests/bpf/progs/strobemeta_nounroll1.c
> new file mode 100644
> index 000000000000..f0a1669e11d6
> --- /dev/null
> +++ b/tools/testing/selftests/bpf/progs/strobemeta_nounroll1.c
> @@ -0,0 +1,9 @@
> +// SPDX-License-Identifier: (LGPL-2.1 OR BSD-2-Clause)
> +// Copyright (c) 2019 Facebook
> +
> +#define STROBE_MAX_INTS 2
> +#define STROBE_MAX_STRS 25
> +#define STROBE_MAX_MAPS 13
> +#define STROBE_MAX_MAP_ENTRIES 20
> +#define NO_UNROLL
> +#include "strobemeta.h"
> diff --git a/tools/testing/selftests/bpf/progs/strobemeta_nounroll2.c b/tools/testing/selftests/bpf/progs/strobemeta_nounroll2.c
> new file mode 100644
> index 000000000000..4291a7d642e7
> --- /dev/null
> +++ b/tools/testing/selftests/bpf/progs/strobemeta_nounroll2.c
> @@ -0,0 +1,9 @@
> +// SPDX-License-Identifier: (LGPL-2.1 OR BSD-2-Clause)
> +// Copyright (c) 2019 Facebook
> +
> +#define STROBE_MAX_INTS 2
> +#define STROBE_MAX_STRS 25
> +#define STROBE_MAX_MAPS 30
> +#define STROBE_MAX_MAP_ENTRIES 20
> +#define NO_UNROLL
> +#include "strobemeta.h"
> diff --git a/tools/testing/selftests/bpf/progs/test_seg6_loop.c b/tools/testing/selftests/bpf/progs/test_seg6_loop.c
> new file mode 100644
> index 000000000000..463964d79f73
> --- /dev/null
> +++ b/tools/testing/selftests/bpf/progs/test_seg6_loop.c
> @@ -0,0 +1,261 @@
> +#include <stddef.h>
> +#include <inttypes.h>
> +#include <errno.h>
> +#include <linux/seg6_local.h>
> +#include <linux/bpf.h>
> +#include "bpf_helpers.h"
> +#include "bpf_endian.h"
> +
> +/* Packet parsing state machine helpers. */
> +#define cursor_advance(_cursor, _len) \
> +       ({ void *_tmp = _cursor; _cursor += _len; _tmp; })
> +
> +#define SR6_FLAG_ALERT (1 << 4)
> +
> +#define htonll(x) ((bpf_htonl(1)) == 1 ? (x) : ((uint64_t)bpf_htonl((x) & \
> +                               0xFFFFFFFF) << 32) | bpf_htonl((x) >> 32))
> +#define ntohll(x) ((bpf_ntohl(1)) == 1 ? (x) : ((uint64_t)bpf_ntohl((x) & \
> +                               0xFFFFFFFF) << 32) | bpf_ntohl((x) >> 32))
> +#define BPF_PACKET_HEADER __attribute__((packed))
> +
> +struct ip6_t {
> +       unsigned int ver:4;
> +       unsigned int priority:8;
> +       unsigned int flow_label:20;
> +       unsigned short payload_len;
> +       unsigned char next_header;
> +       unsigned char hop_limit;
> +       unsigned long long src_hi;
> +       unsigned long long src_lo;
> +       unsigned long long dst_hi;
> +       unsigned long long dst_lo;
> +} BPF_PACKET_HEADER;
> +
> +struct ip6_addr_t {
> +       unsigned long long hi;
> +       unsigned long long lo;
> +} BPF_PACKET_HEADER;
> +
> +struct ip6_srh_t {
> +       unsigned char nexthdr;
> +       unsigned char hdrlen;
> +       unsigned char type;
> +       unsigned char segments_left;
> +       unsigned char first_segment;
> +       unsigned char flags;
> +       unsigned short tag;
> +
> +       struct ip6_addr_t segments[0];
> +} BPF_PACKET_HEADER;
> +
> +struct sr6_tlv_t {
> +       unsigned char type;
> +       unsigned char len;
> +       unsigned char value[0];
> +} BPF_PACKET_HEADER;
> +
> +static __attribute__((always_inline)) struct ip6_srh_t *get_srh(struct __sk_buff *skb)
> +{
> +       void *cursor, *data_end;
> +       struct ip6_srh_t *srh;
> +       struct ip6_t *ip;
> +       uint8_t *ipver;
> +
> +       data_end = (void *)(long)skb->data_end;
> +       cursor = (void *)(long)skb->data;
> +       ipver = (uint8_t *)cursor;
> +
> +       if ((void *)ipver + sizeof(*ipver) > data_end)
> +               return NULL;
> +
> +       if ((*ipver >> 4) != 6)
> +               return NULL;
> +
> +       ip = cursor_advance(cursor, sizeof(*ip));
> +       if ((void *)ip + sizeof(*ip) > data_end)
> +               return NULL;
> +
> +       if (ip->next_header != 43)
> +               return NULL;
> +
> +       srh = cursor_advance(cursor, sizeof(*srh));
> +       if ((void *)srh + sizeof(*srh) > data_end)
> +               return NULL;
> +
> +       if (srh->type != 4)
> +               return NULL;
> +
> +       return srh;
> +}
> +
> +static __attribute__((always_inline))
> +int update_tlv_pad(struct __sk_buff *skb, uint32_t new_pad,
> +                  uint32_t old_pad, uint32_t pad_off)
> +{
> +       int err;
> +
> +       if (new_pad != old_pad) {
> +               err = bpf_lwt_seg6_adjust_srh(skb, pad_off,
> +                                         (int) new_pad - (int) old_pad);
> +               if (err)
> +                       return err;
> +       }
> +
> +       if (new_pad > 0) {
> +               char pad_tlv_buf[16] = {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
> +                                       0, 0, 0};
> +               struct sr6_tlv_t *pad_tlv = (struct sr6_tlv_t *) pad_tlv_buf;
> +
> +               pad_tlv->type = SR6_TLV_PADDING;
> +               pad_tlv->len = new_pad - 2;
> +
> +               err = bpf_lwt_seg6_store_bytes(skb, pad_off,
> +                                              (void *)pad_tlv_buf, new_pad);
> +               if (err)
> +                       return err;
> +       }
> +
> +       return 0;
> +}
> +
> +static __attribute__((always_inline))
> +int is_valid_tlv_boundary(struct __sk_buff *skb, struct ip6_srh_t *srh,
> +                         uint32_t *tlv_off, uint32_t *pad_size,
> +                         uint32_t *pad_off)
> +{
> +       uint32_t srh_off, cur_off;
> +       int offset_valid = 0;
> +       int err;
> +
> +       srh_off = (char *)srh - (char *)(long)skb->data;
> +       // cur_off = end of segments, start of possible TLVs
> +       cur_off = srh_off + sizeof(*srh) +
> +               sizeof(struct ip6_addr_t) * (srh->first_segment + 1);
> +
> +       *pad_off = 0;
> +
> +       // we can only go as far as ~10 TLVs due to the BPF max stack size
> +       #pragma clang loop unroll(disable)
> +       for (int i = 0; i < 100; i++) {
> +               struct sr6_tlv_t tlv;
> +
> +               if (cur_off == *tlv_off)
> +                       offset_valid = 1;
> +
> +               if (cur_off >= srh_off + ((srh->hdrlen + 1) << 3))
> +                       break;
> +
> +               err = bpf_skb_load_bytes(skb, cur_off, &tlv, sizeof(tlv));
> +               if (err)
> +                       return err;
> +
> +               if (tlv.type == SR6_TLV_PADDING) {
> +                       *pad_size = tlv.len + sizeof(tlv);
> +                       *pad_off = cur_off;
> +
> +                       if (*tlv_off == srh_off) {
> +                               *tlv_off = cur_off;
> +                               offset_valid = 1;
> +                       }
> +                       break;
> +
> +               } else if (tlv.type == SR6_TLV_HMAC) {
> +                       break;
> +               }
> +
> +               cur_off += sizeof(tlv) + tlv.len;
> +       } // we reached the padding or HMAC TLVs, or the end of the SRH
> +
> +       if (*pad_off == 0)
> +               *pad_off = cur_off;
> +
> +       if (*tlv_off == -1)
> +               *tlv_off = cur_off;
> +       else if (!offset_valid)
> +               return -EINVAL;
> +
> +       return 0;
> +}
> +
> +static __attribute__((always_inline))
> +int add_tlv(struct __sk_buff *skb, struct ip6_srh_t *srh, uint32_t tlv_off,
> +           struct sr6_tlv_t *itlv, uint8_t tlv_size)
> +{
> +       uint32_t srh_off = (char *)srh - (char *)(long)skb->data;
> +       uint8_t len_remaining, new_pad;
> +       uint32_t pad_off = 0;
> +       uint32_t pad_size = 0;
> +       uint32_t partial_srh_len;
> +       int err;
> +
> +       if (tlv_off != -1)
> +               tlv_off += srh_off;
> +
> +       if (itlv->type == SR6_TLV_PADDING || itlv->type == SR6_TLV_HMAC)
> +               return -EINVAL;
> +
> +       err = is_valid_tlv_boundary(skb, srh, &tlv_off, &pad_size, &pad_off);
> +       if (err)
> +               return err;
> +
> +       err = bpf_lwt_seg6_adjust_srh(skb, tlv_off, sizeof(*itlv) + itlv->len);
> +       if (err)
> +               return err;
> +
> +       err = bpf_lwt_seg6_store_bytes(skb, tlv_off, (void *)itlv, tlv_size);
> +       if (err)
> +               return err;
> +
> +       // the following can't be moved inside update_tlv_pad because the
> +       // bpf verifier has some issues with it
> +       pad_off += sizeof(*itlv) + itlv->len;
> +       partial_srh_len = pad_off - srh_off;
> +       len_remaining = partial_srh_len % 8;
> +       new_pad = 8 - len_remaining;
> +
> +       if (new_pad == 1) // cannot pad for 1 byte only
> +               new_pad = 9;
> +       else if (new_pad == 8)
> +               new_pad = 0;
> +
> +       return update_tlv_pad(skb, new_pad, pad_size, pad_off);
> +}
> +
> +// Add an Egress TLV fc00::4, add the flag A,
> +// and apply End.X action to fc42::1
> +SEC("lwt_seg6local")
> +int __add_egr_x(struct __sk_buff *skb)
> +{
> +       unsigned long long hi = 0xfc42000000000000;
> +       unsigned long long lo = 0x1;
> +       struct ip6_srh_t *srh = get_srh(skb);
> +       uint8_t new_flags = SR6_FLAG_ALERT;
> +       struct ip6_addr_t addr;
> +       int err, offset;
> +
> +       if (srh == NULL)
> +               return BPF_DROP;
> +
> +       uint8_t tlv[20] = {2, 18, 0, 0, 0xfd, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0,
> +                          0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x4};
> +
> +       err = add_tlv(skb, srh, (srh->hdrlen+1) << 3,
> +                     (struct sr6_tlv_t *)&tlv, 20);
> +       if (err)
> +               return BPF_DROP;
> +
> +       offset = sizeof(struct ip6_t) + offsetof(struct ip6_srh_t, flags);
> +       err = bpf_lwt_seg6_store_bytes(skb, offset,
> +                                      (void *)&new_flags, sizeof(new_flags));
> +       if (err)
> +               return BPF_DROP;
> +
> +       addr.lo = htonll(lo);
> +       addr.hi = htonll(hi);
> +       err = bpf_lwt_seg6_action(skb, SEG6_LOCAL_ACTION_END_X,
> +                                 (void *)&addr, sizeof(addr));
> +       if (err)
> +               return BPF_DROP;
> +       return BPF_REDIRECT;
> +}
> +char __license[] SEC("license") = "GPL";
> diff --git a/tools/testing/selftests/bpf/progs/test_sysctl_loop1.c b/tools/testing/selftests/bpf/progs/test_sysctl_loop1.c
> new file mode 100644
> index 000000000000..06e793c96b41
> --- /dev/null
> +++ b/tools/testing/selftests/bpf/progs/test_sysctl_loop1.c
> @@ -0,0 +1,68 @@
> +// SPDX-License-Identifier: GPL-2.0
> +// Copyright (c) 2019 Facebook
> +
> +#include <stdint.h>
> +#include <string.h>
> +
> +#include <linux/stddef.h>
> +#include <linux/bpf.h>
> +
> +#include "bpf_helpers.h"
> +#include "bpf_util.h"
> +
> +/* tcp_mem sysctl has only 3 ints, but this test is doing TCP_MEM_LOOPS */
> +#define TCP_MEM_LOOPS 28  /* because 30 doesn't fit into 512 bytes of stack */
> +#define MAX_ULONG_STR_LEN 7
> +#define MAX_VALUE_STR_LEN (TCP_MEM_LOOPS * MAX_ULONG_STR_LEN)
> +
> +static __always_inline int is_tcp_mem(struct bpf_sysctl *ctx)
> +{
> +       volatile char tcp_mem_name[] = "net/ipv4/tcp_mem/very_very_very_very_long_pointless_string";
> +       unsigned char i;
> +       char name[64];
> +       int ret;
> +
> +       memset(name, 0, sizeof(name));
> +       ret = bpf_sysctl_get_name(ctx, name, sizeof(name), 0);
> +       if (ret < 0 || ret != sizeof(tcp_mem_name) - 1)
> +               return 0;
> +
> +#pragma clang loop unroll(disable)
> +       for (i = 0; i < sizeof(tcp_mem_name); ++i)
> +               if (name[i] != tcp_mem_name[i])
> +                       return 0;
> +
> +       return 1;
> +}
> +
> +SEC("cgroup/sysctl")
> +int sysctl_tcp_mem(struct bpf_sysctl *ctx)
> +{
> +       unsigned long tcp_mem[TCP_MEM_LOOPS] = {};
> +       char value[MAX_VALUE_STR_LEN];
> +       unsigned char i, off = 0;
> +       int ret;
> +
> +       if (ctx->write)
> +               return 0;
> +
> +       if (!is_tcp_mem(ctx))
> +               return 0;
> +
> +       ret = bpf_sysctl_get_current_value(ctx, value, MAX_VALUE_STR_LEN);
> +       if (ret < 0 || ret >= MAX_VALUE_STR_LEN)
> +               return 0;
> +
> +#pragma clang loop unroll(disable)
> +       for (i = 0; i < ARRAY_SIZE(tcp_mem); ++i) {
> +               ret = bpf_strtoul(value + off, MAX_ULONG_STR_LEN, 0,
> +                                 tcp_mem + i);
> +               if (ret <= 0 || ret > MAX_ULONG_STR_LEN)
> +                       return 0;
> +               off += ret & MAX_ULONG_STR_LEN;
> +       }
> +
> +       return tcp_mem[0] < tcp_mem[1] && tcp_mem[1] < tcp_mem[2];
> +}
> +
> +char _license[] SEC("license") = "GPL";
> diff --git a/tools/testing/selftests/bpf/progs/test_sysctl_loop2.c b/tools/testing/selftests/bpf/progs/test_sysctl_loop2.c
> new file mode 100644
> index 000000000000..80690db292a5
> --- /dev/null
> +++ b/tools/testing/selftests/bpf/progs/test_sysctl_loop2.c
> @@ -0,0 +1,69 @@
> +// SPDX-License-Identifier: GPL-2.0
> +// Copyright (c) 2019 Facebook
> +
> +#include <stdint.h>
> +#include <string.h>
> +
> +#include <linux/stddef.h>
> +#include <linux/bpf.h>
> +
> +#include "bpf_helpers.h"
> +#include "bpf_util.h"
> +
> +/* tcp_mem sysctl has only 3 ints, but this test is doing TCP_MEM_LOOPS */
> +#define TCP_MEM_LOOPS 20  /* because 30 doesn't fit into 512 bytes of stack */
> +#define MAX_ULONG_STR_LEN 7
> +#define MAX_VALUE_STR_LEN (TCP_MEM_LOOPS * MAX_ULONG_STR_LEN)
> +
> +static __attribute__((noinline)) int is_tcp_mem(struct bpf_sysctl *ctx)
> +{
> +       volatile char tcp_mem_name[] = "net/ipv4/tcp_mem/very_very_very_very_long_pointless_string_to_stress_byte_loop";
> +       unsigned char i;
> +       char name[64];
> +       int ret;
> +
> +       memset(name, 0, sizeof(name));
> +       ret = bpf_sysctl_get_name(ctx, name, sizeof(name), 0);
> +       if (ret < 0 || ret != sizeof(tcp_mem_name) - 1)
> +               return 0;
> +
> +#pragma clang loop unroll(disable)
> +       for (i = 0; i < sizeof(tcp_mem_name); ++i)
> +               if (name[i] != tcp_mem_name[i])
> +                       return 0;
> +
> +       return 1;
> +}
> +
> +
> +SEC("cgroup/sysctl")
> +int sysctl_tcp_mem(struct bpf_sysctl *ctx)
> +{
> +       unsigned long tcp_mem[TCP_MEM_LOOPS] = {};
> +       char value[MAX_VALUE_STR_LEN];
> +       unsigned char i, off = 0;
> +       int ret;
> +
> +       if (ctx->write)
> +               return 0;
> +
> +       if (!is_tcp_mem(ctx))
> +               return 0;
> +
> +       ret = bpf_sysctl_get_current_value(ctx, value, MAX_VALUE_STR_LEN);
> +       if (ret < 0 || ret >= MAX_VALUE_STR_LEN)
> +               return 0;
> +
> +#pragma clang loop unroll(disable)
> +       for (i = 0; i < ARRAY_SIZE(tcp_mem); ++i) {
> +               ret = bpf_strtoul(value + off, MAX_ULONG_STR_LEN, 0,
> +                                 tcp_mem + i);
> +               if (ret <= 0 || ret > MAX_ULONG_STR_LEN)
> +                       return 0;
> +               off += ret & MAX_ULONG_STR_LEN;
> +       }
> +
> +       return tcp_mem[0] < tcp_mem[1] && tcp_mem[1] < tcp_mem[2];
> +}
> +
> +char _license[] SEC("license") = "GPL";
> diff --git a/tools/testing/selftests/bpf/progs/test_xdp_loop.c b/tools/testing/selftests/bpf/progs/test_xdp_loop.c
> new file mode 100644
> index 000000000000..7fa4677df22e
> --- /dev/null
> +++ b/tools/testing/selftests/bpf/progs/test_xdp_loop.c
> @@ -0,0 +1,231 @@
> +// SPDX-License-Identifier: GPL-2.0
> +// Copyright (c) 2019 Facebook
> +#include <stddef.h>
> +#include <string.h>
> +#include <linux/bpf.h>
> +#include <linux/if_ether.h>
> +#include <linux/if_packet.h>
> +#include <linux/ip.h>
> +#include <linux/ipv6.h>
> +#include <linux/in.h>
> +#include <linux/udp.h>
> +#include <linux/tcp.h>
> +#include <linux/pkt_cls.h>
> +#include <sys/socket.h>
> +#include "bpf_helpers.h"
> +#include "bpf_endian.h"
> +#include "test_iptunnel_common.h"
> +
> +int _version SEC("version") = 1;
> +
> +struct bpf_map_def SEC("maps") rxcnt = {
> +       .type = BPF_MAP_TYPE_PERCPU_ARRAY,
> +       .key_size = sizeof(__u32),
> +       .value_size = sizeof(__u64),
> +       .max_entries = 256,
> +};
> +
> +struct bpf_map_def SEC("maps") vip2tnl = {
> +       .type = BPF_MAP_TYPE_HASH,
> +       .key_size = sizeof(struct vip),
> +       .value_size = sizeof(struct iptnl_info),
> +       .max_entries = MAX_IPTNL_ENTRIES,
> +};
> +
> +static __always_inline void count_tx(__u32 protocol)
> +{
> +       __u64 *rxcnt_count;
> +
> +       rxcnt_count = bpf_map_lookup_elem(&rxcnt, &protocol);
> +       if (rxcnt_count)
> +               *rxcnt_count += 1;
> +}
> +
> +static __always_inline int get_dport(void *trans_data, void *data_end,
> +                                    __u8 protocol)
> +{
> +       struct tcphdr *th;
> +       struct udphdr *uh;
> +
> +       switch (protocol) {
> +       case IPPROTO_TCP:
> +               th = (struct tcphdr *)trans_data;
> +               if (th + 1 > data_end)
> +                       return -1;
> +               return th->dest;
> +       case IPPROTO_UDP:
> +               uh = (struct udphdr *)trans_data;
> +               if (uh + 1 > data_end)
> +                       return -1;
> +               return uh->dest;
> +       default:
> +               return 0;
> +       }
> +}
> +
> +static __always_inline void set_ethhdr(struct ethhdr *new_eth,
> +                                      const struct ethhdr *old_eth,
> +                                      const struct iptnl_info *tnl,
> +                                      __be16 h_proto)
> +{
> +       memcpy(new_eth->h_source, old_eth->h_dest, sizeof(new_eth->h_source));
> +       memcpy(new_eth->h_dest, tnl->dmac, sizeof(new_eth->h_dest));
> +       new_eth->h_proto = h_proto;
> +}
> +
> +static __always_inline int handle_ipv4(struct xdp_md *xdp)
> +{
> +       void *data_end = (void *)(long)xdp->data_end;
> +       void *data = (void *)(long)xdp->data;
> +       struct iptnl_info *tnl;
> +       struct ethhdr *new_eth;
> +       struct ethhdr *old_eth;
> +       struct iphdr *iph = data + sizeof(struct ethhdr);
> +       __u16 *next_iph;
> +       __u16 payload_len;
> +       struct vip vip = {};
> +       int dport;
> +       __u32 csum = 0;
> +       int i;
> +
> +       if (iph + 1 > data_end)
> +               return XDP_DROP;
> +
> +       dport = get_dport(iph + 1, data_end, iph->protocol);
> +       if (dport == -1)
> +               return XDP_DROP;
> +
> +       vip.protocol = iph->protocol;
> +       vip.family = AF_INET;
> +       vip.daddr.v4 = iph->daddr;
> +       vip.dport = dport;
> +       payload_len = bpf_ntohs(iph->tot_len);
> +
> +       tnl = bpf_map_lookup_elem(&vip2tnl, &vip);
> +       /* It only does v4-in-v4 */
> +       if (!tnl || tnl->family != AF_INET)
> +               return XDP_PASS;
> +
> +       if (bpf_xdp_adjust_head(xdp, 0 - (int)sizeof(struct iphdr)))
> +               return XDP_DROP;
> +
> +       data = (void *)(long)xdp->data;
> +       data_end = (void *)(long)xdp->data_end;
> +
> +       new_eth = data;
> +       iph = data + sizeof(*new_eth);
> +       old_eth = data + sizeof(*iph);
> +
> +       if (new_eth + 1 > data_end ||
> +           old_eth + 1 > data_end ||
> +           iph + 1 > data_end)
> +               return XDP_DROP;
> +
> +       set_ethhdr(new_eth, old_eth, tnl, bpf_htons(ETH_P_IP));
> +
> +       iph->version = 4;
> +       iph->ihl = sizeof(*iph) >> 2;
> +       iph->frag_off = 0;
> +       iph->protocol = IPPROTO_IPIP;
> +       iph->check = 0;
> +       iph->tos = 0;
> +       iph->tot_len = bpf_htons(payload_len + sizeof(*iph));
> +       iph->daddr = tnl->daddr.v4;
> +       iph->saddr = tnl->saddr.v4;
> +       iph->ttl = 8;
> +
> +       next_iph = (__u16 *)iph;
> +#pragma clang loop unroll(disable)
> +       for (i = 0; i < sizeof(*iph) >> 1; i++)
> +               csum += *next_iph++;
> +
> +       iph->check = ~((csum & 0xffff) + (csum >> 16));
> +
> +       count_tx(vip.protocol);
> +
> +       return XDP_TX;
> +}
> +
> +static __always_inline int handle_ipv6(struct xdp_md *xdp)
> +{
> +       void *data_end = (void *)(long)xdp->data_end;
> +       void *data = (void *)(long)xdp->data;
> +       struct iptnl_info *tnl;
> +       struct ethhdr *new_eth;
> +       struct ethhdr *old_eth;
> +       struct ipv6hdr *ip6h = data + sizeof(struct ethhdr);
> +       __u16 payload_len;
> +       struct vip vip = {};
> +       int dport;
> +
> +       if (ip6h + 1 > data_end)
> +               return XDP_DROP;
> +
> +       dport = get_dport(ip6h + 1, data_end, ip6h->nexthdr);
> +       if (dport == -1)
> +               return XDP_DROP;
> +
> +       vip.protocol = ip6h->nexthdr;
> +       vip.family = AF_INET6;
> +       memcpy(vip.daddr.v6, ip6h->daddr.s6_addr32, sizeof(vip.daddr));
> +       vip.dport = dport;
> +       payload_len = ip6h->payload_len;
> +
> +       tnl = bpf_map_lookup_elem(&vip2tnl, &vip);
> +       /* It only does v6-in-v6 */
> +       if (!tnl || tnl->family != AF_INET6)
> +               return XDP_PASS;
> +
> +       if (bpf_xdp_adjust_head(xdp, 0 - (int)sizeof(struct ipv6hdr)))
> +               return XDP_DROP;
> +
> +       data = (void *)(long)xdp->data;
> +       data_end = (void *)(long)xdp->data_end;
> +
> +       new_eth = data;
> +       ip6h = data + sizeof(*new_eth);
> +       old_eth = data + sizeof(*ip6h);
> +
> +       if (new_eth + 1 > data_end || old_eth + 1 > data_end ||
> +           ip6h + 1 > data_end)
> +               return XDP_DROP;
> +
> +       set_ethhdr(new_eth, old_eth, tnl, bpf_htons(ETH_P_IPV6));
> +
> +       ip6h->version = 6;
> +       ip6h->priority = 0;
> +       memset(ip6h->flow_lbl, 0, sizeof(ip6h->flow_lbl));
> +       ip6h->payload_len = bpf_htons(bpf_ntohs(payload_len) + sizeof(*ip6h));
> +       ip6h->nexthdr = IPPROTO_IPV6;
> +       ip6h->hop_limit = 8;
> +       memcpy(ip6h->saddr.s6_addr32, tnl->saddr.v6, sizeof(tnl->saddr.v6));
> +       memcpy(ip6h->daddr.s6_addr32, tnl->daddr.v6, sizeof(tnl->daddr.v6));
> +
> +       count_tx(vip.protocol);
> +
> +       return XDP_TX;
> +}
> +
> +SEC("xdp_tx_iptunnel")
> +int _xdp_tx_iptunnel(struct xdp_md *xdp)
> +{
> +       void *data_end = (void *)(long)xdp->data_end;
> +       void *data = (void *)(long)xdp->data;
> +       struct ethhdr *eth = data;
> +       __u16 h_proto;
> +
> +       if (eth + 1 > data_end)
> +               return XDP_DROP;
> +
> +       h_proto = eth->h_proto;
> +
> +       if (h_proto == bpf_htons(ETH_P_IP))
> +               return handle_ipv4(xdp);
> +       else if (h_proto == bpf_htons(ETH_P_IPV6))
> +
> +               return handle_ipv6(xdp);
> +       else
> +               return XDP_DROP;
> +}
> +
> +char _license[] SEC("license") = "GPL";
> --
> 2.20.0
>

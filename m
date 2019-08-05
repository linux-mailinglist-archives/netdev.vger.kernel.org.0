Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A8470825B9
	for <lists+netdev@lfdr.de>; Mon,  5 Aug 2019 21:45:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729383AbfHETpr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Aug 2019 15:45:47 -0400
Received: from mail-qk1-f195.google.com ([209.85.222.195]:34989 "EHLO
        mail-qk1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727460AbfHETpr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 5 Aug 2019 15:45:47 -0400
Received: by mail-qk1-f195.google.com with SMTP id r21so61131579qke.2;
        Mon, 05 Aug 2019 12:45:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=HQm67A5vaVzRpR43sxpLKTZWCkQKDkvRwErYkbLJpQc=;
        b=RLQziXNBgbYWYD4hjIUH5dyIJ2/M9AkxigqJkRNKN+8peez4FmmVXUFQhVAw1ruZMh
         cSQzOrOH+IYBLt9AVAJn5RuGGOgirVi75W5D1CVfl46spU23OruCJbwlgY2dJqBzr3lC
         zh0Cg97UhmcpzX2Xl4p7K6MQKNIlujnD5/Gm7wLLS9BxD4UR3bDfcH9GS1ZTVaU/Rqry
         LvmR87QIrwXmXMOsXmFmyMacX4+BSixsL+dw1JjV0mxbqV52JAp2vSh1c9b+rRij+No1
         a4pB49Hg82QD82/jwEtZjF/aC4Ank1vlKlLOfbHeyGiRQuyW+aFxyTLRPrINDMsPiSxg
         AzIg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=HQm67A5vaVzRpR43sxpLKTZWCkQKDkvRwErYkbLJpQc=;
        b=ZB9JvDR1PiYaJ9N4ebAku4jG+4OfaOOOPdTtaosVOYexM0mvHh00gCvQdBKPjvuCQS
         xqzG00ae6bVWx4ptbaljj8nSXqeKTVPvkFb9AmrKi4pFUvjQ1Z4CtpPboBZ88JlTwtet
         CYI6zJO+t6mPHXHJiAZXgWM52wW4MVu09ylJx2yGQLDWr5yFQRPYiZaZbtUgw5wokiy1
         JClj0c70W+Kgi6CTSqt09Ythka7I31OA4mdte8SFnKUC/V+2X0dyrZoqx9T8W4Jt9PAX
         Ny0hMi9LJXHFXjLCNuGO9qOI+s+PMT6YyEAvPYyocgmofDscerX1lynJ3Elwx9/BxUPZ
         r19A==
X-Gm-Message-State: APjAAAXvlq9waRQx4h+PKRUzLgmO6bX4nOUmxVEy3rC/tTLpbrfa/xL8
        K4cPF0vy11swEtb+VB5GSmjamBH8df7mk3MXNco=
X-Google-Smtp-Source: APXvYqxIQCcVlyLuQKn72SIDPsXS6my3yi2JEpeANTV5TMpRhq8yp0T5L35UCaL1VcoIqigEZbywTOFBnWbldChJmuo=
X-Received: by 2002:a37:660d:: with SMTP id a13mr10873qkc.36.1565034346194;
 Mon, 05 Aug 2019 12:45:46 -0700 (PDT)
MIME-Version: 1.0
References: <20190802233344.863418-1-ast@kernel.org> <20190802233344.863418-2-ast@kernel.org>
In-Reply-To: <20190802233344.863418-2-ast@kernel.org>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Mon, 5 Aug 2019 12:45:35 -0700
Message-ID: <CAEf4Bzb==_gzT78_oN7AfiGHrqGXdYK+oEamkxpfEjP5fzr_UA@mail.gmail.com>
Subject: Re: [PATCH bpf-next 1/2] selftests/bpf: add loop test 4
To:     Alexei Starovoitov <ast@kernel.org>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Kernel Team <kernel-team@fb.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Aug 3, 2019 at 8:19 PM Alexei Starovoitov <ast@kernel.org> wrote:
>
> Add a test that returns a 'random' number between [0, 2^20)
> If state pruning is not working correctly for loop body the number of
> processed insns will be 2^20 * num_of_insns_in_loop_body and the program
> will be rejected.
>
> Signed-off-by: Alexei Starovoitov <ast@kernel.org>
> ---
>  .../bpf/prog_tests/bpf_verif_scale.c          |  1 +
>  tools/testing/selftests/bpf/progs/loop4.c     | 23 +++++++++++++++++++
>  2 files changed, 24 insertions(+)
>  create mode 100644 tools/testing/selftests/bpf/progs/loop4.c
>
> diff --git a/tools/testing/selftests/bpf/prog_tests/bpf_verif_scale.c b/tools/testing/selftests/bpf/prog_tests/bpf_verif_scale.c
> index b4be96162ff4..757e39540eda 100644
> --- a/tools/testing/selftests/bpf/prog_tests/bpf_verif_scale.c
> +++ b/tools/testing/selftests/bpf/prog_tests/bpf_verif_scale.c
> @@ -71,6 +71,7 @@ void test_bpf_verif_scale(void)
>
>                 { "loop1.o", BPF_PROG_TYPE_RAW_TRACEPOINT },
>                 { "loop2.o", BPF_PROG_TYPE_RAW_TRACEPOINT },
> +               { "loop4.o", BPF_PROG_TYPE_RAW_TRACEPOINT },
>
>                 /* partial unroll. 19k insn in a loop.
>                  * Total program size 20.8k insn.
> diff --git a/tools/testing/selftests/bpf/progs/loop4.c b/tools/testing/selftests/bpf/progs/loop4.c
> new file mode 100644
> index 000000000000..3e7ee14fddbd
> --- /dev/null
> +++ b/tools/testing/selftests/bpf/progs/loop4.c
> @@ -0,0 +1,23 @@
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
> +SEC("socket")
> +int combinations(volatile struct __sk_buff* skb)
> +{
> +       int ret = 0, i;
> +
> +#pragma nounroll
> +       for (i = 0; i < 20; i++)
> +               if (skb->len)
> +                       ret |= 1 << i;

So I think the idea is that because verifier shouldn't know whether
skb->len is zero or not, then you have two outcomes on every iteration
leading to 2^20 states, right?

But I'm afraid that verifier can eventually be smart enough (if it's
not already, btw), to figure out that ret can be either 0 or ((1 <<
21) - 1), actually. If skb->len is put into separate register, then
that register's bounds will be established on first loop iteration as
either == 0 on one branch or (0, inf) on another branch, after which
all subsequent iterations will not branch at all (one or the other
branch will be always taken).

It's also possible that LLVM/Clang is smart enough already to figure
this out on its own and optimize loop into.


if (skb->len) {
    for (i = 0; i < 20; i++)
        ret |= 1 << i;
}


So two complains:

1. Let's obfuscate this a bit more, e.g., with testing (skb->len &
(1<<i)) instead, so that result really depends on actual length of the
packet.
2. Is it possible to somehow turn off this precision tracking (e.g.,
running not under root, maybe?) and see that this same program fails
in that case? That way we'll know test actually validates what we
think it validates.

Thoughts?

> +       return ret;
> +}
> --
> 2.20.0
>

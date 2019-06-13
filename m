Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0ECE344FFD
	for <lists+netdev@lfdr.de>; Fri, 14 Jun 2019 01:26:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726556AbfFMXZ6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Jun 2019 19:25:58 -0400
Received: from mail-qk1-f193.google.com ([209.85.222.193]:34212 "EHLO
        mail-qk1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725999AbfFMXZ6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 13 Jun 2019 19:25:58 -0400
Received: by mail-qk1-f193.google.com with SMTP id t8so557431qkt.1;
        Thu, 13 Jun 2019 16:25:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=JJ6fmzTD64VgkEMKi6fUhm1VzLHk4uiBqgXPbE2zUgo=;
        b=NJKRrLPRCh+EhYVtdueOr3AywZjbpqCUy4ACoUO6Tw/LPuqjc4OLgYkGjkfcmVvoQd
         QkB5erya4uEalowzy1JdJD9XCb/WQKb2RSDNLcTciNanCTYMmWeWkttU12rLiwUn1HXs
         uCWtGusFnA/ji533Yycl9CvcSBS4r/fZcj7wzxoImJTvhv0IeH2YugOJunVaT758+R9x
         AKahBUucAoHiYTGuA+TThK4wTq/SIzuANyxHeb0DTPuhtbCnG2QQFzbVZUbRIRA/vLG1
         T7616KuOvQCaJIr233sVe1Fn1CIMMfOBsIzMsWk8qlM0PcNWndI8OFg+Xy28Xs1Navnx
         suBA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=JJ6fmzTD64VgkEMKi6fUhm1VzLHk4uiBqgXPbE2zUgo=;
        b=Wz73ME4UijDj9KtjGvpghOTsQyJdS1M/0uG5zD/56iILIauCM5EAMJN+u/AgGoZ6/e
         afoIbzdKTZBsQ2HUqBJYi9a57yItK9iH19ZXZefp4T2nC7GAwTdLW5CgexFFZZvPUZPD
         qNd9JBgj6h8w6kIJX7+EDR+pJOeiJq54cc3IeRtSdqYeUk20Hz48JpLMHk/Cw22LUBjE
         MCtvCEbpW5pDtRFr0nJa9lHsGfZqVcfdpnjRL+CGLKPLs8xDyQta8nFNmZI7se06To0t
         I/Std1A4VlxhSuu/gQ+c4Cv/AOPIcTwmfQGoUYUjCHthygkpzBKQDakGBTPtHemc54hk
         oxJw==
X-Gm-Message-State: APjAAAVk/TWXkeXZn9zMAoaf7pDrP++5EUi514FuO1HRIsfHRsAmciOK
        j4yU3QxNnqvnm/zHfc8Bn7JtqHeWBKDb5GobOGbkJaF6
X-Google-Smtp-Source: APXvYqzp9j73/94J20tnb++Xa7UcIozQDofztlmUTAa1Smi15GaOKQb/hbf+N6VRbGG0XSQbXoL42MYIiKKFBqWoS2A=
X-Received: by 2002:a05:620a:14a8:: with SMTP id x8mr17898591qkj.35.1560468356562;
 Thu, 13 Jun 2019 16:25:56 -0700 (PDT)
MIME-Version: 1.0
References: <20190613042003.3791852-1-ast@kernel.org> <20190613042003.3791852-7-ast@kernel.org>
In-Reply-To: <20190613042003.3791852-7-ast@kernel.org>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Thu, 13 Jun 2019 16:25:45 -0700
Message-ID: <CAEf4Bzbd8hgxggxmwMkLjZXGbroALhkY-JZzVpKgcWnaDZXRsA@mail.gmail.com>
Subject: Re: [PATCH bpf-next 6/9] selftests/bpf: fix tests
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
> Fix tests that assumed no loops.
>
> Signed-off-by: Alexei Starovoitov <ast@kernel.org>
> ---

Acked-by: Andrii Nakryiko <andriin@fb.com>

>  tools/testing/selftests/bpf/test_verifier.c  | 11 ++++------
>  tools/testing/selftests/bpf/verifier/calls.c | 22 ++++++++++++--------
>  tools/testing/selftests/bpf/verifier/cfg.c   | 11 ++++++----
>  3 files changed, 24 insertions(+), 20 deletions(-)
>
> diff --git a/tools/testing/selftests/bpf/test_verifier.c b/tools/testing/selftests/bpf/test_verifier.c
> index cd0248c54e25..93e1d87a343a 100644
> --- a/tools/testing/selftests/bpf/test_verifier.c
> +++ b/tools/testing/selftests/bpf/test_verifier.c
> @@ -237,10 +237,10 @@ static void bpf_fill_scale1(struct bpf_test *self)
>                 insn[i++] = BPF_STX_MEM(BPF_DW, BPF_REG_1, BPF_REG_6,
>                                         -8 * (k % 64 + 1));
>         }
> -       /* every jump adds 1 step to insn_processed, so to stay exactly
> -        * within 1m limit add MAX_TEST_INSNS - MAX_JMP_SEQ - 1 MOVs and 1 EXIT
> +       /* is_state_visited() doesn't allocate state for pruning for every jump.
> +        * Hence multiply jmps by 4 to accommodate that heuristic
>          */
> -       while (i < MAX_TEST_INSNS - MAX_JMP_SEQ - 1)
> +       while (i < MAX_TEST_INSNS - MAX_JMP_SEQ * 4)
>                 insn[i++] = BPF_ALU64_IMM(BPF_MOV, BPF_REG_0, 42);
>         insn[i] = BPF_EXIT_INSN();
>         self->prog_len = i + 1;
> @@ -269,10 +269,7 @@ static void bpf_fill_scale2(struct bpf_test *self)
>                 insn[i++] = BPF_STX_MEM(BPF_DW, BPF_REG_1, BPF_REG_6,
>                                         -8 * (k % (64 - 4 * FUNC_NEST) + 1));
>         }
> -       /* every jump adds 1 step to insn_processed, so to stay exactly
> -        * within 1m limit add MAX_TEST_INSNS - MAX_JMP_SEQ - 1 MOVs and 1 EXIT
> -        */
> -       while (i < MAX_TEST_INSNS - MAX_JMP_SEQ - 1)
> +       while (i < MAX_TEST_INSNS - MAX_JMP_SEQ * 4)
>                 insn[i++] = BPF_ALU64_IMM(BPF_MOV, BPF_REG_0, 42);
>         insn[i] = BPF_EXIT_INSN();
>         self->prog_len = i + 1;
> diff --git a/tools/testing/selftests/bpf/verifier/calls.c b/tools/testing/selftests/bpf/verifier/calls.c
> index 9093a8f64dc6..2d752c4f8d9d 100644
> --- a/tools/testing/selftests/bpf/verifier/calls.c
> +++ b/tools/testing/selftests/bpf/verifier/calls.c
> @@ -215,9 +215,11 @@
>         BPF_MOV64_IMM(BPF_REG_0, 3),
>         BPF_JMP_IMM(BPF_JA, 0, 0, -6),
>         },
> -       .prog_type = BPF_PROG_TYPE_TRACEPOINT,
> -       .errstr = "back-edge from insn",
> -       .result = REJECT,
> +       .prog_type = BPF_PROG_TYPE_SOCKET_FILTER,
> +       .errstr_unpriv = "back-edge from insn",
> +       .result_unpriv = REJECT,
> +       .result = ACCEPT,
> +       .retval = 1,
>  },
>  {
>         "calls: conditional call 4",
> @@ -250,22 +252,24 @@
>         BPF_MOV64_IMM(BPF_REG_0, 3),
>         BPF_EXIT_INSN(),
>         },
> -       .prog_type = BPF_PROG_TYPE_TRACEPOINT,
> -       .errstr = "back-edge from insn",
> -       .result = REJECT,
> +       .prog_type = BPF_PROG_TYPE_SCHED_CLS,
> +       .result = ACCEPT,
> +       .retval = 1,
>  },
>  {
>         "calls: conditional call 6",
>         .insns = {
> +       BPF_MOV64_REG(BPF_REG_6, BPF_REG_1),
> +       BPF_MOV64_REG(BPF_REG_1, BPF_REG_6),
>         BPF_RAW_INSN(BPF_JMP | BPF_CALL, 0, 1, 0, 2),
> -       BPF_JMP_IMM(BPF_JEQ, BPF_REG_0, 0, -2),
> +       BPF_JMP_IMM(BPF_JEQ, BPF_REG_0, 0, -3),
>         BPF_EXIT_INSN(),
>         BPF_LDX_MEM(BPF_W, BPF_REG_0, BPF_REG_1,
>                     offsetof(struct __sk_buff, mark)),
>         BPF_EXIT_INSN(),
>         },
> -       .prog_type = BPF_PROG_TYPE_TRACEPOINT,
> -       .errstr = "back-edge from insn",
> +       .prog_type = BPF_PROG_TYPE_SCHED_CLS,
> +       .errstr = "infinite loop detected",
>         .result = REJECT,
>  },
>  {
> diff --git a/tools/testing/selftests/bpf/verifier/cfg.c b/tools/testing/selftests/bpf/verifier/cfg.c
> index 349c0862fb4c..4eb76ed739ce 100644
> --- a/tools/testing/selftests/bpf/verifier/cfg.c
> +++ b/tools/testing/selftests/bpf/verifier/cfg.c
> @@ -41,7 +41,8 @@
>         BPF_JMP_IMM(BPF_JA, 0, 0, -1),
>         BPF_EXIT_INSN(),
>         },
> -       .errstr = "back-edge",
> +       .errstr = "unreachable insn 1",
> +       .errstr_unpriv = "back-edge",
>         .result = REJECT,
>  },
>  {
> @@ -53,18 +54,20 @@
>         BPF_JMP_IMM(BPF_JA, 0, 0, -4),
>         BPF_EXIT_INSN(),
>         },
> -       .errstr = "back-edge",
> +       .errstr = "unreachable insn 4",
> +       .errstr_unpriv = "back-edge",
>         .result = REJECT,
>  },
>  {
>         "conditional loop",
>         .insns = {
> -       BPF_MOV64_REG(BPF_REG_1, BPF_REG_0),
> +       BPF_MOV64_REG(BPF_REG_0, BPF_REG_1),
>         BPF_MOV64_REG(BPF_REG_2, BPF_REG_0),
>         BPF_MOV64_REG(BPF_REG_3, BPF_REG_0),
>         BPF_JMP_IMM(BPF_JEQ, BPF_REG_1, 0, -3),
>         BPF_EXIT_INSN(),
>         },
> -       .errstr = "back-edge",
> +       .errstr = "infinite loop detected",
> +       .errstr_unpriv = "back-edge",
>         .result = REJECT,
>  },
> --
> 2.20.0
>

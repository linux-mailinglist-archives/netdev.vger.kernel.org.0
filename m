Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5A85D662F7
	for <lists+netdev@lfdr.de>; Fri, 12 Jul 2019 02:38:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728569AbfGLAiB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Jul 2019 20:38:01 -0400
Received: from mail-qt1-f193.google.com ([209.85.160.193]:34465 "EHLO
        mail-qt1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726199AbfGLAiB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 11 Jul 2019 20:38:01 -0400
Received: by mail-qt1-f193.google.com with SMTP id k10so6460948qtq.1;
        Thu, 11 Jul 2019 17:38:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=JiiqO1dfDLJMFX5mT4ARY95upHgUOuM58KSmu+2M/SY=;
        b=n7LTvSQS1fMV7dWf9+u/0C88tFTMzIQMtsGYU2EuhIKgxU6+0c6Usl0FKAFt1eRi8S
         XvdLQXjp2KkFkCAzpS5N6Fu15aYhZ53RrsYFuQCv4kra/GDLh9y66C4pyXB3xabjS/0C
         AMKN3MkAmXlU1uqcRQDoKIDjaygRo9t+vj7Pq7psUys3EfWXpVgcBdFaQKB5A2iRSgOo
         K5vG30hhe/tFnrp2/us+usWB9w9nEQTVqxof/LevAaY4eldnSs2PkF7YyXI1D+uxDKVN
         88zr5w3PY3/k7a2eT6iOGIWnTYmSm4ZkOFnRmuMiRqtXpcRMHKvyjJWaD5E4Mr46g4Oe
         tHKQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=JiiqO1dfDLJMFX5mT4ARY95upHgUOuM58KSmu+2M/SY=;
        b=HsX0jyG15PdUTvEUqmKJZ+s+Fe3Fzp2HpWEZA6rtKJBKVCMam+JAoFas0lzCu6eXGu
         kR0ifXnCWRuxHHP15po/D4jWXOHI/21NmxXMCC8SnN8vnrbUsawDB668w0aEysMnnRDs
         Ilr+C9et58F8999qIpxlAFWuq56AXsMxCs8oQW62Rh6S2OoiFCrXlg4bMqkYbCONI60Y
         phRhrpDlfSTgzSYHC0feOTTOGaXEbUgwbEcvoJe+2Iy9qZ8QwzyBByiOGE3Ub2tVYyk2
         ggu1h/r4wqXQ59dyweA1E7/8cUkA3I05ltwmbjJ8PVycRj8rLGbgGEtQ71xUWtp5Qr14
         6pKA==
X-Gm-Message-State: APjAAAWoAlnrKqDvMS7S+dWZnA6EZ3iy1y+MsOdq3mxajPJTBmTty45k
        OIR1clQ0HIi/RAgo3Ejt2x8LJ10MYxfieeaR8D4=
X-Google-Smtp-Source: APXvYqyvkoVSNCBEUI9LpZDxTY7742Me/clugQM9b/g/NyhJlnzIG18C8jCOCLEKzoyKFXrknhiwNnrhifcZcHDDH7w=
X-Received: by 2002:a0c:ae50:: with SMTP id z16mr4163447qvc.60.1562891879478;
 Thu, 11 Jul 2019 17:37:59 -0700 (PDT)
MIME-Version: 1.0
References: <20190708163121.18477-1-krzesimir@kinvolk.io> <20190708163121.18477-12-krzesimir@kinvolk.io>
In-Reply-To: <20190708163121.18477-12-krzesimir@kinvolk.io>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Thu, 11 Jul 2019 17:37:48 -0700
Message-ID: <CAEf4BzYaV=AxYZna225qKzyWPteU4YFPiBRE4cO30tYmyN_pJQ@mail.gmail.com>
Subject: Re: [bpf-next v3 11/12] selftests/bpf: Add tests for
 bpf_prog_test_run for perf events progs
To:     Krzesimir Nowak <krzesimir@kinvolk.io>
Cc:     open list <linux-kernel@vger.kernel.org>,
        Alban Crequy <alban@kinvolk.io>,
        =?UTF-8?Q?Iago_L=C3=B3pez_Galeiras?= <iago@kinvolk.io>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        Stanislav Fomichev <sdf@google.com>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        xdp-newbies@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jul 8, 2019 at 3:42 PM Krzesimir Nowak <krzesimir@kinvolk.io> wrote:
>
> The tests check if ctx and data are correctly prepared from ctx_in and
> data_in, so accessing the ctx and using the bpf_perf_prog_read_value
> work as expected.
>

These are x86_64-specific tests, aren't they? Should probably guard
them behind #ifdef's.

> Signed-off-by: Krzesimir Nowak <krzesimir@kinvolk.io>
> ---
>  tools/testing/selftests/bpf/test_verifier.c   | 48 ++++++++++
>  .../selftests/bpf/verifier/perf_event_run.c   | 96 +++++++++++++++++++
>  2 files changed, 144 insertions(+)
>  create mode 100644 tools/testing/selftests/bpf/verifier/perf_event_run.c
>
> diff --git a/tools/testing/selftests/bpf/test_verifier.c b/tools/testing/selftests/bpf/test_verifier.c
> index 6f124cc4ee34..484ea8842b06 100644
> --- a/tools/testing/selftests/bpf/test_verifier.c
> +++ b/tools/testing/selftests/bpf/test_verifier.c
> @@ -295,6 +295,54 @@ static void bpf_fill_scale(struct bpf_test *self)
>         }
>  }
>
> +static void bpf_fill_perf_event_test_run_check(struct bpf_test *self)
> +{
> +       compiletime_assert(
> +               sizeof(struct bpf_perf_event_data) <= TEST_CTX_LEN,
> +               "buffer for ctx is too short to fit struct bpf_perf_event_data");
> +       compiletime_assert(
> +               sizeof(struct bpf_perf_event_value) <= TEST_DATA_LEN,
> +               "buffer for data is too short to fit struct bpf_perf_event_value");
> +
> +       struct bpf_perf_event_data ctx = {
> +               .regs = (bpf_user_pt_regs_t) {
> +                       .r15 = 1,
> +                       .r14 = 2,
> +                       .r13 = 3,
> +                       .r12 = 4,
> +                       .rbp = 5,
> +                       .rbx = 6,
> +                       .r11 = 7,
> +                       .r10 = 8,
> +                       .r9 = 9,
> +                       .r8 = 10,
> +                       .rax = 11,
> +                       .rcx = 12,
> +                       .rdx = 13,
> +                       .rsi = 14,
> +                       .rdi = 15,
> +                       .orig_rax = 16,
> +                       .rip = 17,
> +                       .cs = 18,
> +                       .eflags = 19,
> +                       .rsp = 20,
> +                       .ss = 21,
> +               },
> +               .sample_period = 1,
> +               .addr = 2,
> +       };
> +       struct bpf_perf_event_value data = {
> +               .counter = 1,
> +               .enabled = 2,
> +               .running = 3,
> +       };
> +
> +       memcpy(self->ctx, &ctx, sizeof(ctx));
> +       memcpy(self->data, &data, sizeof(data));

Just curious, just assignment didn't work?

> +       free(self->fill_insns);
> +       self->fill_insns = NULL;
> +}
> +
>  /* BPF_SK_LOOKUP contains 13 instructions, if you need to fix up maps */
>  #define BPF_SK_LOOKUP(func)                                            \
>         /* struct bpf_sock_tuple tuple = {} */                          \
> diff --git a/tools/testing/selftests/bpf/verifier/perf_event_run.c b/tools/testing/selftests/bpf/verifier/perf_event_run.c
> new file mode 100644
> index 000000000000..3f877458a7f8
> --- /dev/null
> +++ b/tools/testing/selftests/bpf/verifier/perf_event_run.c
> @@ -0,0 +1,96 @@
> +#define PER_LOAD_AND_CHECK_PTREG(PT_REG_FIELD, VALUE)                  \
> +       PER_LOAD_AND_CHECK_CTX(offsetof(bpf_user_pt_regs_t, PT_REG_FIELD), VALUE)
> +#define PER_LOAD_AND_CHECK_EVENT(PED_FIELD, VALUE)                     \
> +       PER_LOAD_AND_CHECK_CTX(offsetof(struct bpf_perf_event_data, PED_FIELD), VALUE)
> +#define PER_LOAD_AND_CHECK_CTX(OFFSET, VALUE)                          \
> +       PER_LOAD_AND_CHECK_64(BPF_REG_4, BPF_REG_1, OFFSET, VALUE)
> +#define PER_LOAD_AND_CHECK_VALUE(PEV_FIELD, VALUE)                     \
> +       PER_LOAD_AND_CHECK_64(BPF_REG_7, BPF_REG_6, offsetof(struct bpf_perf_event_value, PEV_FIELD), VALUE)

Wrap long lines? Try also running scripts/checkpatch.pl again these
files you are modifying.

> +#define PER_LOAD_AND_CHECK_64(DST, SRC, OFFSET, VALUE)                 \
> +       BPF_LDX_MEM(BPF_DW, DST, SRC, OFFSET),                          \
> +       BPF_JMP_IMM(BPF_JEQ, DST, VALUE, 2),                            \
> +       BPF_MOV64_IMM(BPF_REG_0, VALUE),                                \
> +       BPF_EXIT_INSN()
> +
> +{
> +       "check if regs contain expected values",
> +       .insns = {
> +       PER_LOAD_AND_CHECK_PTREG(r15, 1),
> +       PER_LOAD_AND_CHECK_PTREG(r14, 2),
> +       PER_LOAD_AND_CHECK_PTREG(r13, 3),
> +       PER_LOAD_AND_CHECK_PTREG(r12, 4),
> +       PER_LOAD_AND_CHECK_PTREG(rbp, 5),
> +       PER_LOAD_AND_CHECK_PTREG(rbx, 6),
> +       PER_LOAD_AND_CHECK_PTREG(r11, 7),
> +       PER_LOAD_AND_CHECK_PTREG(r10, 8),
> +       PER_LOAD_AND_CHECK_PTREG(r9, 9),
> +       PER_LOAD_AND_CHECK_PTREG(r8, 10),
> +       PER_LOAD_AND_CHECK_PTREG(rax, 11),
> +       PER_LOAD_AND_CHECK_PTREG(rcx, 12),
> +       PER_LOAD_AND_CHECK_PTREG(rdx, 13),
> +       PER_LOAD_AND_CHECK_PTREG(rsi, 14),
> +       PER_LOAD_AND_CHECK_PTREG(rdi, 15),
> +       PER_LOAD_AND_CHECK_PTREG(orig_rax, 16),
> +       PER_LOAD_AND_CHECK_PTREG(rip, 17),
> +       PER_LOAD_AND_CHECK_PTREG(cs, 18),
> +       PER_LOAD_AND_CHECK_PTREG(eflags, 19),
> +       PER_LOAD_AND_CHECK_PTREG(rsp, 20),
> +       PER_LOAD_AND_CHECK_PTREG(ss, 21),
> +       BPF_MOV64_IMM(BPF_REG_0, 0),
> +       BPF_EXIT_INSN(),
> +       },
> +       .result = ACCEPT,
> +       .prog_type = BPF_PROG_TYPE_PERF_EVENT,
> +       .ctx_len = sizeof(struct bpf_perf_event_data),
> +       .data_len = sizeof(struct bpf_perf_event_value),
> +       .fill_helper = bpf_fill_perf_event_test_run_check,
> +       .override_data_out_len = true,
> +},
> +{
> +       "check if sample period and addr contain expected values",
> +       .insns = {
> +       PER_LOAD_AND_CHECK_EVENT(sample_period, 1),
> +       PER_LOAD_AND_CHECK_EVENT(addr, 2),
> +       BPF_MOV64_IMM(BPF_REG_0, 0),
> +       BPF_EXIT_INSN(),
> +       },
> +       .result = ACCEPT,
> +       .prog_type = BPF_PROG_TYPE_PERF_EVENT,
> +       .ctx_len = sizeof(struct bpf_perf_event_data),
> +       .data_len = sizeof(struct bpf_perf_event_value),
> +       .fill_helper = bpf_fill_perf_event_test_run_check,
> +       .override_data_out_len = true,
> +},
> +{
> +       "check if bpf_perf_prog_read_value returns expected data",
> +       .insns = {
> +       // allocate space for a struct bpf_perf_event_value
> +       BPF_MOV64_REG(BPF_REG_6, BPF_REG_10),
> +       BPF_ALU64_IMM(BPF_ADD, BPF_REG_6, -(int)sizeof(struct bpf_perf_event_value)),
> +       // prepare parameters for bpf_perf_prog_read_value(ctx, struct bpf_perf_event_value*, u32)
> +       // BPF_REG_1 already contains the context
> +       BPF_MOV64_REG(BPF_REG_2, BPF_REG_6),
> +       BPF_MOV64_IMM(BPF_REG_3, sizeof(struct bpf_perf_event_value)),
> +       BPF_EMIT_CALL(BPF_FUNC_perf_prog_read_value),
> +       // check the return value
> +       BPF_JMP_IMM(BPF_JEQ, BPF_REG_0, 0, 1),
> +       BPF_EXIT_INSN(),
> +       // check if the fields match the expected values

Use /* */ comments.

> +       PER_LOAD_AND_CHECK_VALUE(counter, 1),
> +       PER_LOAD_AND_CHECK_VALUE(enabled, 2),
> +       PER_LOAD_AND_CHECK_VALUE(running, 3),
> +       BPF_MOV64_IMM(BPF_REG_0, 0),
> +       BPF_EXIT_INSN(),
> +       },
> +       .result = ACCEPT,
> +       .prog_type = BPF_PROG_TYPE_PERF_EVENT,
> +       .ctx_len = sizeof(struct bpf_perf_event_data),
> +       .data_len = sizeof(struct bpf_perf_event_value),
> +       .fill_helper = bpf_fill_perf_event_test_run_check,
> +       .override_data_out_len = true,
> +},
> +#undef PER_LOAD_AND_CHECK_64
> +#undef PER_LOAD_AND_CHECK_VALUE
> +#undef PER_LOAD_AND_CHECK_CTX
> +#undef PER_LOAD_AND_CHECK_EVENT
> +#undef PER_LOAD_AND_CHECK_PTREG
> --
> 2.20.1
>

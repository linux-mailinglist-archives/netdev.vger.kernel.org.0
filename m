Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4E2459C8A7
	for <lists+netdev@lfdr.de>; Mon, 26 Aug 2019 07:22:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729241AbfHZFWZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Aug 2019 01:22:25 -0400
Received: from mail-qt1-f194.google.com ([209.85.160.194]:34129 "EHLO
        mail-qt1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725446AbfHZFWZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 26 Aug 2019 01:22:25 -0400
Received: by mail-qt1-f194.google.com with SMTP id q4so16813290qtp.1;
        Sun, 25 Aug 2019 22:22:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=fvyHXhtKgDGAvzWeeBS1NBq87CXpvIV5mOgdpuLqsYs=;
        b=irrNQO+Au3orUPrC1XRrDyVOKjGVko3+kNwRRFJXEyU3xYJHiEbyGwvWb9lcrug+fZ
         a2B8uZ46LvmXDjft8vj8Ntsdux/psnfaoBf7flfj8t9wFHvRXOz39zEeWf/Ln5+5t8hj
         WweBww3NH/pX12MBisKrtSDMYHTFvoRN1YTJdH7Yb0vDvjrjpbzr+I7wVwu1WIGBubT8
         qBBtvcrtg9xJt4THnToEMK/Ll2f6sNCTbyhES+oMO3mLMNj3mz6HuL/H78MZEmuNiFlc
         hHZlAkC5zWNVcNHsZHmtbbS/C9S0lzYRkB9Ww02izajArBzUDWesAg0ADwsvimN5ORan
         kCRg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=fvyHXhtKgDGAvzWeeBS1NBq87CXpvIV5mOgdpuLqsYs=;
        b=TtJQzWvOtCRN8PzbTUDJbttPtg7lzbHNnqcisKc3HqRa6IT1oPSpl4Rl3Ap6cwYqNp
         wDvlxXcKv0oFbqj4GfLygfGy1YdulHw3WCEyWG6K2nnx4bSjtMoQBTzNnudu9efLM4uA
         tcktVefAA9gxukiTWgyzytVU6/5vDZMAmU7o82p196gtz5JHZI/P0qJSOyFeYkCUo+vf
         EnklX85oYZLhjTGAfyccJnx49hTQ1P4cSKyLpTcqrs1DXf+CCcn1y1+Hd4IbQ2L2DQxP
         lAfEUe7iuvItYGPW2OEdRhHZjXDUdcDiM2u6lII6uOHIo6l5xxrC+V21NN/93RBmw7jD
         7+6g==
X-Gm-Message-State: APjAAAVKGs96IPcCxD1aaGJfeG0cNSDquapBAQcrol+d//nBe2egvVi1
        9f9fY2XIgcSomkP0nvs1/qPEK/Yu/mNFkUqH3BQ=
X-Google-Smtp-Source: APXvYqzkZOzgoGSmcX8Vc7TooXrbQUaA7DGSfEGN7ujfwYCQrjSVl1xyKzVk0pv1ouN87WI8Rnhl50a+1r2iyi05HhA=
X-Received: by 2002:ac8:3258:: with SMTP id y24mr15749380qta.183.1566796944139;
 Sun, 25 Aug 2019 22:22:24 -0700 (PDT)
MIME-Version: 1.0
References: <20190823055215.2658669-1-ast@kernel.org> <20190823055215.2658669-4-ast@kernel.org>
In-Reply-To: <20190823055215.2658669-4-ast@kernel.org>
From:   Song Liu <liu.song.a23@gmail.com>
Date:   Sun, 25 Aug 2019 22:22:13 -0700
Message-ID: <CAPhsuW54=MiBfLp+AL2ASqaoGOf+p9D_VXxBYcR5fFpBrdEGSg@mail.gmail.com>
Subject: Re: [PATCH bpf-next 3/4] selftests/bpf: verifier precise tests
To:     Alexei Starovoitov <ast@kernel.org>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Kernel Team <kernel-team@fb.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Aug 23, 2019 at 2:59 AM Alexei Starovoitov <ast@kernel.org> wrote:
>
> Use BPF_F_TEST_STATE_FREQ flag to check that precision
> tracking works as expected by comparing every step it takes.
>
> Signed-off-by: Alexei Starovoitov <ast@kernel.org>
> ---
>  tools/testing/selftests/bpf/test_verifier.c   |  68 ++++++++--
>  .../testing/selftests/bpf/verifier/precise.c  | 117 ++++++++++++++++++
>  2 files changed, 174 insertions(+), 11 deletions(-)
>  create mode 100644 tools/testing/selftests/bpf/verifier/precise.c
>
> diff --git a/tools/testing/selftests/bpf/test_verifier.c b/tools/testing/selftests/bpf/test_verifier.c
> index 44e2d640b088..d27fd929abb9 100644
> --- a/tools/testing/selftests/bpf/test_verifier.c
> +++ b/tools/testing/selftests/bpf/test_verifier.c
> @@ -61,6 +61,7 @@
>  #define UNPRIV_SYSCTL "kernel/unprivileged_bpf_disabled"
>  static bool unpriv_disabled = false;
>  static int skips;
> +static bool verbose = false;
>
>  struct bpf_test {
>         const char *descr;
> @@ -92,7 +93,8 @@ struct bpf_test {
>         enum {
>                 UNDEF,
>                 ACCEPT,
> -               REJECT
> +               REJECT,
> +               VERBOSE_ACCEPT,
>         } result, result_unpriv;
>         enum bpf_prog_type prog_type;
>         uint8_t flags;
> @@ -859,6 +861,36 @@ static int do_prog_test_run(int fd_prog, bool unpriv, uint32_t expected_val,
>         return 0;
>  }
>
> +static bool cmp_str_seq(const char *log, const char *exp)

Maybe call it str_str_seq()?

> +{
> +       char needle[80];
> +       const char *p, *q;
> +       int len;
> +
> +       do {
> +               p = strchr(exp, '\t');
> +               if (!p)
> +                       p = exp + strlen(exp);
> +
> +               len = p - exp;
> +               if (len >= sizeof(needle) || !len) {
> +                       printf("FAIL\nTestcase bug\n");
> +                       return false;
> +               }
> +               strncpy(needle, exp, len);
> +               needle[len] = 0;
> +               q = strstr(log, needle);
> +               if (!q) {
> +                       printf("FAIL\nUnexpected verifier log in successful load!\n"
> +                              "EXP: %s\nRES:\n", needle);
> +                       return false;
> +               }
> +               log = q + len;
> +               exp = p + 1;
> +       } while (*p);
> +       return true;
> +}
> +
>  static void do_test_single(struct bpf_test *test, bool unpriv,
>                            int *passes, int *errors)
>  {
> @@ -897,14 +929,20 @@ static void do_test_single(struct bpf_test *test, bool unpriv,
>                 pflags |= BPF_F_STRICT_ALIGNMENT;
>         if (test->flags & F_NEEDS_EFFICIENT_UNALIGNED_ACCESS)
>                 pflags |= BPF_F_ANY_ALIGNMENT;
> +       if (test->flags & ~3)
> +               pflags |= test->flags;
^^^^^^ why do we need these two lines?

>
> +       expected_ret = unpriv && test->result_unpriv != UNDEF ?
> +                      test->result_unpriv : test->result;
> +       expected_err = unpriv && test->errstr_unpriv ?
> +                      test->errstr_unpriv : test->errstr;
>         memset(&attr, 0, sizeof(attr));
>         attr.prog_type = prog_type;
>         attr.expected_attach_type = test->expected_attach_type;
>         attr.insns = prog;
>         attr.insns_cnt = prog_len;
>         attr.license = "GPL";
> -       attr.log_level = 4;
> +       attr.log_level = verbose || expected_ret == VERBOSE_ACCEPT ? 1 : 4;
>         attr.prog_flags = pflags;
>
>         fd_prog = bpf_load_program_xattr(&attr, bpf_vlog, sizeof(bpf_vlog));
> @@ -914,14 +952,9 @@ static void do_test_single(struct bpf_test *test, bool unpriv,
>                 goto close_fds;
>         }
>
> -       expected_ret = unpriv && test->result_unpriv != UNDEF ?
> -                      test->result_unpriv : test->result;
> -       expected_err = unpriv && test->errstr_unpriv ?
> -                      test->errstr_unpriv : test->errstr;
> -
>         alignment_prevented_execution = 0;
>
> -       if (expected_ret == ACCEPT) {
> +       if (expected_ret == ACCEPT || expected_ret == VERBOSE_ACCEPT) {
>                 if (fd_prog < 0) {
>                         printf("FAIL\nFailed to load prog '%s'!\n",
>                                strerror(errno));
> @@ -932,6 +965,9 @@ static void do_test_single(struct bpf_test *test, bool unpriv,
>                     (test->flags & F_NEEDS_EFFICIENT_UNALIGNED_ACCESS))
>                         alignment_prevented_execution = 1;
>  #endif
> +               if (expected_ret == VERBOSE_ACCEPT && !cmp_str_seq(bpf_vlog, expected_err)) {
> +                       goto fail_log;
> +               }
>         } else {
>                 if (fd_prog >= 0) {
>                         printf("FAIL\nUnexpected success to load!\n");
> @@ -957,6 +993,9 @@ static void do_test_single(struct bpf_test *test, bool unpriv,
>                 }
>         }
>
> +       if (verbose)
> +               printf(", verifier log:\n%s", bpf_vlog);
> +
>         run_errs = 0;
>         run_successes = 0;
>         if (!alignment_prevented_execution && fd_prog >= 0) {
> @@ -1097,17 +1136,24 @@ int main(int argc, char **argv)
>  {
>         unsigned int from = 0, to = ARRAY_SIZE(tests);
>         bool unpriv = !is_admin();
> +       int arg = 1;
> +
> +       if (argc > 1 && strcmp(argv[1], "-v") == 0) {
> +               arg++;
> +               verbose = true;
> +               argc--;
> +       }
>
>         if (argc == 3) {
> -               unsigned int l = atoi(argv[argc - 2]);
> -               unsigned int u = atoi(argv[argc - 1]);
> +               unsigned int l = atoi(argv[arg]);
> +               unsigned int u = atoi(argv[arg + 1]);
>
>                 if (l < to && u < to) {
>                         from = l;
>                         to   = u + 1;
>                 }
>         } else if (argc == 2) {
> -               unsigned int t = atoi(argv[argc - 1]);
> +               unsigned int t = atoi(argv[arg]);
>
>                 if (t < to) {
>                         from = t;
> diff --git a/tools/testing/selftests/bpf/verifier/precise.c b/tools/testing/selftests/bpf/verifier/precise.c
> new file mode 100644
> index 000000000000..a20953c23721
> --- /dev/null
> +++ b/tools/testing/selftests/bpf/verifier/precise.c
> @@ -0,0 +1,117 @@
> +{
> +       "precise: test 1",
> +       .insns = {
> +       BPF_MOV64_IMM(BPF_REG_0, 1),
> +       BPF_LD_MAP_FD(BPF_REG_6, 0),
> +       BPF_MOV64_REG(BPF_REG_1, BPF_REG_6),
> +       BPF_MOV64_REG(BPF_REG_2, BPF_REG_FP),
> +       BPF_ALU64_IMM(BPF_ADD, BPF_REG_2, -8),
> +       BPF_ST_MEM(BPF_DW, BPF_REG_FP, -8, 0),
> +       BPF_EMIT_CALL(BPF_FUNC_map_lookup_elem),
> +       BPF_JMP_IMM(BPF_JNE, BPF_REG_0, 0, 1),
> +       BPF_EXIT_INSN(),
> +
> +       BPF_MOV64_REG(BPF_REG_9, BPF_REG_0),
> +
> +       BPF_MOV64_REG(BPF_REG_1, BPF_REG_6),
> +       BPF_MOV64_REG(BPF_REG_2, BPF_REG_FP),
> +       BPF_ALU64_IMM(BPF_ADD, BPF_REG_2, -8),
> +       BPF_EMIT_CALL(BPF_FUNC_map_lookup_elem),
> +       BPF_JMP_IMM(BPF_JNE, BPF_REG_0, 0, 1),
> +       BPF_EXIT_INSN(),
> +
> +       BPF_MOV64_REG(BPF_REG_8, BPF_REG_0),
> +
> +       BPF_ALU64_REG(BPF_SUB, BPF_REG_9, BPF_REG_8), /* map_value_ptr -= map_value_ptr */
> +       BPF_MOV64_REG(BPF_REG_2, BPF_REG_9),
> +       BPF_JMP_IMM(BPF_JLT, BPF_REG_2, 8, 1),
> +       BPF_EXIT_INSN(),
> +
> +       BPF_ALU64_IMM(BPF_ADD, BPF_REG_2, 1), /* R2=inv(umin=1, umax=8) */
> +       BPF_MOV64_REG(BPF_REG_1, BPF_REG_FP),
> +       BPF_ALU64_IMM(BPF_ADD, BPF_REG_1, -8),
> +       BPF_MOV64_IMM(BPF_REG_3, 0),
> +       BPF_EMIT_CALL(BPF_FUNC_probe_read),
> +       BPF_EXIT_INSN(),
> +       },
> +       .prog_type = BPF_PROG_TYPE_TRACEPOINT,
> +       .fixup_map_array_48b = { 1 },
> +       .result = VERBOSE_ACCEPT,
> +       .errstr =
> +       "26: (85) call bpf_probe_read#4\
> +       last_idx 26 first_idx 20\
> +       regs=4 stack=0 before 25\
> +       regs=4 stack=0 before 24\
> +       regs=4 stack=0 before 23\
> +       regs=4 stack=0 before 22\
> +       regs=4 stack=0 before 20\
> +       parent didn't have regs=4 stack=0 marks\
> +       last_idx 19 first_idx 10\
> +       regs=4 stack=0 before 19\
> +       regs=200 stack=0 before 18\
> +       regs=300 stack=0 before 17\
> +       regs=201 stack=0 before 15\
> +       regs=201 stack=0 before 14\
> +       regs=200 stack=0 before 13\
> +       regs=200 stack=0 before 12\
> +       regs=200 stack=0 before 11\
> +       regs=200 stack=0 before 10\
> +       parent already had regs=0 stack=0 marks",
> +},
> +{
> +       "precise: test 2",
> +       .insns = {
> +       BPF_MOV64_IMM(BPF_REG_0, 1),
> +       BPF_LD_MAP_FD(BPF_REG_6, 0),
> +       BPF_MOV64_REG(BPF_REG_1, BPF_REG_6),
> +       BPF_MOV64_REG(BPF_REG_2, BPF_REG_FP),
> +       BPF_ALU64_IMM(BPF_ADD, BPF_REG_2, -8),
> +       BPF_ST_MEM(BPF_DW, BPF_REG_FP, -8, 0),
> +       BPF_EMIT_CALL(BPF_FUNC_map_lookup_elem),
> +       BPF_JMP_IMM(BPF_JNE, BPF_REG_0, 0, 1),
> +       BPF_EXIT_INSN(),
> +
> +       BPF_MOV64_REG(BPF_REG_9, BPF_REG_0),
> +
> +       BPF_MOV64_REG(BPF_REG_1, BPF_REG_6),
> +       BPF_MOV64_REG(BPF_REG_2, BPF_REG_FP),
> +       BPF_ALU64_IMM(BPF_ADD, BPF_REG_2, -8),
> +       BPF_EMIT_CALL(BPF_FUNC_map_lookup_elem),
> +       BPF_JMP_IMM(BPF_JNE, BPF_REG_0, 0, 1),
> +       BPF_EXIT_INSN(),
> +
> +       BPF_MOV64_REG(BPF_REG_8, BPF_REG_0),
> +
> +       BPF_ALU64_REG(BPF_SUB, BPF_REG_9, BPF_REG_8), /* map_value_ptr -= map_value_ptr */
> +       BPF_MOV64_REG(BPF_REG_2, BPF_REG_9),
> +       BPF_JMP_IMM(BPF_JLT, BPF_REG_2, 8, 1),
> +       BPF_EXIT_INSN(),
> +
> +       BPF_ALU64_IMM(BPF_ADD, BPF_REG_2, 1), /* R2=inv(umin=1, umax=8) */
> +       BPF_MOV64_REG(BPF_REG_1, BPF_REG_FP),
> +       BPF_ALU64_IMM(BPF_ADD, BPF_REG_1, -8),
> +       BPF_MOV64_IMM(BPF_REG_3, 0),
> +       BPF_EMIT_CALL(BPF_FUNC_probe_read),
> +       BPF_EXIT_INSN(),
> +       },
> +       .prog_type = BPF_PROG_TYPE_TRACEPOINT,
> +       .fixup_map_array_48b = { 1 },
> +       .result = VERBOSE_ACCEPT,
> +       .flags = BPF_F_TEST_STATE_FREQ,
> +       .errstr =
> +       "26: (85) call bpf_probe_read#4\
> +       last_idx 26 first_idx 22\
> +       regs=4 stack=0 before 25\
> +       regs=4 stack=0 before 24\
> +       regs=4 stack=0 before 23\
> +       regs=4 stack=0 before 22\
> +       parent didn't have regs=4 stack=0 marks\
> +       last_idx 20 first_idx 20\
> +       regs=4 stack=0 before 20\
> +       parent didn't have regs=4 stack=0 marks\
> +       last_idx 19 first_idx 17\
> +       regs=4 stack=0 before 19\
> +       regs=200 stack=0 before 18\
> +       regs=300 stack=0 before 17\
> +       parent already had regs=0 stack=0 marks",
> +},
> --
> 2.20.0
>

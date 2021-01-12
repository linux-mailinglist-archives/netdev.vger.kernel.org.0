Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 401B52F3366
	for <lists+netdev@lfdr.de>; Tue, 12 Jan 2021 15:59:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389165AbhALO4y (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Jan 2021 09:56:54 -0500
Received: from mail.kernel.org ([198.145.29.99]:60478 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388981AbhALO4x (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 12 Jan 2021 09:56:53 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 586942313B
        for <netdev@vger.kernel.org>; Tue, 12 Jan 2021 14:56:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1610463372;
        bh=qme/Mg8GwGx197LNmKM/I8ea4z8PwVO+XEsx8eGoIzA=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=alNY+VjmDFGHqReI69N1lfH/vDZnLe+IUsBT8m2MV7/oMWmQ6bbNRmcQBMN+pElTM
         JMN1n9ig/mu5H8/tb+3D/aRSSU11TuoSRwagwF7EtpXKFEIR2tyq6MFu82vwhB3fkg
         cleDumE5IBrXgpXs7Ypf2L2kVEZpd9eWF0TlzcALpPeK/DAB30u3Qr6y87GGyKEMpT
         G4qzNgdsM1C+M20Y0OSDliJVklIy7+DKQJanJw7KGYt48F+EU3hiuvcJlaaKmGiSIU
         SDgVRk4YydGqrqx/9RYGuJmmVmdCnBVENJmNrHxmjIg0X6+vktU3NbjaxMVBAmWx6+
         XMWAHRW9fpSPw==
Received: by mail-lf1-f44.google.com with SMTP id o13so3812571lfr.3
        for <netdev@vger.kernel.org>; Tue, 12 Jan 2021 06:56:12 -0800 (PST)
X-Gm-Message-State: AOAM531BlX7RD34I1ltoajc4H6RthJmtIE6zvBw8OIwIg+puuH+5n63w
        5LvhFpW+z83cmk97SLIiOyxFOiwC8X31Hr1R30CDFQ==
X-Google-Smtp-Source: ABdhPJxJB67nGjoVEE0nPESefr34kA2uyVpLEIopKGpL9JurD2jiOnMs8cjpg/eh/Cx5cFsSygdjU/lPZ5ghdhhRPRI=
X-Received: by 2002:a19:810:: with SMTP id 16mr2418512lfi.233.1610463370437;
 Tue, 12 Jan 2021 06:56:10 -0800 (PST)
MIME-Version: 1.0
References: <20210112091545.10535-1-gilad.reti@gmail.com>
In-Reply-To: <20210112091545.10535-1-gilad.reti@gmail.com>
From:   KP Singh <kpsingh@kernel.org>
Date:   Tue, 12 Jan 2021 15:55:59 +0100
X-Gmail-Original-Message-ID: <CACYkzJ69serkHRymzDEAcQ-_KAdHA+RxP4qpAwzGmppWUxYeQQ@mail.gmail.com>
Message-ID: <CACYkzJ69serkHRymzDEAcQ-_KAdHA+RxP4qpAwzGmppWUxYeQQ@mail.gmail.com>
Subject: Re: [PATCH 2/2] selftests/bpf: add verifier test for PTR_TO_MEM spill
To:     Gilad Reti <gilad.reti@gmail.com>
Cc:     bpf <bpf@vger.kernel.org>, Shuah Khan <shuah@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        linux-kselftest@vger.kernel.org,
        Networking <netdev@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jan 12, 2021 at 10:16 AM Gilad Reti <gilad.reti@gmail.com> wrote:
>
> Add test to check that the verifier is able to recognize spilling of
> PTR_TO_MEM registers.
>

It would be nice to have some explanation of what the test does to
recognize the spilling of the PTR_TO_MEM registers in the commit
log as well.

Would it be possible to augment an existing test_progs
program like tools/testing/selftests/bpf/progs/test_ringbuf.c to test
this functionality?



> The patch was partially contibuted by CyberArk Software, Inc.
>
> Signed-off-by: Gilad Reti <gilad.reti@gmail.com>
> ---
>  tools/testing/selftests/bpf/test_verifier.c   | 12 +++++++-
>  .../selftests/bpf/verifier/spill_fill.c       | 30 +++++++++++++++++++
>  2 files changed, 41 insertions(+), 1 deletion(-)
>
> diff --git a/tools/testing/selftests/bpf/test_verifier.c b/tools/testing/selftests/bpf/test_verifier.c
> index 777a81404fdb..f8569f04064b 100644
> --- a/tools/testing/selftests/bpf/test_verifier.c
> +++ b/tools/testing/selftests/bpf/test_verifier.c
> @@ -50,7 +50,7 @@
>  #define MAX_INSNS      BPF_MAXINSNS
>  #define MAX_TEST_INSNS 1000000
>  #define MAX_FIXUPS     8
> -#define MAX_NR_MAPS    20
> +#define MAX_NR_MAPS    21
>  #define MAX_TEST_RUNS  8
>  #define POINTER_VALUE  0xcafe4all
>  #define TEST_DATA_LEN  64
> @@ -87,6 +87,7 @@ struct bpf_test {
>         int fixup_sk_storage_map[MAX_FIXUPS];
>         int fixup_map_event_output[MAX_FIXUPS];
>         int fixup_map_reuseport_array[MAX_FIXUPS];
> +       int fixup_map_ringbuf[MAX_FIXUPS];
>         const char *errstr;
>         const char *errstr_unpriv;
>         uint32_t insn_processed;
> @@ -640,6 +641,7 @@ static void do_test_fixup(struct bpf_test *test, enum bpf_prog_type prog_type,
>         int *fixup_sk_storage_map = test->fixup_sk_storage_map;
>         int *fixup_map_event_output = test->fixup_map_event_output;
>         int *fixup_map_reuseport_array = test->fixup_map_reuseport_array;
> +       int *fixup_map_ringbuf = test->fixup_map_ringbuf;
>
>         if (test->fill_helper) {
>                 test->fill_insns = calloc(MAX_TEST_INSNS, sizeof(struct bpf_insn));
> @@ -817,6 +819,14 @@ static void do_test_fixup(struct bpf_test *test, enum bpf_prog_type prog_type,
>                         fixup_map_reuseport_array++;
>                 } while (*fixup_map_reuseport_array);
>         }
> +       if (*fixup_map_ringbuf) {
> +               map_fds[20] = create_map(BPF_MAP_TYPE_RINGBUF, 0,
> +                                          0, 4096);
> +               do {
> +                       prog[*fixup_map_ringbuf].imm = map_fds[20];
> +                       fixup_map_ringbuf++;
> +               } while (*fixup_map_ringbuf);
> +       }
>  }
>
>  struct libcap {
> diff --git a/tools/testing/selftests/bpf/verifier/spill_fill.c b/tools/testing/selftests/bpf/verifier/spill_fill.c
> index 45d43bf82f26..1833b6c730dd 100644
> --- a/tools/testing/selftests/bpf/verifier/spill_fill.c
> +++ b/tools/testing/selftests/bpf/verifier/spill_fill.c
> @@ -28,6 +28,36 @@
>         .result = ACCEPT,
>         .result_unpriv = ACCEPT,
>  },
> +{
> +       "check valid spill/fill, ptr to mem",
> +       .insns = {
> +       /* reserve 8 byte ringbuf memory */
> +       BPF_ST_MEM(BPF_DW, BPF_REG_10, -8, 0),
> +       BPF_LD_MAP_FD(BPF_REG_1, 0),
> +       BPF_MOV64_IMM(BPF_REG_2, 8),
> +       BPF_MOV64_IMM(BPF_REG_3, 0),
> +       BPF_RAW_INSN(BPF_JMP | BPF_CALL, 0, 0, 0, BPF_FUNC_ringbuf_reserve),
> +       /* store a pointer to the reserved memory in R6 */
> +       BPF_MOV64_REG(BPF_REG_6, BPF_REG_0),
> +       /* check whether the reservation was successful */
> +       BPF_JMP_IMM(BPF_JEQ, BPF_REG_0, 0, 6),
> +       /* spill R6(mem) into the stack */
> +       BPF_STX_MEM(BPF_DW, BPF_REG_10, BPF_REG_6, -8),
> +       /* fill it back in R7 */
> +       BPF_LDX_MEM(BPF_DW, BPF_REG_7, BPF_REG_10, -8),
> +       /* should be able to access *(R7) = 0 */
> +       BPF_ST_MEM(BPF_DW, BPF_REG_7, 0, 0),
> +       /* submit the reserved rungbuf memory */
> +       BPF_MOV64_REG(BPF_REG_1, BPF_REG_7),
> +       BPF_MOV64_IMM(BPF_REG_2, 0),
> +       BPF_RAW_INSN(BPF_JMP | BPF_CALL, 0, 0, 0, BPF_FUNC_ringbuf_submit),
> +       BPF_MOV64_IMM(BPF_REG_0, 0),
> +       BPF_EXIT_INSN(),
> +       },
> +       .fixup_map_ringbuf = { 1 },
> +       .result = ACCEPT,
> +       .result_unpriv = ACCEPT,
> +},
>  {
>         "check corrupted spill/fill",
>         .insns = {
> --
> 2.27.0
>

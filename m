Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 06FE948929
	for <lists+netdev@lfdr.de>; Mon, 17 Jun 2019 18:40:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728307AbfFQQkE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Jun 2019 12:40:04 -0400
Received: from mail-qt1-f193.google.com ([209.85.160.193]:34742 "EHLO
        mail-qt1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726091AbfFQQkD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Jun 2019 12:40:03 -0400
Received: by mail-qt1-f193.google.com with SMTP id m29so11518982qtu.1;
        Mon, 17 Jun 2019 09:40:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=RtKQD5KCL3Sdi76sMeUICHmGljmolJuDbOd9hJJpAIQ=;
        b=W9Z6EePXV/FyVDN0Q1qHK1X2jA0Pz4Fpj30Hu2UhLE1akGze3sAccuef9ea+rltawd
         ayu0saigMgUovp2Xvx7KWk26R57NoHbYVgoaVQ4m7GEbWoBSagzq8e1E8lg1Ggl/i6Vw
         913KktPJFel1l1hBf/byuHB8Qc3qjQdBjYOJnH9pmxw5HnC2Mwh8YTlOxi+MKIYeVkhI
         h+KxwXcFl70O+FunH8Ds7Q6VGPtYwPerMNcc3Ep/b/+ppw3/zrcN5XvH8W1R9Z0Asl5R
         CXuQaJFM9M9+MOrp4rko5WjqLxDFUoaLGaYZAes5Jg8ILWssoehQ1O8emyKrPLSMAmjR
         2wUg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=RtKQD5KCL3Sdi76sMeUICHmGljmolJuDbOd9hJJpAIQ=;
        b=cbV/SesTurUSXu15HLcwfadOkFNs1hZ2Ecqm86xnu8ZECPmmjnjEOFDMhonpi8xamY
         +GDxbAWQo3vGawKUsxn06AQGR24L85ENvT1USk0rtZ9Um48HjqdKKVMp56DuVjLn4RCv
         H6hp57NaqS3H0i9bAeqXfYNDZfn1ubafPqqUUII4m11IjmfUr5sq19/KrUFC0U26dZnO
         4HEWISD8JdJ2XR+K+TZGAe31dyz9JiPk9kcKxRM3MZbR5MyYNqa4M9dHep7yIrMSsb4Y
         h/CS3LlW4vW7XZjKy3zOgYXRc9hgz8DKrw4FlHS/ESc8lQ8HcozcVWArz4xHkHxSJTEz
         EWIQ==
X-Gm-Message-State: APjAAAXLFpMITQNspRGV1PLNtCm0Mc5JZWIQTxMcD5iVA0ki3Q1nB2IH
        TbWlzCS1tSyiFjDKjtWa+IrFrh50sd2AuGDL48E=
X-Google-Smtp-Source: APXvYqwpxxsRDZfcjfR6u0A0LwR3CXk1cvZPgXhbvJGNknlC175M7kH37ZY7HR7ZvIqO4ompTvTBebJhkTcYvUE/BzA=
X-Received: by 2002:ac8:2a63:: with SMTP id l32mr75714552qtl.117.1560789601848;
 Mon, 17 Jun 2019 09:40:01 -0700 (PDT)
MIME-Version: 1.0
References: <20190615191225.2409862-1-ast@kernel.org>
In-Reply-To: <20190615191225.2409862-1-ast@kernel.org>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Mon, 17 Jun 2019 09:39:50 -0700
Message-ID: <CAEf4BzY_w-tTQFy_MfSvRwS4uDziNLRN+Jax4WXidP9R-s961w@mail.gmail.com>
Subject: Re: [PATCH v3 bpf-next 0/9] bpf: bounded loops and other features
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

On Sat, Jun 15, 2019 at 12:12 PM Alexei Starovoitov <ast@kernel.org> wrote:
>
> v2->v3: fixed issues in backtracking pointed out by Andrii.
> The next step is to add a lot more tests for backtracking.
>

Tests would be great, verifier complexity is at the level, where it's
very easy to miss issues.

Was fuzzying approach ever discussed for BPF verifier? I.e., have a
fuzzer to generate both legal and illegal random small programs. Then
re-implement verifier as user-level program with straightforward
recursive exhaustive verification (so no state pruning logic, no
precise/coarse, etc, just register/stack state tracking) of all
possible branches. If kernel verifier's verdict differs from
user-level verifier's verdict - flag that as a test case and figure
out why they differ. Obviously that would work well only for small
programs, but that should be a good first step already.

In addition, if this is done, that user-land verifier can be a HUGE
help to BPF application developers, as libbpf would (potentially) be
able to generate better error messages using it as well.


> v1->v2: addressed Andrii's feedback.
>
> this patch set introduces verifier support for bounded loops and
> adds several other improvements.
> Ideally they would be introduced one at a time,
> but to support bounded loop the verifier needs to 'step back'
> in the patch 1. That patch introduces tracking of spill/fill
> of constants through the stack. Though it's a useful feature
> it hurts cilium tests.
> Patch 3 introduces another feature by extending is_branch_taken
> logic to 'if rX op rY' conditions. This feature is also
> necessary to support bounded loops.
> Then patch 4 adds support for the loops while adding
> key heuristics with jmp_processed.
> Introduction of parentage chain of verifier states in patch 4
> allows patch 9 to add backtracking of precise scalar registers
> which finally resolves degradation from patch 1.
>
> The end result is much faster verifier for existing programs
> and new support for loops.
> See patch 8 for many kinds of loops that are now validated.
> Patch 9 is the most tricky one and could be rewritten with
> a different algorithm in the future.
>
> Alexei Starovoitov (9):
>   bpf: track spill/fill of constants
>   selftests/bpf: fix tests due to const spill/fill
>   bpf: extend is_branch_taken to registers
>   bpf: introduce bounded loops
>   bpf: fix callees pruning callers
>   selftests/bpf: fix tests
>   selftests/bpf: add basic verifier tests for loops
>   selftests/bpf: add realistic loop tests
>   bpf: precise scalar_value tracking
>
>  include/linux/bpf_verifier.h                  |  69 +-
>  kernel/bpf/verifier.c                         | 767 ++++++++++++++++--
>  .../bpf/prog_tests/bpf_verif_scale.c          |  67 +-
>  tools/testing/selftests/bpf/progs/loop1.c     |  28 +
>  tools/testing/selftests/bpf/progs/loop2.c     |  28 +
>  tools/testing/selftests/bpf/progs/loop3.c     |  22 +
>  tools/testing/selftests/bpf/progs/pyperf.h    |   6 +-
>  tools/testing/selftests/bpf/progs/pyperf600.c |   9 +
>  .../selftests/bpf/progs/pyperf600_nounroll.c  |   8 +
>  .../testing/selftests/bpf/progs/strobemeta.c  |  10 +
>  .../testing/selftests/bpf/progs/strobemeta.h  | 528 ++++++++++++
>  .../bpf/progs/strobemeta_nounroll1.c          |   9 +
>  .../bpf/progs/strobemeta_nounroll2.c          |   9 +
>  .../selftests/bpf/progs/test_seg6_loop.c      | 261 ++++++
>  .../selftests/bpf/progs/test_sysctl_loop1.c   |  71 ++
>  .../selftests/bpf/progs/test_sysctl_loop2.c   |  72 ++
>  .../selftests/bpf/progs/test_xdp_loop.c       | 231 ++++++
>  tools/testing/selftests/bpf/test_verifier.c   |  11 +-
>  tools/testing/selftests/bpf/verifier/calls.c  |  22 +-
>  tools/testing/selftests/bpf/verifier/cfg.c    |  11 +-
>  .../bpf/verifier/direct_packet_access.c       |   3 +-
>  .../bpf/verifier/helper_access_var_len.c      |  28 +-
>  tools/testing/selftests/bpf/verifier/loops1.c | 161 ++++
>  23 files changed, 2317 insertions(+), 114 deletions(-)
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
>  create mode 100644 tools/testing/selftests/bpf/verifier/loops1.c
>
> --
> 2.20.0
>

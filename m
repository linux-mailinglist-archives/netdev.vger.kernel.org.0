Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 14B4040A636
	for <lists+netdev@lfdr.de>; Tue, 14 Sep 2021 07:52:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239796AbhINFxs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Sep 2021 01:53:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58898 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239673AbhINFxo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Sep 2021 01:53:44 -0400
Received: from mail-yb1-xb2e.google.com (mail-yb1-xb2e.google.com [IPv6:2607:f8b0:4864:20::b2e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 981BAC061574;
        Mon, 13 Sep 2021 22:52:26 -0700 (PDT)
Received: by mail-yb1-xb2e.google.com with SMTP id m70so24540058ybm.5;
        Mon, 13 Sep 2021 22:52:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=RLpoXkJ8QjEW9X0i7BBhsk10b54qTHIpHAyL9du+np0=;
        b=psW1JEXXpSL5REl1aEnMx1ZcRJBhPgWOMmGTQcadAPILtM2L/tnS+qNkN0HPUtzKza
         HDfp9WjC1pelkIdDTA1Hm8kRXsgM79DxbDwn3AQo7YR8WGfrnf0adym+xLO6ruEi2wol
         4KZlUZlVI4lybr9Vxv3C+bBjXHtqnixENiFmRuSn4PpfjxRU2276cH7555vEYnDMDpRx
         jNmSrSvKMXq5PAtbMnUjtNyE75m2uwbMchU5c2pyBiNStb7mF8KQHBt7A6wtG0MZtyc1
         cdOGOYners5Izg74lPUEVIg4QB/8p+4aloJL4TAMfL+CyiHqxl1/8XHNTfGfYhRZ5pbp
         LD7Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=RLpoXkJ8QjEW9X0i7BBhsk10b54qTHIpHAyL9du+np0=;
        b=VB8GLX7yT0yoFEPb2yzilnNd7ORKDg0yVmKgpHAKG9/u9Fr6ffQg175Q46y5Ey4ihl
         7x5ooG7nvNlGNDYvSkcKIrTEZO0Y4J/ZVOHwj8aIywyCPG0YJJiSDNKjYIx6XpummOfX
         7i/PCCCAs7SDoBhJWI3bkeXnIcErOrLPF+8BEKooeN4HHdY8w5M3Skxn6FSeGd+vuEIx
         FVBdjS0+HyxeKdvWSRu00FnYPODnrfEaZ1O1r8un3cr08ALh5lzO+2+a/hD4yh/Zx+bz
         4xiFgh6DouVTlwXOWcosnSNmN5JiU+PJUmX7EjG1UHEjHQB5jBr1KSUdAFvuuo7vAx37
         sj/Q==
X-Gm-Message-State: AOAM530VFTbBYbIeVOTT157IeqeFfGYQJ82e+1d1xTdtPuEEss5RAn8N
        JAFMmDd/6cpOlrHXJHYU/w3gOrfCOnZwPrIsFJF5EF4sXtE=
X-Google-Smtp-Source: ABdhPJzBTc3889+1obF2FPPivBDBFtNdLUaQTHl1KGTVyvgAYLOVDjldflaVIHZOPo/GYLhlDpN+IdEmOdTguQwtjO0=
X-Received: by 2002:a25:47c4:: with SMTP id u187mr21605934yba.225.1631598745772;
 Mon, 13 Sep 2021 22:52:25 -0700 (PDT)
MIME-Version: 1.0
References: <20210913035609.160722-1-davemarchevsky@fb.com>
In-Reply-To: <20210913035609.160722-1-davemarchevsky@fb.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Mon, 13 Sep 2021 22:52:14 -0700
Message-ID: <CAEf4BzbU30-JN7FTqm4ng8gF6P8_DKNbYSe9K_kvq-Amxk3KLg@mail.gmail.com>
Subject: Re: [PATCH v5 bpf-next 0/9] bpf: implement variadic printk helper
To:     Dave Marchevsky <davemarchevsky@fb.com>
Cc:     bpf <bpf@vger.kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Yonghong Song <yhs@fb.com>, Networking <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Sep 12, 2021 at 8:56 PM Dave Marchevsky <davemarchevsky@fb.com> wrote:
>
> This series introduces a new helper, bpf_trace_vprintk, which functions
> like bpf_trace_printk but supports > 3 arguments via a pseudo-vararg u64
> array. The bpf_printk libbpf convenience macro is modified to use
> bpf_trace_vprintk when > 3 varargs are passed, otherwise the previous
> behavior - using bpf_trace_printk - is retained.
>
> Helper functions and macros added during the implementation of
> bpf_seq_printf and bpf_snprintf do most of the heavy lifting for
> bpf_trace_vprintk. There's no novel format string wrangling here.
>
> Usecase here is straightforward: Giving BPF program writers a more
> powerful printk will ease development of BPF programs, particularly
> during debugging and testing, where printk tends to be used.
>
> This feature was proposed by Andrii in libbpf mirror's issue tracker
> [1].
>
> [1] https://github.com/libbpf/libbpf/issues/315
>
> v4 -> v5:
>
> * patch 8: added test for "%pS" format string w/ NULL fmt arg [Daniel]
> * patch 8: dmesg -> /sys/kernel/debug/tracing/trace_pipe in commit message [Andrii]
> * patch 9: squash into patch 8, remove the added test in favor of just bpf_printk'ing in patch 8's test [Andrii]
>     * migrate comment to /* */
> * header comments improved$
>     * uapi/linux/bpf.h: u64 -> long return type [Daniel]
>     * uapi/linux/bpf.h: function description explains benefit of bpf_trace_vprintk over bpf_trace_printk [Daniel]
>     * uapi/linux/bpf.h: added patch explaining that data_len should be a multiple of 8 in bpf_seq_printf, bpf_snprintf descriptions [Daniel]
>     * tools/lib/bpf/bpf_helpers.h: move comment to new bpf_printk [Andrii]
> * rebase
>
> v3 -> v4:
> * Add patch 2, which migrates reference_tracking prog_test away from
>   bpf_program__load. Could be placed a bit later in the series, but
>   wanted to keep the actual vprintk-related patches contiguous
> * Add patch 9, which adds a program w/ 0 fmt arg bpf_printk to vprintk
>   test
> * bpf_printk convenience macro isn't multiline anymore, so simplify [Andrii]
> * Add some comments to ___bpf_pick_printk to make it more obvious when
>   implementation switches from printk to vprintk [Andrii]
> * BPF_PRINTK_FMT_TYPE -> BPF_PRINTK_FMT_MOD for 'static const' fmt string
>   in printk wrapper macro [Andrii]
>     * checkpatch.pl doesn't like this, says "Macros with complex values
>       should be enclosed in parentheses". Strange that it didn't have similar
>       complaints about v3's BPF_PRINTK_FMT_TYPE. Regardless, IMO the complaint
>       is not highlighting a real issue in the case of this macro.
> * Fix alignment of __bpf_vprintk and __bpf_pick_printk [Andrii]
> * rebase
>
> v2 -> v3:
> * Clean up patch 3's commit message [Alexei]
> * Add patch 4, which modifies __bpf_printk to use 'static const char' to
>   store fmt string with fallback for older kernels [Andrii]
> * rebase
>
> v1 -> v2:
>
> * Naming conversation seems to have gone in favor of keeping
>   bpf_trace_vprintk, names are unchanged
>
> * Patch 3 now modifies bpf_printk convenience macro to choose between
>   __bpf_printk and __bpf_vprintk 'implementation' macros based on arg
>   count. __bpf_vprintk is a renaming of bpf_vprintk convenience macro
>   from v1, __bpf_printk is the existing bpf_printk implementation.
>
>   This patch could use some scrutiny as I think current implementation
>   may regress developer experience in a specific case, turning a
>   compile-time error into a load-time error. Unclear to me how
>   common the case is, or whether the macro magic I chose is ideal.
>
> * char ___fmt[] to static const char ___fmt[] change was not done,
>   wanted to leave __bpf_printk 'implementation' macro unchanged for v2
>   to ease discussion of above point
>
> * Removed __always_inline from __set_printk_clr_event [Andrii]
> * Simplified bpf_trace_printk docstring to refer to other functions
>   instead of copy/pasting and avoid specifying 12 vararg limit [Andrii]
> * Migrated trace_printk selftest to use ASSERT_ instead of CHECK
>   * Adds new patch 5, previous patch 5 is now 6
> * Migrated trace_vprintk selftest to use ASSERT_ instead of CHECK,
>   open_and_load instead of separate open, load [Andrii]
> * Patch 2's commit message now correctly mentions trace_pipe instead of
>   dmesg [Andrii]
>
> Dave Marchevsky (9):
>   bpf: merge printk and seq_printf VARARG max macros
>   selftests/bpf: stop using bpf_program__load
>   bpf: add bpf_trace_vprintk helper
>   libbpf: Modify bpf_printk to choose helper based on arg count
>   libbpf: use static const fmt string in __bpf_printk
>   bpftool: only probe trace_vprintk feature in 'full' mode
>   selftests/bpf: Migrate prog_tests/trace_printk CHECKs to ASSERTs
>   selftests/bpf: add trace_vprintk test prog
>   bpf: clarify data_len param in bpf_snprintf and bpf_seq_printf
>     comments
>
>  include/linux/bpf.h                           |  3 +
>  include/uapi/linux/bpf.h                      | 16 ++++-
>  kernel/bpf/core.c                             |  5 ++
>  kernel/bpf/helpers.c                          |  6 +-
>  kernel/trace/bpf_trace.c                      | 54 ++++++++++++++-
>  tools/bpf/bpftool/feature.c                   |  1 +
>  tools/include/uapi/linux/bpf.h                | 16 ++++-
>  tools/lib/bpf/bpf_helpers.h                   | 51 +++++++++++---
>  tools/testing/selftests/bpf/Makefile          |  3 +-
>  .../bpf/prog_tests/reference_tracking.c       | 39 ++++++++---
>  .../selftests/bpf/prog_tests/trace_printk.c   | 24 +++----
>  .../selftests/bpf/prog_tests/trace_vprintk.c  | 68 +++++++++++++++++++
>  .../selftests/bpf/progs/trace_vprintk.c       | 33 +++++++++
>  tools/testing/selftests/bpf/test_bpftool.py   | 22 +++---
>  14 files changed, 286 insertions(+), 55 deletions(-)
>  create mode 100644 tools/testing/selftests/bpf/prog_tests/trace_vprintk.c
>  create mode 100644 tools/testing/selftests/bpf/progs/trace_vprintk.c
>
> --
> 2.30.2
>

This is a great feature and nice and clean implementation, thanks.
Unfortunately it's conflicting with recently landed
bpf_get_branch_snapshot() series, so you'll have to rebase and
resubmit.

For the series:

Acked-by: Andrii Nakryiko <andrii@kernel.org>

Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 80E4D3E9A90
	for <lists+netdev@lfdr.de>; Wed, 11 Aug 2021 23:47:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232285AbhHKVsK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Aug 2021 17:48:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46876 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232166AbhHKVsJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 Aug 2021 17:48:09 -0400
Received: from mail-yb1-xb2d.google.com (mail-yb1-xb2d.google.com [IPv6:2607:f8b0:4864:20::b2d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 44A4AC061765;
        Wed, 11 Aug 2021 14:47:45 -0700 (PDT)
Received: by mail-yb1-xb2d.google.com with SMTP id a93so7555006ybi.1;
        Wed, 11 Aug 2021 14:47:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=gpLc9KLpDiokUAQGC0OEvqNDu4K4kWLQglgcbBGU6io=;
        b=DBDn8LPePfYuw0ZbqwUAc6mMpk5LUlpBzBtQXq+LBZDWhQe8C6hsfh4fFQyDWR0KHV
         UXh4WkAcT4NG08GI0pFc0MU7gjEdOhPARQVz6Egc3QeiatapGsgxbw72D12Z+KYx/vtq
         r0okkJyRusqPgYlg5bwEL2cSA/nwQK8ttzMaLrWoJtykWbfyjJ9VhBMDUDcwEvMFmH9F
         RVBSvHjkjfDDBXOJZH/2Sw/Y9t5oeHc5NfGxKuHvkpLXd15aOyPUTfViP6rYvbJujRRE
         v9QqKD9XVFEs/H8wpmaaV3S7CqjurQx9Yonr193uNubKJoGf3Zs3OVkhgEHSVbeoirMp
         6KPA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=gpLc9KLpDiokUAQGC0OEvqNDu4K4kWLQglgcbBGU6io=;
        b=qic1r+Ctg3zNI5MbUUEV5WlQDtc9EdfGE0t8j/lubKhTMcyIIFOxYfx5Xrbkgwexae
         oA9dbgXx5gBUbExDLPz8GoM3QR2bIz3aISgJ1mG8/8gq9bmk3zKJX2YjqecktkaXUmeA
         zu0CX+chfk8PKGqstBAoWJhnKLaHJbyl94a6xN+VxXfvFJTLJbu5izzzwNr3BiL1GQKe
         SCnGohiiiPoYWma8bR5PjzPTCIN96J2OsujPqsbRiNNtSxrJQo5fVSD8yCzlmx6/38al
         O2s57KQ9+chc7+3D7VqKUw3qxJXFTbAHm8JN6M7sC5aAF/nluwS3J3F+IVJSSqVDs8hG
         fByQ==
X-Gm-Message-State: AOAM533cm5e4T03TFjU2++QKaurCNTemYiXCniLauhmLLIswPppPl4ps
        gTNtKkAre5vd05swelvw0oDHbmmkijTp5EHV1kE=
X-Google-Smtp-Source: ABdhPJzBIv2U+ZqobtF38wug2kunXkAptpM7AtnmRGNbjbjtNMomuWB3LmgiOI9URqRWYfa4wPrQmGHf6boZ/CYsjxE=
X-Received: by 2002:a5b:648:: with SMTP id o8mr169755ybq.260.1628718464579;
 Wed, 11 Aug 2021 14:47:44 -0700 (PDT)
MIME-Version: 1.0
References: <20210810180608.1858888-1-haoluo@google.com>
In-Reply-To: <20210810180608.1858888-1-haoluo@google.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Wed, 11 Aug 2021 14:47:33 -0700
Message-ID: <CAEf4BzaW=QTa+_6DDvCBgp2BP636J12beyds_S1gD1fJ+Wnwwg@mail.gmail.com>
Subject: Re: [PATCH bpf-next v2] libbpf: support weak typed ksyms.
To:     Hao Luo <haoluo@google.com>
Cc:     Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andriin@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Aug 10, 2021 at 11:22 AM Hao Luo <haoluo@google.com> wrote:
>
> Currently weak typeless ksyms have default value zero, when they don't
> exist in the kernel. However, weak typed ksyms are rejected by libbpf
> if they can not be resolved. This means that if a bpf object contains
> the declaration of a nonexistent weak typed ksym, it will be rejected
> even if there is no program that references the symbol.
>
> Nonexistent weak typed ksyms can also default to zero just like
> typeless ones. This allows programs that access weak typed ksyms to be
> accepted by verifier, if the accesses are guarded. For example,
>
> extern const int bpf_link_fops3 __ksym __weak;
>
> /* then in BPF program */
>
> if (&bpf_link_fops3) {
>    /* use bpf_link_fops3 */
> }
>
> If actual use of nonexistent typed ksym is not guarded properly,
> verifier would see that register is not PTR_TO_BTF_ID and wouldn't
> allow to use it for direct memory reads or passing it to BPF helpers.
>
> Signed-off-by: Hao Luo <haoluo@google.com>
> ---

Selftests are failing ([0]). Did they work locally?..

  test_weak_syms:PASS:test_ksyms_weak__open_and_load 0 nsec
  test_weak_syms:FAIL:existing typed ksym unexpected existing typed
ksym: actual -1 != expected 0
  test_weak_syms:FAIL:existing typeless ksym unexpected existing
typeless ksym: actual -1 == expected -1
  test_weak_syms:FAIL:nonexistent typeless ksym unexpected nonexistent
typeless ksym: actual -1 != expected 0
  test_weak_syms:FAIL:nonexistent typed ksym unexpected nonexistent
typed ksym: actual -1 != expected 0
  #59/3 weak_ksyms:FAIL
  #59 ksyms_btf:FAIL


  [0] https://github.com/kernel-patches/bpf/pull/1611/checks?check_run_id=3305288074

> Changes since v1:
>  - Weak typed symbols default to zero, as suggested by Andrii.
>  - Use ASSERT_XXX() for tets.
>
>  tools/lib/bpf/libbpf.c                        | 17 ++++--
>  .../selftests/bpf/prog_tests/ksyms_btf.c      | 25 ++++++++
>  .../selftests/bpf/progs/test_ksyms_weak.c     | 57 +++++++++++++++++++
>  3 files changed, 94 insertions(+), 5 deletions(-)
>  create mode 100644 tools/testing/selftests/bpf/progs/test_ksyms_weak.c
>

[...]

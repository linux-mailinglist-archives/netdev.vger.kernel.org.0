Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DE2403E9ACA
	for <lists+netdev@lfdr.de>; Thu, 12 Aug 2021 00:14:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232461AbhHKWOX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Aug 2021 18:14:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52828 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232226AbhHKWOW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 Aug 2021 18:14:22 -0400
Received: from mail-ej1-x629.google.com (mail-ej1-x629.google.com [IPv6:2a00:1450:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6974DC061765
        for <netdev@vger.kernel.org>; Wed, 11 Aug 2021 15:13:58 -0700 (PDT)
Received: by mail-ej1-x629.google.com with SMTP id lo4so7168963ejb.7
        for <netdev@vger.kernel.org>; Wed, 11 Aug 2021 15:13:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=KN65N3zNqwksK4aLZmFeR22MZj3e4ZruHE6wL1eK2rs=;
        b=N7pp/CQkEEg1eJ6jDKs92tenu/FLGs3+0O3wG/vHbh5CvRJLdKR2+UpUppqT92ONtz
         MP0uvbvYTKvbHC9BdNUv/nyfmO4HQiNTeLJ6CQrzHf71JQ/Wy8BEwxVAz4ozqJN+HJzQ
         lDBfo8RBd8WD4TjR2OtfqeXgs8rnUC4DAgFHCv/uK7cYhgUuYuYXY/NgMdqzohKWeaGB
         C8GIXNcVhrqh1b4JXV5TolqLYPYaLj78yoM1d4anleZPG1Ifc/9HG3IBJ0d2gl+DdWo/
         ewdnyzTM+fREaydvOrnwINVBip3bYDCM2yK9cv3kLi2fosYG/4Tz39NdYrJClWiiq+Qo
         3WYA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=KN65N3zNqwksK4aLZmFeR22MZj3e4ZruHE6wL1eK2rs=;
        b=jTTkKUHopZUY2oVHZ97fQ5nivIdmnMMKaHl1RAR6uLTKm6o1C3cbg1J+abtpGPbvSf
         NSANb/SGrsMV7CuwlSwh7g35o+tF8sGB7v9HtJJmCaPww5U+iHY8vRJveHQQEF/Pmlgo
         WuKQI35ylO2DNPAGcDivPVrPh+gunhYNZQsz71Zbykk/YXzSqPhl+mG1ATZsA/V5oBzX
         h7h/H8evzW7yf1cULS626wSZyGMrGFWAlyBTR36kXLkYIe+FZC7kmP74728AjZ8Pj1oF
         Ppo9wxS8qvLvZVHQv88VeIb+n6QFMB7/xpLU76dZjpDrHhGlV5+qU7EYsRlkoEZrfWPn
         TVMw==
X-Gm-Message-State: AOAM533BnawKK9FelgNSP8WtTrM2w4Haw35OPzjqmjyoiQtlwpgLAmEm
        /r2r3zt/S0zGgYxS7hE7F+FVYDXGnugePvWxJ55yjw==
X-Google-Smtp-Source: ABdhPJwIblrqmMbDd6O8yrKRmYNrkRYqYu4XHEfDzZtXfMq3a0mKIjRaX6k7RaeVW9POFYyhX3T6ZiRxdet8JywMf5U=
X-Received: by 2002:a17:906:14c8:: with SMTP id y8mr631005ejc.475.1628720036734;
 Wed, 11 Aug 2021 15:13:56 -0700 (PDT)
MIME-Version: 1.0
References: <20210810180608.1858888-1-haoluo@google.com> <CAEf4BzaW=QTa+_6DDvCBgp2BP636J12beyds_S1gD1fJ+Wnwwg@mail.gmail.com>
In-Reply-To: <CAEf4BzaW=QTa+_6DDvCBgp2BP636J12beyds_S1gD1fJ+Wnwwg@mail.gmail.com>
From:   Hao Luo <haoluo@google.com>
Date:   Wed, 11 Aug 2021 15:13:45 -0700
Message-ID: <CA+khW7i=gd81_i=tBuXBt1ZQvANnWkXyadMTcCfs_R2x9_Yysw@mail.gmail.com>
Subject: Re: [PATCH bpf-next v2] libbpf: support weak typed ksyms.
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
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

On Wed, Aug 11, 2021 at 2:47 PM Andrii Nakryiko
<andrii.nakryiko@gmail.com> wrote:
>
> On Tue, Aug 10, 2021 at 11:22 AM Hao Luo <haoluo@google.com> wrote:
> >
> > Currently weak typeless ksyms have default value zero, when they don't
> > exist in the kernel. However, weak typed ksyms are rejected by libbpf
> > if they can not be resolved. This means that if a bpf object contains
> > the declaration of a nonexistent weak typed ksym, it will be rejected
> > even if there is no program that references the symbol.
> >
> > Nonexistent weak typed ksyms can also default to zero just like
> > typeless ones. This allows programs that access weak typed ksyms to be
> > accepted by verifier, if the accesses are guarded. For example,
> >
> > extern const int bpf_link_fops3 __ksym __weak;
> >
> > /* then in BPF program */
> >
> > if (&bpf_link_fops3) {
> >    /* use bpf_link_fops3 */
> > }
> >
> > If actual use of nonexistent typed ksym is not guarded properly,
> > verifier would see that register is not PTR_TO_BTF_ID and wouldn't
> > allow to use it for direct memory reads or passing it to BPF helpers.
> >
> > Signed-off-by: Hao Luo <haoluo@google.com>
> > ---
>
> Selftests are failing ([0]). Did they work locally?..
>
>   test_weak_syms:PASS:test_ksyms_weak__open_and_load 0 nsec
>   test_weak_syms:FAIL:existing typed ksym unexpected existing typed
> ksym: actual -1 != expected 0
>   test_weak_syms:FAIL:existing typeless ksym unexpected existing
> typeless ksym: actual -1 == expected -1
>   test_weak_syms:FAIL:nonexistent typeless ksym unexpected nonexistent
> typeless ksym: actual -1 != expected 0
>   test_weak_syms:FAIL:nonexistent typed ksym unexpected nonexistent
> typed ksym: actual -1 != expected 0
>   #59/3 weak_ksyms:FAIL
>   #59 ksyms_btf:FAIL
>

Doh, in the test I accidentally removed the line of attachment in the
last minute of sending out... :) Let me resend quickly.


>
>   [0] https://github.com/kernel-patches/bpf/pull/1611/checks?check_run_id=3305288074
>
> > Changes since v1:
> >  - Weak typed symbols default to zero, as suggested by Andrii.
> >  - Use ASSERT_XXX() for tets.
> >
> >  tools/lib/bpf/libbpf.c                        | 17 ++++--
> >  .../selftests/bpf/prog_tests/ksyms_btf.c      | 25 ++++++++
> >  .../selftests/bpf/progs/test_ksyms_weak.c     | 57 +++++++++++++++++++
> >  3 files changed, 94 insertions(+), 5 deletions(-)
> >  create mode 100644 tools/testing/selftests/bpf/progs/test_ksyms_weak.c
> >
>
> [...]

Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 711A22B2521
	for <lists+netdev@lfdr.de>; Fri, 13 Nov 2020 21:07:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726487AbgKMUHE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Nov 2020 15:07:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56002 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726162AbgKMUHD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 Nov 2020 15:07:03 -0500
Received: from mail-yb1-xb43.google.com (mail-yb1-xb43.google.com [IPv6:2607:f8b0:4864:20::b43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 33E66C0613D1;
        Fri, 13 Nov 2020 12:07:02 -0800 (PST)
Received: by mail-yb1-xb43.google.com with SMTP id o71so9498816ybc.2;
        Fri, 13 Nov 2020 12:07:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Qr+phWMGXmj8erLd7cXWWK7GP/+zySzbE2OGQPxrGdI=;
        b=I+/Nn+9WYeJY5yuArz6h8EWHQyI+hm86oUOgdmIx8+kZtUZDjDBz8SiOBfaj1ftMBR
         pSglMcF3Ek5Wri+0rmkCb7QtXVXAcePHfYq9IRfProozK5EgSv4wd4lTZzDuSEDU55uT
         LIcalCMSVKAnjHAiGROaQ6Gb0S0JqJR5TdjgU8fRgammU71Fefds2Ygd08iEkGwm+OD0
         wrb+cfq+Ve6ewbwQWrg7zLSj7ogd5/hs6tqmcTrRwpF4NyLrcwXpLGXfSIEzwzJfCGQA
         D6iOUPsQS0WJ+/8KoRnDxXi2Rg0Y/GXtrDFrIHarYRmKw0InC8au2t7UqqUcGT7dunLE
         ZicQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Qr+phWMGXmj8erLd7cXWWK7GP/+zySzbE2OGQPxrGdI=;
        b=iNVfeSK2gIP8FiKxzKArDn/C5dmpZKDVOi7Yu4uLK/5rXSFZSAQ3ZKcS88e9iFbJRr
         cmPEq8lSltY1ED2Vj/+tGXoNYL7NXtx2Yu2kd6RqU8NuQ3HBUSHPjDdKuA5sU2qrvX7W
         25+BaljkZZss/OTPXPMACnpPURUoW8Bo67qVQ4RSQbh7M+yG9PzODEnMRrB1uEBCgrw4
         ONl/AD0QtFTY+dF+5Y3NqM+ihmCz2J7Fe9SPICcaffD2KKsvjS0mzVvLhuVwXCTW9oE4
         ePJpVRgXVbIJU0BSzE6E8uTX229RrB1jvE0jMVh9uuiuaD99xVrjdWKDku/3amEKC9As
         sQZA==
X-Gm-Message-State: AOAM531VPP6K2V8yoJ6xOBzIjjj7NqC2aPyrg3czN+z9tQXylmknWxbp
        OfFdMu4MYiZ0lP9rZqBEyZb5da7JcEQL41YKlxM=
X-Google-Smtp-Source: ABdhPJwB6jRaLScGvH5zLmxhJabraqtZscankqpOcsVNRhi29t84IATrIzCT7aGl+QDX4g4t44L5BPtK1S9nBz9Nat8=
X-Received: by 2002:a25:3d7:: with SMTP id 206mr5816866ybd.27.1605298021377;
 Fri, 13 Nov 2020 12:07:01 -0800 (PST)
MIME-Version: 1.0
References: <20201113171756.90594-1-me@ubique.spb.ru>
In-Reply-To: <20201113171756.90594-1-me@ubique.spb.ru>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Fri, 13 Nov 2020 12:06:50 -0800
Message-ID: <CAEf4Bzbjx8Hpozi9eaa2da2K9WbA_xA0tVrp_+3DHN4GgKmeXw@mail.gmail.com>
Subject: Re: [PATCH bpf v2] bpf: relax return code check for subprograms
To:     Dmitrii Banshchikov <me@ubique.spb.ru>
Cc:     bpf <bpf@vger.kernel.org>, Kernel Team <kernel-team@fb.com>,
        Andrey Ignatov <rdna@fb.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin Lau <kafai@fb.com>, Song Liu <songliubraving@fb.com>,
        Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andrii@kernel.org>,
        john fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>,
        =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>,
        Networking <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Nov 13, 2020 at 9:18 AM Dmitrii Banshchikov <me@ubique.spb.ru> wrote:
>
> Currently verifier enforces return code checks for subprograms in the
> same manner as it does for program entry points. This prevents returning
> arbitrary scalar values from subprograms. Scalar type of returned values
> is checked by btf_prepare_func_args() and hence it should be safe to
> allow only scalars for now. Relax return code checks for subprograms and
> allow any correct scalar values.
>
> Signed-off-by: Dmitrii Banshchikov <me@ubique.spb.ru>
> Fixes: 51c39bb1d5d10 (bpf: Introduce function-by-function verification)
> ---

LGTM!

Acked-by: Andrii Nakryiko <andrii@kernel.org>

> v1 -> v2:
>  - Move is_subprog flag determination to check_return_code()
>  - Remove unneeded intermediate function from tests
>  - Use __noinline instead of __attribute__((noinline)) in tests
>
>  kernel/bpf/verifier.c                         | 15 +++++++++++++--
>  .../bpf/prog_tests/test_global_funcs.c        |  1 +
>  .../selftests/bpf/progs/test_global_func8.c   | 19 +++++++++++++++++++
>  3 files changed, 33 insertions(+), 2 deletions(-)
>  create mode 100644 tools/testing/selftests/bpf/progs/test_global_func8.c
>

[...]

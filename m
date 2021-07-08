Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 20AAC3BF2B9
	for <lists+netdev@lfdr.de>; Thu,  8 Jul 2021 02:12:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230091AbhGHAPB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Jul 2021 20:15:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57508 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230018AbhGHAPB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Jul 2021 20:15:01 -0400
Received: from mail-yb1-xb2e.google.com (mail-yb1-xb2e.google.com [IPv6:2607:f8b0:4864:20::b2e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 55AC5C061574;
        Wed,  7 Jul 2021 17:12:19 -0700 (PDT)
Received: by mail-yb1-xb2e.google.com with SMTP id i4so6085586ybe.2;
        Wed, 07 Jul 2021 17:12:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Ai3QoUwF269skrEAl87NiEr1rh3smfA9/LMINEuC7R0=;
        b=GlRe5n8+JUWW6X0Pe3y+ghYftRfy5EeBkyQ9ImPIwOTAL1E8tEw/9pbPOvuukhsAwy
         NEKla51THiixJc9lyYBIhZ/NtKgEkbRQs+qsEtu1B2VTwdCp8MEX5NMJ5jSJckNtJ0Jw
         8FRtW2JWUSulmW8+aujKNBYFTMRbyFLogZ0nFx55b0Wm0wSEh67R+INbILxxALLlneRN
         h7RvR11M7p7GEbXEJSy7TW5i13xSTmkZ9slwGDuCl/Hupg1O3lGKJAdS2tdap/hqZKbt
         291CVbaOzLp2tKdxoza+b8KPhK301ny7JrlSNtjGIdg9CBNO0RDXOX+OArk97Oh7hPZT
         lTPw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Ai3QoUwF269skrEAl87NiEr1rh3smfA9/LMINEuC7R0=;
        b=qqvuo/TPY+c9KmZQr1M126xEWJi6yxfhJCEYvBuMtTXBy1o3Z6keklcAQblitO1cP3
         IEbbUrzlIbcAUmdR+zEtwAlWNILV6z7CE1g/F6JkAMOBqTbQDAxQ/kgugmkFLlv2R1q6
         SwjE8/qIksQVWx7s8v0Sk0ThDL1jeqQrbSkGYIyCD66KGgQaKFVNzZkxZ7JNBt6ahpCm
         ZHDWNbEmb6bZhuZeiwAYXY4HDlGpjIuxtG2tvEViCdL6VEPUX9pbp4KasSyYwKfqLV31
         hDBE77QsxG2I+lYnry4iXUh8SIiMnbb+XlWwyEFrJfxfHO7sSvguAS2aVpnQscCkcp37
         AK8Q==
X-Gm-Message-State: AOAM530jg79GjOdvGGyDrbKsiakqs2XC6B2vzmD5yeIpBD+LEE2PGSGr
        tjNNoefEBEcn2t6JakO6T0AEoTbzqvChMPEvOgE=
X-Google-Smtp-Source: ABdhPJw8a/d/IAbgrCj9wqHC8EcLdBH203JxLt6J09K8mroEQnh7vQgoya8KIKVBiSipblBnXrFDrwldVZ9YkIV42RI=
X-Received: by 2002:a25:1ec4:: with SMTP id e187mr35105625ybe.425.1625703138520;
 Wed, 07 Jul 2021 17:12:18 -0700 (PDT)
MIME-Version: 1.0
References: <20210707214751.159713-1-jolsa@kernel.org> <20210707214751.159713-6-jolsa@kernel.org>
In-Reply-To: <20210707214751.159713-6-jolsa@kernel.org>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Wed, 7 Jul 2021 17:12:07 -0700
Message-ID: <CAEf4BzZxDAQZ4Y5n8uCjvrEgmr51CY3AQ8y7zM_Hoh+7zqd6DA@mail.gmail.com>
Subject: Re: [PATCHv3 bpf-next 5/7] selftests/bpf: Add test for
 bpf_get_func_ip helper
To:     Jiri Olsa <jolsa@redhat.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andriin@fb.com>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        Alan Maguire <alan.maguire@oracle.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jul 7, 2021 at 2:54 PM Jiri Olsa <jolsa@redhat.com> wrote:
>
> Adding test for bpf_get_func_ip helper for fentry, fexit,
> kprobe, kretprobe and fmod_ret programs.
>
> Signed-off-by: Jiri Olsa <jolsa@kernel.org>
> ---
>  .../bpf/prog_tests/get_func_ip_test.c         | 42 +++++++++++++
>  .../selftests/bpf/progs/get_func_ip_test.c    | 62 +++++++++++++++++++
>  2 files changed, 104 insertions(+)
>  create mode 100644 tools/testing/selftests/bpf/prog_tests/get_func_ip_test.c
>  create mode 100644 tools/testing/selftests/bpf/progs/get_func_ip_test.c
>

[...]

> +       ASSERT_OK(err, "test_run");
> +
> +       result = (__u64 *)skel->bss;
> +       for (i = 0; i < sizeof(*skel->bss) / sizeof(__u64); i++) {
> +               if (!ASSERT_EQ(result[i], 1, "fentry_result"))
> +                       break;
> +       }

I dislike such generic loop over results. It's super error prone and
takes the same 5 lines of code that you'd write for explicit

ASSERT_EQ(testX_result, 1, "testX_result"); /* 5 times */

> +
> +       get_func_ip_test__detach(skel);

no need to explicitly detach, __destroy does that automatically

> +
> +cleanup:
> +       get_func_ip_test__destroy(skel);
> +}

[...]

Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6EED232A2C4
	for <lists+netdev@lfdr.de>; Tue,  2 Mar 2021 15:57:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1381743AbhCBIc0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Mar 2021 03:32:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56662 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239800AbhCBAf0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 Mar 2021 19:35:26 -0500
Received: from mail-yb1-xb31.google.com (mail-yb1-xb31.google.com [IPv6:2607:f8b0:4864:20::b31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6C1A9C06178C;
        Mon,  1 Mar 2021 16:34:36 -0800 (PST)
Received: by mail-yb1-xb31.google.com with SMTP id p193so18931071yba.4;
        Mon, 01 Mar 2021 16:34:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=F9VmOYR1Qo8kLJcpDxdviInMt3+/uSHxCcs+aiiYM2c=;
        b=X7YUNY3F4iEqnr4AZc5K+wpIudTH4atG9R1PleILcziU6gJCYTUvP5lPeTje9iltCa
         Ols/FnqXdc/Tc6izRqk2jazJRQCVyN6/L+zjrLKE68+uxQUnJZvPE4zEpcIIvfwuYl86
         N+SjdGZs4jc/suVIScf69laUZAV3Bsb2MNatSxj1qm6SwHfD3wH7uYTySIdGfQXhfgv2
         LIt7H+sjZfi1j1CwFF87RM6LXE02ggkIH487pGwbwSD6zvZImeKBpdoOizOR0B7TTNIe
         PbqnPEfPfQx64hwV9wcdbEULlmRNoXsTIfTZ6OhXSqbmi3D8o20G7cfXhkzYj1GZ65GS
         49TQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=F9VmOYR1Qo8kLJcpDxdviInMt3+/uSHxCcs+aiiYM2c=;
        b=JbjSNx0pevzkPX6azk51kKv4YrqXk/0wsf3jbQ17vbDYmlQi+FCmBrovSBTElYWBfL
         gndn4QrnKSZhA5+Akj3oitLTZWKNUh8/ruvkI5d+Hb4Y7EpUNZeULejZjtcjAbnktxz0
         HgLFDvCPIcaUhD/SiqIPdHCORqK4AauWrLD0muGLTZaU4DdbCTyxCCvjCkdcWoYPX/W+
         NA3xGublhCemIO/pRfS+q6RYxBy0Q86VOxtKkGBkBmFdtDhD5l8J9VTdoPUPdjua8aqA
         14dp81tjZ8HcOnOGd6reqBEF02zEbqJDzLVdzCFVlqAdh2rIRvQw2MAdwWaMYnid5//D
         4iXA==
X-Gm-Message-State: AOAM532nSRqRQuDDwP2fTyRRqQzT0IAlyFMWP60hZ8r+SaeXTV9syNX7
        AgiHcHGzLoI5C4IRXXHC6bevpWW4XojaS4xATlA=
X-Google-Smtp-Source: ABdhPJx98q2KCRQ3je/TnWHPYP38n6lQwWpPlRpj++ZJ8GKGySO18UA1V4ZXnlAHUgfD3mE7TPKYIDmiFjUdFeDZ5uc=
X-Received: by 2002:a25:bd12:: with SMTP id f18mr27907808ybk.403.1614645275613;
 Mon, 01 Mar 2021 16:34:35 -0800 (PST)
MIME-Version: 1.0
References: <20210301190416.90694-1-jolsa@kernel.org>
In-Reply-To: <20210301190416.90694-1-jolsa@kernel.org>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Mon, 1 Mar 2021 16:34:24 -0800
Message-ID: <CAEf4BzbBnR3M60HepC_CFDsdMQDBYoEWiWtREUaLxrrxyBce0Q@mail.gmail.com>
Subject: Re: [PATCH bpf-next] selftests/bpf: Fix test_attach_probe for powerpc uprobes
To:     Jiri Olsa <jolsa@kernel.org>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andriin@fb.com>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>,
        =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>,
        Yauheni Kaliuta <ykaliuta@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Mar 1, 2021 at 11:11 AM Jiri Olsa <jolsa@kernel.org> wrote:
>
> When testing uprobes we the test gets GEP (Global Entry Point)
> address from kallsyms, but then the function is called locally
> so the uprobe is not triggered.
>
> Fixing this by adjusting the address to LEP (Local Entry Point)
> for powerpc arch.
>
> Signed-off-by: Jiri Olsa <jolsa@kernel.org>
> ---
>  .../selftests/bpf/prog_tests/attach_probe.c    | 18 +++++++++++++++++-
>  1 file changed, 17 insertions(+), 1 deletion(-)
>
> diff --git a/tools/testing/selftests/bpf/prog_tests/attach_probe.c b/tools/testing/selftests/bpf/prog_tests/attach_probe.c
> index a0ee87c8e1ea..c3cfb48d3ed0 100644
> --- a/tools/testing/selftests/bpf/prog_tests/attach_probe.c
> +++ b/tools/testing/selftests/bpf/prog_tests/attach_probe.c
> @@ -2,6 +2,22 @@
>  #include <test_progs.h>
>  #include "test_attach_probe.skel.h"
>
> +#if defined(__powerpc64__)
> +/*
> + * We get the GEP (Global Entry Point) address from kallsyms,
> + * but then the function is called locally, so we need to adjust
> + * the address to get LEP (Local Entry Point).
> + */
> +#define LEP_OFFSET 8
> +
> +static ssize_t get_offset(ssize_t offset)

if we mark this function __weak global, would it work as is? Would it
get an address of a global entry point? I know nothing about this GEP
vs LEP stuff, interesting :)

> +{
> +       return offset + LEP_OFFSET;
> +}
> +#else
> +#define get_offset(offset) (offset)
> +#endif
> +
>  ssize_t get_base_addr() {
>         size_t start, offset;
>         char buf[256];
> @@ -36,7 +52,7 @@ void test_attach_probe(void)
>         if (CHECK(base_addr < 0, "get_base_addr",
>                   "failed to find base addr: %zd", base_addr))
>                 return;
> -       uprobe_offset = (size_t)&get_base_addr - base_addr;
> +       uprobe_offset = get_offset((size_t)&get_base_addr - base_addr);
>
>         skel = test_attach_probe__open_and_load();
>         if (CHECK(!skel, "skel_open", "failed to open skeleton\n"))
> --
> 2.29.2
>

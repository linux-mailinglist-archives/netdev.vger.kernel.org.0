Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B8AA332FE81
	for <lists+netdev@lfdr.de>; Sun,  7 Mar 2021 04:16:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230112AbhCGDOL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 6 Mar 2021 22:14:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54686 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230045AbhCGDNm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 6 Mar 2021 22:13:42 -0500
Received: from mail-yb1-xb29.google.com (mail-yb1-xb29.google.com [IPv6:2607:f8b0:4864:20::b29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CEB68C06174A;
        Sat,  6 Mar 2021 19:13:29 -0800 (PST)
Received: by mail-yb1-xb29.google.com with SMTP id u75so6409116ybi.10;
        Sat, 06 Mar 2021 19:13:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=ukm4FF97j3LFYLEbomttgTdVBJw6RIlzQsc6gDhVDes=;
        b=GFO2qxZtYot5ebaiZzSXNQGsJhiHt5OHmfZ54lTbZPGGRpJ6csNIUpXeeg2IrKFUkt
         KNeBemeyvLUfuLcpTjUMdpNL8kyVaaO/ipuyV54MJkonIGVTqzXFScbKYn8H1LdjRGJ8
         HftB5PYP/QapXTKV8E2I4gGWpXibF/rPp+/gfZUOl1H+XbPJ7mc3UXnbVIuFtA3ucuID
         7dkukSLBW5vZ3W17nZi/2rX3WaPjjqmTm8K1IrUZBUPww8VrnsNyk7rwlMqSdC68K+uI
         Yo/uY1tAsfzczj09D2g8E1KYmA2SxMiZksL69YBtki/rp3lQRVqw1MBG9XAcM+PqXW8V
         sreg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ukm4FF97j3LFYLEbomttgTdVBJw6RIlzQsc6gDhVDes=;
        b=VRT0zTdAMoYl+RIsYjTuTqoM2IUxAaHGQ+1YfL+Hc7KcV+Ud89lVJr+6PdUX2lRzFO
         STHcGHS+AZ3wk070TEKVRvxd1OSoKlkLuXd806nv7V4NiYbtyj08w9xV8zbMwasDSsQw
         NzqZae63xKuHI+5XMFO++o8SgWWb1WxLSayK2jZnGyBGEaaC83/BkYWy7G5FsjkTt30L
         7FwDuB1qkEBRSPHlY/5IL4n4w+b1zwa/867qwOPg6h0jaXjKpO+9EzYCAzzL6vjA/jEg
         VJZ+gul/ZgeAhsX+YL+LGtL9XdVp6kBisehn5BWT0SMTn2OrZ/ubdDJYgHVvAim4ARkt
         MJrA==
X-Gm-Message-State: AOAM531r+qKoSR12TjLl0/ywpZlbzEFAsDnxpzaoV4GOym+m3LnCZW7Z
        t9rmYE9HQYbC3w7dvwuZXIT/WyIJy/kirLZSbfQ=
X-Google-Smtp-Source: ABdhPJyDqnIYvgu+uRfrS2rOAw3QEZQOF/3/yWxKMeyif1YHUO/irIwep364lu3o9SQ3vVenFt0tvlxmBj43YWbKpps=
X-Received: by 2002:a25:bd12:: with SMTP id f18mr24038195ybk.403.1615086808614;
 Sat, 06 Mar 2021 19:13:28 -0800 (PST)
MIME-Version: 1.0
References: <20210305134050.139840-1-jolsa@kernel.org>
In-Reply-To: <20210305134050.139840-1-jolsa@kernel.org>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Sat, 6 Mar 2021 19:13:17 -0800
Message-ID: <CAEf4BzanY2ogGDORCsOXrAivWii06vsUpJFT7rQy2nj0xarm+A@mail.gmail.com>
Subject: Re: [PATCHv2 bpf-next] selftests/bpf: Fix test_attach_probe for
 powerpc uprobes
To:     Jiri Olsa <jolsa@kernel.org>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andriin@fb.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        "Naveen N . Rao" <naveen.n.rao@linux.vnet.ibm.com>,
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

On Fri, Mar 5, 2021 at 5:42 AM Jiri Olsa <jolsa@kernel.org> wrote:
>
> When testing uprobes we the test gets GEP (Global Entry Point)
> address from kallsyms, but then the function is called locally
> so the uprobe is not triggered.
>
> Fixing this by adjusting the address to LEP (Local Entry Point)
> for powerpc arch plus instruction check stolen from ppc_function_entry
> function pointed out and explained by Michael and Naveen.
>
> Cc: Michael Ellerman <mpe@ellerman.id.au>
> Cc: Naveen N. Rao <naveen.n.rao@linux.vnet.ibm.com>
> Signed-off-by: Jiri Olsa <jolsa@kernel.org>
> ---
>  .../selftests/bpf/prog_tests/attach_probe.c   | 40 ++++++++++++++++++-
>  1 file changed, 39 insertions(+), 1 deletion(-)
>
> diff --git a/tools/testing/selftests/bpf/prog_tests/attach_probe.c b/tools/testing/selftests/bpf/prog_tests/attach_probe.c
> index a0ee87c8e1ea..9dc4e3dfbcf3 100644
> --- a/tools/testing/selftests/bpf/prog_tests/attach_probe.c
> +++ b/tools/testing/selftests/bpf/prog_tests/attach_probe.c
> @@ -2,6 +2,44 @@
>  #include <test_progs.h>
>  #include "test_attach_probe.skel.h"
>
> +#if defined(__powerpc64__) && defined(_CALL_ELF) && _CALL_ELF == 2
> +
> +#define OP_RT_RA_MASK   0xffff0000UL
> +#define LIS_R2          0x3c400000UL
> +#define ADDIS_R2_R12    0x3c4c0000UL
> +#define ADDI_R2_R2      0x38420000UL
> +
> +static ssize_t get_offset(ssize_t addr, ssize_t base)
> +{
> +       u32 *insn = (u32 *) addr;
> +
> +       /*
> +        * A PPC64 ABIv2 function may have a local and a global entry
> +        * point. We need to use the local entry point when patching
> +        * functions, so identify and step over the global entry point
> +        * sequence.
> +        *
> +        * The global entry point sequence is always of the form:
> +        *
> +        * addis r2,r12,XXXX
> +        * addi  r2,r2,XXXX
> +        *
> +        * A linker optimisation may convert the addis to lis:
> +        *
> +        * lis   r2,XXXX
> +        * addi  r2,r2,XXXX
> +        */
> +       if ((((*insn & OP_RT_RA_MASK) == ADDIS_R2_R12) ||
> +            ((*insn & OP_RT_RA_MASK) == LIS_R2)) &&
> +           ((*(insn + 1) & OP_RT_RA_MASK) == ADDI_R2_R2))
> +               return (ssize_t)(insn + 2) - base;
> +       else
> +               return addr - base;
> +}
> +#else
> +#define get_offset(addr, base) (addr - base)

I turned this into a static function, not sure why you preferred
#define here. Applied to bpf-next.

> +#endif
> +
>  ssize_t get_base_addr() {
>         size_t start, offset;
>         char buf[256];
> @@ -36,7 +74,7 @@ void test_attach_probe(void)
>         if (CHECK(base_addr < 0, "get_base_addr",
>                   "failed to find base addr: %zd", base_addr))
>                 return;
> -       uprobe_offset = (size_t)&get_base_addr - base_addr;
> +       uprobe_offset = get_offset((size_t)&get_base_addr, base_addr);
>
>         skel = test_attach_probe__open_and_load();
>         if (CHECK(!skel, "skel_open", "failed to open skeleton\n"))
> --
> 2.27.0
>

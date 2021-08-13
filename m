Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 276563EBEC2
	for <lists+netdev@lfdr.de>; Sat, 14 Aug 2021 01:28:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235570AbhHMX2r (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Aug 2021 19:28:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47806 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235330AbhHMX2q (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 Aug 2021 19:28:46 -0400
Received: from mail-yb1-xb35.google.com (mail-yb1-xb35.google.com [IPv6:2607:f8b0:4864:20::b35])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 69469C061756;
        Fri, 13 Aug 2021 16:28:19 -0700 (PDT)
Received: by mail-yb1-xb35.google.com with SMTP id w17so21747581ybl.11;
        Fri, 13 Aug 2021 16:28:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=P+SltoyU/N2j1xguB2Et8FTVeM8VFa3dNugcyncKwts=;
        b=AqoOfTR9+NMWIvtEsraBvCF6VCLvvgG0mDIwq+0xnPWnumDH4CqaDpW/K83qR5EB4f
         XgRJfs3G2edvXO32bnplnodVeTjWKd9i0IRwXTZjqk5B3TdR+2lfkReelJ7NL3CJynbw
         966WioGcporq1+9n5NoYmw73L9pYC66rRcWPmdVXVnSL/z00sPlfDgKMuPWeEpLLZuIZ
         GgXw6M9YjDivQ5Ts71qAdjAyV+U/9dLL5W0vBJpqtqMqaCcCS1p3CLfPaADfF60VA/Wv
         MY88leTm8gM8whKGtd3l7NfKgV5epccTn7DQJCC26rrNcR7PtUlbc54nPgFyvlcZgktX
         DrdQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=P+SltoyU/N2j1xguB2Et8FTVeM8VFa3dNugcyncKwts=;
        b=oxfrv8ess7tgxP65cCGqsbDqyU+lzidOLQ0urSyApkhn8LpCrxe5u9mFT5+srHxoEs
         7MALMU987ZJyWd3lZR5w8vx15mIi9Sc7pxkUTJnqmkqBICr8HFO5Ac9SZlfoBVQxdnqh
         51xMNnVRAcNWeZ56sfmjVnvVu++rnCzqyEpENYu3cnmoihMaiD8yDLK/O7kATS4FEFHo
         IsX47oswU/z6VwHXlP+/bni0EGDsqJKQ6R2a9hPXjlwPL9v0GJkMuSyYF/Y2eoa/GHuI
         Aq5LTNgwzs1KetzSTvw5IPvyBZTluRrtnR/Jv7Nw7BlyVmwsZ84GNzOAU6fbxWlwkjZq
         ZIWA==
X-Gm-Message-State: AOAM532YGpZSt7yK3rNNBslcmu/Pco4j9VfOA9pnV390yr42UuD1vbUV
        c4OgltclDXkEHz1mNpTm3kOiIkU8AqQpdutMP/0=
X-Google-Smtp-Source: ABdhPJxLeaBwdc2P5ltaOYpztf7v5DCTlXlVHUbepH5U8Uq0/MjKGoLush4LrMPazomyhCwq9oLBFi48AMG97tgL9Qs=
X-Received: by 2002:a25:d691:: with SMTP id n139mr6096531ybg.27.1628897298709;
 Fri, 13 Aug 2021 16:28:18 -0700 (PDT)
MIME-Version: 1.0
References: <20210812164557.79046-1-kuniyu@amazon.co.jp> <20210812164557.79046-5-kuniyu@amazon.co.jp>
In-Reply-To: <20210812164557.79046-5-kuniyu@amazon.co.jp>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Fri, 13 Aug 2021 16:28:07 -0700
Message-ID: <CAEf4BzbJC7J9=p9Fh8D7OYPoKMHKg5WyaJUyTkngDcpUhOB_0g@mail.gmail.com>
Subject: Re: [PATCH v5 bpf-next 4/4] selftest/bpf: Extend the bpf_snprintf()
 test for "%c".
To:     Kuniyuki Iwashima <kuniyu@amazon.co.jp>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        Benjamin Herrenschmidt <benh@amazon.com>,
        Kuniyuki Iwashima <kuni1840@gmail.com>,
        bpf <bpf@vger.kernel.org>, Networking <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Aug 12, 2021 at 9:47 AM Kuniyuki Iwashima <kuniyu@amazon.co.jp> wrote:
>
> This patch adds a "positive" pattern for "%c", which intentionally uses a
> __u32 value (0x64636261, "dbca") to print a single character "a".  If the
> implementation went wrong, other 3 bytes might show up as the part of the
> latter "%+05s".
>
> Also, this patch adds two "negative" patterns for wide character.
>
> Signed-off-by: Kuniyuki Iwashima <kuniyu@amazon.co.jp>
> ---
>  tools/testing/selftests/bpf/prog_tests/snprintf.c | 4 +++-
>  tools/testing/selftests/bpf/progs/test_snprintf.c | 7 ++++---
>  2 files changed, 7 insertions(+), 4 deletions(-)
>
> diff --git a/tools/testing/selftests/bpf/prog_tests/snprintf.c b/tools/testing/selftests/bpf/prog_tests/snprintf.c
> index dffbcaa1ec98..f77d7def7fed 100644
> --- a/tools/testing/selftests/bpf/prog_tests/snprintf.c
> +++ b/tools/testing/selftests/bpf/prog_tests/snprintf.c
> @@ -19,7 +19,7 @@
>  #define EXP_ADDR_OUT "0000000000000000 ffff00000add4e55 "
>  #define EXP_ADDR_RET sizeof(EXP_ADDR_OUT "unknownhashedptr")
>
> -#define EXP_STR_OUT  "str1 longstr"
> +#define EXP_STR_OUT  "str1         a longstr"
>  #define EXP_STR_RET  sizeof(EXP_STR_OUT)
>
>  #define EXP_OVER_OUT "%over"
> @@ -114,6 +114,8 @@ void test_snprintf_negative(void)
>         ASSERT_ERR(load_single_snprintf("%"), "invalid specifier 3");
>         ASSERT_ERR(load_single_snprintf("%12345678"), "invalid specifier 4");
>         ASSERT_ERR(load_single_snprintf("%--------"), "invalid specifier 5");
> +       ASSERT_ERR(load_single_snprintf("%lc"), "invalid specifier 6");
> +       ASSERT_ERR(load_single_snprintf("%llc"), "invalid specifier 7");
>         ASSERT_ERR(load_single_snprintf("\x80"), "non ascii character");
>         ASSERT_ERR(load_single_snprintf("\x1"), "non printable character");
>  }
> diff --git a/tools/testing/selftests/bpf/progs/test_snprintf.c b/tools/testing/selftests/bpf/progs/test_snprintf.c
> index e2ad26150f9b..afc2c583125b 100644
> --- a/tools/testing/selftests/bpf/progs/test_snprintf.c
> +++ b/tools/testing/selftests/bpf/progs/test_snprintf.c
> @@ -40,6 +40,7 @@ int handler(const void *ctx)
>         /* Convenient values to pretty-print */
>         const __u8 ex_ipv4[] = {127, 0, 0, 1};
>         const __u8 ex_ipv6[] = {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1};
> +       const __u32 chr1 = 0x64636261; /* dcba */
>         static const char str1[] = "str1";
>         static const char longstr[] = "longstr";
>
> @@ -59,9 +60,9 @@ int handler(const void *ctx)
>         /* Kernel pointers */
>         addr_ret = BPF_SNPRINTF(addr_out, sizeof(addr_out), "%pK %px %p",
>                                 0, 0xFFFF00000ADD4E55, 0xFFFF00000ADD4E55);
> -       /* Strings embedding */
> -       str_ret  = BPF_SNPRINTF(str_out, sizeof(str_out), "%s %+05s",
> -                               str1, longstr);
> +       /* Strings and single-byte character embedding */
> +       str_ret  = BPF_SNPRINTF(str_out, sizeof(str_out), "%s % 9c %+05s",
> +                               str1, chr1, longstr);


Why this hackery with __u32? You are making an endianness assumption
(it will break on big-endian), and you'd never write real code like
that. Just pass 'a', what's wrong with that?

>         /* Overflow */
>         over_ret = BPF_SNPRINTF(over_out, sizeof(over_out), "%%overflow");
>         /* Padding of fixed width numbers */
> --
> 2.30.2
>

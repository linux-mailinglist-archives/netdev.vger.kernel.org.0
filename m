Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 835893EBEC5
	for <lists+netdev@lfdr.de>; Sat, 14 Aug 2021 01:30:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235489AbhHMXbJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Aug 2021 19:31:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48318 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235330AbhHMXbJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 Aug 2021 19:31:09 -0400
Received: from mail-yb1-xb2a.google.com (mail-yb1-xb2a.google.com [IPv6:2607:f8b0:4864:20::b2a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 902F1C061756;
        Fri, 13 Aug 2021 16:30:41 -0700 (PDT)
Received: by mail-yb1-xb2a.google.com with SMTP id z5so21846456ybj.2;
        Fri, 13 Aug 2021 16:30:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=fbF5MrkpdZcrtC+qEDXqiSIRzXw6E9ONxnt1fjH3g3c=;
        b=tFM5k4D+n6Z3fUdxDmEUl7609+nxwRUyfX/bsXhQ0SSv6Kez5y7nAETLdfF+5+Wiow
         CCcaX3SXFISQwE9Hi6SezqIC4oHkDqTb5N5v7VZaByHWERNR3fuTyvmU/E44z8iVzwHk
         BhaI7HMdJ2j3Li5ZpLUBBDAWQH3EPpm0/rt1POcpj9Rx7t7wFhjEKk60gBq7B/ZBIhm2
         DSfv31MeMcwN1jbAcWMLollrDnGsmav9Mke11S9h1WYTgVVsytW17xC+dNTe27VsQMLM
         7EW9iwPVBns+68A7VjDanhqcE00HarrxbwLNI8IFsXoW18gwOilWwvoi0gBOo7EQM8M4
         m1uQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=fbF5MrkpdZcrtC+qEDXqiSIRzXw6E9ONxnt1fjH3g3c=;
        b=WhDMeDMu2dJhbIwGku85CAvHWx3eCPogljZPeRQEA/8u8Z0LMmvUAuVfESKXm0iShD
         3qvV0PchLwD8vklEY02N+JxnPqeXvy3/lvbD44sa4VGmdRqwqs0VfCSSMKvNnTpV1hJU
         Nc5Es8pMntQ879fDoiA/7qAa/bzEtEqmV+IGxDm28ND7NqrwSu9mwE/sFdydtaEtUxK/
         L/NgbzfUk5cZj1xq3gVlAbSjfjOR5/E3J519C6uoab9Njc03tIAS+ZxFNAMEVyXSnrKy
         PM53C8oA0Mnjlhc4HppNJRbCc9eT59rY8JXBlCmXbgG8NrU/YWi0rnZLdcq4phhOJzsO
         FaqQ==
X-Gm-Message-State: AOAM530LyK8/o6lLXWPqk4mJs+NPqgT3XGcEZAWGFyas1Wm5AiWk5c/s
        MBW3HzkFOyziYM1KrqatECNm9JrUQxm310hkF2E=
X-Google-Smtp-Source: ABdhPJwi/hDB8mnYPfUy2EaFZPPmnJqJyMkpTCTeb8P2bLl8X/f9WAL4+6e5RrWksp0ZkD7ZTD0d76gDdyv4436wDJY=
X-Received: by 2002:a25:b21f:: with SMTP id i31mr5862051ybj.403.1628897440789;
 Fri, 13 Aug 2021 16:30:40 -0700 (PDT)
MIME-Version: 1.0
References: <20210812164557.79046-1-kuniyu@amazon.co.jp> <20210812164557.79046-5-kuniyu@amazon.co.jp>
 <CAEf4BzbJC7J9=p9Fh8D7OYPoKMHKg5WyaJUyTkngDcpUhOB_0g@mail.gmail.com>
In-Reply-To: <CAEf4BzbJC7J9=p9Fh8D7OYPoKMHKg5WyaJUyTkngDcpUhOB_0g@mail.gmail.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Fri, 13 Aug 2021 16:30:29 -0700
Message-ID: <CAEf4Bzb-Y5SRrS6VHpBbosUj1QU+76zo29KOJF9-GBoJKaZhCQ@mail.gmail.com>
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

On Fri, Aug 13, 2021 at 4:28 PM Andrii Nakryiko
<andrii.nakryiko@gmail.com> wrote:
>
> On Thu, Aug 12, 2021 at 9:47 AM Kuniyuki Iwashima <kuniyu@amazon.co.jp> wrote:
> >
> > This patch adds a "positive" pattern for "%c", which intentionally uses a
> > __u32 value (0x64636261, "dbca") to print a single character "a".  If the
> > implementation went wrong, other 3 bytes might show up as the part of the
> > latter "%+05s".
> >
> > Also, this patch adds two "negative" patterns for wide character.
> >
> > Signed-off-by: Kuniyuki Iwashima <kuniyu@amazon.co.jp>
> > ---
> >  tools/testing/selftests/bpf/prog_tests/snprintf.c | 4 +++-
> >  tools/testing/selftests/bpf/progs/test_snprintf.c | 7 ++++---
> >  2 files changed, 7 insertions(+), 4 deletions(-)
> >
> > diff --git a/tools/testing/selftests/bpf/prog_tests/snprintf.c b/tools/testing/selftests/bpf/prog_tests/snprintf.c
> > index dffbcaa1ec98..f77d7def7fed 100644
> > --- a/tools/testing/selftests/bpf/prog_tests/snprintf.c
> > +++ b/tools/testing/selftests/bpf/prog_tests/snprintf.c
> > @@ -19,7 +19,7 @@
> >  #define EXP_ADDR_OUT "0000000000000000 ffff00000add4e55 "
> >  #define EXP_ADDR_RET sizeof(EXP_ADDR_OUT "unknownhashedptr")
> >
> > -#define EXP_STR_OUT  "str1 longstr"
> > +#define EXP_STR_OUT  "str1         a longstr"
> >  #define EXP_STR_RET  sizeof(EXP_STR_OUT)
> >
> >  #define EXP_OVER_OUT "%over"
> > @@ -114,6 +114,8 @@ void test_snprintf_negative(void)
> >         ASSERT_ERR(load_single_snprintf("%"), "invalid specifier 3");
> >         ASSERT_ERR(load_single_snprintf("%12345678"), "invalid specifier 4");
> >         ASSERT_ERR(load_single_snprintf("%--------"), "invalid specifier 5");
> > +       ASSERT_ERR(load_single_snprintf("%lc"), "invalid specifier 6");
> > +       ASSERT_ERR(load_single_snprintf("%llc"), "invalid specifier 7");
> >         ASSERT_ERR(load_single_snprintf("\x80"), "non ascii character");
> >         ASSERT_ERR(load_single_snprintf("\x1"), "non printable character");
> >  }
> > diff --git a/tools/testing/selftests/bpf/progs/test_snprintf.c b/tools/testing/selftests/bpf/progs/test_snprintf.c
> > index e2ad26150f9b..afc2c583125b 100644
> > --- a/tools/testing/selftests/bpf/progs/test_snprintf.c
> > +++ b/tools/testing/selftests/bpf/progs/test_snprintf.c
> > @@ -40,6 +40,7 @@ int handler(const void *ctx)
> >         /* Convenient values to pretty-print */
> >         const __u8 ex_ipv4[] = {127, 0, 0, 1};
> >         const __u8 ex_ipv6[] = {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1};
> > +       const __u32 chr1 = 0x64636261; /* dcba */
> >         static const char str1[] = "str1";
> >         static const char longstr[] = "longstr";
> >
> > @@ -59,9 +60,9 @@ int handler(const void *ctx)
> >         /* Kernel pointers */
> >         addr_ret = BPF_SNPRINTF(addr_out, sizeof(addr_out), "%pK %px %p",
> >                                 0, 0xFFFF00000ADD4E55, 0xFFFF00000ADD4E55);
> > -       /* Strings embedding */
> > -       str_ret  = BPF_SNPRINTF(str_out, sizeof(str_out), "%s %+05s",
> > -                               str1, longstr);
> > +       /* Strings and single-byte character embedding */
> > +       str_ret  = BPF_SNPRINTF(str_out, sizeof(str_out), "%s % 9c %+05s",
> > +                               str1, chr1, longstr);

Can you also add tests for %+2c, %-3c, %04c, %0c? Think outside the box ;)

>
>
> Why this hackery with __u32? You are making an endianness assumption
> (it will break on big-endian), and you'd never write real code like
> that. Just pass 'a', what's wrong with that?
>
> >         /* Overflow */
> >         over_ret = BPF_SNPRINTF(over_out, sizeof(over_out), "%%overflow");
> >         /* Padding of fixed width numbers */
> > --
> > 2.30.2
> >

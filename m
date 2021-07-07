Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DB4A63BE18C
	for <lists+netdev@lfdr.de>; Wed,  7 Jul 2021 05:33:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230061AbhGGDfm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Jul 2021 23:35:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35430 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229996AbhGGDfl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Jul 2021 23:35:41 -0400
Received: from mail-yb1-xb31.google.com (mail-yb1-xb31.google.com [IPv6:2607:f8b0:4864:20::b31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5FE54C061574;
        Tue,  6 Jul 2021 20:33:01 -0700 (PDT)
Received: by mail-yb1-xb31.google.com with SMTP id b13so989883ybk.4;
        Tue, 06 Jul 2021 20:33:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=g92ZbK1ZUUXVFmmmcQzp/lkhgyRrPv9oXTWY+NjUb9w=;
        b=s2gNThZdWNI9yJJ8flM3I/ggm2w2ifCtlU8wt3XzvfyQwr8hJV+eSskMe/hYAxyJG+
         QUdOh2YUiO/7cvaPI4lPiRYKkwfoU1udaQ3pfxBfNXSP4knr1GFtn73G9xP27VIINMzt
         BbnRZuJQv5q5UmnOEOjAZJUfmUJTAm+Z+JbOGhPlK8DbBZgx3L0mDnNeOShdoK7elKzO
         IDKVmTx/IXU1cA55J+J70l9X/C4hyg0JNkkQB+mIz0FsxtOpEWLgniDpcEUiep3uvwA4
         mUMqY6l+xlbHElctc1Ek6lZwkvURN9lWRZnTernkvTNVOFAS5xI/DfONQcA5KwBPoY4F
         GtRQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=g92ZbK1ZUUXVFmmmcQzp/lkhgyRrPv9oXTWY+NjUb9w=;
        b=Xd/XjWvxOteKeKNm5Tx1OP/sbK9TEIIdbSpLs8nbJSomcr+50dv6tG9PTWYgMLvCoC
         O/HEH3PtuePlkyMXX2BVL7wi+KvndavnLwdMHI8fey02E0M5Ar2YDG6OAU2Tdb3kE8gq
         cAUqNmQkfIS0bg7ZjzOMefS4Ib9ir8KXi2WWyFa0KZZzfhXALHAzk7RGdDI0XoWrvOYx
         5eiQUvAuRf+qMjim5MrHe1/2Hqd3/i1vwAsGvwKqqR4KRI+McaYcYUHntILq3+En7Vv1
         CiZ/c223qotgcflY/+22pVURKCSUFkiit+SwB9e4HxWV/TJmsU5zc9jfvTXYw5lZKdH/
         dt2A==
X-Gm-Message-State: AOAM530qgwtGCxjnjDF75VrrlWT6hVG7WVJjqwpsPybgfgUaKIoVThpY
        7xhIzI2rqoIXLaR6VnhdPlfV9bKx4OX+B9TJGq4=
X-Google-Smtp-Source: ABdhPJwyB08rQYBfD+/UxmRetBfdpJfNE/S6fWZTwf8uDfbW5S/k9MquVHgSXhNTGxVZhWW0osWSUW9OixoYgfG5pIw=
X-Received: by 2002:a25:b203:: with SMTP id i3mr28907980ybj.260.1625628780470;
 Tue, 06 Jul 2021 20:33:00 -0700 (PDT)
MIME-Version: 1.0
References: <1624092968-5598-1-git-send-email-alan.maguire@oracle.com> <1624092968-5598-3-git-send-email-alan.maguire@oracle.com>
In-Reply-To: <1624092968-5598-3-git-send-email-alan.maguire@oracle.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Tue, 6 Jul 2021 20:32:49 -0700
Message-ID: <CAEf4BzabCuTcA4jPsp+hYboCnr74PptL7hjZtm3HX1j0SJ2YSw@mail.gmail.com>
Subject: Re: [PATCH v5 bpf-next 2/3] selftests/bpf: add ASSERT_STRNEQ()
 variant for test_progs
To:     Alan Maguire <alan.maguire@oracle.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>, Martin Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        john fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        Bill Wendling <morbo@google.com>,
        Shuah Khan <shuah@kernel.org>, bpf <bpf@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>,
        "open list:KERNEL SELFTEST FRAMEWORK" 
        <linux-kselftest@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Jun 19, 2021 at 1:56 AM Alan Maguire <alan.maguire@oracle.com> wrote:
>
> It will support strncmp()-style string comparisons.
>
> Suggested-by: Andrii Nakryiko <andrii.nakryiko@gmail.com>
> Signed-off-by: Alan Maguire <alan.maguire@oracle.com>
> ---
>  tools/testing/selftests/bpf/test_progs.h | 12 ++++++++++++
>  1 file changed, 12 insertions(+)
>
> diff --git a/tools/testing/selftests/bpf/test_progs.h b/tools/testing/selftests/bpf/test_progs.h
> index 8ef7f33..d2944da 100644
> --- a/tools/testing/selftests/bpf/test_progs.h
> +++ b/tools/testing/selftests/bpf/test_progs.h
> @@ -221,6 +221,18 @@ struct test_env {
>         ___ok;                                                          \
>  })
>
> +#define ASSERT_STRNEQ(actual, expected, len, name) ({                  \
> +       static int duration = 0;                                        \
> +       const char *___act = actual;                                    \
> +       const char *___exp = expected;                                  \
> +       size_t ___len = len;                                            \
> +       bool ___ok = strncmp(___act, ___exp, ___len) == 0;              \
> +       CHECK(!___ok, (name),                                           \
> +             "unexpected %s: actual '%s' != expected '%s'\n",          \
> +             (name), ___act, ___exp);                                  \

it would be nice to only emit what we are actually comparing - first n
characters of each string. Luckily, printf is cool enough to support
this:

printf("actual '%.*s' != expected '%.*s'\n", ___len, ___act, ___len, ___exp);

> +       ___ok;                                                          \
> +})
> +
>  #define ASSERT_OK(res, name) ({                                                \
>         static int duration = 0;                                        \
>         long long ___res = (res);                                       \
> --
> 1.8.3.1
>

Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2FE993EBEB7
	for <lists+netdev@lfdr.de>; Sat, 14 Aug 2021 01:26:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235622AbhHMX0c (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Aug 2021 19:26:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47214 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235359AbhHMX0c (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 Aug 2021 19:26:32 -0400
Received: from mail-yb1-xb2b.google.com (mail-yb1-xb2b.google.com [IPv6:2607:f8b0:4864:20::b2b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C4CA3C061756;
        Fri, 13 Aug 2021 16:26:04 -0700 (PDT)
Received: by mail-yb1-xb2b.google.com with SMTP id z128so21742802ybc.10;
        Fri, 13 Aug 2021 16:26:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=rujwDNl9+VoTaeYoegJdQhhxrpVVRtsVkPGdJ2Fbn04=;
        b=HCC0co/jJtGTVHG2Z1EhrCShiVLJSQZ0+oLgQaMYbhlpXx52yJYT1DrK9B4Gh5t6xW
         xuknNt5JblmNDoVg8yTA0e5Qnd2qj9nI+TdB/7G5Bqs17XaZ91C6qQKUiSNtC9pYBSC8
         p6zbuO8v/ZvW5FvW5SYv2vtzlJ/m/6/4gWXdoH+QUNEQVmWLVuSeaxYX8tfTkjPOHzBa
         gShN/1Rn9umQ3V+zZONBFQAJiaQ48Egiqjz2XIQ108YaIhjdBMKqAyfwWlk8ZX4Uq/bh
         vRC1W6gNJb3seIwls6IUryH/NXka1AX95xtxbwDlL0wVFhiW04u1Ca0qWNox5utgcC5Q
         cvog==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=rujwDNl9+VoTaeYoegJdQhhxrpVVRtsVkPGdJ2Fbn04=;
        b=UvYQOIBx/reQcWCv/yqVIF47jYCOSS5L979wlPTlf1Y15hwaZuAfA4dS97ykJAfv3Y
         SZTwTaPfyhw3yojUpzpd3ouAm5pULkWwymeJHbJZEMiK2lB//mm9B08DJ0ZHNQ7ko7Og
         6+Zkgwii6EV464gUm49GWeBDXs88tezySqm47aTlXAGtMo1MIQvxeNfM92CG46WwxWfy
         qNjstZ2I0LFkASI+l4Bbpug+FeEiq2ThCf4OuU6GwrAjElHMl1OzC7HiyjxWcOesrRy8
         6ZUjTZSDLq2JPYVnYVzHU89CAFTIBBevyZA0Q1ra3CoIdi26fPi8m/qhqxIG4rGVeJy5
         hPTQ==
X-Gm-Message-State: AOAM531wDf90rziU5OTqO5SyZP4cTJmUw9bmMtFJrKwfuMVb/5Wm7Cpp
        L4eMNI75UL1Gba5HYeYbMjjpgLslihy03vkyI8E=
X-Google-Smtp-Source: ABdhPJxVMayBFY9t7JRQ0xXYzsjKVE8X3RIbmI8cQPLGBvFd+TZvU+j1Fptra6xDAtPX0E5jO+y01UlZRVQ4k85n1/U=
X-Received: by 2002:a25:4091:: with SMTP id n139mr6031780yba.425.1628897164050;
 Fri, 13 Aug 2021 16:26:04 -0700 (PDT)
MIME-Version: 1.0
References: <20210812164557.79046-1-kuniyu@amazon.co.jp> <20210812164557.79046-4-kuniyu@amazon.co.jp>
In-Reply-To: <20210812164557.79046-4-kuniyu@amazon.co.jp>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Fri, 13 Aug 2021 16:25:53 -0700
Message-ID: <CAEf4BzZ3sVx1m1mOCcPcuVPiY6cWEAO=6VGHDiXEs9ZVD-RoLg@mail.gmail.com>
Subject: Re: [PATCH v5 bpf-next 3/4] selftest/bpf: Implement sample UNIX
 domain socket iterator program.
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

On Thu, Aug 12, 2021 at 9:46 AM Kuniyuki Iwashima <kuniyu@amazon.co.jp> wrote:
>
> The iterator can output almost the same result compared to /proc/net/unix.
> The header line is aligned, and the Inode column uses "%8lu" because "%5lu"
> can be easily overflown.
>
>   # cat /sys/fs/bpf/unix
>   Num               RefCount Protocol Flags    Type St Inode    Path

It's totally my OCD, but why the column name is not aligned with
values? I mean the "Inode" column. It's left aligned, but values
(numbers) are right-aligned? I'd fix that while applying, but I can't
apply due to selftests failures, so please take a look.


>   ffff963c06689800: 00000002 00000000 00010000 0001 01    18697 private/defer
>   ffff963c7c979c00: 00000002 00000000 00000000 0001 01   598245 @Hello@World@
>
>   # cat /proc/net/unix
>   Num       RefCount Protocol Flags    Type St Inode Path
>   ffff963c06689800: 00000002 00000000 00010000 0001 01 18697 private/defer
>   ffff963c7c979c00: 00000002 00000000 00000000 0001 01 598245 @Hello@World@
>
> Note that this prog requires the patch ([0]) for LLVM code gen.  Thanks to
> Yonghong Song for analysing and fixing.
>
> [0] https://reviews.llvm.org/D107483
>
> Signed-off-by: Kuniyuki Iwashima <kuniyu@amazon.co.jp>
> Acked-by: Yonghong Song <yhs@fb.com>
> ---

This selftests breaks test_progs-no_alu32 ([0], the error log is super
long and can freeze browser; it looks like an infinite loop and BPF
verifier just keeps reporting it until it runs out of 1mln
instructions or something). Please check what's going on there, I
can't land it as it is right now.

  [0] https://github.com/kernel-patches/bpf/runs/3326071112?check_suite_focus=true#step:6:124288


>  tools/testing/selftests/bpf/README.rst        | 38 +++++++++
>  .../selftests/bpf/prog_tests/bpf_iter.c       | 16 ++++
>  tools/testing/selftests/bpf/progs/bpf_iter.h  |  8 ++
>  .../selftests/bpf/progs/bpf_iter_unix.c       | 77 +++++++++++++++++++
>  .../selftests/bpf/progs/bpf_tracing_net.h     |  4 +
>  5 files changed, 143 insertions(+)
>  create mode 100644 tools/testing/selftests/bpf/progs/bpf_iter_unix.c
>

[...]

> +                       /* The name of the abstract UNIX domain socket starts
> +                        * with '\0' and can contain '\0'.  The null bytes
> +                        * should be escaped as done in unix_seq_show().
> +                        */
> +                       int i, len;
> +

no_alu32 variant probably isn't happy about using int for this, it
probably does << 32, >> 32 dance and loses track of actual value in
the loop. You can try using u64 instead.

> +                       len = unix_sk->addr->len - sizeof(short);
> +
> +                       BPF_SEQ_PRINTF(seq, " @");
> +
> +                       /* unix_mkname() tests this upper bound. */
> +                       if (len < sizeof(struct sockaddr_un))
> +                               for (i = 1; i < len; i++)

if you move above if inside the loop to break out of the loop, does it
change how Clang generates code?

for (i = 1; i < len i++) {
    if (i >= sizeof(struct sockaddr_un))
        break;
    BPF_SEQ_PRINTF(...);
}


> +                                       BPF_SEQ_PRINTF(seq, "%c",
> +                                                      unix_sk->addr->name->sun_path[i] ?:
> +                                                      '@');
> +               }
> +       }
> +
> +       BPF_SEQ_PRINTF(seq, "\n");
> +
> +       return 0;
> +}
> diff --git a/tools/testing/selftests/bpf/progs/bpf_tracing_net.h b/tools/testing/selftests/bpf/progs/bpf_tracing_net.h
> index 3af0998a0623..eef5646ddb19 100644
> --- a/tools/testing/selftests/bpf/progs/bpf_tracing_net.h
> +++ b/tools/testing/selftests/bpf/progs/bpf_tracing_net.h
> @@ -5,6 +5,10 @@
>  #define AF_INET                        2
>  #define AF_INET6               10
>
> +#define __SO_ACCEPTCON         (1 << 16)
> +#define UNIX_HASH_SIZE         256
> +#define UNIX_ABSTRACT(unix_sk) (unix_sk->addr->hash < UNIX_HASH_SIZE)
> +
>  #define SOL_TCP                        6
>  #define TCP_CONGESTION         13
>  #define TCP_CA_NAME_MAX                16
> --
> 2.30.2
>

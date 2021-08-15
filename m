Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 514353EC7ED
	for <lists+netdev@lfdr.de>; Sun, 15 Aug 2021 09:21:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236394AbhHOHVr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 15 Aug 2021 03:21:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44680 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235569AbhHOHVq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 15 Aug 2021 03:21:46 -0400
Received: from mail-yb1-xb31.google.com (mail-yb1-xb31.google.com [IPv6:2607:f8b0:4864:20::b31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CBB11C061764;
        Sun, 15 Aug 2021 00:21:16 -0700 (PDT)
Received: by mail-yb1-xb31.google.com with SMTP id m193so26870926ybf.9;
        Sun, 15 Aug 2021 00:21:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=0Nr+B6hNhDPVU4pLmSOeqXU9M5M9yLci7yEk8QAoLDM=;
        b=IvqWh3pIITU22GKCJYmRrAWAEjT2wE/3eypDI52cSmK6nXUHwnu/3HfJbqohKJyJPf
         BjP5fbMNnu4mPSY2sawyZERTqf3y+FT3wzqDCkwb50qNlg21hI92C1xh5Q3O25gZgOyO
         VPlvi5iw0sgLYkNa2+QS7M/PjAp3sWA7/fAwJTX/+17zG8fSB25NFKic1zj+bmbMdpHg
         uSKtsgNFPfuWukohFZjBteWkS2pv1Yq42K5g+X/B8ZRqQyQSBwIditrgCwXZikxlBDcg
         YRv37jvtO+4wb9vgw43zwXMpadPlWPXZbTIcbFfo5rLJ36FlrG7JbbZJQuI3SDBtEn+L
         0wBg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=0Nr+B6hNhDPVU4pLmSOeqXU9M5M9yLci7yEk8QAoLDM=;
        b=Bu4OPs1INtG7vwafhuPc3hwrZt4DVefhYlqmLALK9J9gS5MafwIURr3ZI/VQagcbu0
         OWFQxDXPXlMYFK6LUCIiFLhyq6b5bHg1dC6t5C98ZZ0Z7XbzMlqYYJhJZ0cgdQABVMY2
         03I+lCcQ5QUjRB2jqth8ZGCvxnEo9m3ErSQCPele16pSgOBNKurNjJDFnaA1QP3p/n0C
         XKHsP5wl6UsEVXoyU7pIYatOCEbiPVsGvHIV9Xma/PjHMPR4/b4bqVv3pNwssjpYgxLw
         o6lM2GB4zg+vHTGyPnQQojsDAFndXPJ1g203OCRg416R7JUejsqOWjC0Uf9gpLVcB/jB
         endQ==
X-Gm-Message-State: AOAM532K8ZoY+DTdv4F3fGQ57aqHTettnS6GSBvvR1SSGmay/KhKeNdz
        W4+WvLDALjtk+B0yqGUcptS2OR9jug2g55Cgc2Y=
X-Google-Smtp-Source: ABdhPJzMgjVI+t1GBKUEvlkLyKroUZMq1qV3OXOwkM5pRfo3PY9oDt/r+zPnI8S77ztWfLrDNbdUYf6BQcIpzouEYKc=
X-Received: by 2002:a25:4091:: with SMTP id n139mr13372649yba.425.1629012076026;
 Sun, 15 Aug 2021 00:21:16 -0700 (PDT)
MIME-Version: 1.0
References: <20210814015718.42704-1-kuniyu@amazon.co.jp> <20210814015718.42704-4-kuniyu@amazon.co.jp>
In-Reply-To: <20210814015718.42704-4-kuniyu@amazon.co.jp>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Sun, 15 Aug 2021 00:21:04 -0700
Message-ID: <CAEf4BzaRmSbkeS9=aSh3yJeMeGv4Eo31MzE8WWLRD-aAa9N5Fw@mail.gmail.com>
Subject: Re: [PATCH v6 bpf-next 3/4] selftest/bpf: Implement sample UNIX
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

On Fri, Aug 13, 2021 at 6:58 PM Kuniyuki Iwashima <kuniyu@amazon.co.jp> wrote:
>
> The iterator can output almost the same result compared to /proc/net/unix.
> The header line is aligned, and the Inode column uses "%8lu" because "%5lu"
> can be easily overflown.
>
>   # cat /sys/fs/bpf/unix
>   Num               RefCount Protocol Flags    Type St    Inode Path
>   ffff963c06689800: 00000002 00000000 00010000 0001 01    18697 private/defer
>   ffff963c7c979c00: 00000002 00000000 00000000 0001 01   598245 @Hello@World@
>
>   # cat /proc/net/unix
>   Num       RefCount Protocol Flags    Type St Inode Path
>   ffff963c06689800: 00000002 00000000 00010000 0001 01 18697 private/defer
>   ffff963c7c979c00: 00000002 00000000 00000000 0001 01 598245 @Hello@World@
>
> Signed-off-by: Kuniyuki Iwashima <kuniyu@amazon.co.jp>
> Acked-by: Yonghong Song <yhs@fb.com>
> ---
>  .../selftests/bpf/prog_tests/bpf_iter.c       | 16 ++++
>  tools/testing/selftests/bpf/progs/bpf_iter.h  |  8 ++
>  .../selftests/bpf/progs/bpf_iter_unix.c       | 80 +++++++++++++++++++
>  .../selftests/bpf/progs/bpf_tracing_net.h     |  4 +
>  4 files changed, 108 insertions(+)
>  create mode 100644 tools/testing/selftests/bpf/progs/bpf_iter_unix.c

[...]

> +       if (unix_sk->addr) {
> +               if (!UNIX_ABSTRACT(unix_sk)) {
> +                       BPF_SEQ_PRINTF(seq, " %s", unix_sk->addr->name->sun_path);
> +               } else {
> +                       /* The name of the abstract UNIX domain socket starts
> +                        * with '\0' and can contain '\0'.  The null bytes
> +                        * should be escaped as done in unix_seq_show().
> +                        */
> +                       __u64 i, len;
> +
> +                       len = unix_sk->addr->len - sizeof(short);
> +
> +                       BPF_SEQ_PRINTF(seq, " @");
> +
> +                       for (i = 1; i < len; i++) {
> +                               /* unix_mkname() tests this upper bound. */
> +                               if (len >= sizeof(struct sockaddr_un))

I've changed this to (i >= sizeof(...)) which made more sense to me
than checking len multiple times. Both test_progs and
test_progs-no_alu32 passed on my local slightly older clang which
doesn't yet have Yonghong's fix, so I hope I didn't regress anything.

Applied to bpf-next.

> +                                       break;
> +
> +                               BPF_SEQ_PRINTF(seq, "%c",
> +                                              unix_sk->addr->name->sun_path[i] ?:
> +                                              '@');
> +                       }
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

Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F1DF53DBF11
	for <lists+netdev@lfdr.de>; Fri, 30 Jul 2021 21:34:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231214AbhG3TfA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 30 Jul 2021 15:35:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36272 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230402AbhG3TfA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 30 Jul 2021 15:35:00 -0400
Received: from mail-yb1-xb33.google.com (mail-yb1-xb33.google.com [IPv6:2607:f8b0:4864:20::b33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 06CB8C06175F;
        Fri, 30 Jul 2021 12:34:55 -0700 (PDT)
Received: by mail-yb1-xb33.google.com with SMTP id z18so2890347ybg.8;
        Fri, 30 Jul 2021 12:34:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=V8MdH2wjB2JpyJVI9OK1vdjPEtNwyNdoxYpO8ivKZ14=;
        b=R6/h7MSSK4R1jU4gCvs62G379ZLLsXfUNGRROXQW5mMUpFHU5wOT7MncIPXoGPLuEk
         HTFJuCA6UipscRKE521weYz0OqQ/UA4EixQ8bZUPe9foQLRn4C57gKR/GOZ5dYxWTxcq
         tCLBlsRniCMUL2lRFiRQL83DjBzpFWM/d/5OwPruUpWunfvPtwpBkhChJoZEffKrctcz
         GTc6lLkECYl/zgkK0GY9n4u+9KFwpPc6ffXuQym4AL8Yua9EYRNGppQabixchdc7rm+O
         9xScwqIKLBTxCH6UX+PGszeDLraYnLhrUHDfFk0yJVDYa2vJFy/j+DPF9YlhxDOHeSWy
         nc9A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=V8MdH2wjB2JpyJVI9OK1vdjPEtNwyNdoxYpO8ivKZ14=;
        b=ppLkJuGXuN8Y/JC9LuNXA1JxI82oTPSvLY0LkDNxOQ6OOfpIxQ28RhEpGcPmfR7tzR
         mcBuqVWqmAYTKv5eFyZSy1XV+xOyBuxmYomy9KwlADmTYFGvUTjRCWMBCX+ZGp5oBhRJ
         iEuvVq4Aw4VmJfVeNPjykiLo033kh89+IjbRdfD9AChFWVvPsfHGMmHSlnyINh6v/SSf
         AfRlipRHT7pTaLO2JqbrSO38zPLswBJ+OrAF5dC87QmfIB/Fdb0VInmQRT6zMH9NjEaz
         GgeSWbO8dbUFE42ED9V9/1pye1MWNT74XhookJABzphHzXewhsyQJzfVWtE46ai6tT7l
         rhZw==
X-Gm-Message-State: AOAM533D8B9IMe8qTTMWTVclXduw+EDfoDxF7yTOAmmggrUL6BlC/APH
        5oahBseKO3HXrfstNNui5aWJSkKGV4il4yIqh5s=
X-Google-Smtp-Source: ABdhPJx5cxr6mK/AozEPsCN3m4aeAUmhtz2oCJBwapQ2GAL4VQac5FuD3kH5u0rNQQUJ0Yqceo+x3EN08Yly5QnweNk=
X-Received: by 2002:a25:cdc7:: with SMTP id d190mr5157604ybf.425.1627673694256;
 Fri, 30 Jul 2021 12:34:54 -0700 (PDT)
MIME-Version: 1.0
References: <20210729233645.4869-1-kuniyu@amazon.co.jp> <20210729233645.4869-3-kuniyu@amazon.co.jp>
In-Reply-To: <20210729233645.4869-3-kuniyu@amazon.co.jp>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Fri, 30 Jul 2021 12:34:43 -0700
Message-ID: <CAEf4Bza6ac8B+PCHm9=-v4LpYW2E++dd1ur91MwHMjjcQS++wA@mail.gmail.com>
Subject: Re: [PATCH bpf-next 2/2] selftest/bpf: Implement sample UNIX domain
 socket iterator program.
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

On Thu, Jul 29, 2021 at 4:37 PM Kuniyuki Iwashima <kuniyu@amazon.co.jp> wrote:
>
> If there are no abstract sockets, this prog can output the same result
> compared to /proc/net/unix.
>
>   # cat /sys/fs/bpf/unix | head -n 2
>   Num       RefCount Protocol Flags    Type St Inode Path
>   ffff9ab7122db000: 00000002 00000000 00010000 0001 01 10623 private/defer
>
>   # cat /proc/net/unix | head -n 2
>   Num       RefCount Protocol Flags    Type St Inode Path
>   ffff9ab7122db000: 00000002 00000000 00010000 0001 01 10623 private/defer
>
> Signed-off-by: Kuniyuki Iwashima <kuniyu@amazon.co.jp>
> ---
>  .../selftests/bpf/prog_tests/bpf_iter.c       | 17 +++++
>  .../selftests/bpf/progs/bpf_iter_unix.c       | 75 +++++++++++++++++++
>  2 files changed, 92 insertions(+)
>  create mode 100644 tools/testing/selftests/bpf/progs/bpf_iter_unix.c
>
> diff --git a/tools/testing/selftests/bpf/prog_tests/bpf_iter.c b/tools/testing/selftests/bpf/prog_tests/bpf_iter.c
> index 1f1aade56504..4746bac68d36 100644
> --- a/tools/testing/selftests/bpf/prog_tests/bpf_iter.c
> +++ b/tools/testing/selftests/bpf/prog_tests/bpf_iter.c
> @@ -13,6 +13,7 @@
>  #include "bpf_iter_tcp6.skel.h"
>  #include "bpf_iter_udp4.skel.h"
>  #include "bpf_iter_udp6.skel.h"
> +#include "bpf_iter_unix.skel.h"
>  #include "bpf_iter_test_kern1.skel.h"
>  #include "bpf_iter_test_kern2.skel.h"
>  #include "bpf_iter_test_kern3.skel.h"
> @@ -313,6 +314,20 @@ static void test_udp6(void)
>         bpf_iter_udp6__destroy(skel);
>  }
>
> +static void test_unix(void)
> +{
> +       struct bpf_iter_unix *skel;
> +
> +       skel = bpf_iter_unix__open_and_load();
> +       if (CHECK(!skel, "bpf_iter_unix__open_and_load",

please use new ASSERT_PTR_OK() macro instead

> +                 "skeleton open_and_load failed\n"))
> +               return;
> +
> +       do_dummy_read(skel->progs.dump_unix);
> +
> +       bpf_iter_unix__destroy(skel);
> +}
> +
>  /* The expected string is less than 16 bytes */
>  static int do_read_with_fd(int iter_fd, const char *expected,
>                            bool read_one_char)
> @@ -1255,6 +1270,8 @@ void test_bpf_iter(void)
>                 test_udp4();
>         if (test__start_subtest("udp6"))
>                 test_udp6();
> +       if (test__start_subtest("unix"))
> +               test_unix();
>         if (test__start_subtest("anon"))
>                 test_anon_iter(false);
>         if (test__start_subtest("anon-read-one-char"))
> diff --git a/tools/testing/selftests/bpf/progs/bpf_iter_unix.c b/tools/testing/selftests/bpf/progs/bpf_iter_unix.c
> new file mode 100644
> index 000000000000..285ec2f7944d
> --- /dev/null
> +++ b/tools/testing/selftests/bpf/progs/bpf_iter_unix.c
> @@ -0,0 +1,75 @@
> +// SPDX-License-Identifier: GPL-2.0
> +/* Copyright Amazon.com Inc. or its affiliates. */
> +#include "bpf_iter.h"
> +#include "bpf_tracing_net.h"
> +#include <bpf/bpf_helpers.h>
> +#include <bpf/bpf_endian.h>
> +
> +char _license[] SEC("license") = "GPL";
> +
> +#define __SO_ACCEPTCON         (1 << 16)
> +#define UNIX_HASH_SIZE         256
> +#define UNIX_ABSTRACT(unix_sk) (unix_sk->addr->hash < UNIX_HASH_SIZE)
> +
> +static long sock_i_ino(const struct sock *sk)
> +{
> +       const struct socket *sk_socket = sk->sk_socket;
> +       const struct inode *inode;
> +       unsigned long ino;
> +
> +       if (!sk_socket)
> +               return 0;
> +
> +       inode = &container_of(sk_socket, struct socket_alloc, socket)->vfs_inode;
> +       bpf_probe_read_kernel(&ino, sizeof(ino), &inode->i_ino);
> +       return ino;
> +}
> +
> +SEC("iter/unix")
> +int dump_unix(struct bpf_iter__unix *ctx)
> +{
> +       struct unix_sock *unix_sk = ctx->unix_sk;
> +       struct sock *sk = (struct sock *)unix_sk;
> +       struct seq_file *seq;
> +       __u32 seq_num;
> +
> +       if (!unix_sk)
> +               return 0;
> +
> +       seq = ctx->meta->seq;
> +       seq_num = ctx->meta->seq_num;
> +       if (seq_num == 0)
> +               BPF_SEQ_PRINTF(seq, "Num       RefCount Protocol Flags    "
> +                              "Type St Inode Path\n");
> +
> +       BPF_SEQ_PRINTF(seq, "%pK: %08X %08X %08X %04X %02X %5lu",
> +                      unix_sk,
> +                      sk->sk_refcnt.refs.counter,
> +                      0,
> +                      sk->sk_state == TCP_LISTEN ? __SO_ACCEPTCON : 0,
> +                      sk->sk_type,
> +                      sk->sk_socket ?
> +                      (sk->sk_state == TCP_ESTABLISHED ?
> +                       SS_CONNECTED : SS_UNCONNECTED) :
> +                      (sk->sk_state == TCP_ESTABLISHED ?
> +                       SS_CONNECTING : SS_DISCONNECTING),

nit: I'd keep these ternary operators on a single line for
readability. Same for header PRINTF above.

> +                      sock_i_ino(sk));
> +
> +       if (unix_sk->addr) {
> +               if (UNIX_ABSTRACT(unix_sk))
> +                       /* Abstract UNIX domain socket can contain '\0' in
> +                        * the path, and it should be escaped.  However, it
> +                        * requires loops and the BPF verifier rejects it.
> +                        * So here, print only the escaped first byte to
> +                        * indicate it is an abstract UNIX domain socket.
> +                        * (See: unix_seq_show() and commit e7947ea770d0d)
> +                        */
> +                       BPF_SEQ_PRINTF(seq, " @");
> +               else
> +                       BPF_SEQ_PRINTF(seq, " %s", unix_sk->addr->name->sun_path);
> +       }
> +
> +       BPF_SEQ_PRINTF(seq, "\n");
> +
> +       return 0;
> +}
> --
> 2.30.2
>

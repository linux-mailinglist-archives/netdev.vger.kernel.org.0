Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8DD743E321F
	for <lists+netdev@lfdr.de>; Sat,  7 Aug 2021 01:33:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243821AbhHFXdx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 Aug 2021 19:33:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39488 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230280AbhHFXdv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 6 Aug 2021 19:33:51 -0400
Received: from mail-yb1-xb2a.google.com (mail-yb1-xb2a.google.com [IPv6:2607:f8b0:4864:20::b2a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6AA28C0613CF;
        Fri,  6 Aug 2021 16:33:34 -0700 (PDT)
Received: by mail-yb1-xb2a.google.com with SMTP id b133so17999146ybg.4;
        Fri, 06 Aug 2021 16:33:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=GLysGwlhVupj9Iq83Z/Qr14gxM2ZKx5u1meyvn7qPyI=;
        b=tcc3PSEXPhVtBFXi/lRMizcdq+y7SU9mpBE6LQCYS6Jb2DTxezGjR/Rvw6I/2lvFjs
         GXBxqvngM5n5iE3JjfMbQaZfDC7bH2wci1jZ70YRom5nsMzoeicBjAocWwwjJXypg1L9
         7+Bri+Fk05h6nc8pZTu9NV/jGT9teWa7OBif7J2+H6ZMWUgUm1xKfDK9cgxrW/6m+VRh
         GPd7QUvhISmVsMBoxznnhJlSlCHCGmP/ft+GtHlFN2tlBAuZxuWTHLBIG3VZH6WlZtg9
         8mCuWRsgOd5cy4yHoWyj/2eVWBDK75DAzFEC2kfmAPECKzG3ESHo2+knpiAVvwIr1ZkZ
         FWhw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=GLysGwlhVupj9Iq83Z/Qr14gxM2ZKx5u1meyvn7qPyI=;
        b=SKkMCLX4UlwkcmGBjySm8r4Qnz0WE0m0ntnz+aAg9BeSSFGGjTkvuf68q7cJ9OQ5ZK
         3m/3+xdDKIzQZpoPWV1uJEoL5XfAKKd+GrsYmM1JmDyv05PvrBgaTSOYsDmxhPOHUDh/
         w5wvhJAw/CG2hpPFoG7H71eyWsXmkKOMcYscfJxBwbiI1wce5qza6TjdaEkL/FJL1gZY
         4Y1ZJ/C8xNbAkvPM1xqORCRQ6QlRy0ckfdJkjFAGTpZfTCbULUffPjR9XsrL9KYgAicZ
         SE0eNPK5fsXaIqoCW+c/EHc8Qc46OpYcFinXyPQuM13BfA0NZlgUJ2PdTEehFjhY2kQ9
         8YVg==
X-Gm-Message-State: AOAM533vu2YoNXofTfo7Q22V9pw2YnhYnyax1sZo+/KgsnUK3fk0T8zV
        cmx1FlwUzPXBy4Mpwj0IAR3wdBeiZwVgnOEMTPM=
X-Google-Smtp-Source: ABdhPJztnzvcmzMIjLFLwVw5c4BtK8W8vqV0q03/Zju5vaGb2xIftXyAycTco14gQL6HuP61Br+a41nUCIaACvTTVXg=
X-Received: by 2002:a25:2901:: with SMTP id p1mr16027995ybp.459.1628292813573;
 Fri, 06 Aug 2021 16:33:33 -0700 (PDT)
MIME-Version: 1.0
References: <20210804070851.97834-1-kuniyu@amazon.co.jp> <20210804070851.97834-3-kuniyu@amazon.co.jp>
In-Reply-To: <20210804070851.97834-3-kuniyu@amazon.co.jp>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Fri, 6 Aug 2021 16:33:22 -0700
Message-ID: <CAEf4BzaqH1sZM-ZH-C3bkCDCDNL0tYm4_2XGpqYRt33RdBOmhg@mail.gmail.com>
Subject: Re: [PATCH v3 bpf-next 2/2] selftest/bpf: Implement sample UNIX
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

On Wed, Aug 4, 2021 at 12:09 AM Kuniyuki Iwashima <kuniyu@amazon.co.jp> wrote:
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
> According to the analysis by Yonghong Song (See the link), the BPF verifier
> cannot load the code in the comment to print the name of the abstract UNIX
> domain socket due to LLVM optimisation.  It can be uncommented once the
> LLVM code gen is improved.
>
> Link: https://lore.kernel.org/netdev/1994df05-8f01-371f-3c3b-d33d7836878c@fb.com/

Our patchworks tooling, used to apply patches, is using Link: tag to
record original discussion, so this will be quite confusing if you use
the same "Link: " for referencing relevant discussions. Please use
standard link reference syntax:

According to the analysis by Yonghong Song ([0]), ...

...

  [0] https://lore.kernel.org/netdev/1994df05-8f01-371f-3c3b-d33d7836878c@fb.com/


> Signed-off-by: Kuniyuki Iwashima <kuniyu@amazon.co.jp>
> ---
>  .../selftests/bpf/prog_tests/bpf_iter.c       | 16 ++++
>  tools/testing/selftests/bpf/progs/bpf_iter.h  |  8 ++
>  .../selftests/bpf/progs/bpf_iter_unix.c       | 86 +++++++++++++++++++
>  .../selftests/bpf/progs/bpf_tracing_net.h     |  4 +
>  4 files changed, 114 insertions(+)
>  create mode 100644 tools/testing/selftests/bpf/progs/bpf_iter_unix.c
>

[...]

> diff --git a/tools/testing/selftests/bpf/progs/bpf_iter.h b/tools/testing/selftests/bpf/progs/bpf_iter.h
> index 3d83b185c4bc..d92648621bcb 100644
> --- a/tools/testing/selftests/bpf/progs/bpf_iter.h
> +++ b/tools/testing/selftests/bpf/progs/bpf_iter.h
> @@ -12,6 +12,7 @@
>  #define tcp6_sock tcp6_sock___not_used
>  #define bpf_iter__udp bpf_iter__udp___not_used
>  #define udp6_sock udp6_sock___not_used
> +#define bpf_iter__unix bpf_iter__unix___not_used
>  #define bpf_iter__bpf_map_elem bpf_iter__bpf_map_elem___not_used
>  #define bpf_iter__bpf_sk_storage_map bpf_iter__bpf_sk_storage_map___not_used
>  #define bpf_iter__sockmap bpf_iter__sockmap___not_used
> @@ -32,6 +33,7 @@
>  #undef tcp6_sock
>  #undef bpf_iter__udp
>  #undef udp6_sock
> +#undef bpf_iter__unix
>  #undef bpf_iter__bpf_map_elem
>  #undef bpf_iter__bpf_sk_storage_map
>  #undef bpf_iter__sockmap
> @@ -103,6 +105,12 @@ struct udp6_sock {
>         struct ipv6_pinfo inet6;
>  } __attribute__((preserve_access_index));
>
> +struct bpf_iter__unix {
> +       struct bpf_iter_meta *meta;
> +       struct unix_sock *unix_sk;
> +       uid_t uid __attribute__((aligned(8)));

just fyi, aligned doesn't matter here, CO-RE will relocate offsets
appropriately anyways

> +} __attribute__((preserve_access_index));
> +
>  struct bpf_iter__bpf_map_elem {
>         struct bpf_iter_meta *meta;
>         struct bpf_map *map;

[...]

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

nit: please keep format strings on a single line

> +
> +       BPF_SEQ_PRINTF(seq, "%pK: %08X %08X %08X %04X %02X %5lu",
> +                      unix_sk,
> +                      sk->sk_refcnt.refs.counter,
> +                      0,
> +                      sk->sk_state == TCP_LISTEN ? __SO_ACCEPTCON : 0,
> +                      sk->sk_type,
> +                      sk->sk_socket ?
> +                      (sk->sk_state == TCP_ESTABLISHED ? SS_CONNECTED : SS_UNCONNECTED) :
> +                      (sk->sk_state == TCP_ESTABLISHED ? SS_CONNECTING : SS_DISCONNECTING),
> +                      sock_i_ino(sk));
> +

[...]

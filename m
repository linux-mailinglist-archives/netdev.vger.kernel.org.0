Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E423629D71
	for <lists+netdev@lfdr.de>; Fri, 24 May 2019 19:48:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391065AbfEXRsR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 May 2019 13:48:17 -0400
Received: from mail-it1-f195.google.com ([209.85.166.195]:38938 "EHLO
        mail-it1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726079AbfEXRsR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 May 2019 13:48:17 -0400
Received: by mail-it1-f195.google.com with SMTP id 9so15012782itf.4;
        Fri, 24 May 2019 10:48:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=z8Zfkq0Xkri+HQ7egNBjraELwTs9KKa4UccJfXqDOF0=;
        b=UvPczUelcGv2D2UmwRKcGNhh4d9WAsWuweYLkVdKV80HXgKz3wLr/9KVMnLb9PcFNN
         /aXqKmafLVBMwOfDs/ybxZUEMIygKlxnGv8DJbxHKw4YqGkf32/qM0/XFYt3n6kGCTEd
         Vv0Gjp0ETqRqqb3axc1J0YN1HbCPd0GPbAxHP4nKCixVpnJ0MtRoDM6imEan4waXpD4P
         CJ9WI665qd/Lgq3XQ1DKKGqhRQ4rXAOnLMRdgzibRahPBnYvmAnrVUrQpTbwSxDE2bdH
         ubNomg4+r1dOp/xCFzf14b1HODYf1i5L1EQaU2MVfluXI5q7CCNquWb6iIV3WG9bAc75
         0KfQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=z8Zfkq0Xkri+HQ7egNBjraELwTs9KKa4UccJfXqDOF0=;
        b=CcLjDnwigIyWY7bj3E5krr5QMbzUVnLUQeyvf26Qld9QvJv8nKb7OrFfjQHirLd8cz
         MRs5soHqQz+X/0E7k0W3HDc8w3jqTfjD2gkYxJNO5UKtXUf7oP8Q/utkg1NylAZVSIBJ
         8KeM3RnWi58zxoQM8b11egqMekAlnWq/v1P5ZeYxeJfbtKikNr+1h67Bx6LvDkNvauci
         avv44ydblrnSvqJ+uNuQmRLPA4ERfOw+LT2blIVn0H4wmU7R8vjMA72u0zYAAttlNBHR
         gCUH6Z9ppn4eQmzbsa1P4e+KvdgHI8SOr78lJUG0lfBzW0Xxgy1SWhmNZmm1OLTVuwqv
         RtOQ==
X-Gm-Message-State: APjAAAVaH5CTgPke0yoiQ17OI6NRFJLR3qzYAJknT5cxXiUxrMcdxGVK
        QuxdtBBHz0uvpUopV778NTUqM64EuYlEpgJFAXc=
X-Google-Smtp-Source: APXvYqwlrSrxc0IgkyQcO9Wd+lqq7LeER5YMFgnTsbKALZV6W3lE8EaBKQX1/CFPVzefERUauMRgPlaLgxPFFmd670w=
X-Received: by 2002:a24:e4b:: with SMTP id 72mr19889019ite.142.1558720096249;
 Fri, 24 May 2019 10:48:16 -0700 (PDT)
MIME-Version: 1.0
References: <20190524155931.7946-1-iago@kinvolk.io> <20190524155931.7946-2-iago@kinvolk.io>
In-Reply-To: <20190524155931.7946-2-iago@kinvolk.io>
From:   Y Song <ys114321@gmail.com>
Date:   Fri, 24 May 2019 10:47:39 -0700
Message-ID: <CAH3MdRU72b2-XXKPToCV922W3fRsmSWb12rUCNqaJjC3=5ZTng@mail.gmail.com>
Subject: Re: [PATCH bpf-next v4 1/4] bpf: sock ops: add netns ino and dev in
 bpf context
To:     =?UTF-8?Q?Iago_L=C3=B3pez_Galeiras?= <iago@kinvolk.io>
Cc:     John Fastabend <john.fastabend@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Alban Crequy <alban@kinvolk.io>, krzesimir@kinvolk.io,
        bpf <bpf@vger.kernel.org>, netdev <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, May 24, 2019 at 9:01 AM Iago L=C3=B3pez Galeiras <iago@kinvolk.io> =
wrote:
>
> From: Alban Crequy <alban@kinvolk.io>
>
> sockops programs can now access the network namespace inode and device
> via (struct bpf_sock_ops)->netns_ino and ->netns_dev. This can be useful
> to apply different policies on different network namespaces.
>
> In the unlikely case where network namespaces are not compiled in
> (CONFIG_NET_NS=3Dn), the verifier will return netns_dev as usual and will
> return 0 for netns_ino.
>
> The generated BPF bytecode for netns_ino is loading the correct inode
> number at the time of execution.
>
> However, the generated BPF bytecode for netns_dev is loading an
> immediate value determined at BPF-load-time by looking at the initial
> network namespace. In practice, this works because all netns currently
> use the same virtual device. If this was to change, this code would need
> to be updated too.
>
> Co-authored-by: Iago L=C3=B3pez Galeiras <iago@kinvolk.io>
> Signed-off-by: Alban Crequy <alban@kinvolk.io>
> Signed-off-by: Iago L=C3=B3pez Galeiras <iago@kinvolk.io>
>
> ---
>
> Changes since v1:
> - add netns_dev (review from Alexei)
>
> Changes since v2:
> - replace __u64 by u64 in kernel code (review from Y Song)
> - remove unneeded #else branch: program would be rejected in
>   is_valid_access (review from Y Song)
> - allow partial reads (<u64) (review from Y Song)
>
> Changes since v3:
> - return netns_dev unconditionally and set netns_ino to 0 if
>   CONFIG_NET_NS is not enabled (review from Jakub Kicinski)
> - use bpf_ctx_record_field_size and bpf_ctx_narrow_access_ok instead of
>   manually deal with partial reads (review from Y Song)
> - update commit message to reflect new code and remove note about
>   partial reads since it was discussed in the review
> - use bpf_ctx_range() and offsetofend()
> ---
>  include/uapi/linux/bpf.h |  2 ++
>  net/core/filter.c        | 70 ++++++++++++++++++++++++++++++++++++++++
>  2 files changed, 72 insertions(+)
>
> diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
> index 63e0cf66f01a..e64066a09a5f 100644
> --- a/include/uapi/linux/bpf.h
> +++ b/include/uapi/linux/bpf.h
> @@ -3261,6 +3261,8 @@ struct bpf_sock_ops {
>         __u32 sk_txhash;
>         __u64 bytes_received;
>         __u64 bytes_acked;
> +       __u64 netns_dev;
> +       __u64 netns_ino;
>  };
>
>  /* Definitions for bpf_sock_ops_cb_flags */
> diff --git a/net/core/filter.c b/net/core/filter.c
> index 55bfc941d17a..2b1552a8dd74 100644
> --- a/net/core/filter.c
> +++ b/net/core/filter.c
> @@ -76,6 +76,8 @@
>  #include <net/lwtunnel.h>
>  #include <net/ipv6_stubs.h>
>  #include <net/bpf_sk_storage.h>
> +#include <linux/kdev_t.h>
> +#include <linux/proc_ns.h>
>
>  /**
>   *     sk_filter_trim_cap - run a packet through a socket filter
> @@ -6822,6 +6824,18 @@ static bool sock_ops_is_valid_access(int off, int =
size,
>                 }
>         } else {
>                 switch (off) {
> +               case bpf_ctx_range(struct bpf_sock_ops, netns_dev):
> +                       if (off >=3D offsetofend(struct bpf_sock_ops, net=
ns_dev))
> +                               return false;

This is not needed.
#define bpf_ctx_range(TYPE, MEMBER)
         \
        offsetof(TYPE, MEMBER) ... offsetofend(TYPE, MEMBER) - 1
off should never be >=3D offsetofend(struct bpf_sock_ops, netns_dev).

> +
> +                       bpf_ctx_record_field_size(info, sizeof(u64));
> +                       if (!bpf_ctx_narrow_access_ok(off, size, sizeof(u=
64)))
> +                               return false;
> +                       break;
> +               case offsetof(struct bpf_sock_ops, netns_ino):
> +                       if (size !=3D sizeof(u64))
> +                               return false;
> +                       break;
>                 case bpf_ctx_range_till(struct bpf_sock_ops, bytes_receiv=
ed,
>                                         bytes_acked):
>                         if (size !=3D sizeof(__u64))
> @@ -7739,6 +7753,11 @@ static u32 sock_addr_convert_ctx_access(enum bpf_a=
ccess_type type,
>         return insn - insn_buf;
>  }
>
> +static struct ns_common *sockops_netns_cb(void *private_data)
> +{
> +       return &init_net.ns;
> +}
> +
>  static u32 sock_ops_convert_ctx_access(enum bpf_access_type type,
>                                        const struct bpf_insn *si,
>                                        struct bpf_insn *insn_buf,
> @@ -7747,6 +7766,10 @@ static u32 sock_ops_convert_ctx_access(enum bpf_ac=
cess_type type,
>  {
>         struct bpf_insn *insn =3D insn_buf;
>         int off;
> +       struct inode *ns_inode;
> +       struct path ns_path;
> +       u64 netns_dev;
> +       void *res;
>
>  /* Helper macro for adding read access to tcp_sock or sock fields. */
>  #define SOCK_OPS_GET_FIELD(BPF_FIELD, OBJ_FIELD, OBJ)                   =
     \
> @@ -7993,6 +8016,53 @@ static u32 sock_ops_convert_ctx_access(enum bpf_ac=
cess_type type,
>                 SOCK_OPS_GET_OR_SET_FIELD(sk_txhash, sk_txhash,
>                                           struct sock, type);
>                 break;
> +
> +       case bpf_ctx_range(struct bpf_sock_ops, netns_dev):
> +               /* We get the netns_dev at BPF-load-time and not at
> +                * BPF-exec-time. We assume that netns_dev is a constant.
> +                */
> +               res =3D ns_get_path_cb(&ns_path, sockops_netns_cb, NULL);
> +               if (IS_ERR(res)) {
> +                       netns_dev =3D 0;

What is the proper way to handle error here?
If we indeed get an error and netns_dev =3D 0, do this mean bpf program
should check netns_dev =3D=3D 0 and special case it? Or since this is reall=
y
a lower probability thing we can set to 0 and bpf program's logic does not
need to specialize this one.

At least, maybe we need a little documentation for the field in uapi header
to point out this potential caveat?

> +               } else {
> +                       ns_inode =3D ns_path.dentry->d_inode;
> +                       netns_dev =3D new_encode_dev(ns_inode->i_sb->s_de=
v);
> +               }
> +               *target_size =3D 8;
> +               *insn++ =3D BPF_MOV64_IMM(si->dst_reg, netns_dev);
> +               break;
> +
> +       case offsetof(struct bpf_sock_ops, netns_ino):
> +#ifdef CONFIG_NET_NS
> +               /* Loading: sk_ops->sk->__sk_common.skc_net.net->ns.inum
> +                * Type: (struct bpf_sock_ops_kern *)
> +                *       ->(struct sock *)
> +                *       ->(struct sock_common)
> +                *       .possible_net_t
> +                *       .(struct net *)
> +                *       ->(struct ns_common)
> +                *       .(unsigned int)
> +                */
> +               BUILD_BUG_ON(offsetof(struct sock, __sk_common) !=3D 0);
> +               BUILD_BUG_ON(offsetof(possible_net_t, net) !=3D 0);
> +               *insn++ =3D BPF_LDX_MEM(BPF_FIELD_SIZEOF(
> +                                               struct bpf_sock_ops_kern,=
 sk),
> +                                     si->dst_reg, si->src_reg,
> +                                     offsetof(struct bpf_sock_ops_kern, =
sk));
> +               *insn++ =3D BPF_LDX_MEM(BPF_FIELD_SIZEOF(
> +                                               possible_net_t, net),
> +                                     si->dst_reg, si->dst_reg,
> +                                     offsetof(struct sock_common, skc_ne=
t));
> +               *insn++ =3D BPF_LDX_MEM(BPF_FIELD_SIZEOF(
> +                                               struct ns_common, inum),
> +                                     si->dst_reg, si->dst_reg,
> +                                     offsetof(struct net, ns) +
> +                                     offsetof(struct ns_common, inum));
> +#else
> +               *insn++ =3D BPF_MOV64_IMM(si->dst_reg, 0);
> +#endif
> +               break;
> +
>         }
>         return insn - insn_buf;
>  }
> --
> 2.21.0
>

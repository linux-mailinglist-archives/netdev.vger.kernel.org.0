Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BA86631017
	for <lists+netdev@lfdr.de>; Fri, 31 May 2019 16:25:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726616AbfEaOYy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 31 May 2019 10:24:54 -0400
Received: from mail-lf1-f68.google.com ([209.85.167.68]:40106 "EHLO
        mail-lf1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726531AbfEaOYx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 31 May 2019 10:24:53 -0400
Received: by mail-lf1-f68.google.com with SMTP id a9so6650668lff.7
        for <netdev@vger.kernel.org>; Fri, 31 May 2019 07:24:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kinvolk.io; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=QIFTqlspE/r0DEruCD4DATm01uaqKkNSOTeIdqXCCHU=;
        b=CBQuXNNHE2f4EuWoG9Ch3bMq8576ALClYblADDd6k9DGuFWma33U2JgUlnIe/vTy/a
         t81C/gpRw5DdID43oRPTQhhTYWwWvTntKIdU2OtZN4i44z/SGdxZ4wrGwpRJJOtcKQy9
         wZLfzSmtfNku/dXjhg5JbxuTaUxql77Uwvhf4=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=QIFTqlspE/r0DEruCD4DATm01uaqKkNSOTeIdqXCCHU=;
        b=q1bABDwbLGqyIeoDBOcK5581S9wrP/fgDy+IxoowG9lq9O9iBCk6LRLBx6PKmI+Y/1
         3e6w/Z3sl30aCravLWrYB1TBUq6x3genqDjNQlKzqJUJJoGK4TwOFjeIcTNwcMsN4CUu
         /lPQinNG3mEjOxWc15wYpTvNDEP8vlx9VuKksEQMwOIP3JkyeShuH0WaPxhI2kotR29G
         fqJRSE4Xw0o7M9Q0ExuL3GWcdvvzlwjaYCwvQuZ4gAd4B31KH9yM7PbtivaUjN6JtnUF
         KyTw+8rMeU5MRo/9KW6ii9cE7GDYenCq1zPeLmkqufFoQdMEqRxciz0qRvF6MKy9+FMZ
         Eu7Q==
X-Gm-Message-State: APjAAAVBA+eazhM+Zfw7hR/hqumPaVl8ppKCgxx4sapBLz5cKu5R+bs9
        aqKtweh2x+uXrw6RqX0qaaqWdy/RaNjGqgTauLu1sg==
X-Google-Smtp-Source: APXvYqzvhw/97C0QWRETiuQokDnEgD/UNSngrvmnLcTYSND7CD9WQnx5Xr980b4BFSboAnitLBxkAb5WMMokjqS9crk=
X-Received: by 2002:ac2:4d17:: with SMTP id r23mr212585lfi.130.1559312690587;
 Fri, 31 May 2019 07:24:50 -0700 (PDT)
MIME-Version: 1.0
References: <20190524155931.7946-1-iago@kinvolk.io> <20190524155931.7946-2-iago@kinvolk.io>
 <CAH3MdRU72b2-XXKPToCV922W3fRsmSWb12rUCNqaJjC3=5ZTng@mail.gmail.com>
In-Reply-To: <CAH3MdRU72b2-XXKPToCV922W3fRsmSWb12rUCNqaJjC3=5ZTng@mail.gmail.com>
From:   =?UTF-8?Q?Iago_L=C3=B3pez_Galeiras?= <iago@kinvolk.io>
Date:   Fri, 31 May 2019 16:24:23 +0200
Message-ID: <CALxOrhxH7H8VK-ukJvPGMcx663wbSsQ9gWBf4dyUKcp9+hqzxw@mail.gmail.com>
Subject: Re: [PATCH bpf-next v4 1/4] bpf: sock ops: add netns ino and dev in
 bpf context
To:     Y Song <ys114321@gmail.com>
Cc:     John Fastabend <john.fastabend@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Alban Crequy <alban@kinvolk.io>,
        Krzesimir Nowak <krzesimir@kinvolk.io>,
        bpf <bpf@vger.kernel.org>, netdev <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, May 24, 2019 at 7:48 PM Y Song <ys114321@gmail.com> wrote:
>
> On Fri, May 24, 2019 at 9:01 AM Iago L=C3=B3pez Galeiras <iago@kinvolk.io=
> wrote:
> >
> > From: Alban Crequy <alban@kinvolk.io>
> >
> > sockops programs can now access the network namespace inode and device
> > via (struct bpf_sock_ops)->netns_ino and ->netns_dev. This can be usefu=
l
> > to apply different policies on different network namespaces.
> >
> > In the unlikely case where network namespaces are not compiled in
> > (CONFIG_NET_NS=3Dn), the verifier will return netns_dev as usual and wi=
ll
> > return 0 for netns_ino.
> >
> > The generated BPF bytecode for netns_ino is loading the correct inode
> > number at the time of execution.
> >
> > However, the generated BPF bytecode for netns_dev is loading an
> > immediate value determined at BPF-load-time by looking at the initial
> > network namespace. In practice, this works because all netns currently
> > use the same virtual device. If this was to change, this code would nee=
d
> > to be updated too.
> >
> > Co-authored-by: Iago L=C3=B3pez Galeiras <iago@kinvolk.io>
> > Signed-off-by: Alban Crequy <alban@kinvolk.io>
> > Signed-off-by: Iago L=C3=B3pez Galeiras <iago@kinvolk.io>
> >
> > ---
> >
> > Changes since v1:
> > - add netns_dev (review from Alexei)
> >
> > Changes since v2:
> > - replace __u64 by u64 in kernel code (review from Y Song)
> > - remove unneeded #else branch: program would be rejected in
> >   is_valid_access (review from Y Song)
> > - allow partial reads (<u64) (review from Y Song)
> >
> > Changes since v3:
> > - return netns_dev unconditionally and set netns_ino to 0 if
> >   CONFIG_NET_NS is not enabled (review from Jakub Kicinski)
> > - use bpf_ctx_record_field_size and bpf_ctx_narrow_access_ok instead of
> >   manually deal with partial reads (review from Y Song)
> > - update commit message to reflect new code and remove note about
> >   partial reads since it was discussed in the review
> > - use bpf_ctx_range() and offsetofend()
> > ---
> >  include/uapi/linux/bpf.h |  2 ++
> >  net/core/filter.c        | 70 ++++++++++++++++++++++++++++++++++++++++
> >  2 files changed, 72 insertions(+)
> >
> > diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
> > index 63e0cf66f01a..e64066a09a5f 100644
> > --- a/include/uapi/linux/bpf.h
> > +++ b/include/uapi/linux/bpf.h
> > @@ -3261,6 +3261,8 @@ struct bpf_sock_ops {
> >         __u32 sk_txhash;
> >         __u64 bytes_received;
> >         __u64 bytes_acked;
> > +       __u64 netns_dev;
> > +       __u64 netns_ino;
> >  };
> >
> >  /* Definitions for bpf_sock_ops_cb_flags */
> > diff --git a/net/core/filter.c b/net/core/filter.c
> > index 55bfc941d17a..2b1552a8dd74 100644
> > --- a/net/core/filter.c
> > +++ b/net/core/filter.c
> > @@ -76,6 +76,8 @@
> >  #include <net/lwtunnel.h>
> >  #include <net/ipv6_stubs.h>
> >  #include <net/bpf_sk_storage.h>
> > +#include <linux/kdev_t.h>
> > +#include <linux/proc_ns.h>
> >
> >  /**
> >   *     sk_filter_trim_cap - run a packet through a socket filter
> > @@ -6822,6 +6824,18 @@ static bool sock_ops_is_valid_access(int off, in=
t size,
> >                 }
> >         } else {
> >                 switch (off) {
> > +               case bpf_ctx_range(struct bpf_sock_ops, netns_dev):
> > +                       if (off >=3D offsetofend(struct bpf_sock_ops, n=
etns_dev))
> > +                               return false;
>
> This is not needed.
> #define bpf_ctx_range(TYPE, MEMBER)
>          \
>         offsetof(TYPE, MEMBER) ... offsetofend(TYPE, MEMBER) - 1
> off should never be >=3D offsetofend(struct bpf_sock_ops, netns_dev).
>

Right, I'll remove it.

> > +
> > +                       bpf_ctx_record_field_size(info, sizeof(u64));
> > +                       if (!bpf_ctx_narrow_access_ok(off, size, sizeof=
(u64)))
> > +                               return false;
> > +                       break;
> > +               case offsetof(struct bpf_sock_ops, netns_ino):
> > +                       if (size !=3D sizeof(u64))
> > +                               return false;
> > +                       break;
> >                 case bpf_ctx_range_till(struct bpf_sock_ops, bytes_rece=
ived,
> >                                         bytes_acked):
> >                         if (size !=3D sizeof(__u64))
> > @@ -7739,6 +7753,11 @@ static u32 sock_addr_convert_ctx_access(enum bpf=
_access_type type,
> >         return insn - insn_buf;
> >  }
> >
> > +static struct ns_common *sockops_netns_cb(void *private_data)
> > +{
> > +       return &init_net.ns;
> > +}
> > +
> >  static u32 sock_ops_convert_ctx_access(enum bpf_access_type type,
> >                                        const struct bpf_insn *si,
> >                                        struct bpf_insn *insn_buf,
> > @@ -7747,6 +7766,10 @@ static u32 sock_ops_convert_ctx_access(enum bpf_=
access_type type,
> >  {
> >         struct bpf_insn *insn =3D insn_buf;
> >         int off;
> > +       struct inode *ns_inode;
> > +       struct path ns_path;
> > +       u64 netns_dev;
> > +       void *res;
> >
> >  /* Helper macro for adding read access to tcp_sock or sock fields. */
> >  #define SOCK_OPS_GET_FIELD(BPF_FIELD, OBJ_FIELD, OBJ)                 =
       \
> > @@ -7993,6 +8016,53 @@ static u32 sock_ops_convert_ctx_access(enum bpf_=
access_type type,
> >                 SOCK_OPS_GET_OR_SET_FIELD(sk_txhash, sk_txhash,
> >                                           struct sock, type);
> >                 break;
> > +
> > +       case bpf_ctx_range(struct bpf_sock_ops, netns_dev):
> > +               /* We get the netns_dev at BPF-load-time and not at
> > +                * BPF-exec-time. We assume that netns_dev is a constan=
t.
> > +                */
> > +               res =3D ns_get_path_cb(&ns_path, sockops_netns_cb, NULL=
);
> > +               if (IS_ERR(res)) {
> > +                       netns_dev =3D 0;
>
> What is the proper way to handle error here?
> If we indeed get an error and netns_dev =3D 0, do this mean bpf program
> should check netns_dev =3D=3D 0 and special case it? Or since this is rea=
lly
> a lower probability thing we can set to 0 and bpf program's logic does no=
t
> need to specialize this one.
>
> At least, maybe we need a little documentation for the field in uapi head=
er
> to point out this potential caveat?
>

As far as I can tell, this function can only error with ENOMEM when allocat=
ing
a new inode or dentry, which is very unlikely. I don't think bpf programs
should check for this. Also, for sockops programs worst case is usually tha=
t
the connection goes through the usual networking stack so it shouldn't be
dangerous.

I can add a comment like this to the field in the uapi header file:

    ...
    /*
     * netns_dev might be zero if there's an error getting it
     * when loading the BPF program. This is very unlikely.
     */
    __u64 netns_dev;
    ...

What do you think?




> > +               } else {
> > +                       ns_inode =3D ns_path.dentry->d_inode;
> > +                       netns_dev =3D new_encode_dev(ns_inode->i_sb->s_=
dev);
> > +               }
> > +               *target_size =3D 8;
> > +               *insn++ =3D BPF_MOV64_IMM(si->dst_reg, netns_dev);
> > +               break;
> > +
> > +       case offsetof(struct bpf_sock_ops, netns_ino):
> > +#ifdef CONFIG_NET_NS
> > +               /* Loading: sk_ops->sk->__sk_common.skc_net.net->ns.inu=
m
> > +                * Type: (struct bpf_sock_ops_kern *)
> > +                *       ->(struct sock *)
> > +                *       ->(struct sock_common)
> > +                *       .possible_net_t
> > +                *       .(struct net *)
> > +                *       ->(struct ns_common)
> > +                *       .(unsigned int)
> > +                */
> > +               BUILD_BUG_ON(offsetof(struct sock, __sk_common) !=3D 0)=
;
> > +               BUILD_BUG_ON(offsetof(possible_net_t, net) !=3D 0);
> > +               *insn++ =3D BPF_LDX_MEM(BPF_FIELD_SIZEOF(
> > +                                               struct bpf_sock_ops_ker=
n, sk),
> > +                                     si->dst_reg, si->src_reg,
> > +                                     offsetof(struct bpf_sock_ops_kern=
, sk));
> > +               *insn++ =3D BPF_LDX_MEM(BPF_FIELD_SIZEOF(
> > +                                               possible_net_t, net),
> > +                                     si->dst_reg, si->dst_reg,
> > +                                     offsetof(struct sock_common, skc_=
net));
> > +               *insn++ =3D BPF_LDX_MEM(BPF_FIELD_SIZEOF(
> > +                                               struct ns_common, inum)=
,
> > +                                     si->dst_reg, si->dst_reg,
> > +                                     offsetof(struct net, ns) +
> > +                                     offsetof(struct ns_common, inum))=
;
> > +#else
> > +               *insn++ =3D BPF_MOV64_IMM(si->dst_reg, 0);
> > +#endif
> > +               break;
> > +
> >         }
> >         return insn - insn_buf;
> >  }
> > --
> > 2.21.0
> >



--
Iago L=C3=B3pez Galeiras

Kinvolk GmbH | Adalbertstr. 6a, 10999 Berlin
Gesch=C3=A4ftsf=C3=BChrer/Directors: Alban Crequy, Chris K=C3=BChl, Iago L=
=C3=B3pez Galeiras
Registergericht/Court of registration: Amtsgericht Charlottenburg
Registernummer/Registration number: HRB 171414 B
Ust-ID-Nummer/VAT ID number: DE302207000

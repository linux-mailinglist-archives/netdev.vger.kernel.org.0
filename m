Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 03068E69D
	for <lists+netdev@lfdr.de>; Mon, 29 Apr 2019 17:35:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728629AbfD2PfD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Apr 2019 11:35:03 -0400
Received: from mail-oi1-f195.google.com ([209.85.167.195]:41679 "EHLO
        mail-oi1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728546AbfD2PfB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Apr 2019 11:35:01 -0400
Received: by mail-oi1-f195.google.com with SMTP id v23so8479649oif.8
        for <netdev@vger.kernel.org>; Mon, 29 Apr 2019 08:35:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kinvolk.io; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=NCmEesKQZll6z8qms+OpZ8kCs6Eb9bECUhGbIFGCjHY=;
        b=FQ9o14EdK9BE4hJyTRxHvBjI8WUQ9YLVspWY6yiOcsEhTAmKZSm8uIv1GgtotklAmu
         lrFPviWMOAXoBKUTmNzyIwoL8cVHH5TQxVxXWMrrmWPQDbYRNGMQlGfpWH7ngFq2HOln
         Mo7fCW6RVSce0XqXcqFdEkBIeVrDQj8IhTBW0=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=NCmEesKQZll6z8qms+OpZ8kCs6Eb9bECUhGbIFGCjHY=;
        b=VH/ZneCk3WxekuglxJegqqD5MgZVGC4t5Ru+Rrf2KJZTm1KYKzSXA5Ogs0xEJqzb9Z
         URmVni691y6A7aYRIVJpdcs7Yki5pYuRcdusHn3ZTiA/s2KWBNN0Gylgi3gHIlZt837P
         4sq+D2NZwtHonhvIuOMwBP1xUD1UnpVbbomYBe6Ig1KsCPdEdZfDGRsdpbqdfMY3sC32
         7EdkohZYwIMzW7IYHosdpSAkDAjlQVu/Fmy4ldTDDl4hRrssm1VOflGtA3rkTOjq7F8/
         lxhAjVG2dG9VL4ELBcb2arHkSRWMuWm/dzBxz+TmHJxrWaRgSAAMvtzXyR0vYWLmV+7k
         tp9Q==
X-Gm-Message-State: APjAAAWJ/KbNu8vWVgSKsusNp+xSQJnXhC4QekYE7iO9suytfy5G0ZKx
        iqyUoscMJwktcw7yn9KkNYerwaBdoUlnQmtp+gQk8Q==
X-Google-Smtp-Source: APXvYqxjAGhcRBlWXEqyEs3QV3IHzccHauIUWfnwvaaIE/CDiE6g1L2U/eHYbqjkZXPfJd9TzBI4S1GWgXTfwMtpXIc=
X-Received: by 2002:aca:540a:: with SMTP id i10mr3317988oib.54.1556552099454;
 Mon, 29 Apr 2019 08:34:59 -0700 (PDT)
MIME-Version: 1.0
References: <20190426154848.23490-1-alban@kinvolk.io> <CAH3MdRViqmPWm9UaOEO3ZKa5AodL7AGZ4Bb0FzyDcoqRoDmqNw@mail.gmail.com>
In-Reply-To: <CAH3MdRViqmPWm9UaOEO3ZKa5AodL7AGZ4Bb0FzyDcoqRoDmqNw@mail.gmail.com>
From:   Alban Crequy <alban@kinvolk.io>
Date:   Mon, 29 Apr 2019 17:34:47 +0200
Message-ID: <CADZs7q4rmRinZPMGVAnS95hA-prjdx7igFmaO=K_du13LsPm7g@mail.gmail.com>
Subject: Re: [PATCH bpf-next v3 1/4] bpf: sock ops: add netns ino and dev in
 bpf context
To:     Y Song <ys114321@gmail.com>
Cc:     Alban Crequy <alban.crequy@gmail.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        bpf <bpf@vger.kernel.org>, netdev <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        =?UTF-8?Q?Iago_L=C3=B3pez_Galeiras?= <iago@kinvolk.io>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Apr 27, 2019 at 6:35 PM Y Song <ys114321@gmail.com> wrote:
>
> On Fri, Apr 26, 2019 at 8:50 AM Alban Crequy <alban.crequy@gmail.com> wrote:
> >
> > From: Alban Crequy <alban@kinvolk.io>
> >
> > sockops programs can now access the network namespace inode and device
> > via (struct bpf_sock_ops)->netns_ino and ->netns_dev. This can be useful
> > to apply different policies on different network namespaces.
> >
> > In the unlikely case where network namespaces are not compiled in
> > (CONFIG_NET_NS=n), the verifier will not allow access to ->netns_*.
> >
> > The generated BPF bytecode for netns_ino is loading the correct inode
> > number at the time of execution.
> >
> > However, the generated BPF bytecode for netns_dev is loading an
> > immediate value determined at BPF-load-time by looking at the initial
> > network namespace. In practice, this works because all netns currently
> > use the same virtual device. If this was to change, this code would need
> > to be updated too.
> >
> > Signed-off-by: Alban Crequy <alban@kinvolk.io>
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
> >   Note: I have not been able to fully test partial reads on netns_dev.
> > The following patches check partial reads in the verifier but it does
> > not actually execute the program to check if partial reads generate the
> > correct value. I tried to write a BPF program in C and declare the
> > struct bpf_sock_ops as a volatile variable and I could get llvm to
> > generate the BPF instructions to do partial loads. But then, I get the
> > verifier error "dereference of modified ctx ptr R2 off=184 disallowed",
> > explained in https://www.spinics.net/lists/netdev/msg531582.html
> > What do you think should be done here?
>
> You added partial read tests in test_verifier with raw asm codes.
> It should be good enough.
>
> For the compiler generated code causing verifier error, will take
> a detailed look later.

Thanks! To clarify my note: the patches I sent on the mailing list
don't generate a verifier error.

It only errors out when I try partial reads in C. You can see the code
of the failed attempt that generate the error here:
https://github.com/kinvolk/linux/blob/c5fe70990c897a866c7006a0068876b0fde9ee4d/tools/testing/selftests/bpf/test_sockmap_kern.h#L146-L176

So if the partial read tests in test_verifier with raw asm codes are
good enough, there is no need to investigate more on that.

> Also I did not see a cover letter. For a series with 4 patches, it would be
> the best if you can provide a separate cover letter.

Ok, I will do that for the next iteration.

> > ---
> >  include/uapi/linux/bpf.h |  2 +
> >  net/core/filter.c        | 94 ++++++++++++++++++++++++++++++++++++++++
> >  2 files changed, 96 insertions(+)
> >
> > diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
> > index eaf2d3284248..f4f841dde42c 100644
> > --- a/include/uapi/linux/bpf.h
> > +++ b/include/uapi/linux/bpf.h
> > @@ -3213,6 +3213,8 @@ struct bpf_sock_ops {
> >         __u32 sk_txhash;
> >         __u64 bytes_received;
> >         __u64 bytes_acked;
> > +       __u64 netns_dev;
> > +       __u64 netns_ino;
> >  };
> >
> >  /* Definitions for bpf_sock_ops_cb_flags */
> > diff --git a/net/core/filter.c b/net/core/filter.c
> > index 2f88baf39cc2..9c77464b1501 100644
> > --- a/net/core/filter.c
> > +++ b/net/core/filter.c
> > @@ -75,6 +75,8 @@
> >  #include <net/seg6_local.h>
> >  #include <net/lwtunnel.h>
> >  #include <net/ipv6_stubs.h>
> > +#include <linux/kdev_t.h>
> > +#include <linux/proc_ns.h>
> >
> >  /**
> >   *     sk_filter_trim_cap - run a packet through a socket filter
> > @@ -6810,6 +6812,24 @@ static bool sock_ops_is_valid_access(int off, int size,
> >                 }
> >         } else {
> >                 switch (off) {
> > +               case offsetof(struct bpf_sock_ops, netns_dev) ...
> > +                    offsetof(struct bpf_sock_ops, netns_dev) + sizeof(u64) - 1:
> > +#ifdef CONFIG_NET_NS
> > +                       if (off - offsetof(struct bpf_sock_ops, netns_dev)
> > +                           + size > sizeof(u64))
>
> This will allow something off = 1, size = 4. This is not what we want as
> the access is not properly aligned.

sock_ops_is_valid_access() does not allow off = 1, size = 4. There is
this check at the beginning of the function:
        if (off % size != 0)
                return false;

> You can look at function bpf_skb_is_valid_access(), esp. the two lines below:
>           bpf_ctx_record_field_size(info, size_default);
>            if (!bpf_ctx_narrow_access_ok(off, size, size_default))
>                    return false;

Thanks for the pointer! I now see that if I use them, my code in
sock_ops_convert_ctx_access() can be simplified.

> > +                               return false;
> > +#else
> > +                       return false;
> > +#endif
> > +                       break;
> > +               case offsetof(struct bpf_sock_ops, netns_ino):
> > +#ifdef CONFIG_NET_NS
> > +                       if (size != sizeof(u64))
> > +                               return false;
> > +#else
> > +                       return false;
> > +#endif
> > +                       break;
> >                 case bpf_ctx_range_till(struct bpf_sock_ops, bytes_received,
> >                                         bytes_acked):
> >                         if (size != sizeof(__u64))
> > @@ -7727,6 +7747,11 @@ static u32 sock_addr_convert_ctx_access(enum bpf_access_type type,
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
> > @@ -7735,6 +7760,10 @@ static u32 sock_ops_convert_ctx_access(enum bpf_access_type type,
> >  {
> >         struct bpf_insn *insn = insn_buf;
> >         int off;
> > +       struct inode *ns_inode;
> > +       struct path ns_path;
> > +       u64 netns_dev;
> > +       void *res;
> >
> >  /* Helper macro for adding read access to tcp_sock or sock fields. */
> >  #define SOCK_OPS_GET_FIELD(BPF_FIELD, OBJ_FIELD, OBJ)                        \
> > @@ -7981,6 +8010,71 @@ static u32 sock_ops_convert_ctx_access(enum bpf_access_type type,
> >                 SOCK_OPS_GET_OR_SET_FIELD(sk_txhash, sk_txhash,
> >                                           struct sock, type);
> >                 break;
> > +
> > +       case offsetof(struct bpf_sock_ops, netns_dev) ...
> > +            offsetof(struct bpf_sock_ops, netns_dev) + sizeof(u64) - 1:
> > +#ifdef CONFIG_NET_NS
> > +               /* We get the netns_dev at BPF-load-time and not at
> > +                * BPF-exec-time. We assume that netns_dev is a constant.
> > +                */
> > +               res = ns_get_path_cb(&ns_path, sockops_netns_cb, NULL);
> > +               if (IS_ERR(res)) {
> > +                       netns_dev = 0;
> > +               } else {
> > +                       ns_inode = ns_path.dentry->d_inode;
> > +                       netns_dev = new_encode_dev(ns_inode->i_sb->s_dev);
> > +               }
> > +               off = si->off;
> > +               off -= offsetof(struct bpf_sock_ops, netns_dev);
> > +               switch (BPF_LDST_BYTES(si)) {
> > +               case sizeof(u64):
> > +                       *insn++ = BPF_MOV64_IMM(si->dst_reg, netns_dev);
> > +                       break;
> > +               case sizeof(u32):
> > +                       netns_dev = *(u32 *)(((char *)&netns_dev) + off);
> > +                       *insn++ = BPF_MOV32_IMM(si->dst_reg, netns_dev);
> > +                       break;
> > +               case sizeof(u16):
> > +                       netns_dev = *(u16 *)(((char *)&netns_dev) + off);
> > +                       *insn++ = BPF_MOV32_IMM(si->dst_reg, netns_dev);
> > +                       break;
> > +               case sizeof(u8):
> > +                       netns_dev = *(u8 *)(((char *)&netns_dev) + off);
> > +                       *insn++ = BPF_MOV32_IMM(si->dst_reg, netns_dev);
> > +                       break;
> > +               }
> > +#endif
> > +               break;
> > +
> > +       case offsetof(struct bpf_sock_ops, netns_ino):
> > +#ifdef CONFIG_NET_NS
> > +               /* Loading: sk_ops->sk->__sk_common.skc_net.net->ns.inum
> > +                * Type: (struct bpf_sock_ops_kern *)
> > +                *       ->(struct sock *)
> > +                *       ->(struct sock_common)
> > +                *       .possible_net_t
> > +                *       .(struct net *)
> > +                *       ->(struct ns_common)
> > +                *       .(unsigned int)
> > +                */
> > +               BUILD_BUG_ON(offsetof(struct sock, __sk_common) != 0);
> > +               BUILD_BUG_ON(offsetof(possible_net_t, net) != 0);
> > +               *insn++ = BPF_LDX_MEM(BPF_FIELD_SIZEOF(
> > +                                               struct bpf_sock_ops_kern, sk),
> > +                                     si->dst_reg, si->src_reg,
> > +                                     offsetof(struct bpf_sock_ops_kern, sk));
> > +               *insn++ = BPF_LDX_MEM(BPF_FIELD_SIZEOF(
> > +                                               possible_net_t, net),
> > +                                     si->dst_reg, si->dst_reg,
> > +                                     offsetof(struct sock_common, skc_net));
> > +               *insn++ = BPF_LDX_MEM(BPF_FIELD_SIZEOF(
> > +                                               struct ns_common, inum),
> > +                                     si->dst_reg, si->dst_reg,
> > +                                     offsetof(struct net, ns) +
> > +                                     offsetof(struct ns_common, inum));
> > +#endif
> > +               break;
> > +
> >         }
> >         return insn - insn_buf;
> >  }
> > --
> > 2.20.1
> >

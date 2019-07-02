Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 21AF05C653
	for <lists+netdev@lfdr.de>; Tue,  2 Jul 2019 02:32:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727028AbfGBAb6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Jul 2019 20:31:58 -0400
Received: from mail-pf1-f194.google.com ([209.85.210.194]:39205 "EHLO
        mail-pf1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726866AbfGBAb6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 Jul 2019 20:31:58 -0400
Received: by mail-pf1-f194.google.com with SMTP id j2so7348572pfe.6
        for <netdev@vger.kernel.org>; Mon, 01 Jul 2019 17:31:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fomichev-me.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=EWG9D9Z1nsPT0YVF0HcZk/r7kC+7lwO/rqB586b/trk=;
        b=YFNaPcMYk/l5tRAYWxrkr0av7YJgasS9t4M1tytaS0SPRxKRV6Bcmub9KkLn/Tdkbr
         7XGrlDSbfKhm6nHBDVs89NKWsTP8MxJ9YLL+5IYbmXAYQvXVVPcQgkCfXnLk9UO3q+Yc
         N+CiAkLHWGkOExfuPzVtn3Vgc7dkZ8uBURor27VPbMAdBla2u1KY//85wWPj1EOpqQ6R
         Q/cAh5GJ3rXa2nNLfEgT9pumq9BH67i+OgHaMgJx7V9iGPSlMAm1gcIEzDGyefi2PeuD
         dP8cVbtVQK59lgzyTnGK/24myB3MH/YBiitjGzFRtTDdrgBq1Qmhbglj9hUewYzQ2028
         okuA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=EWG9D9Z1nsPT0YVF0HcZk/r7kC+7lwO/rqB586b/trk=;
        b=bYqKRchCUdQdwX9JQx4jPPFpbrCv1EFDm7tVCZtIj8xHs3L2cBvOIKBQ4KQ7RmrCro
         7+7wx1NQBXnFe+lambhQhbAqXXfPujnxQgpDWBTt35wz/LHDr37X98ZgmrDLgWFfUFui
         aT0YAWITNiTwoMfsX8iG8KeBgv31zRTGGo0Ab+QoV9p85AK6ouUfHjyeR/GYIQDuSOtf
         8GPICSBAUuBM8M6iLDPv+IG8viMrrDFBeeWkK/9GyIsmBFo3OI3l0IcFeQ9BJr9UbZb3
         uXfTssggHquOQbxkyARXHR+ysbEpOWvZtBz7iDyeDkwD6HHXwfU5XCi5Fz9YwlX+GyWP
         Eg/A==
X-Gm-Message-State: APjAAAXOXTY0E+X3Nh8tHsJEqGoCecF7skOM90i8fVvbgi5My4bhOLn2
        5rKtBjBgUqrS10s79JMruzgH1g==
X-Google-Smtp-Source: APXvYqx9MEWf0FlC2lSmxm6Hquxa/UOYWWQVGr18lFmZ00tfwxuqJ9fR/mWxlKHIJUVxfaxn2K3fCA==
X-Received: by 2002:a17:90a:228b:: with SMTP id s11mr2209184pjc.23.1562027517225;
        Mon, 01 Jul 2019 17:31:57 -0700 (PDT)
Received: from localhost ([2601:646:8f00:18d9:d0fa:7a4b:764f:de48])
        by smtp.gmail.com with ESMTPSA id n5sm16344470pgd.26.2019.07.01.17.31.56
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Mon, 01 Jul 2019 17:31:56 -0700 (PDT)
Date:   Mon, 1 Jul 2019 17:31:56 -0700
From:   Stanislav Fomichev <sdf@fomichev.me>
To:     Y Song <ys114321@gmail.com>
Cc:     Stanislav Fomichev <sdf@google.com>,
        netdev <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        David Miller <davem@davemloft.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Eric Dumazet <edumazet@google.com>,
        Priyaranjan Jha <priyarjha@google.com>,
        Yuchung Cheng <ycheng@google.com>,
        Soheil Hassas Yeganeh <soheil@google.com>
Subject: Re: [PATCH bpf-next 7/8] samples/bpf: add sample program that
 periodically dumps TCP stats
Message-ID: <20190702003156.GI6757@mini-arch>
References: <20190701204821.44230-1-sdf@google.com>
 <20190701204821.44230-8-sdf@google.com>
 <CAH3MdRX+utr3w1gC537ui7nLOZ+b8yrSKeO3CMuszXG5sGg3NA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAH3MdRX+utr3w1gC537ui7nLOZ+b8yrSKeO3CMuszXG5sGg3NA@mail.gmail.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 07/01, Y Song wrote:
> On Mon, Jul 1, 2019 at 1:49 PM Stanislav Fomichev <sdf@google.com> wrote:
> >
> > Uses new RTT callback to dump stats every second.
> >
> > $ mkdir -p /tmp/cgroupv2
> > $ mount -t cgroup2 none /tmp/cgroupv2
> > $ mkdir -p /tmp/cgroupv2/foo
> > $ echo $$ >> /tmp/cgroupv2/foo/cgroup.procs
> > $ bpftool prog load ./tcp_dumpstats_kern.o /sys/fs/bpf/tcp_prog
> > $ bpftool cgroup attach /tmp/cgroupv2/foo sock_ops pinned /sys/fs/bpf/tcp_prog
> > $ bpftool prog tracelog
> > $ # run neper/netperf/etc
> >
> > Used neper to compare performance with and without this program attached
> > and didn't see any noticeable performance impact.
> >
> > Sample output:
> >   <idle>-0     [015] ..s.  2074.128800: 0: dsack_dups=0 delivered=242526
> >   <idle>-0     [015] ..s.  2074.128808: 0: delivered_ce=0 icsk_retransmits=0
> >   <idle>-0     [015] ..s.  2075.130133: 0: dsack_dups=0 delivered=323599
> >   <idle>-0     [015] ..s.  2075.130138: 0: delivered_ce=0 icsk_retransmits=0
> >   <idle>-0     [005] .Ns.  2076.131440: 0: dsack_dups=0 delivered=404648
> >   <idle>-0     [005] .Ns.  2076.131447: 0: delivered_ce=0 icsk_retransmits=0
> >
> > Cc: Eric Dumazet <edumazet@google.com>
> > Cc: Priyaranjan Jha <priyarjha@google.com>
> > Cc: Yuchung Cheng <ycheng@google.com>
> > Cc: Soheil Hassas Yeganeh <soheil@google.com>
> > Signed-off-by: Stanislav Fomichev <sdf@google.com>
> > ---
> >  samples/bpf/Makefile             |  1 +
> >  samples/bpf/tcp_dumpstats_kern.c | 65 ++++++++++++++++++++++++++++++++
> >  2 files changed, 66 insertions(+)
> >  create mode 100644 samples/bpf/tcp_dumpstats_kern.c
> 
> Currently, the bpf program into the repo. If we do not have another
> script to use
> this program for testing, the instructions in the commit message should be
> added to the bpf program as comments so people know what to do with this file
> without going through git commit message.
> 
> Is it possible to create a script to run with this bpf program?
There is a general instruction in samples/bpf/tcp_bpf.readme
with bpftool examples/etc. Should I just a comment at the top
of the BPF program to point people to that .readme file instead?

> >
> > diff --git a/samples/bpf/Makefile b/samples/bpf/Makefile
> > index 0917f8cf4fab..eaebbeead42f 100644
> > --- a/samples/bpf/Makefile
> > +++ b/samples/bpf/Makefile
> > @@ -154,6 +154,7 @@ always += tcp_iw_kern.o
> >  always += tcp_clamp_kern.o
> >  always += tcp_basertt_kern.o
> >  always += tcp_tos_reflect_kern.o
> > +always += tcp_dumpstats_kern.o
> >  always += xdp_redirect_kern.o
> >  always += xdp_redirect_map_kern.o
> >  always += xdp_redirect_cpu_kern.o
> > diff --git a/samples/bpf/tcp_dumpstats_kern.c b/samples/bpf/tcp_dumpstats_kern.c
> > new file mode 100644
> > index 000000000000..5d22bf61db65
> > --- /dev/null
> > +++ b/samples/bpf/tcp_dumpstats_kern.c
> > @@ -0,0 +1,65 @@
> > +// SPDX-License-Identifier: GPL-2.0
> > +#include <linux/bpf.h>
> > +
> > +#include "bpf_helpers.h"
> > +#include "bpf_endian.h"
> > +
> > +#define INTERVAL                       1000000000ULL
> > +
> > +int _version SEC("version") = 1;
> > +char _license[] SEC("license") = "GPL";
> > +
> > +struct {
> > +       __u32 type;
> > +       __u32 map_flags;
> > +       int *key;
> > +       __u64 *value;
> > +} bpf_next_dump SEC(".maps") = {
> > +       .type = BPF_MAP_TYPE_SK_STORAGE,
> > +       .map_flags = BPF_F_NO_PREALLOC,
> > +};
> > +
> > +SEC("sockops")
> > +int _sockops(struct bpf_sock_ops *ctx)
> > +{
> > +       struct bpf_tcp_sock *tcp_sk;
> > +       struct bpf_sock *sk;
> > +       __u64 *next_dump;
> > +       __u64 now;
> > +
> > +       switch (ctx->op) {
> > +       case BPF_SOCK_OPS_TCP_CONNECT_CB:
> > +               bpf_sock_ops_cb_flags_set(ctx, BPF_SOCK_OPS_RTT_CB_FLAG);
> > +               return 1;
> > +       case BPF_SOCK_OPS_RTT_CB:
> > +               break;
> > +       default:
> > +               return 1;
> > +       }
> > +
> > +       sk = ctx->sk;
> > +       if (!sk)
> > +               return 1;
> > +
> > +       next_dump = bpf_sk_storage_get(&bpf_next_dump, sk, 0,
> > +                                      BPF_SK_STORAGE_GET_F_CREATE);
> > +       if (!next_dump)
> > +               return 1;
> > +
> > +       now = bpf_ktime_get_ns();
> > +       if (now < *next_dump)
> > +               return 1;
> > +
> > +       tcp_sk = bpf_tcp_sock(sk);
> > +       if (!tcp_sk)
> > +               return 1;
> > +
> > +       *next_dump = now + INTERVAL;
> > +
> > +       bpf_printk("dsack_dups=%u delivered=%u\n",
> > +                  tcp_sk->dsack_dups, tcp_sk->delivered);
> > +       bpf_printk("delivered_ce=%u icsk_retransmits=%u\n",
> > +                  tcp_sk->delivered_ce, tcp_sk->icsk_retransmits);
> > +
> > +       return 1;
> > +}
> > --
> > 2.22.0.410.gd8fdbe21b5-goog
> >

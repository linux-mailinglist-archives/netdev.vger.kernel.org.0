Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 25B1769B236
	for <lists+netdev@lfdr.de>; Fri, 17 Feb 2023 19:14:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229573AbjBQSOQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Feb 2023 13:14:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33628 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229520AbjBQSOP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Feb 2023 13:14:15 -0500
Received: from mail-yw1-x1134.google.com (mail-yw1-x1134.google.com [IPv6:2607:f8b0:4864:20::1134])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4D9552364F;
        Fri, 17 Feb 2023 10:14:14 -0800 (PST)
Received: by mail-yw1-x1134.google.com with SMTP id 00721157ae682-536572bf94dso23124467b3.1;
        Fri, 17 Feb 2023 10:14:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=diRDpie4FYvo9Vqcbul5rqZGZMxlBG0cN17od52CNEY=;
        b=Rm+gJ7NwiveR5WZVlTCOL0FBZv5nJkzNCa7j1jwObp2WSQiGQnjbdIwxuD3eQp8Fb1
         IHAUtF0jTPpSJkDjYSCQrMbSm5zRovoqzYGbWKxkIG+TWWOnphLkUP0RLUh2CrcXC8S8
         mhdbrt3hBdwR1mLoAVw4AnSgdLmnIt+ENyia7lsuWlggmjMOlFRzi1bHlbdn+se0R5cO
         z+gaJVkEZJI034wNd64r0DtVzigeIjCnx6Wx6BCjAgr0LCH+0o3q5VfoCsI84Lm1Az91
         zvp1b4qtNYs3/XfznOy/eg/9oqrmkaW6eS93W9zXM3s31FR4ZYG1snWXoWqU4vANKbfY
         MPZw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=diRDpie4FYvo9Vqcbul5rqZGZMxlBG0cN17od52CNEY=;
        b=Oidb6sLSQXOMJt5A6BTuwgd8IlJnaJ8Zn/ZbMSBz3TjwCTQIYFHovFtME3XKb5a4oD
         IaU3VYzhwSXsgcITlXKXKa573c9ZXOK1aCM9sbAaH0F6Ki/nOMrPXWtH1A7fCjoStU74
         avpzKnXM2SP5yOLNm5raLSldAlVSq0T1Kz5Hsys6Vit/uyLNl+ad4ZFmIePyKOvE9tIX
         oS3mO9r1k7WNtNOAz+NDc4BCDJVIDpf5DA4haFIaQVLhxS92zUh/+5XhSRGfCxm2S8ms
         ttO8fM5PtCOWW4SKPWKxNiE/64AhXh0dlcDRHXFWc/W+YVVUXwiNEMcIpKhCqF7/LXpP
         uLuQ==
X-Gm-Message-State: AO0yUKUctmlXNSu+UyOyoHB+kyjWIXWkoEkvNSdER/Mc7vSkGGmqoT+a
        Y4Ul25ZqFWgOlyZpTPwWZHwHzMOvcISMP6N4hOZrLRur
X-Google-Smtp-Source: AK7set9Qp+aBCiWdhcHHtfU00+QPFi1bEeZSaxphM2aKJ4/Z96bnk9+RVhpHaIemnhHT5utfnAo2lbOtO/lEEVRaV7c=
X-Received: by 2002:a81:d547:0:b0:52b:ca74:3643 with SMTP id
 l7-20020a81d547000000b0052bca743643mr1372576ywj.358.1676657653481; Fri, 17
 Feb 2023 10:14:13 -0800 (PST)
MIME-Version: 1.0
References: <20230216225524.1192789-1-joannelkoong@gmail.com>
 <20230216225524.1192789-10-joannelkoong@gmail.com> <87a61cqw65.fsf@toke.dk>
In-Reply-To: <87a61cqw65.fsf@toke.dk>
From:   Joanne Koong <joannelkoong@gmail.com>
Date:   Fri, 17 Feb 2023 10:14:02 -0800
Message-ID: <CAJnrk1YA+-+ZEB3JL=pZS-_NUz+Zvwim9eFFXzoojsqp5ZfZZg@mail.gmail.com>
Subject: Re: [PATCH v10 bpf-next 9/9] selftests/bpf: tests for using dynptrs
 to parse skb and xdp buffers
To:     =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@kernel.org>
Cc:     bpf@vger.kernel.org, martin.lau@kernel.org, andrii@kernel.org,
        memxor@gmail.com, ast@kernel.org, daniel@iogearbox.net,
        netdev@vger.kernel.org, kernel-team@fb.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Feb 17, 2023 at 5:05 AM Toke H=C3=B8iland-J=C3=B8rgensen <toke@kern=
el.org> wrote:
>
> Joanne Koong <joannelkoong@gmail.com> writes:
>
> > Test skb and xdp dynptr functionality in the following ways:
>
> One question on one of the usage examples:
>
> [...]
>
> > diff --git a/tools/testing/selftests/bpf/progs/test_xdp_dynptr.c b/tool=
s/testing/selftests/bpf/progs/test_xdp_dynptr.c
> > new file mode 100644
> > index 000000000000..4c49fd42da6f
> > --- /dev/null
> > +++ b/tools/testing/selftests/bpf/progs/test_xdp_dynptr.c
> > @@ -0,0 +1,257 @@
> > +// SPDX-License-Identifier: GPL-2.0
> > +/* Copyright (c) 2022 Meta */
> > +#include <stddef.h>
> > +#include <string.h>
> > +#include <linux/bpf.h>
> > +#include <linux/if_ether.h>
> > +#include <linux/if_packet.h>
> > +#include <linux/ip.h>
> > +#include <linux/ipv6.h>
> > +#include <linux/in.h>
> > +#include <linux/udp.h>
> > +#include <linux/tcp.h>
> > +#include <linux/pkt_cls.h>
> > +#include <sys/socket.h>
> > +#include <bpf/bpf_helpers.h>
> > +#include <bpf/bpf_endian.h>
> > +#include "test_iptunnel_common.h"
> > +
> > +extern int bpf_dynptr_from_xdp(struct xdp_md *xdp, __u64 flags,
> > +                            struct bpf_dynptr *ptr) __ksym;
> > +extern void *bpf_dynptr_slice(const struct bpf_dynptr *ptr, __u32 offs=
et,
> > +                           void *buffer, __u32 buffer__sz) __ksym;
> > +extern void *bpf_dynptr_slice_rdwr(const struct bpf_dynptr *ptr, __u32=
 offset,
> > +                           void *buffer, __u32 buffer__sz) __ksym;
> > +
> > +const size_t tcphdr_sz =3D sizeof(struct tcphdr);
> > +const size_t udphdr_sz =3D sizeof(struct udphdr);
> > +const size_t ethhdr_sz =3D sizeof(struct ethhdr);
> > +const size_t iphdr_sz =3D sizeof(struct iphdr);
> > +const size_t ipv6hdr_sz =3D sizeof(struct ipv6hdr);
> > +
> > +struct {
> > +     __uint(type, BPF_MAP_TYPE_PERCPU_ARRAY);
> > +     __uint(max_entries, 256);
> > +     __type(key, __u32);
> > +     __type(value, __u64);
> > +} rxcnt SEC(".maps");
> > +
> > +struct {
> > +     __uint(type, BPF_MAP_TYPE_HASH);
> > +     __uint(max_entries, MAX_IPTNL_ENTRIES);
> > +     __type(key, struct vip);
> > +     __type(value, struct iptnl_info);
> > +} vip2tnl SEC(".maps");
> > +
> > +static __always_inline void count_tx(__u32 protocol)
> > +{
> > +     __u64 *rxcnt_count;
> > +
> > +     rxcnt_count =3D bpf_map_lookup_elem(&rxcnt, &protocol);
> > +     if (rxcnt_count)
> > +             *rxcnt_count +=3D 1;
> > +}
> > +
> > +static __always_inline int get_dport(void *trans_data, __u8 protocol)
> > +{
> > +     struct tcphdr *th;
> > +     struct udphdr *uh;
> > +
> > +     switch (protocol) {
> > +     case IPPROTO_TCP:
> > +             th =3D (struct tcphdr *)trans_data;
> > +             return th->dest;
> > +     case IPPROTO_UDP:
> > +             uh =3D (struct udphdr *)trans_data;
> > +             return uh->dest;
> > +     default:
> > +             return 0;
> > +     }
> > +}
> > +
> > +static __always_inline void set_ethhdr(struct ethhdr *new_eth,
> > +                                    const struct ethhdr *old_eth,
> > +                                    const struct iptnl_info *tnl,
> > +                                    __be16 h_proto)
> > +{
> > +     memcpy(new_eth->h_source, old_eth->h_dest, sizeof(new_eth->h_sour=
ce));
> > +     memcpy(new_eth->h_dest, tnl->dmac, sizeof(new_eth->h_dest));
> > +     new_eth->h_proto =3D h_proto;
> > +}
> > +
> > +static __always_inline int handle_ipv4(struct xdp_md *xdp, struct bpf_=
dynptr *xdp_ptr)
> > +{
> > +     __u8 eth_buffer[ethhdr_sz + iphdr_sz + ethhdr_sz];
> > +     __u8 iph_buffer_tcp[iphdr_sz + tcphdr_sz];
> > +     __u8 iph_buffer_udp[iphdr_sz + udphdr_sz];
> > +     struct bpf_dynptr new_xdp_ptr;
> > +     struct iptnl_info *tnl;
> > +     struct ethhdr *new_eth;
> > +     struct ethhdr *old_eth;
> > +     __u32 transport_hdr_sz;
> > +     struct iphdr *iph;
> > +     __u16 *next_iph;
> > +     __u16 payload_len;
> > +     struct vip vip =3D {};
> > +     int dport;
> > +     __u32 csum =3D 0;
> > +     int i;
> > +
> > +     __builtin_memset(eth_buffer, 0, sizeof(eth_buffer));
> > +     __builtin_memset(iph_buffer_tcp, 0, sizeof(iph_buffer_tcp));
> > +     __builtin_memset(iph_buffer_udp, 0, sizeof(iph_buffer_udp));
> > +
> > +     if (ethhdr_sz + iphdr_sz + tcphdr_sz > xdp->data_end - xdp->data)
> > +             iph =3D bpf_dynptr_slice(xdp_ptr, ethhdr_sz, iph_buffer_u=
dp, sizeof(iph_buffer_udp));
> > +     else
> > +             iph =3D bpf_dynptr_slice(xdp_ptr, ethhdr_sz, iph_buffer_t=
cp, sizeof(iph_buffer_tcp));
> > +
> > +     if (!iph)
> > +             return XDP_DROP;
> > +
> > +     dport =3D get_dport(iph + 1, iph->protocol);
> > +     if (dport =3D=3D -1)
> > +             return XDP_DROP;
> > +
> > +     vip.protocol =3D iph->protocol;
> > +     vip.family =3D AF_INET;
> > +     vip.daddr.v4 =3D iph->daddr;
> > +     vip.dport =3D dport;
> > +     payload_len =3D bpf_ntohs(iph->tot_len);
> > +
> > +     tnl =3D bpf_map_lookup_elem(&vip2tnl, &vip);
> > +     /* It only does v4-in-v4 */
> > +     if (!tnl || tnl->family !=3D AF_INET)
> > +             return XDP_PASS;
> > +
> > +     if (bpf_xdp_adjust_head(xdp, 0 - (int)iphdr_sz))
> > +             return XDP_DROP;
> > +
> > +     bpf_dynptr_from_xdp(xdp, 0, &new_xdp_ptr);
> > +     new_eth =3D bpf_dynptr_slice_rdwr(&new_xdp_ptr, 0, eth_buffer, si=
zeof(eth_buffer));
> > +     if (!new_eth)
> > +             return XDP_DROP;
>
> Here the program just gets a new pointer using bpf_dynptr_slice_rdwr()
> and proceeds to write to it directly without any further checks. But
> what happens if the pointer points to the eth_buffer? Presumably the
> program would need to check this and do a bpf_dynptr_write() at the end
> in this case? Would be good to have this in the example, as this is
> basically the only documentation that exists, and people are probably
> going to copy-paste code from here :)
>
> -Toke
>

Ooh good catch, thanks! i forgot to change this for the other examples
as well; I will update this :)

>
>
> > +     iph =3D (struct iphdr *)(new_eth + 1);
> > +     old_eth =3D (struct ethhdr *)(iph + 1);
[...]

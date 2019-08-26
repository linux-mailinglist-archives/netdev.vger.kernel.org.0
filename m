Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2D0F09D3F5
	for <lists+netdev@lfdr.de>; Mon, 26 Aug 2019 18:26:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732351AbfHZQ0n (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Aug 2019 12:26:43 -0400
Received: from mail-yw1-f68.google.com ([209.85.161.68]:44099 "EHLO
        mail-yw1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729338AbfHZQ0n (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 26 Aug 2019 12:26:43 -0400
Received: by mail-yw1-f68.google.com with SMTP id l79so6826846ywe.11
        for <netdev@vger.kernel.org>; Mon, 26 Aug 2019 09:26:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=N302xW0myuImVaI6zbk+l9+AsvPsW5HGP6wk13rV8Uo=;
        b=s2zeEsb26IRwfWkbRdQ1pwtF5go9KxmQZmfxYjTNaRMbASUEyKRJ4HdcMiOVAzX9D6
         GkuiKOmm5+jSy17+BcUhjpQr8MeysodyulgQ/nMLrXrkJebCwO0rBVV9xd5ln7OT7nMM
         /adLpg586vmJAoF28x7ZoHrsjbYIQVp0mn7Bu4+j4uSiI15smgm3Co4lDAZk1j+EcvFT
         Llu43vdtst9mVvjqHDXFhDDdmixfUWxhzXb0vnfMrDIDO8LR6iFo359rNEm3ezLwC6jl
         sFD84gG5OZXI78LwT4goy6OkcYdzBL73ZW/v2De4SKzIZYGqBqCH6dMFYaE58rtFmjBc
         5/tQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=N302xW0myuImVaI6zbk+l9+AsvPsW5HGP6wk13rV8Uo=;
        b=Mf5n6r+VD7Q0jgpXAA7D4DBlExoSlutfU1bnhTgq8SfxNOf0sW493uIdU7bQJKOw4K
         RBBh8Qn23N8UBFc3+aeDzVqnE1axsARQUjJKeLEMVxCndp/4v9CuHf0dbaZ9tUTmDgiE
         NO8KVxr0gjkAtQxxqGwYpBTMs1dLo5Un6PvoB6sJtVr6ZZkZKxrbcl9NL0e6tSD3xyQI
         9bDkK+OdYF81I8myN4Hk8nozR2zTLewM10L7b1QxQRNeuL+oh9jCtTipdOsjjAkJrkY1
         Exp1GlGFotVBIdx/y1wjF4A+yRDEA1nHRru0AThLUqW7f+cjK5WZjZDrIdCIm6mGTGYB
         Ic/A==
X-Gm-Message-State: APjAAAV9I/V/5/TgwNY5/qb3u05DjhLZXLHp0gviLINAbtU5UOvTha48
        WbCRA+OpWsq+WLKitTH7pUuOWjWv+K9O5/isbw==
X-Google-Smtp-Source: APXvYqxvBXE/uLn/RRCbs/KV/qpYf1zWkpeT1tyAeCMHqRkhLNs2vGaeJQe/vq0RF7vwRqOLDpJOgmAUFrxi6TOsZ5g=
X-Received: by 2002:a81:4fd4:: with SMTP id d203mr13275546ywb.166.1566836802005;
 Mon, 26 Aug 2019 09:26:42 -0700 (PDT)
MIME-Version: 1.0
References: <20190826095722.28229-1-danieltimlee@gmail.com> <20190826175420.000021f3@gmail.com>
In-Reply-To: <20190826175420.000021f3@gmail.com>
From:   "Daniel T. Lee" <danieltimlee@gmail.com>
Date:   Tue, 27 Aug 2019 01:26:25 +0900
Message-ID: <CAEKGpzixoNtjA4FedRauBEPx=x55sdDbspceO-r3kTExyHQNpQ@mail.gmail.com>
Subject: Re: [PATCH] samples: bpf: add max_pckt_size option at xdp_adjust_tail
To:     Maciej Fijalkowski <maciejromanfijalkowski@gmail.com>
Cc:     Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>,
        netdev <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Aug 27, 2019 at 12:54 AM Maciej Fijalkowski
<maciejromanfijalkowski@gmail.com> wrote:
>
> On Mon, 26 Aug 2019 18:57:22 +0900
> "Daniel T. Lee" <danieltimlee@gmail.com> wrote:
>
> > Currently, at xdp_adjust_tail_kern.c, MAX_PCKT_SIZE is limited
> > to 600. To make this size flexible, a new map 'pcktsz' is added.
> >
> > By updating new packet size to this map from the userland,
> > xdp_adjust_tail_kern.o will use this value as a new max_pckt_size.
> >
> > If no '-P <MAX_PCKT_SIZE>' option is used, the size of maximum packet
> > will be 600 as a default.
> >
> > Signed-off-by: Daniel T. Lee <danieltimlee@gmail.com>
> > ---
> >  samples/bpf/xdp_adjust_tail_kern.c | 23 +++++++++++++++++++----
> >  samples/bpf/xdp_adjust_tail_user.c | 21 +++++++++++++++++++--
> >  2 files changed, 38 insertions(+), 6 deletions(-)
> >
> > diff --git a/samples/bpf/xdp_adjust_tail_kern.c b/samples/bpf/xdp_adjust_tail_kern.c
> > index 411fdb21f8bc..4d53af370b68 100644
> > --- a/samples/bpf/xdp_adjust_tail_kern.c
> > +++ b/samples/bpf/xdp_adjust_tail_kern.c
> > @@ -25,6 +25,13 @@
> >  #define ICMP_TOOBIG_SIZE 98
> >  #define ICMP_TOOBIG_PAYLOAD_SIZE 92
> >
> > +struct bpf_map_def SEC("maps") pcktsz = {
> > +     .type = BPF_MAP_TYPE_ARRAY,
> > +     .key_size = sizeof(__u32),
> > +     .value_size = sizeof(__u32),
> > +     .max_entries = 1,
> > +};
> > +
> >  struct bpf_map_def SEC("maps") icmpcnt = {
> >       .type = BPF_MAP_TYPE_ARRAY,
> >       .key_size = sizeof(__u32),
> > @@ -64,7 +71,8 @@ static __always_inline void ipv4_csum(void *data_start, int data_size,
> >       *csum = csum_fold_helper(*csum);
> >  }
> >
> > -static __always_inline int send_icmp4_too_big(struct xdp_md *xdp)
> > +static __always_inline int send_icmp4_too_big(struct xdp_md *xdp,
> > +                                           __u32 max_pckt_size)
> >  {
> >       int headroom = (int)sizeof(struct iphdr) + (int)sizeof(struct icmphdr);
> >
> > @@ -92,7 +100,7 @@ static __always_inline int send_icmp4_too_big(struct xdp_md *xdp)
> >       orig_iph = data + off;
> >       icmp_hdr->type = ICMP_DEST_UNREACH;
> >       icmp_hdr->code = ICMP_FRAG_NEEDED;
> > -     icmp_hdr->un.frag.mtu = htons(MAX_PCKT_SIZE-sizeof(struct ethhdr));
> > +     icmp_hdr->un.frag.mtu = htons(max_pckt_size - sizeof(struct ethhdr));
> >       icmp_hdr->checksum = 0;
> >       ipv4_csum(icmp_hdr, ICMP_TOOBIG_PAYLOAD_SIZE, &csum);
> >       icmp_hdr->checksum = csum;
> > @@ -118,14 +126,21 @@ static __always_inline int handle_ipv4(struct xdp_md *xdp)
> >  {
> >       void *data_end = (void *)(long)xdp->data_end;
> >       void *data = (void *)(long)xdp->data;
> > +     __u32 max_pckt_size = MAX_PCKT_SIZE;
> > +     __u32 *pckt_sz;
> > +     __u32 key = 0;
> >       int pckt_size = data_end - data;
> >       int offset;
> >
> > -     if (pckt_size > MAX_PCKT_SIZE) {
> > +     pckt_sz = bpf_map_lookup_elem(&pcktsz, &key);
> > +     if (pckt_sz && *pckt_sz)
> > +             max_pckt_size = *pckt_sz;
> > +
> > +     if (pckt_size > max_pckt_size) {
> >               offset = pckt_size - ICMP_TOOBIG_SIZE;
> >               if (bpf_xdp_adjust_tail(xdp, 0 - offset))
> >                       return XDP_PASS;
> > -             return send_icmp4_too_big(xdp);
> > +             return send_icmp4_too_big(xdp, max_pckt_size);
> >       }
> >       return XDP_PASS;
> >  }
> > diff --git a/samples/bpf/xdp_adjust_tail_user.c b/samples/bpf/xdp_adjust_tail_user.c
> > index a3596b617c4c..dd3befa5e1fe 100644
> > --- a/samples/bpf/xdp_adjust_tail_user.c
> > +++ b/samples/bpf/xdp_adjust_tail_user.c
> > @@ -72,6 +72,7 @@ static void usage(const char *cmd)
> >       printf("Usage: %s [...]\n", cmd);
> >       printf("    -i <ifname|ifindex> Interface\n");
> >       printf("    -T <stop-after-X-seconds> Default: 0 (forever)\n");
> > +     printf("    -P <MAX_PCKT_SIZE> Default: 600\n");
> >       printf("    -S use skb-mode\n");
> >       printf("    -N enforce native mode\n");
> >       printf("    -F force loading prog\n");
> > @@ -85,9 +86,11 @@ int main(int argc, char **argv)
> >               .prog_type      = BPF_PROG_TYPE_XDP,
> >       };
> >       unsigned char opt_flags[256] = {};
> > -     const char *optstr = "i:T:SNFh";
> > +     const char *optstr = "i:T:P:SNFh";
> >       struct bpf_prog_info info = {};
> >       __u32 info_len = sizeof(info);
> > +     __u32 max_pckt_size = 0;
> > +     __u32 key = 0;
> >       unsigned int kill_after_s = 0;
> >       int i, prog_fd, map_fd, opt;
> >       struct bpf_object *obj;
> > @@ -110,6 +113,9 @@ int main(int argc, char **argv)
> >               case 'T':
> >                       kill_after_s = atoi(optarg);
> >                       break;
> > +             case 'P':
> > +                     max_pckt_size = atoi(optarg);
> > +                     break;
> >               case 'S':
> >                       xdp_flags |= XDP_FLAGS_SKB_MODE;
> >                       break;
> > @@ -150,9 +156,20 @@ int main(int argc, char **argv)
> >       if (bpf_prog_load_xattr(&prog_load_attr, &obj, &prog_fd))
> >               return 1;
> >
> > +     /* update pcktsz map */
> >       map = bpf_map__next(NULL, obj);
> >       if (!map) {
> > -             printf("finding a map in obj file failed\n");
> > +             printf("finding a pcktsz map in obj file failed\n");
> > +             return 1;
> > +     }
> > +     map_fd = bpf_map__fd(map);
>
> Consider using bpf_object__find_map_fd_by_name() here.
>
> > +     if (max_pckt_size)
> > +             bpf_map_update_elem(map_fd, &key, &max_pckt_size, BPF_ANY);
> > +
> > +     /* fetch icmpcnt map */
> > +     map = bpf_map__next(map, obj);
> > +     if (!map) {
> > +             printf("finding a icmpcnt map in obj file failed\n");
> >               return 1;
> >       }
> >       map_fd = bpf_map__fd(map);
>

Thanks for the review!
I'll update it right away.

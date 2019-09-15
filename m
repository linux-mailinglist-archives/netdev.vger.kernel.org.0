Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 51701B2FD3
	for <lists+netdev@lfdr.de>; Sun, 15 Sep 2019 14:24:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730365AbfIOMYa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 15 Sep 2019 08:24:30 -0400
Received: from mail-yb1-f193.google.com ([209.85.219.193]:33561 "EHLO
        mail-yb1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730163AbfIOMYa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 15 Sep 2019 08:24:30 -0400
Received: by mail-yb1-f193.google.com with SMTP id z7so2439301ybg.0;
        Sun, 15 Sep 2019 05:24:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=MojEkGwS8/e7HiQGO1PiAT1ljMX0Ym6VaIUWrLg7MLE=;
        b=EBDBl7Dj+eeMCtNfc0Dj1dYrf5Mjryzr/2GbpBBqMKadMHVGBZEEvMuCq3/+spgJNX
         HgGh9XA+QNo9NT2BZNT6tOkmnASQBm3vTU4scC2bczmP/RCZhbtMXP90DRwnMN39BY2i
         UdnDpFuCaLQlZOsaobWT+QWkSuHJP+sW2MfZMWmM5+WubAHt4SZx14BD7PqgFiCu1lgf
         a3ZK+BadnmnpqpS23gG+xPc7EO8glUEoDj6VjESDERkn3kexA8zwJpbPLOVVi/Y5Xuph
         Vuce92YHlvoVBgH1v1KMcXASrQB4kn4E1QzsRikAPDcVeo3ZBrZUG6aMaetleMWx6tIW
         Py9w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=MojEkGwS8/e7HiQGO1PiAT1ljMX0Ym6VaIUWrLg7MLE=;
        b=fpVeb6dEOwsSC/OPBpGDMshd3Ee8dEmsUt0yZ0LDxIgcNFrZszoFfWDcoSw4+OE6O3
         kqcWvvALl4BvNdXssEQYyOzMZHHQ+b+RrGpwCMSZHLgBoqzTXq3EygwXIuaHey/Ibh3z
         IgnlVsKPYCEYjCLrxEKJf/2luWsnm4K75TddiskiKVZIsCV8CQlJF/3PN2G6+GR5l21+
         8LPhZJkWGid+/Y/oQrsag55+8L4UCFadhvL5cwTrb/07zYFrbRTBf+EX2X2QK4jm/R3W
         +PlrAplffa1XK2l8P8pjJzPneNPtiqkvG51Y/b2xOzxYPSDFvKsn5yMvGQpIwQHW890u
         062A==
X-Gm-Message-State: APjAAAUTEYM3jjA4diUwR+f11Ix3klzYMyA6WFdXGmuTSPcabIqpZBvV
        H9wjy53b4PQD4Y4UWKYWXfgCF9oIXVZsozmaEgJ1FDqftA==
X-Google-Smtp-Source: APXvYqxnb/sF9Gx7LyTfUFViEu2e2ICio4Ssxyp00OXa/1pF4aqTcW38GMI89KPoTgOnA5JkST67oxgx4Q7s5mf9pHc=
X-Received: by 2002:a25:e016:: with SMTP id x22mr6853410ybg.9.1568550268928;
 Sun, 15 Sep 2019 05:24:28 -0700 (PDT)
MIME-Version: 1.0
References: <20190911190218.22628-1-danieltimlee@gmail.com> <7add91c8-a22c-f10e-76a4-495d8be09c9b@fb.com>
In-Reply-To: <7add91c8-a22c-f10e-76a4-495d8be09c9b@fb.com>
From:   "Daniel T. Lee" <danieltimlee@gmail.com>
Date:   Sun, 15 Sep 2019 12:24:11 +0900
Message-ID: <CAEKGpzhFid5dXa=POurDcypf82-W=Bpt_b9B0Szhidwds9adTQ@mail.gmail.com>
Subject: Re: [bpf-next,v3] samples: bpf: add max_pckt_size option at xdp_adjust_tail
To:     Yonghong Song <yhs@fb.com>
Cc:     Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Sep 14, 2019 at 7:34 AM Yonghong Song <yhs@fb.com> wrote:
>
>
>
> On 9/11/19 8:02 PM, Daniel T. Lee wrote:
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
> >
> > ---
> > Changes in v2:
> >      - Change the helper to fetch map from 'bpf_map__next' to
> >      'bpf_object__find_map_fd_by_name'.
> >
> >   samples/bpf/xdp_adjust_tail_kern.c | 23 +++++++++++++++++++----
> >   samples/bpf/xdp_adjust_tail_user.c | 28 ++++++++++++++++++++++------
> >   2 files changed, 41 insertions(+), 10 deletions(-)
> >
> > diff --git a/samples/bpf/xdp_adjust_tail_kern.c b/samples/bpf/xdp_adjust_tail_kern.c
> > index 411fdb21f8bc..d6d84ffe6a7a 100644
> > --- a/samples/bpf/xdp_adjust_tail_kern.c
> > +++ b/samples/bpf/xdp_adjust_tail_kern.c
> > @@ -25,6 +25,13 @@
> >   #define ICMP_TOOBIG_SIZE 98
> >   #define ICMP_TOOBIG_PAYLOAD_SIZE 92
> >
> > +struct bpf_map_def SEC("maps") pcktsz = {
> > +     .type = BPF_MAP_TYPE_ARRAY,
> > +     .key_size = sizeof(__u32),
> > +     .value_size = sizeof(__u32),
> > +     .max_entries = 1,
> > +};
>
> We have new map definition format like in
> tools/testing/selftests/bpf/progs/bpf_flow.c.
> But looks like most samples/bpf still use SEC("maps").
> I guess we can leave it for now, and if needed,
> later on a massive conversion for all samples/bpf/
> bpf programs can be done.
>

Thanks for the detailed review!
Didn't notice there was an update with map definition.
This new map definition format looks very neat.

> > +
> >   struct bpf_map_def SEC("maps") icmpcnt = {
> >       .type = BPF_MAP_TYPE_ARRAY,
> >       .key_size = sizeof(__u32),
> > @@ -64,7 +71,8 @@ static __always_inline void ipv4_csum(void *data_start, int data_size,
> >       *csum = csum_fold_helper(*csum);
> >   }
> >
> > -static __always_inline int send_icmp4_too_big(struct xdp_md *xdp)
> > +static __always_inline int send_icmp4_too_big(struct xdp_md *xdp,
> > +                                           __u32 max_pckt_size)
> >   {
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
> >   {
> >       void *data_end = (void *)(long)xdp->data_end;
> >       void *data = (void *)(long)xdp->data;
> > +     __u32 max_pckt_size = MAX_PCKT_SIZE;
> > +     __u32 *pckt_sz;
> > +     __u32 key = 0;
>
> The above two new definitions may the code not in
> reverse Christmas definition order, could you fix it?
>

I'll fix it right away!

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
>
> We could have the following scenario:
>    max_pckt_size = 1
>    pckt_size = 2
>    offset = -96
>    bpf_xdp_adjust_tail return -EINVAL
>    so we return XDP_PASS now
>
> Maybe you want to do
>     if (pckt_size > max(max_pckt_size, ICMP_TOOBIG_SIZE)) {
>        ...
>     }
> as in original code, bpf_xdp_adjust_tail(...) already succeeds.
>

I'll try to fix this way.

> > -             return send_icmp4_too_big(xdp);
> > +             return send_icmp4_too_big(xdp, max_pckt_size);
> >       }
> >       return XDP_PASS;
> >   }
> > diff --git a/samples/bpf/xdp_adjust_tail_user.c b/samples/bpf/xdp_adjust_tail_user.c
> > index a3596b617c4c..aef6c69a48a7 100644
> > --- a/samples/bpf/xdp_adjust_tail_user.c
> > +++ b/samples/bpf/xdp_adjust_tail_user.c
> > @@ -23,6 +23,7 @@
> >   #include "libbpf.h"
> >
> >   #define STATS_INTERVAL_S 2U
> > +#define MAX_PCKT_SIZE 600
> >
> >   static int ifindex = -1;
> >   static __u32 xdp_flags = XDP_FLAGS_UPDATE_IF_NOEXIST;
> > @@ -72,6 +73,7 @@ static void usage(const char *cmd)
> >       printf("Usage: %s [...]\n", cmd);
> >       printf("    -i <ifname|ifindex> Interface\n");
> >       printf("    -T <stop-after-X-seconds> Default: 0 (forever)\n");
> > +     printf("    -P <MAX_PCKT_SIZE> Default: %u\n", MAX_PCKT_SIZE);
> >       printf("    -S use skb-mode\n");
> >       printf("    -N enforce native mode\n");
> >       printf("    -F force loading prog\n");
> > @@ -85,13 +87,14 @@ int main(int argc, char **argv)
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
> > -     struct bpf_map *map;
> >       char filename[256];
> >       int err;
> >
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
> > @@ -150,12 +156,22 @@ int main(int argc, char **argv)
> >       if (bpf_prog_load_xattr(&prog_load_attr, &obj, &prog_fd))
> >               return 1;
> >
> > -     map = bpf_map__next(NULL, obj);
> > -     if (!map) {
> > -             printf("finding a map in obj file failed\n");
> > +     /* update pcktsz map */
> > +     if (max_pckt_size) {
> > +             map_fd = bpf_object__find_map_fd_by_name(obj, "pcktsz");
> > +             if (!map_fd) {
>
> Let us test map_fd and below prog_fd with '< 0" instead of "!= 0'.
> In this particular sample, "! = 0" is okay since we did not close
> stdin. But in programs if stdin is closed, the fd 0 may be reused
> for map_fd. Let us just keep good coding practice here.
>

I didn't think of those details. I'll update this right away!

Once again, I really appreciate your time and effort for the review.
Thank you.

Best,
Daniel

> > +                     printf("finding a pcktsz map in obj file failed\n");
> > +                     return 1;
> > +             }
> > +             bpf_map_update_elem(map_fd, &key, &max_pckt_size, BPF_ANY);
> > +     }
> > +
> > +     /* fetch icmpcnt map */
> > +     map_fd = bpf_object__find_map_fd_by_name(obj, "icmpcnt");
> > +     if (!map_fd) {
> > +             printf("finding a icmpcnt map in obj file failed\n");
> >               return 1;
> >       }
> > -     map_fd = bpf_map__fd(map);
> >
> >       if (!prog_fd) {
> >               printf("load_bpf_file: %s\n", strerror(errno));
> >

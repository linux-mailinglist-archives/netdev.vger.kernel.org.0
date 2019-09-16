Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4AB6DB3F5B
	for <lists+netdev@lfdr.de>; Mon, 16 Sep 2019 18:56:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390229AbfIPQ4M (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Sep 2019 12:56:12 -0400
Received: from mail-yw1-f65.google.com ([209.85.161.65]:44943 "EHLO
        mail-yw1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727821AbfIPQ4M (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 Sep 2019 12:56:12 -0400
Received: by mail-yw1-f65.google.com with SMTP id u187so96528ywa.11;
        Mon, 16 Sep 2019 09:56:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=RpjcguiwP0UOlrT1Z0K/L5tdIDGkoTYTzqLKdAI+2mM=;
        b=FSJ5eFi0Vs929n/F9Jz6RkjzbXjIn7pH+sizm571LEE2zVDQ/d1bPbp+iEdWJrjAG6
         jXOHsd4EYBORzLPNxrIX6cake7SqWMy/BS+wNXPcdttemECPQqfEYJrVbehg4DBCAjX5
         PYuzHaslSW9+54XitahvUUn6NgTp8GPky4jaMrvz2FH3YbtW2B05/SGdU07FZuFEvd5m
         gY+PyuclnH0IJqM0AIOd/qgs3ewJwFMvLn+wlBCcB8XwsR7O+gT8SI6cgnKIvF4JKxZk
         fLy9AA4N0Wk65zx4UmR9grBv6a5jfLZU16ErzYq4ixisEyJ/kg4dfYwsqAMvqQ8/YpUQ
         V9GA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=RpjcguiwP0UOlrT1Z0K/L5tdIDGkoTYTzqLKdAI+2mM=;
        b=k/2xK4hlGnChHb1mJFwQAPxRLk5G/NmZGH/YRQiM7DyoJwxU45EAAkmBnilqylbwJO
         erv91Wf6OoUCDNFGhcHRWmuwSFDyG+SsxodmfBLjBOlKub+y5873qOIMTOMGrxugh/xl
         Jz7OPVRezcEuqLWLb04T4w1UWAY+hjlEXmIJSiZh+FG4ymE6Fm0DFYRTkrsRVeF8AFbX
         0sOdMkwZ4tlRwRTCbCBLXxZP32CSQkDn1ME9VtLzIORVGbXWcgJwzA63SreaIsd8jfaf
         2qHCX0XYN9HiR9MAOcZ7CZYvSucmduiPB62UFEZ77jG61MlBMpyh9Qon6DG8r9B/MYo4
         AJNw==
X-Gm-Message-State: APjAAAXdG322aoHvgh8ENTy8PK5uJ0XJ0XCLX/zUd+roKRIFIIBi3ZYJ
        peKz9jmQVdpOL1TCl7cYVl1R8elviWWSaXJ32A==
X-Google-Smtp-Source: APXvYqxpqWItY6DEsJ8lmJjrnZQ6DIucuow4PbVGT2a5d/JWpK47aaAvPLRDKR/TcU8ttlZD5NBbQDurlt4B/FNXCyc=
X-Received: by 2002:a81:6784:: with SMTP id b126mr522550ywc.369.1568652969695;
 Mon, 16 Sep 2019 09:56:09 -0700 (PDT)
MIME-Version: 1.0
References: <20190915124733.31134-1-danieltimlee@gmail.com> <d6b935ae-64a7-a375-9825-72eaebafd8a4@fb.com>
In-Reply-To: <d6b935ae-64a7-a375-9825-72eaebafd8a4@fb.com>
From:   "Daniel T. Lee" <danieltimlee@gmail.com>
Date:   Tue, 17 Sep 2019 01:55:52 +0900
Message-ID: <CAEKGpzhDv_hGuM3Gyg99GePug=NdOpF+sTbyD4WG0OcwpxVHWg@mail.gmail.com>
Subject: Re: [bpf-next,v4] samples: bpf: add max_pckt_size option at xdp_adjust_tail
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

On Tue, Sep 17, 2019 at 1:07 AM Yonghong Song <yhs@fb.com> wrote:
>
>
>
> On 9/15/19 1:47 PM, Daniel T. Lee wrote:
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
> > Changes in v4:
> >      - make pckt_size no less than ICMP_TOOBIG_SIZE
> >      - Fix code style
> > Changes in v2:
> >      - Change the helper to fetch map from 'bpf_map__next' to
> >      'bpf_object__find_map_fd_by_name'.
> >
> >   samples/bpf/xdp_adjust_tail_kern.c | 23 +++++++++++++++++++----
> >   samples/bpf/xdp_adjust_tail_user.c | 28 ++++++++++++++++++++++------
> >   2 files changed, 41 insertions(+), 10 deletions(-)
>
> LGTM except a minor comments below.
> Acked-by: Yonghong Song <yhs@fb.com>
>
> bpf-next is closed. Please resubmit the patch once it is opened
> in around 2 weeks.
>
> >
> > diff --git a/samples/bpf/xdp_adjust_tail_kern.c b/samples/bpf/xdp_adjust_tail_kern.c
> > index 411fdb21f8bc..8869bbb160d2 100644
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
> >       int pckt_size = data_end - data;
> > +     __u32 *pckt_sz;
> > +     __u32 key = 0;
> >       int offset;
> >
> > -     if (pckt_size > MAX_PCKT_SIZE) {
> > +     pckt_sz = bpf_map_lookup_elem(&pcktsz, &key);
> > +     if (pckt_sz && *pckt_sz)
> > +             max_pckt_size = *pckt_sz;
> > +
> > +     if (pckt_size > max(max_pckt_size, ICMP_TOOBIG_SIZE)) {
> >               offset = pckt_size - ICMP_TOOBIG_SIZE;
> >               if (bpf_xdp_adjust_tail(xdp, 0 - offset))
> >                       return XDP_PASS;
> > -             return send_icmp4_too_big(xdp);
> > +             return send_icmp4_too_big(xdp, max_pckt_size);
> >       }
> >       return XDP_PASS;
> >   }
> > diff --git a/samples/bpf/xdp_adjust_tail_user.c b/samples/bpf/xdp_adjust_tail_user.c
> > index a3596b617c4c..99e965c68054 100644
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
> > +             if (map_fd < 0) {
> > +                     printf("finding a pcktsz map in obj file failed\n");
> > +                     return 1;
> > +             }
> > +             bpf_map_update_elem(map_fd, &key, &max_pckt_size, BPF_ANY);
> > +     }
> > +
> > +     /* fetch icmpcnt map */
> > +     map_fd = bpf_object__find_map_fd_by_name(obj, "icmpcnt");
> > +     if (map_fd < 0) {
> > +             printf("finding a icmpcnt map in obj file failed\n");
> >               return 1;
> >       }
> > -     map_fd = bpf_map__fd(map);
> >
> >       if (!prog_fd) {
> >               printf("load_bpf_file: %s\n", strerror(errno));
>
> Could you move the 'if (!prog_fd) ...' right after 'bpf_prog_load_xattr'
> for readability reason?
>
> Could you also change the condition 'if (!prog_fd)' to 'if (prog_fd <
> 0)'? You need to mention this fix in your commit message as well.


Thanks for the review!

I'll resubmit the patch with this changes included when bpf-next opens.
And also the commit message as well.

Thanks,
Daniel

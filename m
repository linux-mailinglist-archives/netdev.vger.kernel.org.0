Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0B046662726
	for <lists+netdev@lfdr.de>; Mon,  9 Jan 2023 14:33:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229642AbjAINdm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Jan 2023 08:33:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46430 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237062AbjAINco (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 Jan 2023 08:32:44 -0500
Received: from mail-yw1-x112a.google.com (mail-yw1-x112a.google.com [IPv6:2607:f8b0:4864:20::112a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EA6601EED5
        for <netdev@vger.kernel.org>; Mon,  9 Jan 2023 05:32:42 -0800 (PST)
Received: by mail-yw1-x112a.google.com with SMTP id 00721157ae682-4bf16baa865so112038507b3.13
        for <netdev@vger.kernel.org>; Mon, 09 Jan 2023 05:32:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=olTOKnPOgS/t+4/UoX5jAk49hINYRAGGMffFkFN4Zyg=;
        b=G6gQ8d/IvBZu3F0phv08SuiPHxUXSuiMOKjDhEh+YdFq1I7L7atA0RoEn9jsuTi86k
         ocwPkUn95iAasKCv1D4lBF77iihiuFsmx4pm/9MRsMjI18cuL6z/FaOats5iNfRPXIhZ
         XoBEyeC75IT7vej4dKP2MrrP3LY7Eydc+13aEQz8E0tSyG+OL4Uo7xuLbLPjmWXlrV0r
         oXaFLs9chOxbNDAeesqa64P2RMF22EVbyP03C5g4ZXllbJHFaAmO0nLcqaxLFqpM5K+4
         7NeNPuu0HXLpJiTRO8qHXcDa66gmglJuDHggCBILSNIEYAClWSXuX16Rhvgq3HdxgBX3
         kuDg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=olTOKnPOgS/t+4/UoX5jAk49hINYRAGGMffFkFN4Zyg=;
        b=HYC2dHwgoX6HyJYPXNJvjANje1/lC/Nuvq6osbQSTZLPPg2S4BsFKcAz5KDPNzt652
         p+Pe+kWYnrM0e50E/3sOR4rBdNypcZ3pns/N2lLxqNEJCEDELi2+Sj9R0VMz3aL2FMne
         sa3+Q2/PK/OzjABvS4HUK6zgCjryxk1o+jIp/U+8twA/03R5eEdgRRm2SLAhyBy6t4Of
         y6HAt+vIj21YLH5ahEyIdDEi4KuF2VFum34u+Nc5CTzlufnJVaL+eflPQKQha4Tbgg97
         PKKn4X0X8HgGdnS/5Kn5sRZuzaWyJEwX1LeiEYm026G2K9nix1nLJsOyTZofZHeHAujy
         Z7pA==
X-Gm-Message-State: AFqh2kqCzkuwuntWVoMsjZK8EQnD/ZRLx5lvgFXPW+emRznOBYeWkvIv
        SIwAtE9FJiGJNTPvr+hwAepWfwQjLfM1m1Wod6sFhA==
X-Google-Smtp-Source: AMrXdXsLkT9+aDSKB/tl/3oeQXVB7Ro0cimypp97ea7ZYM3G78SCsOvtnytn6p78vuCkM3SRVQjtEPScBVde134tKGA=
X-Received: by 2002:a05:690c:fd1:b0:4ac:cd7c:18d2 with SMTP id
 dg17-20020a05690c0fd100b004accd7c18d2mr2410681ywb.427.1673271162057; Mon, 09
 Jan 2023 05:32:42 -0800 (PST)
MIME-Version: 1.0
References: <cover.1672976410.git.william.xuanziyang@huawei.com>
 <7e9ca6837b20bea661248957dbbd1db198e3d1f8.1672976410.git.william.xuanziyang@huawei.com>
 <Y7h8yrOEkPuHkNpJ@google.com> <CA+FuTSdZ+za55p1kKOcGby89F_ybRhAfy2cG0R+Y00yaJTbVkg@mail.gmail.com>
 <4d0e5f2b-d088-58f4-d86d-00aa444d77c0@huawei.com>
In-Reply-To: <4d0e5f2b-d088-58f4-d86d-00aa444d77c0@huawei.com>
From:   Willem de Bruijn <willemb@google.com>
Date:   Mon, 9 Jan 2023 08:32:05 -0500
Message-ID: <CA+FuTSeE-S9_Uc6Cqs=EqYZd-K6kj=Ex4sudNx7u8HMLcrereQ@mail.gmail.com>
Subject: Re: [PATCH bpf-next 1/2] bpf: Add ipip6 and ip6ip decap support for bpf_skb_adjust_room()
To:     "Ziyang Xuan (William)" <william.xuanziyang@huawei.com>
Cc:     ast@kernel.org, daniel@iogearbox.net, andrii@kernel.org,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, bpf@vger.kernel.org, netdev@vger.kernel.org,
        martin.lau@linux.dev, song@kernel.org, yhs@fb.com,
        john.fastabend@gmail.com, kpsingh@kernel.org, haoluo@google.com,
        jolsa@kernel.org, sdf@google.com
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jan 9, 2023 at 4:20 AM Ziyang Xuan (William)
<william.xuanziyang@huawei.com> wrote:
>
> > On Fri, Jan 6, 2023 at 2:55 PM <sdf@google.com> wrote:
> >>
> >> On 01/06, Ziyang Xuan wrote:
> >>> Add ipip6 and ip6ip decap support for bpf_skb_adjust_room().
> >>> Main use case is for using cls_bpf on ingress hook to decapsulate
> >>> IPv4 over IPv6 and IPv6 over IPv4 tunnel packets.
> >>
> >> CC'd Willem since he has done bpf_skb_adjust_room changes in the past.
> >> There might be a lot of GRO/GSO context I'm missing.
> >>
> >>> Signed-off-by: Ziyang Xuan <william.xuanziyang@huawei.com>
> >>> ---
> >>>   net/core/filter.c | 34 ++++++++++++++++++++++++++++++++--
> >>>   1 file changed, 32 insertions(+), 2 deletions(-)
> >>
> >>> diff --git a/net/core/filter.c b/net/core/filter.c
> >>> index 929358677183..73982fb4fe2e 100644
> >>> --- a/net/core/filter.c
> >>> +++ b/net/core/filter.c
> >>> @@ -3495,6 +3495,12 @@ static int bpf_skb_net_grow(struct sk_buff *skb,
> >>> u32 off, u32 len_diff,
> >>>   static int bpf_skb_net_shrink(struct sk_buff *skb, u32 off, u32 len_diff,
> >>>                             u64 flags)
> >>>   {
> >>> +     union {
> >>> +             struct iphdr *v4;
> >>> +             struct ipv6hdr *v6;
> >>> +             unsigned char *hdr;
> >>> +     } ip;
> >>> +     __be16 proto;
> >>>       int ret;
> >>
> >>>       if (unlikely(flags & ~(BPF_F_ADJ_ROOM_FIXED_GSO |
> >>> @@ -3512,10 +3518,19 @@ static int bpf_skb_net_shrink(struct sk_buff
> >>> *skb, u32 off, u32 len_diff,
> >>>       if (unlikely(ret < 0))
> >>>               return ret;
> >>
> >>> +     ip.hdr = skb_inner_network_header(skb);
> >>> +     if (ip.v4->version == 4)
> >>> +             proto = htons(ETH_P_IP);
> >>> +     else
> >>> +             proto = htons(ETH_P_IPV6);
> >>> +
> >>>       ret = bpf_skb_net_hdr_pop(skb, off, len_diff);
> >>>       if (unlikely(ret < 0))
> >>>               return ret;
> >>
> >>> +     /* Match skb->protocol to new outer l3 protocol */
> >>> +     skb->protocol = proto;
> >>> +
> >>>       if (skb_is_gso(skb)) {
> >>>               struct skb_shared_info *shinfo = skb_shinfo(skb);
> >>
> >>> @@ -3578,10 +3593,14 @@ BPF_CALL_4(bpf_skb_adjust_room, struct sk_buff *,
> >>> skb, s32, len_diff,
> >>>          u32, mode, u64, flags)
> >>>   {
> >>>       u32 len_cur, len_diff_abs = abs(len_diff);
> >>> -     u32 len_min = bpf_skb_net_base_len(skb);
> >>> -     u32 len_max = BPF_SKB_MAX_LEN;
> >>> +     u32 len_min, len_max = BPF_SKB_MAX_LEN;
> >>>       __be16 proto = skb->protocol;
> >>>       bool shrink = len_diff < 0;
> >>> +     union {
> >>> +             struct iphdr *v4;
> >>> +             struct ipv6hdr *v6;
> >>> +             unsigned char *hdr;
> >>> +     } ip;
> >>>       u32 off;
> >>>       int ret;
> >>
> >>> @@ -3594,6 +3613,9 @@ BPF_CALL_4(bpf_skb_adjust_room, struct sk_buff *,
> >>> skb, s32, len_diff,
> >>>                    proto != htons(ETH_P_IPV6)))
> >>>               return -ENOTSUPP;
> >>
> >>> +     if (unlikely(shrink && !skb->encapsulation))
> >>> +             return -ENOTSUPP;
> >>> +
> >
> > This new restriction might break existing users.
> >
> > There is no pre-existing requirement that shrink is used solely with
> > packets encapsulated by the protocol stack.
> >
> > Indeed, skb->encapsulation is likely not set on packets arriving from
> > the wire, even if encapsulated. Referring to your comment "Main use
> > case is for using cls_bpf on ingress hook to decapsulate"
> >
> > Can a combination of the existing bpf_skb_adjust_room and
> > bpf_skb_change_proto address your problem?
>
> Hello Willem,
>
> I think combination bpf_skb_adjust_room and bpf_skb_change_proto can not
> address my problem.
>
> Now, bpf_skb_adjust_room() would fail for "len_cur - len_diff_abs < len_min"
> when decap ipip6 packet, because "len_min" should be sizeof(struct iphdr)
> but not sizeof(struct ipv6hdr).
>
> We can remove skb->encapsulation restriction and parse outer and inner IP
> header to determine ipip6 and ip6ip packets. As following:

Adding logic for network layer protocol conversion like this looks
good to me. bpf_skb_adjust_room already has a few other metadata
quirks.

But like those, let's make this intent explicit: define a new flag
that requests this behavior.

Let's avoid introducing a new union. Just use check (ip_hdr(skb)->version == 4).

>
> --- a/net/core/filter.c
> +++ b/net/core/filter.c
> @@ -3498,6 +3498,12 @@ static int bpf_skb_net_grow(struct sk_buff *skb, u32 off, u32 len_diff,
>  static int bpf_skb_net_shrink(struct sk_buff *skb, u32 off, u32 len_diff,
>                               u64 flags)
>  {
> +       union {
> +               struct iphdr *v4;
> +               struct ipv6hdr *v6;
> +               unsigned char *hdr;
> +       } ip;
> +       __be16 proto;
>         int ret;
>
>         if (unlikely(flags & ~(BPF_F_ADJ_ROOM_FIXED_GSO |
> @@ -3515,10 +3521,23 @@ static int bpf_skb_net_shrink(struct sk_buff *skb, u32 off, u32 len_diff,
>         if (unlikely(ret < 0))
>                 return ret;
>
> +       ip.hdr = skb_network_header(skb);
> +       if (ip.v4->version == 4) {
> +               if (ip.v4->protocol == IPPROTO_IPV6)
> +                       proto = htons(ETH_P_IPV6);
> +       } else {
> +               struct ipv6_opt_hdr *opt_hdr = (struct ipv6_opt_hdr *)(skb_network_header(skb) + sizeof(struct ipv6hdr));
> +               if (ip.v6->nexthdr == NEXTHDR_DEST && opt_hdr->nexthdr == NEXTHDR_IPV4)
> +                       proto = htons(ETH_P_IP);
> +       }
> +
>         ret = bpf_skb_net_hdr_pop(skb, off, len_diff);
>         if (unlikely(ret < 0))
>                 return ret;
>
> +       /* Match skb->protocol to new outer l3 protocol */
> +       skb->protocol = proto;
> +
>         if (skb_is_gso(skb)) {
>                 struct skb_shared_info *shinfo = skb_shinfo(skb);
>
> @@ -3585,6 +3604,11 @@ BPF_CALL_4(bpf_skb_adjust_room, struct sk_buff *, skb, s32, len_diff,
>         u32 len_max = BPF_SKB_MAX_LEN;
>         __be16 proto = skb->protocol;
>         bool shrink = len_diff < 0;
> +       union {
> +               struct iphdr *v4;
> +               struct ipv6hdr *v6;
> +               unsigned char *hdr;
> +       } ip;
>         u32 off;
>         int ret;
>
> @@ -3608,6 +3632,19 @@ BPF_CALL_4(bpf_skb_adjust_room, struct sk_buff *, skb, s32, len_diff,
>                 return -ENOTSUPP;
>         }
>
> +       if (shrink) {
> +               ip.hdr = skb_network_header(skb);
> +               if (ip.v4->version == 4) {
> +                       if (ip.v4->protocol == IPPROTO_IPV6)
> +                               len_min = sizeof(struct ipv6hdr);
> +               } else {
> +                       struct ipv6_opt_hdr *opt_hdr = (struct ipv6_opt_hdr *)(skb_network_header(skb) + sizeof(struct ipv6hdr));
> +                       if (ip.v6->nexthdr == NEXTHDR_DEST && opt_hdr->nexthdr == NEXTHDR_IPV4) {
> +                               len_min = sizeof(struct iphdr);
> +                       }
> +               }
> +       }
> +
>         len_cur = skb->len - skb_network_offset(skb);
>
>
> Look forward to your comments and suggestions.
>
> Thank you!
>
> >
> >>>       off = skb_mac_header_len(skb);
> >>>       switch (mode) {
> >>>       case BPF_ADJ_ROOM_NET:
> >>> @@ -3605,6 +3627,14 @@ BPF_CALL_4(bpf_skb_adjust_room, struct sk_buff *,
> >>> skb, s32, len_diff,
> >>>               return -ENOTSUPP;
> >>>       }
> >>
> >>> +     if (shrink) {
> >>> +             ip.hdr = skb_inner_network_header(skb);
> >>> +             if (ip.v4->version == 4)
> >>> +                     len_min = sizeof(struct iphdr);
> >>> +             else
> >>> +                     len_min = sizeof(struct ipv6hdr);
> >>> +     }
> >>> +
> >>>       len_cur = skb->len - skb_network_offset(skb);
> >>>       if ((shrink && (len_diff_abs >= len_cur ||
> >>>                       len_cur - len_diff_abs < len_min)) ||
> >>> --
> >>> 2.25.1
> >>
> > .
> >

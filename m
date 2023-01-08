Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1CD7C66187A
	for <lists+netdev@lfdr.de>; Sun,  8 Jan 2023 20:17:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233471AbjAHTRD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 8 Jan 2023 14:17:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44204 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233104AbjAHTRB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 8 Jan 2023 14:17:01 -0500
Received: from mail-yb1-xb36.google.com (mail-yb1-xb36.google.com [IPv6:2607:f8b0:4864:20::b36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EF8552602
        for <netdev@vger.kernel.org>; Sun,  8 Jan 2023 11:16:57 -0800 (PST)
Received: by mail-yb1-xb36.google.com with SMTP id c124so6753935ybb.13
        for <netdev@vger.kernel.org>; Sun, 08 Jan 2023 11:16:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=8Er/+EiMLnn2MKOdED8S8DUPSutRL5plgxPKOLwEBOA=;
        b=b62kpT+jNiZkYzBUrwAjmCq0+LwNmLNCpUNp0qj/LQg3ja1haJJayz5RAOSi8e/tLD
         pIBLeTmrtEKjxN1jJzEfaPSKLGbr9BbgiszrvLswEANsF0LoyE0U5RYA8nvVCh97Yj0+
         GUl5A8DsUZfMbnF3QBEo49wl0n6TpF2VMoOyd4Y62AayhLxADAI07K0y6sVLqQNzeAvh
         YQTAuHlc/jqHIx+5TViii0lHZhmMDZ8iXbUwD+cpEqRzJ+3zGRrlwBJ+wPWqgjK8Tyl8
         1dsgrXn9BV6DeGH+rYoaT0quA0NlMRaZQKuBt0TG6DjVVoMqjmz/uO5ADetuuGlNi3FF
         fFKw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=8Er/+EiMLnn2MKOdED8S8DUPSutRL5plgxPKOLwEBOA=;
        b=ETXOhvCG3EGlDXwdI1A3oZLCEol2L11xQPCS4BHqY90kb4c7WnTMo30L3c4RXhawxA
         9ctO2OaSnE5WNtRk9zoN0+NZfoNI7YseY7yhaHRig6noTTC/q/oUCntaV3ghvGwpygv1
         vSBCPisGm/oc3SWChRG2DfsAUjg6KOUUm0FFXQ5dYLj3dYAG22zYq4G9MEjttwjBbf6D
         P+waYTYrLz5IqXs510ZqUWcZkQLJFiTsnB48leA/Zb5jFtor5djd7JsvzhAABc0V/sVb
         Vons0iJ7fLDh/ISU5g5m9O7NjZSuJalpqOsntDAPFx2Xc+aZcSdz7S35Fg0EeoV1KsnJ
         5ExA==
X-Gm-Message-State: AFqh2krBybPA09bIuSHe0wlIWA2/srtEWb3TJMGUIyYp/wyjxmx32aDl
        vUbH+byP8f0Z+ZTJ3cfgH2JGMv+m+TYaMv9xQzjzCg==
X-Google-Smtp-Source: AMrXdXv9u1GJ+TrQhYZOYcZZpBtGnkyLnuLoYleIexHo9LA7cdegAieoGhDUCR410+YPzXH0UXT2U57JRLrH3lpLeZ8=
X-Received: by 2002:a25:d8d4:0:b0:7b8:16c:e66d with SMTP id
 p203-20020a25d8d4000000b007b8016ce66dmr1228558ybg.85.1673205417106; Sun, 08
 Jan 2023 11:16:57 -0800 (PST)
MIME-Version: 1.0
References: <cover.1672976410.git.william.xuanziyang@huawei.com>
 <7e9ca6837b20bea661248957dbbd1db198e3d1f8.1672976410.git.william.xuanziyang@huawei.com>
 <Y7h8yrOEkPuHkNpJ@google.com>
In-Reply-To: <Y7h8yrOEkPuHkNpJ@google.com>
From:   Willem de Bruijn <willemb@google.com>
Date:   Sun, 8 Jan 2023 14:16:20 -0500
Message-ID: <CA+FuTSdZ+za55p1kKOcGby89F_ybRhAfy2cG0R+Y00yaJTbVkg@mail.gmail.com>
Subject: Re: [PATCH bpf-next 1/2] bpf: Add ipip6 and ip6ip decap support for bpf_skb_adjust_room()
To:     Ziyang Xuan <william.xuanziyang@huawei.com>
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
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jan 6, 2023 at 2:55 PM <sdf@google.com> wrote:
>
> On 01/06, Ziyang Xuan wrote:
> > Add ipip6 and ip6ip decap support for bpf_skb_adjust_room().
> > Main use case is for using cls_bpf on ingress hook to decapsulate
> > IPv4 over IPv6 and IPv6 over IPv4 tunnel packets.
>
> CC'd Willem since he has done bpf_skb_adjust_room changes in the past.
> There might be a lot of GRO/GSO context I'm missing.
>
> > Signed-off-by: Ziyang Xuan <william.xuanziyang@huawei.com>
> > ---
> >   net/core/filter.c | 34 ++++++++++++++++++++++++++++++++--
> >   1 file changed, 32 insertions(+), 2 deletions(-)
>
> > diff --git a/net/core/filter.c b/net/core/filter.c
> > index 929358677183..73982fb4fe2e 100644
> > --- a/net/core/filter.c
> > +++ b/net/core/filter.c
> > @@ -3495,6 +3495,12 @@ static int bpf_skb_net_grow(struct sk_buff *skb,
> > u32 off, u32 len_diff,
> >   static int bpf_skb_net_shrink(struct sk_buff *skb, u32 off, u32 len_diff,
> >                             u64 flags)
> >   {
> > +     union {
> > +             struct iphdr *v4;
> > +             struct ipv6hdr *v6;
> > +             unsigned char *hdr;
> > +     } ip;
> > +     __be16 proto;
> >       int ret;
>
> >       if (unlikely(flags & ~(BPF_F_ADJ_ROOM_FIXED_GSO |
> > @@ -3512,10 +3518,19 @@ static int bpf_skb_net_shrink(struct sk_buff
> > *skb, u32 off, u32 len_diff,
> >       if (unlikely(ret < 0))
> >               return ret;
>
> > +     ip.hdr = skb_inner_network_header(skb);
> > +     if (ip.v4->version == 4)
> > +             proto = htons(ETH_P_IP);
> > +     else
> > +             proto = htons(ETH_P_IPV6);
> > +
> >       ret = bpf_skb_net_hdr_pop(skb, off, len_diff);
> >       if (unlikely(ret < 0))
> >               return ret;
>
> > +     /* Match skb->protocol to new outer l3 protocol */
> > +     skb->protocol = proto;
> > +
> >       if (skb_is_gso(skb)) {
> >               struct skb_shared_info *shinfo = skb_shinfo(skb);
>
> > @@ -3578,10 +3593,14 @@ BPF_CALL_4(bpf_skb_adjust_room, struct sk_buff *,
> > skb, s32, len_diff,
> >          u32, mode, u64, flags)
> >   {
> >       u32 len_cur, len_diff_abs = abs(len_diff);
> > -     u32 len_min = bpf_skb_net_base_len(skb);
> > -     u32 len_max = BPF_SKB_MAX_LEN;
> > +     u32 len_min, len_max = BPF_SKB_MAX_LEN;
> >       __be16 proto = skb->protocol;
> >       bool shrink = len_diff < 0;
> > +     union {
> > +             struct iphdr *v4;
> > +             struct ipv6hdr *v6;
> > +             unsigned char *hdr;
> > +     } ip;
> >       u32 off;
> >       int ret;
>
> > @@ -3594,6 +3613,9 @@ BPF_CALL_4(bpf_skb_adjust_room, struct sk_buff *,
> > skb, s32, len_diff,
> >                    proto != htons(ETH_P_IPV6)))
> >               return -ENOTSUPP;
>
> > +     if (unlikely(shrink && !skb->encapsulation))
> > +             return -ENOTSUPP;
> > +

This new restriction might break existing users.

There is no pre-existing requirement that shrink is used solely with
packets encapsulated by the protocol stack.

Indeed, skb->encapsulation is likely not set on packets arriving from
the wire, even if encapsulated. Referring to your comment "Main use
case is for using cls_bpf on ingress hook to decapsulate"

Can a combination of the existing bpf_skb_adjust_room and
bpf_skb_change_proto address your problem?

> >       off = skb_mac_header_len(skb);
> >       switch (mode) {
> >       case BPF_ADJ_ROOM_NET:
> > @@ -3605,6 +3627,14 @@ BPF_CALL_4(bpf_skb_adjust_room, struct sk_buff *,
> > skb, s32, len_diff,
> >               return -ENOTSUPP;
> >       }
>
> > +     if (shrink) {
> > +             ip.hdr = skb_inner_network_header(skb);
> > +             if (ip.v4->version == 4)
> > +                     len_min = sizeof(struct iphdr);
> > +             else
> > +                     len_min = sizeof(struct ipv6hdr);
> > +     }
> > +
> >       len_cur = skb->len - skb_network_offset(skb);
> >       if ((shrink && (len_diff_abs >= len_cur ||
> >                       len_cur - len_diff_abs < len_min)) ||
> > --
> > 2.25.1
>

Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E53044A91EA
	for <lists+netdev@lfdr.de>; Fri,  4 Feb 2022 02:16:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356385AbiBDBO6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Feb 2022 20:14:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37766 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1355032AbiBDBO5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Feb 2022 20:14:57 -0500
Received: from mail-yb1-xb2e.google.com (mail-yb1-xb2e.google.com [IPv6:2607:f8b0:4864:20::b2e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1A1BAC061714
        for <netdev@vger.kernel.org>; Thu,  3 Feb 2022 17:14:57 -0800 (PST)
Received: by mail-yb1-xb2e.google.com with SMTP id 23so14314843ybf.7
        for <netdev@vger.kernel.org>; Thu, 03 Feb 2022 17:14:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=3xOpsB2g/ZDq/ZOdf8lZ52bsr3jRDcogYrT6MLgcv0E=;
        b=kKa+Cg+mDVEPXfgm3F0QygpSiA5QhIKbwtHR4Vwh2XxbvPDQiwKzaXpkRYmtB2pe33
         KFiriid9p9D99N+5gsuu+KY3tycNQJaH57dq/qbfeAGfC/bUBXGRqd20cqz3Zi274PPn
         xZPjkgPJz4WGx4ncLGaHFiaNr6zR3PPc5ohblIgARJmp6Qw17lo6DxhYxw8tIXLIVCZC
         agfPg++8T9DHS/e+mwgiAWxVLed9cmAOaLkenMVFx4zMrju/aAof06OFXz0SSUMq373y
         FamQWrR7InEd+vm/9fJA6wYWRwxoDgZ6ojDJ0ZIReHmNICFZzzaIUI0HDVeP8rtio0OR
         lQ3w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=3xOpsB2g/ZDq/ZOdf8lZ52bsr3jRDcogYrT6MLgcv0E=;
        b=T8TNlLha7DaUCCwrGXiNy5VbeHGg3ZkQZECusZ8A4vLZrWy01caDgKmUMZhxq1SL3Y
         B7bsg8wvDqku9QaApN4aT3iqlFpJ/z+fXrwBwh/kUJo6XPv0CZhQ2lLHULjBdRtOIiet
         NGVqemFFOO6pbsxXMpNDD9XomaFud2AjC6x+r2ga/S4iP5G/lbnVKSVJTjo1IgB0nWrD
         dl0IIeq7ydYX/QhTcCL92s1l59qqz9qBLeH7RSjyKc2MAQ6lt90o0OEQVQ3mPHKZZdDR
         6o5rZp60wywSV811+zRg6Sk0L9S9/CqBcRU6SrtDeLJbvH0Cu4OZ8DKOeni2SE+MZcBk
         Virw==
X-Gm-Message-State: AOAM531jmbirDfr04dZKAmRyHACpEE1ks0PJ60rBwDEjdc9QcCUGLIvj
        gyiwLZH7SD5T13JPlgyQu5aYuM2vrse26QMWmJ5sYA==
X-Google-Smtp-Source: ABdhPJxsLQ0RKzEsWcHng+0jtWsr7sz42l3Fvf3GjG2uM7aCVHALAu7vUjohXnx8/Qh2cKbTvl5E/im+6My9DRmyXKY=
X-Received: by 2002:a25:4f41:: with SMTP id d62mr878480ybb.156.1643937295880;
 Thu, 03 Feb 2022 17:14:55 -0800 (PST)
MIME-Version: 1.0
References: <20220203015140.3022854-1-eric.dumazet@gmail.com>
 <20220203015140.3022854-6-eric.dumazet@gmail.com> <0d3cbdeee93fe7b72f3cdfc07fd364244d3f4f47.camel@gmail.com>
 <CANn89iK7snFJ2GQ6cuDc2t4LC-Ufzki5TaQrLwDOWE8qDyYATQ@mail.gmail.com>
 <CAKgT0UfWd2PyOhVht8ZMpRf1wpVwnJbXxxT68M-hYK9QRZuz2w@mail.gmail.com>
 <CANn89iKzDxLHTVTcu=y_DZgdTHk5w1tv7uycL27aK1joPYbasA@mail.gmail.com>
 <802be507c28b9c1815e6431e604964b79070cd40.camel@gmail.com>
 <CANn89iLLgF6f6YQkd26OxL0Fy3hUEx2KQ+PBQ7p6w8zRUpaC_w@mail.gmail.com>
 <CAKgT0UcGoqJ5426JrKeOAhdm5izSAB1_9+X_bbB23Ws34PKASA@mail.gmail.com> <CANn89iLkx34cnAJboMdRSbQz63OnD7ttxnEX6gMacjWdEL+7Eg@mail.gmail.com>
In-Reply-To: <CANn89iLkx34cnAJboMdRSbQz63OnD7ttxnEX6gMacjWdEL+7Eg@mail.gmail.com>
From:   Eric Dumazet <edumazet@google.com>
Date:   Thu, 3 Feb 2022 17:14:44 -0800
Message-ID: <CANn89iJjwuN6hv7CuvR3n5efwo4MjV+Xe2byK7wy4k0AXkJkzg@mail.gmail.com>
Subject: Re: [PATCH net-next 05/15] ipv6/gso: remove temporary HBH/jumbo header
To:     Alexander Duyck <alexander.duyck@gmail.com>
Cc:     Eric Dumazet <eric.dumazet@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        netdev <netdev@vger.kernel.org>, Coco Li <lixiaoyan@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Feb 3, 2022 at 4:27 PM Eric Dumazet <edumazet@google.com> wrote:
>
> On Thu, Feb 3, 2022 at 4:05 PM Alexander Duyck
> <alexander.duyck@gmail.com> wrote:
> >
>
> > I get that. What I was getting at was that we might be able to process
> > it in ipv6_gso_segment before we hand it off to either TCP or UDP gso
> > handlers to segment.
> >
> > The general idea being we keep the IPv6 specific bits in the IPv6
> > specific code instead of having the skb_segment function now have to
> > understand IPv6 packets. So what we would end up doing is having to do
> > an skb_cow to replace the skb->head if any clones might be holding on
> > it, and then just chop off the HBH jumbo header before we start the
> > segmenting.
> >
> > The risk would be that we waste cycles removing the HBH header for a
> > frame that is going to fail, but I am not sure how likely a scenario
> > that is or if we need to optimize for that.
>
> I guess I can try this for the next version, thanks.

I came up with:

ommit 147f17169ccc6c2c38ea802e5728528ed54f492d
Author: Eric Dumazet <edumazet@google.com>
Date:   Sat Nov 20 16:49:35 2021 -0800

    ipv6/gso: remove temporary HBH/jumbo header

    ipv6 tcp and gro stacks will soon be able to build big TCP packets,
    with an added temporary Hop By Hop header.

    If GSO is involved for these large packets, we need to remove
    the temporary HBH header before segmentation happens.

    v2: perform HBH removal from ipv6_gso_segment() instead of
        skb_segment() (Alexander feedback)

    Signed-off-by: Eric Dumazet <edumazet@google.com>

diff --git a/include/net/ipv6.h b/include/net/ipv6.h
index ea2a4351b654f8bc96503aae2b9adcd478e1f8b2..a850c18dae0dfedccb9d956bf1ec9fa6b0368c6b
100644
--- a/include/net/ipv6.h
+++ b/include/net/ipv6.h
@@ -464,6 +464,38 @@ bool ipv6_opt_accepted(const struct sock *sk,
const struct sk_buff *skb,
 struct ipv6_txoptions *ipv6_update_options(struct sock *sk,
                                           struct ipv6_txoptions *opt);

+/* This helper is specialized for BIG TCP needs.
+ * It assumes the hop_jumbo_hdr will immediately follow the IPV6 header.
+ * It assumes headers are already in skb->head, thus the sk argument
is only read.
+ */
+static inline bool ipv6_has_hopopt_jumbo(const struct sk_buff *skb)
+{
+       const struct hop_jumbo_hdr *jhdr;
+       const struct ipv6hdr *nhdr;
+
+       if (likely(skb->len <= GRO_MAX_SIZE))
+               return false;
+
+       if (skb->protocol != htons(ETH_P_IPV6))
+               return false;
+
+       if (skb_network_offset(skb) +
+           sizeof(struct ipv6hdr) +
+           sizeof(struct hop_jumbo_hdr) > skb_headlen(skb))
+               return false;
+
+       nhdr = ipv6_hdr(skb);
+
+       if (nhdr->nexthdr != NEXTHDR_HOP)
+               return false;
+
+       jhdr = (const struct hop_jumbo_hdr *) (nhdr + 1);
+       if (jhdr->tlv_type != IPV6_TLV_JUMBO || jhdr->hdrlen != 0 ||
+           jhdr->nexthdr != IPPROTO_TCP)
+               return false;
+       return true;
+}
+
 static inline bool ipv6_accept_ra(struct inet6_dev *idev)
 {
        /* If forwarding is enabled, RA are not accepted unless the special
diff --git a/net/ipv6/ip6_offload.c b/net/ipv6/ip6_offload.c
index d37a79a8554e92a1dcaa6fd023cafe2114841ece..7f65097c8f30fa19a8c9c265eb4f027e91848021
100644
--- a/net/ipv6/ip6_offload.c
+++ b/net/ipv6/ip6_offload.c
@@ -87,6 +87,27 @@ static struct sk_buff *ipv6_gso_segment(struct sk_buff *skb,
        bool gso_partial;

        skb_reset_network_header(skb);
+       if (ipv6_has_hopopt_jumbo(skb)) {
+               const int hophdr_len = sizeof(struct hop_jumbo_hdr);
+               int err;
+
+               err = skb_cow_head(skb, 0);
+               if (err < 0)
+                       return ERR_PTR(err);
+
+               /* remove the HBH header.
+                * Layout: [Ethernet header][IPv6 header][HBH][TCP header]
+                */
+               memmove(skb->data + hophdr_len,
+                       skb->data,
+                       ETH_HLEN + sizeof(struct ipv6hdr));
+               skb->data += hophdr_len;
+               skb->len -= hophdr_len;
+               skb->network_header += hophdr_len;
+               skb->mac_header += hophdr_len;
+               ipv6h = (struct ipv6hdr *)skb->data;
+               ipv6h->nexthdr = IPPROTO_TCP;
+       }
        nhoff = skb_network_header(skb) - skb_mac_header(skb);
        if (unlikely(!pskb_may_pull(skb, sizeof(*ipv6h))))
                goto out;

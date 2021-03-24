Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 368F1346F01
	for <lists+netdev@lfdr.de>; Wed, 24 Mar 2021 02:47:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231794AbhCXBqu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Mar 2021 21:46:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54234 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231803AbhCXBqa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 23 Mar 2021 21:46:30 -0400
Received: from mail-ed1-x529.google.com (mail-ed1-x529.google.com [IPv6:2a00:1450:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 971A9C061763
        for <netdev@vger.kernel.org>; Tue, 23 Mar 2021 18:46:29 -0700 (PDT)
Received: by mail-ed1-x529.google.com with SMTP id z1so25795187edb.8
        for <netdev@vger.kernel.org>; Tue, 23 Mar 2021 18:46:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Eff2FWfXc4a+6GtOAiIZD/2SNSsblsYfsYdnervL3yw=;
        b=b1qHd58RPOSfyXdv+QMIxeIaygAdIIaMlO7F6N0bzmFsETtcNgzfvXN3n/nzQ9qGzL
         jMRqvaPlVBbQLV4kcJv26tTU10UPk/ehUT4g7mG19q4TQiHZeZzLoAD7anmzRl4eW1Ac
         qnjKHK3YjSJZ5Y4gIspk5YEqwwoGzvQUvZO7lif7UjM+7B0kxafkqReCM9JUzoxXl4Bh
         qIT+HTfCHFE0MofZ/NfqzAdqcEskIGceTyaBriKGlvDxiOys9+I3NVr7LBLPKOYVjKHP
         P4HOFx8ymr3bU4m5xzZW4zdF0HMUymsbu17x9dj1iWq5+lWjrTNDO3TO/6XgFocZCh+v
         9lqQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Eff2FWfXc4a+6GtOAiIZD/2SNSsblsYfsYdnervL3yw=;
        b=RgYOLj5xuKjPP9HPwao6Fc3WEbVfBqffIwo4B4llKB6LJIKJ+ChhOJRMVO6uVho+X4
         HppyYx+58VijPT7ooHzuZMixmckOPo2+rBvVRl6bOdgcgQWlgy+wfPKbS61bXioIdSxX
         Swas1suzZUOJ8BhXOgbTCJijFkat7iP+zyJ0VlOuPF4ioW1ndcHwgnvGmwbLxaLTVSY3
         M0uXfeRhXnRGyd53yyuIhoP18XWwVTG1VXEbrw6zqTUYjScXYyKw9S1Rs5yMqPib59e+
         2X1wDGmJl2nuM7Y6QMDwggglndBxvqyePCokuP97NMnUUhPaPu7+vDFeK3f7AKW32AOk
         fmLA==
X-Gm-Message-State: AOAM533oqghEsMQd0wctyWPaEKyH3TZ0hwPvdbfjwLrT+yWY46nMYSd+
        ToV7FDfmYs43WXr5gcdwKHP89bHhVu4=
X-Google-Smtp-Source: ABdhPJwTtvLLMMfkHFRrxOQEai1HBmW7FAGdpzbtxNiSG5NmEN2LEva2oqFq8w8Ww4+AwBMna78zBw==
X-Received: by 2002:a05:6402:1d92:: with SMTP id dk18mr754594edb.161.1616550387720;
        Tue, 23 Mar 2021 18:46:27 -0700 (PDT)
Received: from mail-wm1-f46.google.com (mail-wm1-f46.google.com. [209.85.128.46])
        by smtp.gmail.com with ESMTPSA id p27sm203630eja.79.2021.03.23.18.46.26
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 23 Mar 2021 18:46:26 -0700 (PDT)
Received: by mail-wm1-f46.google.com with SMTP id a132-20020a1c668a0000b029010f141fe7c2so316250wmc.0
        for <netdev@vger.kernel.org>; Tue, 23 Mar 2021 18:46:26 -0700 (PDT)
X-Received: by 2002:a1c:2155:: with SMTP id h82mr566408wmh.169.1616550385545;
 Tue, 23 Mar 2021 18:46:25 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1616345643.git.pabeni@redhat.com> <4bff28fbaa8c53ca836eb2b9bdabcc3057118916.1616345643.git.pabeni@redhat.com>
 <CA+FuTScSPJAh+6XnwnP32W+OmEzCVi8aKundnt2dJNzoKgUthg@mail.gmail.com> <43f56578c91f8abd8e3d1e8c73be1c4d5162089f.camel@redhat.com>
In-Reply-To: <43f56578c91f8abd8e3d1e8c73be1c4d5162089f.camel@redhat.com>
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Date:   Tue, 23 Mar 2021 21:45:47 -0400
X-Gmail-Original-Message-ID: <CA+FuTSd6fOaj6bJssyXeyL-LWvSEdSH+QchHUG8Ga-=EQ634Lg@mail.gmail.com>
Message-ID: <CA+FuTSd6fOaj6bJssyXeyL-LWvSEdSH+QchHUG8Ga-=EQ634Lg@mail.gmail.com>
Subject: Re: [PATCH net-next 1/8] udp: fixup csum for GSO receive slow path
To:     Paolo Abeni <pabeni@redhat.com>
Cc:     Network Development <netdev@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        Alexander Lobakin <alobakin@pm.me>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Mar 22, 2021 at 12:36 PM Paolo Abeni <pabeni@redhat.com> wrote:
>
> On Mon, 2021-03-22 at 09:18 -0400, Willem de Bruijn wrote:
> > On Sun, Mar 21, 2021 at 1:01 PM Paolo Abeni <pabeni@redhat.com> wrote:
> > > When looping back UDP GSO over UDP tunnel packets to an UDP socket,
> > > the individual packet csum is currently set to CSUM_NONE. That causes
> > > unexpected/wrong csum validation errors later in the UDP receive path.
> > >
> > > We could possibly addressing the issue with some additional check and
> > > csum mangling in the UDP tunnel code. Since the issue affects only
> > > this UDP receive slow path, let's set a suitable csum status there.
> > >
> > > Signed-off-by: Paolo Abeni <pabeni@redhat.com>
> > > ---
> > >  include/net/udp.h | 18 ++++++++++++++++++
> > >  net/ipv4/udp.c    | 10 ++++++++++
> > >  net/ipv6/udp.c    |  5 +++++
> > >  3 files changed, 33 insertions(+)
> > >
> > > diff --git a/include/net/udp.h b/include/net/udp.h
> > > index d4d064c592328..007683eb3e113 100644
> > > --- a/include/net/udp.h
> > > +++ b/include/net/udp.h
> > > @@ -515,6 +515,24 @@ static inline struct sk_buff *udp_rcv_segment(struct sock *sk,
> > >         return segs;
> > >  }
> > >
> > > +static inline void udp_post_segment_fix_csum(struct sk_buff *skb, int level)
> > > +{
> > > +       /* UDP-lite can't land here - no GRO */
> > > +       WARN_ON_ONCE(UDP_SKB_CB(skb)->partial_cov);
> > > +
> > > +       /* GRO already validated the csum up to 'level', and we just
> > > +        * consumed one header, update the skb accordingly
> > > +        */
> > > +       UDP_SKB_CB(skb)->cscov = skb->len;
> > > +       if (level) {
> > > +               skb->ip_summed = CHECKSUM_UNNECESSARY;
> > > +               skb->csum_level = 0;
> > > +       } else {
> > > +               skb->ip_summed = CHECKSUM_NONE;
> > > +               skb->csum_valid = 1;
> > > +       }
> >
> > why does this function also update these fields for non-tunneled
> > packets? the commit only describes an issue with tunneled packets.
> >
> > > +}
> > > +
> > >  #ifdef CONFIG_BPF_SYSCALL
> > >  struct sk_psock;
> > >  struct proto *udp_bpf_get_proto(struct sock *sk, struct sk_psock *psock);
> > > diff --git a/net/ipv4/udp.c b/net/ipv4/udp.c
> > > index 4a0478b17243a..ff54135c51ffa 100644
> > > --- a/net/ipv4/udp.c
> > > +++ b/net/ipv4/udp.c
> > > @@ -2168,6 +2168,7 @@ static int udp_queue_rcv_one_skb(struct sock *sk, struct sk_buff *skb)
> > >  static int udp_queue_rcv_skb(struct sock *sk, struct sk_buff *skb)
> > >  {
> > >         struct sk_buff *next, *segs;
> > > +       int csum_level;
> > >         int ret;
> > >
> > >         if (likely(!udp_unexpected_gso(sk, skb)))
> > > @@ -2175,9 +2176,18 @@ static int udp_queue_rcv_skb(struct sock *sk, struct sk_buff *skb)
> > >
> > >         BUILD_BUG_ON(sizeof(struct udp_skb_cb) > SKB_GSO_CB_OFFSET);
> > >         __skb_push(skb, -skb_mac_offset(skb));
> > > +       csum_level = !!(skb_shinfo(skb)->gso_type &
> > > +                       (SKB_GSO_UDP_TUNNEL | SKB_GSO_UDP_TUNNEL_CSUM));
> > >         segs = udp_rcv_segment(sk, skb, true);
> > >         skb_list_walk_safe(segs, skb, next) {
> > >                 __skb_pull(skb, skb_transport_offset(skb));
> > > +
> > > +               /* UDP GSO packets looped back after adding UDP encap land here with CHECKSUM none,
> > > +                * instead of adding another check in the tunnel fastpath, we can force valid
> > > +                * csums here (packets are locally generated).
> > > +                * Additionally fixup the UDP CB
> > > +                */
> > > +               udp_post_segment_fix_csum(skb, csum_level);
> >
> > How does this code differentiates locally generated packets with udp
> > tunnel headers from packets arriving from the wire, for which the
> > inner checksum may be incorrect?
>
> First thing first, thank you for the detailed review. Digesting all the
> comments will take time, so please excuse for some latency.

Apologies for my own delayed response. I also need to take time to
understand the existing code and diffs :) And have a few questions.

> I'll try to reply to both your question here because the replies are
> related.
>
> My understanding is that UDP GRO, when processing UDP over UDP traffic

This is a UDP GSO packet egress packet that was further encapsulated
with a GSO_UDP_TUNNEL on egress, then looped to the ingress path?

Then in the ingress path it has traversed the GRO layer.

Is this veth with XDP? That seems unlikely for GSO packets. But there
aren't many paths that will loop a packet through napi_gro_receive or
napi_gro_frags.

> with the appropriate features bit set, will validate the checksum for
> both the inner and the outer header - udp{4,6}_gro_receive will be
> traversed twice, the fist one for the outer header, the 2nd for the
> inner.

GRO will validate multiple levels of checksums with CHECKSUM_COMPLETE.
It can only validate the outer checksum with CHECKSUM_UNNECESSARY, I
believe?

As for looped packets with CHECKSUM_PARTIAL: we definitely have found
bugs in that path before. I think it's fine to set csum_valid on any
packets that can unambiguously be identified as such. Hence the
detailed questions above on which exact packets this code is
targeting, so that there are not accidental false positives that look
the same but have a different ip_summed.

> So when we reach here, the inner header csum could not be incorrect,
> and I don't do anything to differentiate locally generated GSO packets
> and GROed one to keep the code simpler.

But the correctness of the patch depends on them being locally
generated, if I'm not mistaken. Then I would make it explicit.

> The udp_post_segment_fix_csum() always set the csum info - even for non
> tunneled packets to avoid additional branches/make the code more
> complex. The csum should be valid in any scenario.
>
> I guess I can mention the above either in a code comment and/or in the
> commit message.

I don't follow this. The patch adds an else clause for non-tunneled
packets. Why does it update these? It does not seem like avoiding
additional branches, but adding them. So I must be missing something
more involved.

> Cheers,
>
> Paolo
>

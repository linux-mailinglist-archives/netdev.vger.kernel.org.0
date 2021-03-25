Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CD1F234935B
	for <lists+netdev@lfdr.de>; Thu, 25 Mar 2021 14:55:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230281AbhCYNyf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Mar 2021 09:54:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43142 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229731AbhCYNyC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 25 Mar 2021 09:54:02 -0400
Received: from mail-ej1-x62b.google.com (mail-ej1-x62b.google.com [IPv6:2a00:1450:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 762F3C06174A
        for <netdev@vger.kernel.org>; Thu, 25 Mar 2021 06:54:02 -0700 (PDT)
Received: by mail-ej1-x62b.google.com with SMTP id w3so3061463ejc.4
        for <netdev@vger.kernel.org>; Thu, 25 Mar 2021 06:54:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=4v+WL+8/8I7OT61HmrQ11cXzrTvlBNNG6BBJbin+vLY=;
        b=pFpTdBzMJbY/VMamFXQTYuCP/H1v0+ZwqPS/I+DdhNPhLoAEyN0dL8cHASEZuj7wSe
         KGPScpolZ7o3B7MgwSkai6Ic1IlI2xQEmlVUPZSz4CsEqvIVHz5ozak4cHVCcxTX0EFJ
         xcA5YLgUB0nq/3V3zceL3RgerralPEkQ8mh56ZQfVs+r+aQ8ku/I59WdcTIY1t89DfOH
         HI3YFAl6eojmvZNfSQRf/h9dI6eMx2+E5bzXtI+5TOsQ0ctKocfhEWAVpPcf04fhjIjh
         pgQEzmBY5pKLy/hYjfIFtEL23yVOxYX88VVJXILZqrfT0slCngTs6imAAwvPPGfJ43qB
         hXGg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=4v+WL+8/8I7OT61HmrQ11cXzrTvlBNNG6BBJbin+vLY=;
        b=TGIolmZmMSRhDp2uepNeGUElVNwYxOcjIpKnVKSNGsxF2h7mjGz1Do+fvgYK0UTqK/
         olhyE8dmDQdajme+k8RbaDbOZCEhFG2x4HaDh43BKG6yKd9Za89ZNZtVqFJK8n/LAjnc
         r2ShejwBz4WHfdHkLEZtvBndq8y/JLFB5v7y1rbc7M2y6trFNeHbsTQd7WsgZLCY3oCj
         1CTQfB14EDPFGX4ZRcz4EIF8ySorfyKvCKZYkzlkpgG3b2kK/e/AZcnS0QrdZ+uMtXBs
         Q+yrRDCsTFZO2K7PTYOL+Ys9fZVYgem913wuWGvw+nEQcMG9L4nCy0w+5LFIZPL3n/vi
         Fx2A==
X-Gm-Message-State: AOAM531pjSf8aWU19L0pBCJjYXUupYvEpL4MCicDHvpfyPBEvmV93nA3
        +UhTKVkseSyw2w1cMaD+71heKORwv20=
X-Google-Smtp-Source: ABdhPJxQgpEek4PqpNnMLAk3gjb6pf5FsAzZVjJmk5MSWfNPS3x4sq1BhioFWNgUAcTHShlmBpwPeg==
X-Received: by 2002:a17:906:d114:: with SMTP id b20mr9558949ejz.449.1616680440812;
        Thu, 25 Mar 2021 06:54:00 -0700 (PDT)
Received: from mail-wr1-f42.google.com (mail-wr1-f42.google.com. [209.85.221.42])
        by smtp.gmail.com with ESMTPSA id b4sm2445951eja.47.2021.03.25.06.54.00
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 25 Mar 2021 06:54:00 -0700 (PDT)
Received: by mail-wr1-f42.google.com with SMTP id e18so2370088wrt.6
        for <netdev@vger.kernel.org>; Thu, 25 Mar 2021 06:54:00 -0700 (PDT)
X-Received: by 2002:a5d:640b:: with SMTP id z11mr8923616wru.327.1616680439662;
 Thu, 25 Mar 2021 06:53:59 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1616345643.git.pabeni@redhat.com> <4bff28fbaa8c53ca836eb2b9bdabcc3057118916.1616345643.git.pabeni@redhat.com>
 <CA+FuTScSPJAh+6XnwnP32W+OmEzCVi8aKundnt2dJNzoKgUthg@mail.gmail.com>
 <43f56578c91f8abd8e3d1e8c73be1c4d5162089f.camel@redhat.com>
 <CA+FuTSd6fOaj6bJssyXeyL-LWvSEdSH+QchHUG8Ga-=EQ634Lg@mail.gmail.com>
 <5143c873078583ef0f12d08ccf966d6b4640b9ee.camel@redhat.com>
 <CA+FuTScdNaWxNWMp+tpZrEGmO=eW1cpHQi=1Rz9cYQQ8oz+2CA@mail.gmail.com> <6377ac88cd76e7d948a0f4ea5f8bfffd3fac1710.camel@redhat.com>
In-Reply-To: <6377ac88cd76e7d948a0f4ea5f8bfffd3fac1710.camel@redhat.com>
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Date:   Thu, 25 Mar 2021 09:53:22 -0400
X-Gmail-Original-Message-ID: <CA+FuTSepOe88N_jY+9F5gTu6ShzMa8rOZzi6CAsF+4k6iPeajw@mail.gmail.com>
Message-ID: <CA+FuTSepOe88N_jY+9F5gTu6ShzMa8rOZzi6CAsF+4k6iPeajw@mail.gmail.com>
Subject: Re: [PATCH net-next 1/8] udp: fixup csum for GSO receive slow path
To:     Paolo Abeni <pabeni@redhat.com>
Cc:     Willem de Bruijn <willemdebruijn.kernel@gmail.com>,
        Network Development <netdev@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        Alexander Lobakin <alobakin@pm.me>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Mar 25, 2021 at 6:57 AM Paolo Abeni <pabeni@redhat.com> wrote:
>
> Hello,
>
> On Wed, 2021-03-24 at 18:36 -0400, Willem de Bruijn wrote:
> > > > This is a UDP GSO packet egress packet that was further encapsulated
> > > > with a GSO_UDP_TUNNEL on egress, then looped to the ingress path?
> > > >
> > > > Then in the ingress path it has traversed the GRO layer.
> > > >
> > > > Is this veth with XDP? That seems unlikely for GSO packets. But there
> > > > aren't many paths that will loop a packet through napi_gro_receive or
> > > > napi_gro_frags.
> > >
> > > This patch addresses the following scenario:
> > >
> > > sk ->vxlan -> veth -> (xdp in use, TSO disabled, GRO on) -> veth -> vxlan -> sk
> > >
> > > What I meant here is that the issue is not visible with:
> > >
> > > (baremetal, NETIF_F_GRO_UDP_FWD | NETIF_F_GRO_FRAGLIST enabled -> vxlan -> sk
> > >
> > > > > with the appropriate features bit set, will validate the checksum for
> > > > > both the inner and the outer header - udp{4,6}_gro_receive will be
> > > > > traversed twice, the fist one for the outer header, the 2nd for the
> > > > > inner.
> > > >
> > > > GRO will validate multiple levels of checksums with CHECKSUM_COMPLETE.
> > > > It can only validate the outer checksum with CHECKSUM_UNNECESSARY, I
> > > > believe?
> > >
> > > I possibly miss some bits here ?!?
> > >
> > > AFAICS:
> > >
> > > udp4_gro_receive() -> skb_gro_checksum_validate_zero_check() ->
> > > __skb_gro_checksum_validate -> (if  not already valid)
> > > __skb_gro_checksum_validate_complete() -> (if not CHECKSUM_COMPLETE)
> > > __skb_gro_checksum_complete()
> > >
> > > the latter will validate the UDP checksum at the current nesting level
> > > (and set the csum-related bits in the GRO skb cb to the same status
> > > as CHECKSUM_COMPLETE)
> > >
> > > When processing UDP over UDP tunnel packet, the gro call chain will be:
> > >
> > > [l2/l3 GRO] -> udp4_gro_receive (validate outher header csum) ->
> > > udp_sk(sk)->gro_receive -> [other gro layers] ->
> > > udp4_gro_receive (validate inner header csum) -> ...
> >
> > Agreed. But __skb_gro_checksum_validate on the first invocation will
> > call skb_gro_incr_csum_unnecessary, so that on the second invocation
> > csum_cnt == 0 and triggers a real checksum validation?
> >
> > At least, that is my understanding. Intuitively, CHECKSUM_UNNECESSARY
> > only validates the first checksum, so says nothing about the validity
> > of any subsequent ones.
> >
> > But it seems I'm mistaken?
>
> AFAICS, it depends ;) From skbuff.h:
>
>  *   skb->csum_level indicates the number of consecutive checksums found in
>  *   the packet minus one that have been verified as CHECKSUM_UNNECESSARY.
>
> if skb->csum_level > 0, the NIC validate additional headers. The intel
> ixgbe driver use that for vxlan RX csum offload. Such field translates
> into:
>
>         NAPI_GRO_CB(skb)->csum_cnt
>
> inside the GRO engine, and skb_gro_incr_csum_unnecessary takes care of
> the updating it after validation.

True. I glanced over those cases.

More importantly, where exactly do these looped packets get converted
from CHECKSUM_PARTIAL to CHECKSUM_NONE before this patch?

> > __skb_gro_checksum_validate has an obvious exception for locally
> > generated packets by excluding CHECKSUM_PARTIAL. Looped packets
> > usually have CHECKSUM_PARTIAL set. Unfortunately, this is similar to
> > the issue that I looked at earlier this year with looped UDP packets
> > with MSG_MORE: those are also changed to CHECKSUM_NONE (and exposed a
> > checksum bug: 52cbd23a119c).
> >
> > Is there perhaps some other way that we can identify that these are
> > local packets? They should trivially avoid all checksum checks.
> >
> > > > As for looped packets with CHECKSUM_PARTIAL: we definitely have found
> > > > bugs in that path before. I think it's fine to set csum_valid on any
> > > > packets that can unambiguously be identified as such. Hence the
> > > > detailed questions above on which exact packets this code is
> > > > targeting, so that there are not accidental false positives that look
> > > > the same but have a different ip_summed.
> > >
> > > I see this change is controversial.
> >
> > I have no concerns with the fix. It is just a very narrow path (veth +
> > xdp - tso + gro ..), and to minimize risk I would try to avoid
> > updating state of unrelated packets. That was my initial comment: I
> > don't understand the need for the else clause.
>
> The branch is there because I wrote this patch before the patches 5,6,7
> later in this series. GSO UDP L4 over UDP tunnel packets were segmented
> at the UDP tunnel level, and that 'else' branch preserves the
> appropriate 'csum_level' value to avoid later (if/when the packet lands
> in a plain UDP socket) csum validation.
>
> > > Since the addressed scenario is
> > > really a corner case, a simpler alternative would be
> > > replacing udp_post_segment_fix_csum with:
> > >
> > > static inline void udp_post_segment_fix_cb(struct sk_buff *skb, int level)
> > > {
> > >         /* UDP-lite can't land here - no GRO */
> > >         WARN_ON_ONCE(UDP_SKB_CB(skb)->partial_cov);
> > >
> > >         /* UDP CB mirrors the GSO packet, we must re-init it */
> > >         UDP_SKB_CB(skb)->cscov = skb->len;
> > > }
> > >
> > > the downside will be an additional, later, unneeded csum validation for the
> > >
> > > sk ->vxlan -> veth -> (xdp in use, TSO disabled, GRO on) -> veth -> vxlan -> sk
> > >
> > > scenario. WDYT?
> >
> > No, let's definitely avoid an unneeded checksum verification.
>
> Ok.
>
> My understanding is that the following should be better:
>
> static inline void udp_post_segment_fix_csum(struct sk_buff *skb)
> {
>         /* UDP-lite can't land here - no GRO */
>         WARN_ON_ONCE(UDP_SKB_CB(skb)->partial_cov);
>
>         /* UDP packets generated with UDP_SEGMENT and traversing:
>          * UDP tunnel(xmit) -> veth (segmentation) -> veth (gro) -> UDP tunnel (rx)
>          * land here with CHECKSUM_NONE. Instead of adding another check
>          * in the tunnel fastpath, we can force valid csums here:
>          * packets are locally generated and the GRO engine already validated
>          * the csum.
>          * Additionally fixup the UDP CB
>          */
>         UDP_SKB_CB(skb)->cscov = skb->len;
>         if (skb->ip_summed == CHECKSUM_NONE && !skb->csum_valid)
>                 skb->csum_valid = 1;
> }
>
> I'll use the above in v2.

Do I understand correctly that this avoids matching tunneled packets
that arrive from the network with rx checksumming disabled, because
__skb_gro_checksum_complete will have been called on the outer packet
and have set skb->csum_valid?

Yes, this just (1) identifying the packet as being of local source and
then (2) setting csum_valid sounds great to me, thanks.

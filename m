Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 707363484B1
	for <lists+netdev@lfdr.de>; Wed, 24 Mar 2021 23:37:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238710AbhCXWg7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Mar 2021 18:36:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43070 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233038AbhCXWgp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 24 Mar 2021 18:36:45 -0400
Received: from mail-ej1-x630.google.com (mail-ej1-x630.google.com [IPv6:2a00:1450:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A03B7C06174A
        for <netdev@vger.kernel.org>; Wed, 24 Mar 2021 15:36:44 -0700 (PDT)
Received: by mail-ej1-x630.google.com with SMTP id hq27so35498620ejc.9
        for <netdev@vger.kernel.org>; Wed, 24 Mar 2021 15:36:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=3LA15ALXHQnFEk/YNh+ElZEbzDaZ9QU57JnX7YwOqtc=;
        b=tWPR4JxyV2M887CYknpXWDBQGRwV9TeshIdp3cL9fOH3upMAk3w8KrfLxLzMfzGLuF
         3X+MfvbIH2NFlxW2wGEEqtOfzDPO25YR+vbRIA+P/TcayPuHztmoOe1/wDGFjKp7Ll6A
         1zb5iXg2Jh67SqruebxjgnLBfgyWxwQEW2nWcS9pKrjGhn2GWd5RqyCzWoL+WiuSEHYx
         GsjAYasBtal82Fx+UPPlvOEY+LCxq2xzT66bwjG3IQjS2ZdEQumdi9RXKd99+o2qYDLQ
         /1Bggx0m0UUWMjfI/5VnEMnB4rkV2eDl3XgLsmrDofyqQQRtP17BdSgwYksXyfqXH+jw
         XZ2Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=3LA15ALXHQnFEk/YNh+ElZEbzDaZ9QU57JnX7YwOqtc=;
        b=ktwb0GNAnpoq+bosqwt7y2I1GRopV4w+WFH/GE9Nrx57OHjk6ZTZbuqH5qd3EzkLD8
         8y0B9n8QjrFOGfHbxrA8HxXaVCm5Vezv3VbqcFuMRFzk+ZQRyqIK1y5N6d2rnXSfbqX/
         5X07ThxQEsKU9OmYG7XE0STsaTg6MRb6hnZ+lNjtqxbtFWdSvCPz6roRwMOaEstswIif
         tjR7k5LOZBKburgkPN489up8wpjXC0Fey3GOfiqtWAizVQlEMk0XgHFP6fyZ+Y0+e6UH
         t+TsAMT+EUEfDx2nKb2j/Hdsaodj2VmGbJ/B+3KzMxcAOjlbs/Naw/qQIjGMBWXNDVjH
         s8yA==
X-Gm-Message-State: AOAM533QqtfAVTzEpcRjsKg7+HG7+Ob6Shs9vKe2FFn2nWFolNDM3G71
        97lzFQ4qDmCoXIyDMuHqdFMxYGafE9c=
X-Google-Smtp-Source: ABdhPJzqTFtG9YJC1Syv3TQWfMV/TJXLaTqOSngd45JDcMACUH/DXSLlH9+psye1dEGBKs7WmamjCQ==
X-Received: by 2002:a17:906:1fd6:: with SMTP id e22mr6225263ejt.481.1616625402852;
        Wed, 24 Mar 2021 15:36:42 -0700 (PDT)
Received: from mail-wr1-f52.google.com (mail-wr1-f52.google.com. [209.85.221.52])
        by smtp.gmail.com with ESMTPSA id v22sm1541984ejj.103.2021.03.24.15.36.41
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 24 Mar 2021 15:36:41 -0700 (PDT)
Received: by mail-wr1-f52.google.com with SMTP id o16so426856wrn.0
        for <netdev@vger.kernel.org>; Wed, 24 Mar 2021 15:36:41 -0700 (PDT)
X-Received: by 2002:a5d:640b:: with SMTP id z11mr5550869wru.327.1616625400852;
 Wed, 24 Mar 2021 15:36:40 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1616345643.git.pabeni@redhat.com> <4bff28fbaa8c53ca836eb2b9bdabcc3057118916.1616345643.git.pabeni@redhat.com>
 <CA+FuTScSPJAh+6XnwnP32W+OmEzCVi8aKundnt2dJNzoKgUthg@mail.gmail.com>
 <43f56578c91f8abd8e3d1e8c73be1c4d5162089f.camel@redhat.com>
 <CA+FuTSd6fOaj6bJssyXeyL-LWvSEdSH+QchHUG8Ga-=EQ634Lg@mail.gmail.com> <5143c873078583ef0f12d08ccf966d6b4640b9ee.camel@redhat.com>
In-Reply-To: <5143c873078583ef0f12d08ccf966d6b4640b9ee.camel@redhat.com>
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Date:   Wed, 24 Mar 2021 18:36:04 -0400
X-Gmail-Original-Message-ID: <CA+FuTScdNaWxNWMp+tpZrEGmO=eW1cpHQi=1Rz9cYQQ8oz+2CA@mail.gmail.com>
Message-ID: <CA+FuTScdNaWxNWMp+tpZrEGmO=eW1cpHQi=1Rz9cYQQ8oz+2CA@mail.gmail.com>
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

> > This is a UDP GSO packet egress packet that was further encapsulated
> > with a GSO_UDP_TUNNEL on egress, then looped to the ingress path?
> >
> > Then in the ingress path it has traversed the GRO layer.
> >
> > Is this veth with XDP? That seems unlikely for GSO packets. But there
> > aren't many paths that will loop a packet through napi_gro_receive or
> > napi_gro_frags.
>
> This patch addresses the following scenario:
>
> sk ->vxlan -> veth -> (xdp in use, TSO disabled, GRO on) -> veth -> vxlan -> sk
>
> What I meant here is that the issue is not visible with:
>
> (baremetal, NETIF_F_GRO_UDP_FWD | NETIF_F_GRO_FRAGLIST enabled -> vxlan -> sk
>
> > > with the appropriate features bit set, will validate the checksum for
> > > both the inner and the outer header - udp{4,6}_gro_receive will be
> > > traversed twice, the fist one for the outer header, the 2nd for the
> > > inner.
> >
> > GRO will validate multiple levels of checksums with CHECKSUM_COMPLETE.
> > It can only validate the outer checksum with CHECKSUM_UNNECESSARY, I
> > believe?
>
> I possibly miss some bits here ?!?
>
> AFAICS:
>
> udp4_gro_receive() -> skb_gro_checksum_validate_zero_check() ->
> __skb_gro_checksum_validate -> (if  not already valid)
> __skb_gro_checksum_validate_complete() -> (if not CHECKSUM_COMPLETE)
> __skb_gro_checksum_complete()
>
> the latter will validate the UDP checksum at the current nesting level
> (and set the csum-related bits in the GRO skb cb to the same status
> as CHECKSUM_COMPLETE)
>
> When processing UDP over UDP tunnel packet, the gro call chain will be:
>
> [l2/l3 GRO] -> udp4_gro_receive (validate outher header csum) ->
> udp_sk(sk)->gro_receive -> [other gro layers] ->
> udp4_gro_receive (validate inner header csum) -> ...

Agreed. But __skb_gro_checksum_validate on the first invocation will
call skb_gro_incr_csum_unnecessary, so that on the second invocation
csum_cnt == 0 and triggers a real checksum validation?

At least, that is my understanding. Intuitively, CHECKSUM_UNNECESSARY
only validates the first checksum, so says nothing about the validity
of any subsequent ones.

But it seems I'm mistaken?

__skb_gro_checksum_validate has an obvious exception for locally
generated packets by excluding CHECKSUM_PARTIAL. Looped packets
usually have CHECKSUM_PARTIAL set. Unfortunately, this is similar to
the issue that I looked at earlier this year with looped UDP packets
with MSG_MORE: those are also changed to CHECKSUM_NONE (and exposed a
checksum bug: 52cbd23a119c).

Is there perhaps some other way that we can identify that these are
local packets? They should trivially avoid all checksum checks.

> > As for looped packets with CHECKSUM_PARTIAL: we definitely have found
> > bugs in that path before. I think it's fine to set csum_valid on any
> > packets that can unambiguously be identified as such. Hence the
> > detailed questions above on which exact packets this code is
> > targeting, so that there are not accidental false positives that look
> > the same but have a different ip_summed.
>
> I see this change is controversial.

I have no concerns with the fix. It is just a very narrow path (veth +
xdp - tso + gro ..), and to minimize risk I would try to avoid
updating state of unrelated packets. That was my initial comment: I
don't understand the need for the else clause.

> Since the addressed scenario is
> really a corner case, a simpler alternative would be
> replacing udp_post_segment_fix_csum with:
>
> static inline void udp_post_segment_fix_cb(struct sk_buff *skb, int level)
> {
>         /* UDP-lite can't land here - no GRO */
>         WARN_ON_ONCE(UDP_SKB_CB(skb)->partial_cov);
>
>         /* UDP CB mirrors the GSO packet, we must re-init it */
>         UDP_SKB_CB(skb)->cscov = skb->len;
> }
>
> the downside will be an additional, later, unneeded csum validation for the
>
> sk ->vxlan -> veth -> (xdp in use, TSO disabled, GRO on) -> veth -> vxlan -> sk
>
> scenario. WDYT?

No, let's definitely avoid an unneeded checksum verification.

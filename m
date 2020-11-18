Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D04AF2B85AD
	for <lists+netdev@lfdr.de>; Wed, 18 Nov 2020 21:36:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727175AbgKRUfe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Nov 2020 15:35:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39446 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726268AbgKRUfd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Nov 2020 15:35:33 -0500
Received: from mail-io1-xd44.google.com (mail-io1-xd44.google.com [IPv6:2607:f8b0:4864:20::d44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7819FC0613D4;
        Wed, 18 Nov 2020 12:35:33 -0800 (PST)
Received: by mail-io1-xd44.google.com with SMTP id j12so3532225iow.0;
        Wed, 18 Nov 2020 12:35:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=E1bOErIYrjLaTz93PnPGTkpm6bBbgOCWVyxMuRhcFbM=;
        b=C765eYl8DJDZwTjWySFMM2zXZBN/TFUHnk9sfwZaGg5mOZ//zlAtlj4dMkYNvYJQ64
         3dGNtGKT2m0PhRMMDL5KQhwXW4K7yoE/5qQWE4nc4LK1DjLOLVuQf93epPvHciPonFdO
         FkEJY2zmfHG0HpfWf9I2GoI+agoEIXnvMKfnOuP8HEQFxZfQ/+JEB8q2itXYsCLJ/AzF
         2iCRlQAgD7bi7wbYIHpP0Y3Mc4rjl9882HQm6KhT8Vysj1z5v2dtannpbFjUdM/swgmu
         aJDIwZvz0njZXE9n33uBdaNvDjgfm+gBg+MTlm/9tzda7lQZZrBX177qkytzajHcQEZG
         877w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=E1bOErIYrjLaTz93PnPGTkpm6bBbgOCWVyxMuRhcFbM=;
        b=gsM4x2KJfzIWkBOMjITd4keyLZf1H+Y+Tk8UtO8DQlXA2Bd/qBVIO8v+x+aeFnYco/
         7zeZKKOjVdrdDjJNY/dwpQV5D4rMkzJbagnEnzrFExu7zgZix4XqrwtwMJp1TOC1dd0x
         zqpp6zk6fGsJHrIGfbyLZF1DfgsYUx0wB6Bt0lsRgkxHT/zZmcoPxQ8frQ5CEDbC4fIh
         BZUdllSiRI2ZyN62iSe/xIwzurcDiBKISv9/iIfGOgjorVkLZrkwKXJEuJcIiBLXjgwr
         D2ykotTO8iUy8TeWMKMd8pPZZwv36cTkOfJkQbTEjJT7MpHYpnM+fcbjNXMjW76S/rP9
         CPxw==
X-Gm-Message-State: AOAM530zQA+iztUKDD6jiikXmjMKX76iNSkC6MAsCs/53Knx4FfWYzPl
        Ts2x4Gwvw6HDVNJNX+a648dSEQf0nqZ2+Vn5uIc=
X-Google-Smtp-Source: ABdhPJzqnOij7D4t7XcGy0d3J4MibkWJWx+/Vlrk4lcUHcyEyczBk8Lvxfo9XeQ2+88hkqSKmxbxuWLDx4h18eLxIac=
X-Received: by 2002:a5d:964a:: with SMTP id d10mr13066783ios.5.1605731732611;
 Wed, 18 Nov 2020 12:35:32 -0800 (PST)
MIME-Version: 1.0
References: <52ee1b515df977b68497b1b08290d00a22161279.1605518147.git.lucien.xin@gmail.com>
In-Reply-To: <52ee1b515df977b68497b1b08290d00a22161279.1605518147.git.lucien.xin@gmail.com>
From:   Alexander Duyck <alexander.duyck@gmail.com>
Date:   Wed, 18 Nov 2020 12:35:21 -0800
Message-ID: <CAKgT0UdnAfYA1h2dRb4naWZRn5CBfe-0jGd_Vr=hmejX6hR1og@mail.gmail.com>
Subject: Re: [PATCH net-next] ip_gre: remove CRC flag from dev features in gre_gso_segment
To:     Xin Long <lucien.xin@gmail.com>
Cc:     network dev <netdev@vger.kernel.org>,
        "linux-sctp @ vger . kernel . org" <linux-sctp@vger.kernel.org>,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Guillaume Nault <gnault@redhat.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Lorenzo Bianconi <lorenzo@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Nov 16, 2020 at 1:17 AM Xin Long <lucien.xin@gmail.com> wrote:
>
> This patch is to let it always do CRC checksum in sctp_gso_segment()
> by removing CRC flag from the dev features in gre_gso_segment() for
> SCTP over GRE, just as it does in Commit 527beb8ef9c0 ("udp: support
> sctp over udp in skb_udp_tunnel_segment") for SCTP over UDP.
>
> It could set csum/csum_start in GSO CB properly in sctp_gso_segment()
> after that commit, so it would do checksum with gso_make_checksum()
> in gre_gso_segment(), and Commit 622e32b7d4a6 ("net: gre: recompute
> gre csum for sctp over gre tunnels") can be reverted now.
>
> Signed-off-by: Xin Long <lucien.xin@gmail.com>
> ---
>  net/ipv4/gre_offload.c | 14 +++-----------
>  1 file changed, 3 insertions(+), 11 deletions(-)
>
> diff --git a/net/ipv4/gre_offload.c b/net/ipv4/gre_offload.c
> index e0a2465..a5935d4 100644
> --- a/net/ipv4/gre_offload.c
> +++ b/net/ipv4/gre_offload.c
> @@ -15,12 +15,12 @@ static struct sk_buff *gre_gso_segment(struct sk_buff *skb,
>                                        netdev_features_t features)
>  {
>         int tnl_hlen = skb_inner_mac_header(skb) - skb_transport_header(skb);
> -       bool need_csum, need_recompute_csum, gso_partial;
>         struct sk_buff *segs = ERR_PTR(-EINVAL);
>         u16 mac_offset = skb->mac_header;
>         __be16 protocol = skb->protocol;
>         u16 mac_len = skb->mac_len;
>         int gre_offset, outer_hlen;
> +       bool need_csum, gso_partial;
>
>         if (!skb->encapsulation)
>                 goto out;
> @@ -41,10 +41,10 @@ static struct sk_buff *gre_gso_segment(struct sk_buff *skb,
>         skb->protocol = skb->inner_protocol;
>
>         need_csum = !!(skb_shinfo(skb)->gso_type & SKB_GSO_GRE_CSUM);
> -       need_recompute_csum = skb->csum_not_inet;
>         skb->encap_hdr_csum = need_csum;
>
>         features &= skb->dev->hw_enc_features;
> +       features &= ~NETIF_F_SCTP_CRC;
>
>         /* segment inner packet. */
>         segs = skb_mac_gso_segment(skb, features);

Why just blindly strip NETIF_F_SCTP_CRC? It seems like it would make
more sense if there was an explanation as to why you are stripping the
offload. I know there are many NICs that could very easily perform
SCTP CRC offload on the inner data as long as they didn't have to
offload the outer data. For example the Intel NICs should be able to
do it, although when I wrote the code up enabling their offloads I
think it is only looking at the outer headers so that might require
updating to get it to not use the software fallback.

It really seems like we should only be clearing NETIF_F_SCTP_CRC if
need_csum is true since we must compute the CRC before we can compute
the GRE checksum.

> @@ -99,15 +99,7 @@ static struct sk_buff *gre_gso_segment(struct sk_buff *skb,
>                 }
>
>                 *(pcsum + 1) = 0;
> -               if (need_recompute_csum && !skb_is_gso(skb)) {
> -                       __wsum csum;
> -
> -                       csum = skb_checksum(skb, gre_offset,
> -                                           skb->len - gre_offset, 0);
> -                       *pcsum = csum_fold(csum);
> -               } else {
> -                       *pcsum = gso_make_checksum(skb, 0);
> -               }
> +               *pcsum = gso_make_checksum(skb, 0);
>         } while ((skb = skb->next));
>  out:
>         return segs;

This change doesn't make much sense to me. How are we expecting
gso_make_checksum to be able to generate a valid checksum when we are
dealing with a SCTP frame? From what I can tell it looks like it is
just setting the checksum to ~0 and checksum start to the transport
header which isn't true because SCTP is using a CRC, not a 1's
complement checksum, or am I missing something? As such in order to
get the gre checksum we would need to compute it over the entire
payload data wouldn't we? Has this been tested with an actual GRE
tunnel that had checksums enabled? If so was it verified that the GSO
frames were actually being segmented at the NIC level and not at the
GRE tunnel level?

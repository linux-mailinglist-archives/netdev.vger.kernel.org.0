Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0D9A22B8B25
	for <lists+netdev@lfdr.de>; Thu, 19 Nov 2020 06:55:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726182AbgKSFx7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Nov 2020 00:53:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40766 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725648AbgKSFx6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 Nov 2020 00:53:58 -0500
Received: from mail-wm1-x344.google.com (mail-wm1-x344.google.com [IPv6:2a00:1450:4864:20::344])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2D956C0613D4;
        Wed, 18 Nov 2020 21:53:58 -0800 (PST)
Received: by mail-wm1-x344.google.com with SMTP id a186so3188229wme.1;
        Wed, 18 Nov 2020 21:53:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=5vJsShs7RjSMf5YmIucd3cd5LgXe9glIUYE+EeJLy2U=;
        b=prUi9P6iKT3HxTJRjQLXeUE5i97OPXRMGyrsiuNdDKJwhqbQVu9p9f5+HBIepU2UQ5
         0xO8bfm1p2mahyOWbquHxzHZ6fFuKrUKXakqys74s38j5v07AIeEAe6n6APaVwpyvPlJ
         rMlGh6W3fZdZtRj6jehMZw3ST+r6hpAe6iD5zs5NfA+KBc5o5ZiwQNgWTqkBFECof7rD
         GBD/1TqQTgLBE7qQrPKC7ed+qeGj/kUXQkyCgHX9AbT+jraOD/o2BeN+F2R89HHyKcSp
         6Ate1SiZNBV72ZOMmuA8Z8U1a9CksbiypSwloRlY7xXMLp8F+iqaAzmsYVSHY+PVEvgV
         AAOw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=5vJsShs7RjSMf5YmIucd3cd5LgXe9glIUYE+EeJLy2U=;
        b=soEPVIgVPw0hKH93op2l3Y4nR5AN59/Y+7sHWhtaoHBUJwjFlFR/M2uZlmoi899l+S
         ajtUpxrl9bY55dKDfROpbhnX6y3gtx/InOOsKgMYok1X4ClhOD51j0GLKWxtjOE6jmhf
         4GSWN71DTMb64PLrUc6I/g2tBngR5A87TXukovvtCZxpxB0vtHkGYp908xR5In8Lu+nz
         mKGB66N0dwKn3hFYcaf/C4odyLBWId6+47cwltTFtYvfJMOa39qsBESLfolRur+QuZLK
         iD/vGUGn7MPp6AJmkNJqfaUoNntWmPhFi3rz5HpX9yYI63dyf7LJhsaTz+qDg/mRFvwq
         iQKA==
X-Gm-Message-State: AOAM531D0n+G63eQXik7kuPEs4Z+PS97YgdCUF+edV7kclA+M0CvfC5m
        oeAhHiaxtpbcFPKUXp0+K4L79BOl8Gfa3F8T45r0OL6aqLk=
X-Google-Smtp-Source: ABdhPJzEvmf3eTY8yms4ySeuFJPUr885PzsVLNJc3jwm+owagLBqi2uhr9J3VgMeKZyqRUXXSzmfYbLV8xzT0GTBjyY=
X-Received: by 2002:a1c:1d82:: with SMTP id d124mr2739727wmd.12.1605765236741;
 Wed, 18 Nov 2020 21:53:56 -0800 (PST)
MIME-Version: 1.0
References: <52ee1b515df977b68497b1b08290d00a22161279.1605518147.git.lucien.xin@gmail.com>
 <CAKgT0UdnAfYA1h2dRb4naWZRn5CBfe-0jGd_Vr=hmejX6hR1og@mail.gmail.com>
In-Reply-To: <CAKgT0UdnAfYA1h2dRb4naWZRn5CBfe-0jGd_Vr=hmejX6hR1og@mail.gmail.com>
From:   Xin Long <lucien.xin@gmail.com>
Date:   Thu, 19 Nov 2020 13:53:45 +0800
Message-ID: <CADvbK_dDXeOJ_vBRDo-ZUNgRY=ZaJ+44zjCJOCyw_3hBBAi6xw@mail.gmail.com>
Subject: Re: [PATCH net-next] ip_gre: remove CRC flag from dev features in gre_gso_segment
To:     Alexander Duyck <alexander.duyck@gmail.com>
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

On Thu, Nov 19, 2020 at 4:35 AM Alexander Duyck
<alexander.duyck@gmail.com> wrote:
>
> On Mon, Nov 16, 2020 at 1:17 AM Xin Long <lucien.xin@gmail.com> wrote:
> >
> > This patch is to let it always do CRC checksum in sctp_gso_segment()
> > by removing CRC flag from the dev features in gre_gso_segment() for
> > SCTP over GRE, just as it does in Commit 527beb8ef9c0 ("udp: support
> > sctp over udp in skb_udp_tunnel_segment") for SCTP over UDP.
> >
> > It could set csum/csum_start in GSO CB properly in sctp_gso_segment()
> > after that commit, so it would do checksum with gso_make_checksum()
> > in gre_gso_segment(), and Commit 622e32b7d4a6 ("net: gre: recompute
> > gre csum for sctp over gre tunnels") can be reverted now.
> >
> > Signed-off-by: Xin Long <lucien.xin@gmail.com>
> > ---
> >  net/ipv4/gre_offload.c | 14 +++-----------
> >  1 file changed, 3 insertions(+), 11 deletions(-)
> >
> > diff --git a/net/ipv4/gre_offload.c b/net/ipv4/gre_offload.c
> > index e0a2465..a5935d4 100644
> > --- a/net/ipv4/gre_offload.c
> > +++ b/net/ipv4/gre_offload.c
> > @@ -15,12 +15,12 @@ static struct sk_buff *gre_gso_segment(struct sk_buff *skb,
> >                                        netdev_features_t features)
> >  {
> >         int tnl_hlen = skb_inner_mac_header(skb) - skb_transport_header(skb);
> > -       bool need_csum, need_recompute_csum, gso_partial;
> >         struct sk_buff *segs = ERR_PTR(-EINVAL);
> >         u16 mac_offset = skb->mac_header;
> >         __be16 protocol = skb->protocol;
> >         u16 mac_len = skb->mac_len;
> >         int gre_offset, outer_hlen;
> > +       bool need_csum, gso_partial;
> >
> >         if (!skb->encapsulation)
> >                 goto out;
> > @@ -41,10 +41,10 @@ static struct sk_buff *gre_gso_segment(struct sk_buff *skb,
> >         skb->protocol = skb->inner_protocol;
> >
> >         need_csum = !!(skb_shinfo(skb)->gso_type & SKB_GSO_GRE_CSUM);
> > -       need_recompute_csum = skb->csum_not_inet;
> >         skb->encap_hdr_csum = need_csum;
> >
> >         features &= skb->dev->hw_enc_features;
> > +       features &= ~NETIF_F_SCTP_CRC;
> >
> >         /* segment inner packet. */
> >         segs = skb_mac_gso_segment(skb, features);
>
> Why just blindly strip NETIF_F_SCTP_CRC? It seems like it would make
> more sense if there was an explanation as to why you are stripping the
> offload. I know there are many NICs that could very easily perform
> SCTP CRC offload on the inner data as long as they didn't have to
> offload the outer data. For example the Intel NICs should be able to
> do it, although when I wrote the code up enabling their offloads I
> think it is only looking at the outer headers so that might require
> updating to get it to not use the software fallback.
>
> It really seems like we should only be clearing NETIF_F_SCTP_CRC if
> need_csum is true since we must compute the CRC before we can compute
> the GRE checksum.
Right, it's also what Jakub commented, thanks.

>
> > @@ -99,15 +99,7 @@ static struct sk_buff *gre_gso_segment(struct sk_buff *skb,
> >                 }
> >
> >                 *(pcsum + 1) = 0;
> > -               if (need_recompute_csum && !skb_is_gso(skb)) {
> > -                       __wsum csum;
> > -
> > -                       csum = skb_checksum(skb, gre_offset,
> > -                                           skb->len - gre_offset, 0);
> > -                       *pcsum = csum_fold(csum);
> > -               } else {
> > -                       *pcsum = gso_make_checksum(skb, 0);
> > -               }
> > +               *pcsum = gso_make_checksum(skb, 0);
> >         } while ((skb = skb->next));
> >  out:
> >         return segs;
>
> This change doesn't make much sense to me. How are we expecting
> gso_make_checksum to be able to generate a valid checksum when we are
> dealing with a SCTP frame? From what I can tell it looks like it is
> just setting the checksum to ~0 and checksum start to the transport
> header which isn't true because SCTP is using a CRC, not a 1's
> complement checksum, or am I missing something? As such in order to
> get the gre checksum we would need to compute it over the entire
> payload data wouldn't we? Has this been tested with an actual GRE
> tunnel that had checksums enabled? If so was it verified that the GSO
> frames were actually being segmented at the NIC level and not at the
> GRE tunnel level?
Hi Alex,

I think you're looking at net.git? As on net-next.git, sctp_gso_make_checksum()
has been fixed to set csum/csum_start properly by Commit 527beb8ef9c0 ("udp:
support sctp over udp in skb_udp_tunnel_segment"), so that we compute it over
the entire payload data, as you said above:

@@ -27,7 +27,11 @@ static __le32 sctp_gso_make_checksum(struct sk_buff *skb)
 {
        skb->ip_summed = CHECKSUM_NONE;
        skb->csum_not_inet = 0;
-       gso_reset_checksum(skb, ~0);
+       /* csum and csum_start in GSO CB may be needed to do the UDP
+        * checksum when it's a UDP tunneling packet.
+        */
+       SKB_GSO_CB(skb)->csum = (__force __wsum)~0;
+       SKB_GSO_CB(skb)->csum_start = skb_headroom(skb) + skb->len;
        return sctp_compute_cksum(skb, skb_transport_offset(skb));
 }

And yes, this patch has been tested with GRE tunnel checksums enabled.
(... icsum ocsum).
And yes, it was segmented in the lower NIC level, and we can make it by:

# ethtool -K gre1 tx-sctp-segmentation on
# ethtool -K veth0 tx-sctp-segmentation off

(Note: "tx-checksum-sctp" and "gso" are on for both devices)

Thanks.

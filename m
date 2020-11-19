Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3AD0E2B9937
	for <lists+netdev@lfdr.de>; Thu, 19 Nov 2020 18:24:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729123AbgKSRYc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Nov 2020 12:24:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34640 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728327AbgKSRYb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 Nov 2020 12:24:31 -0500
Received: from mail-il1-x141.google.com (mail-il1-x141.google.com [IPv6:2607:f8b0:4864:20::141])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7A8B7C0613CF;
        Thu, 19 Nov 2020 09:24:31 -0800 (PST)
Received: by mail-il1-x141.google.com with SMTP id z14so6022898ilp.11;
        Thu, 19 Nov 2020 09:24:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=OpWaacoxReF8WhiwWFs1hDMPBRtUgRb0qfLfQbUbv4I=;
        b=WCAJ2azZ0o8x78H7Gbn/Y03ZUBVNDk3MC3mvro6sU6N9+R1aFedNgyW8/7U9hPvjAN
         p0xAWqDt78tJfD7mT4voP0N2w1O529oSNKJiVAP42+aiiW/tY+BKTiuW+WdPzhKBB0+W
         gzboZz1SJZ+7zWzUVfGhSKe3gA0wl211z9/F6lHvTBzMxJbMkHxpGY6pjIWk1Qg/ex7r
         xtvEYPtkHyMiX70t7FAc42cyAb1sv2EPBc5VJeoBAAy4Y9sRGOOc5mb09Rz4NLPc8l2d
         Lg2KVqWnUgQkBZan9uB2Q/xMP3JY8I55itT18LI4X270Zgzb+hA0fUb558kWoTj0LnLY
         fo0Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=OpWaacoxReF8WhiwWFs1hDMPBRtUgRb0qfLfQbUbv4I=;
        b=SxSjhcrarFCiVCEXJWHD8eoXI2EZX6WQP1H9sqE9yoYk/HNasOG1pwbI/yQMkKG/5m
         mVwaTZg6tM+ggYuU2yphmv/vwAD5EhIYcFwLcFqhn5gI9+zj2/JJPrErvRP7ijAv1tO9
         LxadBAfLenDqN3PBe65b11CGZUJwUAmyfn77MwU/RCdObMrwBg7MZYfGnistHwvzQsCF
         x0fiCGgdbN7K3Yh9c401DfOSGzjaCjjdSLKyC4duR0Dq9YwBGPsvpTjjLrt/4fwNQItp
         MIXz/8/ZwR4RFULgcfqX+kobcg0HvAP2DaSgEdASFYRSudLReD8jLPJlSRV6iRyywt6/
         y/ug==
X-Gm-Message-State: AOAM531XHm5grOltG1WXRzsvnVS86Mg2AhlE2i2uTLqKPFjjQQD0TcAn
        FnzdHpNiBOypYIklkKo4tglf1e8nqkwM+DU2Pd/kdxdHfDKGVw==
X-Google-Smtp-Source: ABdhPJzwCv+Dl4pTawmmdE9dLepeLHMKPLVBuWmHMm2DlwLcqKk1jHRAnxAyFcA9G4qOZsrXFWzsWeLyra0flCx72MU=
X-Received: by 2002:a92:91c4:: with SMTP id e65mr5404228ill.42.1605806670665;
 Thu, 19 Nov 2020 09:24:30 -0800 (PST)
MIME-Version: 1.0
References: <52ee1b515df977b68497b1b08290d00a22161279.1605518147.git.lucien.xin@gmail.com>
 <CAKgT0UdnAfYA1h2dRb4naWZRn5CBfe-0jGd_Vr=hmejX6hR1og@mail.gmail.com> <CADvbK_dDXeOJ_vBRDo-ZUNgRY=ZaJ+44zjCJOCyw_3hBBAi6xw@mail.gmail.com>
In-Reply-To: <CADvbK_dDXeOJ_vBRDo-ZUNgRY=ZaJ+44zjCJOCyw_3hBBAi6xw@mail.gmail.com>
From:   Alexander Duyck <alexander.duyck@gmail.com>
Date:   Thu, 19 Nov 2020 09:24:19 -0800
Message-ID: <CAKgT0UeDBQv+OcVo0PNfA=RCHwnSvOxMSb1TG-bEpef7gJxzdg@mail.gmail.com>
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

On Wed, Nov 18, 2020 at 9:53 PM Xin Long <lucien.xin@gmail.com> wrote:
>
> On Thu, Nov 19, 2020 at 4:35 AM Alexander Duyck
> <alexander.duyck@gmail.com> wrote:
> >
> > On Mon, Nov 16, 2020 at 1:17 AM Xin Long <lucien.xin@gmail.com> wrote:
> > >
> > > This patch is to let it always do CRC checksum in sctp_gso_segment()
> > > by removing CRC flag from the dev features in gre_gso_segment() for
> > > SCTP over GRE, just as it does in Commit 527beb8ef9c0 ("udp: support
> > > sctp over udp in skb_udp_tunnel_segment") for SCTP over UDP.
> > > It could set csum/csum_start in GSO CB properly in sctp_gso_segment()
> > > after that commit, so it would do checksum with gso_make_checksum()
> > > in gre_gso_segment(), and Commit 622e32b7d4a6 ("net: gre: recompute
> > > gre csum for sctp over gre tunnels") can be reverted now.
> > >
> > > Signed-off-by: Xin Long <lucien.xin@gmail.com>
> > > ---
> > >  net/ipv4/gre_offload.c | 14 +++-----------
> > >  1 file changed, 3 insertions(+), 11 deletions(-)
> > >
> > > diff --git a/net/ipv4/gre_offload.c b/net/ipv4/gre_offload.c
> > > index e0a2465..a5935d4 100644
> > > --- a/net/ipv4/gre_offload.c
> > > +++ b/net/ipv4/gre_offload.c
> > > @@ -15,12 +15,12 @@ static struct sk_buff *gre_gso_segment(struct sk_buff *skb,
> > >                                        netdev_features_t features)
> > >  {
> > >         int tnl_hlen = skb_inner_mac_header(skb) - skb_transport_header(skb);
> > > -       bool need_csum, need_recompute_csum, gso_partial;
> > >         struct sk_buff *segs = ERR_PTR(-EINVAL);
> > >         u16 mac_offset = skb->mac_header;
> > >         __be16 protocol = skb->protocol;
> > >         u16 mac_len = skb->mac_len;
> > >         int gre_offset, outer_hlen;
> > > +       bool need_csum, gso_partial;
> > >
> > >         if (!skb->encapsulation)
> > >                 goto out;
> > > @@ -41,10 +41,10 @@ static struct sk_buff *gre_gso_segment(struct sk_buff *skb,
> > >         skb->protocol = skb->inner_protocol;
> > >
> > >         need_csum = !!(skb_shinfo(skb)->gso_type & SKB_GSO_GRE_CSUM);
> > > -       need_recompute_csum = skb->csum_not_inet;
> > >         skb->encap_hdr_csum = need_csum;
> > >
> > >         features &= skb->dev->hw_enc_features;
> > > +       features &= ~NETIF_F_SCTP_CRC;
> > >
> > >         /* segment inner packet. */
> > >         segs = skb_mac_gso_segment(skb, features);
> >
> > Why just blindly strip NETIF_F_SCTP_CRC? It seems like it would make
> > more sense if there was an explanation as to why you are stripping the
> > offload. I know there are many NICs that could very easily perform
> > SCTP CRC offload on the inner data as long as they didn't have to
> > offload the outer data. For example the Intel NICs should be able to
> > do it, although when I wrote the code up enabling their offloads I
> > think it is only looking at the outer headers so that might require
> > updating to get it to not use the software fallback.
> >
> > It really seems like we should only be clearing NETIF_F_SCTP_CRC if
> > need_csum is true since we must compute the CRC before we can compute
> > the GRE checksum.
> Right, it's also what Jakub commented, thanks.
>
> >
> > > @@ -99,15 +99,7 @@ static struct sk_buff *gre_gso_segment(struct sk_buff *skb,
> > >                 }
> > >
> > >                 *(pcsum + 1) = 0;
> > > -               if (need_recompute_csum && !skb_is_gso(skb)) {
> > > -                       __wsum csum;
> > > -
> > > -                       csum = skb_checksum(skb, gre_offset,
> > > -                                           skb->len - gre_offset, 0);
> > > -                       *pcsum = csum_fold(csum);
> > > -               } else {
> > > -                       *pcsum = gso_make_checksum(skb, 0);
> > > -               }
> > > +               *pcsum = gso_make_checksum(skb, 0);
> > >         } while ((skb = skb->next));
> > >  out:
> > >         return segs;
> >
> > This change doesn't make much sense to me. How are we expecting
> > gso_make_checksum to be able to generate a valid checksum when we are
> > dealing with a SCTP frame? From what I can tell it looks like it is
> > just setting the checksum to ~0 and checksum start to the transport
> > header which isn't true because SCTP is using a CRC, not a 1's
> > complement checksum, or am I missing something? As such in order to
> > get the gre checksum we would need to compute it over the entire
> > payload data wouldn't we? Has this been tested with an actual GRE
> > tunnel that had checksums enabled? If so was it verified that the GSO
> > frames were actually being segmented at the NIC level and not at the
> > GRE tunnel level?
> Hi Alex,
>
> I think you're looking at net.git? As on net-next.git, sctp_gso_make_checksum()
> has been fixed to set csum/csum_start properly by Commit 527beb8ef9c0 ("udp:
> support sctp over udp in skb_udp_tunnel_segment"), so that we compute it over
> the entire payload data, as you said above:

No. I believe the code is still wrong. That is what I was pointing
out. The GSO_CB->csum is supposed to be the checksum of the header
from csum_start up to the end of the payload. In the case of the 1's
complement checksum that is normally the inverse of the pseudo-header
checksum. We don't normally compute it and instead assume it since it
is offloaded. For a CRC based checksum you would need to compute the
checksum over the entire packet since CRC and checksum are very
different computations. That is why we were calling skb_checksum in
the original code.

> @@ -27,7 +27,11 @@ static __le32 sctp_gso_make_checksum(struct sk_buff *skb)
>  {
>         skb->ip_summed = CHECKSUM_NONE;
>         skb->csum_not_inet = 0;
> -       gso_reset_checksum(skb, ~0);
> +       /* csum and csum_start in GSO CB may be needed to do the UDP
> +        * checksum when it's a UDP tunneling packet.
> +        */
> +       SKB_GSO_CB(skb)->csum = (__force __wsum)~0;
> +       SKB_GSO_CB(skb)->csum_start = skb_headroom(skb) + skb->len;
>         return sctp_compute_cksum(skb, skb_transport_offset(skb));
>  }
>
> And yes, this patch has been tested with GRE tunnel checksums enabled.
> (... icsum ocsum).
> And yes, it was segmented in the lower NIC level, and we can make it by:
>
> # ethtool -K gre1 tx-sctp-segmentation on
> # ethtool -K veth0 tx-sctp-segmentation off
>
> (Note: "tx-checksum-sctp" and "gso" are on for both devices)
>
> Thanks.

I would also turn off Tx and Rx checksum offload on your veth device
in order to make certain you aren't falsely sending data across
indicating that the checksums are valid when they are not. It might be
better if you were to run this over an actual NIC as that could then
provide independent verification as it would be a fixed checksum test.

I'm still not convinced this is working correctly. Basically a crc32c
is not the same thing as a 1's complement checksum so you should need
to compute both if you have an SCTP packet tunneled inside a UDP or
GRE packet with a checksum. I don't see how computing a crc32c should
automatically give you a 1's complement checksum of ~0.

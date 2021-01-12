Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 839C62F2796
	for <lists+netdev@lfdr.de>; Tue, 12 Jan 2021 06:15:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388086AbhALFO4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Jan 2021 00:14:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58768 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730568AbhALFO4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Jan 2021 00:14:56 -0500
Received: from mail-wr1-x432.google.com (mail-wr1-x432.google.com [IPv6:2a00:1450:4864:20::432])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C13FAC061575;
        Mon, 11 Jan 2021 21:14:15 -0800 (PST)
Received: by mail-wr1-x432.google.com with SMTP id q18so1102794wrn.1;
        Mon, 11 Jan 2021 21:14:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=vp3jpumNfTANvMHmUWs99QCkazh7SVXBE91SzQo7bxA=;
        b=P3mZIljPJzEv/3XCFkU8l5XR3RNmvFLvWGo/YDD9D/tKeJ+r4SNwh79FBkHpoRcdH7
         ltlHBlvFZnf80xb06pIcPpzS+w3zBex4CPLVrsnu0Cr0w0JIXDHvuTOBUQB+cSickEkx
         V06y9w5BNaZS09GzrvayLbuw4GZ/VB6vtma9ICK6aECkf1Xj1kP5MWeqJdJL+d9ITdWq
         QWm44R4zvjJLkHdSGzxzUiRllaAndlLBD+6v2E4hW9NMOEAhzOGS8aFlXcEr0PNqFWxs
         RRmCFuy5RPxEp4IXJhLTWl8k6I+xqIDWmiCyhyG8ZrkR70bX3UQZCjmQg654rMFoRYOw
         nT+w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=vp3jpumNfTANvMHmUWs99QCkazh7SVXBE91SzQo7bxA=;
        b=kI1BmiANeFqscWvTJrCLQgbNyM9pUSXnVx97D8AxUTdbb3+6vlnrKJAL7/PB+/h778
         FbnyEj9Y8J2xK6Ov404DjOsIs4kaioHK5g1YWDdHv+paNgtyIAqY7gLY+vwhO7rFqJ5n
         VGu4r+a3s7PeH6CDnC0387uJ8amdSwzJnUY1pSJv61tbtNOm7O30oOY1h372vCUSoF4k
         RdSWkjbhrz0sYYxr3l04JtHJpgtcndSW9RYF744o5axQmpNK1a7nKIzj+P7v4rJo1r2a
         2WGcjrNBtIaIz5akB8G/eS0nSolZ/WZyHw/91As3HikPpQy/ujqyfLjiNvzblSBztZzw
         vDzQ==
X-Gm-Message-State: AOAM5303PmvxHIGYjDI9NAbwI/b/M+W00tXcqUWzL6KNGLCIf0dgJJy2
        DTAHML+lwMe0DqU6caXSDYWGg0N8B9oMo7Ivx2w4muFsHm3Y5g==
X-Google-Smtp-Source: ABdhPJyC+jsAMjOLWX2rLW9aO/5PHWHMQEnuPy/TQUJTT5Q1lSV7r+YoS5tzM5lpdg937uCG8eNfHoV4I8qHX5yHfR8=
X-Received: by 2002:a5d:6749:: with SMTP id l9mr2228745wrw.395.1610428454527;
 Mon, 11 Jan 2021 21:14:14 -0800 (PST)
MIME-Version: 1.0
References: <d8dc3cd362915974426d8274bb8ac6970a2096bb.1610371323.git.lucien.xin@gmail.com>
 <CAKgT0UeEkqQjSU_t1wp3_k4pRYxM=FE-rTk2sBa-mdSwPnAstw@mail.gmail.com>
In-Reply-To: <CAKgT0UeEkqQjSU_t1wp3_k4pRYxM=FE-rTk2sBa-mdSwPnAstw@mail.gmail.com>
From:   Xin Long <lucien.xin@gmail.com>
Date:   Tue, 12 Jan 2021 13:14:03 +0800
Message-ID: <CADvbK_cr1bYUjUi-FrcDZwPX9nBkUqP3LZNx06b4sKrO3kdVdw@mail.gmail.com>
Subject: Re: [PATCHv2 net-next] ip_gre: remove CRC flag from dev features in gre_gso_segment
To:     Alexander Duyck <alexander.duyck@gmail.com>
Cc:     network dev <netdev@vger.kernel.org>,
        "linux-sctp @ vger . kernel . org" <linux-sctp@vger.kernel.org>,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        Neil Horman <nhorman@tuxdriver.com>,
        David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Lorenzo Bianconi <lorenzo@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jan 12, 2021 at 12:48 AM Alexander Duyck
<alexander.duyck@gmail.com> wrote:
>
> On Mon, Jan 11, 2021 at 5:22 AM Xin Long <lucien.xin@gmail.com> wrote:
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
> > Note that the current HWs like igb NIC can only handle the SCTP CRC
> > when it's in the outer packet, not in the inner packet like in this
> > case, so here it removes CRC flag from the dev features even when
> > need_csum is false.
>
> So the limitation in igb is not the hardware but the driver
> configuration. When I had coded things up I put in a limitation on the
> igb_tx_csum code that it would have to validate that the protocol we
> are requesting an SCTP CRC offload since it is a different calculation
> than a 1's complement checksum. Since igb doesn't support tunnels we
> limited that check to the outer headers.
Ah.. I see, thanks.
>
> We could probably enable this for tunnels as long as the tunnel isn't
> requesting an outer checksum offload from the driver.
I think in igb_tx_csum(), by checking skb->csum_not_inet would be enough
to validate that is a SCTP request:
-               if (((first->protocol == htons(ETH_P_IP)) &&
-                    (ip_hdr(skb)->protocol == IPPROTO_SCTP)) ||
-                   ((first->protocol == htons(ETH_P_IPV6)) &&
-                    igb_ipv6_csum_is_sctp(skb))) {
+               if (skb->csum_not_inet) {
                        type_tucmd = E1000_ADVTXD_TUCMD_L4T_SCTP;
                        break;
                }

Otherwise, we will need to parse the packet a little bit, as it does in
hns3_get_l4_protocol().

>
> > v1->v2:
> >   - improve the changelog.
> >   - fix "rev xmas tree" in varibles declaration.
> >
> > Signed-off-by: Xin Long <lucien.xin@gmail.com>
> > ---
> >  net/ipv4/gre_offload.c | 15 ++++-----------
> >  1 file changed, 4 insertions(+), 11 deletions(-)
> >
> > diff --git a/net/ipv4/gre_offload.c b/net/ipv4/gre_offload.c
> > index e0a2465..a681306 100644
> > --- a/net/ipv4/gre_offload.c
> > +++ b/net/ipv4/gre_offload.c
> > @@ -15,10 +15,10 @@ static struct sk_buff *gre_gso_segment(struct sk_buff *skb,
> >                                        netdev_features_t features)
> >  {
> >         int tnl_hlen = skb_inner_mac_header(skb) - skb_transport_header(skb);
> > -       bool need_csum, need_recompute_csum, gso_partial;
> >         struct sk_buff *segs = ERR_PTR(-EINVAL);
> >         u16 mac_offset = skb->mac_header;
> >         __be16 protocol = skb->protocol;
> > +       bool need_csum, gso_partial;
> >         u16 mac_len = skb->mac_len;
> >         int gre_offset, outer_hlen;
> >
> > @@ -41,10 +41,11 @@ static struct sk_buff *gre_gso_segment(struct sk_buff *skb,
> >         skb->protocol = skb->inner_protocol;
> >
> >         need_csum = !!(skb_shinfo(skb)->gso_type & SKB_GSO_GRE_CSUM);
> > -       need_recompute_csum = skb->csum_not_inet;
> >         skb->encap_hdr_csum = need_csum;
> >
> >         features &= skb->dev->hw_enc_features;
> > +       /* CRC checksum can't be handled by HW when SCTP is the inner proto. */
> > +       features &= ~NETIF_F_SCTP_CRC;
> >
> >         /* segment inner packet. */
> >         segs = skb_mac_gso_segment(skb, features);
>
> Do we have NICs that are advertising NETIF_S_SCTP_CRC as part of their
> hw_enc_features and then not supporting it? Based on your comment
Yes, igb/igbvf/igc/ixgbe/ixgbevf, they have a similar code of SCTP
proto validation.

> above it seems like you are masking this out because hardware is
> advertising features it doesn't actually support. I'm just wondering
> if that is the case or if this is something where this should be
> cleared if need_csum is set since we only support one level of
> checksum offload.
Since only these drivers only do SCTP proto validation, and "only
one level checksum offload" issue only exists when inner packet
is SCTP packet, clearing NETIF_F_SCTP_CRC should be enough.

But seems to fix the drivers will be better, as hw_enc_features should
tell the correct features for inner proto. wdyt?

(Just note udp tunneling SCTP doesn't have this issue, as the outer
 udp checksum is always required by RFC)

>
> > @@ -99,15 +100,7 @@ static struct sk_buff *gre_gso_segment(struct sk_buff *skb,
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
> > --
> > 2.1.0
> >

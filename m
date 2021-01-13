Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 10B3F2F5808
	for <lists+netdev@lfdr.de>; Thu, 14 Jan 2021 04:01:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727237AbhANCNA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Jan 2021 21:13:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49084 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729158AbhAMV4e (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 Jan 2021 16:56:34 -0500
Received: from mail-io1-xd31.google.com (mail-io1-xd31.google.com [IPv6:2607:f8b0:4864:20::d31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E677AC061575;
        Wed, 13 Jan 2021 13:55:51 -0800 (PST)
Received: by mail-io1-xd31.google.com with SMTP id d9so7233429iob.6;
        Wed, 13 Jan 2021 13:55:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=C1KpeLF8z04zYzPK9f6optkTaPnIGlMvee+/+Z7VX54=;
        b=iPnQ2y1+fYKaR/Efg55DqBP4QIy8QpDXZI2SRF/I9YDSKpA/4L1zWblhvRq6Dr6qPc
         DX1CO97VXqd/dnmbnhKeRJOzT05nZR8YLQp4lPKpmcFsetpIlpQl0KaFRpbhqOhYpSCZ
         XxquSgLfTSM7mm/czDn4gyjr4KNi5BFToVxAb3CKoCviyA3mBQr5w2ZAPTYDreNY39US
         fwPV9vK48Yw/lPiEAn3HbM8qIctpuUExBNPLnMODPFTsw107zX7N1lWAAk0n9X4Lp5RO
         mzZAhFnLeiF1N0WUpY1mDvxy0oNlHwBSFLWTxfpu1kHkWOaIuVw7rUJK/UqBp+HUVQwt
         P4CQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=C1KpeLF8z04zYzPK9f6optkTaPnIGlMvee+/+Z7VX54=;
        b=QbcGbpYPdQMd8Hlnu4I4YUKUdR5AJpgyJcpxpX4XL5o582qq7y3D5btMkRX+dtboAm
         4epOY6hw3Io6dK9Z0x/y9ZGkvJB3uzld7HNciNNCCu43zMYWjuWYC024T9bD24dozKKU
         9+bve67cBXoWkN4Wut4+1pDUgWpvrK5UCy0OfndnnwUC9M4sja8VmTfBugD1dDw3Bo7F
         g3y2XCGVbkaOJqPCToU6VazIJ5d9ctG1e4RyG6DF+c/SvJ429cWFw/qt7SCJS5Vf8DBT
         KrpRcSA6+F2ByyY4PiZ5uSG+hXgWCEb3zuWo5h6UtFRhHkiZ1XdXN0WhLeP7/su8sDti
         jS9g==
X-Gm-Message-State: AOAM531iuLjRdwe8X2S5cptM1jnolUL7UD3JjhuVk8ArArqZSW9XXL8g
        gAA+V2uWsdiuEJm2hJ4ygqytJyYEKGLbqDLX8g+PrZoMMm826w==
X-Google-Smtp-Source: ABdhPJwFG8DCnnEME6ZSQAxJ7v6+aurobSTgX0CgwzDV6/RSYymJmsrButHJPvXdhEBqgTwdWNljqn/6wew5bjXa9CM=
X-Received: by 2002:a05:6e02:929:: with SMTP id o9mr4000052ilt.42.1610574951069;
 Wed, 13 Jan 2021 13:55:51 -0800 (PST)
MIME-Version: 1.0
References: <d8dc3cd362915974426d8274bb8ac6970a2096bb.1610371323.git.lucien.xin@gmail.com>
 <CAKgT0UeEkqQjSU_t1wp3_k4pRYxM=FE-rTk2sBa-mdSwPnAstw@mail.gmail.com>
 <CADvbK_cr1bYUjUi-FrcDZwPX9nBkUqP3LZNx06b4sKrO3kdVdw@mail.gmail.com>
 <CAKgT0UfDQhD=J7RomDZmzjRsMSm6wgtaS-sc-grE00a=8kWN8Q@mail.gmail.com> <CADvbK_fQove=-Oox8aLiZSdrpAFSiBNmtVBUs65v3O9rbzhE+A@mail.gmail.com>
In-Reply-To: <CADvbK_fQove=-Oox8aLiZSdrpAFSiBNmtVBUs65v3O9rbzhE+A@mail.gmail.com>
From:   Alexander Duyck <alexander.duyck@gmail.com>
Date:   Wed, 13 Jan 2021 13:55:40 -0800
Message-ID: <CAKgT0UcCEdTdWJjO4+7CjWPy=kVOaTtY6a2Dd0LEUYoszEiKgg@mail.gmail.com>
Subject: Re: [PATCHv2 net-next] ip_gre: remove CRC flag from dev features in gre_gso_segment
To:     Xin Long <lucien.xin@gmail.com>
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

On Wed, Jan 13, 2021 at 1:46 AM Xin Long <lucien.xin@gmail.com> wrote:
>
> On Wed, Jan 13, 2021 at 10:11 AM Alexander Duyck
> <alexander.duyck@gmail.com> wrote:
> >
> > On Mon, Jan 11, 2021 at 9:14 PM Xin Long <lucien.xin@gmail.com> wrote:
> > >
> > > On Tue, Jan 12, 2021 at 12:48 AM Alexander Duyck
> > > <alexander.duyck@gmail.com> wrote:
> > > >
> > > > On Mon, Jan 11, 2021 at 5:22 AM Xin Long <lucien.xin@gmail.com> wrote:
> > > > >
> > > > > This patch is to let it always do CRC checksum in sctp_gso_segment()
> > > > > by removing CRC flag from the dev features in gre_gso_segment() for
> > > > > SCTP over GRE, just as it does in Commit 527beb8ef9c0 ("udp: support
> > > > > sctp over udp in skb_udp_tunnel_segment") for SCTP over UDP.
> > > > >
> > > > > It could set csum/csum_start in GSO CB properly in sctp_gso_segment()
> > > > > after that commit, so it would do checksum with gso_make_checksum()
> > > > > in gre_gso_segment(), and Commit 622e32b7d4a6 ("net: gre: recompute
> > > > > gre csum for sctp over gre tunnels") can be reverted now.
> > > > >
> > > > > Note that the current HWs like igb NIC can only handle the SCTP CRC
> > > > > when it's in the outer packet, not in the inner packet like in this
> > > > > case, so here it removes CRC flag from the dev features even when
> > > > > need_csum is false.
> > > >
> > > > So the limitation in igb is not the hardware but the driver
> > > > configuration. When I had coded things up I put in a limitation on the
> > > > igb_tx_csum code that it would have to validate that the protocol we
> > > > are requesting an SCTP CRC offload since it is a different calculation
> > > > than a 1's complement checksum. Since igb doesn't support tunnels we
> > > > limited that check to the outer headers.
> > > Ah.. I see, thanks.
> > > >
> > > > We could probably enable this for tunnels as long as the tunnel isn't
> > > > requesting an outer checksum offload from the driver.
> > > I think in igb_tx_csum(), by checking skb->csum_not_inet would be enough
> > > to validate that is a SCTP request:
> > > -               if (((first->protocol == htons(ETH_P_IP)) &&
> > > -                    (ip_hdr(skb)->protocol == IPPROTO_SCTP)) ||
> > > -                   ((first->protocol == htons(ETH_P_IPV6)) &&
> > > -                    igb_ipv6_csum_is_sctp(skb))) {
> > > +               if (skb->csum_not_inet) {
> > >                         type_tucmd = E1000_ADVTXD_TUCMD_L4T_SCTP;
> > >                         break;
> > >                 }
> > >
> >
> > So if I may ask. Why go with something like csum_not_inet instead of
> > specifying something like crc32_csum? I'm just wondering if there are
> > any other non-1's complement checksums that we are dealing with?
> I don't think there is, here is the thread of that patch:
>
> https://lore.kernel.org/netdev/CALx6S36rem=OuN_At6qYA=se5cpuYM1N2R8efoaszvo8b8Tz5A@mail.gmail.com/
>
> I'm writing GRE checksum, and trying to change csum_not_inet:1 to
> csum_type:2, by doing the below, no bit hole occurs:
>
> -       __u8                    csum_not_inet:1;
> -       __u8                    dst_pending_confirm:1;
> +       __u8                    csum_type:2;
>  #ifdef CONFIG_IPV6_NDISC_NODETYPE
>         __u8                    ndisc_nodetype:2;
>  #endif
> +       __u8                    dst_pending_confirm:1;
>

If we only have two types of checksum we probably don't need to add a
new bit. We can basically leave it as a single bit with 0 being the
inet style checksum, and 1 being a crc32. The main thing I would want
to be able to verify is that we are specifically talking about a crc32
checksum so that if the type of checksum and offset match then we can
go forward with the hardware offload. If you need to add additional
types you could probably add them later.

> and in skb_csum_hwoffload_help():
>  int skb_csum_hwoffload_help(struct sk_buff *skb,
>                             const netdev_features_t features)
>  {
> -       if (unlikely(skb->csum_not_inet))
> -               return !!(features & NETIF_F_SCTP_CRC) ? 0 :
> -                       skb_crc32c_csum_help(skb);

Based on this it would seem like csum_not_inet is more of a sctp_crc
specific flag.

> +       if (likely(!skb->csum_type))
> +               return !!(features & NETIF_F_CSUM_MASK) ? 0 :
> skb_checksum_help(skb);
> +
> +       if (skb->csum_type == CSUM_T_GENERIC) {
> +               return !!(features & NETIF_F_HW_CSUM) ? 0 :
> skb_checksum_help(skb);
> +       } else if (skb->csum_type == CSUM_T_SCTP_CRC) {
> +               return !!(features & NETIF_F_SCTP_CRC) ? 0 :
> skb_crc32c_csum_help(skb);
> +       } else {
> +               pr_warn("Wrong csum type: %d\n", skb->csum_type);
> +               return 1;
> +       }
>
> then the driver fix will be:
>         case offsetof(struct sctphdr, checksum):
>                 /* validate that this is actually an SCTP request */
> -               if (((first->protocol == htons(ETH_P_IP)) &&
> -                    (ip_hdr(skb)->protocol == IPPROTO_SCTP)) ||
> -                   ((first->protocol == htons(ETH_P_IPV6)) &&
> -                    igb_ipv6_csum_is_sctp(skb))) {
> +               if (skb->csum_type == CSUM_T_SCTP_CRC) {
>                         type_tucmd = E1000_ADVTXD_TUCMD_L4T_SCTP;
>                         break;
>                 }
>

So the one thing here is that I would prefer to avoid referencing
whatever our solution is directly. I would rather have a function that
performs this test. So what you end up with is something like:
static inline bool skb_csum_is_sctp(struct sk_buff *skb)
{
    return skb->csum_type == CSUM_T_SCTP_CRC;
}

Then it simplifies the driver code and will make backports easier as
they would just have to do something like:
    if (skb_csum_is_sctp(skb)) {
        type_tucmd = E1000_ADVTXD_TUCMD_L4T_SCTP;
        break;
    }

For older kernels the driver can do their own version of
skb_csum_is_sctp and still work correctly.


> then the gre csum set will be:
> +                               skb->csum_type = CSUM_T_GENERIC;
> +                               skb->ip_summed = CHECKSUM_PARTIAL;
> +                               skb->csum_start =
> skb_transport_header(skb) - skb->head;
> +                               skb->csum_offset = sizeof(*greh);
>
> >
> > One thing we might want to do to make eventual backporting for this
> > easier would be to add an accessor inline function. Maybe something
> > like a skb_csum_is_crc32() so that for older kernels the function
> > could just be defined to return false since the csum_not_inet may not
> > exist.
> >
> > > Otherwise, we will need to parse the packet a little bit, as it does in
> > > hns3_get_l4_protocol().
> >
> > Agreed. If the csum_not_inet means it is a crc32 checksum then we
> > could just look at the offsets and as long as they are correct for
> > sctp we could just go forward with what we have.
> >
> > > >
> > > > > v1->v2:
> > > > >   - improve the changelog.
> > > > >   - fix "rev xmas tree" in varibles declaration.
> > > > >
> > > > > Signed-off-by: Xin Long <lucien.xin@gmail.com>
> > > > > ---
> > > > >  net/ipv4/gre_offload.c | 15 ++++-----------
> > > > >  1 file changed, 4 insertions(+), 11 deletions(-)
> > > > >
> > > > > diff --git a/net/ipv4/gre_offload.c b/net/ipv4/gre_offload.c
> > > > > index e0a2465..a681306 100644
> > > > > --- a/net/ipv4/gre_offload.c
> > > > > +++ b/net/ipv4/gre_offload.c
> > > > > @@ -15,10 +15,10 @@ static struct sk_buff *gre_gso_segment(struct sk_buff *skb,
> > > > >                                        netdev_features_t features)
> > > > >  {
> > > > >         int tnl_hlen = skb_inner_mac_header(skb) - skb_transport_header(skb);
> > > > > -       bool need_csum, need_recompute_csum, gso_partial;
> > > > >         struct sk_buff *segs = ERR_PTR(-EINVAL);
> > > > >         u16 mac_offset = skb->mac_header;
> > > > >         __be16 protocol = skb->protocol;
> > > > > +       bool need_csum, gso_partial;
> > > > >         u16 mac_len = skb->mac_len;
> > > > >         int gre_offset, outer_hlen;
> > > > >
> > > > > @@ -41,10 +41,11 @@ static struct sk_buff *gre_gso_segment(struct sk_buff *skb,
> > > > >         skb->protocol = skb->inner_protocol;
> > > > >
> > > > >         need_csum = !!(skb_shinfo(skb)->gso_type & SKB_GSO_GRE_CSUM);
> > > > > -       need_recompute_csum = skb->csum_not_inet;
> > > > >         skb->encap_hdr_csum = need_csum;
> > > > >
> > > > >         features &= skb->dev->hw_enc_features;
> > > > > +       /* CRC checksum can't be handled by HW when SCTP is the inner proto. */
> > > > > +       features &= ~NETIF_F_SCTP_CRC;
> > > > >
> > > > >         /* segment inner packet. */
> > > > >         segs = skb_mac_gso_segment(skb, features);
> > > >
> > > > Do we have NICs that are advertising NETIF_S_SCTP_CRC as part of their
> > > > hw_enc_features and then not supporting it? Based on your comment
> > > Yes, igb/igbvf/igc/ixgbe/ixgbevf, they have a similar code of SCTP
> > > proto validation.
> >
> > Yeah, it is old code. It was added in 4.6 before tunnels supported
> > SCTP_CRC I am guessing. It looks like csum_not_inet wasn't added until
> > 4.13. So it would probably be best to fix the drivers since the driver
> > code is outdated.
> >
> > > > above it seems like you are masking this out because hardware is
> > > > advertising features it doesn't actually support. I'm just wondering
> > > > if that is the case or if this is something where this should be
> > > > cleared if need_csum is set since we only support one level of
> > > > checksum offload.
> > > Since only these drivers only do SCTP proto validation, and "only
> > > one level checksum offload" issue only exists when inner packet
> > > is SCTP packet, clearing NETIF_F_SCTP_CRC should be enough.
> > >
> > > But seems to fix the drivers will be better, as hw_enc_features should
> > > tell the correct features for inner proto. wdyt?
> >
> > Yes, it would be better to fix the drivers. However the one limitation
> > is that this will only work when we don't have an outer checksum in
> > place. If we have an outer checksum then we have to compute the crc32
> > checksum and then offload the outer checksum if we can.
> >
> > > (Just note udp tunneling SCTP doesn't have this issue, as the outer
> > >  udp checksum is always required by RFC)
> But sctp over Vxlan/Geneve may still use noudpcsum, so need_csum
> may still be false in there.
>
> vxlan and geneve is not supporting fraglist, which sctp hw gso requires.
> I will add NETIF_F_FRAGLIST flag for udp tunnel device in another patch.
>
> Thanks.

Okay, so in those cases we still have SCTP over UDP without an outer
checksum then. I agree that it makes sense to allow offloading the
SCTP CRC32 in the noudpcsum case since we should only have one item to
offload.

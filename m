Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 762122C1855
	for <lists+netdev@lfdr.de>; Mon, 23 Nov 2020 23:25:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730037AbgKWWXp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Nov 2020 17:23:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34974 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728161AbgKWWXp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 23 Nov 2020 17:23:45 -0500
Received: from mail-il1-x143.google.com (mail-il1-x143.google.com [IPv6:2607:f8b0:4864:20::143])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CF8BCC0613CF;
        Mon, 23 Nov 2020 14:23:44 -0800 (PST)
Received: by mail-il1-x143.google.com with SMTP id b8so1943215ila.13;
        Mon, 23 Nov 2020 14:23:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Tows1tuYGQr+jIBqnpX1BDyVusEdGaAxB9qd4vyXQlA=;
        b=ltX1iPZ2gYwY+aE/IbE61TDLUIMafXT457eLZ/V5Zt4YlCYYKnZj9fcoeq9HzQviju
         FlkRFKHJ5CiOAf9ZrNfWzXAjIL+DvjqPYJIdlbaEOGUIN3ZP/761G5nkyc9TH6dHES4J
         +q0mM6ocrrKqJ4JrtR3U6Z9lt1Y38D1IoRhd+PlfOd952i+SZRbzzcXXtcoMEMB9+9CQ
         sCIc2VSsQzWV2jRLeu/e10Ebi91UXL1adQVspIIndFp9KqBk27/wjmtmTcW6569VS3Yb
         tj+JgyknCGL8fXKsJmAOGrlyVspSi0+PnmS5MoI2Vi2sxKiqxgIeNClmjip6V5TFl1wP
         vkzA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Tows1tuYGQr+jIBqnpX1BDyVusEdGaAxB9qd4vyXQlA=;
        b=OAfBv6U9+3ZMNIPRSDI0sIV05rliNzH6Za3oBfb7KDvUesb9B9qa5k/PfpH+yl1OdJ
         PsJVzLB9++K7gIO1gy6IO0v51P+bGsmbu+lN/chBFl15D7w7efJaAwOPp7O+tmogGbUN
         hLHqXd56+aR6LFNmEnqSN5BiIQE5C1ZbEo2hH+lsj1mWbT8WbPFJSFz/7Z5IsOuPC+kG
         3VQtPjiU/jqGsOTuWw4D+6dCb0MWD5Z3Gl28O9QsML+EH3HDM7G+1QE/XaV3abUVT53s
         4U3s86bxTTJjZV8si5KAPrQ6K8AMy5f7z/6mHFxTS6zi0LLZUEGfyioT3AdDtpbtg0xI
         V4Jw==
X-Gm-Message-State: AOAM532lwFax719G8rSbhYDTGMMBObRN93UYNeBnFuYNAwNaZQ9+odEK
        DneA/GfhspsiH+ZAL55MgrhBtqJkaPhSCqAL9cQ=
X-Google-Smtp-Source: ABdhPJz0NzR0W2s2reJYdtt+eh6Ioo3/Z/v0IWwh6OyQRkn3Ti+BjTIIa1nISusckgsGfQhRAZ3DeBH7Y1pgF0kHicg=
X-Received: by 2002:a92:4993:: with SMTP id k19mr1749724ilg.237.1606170223927;
 Mon, 23 Nov 2020 14:23:43 -0800 (PST)
MIME-Version: 1.0
References: <52ee1b515df977b68497b1b08290d00a22161279.1605518147.git.lucien.xin@gmail.com>
 <CAKgT0UdnAfYA1h2dRb4naWZRn5CBfe-0jGd_Vr=hmejX6hR1og@mail.gmail.com>
 <CADvbK_dDXeOJ_vBRDo-ZUNgRY=ZaJ+44zjCJOCyw_3hBBAi6xw@mail.gmail.com>
 <CAKgT0UeDBQv+OcVo0PNfA=RCHwnSvOxMSb1TG-bEpef7gJxzdg@mail.gmail.com>
 <CADvbK_depZ618farzMhxUUB9=T9+gosw6iFKesBc2WKw1oguwA@mail.gmail.com>
 <CAKgT0Ud5ft8VBvkaRDewa7qDwJDH8Z=LaaQqiGYVCsu2rgCh-Q@mail.gmail.com> <CADvbK_cY3y-DonBDp7DjKdxbnxkP1r18v1dggW_b3q9cih5coA@mail.gmail.com>
In-Reply-To: <CADvbK_cY3y-DonBDp7DjKdxbnxkP1r18v1dggW_b3q9cih5coA@mail.gmail.com>
From:   Alexander Duyck <alexander.duyck@gmail.com>
Date:   Mon, 23 Nov 2020 14:23:32 -0800
Message-ID: <CAKgT0Udkk9uEnjbPxrz7kxa=p-cysmkzqJX1Pw067dkbUceyHA@mail.gmail.com>
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

On Mon, Nov 23, 2020 at 1:14 AM Xin Long <lucien.xin@gmail.com> wrote:
>
> On Sat, Nov 21, 2020 at 12:10 AM Alexander Duyck
> <alexander.duyck@gmail.com> wrote:
> >
> > On Fri, Nov 20, 2020 at 2:23 AM Xin Long <lucien.xin@gmail.com> wrote:
> > >
> > > On Fri, Nov 20, 2020 at 1:24 AM Alexander Duyck
> > > <alexander.duyck@gmail.com> wrote:
> > > >
> > > > On Wed, Nov 18, 2020 at 9:53 PM Xin Long <lucien.xin@gmail.com> wrote:
> > > > >
> > > > > On Thu, Nov 19, 2020 at 4:35 AM Alexander Duyck
> > > > > <alexander.duyck@gmail.com> wrote:
> > > > > >
> > > > > > On Mon, Nov 16, 2020 at 1:17 AM Xin Long <lucien.xin@gmail.com> wrote:
> > > > > > >

<snip>

> > > > > @@ -27,7 +27,11 @@ static __le32 sctp_gso_make_checksum(struct sk_buff *skb)
> > > > >  {
> > > > >         skb->ip_summed = CHECKSUM_NONE;
> > > > >         skb->csum_not_inet = 0;
> > > > > -       gso_reset_checksum(skb, ~0);
> > > > > +       /* csum and csum_start in GSO CB may be needed to do the UDP
> > > > > +        * checksum when it's a UDP tunneling packet.
> > > > > +        */
> > > > > +       SKB_GSO_CB(skb)->csum = (__force __wsum)~0;
> > > > > +       SKB_GSO_CB(skb)->csum_start = skb_headroom(skb) + skb->len;
> > > > >         return sctp_compute_cksum(skb, skb_transport_offset(skb));
> > > > >  }
> > > > >
> > > > > And yes, this patch has been tested with GRE tunnel checksums enabled.
> > > > > (... icsum ocsum).
> > > > > And yes, it was segmented in the lower NIC level, and we can make it by:
> > > > >
> > > > > # ethtool -K gre1 tx-sctp-segmentation on
> > > > > # ethtool -K veth0 tx-sctp-segmentation off
> > > > >
> > > > > (Note: "tx-checksum-sctp" and "gso" are on for both devices)
> > > > >
> > > > > Thanks.
> > > >
> > > > I would also turn off Tx and Rx checksum offload on your veth device
> > > > in order to make certain you aren't falsely sending data across
> > > > indicating that the checksums are valid when they are not. It might be
> > > > better if you were to run this over an actual NIC as that could then
> > > > provide independent verification as it would be a fixed checksum test.
> > > >
> > > > I'm still not convinced this is working correctly. Basically a crc32c
> > > > is not the same thing as a 1's complement checksum so you should need
> > > > to compute both if you have an SCTP packet tunneled inside a UDP or
> > > > GRE packet with a checksum. I don't see how computing a crc32c should
> > > > automatically give you a 1's complement checksum of ~0.
> > >
> > > On the tx Path [1] below, the sctp crc checksum is calculated in
> > > sctp_gso_make_checksum() [a], where it calls *sctp_compute_cksum()*
> > > to do that, and as for the code in it:
> > >
> > >     SKB_GSO_CB(skb)->csum = (__force __wsum)~0;
> > >     SKB_GSO_CB(skb)->csum_start = skb_headroom(skb) + skb->len;
> >
> > Okay, so I think I know how this is working, but the number of things
> > relied on is ugly. Normally assuming skb_headroom(skb) + skb->len
> > being valid for this would be a non-starter. I was assuming you
> > weren't doing the 1's compliment checksum because you weren't using
> > __skb_checksum to generate it.
> >
> > If I am not mistaken SCTP GSO uses the GSO_BY_FRAGS and apparently
> > none of the frags are using page fragments within the skb. Am I
> > understanding correctly? One thing that would help to address some of
> > my concerns would be to clear instead of set NETIF_F_SG in
> > sctp_gso_segment since your checksum depends on linear skbs.
> Right, no frag is using page fragments for SCTP GSO.
> NETIF_F_SG is set here, because in skb_segment():
>
>                 if (hsize > len || !sg)
>                         hsize = len;
>
>                 if (!hsize && i >= nfrags && skb_headlen(list_skb) &&
>                     (skb_headlen(list_skb) == len || sg)) { <------
> for flag_list
>
> without sg set, it won't go to this 'if' block, which is the process
> of frag_list, see

I don't think that is processing frag_list, it is processing frags. It
is just updating list_skb as needed, however it is also configured
outside of that block.

> commit 89319d3801d1d3ac29c7df1f067038986f267d29
> Author: Herbert Xu <herbert@gondor.apana.org.au>
> Date:   Mon Dec 15 23:26:06 2008 -0800
>
>     net: Add frag_list support to skb_segment
>
> do you think this might be a bug in skb_segment()?

I would say it is assuming your logic is correct. Basically it should
be able to segment the frame regardless of if the lower device
supports NETIF_F_SG or not.

> I was also thinking if SCTP GSO could go with the way of UDP's
> with skb_segment_list() instead of GSO_BY_FRAGS things.
> the different is that the head skb does not only include header,
> but may also include userdata/payload with skb_segment_list().

The problem is right now the way the checksum is being configured you
would have to keep the payload and data all in one logical data
segment starting at skb->data. We cannot have any data stored in
shinfo->frags, nor shinfo->frag_list.

> >
> > > is prepared for doing 1's complement checksum (for outer UDP/GRE), and used
> > > in gre_gso_segment() [b], where it calls gso_make_checksum() to do that
> > > when need_csum is set. Note that, here it played a TRICK:
> > >
> > > I set SKB_GSO_CB->csum_start to the end of this packet and
> > > SKB_GSO_CB->csum = ~0 manually, so that in gso_make_checksum() it will do
> > > the 1's complement checksum for outer UDP/GRE by summing all packet bits up.
> > > See gso_make_checksum() (called by gre_gso_segment()):
> > >
> > >  unsigned char *csum_start = skb_transport_header(skb);
> > >  int plen = (skb->head + SKB_GSO_CB(skb)->csum_start) - csum_start;
> > >  /* now plen is from udp header to the END of packet. */
> > >  __wsum partial = SKB_GSO_CB(skb)->csum;
> > >
> > >  return csum_fold(csum_partial(csum_start, plen, partial));
> > >
> > > So yes, here it does compute both if I have an SCTP packet tunnelled inside
> > > a UDP or GRE packet with a checksum.
> >
> > Assuming you have the payload data in the skb->data section. Normally
> > payload is in page frags. That is why I was concerned. You have to
> > have guarantees in place that there will not be page fragments
> > attached to the skb.
> On SCTP TX path, sctp_packet_transmit() will always alloc linear skbs
> and reserve headers for lower-layer protocols. I think this will guarantee it.

That ends up being my big concern. We need to make certain that is
true for all GRO and GSO cases if we are going to operate on the
assumption that just doing a linear checksum will work in the GSO
code. Otherwise we need to make certain that segmentation will correct
this for us if it cannot be guaranteed. That is why I would be much
more comfortable if we were able to just drop the NETIF_F_SG bit when
doing the segmentation since that would guarantee the results we are
looking for.

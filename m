Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DAC472C27F3
	for <lists+netdev@lfdr.de>; Tue, 24 Nov 2020 14:33:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388284AbgKXNaz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Nov 2020 08:30:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34000 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388265AbgKXNau (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 Nov 2020 08:30:50 -0500
Received: from mail-lf1-x141.google.com (mail-lf1-x141.google.com [IPv6:2a00:1450:4864:20::141])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1DDF1C0617A6;
        Tue, 24 Nov 2020 05:30:50 -0800 (PST)
Received: by mail-lf1-x141.google.com with SMTP id d17so28846359lfq.10;
        Tue, 24 Nov 2020 05:30:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Yj8//tES5JifY9hwp6jFeWxm++VYIcYaGL5w6dvNlO4=;
        b=XCYUhbAirWmW2IKGXl+amz0I0Zd0vtR8emnhwIRRSli0+gR65/bgcByOEjOKMv9FfF
         r/aZ4MENr/wiukLIl4Xyn7xS8/KoqybLCTTmYfTAZdibVPo4B/BMaBZMMRTz+wfTpD6s
         csGYk9+p0r3z9U+O//IzP6yEJk5GqEo9ya0zUdwPq6i0idEWuA5wiFJH6uICjQr7Pv89
         +K28akYmH7pk7R7LB95sckhe2uvWnCUWxXeQ6yAOyP30fhT0QlX+Uyod3kjSQXQxkK/6
         0HOCS47jP1q5eBaMf92KCPg+RIfnADuvjn4geqXHIXj74uYRFEUUFhNRUeciX8ulXGUG
         lyjQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Yj8//tES5JifY9hwp6jFeWxm++VYIcYaGL5w6dvNlO4=;
        b=YOloWMNI8n87H2QnCdBMnWHH8CIL0DHAhvC3lPbizRarRdR43UxyPM3TsuF2pG3xQl
         UIQlkqGJZ1cQcglLEVJPz4KoM6eHM27ic4sFOMsa6pWjsj7GjEqPqvBYpYw4QpwRcCsG
         WDRRZ1V3Twtm1AcIchYAS2U1SiluO6LiKdlxhRVljXRIWHMFEavvPgCkP7JpOteS8RKE
         6t0KwLNx/BpTSAhV0KaE/iXcaYAUOrEk28AocSkiKaxOj3BVZxF03NSSutCmLZZrHkcK
         g0frY25hIy0LAfdVz/kCm1VAkJF5R8Tn0iBLFmk/TC+ozRjXLAQ8frC3aY30BgQyVwVb
         jV7w==
X-Gm-Message-State: AOAM533lPRT3bT4VOBIbM2zXlqR+iXCGAni50GV5DhSDi1M3yn7GfU7V
        xL2UzQCD+rTMJZctOq3XUKaaZem3xxMYB8Ggb3k=
X-Google-Smtp-Source: ABdhPJzOyqZqMOVd1je87oMgp/Y86wszZeyHTlVYShts9xljCpu60tQ61wrV4dkosIZB+CHaxvQT3z+UQlxj13XTdKc=
X-Received: by 2002:a19:3cb:: with SMTP id 194mr1638604lfd.437.1606224648521;
 Tue, 24 Nov 2020 05:30:48 -0800 (PST)
MIME-Version: 1.0
References: <52ee1b515df977b68497b1b08290d00a22161279.1605518147.git.lucien.xin@gmail.com>
 <CAKgT0UdnAfYA1h2dRb4naWZRn5CBfe-0jGd_Vr=hmejX6hR1og@mail.gmail.com>
 <CADvbK_dDXeOJ_vBRDo-ZUNgRY=ZaJ+44zjCJOCyw_3hBBAi6xw@mail.gmail.com>
 <CAKgT0UeDBQv+OcVo0PNfA=RCHwnSvOxMSb1TG-bEpef7gJxzdg@mail.gmail.com>
 <CADvbK_depZ618farzMhxUUB9=T9+gosw6iFKesBc2WKw1oguwA@mail.gmail.com>
 <CAKgT0Ud5ft8VBvkaRDewa7qDwJDH8Z=LaaQqiGYVCsu2rgCh-Q@mail.gmail.com>
 <CADvbK_cY3y-DonBDp7DjKdxbnxkP1r18v1dggW_b3q9cih5coA@mail.gmail.com> <CAKgT0Udkk9uEnjbPxrz7kxa=p-cysmkzqJX1Pw067dkbUceyHA@mail.gmail.com>
In-Reply-To: <CAKgT0Udkk9uEnjbPxrz7kxa=p-cysmkzqJX1Pw067dkbUceyHA@mail.gmail.com>
From:   Xin Long <lucien.xin@gmail.com>
Date:   Tue, 24 Nov 2020 21:30:37 +0800
Message-ID: <CADvbK_e_PTpq9pNEv-o2fQWjJ9qyV=JdMscTniSMKQttnpgF8Q@mail.gmail.com>
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

On Tue, Nov 24, 2020 at 6:23 AM Alexander Duyck
<alexander.duyck@gmail.com> wrote:
>
> On Mon, Nov 23, 2020 at 1:14 AM Xin Long <lucien.xin@gmail.com> wrote:
> >
> > On Sat, Nov 21, 2020 at 12:10 AM Alexander Duyck
> > <alexander.duyck@gmail.com> wrote:
> > >
> > > On Fri, Nov 20, 2020 at 2:23 AM Xin Long <lucien.xin@gmail.com> wrote:
> > > >
> > > > On Fri, Nov 20, 2020 at 1:24 AM Alexander Duyck
> > > > <alexander.duyck@gmail.com> wrote:
> > > > >
> > > > > On Wed, Nov 18, 2020 at 9:53 PM Xin Long <lucien.xin@gmail.com> wrote:
> > > > > >
> > > > > > On Thu, Nov 19, 2020 at 4:35 AM Alexander Duyck
> > > > > > <alexander.duyck@gmail.com> wrote:
> > > > > > >
> > > > > > > On Mon, Nov 16, 2020 at 1:17 AM Xin Long <lucien.xin@gmail.com> wrote:
> > > > > > > >
>
> <snip>
>
> > > > > > @@ -27,7 +27,11 @@ static __le32 sctp_gso_make_checksum(struct sk_buff *skb)
> > > > > >  {
> > > > > >         skb->ip_summed = CHECKSUM_NONE;
> > > > > >         skb->csum_not_inet = 0;
> > > > > > -       gso_reset_checksum(skb, ~0);
> > > > > > +       /* csum and csum_start in GSO CB may be needed to do the UDP
> > > > > > +        * checksum when it's a UDP tunneling packet.
> > > > > > +        */
> > > > > > +       SKB_GSO_CB(skb)->csum = (__force __wsum)~0;
> > > > > > +       SKB_GSO_CB(skb)->csum_start = skb_headroom(skb) + skb->len;
> > > > > >         return sctp_compute_cksum(skb, skb_transport_offset(skb));
> > > > > >  }
> > > > > >
> > > > > > And yes, this patch has been tested with GRE tunnel checksums enabled.
> > > > > > (... icsum ocsum).
> > > > > > And yes, it was segmented in the lower NIC level, and we can make it by:
> > > > > >
> > > > > > # ethtool -K gre1 tx-sctp-segmentation on
> > > > > > # ethtool -K veth0 tx-sctp-segmentation off
> > > > > >
> > > > > > (Note: "tx-checksum-sctp" and "gso" are on for both devices)
> > > > > >
> > > > > > Thanks.
> > > > >
> > > > > I would also turn off Tx and Rx checksum offload on your veth device
> > > > > in order to make certain you aren't falsely sending data across
> > > > > indicating that the checksums are valid when they are not. It might be
> > > > > better if you were to run this over an actual NIC as that could then
> > > > > provide independent verification as it would be a fixed checksum test.
> > > > >
> > > > > I'm still not convinced this is working correctly. Basically a crc32c
> > > > > is not the same thing as a 1's complement checksum so you should need
> > > > > to compute both if you have an SCTP packet tunneled inside a UDP or
> > > > > GRE packet with a checksum. I don't see how computing a crc32c should
> > > > > automatically give you a 1's complement checksum of ~0.
> > > >
> > > > On the tx Path [1] below, the sctp crc checksum is calculated in
> > > > sctp_gso_make_checksum() [a], where it calls *sctp_compute_cksum()*
> > > > to do that, and as for the code in it:
> > > >
> > > >     SKB_GSO_CB(skb)->csum = (__force __wsum)~0;
> > > >     SKB_GSO_CB(skb)->csum_start = skb_headroom(skb) + skb->len;
> > >
> > > Okay, so I think I know how this is working, but the number of things
> > > relied on is ugly. Normally assuming skb_headroom(skb) + skb->len
> > > being valid for this would be a non-starter. I was assuming you
> > > weren't doing the 1's compliment checksum because you weren't using
> > > __skb_checksum to generate it.
> > >
> > > If I am not mistaken SCTP GSO uses the GSO_BY_FRAGS and apparently
> > > none of the frags are using page fragments within the skb. Am I
> > > understanding correctly? One thing that would help to address some of
> > > my concerns would be to clear instead of set NETIF_F_SG in
> > > sctp_gso_segment since your checksum depends on linear skbs.
> > Right, no frag is using page fragments for SCTP GSO.
> > NETIF_F_SG is set here, because in skb_segment():
> >
> >                 if (hsize > len || !sg)
> >                         hsize = len;
> >
> >                 if (!hsize && i >= nfrags && skb_headlen(list_skb) &&
> >                     (skb_headlen(list_skb) == len || sg)) { <------
> > for flag_list
> >
> > without sg set, it won't go to this 'if' block, which is the process
> > of frag_list, see
>
> I don't think that is processing frag_list, it is processing frags. It
> is just updating list_skb as needed, however it is also configured
> outside of that block.
For SCTP's  gso, we expect it going to the branch of matching
(skb_headlen(list_skb) == len), as it will reuse the skb->data.

>
> > commit 89319d3801d1d3ac29c7df1f067038986f267d29
> > Author: Herbert Xu <herbert@gondor.apana.org.au>
> > Date:   Mon Dec 15 23:26:06 2008 -0800
> >
> >     net: Add frag_list support to skb_segment
> >
> > do you think this might be a bug in skb_segment()?
>
> I would say it is assuming your logic is correct. Basically it should
> be able to segment the frame regardless of if the lower device
> supports NETIF_F_SG or not.
>
> > I was also thinking if SCTP GSO could go with the way of UDP's
> > with skb_segment_list() instead of GSO_BY_FRAGS things.
> > the different is that the head skb does not only include header,
> > but may also include userdata/payload with skb_segment_list().
>
> The problem is right now the way the checksum is being configured you
> would have to keep the payload and data all in one logical data
> segment starting at skb->data. We cannot have any data stored in
> shinfo->frags, nor shinfo->frag_list.
That's right, current SCTP protocol stack don't save tx data into
frags or frag_list, and SCTP doesn't support GRO by now.

>
> > >
> > > > is prepared for doing 1's complement checksum (for outer UDP/GRE), and used
> > > > in gre_gso_segment() [b], where it calls gso_make_checksum() to do that
> > > > when need_csum is set. Note that, here it played a TRICK:
> > > >
> > > > I set SKB_GSO_CB->csum_start to the end of this packet and
> > > > SKB_GSO_CB->csum = ~0 manually, so that in gso_make_checksum() it will do
> > > > the 1's complement checksum for outer UDP/GRE by summing all packet bits up.
> > > > See gso_make_checksum() (called by gre_gso_segment()):
> > > >
> > > >  unsigned char *csum_start = skb_transport_header(skb);
> > > >  int plen = (skb->head + SKB_GSO_CB(skb)->csum_start) - csum_start;
> > > >  /* now plen is from udp header to the END of packet. */
> > > >  __wsum partial = SKB_GSO_CB(skb)->csum;
> > > >
> > > >  return csum_fold(csum_partial(csum_start, plen, partial));
> > > >
> > > > So yes, here it does compute both if I have an SCTP packet tunnelled inside
> > > > a UDP or GRE packet with a checksum.
> > >
> > > Assuming you have the payload data in the skb->data section. Normally
> > > payload is in page frags. That is why I was concerned. You have to
> > > have guarantees in place that there will not be page fragments
> > > attached to the skb.
> > On SCTP TX path, sctp_packet_transmit() will always alloc linear skbs
> > and reserve headers for lower-layer protocols. I think this will guarantee it.
>
> That ends up being my big concern. We need to make certain that is
> true for all GRO and GSO cases if we are going to operate on the
> assumption that just doing a linear checksum will work in the GSO
> code. Otherwise we need to make certain that segmentation will correct
> this for us if it cannot be guaranteed. That is why I would be much
> more comfortable if we were able to just drop the NETIF_F_SG bit when
> doing the segmentation since that would guarantee the results we are
> looking for.
before doing that, we should have a fix below:

@@ -3850,8 +3850,6 @@ struct sk_buff *skb_segment(struct sk_buff *head_skb,
                hsize = skb_headlen(head_skb) - offset;
                if (hsize < 0)
                        hsize = 0;
-               if (hsize > len || !sg)
-                       hsize = len;

                if (!hsize && i >= nfrags && skb_headlen(list_skb) &&
                    (skb_headlen(list_skb) == len || sg)) {
@@ -3896,6 +3894,9 @@ struct sk_buff *skb_segment(struct sk_buff *head_skb,
                        skb_release_head_state(nskb);
                        __skb_push(nskb, doffset);
                } else {
+                       if (hsize > len || !sg)
+                               hsize = len;
+

I believe it makes more sense to move this check to the 'else' branch.

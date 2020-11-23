Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 07C2C2C0219
	for <lists+netdev@lfdr.de>; Mon, 23 Nov 2020 10:17:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726486AbgKWJOe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Nov 2020 04:14:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53864 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725275AbgKWJOe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 23 Nov 2020 04:14:34 -0500
Received: from mail-wr1-x443.google.com (mail-wr1-x443.google.com [IPv6:2a00:1450:4864:20::443])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EB425C0613CF;
        Mon, 23 Nov 2020 01:14:33 -0800 (PST)
Received: by mail-wr1-x443.google.com with SMTP id k2so17871440wrx.2;
        Mon, 23 Nov 2020 01:14:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=TP0M8RWGZ0sMol8enYkzONyV15OOBR3/f/lGul1l9nQ=;
        b=WD1m2z9zFQSk6nG8u+MAgwteuo3xsvXSDTFkYfNi6+6wmbX6FXa58MDNZXUxnIWs16
         ctJ0ushiVGiuuEuA1LpozVTmFGLdiG99zYbKJhM5JqsJ5Rya85GDz1DBP7dlfRayG/Do
         1FcapM7ezokflko2oZTnaSDvjAz4B9GTX8zHMEsuIU0eln0Vr961WJeH2HcNskx28fCh
         OgiJKytDV42YNdBGjZ+KV4hej/3QMshEDvr1JAgA6u3895K+c9G1dPXB2Eg2eHupKCud
         6qxwDjShrGGQjZT9G9ou8HJT7S791bxuP4/8KPvWaJcbJKc8/4AMDzWmmgB+7PU4H/6i
         g6nw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=TP0M8RWGZ0sMol8enYkzONyV15OOBR3/f/lGul1l9nQ=;
        b=h85DXZMJsNg/uBaC7lmlz1nHjohsozszP5snSWxHMUDIyPuIMUyif7YHaO1lcC8pV5
         6jhnV0H+ElqBZHYkVsRCYK8mRGldYf9uFrYdNiphopdQAzxjXQDV6UCfSb0avmMsTyEt
         jERtoI/UEVndW6WA22HqI8frRm3cpZ/lV2fCyqIWqZTUXJhcDM+tulm9gFth5HHmLqPB
         8R6ev5FGxNoOvL02NiY486pwi3P0lMyXrNoCQE+CrGtJar/p9Ge4ZCErwKgvcfzcblCw
         tO0s1SThOBATYoZhpAiZGV697hjhZQu26xUMxSmiXNIsUmtDq/xQuu7tqYJdG8CQkSq/
         c37g==
X-Gm-Message-State: AOAM530BVeTcSnUShXaDd85vJuO/9udFW+Tfz2DzqyT21v+m26WEmUtI
        ft0/LAwQ+u2LlEWk3soMnnJEbuXKQMv0ZRrhJKg=
X-Google-Smtp-Source: ABdhPJzCkspm6ISy3M8unhLbYdmsgkWWVwLXBYptVgxA+V0Ly4igIOK03T1wWxxj3+yyh3IX1pbSZ6RqfymwjmZdQ5Y=
X-Received: by 2002:a05:6000:151:: with SMTP id r17mr6179243wrx.157.1606122872374;
 Mon, 23 Nov 2020 01:14:32 -0800 (PST)
MIME-Version: 1.0
References: <52ee1b515df977b68497b1b08290d00a22161279.1605518147.git.lucien.xin@gmail.com>
 <CAKgT0UdnAfYA1h2dRb4naWZRn5CBfe-0jGd_Vr=hmejX6hR1og@mail.gmail.com>
 <CADvbK_dDXeOJ_vBRDo-ZUNgRY=ZaJ+44zjCJOCyw_3hBBAi6xw@mail.gmail.com>
 <CAKgT0UeDBQv+OcVo0PNfA=RCHwnSvOxMSb1TG-bEpef7gJxzdg@mail.gmail.com>
 <CADvbK_depZ618farzMhxUUB9=T9+gosw6iFKesBc2WKw1oguwA@mail.gmail.com> <CAKgT0Ud5ft8VBvkaRDewa7qDwJDH8Z=LaaQqiGYVCsu2rgCh-Q@mail.gmail.com>
In-Reply-To: <CAKgT0Ud5ft8VBvkaRDewa7qDwJDH8Z=LaaQqiGYVCsu2rgCh-Q@mail.gmail.com>
From:   Xin Long <lucien.xin@gmail.com>
Date:   Mon, 23 Nov 2020 17:14:20 +0800
Message-ID: <CADvbK_cY3y-DonBDp7DjKdxbnxkP1r18v1dggW_b3q9cih5coA@mail.gmail.com>
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

On Sat, Nov 21, 2020 at 12:10 AM Alexander Duyck
<alexander.duyck@gmail.com> wrote:
>
> On Fri, Nov 20, 2020 at 2:23 AM Xin Long <lucien.xin@gmail.com> wrote:
> >
> > On Fri, Nov 20, 2020 at 1:24 AM Alexander Duyck
> > <alexander.duyck@gmail.com> wrote:
> > >
> > > On Wed, Nov 18, 2020 at 9:53 PM Xin Long <lucien.xin@gmail.com> wrote:
> > > >
> > > > On Thu, Nov 19, 2020 at 4:35 AM Alexander Duyck
> > > > <alexander.duyck@gmail.com> wrote:
> > > > >
> > > > > On Mon, Nov 16, 2020 at 1:17 AM Xin Long <lucien.xin@gmail.com> wrote:
> > > > > >
> > > > > > This patch is to let it always do CRC checksum in sctp_gso_segment()
> > > > > > by removing CRC flag from the dev features in gre_gso_segment() for
> > > > > > SCTP over GRE, just as it does in Commit 527beb8ef9c0 ("udp: support
> > > > > > sctp over udp in skb_udp_tunnel_segment") for SCTP over UDP.
> > > > > > It could set csum/csum_start in GSO CB properly in sctp_gso_segment()
> > > > > > after that commit, so it would do checksum with gso_make_checksum()
> > > > > > in gre_gso_segment(), and Commit 622e32b7d4a6 ("net: gre: recompute
> > > > > > gre csum for sctp over gre tunnels") can be reverted now.
> > > > > >
> > > > > > Signed-off-by: Xin Long <lucien.xin@gmail.com>
> > > > > > ---
> > > > > >  net/ipv4/gre_offload.c | 14 +++-----------
> > > > > >  1 file changed, 3 insertions(+), 11 deletions(-)
> > > > > >
> > > > > > diff --git a/net/ipv4/gre_offload.c b/net/ipv4/gre_offload.c
> > > > > > index e0a2465..a5935d4 100644
> > > > > > --- a/net/ipv4/gre_offload.c
> > > > > > +++ b/net/ipv4/gre_offload.c
> > > > > > @@ -15,12 +15,12 @@ static struct sk_buff *gre_gso_segment(struct sk_buff *skb,
> > > > > >                                        netdev_features_t features)
> > > > > >  {
> > > > > >         int tnl_hlen = skb_inner_mac_header(skb) - skb_transport_header(skb);
> > > > > > -       bool need_csum, need_recompute_csum, gso_partial;
> > > > > >         struct sk_buff *segs = ERR_PTR(-EINVAL);
> > > > > >         u16 mac_offset = skb->mac_header;
> > > > > >         __be16 protocol = skb->protocol;
> > > > > >         u16 mac_len = skb->mac_len;
> > > > > >         int gre_offset, outer_hlen;
> > > > > > +       bool need_csum, gso_partial;
> > > > > >
> > > > > >         if (!skb->encapsulation)
> > > > > >                 goto out;
> > > > > > @@ -41,10 +41,10 @@ static struct sk_buff *gre_gso_segment(struct sk_buff *skb,
> > > > > >         skb->protocol = skb->inner_protocol;
> > > > > >
> > > > > >         need_csum = !!(skb_shinfo(skb)->gso_type & SKB_GSO_GRE_CSUM);
> > > > > > -       need_recompute_csum = skb->csum_not_inet;
> > > > > >         skb->encap_hdr_csum = need_csum;
> > > > > >
> > > > > >         features &= skb->dev->hw_enc_features;
> > > > > > +       features &= ~NETIF_F_SCTP_CRC;
> > > > > >
> > > > > >         /* segment inner packet. */
> > > > > >         segs = skb_mac_gso_segment(skb, features);
> > > > >
> > > > > Why just blindly strip NETIF_F_SCTP_CRC? It seems like it would make
> > > > > more sense if there was an explanation as to why you are stripping the
> > > > > offload. I know there are many NICs that could very easily perform
> > > > > SCTP CRC offload on the inner data as long as they didn't have to
> > > > > offload the outer data. For example the Intel NICs should be able to
> > > > > do it, although when I wrote the code up enabling their offloads I
> > > > > think it is only looking at the outer headers so that might require
> > > > > updating to get it to not use the software fallback.
> > > > >
> > > > > It really seems like we should only be clearing NETIF_F_SCTP_CRC if
> > > > > need_csum is true since we must compute the CRC before we can compute
> > > > > the GRE checksum.
> > > > Right, it's also what Jakub commented, thanks.
> > > >
> > > > >
> > > > > > @@ -99,15 +99,7 @@ static struct sk_buff *gre_gso_segment(struct sk_buff *skb,
> > > > > >                 }
> > > > > >
> > > > > >                 *(pcsum + 1) = 0;
> > > > > > -               if (need_recompute_csum && !skb_is_gso(skb)) {
> > > > > > -                       __wsum csum;
> > > > > > -
> > > > > > -                       csum = skb_checksum(skb, gre_offset,
> > > > > > -                                           skb->len - gre_offset, 0);
> > > > > > -                       *pcsum = csum_fold(csum);
> > > > > > -               } else {
> > > > > > -                       *pcsum = gso_make_checksum(skb, 0);
> > > > > > -               }
> > > > > > +               *pcsum = gso_make_checksum(skb, 0);
> > > > > >         } while ((skb = skb->next));
> > > > > >  out:
> > > > > >         return segs;
> > > > >
> > > > > This change doesn't make much sense to me. How are we expecting
> > > > > gso_make_checksum to be able to generate a valid checksum when we are
> > > > > dealing with a SCTP frame? From what I can tell it looks like it is
> > > > > just setting the checksum to ~0 and checksum start to the transport
> > > > > header which isn't true because SCTP is using a CRC, not a 1's
> > > > > complement checksum, or am I missing something? As such in order to
> > > > > get the gre checksum we would need to compute it over the entire
> > > > > payload data wouldn't we? Has this been tested with an actual GRE
> > > > > tunnel that had checksums enabled? If so was it verified that the GSO
> > > > > frames were actually being segmented at the NIC level and not at the
> > > > > GRE tunnel level?
> > > > Hi Alex,
> > > >
> > > > I think you're looking at net.git? As on net-next.git, sctp_gso_make_checksum()
> > > > has been fixed to set csum/csum_start properly by Commit 527beb8ef9c0 ("udp:
> > > > support sctp over udp in skb_udp_tunnel_segment"), so that we compute it over
> > > > the entire payload data, as you said above:
> > >
> > > No. I believe the code is still wrong. That is what I was pointing
> > > out. The GSO_CB->csum is supposed to be the checksum of the header
> > > from csum_start up to the end of the payload. In the case of the 1's
> > > complement checksum that is normally the inverse of the pseudo-header
> > > checksum. We don't normally compute it and instead assume it since it
> > > is offloaded. For a CRC based checksum you would need to compute the
> > > checksum over the entire packet since CRC and checksum are very
> > > different computations. That is why we were calling skb_checksum in
> > > the original code.
> > Hi, Alex, sorry for having confused you, see below.
> >
> > >
> > > > @@ -27,7 +27,11 @@ static __le32 sctp_gso_make_checksum(struct sk_buff *skb)
> > > >  {
> > > >         skb->ip_summed = CHECKSUM_NONE;
> > > >         skb->csum_not_inet = 0;
> > > > -       gso_reset_checksum(skb, ~0);
> > > > +       /* csum and csum_start in GSO CB may be needed to do the UDP
> > > > +        * checksum when it's a UDP tunneling packet.
> > > > +        */
> > > > +       SKB_GSO_CB(skb)->csum = (__force __wsum)~0;
> > > > +       SKB_GSO_CB(skb)->csum_start = skb_headroom(skb) + skb->len;
> > > >         return sctp_compute_cksum(skb, skb_transport_offset(skb));
> > > >  }
> > > >
> > > > And yes, this patch has been tested with GRE tunnel checksums enabled.
> > > > (... icsum ocsum).
> > > > And yes, it was segmented in the lower NIC level, and we can make it by:
> > > >
> > > > # ethtool -K gre1 tx-sctp-segmentation on
> > > > # ethtool -K veth0 tx-sctp-segmentation off
> > > >
> > > > (Note: "tx-checksum-sctp" and "gso" are on for both devices)
> > > >
> > > > Thanks.
> > >
> > > I would also turn off Tx and Rx checksum offload on your veth device
> > > in order to make certain you aren't falsely sending data across
> > > indicating that the checksums are valid when they are not. It might be
> > > better if you were to run this over an actual NIC as that could then
> > > provide independent verification as it would be a fixed checksum test.
> > >
> > > I'm still not convinced this is working correctly. Basically a crc32c
> > > is not the same thing as a 1's complement checksum so you should need
> > > to compute both if you have an SCTP packet tunneled inside a UDP or
> > > GRE packet with a checksum. I don't see how computing a crc32c should
> > > automatically give you a 1's complement checksum of ~0.
> >
> > On the tx Path [1] below, the sctp crc checksum is calculated in
> > sctp_gso_make_checksum() [a], where it calls *sctp_compute_cksum()*
> > to do that, and as for the code in it:
> >
> >     SKB_GSO_CB(skb)->csum = (__force __wsum)~0;
> >     SKB_GSO_CB(skb)->csum_start = skb_headroom(skb) + skb->len;
>
> Okay, so I think I know how this is working, but the number of things
> relied on is ugly. Normally assuming skb_headroom(skb) + skb->len
> being valid for this would be a non-starter. I was assuming you
> weren't doing the 1's compliment checksum because you weren't using
> __skb_checksum to generate it.
>
> If I am not mistaken SCTP GSO uses the GSO_BY_FRAGS and apparently
> none of the frags are using page fragments within the skb. Am I
> understanding correctly? One thing that would help to address some of
> my concerns would be to clear instead of set NETIF_F_SG in
> sctp_gso_segment since your checksum depends on linear skbs.
Right, no frag is using page fragments for SCTP GSO.
NETIF_F_SG is set here, because in skb_segment():

                if (hsize > len || !sg)
                        hsize = len;

                if (!hsize && i >= nfrags && skb_headlen(list_skb) &&
                    (skb_headlen(list_skb) == len || sg)) { <------
for flag_list

without sg set, it won't go to this 'if' block, which is the process
of frag_list, see

commit 89319d3801d1d3ac29c7df1f067038986f267d29
Author: Herbert Xu <herbert@gondor.apana.org.au>
Date:   Mon Dec 15 23:26:06 2008 -0800

    net: Add frag_list support to skb_segment

do you think this might be a bug in skb_segment()?

I was also thinking if SCTP GSO could go with the way of UDP's
with skb_segment_list() instead of GSO_BY_FRAGS things.
the different is that the head skb does not only include header,
but may also include userdata/payload with skb_segment_list().

>
> > is prepared for doing 1's complement checksum (for outer UDP/GRE), and used
> > in gre_gso_segment() [b], where it calls gso_make_checksum() to do that
> > when need_csum is set. Note that, here it played a TRICK:
> >
> > I set SKB_GSO_CB->csum_start to the end of this packet and
> > SKB_GSO_CB->csum = ~0 manually, so that in gso_make_checksum() it will do
> > the 1's complement checksum for outer UDP/GRE by summing all packet bits up.
> > See gso_make_checksum() (called by gre_gso_segment()):
> >
> >  unsigned char *csum_start = skb_transport_header(skb);
> >  int plen = (skb->head + SKB_GSO_CB(skb)->csum_start) - csum_start;
> >  /* now plen is from udp header to the END of packet. */
> >  __wsum partial = SKB_GSO_CB(skb)->csum;
> >
> >  return csum_fold(csum_partial(csum_start, plen, partial));
> >
> > So yes, here it does compute both if I have an SCTP packet tunnelled inside
> > a UDP or GRE packet with a checksum.
>
> Assuming you have the payload data in the skb->data section. Normally
> payload is in page frags. That is why I was concerned. You have to
> have guarantees in place that there will not be page fragments
> attached to the skb.
On SCTP TX path, sctp_packet_transmit() will always alloc linear skbs
and reserve headers for lower-layer protocols. I think this will guarantee it.

>
> > But you're right that "the GSO_CB->csum is supposed to be the checksum
> > of the header from csum_start up to the end of the payload". In this
> > TRICK, csum_start is set to the end of packet,  and csum should be
> > set to 0, and I will fix it in sctp_gso_make_checksum(), thanks!
> >
> > -       SKB_GSO_CB(skb)->csum = (__force __wsum)~0;
> > +       SKB_GSO_CB(skb)->csum = (__force __wsum)0;
> >
> > Does it make sense to you now?
>
> For a 1's compliment checksum ~0 and 0 are the same thing. So that
> value doesn't matter. The issue as I have pointed out is the fact that
> you are assuming a linear skb, and I am not certain that is what you
> will actually get out of the call to skb_segment that you make in
> sctp_gso_segment.
Thanks, didn't know ~0 and 0 are the same thing here.

>
> > Path [1]:
> >  sctp_gso_segment.cold.6+0x3c/0x87 [sctp] <----- [a]
> >  inet_gso_segment+0x152/0x3c0
> >  skb_mac_gso_segment+0xa2/0x110
> >  gre_gso_segment+0x138/0x380 <---- [b]
> >  inet_gso_segment+0x152/0x3c0
> >  skb_mac_gso_segment+0xa2/0x110
> >  __skb_gso_segment+0xba/0x160
> >  validate_xmit_skb+0x147/0x300
> >  __dev_queue_xmit+0x569/0x920
> >  ip_finish_output2+0x264/0x570
> >  ip_output+0x6d/0x100
> >  iptunnel_xmit+0x16e/0x200
> >  ip_tunnel_xmit+0x437/0x870 [ip_tunnel]
> >  ipgre_xmit+0x17b/0x210 [ip_gre]
> >  dev_hard_start_xmit+0xd4/0x200
> >  __dev_queue_xmit+0x78c/0x920
> >  ip_finish_output2+0x194/0x570
> >  ip_output+0x6d/0x100
> >  __ip_queue_xmit+0x15d/0x430
> >  sctp_packet_transmit+0x706/0x9b0 [sctp]
> >  sctp_outq_flush+0xd7/0x8d0 [sctp]
> >  sctp_cmd_interpreter.isra.21+0x721/0x1a20 [sctp]
> >  sctp_do_sm+0xc3/0x2a0 [sctp]
> >  sctp_primitive_SEND+0x2f/0x40 [sctp]
> >  sctp_sendmsg_to_asoc+0x5fa/0x870 [sctp]
> >  sctp_sendmsg+0x692/0x9d0 [sctp]
> >  sock_sendmsg+0x54/0x60

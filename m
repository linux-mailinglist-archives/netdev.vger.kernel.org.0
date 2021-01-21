Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 519A02FEA99
	for <lists+netdev@lfdr.de>; Thu, 21 Jan 2021 13:49:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729590AbhAUMs7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Jan 2021 07:48:59 -0500
Received: from mailout2.samsung.com ([203.254.224.25]:26588 "EHLO
        mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731358AbhAUMr6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 Jan 2021 07:47:58 -0500
Received: from epcas2p1.samsung.com (unknown [182.195.41.53])
        by mailout2.samsung.com (KnoxPortal) with ESMTP id 20210121124713epoutp02f6d525fddc6bd2dc9c597b558b9b1699~cQBbAcIyg1688516885epoutp02j
        for <netdev@vger.kernel.org>; Thu, 21 Jan 2021 12:47:13 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.samsung.com 20210121124713epoutp02f6d525fddc6bd2dc9c597b558b9b1699~cQBbAcIyg1688516885epoutp02j
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1611233233;
        bh=5ArUZ7OnusqAu7XKHLjxdliNYY+mqybSZTjnOm3v2nU=;
        h=From:To:Cc:In-Reply-To:Subject:Date:References:From;
        b=jkuS231PrGJpv6RfGLHzbsZ51UqL7Yo3wBQf+W+I7tAvMoGt6K3Ye93tCp1nc0x2x
         4hB4PgVHlAYGvgUdeC57bTQ2J4RSwI0v5juE6qJ4FsICfuBQUze9ba5LDR1I1oiB+L
         f8tNUjIVI8Cf9XTWad7asnkrC9kpX1q30vKZfwK8=
Received: from epsnrtp4.localdomain (unknown [182.195.42.165]) by
        epcas2p3.samsung.com (KnoxPortal) with ESMTP id
        20210121124712epcas2p36c3caea815410ca2de2a985ace765f4c~cQBaD9TLA1480214802epcas2p3F;
        Thu, 21 Jan 2021 12:47:12 +0000 (GMT)
Received: from epsmges2p1.samsung.com (unknown [182.195.40.190]) by
        epsnrtp4.localdomain (Postfix) with ESMTP id 4DM2GQ1SSbz4x9Pv; Thu, 21 Jan
        2021 12:47:10 +0000 (GMT)
Received: from epcas2p3.samsung.com ( [182.195.41.55]) by
        epsmges2p1.samsung.com (Symantec Messaging Gateway) with SMTP id
        29.14.10621.DC779006; Thu, 21 Jan 2021 21:47:10 +0900 (KST)
Received: from epsmtrp2.samsung.com (unknown [182.195.40.14]) by
        epcas2p3.samsung.com (KnoxPortal) with ESMTPA id
        20210121124708epcas2p3edce29f145f94cc78de836e3c2ea846a~cQBXCUyRe0816608166epcas2p3n;
        Thu, 21 Jan 2021 12:47:08 +0000 (GMT)
Received: from epsmgms1p2.samsung.com (unknown [182.195.42.42]) by
        epsmtrp2.samsung.com (KnoxPortal) with ESMTP id
        20210121124708epsmtrp22144d1b5ae320858d5e27df02164ca04~cQBXBnwKM1687816878epsmtrp2T;
        Thu, 21 Jan 2021 12:47:08 +0000 (GMT)
X-AuditID: b6c32a45-337ff7000001297d-69-600977cdc4a4
Received: from epsmtip1.samsung.com ( [182.195.34.30]) by
        epsmgms1p2.samsung.com (Symantec Messaging Gateway) with SMTP id
        31.9A.08745.CC779006; Thu, 21 Jan 2021 21:47:08 +0900 (KST)
Received: from KORDO035731 (unknown [12.36.185.47]) by epsmtip1.samsung.com
        (KnoxPortal) with ESMTPA id
        20210121124708epsmtip1bb6213fd5647e87a3a7ed1ab7d9db8cd~cQBWydp3_1155611556epsmtip1G;
        Thu, 21 Jan 2021 12:47:08 +0000 (GMT)
From:   "Dongseok Yi" <dseok.yi@samsung.com>
To:     "'Steffen Klassert'" <steffen.klassert@secunet.com>
Cc:     "'David S. Miller'" <davem@davemloft.net>,
        "'Alexander Lobakin'" <alobakin@pm.me>, <namkyu78.kim@samsung.com>,
        "'Jakub Kicinski'" <kuba@kernel.org>,
        "'Hideaki YOSHIFUJI'" <yoshfuji@linux-ipv6.org>,
        "'Willem de Bruijn'" <willemb@google.com>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
In-Reply-To: <20210121122857.GS3576117@gauss3.secunet.de>
Subject: RE: [PATCH net v2] udp: ipv4: manipulate network header of NATed
 UDP GRO fraglist
Date:   Thu, 21 Jan 2021 21:47:08 +0900
Message-ID: <00cb01d6eff3$87b00700$97101500$@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="Windows-1252"
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Outlook 16.0
Thread-Index: AQJT4Rp7bAvF1bGeZTYGN+mZAmy16AFN1KutAr+8QJcCBTCwTADoX3BCqQBKGXA=
Content-Language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrPJsWRmVeSWpSXmKPExsWy7bCmue65cs4Eg2cfmSxWPd7OYjHnfAuL
        xYVtfawWl3fNYbNouNPMZnFsgZjF7s4f7Bbvthxht/i6t4vFgdNjy8qbTB4LNpV6bFrVyebR
        dm0Vk8fRPefYPPq2rGL02NS6hNXj8ya5AI6oHJuM1MSU1CKF1Lzk/JTMvHRbJe/geOd4UzMD
        Q11DSwtzJYW8xNxUWyUXnwBdt8wcoOuUFMoSc0qBQgGJxcVK+nY2RfmlJakKGfnFJbZKqQUp
        OQWGhgV6xYm5xaV56XrJ+blWhgYGRqZAlQk5Gf+3/GcseGZVcf2cTwPjKc0uRk4OCQETie8b
        p7N0MXJxCAnsYJT41vGMHcL5xChx9uVBNgjnM6PE4nftLDAtp9Z+ZYZI7GKU+LL2NSOE84JR
        4tyMTlaQKjYBLYk3s9rBbBEBc4nVr6YxgRQxC2xlknj4dSrYKE4BS4l7i7sYQWxhgRiJp5M6
        2UBsFgFViSM/HoLV8ALV7Lh3hx3CFpQ4OfMJWJxZwEDi/bn5zBC2vMT2t3OYIc5TkPj5dBnU
        Yj+J92svsULUiEjM7myDqtnDIXFwUQKE7SKx8uorJghbWOLV8S3sELaUxOd3e4Hu4QCy6yVa
        u2NA7pcQ6GGUuLLvCTQojCVmPWtnhKhRljhyC+o0PomOw3/ZIcK8Eh1tQhCmksTEL/EQjRIS
        L05OZpnAqDQLyV+zkPw1C8lfs5Dcv4CRZRWjWGpBcW56arFRgSFyZG9iBKdcLdcdjJPfftA7
        xMjEwXiIUYKDWUmE95ElR4IQb0piZVVqUX58UWlOavEhRlNgUE9klhJNzgcm/bySeENTIzMz
        A0tTC1MzIwslcd5igwfxQgLpiSWp2ampBalFMH1MHJxSDUy250w+/SvhVzaNtHFc+yfa2m7W
        pF6mEmV7qXdMKc9nT70z0aDvm40vT3FZUkP1TI4SdqPJxun/eR5Gzyn5uMi4+FLcttkfr+uL
        u14SiGjNDzH2mf5g2371Lf4ntnGx3+5XaFaXaVbs+iQZPTvhds/7qzo7PT/2/m+Sab29QUX2
        1BrtHc2m5deipmgYMqzZ9MdW7Iz7vFOMd0606i+yaOh6/qbh4v+0yh1V9j6N7I/vyfh9/Pz7
        seBaj6KkmCIl6fu9j84KsFQ07S9nvDE5dletuJ+S0fnV/nr5y6KffWA+vorzr3DiXrGSOrc+
        /XnPJxx/KhP5bP+9Tcvfv/S4YGN/e1u3wqxUHa+mQ+utm5RYijMSDbWYi4oTAZjJK+hCBAAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprFIsWRmVeSWpSXmKPExsWy7bCSnO6Zcs4Eg6OzdS1WPd7OYjHnfAuL
        xYVtfawWl3fNYbNouNPMZnFsgZjF7s4f7Bbvthxht/i6t4vFgdNjy8qbTB4LNpV6bFrVyebR
        dm0Vk8fRPefYPPq2rGL02NS6hNXj8ya5AI4oLpuU1JzMstQifbsEroz/W/4zFjyzqrh+zqeB
        8ZRmFyMnh4SAicSptV+Zuxi5OIQEdjBKTDz2hKWLkQMoISGxa7MrRI2wxP2WI6wQNc8YJfbf
        3s4IkmAT0JJ4M6udFcQWETCXWP1qGhNIEbPAbiaJrz33oabOZ5L4/WMRC0gVp4ClxL3FXWDd
        wgJREr1t75hBbBYBVYkjPx6C1fAC1ey4d4cdwhaUODnzCVicWcBI4tyh/WwQtrzE9rdzmCHO
        U5D4+XQZ1BV+Eu/XXmKFqBGRmN3ZxjyBUXgWklGzkIyahWTULCQtCxhZVjFKphYU56bnFhsW
        GOWllusVJ+YWl+al6yXn525iBEefltYOxj2rPugdYmTiYDzEKMHBrCTC+8iSI0GINyWxsiq1
        KD++qDQntfgQozQHi5I474Wuk/FCAumJJanZqakFqUUwWSYOTqkGpq7bhi3PeN3y1u8qmlX5
        2FLtlWXJ9siNfLNcP7m/Sa9cXLBxc81Pi9j1Zpurzj9UuLSqfx5Pv3jxYhaD5f1/YpbVLK4y
        /Pb2dOpDT9b26pU/G60L4i0O7wtkmhd9QGLXHrlmB48T608f/8R1ckqKp9yMZ6e2qv6o8PT/
        9FHm5v8Kh2y5s9yegmtqT+Vw/jz/1q/Pb47ncpcj37LYdU4UN1Rv035xMWqt0JKjG688rjiS
        qZ0cfPN1lcRkHZngCfvMd1m93R9m157wLu2O5f/ZrTFJoiVRSbElJxOaK6NWnFidsOZCy8IF
        psya997pbTj9KmtWjO4/8cJrOyU5z5rzf10ssv1D75bLrUs+dOTNFVRiKc5INNRiLipOBABg
        Hx2gLQMAAA==
X-CMS-MailID: 20210121124708epcas2p3edce29f145f94cc78de836e3c2ea846a
X-Msg-Generator: CA
X-Sendblock-Type: AUTO_CONFIDENTIAL
CMS-TYPE: 102P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20210115133200epcas2p1f52efe7bbc2826ed12da2fde4e03e3b2
References: <CGME20210115133200epcas2p1f52efe7bbc2826ed12da2fde4e03e3b2@epcas2p1.samsung.com>
        <1610716836-140533-1-git-send-email-dseok.yi@samsung.com>
        <20210118132736.GM3576117@gauss3.secunet.de>
        <012d01d6eef9$45516d40$cff447c0$@samsung.com>
        <20210121122857.GS3576117@gauss3.secunet.de>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2021-01-21 21:28, Steffen Klassert wrote:
> On Wed, Jan 20, 2021 at 03:55:42PM +0900, Dongseok Yi wrote:
> > On 2021-01-18 22:27, Steffen Klassert wrote:
> > > On Fri, Jan 15, 2021 at 10:20:35PM +0900, Dongseok Yi wrote:
> > > > UDP/IP header of UDP GROed frag_skbs are not updated even after NAT
> > > > forwarding. Only the header of head_skb from ip_finish_output_gso ->
> > > > skb_gso_segment is updated but following frag_skbs are not updated.
> > > >
> > > > A call path skb_mac_gso_segment -> inet_gso_segment ->
> > > > udp4_ufo_fragment -> __udp_gso_segment -> __udp_gso_segment_list
> > > > does not try to update UDP/IP header of the segment list but copy
> > > > only the MAC header.
> > > >
> > > > Update dport, daddr and checksums of each skb of the segment list
> > > > in __udp_gso_segment_list. It covers both SNAT and DNAT.
> > > >
> > > > Fixes: 9fd1ff5d2ac7 (udp: Support UDP fraglist GRO/GSO.)
> > > > Signed-off-by: Dongseok Yi <dseok.yi@samsung.com>
> > > > ---
> > > > v1:
> > > > Steffen Klassert said, there could be 2 options.
> > > > https://lore.kernel.org/patchwork/patch/1362257/
> > > > I was trying to write a quick fix, but it was not easy to forward
> > > > segmented list. Currently, assuming DNAT only.
> > > >
> > > > v2:
> > > > Per Steffen Klassert request, move the procedure from
> > > > udp4_ufo_fragment to __udp_gso_segment_list and support SNAT.
> > > >
> > > > To Alexander Lobakin, I've checked your email late. Just use this
> > > > patch as a reference. It support SNAT too, but does not support IPv6
> > > > yet. I cannot make IPv6 header changes in __udp_gso_segment_list due
> > > > to the file is in IPv4 directory.
> > > >
> > > >  include/net/udp.h      |  2 +-
> > > >  net/ipv4/udp_offload.c | 62 ++++++++++++++++++++++++++++++++++++++++++++++----
> > > >  net/ipv6/udp_offload.c |  2 +-
> > > >  3 files changed, 59 insertions(+), 7 deletions(-)
> > > >
> > > > diff --git a/include/net/udp.h b/include/net/udp.h
> > > > index 877832b..01351ba 100644
> > > > --- a/include/net/udp.h
> > > > +++ b/include/net/udp.h
> > > > @@ -178,7 +178,7 @@ struct sk_buff *udp_gro_receive(struct list_head *head, struct sk_buff *skb,
> > > >  int udp_gro_complete(struct sk_buff *skb, int nhoff, udp_lookup_t lookup);
> > > >
> > > >  struct sk_buff *__udp_gso_segment(struct sk_buff *gso_skb,
> > > > -				  netdev_features_t features);
> > > > +				  netdev_features_t features, bool is_ipv6);
> > > >
> > > >  static inline struct udphdr *udp_gro_udphdr(struct sk_buff *skb)
> > > >  {
> > > > diff --git a/net/ipv4/udp_offload.c b/net/ipv4/udp_offload.c
> > > > index ff39e94..c532d3b 100644
> > > > --- a/net/ipv4/udp_offload.c
> > > > +++ b/net/ipv4/udp_offload.c
> > > > @@ -187,8 +187,57 @@ struct sk_buff *skb_udp_tunnel_segment(struct sk_buff *skb,
> > > >  }
> > > >  EXPORT_SYMBOL(skb_udp_tunnel_segment);
> > > >
> > > > +static void __udpv4_gso_segment_csum(struct sk_buff *seg,
> > > > +				     __be32 *oldip, __be32 *newip,
> > > > +				     __be16 *oldport, __be16 *newport)
> > > > +{
> > > > +	struct udphdr *uh = udp_hdr(seg);
> > > > +	struct iphdr *iph = ip_hdr(seg);
> > > > +
> > > > +	if (uh->check) {
> > > > +		inet_proto_csum_replace4(&uh->check, seg, *oldip, *newip,
> > > > +					 true);
> > > > +		inet_proto_csum_replace2(&uh->check, seg, *oldport, *newport,
> > > > +					 false);
> > > > +		if (!uh->check)
> > > > +			uh->check = CSUM_MANGLED_0;
> > > > +	}
> > > > +	uh->dest = *newport;
> > > > +
> > > > +	csum_replace4(&iph->check, *oldip, *newip);
> > > > +	iph->daddr = *newip;
> > > > +}
> > >
> > > Can't we just do the checksum recalculation for this case as it is done
> > > with standard GRO?
> >
> > If I understand standard GRO correctly, it calculates full checksum.
> > Should we adopt the same method to UDP GRO fraglist? I did not find
> > a simple method for the incremental checksum update.
> >
> > >
> > > > +
> > > > +static struct sk_buff *__udpv4_gso_segment_list_csum(struct sk_buff *segs)
> > > > +{
> > > > +	struct sk_buff *seg;
> > > > +	struct udphdr *uh, *uh2;
> > > > +	struct iphdr *iph, *iph2;
> > > > +
> > > > +	seg = segs;
> > > > +	uh = udp_hdr(seg);
> > > > +	iph = ip_hdr(seg);
> > > > +
> > > > +	while ((seg = seg->next)) {
> > > > +		uh2 = udp_hdr(seg);
> > > > +		iph2 = ip_hdr(seg);
> > > > +
> > > > +		if (uh->source != uh2->source || iph->saddr != iph2->saddr)
> > > > +			__udpv4_gso_segment_csum(seg,
> > > > +						 &iph2->saddr, &iph->saddr,
> > > > +						 &uh2->source, &uh->source);
> > > > +
> > > > +		if (uh->dest != uh2->dest || iph->daddr != iph2->daddr)
> > > > +			__udpv4_gso_segment_csum(seg,
> > > > +						 &iph2->daddr, &iph->daddr,
> > > > +						 &uh2->dest, &uh->dest);
> > > > +	}
> 
> 
> > >
> > > You don't need to check the addresses and ports of all packets in the
> > > segment list. If the addresses and ports are equal for the first and
> > > second packet in the list, then this also holds for the rest of the
> > > packets.
> >
> > I think we can try this with an additional flag (seg_csum).
> >
> > diff --git a/net/ipv4/udp_offload.c b/net/ipv4/udp_offload.c
> > index 36b7e30..3f892df 100644
> > --- a/net/ipv4/udp_offload.c
> > +++ b/net/ipv4/udp_offload.c
> > @@ -213,25 +213,36 @@ static struct sk_buff *__udpv4_gso_segment_list_csum(struct sk_buff *segs)
> >         struct sk_buff *seg;
> >         struct udphdr *uh, *uh2;
> >         struct iphdr *iph, *iph2;
> > +       bool seg_csum = false;
> >
> >         seg = segs;
> >         uh = udp_hdr(seg);
> >         iph = ip_hdr(seg);
> 
> Why not
> 
>        if ((udp_hdr(seg)->dest == udp_hdr(seg->next)->dest) &&
>            (udp_hdr(seg)->source == udp_hdr(seg->next)->source) &&
>            (ip_hdr(seg)->daddr == ip_hdr(seg->next)->daddr) &&
>            (ip_hdr(seg)->saddr == ip_hdr(seg->next)->saddr))
> 	   	return segs;
> 
> Then you don't need to test inside the loop. Just update all
> packets if there is a header mismatch.

The test inside the loop would be needed to distinguish SNAT
and DNAT. I will try your approach on v3. Thanks.

> 
> >
> > -       while ((seg = seg->next)) {
> > +       seg = seg->next;
> > +       do {
> > +               if (!seg)
> > +                       break;
> > +
> >                 uh2 = udp_hdr(seg);
> >                 iph2 = ip_hdr(seg);
> >
> > -               if (uh->source != uh2->source || iph->saddr != iph2->saddr)
> > +               if (uh->source != uh2->source || iph->saddr != iph2->saddr) {
> >                         __udpv4_gso_segment_csum(seg,
> >                                                  &iph2->saddr, &iph->saddr,
> >                                                  &uh2->source, &uh->source);
> > +                       seg_csum = true;
> > +               }
> >
> > -               if (uh->dest != uh2->dest || iph->daddr != iph2->daddr)
> > +               if (uh->dest != uh2->dest || iph->daddr != iph2->daddr) {
> >                         __udpv4_gso_segment_csum(seg,
> >                                                  &iph2->daddr, &iph->daddr,
> >                                                  &uh2->dest, &uh->dest);
> > -       }
> > +                       seg_csum = true;
> > +               }
> > +
> > +               seg = seg->next;
> > +       } while (seg_csum);
> >
> >         return segs;
> >  }


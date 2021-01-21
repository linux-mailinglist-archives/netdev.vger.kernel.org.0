Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3C4DA2FE9DB
	for <lists+netdev@lfdr.de>; Thu, 21 Jan 2021 13:21:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728607AbhAUMVI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Jan 2021 07:21:08 -0500
Received: from mailout4.samsung.com ([203.254.224.34]:63308 "EHLO
        mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730950AbhAUMOZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 Jan 2021 07:14:25 -0500
Received: from epcas2p2.samsung.com (unknown [182.195.41.54])
        by mailout4.samsung.com (KnoxPortal) with ESMTP id 20210121121343epoutp04d1af9879b08fa140e2dcc1bc91da56f0~cPkK5-GxF1003710037epoutp04f
        for <netdev@vger.kernel.org>; Thu, 21 Jan 2021 12:13:42 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout4.samsung.com 20210121121343epoutp04d1af9879b08fa140e2dcc1bc91da56f0~cPkK5-GxF1003710037epoutp04f
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1611231223;
        bh=GLBdt6TqB3mxqd2afmbzxTabt/F1PQwWMVDrZR1h/ks=;
        h=From:To:Cc:In-Reply-To:Subject:Date:References:From;
        b=DtrzCnaaoKH2656QAB/uRUwNPkwx+7WaSyvQR5gkYM1FsX88pDZUbEwsPO+IGwnnp
         bIVEbXVJLUHuMocLPq0r+7OR6HfnS/7GQSewcw2aB/mgQ07bzf+9Oyji09k124Be7G
         2dG7OPMbh8zcFSNYYL8kcK1xx/lGgmRrqVQqvEqo=
Received: from epsnrtp1.localdomain (unknown [182.195.42.162]) by
        epcas2p4.samsung.com (KnoxPortal) with ESMTP id
        20210121121342epcas2p4ebdfd054493271e0df58867f13121349~cPkKLKtYN2469124691epcas2p4f;
        Thu, 21 Jan 2021 12:13:42 +0000 (GMT)
Received: from epsmges2p2.samsung.com (unknown [182.195.40.188]) by
        epsnrtp1.localdomain (Postfix) with ESMTP id 4DM1Wm3L6Gz4x9Ps; Thu, 21 Jan
        2021 12:13:40 +0000 (GMT)
Received: from epcas2p2.samsung.com ( [182.195.41.54]) by
        epsmges2p2.samsung.com (Symantec Messaging Gateway) with SMTP id
        9A.A3.56312.4FF69006; Thu, 21 Jan 2021 21:13:40 +0900 (KST)
Received: from epsmtrp1.samsung.com (unknown [182.195.40.13]) by
        epcas2p2.samsung.com (KnoxPortal) with ESMTPA id
        20210121121339epcas2p25c2798ee4139aa18ad562a94c43ced06~cPkHWK-lD3020330203epcas2p2s;
        Thu, 21 Jan 2021 12:13:39 +0000 (GMT)
Received: from epsmgms1p1new.samsung.com (unknown [182.195.42.41]) by
        epsmtrp1.samsung.com (KnoxPortal) with ESMTP id
        20210121121339epsmtrp1331bf6638fae13d3fef2aa8fc50c9759~cPkHVXvKN1367413674epsmtrp1e;
        Thu, 21 Jan 2021 12:13:39 +0000 (GMT)
X-AuditID: b6c32a46-1d9ff7000000dbf8-a7-60096ff41f9f
Received: from epsmtip2.samsung.com ( [182.195.34.31]) by
        epsmgms1p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
        B1.93.13470.3FF69006; Thu, 21 Jan 2021 21:13:39 +0900 (KST)
Received: from KORDO035731 (unknown [12.36.185.47]) by epsmtip2.samsung.com
        (KnoxPortal) with ESMTPA id
        20210121121338epsmtip219261e4257a74680cda7fd2e9760ffc6~cPkHI7Sa00414604146epsmtip2W;
        Thu, 21 Jan 2021 12:13:38 +0000 (GMT)
From:   "Dongseok Yi" <dseok.yi@samsung.com>
To:     "'Steffen Klassert'" <steffen.klassert@secunet.com>
Cc:     "'David S. Miller'" <davem@davemloft.net>,
        "'Alexander Lobakin'" <alobakin@pm.me>, <namkyu78.kim@samsung.com>,
        "'Jakub Kicinski'" <kuba@kernel.org>,
        "'Hideaki YOSHIFUJI'" <yoshfuji@linux-ipv6.org>,
        "'Willem de Bruijn'" <willemb@google.com>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
In-Reply-To: 
Subject: RE: [PATCH net v2] udp: ipv4: manipulate network header of NATed
 UDP GRO fraglist
Date:   Thu, 21 Jan 2021 21:13:38 +0900
Message-ID: <00ca01d6efee$d9d2bcd0$8d783670$@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="Windows-1252"
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Outlook 16.0
Thread-Index: AQJT4Rp7bAvF1bGeZTYGN+mZAmy16AFN1KutAr+8QJepFb/3kIAB63VA
Content-Language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrNJsWRmVeSWpSXmKPExsWy7bCmme6XfM4Eg/NLRCxWPd7OYjHnfAuL
        xYVtfawWl3fNYbNouNPMZnFsgZjF7s4f7Bbvthxht/i6t4vFgdNjy8qbTB4LNpV6bFrVyebR
        dm0Vk8fRPefYPPq2rGL02NS6hNXj8ya5AI6oHJuM1MSU1CKF1Lzk/JTMvHRbJe/geOd4UzMD
        Q11DSwtzJYW8xNxUWyUXnwBdt8wcoOuUFMoSc0qBQgGJxcVK+nY2RfmlJakKGfnFJbZKqQUp
        OQWGhgV6xYm5xaV56XrJ+blWhgYGRqZAlQk5GR8/6RbcManY/fEWUwPjLdUuRk4OCQETiUud
        a9m7GLk4hAR2MEo8nbcGyvkE5LxsgHK+MUpcXd3C3MXIAdayuy0TIr6XUaLx5Bo2COcFo0TP
        w60sIHPZBLQk3sxqZwWxRQTMJVa/msYEUsQssJVJ4uHXqSwgkzgFeCUm/LMGqREWiJF4OqmT
        DSTMIqAq8XSOE4jJK2Ap8Wu2DkgFr4CgxMmZT8CmMwsYSLw/N58ZwpaX2P52DjPENwoSP58u
        g9rqJnFjQR8TRI2IxOzONqiaPRwSv/+IQtguEjt6FzFC2MISr45vYYewpSRe9rexQ7xbL9Ha
        HQNyvIRAD6PElX0QN0gIGEvMetbOCFGjLHHkFtRpfBIdh/9CtfJKdLQJQZhKEhO/xEM0Ski8
        ODmZZQKj0iwkf81C8tcsJH/NQnL/AkaWVYxiqQXFuempxUYFRsgRvYkRnGq13HYwTnn7Qe8Q
        IxMH4yFGCQ5mJRHeR5YcCUK8KYmVValF+fFFpTmpxYcYTYEBPZFZSjQ5H5js80riDU2NzMwM
        LE0tTM2MLJTEeYsNHsQLCaQnlqRmp6YWpBbB9DFxcEo1MB3qvmD48YaSQPsi+XOXnVVfOon1
        e4qaZnin3J58MeUkY6+4KVvIzpXavOa7T655tn3fWtsji266l9rsnBe17tQsxWhRfXmVQ9vS
        fYqZ785s3bJyTmj41prpBglXdgTU6r/21Dl5VJVTwefe/csvNKKsjq1c985RtflMipPLfEWO
        2bp6k3Nm117xFQtQj5y/RzZKftaU23XFZaKBGqyXdb11BR3kXyg+fbG0/NVPVv4fP59s4tAp
        v6CdIX/e8pSJhWh66cQXU5zTnG+JMfmztbMukLPM0zHzFE94d/zztkOvf4buMesQCilTXl09
        le9UyPzjHzZkTC/ZPE90o88Vuy1vTu9kPb7DWuRWfO2EpUosxRmJhlrMRcWJACRlzao+BAAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprGIsWRmVeSWpSXmKPExsWy7bCSvO7nfM4Eg2P9LBarHm9nsZhzvoXF
        4sK2PlaLy7vmsFk03Glmszi2QMxid+cPdot3W46wW3zd28XiwOmxZeVNJo8Fm0o9Nq3qZPNo
        u7aKyePonnNsHn1bVjF6bGpdwurxeZNcAEcUl01Kak5mWWqRvl0CV8bHT7oFd0wqdn+8xdTA
        eEu1i5GDQ0LARGJ3W2YXIxeHkMBuRom9y1pYIOISErs2u3YxcgKZwhL3W46wQtQ8Y5S4PPsL
        G0iCTUBL4s2sdlYQW0TAXGL1q2lMIEXMAruZJL723GeG6DjKKPFw0QNmkKmcArwSE/5ZgzQI
        C0RJ9La9AwuzCKhKPJ3jBGLyClhK/JqtA1LBKyAocXLmExYQm1nASOLcof1sELa8xPa3c5gh
        blOQ+Pl0GdQJbhI3FvQxQdSISMzubGOewCg8C8moWUhGzUIyahaSlgWMLKsYJVMLinPTc4sN
        CwzzUsv1ihNzi0vz0vWS83M3MYKjTktzB+P2VR/0DjEycTAeYpTgYFYS4X1kyZEgxJuSWFmV
        WpQfX1Sak1p8iFGag0VJnPdC18l4IYH0xJLU7NTUgtQimCwTB6dUAxPrPoVjJ6ZJ9tdPsZqd
        8jsvbPbhfX16VsKRbodTlvMcnNEUrWuxTaSixyXhk8X3BNkundtTCw7478kMZHF+uKM/bvax
        kpkTVaZzTDJfqv7p7rLqLQEfPv1NPDO/ZYuWS9EtHq9fqo8urtX6wlLTIPqLw6bN8fflY+tZ
        Kh+1afz/wLxHaO5e4T1tf/f7/v989ex9V86T6xb/m8iqdj3D3rd0uZgcu93P86HCHQ/uznsu
        OOX9TpFSpi/fJTjNo+MdsmPPOvl+9T1Zm+wUO8X0f6H63p0/f8t9V6uZ1jFllmmN7ymPXhae
        VRf7f+4PEOQzX/Lq7UxLKS+H/0vfntvMYZW0LiryTPaE4hebmXhCFWcqsRRnJBpqMRcVJwIA
        jVoxjykDAAA=
X-CMS-MailID: 20210121121339epcas2p25c2798ee4139aa18ad562a94c43ced06
X-Msg-Generator: CA
X-Sendblock-Type: AUTO_CONFIDENTIAL
CMS-TYPE: 102P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20210115133200epcas2p1f52efe7bbc2826ed12da2fde4e03e3b2
References: <CGME20210115133200epcas2p1f52efe7bbc2826ed12da2fde4e03e3b2@epcas2p1.samsung.com>
        <1610716836-140533-1-git-send-email-dseok.yi@samsung.com>
        <20210118132736.GM3576117@gauss3.secunet.de> 
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2021-01-20 15:56, Dongseok Yi wrote:
> On 2021-01-18 22:27, Steffen Klassert wrote:
> > On Fri, Jan 15, 2021 at 10:20:35PM +0900, Dongseok Yi wrote:
> > > UDP/IP header of UDP GROed frag_skbs are not updated even after NAT
> > > forwarding. Only the header of head_skb from ip_finish_output_gso ->
> > > skb_gso_segment is updated but following frag_skbs are not updated.
> > >
> > > A call path skb_mac_gso_segment -> inet_gso_segment ->
> > > udp4_ufo_fragment -> __udp_gso_segment -> __udp_gso_segment_list
> > > does not try to update UDP/IP header of the segment list but copy
> > > only the MAC header.
> > >
> > > Update dport, daddr and checksums of each skb of the segment list
> > > in __udp_gso_segment_list. It covers both SNAT and DNAT.
> > >
> > > Fixes: 9fd1ff5d2ac7 (udp: Support UDP fraglist GRO/GSO.)
> > > Signed-off-by: Dongseok Yi <dseok.yi@samsung.com>
> > > ---
> > > v1:
> > > Steffen Klassert said, there could be 2 options.
> > > https://lore.kernel.org/patchwork/patch/1362257/
> > > I was trying to write a quick fix, but it was not easy to forward
> > > segmented list. Currently, assuming DNAT only.
> > >
> > > v2:
> > > Per Steffen Klassert request, move the procedure from
> > > udp4_ufo_fragment to __udp_gso_segment_list and support SNAT.
> > >
> > > To Alexander Lobakin, I've checked your email late. Just use this
> > > patch as a reference. It support SNAT too, but does not support IPv6
> > > yet. I cannot make IPv6 header changes in __udp_gso_segment_list due
> > > to the file is in IPv4 directory.
> > >
> > >  include/net/udp.h      |  2 +-
> > >  net/ipv4/udp_offload.c | 62 ++++++++++++++++++++++++++++++++++++++++++++++----
> > >  net/ipv6/udp_offload.c |  2 +-
> > >  3 files changed, 59 insertions(+), 7 deletions(-)
> > >
> > > diff --git a/include/net/udp.h b/include/net/udp.h
> > > index 877832b..01351ba 100644
> > > --- a/include/net/udp.h
> > > +++ b/include/net/udp.h
> > > @@ -178,7 +178,7 @@ struct sk_buff *udp_gro_receive(struct list_head *head, struct sk_buff *skb,
> > >  int udp_gro_complete(struct sk_buff *skb, int nhoff, udp_lookup_t lookup);
> > >
> > >  struct sk_buff *__udp_gso_segment(struct sk_buff *gso_skb,
> > > -				  netdev_features_t features);
> > > +				  netdev_features_t features, bool is_ipv6);
> > >
> > >  static inline struct udphdr *udp_gro_udphdr(struct sk_buff *skb)
> > >  {
> > > diff --git a/net/ipv4/udp_offload.c b/net/ipv4/udp_offload.c
> > > index ff39e94..c532d3b 100644
> > > --- a/net/ipv4/udp_offload.c
> > > +++ b/net/ipv4/udp_offload.c
> > > @@ -187,8 +187,57 @@ struct sk_buff *skb_udp_tunnel_segment(struct sk_buff *skb,
> > >  }
> > >  EXPORT_SYMBOL(skb_udp_tunnel_segment);
> > >
> > > +static void __udpv4_gso_segment_csum(struct sk_buff *seg,
> > > +				     __be32 *oldip, __be32 *newip,
> > > +				     __be16 *oldport, __be16 *newport)
> > > +{
> > > +	struct udphdr *uh = udp_hdr(seg);
> > > +	struct iphdr *iph = ip_hdr(seg);
> > > +
> > > +	if (uh->check) {
> > > +		inet_proto_csum_replace4(&uh->check, seg, *oldip, *newip,
> > > +					 true);
> > > +		inet_proto_csum_replace2(&uh->check, seg, *oldport, *newport,
> > > +					 false);
> > > +		if (!uh->check)
> > > +			uh->check = CSUM_MANGLED_0;
> > > +	}
> > > +	uh->dest = *newport;
> > > +
> > > +	csum_replace4(&iph->check, *oldip, *newip);
> > > +	iph->daddr = *newip;
> > > +}
> >
> > Can't we just do the checksum recalculation for this case as it is done
> > with standard GRO?
> 
> If I understand standard GRO correctly, it calculates full checksum.
> Should we adopt the same method to UDP GRO fraglist? I did not find
> a simple method for the incremental checksum update.
> 
> >
> > > +
> > > +static struct sk_buff *__udpv4_gso_segment_list_csum(struct sk_buff *segs)
> > > +{
> > > +	struct sk_buff *seg;
> > > +	struct udphdr *uh, *uh2;
> > > +	struct iphdr *iph, *iph2;
> > > +
> > > +	seg = segs;
> > > +	uh = udp_hdr(seg);
> > > +	iph = ip_hdr(seg);
> > > +
> > > +	while ((seg = seg->next)) {
> > > +		uh2 = udp_hdr(seg);
> > > +		iph2 = ip_hdr(seg);
> > > +
> > > +		if (uh->source != uh2->source || iph->saddr != iph2->saddr)
> > > +			__udpv4_gso_segment_csum(seg,
> > > +						 &iph2->saddr, &iph->saddr,
> > > +						 &uh2->source, &uh->source);
> > > +
> > > +		if (uh->dest != uh2->dest || iph->daddr != iph2->daddr)
> > > +			__udpv4_gso_segment_csum(seg,
> > > +						 &iph2->daddr, &iph->daddr,
> > > +						 &uh2->dest, &uh->dest);
> > > +	}
> >
> > You don't need to check the addresses and ports of all packets in the
> > segment list. If the addresses and ports are equal for the first and
> > second packet in the list, then this also holds for the rest of the
> > packets.
> 
> I think we can try this with an additional flag (seg_csum).
> 
> diff --git a/net/ipv4/udp_offload.c b/net/ipv4/udp_offload.c
> index 36b7e30..3f892df 100644
> --- a/net/ipv4/udp_offload.c
> +++ b/net/ipv4/udp_offload.c
> @@ -213,25 +213,36 @@ static struct sk_buff *__udpv4_gso_segment_list_csum(struct sk_buff *segs)
>         struct sk_buff *seg;
>         struct udphdr *uh, *uh2;
>         struct iphdr *iph, *iph2;
> +       bool seg_csum = false;
> 
>         seg = segs;
>         uh = udp_hdr(seg);
>         iph = ip_hdr(seg);
> 
> -       while ((seg = seg->next)) {
> +       seg = seg->next;
> +       do {
> +               if (!seg)
> +                       break;
> +
>                 uh2 = udp_hdr(seg);
>                 iph2 = ip_hdr(seg);
> 
> -               if (uh->source != uh2->source || iph->saddr != iph2->saddr)
> +               if (uh->source != uh2->source || iph->saddr != iph2->saddr) {
>                         __udpv4_gso_segment_csum(seg,
>                                                  &iph2->saddr, &iph->saddr,
>                                                  &uh2->source, &uh->source);
> +                       seg_csum = true;
> +               }
> 
> -               if (uh->dest != uh2->dest || iph->daddr != iph2->daddr)
> +               if (uh->dest != uh2->dest || iph->daddr != iph2->daddr) {
>                         __udpv4_gso_segment_csum(seg,
>                                                  &iph2->daddr, &iph->daddr,
>                                                  &uh2->dest, &uh->dest);
> -       }
> +                       seg_csum = true;
> +               }
> +
> +               seg = seg->next;
> +       } while (seg_csum);
> 
>         return segs;
>  }

Hi, Steffen
Do you have any further comments for this? I think the bug fix has
higher priority than optimization. Can we defer the optimization
patch?


Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5D9313048F8
	for <lists+netdev@lfdr.de>; Tue, 26 Jan 2021 20:46:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726468AbhAZFff (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Jan 2021 00:35:35 -0500
Received: from mailout3.samsung.com ([203.254.224.33]:60919 "EHLO
        mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731220AbhAZCQS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 Jan 2021 21:16:18 -0500
Received: from epcas2p4.samsung.com (unknown [182.195.41.56])
        by mailout3.samsung.com (KnoxPortal) with ESMTP id 20210126003135epoutp030246cad0c31da48f15bf096005a97209~doNkFUw012424024240epoutp03j
        for <netdev@vger.kernel.org>; Tue, 26 Jan 2021 00:31:35 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout3.samsung.com 20210126003135epoutp030246cad0c31da48f15bf096005a97209~doNkFUw012424024240epoutp03j
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1611621095;
        bh=OGsj0MIkfZyHE5NB7L5PUMSmlStzrlK4MtVhzEASbSs=;
        h=From:To:Cc:In-Reply-To:Subject:Date:References:From;
        b=B0p6OWhGMQlNRmkHj4YUQp7gfboquYB4cc++ftdLQtcD5b9Uj6vhLR50ZbbFMY+jh
         9Xr9AO/qBH6EyZyKwtN4/2lgu7sxXdQDziDzoak7anqPeZkvlC6kJ8lS/eJa1jl/g6
         ZW2qMC5UjhHfPBlCkQEMIXj92fbOoLZEyCV0qDMk=
Received: from epsnrtp4.localdomain (unknown [182.195.42.165]) by
        epcas2p4.samsung.com (KnoxPortal) with ESMTP id
        20210126003135epcas2p4647eac927b8dd478b8e804f3100b1736~doNjpjh1b2228122281epcas2p4u;
        Tue, 26 Jan 2021 00:31:35 +0000 (GMT)
Received: from epsmges2p3.samsung.com (unknown [182.195.40.187]) by
        epsnrtp4.localdomain (Postfix) with ESMTP id 4DPnjK1vzbz4x9Pp; Tue, 26 Jan
        2021 00:31:33 +0000 (GMT)
Received: from epcas2p1.samsung.com ( [182.195.41.53]) by
        epsmges2p3.samsung.com (Symantec Messaging Gateway) with SMTP id
        98.1E.05262.2E26F006; Tue, 26 Jan 2021 09:31:30 +0900 (KST)
Received: from epsmtrp2.samsung.com (unknown [182.195.40.14]) by
        epcas2p4.samsung.com (KnoxPortal) with ESMTPA id
        20210126003130epcas2p4edac02397592781f3f06fd0c58421c44~doNfXQtOm2472924729epcas2p4y;
        Tue, 26 Jan 2021 00:31:30 +0000 (GMT)
Received: from epsmgms1p1new.samsung.com (unknown [182.195.42.41]) by
        epsmtrp2.samsung.com (KnoxPortal) with ESMTP id
        20210126003130epsmtrp26f9d9f62bdd05e83caca4106c42dedb3~doNfWbMQl0296902969epsmtrp2G;
        Tue, 26 Jan 2021 00:31:30 +0000 (GMT)
X-AuditID: b6c32a47-b81ff7000000148e-e1-600f62e2bcb5
Received: from epsmtip2.samsung.com ( [182.195.34.31]) by
        epsmgms1p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
        00.78.13470.2E26F006; Tue, 26 Jan 2021 09:31:30 +0900 (KST)
Received: from KORDO035731 (unknown [12.36.185.47]) by epsmtip2.samsung.com
        (KnoxPortal) with ESMTPA id
        20210126003130epsmtip2e461871cde2e8e6352adef2e2667bb26~doNfH35tU2637426374epsmtip21;
        Tue, 26 Jan 2021 00:31:30 +0000 (GMT)
From:   "Dongseok Yi" <dseok.yi@samsung.com>
To:     "'Steffen Klassert'" <steffen.klassert@secunet.com>
Cc:     "'David S. Miller'" <davem@davemloft.net>,
        "'Alexander Lobakin'" <alobakin@pm.me>, <namkyu78.kim@samsung.com>,
        "'Jakub Kicinski'" <kuba@kernel.org>,
        "'Hideaki YOSHIFUJI'" <yoshfuji@linux-ipv6.org>,
        "'Willem de Bruijn'" <willemb@google.com>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
In-Reply-To: <20210125124544.GW3576117@gauss3.secunet.de>
Subject: RE: [PATCH net v3] udp: ipv4: manipulate network header of NATed
 UDP GRO fraglist
Date:   Tue, 26 Jan 2021 09:31:29 +0900
Message-ID: <026001d6f37a$97461300$c5d23900$@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="Windows-1252"
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Outlook 16.0
Thread-Index: AQD8+b0cWZtPvmUMIOPw0keCYjUzAAJKUisyAbm6YsWrzN/I0A==
Content-Language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrHJsWRmVeSWpSXmKPExsWy7bCmqe6jJP4Eg70rzC1WPd7OYjHnfAuL
        xYVtfawWl3fNYbNouNPMZnFsgZjF7s4f7Bbvthxht/i6t4vFgdNjy8qbTB4LNpV6bFrVyebR
        dm0Vk8fRPefYPPq2rGL02NS6hNXj8ya5AI6oHJuM1MSU1CKF1Lzk/JTMvHRbJe/geOd4UzMD
        Q11DSwtzJYW8xNxUWyUXnwBdt8wcoOuUFMoSc0qBQgGJxcVK+nY2RfmlJakKGfnFJbZKqQUp
        OQWGhgV6xYm5xaV56XrJ+blWhgYGRqZAlQk5GW9nnGMvuGtSsb3zGnMD42bNLkZODgkBE4mV
        RzqZuhi5OIQEdjBKXPzcwQ7hfGKU+LPtMzOE841R4vmDBWxdjBxgLRcPFEPE9zJKPLtxjA3C
        ecEoca5vIzPIXDYBLYk3s9pZQWwRAXOJ1a+mge1gFtjKJPHw61QWkEmcApYSHw+UgNQIC8RI
        rN/6iR3EZhFQlbi+qRtsDi9QybKJy9ghbEGJkzOfsIDYzAIGEu/PzWeGsOUltr+dwwzxj4LE
        z6fLoPY6SfTd72WCqBGRmN3ZBvaNhMAeDonrN1+yQ3zjIvFqix5Er7DEq+Nb2CFsKYnP7/ZC
        PVwv0dodA9HawyhxZR/EDRICxhKznrUzQtQoSxy5BXUan0TH4b9Q03klOtqEIEwliYlf4iEa
        JSRenJzMMoFRaRaSv2Yh+WsWkr9mIbl/ASPLKkax1ILi3PTUYqMCY+S43sQITrha7jsYZ7z9
        oHeIkYmD8RCjBAezkgjvbj2eBCHelMTKqtSi/Pii0pzU4kOMpsCgnsgsJZqcD0z5eSXxhqZG
        ZmYGlqYWpmZGFkrivMUGD+KFBNITS1KzU1MLUotg+pg4OKUamBxCpGUeLTRZ2GxQmOk1qTzz
        3I8H3uu5g9r945pkp7LFPay0q2p0PTT36yyfpxN7o5Jn8B6/b6MSZFHFsf5g/8oZdeUx/38X
        1FZnPK1U/LcsQe9+QIrzp9hJrz0dJyaU/CxSXHRaQeTIK3ORvd18D68962d3DpLaMeeCoN6R
        maofLtRqJBj4XNDcUyIlE/34kNKW1ewMm8VZ5f5qMpRW14vcFJWxXr46VTv17QQd7zs8XI+k
        ts5gFb3/+7rtNatErSdfzd7xsxSqWS/kZ7/5nunCRR5VLX7OWN8FsxPcWg8WbvZ6eU/5pavL
        dPc1H9ecyV95r34HjzfvCZN1/O1nPjx7+Okq06yEFdz3gssNlViKMxINtZiLihMByeXtDEEE
        AAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprJIsWRmVeSWpSXmKPExsWy7bCSvO6jJP4Eg0O7pCxWPd7OYjHnfAuL
        xYVtfawWl3fNYbNouNPMZnFsgZjF7s4f7Bbvthxht/i6t4vFgdNjy8qbTB4LNpV6bFrVyebR
        dm0Vk8fRPefYPPq2rGL02NS6hNXj8ya5AI4oLpuU1JzMstQifbsEroy3M86xF9w1qdjeeY25
        gXGzZhcjB4eEgInExQPFXYxcHEICuxklHh/exwYRl5DYtdm1i5ETyBSWuN9yhBWi5hmjxJv7
        k1hAEmwCWhJvZrWzgtgiAuYSq19NYwIpYhbYzSTxtec+M0THYUaJO/M+sIJM5RSwlPh4oASk
        QVggSuLy1K2MIDaLgKrE9U3dzCA2L1DJsonL2CFsQYmTM5+ALWMWMJI4d2g/G4QtL7H97Rxm
        iOsUJH4+XQZ1hJNE3/1eJogaEYnZnW3MExiFZyEZNQvJqFlIRs1C0rKAkWUVo2RqQXFuem6x
        YYFhXmq5XnFibnFpXrpecn7uJkZw7Glp7mDcvuqD3iFGJg7GQ4wSHMxKIry79XgShHhTEiur
        Uovy44tKc1KLDzFKc7AoifNe6DoZLySQnliSmp2aWpBaBJNl4uCUamAKyJ3hd/e1zq2FV7tf
        35rBUb7k9obexOK/J7dk362q+9odId3zLW22Dtf6XjZeQ9cO5TTGpljdnC7uWwumxwXM2rnt
        40Sh6x3JV+4bhZktz76vy/rrTdMTvu5Ny7Q0a29EBoov/DzV99KhiDTBn09PXZhXLvd6kc3F
        TT+3K6SnKc1o/MnQr5U0/9vZlYve2q6NObD6pb3Ahw/3fit16U1ytEsVShUqnM/NlzL/fNqZ
        5jXPZy6KeV7w2lr15Kdgx/0vOeS7C9TepV44cFpjtopLaO9qX5dJWyv9VSYUs56SvLnnTc+H
        RyWe7dduL98Wxmm7Lsj1n1et9NxXRgLHohu0TMuNHntmXPrzYEP59f+9SizFGYmGWsxFxYkA
        H/WuMiwDAAA=
X-CMS-MailID: 20210126003130epcas2p4edac02397592781f3f06fd0c58421c44
X-Msg-Generator: CA
X-Sendblock-Type: AUTO_CONFIDENTIAL
CMS-TYPE: 102P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20210121133649epcas2p493d5d59df1b48ee8e3282ab766f37a70
References: <CGME20210121133649epcas2p493d5d59df1b48ee8e3282ab766f37a70@epcas2p4.samsung.com>
        <1611235479-39399-1-git-send-email-dseok.yi@samsung.com>
        <20210125124544.GW3576117@gauss3.secunet.de>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 1/25/21 9:45 PM, Steffen Klassert wrote:
> On Thu, Jan 21, 2021 at 10:24:39PM +0900, Dongseok Yi wrote:
> > UDP/IP header of UDP GROed frag_skbs are not updated even after NAT
> > forwarding. Only the header of head_skb from ip_finish_output_gso ->
> > skb_gso_segment is updated but following frag_skbs are not updated.
> >
> > A call path skb_mac_gso_segment -> inet_gso_segment ->
> > udp4_ufo_fragment -> __udp_gso_segment -> __udp_gso_segment_list
> > does not try to update UDP/IP header of the segment list but copy
> > only the MAC header.
> >
> > Update port, addr and check of each skb of the segment list in
> > __udp_gso_segment_list. It covers both SNAT and DNAT.
> >
> > Fixes: 9fd1ff5d2ac7 (udp: Support UDP fraglist GRO/GSO.)
> > Signed-off-by: Dongseok Yi <dseok.yi@samsung.com>
> > ---
> > v1:
> > Steffen Klassert said, there could be 2 options.
> > https://lore.kernel.org/patchwork/patch/1362257/
> > I was trying to write a quick fix, but it was not easy to forward
> > segmented list. Currently, assuming DNAT only.
> >
> > v2:
> > Per Steffen Klassert request, moved the procedure from
> > udp4_ufo_fragment to __udp_gso_segment_list and support SNAT.
> >
> > v3:
> > Per Steffen Klassert request, applied fast return by comparing seg
> > and seg->next at the beginning of __udpv4_gso_segment_list_csum.
> >
> > Fixed uh->dest = *newport and iph->daddr = *newip to
> > *oldport = *newport and *oldip = *newip.
> >
> >  include/net/udp.h      |  2 +-
> >  net/ipv4/udp_offload.c | 72 ++++++++++++++++++++++++++++++++++++++++++++++----
> >  net/ipv6/udp_offload.c |  2 +-
> >  3 files changed, 69 insertions(+), 7 deletions(-)
> >
> > diff --git a/include/net/udp.h b/include/net/udp.h
> > index 877832b..01351ba 100644
> > --- a/include/net/udp.h
> > +++ b/include/net/udp.h
> > @@ -178,7 +178,7 @@ struct sk_buff *udp_gro_receive(struct list_head *head, struct sk_buff *skb,
> >  int udp_gro_complete(struct sk_buff *skb, int nhoff, udp_lookup_t lookup);
> >
> >  struct sk_buff *__udp_gso_segment(struct sk_buff *gso_skb,
> > -				  netdev_features_t features);
> > +				  netdev_features_t features, bool is_ipv6);
> >
> >  static inline struct udphdr *udp_gro_udphdr(struct sk_buff *skb)
> >  {
> > diff --git a/net/ipv4/udp_offload.c b/net/ipv4/udp_offload.c
> > index ff39e94..43660cf 100644
> > --- a/net/ipv4/udp_offload.c
> > +++ b/net/ipv4/udp_offload.c
> > @@ -187,8 +187,67 @@ struct sk_buff *skb_udp_tunnel_segment(struct sk_buff *skb,
> >  }
> >  EXPORT_SYMBOL(skb_udp_tunnel_segment);
> >
> > +static void __udpv4_gso_segment_csum(struct sk_buff *seg,
> > +				     __be32 *oldip, __be32 *newip,
> > +				     __be16 *oldport, __be16 *newport)
> > +{
> > +	struct udphdr *uh;
> > +	struct iphdr *iph;
> > +
> > +	if (*oldip == *newip && *oldport == *newport)
> > +		return;
> 
> This check is redundant as you check this already in
> __udpv4_gso_segment_list_csum.

When comes in __udpv4_gso_segment_csum, the condition would be
SNAT or DNAT. I think we don't need to do the function if the
condition is not met. I want to skip the function for SNAT checksum
when DNAT only case. Is it better to remove the check?

> 
> Looks ok otherwise.
> 
> > +
> > +	uh = udp_hdr(seg);
> > +	iph = ip_hdr(seg);
> > +
> > +	if (uh->check) {
> > +		inet_proto_csum_replace4(&uh->check, seg, *oldip, *newip,
> > +					 true);
> > +		inet_proto_csum_replace2(&uh->check, seg, *oldport, *newport,
> > +					 false);
> > +		if (!uh->check)
> > +			uh->check = CSUM_MANGLED_0;
> > +	}
> > +	*oldport = *newport;
> > +
> > +	csum_replace4(&iph->check, *oldip, *newip);
> > +	*oldip = *newip;
> > +}
> > +
> > +static struct sk_buff *__udpv4_gso_segment_list_csum(struct sk_buff *segs)
> > +{
> > +	struct sk_buff *seg;
> > +	struct udphdr *uh, *uh2;
> > +	struct iphdr *iph, *iph2;
> > +
> > +	seg = segs;
> > +	uh = udp_hdr(seg);
> > +	iph = ip_hdr(seg);
> > +
> > +	if ((udp_hdr(seg)->dest == udp_hdr(seg->next)->dest) &&
> > +	    (udp_hdr(seg)->source == udp_hdr(seg->next)->source) &&
> > +	    (ip_hdr(seg)->daddr == ip_hdr(seg->next)->daddr) &&
> > +	    (ip_hdr(seg)->saddr == ip_hdr(seg->next)->saddr))
> > +		return segs;
> > +
> > +	while ((seg = seg->next)) {
> > +		uh2 = udp_hdr(seg);
> > +		iph2 = ip_hdr(seg);
> > +
> > +		__udpv4_gso_segment_csum(seg,
> > +					 &iph2->saddr, &iph->saddr,
> > +					 &uh2->source, &uh->source);
> > +		__udpv4_gso_segment_csum(seg,
> > +					 &iph2->daddr, &iph->daddr,
> > +					 &uh2->dest, &uh->dest);
> > +	}
> > +
> > +	return segs;
> > +}
> > +
> >  static struct sk_buff *__udp_gso_segment_list(struct sk_buff *skb,
> > -					      netdev_features_t features)
> > +					      netdev_features_t features,
> > +					      bool is_ipv6)
> >  {
> >  	unsigned int mss = skb_shinfo(skb)->gso_size;
> >
> > @@ -198,11 +257,14 @@ static struct sk_buff *__udp_gso_segment_list(struct sk_buff *skb,
> >
> >  	udp_hdr(skb)->len = htons(sizeof(struct udphdr) + mss);
> >
> > -	return skb;
> > +	if (is_ipv6)
> > +		return skb;
> > +	else
> > +		return __udpv4_gso_segment_list_csum(skb);
> >  }
> >
> >  struct sk_buff *__udp_gso_segment(struct sk_buff *gso_skb,
> > -				  netdev_features_t features)
> > +				  netdev_features_t features, bool is_ipv6)
> >  {
> >  	struct sock *sk = gso_skb->sk;
> >  	unsigned int sum_truesize = 0;
> > @@ -214,7 +276,7 @@ struct sk_buff *__udp_gso_segment(struct sk_buff *gso_skb,
> >  	__be16 newlen;
> >
> >  	if (skb_shinfo(gso_skb)->gso_type & SKB_GSO_FRAGLIST)
> > -		return __udp_gso_segment_list(gso_skb, features);
> > +		return __udp_gso_segment_list(gso_skb, features, is_ipv6);
> >
> >  	mss = skb_shinfo(gso_skb)->gso_size;
> >  	if (gso_skb->len <= sizeof(*uh) + mss)
> > @@ -328,7 +390,7 @@ static struct sk_buff *udp4_ufo_fragment(struct sk_buff *skb,
> >  		goto out;
> >
> >  	if (skb_shinfo(skb)->gso_type & SKB_GSO_UDP_L4)
> > -		return __udp_gso_segment(skb, features);
> > +		return __udp_gso_segment(skb, features, false);
> >
> >  	mss = skb_shinfo(skb)->gso_size;
> >  	if (unlikely(skb->len <= mss))
> > diff --git a/net/ipv6/udp_offload.c b/net/ipv6/udp_offload.c
> > index c7bd7b1..faa823c 100644
> > --- a/net/ipv6/udp_offload.c
> > +++ b/net/ipv6/udp_offload.c
> > @@ -42,7 +42,7 @@ static struct sk_buff *udp6_ufo_fragment(struct sk_buff *skb,
> >  			goto out;
> >
> >  		if (skb_shinfo(skb)->gso_type & SKB_GSO_UDP_L4)
> > -			return __udp_gso_segment(skb, features);
> > +			return __udp_gso_segment(skb, features, true);
> >
> >  		mss = skb_shinfo(skb)->gso_size;
> >  		if (unlikely(skb->len <= mss))
> > --
> > 2.7.4


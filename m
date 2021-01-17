Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8E1A52F9675
	for <lists+netdev@lfdr.de>; Mon, 18 Jan 2021 00:56:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730192AbhAQX40 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 17 Jan 2021 18:56:26 -0500
Received: from mailout2.samsung.com ([203.254.224.25]:40735 "EHLO
        mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729621AbhAQX4Q (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 17 Jan 2021 18:56:16 -0500
Received: from epcas2p4.samsung.com (unknown [182.195.41.56])
        by mailout2.samsung.com (KnoxPortal) with ESMTP id 20210117235532epoutp02dd5133b55ff1fd1247b8e933e27e6a72~bKjz0MKaZ1105911059epoutp02E
        for <netdev@vger.kernel.org>; Sun, 17 Jan 2021 23:55:32 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.samsung.com 20210117235532epoutp02dd5133b55ff1fd1247b8e933e27e6a72~bKjz0MKaZ1105911059epoutp02E
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1610927733;
        bh=qYM8peW2AjSGF9pUtcB20zc3RGH88e8d217Rrq3UYsA=;
        h=From:To:Cc:In-Reply-To:Subject:Date:References:From;
        b=dMyyXbSEEh3zM1Xz6Ab3tSKVkC5CUMDWh7BdlVQYhhFi9YJbQqU8VCaUoy4guAbPG
         kw/iPEnJr7nUWcIOqoYyUpbUprUexi2hXoZC4jAGI80ud4k3a7h2m+oRInmb6vXpXN
         sTZ6YGNwSfkXSE9V0DhSSh/d4+C/dZj3EnZPAo3U=
Received: from epsnrtp4.localdomain (unknown [182.195.42.165]) by
        epcas2p1.samsung.com (KnoxPortal) with ESMTP id
        20210117235532epcas2p1775ca676498d3f1332d6db5e5357c34a~bKjzMHgs03144131441epcas2p1m;
        Sun, 17 Jan 2021 23:55:32 +0000 (GMT)
Received: from epsmges2p4.samsung.com (unknown [182.195.40.184]) by
        epsnrtp4.localdomain (Postfix) with ESMTP id 4DJsHP48h0z4x9QB; Sun, 17 Jan
        2021 23:55:29 +0000 (GMT)
Received: from epcas2p2.samsung.com ( [182.195.41.54]) by
        epsmges2p4.samsung.com (Symantec Messaging Gateway) with SMTP id
        78.14.52511.07EC4006; Mon, 18 Jan 2021 08:55:28 +0900 (KST)
Received: from epsmtrp1.samsung.com (unknown [182.195.40.13]) by
        epcas2p3.samsung.com (KnoxPortal) with ESMTPA id
        20210117235528epcas2p3d3db81d17c6c182b49afe808d7c142be~bKjvSedkd0572605726epcas2p3b;
        Sun, 17 Jan 2021 23:55:28 +0000 (GMT)
Received: from epsmgms1p1new.samsung.com (unknown [182.195.42.41]) by
        epsmtrp1.samsung.com (KnoxPortal) with ESMTP id
        20210117235528epsmtrp172f3791aca954ca2b38d17a169e8e102~bKjvRNohE0966309663epsmtrp1N;
        Sun, 17 Jan 2021 23:55:28 +0000 (GMT)
X-AuditID: b6c32a48-4f9ff7000000cd1f-d2-6004ce708f31
Received: from epsmtip1.samsung.com ( [182.195.34.30]) by
        epsmgms1p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
        D4.9E.13470.F6EC4006; Mon, 18 Jan 2021 08:55:27 +0900 (KST)
Received: from KORDO035731 (unknown [12.36.185.47]) by epsmtip1.samsung.com
        (KnoxPortal) with ESMTPA id
        20210117235527epsmtip171b2f31bfb14ec51c96e451fc33f6e48~bKjvB6qCu0339203392epsmtip1o;
        Sun, 17 Jan 2021 23:55:27 +0000 (GMT)
From:   "Dongseok Yi" <dseok.yi@samsung.com>
To:     "'Alexander Lobakin'" <alobakin@pm.me>
Cc:     "'David S. Miller'" <davem@davemloft.net>,
        "'Steffen Klassert'" <steffen.klassert@secunet.com>,
        <namkyu78.kim@samsung.com>, "'Jakub Kicinski'" <kuba@kernel.org>,
        "'Hideaki YOSHIFUJI'" <yoshfuji@linux-ipv6.org>,
        "'Willem de Bruijn'" <willemb@google.com>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
In-Reply-To: <20210115171203.175115-1-alobakin@pm.me>
Subject: RE: [PATCH net v2] udp: ipv4: manipulate network header of NATed
 UDP GRO fraglist
Date:   Mon, 18 Jan 2021 08:55:27 +0900
Message-ID: <023201d6ed2c$3b0c8af0$b125a0d0$@samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Outlook 16.0
Thread-Index: AQJT4Rp7bAvF1bGeZTYGN+mZAmy16AFN1KutAf1qvD+pGDrwsA==
Content-Language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrPJsWRmVeSWpSXmKPExsWy7bCmmW7BOZYEg/tXpCxWPd7OYjHnfAuL
        xYVtfawWl3fNYbNouNPMZnFsgZjF7s4f7Bbvthxht/i6t4vFgdNjy8qbTB4LNpV6bFrVyebR
        dm0Vk8fRPefYPPq2rGL02NS6hNXj8ya5AI6oHJuM1MSU1CKF1Lzk/JTMvHRbJe/geOd4UzMD
        Q11DSwtzJYW8xNxUWyUXnwBdt8wcoOuUFMoSc0qBQgGJxcVK+nY2RfmlJakKGfnFJbZKqQUp
        OQWGhgV6xYm5xaV56XrJ+blWhgYGRqZAlQk5Ga+29DEXzDSr+H34JksD4wrtLkZODgkBE4mt
        Z5tZuhi5OIQEdjBKHN91hx3C+cQosfP1XqjMN0aJO90tzDAtT/98gKrayyhx/exXqKoXjBLz
        P0xmB6liE9CSeDOrnRXEFgGyVx77zQhSxCxwiEli/+GbYEWcAqYSu3Z0gBUJC8RIPJ3UyQZi
        swioSmy9fRjM5hWwlNizvY0JwhaUODnzCQuIzSwgL7H97RyokxQkfj5dBrXMSeLJ+oXMEDUi
        ErM725hBFksI7OCQOPb9I1SDi8SxAwtYIWxhiVfHt7BD2FISL/vbgGwOILteorU7BqK3h1Hi
        yj6IxRICxhKznrUzgtQwC2hKrN+lD1GuLHHkFtRpfBIdh/9CTeGV6GgTgjCVJCZ+iYeYISHx
        4uRklgmMSrOQ/DULyV+zkNw/C2HVAkaWVYxiqQXFuempxUYFJsiRvYkRnHK1PHYwzn77Qe8Q
        IxMH4yFGCQ5mJRHe0nVMCUK8KYmVValF+fFFpTmpxYcYTYEhPZFZSjQ5H5j080riDU2NzMwM
        LE0tTM2MLJTEeYsMHsQLCaQnlqRmp6YWpBbB9DFxcEo1MCUe+5q1M3bmK/YbS78fbCuca/B7
        S9BBsYMxMcl8hcfns1pXP6q5kbx4UtPZuEv7jX3ydfz1EqUZTGwkU85n3sozSrguoPKraY1j
        7NHAna8sDPkyLwhH9qzWm8JcMmXz9c//FsW4FrbM2Sl1Pj3B2XaXtoBw3IGm2kk7P+5auibE
        L8BNO8jh323brcJNQe9D9u/o/B6/yjol10Q6QNnJ+03+znpbr8BPTj/3l5qc2bXr/u4imZ2s
        ga95+GNTrvUF83tkTuT6zW7N+6sm6vHBJxOqXQOd9GwfvVu58MG/EyZPtZLkygUMr83JrZK/
        c7rp7sezyboNzsl9D2Wi6vN3FJ3saC3QWyDbo9Lx1eepEktxRqKhFnNRcSIANbGhi0IEAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprNIsWRmVeSWpSXmKPExsWy7bCSnG7+OZYEgyMzrS1WPd7OYjHnfAuL
        xYVtfawWl3fNYbNouNPMZnFsgZjF7s4f7Bbvthxht/i6t4vFgdNjy8qbTB4LNpV6bFrVyebR
        dm0Vk8fRPefYPPq2rGL02NS6hNXj8ya5AI4oLpuU1JzMstQifbsEroxXW/qYC2aaVfw+fJOl
        gXGFdhcjJ4eEgInE0z8f2LsYuTiEBHYzSnw5OAfI4QBKSEjs2uwKUSMscb/lCCtEzTNGibld
        rWwgCTYBLYk3s9pZQWwRIHvlsd+MIEXMAieYJL6+ec8C0XGAUeLk3WNgVZwCphK7dnSA2cIC
        URK9be+YQWwWAVWJrbcPg03lFbCU2LO9jQnCFpQ4OfMJC4jNLKAt0fuwlRHClpfY/nYOM8R5
        ChI/ny6DusJJ4sn6hcwQNSISszvbmCcwCs9CMmoWklGzkIyahaRlASPLKkbJ1ILi3PTcYsMC
        w7zUcr3ixNzi0rx0veT83E2M4PjT0tzBuH3VB71DjEwcjIcYJTiYlUR4S9cxJQjxpiRWVqUW
        5ccXleakFh9ilOZgURLnvdB1Ml5IID2xJDU7NbUgtQgmy8TBKdXAFCHkEXl83cac6Ob0usL9
        KgzbVfRNUmpYe1YcmuthvNJaO9q56V9r+btWW93L8+W63I4miC2Nf2u/LmCdTdut745buy8+
        3antnKe+zjawOXj+9ifq8i4Hs7sbxM8+5jU8V//szp9v9xffrr5iPG/jL5kv6y/kZXBN2ni/
        Xvb76wNmpscfbAi9KxfwNmWS66ECAbOI/9GTr/CtvpPHk70vaZWP0uzyrfe1UxTfPc54/U/R
        8IVSv6rl3cXcKhuV5PqzZypfE+fgz/GMPfmo+8MN7c79X0trNwtwLnrs8XEpd4epa3Py/8vH
        4qz7piUe/653x0Bjf8Thrbm5RZ/M8/siE8O+OygGTz675MX2LPvbSizFGYmGWsxFxYkAnXI8
        AS4DAAA=
X-CMS-MailID: 20210117235528epcas2p3d3db81d17c6c182b49afe808d7c142be
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: AUTO_CONFIDENTIAL
CMS-TYPE: 102P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20210115133200epcas2p1f52efe7bbc2826ed12da2fde4e03e3b2
References: <CGME20210115133200epcas2p1f52efe7bbc2826ed12da2fde4e03e3b2@epcas2p1.samsung.com>
        <1610716836-140533-1-git-send-email-dseok.yi@samsung.com>
        <20210115171203.175115-1-alobakin@pm.me>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2021-01-16 02:12, Alexander Lobakin wrote:
> From: Dongseok Yi <dseok.yi@samsung.com>
> Date: Fri, 15 Jan 2021 22:20:35 +0900
> 
> > UDP/IP header of UDP GROed frag_skbs are not updated even after NAT
> > forwarding. Only the header of head_skb from ip_finish_output_gso ->
> > skb_gso_segment is updated but following frag_skbs are not updated.
> >
> > A call path skb_mac_gso_segment -> inet_gso_segment ->
> > udp4_ufo_fragment -> __udp_gso_segment -> __udp_gso_segment_list
> > does not try to update UDP/IP header of the segment list but copy
> > only the MAC header.
> >
> > Update dport, daddr and checksums of each skb of the segment list
> > in __udp_gso_segment_list. It covers both SNAT and DNAT.
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
> > Per Steffen Klassert request, move the procedure from
> > udp4_ufo_fragment to __udp_gso_segment_list and support SNAT.
> >
> > To Alexander Lobakin, I've checked your email late. Just use this
> > patch as a reference. It support SNAT too, but does not support IPv6
> > yet. I cannot make IPv6 header changes in __udp_gso_segment_list due
> > to the file is in IPv4 directory.
> 
> I used another approach, tried to make fraglist GRO closer to plain
> in terms of checksummming, as it is confusing to me why GSO packet
> should have CHECKSUM_UNNECESSARY. Just let Netfilter do its mangling,
> and then use classic UDP GSO magic at the end of segmentation.
> I also see the idea of explicit comparing and editing of IP and UDP
> headers right in __udp_gso_segment_list() rather unacceptable.

If I understand UDP GRO fraglist correctly, it keeps the length of
each skb of the fraglist. But your approach might change the lengths
by gso_size. What if each skb of the fraglist had different lengths?

For CHECKSUM_UNNECESSARY, GROed head_skb might have an invalid
checksum. But finally, the fraglist will be segmented to queue to
sk_receive_queue with head_skb. We could pass the GROed head_skb with
CHECKSUM_UNNECESSARY.

> 
> Dongseok, Steffen, please test this WIP diff and tell if this one
> works for you, so I could clean up the code and make a patch.
> For me, it works now in any configurations, with and without
> checksum/GSO/fraglist offload.
> 
> diff --git a/net/core/skbuff.c b/net/core/skbuff.c
> index c1a6f262636a..646a42e88e83 100644
> --- a/net/core/skbuff.c
> +++ b/net/core/skbuff.c
> @@ -3674,6 +3674,7 @@ struct sk_buff *skb_segment_list(struct sk_buff *skb,
>  				 unsigned int offset)
>  {
>  	struct sk_buff *list_skb = skb_shinfo(skb)->frag_list;
> +	unsigned int doffset = skb->data - skb_mac_header(skb);
>  	unsigned int tnl_hlen = skb_tnl_header_len(skb);
>  	unsigned int delta_truesize = 0;
>  	unsigned int delta_len = 0;
> @@ -3681,7 +3682,7 @@ struct sk_buff *skb_segment_list(struct sk_buff *skb,
>  	struct sk_buff *nskb, *tmp;
>  	int err;
> 
> -	skb_push(skb, -skb_network_offset(skb) + offset);
> +	skb_push(skb, doffset);
> 
>  	skb_shinfo(skb)->frag_list = NULL;
> 
> @@ -3716,12 +3717,11 @@ struct sk_buff *skb_segment_list(struct sk_buff *skb,
>  		delta_len += nskb->len;
>  		delta_truesize += nskb->truesize;
> 
> -		skb_push(nskb, -skb_network_offset(nskb) + offset);
> +		skb_push(nskb, skb_headroom(nskb) - skb_headroom(skb));
> 
>  		skb_release_head_state(nskb);
> -		 __copy_skb_header(nskb, skb);
> +		__copy_skb_header(nskb, skb);
> 
> -		skb_headers_offset_update(nskb, skb_headroom(nskb) - skb_headroom(skb));
>  		skb_copy_from_linear_data_offset(skb, -tnl_hlen,
>  						 nskb->data - tnl_hlen,
>  						 offset + tnl_hlen);
> diff --git a/net/ipv4/udp_offload.c b/net/ipv4/udp_offload.c
> index ff39e94781bf..61665fcd8c85 100644
> --- a/net/ipv4/udp_offload.c
> +++ b/net/ipv4/udp_offload.c
> @@ -190,13 +190,58 @@ EXPORT_SYMBOL(skb_udp_tunnel_segment);
>  static struct sk_buff *__udp_gso_segment_list(struct sk_buff *skb,
>  					      netdev_features_t features)
>  {
> -	unsigned int mss = skb_shinfo(skb)->gso_size;
> +	struct sk_buff *seg;
> +	struct udphdr *uh;
> +	unsigned int mss;
> +	__be16 newlen;
> +	__sum16 check;
> +
> +	mss = skb_shinfo(skb)->gso_size;
> +	if (skb->len <= sizeof(*uh) + mss)
> +		return ERR_PTR(-EINVAL);
> 
> -	skb = skb_segment_list(skb, features, skb_mac_header_len(skb));
> +	skb_pull(skb, sizeof(*uh));
> +
> +	skb = skb_segment_list(skb, features, skb->data - skb_mac_header(skb));
>  	if (IS_ERR(skb))
>  		return skb;
> 
> -	udp_hdr(skb)->len = htons(sizeof(struct udphdr) + mss);
> +	seg = skb;
> +	uh = udp_hdr(seg);
> +
> +	/* compute checksum adjustment based on old length versus new */
> +	newlen = htons(sizeof(*uh) + mss);
> +	check = csum16_add(csum16_sub(uh->check, uh->len), newlen);
> +
> +	for (;;) {
> +		if (!seg->next)
> +			break;
> +
> +		uh->len = newlen;
> +		uh->check = check;
> +
> +		if (seg->ip_summed == CHECKSUM_PARTIAL)
> +			gso_reset_checksum(seg, ~check);
> +		else
> +			uh->check = gso_make_checksum(seg, ~check) ? :
> +				    CSUM_MANGLED_0;
> +
> +		seg = seg->next;
> +		uh = udp_hdr(seg);
> +	}
> +
> +	/* last packet can be partial gso_size, account for that in checksum */
> +	newlen = htons(skb_tail_pointer(seg) - skb_transport_header(seg) +
> +		       seg->data_len);
> +	check = csum16_add(csum16_sub(uh->check, uh->len), newlen);
> +
> +	uh->len = newlen;
> +	uh->check = check;
> +
> +	if (seg->ip_summed == CHECKSUM_PARTIAL)
> +		gso_reset_checksum(seg, ~check);
> +	else
> +		uh->check = gso_make_checksum(seg, ~check) ? : CSUM_MANGLED_0;
> 
>  	return skb;
>  }
> @@ -602,27 +647,13 @@ INDIRECT_CALLABLE_SCOPE int udp4_gro_complete(struct sk_buff *skb, int nhoff)
>  	const struct iphdr *iph = ip_hdr(skb);
>  	struct udphdr *uh = (struct udphdr *)(skb->data + nhoff);
> 
> -	if (NAPI_GRO_CB(skb)->is_flist) {
> -		uh->len = htons(skb->len - nhoff);
> -
> -		skb_shinfo(skb)->gso_type |= (SKB_GSO_FRAGLIST|SKB_GSO_UDP_L4);
> -		skb_shinfo(skb)->gso_segs = NAPI_GRO_CB(skb)->count;
> -
> -		if (skb->ip_summed == CHECKSUM_UNNECESSARY) {
> -			if (skb->csum_level < SKB_MAX_CSUM_LEVEL)
> -				skb->csum_level++;
> -		} else {
> -			skb->ip_summed = CHECKSUM_UNNECESSARY;
> -			skb->csum_level = 0;
> -		}
> -
> -		return 0;
> -	}
> -
>  	if (uh->check)
>  		uh->check = ~udp_v4_check(skb->len - nhoff, iph->saddr,
>  					  iph->daddr, 0);
> 
> +	if (NAPI_GRO_CB(skb)->is_flist)
> +		skb_shinfo(skb)->gso_type |= SKB_GSO_FRAGLIST;
> +
>  	return udp_gro_complete(skb, nhoff, udp4_lib_lookup_skb);
>  }
> 



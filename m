Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3489A4A8BF1
	for <lists+netdev@lfdr.de>; Thu,  3 Feb 2022 19:53:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353586AbiBCSxN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Feb 2022 13:53:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35210 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233247AbiBCSxL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Feb 2022 13:53:11 -0500
Received: from mail-qt1-x836.google.com (mail-qt1-x836.google.com [IPv6:2607:f8b0:4864:20::836])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2BDB5C061714
        for <netdev@vger.kernel.org>; Thu,  3 Feb 2022 10:53:11 -0800 (PST)
Received: by mail-qt1-x836.google.com with SMTP id y8so3661528qtn.8
        for <netdev@vger.kernel.org>; Thu, 03 Feb 2022 10:53:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:subject:from:to:cc:date:in-reply-to:references
         :user-agent:mime-version:content-transfer-encoding;
        bh=RYjNR35YqJMgyO5nFge5c29LEEhLuuYJQLnEhGRZ4uQ=;
        b=CNLmkuVQLYXqko+jwIbZ46hWMA0TCbPsZgxSQNN7nrBirFd5OLwLK69gq6uZg9E9cY
         7VXRHU5ryDTUpCemeng5ncE9Dl6Q2xOjJw5khC0MT3ZTudLntMBR6ZxHvcfzSwNUk8GW
         BG1xBxN+t2S1tLr+mvreEOqZRZFkCBUvo7dSprZ4YhUBzBXteL8RkVNlWDsqcHhSR8uq
         zEmgmZY6TAjIIWadC4HaXvS4QYhzQFRHrNYi3El3ULTQs96BH/Soeepnu7xrvjlv8//6
         DKd47MrK9BYn9eiFQaPrs1FvmdfVDt6uxxaGLOBS/sa2AtTwzGUDG7E4udirCO/FJ0IC
         j5qQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=RYjNR35YqJMgyO5nFge5c29LEEhLuuYJQLnEhGRZ4uQ=;
        b=J1Y5ITfqQ1CBv+sf+nA6Z+k7nCOvz2MRAzf1wgNgBGat0b372QM8J2OPJnDoUWhX2p
         BFNonwpXashbWkmXM/3acDNyKZtR1ubXXCvSEDKFJsP8FMXZzsCykg13n7MqhtRO+yUt
         N8sv7jW1k6BdS2EpkQoLCWf+OFnZDCDtMWIXAi7Vp8ct29RCdtgg0tcyGkSrr7VDftTu
         Y/rJci6/u+ozSd1P5+YlwTWeLhUZe4PAJA2tXQN0R2QuNQ7HkzacAvICHv5jzXWHx15x
         99WjtLnUtVKMG91NntseeR+t+saGETDiOYB4TyQdkvFtDMPRhGY4wUsKa6HWQEjTRODJ
         48ug==
X-Gm-Message-State: AOAM530g5UlrPW8QyBlpPAIGVgn66oXj0BqTkPyomD5AEwnscJKRLmMr
        7ZMU2ps15d5QJC8zeXYczNj62wU+qnwEqg==
X-Google-Smtp-Source: ABdhPJwA75crJCbvyTmDYwpawFpS5vVLL8ynHg7/dywXStI6XmdBPWVqPQXKoGV5Rhognl3i2tGPRA==
X-Received: by 2002:ac8:5cc9:: with SMTP id s9mr18332263qta.215.1643914390126;
        Thu, 03 Feb 2022 10:53:10 -0800 (PST)
Received: from ?IPv6:2001:470:b:9c3:82ee:73ff:fe41:9a02? ([2001:470:b:9c3:82ee:73ff:fe41:9a02])
        by smtp.googlemail.com with ESMTPSA id 5sm8387540qtp.81.2022.02.03.10.53.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 03 Feb 2022 10:53:09 -0800 (PST)
Message-ID: <0d3cbdeee93fe7b72f3cdfc07fd364244d3f4f47.camel@gmail.com>
Subject: Re: [PATCH net-next 05/15] ipv6/gso: remove temporary HBH/jumbo
 header
From:   Alexander H Duyck <alexander.duyck@gmail.com>
To:     Eric Dumazet <eric.dumazet@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Coco Li <lixiaoyan@google.com>
Date:   Thu, 03 Feb 2022 10:53:07 -0800
In-Reply-To: <20220203015140.3022854-6-eric.dumazet@gmail.com>
References: <20220203015140.3022854-1-eric.dumazet@gmail.com>
         <20220203015140.3022854-6-eric.dumazet@gmail.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.40.4 (3.40.4-2.fc34) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 2022-02-02 at 17:51 -0800, Eric Dumazet wrote:
> From: Eric Dumazet <edumazet@google.com>
> 
> ipv6 tcp and gro stacks will soon be able to build big TCP packets,
> with an added temporary Hop By Hop header.
> 
> If GSO is involved for these large packets, we need to remove
> the temporary HBH header before segmentation happens.
> 
> Signed-off-by: Eric Dumazet <edumazet@google.com>
> ---
>  include/net/ipv6.h | 31 +++++++++++++++++++++++++++++++
>  net/core/skbuff.c  | 21 ++++++++++++++++++++-
>  2 files changed, 51 insertions(+), 1 deletion(-)
> 
> diff --git a/include/net/ipv6.h b/include/net/ipv6.h
> index ea2a4351b654f8bc96503aae2b9adcd478e1f8b2..96e916fb933c3e7d4288e86790fcb2bb1353a261 100644
> --- a/include/net/ipv6.h
> +++ b/include/net/ipv6.h
> @@ -464,6 +464,37 @@ bool ipv6_opt_accepted(const struct sock *sk, const struct sk_buff *skb,
>  struct ipv6_txoptions *ipv6_update_options(struct sock *sk,
>  					   struct ipv6_txoptions *opt);
>  
> +/* This helper is specialized for BIG TCP needs.
> + * It assumes the hop_jumbo_hdr will immediately follow the IPV6 header.
> + * It assumes headers are already in skb->head, thus the sk argument is only read.
> + */
> +static inline bool ipv6_has_hopopt_jumbo(const struct sk_buff *skb)
> +{
> +	struct hop_jumbo_hdr *jhdr;
> +	struct ipv6hdr *nhdr;
> +
> +	if (likely(skb->len <= GRO_MAX_SIZE))
> +		return false;
> +
> +	if (skb->protocol != htons(ETH_P_IPV6))
> +		return false;
> +
> +	if (skb_network_offset(skb) +
> +	    sizeof(struct ipv6hdr) +
> +	    sizeof(struct hop_jumbo_hdr) > skb_headlen(skb))
> +		return false;
> +
> +	nhdr = ipv6_hdr(skb);
> +
> +	if (nhdr->nexthdr != NEXTHDR_HOP)
> +		return false;
> +
> +	jhdr = (struct hop_jumbo_hdr *) (nhdr + 1);
> +	if (jhdr->tlv_type != IPV6_TLV_JUMBO || jhdr->hdrlen != 0)
> +		return false;
> +	return true;

Rather than having to perform all of these checkes would it maybe make
sense to add SKB_GSO_JUMBOGRAM as a gso_type flag? Then it would make
it easier for drivers to indicate if they support the new offload or
not.

An added bonus is that it would probably make it easier to do something
like a GSO_PARTIAL for this since then it would just be a matter of
flagging it, stripping the extra hop-by-hop header, and chopping it
into gso_max_size chunks.

> +}
> +
>  static inline bool ipv6_accept_ra(struct inet6_dev *idev)
>  {
>  	/* If forwarding is enabled, RA are not accepted unless the special
> diff --git a/net/core/skbuff.c b/net/core/skbuff.c
> index 0118f0afaa4fce8da167ddf39de4c9f3880ca05b..53f17c7392311e7123628fcab4617efc169905a1 100644
> --- a/net/core/skbuff.c
> +++ b/net/core/skbuff.c
> @@ -3959,8 +3959,9 @@ struct sk_buff *skb_segment(struct sk_buff *head_skb,
>  	skb_frag_t *frag = skb_shinfo(head_skb)->frags;
>  	unsigned int mss = skb_shinfo(head_skb)->gso_size;
>  	unsigned int doffset = head_skb->data - skb_mac_header(head_skb);
> +	int hophdr_len = sizeof(struct hop_jumbo_hdr);
>  	struct sk_buff *frag_skb = head_skb;
> -	unsigned int offset = doffset;
> +	unsigned int offset;
>  	unsigned int tnl_hlen = skb_tnl_header_len(head_skb);
>  	unsigned int partial_segs = 0;
>  	unsigned int headroom;
> @@ -3968,6 +3969,7 @@ struct sk_buff *skb_segment(struct sk_buff *head_skb,
>  	__be16 proto;
>  	bool csum, sg;
>  	int nfrags = skb_shinfo(head_skb)->nr_frags;
> +	struct ipv6hdr *h6;
>  	int err = -ENOMEM;
>  	int i = 0;
>  	int pos;
> @@ -3992,6 +3994,23 @@ struct sk_buff *skb_segment(struct sk_buff *head_skb,
>  	}
>  
>  	__skb_push(head_skb, doffset);
> +
> +	if (ipv6_has_hopopt_jumbo(head_skb)) {
> +		/* remove the HBH header.
> +		 * Layout: [Ethernet header][IPv6 header][HBH][TCP header]
> +		 */
> +		memmove(head_skb->data + hophdr_len,
> +			head_skb->data,
> +			ETH_HLEN + sizeof(struct ipv6hdr));
> +		head_skb->data += hophdr_len;
> +		head_skb->len -= hophdr_len;
> +		head_skb->network_header += hophdr_len;
> +		head_skb->mac_header += hophdr_len;
> +		doffset -= hophdr_len;
> +		h6 = (struct ipv6hdr *)(head_skb->data + ETH_HLEN);
> +		h6->nexthdr = IPPROTO_TCP;
> +	}

Does it really make the most sense to be doing this here, or should
this be a part of the IPv6 processing? It seems like of asymmetric when
compared with the change in the next patch to add the header in GRO.

> +	offset = doffset;
>  	proto = skb_network_protocol(head_skb, NULL);
>  	if (unlikely(!proto))
>  		return ERR_PTR(-EINVAL);



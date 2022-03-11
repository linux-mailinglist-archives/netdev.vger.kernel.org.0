Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1CBC54D6608
	for <lists+netdev@lfdr.de>; Fri, 11 Mar 2022 17:24:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239826AbiCKQZM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Mar 2022 11:25:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35284 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235817AbiCKQZL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Mar 2022 11:25:11 -0500
Received: from mail-qt1-x832.google.com (mail-qt1-x832.google.com [IPv6:2607:f8b0:4864:20::832])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 52B47FE421
        for <netdev@vger.kernel.org>; Fri, 11 Mar 2022 08:24:08 -0800 (PST)
Received: by mail-qt1-x832.google.com with SMTP id a1so7664832qta.13
        for <netdev@vger.kernel.org>; Fri, 11 Mar 2022 08:24:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:subject:from:to:cc:date:in-reply-to:references
         :user-agent:mime-version:content-transfer-encoding;
        bh=g1zrfPF34sccMpfZ8sn+gd5rKWAjllWRjCJdzeDQk9k=;
        b=Cwo9wN7YPaEq6w4VR6wk5bVSIELZ3IFolzWz+u4jYVtI5w0UuhqkrUjzCczsJ3URBh
         z6dXFfRnqoe4SQHTtY9PeHc3zyXr7C3erfPlHKcn5tlX854hgL4TyT/V4JqIB+XOGdh/
         GTZTmxsO1nFvRMvKjXBVc6+l+gTPDFoNjN77oMIaz+65icr/yCBn8EwoebhVhrNMZ7z6
         TroXdvPtXdMXKBOal+HkHNgp+71iZ1MaPfVphY17Y19/T1V4BFfiK364x6ST6YQUPYBq
         i7BI/Ns3zMwO5X1BgmACLwGfmTsEg5HV3IlXQmVdq312CzkC6ZH/NWJud8GqGel/Sk4o
         F29Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=g1zrfPF34sccMpfZ8sn+gd5rKWAjllWRjCJdzeDQk9k=;
        b=6gLKCUj1Tnv7eTZJr1sdyx0F7TzIQBSOzkvIEU9j1XejO6zJtCbAAJ62N+dBbOmEpb
         0mXn0aueUYMNDhLjB5l9iCMZO5FnlO9zfsWYm+H2+wE8oT+iSu31LUysO3+JIYX98lv4
         LgnKe8Fhb5S2arvyGcQh4aszdViBu3bJPgsQXi3KQYH8rDwpNWs37JaC7T7efRnx4epd
         sPmLnMbWwjwYcpUVzdX2D7ek55zzFsuE6lKUPqgFwuhZVjiWhSW1A+pwyxy1ar53QxKz
         Kg9Y1dpFONMfAVC8ugpJihXop74B+QcR2qDTxjlU3CwURpKZEOF8k5M3c9Ba89HUklp6
         nssg==
X-Gm-Message-State: AOAM530b5tHMPGFb57LZ2QP/HhPVISclbb0K7Gq0iZZTAHRqBeqc9dMU
        mO0IfUhIgQD6T9lhbTi1tkImkQVQRLs=
X-Google-Smtp-Source: ABdhPJy3NV12nD7un/JfbxtR5psMUoFd6sBNO3DdnA2ls2qa08TyJbgbvo/m6VqaKCtDpPq1DKsYLA==
X-Received: by 2002:a05:622a:1aa4:b0:2e1:a97b:e80a with SMTP id s36-20020a05622a1aa400b002e1a97be80amr7926525qtc.642.1647015847305;
        Fri, 11 Mar 2022 08:24:07 -0800 (PST)
Received: from ?IPv6:2001:470:b:9c3:82ee:73ff:fe41:9a02? ([2001:470:b:9c3:82ee:73ff:fe41:9a02])
        by smtp.googlemail.com with ESMTPSA id d4-20020a37c404000000b0067d67adea0fsm1963535qki.84.2022.03.11.08.24.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 11 Mar 2022 08:24:06 -0800 (PST)
Message-ID: <bd7742e5631aee2059aea2d55a7531cc88dfe49b.camel@gmail.com>
Subject: Re: [PATCH v4 net-next 06/14] ipv6/gro: insert temporary HBH/jumbo
 header
From:   Alexander H Duyck <alexander.duyck@gmail.com>
To:     Eric Dumazet <eric.dumazet@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev <netdev@vger.kernel.org>,
        Alexander Duyck <alexanderduyck@fb.com>,
        Coco Li <lixiaoyan@google.com>,
        Eric Dumazet <edumazet@google.com>
Date:   Fri, 11 Mar 2022 08:24:04 -0800
In-Reply-To: <20220310054703.849899-7-eric.dumazet@gmail.com>
References: <20220310054703.849899-1-eric.dumazet@gmail.com>
         <20220310054703.849899-7-eric.dumazet@gmail.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.40.4 (3.40.4-2.fc34) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 2022-03-09 at 21:46 -0800, Eric Dumazet wrote:
> From: Eric Dumazet <edumazet@google.com>
> 
> Following patch will add GRO_IPV6_MAX_SIZE, allowing gro to build
> BIG TCP ipv6 packets (bigger than 64K).
> 

This looks like it belongs in the next patch, not this one. This patch
is adding the HBH header.

> This patch changes ipv6_gro_complete() to insert a HBH/jumbo header
> so that resulting packet can go through IPv6/TCP stacks.
> 
> Signed-off-by: Eric Dumazet <edumazet@google.com>
> ---
>  net/ipv6/ip6_offload.c | 32 ++++++++++++++++++++++++++++++--
>  1 file changed, 30 insertions(+), 2 deletions(-)
> 
> diff --git a/net/ipv6/ip6_offload.c b/net/ipv6/ip6_offload.c
> index a6a6c1539c28d242ef8c35fcd5ce900512ce912d..d12dba2dd5354dbb79bb80df4038dec2544cddeb 100644
> --- a/net/ipv6/ip6_offload.c
> +++ b/net/ipv6/ip6_offload.c
> @@ -342,15 +342,43 @@ static struct sk_buff *ip4ip6_gro_receive(struct list_head *head,
>  INDIRECT_CALLABLE_SCOPE int ipv6_gro_complete(struct sk_buff *skb, int nhoff)
>  {
>  	const struct net_offload *ops;
> -	struct ipv6hdr *iph = (struct ipv6hdr *)(skb->data + nhoff);
> +	struct ipv6hdr *iph;
>  	int err = -ENOSYS;
> +	u32 payload_len;
>  
>  	if (skb->encapsulation) {
>  		skb_set_inner_protocol(skb, cpu_to_be16(ETH_P_IPV6));
>  		skb_set_inner_network_header(skb, nhoff);
>  	}
>  
> -	iph->payload_len = htons(skb->len - nhoff - sizeof(*iph));
> +	payload_len = skb->len - nhoff - sizeof(*iph);
> +	if (unlikely(payload_len > IPV6_MAXPLEN)) {
> +		struct hop_jumbo_hdr *hop_jumbo;
> +		int hoplen = sizeof(*hop_jumbo);
> +
> +		/* Move network header left */
> +		memmove(skb_mac_header(skb) - hoplen, skb_mac_header(skb),
> +			skb->transport_header - skb->mac_header);
> +		skb->data -= hoplen;
> +		skb->len += hoplen;
> +		skb->mac_header -= hoplen;
> +		skb->network_header -= hoplen;
> +		iph = (struct ipv6hdr *)(skb->data + nhoff);
> +		hop_jumbo = (struct hop_jumbo_hdr *)(iph + 1);
> +
> +		/* Build hop-by-hop options */
> +		hop_jumbo->nexthdr = iph->nexthdr;
> +		hop_jumbo->hdrlen = 0;
> +		hop_jumbo->tlv_type = IPV6_TLV_JUMBO;
> +		hop_jumbo->tlv_len = 4;
> +		hop_jumbo->jumbo_payload_len = htonl(payload_len + hoplen);
> +
> +		iph->nexthdr = NEXTHDR_HOP;
> +		iph->payload_len = 0;
> +	} else {
> +		iph = (struct ipv6hdr *)(skb->data + nhoff);
> +		iph->payload_len = htons(payload_len);
> +	}
>  
>  	nhoff += sizeof(*iph) + ipv6_exthdrs_len(iph, &ops);
>  	if (WARN_ON(!ops || !ops->callbacks.gro_complete))



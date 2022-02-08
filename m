Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 442154AD10D
	for <lists+netdev@lfdr.de>; Tue,  8 Feb 2022 06:34:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347466AbiBHFdU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Feb 2022 00:33:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55806 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347022AbiBHEr3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Feb 2022 23:47:29 -0500
Received: from mail-pl1-x634.google.com (mail-pl1-x634.google.com [IPv6:2607:f8b0:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 25B97C0401DC;
        Mon,  7 Feb 2022 20:47:29 -0800 (PST)
Received: by mail-pl1-x634.google.com with SMTP id z17so2877600plb.9;
        Mon, 07 Feb 2022 20:47:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=s9UxDPunzThEazgxjnJNZiUd1Sn9ezdvm0HY1dXaGJg=;
        b=Te3Xw/Laa+58xrEhBZUXblnfIvrZq9PP8a6n5sNT1r0iPSz+2Na6f2d5T2NUcheHur
         wyf5hlNNhcvKvnDizW7lxWngdzj694vMyBWGnp/5mMbMRGgH9zGHJdP2nNstbjva7F8k
         dzVUBln38s40UMwfHyKEoYtJ0Vd/rH4nnL5g4RVgt12LaXO/2mlfFDu68l22A0W8Ixq8
         SgNrdz/IDmjBomR1NX6ANb9YdSf/04AeEsZB4Y3mdNqm9u7fmpl9dg4M6Jltii8fVAPg
         CxLifKxzN5q/HqvKCapgVcB++kTtjBdgZHtbCFXcPmqlBiCaQ8ugkdEH+F5N0sLZUen+
         rh1A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=s9UxDPunzThEazgxjnJNZiUd1Sn9ezdvm0HY1dXaGJg=;
        b=h/V1pGdBFe83MpPoIODLNHVM6YLstnYtbot16NO9JCKgDhK+s/9qAnbWJKQ/r2Vd0L
         XYJ/zF/TgffDlNJS75VbKJymkbXeWeh0jdfiwyfmBf2U0Goey8f2EdeC6oMgfj+ybAd9
         84oY6BIa3ts3KDhJrMlGZ5gRmNuRStaGWXBQKohEZE1970TPq0Iss9XauQt8MnAQDdBN
         pHEuAXsU0s+56Fq+HgGWIp8uD9briHiuJo4DrDtxIZWwT228n41xvUDuNtjLQt8Qevoz
         DZtzFLTEL83spoMvg+fhegP3F0FEbijVvdBVvzVImqzIaKJlOYgcP25ew9JyKXpBza2v
         QsUg==
X-Gm-Message-State: AOAM531cOHWFP8TW5sBjwSitb9L0bEKJM337uHFWKaXzaeIwLtPgXp0R
        g3of9TyyEVqn0rD0qAv0fYU=
X-Google-Smtp-Source: ABdhPJxnXhfyyETbRVA04ZajBGzAY+x7vfTavhEVgoEcU/GG44I7F3oBilXC8UCBgiX6TVChnT+F/Q==
X-Received: by 2002:a17:90b:17c4:: with SMTP id me4mr2495286pjb.198.1644295648655;
        Mon, 07 Feb 2022 20:47:28 -0800 (PST)
Received: from [10.0.2.64] ([209.37.97.194])
        by smtp.googlemail.com with ESMTPSA id j3sm10105037pgs.0.2022.02.07.20.47.27
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 07 Feb 2022 20:47:28 -0800 (PST)
Message-ID: <53282d15-1e73-9aef-6384-3f76812480e6@gmail.com>
Date:   Mon, 7 Feb 2022 20:47:26 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.5.1
Subject: Re: [PATCH 1/2] net: tap: track dropped skb via kfree_skb_reason()
Content-Language: en-US
To:     Dongli Zhang <dongli.zhang@oracle.com>, netdev@vger.kernel.org,
        Eric Dumazet <edumazet@google.com>
Cc:     linux-kernel@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        rostedt@goodmis.org, mingo@redhat.com, ast@kernel.org,
        daniel@iogearbox.net, andrii@kernel.org, imagedong@tencent.com,
        joao.m.martins@oracle.com, joe.jin@oracle.com
References: <20220208035510.1200-1-dongli.zhang@oracle.com>
 <20220208035510.1200-2-dongli.zhang@oracle.com>
From:   David Ahern <dsahern@gmail.com>
In-Reply-To: <20220208035510.1200-2-dongli.zhang@oracle.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2/7/22 7:55 PM, Dongli Zhang wrote:
> diff --git a/drivers/net/tap.c b/drivers/net/tap.c
> index 8e3a28ba6b28..232572289e63 100644
> --- a/drivers/net/tap.c
> +++ b/drivers/net/tap.c
> @@ -322,6 +322,7 @@ rx_handler_result_t tap_handle_frame(struct sk_buff **pskb)
>  	struct tap_dev *tap;
>  	struct tap_queue *q;
>  	netdev_features_t features = TAP_FEATURES;
> +	int drop_reason = SKB_DROP_REASON_NOT_SPECIFIED;

maybe I missed an exit path, but I believe drop_reason is always set
before a goto jump, so this init is not needed.

>  
>  	tap = tap_dev_get_rcu(dev);
>  	if (!tap)
> @@ -343,12 +344,16 @@ rx_handler_result_t tap_handle_frame(struct sk_buff **pskb)
>  		struct sk_buff *segs = __skb_gso_segment(skb, features, false);
>  		struct sk_buff *next;
>  
> -		if (IS_ERR(segs))
> +		if (IS_ERR(segs)) {
> +			drop_reason = SKB_DROP_REASON_SKB_GSO_SEGMENT;

This reason points to a line of code, not the real reason for the drop.
If you unwind __skb_gso_segment the only failure there is ENOMEM. The
reason code needs to be meaningful to users, not just code references.


>  			goto drop;
> +		}
>  
>  		if (!segs) {
> -			if (ptr_ring_produce(&q->ring, skb))
> +			if (ptr_ring_produce(&q->ring, skb)) {
> +				drop_reason = SKB_DROP_REASON_PTR_FULL;

similar comment to Eric - PTR_FULL needs to be more helpful.

>  				goto drop;
> +			}
>  			goto wake_up;
>  		}
>  
> @@ -369,10 +374,14 @@ rx_handler_result_t tap_handle_frame(struct sk_buff **pskb)
>  		 */
>  		if (skb->ip_summed == CHECKSUM_PARTIAL &&
>  		    !(features & NETIF_F_CSUM_MASK) &&
> -		    skb_checksum_help(skb))
> +		    skb_checksum_help(skb)) {
> +			drop_reason = SKB_DROP_REASON_SKB_CHECKSUM;

That is not helpful explanation of the root cause; it is more of a code
reference.


>  			goto drop;
> -		if (ptr_ring_produce(&q->ring, skb))
> +		}
> +		if (ptr_ring_produce(&q->ring, skb)) {
> +			drop_reason = SKB_DROP_REASON_PTR_FULL;

ditto above comment

>  			goto drop;
> +		}
>  	}
>  
>  wake_up:
> @@ -383,7 +392,7 @@ rx_handler_result_t tap_handle_frame(struct sk_buff **pskb)
>  	/* Count errors/drops only here, thus don't care about args. */
>  	if (tap->count_rx_dropped)
>  		tap->count_rx_dropped(tap);
> -	kfree_skb(skb);
> +	kfree_skb_reason(skb, drop_reason);
>  	return RX_HANDLER_CONSUMED;
>  }
>  EXPORT_SYMBOL_GPL(tap_handle_frame);
> @@ -632,6 +641,7 @@ static ssize_t tap_get_user(struct tap_queue *q, void *msg_control,
>  	int depth;
>  	bool zerocopy = false;
>  	size_t linear;
> +	int drop_reason = SKB_DROP_REASON_NOT_SPECIFIED;
>  
>  	if (q->flags & IFF_VNET_HDR) {
>  		vnet_hdr_len = READ_ONCE(q->vnet_hdr_sz);
> @@ -696,8 +706,10 @@ static ssize_t tap_get_user(struct tap_queue *q, void *msg_control,
>  	else
>  		err = skb_copy_datagram_from_iter(skb, 0, from, len);
>  
> -	if (err)
> +	if (err) {
> +		drop_reason = SKB_DROP_REASON_SKB_COPY_DATA;

As mentioned above, plus unwind the above functions and give a more
explicit description of why the above fails.

>  		goto err_kfree;
> +	}
>  
>  	skb_set_network_header(skb, ETH_HLEN);
>  	skb_reset_mac_header(skb);
> @@ -706,8 +718,10 @@ static ssize_t tap_get_user(struct tap_queue *q, void *msg_control,
>  	if (vnet_hdr_len) {
>  		err = virtio_net_hdr_to_skb(skb, &vnet_hdr,
>  					    tap_is_little_endian(q));
> -		if (err)
> +		if (err) {
> +			drop_reason = SKB_DROP_REASON_VIRTNET_HDR;

and here too.

Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 98E165F4E01
	for <lists+netdev@lfdr.de>; Wed,  5 Oct 2022 05:03:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229508AbiJEDDz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Oct 2022 23:03:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60608 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229548AbiJEDDx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 4 Oct 2022 23:03:53 -0400
Received: from mail-pj1-x1029.google.com (mail-pj1-x1029.google.com [IPv6:2607:f8b0:4864:20::1029])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 192B95D0ED
        for <netdev@vger.kernel.org>; Tue,  4 Oct 2022 20:03:50 -0700 (PDT)
Received: by mail-pj1-x1029.google.com with SMTP id gf8so11945329pjb.5
        for <netdev@vger.kernel.org>; Tue, 04 Oct 2022 20:03:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date;
        bh=aP95bKWiKwfkowGhCeZHvZSzzx4vDFEtGUhbJZ58BVs=;
        b=iHuEAr1jQRkJk7UMid9KXukN+CUzKUUuqCSfNOTGl1fTgkJ8erSEr2uEnoyxG+LAnW
         FVLcMAO+3HddaLBf6O7yCrhYfos2jIydv79VyLd7JgXqic5cACZDBcJPm0+eXfHKpmYe
         86IQGd2pHKUG6MAQttJLLkxkIwZU2GeyIWGrA=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date;
        bh=aP95bKWiKwfkowGhCeZHvZSzzx4vDFEtGUhbJZ58BVs=;
        b=z1uwtX36feUOnSlamNhpYZCqk0g5i2bZ39zcO70jX6v0xOhhF+4x8dyEr4dKU5fOFa
         MmMIBx5crTnBpSicyBm+EtuyFxDSxribNWGtQ3g6ZSlh6KZy905A8Tg1lHS0op4U4FCc
         BGoPowgNa/9sTHKf7S9RnxXOUCvTXn9/lsRYmjqla2O0q2Uac01WJYq1DrGJKsgDttVk
         XvCEM9V30KsmRTBnCvBkOzcFeu1jeXE69RkWs2xFFOcZlo4KBa5lDq3pu+MY0vFGHIEV
         G6TtE2g++jlBVnSHbs7S4XuAfSQofPJqza9ubXsmLbt4u1lPL1D1idN/12OzsgY3EwaU
         2uNA==
X-Gm-Message-State: ACrzQf2d1fXHW7PYsZJj5zIul76VBuTwgMb4zqfzCZFf7RSva6aUzZL7
        k2pUhZJup+X3bgntNxzLt/8NEg==
X-Google-Smtp-Source: AMsMyM5/tFBSnDzNkaDJGlsm3jS0p7ylLnjrrbXy9Y0O5uixYzXyy7DK60ryooTo24o26tNnFPbbXA==
X-Received: by 2002:a17:903:22c2:b0:178:3c7c:18af with SMTP id y2-20020a17090322c200b001783c7c18afmr29975895plg.134.1664939030387;
        Tue, 04 Oct 2022 20:03:50 -0700 (PDT)
Received: from www.outflux.net (smtp.outflux.net. [198.145.64.163])
        by smtp.gmail.com with ESMTPSA id d5-20020a170902654500b0017c7fe4718asm9095256pln.213.2022.10.04.20.03.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 04 Oct 2022 20:03:49 -0700 (PDT)
Date:   Tue, 4 Oct 2022 20:03:37 -0700
From:   Kees Cook <keescook@chromium.org>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, linux-hardening@vger.kernel.org
Subject: Re: [RFC] netlink: split up copies in the ack construction
Message-ID: <202210041959.3654E4C@keescook>
References: <202210041600.7C90DF917@keescook>
 <20221005002814.2233715-1-kuba@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221005002814.2233715-1-kuba@kernel.org>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Oct 04, 2022 at 05:28:14PM -0700, Jakub Kicinski wrote:
> Signed-off-by: Jakub Kicinski <kuba@kernel.org>
> ---
>  include/net/netlink.h        | 21 +++++++++++++++++++++
>  include/uapi/linux/netlink.h |  2 ++
>  net/netlink/af_netlink.c     | 30 +++++++++++++++++++++---------
>  3 files changed, 44 insertions(+), 9 deletions(-)
> 
> diff --git a/include/net/netlink.h b/include/net/netlink.h
> index 4418b1981e31..46c40fabd2b5 100644
> --- a/include/net/netlink.h
> +++ b/include/net/netlink.h
> @@ -931,6 +931,27 @@ static inline struct nlmsghdr *nlmsg_put(struct sk_buff *skb, u32 portid, u32 se
>  	return __nlmsg_put(skb, portid, seq, type, payload, flags);
>  }
>  
> +/**
> + * nlmsg_append - Add more data to a nlmsg in a skb
> + * @skb: socket buffer to store message in
> + * @payload: length of message payload
> + *
> + * Append data to an existing nlmsg, used when constructing a message
> + * with multiple fixed-format headers (which is rare).
> + * Returns NULL if the tailroom of the skb is insufficient to store
> + * the extra payload.
> + */
> +static inline void *nlmsg_append(struct sk_buff *skb, u32 size)
> +{
> +	if (unlikely(skb_tailroom(skb) < NLMSG_ALIGN(size)))
> +		return NULL;
> +
> +	if (NLMSG_ALIGN(size) - size)
> +		memset(skb_tail_pointer(skb) + size, 0,
> +		       NLMSG_ALIGN(size) - size);
> +	return __skb_put(skb, NLMSG_ALIGN(size));
> +}
> +
>  /**
>   * nlmsg_put_answer - Add a new callback based netlink message to an skb
>   * @skb: socket buffer to store message in
> diff --git a/include/uapi/linux/netlink.h b/include/uapi/linux/netlink.h
> index e2ae82e3f9f7..fba3ca8152fa 100644
> --- a/include/uapi/linux/netlink.h
> +++ b/include/uapi/linux/netlink.h
> @@ -48,6 +48,7 @@ struct sockaddr_nl {
>   * @nlmsg_flags: Additional flags
>   * @nlmsg_seq:   Sequence number
>   * @nlmsg_pid:   Sending process port ID
> + * @nlmsg_data:  Message payload
>   */
>  struct nlmsghdr {
>  	__u32		nlmsg_len;
> @@ -55,6 +56,7 @@ struct nlmsghdr {
>  	__u16		nlmsg_flags;
>  	__u32		nlmsg_seq;
>  	__u32		nlmsg_pid;
> +	__DECLARE_FLEX_ARRAY(char, nlmsg_data);

Since the flex array isn't part of a union, it can just be declared
"normally":

	__u8		nlmsg_data[];

I'd also suggest u8 (rather than signed char) because compilers hate us,
and I've been burned too many times by having char arrays do stupid
things with the signed bit.

>  };
>  
>  /* Flags values */
> diff --git a/net/netlink/af_netlink.c b/net/netlink/af_netlink.c
> index a662e8a5ff84..f8c94454b916 100644
> --- a/net/netlink/af_netlink.c
> +++ b/net/netlink/af_netlink.c
> @@ -2488,19 +2488,25 @@ void netlink_ack(struct sk_buff *in_skb, struct nlmsghdr *nlh, int err,
>  		flags |= NLM_F_ACK_TLVS;
>  
>  	skb = nlmsg_new(payload + tlvlen, GFP_KERNEL);
> -	if (!skb) {
> -		NETLINK_CB(in_skb).sk->sk_err = ENOBUFS;
> -		sk_error_report(NETLINK_CB(in_skb).sk);
> -		return;
> -	}
> +	if (!skb)
> +		goto err_bad_put;
>  
>  	rep = nlmsg_put(skb, NETLINK_CB(in_skb).portid, nlh->nlmsg_seq,
> -			NLMSG_ERROR, payload, flags);
> +			NLMSG_ERROR, sizeof(*errmsg), flags);
> +	if (!rep)
> +		goto err_bad_put;
>  	errmsg = nlmsg_data(rep);
>  	errmsg->error = err;
> -	unsafe_memcpy(&errmsg->msg, nlh, payload > sizeof(*errmsg)
> -					 ? nlh->nlmsg_len : sizeof(*nlh),
> -		      /* Bounds checked by the skb layer. */);
> +	errmsg->msg = *nlh;
> +
> +	if (!(flags & NLM_F_CAPPED)) {
> +		if (!nlmsg_append(skb, nlmsg_len(nlh)))
> +			goto err_bad_put;
> +
> +		/* the nlh + 1 is probably going to make you unhappy? */
> +		memcpy(errmsg->msg.nlmsg_data, nlh->nlmsg_data,
> +		       nlmsg_len(nlh));
> +	}
>  
>  	if (tlvlen)
>  		netlink_ack_tlv_fill(in_skb, skb, nlh, err, extack);
> @@ -2508,6 +2514,12 @@ void netlink_ack(struct sk_buff *in_skb, struct nlmsghdr *nlh, int err,
>  	nlmsg_end(skb, rep);
>  
>  	nlmsg_unicast(in_skb->sk, skb, NETLINK_CB(in_skb).portid);
> +
> +	return;
> +
> +err_bad_put:
> +	NETLINK_CB(in_skb).sk->sk_err = ENOBUFS;
> +	sk_error_report(NETLINK_CB(in_skb).sk);
>  }
>  EXPORT_SYMBOL(netlink_ack);

The rest looks great! :) I suspect you'll want to do close to the same
conversion in net/netfilter/ipset/ip_set_core.c in call_ad() too.

-- 
Kees Cook

Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8FBFF5F4CA9
	for <lists+netdev@lfdr.de>; Wed,  5 Oct 2022 01:40:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230166AbiJDXkk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Oct 2022 19:40:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47864 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230152AbiJDXkh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 4 Oct 2022 19:40:37 -0400
Received: from mail-pf1-x434.google.com (mail-pf1-x434.google.com [IPv6:2607:f8b0:4864:20::434])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 726BF22502
        for <netdev@vger.kernel.org>; Tue,  4 Oct 2022 16:40:35 -0700 (PDT)
Received: by mail-pf1-x434.google.com with SMTP id w191so5003130pfc.5
        for <netdev@vger.kernel.org>; Tue, 04 Oct 2022 16:40:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date;
        bh=17uTSVuuH+QTHxsm/5IIJEGw/N/AJ/QfjhcHMhmV5Bw=;
        b=KCCGkjg/lm1I/zU2VnaKZvjj97yaGn5OBj3n66fMdLxVmMrJJ6Yocazsuba3bdyfQ9
         L1wO4a/xf44XhTcz367hEFaLh8U8uedvXglZuxKzbA4o9S/6QSlKbHzBKtBFpZLMJgbC
         693tqs58REMqBOuxhP6VZHOVjEYnO+785/y2k=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date;
        bh=17uTSVuuH+QTHxsm/5IIJEGw/N/AJ/QfjhcHMhmV5Bw=;
        b=d8x9s1c4RQKMr4N5NRG4b9XD86W0nXYQ0Snuy09y6o8F5WS89pmRIsM4pnctwzRcAT
         MW414TZvRjlZh1Ic7Hegrz3CCW9jvbOv/rINcMM33G2K2j0SI1U9V5QP52ixDA2V/g5s
         g0B6rcOgHfuLaxmRru2+ppZ2yWIGqyU1WK5bXsXK/swW1Jz/wzBcGLClfWudC45LJUCp
         WEH9sesBuuritdhDx4Gh1kVpTTMyQ4Mi5r3Hchhu6B0zbyV89JcNzqD6D8rd/ijyicZ1
         lC3brKzPkUARQe+lTzxlr6fr1Az04KOYTYnUVJ96ZIG9Ph9wSyBX/SphHinsCG4sYwMW
         aMyA==
X-Gm-Message-State: ACrzQf2rMMj86GuSe9jN352KvCGDgCRem1bSEZAdhMI/amRJUQZLLHeL
        Y9mojzphu5EpGb96eAOm3zPF5w==
X-Google-Smtp-Source: AMsMyM7WAfq/aH0wDvhMGQSNUe7IyTA2uq5JB0ACPuIMSUMupOqWdtqYLvvHAnFap3beGzRu6PbVkg==
X-Received: by 2002:a63:e04e:0:b0:44b:97e8:101f with SMTP id n14-20020a63e04e000000b0044b97e8101fmr13556229pgj.330.1664926834682;
        Tue, 04 Oct 2022 16:40:34 -0700 (PDT)
Received: from www.outflux.net (smtp.outflux.net. [198.145.64.163])
        by smtp.gmail.com with ESMTPSA id s82-20020a632c55000000b0043be31d490dsm8809977pgs.67.2022.10.04.16.40.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 04 Oct 2022 16:40:33 -0700 (PDT)
Date:   Tue, 4 Oct 2022 16:40:32 -0700
From:   Kees Cook <keescook@chromium.org>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Dmitry Vyukov <dvyukov@google.com>,
        syzbot <syzbot+3a080099974c271cd7e9@syzkaller.appspotmail.com>,
        bpf@vger.kernel.org, davem@davemloft.net, edumazet@google.com,
        fw@strlen.de, harshit.m.mogalapalli@oracle.com,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        pabeni@redhat.com, syzkaller-bugs@googlegroups.com,
        linux-hardening@vger.kernel.org
Subject: Re: [syzbot] upstream boot error: WARNING in netlink_ack
Message-ID: <202210041600.7C90DF917@keescook>
References: <000000000000a793cc05ea313b87@google.com>
 <CACT4Y+a8b-knajrXWs8OnF1ijCansRxEicU=YJz6PRk-JuSKvg@mail.gmail.com>
 <F58E0701-8F53-46FE-8324-4DEA7A806C20@chromium.org>
 <20221004104253.29c1f3c7@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221004104253.29c1f3c7@kernel.org>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Oct 04, 2022 at 10:42:53AM -0700, Jakub Kicinski wrote:
> On Tue, 04 Oct 2022 07:36:55 -0700 Kees Cook wrote:
> > This is fixed in the pending netdev tree coming for the merge window.
> 
> This has been weighing on my conscience a little, I don't like how we
> still depend on putting one length in the skb and then using a
> different one for the actual memcpy(). How would you feel about this
> patch on top (untested):

tl;dr: yes, I like it. Please add a nlmsg_contents member. :)

Rambling below...

> 
> diff --git a/include/net/netlink.h b/include/net/netlink.h
> index 4418b1981e31..6ad671441dff 100644
> --- a/include/net/netlink.h
> +++ b/include/net/netlink.h
> @@ -931,6 +931,29 @@ static inline struct nlmsghdr *nlmsg_put(struct sk_buff *skb, u32 portid, u32 se
>  	return __nlmsg_put(skb, portid, seq, type, payload, flags);
>  }
>  
> +/**
> + * nlmsg_append - Add more data to a nlmsg in a skb
> + * @skb: socket buffer to store message in
> + * @nlh: message header
> + * @payload: length of message payload
> + *
> + * Append data to an existing nlmsg, used when constructing a message
> + * with multiple fixed-format headers (which is rare).
> + * Returns NULL if the tailroom of the skb is insufficient to store
> + * the extra payload.
> + */
> +static inline void *nlmsg_append(struct sk_buff *skb, struct nlmsghdr *nlh,

nlh not needed here?

> +				 u32 size)
> +{
> +	if (unlikely(skb_tailroom(skb) < NLMSG_ALIGN(size)))
> +		return NULL;
> +
> +	if (!__builtin_constant_p(size) || NLMSG_ALIGN(size) - size != 0)

why does a fixed size mean no memset?

> +		memset(skb_tail_pointer(skb) + size, 0,
> +		       NLMSG_ALIGN(size) - size);
> +	return __skb_put(NLMSG_ALIGN(size));
> +}
> +
>  /**
>   * nlmsg_put_answer - Add a new callback based netlink message to an skb
>   * @skb: socket buffer to store message in
> diff --git a/net/netlink/af_netlink.c b/net/netlink/af_netlink.c
> index a662e8a5ff84..bb3d855d1f57 100644
> --- a/net/netlink/af_netlink.c
> +++ b/net/netlink/af_netlink.c
> @@ -2488,19 +2488,28 @@ void netlink_ack(struct sk_buff *in_skb, struct nlmsghdr *nlh, int err,
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
> +	memcpy(&errmsg->msg, nlh, sizeof(*nlh));
> +
> +	if (!(flags & NLM_F_CAPPED)) {

Should it test this flag, or test if the sizes show the need for "extra"
payload length?

I always found the progression of sizes here to be confusing. "payload"
starts as sizeof(*errmsg), and gets nlmsg_len(nlh) added but only when if
"(err && !(nlk->flags & NETLINK_F_CAP_ACK)" was true. Why is
nlmsg_len(nlh) _wrong_ if the rest of its contents are correct? If this
was "0" in the other state, the logic would just be:

	nlh_bytes = nlmsg_len(nlh);
	total  = sizeof(*errmsg);
	total += nlh_bytes;
	total += tlvlen;

and:

	nlmsg_new(total, ...);
	... nlmsg_put(..., sizeof(*errmsg), ...);
	...
	errmsg->error = err;
	errmsg->nlh = *nlh;
	if (nlh_bytes) {
		data = nlmsg_append(..., nlh_bytes), ...);
		...
		memcpy(data, nlh->nlmsg_contents, nlh_bytes);
	}

> +		size_t data_len = nlh->nlmsg_len - sizeof(*nlh);

I think data_len here is also "payload - sizeof(*errmsg)"? So if it's >0,
we need to append the nlh contents.

> +		void *data;
> +
> +		data = nlmsg_append(skb, rep, data_len);
> +		if (!data)
> +			goto err_bad_put;
> +
> +		/* the nlh + 1 is probably going to make you unhappy? */

Right, the compiler may think it is an object no larger than sizeof(*nlh).
My earliest attempt at changes here introduced a flex-array for the
contents, and split the memcpy:
https://lore.kernel.org/lkml/d7251d92-150b-5346-6237-52afc154bb00@rasmusvillemoes.dk/
which is basically the solution you have here, except it wasn't having
the nlmsg_*-helpers do the bounds checking.

> +		memcpy(data, nlh + 1, data_len);

So with the struct nlmsghdr::nlmsg_contents member, this becomes:

		memcpy(data, nlh->nlmsg_contents, data_len);

-- 
Kees Cook

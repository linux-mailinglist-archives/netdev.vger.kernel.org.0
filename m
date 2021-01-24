Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 54BF6301CA9
	for <lists+netdev@lfdr.de>; Sun, 24 Jan 2021 15:22:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725968AbhAXOWG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 24 Jan 2021 09:22:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45800 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725769AbhAXOWF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 24 Jan 2021 09:22:05 -0500
Received: from mail-lf1-x12b.google.com (mail-lf1-x12b.google.com [IPv6:2a00:1450:4864:20::12b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 767BFC061573
        for <netdev@vger.kernel.org>; Sun, 24 Jan 2021 06:21:24 -0800 (PST)
Received: by mail-lf1-x12b.google.com with SMTP id u25so14109843lfc.2
        for <netdev@vger.kernel.org>; Sun, 24 Jan 2021 06:21:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=norrbonn-se.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=Jvdg1k/IyV57ONpqS+CYw5ha+l9eiHB+LmUQ9PhDmAY=;
        b=bqvwd/qNTEDPCgyRoDMPR5wa0lT6tB2YmNmSrmaBjEKtm+dIinC6ShuMLl7Uax3KNt
         CJObazq5slF4FDt/9+zeQCs0eEMN5fx74X33lUF41jhLm7w6Dn9KmEeYQAX7m+vLjGSx
         +rUqhmHJQNWZqXjh8c0AKznxgZGlGBLOgTsFrFnWtgG4aWoAPg3LUx4kaNjjdsbqND5x
         XLEeRXmajpWf+eHziE3XS5cHqbJVZmVlVLCOo73ffl+kpaE04KLIeAalVtpebUOFYKKR
         hkOGrHmgOu4x4MROuskJtYcLFuB5CrILXGrLUqVKvnsEl1Th/teDGKMWGZzBYcDkPPxj
         doAQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=Jvdg1k/IyV57ONpqS+CYw5ha+l9eiHB+LmUQ9PhDmAY=;
        b=DExRNTK6+8XN40bfnYipnsrKw1fROPmeUMH3MoXn1zKFeAKO9IYPDvLBxKCdJXdclI
         FK5LgbbQWdPLnQQ4se6mHPMEa5kQWwgxXt+/F/AyERPI+Sdka2fEXmOoJK2NOszUjsxQ
         +lqjpvc2QlZpljZWALB2pBWlD3BiC/INBNF82/tXReeCxiZXNtGfEBWCCM8A2p6fMfjP
         bkmWJYz1k8qcxH+hpTJgMEA5aqMfIEXnBh9oYu7jCyYY2C83iB0Ae24gj5MLVlZ4W9cP
         2OfIBzcPvU++sBe2TB4xw/uzRcL+XjpwRPndIvtt8C72GghstIibl3210wIV2OwobpqC
         lphg==
X-Gm-Message-State: AOAM533dkSMEbea7BkhGlaVYMPln5wd3uyMyquyWP9Jb8pu7B6etTWMz
        CtwjItz998A2tvapMd0xI2VUlshDxjeGow==
X-Google-Smtp-Source: ABdhPJy6ljXyBeNgHJAbqmSzOST7fFbO92YponXq4oN8BRGw+D976uJMDnr/RqzhaVSNZ4MZFNIKpg==
X-Received: by 2002:a19:7013:: with SMTP id h19mr62596lfc.173.1611498082963;
        Sun, 24 Jan 2021 06:21:22 -0800 (PST)
Received: from [192.168.1.157] (h-137-65.A159.priv.bahnhof.se. [81.170.137.65])
        by smtp.gmail.com with ESMTPSA id w13sm1640045ljw.115.2021.01.24.06.21.22
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 24 Jan 2021 06:21:22 -0800 (PST)
Subject: Re: [RFC PATCH 15/16] gtp: add ability to send GTP controls headers
To:     laforge@gnumonks.org, netdev@vger.kernel.org, pbshelar@fb.com,
        kuba@kernel.org
Cc:     pablo@netfilter.org
References: <20210123195916.2765481-1-jonas@norrbonn.se>
 <20210123195916.2765481-16-jonas@norrbonn.se>
From:   Jonas Bonn <jonas@norrbonn.se>
Message-ID: <bf6de363-8e32-aca0-1803-a041c0f55650@norrbonn.se>
Date:   Sun, 24 Jan 2021 15:21:21 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.5.0
MIME-Version: 1.0
In-Reply-To: <20210123195916.2765481-16-jonas@norrbonn.se>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Pravin,

So, this whole GTP metadata thing has me a bit confused.

You've defined a metadata structure like this:

struct gtpu_metadata {
         __u8    ver;
         __u8    flags;
         __u8    type;
};

Here ver is the version of the metadata structure itself, which is fine.
'flags' corresponds to the 3 flag bits of GTP header's first byte:  E, 
S, and PN.
'type' corresponds to the 'message type' field of the GTP header.

The 'control header' (strange name) example below allows the flags to be 
set; however, setting these flags alone is insufficient because each one 
indicates the presence of additional fields in the header and there's 
nothing in the code to account for that.

If E is set, extension headers would need to be added.
If S is set, a sequence number field would need to be added.
If PN is set, a PDU-number header would need to be added.

It's not clear to me who sets up this metadata in the first place.  Is 
that where OVS or eBPF come in?  Can you give some pointers to how this 
works?

Couple of comments below....

On 23/01/2021 20:59, Jonas Bonn wrote:
> From: Pravin B Shelar <pbshelar@fb.com>
> 
> Please explain how this patch actually works... creation of the control
> header makes sense, but I don't understand how sending of a
> control header is actually triggered.
> 
> Signed-off-by: Jonas Bonn <jonas@norrbonn.se>
> ---
>   drivers/net/gtp.c | 43 ++++++++++++++++++++++++++++++++++++++++++-
>   1 file changed, 42 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/net/gtp.c b/drivers/net/gtp.c
> index 668ed8a4836e..bbce2671de2d 100644
> --- a/drivers/net/gtp.c
> +++ b/drivers/net/gtp.c
> @@ -683,6 +683,38 @@ static void gtp_push_header(struct sk_buff *skb, struct pdp_ctx *pctx,
>   	}
>   }
>   
> +static inline int gtp1_push_control_header(struct sk_buff *skb,

I'm not enamored with the name 'control header' because it makes sound 
like this is some GTP-C thing.  The GTP module is really only about 
GTP-U and the function itself just sets up a GTP-U header.


> +					   struct pdp_ctx *pctx,
> +					   struct gtpu_metadata *opts,
> +					   struct net_device *dev)
> +{
> +	struct gtp1_header *gtp1c;
> +	int payload_len;
> +
> +	if (opts->ver != GTP_METADATA_V1)
> +		return -ENOENT;
> +
> +	if (opts->type == 0xFE) {
> +		/* for end marker ignore skb data. */
> +		netdev_dbg(dev, "xmit pkt with null data");
> +		pskb_trim(skb, 0);
> +	}
> +	if (skb_cow_head(skb, sizeof(*gtp1c)) < 0)
> +		return -ENOMEM;
> +
> +	payload_len = skb->len;
> +
> +	gtp1c = skb_push(skb, sizeof(*gtp1c));
> +
> +	gtp1c->flags	= opts->flags;
> +	gtp1c->type	= opts->type;
> +	gtp1c->length	= htons(payload_len);
> +	gtp1c->tid	= htonl(pctx->u.v1.o_tei);
> +	netdev_dbg(dev, "xmit control pkt: ver %d flags %x type %x pkt len %d tid %x",
> +		   opts->ver, opts->flags, opts->type, skb->len, pctx->u.v1.o_tei);
> +	return 0;
> +}

There's nothing really special about that above function aside from the 
facts that it takes 'opts' as an argument.  Can't we just merge this 
with the regular 'gtp_push_header' function?  Do you have plans for this 
beyond what's here that would complicated by doing so?

/Jonas


> +
>   static int gtp_xmit_ip4(struct sk_buff *skb, struct net_device *dev)
>   {
>   	struct gtp_dev *gtp = netdev_priv(dev);
> @@ -807,7 +839,16 @@ static int gtp_xmit_ip4(struct sk_buff *skb, struct net_device *dev)
>   
>   	skb_set_inner_protocol(skb, skb->protocol);
>   
> -	gtp_push_header(skb, pctx, &port);
> +	if (unlikely(opts)) {
> +		port = htons(GTP1U_PORT);
> +		r = gtp1_push_control_header(skb, pctx, opts, dev);
> +		if (r) {
> +			netdev_info(dev, "cntr pkt error %d", r);
> +			goto err_rt;
> +		}
> +	} else {
> +		gtp_push_header(skb, pctx, &port);
> +	}
>   
>   	iph = ip_hdr(skb);
>   	netdev_dbg(dev, "gtp -> IP src: %pI4 dst: %pI4\n",
> 

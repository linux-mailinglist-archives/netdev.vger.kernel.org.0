Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7F22C3D147A
	for <lists+netdev@lfdr.de>; Wed, 21 Jul 2021 18:46:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235143AbhGUQFj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Jul 2021 12:05:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59928 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232585AbhGUQFi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 21 Jul 2021 12:05:38 -0400
Received: from mail-wr1-x430.google.com (mail-wr1-x430.google.com [IPv6:2a00:1450:4864:20::430])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 62507C061575
        for <netdev@vger.kernel.org>; Wed, 21 Jul 2021 09:46:14 -0700 (PDT)
Received: by mail-wr1-x430.google.com with SMTP id f17so2888609wrt.6
        for <netdev@vger.kernel.org>; Wed, 21 Jul 2021 09:46:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=bnfNLQbapo04htEMVmrHv3Hw2/PvXJQtO1GubH9G0ew=;
        b=rhb0jndEbht0GL/mC1EZm/8EYR+Gfdv2KLpU75wkj/ghtCP4/S/cPL4v8s+mQBOVLy
         32y7bc23TpN1JBp+sUgfD9fN+jsT94AYLXTp6QtKHQZa0a8xO+TQX8dZR1zHs/MjvDlW
         DSiz19lNUPnyptE0TVNfQ0XOfEvbVKRuaA7E5IfBQOzjbuJwAtWHNkFe1uMgWdcIbZKS
         ToU6MZHubLtPiG1DrJf2iR34h2NDoksYr5y4yjorhfSQeRsC6gqj5NJekyMhRjNeQidC
         knaNZU5xYAp+5IkIye3BqipDEPWtRpERgZLiUWJ4nv//eUns9cyEeOygnXG9BDGzU6oN
         WEdA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=bnfNLQbapo04htEMVmrHv3Hw2/PvXJQtO1GubH9G0ew=;
        b=Od+FQ8pxJy2uVYES80uAWKWqzRERF6RXgvv/Iu4DY3zqmMpvwetWoC/4ROdkdxUfs5
         9Fwd14LFEVy6v2LFgWEp12uLcyuhzS/A4ShtYh1Zp0uqveZ5M8ZBWa1KRJO8J4v/DPtq
         c7aFMdZWKhxzINid3OL4qxSdL5v0eeym8yajn4zmWBIyAoAEULqnbvQsttLwfp70emvR
         tPNJL51Ilpz4TC5QbvbjfaR07WRfqDIJI2zZUo9hu4ABWTH4AWaDYC8QR3JFXKvmIaG4
         WGbEk9rFgBLh4VSpCU1CU5ELs2y8jzK1jXTmcwIwcJXruE9s3amLuEHHXuSk1N41hOYv
         d1Gw==
X-Gm-Message-State: AOAM531kjJpd98XgFnBy3rN8Ph04SaLenpm8UoMQiFdWHLk5ki0LevXC
        caUuy/0trc2ITSDzH2LBdQY=
X-Google-Smtp-Source: ABdhPJz4AUlImkiy5+eGWQ5HB/EpKs08LvNQIQyDZrht+VfauByUijx5BdlAZrEjGxZm6hSAmvHzbQ==
X-Received: by 2002:a5d:6189:: with SMTP id j9mr44739934wru.196.1626885973051;
        Wed, 21 Jul 2021 09:46:13 -0700 (PDT)
Received: from [10.0.0.18] ([37.165.40.217])
        by smtp.gmail.com with ESMTPSA id x18sm26654674wrw.19.2021.07.21.09.46.11
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 21 Jul 2021 09:46:12 -0700 (PDT)
Subject: Re: [PATCH net-next v5 2/6] ipv6: ioam: Data plane support for
 Pre-allocated Trace
To:     Justin Iurman <justin.iurman@uliege.be>, netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, yoshfuji@linux-ipv6.org,
        dsahern@kernel.org, tom@herbertland.com
References: <20210720194301.23243-1-justin.iurman@uliege.be>
 <20210720194301.23243-3-justin.iurman@uliege.be>
From:   Eric Dumazet <eric.dumazet@gmail.com>
Message-ID: <37f96841-39ad-c9bc-0b47-b1e418c4d9b8@gmail.com>
Date:   Wed, 21 Jul 2021 18:46:10 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <20210720194301.23243-3-justin.iurman@uliege.be>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 7/20/21 9:42 PM, Justin Iurman wrote:
> Implement support for processing the IOAM Pre-allocated Trace with IPv6,
> see [1] and [2]. Introduce a new IPv6 Hop-by-Hop TLV option, see IANA [3].
> 
> A new per-interface sysctl is introduced. The value is a boolean to accept (=1)
> or ignore (=0, by default) IPv6 IOAM options on ingress for an interface:
>  - net.ipv6.conf.XXX.ioam6_enabled
> 

...

>  }
>  
> +/* IOAM */
> +
> +static bool ipv6_hop_ioam(struct sk_buff *skb, int optoff)
> +{
> +	struct ioam6_trace_hdr *trace;
> +	struct ioam6_namespace *ns;
> +	struct ioam6_hdr *hdr;
> +
> +	/* Bad alignment (must be 4n-aligned) */
> +	if (optoff & 3)
> +		goto drop;
> +
> +	/* Ignore if IOAM is not enabled on ingress */
> +	if (!__in6_dev_get(skb->dev)->cnf.ioam6_enabled)
> +		goto ignore;
> +
> +	/* Truncated Option header */
> +	hdr = (struct ioam6_hdr *)(skb_network_header(skb) + optoff);
> +	if (hdr->opt_len < 2)
> +		goto drop;
> +
> +	switch (hdr->type) {
> +	case IOAM6_TYPE_PREALLOC:
> +		/* Truncated Pre-allocated Trace header */
> +		if (hdr->opt_len < 2 + sizeof(*trace))
> +			goto drop;
> +
> +		/* Malformed Pre-allocated Trace header */
> +		trace = (struct ioam6_trace_hdr *)((u8 *)hdr + sizeof(*hdr));
> +		if (hdr->opt_len < 2 + sizeof(*trace) + trace->remlen * 4)
> +			goto drop;
> +
> +		/* Ignore if the IOAM namespace is unknown */
> +		ns = ioam6_namespace(ipv6_skb_net(skb), trace->namespace_id);
> +		if (!ns)
> +			goto ignore;
> +
> +		if (!skb_valid_dst(skb))
> +			ip6_route_input(skb);
> +
> +		ioam6_fill_trace_data(skb, ns, trace);
> +		break;
> +	default:
> +		break;
> +	}
> +
> +ignore:
> +	return true;
> +
> +drop:
> +	kfree_skb(skb);
> +	return false;
> +}
> +
>  /* Jumbo payload */
>  
>  static bool ipv6_hop_jumbo(struct sk_buff *skb, int optoff)
> @@ -999,6 +1056,10 @@ static const struct tlvtype_proc tlvprochopopt_lst[] = {
>  		.type	= IPV6_TLV_ROUTERALERT,
>  		.func	= ipv6_hop_ra,
>  	},
> +	{
> +		.type	= IPV6_TLV_IOAM,
> +		.func	= ipv6_hop_ioam,
> +	},

It is a bit strange to put a not-yet used option in the midle of the table,
before TLV_JUMBO (that some of us use already...)


>  	{
>  		.type	= IPV6_TLV_JUMBO,
>  		.func	= ipv6_hop_jumbo,

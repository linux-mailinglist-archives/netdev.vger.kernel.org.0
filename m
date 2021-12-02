Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3DC9A466874
	for <lists+netdev@lfdr.de>; Thu,  2 Dec 2021 17:40:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1359135AbhLBQn6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Dec 2021 11:43:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39150 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237080AbhLBQn5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Dec 2021 11:43:57 -0500
Received: from mail-ot1-x32b.google.com (mail-ot1-x32b.google.com [IPv6:2607:f8b0:4864:20::32b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 43B57C06174A
        for <netdev@vger.kernel.org>; Thu,  2 Dec 2021 08:40:35 -0800 (PST)
Received: by mail-ot1-x32b.google.com with SMTP id x3-20020a05683000c300b0057a5318c517so333373oto.13
        for <netdev@vger.kernel.org>; Thu, 02 Dec 2021 08:40:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=68+m3RJah+8IljvkkfwYXGTDXXOGi74HpW0rqyqsAgs=;
        b=KxPrwAjs6LLS+X9BNRafm9m3LQmwDpiQ4nVqOOi/NvozNiT1yhMKT4WvdhtUQSCIYv
         KG7+cWmVVz9/Tus38gDcAxdAAdErB7dCwHtXUf00n9tBPTu06pE/Vev59Qqsnr3zGuFS
         /ntXiv1ROF5mDINyg+9yjMgeCF4S8IuWeI3qxK9Zver3vJglbS/w6kVD037xTvUw3w2D
         5AqzEsoD8DssOmC6xdsYcbwGGo715caXatu7j6+5PzEhH0Y1bWhEj2QvB40OULbKUGGy
         r3biZiUuGX0oLTVQ/JArazBlkda6RPRK/aikjrjjhonGaz6LfscKAK8RBNjdFBj/S/xw
         jaZQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=68+m3RJah+8IljvkkfwYXGTDXXOGi74HpW0rqyqsAgs=;
        b=X+BhxNHVAEGs7QMCNiV3c5tKP25PCOImMw4C9tEeKgO8Ev9FpJ8c6Hqg6r95MEOXDc
         E3d2W+uwfHn9RX6EdrP1Q1Cw+KEg2JW1/TmUfjl7SpA4RhknP2ltrm7lJMxqfK3dsLeN
         cOdqFeHfMvonF+YJO+Ivjt5Nsm7Ggy5Hjcsoe3034vNuwxczZeYpGaMx2YZ8hEz3xz3E
         FKAPsVdtvnNmA3aEfYQ66ZCax2LcQ9fRREUdArAAyoKITyOa9BLLgGab3X+/1RDAyw5u
         PEPjjpFJ8bGbaMmSXLcDKztUrbsi+UAKNP5mU3QbhgFtakdlOh7qf347K+yl8qgj3HYS
         ctdQ==
X-Gm-Message-State: AOAM531SwdNJeDHtbq/PEkpHMCdnh3J0jiKXXJZrDhEWY3wlXh84zxQi
        SBpZK9jXnUbylxS1/9bBV/U=
X-Google-Smtp-Source: ABdhPJwq8tY0MQ1kbDgnFFlhWSuQzOAM6swtskyuaSCV+ej0gPlLbNa4HjTlJtd4asgdYblSgk3XHA==
X-Received: by 2002:a9d:7b51:: with SMTP id f17mr12121516oto.88.1638463234710;
        Thu, 02 Dec 2021 08:40:34 -0800 (PST)
Received: from [172.16.0.2] ([8.48.134.30])
        by smtp.googlemail.com with ESMTPSA id bi20sm174569oib.29.2021.12.02.08.40.33
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 02 Dec 2021 08:40:34 -0800 (PST)
Message-ID: <9dcf55f7-9dde-5d76-a731-328462c393df@gmail.com>
Date:   Thu, 2 Dec 2021 09:40:33 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.3.2
Subject: Re: [patch RFC net-next v2 3/3] udp6: Use Segment Routing Header for
 dest address if present
Content-Language: en-US
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>,
        Willem de Bruijn <willemb@google.com>,
        James Prestwood <prestwoj@gmail.com>,
        Justin Iurman <justin.iurman@uliege.be>,
        Praveen Chaudhary <praveen5582@gmail.com>,
        "Jason A . Donenfeld" <Jason@zx2c4.com>,
        Eric Dumazet <edumazet@google.com>,
        netdev <netdev@vger.kernel.org>
References: <20211201202519.3637005-1-andrew@lunn.ch>
 <20211201202519.3637005-4-andrew@lunn.ch>
From:   David Ahern <dsahern@gmail.com>
In-Reply-To: <20211201202519.3637005-4-andrew@lunn.ch>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 12/1/21 1:25 PM, Andrew Lunn wrote:
> @@ -563,12 +564,18 @@ int __udp6_lib_err(struct sk_buff *skb, struct inet6_skb_parm *opt,
>  	const struct in6_addr *saddr = &hdr->saddr;
>  	const struct in6_addr *daddr = &hdr->daddr;
>  	struct udphdr *uh = (struct udphdr *)(skb->data+offset);
> +	struct ipv6_sr_hdr *srh;
>  	bool tunnel = false;
>  	struct sock *sk;
>  	int harderr;
>  	int err;
>  	struct net *net = dev_net(skb->dev);
>  
> +	if (opt->flags & IP6SKB_SEG6) {
> +		srh = (struct ipv6_sr_hdr *)(skb->data + opt->srhoff);
> +		daddr = &srh->segments[0];
> +	}
> +
>  	sk = __udp6_lib_lookup(net, daddr, uh->dest, saddr, uh->source,
>  			       inet6_iif(skb), inet6_sdif(skb), udptable, NULL);
>  

similarly for this one, have a helper in seg6.h that returns in6_addr
pointer. It will be referencing within skb->data so should be fine.

Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D3F0C3BED47
	for <lists+netdev@lfdr.de>; Wed,  7 Jul 2021 19:41:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230408AbhGGRoa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Jul 2021 13:44:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55574 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230110AbhGGRo3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Jul 2021 13:44:29 -0400
Received: from mail-wr1-x433.google.com (mail-wr1-x433.google.com [IPv6:2a00:1450:4864:20::433])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6E645C061574;
        Wed,  7 Jul 2021 10:41:48 -0700 (PDT)
Received: by mail-wr1-x433.google.com with SMTP id a8so4017037wrp.5;
        Wed, 07 Jul 2021 10:41:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=lA3hDr792hgobfyrQMbraHH3m59ZWiVGpciRaq1+pUE=;
        b=vhIjqE2ALd4XXXh06sMcmJELw+L7AWFALPddHb12EhQNWJbZGClUcxJQ7fiPxegudN
         /OOZvxb78sHoZLxiSRg20Cmw5lInY60zs1HIUdYPzWnzNX97eHwB9DVadtWNTNXF313l
         +rNaOqMGGggXANoW8EPQKLeehcobgT4SRe+Wq6JNN69BxCTpFUGWrPFAFQPX1qyqbMoT
         064ejKBH7k7lq4kDVpSi68JlnDkqKGt12KyliTICvFeeXFMNtsqyKTvccsYyYNb58+d4
         mQr0PxIdbX2MvDeyxHQhTRvokOVwxHEKmUOxQNzhvcH2byuAn2fdQKfpzVCzN+8RFyRx
         NT3w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=lA3hDr792hgobfyrQMbraHH3m59ZWiVGpciRaq1+pUE=;
        b=gPDmZd607Esb8NpaXAR2o2PdBeniezVqjYrznTpMQKbvSTU3a+UXjSoTZxZ2vdG8Q8
         9TE7aVY3ByyT90oS4Ww1GN8Ivvg3njyt7KGwgjQk7oo5i/HeKdowjtqxtACmXKHKeIVj
         9yy0On59G88NB58FdhbFRxOTdT3uizriRt9PEcaUyBnmqcq4gUhM3UM5j5v6TvrnYd1r
         fovubmWY3hu3YfQqyx06ek7Wf5yuw9uRhrf0hloTp9/OYNDwVIk5vDAvKNQyw459RpXh
         +yqjbrNyIaHbMDrapcRDCmIHRQaaQZbpCyvWdqyt/WtKBQijti3DzE/EY0hcvX9OjP58
         lwVw==
X-Gm-Message-State: AOAM533KV1RP+kZgS48aDCZxJDxsbYHRPxH9Po9/uqGjk6XJ5o9k+KXS
        QeFu+058W9HVjFzdMoKrSq8EHfPsdVA=
X-Google-Smtp-Source: ABdhPJwbkbndjTycaWgmbiEB+6RtI4zIbh92o7Cw787TdRjf7dZaoUfxNq3A7M96i3Ct7Y1o08e70A==
X-Received: by 2002:a05:6000:1361:: with SMTP id q1mr28751207wrz.179.1625679706809;
        Wed, 07 Jul 2021 10:41:46 -0700 (PDT)
Received: from [192.168.98.98] (162.199.23.93.rev.sfr.net. [93.23.199.162])
        by smtp.gmail.com with ESMTPSA id o11sm7671585wmc.2.2021.07.07.10.41.45
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 07 Jul 2021 10:41:46 -0700 (PDT)
Subject: Re: [PATCH IPV6 1/1] ipv6: allocate enough headroom in
 ip6_finish_output2()
To:     Jakub Kicinski <kuba@kernel.org>, David Ahern <dsahern@gmail.com>
Cc:     Vasily Averin <vvs@virtuozzo.com>,
        "David S. Miller" <davem@davemloft.net>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <cover.1625665132.git.vvs@virtuozzo.com>
 <3cb5a2e5-4e4c-728a-252d-4757b6c9612d@virtuozzo.com>
 <8996db63-5554-d3dc-cd36-94570ade6d18@gmail.com>
 <20210707094218.0e9b6ffc@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   Eric Dumazet <eric.dumazet@gmail.com>
Message-ID: <1cbf3c7b-455e-f3a5-cc2c-c18ce8be4ce1@gmail.com>
Date:   Wed, 7 Jul 2021 19:41:44 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <20210707094218.0e9b6ffc@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 7/7/21 6:42 PM, Jakub Kicinski wrote:
> On Wed, 7 Jul 2021 08:45:13 -0600 David Ahern wrote:
>> On 7/7/21 8:04 AM, Vasily Averin wrote:
>>> diff --git a/net/ipv6/ip6_output.c b/net/ipv6/ip6_output.c
>>> index ff4f9eb..e5af740 100644
>>> --- a/net/ipv6/ip6_output.c
>>> +++ b/net/ipv6/ip6_output.c
>>> @@ -61,9 +61,24 @@ static int ip6_finish_output2(struct net *net, struct sock *sk, struct sk_buff *
>>>  	struct dst_entry *dst = skb_dst(skb);
>>>  	struct net_device *dev = dst->dev;
>>>  	const struct in6_addr *nexthop;
>>> +	unsigned int hh_len = LL_RESERVED_SPACE(dev);
>>>  	struct neighbour *neigh;
>>>  	int ret;
>>>  
>>> +	/* Be paranoid, rather than too clever. */
>>> +	if (unlikely(skb_headroom(skb) < hh_len && dev->header_ops)) {
>>> +		struct sk_buff *skb2;
>>> +
>>> +		skb2 = skb_realloc_headroom(skb, LL_RESERVED_SPACE(dev));  
>>
>> why not use hh_len here?
> 
> Is there a reason for the new skb? Why not pskb_expand_head()?


pskb_expand_head() might crash, if skb is shared.

We possibly can add a helper, factorizing all this,
and eventually use pskb_expand_head() if safe.

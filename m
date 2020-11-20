Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C51792BAEB2
	for <lists+netdev@lfdr.de>; Fri, 20 Nov 2020 16:24:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729621AbgKTPTa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Nov 2020 10:19:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39988 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729278AbgKTPT3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 Nov 2020 10:19:29 -0500
Received: from mail-il1-x141.google.com (mail-il1-x141.google.com [IPv6:2607:f8b0:4864:20::141])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8C9DCC0613CF;
        Fri, 20 Nov 2020 07:19:29 -0800 (PST)
Received: by mail-il1-x141.google.com with SMTP id z14so8806484ilp.11;
        Fri, 20 Nov 2020 07:19:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=go7rpHsn97AURPaqxUQweQF8Yet+YfZQ1TK6lJWZl+g=;
        b=UrAWVCjpki5tt9jdrOvuDgNswX793gxa2psmzm60gyRIQ8VSpqscZdhFcZ7avg+BAQ
         1bB89FKmqFzZqsTy1uZvlxfijIpa6REn5QTwCtVJfNYXYzDJaZQhY30FtshImitXhfhx
         8LbJVUqnO1uvDSsAm3PeL1cQV3FXM9SnR0GugEThnY/ZakAkbX1RF9cd71imjoejMUNN
         1tGUk9OcBiyh9bI9cgAJz76dZcM/+m+zW7+5nlvTYR3IReLqGtio51UXcIqg1yFwS5KY
         Buvxe7VQaAtI3pSKqMN1CwiFcpNVAVdSjdy7VJ+D60//Uw1idyh78hPI/qcsDqOFGdbB
         7x9g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=go7rpHsn97AURPaqxUQweQF8Yet+YfZQ1TK6lJWZl+g=;
        b=p8QvgpF28cGhb1ItjWvtbrZDZLuEVA+BNr9AFBF1wPQMVmNoTQ4Krm1QdG/s75Q4RY
         7rXpTBxzfMmpW5MlKvO0R27yGOfL16rN/bEZoK/mpsk5FsM8/C0A5DpXMdNrKYN1ErJK
         +zMdzhFuO0oIUzWQyPVNWNrbE4SIH2+FQBDaYcVPPp+VW8K+n+UvZJX3imodGWO91uIW
         AE9hUoMi9YAvVnrEkyrm21WvRbQPnQv2ZcxGZK0gdzjBHgJcrFsH00hWS8vqQZJaWMbD
         3uOz3J9j9tkHHue4XVfJnHoWqfh7lUPkTJP0OUh+carSjDNhbOC19EMlSQpkqa1OW/0O
         97rQ==
X-Gm-Message-State: AOAM530U4NODdwqfwY9if4fNolOeyLOpoM5Za3y6iHxHXCjbnBIiPwEj
        LZym/pnZNWcOnQAAaWagfsk=
X-Google-Smtp-Source: ABdhPJzHuxQ96VQz19thRa5iYvSE5dLidV0XB7RllJORKi7Se319Gn7LsXhuQKKg17tjcb32n1IYiQ==
X-Received: by 2002:a92:ba14:: with SMTP id o20mr27070503ili.268.1605885568355;
        Fri, 20 Nov 2020 07:19:28 -0800 (PST)
Received: from Davids-MacBook-Pro.local ([2601:282:800:dc80:61e9:2b78:3570:a66])
        by smtp.googlemail.com with ESMTPSA id p83sm1827957iod.49.2020.11.20.07.19.27
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 20 Nov 2020 07:19:27 -0800 (PST)
Subject: Re: [PATCH] bpf: Check the return value of dev_get_by_index_rcu()
To:     Daniel Borkmann <daniel@iogearbox.net>, xiakaixu1987@gmail.com,
        ast@kernel.org, kafai@fb.com, songliubraving@fb.com, yhs@fb.com,
        andrii@kernel.org, john.fastabend@gmail.com, kpsingh@chromium.org
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        linux-kernel@vger.kernel.org, Kaixu Xia <kaixuxia@tencent.com>
References: <1605769468-2078-1-git-send-email-kaixuxia@tencent.com>
 <65d8f988-5b41-24c2-8501-7cbbddb1238e@iogearbox.net>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <f8ff26f0-b1b6-6dd1-738d-4c592a8efdb0@gmail.com>
Date:   Fri, 20 Nov 2020 08:19:26 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.4.3
MIME-Version: 1.0
In-Reply-To: <65d8f988-5b41-24c2-8501-7cbbddb1238e@iogearbox.net>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 11/20/20 8:13 AM, Daniel Borkmann wrote:
> [ +David ]
> 
> On 11/19/20 8:04 AM, xiakaixu1987@gmail.com wrote:
>> From: Kaixu Xia <kaixuxia@tencent.com>
>>
>> The return value of dev_get_by_index_rcu() can be NULL, so here it
>> is need to check the return value and return error code if it is NULL.
>>
>> Signed-off-by: Kaixu Xia <kaixuxia@tencent.com>
>> ---
>>   net/core/filter.c | 2 ++
>>   1 file changed, 2 insertions(+)
>>
>> diff --git a/net/core/filter.c b/net/core/filter.c
>> index 2ca5eecebacf..1263fe07170a 100644
>> --- a/net/core/filter.c
>> +++ b/net/core/filter.c
>> @@ -5573,6 +5573,8 @@ BPF_CALL_4(bpf_skb_fib_lookup, struct sk_buff *,
>> skb,
>>           struct net_device *dev;
>>             dev = dev_get_by_index_rcu(net, params->ifindex);
>> +        if (unlikely(!dev))
>> +            return -EINVAL;
>>           if (!is_skb_forwardable(dev, skb))
>>               rc = BPF_FIB_LKUP_RET_FRAG_NEEDED;

rcu lock is held right? It is impossible for dev to return NULL here.

> 
> The above logic is quite ugly anyway given we fetched the dev pointer
> already earlier
> in bpf_ipv{4,6}_fib_lookup() and now need to redo it again ... so yeah

evolved from the different needs of the xdp and tc paths.

> there could be
> a tiny race in here. We wanted do bring this logic closer to what XDP
> does anyway,
> something like below, for example. David, thoughts? Thx
> 
> Subject: [PATCH] diff mtu check
> 
> Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
> ---
>  net/core/filter.c | 22 +++++-----------------
>  1 file changed, 5 insertions(+), 17 deletions(-)
> 
> diff --git a/net/core/filter.c b/net/core/filter.c
> index 2ca5eecebacf..3bab0a97fa38 100644
> --- a/net/core/filter.c
> +++ b/net/core/filter.c
> @@ -5547,9 +5547,6 @@ static const struct bpf_func_proto
> bpf_xdp_fib_lookup_proto = {
>  BPF_CALL_4(bpf_skb_fib_lookup, struct sk_buff *, skb,
>         struct bpf_fib_lookup *, params, int, plen, u32, flags)
>  {
> -    struct net *net = dev_net(skb->dev);
> -    int rc = -EAFNOSUPPORT;
> -
>      if (plen < sizeof(*params))
>          return -EINVAL;
> 
> @@ -5559,25 +5556,16 @@ BPF_CALL_4(bpf_skb_fib_lookup, struct sk_buff *,
> skb,
>      switch (params->family) {
>  #if IS_ENABLED(CONFIG_INET)
>      case AF_INET:
> -        rc = bpf_ipv4_fib_lookup(net, params, flags, false);
> -        break;
> +        return bpf_ipv4_fib_lookup(dev_net(skb->dev), params, flags,
> +                       !skb_is_gso(skb));
>  #endif
>  #if IS_ENABLED(CONFIG_IPV6)
>      case AF_INET6:
> -        rc = bpf_ipv6_fib_lookup(net, params, flags, false);
> -        break;
> +        return bpf_ipv6_fib_lookup(dev_net(skb->dev), params, flags,
> +                       !skb_is_gso(skb));

seems ok.


>  #endif
>      }
> -
> -    if (!rc) {
> -        struct net_device *dev;
> -
> -        dev = dev_get_by_index_rcu(net, params->ifindex);
> -        if (!is_skb_forwardable(dev, skb))
> -            rc = BPF_FIB_LKUP_RET_FRAG_NEEDED;
> -    }
> -
> -    return rc;
> +    return -EAFNOSUPPORT;
>  }
> 
>  static const struct bpf_func_proto bpf_skb_fib_lookup_proto = {


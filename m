Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A171A1CB22C
	for <lists+netdev@lfdr.de>; Fri,  8 May 2020 16:43:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727983AbgEHOnm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 May 2020 10:43:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50114 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727841AbgEHOni (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 8 May 2020 10:43:38 -0400
Received: from mail-pf1-x442.google.com (mail-pf1-x442.google.com [IPv6:2607:f8b0:4864:20::442])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 804E7C061A0C
        for <netdev@vger.kernel.org>; Fri,  8 May 2020 07:43:38 -0700 (PDT)
Received: by mail-pf1-x442.google.com with SMTP id 18so1030656pfx.6
        for <netdev@vger.kernel.org>; Fri, 08 May 2020 07:43:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=uxuFrPbMNZSF2KTUlwhWw01v9/d1SJataGSiFfIMVcc=;
        b=XeicOgaz5/MVZWJLCm0UFijW4VnBcXNE2Xn7GfO3jXhQNtiLpDJXNI4ChOVEbJX/+H
         JCNzmmB9MyyCJKB3LGdDIYFZ1MKIgHzN2DULobzTF6g2UuwFkM0LtCeXPnTiq+Zuav5k
         N0zzSyRDC22YovFNodYxEWPztI2ZDqKBiq3FVo1tsXypkt2x7Vg/5imNx9ndDvAxR2Tt
         QOqXzu8JhdNYbQVunzyo29wuhov1n/zpqQIUPreK5AvSSSzvE69/FXCRPliv+J4nJ9Ko
         9/xevFEIhHgAmNz8fIUzEfvzexlb60wqjYrZzTY1/k+S6MLQtnG5CxGWIb5wbc2C3x3R
         0WOA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=uxuFrPbMNZSF2KTUlwhWw01v9/d1SJataGSiFfIMVcc=;
        b=GG0Lx2QDGv363PG4lRG2d5+Nd0N9Hnrg6takvKyokKHlDaClE9/ulbEBcCFx8WN03/
         zi4zn9f2IAhQqgjrgrzTGy30qiOgJfewms0Immybb1W/I+PL5pqlspaN7TVTHR5rK63U
         pYySvfWv27524jyCNidqhYKg2JzsV1SyKnfG3YpPgIphjGCfuUaV17SlLpgT0I2wcOid
         X9B4aLrYzxTOUHWKyXvRkJr0umJ/+fB/4nxPwdNuuOQTfVOUC3REv8scB588264lmIXj
         bTMLY+KNiy9ZIabeR6mYHs0HRt1v1EDvHW3t2aeQc36qUIe9zdCvnhDuEE0gX1UUufGB
         8elw==
X-Gm-Message-State: AGi0Pua2ijbG7LvGboKg73PsgCHcfQ273+6y0p1sCJF/9Udt6hGP41iE
        aC6Y1TV7RoAZN9zdCS9BYWk=
X-Google-Smtp-Source: APiQypL9l2yWkFvPfRVwjKAlM1OqykMJCThD7q50yKb0iePKG+kI8aTONATaUPbh7xQ6XaVYN/D8gQ==
X-Received: by 2002:a63:1a58:: with SMTP id a24mr2455740pgm.419.1588949018083;
        Fri, 08 May 2020 07:43:38 -0700 (PDT)
Received: from [192.168.86.235] (c-73-241-150-58.hsd1.ca.comcast.net. [73.241.150.58])
        by smtp.gmail.com with ESMTPSA id d8sm1913903pfd.159.2020.05.08.07.43.31
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 08 May 2020 07:43:37 -0700 (PDT)
Subject: Re: [PATCH net-next] ipv6: use DST_NOCOUNT in ip6_rt_pcpu_alloc()
To:     David Ahern <dsahern@gmail.com>,
        Eric Dumazet <edumazet@google.com>,
        "David S . Miller" <davem@davemloft.net>
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Martin KaFai Lau <kafai@fb.com>,
        David Ahern <dsahern@kernel.org>, Wei Wang <weiwan@google.com>,
        =?UTF-8?Q?Maciej_=c5=bbenczykowski?= <maze@google.com>
References: <20200508143414.42022-1-edumazet@google.com>
 <362c2030-6e7f-512d-4285-d904b4a433b6@gmail.com>
From:   Eric Dumazet <eric.dumazet@gmail.com>
Message-ID: <a5f381b0-e2bf-05f9-a849-d9d45aa38212@gmail.com>
Date:   Fri, 8 May 2020 07:43:30 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <362c2030-6e7f-512d-4285-d904b4a433b6@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 5/8/20 7:39 AM, David Ahern wrote:
> On 5/8/20 8:34 AM, Eric Dumazet wrote:
>> We currently have to adjust ipv6 route gc_thresh/max_size depending
>> on number of cpus on a server, this makes very little sense.
>>
>> If the kernels sets /proc/sys/net/ipv6/route/gc_thresh to 1024
>> and /proc/sys/net/ipv6/route/max_size to 4096, then we better
>> not track the percpu dst that our implementation uses.
>>
>> Only routes not added (directly or indirectly) by the admin
>> should be tracked and limited.
>>
>> Signed-off-by: Eric Dumazet <edumazet@google.com>
>> Cc: Martin KaFai Lau <kafai@fb.com>
>> Cc: David Ahern <dsahern@kernel.org>
>> Cc: Wei Wang <weiwan@google.com>
>> Cc: Maciej Żenczykowski <maze@google.com>
>> ---
>>  net/ipv6/route.c | 2 +-
>>  1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/net/ipv6/route.c b/net/ipv6/route.c
>> index a9072dba00f4fb0b61bce1fc0f44a3a81ba702fa..4292653af533bb641ae8571fffe45b39327d0380 100644
>> --- a/net/ipv6/route.c
>> +++ b/net/ipv6/route.c
>> @@ -1377,7 +1377,7 @@ static struct rt6_info *ip6_rt_pcpu_alloc(const struct fib6_result *res)
>>  
>>  	rcu_read_lock();
>>  	dev = ip6_rt_get_dev_rcu(res);
>> -	pcpu_rt = ip6_dst_alloc(dev_net(dev), dev, flags);
>> +	pcpu_rt = ip6_dst_alloc(dev_net(dev), dev, flags | DST_NOCOUNT);
>>  	rcu_read_unlock();
>>  	if (!pcpu_rt) {
>>  		fib6_info_release(f6i);
>>
> 
> At this point in IPv6's evolution it seems like it can align more with
> IPv4 and just get rid of the dst limits completely.
> 

This patch can be backported without any pains ;)

Getting rid of limits, even for exceptions ?

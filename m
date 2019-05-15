Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3EC521F996
	for <lists+netdev@lfdr.de>; Wed, 15 May 2019 19:49:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727355AbfEORta (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 May 2019 13:49:30 -0400
Received: from mail-pg1-f193.google.com ([209.85.215.193]:40131 "EHLO
        mail-pg1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726360AbfEORta (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 May 2019 13:49:30 -0400
Received: by mail-pg1-f193.google.com with SMTP id d30so139947pgm.7
        for <netdev@vger.kernel.org>; Wed, 15 May 2019 10:49:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=f+pO3c77XQZ6E9VDhAesU5XOi6vF/DO+NXXF0biIs4w=;
        b=dU/hd2mf1B4/d7LWs/TnTz+M6rT9bxODnr43Q6LNfC8XDSeB6UvBbM8pM0Hg8BBV2f
         sbXa1ZVkh0wsF1v5vH0zaFoj9E9/Pc4HqTgkcJW/P6Ij7FH4EUPvAKL4kC9Tgxc5WWi6
         Pn4nVUNIKngoLukQW1EB0BcmcIyAxC67bRvPwvGJU00hxQdifoin3601Mwpfwqs6FmHJ
         6MUTNBpET0kmRZqOLNvNyF/4edgaKo8yDr2vRxzjHfvtT1NaTypn/MCpz8wnfvzct71I
         umKgUvf1fqDNCWwHAgjyZ131Ipe6lcw9jLU1tdkThyFdnmXY32f634aqRwYz/yYARxSR
         xLXg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=f+pO3c77XQZ6E9VDhAesU5XOi6vF/DO+NXXF0biIs4w=;
        b=jPKkfMHtaVB9D73K0I2HHEljZxQMqHlC03NRj6BiJN6YDy4VulYt6PX9DlGfBAphUk
         IEwEDUwViV+eVYGYNAF5+4U38qrKPcEwRpxvaFku9kS1W77XkQB1blcnxS4eQmx5PAT1
         ZDOkE/vw3KGnDj16cbasht6BGauJeOs69X6mA277JdZZVo8Xbv4oOqOSGTAPg5eqjqnk
         jNMGBzpXiql8moiPZJKrPXh1ehIWTjCaWBTnsczq0M5jfrHr8yn4k2bzE3npCBhhoDXY
         08AT031QxT5LvRdhcCWbrNevM8SuyXx2WtaaTyNQ9gpIQ84hjgQlzp+kYMFwQJVEIGIO
         lzpQ==
X-Gm-Message-State: APjAAAWYhxBl14tL3X9T3GlWEZXCBPN1TEIpN0pUeCbLK2wT8HPgqDJC
        yoOHCivmpUfElK8xg/ChpL0=
X-Google-Smtp-Source: APXvYqwxZZaHVIh88A2ThR+XCxvDUweCJTW6dljKzkC9i1glXFjTXuoLGl5heTqWUcV2UTlU83WakA==
X-Received: by 2002:aa7:8157:: with SMTP id d23mr21382282pfn.92.1557942569273;
        Wed, 15 May 2019 10:49:29 -0700 (PDT)
Received: from ?IPv6:2601:282:800:fd80:81dc:8ee9:edb2:6ea? ([2601:282:800:fd80:81dc:8ee9:edb2:6ea])
        by smtp.googlemail.com with ESMTPSA id x7sm2084670pgl.11.2019.05.15.10.49.27
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 15 May 2019 10:49:28 -0700 (PDT)
Subject: Re: [PATCH net] ipv6: fix src addr routing with the exception table
To:     Wei Wang <weiwan@google.com>
Cc:     Wei Wang <tracywwnj@gmail.com>, David Miller <davem@davemloft.net>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Mikael Magnusson <mikael.kernel@lists.m7n.se>,
        Eric Dumazet <edumazet@google.com>
References: <20190515004610.102519-1-tracywwnj@gmail.com>
 <fdded637-fd19-bcab-87aa-b71ca8158735@gmail.com>
 <95d844f2-1be2-83b9-1910-e90ad3d2b28d@gmail.com>
 <CAEA6p_B8-zBPxzcNSdpK+2U2eOU0efQBSu1dMx3sEV7r1+c8oA@mail.gmail.com>
 <CAEA6p_D0-dT4a-wqz7DMq8dSNbESRkj40ESTTxdnbPar-0N90g@mail.gmail.com>
 <a1fa84e7-e474-9488-ddc5-e139ab1f2e05@gmail.com>
 <CAEA6p_ATUB_tXY12FFFnw0HFAdJzo0VVsdBzN_AL4KGVc9gVVw@mail.gmail.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <22938ec3-6a88-974f-db07-b1ecdc94392b@gmail.com>
Date:   Wed, 15 May 2019 11:49:26 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:52.0)
 Gecko/20100101 Thunderbird/52.9.1
MIME-Version: 1.0
In-Reply-To: <CAEA6p_ATUB_tXY12FFFnw0HFAdJzo0VVsdBzN_AL4KGVc9gVVw@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 5/15/19 11:45 AM, Wei Wang wrote:
>>
>> you have to pass in a device. The first line in ip6_del_cached_rt:
>>
>> if (cfg->fc_ifindex && rt->dst.dev->ifindex != cfg->fc_ifindex)
>>                 goto out;
>>
>> 'ip route get' is one way to check if it has been deleted. We really
>> need to add support for dumping exception routes.
> 
> Without passing in dev, fc_ifindex = 0. So it won't goto out. Isn't it?

ugh, yes, blew right past that.

> The way I checked if the route cache is being removed is by doing:
> ip netns exec a cat /proc/net/rt6_stats
> The 5th counter is the number of cached routes right now in the system.
> 
> The output I get after I run the reproducer:
> # ip netns exec a cat /proc/net/rt6_stats
> 000b 0006 000e 0006 0001 0005 0000
> # ip netns exec a ./ip -6 route del fd01::c from fd00::/64 cache
> # ip netns exec a cat /proc/net/rt6_stats
> 000b 0006 0012 0006 0000 0004 0000
> 
> The same behavior if I pass in dev:
> # ip netns exec a cat /proc/net/rt6_stats
> 000b 0006 000c 0006 0001 0004 0000
> # ip netns exec a ./ip -6 route del fd01::c from fd00::/64 dev vethab cache
> # ip netns exec a cat /proc/net/rt6_stats
> 000b 0006 0013 0006 0000 0003 0000
> 

ok.

Reviewed-by: David Ahern <dsahern@gmail.com>

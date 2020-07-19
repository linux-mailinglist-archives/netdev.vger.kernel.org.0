Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 34BF322538D
	for <lists+netdev@lfdr.de>; Sun, 19 Jul 2020 20:44:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726307AbgGSSoA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 19 Jul 2020 14:44:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43346 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726009AbgGSSn7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 19 Jul 2020 14:43:59 -0400
Received: from mail-qt1-x841.google.com (mail-qt1-x841.google.com [IPv6:2607:f8b0:4864:20::841])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 62521C0619D2
        for <netdev@vger.kernel.org>; Sun, 19 Jul 2020 11:43:59 -0700 (PDT)
Received: by mail-qt1-x841.google.com with SMTP id b25so11462358qto.2
        for <netdev@vger.kernel.org>; Sun, 19 Jul 2020 11:43:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=04XRmeVR+BdbT3nlu1OUFjNjxD2J0RnUq57VtRjRDNg=;
        b=hc2/O8Qw0zMFdnVIVhgicHfawzD/JKkYY4T13FUot7RPZEn/bwQjh13LcNxXicjloo
         MDKXCS9taRvYmLkQa7Hl6GGVFAHYFwRnrndwIF2VDdvr5hgdS727oYOfVlK5rfoy+5nM
         tyPfqaW0xCPFzsGrTPPBOXRFEkXEJqEQ84JZo/fhdWVcyO0PwQyoWWf2zz3mIlq9jNln
         hh4oPS6zkbiHwF4Y0kUYg8P3M4EjvdFUMasHXMvLVq+s7tb6C9s0lGE7p42qHW6UiVah
         NzmBjKJ2NQIzJ/GAjomJVHZdgmbx4Zadh9TGl3oHHr0hE5ZBK0JLnYzxuJMTTZJN2IvH
         8pog==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=04XRmeVR+BdbT3nlu1OUFjNjxD2J0RnUq57VtRjRDNg=;
        b=K06aDKBv7HCaMa+JzdzzIT7uCwkVXOkykiD32jXkKabibXQhlFDELYr1zG4ap5A+RV
         yX+nm8XXUs3+7Pg3+LEZsMCTFQgetWBa443GN+DePQKKD4z9FPrezDI6uSHRv7WYopy2
         MUglIV+VeL5N7jwSVUlhIRmYlIYuZXYRNdTixVJlzFidXkcTESYIqa0e7VetQjyF2LjK
         v5+0IktNFTm8z3n4F5Nyh+6hVB8eChcLLH0b+coBiEvrBxWFc4QAfTTH9qYtBUY/Puo/
         S9SJK/e8uCj/tkEAVkd4anvuwJ3bXJN77TW5jj9p2pLCIBoyJgYk9TghDt4gGWxZu7eH
         wGkw==
X-Gm-Message-State: AOAM532bya+Uh0FzHWjpYr8iNey3wC3hBPUFU/IOeFlb9V3f1LV4/8er
        gJLOMzDGptb5/NyB7JQOIXtuTqJu
X-Google-Smtp-Source: ABdhPJwudQdlLNtrhgfvz2CAIAG7J7/Dxw6HaPu+PC9l3EIsFteTwAfOlit+xd5f/tk26APwFDRwSQ==
X-Received: by 2002:ac8:173b:: with SMTP id w56mr20432944qtj.218.1595184238320;
        Sun, 19 Jul 2020 11:43:58 -0700 (PDT)
Received: from ?IPv6:2601:282:803:7700:247a:2d5a:19c4:a32f? ([2601:282:803:7700:247a:2d5a:19c4:a32f])
        by smtp.googlemail.com with ESMTPSA id e129sm16141078qkf.132.2020.07.19.11.43.56
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 19 Jul 2020 11:43:57 -0700 (PDT)
Subject: Re: [PATCH net-next 1/3] udp_tunnel: allow to turn off path mtu
 discovery on encap sockets
To:     Stefano Brivio <sbrivio@redhat.com>
Cc:     Florian Westphal <fw@strlen.de>, netdev@vger.kernel.org,
        aconole@redhat.com
References: <20200712200705.9796-1-fw@strlen.de>
 <20200712200705.9796-2-fw@strlen.de> <20200713003813.01f2d5d3@elisabeth>
 <20200713080413.GL32005@breakpoint.cc>
 <b61d3e1f-02b3-ac80-4b9a-851871f7cdaa@gmail.com>
 <20200713140219.GM32005@breakpoint.cc> <20200714143327.2d5b8581@redhat.com>
 <20200715124258.GP32005@breakpoint.cc> <20200715153547.77dbaf82@elisabeth>
 <20200715143356.GQ32005@breakpoint.cc> <20200717142743.6d05d3ae@elisabeth>
 <89e5ec7b-845f-ab23-5043-73e797a29a14@gmail.com>
 <20200718085645.7420da02@elisabeth>
 <9e47f521-b3dc-f116-658b-d6897b0ddf20@gmail.com>
 <20200718195850.61104dd2@elisabeth>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <dda364c6-3ac8-31a8-23b5-c337042b7d5d@gmail.com>
Date:   Sun, 19 Jul 2020 12:43:55 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20200718195850.61104dd2@elisabeth>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 7/18/20 11:58 AM, Stefano Brivio wrote:
> On Sat, 18 Jul 2020 11:02:46 -0600
> David Ahern <dsahern@gmail.com> wrote:
> 
>> On 7/18/20 12:56 AM, Stefano Brivio wrote:
>>> On Fri, 17 Jul 2020 09:04:51 -0600
>>> David Ahern <dsahern@gmail.com> wrote:
>>>   
>>>> On 7/17/20 6:27 AM, Stefano Brivio wrote:  
>>>>>>    
>>>>>>> Note that this doesn't work as it is because of a number of reasons
>>>>>>> (skb doesn't have a dst, pkt_type is not PACKET_HOST), and perhaps we
>>>>>>> shouldn't be using icmp_send(), but at a glance that looks simpler.      
>>>>>>
>>>>>> Yes, it also requires that the bridge has IP connectivity
>>>>>> to reach the inner ip, which might not be the case.    
>>>>>
>>>>> If the VXLAN endpoint is a port of the bridge, that needs to be the
>>>>> case, right? Otherwise the VXLAN endpoint can't be reached.
>>>>>     
>>>>>>> Another slight preference I have towards this idea is that the only
>>>>>>> known way we can break PMTU discovery right now is by using a bridge,
>>>>>>> so fixing the problem there looks more future-proof than addressing any
>>>>>>> kind of tunnel with this problem. I think FoU and GUE would hit the
>>>>>>> same problem, I don't know about IP tunnels, sticking that selftest
>>>>>>> snippet to whatever other test in pmtu.sh should tell.      
>>>>>>
>>>>>> Every type of bridge port that needs to add additional header on egress
>>>>>> has this problem in the bridge scenario once the peer of the IP tunnel
>>>>>> signals a PMTU event.    
>>>>>
>>>>> Yes :(  
>>>>
>>>> The vxlan/tunnel device knows it is a bridge port, and it knows it is
>>>> going to push a udp and ip{v6} header. So why not use that information
>>>> in setting / updating the MTU? That's what I was getting at on Monday
>>>> with my comment about lwtunnel_headroom equivalent.  
>>>
>>> If I understand correctly, you're proposing something similar to my
>>> earlier draft from:
>>>
>>> 	<20200713003813.01f2d5d3@elisabeth>
>>> 	https://lore.kernel.org/netdev/20200713003813.01f2d5d3@elisabeth/
>>>
>>> the problem with it is that it wouldn't help: the MTU is already set to
>>> the right value for both port and bridge in the case Florian originally
>>> reported.  
>>
>> I am definitely hand waving; I have not had time to create a setup
>> showing the problem. Is there a reproducer using only namespaces?
> 
> And I'm laser pointing: check the bottom of that email ;)
> 

With this test case, the lookup fails:

[  144.689378] vxlan: vxlan_xmit_one: dev vxlan_a 10.0.1.1/57864 ->
10.0.0.0/4789 len 5010 gw 10.0.1.2
[  144.692755] vxlan: skb_tunnel_check_pmtu: dst dev br0 skb dev vxlan_a
skb len 5010 encap_mtu 4000 headroom 50
[  144.697682] vxlan: skb_dst_update_pmtu_no_confirm: calling
ip_rt_update_pmtu+0x0/0x160/ffffffff825ee850 for dev br0 mtu 3950
[  144.703601] IPv4: __ip_rt_update_pmtu: dev br0 mtu 3950 old_mtu 5000
192.168.2.1 -> 192.168.2.2
[  144.708177] IPv4: __ip_rt_update_pmtu: fib_lookup failed for
192.168.2.1 -> 192.168.2.2

Because the lookup fails, __ip_rt_update_pmtu skips creating the exception.

This hack gets the lookup to succeed:

fl4->flowi4_oif = dst->dev->ifindex;
or
fl4->flowi4_oif = 0;

and the test passes.


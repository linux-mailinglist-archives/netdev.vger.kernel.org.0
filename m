Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 952C2224D38
	for <lists+netdev@lfdr.de>; Sat, 18 Jul 2020 19:03:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726798AbgGRRCu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 18 Jul 2020 13:02:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34274 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726604AbgGRRCu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 18 Jul 2020 13:02:50 -0400
Received: from mail-qk1-x743.google.com (mail-qk1-x743.google.com [IPv6:2607:f8b0:4864:20::743])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 268BFC0619D2
        for <netdev@vger.kernel.org>; Sat, 18 Jul 2020 10:02:50 -0700 (PDT)
Received: by mail-qk1-x743.google.com with SMTP id b185so11620837qkg.1
        for <netdev@vger.kernel.org>; Sat, 18 Jul 2020 10:02:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=09wA+GGfZg7jRw4tYhn2ifyWoRW2GDPu42oIB0KGqIw=;
        b=QhxWqgfP6vfcGtyzTMmeAseTurbDLASvv6vCzfI59tU75N25Nn9r6TpjCxO7flExDB
         QrLRSyvzyONLIKEOPZLvr/xLXfFa6+hz2ZsRH9N3HVMX5gOplQRJrMQUy/ZgM73mL4QZ
         9Dosxro1Q/Ec8F1mSYvX4EMl1pJ+oT7ceQ1MFZge0yOmejAKLqAe5wbpKyzc+cmWl7KL
         mO//w+qwQl63moMKv7Ga3BZh3daK4NW/MXF2RulJFv2YI3CYtKvJDhKRntoc2n/Kp+ct
         zVnPy4CFXDGey15vl9eC0BrlINFrkvcmWTRUEtGIUUmh61H0WU/35LCom7eDfP6H6smA
         tK4A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=09wA+GGfZg7jRw4tYhn2ifyWoRW2GDPu42oIB0KGqIw=;
        b=G0LU+ygEDx9w6T07EGVHPtK51/xCvr3bJgvetThbSc7nXQTNeCypFigk1degrxkbUM
         NqXhw5zdJTOkUItJWBb7ck3XFLFMyJlX93CBEMvOYdGE0BWEtmFw/R2qJRlAFtAjYzWr
         maG+/CJ/EWCp4uLIf+KBUx3pCFOitxrXzbCKxQEHM2ttUXVwmD13JAG4AsoOEQQei5lZ
         mEYWfJFS0SmNTnWvaeyoziskQI7Ofk/8vY/RJxBEzvYVHwv+3Y3Sk8EGHhWxm+so+alW
         xDYLOOjsPJ4fcGtiRZZHrHTKL+rrvmBmYmKiUgAgpnJlfeOi01KCfnoDiX4xfRJjFmVC
         gMzA==
X-Gm-Message-State: AOAM53326+ExhfWckewBmuQCSzyDHDwIRgP0ae94+tjCTXgul3p/UQrD
        4z4agv8gmH1UQ6zT1+QYdnM=
X-Google-Smtp-Source: ABdhPJxclBSKzY19F/jbnO3f5Hubq0scCu/5m5HFFmXMtcsDRLe8DodrjIi2fJK6KDuhhpXdcsNX2A==
X-Received: by 2002:a05:620a:15f4:: with SMTP id p20mr13443318qkm.377.1595091769194;
        Sat, 18 Jul 2020 10:02:49 -0700 (PDT)
Received: from ?IPv6:2601:282:803:7700:a04e:6ffa:adfd:b8f? ([2601:282:803:7700:a04e:6ffa:adfd:b8f])
        by smtp.googlemail.com with ESMTPSA id o12sm13929901qtl.48.2020.07.18.10.02.47
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 18 Jul 2020 10:02:47 -0700 (PDT)
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
From:   David Ahern <dsahern@gmail.com>
Message-ID: <9e47f521-b3dc-f116-658b-d6897b0ddf20@gmail.com>
Date:   Sat, 18 Jul 2020 11:02:46 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20200718085645.7420da02@elisabeth>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 7/18/20 12:56 AM, Stefano Brivio wrote:
> On Fri, 17 Jul 2020 09:04:51 -0600
> David Ahern <dsahern@gmail.com> wrote:
> 
>> On 7/17/20 6:27 AM, Stefano Brivio wrote:
>>>>  
>>>>> Note that this doesn't work as it is because of a number of reasons
>>>>> (skb doesn't have a dst, pkt_type is not PACKET_HOST), and perhaps we
>>>>> shouldn't be using icmp_send(), but at a glance that looks simpler.    
>>>>
>>>> Yes, it also requires that the bridge has IP connectivity
>>>> to reach the inner ip, which might not be the case.  
>>>
>>> If the VXLAN endpoint is a port of the bridge, that needs to be the
>>> case, right? Otherwise the VXLAN endpoint can't be reached.
>>>   
>>>>> Another slight preference I have towards this idea is that the only
>>>>> known way we can break PMTU discovery right now is by using a bridge,
>>>>> so fixing the problem there looks more future-proof than addressing any
>>>>> kind of tunnel with this problem. I think FoU and GUE would hit the
>>>>> same problem, I don't know about IP tunnels, sticking that selftest
>>>>> snippet to whatever other test in pmtu.sh should tell.    
>>>>
>>>> Every type of bridge port that needs to add additional header on egress
>>>> has this problem in the bridge scenario once the peer of the IP tunnel
>>>> signals a PMTU event.  
>>>
>>> Yes :(
>>
>> The vxlan/tunnel device knows it is a bridge port, and it knows it is
>> going to push a udp and ip{v6} header. So why not use that information
>> in setting / updating the MTU? That's what I was getting at on Monday
>> with my comment about lwtunnel_headroom equivalent.
> 
> If I understand correctly, you're proposing something similar to my
> earlier draft from:
> 
> 	<20200713003813.01f2d5d3@elisabeth>
> 	https://lore.kernel.org/netdev/20200713003813.01f2d5d3@elisabeth/
> 
> the problem with it is that it wouldn't help: the MTU is already set to
> the right value for both port and bridge in the case Florian originally
> reported.

I am definitely hand waving; I have not had time to create a setup
showing the problem. Is there a reproducer using only namespaces?

> 
> Also, given the implications on overriding configured MTUs, and
> introducing (further) IP logic into the bridge, if Florian's idea of
> injecting ICMP messages could be implemented in a generic function:
> 
> On Wed, 15 Jul 2020 16:33:56 +0200
> Florian Westphal <fw@strlen.de> wrote:
> 
>> Yes, it might be possible to move the proposed icmp inject into
>> skb_tunnel_check_pmtu() -- it gets the needed headroom passed as arg,
>> it could detect when device driver is in a bridge and it already knows
>> when skb has no dst entry that it a pmtu change could be propagated to.
> 
> I think that would be preferable: then it's fixed for all tunnels in a
> generic, probably simpler way, without those two issues.
> 
> But then again, we're talking about Linux bridge. Unfortunately this
> doesn't fix the problem with Open vSwitch either.
> 

Of course. (insert sarcastic jab at ovs here)

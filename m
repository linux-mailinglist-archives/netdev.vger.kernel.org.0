Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 970DA3F9650
	for <lists+netdev@lfdr.de>; Fri, 27 Aug 2021 10:38:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244611AbhH0Ija (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 Aug 2021 04:39:30 -0400
Received: from serv108.segi.ulg.ac.be ([139.165.32.111]:47824 "EHLO
        serv108.segi.ulg.ac.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244471AbhH0Ij3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 27 Aug 2021 04:39:29 -0400
Received: from mbx12-zne.ulg.ac.be (serv470.segi.ulg.ac.be [139.165.32.199])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by serv108.segi.ulg.ac.be (Postfix) with ESMTPS id C32F22012360;
        Fri, 27 Aug 2021 10:38:39 +0200 (CEST)
DKIM-Filter: OpenDKIM Filter v2.11.0 serv108.segi.ulg.ac.be C32F22012360
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=uliege.be;
        s=ulg20190529; t=1630053519;
        bh=gRgb45gMgJUo9iQLm6RA2KmCyzGXCETltlUYqG3K/Zw=;
        h=Date:From:Reply-To:To:Cc:In-Reply-To:References:Subject:From;
        b=0A1a8raOoUpSXvCotzJfQsfCdwC9unQxg/Kr6224kF6zR5lrpmDpGXoT1130pfG6z
         BHQkNsQKtuO6uxJ6mt67Vp5bKZWgYX0pHw3c26R2GYuHEVWUafneb0Zz9J/Qjc0Xkb
         ima6hhqQwK3+wFV0k170q475yMr/Wgn1b1CS3ULY8zksnOEstRYLXizX8BSddxiF/n
         qww5kBG5JhrNQhr8VaRjoKqkjexRgF5MFrjlqjUGm/8HGKyFC/K3ldmYg9HxPGKsSl
         gFMYJYFLruQSz53janC45F4uhOzEGnh85MbZJdRZqDvbMIwXUYqr4qqv6zBsl5mTxj
         rOApizBufUvZw==
Received: from localhost (localhost [127.0.0.1])
        by mbx12-zne.ulg.ac.be (Postfix) with ESMTP id B89846008D859;
        Fri, 27 Aug 2021 10:38:39 +0200 (CEST)
Received: from mbx12-zne.ulg.ac.be ([127.0.0.1])
        by localhost (mbx12-zne.ulg.ac.be [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id zDLpI6YfQgZW; Fri, 27 Aug 2021 10:38:39 +0200 (CEST)
Received: from mbx12-zne.ulg.ac.be (mbx12-zne.ulg.ac.be [139.165.32.199])
        by mbx12-zne.ulg.ac.be (Postfix) with ESMTP id 9F3026008664E;
        Fri, 27 Aug 2021 10:38:39 +0200 (CEST)
Date:   Fri, 27 Aug 2021 10:38:39 +0200 (CEST)
From:   Justin Iurman <justin.iurman@uliege.be>
Reply-To: Justin Iurman <justin.iurman@uliege.be>
To:     nicolas dichtel <nicolas.dichtel@6wind.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        yoshfuji@linux-ipv6.org, dsahern@kernel.org, tom@herbertland.com,
        edumazet@google.com
Message-ID: <406785024.54460986.1630053519604.JavaMail.zimbra@uliege.be>
In-Reply-To: <63ec6555-77f8-d241-80d5-a40bc4561d75@6wind.com>
References: <20210826140150.19920-1-justin.iurman@uliege.be> <fd41d544-31f0-8e60-a301-eb4f4e323a5b@6wind.com> <1977792481.53611744.1629994989620.JavaMail.zimbra@uliege.be> <76c2a8bf-e8c8-7402-ba20-a493fbf7c0e4@6wind.com> <324963792.54305318.1630050698741.JavaMail.zimbra@uliege.be> <63ec6555-77f8-d241-80d5-a40bc4561d75@6wind.com>
Subject: Re: [RFC net-next] ipv6: Support for anonymous tunnel decapsulation
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.22.52.207]
X-Mailer: Zimbra 8.8.15_GA_4018 (ZimbraWebClient - FF91 (Linux)/8.8.15_GA_4026)
Thread-Topic: ipv6: Support for anonymous tunnel decapsulation
Thread-Index: ybDXTj7fVqMHj8MJgMljbVlSd5ac2w==
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

>>> [snip]
>>>
>>>>>> Thoughts?
>>>>> I'm not sure to understand why the current code isn't enough. The fallback
>>>>> tunnels created by legacy IP tunnels drivers are able to receive and decapsulate
>>>>> any encapsulated packets.
>>>>
>>>> Because, right now, you need to use the ip6_tunnel module and explicitly
>>>> configure a tunnel, as you described below. The goal of this patch is to
>>>> provide a way to apply an ip6ip6 decapsulation *without* having to configure a
>>>> tunnel.
>>>
>>> What is the difference between setting a sysctl somewhere and putting an
>>> interface up?
>> 
>> Well, correct me if I'm wrong but, it's more than just putting an interface up.
>> You'd first need ip6_tunnel (and so tunnel6) module loaded, but you'd also need
>> to configure a tunnel on the decap node.
> No, you just need to have the module. The fallback device is automatically
> created. And if the module is built-in, there is nothing to do.
> 
> Indeed, the current ip6_tunnel fallback handler only works if a tunnel matches
> the packet (i.e., ipxip6_rcv will return -1 since ip6_tnl_lookup will return
> NULL, leading to *no* decapsulation from this handler).
> No. ip6_tnl_lookup() won't return NULL if the fallback device exists and is up.
> https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tree/net/ipv6/ip6_tunnel.c#n168

My bad, I missed the condition at the end and didn't test it. Indeed, you're correct.

> The tunnels lookup algorithm has several steps:
> - try to match local and remote addr
> - try to match only local addr
> - try to match only dst addr
> - return the lwt tunnel if it exists
> - return the fallback device if it exists and is up
> 
> https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tree/net/ipv6/ip6_tunnel.c#n100
> https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tree/net/ipv6/sit.c#n96
> https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tree/net/ipv4/ip_tunnel.c#n72
> 
>> 
>> So, again, think about the case where you have lots of ingresses and egresses
>> that should be linked (= a tunnel for each pair) altogether in a domain. You'd
>> need to configure N tunnels on the decap node, where N is the number of
>> ingresses. Well, actually no, you could just configure one tunnel with "remote
>> any", but you'd still depend on the ip6_tunnel module and play with tunnel
>> configuration and its interface. This patch provides a way to avoid that by
>> just enabling the ip6ip6 decapsulation through a per interface sysctl.
>> 
> I don't understand the problem of depending to the ip6_tunnel module.
> Duplicating a subset of the existing code to avoid a dependency to an existing
> module seems a bad idea for me, from a maintenance point of view.

Totally agree, I know this is usually not ideal, especially now that I know ip6_tunnel can already do the job without tunnel configurations. The only "downside" is that you need the ip6_tunnel module but that's fine. Thanks for the feedback and clarification.

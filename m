Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 816C4225621
	for <lists+netdev@lfdr.de>; Mon, 20 Jul 2020 05:21:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726884AbgGTDTr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 19 Jul 2020 23:19:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37182 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726612AbgGTDTq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 19 Jul 2020 23:19:46 -0400
Received: from mail-oi1-x244.google.com (mail-oi1-x244.google.com [IPv6:2607:f8b0:4864:20::244])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B30B3C0619D2
        for <netdev@vger.kernel.org>; Sun, 19 Jul 2020 20:19:46 -0700 (PDT)
Received: by mail-oi1-x244.google.com with SMTP id k4so13340200oik.2
        for <netdev@vger.kernel.org>; Sun, 19 Jul 2020 20:19:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=xuXi1HwM5wNb5pHWmtkSLWOotfjXgcfGZjnmTCrCUsE=;
        b=ZyCffuuiKEejFd7Wk3sZJ70bkSvJdLCkgmDosXgdSiLd6cl1GeqgPXqDsRM5J2myXT
         tEjDPU6mXlg6WHeuSlS0nOR5URyjrZIMLJ4+FQhzxvvhbHEwRvS4Z7zso7w1MQqsW0cX
         jb32PYDFfkr/MtISjG2qG3vszR/JQTe5wTUmhlpL/23QXwkrteGvu5fWQJhP0IJfAfAg
         OfvKysSzq8rK/aUv4MV61TLGQ6jVimV4T709bbcOjK0PygYlJT6q5EYOXzgThuypitBj
         DQ4kay1NboeerEqkF3s2p061hFcc8eJGe43hvrrqoWonJmO7J46zqD8fXXGBbtG6lhZo
         C4oQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=xuXi1HwM5wNb5pHWmtkSLWOotfjXgcfGZjnmTCrCUsE=;
        b=IHBqxEVcDyH5Sc+prm1nAaNCZa2LX8o8bRGnZlb5ZsLJ4hDKZRRKNlL6R300xypEjB
         w819QgLv9dIiQzAXAd+E1HRbrSDn9/eZaMbwpJ4Tw57aJDCjAm21hlDqB1u6/gEQBSJg
         GqSPAd9vbQ0I0fOjlKoDWt0prJZY6U6AJjpigKxf1ALHpJiCWmmlW6DQdA6zgMfoL2wR
         d1zMgNWHhDbOc07xONR6inz4abyoeNA4ondL2jKGj8xW5Jq4qnCU8kIVVjoDW8EOlI6J
         favDpbWYLQJzLqY2hHZr5s1defgTMzvfSX3ZI4SoQey3jI39Y6McpAO4P3TSmZ0cTyWC
         vIqQ==
X-Gm-Message-State: AOAM531lG2LqeQJUyuQdG/e6lFbRH51XSLhPsJdIAMwfqsOHTvtMcNUf
        waOg9sClguCATsPrLCVO75c=
X-Google-Smtp-Source: ABdhPJzYLoi35ZdPDb6qoYVrKI5PxNMrb8+Gg/ulPzLG1CQSHmYs27ZhVosk2U7H2BlcoJmtkSE9Kw==
X-Received: by 2002:a54:480c:: with SMTP id j12mr16897210oij.85.1595215186075;
        Sun, 19 Jul 2020 20:19:46 -0700 (PDT)
Received: from ?IPv6:2601:282:803:7700:247a:2d5a:19c4:a32f? ([2601:282:803:7700:247a:2d5a:19c4:a32f])
        by smtp.googlemail.com with ESMTPSA id y67sm3867398oig.46.2020.07.19.20.19.45
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 19 Jul 2020 20:19:45 -0700 (PDT)
Subject: Re: [PATCH net-next 1/3] udp_tunnel: allow to turn off path mtu
 discovery on encap sockets
To:     Stefano Brivio <sbrivio@redhat.com>,
        Florian Westphal <fw@strlen.de>
Cc:     netdev@vger.kernel.org, aconole@redhat.com
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
 <dda364c6-3ac8-31a8-23b5-c337042b7d5d@gmail.com>
 <20200719234940.37adebe7@elisabeth>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <5d5deb1f-0a7f-1519-4716-6a92aec40bd2@gmail.com>
Date:   Sun, 19 Jul 2020 21:19:44 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20200719234940.37adebe7@elisabeth>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 7/19/20 3:49 PM, Stefano Brivio wrote:
>>
>> With this test case, the lookup fails:
>>
>> [  144.689378] vxlan: vxlan_xmit_one: dev vxlan_a 10.0.1.1/57864 ->
>> 10.0.0.0/4789 len 5010 gw 10.0.1.2
>> [  144.692755] vxlan: skb_tunnel_check_pmtu: dst dev br0 skb dev vxlan_a
>> skb len 5010 encap_mtu 4000 headroom 50
>> [  144.697682] vxlan: skb_dst_update_pmtu_no_confirm: calling
>> ip_rt_update_pmtu+0x0/0x160/ffffffff825ee850 for dev br0 mtu 3950
>> [  144.703601] IPv4: __ip_rt_update_pmtu: dev br0 mtu 3950 old_mtu 5000
>> 192.168.2.1 -> 192.168.2.2
>> [  144.708177] IPv4: __ip_rt_update_pmtu: fib_lookup failed for
>> 192.168.2.1 -> 192.168.2.2
>>
>> Because the lookup fails, __ip_rt_update_pmtu skips creating the exception.
>>
>> This hack gets the lookup to succeed:
>>
>> fl4->flowi4_oif = dst->dev->ifindex;
>> or
>> fl4->flowi4_oif = 0;
> 
> Oh, I didn't consider that... route. :) Here comes an added twist, which
> currently needs Florian's changes from:
> 	https://git.breakpoint.cc/cgit/fw/net-next.git/log/?h=udp_tun_pmtud_12
> 
> Test is as follows:
> 
> test_pmtu_ipv4_vxlan4_exception_bridge() {
> 	test_pmtu_ipvX_over_vxlanY_or_geneveY_exception vxlan  4 4
> 
> 	ip netns add ns-C
> 
> 	ip -n ns-C link add veth_c_a type veth peer name veth_a_c
> 	ip -n ns-C link set veth_a_c netns ns-A
> 
> 	ip -n ns-C addr add 192.168.2.100/24 dev veth_c
> 
> 	ip -n ns-C link set dev veth_c_a mtu 5000
> 	ip -n ns-C link set veth_c_a up
> 	ip -n ns-A link set dev veth_a_c mtu 5000
> 	ip -n ns-A link set veth_c_a up
> 
> 	ip -n ns-A link add br0 type bridge
> 	ip -n ns-A link set br0 up
> 	ip -n ns-A link set dev br0 mtu 5000
> 	ip -n ns-A link set veth_a_c master br0
> 	ip -n ns-A link set vxlan_a master br0
> 
> 	ip -n ns-A addr del 192.168.2.1/24 dev vxlan_a
> 	ip -n ns-A addr add 192.168.2.1/24 dev br0
> 
> 	ip -n ns-C exec ping -c 1 -w 2 -M want -s 5000 192.168.2.2
> }
> 
> I didn't check the test itself recently, I'm just copying from some
> local changes I was trying last week, some commands might be wrong.

I fixed the exec typo, but yes even with my flowi4_oif hack it fails.

> 
> The idea is: what if we now have another host (here, it's ns-C) sending
> traffic to that bridge? Then the exception on a local interface isn't
> enough, we actually need to send Fragmentation Needed back to where the
> packet came from, and the bridge won't do it for us (with routing, it
> already works).
> 
> I haven't tried your hack, but I guess it would have the same problem.
> 

What I saw in my tests and debug statements is that vxlan xmit does
compensate for the tunnel overhead (e.g., skb_tunnel_check_pmtu in
vxlan_xmit_one). It still feels like there are some minor details that
are wrong - like the fib_lookup failing when called from the
vxlan_xmit_one path. Does finding and fixing those make it work vs
adding another config item? I can send my debug diff if it helps.


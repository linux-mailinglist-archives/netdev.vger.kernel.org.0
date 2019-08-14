Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 984258D8A1
	for <lists+netdev@lfdr.de>; Wed, 14 Aug 2019 18:59:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728487AbfHNQ7I (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Aug 2019 12:59:08 -0400
Received: from mail-lf1-f65.google.com ([209.85.167.65]:34643 "EHLO
        mail-lf1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726265AbfHNQ7I (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 14 Aug 2019 12:59:08 -0400
Received: by mail-lf1-f65.google.com with SMTP id b29so72594725lfq.1
        for <netdev@vger.kernel.org>; Wed, 14 Aug 2019 09:59:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cumulusnetworks.com; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=VGdioYFZQ1Fks4VK1hOXuOtR5kZxo6UuT8R67fuGKm4=;
        b=gGknORqE3jxueXwmM5EeG+nRTzy9mTMsGDvQa58wcGCyUVosolpQHXyzFEImqwUxw6
         bokhsRNaor6MJTj/dNDJ5xAsEBDYF6ZYRLjePkf9BMqDk5+z8vVH2nRe7EWfrjfC+eFO
         MT75L4GV0/BjB4KiChN+s1kTokHcm0zYs+r8M=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=VGdioYFZQ1Fks4VK1hOXuOtR5kZxo6UuT8R67fuGKm4=;
        b=HSySsMxWPAvNL8YTs3uhY8tJnje+FPLsm9vbFD4O/XrQ55E/hcXUx0qON+qAs8SNAG
         WqhIcz5VtqUR/ptEHaa3SdXMwHcykTbntsWBziOO9e2qCIb6f/poDlp9oRYpJhTY3vRf
         ippPjVnk89Ydrph+pPc1taawJ/XOnQCn17UkQSPSBYL6DspgBmsAHDodbSQN3xNJT2pX
         8qoSZj5g89q1HyPKOKBwRcwYv1sV/6PKf26ynXA7v2/oQrj1v4psDeqT08wE7TLqPYg0
         2iz6I0/CygUgF+oOJjkFSJFWON8Ex9b1mzG3f40k9t+6jt+VxOIvttPIIEx2nPIjCQha
         ntRg==
X-Gm-Message-State: APjAAAV7JAscqqGvyX52sfqGK3DqGDErpS6vERPEBj7gWTuk2DEbUOex
        JEpbp2IaLGd2O+RmLfmlENXwB6k+nLE=
X-Google-Smtp-Source: APXvYqxWkLsVKeKtSgMGc791uOYhCpFEAwWRZixyfOdLeCnQhadg/whu9e7AFTLlgolqHEcd9y0izw==
X-Received: by 2002:a19:c213:: with SMTP id l19mr190450lfc.83.1565801945712;
        Wed, 14 Aug 2019 09:59:05 -0700 (PDT)
Received: from [192.168.0.104] ([79.134.174.40])
        by smtp.googlemail.com with ESMTPSA id t137sm20803lff.78.2019.08.14.09.59.04
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 14 Aug 2019 09:59:05 -0700 (PDT)
Subject: Re: [PATCH net-next] mcast: ensure L-L IPv6 packets are accepted by
 bridge
To:     pruddy@vyatta.att-mail.com, Ido Schimmel <idosch@idosch.org>
Cc:     netdev@vger.kernel.org, roopa@cumulusnetworks.com,
        linus.luessing@c0d3.blue
References: <20190813141804.20515-1-pruddy@vyatta.att-mail.com>
 <20190813195341.GA27005@splinter>
 <43ed59db-9228-9132-b9a5-31c8d1e8e9e9@cumulusnetworks.com>
 <620d3cfbe58e3ae87ef1d5e7f2aa1588cac3e64a.camel@vyatta.att-mail.com>
From:   Nikolay Aleksandrov <nikolay@cumulusnetworks.com>
Message-ID: <9b921135-3447-15b1-8241-3f10693b6e85@cumulusnetworks.com>
Date:   Wed, 14 Aug 2019 19:58:57 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <620d3cfbe58e3ae87ef1d5e7f2aa1588cac3e64a.camel@vyatta.att-mail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 8/14/19 7:40 PM, Patrick Ruddy wrote:
> Thanks both for the quick replies, answers inline...
> 
> On Wed, 2019-08-14 at 02:55 +0300, Nikolay Aleksandrov wrote:
>> On 8/13/19 10:53 PM, Ido Schimmel wrote:
>>> + Bridge maintainers, Linus
>>>
>>
>> Good catch Ido, thanks!
>> First I'd say the subject needs to reflect that this is a bridge change
>> better, please rearrange it like so - bridge: mcast: ...
>> More below,
>>
>>> On Tue, Aug 13, 2019 at 03:18:04PM +0100, Patrick Ruddy wrote:
>>>> At present only all-nodes IPv6 multicast packets are accepted by
>>>> a bridge interface that is not in multicast router mode. Since
>>>> other protocols can be running in the absense of multicast
>>>> forwarding e.g. OSPFv3 IPv6 ND. Change the test to allow
>>>> all of the FFx2::/16 range to be accepted when not in multicast
>>>> router mode. This aligns the code with IPv4 link-local reception
>>>> and RFC4291
>>>
>>> Can you please quote the relevant part from RFC 4291?
>>>
>>>> Signed-off-by: Patrick Ruddy <pruddy@vyatta.att-mail.com>
>>>> ---
>>>>  include/net/addrconf.h    | 15 +++++++++++++++
>>>>  net/bridge/br_multicast.c |  2 +-
>>>>  2 files changed, 16 insertions(+), 1 deletion(-)
>>>>
>>>> diff --git a/include/net/addrconf.h b/include/net/addrconf.h
>>>> index becdad576859..05b42867e969 100644
>>>> --- a/include/net/addrconf.h
>>>> +++ b/include/net/addrconf.h
>>>> @@ -434,6 +434,21 @@ static inline void addrconf_addr_solict_mult(const struct in6_addr *addr,
>>>>  		      htonl(0xFF000000) | addr->s6_addr32[3]);
>>>>  }
>>>>  
>>>> +/*
>>>> + *      link local multicast address range ffx2::/16 rfc4291
>>>> + */
>>>> +static inline bool ipv6_addr_is_ll_mcast(const struct in6_addr *addr)
>>>> +{
>>>> +#if defined(CONFIG_HAVE_EFFICIENT_UNALIGNED_ACCESS) && BITS_PER_LONG == 64
>>>> +	__be64 *p = (__be64 *)addr;
>>>> +	return ((p[0] & cpu_to_be64(0xff0f000000000000UL))
>>>> +		^ cpu_to_be64(0xff02000000000000UL)) == 0UL;
>>>> +#else
>>>> +	return ((addr->s6_addr32[0] & htonl(0xff0f0000)) ^
>>>> +		htonl(0xff020000)) == 0;
>>>> +#endif
>>>> +}
>>>> +
>>>>  static inline bool ipv6_addr_is_ll_all_nodes(const struct in6_addr *addr)
>>>>  {
>>>>  #if defined(CONFIG_HAVE_EFFICIENT_UNALIGNED_ACCESS) && BITS_PER_LONG == 64
>>>> diff --git a/net/bridge/br_multicast.c b/net/bridge/br_multicast.c
>>>> index 9b379e110129..ed3957381fa2 100644
>>>> --- a/net/bridge/br_multicast.c
>>>> +++ b/net/bridge/br_multicast.c
>>>> @@ -1664,7 +1664,7 @@ static int br_multicast_ipv6_rcv(struct net_bridge *br,
>>>>  	err = ipv6_mc_check_mld(skb);
>>>>  
>>>>  	if (err == -ENOMSG) {
>>>> -		if (!ipv6_addr_is_ll_all_nodes(&ipv6_hdr(skb)->daddr))
>>>> +		if (!ipv6_addr_is_ll_mcast(&ipv6_hdr(skb)->daddr))
>>>>  			BR_INPUT_SKB_CB(skb)->mrouters_only = 1;
>>>
>>> IIUC, you want IPv6 link-local packets to be locally received, but this
>>> also changes how these packets are flooded. RFC 4541 says that packets
>>
>> Indeed, we'll start flooding them all, not just the all hosts address.
>> If that is at all required it'll definitely have to be optional.
>>
>>> addressed to the all hosts address are a special case and should be
>>> forwarded to all ports:
>>>
>>> "In IPv6, the data forwarding rules are more straight forward because MLD is
>>> mandated for addresses with scope 2 (link-scope) or greater. The only exception
>>> is the address FF02::1 which is the all hosts link-scope address for which MLD
>>> messages are never sent. Packets with the all hosts link-scope address should
>>> be forwarded on all ports."
>>>
>>
>> I wonder what is the problem for the host to join such group on behalf of the bridge ?
>> Then you'll receive the traffic at least locally and the RFC says it itself - MLD is mandated
>> for the other link-local addresses.
>> It's very late here and maybe I'm missing something.. :)
>>
> The group is being joined by MLD at the L3 level but the packets are
> not being passed up to the l3 interface becasue there is a MLD querier
> on the network
> 

That shouldn't matter if the host has joined the group, there is a specific
check for that. If the host has joined the group and we have an mdst then
we'll hit this code:
                mdst = br_mdb_get(br, skb, vid);
                if ((mdst || BR_INPUT_SKB_CB_MROUTERS_ONLY(skb)) &&
                    br_multicast_querier_exists(br, eth_hdr(skb))) {
                        if ((mdst && mdst->host_joined) ||
                            br_multicast_is_router(br)) {
                                local_rcv = true;
                                br->dev->stats.multicast++;
                        }
                        mcast_hit = true;
                } else {

local_rcv become true and the packet is passed up, so what is the problem ?
Have you missed to refresh the group and it has expired in the bridge perhaps ?


> snippet from /proc/net/igmp6
> ...
> 40   sw1             ff0200000000000000000001ff008700     1 00000004 0
> 40   sw1             ff020000000000000000000000000002     1 00000004 0
> 40   sw1             ff020000000000000000000000000001     1 0000000C 0
> 40   sw1             ff010000000000000000000000000001     1 00000008 0
> 41   lo1             ff020000000000000000000000000001     1 0000000C 0
> 41   lo1             ff010000000000000000000000000001     1 00000008 0
> 42   sw1.1           ff020000000000000000000000000006     1 00000004 0
> 42   sw1.1           ff020000000000000000000000000005     1 00000004 0
> 42   sw1.1           ff0200000000000000000001ff000000     2 00000004 0
> 42   sw1.1           ff0200000000000000000001ff008700     1 00000004 0
> 42   sw1.1           ff0200000000000000000001ff000099     1 00000004 0
> 42   sw1.1           ff020000000000000000000000000002     1 00000004 0
> 42   sw1.1           ff020000000000000000000000000001     1 0000000C 0
> 42   sw1.1           ff010000000000000000000000000001     1 00000008 0
> ...
> 
> the bridge is sw1 and the l3 intervace is sw1.1
> 
> Ido is correct about the flooding - I will update the patch with the
> comments and reissue.
> 
> Thanks again
> 
> -pr
>>  
>>> Maybe you want something like:
>>>
>>
>> I think we can do without the new field, either pass local_rcv into br_multicast_rcv() or
>> set it based on return value. The extra test will have to remain unfortunately, but we
>> can reduce the tests by one if carefully done.
>>
>>> diff --git a/net/bridge/br_input.c b/net/bridge/br_input.c
>>> index 09b1dd8cd853..9f312a73f61c 100644
>>> --- a/net/bridge/br_input.c
>>> +++ b/net/bridge/br_input.c
>>> @@ -132,7 +132,8 @@ int br_handle_frame_finish(struct net *net, struct sock *sk, struct sk_buff *skb
>>>  		if ((mdst || BR_INPUT_SKB_CB_MROUTERS_ONLY(skb)) &&
>>>  		    br_multicast_querier_exists(br, eth_hdr(skb))) {
>>>  			if ((mdst && mdst->host_joined) ||
>>> -			    br_multicast_is_router(br)) {
>>> +			    br_multicast_is_router(br) ||
>>> +			    BR_INPUT_SKB_CB_LOCAL_RECEIVE(skb)) {
>>>  				local_rcv = true;
>>>  				br->dev->stats.multicast++;
>>>  			}
>>> diff --git a/net/bridge/br_multicast.c b/net/bridge/br_multicast.c
>>> index 9b379e110129..f03cecf6174e 100644
>>> --- a/net/bridge/br_multicast.c
>>> +++ b/net/bridge/br_multicast.c
>>> @@ -1667,6 +1667,9 @@ static int br_multicast_ipv6_rcv(struct net_bridge *br,
>>>  		if (!ipv6_addr_is_ll_all_nodes(&ipv6_hdr(skb)->daddr))
>>>  			BR_INPUT_SKB_CB(skb)->mrouters_only = 1;
>>>  
>>> +		if (ipv6_addr_is_ll_mcast(&ipv6_hdr(skb)->daddr))
>>> +			BR_INPUT_SKB_CB(skb)->local_receive = 1;
>>> +
>>>  		if (ipv6_addr_is_all_snoopers(&ipv6_hdr(skb)->daddr)) {
>>>  			err = br_ip6_multicast_mrd_rcv(br, port, skb);
>>>  
>>> diff --git a/net/bridge/br_private.h b/net/bridge/br_private.h
>>> index b7a4942ff1b3..d76394ca4059 100644
>>> --- a/net/bridge/br_private.h
>>> +++ b/net/bridge/br_private.h
>>> @@ -426,6 +426,7 @@ struct br_input_skb_cb {
>>>  #ifdef CONFIG_BRIDGE_IGMP_SNOOPING
>>>  	u8 igmp;
>>>  	u8 mrouters_only:1;
>>> +	u8 local_receive:1;
>>>  #endif
>>>  	u8 proxyarp_replied:1;
>>>  	u8 src_port_isolated:1;
>>> @@ -445,8 +446,10 @@ struct br_input_skb_cb {
>>>  
>>>  #ifdef CONFIG_BRIDGE_IGMP_SNOOPING
>>>  # define BR_INPUT_SKB_CB_MROUTERS_ONLY(__skb)	(BR_INPUT_SKB_CB(__skb)->mrouters_only)
>>> +# define BR_INPUT_SKB_CB_LOCAL_RECEIVE(__skb)	(BR_INPUT_SKB_CB(__skb)->local_receive)
>>>  #else
>>>  # define BR_INPUT_SKB_CB_MROUTERS_ONLY(__skb)	(0)
>>> +# define BR_INPUT_SKB_CB_LOCAL_RECEIVE(__skb)	(0)
>>>  #endif
>>>  
>>>  #define br_printk(level, br, format, args...)	\
>>>
> 


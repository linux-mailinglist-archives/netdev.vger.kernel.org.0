Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 99DE9280B6E
	for <lists+netdev@lfdr.de>; Fri,  2 Oct 2020 01:48:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733261AbgJAXsv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Oct 2020 19:48:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59808 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728090AbgJAXsv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 1 Oct 2020 19:48:51 -0400
Received: from mail-pf1-x442.google.com (mail-pf1-x442.google.com [IPv6:2607:f8b0:4864:20::442])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 42764C0613D0;
        Thu,  1 Oct 2020 16:48:51 -0700 (PDT)
Received: by mail-pf1-x442.google.com with SMTP id d6so121946pfn.9;
        Thu, 01 Oct 2020 16:48:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=pNtpKCx7E1khAvq3FIWIjykLAInK6DJInmbvKbDsgG0=;
        b=N3gVeqLPyTgzQSm2F5VVgggmGvYeLxqaEiFcjw+tdU05SpZdDjcg94Ba12/sWeU9dU
         y1M7MfYARRnnYyn7sPQBia7CVUmgnKZqmPZRunUr3OplK1XmT5L+Ji98gAydRuoCf0yA
         EV5R8oEeabZ7XO+LMyhxvKtpwMbvspgZk/cImD6kV0DolmcMJJxKid4h3M+ZszD/jKnA
         /0gbnzopdNAcwDX4lfnTac+vBKWr/AFL3C9BEEulLoDBC7AYQcRCX/L2CIr4zFQxBcFv
         7yiEctuRnCFAWOteu2oxI9HQsuRY6NNVjHChTIgUDvzWyYiruKTR+bs6GNS/RRfMJBD8
         vvng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=pNtpKCx7E1khAvq3FIWIjykLAInK6DJInmbvKbDsgG0=;
        b=AsfZXWuw3ix+fdPhPoJcsPPIwmiYFqag7H5bMXo4QVX8iKbpAZvsF1HGtFw+4FRTZl
         vc9OHUPPMUTBI1JN+AILfwjzfDHY2Mhhu24HwE/jR58G9ynVS2OmPfujOOJkgtEg44JI
         dtoHs5e5MqR3RCBGUUesT4vRnDDfCuspOZPyiRzIoFHPBLQPCZZqaYzMNYQEAwi4u4f7
         jOOewh+mZay5La6GB3haVStsP55q43HxRuRNJXL7G3ADGHGm2Dtvn7nVD4L82N9NyHkB
         hryBc3ojFGHgLqQ1gb2EFewl5Lon12Nx+bQJAMh4LyTLtm+/dxA1L9lz6NK70+muVwKh
         Ogdg==
X-Gm-Message-State: AOAM532iD5fHmjRr7kpQIr7xub0zTIx1rMuf0mM6mU+OaF6oH2GARGLM
        DK2qDgdwfsCRrIVN0EoeuzuUbpT2j4JO8A==
X-Google-Smtp-Source: ABdhPJw8QxTbSC3nI1NpNRYg3qzrFx8YpQZ7E4QIMqNTYOhKbg6M91HSRJDjovFaEwH8oMXozK4jFA==
X-Received: by 2002:a63:5c05:: with SMTP id q5mr8039242pgb.352.1601596130237;
        Thu, 01 Oct 2020 16:48:50 -0700 (PDT)
Received: from [10.230.29.112] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id i2sm8156240pfq.89.2020.10.01.16.48.46
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 01 Oct 2020 16:48:49 -0700 (PDT)
Subject: Re: [PATCH net-next v2] net: dsa: Support bridge 802.1Q while
 untagging
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        open list <linux-kernel@vger.kernel.org>
References: <20201001030623.343535-1-f.fainelli@gmail.com>
 <20201001232402.77gglnqqfsq6l4fj@skbuf>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <8610459d-3700-bf80-edea-c9ee24b38bc2@gmail.com>
Date:   Thu, 1 Oct 2020 16:48:43 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Firefox/78.0 Thunderbird/78.3.1
MIME-Version: 1.0
In-Reply-To: <20201001232402.77gglnqqfsq6l4fj@skbuf>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 10/1/2020 4:24 PM, Vladimir Oltean wrote:
> On Wed, Sep 30, 2020 at 08:06:23PM -0700, Florian Fainelli wrote:
>> The intent of 412a1526d067 ("net: dsa: untag the bridge pvid from rx
>> skbs") is to transparently untag the bridge's default_pvid when the
>> Ethernet switch can only support egress tagged of that default_pvid
>> towards the CPU port.
>>
>> Prior to this commit, users would have to configure an 802.1Q upper on
>> the bridge master device when the bridge is configured with
>> vlan_filtering=0 in order to pop the VLAN tag:
>>
>> ip link add name br0 type bridge vlan_filtering 0
>> ip link add link br0 name br0.1 type vlan id 1
>>
>> After this commit we added support for managing a switch port 802.1Q
>> upper but those are not usually added as bridge members, and if they do,
>> they do not actually require any special management, the data path would
>> pop the desired VLAN tag accordingly.
>>
>> What we want to preserve is that use case and to manage when the user
>> creates that 802.1Q upper for the bridge port.
>>
>> While we are it, call __vlan_find_dev_deep_rcu() which makes use the
>> VLAN group array which is faster.
>>
>> As soon as we return the VLAN tagged SKB though it will be used by the
>> following call path:
>>
>> netif_receive_skb_list_internal
>>    -> __netif_receive_skb_list_core
>>      -> __netif_receive_skb_core
>>        -> vlan_do_receive()
>>
>> which uses skb->vlan_proto, if we do not set it to the appropriate VLAN
>> protocol, we will leave it set to what the DSA master has set
>> (ETH_P_XDSA).
>>
> 
> The explanation is super confusing, although I think the placement of
> the "skb->vlan_proto = vlan_dev_vlan_proto(upper_dev)" is correct.
> Here's what I think is going on. It has to do with what's upwards of the
> code you're changing:
> 
> 	/* Move VLAN tag from data to hwaccel */
> 	if (!skb_vlan_tag_present(skb) && hdr->h_vlan_proto == htons(proto)) {
> 		skb = skb_vlan_untag(skb);
> 		if (!skb)
> 			return NULL;
> 	}
> 
> So skb->vlan_proto should already be equal to the protocol of the 8021q
> upper, see the call path below.
> 
>                             this is the problem
>                                     |
> skb_vlan_untag()                   v
>    -> __vlan_hwaccel_put_tag(skb, skb->protocol, vlan_tci);
>      -> skb->vlan_proto = vlan_proto;

Ah, indeed!

> 
> But the problem is that skb_vlan_untag() calls __vlan_hwaccel_put_tag
> with the wrong vlan_proto, it calls it with the skb->protocol which is
> still ETH_P_XDSA because we haven't re-run eth_type_trans() yet.
> It looks like this function wants pretty badly to be called after
> eth_type_trans(), and it's getting pretty messy because of that, but we
> don't have any other driver-specific hook afterwards..
> 
> I don't have a lot of experience, the alternatives are either to:
> - move dsa_untag_bridge_pvid() after eth_type_trans(), similar to what
>    you did in your initial patch - maybe this is the cleanest

This would be my preference and it would not be hurting the fast-path 
that much.

> - make dsa_untag_bridge_pvid() call eth_type_trans() and this gets rid
>    of the extra step you need to do in tag_brcm.c

Sure, however this requires that we remove the call to eth_type_trans() 
in dsa_switch_rcv() or that we push/pull by an appropriate amount, not 
very effective.

> - document this very well

I doubt this would survive the test of time unfortunately.

> 
>> Fixes: 412a1526d067 ("net: dsa: untag the bridge pvid from rx skbs")
>> Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
>> ---
>> Changes in v2:
>>
>> - removed unused list_head iter argument
>>
>>   net/dsa/dsa_priv.h | 11 ++++-------
>>   1 file changed, 4 insertions(+), 7 deletions(-)
>>
>> diff --git a/net/dsa/dsa_priv.h b/net/dsa/dsa_priv.h
>> index 0348dbab4131..b4aafb2e90fa 100644
>> --- a/net/dsa/dsa_priv.h
>> +++ b/net/dsa/dsa_priv.h
>> @@ -205,7 +205,6 @@ static inline struct sk_buff *dsa_untag_bridge_pvid(struct sk_buff *skb)
>>   	struct net_device *br = dp->bridge_dev;
>>   	struct net_device *dev = skb->dev;
>>   	struct net_device *upper_dev;
>> -	struct list_head *iter;
>>   	u16 vid, pvid, proto;
>>   	int err;
>>   
>> @@ -247,12 +246,10 @@ static inline struct sk_buff *dsa_untag_bridge_pvid(struct sk_buff *skb)
>>   	 * supports because vlan_filtering is 0. In that case, we should
>>   	 * definitely keep the tag, to make sure it keeps working.
>>   	 */
>> -	netdev_for_each_upper_dev_rcu(dev, upper_dev, iter) {
>> -		if (!is_vlan_dev(upper_dev))
>> -			continue;
>> -
>> -		if (vid == vlan_dev_vlan_id(upper_dev))
>> -			return skb;
>> +	upper_dev = __vlan_find_dev_deep_rcu(br, htons(proto), vid);
>> +	if (upper_dev) {
>> +		skb->vlan_proto = vlan_dev_vlan_proto(upper_dev);
>> +		return skb;
>>   	}
>>   
>>   	__vlan_hwaccel_clear_tag(skb);
>> -- 
>> 2.25.1

-- 
Florian

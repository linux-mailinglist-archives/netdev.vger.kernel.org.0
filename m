Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1626123D12F
	for <lists+netdev@lfdr.de>; Wed,  5 Aug 2020 21:57:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728228AbgHET5W (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Aug 2020 15:57:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45434 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727984AbgHEQoI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 Aug 2020 12:44:08 -0400
Received: from mail-qk1-x744.google.com (mail-qk1-x744.google.com [IPv6:2607:f8b0:4864:20::744])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0EC17C008698
        for <netdev@vger.kernel.org>; Wed,  5 Aug 2020 09:31:11 -0700 (PDT)
Received: by mail-qk1-x744.google.com with SMTP id d14so42203659qke.13
        for <netdev@vger.kernel.org>; Wed, 05 Aug 2020 09:31:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=2Oy1KPRkMj5aUnaFB5ah7Ga5bM3PKnMFBqFCo7gq61M=;
        b=U8U9PgVmG3A0ugXOEflLYWwQZ7WJffMiGMlfPoMK4vYTN5VpN+Ie5TdpredaY43itN
         ri1MjnAayw5aIgD8iGa8gke5N3jDL46QhwisAlh1Q3wVq08gUdYhbjkVQtySWimVH2D8
         GcyN6KKsrlTLfSMOhX0Z5YdgT6N3ov0yoJAbMV23vQaqqruTCKb45RDRjlX1CVBg1N36
         za+5DOovNfsDz5xA8xufBLApxFq7KKCe6L4iQKU+9lQnPpcW+Gwt3tF59/ZcJoFAvPuI
         o0KPx/EV1JvrVWjn5G6Ix3U/ETKOuWilG9OmoFIUdDJ2FpYq/KtL3SRYooYpNefm8l5J
         FBmw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=2Oy1KPRkMj5aUnaFB5ah7Ga5bM3PKnMFBqFCo7gq61M=;
        b=aBwG/1Ay5DQfrMmGcP3uNV9Dxom3av+0vUvoms+gRERmhfkKBIy0CvgsHGmr1/ksns
         /tW1U6BCOqDTfiQgfiDzVY9P6pGpcUMksKxqV8HC18FQm2865gJYSTjoHQSs7e2K8uV1
         RnajDEw10fK46ohDYk9dN82Umh0Rvf3viK/bHL9LMxbabWsh549lEq3wIt8JRC8AMYxo
         3k7wpTkTzf3SvHWv8mfGgRhuRWhgm/BYCbyuvgjyKZgOTsNak0osxUzX5FyuK9qsS91f
         sCCsJXoBUX4wracqpEXNgcZhIg0zzSkzrgNQPBmEAPJ4cYh4keKkVW+4IaZqrtM9iP78
         SJzQ==
X-Gm-Message-State: AOAM530XOU74iswORzxzYW3YRM7oj7u1QB/vX5nbUR6/OSHcG2M7KUjK
        t4ue+6EcAGspbMix/T11XArBegUM
X-Google-Smtp-Source: ABdhPJwS5BuLoY5pb/QSOYQKSlQR3/JgCAxXK6Vg/sC6pmBuiTEp4metTt7zH+fnqrjMlMt2cxk49A==
X-Received: by 2002:a37:80c:: with SMTP id 12mr4283253qki.149.1596645069936;
        Wed, 05 Aug 2020 09:31:09 -0700 (PDT)
Received: from [10.254.6.29] ([162.243.188.133])
        by smtp.googlemail.com with ESMTPSA id r6sm2095645qkc.43.2020.08.05.09.31.07
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 05 Aug 2020 09:31:09 -0700 (PDT)
Subject: Re: [PATCH net 1/2] ipv6: add ipv6_dev_find()
To:     Ying Xue <ying.xue@windriver.com>, Xin Long <lucien.xin@gmail.com>,
        network dev <netdev@vger.kernel.org>
Cc:     davem@davemloft.net, Jon Maloy <jon.maloy@ericsson.com>,
        tipc-discussion@lists.sourceforge.net,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>
References: <cover.1596468610.git.lucien.xin@gmail.com>
 <7ba2ca17347249b980731e7a76ba3e24a9e37720.1596468610.git.lucien.xin@gmail.com>
 <491f4a9b-1924-baf5-c1b5-43704af2ed5e@windriver.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <9aec8657-ac6e-f10a-2b6e-a544a0aa9ab5@gmail.com>
Date:   Wed, 5 Aug 2020 10:31:06 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.11.0
MIME-Version: 1.0
In-Reply-To: <491f4a9b-1924-baf5-c1b5-43704af2ed5e@windriver.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 8/5/20 5:03 AM, Ying Xue wrote:
>> diff --git a/net/ipv6/addrconf.c b/net/ipv6/addrconf.c
>> index 840bfdb..857d6f9 100644
>> --- a/net/ipv6/addrconf.c
>> +++ b/net/ipv6/addrconf.c
>> @@ -1983,6 +1983,45 @@ int ipv6_chk_prefix(const struct in6_addr *addr, struct net_device *dev)
>>  }
>>  EXPORT_SYMBOL(ipv6_chk_prefix);
>>  
>> +/**
>> + * ipv6_dev_find - find the first device with a given source address.
>> + * @net: the net namespace
>> + * @addr: the source address
>> + *
>> + * The caller should be protected by RCU, or RTNL.
>> + */
>> +struct net_device *ipv6_dev_find(struct net *net, const struct in6_addr *addr)
>> +{
>> +	unsigned int hash = inet6_addr_hash(net, addr);
>> +	struct inet6_ifaddr *ifp, *result = NULL;
>> +	struct net_device *dev = NULL;
>> +
>> +	rcu_read_lock();
>> +	hlist_for_each_entry_rcu(ifp, &inet6_addr_lst[hash], addr_lst) {
>> +		if (net_eq(dev_net(ifp->idev->dev), net) &&
>> +		    ipv6_addr_equal(&ifp->addr, addr)) {
>> +			result = ifp;
>> +			break;
>> +		}
>> +	}
>> +
>> +	if (!result) {
>> +		struct rt6_info *rt;
>> +
>> +		rt = rt6_lookup(net, addr, NULL, 0, NULL, 0);

why is this needed? you have already walked the interfaces in the
namespace and not found the address. Doing a route lookup is beyond the
stated scope of this function.

>> +		if (rt) {
>> +			dev = rt->dst.dev;
>> +			ip6_rt_put(rt);
>> +		}
>> +	} else {
>> +		dev = result->idev->dev;
>> +	}
>> +	rcu_read_unlock();
>> +
>> +	return dev;
>> +}
>> +EXPORT_SYMBOL(ipv6_dev_find);
>> +
>>  struct inet6_ifaddr *ipv6_get_ifaddr(struct net *net, const struct in6_addr *addr,
>>  				     struct net_device *dev, int strict)
>>  {
>>


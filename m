Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 162184E5294
	for <lists+netdev@lfdr.de>; Wed, 23 Mar 2022 13:56:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231730AbiCWM5g (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Mar 2022 08:57:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53398 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240897AbiCWM5f (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Mar 2022 08:57:35 -0400
Received: from mail-ej1-x62e.google.com (mail-ej1-x62e.google.com [IPv6:2a00:1450:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B38447C792
        for <netdev@vger.kernel.org>; Wed, 23 Mar 2022 05:56:05 -0700 (PDT)
Received: by mail-ej1-x62e.google.com with SMTP id a8so2632561ejc.8
        for <netdev@vger.kernel.org>; Wed, 23 Mar 2022 05:56:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=Ftk9sAk2bfo88EqepnTFUzS4YEp7u3X57dJlEwJZV2M=;
        b=PxahVlEoucltOxa5CLptTXpOdUWHZrAO8vqmimIXv8JBCCVNw8fM3cnDbuCN8PYy1O
         kNlL9QGYKOmhZe+i7pFAw1EDF8M4RgD7iGTtsw5SMJh0YCHkFc1lkSG9B77t9S9ts8S+
         O5qJSIyaZGFzasq+/wckMrIvKMnSBEq03VhWOh8U+OV074lfIOI2mRzb1N78Fd+IQvyg
         ua9kQooXoK3QmTsDX6Ie1onrZY3qAtBqvym2jAfoeLmpo68XvCYrdj8Oaaz8vkSn08ja
         Udft8M7s/meK13aAAWk7rc9m1tsbNmKZIhgQRbioDJ+5r4TO3GfYFtCXIS0NXIa8bwrc
         VWtA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=Ftk9sAk2bfo88EqepnTFUzS4YEp7u3X57dJlEwJZV2M=;
        b=XBCbz5sSr0lyNwPc2IHd8VhnvvR06DYuljFHzJXzIhPOV8InUi96v9u2AqI7rEllKF
         jNGGQemRxZvPeIvhXvZ7eHwUeDbynCx8MfAqfuRUAAyrR3ILCLwrhRWuB0X9XpLxbgzp
         iyQq6kgwhMT6qUBh21RZKeJvBQzzdcpGIlXDE48xzNO3lcxbiUYNpK/Yd7tU+b4vI1sz
         t9qdDMWtpAnJ4PToE2WoFdndqP9GFPsXK62OsYrxGX0JL8LYBrWmJ16FQur0DyxP8HZw
         XU6LpSEloRYmcCYpZ9cxn3Ei5lckF16v07hWp9undVB8Fb4QshvQwBzSWcKiKdsqjK3B
         nCVA==
X-Gm-Message-State: AOAM531NVYquPdO6FuU8XLj4wpBm4vINUF8E8MVXZJPRKimODgwXTXSM
        X0YrDc/I6koxatZ7fhg3cmE=
X-Google-Smtp-Source: ABdhPJz8P3ZOaVTUZ3V7q+K1EgdWxmzosqCP9hLa/EtQ/MPUK414RsoapSDof5En0AbqhTPZo5DYnw==
X-Received: by 2002:a17:906:9b8f:b0:6db:ab62:4713 with SMTP id dd15-20020a1709069b8f00b006dbab624713mr31686009ejc.738.1648040164207;
        Wed, 23 Mar 2022 05:56:04 -0700 (PDT)
Received: from ?IPV6:2a02:1811:cc83:eef0:7bf1:a0f8:a9aa:ac98? (ptr-dtfv0pmq82wc9dcpm6w.18120a2.ip6.access.telenet.be. [2a02:1811:cc83:eef0:7bf1:a0f8:a9aa:ac98])
        by smtp.gmail.com with ESMTPSA id n13-20020a170906724d00b006cedd6d7e24sm9892761ejk.119.2022.03.23.05.56.03
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 23 Mar 2022 05:56:03 -0700 (PDT)
Message-ID: <a662198e-dd32-ee7a-2dbb-8ae33588356e@gmail.com>
Date:   Wed, 23 Mar 2022 13:56:02 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.6.2
Subject: Re: [PATCH] ipv6: fix locking issues with loops over idev->addr_list
Content-Language: en-US
To:     Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>,
        Jakub Kicinski <kuba@kernel.org>
References: <20220322213406.55977-1-dossche.niels@gmail.com>
 <2ef6b0571179c75636830bd9810a777d197738f4.camel@redhat.com>
From:   Niels Dossche <dossche.niels@gmail.com>
In-Reply-To: <2ef6b0571179c75636830bd9810a777d197738f4.camel@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 23/03/2022 09:20, Paolo Abeni wrote:
> On Tue, 2022-03-22 at 22:34 +0100, Niels Dossche wrote:
>> idev->addr_list needs to be protected by idev->lock. However, it is not
>> always possible to do so while iterating and performing actions on
>> inet6_ifaddr instances. For example, multiple functions (like
>> addrconf_{join,leave}_anycast) eventually call down to other functions
>> that acquire the idev->lock. The current code temporarily unlocked the
>> idev->lock during the loops, which can cause race conditions. Moving the
>> locks up is also not an appropriate solution as the ordering of lock
>> acquisition will be inconsistent with for example mc_lock.
>>
>> This solution adds an additional field to inet6_ifaddr that is used
>> to temporarily add the instances to a temporary list while holding
>> idev->lock. The temporary list can then be traversed without holding
>> idev->lock. This change was done in two places. In addrconf_ifdown, the
>> list_for_each_entry_safe variant of the list loop is also no longer
>> necessary as there is no deletion within that specific loop.
>>
>> The remaining loop in addrconf_ifdown that unlocks idev->lock in its
>> loop body is of no issue. This is because that loop always gets the
>> first entry and performs the delete and condition check under the
>> idev->lock.
>>
>> Suggested-by: Paolo Abeni <pabeni@redhat.com>
>> Signed-off-by: Niels Dossche <dossche.niels@gmail.com>
>> ---
>>
>> This was previously discussed in the mailing thread of
>> [PATCH v2] ipv6: acquire write lock for addr_list in dev_forward_change
>>
>>  include/net/if_inet6.h |  7 +++++++
>>  net/ipv6/addrconf.c    | 29 +++++++++++++++++++++++------
>>  2 files changed, 30 insertions(+), 6 deletions(-)
>>
>> diff --git a/include/net/if_inet6.h b/include/net/if_inet6.h
>> index f026cf08a8e8..a17f29f75e9a 100644
>> --- a/include/net/if_inet6.h
>> +++ b/include/net/if_inet6.h
>> @@ -64,6 +64,13 @@ struct inet6_ifaddr {
>>  
>>  	struct hlist_node	addr_lst;
>>  	struct list_head	if_list;
>> +	/*
>> +	 * Used to safely traverse idev->addr_list in process context
>> +	 * if the idev->lock needed to protect idev->addr_list cannot be held.
>> +	 * In that case, add the items to this list temporarily and iterate
>> +	 * without holding idev->lock. See addrconf_ifdown and dev_forward_change.
>> +	 */
>> +	struct list_head	if_list_aux;
>>  
>>  	struct list_head	tmp_list;
>>  	struct inet6_ifaddr	*ifpub;
>> diff --git a/net/ipv6/addrconf.c b/net/ipv6/addrconf.c
>> index f908e2fd30b2..72790d1934c7 100644
>> --- a/net/ipv6/addrconf.c
>> +++ b/net/ipv6/addrconf.c
>> @@ -800,6 +800,7 @@ static void dev_forward_change(struct inet6_dev *idev)
>>  {
>>  	struct net_device *dev;
>>  	struct inet6_ifaddr *ifa;
>> +	LIST_HEAD(tmp_addr_list);
>>  
>>  	if (!idev)
>>  		return;
>> @@ -818,14 +819,23 @@ static void dev_forward_change(struct inet6_dev *idev)
>>  		}
>>  	}
>>  
>> +	read_lock_bh(&idev->lock);
>>  	list_for_each_entry(ifa, &idev->addr_list, if_list) {
>>  		if (ifa->flags&IFA_F_TENTATIVE)
>>  			continue;
>> +		list_add_tail(&ifa->if_list_aux, &tmp_addr_list);
>> +	}
>> +	read_unlock_bh(&idev->lock);
>> +
>> +	while (!list_empty(&tmp_addr_list)) {
>> +		ifa = list_first_entry(&tmp_addr_list, struct inet6_ifaddr, if_list_aux);
>> +		list_del(&ifa->if_list_aux);
>>  		if (idev->cnf.forwarding)
>>  			addrconf_join_anycast(ifa);
>>  		else
>>  			addrconf_leave_anycast(ifa);
>>  	}
>> +
>>  	inet6_netconf_notify_devconf(dev_net(dev), RTM_NEWNETCONF,
>>  				     NETCONFA_FORWARDING,
>>  				     dev->ifindex, &idev->cnf);
>> @@ -3730,10 +3740,11 @@ static int addrconf_ifdown(struct net_device *dev, bool unregister)
>>  	unsigned long event = unregister ? NETDEV_UNREGISTER : NETDEV_DOWN;
>>  	struct net *net = dev_net(dev);
>>  	struct inet6_dev *idev;
>> -	struct inet6_ifaddr *ifa, *tmp;
>> +	struct inet6_ifaddr *ifa;
>>  	bool keep_addr = false;
>>  	bool was_ready;
>>  	int state, i;
>> +	LIST_HEAD(tmp_addr_list);
> 
> Very minot nit: I guess it's better to try to enforce the reverse x-mas
> tree order for newly added variables - that is: this declaration should
> me moved up, just after 'ifa'.
> 
>>  	ASSERT_RTNL();
>>  
>> @@ -3822,16 +3833,23 @@ static int addrconf_ifdown(struct net_device *dev, bool unregister)
>>  		write_lock_bh(&idev->lock);
>>  	}
>>  
>> -	list_for_each_entry_safe(ifa, tmp, &idev->addr_list, if_list) {
>> +	list_for_each_entry(ifa, &idev->addr_list, if_list) {
>> +		list_add_tail(&ifa->if_list_aux, &tmp_addr_list);
>> +	}
> 
> 
> Other minor nit: the braces are not required here.
> 
> Otherwise LGTM:
> 
> Acked-by: Paolo Abeni <pabeni@redhat.com>
> 

I will apply the suggestions to the patch, thanks for the review.

> However this looks like net-next material, and we are in the merge
> window right now. I think you should re-post in (slighly less) than 2w.
> Please add the target tree into the subj.
> 

Okay, I'll send it for net-next when the merge window is closed.

> Side note: AFAICS after this patch, there is still the suspicious
> tempaddr_list usage in addrconf_ifdown to be handled.
> 
> Cheers,
> 
> Paolo
> 

I have taken a look at that loop. I'm not sure that it is really problematic since the iteration and deletion is at least atomic under idev->lock.
But I can write a patch for that as well.

Cheers
Niels

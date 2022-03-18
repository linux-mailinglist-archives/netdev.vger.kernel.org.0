Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3BF7D4DDD3A
	for <lists+netdev@lfdr.de>; Fri, 18 Mar 2022 16:46:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238295AbiCRPq7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Mar 2022 11:46:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49022 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238290AbiCRPq5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Mar 2022 11:46:57 -0400
Received: from mail-ej1-x62f.google.com (mail-ej1-x62f.google.com [IPv6:2a00:1450:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 50052EDF32
        for <netdev@vger.kernel.org>; Fri, 18 Mar 2022 08:45:37 -0700 (PDT)
Received: by mail-ej1-x62f.google.com with SMTP id a8so17803380ejc.8
        for <netdev@vger.kernel.org>; Fri, 18 Mar 2022 08:45:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=BuXzY00RymeyQUNY375vpcob76LT2iswXCirhVizIXU=;
        b=I4z8KEDSGRdg/JW9pnkUAzkqPAU5x9cmOuV3NHQRIfIoaTXiqa/GleLWNU00ECEt0Q
         y6CToKezrm82tbgE+GwbsD4A9TA8XGD533FbvkNild0eIHp7DeVs+iQUni4vxFotlOgH
         gTkKGqnCHlNiI3u9+7dL+Sk1Ig1rMecB2DclQFxA7fUOobKdjCSQ68/XCxF0U/bwdOjs
         edbT0jeL8ihLPS4ENbtDsv58EWn3A5jLJ0s20hkMYdy8y731a2WHMw5v9p11T6LL1HyD
         vhDnGIKHeTCOJTXnXaexJiD/giA0yhcz+Li1MspQk/jVj+jT8EbPmJ2O0DpE+pkxz5WJ
         JaSA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=BuXzY00RymeyQUNY375vpcob76LT2iswXCirhVizIXU=;
        b=ZgtULzBSuqJ96nb2lFSYzOYORbxZRklpccbqX572KmkZ+83MNP4almW7kg1F9gTyxS
         RpptAIaClkGFn/xqbHXNkvLaLPXkBWQTQgVIoqjqTul+GZH9R8Dwk3Pn0+Cyqmpcnkbl
         ej+W6atmYpXy8wS8dJCvcVGI2HcDr0s5TJ5ZhRqQnuWg4vxqOytNLjv8KReO0GrWNQXE
         f7KscB0kWK1F96lIA8SLYKLAx+O3OdXEQ2f99zr7xhr9/T+cF7QcDdBJjJbyAn3hKzq8
         MLImxLGrVUNMPJG6bYcdDMiaCfZvL3BJVIbKoh5NLQZgrIzU9gkVqsADqobVXLmmydi/
         8LvA==
X-Gm-Message-State: AOAM530AeQ5IufPNwEThjysbyh2If4ewSDswa2HrskinZVLH7JXappqb
        DVoBU4sDt9cYWuC1/krthG0fmG98z0lbPg==
X-Google-Smtp-Source: ABdhPJyX8ezvGHfHPivDTufIASod31LF/WNwikLEUiiaQRaH2SzC/jmt61HTSCOjGFd2pfKyvNuw5g==
X-Received: by 2002:a17:907:216f:b0:6ce:d85f:35cf with SMTP id rl15-20020a170907216f00b006ced85f35cfmr9511485ejb.517.1647618335621;
        Fri, 18 Mar 2022 08:45:35 -0700 (PDT)
Received: from ?IPV6:2a02:1811:cc83:eef0:7bf1:a0f8:a9aa:ac98? (ptr-dtfv0pmq82wc9dcpm6w.18120a2.ip6.access.telenet.be. [2a02:1811:cc83:eef0:7bf1:a0f8:a9aa:ac98])
        by smtp.gmail.com with ESMTPSA id u10-20020a50d94a000000b004131aa2525esm4362098edj.49.2022.03.18.08.45.34
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 18 Mar 2022 08:45:35 -0700 (PDT)
Message-ID: <f8b7e306-916d-a3e7-5755-b71d6b118489@gmail.com>
Date:   Fri, 18 Mar 2022 16:45:33 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.6.2
Subject: Re: [PATCH v2] ipv6: acquire write lock for addr_list in
 dev_forward_change
Content-Language: en-US
To:     Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>,
        Jakub Kicinski <kuba@kernel.org>
References: <20220317155637.29733-1-dossche.niels@gmail.com>
 <7bd311d0846269f331a1d401c493f5511491d0df.camel@redhat.com>
 <a24b13ea10ca898bb003300084039b459d553f6d.camel@redhat.com>
 <13558e3e0ed23097f04bb90b43c261062dca9107.camel@redhat.com>
From:   Niels Dossche <dossche.niels@gmail.com>
In-Reply-To: <13558e3e0ed23097f04bb90b43c261062dca9107.camel@redhat.com>
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

On 18/03/2022 16:42, Paolo Abeni wrote:
> On Fri, 2022-03-18 at 13:48 +0100, Paolo Abeni wrote:
>> On Fri, 2022-03-18 at 10:13 +0100, Paolo Abeni wrote:
>>> On Thu, 2022-03-17 at 16:56 +0100, Niels Dossche wrote:
>>>> No path towards dev_forward_change (common ancestor of paths is in
>>>> addrconf_fixup_forwarding) acquires idev->lock for idev->addr_list.
>>>> We need to hold the lock during the whole loop in dev_forward_change.
>>>> __ipv6_dev_ac_{inc,dec} both acquire the write lock on idev->lock in
>>>> their function body. Since addrconf_{join,leave}_anycast call to
>>>> __ipv6_dev_ac_inc and __ipv6_dev_ac_dec respectively, we need to move
>>>> the responsibility of locking upwards.
>>>>
>>>> This patch moves the locking up. For __ipv6_dev_ac_dec, there is one
>>>> place where the caller can directly acquire the idev->lock, that is in
>>>> ipv6_dev_ac_dec. The other caller is addrconf_leave_anycast, which now
>>>> needs to be called under idev->lock, and thus it becomes the
>>>> responsibility of the callers of addrconf_leave_anycast to hold that
>>>> lock. For __ipv6_dev_ac_inc, there are also 2 callers, one is
>>>> ipv6_sock_ac_join, which can acquire the lock during the call to
>>>> __ipv6_dev_ac_inc. The other caller is addrconf_join_anycast, which now
>>>> needs to be called under idev->lock, and thus it becomes the
>>>> responsibility of the callers of addrconf_join_anycast to hold that
>>>> lock.
>>>>
>>>> Signed-off-by: Niels Dossche <dossche.niels@gmail.com>
>>>> ---
>>>>
>>>> Changes in v2:
>>>>  - Move the locking upwards
>>>>
>>>>  net/ipv6/addrconf.c | 21 ++++++++++++++++-----
>>>>  net/ipv6/anycast.c  | 37 ++++++++++++++++---------------------
>>>>  2 files changed, 32 insertions(+), 26 deletions(-)
>>>>
>>>> diff --git a/net/ipv6/addrconf.c b/net/ipv6/addrconf.c
>>>> index f908e2fd30b2..69e9f81e2045 100644
>>>> --- a/net/ipv6/addrconf.c
>>>> +++ b/net/ipv6/addrconf.c
>>>> @@ -818,6 +818,7 @@ static void dev_forward_change(struct inet6_dev *idev)
>>>>  		}
>>>>  	}
>>>>  
>>>> +	write_lock_bh(&idev->lock);
>>>>  	list_for_each_entry(ifa, &idev->addr_list, if_list) {
>>>>  		if (ifa->flags&IFA_F_TENTATIVE)
>>>>  			continue;
>>>> @@ -826,6 +827,7 @@ static void dev_forward_change(struct inet6_dev *idev)
>>>>  		else
>>>>  			addrconf_leave_anycast(ifa);
>>>>  	}
>>>> +	write_unlock_bh(&idev->lock);
>>>>  	inet6_netconf_notify_devconf(dev_net(dev), RTM_NEWNETCONF,
>>>>  				     NETCONFA_FORWARDING,
>>>>  				     dev->ifindex, &idev->cnf);
>>>> @@ -2191,7 +2193,7 @@ void addrconf_leave_solict(struct inet6_dev *idev, const struct in6_addr *addr)
>>>>  	__ipv6_dev_mc_dec(idev, &maddr);
>>>>  }
>>>>  
>>>> -/* caller must hold RTNL */
>>>> +/* caller must hold RTNL and write lock idev->lock */
>>>>  static void addrconf_join_anycast(struct inet6_ifaddr *ifp)
>>>>  {
>>>>  	struct in6_addr addr;
>>>> @@ -2204,7 +2206,7 @@ static void addrconf_join_anycast(struct inet6_ifaddr *ifp)
>>>>  	__ipv6_dev_ac_inc(ifp->idev, &addr);
>>>>  }
>>>>  
>>>> -/* caller must hold RTNL */
>>>> +/* caller must hold RTNL and write lock idev->lock */
>>>>  static void addrconf_leave_anycast(struct inet6_ifaddr *ifp)
>>>>  {
>>>>  	struct in6_addr addr;
>>>> @@ -3857,8 +3859,11 @@ static int addrconf_ifdown(struct net_device *dev, bool unregister)
>>>>  			__ipv6_ifa_notify(RTM_DELADDR, ifa);
>>>>  			inet6addr_notifier_call_chain(NETDEV_DOWN, ifa);
>>>>  		} else {
>>>> -			if (idev->cnf.forwarding)
>>>> +			if (idev->cnf.forwarding) {
>>>> +				write_lock_bh(&idev->lock);
>>>>  				addrconf_leave_anycast(ifa);
>>>> +				write_unlock_bh(&idev->lock);
>>>> +			}
>>>>  			addrconf_leave_solict(ifa->idev, &ifa->addr);
>>>>  		}
>>>>  
>>>> @@ -6136,16 +6141,22 @@ static void __ipv6_ifa_notify(int event, struct inet6_ifaddr *ifp)
>>>>  				&ifp->addr, ifp->idev->dev->name);
>>>>  		}
>>>>  
>>>> -		if (ifp->idev->cnf.forwarding)
>>>> +		if (ifp->idev->cnf.forwarding) {
>>>> +			write_lock_bh(&ifp->idev->lock);
>>>>  			addrconf_join_anycast(ifp);
>>>> +			write_unlock_bh(&ifp->idev->lock);
>>>> +		}
>>>>  		if (!ipv6_addr_any(&ifp->peer_addr))
>>>>  			addrconf_prefix_route(&ifp->peer_addr, 128,
>>>>  					      ifp->rt_priority, ifp->idev->dev,
>>>>  					      0, 0, GFP_ATOMIC);
>>>>  		break;
>>>>  	case RTM_DELADDR:
>>>> -		if (ifp->idev->cnf.forwarding)
>>>> +		if (ifp->idev->cnf.forwarding) {
>>>> +			write_lock_bh(&ifp->idev->lock);
>>>>  			addrconf_leave_anycast(ifp);
>>>> +			write_unlock_bh(&ifp->idev->lock);
>>>> +		}
>>>>  		addrconf_leave_solict(ifp->idev, &ifp->addr);
>>>>  		if (!ipv6_addr_any(&ifp->peer_addr)) {
>>>>  			struct fib6_info *rt;
>>>> diff --git a/net/ipv6/anycast.c b/net/ipv6/anycast.c
>>>> index dacdea7fcb62..f3017ed6f005 100644
>>>> --- a/net/ipv6/anycast.c
>>>> +++ b/net/ipv6/anycast.c
>>>> @@ -136,7 +136,9 @@ int ipv6_sock_ac_join(struct sock *sk, int ifindex, const struct in6_addr *addr)
>>>>  			goto error;
>>>>  	}
>>>>  
>>>> +	write_lock_bh(&idev->lock);
>>>>  	err = __ipv6_dev_ac_inc(idev, addr);
>>>> +	write_unlock_bh(&idev->lock);
>>>
>>> I feat this is problematic, due this call chain:
>>>
>>>  __ipv6_dev_ac_inc() -> addrconf_join_solict() -> ipv6_dev_mc_inc ->
>>> __ipv6_dev_mc_inc -> mutex_lock(&idev->mc_lock);
>>>
>>> The latter call requires process context.
>>>
>>> One alternarive (likely very hackish way) to solve this could be:
>>> - adding another list entry  into struct inet6_dev, rtnl protected.
>>
>> Typo above: the new field should be added to 'struct inet6_ifaddr'.
>>
>>> - traverse addr_list under idev->lock and add each entry with
>>> forwarding on to into a tmp list (e.g. tmp_join) using the field above;
>>> add the entries with forwarding off into another tmp list (e.g.
>>> tmp_leave), still using the same field.
>>
>> Again confusing text above, sorry. As the forwarding flag is per
>> device, all the addr entries will land into the same tmp list.
>>
>> It's probably better if I sketch up some code...
> 
> For the records, I mean something alongside the following - completely
> not tested:
> ---
> diff --git a/include/net/if_inet6.h b/include/net/if_inet6.h
> index 4cfdef6ca4f6..2df3c98b9e55 100644
> --- a/include/net/if_inet6.h
> +++ b/include/net/if_inet6.h
> @@ -64,6 +64,7 @@ struct inet6_ifaddr {
>  
>  	struct hlist_node	addr_lst;
>  	struct list_head	if_list;
> +	struct list_head	if_list_aux;
>  
>  	struct list_head	tmp_list;
>  	struct inet6_ifaddr	*ifpub;
> diff --git a/net/ipv6/addrconf.c b/net/ipv6/addrconf.c
> index b22504176588..27d1081b693e 100644
> --- a/net/ipv6/addrconf.c
> +++ b/net/ipv6/addrconf.c
> @@ -797,6 +797,7 @@ static void dev_forward_change(struct inet6_dev *idev)
>  {
>  	struct net_device *dev;
>  	struct inet6_ifaddr *ifa;
> +	LIST_HEAD(tmp);
>  
>  	if (!idev)
>  		return;
> @@ -815,9 +816,17 @@ static void dev_forward_change(struct inet6_dev *idev)
>  		}
>  	}
>  
> +	rcu_read_lock();
>  	list_for_each_entry(ifa, &idev->addr_list, if_list) {
>  		if (ifa->flags&IFA_F_TENTATIVE)
>  			continue;
> +		list_add_tail(&ifa->if_list_aux, &tmp);
> +	}
> +	rcu_read_unlock();
> +
> +	while (!list_empty(&tmp)) {
> +		ifa = list_first_entry(&tmp, struct inet6_ifaddr, if_list_aux);
> +		list_del(&ifa->if_list_aux);
>  		if (idev->cnf.forwarding)
>  			addrconf_join_anycast(ifa);
>  		else
> 

I see, nice small change.
Only thing I notice is that list_for_each_entry_rcu should be used instead of list_for_each_entry inside the rcu lock, right?

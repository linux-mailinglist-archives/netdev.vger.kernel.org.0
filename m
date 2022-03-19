Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9C5204DE821
	for <lists+netdev@lfdr.de>; Sat, 19 Mar 2022 14:18:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236979AbiCSNT1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 19 Mar 2022 09:19:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48354 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234764AbiCSNT0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 19 Mar 2022 09:19:26 -0400
Received: from mail-ej1-x629.google.com (mail-ej1-x629.google.com [IPv6:2a00:1450:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9827E19C03
        for <netdev@vger.kernel.org>; Sat, 19 Mar 2022 06:18:02 -0700 (PDT)
Received: by mail-ej1-x629.google.com with SMTP id a8so21769523ejc.8
        for <netdev@vger.kernel.org>; Sat, 19 Mar 2022 06:18:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=f1sMBRmqwZwAU9GnhU6NOfTHyQQaYPhyhrORRiZwNRY=;
        b=CbxbP8l/PwRpVE0ZwJ0HpgBeuKziFZuicNwyBDrjXlnx/nkaqmsUDXXiixiILsmXZJ
         ZQkb138kxRYayFyrm0BHt8N8pE4XfEVTvkSgrcyHInme5yPBVkHfXpXt5bGBZ9IbKZy2
         P6iLzB522XWrbDUlnYAMWtP7cbE3C2BRUHoHcMVYPcp4uw5ZHva2KAspyuigC36jI46e
         V9DsKe6R2/xfX/1M1sFGpD5UkBz/YVfme8BJaoqUYyFi4ymx2Q+P9ZVu59UGXLYx+zAW
         4UYH3RgZRnCK0xAGJDlN/hdCCr3u9iJi/jxrvqWm7IKOTNEg5sdbfSvRQb1NNDKZ+8xa
         JyOw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=f1sMBRmqwZwAU9GnhU6NOfTHyQQaYPhyhrORRiZwNRY=;
        b=rblh5hNDKnEBW+QDjJ9p5S7ytb5Nk5mWa8vEnrSmxoSQr3qQgH588Tr/q6Rjuj4Jl1
         nAd5hcn2NHecRazjiU27N/kMjsdLUMNYeTmaiSQIPkstbryrPfO1MUvf1LJPSXQA4CMB
         zjtRvsmDrnoYVQJ7meUwMs4/WqoyyRXYhifGr4ZSPZBjb3l5xXBD9S4/UL9rEkCrHl/B
         QU7KMJrCpmFQYkw6Ahl7hJ+uSBP6vV+9/KEx1lk7lqUkLZTcruEC6NA3YXYtXwe70VYt
         xZAPsdR4O3e5stZApacXTKOjHez2doSatcOK1xHc2O22W4rPNblv3eeMp2EbB747MfXS
         KLgw==
X-Gm-Message-State: AOAM530VtOgtdDC5gBTcdQ5az6vKgqKJDFCSYd5x/nHv++Ant+idzyNS
        kK+4sV+JCZB4X0dLj2sK9GM=
X-Google-Smtp-Source: ABdhPJxc5xCI0UTUgnKZg69WaokAvIi0orgJ9uWquP1U2szV8cv61f0Y87fquXU6bkib5WUNs9Wp9A==
X-Received: by 2002:a17:906:99c9:b0:6db:dd00:c35e with SMTP id s9-20020a17090699c900b006dbdd00c35emr12722299ejn.577.1647695880560;
        Sat, 19 Mar 2022 06:18:00 -0700 (PDT)
Received: from [192.168.0.59] (178-117-137-225.access.telenet.be. [178.117.137.225])
        by smtp.gmail.com with ESMTPSA id m19-20020a1709062ad300b006d1289becc7sm4753502eje.167.2022.03.19.06.17.59
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 19 Mar 2022 06:18:00 -0700 (PDT)
Message-ID: <8b90b4a6-a906-0f46-bb87-0ec51c9c89fe@gmail.com>
Date:   Sat, 19 Mar 2022 14:17:58 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.6.1
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
 <f8b7e306-916d-a3e7-5755-b71d6b118489@gmail.com>
 <0cf800e8bb28116fce7466cacbabde395abfac4f.camel@redhat.com>
From:   Niels Dossche <dossche.niels@gmail.com>
In-Reply-To: <0cf800e8bb28116fce7466cacbabde395abfac4f.camel@redhat.com>
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

On 3/18/22 17:50, Paolo Abeni wrote:
> On Fri, 2022-03-18 at 16:45 +0100, Niels Dossche wrote:
>> On 18/03/2022 16:42, Paolo Abeni wrote:
>>> On Fri, 2022-03-18 at 13:48 +0100, Paolo Abeni wrote:
>>>> On Fri, 2022-03-18 at 10:13 +0100, Paolo Abeni wrote:
>>>>> On Thu, 2022-03-17 at 16:56 +0100, Niels Dossche wrote:
>>>>>> No path towards dev_forward_change (common ancestor of paths
>>>>>> is in
>>>>>> addrconf_fixup_forwarding) acquires idev->lock for idev-
>>>>>>> addr_list.
>>>>>> We need to hold the lock during the whole loop in
>>>>>> dev_forward_change.
>>>>>> __ipv6_dev_ac_{inc,dec} both acquire the write lock on idev-
>>>>>>> lock in
>>>>>> their function body. Since addrconf_{join,leave}_anycast call
>>>>>> to
>>>>>> __ipv6_dev_ac_inc and __ipv6_dev_ac_dec respectively, we need
>>>>>> to move
>>>>>> the responsibility of locking upwards.
>>>>>>
>>>>>> This patch moves the locking up. For __ipv6_dev_ac_dec, there
>>>>>> is one
>>>>>> place where the caller can directly acquire the idev->lock,
>>>>>> that is in
>>>>>> ipv6_dev_ac_dec. The other caller is addrconf_leave_anycast,
>>>>>> which now
>>>>>> needs to be called under idev->lock, and thus it becomes the
>>>>>> responsibility of the callers of addrconf_leave_anycast to
>>>>>> hold that
>>>>>> lock. For __ipv6_dev_ac_inc, there are also 2 callers, one is
>>>>>> ipv6_sock_ac_join, which can acquire the lock during the call
>>>>>> to
>>>>>> __ipv6_dev_ac_inc. The other caller is addrconf_join_anycast,
>>>>>> which now
>>>>>> needs to be called under idev->lock, and thus it becomes the
>>>>>> responsibility of the callers of addrconf_join_anycast to
>>>>>> hold that
>>>>>> lock.
>>>>>>
>>>>>> Signed-off-by: Niels Dossche <dossche.niels@gmail.com>
>>>>>> ---
>>>>>>
>>>>>> Changes in v2:
>>>>>>  - Move the locking upwards
>>>>>>
>>>>>>  net/ipv6/addrconf.c | 21 ++++++++++++++++-----
>>>>>>  net/ipv6/anycast.c  | 37 ++++++++++++++++-------------------
>>>>>> --
>>>>>>  2 files changed, 32 insertions(+), 26 deletions(-)
>>>>>>
>>>>>> diff --git a/net/ipv6/addrconf.c b/net/ipv6/addrconf.c
>>>>>> index f908e2fd30b2..69e9f81e2045 100644
>>>>>> --- a/net/ipv6/addrconf.c
>>>>>> +++ b/net/ipv6/addrconf.c
>>>>>> @@ -818,6 +818,7 @@ static void dev_forward_change(struct
>>>>>> inet6_dev *idev)
>>>>>>  		}
>>>>>>  	}
>>>>>>  
>>>>>> +	write_lock_bh(&idev->lock);
>>>>>>  	list_for_each_entry(ifa, &idev->addr_list, if_list)
>>>>>> {
>>>>>>  		if (ifa->flags&IFA_F_TENTATIVE)
>>>>>>  			continue;
>>>>>> @@ -826,6 +827,7 @@ static void dev_forward_change(struct
>>>>>> inet6_dev *idev)
>>>>>>  		else
>>>>>>  			addrconf_leave_anycast(ifa);
>>>>>>  	}
>>>>>> +	write_unlock_bh(&idev->lock);
>>>>>>  	inet6_netconf_notify_devconf(dev_net(dev),
>>>>>> RTM_NEWNETCONF,
>>>>>>  				     NETCONFA_FORWARDING,
>>>>>>  				     dev->ifindex, &idev-
>>>>>>> cnf);
>>>>>> @@ -2191,7 +2193,7 @@ void addrconf_leave_solict(struct
>>>>>> inet6_dev *idev, const struct in6_addr *addr)
>>>>>>  	__ipv6_dev_mc_dec(idev, &maddr);
>>>>>>  }
>>>>>>  
>>>>>> -/* caller must hold RTNL */
>>>>>> +/* caller must hold RTNL and write lock idev->lock */
>>>>>>  static void addrconf_join_anycast(struct inet6_ifaddr *ifp)
>>>>>>  {
>>>>>>  	struct in6_addr addr;
>>>>>> @@ -2204,7 +2206,7 @@ static void
>>>>>> addrconf_join_anycast(struct inet6_ifaddr *ifp)
>>>>>>  	__ipv6_dev_ac_inc(ifp->idev, &addr);
>>>>>>  }
>>>>>>  
>>>>>> -/* caller must hold RTNL */
>>>>>> +/* caller must hold RTNL and write lock idev->lock */
>>>>>>  static void addrconf_leave_anycast(struct inet6_ifaddr *ifp)
>>>>>>  {
>>>>>>  	struct in6_addr addr;
>>>>>> @@ -3857,8 +3859,11 @@ static int addrconf_ifdown(struct
>>>>>> net_device *dev, bool unregister)
>>>>>>  			__ipv6_ifa_notify(RTM_DELADDR, ifa);
>>>>>> 			inet6addr_notifier_call_chain(NETDEV_DOWN, ifa);
>>>>>>  		} else {
>>>>>> -			if (idev->cnf.forwarding)
>>>>>> +			if (idev->cnf.forwarding) {
>>>>>> +				write_lock_bh(&idev->lock);
>>>>>>  				addrconf_leave_anycast(ifa);
>>>>>> +				write_unlock_bh(&idev-
>>>>>>> lock);
>>>>>> +			}
>>>>>>  			addrconf_leave_solict(ifa->idev,
>>>>>> &ifa->addr);
>>>>>>  		}
>>>>>>  
>>>>>> @@ -6136,16 +6141,22 @@ static void __ipv6_ifa_notify(int
>>>>>> event, struct inet6_ifaddr *ifp)
>>>>>>  				&ifp->addr, ifp->idev->dev-
>>>>>>> name);
>>>>>>  		}
>>>>>>  
>>>>>> -		if (ifp->idev->cnf.forwarding)
>>>>>> +		if (ifp->idev->cnf.forwarding) {
>>>>>> +			write_lock_bh(&ifp->idev->lock);
>>>>>>  			addrconf_join_anycast(ifp);
>>>>>> +			write_unlock_bh(&ifp->idev->lock);
>>>>>> +		}
>>>>>>  		if (!ipv6_addr_any(&ifp->peer_addr))
>>>>>>  			addrconf_prefix_route(&ifp-
>>>>>>> peer_addr, 128,
>>>>>>  					      ifp-
>>>>>>> rt_priority, ifp->idev->dev,
>>>>>>  					      0, 0,
>>>>>> GFP_ATOMIC);
>>>>>>  		break;
>>>>>>  	case RTM_DELADDR:
>>>>>> -		if (ifp->idev->cnf.forwarding)
>>>>>> +		if (ifp->idev->cnf.forwarding) {
>>>>>> +			write_lock_bh(&ifp->idev->lock);
>>>>>>  			addrconf_leave_anycast(ifp);
>>>>>> +			write_unlock_bh(&ifp->idev->lock);
>>>>>> +		}
>>>>>>  		addrconf_leave_solict(ifp->idev, &ifp-
>>>>>>> addr);
>>>>>>  		if (!ipv6_addr_any(&ifp->peer_addr)) {
>>>>>>  			struct fib6_info *rt;
>>>>>> diff --git a/net/ipv6/anycast.c b/net/ipv6/anycast.c
>>>>>> index dacdea7fcb62..f3017ed6f005 100644
>>>>>> --- a/net/ipv6/anycast.c
>>>>>> +++ b/net/ipv6/anycast.c
>>>>>> @@ -136,7 +136,9 @@ int ipv6_sock_ac_join(struct sock *sk,
>>>>>> int ifindex, const struct in6_addr *addr)
>>>>>>  			goto error;
>>>>>>  	}
>>>>>>  
>>>>>> +	write_lock_bh(&idev->lock);
>>>>>>  	err = __ipv6_dev_ac_inc(idev, addr);
>>>>>> +	write_unlock_bh(&idev->lock);
>>>>>
>>>>> I feat this is problematic, due this call chain:
>>>>>
>>>>>  __ipv6_dev_ac_inc() -> addrconf_join_solict() ->
>>>>> ipv6_dev_mc_inc ->
>>>>> __ipv6_dev_mc_inc -> mutex_lock(&idev->mc_lock);
>>>>>
>>>>> The latter call requires process context.
>>>>>
>>>>> One alternarive (likely very hackish way) to solve this could
>>>>> be:
>>>>> - adding another list entry  into struct inet6_dev, rtnl
>>>>> protected.
>>>>
>>>> Typo above: the new field should be added to 'struct
>>>> inet6_ifaddr'.
>>>>
>>>>> - traverse addr_list under idev->lock and add each entry with
>>>>> forwarding on to into a tmp list (e.g. tmp_join) using the
>>>>> field above;
>>>>> add the entries with forwarding off into another tmp list (e.g.
>>>>> tmp_leave), still using the same field.
>>>>
>>>> Again confusing text above, sorry. As the forwarding flag is per
>>>> device, all the addr entries will land into the same tmp list.
>>>>
>>>> It's probably better if I sketch up some code...
>>>
>>> For the records, I mean something alongside the following -
>>> completely
>>> not tested:
>>> ---
>>> diff --git a/include/net/if_inet6.h b/include/net/if_inet6.h
>>> index 4cfdef6ca4f6..2df3c98b9e55 100644
>>> --- a/include/net/if_inet6.h
>>> +++ b/include/net/if_inet6.h
>>> @@ -64,6 +64,7 @@ struct inet6_ifaddr {
>>>  
>>>  	struct hlist_node	addr_lst;
>>>  	struct list_head	if_list;
>>> +	struct list_head	if_list_aux;
>>>  
>>>  	struct list_head	tmp_list;
>>>  	struct inet6_ifaddr	*ifpub;
>>> diff --git a/net/ipv6/addrconf.c b/net/ipv6/addrconf.c
>>> index b22504176588..27d1081b693e 100644
>>> --- a/net/ipv6/addrconf.c
>>> +++ b/net/ipv6/addrconf.c
>>> @@ -797,6 +797,7 @@ static void dev_forward_change(struct inet6_dev
>>> *idev)
>>>  {
>>>  	struct net_device *dev;
>>>  	struct inet6_ifaddr *ifa;
>>> +	LIST_HEAD(tmp);
>>>  
>>>  	if (!idev)
>>>  		return;
>>> @@ -815,9 +816,17 @@ static void dev_forward_change(struct
>>> inet6_dev *idev)
>>>  		}
>>>  	}
>>>  
>>> +	rcu_read_lock();
>>>  	list_for_each_entry(ifa, &idev->addr_list, if_list) {
>>>  		if (ifa->flags&IFA_F_TENTATIVE)
>>>  			continue;
>>> +		list_add_tail(&ifa->if_list_aux, &tmp);
>>> +	}
>>> +	rcu_read_unlock();
>>> +
>>> +	while (!list_empty(&tmp)) {
>>> +		ifa = list_first_entry(&tmp, struct inet6_ifaddr,
>>> if_list_aux);
>>> +		list_del(&ifa->if_list_aux);
>>>  		if (idev->cnf.forwarding)
>>>  			addrconf_join_anycast(ifa);
>>>  		else
>>>
>>
>> I see, nice small change.
>> Only thing I notice is that list_for_each_entry_rcu should be used
>> instead of list_for_each_entry inside the rcu lock, right?
> 
> Yes you are right. Or you can replace rcu_read_lock() with
> write_lock_bh(&idev->lock).
> 
> Probably we need some commend nearby if_list_aux definition alike "used
> to safely traverse the idev address list in process context, see
> dev_forward_change"
> 
> Cheers,
> 
> Paolo
> 
>  
> 

Hi,
I have an additional question about the locks on the addr_list actually.
In addrconf_ifdown, there's a loop on addr_list within a write lock in idev->lock
> list_for_each_entry_safe(ifa, tmp, &idev->addr_list, if_list)
The loop body unlocks the idev->lock and reacquires it later. I assume because of the lock dependency on ifa->lock and the calls that acquire the mc_lock? Shouldn't that list iteration also be protected during the whole iteration?

Thanks
Niels

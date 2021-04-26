Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0FF5336B5B2
	for <lists+netdev@lfdr.de>; Mon, 26 Apr 2021 17:24:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234029AbhDZPZT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Apr 2021 11:25:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59128 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233573AbhDZPZT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 26 Apr 2021 11:25:19 -0400
Received: from mail-pl1-x629.google.com (mail-pl1-x629.google.com [IPv6:2607:f8b0:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 86EE0C061574
        for <netdev@vger.kernel.org>; Mon, 26 Apr 2021 08:24:37 -0700 (PDT)
Received: by mail-pl1-x629.google.com with SMTP id s20so13279115plr.13
        for <netdev@vger.kernel.org>; Mon, 26 Apr 2021 08:24:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=q0T9jbT9J+TwSihAcCr3HGKEWP12uQgYZvS3pdHVqZo=;
        b=d4UWmkkRHMFKP3kmi5OF+3tUt2yHNzgDLOlWEj7T2XOeHCDvRyd8JHq8AbUrzST7FX
         Z8REYPJxb+n6Y62qo4mLz7ghuRtgyF70jkT3Sk6yeZNd9gfP+9XX8OLicZQxJRxk8SD6
         JUbVsWMhMqlEsuOnprSxi4DZG6/esyvBE5KAdH6S0u/qJRtrV7TopyYavmlaqkXt2tI3
         pEZnblHvFjEbRq7nugYy2HTtuOOJkZp8wvIiReVoodNkAGi1nqYMqrdBueMMRFG/GO1I
         a6xbjZyddbFIB8y5BzfquAN2EF/uLQSVQuaONjZE0DOQJOV1v5nI0jPvVGxNQTpv9mVy
         7Dug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=q0T9jbT9J+TwSihAcCr3HGKEWP12uQgYZvS3pdHVqZo=;
        b=tC5EgefGy9mMwwlXE6WQrbfGqAbap5QYJ8qGGK13Y31ZyTSDysIDQdxiiGxBO0B0SV
         vPHoXuhpDbURzcmb7CWPbLOlIse3GwrcYPo5YIgZA3d8DtvY/sK/vHj9pAzSwGcSQRKZ
         APMpBY3cuC80ZyzP6COEOkTmdwvve6V+lVk+bimUUy2nP0ksrSV1mdvrWP/80n1xQkQr
         EQbRRi1Yn9ehA6As1MQsbzofoK64yFbdF6+8v2JwTvo2s33A7xNDpdWu4SKJlKUFzp/r
         yuDyyVpUbYay/8nLy5LE9Qz3MLKgzpTS/lsCnaajGL4M99M4S/qJGveihBnXAo7bOLNB
         AC5w==
X-Gm-Message-State: AOAM532j7lmW2QtGtZItYzEelwQnF8yVxGrAo2ltvn0LpOiz8mEpxdd+
        o6Evw2u7oHCiDVRqat3IOvo=
X-Google-Smtp-Source: ABdhPJwAGxuU4uvgk5s1YLZIMbudsahCI3btlZBwLhg9JqvI5u1fdgmj4bIZHPuxtaOa4gWUddd6XQ==
X-Received: by 2002:a17:90b:4908:: with SMTP id kr8mr9032606pjb.85.1619450676936;
        Mon, 26 Apr 2021 08:24:36 -0700 (PDT)
Received: from [192.168.0.4] ([49.173.165.50])
        by smtp.gmail.com with ESMTPSA id 132sm108229pfu.107.2021.04.26.08.24.32
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 26 Apr 2021 08:24:36 -0700 (PDT)
Subject: Re: [PATCH net v2 1/2] net: core: make bond_get_lowest_level_rcu()
 generic
To:     Heiner Kallweit <hkallweit1@gmail.com>, davem@davemloft.net,
        kuba@kernel.org, dsahern@kernel.org, yoshfuji@linux-ipv6.org,
        netdev@vger.kernel.org, j.vosburgh@gmail.com, vfalico@gmail.com,
        andy@greyhouse.net, roopa@nvidia.com, nikolay@nvidia.com,
        ast@kernel.org, andriin@fb.com, daniel@iogearbox.net,
        weiwan@google.com, cong.wang@bytedance.com, bjorn@kernel.org,
        herbert@gondor.apana.org.au, bridge@lists.linux-foundation.org
References: <20210425155742.30057-1-ap420073@gmail.com>
 <20210425155742.30057-2-ap420073@gmail.com>
 <d7cf5368-21a4-a551-169a-00a4cb2b3a0d@gmail.com>
From:   Taehee Yoo <ap420073@gmail.com>
Message-ID: <a43a957a-0fc8-cfff-f04a-cf0bc1ae612b@gmail.com>
Date:   Tue, 27 Apr 2021 00:24:31 +0900
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <d7cf5368-21a4-a551-169a-00a4cb2b3a0d@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 4/26/21 3:03 AM, Heiner Kallweit wrote:

Hi Heiner,
Thank you for the review!

 > On 25.04.2021 17:57, Taehee Yoo wrote:
 >> The purpose of bond_get_lowest_level_rcu() is to get nested_level under
 >> RCU. Because dev->nested_level is protected by RTNL, so it shouldn't be
 >> used without RTNL. But bonding module needs this value under RCU without
 >> RTNL.
 >> So, this function was added.
 >>
 >> But, there is another module, which needs this function.
 >> So, make this function generic.
 >> the new name is netdev_get_nest_level_rcu().
 >>
 >> Signed-off-by: Taehee Yoo <ap420073@gmail.com>
 >> ---
 >>
 >> v2:
 >>   - No change
 >>
 >>   drivers/net/bonding/bond_main.c | 45 +--------------------------------
 >>   include/linux/netdevice.h       |  1 +
 >>   net/core/dev.c                  | 44 ++++++++++++++++++++++++++++++++
 >>   3 files changed, 46 insertions(+), 44 deletions(-)
 >>
 >> diff --git a/drivers/net/bonding/bond_main.c 
b/drivers/net/bonding/bond_main.c
 >> index 83ef62db6285..a9feb039ffa6 100644
 >> --- a/drivers/net/bonding/bond_main.c
 >> +++ b/drivers/net/bonding/bond_main.c
 >> @@ -3754,47 +3754,6 @@ static void bond_fold_stats(struct 
rtnl_link_stats64 *_res,
 >>   	}
 >>   }
 >>
 >> -#ifdef CONFIG_LOCKDEP
 >> -static int bond_get_lowest_level_rcu(struct net_device *dev)
 >> -{
 >> -	struct net_device *ldev, *next, *now, *dev_stack[MAX_NEST_DEV + 1];
 >> -	struct list_head *niter, *iter, *iter_stack[MAX_NEST_DEV + 1];
 >> -	int cur = 0, max = 0;
 >> -
 >> -	now = dev;
 >> -	iter = &dev->adj_list.lower;
 >> -
 >> -	while (1) {
 >> -		next = NULL;
 >> -		while (1) {
 >> -			ldev = netdev_next_lower_dev_rcu(now, &iter);
 >> -			if (!ldev)
 >> -				break;
 >> -
 >> -			next = ldev;
 >> -			niter = &ldev->adj_list.lower;
 >> -			dev_stack[cur] = now;
 >> -			iter_stack[cur++] = iter;
 >> -			if (max <= cur)
 >> -				max = cur;
 >> -			break;
 >> -		}
 >> -
 >> -		if (!next) {
 >> -			if (!cur)
 >> -				return max;
 >> -			next = dev_stack[--cur];
 >> -			niter = iter_stack[cur];
 >> -		}
 >> -
 >> -		now = next;
 >> -		iter = niter;
 >> -	}
 >> -
 >> -	return max;
 >> -}
 >> -#endif
 >> -
 >>   static void bond_get_stats(struct net_device *bond_dev,
 >>   			   struct rtnl_link_stats64 *stats)
 >>   {
 >> @@ -3806,9 +3765,7 @@ static void bond_get_stats(struct net_device 
*bond_dev,
 >>
 >>
 >>   	rcu_read_lock();
 >> -#ifdef CONFIG_LOCKDEP
 >> -	nest_level = bond_get_lowest_level_rcu(bond_dev);
 >> -#endif
 >> +	nest_level = netdev_get_nest_level_rcu(bond_dev);
 >>
 >>   	spin_lock_nested(&bond->stats_lock, nest_level);
 >>   	memcpy(stats, &bond->bond_stats, sizeof(*stats));
 >> diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
 >> index 87a5d186faff..507c06bf5dba 100644
 >> --- a/include/linux/netdevice.h
 >> +++ b/include/linux/netdevice.h
 >> @@ -4699,6 +4699,7 @@ int netdev_walk_all_lower_dev(struct 
net_device *dev,
 >>   			      int (*fn)(struct net_device *lower_dev,
 >>   					struct netdev_nested_priv *priv),
 >>   			      struct netdev_nested_priv *priv);
 >> +int netdev_get_nest_level_rcu(struct net_device *dev);
 >>   int netdev_walk_all_lower_dev_rcu(struct net_device *dev,
 >>   				  int (*fn)(struct net_device *lower_dev,
 >>   					    struct netdev_nested_priv *priv),
 >> diff --git a/net/core/dev.c b/net/core/dev.c
 >> index 15fe36332fb8..efc2bf88eafd 100644
 >> --- a/net/core/dev.c
 >> +++ b/net/core/dev.c
 >> @@ -7709,6 +7709,50 @@ static int __netdev_update_lower_level(struct 
net_device *dev,
 >>   	return 0;
 >>   }
 >>
 >> +int netdev_get_nest_level_rcu(struct net_device *dev)
 >> +{
 >> +#ifdef CONFIG_LOCKDEP
 >> +	struct net_device *ldev, *next, *now, *dev_stack[MAX_NEST_DEV + 1];
 >> +	struct list_head *niter, *iter, *iter_stack[MAX_NEST_DEV + 1];
 >> +	int cur = 0, max = 0;
 >> +
 >> +	now = dev;
 >> +	iter = &dev->adj_list.lower;
 >> +
 >> +	while (1) {
 >> +		next = NULL;
 >> +		while (1) {
 >> +			ldev = netdev_next_lower_dev_rcu(now, &iter);
 >> +			if (!ldev)
 >> +				break;
 >> +
 >> +			next = ldev;
 >> +			niter = &ldev->adj_list.lower;
 >> +			dev_stack[cur] = now;
 >> +			iter_stack[cur++] = iter;
 >> +			if (max <= cur)
 >> +				max = cur;
 >> +			break;
 >
 > This looks odd. Why a while loop if it's left in the first iteration
 > anyway? The whole loop looks unnecessarily complex. The following
 > should do the same, just in a simpler way (untested!)
 >
 >          while (1) {
 >                  ldev = netdev_next_lower_dev_rcu(now, &iter);
 >                  if (ldev) {
 >                          dev_stack[cur] = now;
 >                          iter_stack[cur++] = iter;
 >                          if (max <= cur)
 >                                  max = cur;
 >                          now = ldev;
 >                          iter = &ldev->adj_list.lower;
 >                  } else {
 >                          if (!cur)
 >                                  break;
 >                          now = dev_stack[--cur];
 >                          iter = iter_stack[cur];
 >                  }
 >          }
 >
 > I know that you just copied the original function.
 > Simplifying the function should be something for a
 > follow-up patch.
 >
 >> +		}
 >> +
 >> +		if (!next) {
 >> +			if (!cur)
 >> +				return max;
 >> +			next = dev_stack[--cur];
 >> +			niter = iter_stack[cur];
 >> +		}
 >> +
 >> +		now = next;
 >> +		iter = niter;
 >> +	}
 >> +
 >> +	return max;
 >> +#else
 >> +	return 0;
 >> +#endif
 >> +}
 >> +EXPORT_SYMBOL_GPL(netdev_get_nest_level_rcu);
 >> +
 >>   int netdev_walk_all_lower_dev_rcu(struct net_device *dev,
 >>   				  int (*fn)(struct net_device *dev,
 >>   					    struct netdev_nested_priv *priv),
 >>
 >

I think you're right.
Your logic is more simple and stable.
If I send a v3 patch, I will use your logic after some tests.

Thanks a lot!
Taehee

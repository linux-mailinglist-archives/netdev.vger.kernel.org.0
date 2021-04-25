Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1961636A8BD
	for <lists+netdev@lfdr.de>; Sun, 25 Apr 2021 20:04:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231205AbhDYSEi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 25 Apr 2021 14:04:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59868 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230329AbhDYSEh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 25 Apr 2021 14:04:37 -0400
Received: from mail-wr1-x42d.google.com (mail-wr1-x42d.google.com [IPv6:2a00:1450:4864:20::42d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7FBCBC061574
        for <netdev@vger.kernel.org>; Sun, 25 Apr 2021 11:03:57 -0700 (PDT)
Received: by mail-wr1-x42d.google.com with SMTP id a4so53459002wrr.2
        for <netdev@vger.kernel.org>; Sun, 25 Apr 2021 11:03:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=to:references:from:subject:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=9OL0OlRXc1nSbmzqegdZimzYL1pFvw5oCivkkb0kv48=;
        b=nf525OSUXYIh0ST8ge8wNjDtu1fSy/7+SZIpae0shKwFRpWy9Yv/E0BMKW27vDj45I
         +xgpiacflDJgH+SR6NLwdDT7lSAwh5mDUWtIEl0SbocarNL/ZQIBvjoqKPue3Wb/4xiE
         BRXUwOD7uO0/CvUneokAb2QgGRNFm2x/JeMBDFcWPkj8nIqWnmjvGNcplo3oPLH5bjhx
         ZCC4Tmog2YbD6c7ZzwP62RheqlDnCiIqas8Y61LtmEFjt02W6f8tFY1T+6oto1kCy4r/
         pNiIJ5MmcN3IRunfth5Hr4R+v8Y87iPPJK3N3BCWePvAYUkyafIpGQdt8FXcfnTLGCfp
         D5PQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:references:from:subject:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=9OL0OlRXc1nSbmzqegdZimzYL1pFvw5oCivkkb0kv48=;
        b=SmtTJ+xUawV3NkEPoxTeywNuttqVHbX3SA7taXZqHibMyDMRyabGW7eH31kixdf/Pc
         SjBPBFJwgV+XOdyTB0C5ZT//NO9B5Uz7Anf8v9ml0yP9aklUGVJX/dNNtVAEoWMYcI3o
         M1sb2/VbH5UdF5wNlacLp2Bsj9Z5C5TMhcsGqbuWkM/EiXGoKy/ROCKFt7XHLGtel8Du
         hO+MabV5/ns3+47agMTG7SrX+U41YKVx4lsAXtNrBMJjwxw+m7ncTU+t7uCi5xPfCYwG
         t0raRUp+EHl8swVeJCTiswFsSnIOz+k6PRY9/zp50xTWNC+ls4rWDUV32ERSIExsljSz
         Hidw==
X-Gm-Message-State: AOAM532L2EFq5H+Dm6/M5fNFwAPKIE+cE+N/Isoj2dZaR/OYl2m1t66D
        4EJ6olFjbQeJSQG/BXYWjzwNRIHRV3TnRQ==
X-Google-Smtp-Source: ABdhPJyrLI3AzvV3yJSg+iI05XbbB/ioRbg+PX/fIanjsIhfOtk4Xj7JmvjWvGfQQq2QGAwLnP+/Qw==
X-Received: by 2002:a5d:638f:: with SMTP id p15mr5090427wru.255.1619373836282;
        Sun, 25 Apr 2021 11:03:56 -0700 (PDT)
Received: from ?IPv6:2003:ea:8f38:4600:29ce:8a0d:b323:586a? (p200300ea8f38460029ce8a0db323586a.dip0.t-ipconnect.de. [2003:ea:8f38:4600:29ce:8a0d:b323:586a])
        by smtp.googlemail.com with ESMTPSA id q20sm43458913wmq.2.2021.04.25.11.03.55
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 25 Apr 2021 11:03:55 -0700 (PDT)
To:     Taehee Yoo <ap420073@gmail.com>, davem@davemloft.net,
        kuba@kernel.org, dsahern@kernel.org, yoshfuji@linux-ipv6.org,
        netdev@vger.kernel.org, j.vosburgh@gmail.com, vfalico@gmail.com,
        andy@greyhouse.net, roopa@nvidia.com, nikolay@nvidia.com,
        ast@kernel.org, andriin@fb.com, daniel@iogearbox.net,
        weiwan@google.com, cong.wang@bytedance.com, bjorn@kernel.org,
        herbert@gondor.apana.org.au, bridge@lists.linux-foundation.org
References: <20210425155742.30057-1-ap420073@gmail.com>
 <20210425155742.30057-2-ap420073@gmail.com>
From:   Heiner Kallweit <hkallweit1@gmail.com>
Subject: Re: [PATCH net v2 1/2] net: core: make bond_get_lowest_level_rcu()
 generic
Message-ID: <d7cf5368-21a4-a551-169a-00a4cb2b3a0d@gmail.com>
Date:   Sun, 25 Apr 2021 20:03:49 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.0
MIME-Version: 1.0
In-Reply-To: <20210425155742.30057-2-ap420073@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 25.04.2021 17:57, Taehee Yoo wrote:
> The purpose of bond_get_lowest_level_rcu() is to get nested_level under
> RCU. Because dev->nested_level is protected by RTNL, so it shouldn't be
> used without RTNL. But bonding module needs this value under RCU without
> RTNL.
> So, this function was added.
> 
> But, there is another module, which needs this function.
> So, make this function generic.
> the new name is netdev_get_nest_level_rcu().
> 
> Signed-off-by: Taehee Yoo <ap420073@gmail.com>
> ---
> 
> v2:
>  - No change
> 
>  drivers/net/bonding/bond_main.c | 45 +--------------------------------
>  include/linux/netdevice.h       |  1 +
>  net/core/dev.c                  | 44 ++++++++++++++++++++++++++++++++
>  3 files changed, 46 insertions(+), 44 deletions(-)
> 
> diff --git a/drivers/net/bonding/bond_main.c b/drivers/net/bonding/bond_main.c
> index 83ef62db6285..a9feb039ffa6 100644
> --- a/drivers/net/bonding/bond_main.c
> +++ b/drivers/net/bonding/bond_main.c
> @@ -3754,47 +3754,6 @@ static void bond_fold_stats(struct rtnl_link_stats64 *_res,
>  	}
>  }
>  
> -#ifdef CONFIG_LOCKDEP
> -static int bond_get_lowest_level_rcu(struct net_device *dev)
> -{
> -	struct net_device *ldev, *next, *now, *dev_stack[MAX_NEST_DEV + 1];
> -	struct list_head *niter, *iter, *iter_stack[MAX_NEST_DEV + 1];
> -	int cur = 0, max = 0;
> -
> -	now = dev;
> -	iter = &dev->adj_list.lower;
> -
> -	while (1) {
> -		next = NULL;
> -		while (1) {
> -			ldev = netdev_next_lower_dev_rcu(now, &iter);
> -			if (!ldev)
> -				break;
> -
> -			next = ldev;
> -			niter = &ldev->adj_list.lower;
> -			dev_stack[cur] = now;
> -			iter_stack[cur++] = iter;
> -			if (max <= cur)
> -				max = cur;
> -			break;
> -		}
> -
> -		if (!next) {
> -			if (!cur)
> -				return max;
> -			next = dev_stack[--cur];
> -			niter = iter_stack[cur];
> -		}
> -
> -		now = next;
> -		iter = niter;
> -	}
> -
> -	return max;
> -}
> -#endif
> -
>  static void bond_get_stats(struct net_device *bond_dev,
>  			   struct rtnl_link_stats64 *stats)
>  {
> @@ -3806,9 +3765,7 @@ static void bond_get_stats(struct net_device *bond_dev,
>  
>  
>  	rcu_read_lock();
> -#ifdef CONFIG_LOCKDEP
> -	nest_level = bond_get_lowest_level_rcu(bond_dev);
> -#endif
> +	nest_level = netdev_get_nest_level_rcu(bond_dev);
>  
>  	spin_lock_nested(&bond->stats_lock, nest_level);
>  	memcpy(stats, &bond->bond_stats, sizeof(*stats));
> diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
> index 87a5d186faff..507c06bf5dba 100644
> --- a/include/linux/netdevice.h
> +++ b/include/linux/netdevice.h
> @@ -4699,6 +4699,7 @@ int netdev_walk_all_lower_dev(struct net_device *dev,
>  			      int (*fn)(struct net_device *lower_dev,
>  					struct netdev_nested_priv *priv),
>  			      struct netdev_nested_priv *priv);
> +int netdev_get_nest_level_rcu(struct net_device *dev);
>  int netdev_walk_all_lower_dev_rcu(struct net_device *dev,
>  				  int (*fn)(struct net_device *lower_dev,
>  					    struct netdev_nested_priv *priv),
> diff --git a/net/core/dev.c b/net/core/dev.c
> index 15fe36332fb8..efc2bf88eafd 100644
> --- a/net/core/dev.c
> +++ b/net/core/dev.c
> @@ -7709,6 +7709,50 @@ static int __netdev_update_lower_level(struct net_device *dev,
>  	return 0;
>  }
>  
> +int netdev_get_nest_level_rcu(struct net_device *dev)
> +{
> +#ifdef CONFIG_LOCKDEP
> +	struct net_device *ldev, *next, *now, *dev_stack[MAX_NEST_DEV + 1];
> +	struct list_head *niter, *iter, *iter_stack[MAX_NEST_DEV + 1];
> +	int cur = 0, max = 0;
> +
> +	now = dev;
> +	iter = &dev->adj_list.lower;
> +
> +	while (1) {
> +		next = NULL;
> +		while (1) {
> +			ldev = netdev_next_lower_dev_rcu(now, &iter);
> +			if (!ldev)
> +				break;
> +
> +			next = ldev;
> +			niter = &ldev->adj_list.lower;
> +			dev_stack[cur] = now;
> +			iter_stack[cur++] = iter;
> +			if (max <= cur)
> +				max = cur;
> +			break;

This looks odd. Why a while loop if it's left in the first iteration
anyway? The whole loop looks unnecessarily complex. The following
should do the same, just in a simpler way (untested!)

        while (1) {
                ldev = netdev_next_lower_dev_rcu(now, &iter);
                if (ldev) {
                        dev_stack[cur] = now;
                        iter_stack[cur++] = iter;
                        if (max <= cur)
                                max = cur;
                        now = ldev;
                        iter = &ldev->adj_list.lower;
                } else {
                        if (!cur)
                                break;
                        now = dev_stack[--cur];
                        iter = iter_stack[cur];
                }
        }

I know that you just copied the original function.
Simplifying the function should be something for a
follow-up patch.

> +		}
> +
> +		if (!next) {
> +			if (!cur)
> +				return max;
> +			next = dev_stack[--cur];
> +			niter = iter_stack[cur];
> +		}
> +
> +		now = next;
> +		iter = niter;
> +	}
> +
> +	return max;
> +#else
> +	return 0;
> +#endif
> +}
> +EXPORT_SYMBOL_GPL(netdev_get_nest_level_rcu);
> +
>  int netdev_walk_all_lower_dev_rcu(struct net_device *dev,
>  				  int (*fn)(struct net_device *dev,
>  					    struct netdev_nested_priv *priv),
> 


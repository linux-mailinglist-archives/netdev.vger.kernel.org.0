Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3277E1E2510
	for <lists+netdev@lfdr.de>; Tue, 26 May 2020 17:10:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729631AbgEZPKF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 May 2020 11:10:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52876 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728166AbgEZPKE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 26 May 2020 11:10:04 -0400
Received: from mail-wm1-x343.google.com (mail-wm1-x343.google.com [IPv6:2a00:1450:4864:20::343])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8C2B9C03E96D
        for <netdev@vger.kernel.org>; Tue, 26 May 2020 08:10:03 -0700 (PDT)
Received: by mail-wm1-x343.google.com with SMTP id v19so3504345wmj.0
        for <netdev@vger.kernel.org>; Tue, 26 May 2020 08:10:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cumulusnetworks.com; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=ZWqxKtratSFfhueLuPsutzJZC8p/KvoEe/D08BzsjYY=;
        b=KButwarusdo2Ms9mXJDVfFlLyCLDJt9bvrVyYEDb83s4NnY+mVrcHYWGT9s4ANRbRg
         SMCXqtjitDLpIS+zvAPSUMT+I/fcL/3tfu22uJIZ3bzmUvYccCr3nmluvgkglTSezbA7
         QkbymOPNWMEJbinKbL+ynlvTP9EuHfF7+TWnk=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=ZWqxKtratSFfhueLuPsutzJZC8p/KvoEe/D08BzsjYY=;
        b=EV7MZyxqe0Qoiq+ZvKnp5wg3KgUAUU5sp4bSqrJbvmGpmEwFsSPtKRha38f6oyNOd8
         4YRa7royjIBqKaGQuQZ+bevH5XoS0QXysz7yhwKf9gmUCY37PW7wk1bf53eAzWA+PfT7
         +940SqytJNfvD3n+AEODgYuOeXGk69Q7dozUHgKM211Ix7HhFZJdEMOsWYR6oHYDGZ8n
         R/UOKhLFqnbH4M19omdjuOl+tUHMNqyo62EaJZBzythup6fNyPbvBwmdyXDygxjy7z6i
         m21W1WeiNuWic1qJH54OiSsb1ByaKyML8OiO1cx4Zaf30kjFXiL39aJByulUJDlKpDdh
         /7EQ==
X-Gm-Message-State: AOAM533ABRzHBrjSHB4kUI/rM+VEcPisfWvPiSwiUYv18xA5trxr68BY
        wNNtHO2A1nmZv4czksds83JQ9g==
X-Google-Smtp-Source: ABdhPJw7o9vgc4vT7M9EeD6RjxMGv56DuMoUVnFMVpTTg6ZiISVsdO5SisSK7MSuMhE6Fou1xNyITg==
X-Received: by 2002:a1c:5a86:: with SMTP id o128mr1872786wmb.77.1590505802351;
        Tue, 26 May 2020 08:10:02 -0700 (PDT)
Received: from [192.168.0.109] (84-238-136-197.ip.btc-net.bg. [84.238.136.197])
        by smtp.gmail.com with ESMTPSA id u4sm1432048wmb.48.2020.05.26.08.10.00
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 26 May 2020 08:10:01 -0700 (PDT)
Subject: Re: [PATCH net 5/5] ipv4: nexthop version of fib_info_nh_uses_dev
To:     David Ahern <dsahern@kernel.org>, netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org,
        David Ahern <dsahern@gmail.com>
References: <20200526150114.41687-1-dsahern@kernel.org>
 <20200526150114.41687-6-dsahern@kernel.org>
From:   Nikolay Aleksandrov <nikolay@cumulusnetworks.com>
Message-ID: <b4458d2c-6957-3adf-0553-6afcf2df7d42@cumulusnetworks.com>
Date:   Tue, 26 May 2020 18:10:00 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <20200526150114.41687-6-dsahern@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 26/05/2020 18:01, David Ahern wrote:
> From: David Ahern <dsahern@gmail.com>
> 
> Similar to the last path, need to fix fib_info_nh_uses_dev for
> external nexthops to avoid referencing multiple nh_grp structs.
> Move the device check in fib_info_nh_uses_dev to a helper and
> create a nexthop version that is called if the fib_info uses an
> external nexthop.
> 
> Fixes: 430a049190de ("nexthop: Add support for nexthop groups")
> Signed-off-by: David Ahern <dsahern@gmail.com>
> ---
>  include/net/ip_fib.h    | 10 ++++++++++
>  include/net/nexthop.h   | 25 +++++++++++++++++++++++++
>  net/ipv4/fib_frontend.c | 19 ++++++++++---------
>  3 files changed, 45 insertions(+), 9 deletions(-)
> 

Acked-by: Nikolay Aleksandrov <nikolay@cumulusnetworks.com>

> diff --git a/include/net/ip_fib.h b/include/net/ip_fib.h
> index 1f1dd22980e4..6683558db7c9 100644
> --- a/include/net/ip_fib.h
> +++ b/include/net/ip_fib.h
> @@ -448,6 +448,16 @@ static inline int fib_num_tclassid_users(struct net *net)
>  #endif
>  int fib_unmerge(struct net *net);
>  
> +static inline bool nhc_l3mdev_matches_dev(const struct fib_nh_common *nhc,
> +const struct net_device *dev)
> +{
> +	if (nhc->nhc_dev == dev ||
> +	    l3mdev_master_ifindex_rcu(nhc->nhc_dev) == dev->ifindex)
> +			return true;
> +
> +	return false;
> +}
> +
>  /* Exported by fib_semantics.c */
>  int ip_fib_check_default(__be32 gw, struct net_device *dev);
>  int fib_sync_down_dev(struct net_device *dev, unsigned long event, bool force);
> diff --git a/include/net/nexthop.h b/include/net/nexthop.h
> index 9414ae46fc1c..35680a8c2a1c 100644
> --- a/include/net/nexthop.h
> +++ b/include/net/nexthop.h
> @@ -266,6 +266,31 @@ struct fib_nh_common *nexthop_get_nhc_lookup(const struct nexthop *nh,
>  	return NULL;
>  }
>  
> +static inline bool nexthop_uses_dev(const struct nexthop *nh,
> +				    const struct net_device *dev)
> +{
> +	struct nh_info *nhi;
> +
> +	if (nh->is_group) {
> +		struct nh_group *nhg = rcu_dereference(nh->nh_grp);
> +		int i;
> +
> +		for (i = 0; i < nhg->num_nh; i++) {
> +			struct nexthop *nhe = nhg->nh_entries[i].nh;
> +
> +			nhi = rcu_dereference(nhe->nh_info);
> +			if (nhc_l3mdev_matches_dev(&nhi->fib_nhc, dev))
> +				return true;
> +                }
> +        } else {
> +		nhi = rcu_dereference(nh->nh_info);
> +		if (nhc_l3mdev_matches_dev(&nhi->fib_nhc, dev))
> +			return true;
> +        }
> +
> +	return false;
> +}
> +
>  static inline unsigned int fib_info_num_path(const struct fib_info *fi)
>  {
>  	if (unlikely(fi->nh))
> diff --git a/net/ipv4/fib_frontend.c b/net/ipv4/fib_frontend.c
> index 213be9c050ad..aebb50735c68 100644
> --- a/net/ipv4/fib_frontend.c
> +++ b/net/ipv4/fib_frontend.c
> @@ -309,17 +309,18 @@ bool fib_info_nh_uses_dev(struct fib_info *fi, const struct net_device *dev)
>  {
>  	bool dev_match = false;
>  #ifdef CONFIG_IP_ROUTE_MULTIPATH
> -	int ret;
> +	if (unlikely(fi->nh)) {
> +		dev_match = nexthop_uses_dev(fi->nh, dev);
> +	} else {
> +		int ret;
>  
> -	for (ret = 0; ret < fib_info_num_path(fi); ret++) {
> -		const struct fib_nh_common *nhc = fib_info_nhc(fi, ret);
> +		for (ret = 0; ret < fib_info_num_path(fi); ret++) {
> +			const struct fib_nh_common *nhc = fib_info_nhc(fi, ret);
>  
> -		if (nhc->nhc_dev == dev) {
> -			dev_match = true;
> -			break;
> -		} else if (l3mdev_master_ifindex_rcu(nhc->nhc_dev) == dev->ifindex) {
> -			dev_match = true;
> -			break;
> +			if (nhc_l3mdev_matches_dev(nhc, dev)) {
> +				dev_match = true;
> +				break;
> +			}
>  		}
>  	}
>  #else
> 


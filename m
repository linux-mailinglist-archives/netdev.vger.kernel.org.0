Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 09B6C1E24F4
	for <lists+netdev@lfdr.de>; Tue, 26 May 2020 17:07:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729385AbgEZPHe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 May 2020 11:07:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52482 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728205AbgEZPHe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 26 May 2020 11:07:34 -0400
Received: from mail-wm1-x343.google.com (mail-wm1-x343.google.com [IPv6:2a00:1450:4864:20::343])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A3928C03E96D
        for <netdev@vger.kernel.org>; Tue, 26 May 2020 08:07:33 -0700 (PDT)
Received: by mail-wm1-x343.google.com with SMTP id c71so3470452wmd.5
        for <netdev@vger.kernel.org>; Tue, 26 May 2020 08:07:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cumulusnetworks.com; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=jRMe2Agckd+9zqw+cPfu8pBAWUruno/pEek/W83qQjQ=;
        b=IbBG81d/DgkALMuN2q6ob32VJ8xgOM7xF5WoeW06GxSbp+7Drh/YuRMasNi46h8sIZ
         pplgDqelDRnkLBWYHNlbXomCPgLmSgpP9b5vA2mQdDLJypiumBACHo7o+bqxgjk151P7
         HEGVykGTrejPQuJklEs0lPrmZ2LSvHF6sHA8g=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=jRMe2Agckd+9zqw+cPfu8pBAWUruno/pEek/W83qQjQ=;
        b=ttP7C2YAHGamdNj+GOCA/8yZhYjoego0JLN3MOJtpfaVRfgVK4JyfOTvUx4Gv+cgOj
         An4HJNUNR8MHa3VKxjBnvyIeMahZ3tZA0sjJS36rA4CVYcYV3TpcBrqG0OzyYp2ese3w
         qiLb6kQLXU1Rzf5zUS+5gLHqJZme9szOPKEmwKXtqp2oavxXrClrRUmTaQtA1u6T9VT3
         hHyhAfaVAoyaGMV8MxNj4+ci8bb7/a14SW44VEqDdG+Wai/9f7t7Wz5udf+IvJm27FCq
         HUQoTZsqlKwrPogZT1q1+jHsOtGQJZZoBIxy7NtgYWUeHMfPndy4RZzSvw/1j6g4Trej
         PuQg==
X-Gm-Message-State: AOAM530sfwL0xk/l6BGCdiTrU6u2fXOn5phv/5KqTsdLbCju7LTwzBxR
        SnJtXxg9MsqQ0LC/jJ8GdJMH3A==
X-Google-Smtp-Source: ABdhPJwBsO2WJFPIC7e77zvHUIx+fcdoPOnIOPfpS7sM3yNxQSKSDWBMT/KxBGBgwjAPlrln0YrRrQ==
X-Received: by 2002:a05:600c:1:: with SMTP id g1mr1780101wmc.142.1590505652289;
        Tue, 26 May 2020 08:07:32 -0700 (PDT)
Received: from [192.168.0.109] (84-238-136-197.ip.btc-net.bg. [84.238.136.197])
        by smtp.gmail.com with ESMTPSA id q1sm7363726wmj.9.2020.05.26.08.07.30
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 26 May 2020 08:07:31 -0700 (PDT)
Subject: Re: [PATCH net 1/5] nexthops: Move code from
 remove_nexthop_from_groups to remove_nh_grp_entry
To:     David Ahern <dsahern@kernel.org>, netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org,
        David Ahern <dsahern@gmail.com>
References: <20200526150114.41687-1-dsahern@kernel.org>
 <20200526150114.41687-2-dsahern@kernel.org>
From:   Nikolay Aleksandrov <nikolay@cumulusnetworks.com>
Message-ID: <c5667ed4-d50d-76b0-292b-503d51c3cd7f@cumulusnetworks.com>
Date:   Tue, 26 May 2020 18:07:30 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <20200526150114.41687-2-dsahern@kernel.org>
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
> Move nh_grp dereference and check for removing nexthop group due to
> all members gone into remove_nh_grp_entry.
> 
> Fixes: 430a049190de ("nexthop: Add support for nexthop groups")
> Signed-off-by: David Ahern <dsahern@gmail.com>
> ---
>  net/ipv4/nexthop.c | 27 +++++++++++++--------------
>  1 file changed, 13 insertions(+), 14 deletions(-)
> 

Acked-by: Nikolay Aleksandrov <nikolay@cumulusnetworks.com>

> diff --git a/net/ipv4/nexthop.c b/net/ipv4/nexthop.c
> index 2a31c4af845e..0f68d9801808 100644
> --- a/net/ipv4/nexthop.c
> +++ b/net/ipv4/nexthop.c
> @@ -693,17 +693,21 @@ static void nh_group_rebalance(struct nh_group *nhg)
>  	}
>  }
>  
> -static void remove_nh_grp_entry(struct nh_grp_entry *nhge,
> -				struct nh_group *nhg,
> +static void remove_nh_grp_entry(struct net *net, struct nh_grp_entry *nhge,
>  				struct nl_info *nlinfo)
>  {
> +	struct nexthop *nhp = nhge->nh_parent;
>  	struct nexthop *nh = nhge->nh;
>  	struct nh_grp_entry *nhges;
> +	struct nh_group *nhg;
>  	bool found = false;
>  	int i;
>  
>  	WARN_ON(!nh);
>  
> +	list_del(&nhge->nh_list);
> +
> +	nhg = rtnl_dereference(nhp->nh_grp);
>  	nhges = nhg->nh_entries;
>  	for (i = 0; i < nhg->num_nh; ++i) {
>  		if (found) {
> @@ -727,7 +731,11 @@ static void remove_nh_grp_entry(struct nh_grp_entry *nhge,
>  	nexthop_put(nh);
>  
>  	if (nlinfo)
> -		nexthop_notify(RTM_NEWNEXTHOP, nhge->nh_parent, nlinfo);
> +		nexthop_notify(RTM_NEWNEXTHOP, nhp, nlinfo);
> +
> +	/* if this group has no more entries then remove it */
> +	if (!nhg->num_nh)
> +		remove_nexthop(net, nhp, nlinfo);
>  }
>  
>  static void remove_nexthop_from_groups(struct net *net, struct nexthop *nh,
> @@ -735,17 +743,8 @@ static void remove_nexthop_from_groups(struct net *net, struct nexthop *nh,
>  {
>  	struct nh_grp_entry *nhge, *tmp;
>  
> -	list_for_each_entry_safe(nhge, tmp, &nh->grp_list, nh_list) {
> -		struct nh_group *nhg;
> -
> -		list_del(&nhge->nh_list);
> -		nhg = rtnl_dereference(nhge->nh_parent->nh_grp);
> -		remove_nh_grp_entry(nhge, nhg, nlinfo);
> -
> -		/* if this group has no more entries then remove it */
> -		if (!nhg->num_nh)
> -			remove_nexthop(net, nhge->nh_parent, nlinfo);
> -	}
> +	list_for_each_entry_safe(nhge, tmp, &nh->grp_list, nh_list)
> +		remove_nh_grp_entry(net, nhge, nlinfo);
>  }
>  
>  static void remove_nexthop_group(struct nexthop *nh, struct nl_info *nlinfo)
> 


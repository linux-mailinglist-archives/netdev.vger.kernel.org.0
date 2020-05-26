Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5F5871E2503
	for <lists+netdev@lfdr.de>; Tue, 26 May 2020 17:08:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729854AbgEZPIV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 May 2020 11:08:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52602 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728166AbgEZPIV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 26 May 2020 11:08:21 -0400
Received: from mail-wm1-x341.google.com (mail-wm1-x341.google.com [IPv6:2a00:1450:4864:20::341])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D6858C03E96D
        for <netdev@vger.kernel.org>; Tue, 26 May 2020 08:08:19 -0700 (PDT)
Received: by mail-wm1-x341.google.com with SMTP id u13so3493980wml.1
        for <netdev@vger.kernel.org>; Tue, 26 May 2020 08:08:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cumulusnetworks.com; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=+kLxyT/PjROhQ9hjFK4vO6Gv1fHPKBD4OXzH6+45LL4=;
        b=gMcBMDHoxpsiCxeilpX/R7WkopOqaqAt/WQ2MuU7bwXiiO/YUObMDNCDYuk6gPOwNk
         UsF4HXF85YreUqMcul3H4GAGIxpGqDQYiuhoJSJuswxAfiOACgg4y0QO3kSAfr5h5Hid
         DEjNaqE/8pm8i1T6wx7lUZoBStX3XMmtr8Ctw=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=+kLxyT/PjROhQ9hjFK4vO6Gv1fHPKBD4OXzH6+45LL4=;
        b=X/dVjmIINGQ7tMgN72jjzw39+VRvgPZBbcSvfbydC6BIoSVq4OordEbkTQnDe5lSrD
         4Nc4qYcAjoLY9u19xzPrMUqjWGtAgy2EUI1pR14UOI3ORAMcx8Rv3/Eb1LCkfYnS+XyE
         uogBrxlKpiq3nyfKq1ijF3cIFzGxU3QtklqZMCqBOCfwOcXRgu0pujN9lhJVZ96+2YiK
         QFOBY6miXD7ejCPx8V/yVrcrJ/tRJ1lIhAK2HkKebTIIQ8iKwUVLdTlTyJtH5jrFnMBH
         vWrVzElNXc+M41aupVh1PkVH+Pa1qB1a0HCIp7wlQKzi/fSDSsLOzVI3lpDd14Vojy9K
         z0zQ==
X-Gm-Message-State: AOAM532dfgzTXQJMPEjgruprqwE+QT5ATrLCnLBIYnRxawalFMotBytm
        j72w3uwQcFDsX76V0bZ0izcMbQ==
X-Google-Smtp-Source: ABdhPJxhY9dQ64ZFFbZ/GCBdOs9phqlJnfq7VQ2PKAcN28xpN65LIa9RtzyWGqhVFBOTjO1SU0WyAQ==
X-Received: by 2002:a1c:98cc:: with SMTP id a195mr1931953wme.32.1590505698558;
        Tue, 26 May 2020 08:08:18 -0700 (PDT)
Received: from [192.168.0.109] (84-238-136-197.ip.btc-net.bg. [84.238.136.197])
        by smtp.gmail.com with ESMTPSA id t13sm133852wrn.64.2020.05.26.08.08.16
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 26 May 2020 08:08:17 -0700 (PDT)
Subject: Re: [PATCH net 3/5] nexthop: Expand nexthop_is_multipath in a few
 places
To:     David Ahern <dsahern@kernel.org>, netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org,
        David Ahern <dsahern@gmail.com>
References: <20200526150114.41687-1-dsahern@kernel.org>
 <20200526150114.41687-4-dsahern@kernel.org>
From:   Nikolay Aleksandrov <nikolay@cumulusnetworks.com>
Message-ID: <0fa0d437-dcfe-8326-dca6-c0e54a1a0009@cumulusnetworks.com>
Date:   Tue, 26 May 2020 18:08:15 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <20200526150114.41687-4-dsahern@kernel.org>
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
> I got too fancy consolidating checks on multipath type. The result
> is that path lookups can access 2 different nh_grp structs as exposed
> by Nik's torture tests. Expand nexthop_is_multipath within nexthop.h to
> avoid multiple, nh_grp dereferences and make decisions based on the
> consistent struct.
> 
> Only 2 places left using nexthop_is_multipath are within IPv6, both
> only check that the nexthop is a multipath for a branching decision
> which are acceptable.
> 
> Fixes: 430a049190de ("nexthop: Add support for nexthop groups")
> Signed-off-by: David Ahern <dsahern@gmail.com>
> ---
>  include/net/nexthop.h | 41 +++++++++++++++++++++++++----------------
>  1 file changed, 25 insertions(+), 16 deletions(-)
> 

Acked-by: Nikolay Aleksandrov <nikolay@cumulusnetworks.com>

> diff --git a/include/net/nexthop.h b/include/net/nexthop.h
> index 8a343519ed7a..f09e8d7d9886 100644
> --- a/include/net/nexthop.h
> +++ b/include/net/nexthop.h
> @@ -137,21 +137,20 @@ static inline unsigned int nexthop_num_path(const struct nexthop *nh)
>  {
>  	unsigned int rc = 1;
>  
> -	if (nexthop_is_multipath(nh)) {
> +	if (nh->is_group) {
>  		struct nh_group *nh_grp;
>  
>  		nh_grp = rcu_dereference_rtnl(nh->nh_grp);
> -		rc = nh_grp->num_nh;
> +		if (nh_grp->mpath)
> +			rc = nh_grp->num_nh;
>  	}
>  
>  	return rc;
>  }
>  
>  static inline
> -struct nexthop *nexthop_mpath_select(const struct nexthop *nh, int nhsel)
> +struct nexthop *nexthop_mpath_select(const struct nh_group *nhg, int nhsel)
>  {
> -	const struct nh_group *nhg = rcu_dereference_rtnl(nh->nh_grp);
> -
>  	/* for_nexthops macros in fib_semantics.c grabs a pointer to
>  	 * the nexthop before checking nhsel
>  	 */
> @@ -186,12 +185,14 @@ static inline bool nexthop_is_blackhole(const struct nexthop *nh)
>  {
>  	const struct nh_info *nhi;
>  
> -	if (nexthop_is_multipath(nh)) {
> -		if (nexthop_num_path(nh) > 1)
> -			return false;
> -		nh = nexthop_mpath_select(nh, 0);
> -		if (!nh)
> +	if (nh->is_group) {
> +		struct nh_group *nh_grp;
> +
> +		nh_grp = rcu_dereference_rtnl(nh->nh_grp);
> +		if (nh_grp->num_nh > 1)
>  			return false;
> +
> +		nh = nh_grp->nh_entries[0].nh;
>  	}
>  
>  	nhi = rcu_dereference_rtnl(nh->nh_info);
> @@ -217,10 +218,15 @@ struct fib_nh_common *nexthop_fib_nhc(struct nexthop *nh, int nhsel)
>  	BUILD_BUG_ON(offsetof(struct fib_nh, nh_common) != 0);
>  	BUILD_BUG_ON(offsetof(struct fib6_nh, nh_common) != 0);
>  
> -	if (nexthop_is_multipath(nh)) {
> -		nh = nexthop_mpath_select(nh, nhsel);
> -		if (!nh)
> -			return NULL;
> +	if (nh->is_group) {
> +		struct nh_group *nh_grp;
> +
> +		nh_grp = rcu_dereference_rtnl(nh->nh_grp);
> +		if (nh_grp->mpath) {
> +			nh = nexthop_mpath_select(nh_grp, nhsel);
> +			if (!nh)
> +				return NULL;
> +		}
>  	}
>  
>  	nhi = rcu_dereference_rtnl(nh->nh_info);
> @@ -264,8 +270,11 @@ static inline struct fib6_nh *nexthop_fib6_nh(struct nexthop *nh)
>  {
>  	struct nh_info *nhi;
>  
> -	if (nexthop_is_multipath(nh)) {
> -		nh = nexthop_mpath_select(nh, 0);
> +	if (nh->is_group) {
> +		struct nh_group *nh_grp;
> +
> +		nh_grp = rcu_dereference_rtnl(nh->nh_grp);
> +		nh = nexthop_mpath_select(nh_grp, 0);
>  		if (!nh)
>  			return NULL;
>  	}
> 


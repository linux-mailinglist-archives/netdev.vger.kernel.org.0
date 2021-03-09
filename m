Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5A23C331D21
	for <lists+netdev@lfdr.de>; Tue,  9 Mar 2021 03:48:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230027AbhCICr4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Mar 2021 21:47:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48072 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229694AbhCICre (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 8 Mar 2021 21:47:34 -0500
Received: from mail-il1-x12e.google.com (mail-il1-x12e.google.com [IPv6:2607:f8b0:4864:20::12e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 57024C06174A
        for <netdev@vger.kernel.org>; Mon,  8 Mar 2021 18:47:34 -0800 (PST)
Received: by mail-il1-x12e.google.com with SMTP id e7so10824029ile.7
        for <netdev@vger.kernel.org>; Mon, 08 Mar 2021 18:47:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=6uUJE1WeVsOHi3KGmU9QrNU7s/tFgygUoHaH+vDFSwo=;
        b=h6umS0iRo1/tPR/9EUZDRU+krO+hNuoBFB2lZszxw6nOtc2JwhQ6KXX2aAF/864Bm8
         3PBTF/kTWbpM1dEVySKglT+zFRn6L2oUrWJi4q2SIHLRHDQWxYrD+kNcKwwBAUtdcvcG
         fQYuu36kcqZFX1sI08QEpjACHyoTm2AqSxFFsy5AjmPk+HUnGElISvnNM6IhRFpxjwc7
         p0tUZ4ge5cMg6b27bo2lMrVosCT4uvHJSWSkAcOP/BZJaL0sERPdHwiapLPhaVFOlBdr
         HoqhbI/1KBN8o9LnS8sZ9Pl9EdzObmnmkS1MieEc8rLHGU3ucRCjaY2XKSOir/kd7k4D
         wlPg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=6uUJE1WeVsOHi3KGmU9QrNU7s/tFgygUoHaH+vDFSwo=;
        b=unWJCvjY/hY3MTBnBSxwVtehTy2F/0ObV23hTR7rcPgLnGr/K777E9EPhZAdxYdTIX
         mkq0qm5QwKB/DsIZr2S+e25zNcIK2auCc2B1tZcwsB3O2BDqU8o0+LtxoOC4ww49H3aA
         rgcrPeC+YVVU5lSCzEld7vF2PHDnWGNbOPINB9NV32/pc4wtVxqacpyMqyd37COSkOX1
         swqjMxYU5ASkka2hI3D4ZSFnq8CvlClIlCeHbt27nSjFRPN8W7eR9vgvr/1rWX3t5aLE
         uuHQpCbLgmE/uyzP9m+0/zF4eOwkgayyTFWazGluev+fUXqTihSWpcUfN4oQFsrx1EmH
         HXlw==
X-Gm-Message-State: AOAM532Sa2LLME40KkFpCBq/cBXlgtHq1s/YerfA+jubTkmdex5XUK95
        VjsB4XyOLUqMrTAQxjzmZck=
X-Google-Smtp-Source: ABdhPJxAOvSrjZFFMGbDw/kzfg5XFXqmx9pqiWCW0HCdecUksHsXYoOOeBUjBvnJyf3gu8HnytiRng==
X-Received: by 2002:a92:dc01:: with SMTP id t1mr22576697iln.192.1615258053780;
        Mon, 08 Mar 2021 18:47:33 -0800 (PST)
Received: from Davids-MacBook-Pro.local ([8.48.134.40])
        by smtp.googlemail.com with ESMTPSA id j12sm6811031ila.75.2021.03.08.18.47.32
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 08 Mar 2021 18:47:33 -0800 (PST)
Subject: Re: [PATCH net] ipv6: fix suspecious RCU usage warning
To:     Wei Wang <weiwan@google.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        Ido Schimmel <idosch@nvidia.com>,
        Petr Machata <petrm@nvidia.com>
Cc:     syzbot <syzkaller@googlegroups.com>,
        David Ahern <dsahern@kernel.org>,
        Eric Dumazet <edumazet@google.com>
References: <20210308192113.2721435-1-weiwan@google.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <0d18e982-93de-5b88-b3a5-efb6ebd200f2@gmail.com>
Date:   Mon, 8 Mar 2021 19:47:31 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.16; rv:78.0)
 Gecko/20100101 Thunderbird/78.8.0
MIME-Version: 1.0
In-Reply-To: <20210308192113.2721435-1-weiwan@google.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

[ cc Ido and Petr ]

On 3/8/21 12:21 PM, Wei Wang wrote:
> diff --git a/include/net/nexthop.h b/include/net/nexthop.h
> index 7bc057aee40b..48956b144689 100644
> --- a/include/net/nexthop.h
> +++ b/include/net/nexthop.h
> @@ -410,31 +410,39 @@ static inline struct fib_nh *fib_info_nh(struct fib_info *fi, int nhsel)
>  int fib6_check_nexthop(struct nexthop *nh, struct fib6_config *cfg,
>  		       struct netlink_ext_ack *extack);
>  
> -static inline struct fib6_nh *nexthop_fib6_nh(struct nexthop *nh)
> +static inline struct fib6_nh *nexthop_fib6_nh(struct nexthop *nh,
> +					      bool bh_disabled)

Hi Wei: I would prefer not to have a second argument to nexthop_fib6_nh
for 1 code path, and a control path at that.

>  {
>  	struct nh_info *nhi;
>  
>  	if (nh->is_group) {
>  		struct nh_group *nh_grp;
>  
> -		nh_grp = rcu_dereference_rtnl(nh->nh_grp);
> +		if (bh_disabled)
> +			nh_grp = rcu_dereference_bh_rtnl(nh->nh_grp);
> +		else
> +			nh_grp = rcu_dereference_rtnl(nh->nh_grp);
>  		nh = nexthop_mpath_select(nh_grp, 0);
>  		if (!nh)
>  			return NULL;
>  	}
>  
> -	nhi = rcu_dereference_rtnl(nh->nh_info);
> +	if (bh_disabled)
> +		nhi = rcu_dereference_bh_rtnl(nh->nh_info);
> +	else
> +		nhi = rcu_dereference_rtnl(nh->nh_info);
>  	if (nhi->family == AF_INET6)
>  		return &nhi->fib6_nh;
>  
>  	return NULL;
>  }
>  

I am wary of duplicating code, but this helper is simple enough that it
should be ok with proper documentation.

Ido/Petr: I think your resilient hashing patch set touches this helper.
How ugly does it get to have a second version?

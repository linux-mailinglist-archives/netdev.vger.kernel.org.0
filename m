Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2E683253814
	for <lists+netdev@lfdr.de>; Wed, 26 Aug 2020 21:16:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726988AbgHZTQP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Aug 2020 15:16:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47342 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728009AbgHZTP4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Aug 2020 15:15:56 -0400
Received: from mail-il1-x142.google.com (mail-il1-x142.google.com [IPv6:2607:f8b0:4864:20::142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4E0BFC061757
        for <netdev@vger.kernel.org>; Wed, 26 Aug 2020 12:15:56 -0700 (PDT)
Received: by mail-il1-x142.google.com with SMTP id t4so2797680iln.1
        for <netdev@vger.kernel.org>; Wed, 26 Aug 2020 12:15:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=aIzS3e5VSptv517Fs+LdEWd11MIHR1n2VNOHOD5Aosc=;
        b=fqoWEKqvyCiNKnt39/Qx45qlFObGY+3+PFnruujCOay7RgAlbewRJF4E7D4E+YLAhq
         0fDsVSet7YmyXsXC215dFmrqFtDxyTaMqUSqgIZCUUTzbr2ZJSoK3Wx50O+hT2As3kZT
         3TDXQAyJ9vZiUCPEEzLfb6WbaA9uE0qr+90HCBjBJSgd/oanGLBO6nJx1yj1E3tbK744
         vF4ADFA03U3FkWHreSTccp6a/a0B8YvOEcd9V0DzWMIVY5zXKa3j1Fl95NzMwi62Wwnt
         DIibfAbMPwbwqRB1oKadd0gm5cVTKCEoWPWJcLewtIpCTEx3YrlkHa8VFlOARkK+KKjG
         69lw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=aIzS3e5VSptv517Fs+LdEWd11MIHR1n2VNOHOD5Aosc=;
        b=GIAm00KODiRs0aC/nKltE454a0LOclj2nPJXDv+lYYl4nHasWMB16zQeActuudA6xY
         /LqX3BuQsjDyjpsCkWUngl7MdjQ99mGiaUcit49BPmB/pe9/AoXpKTe67acC/NLous14
         EjMRbraJg6ixVuxvx+YM+nKaMrvnd9X9rMkCaG6V7cVgDCj2PgLiC6CWAGbcfUd04Af0
         6fcZkRwh0V855g5loIR3JBlbwFvqvbiciBEfk41t/5yevJVy4E0N/044neZtlx5nOZSZ
         DpVqEj57Rr7wAEqM5hkVz6Rt2lXDmX9BJuShaE6m8CDELzzHkNZLvdSg1SKn75f1+eLp
         /KlA==
X-Gm-Message-State: AOAM5320MYs60LiwqKvUavc1M55axEb/OOs9Jmb/JTBOxMpJdczdTZDk
        3GpJBz71UkJI1L7epxd3Bbk=
X-Google-Smtp-Source: ABdhPJwByBW9G86kgP2AFOEvDBVg4VyVWaFkbrxUY9sWeJVVcxEffxV7tPcGg/fbNArgJ9/t8IMf6Q==
X-Received: by 2002:a05:6e02:82:: with SMTP id l2mr14418999ilm.130.1598469355706;
        Wed, 26 Aug 2020 12:15:55 -0700 (PDT)
Received: from Davids-MacBook-Pro.local ([2601:282:803:7700:305a:ae30:42e4:e2ca])
        by smtp.googlemail.com with ESMTPSA id e22sm1596897ioc.43.2020.08.26.12.15.54
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 26 Aug 2020 12:15:55 -0700 (PDT)
Subject: Re: [PATCH net-next 6/7] ipv4: nexthop: Correctly update nexthop
 group when replacing a nexthop
To:     Ido Schimmel <idosch@idosch.org>, netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, mlxsw@nvidia.com,
        Ido Schimmel <idosch@nvidia.com>
References: <20200826164857.1029764-1-idosch@idosch.org>
 <20200826164857.1029764-7-idosch@idosch.org>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <7a5f541e-c11c-30a0-9210-7d440443c1c6@gmail.com>
Date:   Wed, 26 Aug 2020 13:15:54 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.11.0
MIME-Version: 1.0
In-Reply-To: <20200826164857.1029764-7-idosch@idosch.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 8/26/20 10:48 AM, Ido Schimmel wrote:
> From: Ido Schimmel <idosch@nvidia.com>
> 
> Each nexthop group contains an indication if it has IPv4 nexthops
> ('has_v4'). Its purpose is to prevent IPv6 routes from using groups with
> IPv4 nexthops.
> 
> However, the indication is not updated when a nexthop is replaced. This
> results in the kernel wrongly rejecting IPv6 routes from pointing to
> groups that only contain IPv6 nexthops. Example:
> 
> # ip nexthop replace id 1 via 192.0.2.2 dev dummy10
> # ip nexthop replace id 10 group 1
> # ip nexthop replace id 1 via 2001:db8:1::2 dev dummy10
> # ip route replace 2001:db8:10::/64 nhid 10
> Error: IPv6 routes can not use an IPv4 nexthop.
> 
> Solve this by iterating over all the nexthop groups that the replaced
> nexthop is a member of and potentially update their IPv4 indication
> according to the new set of member nexthops.
> 
> Avoid wasting cycles by only performing the update in case an IPv4
> nexthop is replaced by an IPv6 nexthop.
> 
> Signed-off-by: Ido Schimmel <idosch@nvidia.com>
> ---
>  net/ipv4/nexthop.c | 32 ++++++++++++++++++++++++++++++++
>  1 file changed, 32 insertions(+)
> 
> diff --git a/net/ipv4/nexthop.c b/net/ipv4/nexthop.c
> index 5199a2815df6..bf9d4cd2d6e5 100644
> --- a/net/ipv4/nexthop.c
> +++ b/net/ipv4/nexthop.c
> @@ -964,6 +964,23 @@ static int replace_nexthop_grp(struct net *net, struct nexthop *old,
>  	return 0;
>  }
>  
> +static void nh_group_v4_update(struct nh_group *nhg)
> +{
> +	struct nh_grp_entry *nhges;
> +	bool has_v4 = false;
> +	int i;
> +
> +	nhges = nhg->nh_entries;
> +	for (i = 0; i < nhg->num_nh; i++) {
> +		struct nh_info *nhi;
> +
> +		nhi = rtnl_dereference(nhges[i].nh->nh_info);
> +		if (nhi->family == AF_INET)
> +			has_v4 = true;
> +	}
> +	nhg->has_v4 = has_v4;
> +}
> +
>  static int replace_nexthop_single(struct net *net, struct nexthop *old,
>  				  struct nexthop *new,
>  				  struct netlink_ext_ack *extack)
> @@ -987,6 +1004,21 @@ static int replace_nexthop_single(struct net *net, struct nexthop *old,
>  	rcu_assign_pointer(old->nh_info, newi);
>  	rcu_assign_pointer(new->nh_info, oldi);
>  
> +	/* When replacing an IPv4 nexthop with an IPv6 nexthop, potentially
> +	 * update IPv4 indication in all the groups using the nexthop.
> +	 */
> +	if (oldi->family == AF_INET && newi->family == AF_INET6) {
> +		struct nh_grp_entry *nhge;
> +
> +		list_for_each_entry(nhge, &old->grp_list, nh_list) {
> +			struct nexthop *nhp = nhge->nh_parent;
> +			struct nh_group *nhg;
> +
> +			nhg = rtnl_dereference(nhp->nh_grp);
> +			nh_group_v4_update(nhg);
> +		}
> +	}
> +
>  	return 0;
>  }
>  
> 

Hopefully userspace apps create a new nexthop versus overwriting
existing ones with different address family. Thanks for handling this
case and adding a test case.

Reviewed-by: David Ahern <dsahern@gmail.com>


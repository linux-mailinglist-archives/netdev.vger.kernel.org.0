Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A6ED2261F34
	for <lists+netdev@lfdr.de>; Tue,  8 Sep 2020 22:00:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732516AbgIHUAh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Sep 2020 16:00:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50208 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730210AbgIHPf0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Sep 2020 11:35:26 -0400
Received: from mail-io1-xd42.google.com (mail-io1-xd42.google.com [IPv6:2607:f8b0:4864:20::d42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8BC52C02C3FA
        for <netdev@vger.kernel.org>; Tue,  8 Sep 2020 08:33:45 -0700 (PDT)
Received: by mail-io1-xd42.google.com with SMTP id d190so17556952iof.3
        for <netdev@vger.kernel.org>; Tue, 08 Sep 2020 08:33:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=1hf0bxlsMDACdDLheIGqGTjrclDra3XZ2eTrMmhy6q4=;
        b=Vw6R8S/mdAhUTpoA45Qts9SLEfaark42iGaxdzH5xdqjl6fE8sD5zwcZjufWGUX8gA
         xEWT5AGiLwqyi9xQDY1yi2mx1aoXAffg39KLgY31aIMLyQ4QWNSoNEfPx6EVBniz6SIW
         c7YtX2FUOJpr9QRQ02vgx+Mj1dixzVKTbKZz66Qqct0BykR9xnNX90QlXo0zxMp8qogx
         06ZUJi+5UTFjJ7vwR9aPUQZ5vNj68MciUulGW7ypyXE9Os3o8mFRNAGdOdBNNCZv4Mje
         /ciQrc2Ju+CxgjyjOqkrEeP439UdItzmmtFQDqv6TH14pORdQkAUamqtiZwdjGfsXKPr
         vxmg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=1hf0bxlsMDACdDLheIGqGTjrclDra3XZ2eTrMmhy6q4=;
        b=UtpxXyAVkyKI1cgwe2lo29Fr2/XS8I6BSXMAkINDb+Jh7z3AJp4wpILgVRbowUFCtm
         eo11/yXZ1ZCbeJPRVZfVvYTEfdyEkBPY4GsTZ72Hc7f5qcBQUdzE4qMXa6F/ZIItaqlD
         AGDNyCb/Ofg4GRpyRcq/oE3+vQXmrhV0ZXoWUjcnOoHa8uwiPWEcWdqnMIm1vzmvC8mH
         Qk9zZ62VfqT3gFhT/pLB939Hfsjsj6ThkaqbAJEqae/UHL/EjdpV/0JOI8TkbQwMxRcL
         iK3bxIiy6KnC+Gt3kAZeIT8P9cZYJ45XRST1mAd6km+tx3Ejmmymba90GWx9VpSng/T9
         +sJQ==
X-Gm-Message-State: AOAM533Qc/4fnp3hB8jupM4E9sVwvCyJpxYFlRMjXNVucze/5Uank7Hj
        sAxTA/gnsyI/SwUBgdQpCnQ=
X-Google-Smtp-Source: ABdhPJytuBYW5HvdDT4P/U19TP9slhMw2qQ9UY+4WuomL18jmWBt6M6xWGOl02U9+Jkqm03hFqNh/g==
X-Received: by 2002:a6b:7112:: with SMTP id q18mr21045471iog.79.1599579224426;
        Tue, 08 Sep 2020 08:33:44 -0700 (PDT)
Received: from Davids-MacBook-Pro.local ([2601:282:803:7700:ec70:7b06:eed6:6e35])
        by smtp.googlemail.com with ESMTPSA id o1sm10255373ilo.32.2020.09.08.08.33.43
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 08 Sep 2020 08:33:43 -0700 (PDT)
Subject: Re: [RFC PATCH net-next 15/22] nexthop: Emit a notification when a
 nexthop group is reduced
To:     Ido Schimmel <idosch@idosch.org>, netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, roopa@nvidia.com,
        mlxsw@nvidia.com, Ido Schimmel <idosch@nvidia.com>
References: <20200908091037.2709823-1-idosch@idosch.org>
 <20200908091037.2709823-16-idosch@idosch.org>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <c9fca303-9168-1b4b-25d9-7982d05cda92@gmail.com>
Date:   Tue, 8 Sep 2020 09:33:42 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.12.0
MIME-Version: 1.0
In-Reply-To: <20200908091037.2709823-16-idosch@idosch.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 9/8/20 3:10 AM, Ido Schimmel wrote:
> From: Ido Schimmel <idosch@nvidia.com>
> 
> When a single nexthop is deleted, the configuration of all the groups
> using the nexthop is effectively modified. In this case, emit a
> notification in the nexthop notification chain for each modified group
> so that listeners would not need to keep track of which nexthops are
> member in which groups.
> 
> In the rare cases where the notification fails, emit an error to the
> kernel log.
> 
> Signed-off-by: Ido Schimmel <idosch@nvidia.com>
> ---
>  net/ipv4/nexthop.c | 6 +++++-
>  1 file changed, 5 insertions(+), 1 deletion(-)
> 
> diff --git a/net/ipv4/nexthop.c b/net/ipv4/nexthop.c
> index 0edc3e73d416..33f611bbce1f 100644
> --- a/net/ipv4/nexthop.c
> +++ b/net/ipv4/nexthop.c
> @@ -893,7 +893,7 @@ static void remove_nh_grp_entry(struct net *net, struct nh_grp_entry *nhge,
>  	struct nexthop *nhp = nhge->nh_parent;
>  	struct nexthop *nh = nhge->nh;
>  	struct nh_group *nhg, *newg;
> -	int i, j;
> +	int i, j, err;
>  
>  	WARN_ON(!nh);
>  
> @@ -941,6 +941,10 @@ static void remove_nh_grp_entry(struct net *net, struct nh_grp_entry *nhge,
>  	list_del(&nhge->nh_list);
>  	nexthop_put(nhge->nh);
>  
> +	err = call_nexthop_notifiers(net, NEXTHOP_EVENT_REPLACE, nhp, NULL);
> +	if (err)
> +		pr_err("Failed to replace nexthop group after nexthop deletion\n");

This should refer to the notifier failing since wrt nexthop code the
structs are ok. extack on the stack and logging that message would be
useful too (or have the users of the notifier log why it fails).

> +
>  	if (nlinfo)
>  		nexthop_notify(RTM_NEWNEXTHOP, nhp, nlinfo);
>  }
> 


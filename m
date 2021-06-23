Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D501A3B1DB3
	for <lists+netdev@lfdr.de>; Wed, 23 Jun 2021 17:36:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231426AbhFWPiv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Jun 2021 11:38:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46770 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231236AbhFWPiu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Jun 2021 11:38:50 -0400
Received: from mail-oo1-xc35.google.com (mail-oo1-xc35.google.com [IPv6:2607:f8b0:4864:20::c35])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 084B8C061574
        for <netdev@vger.kernel.org>; Wed, 23 Jun 2021 08:36:32 -0700 (PDT)
Received: by mail-oo1-xc35.google.com with SMTP id s20-20020a4ae9940000b02902072d5df239so826567ood.2
        for <netdev@vger.kernel.org>; Wed, 23 Jun 2021 08:36:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=cC9ee+LHAaxDZwEIcmUILGo2rSh8KNSMTECWbH6VPwg=;
        b=Zpv6t8Z4E6dggymFITDZCO8JZwOqA34kQ3y3tYoQ084iWTvVxUcod8x8Yu0CZJeyfO
         yuBg9MnBwioB9VQkQPeKvpuhRcPEHC3nfXuf7g+UDh5S+w1H6QN6e9zViH/h2Iq31Y+O
         r5ZiIxW0pAbdyH90nhjdpWCea4E+8YdVpHGZg6Sb8ArAYL9eTSP9THY2x8h70IEDWNHG
         ZefRSqdwlGOleh8H/9ra6uWcMd3+ZXiLuZLYxCvPLfjBkwYAV1apcU4kNZDbgK4/vJmi
         fmol2GQQoCdQn206EQzLZdhuW+O/qXUUkit3T82iCMB327j6Ml+N3ql3qj4BR7bKmR7y
         VK0A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=cC9ee+LHAaxDZwEIcmUILGo2rSh8KNSMTECWbH6VPwg=;
        b=TggsYffQBCKqMGAjEMFnoRfxrEqr0vI9mj9cjtGU2C8+F+zSMoj+apRtAjIlUvNafT
         TYRvIy4pZcI6wWKvKWTfJ8Ko0jdnc1vcjAgvP90k3r5n201raUA4xMXUqcD/hdueIols
         RAZPt3tJlcHfsFIfasrYwttHX2bZhk4e3NIozmCycv0qZsVV8a78odGP4TVKFQ0OMz/U
         Tz/v4Kx/NFaD7WS96ILJZ/H++R0K5lCrpL0IWaNMl8FY5PyAMHioyaH+97agu0/c9DUr
         4ZBRMyU/e+QSSp6d3X6bZfPXjs+prcd7tQHNEgRDmXQcOqhB+aIpcpCUwOrIVhjeMwOc
         1J8w==
X-Gm-Message-State: AOAM532imbQpD0pyqu11w3B9k7RV7oHcAnjzAWbs+GNMODw1/oEFFq4q
        mYjHY87iI9E7sJzRCzDhOqk=
X-Google-Smtp-Source: ABdhPJyFMrhOZIkmMgHZwpTNu8+4DczuOG1uS7Clr4l36UmMBnWAHPK4FKgDnOGeu1cc7Uisyw/JlQ==
X-Received: by 2002:a4a:5482:: with SMTP id t124mr342216ooa.42.1624462591468;
        Wed, 23 Jun 2021 08:36:31 -0700 (PDT)
Received: from Davids-MacBook-Pro.local ([8.48.134.38])
        by smtp.googlemail.com with ESMTPSA id q18sm26282oic.3.2021.06.23.08.36.30
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 23 Jun 2021 08:36:31 -0700 (PDT)
Subject: Re: [PATCH iproute2] ip route: ignore ENOENT during save if
 RT_TABLE_MAIN is being dumped
To:     Alexander Mikhalitsyn <alexander.mikhalitsyn@virtuozzo.com>,
        netdev@vger.kernel.org
Cc:     David Ahern <dsahern@kernel.org>,
        Stephen Hemminger <stephen@networkplumber.org>,
        Andrei Vagin <avagin@gmail.com>,
        Alexander Mikhalitsyn <alexander@mihalicyn.com>
References: <20210622150330.28014-1-alexander.mikhalitsyn@virtuozzo.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <042c0ec6-f347-8b82-2bb2-c4ea87cf4a6d@gmail.com>
Date:   Wed, 23 Jun 2021 09:36:29 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <20210622150330.28014-1-alexander.mikhalitsyn@virtuozzo.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 6/22/21 9:03 AM, Alexander Mikhalitsyn wrote:
> We started to use in-kernel filtering feature which allows to get only needed
> tables (see iproute_dump_filter()). From the kernel side it's implemented in
> net/ipv4/fib_frontend.c (inet_dump_fib), net/ipv6/ip6_fib.c (inet6_dump_fib).
> The problem here is that behaviour of "ip route save" was changed after
> c7e6371bc ("ip route: Add protocol, table id and device to dump request").
> If filters are used, then kernel returns ENOENT error if requested table is absent,
> but in newly created net namespace even RT_TABLE_MAIN table doesn't exist.
> It is really allocated, for instance, after issuing "ip l set lo up".
> 
> Reproducer is fairly simple:
> $ unshare -n ip route save > dump
> Error: ipv4: FIB table does not exist.
> Dump terminated

The above command on 5.4 kernel with corresponding iproute2 does not
show that error. Is your kernel compiled with CONFIG_IP_MULTIPLE_TABLES
enabled?

> 
> Expected result here is to get empty dump file (as it was before this change).
> 
> This affects on CRIU [1] because we use ip route save in dump process, to workaround
> problem in tests we just put loopback interface up in each net namespace.
> Other users also met this problem [2].
> 
> Links:
> [1] https://github.com/checkpoint-restore/criu/issues/747
> [2] https://www.spinics.net/lists/netdev/msg559739.html
> 
> Fixes: c7e6371bc ("ip route: Add protocol, table id and device to dump request")
> 
> Cc: David Ahern <dsahern@kernel.org>
> Cc: Stephen Hemminger <stephen@networkplumber.org>
> Cc: Andrei Vagin <avagin@gmail.com>
> Cc: Alexander Mikhalitsyn <alexander@mihalicyn.com>
> Signed-off-by: Alexander Mikhalitsyn <alexander.mikhalitsyn@virtuozzo.com>
> ---
>  ip/iproute.c | 7 ++++++-
>  1 file changed, 6 insertions(+), 1 deletion(-)
> 
> diff --git a/ip/iproute.c b/ip/iproute.c
> index 5853f026..b70acc00 100644
> --- a/ip/iproute.c
> +++ b/ip/iproute.c
> @@ -1734,6 +1734,7 @@ static int iproute_list_flush_or_save(int argc, char **argv, int action)
>  	char *od = NULL;
>  	unsigned int mark = 0;
>  	rtnl_filter_t filter_fn;
> +	int ret;
>  
>  	if (action == IPROUTE_SAVE) {
>  		if (save_route_prep())
> @@ -1939,7 +1940,11 @@ static int iproute_list_flush_or_save(int argc, char **argv, int action)
>  
>  	new_json_obj(json);
>  
> -	if (rtnl_dump_filter(&rth, filter_fn, stdout) < 0) {
> +	ret = rtnl_dump_filter(&rth, filter_fn, stdout);
> +
> +	/* Let's ignore ENOENT error if we want to dump RT_TABLE_MAIN table */
> +	if (ret < 0 &&

ret temp variable is not needed; just add the extra checks.

> +	    !(errno == ENOENT && filter.tb == RT_TABLE_MAIN)) {
>  		fprintf(stderr, "Dump terminated\n");
>  		return -2;
>  	}
> 

This looks fine to me, but I want clarification on the kernel config. As
I recall with multiple tables and fib rules tables are created when net
namespace is created.

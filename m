Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8E4FD15FF97
	for <lists+netdev@lfdr.de>; Sat, 15 Feb 2020 19:00:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726422AbgBOSAK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 15 Feb 2020 13:00:10 -0500
Received: from mail-io1-f66.google.com ([209.85.166.66]:46990 "EHLO
        mail-io1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726318AbgBOSAK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 15 Feb 2020 13:00:10 -0500
Received: by mail-io1-f66.google.com with SMTP id t26so855471ioi.13
        for <netdev@vger.kernel.org>; Sat, 15 Feb 2020 10:00:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=kixFfhcLwan/IwY+vJbS7NYb2qAqPQPDCAMwJty/8GU=;
        b=NeSLq5Xu3TqzINYsfVkzehmipG/J1O3OqipSbtvuX8DEMXSGGA7FNTJmfqlcIulPDI
         xM3OI7UXoUev0bl6X/7/zlZSgS7WYkMcWVd9UK1CKpAgvHXrhi1ei0SCNF1sP3/b8B9U
         IOiSi7qyYMgQJG+sPysBKruzosfgW+pHzfNWV3tx7YQBIwtqQ6wcB2c3NFSL9qyR6QOU
         YMtm+9Ls7IHrub750W/JShQfjTzmoVlfTYC+vzhnRS9sskLABR8HsZDuebKTY1KyozTn
         6wxJJR16tP/tmV9/giOib7/a0Ub4PWDgzV7REd/FsmuksAr7yT5zOEBs7nepRJASUDUF
         M53w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=kixFfhcLwan/IwY+vJbS7NYb2qAqPQPDCAMwJty/8GU=;
        b=NAxO8D9vnH3lrIhOYMfNnuPisrrofdSmShxwIa0gcVnWirSJnPyQbmsKvWtV2BwK1u
         CmHDxh5bheCedncTYIQb1ps37yabNISBpjdtNTKvhP7y9HNfciEQH8PLN6x7bf0Dc4yj
         c1yLTkf4AN4hvipjlGP/7Y47Az50T/bUIl4ex1iqgzGbRKE0VJZOpQQA6SFNMtUnhsly
         Oaz2vk5rXOonp4EmSvC79QDsPch6IgF3qDxXgeA7hpc+ABE8h8Dq+3gfvea0vm3fUFI5
         BoayuBLPCVvXAqcnphq+QyW8fI0nenPysbLFEaz3XrbDVV4SEBh7XDDXomvF1bpI+BOy
         b1ow==
X-Gm-Message-State: APjAAAVcRgSesEGI14++145HH7LT+YxUl9csCK3BhhWKaJVEmnTFYBFV
        ykWF7zCJfPf2yX23PJQWLlvabr/W
X-Google-Smtp-Source: APXvYqxxYwfgz4dLvdf1G1unzgHIJ25iIHFiUGNxnjnWkDWE2M8UQ8pP+jpNVUueFdzOcSK/ZOiCqQ==
X-Received: by 2002:a6b:ac45:: with SMTP id v66mr6734357ioe.76.1581789610060;
        Sat, 15 Feb 2020 10:00:10 -0800 (PST)
Received: from ?IPv6:2601:282:803:7700:65d1:a3b2:d15f:79af? ([2601:282:803:7700:65d1:a3b2:d15f:79af])
        by smtp.googlemail.com with ESMTPSA id x62sm3339884ill.86.2020.02.15.10.00.08
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 15 Feb 2020 10:00:09 -0800 (PST)
Subject: Re: [PATCH net 1/2] ipv6: Fix route replacement with dev-only route
To:     Benjamin Poirier <bpoirier@cumulusnetworks.com>,
        netdev@vger.kernel.org
Cc:     =?UTF-8?Q?Michal_Kube=c4=8dek?= <mkubecek@suse.cz>,
        Nicolas Dichtel <nicolas.dichtel@6wind.com>,
        Ido Schimmel <idosch@idosch.org>
References: <20200212014107.110066-1-bpoirier@cumulusnetworks.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <46537e63-1ba9-5e76-fad3-03cae4d0d60f@gmail.com>
Date:   Sat, 15 Feb 2020 11:00:08 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.4.2
MIME-Version: 1.0
In-Reply-To: <20200212014107.110066-1-bpoirier@cumulusnetworks.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2/11/20 6:41 PM, Benjamin Poirier wrote:
> After commit 27596472473a ("ipv6: fix ECMP route replacement") it is no
> longer possible to replace an ECMP-able route by a non ECMP-able route.
> For example,
> 	ip route add 2001:db8::1/128 via fe80::1 dev dummy0
> 	ip route replace 2001:db8::1/128 dev dummy0
> does not work as expected.
> 
> Tweak the replacement logic so that point 3 in the log of the above commit
> becomes:
> 3. If the new route is not ECMP-able, and no matching non-ECMP-able route
> exists, replace matching ECMP-able route (if any) or add the new route.
> 
> We can now summarize the entire replace semantics to:
> When doing a replace, prefer replacing a matching route of the same
> "ECMP-able-ness" as the replace argument. If there is no such candidate,
> fallback to the first route found.
> 
> Fixes: 27596472473a ("ipv6: fix ECMP route replacement")
> Signed-off-by: Benjamin Poirier <bpoirier@cumulusnetworks.com>
> ---
>  net/ipv6/ip6_fib.c                       | 7 ++++---
>  tools/testing/selftests/net/fib_tests.sh | 6 ++++++
>  2 files changed, 10 insertions(+), 3 deletions(-)
> 
> diff --git a/net/ipv6/ip6_fib.c b/net/ipv6/ip6_fib.c
> index 58fbde244381..72abf892302f 100644
> --- a/net/ipv6/ip6_fib.c
> +++ b/net/ipv6/ip6_fib.c
> @@ -1102,8 +1102,7 @@ static int fib6_add_rt2node(struct fib6_node *fn, struct fib6_info *rt,
>  					found++;
>  					break;
>  				}
> -				if (rt_can_ecmp)
> -					fallback_ins = fallback_ins ?: ins;
> +				fallback_ins = fallback_ins ?: ins;
>  				goto next_iter;
>  			}
>  
> @@ -1146,7 +1145,9 @@ static int fib6_add_rt2node(struct fib6_node *fn, struct fib6_info *rt,
>  	}
>  
>  	if (fallback_ins && !found) {
> -		/* No ECMP-able route found, replace first non-ECMP one */
> +		/* No matching route with same ecmp-able-ness found, replace
> +		 * first matching route
> +		 */
>  		ins = fallback_ins;
>  		iter = rcu_dereference_protected(*ins,
>  				    lockdep_is_held(&rt->fib6_table->tb6_lock));
> diff --git a/tools/testing/selftests/net/fib_tests.sh b/tools/testing/selftests/net/fib_tests.sh
> index 6dd403103800..60273f1bc7d9 100755
> --- a/tools/testing/selftests/net/fib_tests.sh
> +++ b/tools/testing/selftests/net/fib_tests.sh
> @@ -910,6 +910,12 @@ ipv6_rt_replace_mpath()
>  	check_route6 "2001:db8:104::/64 via 2001:db8:101::3 dev veth1 metric 1024"
>  	log_test $? 0 "Multipath with single path via multipath attribute"
>  
> +	# multipath with dev-only
> +	add_initial_route6 "nexthop via 2001:db8:101::2 nexthop via 2001:db8:103::2"
> +	run_cmd "$IP -6 ro replace 2001:db8:104::/64 dev veth1"
> +	check_route6 "2001:db8:104::/64 dev veth1 metric 1024"
> +	log_test $? 0 "Multipath with dev-only"
> +
>  	# route replace fails - invalid nexthop 1
>  	add_initial_route6 "nexthop via 2001:db8:101::2 nexthop via 2001:db8:103::2"
>  	run_cmd "$IP -6 ro replace 2001:db8:104::/64 nexthop via 2001:db8:111::3 nexthop via 2001:db8:103::3"
> 

Thanks for adding a test case. I take this to mean that all existing
tests pass with this change. We have found this code to be extremely
sensitive to seemingly obvious changes.

Added Ido.

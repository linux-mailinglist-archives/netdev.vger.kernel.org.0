Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 640C72537F0
	for <lists+netdev@lfdr.de>; Wed, 26 Aug 2020 21:13:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726940AbgHZTMy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Aug 2020 15:12:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46838 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726723AbgHZTMw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Aug 2020 15:12:52 -0400
Received: from mail-io1-xd44.google.com (mail-io1-xd44.google.com [IPv6:2607:f8b0:4864:20::d44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B9582C061574
        for <netdev@vger.kernel.org>; Wed, 26 Aug 2020 12:12:51 -0700 (PDT)
Received: by mail-io1-xd44.google.com with SMTP id h4so3314078ioe.5
        for <netdev@vger.kernel.org>; Wed, 26 Aug 2020 12:12:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=2z2UvM3G0Gu8WjlHLYrNvAxLr1vPEVrIx6NRa9VUpps=;
        b=PbvS9EdU6rZp3k8WnCac48woZj0+lMSvPuqyREjAMfQ2z2KN/gTKPfn9PQ8eLsR5fA
         gsW7tM5MT1Xf3xF7aPkZ+HvlPJlDx5QvA235sDVKi/XuC+Ut766ob/egs4UUdbKlx75e
         IgTvm6YA9ikrRot8CWnmrsF9J0aM7Hc3a6g4qSV8cLuy7ILLVM8E8JfEfQirZ+833N2f
         7R5gEoMWIvVWFY/h3nDq2eM/Yt1Y93D+tK4mfbvgw/Q9LyJaY/VoXljuVRZH6pNd+kyS
         UFiA6oFwH3ClvUnxnCD2J94GgbrICO6pbUEZxlNZvYb14UdS3hVsMzGP3SVBNxJbhWbM
         1t8w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=2z2UvM3G0Gu8WjlHLYrNvAxLr1vPEVrIx6NRa9VUpps=;
        b=HYYYFoFL6So4bVEVkqeRKFRt6C0S+v+SCRR/4afeHELwD2SRDxeTdJG0tpMWMpaF8U
         OsXvj9vzEaQmT4DPJ1uvMTwFs2R1olpRw7ThIQAbiiiwYLKa/x51eJDFbugLsTX7P0it
         D88Zk/ESWs/j1walV1oefEb2b5aFwEZg99jjRZEEuZtLaC0I7qc9XNp48H6JFJkv6Kd5
         qUeMb7z9FDlxcM+DZQhhEjDKDZ9b+33zJyxfEZlKrW7eREkYrpuSPRLkNpqMJ2ahNzcF
         pXq9cbe6tCRMAfwgVQCMLU33w5XnNOWNdHtOdIMStyDgwzikP8jyU+3qTaR/uXmREDnu
         6KQA==
X-Gm-Message-State: AOAM530BTn8zWEFEAZRSdhxG8BnWweCvh7NWJSIE9y0WDS94CXVQea58
        kTEVHl4xGfPGDz/tMhD/9Gw=
X-Google-Smtp-Source: ABdhPJwISChcI0UA0g/+G0ZByN7vFDVCMmSxdIxiwhNL0cwA2I/Ur2WPfcfGGUB/y2EaYXhPqkMxDg==
X-Received: by 2002:a02:95ae:: with SMTP id b43mr15889670jai.19.1598469171124;
        Wed, 26 Aug 2020 12:12:51 -0700 (PDT)
Received: from Davids-MacBook-Pro.local ([2601:282:803:7700:305a:ae30:42e4:e2ca])
        by smtp.googlemail.com with ESMTPSA id k2sm719127ioj.2.2020.08.26.12.12.50
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 26 Aug 2020 12:12:50 -0700 (PDT)
Subject: Re: [PATCH net-next 5/7] selftests: fib_nexthops: Test IPv6 route
 with group after removing IPv4 nexthops
To:     Ido Schimmel <idosch@idosch.org>, netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, mlxsw@nvidia.com,
        Ido Schimmel <idosch@nvidia.com>
References: <20200826164857.1029764-1-idosch@idosch.org>
 <20200826164857.1029764-6-idosch@idosch.org>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <b36b6ece-b75b-eb2d-3004-2dac07b85cd4@gmail.com>
Date:   Wed, 26 Aug 2020 13:12:50 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.11.0
MIME-Version: 1.0
In-Reply-To: <20200826164857.1029764-6-idosch@idosch.org>
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
> Test that an IPv6 route can not use a nexthop group with mixed IPv4 and
> IPv6 nexthops, but can use it after deleting the IPv4 nexthops.
> 
> Output without previous patch:
> 
> # ./fib_nexthops.sh -t ipv6_fcnal_runtime
> 
> IPv6 functional runtime
> -----------------------
> TEST: Route add                                                     [ OK ]
> TEST: Route delete                                                  [ OK ]
> TEST: Ping with nexthop                                             [ OK ]
> TEST: Ping - multipath                                              [ OK ]
> TEST: Ping - blackhole                                              [ OK ]
> TEST: Ping - blackhole replaced with gateway                        [ OK ]
> TEST: Ping - gateway replaced by blackhole                          [ OK ]
> TEST: Ping - group with blackhole                                   [ OK ]
> TEST: Ping - group blackhole replaced with gateways                 [ OK ]
> TEST: IPv6 route with device only nexthop                           [ OK ]
> TEST: IPv6 multipath route with nexthop mix - dev only + gw         [ OK ]
> TEST: IPv6 route can not have a v4 gateway                          [ OK ]
> TEST: Nexthop replace - v6 route, v4 nexthop                        [ OK ]
> TEST: Nexthop replace of group entry - v6 route, v4 nexthop         [ OK ]
> TEST: IPv6 route can not have a group with v4 and v6 gateways       [ OK ]
> TEST: IPv6 route can not have a group with v4 and v6 gateways       [ OK ]
> TEST: IPv6 route using a group after deleting v4 gateways           [FAIL]
> TEST: Nexthop with default route and rpfilter                       [ OK ]
> TEST: Nexthop with multipath default route and rpfilter             [ OK ]
> 
> Tests passed:  18
> Tests failed:   1
> 
> Output with previous patch:
> 
> bash-5.0# ./fib_nexthops.sh -t ipv6_fcnal_runtime
> 
> IPv6 functional runtime
> -----------------------
> TEST: Route add                                                     [ OK ]
> TEST: Route delete                                                  [ OK ]
> TEST: Ping with nexthop                                             [ OK ]
> TEST: Ping - multipath                                              [ OK ]
> TEST: Ping - blackhole                                              [ OK ]
> TEST: Ping - blackhole replaced with gateway                        [ OK ]
> TEST: Ping - gateway replaced by blackhole                          [ OK ]
> TEST: Ping - group with blackhole                                   [ OK ]
> TEST: Ping - group blackhole replaced with gateways                 [ OK ]
> TEST: IPv6 route with device only nexthop                           [ OK ]
> TEST: IPv6 multipath route with nexthop mix - dev only + gw         [ OK ]
> TEST: IPv6 route can not have a v4 gateway                          [ OK ]
> TEST: Nexthop replace - v6 route, v4 nexthop                        [ OK ]
> TEST: Nexthop replace of group entry - v6 route, v4 nexthop         [ OK ]
> TEST: IPv6 route can not have a group with v4 and v6 gateways       [ OK ]
> TEST: IPv6 route can not have a group with v4 and v6 gateways       [ OK ]
> TEST: IPv6 route using a group after deleting v4 gateways           [ OK ]
> TEST: Nexthop with default route and rpfilter                       [ OK ]
> TEST: Nexthop with multipath default route and rpfilter             [ OK ]
> 
> Tests passed:  19
> Tests failed:   0
> 
> Signed-off-by: Ido Schimmel <idosch@nvidia.com>
> ---
>  tools/testing/selftests/net/fib_nexthops.sh | 15 +++++++++++++++
>  1 file changed, 15 insertions(+)
> 
> diff --git a/tools/testing/selftests/net/fib_nexthops.sh b/tools/testing/selftests/net/fib_nexthops.sh
> index 22dc2f3d428b..06e4f12e838d 100755
> --- a/tools/testing/selftests/net/fib_nexthops.sh
> +++ b/tools/testing/selftests/net/fib_nexthops.sh
> @@ -739,6 +739,21 @@ ipv6_fcnal_runtime()
>  	run_cmd "$IP nexthop replace id 81 via 172.16.1.1 dev veth1"
>  	log_test $? 2 "Nexthop replace of group entry - v6 route, v4 nexthop"
>  
> +	run_cmd "$IP nexthop add id 86 via 2001:db8:92::2 dev veth3"
> +	run_cmd "$IP nexthop add id 87 via 172.16.1.1 dev veth1"
> +	run_cmd "$IP nexthop add id 88 via 172.16.1.1 dev veth1"
> +	run_cmd "$IP nexthop add id 124 group 86/87/88"
> +	run_cmd "$IP ro replace 2001:db8:101::1/128 nhid 124"
> +	log_test $? 2 "IPv6 route can not have a group with v4 and v6 gateways"
> +
> +	run_cmd "$IP nexthop del id 88"
> +	run_cmd "$IP ro replace 2001:db8:101::1/128 nhid 124"
> +	log_test $? 2 "IPv6 route can not have a group with v4 and v6 gateways"
> +
> +	run_cmd "$IP nexthop del id 87"
> +	run_cmd "$IP ro replace 2001:db8:101::1/128 nhid 124"
> +	log_test $? 0 "IPv6 route using a group after removing v4 gateways"
> +
>  	$IP nexthop flush >/dev/null 2>&1
>  
>  	#
> 

Thanks for adding the tests!

Reviewed-by: David Ahern <dsahern@gmail.com>


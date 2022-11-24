Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6BCF163809E
	for <lists+netdev@lfdr.de>; Thu, 24 Nov 2022 22:25:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229624AbiKXVZs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Nov 2022 16:25:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58970 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229583AbiKXVZq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Nov 2022 16:25:46 -0500
Received: from mail-wr1-x431.google.com (mail-wr1-x431.google.com [IPv6:2a00:1450:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C8DF960EA1
        for <netdev@vger.kernel.org>; Thu, 24 Nov 2022 13:25:44 -0800 (PST)
Received: by mail-wr1-x431.google.com with SMTP id q7so3265573wrr.8
        for <netdev@vger.kernel.org>; Thu, 24 Nov 2022 13:25:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=blackwall-org.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=kirJwAc8Joe5ZepLZx8T+pb8ok/cXjiQNGG9J+4Cwac=;
        b=MTBNaTzbT6qf5yZy95jG7ZQTMU4tAvCQ8/wGCor1vado7/hkgqhoXSY0rGcimthZiM
         jDQmsyceubYnf2yR7gzzGgNWj9ToCIkClJrotVw31FZ/WDs17nm9pqrBoK1Ldvi3UrLY
         F0cBV5N+Myf2HAlKMcFW/6IMFdq1xebKLmUi/Xa22wtwCSr/4/fN5nRco+rMGZLqNt4y
         W1CCRFlZSKquXys6HhgWiSNF3uiuSAvzD2KGV1CjZhgwZtgXth0CUtdp0iOHUAOLuGZT
         OjCIKZq+ZFMSD/m9w1aiVdk2DOZbmn0oCMBgPePYfgPmgQDA9k+IbEwUupveWCgMTGvE
         yx0A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=kirJwAc8Joe5ZepLZx8T+pb8ok/cXjiQNGG9J+4Cwac=;
        b=DcaNNKgDMm2qKuOyehT4mt/Hbg2VkvEmvy+6YbnuuNlzoHfyliqR7RtG9QazOdzyuZ
         dfz5oj5t+uIZAyh0lTBJA7uR8YzUtgtqVsYCzdJoq4V4huV9AMI0vqLa4t1PclaQgYz5
         IVI2zdhcMOUC+13rvuqJxdpe2edVjD0tPNqtjoZOktuwa2k7JQTaL5S7BIQCqHm6ards
         mRxdzIV/omziLJOKBVAJSWuVTez732szHFyv6fIcr2d+GgIbODucXjE0PsYHCNYDwWqB
         WnJHs6Xa9HNDy8soV3qSQlDLN3wRIuNYV03CX3dBgaqAi7ECy/pyBOLB+fFEvC000RZI
         bPGQ==
X-Gm-Message-State: ANoB5pkglcuAgfBB/HBIdh3r/PRh0W6F7kr8OIAH0o89U5HRVnhW80VW
        02qtqleC90R84KUJf+3VUPz+vg==
X-Google-Smtp-Source: AA0mqf7bfoxryed0cFVOBn1ZlrjPLCZRUohj0qI7ybadOlD9MZltTJ3eD2PaAJoUTuNMs2+adt3XYA==
X-Received: by 2002:a5d:4563:0:b0:22e:3df5:df2 with SMTP id a3-20020a5d4563000000b0022e3df50df2mr21344964wrc.572.1669325143093;
        Thu, 24 Nov 2022 13:25:43 -0800 (PST)
Received: from [192.168.0.161] (79-100-144-200.ip.btc-net.bg. [79.100.144.200])
        by smtp.gmail.com with ESMTPSA id i17-20020adfe491000000b0022da3977ec5sm2158654wrm.113.2022.11.24.13.25.42
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 24 Nov 2022 13:25:42 -0800 (PST)
Message-ID: <6698e600-cb3a-4b49-34e5-1407f9b193ec@blackwall.org>
Date:   Thu, 24 Nov 2022 23:25:41 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.2.1
Subject: Re: [PATCH net] ipv4: Fix route deletion when nexthop info is not
 specified
Content-Language: en-US
To:     Ido Schimmel <idosch@nvidia.com>, netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, dsahern@gmail.com, jonas.gorski@gmail.com,
        mlxsw@nvidia.com, stable@vger.kernel.org
References: <20221124210932.2470010-1-idosch@nvidia.com>
From:   Nikolay Aleksandrov <razor@blackwall.org>
In-Reply-To: <20221124210932.2470010-1-idosch@nvidia.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 24/11/2022 23:09, Ido Schimmel wrote:
> When the kernel receives a route deletion request from user space it
> tries to delete a route that matches the route attributes specified in
> the request.
> 
> If only prefix information is specified in the request, the kernel
> should delete the first matching FIB alias regardless of its associated
> FIB info. However, an error is currently returned when the FIB info is
> backed by a nexthop object:
> 
>  # ip nexthop add id 1 via 192.0.2.2 dev dummy10
>  # ip route add 198.51.100.0/24 nhid 1
>  # ip route del 198.51.100.0/24
>  RTNETLINK answers: No such process
> 
> Fix by matching on such a FIB info when legacy nexthop attributes are
> not specified in the request. An earlier check already covers the case
> where a nexthop ID is specified in the request.
> 
> Add tests that cover these flows. Before the fix:
> 
>  # ./fib_nexthops.sh -t ipv4_fcnal
>  ...
>  TEST: Delete route when not specifying nexthop attributes           [FAIL]
> 
>  Tests passed:  11
>  Tests failed:   1
> 
> After the fix:
> 
>  # ./fib_nexthops.sh -t ipv4_fcnal
>  ...
>  TEST: Delete route when not specifying nexthop attributes           [ OK ]
> 
>  Tests passed:  12
>  Tests failed:   0
> 
> No regressions in other tests:
> 
>  # ./fib_nexthops.sh
>  ...
>  Tests passed: 228
>  Tests failed:   0
> 
>  # ./fib_tests.sh
>  ...
>  Tests passed: 186
>  Tests failed:   0
> 
> Cc: stable@vger.kernel.org
> Reported-by: Jonas Gorski <jonas.gorski@gmail.com>
> Tested-by: Jonas Gorski <jonas.gorski@gmail.com>
> Fixes: 493ced1ac47c ("ipv4: Allow routes to use nexthop objects")
> Fixes: 6bf92d70e690 ("net: ipv4: fix route with nexthop object delete warning")
> Fixes: 61b91eb33a69 ("ipv4: Handle attempt to delete multipath route when fib_info contains an nh reference")
> Signed-off-by: Ido Schimmel <idosch@nvidia.com>
> ---
>  net/ipv4/fib_semantics.c                    |  8 +++++---
>  tools/testing/selftests/net/fib_nexthops.sh | 11 +++++++++++
>  2 files changed, 16 insertions(+), 3 deletions(-)
> 

Reviewed-by: Nikolay Aleksandrov <razor@blackwall.org>

> diff --git a/net/ipv4/fib_semantics.c b/net/ipv4/fib_semantics.c
> index f721c308248b..19a662003eef 100644
> --- a/net/ipv4/fib_semantics.c
> +++ b/net/ipv4/fib_semantics.c
> @@ -888,9 +888,11 @@ int fib_nh_match(struct net *net, struct fib_config *cfg, struct fib_info *fi,
>  		return 1;
>  	}
>  
> -	/* cannot match on nexthop object attributes */
> -	if (fi->nh)
> -		return 1;
> +	if (fi->nh) {
> +		if (cfg->fc_oif || cfg->fc_gw_family || cfg->fc_mp)
> +			return 1;
> +		return 0;
> +	}
>  
>  	if (cfg->fc_oif || cfg->fc_gw_family) {
>  		struct fib_nh *nh;
> diff --git a/tools/testing/selftests/net/fib_nexthops.sh b/tools/testing/selftests/net/fib_nexthops.sh
> index ee5e98204d3d..a47b26ab48f2 100755
> --- a/tools/testing/selftests/net/fib_nexthops.sh
> +++ b/tools/testing/selftests/net/fib_nexthops.sh
> @@ -1228,6 +1228,17 @@ ipv4_fcnal()
>  	run_cmd "$IP ro add 172.16.101.0/24 nhid 21"
>  	run_cmd "$IP ro del 172.16.101.0/24 nexthop via 172.16.1.7 dev veth1 nexthop via 172.16.1.8 dev veth1"
>  	log_test $? 2 "Delete multipath route with only nh id based entry"
> +
> +	run_cmd "$IP nexthop add id 22 via 172.16.1.6 dev veth1"
> +	run_cmd "$IP ro add 172.16.102.0/24 nhid 22"
> +	run_cmd "$IP ro del 172.16.102.0/24 dev veth1"
> +	log_test $? 2 "Delete route when specifying only nexthop device"
> +
> +	run_cmd "$IP ro del 172.16.102.0/24 via 172.16.1.6"
> +	log_test $? 2 "Delete route when specifying only gateway"
> +
> +	run_cmd "$IP ro del 172.16.102.0/24"
> +	log_test $? 0 "Delete route when not specifying nexthop attributes"
>  }
>  
>  ipv4_grp_fcnal()


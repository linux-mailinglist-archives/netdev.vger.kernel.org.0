Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6C50A1E5B37
	for <lists+netdev@lfdr.de>; Thu, 28 May 2020 10:54:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728007AbgE1IyB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 May 2020 04:54:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46300 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727814AbgE1Ix5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 May 2020 04:53:57 -0400
Received: from mail-wr1-x441.google.com (mail-wr1-x441.google.com [IPv6:2a00:1450:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9DC3EC05BD1E
        for <netdev@vger.kernel.org>; Thu, 28 May 2020 01:53:57 -0700 (PDT)
Received: by mail-wr1-x441.google.com with SMTP id e1so27033561wrt.5
        for <netdev@vger.kernel.org>; Thu, 28 May 2020 01:53:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cumulusnetworks.com; s=google;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=Zch1nyFtoNx2wH+Li6mNyEXJF1Uhf40x1M1UJtfkBoc=;
        b=VeXliFXieKMYXF0hINR7khXgxTcNF4Z4MGbHeO6Uee4YEV5Mr/rrWQzqpQM72g4rmT
         N+7/U7ePTQSqiv18QuwSr5T4ZtkbHt2si4mVKwMrx7AuWCQsO7SzVH6IDv0dGd3Xg0In
         mAzMTgM9Qs2Y4xEcmMNL3UL2fIsS9T91s/RwY=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=Zch1nyFtoNx2wH+Li6mNyEXJF1Uhf40x1M1UJtfkBoc=;
        b=L18tzCLdPj78jD3KO+yBFVCp0LKj8ICv5EuRbB/aPknzMUQNT9G4Jvg+jaG4gyZtKE
         A1qaIIMv1SGYGy1ObMAMV6SYZD8zNONuqmPVMPbe0AmQhIyMjSw+8t/xTbaDIPg0Cm7L
         0ODnRbFqAB7yDQpDlh4Zj8ol9vryR9/zLMWbZfk7osegmrKcSt22a9+gKTLFRPXcvLZh
         xGTqVoe3I/mgYw2ZIrMVCXVItQTVPNaRKXyFzNAi2aUIyqC2n0I7F0YNEhG/cHfLoeMe
         IcmrjcpF+d/RGk4PZSiOCe9c5gKlqILThF1Uwx90vsNe/8PGKRV6vONDF19V/H5tIxJh
         ArXA==
X-Gm-Message-State: AOAM531/qrkQ3PTmG/KhqgFkaPajeGfeqY7GqacJn4UBT99MapL46IgF
        u+s2deHMCp5axnwISDd2UcHs/g==
X-Google-Smtp-Source: ABdhPJztaDM21/9Lu+TIlTWqECIjCRIL/qZTfP60p4+g/8RT82CX98zJ7c4q56I+wl/Nq6ZDrGiKiw==
X-Received: by 2002:adf:c385:: with SMTP id p5mr2531344wrf.409.1590656036319;
        Thu, 28 May 2020 01:53:56 -0700 (PDT)
Received: from [192.168.0.109] (84-238-136-197.ip.btc-net.bg. [84.238.136.197])
        by smtp.gmail.com with ESMTPSA id 128sm5640040wme.39.2020.05.28.01.53.54
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 28 May 2020 01:53:55 -0700 (PDT)
Subject: Re: [PATCH net-next] selftests: Add torture tests to nexthop tests
To:     David Ahern <dsahern@kernel.org>, netdev@vger.kernel.org,
        kuba@kernel.org, davem@davemloft.net
References: <20200528000344.57809-1-dsahern@kernel.org>
From:   Nikolay Aleksandrov <nikolay@cumulusnetworks.com>
Message-ID: <62bc95f3-8d8c-6dd3-2064-18c1a931cec6@cumulusnetworks.com>
Date:   Thu, 28 May 2020 11:53:54 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <20200528000344.57809-1-dsahern@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 28/05/2020 03:03, David Ahern wrote:
> Add Nik's torture tests as a new set to stress the replace and cleanup
> paths.
> 
> Torture test created by Nikolay Aleksandrov and then I adapted to
> selftest and added IPv6 version.
> 
> Signed-off-by: David Ahern <dsahern@kernel.org>
> ---
>  tools/testing/selftests/net/fib_nexthops.sh | 115 +++++++++++++++++++-
>  1 file changed, 113 insertions(+), 2 deletions(-)
> 

Signed-off-by: Nikolay Aleksandrov <nikolay@cumulusnetworks.com>

> diff --git a/tools/testing/selftests/net/fib_nexthops.sh b/tools/testing/selftests/net/fib_nexthops.sh
> index 1e2f61262e4e..dee567f7576a 100755
> --- a/tools/testing/selftests/net/fib_nexthops.sh
> +++ b/tools/testing/selftests/net/fib_nexthops.sh
> @@ -19,8 +19,8 @@ ret=0
>  ksft_skip=4
>  
>  # all tests in this script. Can be overridden with -t option
> -IPV4_TESTS="ipv4_fcnal ipv4_grp_fcnal ipv4_withv6_fcnal ipv4_fcnal_runtime ipv4_large_grp ipv4_compat_mode ipv4_fdb_grp_fcnal"
> -IPV6_TESTS="ipv6_fcnal ipv6_grp_fcnal ipv6_fcnal_runtime ipv6_large_grp ipv6_compat_mode ipv6_fdb_grp_fcnal"
> +IPV4_TESTS="ipv4_fcnal ipv4_grp_fcnal ipv4_withv6_fcnal ipv4_fcnal_runtime ipv4_large_grp ipv4_compat_mode ipv4_fdb_grp_fcnal ipv4_torture"
> +IPV6_TESTS="ipv6_fcnal ipv6_grp_fcnal ipv6_fcnal_runtime ipv6_large_grp ipv6_compat_mode ipv6_fdb_grp_fcnal ipv6_torture"
>  
>  ALL_TESTS="basic ${IPV4_TESTS} ${IPV6_TESTS}"
>  TESTS="${ALL_TESTS}"
> @@ -767,6 +767,62 @@ ipv6_large_grp()
>  	$IP nexthop flush >/dev/null 2>&1
>  }
>  
> +ipv6_del_add_loop1()
> +{
> +	while :; do
> +		$IP nexthop del id 100
> +		$IP nexthop add id 100 via 2001:db8:91::2 dev veth1
> +	done >/dev/null 2>&1
> +}
> +
> +ipv6_grp_replace_loop()
> +{
> +	while :; do
> +		$IP nexthop replace id 102 group 100/101
> +	done >/dev/null 2>&1
> +}
> +
> +ipv6_torture()
> +{
> +	local pid1
> +	local pid2
> +	local pid3
> +	local pid4
> +	local pid5
> +
> +	echo
> +	echo "IPv6 runtime torture"
> +	echo "--------------------"
> +	if [ ! -x "$(command -v mausezahn)" ]; then
> +		echo "SKIP: Could not run test; need mausezahn tool"
> +		return
> +	fi
> +
> +	run_cmd "$IP nexthop add id 100 via 2001:db8:91::2 dev veth1"
> +	run_cmd "$IP nexthop add id 101 via 2001:db8:92::2 dev veth3"
> +	run_cmd "$IP nexthop add id 102 group 100/101"
> +	run_cmd "$IP route add 2001:db8:101::1 nhid 102"
> +	run_cmd "$IP route add 2001:db8:101::2 nhid 102"
> +
> +	ipv6_del_add_loop1 &
> +	pid1=$!
> +	ipv6_grp_replace_loop &
> +	pid2=$!
> +	ip netns exec me ping -f 2001:db8:101::1 >/dev/null 2>&1 &
> +	pid3=$!
> +	ip netns exec me ping -f 2001:db8:101::2 >/dev/null 2>&1 &
> +	pid4=$!
> +	ip netns exec me mausezahn veth1 -B 2001:db8:101::2 -A 2001:db8:91::1 -c 0 -t tcp "dp=1-1023, flags=syn" >/dev/null 2>&1 &
> +	pid5=$!
> +
> +	sleep 300
> +	kill -9 $pid1 $pid2 $pid3 $pid4 $pid5
> +
> +	# if we did not crash, success
> +	log_test 0 0 "IPv6 torture test"
> +}
> +
> +
>  ipv4_fcnal()
>  {
>  	local rc
> @@ -1313,6 +1369,61 @@ ipv4_compat_mode()
>  	sysctl_nexthop_compat_mode_set 1 "IPv4"
>  }
>  
> +ipv4_del_add_loop1()
> +{
> +	while :; do
> +		$IP nexthop del id 100
> +		$IP nexthop add id 100 via 172.16.1.2 dev veth1
> +	done >/dev/null 2>&1
> +}
> +
> +ipv4_grp_replace_loop()
> +{
> +	while :; do
> +		$IP nexthop replace id 102 group 100/101
> +	done >/dev/null 2>&1
> +}
> +
> +ipv4_torture()
> +{
> +	local pid1
> +	local pid2
> +	local pid3
> +	local pid4
> +	local pid5
> +
> +	echo
> +	echo "IPv4 runtime torture"
> +	echo "--------------------"
> +	if [ ! -x "$(command -v mausezahn)" ]; then
> +		echo "SKIP: Could not run test; need mausezahn tool"
> +		return
> +	fi
> +
> +	run_cmd "$IP nexthop add id 100 via 172.16.1.2 dev veth1"
> +	run_cmd "$IP nexthop add id 101 via 172.16.2.2 dev veth3"
> +	run_cmd "$IP nexthop add id 102 group 100/101"
> +	run_cmd "$IP route add 172.16.101.1 nhid 102"
> +	run_cmd "$IP route add 172.16.101.2 nhid 102"
> +
> +	ipv4_del_add_loop1 &
> +	pid1=$!
> +	ipv4_grp_replace_loop &
> +	pid2=$!
> +	ip netns exec me ping -f 172.16.101.1 >/dev/null 2>&1 &
> +	pid3=$!
> +	ip netns exec me ping -f 172.16.101.2 >/dev/null 2>&1 &
> +	pid4=$!
> +	ip netns exec me mausezahn veth1 -B 172.16.101.2 -A 172.16.1.1 -c 0 -t tcp "dp=1-1023, flags=syn" >/dev/null 2>&1 &
> +	pid5=$!
> +
> +	sleep 300
> +	kill -9 $pid1 $pid2 $pid3 $pid4 $pid5
> +
> +	# if we did not crash, success
> +	log_test 0 0 "IPv4 torture test"
> +}
> +
>  basic()
>  {
>  	echo
> 


Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B93032EC1AD
	for <lists+netdev@lfdr.de>; Wed,  6 Jan 2021 18:04:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727646AbhAFREC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Jan 2021 12:04:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52850 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727556AbhAFREC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 Jan 2021 12:04:02 -0500
Received: from mail-oo1-xc34.google.com (mail-oo1-xc34.google.com [IPv6:2607:f8b0:4864:20::c34])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 01E8CC06134C
        for <netdev@vger.kernel.org>; Wed,  6 Jan 2021 09:03:22 -0800 (PST)
Received: by mail-oo1-xc34.google.com with SMTP id k7so908602ooa.0
        for <netdev@vger.kernel.org>; Wed, 06 Jan 2021 09:03:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=bOHJqnBWwmocqkIPm2q8YM2omg2jhdUQgHlbHS5khyA=;
        b=IHR/Ru0PPRipNXH16wsZFkjSAZzt3y+vqcJhwHZHYwXVZ/iFD+56GQmMHtzZGlD6d2
         uVxSV4StOzY+bkiiVOoFMIdgKa7cQ7iA2c1T6u7fiY0BUO2pt3LfA/PvqlKtkPEG6hUD
         /iCBJWW9ZFl/nEiyDfJrZvSHoR/NCmPf+M74ZBUdE0Gd7aTFjYyqigmK1058RE0i4r1Q
         G4zZ4P5dmROdwi+qzCWHgqBaCT/4wS3KuWRZKjiMw41K2xuUVd6smKzD2+ttzh/IN83O
         E/jtyiWvDTOlF14J67cQXmaNTDbh9RhqcdNFLX/WKmvCZm7qJs2PEz67I6760egDTRN+
         vvFg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=bOHJqnBWwmocqkIPm2q8YM2omg2jhdUQgHlbHS5khyA=;
        b=FWYgvA5qqXt6efzgSoYcObkP9VSsTizPAi0ZKNKbOpdj2GsL2QD3DTBHIMFwNETFZw
         uJBRBvhHJxhGmrMfO4XOj/Mj6X6cMcHp8mr3Za2mTbbQ0F9cy10KobcPJ/tqW2v0inRL
         Kqgba8LHT4Tks/dIy+cdukZKMqE2Hk2JG2YSAELhB8NvpNPdCdhp553s80Bg2B02RpsB
         DnCNbuW6oWiNDKI6pfUHBFXImjVapufgOn1tu5EbdPapbf0afLzX5UzEcdL3INyM13+M
         2qrDcivxRDrjUm6sEOGgbDh1Tbj70okSQi17J5aTHJDZw6FCZFNwOgpNpJQvOG4hwKIY
         i/Gw==
X-Gm-Message-State: AOAM533o/b4QaC1OpTPBWJuNJelWsTo7vVw3YsrAekQuEIOcNjnry/pU
        AsoX72Cdh7IBpSMa+YcljqC6E70PIfQ=
X-Google-Smtp-Source: ABdhPJyZaKYEVJvmzFVengkyCmepXkf1otfYrhzmlqoibkBTWsPq59Zg6OQFTdoqiKxKOriGQbDnew==
X-Received: by 2002:a4a:2256:: with SMTP id z22mr3436699ooe.62.1609952601405;
        Wed, 06 Jan 2021 09:03:21 -0800 (PST)
Received: from Davids-MacBook-Pro.local ([2601:282:800:dc80:e074:7fa1:391b:b88d])
        by smtp.googlemail.com with ESMTPSA id 11sm585796oty.65.2021.01.06.09.03.20
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 06 Jan 2021 09:03:20 -0800 (PST)
Subject: Re: [net PATCH 2/2] tools: selftests: add test for changing routes
 with PTMU exceptions
To:     Sean Tranchetti <stranche@quicinc.com>, davem@davemloft.net,
        netdev@vger.kernel.org, kuba@kernel.org
Cc:     subashab@codearurora.org,
        Sean Tranchetti <stranche@codeaurora.org>,
        Stefano Brivio <sbrivio@redhat.com>
References: <1609892546-11389-1-git-send-email-stranche@quicinc.com>
 <1609892546-11389-2-git-send-email-stranche@quicinc.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <43a47c65-d608-e05d-385e-f9b4b7f49ac1@gmail.com>
Date:   Wed, 6 Jan 2021 10:03:19 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.16; rv:78.0)
 Gecko/20100101 Thunderbird/78.6.0
MIME-Version: 1.0
In-Reply-To: <1609892546-11389-2-git-send-email-stranche@quicinc.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 1/5/21 5:22 PM, Sean Tranchetti wrote:
> From: Sean Tranchetti <stranche@codeaurora.org>
> 
> Adds new 2 new tests to the PTMU script: pmtu_ipv4/6_route_change.
> 
> These tests explicitly test for a recently discovered problem in the
> IPv6 routing framework where PMTU exceptions were not properly released
> when replacing a route via "ip route change ...".
> 
> After creating PMTU exceptions, the route from the device A to R1 will be
> replaced with a new route, then device A will be deleted. If the PMTU
> exceptions were properly cleaned up by the kernel, this device deletion
> will succeed. Otherwise, the unregistration of the device will stall, and
> messages such as the following will be logged in dmesg:
> 
> unregister_netdevice: waiting for veth_A-R1 to become free. Usage count = 4
> 
> Signed-off-by: Sean Tranchetti <stranche@codeaurora.org>
> ---
>  tools/testing/selftests/net/pmtu.sh | 71 +++++++++++++++++++++++++++++++++++--
>  1 file changed, 69 insertions(+), 2 deletions(-)
> 
> diff --git a/tools/testing/selftests/net/pmtu.sh b/tools/testing/selftests/net/pmtu.sh
> index 464e31e..64cd2e2 100755
> --- a/tools/testing/selftests/net/pmtu.sh
> +++ b/tools/testing/selftests/net/pmtu.sh
> @@ -162,7 +162,15 @@
>  # - list_flush_ipv6_exception
>  #	Using the same topology as in pmtu_ipv6, create exceptions, and check
>  #	they are shown when listing exception caches, gone after flushing them
> -
> +#
> +# - pmtu_ipv4_route_change
> +#	Use the same topology as in pmtu_ipv4, but issue a route replacement
> +#	command and delete the corresponding device afterward. This tests for
> +#	proper cleanup of the PMTU exceptions by the route replacement path.
> +#	Device unregistration should complete successfully
> +#
> +# - pmtu_ipv6_route_change
> +#	Same as above but with IPv6
>  
>  # Kselftest framework requirement - SKIP code is 4.
>  ksft_skip=4
> @@ -224,7 +232,9 @@ tests="
>  	cleanup_ipv4_exception		ipv4: cleanup of cached exceptions	1
>  	cleanup_ipv6_exception		ipv6: cleanup of cached exceptions	1
>  	list_flush_ipv4_exception	ipv4: list and flush cached exceptions	1
> -	list_flush_ipv6_exception	ipv6: list and flush cached exceptions	1"
> +	list_flush_ipv6_exception	ipv6: list and flush cached exceptions	1
> +	pmtu_ipv4_route_change		ipv4: PMTU exception w/route replace	1
> +	pmtu_ipv6_route_change		ipv6: PMTU exception w/route replace	1"
>  
>  NS_A="ns-A"
>  NS_B="ns-B"
> @@ -1782,6 +1792,63 @@ test_list_flush_ipv6_exception() {
>  	return ${fail}
>  }
>  
> +test_pmtu_ipvX_route_change() {
> +	family=${1}
> +
> +	setup namespaces routing || return 2
> +	trace "${ns_a}"  veth_A-R1    "${ns_r1}" veth_R1-A \
> +	      "${ns_r1}" veth_R1-B    "${ns_b}"  veth_B-R1 \
> +	      "${ns_a}"  veth_A-R2    "${ns_r2}" veth_R2-A \
> +	      "${ns_r2}" veth_R2-B    "${ns_b}"  veth_B-R2
> +
> +	if [ ${family} -eq 4 ]; then
> +		ping=ping
> +		dst1="${prefix4}.${b_r1}.1"
> +		dst2="${prefix4}.${b_r2}.1"
> +		gw="${prefix4}.${a_r1}.2"
> +	else
> +		ping=${ping6}
> +		dst1="${prefix6}:${b_r1}::1"
> +		dst2="${prefix6}:${b_r2}::1"
> +		gw="${prefix6}:${a_r1}::2"
> +	fi
> +
> +	# Set up initial MTU values
> +	mtu "${ns_a}"  veth_A-R1 2000
> +	mtu "${ns_r1}" veth_R1-A 2000
> +	mtu "${ns_r1}" veth_R1-B 1400
> +	mtu "${ns_b}"  veth_B-R1 1400
> +
> +	mtu "${ns_a}"  veth_A-R2 2000
> +	mtu "${ns_r2}" veth_R2-A 2000
> +	mtu "${ns_r2}" veth_R2-B 1500
> +	mtu "${ns_b}"  veth_B-R2 1500
> +
> +	# Create route exceptions
> +	run_cmd ${ns_a} ${ping} -q -M want -i 0.1 -w 1 -s 1800 ${dst1}
> +	run_cmd ${ns_a} ${ping} -q -M want -i 0.1 -w 1 -s 1800 ${dst2}
> +
> +	# Check that exceptions have been created with the correct PMTU
> +	pmtu_1="$(route_get_dst_pmtu_from_exception "${ns_a}" ${dst1})"
> +	check_pmtu_value "1400" "${pmtu_1}" "exceeding MTU" || return 1
> +	pmtu_2="$(route_get_dst_pmtu_from_exception "${ns_a}" ${dst2})"
> +	check_pmtu_value "1500" "${pmtu_2}" "exceeding MTU" || return 1
> +
> +	# Replace the route from A to R1
> +	run_cmd ${ns_a} ip route change default via ${gw}
> +
> +	# Delete the device in A
> +	run_cmd ${ns_a} ip link del "veth_A-R1"
> +}
> +
> +test_pmtu_ipv4_route_change() {
> +	test_pmtu_ipvX_route_change 4
> +}
> +
> +test_pmtu_ipv6_route_change() {
> +	test_pmtu_ipvX_route_change 6
> +}
> +
>  usage() {
>  	echo
>  	echo "$0 [OPTIONS] [TEST]..."
> 

Thanks for adding the tests.
Reviewed-by: David Ahern <dsahern@kernel.org>


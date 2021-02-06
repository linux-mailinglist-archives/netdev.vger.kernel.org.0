Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D63E1311EA4
	for <lists+netdev@lfdr.de>; Sat,  6 Feb 2021 17:29:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230150AbhBFQ0m (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 6 Feb 2021 11:26:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46592 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229508AbhBFQ0f (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 6 Feb 2021 11:26:35 -0500
Received: from merlin.infradead.org (merlin.infradead.org [IPv6:2001:8b0:10b:1231::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 69C05C061786;
        Sat,  6 Feb 2021 08:25:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=merlin.20170209; h=Content-Transfer-Encoding:Content-Type:
        In-Reply-To:MIME-Version:Date:Message-ID:From:References:Cc:To:Subject:Sender
        :Reply-To:Content-ID:Content-Description;
        bh=qn9SKsuN29e/1ymaZOP8h+DprUmvijIyVh8PkwYRC0Q=; b=UsQINfoXzDgjQebAy+d8plz63j
        FXVUoznhYMHmU/3fKXJ130rA6GWCCgwqwX7txvnrBWJkmpARul0/I8l2Z5vEJa5db4U0mcmtAA+b7
        BzXCNLqUlE1dN2OOUTDdAgAkaK7L0A2/0Es5lzNrLLcmNUhg7HzvBvEFEairqnL7XUtl4WJt+n8BB
        w5IQeUjKrfWaw8X9kO5C/ASif3CNdxkR2oyncqP+dB9rkzWYSVDZLO0g5rtKswFHCyygEyoOZXlzd
        YrROyD+bf12K+I2qIQ1rWOamaSzottXEHFGPLYysdT7nMQwRvNk5DUleMcFhhh1xIC3f9IT+B/rYf
        7bfKaOvw==;
Received: from [2601:1c0:6280:3f0::b879]
        by merlin.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1l8QP6-0005uE-NW; Sat, 06 Feb 2021 16:25:49 +0000
Subject: Re: [PATCH bpf v2] selftests/bpf: remove bash feature in
 test_xdp_redirect.sh
To:     =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@gmail.com>,
        ast@kernel.org, daniel@iogearbox.net, netdev@vger.kernel.org,
        bpf@vger.kernel.org
Cc:     =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@intel.com>,
        u9012063@gmail.com
References: <20210206092654.155239-1-bjorn.topel@gmail.com>
From:   Randy Dunlap <rdunlap@infradead.org>
Message-ID: <4cf38817-15bb-da36-68eb-4e268294b611@infradead.org>
Date:   Sat, 6 Feb 2021 08:25:43 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.0
MIME-Version: 1.0
In-Reply-To: <20210206092654.155239-1-bjorn.topel@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2/6/21 1:26 AM, Björn Töpel wrote:
> From: Björn Töpel <bjorn.topel@intel.com>
> 
> The test_xdp_redirect.sh script uses a bash redirect feature,
> '&>/dev/null'. Use '>/dev/null 2>&1' instead.
> 
> Also remove the 'set -e' since the script actually relies on that the
> return value can be used to determine pass/fail of the test.
> 
> Acked-by: William Tu <u9012063@gmail.com>
> Fixes: 996139e801fd ("selftests: bpf: add a test for XDP redirect")
> Signed-off-by: Björn Töpel <bjorn.topel@intel.com>

Acked-by: Randy Dunlap <rdunlap@infradead.org>

Thanks.

> ---
> William, I kept your Acked-by.
> 
> v2: Kept /bin/sh and removed bashisms. (Randy)
> ---
>  tools/testing/selftests/bpf/test_xdp_redirect.sh | 15 +++++++--------
>  1 file changed, 7 insertions(+), 8 deletions(-)
> 
> diff --git a/tools/testing/selftests/bpf/test_xdp_redirect.sh b/tools/testing/selftests/bpf/test_xdp_redirect.sh
> index dd80f0c84afb..4d4887da175c 100755
> --- a/tools/testing/selftests/bpf/test_xdp_redirect.sh
> +++ b/tools/testing/selftests/bpf/test_xdp_redirect.sh
> @@ -46,20 +46,20 @@ test_xdp_redirect()
>  
>  	setup
>  
> -	ip link set dev veth1 $xdpmode off &> /dev/null
> +	ip link set dev veth1 $xdpmode off >/dev/null 2>&1
>  	if [ $? -ne 0 ];then
>  		echo "selftests: test_xdp_redirect $xdpmode [SKIP]"
>  		return 0
>  	fi
>  
> -	ip -n ns1 link set veth11 $xdpmode obj xdp_dummy.o sec xdp_dummy &> /dev/null
> -	ip -n ns2 link set veth22 $xdpmode obj xdp_dummy.o sec xdp_dummy &> /dev/null
> -	ip link set dev veth1 $xdpmode obj test_xdp_redirect.o sec redirect_to_222 &> /dev/null
> -	ip link set dev veth2 $xdpmode obj test_xdp_redirect.o sec redirect_to_111 &> /dev/null
> +	ip -n ns1 link set veth11 $xdpmode obj xdp_dummy.o sec xdp_dummy >/dev/null 2>&1
> +	ip -n ns2 link set veth22 $xdpmode obj xdp_dummy.o sec xdp_dummy >/dev/null 2>&1
> +	ip link set dev veth1 $xdpmode obj test_xdp_redirect.o sec redirect_to_222 >/dev/null 2>&1
> +	ip link set dev veth2 $xdpmode obj test_xdp_redirect.o sec redirect_to_111 >/dev/null 2>&1
>  
> -	ip netns exec ns1 ping -c 1 10.1.1.22 &> /dev/null
> +	ip netns exec ns1 ping -c 1 10.1.1.22 >/dev/null 2>&1
>  	local ret1=$?
> -	ip netns exec ns2 ping -c 1 10.1.1.11 &> /dev/null
> +	ip netns exec ns2 ping -c 1 10.1.1.11 >/dev/null 2>&1
>  	local ret2=$?
>  
>  	if [ $ret1 -eq 0 -a $ret2 -eq 0 ]; then
> @@ -72,7 +72,6 @@ test_xdp_redirect()
>  	cleanup
>  }
>  
> -set -e
>  trap cleanup 2 3 6 9
>  
>  test_xdp_redirect xdpgeneric
> 
> base-commit: 6183f4d3a0a2ad230511987c6c362ca43ec0055f
> 


-- 
~Randy


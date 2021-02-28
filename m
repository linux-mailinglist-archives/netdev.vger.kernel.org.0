Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C26F0327553
	for <lists+netdev@lfdr.de>; Mon,  1 Mar 2021 00:47:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231358AbhB1Xlw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 28 Feb 2021 18:41:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47270 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230207AbhB1Xlw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 28 Feb 2021 18:41:52 -0500
Received: from mail-oo1-xc35.google.com (mail-oo1-xc35.google.com [IPv6:2607:f8b0:4864:20::c35])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C8CC4C06174A
        for <netdev@vger.kernel.org>; Sun, 28 Feb 2021 15:41:11 -0800 (PST)
Received: by mail-oo1-xc35.google.com with SMTP id x19so3539073ooj.10
        for <netdev@vger.kernel.org>; Sun, 28 Feb 2021 15:41:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=B4eVObotJQ8FpOttvSU0+eCO87xvE/vfsfK0urWlTyg=;
        b=gCydXOQDL0B4ttLRkTxvZtgJEmvfYeX+AMhDZFrQNcSFV65g334zMskJCXgsekYaGL
         ONUEB9WaABtLhhRa/e2l7e5vsSzKzs+buL+F+cWuIemxXO3fH64KpS2YLtYUM/2Fbq6u
         CvctJ84orGI4kJ5rPnkUMBhSxsjOukF30TUz1i7y9gydualklhVhqcD9NqC49TJrN3/w
         Z3oTy2twCDIP48RmHt99t2YDvUY4pwisLfNpFzRDXkdiNtLMb6et3YULv+2bO6rG6hWH
         Yhtn1Yuck0UypLjbDFJTc6uvU29jEWjHAFN/9adJpC/5uw6DBNvolXJ8G6GQbD+NAWcH
         13jA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=B4eVObotJQ8FpOttvSU0+eCO87xvE/vfsfK0urWlTyg=;
        b=MMQyIaq4VQN+AlB0W1T710nYIVCeTAEs8yYIrH35GfAZY1KpJA1ssuCf59vVG1uRhT
         zIxxPQemBcMe/sVNjvCk2k7/4FIODtkwbjZ5TP0tjCKA18Nj01h7KtR5RokIM6vExZCn
         gDsVhjdVSd5LcUCSTaCgRy9AcUFUWF0jVUr3SXy24oWDZY/X6uspwSpEEM4/2CII315T
         /8q3XjHzuVoR7nbsagHGBpkaG7YSKHsZtTY6j7avuKf62AHayBi8TB+czRPuV3Lc/nyI
         /igweVwTJqbLSFieiJtllCVmLOhE/cGFaj0kEd+0k9mbG0+/rl0LSSIeb07+w8010IUM
         fxIg==
X-Gm-Message-State: AOAM532jqb4is56aLJcSYs/4NL/4gxNZtszNXBjRMEcVb0Sod/5LYN3f
        eGhSVe3I4/yJOt0mN1HWWb0=
X-Google-Smtp-Source: ABdhPJxbMna2ph/QSKRPpe8ZGVxl2CCtcflV8Oll92X/yEWwyLsozFSu2Gcq27D35+9/crWPDS4kRQ==
X-Received: by 2002:a4a:1883:: with SMTP id 125mr10430322ooo.6.1614555671279;
        Sun, 28 Feb 2021 15:41:11 -0800 (PST)
Received: from Davids-MacBook-Pro.local ([8.48.134.40])
        by smtp.googlemail.com with ESMTPSA id 43sm3425645otv.69.2021.02.28.15.41.09
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 28 Feb 2021 15:41:10 -0800 (PST)
Subject: Re: [RFC PATCH net 2/2] selftests: fib_nexthops: Test blackhole
 nexthops when loopback goes down
To:     Ido Schimmel <idosch@idosch.org>, netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, roopa@nvidia.com,
        sharpd@nvidia.com, mlxsw@nvidia.com,
        Ido Schimmel <idosch@nvidia.com>
References: <20210228142613.1642938-1-idosch@idosch.org>
 <20210228142613.1642938-3-idosch@idosch.org>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <75d794f7-e0f2-503e-b858-f60114706fe2@gmail.com>
Date:   Sun, 28 Feb 2021 16:41:09 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.16; rv:78.0)
 Gecko/20100101 Thunderbird/78.7.1
MIME-Version: 1.0
In-Reply-To: <20210228142613.1642938-3-idosch@idosch.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2/28/21 7:26 AM, Ido Schimmel wrote:
> From: Ido Schimmel <idosch@nvidia.com>
> 
> Test that blackhole nexthops are not flushed when the loopback device
> goes down.
> 


> 
> Signed-off-by: Ido Schimmel <idosch@nvidia.com>
> ---
>  tools/testing/selftests/net/fib_nexthops.sh | 8 ++++++++
>  1 file changed, 8 insertions(+)
> 
> diff --git a/tools/testing/selftests/net/fib_nexthops.sh b/tools/testing/selftests/net/fib_nexthops.sh
> index 4c7d33618437..d98fb85e201c 100755
> --- a/tools/testing/selftests/net/fib_nexthops.sh
> +++ b/tools/testing/selftests/net/fib_nexthops.sh
> @@ -1524,6 +1524,14 @@ basic()
>  	run_cmd "$IP nexthop replace id 2 blackhole dev veth1"
>  	log_test $? 2 "Blackhole nexthop with other attributes"
>  
> +	# blackhole nexthop should not be affected by the state of the loopback
> +	# device
> +	run_cmd "$IP link set dev lo down"
> +	check_nexthop "id 2" "id 2 blackhole"
> +	log_test $? 0 "Blackhole nexthop with loopback device down"
> +
> +	run_cmd "$IP link set dev lo up"
> +
>  	#
>  	# groups
>  	#
> 

Thanks for adding a test.

Reviewed-by: David Ahern <dsahern@gmail.com>


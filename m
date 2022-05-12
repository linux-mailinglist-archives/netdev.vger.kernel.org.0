Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E2B25524FEF
	for <lists+netdev@lfdr.de>; Thu, 12 May 2022 16:28:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344944AbiELO2H (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 May 2022 10:28:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33996 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241180AbiELO2G (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 May 2022 10:28:06 -0400
Received: from mail-ot1-x333.google.com (mail-ot1-x333.google.com [IPv6:2607:f8b0:4864:20::333])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A31B124599
        for <netdev@vger.kernel.org>; Thu, 12 May 2022 07:28:05 -0700 (PDT)
Received: by mail-ot1-x333.google.com with SMTP id z15-20020a9d65cf000000b00605f064482cso2805599oth.6
        for <netdev@vger.kernel.org>; Thu, 12 May 2022 07:28:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=5uoHlQPl/6jY1+exb0E9dSN+HtYbKmrBYafdJjlRsGc=;
        b=elua2LF4NHEx256J65vtl6olydKZHUkb2SejHvNh5Tzta/27gaICVQTo6kCNTHb2hC
         XSpoJ+LVsGUyY9YTE33cVlTkA6kzvS9s+IL01CtQWeQ11AHu39HwP5KjofVJax31VNC+
         k360i9X5peRu9c5vcGP4JtUOaWnGCtKOmyngg=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=5uoHlQPl/6jY1+exb0E9dSN+HtYbKmrBYafdJjlRsGc=;
        b=CLhRmnf91K+2uDskAFrMN4pmZ2d9jaR03sLqBnUnNgfh3oGUFY6KZBgHJXBMR0jxb5
         f8ZLfz3MuXYSsz6CPCET140PjIVaQWvZl19yIX0/1/WErSb95dMnZYYvV8cQmsWUJ/54
         hlkj7DDA+bXzUT146wciNNTlLqA7vvPYlKLOoZn6i1SCUnAjuFKbMCt4+WZdT8zTRSPk
         51BjZRVMUogw9Xj4pWsRfXBmDgtU5HiNnmUV2OXfeadYgef9ja8JYrk8ZqYpdHSb07dp
         glkF1iEhH/Q8bXZZLR1wmG2f6PM2/yFcKtivDIdvESJ0IxPMOvcXzXm6Pj7337bQs5fA
         d/6w==
X-Gm-Message-State: AOAM530RBkXZ8kElpiN2bV+LsTeKmCizqIQctXxdkwU0p66dCNihhJVt
        VP2Jl2h8KoOxdY61mRCC/ggW4w==
X-Google-Smtp-Source: ABdhPJzN7YEGfAZb0aDyt9lSC5bkdpiZCMpK/kxbSwq+Gu8SzMDyxBcQOKEMOzTlS7yj8GHTSsGdQw==
X-Received: by 2002:a9d:875:0:b0:605:fbdd:ae3d with SMTP id 108-20020a9d0875000000b00605fbddae3dmr75062oty.352.1652365684910;
        Thu, 12 May 2022 07:28:04 -0700 (PDT)
Received: from [192.168.1.128] ([38.15.45.1])
        by smtp.gmail.com with ESMTPSA id k10-20020a056808068a00b00328b3d8a80fsm1485074oig.50.2022.05.12.07.28.04
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 12 May 2022 07:28:04 -0700 (PDT)
Subject: Re: [PATCH net-next] selftests: fib_nexthops: Make the test more
 robust
To:     Amit Cohen <amcohen@nvidia.com>, netdev@vger.kernel.org
Cc:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, shuah@kernel.org, mlxsw@nvidia.com,
        Shuah Khan <skhan@linuxfoundation.org>
References: <20220512131207.2617437-1-amcohen@nvidia.com>
From:   Shuah Khan <skhan@linuxfoundation.org>
Message-ID: <c45dd146-0c70-348a-5680-35beb1b20285@linuxfoundation.org>
Date:   Thu, 12 May 2022 08:28:03 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <20220512131207.2617437-1-amcohen@nvidia.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-5.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 5/12/22 7:12 AM, Amit Cohen wrote:
> Rarely some of the test cases fail. Make the test more robust by increasing
> the timeout of ping commands to 5 seconds.
> 

Can you explain why test cases fail?

> Signed-off-by: Amit Cohen <amcohen@nvidia.com>
> ---
>   tools/testing/selftests/net/fib_nexthops.sh | 48 ++++++++++-----------
>   1 file changed, 24 insertions(+), 24 deletions(-)
> 
> diff --git a/tools/testing/selftests/net/fib_nexthops.sh b/tools/testing/selftests/net/fib_nexthops.sh
> index b3bf5319bb0e..a99ee3fb2e13 100755
> --- a/tools/testing/selftests/net/fib_nexthops.sh
> +++ b/tools/testing/selftests/net/fib_nexthops.sh
> @@ -882,13 +882,13 @@ ipv6_fcnal_runtime()
>   	log_test $? 0 "Route delete"
>   
>   	run_cmd "$IP ro add 2001:db8:101::1/128 nhid 81"
> -	run_cmd "ip netns exec me ping -c1 -w1 2001:db8:101::1"
> +	run_cmd "ip netns exec me ping -c1 -w5 2001:db8:101::1"
>   	log_test $? 0 "Ping with nexthop"
>   
Looks like the change uses "-w deadline" - "-W timeout" might
be a better choice if ping fails with no response?

thanks,
-- Shuah

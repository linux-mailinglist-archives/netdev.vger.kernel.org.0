Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 348DC5252C6
	for <lists+netdev@lfdr.de>; Thu, 12 May 2022 18:40:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356573AbiELQkO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 May 2022 12:40:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36476 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1356571AbiELQkL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 May 2022 12:40:11 -0400
Received: from mail-oa1-x35.google.com (mail-oa1-x35.google.com [IPv6:2001:4860:4864:20::35])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D7277268229
        for <netdev@vger.kernel.org>; Thu, 12 May 2022 09:40:10 -0700 (PDT)
Received: by mail-oa1-x35.google.com with SMTP id 586e51a60fabf-e93bbb54f9so7263264fac.12
        for <netdev@vger.kernel.org>; Thu, 12 May 2022 09:40:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=nJHIG9whqzYvVQ1XdTS+j88+Ky9JEAivL9Y9i7uONTM=;
        b=K/zw8DFOpLD8OHuTM47ECLj8g+O/r1Fz9NSUbuZNhwQupwIC2h672srHeof+p9foXX
         VnPC1hJ9kGRVcdOWiifADlskKnowe+iVy8WsGvNTGlNLnXwrRrhyTZVgC4bBgJ8tDt9w
         QwU6xKWUUlf8r226l6NgunOt7V7osv3XoezLs=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=nJHIG9whqzYvVQ1XdTS+j88+Ky9JEAivL9Y9i7uONTM=;
        b=o+w2I9c/UcVOLiBTedHYVMblM5pc3h7OwLERNUxH0B4VLyeVwqUjE7lDnwqXXNaiKS
         dTU8GZD6F9oLJa0pjNjBGD9hFITQeOsKTqmrogCLlvhSzccg9RCe7u2X671i8qbcFuc8
         lw8qlIscF6G4IVkq8epNIQmXsXEjzZ+JeGAzUQBwHe56x1eSBQrsGF2WgNRztGiLjixB
         MB01knozXHpgKZVOFuxmexc1L2YFanZFdXj44zwPH+DiwkQRcJ69Whq5HpL8TLI+TXWG
         dmu1RHXitp1imvrPcpW3s/S+Xv2PFw39ITUeOeA0qtYO7vuZrlhMpsrlqhPWOCt0M3YO
         DQOQ==
X-Gm-Message-State: AOAM533WetuSQrAN84RRrLtCy3/b8ddRPQuTUDpm0KbTf9E9xlOo9Yvc
        xZ/34Guj1CZsqaOYalFFnYnIOQ==
X-Google-Smtp-Source: ABdhPJwI+2FqWetXTErMQuMG31Lp5XMaZKWSTpZGS0ld7Oa3+KM0GEAWWE91tR9fvSldk0UOnuKBJw==
X-Received: by 2002:a05:6870:d207:b0:ed:9899:1f84 with SMTP id g7-20020a056870d20700b000ed98991f84mr374566oac.198.1652373610208;
        Thu, 12 May 2022 09:40:10 -0700 (PDT)
Received: from [192.168.1.128] ([38.15.45.1])
        by smtp.gmail.com with ESMTPSA id c26-20020a9d481a000000b00606aaae39f4sm72249otf.8.2022.05.12.09.40.08
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 12 May 2022 09:40:09 -0700 (PDT)
Subject: Re: [PATCH net-next] selftests: fib_nexthops: Make the test more
 robust
To:     Amit Cohen <amcohen@nvidia.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Cc:     "davem@davemloft.net" <davem@davemloft.net>,
        "edumazet@google.com" <edumazet@google.com>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        "shuah@kernel.org" <shuah@kernel.org>, mlxsw <mlxsw@nvidia.com>,
        "dsahern@kernel.org" <dsahern@kernel.org>,
        Shuah Khan <skhan@linuxfoundation.org>
References: <20220512131207.2617437-1-amcohen@nvidia.com>
 <c45dd146-0c70-348a-5680-35beb1b20285@linuxfoundation.org>
 <DM6PR12MB3066EB87CEE0F9627F3C9592CBCB9@DM6PR12MB3066.namprd12.prod.outlook.com>
From:   Shuah Khan <skhan@linuxfoundation.org>
Message-ID: <26e610ee-2e78-2593-6fc9-904949a38d6e@linuxfoundation.org>
Date:   Thu, 12 May 2022 10:40:07 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <DM6PR12MB3066EB87CEE0F9627F3C9592CBCB9@DM6PR12MB3066.namprd12.prod.outlook.com>
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

On 5/12/22 9:17 AM, Amit Cohen wrote:
> 
> 
>> -----Original Message-----
>> From: Shuah Khan <skhan@linuxfoundation.org>
>> Sent: Thursday, May 12, 2022 5:28 PM
>> To: Amit Cohen <amcohen@nvidia.com>; netdev@vger.kernel.org
>> Cc: davem@davemloft.net; edumazet@google.com; kuba@kernel.org; pabeni@redhat.com; shuah@kernel.org; mlxsw
>> <mlxsw@nvidia.com>; Shuah Khan <skhan@linuxfoundation.org>
>> Subject: Re: [PATCH net-next] selftests: fib_nexthops: Make the test more robust
>>
>> On 5/12/22 7:12 AM, Amit Cohen wrote:
>>> Rarely some of the test cases fail. Make the test more robust by increasing
>>> the timeout of ping commands to 5 seconds.
>>>
>>
>> Can you explain why test cases fail?
> 
> The failures are probably caused due to slow forwarding performance.
> You can see similar commit - b6a4fd680042 ("selftests: forwarding: Make ping timeout configurable").
> 

My primary concern is that this patch simply changes the value
and doesn't make it configurable. Sounds like the above commit
does that. Why not use the same approach to keep it consistent.

>>
>>> Signed-off-by: Amit Cohen <amcohen@nvidia.com>
>>> ---
>>>    tools/testing/selftests/net/fib_nexthops.sh | 48 ++++++++++-----------
>>>    1 file changed, 24 insertions(+), 24 deletions(-)
>>>
>>> diff --git a/tools/testing/selftests/net/fib_nexthops.sh b/tools/testing/selftests/net/fib_nexthops.sh
>>> index b3bf5319bb0e..a99ee3fb2e13 100755
>>> --- a/tools/testing/selftests/net/fib_nexthops.sh
>>> +++ b/tools/testing/selftests/net/fib_nexthops.sh
>>> @@ -882,13 +882,13 @@ ipv6_fcnal_runtime()
>>>    	log_test $? 0 "Route delete"
>>>
>>>    	run_cmd "$IP ro add 2001:db8:101::1/128 nhid 81"
>>> -	run_cmd "ip netns exec me ping -c1 -w1 2001:db8:101::1"
>>> +	run_cmd "ip netns exec me ping -c1 -w5 2001:db8:101::1"
>>>    	log_test $? 0 "Ping with nexthop"
>>>
>> Looks like the change uses "-w deadline" - "-W timeout" might
>> be a better choice if ping fails with no response?
> 
> We usually use "-w" in ping commands in selftests, but I can change it if you prefer "-W".
> 

I will defer to networking experts/maintainers on the choice of
-w vs -W

I would like to see the timeout configurable.

thanks,
-- Shuah

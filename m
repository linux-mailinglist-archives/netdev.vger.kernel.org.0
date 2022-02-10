Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 50D324B1803
	for <lists+netdev@lfdr.de>; Thu, 10 Feb 2022 23:15:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344887AbiBJWPg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Feb 2022 17:15:36 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:47314 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344868AbiBJWPf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Feb 2022 17:15:35 -0500
Received: from mail-io1-xd2c.google.com (mail-io1-xd2c.google.com [IPv6:2607:f8b0:4864:20::d2c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2688F1139
        for <netdev@vger.kernel.org>; Thu, 10 Feb 2022 14:15:36 -0800 (PST)
Received: by mail-io1-xd2c.google.com with SMTP id n17so9241392iod.4
        for <netdev@vger.kernel.org>; Thu, 10 Feb 2022 14:15:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=EOJCZlWtnaUAqUSbnSeiKKhH2IwojqmUtfeSmw0q78U=;
        b=Q/d0wrOm6M783QMRxF1jZN6EmO/xV3HHfO8yZWm7f7ij/lYlpuYtLHZ5W48ZnSl5tr
         IHAzRq5pbzGRx0H5ypA9TXk5ZOvmT35OVOzbKc1n5hcTRf0jPUkzbV/UoPtBhuuPrSJM
         zmheiR0YJe/Ny21GHTsIKkOJRJHcnW2CjGnB0=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=EOJCZlWtnaUAqUSbnSeiKKhH2IwojqmUtfeSmw0q78U=;
        b=Wzykf08mjD3p9kkAfMrmTC7T6HjGULzra5pPXdYXN4ZUCwqLNCUH0zueNzqOix6Nfo
         UxwTLp4W4bZ2aPbggRsyPG/7P4mRqX29+c9SmwD3NIkxrxiTrQSE2hCk4vOuDSJ3ZPrD
         zuHt6ab0UPfKHVdJXLIRJXwqimU6iJ4MNKU19HUV0YYTRCueQkaDHrWEbZojwNwilPTe
         EP1McnKuM/36w68Z16vMPXHL8Cq5bBoQ60f3aNPCdKKUSsUUODp4Jf8GimuonDWduxQ1
         bjkLiV6zwmeldE0YbeK2/j9gplK5YpE/SEQIPhRg2SJ/ZdrTWV2UkPKxe8jLVgBmTEjx
         5icw==
X-Gm-Message-State: AOAM530BboOwDqilI56Dw8pF6PqpKK7kOH0o1FNFNg1HE4HD4uf/we47
        ILxMokEDics3wuwmsXOYKl2JqdX2uJxlyw==
X-Google-Smtp-Source: ABdhPJzZe3214Rziic0zSZxbipcgLIu3ZL5p/9SqAc6FL/T1Gg83dfbgw2cAkIBYcA1WFQ6fVhD3uA==
X-Received: by 2002:a05:6602:2cd3:: with SMTP id j19mr4870736iow.17.1644531335139;
        Thu, 10 Feb 2022 14:15:35 -0800 (PST)
Received: from [192.168.1.128] ([71.205.29.0])
        by smtp.gmail.com with ESMTPSA id i17sm9029851ilq.19.2022.02.10.14.15.34
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 10 Feb 2022 14:15:34 -0800 (PST)
Subject: Re: [PATCH net-next] ipv6: Reject routes configurations that specify
 dsfield (tos)
To:     Guillaume Nault <gnault@redhat.com>
Cc:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>,
        Shuah Khan <shuah@kernel.org>, linux-kselftest@vger.kernel.org,
        =?UTF-8?Q?Toke_H=c3=b8iland-J=c3=b8rgensen?= <toke@redhat.com>,
        Shuah Khan <skhan@linuxfoundation.org>
References: <51234fd156acbe2161e928631cdc3d74b00002a7.1644505353.git.gnault@redhat.com>
 <7bbeba35-17a7-f8ba-0587-4bb1c9b6721e@linuxfoundation.org>
 <20220210220516.GA31389@pc-4.home>
From:   Shuah Khan <skhan@linuxfoundation.org>
Message-ID: <0b401730-4f18-4e61-1c88-1dce438d6166@linuxfoundation.org>
Date:   Thu, 10 Feb 2022 15:15:34 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <20220210220516.GA31389@pc-4.home>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2/10/22 3:05 PM, Guillaume Nault wrote:
> On Thu, Feb 10, 2022 at 11:23:20AM -0700, Shuah Khan wrote:
>> On 2/10/22 8:08 AM, Guillaume Nault wrote:
>>> The ->rtm_tos option is normally used to route packets based on both
>>> the destination address and the DS field. However it's ignored for
>>> IPv6 routes. Setting ->rtm_tos for IPv6 is thus invalid as the route
>>> is going to work only on the destination address anyway, so it won't
>>> behave as specified.
>>>
>>> Suggested-by: Toke Høiland-Jørgensen <toke@redhat.com>
>>> Signed-off-by: Guillaume Nault <gnault@redhat.com>
>>> ---
>>> The same problem exists for ->rtm_scope. I'm working only on ->rtm_tos
>>> here because IPv4 recently started to validate this option too (as part
>>> of the DSCP/ECN clarification effort).
>>> I'll give this patch some soak time, then send another one for
>>> rejecting ->rtm_scope in IPv6 routes if nobody complains.
>>>
>>>    net/ipv6/route.c                         |  6 ++++++
>>>    tools/testing/selftests/net/fib_tests.sh | 13 +++++++++++++
>>>    2 files changed, 19 insertions(+)
>>>
>>> diff --git a/net/ipv6/route.c b/net/ipv6/route.c
>>> index f4884cda13b9..dd98a11fbdb6 100644
>>> --- a/net/ipv6/route.c
>>> +++ b/net/ipv6/route.c
>>> @@ -5009,6 +5009,12 @@ static int rtm_to_fib6_config(struct sk_buff *skb, struct nlmsghdr *nlh,
>>>    	err = -EINVAL;
>>>    	rtm = nlmsg_data(nlh);
>>> +	if (rtm->rtm_tos) {
>>> +		NL_SET_ERR_MSG(extack,
>>> +			       "Invalid dsfield (tos): option not available for IPv6");
>>
>> Is this an expected failure on ipv6, in which case should this test report
>> pass? Should it print "failed as expected" or is returning fail from errout
>> is what should happen?
> 
> This is an expected failure. When ->rtm_tos is set, iproute2 fails with
> error code 2 and prints
> "Error: Invalid dsfield (tos): option not available for IPv6.".
> 
> The selftest redirects stderr to /dev/null by default (unless -v is
> passed on the command line) and expects the command to fail and
> return 2. So the default output is just:
> 
> IPv6 route with dsfield tests
>      TEST: Reject route with dsfield                                     [ OK ]
> 
> Of course, on a kernel that accepts non-null ->rtm_tos, "[ OK ]"
> becomes "[FAIL]", and the the failed tests couter is incremented.
> 

Sounds good to me.

>>
>> With the above comment addressed or explained.
>>
>> Reviewed-by: Shuah Khan <skhan@linuxfoundation.org>
>>

thanks,
-- Shuah




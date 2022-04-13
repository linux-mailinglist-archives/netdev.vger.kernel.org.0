Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BB3074FF2D7
	for <lists+netdev@lfdr.de>; Wed, 13 Apr 2022 11:01:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229878AbiDMJDM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Apr 2022 05:03:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42570 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234260AbiDMJDE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 Apr 2022 05:03:04 -0400
Received: from mail-ed1-x535.google.com (mail-ed1-x535.google.com [IPv6:2a00:1450:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A1DF0252AA
        for <netdev@vger.kernel.org>; Wed, 13 Apr 2022 02:00:43 -0700 (PDT)
Received: by mail-ed1-x535.google.com with SMTP id b24so1510315edu.10
        for <netdev@vger.kernel.org>; Wed, 13 Apr 2022 02:00:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=blackwall-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language
         :from:to:cc:references:in-reply-to:content-transfer-encoding;
        bh=5ZKbS5mFW0wYcfmERfQx2D+wsG6WIRzsydtnS1G3otA=;
        b=kTRmGMVKJL4Lbotut2iU3K6cxKxnhKkntNjNs4zGWHEPXgAvf8m3/8Dh71lAvt0U7+
         9Un3v9b12rqAPg7D5UjNmQ9hAavvbtdb+ck9bL/6NWkkcG49ak7BtkfDBKiz2mhOfNCZ
         xiUeBctyZ+97hKJwS3BkUDRag/+M+bIhPpOEYXRLVRCGMJOHEztwsRRBuPHlnSsHlLIW
         dbEKlU8WUQK69mt1WdQXpOXo5OGTMMtJu9mH8N2/I9U5Elyn9whK3zDZ3Zg7HFqNHRsT
         ZzpCyOgFhznESvKXnABLIJLPaUM8/AVHhtS9KtjfXeKMJOxDDiRi54brFA5N96UURMZ5
         Xrdg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:from:to:cc:references:in-reply-to
         :content-transfer-encoding;
        bh=5ZKbS5mFW0wYcfmERfQx2D+wsG6WIRzsydtnS1G3otA=;
        b=tVztPJzJ5NGj32HaZ1xU6QkYo3iIejx4mRiloqmB5kcTruRgJNLWmKt/KZM068Z2iO
         lSShHDpvez0o8FIJqmTcFu4V1EgwvwoUV3pzyYyVIaAe68M70qsJxZ6+KH6/rG/+iJ3b
         uUWb0pQCE9acgXOrWNp9jWjhV4KmW6/4nOZo7j2qSMPaVkQVuA3o00WWx/nmqahETKHK
         WcWf4v/U9recCdkH+nS6mT1MWDFZ0MsMMDLSodnVkePfD0pZwDv/6TD9Dx622RS4W28X
         9qgJ+MuM9+ewUOZgA61pe74KCUbxUwU9aSm2+FfvuA6bIGEjh4C57X8c7yhFc1BN4XEW
         xBWA==
X-Gm-Message-State: AOAM533K16FaBgXbRYtbY/p6MWGrLWlaoBJppGZ04ppXbz6ZsXxWIIs9
        PPcwGyGQFTTnhbKPcB7zuoycOQ==
X-Google-Smtp-Source: ABdhPJx2xF/aOgjmJNQlWTN9v9v6QBFPrUjiDQPVS6Uqe+j9Y3OLSjqJB3FtZRtoNtVk8eRix8IHtQ==
X-Received: by 2002:a05:6402:50c7:b0:419:534f:bbd7 with SMTP id h7-20020a05640250c700b00419534fbbd7mr41354575edb.209.1649840442131;
        Wed, 13 Apr 2022 02:00:42 -0700 (PDT)
Received: from [192.168.0.111] (87-243-81-1.ip.btc-net.bg. [87.243.81.1])
        by smtp.gmail.com with ESMTPSA id q15-20020a1709060e4f00b006cdf4535cf2sm13875685eji.67.2022.04.13.02.00.41
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 13 Apr 2022 02:00:41 -0700 (PDT)
Message-ID: <586b97b3-0882-b42c-20f8-275a05b51beb@blackwall.org>
Date:   Wed, 13 Apr 2022 12:00:40 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Subject: Re: [PATCH RFC net-next 08/13] net: bridge: avoid classifying unknown
 multicast as mrouters_only
Content-Language: en-US
From:   Nikolay Aleksandrov <razor@blackwall.org>
To:     Joachim Wiberg <troglobit@gmail.com>,
        Roopa Prabhu <roopa@nvidia.com>
Cc:     netdev@vger.kernel.org, bridge@lists.linux-foundation.org,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Tobias Waldekranz <tobias@waldekranz.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>
References: <20220411133837.318876-1-troglobit@gmail.com>
 <20220411133837.318876-9-troglobit@gmail.com>
 <ebd182a2-20bc-471c-e649-a2689ea5a5d1@blackwall.org>
 <87v8ve9ppr.fsf@gmail.com>
 <5d597756-2fe1-e7cc-9ef3-c0323e2274f2@blackwall.org>
 <87pmll9xj1.fsf@gmail.com>
 <96bb8ff0-26d8-e9d3-e7c8-78f2abd28126@blackwall.org>
In-Reply-To: <96bb8ff0-26d8-e9d3-e7c8-78f2abd28126@blackwall.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 13/04/2022 11:55, Nikolay Aleksandrov wrote:
> On 13/04/2022 11:51, Joachim Wiberg wrote:
>> On Tue, Apr 12, 2022 at 20:37, Nikolay Aleksandrov <razor@blackwall.org> wrote:
>>> On 12/04/2022 20:27, Joachim Wiberg wrote:
>>>> [snip]
>>>> From this I'd like to argue that our current behavior in the bridge is
>>>> wrong.  To me it's clear that, since we have a confiugration option, we
>>>> should forward unknown IP multicast to all MCAST_FLOOD ports (as well as
>>>> the router ports).
>>> Definitely not wrong. In fact:
>>> "Switches that do not forward unregistered packets to all ports must
>>>  include a configuration option to force the flooding of unregistered
>>>  packets on specified ports. [..]"
>>> is already implemented because the admin can mark any port as a router and
>>> enable flooding to it.
>>
>> Hmm, I understand your point (here and below), and won't drive this
>> point further.  Instead I'll pick up on what you said in your first
>> reply ... (below, last)
>>
>> Btw, thank you for taking the time to reply and explain your standpoint,
>> really helps my understanding of how we can develop the bridge further,
>> without breaking userspace! :)
>>
>>>> [1]: https://www.rfc-editor.org/rfc/rfc4541.html#section-2.1.2
>>> RFC4541 is only recommending, it's not a mandatory behaviour. This
>>> default has been placed for a very long time and a lot of users and
>>> tests take it into consideration.
>>
>> Noted.
>>
>>> We cannot break such assumptions and start suddenly flooding packets,
>>> but we can leave it up to the admin or distribution/network software
>>> to configure it as default.
>>
>> So, if I add a bridge flag, default off as you mentioned out earlier,
>> which changes the default behavior of MCAST_FLOOD, then you'd be OK with
>> that?  Something cheeky like this perhaps:
>>
>>     if (!ipv4_is_local_multicast(ip_hdr(skb)->daddr))
>>        	BR_INPUT_SKB_CB(skb)->mrouters_only = !br_opt_get(br, BROPT_MCAST_FLOOD_RFC4541);
> 
> Exactly! And that is exactly what I had in mind when I wrote it. :)
> 

Just please use a different option name that better suggests what it does.

> Thanks,
>  Nik
> 
>>
>>
>> Best regards
>>  /Joachim
> 


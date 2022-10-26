Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 14AEC60E22D
	for <lists+netdev@lfdr.de>; Wed, 26 Oct 2022 15:31:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233395AbiJZNbu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Oct 2022 09:31:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38806 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232848AbiJZNbs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Oct 2022 09:31:48 -0400
Received: from mail-wm1-x32a.google.com (mail-wm1-x32a.google.com [IPv6:2a00:1450:4864:20::32a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A08D3895E6
        for <netdev@vger.kernel.org>; Wed, 26 Oct 2022 06:31:46 -0700 (PDT)
Received: by mail-wm1-x32a.google.com with SMTP id bg9-20020a05600c3c8900b003bf249616b0so1569841wmb.3
        for <netdev@vger.kernel.org>; Wed, 26 Oct 2022 06:31:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=6wind.com; s=google;
        h=content-transfer-encoding:in-reply-to:organization:from:references
         :to:content-language:subject:reply-to:user-agent:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=UeRQpvVAu2xFCVrsjKJ2OWu65v6j6njSjEQjRY7nMSU=;
        b=W4ToOAKj5E9+X2DQQ64R2c6cDLtlm35Z9f/lvLa9NPnInjf4LYoUOBknI1J1YQiTTv
         zTqG1sq/LmaEYmRYwzGSshLCdTuwRVgwP7o781yrDvo/dmlLJa1KzcsZbvWhmtKx8Z3z
         P1Z0SqeS7x6el1hSyUqkkiBCGs44bVgC8J65QA3Ahh7xtrzBcOA/wDBVa6QEGh1WkNYM
         g5YND6pYUelA+ZPU0Ts6+GaTrUW1/Po+N3YGH2w5QMXp9RoHzdJ98q11MUu89tBgBvgT
         mzAIuzLFAoIwjtqO95aeUfu3BvdvXsccSMkHKoGPzKWVrsk42NasjDqkuO4LtuD7vWMa
         tZsw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:organization:from:references
         :to:content-language:subject:reply-to:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=UeRQpvVAu2xFCVrsjKJ2OWu65v6j6njSjEQjRY7nMSU=;
        b=76b2Cm/j0rs1PEPRBIIiY1yw4Vb/rGVAE32bNtQV6r2pSH3cGs7mrXT3c5is29yYMO
         9AKQNruh/j0DiMEpGdPES8tE8NJywoMo2KrShKCRYUOhij/xo2UqvX4JiDisZWwEeup6
         1gOQx8EY3NluTUCTX9PMo+rXcTYnnu2f6/rf4Bl+AXOB3gLyItmvNBG4taPaTdpEsGoX
         RgoayhVWYHEn/Mh/zWjIZg8kZvkQZVXa/mdSOhUzo5rKcJ1FACXJG/POWwv1c95qRUcm
         kXsq+AjEQbffP/Zscb9LUnP1oVlaTYlzbXwJg2a5q0pxbBC+gAp7w8GNsFG3+evwdfLO
         Rg7Q==
X-Gm-Message-State: ACrzQf2K+HM3oFbiFjGJQp1IgnH8+e3WyaiTeJq17mXBOf/w6KsFEUEa
        KoIzv3XnDx7pxsNZYQ8t+qQP5w==
X-Google-Smtp-Source: AMsMyM6pizyIY8tsQBk2NrbtSiuAplvZtLeu8EV7hIiKsVB25wnKYjPZuDmk3TZrUK+o9YiJoXtfUQ==
X-Received: by 2002:a05:600c:3848:b0:3c7:1832:2b6b with SMTP id s8-20020a05600c384800b003c718322b6bmr2473424wmr.28.1666791104577;
        Wed, 26 Oct 2022 06:31:44 -0700 (PDT)
Received: from ?IPV6:2a01:e0a:b41:c160:e8f9:50eb:973f:3244? ([2a01:e0a:b41:c160:e8f9:50eb:973f:3244])
        by smtp.gmail.com with ESMTPSA id a2-20020a056000050200b0023662245d3csm5363748wrf.95.2022.10.26.06.31.43
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 26 Oct 2022 06:31:43 -0700 (PDT)
Message-ID: <9497b5f8-1f48-1d38-3a26-65ea03d9036f@6wind.com>
Date:   Wed, 26 Oct 2022 15:31:42 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.2.2
Reply-To: nicolas.dichtel@6wind.com
Subject: Re: Bug in netlink monitor
Content-Language: en-US
To:     George Shuklin <george.shuklin@gmail.com>, netdev@vger.kernel.org
References: <2528510b-3463-8a8b-25c2-9402a8a78fcd@gmail.com>
 <037d30a7-15e3-34c7-8fdd-2cf356430355@6wind.com>
 <9753a024-5499-af09-ccc2-21c3c614ea64@gmail.com>
From:   Nicolas Dichtel <nicolas.dichtel@6wind.com>
Organization: 6WIND
In-Reply-To: <9753a024-5499-af09-ccc2-21c3c614ea64@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Le 26/10/2022 à 14:41, George Shuklin a écrit :
> On 26/10/2022 11:34, Nicolas Dichtel wrote:
>> Le 25/10/2022 à 13:18, George Shuklin a écrit :
>>> I found that if veth interface is created in a namespace using netns option for
>>> ip, no events are logged in `ip monitor all-nsid`.
>>>
>>> Steps to reproduce:
>>>
>>>
>>> (console1)
>>>
>>> ip monitor all-nsid
>>>
>>>
>>> (console 2)
>>>
>>> ip net add foobar
>>>
>>> ip link add netns foobar type veth
>>>
>>>
>>> Expected results:
>>>
>>> Output in `ip monitor`. Actual result: no output, (but there are two new veth
>>> interaces in foobar namespace).
>>>
>>> Additional observation: namespace 'foobar' does not have id in output of `ip
>>> net`:
>> This is why.
>> https://man7.org/linux/man-pages/man8/ip-monitor.8.html
>>
>> "       If the all-nsid option is set, the program listens to all network
>>         namespaces that have a nsid assigned into the network namespace
>>         were the program is running"
>>
>> You can assign one with:
>> ip netns set foobar auto
>>
> Oh, I missed that.
> 
> But I think it's making things a bit odd, because there are network events in
> the system which are not visible in `ip monitor` (no matter what options are set).
It's not visible, because this netns is not visible.

> 
> Are there a way to see _all_ network events?
No. Remember that network namespace are used for isolation. There are a lot of
scenarii where you don't have to know what happen in another netns, even not
that another netns exists ;-)

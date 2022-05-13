Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A70A75265B8
	for <lists+netdev@lfdr.de>; Fri, 13 May 2022 17:12:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350764AbiEMPMq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 May 2022 11:12:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52176 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1358895AbiEMPMl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 May 2022 11:12:41 -0400
Received: from mail-wm1-x334.google.com (mail-wm1-x334.google.com [IPv6:2a00:1450:4864:20::334])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 17F7A54014
        for <netdev@vger.kernel.org>; Fri, 13 May 2022 08:12:40 -0700 (PDT)
Received: by mail-wm1-x334.google.com with SMTP id bg25so4961457wmb.4
        for <netdev@vger.kernel.org>; Fri, 13 May 2022 08:12:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=6wind.com; s=google;
        h=message-id:date:mime-version:user-agent:reply-to:subject
         :content-language:to:cc:references:from:organization:in-reply-to
         :content-transfer-encoding;
        bh=ENNi8dxp63i9aV+m2eeaEgksj3tupb9990n9Fg4X7Jc=;
        b=AxMnps+Q70CbZ8FChIqVOjRg8P3Gis/igNQ0Pzd7z5cadeSOb7FlyLH3rP5Zgpx4B0
         xAh4pqULg5I8rBQHC2PaV5VMPwON+FDjlyCr+iKsOXFQDGOAe5Xy3SW0ycfFNEgjMsqr
         BZbVsTlf+luYCLiwFlp1Be6v2bgNsgzZfS9K+YPY2fuC1bt2tCGcmeb668MKb3Ro3ZXO
         5CJAKxgdOlGMOseam2CpZSIymKcEBVI9YHbyAIIOnw7Qk6l/17x4sjL+S3DcwGtiAMUC
         DUrI5q2aoZMn0kIFXX9p47gJmm48j2FIdsrqFfteeqJb82BAQCMmYCyT1FrUvwOcNn8R
         LQLQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:reply-to
         :subject:content-language:to:cc:references:from:organization
         :in-reply-to:content-transfer-encoding;
        bh=ENNi8dxp63i9aV+m2eeaEgksj3tupb9990n9Fg4X7Jc=;
        b=CHC8nyxpsJwLrqIDY+2F8zqQt5AR5irmoESxdynnpgKfg7U6ko7F7/lEI6TEumIkQD
         Dzm4VxqZrmoae3UcXms1fF2gkZ6o91nLzovwFJ8C4srzbEOskoPEqHPpnEVkyvGSN4n5
         YEowgJWXuCid8S1VWox2ac3h0Y13DLMwVr7cemfdUjCa1GU4KFgAk6cxp3u7nmE3gM8d
         N5CJeRSwGHe6PYan7heZ/uALkPJxvy3hhMHUJC5dP6hvILxXEghdNltaXD49om3YVaHR
         qV3zBRGQ3NoiYHZK9qbG6Cyd9ogXc9RWcWDqXKm6+EjfrxpuAn+98pQJwvkY1QFtXw0f
         eFOA==
X-Gm-Message-State: AOAM5327LOI0UHVOXWhDb2NllloKzhpVvBg9IJgrv9/borJ3HA3uG43c
        UGMe3cckL5d6tJ6ykvai8O2sgg==
X-Google-Smtp-Source: ABdhPJyqBqvoqb1oFUH753G5u/vril12rLr+OkPi0S2tFdJ2T8f4CWfZEvUleJinJ4PEf+OZhGMB4Q==
X-Received: by 2002:a05:600c:19c8:b0:394:7cb0:717b with SMTP id u8-20020a05600c19c800b003947cb0717bmr5163488wmq.136.1652454758612;
        Fri, 13 May 2022 08:12:38 -0700 (PDT)
Received: from ?IPV6:2a01:e0a:b41:c160:80f4:a72:758d:7910? ([2a01:e0a:b41:c160:80f4:a72:758d:7910])
        by smtp.gmail.com with ESMTPSA id y11-20020adfc7cb000000b0020cf41017b4sm1344659wrg.19.2022.05.13.08.12.37
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 13 May 2022 08:12:37 -0700 (PDT)
Message-ID: <56903463-9d73-8cb1-52ee-07d12430ed7a@6wind.com>
Date:   Fri, 13 May 2022 17:12:36 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.1
Reply-To: nicolas.dichtel@6wind.com
Subject: Re: [PATCH ipsec] xfrm: fix "disable_policy" flag use when arriving
 from different devices
Content-Language: en-US
To:     Eyal Birger <eyal.birger@gmail.com>
Cc:     davem@davemloft.net, yoshfuji@linux-ipv6.org, dsahern@kernel.org,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        steffen.klassert@secunet.com, herbert@gondor.apana.org.au,
        netdev@vger.kernel.org, Shmulik Ladkani <shmulik.ladkani@gmail.com>
References: <20220512104831.976553-1-eyal.birger@gmail.com>
 <dca644d9-aee1-9eae-19fb-b134b19827ec@6wind.com>
 <CAHsH6GtFfam4j9T0oBOkEjZqOjQu7j1SrGsjb40mrd1pVF0-ag@mail.gmail.com>
From:   Nicolas Dichtel <nicolas.dichtel@6wind.com>
Organization: 6WIND
In-Reply-To: <CAHsH6GtFfam4j9T0oBOkEjZqOjQu7j1SrGsjb40mrd1pVF0-ag@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-5.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org




Le 12/05/2022 à 18:29, Eyal Birger a écrit :
> On Thu, May 12, 2022 at 7:09 PM Nicolas Dichtel
> <nicolas.dichtel@6wind.com> wrote:
>>
>>
>> Le 12/05/2022 à 12:48, Eyal Birger a écrit :
>>> In IPv4 setting the "disable_policy" flag on a device means no policy
>>> should be enforced for traffic originating from the device. This was
>>> implemented by seting the DST_NOPOLICY flag in the dst based on the
>>> originating device.
>>>
>>> However, dsts are cached in nexthops regardless of the originating
>>> devices, in which case, the DST_NOPOLICY flag value may be incorrect.
>>>
>>> Consider the following setup:
>>>
>>>                      +------------------------------+
>>>                      | ROUTER                       |
>>>   +-------------+    | +-----------------+          |
>>>   | ipsec src   |----|-|ipsec0           |          |
>>>   +-------------+    | |disable_policy=0 |   +----+ |
>>>                      | +-----------------+   |eth1|-|-----
>>>   +-------------+    | +-----------------+   +----+ |
>>>   | noipsec src |----|-|eth0             |          |
>>>   +-------------+    | |disable_policy=1 |          |
>>>                      | +-----------------+          |
>>>                      +------------------------------+
>>>
>>> Where ROUTER has a default route towards eth1.
>>>
>>> dst entries for traffic arriving from eth0 would have DST_NOPOLICY
>>> and would be cached and therefore can be reused by traffic originating
>>> from ipsec0, skipping policy check.
>>>
>>> Fix by setting a IPSKB_NOPOLICY flag in IPCB and observing it instead
>>> of the DST in IN/FWD IPv4 policy checks.
>>>
>>> Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
>>> Reported-by: Shmulik Ladkani <shmulik.ladkani@gmail.com>
>>> Signed-off-by: Eyal Birger <eyal.birger@gmail.com>
>>> ---
>>
>> [snip]
>>
>>> @@ -1852,8 +1856,7 @@ static int __mkroute_input(struct sk_buff *skb,
>>>               }
>>>       }
>>>
>>> -     rth = rt_dst_alloc(out_dev->dev, 0, res->type,
>>> -                        IN_DEV_ORCONF(in_dev, NOPOLICY),
>>> +     rth = rt_dst_alloc(out_dev->dev, 0, res->type, no_policy,>                         IN_DEV_ORCONF(out_dev, NOXFRM));
>> no_policy / DST_NOPOLICY is still needed in the dst entry after this patch?
> 
> I see it's being set in the outbound direction in IPv4 - though I don't see
> where it's actually used in that direction.
> 
> Maybe it could be cleaned up as a follow up, but I wanted to scope this
> patch to the bugfix.
Sure, the cleanup should be put in a separate patch. Removing the flag for ipv4
could help to avoid ambiguity.


Thank you,
Nicolas

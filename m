Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6EE9E528F3C
	for <lists+netdev@lfdr.de>; Mon, 16 May 2022 21:53:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241478AbiEPTxX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 May 2022 15:53:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56672 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348365AbiEPTws (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 May 2022 15:52:48 -0400
Received: from mail-wr1-x42b.google.com (mail-wr1-x42b.google.com [IPv6:2a00:1450:4864:20::42b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AAC974551C
        for <netdev@vger.kernel.org>; Mon, 16 May 2022 12:48:26 -0700 (PDT)
Received: by mail-wr1-x42b.google.com with SMTP id w4so21852971wrg.12
        for <netdev@vger.kernel.org>; Mon, 16 May 2022 12:48:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=solid-run-com.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=Jv2Ibfr5W+dJj2eQLEYufMVC7N7nymr5jHPEWoS7p/w=;
        b=hVhRRbYC3+KIUVCzzVMx5KazITa9VCpj3vLG76svyGK6EUEx/e4Y4tsNmxxJ03DSMW
         /Kf+7HFKZtQrk4F97rr/0XETZxLXVD1gNwhoG2SppnG1tk2tHEWNoqi/zMcodOfJzVLk
         Kdgqhm2/eZ+ujoPrA1Bp0WImmEtgzLDSt2PbkjCOOloDQrjNIwxDdB9fkTyTPY0i8+Cs
         D05NK60ej4W1x+uI3gyL4Q/RJnlbpRvI+N65wNgR6SZpRTSBp2GbztsTEnxehC8xaZbm
         dTOCEBMl2BtDwTcQIAZZlITDod0s1PxSH5igzdGekYAtrzD2r8LHQTs889fQHi/X6ahO
         W4+g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=Jv2Ibfr5W+dJj2eQLEYufMVC7N7nymr5jHPEWoS7p/w=;
        b=25/Mpm+Z2/oAVP0XVbn3H5/BsH8Vbw5VuC4OmRR0goaCmUAkOiLzY0vdo/9Y4c7ed1
         dAnbhf7JD4GQCc0edWSF1WTpLMLDBVcIb9aLvdN3ARAfydyjJ1mNZEZfvxVd8PVDFtrJ
         N0AxsZK4Ix4KogDKoG6a/rOu7NeTST55ol4qQjoMJQVzpY7E5kuBs/R+jp+g9lRC2HRx
         ZGO4d57p65LNXoU4DNIegFlG9hxy1m0donhlyolJIaOPNy3EXPbs2Uls4iyCNb0CrspL
         Z6SEvgVn2jN48cKui8QtuFZ1SBIDdMj8zRla46X7rt3/oDlx6q87forFGxaXYVR8uxbB
         4oVg==
X-Gm-Message-State: AOAM5322ZtQWpMwcaU1rYaOoh/TRwWF2fF9arPWnZ+XR/8bg0hrFI8Lj
        leMyJEVNmNGKhWadxEsHx6NfspP/DRcwEWMbw8irIg==
X-Google-Smtp-Source: ABdhPJzMs726b4qDrO6U+kLHf+vvHthWKLfVrjdOOHcKqZi7pQImUWHYFM0+PWH2YUfjzrtz4daTdA==
X-Received: by 2002:a5d:6488:0:b0:203:b628:70d2 with SMTP id o8-20020a5d6488000000b00203b62870d2mr15588279wri.83.1652730504268;
        Mon, 16 May 2022 12:48:24 -0700 (PDT)
Received: from ?IPV6:2a10:8000:dc4b::1005? ([2a10:8000:dc4b::1005])
        by smtp.gmail.com with ESMTPSA id r7-20020adfab47000000b0020d0a57af5esm3112864wrc.79.2022.05.16.12.48.21
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 16 May 2022 12:48:23 -0700 (PDT)
Message-ID: <ab86220b-f583-4c77-0ddf-a3e25f5bc840@solid-run.com>
Date:   Mon, 16 May 2022 22:48:20 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.0
Subject: Re: [PATCH v4 1/3] dt-bindings: net: adin: document phy clock
Content-Language: en-US
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Michael Walle <michael@walle.cc>, alexandru.ardelean@analog.com,
        alvaro.karsz@solid-run.com, davem@davemloft.net,
        edumazet@google.com, krzysztof.kozlowski+dt@linaro.org,
        michael.hennerich@analog.com, netdev@vger.kernel.org,
        pabeni@redhat.com, robh+dt@kernel.org
References: <20220510133928.6a0710dd@kernel.org>
 <20220511125855.3708961-1-michael@walle.cc>
 <20220511091136.34dade9b@kernel.org>
 <c457047dd2af8fc0db69d815db981d61@walle.cc>
 <20220511124241.7880ef52@kernel.org>
 <bfe71846f940be3c410ae987569ddfbf@walle.cc>
 <20220512154455.31515ead@kernel.org>
 <072a773c-2e42-1b82-9fe7-63c9a3dc9c7d@solid-run.com>
 <20220516104336.3a76579e@kernel.org>
From:   Josua Mayer <josua@solid-run.com>
In-Reply-To: <20220516104336.3a76579e@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.3 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Am 16.05.22 um 20:43 schrieb Jakub Kicinski:
> On Sun, 15 May 2022 10:16:47 +0300 Josua Mayer wrote:
>> Am 13.05.22 um 01:44 schrieb Jakub Kicinski:
>>> On Thu, 12 May 2022 23:20:18 +0200 Michael Walle wrote:
>>>>> It's pure speculation on my side. I don't even know if PHYs use
>>>>> the recovered clock to clock its output towards the MAC or that's
>>>>> a different clock domain.
>>>>>
>>>>> My concern is that people will start to use DT to configure SyncE which
>>>>> is entirely a runtime-controllable thing, and doesn't belong.
>> Okay.
>> However phy drivers do not seem to implement runtime control of those
>> clock output pins currently, so they are configured once in DT.
> To me that means nobody needs the recovered clock.
Doesn't need it, or is overwhelmed by the idea of figuring out how to 
implement it properly.
>>>>> Hence
>>>>> my preference to hide the recovered vs free-running detail if we can
>>>>> pick one that makes most sense for now.
>> I am not a fan of hiding information. The clock configuration register
>> clearly supports this distinction.
> Unless you expose all registers as a direct API to the user you'll be
> "hiding information". I don't think we are exposing all possible
> registers for this PHY, the two bits in question are no different.
>
>> Is this a political stance to say users may not "accidentally" enable
>> SyncE by patching DT?
>> If so we should print a warning message when someone selects it?
> Why would we add a feature and then print a warning? We can always add
> the support later, once we have a use case for it.
I would not call it a feature.
We can e.g. not print a warning, and instead put in the DT binding a 
note that the recovered variants are for SyncE which Linux does not 
support.

As to why we would add the -recovered options,
for starters this allows curious developers to search for the term to 
get an idea which PHYs would technically support it.
That it would also allow tinkering with SyncE to me is a plus, but for 
you clearly a minus, and I can not make a strong case.

So I can imagine to change the bindings as follows:
1. remove the -recovered variants
2. add an explicit note in the commit message that the recovered clock 
is not implemented because we do not have infrastructure for SyncE
3. keep the -free-running suffix, we should imo only hide it on the day 
SyncE can be toggled by another means.

> I see. That makes sense, but then wouldn't it make more sense to pick
> the (simple) free-running one? As for SyncE you'd need the recovered
> clock.
>>> Sounds good.
>> Yep, it seems recovered clock is only for SyncE - and only if there is a
>> master clock on the network. Sadly however documentation is sparse and I
>> do not know if the adi phys would fall back to using their internal
>> clock, or just refuse to operate at all.

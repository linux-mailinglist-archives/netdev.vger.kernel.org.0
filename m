Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8EF976CFD21
	for <lists+netdev@lfdr.de>; Thu, 30 Mar 2023 09:43:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229535AbjC3HnC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Mar 2023 03:43:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43308 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229448AbjC3HnA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Mar 2023 03:43:00 -0400
Received: from mail-ed1-x531.google.com (mail-ed1-x531.google.com [IPv6:2a00:1450:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AEE5F4219
        for <netdev@vger.kernel.org>; Thu, 30 Mar 2023 00:42:59 -0700 (PDT)
Received: by mail-ed1-x531.google.com with SMTP id 4fb4d7f45d1cf-502627e17c0so900a12.0
        for <netdev@vger.kernel.org>; Thu, 30 Mar 2023 00:42:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1680162178; x=1682754178;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=DwIorkvy8AMr6qWuv5Sgygro5VQi/ok0cmZ9UTW4AJo=;
        b=l+lSMLQJIh91Gh48CofiVFpNznZDTuqfxQSCiiNT5iTPWfzSYqzW3nU+RTUC7aqQow
         FzvMFBc2NpvjBPMv8AnKRNCPc/ZhXtHesjL+COdpA7022i/Hah9wXA/5a25LzXgijljS
         761EhY9RtXX9jkqG+zs1eezRgxe1lzhbp26LIKA37Qlwgjhg8U8tO6IEAuojTlCxW5Em
         JYHHoYv8XPaywsdZLyWEIOa9MfbWARtteAHIIhHYSEdHHR+SmAjPBJkDWAU1yVX03UW2
         egrwiE3bYfOfSh5ga3kXn4et1205Q8U9H+PalKM76xdeiEXlrAjSkt1T0YA7uM0hQ0iU
         L3ew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680162178; x=1682754178;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=DwIorkvy8AMr6qWuv5Sgygro5VQi/ok0cmZ9UTW4AJo=;
        b=a86ISHKQgkL75JoRfoBHQUCLcBFBmDkfNSmG/Z4SY9JoWDLXgvVQecUkO8STKVyG5S
         vc3YnBdqfgNfidzKe3yyfDfckv18Durod12Hs0OKZ9VsqY9/J8esyGpBloE1bGXPsRcy
         mQDC+ah8RdXTIsszKQ/AKPO4lY9G1+LGfHEP6SN69RU/1ny7nh1f9FURlBfFwVxW9/j4
         X4ZXcjqkt2+PXDL53eiuccedyWmE7zjXvu2pPl5LHVS7HFw3ANH0AOVft/GltSl00rJF
         YpkWCETIx9Nqanv+BI/CEubS4xMjy1tkK4JZB4n0ntji2C8jpAdMLzfAv8K+kG+gTbNx
         eQtg==
X-Gm-Message-State: AAQBX9docSLXSoaszlSPS8NYp/oCwIoKckiUMVPhir6iPMNSezBgkOBP
        +C5WVKL7KxdaK6sY0+RBgc752Q==
X-Google-Smtp-Source: AKy350arftL2hG+9fn77zGMqf7Pc316tSkXIQ09SZgH33a1GABxSCD+Od3azTv6Gscv1M9OHpye8hg==
X-Received: by 2002:a05:6402:5003:b0:502:53aa:433f with SMTP id p3-20020a056402500300b0050253aa433fmr55086eda.0.1680162177935;
        Thu, 30 Mar 2023 00:42:57 -0700 (PDT)
Received: from [192.168.2.107] ([79.115.63.91])
        by smtp.gmail.com with ESMTPSA id ha25-20020a170906a89900b00934212e973esm14511608ejb.198.2023.03.30.00.42.56
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 30 Mar 2023 00:42:57 -0700 (PDT)
Message-ID: <179721c2-f471-0e26-9023-4742a5e2489c@google.com>
Date:   Thu, 30 Mar 2023 08:42:56 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.1
Subject: Re: [PATCH] net: Fix invalid ip_route_output_ports() call
Content-Language: en-US
To:     Steffen Klassert <steffen.klassert@secunet.com>,
        Hyunwoo Kim <v4bel@theori.io>
Cc:     Eric Dumazet <edumazet@google.com>,
        Taehee Yoo <ap420073@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, Dmitry Kozlov <xeb@mail.ru>,
        David Ahern <dsahern@kernel.org>, netdev@vger.kernel.org,
        imv4bel@gmail.com, Lee Jones <joneslee@google.com>
References: <20230321024946.GA21870@ubuntu>
 <CANn89i+=-BTZyhg9f=Vyz0rws1Z-1O-F5TkESBjkZnKmHeKz1g@mail.gmail.com>
 <20230321050803.GA22060@ubuntu> <ZBmMUjSXPzFBWeTv@gauss3.secunet.de>
 <20230321111430.GA22737@ubuntu>
 <CANn89iJVU1yfCfyyUpmMeZA7BEYLfVXYsK80H26WM=hB-1B27Q@mail.gmail.com>
 <20230321113509.GA23276@ubuntu> <ZB10DlJoNmGhRINM@gauss3.secunet.de>
From:   Tudor Ambarus <tudordana@google.com>
In-Reply-To: <ZB10DlJoNmGhRINM@gauss3.secunet.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-15.7 required=5.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,ENV_AND_HDR_SPF_MATCH,
        NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi, Steffen!

On 3/24/23 09:57, Steffen Klassert wrote:
> On Tue, Mar 21, 2023 at 04:35:09AM -0700, Hyunwoo Kim wrote:
>> On Tue, Mar 21, 2023 at 04:19:25AM -0700, Eric Dumazet wrote:
>>> On Tue, Mar 21, 2023 at 4:14 AM Hyunwoo Kim <v4bel@theori.io> wrote:
>>>>
>>>> I'm not sure what 'ip x p' means, as my understanding of XFRM is limited, sorry.
>>>
>>> Since your repro does not set up a private netns.
>>>
>>> Please install the iproute2 package (if not there already) and run the
>>> following command
>>>
>>> sudo ip x p
>>>
>>> man ip
>>>
>>> IP(8)                                      Linux
>>>                IP(8)
>>>
>>> NAME
>>>        ip - show / manipulate routing, network devices, interfaces and tunnels
>>>
>>> SYNOPSIS
>>
>> This is the result of creating a new netns, running repro, and then running the ip x p command:
>> ```
>> src 255.1.0.0/0 dst 0.0.0.0/0
>> 	dir out priority 0
>> 	mark 0/0x6
>> 	tmpl src 0.0.0.0 dst 0.0.0.0
>> 		proto comp reqid 0 mode beet
>> 		level 16
>> 	tmpl src fc00:: dst e000:2::
>> 		proto ah reqid 0 mode tunnel
>> 		level 32
>> 	tmpl src ac14:14bb:: dst ac14:14fa::
>> 		proto route2 reqid 0 mode transport
>> 		level 3
>> 	tmpl src :: dst 2001::1
>> 		proto ah reqid 0 mode in_trigger
>> 	tmpl src ff01::1 dst 7f00:1::
>> 		proto comp reqid 0 mode transport
>> ```
> 
> I plan to fix this with the patch below. With this, the above policy
> should be rejected. It still needs a bit of testing to make sure that
> I prohibited no valid usecase with it.
> 
> ---
> Subject: [PATCH RFC ipsec] xfrm: Don't allow optional intermediate templates that
>  changes the address family
> 
> When an optional intermediate template changes the address family,
> it is unclear which family the next template should have. This can
> lead to misinterpretations of IPv4/IPv6 addresses. So reject
> optional intermediate templates on insertion time.
> 
> Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
> Reported-by: Hyunwoo Kim <v4bel@theori.io>
> Signed-off-by: Steffen Klassert <steffen.klassert@secunet.com>
> ---
>  net/xfrm/xfrm_user.c | 9 +++++++++
>  1 file changed, 9 insertions(+)
> 

What's the status of this patch? I'm asking because LTS kernels are
affected and we'll have to fix them too. I tried searching for a related
patch on public ml archives and into the IPSEC repositories and I
couldn't find one.

Thanks!
ta

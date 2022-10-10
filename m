Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2966B5F9EA0
	for <lists+netdev@lfdr.de>; Mon, 10 Oct 2022 14:19:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232430AbiJJMT5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 Oct 2022 08:19:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33612 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232319AbiJJMTs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 10 Oct 2022 08:19:48 -0400
Received: from mail-wr1-x42c.google.com (mail-wr1-x42c.google.com [IPv6:2a00:1450:4864:20::42c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 73D42272E
        for <netdev@vger.kernel.org>; Mon, 10 Oct 2022 05:19:39 -0700 (PDT)
Received: by mail-wr1-x42c.google.com with SMTP id a10so16718957wrm.12
        for <netdev@vger.kernel.org>; Mon, 10 Oct 2022 05:19:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=6wind.com; s=google;
        h=content-transfer-encoding:in-reply-to:organization:from:references
         :cc:to:content-language:subject:reply-to:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=g/ZHjNHsGoaehn5niIwN9gyFHAZsxlv7mG7cEwEx2B0=;
        b=WMf+npDtzFcGMB3EuCNLTRlDEapRE5ulr+KRjG5zeMaPJPWfrgXL6wepvhrvtima4z
         k7y/ISn6MvXvSaLh0QQS6P9U9a8hE/8bU48B9dYOEdBhoScggW7QgoG9qmgoOX/FXdJQ
         g1zxEqhW6kEMUhvoICyUPQrXTekWXIFCZUerZuj4fC1fBcUcjaXrNMNGp5lRlTdh2VU0
         f8nlIiaf0pI8mYyppqqs9zZb9+m/1ReN4UPWNiw3AkU0tXDW9fRyN2mgvTIHnvg+MQGy
         WJ4CN/9a3smkc0NGmyfJZIdaDttKUXRwE65iVGx3yZOFXdk7Z+hpKsUhTD48PmWWJmAJ
         5bRQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:organization:from:references
         :cc:to:content-language:subject:reply-to:user-agent:mime-version
         :date:message-id:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=g/ZHjNHsGoaehn5niIwN9gyFHAZsxlv7mG7cEwEx2B0=;
        b=bIYNZgPr0USEUaLAufKKtPKgo03K8g0T5VkkIcKcLzeeN892WwEiRG8On8WBFtFrre
         GGMm6YZPF1clmhpnMoTACXVxHoQgzblUcITM2La/jOaGsOgZRiy35hL0cCae1F3ez+PH
         RU7DQtxLJivx5dhYCF6cdOwd2gSJph/N69iB1drc+SKonvYHqZmctx12jr1rQZ/kcY+z
         gUJAfjTBRdqlrClU3J8P7cCqvl0PXiEfXN88/nSisTbVK6lA08weez2Xj9GUtJAR4Uc4
         L/XXPp2hwKSd9auSlmaJTEpWHWXGzt7G2ESIbvJxNKXXKf3LRvz6ZzfADW+/JtTDQXMo
         6VMA==
X-Gm-Message-State: ACrzQf0IP2YkQZekh5H2laVmx2IuAKG7OnEqZ1oYtaPT317XRDFh0g7P
        YBlfUJGIQ/cbKM7kDP5xHsepjw==
X-Google-Smtp-Source: AMsMyM45C3sTvGf+a5kDI2DEPyDsv84fUVWidHMSBZrFsbmV23zHGTCP4R+JaNCMrFC17WpE8JwOrw==
X-Received: by 2002:a5d:6d8a:0:b0:22f:1ade:de87 with SMTP id l10-20020a5d6d8a000000b0022f1adede87mr8233476wrs.3.1665404378259;
        Mon, 10 Oct 2022 05:19:38 -0700 (PDT)
Received: from ?IPV6:2a01:e0a:b41:c160:5d4:a7f7:8743:2a68? ([2a01:e0a:b41:c160:5d4:a7f7:8743:2a68])
        by smtp.gmail.com with ESMTPSA id b21-20020a05600c151500b003c6b9749505sm1785766wmg.30.2022.10.10.05.19.36
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 10 Oct 2022 05:19:37 -0700 (PDT)
Message-ID: <0e3f881d-b469-566f-7cdf-317fb88c305a@6wind.com>
Date:   Mon, 10 Oct 2022 14:19:36 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.2.2
Reply-To: nicolas.dichtel@6wind.com
Subject: Re: [PATCH ipsec,v2] xfrm: fix "disable_policy" on ipv4 early demux
Content-Language: en-US
To:     Eyal Birger <eyal.birger@gmail.com>
Cc:     steffen.klassert@secunet.com, davem@davemloft.net,
        yoshfuji@linux-ipv6.org, dsahern@kernel.org, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, netdev@vger.kernel.org,
        monil191989@gmail.com, stephen@networkplumber.org
References: <20221009191643.297623-1-eyal.birger@gmail.com>
 <1fc3c7b2-027b-374d-b77a-e5a01b70e73a@6wind.com>
 <CAHsH6GthqV7nUmeujhX_=3425HTsV0sc6O7YxWg22qbwbP=KJg@mail.gmail.com>
From:   Nicolas Dichtel <nicolas.dichtel@6wind.com>
Organization: 6WIND
In-Reply-To: <CAHsH6GthqV7nUmeujhX_=3425HTsV0sc6O7YxWg22qbwbP=KJg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Le 10/10/2022 à 12:29, Eyal Birger a écrit :
> Hi Nicolas,
> 
> On Mon, Oct 10, 2022 at 11:28 AM Nicolas Dichtel
> <nicolas.dichtel@6wind.com> wrote:
>>
>> Le 09/10/2022 à 21:16, Eyal Birger a écrit :
>>> The commit in the "Fixes" tag tried to avoid a case where policy check
>>> is ignored due to dst caching in next hops.
>>>
>>> However, when the traffic is locally consumed, the dst may be cached
>>> in a local TCP or UDP socket as part of early demux. In this case the
>>> "disable_policy" flag is not checked as ip_route_input_noref() was only
>>> called before caching, and thus, packets after the initial packet in a
>>> flow will be dropped if not matching policies.
>>>
>>> Fix by checking the "disable_policy" flag also when a valid dst is
>>> already available.
>>>
>>> Link: https://bugzilla.kernel.org/show_bug.cgi?id=216557
>>> Reported-by: Monil Patel <monil191989@gmail.com>
>>> Fixes: e6175a2ed1f1 ("xfrm: fix "disable_policy" flag use when arriving from different devices")
>>> Signed-off-by: Eyal Birger <eyal.birger@gmail.com>
>>>
>>
>> Is there the same problem with ipv6?
> 
> The issue is specific to IPv4 as the original fix was only relevant
> to IPv4.
> 
> I also tested a similar scenario using IPv6 addresses and did not see
> a problem.
Thanks. Is it possible to write a selftest with this scenario?


Regards,
Nicolas

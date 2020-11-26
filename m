Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A6CB92C537B
	for <lists+netdev@lfdr.de>; Thu, 26 Nov 2020 13:02:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729843AbgKZMBN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Nov 2020 07:01:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42904 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726162AbgKZMBM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 Nov 2020 07:01:12 -0500
Received: from mail-ej1-x644.google.com (mail-ej1-x644.google.com [IPv6:2a00:1450:4864:20::644])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6E58FC0613D4
        for <netdev@vger.kernel.org>; Thu, 26 Nov 2020 04:01:12 -0800 (PST)
Received: by mail-ej1-x644.google.com with SMTP id k9so2516388ejc.11
        for <netdev@vger.kernel.org>; Thu, 26 Nov 2020 04:01:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=24QxSt+zZxNbiFImJZUoZ3gdMcMKbDpmm9bbAZF7EK0=;
        b=IolQgRM2jwcyZFpG7wm+djqftGzInOJ4AyNqsGmwLzh9SciLmxwfz+yivocy4guikz
         uSFWQdyubNKYiupxfXlJHRUOll+Fi4Nn120ehJI1jRjG8/MMqYB73OTOWd0Q2VCBvptq
         rn7uBr3DYJsQivsXd1VopyhIIvmiVI5uXZ0N4RtFmHAV7ePeU4BldoRP3H3phSlCM3zM
         cbF9iNb/pBLwtQICf6wDTQ8FyhQGkxvVE3oSuHu9Bn63/ZtDIQW+nCzoX/Zodb+hYqYA
         fAqO7iLcKD+ebG3CCwfyjJEW2iFaaCfkTGMbzykvTmxZPToKx0V1Y535R7MXRIOh8bdS
         fUbg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=24QxSt+zZxNbiFImJZUoZ3gdMcMKbDpmm9bbAZF7EK0=;
        b=L1nEfh9IWIKw/0toofnp//SB4gIYnO3MRUGbTG7/NK/EKjrnVl1otBDoALZMUAKz37
         x8g3RPg8yrxTzIeWEO8Y9FHOxByoCcjp0jbEeF8gCPIpA8aoMhufmc9WMl3w3WToC2Df
         yHXYzSemZ8N6krFgIy1BUbZkL9KTPemrMslO5vX29Cr+3OZdQtsc2kmR+53oNxD602sa
         wgIf8EZmdHDYzvNC3UoLw0yszFjgRl2Eu36h06or0q2dslcLFcwkLxOfiPIXjUg8Nc24
         D3Obz/KmVcHbRa0uMEYJe3+LY24fHN2k91Hl8xrEEtCLk6tJ1aScGENPDh0pTJHhp7Dh
         Cnug==
X-Gm-Message-State: AOAM532HhSRj/zGA+sy4/ffZI0E0jyGZzjHLxcNYyrTuinqi6YSpHaXt
        xyB+EcqoUWP+1kUyJrFVQ3E7NuQAXu4=
X-Google-Smtp-Source: ABdhPJwnl3m059byvV8u9Z9622MwyCiaS3sy5F6L2OMRu9UHvxuvPHPP+Nit19UknsMYrNpf5hXfqQ==
X-Received: by 2002:a17:906:7e43:: with SMTP id z3mr2302335ejr.67.1606392071169;
        Thu, 26 Nov 2020 04:01:11 -0800 (PST)
Received: from [192.168.0.110] ([77.127.85.120])
        by smtp.gmail.com with ESMTPSA id o33sm782195edd.50.2020.11.26.04.01.09
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 26 Nov 2020 04:01:10 -0800 (PST)
Subject: Re: [PATCH net] netdevice.h: Fix unintentional disable of ALL_FOR_ALL
 features on upper device
To:     Eric Dumazet <edumazet@google.com>,
        Herbert Xu <herbert@gondor.apana.org.au>
Cc:     Tariq Toukan <tariqt@nvidia.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        netdev <netdev@vger.kernel.org>,
        Moshe Shemesh <moshe@nvidia.com>,
        Maxim Mikityanskiy <maximmi@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
References: <20201123141256.14208-1-tariqt@nvidia.com>
 <CANn89iKRVyTZg-tNQvo_Ub-RZ_A+OOQQY8Py3J9fx=NOZXF9Qw@mail.gmail.com>
 <9bf8ba40-cd40-2af6-d358-48dd98526434@gmail.com>
 <CANn89iK8MXp0QmZbBKdMDHxi7A4afrVdBtgQq7cSY5SRefwraA@mail.gmail.com>
 <20201125032549.GA13059@gondor.apana.org.au>
 <329952c5-b208-1781-5604-2b408796ec90@gmail.com>
 <CANn89iLTsTgW9UPFn_LNN5Qvs9+0drfcW2cQHtCVYMoboHdv4Q@mail.gmail.com>
From:   Tariq Toukan <ttoukan.linux@gmail.com>
Message-ID: <c96d41dd-3679-c76f-2e3a-cb3fb0cfd6c3@gmail.com>
Date:   Thu, 26 Nov 2020 14:01:07 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.5.0
MIME-Version: 1.0
In-Reply-To: <CANn89iLTsTgW9UPFn_LNN5Qvs9+0drfcW2cQHtCVYMoboHdv4Q@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 11/25/2020 11:27 AM, Eric Dumazet wrote:
> On Wed, Nov 25, 2020 at 10:06 AM Tariq Toukan <ttoukan.linux@gmail.com> wrote:
>>
>>
>>
>> On 11/25/2020 5:25 AM, Herbert Xu wrote:
>>> On Tue, Nov 24, 2020 at 11:48:35AM +0100, Eric Dumazet wrote:
>>>>
>>>> Well, the 'increment' part was suggesting the function was adding
>>>> flags, not removing them.
>>>
>>> The idea of the increment part is that we're adding a constituent
>>> device, not that we're adding features.  There have always been
>>> features which were conjunctions, i.e., they must be supported by
>>> all underlying devices for them to be enabled on the virtual device.
>>>
>>> Your use of the increment function is unusual, as you're not adding
>>> features that belong to one underlying device, but rather you're
>>> trying to enable a feature on the virtual device unconditionally.
> 
> This was not the intent.
> 
> We can still disable TSO on the bonding device if desired.
> 
> pk51:~# for i in bond0 eth1 eth2; do ethtool -k $i|grep
> tcp-segmentation-offload; done
> tcp-segmentation-offload: on
> tcp-segmentation-offload: on
> tcp-segmentation-offload: on
> lpk51:~# ethtool -K bond0 tso off
> Actual changes:
> tcp-segmentation-offload: off
> tx-tcp-segmentation: off
> tx-tcp-ecn-segmentation: off
> tx-tcp-mangleid-segmentation: off
> tx-tcp6-segmentation: off
> large-receive-offload: off [requested on]
> lpk51:~# for i in bond0 eth1 eth2; do ethtool -k $i|grep
> tcp-segmentation-offload; done
> tcp-segmentation-offload: off
> tcp-segmentation-offload: on
> tcp-segmentation-offload: on
> 
> The intent was that we could have :
> 
> lpk51:~# ethtool -K bond0 tso on
> Actual changes:
> tcp-segmentation-offload: on
> tx-tcp-segmentation: on
> tx-tcp-ecn-segmentation: on
> tx-tcp-mangleid-segmentation: on
> tx-tcp6-segmentation: on
> lpk51:~# ethtool -K eth1 tso off
> lpk51:~# ethtool -K eth2 tso off
> lpk51:~# for i in bond0 eth1 eth2; do ethtool -k $i|grep
> tcp-segmentation-offload; done
> tcp-segmentation-offload: on
> tcp-segmentation-offload: off
> tcp-segmentation-offload: off
> lpk51:~#
> 
> 

IIUC, we want to let the bond TSO feature bit be totally independent, 
not affected by slaves.
If so, I think that:
First we should take NETIF_F_GSO_SOFTWARE (or just NETIF_F_ALL_TSO) out 
of NETIF_F_ONE_FOR_ALL.
Then, make sure it is set in bond_setup (it is already done, as part of 
BOND_VLAN_FEATURES).

I think this new logic is good for all other upper devices, which will 
be affected by the change in NETIF_F_ONE_FOR_ALL.


>>>
>>>> We might ask Herbert Xu if we :
>>>>
>>>> 1) Need to comment the function, or change its name to be more descriptive.
>>>> 2) Change the behavior (as you suggested)
>>>> 3) Other choice.
>>>
>>> I think Tariq's patch is fine, although a comment should be added
>>> to netdev_add_tso_features as this use of the increment function
>>> is nonstandard.
>>>
>>
>> Thanks Herbert, I'll add a comment and re-spin.
> 
> I think we should remove the use of  netdev_increment_features() and
> replace it with something else,
> because there is too much confusion.
> 

I think it would be best.

I can prepare the patch I described above if you agree with it.

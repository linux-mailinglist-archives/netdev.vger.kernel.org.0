Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A2AE32F50A8
	for <lists+netdev@lfdr.de>; Wed, 13 Jan 2021 18:09:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727335AbhAMRIN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Jan 2021 12:08:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43482 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726544AbhAMRIN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 Jan 2021 12:08:13 -0500
Received: from mail-wr1-x42c.google.com (mail-wr1-x42c.google.com [IPv6:2a00:1450:4864:20::42c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C771CC061786
        for <netdev@vger.kernel.org>; Wed, 13 Jan 2021 09:07:32 -0800 (PST)
Received: by mail-wr1-x42c.google.com with SMTP id a12so2891359wrv.8
        for <netdev@vger.kernel.org>; Wed, 13 Jan 2021 09:07:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=+/xffr4JTtf25bpV4ACP0RdqyvcKefGdvXjV4JqAIuo=;
        b=AofJe/5Btf+5rSM9WocEvBgdivCFlJQsX1zPHbrRiXePvDrfkjH1Y65TZDjK9H1rRf
         xbvCnQee78DRmo322YAC90/EisuZo058gUVzbhY8vRwuHFb7uws7CM2G+nrm2zpSMB/0
         8GOS7vVKXjYyw9O5VqvjK1x7VNZZJ+OnTsAjKpOAiEMmHx15pb/4sO3u/y+6ES5D/ciw
         YgRqVtA2plis7ElDPidyxXieZnexvXFr28838gvG5HvO4EHAPFnGPKEi/6Op+sFu8N6I
         ykTQyYvTewZck3zAlfpiSQB9GznyvA3gv2HSUoTsQyfSL8xc6R+RJysADnGJGOWVXCx5
         pt3g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=+/xffr4JTtf25bpV4ACP0RdqyvcKefGdvXjV4JqAIuo=;
        b=bYz7BjAFedBjXMQtIt6HdDy8h89bu4ZE6ZLIFiJ+A0YajL7+nbpkWl/z2Z1fJhHacD
         K+hoWXdq/aIOfoktUgfwNr5xP2spK88IMbSjTIhlOWC1N15MQIJ3DMBBhAWpSxwzA0ZR
         IVsIfcOVLYp9S9nO6qZ6nShn7EcaxxOuuDmL5asJHoXTm0QfPGpKsXijBz1ibQSJrrCU
         GBxDi666JB9a8N5Ceu5AypAusVTN+LfWh0nzRJLBbgct7nSXziNQgSHxnsq63LFseZti
         NT7nRSJLUkHiPV9dacptnEEJk2DfngpYStXBMa5c3RxNQmUbY7vIEH+9PaMJMc5HklLl
         74iQ==
X-Gm-Message-State: AOAM530ZnIfljHPWqidTeaWB8qBOD0asHE+nBV/8fzTGpQszlX3w2u+K
        cPb5odSR11ZF4G6k8Gzqsj3lDsLowZg=
X-Google-Smtp-Source: ABdhPJzdsFzZ//aOSq6ZMwKd3sOMbMR/Lv9zQx6rF4ytaTwcgCunC6uW71/naI2EXkPLeEjPaRfSMQ==
X-Received: by 2002:a05:6000:11c1:: with SMTP id i1mr3705954wrx.16.1610557651599;
        Wed, 13 Jan 2021 09:07:31 -0800 (PST)
Received: from [10.21.182.110] ([212.23.236.67])
        by smtp.gmail.com with ESMTPSA id b133sm4214341wme.33.2021.01.13.09.07.24
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 13 Jan 2021 09:07:30 -0800 (PST)
Subject: Re: [net] net: feature check mandating HW_CSUM is wrong
To:     Alexander Duyck <alexander.duyck@gmail.com>,
        rohit maheshwari <rohitm@chelsio.com>
Cc:     Jakub Kicinski <kuba@kernel.org>, Netdev <netdev@vger.kernel.org>,
        David Miller <davem@davemloft.net>, secdev@chelsio.com,
        Alexei Starovoitov <ast@kernel.org>,
        =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@intel.com>,
        Daniel Borkmann <daniel@iogearbox.net>, andriin@fb.com,
        Eric Dumazet <edumazet@google.com>,
        Cong Wang <xiyou.wangcong@gmail.com>, ap420073@gmail.com,
        Jiri Pirko <jiri@mellanox.com>, borisp@nvidia.com,
        Tariq Toukan <ttoukan.linux@gmail.com>,
        Tariq Toukan <tariqt@nvidia.com>
References: <20210106175327.5606-1-rohitm@chelsio.com>
 <20210106111710.34ab4eab@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <3d94bd63-dee0-3699-8e42-193e652592fa@chelsio.com>
 <CAKgT0UcbYhpngJ5qtXvDGK+nqCgUqa9m3CHBT0=ZeFxCvRJSxQ@mail.gmail.com>
From:   Tariq Toukan <ttoukan.linux@gmail.com>
Message-ID: <113bea13-8f7e-af0c-50de-936112a1bc48@gmail.com>
Date:   Wed, 13 Jan 2021 19:07:20 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.0
MIME-Version: 1.0
In-Reply-To: <CAKgT0UcbYhpngJ5qtXvDGK+nqCgUqa9m3CHBT0=ZeFxCvRJSxQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 1/13/2021 5:35 AM, Alexander Duyck wrote:
> On Tue, Jan 12, 2021 at 6:43 PM rohit maheshwari <rohitm@chelsio.com> wrote:
>>
>>
>> On 07/01/21 12:47 AM, Jakub Kicinski wrote:
>>> On Wed,  6 Jan 2021 23:23:27 +0530 Rohit Maheshwari wrote:
>>>> Mandating NETIF_F_HW_CSUM to enable TLS offload feature is wrong.
>>>> And it broke tls offload feature for the drivers, which are still
>>>> using NETIF_F_IP_CSUM or NETIF_F_IPV6_CSUM. We should use
>>>> NETIF_F_CSUM_MASK instead.
>>>>
>>>> Fixes: ae0b04b238e2 ("net: Disable NETIF_F_HW_TLS_TX when HW_CSUM is disabled")
>>>> Signed-off-by: Rohit Maheshwari <rohitm@chelsio.com>
>>> Please use Tariq's suggestion.
>> HW_TLS_TX feature is for both IPv4/v6. And If one device is limited to
>> support only IPv4 checksum offload, TLS offload should be allowed for
>> that too. So I think putting a check of CSUM_MASK is enough.
> 
> The issue is that there is no good software fallback if the packet
> arrives at the NIC and it cannot handle the IPv6 TLS offload.
> 
> The problem with the earlier patch you had is that it was just
> dropping frames if you couldn't handle the offload and "hoping" the
> other end would catch it. That isn't a good practice for any offload.
> If you have it enabled you have to have a software fallback and in
> this case it sounds like you don't have that.
> 
> In order to do that you would have to alter the fast path to have to
> check if the device is capable per packet which is really an
> undesirable setup as it would add considerable overhead and is open to
> race conditions.
> 

+1

Are there really such modern devices with missing IPv6 csum 
capabilities, or it's just a missing SW implementation in the device driver?

IMO, it sounds reasonable for this modern TLS device offload to asks for 
a basic requirement such as IPv6 csum offload capability, to save the 
overhead.


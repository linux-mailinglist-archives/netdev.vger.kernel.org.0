Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AD93749DCF4
	for <lists+netdev@lfdr.de>; Thu, 27 Jan 2022 09:51:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237926AbiA0Ivy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Jan 2022 03:51:54 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.129.124]:26738 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234366AbiA0Ivx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Jan 2022 03:51:53 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1643273513;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=1w0Az/cKrjE/HLp90TQLOsehyEFIF1hCJDvaHHSu/h0=;
        b=S24yuBEhuFZ66aE6XbcyPhRxoYJs7WwObFYirbqnBHJBbF0n1iq2YB+12eJ97/dVQWfKjA
        FlVCpvtgi3QeNCSgRLL2lQvaanklitProMpzfO8QxbwpH0laAc4L/AOXkRHYkOCdXsGe8y
        AWWqu13dJwG3lB+YU8APpmgjTntngto=
Received: from mail-ed1-f70.google.com (mail-ed1-f70.google.com
 [209.85.208.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-561-kFHMbGS4Mw2CDaom5gHIhQ-1; Thu, 27 Jan 2022 03:51:51 -0500
X-MC-Unique: kFHMbGS4Mw2CDaom5gHIhQ-1
Received: by mail-ed1-f70.google.com with SMTP id l14-20020aa7cace000000b003f7f8e1cbbdso1043522edt.20
        for <netdev@vger.kernel.org>; Thu, 27 Jan 2022 00:51:51 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:message-id:date:mime-version:user-agent:cc
         :subject:content-language:to:references:in-reply-to
         :content-transfer-encoding;
        bh=1w0Az/cKrjE/HLp90TQLOsehyEFIF1hCJDvaHHSu/h0=;
        b=WIS4Rduor/d83Jhoj83yv+v3trTa340IjzYHmmm6BrZvxIVfT9sDPtqsXF6JNBKxvN
         C/VsXxt4p1kpFM6ocfI7DrFUdSDlR73bh6cImL+oCtemF3Y31eKgrgkkKxQ5cwn0RNwB
         eWNVpLMeDnDV9tXCm0honrsBP1+jwZQwDBk2bPNkHmvUMwlilM8EypZrgj2oxY62KqHF
         p5C4jwRzR9m5oN69zkDh/KaXw6XYSzK0fI56Jde0RdWyee6+N/UI+9q7GEO4zyMlt+Y+
         qlCgk1lDRduCd8hLwcV/nuyDHP34YDjLhAoM3CzFD3HqUM2RNJHQoSv70E0eqyNrl1Ru
         7wDQ==
X-Gm-Message-State: AOAM531wqm+U4hTMNjMtV9Zq2d1Sh3DhtlmKbeptLGlLs+GILQq2R4pJ
        uIB80zq6NF2YET/JrUwoeWIv6m43AlxmKEhXSMU6cBRfAbe2C1wuJfNagq4VpA6gih44qhhQbMq
        9l6cQgU7K8ae2jgGs
X-Received: by 2002:a17:906:d88:: with SMTP id m8mr2103264eji.411.1643273510167;
        Thu, 27 Jan 2022 00:51:50 -0800 (PST)
X-Google-Smtp-Source: ABdhPJwTyjPifdCP+dCtaSrna+fjPqOZrido8Em6c1wTmRP5OiZalXBWLzugViTyVXVKMQ8ckupXng==
X-Received: by 2002:a17:906:d88:: with SMTP id m8mr2103254eji.411.1643273509938;
        Thu, 27 Jan 2022 00:51:49 -0800 (PST)
Received: from [192.168.0.50] (87-59-106-155-cable.dk.customer.tdc.net. [87.59.106.155])
        by smtp.gmail.com with ESMTPSA id s19sm8861607edr.23.2022.01.27.00.51.48
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 27 Jan 2022 00:51:49 -0800 (PST)
From:   Jesper Dangaard Brouer <jbrouer@redhat.com>
X-Google-Original-From: Jesper Dangaard Brouer <brouer@redhat.com>
Message-ID: <c7945726-6d6a-2361-3c5a-1f9e3187683a@redhat.com>
Date:   Thu, 27 Jan 2022 09:51:48 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.2.0
Cc:     brouer@redhat.com, kuba@kernel.org, davem@davemloft.net,
        ilias.apalodimas@linaro.org, hawk@kernel.org
Subject: Re: [PATCH net-next 0/6] net: page_pool: Add page_pool stat counters
Content-Language: en-US
To:     Joe Damato <jdamato@fastly.com>, netdev@vger.kernel.org
References: <1643237300-44904-1-git-send-email-jdamato@fastly.com>
In-Reply-To: <1643237300-44904-1-git-send-email-jdamato@fastly.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 26/01/2022 23.48, Joe Damato wrote:
> Greetings:
> 
> This series adds some stat counters for the page_pool allocation path which
> help to track:
> 
> 	- fast path allocations
> 	- slow path order-0 allocations
> 	- slow path high order allocations
> 	- refills which failed due to an empty ptr ring, forcing a slow
> 	  path allocation
> 	- allocations fulfilled via successful refill
> 	- pages which cannot be added to the cache because of numa mismatch
> 	  (i.e. waived)
> 
> Some static inline wrappers are provided for accessing these stats. The
> intention is that drivers which use the page_pool API can, if they choose,
> use this stats API.

You are adding (always on) counters to a critical fast-path, that 
drivers uses for the XDP_DROP use-case.

I want to see performance measurements as documentation, showing this is 
not causing a slow-down.

I have some performance tests here[1]:
  [1] 
https://github.com/netoptimizer/prototype-kernel/tree/master/kernel/lib

Look at:
  - bench_page_pool_simple.c and
  - bench_page_pool_cross_cpu.c

How to use + build this[2]:
  [2] 
https://prototype-kernel.readthedocs.io/en/latest/prototype-kernel/build-process.html

> It assumed that the API consumer will ensure the page_pool is not destroyed
> during calls to the stats API.
> 
> If this series is accepted, I'll submit a follow up patch which will export
> these stats per RX-ring via ethtool in a driver which uses the page_pool
> API.
> 
> Joe Damato (6):
>    net: page_pool: Add alloc stats and fast path stat
>    net: page_pool: Add a stat for the slow alloc path
>    net: page_pool: Add a high order alloc stat
>    net: page_pool: Add stat tracking empty ring
>    net: page_pool: Add stat tracking cache refills.
>    net: page_pool: Add a stat tracking waived pages.
> 
>   include/net/page_pool.h | 82 +++++++++++++++++++++++++++++++++++++++++++++++++
>   net/core/page_pool.c    | 15 +++++++--
>   2 files changed, 94 insertions(+), 3 deletions(-)
> 


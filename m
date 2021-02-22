Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5233F321232
	for <lists+netdev@lfdr.de>; Mon, 22 Feb 2021 09:46:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229987AbhBVIpz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Feb 2021 03:45:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41650 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229907AbhBVIpx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 22 Feb 2021 03:45:53 -0500
Received: from mail-wm1-x336.google.com (mail-wm1-x336.google.com [IPv6:2a00:1450:4864:20::336])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DA841C061574;
        Mon, 22 Feb 2021 00:45:12 -0800 (PST)
Received: by mail-wm1-x336.google.com with SMTP id l13so4006002wmg.5;
        Mon, 22 Feb 2021 00:45:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=WZ1TpVqC8jbOAE905d14DzJdnCbYipexqF0Xfhf38q0=;
        b=tRSBVpZfp7BN7eaY63r2/hmgFVZF4cG8NGhti13kMdgoomZW4zLYoV5D62aF/vstam
         GWjjxEnH6buLbtZ2WWbuelFrtuhNPxuQSnI+AWHDfwmHhrA83l40r1R79745tvpE5eNT
         Nl974nU1mfVIu7tYt2CWTdJD6KIwEbarHC4rV9Q4LUZz49yB0qVTGeSOfwzkdoNq40th
         fwEq0Vb0fhQIEzFGBL46f0yIqzWVNbPdXQI9h1f2FZkZS/HrJLtJLPo7tQBiefYLmEj8
         Ulx9PPCUTpUReU9MjedAp9ZHmRW8SeyRazbDoEYKUZhO6eHWvI1gJIT9c4dhhTAbsR35
         Ih/Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=WZ1TpVqC8jbOAE905d14DzJdnCbYipexqF0Xfhf38q0=;
        b=MgRC7NXIHFhRFG7e4BNBj56wDiQDAt8tmXU5CPYYZgZZ4FhKL8ym+IPRHiMpLwbnTT
         JNvjvMeqP72I/HmEBcgGkd6mcEmwH8uxQ6rWOW1ktRIyVFRk24iditMcFr5QmqByb43M
         U+31GNol93CNopwUYXWlRWVzaIXyP3pvf6LbqToAUwoLzrGNcRAztry+bLKG347A5xU4
         uvlsyGPFPI4NP7n01Rse2p5aGrbvOKNCCc2/v/j4HnJHw+GQmkuhDBAIDuKGSnMo9WpR
         JHTH+gwOxb/9wP9DDtJN3O05Iulpzf3UFo0vHW1bUu0u7nCc5dUHPH/dyn312ymrwflg
         WSZg==
X-Gm-Message-State: AOAM533omJEmN0DD13bHkgqVNjpEQ37/amm5W7Ld0co37dwo9y6v37A9
        P2jMBsRnkXM7tkCxB57qXCA=
X-Google-Smtp-Source: ABdhPJzkjqc9ets0DSyy3uS4J8QgFPty0lmgdctexH3xsijP6wBd7K7ZXB8PaAqYmSe8K3mqTgFCsQ==
X-Received: by 2002:a1c:cc14:: with SMTP id h20mr19309612wmb.180.1613983511700;
        Mon, 22 Feb 2021 00:45:11 -0800 (PST)
Received: from [192.168.1.101] ([37.171.239.209])
        by smtp.gmail.com with ESMTPSA id t15sm25202663wmi.48.2021.02.22.00.45.10
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 22 Feb 2021 00:45:10 -0800 (PST)
Subject: Re: [PATCH] net/qrtr: restrict length in qrtr_tun_write_iter()
To:     Sabyrzhan Tasbolatov <snovitoll@gmail.com>
Cc:     davem@davemloft.net, kuba@kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org,
        syzbot+c2a7e5c5211605a90865@syzkaller.appspotmail.com
References: <3b27dac1-45b9-15ad-c25e-2f5f3050907e@gmail.com>
 <20210221123912.3185059-1-snovitoll@gmail.com>
From:   Eric Dumazet <eric.dumazet@gmail.com>
Message-ID: <573bd57c-5ef8-3d4c-1fe9-eaa0337e7bfd@gmail.com>
Date:   Mon, 22 Feb 2021 09:45:09 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.0
MIME-Version: 1.0
In-Reply-To: <20210221123912.3185059-1-snovitoll@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 2/21/21 1:39 PM, Sabyrzhan Tasbolatov wrote:
>> Do we really expect to accept huge lengths here ?
> 
> Sorry for late response but I couldnt find any reference to the max
> length of incoming data for qrtr TUN interface.
> 
>> qrtr_endpoint_post() will later attempt a netdev_alloc_skb() which will need
>> some extra space (for struct skb_shared_info)
> 
> Thanks, you're right, qrtr_endpoint_post() will alloc another slab buffer.
> We can check the length of skb allocation but we need to do following:
> 
> int qrtr_endpoint_post(.., const void *data, size_t len) 
> {
> 	..
> 	when QRTR_PROTO_VER_1:
> 		hdrlen = sizeof(*data);
> 	when QRTR_PROTO_VER_2:
> 		hdrlen = sizeof(*data) + data->optlen;
> 	
> 	len = (KMALLOC_MAX_SIZE - hdrlen) % data->size;
> 	skb = netdev_alloc_skb(NULL, len);
> 	..
> 	skb_put_data(skb, data + hdrlen, size);
> 
> 
> So it requires refactoring as in qrtr_tun_write_iter() we just allocate and
> pass it to qrtr_endpoint_post() and there
> we need to do len calculation as above *before* netdev_alloc_skb(NULL, len).
> 
> Perhaps there is a nicer solution though.
> 

A protocol requiring contiguous physical memory allocations of up to KMALLOC_MAX_SIZE
bytes would be really unreliable.

I suggest we simply limit the allocations to 64KB, unless qrtr maintainers shout,
or start implementing scatter gather.






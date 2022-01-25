Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7D43549B565
	for <lists+netdev@lfdr.de>; Tue, 25 Jan 2022 14:53:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1386618AbiAYNww (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Jan 2022 08:52:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57020 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1385439AbiAYNug (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Jan 2022 08:50:36 -0500
Received: from mail-lj1-x229.google.com (mail-lj1-x229.google.com [IPv6:2a00:1450:4864:20::229])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F1585C06173D;
        Tue, 25 Jan 2022 05:50:34 -0800 (PST)
Received: by mail-lj1-x229.google.com with SMTP id e17so3726114ljk.5;
        Tue, 25 Jan 2022 05:50:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=ZLnOYuyorYTwARzIwCYtX0Y+DVUCcs21qO0uQgIbKpg=;
        b=nKtJRYwHPJ3u+LD6RcTpyIaViq8Bz0Tj9KkubsjRTAjjJJlJ16FaKZJm2P6BZE7+8G
         oZ+peKp2Fm3zhcbUcBQYp3oOshMHyjjIB0S4FyWk973NDHiwAlXXrkV6j1skbEb3fCAV
         154+v4NL7waMORsJFXw/adSqEoj8SA3pVl+IPXT7BCvQCN3x3xbpp6ZBzl1KClVu16IR
         F1zTLLd+7RRxTOcGpViGuasvehc+o2o1/WdrfsruUSad5maxyVb9Caq1nrJzA7xkou1K
         nzJ606HJUFbBkAZgy7xbSnlOuA0kvpPC/xNaGJybJ9V1CAywSVN5xlRhFVHen2PzJIUU
         XVfw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=ZLnOYuyorYTwARzIwCYtX0Y+DVUCcs21qO0uQgIbKpg=;
        b=phQUas4a3i2zVnyhW3h5Et8m2Oejiw5BUO+K9EHVTB/SzrWVgD4iBK+EGUn5Cgx0H8
         z0ei/r38xpcid3dCcLDG1UqdJ/7sSkgS5BkkNWD97lpEu2p6UpIAUoPpjGzQMlL18LRm
         7xgiH4zTPvj6Y7O6CuswVGWluQxgUu/V4oL7V2NT0X3DnoOlmWYn+5EpYYEHQihYFcxw
         dET7xVkCxuqtPnhb0y2dITxEDa3iLPYJXdVemIqUt5wHBJ1fAX9hYgKw5vCBoN0M8Eoa
         ZyKVSRtz/KdMACETynM5qHsjAggYd2ATzzMeU6WUhvHoDRv/GowR6r1iB1sek8mePB2H
         K/gA==
X-Gm-Message-State: AOAM533Q0/1czQjiw8UCDB8PVLWFOsMM8hx5NjyRu6gIZN8ObG2tk8HR
        jn3L6dEcG1qZosCNOxJBWEo=
X-Google-Smtp-Source: ABdhPJx8g8xdesMNoGVTzuT3XagRj5LAaufkKUYbo6VUO/Xk/HZpzkHbh9B46nJmAsZXzEC0QizUKg==
X-Received: by 2002:a2e:9e02:: with SMTP id e2mr14661066ljk.502.1643118633404;
        Tue, 25 Jan 2022 05:50:33 -0800 (PST)
Received: from [192.168.8.103] (m91-129-103-86.cust.tele2.ee. [91.129.103.86])
        by smtp.gmail.com with ESMTPSA id h23sm1206582ljk.4.2022.01.25.05.50.31
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 25 Jan 2022 05:50:32 -0800 (PST)
Message-ID: <bad34ba9-eacf-f325-7ebc-6fdd43414945@gmail.com>
Date:   Tue, 25 Jan 2022 15:50:30 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.4.0
Subject: Re: [PATCH] net: ena: Do not waste napi skb cache
Content-Language: en-US
To:     Hyeonggon Yoo <42.hyeyoo@gmail.com>,
        Shay Agroskin <shayagr@amazon.com>
Cc:     netdev@vger.kernel.org, Arthur Kiyanovski <akiyano@amazon.com>,
        David Arinzon <darinzon@amazon.com>,
        Noam Dagan <ndagan@amazon.com>,
        Saeed Bishara <saeedb@amazon.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Wei Yongjun <weiyongjun1@huawei.com>,
        Lorenzo Bianconi <lorenzo@kernel.org>,
        linux-kernel@vger.kernel.org
References: <20220123115623.94843-1-42.hyeyoo@gmail.com>
 <f835cbb3-a028-1daf-c038-516dd47ce47c@gmail.com>
 <5cca8bdd-bed0-f26a-6c96-d18947d3a50b@gmail.com>
 <pj41zlmtjk7t9a.fsf@u570694869fb251.ant.amazon.com>
 <Ye/EQgqCBogZR87T@ip-172-31-19-208.ap-northeast-1.compute.internal>
From:   Julian Wiedmann <jwiedmann.dev@gmail.com>
In-Reply-To: <Ye/EQgqCBogZR87T@ip-172-31-19-208.ap-northeast-1.compute.internal>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 25.01.22 11:34, Hyeonggon Yoo wrote:
> On Mon, Jan 24, 2022 at 10:50:05PM +0200, Shay Agroskin wrote:
>>

[...]

>>
>> I agree that the netdev_alloc_skb_ip_align() can become napi_alloc_skb().
>> Hyeonggon Yoo, can you please apply this change as well to this patch?
>>
> 
> Okay. I'll update and test it again.
> 
> BTW, It seems netdev_alloc_skb_ip_align() is used to make some fields
> be aligned. It's okay to just ignore this?
> 

napi_alloc_skb() adds NET_IP_ALIGN internally, so you end up with the same alignment as before.


> Thanks,
> Hyeonggon.
> 
>> Thanks,
>> Shay
>>
>>
>>>>>  	else
>>>>> -		skb = build_skb(first_frag, ENA_PAGE_SIZE);
>>>>> +		skb = napi_build_skb(first_frag, ENA_PAGE_SIZE);
>>>>>  	if (unlikely(!skb)) {
>>>>>  		ena_increase_stat(&rx_ring->rx_stats.skb_alloc_fail,  1,
>>>>


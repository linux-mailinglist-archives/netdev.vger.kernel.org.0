Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E4FEC32FFE8
	for <lists+netdev@lfdr.de>; Sun,  7 Mar 2021 10:31:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230184AbhCGJbM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 7 Mar 2021 04:31:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50354 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229619AbhCGJbJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 7 Mar 2021 04:31:09 -0500
Received: from mail-pf1-x42d.google.com (mail-pf1-x42d.google.com [IPv6:2607:f8b0:4864:20::42d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 62059C06174A;
        Sun,  7 Mar 2021 01:31:09 -0800 (PST)
Received: by mail-pf1-x42d.google.com with SMTP id j12so5111160pfj.12;
        Sun, 07 Mar 2021 01:31:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-transfer-encoding:content-language;
        bh=qyR07YDqUgRUKmk3fTa/Vt5RDMJrIvpFOr8PG+miymA=;
        b=MfkgjOKnOVYLO3SuNni18rv4q5P5WwP9LauVxNPe0365fqeYG2qbTKJdCG1zWOFm96
         qykaMHjkggeb5xmSn67OMHMBmPZHtBChA+ljSAwPp8Vk8bjisZ8m4BCwKEs8mYLXqz/t
         He4L4SYLkJwgP8NBB01hKm+DXy9TcA1bWyFuh+LRNxdCszIf0wMddCu8hF+/N0yUmcrd
         9SwEel14qIO7MJozGfKVN1Bfv2nbKxaUykL5Ea0QM3lTdOvYCVkFFqgDGRJu0nH08q0H
         QSZb6ITpmrmKGe4f/8j0X6ue58DxKl8cRIrkQKvbvBZrXyRFAFljitEiUOGVyj01p+3L
         jtfw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=qyR07YDqUgRUKmk3fTa/Vt5RDMJrIvpFOr8PG+miymA=;
        b=EgSUq6yslcdiIZt/Sdfrfr6hF5mb9CMweZJYGGyJ0Md5fM9m89LNDIEJmCk+ph1EG6
         VAmZ6zsgKnHN5R9MCw6TNvq9RQQTXQngd95mYAJhy76D4lOUJ/h090Bq2gFSZicqo4ZK
         P0eFVUxu5bcFuepB1oTj1brdk1dj6o1xPzJQLES72dZRk2/OAY2wUOb5HWPY6DnwiYET
         8NFpM2/mR1prFSCRp2ZUKExZ592yRar7mNY7mI2xAIONuFnhrBSUlLrJOIUlZ0DZRQUh
         CHVWTes0hvCmSSZAvCZRBfVA+/3ghaMMMwM8kGs0bNU+K7z/ZD/uLH2QOwBsdw6vsllj
         rkPA==
X-Gm-Message-State: AOAM532aj4hpRtK4uRp33VOWx4EShGyYq7L3n/4M6+xghonv6GgyCjSX
        uGpRQ8P10yxpoEmVRjI5CxN5gvOujnefAi3t
X-Google-Smtp-Source: ABdhPJyD789MXxrFH1qFfdzEM4OXwC82uAqHFu8di0W3snf8KvjlhGvwm1lv77tVUwmmnx8gPFHZhg==
X-Received: by 2002:a62:e502:0:b029:1e4:d7c3:5c59 with SMTP id n2-20020a62e5020000b02901e4d7c35c59mr16529517pff.51.1615109468420;
        Sun, 07 Mar 2021 01:31:08 -0800 (PST)
Received: from [10.74.0.22] ([45.135.186.99])
        by smtp.gmail.com with ESMTPSA id 142sm7203548pfz.196.2021.03.07.01.31.04
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 07 Mar 2021 01:31:07 -0800 (PST)
Subject: Re: [PATCH] ath: ath6kl: fix error return code of
 ath6kl_htc_rx_bundle()
To:     Leon Romanovsky <leon@kernel.org>, davem@davemloft.net,
        kuba@kernel.org
Cc:     kvalo@codeaurora.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20210307090757.22617-1-baijiaju1990@gmail.com>
 <YESaSwoGRxGvrggv@unreal>
From:   Jia-Ju Bai <baijiaju1990@gmail.com>
Message-ID: <a55172ad-bf40-0110-8ef3-326001ecd13e@gmail.com>
Date:   Sun, 7 Mar 2021 17:31:01 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <YESaSwoGRxGvrggv@unreal>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Leon,

I am quite sorry for my incorrect patches...
My static analysis tool reports some possible bugs about error handling 
code, and thus I write some patches for the bugs that seem to be true in 
my opinion.
Because I am not familiar with many device drivers, some of my reported 
bugs can be false positives...


Best wishes,
Jia-Ju Bai

On 2021/3/7 17:18, Leon Romanovsky wrote:
> On Sun, Mar 07, 2021 at 01:07:57AM -0800, Jia-Ju Bai wrote:
>> When hif_scatter_req_get() returns NULL to scat_req, no error return
>> code of ath6kl_htc_rx_bundle() is assigned.
>> To fix this bug, status is assigned with -EINVAL in this case.
>>
>> Reported-by: TOTE Robot <oslab@tsinghua.edu.cn>
>> Signed-off-by: Jia-Ju Bai <baijiaju1990@gmail.com>
>> ---
>>   drivers/net/wireless/ath/ath6kl/htc_mbox.c | 4 +++-
>>   1 file changed, 3 insertions(+), 1 deletion(-)
>>
>> diff --git a/drivers/net/wireless/ath/ath6kl/htc_mbox.c b/drivers/net/wireless/ath/ath6kl/htc_mbox.c
>> index 998947ef63b6..3f8857d19a0c 100644
>> --- a/drivers/net/wireless/ath/ath6kl/htc_mbox.c
>> +++ b/drivers/net/wireless/ath/ath6kl/htc_mbox.c
>> @@ -1944,8 +1944,10 @@ static int ath6kl_htc_rx_bundle(struct htc_target *target,
>>
>>   	scat_req = hif_scatter_req_get(target->dev->ar);
>>
>> -	if (scat_req == NULL)
>> +	if (scat_req == NULL) {
>> +		status = -EINVAL;
> I'm not sure about it.
>
> David. Jakub,
> Please be warned that patches from this guy are not so great.
> I looked on 4 patches and 3 of them were wrong (2 in RDMA and 1 for mlx5)
> plus this patch most likely is incorrect too.
>

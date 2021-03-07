Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C74B9330020
	for <lists+netdev@lfdr.de>; Sun,  7 Mar 2021 11:37:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231426AbhCGKgn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 7 Mar 2021 05:36:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36396 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231325AbhCGKga (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 7 Mar 2021 05:36:30 -0500
Received: from mail-wr1-x42e.google.com (mail-wr1-x42e.google.com [IPv6:2a00:1450:4864:20::42e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 956FCC06174A;
        Sun,  7 Mar 2021 02:36:30 -0800 (PST)
Received: by mail-wr1-x42e.google.com with SMTP id f12so8186979wrx.8;
        Sun, 07 Mar 2021 02:36:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=QUAGgQ+GCSEMKdmjw8dHGrKRA1a4GuPIKYGKPGuNTkI=;
        b=NcLsOwyuZxWHoQPJrRmBfNOlGHj+UD4HB+xhzzUjurOMM6CDdbhVkYXxj2W8RoVvHo
         PDgjDbRcwVehlJZycAQY801wI1dpbti9gfuZxRFcyQaJffE4doD0AOFLiJYblxlb/Yf+
         W3nlPbDzafY99Ioo9lv6Qcsz2yTDQ60DHT9MrSCJq/xlcPxYOZPYn9YSE2jLjLnDKXBx
         GIjq5oi6IG54erMX42Z+TFORd+0gtG+iFEti8sWdG7UA0XmXADq9Js2NsOLcbiTtDyav
         C786jQHanihPoiwsUV3sN2i0FBGOpKgu6zK/oSPR20F1n68Gt0x4azPwc0AUKBYC389N
         VNNw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=QUAGgQ+GCSEMKdmjw8dHGrKRA1a4GuPIKYGKPGuNTkI=;
        b=Y2ZmGCzmgsphtihSXrqPFFkJ2NjYK3jmwwB97X5x8qy3D0YrNPqkMWlxTwswqks4a2
         I59igp+i7H7jKABJFh9Erbiudi1s5nNeXsZIj5Duh6mqySbbjbLBPZmmyrc3btBAn6DH
         /yVR6p30GF1EgsaMYUrLHmR1V58KcSYiZPM3jWUK0I9nWk0MwSVunDcwkc5OVrnqmLSH
         aOntqUCIofM0Ukyoiu6GWuv4r5yVpL4ReWs2SR7mfiEp9KLES5IhY3rgg1X3C3vYHnS2
         FPoKsSt2m5tnqq/25d0Hwq3fuaqEmRcllE/I+BASquR0cU2a2+jY3peq2XohsokHKKXe
         MYIg==
X-Gm-Message-State: AOAM532uT2QRw6rM93qt/gDK89e2RGP8tKKBulTHjVTAxfUXk0UZNWtz
        J0XNfCtc3zG1iUcdpsNd0Lp2gxGOry0mtA==
X-Google-Smtp-Source: ABdhPJzGMvdqpeuWDWa/seuVgiTG3Xn6d1iiAfETy4rAbCTVCKOwItLngRjiu17YCxDYXem4Zmercw==
X-Received: by 2002:a5d:4ac4:: with SMTP id y4mr17495668wrs.86.1615113389054;
        Sun, 07 Mar 2021 02:36:29 -0800 (PST)
Received: from ?IPv6:2003:ea:8f1f:bb00:98ed:522e:af2a:b86a? (p200300ea8f1fbb0098ed522eaf2ab86a.dip0.t-ipconnect.de. [2003:ea:8f1f:bb00:98ed:522e:af2a:b86a])
        by smtp.googlemail.com with ESMTPSA id d85sm13342172wmd.15.2021.03.07.02.36.28
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 07 Mar 2021 02:36:28 -0800 (PST)
Subject: Re: [PATCH] ath: ath6kl: fix error return code of
 ath6kl_htc_rx_bundle()
To:     Jia-Ju Bai <baijiaju1990@gmail.com>,
        Leon Romanovsky <leon@kernel.org>, davem@davemloft.net,
        kuba@kernel.org
Cc:     kvalo@codeaurora.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20210307090757.22617-1-baijiaju1990@gmail.com>
 <YESaSwoGRxGvrggv@unreal> <a55172ad-bf40-0110-8ef3-326001ecd13e@gmail.com>
From:   Heiner Kallweit <hkallweit1@gmail.com>
Message-ID: <8e28cbdd-55f0-0479-04ee-22f5266ce0ac@gmail.com>
Date:   Sun, 7 Mar 2021 11:36:19 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.0
MIME-Version: 1.0
In-Reply-To: <a55172ad-bf40-0110-8ef3-326001ecd13e@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 07.03.2021 10:31, Jia-Ju Bai wrote:
> Hi Leon,
> 
> I am quite sorry for my incorrect patches...
> My static analysis tool reports some possible bugs about error handling code, and thus I write some patches for the bugs that seem to be true in my opinion.
> Because I am not familiar with many device drivers, some of my reported bugs can be false positives...

Then, before posting a patch for a driver, get familiar with it to
an extent that you can identify false positives. Relying on others
to detect the false positives is not the best approach.

> 
> 
> Best wishes,
> Jia-Ju Bai
> 
> On 2021/3/7 17:18, Leon Romanovsky wrote:
>> On Sun, Mar 07, 2021 at 01:07:57AM -0800, Jia-Ju Bai wrote:
>>> When hif_scatter_req_get() returns NULL to scat_req, no error return
>>> code of ath6kl_htc_rx_bundle() is assigned.
>>> To fix this bug, status is assigned with -EINVAL in this case.
>>>
>>> Reported-by: TOTE Robot <oslab@tsinghua.edu.cn>
>>> Signed-off-by: Jia-Ju Bai <baijiaju1990@gmail.com>
>>> ---
>>>   drivers/net/wireless/ath/ath6kl/htc_mbox.c | 4 +++-
>>>   1 file changed, 3 insertions(+), 1 deletion(-)
>>>
>>> diff --git a/drivers/net/wireless/ath/ath6kl/htc_mbox.c b/drivers/net/wireless/ath/ath6kl/htc_mbox.c
>>> index 998947ef63b6..3f8857d19a0c 100644
>>> --- a/drivers/net/wireless/ath/ath6kl/htc_mbox.c
>>> +++ b/drivers/net/wireless/ath/ath6kl/htc_mbox.c
>>> @@ -1944,8 +1944,10 @@ static int ath6kl_htc_rx_bundle(struct htc_target *target,
>>>
>>>       scat_req = hif_scatter_req_get(target->dev->ar);
>>>
>>> -    if (scat_req == NULL)
>>> +    if (scat_req == NULL) {
>>> +        status = -EINVAL;
>> I'm not sure about it.
>>
>> David. Jakub,
>> Please be warned that patches from this guy are not so great.
>> I looked on 4 patches and 3 of them were wrong (2 in RDMA and 1 for mlx5)
>> plus this patch most likely is incorrect too.
>>


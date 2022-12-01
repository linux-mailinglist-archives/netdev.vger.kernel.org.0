Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 403CF63F701
	for <lists+netdev@lfdr.de>; Thu,  1 Dec 2022 19:00:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229807AbiLASA5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Dec 2022 13:00:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54350 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229999AbiLASA4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 1 Dec 2022 13:00:56 -0500
Received: from mail-il1-x12e.google.com (mail-il1-x12e.google.com [IPv6:2607:f8b0:4864:20::12e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 39F08B276A
        for <netdev@vger.kernel.org>; Thu,  1 Dec 2022 10:00:55 -0800 (PST)
Received: by mail-il1-x12e.google.com with SMTP id h17so1080721ila.6
        for <netdev@vger.kernel.org>; Thu, 01 Dec 2022 10:00:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:references:cc:to:from
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=mLmQ9FuLQV/3WYg6WIyM6UQ5+aTXTDiwF3md5aMgLKE=;
        b=warFrrLffutg4BA21c3UlAQ+DI9pvBMP2jZvjocySvHdk0YnKonKWoTMV1r5Fkgfqk
         t6fYtIgN4kzMEV7T/AAxi4rXxSY4U60Ym7uO81kbq/zV1jWwnrMBWKCzivHDFYrU54u+
         TEKvyJuZFXInC8FSQKOzsdCMiA4cEwZKPtzp7baKTowghYvbUYfHX4ZyTe3AQNcFhRPY
         RseGYVRgPIePpH2nPJPYhJ5OGVNNbx2Z6Z+AVBbhRMRXUZsEUTfXI9cIyao+1jknzPJO
         ufPH+Vd/AqVV4O1MmICq/ZflguQP3LirFPeiEDmWCyOccvGo21L1IvetyAaSYGGupot9
         Izfw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:references:cc:to:from
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=mLmQ9FuLQV/3WYg6WIyM6UQ5+aTXTDiwF3md5aMgLKE=;
        b=JJVGmyVp6krE+9U9nYUj0iQYh2E7Jv5LyycyWiWSgnzgyh2dWZeAgvDkxd0AEMooeU
         geVBsCDqD2IkaFT2Z0VygRTgWOv7aGjPB15e8EceUAtS2wf18uX4NQm9DvUONx/pCUbO
         ydNbTFNe34tnYBu/d/XvkRJLQjsiDDg+mTAPDOzxCR1Dkm1wZi7anE5gPL62tVaaEf7G
         d6LoaBx0kagrEwy009ux15NTGMTKTJKuh3c4a644AzPHESQ/p1YLp9SbL8nQZ1y0W0Rm
         Cp5uM1XsuGBYhhoBfhx7Cy8v7jiiwV1wYepDalubW2Te6gPctkV1tR/n6CwiRXynoDni
         4Qkw==
X-Gm-Message-State: ANoB5pkR6/GqwbWaOvfqwNnMUBPwOCwiZfORRj8H3ZBzTSVYaWa85u3N
        XcQ9bkoeQ1d3N1AEM+zCtJzz7Q==
X-Google-Smtp-Source: AA0mqf7pMLfmPCOnWsEzbt4qZ5dRqmAd5e/FC+k4b+Dpqd1z7c4CXwBLHthxHIR7+AhkTxHUfFwsPA==
X-Received: by 2002:a92:a30b:0:b0:302:555a:f761 with SMTP id a11-20020a92a30b000000b00302555af761mr21047770ili.323.1669917654401;
        Thu, 01 Dec 2022 10:00:54 -0800 (PST)
Received: from [192.168.1.94] ([207.135.234.126])
        by smtp.gmail.com with ESMTPSA id l66-20020a6b3e45000000b006dfbf3fe79dsm1831823ioa.32.2022.12.01.10.00.53
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 01 Dec 2022 10:00:53 -0800 (PST)
Message-ID: <8d195905-a93f-d342-abb0-dd0e0f5a5764@kernel.dk>
Date:   Thu, 1 Dec 2022 11:00:52 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.0
Subject: Re: [PATCH 6/6] eventpoll: add support for min-wait
Content-Language: en-US
From:   Jens Axboe <axboe@kernel.dk>
To:     Soheil Hassas Yeganeh <soheil@google.com>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Cc:     Willem de Bruijn <willemb@google.com>,
        Shakeel Butt <shakeelb@google.com>
References: <20221030220203.31210-1-axboe@kernel.dk>
 <20221030220203.31210-7-axboe@kernel.dk> <Y2rUsi5yrhDZYpf/@google.com>
 <4764dcbf-c735-bbe2-b60e-b64c789ffbe6@kernel.dk>
In-Reply-To: <4764dcbf-c735-bbe2-b60e-b64c789ffbe6@kernel.dk>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

>>> @@ -1845,6 +1891,18 @@ static int ep_poll(struct eventpoll *ep, struct epoll_event __user *events,
>>>  		ewq.timed_out = true;
>>>  	}
>>>  
>>> +	/*
>>> +	 * If min_wait is set for this epoll instance, note the min_wait
>>> +	 * time. Ensure the lowest bit is set in ewq.min_wait_ts, that's
>>> +	 * the state bit for whether or not min_wait is enabled.
>>> +	 */
>>> +	if (ep->min_wait_ts) {
>>
>> Can we limit this block to "ewq.timed_out && ep->min_wait_ts"?
>> AFAICT, the code we run here is completely wasted if timeout is 0.
> 
> Yep certainly, I can gate it on both of those conditions.
Looking at this for a respin, I think it should be gated on
!ewq.timed_out? timed_out == true is the path that it's wasted on
anyway.

-- 
Jens Axboe


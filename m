Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9399B3BEA37
	for <lists+netdev@lfdr.de>; Wed,  7 Jul 2021 17:01:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232214AbhGGPEc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Jul 2021 11:04:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47844 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232183AbhGGPEa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Jul 2021 11:04:30 -0400
Received: from mail-ot1-x334.google.com (mail-ot1-x334.google.com [IPv6:2607:f8b0:4864:20::334])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0D90BC06175F
        for <netdev@vger.kernel.org>; Wed,  7 Jul 2021 08:01:50 -0700 (PDT)
Received: by mail-ot1-x334.google.com with SMTP id i12-20020a05683033ecb02903346fa0f74dso2470841otu.10
        for <netdev@vger.kernel.org>; Wed, 07 Jul 2021 08:01:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=6t9MlTexAyqffAg1sXAEFN6t/hS/f3lKajvWWPkbehQ=;
        b=Ez1SiPN5bqU4qzH6upAlgggEoo8Hr9uxj7FQGe/wNrdpxKUq8JpDMyiDsFaPSLktpg
         VAquJ5jcFIarB9IRYrdiWXMqTUPe90Z1BEa+mgKVkdW1pi2Q0S4LRruKdd5qfdOfI9GP
         nkzGAMOJl29PQBuLua3OzmUDHKvqvZrnwa3jQ1iGaM/FH8GYJ0b4eSzZaJT4z/A02tPZ
         AC9jBSBnplNjZ7Ml2MA435x95eyYkpIjMxuR9iG/q+AaG9t7Da3AMPodw2pRCOElEdDt
         GYkqnLkwK2560F6vvSUP8vBOPZbE2x2e9E3T3L1GyPqIoBJ5IIoOf/g0e1SFjwtvb6k5
         NV1A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=6t9MlTexAyqffAg1sXAEFN6t/hS/f3lKajvWWPkbehQ=;
        b=W6opwB/GPFSXqPmmY1a2NhFTbtmuNObSjrbVODzAP98cV44AEw5MwPd7AiaMzgM5OG
         GQfRub1YLpkOw7gFNxfv3GapwsTfevOMLgC6j+XcI2/V/Zf1S8YOeVZpLdutS9pmdZye
         k8mE4xhkBTi+6leangIedjgVMQYlXr+33Q/bMxEXWQqUN9hWFImqYJllFo+6N0BNlRYo
         yN8kEH2s1bFrZKJBE/JwbaX03XjfIdwL/QBpLskTkcycE9hFp0XRy7JzN3b6BAgrM4I9
         ht0QZkyEk+g2RIPuJTxCzyAPa6WLqrqvCwitbQUhFvKfZ05P0mn88RXN4IDElQEDt/Fn
         dRmQ==
X-Gm-Message-State: AOAM5334fHMF6xpRs9zjEX3oFBhVfqc7/HoCaOYH00+qEjT2q5SU0y3H
        PQ2e5DLRhIXomJG9J5ccukndWQ==
X-Google-Smtp-Source: ABdhPJzjgs126XXFA6BcUwdBhC1gy+5Aw7zbW0VPPx4XILs/RxgDSqtfj5vlx1MaRjNUcz32PPHM9A==
X-Received: by 2002:a9d:6a93:: with SMTP id l19mr19292821otq.223.1625670108830;
        Wed, 07 Jul 2021 08:01:48 -0700 (PDT)
Received: from [192.168.1.170] ([207.135.234.126])
        by smtp.gmail.com with ESMTPSA id v12sm191478otq.13.2021.07.07.08.01.48
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 07 Jul 2021 08:01:48 -0700 (PDT)
Subject: Re: [RFC 0/4] open/accept directly into io_uring fixed file table
To:     Stefan Metzmacher <metze@samba.org>,
        Pavel Begunkov <asml.silence@gmail.com>,
        io-uring@vger.kernel.org
Cc:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, Josh Triplett <josh@joshtriplett.org>
References: <cover.1625657451.git.asml.silence@gmail.com>
 <48bd91bc-ba1a-1e69-03a1-3d6f913f96c3@kernel.dk>
 <4accdfa5-36fc-7de8-f4b2-7609b6f9d8ee@samba.org>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <6db18003-bb72-daf7-f5e6-20f9e128ada3@kernel.dk>
Date:   Wed, 7 Jul 2021 09:01:47 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <4accdfa5-36fc-7de8-f4b2-7609b6f9d8ee@samba.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 7/7/21 7:59 AM, Stefan Metzmacher wrote:
> Am 07.07.21 um 15:07 schrieb Jens Axboe:
>> On 7/7/21 5:39 AM, Pavel Begunkov wrote:
>>> Implement an old idea allowing open/accept io_uring requests to register
>>> a newly created file as a io_uring's fixed file instead of placing it
>>> into a task's file table. The switching is encoded in io_uring's SQEs
>>> by setting sqe->buf_index/file_index, so restricted to 2^16-1. Don't
>>> think we need more, but may be a good idea to scrap u32 somewhere
>>> instead.
>>>
>>> From the net side only needs a function doing __sys_accept4_file()
>>> but not installing fd, see 2/4.
>>>
>>> Only RFC for now, the new functionality is tested only for open yet.
>>> I hope we can remember the author of the idea to add attribution.
>>
>> Pretty sure the original suggester of this as Josh, CC'ed.
> 
> I also requested it for open :-)

Indeed! I honestly forget the details, as some of it is implementation
detail. I think Josh was the first to suggest a private fd table could
be used, but that's mostly implementation detail as the point was to be
able to know which fd would be assigned.

But I think we're all in agreement here, it's a nifty feature :-)

-- 
Jens Axboe


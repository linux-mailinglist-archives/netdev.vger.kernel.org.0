Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AB775260526
	for <lists+netdev@lfdr.de>; Mon,  7 Sep 2020 21:33:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729003AbgIGTc7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Sep 2020 15:32:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33646 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728879AbgIGTc7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Sep 2020 15:32:59 -0400
Received: from mail-pj1-x1044.google.com (mail-pj1-x1044.google.com [IPv6:2607:f8b0:4864:20::1044])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C91C9C061573
        for <netdev@vger.kernel.org>; Mon,  7 Sep 2020 12:32:58 -0700 (PDT)
Received: by mail-pj1-x1044.google.com with SMTP id s2so6846527pjr.4
        for <netdev@vger.kernel.org>; Mon, 07 Sep 2020 12:32:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=3XNNodxw2Bqna8ES9FUGiCTDfgFc2NQi+BtH/2J6RyE=;
        b=fL1fnON3sZcvwx4ljerjvZBgLBt65JuWoWLKgao//QyBLVhtLfrgxbS9lXnwe4qEVy
         n7u23IpbLAD31AE6+NIohQU/z+DX25eQ1Yf6+zSEQcUHQegswCiZtIYdF6DD8tugMK80
         emgELklmlD7Aj3Gv65lhihlLfisaZ8RrQB+aVPtK6bStPhDWawRseqZi4T5ojUjn6xWN
         IOAYcntbLtASZdJjBcMDXF3uAtVrtzXLuj2gUW6tw8zS4DO2rfKM2Cq9dqkA6Q5IhDfW
         Q/p0+ALPWyUxqeBuUpOWTsRCTEcrtfY9FF6jMx4w/879+hL9AVdi2CbWAps1anIf7fJC
         YIiA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=3XNNodxw2Bqna8ES9FUGiCTDfgFc2NQi+BtH/2J6RyE=;
        b=ZvK0r7dk4++AXMq/CJEQf9TlaLYVWs/9n+rtQoYMDwwt8D6Kq2lhvA6Z2z22tvmJXN
         +fydiaQtdia1FvP9RSg+InV5XsQFddNu1yzTFMLPLM5EiAA1p9wG7szhB5xgFq/0WwsJ
         cQaXZfWL29/vEFODm9LvbQmEG32pfjb7P5EFUZ8Djnqy5B8zW9pHjv/lAVOkxMKyh9Di
         h6wXSCf0sAQcqJAObwh8RdoGSC9klhjtlUVIi+hTz4J1OnCK44bqB9FxvS14eDaZLQwf
         bY/IwiWg94th90rcqA2pwDmzkL2+QfqET+ZX05AuzShMfvKf7slCTlx64aQEYY9vGa6W
         VntA==
X-Gm-Message-State: AOAM533/FhHg+lIauCCP6gcJOY4ag6wrbrng8KYe5+x+xRFK91TfOKwm
        tl+ssLh8GPHblt3mcMx6K0l+WA==
X-Google-Smtp-Source: ABdhPJwVQQuoGVlwnMyc0gb7qcV3e4skoDpoknRrTnGaKIi4378Qq4n/nZADnD7LXVmQEvW0TcbNPA==
X-Received: by 2002:a17:90a:67cb:: with SMTP id g11mr710684pjm.56.1599507178083;
        Mon, 07 Sep 2020 12:32:58 -0700 (PDT)
Received: from [192.168.1.182] ([66.219.217.173])
        by smtp.gmail.com with ESMTPSA id s8sm16743519pfm.180.2020.09.07.12.32.56
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 07 Sep 2020 12:32:57 -0700 (PDT)
Subject: Re: [PATCH for-next] net: provide __sys_shutdown_sock() that takes a
 socket
To:     Christoph Hellwig <hch@infradead.org>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Networking <netdev@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>
References: <d3973f5b-2d86-665d-a5f3-95d017f9c79f@kernel.dk>
 <20200907054836.GA8956@infradead.org>
 <378cfa5a-eb06-d04c-bbbc-07b377f60c11@kernel.dk>
 <20200907095813.4cdacb5c@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <20200907170039.GA13982@infradead.org>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <0b165669-c08e-3b12-6b78-197e782e5c00@kernel.dk>
Date:   Mon, 7 Sep 2020 13:32:56 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20200907170039.GA13982@infradead.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 9/7/20 11:00 AM, Christoph Hellwig wrote:
> On Mon, Sep 07, 2020 at 09:58:13AM -0700, Jakub Kicinski wrote:
>> On Mon, 7 Sep 2020 10:45:00 -0600 Jens Axboe wrote:
>>> On 9/6/20 11:48 PM, Christoph Hellwig wrote:
>>>> On Sat, Sep 05, 2020 at 04:05:48PM -0600, Jens Axboe wrote:  
>>>>> There's a trivial io_uring patch that depends on this one. If this one
>>>>> is acceptable to you, I'd like to queue it up in the io_uring branch for
>>>>> 5.10.  
>>>>
>>>> Can you give it a better name?  These __ names re just horrible.
>>>> sock_shutdown_sock?  
>>>
>>> Sure, I don't really care, just following what is mostly done already. And
>>> it is meant to be internal in the sense that it's not exported to modules.
>>>
>>> I'll let the net guys pass the final judgement on that, I'm obviously fine
>>> with anything in terms of naming :-)
>>
>> So am I :) But if Christoph prefers sock_shutdown_sock() let's use that.
> 
> Let's go with the original naming.  I might eventually do a big
> naming sweep in socket.c after cleaning up more of the compat mess.

Agree, saves me the hassle... FWIW, networking does have an even broader
space of func to __func to ____func and in some cases not "following" the
usual calling order of them.

-- 
Jens Axboe


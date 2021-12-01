Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7117F4656D3
	for <lists+netdev@lfdr.de>; Wed,  1 Dec 2021 21:00:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242466AbhLAUD2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Dec 2021 15:03:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38904 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230197AbhLAUDZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Dec 2021 15:03:25 -0500
Received: from mail-wr1-x435.google.com (mail-wr1-x435.google.com [IPv6:2a00:1450:4864:20::435])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A708EC061574;
        Wed,  1 Dec 2021 12:00:03 -0800 (PST)
Received: by mail-wr1-x435.google.com with SMTP id t9so37825102wrx.7;
        Wed, 01 Dec 2021 12:00:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=Vt+OcMY2R/jF1z+M9gOwwL9VOFGJf09UHYeezsdqi70=;
        b=gn8U7lCPTHHd1UixZQINYzwt6etsT47Gn4SrC+8juSJ6OoI07j67cotK1qYYrmUewX
         LipC8ulYkDfYPhQuEEHzxWVXPoEf3XbEHB4esp7hHydnFGguI8MDhEoX3siBNAvQUzcF
         kVpVbStYwvgN6ft+l22tPnvia9lDPU0Q6qeiIN8l3GNZe3gEd2hDCp63gWrEWSH48tuq
         FmgCVmqbwWNNBEfKgYn1igMyqFuY4xAbp56UBv/agjvO20L3DJ2Z9woj/JO/DzmPgpmh
         VpWf30agsfQysuvzbruLAutlkmvCG8ehaWuyXIsuOepvqCyXMv6ZapIaQqMz6dQAoSmP
         Ar/Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=Vt+OcMY2R/jF1z+M9gOwwL9VOFGJf09UHYeezsdqi70=;
        b=dPNeNp/27vWayt1dn4wbnOn97m/RIVZHhS4VEvANZezcbrdF+WFHau3CidfRCTk2Qa
         Xox4ynMHJSnt0gEYqvZdsLdZgP+fLEyGAAEe7LH5qSOyt3Jl/HrlA0JCLmIoJN6XWus2
         3BKZ8vEvJGgMm4tXVThjr2f/ooMQS66XuWZ9HVGh/4S9BLfyJXyE/vwaQScD/x7rO63Y
         +IP2rHVinoMtsVYxGt6hiPSK/9mBAGeieXz6IkEGpWE90zfNIRdoD7Y9CS1n1QRC/KGZ
         5sZjCckp/SxHPQ0xP7pDI6zjklyBXO7rIBwegkxTy3w3UdiVEVHbTZnVoqbEfQr6RkwR
         GSKg==
X-Gm-Message-State: AOAM5335td9RyuzBG3zrZYBboXBYn+ImO2BVpNir0/ofqoFaTwFEboFn
        XnjmgQMOiEUS09Z/FWuyEsY=
X-Google-Smtp-Source: ABdhPJy1l9L3ZH8uahJZMf/734rIewzeh/+l47lBDFm6L8ZIDbZDeD+qZQcXMLnTp5gzDWWFASQMRQ==
X-Received: by 2002:a5d:40cf:: with SMTP id b15mr9366547wrq.161.1638388802346;
        Wed, 01 Dec 2021 12:00:02 -0800 (PST)
Received: from [192.168.8.198] ([185.69.144.129])
        by smtp.gmail.com with ESMTPSA id b6sm233654wmq.45.2021.12.01.12.00.01
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 01 Dec 2021 12:00:01 -0800 (PST)
Message-ID: <1281a755-bef4-d2c8-4416-e4b5734118af@gmail.com>
Date:   Wed, 1 Dec 2021 19:59:58 +0000
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.3.2
Subject: Re: [RFC 00/12] io_uring zerocopy send
Content-Language: en-US
To:     David Ahern <dsahern@gmail.com>, io-uring@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     Jakub Kicinski <kuba@kernel.org>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Willem de Bruijn <willemb@google.com>,
        Eric Dumazet <edumazet@google.com>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>, Jens Axboe <axboe@kernel.dk>
References: <cover.1638282789.git.asml.silence@gmail.com>
 <4c0170fa-5b6f-ff76-0eff-a83ffec9864d@gmail.com>
 <2c8bf94e-1265-2f3c-98ae-dfc73598f8f2@gmail.com>
From:   Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <2c8bf94e-1265-2f3c-98ae-dfc73598f8f2@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 12/1/21 17:49, David Ahern wrote:
> On 12/1/21 7:31 AM, Pavel Begunkov wrote:
>>
>> Also, as was asked, attaching a standalone .c version of the
>> benchmark. Requires any relatively up-to-date liburing installed.
>>
> attached command differs from the version mentioned in the cover letter:

I guess you mean the new options mentioned in the message that
were added to that standalone script. They look useful, will
update the repo with a similar change later.


> https://github.com/isilence/liburing.git zc_v1
> 
> copying this version into that branch, removing the duplicate
> definitions and it works.
> 

-- 
Pavel Begunkov

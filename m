Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DC37A24D84
	for <lists+netdev@lfdr.de>; Tue, 21 May 2019 13:04:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727545AbfEULEB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 May 2019 07:04:01 -0400
Received: from mail-io1-f65.google.com ([209.85.166.65]:43847 "EHLO
        mail-io1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726525AbfEULEA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 May 2019 07:04:00 -0400
Received: by mail-io1-f65.google.com with SMTP id v7so13523579iob.10
        for <netdev@vger.kernel.org>; Tue, 21 May 2019 04:04:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=tVZ1tFnofzDOshXJ55p2YIxYyc5VRLW0cEuiG1ZNDek=;
        b=ihR4sLB+Kcp5BjrhDZHbUHYi2I33+G3zsEL7+TLDz8Y7qWAJ6TdjzbQk2F+OSvOM1A
         GLIa2qJAZhBQZ9VZwMjjj3E45vPjlkcUCpN6i/oYE7jp19uqCloRgvG1a6iAmErAWRgE
         Qebj/ChBVrQbBUZg0ohqVfL9DyqylRQYV9NQNal9pXz9TXgpd8sF8qjgc21GP7N6zHeG
         FYb1QS5bhZgssSibeUx/tIQkitHUx5vKhoE2slQG2BN9Wmt2paYn5C4O2aKpZelG1qwW
         AwPwcL8iGMce28BZ/P2CtfAQNd9d3mCbLhtcxCDemp2dZnA6XZEwzQ1NEAMpidVJjVuo
         6mtA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=tVZ1tFnofzDOshXJ55p2YIxYyc5VRLW0cEuiG1ZNDek=;
        b=K/6J3dEBZLXbU6wErEquj0GGj5Sf0DTglRuX4dwoUegZ8sXXjBbo23AnkPNZg6RTQD
         aa3TNzRi258DA6ghGXiC+aeT/OXQ/3A2jM1lhxgMsSj88e/EGoXjhVqDvfZeCWFdqFJ8
         nHeX5Nqjfo2GjcD4ZrKNXVtmFNol2/7Gx7b8WrV1l3EbAmro4pGDISg0pV+Akyxc7D/H
         H4gtLYqQgnhbObHMUq+wHArZPkHisNWhQTVLJM9zNGocGWXCokO1aFkQXNlMVcWj9/p1
         FUW3hFBkkJAUXz1MSb9UmvnkG8pn+t3BQtwYiCM27YX/F7bDybKOOE5hu/yK0kF+z12d
         VT0w==
X-Gm-Message-State: APjAAAX8MNylSVzXBGu6G6n6it/SRkSWmRPctlbtvs7NMn8hbLkaic48
        ZncdBXyV/4c2D64B1FYnWaJ7wg==
X-Google-Smtp-Source: APXvYqzdS1QKhqlxQQboe9Y8ZH8ImzRkyRKdPGltO8YHoy6eE3kbPG+Qdn9Y/EsptD5mGgIiV7tFqw==
X-Received: by 2002:a6b:da11:: with SMTP id x17mr1436692iob.78.1558436639911;
        Tue, 21 May 2019 04:03:59 -0700 (PDT)
Received: from [172.22.22.26] (c-71-195-29-92.hsd1.mn.comcast.net. [71.195.29.92])
        by smtp.googlemail.com with ESMTPSA id q24sm6851957ioh.31.2019.05.21.04.03.58
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 21 May 2019 04:03:59 -0700 (PDT)
Subject: Re: [PATCH 1/8] net: qualcomm: rmnet: fix struct rmnet_map_header
To:     Bjorn Andersson <bjorn.andersson@linaro.org>
Cc:     Subash Abhinov Kasiviswanathan <subashab@codeaurora.org>,
        arnd@arndb.de, david.brown@linaro.org, agross@kernel.org,
        davem@davemloft.net, ilias.apalodimas@linaro.org,
        cpratapa@codeaurora.org, syadagir@codeaurora.org,
        evgreen@chromium.org, benchan@google.com, ejcaruso@google.com,
        netdev@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
References: <20190520135354.18628-1-elder@linaro.org>
 <20190520135354.18628-2-elder@linaro.org>
 <b0edef36555877350cfbab2248f8baac@codeaurora.org>
 <81fd1e01-b8e3-f86a-fcc9-2bcbc51bd679@linaro.org>
 <d90f8ccdc1f76f9166f269eb71a14f7f@codeaurora.org>
 <cd839826-639d-2419-0941-333055e26e37@linaro.org>
 <20190521030712.GY2085@tuxbook-pro>
From:   Alex Elder <elder@linaro.org>
Message-ID: <25b1d768-d492-08a7-b1ab-d3d022b01bc9@linaro.org>
Date:   Tue, 21 May 2019 06:03:58 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <20190521030712.GY2085@tuxbook-pro>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 5/20/19 10:07 PM, Bjorn Andersson wrote:
> On Mon 20 May 19:30 PDT 2019, Alex Elder wrote:
> 
>> On 5/20/19 8:32 PM, Subash Abhinov Kasiviswanathan wrote:
>>>>
>>>> If you are telling me that the command/data flag resides at bit
>>>> 7 of the first byte, I will update the field masks in a later
>>>> patch in this series to reflect that.
>>>>
>>>
>>> Higher order bit is Command / Data.
>>
>> So what this means is that to get the command/data bit we use:
>>
>> 	first_byte & 0x80
>>
>> If that is correct I will remove this patch from the series and
>> will update the subsequent patches so bit 7 is the command bit,
>> bit 6 is reserved, and bits 0-5 are the pad length.
>>
>> I will post a v2 of the series with these changes, and will
>> incorporate Bjorn's "Reviewed-by".
>>
> 
> But didn't you say that your testing show that the current bit order is
> wrong?

I did say that, but it seems I may have been misinterpreting
what the documentation said, namely that "bit 0" in the network
data stream is actually the high-order bit in the first byte.

I did definitely see that bit 7 (0x80) in the first byte was the
one selected by the "cd_bit" C bit-field originally, and I believed
that was wrong.

The other thing I can say is that I never see that bit set in my
use of the rmnet driver for IPA.  On top of that, the pad_len
value is 0.  Given that, either bit order works, because the
whole first byte is 0 either way.  So it turns out the testing
I am able to do is not adequate to verify the change.

I am hoping that Subash has an environment in which QMAP
commands (with the appropriate bit set) are actually used.

I'm going to wait a bit for him to confirm that, but at this
time my plan is to do as I said above--remove this patch and
adjust the ones that follow accordingly.

					-Alex

> I still like the cleanup, if nothing else just to clarify and clearly
> document the actual content of this header.
> 
> Regards,
> Bjorn
> 


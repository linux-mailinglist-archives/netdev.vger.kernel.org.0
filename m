Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1719C383D8D
	for <lists+netdev@lfdr.de>; Mon, 17 May 2021 21:35:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234727AbhEQThG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 May 2021 15:37:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53490 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234701AbhEQThF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 May 2021 15:37:05 -0400
Received: from mail-lj1-x229.google.com (mail-lj1-x229.google.com [IPv6:2a00:1450:4864:20::229])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 23CF9C061573;
        Mon, 17 May 2021 12:35:48 -0700 (PDT)
Received: by mail-lj1-x229.google.com with SMTP id y9so8660185ljn.6;
        Mon, 17 May 2021 12:35:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=YoJFd8EjmPKe3+5qZXDSvXf5TOxjV3ZVJo/hnHMI5XQ=;
        b=PCm6m7cF/j82uplTUTAoaY6o2csd11PeOCJ+m6LLxz8riIg/nBwMFHxcoBErPkXBzT
         kUx5lcpiqjbanEOcSndFDzQW7J48F2NosANLr9zhqmYOvgtHFTJQ4rIcPtJnMoS3y9MQ
         FUCfRowvckgR13pykP7Wum4uGpWMJxh1+WV5Z4qe5L/tyyqrhzznDdAaiF28nzQBisnK
         tyh/WKzKKFEHOlwGHPDDA2Ih/il3oeR5snjvH33OnCSwxtXdbPLXoM/rn9t0EocczW07
         GIUV5fdUix98eTU2r4waXBc7Pu67dr96OmAsQYwIdXQzAk5il1QP4E7VPL0+QjjkTuPA
         bO6Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=YoJFd8EjmPKe3+5qZXDSvXf5TOxjV3ZVJo/hnHMI5XQ=;
        b=LwDALYbnDiI6sYPELFg38m5r2Q2YD8pLnOa5+ZUZWPfCgH6SR1ofT7ayhB2YyoQ1W2
         Da8m14qNxbiCMpYSDdvHWa6UA2FxbFWOwbWTJVc6mX+vvtCTYOvHooa7MDR7PHWtBhTd
         9cwgarYHGpkQz2R2RWx6fk1nsO4fBhP2U5p7hI/oolbBiP0rHgD+zriQiVDQXZMh+S+h
         FC9Ur+KVRYf2ywd8CYqAug4gSqYLfzm4Z7/9/IVOkFis//vG0xS7HIxkBQvHT1qA8cT9
         MwZaQHk15M3MJfAT/U1Tp8wUiyMGEfpPA9W6evvR2q8hxbz/6W96E6PyR7Amda1tnedD
         B5Sg==
X-Gm-Message-State: AOAM531POxVJjzSkG21sckJnOCeIMd4Hpsv3CFj2oUmv08dzFyF2YAUp
        KZ6k3ao6cAGBz1H33iYlxiw=
X-Google-Smtp-Source: ABdhPJw0nSrWFufd+f0aGFvEIQXlD78bbhp7uXW7nTJWst57n7BOYzVVXDwL4b+iJOJJnBAkXKU2aQ==
X-Received: by 2002:a2e:8e62:: with SMTP id t2mr813432ljk.20.1621280146634;
        Mon, 17 May 2021 12:35:46 -0700 (PDT)
Received: from [192.168.1.102] ([178.176.75.125])
        by smtp.gmail.com with ESMTPSA id c9sm218039ljr.104.2021.05.17.12.35.45
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 17 May 2021 12:35:46 -0700 (PDT)
Subject: Re: [PATCH] net: renesas: ravb: Fix a stuck issue when a lot of
 frames are received
To:     Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-renesas-soc@vger.kernel.org" 
        <linux-renesas-soc@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>
References: <20210421045246.215779-1-yoshihiro.shimoda.uh@renesas.com>
 <68291557-0af5-de1e-4f4f-b104bb65c6b3@gmail.com>
 <04c93015-5fe2-8471-3da5-ee85585d9e6c@gmail.com>
 <TY2PR01MB369211466F9F6DB5EDC41183D8549@TY2PR01MB3692.jpnprd01.prod.outlook.com>
From:   Sergei Shtylyov <sergei.shtylyov@gmail.com>
Message-ID: <0ce3a5e2-8e42-3648-83c3-fea7b1147b5a@gmail.com>
Date:   Mon, 17 May 2021 22:35:44 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <TY2PR01MB369211466F9F6DB5EDC41183D8549@TY2PR01MB3692.jpnprd01.prod.outlook.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello!

On 5/10/21 1:29 PM, Yoshihiro Shimoda wrote:

>>>     Posting a review of the already commited (over my head) patch. It would have
>>> been appropriate if the patch looked OK but it's not. :-/
>>>
>>>> When a lot of frames were received in the short term, the driver
>>>> caused a stuck of receiving until a new frame was received. For example,
>>>> the following command from other device could cause this issue.
>>>>
>>>>      $ sudo ping -f -l 1000 -c 1000 <this driver's ipaddress>
>>>
>>>     -l is essential here, right?
> 
> Yes.
> 
>>>     Have you tried testing sh_eth sriver like that, BTW?
>>
>>     It's driver! :-)
> 
> I have not tried testing sh_eth driver yet. I'll test it after I got an actual board.

   Now you've got it, let's not rush forth with the fix this time.

>>>> The previous code always cleared the interrupt flag of RX but checks
>>>> the interrupt flags in ravb_poll(). So, ravb_poll() could not call
>>>> ravb_rx() in the next time until a new RX frame was received if
>>>> ravb_rx() returned true. To fix the issue, always calls ravb_rx()
>>>> regardless the interrupt flags condition.
>>>
>>>     That bacially defeats the purpose of IIUC...
>>                                            ^ NAPI,
>>
>>     I was sure I typed NAPI here, yet it got lost in the edits. :-)
> 
> I could not understand "that" (calling ravb_rx() regardless the interrupt
> flags condition) defeats the purpose of NAPI. According to an article on
> the Linux Foundation wiki [1], one of the purpose of NAPI is "Interrupt mitigation".

   Thank you for the pointer, BTW! Would have helped me with enabling NAPI in sh_eth
(and ravb) drivers...

> In poll(), the interrupts are already disabled, and ravb_rx() will check the
> descriptor's status. So, this patch keeps the "Interrupt mitigation" IIUC.

   I think we'll still have the short race window, described in section 5.1
of this doc. So perhaps what we should do is changing the order of the code in
the poll() method, not eliminating the loops totally. Thoughts?
 
> [1]
> https://wiki.linuxfoundation.org/networking/napi
> 
> Best regards,
> Yoshihiro Shimoda

MBR, Sergei

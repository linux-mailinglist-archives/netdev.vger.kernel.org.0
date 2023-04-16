Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 539786E3B9E
	for <lists+netdev@lfdr.de>; Sun, 16 Apr 2023 21:46:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229791AbjDPTq5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 16 Apr 2023 15:46:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33300 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229484AbjDPTqz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 16 Apr 2023 15:46:55 -0400
X-Greylist: delayed 25830 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Sun, 16 Apr 2023 12:46:51 PDT
Received: from mo4-p01-ob.smtp.rzone.de (mo4-p01-ob.smtp.rzone.de [85.215.255.51])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A78C92694;
        Sun, 16 Apr 2023 12:46:50 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1681674407; cv=none;
    d=strato.com; s=strato-dkim-0002;
    b=AgIVPUB345RxFKnkh07CQKy1ZbKF8aVI3EpXGvrSJ0eX8lErWtDbsDqF2QB77OqzuF
    4GbFhWmGDA3ZGNPmSQytT39+7U/wL7b00FQtjaaRjwbbKZjUz3W4SjUtzrgPmF5CqmSR
    a0CJXYdrGs7/wtFWYehvlHef/DyE0lkUskAJBFMMADVp5DvHxcIZRi/m2tcQQhcmGxeR
    D6qzIGWnFMxkwYgJIxGZC46sVPGBevjrKS/hhj149ySat/7sj+St0/PRR/fUW2UJ9m5L
    VX3YZ4i3cxaUlQnHFb4eVYjun2G0fpBZk46RjFols0hETr2/jzitD4JO38vGZMtmhVdr
    xGjw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; t=1681674407;
    s=strato-dkim-0002; d=strato.com;
    h=In-Reply-To:From:References:Cc:To:Subject:Date:Message-ID:Cc:Date:
    From:Subject:Sender;
    bh=s7e5pLZEiw+VWzLdZyOifqhlqNcQHDzzu/jx3K9/G7A=;
    b=YsiMkGUwdyrKRaOuTCJ2T5uX3H5oGVFfgu9Bn78bKdHwbvFeyCXbphv4bVF3kWX+60
    UdXUnXzRx1s6NCWRODFMl7jr+9O5CTm6beCfnxPdthcZLT66aenUeXDbKhoI8WXP7RTN
    gHs/BYJNIq11hlLLzsERwCrmkA42+hlJ7Ql8ZqOFjwyffKrJ9Q4WQ4GMeufaapsA9+tE
    8j/r/TzqFYSGAp+jUFoX/rnaO44zeG5tWLp1xsMG5LKVqtmsKtQ9dvMFohYrH95kfwD/
    ck2gWcCzC5Tat1aG5+K24h89fZIEMeHLf9KBd6JgJZgI0NxON2ZNTlWQ8m4s8uVpKI/N
    gTjA==
ARC-Authentication-Results: i=1; strato.com;
    arc=none;
    dkim=none
X-RZG-CLASS-ID: mo01
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; t=1681674407;
    s=strato-dkim-0002; d=hartkopp.net;
    h=In-Reply-To:From:References:Cc:To:Subject:Date:Message-ID:Cc:Date:
    From:Subject:Sender;
    bh=s7e5pLZEiw+VWzLdZyOifqhlqNcQHDzzu/jx3K9/G7A=;
    b=IUznJkOsCZmR88DurFI/rNus5QPxdhpa6dnmuJzTnJIoMadzddwU+GNwBxPFuJZkcX
    dAnsO7ZhR2ZNpdLSH1biuPLDNDZd87mpzpqtMll9J2Q16DBX5QDJwXwz9iaOFR8Blbsy
    GosRbcSsyBaRKKLatZZdbprjlu/MaimwbBHvC5HtM2fY3jmPbwur5ZnRMlULzVcQwzdv
    OetnfeUs9kGrkTcjTA4WdsNCREa/mW0SJz5G1MkBLLXdkfpMfXccm06X14WBiKegeco5
    +pwlBtKjg7H8knYgbIM1J+4vEkOTugT3Lg45+OqoOW/rDMC+Q2RXdk3r7nyVQRJEjp4B
    U57A==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; t=1681674407;
    s=strato-dkim-0003; d=hartkopp.net;
    h=In-Reply-To:From:References:Cc:To:Subject:Date:Message-ID:Cc:Date:
    From:Subject:Sender;
    bh=s7e5pLZEiw+VWzLdZyOifqhlqNcQHDzzu/jx3K9/G7A=;
    b=nSyMQzld3GoRWMQX62ZAhD0y3GwJr8+weQWFeukLweFeggQgoRN01MRqiSZ3HXtJOA
    8Yhl4EeiV6aIp3yoIeBQ==
X-RZG-AUTH: ":P2MHfkW8eP4Mre39l357AZT/I7AY/7nT2yrDxb8mjG14FZxedJy6qgO1qCHSa1GLptZHusl129OHEdFq0USEbDUQnQ=="
Received: from [IPV6:2a00:6020:4a8e:5000::923]
    by smtp.strato.de (RZmta 49.4.0 AUTH)
    with ESMTPSA id x06214z3GJkkSYH
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256 bits))
        (Client did not present a certificate);
    Sun, 16 Apr 2023 21:46:46 +0200 (CEST)
Message-ID: <f58e8dce-898c-8797-5293-1001c9a75381@hartkopp.net>
Date:   Sun, 16 Apr 2023 21:46:40 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.9.0
Subject: Re: [RFC PATCH 5/5] can: m_can: Add hrtimer to generate software
 interrupt
To:     Marc Kleine-Budde <mkl@pengutronix.de>
Cc:     Judith Mendez <jm@ti.com>,
        Chandrasekar Ramakrishnan <rcsekar@samsung.com>,
        Nishanth Menon <nm@ti.com>,
        Vignesh Raghavendra <vigneshr@ti.com>,
        Andrew Davis <afd@ti.com>,
        Wolfgang Grandegger <wg@grandegger.com>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        linux-can@vger.kernel.org, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org, netdev@vger.kernel.org,
        Schuyler Patton <spatton@ti.com>
References: <20230413223051.24455-1-jm@ti.com>
 <20230413223051.24455-6-jm@ti.com>
 <20230414-bounding-guidance-262dffacd05c-mkl@pengutronix.de>
 <4a6c66eb-2ccf-fc42-a6fc-9f411861fcef@hartkopp.net>
 <20230416-failing-washbasin-e4fa5caea267-mkl@pengutronix.de>
Content-Language: en-US
From:   Oliver Hartkopp <socketcan@hartkopp.net>
In-Reply-To: <20230416-failing-washbasin-e4fa5caea267-mkl@pengutronix.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 16.04.23 17:35, Marc Kleine-Budde wrote:
> On 16.04.2023 14:33:11, Oliver Hartkopp wrote:
>>
>>
>> On 4/14/23 20:20, Marc Kleine-Budde wrote:
>>> On 13.04.2023 17:30:51, Judith Mendez wrote:
>>>> Add a hrtimer to MCAN struct. Each MCAN will have its own
>>>> hrtimer instantiated if there is no hardware interrupt found.
>>>>
>>>> The hrtimer will generate a software interrupt every 1 ms. In
>>>
>>> Are you sure about the 1ms?
> 
> I had the 5ms that are actually used in the code in mind. But this is a
> good calculation.

@Judith: Can you acknowledge the value calculation?

>> The "shortest" 11 bit CAN ID CAN frame is a Classical CAN frame with DLC = 0
>> and 1 Mbit/s (arbitration) bitrate. This should be 48 bits @1Mbit => ~50
>> usecs
>>
>> So it should be something about
>>
>>      50 usecs * (FIFO queue len - 2)
> 
> Where does the "2" come from?

I thought about handling the FIFO earlier than it gets completely "full".

The fetching routine would need some time too and the hrtimer could also 
jitter to some extend.

>> if there is some FIFO involved, right?
> 
> Yes, the mcan core has a FIFO. In the current driver the FIFO
> configuration is done via device tree and fixed after that. And I don't
> know the size of the available RAM in the mcan IP core on that TI SoC.
> 
> Marc
> 

Best regards,
Oliver

Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BD6256E4F48
	for <lists+netdev@lfdr.de>; Mon, 17 Apr 2023 19:34:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230072AbjDQReV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Apr 2023 13:34:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57400 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229485AbjDQReU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Apr 2023 13:34:20 -0400
Received: from mo4-p01-ob.smtp.rzone.de (mo4-p01-ob.smtp.rzone.de [85.215.255.50])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5053D5BB3;
        Mon, 17 Apr 2023 10:34:12 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1681752850; cv=none;
    d=strato.com; s=strato-dkim-0002;
    b=lVO7wZVx2MAv4eAMoqoLc1ygoorFoMQhBJiiahjE7DIl1jvlDoRxxzIx+VywrAYvJV
    m7hxgGQ2gy7tf2T0pln3cJKUNekRIGP4txwmxZS/znBtityYb/ih30I+Op1+kOg3W69p
    MjcIjZjCNQ6bBDhIRafreSoNY9khTxmHgRlrzeZo5CvoH27oDiQodg2B8P3t7e1dYqlS
    Uw/Cb6kkWMvtr1iL198/SlzDP3wljyLA1UdGydrDEz+85bozB/31BTsg+SiOlmPEtl2z
    BTLRBHwWuvb2gQ8PwaIwrxXLLQfrEvHVefuOYwAV7VBctTNnAcdSJ7ZbnUCNkmM1/xz0
    +jpg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; t=1681752850;
    s=strato-dkim-0002; d=strato.com;
    h=In-Reply-To:From:References:Cc:To:Subject:Date:Message-ID:Cc:Date:
    From:Subject:Sender;
    bh=TDsaW+fOjNbUU6F8k2uHkSh2gFWrMS54+k1SLnroVEE=;
    b=axcDzRCGjF/m43bFxD+pBm8JKt6B2Ms7x1Sq95ls9uCu/B44MK/AtdpCrEaqxBsLH/
    MfuCheElTWAY5KV0jJ0aOOo0vm6UBXr5zyo1PG24hDKTkScTqlpcE+Zo+KkU3OjXVn2L
    E2lmXF6lck8zj6CvoF4VhrZ/oLmFmzc7qA9dSPPIHwtgpEWbNOmozvNoSFfc9/LbHXtf
    ErVkOu1led5BXIcjLURfp0yjayEfiQuB2vsbWUdcmmxpL6+6vF53OxqIsfzKwM6vXTrA
    lVy3Gprclfh/fB8Ha7NCEfxsviReAUUm3Mod65rgWu8U66d2P5i0DPygvgA8BCi0w/Q3
    jE7A==
ARC-Authentication-Results: i=1; strato.com;
    arc=none;
    dkim=none
X-RZG-CLASS-ID: mo01
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; t=1681752850;
    s=strato-dkim-0002; d=hartkopp.net;
    h=In-Reply-To:From:References:Cc:To:Subject:Date:Message-ID:Cc:Date:
    From:Subject:Sender;
    bh=TDsaW+fOjNbUU6F8k2uHkSh2gFWrMS54+k1SLnroVEE=;
    b=f7eLkshDbSz6JfiV9RfcxPC2SixoKcXJeD5uP6UwnBab8MlBRwJGzN+gaRBx62YmGY
    ptJDfskmkKgiHpdl5Ub3HYdewWGKMhSXrCH8EATbk4lvNUV7jHCiodmc890ZxwwhLXKR
    lN856npgaMbin5A9JtU3ppOrwGjvSw58Me0TkUKUHN6ylMMlWfnc0zcSj0gNFo3qxmmt
    lsT/kcp5/pBlLKPCUBZ1hM3nG3yjiH/Fd4utiTEGMACdFTD3JjZB1R53INps1jN09gLF
    dfYUgNkAp9oP18XflzqaK+MkYzVCmraB9z6tQXJAYO/ADRIEHfL3yAU9kpkfrC+dqxEc
    DYvA==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; t=1681752850;
    s=strato-dkim-0003; d=hartkopp.net;
    h=In-Reply-To:From:References:Cc:To:Subject:Date:Message-ID:Cc:Date:
    From:Subject:Sender;
    bh=TDsaW+fOjNbUU6F8k2uHkSh2gFWrMS54+k1SLnroVEE=;
    b=MWm17DgufCea4SceyL83BCi+gB3NJMnnl4fye2NpdX/dC3+Asj0mJnQMXxZ5uFL1ek
    AiSe3gU8wLVC6IZzvgCg==
X-RZG-AUTH: ":P2MHfkW8eP4Mre39l357AZT/I7AY/7nT2yrDxb8mjG14FZxedJy6qgO1qCHSa1GLptZHusl129OHEdFq0USEbDUQnQ=="
Received: from [IPV6:2a00:6020:4a8e:5000::923]
    by smtp.strato.de (RZmta 49.4.0 AUTH)
    with ESMTPSA id x06214z3HHY9W20
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256 bits))
        (Client did not present a certificate);
    Mon, 17 Apr 2023 19:34:09 +0200 (CEST)
Message-ID: <25806ec7-64c5-3421-aea1-c0d431e3f27f@hartkopp.net>
Date:   Mon, 17 Apr 2023 19:34:03 +0200
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
 <f58e8dce-898c-8797-5293-1001c9a75381@hartkopp.net>
 <20230417-taking-relieving-f2c8532864c0-mkl@pengutronix.de>
Content-Language: en-US
From:   Oliver Hartkopp <socketcan@hartkopp.net>
In-Reply-To: <20230417-taking-relieving-f2c8532864c0-mkl@pengutronix.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 17.04.23 09:26, Marc Kleine-Budde wrote:
> On 16.04.2023 21:46:40, Oliver Hartkopp wrote:
>>> I had the 5ms that are actually used in the code in mind. But this is a
>>> good calculation.
>>
>> @Judith: Can you acknowledge the value calculation?
>>
>>>> The "shortest" 11 bit CAN ID CAN frame is a Classical CAN frame with DLC = 0
>>>> and 1 Mbit/s (arbitration) bitrate. This should be 48 bits @1Mbit => ~50
>>>> usecs
>>>>
>>>> So it should be something about
>>>>
>>>>       50 usecs * (FIFO queue len - 2)
>>>
>>> Where does the "2" come from?
>>
>> I thought about handling the FIFO earlier than it gets completely "full".
>>
>> The fetching routine would need some time too and the hrtimer could also
>> jitter to some extend.
> 
> I was assuming something like this.
> 
> I would argue that the polling time should be:
> 
>      50 µs * FIFO length - IRQ overhead.
> 
> The max IRQ overhead depends on your SoC and kernel configuration.

I just tried an educated guess to prevent the FIFO to be filled up 
completely. How can you estimate the "IRQ overhead"? And how do you 
catch the CAN frames that are received while the IRQ is handled?

Best regards,
Oliver



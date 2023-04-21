Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0A9FF6EB545
	for <lists+netdev@lfdr.de>; Sat, 22 Apr 2023 00:55:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233259AbjDUWz3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Apr 2023 18:55:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50736 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230110AbjDUWz1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 Apr 2023 18:55:27 -0400
Received: from mail-pf1-x433.google.com (mail-pf1-x433.google.com [IPv6:2607:f8b0:4864:20::433])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A6D721730
        for <netdev@vger.kernel.org>; Fri, 21 Apr 2023 15:55:26 -0700 (PDT)
Received: by mail-pf1-x433.google.com with SMTP id d2e1a72fcca58-63b70f0b320so3711346b3a.1
        for <netdev@vger.kernel.org>; Fri, 21 Apr 2023 15:55:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mistywest-com.20221208.gappssmtp.com; s=20221208; t=1682117726; x=1684709726;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=n734qa3Pdm/FFLE9UBT/WvBivwjuwq8zl7M1W5Fzyd0=;
        b=MVaPUPPdxxvsRhsqkYdKKjMppTJmA4UIVSX0CGD5Xj6IUQI9W2OWH3+5Cvx6hauvn9
         n8PmqbjV2MK8aous417IqsIyf+3Jc5SP1jn3Yir/C7tbkYu2/rzPDXPQeyOW0uq7TD2C
         BJJ5EaJXuTlecoVFJWNGcUXjVCgdE3ZpnXr3Pd8erhGQzimLtsVGdINunTbjX5PIpnvy
         G2TMvhYBZpcH9Dum2740R8N/DaVxAERNz2eh+wPUaCgQFmFojfuwjf5Z/40hBeYipB5X
         fdrk5Y6EgQHezdFCUrqNgn/XjbfdIIC+qoecBTxURSJbrIJxjXQIJQ/OEMHbiWbAeyC3
         Z5jg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682117726; x=1684709726;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=n734qa3Pdm/FFLE9UBT/WvBivwjuwq8zl7M1W5Fzyd0=;
        b=lPuWl0Es7Nr1HoJFJdBklWDbg32JbLB3fnMQhsh24lSl0xLh4JYvR8Pl3N57KHhThl
         TW6jLtsQb6xefJpQXcHWRM6jYYaZp3EVXGfjIvlbt3TCNrl5WbWUS/WTQzcv7F3mu1cQ
         NIez+3e66QrIxN0NsEc7msh+8zWqWZ4xqL05HNxgvI4IbyVPduegG7dNzAHmNZmrw0HR
         516RwtwLXgk1jTEXlR7Jc7RfCBLk1vio1Kku1/rRzb7D05lygti0slBg57WrB0sgfrvd
         GFijpahEZ5efw5tr700YvC69QO2TaTNhJKlQm149+PI1VFsht3KedF3c1er3juNqLdfk
         ZbcQ==
X-Gm-Message-State: AAQBX9d+Btn5OfrZJxAgMM+WiUnJfnVne40E/LSsGXoBgMOt3Wa4navW
        xqkCoTv4wKlDyYJ3BTWJmQP7cg==
X-Google-Smtp-Source: AKy350Zs1tvf3RcG3bySBYs9VCFwI7ksKW1aItiQXB6AkZkUomPIZ60//U/YCgr1O6VL5Z4KW7dk8w==
X-Received: by 2002:a05:6a20:429e:b0:f2:64f8:b214 with SMTP id o30-20020a056a20429e00b000f264f8b214mr5260125pzj.13.1682117726093;
        Fri, 21 Apr 2023 15:55:26 -0700 (PDT)
Received: from [192.168.1.222] (S01061c937c8195ad.vc.shawcable.net. [24.87.33.175])
        by smtp.gmail.com with ESMTPSA id w35-20020a631623000000b0051f15c575fesm2973000pgl.87.2023.04.21.15.55.25
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 21 Apr 2023 15:55:25 -0700 (PDT)
Message-ID: <fa806e4a-b706-ce54-b3e0-b95d065e8d4a@mistywest.com>
Date:   Fri, 21 Apr 2023 15:55:23 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.0
Subject: Re: issues to bring up two VSC8531 PHYs
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Heiner Kallweit <hkallweit1@gmail.com>, netdev@vger.kernel.org,
        Russell King - ARM Linux <linux@armlinux.org.uk>
References: <5eb810d7-6765-4de5-4eb0-ad0972bf640d@mistywest.com>
 <bb62e044-034e-771e-e3a9-a4b274e3dec9@gmail.com>
 <46e4d167-5c96-41a0-8823-a6a97a9fa45f@lunn.ch>
 <ba56f0a4-b8af-a478-7c1d-e6532144b820@gmail.com>
 <59fc6f98-0f67-f4a3-23c9-cd589aaa6af8@mistywest.com>
 <b3776edd-e337-44a4-8196-a6a94b498991@lunn.ch>
 <02b26c6f-f056-cec6-daf1-5e7736363d4e@mistywest.com>
 <7bb09c7c-24fc-4c8d-8068-f163082ab781@lunn.ch>
Content-Language: en-US
From:   Ron Eggler <ron.eggler@mistywest.com>
In-Reply-To: <7bb09c7c-24fc-4c8d-8068-f163082ab781@lunn.ch>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-5.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 4/21/23 09:35, Andrew Lunn wrote:
>>> You can also try:
>>>
>>> ethtool --phy-statistics ethX
>> after appliaction of the above patch, ethtool tells me
>>
>> # ethtool --phy-statistics eth0
>> PHY statistics:
>>       phy_receive_errors: 65535
>>      phy_idle_errors: 255
> So these have saturated. Often these counters don't wrap, they stop at
> the maximum value.
>
> These errors also indicate your problem is probably not between the
> MAC and the PHY, but between the PHY and the RJ45 socket. Or maybe how
> the PHY is clocked. It might not have a stable clock, or the wrong
> clock frequency.

The man page (https://www.man7.org/linux/man-pages/man8/ethtool.8.html) 
does not give any details about what phy_receive_errors or 
phy_idle_errors refer to exactly, is there any documentation about it 
that I could not find?


Ron

-- 
RON EGGLER Firmware Engineer (he/him/his) www.mistywest.com

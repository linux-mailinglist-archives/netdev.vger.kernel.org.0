Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8C8CF445697
	for <lists+netdev@lfdr.de>; Thu,  4 Nov 2021 16:51:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231533AbhKDPxo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 4 Nov 2021 11:53:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34112 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229770AbhKDPxo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 4 Nov 2021 11:53:44 -0400
Received: from mail-wr1-x42a.google.com (mail-wr1-x42a.google.com [IPv6:2a00:1450:4864:20::42a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1068BC061714;
        Thu,  4 Nov 2021 08:51:06 -0700 (PDT)
Received: by mail-wr1-x42a.google.com with SMTP id b12so9341890wrh.4;
        Thu, 04 Nov 2021 08:51:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=WZb02HUNcpyrSV5l5/+XMe5AMoc6YwLyY8T5euRMbL8=;
        b=kw1zp2Tegl4Kqb4SQ0i5nA93CA98pd7hYLtkw13rlOMEQZ+8Q418AzSmPVcyedY74C
         ABTDfoiZNmd1s4NmsY4PWLZhgb3Y1XfqgBLaWDRnQH+/hLeAofrOwy7p8lZsjZSugL3F
         qrmL7LzDpqv5BwpI1UxzYHz/nPrF7LPiHH5C3sKTPWd3H/lECZQohDF+Ynq7FWOlIIgS
         /aPrZ/MhApbdHIyUnl4liqM7yWj9yl03OnkwXGaX+xZbE2IgwRGwXsJAmP+kvLNTw606
         uTKDJKSeDBWCs1LcRwCwkV1jPQ1fCNcpeM/tbxb8ZP7j1CilcdcHqsXUIgJKjP9eWS94
         FLxA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=WZb02HUNcpyrSV5l5/+XMe5AMoc6YwLyY8T5euRMbL8=;
        b=1KKrFWtD+EZHWIzSwdqf52hTvLKw/wojFNYVCtR8SZrVmFeua2LteKc8HAl+nQTZHl
         KFNluKn/n92MRXzFO7iQ5Uc5YqDA7AfWA4t8yBMGq9cMCUnCOY509ixsbmEo3mIxUpSL
         LzcYuHIdlpIAJKfiVY4Sol3DTwmdu+9a9vFTWuCL69BA8qQUDK77gOqXmArvqQrhLiyU
         S2gKMP2sttSa7gYtd57tBJb26NArTH/B8zqfLkJzjybrRd3PuTJuRs6kDQBl7+vZAGVm
         7y+xca0qbLPLGXOkKJf53MxN9oQHGdjqJLDrUr+QgzYEC19QAldngiBpumtwHt6W/Bt3
         g6Yw==
X-Gm-Message-State: AOAM532RPwX0ehD7tJFj+rkk3nCt7sgXwkbEAyjCO4rI801Mx38cORNU
        Y9oIYjG+r3ZxVqGGXOEuACs=
X-Google-Smtp-Source: ABdhPJyDTpRBmB3xRPfE1CErEHrPH0QFPa6OVsRksW9o7hV8xA9OzQNF3oJjV7lgeE4GnIlESrqjZA==
X-Received: by 2002:adf:ce8b:: with SMTP id r11mr45456071wrn.294.1636041064535;
        Thu, 04 Nov 2021 08:51:04 -0700 (PDT)
Received: from debian64.daheim (p5b0d7fa5.dip0.t-ipconnect.de. [91.13.127.165])
        by smtp.gmail.com with ESMTPSA id e12sm6714724wrq.20.2021.11.04.08.51.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 04 Nov 2021 08:51:04 -0700 (PDT)
Received: from localhost.daheim ([127.0.0.1])
        by debian64.daheim with esmtp (Exim 4.95)
        (envelope-from <chunkeey@gmail.com>)
        id 1mie48-00085z-QO;
        Thu, 04 Nov 2021 16:51:03 +0100
Message-ID: <179edf00-3ae0-3964-3433-015da8274aff@gmail.com>
Date:   Thu, 4 Nov 2021 16:51:03 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.2.1
Subject: Re: [RFC net-next/wireless-next v1 2/2] ath10k: move
 device_get_mac_address() and pass errors up the chain
Content-Language: de-DE
To:     Mathias Kresin <dev@kresin.me>, netdev@vger.kernel.org,
        linux-acpi@vger.kernel.org, linux-wireless@vger.kernel.org,
        ath10k@lists.infradead.org
Cc:     Ansuel Smith <ansuelsmth@gmail.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S . Miller" <davem@davemloft.net>,
        "Rafael J . Wysocki" <rafael@kernel.org>,
        Jakub Kicinski <kuba@kernel.org>, Len Brown <lenb@kernel.org>,
        Andrew Lunn <andrew@lunn.ch>, Michael Walle <michael@walle.cc>,
        Arnd Bergmann <arnd@arndb.de>
References: <20211030174111.1432663-1-chunkeey@gmail.com>
 <20211030174111.1432663-2-chunkeey@gmail.com>
 <2caec4e0-94f4-915c-60d1-c78e7bdc5364@kresin.me>
From:   Christian Lamparter <chunkeey@gmail.com>
In-Reply-To: <2caec4e0-94f4-915c-60d1-c78e7bdc5364@kresin.me>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Mathias,

On 02/11/2021 23:08, Mathias Kresin wrote:
> 10/30/21 7:41 PM, Christian Lamparter:
>> --- a/drivers/net/wireless/ath/ath10k/ahb.c
>> +++ b/drivers/net/wireless/ath/ath10k/ahb.c
>> @@ -745,9 +745,11 @@ static int ath10k_ahb_probe(struct platform_device *pdev)
>>       size = sizeof(*ar_pci) + sizeof(*ar_ahb);
>>       ar = ath10k_core_create(size, &pdev->dev, ATH10K_BUS_AHB,
>>                   hw_rev, &ath10k_ahb_hif_ops);
>> -    if (!ar) {
>> -        dev_err(&pdev->dev, "failed to allocate core\n");
>> -        return -ENOMEM;
>> +    if (IS_ERR(ar)) {
>> +        ret = PTR_ERR(ar);
>> +        if (ret != -EPROBE_DEFER)
>> +            dev_err(&pdev->dev, "failed to allocate core: %d\n", ret);
> 
> There's a helper for that: dev_err_probe().

I was looking for that. Thank you! :-)
(I need to check if this device_get_mac_address() all works
with 5.15-next or not. It's probably easier to wait until
5.16-rc1-wt gets released).

Regards,
Christian

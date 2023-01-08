Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E58CC66152F
	for <lists+netdev@lfdr.de>; Sun,  8 Jan 2023 13:49:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232907AbjAHMtS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 8 Jan 2023 07:49:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32834 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229482AbjAHMtQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 8 Jan 2023 07:49:16 -0500
Received: from mail-ej1-x631.google.com (mail-ej1-x631.google.com [IPv6:2a00:1450:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DDBE0110C;
        Sun,  8 Jan 2023 04:49:15 -0800 (PST)
Received: by mail-ej1-x631.google.com with SMTP id qk9so13818304ejc.3;
        Sun, 08 Jan 2023 04:49:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=txZDWRyk31P/lBn7N7GNRaUrSacN5uRPaibOTmbLa1A=;
        b=Uh7kSL0OSgThsz0TEpTtOlzWJ7MeghSYYBASK+AoYjyt9B1wa36+KcibIRXBJJMQ6C
         TWP6ms02REB0zYdfyvfBGyMPWUs1Y6TR0syIdeuP9iBRUQPnW/MC12DW4DIbDfAhGlTx
         d5l5AZwsKG/KpFRUj5W8by418+MTT3XVX5Kw9e9XN7XlGVEbRdnnX76ncsfu4QufBHcl
         D9lX4c7QgHQcKcfvgL41/An6V3dco3fZNBEHvRgZ4QbJGz4I05ULqguWJPB7TCkD9Mdd
         l/stqgILYY0tj61XmGsxbfp3bDvwqfFxS31EA4BrtirH7gGuvscaXHfL22jVdOpqhP7B
         qsZA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=txZDWRyk31P/lBn7N7GNRaUrSacN5uRPaibOTmbLa1A=;
        b=wp4j91zRLbeqj9hSVdmwpV+TfiOPPtqp/3iZdbr/R9gDtvIXiq1H6Cah9CdwXg9832
         rY7hVGWPdvIIqgSe7CNTWxx6YWIVa3FUdT4ld+2kHnGDu0t2VgY3Ikvegll+x6K+0YTh
         S0mntCfMfwtvIOxmPaJ9UeCcs1uGE11XlsehViGFgRWBmBg9Jx7b8kOtxz65CGXk+V3Z
         SfzTg434neeZa0Yc9hG1oCOY3By5Zca8+wljm538it5u27gv8t+XuOm7/2DceNIyc9FG
         +f3HvMRQBJa0Sb/BsMboDF7Zpe14LYAUmGjWtoYjUZ7lxJ4din4Qd+J/R35jjb7LvGDY
         3Kgw==
X-Gm-Message-State: AFqh2kqFkRhYIVv5K5wsRYPY7DHTryH2w2s0OFshvLQcTSeta/uuyp+u
        i5Wn6oTg8yv71ix8g1q3L+c=
X-Google-Smtp-Source: AMrXdXvK+6B9KV+f+7A8w8pXkXTnKnzySqCA543UWOEFkjEd3FsD3ZXoLnYY8ZaEpS5yRoGTTS85JQ==
X-Received: by 2002:a17:906:4e48:b0:7c1:8f78:9562 with SMTP id g8-20020a1709064e4800b007c18f789562mr48946958ejw.50.1673182154344;
        Sun, 08 Jan 2023 04:49:14 -0800 (PST)
Received: from [192.168.1.50] ([79.119.240.114])
        by smtp.gmail.com with ESMTPSA id s22-20020a170906961600b007815ca7ae57sm2486224ejx.212.2023.01.08.04.49.12
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 08 Jan 2023 04:49:13 -0800 (PST)
Message-ID: <4ce57d51-0b53-6258-d003-ebb4a2eb4b82@gmail.com>
Date:   Sun, 8 Jan 2023 14:49:12 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.3.3
Subject: Re: [PATCH] wifi: rtl8xxxu: fixing transmisison failure for rtl8192eu
To:     Jun ASAKA <JunASAKA@zzy040330.moe>, Jes.Sorensen@gmail.com
Cc:     kvalo@kernel.org, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20221217030659.12577-1-JunASAKA@zzy040330.moe>
 <18907e6b-93b4-d850-8a17-95ad43501136@gmail.com>
 <56a335f1-3558-e496-4b0b-b024a935f881@zzy040330.moe>
Content-Language: en-US
From:   Bitterblue Smith <rtl8821cerfe2@gmail.com>
In-Reply-To: <56a335f1-3558-e496-4b0b-b024a935f881@zzy040330.moe>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 08/01/2023 11:29, Jun ASAKA wrote:
> On 07/01/2023 22:17, Bitterblue Smith wrote:
> 
>> On 17/12/2022 05:06, Jun ASAKA wrote:
>>> Fixing transmission failure which results in
>>> "authentication with ... timed out". This can be
>>> fixed by disable the REG_TXPAUSE.
>>>
>>> Signed-off-by: Jun ASAKA <JunASAKA@zzy040330.moe>
>>> ---
>>>   drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_8192e.c | 5 +++++
>>>   1 file changed, 5 insertions(+)
>>>
>>> diff --git a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_8192e.c b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_8192e.c
>>> index a7d76693c02d..9d0ed6760cb6 100644
>>> --- a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_8192e.c
>>> +++ b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_8192e.c
>>> @@ -1744,6 +1744,11 @@ static void rtl8192e_enable_rf(struct rtl8xxxu_priv *priv)
>>>       val8 = rtl8xxxu_read8(priv, REG_PAD_CTRL1);
>>>       val8 &= ~BIT(0);
>>>       rtl8xxxu_write8(priv, REG_PAD_CTRL1, val8);
>>> +
>>> +    /*
>>> +     * Fix transmission failure of rtl8192e.
>>> +     */
>>> +    rtl8xxxu_write8(priv, REG_TXPAUSE, 0x00);
>>>   }
>>>     static s8 rtl8192e_cck_rssi(struct rtl8xxxu_priv *priv, u8 cck_agc_rpt)
>> By the way, you should get this into the stable kernels too:
>> https://www.kernel.org/doc/html/latest/process/stable-kernel-rules.html
> 
> I see.
> 
> But since this patch has not been merged into Linus' tree yet, so should I wait until this patch is merged or I should issue a v2 patch here and Cc it to "table@vger.kernel.org"?
> 
> 
> Jun ASAKA.
> 
Ah, yeah. Wait then.

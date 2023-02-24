Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 26EF86A1FEB
	for <lists+netdev@lfdr.de>; Fri, 24 Feb 2023 17:45:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229998AbjBXQpH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Feb 2023 11:45:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44906 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229757AbjBXQpH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Feb 2023 11:45:07 -0500
Received: from mail-ed1-x52e.google.com (mail-ed1-x52e.google.com [IPv6:2a00:1450:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A475F1A66B;
        Fri, 24 Feb 2023 08:45:05 -0800 (PST)
Received: by mail-ed1-x52e.google.com with SMTP id da10so58354266edb.3;
        Fri, 24 Feb 2023 08:45:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :cc:to:from:subject:user-agent:mime-version:date:message-id:from:to
         :cc:subject:date:message-id:reply-to;
        bh=qhsCvsTQigHaRbJBtRfG3MI7vuMgumhn+WwEAc/wh38=;
        b=KfxTUqrPaM/JFBgLjle39E08GF3YQnUun22/P74B0AWc1lMfJglKCVpq+igWeLLccw
         eVt3KKQE9brNzCZWJLP1A2xZOjTt7q16eJxe4p99vHxmvLgkECg51StdGqXKolE4YOyn
         g5oK4hYxY/OjU6GfJNekO54scJiE88CX84XBb9KiI4992tnCT/gLQ8Lr4Myo6f8d8zfV
         1nIwREah3PkGpMwp16uyj8EpXEaJYby9vU00NLG/1ig0+fUtah223DuH/f1vcIdMM/E4
         Bz4VSxfy6remH3BjpBhfH09td1V3mIA5/mAaoi31WF0HpWX2HSANAaeVPNAvoEPaXwF5
         BGPw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :cc:to:from:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=qhsCvsTQigHaRbJBtRfG3MI7vuMgumhn+WwEAc/wh38=;
        b=L72f5VYbID+RofKuINqkAvpAZ2LmgW+yNIKbTzXpGUx44tB4buI6O+yqKnOCfhta84
         X6BDT4aShHZ5sUQhvcmA6SOzdWB9GkX9+P356zl2NvIEH3J11Ebk67TJgrNzM/1qaczX
         Oj9JH4Lm2NL9Svsnu8dcgEDVzyoyCVTWh6EH74QHCwdtbVxg0jkC2TO7GpRx3zXlbyua
         R8b3LtxHHX5JBIcVP24nLtFTSFPgTZVkfU9RKTrzWmPPsQhq5WSNoAWNKyx92+ynlYCq
         OxmmBMJgtpM2uyE5fIKKIZslWd3wQniwZU9gOk5CsCIkxHeVexnOZDQ3Id5SC73Wnbpb
         AfHg==
X-Gm-Message-State: AO0yUKURCR+FCi2smqEStDqE8mxtZRqvSYbtLeGqEhWt7jUivdRbhxk7
        8TzQuNhxJSvuTIFYSVvg25Y=
X-Google-Smtp-Source: AK7set/4ePRxdLx3BL4tvb//3n2ehhz8lNKdTJxXQszTAbDdd+iv6YtOmXPPufJI0gn1001tbhEj2Q==
X-Received: by 2002:a17:907:d403:b0:8ae:fa9f:d58e with SMTP id vi3-20020a170907d40300b008aefa9fd58emr30424961ejc.53.1677257104079;
        Fri, 24 Feb 2023 08:45:04 -0800 (PST)
Received: from [192.168.1.50] ([79.119.240.25])
        by smtp.gmail.com with ESMTPSA id kq9-20020a170906abc900b008d9c518a318sm5844996ejb.142.2023.02.24.08.45.03
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 24 Feb 2023 08:45:03 -0800 (PST)
Message-ID: <5c024519-3c5c-dd83-6b71-14b2747084fd@gmail.com>
Date:   Fri, 24 Feb 2023 18:44:19 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.2
Subject: Re: [PATCH] wifi: rtl8xxxu: fixing transmisison failure for rtl8192eu
From:   Bitterblue Smith <rtl8821cerfe2@gmail.com>
To:     Jun ASAKA <JunASAKA@zzy040330.moe>, Jes.Sorensen@gmail.com
Cc:     kvalo@kernel.org, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20221217030659.12577-1-JunASAKA@zzy040330.moe>
 <18907e6b-93b4-d850-8a17-95ad43501136@gmail.com>
 <56a335f1-3558-e496-4b0b-b024a935f881@zzy040330.moe>
 <4ce57d51-0b53-6258-d003-ebb4a2eb4b82@gmail.com>
Content-Language: en-US
In-Reply-To: <4ce57d51-0b53-6258-d003-ebb4a2eb4b82@gmail.com>
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

On 08/01/2023 14:49, Bitterblue Smith wrote:
> On 08/01/2023 11:29, Jun ASAKA wrote:
>> On 07/01/2023 22:17, Bitterblue Smith wrote:
>>
>>> On 17/12/2022 05:06, Jun ASAKA wrote:
>>>> Fixing transmission failure which results in
>>>> "authentication with ... timed out". This can be
>>>> fixed by disable the REG_TXPAUSE.
>>>>
>>>> Signed-off-by: Jun ASAKA <JunASAKA@zzy040330.moe>
>>>> ---
>>>>   drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_8192e.c | 5 +++++
>>>>   1 file changed, 5 insertions(+)
>>>>
>>>> diff --git a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_8192e.c b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_8192e.c
>>>> index a7d76693c02d..9d0ed6760cb6 100644
>>>> --- a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_8192e.c
>>>> +++ b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_8192e.c
>>>> @@ -1744,6 +1744,11 @@ static void rtl8192e_enable_rf(struct rtl8xxxu_priv *priv)
>>>>       val8 = rtl8xxxu_read8(priv, REG_PAD_CTRL1);
>>>>       val8 &= ~BIT(0);
>>>>       rtl8xxxu_write8(priv, REG_PAD_CTRL1, val8);
>>>> +
>>>> +    /*
>>>> +     * Fix transmission failure of rtl8192e.
>>>> +     */
>>>> +    rtl8xxxu_write8(priv, REG_TXPAUSE, 0x00);
>>>>   }
>>>>     static s8 rtl8192e_cck_rssi(struct rtl8xxxu_priv *priv, u8 cck_agc_rpt)
>>> By the way, you should get this into the stable kernels too:
>>> https://www.kernel.org/doc/html/latest/process/stable-kernel-rules.html
>>
>> I see.
>>
>> But since this patch has not been merged into Linus' tree yet, so should I wait until this patch is merged or I should issue a v2 patch here and Cc it to "table@vger.kernel.org"?
>>
>>
>> Jun ASAKA.
>>
> Ah, yeah. Wait then.

It should be fine to send it now.

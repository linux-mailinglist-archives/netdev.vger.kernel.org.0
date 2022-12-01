Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 00C8E63F13E
	for <lists+netdev@lfdr.de>; Thu,  1 Dec 2022 14:10:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231149AbiLANKB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Dec 2022 08:10:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53254 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231220AbiLANJ7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 1 Dec 2022 08:09:59 -0500
Received: from mail-ej1-x62c.google.com (mail-ej1-x62c.google.com [IPv6:2a00:1450:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 129129E44A;
        Thu,  1 Dec 2022 05:09:56 -0800 (PST)
Received: by mail-ej1-x62c.google.com with SMTP id vv4so4107639ejc.2;
        Thu, 01 Dec 2022 05:09:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=0jz1HLaxl88ozkD6mHLvrjmXIkPIX0Lx9G6bs3QkAkg=;
        b=Fk1LLVz8P+OfjdPAyMGQUn6qVnyleCgKlLJSrTJXx04x5Jf7Ocs1/DdRH1ftZdZgyQ
         pjrauZk8C82Bl+P2XQqcII+xTv0mpDhmxEFYEht/F+Px1fLv372iFJ1E+bJH4pwzqB9P
         vk3iplF5gu3DAEWtiOpxqSdaMs3p7tXJxyA9bmWE8KdJQpocpNbc3obfMb9BcLRABQgp
         cCozLtCgDymPg/kLFiAaew9wkKTMKq5XCgR4FFwn7jiU05odvA0UiwjmZOllPCIyMDkS
         Q0qlT3s64O4ehiVrVAKJSDScVpTQJTSRjtS0pQynb+NcQD7mi1izC+cU4dK2tsKm63Wz
         igTQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=0jz1HLaxl88ozkD6mHLvrjmXIkPIX0Lx9G6bs3QkAkg=;
        b=juAiFhezIRnVI7z1d4RnO9NwmaL5RV6GQrRW0Mrw9o98dQoTDWR+iBR/o2R7VUX2Lc
         ytsep/bV5b99K46ZcPVyGvXnnU6J7+fa4hcAveiGcPM8jUDcyKjkvynZhnqfx3jV4Ed1
         6T4d8O+FT8BmE6Kh31V/P6+uU9z9WMKYXtKioCKi4mIh+Yw1SbnJ5/sxC/WhlBR5dNOe
         1b2txZvFNUE/1ne5/zLia+K74kOZsTUSzgurdIvqmnzDbdtlMnfiSn3mMXyWEp0dexQ8
         jyLbK4aIidgPvBJwgkCXNELUWgweJwEbqR5HaQPqWwXtyhh/20zcfsxv3q3IYzSTicOk
         gflg==
X-Gm-Message-State: ANoB5pmgtPuHttMinAWGG9NxqN/6Bkk8CKGLAJeFYwYUcuhJBW3dNwEi
        /1bgH39TYaA4lbKrWZaxq/Q=
X-Google-Smtp-Source: AA0mqf5dP6+vhvNUs9jbQn3Wu4GllWNV3MCZCxwOALYg/+eHJX4RhUbzfEG1BkP45IPlfV/Y4j9EHA==
X-Received: by 2002:a17:906:6681:b0:7ae:732d:bc51 with SMTP id z1-20020a170906668100b007ae732dbc51mr43644830ejo.549.1669900194522;
        Thu, 01 Dec 2022 05:09:54 -0800 (PST)
Received: from [192.168.1.50] ([79.119.240.254])
        by smtp.gmail.com with ESMTPSA id q18-20020a1709066b1200b007bf988ce9f7sm1778988ejr.38.2022.12.01.05.09.53
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 01 Dec 2022 05:09:54 -0800 (PST)
Message-ID: <a0c14bfd-a502-6b19-de75-491ea9af3816@gmail.com>
Date:   Thu, 1 Dec 2022 15:09:52 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.3.3
Subject: Re: [PATCH] wifi: rtl8xxxu: fixing IQK failures for rtl8192eu
To:     Ping-Ke Shih <pkshih@realtek.com>,
        Jun ASAKA <JunASAKA@zzy040330.moe>,
        "Jes.Sorensen@gmail.com" <Jes.Sorensen@gmail.com>
Cc:     "kvalo@kernel.org" <kvalo@kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "edumazet@google.com" <edumazet@google.com>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <20221130140849.153705-1-JunASAKA@zzy040330.moe>
 <663e6d79c34f44998a937fe9fbd228e9@realtek.com>
 <6ce2e648-9c12-56a1-9118-e1e18c7ecd7d@zzy040330.moe>
 <870b8a6e591f4de8b83df26f2a65330b@realtek.com>
Content-Language: en-US
From:   Bitterblue Smith <rtl8821cerfe2@gmail.com>
In-Reply-To: <870b8a6e591f4de8b83df26f2a65330b@realtek.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 01/12/2022 04:18, Ping-Ke Shih wrote:
> 
>> -----Original Message-----
>> From: Jun ASAKA <JunASAKA@zzy040330.moe>
>> Sent: Thursday, December 1, 2022 9:39 AM
>> To: Ping-Ke Shih <pkshih@realtek.com>; Jes.Sorensen@gmail.com
>> Cc: kvalo@kernel.org; davem@davemloft.net; edumazet@google.com; kuba@kernel.org; pabeni@redhat.com;
>> linux-wireless@vger.kernel.org; netdev@vger.kernel.org; linux-kernel@vger.kernel.org
>> Subject: Re: [PATCH] wifi: rtl8xxxu: fixing IQK failures for rtl8192eu
>>
>> On 01/12/2022 8:54 am, Ping-Ke Shih wrote:
>>
>>>
>>>> -----Original Message-----
>>>> From: JunASAKA <JunASAKA@zzy040330.moe>
>>>> Sent: Wednesday, November 30, 2022 10:09 PM
>>>> To: Jes.Sorensen@gmail.com
>>>> Cc: kvalo@kernel.org; davem@davemloft.net; edumazet@google.com; kuba@kernel.org; pabeni@redhat.com;
>>>> linux-wireless@vger.kernel.org; netdev@vger.kernel.org; linux-kernel@vger.kernel.org; JunASAKA
>>>> <JunASAKA@zzy040330.moe>
>>>> Subject: [PATCH] wifi: rtl8xxxu: fixing IQK failures for rtl8192eu
>>>>
>>>> Fixing "Path A RX IQK failed" and "Path B RX IQK failed"
>>>> issues for rtl8192eu chips by replacing the arguments with
>>>> the ones in the updated official driver.
>>> I think it would be better if you can point out which version you use, and
>>> people will not modify them back to old version suddenly.
>>>
>>>> Signed-off-by: JunASAKA <JunASAKA@zzy040330.moe>
>>>> ---
>>>>   .../realtek/rtl8xxxu/rtl8xxxu_8192e.c         | 76 +++++++++++++------
>>>>   1 file changed, 54 insertions(+), 22 deletions(-)
>>>>
>>>> diff --git a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_8192e.c
>>>> b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_8192e.c
>>>> index b06508d0cd..82346500f2 100644
>>>> --- a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_8192e.c
>>>> +++ b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_8192e.c
>>> [...]
>>>
>>>> @@ -891,22 +907,28 @@ static int rtl8192eu_iqk_path_b(struct rtl8xxxu_priv *priv)
>>>>
>>>>   	rtl8xxxu_write32(priv, REG_FPGA0_IQK, 0x00000000);
>>>>   	rtl8xxxu_write_rfreg(priv, RF_B, RF6052_REG_UNKNOWN_DF, 0x00180);
>>>> -	rtl8xxxu_write32(priv, REG_FPGA0_IQK, 0x80800000);
>>>>
>>>> -	rtl8xxxu_write32(priv, REG_FPGA0_IQK, 0x00000000);
>>>> +	rtl8xxxu_write_rfreg(priv, RF_B, RF6052_REG_WE_LUT, 0x800a0);
>>>> +	rtl8xxxu_write_rfreg(priv, RF_B, RF6052_REG_RCK_OS, 0x20000);
>>>> +	rtl8xxxu_write_rfreg(priv, RF_B, RF6052_REG_TXPA_G1, 0x0000f);
>>>> +	rtl8xxxu_write_rfreg(priv, RF_B, RF6052_REG_TXPA_G2, 0x07f77);
>>>> +
>>>>   	rtl8xxxu_write32(priv, REG_FPGA0_IQK, 0x80800000);
>>>>
>>>> +	// rtl8xxxu_write32(priv, REG_FPGA0_IQK, 0x00000000);
>>>> +	// rtl8xxxu_write32(priv, REG_FPGA0_IQK, 0x80800000);
>>>> +
>>> I think this is a test code of vendor driver. No need them here.
>>>
>>>
>>>>   	/* Path B IQK setting */
>>>>   	rtl8xxxu_write32(priv, REG_TX_IQK_TONE_A, 0x38008c1c);
>>>>   	rtl8xxxu_write32(priv, REG_RX_IQK_TONE_A, 0x38008c1c);
>>>>   	rtl8xxxu_write32(priv, REG_TX_IQK_TONE_B, 0x18008c1c);
>>>>   	rtl8xxxu_write32(priv, REG_RX_IQK_TONE_B, 0x38008c1c);
>>>>
>>>> -	rtl8xxxu_write32(priv, REG_TX_IQK_PI_B, 0x821403e2);
>>>> +	rtl8xxxu_write32(priv, REG_TX_IQK_PI_B, 0x82140303);
>>>>   	rtl8xxxu_write32(priv, REG_RX_IQK_PI_B, 0x68160000);
>>>>
>>>>   	/* LO calibration setting */
>>>> -	rtl8xxxu_write32(priv, REG_IQK_AGC_RSP, 0x00492911);
>>>> +	rtl8xxxu_write32(priv, REG_IQK_AGC_RSP, 0x00462911);
>>>>
>>>>   	/* One shot, path A LOK & IQK */
>>>>   	rtl8xxxu_write32(priv, REG_IQK_AGC_PTS, 0xfa000000);
>>> [...]
>>>
>>> I have compared your patch with internal code, and they are the same.
>>> But, I don't have a test.
>>>
>>> Ping-Ke
>>
>> I changed those arguments into the ones here:
>> https://github.com/Mange/rtl8192eu-linux-driver which works fine with my
>> rtl8192eu wifi dongle. But forgive my ignorant that I don't have enough
>> experience on wifi drivers, I just compared those two drivers and
>> figured that those codes fixing my IQK failures.
> 
> I do similar things as well. :-)
> 
> The github repository mentioned 
> "This branch is based on Realtek's driver versioned 4.4.1. master is based on 4.3.1.1 originally."
> So, we can add something to commit message: 
> 1. https://github.com/Mange/rtl8192eu-linux-driver 
> 2. vendor driver version: 4.3.1.1
> 
> --
> Ping-Ke
> 

That repo is confusing, unfortunately. Indeed, the "master" branch seems to
contain v4.3.1.1_11320.20140505. But the last commit is from 2017.

The "realtek-4.4.x" branch is the one being actively maintained, and at some
point it was updated to v5.6.4_35685.20191108_COEX20171113-0047. README.md
was forgotten.

Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6C5BE652134
	for <lists+netdev@lfdr.de>; Tue, 20 Dec 2022 14:04:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233760AbiLTNDm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Dec 2022 08:03:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36364 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233507AbiLTNDh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 20 Dec 2022 08:03:37 -0500
Received: from mail-ed1-x536.google.com (mail-ed1-x536.google.com [IPv6:2a00:1450:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5FA41DE4;
        Tue, 20 Dec 2022 05:03:36 -0800 (PST)
Received: by mail-ed1-x536.google.com with SMTP id i9so17399483edj.4;
        Tue, 20 Dec 2022 05:03:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=2Og7+6ieoeZuMIctQHPANXasHJDVTyU4dmzcZDyN7Ac=;
        b=dGc1U/criCMUlZ26juiBEWKIo6M5IOAyYaRRR9bPbccHG2Bv0V5iQSUV7SF2HDOuYP
         874d9OO8mdtMzLCvFJz31lEWfUB+4nT8iUrzAnssAIZWBZ11MaW0TeBOOtgfrG3xZRMv
         TxCTHSFBQlqiB6eJHvOgcXEMbYGf8c+XCjykMKTa3GtXrtPIYL3FDK8JKHTxTH5bCro7
         dWnuB7hGVbjOCB6cD2Wo2i4sLERioaiECwZVfmCa8d8hQUImu1l1+aOagGPUmqFhrMFJ
         nnUz/dHgJbi81woO0rqK/0QcT9/Td9ma8Q7oiUM51Q2eZ41wGCdOwoUiyfJHkFAf80+3
         NTKQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=2Og7+6ieoeZuMIctQHPANXasHJDVTyU4dmzcZDyN7Ac=;
        b=R1uiRMoZjvEVUoKBdHpVT+GcmG1L0t99c/LsimEZQTRXhRNETwmrpr44LleJcf8if+
         TURVcf19EvRxxXX8eir9/8qmhby6KiEJDGAvcgqxo1Z0/Hq/fJFzW2rmhWRs08zVyiyf
         60QXplJJvRhpEu8EP3urL6BPLj6dTPkbM6gvA9dUYxkjBJpWaFXPiYNLNDoxpEXZnaFo
         xb/2BuBsn62lVa8eBwrLZFjZt75bYFQ+lS8rKVCEmToKyRv0vIPwiVpRj0mk+RAD9hdP
         StWz+J1meZ1tQQjsY9wQF0Rg4xdXinAXDqVyQBavAakek80MThDd0aKdEQ/UF3rsui6G
         RQNw==
X-Gm-Message-State: AFqh2krubJxldgGhw0yhvVkpuJOybgnsy6IRlJqHBdGC2KGTVwtIMUcy
        1Nyq4bJVzBtHVuNWMAGsXW0=
X-Google-Smtp-Source: AMrXdXszumQc1+m89EmwpWp8+ABnsVMGN+0TFPOk5wqHQ7FENd1exMf+pVQUN3TER5M3VUW0L8P9tw==
X-Received: by 2002:aa7:c850:0:b0:472:adc9:6eb2 with SMTP id g16-20020aa7c850000000b00472adc96eb2mr17840559edt.29.1671541414923;
        Tue, 20 Dec 2022 05:03:34 -0800 (PST)
Received: from [192.168.1.50] ([79.119.240.153])
        by smtp.gmail.com with ESMTPSA id cf25-20020a0564020b9900b0045b4b67156fsm5675936edb.45.2022.12.20.05.03.33
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 20 Dec 2022 05:03:34 -0800 (PST)
Message-ID: <33b2b585-c5b1-5888-bcee-ca74ce809a44@gmail.com>
Date:   Tue, 20 Dec 2022 15:03:33 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.3.3
Subject: Re: [PATCH] wifi: rtl8xxxu: fixing transmisison failure for rtl8192eu
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
References: <20221217030659.12577-1-JunASAKA@zzy040330.moe>
 <3b4124ebabcb4ceaae89cd9ccf84c7de@realtek.com>
Content-Language: en-US
From:   Bitterblue Smith <rtl8821cerfe2@gmail.com>
In-Reply-To: <3b4124ebabcb4ceaae89cd9ccf84c7de@realtek.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 20/12/2022 07:44, Ping-Ke Shih wrote:
> 
> 
>> -----Original Message-----
>> From: Jun ASAKA <JunASAKA@zzy040330.moe>
>> Sent: Saturday, December 17, 2022 11:07 AM
>> To: Jes.Sorensen@gmail.com
>> Cc: kvalo@kernel.org; davem@davemloft.net; edumazet@google.com; kuba@kernel.org; pabeni@redhat.com;
>> linux-wireless@vger.kernel.org; netdev@vger.kernel.org; linux-kernel@vger.kernel.org; Jun ASAKA
>> <JunASAKA@zzy040330.moe>
>> Subject: [PATCH] wifi: rtl8xxxu: fixing transmisison failure for rtl8192eu
>>
>> Fixing transmission failure which results in
>> "authentication with ... timed out". This can be
>> fixed by disable the REG_TXPAUSE.
>>
>> Signed-off-by: Jun ASAKA <JunASAKA@zzy040330.moe>
>> ---
>>  drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_8192e.c | 5 +++++
>>  1 file changed, 5 insertions(+)
>>
>> diff --git a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_8192e.c
>> b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_8192e.c
>> index a7d76693c02d..9d0ed6760cb6 100644
>> --- a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_8192e.c
>> +++ b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_8192e.c
>> @@ -1744,6 +1744,11 @@ static void rtl8192e_enable_rf(struct rtl8xxxu_priv *priv)
>>  	val8 = rtl8xxxu_read8(priv, REG_PAD_CTRL1);
>>  	val8 &= ~BIT(0);
>>  	rtl8xxxu_write8(priv, REG_PAD_CTRL1, val8);
>> +
>> +	/*
>> +	 * Fix transmission failure of rtl8192e.
>> +	 */
>> +	rtl8xxxu_write8(priv, REG_TXPAUSE, 0x00);
> 
> I trace when rtl8xxxu set REG_TXPAUSE=0xff that will stop TX.
> The occasions include RF calibration, LPS mode (called by power off), and
> going to stop. So, I think RF calibration does TX pause but not restore
> settings after calibration, and causes TX stuck. As the flow I traced,
> this patch looks reasonable. But, I wonder why other people don't meet
> this problem.
> 
Other people have this problem too:
https://bugzilla.kernel.org/show_bug.cgi?id=196769
https://bugzilla.kernel.org/show_bug.cgi?id=216746

The RF calibration does restore REG_TXPAUSE at the end. What happens is
when you plug in the device, something (mac80211? wpa_supplicant?) calls
rtl8xxxu_start(), then rtl8xxxu_stop(), then rtl8xxxu_start() again.
rtl8xxxu_stop() sets REG_TXPAUSE to 0xff and nothing sets it back to 0.

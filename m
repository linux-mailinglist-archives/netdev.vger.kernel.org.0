Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BE02E5AB764
	for <lists+netdev@lfdr.de>; Fri,  2 Sep 2022 19:24:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235064AbiIBRX6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Sep 2022 13:23:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38930 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230151AbiIBRX5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 2 Sep 2022 13:23:57 -0400
Received: from mail-wm1-x331.google.com (mail-wm1-x331.google.com [IPv6:2a00:1450:4864:20::331])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3D514FC316
        for <netdev@vger.kernel.org>; Fri,  2 Sep 2022 10:23:56 -0700 (PDT)
Received: by mail-wm1-x331.google.com with SMTP id az24-20020a05600c601800b003a842e4983cso1833975wmb.0
        for <netdev@vger.kernel.org>; Fri, 02 Sep 2022 10:23:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=smile-fr.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date;
        bh=CxLhblwGkGcaC+D1M5T945ieoOqCM24BriG3py00Qzk=;
        b=xOvluaFHFB11kk+p+23Z1UlfjT7L5QVrS8hr06TGc3rXRA/sxm8U/3X/qFYCaXf5Ud
         wfFWrrLbeSaRxOeg+cstxmBI+0AyIbe9hyzW+xUoYXxGRdXfrNhOkkcV0+Jkzxs2sxaE
         u9R6SwO86jt071yppVRIHwkBWETFpZd4ltcmUtIxsoDvPAlKdRW7IqBNGO4kHoyxHyNK
         ohZGhO3LTEsiu1eeapPj8QKgwb6HB57RrhmMYi3zw0da1sf4k9x0nomuv1dvnnDsgpT1
         HBmLV4Ofpg2n9ODyP4E8iYXNazo2wZwa4RGjv8/XESZkQJw71IcNQEDur4IisqvPUhPq
         CIrw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date;
        bh=CxLhblwGkGcaC+D1M5T945ieoOqCM24BriG3py00Qzk=;
        b=ryLkNTZg3qwN74wvhcTwXHW3MO5Qd6hoC3Ef0qQ7sihXEM/gRL1ilWRYH0Nf6Q0x69
         nO/ZovZKJN1bFp4pq/0wRha83UXGOdl7DeCYyWvW+5ua8tQLw43fr0jEMP7uHyqFxBn7
         c1ZXgJdiSZT0bsSzgyZl4yZrCyG3jSYh3sm0sYFV2lHlgrn7GuTDmZ12FhL+5hl8vPlS
         6CqaOPDWNvCnp49sd7i38alAagFryI10V3fnxNhRD1pjKvqOludAvfxI0O4gNYVprDrZ
         ZEmENDCwy/v0k/EiVXu7BSOFS3KvRVPEOnzgn3rEfd51AW9t2bgnRW0hERc/ucr2rmjn
         f7ug==
X-Gm-Message-State: ACgBeo2hFvmuJBpMZnNB9XTMVT3/pWhzgkBATv/K66LluTRhanhu6t9X
        DaISrSRYVjIjtANQ7G4iyJ0ccA==
X-Google-Smtp-Source: AA6agR6QZtFnuLOBT8MhE4EmOZ2lP9EbH9e8Hh8W3y7S2Xyf9HjiNteTK1EBT2B5Yc4ZYk6/Npqayg==
X-Received: by 2002:a05:600c:4e0f:b0:3a5:e065:9b50 with SMTP id b15-20020a05600c4e0f00b003a5e0659b50mr3591638wmq.35.1662139434791;
        Fri, 02 Sep 2022 10:23:54 -0700 (PDT)
Received: from ?IPV6:2a01:cb05:8f8a:1800:1c97:b8d1:b477:d53f? (2a01cb058f8a18001c97b8d1b477d53f.ipv6.abo.wanadoo.fr. [2a01:cb05:8f8a:1800:1c97:b8d1:b477:d53f])
        by smtp.gmail.com with ESMTPSA id v64-20020a1cac43000000b003a844885f88sm2814320wme.22.2022.09.02.10.23.53
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 02 Sep 2022 10:23:54 -0700 (PDT)
Message-ID: <0e2eafc1-4af8-15c0-f587-eddb454c8754@smile.fr>
Date:   Fri, 2 Sep 2022 19:23:53 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.0
Subject: Re: [PATCH v3: net-next 2/4] net: dsa: microchip: add KSZ9896 to
 KSZ9477 I2C driver
Content-Language: en-US
To:     Arun.Ramadoss@microchip.com, netdev@vger.kernel.org
Cc:     olteanv@gmail.com, andrew@lunn.ch, UNGLinuxDriver@microchip.com,
        vivien.didelot@gmail.com, f.fainelli@gmail.com, kuba@kernel.org,
        pabeni@redhat.com, edumazet@google.com, Woojung.Huh@microchip.com,
        romain.naour@skf.com, davem@davemloft.net
References: <20220902101610.109646-1-romain.naour@smile.fr>
 <20220902101610.109646-2-romain.naour@smile.fr>
 <aa0c9a7b3384a69ce4b5be85673df479788d1208.camel@microchip.com>
From:   Romain Naour <romain.naour@smile.fr>
In-Reply-To: <aa0c9a7b3384a69ce4b5be85673df479788d1208.camel@microchip.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Arun,

Le 02/09/2022 à 15:39, Arun.Ramadoss@microchip.com a écrit :
> On Fri, 2022-09-02 at 12:16 +0200, Romain Naour wrote:
>> EXTERNAL EMAIL: Do not click links or open attachments unless you
>> know the content is safe
>>
>> From: Romain Naour <romain.naour@skf.com>
>>
>> Add support for the KSZ9896 6-port Gigabit Ethernet Switch to the
>> ksz9477 driver. The KSZ9896 supports both SPI (already in) and I2C.
>>
>> Signed-off-by: Romain Naour <romain.naour@skf.com>
>> ---
>> The KSZ9896 support i2c interface, it seems safe to enable as is but
>> runtime testing is really needed (my KSZ9896 is wired with spi).
>>
>> v2: remove duplicated SoB line
>> ---
>>  drivers/net/dsa/microchip/ksz9477_i2c.c | 4 ++++
>>  1 file changed, 4 insertions(+)
>>
>> diff --git a/drivers/net/dsa/microchip/ksz9477_i2c.c
>> b/drivers/net/dsa/microchip/ksz9477_i2c.c
>> index 99966514d444..8fbc122e3384 100644
>> --- a/drivers/net/dsa/microchip/ksz9477_i2c.c
>> +++ b/drivers/net/dsa/microchip/ksz9477_i2c.c
>> @@ -91,6 +91,10 @@ static const struct of_device_id ksz9477_dt_ids[]
>> = {
>>                 .compatible = "microchip,ksz9477",
>>                 .data = &ksz_switch_chips[KSZ9477]
>>         },
>> +       {
>> +               .compatible = "microchip,ksz9896",
>> +               .data = &ksz_switch_chips[KSZ9896]
>> +       },
> 
> Do we need to add the compatible in ksz_spi interface as well, since
> ksz9896 supports both i2c and spi interface.

That's what the first patch does.

Thanks for your review.

Best regards,
Romain


> 
>>         {
>>                 .compatible = "microchip,ksz9897",
>>                 .data = &ksz_switch_chips[KSZ9897]
>> --
>> 2.34.3
>>


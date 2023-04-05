Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5DCF36D7CDC
	for <lists+netdev@lfdr.de>; Wed,  5 Apr 2023 14:43:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238014AbjDEMnd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Apr 2023 08:43:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51814 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237141AbjDEMnF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 Apr 2023 08:43:05 -0400
Received: from mail-qt1-x829.google.com (mail-qt1-x829.google.com [IPv6:2607:f8b0:4864:20::829])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B3C0540C4
        for <netdev@vger.kernel.org>; Wed,  5 Apr 2023 05:43:04 -0700 (PDT)
Received: by mail-qt1-x829.google.com with SMTP id g19so34811362qts.9
        for <netdev@vger.kernel.org>; Wed, 05 Apr 2023 05:43:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1680698584; x=1683290584;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=BR/MB21aJMiv6VgCELv7Fom7APmWyTJEuKBLSrtaCrs=;
        b=YNJRgitdCYcI2RjpyOkxlnBVt1TgzCNstC1ATVcn8OGDW3WykRdEXE7pwan9M1fB6t
         QwoKIu2Hyiwc2bjFo8MPODsoKZRMaGTI4Wz4b/1aZoDgCqII9VFFMpRUt1ZMGFP9I5Ts
         N3KzuYBPlHdz1qNExuJaidt/lZj2bpOWjO2fPYmFLWF0X9bXBsOyljjum2eTDMvB/hcq
         EUXsmVJyuargwqTgALdTTugTDbcWnaxdBduNW2tYyzz3ZGS9ph/X5O4oh3ofQ5gNQ97d
         nfRCVqQbAAtz8cUahBew14T9S4u2MrAUZ/7FqM7xWQqXyFWEh+5wpGi2Qnwomg4izmro
         LCdA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680698584; x=1683290584;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=BR/MB21aJMiv6VgCELv7Fom7APmWyTJEuKBLSrtaCrs=;
        b=GZ2SEy/Cq0T0KWXniE3rvpMQ074MX110yDF5JcJ5GnNyC69l4AEGpJegbNEbR4mllv
         1FqG8+VvYUDy5M6FpVG7pm8aamgIAtjcJDYo+WCbpAQmc9o10jFaN6YwUQwfdjj1QVQx
         8P+aYUiKh20ffvPyCo5uiCsqheoUNY7Hrb2Yg2t2e2oa4U59PAkel1KEwMAUdBsbtg2k
         pk2suLbYOWBHXeCj3QeAgiixcVGV/UO8ylS8PS5lf9z5XmRRi7hunrqWJbgA198eSmAB
         Jr/dNgkLprtVOBpHH57HBw20gdpJ7g5UQ1EXIQNwynAaBjMlc3urOt7QYWLsSsjkFiF/
         uGCA==
X-Gm-Message-State: AAQBX9exSeEd37uP+cLGxSIj93y+5NfOGCpalrswCr+xC6QjUmi/4rhe
        YGjKQ17hw56pDuS2mbCUbu4=
X-Google-Smtp-Source: AKy350a8UFImb/dDJN6DHAGrUxrTdRANw3umqa6V3KFEdwatHYcRQcsv8StWq8RpPiVwTrCj7cPKJg==
X-Received: by 2002:a05:622a:1786:b0:3e4:e5bf:a250 with SMTP id s6-20020a05622a178600b003e4e5bfa250mr4988275qtk.7.1680698583820;
        Wed, 05 Apr 2023 05:43:03 -0700 (PDT)
Received: from [192.168.1.105] (ip72-194-116-95.oc.oc.cox.net. [72.194.116.95])
        by smtp.gmail.com with ESMTPSA id s66-20020a372c45000000b0074a2467f541sm3960804qkh.35.2023.04.05.05.43.00
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 05 Apr 2023 05:43:03 -0700 (PDT)
Message-ID: <b7b11a57-9512-cda9-1b15-5dd5aa12f162@gmail.com>
Date:   Wed, 5 Apr 2023 05:42:59 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.9.1
Subject: Re: [PATCH net] bgmac: fix *initial* chip reset to support BCM5358
Content-Language: en-US
To:     =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <rafal@milecki.pl>,
        =?UTF-8?Q?Ricardo_Ca=c3=b1uelo?= <ricardo.canuelo@collabora.com>,
        =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, Arnd Bergmann <arnd@arndb.de>,
        Florian Fainelli <f.fainelli@gmail.com>,
        netdev@vger.kernel.org, bcm-kernel-feedback-list@broadcom.com,
        Jon Mason <jdmason@kudzu.us>
References: <20230227091156.19509-1-zajec5@gmail.com>
 <20230404134613.wtikjp6v63isofoc@rcn-XPS-13-9305>
 <002c1f96-b82f-6be7-2530-68c5ae1d962d@milecki.pl>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <002c1f96-b82f-6be7-2530-68c5ae1d962d@milecki.pl>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.6 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 4/4/2023 6:52 AM, Rafał Miłecki wrote:
> Hi,
> 
> On 4.04.2023 15:46, Ricardo Cañuelo wrote:
>> On mar 07-02-2023 23:53:27, Rafał Miłecki wrote:
>>> While bringing hardware up we should perform a full reset including the
>>> switch bit (BGMAC_BCMA_IOCTL_SW_RESET aka SICF_SWRST). It's what
>>> specification says and what reference driver does.
>>>
>>> This seems to be critical for the BCM5358. Without this hardware doesn't
>>> get initialized properly and doesn't seem to transmit or receive any
>>> packets.
>>>
>>> Signed-off-by: Rafał Miłecki <rafal@milecki.pl>
>>
>> KernelCI found this patch causes a regression in the
>> bootrr.deferred-probe-empty test [1] on sun8i-h3-libretech-all-h3-cc
>> [2], see the bisection report for more details [3]
>>
>> Does it make sense to you?
> 
> It doesn't seem to make any sense. I guess that on your platform
> /sys/kernel/debug/devices_deferred
> is not empty anymore?
> 
> Does your platform use Broadcom Ethernet controller at all?

I do not believe it does, however according to the log, the driver is 
enabled:

<6>[    1.819466] bgmac_bcma: Broadcom 47xx GBit MAC driver loaded

but it should not be probing any device since you don't have any 
internal BCMA bus to match gigabit devices with. Later in the log we see:

1c22c00.codec	sun4i-codec: Failed to register our card

and most likely as you already wrote the deferred device list might not 
be empty.
-- 
Florian

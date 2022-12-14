Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E2C1C64D1EA
	for <lists+netdev@lfdr.de>; Wed, 14 Dec 2022 22:43:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229647AbiLNVnX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Dec 2022 16:43:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38334 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229475AbiLNVnW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 14 Dec 2022 16:43:22 -0500
Received: from mail-ej1-x632.google.com (mail-ej1-x632.google.com [IPv6:2a00:1450:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8B06F31DE8;
        Wed, 14 Dec 2022 13:43:20 -0800 (PST)
Received: by mail-ej1-x632.google.com with SMTP id vv4so47801992ejc.2;
        Wed, 14 Dec 2022 13:43:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:subject:from:references:cc:to
         :content-language:user-agent:mime-version:date:message-id:from:to:cc
         :subject:date:message-id:reply-to;
        bh=WOM35NSkl7CfZFv6FY36aAQSu0chDpwBN61A5jdRrQk=;
        b=o6Ni/Grh71hN1L2644JxFDIGyixI7jmoLbjM2BK8eknrJKByklfVAsrVU2hrJ+mY8j
         rdoic1K7FNaQENWRS5irIs3SbPQoPvXi74hKzJ7KGMrIu2+DNPDOztgU0bAn57YqV83z
         yts+8IJERzBvSakh8twHdfC2L3mPVEgg7PYEQWd3Z+3wPIpmsTn1n2HV8x+JWS/yqxcg
         WtoIa+gmnM0HPO5K6X2ckTe3OIzcFDA+MS9V/oakWDz3+quecZ8gFWvLdDom6Eap++3y
         yMmebw2WiBJZnyl2mWBXSmxAxjb1ov4isSV1fsDFbBOIwkGMPgG3vfJCHp9DuXzShmr7
         bZ4A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:subject:from:references:cc:to
         :content-language:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=WOM35NSkl7CfZFv6FY36aAQSu0chDpwBN61A5jdRrQk=;
        b=0ruy6g9P3us/W+Qp9aLCsioq0WPjQZEGOZ7SpeOT4LF1e6EubGpBuIUz5u8LSex1QF
         bv3vKLaqQj/JLTwRq6fhtPdijjMevVG8S+ak9Li3w95pFxLe5kGswMd283yrr3P4uM1F
         xteRkJgahbIAGj7hvzEMUys4SB9ozdg3MuetoK9ze21EPKiWk09iWghNY5TI1YA8mFY1
         F2bwim2W6fdE9hzGYDBM1lHtGC9IiWoexomrUIAV3E3t2lVYRONbsVlO9kjjtlPDKSgH
         JKL3dTKcmxBLTSjl8vUd3dqrFfEdXfPyAhzcVRsZf0GApu84tk8Jv9isiKt7XZcCy2ee
         5njw==
X-Gm-Message-State: ANoB5plhrfctqj/+lElxueI3eSbydshRZK6BS58VtwswDIYzdnW/qdMa
        prNe9rxe9vho77os4lUxjhQ=
X-Google-Smtp-Source: AA0mqf73xpCitfVigQrn0wXSTQg2Q9KtzQIhAtzorjixlsxaDQHMr+baPRYjde24t9W7bIT/7jsynw==
X-Received: by 2002:a17:906:704d:b0:7b9:62ab:dc3f with SMTP id r13-20020a170906704d00b007b962abdc3fmr30321345ejj.1.1671054199060;
        Wed, 14 Dec 2022 13:43:19 -0800 (PST)
Received: from ?IPV6:2a01:c23:b8b1:2700:80c5:d7b3:aee5:57bf? (dynamic-2a01-0c23-b8b1-2700-80c5-d7b3-aee5-57bf.c23.pool.telefonica.de. [2a01:c23:b8b1:2700:80c5:d7b3:aee5:57bf])
        by smtp.googlemail.com with ESMTPSA id 4-20020a170906328400b007aed2057ea1sm6281652ejw.167.2022.12.14.13.43.17
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 14 Dec 2022 13:43:18 -0800 (PST)
Message-ID: <4576ee79-1040-1998-6d91-7ef836ae123b@gmail.com>
Date:   Wed, 14 Dec 2022 22:43:12 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.1
Content-Language: en-US
To:     Jakub Kicinski <kuba@kernel.org>, Leon Romanovsky <leon@kernel.org>
Cc:     Lixue Liang <lianglixuehao@126.com>, anthony.l.nguyen@intel.com,
        linux-kernel@vger.kernel.org, jesse.brandeburg@intel.com,
        davem@davemloft.net, edumazet@google.com, pabeni@redhat.com,
        netdev@vger.kernel.org, lianglixue@greatwall.com.cn,
        Alexander H Duyck <alexander.duyck@gmail.com>
References: <20221213074726.51756-1-lianglixuehao@126.com>
 <Y5l5pUKBW9DvHJAW@unreal> <20221214085106.42a88df1@kernel.org>
 <Y5obql8TVeYEsRw8@unreal> <20221214125016.5a23c32a@kernel.org>
From:   Heiner Kallweit <hkallweit1@gmail.com>
Subject: Re: [PATCH v7] igb: Assign random MAC address instead of fail in case
 of invalid one
In-Reply-To: <20221214125016.5a23c32a@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 14.12.2022 21:50, Jakub Kicinski wrote:
> On Wed, 14 Dec 2022 20:53:30 +0200 Leon Romanovsky wrote:
>> On Wed, Dec 14, 2022 at 08:51:06AM -0800, Jakub Kicinski wrote:
>>> On Wed, 14 Dec 2022 09:22:13 +0200 Leon Romanovsky wrote:  
>>>> NAK to any module driver parameter. If it is applicable to all drivers,
>>>> please find a way to configure it to more user-friendly. If it is not,
>>>> try to do the same as other drivers do.  
>>>
>>> I think this one may be fine. Configuration which has to be set before
>>> device probing can't really be per-device.  
>>
>> This configuration can be different between multiple devices
>> which use same igb module. Module parameters doesn't allow such
>> separation.
> 
> Configuration of the device, sure, but this module param is more of 
> a system policy. BTW the name of the param is not great, we're allowing
> the use of random address, not an invalid address.
> 
>> Also, as a user, I despise random module parameters which I need
>> to set after every HW update/replacement.
> 
> Agreed, IIUC the concern was alerting users to incorrect EEPROM values.
> I thought falling back to a random address was relatively common, but
> I haven't done the research.

My 2ct, because I once added the fallback to a random MAC address to r8169:
Question is whether there's any scenario where you would prefer bailing out
in case of invalid MAC address over assigning a random MAC address (that the
user may manually change later) plus a warning.
I'm not aware of such a scenario. Therefore I decided to hardcode this
fallback in the driver.


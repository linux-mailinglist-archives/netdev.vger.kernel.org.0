Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 395F855B3F6
	for <lists+netdev@lfdr.de>; Sun, 26 Jun 2022 22:04:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232140AbiFZUCa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 26 Jun 2022 16:02:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57268 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232133AbiFZUC3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 26 Jun 2022 16:02:29 -0400
Received: from mail-ed1-x52e.google.com (mail-ed1-x52e.google.com [IPv6:2a00:1450:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2D9161159
        for <netdev@vger.kernel.org>; Sun, 26 Jun 2022 13:02:28 -0700 (PDT)
Received: by mail-ed1-x52e.google.com with SMTP id c13so10323803eds.10
        for <netdev@vger.kernel.org>; Sun, 26 Jun 2022 13:02:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=L5luTbophPMtkkcPCTZKh24/A/2KpC32wThCfYNcqBw=;
        b=Ft2aRODYm0ooP4HVNITmIfrnQxEc1UVQXmL45t2je8p42F4zyOb1RtKjS4YngXvoeL
         N8ABZ6cSPXVSZ5JsNLY9Kqdd98xeFvOTS3xELRf9iN7+MsRnqNIqQCwzH13wgnZoS6IS
         xIzufEXQRLsizhjwafl1zU//kC1cdTkiU7hZw5HMtUI5TkauwJRQeOFgcOPZK84MVvmz
         NeCud2UCvQKFVFhifUXhW/yn5Ey9CGEghzzvjg6dBbhvGT0PUhzZcsEdm9hfg3mpKsAO
         aZNZ7M8xDKghh6dOR63Z4i00T+xo1WNkuCBz9ArPTKR6tE/TA953SEo+AGeW0fLoU0j4
         SrJw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=L5luTbophPMtkkcPCTZKh24/A/2KpC32wThCfYNcqBw=;
        b=wspe2/PrUm4lmjQcmTO0oZ/1lBzRdCXhse0zRF9O7XNsDmamBSR7alifk0vJ8Vm08h
         SPZquofHfY2LT7m2kC9SXFYiLv58+DVQpiLSEC+59v72MEJSx1NMoVADvmO4k5moUlXh
         VIoQH2F0O7Y9QmsPIHlPCuFpAt3Z49M778Ff/VLZD4FWRHlCO0YaQEkUD3AohEtPz48f
         xLPA6+YhP0t6twdSkt8NjD5+3eTDFcRE5+YgmzKiGHpE0Tkg2h3ezqZ3+gdqc8d52gX9
         4LBMVLuyfqUYScUMmqFUtOyf4nMll6U50QDMYgOBQm57zb7Bs+DRkHstqHfoKXJlN318
         FsAg==
X-Gm-Message-State: AJIora8qIzcYhidwp9XhKU9p7wckGdUnayYNV9AorlBwtOZ3y+KNaDoR
        J3XgAvawT4Gax3UqZuUY0dCRemn5kphMZQ==
X-Google-Smtp-Source: AGRyM1uAX7GHluPWOZ+mm6n4aoUDMhbCqd/31547KKJrSeyePKgiWbv0/VTiEo5zhKBxoWInDD10Mw==
X-Received: by 2002:a50:ff0e:0:b0:433:5d15:eada with SMTP id a14-20020a50ff0e000000b004335d15eadamr12551827edu.102.1656273746784;
        Sun, 26 Jun 2022 13:02:26 -0700 (PDT)
Received: from [192.168.0.245] (xdsl-188-155-176-92.adslplus.ch. [188.155.176.92])
        by smtp.gmail.com with ESMTPSA id y1-20020aa7c241000000b004355dc75066sm6321979edo.86.2022.06.26.13.02.25
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 26 Jun 2022 13:02:26 -0700 (PDT)
Message-ID: <63b7e653-d2d2-c1fc-e43f-1c70ecbe9d04@linaro.org>
Date:   Sun, 26 Jun 2022 22:02:25 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.10.0
Subject: Re: [PATCH 2/2] NFC: nxp-nci: Don't issue a zero length
 i2c_master_read()
Content-Language: en-US
To:     Michael Walle <michael@walle.cc>
Cc:     Charles Gorand <charles.gorand@effinnov.com>,
        =?UTF-8?Q?Cl=c3=a9ment_Perrochaud?= <clement.perrochaud@nxp.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20220626194243.4059870-1-michael@walle.cc>
 <20220626194243.4059870-2-michael@walle.cc>
 <3c28bc43-4994-8e12-25f4-32b723e6e7ac@linaro.org>
 <f9aa0597b22e2282abe7925135eebc4e@walle.cc>
From:   Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
In-Reply-To: <f9aa0597b22e2282abe7925135eebc4e@walle.cc>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 26/06/2022 21:56, Michael Walle wrote:
> Am 2022-06-26 21:51, schrieb Krzysztof Kozlowski:
>> On 26/06/2022 21:42, Michael Walle wrote:
>>> There are packets which doesn't have a payload. In that case, the 
>>> second
>>> i2c_master_read() will have a zero length. But because the NFC
>>> controller doesn't have any data left, it will NACK the I2C read and
>>> -ENXIO will be returned. In case there is no payload, just skip the
>>> second i2c master read.
>>>
>>> Fixes: 6be88670fc59 ("NFC: nxp-nci_i2c: Add I2C support to NXP NCI 
>>> driver")
>>> Signed-off-by: Michael Walle <michael@walle.cc>
>>
>> Reviewed-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
> 
> Thanks, I'll reorder the patches in the next version otherwise
> there will likely be a conflict.

Yes.

> That should work with any patch
> tools (i.e. b4), shouldn't it?

You mean - re-ordering should work? Yes, no problem with that.

Best regards,
Krzysztof

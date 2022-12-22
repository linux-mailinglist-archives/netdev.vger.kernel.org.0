Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AE920653E56
	for <lists+netdev@lfdr.de>; Thu, 22 Dec 2022 11:32:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235336AbiLVKch (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Dec 2022 05:32:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42476 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235038AbiLVKcf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 22 Dec 2022 05:32:35 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4D7471EC;
        Thu, 22 Dec 2022 02:32:34 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 021D7B81D11;
        Thu, 22 Dec 2022 10:32:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D02ABC433EF;
        Thu, 22 Dec 2022 10:32:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1671705151;
        bh=+O2SMYuiD+a6BrGX3LWSkWDiITMpiTrVROT/YBfj4fY=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=K5jqoxofMEb3CCc7H5adb+T0ZyCLaKTOMqW9tKd4XQcwjmOwq96D204V3RWPLbDM9
         d5THqWIGsrIiMc1ZDf9OfXKZfLpqROudLURhOHvoZrYdnQmGDsu9ORSVCiOviofSSa
         06SYFgbZdrOsYz/V7AMJ/ADhP4ZlHzXd1dbfnFflm4/bySKYjsLKADTp7xaqE+HUHf
         j7NQj39ICgeXy6wRfaSSqeMGURDon3tvQJzcq19Oi8n3IO6eRlU0Sfa/AU5X5Ycuct
         /qGr66CFc6ZigHLsP7iSolB+vbu/Ye1Ru6qpgPF5zUPdCNzt5Q7eCA89KIbo5/f0zw
         1vygUMCLwoMCA==
Message-ID: <ace9cc9d-ccf1-fffa-3504-6504fdfb5a20@kernel.org>
Date:   Thu, 22 Dec 2022 11:32:27 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.0
Subject: Re: [PATCH 1/2] dt-bindings: net: Add rfkill-gpio binding
Content-Language: en-US
To:     Philipp Zabel <p.zabel@pengutronix.de>,
        Rob Herring <robh@kernel.org>
Cc:     Johannes Berg <johannes@sipsolutions.net>, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-wireless@vger.kernel.org, kernel@pengutronix.de
References: <20221221104803.1693874-1-p.zabel@pengutronix.de>
 <20221221144505.GA2848091-robh@kernel.org>
 <432ed015f4ba99d6bddd0a10af72324fea1388da.camel@pengutronix.de>
From:   Krzysztof Kozlowski <krzk@kernel.org>
In-Reply-To: <432ed015f4ba99d6bddd0a10af72324fea1388da.camel@pengutronix.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 21/12/2022 16:36, Philipp Zabel wrote:
>>> +    $ref: /schemas/types.yaml#/definitions/string
>>> +    description: rfkill switch name, defaults to node name
>>> +
>>> +  type:
>>
>> Too generic. Property names should ideally have 1 type globally. I think 
>> 'type' is already in use. 'radio-type' instead?
> 
> These values correspond to the 'enum rfkill_type' in Linux UAPI, but I
> think in this context 'radio-type' would be better than 'rfkill-type'.

Do not map Linux driver to DT, but rather describe the actual hardware.

> 
>>> +    description: rfkill radio type
>>> +    enum:
>>> +      - wlan
>>> +      - bluetooth
>>> +      - ultrawideband
>>> +      - wimax
>>> +      - wwan
>>> +      - gps
>>> +      - fm
>>> +      - nfc
>>> +
>>> +  shutdown-gpios:
>>> +    maxItems: 1
>>> +
>>> +  reset-gpios:
>>> +    maxItems: 1
>>
>> I'm lost as to why there are 2 GPIOs.
> 
> I don't know either.  My assumption is that this is for devices that
> are radio silenced by just asserting their reset pin (for example GPS
> chips). The driver handles them the same.
> 
> I could remove reset-gpios and make shutdown-gpios required.
> 
>>> +
>>> +required:
>>> +  - compatible
>>> +  - type
>>> +
>>> +oneOf:
>>> +  - required:
>>> +      - shutdown-gpios
>>> +  - required:
>>> +      - reset-gpios
>>
>> But only 1 can be present? So just define 1 GPIO name.
> 
> The intent was that only one of them would be required.
> 
>>> +additionalProperties: false
>>> +
>>> +examples:
>>> +  - |
>>> +    #include <dt-bindings/gpio/gpio.h>
>>> +
>>> +    rfkill-pcie-wlan {
>>
>> Node names should be generic.
> 
> What could be a generic name for this - is "rfkill" acceptable even
> though it is a Linux subsystem name? Or would "rf-kill-switch" be
> better?

rfkill

> 
> How should they be called if there are multiple of them?

The same as in all other cases (leds, gpios, regulators), so rfkill-1,
rfkill-2...


Best regards,
Krzysztof


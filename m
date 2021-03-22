Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B7C46344574
	for <lists+netdev@lfdr.de>; Mon, 22 Mar 2021 14:20:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232665AbhCVNT3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Mar 2021 09:19:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33686 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233685AbhCVNSC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 22 Mar 2021 09:18:02 -0400
Received: from mail-io1-xd29.google.com (mail-io1-xd29.google.com [IPv6:2607:f8b0:4864:20::d29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D45B4C061574
        for <netdev@vger.kernel.org>; Mon, 22 Mar 2021 06:18:01 -0700 (PDT)
Received: by mail-io1-xd29.google.com with SMTP id k25so1751620iob.6
        for <netdev@vger.kernel.org>; Mon, 22 Mar 2021 06:18:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=CaLl8WYyGhEv/zKl6xwrPBBULyyeZrNEf1aCYBb15Ng=;
        b=FEJ5F5rThAMlyVkPFnTgWR9VaDTkQ4Zha07gqhlb2MnPeqkFGTtf7rY3g2eU1JZgpZ
         WNOcLUYPcxi6+xmmGOhO2Y2OxuTu+F1kLZ3nMC6WVjR6ucXIz/xIchW5vWg0BgmlxjE2
         kkOI5xyDRP7r1szJssUvnJ8tbNLXNLyLxANpQAHOTvYsuaGJzuQLc6zhZ4U5076qZ4zW
         eqw/+NjnG7tUcT1Vz98+EHGpiPHLUrOZnE61ApegXsRSJydd/0Eei1H+i3lvqARpW+Mx
         ASjIOQv/FPoFEChR4XKE60dCZyJPq/rN5/XWF4zRYMd3Rf2NVbivnfLZwozoSuy6Zn9+
         t35w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=CaLl8WYyGhEv/zKl6xwrPBBULyyeZrNEf1aCYBb15Ng=;
        b=o7zXrEO34E0XzWEYASgw/+XauKlk+GN1rgbFDUerwJlvtGaz78bNteW56tUrEsI2Rt
         rovOYg7Gw+j3tu0EXrujTVhr2chRUuWXjM7jIhZjbUqUSr2R5lP0y9xT54jSa+JMsouh
         RBV4ycixzf30vrShaxwobwUbhterXnjLFzZte7624Ew/L196vuwveDYOTMdnz4sD5GFU
         zVi5Ka2OknklyFiVQiFeCbJt8qDfGEbyPs/PQdFcetMHmZYDtJ3KW1ttTqv/unSljYUt
         B23CYItes5CnG6eOGghL2pme3IBNOmBmnLfHw2dVlSbFRaH/SAN0AYcTkLCnHRJisTcZ
         CZyg==
X-Gm-Message-State: AOAM532WqCz1BSgesBn7akE7dwXoWddG+PvRgjoSFxEfu9jfv9rfNidY
        1a2ScPk9zpNStD2dRSQAkeVnYQ==
X-Google-Smtp-Source: ABdhPJxWECBZRbIVVehzNPNIjC9vslsXeO2NI2qJuOhWSVFcfy7S2/V6bQPJeEKnrl29rgNrIYo4Cw==
X-Received: by 2002:a02:9382:: with SMTP id z2mr11415974jah.120.1616419081107;
        Mon, 22 Mar 2021 06:18:01 -0700 (PDT)
Received: from [172.22.22.4] (c-73-185-129-58.hsd1.mn.comcast.net. [73.185.129.58])
        by smtp.googlemail.com with ESMTPSA id r15sm7625997iot.5.2021.03.22.06.18.00
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 22 Mar 2021 06:18:00 -0700 (PDT)
Subject: Re: [PATCH net-next v2 2/2] net: ipa: fix IPA validation
To:     Leon Romanovsky <leon@kernel.org>
Cc:     davem@davemloft.net, kuba@kernel.org, andrew@lunn.ch,
        bjorn.andersson@linaro.org, evgreen@chromium.org,
        cpratapa@codeaurora.org, subashab@codeaurora.org, elder@kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20210320141729.1956732-1-elder@linaro.org>
 <20210320141729.1956732-3-elder@linaro.org> <YFcCAr19ZXJ9vFQ5@unreal>
 <dd4619e2-f96a-122f-2cf6-ec19445c6a5c@linaro.org> <YFdO6UnWsm4DAkwc@unreal>
 <7bc3e7d7-d32f-1454-eecc-661b5dc61aeb@linaro.org> <YFg7yHUeYvQZt+/Z@unreal>
From:   Alex Elder <elder@linaro.org>
Message-ID: <f152c274-6fe0-37a1-3723-330b7bfe249a@linaro.org>
Date:   Mon, 22 Mar 2021 08:17:59 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.1
MIME-Version: 1.0
In-Reply-To: <YFg7yHUeYvQZt+/Z@unreal>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 3/22/21 1:40 AM, Leon Romanovsky wrote:
>> I'd like to suggest a plan so I can begin to make progress,
>> but do so in a way you/others think is satisfactory.
>> - I would first like to fix the existing bugs, namely that
>>    if IPA_VALIDATION is defined there are build errors, and
>>    that IPA_VALIDATION is not consistently used.  That is
>>    this 2-patch series.
> The thing is that IPA_VALIDATION is not defined in the upstream kernel.
> There is nothing to be fixed in netdev repository
> 
>> - I assure you that my goal is to simplify the code that
>>    does this sort of checking.  So here are some specific
>>    things I can implement in the coming weeks toward that:
>>      - Anything that can be checked at build time, will
>>        be checked with BUILD_BUG_ON().
> +1
> 
>>      - Anything checked with BUILD_BUG_ON() will*not*
>>        be conditional.  I.e. it won't be inside an
>>        #ifdef IPA_VALIDATION block.
>>      - I will review all remaining VALIDATION code (which
>>        can't--or can't always--be checked at build time),
>>        If it looks prudent to make it*always*  be checked,
>>        I will make it always be checked (not conditional
>>        on IPA_VALIDATION).
> +1
> 
>> The result should clearly separate checks that can be done
>> at build time from those that can't.
>>
>> And with what's left (especially on that third sub-bullet)
>> I might have some better examples with which to argue
>> for something different.  Or I might just concede that
>> you were right all along.
> I hope so.

I came up with a solution last night that I'm going to try
to implement.  I will still do the things I mention above.

The solution is to create a user space tool inside the
drivers/net/ipa directory that will link with the kernel
source files and will perform all the basic one-time checks
I want to make.

Building, and then running that tool will be a build
dependency for the driver.  If it fails, the driver build
will fail.  If it passes, all the one-time checks will
have been satisfied and the driver will be built, but it
will not have all of these silly checks littered
throughout.  And all checks (even those that aren't
constant) will be made at build time.

I don't know if that passes your "casual developer"
criterion, but at least it will not be part of the
kernel code proper.

I'm going to withdraw this two-patch series, and post
it again along with others, so I the whole set of changes
can be done as a complete series.

It isn't easy to have something you value be rejected.
But I understand your concerns, and accept the reasoning
about non-standard coding patterns making it harder for
a casual reader to comprehend.  As I said, cleaning up
this validation code was already my goal, but I'll be
doing it differently now.  In the end, I might like the
new result better, which is always a nice outcome from
discussion during review.  Thank you.

					-Alex

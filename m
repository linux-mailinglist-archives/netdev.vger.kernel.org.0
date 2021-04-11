Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B7B5C35B4AF
	for <lists+netdev@lfdr.de>; Sun, 11 Apr 2021 15:42:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235467AbhDKNme (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 11 Apr 2021 09:42:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43550 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229804AbhDKNmd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 11 Apr 2021 09:42:33 -0400
Received: from mail-il1-x131.google.com (mail-il1-x131.google.com [IPv6:2607:f8b0:4864:20::131])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4B3ACC061574
        for <netdev@vger.kernel.org>; Sun, 11 Apr 2021 06:42:17 -0700 (PDT)
Received: by mail-il1-x131.google.com with SMTP id i22so4013612ila.11
        for <netdev@vger.kernel.org>; Sun, 11 Apr 2021 06:42:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=jHOs/GUNj1A6ya3vcccNEUycGjR7OVNzCp35FYh45a8=;
        b=L1RRQYC6N+Dgp4DoT7PRd517GDpNGGbtDzuZ9+qO0iXUwrd8RL0nk3BAmjHcOFMh/L
         F58/rFW3gpuUbxOkb+NQDUNqI2Vd3qUINmwa5K/XHJOSyBC/3TDhRtaAwfXQ8f+4KIgh
         LpKNRLly3IdatiwMfBXxgTcaR9FmlXDegyQSTfY5RJK5ZnCjwxxmIhR2c9nduL13eZcK
         Habfk+eVF9R1w+FVnmdaQZYrgeDP17L4nvzNJZkJf2TqBDyeu/jllBXzntrXHxyerbBl
         1+8r/iPAfKIviGsRx5iRDGpav4ASk2kzYQF0pnuXTf0wj5+r7wyM4BBuFE30AeOpbs3R
         83Nw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=jHOs/GUNj1A6ya3vcccNEUycGjR7OVNzCp35FYh45a8=;
        b=OJf6aN7ef4pMC3XUP+xFpOCFLb0iGPKHctxczFTIdNpzu7RWl/pbl1oqELVSZPhpIH
         SSFeIG9cF4UObY9aZ+phKEbCP4fr2WPXPw9KaztIc6WnFzCMXOyBGvlM8i+kXSFWpIki
         t8dHPb0f+LmNpM69w1ExvYzA362VILPgYizeaUnWS2PPfhsOh3SM+7N33ulsDRi0oS4a
         EKGtleYX9kxPmtoE+Fv4v2VQ+2m8hSJUqKrK0o0C1tHFXtKyJGl9N1t5pUDiT+LMGp82
         g5oNUH+sjeHvWqQRVBzDK0QX6B0I0xEoRE0zV1nztdqSHAPVe49JrUYAIvrW+At+rBT9
         rAkQ==
X-Gm-Message-State: AOAM533vDF/ggW+RiSfDofDPFrJJXQLMYXWePxa6Zh6TpAD1d8esC0l4
        g0TeBTO7a6BFe0YS5UaUpd5ErQ==
X-Google-Smtp-Source: ABdhPJxuBaDdJ7m0Z1ESomTiIQVbmHZfCmZCK7Lzg4DEFwh75H0k+WYobd4D4EFPi3LJyDoysVg5gg==
X-Received: by 2002:a05:6e02:20c5:: with SMTP id 5mr1869932ilq.14.1618148536684;
        Sun, 11 Apr 2021 06:42:16 -0700 (PDT)
Received: from [192.168.20.93] ([64.118.8.63])
        by smtp.googlemail.com with ESMTPSA id b9sm4186165iof.54.2021.04.11.06.42.15
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 11 Apr 2021 06:42:16 -0700 (PDT)
Subject: Re: [PATCH net-next 4/7] net: ipa: ipa_stop() does not return an
 error
To:     Leon Romanovsky <leon@kernel.org>
Cc:     davem@davemloft.net, kuba@kernel.org, bjorn.andersson@linaro.org,
        evgreen@chromium.org, cpratapa@codeaurora.org,
        subashab@codeaurora.org, elder@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20210409180722.1176868-1-elder@linaro.org>
 <20210409180722.1176868-5-elder@linaro.org> <YHKYWCkPl5pucFZo@unreal>
 <1f5c3d2c-f22a-ef5e-f282-fb2dec4479f3@linaro.org> <YHL5fwkYyHvQG2Z4@unreal>
From:   Alex Elder <elder@linaro.org>
Message-ID: <6e0c08a0-aebd-83b2-26b5-98f7d46d6b2b@linaro.org>
Date:   Sun, 11 Apr 2021 08:42:15 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.1
MIME-Version: 1.0
In-Reply-To: <YHL5fwkYyHvQG2Z4@unreal>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 4/11/21 8:28 AM, Leon Romanovsky wrote:
>> I think *not* checking an available return value is questionable
>> practice.  I'd really rather have a build option for a
>> "__need_not_check" tag and have "must_check" be the default.
> __need_not_check == void ???

I'm not sure I understand your statement here, but...

My point is, I'd rather have things like printk() and
strscpy() be marked with (an imaginary) __need_not_check,
than the way things are, with only certain functions being
marked __must_check.

In my view, if a function returns a value, all callers
of that function ought to be checking it.  If the return
value is not necessary it should be a void function if
possible.

I don't expect the world to change, but I just think the
default should be "must check" rather than "check optional".

					-Alex

Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 210AD49FE44
	for <lists+netdev@lfdr.de>; Fri, 28 Jan 2022 17:44:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245543AbiA1Qom (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Jan 2022 11:44:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46452 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239249AbiA1Qom (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 Jan 2022 11:44:42 -0500
Received: from mail-lj1-x234.google.com (mail-lj1-x234.google.com [IPv6:2a00:1450:4864:20::234])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C2193C061714;
        Fri, 28 Jan 2022 08:44:41 -0800 (PST)
Received: by mail-lj1-x234.google.com with SMTP id a25so9819588lji.9;
        Fri, 28 Jan 2022 08:44:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=lGbJdBWOVm4Va2Wgu00QXQ6qBSeWp/5p1TodM7voG/M=;
        b=gi8dnSZB6Jf3ARKxPcuzQilOA1X+IiqrSJpDqa0UwPNSbvxlAZhn7o27PEBX6T4Pt0
         Yy6l0mN+LNiSyQQWHHAmf6parJzpyeXFAkkxL5K7luFmmIlaRL2LfjpG0L/TAIz1bTF9
         i7uzFMuBqGG3XviwNlXn7b799D8RxFzBpjwSZmu3RWfi8ru7YbpoFcVo5g88KsceELfy
         lIZuTKJyqdnQ59c2ztH/IFQSmsKWFYSWfk99sySz8rE0ttv6MHCV9Yo++nJdsP6ntQIH
         zeq+MWJsiwRWavnQIl8R2mLwvpLx0V4yVwg82LUiDJWia8a5F0Ypj1Y64q0qvTav4zhX
         BOPA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=lGbJdBWOVm4Va2Wgu00QXQ6qBSeWp/5p1TodM7voG/M=;
        b=tNYMG9X7EI5m9Cv9JncQW26U+SWVjHCPvgCAWeV4Ql9HWW43NkTlB78bw/SeAMl3nC
         O24Re4sezeKGKg0vG6W/mA5e1shfS72FzBuNtYVeQhD1lwkW2RyPVyxscr0rO1mZHG1d
         0u7jq1QW21uxa0qAC06e/83ObjgyK1t81tJ0uM1gcFql3zkX7z7g8QP/8Fpp8uE9o6VK
         nMyL6wjncxlzBB0Xesxrm733mfCV4jicTGgXScZneZhut45HT/JQyNw8PtPcHuDk5Ne+
         n5NOAU/I/Td1gXUaPFes16F9ahWnhwN8c48sgfOtP7+njmTaFKrVT2+TE8oKSUoxWyad
         htFw==
X-Gm-Message-State: AOAM530mrqOil4iOD8HuOSeSyIjaAmJo+82gJCw/CZW3QnAKMH3T2vFc
        7p9kaNjoidAPbmTxcnW1W7k=
X-Google-Smtp-Source: ABdhPJyJ6jgjwOjzC8CzJQXbRwBcvXaRgKVo2AAd4HIFZT41VNXT41y1PVAPuiy0ARZx4En3ka4wwQ==
X-Received: by 2002:a2e:b8d5:: with SMTP id s21mr6499514ljp.196.1643388279294;
        Fri, 28 Jan 2022 08:44:39 -0800 (PST)
Received: from [192.168.1.103] ([31.173.86.67])
        by smtp.gmail.com with ESMTPSA id f9sm1988948lfm.166.2022.01.28.08.44.37
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 28 Jan 2022 08:44:38 -0800 (PST)
Subject: Re: [PATCH 4/7] mfd: hi6421-spmi-pmic: Use generic_handle_irq_safe().
To:     Lee Jones <lee.jones@linaro.org>
Cc:     Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        greybus-dev@lists.linaro.org, linux-i2c@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-staging@lists.linux.dev,
        linux-usb@vger.kernel.org, netdev@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Alex Elder <elder@kernel.org>, Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Hans de Goede <hdegoede@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Johan Hovold <johan@kernel.org>,
        Rui Miguel Silva <rmfrfs@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        UNGLinuxDriver@microchip.com, Wolfram Sang <wsa@kernel.org>,
        Woojung Huh <woojung.huh@microchip.com>
References: <20220127113303.3012207-1-bigeasy@linutronix.de>
 <20220127113303.3012207-5-bigeasy@linutronix.de>
 <44b42c37-67a4-1d20-e2ff-563d4f9bfae2@gmail.com>
 <YfPwqfmrWEPm/9K0@google.com>
From:   Sergei Shtylyov <sergei.shtylyov@gmail.com>
Message-ID: <d351e221-ddd4-eb34-5bbe-08314d26a2e0@gmail.com>
Date:   Fri, 28 Jan 2022 19:44:36 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <YfPwqfmrWEPm/9K0@google.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 1/28/22 4:33 PM, Lee Jones wrote:

>>> generic_handle_irq() is invoked from a regular interrupt service
>>> routing. This handler will become a forced-threaded handler on
>>
>>    s/routing/routine/?
>>
>>> PREEMPT_RT and will be invoked with enabled interrupts. The
>>> generic_handle_irq() must be invoked with disabled interrupts in order
>>> to avoid deadlocks.
>>>
>>> Instead of manually disabling interrupts before invoking use
>>> generic_handle_irq() which can be invoked with enabled and disabled
>>> interrupts.
>>>
>>> Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
>> [...]
>>
>> MBR, Sergey
> 
> What does that mean?

   Ah, you were asking about MBR! My best regards then. :-)

MBR, Sergey

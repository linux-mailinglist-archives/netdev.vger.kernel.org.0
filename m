Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D45B529DAC5
	for <lists+netdev@lfdr.de>; Thu, 29 Oct 2020 00:31:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390497AbgJ1XbD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Oct 2020 19:31:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33992 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726286AbgJ1XJC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 28 Oct 2020 19:09:02 -0400
Received: from mail-lj1-x242.google.com (mail-lj1-x242.google.com [IPv6:2a00:1450:4864:20::242])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 508FDC0613D1
        for <netdev@vger.kernel.org>; Wed, 28 Oct 2020 16:09:02 -0700 (PDT)
Received: by mail-lj1-x242.google.com with SMTP id m16so1050859ljo.6
        for <netdev@vger.kernel.org>; Wed, 28 Oct 2020 16:09:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=P7F7xIRgu/l8g7HgtzAM8qKS93wbDPv7v/8BlOLWeDI=;
        b=UYu7ljF9nHw7Ms+9PKei/Lvrwh3t1D2Ed4IuVRcFscCKtEfaugYdDjog3RJHvxOytO
         L0OkcSDIEqL4IuNbCI3GZjeMJ7e3Y32AFqNWPZhneVoQYPc3dOlA378J9QhaDW3lqmr2
         QEURm3S8NRYzz5k5+M8L3e5WxfuHXXSLUrWbiZ5mgMr0g59KyMKn9HIXv6Oo2pz7eMtl
         4eiiPRKNbXx5fkOV1i2MXSroOBihpcs6LwUZ80OTac0yvPoyuUWHqwSj6VKma1t8woXZ
         PzADOq33hnCYt0zqmVXpqknXzvobeDQcn8ds8Vp4LbM+9yk67viy9PQJO4ZLq/zxBwwb
         wGBg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=P7F7xIRgu/l8g7HgtzAM8qKS93wbDPv7v/8BlOLWeDI=;
        b=OcS1Xtzre7q6uYRS2E8Y+YDXs6msd2veuf7jDeE8ZQoEGDhMMH3/vHkNDrdWLOBk2W
         8MH2CEIKIdlmPY9edREgC+HlEQ14pGvr9jmnzvtSsocl6/X9ekg/He6WfH6tde5HfR9d
         OETJuvyM2AH/ahWryLd7e66BzzwnLtu6n6NZtMRhPI8IC2nnV1Hv5VzDNMA3YoQgFh2n
         0CDX4L4lUzOvdvZFuyBaXsMhNtqbEuY1xbFIxvN/EOkPFbNZzxMyOBne8JmOzGEeVqra
         wA2YXterLvLYuq68xGuWRTqgSrrmNrUkK4veSkv+43yhUhh+MSYEvaQx88ajzmY0FKyT
         Qbjg==
X-Gm-Message-State: AOAM5321zBiQI4Tde4jNjWB4Z7MxmDc9S3otGaUWT7yPwSWqB+tGadgA
        g9iizAQ0B2OciCbksEDrjibx3Y4UZQI=
X-Google-Smtp-Source: ABdhPJyVwHnIyB7PeVQFgX5pIaT1wyo9txQHTqUX0u5bUZkd5enFmhs0qS2tK66IMJF+trBnasqRUg==
X-Received: by 2002:a5d:63cb:: with SMTP id c11mr6313329wrw.243.1603893873097;
        Wed, 28 Oct 2020 07:04:33 -0700 (PDT)
Received: from ?IPv6:2003:ea:8f23:2800:7833:37d2:8d24:4d07? (p200300ea8f232800783337d28d244d07.dip0.t-ipconnect.de. [2003:ea:8f23:2800:7833:37d2:8d24:4d07])
        by smtp.googlemail.com with ESMTPSA id a3sm6428950wmb.46.2020.10.28.07.04.32
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 28 Oct 2020 07:04:32 -0700 (PDT)
Subject: Re: [PATCH net] r8169: fix operation under forced interrupt threading
To:     Serge Belyshev <belyshev@depni.sinp.msu.ru>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        David Miller <davem@davemloft.net>,
        Realtek linux nic maintainers <nic_swsd@realtek.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
References: <4d3ef84a-c812-5072-918a-22a6f6468310@gmail.com>
 <877drabmoq.fsf@depni.sinp.msu.ru>
From:   Heiner Kallweit <hkallweit1@gmail.com>
Message-ID: <c9cbe7ae-ca05-1462-3c6b-6582586f3857@gmail.com>
Date:   Wed, 28 Oct 2020 15:04:25 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.4.0
MIME-Version: 1.0
In-Reply-To: <877drabmoq.fsf@depni.sinp.msu.ru>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 28.10.2020 12:43, Serge Belyshev wrote:
> 
>> For several network drivers it was reported that using
>> __napi_schedule_irqoff() is unsafe with forced threading. One way to
>> fix this is switching back to __napi_schedule, but then we lose the
>> benefit of the irqoff version in general. As stated by Eric it doesn't
>> make sense to make the minimal hard irq handlers in drivers using NAPI
>> a thread. Therefore ensure that the hard irq handler is never
>> thread-ified.
>>
>> Fixes: 9a899a35b0d6 ("r8169: switch to napi_schedule_irqoff")
>> Link: https://lkml.org/lkml/2020/10/18/19
>> Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
>> ---
>>  drivers/net/ethernet/realtek/r8169_main.c | 8 ++++----
>>  1 file changed, 4 insertions(+), 4 deletions(-)
>>
>> diff --git a/drivers/net/ethernet/realtek/r8169_main.c b/drivers/net/ethernet/realtek/r8169_main.c
>> index 7d366b036..3b6ddc706 100644
>> --- a/drivers/net/ethernet/realtek/r8169_main.c
>> +++ b/drivers/net/ethernet/realtek/r8169_main.c
> ...
> 
> Hi!  This patch actually breaks r8169 with threadirqs on an old box
> where it was working before:
> 
> [    0.000000] DMI: Gigabyte Technology Co., Ltd. GA-MA790FX-DQ6/GA-MA790FX-DQ6, BIOS F7g 07/19/2010
> ...
> [    1.072676] r8169 0000:02:00.0 eth0: RTL8168b/8111b, 00:1a:4d:5d:6b:c3, XID 380, IRQ 18
> ...
> [    8.850099] genirq: Flags mismatch irq 18. 00010080 (eth0) vs. 00002080 (ahci[0000:05:00.0])
> 
> (error is reported to userspace, interface failed to bring up).
> Reverting the patch fixes the problem.
> 
Please provide the following info in addition:
- dmesg
- lspci -v
- cat /proc/interrupts

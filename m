Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C863E254916
	for <lists+netdev@lfdr.de>; Thu, 27 Aug 2020 17:20:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728169AbgH0PUu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Aug 2020 11:20:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58564 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728704AbgH0LdA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Aug 2020 07:33:00 -0400
Received: from mail-ed1-x529.google.com (mail-ed1-x529.google.com [IPv6:2a00:1450:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A759DC06123A
        for <netdev@vger.kernel.org>; Thu, 27 Aug 2020 04:07:01 -0700 (PDT)
Received: by mail-ed1-x529.google.com with SMTP id c8so4514014edn.8
        for <netdev@vger.kernel.org>; Thu, 27 Aug 2020 04:07:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=qlGHUWYwoYmSS9Td5ZA6Ok8wzL3FIbAQsVvmeGf568k=;
        b=aB7E7Yj7w0ZJ2YKcrfAg5b+XREY7tjMgMV6r0I51QIwWNMXqiUeQ38YLLDcm4DSeUj
         oRVlHihQadS/6yiEyQp33n4I9EcCHFlhkYW8/kITfVD8rgj/CnLJMNKYZOKrUZd+D1+9
         27vk4y6DSLSQndP34tHg6lgBIX1h9Ec/o8k9uPhIu+2nZOyGGSPqvrRObYnS3KxD8HZM
         jSOwhzA6KblhOp2UE06rFfwHbya0a2uqLkF2SETSY7aF/Q0Kx6PKHG69dWo42e93USJR
         OTRljzD9rfyOVJ5JZJfvtzVTC9ifXt1LwL9+Zau34GoteJ9TVzL77FEvFrLcTJ2x0EvQ
         efmQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=qlGHUWYwoYmSS9Td5ZA6Ok8wzL3FIbAQsVvmeGf568k=;
        b=LRbroT4FGi/mKsj8lLVYFccon5gwBKmPsX9epqXiTrOnjdK1nTMPFaxyWrumAmjdvt
         p+bxrWUJSBCMiPKYNnYPGVcQPBAG5rOoZQGb/yhr/zWBkE0RU5+JTY4ifvRx0DCWim64
         gApYJdkJ24S4sbCLG2lDSZbLc7Bv2DfbPQiWndEsOdibQjPhXfD/SiBcdSqEnG5jW2Is
         NAeuskjlnXy2yNzkPWmP/rrHEEIONglDXhTYiwB6PveTCc0cBu3BCSbsCmwk2Yh4U4cm
         xJT6vgI+aER0715IoacWOi/Xsg1oyZjFupJmVfKuM5s4ldVNHnlFU03MRx/1t8igSgZ6
         D+aQ==
X-Gm-Message-State: AOAM533veLTUvwPLxpUv7ekQ+FQfBif3m/+OTWW/jcZJFTAhhllWn5ld
        VvVogk7xshQYrophkiL9fRc=
X-Google-Smtp-Source: ABdhPJznWbUmO7DIKPAsDzU8dgchN3myRFa8FcuJuhInYsngw6VpA1rwbiOizjTC0xnWkw1lwiC3cw==
X-Received: by 2002:aa7:da82:: with SMTP id q2mr14941380eds.45.1598526417932;
        Thu, 27 Aug 2020 04:06:57 -0700 (PDT)
Received: from ?IPv6:2003:ea:8f23:5700:88d6:516:4510:4c1f? (p200300ea8f23570088d6051645104c1f.dip0.t-ipconnect.de. [2003:ea:8f23:5700:88d6:516:4510:4c1f])
        by smtp.googlemail.com with ESMTPSA id yh29sm1658501ejb.0.2020.08.27.04.06.57
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 27 Aug 2020 04:06:57 -0700 (PDT)
Subject: Re: powering off phys on 'ip link set down'
To:     Rasmus Villemoes <rasmus.villemoes@prevas.dk>,
        Network Development <netdev@vger.kernel.org>
Cc:     Lasse Klok Mikkelsen <Lasse.Klok@prevas.se>
References: <9e3c2b6e-b1f8-7e43-2561-30aa84d356c7@prevas.dk>
 <7a17486d-2fee-47cb-eddc-b000e8b6d332@gmail.com>
 <4adfeeab-937a-b722-6dd8-84c8a3efb8ac@prevas.dk>
From:   Heiner Kallweit <hkallweit1@gmail.com>
Message-ID: <565ef886-18a4-b5ed-9ba5-96c2198b0caa@gmail.com>
Date:   Thu, 27 Aug 2020 13:06:54 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.12.0
MIME-Version: 1.0
In-Reply-To: <4adfeeab-937a-b722-6dd8-84c8a3efb8ac@prevas.dk>
Content-Type: text/plain; charset=windows-1252
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 27.08.2020 13:00, Rasmus Villemoes wrote:
> On 27/08/2020 12.29, Heiner Kallweit wrote:
>> On 27.08.2020 12:08, Rasmus Villemoes wrote:
>>> Hi,
>>>
>>> We have a requirement that when an interface is taken down
>>> administratively, the phy should be powered off. That also works when
>>> the interface has link when the 'ip link set down ...' is run. But if
>>> there's no cable plugged in, the phy stays powered on (as can be seen
>>> both using phytool, and from the fact that a peer gets carrier once a
>>> cable is later plugged in).
>>>
>>> Is this expected behaviour? Driver/device dependent? Can we do anything
>>> to force the phy off?
>>>
>> This may be MAC/PHY-driver dependent. Which driver(s) do we talk about?
> 
> It's a Marvell 88e6250 switch (drivers/net/dsa/mv88e6xxx/).
> 
>> Also it may depend on whether Runtime PM is active for a PCI network
>> device. In addition WoL should be disabled.
> 
> The datasheet does mention WoL, but it's either not hooked up in the
> driver or at least default disabled, ethtool says
> 
>      Supports Wake-on: d
>      Wake-on: d
> 

By the way, which kernel version are you using?

> Thanks,
> Rasmus
> 


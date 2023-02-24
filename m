Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E9F696A231D
	for <lists+netdev@lfdr.de>; Fri, 24 Feb 2023 21:21:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229656AbjBXUVj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Feb 2023 15:21:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48816 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229446AbjBXUVi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Feb 2023 15:21:38 -0500
Received: from mail-wm1-x330.google.com (mail-wm1-x330.google.com [IPv6:2a00:1450:4864:20::330])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C397E16AE8
        for <netdev@vger.kernel.org>; Fri, 24 Feb 2023 12:21:35 -0800 (PST)
Received: by mail-wm1-x330.google.com with SMTP id p3-20020a05600c358300b003e206711347so239110wmq.0
        for <netdev@vger.kernel.org>; Fri, 24 Feb 2023 12:21:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=VhAihSXcGDe4OQNObCH0G3hSQytsdW3S/qs8PDbZK7E=;
        b=YOBtANwWoOg4Ev7XAKQzG6ckLFyIyWvtYDGX04F0RjpLCJIgOjkZjYB8aNfXl6Ia9J
         0nBo6bAvpqFd+T5e1y/uJmYCb6YA7updYNHD8vOmzDPMlwlDOrwtdfTcpBwwjgPAnaF2
         75mCUlrSjsnj1ODfGlObFdNqlMY2x6/lyNoM+nkPhWY8Jq+6LPZe2A4/maE68BZn8w1N
         CP/t7DqzEbnaA+pg2dxjYV6pXOXHRfhewSqIueCkiByq4NFMvj+0Je8DqeURs42sU7Nr
         Wz4uKhVDZisnde5V/Yk2zN0dzTZlf6wl2vcQ0/6/G1d7728rOAB5j8HcY2H92A8v7icV
         8QbQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=VhAihSXcGDe4OQNObCH0G3hSQytsdW3S/qs8PDbZK7E=;
        b=lKdMjG8ObT7nSmZp0fHXxGz1KRlbaPXR2zcvqyuc+p72Mt4z3PvCbZN6eXpRlLxn4x
         Q2Uwz72sI62CdxWJRDoQS4n2beeM52+FaTNrohljZ2/xqKSwY3IJnkAdEcrIx3hnKzTx
         ysioA1InpdYdnUVeJkRxce/S0Ke/RLnxHHuRlrpvaRC8CxBTJLNfbZSdraBg4wAYemIx
         DSwWC+9gP5+O1lCiNn2jOycXffVU8TcRwx7hyZl5iZ3rG0zQTZVr2eSrqrV/y9XnozzI
         PTb7c710TwZfy2xW/WOraHdLW9wi0KonPR7gQa16DDDtE6x6W0uHMLTvOWHfA3GXIofv
         eqvg==
X-Gm-Message-State: AO0yUKX2OPgfBUw5ZlJMLT19RUMiwnhZGPPT8yGKRrD5CMNN5nE1ASq5
        z7Gtsh7u14gJRiJQpGJ4cfM=
X-Google-Smtp-Source: AK7set931ehdQ+jrqNZFOJNqacCsl11YrSc1OKub1viMnb6Ph9AW4xPEIwynir4PLUxJgdGdXIG53Q==
X-Received: by 2002:a05:600c:491f:b0:3ea:bc08:42ad with SMTP id f31-20020a05600c491f00b003eabc0842admr4799224wmp.2.1677270094004;
        Fri, 24 Feb 2023 12:21:34 -0800 (PST)
Received: from ?IPV6:2a01:c23:b8b4:b000:4112:2010:ca46:c1a4? (dynamic-2a01-0c23-b8b4-b000-4112-2010-ca46-c1a4.c23.pool.telefonica.de. [2a01:c23:b8b4:b000:4112:2010:ca46:c1a4])
        by smtp.googlemail.com with ESMTPSA id p13-20020a1c544d000000b003e208cec49bsm9302130wmi.3.2023.02.24.12.21.33
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 24 Feb 2023 12:21:33 -0800 (PST)
Message-ID: <92181e0e-3ca0-b19c-71f3-607fbfdc40a3@gmail.com>
Date:   Fri, 24 Feb 2023 21:21:32 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.8.0
Subject: Re: 4-port ASMedia/RealTek RTL8125 2.5Gbps NIC freezes whole system
Content-Language: en-US
To:     fk1xdcio@duck.com, netdev@vger.kernel.org
References: <AF9C0500-2909-4FF4-8E4E-3BAD8FD8AA14.1@smtp-inbound1.duck.com>
From:   Heiner Kallweit <hkallweit1@gmail.com>
In-Reply-To: <AF9C0500-2909-4FF4-8E4E-3BAD8FD8AA14.1@smtp-inbound1.duck.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 24.02.2023 15:37, fk1xdcio@duck.com wrote:
> I hope this is the correct place to ask this(?). I'm not sure if my large attachments will come through; this is my first attempt.
> 
> I'm having problems getting this 4-port 2.5Gbps NIC to be stable. I have tried on multiple different physical systems both with Xeon server and i7 workstation chipsets and it behaves the same way on everything. Testing with latest Arch Linux and kernels 6.1, 6.2, and 5.15. I'm using the kernel default r8169 driver.
> 
> The higher the load on the NIC the more likely the whole system freezes hard. Everything freezes including my serial console, SysRq doesn't work, even the motherboard hardware reset switch doesn't work(!). I have to cut power to the system to reset it.
> 
> Disabling IOMMU is more stable but doesn't fix the issue. ASPM doesn't work correctly on this card either despite the ASMedia 1812 supposedly supporting it (lots of corrected PCIe errors). Enabling or disabling ASPM makes no difference.
> 
> "SSU-TECH" (generic/counterfeit?) 4-port 2.5Gbps PCIe x4 card
>   ASMedia ASM1812 PCIe switch (driver: pcieport)
>   RTL8125BG x4 (driver: r8169)
> 
> I have tested with a normal network configuration consisting of multiple machines and also with lookback cables plugging the card ports in to itself.
> 
> I have attached the scripts I use with the loopback cables (crashsys.sh), lspci, and dmesg.
> 
> System freezes almost immediately with:
>   3,1266,4284361895,-;pcieport 0000:04:02.0: Unable to change power state from D3hot to D0, device inaccessible
>    SUBSYSTEM=pci
>    DEVICE=+pci:0000:04:02.0
> 
> If I set permanent D0 mode (power/control=on) then the error is different when the system freezes:
>   r8169 0000:0d:00.0 enp13s0: rtl_chipcmd_cond == 1 (loop: 100, delay: 100).
> 
> Is there anything I can do to get more debugging information? The system locks so hard that I haven't gotten much so far. It's unclear if the problem is happening in the pcieport driver, r8169, or somewhere else.

The network driver shouldn't be able to freeze the system. You can test whether vendor driver r8125 makes a difference.
This should provide us with an idea whether the root cause is at a lower level.

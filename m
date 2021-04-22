Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E33FF3684E2
	for <lists+netdev@lfdr.de>; Thu, 22 Apr 2021 18:32:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237829AbhDVQcj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Apr 2021 12:32:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35470 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236662AbhDVQch (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 22 Apr 2021 12:32:37 -0400
Received: from mail-pl1-x631.google.com (mail-pl1-x631.google.com [IPv6:2607:f8b0:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8D536C06174A
        for <netdev@vger.kernel.org>; Thu, 22 Apr 2021 09:32:02 -0700 (PDT)
Received: by mail-pl1-x631.google.com with SMTP id h20so23815222plr.4
        for <netdev@vger.kernel.org>; Thu, 22 Apr 2021 09:32:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=n17Nd6KbKM4TIRn14bYoGcC2Nk05kNj6H9ojCJ9DAHE=;
        b=U0mFOsojRo4oa8OSkS+lD3n2fghtKz+MD+LYekVlotxT/VqbuxwPWQeMb11R1pSmbM
         pocX4TQ80Qx8017VHvIsYUxxv5gH7gK2Uok+zfDK3SUbndudq3DyvSEJVu3k8fmOLcUS
         UBFNytHDmez1ljB1hc53wMps0SKPoN6JuSicHuj8Raqk1jDoCRT1iZZfrZX3oU3Ixu+Q
         4EiUXjKEX3Z0PdSGQ46+US5k/ZS9gwbf63coqHflUMZIq4ROEy+Dcd2ZzYwiZvTJyWxp
         H1RYztkAkzQfFVgp6pyT9wZneY/E3APMxzerLYonJOesa7fewkeQqObJmBll5mpSnvSE
         Ek7w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=n17Nd6KbKM4TIRn14bYoGcC2Nk05kNj6H9ojCJ9DAHE=;
        b=DkVIQeQdzeX/YOxaqdNOSBKtfs/eyuQScxCki6nipo4tMG9s5nlRn/BwaXz2/AZIct
         OUmb60VayizyJJ6tDERGvOzah3dncvc9+We9q3OIhhnC0UJMI0e/x57ef7svAgbdrRNv
         7mPH+7dzizqR1hvFuvDgrIebQ/Kjb0K6tfQu2luknPd2ptND7KG32Q4tI+E0+5qG1CS7
         oNq8TrLsAAkHRHb6ZyXVaXmU6Mq3DLNp+0Zr/+7RDN75S6ft2bz0dhVlQzBvQl6wgfqr
         le8Ge9xBZIcCKM4L4byXrEkJaLsy5Uuo79cmCHolf6If4+dTIw95zcuKzt+rYpskjGzt
         StNw==
X-Gm-Message-State: AOAM533RROihk71/hn7Ne2APSs7RB7Ec3NZCCHuBy+sMjSShqHvWAPLc
        G5d6k+8vopegr3jXaGgZpKUO7/1njho=
X-Google-Smtp-Source: ABdhPJyGDhzQ9gwdRklp98hqco248CD/KsQ0+P93dgkujxyxKJ5dvPTyWKqkqYwqjn0j6KVvtVDIqQ==
X-Received: by 2002:a17:903:114:b029:eb:3963:9d1a with SMTP id y20-20020a1709030114b02900eb39639d1amr4441779plc.79.1619109120946;
        Thu, 22 Apr 2021 09:32:00 -0700 (PDT)
Received: from [10.230.29.202] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id b5sm2795609pgb.0.2021.04.22.09.31.54
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 22 Apr 2021 09:31:59 -0700 (PDT)
Subject: Re: [RFC net-next] net: stmmac: should not modify RX descriptor when
 STMMAC resume
To:     Joakim Zhang <qiangqing.zhang@nxp.com>, peppe.cavallaro@st.com,
        alexandre.torgue@foss.st.com, joabreu@synopsys.com,
        davem@davemloft.net, kuba@kernel.org, mcoquelin.stm32@gmail.com,
        andrew@lunn.ch
Cc:     linux-imx@nxp.com, jonathanh@nvidia.com, treding@nvidia.com,
        netdev@vger.kernel.org
References: <20210419115921.19219-1-qiangqing.zhang@nxp.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <1b2dd47e-184a-2dea-f62d-5417192f2710@gmail.com>
Date:   Thu, 22 Apr 2021 09:31:51 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Firefox/78.0 Thunderbird/78.9.0
MIME-Version: 1.0
In-Reply-To: <20210419115921.19219-1-qiangqing.zhang@nxp.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 4/19/2021 4:59 AM, Joakim Zhang wrote:
> When system resume back, STMMAC will clear RX descriptors:
> stmmac_resume()
> 	->stmmac_clear_descriptors()
> 		->stmmac_clear_rx_descriptors()
> 			->stmmac_init_rx_desc()
> 				->dwmac4_set_rx_owner()
> 				//p->des3 |= cpu_to_le32(RDES3_OWN | RDES3_BUFFER1_VALID_ADDR);
> It only assets OWN and BUF1V bits in desc3 field, doesn't clear desc0/1/2 fields.
> 
> Let's take a case into account, when system suspend, it is possible that
> there are packets have not received yet, so the RX descriptors are wrote
> back by DMA, e.g.
> 008 [0x00000000c4310080]: 0x0 0x40 0x0 0x34010040
> 
> When system resume back, after above process, it became a broken
> descriptor:
> 008 [0x00000000c4310080]: 0x0 0x40 0x0 0xb5010040
> 
> The issue is that it only changes the owner of this descriptor, but do nothing
> about desc0/1/2 fields. The descriptor of STMMAC a bit special, applicaton
> prepares RX descriptors for DMA, after DMA recevie the packets, it will write
> back the descriptors, so the same field of a descriptor have different
> meanings to application and DMA. It should be a software bug there, and may
> not easy to reproduce, but there is a certain probability that it will
> occur.
> 
> Commit 9c63faaa931e ("net: stmmac: re-init rx buffers when mac resume back") tried
> to re-init desc0/desc1 (buffer address fields) to fix this issue, but it
> is not a proper solution, and made regression on Jetson TX2 boards.
> 
> It is unreasonable to modify RX descriptors outside of stmmac_rx_refill() function,
> where it will clear all desc0/desc1/desc2/desc3 fields together.
> 
> This patch removes RX descriptors modification when STMMAC resume.

Your patch makes sense to me, however the explanation seems to highlight
that you may have a few cases to consider while you suspend.

Usually you will turn off the RX DMA such that DMA into DRAM stops
there, this may not an entirely atomic operation as the MAC may have to
wait for a certain packet boundary to be crossed, that could leave you
with descriptors in 3 states I believe:

- descriptor is ready for RX DMA to process and is owned by RX DMA, no
need to do anything

- descriptor has been fully consumed by the CPU and is owned by the CPU,
CPU should be putting the descriptor back on the ring and relinquish
ownership

- descriptor has been written to DRAM but not processed by CPU, and it
should be put back on the ring for RX DMA to use it

Out of suspend, don't you need to deal with descriptors in cases 2 and 3
somehow? Does the DMA skip over descriptors that are still marked as
owned by the CPU or does it stop/stall?
-- 
Florian

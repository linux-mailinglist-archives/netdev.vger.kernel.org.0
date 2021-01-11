Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3F14D2F165A
	for <lists+netdev@lfdr.de>; Mon, 11 Jan 2021 14:52:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387849AbhAKNvb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Jan 2021 08:51:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57500 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387834AbhAKNv2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 Jan 2021 08:51:28 -0500
Received: from mail-wr1-x42c.google.com (mail-wr1-x42c.google.com [IPv6:2a00:1450:4864:20::42c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0798FC061786
        for <netdev@vger.kernel.org>; Mon, 11 Jan 2021 05:50:48 -0800 (PST)
Received: by mail-wr1-x42c.google.com with SMTP id t16so16533580wra.3
        for <netdev@vger.kernel.org>; Mon, 11 Jan 2021 05:50:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=oDzybAPpq9OLiBxkNJm8T2EB85HkkF7WtXv5U+4ebOg=;
        b=G/76C+Yn3Qqckr8KqV5Z+4Wr7FBCMqWiwU8N422mcz9IVb/PQp6rAlBJ9x6CfDhn5l
         4dCTypJRE6pAk97iPS8Rk1g/35rWN4+QRHyMenMWdXGG8e2IWYMav2D+vSLglJCP9ezs
         nKW17I9XBgGxF/5MdAxajJMu9jxjMUKoxObTmyoL4X3HskibK3hwRWX/lcDxVImSie4U
         18zXZm7L2qECqwCUEhR+oqR8y3rXs6plH5HfAXNw6pL68BIFTito2qtrd+0HG4358FZE
         frRDoX+sMXa7r/oIBT+sDHlnPa4y5Nv9uowIZFQJmhUibOiiDiZ5yvMi0pk6WUdQYIj4
         xuuQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=oDzybAPpq9OLiBxkNJm8T2EB85HkkF7WtXv5U+4ebOg=;
        b=n+MHgVIoniakihiP/JzfOAGCFZHMohZayPVnh5HwfJQBp6820OyrXtodJJ72u0PRqD
         HaKq2B86Yc708JrN9npJzseRIot2vOBRf/dz44JEyLHE44EAxCnhJ7PLSz8V4cWGKRVZ
         AcRTl5p0LOlo5kgJAZn2Mz6mej4IrOmchT8gGaVXJj+M0m3v9sMEPO5qlkhyhqT4/nsy
         Ve3X5E5iJyYvGffpYLOtDYnuoXjH2JS/llbCrUfxYoUUpXUPlrliCrGotQz2oZlA06Kt
         pvcnMcZqGOIp/qz6t4U9BeeHIqKIvBScJ4twQfOnnJuT1FeUuRqVpXbqj0UZigSMWnG3
         ggwg==
X-Gm-Message-State: AOAM533BhWosSPI7o6L0A1zOuKCgG2bd5hneSgfC96BHcJ7rNgbRG/IM
        HUTxony9tFw1lBe0ZokGRaKofkw5wNw=
X-Google-Smtp-Source: ABdhPJyA9mrkCOEokKdIIZauUp8SIaCKeo5A/TI7tiFmA3wVA5OLBbJskCRgM9MK0zfcZ37gR/SuJQ==
X-Received: by 2002:adf:90e3:: with SMTP id i90mr17080911wri.248.1610373046722;
        Mon, 11 Jan 2021 05:50:46 -0800 (PST)
Received: from ?IPv6:2003:ea:8f06:5500:70c5:7cc:8644:5b6d? (p200300ea8f06550070c507cc86445b6d.dip0.t-ipconnect.de. [2003:ea:8f06:5500:70c5:7cc:8644:5b6d])
        by smtp.googlemail.com with ESMTPSA id i11sm21616504wmd.47.2021.01.11.05.50.45
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 11 Jan 2021 05:50:46 -0800 (PST)
Subject: Re: [PATCH net-next] net: ks8851: Connect and start/stop the internal
 PHY
To:     Marek Vasut <marex@denx.de>, netdev@vger.kernel.org
Cc:     Andrew Lunn <andrew@lunn.ch>, Lukas Wunner <lukas@wunner.de>
References: <20210111125337.36513-1-marex@denx.de>
 <a8eb8186-cde4-19ab-5b3c-e885e11106cf@gmail.com>
 <8c46baf2-28c9-190a-090c-c2980842b78e@denx.de>
From:   Heiner Kallweit <hkallweit1@gmail.com>
Message-ID: <aeb906d3-be61-c3cd-4ec0-88e66f384369@gmail.com>
Date:   Mon, 11 Jan 2021 14:50:42 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.0
MIME-Version: 1.0
In-Reply-To: <8c46baf2-28c9-190a-090c-c2980842b78e@denx.de>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 11.01.2021 14:38, Marek Vasut wrote:
> On 1/11/21 2:26 PM, Heiner Kallweit wrote:
> [...]
> 
>> LGTM. When having a brief look at the driver I stumbled across two things:
>>
>> 1. Do MAC/PHY support any pause mode? Then a call to
>>     phy_support_(a)sym_pause() would be missing.
> 
> https://ww1.microchip.com/downloads/en/DeviceDoc/KSZ8851-16MLL-Single-Port-Ethernet-MAC-Controller-with-8-Bit-or-16-Bit-Non-PCI-Interface-DS00002357B.pdf
> page 64
> 
> https://www.mouser.com/datasheet/2/268/ksz8851-16mll_ds-776208.pdf
> page 65
> 
> The later is more complete.
> 
> Apparently it does support pause.
> 
>> 2. Don't have the datasheet, but IRQ_LCI seems to be the link change
>>     interrupt. So far it's ignored by the driver. You could configure
>>     it and use phy_mac_interrupt() to operate the internal PHY in
>>     interrupt mode.
> 
> That's only for link state change, shouldn't the PHY interrupt trigger on other things as well ?

No, it's sufficient if the interrupt can signal link state change.
In r8169 I have exactly that case.

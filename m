Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 05E9965F040
	for <lists+netdev@lfdr.de>; Thu,  5 Jan 2023 16:39:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234402AbjAEPif (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Jan 2023 10:38:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58556 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232803AbjAEPiN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 Jan 2023 10:38:13 -0500
Received: from mail-wm1-x336.google.com (mail-wm1-x336.google.com [IPv6:2a00:1450:4864:20::336])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 992724D70C;
        Thu,  5 Jan 2023 07:38:12 -0800 (PST)
Received: by mail-wm1-x336.google.com with SMTP id l26so26711128wme.5;
        Thu, 05 Jan 2023 07:38:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=JonkN/5yYHnucf2q3jhmBsrrdYdJsV4jujR0sLg/+OQ=;
        b=lRWu5J2E6bTiOO97Xz7WyLNGbXxJXrHQpicJ5WYrI9O6zTbgogee3hF7N6/AQ7UeQj
         c3mTqFK5DBYelb6mMNy4EhH/Qxa2sekzj5giEceLkjCrSJhOwZsF1D+dLgVvbnIcmZP2
         Njy3iGUmW1fxm3+W2PYGsN/2Q5ZP7Jwioy25ZYrg1/+aAIyaK6NAsdr8eJ5SnZJwWdQ4
         /8ciPe1FMvsN3j1thtnrvKfC0k8Dtpl1M0yOk49DZx/ma758j1XwR5FmJHl9bo4c4HkB
         olyWtfD9p5hdhbNhJD/InlNXUFhkuMehtmPppzEyrepUV3J565x0be5uxDJkSts0IOxv
         3P/w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=JonkN/5yYHnucf2q3jhmBsrrdYdJsV4jujR0sLg/+OQ=;
        b=LD9qwEGdrF6bxBC7ydLWyLmWZoMeeY4VOnksUwKYlyXMVkCrplxvxNVXTSGCxRExZ3
         KSTiphph6RS+6iitrHK0MAp4HeyYioa1G0CSx5Ms8Poqk48gIZkOL7VB6AoEdwYUzP/H
         /kM2Qroykx/q3ZwgLBprMp39I5zaRSNusqvjUykOGXsKojuS4tM6cP8iPIIwbR4NPrE6
         WoNdwZkqwbfiNNbptYUAyTyUW4VDTZB6LlSHd7MSM0nxVZeB/Wno8ZfCahfQMBAdsZ/g
         kWFFBjQrSmZN9ldL7JnLyiCbwjRDEkhq0+7jxh9sWPDFGWCkD0crjh0rT36e9rVmhLHS
         h0EA==
X-Gm-Message-State: AFqh2kqx6yb/faYlR7gyzobjyL9W/n751ovcs260nRYicFzT8adZw1BD
        iT2NIllD/U6FhZ4Ja8bz++w=
X-Google-Smtp-Source: AMrXdXskES35BGhVDGhNRFrHW7Srev49jb9drqf1nYZ5w0pgiciJYQhEhWHVVLIIRYupFQrd8EPrpg==
X-Received: by 2002:a05:600c:22ca:b0:3d1:ebdf:d586 with SMTP id 10-20020a05600c22ca00b003d1ebdfd586mr36666492wmg.29.1672933091073;
        Thu, 05 Jan 2023 07:38:11 -0800 (PST)
Received: from [192.168.1.50] ([79.119.240.114])
        by smtp.gmail.com with ESMTPSA id p3-20020a05600c358300b003d1f2c3e571sm3152999wmq.33.2023.01.05.07.38.09
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 05 Jan 2023 07:38:10 -0800 (PST)
Message-ID: <7b3e4eaf-258f-bf5c-80f8-68d04d285235@gmail.com>
Date:   Thu, 5 Jan 2023 17:38:08 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.3.3
Subject: Re: [RFC PATCH v1 19/19] rtw88: Add support for the SDIO based
 RTL8821CS chipset
To:     Sascha Hauer <sha@pengutronix.de>
Cc:     Chris Morgan <macroalpha82@gmail.com>,
        Martin Blumenstingl <martin.blumenstingl@googlemail.com>,
        linux-wireless@vger.kernel.org,
        Yan-Hsuan Chuang <tony0620emma@gmail.com>,
        Kalle Valo <kvalo@kernel.org>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        linux-mmc@vger.kernel.org, Nitin Gupta <nitin.gupta981@gmail.com>,
        Neo Jou <neojou@gmail.com>, Pkshih <pkshih@realtek.com>,
        Jernej Skrabec <jernej.skrabec@gmail.com>
References: <20221227233020.284266-1-martin.blumenstingl@googlemail.com>
 <20221227233020.284266-20-martin.blumenstingl@googlemail.com>
 <63b4b3e1.050a0220.791fb.767c@mx.google.com>
 <0acf173d-a425-dcca-ad2f-f0f0f13a9f5e@gmail.com>
 <20230105080142.GA15042@pengutronix.de>
Content-Language: en-US
From:   Bitterblue Smith <rtl8821cerfe2@gmail.com>
In-Reply-To: <20230105080142.GA15042@pengutronix.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 05/01/2023 10:01, Sascha Hauer wrote:
> On Wed, Jan 04, 2023 at 09:59:35PM +0200, Bitterblue Smith wrote:
>> On 04/01/2023 01:01, Chris Morgan wrote:
>>> On Wed, Dec 28, 2022 at 12:30:20AM +0100, Martin Blumenstingl wrote:
>>>> Wire up RTL8821CS chipset support using the new rtw88 SDIO HCI code as
>>>> well as the existing RTL8821C chipset code.
>>>>
>>>
>>> Unfortunately, this doesn't work for me. I applied it on top of 6.2-rc2
>>> master and I get errors during probe (it appears the firmware never
>>> loads).
>>>
>>> Relevant dmesg logs are as follows:
>>>
>>> [    0.989545] mmc2: new high speed SDIO card at address 0001
>>> [    0.989993] rtw_8821cs mmc2:0001:1: Firmware version 24.8.0, H2C version 12
>>> [    1.005684] rtw_8821cs mmc2:0001:1: sdio write32 failed (0x14): -110
>>> [    1.005737] rtw_8821cs mmc2:0001:1: sdio read32 failed (0x1080): -110
>>> [    1.005789] rtw_8821cs mmc2:0001:1: sdio write32 failed (0x11080): -110
>>> [    1.005840] rtw_8821cs mmc2:0001:1: sdio read8 failed (0x3): -110
>>> [    1.005920] rtw_8821cs mmc2:0001:1: sdio read8 failed (0x1103): -110
>>> [    1.005998] rtw_8821cs mmc2:0001:1: sdio read32 failed (0x80): -110
>>> [    1.006078] rtw_8821cs mmc2:0001:1: sdio read32 failed (0x1700): -110
>>>
>>> The error of "sdio read32 failed (0x1700): -110" then repeats several
>>> hundred times, then I get this:
>>>
>>> [    1.066294] rtw_8821cs mmc2:0001:1: failed to download firmware
>>> [    1.066367] rtw_8821cs mmc2:0001:1: sdio read16 failed (0x80): -110
>>> [    1.066417] rtw_8821cs mmc2:0001:1: sdio read8 failed (0x100): -110
>>> [    1.066697] rtw_8821cs mmc2:0001:1: failed to setup chip efuse info
>>> [    1.066703] rtw_8821cs mmc2:0001:1: failed to setup chip information
>>> [    1.066839] rtw_8821cs: probe of mmc2:0001:1 failed with error -16
>>>
>>> The hardware I am using is an rtl8821cs that I can confirm was working
>>> with a previous driver.
>>>
>>> Thank you.
>>>
>> The USB-based RTL8811CU also doesn't work, with suspiciously similar
>> errors:
>>
>> Dec 25 21:43:37 home kernel: rtw_8821cu 1-2:1.0: Firmware version 24.11.0, H2C version 12
>> Dec 25 21:43:37 home kernel: rtw_8821cu 1-2:1.0 wlp0s20f0u2: renamed from wlan0
>> Dec 25 21:43:40 home kernel: rtw_8821cu 1-2:1.0: read register 0x5 failed with -110
> 
> Is this the very first register access or are there other register
> accesses before that actually do work?
> 
> Sascha
> 
It's not the first register access. rtw_mac_power_switch() runs a few
times before things fail.

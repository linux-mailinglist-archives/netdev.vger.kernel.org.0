Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0FA0262FAB7
	for <lists+netdev@lfdr.de>; Fri, 18 Nov 2022 17:47:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242223AbiKRQrT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Nov 2022 11:47:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33728 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242011AbiKRQrS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Nov 2022 11:47:18 -0500
Received: from mail-lf1-x133.google.com (mail-lf1-x133.google.com [IPv6:2a00:1450:4864:20::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B39A41EEE6
        for <netdev@vger.kernel.org>; Fri, 18 Nov 2022 08:47:16 -0800 (PST)
Received: by mail-lf1-x133.google.com with SMTP id p8so9070212lfu.11
        for <netdev@vger.kernel.org>; Fri, 18 Nov 2022 08:47:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to:subject
         :user-agent:mime-version:date:message-id:from:to:cc:subject:date
         :message-id:reply-to;
        bh=JjS4gImtGAJJbWB/0EDokdPSqW8A0zuYR+TtXk+h7bA=;
        b=kDciKdVGHdmiJlolrTF6PbQo6D/1op1CjAitUOm47eVwIp7q548L2ZgzwK/JRH9H9O
         OACMJe6gV1S5iJy+Y3XmYIrM/4lFBav6Qjr0Nam47w2I3MN7RarUKS5ZhpPE1zHO6JWn
         576QQkfZaQBkIpZZBdoL788i3/OUPIGmtG8dFq1+SVDBpPLJ8OBiZHMAw4WLOYbyQnFu
         f13d2BBVSQZUTgzXg3ac6cDQJgUVVnGZInsmPH4WQwdEG54ufYeWBkK/pU5wMkvArKUF
         ReR2F6BHOYDKcWMclEOGGT3rWIxXgYZHKf2C2e16VU5kFHmNW57/ZMxy+Qfzc+qCpc89
         eANg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to:subject
         :user-agent:mime-version:date:message-id:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=JjS4gImtGAJJbWB/0EDokdPSqW8A0zuYR+TtXk+h7bA=;
        b=7aUcx0w4S6mUpJ5DajHav5aTaeLTVXGNcUadpfyUMuN1nkubfy2T7V55Uxs5qOOPLH
         teWwFNB2zz5ti5evFhDDYdXn05vXSnb9EwpqilpPFgW4xkitRypNcom0F5l/dslx4f0V
         t5zH6eF63TDh6zTAodhP6vyjVKfnY+VAhNVRjOpNPjonOrjCGeUU6OxQTMOmX28mSVC3
         +afYvngaHWtJ+iZ9hTP+Hy7Jw5bR8IUlsw/ll44u3nfyZ+SqDVwz49JiwhAivX5ongMl
         YVvGd0snYxx9O7zFDDKhgH5QPrvmTxz4P5LZqZTho4X/CxyPETqVJ0r5wthVpgLocWtF
         xB2Q==
X-Gm-Message-State: ANoB5pmlt2tcZKi0rtK+lft9uJ+m0qX5WPC1zD0ae4HYH/Ya7PS1jz2y
        eaKW9pHRc5N+cbt951wdqapEWQ==
X-Google-Smtp-Source: AA0mqf64S2QnERSJTTT5QfDNrtKoGh+bzu+VoYTnFpf/BrzC3hbdxo8BS7xLLf52YaQigOAu/EHglg==
X-Received: by 2002:ac2:4e0a:0:b0:4a2:2aab:5460 with SMTP id e10-20020ac24e0a000000b004a22aab5460mr2546386lfr.62.1668790035078;
        Fri, 18 Nov 2022 08:47:15 -0800 (PST)
Received: from [192.168.31.208] ([194.29.137.22])
        by smtp.gmail.com with ESMTPSA id v20-20020a2e9614000000b0026dced9840dsm693266ljh.61.2022.11.18.08.47.13
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 18 Nov 2022 08:47:14 -0800 (PST)
Message-ID: <4592f87a-bb61-1c28-13f0-d041a6e7d3bf@linaro.org>
Date:   Fri, 18 Nov 2022 17:47:12 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.4.2
Subject: Re: [PATCH v2] brcmfmac: Add support for BCM43596 PCIe Wi-Fi
To:     Kalle Valo <kvalo@kernel.org>,
        =?UTF-8?Q?Alvin_=c5=a0ipraga?= <ALSI@bang-olufsen.dk>
Cc:     Linus Walleij <linus.walleij@linaro.org>,
        Hector Martin <marcan@marcan.st>,
        "~postmarketos/upstreaming@lists.sr.ht" 
        <~postmarketos/upstreaming@lists.sr.ht>,
        "martin.botka@somainline.org" <martin.botka@somainline.org>,
        "angelogioacchino.delregno@somainline.org" 
        <angelogioacchino.delregno@somainline.org>,
        "marijn.suijten@somainline.org" <marijn.suijten@somainline.org>,
        "jamipkettunen@somainline.org" <jamipkettunen@somainline.org>,
        Arend van Spriel <aspriel@gmail.com>,
        Franky Lin <franky.lin@broadcom.com>,
        Hante Meuleman <hante.meuleman@broadcom.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, Marek Vasut <marex@denx.de>,
        "Zhao, Jiaqing" <jiaqing.zhao@intel.com>,
        "Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>,
        Soon Tak Lee <soontak.lee@cypress.com>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "brcm80211-dev-list.pdl@broadcom.com" 
        <brcm80211-dev-list.pdl@broadcom.com>,
        "SHA-cyfmac-dev-list@infineon.com" <SHA-cyfmac-dev-list@infineon.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <20220921001630.56765-1-konrad.dybcio@somainline.org>
 <83b90478-3974-28e6-cf13-35fc4f62e0db@marcan.st>
 <13b8c67c-399c-d1a6-4929-61aea27aa57d@somainline.org>
 <0e65a8b2-0827-af1e-602c-76d9450e3d11@marcan.st>
 <7fd077c5-83f8-02e2-03c1-900a47f05dc1@somainline.org>
 <CACRpkda3uryD6TOEaTi3pPX5No40LBWoyHR4VcEuKw4iYT0dqA@mail.gmail.com>
 <20220922133056.eo26da4npkg6bpf2@bang-olufsen.dk> <87sfke32pc.fsf@kernel.org>
From:   Konrad Dybcio <konrad.dybcio@linaro.org>
In-Reply-To: <87sfke32pc.fsf@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 26/09/2022 11:27, Kalle Valo wrote:
> Alvin Šipraga <ALSI@bang-olufsen.dk> writes:
> 
>> On Thu, Sep 22, 2022 at 03:02:12PM +0200, Linus Walleij wrote:
>>> On Thu, Sep 22, 2022 at 12:21 PM Konrad Dybcio
>>> <konrad.dybcio@somainline.org> wrote:
>>>
>>>> Also worth noting is the 'somc' bit, meaning there are probably *some* SONY
>>>> customizations, but that's also just a guess.
>>>
>>> What I have seen from BRCM customizations on Samsung phones is that
>>> the per-device customization of firmware seems to involve the set-up of
>>> some GPIO and power management pins. For example if integrated with
>>> an SoC that has autonomous system resume, or if some GPIO line has
>>> to be pulled to enable an external regulator or PA.
>>
>> At least with Infineon (formerly Cypress), as a customer you might get a
>> private firmware and this will be maintained internally by them on a
>> separate customer branch. Any subsequent bugfixes or feature requests
>> will usually be applied to that customer branch and a new firmware built
>> from it. I think their internal "mainline" branch might get merged into
>> the customer branches from time to time, but this seems to be done on an
>> ad-hoc basis. This is our experience at least.
>>
>> I would also point out that the BCM4359 is equivalent to the
>> CYW88359/CYW89359 chipset, which we are using in some of our
>> products. Note that this is a Cypress chipset (identifiable by the
>> Version: ... (... CY) tag in the version string). But the FW Konrad is
>> linking appears to be for a Broadcom chipset.
>>
>> FYI, here's a publicly available set of firmware files for the '4359:
>>
>> https://github.com/NXP/imx-firmware/tree/master/cyw-wifi-bt/1FD_CYW4359
>>
>> Anyway, I would second Hector's suggestion and make this a separate FW.
> 
> I also recommend having a separate firmware filename. Like Hector said,
> it's easy to have a symlink in userspace if same binary can be used.
So, I dusted off this patch and tried to change the fw name, only to 
discover that the BRCM_PCIE_43596_DEVICE_ID is equal to 
CY_PCIE_89459_DEVICE_ID, (which btw uses 4355/89459 fw), but then it 
makes the driver expect 4359/9 based on rev matching, so... the 43596 
chip ID may be a lie? Or at least for the one used in my particular 
device? I'm beyond confused now..

I can think of a couple of hacky ways to force use of 43596 fw, but I 
don't think any would be really upstreamable..

Any thoughts?

Konrad

Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 28EF2250114
	for <lists+netdev@lfdr.de>; Mon, 24 Aug 2020 17:27:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728092AbgHXP1X (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Aug 2020 11:27:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42892 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727024AbgHXP1J (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Aug 2020 11:27:09 -0400
Received: from mail-lj1-x243.google.com (mail-lj1-x243.google.com [IPv6:2a00:1450:4864:20::243])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BDCC1C061573;
        Mon, 24 Aug 2020 08:27:08 -0700 (PDT)
Received: by mail-lj1-x243.google.com with SMTP id h19so10118610ljg.13;
        Mon, 24 Aug 2020 08:27:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=sZNoB46D8/M/M2PgyVIiT6V2NCFpqgPFmRkE3BbQYY0=;
        b=sFvK/cjqd0IY2FPppcw4ggSbTyzS+/bWDuEn6APnjzaEMODweGr843dqvGmIuZ+7+l
         gh06YDRForm905ZwwSXfCS10xvIyJHfBRec0N9sQKOlmpvcQiDXtyT/bqdhRpw7tZUNu
         UEt8sEEUrr11VVRAa01f+JHkf5pvNVeBCA7po2V2tGY66x0vz7fDMP2/dIH8JrUq37HC
         8bfccDyUTlVyGazDcn+uLQRca/72M8adtNfMbKh3TutR5L2eUnXkaE1OEV1wT1R0bjyc
         7Ir8HxkHJ7jEa/cc/qgxI3W57DzAosbcngWFKAECdSjK8/+4rinCdsDecBnH4RjzY/1q
         m2Rg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=sZNoB46D8/M/M2PgyVIiT6V2NCFpqgPFmRkE3BbQYY0=;
        b=gGRWGha3WcfILFzg2rb2LW8XxMEg1iMfsXG/iR/0/4sT+iJ/tG3o7xZXyobYoqzMyd
         aSlPAP3eTM52Yu1MBKKjL4alqscKJKLn4Q9Lh77WT1xOb+Uhus1AESL7jMytx8OKtPiS
         +m7Q+b/wZtLo9YfJkHirxdGUL1hw6PpxetPl+2o0sukiWSSnc0qCI38Uh/fZH87QugCe
         tF/LxxCMGJQ5DopjVysOE7WTfv6Re9BH4g6UacM/uGoUXz/ULsVva8VlHSVwas9Gmk/j
         Ug5wy5UXaWKbaYt4KzRrBLI2+mGOtKoZ+0E73lt/8+tB99JxrgVxl3E9cwyNlkrY0hxM
         qmCA==
X-Gm-Message-State: AOAM530UWit5etDGObjrMvo7RV5hh8UXG9DQHwJVpFJSLfCpVQUNoq0/
        klZ/GqYQRnMyG2FFR+iAy24xniYdYmk=
X-Google-Smtp-Source: ABdhPJwS3dpy3Zm6zjcqPm81pjWD00BirHl7L/nEzT8MmwndTfEiqXTyjQEML9iDc7lMLRZgUCDamw==
X-Received: by 2002:a2e:2c0e:: with SMTP id s14mr3038795ljs.28.1598282826933;
        Mon, 24 Aug 2020 08:27:06 -0700 (PDT)
Received: from [192.168.2.145] (109-252-170-211.dynamic.spd-mgts.ru. [109.252.170.211])
        by smtp.googlemail.com with ESMTPSA id z3sm2239976ljz.109.2020.08.24.08.27.05
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 24 Aug 2020 08:27:06 -0700 (PDT)
Subject: Re: [PATCH v1] brcmfmac: increase F2 watermark for BCM4329
To:     Arend Van Spriel <arend.vanspriel@broadcom.com>,
        Franky Lin <franky.lin@broadcom.com>,
        Hante Meuleman <hante.meuleman@broadcom.com>,
        Chi-Hsien Lin <chi-hsien.lin@cypress.com>,
        Wright Feng <wright.feng@cypress.com>,
        Kalle Valo <kvalo@codeaurora.org>
Cc:     linux-wireless@vger.kernel.org,
        brcm80211-dev-list.pdl@broadcom.com,
        brcm80211-dev-list@cypress.com, netdev@vger.kernel.org,
        linux-tegra@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20200823142004.21990-1-digetx@gmail.com>
 <93536fd4-8abc-e167-a184-5a5e36d4205a@broadcom.com>
From:   Dmitry Osipenko <digetx@gmail.com>
Message-ID: <1ac6d0f3-d639-e947-4108-17ecc0220a1e@gmail.com>
Date:   Mon, 24 Aug 2020 18:27:05 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <93536fd4-8abc-e167-a184-5a5e36d4205a@broadcom.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

24.08.2020 11:28, Arend Van Spriel пишет:
> 
> 
> On 8/23/2020 4:20 PM, Dmitry Osipenko wrote:
>> This patch fixes SDHCI CRC errors during of RX throughput testing on
>> BCM4329 chip if SDIO BUS is clocked above 25MHz. In particular the
>> checksum problem is observed on NVIDIA Tegra20 SoCs. The good watermark
>> value is borrowed from downstream BCMDHD driver and it's the same as the
>> value used for the BCM4339 chip, hence let's re-use it for BCM4329.
> 
> one comment, but when fixed you can add my....
> 
> Reviewed-by: Arend van Spriel <arend.vanspriel@broadcom.com>
>> Signed-off-by: Dmitry Osipenko <digetx@gmail.com>
>> ---
>>   drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c | 1 +
>>   1 file changed, 1 insertion(+)
>>
>> diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c
>> b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c
>> index 3c07d1bbe1c6..ac3ee93a2378 100644
>> --- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c
>> +++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c
>> @@ -4278,6 +4278,7 @@ static void brcmf_sdio_firmware_callback(struct
>> device *dev, int err,
>>               brcmf_sdiod_writeb(sdiod, SBSDIO_FUNC1_MESBUSYCTRL,
>>                          CY_43012_MESBUSYCTRL, &err);
>>               break;
>> +        case SDIO_DEVICE_ID_BROADCOM_4329:
>>           case SDIO_DEVICE_ID_BROADCOM_4339:
>>               brcmf_dbg(INFO, "set F2 watermark to 0x%x*4 bytes for
>> 4339\n",
> 
> Maybe better to drop the chip id from the debug message. The chip id is
> printed elsewhere already so it does not add info here and could only
> cause confusion. Maybe you can also remove it from the 43455 message a
> bit below.

Hello, Arend! Thank you for the review! I'll prepare v2 with the cleaned
debug messages and couple more small changes!

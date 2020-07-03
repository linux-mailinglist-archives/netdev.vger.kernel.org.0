Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 429D6213B76
	for <lists+netdev@lfdr.de>; Fri,  3 Jul 2020 16:01:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726311AbgGCOBK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Jul 2020 10:01:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38698 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726035AbgGCOBI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 Jul 2020 10:01:08 -0400
Received: from mail-wr1-x443.google.com (mail-wr1-x443.google.com [IPv6:2a00:1450:4864:20::443])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1B294C08C5C1;
        Fri,  3 Jul 2020 07:01:07 -0700 (PDT)
Received: by mail-wr1-x443.google.com with SMTP id f7so29790864wrw.1;
        Fri, 03 Jul 2020 07:01:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:autocrypt:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=6bBD353wa9oOGAllNHqdK+eyXz4Kyyl8Jv53eUCZE30=;
        b=eY0KG8vB+nGTiTyYby+J3tGYqBmR0XZUQER1jLykSgsIe2ekhxZkqUBMfqKilI0JO7
         RM6aCSUTcDQFm2vuYjZkekbSATq/YuguYuJpnTqAW+jMlpV1MRFi4I4UmC8lAn7un/mX
         aji1ubi37eKChSa15jTSoAGOlLjBwNz3XYHViT+sj4Tnx4lrBSaKp2hYV/+5eaK3n5A1
         /+lOa2tgIIb9/i2eps5h443srl9pgaXS5Uf9Gg1AFL7cy8LIsVTdnSJ6B3/CdTlzDf40
         TVkNtBOJkslRpuRPAgW55mDwkyeAMyu8vbVI/U+6ObjmH87ewObClFDZfutSfBrwwh16
         NO0Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:autocrypt
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=6bBD353wa9oOGAllNHqdK+eyXz4Kyyl8Jv53eUCZE30=;
        b=Iet7t085qyQ2Yinu3VvJnUEbuk0mh7qkFsCCoQPjVLS9Wv8daTpQ1iKl7I+3AOL4ij
         tdSqEFGc/+zsMnfJP+9sp5TNoJe1XVAu4mHzNhAXQJhSZ24VPaZRK84lIczFb1GvkL+5
         5G0VKMG2Qa3MDYRsImHKl5BM7mLiG8APBBVJ/Y+ZSp52IrFq1ZGaIXXEH6VsDrvc2xqX
         NdvtBrd3GDBMmt7/+av0SE1NkPmgvhaWcJpeDQTaYovyK7T1DlNsegd358WFwINk67fB
         KG/749Ynuim3dgNd8vaATo4kh5c+PwbHY6PTON6Ss5uggJrw6c/jyZ1upHMthE8xvg6u
         UwOA==
X-Gm-Message-State: AOAM531N9+tSntXzV52DdtbBmlCFkJGw9VtEOyUqd1yicBSQp0tJ6Z4q
        9ZtS73amKQ4MMKKisVd3qaI=
X-Google-Smtp-Source: ABdhPJyiJXs/n2wp9EINdUtUPcWxHxkCQnEm1p8H8CmVuUSf6pDKfxeFCqDF3/79iFmOZbSXXG/fBg==
X-Received: by 2002:adf:c185:: with SMTP id x5mr40322595wre.403.1593784865770;
        Fri, 03 Jul 2020 07:01:05 -0700 (PDT)
Received: from ziggy.stardust ([213.195.114.245])
        by smtp.gmail.com with ESMTPSA id k20sm13654569wmi.27.2020.07.03.07.01.04
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 03 Jul 2020 07:01:05 -0700 (PDT)
Subject: Re: [PATCH] brcmfmac: expose firmware config files through modinfo
To:     Hans de Goede <hdegoede@redhat.com>,
        Matthias Brugger <mbrugger@suse.com>, matthias.bgg@kernel.org,
        Jakub Kicinski <kuba@kernel.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S . Miller" <davem@davemloft.net>
Cc:     =?UTF-8?Q?Pali_Roh=c3=a1r?= <pali@kernel.org>,
        Guenter Roeck <linux@roeck-us.net>,
        Chi-Hsien Lin <chi-hsien.lin@cypress.com>,
        Franky Lin <franky.lin@broadcom.com>,
        Chung-Hsien Hsu <stanley.hsu@cypress.com>,
        Jean-Philippe Brucker <jean-philippe@linaro.org>,
        Double Lo <double.lo@cypress.com>,
        Frank Kao <frank.kao@cypress.com>,
        linux-wireless@vger.kernel.org,
        brcm80211-dev-list.pdl@broadcom.com,
        Arend van Spriel <arend.vanspriel@broadcom.com>,
        "Gustavo A . R . Silva" <gustavo@embeddedor.com>,
        netdev@vger.kernel.org,
        =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <rafal@milecki.pl>,
        Hante Meuleman <hante.meuleman@broadcom.com>,
        Wright Feng <wright.feng@cypress.com>,
        Saravanan Shanmugham <saravanan.shanmugham@cypress.com>,
        brcm80211-dev-list@cypress.com, linux-kernel@vger.kernel.org,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Soeren Moch <smoch@web.de>
References: <20200701153123.25602-1-matthias.bgg@kernel.org>
 <338e3cff-dfa0-c588-cf53-a160d75af2ee@redhat.com>
 <1013c7e6-f1fb-af0c-fe59-4d6cd612f959@suse.com>
 <35066b13-9fe2-211d-2ba8-5eb903b46bf7@redhat.com>
From:   Matthias Brugger <matthias.bgg@gmail.com>
Autocrypt: addr=matthias.bgg@gmail.com; prefer-encrypt=mutual; keydata=
 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
Message-ID: <ba8c2bfa-3f50-512e-e28c-a47896e5c242@gmail.com>
Date:   Fri, 3 Jul 2020 16:01:03 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.9.0
MIME-Version: 1.0
In-Reply-To: <35066b13-9fe2-211d-2ba8-5eb903b46bf7@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 02/07/2020 20:00, Hans de Goede wrote:
> Hi,
> 
> On 7/1/20 5:46 PM, Matthias Brugger wrote:
>> Hi Hans,
>>
>> On 01/07/2020 17:38, Hans de Goede wrote:
>>> Hi,
>>>
>>> On 7/1/20 5:31 PM, matthias.bgg@kernel.org wrote:
>>>> From: Matthias Brugger <mbrugger@suse.com>
>>>>
>>>> Apart from a firmware binary the chip needs a config file used by the
>>>> FW. Add the config files to modinfo so that they can be read by
>>>> userspace.
>>>
>>> The configfile firmware filename is dynamically generated, just adding the list
>>> of all currently shipped ones is not really helpful and this is going to get
>>> out of sync with what we actually have in linux-firmware.
>>
>> I'm aware of this, and I agree.
>>
>>>
>>> I must honestly say that I'm not a fan of this, I guess you are trying to
>>> get some tool which builds a minimal image, such as an initrd generator
>>> to add these files to the image ?
>>>
>>
>> Yes exactly.
>>
>>> I do not immediately have a better idea, but IMHO the solution
>>> this patch proposes is not a good one, so nack from me for this change.
>>>
>>
>> Another path we could go is add a wildcard string instead, for example:
>> MODULE_FIRMWARE("brcm/brcmfmac43455-sdio.*.txt");
> 
> I was thinking about the same lines, but I'm afraid some user-space
> utils may blow up if we introduce this, which is why I did not suggest
> it in my previous email.
> 
>> AFAIK there is no driver in the kernel that does this. I checked with our dracut
>> developer and right now dracut can't cope with that.
> 
> Can't cope as in tries to add "/lib/firmware/brcm/brcmfmac43455-sdio.*.txt"
> and then skips it (as it does for other missing firmware files); or can't
> cope as in blows-up and aborts without leaving a valid initrd behind.
> 
> If is the former, that is fine, if it is the latter that is a problem.
> 
>> But he will try to
>> implement that in the future.
>>
>> So my idea was to maintain that list for now and switch to the wildcard approach
>> once we have dracut support that.
> 
> So lets assume that the wildcard approach is ok and any initrd tools looking at
> the MODULE_FIRMWARE metadata either accidentally do what we want; or fail
> gracefully.  Then if we temporarily add the long MODULE_FIRMWARE list now, those
> which fail gracefully will start doing the right thing (except they add too
> much firmware), and later on we cannot remove all the non wildcard
> MODULE_FIRMWARE list entries because that will cause a regression.
> 
> Because of this I'm not a fan of temporarily fixing this like this. Using wifi
> inside the initrd is very much a cornercase anyways, so I think users can
> use a workaround by dropping an /etc/dracut.conf.d file adding the necessary
> config file for now.
> 
> As for the long run, I was thinking that even with regular firmware files
> we are adding too much firmware to host-specific initrds since we add all
> the firmwares listed with MODULE_FIRMWARE, and typically only a few are
> actually necessary.
> 
> We could modify the firmware_loader code under drivers/base/firmware_loader
> to keep a list of all files loaded since boot; and export that somewhere
> under /sys, then dracut could use that list in host-only mode and we get
> a smaller initrd. One challenge with this approach though is firmware files
> which are necessary for a new kernel, but not used by the running kernel ...
> I'm afraid I do not have a good answer to that.
> 

That would work for creating a new minimal initrd from a working image. But it
would not help in bootstrapping an image. My understanding is that for
bootstrapping an image we will need to support wildcards in MODULE_FIRMWARE()
strings.

Regards,
Matthias

> Regards,
> 
> Hans
> 
> 
> 
> 
> 
> 
> 
>>>> Signed-off-by: Matthias Brugger <mbrugger@suse.com>
>>>>
>>>> ---
>>>>
>>>>    .../wireless/broadcom/brcm80211/brcmfmac/sdio.c  | 16 ++++++++++++++++
>>>>    1 file changed, 16 insertions(+)
>>>>
>>>> diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c
>>>> b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c
>>>> index 310d8075f5d7..ba18df6d8d94 100644
>>>> --- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c
>>>> +++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c
>>>> @@ -624,6 +624,22 @@ BRCMF_FW_DEF(4359, "brcmfmac4359-sdio");
>>>>    BRCMF_FW_DEF(4373, "brcmfmac4373-sdio");
>>>>    BRCMF_FW_DEF(43012, "brcmfmac43012-sdio");
>>>>    +/* firmware config files */
>>>> +MODULE_FIRMWARE(BRCMF_FW_DEFAULT_PATH
>>>> "brcm/brcmfmac4330-sdio.Prowise-PT301.txt");
>>>> +MODULE_FIRMWARE(BRCMF_FW_DEFAULT_PATH
>>>> "brcm/brcmfmac43340-sdio.meegopad-t08.txt");
>>>> +MODULE_FIRMWARE(BRCMF_FW_DEFAULT_PATH
>>>> "brcm/brcmfmac43340-sdio.pov-tab-p1006w-data.txt");
>>>> +MODULE_FIRMWARE(BRCMF_FW_DEFAULT_PATH
>>>> "brcm/brcmfmac43362-sdio.cubietech,cubietruck.txt");
>>>> +MODULE_FIRMWARE(BRCMF_FW_DEFAULT_PATH
>>>> "brcm/brcmfmac43430a0-sdio.jumper-ezpad-mini3.txt");
>>>> +MODULE_FIRMWARE(BRCMF_FW_DEFAULT_PATH "brcm/brcmfmac43430a0-sdio.ONDA-V80
>>>> PLUS.txt");
>>>> +MODULE_FIRMWARE(BRCMF_FW_DEFAULT_PATH "brcm/brcmfmac43430-sdio.AP6212.txt");
>>>> +MODULE_FIRMWARE(BRCMF_FW_DEFAULT_PATH
>>>> "brcm/brcmfmac43430-sdio.Hampoo-D2D3_Vi8A1.txt");
>>>> +MODULE_FIRMWARE(BRCMF_FW_DEFAULT_PATH "brcm/brcmfmac43430-sdio.MUR1DX.txt");
>>>> +MODULE_FIRMWARE(BRCMF_FW_DEFAULT_PATH
>>>> "brcm/brcmfmac43430-sdio.raspberrypi,3-model-b.txt");
>>>> +MODULE_FIRMWARE(BRCMF_FW_DEFAULT_PATH "brcm/brcmfmac43455-sdio.MINIX-NEO
>>>> Z83-4.txt");
>>>> +MODULE_FIRMWARE(BRCMF_FW_DEFAULT_PATH
>>>> "brcm/brcmfmac43455-sdio.raspberrypi,3-model-b-plus.txt");
>>>> +MODULE_FIRMWARE(BRCMF_FW_DEFAULT_PATH
>>>> "brcm/brcmfmac43455-sdio.raspberrypi,4-model-b.txt");
>>>> +MODULE_FIRMWARE(BRCMF_FW_DEFAULT_PATH
>>>> "brcm/brcmfmac4356-pcie.gpd-win-pocket.txt");
>>>> +
>>>>    static const struct brcmf_firmware_mapping brcmf_sdio_fwnames[] = {
>>>>        BRCMF_FW_ENTRY(BRCM_CC_43143_CHIP_ID, 0xFFFFFFFF, 43143),
>>>>        BRCMF_FW_ENTRY(BRCM_CC_43241_CHIP_ID, 0x0000001F, 43241B0),
>>>>
>>>
>>
> 

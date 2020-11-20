Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F03CF2BA8C1
	for <lists+netdev@lfdr.de>; Fri, 20 Nov 2020 12:14:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728666AbgKTLLN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Nov 2020 06:11:13 -0500
Received: from mx2.suse.de ([195.135.220.15]:44812 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728196AbgKTLLM (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 20 Nov 2020 06:11:12 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1605870670; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=okS+uE4+yBQTM7gr9/lTXNCnQnbhp4qFP4cgEiZ30RY=;
        b=KdkxFsr940NtcWXuxYcJ1rQdOqMyudA0sk8M9l9s5betLZguUYKLa9D+nMhYUEo14OjrUC
        qNwxZOU6eUiif1JDiT0cfW2zVRGjlEqlZrIIuVq4dTidkXNzSeYg2d/wjnQ6CsYAfvUbPH
        +XvtXs+AQ7uXmaJs2NDH4YVJvuCBnxI=
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id AA97AAF37;
        Fri, 20 Nov 2020 11:11:10 +0000 (UTC)
Subject: Re: [PATCH v2] brcmfmac: expose firmware config files through modinfo
To:     Dmitry Osipenko <digetx@gmail.com>, matthias.bgg@kernel.org,
        Jakub Kicinski <kuba@kernel.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S . Miller" <davem@davemloft.net>, hdegoede@redhat.com
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
        Amar Shankar <amsr@cypress.com>
References: <20201120095233.19953-1-matthias.bgg@kernel.org>
 <2ff4dcc3-6f99-a068-8989-4293d2013627@gmail.com>
From:   Matthias Brugger <mbrugger@suse.com>
Message-ID: <7e8e689a-9804-86fc-dd2c-f1622dd40476@suse.com>
Date:   Fri, 20 Nov 2020 12:11:08 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.4.0
MIME-Version: 1.0
In-Reply-To: <2ff4dcc3-6f99-a068-8989-4293d2013627@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 20/11/2020 11:05, Dmitry Osipenko wrote:
> 20.11.2020 12:52, matthias.bgg@kernel.org пишет:
>> From: Matthias Brugger <mbrugger@suse.com>
>>
>> Apart from a firmware binary the chip needs a config file used by the
>> FW. Add the config files to modinfo so that they can be read by
>> userspace.
>>
>> Signed-off-by: Matthias Brugger <mbrugger@suse.com>
>>
>> ---
>>
>> Changes in v2:
>> In comparison to first version [0] we use wildcards to enumerate the
>> firmware configuration files. Wildcard support was added to dracut
>> recently [1].
>> [0] https://lore.kernel.org/linux-wireless/20200701153123.25602-1-matthias.bgg@kernel.org/
>> [1] https://github.com/dracutdevs/dracut/pull/860
>>
>>   drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c | 9 +++++++++
>>   1 file changed, 9 insertions(+)
>>
>> diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c
>> index 99987a789e7e..dd6d287b1b00 100644
>> --- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c
>> +++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c
>> @@ -625,6 +625,15 @@ BRCMF_FW_DEF(4359, "brcmfmac4359-sdio");
>>   BRCMF_FW_DEF(4373, "brcmfmac4373-sdio");
>>   BRCMF_FW_DEF(43012, "brcmfmac43012-sdio");
>>   
>> +/* firmware config files */
>> +MODULE_FIRMWARE(BRCMF_FW_DEFAULT_PATH "brcm/brcmfmac4330-sdio.*.txt");
>> +MODULE_FIRMWARE(BRCMF_FW_DEFAULT_PATH "brcm/brcmfmac43340-sdio.*.txt");
>> +MODULE_FIRMWARE(BRCMF_FW_DEFAULT_PATH "brcm/brcmfmac43362-sdio.*.txt");
>> +MODULE_FIRMWARE(BRCMF_FW_DEFAULT_PATH "brcm/brcmfmac43430a0-sdio.*.txt");
>> +MODULE_FIRMWARE(BRCMF_FW_DEFAULT_PATH "brcm/brcmfmac43430-sdio.*.txt");
>> +MODULE_FIRMWARE(BRCMF_FW_DEFAULT_PATH "brcm/brcmfmac43455-sdio.*.txt");
>> +MODULE_FIRMWARE(BRCMF_FW_DEFAULT_PATH "brcm/brcmfmac4356-pcie.*.txt");
> 
> This doesn't cover all hardware models. Note that the upstream
> linux-firmware has files only for a few hardware models.
> 
> I suppose that the correct mask should be "brcm/brcmfmac*-sdio.*.txt".
> 

We can use the two "brcm/brcmfmac*-sdio.*.txt" and "brcm/brcmfmac*-pcie.*.txt" 
to also include firmware files for chips that don't have any config file in 
linux-firmware. I'm indifferent to that, although I think we should make 
incentivize to upstream firmware config files to linux-firmware.

Regards,
Matthias

Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B89E0212BC9
	for <lists+netdev@lfdr.de>; Thu,  2 Jul 2020 20:00:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727984AbgGBSA1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Jul 2020 14:00:27 -0400
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:30866 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727935AbgGBSA0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Jul 2020 14:00:26 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1593712825;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=9RTAPOlUHkOQw9eYA5K/tFkatYM1nQfJUmd/xyhvdU8=;
        b=RHqeV+9i0N6zcezDs8QZqjL45VcGYQ5A9Q0ytt+p/GFa6I+7QQPoi0ZQ3pIckArWv/ZuJQ
        gPDQQ1rI3MkVVTBBsH3Sb1/DOKSQONSrs+i8zEbQy/KETeXK8M8v5RsZLQMTKcKXr3VzWi
        1j4GXkPAUrOZMBqsS8E3JSigOsvMrDc=
Received: from mail-ed1-f69.google.com (mail-ed1-f69.google.com
 [209.85.208.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-224-2tecgtsWNpaaXRVuCLxCJw-1; Thu, 02 Jul 2020 14:00:23 -0400
X-MC-Unique: 2tecgtsWNpaaXRVuCLxCJw-1
Received: by mail-ed1-f69.google.com with SMTP id d3so15788857edq.14
        for <netdev@vger.kernel.org>; Thu, 02 Jul 2020 11:00:23 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=9RTAPOlUHkOQw9eYA5K/tFkatYM1nQfJUmd/xyhvdU8=;
        b=in9MZVPuwnVAtS74q+ASlbHtVr2LhscuqykTd7TS3V5Gz9Jxda+7hcXuIpzw5rb+i5
         5HsK5n3KL77DZ0x78Ts4dvbtgOsjKgjRB3oU/+omvaRysqa2l1jSYcm3glGdXCmfKIZN
         2x5uk/J8xfpLvaERKkTh5na1uth95VI53zSGcxqUs0sDe4tU05TCw8LaCh+x8BWwgHrd
         hOcssupizt3i7XHNZQoQh+9/4N04yf41WcgnpsKvtuhG8EjpUfdGZ20w3TwsORNGoEiF
         XrNXqf+sJYFV7RlwwvET2k1Y/gXD8op0ouPbPUSERi/MgNfKomM93pvsx0SVTXGZMJhV
         UDJQ==
X-Gm-Message-State: AOAM530JS0ldlZ7OeThRZWC1+idKixDDFetZOds8NVjP9jSvuvVBQyAP
        Fu0Afx5gnZZv4u+oS9J6+DdNkc3FFLMThNlxl4bVPlg362UWgBr7YsLsc5UxahvOp1kNBdmi/hR
        Hd1r5ktguVdgNj1sl
X-Received: by 2002:a17:906:7c3:: with SMTP id m3mr27739734ejc.30.1593712822204;
        Thu, 02 Jul 2020 11:00:22 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzoAanT6l1qUnuzAmJ14QQOgQttXkiEZaoXRw3XHTH4UmRAk7NzoBTFrhoAQmSqdLtzxCypVA==
X-Received: by 2002:a17:906:7c3:: with SMTP id m3mr27739678ejc.30.1593712821894;
        Thu, 02 Jul 2020 11:00:21 -0700 (PDT)
Received: from x1.localdomain (2001-1c00-0c0c-fe00-d2ea-f29d-118b-24dc.cable.dynamic.v6.ziggo.nl. [2001:1c00:c0c:fe00:d2ea:f29d:118b:24dc])
        by smtp.gmail.com with ESMTPSA id qc16sm7399458ejb.33.2020.07.02.11.00.20
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 02 Jul 2020 11:00:21 -0700 (PDT)
Subject: Re: [PATCH] brcmfmac: expose firmware config files through modinfo
To:     Matthias Brugger <mbrugger@suse.com>, matthias.bgg@kernel.org,
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
From:   Hans de Goede <hdegoede@redhat.com>
Message-ID: <35066b13-9fe2-211d-2ba8-5eb903b46bf7@redhat.com>
Date:   Thu, 2 Jul 2020 20:00:19 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.9.0
MIME-Version: 1.0
In-Reply-To: <1013c7e6-f1fb-af0c-fe59-4d6cd612f959@suse.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

On 7/1/20 5:46 PM, Matthias Brugger wrote:
> Hi Hans,
> 
> On 01/07/2020 17:38, Hans de Goede wrote:
>> Hi,
>>
>> On 7/1/20 5:31 PM, matthias.bgg@kernel.org wrote:
>>> From: Matthias Brugger <mbrugger@suse.com>
>>>
>>> Apart from a firmware binary the chip needs a config file used by the
>>> FW. Add the config files to modinfo so that they can be read by
>>> userspace.
>>
>> The configfile firmware filename is dynamically generated, just adding the list
>> of all currently shipped ones is not really helpful and this is going to get
>> out of sync with what we actually have in linux-firmware.
> 
> I'm aware of this, and I agree.
> 
>>
>> I must honestly say that I'm not a fan of this, I guess you are trying to
>> get some tool which builds a minimal image, such as an initrd generator
>> to add these files to the image ?
>>
> 
> Yes exactly.
> 
>> I do not immediately have a better idea, but IMHO the solution
>> this patch proposes is not a good one, so nack from me for this change.
>>
> 
> Another path we could go is add a wildcard string instead, for example:
> MODULE_FIRMWARE("brcm/brcmfmac43455-sdio.*.txt");

I was thinking about the same lines, but I'm afraid some user-space
utils may blow up if we introduce this, which is why I did not suggest
it in my previous email.

> AFAIK there is no driver in the kernel that does this. I checked with our dracut
> developer and right now dracut can't cope with that.

Can't cope as in tries to add "/lib/firmware/brcm/brcmfmac43455-sdio.*.txt"
and then skips it (as it does for other missing firmware files); or can't
cope as in blows-up and aborts without leaving a valid initrd behind.

If is the former, that is fine, if it is the latter that is a problem.

> But he will try to
> implement that in the future.
> 
> So my idea was to maintain that list for now and switch to the wildcard approach
> once we have dracut support that.

So lets assume that the wildcard approach is ok and any initrd tools looking at
the MODULE_FIRMWARE metadata either accidentally do what we want; or fail
gracefully.  Then if we temporarily add the long MODULE_FIRMWARE list now, those
which fail gracefully will start doing the right thing (except they add too
much firmware), and later on we cannot remove all the non wildcard
MODULE_FIRMWARE list entries because that will cause a regression.

Because of this I'm not a fan of temporarily fixing this like this. Using wifi
inside the initrd is very much a cornercase anyways, so I think users can
use a workaround by dropping an /etc/dracut.conf.d file adding the necessary
config file for now.

As for the long run, I was thinking that even with regular firmware files
we are adding too much firmware to host-specific initrds since we add all
the firmwares listed with MODULE_FIRMWARE, and typically only a few are
actually necessary.

We could modify the firmware_loader code under drivers/base/firmware_loader
to keep a list of all files loaded since boot; and export that somewhere
under /sys, then dracut could use that list in host-only mode and we get
a smaller initrd. One challenge with this approach though is firmware files
which are necessary for a new kernel, but not used by the running kernel ...
I'm afraid I do not have a good answer to that.

Regards,

Hans







>>> Signed-off-by: Matthias Brugger <mbrugger@suse.com>
>>>
>>> ---
>>>
>>>    .../wireless/broadcom/brcm80211/brcmfmac/sdio.c  | 16 ++++++++++++++++
>>>    1 file changed, 16 insertions(+)
>>>
>>> diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c
>>> b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c
>>> index 310d8075f5d7..ba18df6d8d94 100644
>>> --- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c
>>> +++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c
>>> @@ -624,6 +624,22 @@ BRCMF_FW_DEF(4359, "brcmfmac4359-sdio");
>>>    BRCMF_FW_DEF(4373, "brcmfmac4373-sdio");
>>>    BRCMF_FW_DEF(43012, "brcmfmac43012-sdio");
>>>    +/* firmware config files */
>>> +MODULE_FIRMWARE(BRCMF_FW_DEFAULT_PATH
>>> "brcm/brcmfmac4330-sdio.Prowise-PT301.txt");
>>> +MODULE_FIRMWARE(BRCMF_FW_DEFAULT_PATH
>>> "brcm/brcmfmac43340-sdio.meegopad-t08.txt");
>>> +MODULE_FIRMWARE(BRCMF_FW_DEFAULT_PATH
>>> "brcm/brcmfmac43340-sdio.pov-tab-p1006w-data.txt");
>>> +MODULE_FIRMWARE(BRCMF_FW_DEFAULT_PATH
>>> "brcm/brcmfmac43362-sdio.cubietech,cubietruck.txt");
>>> +MODULE_FIRMWARE(BRCMF_FW_DEFAULT_PATH
>>> "brcm/brcmfmac43430a0-sdio.jumper-ezpad-mini3.txt");
>>> +MODULE_FIRMWARE(BRCMF_FW_DEFAULT_PATH "brcm/brcmfmac43430a0-sdio.ONDA-V80
>>> PLUS.txt");
>>> +MODULE_FIRMWARE(BRCMF_FW_DEFAULT_PATH "brcm/brcmfmac43430-sdio.AP6212.txt");
>>> +MODULE_FIRMWARE(BRCMF_FW_DEFAULT_PATH
>>> "brcm/brcmfmac43430-sdio.Hampoo-D2D3_Vi8A1.txt");
>>> +MODULE_FIRMWARE(BRCMF_FW_DEFAULT_PATH "brcm/brcmfmac43430-sdio.MUR1DX.txt");
>>> +MODULE_FIRMWARE(BRCMF_FW_DEFAULT_PATH
>>> "brcm/brcmfmac43430-sdio.raspberrypi,3-model-b.txt");
>>> +MODULE_FIRMWARE(BRCMF_FW_DEFAULT_PATH "brcm/brcmfmac43455-sdio.MINIX-NEO
>>> Z83-4.txt");
>>> +MODULE_FIRMWARE(BRCMF_FW_DEFAULT_PATH
>>> "brcm/brcmfmac43455-sdio.raspberrypi,3-model-b-plus.txt");
>>> +MODULE_FIRMWARE(BRCMF_FW_DEFAULT_PATH
>>> "brcm/brcmfmac43455-sdio.raspberrypi,4-model-b.txt");
>>> +MODULE_FIRMWARE(BRCMF_FW_DEFAULT_PATH
>>> "brcm/brcmfmac4356-pcie.gpd-win-pocket.txt");
>>> +
>>>    static const struct brcmf_firmware_mapping brcmf_sdio_fwnames[] = {
>>>        BRCMF_FW_ENTRY(BRCM_CC_43143_CHIP_ID, 0xFFFFFFFF, 43143),
>>>        BRCMF_FW_ENTRY(BRCM_CC_43241_CHIP_ID, 0x0000001F, 43241B0),
>>>
>>
> 


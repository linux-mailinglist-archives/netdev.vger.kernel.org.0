Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 46BE73C27FC
	for <lists+netdev@lfdr.de>; Fri,  9 Jul 2021 19:04:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230129AbhGIRG3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Jul 2021 13:06:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38920 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230048AbhGIRG1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 9 Jul 2021 13:06:27 -0400
Received: from mail-ej1-x62f.google.com (mail-ej1-x62f.google.com [IPv6:2a00:1450:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1D6FAC0613DD;
        Fri,  9 Jul 2021 10:03:43 -0700 (PDT)
Received: by mail-ej1-x62f.google.com with SMTP id hr1so17441014ejc.1;
        Fri, 09 Jul 2021 10:03:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=dVvi+fZClluzxbZN95gNbThYay+2YwEvt12ff5eLbXk=;
        b=tEu1JMlVzD8b1ypcdJPbklHbisxRVqJruL4zMITA4wwQWTQlw9JW2PCaAikP5hc6LH
         nBO4sDB+3rIcpzI6li/thAFzEd1rtBgfFWRTm5mNUS7La79azOLXUrSbVXXP5NhVsOGV
         LM/jRRmNQr7t8SFQn4Kjtn9nCHfLBaJbrxb/NfwURY5ptX1HVYBVxI9kYoMCoA1CJG+B
         rN9bNSD0vWjGu8RjQyD/xmOETiz01jK0RSlEO5HgcqE9UcFlFhoke6elSE9u7jvk/nYv
         H7COXhXsDnRgdniVwk8qxRZJUtmfGmCSIwRUksFkpOWEYSNgUAV9GHWb0erbuLdZ64il
         qSzw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=dVvi+fZClluzxbZN95gNbThYay+2YwEvt12ff5eLbXk=;
        b=HZLdsUUo3wInXSmrDF1vkopxUyIdt4CLAW4Zn6OPm6YPAovBhHplrsz9Bz5tVMYSjh
         N8fka6U4JVwvJyVLI5NzkkNMEZhGXv5S0QUYf6PaRqas5erkgs/s8wXO4uCE/p7jKhPu
         GA6bcYreAiMy5epMzF/AieyK0C7hDekhfe4zRECymX3O258kbMKOeyarwOYFpPOf3eTH
         gw3NHhWs01mI+mXnGKkLPGGvc1wqGGtfbIivYEr+wn++nGMF4sQZVFfcjaL+G1apjbFG
         ICzixd7ADqFyKZxrinZdBjcp4TzpfBxzMXa0vuZZXambu0ELSkTv9pdKq56tzWJHRbsK
         0ukw==
X-Gm-Message-State: AOAM5327Mo/LDyawBT3ocVkLXqOeGXLASQ/UxagocRrkkIXBUGmNNUH0
        7w9TNKfTSS9HEgCqRXJDa4Q=
X-Google-Smtp-Source: ABdhPJyNpj7VoaP/QFxXSqjELez4vxqyI7afRt1sdshszXWHVKMHr5T0zib4zwltcYgIr6pk8m7p/g==
X-Received: by 2002:a17:907:1c98:: with SMTP id nb24mr39644300ejc.316.1625850221623;
        Fri, 09 Jul 2021 10:03:41 -0700 (PDT)
Received: from [10.17.0.13] ([37.58.58.229])
        by smtp.gmail.com with ESMTPSA id zp1sm2581308ejb.92.2021.07.09.10.03.38
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 09 Jul 2021 10:03:41 -0700 (PDT)
Subject: Re: [PATCH v2 2/2] mwifiex: pcie: add reset_d3cold quirk for Surface
 gen4+ devices
To:     =?UTF-8?Q?Pali_Roh=c3=a1r?= <pali@kernel.org>,
        =?UTF-8?Q?Jonas_Dre=c3=9fler?= <verdre@v0yd.nl>
Cc:     Amitkumar Karwar <amitkarwar@gmail.com>,
        Ganapathi Bhat <ganapathi.bhat@nxp.com>,
        Xinming Hu <huxinming820@gmail.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Tsuchiya Yuto <kitakar@gmail.com>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Bjorn Helgaas <bhelgaas@google.com>
References: <20210709145831.6123-1-verdre@v0yd.nl>
 <20210709145831.6123-3-verdre@v0yd.nl> <20210709151800.7b2qqezlcicbgrqn@pali>
 <b1002254-97c6-d271-c385-4a5c9fe0c914@mailbox.org>
 <20210709161251.g4cvq3l4fnh4ve4r@pali>
From:   Maximilian Luz <luzmaximilian@gmail.com>
Message-ID: <d9158206-8ebe-c857-7533-47155a6464e1@gmail.com>
Date:   Fri, 9 Jul 2021 19:03:37 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <20210709161251.g4cvq3l4fnh4ve4r@pali>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 7/9/21 6:12 PM, Pali Rohár wrote:

[...]

>>> Hello! Now I'm thinking loudly about this patch. Why this kind of reset
>>> is needed only for Surface devices? AFAIK these 88W8897 chips are same
>>> in all cards. Chip itself implements PCIe interface (and also SDIO) so
>>> for me looks very strange if this 88W8897 PCIe device needs DMI specific
>>> quirks. I cannot believe that Microsoft got some special version of
>>> these chips from Marvell which are different than version uses on cards
>>> in mPCIe form factor.
>>>
>>> And now when I'm reading comment below about PCIe bridge to which is
>>> this 88W8897 PCIe chip connected, is not this rather an issue in that
>>> PCIe bridge (instead of mwifiex/88W8897) or in ACPI firmware which
>>> controls this bridge?
>>>
>>> Or are having other people same issues on mPCIe form factor wifi cards
>>> with 88W8897 chips and then this quirk should not DMI dependent?
>>>
>>> Note that I'm seeing issues with reset and other things also on chip
>>> 88W8997 when is connected to system via SDIO. These chips have both PCIe
>>> and SDIO buses, it just depends which pins are used.
>>>
>>
>> Hi and thanks for the quick reply! Honestly I've no idea, this is just the
>> first method we found that allows for a proper reset of the chip. What I
>> know is that some Surface devices need that ACPI DSM call (the one that was
>> done in the commit I dropped in this version of the patchset) to reset the
>> chip instead of this method.
>>
>> Afaik other devices with this chip don't need this resetting method, at
>> least Marvell employees couldn't reproduce the issues on their testing
>> devices.
>>
>> So would you suggest we just try to match for the pci chip 88W8897 instead?
> 
> Hello! Such suggestion makes sense when we know that it is 88W8897
> issue. But if you got information that issue cannot be reproduced on
> other 88W8897 cards then matching 88W8897 is not correct.
> 
>  From all this information looks like that it is problem in (Microsoft?)
> PCIe bridge to which is card connected. Otherwise I do not reason how it
> can be 88W8897 affected. Either it is reproducible on 88W8897 cards also
> in other devices or issue is not on 88W8897 card.

I doubt that it's an issue with the PCIe bridge (itself at least). The
same type of bridge is used for both dGPU and NVME SSD on my device (see
lspci output below) and those work fine. Also if I'm seeing that right
it's from the Intel CPU, so my guess is that a lot more people would
have issues with that then.

I don't know about the hardware side, so it might be possible that it's
an issue with integrating both bridge and wifi chip, in which case it's
still probably best handled via DMI quirks unless we know more.

Also as Tsuchiya mentioned in his original submission, on Windows the
device is reset via this D3cold method. I've only skimmed that
errata.inf file mentioned, but I think this is what he's referring to:

   Controls whether ACPIDeviceEnableD3ColdOnSurpriseRemoval rule will be
   evaluated or not on a given platform. Currently
   ACPIDeviceEnableD3ColdOnSurpriseRemoval rule only needs to be
   evaluated on Surface platforms which contain the Marvell WiFi
   controller which depends on device going through D3Cold as part of
   surprise-removal.

and

   Starting with Windows releases *after* Blue, ACPI will not put
   surprise-removed devices into D3Cold automatically. Some known
   scenarios (viz. WiFi reset/recovery) rely on the device cycling
   through D3Cold on surprise-removal. This hack allows surprise-removed
   devices to be put into D3Cold (if supported by the stack).

So, as far as I can tell, the chip doesn't like to be surprise-removed
(which seems to happen during reset) and then needs to be power-cycled,
which I think is likely due to some issue with firmware state.

So the quirk on Windows seems very Surface specific.

There also seem a bunch of revisions of these chips around, for example
my SB2 is affected by a bug that we've tied to the specific hardware
revision which causes some issues with host-sleep (IIRC chip switches
rapidly between wake and sleep states without any external influence,
which is not how it should behave and how it does behave on a later
hardware revision).

>> Then we'd probably have to check if there are any laptops where multiple
>> devices are connected to the pci bridge as Amey suggested in a review
>> before.
> 
> Well, I do not know... But if this is issue with PCIe bridge then
> similar issue could be observed also for other PCIe devices with this
> PCIe bridge. But question is if there are other laptops with this PCIe
> bridge. And also it can be a problem in ACPI firmware on those Surface
> devices, which implements some PCIe bridge functionality. So it is
> possible that issue is with PCIe bridge, not in HW, but in SW/firmware
> part which can be Microsoft specific... So too many questions to which
> we do not know answers.
> 
> Could you provide output of 'lspci -nn -vv' and 'lspci -tvnn' on
> affected machines? If you have already sent it in some previous email,
> just send a link. At least I'm not able to find it right now and output
> may contain something useful...

 From my Surface Book 2 (with the same issue):

  - lspci -tvnn: https://paste.ubuntu.com/p/mm3YpcZJ8N/
  - lspci -vv -nn: https://paste.ubuntu.com/p/dctTDP738N/

Regards,
Max

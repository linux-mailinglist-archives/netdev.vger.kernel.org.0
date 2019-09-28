Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EC325C1222
	for <lists+netdev@lfdr.de>; Sat, 28 Sep 2019 22:36:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728623AbfI1UgF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 28 Sep 2019 16:36:05 -0400
Received: from mail-pl1-f193.google.com ([209.85.214.193]:37995 "EHLO
        mail-pl1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727655AbfI1UgF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 28 Sep 2019 16:36:05 -0400
Received: by mail-pl1-f193.google.com with SMTP id w8so1911063plq.5
        for <netdev@vger.kernel.org>; Sat, 28 Sep 2019 13:36:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=EckgKtoWO52w6E/OaNzyBr1B6L5Dqn451ZrvZi5pE8E=;
        b=CQqdAhV4syz9j/vGGOJvaBX09NwVGcpFxf6Q8F2wRxiYjoLdX3QTZ/DwWQIUwhEWsF
         L7te3Dp3IZuhAfRozhKZx2Q+8PsSB07+Qvyqeq+pXiEtOOuJJkAXxL8qWwG7Jq8ZvW9F
         O6jZrAYNbcoj78VEwm1Y6twq/uB9tOvp6rjc0Eh+jODzzwK8Dz3p5vvCqPlpoDRiQ0pc
         GCYK1KamyjKxyhW0Cp4Pu+Om8Q8OANhKG8udj7A398a4lpfT/Boud5Q+yaymx1HU2no7
         sX87/jIOZ28yUQeKCA7mcm31GzEZdg4bkKiiWG6o5PiSzaewlZK/3FUv6HawHYfPoLFI
         iYtw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=EckgKtoWO52w6E/OaNzyBr1B6L5Dqn451ZrvZi5pE8E=;
        b=QUNPTb3Pr/apF7eFa/SWrQ0xAAFbs62kBkM7Hj94c4HO4tvthp21MtFwv97LLYuk/5
         KV5JR1SQBpLlTWKnxBIjgwXAMVa7ySUvnQCMcBaNn/7ATPFA6NLL5jeHsWUvcgVz+1AM
         SoaYpWnW8KRCae3eJOw0hcz5oCJ/E4/a0QSV4x4xmtEkYiaipOCOsT1/CrCC+i+iUVIp
         0n7vbq1N/bUbghtCkoWN82ILktUrkbFtYm4vMgNHDLrd71uKRqEwL2LwLDLo+QIXmP7l
         kaZBHNftLlY2QYc6aFVMPWv9IkVjoqoikSFHCwdoTnGFZgqFCReW9+VaMm8W6sVmdr3B
         J4Xg==
X-Gm-Message-State: APjAAAXwYSMtebTy9+Ltxk+eYv733Zt/gRd2BdNDf7OkpL6a6zm6ixS7
        GP1+YGWo+32t5tDSV73Gh8d/z0tS
X-Google-Smtp-Source: APXvYqz9onrpdxrr+cAAWkC/OhCXGBW3brhcuy3f8+pZEIvdEG1htxjDnKVDyx+jNO1jmYYgeatdbg==
X-Received: by 2002:a17:902:b482:: with SMTP id y2mr12131181plr.334.1569702964270;
        Sat, 28 Sep 2019 13:36:04 -0700 (PDT)
Received: from [10.230.28.130] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id x20sm8631332pfp.120.2019.09.28.13.36.03
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 28 Sep 2019 13:36:03 -0700 (PDT)
Subject: Re: [PATCH] net: dsa: rtl8366: Check VLAN ID and not ports
To:     Linus Walleij <linus.walleij@linaro.org>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@savoirfairelinux.com>,
        netdev <netdev@vger.kernel.org>
References: <20190927163911.11179-1-linus.walleij@linaro.org>
 <e21e9a80-c8e0-d758-2309-1a8f03dda400@gmail.com>
 <CACRpkdaLTf9x=yTBBcGXDUmu2fNjLhx_eWVce_LQcPCjeq9TcQ@mail.gmail.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <8d34070c-4d35-e378-0b9e-4cfe279a7615@gmail.com>
Date:   Sat, 28 Sep 2019 13:36:02 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.1
MIME-Version: 1.0
In-Reply-To: <CACRpkdaLTf9x=yTBBcGXDUmu2fNjLhx_eWVce_LQcPCjeq9TcQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 9/28/2019 1:26 PM, Linus Walleij wrote:
> On Fri, Sep 27, 2019 at 6:40 PM Florian Fainelli <f.fainelli@gmail.com> wrote:
>> On 9/27/19 9:39 AM, Linus Walleij wrote:
>>> There has been some confusion between the port number and
>>> the VLAN ID in this driver. What we need to check for
>>> validity is the VLAN ID, nothing else.
>>>
>>> The current confusion came from assigning a few default
>>> VLANs for default routing and we need to rewrite that
>>> properly.
>>>
>>> Instead of checking if the port number is a valid VLAN
>>> ID, check the actual VLAN IDs passed in to the callback
>>> one by one as expected.
>>>
>>> Fixes: d8652956cf37 ("net: dsa: realtek-smi: Add Realtek SMI driver")
>>> Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
>>> ---
>>>  drivers/net/dsa/rtl8366.c | 12 ++++++++----
>>>  1 file changed, 8 insertions(+), 4 deletions(-)
>>>
>>> diff --git a/drivers/net/dsa/rtl8366.c b/drivers/net/dsa/rtl8366.c
>>> index ca3d17e43ed8..e2c91b75e843 100644
>>> --- a/drivers/net/dsa/rtl8366.c
>>> +++ b/drivers/net/dsa/rtl8366.c
>>> @@ -340,9 +340,11 @@ int rtl8366_vlan_prepare(struct dsa_switch *ds, int port,
>>>  {
>>>       struct realtek_smi *smi = ds->priv;
>>>       int ret;
>>> +     int i;
>>>
>>> -     if (!smi->ops->is_vlan_valid(smi, port))
>>> -             return -EINVAL;
>>> +     for (i = vlan->vid_begin; i < vlan->vid_end; i++)
>>> +             if (!smi->ops->is_vlan_valid(smi, port))
>>> +                     return -EINVAL;
>>
>> You are still checking the port and not the "i" (VLAN ID) argument here,
>> is there something I am missing?
> 
> No you're right, just correcting old mistakes by making
> new mistakes .. I'll fix, thanks!
> 
Do we need to duplicate the same is_vlan_valid() check in both the
vlan_prepare and vlan_add callbacks?
-- 
Florian

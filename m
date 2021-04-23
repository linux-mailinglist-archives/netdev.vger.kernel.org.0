Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8503336964C
	for <lists+netdev@lfdr.de>; Fri, 23 Apr 2021 17:38:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231858AbhDWPjO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 23 Apr 2021 11:39:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57890 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242868AbhDWPjL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 23 Apr 2021 11:39:11 -0400
Received: from mail-ed1-x52c.google.com (mail-ed1-x52c.google.com [IPv6:2a00:1450:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6750DC06174A
        for <netdev@vger.kernel.org>; Fri, 23 Apr 2021 08:38:32 -0700 (PDT)
Received: by mail-ed1-x52c.google.com with SMTP id z5so21423770edr.11
        for <netdev@vger.kernel.org>; Fri, 23 Apr 2021 08:38:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=NSMYinUsCajK5eYL8KInW6Mnu9Lr+mRa3SLShxOB6KY=;
        b=DzNUe3F2i3k5zl40Qz/MNF07oDwWZvPwSOqKIUjdtyQqiOl3VZorhO+8CakpvwK+qW
         l+iRl8NSRv9UNoUko/ewbJRDe9e9iNaw4ea4bNKH7qA+dPxuBpWyfOeOr9hGY0P7fSsr
         W9BA5tx9yTy/Aq1l4RlmvQD5yddJMhA7SwDA2bzS1lXirlAoHlJHpbMyE2Iz17bgiWUn
         brA3raEZbNte+dQcz1MCBg0rbvN1S6wN2RFBgdjnez2u+F0ZCYJhDvl6w/2zlkKHzl8F
         gWFIwe11s3G73Das/5zF2FdwXrk5L5vkBV03PLJe0KPMBylPYPW7UWNTWJsG/cJPR+pi
         r1Rg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=NSMYinUsCajK5eYL8KInW6Mnu9Lr+mRa3SLShxOB6KY=;
        b=eH+HEY6lF8W8TkQHJUBhb3io/nGO6zTa+qBYKo7bsQ4iNmyQbGqnEUNuy7aEB3RT66
         fUs6FsBobHPJ6ys+f7k14CR6gFS/HqCcL6GVRz2NqURj+lcjTVAIMFcfVyu2tssAB2iP
         LWMKe1mBDz+sxZJXgzHt+77QF1mzmlrjg/TdMVBET1Ohi5Bn2BILyFaA4q1GuNJ4MHI1
         z+1UcN3A9lbBL4aVPpmSaRNYl0kIaklUecighayfUNVX+iXtzUbmFwR4meaEU0CZW+2+
         cCnz4EcBbaRikxz6zOVShvU0hZJfpkWirPwBV+ARpOt95CrTXuQ3lmSfLN1MAHQ4t+P+
         rTQQ==
X-Gm-Message-State: AOAM530NUldTr5NINm2Fv0lDg01l93hU3vqnLhs+IoEwCeIMivrhOEBo
        fA44ifmkjuQCCh03buh/WEGnAHuPHyMdow==
X-Google-Smtp-Source: ABdhPJya8k1TH8R39QMI4WLMrfoT9VYJAqXOG+F5pvmgjJlw9hsEZ0vDHQRq1YSDdgZJkl2LUd7Kcw==
X-Received: by 2002:aa7:d9d7:: with SMTP id v23mr5227882eds.281.1619192310837;
        Fri, 23 Apr 2021 08:38:30 -0700 (PDT)
Received: from ?IPv6:2003:ea:8f38:4600:70d4:4753:f0ec:4620? (p200300ea8f38460070d44753f0ec4620.dip0.t-ipconnect.de. [2003:ea:8f38:4600:70d4:4753:f0ec:4620])
        by smtp.googlemail.com with ESMTPSA id n10sm4115939ejg.124.2021.04.23.08.38.27
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 23 Apr 2021 08:38:30 -0700 (PDT)
Subject: Re: [RFC net-next] net: stmmac: should not modify RX descriptor when
 STMMAC resume
To:     Jon Hunter <jonathanh@nvidia.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Joakim Zhang <qiangqing.zhang@nxp.com>,
        "peppe.cavallaro@st.com" <peppe.cavallaro@st.com>,
        "alexandre.torgue@foss.st.com" <alexandre.torgue@foss.st.com>,
        "joabreu@synopsys.com" <joabreu@synopsys.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "mcoquelin.stm32@gmail.com" <mcoquelin.stm32@gmail.com>,
        "andrew@lunn.ch" <andrew@lunn.ch>
Cc:     dl-linux-imx <linux-imx@nxp.com>,
        "treding@nvidia.com" <treding@nvidia.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
References: <20210419115921.19219-1-qiangqing.zhang@nxp.com>
 <f00e1790-5ba6-c9f0-f34f-d8a39c355cd7@nvidia.com>
 <DB8PR04MB67954D37A59B2D91C69BF6A9E6489@DB8PR04MB6795.eurprd04.prod.outlook.com>
 <cec17489-2ef9-7862-94c8-202d31507a0c@nvidia.com>
 <DB8PR04MB67953A499438FF3FF6BE531BE6469@DB8PR04MB6795.eurprd04.prod.outlook.com>
 <2cf60306-e2b9-cc24-359c-774c9d339074@gmail.com>
 <9abe58c4-a788-e07d-f281-847ee5b9fcf3@nvidia.com>
 <22bf351b-3f01-db62-8185-7a925f19998e@gmail.com>
 <bd184c72-7b12-db4c-0dd3-25f0fd45b7aa@nvidia.com>
 <3ba28b13-15eb-85bd-0625-f99450c8341b@gmail.com>
 <0e6467a0-428a-6520-f012-bdd332a7d7ee@nvidia.com>
From:   Heiner Kallweit <hkallweit1@gmail.com>
Message-ID: <f8f9f335-0a2d-5fd6-1e9e-6caa70abc0ad@gmail.com>
Date:   Fri, 23 Apr 2021 17:38:21 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.0
MIME-Version: 1.0
In-Reply-To: <0e6467a0-428a-6520-f012-bdd332a7d7ee@nvidia.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 23.04.2021 15:46, Jon Hunter wrote:
> 
> On 22/04/2021 19:20, Florian Fainelli wrote:
>>
>>
>> On 4/22/2021 11:18 AM, Jon Hunter wrote:
>>>
>>> On 22/04/2021 18:32, Florian Fainelli wrote:
>>>>
>>>>
>>>> On 4/22/2021 10:00 AM, Jon Hunter wrote:
>>>>>
>>>>> On 22/04/2021 17:12, Florian Fainelli wrote:
>>>>>
>>>>> ...
>>>>>
>>>>>> What does the resumption failure looks like? Does the stmmac driver
>>>>>> successfully resume from your suspend state, but there is no network
>>>>>> traffic? Do you have a log by any chance?
>>>>>
>>>>> The board fails to resume and appears to hang. With regard to the
>>>>> original patch I did find that moving the code to re-init the RX buffers
>>>>> to before the PHY is enabled did work [0].
>>>>
>>>> You indicated that you are using a Broadcom PHY, which specific PHY are
>>>> you using?
>>>>
>>>> I suspect that the stmmac is somehow relying on the PHY to provide its
>>>> 125MHz RXC clock back to you in order to have its RX logic work correctly.
>>>>
>>>> One difference between using the Broadcom PHY and the Generic PHY
>>>> drivers could be whether your Broadcom PHY driver entry has a
>>>> .suspend/.resume callback implemented or not.
>>>
>>>
>>> This board has a BCM89610 and uses the drivers/net/phy/broadcom.c
>>> driver. Interestingly I don't see any suspend/resume handlers for this phy.
>>
>> Now if you do add .suspend = genphy_suspend and .resume = bcm54xx_resume
>> for this PHY entry does it work better?
> 
> Thanks for the suggestion. I tried this and this appears to breaking
> networking altogether. In other words, the board was not longer able to
> request an IP address. I also tried the genphy_resume and the board was
> able to get an IP address, but it is still unable to resume from suspend.
> 
Maybe MDIO bus PM and MAC driver PM interfere. Following changes dealt
with such an issue with the fec driver and a specific PHY model.

fba863b81604 ("net: phy: make PHY PM ops a no-op if MAC driver manages PHY PM")
557d5dc83f68 ("net: fec: use mac-managed PHY PM")

If stmmac suspend/resume take care also of PHY pm, you may try a similar
change in stmmac.


> Thanks
> Jon
> 
Heiner

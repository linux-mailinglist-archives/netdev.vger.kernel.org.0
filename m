Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8E96D339482
	for <lists+netdev@lfdr.de>; Fri, 12 Mar 2021 18:17:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232138AbhCLRRE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 12 Mar 2021 12:17:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38942 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232506AbhCLRQk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 12 Mar 2021 12:16:40 -0500
Received: from mail-pj1-x1030.google.com (mail-pj1-x1030.google.com [IPv6:2607:f8b0:4864:20::1030])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D6935C061574
        for <netdev@vger.kernel.org>; Fri, 12 Mar 2021 09:16:39 -0800 (PST)
Received: by mail-pj1-x1030.google.com with SMTP id lr1-20020a17090b4b81b02900ea0a3f38c1so3541283pjb.0
        for <netdev@vger.kernel.org>; Fri, 12 Mar 2021 09:16:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=IKITGBE6e3sPfJcMwIkG1ZNZolzfLTaMWhJ62y6wqdc=;
        b=r+4zSwulH1IuUezXSRZ00iJ2cl4E8PHapKE2KXMSidvvLiqE9mOp7Y2BL/vSdiacOo
         rBzY0FZbZC6mGJ9lvIjNUhMhfo40saxITY84Vg/VOr0Ud8ZgCGHMYtoR3p/aRDoOWEAq
         cJkiZ/oaVxcdqYZgv2zZh0GxiMmYga03FEtRfGJHWnKWcYQcy+cHjOgwAmtg9woHdYQv
         rwcZpWUBgxENBlZbEKz12vheKstHCyGzpsCM4re856p00zK6uV2UTtXdCHS+4C4gC/a+
         ut+6msBhtDKofjg2a6cHIC/QZ/NjtzwJQy0qvVctcCAMXzd9auLlZeZo6izTJ5D7z5is
         v36A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=IKITGBE6e3sPfJcMwIkG1ZNZolzfLTaMWhJ62y6wqdc=;
        b=XclN3U+L3Z/Ucrk5j6Iwxhs9xvUYQTSRpUraEfWvqxl5ogAFdjmWlvKS5LbyWlWE/R
         4ZRFYl2xCvhbVUCUgsuwi9PvYzZJxRzLLXXMWLQmMGnl4wo1Gs4tE8+5iwjXUry5+zfV
         Cuwclea1dOpRni9Wz0OEJxN/Rc6OU2qc7JasuIr/N0JFyhQ0a9O1qXmhO+lINzq1ug9g
         Km7qMZ+F6QKjL5R55K0JstrroY+3BvvTRziS96a7A8Bsx1C2raZsrcMFtBp7bJ99Q0Ko
         FOGJfkT0qdFtp909N1k2Fry9x91VpAosfoJR0Ro4yTX2tEpnMEjIn9jUR9JvmaMAQWqZ
         eXjw==
X-Gm-Message-State: AOAM531T9vlZEnQtqtbtB8nDSyl8y/vpwi35UE3o77f3iTL/t1dIeX2C
        bhvp1WI1+Zs2CHgtcFlh/IQ=
X-Google-Smtp-Source: ABdhPJzr1jFtznQ5AyVxNJCtL1zQLgU3Ipec2BMYToxmE8URa5n2JwWwnvOgMr18JuaFGsmn8RLpiw==
X-Received: by 2002:a17:90a:ad87:: with SMTP id s7mr15607201pjq.20.1615569399312;
        Fri, 12 Mar 2021 09:16:39 -0800 (PST)
Received: from [10.67.49.104] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id 1sm6348266pfh.90.2021.03.12.09.16.37
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 12 Mar 2021 09:16:38 -0800 (PST)
Subject: Re: [PATCH] net: dsa: bcm_sf2: setup BCM4908 internal crossbar
To:     =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        bcm-kernel-feedback-list@broadcom.com,
        =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <rafal@milecki.pl>
References: <20210310115951.14565-1-zajec5@gmail.com>
 <dafc2ec7-871b-3ddc-d094-400055e81e4c@gmail.com>
 <6727ac96-b004-f1f3-10c0-32f96dfe9f0c@gmail.com>
 <a6700669-5260-2d70-65a2-66c8cbfc6881@gmail.com>
 <c6c36617-dc16-ccb5-6760-ed660eb19b5b@gmail.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <f0c5da8e-17a5-f20f-bc21-e92b6b292081@gmail.com>
Date:   Fri, 12 Mar 2021 09:16:37 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.1
MIME-Version: 1.0
In-Reply-To: <c6c36617-dc16-ccb5-6760-ed660eb19b5b@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 3/12/21 2:01 AM, Rafał Miłecki wrote:
> On 11.03.2021 23:13, Florian Fainelli wrote:
>> On 3/11/21 2:04 PM, Rafał Miłecki wrote:
>>> On 10.03.2021 18:19, Florian Fainelli wrote:
>>>> On 3/10/21 3:59 AM, Rafał Miłecki wrote:
>>>>> From: Rafał Miłecki <rafal@milecki.pl>
>>>>>
>>>>> On some SoCs (e.g. BCM4908, BCM631[345]8) SF2 has an integrated
>>>>> crossbar. It allows connecting its selected external ports to
>>>>> internal ports. It's used by vendors to handle custom Ethernet
>>>>> setups.
>>>>>
>>>>> BCM4908 has following 3x2 crossbar. On Asus GT-AC5300 rgmii is
>>>>> used for connecting external BCM53134S switch. GPHY4 is usually
>>>>> used for WAN port. More fancy devices use SerDes for 2.5 Gbps
>>>>> Ethernet.
>>>>>
>>>>> ┌──────────┐ SerDes ─── 0 ─┤          │ │   3x2    ├─ 0 ───
>>>>> switch port 7 GPHY4 ─── 1 ─┤          │ │ crossbar ├─ 1 ───
>>>>> runner (accelerator) rgmii ─── 2 ─┤          │ └──────────┘
>>>>>
>>>>> Use setup data based on DT info to configure BCM4908's switch
>>>>> port 7. Right now only GPHY and rgmii variants are supported.
>>>>> Handling SerDes can be implemented later.
>>>>>
>>>>> Signed-off-by: Rafał Miłecki <rafal@milecki.pl> ---
>>>>> drivers/net/dsa/bcm_sf2.c      | 41
>>>>> ++++++++++++++++++++++++++++++++++ drivers/net/dsa/bcm_sf2.h
>>>>> |  1 + drivers/net/dsa/bcm_sf2_regs.h |  7 ++++++ 3 files
>>>>> changed, 49 insertions(+)
>>>>>
>>>>> diff --git a/drivers/net/dsa/bcm_sf2.c
>>>>> b/drivers/net/dsa/bcm_sf2.c index 8f50e91d4004..b4b36408f069
>>>>> 100644 --- a/drivers/net/dsa/bcm_sf2.c +++
>>>>> b/drivers/net/dsa/bcm_sf2.c @@ -432,6 +432,40 @@ static int
>>>>> bcm_sf2_sw_rst(struct bcm_sf2_priv *priv) return 0; } +static
>>>>> void bcm_sf2_crossbar_setup(struct bcm_sf2_priv *priv) +{ +
>>>>> struct device *dev = priv->dev->ds->dev; +    int shift; +    u32
>>>>> mask; +    u32 reg; +    int i; + +    reg = 0;
>>>>
>>>> I believe you need to do a read/modify/write here otherwise you
>>>> are clobbering the other settings for the p_wan_link_status and
>>>> p_wan_link_sel bits.
>>>
>>> Thanks, I didn't know about those bits.
>>>
>>>
>>>>> +    switch (priv->type) { +    case BCM4908_DEVICE_ID: +
>>>>> shift = CROSSBAR_BCM4908_INT_P7 * priv->num_crossbar_int_ports; +
>>>>> if (priv->int_phy_mask & BIT(7)) +            reg |=
>>>>> CROSSBAR_BCM4908_EXT_GPHY4 << shift; +        else if (0) /*
>>>>> FIXME */ +            reg |= CROSSBAR_BCM4908_EXT_SERDES <<
>>>>> shift; +        else
>>>>
>>>> Maybe what you can do is change bcm_sf2_identify_ports() such that
>>>> when the 'phy-interface' property is retrieved from Device Tree, we
>>>> also store the 'mode' variable into the per-port structure
>>>> (bcm_sf2_port_status) and when you call bcm_sf2_crossbar_setup()
>>>> for each port that has been setup, and you update the logic to look
>>>> like this:
>>>>
>>>> if (priv->int_phy_mask & BIT(7)) reg |= CROSSBAR_BCM4908_EXT_GPHY4
>>>> << shift; else if (phy_interface_mode_is_rgmii(mode)) reg |=
>>>> CROSSBAR_BCM4908_EXT_RGMII
>>>>
>>>> and we add support for SerDes when we get to that point. This would
>>>> also allow you to detect if an invalid configuration is specified
>>>> via Device Tree.
>>>
>>> Sounds great, but I experienced a problem while trying to implement
>>> that.
>>>
>>> On Asus GT-AC5300 I have:
>>>
>>> /* External BCM53134S switch */ port@7 { label = "sw"; reg = <7>;
>>>
>>> fixed-link { speed = <1000>; full-duplex; }; };
>>>
>>> after adding phy-mode = "rgmii"; to it, my PHYs stop working because
>>> of SF2.
>>>
>>> bcm_sf2_sw_mac_link_up() calls: bcm_sf2_sw_mac_link_set(ds, 7,
>>> PHY_INTERFACE_MODE_RGMII, true); which results in setting
>>> RGMII_MODE_EN bit in the REG_RGMII_CNTRL_P(7).
>>>
>>> For some reason setting above bit results in stopping internal PHYs.
>>> unimac_mdio_read() starts getting MDIO_READ_FAIL.
>>>
>>> Do you have any idea why it happens?
>>
>> RGMII_MODE_EN enables the RGMII data pad, but this usually has no
>> incidence on the MDIO which is separate, unless there is something I do
>> not understand about how the crossbar works.
> 
> REG_RGMII_CNTRL_P() macro usage is broken. It can be called with
> arguments 0, 1 and 2 only.

Oh that's right, yes, none of the chips I have had access to had more
than 3 RGMII ports.

> 
> For port 7, REG_RGMII_CNTRL_P(7) returns offset exceeding array size
> and causes bcm_sf2_sw_mac_config() and bcm_sf2_sw_mac_link_set() to
> access random registers.

There is no a SWITCH_REG_RGMII_7_CNTRL register offset defined in fact
there is no offset for ports 0, 1 or 2, there is a
SWITCH_REG_RGMII_11_CNTRL which is at offset 0x14c from the start of
SWITCH_REG. So yes, you would definitively overrun the
bcm_sf2_4908_reg_offsets() array.
-- 
Florian

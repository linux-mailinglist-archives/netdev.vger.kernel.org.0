Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EA97136A347
	for <lists+netdev@lfdr.de>; Sat, 24 Apr 2021 23:49:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231458AbhDXVuV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 24 Apr 2021 17:50:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53234 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229778AbhDXVuU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 24 Apr 2021 17:50:20 -0400
Received: from mail-ej1-x629.google.com (mail-ej1-x629.google.com [IPv6:2a00:1450:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0BB22C061574;
        Sat, 24 Apr 2021 14:49:42 -0700 (PDT)
Received: by mail-ej1-x629.google.com with SMTP id u3so110710eja.12;
        Sat, 24 Apr 2021 14:49:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=to:cc:references:from:subject:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=9zBOH67TcxSCIlOkEt/A577wH0/U00RQGBXJyvaiY8s=;
        b=l/zgWa3S/73rHedDFs72ZWvsAkNvqqYxGmOPBqSInAc4RUarhcoULzwviy7j/ukDE2
         fLovZILz71LNzzi2sV1tdkDqZiwqWgw2rMI2G2yTDCcgV/a296qyw23B1+6XP6xT58nk
         /AuBcMfLpgi/Diz6IQvTjbNntqrbJ3F/ncQ1YCuTui1zqH9VVcJdtY/JLDaFnFRKQ9S7
         n2qYJG8JEL7NXQb7N0udummxvhHL2jkS6Zbhia4D/vaF5U2Yd4tupkZ8FF92K28Od4Bh
         PfBvxXNsSm0mI0X/rUOBoZ32F6eOXhXdi5hyTn4x8UtqXxUCo5jgiuDvCk+pj9MXdPME
         UGNg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:cc:references:from:subject:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=9zBOH67TcxSCIlOkEt/A577wH0/U00RQGBXJyvaiY8s=;
        b=gc2tndbkldHw/CcPBGpjsV9S6qGFpsZ0FI49tWbbIXEs5vL5M6x5T0E42hSttMRmZ2
         qBzB0HqaOEQw9or5SAxfbqBigBJZ5xwd8aKayZulaSDZY4BRGrU4iQOx6qvM5YSLtEMX
         6foFtjTNiFoYxzvBClgGfXU9VnTtp/qktWd7oETs16Qn3rCrnQ/tgI225mVl1euwGA1N
         wPsNucl+f0oJ/DCklHq3V2Unpap3JoxlHcshiKdMUJSaOxQZJrgGhQyWi9kKw/ZC8u+R
         GgioXdEVi/pTBXtLT1ASVo2sS0KOK4CYGhvcGYX90KNxpKpyIPN3s88D8ZBy9Den0gGD
         TLng==
X-Gm-Message-State: AOAM5327jQGXGSI21gBJWLOSqzku5DZ98SaLAopHkXuf1+BKGoIgPP83
        Wu83X5dLPgbIGwBIxR8WUuAoo0kbPfab/w==
X-Google-Smtp-Source: ABdhPJzqHu1EqvKezfc6NeQxqO3YyHeEekHwiviaB5gTWD80mXPafGP3hgrq9dV/jpB8POgg94InQg==
X-Received: by 2002:a17:906:2746:: with SMTP id a6mr10545524ejd.265.1619300980546;
        Sat, 24 Apr 2021 14:49:40 -0700 (PDT)
Received: from ?IPv6:2003:ea:8f38:4600:d4b:63c:654f:4f21? (p200300ea8f3846000d4b063c654f4f21.dip0.t-ipconnect.de. [2003:ea:8f38:4600:d4b:63c:654f:4f21])
        by smtp.googlemail.com with ESMTPSA id g11sm9992423edt.35.2021.04.24.14.49.39
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 24 Apr 2021 14:49:40 -0700 (PDT)
To:     Ansuel Smith <ansuelsmth@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Russell King <linux@armlinux.org.uk>, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20210423014741.11858-1-ansuelsmth@gmail.com>
 <20210423014741.11858-12-ansuelsmth@gmail.com>
 <e644aba9-a092-3825-b55b-e0cca158d28b@gmail.com>
 <YISLHNK8binc9T1N@Ansuel-xps.localdomain>
From:   Heiner Kallweit <hkallweit1@gmail.com>
Subject: Re: [PATCH 11/14] drivers: net: dsa: qca8k: apply switch revision fix
Message-ID: <16092d86-30be-da60-b366-9316798da636@gmail.com>
Date:   Sat, 24 Apr 2021 23:49:26 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.0
MIME-Version: 1.0
In-Reply-To: <YISLHNK8binc9T1N@Ansuel-xps.localdomain>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 24.04.2021 23:18, Ansuel Smith wrote:
> On Thu, Apr 22, 2021 at 07:02:37PM -0700, Florian Fainelli wrote:
>>
>>
>> On 4/22/2021 6:47 PM, Ansuel Smith wrote:
>>> qca8k require special debug value based on the switch revision.
>>>
>>> Signed-off-by: Ansuel Smith <ansuelsmth@gmail.com>
>>> ---
>>>  drivers/net/dsa/qca8k.c | 23 +++++++++++++++++++++--
>>>  1 file changed, 21 insertions(+), 2 deletions(-)
>>>
>>> diff --git a/drivers/net/dsa/qca8k.c b/drivers/net/dsa/qca8k.c
>>> index 193c269d8ed3..12d2c97d1417 100644
>>> --- a/drivers/net/dsa/qca8k.c
>>> +++ b/drivers/net/dsa/qca8k.c
>>> @@ -909,7 +909,7 @@ qca8k_phylink_mac_config(struct dsa_switch *ds, int port, unsigned int mode,
>>>  {
>>>  	const struct qca8k_match_data *data;
>>>  	struct qca8k_priv *priv = ds->priv;
>>> -	u32 reg, val;
>>> +	u32 phy, reg, val;
>>>  
>>>  	/* get the switches ID from the compatible */
>>>  	data = of_device_get_match_data(priv->dev);
>>> @@ -928,7 +928,26 @@ qca8k_phylink_mac_config(struct dsa_switch *ds, int port, unsigned int mode,
>>>  	case 3:
>>>  	case 4:
>>>  	case 5:
>>> -		/* Internal PHY, nothing to do */
>>> +		/* Internal PHY, apply revision fixup */
>>> +		phy = qca8k_port_to_phy(port) % PHY_MAX_ADDR;
>>> +		switch (priv->switch_revision) {
>>> +		case 1:
>>> +			/* For 100M waveform */
>>> +			qca8k_phy_dbg_write(priv, phy, 0, 0x02ea);
>>> +			/* Turn on Gigabit clock */
>>> +			qca8k_phy_dbg_write(priv, phy, 0x3d, 0x68a0);
>>> +			break;
>>> +
>>> +		case 2:
>>> +			qca8k_phy_mmd_write(priv, phy, 0x7, 0x3c, 0x0);

Please replace the magic numbers with constants. Here even standard
registers are used: 0x7 = MDIO_MMD_AN, 0x3c = MDIO_AN_EEE_ADV
Effectively EEE advertisement is disabled.

>>> +			fallthrough;
>>> +		case 4:
>>> +			qca8k_phy_mmd_write(priv, phy, 0x3, 0x800d, 0x803f);
>>> +			qca8k_phy_dbg_write(priv, phy, 0x3d, 0x6860);
>>> +			qca8k_phy_dbg_write(priv, phy, 0x5, 0x2c46);
>>> +			qca8k_phy_dbg_write(priv, phy, 0x3c, 0x6000);
>>> +			break;
>>
>> This would be better done with a PHY driver that is specific to the
>> integrated PHY found in these switches, it would provide a nice clean
>> layer and would allow you to expose additional features like cable
>> tests, PHY statistics/counters, etc.
> 
> I'm starting to do some work with this and a problem arised. Since these
> value are based on the switch revision, how can I access these kind of
> data from the phy driver? It's allowed to declare a phy driver in the
> dsa directory? (The idea would be to create a qca8k dir with the dsa
> driver and the dedicated internal phy driver.) This would facilitate the
> use of normal qca8k_read/write (to access the switch revision from the
> phy driver) using common function?
> 

PHY drivers reside under drivers/net/phy. Not sure whether your internal
PHY's have a proper PHY ID, you could assign pseudo PHY ID's differing
per switch revision. See mv88e6xxx_mdio_read() for a similar use case.

>> -- 
>> Florian

Heiner

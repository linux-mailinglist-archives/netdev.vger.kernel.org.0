Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B85C92E7757
	for <lists+netdev@lfdr.de>; Wed, 30 Dec 2020 10:13:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726289AbgL3JMu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Dec 2020 04:12:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32934 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725853AbgL3JMu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 30 Dec 2020 04:12:50 -0500
Received: from mail-wr1-x42e.google.com (mail-wr1-x42e.google.com [IPv6:2a00:1450:4864:20::42e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A8400C061799;
        Wed, 30 Dec 2020 01:12:09 -0800 (PST)
Received: by mail-wr1-x42e.google.com with SMTP id i9so16881528wrc.4;
        Wed, 30 Dec 2020 01:12:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=8ekrnEEYbjcIXjRJtiDhNnEgbPzrjHFldSjZZcj6FOs=;
        b=m5nqFSSme1U5mz2pc+EE+ZCuS0LDJXlQhowBFui2jnCwcEHlPnjiWaylwc0RTsXHIt
         XLE+pNBUGlu1OQYwWUuigkl8RZ3P+zIQcoEM1UtzsO80jBX2nOAcRIRZEvU/Wh4YlpuM
         pTcthZkCVDrrRUDn4ylbl66WUXjN9J7xPiS/+ZK30xjmcTx+49zVlhu5ogHCYqyZ31An
         VRuvJyx+JRqutwn4wh9oGKmOMR4MpNML9mgUxt+iEAYZIUhr2cN0dE60AOh5ijdVFdNm
         6CjO9qfADirWBuzp7JtknvGscaT6lzi698H5scfVa5cW9NVJNvVxeC6chSETzA1rmtrQ
         c2Lg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=8ekrnEEYbjcIXjRJtiDhNnEgbPzrjHFldSjZZcj6FOs=;
        b=QFirN3ttUOQs7OD+GB39ASavfgx8psBbKws/26FbC2MTi3SOUX0QUjeXrJQwW5ejt4
         nSrCsVH2e+/R5jgihWQUwLpxUtIuFgSpuiEex9GweRo35Y4zziC2RIlV0oIedCNnDF9j
         6Nryr/4M5av9fOp5F4jv/sP97kDsC9HumlZBWw5miqgq2FBLUIeV+aqO1VCDTqxM0NQ/
         nI53X89KE2sAqO3kiWCAdK+YwV6fsQ7EtSg9bkbYgcmjdJcrfgiWorUYJtF3Zxldzf9m
         Wi0dWxR/bVxA3ox/ekHX61MUKkBozywSz5a9rdC8WaORVd6s9oH+IbMgahX+mT7gXyjI
         0QuA==
X-Gm-Message-State: AOAM533PFiM8YJwD8UKn3lh0RuSU1doHKKPwdonmIvt+4v349LLWgg8t
        4fZ5GYDsqFu5EGtZ23xEsdQ=
X-Google-Smtp-Source: ABdhPJwUZmDcgVqcqV1ynk9l74skzyV33FJBETqJiDqDPUM5Qdi6DMFGDDiSDr9+guJgdhLU1ZmKKQ==
X-Received: by 2002:adf:e84c:: with SMTP id d12mr61675201wrn.382.1609319528231;
        Wed, 30 Dec 2020 01:12:08 -0800 (PST)
Received: from ?IPv6:2003:ea:8f06:5500:40d3:8504:24f3:bef8? (p200300ea8f06550040d3850424f3bef8.dip0.t-ipconnect.de. [2003:ea:8f06:5500:40d3:8504:24f3:bef8])
        by smtp.googlemail.com with ESMTPSA id l8sm6550598wmf.35.2020.12.30.01.12.06
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 30 Dec 2020 01:12:07 -0800 (PST)
Subject: Re: Registering IRQ for MT7530 internal PHYs
To:     DENG Qingfang <dqfext@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Landen Chao <Landen.Chao@mediatek.com>,
        Marc Zyngier <maz@kernel.org>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Russell King <linux@armlinux.org.uk>,
        Sean Wang <sean.wang@mediatek.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        linux-kernel@vger.kernel.org, netdev <netdev@vger.kernel.org>,
        Weijie Gao <weijie.gao@mediatek.com>,
        Chuanhong Guo <gch981213@gmail.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        =?UTF-8?Q?Ren=c3=a9_van_Dorst?= <opensource@vdorst.com>
References: <20201230042208.8997-1-dqfext@gmail.com>
 <a64312eb-8b4c-d6d4-5624-98f55e33e0b7@gmail.com>
 <CALW65jbV-RwbmmiGjfq8P-ZcApOW0YyN6Ez5FvhhP4dgaA+VjQ@mail.gmail.com>
From:   Heiner Kallweit <hkallweit1@gmail.com>
Message-ID: <fa7951e1-4a98-8488-d724-3eda9b97e376@gmail.com>
Date:   Wed, 30 Dec 2020 10:12:03 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.0
MIME-Version: 1.0
In-Reply-To: <CALW65jbV-RwbmmiGjfq8P-ZcApOW0YyN6Ez5FvhhP4dgaA+VjQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 30.12.2020 10:07, DENG Qingfang wrote:
> Hi Heiner,
> Thanks for your reply.
> 
> On Wed, Dec 30, 2020 at 3:39 PM Heiner Kallweit <hkallweit1@gmail.com> wrote:
>> I don't think that's the best option.
> 
> I'm well aware of that.
> 
>> You may want to add a PHY driver for your chip. Supposedly it
>> supports at least PHY suspend/resume. You can use the RTL8366RB
>> PHY driver as template.
> 
> There's no MediaTek PHY driver yet. Do we really need a new one just
> for the interrupts?
> 
Not only for the interrupts. The genphy driver e.g. doesn't support
PHY suspend/resume. And the PHY driver needs basically no code,
just set the proper callbacks.

>>> +     dev_info_ratelimited(priv->dev, "interrupt status: 0x%08x\n", val);
>>> +     dev_info_ratelimited(priv->dev, "interrupt enable: 0x%08x\n", mt7530_read(priv, MT7530_SYS_INT_EN));
>>> +
>> This is debug code to be removed in the final version?
> 
> Yes.
> 
>>> +     for (phy = 0; phy < MT7530_NUM_PHYS; phy++) {
>>> +             if (val & BIT(phy)) {
>>> +                     unsigned int child_irq;
>>> +
>>> +                     child_irq = irq_find_mapping(priv->irq_domain, phy);
>>> +                     handle_nested_irq(child_irq);
>>> +                     handled = true;
>>> +             }
>>> +     }
>>> +
>>> +     return handled ? IRQ_HANDLED : IRQ_NONE;
>>
>> IRQ_RETVAL() could be used here.
> 
> Good to know :)
> 
>>
>>> +}
>>> +
>>> +static void mt7530_irq_mask(struct irq_data *d)
>>> +{
>>> +     struct mt7530_priv *priv = irq_data_get_irq_chip_data(d);
>>> +
>>> +     priv->irq_enable &= ~BIT(d->hwirq);
>>
>> Here you don't actually do something. HW doesn't support masking
>> interrupt generation for a port?
> 
> priv->irq_enable will be written to MT7530_SYS_INT_EN in
> mt7530_irq_bus_sync_unlock. You can think of it as an inverted mask.
> 


Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A91536C85A1
	for <lists+netdev@lfdr.de>; Fri, 24 Mar 2023 20:10:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231499AbjCXTJ4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Mar 2023 15:09:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57036 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231411AbjCXTJz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Mar 2023 15:09:55 -0400
Received: from mail-pj1-x102e.google.com (mail-pj1-x102e.google.com [IPv6:2607:f8b0:4864:20::102e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1E09A1A97B
        for <netdev@vger.kernel.org>; Fri, 24 Mar 2023 12:09:52 -0700 (PDT)
Received: by mail-pj1-x102e.google.com with SMTP id j13so2330450pjd.1
        for <netdev@vger.kernel.org>; Fri, 24 Mar 2023 12:09:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1679684992;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=co5GKiPzMgUl5Wio5Nd1/l8Qu4hXksKONH3QUOeWg7g=;
        b=QKxZBG93/3zGmcZHn+8Sthws91y7Xub/LeP5XPEL9PWCEIIVwsFNwPEiXWikqPBJs4
         IBzwk6bfSvkibF7OIYEFs/TGsex9T3VOBSijL+6/gnZhVpnm7gtXvqskEldSw8oJwrlF
         EPKF6hfwu59ITvdVCTq7DdB10yVNsj2vV36DxkBPAwRNEjNcZivDclpHYhHdShFQKVfN
         7OzpXjVt/v5BZxB2b0/8HLIIgNryMy4LPC9OwuI4iJsrG4T7sBO4exaDT9fu2/KNXBk6
         Xh38jXssdbkpzTyrzTErmIeG0ZB+a3Y2Y2ZKQrvYs8T12y9YL/xJy5CmoADI4xGJ4ZVi
         Y4Bw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679684992;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=co5GKiPzMgUl5Wio5Nd1/l8Qu4hXksKONH3QUOeWg7g=;
        b=PxpMcyCOkVKOSyfGF9Jtl1LsHAoRi0rH4LsRNWcXbl8NIAlSRmQd1K4WkllnH7cRnV
         EjtXkMKd3EXbihZ6CrTr+IRKmk8QZYrX8/WqhFEERpQrX/06pVHxJ0gGqIlklW/6BqIJ
         R8zf0I/U3sT+OPpVL+gK9NjVhloxPQrIBBJgs+LsHRWk/k7PX8HPFDdC+h1HwbW/+aBO
         cZCnxRHCcjXyABbvz6aZjZX+6POmDgrJK9Hu6XjVRRdAj6xzkA0KLB+Qx2iSaA9RaZ0s
         6lUmIERPdg05litUUtxBNq6L4cGY2Iz7oOmxSr3yAL0CrMYG96/0fo4mmO7ZfqKO32//
         4QSg==
X-Gm-Message-State: AAQBX9dTLY54P9/m1O0j2gY0nQ9elefnka4IVJ2GFsBTh0QsUH2DJiJ2
        rikXTo8PcJeMOPWaOfOTEJiZkIZpZpc=
X-Google-Smtp-Source: AKy350b8pcGPqNax4XrmwUJTdlgCQ19N5Q3XND45SlpNOpegf664PHCRORowrmi3PQswSV88FRpu/g==
X-Received: by 2002:a17:903:110e:b0:1a1:f5dd:2dd5 with SMTP id n14-20020a170903110e00b001a1f5dd2dd5mr4921374plh.13.1679684992414;
        Fri, 24 Mar 2023 12:09:52 -0700 (PDT)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id jh5-20020a170903328500b0019f3cc463absm14633151plb.0.2023.03.24.12.09.46
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 24 Mar 2023 12:09:51 -0700 (PDT)
Message-ID: <e703abb1-e92e-5ad3-f3d9-5c4d22c8125c@gmail.com>
Date:   Fri, 24 Mar 2023 12:09:43 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.1
Subject: Re: [PATCH net-next 2/4] net: phy: smsc: remove getting reference
 clock
Content-Language: en-US
To:     Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Russell King - ARM Linux <linux@armlinux.org.uk>,
        Jakub Kicinski <kuba@kernel.org>,
        David Miller <davem@davemloft.net>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>,
        Broadcom internal kernel review list 
        <bcm-kernel-feedback-list@broadcom.com>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
References: <0c529488-0fd8-19e1-c5a9-9cf1fab78ed3@gmail.com>
 <00ff6ad6-4554-2ce5-32ba-de47dcfcd81b@gmail.com>
 <efe84928-e4fc-aca3-d6ac-7ba08fe4a705@gmail.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <efe84928-e4fc-aca3-d6ac-7ba08fe4a705@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 3/24/23 12:07, Florian Fainelli wrote:
> On 3/24/23 11:03, Heiner Kallweit wrote:
>> Now that getting the reference clock has been moved to phylib,
>> we can remove it here.
>>
>> Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
>> ---
>>   drivers/net/phy/smsc.c | 9 +--------
>>   1 file changed, 1 insertion(+), 8 deletions(-)
>>
>> diff --git a/drivers/net/phy/smsc.c b/drivers/net/phy/smsc.c
>> index 730964b85..48654c684 100644
>> --- a/drivers/net/phy/smsc.c
>> +++ b/drivers/net/phy/smsc.c
>> @@ -278,7 +278,6 @@ int smsc_phy_probe(struct phy_device *phydev)
>>   {
>>       struct device *dev = &phydev->mdio.dev;
>>       struct smsc_phy_priv *priv;
>> -    struct clk *refclk;
>>       priv = devm_kzalloc(dev, sizeof(*priv), GFP_KERNEL);
>>       if (!priv)
>> @@ -291,13 +290,7 @@ int smsc_phy_probe(struct phy_device *phydev)
>>       phydev->priv = priv;
>> -    /* Make clk optional to keep DTB backward compatibility. */
>> -    refclk = devm_clk_get_optional_enabled(dev, NULL);
>> -    if (IS_ERR(refclk))
>> -        return dev_err_probe(dev, PTR_ERR(refclk),
>> -                     "Failed to request clock\n");
>> -
>> -    return clk_set_rate(refclk, 50 * 1000 * 1000);
>> +    return clk_set_rate(phydev->refclk, 50 * 1000 * 1000);
> 
> AFAIR one should be calling clk_prepare_enable() before clk_set_rate(), 
> which neither smsc.c nor micrel.c do.

Which is implied by the devm_clk_get_optional_enabled().
-- 
Florian


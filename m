Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CB5AF5847CF
	for <lists+netdev@lfdr.de>; Thu, 28 Jul 2022 23:44:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229801AbiG1Voy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Jul 2022 17:44:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32874 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229436AbiG1Vox (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 Jul 2022 17:44:53 -0400
Received: from mail-pj1-x1035.google.com (mail-pj1-x1035.google.com [IPv6:2607:f8b0:4864:20::1035])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C3AD672EF3;
        Thu, 28 Jul 2022 14:44:52 -0700 (PDT)
Received: by mail-pj1-x1035.google.com with SMTP id a7-20020a17090a008700b001f325db8b90so1999765pja.0;
        Thu, 28 Jul 2022 14:44:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc;
        bh=sYzAr8lgaXAXDF+gl1uR3mk+XI3NGskm/8fxdmGspG4=;
        b=QtKVbp9zPcljnP+k9V8pqj3I+4hQSA82o66hVspm7+Bh9poLT1VUph6O4hEwmrI6+C
         kziPfmMpyuRab+letNRaLthoKAN2/sAdnvyVoPs9QRnLB58ypGnOyv/4w3H2PlVfLYWH
         ezg7ODke7Naf2XBkLCQSUtNuXJns9dUO8ni/jdNRboQ63CgM4O18eoyhjb+TCH1MF2ZJ
         uKj2VD8IwOu6AASIZvwqazFKwBA4qjodbHbEkgrDqbgyhBI4FBTMmnJiBayLmwHll2dL
         fTDR2TIXOTBYB5saFdeDnKGavU4uUYrbN3OoQi7S1anfTE5E9pBX7mgpnq4eEbT5f+zt
         Vfxg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc;
        bh=sYzAr8lgaXAXDF+gl1uR3mk+XI3NGskm/8fxdmGspG4=;
        b=qp8cJ4FAjC83VdoNZJMPNc8fSd/yh8fyGqsIPfYAx78E07MF8cd9P8REJaEeyL+dj8
         /RKxPmG8m6rh61qznT4dKTAPgasyZKgw8VJ4ptpwhc83bu2hxAUIePXnI9L9SvWGO/+c
         8bQ0ykvg4Y+1fvllcSNITwm9WIVLSkRyWgXbZQN/5lB3C6+jhD/vf0tM6QbUXsXzQuPm
         /rez1rV/yNt2zQ4tXpGFt22ovwZRo1hCpNR8ySUTdhoKUskuCIlgQGJ5EYym018AY4HE
         Y4uIGCPWEMl7GIR6Hxc4BFRfrtnayNCFjYVuaRpADlNie0KlXufYPnOZcXmUHfP1MdT2
         +3CQ==
X-Gm-Message-State: ACgBeo0QAhqwd1NiBjWCavNSbAsATAjwGATiRBDRxifHqIcxpfP8kY5a
        xzAC3TT5aOSmWO9dsXdilQ0=
X-Google-Smtp-Source: AA6agR6G0g0tepPldrnNWTsVrllTh0MrUkGBJuVD20hkGZDITGk2KSDTXVMtbDy1RIjdznCwz7i1lw==
X-Received: by 2002:a17:902:bb95:b0:169:4d7:fee with SMTP id m21-20020a170902bb9500b0016904d70feemr874904pls.80.1659044692157;
        Thu, 28 Jul 2022 14:44:52 -0700 (PDT)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id oa15-20020a17090b1bcf00b001ef89019352sm10089966pjb.3.2022.07.28.14.44.49
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 28 Jul 2022 14:44:51 -0700 (PDT)
Message-ID: <df39cfc9-6fd8-e277-870b-67059dcebb2b@gmail.com>
Date:   Thu, 28 Jul 2022 14:44:47 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: [PATCH net-next 3/4] net: phy: Add helper to derive the number of
 ports from a phy mode
Content-Language: en-US
To:     Andrew Lunn <andrew@lunn.ch>,
        Maxime Chevallier <maxime.chevallier@bootlin.com>
Cc:     davem@davemloft.net, Rob Herring <robh+dt@kernel.org>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org, thomas.petazzoni@bootlin.com,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        linux-arm-kernel@lists.infradead.org, Horatiu.Vultur@microchip.com,
        Allan.Nielsen@microchip.com, UNGLinuxDriver@microchip.com
References: <20220728145252.439201-1-maxime.chevallier@bootlin.com>
 <20220728145252.439201-4-maxime.chevallier@bootlin.com>
 <YuMAdACnRKsL8/xD@lunn.ch>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <YuMAdACnRKsL8/xD@lunn.ch>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 7/28/22 14:32, Andrew Lunn wrote:
>> +int phy_interface_num_ports(phy_interface_t interface)
>> +{
>> +	switch (interface) {
>> +	case PHY_INTERFACE_MODE_NA:
>> +	case PHY_INTERFACE_MODE_INTERNAL:
>> +		return 0;
> 
> I've not yet looked at how this is used. Returning 0 could have
> interesting effects i guess? INTERNAL clearly does have some sort of
> path between the MAC and the PHY, so i think 1 would be a better
> value. NA is less clear, it generally means Don't touch. But again,
> there still needs to be a path between the MAC and PHY, otherwise
> there would not be any to touch.
> 
> Why did you pick 0?

I would agree that returning 1 is a more sensible default to avoid breaking users of that function. However this makes me wonder, in what case will we break the following common meaning:

- Q -> quad
- P -> penta
- O -> octal

Is the helper really needed in the sense that the phy_interface_t enumeration is explicit enough thanks to or because of its name?
--
Florian

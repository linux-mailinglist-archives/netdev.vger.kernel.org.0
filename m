Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 788AE31CFA2
	for <lists+netdev@lfdr.de>; Tue, 16 Feb 2021 18:53:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231190AbhBPRvU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Feb 2021 12:51:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38274 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231327AbhBPRuq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 16 Feb 2021 12:50:46 -0500
Received: from mail-pg1-x535.google.com (mail-pg1-x535.google.com [IPv6:2607:f8b0:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DE365C061756
        for <netdev@vger.kernel.org>; Tue, 16 Feb 2021 09:50:05 -0800 (PST)
Received: by mail-pg1-x535.google.com with SMTP id m2so6717585pgq.5
        for <netdev@vger.kernel.org>; Tue, 16 Feb 2021 09:50:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=9vlzinc/106KOTmVjws4yoqes7O8cGXcAqScCAVwmsI=;
        b=ADJk6G8/ii0CmZvsDJ5fmlhWvPilVvCnmjXGoQF01yy3yt6hyL6VGwCybHAQ6hyAHZ
         GEA03sYMejOqz60JJytUTtt2h8hmaysgwPCbyJmNnPGnkaSUtMqMTt9WCegwZYDgaY3g
         mqDbVq3jh4pLonk2EuWvBrwg4YfncG7RMLoFLSzx7SUd6So7hqrQrXy/UBoVUVauhQ2S
         mPssRTsuiauOGDkaxOsT7k2JRgtiPxwxrqcGx3TPWMUCazA7mnTq90GX/YRPTSzfx/Uy
         /1isvui9khURaWtoiBlo5/HUGegDI2dEBzo2FnvDfl+H08BAuA7bdHbVFrjpuMSbVKVe
         85Pg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=9vlzinc/106KOTmVjws4yoqes7O8cGXcAqScCAVwmsI=;
        b=jTGAyIH4XLGb9a3KEP1r83jxun94uTDkX1ElxwMdpKPaoszvIblYUQLXt4ljPJN8f+
         XnwXEHE4Yvwtsrt7tSqxslBf4UKC8ivGczXnwJVnvL27o+isloOExkrxLWZYyHhIpOLR
         rdKK2wRwn/WyQ903+7fJpaIQipGnjsbBwaWevM8aBaJKgbj2W5pkqKuSfrC0g9tU6ypb
         GaZ7UnxndtcF8GvzNTP+MYC6PQCubeNa4oyQnGZmdEhyh1vhhAiSbQyqalj8ufrw6oVZ
         E7Lb9vBR9sInJxP9Vj9ufC3YgN79tuCUskGne/WaDatU0kyD7bamYHfFgHNWY9UhS5V1
         UsuQ==
X-Gm-Message-State: AOAM530yotCo79GGQ5OAqQUsr7QRbWIwYlIw7094w6qQfyP3aYAjSRhv
        O+bqlsiGinUAAfJzhKZ3fypIDttvkM8=
X-Google-Smtp-Source: ABdhPJxW+XXCw27Jfp7JXSbIHvSioPvNR/KeT2LyMXyOwMWI5r7oVoBYnFNOfNAWgNSiyxt4FfFFrg==
X-Received: by 2002:a62:7594:0:b029:1ec:a3df:e8a6 with SMTP id q142-20020a6275940000b02901eca3dfe8a6mr9234775pfc.58.1613497805292;
        Tue, 16 Feb 2021 09:50:05 -0800 (PST)
Received: from [10.230.29.30] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id e76sm20834211pfh.102.2021.02.16.09.50.03
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 16 Feb 2021 09:50:04 -0800 (PST)
Subject: Re: [PATCH] of: of_mdio: Handle properties for non-phy mdio devices
To:     Andrew Lunn <andrew@lunn.ch>, Nathan Rossi <nathan@nathanrossi.com>
Cc:     netdev@vger.kernel.org, Nathan Rossi <nathan.rossi@digi.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
References: <20210215070218.1188903-1-nathan@nathanrossi.com>
 <YCvDVEvBU5wabIx7@lunn.ch>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <55c94cf4-f660-f0f5-fb04-f51f4d175f53@gmail.com>
Date:   Tue, 16 Feb 2021 09:50:02 -0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Firefox/78.0 Thunderbird/78.7.1
MIME-Version: 1.0
In-Reply-To: <YCvDVEvBU5wabIx7@lunn.ch>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 2/16/2021 5:06 AM, Andrew Lunn wrote:
> On Mon, Feb 15, 2021 at 07:02:18AM +0000, Nathan Rossi wrote:
>> From: Nathan Rossi <nathan.rossi@digi.com>
>>
>> The documentation for MDIO bindings describes the "broken-turn-around",
>> "reset-assert-us", and "reset-deassert-us" properties such that any MDIO
>> device can define them. Other MDIO devices may require these properties
>> in order to correctly function on the MDIO bus.
>>
>> Enable the parsing and configuration associated with these properties by
>> moving the associated OF parsing to a common function
>> of_mdiobus_child_parse and use it to apply these properties for both
>> PHYs and other MDIO devices.
> 
> Hi Nathan
> 
> What device are you using this with?
> 
> The Marvell Switch driver does its own GPIO reset handling. It has a
> better idea when a hardware reset should be applied than what the
> phylib core has. It will also poll the EEPROM busy bit after a
> reset. How long a pause you need after the reset depends on how full
> the EEPROM is.
> 
> And i've never had problems with broken-turn-around with Marvell
> switches.

The patch does make sense though, Broadcom 53125 switches have a broken
turn around and are mdio_device instances, the broken behavior may not
show up with all MDIO controllers used to interface though. For the
reset, I would agree with you this is better delegated to the switch
driver, given that unlike PHY devices, we have no need to know the
mdio_device ID prior to binding the device and the driver together.

> 
> Given the complexity of an Ethernet switch, it is probably better if
> it handles its own reset.
> 
>      Andrew
> 

-- 
Florian

Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E76396F3035
	for <lists+netdev@lfdr.de>; Mon,  1 May 2023 12:32:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232366AbjEAKcR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 May 2023 06:32:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56188 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232355AbjEAKcP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 May 2023 06:32:15 -0400
Received: from mail-wm1-x331.google.com (mail-wm1-x331.google.com [IPv6:2a00:1450:4864:20::331])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 545D21A5;
        Mon,  1 May 2023 03:32:13 -0700 (PDT)
Received: by mail-wm1-x331.google.com with SMTP id 5b1f17b1804b1-3f20215fa70so13610475e9.0;
        Mon, 01 May 2023 03:32:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1682937132; x=1685529132;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=88ED5pu6NIUvWB1EVkjbAvR9D0f7HUy1+wauwnGtc9E=;
        b=aVU9tEIGcAyxX/UVkTd/+LzlZUdCrOBKwiDmszTdXBCg4p6CkkLwC0Jd/BxwWD4gZ9
         +6vXAbVxueP6wfGjk5cMh0tirC1tp99oQ9bA4PMgX3Be2o3dHF2L2l5kufxDeSYsQrq7
         5nXnJ/TQ9S5ozS6sxkLWpQ8xCB0GGVgj5V6bopm3gPg+eU+ePy+aSgSTeoK9tS1nuwB6
         gFjqzkylUYpgrvnFTweGDor/zGD9O8eB1LahWWeYZQkMWRUe0jsYzpgSDpNqtcB8SF0H
         yOlIDd7D08MRnAm60Qsf7119KL6DaJjPavv7K5mjuewvCA3gJfkv2vyqumAtxGLUW8Et
         MerQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682937132; x=1685529132;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=88ED5pu6NIUvWB1EVkjbAvR9D0f7HUy1+wauwnGtc9E=;
        b=aAsep9pN+dRU1IOmMe3L+MlFhfLXZ3J9zz4YFd5Yzf/3C6M7p61VS/4y9ISu9hlYpS
         rdFs3vW2FiefifCcvo+v+yRZ3acZkU6RyKeT7dLRoNA5p/Qcw6a0mbWBW9LPbeltq+Vj
         hW/iWHcc5saAGErP1L0W3HuzmUMJCEYLXd2hmKMKetm7+jrPiiU4Y33OVMc1Uc3n37uR
         Kig2bi9MQb/wN8ubaL9TCPhZfG4e6HvhXPGcZpuQtOCHAM0n4XoBIw2gKKVb5XfcaWcr
         nQ1PIZvS6PzE9OMz+AaPbaHG5lYuPI963iUpNADKAtcpJnoTq1hKEVkSiJ2/1vMZJrKy
         PItA==
X-Gm-Message-State: AC+VfDxmurJz+PnGFf20ZSwS4IuWPC+SW9xg9/ETfFRv7//aQeZcp4RI
        dzWVe4VhWszAX7/ZiBfsqalZyhJa2xQ=
X-Google-Smtp-Source: ACHHUZ5eBpHEUMNHy1bFaWquPRPHSuoSuTTuIHLytm54M5fD7iNwBzK81xPAZK6V8c5M+F1XuavaGw==
X-Received: by 2002:a1c:7502:0:b0:3ed:88f5:160a with SMTP id o2-20020a1c7502000000b003ed88f5160amr9572195wmc.11.1682937131442;
        Mon, 01 May 2023 03:32:11 -0700 (PDT)
Received: from ?IPV6:2a01:c23:b9bd:5800:60ec:422b:628c:6ca5? (dynamic-2a01-0c23-b9bd-5800-60ec-422b-628c-6ca5.c23.pool.telefonica.de. [2a01:c23:b9bd:5800:60ec:422b:628c:6ca5])
        by smtp.googlemail.com with ESMTPSA id jb12-20020a05600c54ec00b003f17003e26esm35339174wmb.15.2023.05.01.03.32.10
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 01 May 2023 03:32:10 -0700 (PDT)
Message-ID: <951be015-c18a-0aec-4c2c-df98803a2e84@gmail.com>
Date:   Mon, 1 May 2023 12:32:08 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.0
Subject: Re: [RFC PATCH net-next 5/8] net: phy: realtek: use phy_read_paged
 instead of open coding
To:     Daniel Golle <daniel@makrotopia.org>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Andrew Lunn <andrew@lunn.ch>,
        Russell King <linux@armlinux.org.uk>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Chen Minqiang <ptpt52@gmail.com>,
        Chukun Pan <amadeus@jmu.edu.cn>,
        Yevhen Kolomeiko <jarvis2709@gmail.com>,
        Alexander Couzens <lynxis@fe80.eu>
References: <cover.1682163424.git.daniel@makrotopia.org>
 <85eb0791bd614ccfdeccdc6fe39be55e602c521c.1682163424.git.daniel@makrotopia.org>
 <d7eaf73b-282a-df7d-d9a5-530e431701a1@gmail.com>
 <ZEVyk71pBcQZ_NH_@makrotopia.org>
Content-Language: en-US
From:   Heiner Kallweit <hkallweit1@gmail.com>
In-Reply-To: <ZEVyk71pBcQZ_NH_@makrotopia.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.3 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 23.04.2023 20:01, Daniel Golle wrote:
> On Sat, Apr 22, 2023 at 05:11:57PM +0200, Heiner Kallweit wrote:
>> On 22.04.2023 13:48, Daniel Golle wrote:
>>> Instead of open coding a paged read, use the phy_read_paged function
>>> in rtlgen_supports_2_5gbps.
>>>
>>> Signed-off-by: Daniel Golle <daniel@makrotopia.org>
>>> ---
>>>  drivers/net/phy/realtek.c | 4 +---
>>>  1 file changed, 1 insertion(+), 3 deletions(-)
>>>
>>> diff --git a/drivers/net/phy/realtek.c b/drivers/net/phy/realtek.c
>>> index f97b5e49fae58..62fb965b6d338 100644
>>> --- a/drivers/net/phy/realtek.c
>>> +++ b/drivers/net/phy/realtek.c
>>> @@ -735,9 +735,7 @@ static bool rtlgen_supports_2_5gbps(struct phy_device *phydev)
>>>  {
>>>  	int val;
>>>  
>>> -	phy_write(phydev, RTL821x_PAGE_SELECT, 0xa61);
>>> -	val = phy_read(phydev, 0x13);
>>> -	phy_write(phydev, RTL821x_PAGE_SELECT, 0);
>>> +	val = phy_read_paged(phydev, 0xa61, 0x13);
>>>  
>>>  	return val >= 0 && val & RTL_SUPPORTS_2500FULL;
>>>  }
>>
>> I remember I had a reason to open-code it, it took me some minutes
>> to recall it.
>> phy_read_paged() calls __phy_read_page() that relies on phydev->drv
>> being set. phydev->drv is set in phy_probe(). And probing is done
>> after matching. __phy_read_paged() should have given you a warning.
>> Did you test this patch? If yes and you didn't get the warning,
>> then apparently I miss something.
>>
> 
> Yes, you are right, this change was a bit too naive and causes a
> NULL pointer dereference e.g. for the r8169 driver which also uses
> the RealTek Ethernet PHY driver.
> My main concern and original motivation was the lack of mutex protection
> for the paged read operation. I suggest to rather make this change
> instead:
> 
>>From 4dd2cc9b91ecb25f278a2c55e07e6455e9000e6b Mon Sep 17 00:00:00 2001
> From: Daniel Golle <daniel@makrotopia.org>
> Date: Sun, 23 Apr 2023 18:47:45 +0100
> Subject: [PATCH] net: phy: realtek: make sure paged read is protected by mutex
> 
> As we cannot rely on phy_read_paged function before the PHY is
> identified, the paged read in rtlgen_supports_2_5gbps needs to be open
> coded as it is being called by the match_phy_device function, ie. before
> .read_page and .write_page have been populated.
> 
> Make sure it is also protected by the MDIO bus mutex and use
> rtl821x_write_page instead of 3 individually locked MDIO bus operations.
> 
> Signed-off-by: Daniel Golle <daniel@makrotopia.org>
> ---
>  drivers/net/phy/realtek.c | 8 +++++---
>  1 file changed, 5 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/net/phy/realtek.c b/drivers/net/phy/realtek.c
> index f97b5e49fae5..c27ec4e99fc2 100644
> --- a/drivers/net/phy/realtek.c
> +++ b/drivers/net/phy/realtek.c
> @@ -735,9 +735,11 @@ static bool rtlgen_supports_2_5gbps(struct phy_device *phydev)
>  {
>  	int val;
>  
> -	phy_write(phydev, RTL821x_PAGE_SELECT, 0xa61);
> -	val = phy_read(phydev, 0x13);
> -	phy_write(phydev, RTL821x_PAGE_SELECT, 0);
> +	mutex_lock(&phydev->mdio.bus->mdio_lock);

We have helpers phy_(un)lock_mdio_bus() for this.
Apart from that: LGTM

> +	rtl821x_write_page(phydev, 0xa61);
> +	val = __phy_read(phydev, 0x13);
> +	rtl821x_write_page(phydev, 0);
> +	mutex_unlock(&phydev->mdio.bus->mdio_lock);
>  
>  	return val >= 0 && val & RTL_SUPPORTS_2500FULL;
>  }


Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9B82D6DDAEB
	for <lists+netdev@lfdr.de>; Tue, 11 Apr 2023 14:33:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229881AbjDKMde (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 Apr 2023 08:33:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54570 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229761AbjDKMdb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 11 Apr 2023 08:33:31 -0400
Received: from mail-pl1-x62f.google.com (mail-pl1-x62f.google.com [IPv6:2607:f8b0:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 429CB30FE
        for <netdev@vger.kernel.org>; Tue, 11 Apr 2023 05:33:30 -0700 (PDT)
Received: by mail-pl1-x62f.google.com with SMTP id d9443c01a7336-1a526890eeeso4585615ad.1
        for <netdev@vger.kernel.org>; Tue, 11 Apr 2023 05:33:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1681216410; x=1683808410;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=b7sS6NgVPjbACus9E/+eag1ATMh3LLtZ4juWG3sQbnc=;
        b=otl0oI6vnQTYf2BjxVxuqGiVL8w0iTNbYPgHRcW2TeAGZ8P7rTzDtzuaZgQdqikgQj
         LanS2y5uBP/zRJ+PXpvpyRV66bPhFKEhJwrbbKfcbR9YOcRAxN6XnBorDVtkpzOMeUrf
         yqxAAsdopVMhmTkhJDUCOZCEUMNVMjVhz4TvJYXW1Eaq/hrYK3+DcQPaHi7Gk+pN82nm
         nFZi7zS0JVZ6nmrss1KsKkOHHKRt3OPQUuxe7hyZGf1Ltxb3UOGVqJKL1krJBuT4AM1K
         zwW4Cjurqw3Qrn/xFyDn0l846TrAmkET86zEfu59E0DcX1i+Fnqp79IwUhtjmQsX/Upi
         qbmQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1681216410; x=1683808410;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=b7sS6NgVPjbACus9E/+eag1ATMh3LLtZ4juWG3sQbnc=;
        b=6Tpgks2Z57ZnSPEVYkzgx5ySx5PvSIDWuejJucq+WA/gTMiN2BjizhmQv9FJbeY/DA
         HBDk4e189arjkULyioZ89u0U/CoZB4qwUd0XVqdlPGU8Dl+SfXvdV5AyjX+JxlvQp8Jn
         V0sVyRKA3NFPhyxDhunTHp2jdnHzeUg5AyZVZULjsp1MiINBSQaHcWfNPoIwnhoqNfI2
         Rwsdrspe7CgoRgJlRCB0m/Yq1Jdv9/nZ7iNIc8hkRVOgcXv5io6BA/u5/NkSlTPw94cb
         O/g/mrEpkECT/NE/4csdDJaj+NXF5L0WznaycVUmi/Y73qvkLIbPXh3Xn8tLVXWx00no
         oRkQ==
X-Gm-Message-State: AAQBX9fmi9IRVnwo3hLy1vUZeTrzsGT07aUSOd9zLQpGy5+4W7Jo0tpG
        2tc3OAtfUC+hX+2/TVKZM+8q7NNFZyW80g==
X-Google-Smtp-Source: AKy350Yz5w7TS8mzTFMitpK5kq0Csfx2az5DKZLInjg7Qw6ubrGO2P5D+Jdi8Gc4qZ5uUWl/nEfP4A==
X-Received: by 2002:a62:6d84:0:b0:62d:e5eb:2d73 with SMTP id i126-20020a626d84000000b0062de5eb2d73mr13523516pfc.34.1681216409665;
        Tue, 11 Apr 2023 05:33:29 -0700 (PDT)
Received: from ?IPV6:2600:8802:b00:4a48:f883:c242:b637:c11? ([2600:8802:b00:4a48:f883:c242:b637:c11])
        by smtp.gmail.com with ESMTPSA id i16-20020aa78b50000000b0062d35807d3asm9809084pfd.28.2023.04.11.05.33.28
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 11 Apr 2023 05:33:29 -0700 (PDT)
Message-ID: <123b198a-f810-a096-137b-fcf433a13b96@gmail.com>
Date:   Tue, 11 Apr 2023 05:33:27 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.9.1
Subject: Re: [PATCH net-next] net: dsa: mv88e6xxx: Correct cmode to
 PHY_INTERFACE_
Content-Language: en-US
To:     Vladimir Oltean <vladimir.oltean@nxp.com>,
        Andrew Lunn <andrew@lunn.ch>
Cc:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Russell King <rmk+kernel@armlinux.org.uk>,
        netdev <netdev@vger.kernel.org>
References: <20230411023541.2372609-1-andrew@lunn.ch>
 <20230411023541.2372609-1-andrew@lunn.ch>
 <20230411113857.f4i7drf7573r6vmg@skbuf>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20230411113857.f4i7drf7573r6vmg@skbuf>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.4 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 4/11/2023 4:38 AM, Vladimir Oltean wrote:
> On Tue, Apr 11, 2023 at 04:35:41AM +0200, Andrew Lunn wrote:
>> The switch can either take the MAC or the PHY role in an MII or RMII
>> link. There are distinct PHY_INTERFACE_ macros for these two roles.
>> Correct the mapping so that the `REV` version is used for the PHY
>> role.
>>
>> Signed-off-by: Andrew Lunn <andrew@lunn.ch>
>> ---
> 
> Reviewed-by: Vladimir Oltean <vladimir.oltean@nxp.com>
> 
>>
>> Since this has not caused any known issues so far, i decided to not
>> add a Fixes: tag and submit for net.
>>
>>   drivers/net/dsa/mv88e6xxx/chip.c | 4 ++--
>>   1 file changed, 2 insertions(+), 2 deletions(-)
>>
>> diff --git a/drivers/net/dsa/mv88e6xxx/chip.c b/drivers/net/dsa/mv88e6xxx/chip.c
>> index 62a126402983..ffe6a88f94ce 100644
>> --- a/drivers/net/dsa/mv88e6xxx/chip.c
>> +++ b/drivers/net/dsa/mv88e6xxx/chip.c
>> @@ -611,10 +611,10 @@ static void mv88e6185_phylink_get_caps(struct mv88e6xxx_chip *chip, int port,
>>   }
>>   
>>   static const u8 mv88e6xxx_phy_interface_modes[] = {
>> -	[MV88E6XXX_PORT_STS_CMODE_MII_PHY]	= PHY_INTERFACE_MODE_MII,
>> +	[MV88E6XXX_PORT_STS_CMODE_MII_PHY]	= PHY_INTERFACE_MODE_REVMII,

Is this hunk correct?

>>   	[MV88E6XXX_PORT_STS_CMODE_MII]		= PHY_INTERFACE_MODE_MII,
>>   	[MV88E6XXX_PORT_STS_CMODE_GMII]		= PHY_INTERFACE_MODE_GMII,
>> -	[MV88E6XXX_PORT_STS_CMODE_RMII_PHY]	= PHY_INTERFACE_MODE_RMII,
>> +	[MV88E6XXX_PORT_STS_CMODE_RMII_PHY]	= PHY_INTERFACE_MODE_REVRMII,
>>   	[MV88E6XXX_PORT_STS_CMODE_RMII]		= PHY_INTERFACE_MODE_RMII,
>>   	[MV88E6XXX_PORT_STS_CMODE_100BASEX]	= PHY_INTERFACE_MODE_100BASEX,
>>   	[MV88E6XXX_PORT_STS_CMODE_1000BASEX]	= PHY_INTERFACE_MODE_1000BASEX,
>> -- 
>> 2.40.0
>>

-- 
Florian

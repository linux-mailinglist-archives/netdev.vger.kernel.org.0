Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D1BB46DDB87
	for <lists+netdev@lfdr.de>; Tue, 11 Apr 2023 15:02:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230196AbjDKNCN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 Apr 2023 09:02:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59398 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230249AbjDKNB5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 11 Apr 2023 09:01:57 -0400
Received: from mail-pl1-x62c.google.com (mail-pl1-x62c.google.com [IPv6:2607:f8b0:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D4FE65244
        for <netdev@vger.kernel.org>; Tue, 11 Apr 2023 06:01:23 -0700 (PDT)
Received: by mail-pl1-x62c.google.com with SMTP id e13so7435577plc.12
        for <netdev@vger.kernel.org>; Tue, 11 Apr 2023 06:01:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1681218054; x=1683810054;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=OOHp7zmWGESYSM6vAK71He3seHwopGbS9256hQPEcdk=;
        b=Bw3bFIpWCjRDPF7hP5j/udrEG9s/pdiKtZMgjLQCWwct6WxHRaxxKhRi9OYm3lw3rJ
         4nP5bwpy1E1kA283TXTOt59qVVOMWTZO/VwBS5F70ufg0Gqscph2vum3tyZxi/oZcE10
         dDaPuho28lzF9XBG7drfB29ANjGtOy5Fqai5ejQe7g6y9VrO5qOvQ5DIkGFoSI/9Hvmn
         AOUTXq6i0OjlfAI5uzqLz1yqcmsINCyfFKkNnkYwX9GBfQQvam/ttvcmg1Ss4LsVBSJm
         zIW5ab915k3z4ZJBYZZYy/dBLsY5tSwK4eY23PN0Y0URm1c32hlVqSAYpT+2EfA26mh8
         3s3A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1681218054; x=1683810054;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=OOHp7zmWGESYSM6vAK71He3seHwopGbS9256hQPEcdk=;
        b=GiUwK0WAT3yhbiA7OlremXkebU+juw8m+DNhvKDSXzcEiVBrWkEhL+A+G5cDov4sUo
         x0yBNkpEnzGQqK7wRj1UNlv3nxu1RCqw8/rwUfP98Z7Dq8ImLDntwjEmIQTTzFXg0FhI
         eEtVF2+j/sGrqp7PPPLj9Z7/eXhxFv0HNsIrXeK8o6+ZSBSQCtkb8Ia/qPWkbrViZWye
         MlJi8AdujAJv/DrdQpGZ/dMWQqr4IO3MtxM1NTxrufQooSZM8dfMbVxFLhpiSvjIuVi9
         OrnHGn5dn3wllAyJfCMTkZFxBan3Ou7uH8ZlctzYbSN/pXDzF8kzcGIzAl1mNY6vIxTc
         UfHg==
X-Gm-Message-State: AAQBX9dTN8JG0w38UJEar8I7ReP0u9rXXeXZZ6oIHtx3LysGT9aS/KrO
        yVS6lCjxVt9wSXQCszSGc4A=
X-Google-Smtp-Source: AKy350bHUhfmfkFI42NRiAh2jHOSWuT4kTvIpJ1cE6BLe5D1mkTbETpWwMueb7D+KCa9y13qrfpJgA==
X-Received: by 2002:a05:6a20:7aa2:b0:d3:89a1:76d1 with SMTP id u34-20020a056a207aa200b000d389a176d1mr2991808pzh.11.1681218051755;
        Tue, 11 Apr 2023 06:00:51 -0700 (PDT)
Received: from [10.230.29.214] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id d18-20020aa78152000000b005d61829db4fsm9695131pfn.168.2023.04.11.06.00.49
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 11 Apr 2023 06:00:51 -0700 (PDT)
Message-ID: <8e36fa45-129c-4bb1-3ebb-1b0871355ef2@gmail.com>
Date:   Tue, 11 Apr 2023 06:00:48 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.9.1
Subject: Re: [PATCH net-next] net: dsa: mv88e6xxx: Correct cmode to
 PHY_INTERFACE_
Content-Language: en-US
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Vladimir Oltean <vladimir.oltean@nxp.com>,
        David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Russell King <rmk+kernel@armlinux.org.uk>,
        netdev <netdev@vger.kernel.org>
References: <20230411023541.2372609-1-andrew@lunn.ch>
 <20230411023541.2372609-1-andrew@lunn.ch>
 <20230411113857.f4i7drf7573r6vmg@skbuf>
 <123b198a-f810-a096-137b-fcf433a13b96@gmail.com>
 <a7a0dc51-c3dd-49e5-b66e-da9ddcc9e071@lunn.ch>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <a7a0dc51-c3dd-49e5-b66e-da9ddcc9e071@lunn.ch>
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



On 4/11/2023 5:48 AM, Andrew Lunn wrote:
>> On 4/11/2023 4:38 AM, Vladimir Oltean wrote:
>>> On Tue, Apr 11, 2023 at 04:35:41AM +0200, Andrew Lunn wrote:
>>>> The switch can either take the MAC or the PHY role in an MII or RMII
>>>> link. There are distinct PHY_INTERFACE_ macros for these two roles.
>>>> Correct the mapping so that the `REV` version is used for the PHY
>>>> role.
> 
>>>>    static const u8 mv88e6xxx_phy_interface_modes[] = {
>>>> -	[MV88E6XXX_PORT_STS_CMODE_MII_PHY]	= PHY_INTERFACE_MODE_MII,
>>>> +	[MV88E6XXX_PORT_STS_CMODE_MII_PHY]	= PHY_INTERFACE_MODE_REVMII,
>>
>> Is this hunk correct?
> 
> Hi Florian
> 
> I don't see why it is wrong, but you can be blind to bugs in your own
> code. What do you think is wrong?

I was not thinking it was wrong, just curious about the meaning of a 
CMODE value suffixed with _PHY, though it seems clear(er) now that this 
means the port is configured as a PHY and provides PHY signals to the 
MAC it connects to.

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>

PS: you can be blind without enough coffee as well :p
-- 
Florian

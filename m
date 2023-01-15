Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E8AEB66B385
	for <lists+netdev@lfdr.de>; Sun, 15 Jan 2023 19:43:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231538AbjAOSnw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 15 Jan 2023 13:43:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41118 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231514AbjAOSnv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 15 Jan 2023 13:43:51 -0500
Received: from mail-wr1-x434.google.com (mail-wr1-x434.google.com [IPv6:2a00:1450:4864:20::434])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3E8EAF744
        for <netdev@vger.kernel.org>; Sun, 15 Jan 2023 10:43:50 -0800 (PST)
Received: by mail-wr1-x434.google.com with SMTP id e3so16333687wru.13
        for <netdev@vger.kernel.org>; Sun, 15 Jan 2023 10:43:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=OqNu4z7pVUpJTWUrkJ4U/d2KgKBc21hr1i/mBhqreCk=;
        b=ssNzrq3Nd7XNJkmahlyQ/9J04sU0fcIOPhxzHYzuYvM2pCHS6fgOsJ2LOimWTSdtxr
         D7anbkV4JFp5UmWsUcIxXttg86WIosZXTExsjaf+5rWgA360zZm8ZJnbci2XVzzXqp6+
         y78SUhkTdrvmrjThgpC0S/qsonCFsQI6uLz/OshG2euGHBsg7CbAnyICXkUMC/78VxFO
         rhQE3sobOrjK+vmdeBtPM7/GlayvqMlwOOkhevykQ9u3aJyVkys3GYUV3+JQAX/06qPj
         45mDsUzGvV+e38YMSlAqzybxfK3WNrFNYV6EirX2ekrT3WeidS3oRIsSrhJId9EF48Kt
         NIeQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=OqNu4z7pVUpJTWUrkJ4U/d2KgKBc21hr1i/mBhqreCk=;
        b=aoCny0tNG0QCXfX4Kk3flUwlWYFFnhXsIierO4PQiiRz1jf+yhstDY6TCbsv8MT02c
         Y6FDI4HoTo46qrAHOFGcmCIOoFYHRvWMEMqSU6SxrUjtuFtp0Fw8D9c4xtRPPDxEv+Yq
         ldezS91H2AQAkerJFBrTqLFgVz60YuxiSZ6z7HFPPdNWwEk+d/s3qPsMJVyu00GNIt9X
         YDuIU6ejYrj4iYNKVvLauydV2lbw7FYVmqaNv5DMiRgLHPv4lw8LdMmYCC+M9Gc812Pe
         rTbcvNaSfnOUPnRECHVq73Ob7cPWGZ+MSIK0/R90J1QsgrPZZ1OLPGF3wYjt3R36xyDn
         bETQ==
X-Gm-Message-State: AFqh2kqgJTjRQDyuKFE6/yJsSApScLilAKWrJDFxRvPSpPNiNBW93kca
        HtoYibwgw4cGUhvOwzmd37F5YoF4QFZ37DiP
X-Google-Smtp-Source: AMrXdXuFIbJ8sgk1dRCGGcgp21liwHrqT6eDQwJqp2Z4Sm3pYqyagyRd8SylbdZooVuIL08uhVraYQ==
X-Received: by 2002:adf:e587:0:b0:2bd:c2ce:dd58 with SMTP id l7-20020adfe587000000b002bdc2cedd58mr13399941wrm.18.1673808228849;
        Sun, 15 Jan 2023 10:43:48 -0800 (PST)
Received: from ?IPV6:2a01:e0a:982:cbb0:3095:3ab6:8d3f:21f? ([2a01:e0a:982:cbb0:3095:3ab6:8d3f:21f])
        by smtp.gmail.com with ESMTPSA id t14-20020adfeb8e000000b002baa780f0fasm24089794wrn.111.2023.01.15.10.43.47
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 15 Jan 2023 10:43:48 -0800 (PST)
Message-ID: <51abd8ca-8172-edfa-1c18-b1e48231f316@linaro.org>
Date:   Sun, 15 Jan 2023 19:43:47 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.6.1
Subject: Re: [PATCH net-next] net: phy: meson-gxl: support more G12A-internal
 PHY versions
Content-Language: fr
To:     Heiner Kallweit <hkallweit1@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>
Cc:     Russell King - ARM Linux <linux@armlinux.org.uk>,
        David Miller <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Kevin Hilman <khilman@baylibre.com>,
        Jerome Brunet <jbrunet@baylibre.com>,
        Martin Blumenstingl <martin.blumenstingl@googlemail.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "open list:ARM/Amlogic Meson..." <linux-amlogic@lists.infradead.org>
References: <d75ef7df-a645-7fdd-491a-f89f70dbea01@gmail.com>
 <Y8Qwk5H8Yd7qiN0j@lunn.ch> <03ea260e-f03c-d9d7-6f5f-ff72836f5739@gmail.com>
From:   Neil Armstrong <neil.armstrong@linaro.org>
In-Reply-To: <03ea260e-f03c-d9d7-6f5f-ff72836f5739@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Heiner,

Le 15/01/2023 à 18:09, Heiner Kallweit a écrit :
> On 15.01.2023 17:57, Andrew Lunn wrote:
>> On Sun, Jan 15, 2023 at 04:19:37PM +0100, Heiner Kallweit wrote:
>>> On my SC2-based system the genphy driver was used because the PHY
>>> identifies as 0x01803300. It works normal with the meson g12a
>>> driver after this change.
>>> Switch to PHY_ID_MATCH_MODEL to cover the different sub-versions.
>>
>> Hi Heiner
>>
>> Are there any datasheets for these devices? Anything which documents
>> the lower nibble really is a revision?
>>
>> I'm just trying to avoid future problems where we find it is actually
>> a different PHY, needs its own MATCH_EXACT entry, and then we find we
>> break devices using 0x01803302 which we had no idea exists, but got
>> covered by this change.
>>
> The SC2 platform inherited a lot from G12A, therefore it's plausible
> that it's the same PHY. Also the vendor driver for SC2 gives a hint
> as it has the following compatible for the PHY:
> 
> compatible = "ethernet-phy-id0180.3301", "ethernet-phy-ieee802.3-c22";
> 
> But you're right, I can't say for sure as I don't have the datasheets.

On G12A (& GXL), the PHY ID is set in the MDIO MUX registers,
please see:
https://elixir.bootlin.com/linux/latest/source/drivers/net/mdio/mdio-mux-meson-g12a.c#L36

So you should either add support for the PHY mux in SC2 or check
what is in the ETH_PHY_CNTL0 register.

Neil

> 
>> 	Andrew
> 
> Heiner


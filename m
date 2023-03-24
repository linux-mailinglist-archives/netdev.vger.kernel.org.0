Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A3FAE6C862C
	for <lists+netdev@lfdr.de>; Fri, 24 Mar 2023 20:50:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231274AbjCXTuL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Mar 2023 15:50:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54086 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230038AbjCXTuJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Mar 2023 15:50:09 -0400
Received: from mail-wr1-x433.google.com (mail-wr1-x433.google.com [IPv6:2a00:1450:4864:20::433])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3AD7A59D5
        for <netdev@vger.kernel.org>; Fri, 24 Mar 2023 12:50:08 -0700 (PDT)
Received: by mail-wr1-x433.google.com with SMTP id m2so2890233wrh.6
        for <netdev@vger.kernel.org>; Fri, 24 Mar 2023 12:50:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1679687407;
        h=content-transfer-encoding:in-reply-to:subject:from:references:cc:to
         :content-language:user-agent:mime-version:date:message-id:from:to:cc
         :subject:date:message-id:reply-to;
        bh=feJ7EX3IspkdYbKQ5TxWDW6/zIUMMX5mtcLHUkJ2lTg=;
        b=Y+qep2YVkeMuxiHy3OGXaQ/irh2lnPvOUoIj/78GRXlVvfRNZ4jEJ0TnWz7FyQav5i
         /QKoJfi6aj90uvqKQWyOL81tq+up9hUt2bp67S6Q11eG75Q/S0BPWZ9LMSmu72GbSHdY
         uLTECT0TVtcwdwi5YECTU7VKpR9XznoFDtk+ReaTc8+I454MkS/5vhE/X1rEkKU7ChH2
         7MU3OpHuRy2optvo6bGEhoqsbA4oakJlUPkTvLlM3uWRQ6nGEhqpFYmZfn8CR08QHXR0
         JHFgDXA6KEVRZKubimNbmIgeY/OQP3wJQG4f/NTZZOkuLJQVmqEO2jNv8EXak6flWBZR
         RRqg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679687407;
        h=content-transfer-encoding:in-reply-to:subject:from:references:cc:to
         :content-language:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=feJ7EX3IspkdYbKQ5TxWDW6/zIUMMX5mtcLHUkJ2lTg=;
        b=KQgVIxwAdcUQSo7V50aiQ0D7IWEInDL1NAmT/q/imnMmgp8kQh19Dud97H3XZw6Ijd
         RYU1EcPA7OlLLKSuPhmryOgqvuRlUn2H5uCU+62pmMp2XHCD5ZCpN3BlPhePvFpVNCYU
         YEmsv3cGFEAFt++R7QukUKkbcBDwYkwf/LtaRDFg10VmYwxh0mNgf6oMI5aEFR9l8N5a
         ArtpcOmG5CXSkVL4F8CDg0BwRj3NbG2BRqunOnUL8wqC233ruquyYVISdn7wtea00Wx8
         poHTVe/H+YIaW8zlyIZkaIqqzfch2QvgYtFBbXx9mmJUEhH3G7a4ZctgV49d8dPO99Wb
         OzKg==
X-Gm-Message-State: AAQBX9cmsJZCkorMuOrzVjnt8GM0oB0ep5pEcwwhgvOS/WnXmQPSSuCh
        TvCYcmhmonVS197PN1pMMaM=
X-Google-Smtp-Source: AKy350Yc4xsHZikXaRa7r8FyIdJv9M+40oS44FDRFHIyN2XNvXEPHwzT1DbVVhMgXVmxeImh/4nKeg==
X-Received: by 2002:adf:efc3:0:b0:2ce:a944:2c6a with SMTP id i3-20020adfefc3000000b002cea9442c6amr3015544wrp.70.1679687406452;
        Fri, 24 Mar 2023 12:50:06 -0700 (PDT)
Received: from ?IPV6:2a01:c23:b926:df00:a161:16e2:f237:a7d4? (dynamic-2a01-0c23-b926-df00-a161-16e2-f237-a7d4.c23.pool.telefonica.de. [2a01:c23:b926:df00:a161:16e2:f237:a7d4])
        by smtp.googlemail.com with ESMTPSA id p5-20020a05600c358500b003b47b80cec3sm679303wmq.42.2023.03.24.12.50.05
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 24 Mar 2023 12:50:05 -0700 (PDT)
Message-ID: <45afac86-cff6-f695-f02b-a8d711166db0@gmail.com>
Date:   Fri, 24 Mar 2023 20:50:04 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.9.0
Content-Language: en-US
To:     Florian Fainelli <f.fainelli@gmail.com>,
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
 <8d1e588f-72a4-ffff-f0f3-dbb071838a08@gmail.com>
 <c3bc1a7e-b80b-cf04-c925-6893d5ac53ae@gmail.com>
From:   Heiner Kallweit <hkallweit1@gmail.com>
Subject: Re: [PATCH net-next 4/4] net: phy: bcm7xxx: remove getting reference
 clock
In-Reply-To: <c3bc1a7e-b80b-cf04-c925-6893d5ac53ae@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=0.1 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,FREEMAIL_FROM,
        NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 24.03.2023 20:03, Florian Fainelli wrote:
> On 3/24/23 11:05, Heiner Kallweit wrote:
>> Now that getting the reference clock has been moved to phylib,
>> we can remove it here.
>>
>> Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
> 
> This is not the reference clock for bcm7xxx this is the SoC internal clock that feeds the Soc internal PHY.

Ah, good to know. Then indeed we may have to allow drivers to disable this feature.

Another aspect: When looking at ba4ee3c05365 "net: phy: bcm7xxx: request and manage GPHY clock"
I stumbled across statement "PHY driver can be probed with the clocks turned off".
I interpret this in a way that dynamic PHY detection doesn't work because the PHY ID
registers aren't accessible before the PHY driver has been loaded and probed. Is this right?
Should the MDIO bus driver enable the clock for the PHY?


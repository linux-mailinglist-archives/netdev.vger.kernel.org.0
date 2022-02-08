Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E687E4ACF18
	for <lists+netdev@lfdr.de>; Tue,  8 Feb 2022 03:46:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345019AbiBHCps (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Feb 2022 21:45:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36490 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241393AbiBHCpi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Feb 2022 21:45:38 -0500
Received: from mail-pf1-x433.google.com (mail-pf1-x433.google.com [IPv6:2607:f8b0:4864:20::433])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C17C6C061A73
        for <netdev@vger.kernel.org>; Mon,  7 Feb 2022 18:45:37 -0800 (PST)
Received: by mail-pf1-x433.google.com with SMTP id e6so16373936pfc.7
        for <netdev@vger.kernel.org>; Mon, 07 Feb 2022 18:45:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=xoQjK81G3OKCwibVPmCaCaoCXfow9Lj/TJfFxnMYYbQ=;
        b=imOpwacLkBy8S357R3aneKuNiN1Nwh1kAyB9f3YDWv5u7sX3IMmdwaKvXql7pjqOhE
         /SbAIfTUfawup/ociOtFgqNcqX2oe1/WDRJbkaiI+rc2MEZ+lGOJvLVewQjkqnInRaBR
         h6ddeZ2pDUAr+KINAHOSxxPANKpae8bzQxOlepVBbPfEPJ7qVYo7tCQYUN24FU9052uu
         JW1igA2yh9nE8lQTIfggTdwWTGnvm7N5jgX81sIvYX60f5rv6MBIF3Tqg9ucuTgrwoOf
         h5n1TzplWlYiQlMg+7xQF5H4UZBaMyiDvgzmKW0h17uXrKRR+yMdPsluqQK4wbZPc4h7
         IAgg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=xoQjK81G3OKCwibVPmCaCaoCXfow9Lj/TJfFxnMYYbQ=;
        b=ow0LTXhxCI36XsrUozRXKFJGzXb7h4IzfBKJ4KHQWRyd5nTM1meF74BFkOadNcF3Lv
         ClTMo6CtkJxv132dgG+04JTFNHPPdZGWtEzuxZYG0ZTZCZlRcshxO7fIqJd9l5QFwTm/
         zQELsbOzhVW548Kl2OEUIJnwBpc0+UweCy4T+XI4CGiR0oaRqBSm8/V7FpbW3lTNRUI2
         ancDmmsdy60bhu3hTSkx6gYC5eg1my7DcJ3YvA6h+ELjW4z4DpAX74xDScgU0jrdxqoo
         qG7PpGSNJis9UG68tzLJdi1mT+hnEB9DHFAQF4UPPV4amDgWygGoCtcjXxig2dVB9v4t
         J6tg==
X-Gm-Message-State: AOAM530OYIcQohiST9WxuCif/jsNa2iGfHbW9YH6ZyTQLiNvFn98PQuG
        g6HTvw9bEEoKSas8kIAqDHg=
X-Google-Smtp-Source: ABdhPJwCHawOI5ZXveYuTFzBXrd/RdrSxBYJfG11l0bfe8/GYnvWK9e0pMhk2YItpsmob2O95w+msg==
X-Received: by 2002:a65:4088:: with SMTP id t8mr1824518pgp.241.1644288337174;
        Mon, 07 Feb 2022 18:45:37 -0800 (PST)
Received: from [192.168.1.3] (ip72-194-116-95.oc.oc.cox.net. [72.194.116.95])
        by smtp.gmail.com with ESMTPSA id g4sm1857703pgw.9.2022.02.07.18.45.34
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 07 Feb 2022 18:45:36 -0800 (PST)
Message-ID: <5011cbdd-0172-0402-1053-4ced38e12333@gmail.com>
Date:   Mon, 7 Feb 2022 18:45:34 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.1
Subject: Re: [PATCH net 3/7] net: dsa: bcm_sf2: don't use devres for mdiobus
Content-Language: en-US
To:     Vladimir Oltean <vladimir.oltean@nxp.com>, netdev@vger.kernel.org
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Hauke Mehrtens <hauke@hauke-m.de>,
        Sean Wang <sean.wang@mediatek.com>,
        Landen Chao <Landen.Chao@mediatek.com>,
        DENG Qingfang <dqfext@gmail.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        UNGLinuxDriver@microchip.com,
        Oleksij Rempel <linux@rempel-privat.de>,
        Bartosz Golaszewski <bgolaszewski@baylibre.com>,
        Laurentiu Tudor <laurentiu.tudor@nxp.com>,
        Rafael Richter <rafael.richter@gin.de>,
        Daniel Klauer <daniel.klauer@gin.de>
References: <20220207161553.579933-1-vladimir.oltean@nxp.com>
 <20220207161553.579933-4-vladimir.oltean@nxp.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20220207161553.579933-4-vladimir.oltean@nxp.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 2/7/2022 8:15 AM, Vladimir Oltean wrote:
> As explained in commits:
> 74b6d7d13307 ("net: dsa: realtek: register the MDIO bus under devres")
> 5135e96a3dd2 ("net: dsa: don't allocate the slave_mii_bus using devres")
> 
> mdiobus_free() will panic when called from devm_mdiobus_free() <-
> devres_release_all() <- __device_release_driver(), and that mdiobus was
> not previously unregistered.
> 
> The Starfighter 2 is a platform device, so the initial set of
> constraints that I thought would cause this (I2C or SPI buses which call
> ->remove on ->shutdown) do not apply. But there is one more which
> applies here.
> 
> If the DSA master itself is on a bus that calls ->remove from ->shutdown
> (like dpaa2-eth, which is on the fsl-mc bus), there is a device link
> between the switch and the DSA master, and device_links_unbind_consumers()
> will unbind the bcm_sf2 switch driver on shutdown.
> 
> So the same treatment must be applied to all DSA switch drivers, which
> is: either use devres for both the mdiobus allocation and registration,
> or don't use devres at all.
> 
> The bcm_sf2 driver has the code structure in place for orderly mdiobus
> removal, so just replace devm_mdiobus_alloc() with the non-devres
> variant, and add manual free where necessary, to ensure that we don't
> let devres free a still-registered bus.
> 
> Fixes: ac3a68d56651 ("net: phy: don't abuse devres in devm_mdiobus_register()")
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian

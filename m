Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 48D344ACF1E
	for <lists+netdev@lfdr.de>; Tue,  8 Feb 2022 03:46:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345632AbiBHCqb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Feb 2022 21:46:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37052 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345508AbiBHCq3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Feb 2022 21:46:29 -0500
Received: from mail-pf1-x435.google.com (mail-pf1-x435.google.com [IPv6:2607:f8b0:4864:20::435])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6A8AFC06109E
        for <netdev@vger.kernel.org>; Mon,  7 Feb 2022 18:46:28 -0800 (PST)
Received: by mail-pf1-x435.google.com with SMTP id r19so637972pfh.6
        for <netdev@vger.kernel.org>; Mon, 07 Feb 2022 18:46:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=f41EUITFq9757EpKPhUcUXQC42+1z4BZZffbdhcGmAk=;
        b=LLd5wCKFCoALGBK9euyOThq8y21WT4G7CYalA6btX1osrVqC1q8DKWoZg506YXt71Z
         Iq/Foci2ug9aLkvj4pI5J8nRoz49j0AJy6N0Ikh4cDT+c52pEbn7CMb4tLIZmQrqhkyi
         I2Lqlyd6p/xLwevMPd+1x6ooweAZhqnxQWz+uRild0ldsPLuug/IOIz8Gy1yRvd+u8VM
         msuBM+e9ktwbCNnXLnXjAhsBII+gvchnHAiZCD2P4Z3B7RRBaDP0nOFHeiAJZseUrc8J
         k/WxH1Gr5kD+Qe4TovSiuIfENz6evtVjaK0JYwph9rFIrjVC8J94MkrGUaQtYLjYFCxn
         L4pQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=f41EUITFq9757EpKPhUcUXQC42+1z4BZZffbdhcGmAk=;
        b=RK3/jNxu7KUGXN9j8D2GgBHo9ReN34eOBK2bm8p+6HxlY1ZOXtgBnoFUX+S2VVyYQW
         aVxi6gFGpOSRgR9iFjFz6PBynpZVSaGnniX30wTukvTWCUKD53vExOKykjP8aqoEHt1+
         /2opwWaxEUo5PIBkTtzc900UhPbqqjwJXGo1IZLU0iLXNE0ZRs34V+H6RJgS6ksqJc5I
         xOCnTGDP6su6ZZJwE5t323iWPTBXFlYcmQSrLw6Hl6Ry3scnBLjEiXL5xKFJsgEQU1Mp
         5I/bZzyg9rzdzdkeyWRn/QqE6Oi55g/sb6x9RksjxCIWyY9FPmfz1D4lj7Y4qyz8ksn8
         X/JQ==
X-Gm-Message-State: AOAM530evAtctEvrdm8vrUXUH/fknxRM5daTBE4fCb9fuuxWMDQZqOfC
        gk1KngDnpyySVo72uEWC//I=
X-Google-Smtp-Source: ABdhPJyiMkeZJmD6t6ZrUjU2NkYVKMJIOGSIbNWPb98D0kyM6mKI6AgeJAZIRznL/Vg9mD8XGl9+Sg==
X-Received: by 2002:a63:5819:: with SMTP id m25mr1857294pgb.21.1644288387875;
        Mon, 07 Feb 2022 18:46:27 -0800 (PST)
Received: from [192.168.1.3] (ip72-194-116-95.oc.oc.cox.net. [72.194.116.95])
        by smtp.gmail.com with ESMTPSA id kb11sm673515pjb.51.2022.02.07.18.46.25
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 07 Feb 2022 18:46:27 -0800 (PST)
Message-ID: <4732261e-4437-97ba-ea96-a95bd619d475@gmail.com>
Date:   Mon, 7 Feb 2022 18:46:25 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.1
Subject: Re: [PATCH net 2/7] net: dsa: ar9331: register the mdiobus under
 devres
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
 <20220207161553.579933-3-vladimir.oltean@nxp.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20220207161553.579933-3-vladimir.oltean@nxp.com>
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
> The ar9331 is an MDIO device, so the initial set of constraints that I
> thought would cause this (I2C or SPI buses which call ->remove on
> ->shutdown) do not apply. But there is one more which applies here.
> 
> If the DSA master itself is on a bus that calls ->remove from ->shutdown
> (like dpaa2-eth, which is on the fsl-mc bus), there is a device link
> between the switch and the DSA master, and device_links_unbind_consumers()
> will unbind the ar9331 switch driver on shutdown.
> 
> So the same treatment must be applied to all DSA switch drivers, which
> is: either use devres for both the mdiobus allocation and registration,
> or don't use devres at all.
> 
> The ar9331 driver doesn't have a complex code structure for mdiobus
> removal, so just replace of_mdiobus_register with the devres variant in
> order to be all-devres and ensure that we don't free a still-registered
> bus.
> 
> Fixes: ac3a68d56651 ("net: phy: don't abuse devres in devm_mdiobus_register()")
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian

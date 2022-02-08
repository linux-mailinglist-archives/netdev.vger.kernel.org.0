Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C415E4ACF27
	for <lists+netdev@lfdr.de>; Tue,  8 Feb 2022 03:48:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346118AbiBHCsp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Feb 2022 21:48:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37912 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346116AbiBHCso (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Feb 2022 21:48:44 -0500
Received: from mail-pl1-x636.google.com (mail-pl1-x636.google.com [IPv6:2607:f8b0:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 23996C061A73
        for <netdev@vger.kernel.org>; Mon,  7 Feb 2022 18:48:44 -0800 (PST)
Received: by mail-pl1-x636.google.com with SMTP id j4so389766plj.8
        for <netdev@vger.kernel.org>; Mon, 07 Feb 2022 18:48:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=NEh5x0LVGd+qoMxieAe+IiZ/A7gCA2iHcNNv6+1ntpw=;
        b=Shvu9tWvyuQoh0LcpaNmNzxbWfY4RF1TXC11GuH4LQZ2xAvH+1JKlUSSEy5VqyRZ9O
         dQ+xW/RYCaTgcALHKCM0Q86RSQtBFp/caHA6lT7pgKU5CmZdlElvaZ3V0Risk9lkGRC2
         mOY24o+gkLg03oqgvzYCh+qwQbcQv8ginWFuvEbNwok5uMFj2Uhzp5ah8UwzR3Kf7i64
         d3ljewxpKDpcVD+uUR0NiqvPbdMHSc4AGMcyOyX2sPbVJ3nQ7d3izmxrz/BI1xzhhAoP
         llmdezqj7Oq/SARCwwQBaVnBUcA/vA1MBdvhtmO40LrdzZz1GnZSNmo6iqpv8eA4fTuV
         Rcig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=NEh5x0LVGd+qoMxieAe+IiZ/A7gCA2iHcNNv6+1ntpw=;
        b=cc/fxgIaRHurR9MhJYiaSE9huR5ZgZnh/qyBQRr4WKuRPra+Ob0QW1zZoaxLgTkc/I
         zRNk+xNeF/OJaPpdfEGZPkYUFGPXZoYu/HHUD7F0pEIiiRoNbgCx/B7XyYZXeJpdLIkb
         gOI0c32LLf4r9AhT0pP59/Um8/DQ1pkYGalF5BJXy6wuhmR2eu8UjAEctBgM7aAtoGKe
         8UBA79zikXu2X/LmNLm+fsDj++m4EYAXAk1UQeFLjX1JxAxkZ0ziPvtElipQGHFS2+gQ
         WjFiWZabFmkDyFK2X0R6ldVRJnefvd2VG+s6h6/yNdPK0+Nck4GlKBC5nmC6Vxm83TEl
         V4UQ==
X-Gm-Message-State: AOAM531nqpILqgOoqqp6tcCqCp+8RUByJtcVn8diq7UbpoSO6fNrPAQI
        l+Ek5ibXTA14LVCyWVoibPZTDeFC/p4=
X-Google-Smtp-Source: ABdhPJzLCoT2UziifSX5edoylV8TNKZYWPbNMJ3i/DJu+bfdwSIHdGdf6Dro2yOVwSbUvGybGX/eGQ==
X-Received: by 2002:a17:903:41c6:: with SMTP id u6mr2636273ple.71.1644288523603;
        Mon, 07 Feb 2022 18:48:43 -0800 (PST)
Received: from [192.168.1.3] (ip72-194-116-95.oc.oc.cox.net. [72.194.116.95])
        by smtp.gmail.com with ESMTPSA id h25sm12617270pfn.208.2022.02.07.18.48.41
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 07 Feb 2022 18:48:42 -0800 (PST)
Message-ID: <18635376-118f-4f98-74b5-6dbe81f893d9@gmail.com>
Date:   Mon, 7 Feb 2022 18:48:40 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.1
Subject: Re: [PATCH net 5/7] net: dsa: seville: register the mdiobus under
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
 <20220207161553.579933-6-vladimir.oltean@nxp.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20220207161553.579933-6-vladimir.oltean@nxp.com>
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
> The Seville VSC9959 switch is a platform device, so the initial set of
> constraints that I thought would cause this (I2C or SPI buses which call
> ->remove on ->shutdown) do not apply. But there is one more which
> applies here.
> 
> If the DSA master itself is on a bus that calls ->remove from ->shutdown
> (like dpaa2-eth, which is on the fsl-mc bus), there is a device link
> between the switch and the DSA master, and device_links_unbind_consumers()
> will unbind the seville switch driver on shutdown.
> 
> So the same treatment must be applied to all DSA switch drivers, which
> is: either use devres for both the mdiobus allocation and registration,
> or don't use devres at all.
> 
> The seville driver has a code structure that could accommodate both the
> mdiobus_unregister and mdiobus_free calls, but it has an external
> dependency upon mscc_miim_setup() from mdio-mscc-miim.c, which calls
> devm_mdiobus_alloc_size() on its behalf. So rather than restructuring
> that, and exporting yet one more symbol mscc_miim_teardown(), let's work
> with devres and replace of_mdiobus_register with the devres variant.
> When we use all-devres, we can ensure that devres doesn't free a
> still-registered bus (it either runs both callbacks, or none).
> 
> Fixes: ac3a68d56651 ("net: phy: don't abuse devres in devm_mdiobus_register()")
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian

Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DF0074ACF2B
	for <lists+netdev@lfdr.de>; Tue,  8 Feb 2022 03:50:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346119AbiBHCtl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Feb 2022 21:49:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38230 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238055AbiBHCtk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Feb 2022 21:49:40 -0500
Received: from mail-pf1-x435.google.com (mail-pf1-x435.google.com [IPv6:2607:f8b0:4864:20::435])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 12FDEC061355
        for <netdev@vger.kernel.org>; Mon,  7 Feb 2022 18:49:40 -0800 (PST)
Received: by mail-pf1-x435.google.com with SMTP id n32so16386118pfv.11
        for <netdev@vger.kernel.org>; Mon, 07 Feb 2022 18:49:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=zNQZXxqoOYkdXuYo5dD7WKNu4QDhFnzCJtPbDGQgP2o=;
        b=Wm+oKdqfraU8GZ5amC/CQiqquSc19ORVi4GHQ6GWCxf5893cPRNarg+i1XB/jmtaJ9
         D7jtR/PW48gx9yCpv8l8KTVx8Vq1Bo28t9NTGDkCMItOpHv2I6uqQsXljj1x7vb3uaYF
         YQDH5NwOmgb/adjO5JlhjzkZfXyMZ6wYLzazBkrbmObglsV7bbUms2LGzhrlEe9VtuKa
         CdaCjwB0Y9FKDJThp6SuERlTsrRVwj2DOIzu2Cuok46Po83Fjwh4jE8CKU18jX0GCaHa
         M2lpEmpGckNsu4i+mdGRBkkI8s7ACf4B191HIdrF24vD2vkjJ2RGiRZg5oR+ssIuS9nq
         r6Sg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=zNQZXxqoOYkdXuYo5dD7WKNu4QDhFnzCJtPbDGQgP2o=;
        b=ISC4+fWK2vRecHNBZZq+wJWXT3nSgqt4pYShreY5mJ7UVf7ZuMKaVbWg4z4ZOpuXyg
         b+9DhlG/hjJfnKY6Admqa3BsF8kfwxFW9ZP0Zw/8ZF5nmV+qH75RRHXTr2Yjbyr2U622
         LQ2baLerhiJIOCmArXX/KpAQnYpYAsV+h8e26HCHpkSAO/UGPr46q4fRKcE0D90AhwR3
         U0N+/1h2Y059F4gLkWiKMSSIyTcv5bjsLpktOKb8U9Tf/Mg239u6iJhBkR6mqGWscUCB
         Tij2+l9ZNvkgu9+ROemeTDDESARnWDFijkOSnsYbZ78TDqMyXRsziiniViF2l8Ejx5I+
         0uqA==
X-Gm-Message-State: AOAM530frrklGg4lWUKGJaPzTrs/ECmVSs31Z1eldOuFOW0luDDvQqjk
        Q90TKV164iJgtLK+j/2tSSw=
X-Google-Smtp-Source: ABdhPJwABHF7D6lc/Z4IeqLR8qqwyKkfsxaDzyitibrcjfPicN0fXM/f6yOTiCHZ01Kt0RH38ywyag==
X-Received: by 2002:a05:6a00:1c96:: with SMTP id y22mr2340970pfw.8.1644288579551;
        Mon, 07 Feb 2022 18:49:39 -0800 (PST)
Received: from [192.168.1.3] (ip72-194-116-95.oc.oc.cox.net. [72.194.116.95])
        by smtp.gmail.com with ESMTPSA id l20sm13928645pfc.53.2022.02.07.18.49.37
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 07 Feb 2022 18:49:38 -0800 (PST)
Message-ID: <92d44fc0-fafa-b445-d0cd-27179520b1d4@gmail.com>
Date:   Mon, 7 Feb 2022 18:49:36 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.1
Subject: Re: [PATCH net 7/7] net: dsa: lantiq_gswip: don't use devres for
 mdiobus
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
 <20220207161553.579933-8-vladimir.oltean@nxp.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20220207161553.579933-8-vladimir.oltean@nxp.com>
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
> The GSWIP switch is a platform device, so the initial set of constraints
> that I thought would cause this (I2C or SPI buses which call ->remove on
> ->shutdown) do not apply. But there is one more which applies here.
> 
> If the DSA master itself is on a bus that calls ->remove from ->shutdown
> (like dpaa2-eth, which is on the fsl-mc bus), there is a device link
> between the switch and the DSA master, and device_links_unbind_consumers()
> will unbind the GSWIP switch driver on shutdown.
> 
> So the same treatment must be applied to all DSA switch drivers, which
> is: either use devres for both the mdiobus allocation and registration,
> or don't use devres at all.
> 
> The gswip driver has the code structure in place for orderly mdiobus
> removal, so just replace devm_mdiobus_alloc() with the non-devres
> variant, and add manual free where necessary, to ensure that we don't
> let devres free a still-registered bus.
> 
> Fixes: ac3a68d56651 ("net: phy: don't abuse devres in devm_mdiobus_register()")
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian

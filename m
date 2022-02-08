Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5D7164ACF25
	for <lists+netdev@lfdr.de>; Tue,  8 Feb 2022 03:48:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346115AbiBHCsa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Feb 2022 21:48:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37822 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229888AbiBHCs3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Feb 2022 21:48:29 -0500
Received: from mail-pf1-x42d.google.com (mail-pf1-x42d.google.com [IPv6:2607:f8b0:4864:20::42d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 778E6C061355
        for <netdev@vger.kernel.org>; Mon,  7 Feb 2022 18:48:28 -0800 (PST)
Received: by mail-pf1-x42d.google.com with SMTP id i186so16455224pfe.0
        for <netdev@vger.kernel.org>; Mon, 07 Feb 2022 18:48:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=2aZqSBXGDf3/RmFKoGK0WLS8bd8u3NP/ekwoYCbOZYU=;
        b=b38L2gKvgzRyl9aCMZ8F0EAU58HaKVMbVX/j2aJx+3UF0L/G3n5AJJFy5HVPsNUdgT
         YNcK+R1fsXVoxNxzdf6TIFBycrQ0xG+1DyY6I1AFepwfPjpDBQH84WHy2yOhUpbLzXQC
         seEyPd9xqylCSIux0KK0E1NXukUF7XvKciMlBSEP+HxsWLnrzTLa0ueXH2RJ9cgd7dut
         c+bA+X/s6kpIVIx0rqIDrP1TmKkGcz/edi17LggLhSpOAUftYtjl/W8LxAdiGwHn/JZu
         AAFoAC5zLQMofObDe0tbAP9bJlxAJTge86vqr3wXtNnbrRH8z64aeA9V9Y4gQGlc0DmB
         fzcA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=2aZqSBXGDf3/RmFKoGK0WLS8bd8u3NP/ekwoYCbOZYU=;
        b=3SJknsxpHbmORjJS052/StIp8Ij+jBYJ5/DMU77jxJI17Wg6meJw+hTwPdpzcxfMZ6
         HBh4/Q3RPEt+7q7fjgdR1uo6pR1GKatazJ0aTIo152CHbXzTXJPhYMzzxKzVR+7LPaEl
         IMBU7HCiexqE1Wt+ma90w8NyZzXD7M2SyHkAP+rYtO77ak1edLnWEIKtnf0gYk4/UDLN
         S8b1IT0sJyR2/UkJJG7Mff5FNkYlwwLgRKlfrmioSVHeUK4bNFH/7RIvY1cm5zydskgG
         P9M+k8f3JsYFbG51kctM9QQgg+2iVUi13xMPzR/HacmosqA3qh6IRjcJEkOF0Y8ykbiJ
         fNaw==
X-Gm-Message-State: AOAM5310mlXJ1DjMHxMeh1C78xoHVSJEDXOTGYc41GuZKcSeqm/e6+en
        9YtodlG4RmQ2syonYAgWZnU=
X-Google-Smtp-Source: ABdhPJxKQoA8+PPuz26Al4O/0dZN0w/UpTOGHOas0WmkL24JO51IgA+M2Kwq6KPB426uJksKfuYUVg==
X-Received: by 2002:a63:8141:: with SMTP id t62mr15914pgd.266.1644288507926;
        Mon, 07 Feb 2022 18:48:27 -0800 (PST)
Received: from [192.168.1.3] (ip72-194-116-95.oc.oc.cox.net. [72.194.116.95])
        by smtp.gmail.com with ESMTPSA id s14sm13885605pfk.174.2022.02.07.18.48.26
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 07 Feb 2022 18:48:27 -0800 (PST)
Message-ID: <b180b3df-da13-18a5-7e59-c8114149314c@gmail.com>
Date:   Mon, 7 Feb 2022 18:48:25 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.1
Subject: Re: [PATCH net 4/7] net: dsa: felix: don't use devres for mdiobus
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
 <20220207161553.579933-5-vladimir.oltean@nxp.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20220207161553.579933-5-vladimir.oltean@nxp.com>
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
> The Felix VSC9959 switch is a PCI device, so the initial set of
> constraints that I thought would cause this (I2C or SPI buses which call
> ->remove on ->shutdown) do not apply. But there is one more which
> applies here.
> 
> If the DSA master itself is on a bus that calls ->remove from ->shutdown
> (like dpaa2-eth, which is on the fsl-mc bus), there is a device link
> between the switch and the DSA master, and device_links_unbind_consumers()
> will unbind the felix switch driver on shutdown.
> 
> So the same treatment must be applied to all DSA switch drivers, which
> is: either use devres for both the mdiobus allocation and registration,
> or don't use devres at all.
> 
> The felix driver has the code structure in place for orderly mdiobus
> removal, so just replace devm_mdiobus_alloc_size() with the non-devres
> variant, and add manual free where necessary, to ensure that we don't
> let devres free a still-registered bus.
> 
> Fixes: ac3a68d56651 ("net: phy: don't abuse devres in devm_mdiobus_register()")
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian

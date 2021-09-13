Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4E3CC4099F4
	for <lists+netdev@lfdr.de>; Mon, 13 Sep 2021 18:50:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239544AbhIMQv7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Sep 2021 12:51:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50434 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238876AbhIMQv6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Sep 2021 12:51:58 -0400
Received: from mail-pj1-x1036.google.com (mail-pj1-x1036.google.com [IPv6:2607:f8b0:4864:20::1036])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 792F9C061574;
        Mon, 13 Sep 2021 09:50:42 -0700 (PDT)
Received: by mail-pj1-x1036.google.com with SMTP id oc9so6772595pjb.4;
        Mon, 13 Sep 2021 09:50:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=jKmrMtYAU38Ek0NsTISM2Zo8smzHINIMpeNn3tlnY80=;
        b=gCMrRKvqPWRUrkSrGMik2fdH4KgaFn6e7amxvH8g3f5m02GSWYxxZA5KVXZ+QmyxuS
         ngTNTvlGITaNNmuLrgSK6W1Lf3+gOT3SSrBj4I9VnjihlA5CQfO/drvGvwYB1EHjwfpN
         axizCznZzmp+Mi86btY97Sv53/NMUAYKAKfFkqw5pD8XztHkjadwTVt858bbnfDXIRU+
         b8c9puerZoOFpzulKdEmmsoisWUXJ41mKCo2moG39jr8qHopuPEqNjMV01I23V9SnUXo
         5VghUSpYCtkpGy5n4ZXIcG6LadKt4AmcBCOeuRb10NWrZcvVU38TBULHGrFZTIER4JIV
         CR0w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=jKmrMtYAU38Ek0NsTISM2Zo8smzHINIMpeNn3tlnY80=;
        b=cqMKhziJfM9dL4A4cHVqZ/KOzYWY0ZvoCoajr8cUvdFHWVLOXCdruINeqG160E2hOm
         FtS+CuFsDL1t4U1JfSu0MApbBc8yYX3xE+Ii+ZK4CEJaglHiaWXmC/Aoq/Ea6vUUuVA9
         DCldrK/F78uMSx8dXDz1Lx639aYiIA/S+lYNNLLyAAme552zE4R1KsLwozWZixwhIKug
         Z+wBop9o3dkWnllgraTgSva6JNhWO43uV1OWET+Dmb1A17RQrLxEhKWjqa1xV+uxCsf1
         XDywxGwhvQerYZlaK7alwIuFlmeIEUKA+XumgKVUUjHgz9mYXtW3OVfkIcZXdH8tYzOD
         3XAw==
X-Gm-Message-State: AOAM530l1r1kbY2pBdKIXFW/YPETDTYkK/lPyMtpbry4mchlwoHxB93Z
        rXBnw0aWsz/WzUrDgq+8ZvkoKOKUtzY=
X-Google-Smtp-Source: ABdhPJywRgCWqJleziXMBtnAEhoFJMaZd/Llu0A0ZhV0dc/inc29V4ho7O1FsiUQKMXD1tig/GAbew==
X-Received: by 2002:a17:902:a407:b0:138:849b:56f6 with SMTP id p7-20020a170902a40700b00138849b56f6mr11398144plq.0.1631551841867;
        Mon, 13 Sep 2021 09:50:41 -0700 (PDT)
Received: from [192.168.1.121] (99-44-17-11.lightspeed.irvnca.sbcglobal.net. [99.44.17.11])
        by smtp.gmail.com with ESMTPSA id u24sm7754410pfm.85.2021.09.13.09.50.39
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 13 Sep 2021 09:50:41 -0700 (PDT)
Message-ID: <77c03355-f05e-2731-806d-df7e95c45b12@gmail.com>
Date:   Mon, 13 Sep 2021 09:50:38 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.1.0
Subject: Re: [RFC PATCH net 3/5] net: dsa: hellcreek: be compatible with
 masters which unregister on shutdown
Content-Language: en-US
To:     Vladimir Oltean <vladimir.oltean@nxp.com>, netdev@vger.kernel.org
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        Hauke Mehrtens <hauke@hauke-m.de>,
        Woojung Huh <woojung.huh@microchip.com>,
        UNGLinuxDriver@microchip.com, Sean Wang <sean.wang@mediatek.com>,
        Landen Chao <Landen.Chao@mediatek.com>,
        DENG Qingfang <dqfext@gmail.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        George McCollister <george.mccollister@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Oleksij Rempel <linux@rempel-privat.de>,
        Michael Grzeschik <m.grzeschik@pengutronix.de>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org,
        Lino Sanfilippo <LinoSanfilippo@gmx.de>
References: <20210912120932.993440-1-vladimir.oltean@nxp.com>
 <20210912120932.993440-4-vladimir.oltean@nxp.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20210912120932.993440-4-vladimir.oltean@nxp.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 9/12/2021 5:09 AM, Vladimir Oltean wrote:
> Since commit 2f1e8ea726e9 ("net: dsa: link interfaces with the DSA
> master to get rid of lockdep warnings"), DSA gained a requirement which
> it did not fulfill, which is to unlink itself from the DSA master at
> shutdown time.
> 
> Since the hellcreek driver was introduced after the bad commit, it has
> never worked with DSA masters which decide to unregister their
> net_device on shutdown, effectively hanging the reboot process.
> 
> Hellcreek is a platform device driver, so we probably cannot have the
> oddities of ->shutdown and ->remove getting both called for the exact
> same struct device. But to be in line with the pattern from the other
> device drivers which are on slow buses, implement the same "if this then
> not that" pattern of either running the ->shutdown or the ->remove hook.
> The driver's current ->remove implementation makes that very easy
> because it already zeroes out its device_drvdata on ->remove.
> 
> Fixes: e4b27ebc780f ("net: dsa: Add DSA driver for Hirschmann Hellcreek switches")
> Link: https://lore.kernel.org/netdev/20210909095324.12978-1-LinoSanfilippo@gmx.de/
> Reported-by: Lino Sanfilippo <LinoSanfilippo@gmx.de>
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian

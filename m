Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9F7344099F6
	for <lists+netdev@lfdr.de>; Mon, 13 Sep 2021 18:51:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239941AbhIMQwV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Sep 2021 12:52:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50534 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239698AbhIMQwU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Sep 2021 12:52:20 -0400
Received: from mail-pg1-x52b.google.com (mail-pg1-x52b.google.com [IPv6:2607:f8b0:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 76C7AC061760;
        Mon, 13 Sep 2021 09:51:04 -0700 (PDT)
Received: by mail-pg1-x52b.google.com with SMTP id u18so10062551pgf.0;
        Mon, 13 Sep 2021 09:51:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=u8LSn204FDqhGyF0mRHlJ+uof8bjln9ACZwGJ4VJX/Q=;
        b=ilq7JmMnDjs41l5IclgdcW1Z9freZdaRf+3oq0i6Qet/fxHzA1mxEv62jZdGc887or
         J6tCtrBXyQZUYUqXNoh1IYCjNoRIoB+/sar4zeOnxSvp+ppk2NDc4WwX+RzZtkKS+ZKa
         DZaOijUuOBfdVZcg4BHr9lavDRCjYp1HH++4Qf4+W+ScdynyF1SVi9+ppm+uRiXpc4sV
         D4kd+0A3TFVUyTjTtSwAmZpVNBtKL3xNkQ5feex8wsGB4rI6w2QrZgZLsq632cLZKWB0
         oB3naggJovqO0tgQ5x4VN/C+A6d7S082F4Q+gtPMxO2z7i3mLKRzKH1oHl2Je8P0qi1A
         HHfA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=u8LSn204FDqhGyF0mRHlJ+uof8bjln9ACZwGJ4VJX/Q=;
        b=6h1luUtjbX+evg7gXBVGkLSocqagvla7vacuPUPgNbTOsvAHl30VMlgc1sw4Rbe9ti
         j3wjcmNFn5GW+Mlhw+p6j7WNYpKhTIR19EthIyeoOlwtbWkUe0CD8EZ46IALn2aV3KZr
         gB7uyhPdxTUwaK6zpcGBOFmI3dlWH10THL+pHT5GsXpcaqPhVNJZ3JCy2m6JajAaDYL4
         /WTjC3UPHJ68irKCCs18M1r59VRhvzCJ4B/twCQT0FfMKgwSTPLt10BlzDOqdB7ZzcxY
         UBQIy10jJTGF3fvV1RQJqP9iW+g8xeog7uCnh8D8iEd/JN/8ghgvFAvtYKl1SEB99kym
         4JLg==
X-Gm-Message-State: AOAM532r7r22P6TXtgoFKx7BLIYrjhWI/up6K2xXQ3vAtgpYvDPQgWXH
        OO5P88/YdFOxavOHL57eaSs=
X-Google-Smtp-Source: ABdhPJz+Z/0fZXWXpqmgD1KoL8aLN+20FwGJLzMhTXASueU2yb4r9RmckOLdl8484bbj9ONhKCycbg==
X-Received: by 2002:a62:8281:0:b0:3f6:3b92:3698 with SMTP id w123-20020a628281000000b003f63b923698mr331543pfd.55.1631551863939;
        Mon, 13 Sep 2021 09:51:03 -0700 (PDT)
Received: from [192.168.1.121] (99-44-17-11.lightspeed.irvnca.sbcglobal.net. [99.44.17.11])
        by smtp.gmail.com with ESMTPSA id w11sm8570713pgf.5.2021.09.13.09.51.01
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 13 Sep 2021 09:51:03 -0700 (PDT)
Message-ID: <d8bcc915-8b3d-f68e-8a04-1b33eaeca165@gmail.com>
Date:   Mon, 13 Sep 2021 09:51:00 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.1.0
Subject: Re: [RFC PATCH net 4/5] net: dsa: microchip: ksz8863: be compatible
 with masters which unregister on shutdown
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
 <20210912120932.993440-5-vladimir.oltean@nxp.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20210912120932.993440-5-vladimir.oltean@nxp.com>
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
> Since the Microchip sub-driver for KSZ8863 was introduced after the bad
> commit, it has never worked with DSA masters which decide to unregister
> their net_device on shutdown, effectively hanging the reboot process.
> To fix that, we need to call dsa_switch_shutdown.
> 
> Since this driver expects the MDIO bus to be backed by mdio_bitbang, I
> don't think there is currently any MDIO bus driver which implements its
> ->shutdown by redirecting it to ->remove, but in any case, to be
> compatible with that pattern, it is necessary to implement an "if this
> then not that" scheme, to avoid ->remove and ->shutdown from being
> called both for the same struct device.
> 
> Fixes: 60a364760002 ("net: dsa: microchip: Add Microchip KSZ8863 SMI based driver support")
> Link: https://lore.kernel.org/netdev/20210909095324.12978-1-LinoSanfilippo@gmx.de/
> Reported-by: Lino Sanfilippo <LinoSanfilippo@gmx.de>
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian

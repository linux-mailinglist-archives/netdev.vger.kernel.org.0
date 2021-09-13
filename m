Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7D047409A23
	for <lists+netdev@lfdr.de>; Mon, 13 Sep 2021 18:56:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241010AbhIMQ5b (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Sep 2021 12:57:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51882 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238966AbhIMQ52 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Sep 2021 12:57:28 -0400
Received: from mail-pj1-x1029.google.com (mail-pj1-x1029.google.com [IPv6:2607:f8b0:4864:20::1029])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B2734C061574;
        Mon, 13 Sep 2021 09:56:12 -0700 (PDT)
Received: by mail-pj1-x1029.google.com with SMTP id v19so4111310pjh.2;
        Mon, 13 Sep 2021 09:56:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=s7JXjudNAvVAT8INF+9UU5Gmm38N1/XGnQ2A94jG1bk=;
        b=SX5baUWspzyFSQ2AFuob8sstRM5Ha/Y1VxXQEQgIbgOJFaTfvJkC2iAgL52ErHsZ0i
         xmiV1acAbL+M1taGIYFo6nMLcaU424EyH1TAEOb7UVY/TofnN+/DNYtP2z6Qo4LG9hL8
         X6eTlEtbh+fOzN61hHvmV+GfRkHlQcUwO7X/BOvbnB14pO23728IHXRLYNi6CVN1a740
         4n6Ri3BZbplT2QEuUdBqf2hTIltST4r7SZadpaLQkzz35l0LeTToi8d2L6H2T1jtqPQv
         44yLmDtskYqHFB1YCNFGEuNlUPHDV9q2sgEUMtLDHoaffvhyGbHdXeWH26iV2NaRicI9
         4N/Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=s7JXjudNAvVAT8INF+9UU5Gmm38N1/XGnQ2A94jG1bk=;
        b=TcT2yEPi2TRFiZOTUXUS47iu6kEPQisSJtJFSyT2w0sLolKumop1J0NfZ20Hbu/BDH
         iOMDZ9TSKQ5Cgdnw0YNWdZGaWk74mWFDaX0O/0lT+VfRiFMhzZ3P97Yg39JU+wcGpbIM
         K7bl2XwmSmLK5o9tmKiR0Z4EZFNl7eyEKrXBne5U6mID5JBjgWHgmpQI5wTkAfG7yi2P
         ygGb1K/T0CdAqlfqpzegTaGT/K0NfAR7E/8ytw8dh0XPtKxxr7ajEqKm2uIe/2Umvb/f
         DLJZrwd/qiS3tOWxgfdTL/pFGoKveI5fugU2/bqK3v+BRviWZ2smW4vgFBCHQvhB3AD2
         /gjA==
X-Gm-Message-State: AOAM532Zyy36L26+fIbDXbpn2drIAZC16HAGC1f5FkBhM9iq2tTUIWnh
        Vta49VT3dtXRnajTFWxk9II=
X-Google-Smtp-Source: ABdhPJyoLFc+poLIjiuG0ZAogAYR00iOdxLlkK0HZFX9tOSs/Mi7cwpVZhz13ZDtTRsX3WUyIkMWMw==
X-Received: by 2002:a17:90b:1212:: with SMTP id gl18mr484897pjb.146.1631552172057;
        Mon, 13 Sep 2021 09:56:12 -0700 (PDT)
Received: from [192.168.1.121] (99-44-17-11.lightspeed.irvnca.sbcglobal.net. [99.44.17.11])
        by smtp.gmail.com with ESMTPSA id mi18sm7945827pjb.15.2021.09.13.09.56.09
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 13 Sep 2021 09:56:11 -0700 (PDT)
Message-ID: <7ba3fe1c-009a-15b4-3049-4fd9d96dbf3f@gmail.com>
Date:   Mon, 13 Sep 2021 09:56:07 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.1.0
Subject: Re: [RFC PATCH net 2/5] net: dsa: be compatible with masters which
 unregister on shutdown
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
 <20210912120932.993440-3-vladimir.oltean@nxp.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20210912120932.993440-3-vladimir.oltean@nxp.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 9/12/2021 5:09 AM, Vladimir Oltean wrote:
> Lino reports that on his system with bcmgenet as DSA master and KSZ9897
> as a switch, rebooting or shutting down never works properly.
> 
> What does the bcmgenet driver have special to trigger this, that other
> DSA masters do not? It has an implementation of ->shutdown which simply
> calls its ->remove implementation. Otherwise said, it unregisters its
> network interface on shutdown.
> 
> This message can be seen in a loop, and it hangs the reboot process there:
> 
> unregister_netdevice: waiting for eth0 to become free. Usage count = 3
> 
> So why 3?
> 
> A usage count of 1 is normal for a registered network interface, and any
> virtual interface which links itself as an upper of that will increment
> it via dev_hold. In the case of DSA, this is the call path:
> 
> dsa_slave_create
> -> netdev_upper_dev_link
>     -> __netdev_upper_dev_link
>        -> __netdev_adjacent_dev_insert
>           -> dev_hold
> 
> So a DSA switch with 3 interfaces will result in a usage count elevated
> by two, and netdev_wait_allrefs will wait until they have gone away.
> 
> Other stacked interfaces, like VLAN, watch NETDEV_UNREGISTER events and
> delete themselves, but DSA cannot just vanish and go poof, at most it
> can unbind itself from the switch devices, but that must happen strictly
> earlier compared to when the DSA master unregisters its net_device, so
> reacting on the NETDEV_UNREGISTER event is way too late.
> 
> It seems that it is a pretty established pattern to have a driver's
> ->shutdown hook redirect to its ->remove hook, so the same code is
> executed regardless of whether the driver is unbound from the device, or
> the system is just shutting down. As Florian puts it, it is quite a big
> hammer for bcmgenet to unregister its net_device during shutdown, but
> having a common code path with the driver unbind helps ensure it is well
> tested.
> 
> So DSA, for better or for worse, has to live with that and engage in an
> arms race of implementing the ->shutdown hook too, from all individual
> drivers, and do something sane when paired with masters that unregister
> their net_device there. The only sane thing to do, of course, is to
> unlink from the master.
> 
> However, complications arise really quickly.
> 
> The pattern of redirecting ->shutdown to ->remove is not unique to
> bcmgenet or even to net_device drivers. In fact, SPI controllers do it
> too (see dspi_shutdown -> dspi_remove), and presumably, I2C controllers
> and MDIO controllers do it too (this is something I have not researched
> too deeply, but even if this is not the case today, it is certainly
> plausible to happen in the future, and must be taken into consideration).
> 
> Since DSA switches might be SPI devices, I2C devices, MDIO devices, the
> insane implication is that for the exact same DSA switch device, we
> might have both ->shutdown and ->remove getting called.
> 
> So we need to do something with that insane environment. The pattern
> I've come up with is "if this, then not that", so if either ->shutdown
> or ->remove gets called, we set the device's drvdata to NULL, and in the
> other hook, we check whether the drvdata is NULL and just do nothing.
> This is probably not necessary for platform devices, just for devices on
> buses, but I would really insist for consistency among drivers, because
> when code is copy-pasted, it is not always copy-pasted from the best
> sources.
> 
> So depending on whether the DSA switch's ->remove or ->shutdown will get
> called first, we cannot really guarantee even for the same driver if
> rebooting will result in the same code path on all platforms. But
> nonetheless, we need to do something minimally reasonable on ->shutdown
> too to fix the bug. Of course, the ->remove will do more (a full
> teardown of the tree, with all data structures freed, and this is why
> the bug was not caught for so long). The new ->shutdown method is kept
> separate from dsa_unregister_switch not because we couldn't have
> unregistered the switch, but simply in the interest of doing something
> quick and to the point.
> 
> The big question is: does the DSA switch's ->shutdown get called earlier
> than the DSA master's ->shutdown? If not, there is still a risk that we
> might still trigger the WARN_ON in unregister_netdevice that says we are
> attempting to unregister a net_device which has uppers. That's no good.
> Although the reference to the master net_device won't physically go away
> even if DSA's ->shutdown comes afterwards, remember we have a dev_hold
> on it.
> 
> The answer to that question lies in this comment above device_link_add:
> 
>   * A side effect of the link creation is re-ordering of dpm_list and the
>   * devices_kset list by moving the consumer device and all devices depending
>   * on it to the ends of these lists (that does not happen to devices that have
>   * not been registered when this function is called).
> 
> so the fact that DSA uses device_link_add towards its master is not
> exactly for nothing. device_shutdown() walks devices_kset from the back,
> so this is our guarantee that DSA's shutdown happens before the master's
> shutdown.
> 
> Fixes: 2f1e8ea726e9 ("net: dsa: link interfaces with the DSA master to get rid of lockdep warnings")
> Link: https://lore.kernel.org/netdev/20210909095324.12978-1-LinoSanfilippo@gmx.de/
> Reported-by: Lino Sanfilippo <LinoSanfilippo@gmx.de>
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>

LGTM, after you fix the b53_mmap.c build fix.
-- 
Florian

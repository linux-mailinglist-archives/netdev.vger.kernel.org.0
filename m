Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0A9512793E7
	for <lists+netdev@lfdr.de>; Sat, 26 Sep 2020 00:03:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728051AbgIYWDf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Sep 2020 18:03:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39936 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726687AbgIYWDe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 25 Sep 2020 18:03:34 -0400
Received: from mail-ed1-x532.google.com (mail-ed1-x532.google.com [IPv6:2a00:1450:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7CE4CC0613CE;
        Fri, 25 Sep 2020 15:03:34 -0700 (PDT)
Received: by mail-ed1-x532.google.com with SMTP id w1so4066843edr.3;
        Fri, 25 Sep 2020 15:03:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=PfB5GrheyIxnuAWoT4Dsjo6Mha9ADMRuQTrX6xNqieM=;
        b=jYd4vVauL82htavV5DVWBFt35LGUeihssisY05RbiHtTLMH1W2WclaKNei4NEaX1xF
         mjJN1hc11c8Vb7ATOQUoX8r7X2oJIlwZiXmuE9YtGGuejIuEsU6HKZKHlO/kFpnUWiSw
         etcfK56weRaTSIM/YZ0kW1we6+hVqRwq7w3C9QNPWSwrN+Qpbv79oZVJB0iXntdgbD8u
         KAl9vf7vyOhJ5S0dHAlKfoVmBHSklOR7hMVongLBZl29la+Wy5NjQVI++8mW5qL2acHd
         jWgbR0KXJGcbQhH89ciba6kB6lxciOwnSS//IZynAhPVElj6Tc2e3V764l9hfFc3WsZY
         qeVw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=PfB5GrheyIxnuAWoT4Dsjo6Mha9ADMRuQTrX6xNqieM=;
        b=ZIV5S1ijOpD+NL8Z7qKGcqJpFK+FCDJdXqrwietSgf/BJZNWnpXUMhBSiIM+crpxKY
         yojPLa+f0JTE+ocX7e3LvvQlHqg09t41WPQP7LY2DZ5Ok2Pkogf5kaQwJCqO9Mq39Ien
         DcCsDnuBsh5o54G4cRaWlJ6pH1f/jKJOANPmm5YqXTjBMyw6vtwobUwgyi1Akv201dJV
         OcCTrK1+YDSDUhmReyksmd/IqAzNW/JwFJ7z9vmBvI8XpXSSsD2vKbZAoaDaHBSkGCnt
         IthpR/Dg5NLlQse0KlbQpaNOjnKp8lkWTY0Zz5X5LV/0wD06nHbUbSGkNoVrqkE+lIrU
         Csrg==
X-Gm-Message-State: AOAM530zw2GUO5mDVR+6gcHwnxnZi9eon/3LCIjIkJ1ovacV84Dbeorm
        QbAT56SikJywaxbCHwcB+VA=
X-Google-Smtp-Source: ABdhPJyGUVsG+yL+Rkb1/RH2dwFszvvzId3+1LmhXmXvj3lb8f6D/iaxC1P/kNs7PvAxUn8g3w/wcw==
X-Received: by 2002:a50:8c24:: with SMTP id p33mr3715365edp.330.1601071413119;
        Fri, 25 Sep 2020 15:03:33 -0700 (PDT)
Received: from skbuf ([188.25.217.212])
        by smtp.gmail.com with ESMTPSA id bo8sm2769846edb.39.2020.09.25.15.03.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 25 Sep 2020 15:03:31 -0700 (PDT)
Date:   Sat, 26 Sep 2020 01:03:29 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Martin Blumenstingl <martin.blumenstingl@googlemail.com>,
        f.fainelli@gmail.com
Cc:     netdev@vger.kernel.org, linux-amlogic@lists.infradead.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux@armlinux.org.uk, peppe.cavallaro@st.com,
        alexandre.torgue@st.com, joabreu@synopsys.com, davem@davemloft.net,
        kuba@kernel.org
Subject: Re: RGMII timing calibration (on 12nm Amlogic SoCs) - integration
 into dwmac-meson8b
Message-ID: <20200925220329.wdnrqeauto55vdao@skbuf>
References: <CAFBinCATt4Hi9rigj52nMf3oygyFbnopZcsakGL=KyWnsjY3JA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAFBinCATt4Hi9rigj52nMf3oygyFbnopZcsakGL=KyWnsjY3JA@mail.gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Martin,

On Fri, Sep 25, 2020 at 11:47:18PM +0200, Martin Blumenstingl wrote:
> Hello,
>
> Amlogic's 12nm SoC generation requires some RGMII timing calibration
> within the Ethernet controller glue registers.
> This calibration is only needed for the RGMII modes, not for the
> (internal) RMII PHY.
> With "incorrect" calibration settings Ethernet speeds up to 100Mbit/s
> will still work fine, but no data is flowing on 1Gbit/s connections
> (similar to when RX or TX delay settings are incorrect).
>
> A high-level description of this calibration (the full code can be
> seen in [0] and [1]):
> - there are sixteen possible calibration values: [0..15]
> - switch the Ethernet PHY to loopback mode
> - for each of the sixteen possible calibration values repeat the
> following steps five times:
> -- write the value to the calibration register
> -- construct an Ethernet loopback test frame with protocol 0x0808
> ("Frame Relay ARP")
> -- add 256 bytes of arbitrary data
> -- use the MAC address of the controller as source and destination
> -- send out this data packet
> -- receive this data packet
> -- compare the contents and remember if the data is valid or corrupted
> - disable loopback mode on the Ethernet PHY
> - find the best calibration value by getting the center point of the
> "longest streak"
> - write this value to the calibration register
>
> My question is: how do I integrate this into the dwmac-meson8b (stmmac
> based) driver?
> I already found some interesting and relevant bits:
> - stmmac_selftests.c uses phy_loopback() and also constructs data
> which is sent-out in loopback mode
> - there's a serdes_powerup callback in struct plat_stmmacenet_data
> which is called after register_netdev()
> - I'm not sure if there's any other Ethernet driver doing some similar
> calibration (and therefore a way to avoid some code-duplication)
>
>
> Any recommendations/suggestions/ideas/hints are welcome!
> Thank you and best regards,
> Martin
>
>
> [0] https://github.com/khadas/u-boot/blob/4752efbb90b7d048a81760c67f8c826f14baf41c/drivers/net/designware.c#L707
> [1] https://github.com/khadas/linux/blob/khadas-vims-4.9.y/drivers/net/ethernet/stmicro/stmmac/dwmac-meson.c#L466

Florian attempted something like this before, for the PHY side of things:
https://patchwork.ozlabs.org/project/netdev/patch/20191015224953.24199-3-f.fainelli@gmail.com/

There are quite some assumptions to be made if the code is to be made
generic, such as the fact that the controller should not drop frames
with bad FCS in hardware. Or if it does, the code should be aware of
that and check that counter.

Thanks,
-Vladimir

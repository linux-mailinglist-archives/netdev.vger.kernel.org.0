Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 37DB45162AD
	for <lists+netdev@lfdr.de>; Sun,  1 May 2022 10:23:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244470AbiEAI0k (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 1 May 2022 04:26:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54380 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243772AbiEAI0i (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 1 May 2022 04:26:38 -0400
Received: from mail-lj1-x22b.google.com (mail-lj1-x22b.google.com [IPv6:2a00:1450:4864:20::22b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 462FA3DA55
        for <netdev@vger.kernel.org>; Sun,  1 May 2022 01:23:14 -0700 (PDT)
Received: by mail-lj1-x22b.google.com with SMTP id c15so15200725ljr.9
        for <netdev@vger.kernel.org>; Sun, 01 May 2022 01:23:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=semihalf-com.20210112.gappssmtp.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=1FgAGOgKVH52PF7L4avUtVlJkwo06dnHRwv/BhAiO4E=;
        b=0XwXlDujLqWvDsq1G6ys9UUof8fXBwJ14DUBf8Dv2o1ANcqm4WoJKZuRUehHHcZ1S0
         hfp1F3mMtyD+EWVuGT3u9p9TD+cj+aMpYcpi50sLlIcgSpnQLGzIfqQjEb2p6CRUkDAI
         uuGb02SO/L06oPcqCRDHuejKUmQtjaFLy6R2PnRixyTjVgsQc/AucRAlmLLqhOrpW1m9
         Rew1jn1htlk0kOnppwQEBikKnidK7TKbBTxuzLrUqWmNMTkmsQ7vn1idaH8aApEyIP2V
         KjEcDc94miSf0lg8GP7KNznn8UzzVBJ59P6TOVjumDDjHg+xMAdBO5CnLZmhohlpOWef
         T/hw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=1FgAGOgKVH52PF7L4avUtVlJkwo06dnHRwv/BhAiO4E=;
        b=CBULOBaldmCS31EwtxiYeFOXc8tWO2nQiTyxesNmQdbkJjICmUfjTVE7W0FZAahocR
         kZLtoTuVKG346hlkey8VHKS+IrKE26hekcKnYFJNT6wPGl8hWXreplDwScYbtb+ZbmeU
         orpe0yv7wgwZT9+dAmN5WRYkHIdRihZIJ7Iz13ju2z8nlKdc8kracaP65AiCp54iGHEb
         T0aOfutptCDvCGbJbO/SeOf65rEgYbf6FDNw5OptRF0h2dUXtrsVBhXB8POyfvDxagpc
         vtX24qbd/63pVxuC7NnHAQvJqBCRvPzCNfrL4WnboKgKr5CoYqJUlgK5+xkUfJkip4xm
         Q1Qw==
X-Gm-Message-State: AOAM531AJ43GonENRQhj//fXS9yDxQaWxs0KzCEgeCBcDXTEqnNUKgGS
        eYIH3xysJAgLzf8EbFRaqluYe4mHx24n65OogLTFHRonKlZ52Q==
X-Google-Smtp-Source: ABdhPJwLcTdN4UbdBxVr6M2ajkc3CZGfpgPbpKmB6fDb/587Bd8KrX7KfnvVZSoQfXCA9mtMt8f4M2P/P/wAf3hO8RM=
X-Received: by 2002:a05:651c:4c7:b0:24f:4017:a2ce with SMTP id
 e7-20020a05651c04c700b0024f4017a2cemr4915008lji.5.1651393392501; Sun, 01 May
 2022 01:23:12 -0700 (PDT)
MIME-Version: 1.0
References: <2460cc37a4138d3cfb598349e78f0c5f3cfa59c7.1651071936.git.baruch@tkos.co.il>
 <CAPv3WKf5dnOrzkm6uaFYHkuZZ2ANrr3PMNrUhU5SV6TFAJE2Qw@mail.gmail.com>
 <87levpzcds.fsf@tarshish> <CAPv3WKc1eM4gyD_VG2M+ozzvLYrDAXiKGvK6Ej_ykRVf-Zf9Mw@mail.gmail.com>
 <87czh1yn4x.fsf@tarshish> <878rrlznvu.fsf@tarshish>
In-Reply-To: <878rrlznvu.fsf@tarshish>
From:   Marcin Wojtas <mw@semihalf.com>
Date:   Sun, 1 May 2022 10:23:01 +0200
Message-ID: <CAPv3WKfC25Uh2ufDh-4+5UPdyU7BLevmXw01pjFOM-kNrVQMeA@mail.gmail.com>
Subject: Re: [PATCH] net: mvpp2: add delay at the end of .mac_prepare
To:     Baruch Siach <baruch@tkos.co.il>
Cc:     Russell King <linux@armlinux.org.uk>,
        netdev <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Baruch,

niedz., 1 maj 2022 o 09:57 Baruch Siach <baruch@tkos.co.il> napisa=C5=82(a)=
:
>
> Hi Marcin,
>
> On Thu, Apr 28 2022, Baruch Siach wrote:
> > On Thu, Apr 28 2022, Marcin Wojtas wrote:
> >> I booted MacchiatoBin doubleshot with DT (phy-mode set to "10gbase-r")
> >> without your patch and the 3310 PHY is connected to 1G e1000 card.
> >> After `ifconfig eth0 up` it properly drops to SGMII without any issue
> >> in my setup:
> >>
> >> # ifconfig eth0 up
> >> [   62.006580] mvpp2 f2000000.ethernet eth0: PHY
> >> [f212a600.mdio-mii:00] driver [mv88x3310] (irq=3DPOLL)
> >> [   62.016777] mvpp2 f2000000.ethernet eth0: configuring for phy/sgmii=
 link mode
> >> # [   66.110289] mvpp2 f2000000.ethernet eth0: Link is Up - 1Gbps/Full
> >> - flow control rx/tx
> >> [   66.118270] IPv6: ADDRCONF(NETDEV_CHANGE): eth0: link becomes ready
> >> # ifconfig eth0 192.168.1.1
> >> # ping 192.168.1.2
> >> PING 192.168.1.2 (192.168.1.2): 56 data bytes
> >> 64 bytes from 192.168.1.2: seq=3D0 ttl=3D64 time=3D0.511 ms
> >> 64 bytes from 192.168.1.2: seq=3D1 ttl=3D64 time=3D0.212 ms
> >
> > This is what I see here:
> >
> > [   46.097184] mvpp2 f2000000.ethernet eth0: PHY [f212a600.mdio-mii:02]=
 driver [mv88x3310] (irq=3DPOLL)
> > [   46.115071] mvpp2 f2000000.ethernet eth0: configuring for phy/10gbas=
e-r link mode
> > [   50.249513] mvpp2 f2000000.ethernet eth0: Link is Up - 1Gbps/Full - =
flow control rx/tx
> > [   50.257539] IPv6: ADDRCONF(NETDEV_CHANGE): eth0: link becomes ready
> >
> > It is almost the same except from the link mode. Why does it try sgmii
> > even before auto-negotiation takes place?
>
> I have now tested on my Macchiatobin, and the issue does not
> reproduce. PHY firmware version here:
>
> [    1.074605] mv88x3310 f212a600.mdio-mii:00: Firmware version 0.2.1.0
>
> But still I see that pl->link_config.interface is initially set to
> PHY_INTERFACE_MODE_10GBASER:
>
> [   13.518118] mvpp2 f2000000.ethernet eth0: configuring for phy/10gbase-=
r link mode
>
> This is set in phylink_create() based on DT phy-mode. After interface
> down/up sequence pl->link_config.interface matches the 1G wire rate:
>
> [   33.383971] mvpp2 f2000000.ethernet eth0: configuring for phy/sgmii li=
nk mode
>
> Do you have any idea where your initial PHY_INTERFACE_MODE_SGMII comes
> from?
>

I have the same behavior, the link configured to 10GBASER and switches
to 1G by linux init scripts. When I do the first ifconfig up, it's
already at SGMII state:

# dmesg | grep eth1
[    2.071753] mvpp2 f2000000.ethernet eth1: Using random mac address
12:27:35:ff:2d:48
[    3.461338] mvpp2 f2000000.ethernet eth1: PHY
[f212a600.mdio-mii:00] driver [mv88x3310] (irq=3DPOLL)
[    3.679714] mvpp2 f2000000.ethernet eth1: configuring for
phy/10gbase-r link mode
[    7.775483] mvpp2 f2000000.ethernet eth1: Link is Up - 1Gbps/Full -
flow control rx/tx
[    7.783455] IPv6: ADDRCONF(NETDEV_CHANGE): eth1: link becomes ready
[    8.801107] mvpp2 f2000000.ethernet eth1: Link is Down
# ifconfig eth1 up
[   37.498617] mvpp2 f2000000.ethernet eth1: PHY
[f212a600.mdio-mii:00] driver [mv88x3310] (irq=3DPOLL)
[   37.508812] mvpp2 f2000000.ethernet eth1: configuring for phy/sgmii link=
 mode
[   41.598331] mvpp2 f2000000.ethernet eth1: Link is Up - 1Gbps/Full -
flow control rx/tx
[   41.606309] IPv6: ADDRCONF(NETDEV_CHANGE): eth1: link becomes ready
#

Best regards,
Marcin

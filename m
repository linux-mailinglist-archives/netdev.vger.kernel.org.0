Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2D7BB202C6F
	for <lists+netdev@lfdr.de>; Sun, 21 Jun 2020 21:38:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730344AbgFUTh5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 21 Jun 2020 15:37:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52224 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730070AbgFUTh4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 21 Jun 2020 15:37:56 -0400
Received: from mail-ed1-x544.google.com (mail-ed1-x544.google.com [IPv6:2a00:1450:4864:20::544])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6B60EC061794
        for <netdev@vger.kernel.org>; Sun, 21 Jun 2020 12:37:55 -0700 (PDT)
Received: by mail-ed1-x544.google.com with SMTP id g1so11908082edv.6
        for <netdev@vger.kernel.org>; Sun, 21 Jun 2020 12:37:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=CWnDmafMP8vdilyoxxFZUfbSYi5dktxixw3zE/1zftY=;
        b=W6ik+ZXtIbzTNKSv6N8O+4QSeapIxB20z6NxkIcRKFNHDkBakCdYkCM1Jd1KJ0fUqq
         cSbvCh5ZTi1J/SV72vY336Ckq7HQ+txmKnFq0n10EYEtSktONBLEkNN3tLWdfTCFO14x
         xMt6kPeU7EZZYZ7SRzR4dMNHLxRl1OyJTzzVH3fxLm3YBt1lxV3As0SaefPkoKic55vX
         GYTd/gp0nacY5GI21XzrNby5+z0xmiHvHORU7XsHmp8X2daGXyo93oKTHaNFpuTco0Yg
         RNCYM+KYIYiy8GwRxoRNiuz/pC7IEWWVLdZ6igEHjmpfX+v+WTErDV19w4TYnXyZfh1a
         y1jw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=CWnDmafMP8vdilyoxxFZUfbSYi5dktxixw3zE/1zftY=;
        b=NDPcVlwvI/BY/LZTDk53neie/HFvVVI/ewkm4V4nYxWG4FOCh0J8v8oOhIrg7UMqm1
         RSR4w9nxcaZIJX8i4pFSUKB++sdvIV7STr5iKpEuyDHC1gbQMZNa2pjdBHS7AdRqABp2
         Mg16jCXlhdZzAfpesariq5x+NHH3+fpe8DCZefOy6292kK9GREe5GAz/HuTVQNLQqj7E
         0tQgAofew/sF6Icoe+OIdR30XMTp2F6JWZyTQK0SNeWtZqJ42gv/Ut+5MlAvlpW97ggx
         UYqojyZNyNrJ+j0ercAZhEqLfD8md1IFLGn6j29Y/xT8rTa8WXG7BkDdJ5fxViSTxYIu
         iQXw==
X-Gm-Message-State: AOAM531l9pVYehrXqfgTvE1t6/qYr7wJOSLENwdGCt1MI+5ZU4jv07z5
        WAWuTm8SeaKwX9CbksWM0BKytYwgU2cWFGuPINw=
X-Google-Smtp-Source: ABdhPJwPwKYCd9e4PN1L+qYoI893fY/1Aj0ZXp5DfchyfiWroP3jBBC/zQ8sTcoXnkd5oip0Uisfl6yw7r2d3WSdCL8=
X-Received: by 2002:aa7:c157:: with SMTP id r23mr14006468edp.139.1592768274080;
 Sun, 21 Jun 2020 12:37:54 -0700 (PDT)
MIME-Version: 1.0
References: <20200217172242.GZ25745@shell.armlinux.org.uk> <20200621143340.GI1605@shell.armlinux.org.uk>
In-Reply-To: <20200621143340.GI1605@shell.armlinux.org.uk>
From:   Vladimir Oltean <olteanv@gmail.com>
Date:   Sun, 21 Jun 2020 22:37:43 +0300
Message-ID: <CA+h21ho2Papr2gXqap2LGE3N4LJAbor2WxzX1quDckVvw-mQ5Q@mail.gmail.com>
Subject: Re: [CFT 0/8] rework phylink interface for split MAC/PCS support
To:     Russell King - ARM Linux admin <linux@armlinux.org.uk>
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Felix Fietkau <nbd@openwrt.org>,
        John Crispin <john@phrozen.org>,
        Sean Wang <sean.wang@mediatek.com>,
        Mark Lee <Mark-MC.Lee@mediatek.com>,
        Microchip Linux Driver Support <UNGLinuxDriver@microchip.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Oleksij Rempel <o.rempel@pengutronix.de>,
        "David S. Miller" <davem@davemloft.net>,
        "moderated list:ARM/Mediatek SoC support" 
        <linux-arm-kernel@lists.infradead.org>,
        "moderated list:ARM/Mediatek SoC support" 
        <linux-mediatek@lists.infradead.org>,
        netdev <netdev@vger.kernel.org>, Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Russell,

On Sun, 21 Jun 2020 at 17:34, Russell King - ARM Linux admin
<linux@armlinux.org.uk> wrote:
>
> All,
>
> This is now almost four months old, but I see that I didn't copy the
> message to everyone who should've been, especially for the five
> remaining drivers.
>
> I had asked for input from maintainers to help me convert their
> phylink-using drivers to the new style where mac_link_up() performs
> the speed, duplex and pause setup rather than mac_config(). So far,
> I have had very little assistance with this, and it is now standing
> in the way of further changes to phylink, particularly with proper
> PCS support. You are effectively blocking this work; I can't break
> your code as that will cause a kernel regression.
>
> This is one of the reasons why there were not many phylink patches
> merged for the last merge window.
>
> The following drivers in current net-next remain unconverted:
>
> drivers/net/ethernet/mediatek/mtk_eth_soc.c
> drivers/net/dsa/ocelot/felix.c
> drivers/net/dsa/qca/ar9331.c
> drivers/net/dsa/bcm_sf2.c
> drivers/net/dsa/b53/b53_common.c
>
> These can be easily identified by grepping for conditionals where the
> expression matches the "MLO_PAUSE_.X" regexp.
>
> I have an untested patch that I will be sending out today for
> mtk_eth_soc.c, but the four DSA ones definitely require their authors
> or maintainers to either make the changes, or assist with that since
> their code is not straight forward.
>
> Essentially, if you are listed in this email's To: header, then you
> are listed as a maintainer for one of the affected drivers, and I am
> requesting assistance from you for this task please.
>
> Thanks.
>
> Russell.
>

If forcing MAC speed is to be moved in mac_link_up(), and if (as you
requested in the mdio-lynx-pcs thread) configuring the PCS is to be
moved in pcs_link_up() and pcs_config() respectively, then what
remains to be done in mac_config()?

Regards,
-Vladimir

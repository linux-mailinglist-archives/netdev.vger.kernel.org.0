Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 878AF21C31A
	for <lists+netdev@lfdr.de>; Sat, 11 Jul 2020 09:52:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728052AbgGKHwr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 11 Jul 2020 03:52:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35080 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726958AbgGKHwr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 11 Jul 2020 03:52:47 -0400
Received: from mail-ed1-x541.google.com (mail-ed1-x541.google.com [IPv6:2a00:1450:4864:20::541])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2EBB2C08C5DD;
        Sat, 11 Jul 2020 00:52:47 -0700 (PDT)
Received: by mail-ed1-x541.google.com with SMTP id d18so6361955edv.6;
        Sat, 11 Jul 2020 00:52:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=chblfhw/pZ7F1F13XRbjCEZ4EpDpVMofJy+rOKK895o=;
        b=rZQEKQXLQHKsEKZ14YIUwLgP1Gg4TVDuTNwwxGCX1yBHgmGU0JmdWGoPJqVUKH4Ije
         9V6yRwBMetaPJrBSAk3DJIWfCMv9HkUDdzL39lNSoKVcgsTAwOExFiru9aFF4wJWaT6J
         TvQ7kVPHGLHQ4qznP/EDGXTDXI7M4DI0YFawdEuCC5DSaMtB5hvlSkVOsF2Rm/tc8McB
         Igjw9ApnydtBCHn/MJjexNiGHiLZ0NSp5j1H7KA++jOAnfnd1LqhHqQMQXvt6AkmIWti
         Nps1YyHiiIEOaygafwoUVSUbFx+4CpJ3fCj5dfmAaJbUeRSmkMmvonPiv5FYLTKT6WcP
         dIqA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=chblfhw/pZ7F1F13XRbjCEZ4EpDpVMofJy+rOKK895o=;
        b=G2bzA9dh88knSy1uQwYJoTEE+9VoIoHe6iMAeA5JwwbToVwwxoYofSovGOmbY64fke
         Unja7tbgpiEpCOHX6qxN0Y+2gYNbopC0gDDjY+bp3g77JqICUPZxHZ1NkrTY8xmzaUtA
         eDWTDpsi4Lr5F0zbwernAxgoVJAJCKj681bdho0JJ7TXL9tafchoL4gvLxjkmjspvqxJ
         6TMLoB2VoZIL4jW1DV6AJK0tcI22W49DwAJco2s4bxhJV37+dBMvO2PWOnGAN7Tp7TOt
         2MbfgK39Cn/cLCEoBpVx5FPaCo6MJf7DY1TcCVbuUXH22pEMS6hb4KHxIZ/Tj5WwLWqt
         HDSw==
X-Gm-Message-State: AOAM532p6CZqCSPV/t2dyMGHy49SjzLioTXDM3zj/73KxOCdya2djZSC
        2XsORtYg4q75RUdu7EOtbHs=
X-Google-Smtp-Source: ABdhPJwihN9PIaXQhbGqnJH6ukFMQ3u+W+sA+rUYcCgbXMxlm1nwnsGuXmBouw+4drIRnpRE9Tl0IQ==
X-Received: by 2002:aa7:c24d:: with SMTP id y13mr84833261edo.123.1594453965789;
        Sat, 11 Jul 2020 00:52:45 -0700 (PDT)
Received: from skbuf ([188.25.219.134])
        by smtp.gmail.com with ESMTPSA id r17sm6262069edw.68.2020.07.11.00.52.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 11 Jul 2020 00:52:44 -0700 (PDT)
Date:   Sat, 11 Jul 2020 10:52:42 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Michael Walle <michael@walle.cc>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, Andrew Lunn <andrew@lunn.ch>,
        Alex Marginean <alexandru.marginean@nxp.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Heiko Thiery <heiko.thiery@gmail.com>,
        Russell King - ARM Linux admin <linux@armlinux.org.uk>,
        Ioana Ciornei <ioana.ciornei@nxp.com>,
        Microchip Linux Driver Support <UNGLinuxDriver@microchip.com>
Subject: Re: [PATCH net-next v6 0/4] net: enetc: remove bootloader dependency
Message-ID: <20200711075242.dl72ymyyby6ivsk2@skbuf>
References: <20200709213526.21972-1-michael@walle.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200709213526.21972-1-michael@walle.cc>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jul 09, 2020 at 11:35:22PM +0200, Michael Walle wrote:
> This is a resend [now a new v6] of the series because the conversion to the
> phylink interface will likely take longer:
> https://lore.kernel.org/netdev/CA+h21hpBodyY8CtNH2ktRdc2FqPi=Fjp94=VVZvzSVbnvnfKVg@mail.gmail.com/
> Also the discussion in the v3 resend doesn't look like it will be resolved
> soon :/
> https://lore.kernel.org/netdev/20200701213433.9217-1-michael@walle.cc/
> 
> Unfortunately, we have boards in the wild with a bootloader which doesn't
> set the PCS up correctly. Thus I'd really see this patches picked up as an
> intermediate step until the phylink conversion is ready. Vladimir Oltean
> already offered to convert enetc to phylink when he converts the felix to
> phylink. After this series the PCS setup of the enetc looks almost the same
> as the current felix setup. Thus conversion should be easy.
> 
> These patches were picked from the following series:
> https://lore.kernel.org/netdev/1567779344-30965-1-git-send-email-claudiu.manoil@nxp.com/
> They have never been resent. I've picked them up, addressed Andrews
> comments, fixed some more bugs and asked Claudiu if I can keep their SOB
> tags; he agreed. I've tested this on our board which happens to have a
> bootloader which doesn't do the enetc setup in all cases. Though, only
> SGMII mode was tested.
> 
> changes since v5:
>  - fixed pcs->autoneg_complete and pcs->link assignment. Thanks Vladimir.
> 
> changes since v4:
>  - moved (and renamed) the USXGMII constants to include/uapi/linux/mdio.h.
>    Suggested by Russell King.
> 
> changes since v3:
>  - rebased to latest net-next where devm_mdiobus_free() was removed.
>    replace it by mdiobus_free(). The internal MDIO bus is optional, if
>    there is any error, we try to run with the bootloader default PCS
>    settings, thus in the error case, we need to free the mdiobus.
> 
> changes since v2:
>  - removed SOBs from "net: enetc: Initialize SerDes for SGMII and USXGMII
>    protocols" because almost everything has changed.
>  - get a phy_device for the internal PCS PHY so we can use the phy_
>    functions instead of raw mdiobus writes
>  - reuse macros already defined in fsl_mdio.h, move missing bits from
>    felix to fsl_mdio.h, because they share the same PCS PHY building
>    block
>  - added 2500BaseX mode (based on felix init routine)
>  - changed xgmii mode to usxgmii mode, because it is actually USXGMII and
>    felix does the same.
>  - fixed devad, which is 0x1f (MMD_VEND2)
> 
> changes since v1:
>  - mdiobus id is '"imdio-%s", dev_name(dev)' because the plain dev_name()
>    is used by the emdio.
>  - use mdiobus_write() instead of imdio->write(imdio, ..), since this is
>    already a full featured mdiobus
>  - set phy_mask to ~0 to avoid scanning the bus
>  - use phy_interface_mode_is_rgmii(phy_mode) to also include the RGMII
>    modes with pad delays.
>  - move enetc_imdio_init() to enetc_pf.c, there shouldn't be any other
>    users, should it?
>  - renamed serdes to SerDes
>  - printing the error code of mdiobus_register() in the error path
>  - call mdiobus_unregister() on _remove()
>  - call devm_mdiobus_free() if mdiobus_register() fails, since an
>    error is not fatal
> 
> Alex Marginean (1):
>   net: enetc: Use DT protocol information to set up the ports
> 
> Michael Walle (3):
>   net: phy: add USXGMII link partner ability constants
>   net: dsa: felix: (re)use already existing constants
>   net: enetc: Initialize SerDes for SGMII and USXGMII protocols
> 
>  drivers/net/dsa/ocelot/felix_vsc9959.c        |  45 ++---
>  .../net/ethernet/freescale/enetc/enetc_hw.h   |   3 +
>  .../net/ethernet/freescale/enetc/enetc_pf.c   | 188 +++++++++++++++---
>  .../net/ethernet/freescale/enetc/enetc_pf.h   |   5 +
>  include/uapi/linux/mdio.h                     |  26 +++
>  5 files changed, 210 insertions(+), 57 deletions(-)
> 
> -- 
> 2.20.1
> 

I plan to give this series a go on an LS1028A-QDS later today to make
sure there are no regressions.

Thanks,
-Vladimir

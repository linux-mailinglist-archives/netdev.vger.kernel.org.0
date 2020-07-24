Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A34B322D179
	for <lists+netdev@lfdr.de>; Fri, 24 Jul 2020 23:47:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726801AbgGXVrc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Jul 2020 17:47:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59500 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726591AbgGXVrc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Jul 2020 17:47:32 -0400
Received: from mail-ej1-x641.google.com (mail-ej1-x641.google.com [IPv6:2a00:1450:4864:20::641])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AD6CEC0619D3
        for <netdev@vger.kernel.org>; Fri, 24 Jul 2020 14:47:31 -0700 (PDT)
Received: by mail-ej1-x641.google.com with SMTP id v18so3032362ejb.0
        for <netdev@vger.kernel.org>; Fri, 24 Jul 2020 14:47:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=RiQE4DBnFE5++miAG59HLKGw+ZeKXwPzcd4r1fRSRpM=;
        b=Jqwn06XPvBxMAKyq8t7qlTl/KN1JOKX+96ZjkuEo4Dh8zl3Vcz/DfIQXJWIdtA0yix
         Hn+bhzaU5V9360tWocb5j66gxnAUx78PDxyNxE/CKsJfEbKXQAf6bRlTVYZBAWQfJprn
         qZ33QIqe5jmtUPG9K90kiDogQrHu+PMDwFhNAoWNWZ1M/8BHAVpNGMfOo8XW2BLOFLGx
         sN1xg7FABxTehoSutIHSKhY8wLB0dZk4wm11zNFwXJreatPl7YYXDBtFx/RCxaLiPqXm
         xmUQS0mmB/T9pndHxxp0mp5PDnlC7GwP37BkhX386iC/zdrLypWIILblElA9qQNFkg5k
         JfgA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=RiQE4DBnFE5++miAG59HLKGw+ZeKXwPzcd4r1fRSRpM=;
        b=pBajmkmAE53yAEJd14eWU44nKum4OH+VugcDYtQSZVkbJWuemGBMHMhwAsrHXJlguc
         c6Gj+usTj+1xdjzKu/Pof8MUqKC6XXclSOTi+LaWCfifFz5yMzIw/g6y6j0LbKRY6Mlb
         dTK69N0VPWQykY+QXZJq1nZX0MRDt8tdzheo6mZKwQ8jWpyYVmF3K2B3dKydgZ/aVkGN
         CFbohDc48HmghwuwHi6Pa0wHq/lODbFIzOfQ9RV5qVP/glyBQ6ezx2kGXPGmpGzzrKvA
         bv2v22UZrF0iKbbd6xlOqkia/VuvXwGzGQJ5NWdPtkeuzJ/mlsxTHnBs8wnNN4tbaVEA
         apEA==
X-Gm-Message-State: AOAM5329P7FD4bs0GpcHBVv05DgGamH4amL3Sv+VlNANaCCEaKkAA2E/
        G4hMuZX/31Z9mk0A4RMIfKU=
X-Google-Smtp-Source: ABdhPJzcIGqbsNWN9tO2IRY06VqCmFLw2SG8MGXRZppGu6w9Q27De8iLH3nOQP2CDvaqyIlPXGw0Cw==
X-Received: by 2002:a17:907:72cc:: with SMTP id du12mr10988685ejc.357.1595627250282;
        Fri, 24 Jul 2020 14:47:30 -0700 (PDT)
Received: from skbuf ([188.25.219.134])
        by smtp.gmail.com with ESMTPSA id c9sm1500815edv.8.2020.07.24.14.47.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 24 Jul 2020 14:47:29 -0700 (PDT)
Date:   Sat, 25 Jul 2020 00:47:27 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Ioana Ciornei <ioana.ciornei@nxp.com>
Cc:     davem@davemloft.net, netdev@vger.kernel.org,
        vladimir.oltean@nxp.com, claudiu.manoil@nxp.com,
        alexandru.marginean@nxp.com, andrew@lunn.ch, linux@armlinux.org.uk,
        f.fainelli@gmail.com
Subject: Re: [PATCH net-next v4 0/5] net: phy: add Lynx PCS MDIO module
Message-ID: <20200724214727.c7dgmhb57hlecvgm@skbuf>
References: <20200724080143.12909-1-ioana.ciornei@nxp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200724080143.12909-1-ioana.ciornei@nxp.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jul 24, 2020 at 11:01:38AM +0300, Ioana Ciornei wrote:
> Add support for the Lynx PCS as a separate module in drivers/net/phy/.
> The advantage of this structure is that multiple ethernet or switch
> drivers used on NXP hardware (ENETC, Seville, Felix DSA switch etc) can
> share the same implementation of PCS configuration and runtime
> management.
> 
> The module implements phylink_pcs_ops and exports a phylink_pcs
> (incorporated into a lynx_pcs) which can be directly passed to phylink
> through phylink_pcs_set.
> 
> The first 3 patches add some missing pieces in phylink and the locked
> mdiobus write accessor. Next, the Lynx PCS MDIO module is added as a
> standalone module. The majority of the code is extracted from the Felix
> DSA driver. The last patch makes the necessary changes in the Felix and
> Seville drivers in order to use the new common PCS implementation.
> 
> At the moment, USXGMII (only with in-band AN), SGMII, QSGMII (with and
> without in-band AN) and 2500Base-X (only w/o in-band AN) are supported
> by the Lynx PCS MDIO module since these were also supported by Felix and
> no functional change is intended at this time.
> 
> Changes in v2:
>  * got rid of the mdio_lynx_pcs structure and directly exported the
>  functions without the need of an indirection
>  * made the necessary adjustments for this in the Felix DSA driver
>  * solved the broken allmodconfig build test by making the module
>  tristate instead of bool
>  * fixed a memory leakage in the Felix driver (the pcs structure was
>  allocated twice)
> 
> Changes in v3:
>  * added support for PHYLINK PCS ops in DSA (patch 5/9)
>  * cleanup in Felix PHYLINK operations and migrate to
>  phylink_mac_link_up() being the callback of choice for applying MAC
>  configuration (patches 6-8)
> 
> Changes in v4:
>  * use the newly introduced phylink PCS mechanism
>  * install the phylink_pcs in the phylink_mac_config DSA ops
>  * remove the direct implementations of the PCS ops
>  * do no use the SGMII_ prefix when referring to the IF_MORE register
>  * add a phylink helper to decode the USXGMII code word
>  * remove cleanup patches for Felix (these have been already accepted)
>  * Seville (recently introduced) now has PCS support through the same
>  Lynx PCS module
> 
> Ioana Ciornei (5):
>   net: phylink: add helper function to decode USXGMII word
>   net: phylink: consider QSGMII interface mode in
>     phylink_mii_c22_pcs_get_state
>   net: mdiobus: add clause 45 mdiobus write accessor
>   net: phy: add Lynx PCS module
>   net: dsa: ocelot: use the Lynx PCS helpers in Felix and Seville
> 
>  MAINTAINERS                              |   7 +
>  drivers/net/dsa/ocelot/Kconfig           |   1 +
>  drivers/net/dsa/ocelot/felix.c           |  28 +-
>  drivers/net/dsa/ocelot/felix.h           |  20 +-
>  drivers/net/dsa/ocelot/felix_vsc9959.c   | 374 ++---------------------
>  drivers/net/dsa/ocelot/seville_vsc9953.c |  21 +-
>  drivers/net/phy/Kconfig                  |   6 +
>  drivers/net/phy/Makefile                 |   1 +
>  drivers/net/phy/pcs-lynx.c               | 314 +++++++++++++++++++
>  drivers/net/phy/phylink.c                |  44 +++
>  include/linux/mdio.h                     |   6 +
>  include/linux/pcs-lynx.h                 |  21 ++
>  include/linux/phylink.h                  |   3 +
>  13 files changed, 442 insertions(+), 404 deletions(-)
>  create mode 100644 drivers/net/phy/pcs-lynx.c
>  create mode 100644 include/linux/pcs-lynx.h
> 
> -- 
> 2.25.1
> 

For the entire series:

Tested-by: Vladimir Oltean <vladimir.oltean@nxp.com>

Seville QSGMII with in-band AN
Felix QSGMII with in-band AN
Felix SGMII without in-band AN
Felix USXGMII with in-band AN

Thanks,
-Vladimir

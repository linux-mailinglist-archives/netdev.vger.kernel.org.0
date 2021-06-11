Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B12D63A4166
	for <lists+netdev@lfdr.de>; Fri, 11 Jun 2021 13:45:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231366AbhFKLrM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Jun 2021 07:47:12 -0400
Received: from mail-ej1-f50.google.com ([209.85.218.50]:39756 "EHLO
        mail-ej1-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230377AbhFKLrM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Jun 2021 07:47:12 -0400
Received: by mail-ej1-f50.google.com with SMTP id l1so4107927ejb.6
        for <netdev@vger.kernel.org>; Fri, 11 Jun 2021 04:45:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=ju38bHQjeWORzqRo9ATwT2G9SvylzVNrNSaJSuObRr8=;
        b=A+0FBd8V9UcOXDgfrZOeUnZquNmKAEAhdsk0i5mIXNC3bqsHX1bMt1n4/OT7LhMCm1
         hOg+5JbCyqI4Zed41x1UgPbK3UYUmtu7VLusVgQxAxEat+pX3xwOtOPTlFPHKMwNyAkq
         z+xWVBoBsKtJJz5IO3cKd6z3ctiKg7jcs0Wzm3jCJE114VzW/1k+LZ+GiJ/oFr3ZT8XL
         yKhDx2jjNupvMEqZFjwQF57jxul7wwaXcLcmh21xenCeMcJdxjEvQrIXCB/2iqTH1ZXm
         1dxe4nwg/mHez6/hju5fb6T0ICdnI6zx7ULQPUKi1LlMwoVGtAzydecq/zVP5nYMzktM
         g1XA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=ju38bHQjeWORzqRo9ATwT2G9SvylzVNrNSaJSuObRr8=;
        b=Ca1tG38UnVKqvjHToC+GDPimND+WGWNG5vLIoClx7XOn2vzDQ3QSxG6BV5NXxOOUk1
         VLiW6bkjPwxCKgCylOkRyiVOWCF5NimgCLknDj2sTpLRm53vYk24lMAP5LHZJij/oPFh
         sBTJ4XdbWHI9aoEikyKobV58ewB2E7jtLNrVhRCbaE36doq57KCr1RChJxk/AXNVbENf
         UpsBodsojbEJZy3hD0Rlb6GiuEDY5C0G16JB2lYo0KDEPqrzPqiqpL46G+G9oHjyn/hh
         LGfgL8m9YLB9kfwwBMvtYyNNmcVwkGZY+0pS/pgP402bMm2CutfLbC8mN3YsQHZaLZND
         vyCg==
X-Gm-Message-State: AOAM530MvwlvfuaKhQTyYkS7fiKzha9xLFgeRYkGugKqYxuyMaxweLnJ
        rASGTU77JUNAx2ZLcWGZmq8=
X-Google-Smtp-Source: ABdhPJzwf4qXhJGndqkTM0wvWYpNDdv4X8hk+kHVmoS3uHKA+bH2kwtBm8KR/COJyenZYv12ZfCacA==
X-Received: by 2002:a17:907:b14:: with SMTP id h20mr3201125ejl.257.1623411853907;
        Fri, 11 Jun 2021 04:44:13 -0700 (PDT)
Received: from skbuf ([188.26.52.84])
        by smtp.gmail.com with ESMTPSA id p13sm2503422edq.67.2021.06.11.04.44.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 11 Jun 2021 04:44:13 -0700 (PDT)
Date:   Fri, 11 Jun 2021 14:44:12 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org
Cc:     Wong Vee Khee <vee.khee.wong@linux.intel.com>,
        Ong Boon Leong <boon.leong.ong@intel.com>,
        Michael Sit Wei Hong <michael.wei.hong.sit@intel.com>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        Jose Abreu <Jose.Abreu@synopsys.com>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King - ARM Linux admin <linux@armlinux.org.uk>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>
Subject: Re: [PATCH v2 net-next 00/13] Port the SJA1105 DSA driver to XPCS
Message-ID: <20210611114412.kgapahacqyz72il4@skbuf>
References: <20210610181410.1886658-1-olteanv@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210610181410.1886658-1-olteanv@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jun 10, 2021 at 09:13:57PM +0300, Vladimir Oltean wrote:
> From: Vladimir Oltean <vladimir.oltean@nxp.com>
> 
> As requested when adding support for the NXP SJA1110, the SJA1105 driver
> could make use of the common XPCS driver, to eliminate some hardware
> specific code duplication.
> 
> This series modifies the XPCS driver so that it can accommodate the XPCS
> instantiation from NXP switches, and the SJA1105 driver so it can expose
> what the XPCS driver expects.
> 
> Tested on NXP SJA1105S and SJA1110A.
> 
> Changes in v2:
> - fix module build (pcs-xpcs-nxp.c is not a different module so this
>   means that we need to change the name of pcs-xpcs.ko to pcs_xpcs.ko).
> - delete sja1105_sgmii.h
> - just check for priv->pcs[port] instead of checking the PHY interface
>   mode each time.
> - add the 2500base-x check in one place where it was missing (before
>   mdio_device_create)
> - remove it from a few places where it is no longer necessary now that
>   we check more generically for the presence of priv->xpcs[port]
> 
> Vladimir Oltean (13):
>   net: pcs: xpcs: rename mdio_xpcs_args to dw_xpcs
>   net: stmmac: reverse Christmas tree notation in stmmac_xpcs_setup
>   net: stmmac: reduce indentation when calling stmmac_xpcs_setup
>   net: pcs: xpcs: move register bit descriptions to a header file
>   net: pcs: xpcs: add support for sgmii with no inband AN
>   net: pcs: xpcs: also ignore phy id if it's all ones
>   net: pcs: xpcs: add support for NXP SJA1105
>   net: pcs: xpcs: add support for NXP SJA1110
>   net: pcs: xpcs: export xpcs_do_config and xpcs_link_up
>   net: dsa: sja1105: migrate to xpcs for SGMII
>   net: dsa: sja1105: register the PCS MDIO bus for SJA1110
>   net: dsa: sja1105: SGMII and 2500base-x on the SJA1110 are 'special'
>   net: dsa: sja1105: plug in support for 2500base-x
> 
>  MAINTAINERS                                   |   2 +
>  drivers/net/dsa/sja1105/Kconfig               |   1 +
>  drivers/net/dsa/sja1105/sja1105.h             |   9 +
>  drivers/net/dsa/sja1105/sja1105_main.c        | 186 +++----------
>  drivers/net/dsa/sja1105/sja1105_mdio.c        | 255 +++++++++++++++++
>  drivers/net/dsa/sja1105/sja1105_sgmii.h       |  53 ----
>  drivers/net/dsa/sja1105/sja1105_spi.c         |  17 ++
>  drivers/net/ethernet/stmicro/stmmac/common.h  |   2 +-
>  .../net/ethernet/stmicro/stmmac/stmmac_main.c |  10 +-
>  .../net/ethernet/stmicro/stmmac/stmmac_mdio.c |   6 +-
>  drivers/net/pcs/Makefile                      |   4 +-
>  drivers/net/pcs/pcs-xpcs-nxp.c                | 185 ++++++++++++
>  drivers/net/pcs/pcs-xpcs.c                    | 263 +++++++++---------
>  drivers/net/pcs/pcs-xpcs.h                    | 115 ++++++++
>  include/linux/pcs/pcs-xpcs.h                  |  21 +-
>  15 files changed, 772 insertions(+), 357 deletions(-)
>  delete mode 100644 drivers/net/dsa/sja1105/sja1105_sgmii.h
>  create mode 100644 drivers/net/pcs/pcs-xpcs-nxp.c
>  create mode 100644 drivers/net/pcs/pcs-xpcs.h
> 
> -- 
> 2.25.1
> 

I see in patchwork this has "changes requested" but when I look through
the patches I see no feedback on them?
https://patchwork.kernel.org/project/netdevbpf/list/?series=498301&state=%2A&archive=both

The checkpatch warnings are along the lines of 'line length of 81/82
characters exceeds limit of 80', which I deliberately ignored, and 'you
didn't CC some random mailing list', which again was more or less
deliberate since I don't know if it would make any difference. Is that
the reason? There are no build failures with this version.

Thanks.

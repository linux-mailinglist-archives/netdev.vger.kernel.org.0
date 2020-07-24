Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6384022C898
	for <lists+netdev@lfdr.de>; Fri, 24 Jul 2020 16:58:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726701AbgGXO6j (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Jul 2020 10:58:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51486 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726539AbgGXO6j (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Jul 2020 10:58:39 -0400
Received: from mail-wr1-x444.google.com (mail-wr1-x444.google.com [IPv6:2a00:1450:4864:20::444])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 01B32C0619E4
        for <netdev@vger.kernel.org>; Fri, 24 Jul 2020 07:58:39 -0700 (PDT)
Received: by mail-wr1-x444.google.com with SMTP id q5so8591692wru.6
        for <netdev@vger.kernel.org>; Fri, 24 Jul 2020 07:58:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=r7z3kqffAILENhx2PwFKt/PKLBtoYO+d/ApQ2e9tzs8=;
        b=ogt6hTzqzPZxkRmK6oKvZq3N+WEBvaYIKIFNk5zMdvgQVJr2mlOkDE42r3SaIiBQLJ
         0qCJ8TyhkTTwJBLS3XRFCnopLJnWSmIVQkPvCf/3biaWUsMEQ7GpnB/VHyMomprUheQy
         QsKhwAIuQ5/4GzaJJd+GkJfVuasTnZNVUCsjbtuCwPQsd3n7VpkgAqD4CrFeUQRnsRiY
         ltpInl1+FKdrFWJlOKI2aDcPrAJpd6C8M7YVqbkTgYTN+1YXuuOos6S0TFDnYu8SYsgj
         D/Afyfr4nJrA4G1EemrzvqDKt3EEVrG7zHGN107m7WjNb1m6pNDbPCwEYMfmHjfnBVfh
         C+Lg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=r7z3kqffAILENhx2PwFKt/PKLBtoYO+d/ApQ2e9tzs8=;
        b=UB4ivlufOV9NMtZHDDv/g074JTQSlbRc5+xJfoMEkJgaHCdFEI+XvNLJyYmG02azX7
         RS0QXRlC2QX+6we4KLMvVN3AXv3L1GFKSgRq+6MyE5SjDLuTj8o38vCbJYcB1YV4UQY/
         B4fkJ2Z/nCvR5aQ0/20AqBVr2mk905NHrqghE4kBNYH3u4XqsTZLxudjaL+2SNNzTKBz
         dDstFU0fUnI8Cm+WFiI6/STOpNF3Bo0mxoY1pPDbZo838Y96lEXCfypVJjQn6fDkikYq
         vpVoYycmpx56490sYyXzYQszRKdgISdW/QI1rOUYym2mnaVtHSpRZYFFLevPVIPkSI3E
         R6Ow==
X-Gm-Message-State: AOAM533EZeLQ8ePkS59dItJz/6zL3zAJUBy+PLg2JzK6JrRpHb9w+Oxr
        QMMxfMyvbqsTE8eyfoIF4eILO3rSmmY=
X-Google-Smtp-Source: ABdhPJzGW9oxk7aw2R9ByG18wgcevibYu9oaEzkaAp0L88lZn8Tb/pVckPCeKvylboejUXX9lu2C9Q==
X-Received: by 2002:adf:82b2:: with SMTP id 47mr8701330wrc.17.1595602717635;
        Fri, 24 Jul 2020 07:58:37 -0700 (PDT)
Received: from localhost (jirka.pirko.cz. [84.16.102.26])
        by smtp.gmail.com with ESMTPSA id q7sm1584344wra.56.2020.07.24.07.58.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 24 Jul 2020 07:58:37 -0700 (PDT)
Date:   Fri, 24 Jul 2020 16:58:36 +0200
From:   Jiri Pirko <jiri@resnulli.us>
To:     Vadym Kochan <vadym.kochan@plvision.eu>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jiri Pirko <jiri@mellanox.com>,
        Ido Schimmel <idosch@mellanox.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Oleksandr Mazur <oleksandr.mazur@plvision.eu>,
        Serhiy Boiko <serhiy.boiko@plvision.eu>,
        Serhiy Pshyk <serhiy.pshyk@plvision.eu>,
        Volodymyr Mytnyk <volodymyr.mytnyk@plvision.eu>,
        Taras Chornyi <taras.chornyi@plvision.eu>,
        Andrii Savka <andrii.savka@plvision.eu>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Mickey Rachamim <mickeyr@marvell.com>
Subject: Re: [net-next v2 0/6] net: marvell: prestera: Add Switchdev driver
 for Prestera family ASIC device 98DX326x (AC3x)
Message-ID: <20200724145836.GA2216@nanopsycho>
References: <20200724141957.29698-1-vadym.kochan@plvision.eu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200724141957.29698-1-vadym.kochan@plvision.eu>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fri, Jul 24, 2020 at 04:19:51PM CEST, vadym.kochan@plvision.eu wrote:
>Marvell Prestera 98DX326x integrates up to 24 ports of 1GbE with 8
>ports of 10GbE uplinks or 2 ports of 40Gbps stacking for a largely
>wireless SMB deployment.
>
>Prestera Switchdev is a firmware based driver that operates via PCI bus.  The
>current implementation supports only boards designed for the Marvell Switchdev
>solution and requires special firmware.
>
>This driver implementation includes only L1, basic L2 support, and RX/TX.
>
>The core Prestera switching logic is implemented in prestera_main.c, there is
>an intermediate hw layer between core logic and firmware. It is
>implemented in prestera_hw.c, the purpose of it is to encapsulate hw
>related logic, in future there is a plan to support more devices with
>different HW related configurations.
>
>The following Switchdev features are supported:
>
>    - VLAN-aware bridge offloading
>    - VLAN-unaware bridge offloading
>    - FDB offloading (learning, ageing)
>    - Switchport configuration
>
>The original firmware image is uploaded to the linux-firmware repository.
>
>PATCHv2:
>    1) Use devlink_port_type_clear()
>
>    2) Add _MS prefix to timeout defines.
>
>    3) Remove not-needed packed attribute from the firmware ipc structs,
>       also the firmware image needs to be uploaded too (will do it soon).
>
>    4) Introduce prestera_hw_switch_fini(), to be mirrored with init and
>       do simple validation if the event handlers are unregistered.
>
>    5) Use kfree_rcu() for event handler unregistering.
>
>    6) Get rid of rcu-list usage when dealing with ports, not needed for
>       now.
>
>    7) Little spelling corrections in the error/info messages.
>
>    8) Make pci probe & remove logic mirrored.
>
>    9) Get rid of ETH_FCS_LEN in headroom setting, not needed.

Note it is much more convenient for the reviewer to see the changelog
per-patch. Could you please do it if there's going to be v3? Thanks!


>
>PATCH:
>    1) Fixed W=1 warnings
>
>    2) Renamed PCI driver name to be more generic "Prestera DX" because
>       there will be more devices supported.
>
>    3) Changed firmware image dir path: marvell/ -> mrvl/prestera/
>       to be aligned with location in linux-firmware.git (if such
>       will be accepted).
>
>RFC v3:
>    1) Fix prestera prefix in prestera_rxtx.c
>
>    2) Protect concurrent access from multiple ports on multiple CPU system
>       on tx path by spinlock in prestera_rxtx.c
>
>    3) Try to get base mac address from device-tree, otherwise use a random generated one.
>
>    4) Move ethtool interface support into separate prestera_ethtool.c file.
>
>    5) Add basic devlink support and get rid of physical port naming ops.
>
>    6) Add STP support in Switchdev driver.
>
>    7) Removed MODULE_AUTHOR
>
>    8) Renamed prestera.c -> prestera_main.c, and kernel module to
>       prestera.ko
>
>RFC v2:
>    1) Use "pestera_" prefix in struct's and functions instead of mvsw_pr_
>
>    2) Original series split into additional patches for Switchdev ethtool support.
>
>    3) Use major and minor firmware version numbers in the firmware image filename.
>
>    4) Removed not needed prints.
>
>    5) Use iopoll API for waiting on register's value in prestera_pci.c
>
>    6) Use standart approach for describing PCI ID matching section instead of using
>       custom wrappers in prestera_pci.c
>
>    7) Add RX/TX support in prestera_rxtx.c.
>
>    8) Rewritten prestera_switchdev.c with following changes:
>       - handle netdev events from prestera.c
>
>       - use struct prestera_bridge for bridge objects, and get rid of
>         struct prestera_bridge_device which may confuse.
>
>       - use refcount_t
>
>    9) Get rid of macro usage for sending fw requests in prestera_hw.c
>
>    10) Add base_mac setting as module parameter. base_mac is required for
>        generation default port's mac.
>
>Vadym Kochan (6):
>  net: marvell: prestera: Add driver for Prestera family ASIC devices
>  net: marvell: prestera: Add PCI interface support
>  net: marvell: prestera: Add basic devlink support
>  net: marvell: prestera: Add ethtool interface support
>  net: marvell: prestera: Add Switchdev driver implementation
>  dt-bindings: marvell,prestera: Add description for device-tree
>    bindings
>
> .../bindings/net/marvell,prestera.txt         |   34 +
> drivers/net/ethernet/marvell/Kconfig          |    1 +
> drivers/net/ethernet/marvell/Makefile         |    1 +
> drivers/net/ethernet/marvell/prestera/Kconfig |   25 +
> .../net/ethernet/marvell/prestera/Makefile    |    7 +
> .../net/ethernet/marvell/prestera/prestera.h  |  208 +++
> .../marvell/prestera/prestera_devlink.c       |  120 ++
> .../marvell/prestera/prestera_devlink.h       |   26 +
> .../ethernet/marvell/prestera/prestera_dsa.c  |  134 ++
> .../ethernet/marvell/prestera/prestera_dsa.h  |   37 +
> .../marvell/prestera/prestera_ethtool.c       |  737 ++++++++++
> .../marvell/prestera/prestera_ethtool.h       |   37 +
> .../ethernet/marvell/prestera/prestera_hw.c   | 1231 ++++++++++++++++
> .../ethernet/marvell/prestera/prestera_hw.h   |  181 +++
> .../ethernet/marvell/prestera/prestera_main.c |  653 +++++++++
> .../ethernet/marvell/prestera/prestera_pci.c  |  823 +++++++++++
> .../ethernet/marvell/prestera/prestera_rxtx.c |  860 +++++++++++
> .../ethernet/marvell/prestera/prestera_rxtx.h |   21 +
> .../marvell/prestera/prestera_switchdev.c     | 1286 +++++++++++++++++
> .../marvell/prestera/prestera_switchdev.h     |   16 +
> 20 files changed, 6438 insertions(+)
> create mode 100644 drivers/net/ethernet/marvell/prestera/Kconfig
> create mode 100644 drivers/net/ethernet/marvell/prestera/Makefile
> create mode 100644 drivers/net/ethernet/marvell/prestera/prestera.h
> create mode 100644 drivers/net/ethernet/marvell/prestera/prestera_devlink.c
> create mode 100644 drivers/net/ethernet/marvell/prestera/prestera_devlink.h
> create mode 100644 drivers/net/ethernet/marvell/prestera/prestera_dsa.c
> create mode 100644 drivers/net/ethernet/marvell/prestera/prestera_dsa.h
> create mode 100644 drivers/net/ethernet/marvell/prestera/prestera_ethtool.c
> create mode 100644 drivers/net/ethernet/marvell/prestera/prestera_ethtool.h
> create mode 100644 drivers/net/ethernet/marvell/prestera/prestera_hw.c
> create mode 100644 drivers/net/ethernet/marvell/prestera/prestera_hw.h
> create mode 100644 drivers/net/ethernet/marvell/prestera/prestera_main.c
> create mode 100644 drivers/net/ethernet/marvell/prestera/prestera_pci.c
> create mode 100644 drivers/net/ethernet/marvell/prestera/prestera_rxtx.c
> create mode 100644 drivers/net/ethernet/marvell/prestera/prestera_rxtx.h
> create mode 100644 drivers/net/ethernet/marvell/prestera/prestera_switchdev.c
> create mode 100644 drivers/net/ethernet/marvell/prestera/prestera_switchdev.h
>
>-- 
>2.17.1
>

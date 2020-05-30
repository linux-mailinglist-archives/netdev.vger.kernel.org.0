Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E5EC71E90EE
	for <lists+netdev@lfdr.de>; Sat, 30 May 2020 13:52:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728911AbgE3LwR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 30 May 2020 07:52:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42474 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728433AbgE3LwR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 30 May 2020 07:52:17 -0400
Received: from mail-ej1-x643.google.com (mail-ej1-x643.google.com [IPv6:2a00:1450:4864:20::643])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 00D2FC03E969
        for <netdev@vger.kernel.org>; Sat, 30 May 2020 04:52:17 -0700 (PDT)
Received: by mail-ej1-x643.google.com with SMTP id l27so4720935ejc.1
        for <netdev@vger.kernel.org>; Sat, 30 May 2020 04:52:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=FrAoaqyQSkK80KvqEzxkw94CJDa0gWtADX3Wjd254T4=;
        b=L7xaoarJu7kJRdKTMu9NwJh0o6DhOZV46fW4OgxqFMmn36MXOPlZDO+2t4G00HlXi6
         6z7+BiirfiL3hFlgjX3UJokqOeFc/usiDmMFKEMweHeYhM7ypwBHOWpHjpcVT5pJBau2
         i+GJ3h9jgw1NJRsobqNTVlbl4V79jC9kdcD1i0RqNL+Ar+iQGZTXZp6C2hOD1Ba3/TOC
         XGqEN2yV1D6F/o/IpUUG/a048dx+5piRYqdyaQPexsRM1aMwLumYsMLbqHv1Y66vbtcm
         8ZTKvWUNS9JSJKk7uTE8St4o/Kkoa4pecAZuHYIgN+okVhjrZBDFV5C1RZOL1lIgJrI/
         0RhA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=FrAoaqyQSkK80KvqEzxkw94CJDa0gWtADX3Wjd254T4=;
        b=YyQMlSQIL7jiINEgG0tMrAnaS6l6sSNMKgtBR3SLOvPI5wrkbts8s6cRaEnWBYsYw3
         o3TlP4pt3BYuggc91QHqZEliG+iFBytj6K9VDjUyAjjAUQ+8vZDepOwtEPDXY9noBpco
         coa6xHRkLDx/T6sh0mXA75xdYGNNuni9RAka6R+EPBdHW3epUyVULgNkOk6HobqNzbdE
         1JZQtKx7zUUtEWRhlSCI4h3y3QzcU1J3aFQGL3EXPpoPDp+x8sUMZv+dL77+gJkE7alm
         dyJgD0WFOhfqs6To0d+je64vDjW7fSx36sHcTxc6FCCLpmW7SdSC+InVXcjjRfyKfTAU
         Rk3w==
X-Gm-Message-State: AOAM530onk3OOmLqGBoe7KgArrqFOpGwl0WXFFtZRz+ZyT3WSW571Nop
        YFMGMmo1XxViyqapRKaqniw=
X-Google-Smtp-Source: ABdhPJw350vbxg8ZTUxCxNvVsoF74e3fN3zZWYPcQwatmsYlFtijCCyH3/08Cj6HT/kTsSu9qQMB7w==
X-Received: by 2002:a17:906:4d45:: with SMTP id b5mr11280651ejv.146.1590839535654;
        Sat, 30 May 2020 04:52:15 -0700 (PDT)
Received: from localhost.localdomain ([188.25.147.193])
        by smtp.gmail.com with ESMTPSA id z14sm9625203ejd.37.2020.05.30.04.52.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 30 May 2020 04:52:15 -0700 (PDT)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, andrew@lunn.ch, vivien.didelot@gmail.com,
        f.fainelli@gmail.com, antoine.tenart@bootlin.com,
        alexandre.belloni@bootlin.com, UNGLinuxDriver@microchip.com,
        alexandru.marginean@nxp.com, claudiu.manoil@nxp.com,
        madalin.bucur@oss.nxp.com, radu-andrei.bulie@nxp.com,
        fido_max@inbox.ru, broonie@kernel.org
Subject: [PATCH v2 net-next 00/13] New DSA driver for VSC9953 Seville switch
Date:   Sat, 30 May 2020 14:51:29 +0300
Message-Id: <20200530115142.707415-1-olteanv@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>

Looking at the Felix and Ocelot drivers, Maxim asked if it would be
possible to use them as a base for a new driver for the Seville switch
inside NXP T1040. Turns out, it is! The result is that the mscc_felix
driver was extended to probe on Seville.

The biggest challenge seems to be getting register read/write API
generic enough to cover such wild bitfield variations between hardware
generations.

There is a trivial dependency patch on the regmap core which is in Mark
Brown's for-next tree:
https://git.kernel.org/pub/scm/linux/kernel/git/broonie/regmap.git/commit/?h=for-next&id=8baebfc2aca26e3fa67ab28343671b82be42b22c
I didn't know what to do with it, so I just added it here as well, as
01/13, so that net-next builds wouldn't break.

Maxim Kochetkov (4):
  soc/mscc: ocelot: add MII registers description
  net: mscc: ocelot: convert SYS_PAUSE_CFG register access to regfield
  net: mscc: ocelot: extend watermark encoding function
  net: dsa: felix: introduce support for Seville VSC9953 switch

Vladimir Oltean (9):
  regmap: add helper for per-port regfield initialization
  net: dsa: felix: set proper link speed in felix_phylink_mac_config
  net: mscc: ocelot: convert port registers to regmap
  net: mscc: ocelot: convert QSYS_SWITCH_PORT_MODE and SYS_PORT_MODE to
    regfields
  net: dsa: felix: create a template for the DSA tags on xmit
  net: mscc: ocelot: split writes to pause frame enable bit and to
    thresholds
  net: mscc: ocelot: disable flow control on NPI interface
  net: dsa: felix: support half-duplex link modes
  net: dsa: felix: move probing to felix_vsc9959.c

 .../devicetree/bindings/net/dsa/ocelot.txt    |  106 +-
 drivers/net/dsa/ocelot/Kconfig                |   12 +-
 drivers/net/dsa/ocelot/Makefile               |    3 +-
 drivers/net/dsa/ocelot/felix.c                |  269 +---
 drivers/net/dsa/ocelot/felix.h                |   22 +-
 drivers/net/dsa/ocelot/felix_vsc9959.c        |  313 ++++-
 drivers/net/dsa/ocelot/seville_vsc9953.c      | 1111 +++++++++++++++++
 drivers/net/ethernet/mscc/ocelot.c            |   86 +-
 drivers/net/ethernet/mscc/ocelot.h            |    9 +-
 drivers/net/ethernet/mscc/ocelot_board.c      |   21 +-
 drivers/net/ethernet/mscc/ocelot_io.c         |   18 +-
 drivers/net/ethernet/mscc/ocelot_regs.c       |   61 +-
 include/linux/regmap.h                        |    8 +
 include/soc/mscc/ocelot.h                     |   68 +-
 include/soc/mscc/ocelot_dev.h                 |   78 --
 include/soc/mscc/ocelot_qsys.h                |   13 -
 include/soc/mscc/ocelot_sys.h                 |   23 -
 net/dsa/tag_ocelot.c                          |   21 +-
 18 files changed, 1811 insertions(+), 431 deletions(-)
 create mode 100644 drivers/net/dsa/ocelot/seville_vsc9953.c

-- 
2.25.1


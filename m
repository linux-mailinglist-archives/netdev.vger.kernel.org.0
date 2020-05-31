Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 92B251E9787
	for <lists+netdev@lfdr.de>; Sun, 31 May 2020 14:27:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728125AbgEaM1G (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 31 May 2020 08:27:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44746 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725912AbgEaM1F (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 31 May 2020 08:27:05 -0400
Received: from mail-ej1-x642.google.com (mail-ej1-x642.google.com [IPv6:2a00:1450:4864:20::642])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1CA9AC061A0E
        for <netdev@vger.kernel.org>; Sun, 31 May 2020 05:27:04 -0700 (PDT)
Received: by mail-ej1-x642.google.com with SMTP id x1so6557773ejd.8
        for <netdev@vger.kernel.org>; Sun, 31 May 2020 05:27:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=7pIri4ANVEN5TdpsWWkmPKNoKC/6RR0JRk0H9C6YdQE=;
        b=b3RHHn7d40+OHIfdi2TGQgWs6jRfTqo4I6dk9jALDCoJTMponeNv0fwppvFO7rb54m
         ESHOaLPuWlcRNdWktsO0eDZZp/lra/iOLCRQF2AIAi9N20z4M1xFXmJdCJj1Zoi7eSJb
         F8ESOTpXd4/RbQoyl/bPId65oP9TYpTBHJros+vg2RxyhoXVMtCn1noB64kcm11xIron
         Vh1aUj0+aaN1x+YnF/iIDGML8sFhjase05Ks4niSUh4oidX9aO++Q68jZgkqWs7kFU3A
         3BH4GqZA4rBz+JbTtImcwDDhORIi2RKrKPiDNiKZWGPXYAYcbTefLAKDFfT8XhyUQDGb
         rbaA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=7pIri4ANVEN5TdpsWWkmPKNoKC/6RR0JRk0H9C6YdQE=;
        b=gAnytF3tnS9/XttNgLGY92lytpQZfYMMQtzdlfzgdlGWGjHya5sKRGM4RKfpPAPBdG
         PRgQ16ta8ysLXSDQ59Ur0NuSPf0gBa8k/y+q2dP26yfExkDJn18lap3/yRCv3A+iBUVb
         VJ4wJX6mpkGq7CEdRC4lLQrFLn16xt7FdoYp+TcL1RsG00eRYtVrdjhVRNWt/DBTJqIa
         S6DA3s/C2RQ8wSK2D2fVyuvA/nsDF6AMVV4LPRFP2N1kSKw3+T434uP2o/vSUbGq0ea3
         tCFNUDtvqz3TjljZhQQBvotdUZrq2lQ12vS9zku6y4T2GMAsUQ2VJilPMHe77BYIUwWE
         PEGQ==
X-Gm-Message-State: AOAM5325m4svDDOWYpCC6ImSWpZVHONnXY9gWjId0r0R2O+SxOcWTEJ6
        XByNmWv8qE/B/qHL2umZHkW37ov3
X-Google-Smtp-Source: ABdhPJzYID6rrpR2Iq97hASmnXNfFa+Y7IuupJM+SudPFsacXNY/FSv66nvW7LFJhePsVzoPZwaP5A==
X-Received: by 2002:a17:906:3604:: with SMTP id q4mr15626645ejb.69.1590928022728;
        Sun, 31 May 2020 05:27:02 -0700 (PDT)
Received: from localhost.localdomain ([188.25.147.193])
        by smtp.gmail.com with ESMTPSA id b16sm12870024edu.89.2020.05.31.05.27.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 31 May 2020 05:27:01 -0700 (PDT)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, andrew@lunn.ch, vivien.didelot@gmail.com,
        f.fainelli@gmail.com, antoine.tenart@bootlin.com,
        alexandre.belloni@bootlin.com, UNGLinuxDriver@microchip.com,
        alexandru.marginean@nxp.com, claudiu.manoil@nxp.com,
        madalin.bucur@oss.nxp.com, radu-andrei.bulie@nxp.com,
        fido_max@inbox.ru, broonie@kernel.org
Subject: [PATCH v3 net-next 00/13] New DSA driver for VSC9953 Seville switch
Date:   Sun, 31 May 2020 15:26:27 +0300
Message-Id: <20200531122640.1375715-1-olteanv@gmail.com>
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
 drivers/net/dsa/ocelot/felix.c                |  272 ++--
 drivers/net/dsa/ocelot/felix.h                |   24 +-
 drivers/net/dsa/ocelot/felix_vsc9959.c        |  308 ++++-
 drivers/net/dsa/ocelot/seville_vsc9953.c      | 1106 +++++++++++++++++
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
 18 files changed, 1820 insertions(+), 417 deletions(-)
 create mode 100644 drivers/net/dsa/ocelot/seville_vsc9953.c

-- 
2.25.1


Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2D9D71E51E9
	for <lists+netdev@lfdr.de>; Thu, 28 May 2020 01:41:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725879AbgE0XlZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 May 2020 19:41:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45734 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725385AbgE0XlY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 May 2020 19:41:24 -0400
Received: from mail-ed1-x544.google.com (mail-ed1-x544.google.com [IPv6:2a00:1450:4864:20::544])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 65EBDC08C5C1
        for <netdev@vger.kernel.org>; Wed, 27 May 2020 16:41:24 -0700 (PDT)
Received: by mail-ed1-x544.google.com with SMTP id d24so21668935eds.11
        for <netdev@vger.kernel.org>; Wed, 27 May 2020 16:41:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=WG+IbJTAWVlyRr98MhMi0L/HJjJQCsOaKsayvqo1ZOo=;
        b=cG6KGS06QNsKrfVVvhHuJss/dmkW/hrBvBmHDCFl3nhzxACBiPS55xfPaLMtn60OvM
         NiKtNXGDWG1xJa2Ri+kOT5a1BegOwUrDiG9oTx2S3vDGXfBfEFjd2C3qDPX32UEaWdjW
         6Kdbo1RIM41kfIFZDnaAME7UawTG22pj2ueAx1X+X7Sbp7HCEUASDag1dssHox720wzh
         iBH2n9p2UxtjfJ6KlI1wDcAJTwK1sqItFHAWuS7prOSgh39exU7/H4QsRxdL349O1WWf
         7HCqxNlSNSx19tvymncVNyX4Tpj7GbXh056Kews70v3MpWItz7yewm60gL8KqmxWkodt
         U+pA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=WG+IbJTAWVlyRr98MhMi0L/HJjJQCsOaKsayvqo1ZOo=;
        b=dOmwFxQZ44T6nzEDWFSFAJESvgcbW1A0/P9TZfIETwdoMv7lOdtlkd+h/52zHl4hik
         NP9y4XA4h4AUWdaPHwqNwyeryyymFd4kEIxZRFXVEoYAbabHqUuDnjWDNR2pUBfkvmF+
         fTRCTLWZoEQA1BekNDKrAuuGcdFfV+cYEjmbIV55CzsTbRWhSaudL5acisX6039SAcmi
         EFB1mHojSTKeRKBlB9yNsITRYv57GU7iLoVKyoZZ1J3M+k/Uys/Em220M5sWrdrfHlWk
         1SJ+5V8x/wIiTZUO2gC4t/CkIyEfXiT5b6KtZswkyVxTiXejA7g/TVnaRamHWnI+6iAp
         EvfA==
X-Gm-Message-State: AOAM532SWjDleqVHBM8FS3K+eFGky5YMr18PI8gARKaJ7X6HIOa5Doot
        enlnpTzQAQDrn39JcxflRac=
X-Google-Smtp-Source: ABdhPJzQJJ6Rab8mBBUrThs7Qax/qyZMw7G6MsFmC3dPrCbjJNtXxcR6tBDSzPRrUMXwFBSHe2xgRA==
X-Received: by 2002:a50:f182:: with SMTP id x2mr506941edl.336.1590622883029;
        Wed, 27 May 2020 16:41:23 -0700 (PDT)
Received: from localhost.localdomain ([188.25.147.193])
        by smtp.gmail.com with ESMTPSA id a13sm3236555eds.6.2020.05.27.16.41.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 27 May 2020 16:41:22 -0700 (PDT)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, andrew@lunn.ch, vivien.didelot@gmail.com,
        f.fainelli@gmail.com, linux@armlinux.org.uk,
        antoine.tenart@bootlin.com, alexandre.belloni@bootlin.com,
        horatiu.vultur@microchip.com, allan.nielsen@microchip.com,
        UNGLinuxDriver@microchip.com, alexandru.marginean@nxp.com,
        claudiu.manoil@nxp.com, madalin.bucur@oss.nxp.com,
        radu-andrei.bulie@nxp.com, fido_max@inbox.ru
Subject: [PATCH net-next 00/11] New DSA driver for VSC9953 Seville switch
Date:   Thu, 28 May 2020 02:41:02 +0300
Message-Id: <20200527234113.2491988-1-olteanv@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Looking at the Felix and Ocelot drivers, Maxim asked if it would be
possible to use them as a base for a new driver for the switch inside
NXP T1040. Turns out, it is! The result is a driver eerily similar to
Felix.

The biggest challenge seems to be getting register read/write API
generic enough to cover such wild bitfield variations between hardware
generations. There is a patch on the regmap core which I would like to
get in through the networking subsystem, if possible (and if Mark is
ok), since it's a trivial addition.

Maxim Kochetkov (4):
  soc/mscc: ocelot: add MII registers description
  net: mscc: ocelot: convert SYS_PAUSE_CFG register access to regfield
  net: mscc: ocelot: extend watermark encoding function
  net: dsa: ocelot: introduce driver for Seville VSC9953 switch

Vladimir Oltean (7):
  regmap: add helper for per-port regfield initialization
  net: mscc: ocelot: unexport ocelot_probe_port
  net: mscc: ocelot: convert port registers to regmap
  net: mscc: ocelot: convert QSYS_SWITCH_PORT_MODE and SYS_PORT_MODE to
    regfields
  net: dsa: ocelot: create a template for the DSA tags on xmit
  net: mscc: ocelot: split writes to pause frame enable bit and to
    thresholds
  net: mscc: ocelot: disable flow control on NPI interface

 drivers/net/dsa/ocelot/Kconfig           |   12 +
 drivers/net/dsa/ocelot/Makefile          |    6 +
 drivers/net/dsa/ocelot/felix.c           |   49 +-
 drivers/net/dsa/ocelot/felix_vsc9959.c   |   72 +-
 drivers/net/dsa/ocelot/seville.c         |  742 +++++++++++++++
 drivers/net/dsa/ocelot/seville.h         |   50 +
 drivers/net/dsa/ocelot/seville_vsc9953.c | 1064 ++++++++++++++++++++++
 drivers/net/ethernet/mscc/ocelot.c       |   87 +-
 drivers/net/ethernet/mscc/ocelot.h       |    9 +-
 drivers/net/ethernet/mscc/ocelot_board.c |   21 +-
 drivers/net/ethernet/mscc/ocelot_io.c    |   18 +-
 drivers/net/ethernet/mscc/ocelot_regs.c  |   57 ++
 include/linux/regmap.h                   |    8 +
 include/soc/mscc/ocelot.h                |   68 +-
 include/soc/mscc/ocelot_dev.h            |   78 --
 include/soc/mscc/ocelot_qsys.h           |   13 -
 include/soc/mscc/ocelot_sys.h            |   23 -
 net/dsa/tag_ocelot.c                     |   21 +-
 18 files changed, 2196 insertions(+), 202 deletions(-)
 create mode 100644 drivers/net/dsa/ocelot/seville.c
 create mode 100644 drivers/net/dsa/ocelot/seville.h
 create mode 100644 drivers/net/dsa/ocelot/seville_vsc9953.c

-- 
2.25.1


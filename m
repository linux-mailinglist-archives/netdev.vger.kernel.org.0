Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B217E26FB05
	for <lists+netdev@lfdr.de>; Fri, 18 Sep 2020 12:58:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726309AbgIRK6F (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Sep 2020 06:58:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51444 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725955AbgIRK6E (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Sep 2020 06:58:04 -0400
Received: from mail-ed1-x543.google.com (mail-ed1-x543.google.com [IPv6:2a00:1450:4864:20::543])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 777F6C06174A
        for <netdev@vger.kernel.org>; Fri, 18 Sep 2020 03:58:04 -0700 (PDT)
Received: by mail-ed1-x543.google.com with SMTP id a12so5565729eds.13
        for <netdev@vger.kernel.org>; Fri, 18 Sep 2020 03:58:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=6Gsprr1SC+uKxn9hUj9/VHYG7eV6UxQoyxC9gF6yqsY=;
        b=ErZMw/8EuUFPmw6kAZR/FnCSexvjzS6/ZcRMxzWjHFQI7FmQHBGttEg+RdOonSjUwH
         bKzF3IKr1DlVpKzCygBUGxXA2rj6SnswqNM/g+2XM7QLYB/aVCzh2CkrByp2mmdqZoYh
         OXanFeusiFj7oaD9PHgybQPc/qlCNEJ7t3BbPPHm3c0eVHPfVR+cg3554XAkMNyd7GJW
         1nVdVS5wFnQSiV8g/sv2FGXXGHRDAiUeAJJTDFN55Kv0nrqAWwcWpHkouG3fgbJJPMww
         VYZEyGFWIogBlb+PbTRZHxBmHoss9NnAyffClrqxU93/J+ER8dHpDJ7zh/+/60TxZH5q
         Y0Eg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=6Gsprr1SC+uKxn9hUj9/VHYG7eV6UxQoyxC9gF6yqsY=;
        b=CbQiTWHO5TgqwvFwsEy362d9O7qh1NlA1OBeCXVTBanFK+U4auRhGPg85e+HC/tPpM
         tN6SCGP1vLw+qoqfUxQpcmqFERHq3xxBdiyEWTxdTZlpRsik6obUyka/itNoJGqYsuJ8
         OhzmI17e4qqyeSaP7z77S7HJVtqwqXtBd9CCSv1qwEpl/NGMBQn8K8lww0WuE1jj0YDi
         Q/u0qP2vu3hTCCaT1LhNX6VB9pzz3jxNZ6y63XtD4IfoJ+prtHQk7419yK+HTWA9jjWP
         PmDTipayiq23vRSYqeaRq5Ijxr2MBOIg6qjrCPrP37JrgOlPW43ix8grVnnMPBjhsms/
         hGFQ==
X-Gm-Message-State: AOAM5326edDr2TODLOu32ILO3hJsSQjMaFfU1MPB7gWxy8HCKrE6s40F
        UzqhgpJ3G5EcKiggsIKH6X1s96jZ5Y8=
X-Google-Smtp-Source: ABdhPJwEG8nlMbJVZs1g2QOP0DXJvhHBz+yCrSY81SswhTImGrt2VfCzAGmpzPdOi2x/qYX2ULPqow==
X-Received: by 2002:a05:6402:3050:: with SMTP id bu16mr38550059edb.343.1600426683032;
        Fri, 18 Sep 2020 03:58:03 -0700 (PDT)
Received: from localhost.localdomain ([188.25.217.212])
        by smtp.gmail.com with ESMTPSA id k1sm1995086eji.20.2020.09.18.03.58.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 18 Sep 2020 03:58:02 -0700 (PDT)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     davem@davemloft.net, netdev@vger.kernel.org
Cc:     yangbo.lu@nxp.com, xiaoliang.yang_1@nxp.com,
        UNGLinuxDriver@microchip.com, claudiu.manoil@nxp.com,
        alexandre.belloni@bootlin.com, andrew@lunn.ch,
        vivien.didelot@gmail.com, f.fainelli@gmail.com, kuba@kernel.org
Subject: [PATCH net-next 00/11] Felix DSA driver cleanup: build Seville separately
Date:   Fri, 18 Sep 2020 13:57:42 +0300
Message-Id: <20200918105753.3473725-1-olteanv@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>

When introducing the Seville switch support to the Felix driver, some
technical debt was created. Since both VSC9959 and VSC9953 are embedded
switches (one on an arm64 SoC and the other on a powerpc SoC), there is
no use case for having the code for both be present in the same module.

This was necessary at the time due to the common SERDES PCS code that
they were using, but that has been since refactored into
drivers/net/pcs/pcs-lynx.c.

This makes the Seville driver stop uselessly depending upon PCI and
FSL_ENETC_MDIO, which were only dependencies of Felix in fact.

Some whitespace/tab conversions are also present in this series as part
of the cleanup process.

Vladimir Oltean (11):
  net: dsa: felix: use ocelot_field_{read,write} helpers consistently
  net: dsa: seville: don't write to MEM_ENA twice
  net: dsa: seville: first enable memories, then initialize them
  net: dsa: ocelot: document why reset procedure is different for
    felix/seville
  net: dsa: seville: remove unused defines for the mdio controller
  net: dsa: seville: reindent defines for MDIO controller
  net: dsa: felix: replace tabs with spaces
  net: dsa: seville: duplicate vsc9959_mdio_bus_free
  net: mscc: ocelot: make ocelot_init_timestamp take a const struct
    ptp_clock_info
  net: dsa: felix: move the PTP clock structure to felix_vsc9959.c
  net: dsa: seville: build as separate module

 drivers/net/dsa/ocelot/Kconfig           | 22 +++++----
 drivers/net/dsa/ocelot/Makefile          |  6 ++-
 drivers/net/dsa/ocelot/felix.c           | 47 +------------------
 drivers/net/dsa/ocelot/felix.h           |  7 +--
 drivers/net/dsa/ocelot/felix_vsc9959.c   | 57 +++++++++++++++++-------
 drivers/net/dsa/ocelot/seville_vsc9953.c | 55 ++++++++++++++---------
 drivers/net/ethernet/mscc/ocelot_ptp.c   |  3 +-
 include/soc/mscc/ocelot_ptp.h            |  3 +-
 8 files changed, 102 insertions(+), 98 deletions(-)

-- 
2.25.1


Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2BD2E130E1E
	for <lists+netdev@lfdr.de>; Mon,  6 Jan 2020 08:47:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726373AbgAFHqx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Jan 2020 02:46:53 -0500
Received: from mail-lj1-f195.google.com ([209.85.208.195]:37481 "EHLO
        mail-lj1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725821AbgAFHqw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Jan 2020 02:46:52 -0500
Received: by mail-lj1-f195.google.com with SMTP id o13so38550415ljg.4
        for <netdev@vger.kernel.org>; Sun, 05 Jan 2020 23:46:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=bRbQtHZCcijc2OrwpjqtsTdlAcFX37E9ijlxNalaYQw=;
        b=QzLt/89MxlDhd+Hr1gNdEJW7QrrwmNi7RE5/nghoDQektbEMIs8sbHaX1B+NDnCRdF
         GVaZHSgRmwLc2RpJskPF3ZYj8otAJLPQ5gprTig49Lo4wR74jk08R/kQk9S0LgqGpnX6
         c4ERE+bJwoqLAJJfBnJHCUnDMSEOJC/9MbDdJblrz8Hr2c5wQAsK5SdGDGLAhzX6BXHD
         oobtXb6ZITa5NNX5XijBoBxn0ZLiibx6g3dyj7gQ7EH9GVkxW/7bCguzKWhtfRMr4D/A
         DsC691PPRZmy55WZ6//P4/ygmNMPzwq8+K2VqsSdV4MSFzJEBivkNpMGa8Y2bCrUWYVn
         p5nQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=bRbQtHZCcijc2OrwpjqtsTdlAcFX37E9ijlxNalaYQw=;
        b=cFZVu/NgLm2DFlU4MqjpB4ALc0hKt+DV+vJXrXoHnG8hBprMX4UEFOqKwtaF70EJaB
         ODec8XHckD5LUCwUI+cFLfuNZ0xXumfMdHtR3vfT/whvvcfXF1wG928uEBEe0uEhNkzR
         YXDxvF21ryHogKvdBtpCFHHIFgGnyFSaEDy2OU9WcJHTMj24ZBoOV3EIG1L1OdVqV/Qv
         9NjWSr5om0nK3Hh5peh07JaxwYz8r3uXxaLvbndu1G7oohf8qdehX0AaqpIiN9uWG3wD
         3RNQG2KKJAY1a7qCQmdbTeVP+Y5L/+Z0gaZlZGNVfIvhPeiUKigs+u1TCQrA9ZjeVc9a
         4JEQ==
X-Gm-Message-State: APjAAAUiQAXEX8c/ntvOigSBSR5e1AchIanhsrC5nKzXUEhXfqPd4Nsg
        o8ftputMimRrrU1ql46sSSsA4bAVfQYm0A==
X-Google-Smtp-Source: APXvYqyTXcGXsZbId5XO6uP+1ac0pEURj7a28l65KHzy5h157qx1ETHXp1WLMO37+50KJlCtv9eVKQ==
X-Received: by 2002:a05:651c:204f:: with SMTP id t15mr61124110ljo.240.1578296810713;
        Sun, 05 Jan 2020 23:46:50 -0800 (PST)
Received: from localhost.bredbandsbolaget (c-5ac9225c.014-348-6c756e10.bbcust.telenor.se. [92.34.201.90])
        by smtp.gmail.com with ESMTPSA id n14sm28625551lfe.5.2020.01.05.23.46.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 05 Jan 2020 23:46:50 -0800 (PST)
From:   Linus Walleij <linus.walleij@linaro.org>
To:     netdev@vger.kernel.org, "David S . Miller" <davem@davemloft.net>
Cc:     Arnd Bergmann <arnd@arndb.de>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Linus Walleij <linus.walleij@linaro.org>
Subject: [PATCH net-next 0/9 v3] IXP4xx networking cleanups
Date:   Mon,  6 Jan 2020 08:46:38 +0100
Message-Id: <20200106074647.23771-1-linus.walleij@linaro.org>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This is a patch series which jams together Arnds and mine
cleanups for the IXP4xx networking.

I also have patches for device tree support but that
requires more elaborate work, this series is some of
mine and some of Arnds patches that is a good foundation
for his multiplatform work and my device tree work.

These are for application to the networking tree so
that can be taken in one separate sweep.

I have tested the patches for a bit using zeroday builds
and some boots on misc IXP4xx devices and haven't run
into any major problems. We might find some new stuff
as a result from the new compiler coverage.

I had to depromote enabling compiler coverage at one
point in this v2 set because it depended on other patches
making the code more generic.

The change from v3 is simply dropping one offending
patch hardcoding base addresses into the driver.

Arnd Bergmann (4):
  wan: ixp4xx_hss: fix compile-testing on 64-bit
  wan: ixp4xx_hss: prepare compile testing
  ptp: ixp46x: move adjacent to ethernet driver
  ixp4xx_eth: move platform_data definition

Linus Walleij (5):
  net: ethernet: ixp4xx: Standard module init
  net: ethernet: ixp4xx: Use distinct local variable
  net: ehernet: ixp4xx: Use netdev_* messages
  ARM/net: ixp4xx: Pass ethernet physical base as resource
  net: ethernet: ixp4xx: Use parent dev for DMA pool

 arch/arm/mach-ixp4xx/fsg-setup.c              |  20 ++
 arch/arm/mach-ixp4xx/goramo_mlr.c             |  24 ++
 arch/arm/mach-ixp4xx/include/mach/platform.h  |  22 +-
 arch/arm/mach-ixp4xx/ixdp425-setup.c          |  20 ++
 arch/arm/mach-ixp4xx/nas100d-setup.c          |  10 +
 arch/arm/mach-ixp4xx/nslu2-setup.c            |  10 +
 arch/arm/mach-ixp4xx/omixp-setup.c            |  20 ++
 arch/arm/mach-ixp4xx/vulcan-setup.c           |  20 ++
 drivers/net/ethernet/xscale/Kconfig           |  14 ++
 drivers/net/ethernet/xscale/Makefile          |   3 +-
 .../net/ethernet/xscale}/ixp46x_ts.h          |   0
 drivers/net/ethernet/xscale/ixp4xx_eth.c      | 213 +++++++++---------
 .../{ptp => net/ethernet/xscale}/ptp_ixp46x.c |   3 +-
 drivers/net/wan/Kconfig                       |   3 +-
 drivers/net/wan/ixp4xx_hss.c                  |  39 ++--
 drivers/ptp/Kconfig                           |  14 --
 drivers/ptp/Makefile                          |   1 -
 include/linux/platform_data/eth_ixp4xx.h      |  19 ++
 include/linux/platform_data/wan_ixp4xx_hss.h  |  17 ++
 19 files changed, 306 insertions(+), 166 deletions(-)
 rename {arch/arm/mach-ixp4xx/include/mach => drivers/net/ethernet/xscale}/ixp46x_ts.h (100%)
 rename drivers/{ptp => net/ethernet/xscale}/ptp_ixp46x.c (99%)
 create mode 100644 include/linux/platform_data/eth_ixp4xx.h
 create mode 100644 include/linux/platform_data/wan_ixp4xx_hss.h

-- 
2.21.0


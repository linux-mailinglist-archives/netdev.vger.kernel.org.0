Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B8ED3235208
	for <lists+netdev@lfdr.de>; Sat,  1 Aug 2020 14:24:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728971AbgHAMY1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 1 Aug 2020 08:24:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54172 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728505AbgHAMYZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 1 Aug 2020 08:24:25 -0400
Received: from mail-ej1-x644.google.com (mail-ej1-x644.google.com [IPv6:2a00:1450:4864:20::644])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4726BC06174A;
        Sat,  1 Aug 2020 05:24:25 -0700 (PDT)
Received: by mail-ej1-x644.google.com with SMTP id qc22so19227892ejb.4;
        Sat, 01 Aug 2020 05:24:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=T7aPF82SA5wWWFZavl8BJzxoy0LUNqXZ1nMb9d5sWLA=;
        b=j66cZ0STMIZTim+8iu9l4yKXtG8ZTanGI8z+X1wR0aquCIkjlSQ3uq144NXbHFRqYq
         pryOrLm0Tk4WjXIpQPSZ9hc5epP0b8/seyPyQa+oa84ubNQfoqeMdFAeOwHM5c7f8gs6
         iw1UY5HeZyBDIl6k0tfTCuIswWS1yzXqU96nzIlAzw9U72XKPoXpyeW/y8zsFeP4eni7
         u92WbfkYX/y3wS58Nh5M614LPj1IL5Sgqlo04ji1dBuFIvc+ym23L2TB1sTW89cBJDl5
         Jm1eicn/zIgYkq2QWzqabG/A92wScoWb3O1Q68yCp6is3jqAAXrCric1VJ3YyUqhFsVs
         VMzw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=T7aPF82SA5wWWFZavl8BJzxoy0LUNqXZ1nMb9d5sWLA=;
        b=dQrSRBSe++bzQlTg5FYL72L/wPWgzSJVMOY7MZ2TMCmM9dc4twLGikNjuhEiT7hCoc
         GD0iXcvIu3WqChD5R4YkHPapuSQBpyaPRT7oJuBMplb+9XPaVsTTqWGA3/drvOFWlXT9
         x34s/luakjXoBR+USjeRWuGucORT4U3NpUL/lgOdETqpgWAoVSlpqhIuKQnBTj7KupMV
         d4P2Y4bJUEW2GSB1GyI9mzdDLq+CjlfPLVsttpQpP7t4pl5yxU+JHNtaRqpimRWLTFLg
         ndQA8jM4dsc5nrY2iElAhjvky4pFToSCwdSoUDvFjref7DL2YM35Fw4P1P4ML4xZHtRL
         L4+Q==
X-Gm-Message-State: AOAM533j1VchNgcqTNA/OP5KRaSsN/WieVpieZryg13pXJrU3XXErVau
        w1ZZmi02mJKGOmZcCjljBwE=
X-Google-Smtp-Source: ABdhPJzoUNKtZROrtg5oRTHrqWYi9kdFEI+ce31VxUN0Y2Yt/rL0DBWkJLpuSAyDhwqGzfm7zy5ymA==
X-Received: by 2002:a17:906:b146:: with SMTP id bt6mr8432804ejb.138.1596284663809;
        Sat, 01 Aug 2020 05:24:23 -0700 (PDT)
Received: from net.saheed (95C84E0A.dsl.pool.telekom.hu. [149.200.78.10])
        by smtp.gmail.com with ESMTPSA id a101sm12083131edf.76.2020.08.01.05.24.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 01 Aug 2020 05:24:22 -0700 (PDT)
From:   "Saheed O. Bolarinwa" <refactormyself@gmail.com>
To:     helgaas@kernel.org, Kalle Valo <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Wolfgang Grandegger <wg@grandegger.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        Miquel Raynal <miquel.raynal@bootlin.com>,
        Richard Weinberger <richard@nod.at>,
        Vignesh Raghavendra <vigneshr@ti.com>,
        Joerg Roedel <joro@8bytes.org>
Cc:     "Saheed O. Bolarinwa" <refactormyself@gmail.com>,
        bjorn@helgaas.com, skhan@linuxfoundation.org,
        linux-kernel-mentees@lists.linuxfoundation.org,
        linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-mtd@lists.infradead.org, iommu@lists.linux-foundation.org,
        linux-rdma@vger.kernel.org, linux-ide@vger.kernel.org,
        linux-i2c@vger.kernel.org, linux-hwmon@vger.kernel.org,
        dri-devel@lists.freedesktop.org, intel-gfx@lists.freedesktop.org,
        linux-gpio@vger.kernel.org, linux-fpga@vger.kernel.org,
        linux-edac@vger.kernel.org, dmaengine@vger.kernel.org,
        linux-crypto@vger.kernel.org,
        linux-atm-general@lists.sourceforge.net
Subject: [RFC PATCH 00/17] Drop uses of pci_read_config_*() return value
Date:   Sat,  1 Aug 2020 13:24:29 +0200
Message-Id: <20200801112446.149549-1-refactormyself@gmail.com>
X-Mailer: git-send-email 2.18.4
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The return value of pci_read_config_*() may not indicate a device error.
However, the value read by these functions is more likely to indicate
this kind of error. This presents two overlapping ways of reporting
errors and complicates error checking.

It is possible to move to one single way of checking for error if the 
dependencies on the return value of these functions are removed, then it
can later be made to return void.

Remove all uses of the return value of pci_read_config_*().
Check the actual value read for ~0. In this case, ~0 is an invalid value
thus it indicates some kind of error.

In some cases it madkes sence to make the calling function return void
without causing any bug. Future callers can use the value obtained from
these functions for validation. This case pertain to cs5536_read() and 
edac_pci_read_dword()

MERGE:
There is no dependency.
Merge individually

Saheed O. Bolarinwa (17):
  ata: Drop uses of pci_read_config_*() return value
  atm: Drop uses of pci_read_config_*() return value
  bcma: Drop uses of pci_read_config_*() return value
  hwrng: Drop uses of pci_read_config_*() return value
  dmaengine: ioat: Drop uses of pci_read_config_*() return value
  edac: Drop uses of pci_read_config_*() return value
  fpga: altera-cvp: Drop uses of pci_read_config_*() return value
  gpio: Drop uses of pci_read_config_*() return value
  drm/i915/vga: Drop uses of pci_read_config_*() return value
  hwmon: Drop uses of pci_read_config_*() return value
  intel_th: pci: Drop uses of pci_read_config_*() return value
  i2c: Drop uses of pci_read_config_*() return value
  ide: Drop uses of pci_read_config_*() return value
  IB: Drop uses of pci_read_config_*() return value
  iommu/vt-d: Drop uses of pci_read_config_*() return value
  mtd: Drop uses of pci_read_config_*() return value
  net: Drop uses of pci_read_config_*() return value

 drivers/ata/pata_cs5536.c                     |  6 +--
 drivers/ata/pata_rz1000.c                     |  3 +-
 drivers/atm/eni.c                             |  3 +-
 drivers/atm/he.c                              | 12 +++--
 drivers/atm/idt77252.c                        |  9 ++--
 drivers/atm/iphase.c                          | 46 ++++++++++---------
 drivers/atm/lanai.c                           |  4 +-
 drivers/atm/nicstar.c                         |  3 +-
 drivers/atm/zatm.c                            |  9 ++--
 drivers/bcma/host_pci.c                       |  6 ++-
 drivers/char/hw_random/amd-rng.c              |  6 +--
 drivers/dma/ioat/dma.c                        |  6 +--
 drivers/edac/amd64_edac.c                     |  8 ++--
 drivers/edac/amd8111_edac.c                   | 16 ++-----
 drivers/edac/amd8131_edac.c                   |  6 +--
 drivers/edac/i82443bxgx_edac.c                |  3 +-
 drivers/edac/sb_edac.c                        | 12 +++--
 drivers/edac/skx_common.c                     | 18 +++++---
 drivers/fpga/altera-cvp.c                     |  8 ++--
 drivers/gpio/gpio-amd8111.c                   |  7 ++-
 drivers/gpio/gpio-rdc321x.c                   | 21 +++++----
 drivers/gpu/drm/i915/display/intel_vga.c      |  3 +-
 drivers/hwmon/i5k_amb.c                       | 12 +++--
 drivers/hwmon/vt8231.c                        |  8 ++--
 drivers/hwtracing/intel_th/pci.c              | 12 ++---
 drivers/i2c/busses/i2c-ali15x3.c              |  6 ++-
 drivers/i2c/busses/i2c-elektor.c              |  3 +-
 drivers/i2c/busses/i2c-nforce2.c              |  4 +-
 drivers/i2c/busses/i2c-sis5595.c              | 17 ++++---
 drivers/i2c/busses/i2c-sis630.c               |  7 +--
 drivers/i2c/busses/i2c-viapro.c               | 11 +++--
 drivers/ide/cs5536.c                          |  6 +--
 drivers/ide/rz1000.c                          |  3 +-
 drivers/ide/setup-pci.c                       | 26 +++++++----
 drivers/infiniband/hw/hfi1/pcie.c             | 38 +++++++--------
 drivers/infiniband/hw/mthca/mthca_reset.c     | 19 ++++----
 drivers/iommu/intel/iommu.c                   |  6 ++-
 drivers/mtd/maps/ichxrom.c                    |  4 +-
 drivers/net/can/peak_canfd/peak_pciefd_main.c |  6 ++-
 drivers/net/can/sja1000/peak_pci.c            |  6 ++-
 drivers/net/ethernet/agere/et131x.c           | 11 +++--
 .../ethernet/broadcom/bnx2x/bnx2x_ethtool.c   |  5 +-
 .../cavium/liquidio/cn23xx_pf_device.c        |  4 +-
 drivers/net/ethernet/marvell/sky2.c           |  5 +-
 drivers/net/ethernet/mellanox/mlx4/catas.c    |  7 +--
 drivers/net/ethernet/mellanox/mlx4/reset.c    | 10 ++--
 .../net/ethernet/myricom/myri10ge/myri10ge.c  |  4 +-
 drivers/net/wan/farsync.c                     |  5 +-
 .../broadcom/brcm80211/brcmfmac/pcie.c        |  4 +-
 .../net/wireless/intel/iwlwifi/pcie/trans.c   | 15 ++++--
 50 files changed, 270 insertions(+), 209 deletions(-)

-- 
2.18.4


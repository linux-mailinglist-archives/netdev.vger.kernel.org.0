Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 31CA811BCE8
	for <lists+netdev@lfdr.de>; Wed, 11 Dec 2019 20:28:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729178AbfLKT1u (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Dec 2019 14:27:50 -0500
Received: from mail-pg1-f201.google.com ([209.85.215.201]:41310 "EHLO
        mail-pg1-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728982AbfLKT1u (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 Dec 2019 14:27:50 -0500
Received: by mail-pg1-f201.google.com with SMTP id r30so13229048pgm.8
        for <netdev@vger.kernel.org>; Wed, 11 Dec 2019 11:27:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=KFmQdAdZh8/B/wh1g4c+i5ALsP3kFx6ncDBf/RCXchM=;
        b=BHEbvjoHWqZ7Nv64QnvdKu9CN/PsQfHYxZZQz1Q10KydrF+m2IHzcnK5CrZKkXxx4b
         2YMOz+hd3HzxKnkbWedNtKO00vtCc2M3iMLn8LoGBw3qqR4py04EUe+8nahF6KzgWO/b
         vx1yhOmUkc/tCU9SZaP784yXIevMeiNK8sTRWzHqze2L7IbBFAHJC4itwqTKgrxGtnjj
         YeOhn/aOPE4f5oqAfM8DBWqmaHF/yW9Y7gmPjj650DnJ/PPd/Wng33I4+uBaDrD616/p
         ZRtT+uj/OzuuvRgRQ2d0fDYsZ2aGXgohBEYAYMIdTYa6aIe9iYQrbTB4SE+EyIfKIqoL
         sEbA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=KFmQdAdZh8/B/wh1g4c+i5ALsP3kFx6ncDBf/RCXchM=;
        b=Qk6qo9VS+B3A8UsIIGgh0+6blM8p6gL0TjZa8FHGE7WmCG2TV7Azm/gB1KTZpKQx6E
         ljw7hcKDZI2Gk8w4fD5pOibLR1oyEX2P9BtZ9VODUBAs18afXxWk/DS9k8GGrAUhdAkk
         seKK3HZdF2eFY/dx/EByLe+WwQas2Oq7jho3Xf32MSZFUZoy+v4fnWggWCBV1IWNylOA
         1JCUMV84nvoY5c3XiHnVi6yNImagX4fxGlNMaEaavWcG7qWCUHMqMdYEqIu0HDxx4Q+t
         LQNXltkw0AQevZRGxNCHzXCajE3lQRfYLhTQMbf8OmR95I4aZO+LmPkw8JdgwJO8zxvY
         TT7g==
X-Gm-Message-State: APjAAAV4SisLUxY+el8WnIwHot8DQM11oZ4c8V6Xkkk0k/piPl/3i/JA
        sGjlJ4/HZsShDeTeWyVx8T8VIopsUxPkkSfOBIWRRA==
X-Google-Smtp-Source: APXvYqycyWWqOB+1R/dWpmqnOlhdQUifRBeUd7lNrtDIGomABUXQd06geDk/YSSdxQdhxW6XmQloW5ZXtQ6ql5pkVCc82w==
X-Received: by 2002:a63:f60:: with SMTP id 32mr5943939pgp.206.1576092468990;
 Wed, 11 Dec 2019 11:27:48 -0800 (PST)
Date:   Wed, 11 Dec 2019 11:27:35 -0800
Message-Id: <20191211192742.95699-1-brendanhiggins@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.24.0.525.g8f36a354ae-goog
Subject: [PATCH v1 0/7] uml: add unspecified HAS_IOMEM dependencies
From:   Brendan Higgins <brendanhiggins@google.com>
To:     jdike@addtoit.com, richard@nod.at, anton.ivanov@cambridgegreys.com,
        "David S. Miller" <davem@davemloft.net>,
        Alistar Popple <alistair@popple.id.au>,
        Andrew Jeffery <andrew@aj.id.au>,
        Antoine Tenart <antoine.tenart@bootlin.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Boris Brezillon <bbrezillon@kernel.org>,
        Corentin Labbe <clabbe@baylibre.com>,
        Eddie James <eajames@linux.ibm.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Jeremy Kerr <jk@ozlabs.org>, Joel Stanley <joel@jms.id.au>,
        Linus Walleij <linus.walleij@linaro.org>,
        Michal Simek <michal.simek@xilinx.com>,
        Miquel Raynal <miquel.raynal@bootlin.com>,
        Moses Christopher <moseschristopherb@gmail.com>,
        Piotr Sroka <piotrs@cadence.com>,
        Radhey Shyam Pandey <radhey.shyam.pandey@xilinx.com>,
        Vignesh Raghavendra <vigneshr@ti.com>
Cc:     linux-um@lists.infradead.org, linux-kernel@vger.kernel.org,
        davidgow@google.com, Brendan Higgins <brendanhiggins@google.com>,
        devel@driverdev.osuosl.org, linux-amlogic@lists.infradead.org,
        linux-arm-kernel@lists.infradead.org,
        linux-aspeed@lists.ozlabs.org, linux-crypto@vger.kernel.org,
        linux-fsi@lists.ozlabs.org, linux-gpio@vger.kernel.org,
        linux-mtd@lists.infradead.org, netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

# TL;DR

This patchset adds a missing HAS_IOMEM dependency to several drivers in
an attempt to get allyesconfig closer to working for ARCH=um.

# What am I trying to do?

This patchset is part of my attempt to get `make ARCH=um allyesconfig`
to produce a config that will build *and* boot to init, so that I can
use it as a mechanism to run tests[1].

This patchset is attempting to deal with

CONFIG_PINCTRL_EQUILIBRIUM=y
CONFIG_MTD_NAND_CADENCE=y
CONFIG_FSI_MASTER_ASPEED=y
CONFIG_CRYPTO_DEV_SAFEXCEL=y
CONFIG_XIL_AXIS_FIFO=y
CONFIG_CRYPTO_DEV_AMLOGIC_GXL=y
CONFIG_XILINX_AXI_EMAC=y

which are selected by `make ARCH=um allyesconfig`, but prevent it from
building.

# How far away are we from an allyesconfig UML kernel?

I have identified 33 Kconfigs that are selected by allyesconfig, but
will either not build on UML, or prevent it from booting. They are:

CONFIG_STATIC_LINK=y
CONFIG_UML_NET_PCAP=y
CONFIG_NET_PTP_CLASSIFY=y
CONFIG_IP_VS=y
CONFIG_BRIDGE_EBT_BROUTE=y
CONFIG_BRIDGE_EBT_T_FILTER=y
CONFIG_BRIDGE_EBT_T_NAT=y
CONFIG_MTD_NAND_CADENCE=y
CONFIG_MTD_NAND_NANDSIM=y
CONFIG_BLK_DEV_NULL_BLK=y
CONFIG_BLK_DEV_RAM=y
CONFIG_SCSI_DEBUG=y
CONFIG_NET_VENDOR_XILINX=y
CONFIG_NULL_TTY=y
CONFIG_PTP_1588_CLOCK=y
CONFIG_PINCTRL_EQUILIBRIUM=y
CONFIG_DMABUF_SELFTESTS=y
CONFIG_COMEDI=y
CONFIG_XIL_AXIS_FIFO=y
CONFIG_EXFAT_FS=y
CONFIG_STM_DUMMY=y
CONFIG_FSI_MASTER_ASPEED=y
CONFIG_JFS_FS=y
CONFIG_UBIFS_FS=y
CONFIG_CRAMFS=y
CONFIG_CRYPTO_DEV_SAFEXCEL=y
CONFIG_CRYPTO_DEV_AMLOGIC_GXL=y
CONFIG_KCOV=y
CONFIG_LKDTM=y
CONFIG_REED_SOLOMON_TEST=y
CONFIG_TEST_RHASHTABLE=y
CONFIG_TEST_MEMINIT=y
CONFIG_NETWORK_PHY_TIMESTAMPING=y

CONFIG_STATIC_LINK=y and CONFIG_UML_NET_PCAP=y already have fixes on
their way.

I also have a patchset that just got accepted to fix
CONFIG_EXFAT_FS=y[2].

So with this patchset and these other three fixes mentioned here, we
will be about a third of the way there. There is only one more broken
config that prevents UML from building, CONFIG_LKDTM=y. After this there
will still be 22 broken configs which will prevent the UML allyesconfig
kernel from reaching the end of init; nevertheless, this is a good
milestone where, once reached, we can stop some of this bleeding by
adding a build test.

# Why won't allyesconfig break again after this series of fixes?

As I mentioned above, I am using UML for testing the kernel, and I am
currently working on getting my tests to run on KernelCI. As part of our
testing procedure for KernelCI, we are planning on building a UML kernel
using allyesconfig and running our tests on it. Thus, we will find out
very quickly once someone breaks allyesconfig again once we get this all
working.

Brendan Higgins (7):
  pinctrl: equilibrium: add unspecified HAS_IOMEM dependency
  mtd: rawnand: add unspecified HAS_IOMEM dependency
  net: axienet: add unspecified HAS_IOMEM dependency
  crypto: inside-secure: add unspecified HAS_IOMEM dependency
  crypto: amlogic: add unspecified HAS_IOMEM dependency
  staging: axis-fifo: add unspecified HAS_IOMEM dependency
  fsi: aspeed: add unspecified HAS_IOMEM dependency

 drivers/crypto/Kconfig              | 2 +-
 drivers/crypto/amlogic/Kconfig      | 1 +
 drivers/fsi/Kconfig                 | 1 +
 drivers/mtd/nand/raw/Kconfig        | 2 +-
 drivers/net/ethernet/xilinx/Kconfig | 1 +
 drivers/pinctrl/Kconfig             | 1 +
 drivers/staging/axis-fifo/Kconfig   | 2 +-
 7 files changed, 7 insertions(+), 3 deletions(-)

[1] https://bugzilla.kernel.org/show_bug.cgi?id=205223
[2] https://patchwork.kernel.org/patch/11273771/

-- 
2.24.0.525.g8f36a354ae-goog


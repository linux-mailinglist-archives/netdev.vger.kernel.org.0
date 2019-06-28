Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6A65B5A763
	for <lists+netdev@lfdr.de>; Sat, 29 Jun 2019 01:07:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726822AbfF1XHj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Jun 2019 19:07:39 -0400
Received: from mail-vk1-f201.google.com ([209.85.221.201]:53593 "EHLO
        mail-vk1-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726631AbfF1XHj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 Jun 2019 19:07:39 -0400
Received: by mail-vk1-f201.google.com with SMTP id v126so2229741vkv.20
        for <netdev@vger.kernel.org>; Fri, 28 Jun 2019 16:07:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=Xr333bCiBKOvL/tMx6ZbkK71/PoeuC7ymrmWp7RhG7g=;
        b=isC++4UTyijfPP8msMYU83ynWDTuIikU3Bcj1MeT2GtgW0e0rGIlqNck36Ey3onp7o
         UpTNE2zNhRziiAz/XrxeJm1e/m+sKDsA2xx0j/iY0AEmg/8UFp0+5F00EWSXUN85NnGD
         3JmBtMQ13hLnhLltpl+Bs85iuIDv5o0lhQrdtYUZlPC5XDjmoGvum2/Sg/8HHLiHA9tl
         bIMvZCcJ0lsV2EwQIQ4Pok9omxm1GOSicMz9BGr9taHofyi8BwJuFrDVyIckUHrptNGI
         WnFUxyaABL4PeBh52smlFHLNDDMxcPgbmX01+1c8r3Y8HYuTeWgSxj95AurpOvFpEMen
         GomA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=Xr333bCiBKOvL/tMx6ZbkK71/PoeuC7ymrmWp7RhG7g=;
        b=Z43mpaUHZgrh6IqE9eHJw/4Itfo6J76ckruMOOq/MwqSBx0W9QIxG2Q/UyCvWzLXQk
         aleAz5J5lr2ldqRMMH720Zb5+RswR/hZF+apkf0eYRJIgFNIFpt3zdHbVDnpZ2kCEchz
         kl1/pZCv2xUbCAgTKnFNZihHuuOKo96iZfV59zexhI54TZoKCHSkBP848T7QWq3fGKuP
         vRL7scstzGwuAXjXPbNmsl2rAZudAvGZTnBFf/rKw4CIIm4ZGyp9lTk4DYbrUdGEjJFz
         GePRsS6e1blm99sF0aK25F3o47/JV8JgYEZGete7EBE6BVV/G977GzIL28m54110ZxTw
         dN0A==
X-Gm-Message-State: APjAAAXvXg+hxdrGpF4wuibaf2XPNOj822sIhCoWkKByP+o2E1JdXDJ+
        RQQCAgE2w4Lb6sdxkPjQtpbC65bbQuUXbTTRRUrtDwqe3QIiaX3osYLha6nX2o3Y3b3fFtRV1bh
        HB4pZG2Fu3bWdt/TC0Bye5GdALKWFv4RbWZUKUVkK5LfAPNX+ECcIQY+dlhQV/w==
X-Google-Smtp-Source: APXvYqxgAkwWnG6g2ZLv9eWSpaneGf8xS9JrQvZZgVlY+sS7DYK/Ovmhbjuwx3YpV95GK4zL0pLPUuAlU1Y=
X-Received: by 2002:a1f:2896:: with SMTP id o144mr4860817vko.73.1561763257974;
 Fri, 28 Jun 2019 16:07:37 -0700 (PDT)
Date:   Fri, 28 Jun 2019 16:07:29 -0700
Message-Id: <20190628230733.54169-1-csully@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.22.0.410.gd8fdbe21b5-goog
Subject: [PATCH net-next v3 0/4] Add gve driver
From:   Catherine Sullivan <csully@google.com>
To:     netdev@vger.kernel.org
Cc:     Catherine Sullivan <csully@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch series adds the gve driver which will support the
Compute Engine Virtual NIC that will be available in the future.

v2:
- Patch 1:
  - Remove gve_size_assert.h and use static_assert instead.
  - Loop forever instead of bugging if the device won't reset
  - Use module_pci_driver
- Patch 2:
  - Use be16_to_cpu in the RX Seq No define
  - Remove unneeded ndo_change_mtu
- Patch 3:
  - No Changes
- Patch 4:
  - Instead of checking netif_carrier_ok in ethtool stats, just make sure

v3:
- Patch 1:
  - Remove X86 dep
- Patch 2:
  - No changes
- Patch 3:
  - No changes
- Patch 4:
  - Remove unneeded memsets in ethtool stats

Catherine Sullivan (4):
  gve: Add basic driver framework for Compute Engine Virtual NIC
  gve: Add transmit and receive support
  gve: Add workqueue and reset support
  gve: Add ethtool support

 .../networking/device_drivers/google/gve.rst  |  123 ++
 .../networking/device_drivers/index.rst       |    1 +
 MAINTAINERS                                   |    9 +
 drivers/net/ethernet/Kconfig                  |    1 +
 drivers/net/ethernet/Makefile                 |    1 +
 drivers/net/ethernet/google/Kconfig           |   27 +
 drivers/net/ethernet/google/Makefile          |    5 +
 drivers/net/ethernet/google/gve/Makefile      |    4 +
 drivers/net/ethernet/google/gve/gve.h         |  456 ++++++
 drivers/net/ethernet/google/gve/gve_adminq.c  |  388 ++++++
 drivers/net/ethernet/google/gve/gve_adminq.h  |  215 +++
 drivers/net/ethernet/google/gve/gve_desc.h    |  113 ++
 drivers/net/ethernet/google/gve/gve_ethtool.c |  232 ++++
 drivers/net/ethernet/google/gve/gve_main.c    | 1217 +++++++++++++++++
 .../net/ethernet/google/gve/gve_register.h    |   27 +
 drivers/net/ethernet/google/gve/gve_rx.c      |  445 ++++++
 drivers/net/ethernet/google/gve/gve_tx.c      |  584 ++++++++
 17 files changed, 3848 insertions(+)
 create mode 100644 Documentation/networking/device_drivers/google/gve.rst
 create mode 100644 drivers/net/ethernet/google/Kconfig
 create mode 100644 drivers/net/ethernet/google/Makefile
 create mode 100644 drivers/net/ethernet/google/gve/Makefile
 create mode 100644 drivers/net/ethernet/google/gve/gve.h
 create mode 100644 drivers/net/ethernet/google/gve/gve_adminq.c
 create mode 100644 drivers/net/ethernet/google/gve/gve_adminq.h
 create mode 100644 drivers/net/ethernet/google/gve/gve_desc.h
 create mode 100644 drivers/net/ethernet/google/gve/gve_ethtool.c
 create mode 100644 drivers/net/ethernet/google/gve/gve_main.c
 create mode 100644 drivers/net/ethernet/google/gve/gve_register.h
 create mode 100644 drivers/net/ethernet/google/gve/gve_rx.c
 create mode 100644 drivers/net/ethernet/google/gve/gve_tx.c

-- 
2.22.0.410.gd8fdbe21b5-goog


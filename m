Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4041F5C5C9
	for <lists+netdev@lfdr.de>; Tue,  2 Jul 2019 00:58:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726638AbfGAW6P (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Jul 2019 18:58:15 -0400
Received: from mail-pl1-f202.google.com ([209.85.214.202]:54203 "EHLO
        mail-pl1-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726362AbfGAW6P (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 Jul 2019 18:58:15 -0400
Received: by mail-pl1-f202.google.com with SMTP id b24so7947381plz.20
        for <netdev@vger.kernel.org>; Mon, 01 Jul 2019 15:58:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=ZNS5+4kxY7vAqKXvfdhm+lheO2jZjgdhtPuol1XTNEo=;
        b=mBL+rmxF23lluziULuj0PGxAwKtpplRPj2o8LxwzLB6aVXaKb0HOkkyn5b6PhBxEFC
         o3zvez2J9S2PYzwTZT0198D7er7J3zLDGFSvI3+NiYYkJgovxoFacMOuxBeWtteQNySc
         qzDoAHYUdeh2jFRH1W3r8JpfDQ2zabwzXtv2A/QXywMkr54+Gw4s09U+JqUUUNS4krsS
         wIwm6JzdRJc/jwnfdm/QO2TLiA8tvocm9UHeDW1zN0CYtHnse1H7vTnwEkaWIN0q6Tok
         MjAMZYMuv4V3VuuAZuCsDnM/+MdLcH1yy9Ckp+G0PoXSXgPCOuSyNo9ziAoJNR+VO13y
         F7bQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=ZNS5+4kxY7vAqKXvfdhm+lheO2jZjgdhtPuol1XTNEo=;
        b=Q26QwkQ6KlqSow+Pi87mYw++awRvVgt/AV8Tqkxr5V0dwKijA9bsjDIx4U5cn8vxUU
         yOSdUFpM8Bc+392OvEf6Qjf3fY38lejBOLNk/ZMZyY35A0+THW8DmfSIPa2O1VY+Q475
         cSefpVIQbIfTOpugL7ztHKDxC1laMX07SGVYzKD5A+gVzfjnjVBhSDJxffEEwF+91brn
         JQnjM5ph8gdF6SI3/d56YjX95fJlDNW3lMuNPrCVMbTyVwQRa4c3D5T9S/N7nrrp2xbg
         yuMXb7Z97yYSogEkrnWBz6l9/M0CHVypKUsfy2BlaDqnpkvb3HHMJf4BvIPpOZgRTWVP
         TFPQ==
X-Gm-Message-State: APjAAAXbTkq6VOOGwH2kYD7WHCrm66pULcPMXAeItVOnZgVc1uNWj6xq
        55WYZwyg8Itn3iJbvEFCm87eL8OEBdBWDPoOlst/LNLtQNLHhX95t8Q5sNeRy71aQv2WEuNrFqR
        K9aDALEtDPHg85UICEwYK5mvG8I3y9XVVxmcsyIlpMxICGRjDQoaguaU2Vi+cUQ==
X-Google-Smtp-Source: APXvYqxiJpSF7RVGA9ggow5SNywhfVVIanzmWZCG1lwbGNyjAJ15lhC/WNw5uKO6YVM3fKDgKrbveVQmZXE=
X-Received: by 2002:a63:f857:: with SMTP id v23mr12968159pgj.228.1562021894115;
 Mon, 01 Jul 2019 15:58:14 -0700 (PDT)
Date:   Mon,  1 Jul 2019 15:57:51 -0700
Message-Id: <20190701225755.209250-1-csully@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.22.0.410.gd8fdbe21b5-goog
Subject: [PATCH net-next v4 0/4] Add gve driver
From:   Catherine Sullivan <csully@google.com>
To:     netdev@vger.kernel.org
Cc:     Catherine Sullivan <csully@google.com>,
        kbuild test robot <lkp@intel.com>,
        Julia Lawall <julia.lawall@lip6.fr>
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

v4:
- Patch 1:
  - Use io[read|write]32be instead of [read|write]l(cpu_to_be32())
  - Explicitly add padding to gve_adminq_set_driver_parameter
  - Use static where appropriate
- Patch 2:
  - Use u64_stats_sync
  - Explicity add padding to gve_adminq_create_rx_queue
  - Fix some enianness typing issues found by kbuild
  - Use static where appropriate
  - Remove unused variables
- Patch 3:
  - Use io[read|write]32be instead of [read|write]l(cpu_to_be32())
- Patch 4:
  - Use u64_stats_sync
  - Use static where appropriate
Warnings reported by:
Reported-by: kbuild test robot <lkp@intel.com>
Reported-by: Julia Lawall <julia.lawall@lip6.fr>

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
 drivers/net/ethernet/google/gve/gve.h         |  459 ++++++
 drivers/net/ethernet/google/gve/gve_adminq.c  |  387 ++++++
 drivers/net/ethernet/google/gve/gve_adminq.h  |  217 +++
 drivers/net/ethernet/google/gve/gve_desc.h    |  113 ++
 drivers/net/ethernet/google/gve/gve_ethtool.c |  243 ++++
 drivers/net/ethernet/google/gve/gve_main.c    | 1228 +++++++++++++++++
 .../net/ethernet/google/gve/gve_register.h    |   27 +
 drivers/net/ethernet/google/gve/gve_rx.c      |  446 ++++++
 drivers/net/ethernet/google/gve/gve_tx.c      |  584 ++++++++
 17 files changed, 3875 insertions(+)
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


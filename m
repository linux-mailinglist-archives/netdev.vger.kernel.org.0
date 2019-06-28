Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0EA9F5A668
	for <lists+netdev@lfdr.de>; Fri, 28 Jun 2019 23:39:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726565AbfF1Vjo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Jun 2019 17:39:44 -0400
Received: from mail-pg1-f178.google.com ([209.85.215.178]:41345 "EHLO
        mail-pg1-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725783AbfF1Vjn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 Jun 2019 17:39:43 -0400
Received: by mail-pg1-f178.google.com with SMTP id q4so1663901pgj.8
        for <netdev@vger.kernel.org>; Fri, 28 Jun 2019 14:39:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=pensando.io; s=google;
        h=from:to:subject:date:message-id;
        bh=2GqvDSEU/dKVAzLcbujDb1j5cvp6/Q4DWdJM0XWrWaU=;
        b=4L0x2YneJzgMZRE759yl1lPTVTNFTbmq+GGBl3C7ys2kIcJJ1o+QH8HWLti7RT1Zjo
         RoHwjYpykKBquSYuYtNODFbBeUu4HULd4Ffh0oXV0XPAxU2b7ZlHDKKd4AIh1hdIDfrK
         2ciQN3T4ujfWyJyKQIoWVb4px6moXzGuuSskGR2Aln5j1eW5KoUOVDVuI+Dj0gjKP7gF
         QSV1QA/s6ZeHnyb3TKrdCwKjevrrA/hLw6Qx7WX4LkvaNlplvHYA7maSwLR+xXWK59M0
         TzXhCeKLD5W8bUiusUgXWvTE6taHptCUakFl7/19wkBwjuUbxHpKFQM42VqFYJa3vNkC
         qCAw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id;
        bh=2GqvDSEU/dKVAzLcbujDb1j5cvp6/Q4DWdJM0XWrWaU=;
        b=dyrmtnbCxqmAXcvbV6WLO5mevlrNJ+OeSEvfHb5He4T5VlGCRsvngL6can7CPYQMr5
         s/rmpuXsZDxn1mwDj2LIz1mSMGBEfTgKDGhFSet5x4jqKsQvcJ7wt7KKG9ClcC1aZIkp
         GSQ3Z7SIbnjykBD09Oocs9exuHfkmbHSL1kZQK/DSwOXmg1FtmgV7pM7pgO3SA9wZ/s8
         UTWiAAPz39jX+9hbFiNjQIkcP4O3nAEjJDnuLmNRnfCjlTk+dsB0GYahBQFgB76fQaQO
         8Of8nJmtXOcd1hqmJUCGRK1gwoRy3tr0aVMlwDtLFfKeswfhl3XLv03u94LZtQForoTB
         kPRw==
X-Gm-Message-State: APjAAAUxsjsf7ZqSDBvhIsDHCVNU3bCdv8Xatf6BukUxn9zxBc8izYJA
        zMtf8tGZeiYwFUD08EjSg29bEQ==
X-Google-Smtp-Source: APXvYqxIw01LpOimwf/mGFqVDommzKqeZgj9fMss0CGlPcp/wdWFh6s95vpYoPZh6cQPzpn6mEEoMQ==
X-Received: by 2002:a63:7a5b:: with SMTP id j27mr11295633pgn.242.1561757982954;
        Fri, 28 Jun 2019 14:39:42 -0700 (PDT)
Received: from driver-dev1.pensando.io ([12.1.37.26])
        by smtp.gmail.com with ESMTPSA id 135sm3516920pfb.137.2019.06.28.14.39.41
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 28 Jun 2019 14:39:41 -0700 (PDT)
From:   Shannon Nelson <snelson@pensando.io>
To:     snelson@pensando.io, netdev@vger.kernel.org
Subject: [PATCH v2 net-next 00/19] Add ionic driver
Date:   Fri, 28 Jun 2019 14:39:15 -0700
Message-Id: <20190628213934.8810-1-snelson@pensando.io>
X-Mailer: git-send-email 2.17.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This is the second version of a patch series that adds the ionic driver,
supporting the Pensando ethernet device.

In this initial patchset we implement basic transmit and receive.  Later
patchsets will add more advanced features.

Our thanks to Andrew Lunn, Michal Kubecek, Jacub Kicinski, and the ever
present kbuild test robots for their comments and suggestions.

There was some commentary on patch size and count, and I'm trying to
be careful - this v2 adds a patch with 2 new files for devlink, but has
fewer total lines.  I'm pushing the boundaries on how many in a patchset,
but I tried to keep most of them bite-sized and self consistent.  I'm not
sure further slicing-and-dicing will make much difference, but I'll try
if it is still an issue.

New in v2:
 - removed debugfs error checking and cut down on debugfs use
 - remove redundant bounds checking on incoming values for mtu and ethtool
 - don't alloc rx_filter memory until the match type has been checked
 - free the ionic struct on remove
 - simplified link_up and netif_carrier_ok comparison
 - put stats into ethtool -S, out of debugfs
 - moved dev_cmd and dev_info dumping to ethtool -d, out of debugfs
 - added devlink support
 - used kernel's rss init routines rather than open code
 - set the Kbuild dependant on 64BIT
 - cut down on some unnecessary log messaging
 - cleaned up ionic_get_link_ksettings
 - cleaned up other little code bits here and there

Shannon Nelson (19):
  ionic: Add basic framework for IONIC Network device driver
  ionic: Add hardware init and device commands
  ionic: Add port management commands
  ionic: Add basic lif support
  ionic: Add interrupts and doorbells
  ionic: Add basic adminq support
  ionic: Add adminq action
  ionic: Add notifyq support
  ionic: Add the basic NDO callbacks for netdev support
  ionic: Add management of rx filters
  ionic: Add Rx filter and rx_mode ndo support
  ionic: Add async link status check and basic stats
  ionic: Add initial ethtool support
  ionic: Add Tx and Rx handling
  ionic: Add netdev-event handling
  ionic: Add driver stats
  ionic: Add RSS support
  ionic: Add coalesce and other features
  ionic: Add basic devlink interface

 .../networking/device_drivers/index.rst       |    1 +
 .../device_drivers/pensando/ionic.rst         |   64 +
 MAINTAINERS                                   |    8 +
 drivers/net/ethernet/Kconfig                  |    1 +
 drivers/net/ethernet/Makefile                 |    1 +
 drivers/net/ethernet/pensando/Kconfig         |   32 +
 drivers/net/ethernet/pensando/Makefile        |    6 +
 drivers/net/ethernet/pensando/ionic/Makefile  |    8 +
 drivers/net/ethernet/pensando/ionic/ionic.h   |   72 +
 .../net/ethernet/pensando/ionic/ionic_bus.h   |   16 +
 .../ethernet/pensando/ionic/ionic_bus_pci.c   |  291 ++
 .../ethernet/pensando/ionic/ionic_debugfs.c   |  279 ++
 .../ethernet/pensando/ionic/ionic_debugfs.h   |   38 +
 .../net/ethernet/pensando/ionic/ionic_dev.c   |  535 ++++
 .../net/ethernet/pensando/ionic/ionic_dev.h   |  284 ++
 .../ethernet/pensando/ionic/ionic_devlink.c   |   89 +
 .../ethernet/pensando/ionic/ionic_devlink.h   |   12 +
 .../ethernet/pensando/ionic/ionic_ethtool.c   |  796 +++++
 .../ethernet/pensando/ionic/ionic_ethtool.h   |    9 +
 .../net/ethernet/pensando/ionic/ionic_if.h    | 2552 +++++++++++++++++
 .../net/ethernet/pensando/ionic/ionic_lif.c   | 2268 +++++++++++++++
 .../net/ethernet/pensando/ionic/ionic_lif.h   |  270 ++
 .../net/ethernet/pensando/ionic/ionic_main.c  |  553 ++++
 .../net/ethernet/pensando/ionic/ionic_regs.h  |  133 +
 .../ethernet/pensando/ionic/ionic_rx_filter.c |  142 +
 .../ethernet/pensando/ionic/ionic_rx_filter.h |   34 +
 .../net/ethernet/pensando/ionic/ionic_stats.c |  333 +++
 .../net/ethernet/pensando/ionic/ionic_stats.h |   53 +
 .../net/ethernet/pensando/ionic/ionic_txrx.c  |  880 ++++++
 .../net/ethernet/pensando/ionic/ionic_txrx.h  |   15 +
 30 files changed, 9775 insertions(+)
 create mode 100644 Documentation/networking/device_drivers/pensando/ionic.rst
 create mode 100644 drivers/net/ethernet/pensando/Kconfig
 create mode 100644 drivers/net/ethernet/pensando/Makefile
 create mode 100644 drivers/net/ethernet/pensando/ionic/Makefile
 create mode 100644 drivers/net/ethernet/pensando/ionic/ionic.h
 create mode 100644 drivers/net/ethernet/pensando/ionic/ionic_bus.h
 create mode 100644 drivers/net/ethernet/pensando/ionic/ionic_bus_pci.c
 create mode 100644 drivers/net/ethernet/pensando/ionic/ionic_debugfs.c
 create mode 100644 drivers/net/ethernet/pensando/ionic/ionic_debugfs.h
 create mode 100644 drivers/net/ethernet/pensando/ionic/ionic_dev.c
 create mode 100644 drivers/net/ethernet/pensando/ionic/ionic_dev.h
 create mode 100644 drivers/net/ethernet/pensando/ionic/ionic_devlink.c
 create mode 100644 drivers/net/ethernet/pensando/ionic/ionic_devlink.h
 create mode 100644 drivers/net/ethernet/pensando/ionic/ionic_ethtool.c
 create mode 100644 drivers/net/ethernet/pensando/ionic/ionic_ethtool.h
 create mode 100644 drivers/net/ethernet/pensando/ionic/ionic_if.h
 create mode 100644 drivers/net/ethernet/pensando/ionic/ionic_lif.c
 create mode 100644 drivers/net/ethernet/pensando/ionic/ionic_lif.h
 create mode 100644 drivers/net/ethernet/pensando/ionic/ionic_main.c
 create mode 100644 drivers/net/ethernet/pensando/ionic/ionic_regs.h
 create mode 100644 drivers/net/ethernet/pensando/ionic/ionic_rx_filter.c
 create mode 100644 drivers/net/ethernet/pensando/ionic/ionic_rx_filter.h
 create mode 100644 drivers/net/ethernet/pensando/ionic/ionic_stats.c
 create mode 100644 drivers/net/ethernet/pensando/ionic/ionic_stats.h
 create mode 100644 drivers/net/ethernet/pensando/ionic/ionic_txrx.c
 create mode 100644 drivers/net/ethernet/pensando/ionic/ionic_txrx.h

-- 
2.17.1


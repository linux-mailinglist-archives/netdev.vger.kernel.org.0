Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3A02A5A2DB
	for <lists+netdev@lfdr.de>; Fri, 28 Jun 2019 19:56:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726549AbfF1R4r (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Jun 2019 13:56:47 -0400
Received: from mail-pg1-f202.google.com ([209.85.215.202]:42685 "EHLO
        mail-pg1-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726408AbfF1R4r (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 Jun 2019 13:56:47 -0400
Received: by mail-pg1-f202.google.com with SMTP id d3so3547126pgc.9
        for <netdev@vger.kernel.org>; Fri, 28 Jun 2019 10:56:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=qG+Ud30lkFk67iWuKB1b9KhjwGVEAJBvKA6x7jWFKsg=;
        b=cmRVI4e85nB2xmQopdu8r2j65C0rTMAU/Z5y1a4wL++pU/Kf2ZKb6ulxHxV2JKDasd
         EXDxstkyF1NzzSPHpHOhs4RXjqu8fSdeV5L/5lbYDuYRyR6CDDQVxdikON4oM7G1SgWD
         9dn9810tLO2yWmdWreXeHTrml/dj6kcvPlol8XsQi3sAVCqDalBrRDzOjshoGUcZDxwk
         +vmgVeKbgZ/npP1qKddY8gLwFDsqYP6xJsgEWbt7ANfPLsZq6NfuzfXdGBUsUwwNV1Ux
         uqgFynyn4FJQtV3bLVhLjVTctYC83rr8OxQ3k31ww8eyUNEt0S6noaxJr8hO4WyOn31I
         0rEQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=qG+Ud30lkFk67iWuKB1b9KhjwGVEAJBvKA6x7jWFKsg=;
        b=FLvacjo6+10+Hnsqlz1bk0FhE+4GdDmoQ9voUky9Ov1991AxGgj7l3Lanx0BTyfrcM
         SuHtxHbVhmfOL4jTbW5ZnKz7FQxYRXS13l9wiZFszcRg3xfOXvzDfFoK4ouTHPr3MCCe
         52baKv/IJOZjxkN6D/aIL7KCfSja+2wU+htk2dPQKiRqkXxQSQ7MqmHD2FifdB2UJ1QH
         vIRBVnbNQKsvCmtHE9cSuvxtaIs6fNPdlTym7Je2ZDtAcwzJWX6YrITG6eyzPtvw+snj
         Sb1wMEF79PgwOAHAgycGU4sTWJbSM9NA5dAUOEm6DMLhEklGgKsW4trolWgeisugdTg6
         YT9w==
X-Gm-Message-State: APjAAAVuhByYfuUWgrw6mjLjCvJO62kjesPaEqO5ZKJdrzLRlHaD4AwZ
        acCt66cO1hesRCJ8eg4d+lgLP63+LICjrAxENDaGn+e55cN0kWNu0rZAK+HXlQ1y42QFFZNp/f+
        W7rKnoKX43aMCp6aTQSi7SWXJGtmHARoiHi+q1+sAE8cPeMuQYId8M68J6lCpCQ==
X-Google-Smtp-Source: APXvYqyrlOu58FS5s19aaomSnRvzWpO/13eOIY2RxpD8km53cUCdEaAEo1LWLFJIrb2P5c3fkisBM/I9FKA=
X-Received: by 2002:a63:2ad5:: with SMTP id q204mr10596244pgq.140.1561744606594;
 Fri, 28 Jun 2019 10:56:46 -0700 (PDT)
Date:   Fri, 28 Jun 2019 10:56:29 -0700
Message-Id: <20190628175633.143501-1-csully@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.22.0.410.gd8fdbe21b5-goog
Subject: [PATCH net-next v2 0/4] Add gve driver
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
    the rings have valid pointers.

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
 drivers/net/ethernet/google/gve/gve_ethtool.c |  239 ++++
 drivers/net/ethernet/google/gve/gve_main.c    | 1217 +++++++++++++++++
 .../net/ethernet/google/gve/gve_register.h    |   27 +
 drivers/net/ethernet/google/gve/gve_rx.c      |  445 ++++++
 drivers/net/ethernet/google/gve/gve_tx.c      |  584 ++++++++
 17 files changed, 3855 insertions(+)
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


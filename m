Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 659C6361C65
	for <lists+netdev@lfdr.de>; Fri, 16 Apr 2021 11:01:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240787AbhDPIwg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 16 Apr 2021 04:52:36 -0400
Received: from mx2.suse.de ([195.135.220.15]:53912 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236538AbhDPIwe (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 16 Apr 2021 04:52:34 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id A5205AEC6;
        Fri, 16 Apr 2021 08:52:08 +0000 (UTC)
From:   Thomas Bogendoerfer <tsbogend@alpha.franken.de>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-mips@vger.kernel.org
Subject: [PATCH v5 net-next 00/10] net: Korina improvements
Date:   Fri, 16 Apr 2021 10:51:56 +0200
Message-Id: <20210416085207.63181-1-tsbogend@alpha.franken.de>
X-Mailer: git-send-email 2.29.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

While converting Mikrotik RB532 support to use device tree I stumbled
over the korina ethernet driver, which used way too many MIPS specific
hacks. This series cleans this all up and adds support for device tree.

Changes in v5:
  - fixed email address in binding document, which prevented sending it

Changes in v4:
  - improve error returns in mdio_read further
  - added clock name and improved clk handling
  - fixed bindind errors

Changes in v3:
  - use readl_poll_timeout_atomic in mdio_wait
  - return -ETIMEDOUT, if mdio_wait failed
  - added DT binding and changed name to idt,3243x-emac
  - fixed usage of of_get_mac_address for net-next

Changes in v2:
  - added device tree support to get rid of idt_cpu_freq
  - fixed compile test on 64bit archs
  - fixed descriptor current address handling by storing/using mapped
    dma addresses (dma controller modifies current address)

Thomas Bogendoerfer (10):
  net: korina: Fix MDIO functions
  net: korina: Use devres functions
  net: korina: Remove not needed cache flushes
  net: korina: Remove nested helpers
  net: korina: Use DMA API
  net: korina: Only pass mac address via platform data
  net: korina: Add support for device tree
  net: korina: Get mdio input clock via common clock framework
  net: korina: Make driver COMPILE_TESTable
  dt-bindings: net: korina: Add DT bindings for IDT 79RC3243x SoCs

 .../bindings/net/idt,3243x-emac.yaml          |  74 +++
 arch/mips/rb532/devices.c                     |   5 +-
 drivers/net/ethernet/Kconfig                  |   3 +-
 drivers/net/ethernet/korina.c                 | 601 +++++++++++++-----
 4 files changed, 511 insertions(+), 172 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/net/idt,3243x-emac.yaml

-- 
2.29.2


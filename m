Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0483255C8E
	for <lists+netdev@lfdr.de>; Wed, 26 Jun 2019 01:45:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726293AbfFYXpx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Jun 2019 19:45:53 -0400
Received: from mail-out.m-online.net ([212.18.0.10]:50185 "EHLO
        mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725782AbfFYXpw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Jun 2019 19:45:52 -0400
Received: from frontend01.mail.m-online.net (unknown [192.168.8.182])
        by mail-out.m-online.net (Postfix) with ESMTP id 45YN8G44Rtz1rlwr;
        Wed, 26 Jun 2019 01:45:50 +0200 (CEST)
Received: from localhost (dynscan1.mnet-online.de [192.168.6.70])
        by mail.m-online.net (Postfix) with ESMTP id 45YN8G3X4pz20V2L;
        Wed, 26 Jun 2019 01:45:50 +0200 (CEST)
X-Virus-Scanned: amavisd-new at mnet-online.de
Received: from mail.mnet-online.de ([192.168.8.182])
        by localhost (dynscan1.mail.m-online.net [192.168.6.70]) (amavisd-new, port 10024)
        with ESMTP id q53IhahK3fDO; Wed, 26 Jun 2019 01:45:49 +0200 (CEST)
X-Auth-Info: CKcRJmFCq9WAJD/TgHNr/dh3M8q1xZ47s1stmzjf66g=
Received: from kurokawa.lan (ip-86-49-110-70.net.upcbroadband.cz [86.49.110.70])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.mnet-online.de (Postfix) with ESMTPSA;
        Wed, 26 Jun 2019 01:45:49 +0200 (CEST)
From:   Marek Vasut <marex@denx.de>
To:     netdev@vger.kernel.org
Cc:     Marek Vasut <marex@denx.de>, Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Tristram Ha <Tristram.Ha@microchip.com>,
        Woojung Huh <Woojung.Huh@microchip.com>
Subject: [PATCH V4 00/10] net: dsa: microchip: Convert to regmap
Date:   Wed, 26 Jun 2019 01:43:38 +0200
Message-Id: <20190625234348.16246-1-marex@denx.de>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patchset converts KSZ9477 switch driver to regmap.

This was tested with extra patches on KSZ8795. This was also tested
on KSZ9477 on Microchip KSZ9477EVB board, which I now have.

Signed-off-by: Marek Vasut <marex@denx.de>
Cc: Andrew Lunn <andrew@lunn.ch>
Cc: Florian Fainelli <f.fainelli@gmail.com>
Cc: Tristram Ha <Tristram.Ha@microchip.com>
Cc: Woojung Huh <Woojung.Huh@microchip.com>

Marek Vasut (10):
  net: dsa: microchip: Remove ksz_{read,write}24()
  net: dsa: microchip: Remove ksz_{get,set}()
  net: dsa: microchip: Inline ksz_spi.h
  net: dsa: microchip: Move ksz_cfg and ksz_port_cfg to ksz9477.c
  net: dsa: microchip: Use PORT_CTRL_ADDR() instead of indirect function
    call
  net: dsa: microchip: Factor out register access opcode generation
  net: dsa: microchip: Initial SPI regmap support
  net: dsa: microchip: Dispose of ksz_io_ops
  net: dsa: microchip: Factor out regmap config generation into common
    header
  net: dsa: microchip: Replace ad-hoc bit manipulation with regmap

 drivers/net/dsa/microchip/Kconfig       |   1 +
 drivers/net/dsa/microchip/ksz9477.c     |  35 +++---
 drivers/net/dsa/microchip/ksz9477_spi.c | 114 +++--------------
 drivers/net/dsa/microchip/ksz_common.c  |   6 +-
 drivers/net/dsa/microchip/ksz_common.h  | 157 +++++++-----------------
 drivers/net/dsa/microchip/ksz_priv.h    |  23 +---
 drivers/net/dsa/microchip/ksz_spi.h     |  69 -----------
 7 files changed, 84 insertions(+), 321 deletions(-)
 delete mode 100644 drivers/net/dsa/microchip/ksz_spi.h

-- 
2.20.1


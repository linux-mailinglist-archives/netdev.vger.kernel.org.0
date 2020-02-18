Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3F5CF16222D
	for <lists+netdev@lfdr.de>; Tue, 18 Feb 2020 09:26:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726319AbgBRI0L (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Feb 2020 03:26:11 -0500
Received: from first.geanix.com ([116.203.34.67]:59508 "EHLO first.geanix.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726180AbgBRI0L (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 18 Feb 2020 03:26:11 -0500
Received: from localhost (unknown [193.163.1.7])
        by first.geanix.com (Postfix) with ESMTPSA id 022A1C0025;
        Tue, 18 Feb 2020 08:25:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=geanix.com; s=first;
        t=1582014320; bh=/5PMdnbcZEmMSf5cYP0ZOMULsq12k2qzbPlGi8rrhgU=;
        h=From:To:Cc:Subject:Date;
        b=ZgWAOP0Hylu0LjKdn3Be7eQFCzflLQxHlbF9uN5ym2/rCl6O/6VcuXiWzoCWPi7um
         VuwNlDTMwWLPnF3jARudkJRYDPOEcX0SNjE1foTw3ezYopjP7ZHlLG2CJ1ADDZNuiJ
         nyWO8ROCLMvNKZvk93KqX4SH7RIK+9UpcGQLUIQTzauvPCtKqVTmMgNbO3J7zGakb9
         QcB6UZr9jKQiv4JCpCc1dG8VK/LydOeIQM7I2FobwSwod2xomL4oGBcQcMKWwrGdnl
         OwoihCxFENs1TfKNVjtHvah/xoG5ucszhw/2PzirGJjgSRsWRavT8WW4C3PcI6n0/3
         FRiDfyPSgmKWw==
From:   Esben Haabendal <esben@geanix.com>
To:     netdev@vger.kernel.org
Cc:     linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Andrew Lunn <andrew@lunn.ch>,
        "David S . Miller" <davem@davemloft.net>,
        Michal Simek <michal.simek@xilinx.com>,
        =?UTF-8?q?Petr=20=C5=A0tetiar?= <ynezz@true.cz>
Subject: [PATCH 0/8] net: ll_temac: Bugfixes and ethtool support
Date:   Tue, 18 Feb 2020 09:26:07 +0100
Message-Id: <20200218082607.7035-1-esben@geanix.com>
X-Mailer: git-send-email 2.25.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=1.0 required=4.0 tests=BAYES_50,DKIM_INVALID,
        DKIM_SIGNED,UNPARSEABLE_RELAY,URIBL_BLOCKED autolearn=disabled
        version=3.4.3
X-Spam-Level: *
X-Spam-Checker-Version: SpamAssassin 3.4.3 (2019-12-06) on eb9da72b0f73
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Patch 1-4 brings fixes a number of bugs observed.
Patch 5-6 are simple cleanup, removing two unused struct fields.
Patch 7-8 add ethtool support for controlling rx and tx ring sizes and irq
coalesce parameters.

Esben Haabendal (9):
  net: ll_temac: Fix race condition causing TX hang
  net: ll_temac: Add more error handling of dma_map_single() calls
  net: ll_temac: Fix RX buffer descriptor handling on GFP_ATOMIC
    pressure
  net: ll_temac: Handle DMA halt condition caused by buffer underrun
  net: ll_temac: Remove unused tx_bd_next struct field
  net: ll_temac: Remove unused start_p variable
  net: ll_temac: Make RX/TX ring sizes configurable
  net: ll_temac: Add ethtool support for coalesce parameters

 drivers/net/ethernet/xilinx/ll_temac.h      |  12 +-
 drivers/net/ethernet/xilinx/ll_temac_main.c | 435 ++++++++++++++++----
 2 files changed, 367 insertions(+), 80 deletions(-)

-- 
2.25.0


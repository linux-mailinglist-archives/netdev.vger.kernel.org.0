Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id ADE9C1642A6
	for <lists+netdev@lfdr.de>; Wed, 19 Feb 2020 11:53:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726891AbgBSKxk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Feb 2020 05:53:40 -0500
Received: from first.geanix.com ([116.203.34.67]:57086 "EHLO first.geanix.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726469AbgBSKxk (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 19 Feb 2020 05:53:40 -0500
Received: from localhost (_gateway [172.20.0.1])
        by first.geanix.com (Postfix) with ESMTPSA id 65BD6C002E;
        Wed, 19 Feb 2020 10:53:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=geanix.com; s=first;
        t=1582109617; bh=4da/aCxIHKB77/nlVZEvWvQNLVXyCUPaOYknt7VRhaI=;
        h=From:To:Cc:Subject:Date;
        b=DDOv9LgrrQVJQD+dNheEz6/+GsIeIqpnX4c77hFGGIMcNQtRUdoDxyJ/X2P2gvfuf
         HcldEgcX07ruCdx/fS/A31UBBDDB7X61YLi3zLVB3TK1rKax2pcOFvwqd3JJbgNhmg
         jhiSRa72+rVNefjiqQ82Azinq6rVTVPBBMgKApgJKS6ogrhywZmRcZEcIgKSTuxNUS
         Yon5t8ZC7e46/nVQUCCTkWJJzDt+8j64i6EiSx4CzKiRzrN6521S7Pu7hCXUTPL4g6
         fri252G4bnaci1z6dkxOgUZNJ8L4qu9Z4q0jM2T4jtucMz9i0mfrp+d7r1DXlCgvXY
         qOb3kbNj+eHBw==
From:   Esben Haabendal <esben@geanix.com>
To:     netdev@vger.kernel.org
Cc:     linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Andrew Lunn <andrew@lunn.ch>,
        "David S . Miller" <davem@davemloft.net>,
        Michal Simek <michal.simek@xilinx.com>,
        =?UTF-8?q?Petr=20=C5=A0tetiar?= <ynezz@true.cz>
Subject: [PATCH net 0/4] net: ll_temac: Bugfixes
Date:   Wed, 19 Feb 2020 11:53:37 +0100
Message-Id: <cover.1582108989.git.esben@geanix.com>
X-Mailer: git-send-email 2.25.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.7 required=4.0 tests=BAYES_00,DKIM_INVALID,
        DKIM_SIGNED,UNPARSEABLE_RELAY,URIBL_BLOCKED autolearn=disabled
        version=3.4.3
X-Spam-Checker-Version: SpamAssassin 3.4.3 (2019-12-06) on eb9da72b0f73
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fix a number of bugs which have been present since the first commit.

The bugs fixed in patch 1,2 and 4 have all been observed in real systems, and
was relatively easy to reproduce given an appropriate stress setup.

Esben Haabendal (4):
  net: ll_temac: Fix race condition causing TX hang
  net: ll_temac: Add more error handling of dma_map_single() calls
  net: ll_temac: Fix RX buffer descriptor handling on GFP_ATOMIC
    pressure
  net: ll_temac: Handle DMA halt condition caused by buffer underrun

 drivers/net/ethernet/xilinx/ll_temac.h      |   4 +
 drivers/net/ethernet/xilinx/ll_temac_main.c | 204 ++++++++++++++++----
 2 files changed, 170 insertions(+), 38 deletions(-)

-- 
2.25.0


Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7A12A10AB28
	for <lists+netdev@lfdr.de>; Wed, 27 Nov 2019 08:28:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726281AbfK0H2V (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Nov 2019 02:28:21 -0500
Received: from inva021.nxp.com ([92.121.34.21]:41346 "EHLO inva021.nxp.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726078AbfK0H2V (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 27 Nov 2019 02:28:21 -0500
Received: from inva021.nxp.com (localhost [127.0.0.1])
        by inva021.eu-rdc02.nxp.com (Postfix) with ESMTP id BC8C920018D;
        Wed, 27 Nov 2019 08:28:19 +0100 (CET)
Received: from invc005.ap-rdc01.nxp.com (invc005.ap-rdc01.nxp.com [165.114.16.14])
        by inva021.eu-rdc02.nxp.com (Postfix) with ESMTP id C53B020001F;
        Wed, 27 Nov 2019 08:28:16 +0100 (CET)
Received: from localhost.localdomain (mega.ap.freescale.net [10.192.208.232])
        by invc005.ap-rdc01.nxp.com (Postfix) with ESMTP id BC8364028F;
        Wed, 27 Nov 2019 15:28:12 +0800 (SGT)
From:   Yangbo Lu <yangbo.lu@nxp.com>
To:     netdev@vger.kernel.org,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Microchip Linux Driver Support <UNGLinuxDriver@microchip.com>,
        "David S . Miller" <davem@davemloft.net>,
        Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     Yangbo Lu <yangbo.lu@nxp.com>
Subject: [v2, 0/2] net: mscc: ocelot: fix potential issues accessing skbs list
Date:   Wed, 27 Nov 2019 15:27:55 +0800
Message-Id: <20191127072757.34502-1-yangbo.lu@nxp.com>
X-Mailer: git-send-email 2.17.1
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fix two prtential issues accessing skbs list.
- Break the matching loop when find the matching skb to avoid
  consuming more skbs incorrectly. The timestamp ID is only
  from 0 to 3 while the FIFO supports 128 timestamps at most.
- Convert to use skb queue instead of the list of skbs to provide
  protect with lock.

---
Changes for v2:
	- Split into two patches.
	- Converted to use skb queue.

Yangbo Lu (2):
  net: mscc: ocelot: avoid incorrect consuming in skbs list
  net: mscc: ocelot: use skb queue instead of skbs list

 drivers/net/ethernet/mscc/ocelot.c | 55 +++++++++++++-------------------------
 include/soc/mscc/ocelot.h          |  9 +------
 2 files changed, 20 insertions(+), 44 deletions(-)

-- 
2.7.4


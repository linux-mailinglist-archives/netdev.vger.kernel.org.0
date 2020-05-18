Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 91B4C1D881F
	for <lists+netdev@lfdr.de>; Mon, 18 May 2020 21:21:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727998AbgERTVb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 May 2020 15:21:31 -0400
Received: from mga09.intel.com ([134.134.136.24]:61288 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727937AbgERTVb (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 18 May 2020 15:21:31 -0400
IronPort-SDR: eROm7EE0433qotRUCdMVNlnIXh6g5kn51aeVpMlM6bCITsV5RHj0Ax6txBRwd6gx+by0zoNSrQ
 4c2Wsp6m77Yg==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 May 2020 12:21:30 -0700
IronPort-SDR: F3JgKJwsBnP/kP+ZNx2QR6bsWrCPZSCzTCMfei2gLJfNiM/TwakM9q2cg0xp7CNOBOwtXNZQc9
 r2FOECzxY/AA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,407,1583222400"; 
   d="scan'208";a="264061572"
Received: from black.fi.intel.com ([10.237.72.28])
  by orsmga003.jf.intel.com with ESMTP; 18 May 2020 12:21:29 -0700
Received: by black.fi.intel.com (Postfix, from userid 1003)
        id B532579; Mon, 18 May 2020 22:21:28 +0300 (EEST)
From:   Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Cc:     Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: [PATCH v1] net: seeq: Use %pM format specifier for MAC addresses
Date:   Mon, 18 May 2020 22:21:28 +0300
Message-Id: <20200518192128.72875-1-andriy.shevchenko@linux.intel.com>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Convert to %pM instead of using custom code.

Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
---
 drivers/net/ethernet/seeq/ether3.c | 5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/seeq/ether3.c b/drivers/net/ethernet/seeq/ether3.c
index 128ee7cda1ed..65c98837ec45 100644
--- a/drivers/net/ethernet/seeq/ether3.c
+++ b/drivers/net/ethernet/seeq/ether3.c
@@ -610,12 +610,9 @@ static int ether3_rx(struct net_device *dev, unsigned int maxcnt)
 		ether3_readbuffer(dev, addrs+2, 12);
 
 if (next_ptr < RX_START || next_ptr >= RX_END) {
- int i;
  printk("%s: bad next pointer @%04X: ", dev->name, priv(dev)->rx_head);
  printk("%02X %02X %02X %02X ", next_ptr >> 8, next_ptr & 255, status & 255, status >> 8);
- for (i = 2; i < 14; i++)
-   printk("%02X ", addrs[i]);
- printk("\n");
+ printk("%pM %pM\n", addrs + 2, addrs + 8);
  next_ptr = priv(dev)->rx_head;
  break;
 }
-- 
2.26.2


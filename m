Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B86683C5E5B
	for <lists+netdev@lfdr.de>; Mon, 12 Jul 2021 16:29:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235120AbhGLOcK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Jul 2021 10:32:10 -0400
Received: from mga12.intel.com ([192.55.52.136]:46630 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235026AbhGLOcJ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 12 Jul 2021 10:32:09 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10042"; a="189673998"
X-IronPort-AV: E=Sophos;i="5.84,234,1620716400"; 
   d="scan'208";a="189673998"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Jul 2021 07:29:21 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.84,234,1620716400"; 
   d="scan'208";a="652994852"
Received: from black.fi.intel.com ([10.237.72.28])
  by fmsmga005.fm.intel.com with ESMTP; 12 Jul 2021 07:29:19 -0700
Received: by black.fi.intel.com (Postfix, from userid 1003)
        id C883FFF; Mon, 12 Jul 2021 17:29:46 +0300 (EEST)
From:   Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To:     Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     Kalle Valo <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH v1 1/1] ray_cs: use %*ph to print small buffer
Date:   Mon, 12 Jul 2021 17:29:43 +0300
Message-Id: <20210712142943.23981-1-andriy.shevchenko@linux.intel.com>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Use %*ph format to print small buffer as hex string.

Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
---
 drivers/net/wireless/ray_cs.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/net/wireless/ray_cs.c b/drivers/net/wireless/ray_cs.c
index 590bd974d94f..de614ac60421 100644
--- a/drivers/net/wireless/ray_cs.c
+++ b/drivers/net/wireless/ray_cs.c
@@ -2424,9 +2424,7 @@ static void rx_authenticate(ray_dev_t *local, struct rcs __iomem *prcs,
 	copy_from_rx_buff(local, buff, pkt_addr, rx_len & 0xff);
 	/* if we are trying to get authenticated */
 	if (local->sparm.b4.a_network_type == ADHOC) {
-		pr_debug("ray_cs rx_auth var= %02x %02x %02x %02x %02x %02x\n",
-		      msg->var[0], msg->var[1], msg->var[2], msg->var[3],
-		      msg->var[4], msg->var[5]);
+		pr_debug("ray_cs rx_auth var= %6ph\n", msg->var);
 		if (msg->var[2] == 1) {
 			pr_debug("ray_cs Sending authentication response.\n");
 			if (!build_auth_frame
-- 
2.30.2


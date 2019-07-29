Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7C33B78F1E
	for <lists+netdev@lfdr.de>; Mon, 29 Jul 2019 17:24:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387976AbfG2PYi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Jul 2019 11:24:38 -0400
Received: from mout.kundenserver.de ([212.227.17.13]:52433 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387693AbfG2PYi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Jul 2019 11:24:38 -0400
Received: from orion.localdomain ([77.4.29.213]) by mrelayeu.kundenserver.de
 (mreue108 [212.227.15.183]) with ESMTPSA (Nemesis) id
 1MKKhF-1i5eBx0MWt-00Lnd4; Mon, 29 Jul 2019 17:24:34 +0200
From:   "Enrico Weigelt, metux IT consult" <info@metux.net>
To:     linux-kernel@vger.kernel.org
Cc:     amitkarwar@gmail.com, siva8118@gmail.com, kvalo@codeaurora.org,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH] drivers: net: wireless: rsi: return explicit error values
Date:   Mon, 29 Jul 2019 17:24:32 +0200
Message-Id: <1564413872-10720-1-git-send-email-info@metux.net>
X-Mailer: git-send-email 1.9.1
X-Provags-ID: V03:K1:ksVHMps503+LcqYL67PSCCKtCJFaPbytVqqBbTkepts7c9sg6Jr
 FSBjEO9XnujHOF+0IOR3PLdTvQLM1S/FDtYxvh+jS1ljbsyUHKJEnOCuC80uSTkD/Mn6oDp
 TTfFQadmLc6OQ/AUx2JHcPSLpovSY+csUzVHLwOw7lcW25fYgzYIO2Tf3KSKhBPMeTmylPR
 8nyJx0p1f/ZkA+irHDWbw==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:AmsVlK1Vod8=:ecBNmD13mZxnUDmtu8Mxlb
 dG3t2s+KCPddyIAVbG4Z1Pl3/QBWLdnIbviBejI8dnVXeBd3WF5CCuyAMI8wq28O+tk7CDnxx
 T/SLiqAs59yqw9uUoD4Km7Khg3lFsdMZzl90Kr4T56jHJCmBRrQCOh8JO5Obha5BnZ84nnE5C
 lFsJjBgDuO/JB3/yZwRMZ+/U+M392JpYL0ss82J378hjnkd0eRdFu+1QakOAjjO5YwqqfXKMp
 d/i3FmQ9jxlxn7N4C0uPunHuMny89paYbrIr8nrn0kM5RX+ECW8kRJ+r5UiQb3EzOCFXsgtKK
 vfWqVD5zCzhKmdu5iqFTDqPisDK2BPbkgaHUZrb7MVkjose5lQ/uCplCqkinBLJQ0WLoP+fL2
 FfAVkrwvdfEAL9i4glS+n11t4lDyP7iuW9iiYIHGc/1Z5zyp/WMJ1sBnYpHYc16kM6KEZ52ay
 bnOx6IAC2qQddI2fbxX0B8TvBCti0ZINVWaroXgowikCjgcIz1JbFG2W8HEMSpbTQlrTI7I7p
 9qac/U5tRoNI+hppFB6/DHvZDpBrYFQp99BvTDgmm55h8G+/ceiZq5pCXaH7ZuuZUIdaH+NGT
 7n0fiA1Of0cVrWq7Gw3zXbdZ+rnZlPu5tFVFejw+hfvIIwLMno60xNzqlokjxA1baTUHDUlfT
 5rKB+9kU+g9XLnYkbEtXVz6Wg8XJlBWHjTTG6cfmRyOHcaRBJ04w5miECOecXuI8SBcLkFpyv
 ERtPExwhoXjW9Xo4mAvyLV2nvD9UVdiv9LjSwA==
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Enrico Weigelt <info@metux.net>

Explicitly return constants instead of variable (and rely on
it to be explicitly initialized), if the value is supposed
to be fixed anyways. Align it with the rest of the driver,
which does it the same way.

Signed-off-by: Enrico Weigelt <info@metux.net>
---
 drivers/net/wireless/rsi/rsi_91x_sdio.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/rsi/rsi_91x_sdio.c b/drivers/net/wireless/rsi/rsi_91x_sdio.c
index b42cd50..2a3577d 100644
--- a/drivers/net/wireless/rsi/rsi_91x_sdio.c
+++ b/drivers/net/wireless/rsi/rsi_91x_sdio.c
@@ -844,11 +844,11 @@ static int rsi_init_sdio_interface(struct rsi_hw *adapter,
 				   struct sdio_func *pfunction)
 {
 	struct rsi_91x_sdiodev *rsi_91x_dev;
-	int status = -ENOMEM;
+	int status;
 
 	rsi_91x_dev = kzalloc(sizeof(*rsi_91x_dev), GFP_KERNEL);
 	if (!rsi_91x_dev)
-		return status;
+		return -ENOMEM;
 
 	adapter->rsi_dev = rsi_91x_dev;
 
@@ -890,7 +890,7 @@ static int rsi_init_sdio_interface(struct rsi_hw *adapter,
 #ifdef CONFIG_RSI_DEBUGFS
 	adapter->num_debugfs_entries = MAX_DEBUGFS_ENTRIES;
 #endif
-	return status;
+	return 0;
 fail:
 	sdio_disable_func(pfunction);
 	sdio_release_host(pfunction);
-- 
1.9.1


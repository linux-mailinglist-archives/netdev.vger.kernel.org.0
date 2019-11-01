Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DFB9BEC2C8
	for <lists+netdev@lfdr.de>; Fri,  1 Nov 2019 13:37:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730380AbfKAMht (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 1 Nov 2019 08:37:49 -0400
Received: from szxga04-in.huawei.com ([45.249.212.190]:5689 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1730364AbfKAMhr (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 1 Nov 2019 08:37:47 -0400
Received: from DGGEMS403-HUB.china.huawei.com (unknown [172.30.72.59])
        by Forcepoint Email with ESMTP id 116C29E00AD75C776F88;
        Fri,  1 Nov 2019 20:37:46 +0800 (CST)
Received: from linux-ibm.site (10.175.102.37) by
 DGGEMS403-HUB.china.huawei.com (10.3.19.203) with Microsoft SMTP Server id
 14.3.439.0; Fri, 1 Nov 2019 20:37:35 +0800
From:   zhong jiang <zhongjiang@huawei.com>
To:     <kvalo@codeaurora.org>, <stas.yakovlev@gmail.com>,
        <simon.horman@netronome.com>
CC:     <linux-wireless@vger.kernel.org>, <netdev@vger.kernel.org>,
        <zhongjiang@huawei.com>
Subject: [PATCH v2 3/3] b43legacy: ASoC: ux500: Remove redundant variable "count"
Date:   Fri, 1 Nov 2019 20:33:41 +0800
Message-ID: <1572611621-13280-4-git-send-email-zhongjiang@huawei.com>
X-Mailer: git-send-email 1.7.12.4
In-Reply-To: <1572611621-13280-1-git-send-email-zhongjiang@huawei.com>
References: <1572611621-13280-1-git-send-email-zhongjiang@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.175.102.37]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

local variable "count" is not used. hence it is safe to remove and
just return 0.

Signed-off-by: zhong jiang <zhongjiang@huawei.com>
---
 drivers/net/wireless/broadcom/b43legacy/debugfs.c | 9 +++------
 1 file changed, 3 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/broadcom/b43legacy/debugfs.c b/drivers/net/wireless/broadcom/b43legacy/debugfs.c
index 082aab8..de766c7 100644
--- a/drivers/net/wireless/broadcom/b43legacy/debugfs.c
+++ b/drivers/net/wireless/broadcom/b43legacy/debugfs.c
@@ -65,7 +65,6 @@ struct b43legacy_dfs_file * fops_to_dfs_file(struct b43legacy_wldev *dev,
 /* wl->irq_lock is locked */
 static ssize_t tsf_read_file(struct b43legacy_wldev *dev, char *buf, size_t bufsize)
 {
-	ssize_t count = 0;
 	u64 tsf;
 
 	b43legacy_tsf_read(dev, &tsf);
@@ -73,7 +72,7 @@ static ssize_t tsf_read_file(struct b43legacy_wldev *dev, char *buf, size_t bufs
 		(unsigned int)((tsf & 0xFFFFFFFF00000000ULL) >> 32),
 		(unsigned int)(tsf & 0xFFFFFFFFULL));
 
-	return count;
+	return 0;
 }
 
 /* wl->irq_lock is locked */
@@ -91,7 +90,6 @@ static int tsf_write_file(struct b43legacy_wldev *dev, const char *buf, size_t c
 /* wl->irq_lock is locked */
 static ssize_t ucode_regs_read_file(struct b43legacy_wldev *dev, char *buf, size_t bufsize)
 {
-	ssize_t count = 0;
 	int i;
 
 	for (i = 0; i < 64; i++) {
@@ -99,7 +97,7 @@ static ssize_t ucode_regs_read_file(struct b43legacy_wldev *dev, char *buf, size
 			b43legacy_shm_read16(dev, B43legacy_SHM_WIRELESS, i));
 	}
 
-	return count;
+	return 0;
 }
 
 /* wl->irq_lock is locked */
@@ -125,7 +123,6 @@ static ssize_t shm_read_file(struct b43legacy_wldev *dev, char *buf, size_t bufs
 static ssize_t txstat_read_file(struct b43legacy_wldev *dev, char *buf, size_t bufsize)
 {
 	struct b43legacy_txstatus_log *log = &dev->dfsentry->txstatlog;
-	ssize_t count = 0;
 	unsigned long flags;
 	int i, idx;
 	struct b43legacy_txstatus *stat;
@@ -166,7 +163,7 @@ static ssize_t txstat_read_file(struct b43legacy_wldev *dev, char *buf, size_t b
 out_unlock:
 	spin_unlock_irqrestore(&log->lock, flags);
 
-	return count;
+	return 0;
 }
 
 /* wl->irq_lock is locked */
-- 
1.7.12.4


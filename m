Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4762E3BBA3C
	for <lists+netdev@lfdr.de>; Mon,  5 Jul 2021 11:35:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230375AbhGEJiQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Jul 2021 05:38:16 -0400
Received: from inva020.nxp.com ([92.121.34.13]:46364 "EHLO inva020.nxp.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230262AbhGEJiP (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 5 Jul 2021 05:38:15 -0400
Received: from inva020.nxp.com (localhost [127.0.0.1])
        by inva020.eu-rdc02.nxp.com (Postfix) with ESMTP id A90BC1A0476;
        Mon,  5 Jul 2021 11:35:37 +0200 (CEST)
Received: from aprdc01srsp001v.ap-rdc01.nxp.com (aprdc01srsp001v.ap-rdc01.nxp.com [165.114.16.16])
        by inva020.eu-rdc02.nxp.com (Postfix) with ESMTP id 707951A0465;
        Mon,  5 Jul 2021 11:35:37 +0200 (CEST)
Received: from localhost.localdomain (mega.ap.freescale.net [10.192.208.232])
        by aprdc01srsp001v.ap-rdc01.nxp.com (Postfix) with ESMTP id BD96E183AC98;
        Mon,  5 Jul 2021 17:35:35 +0800 (+08)
From:   Yangbo Lu <yangbo.lu@nxp.com>
To:     netdev@vger.kernel.org
Cc:     Yangbo Lu <yangbo.lu@nxp.com>, linux-kernel@vger.kernel.org,
        Richard Cochran <richardcochran@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Rui Sousa <rui.sousa@nxp.com>,
        Sebastien Laveze <sebastien.laveze@nxp.com>
Subject: [net] ptp: fix format string mismatch in ptp_sysfs.c
Date:   Mon,  5 Jul 2021 17:46:17 +0800
Message-Id: <20210705094617.15470-1-yangbo.lu@nxp.com>
X-Mailer: git-send-email 2.17.1
X-Virus-Scanned: ClamAV using ClamSMTP
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fix format string mismatch in ptp_sysfs.c. Use %u for unsigned int.

Fixes: 73f37068d540 ("ptp: support ptp physical/virtual clocks conversion")
Reported-by: kernel test robot <lkp@intel.com>
Signed-off-by: Yangbo Lu <yangbo.lu@nxp.com>
---
 drivers/ptp/ptp_sysfs.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/ptp/ptp_sysfs.c b/drivers/ptp/ptp_sysfs.c
index 6a36590ca77a..b3d96b747292 100644
--- a/drivers/ptp/ptp_sysfs.c
+++ b/drivers/ptp/ptp_sysfs.c
@@ -179,7 +179,7 @@ static ssize_t n_vclocks_show(struct device *dev,
 	if (mutex_lock_interruptible(&ptp->n_vclocks_mux))
 		return -ERESTARTSYS;
 
-	size = snprintf(page, PAGE_SIZE - 1, "%d\n", ptp->n_vclocks);
+	size = snprintf(page, PAGE_SIZE - 1, "%u\n", ptp->n_vclocks);
 
 	mutex_unlock(&ptp->n_vclocks_mux);
 
@@ -252,7 +252,7 @@ static ssize_t max_vclocks_show(struct device *dev,
 	struct ptp_clock *ptp = dev_get_drvdata(dev);
 	ssize_t size;
 
-	size = snprintf(page, PAGE_SIZE - 1, "%d\n", ptp->max_vclocks);
+	size = snprintf(page, PAGE_SIZE - 1, "%u\n", ptp->max_vclocks);
 
 	return size;
 }

base-commit: 6ff63a150b5556012589ae59efac1b5eeb7d32c3
-- 
2.25.1


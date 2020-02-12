Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 536A015A631
	for <lists+netdev@lfdr.de>; Wed, 12 Feb 2020 11:22:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727671AbgBLKV4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Feb 2020 05:21:56 -0500
Received: from inva021.nxp.com ([92.121.34.21]:43990 "EHLO inva021.nxp.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725945AbgBLKV4 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 12 Feb 2020 05:21:56 -0500
Received: from inva021.nxp.com (localhost [127.0.0.1])
        by inva021.eu-rdc02.nxp.com (Postfix) with ESMTP id A52E9200F52;
        Wed, 12 Feb 2020 11:21:53 +0100 (CET)
Received: from invc005.ap-rdc01.nxp.com (invc005.ap-rdc01.nxp.com [165.114.16.14])
        by inva021.eu-rdc02.nxp.com (Postfix) with ESMTP id 480D4203CB5;
        Wed, 12 Feb 2020 11:21:50 +0100 (CET)
Received: from localhost.localdomain (mega.ap.freescale.net [10.192.208.232])
        by invc005.ap-rdc01.nxp.com (Postfix) with ESMTP id 9FDD74029B;
        Wed, 12 Feb 2020 18:21:46 +0800 (SGT)
From:   Yangbo Lu <yangbo.lu@nxp.com>
To:     netdev@vger.kernel.org, "David S . Miller" <davem@davemloft.net>,
        Richard Cochran <richardcochran@gmail.com>
Cc:     Yangbo Lu <yangbo.lu@nxp.com>
Subject: [v2] ptp_qoriq: add initialization message
Date:   Wed, 12 Feb 2020 18:19:16 +0800
Message-Id: <20200212101916.27085-1-yangbo.lu@nxp.com>
X-Mailer: git-send-email 2.17.1
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Current ptp_qoriq driver prints only warning or error messages.
It may be loaded successfully without any messages.
Although this is fine, it would be convenient to have an oneline
initialization log showing success and PTP clock index.
The goods are,
- The ptp_qoriq driver users may know whether this driver is loaded
  successfully, or not, or not loaded from the booting log.
- The ptp_qoriq driver users don't have to install an ethtool to
  check the PTP clock index for using. Or don't have to check which
  /sys/class/ptp/ptpX is PTP QorIQ clock.

Signed-off-by: Yangbo Lu <yangbo.lu@nxp.com>
---
Changes for v2:
	- Added more in commit message.
---
 drivers/ptp/ptp_qoriq.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/ptp/ptp_qoriq.c b/drivers/ptp/ptp_qoriq.c
index b27c46e..66e7d57 100644
--- a/drivers/ptp/ptp_qoriq.c
+++ b/drivers/ptp/ptp_qoriq.c
@@ -541,6 +541,8 @@ int ptp_qoriq_init(struct ptp_qoriq *ptp_qoriq, void __iomem *base,
 
 	ptp_qoriq->phc_index = ptp_clock_index(ptp_qoriq->clock);
 	ptp_qoriq_create_debugfs(ptp_qoriq);
+
+	pr_info("new PTP clock ptp%d\n", ptp_qoriq->phc_index);
 	return 0;
 }
 EXPORT_SYMBOL_GPL(ptp_qoriq_init);
-- 
2.7.4


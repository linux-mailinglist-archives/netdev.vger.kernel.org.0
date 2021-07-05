Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 930963BB97D
	for <lists+netdev@lfdr.de>; Mon,  5 Jul 2021 10:42:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230194AbhGEIpJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Jul 2021 04:45:09 -0400
Received: from inva021.nxp.com ([92.121.34.21]:47996 "EHLO inva021.nxp.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230107AbhGEIpI (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 5 Jul 2021 04:45:08 -0400
Received: from inva021.nxp.com (localhost [127.0.0.1])
        by inva021.eu-rdc02.nxp.com (Postfix) with ESMTP id 013D420261C;
        Mon,  5 Jul 2021 10:42:31 +0200 (CEST)
Received: from aprdc01srsp001v.ap-rdc01.nxp.com (aprdc01srsp001v.ap-rdc01.nxp.com [165.114.16.16])
        by inva021.eu-rdc02.nxp.com (Postfix) with ESMTP id BE98020067D;
        Mon,  5 Jul 2021 10:42:30 +0200 (CEST)
Received: from localhost.localdomain (mega.ap.freescale.net [10.192.208.232])
        by aprdc01srsp001v.ap-rdc01.nxp.com (Postfix) with ESMTP id 2F0ED183ACDF;
        Mon,  5 Jul 2021 16:42:29 +0800 (+08)
From:   Yangbo Lu <yangbo.lu@nxp.com>
To:     netdev@vger.kernel.org
Cc:     Yangbo Lu <yangbo.lu@nxp.com>, linux-kernel@vger.kernel.org,
        Richard Cochran <richardcochran@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Rui Sousa <rui.sousa@nxp.com>,
        Sebastien Laveze <sebastien.laveze@nxp.com>
Subject: [net] ptp: fix NULL pointer dereference in ptp_clock_register
Date:   Mon,  5 Jul 2021 16:53:06 +0800
Message-Id: <20210705085306.15470-1-yangbo.lu@nxp.com>
X-Mailer: git-send-email 2.17.1
X-Virus-Scanned: ClamAV using ClamSMTP
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fix NULL pointer dereference in ptp_clock_register. The argument
"parent" of ptp_clock_register may be NULL pointer.

Fixes: 73f37068d540 ("ptp: support ptp physical/virtual clocks conversion")
Reported-by: kernel test robot <oliver.sang@intel.com>
Signed-off-by: Yangbo Lu <yangbo.lu@nxp.com>
---
 drivers/ptp/ptp_clock.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/ptp/ptp_clock.c b/drivers/ptp/ptp_clock.c
index f012fa581cf4..ce6d9fc85607 100644
--- a/drivers/ptp/ptp_clock.c
+++ b/drivers/ptp/ptp_clock.c
@@ -236,7 +236,7 @@ struct ptp_clock *ptp_clock_register(struct ptp_clock_info *info,
 	}
 
 	/* PTP virtual clock is being registered under physical clock */
-	if (parent->class && parent->class->name &&
+	if (parent && parent->class && parent->class->name &&
 	    strcmp(parent->class->name, "ptp") == 0)
 		ptp->is_virtual_clock = true;
 

base-commit: 6ff63a150b5556012589ae59efac1b5eeb7d32c3
-- 
2.25.1


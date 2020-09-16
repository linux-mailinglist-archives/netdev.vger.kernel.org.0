Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 46E7C26C80C
	for <lists+netdev@lfdr.de>; Wed, 16 Sep 2020 20:39:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728191AbgIPSju (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Sep 2020 14:39:50 -0400
Received: from inva020.nxp.com ([92.121.34.13]:46854 "EHLO inva020.nxp.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728067AbgIPS2z (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 16 Sep 2020 14:28:55 -0400
Received: from inva020.nxp.com (localhost [127.0.0.1])
        by inva020.eu-rdc02.nxp.com (Postfix) with ESMTP id 563D71A0334;
        Wed, 16 Sep 2020 14:16:53 +0200 (CEST)
Received: from invc005.ap-rdc01.nxp.com (invc005.ap-rdc01.nxp.com [165.114.16.14])
        by inva020.eu-rdc02.nxp.com (Postfix) with ESMTP id 474231A0CB8;
        Wed, 16 Sep 2020 14:16:50 +0200 (CEST)
Received: from localhost.localdomain (mega.ap.freescale.net [10.192.208.232])
        by invc005.ap-rdc01.nxp.com (Postfix) with ESMTP id 97FA3402E3;
        Wed, 16 Sep 2020 14:16:45 +0200 (CEST)
From:   Yangbo Lu <yangbo.lu@nxp.com>
To:     netdev@vger.kernel.org
Cc:     Yangbo Lu <yangbo.lu@nxp.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Ioana Ciornei <ioana.ciornei@nxp.com>,
        Ioana Radulescu <ruxandra.radulescu@nxp.com>,
        Richard Cochran <richardcochran@gmail.com>
Subject: [v3, 6/6] dpaa2-eth: fix a build warning in dpmac.c
Date:   Wed, 16 Sep 2020 20:08:30 +0800
Message-Id: <20200916120830.11456-7-yangbo.lu@nxp.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200916120830.11456-1-yangbo.lu@nxp.com>
References: <20200916120830.11456-1-yangbo.lu@nxp.com>
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fix below sparse warning in dpmac.c.
warning: cast to restricted __le64

Signed-off-by: Yangbo Lu <yangbo.lu@nxp.com>
---
Changes for v3:
	- Added this patch.
---
 drivers/net/ethernet/freescale/dpaa2/dpmac.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/freescale/dpaa2/dpmac.c b/drivers/net/ethernet/freescale/dpaa2/dpmac.c
index d5997b6..71f165c 100644
--- a/drivers/net/ethernet/freescale/dpaa2/dpmac.c
+++ b/drivers/net/ethernet/freescale/dpaa2/dpmac.c
@@ -177,7 +177,7 @@ int dpmac_get_counter(struct fsl_mc_io *mc_io, u32 cmd_flags, u16 token,
 		return err;
 
 	dpmac_rsp = (struct dpmac_rsp_get_counter *)cmd.params;
-	*value = le64_to_cpu(dpmac_rsp->counter);
+	*value = dpmac_rsp->counter;
 
 	return 0;
 }
-- 
2.7.4


Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 46F2A12929C
	for <lists+netdev@lfdr.de>; Mon, 23 Dec 2019 09:06:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725901AbfLWIGO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Dec 2019 03:06:14 -0500
Received: from inva021.nxp.com ([92.121.34.21]:40584 "EHLO inva021.nxp.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725810AbfLWIGO (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 23 Dec 2019 03:06:14 -0500
Received: from inva021.nxp.com (localhost [127.0.0.1])
        by inva021.eu-rdc02.nxp.com (Postfix) with ESMTP id 00695200303;
        Mon, 23 Dec 2019 09:06:13 +0100 (CET)
Received: from inva024.eu-rdc02.nxp.com (inva024.eu-rdc02.nxp.com [134.27.226.22])
        by inva021.eu-rdc02.nxp.com (Postfix) with ESMTP id E7C3E200A39;
        Mon, 23 Dec 2019 09:06:12 +0100 (CET)
Received: from fsr-fed2164-101.ea.freescale.net (fsr-fed2164-101.ea.freescale.net [10.171.82.91])
        by inva024.eu-rdc02.nxp.com (Postfix) with ESMTP id A1B292033F;
        Mon, 23 Dec 2019 09:06:12 +0100 (CET)
From:   Madalin Bucur <madalin.bucur@oss.nxp.com>
To:     davem@davemloft.net, netdev@vger.kernel.org
Cc:     Madalin Bucur <madalin.bucur@oss.nxp.com>
Subject: [PATCH net,v2] net: phy: aquantia: add suspend / resume ops for AQR105
Date:   Mon, 23 Dec 2019 10:06:10 +0200
Message-Id: <1577088370-21954-1-git-send-email-madalin.bucur@oss.nxp.com>
X-Mailer: git-send-email 2.1.0
Content-Type: text/plain; charset="us-ascii"
Reply-to: madalin.bucur@oss.nxp.com
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The suspend/resume code for AQR107 works on AQR105 too.
This patch fixes issues with the partner not seeing the link down
when the interface using AQR105 is brought down.

Fixes: bee8259dd31f ("net: phy: add driver for aquantia phy")
Signed-off-by: Madalin Bucur <madalin.bucur@oss.nxp.com>
---

Changes from v1: add Fixes: tag

 drivers/net/phy/aquantia_main.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/phy/aquantia_main.c b/drivers/net/phy/aquantia_main.c
index 3b29d381116f..975789d9349d 100644
--- a/drivers/net/phy/aquantia_main.c
+++ b/drivers/net/phy/aquantia_main.c
@@ -627,6 +627,8 @@ static struct phy_driver aqr_driver[] = {
 	.config_intr	= aqr_config_intr,
 	.ack_interrupt	= aqr_ack_interrupt,
 	.read_status	= aqr_read_status,
+	.suspend	= aqr107_suspend,
+	.resume		= aqr107_resume,
 },
 {
 	PHY_ID_MATCH_MODEL(PHY_ID_AQR106),
-- 
2.1.0


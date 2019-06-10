Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B10CA3AD96
	for <lists+netdev@lfdr.de>; Mon, 10 Jun 2019 05:20:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387696AbfFJDUM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 9 Jun 2019 23:20:12 -0400
Received: from inva020.nxp.com ([92.121.34.13]:43254 "EHLO inva020.nxp.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387420AbfFJDTd (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 9 Jun 2019 23:19:33 -0400
Received: from inva020.nxp.com (localhost [127.0.0.1])
        by inva020.eu-rdc02.nxp.com (Postfix) with ESMTP id 9142C1A0746;
        Mon, 10 Jun 2019 05:19:31 +0200 (CEST)
Received: from invc005.ap-rdc01.nxp.com (invc005.ap-rdc01.nxp.com [165.114.16.14])
        by inva020.eu-rdc02.nxp.com (Postfix) with ESMTP id 729861A001F;
        Mon, 10 Jun 2019 05:19:27 +0200 (CEST)
Received: from localhost.localdomain (mega.ap.freescale.net [10.192.208.232])
        by invc005.ap-rdc01.nxp.com (Postfix) with ESMTP id 0D8AE402FB;
        Mon, 10 Jun 2019 11:19:21 +0800 (SGT)
From:   Yangbo Lu <yangbo.lu@nxp.com>
To:     netdev@vger.kernel.org, "David S . Miller" <davem@davemloft.net>,
        Richard Cochran <richardcochran@gmail.com>,
        Rob Herring <robh+dt@kernel.org>,
        Shawn Guo <shawnguo@kernel.org>
Cc:     linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        devicetree@vger.kernel.org, Yangbo Lu <yangbo.lu@nxp.com>
Subject: [PATCH 1/6] ptp: add QorIQ PTP support for DPAA2
Date:   Mon, 10 Jun 2019 11:21:03 +0800
Message-Id: <20190610032108.5791-2-yangbo.lu@nxp.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190610032108.5791-1-yangbo.lu@nxp.com>
References: <20190610032108.5791-1-yangbo.lu@nxp.com>
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch is to add QorIQ PTP support for DPAA2.
Although dpaa2-ptp.c driver is a fsl_mc_driver which
is using MC APIs for register accessing, it's same
IP block with eTSEC/DPAA/ENETC 1588 timer. We will
convert to reuse ptp_qoriq driver by using register
ioremap and dropping related MC APIs.

Signed-off-by: Yangbo Lu <yangbo.lu@nxp.com>
---
 drivers/ptp/Kconfig | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/ptp/Kconfig b/drivers/ptp/Kconfig
index 9b8fee5..b1b454f 100644
--- a/drivers/ptp/Kconfig
+++ b/drivers/ptp/Kconfig
@@ -44,7 +44,7 @@ config PTP_1588_CLOCK_DTE
 
 config PTP_1588_CLOCK_QORIQ
 	tristate "Freescale QorIQ 1588 timer as PTP clock"
-	depends on GIANFAR || FSL_DPAA_ETH || FSL_ENETC || FSL_ENETC_VF
+	depends on GIANFAR || FSL_DPAA_ETH || FSL_DPAA2_ETH || FSL_ENETC || FSL_ENETC_VF
 	depends on PTP_1588_CLOCK
 	default y
 	help
-- 
2.7.4


Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C54B361DA1
	for <lists+netdev@lfdr.de>; Mon,  8 Jul 2019 13:07:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728684AbfGHLHR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Jul 2019 07:07:17 -0400
Received: from dispatch1-us1.ppe-hosted.com ([67.231.154.164]:59448 "EHLO
        dispatch1-us1.ppe-hosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726501AbfGHLHR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 8 Jul 2019 07:07:17 -0400
X-Virus-Scanned: Proofpoint Essentials engine
Received: from webmail.solarflare.com (uk.solarflare.com [193.34.186.16])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mx1-us4.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTPS id 62227140063;
        Mon,  8 Jul 2019 11:07:15 +0000 (UTC)
Received: from mh-desktop.uk.solarflarecom.com (10.17.20.62) by
 ukex01.SolarFlarecom.com (10.17.10.4) with Microsoft SMTP Server (TLS) id
 15.0.1395.4; Mon, 8 Jul 2019 12:07:12 +0100
Subject: [PATCH net-next] sfc: Remove 'PCIE error reporting unavailable'
From:   Martin Habets <mhabets@solarflare.com>
To:     <mhabets@solarflare.com>, <davem@davemloft.net>,
        <linux-net-drivers@solarflare.com>
CC:     <netdev@vger.kernel.org>
Date:   Mon, 8 Jul 2019 12:07:11 +0100
Message-ID: <156258403191.17195.13184667600147687856.stgit@mh-desktop.uk.solarflarecom.com>
User-Agent: StGit/unknown-version
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.17.20.62]
X-ClientProxiedBy: ukex01.SolarFlarecom.com (10.17.10.4) To
 ukex01.SolarFlarecom.com (10.17.10.4)
X-TM-AS-Product-Ver: SMEX-12.5.0.1300-8.5.1010-24746.003
X-TM-AS-Result: No-3.772800-8.000000-10
X-TMASE-MatchedRID: EkehRD3Hwu/F31R1OJxdtHGg/sD2gWLWSWg+u4ir2NMjRiu1AuxJTJwv
        sCIoaFvVXtST0yMsjsBTvVffeIwvQwUcfW/oedmqPwKTD1v8YV5MkOX0UoduuVVkJxysad/IbjU
        RqDyhk6EezchVGiUvLHk48PxckV+kTX7PJ/OU3vKDGx/OQ1GV8t0H8LFZNFG7MGpgBNI6BaPB7E
        sQqHahIaEFyQar4MqOvepxLFzFweaKXYhVr1UHzBTh6g7sbNlS8SZAqqmPu6Rg8x106ZOBPLIVf
        j7ILQQLystdgrSuvfQEwgV2twOxPhxPa4lbH7OeTdr0QToql1Msc+bDq5gu5/fbIpwSGZvXftwZ
        3X11IV0=
X-TM-AS-User-Approved-Sender: Yes
X-TM-AS-User-Blocked-Sender: No
X-TMASE-Result: 10--3.772800-8.000000
X-TMASE-Version: SMEX-12.5.0.1300-8.5.1010-24746.003
X-MDID: 1562584036-TCMbxm8z7Fjd
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This is only at notice level but it was pointed out that no other driver
does this.
Also there is no action the user can take as it is really a property of
the server.

Signed-off-by: Martin Habets <mhabets@solarflare.com>
---
 drivers/net/ethernet/sfc/efx.c |    6 +-----
 1 file changed, 1 insertion(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/sfc/efx.c b/drivers/net/ethernet/sfc/efx.c
index 53b726bfe945..ab58b837df47 100644
--- a/drivers/net/ethernet/sfc/efx.c
+++ b/drivers/net/ethernet/sfc/efx.c
@@ -3614,11 +3614,7 @@ static int efx_pci_probe(struct pci_dev *pci_dev,
 		netif_warn(efx, probe, efx->net_dev,
 			   "failed to create MTDs (%d)\n", rc);
 
-	rc = pci_enable_pcie_error_reporting(pci_dev);
-	if (rc && rc != -EINVAL)
-		netif_notice(efx, probe, efx->net_dev,
-			     "PCIE error reporting unavailable (%d).\n",
-			     rc);
+	(void)pci_enable_pcie_error_reporting(pci_dev);
 
 	if (efx->type->udp_tnl_push_ports)
 		efx->type->udp_tnl_push_ports(efx);


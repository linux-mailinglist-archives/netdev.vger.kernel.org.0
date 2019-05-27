Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7F4922B557
	for <lists+netdev@lfdr.de>; Mon, 27 May 2019 14:32:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727287AbfE0Mc0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 May 2019 08:32:26 -0400
Received: from inva020.nxp.com ([92.121.34.13]:56968 "EHLO inva020.nxp.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726867AbfE0McR (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 27 May 2019 08:32:17 -0400
Received: from inva020.nxp.com (localhost [127.0.0.1])
        by inva020.eu-rdc02.nxp.com (Postfix) with ESMTP id 5C41F1A0BA4;
        Mon, 27 May 2019 14:32:15 +0200 (CEST)
Received: from inva024.eu-rdc02.nxp.com (inva024.eu-rdc02.nxp.com [134.27.226.22])
        by inva020.eu-rdc02.nxp.com (Postfix) with ESMTP id 4FBB91A01DA;
        Mon, 27 May 2019 14:32:15 +0200 (CEST)
Received: from fsr-fed2164-101.ea.freescale.net (fsr-fed2164-101.ea.freescale.net [10.171.82.91])
        by inva024.eu-rdc02.nxp.com (Postfix) with ESMTP id 0D1E82061C;
        Mon, 27 May 2019 14:32:15 +0200 (CEST)
From:   Madalin Bucur <madalin.bucur@nxp.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Madalin Bucur <madalin.bucur@nxp.com>
Subject: [PATCH net-next] fsl/fman: include IPSEC SPI in the Keygen extraction
Date:   Mon, 27 May 2019 15:32:12 +0300
Message-Id: <1558960332-12450-1-git-send-email-madalin.bucur@nxp.com>
X-Mailer: git-send-email 2.1.0
Reply-to: madalin.bucur@nxp.com
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The keygen extracted fields are used as input for the hash that
determines the incoming frames distribution. Adding IPSEC SPI so
different IPSEC flows can be distributed to different CPUs.

Signed-off-by: Madalin Bucur <madalin.bucur@nxp.com>
---
 drivers/net/ethernet/freescale/fman/fman_keygen.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/freescale/fman/fman_keygen.c b/drivers/net/ethernet/freescale/fman/fman_keygen.c
index f54da3c684d0..e1bdfed16134 100644
--- a/drivers/net/ethernet/freescale/fman/fman_keygen.c
+++ b/drivers/net/ethernet/freescale/fman/fman_keygen.c
@@ -144,7 +144,8 @@
 /* Hash Key extraction fields: */
 #define DEFAULT_HASH_KEY_EXTRACT_FIELDS		\
 	(KG_SCH_KN_IPSRC1 | KG_SCH_KN_IPDST1 | \
-	    KG_SCH_KN_L4PSRC | KG_SCH_KN_L4PDST)
+	 KG_SCH_KN_L4PSRC | KG_SCH_KN_L4PDST | \
+	 KG_SCH_KN_IPSEC_SPI)
 
 /* Default values to be used as hash key in case IPv4 or L4 (TCP, UDP)
  * don't exist in the frame
-- 
2.1.0


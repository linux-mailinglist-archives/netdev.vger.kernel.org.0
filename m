Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 299792C4B9E
	for <lists+netdev@lfdr.de>; Thu, 26 Nov 2020 00:26:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733183AbgKYXZ4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Nov 2020 18:25:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39142 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730073AbgKYXZy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 25 Nov 2020 18:25:54 -0500
Received: from mail-out.m-online.net (mail-out.m-online.net [IPv6:2001:a60:0:28:0:1:25:1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1A0FFC0613D4
        for <netdev@vger.kernel.org>; Wed, 25 Nov 2020 15:25:54 -0800 (PST)
Received: from frontend01.mail.m-online.net (unknown [192.168.8.182])
        by mail-out.m-online.net (Postfix) with ESMTP id 4ChH7b4jj5z1rwZq;
        Thu, 26 Nov 2020 00:25:45 +0100 (CET)
Received: from localhost (dynscan1.mnet-online.de [192.168.6.70])
        by mail.m-online.net (Postfix) with ESMTP id 4ChH7Y1vZ5z1vdfs;
        Thu, 26 Nov 2020 00:25:45 +0100 (CET)
X-Virus-Scanned: amavisd-new at mnet-online.de
Received: from mail.mnet-online.de ([192.168.8.182])
        by localhost (dynscan1.mail.m-online.net [192.168.6.70]) (amavisd-new, port 10024)
        with ESMTP id Bo2OedDOC47N; Thu, 26 Nov 2020 00:25:43 +0100 (CET)
X-Auth-Info: Pw9YCvMdnOzlHdaksvWkRNQhWgJkn2CYCowWoZ/VK/w=
Received: from localhost.localdomain (89-64-5-98.dynamic.chello.pl [89.64.5.98])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.mnet-online.de (Postfix) with ESMTPSA;
        Thu, 26 Nov 2020 00:25:43 +0100 (CET)
From:   Lukasz Majewski <lukma@denx.de>
To:     Fugang Duan <fugang.duan@nxp.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        Andrew Lunn <andrew@lunn.ch>,
        Fabio Estevam <festevam@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>
Cc:     NXP Linux Team <linux-imx@nxp.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Peng Fan <peng.fan@nxp.com>, stefan.agner@toradex.com,
        krzk@kernel.org, Shawn Guo <shawnguo@kernel.org>,
        Lukasz Majewski <lukma@denx.de>
Subject: [RFC 1/4] net: fec: Move some defines to ./drivers/net/ethernet/freescale/fec.h header
Date:   Thu, 26 Nov 2020 00:24:56 +0100
Message-Id: <20201125232459.378-2-lukma@denx.de>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20201125232459.378-1-lukma@denx.de>
References: <20201125232459.378-1-lukma@denx.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

After this change ECR (control register) defines are moved to fec.h, so
they can be reused by L2 switch code.

Signed-off-by: Lukasz Majewski <lukma@denx.de>
---
 drivers/net/ethernet/freescale/fec.h      | 3 +++
 drivers/net/ethernet/freescale/fec_main.c | 3 ---
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/freescale/fec.h b/drivers/net/ethernet/freescale/fec.h
index 832a2175636d..c555a421f647 100644
--- a/drivers/net/ethernet/freescale/fec.h
+++ b/drivers/net/ethernet/freescale/fec.h
@@ -189,6 +189,9 @@
 #define FEC_RXIC2		0xfff
 #endif /* CONFIG_M5272 */
 
+/* FEC ECR bits definition */
+#define FEC_ECR_MAGICEN		(1 << 2)
+#define FEC_ECR_SLEEP		(1 << 3)
 
 /*
  *	Define the buffer descriptor structure.
diff --git a/drivers/net/ethernet/freescale/fec_main.c b/drivers/net/ethernet/freescale/fec_main.c
index fb37816a74db..bd29c84fd89a 100644
--- a/drivers/net/ethernet/freescale/fec_main.c
+++ b/drivers/net/ethernet/freescale/fec_main.c
@@ -249,9 +249,6 @@ MODULE_PARM_DESC(macaddr, "FEC Ethernet MAC address");
 #define FEC_MMFR_RA(v)		((v & 0x1f) << 18)
 #define FEC_MMFR_TA		(2 << 16)
 #define FEC_MMFR_DATA(v)	(v & 0xffff)
-/* FEC ECR bits definition */
-#define FEC_ECR_MAGICEN		(1 << 2)
-#define FEC_ECR_SLEEP		(1 << 3)
 
 #define FEC_MII_TIMEOUT		30000 /* us */
 
-- 
2.20.1


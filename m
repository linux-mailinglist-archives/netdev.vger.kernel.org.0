Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C8D8C4817B4
	for <lists+netdev@lfdr.de>; Thu, 30 Dec 2021 00:27:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233203AbhL2X1a (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Dec 2021 18:27:30 -0500
Received: from mx3.wp.pl ([212.77.101.10]:56794 "EHLO mx3.wp.pl"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232929AbhL2X1a (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 29 Dec 2021 18:27:30 -0500
Received: (wp-smtpd smtp.wp.pl 16512 invoked from network); 30 Dec 2021 00:27:28 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=wp.pl; s=1024a;
          t=1640820448; bh=bSpcc4DGlwWldWE5Op3MSMSR4xx8f4jW6BJdMYrwrDw=;
          h=From:To:Subject;
          b=mPp0APnWzkwoST3AsNv0k2jPVJtVplwUpQ7Egbzxj+9FXUuSnP3R7i6ADWOZqVYZS
           sv1OgIcX5Noy25KzoEe/Ctl7BHz1A/dltLQ8s75oDuV2cW/YvIl2lm9VfCy63bjxJJ
           jmq6DrsukWFt1E3ZVdVI6BCEuJjJfjtQgIAqAnkQ=
Received: from riviera.nat.ds.pw.edu.pl (HELO LAPTOP-OLEK.lan) (olek2@wp.pl@[194.29.137.1])
          (envelope-sender <olek2@wp.pl>)
          by smtp.wp.pl (WP-SMTPD) with ECDHE-RSA-AES256-GCM-SHA384 encrypted SMTP
          for <davem@davemloft.net>; 30 Dec 2021 00:27:28 +0100
From:   Aleksander Jan Bajkowski <olek2@wp.pl>
To:     davem@davemloft.net, kuba@kernel.org, olek2@wp.pl, jgg@ziepe.ca,
        rdunlap@infradead.org, arnd@arndb.de, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH net-next] net: lantiq_etop: avoid precedence issues
Date:   Thu, 30 Dec 2021 00:27:25 +0100
Message-Id: <20211229232725.4048-1-olek2@wp.pl>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-WP-MailID: 061547b3d2861fe89a20995a6ec9f5ee
X-WP-AV: skaner antywirusowy Poczty Wirtualnej Polski
X-WP-SPAM: NO 0000000 [AQOE]                               
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add () around macro argument to avoid precedence issues

Signed-off-by: Aleksander Jan Bajkowski <olek2@wp.pl>
---
 drivers/net/ethernet/lantiq_etop.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/lantiq_etop.c b/drivers/net/ethernet/lantiq_etop.c
index 072391c494ce..db244c90a4cb 100644
--- a/drivers/net/ethernet/lantiq_etop.c
+++ b/drivers/net/ethernet/lantiq_etop.c
@@ -65,8 +65,8 @@
 /* use 2 static channels for TX/RX */
 #define LTQ_ETOP_TX_CHANNEL	1
 #define LTQ_ETOP_RX_CHANNEL	6
-#define IS_TX(x)		(x == LTQ_ETOP_TX_CHANNEL)
-#define IS_RX(x)		(x == LTQ_ETOP_RX_CHANNEL)
+#define IS_TX(x)		((x) == LTQ_ETOP_TX_CHANNEL)
+#define IS_RX(x)		((x) == LTQ_ETOP_RX_CHANNEL)
 
 #define ltq_etop_r32(x)		ltq_r32(ltq_etop_membase + (x))
 #define ltq_etop_w32(x, y)	ltq_w32(x, ltq_etop_membase + (y))
-- 
2.30.2


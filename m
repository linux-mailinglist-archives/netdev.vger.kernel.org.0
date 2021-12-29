Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 81F484817B0
	for <lists+netdev@lfdr.de>; Thu, 30 Dec 2021 00:23:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233160AbhL2XXE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Dec 2021 18:23:04 -0500
Received: from mx4.wp.pl ([212.77.101.12]:7838 "EHLO mx4.wp.pl"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232759AbhL2XXD (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 29 Dec 2021 18:23:03 -0500
Received: (wp-smtpd smtp.wp.pl 21038 invoked from network); 30 Dec 2021 00:22:58 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=wp.pl; s=1024a;
          t=1640820178; bh=Q32ltGVn3pzr7p53WNOk9fpqw+hMgzoLsv1gC0p+9mk=;
          h=From:To:Subject;
          b=Q5zVGme0C8WfTwxwOiP78I3cC83Dqp8xrMIC/tQIBcIsh9I74yLlndO4zMZs/DXUo
           J8yvlCjdUPmOugI0CvuXi2s/GsYyMsnwtqVRp5bp5qlPv6Hc86pEH94MIi1yHOzu9z
           08FHz1LypMt0M3i9tNUhOvtwYJ0OkfTfoNU9RtAY=
Received: from riviera.nat.ds.pw.edu.pl (HELO LAPTOP-OLEK.lan) (olek2@wp.pl@[194.29.137.1])
          (envelope-sender <olek2@wp.pl>)
          by smtp.wp.pl (WP-SMTPD) with ECDHE-RSA-AES256-GCM-SHA384 encrypted SMTP
          for <davem@davemloft.net>; 30 Dec 2021 00:22:58 +0100
From:   Aleksander Jan Bajkowski <olek2@wp.pl>
To:     davem@davemloft.net, kuba@kernel.org, olek2@wp.pl, jgg@ziepe.ca,
        rdunlap@infradead.org, arnd@arndb.de, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH net-next] net: lantiq_etop: replace strlcpy with strscpy
Date:   Thu, 30 Dec 2021 00:22:57 +0100
Message-Id: <20211229232257.3525-1-olek2@wp.pl>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-WP-MailID: 390f6c7053da1c064b08a33d6f4567c2
X-WP-AV: skaner antywirusowy Poczty Wirtualnej Polski
X-WP-SPAM: NO 0000000 [YQNk]                               
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

strlcpy is marked as deprecated in Documentation/process/deprecated.rst,
and there is no functional difference when the caller expects truncation
(when not checking the return value). strscpy is relatively better as it
also avoids scanning the whole source string.

This silences the related checkpatch warnings from:
commit 5dbdb2d87c29 ("checkpatch: prefer strscpy to strlcpy")

Signed-off-by: Aleksander Jan Bajkowski <olek2@wp.pl>
---
 drivers/net/ethernet/lantiq_etop.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/lantiq_etop.c b/drivers/net/ethernet/lantiq_etop.c
index 072391c494ce..d8e100535999 100644
--- a/drivers/net/ethernet/lantiq_etop.c
+++ b/drivers/net/ethernet/lantiq_etop.c
@@ -305,9 +305,9 @@ ltq_etop_hw_init(struct net_device *dev)
 static void
 ltq_etop_get_drvinfo(struct net_device *dev, struct ethtool_drvinfo *info)
 {
-	strlcpy(info->driver, "Lantiq ETOP", sizeof(info->driver));
-	strlcpy(info->bus_info, "internal", sizeof(info->bus_info));
-	strlcpy(info->version, DRV_VERSION, sizeof(info->version));
+	strscpy(info->driver, "Lantiq ETOP", sizeof(info->driver));
+	strscpy(info->bus_info, "internal", sizeof(info->bus_info));
+	strscpy(info->version, DRV_VERSION, sizeof(info->version));
 }
 
 static const struct ethtool_ops ltq_etop_ethtool_ops = {
-- 
2.30.2


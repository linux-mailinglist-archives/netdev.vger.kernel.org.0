Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8BD6B1CE6F0
	for <lists+netdev@lfdr.de>; Mon, 11 May 2020 23:05:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732549AbgEKVE7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 May 2020 17:04:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44946 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1731815AbgEKVE5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 May 2020 17:04:57 -0400
Received: from mail-pl1-x62b.google.com (mail-pl1-x62b.google.com [IPv6:2607:f8b0:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C8BFDC061A0C
        for <netdev@vger.kernel.org>; Mon, 11 May 2020 14:04:56 -0700 (PDT)
Received: by mail-pl1-x62b.google.com with SMTP id u10so4438450pls.8
        for <netdev@vger.kernel.org>; Mon, 11 May 2020 14:04:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=pensando.io; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=LIx/pfKAPWPAXNT2F7f8FkFt9UnSm350N911MwRS/vU=;
        b=jjDTZlI9PEd7TZI/458OV+V3+oDrkZl1jsQHmKhpFCGCYyxBylygteqaqa+ZZKoJb+
         /0H1Nn0KZjW4Bz4W+LiGbchJzGWpimw6XEmvdI0/QTH8w3mCpCWAuDu/EGxlEvBuojXa
         uK2WnHidq9U+KDOsNa+F+FS6uY/e6LstHQMdccMTY0wnUj3N30U1lNl819HGqfsX87F5
         L2D/0C/3ly2mJWrsNxycCtoiSte5bu73DwNW2dd7cyjWWc7j7R8uOrP4dqPBYSocAzSF
         oRNbkr7UqPgMAupRncyiSS2VgIIOEZjHXn2Wo2pI69wX0IiWDik/HJe5n47rnuF/ckjG
         WwDw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=LIx/pfKAPWPAXNT2F7f8FkFt9UnSm350N911MwRS/vU=;
        b=cCBSi8PKEDBWkTVbySwo5qgBTd1xiTrnr1BXovnGk5HK4O6XNvxDmNZzukxXXwvrZI
         u6zqgmIR2h3JZ+RGavumhSLrVJH0BITvVwF1fBsvMDRoewcjF8G+Mlmb2F0FBaIIVQnr
         xvn7ryGhWvCpLBXvHLkHQX6eQADt3pM2srZBmsOFzVE8dFIhYfwkkfh9Gh6IiPuuaQ6H
         KOUAAqVKAE9PbA2ltzS2PPIGXPNITVESnA+I8DfRyXEJKw35VV1NQpzOUHOY4rlVLrqy
         nDchYAPRMQjYlUgiNxFDzu2TgoTZFzWuKcTyCtkhPY0beOvl7Zz36XbunQpG7P1JcTRv
         2nIw==
X-Gm-Message-State: AGi0Publux7mTpkawkGXrb5ddG4EsP6Y8lcG8nJnuqmN1ERy6gN+2N2y
        5H3C5Fu111MitYhvfpbskJoNE3w+n1Y=
X-Google-Smtp-Source: APiQypLTFs9d9ssNzISu5XMcTOu32ZXNy2K3ruagZ9RJCrvsnWgn8OZRCqrSKmyA+E8avyf8Ezxw9Q==
X-Received: by 2002:a17:90a:276a:: with SMTP id o97mr24534458pje.194.1589231093348;
        Mon, 11 May 2020 14:04:53 -0700 (PDT)
Received: from driver-dev1.pensando.io ([12.226.153.42])
        by smtp.gmail.com with ESMTPSA id c2sm6325048pgj.93.2020.05.11.14.04.52
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 11 May 2020 14:04:52 -0700 (PDT)
From:   Shannon Nelson <snelson@pensando.io>
To:     netdev@vger.kernel.org, davem@davemloft.net
Cc:     Shannon Nelson <snelson@pensando.io>
Subject: [PATCH net 1/2] ionic: leave netdev mac alone after fw-upgrade
Date:   Mon, 11 May 2020 14:04:44 -0700
Message-Id: <20200511210445.2144-2-snelson@pensando.io>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200511210445.2144-1-snelson@pensando.io>
References: <20200511210445.2144-1-snelson@pensando.io>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When running in a bond setup, or some other potential
configurations, the netdev mac may have been changed from
the default device mac.  Since the userland doesn't know
about the changes going on under the covers in a fw-upgrade
it doesn't know the re-push the mac filter.  The driver
needs to leave the netdev mac filter alone when rebuilding
after the fw-upgrade.

Fixes: c672412f6172 ("ionic: remove lifs on fw reset")
Signed-off-by: Shannon Nelson <snelson@pensando.io>
---
 .../net/ethernet/pensando/ionic/ionic_lif.c    | 18 +++++++++++-------
 1 file changed, 11 insertions(+), 7 deletions(-)

diff --git a/drivers/net/ethernet/pensando/ionic/ionic_lif.c b/drivers/net/ethernet/pensando/ionic/ionic_lif.c
index d5293bfded29..f8c626444da0 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic_lif.c
+++ b/drivers/net/ethernet/pensando/ionic/ionic_lif.c
@@ -2348,7 +2348,17 @@ static int ionic_station_set(struct ionic_lif *lif)
 	if (is_zero_ether_addr(ctx.comp.lif_getattr.mac))
 		return 0;
 
-	if (!ether_addr_equal(ctx.comp.lif_getattr.mac, netdev->dev_addr)) {
+	if (!is_zero_ether_addr(netdev->dev_addr)) {
+		/* If the netdev mac is non-zero and doesn't match the default
+		 * device address, it was set by something earlier and we're
+		 * likely here again after a fw-upgrade reset.  We need to be
+		 * sure the netdev mac is in our filter list.
+		 */
+		if (!ether_addr_equal(ctx.comp.lif_getattr.mac,
+				      netdev->dev_addr))
+			ionic_lif_addr(lif, netdev->dev_addr, true);
+	} else {
+		/* Update the netdev mac with the device's mac */
 		memcpy(addr.sa_data, ctx.comp.lif_getattr.mac, netdev->addr_len);
 		addr.sa_family = AF_INET;
 		err = eth_prepare_mac_addr_change(netdev, &addr);
@@ -2358,12 +2368,6 @@ static int ionic_station_set(struct ionic_lif *lif)
 			return 0;
 		}
 
-		if (!is_zero_ether_addr(netdev->dev_addr)) {
-			netdev_dbg(lif->netdev, "deleting station MAC addr %pM\n",
-				   netdev->dev_addr);
-			ionic_lif_addr(lif, netdev->dev_addr, false);
-		}
-
 		eth_commit_mac_addr_change(netdev, &addr);
 	}
 
-- 
2.17.1


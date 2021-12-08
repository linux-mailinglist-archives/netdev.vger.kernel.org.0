Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E99E246CE48
	for <lists+netdev@lfdr.de>; Wed,  8 Dec 2021 08:20:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244505AbhLHHY0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Dec 2021 02:24:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54860 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244514AbhLHHYW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Dec 2021 02:24:22 -0500
Received: from mail-ed1-x534.google.com (mail-ed1-x534.google.com [IPv6:2a00:1450:4864:20::534])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 92D92C0617A1
        for <netdev@vger.kernel.org>; Tue,  7 Dec 2021 23:20:50 -0800 (PST)
Received: by mail-ed1-x534.google.com with SMTP id w1so5172080edc.6
        for <netdev@vger.kernel.org>; Tue, 07 Dec 2021 23:20:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=a0xkDw0dcv6id1j2wFN3KzJ6+k6a8lx4Bs8T1tPQCKU=;
        b=cBNxoN2+BKp1rFC0aC8cv5kLVodNkISgN/yofI4xuAAkuac8C4jgKOglOf10Y+PAsw
         EpYXITwB+eVWnssobfT/c0q+lfle+NH+j7fZtsc/2eL8kGiHztbJ2ZlDwHjRSVA6vd00
         oh29QMA6hTznuO+o3hEIvgIJ86g03xB2rXcquiPZBm9OTztFzS6aYTQiUa+8PXAZPkOI
         FSuQ3iKlpi/IR6OLxQfIb09rWYPwCZIACCdwfwkBQrqgaRu+zNbP0bfUXpfCFT7tuSnu
         b9fDIVGo27uzg8UXc7z6F/rul9BOt9KykB/vrawsKdxJdg2xxDselzci0hSjAAFoRpuG
         2H6g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=a0xkDw0dcv6id1j2wFN3KzJ6+k6a8lx4Bs8T1tPQCKU=;
        b=MvNUUQKBLW9A8VTE8TlwyNWKU5vgipAPsUqyFtVQTjpvABbZKylup6Zf2Ted+lMXlU
         F3zlJ4P2FF0TMGP9fuPt4jRfXlJXAOlkbUXo96GjqtJBdAt7ufw2qA4c1Xrv164iHOlh
         mKxi6g8jQsEXckYwgsMY4982Cf888ZxkNGXvdrDqmIBvaJz0pphbqUqHsBlHHgL46owa
         d4ETqFG03DRCIcjGL0O8y8qXonv5j1L6olWIINpR63+ETwY3Xp4nZwgj5jhYohMr2pwf
         KnwnA/vpMa8EjXdjj5+X1s5V96sm1kZoR20CfWGWILpXdJ26m84H3RYACfgJg2/NOnCy
         Splw==
X-Gm-Message-State: AOAM533Mo7olBXtgIT6bMEiubl2TKhzKvIoNxO4z2cQzc0MGYLXLEGTi
        ZYIqvnlCo/iVKQ7+AuOioxFBhBKl9wwC9Q==
X-Google-Smtp-Source: ABdhPJwZzBlaldhKP6DS6zlA+Ax1zCHOxJbjKQsUR09ZiL9DXsZFCp0+/8yhQvnRI9CQctQPMD9dig==
X-Received: by 2002:a05:6402:2744:: with SMTP id z4mr17166380edd.310.1638948049093;
        Tue, 07 Dec 2021 23:20:49 -0800 (PST)
Received: from localhost ([81.17.18.62])
        by smtp.gmail.com with ESMTPSA id g15sm974193ejt.10.2021.12.07.23.20.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 07 Dec 2021 23:20:48 -0800 (PST)
From:   =?UTF-8?q?J=CE=B5an=20Sacren?= <sakiwit@gmail.com>
To:     mathew.j.martineau@linux.intel.com, matthieu.baerts@tessares.net,
        davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        mptcp@lists.linux.dev
Subject: [PATCH net-next] net: mptcp: clean up harmless false expressions
Date:   Wed,  8 Dec 2021 00:20:26 -0700
Message-Id: <20211208024732.142541-6-sakiwit@gmail.com>
X-Mailer: git-send-email 2.32.0
X-Mailer: git-send-email 2.32.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jean Sacren <sakiwit@gmail.com>

entry->addr.id is u8 with a range from 0 to 255 and MAX_ADDR_ID is 255.
We should drop both false expressions of (entry->addr.id > MAX_ADDR_ID).

We should also remove the obsolete parentheses in the first if branch.

Signed-off-by: Jean Sacren <sakiwit@gmail.com>
---
 net/mptcp/pm_netlink.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/net/mptcp/pm_netlink.c b/net/mptcp/pm_netlink.c
index 4ff8d55cbe82..233d4002c634 100644
--- a/net/mptcp/pm_netlink.c
+++ b/net/mptcp/pm_netlink.c
@@ -822,14 +822,13 @@ static int mptcp_pm_nl_append_new_local_addr(struct pm_nl_pernet *pernet,
 		entry->addr.id = find_next_zero_bit(pernet->id_bitmap,
 						    MAX_ADDR_ID + 1,
 						    pernet->next_id);
-		if ((!entry->addr.id || entry->addr.id > MAX_ADDR_ID) &&
-		    pernet->next_id != 1) {
+		if (!entry->addr.id && pernet->next_id != 1) {
 			pernet->next_id = 1;
 			goto find_next;
 		}
 	}
 
-	if (!entry->addr.id || entry->addr.id > MAX_ADDR_ID)
+	if (!entry->addr.id)
 		goto out;
 
 	__set_bit(entry->addr.id, pernet->id_bitmap);

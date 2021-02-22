Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6C0D9320FAD
	for <lists+netdev@lfdr.de>; Mon, 22 Feb 2021 04:18:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229902AbhBVDQT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 21 Feb 2021 22:16:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56236 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229863AbhBVDQP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 21 Feb 2021 22:16:15 -0500
Received: from mail-pl1-x636.google.com (mail-pl1-x636.google.com [IPv6:2607:f8b0:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2AB8EC061574;
        Sun, 21 Feb 2021 19:15:35 -0800 (PST)
Received: by mail-pl1-x636.google.com with SMTP id z7so6862302plk.7;
        Sun, 21 Feb 2021 19:15:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=5NYuJtu5WA02pTylBdzel53IgVo86VYzWK5glcYVXg8=;
        b=uXHoDzvfbSko0H3SLOz+d6YU+XnkP4S6GSQ9IhUd4NjT5xhKuz8De3i6Bnrs9zHyAK
         3cl8KTQd+rQBlxcJcnvOiHl5bpLjwfVi/ERlkLB86g1pXqle6fvqijqoRZi/jZ2i+lWI
         yzeWeWQhqX8H5gGiQNXZfmDKr/uzBnEaPPHj22VTimwcL7FPLsQZ5sdWN//8u9WZBV7c
         M3129NU1MrAoDdlmrgicLF6v04BzbcYHnU7PkiizFjHG6yXP5uW8BznM5yyONMvmkQuj
         bidF2/D7zQr8zZK3JKacwgAuYcSaOWoGEmY1itiod6Vee7bDNGiDR7DGw9iLOwG11L+Z
         QbTQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=5NYuJtu5WA02pTylBdzel53IgVo86VYzWK5glcYVXg8=;
        b=AGyvmwRFdYzYsPjwjJENkmAiHEjIdDedC2FvaSkMSm/x61PZjMoO1mXUxJrDtzhUrm
         NuzJiN5IgIY4Yx9dRDqzbTvJcnfp13QSUJM86zzu7F4FBiLkNpWdzoPnjlHQv5UOnJyW
         ilSl9926ObRwuEJ9dKo1Blebs72oY06ShIqavwL0SWl6C4hZozg6Sh1fifh+T+lE9Zfo
         acHWhbKITxEBqGx1zn9lNjVmZtQxNdqF8sr8i1j+SEX7y8ELgMD8QFjFBn/ms0m9zBCI
         uu8toBeuefBPFOkcjndzWddOlxgJMcUKiJzKvAjYKMQbuea9suO9GybqdAUFGVwtegPA
         fZQw==
X-Gm-Message-State: AOAM532FfTtfoitvXS9vzLnTEt3ghpScR1p239w7J8YWqXKwu4nurcfY
        PLDwFyU5pmNBE74Lp+vZn6o=
X-Google-Smtp-Source: ABdhPJzXoeYPg9h8uSS7umKJqXmuPhi2Sw1G+6PA047S9J5MkD5L5Cf43J5DS2/bQ0pdDgLWORzdqg==
X-Received: by 2002:a17:90b:3892:: with SMTP id mu18mr21220607pjb.143.1613963734758;
        Sun, 21 Feb 2021 19:15:34 -0800 (PST)
Received: from localhost.localdomain ([122.10.161.207])
        by smtp.gmail.com with ESMTPSA id v126sm16484528pfv.163.2021.02.21.19.15.32
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 21 Feb 2021 19:15:34 -0800 (PST)
From:   Yejune Deng <yejune.deng@gmail.com>
To:     davem@davemloft.net, yoshfuji@linux-ipv6.org, dsahern@kernel.org,
        kuba@kernel.org
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        yejune.deng@gmail.com, kernel test robot <oliver.sang@intel.com>
Subject: [PATCH] arp: Remove the arp_hh_ops structure
Date:   Mon, 22 Feb 2021 11:15:26 +0800
Message-Id: <20210222031526.3834-1-yejune.deng@gmail.com>
X-Mailer: git-send-email 2.29.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The arp_hh_ops structure is similar to the arp_generic_ops structure.
but the latter is more general,so remove the arp_hh_ops structure.

Fix when took out the neigh->ops assignment:
8.973653] #PF: supervisor read access in kernel mode
[    8.975027] #PF: error_code(0x0000) - not-present page
[    8.976310] PGD 0 P4D 0
[    8.977036] Oops: 0000 [#1] SMP PTI
[    8.977973] CPU: 1 PID: 210 Comm: sd-resolve Not tainted 5.11.0-rc7-02046-g4591591ab715 #1
[    8.979998] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.12.0-1 04/01/2014
[    8.981996] RIP: 0010:neigh_probe (kbuild/src/consumer/net/core/neighbour.c:1009)

Reported-by: kernel test robot <oliver.sang@intel.com>
Signed-off-by: Yejune Deng <yejune.deng@gmail.com>
---
 net/ipv4/arp.c | 15 ++-------------
 1 file changed, 2 insertions(+), 13 deletions(-)

diff --git a/net/ipv4/arp.c b/net/ipv4/arp.c
index 922dd73e5740..9ee59c2e419a 100644
--- a/net/ipv4/arp.c
+++ b/net/ipv4/arp.c
@@ -135,14 +135,6 @@ static const struct neigh_ops arp_generic_ops = {
 	.connected_output =	neigh_connected_output,
 };
 
-static const struct neigh_ops arp_hh_ops = {
-	.family =		AF_INET,
-	.solicit =		arp_solicit,
-	.error_report =		arp_error_report,
-	.output =		neigh_resolve_output,
-	.connected_output =	neigh_resolve_output,
-};
-
 static const struct neigh_ops arp_direct_ops = {
 	.family =		AF_INET,
 	.output =		neigh_direct_output,
@@ -277,12 +269,9 @@ static int arp_constructor(struct neighbour *neigh)
 			memcpy(neigh->ha, dev->broadcast, dev->addr_len);
 		}
 
-		if (dev->header_ops->cache)
-			neigh->ops = &arp_hh_ops;
-		else
-			neigh->ops = &arp_generic_ops;
+		neigh->ops = &arp_generic_ops;
 
-		if (neigh->nud_state & NUD_VALID)
+		if (!dev->header_ops->cache && (neigh->nud_state & NUD_VALID))
 			neigh->output = neigh->ops->connected_output;
 		else
 			neigh->output = neigh->ops->output;
-- 
2.29.0


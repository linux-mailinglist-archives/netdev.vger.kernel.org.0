Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E7B0B3AC85B
	for <lists+netdev@lfdr.de>; Fri, 18 Jun 2021 12:03:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233454AbhFRKFL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Jun 2021 06:05:11 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:50180 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233259AbhFRKEM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Jun 2021 06:04:12 -0400
Received: from 1.general.cking.uk.vpn ([10.172.193.212] helo=localhost)
        by youngberry.canonical.com with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
        (Exim 4.93)
        (envelope-from <colin.king@canonical.com>)
        id 1luBJz-0007K2-Re; Fri, 18 Jun 2021 10:01:55 +0000
From:   Colin King <colin.king@canonical.com>
To:     Roopa Prabhu <roopa@nvidia.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        bridge@lists.linux-foundation.org, netdev@vger.kernel.org
Cc:     kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] net: bridge: remove redundant continue statement
Date:   Fri, 18 Jun 2021 11:01:55 +0100
Message-Id: <20210618100155.101386-1-colin.king@canonical.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Colin Ian King <colin.king@canonical.com>

The continue statement at the end of a for-loop has no effect,
invert the if expression and remove the continue.

Addresses-Coverity: ("Continue has no effect")
Signed-off-by: Colin Ian King <colin.king@canonical.com>
---
 net/bridge/br_vlan.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/net/bridge/br_vlan.c b/net/bridge/br_vlan.c
index da3256a3eed0..8789a57af543 100644
--- a/net/bridge/br_vlan.c
+++ b/net/bridge/br_vlan.c
@@ -113,9 +113,7 @@ static void __vlan_add_list(struct net_bridge_vlan *v)
 	headp = &vg->vlan_list;
 	list_for_each_prev(hpos, headp) {
 		vent = list_entry(hpos, struct net_bridge_vlan, vlist);
-		if (v->vid < vent->vid)
-			continue;
-		else
+		if (v->vid >= vent->vid)
 			break;
 	}
 	list_add_rcu(&v->vlist, hpos);
-- 
2.31.1


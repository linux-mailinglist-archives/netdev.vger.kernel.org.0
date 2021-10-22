Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 25F5043808F
	for <lists+netdev@lfdr.de>; Sat, 23 Oct 2021 01:21:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231877AbhJVXX2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Oct 2021 19:23:28 -0400
Received: from mail.kernel.org ([198.145.29.99]:40888 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231569AbhJVXX1 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 22 Oct 2021 19:23:27 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 708976103D;
        Fri, 22 Oct 2021 23:21:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1634944869;
        bh=GjePRYsuxbkMK4AxbVDxBnBZ2/Dfo3Ul8l0t+bMtyLs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=pK5mW+RKwDNGxhnPsDKMpCN0zLmXmgl073THBCTPPWjBj4HRBBqgX5TIojtvZvhEp
         OWZ2ktHdmBrMksfH1ZVBypXrIq1u9rZnKyTmQRJHKdXsjcUv2CD0Ek6/MWL9xaIki6
         LAhIERejzux7lv2L/0S4is83027PoFFpXUhev0k4vnsoKe2PNRlm/NSvSuzXgOxMNn
         9GtxIDuG5dHo9SwAs8EYYSgpiLBYF8zITakxGqCnSCjqakL1G795Cc7IFW8+XflVMg
         KDqtVu8LWaztwuwtQhTRkqMfIL5kCZAuop5RdW9kuvKmvupG2RsTgVN9IIK4aHEB16
         zJzaIlzMIBp8Q==
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net-next v2 2/8] net: rtnetlink: use __dev_addr_set()
Date:   Fri, 22 Oct 2021 16:20:57 -0700
Message-Id: <20211022232103.2715312-3-kuba@kernel.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211022232103.2715312-1-kuba@kernel.org>
References: <20211022232103.2715312-1-kuba@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Get it ready for constant netdev->dev_addr.

Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
 net/core/rtnetlink.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/core/rtnetlink.c b/net/core/rtnetlink.c
index 79477dcae7c2..2af8aeeadadf 100644
--- a/net/core/rtnetlink.c
+++ b/net/core/rtnetlink.c
@@ -3204,8 +3204,8 @@ struct net_device *rtnl_create_link(struct net *net, const char *ifname,
 		dev->mtu = mtu;
 	}
 	if (tb[IFLA_ADDRESS]) {
-		memcpy(dev->dev_addr, nla_data(tb[IFLA_ADDRESS]),
-				nla_len(tb[IFLA_ADDRESS]));
+		__dev_addr_set(dev, nla_data(tb[IFLA_ADDRESS]),
+			       nla_len(tb[IFLA_ADDRESS]));
 		dev->addr_assign_type = NET_ADDR_SET;
 	}
 	if (tb[IFLA_BROADCAST])
-- 
2.31.1


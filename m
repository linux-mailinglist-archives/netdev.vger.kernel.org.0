Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6169C3CD510
	for <lists+netdev@lfdr.de>; Mon, 19 Jul 2021 14:47:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236916AbhGSMGs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Jul 2021 08:06:48 -0400
Received: from out0.migadu.com ([94.23.1.103]:29923 "EHLO out0.migadu.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236571AbhGSMGs (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 19 Jul 2021 08:06:48 -0400
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1626698846;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=x8PnJ8W3fFhsOfoyFAM+siyJPmoRbiK7B+kykZqSh/Y=;
        b=uPxCRRiW6ReoAlGTfkz+urcDC/WWa12swKTvIkWP63C6hHJGg4VD97ZmsNEu6Cfv1WZQbl
        F6hR5nAMiZ90iYV4TxxI8EGOcyrkr94boqqnAJ+W63EBMmClqpYf5lAEwbj3I889RHo7CY
        sQsf3RVS8zGMAdzgjQ9mY1+0ybZNXW4=
From:   Yajun Deng <yajun.deng@linux.dev>
To:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-decnet-user@lists.sourceforge.net
Cc:     Yajun Deng <yajun.deng@linux.dev>
Subject: [PATCH 3/4] vxlan: Adjustment parameters in rtnl_notify()
Date:   Mon, 19 Jul 2021 20:47:12 +0800
Message-Id: <20210719124712.9009-1-yajun.deng@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Migadu-Auth-User: yajun.deng@linux.dev
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The fifth parameter alread modify from 'struct nlmsghdr *nlh' to
'int report', just adjustment it.

Signed-off-by: Yajun Deng <yajun.deng@linux.dev>
---
 drivers/net/vxlan.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/vxlan.c b/drivers/net/vxlan.c
index 5a8df5a195cb..dbe0b531868a 100644
--- a/drivers/net/vxlan.c
+++ b/drivers/net/vxlan.c
@@ -381,7 +381,7 @@ static void __vxlan_fdb_notify(struct vxlan_dev *vxlan, struct vxlan_fdb *fdb,
 		goto errout;
 	}
 
-	rtnl_notify(skb, net, 0, RTNLGRP_NEIGH, NULL, GFP_ATOMIC);
+	rtnl_notify(skb, net, 0, RTNLGRP_NEIGH, 0, GFP_ATOMIC);
 	return;
 errout:
 	if (err < 0)
-- 
2.32.0


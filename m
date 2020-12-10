Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E4DB12D55F0
	for <lists+netdev@lfdr.de>; Thu, 10 Dec 2020 09:59:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728886AbgLJI6V (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Dec 2020 03:58:21 -0500
Received: from s2.neomailbox.net ([5.148.176.60]:23995 "EHLO s2.neomailbox.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730417AbgLJI5x (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 10 Dec 2020 03:57:53 -0500
From:   Antonio Quartulli <a@unstable.cc>
To:     Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     Antonio Quartulli <a@unstable.cc>
Subject: [PATCH] vxlan: avoid double unlikely() notation when using IS_ERR()
Date:   Thu, 10 Dec 2020 09:55:49 +0100
Message-Id: <20201210085549.22846-1-a@unstable.cc>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The definition of IS_ERR() already applies the unlikely() notation
when checking the error status of the passed pointer. For this
reason there is no need to have the same notation outside of
IS_ERR() itself.

Clean up code by removing redundant notation.

Signed-off-by: Antonio Quartulli <a@unstable.cc>
---
 drivers/net/vxlan.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/vxlan.c b/drivers/net/vxlan.c
index e1e44d68ac4b..a8ad710629e6 100644
--- a/drivers/net/vxlan.c
+++ b/drivers/net/vxlan.c
@@ -2477,7 +2477,7 @@ static struct dst_entry *vxlan6_get_route(struct vxlan_dev *vxlan,
 
 	ndst = ipv6_stub->ipv6_dst_lookup_flow(vxlan->net, sock6->sock->sk,
 					       &fl6, NULL);
-	if (unlikely(IS_ERR(ndst))) {
+	if (IS_ERR(ndst)) {
 		netdev_dbg(dev, "no route to %pI6\n", daddr);
 		return ERR_PTR(-ENETUNREACH);
 	}
-- 
2.29.2


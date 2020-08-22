Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 376A124E499
	for <lists+netdev@lfdr.de>; Sat, 22 Aug 2020 04:04:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726435AbgHVCEq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Aug 2020 22:04:46 -0400
Received: from foss.arm.com ([217.140.110.172]:41752 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725935AbgHVCEq (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 21 Aug 2020 22:04:46 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 57F3B31B;
        Fri, 21 Aug 2020 19:04:45 -0700 (PDT)
Received: from net-arm-thunderx2-02.shanghai.arm.com (net-arm-thunderx2-02.shanghai.arm.com [10.169.210.119])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id 4119D3F66B;
        Fri, 21 Aug 2020 19:04:43 -0700 (PDT)
From:   Jianlin Lv <Jianlin.Lv@arm.com>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, Song.Zhu@arm.com,
        Jianlin.Lv@arm.com, linux-kernel@vger.kernel.org
Subject: [PATCH net-next] net: Remove unnecessary intermediate variables
Date:   Sat, 22 Aug 2020 10:04:31 +0800
Message-Id: <20200822020431.125732-1-Jianlin.Lv@arm.com>
X-Mailer: git-send-email 2.17.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

It is not necessary to use src/dst as an intermediate variable for
assignment operation; Delete src/dst intermediate variables to avoid
unnecessary variable declarations.

Signed-off-by: Jianlin Lv <Jianlin.Lv@arm.com>
---
 drivers/net/vxlan.c | 16 ++++------------
 1 file changed, 4 insertions(+), 12 deletions(-)

diff --git a/drivers/net/vxlan.c b/drivers/net/vxlan.c
index b9fefe27e3e8..c00ca01ebe76 100644
--- a/drivers/net/vxlan.c
+++ b/drivers/net/vxlan.c
@@ -2728,12 +2728,8 @@ static void vxlan_xmit_one(struct sk_buff *skb, struct net_device *dev,
 			goto tx_error;
 		} else if (err) {
 			if (info) {
-				struct in_addr src, dst;
-
-				src = remote_ip.sin.sin_addr;
-				dst = local_ip.sin.sin_addr;
-				info->key.u.ipv4.src = src.s_addr;
-				info->key.u.ipv4.dst = dst.s_addr;
+				info->key.u.ipv4.src = remote_ip.sin.sin_addr.s_addr;
+				info->key.u.ipv4.dst = local_ip.sin.sin_addr.s_addr;
 			}
 			vxlan_encap_bypass(skb, vxlan, vxlan, vni, false);
 			dst_release(ndst);
@@ -2784,12 +2780,8 @@ static void vxlan_xmit_one(struct sk_buff *skb, struct net_device *dev,
 			goto tx_error;
 		} else if (err) {
 			if (info) {
-				struct in6_addr src, dst;
-
-				src = remote_ip.sin6.sin6_addr;
-				dst = local_ip.sin6.sin6_addr;
-				info->key.u.ipv6.src = src;
-				info->key.u.ipv6.dst = dst;
+				info->key.u.ipv6.src = remote_ip.sin6.sin6_addr;
+				info->key.u.ipv6.dst = local_ip.sin6.sin6_addr;
 			}
 
 			vxlan_encap_bypass(skb, vxlan, vxlan, vni, false);
-- 
2.17.1


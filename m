Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5C9E19545C
	for <lists+netdev@lfdr.de>; Tue, 20 Aug 2019 04:26:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729096AbfHTCZq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Aug 2019 22:25:46 -0400
Received: from mx134-tc.baidu.com ([61.135.168.134]:18389 "EHLO
        tc-sys-mailedm01.tc.baidu.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728647AbfHTCZq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 19 Aug 2019 22:25:46 -0400
Received: from localhost (cp01-cos-dev01.cp01.baidu.com [10.92.119.46])
        by tc-sys-mailedm01.tc.baidu.com (Postfix) with ESMTP id 070082040041
        for <netdev@vger.kernel.org>; Tue, 20 Aug 2019 10:25:33 +0800 (CST)
From:   Li RongQing <lirongqing@baidu.com>
To:     netdev@vger.kernel.org
Subject: [PATCH] net: Fix __ip_mc_inc_group argument 3 input
Date:   Tue, 20 Aug 2019 10:25:33 +0800
Message-Id: <1566267933-30434-1-git-send-email-lirongqing@baidu.com>
X-Mailer: git-send-email 1.7.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

It expects gfp_t, but got unsigned int mode

Fixes: 6e2059b53f98 ("ipv4/igmp: init group mode as INCLUDE when join source group")
Signed-off-by: Li RongQing <lirongqing@baidu.com>
Signed-off-by: Zhang Yu <zhangyu31@baidu.com>
---
 net/ipv4/igmp.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/ipv4/igmp.c b/net/ipv4/igmp.c
index 180f6896b98b..b8352d716253 100644
--- a/net/ipv4/igmp.c
+++ b/net/ipv4/igmp.c
@@ -1475,7 +1475,7 @@ EXPORT_SYMBOL(__ip_mc_inc_group);
 
 void ip_mc_inc_group(struct in_device *in_dev, __be32 addr)
 {
-	__ip_mc_inc_group(in_dev, addr, MCAST_EXCLUDE);
+	__ip_mc_inc_group(in_dev, addr, GFP_KERNEL);
 }
 EXPORT_SYMBOL(ip_mc_inc_group);
 
@@ -2197,7 +2197,7 @@ static int __ip_mc_join_group(struct sock *sk, struct ip_mreqn *imr,
 	iml->sflist = NULL;
 	iml->sfmode = mode;
 	rcu_assign_pointer(inet->mc_list, iml);
-	__ip_mc_inc_group(in_dev, addr, mode);
+	__ip_mc_inc_group(in_dev, addr, GFP_KERNEL);
 	err = 0;
 done:
 	return err;
-- 
2.16.2


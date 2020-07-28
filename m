Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D78202310C1
	for <lists+netdev@lfdr.de>; Tue, 28 Jul 2020 19:20:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731970AbgG1RUr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Jul 2020 13:20:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34036 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731962AbgG1RUp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Jul 2020 13:20:45 -0400
Received: from mail.katalix.com (mail.katalix.com [IPv6:2a05:d01c:827:b342:16d0:7237:f32a:8096])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 2F756C0619D2
        for <netdev@vger.kernel.org>; Tue, 28 Jul 2020 10:20:45 -0700 (PDT)
Received: from localhost.localdomain (82-69-49-219.dsl.in-addr.zen.co.uk [82.69.49.219])
        (Authenticated sender: tom)
        by mail.katalix.com (Postfix) with ESMTPSA id 833378AD62;
        Tue, 28 Jul 2020 18:20:44 +0100 (BST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=katalix.com; s=mail;
        t=1595956844; bh=efmILNjIlTcEGj3WbS0+Ric9n4hVSMkysmnCCipK9lY=;
        h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:From;
        z=From:=20Tom=20Parkin=20<tparkin@katalix.com>|To:=20netdev@vger.ke
         rnel.org|Cc:=20jchapman@katalix.com,=0D=0A=09Tom=20Parkin=20<tpark
         in@katalix.com>|Subject:=20[PATCH=205/6]=20l2tp:=20tweak=20exports
         =20for=20l2tp_recv_common=20and=20l2tp_ioctl|Date:=20Tue,=2028=20J
         ul=202020=2018:20:32=20+0100|Message-Id:=20<20200728172033.19532-6
         -tparkin@katalix.com>|In-Reply-To:=20<20200728172033.19532-1-tpark
         in@katalix.com>|References:=20<20200728172033.19532-1-tparkin@kata
         lix.com>;
        b=UWMxEb1RqEpI/akAFwVBOuI1OAOzqQJAZtq0EuBEQHTcWnAPFUVn8OTrCCHEl115H
         6lsifJ0ygZuPUkAIeUoLo4kx/KMaF+7sTve7oSwBptswgQojTuqwiJn73D2AWKlSwi
         v5kAE/X0NkLZA5v+RlZEwc+dMkAqua7K77ajz4ymEkovTto6gQ5x053pjppFmrOXyH
         Tnsa65j64JxYK8LZ+KLNJrDh6KYevBbVlyxVZN4Nyd3M7q++lbU9sJTR4krJXft83s
         I8JlnGcDJeLb2mjiJI8l6sP/uju9O4LgaENDhXJYLKm1l5mKJK9bPX6llF3Ve+zVgo
         oXG2BbG550cTg==
From:   Tom Parkin <tparkin@katalix.com>
To:     netdev@vger.kernel.org
Cc:     jchapman@katalix.com, Tom Parkin <tparkin@katalix.com>
Subject: [PATCH 5/6] l2tp: tweak exports for l2tp_recv_common and l2tp_ioctl
Date:   Tue, 28 Jul 2020 18:20:32 +0100
Message-Id: <20200728172033.19532-6-tparkin@katalix.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200728172033.19532-1-tparkin@katalix.com>
References: <20200728172033.19532-1-tparkin@katalix.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

All of the l2tp subsystem's exported symbols are exported using
EXPORT_SYMBOL_GPL, except for l2tp_recv_common and l2tp_ioctl.

These functions alone are not useful without the rest of the l2tp
infrastructure, so there's no practical benefit to these symbols using a
different export policy.

Change these exports to use EXPORT_SYMBOL_GPL for consistency with the
rest of l2tp.

Signed-off-by: Tom Parkin <tparkin@katalix.com>
---
 net/l2tp/l2tp_core.c | 2 +-
 net/l2tp/l2tp_ip.c   | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/l2tp/l2tp_core.c b/net/l2tp/l2tp_core.c
index 3992af139479..701fc72ad9f4 100644
--- a/net/l2tp/l2tp_core.c
+++ b/net/l2tp/l2tp_core.c
@@ -808,7 +808,7 @@ void l2tp_recv_common(struct l2tp_session *session, struct sk_buff *skb,
 	atomic_long_inc(&session->stats.rx_errors);
 	kfree_skb(skb);
 }
-EXPORT_SYMBOL(l2tp_recv_common);
+EXPORT_SYMBOL_GPL(l2tp_recv_common);
 
 /* Drop skbs from the session's reorder_q
  */
diff --git a/net/l2tp/l2tp_ip.c b/net/l2tp/l2tp_ip.c
index a159cb2bf0f4..df2a35b5714a 100644
--- a/net/l2tp/l2tp_ip.c
+++ b/net/l2tp/l2tp_ip.c
@@ -597,7 +597,7 @@ int l2tp_ioctl(struct sock *sk, int cmd, unsigned long arg)
 
 	return put_user(amount, (int __user *)arg);
 }
-EXPORT_SYMBOL(l2tp_ioctl);
+EXPORT_SYMBOL_GPL(l2tp_ioctl);
 
 static struct proto l2tp_ip_prot = {
 	.name		   = "L2TP/IP",
-- 
2.17.1


Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C8DD52287A2
	for <lists+netdev@lfdr.de>; Tue, 21 Jul 2020 19:42:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730806AbgGURmF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Jul 2020 13:42:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56140 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730344AbgGURlC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Jul 2020 13:41:02 -0400
Received: from mail.katalix.com (mail.katalix.com [IPv6:2a05:d01c:827:b342:16d0:7237:f32a:8096])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id E415BC0619DA
        for <netdev@vger.kernel.org>; Tue, 21 Jul 2020 10:41:01 -0700 (PDT)
Received: from localhost.localdomain (82-69-49-219.dsl.in-addr.zen.co.uk [82.69.49.219])
        (Authenticated sender: tom)
        by mail.katalix.com (Postfix) with ESMTPSA id 60DF993AFF;
        Tue, 21 Jul 2020 18:33:01 +0100 (BST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=katalix.com; s=mail;
        t=1595352781; bh=XN/qNjfxTSMjwxrktRZOc6D7Ebcd8anYeC2OaoTG0AY=;
        h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:From;
        z=From:=20Tom=20Parkin=20<tparkin@katalix.com>|To:=20netdev@vger.ke
         rnel.org|Cc:=20Tom=20Parkin=20<tparkin@katalix.com>|Subject:=20[PA
         TCH=2015/29]=20l2tp:=20comment=20per=20net=20spinlock=20instances|
         Date:=20Tue,=2021=20Jul=202020=2018:32:07=20+0100|Message-Id:=20<2
         0200721173221.4681-16-tparkin@katalix.com>|In-Reply-To:=20<2020072
         1173221.4681-1-tparkin@katalix.com>|References:=20<20200721173221.
         4681-1-tparkin@katalix.com>;
        b=J0QmbuybQ5iGzWPsci5y8ReiYhOWJexJa1rRa3eBLZoobRZsL91hkuWPQhRT62hWe
         jhsGswjtMsqaNqAn1cDSpqRX/QH2/7jdclHzsNUlcNAfldBWoyLthE5s8x0G6uxckX
         UbGcUwgpimNOgCQRXVifIKLcEBDql6QFPlfC43Ql+80Tw0PH5sx7tsaZi/jhFSZdHY
         nV1EAQjMGM/KaMI/KhHuYHFwFPTImFnv0rf7Krt510P+z/vS1uAbHL+aCYKH8SPggd
         OWWM9Aswu3uqNeQXyazckc99VOHWTtYyKyTSDl/Kqv45bHxjITphryQe0Zk5q2TTFR
         bTfZ4soYn7Lkw==
From:   Tom Parkin <tparkin@katalix.com>
To:     netdev@vger.kernel.org
Cc:     Tom Parkin <tparkin@katalix.com>
Subject: [PATCH 15/29] l2tp: comment per net spinlock instances
Date:   Tue, 21 Jul 2020 18:32:07 +0100
Message-Id: <20200721173221.4681-16-tparkin@katalix.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200721173221.4681-1-tparkin@katalix.com>
References: <20200721173221.4681-1-tparkin@katalix.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

checkpatch warns on spinlocks which are not commented as to their use.

Comment l2tp's per net locks accordingly.

Signed-off-by: Tom Parkin <tparkin@katalix.com>
---
 net/l2tp/l2tp_core.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/net/l2tp/l2tp_core.c b/net/l2tp/l2tp_core.c
index ef393604e66e..182386ad20e2 100644
--- a/net/l2tp/l2tp_core.c
+++ b/net/l2tp/l2tp_core.c
@@ -101,8 +101,10 @@ static struct workqueue_struct *l2tp_wq;
 static unsigned int l2tp_net_id;
 struct l2tp_net {
 	struct list_head l2tp_tunnel_list;
+	/* Lock for write access to l2tp_tunnel_list */
 	spinlock_t l2tp_tunnel_list_lock;
 	struct hlist_head l2tp_session_hlist[L2TP_HASH_SIZE_2];
+	/* Lock for write access to l2tp_session_hlist */
 	spinlock_t l2tp_session_hlist_lock;
 };
 
-- 
2.17.1


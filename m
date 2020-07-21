Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B9DBB228792
	for <lists+netdev@lfdr.de>; Tue, 21 Jul 2020 19:41:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729176AbgGURld (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Jul 2020 13:41:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56158 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728256AbgGURlE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Jul 2020 13:41:04 -0400
Received: from mail.katalix.com (mail.katalix.com [IPv6:2a05:d01c:827:b342:16d0:7237:f32a:8096])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 71B52C061794
        for <netdev@vger.kernel.org>; Tue, 21 Jul 2020 10:41:03 -0700 (PDT)
Received: from localhost.localdomain (82-69-49-219.dsl.in-addr.zen.co.uk [82.69.49.219])
        (Authenticated sender: tom)
        by mail.katalix.com (Postfix) with ESMTPSA id 045B793AFB;
        Tue, 21 Jul 2020 18:33:01 +0100 (BST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=katalix.com; s=mail;
        t=1595352781; bh=jDBa5ZnZU8KQNHFXI6z59zdjteWHIOikgi1+MgIVUD4=;
        h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:From;
        z=From:=20Tom=20Parkin=20<tparkin@katalix.com>|To:=20netdev@vger.ke
         rnel.org|Cc:=20Tom=20Parkin=20<tparkin@katalix.com>|Subject:=20[PA
         TCH=2012/29]=20l2tp:=20prefer=20seq_puts=20for=20unformatted=20out
         put|Date:=20Tue,=2021=20Jul=202020=2018:32:04=20+0100|Message-Id:=
         20<20200721173221.4681-13-tparkin@katalix.com>|In-Reply-To:=20<202
         00721173221.4681-1-tparkin@katalix.com>|References:=20<20200721173
         221.4681-1-tparkin@katalix.com>;
        b=ywloG//6YJt/CQfYcksPjF3L2xqRGBhg5AByaf+FAhFXwNfssxNZJy2r+RKy6s/YS
         SFvdcdWWqHuVs7S9Vo0kH2z0J3nJYoYbFkFx6BD5wCHba6NbmlDwBVjeq83jZA2r0G
         cBRcm50PGTUFbHe8wTcXxQT+NFZ1Kt9U7due1kV4CR6JqIeDAlNiuqiIzJCiSXy0p4
         yOeTnF6stuYfUqCEPuJtJJXorvoNW3uhFU6sZRRKcyf5e9N6pLOk0iCRWpo0rs/d/T
         zQh8Vag/QGH3DsUyAMeiDaRZTFL5Dhj1EJ9c4TRfERJkqwgzhk+lo6J6qVdXETlUTl
         qrLcNRtv3+ibg==
From:   Tom Parkin <tparkin@katalix.com>
To:     netdev@vger.kernel.org
Cc:     Tom Parkin <tparkin@katalix.com>
Subject: [PATCH 12/29] l2tp: prefer seq_puts for unformatted output
Date:   Tue, 21 Jul 2020 18:32:04 +0100
Message-Id: <20200721173221.4681-13-tparkin@katalix.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200721173221.4681-1-tparkin@katalix.com>
References: <20200721173221.4681-1-tparkin@katalix.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

checkpatch warns about use of seq_printf where seq_puts would do.

Modify l2tp_debugfs accordingly.

Signed-off-by: Tom Parkin <tparkin@katalix.com>
---
 net/l2tp/l2tp_debugfs.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/l2tp/l2tp_debugfs.c b/net/l2tp/l2tp_debugfs.c
index 70759acf2ae9..117a6697da72 100644
--- a/net/l2tp/l2tp_debugfs.c
+++ b/net/l2tp/l2tp_debugfs.c
@@ -199,7 +199,7 @@ static void l2tp_dfs_seq_session_show(struct seq_file *m, void *v)
 			seq_printf(m, "%02x%02x%02x%02x",
 				   session->cookie[4], session->cookie[5],
 				   session->cookie[6], session->cookie[7]);
-		seq_printf(m, "\n");
+		seq_puts(m, "\n");
 	}
 	if (session->peer_cookie_len) {
 		seq_printf(m, "   peer cookie %02x%02x%02x%02x",
@@ -209,7 +209,7 @@ static void l2tp_dfs_seq_session_show(struct seq_file *m, void *v)
 			seq_printf(m, "%02x%02x%02x%02x",
 				   session->peer_cookie[4], session->peer_cookie[5],
 				   session->peer_cookie[6], session->peer_cookie[7]);
-		seq_printf(m, "\n");
+		seq_puts(m, "\n");
 	}
 
 	seq_printf(m, "   %hu/%hu tx %ld/%ld/%ld rx %ld/%ld/%ld\n",
-- 
2.17.1


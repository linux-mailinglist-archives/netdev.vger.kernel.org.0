Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9BB86229D28
	for <lists+netdev@lfdr.de>; Wed, 22 Jul 2020 18:32:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730917AbgGVQcn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Jul 2020 12:32:43 -0400
Received: from mail.katalix.com ([3.9.82.81]:35458 "EHLO mail.katalix.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730189AbgGVQch (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 22 Jul 2020 12:32:37 -0400
Received: from localhost.localdomain (82-69-49-219.dsl.in-addr.zen.co.uk [82.69.49.219])
        (Authenticated sender: tom)
        by mail.katalix.com (Postfix) with ESMTPSA id 7D17293AF4;
        Wed, 22 Jul 2020 17:32:35 +0100 (BST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=katalix.com; s=mail;
        t=1595435555; bh=wyQQb5WXNgNLmM56IX/VXiPESBTDpGo+BVlPm3Fyn5M=;
        h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:From;
        z=From:=20Tom=20Parkin=20<tparkin@katalix.com>|To:=20netdev@vger.ke
         rnel.org|Cc:=20jchapman@katalix.com,=0D=0A=09Tom=20Parkin=20<tpark
         in@katalix.com>|Subject:=20[PATCH=2008/10]=20l2tp:=20prefer=20seq_
         puts=20for=20unformatted=20output|Date:=20Wed,=2022=20Jul=202020=2
         017:32:12=20+0100|Message-Id:=20<20200722163214.7920-9-tparkin@kat
         alix.com>|In-Reply-To:=20<20200722163214.7920-1-tparkin@katalix.co
         m>|References:=20<20200722163214.7920-1-tparkin@katalix.com>;
        b=qyBp60aUnVWG5e3/OWT+x7gjFxBzDukQQgTLIoE1fJGaomKvNi16zCIQgo41X8roN
         jCLdTu6/k8a6npW5uXmR20iwunIAstUtHdJA44hkVOc0qzdk+TqhFz9WZStklc8RjW
         3X+cflVv6GkvNreGwvhvgjbS5gm5in6e0+hOFpHraPXInauK6ssp9hg0XKbldlxAOB
         Eml1mGSp8xi+B0fylFv5vQRQSixZPPplr9jpSttu8TA3F1IntfcHfndm+4T2zRSpq4
         iGzaUGEO+xR7MCbSoxnzDXJWq3b5eeDY0lE5dVx1HuSQ6gRH8vG0/wgxtX6nGK/cHa
         pTPDDGff804DA==
From:   Tom Parkin <tparkin@katalix.com>
To:     netdev@vger.kernel.org
Cc:     jchapman@katalix.com, Tom Parkin <tparkin@katalix.com>
Subject: [PATCH 08/10] l2tp: prefer seq_puts for unformatted output
Date:   Wed, 22 Jul 2020 17:32:12 +0100
Message-Id: <20200722163214.7920-9-tparkin@katalix.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200722163214.7920-1-tparkin@katalix.com>
References: <20200722163214.7920-1-tparkin@katalix.com>
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
index bea89c383b7d..ebe03bbb5948 100644
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


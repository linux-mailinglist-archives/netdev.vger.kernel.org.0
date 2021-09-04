Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AA171400C86
	for <lists+netdev@lfdr.de>; Sat,  4 Sep 2021 20:30:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237391AbhIDSbn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 4 Sep 2021 14:31:43 -0400
Received: from lizzy.crudebyte.com ([91.194.90.13]:53875 "EHLO
        lizzy.crudebyte.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234085AbhIDSbm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 4 Sep 2021 14:31:42 -0400
X-Greylist: delayed 1838 seconds by postgrey-1.27 at vger.kernel.org; Sat, 04 Sep 2021 14:31:42 EDT
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=crudebyte.com; s=lizzy; h=Cc:To:Subject:Date:From:References:In-Reply-To:
        Message-Id:Content-Type:Content-Transfer-Encoding:MIME-Version:Content-ID:
        Content-Description; bh=Tut7eTe5qe1gcpJfndZBSuyDAml0NcR3QWvzUhKfSJY=; b=oYHno
        iRcK+FKCG4rE4dKoOsvOtE16e06TIYCMX1cdpwU2WFr43Uym6XV0ppIsplej2Z8glajT79hBJ3Ujg
        TnIKexznxmAoi2a4UzTPyC1B3DB/6fxLefXyH3mcD9izODJeJAQE3p63zolbw//aflxsD2UAEns4F
        /GY3x7TsVJp1CwLKIZtTJ5QJfLJEff5hhB77DjML2jbl2NkyT8ZKlUpkU3Z84Xnd5+5XApgvwB1zJ
        FMg/OsVKjxnIkbxpEMgEph4g4Y2lKg2K/mFNxCB6URN4IqZXcSmsj5HQE/TxW3f1nVebF6+ERxoce
        G5+OCVjw4XtQ9d+tHZulD4BHwprGg==;
Message-Id: <28bb651ae0349a7d57e8ddc92c1bd5e62924a912.1630770829.git.linux_oss@crudebyte.com>
In-Reply-To: <cover.1630770829.git.linux_oss@crudebyte.com>
References: <cover.1630770829.git.linux_oss@crudebyte.com>
From:   Christian Schoenebeck <linux_oss@crudebyte.com>
Date:   Sat, 4 Sep 2021 17:07:12 +0200
Subject: [PATCH 1/2] net/9p: use macro to define default msize
To:     v9fs-developer@lists.sourceforge.net
Cc:     netdev@vger.kernel.org,
        Dominique Martinet <asmadeus@codewreck.org>,
        Eric Van Hensbergen <ericvh@gmail.com>,
        Latchesar Ionkov <lucho@ionkov.net>, Greg Kurz <groug@kaod.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Use a macro to define the default value for the 'msize' option
at one place instead of using two separate integer literals.

Signed-off-by: Christian Schoenebeck <linux_oss@crudebyte.com>
---
 net/9p/client.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/net/9p/client.c b/net/9p/client.c
index b7b958f61faf..1cb255587fff 100644
--- a/net/9p/client.c
+++ b/net/9p/client.c
@@ -30,6 +30,8 @@
 #define CREATE_TRACE_POINTS
 #include <trace/events/9p.h>
 
+#define DEFAULT_MSIZE 8192
+
 /*
   * Client Option Parsing (code inspired by NFS code)
   *  - a little lazy - parse all client options
@@ -65,7 +67,7 @@ EXPORT_SYMBOL(p9_is_proto_dotu);
 
 int p9_show_client_options(struct seq_file *m, struct p9_client *clnt)
 {
-	if (clnt->msize != 8192)
+	if (clnt->msize != DEFAULT_MSIZE)
 		seq_printf(m, ",msize=%u", clnt->msize);
 	seq_printf(m, ",trans=%s", clnt->trans_mod->name);
 
@@ -139,7 +141,7 @@ static int parse_opts(char *opts, struct p9_client *clnt)
 	int ret = 0;
 
 	clnt->proto_version = p9_proto_2000L;
-	clnt->msize = 8192;
+	clnt->msize = DEFAULT_MSIZE;
 
 	if (!opts)
 		return 0;
-- 
2.20.1


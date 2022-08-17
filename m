Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 57215596913
	for <lists+netdev@lfdr.de>; Wed, 17 Aug 2022 08:02:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233305AbiHQGAS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Aug 2022 02:00:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58888 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231167AbiHQGAQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 17 Aug 2022 02:00:16 -0400
Received: from nautica.notk.org (ipv6.notk.org [IPv6:2001:41d0:1:7a93::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 44CB05F109;
        Tue, 16 Aug 2022 23:00:13 -0700 (PDT)
Received: by nautica.notk.org (Postfix, from userid 108)
        id A53F4C023; Wed, 17 Aug 2022 08:00:10 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=codewreck.org; s=2;
        t=1660716010; bh=oLawsTDNpKCPBs4WfqX5ZpLPu+XeYzk8pF8CByNEE9U=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Q8kyToz4gT4qpFyv4SW3MaYKZeh1z/1Vtbq64ZONJx+68wN1zoFXakjvp09eIAP40
         Us4DyYKA/qYnl5+XwdnCOH10431pAYXNxBFr+239yymvX98r33qK1kP0/cMP99GLUT
         11BUvfYMy7buHGPfDBxfTj891YKpKjYTJSwDbadCyhsBMsiOxnfwUbiakiKE4kez3b
         a3A5yd5xw8UYvf+RTyXGu6c0E0V7nv5pKuwirpSxrWZVlhUYMbIZMdtu0rJN7mbbBS
         3wkTdj/Vkx2r3Gayq+P9BKTcyOgzP1Kov5zyNK4Vv2lmO6L9WiKOvRjsh4eITKHYLc
         JzHDY71836eEA==
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
X-Spam-Level: 
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
Received: from odin.codewreck.org (localhost [127.0.0.1])
        by nautica.notk.org (Postfix) with ESMTPS id 9C693C009;
        Wed, 17 Aug 2022 08:00:05 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=codewreck.org; s=2;
        t=1660716009; bh=oLawsTDNpKCPBs4WfqX5ZpLPu+XeYzk8pF8CByNEE9U=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=wIPUcYFMZFE6d29/F20PcsGJHWz99spLgop5LaFfEhHJY7aVmwEWCc0xuxGK81jzX
         5gKyEZehHb67HXExYY1GozBD69Jogpu27xTayMLiwHdBRbUexiKSIXMIuNUNzUUcdy
         sW5fEPWypWT3DZt8dxfpDMTiP+CeYMqWWx7Mgm5tMwRqYDbIAQ4+Lqt88ayGCJlcM1
         tro98Mo8P4E14RTlW1BwaJxeadg83HQjfXtuTQhXO9UbVwbNFA6vctVwtv5NWtXG16
         +2JZSL1kgiqv1ZCVpFKPRe3umCXMAeDMpVA0fwBwspi1JFbucsu7sREXMv06nwXAV4
         y1c9aNpFiEgVQ==
Received: from localhost (odin.codewreck.org [local])
        by odin.codewreck.org (OpenSMTPD) with ESMTPA id a01f3657;
        Wed, 17 Aug 2022 06:00:02 +0000 (UTC)
Date:   Wed, 17 Aug 2022 14:59:47 +0900
From:   asmadeus@codewreck.org
To:     syzbot <syzbot+de52531662ebb8823b26@syzkaller.appspotmail.com>
Cc:     davem@davemloft.net, edumazet@google.com, ericvh@gmail.com,
        kuba@kernel.org, linux-kernel@vger.kernel.org,
        linux_oss@crudebyte.com, lucho@ionkov.net, netdev@vger.kernel.org,
        pabeni@redhat.com, syzkaller-bugs@googlegroups.com,
        v9fs-developer@lists.sourceforge.net
Subject: Re: [syzbot] KASAN: use-after-free Read in p9_req_put
Message-ID: <YvyD053bdbGE9xoo@codewreck.org>
References: <0000000000001c3efc05e6693f06@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <0000000000001c3efc05e6693f06@google.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

syzbot having a fresh look at 9p?

Well at least that one should be easy enough, the following (untested)
probably should work around that issue:

-----
From 433138e5d36a5b29b46b043c542e14b9dc908460 Mon Sep 17 00:00:00 2001
From: Dominique Martinet <asmadeus@codewreck.org>
Date: Wed, 17 Aug 2022 14:49:29 +0900
Subject: [PATCH] 9p: p9_client_create: use p9_client_destroy on failure

If trans was connected it's somehow possible to fail with requests in
flight that could still be accessed after free if we just free the clnt
on failure.
Just use p9_client_destroy instead that has proper safeguards.

Reported-by: syzbot+de52531662ebb8823b26@syzkaller.appspotmail.com
Signed-off-by: Dominique Martinet <asmadeus@codewreck.org>

diff --git a/net/9p/client.c b/net/9p/client.c
index 5bf4dfef0c70..da5d43848600 100644
--- a/net/9p/client.c
+++ b/net/9p/client.c
@@ -948,7 +948,7 @@ struct p9_client *p9_client_create(const char *dev_name, char *options)
 
 	err = parse_opts(options, clnt);
 	if (err < 0)
-		goto free_client;
+		goto out;
 
 	if (!clnt->trans_mod)
 		clnt->trans_mod = v9fs_get_default_trans();
@@ -957,7 +957,7 @@ struct p9_client *p9_client_create(const char *dev_name, char *options)
 		err = -EPROTONOSUPPORT;
 		p9_debug(P9_DEBUG_ERROR,
 			 "No transport defined or default transport\n");
-		goto free_client;
+		goto out;
 	}
 
 	p9_debug(P9_DEBUG_MUX, "clnt %p trans %p msize %d protocol %d\n",
@@ -965,7 +965,7 @@ struct p9_client *p9_client_create(const char *dev_name, char *options)
 
 	err = clnt->trans_mod->create(clnt, dev_name, options);
 	if (err)
-		goto put_trans;
+		goto out;
 
 	if (clnt->msize > clnt->trans_mod->maxsize) {
 		clnt->msize = clnt->trans_mod->maxsize;
@@ -979,12 +979,12 @@ struct p9_client *p9_client_create(const char *dev_name, char *options)
 		p9_debug(P9_DEBUG_ERROR,
 			 "Please specify a msize of at least 4k\n");
 		err = -EINVAL;
-		goto close_trans;
+		goto out;
 	}
 
 	err = p9_client_version(clnt);
 	if (err)
-		goto close_trans;
+		goto out;
 
 	/* P9_HDRSZ + 4 is the smallest packet header we can have that is
 	 * followed by data accessed from userspace by read
@@ -997,12 +997,8 @@ struct p9_client *p9_client_create(const char *dev_name, char *options)
 
 	return clnt;
 
-close_trans:
-	clnt->trans_mod->close(clnt);
-put_trans:
-	v9fs_put_trans(clnt->trans_mod);
-free_client:
-	kfree(clnt);
+out:
+	p9_client_destroy(clnt);
 	return ERR_PTR(err);
 }
 EXPORT_SYMBOL(p9_client_create);
-----

I'll test and submit to Linus over the next few weeks.

I had a quick look at the other new syzbot warnings and:
 - 'possible deadlock in p9_req_put' is clear enough, we can just drop
the lock before running through the cancel list and I don't think
that'll cause any problem as everything has been moved to a local list
and that lock is abused by trans fd for its local stuff. I'll also send
that after quick testing.
----
From c46435a4af7c119bd040922886ed2ea3a2a842d7 Mon Sep 17 00:00:00 2001
From: Dominique Martinet <asmadeus@codewreck.org>
Date: Wed, 17 Aug 2022 14:58:44 +0900
Subject: [PATCH] 9p: trans_fd/p9_conn_cancel: drop client lock earlier

syzbot reported a double-lock here and we no longer need this
lock after requests have been moved off to local list:
just drop the lock earlier.

Reported-by: syzbot+50f7e8d06c3768dd97f3@syzkaller.appspotmail.com
Signed-off-by: Dominique Martinet <asmadeus@codewreck.org>

diff --git a/net/9p/trans_fd.c b/net/9p/trans_fd.c
index e758978b44be..60fcc6b30b46 100644
--- a/net/9p/trans_fd.c
+++ b/net/9p/trans_fd.c
@@ -205,6 +205,8 @@ static void p9_conn_cancel(struct p9_conn *m, int err)
 		list_move(&req->req_list, &cancel_list);
 	}
 
+	spin_unlock(&m->client->lock);
+
 	list_for_each_entry_safe(req, rtmp, &cancel_list, req_list) {
 		p9_debug(P9_DEBUG_ERROR, "call back req %p\n", req);
 		list_del(&req->req_list);
@@ -212,7 +214,6 @@ static void p9_conn_cancel(struct p9_conn *m, int err)
 			req->t_err = err;
 		p9_client_cb(m->client, req, REQ_STATUS_ERROR);
 	}
-	spin_unlock(&m->client->lock);
 }
 
 static __poll_t
----

 - but I don't get the two 'inconsistent lock state', the hint says it's
possibly an interrupt while the lock was held but that doesn't seem to
be the case from the stack trace (unless we leaked the lock, at which
point anything goes)
I'd need to take time to look at it, feel free to beat me to these.

--
Dominique
